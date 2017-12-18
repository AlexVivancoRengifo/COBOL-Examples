@POWER POWSHEET COBOLREG WORKING
  01  REPORT-REQUEST GLOBAL.
	     COPY "REPORT-REQUEST.CBL".

  01  REG-ID-STATUS  GLOBAL PIC 99 COMP.
     88	REG-ID-NO-ERROR-DISPLAYED      VALUE 0.
     88  REG-ID-ST-ERROR-DISPLAYED      VALUE 1.
     88  REG-ID-ST-NON-NUMERIC 		   VALUE 2.
		88	REG-ID-EN-ERROR-DISPLAYED	   VALUE 3.
		88  REG-ID-EN-NON-NUMERIC          VALUE 4.
 
@POWER POWSHEET COBOLREG CONSTANT
 COPY "Registration-Constants.CBL".
@POWER POWSHEET COBOLREG PROCEDURE
 IDENTIFICATION DIVISION.
 PROGRAM-ID. "INVOKE-PRINT" COMMON.

* Code to do final checks on input data and
*  invoke the report program (Print-Registrations)

 ENVIRONMENT DIVISION.
 DATA DIVISION.
 WORKING-STORAGE SECTION.
* Record Definition for REPORT-REQUEST passed to the 
*  print program is declared as GLOBAL in the 
*  WORKING-STORAGE of the COBOLREG sheet.

 01 WK-AREA.
	  03  WK-NUM				PIC 9(9).
   03    					PIC X(247).

 01 WK-POINTER				PIC 9(4) COMP.
 01 WK-POINTER-2				PIC 9(4) COMP.
 

 01 ERROR-MESSAGE-TEXTS.
   03 PIC X(128) VALUE "Invalid key error. Check ""Start at"" val
-                      "ue.".
   03 PIC X(128) VALUE "System error - invalid request code.".
   03 PIC X(128) VALUE "No records found in registration file equ
-                      "al to, or greater than, ""Start at"" valu
-                      "e.".
   03 PIC X(128) VALUE "No records found in specified range.".
   03 PIC X(128) VALUE "Failed to open registration file.".
   03 PIC X(128) VALUE "Unable to call print routine. If another 
-                      "report is printing, try clicking Print w
-                      "hen that report is finished.".
	  03 PIC X(128) VALUE """Start at"" value is greater than ""End
-                      " at"" value.".

 01 ERROR-MESSAGE-TABLE REDEFINES ERROR-MESSAGE-TEXTS.
   03 ERROR-MESSAGE OCCURS 7 PIC X(128).

 01 MB-MESSAGE				PIC X(256).

 01 ON-EXCEPTION-TITLE		PIC X(60) VALUE
						   "Registration Report Error".

 01 ON-EXCEPTION-STYLE		PIC S9(4) COMP-5.


 PROCEDURE DIVISION.

 A000-MAIN.

* Check if error messages are still displayed and switch them off
		IF REG-ID-ST-ERROR-DISPLAYED
			MOVE POW-OFF TO POW-VISIBLE OF TX-RGID-S-ERR
			SET REG-ID-NO-ERROR-DISPLAYED TO TRUE
		END-IF
		IF REG-ID-EN-ERROR-DISPLAYED
			MOVE POW-OFF TO POW-VISIBLE OF TX-RGID-E-ERR
			SET REG-ID-NO-ERROR-DISPLAYED TO TRUE
		END-IF

		SET RQ-REQUEST-OK TO TRUE

* Check the report order to be used and set up the call parameters.
		EVALUATE TRUE 

		  WHEN RQ-FIRST-NAME
			MOVE POW-TEXT OF ED-FRSTNM-STRT
			  TO RQ-START-NAME
			MOVE POW-TEXT OF ED-FRSTNM-END
			  TO RQ-END-NAME

*        Cross validate the input values
*         (Print program interprets spaces in end value to be
*           end-of-file)
			IF RQ-START-NAME > RQ-END-NAME
				AND
			   RQ-END-NAME NOT = SPACE
			  SET RQ-START-GREATER-THAN-END TO TRUE
			  CALL SETFOCUS OF ED-FRSTNM-STRT
			END-IF

		  WHEN RQ-LAST-NAME
         MOVE POW-TEXT OF ED-LASTNM-STRT
			  TO RQ-START-NAME
			MOVE POW-TEXT OF ED-LASTNM-END
			  TO RQ-END-NAME

*        Cross validate the input values
*         (Print program interprets spaces in end value to be
*           end-of-file)
			IF RQ-START-NAME > RQ-END-NAME
				AND
			   RQ-END-NAME NOT = SPACE
			  SET RQ-START-GREATER-THAN-END TO TRUE
			  CALL SETFOCUS OF ED-LASTNM-STRT
			END-IF

		  WHEN RQ-REGISTRATION-ID
			MOVE POW-TEXT OF ED-REGID-STRT TO WK-AREA

*       Print program interprets spaces as meaning start-of-
* 	    file or end-of-file.

			IF WK-AREA = SPACE
			  MOVE SPACE TO RQ-START-REGISTRATION-IDX
			ELSE
			  PERFORM R100-RIGHT-ALIGN
			  MOVE WK-NUM TO RQ-START-REGISTRATION-ID
			END-IF
			MOVE POW-TEXT OF ED-REGID-END TO WK-AREA
			IF WK-AREA = SPACE
			  MOVE SPACE TO RQ-END-REGISTRATION-IDX
			ELSE
			  PERFORM R100-RIGHT-ALIGN
			  MOVE WK-NUM TO RQ-END-REGISTRATION-ID
			END-IF

*        Cross validate the input values
*         (Print program interprets spaces in end value to be
*           end-of-file)
			IF RQ-START-REGISTRATION-ID > RQ-END-REGISTRATION-ID
				AND
			   RQ-END-REGISTRATION-IDX NOT = SPACE
			  SET RQ-START-GREATER-THAN-END TO TRUE
			  CALL SETFOCUS OF ED-REGID-STRT
			END-IF

		  WHEN RQ-SERIAL-NUMBER
			MOVE POW-TEXT OF ED-SERNO-STRT
			  TO RQ-START-SERIAL-NO
			MOVE POW-TEXT OF ED-SERNO-END
			  TO RQ-END-SERIAL-NO

*        Cross validate the input values
*         (Print program interprets spaces in end value to be
*           end-of-file)
			IF RQ-START-SERIAL-NO > RQ-END-SERIAL-NO
			    AND
            RQ-END-SERIAL-NO NOT = SPACE
			  SET RQ-START-GREATER-THAN-END TO TRUE
			  CALL SETFOCUS OF ED-SERNO-STRT
			END-IF

		END-EVALUATE

		IF RQ-REQUEST-OK
		  CALL "Print-Registrations" USING REPORT-REQUEST
			ON EXCEPTION SET RQ-UNABLE-TO-CALL-PRINT-PROG TO TRUE
		  END-CALL
		END-IF

*  Check return code and display message
		IF NOT RQ-REQUEST-OK
		  MOVE ERROR-MESSAGE (RQ-RETURN-CODE) TO MB-MESSAGE
		  PERFORM M100-MESSAGE-DISPLAY
		END-IF

		EXIT PROGRAM
		.

  M100-MESSAGE-DISPLAY.
* Set up the message box style
		ADD	POW-DMOK 
         POW-DMICONEXCLAMATION 
         POW-DMDEFBUTTON1
		  GIVING ON-EXCEPTION-STYLE
		END-ADD
		CALL DISPLAYMESSAGE OF COBOLREG USING
				MB-MESSAGE
				ON-EXCEPTION-TITLE
				ON-EXCEPTION-STYLE
		END-CALL
		.

	 R100-RIGHT-ALIGN.
* Find rightmost non-space character
* CHANGE event code ensures the characters are a continuous
*  left-aligned string of numeric digits
		PERFORM VARYING WK-POINTER 
				   FROM CONST-REG-ID-LENGTH
					 BY -1
				  UNTIL WK-AREA (WK-POINTER:1) NOT = SPACE
				     OR WK-POINTER = 1
		END-PERFORM

* Use part of WK-AREA as a temporary store for right alignment
*  a) Move out of work area
		MOVE WK-AREA (1:WK-POINTER) 
       TO WK-AREA (CONST-REG-ID-LENGTH + 1:WK-POINTER)
*  b) Move back in right-aligned
		MOVE WK-AREA (CONST-REG-ID-LENGTH + 1:WK-POINTER) 
       TO WK-AREA (CONST-REG-ID-LENGTH + 1 - WK-POINTER:WK-POINTER)

* Zero fill
		SUBTRACT WK-POINTER FROM CONST-REG-ID-LENGTH GIVING WK-POINTER
		PERFORM VARYING WK-POINTER-2
				   FROM 1
					 BY 1
				  UNTIL WK-POINTER-2 > WK-POINTER
		  MOVE "0" TO WK-AREA (WK-POINTER-2:1)
		END-PERFORM
		.
	  
  END PROGRAM "INVOKE-PRINT".
@POWER POWSHEET COBOLREG OPENED
 ENVIRONMENT DIVISION.
 DATA        DIVISION.
 PROCEDURE   DIVISION.
		SET RQ-LAST-NAME TO TRUE
		CALL SETFOCUS OF ED-LASTNM-STRT
		EXIT PROGRAM
		.
@POWER POWRDBTN RADIO-FRSTNAM CLICK
 ENVIRONMENT DIVISION.
 DATA        DIVISION.
 PROCEDURE   DIVISION.

* NOTE: The code below makes it easier to use a mouse
*  than the keyboard as putting focus on the first
*  range field when the radio button is selected makes
*  it difficult to select the radio buttons using the
*  keyboard.

* Enable the first name range edit fields
		MOVE POW-ON TO POW-ENABLE OF ED-FRSTNM-STRT
					   POW-ENABLE OF ED-FRSTNM-END

* Set the focus on the first range field.
		CALL SETFOCUS OF ED-FRSTNM-STRT

* Set the report order type
     SET RQ-FIRST-NAME TO TRUE

* Disable the other active edit fields
		IF POW-ENABLE OF ED-LASTNM-STRT = POW-ON
			MOVE POW-OFF TO POW-ENABLE OF ED-LASTNM-STRT
						    POW-ENABLE OF ED-LASTNM-END
		END-IF
		IF POW-ENABLE OF ED-REGID-STRT = POW-ON
			MOVE POW-OFF TO POW-ENABLE OF ED-REGID-STRT
						    POW-ENABLE OF ED-REGID-END
		END-IF
		IF POW-ENABLE OF ED-SERNO-STRT = POW-ON
			MOVE POW-OFF TO POW-ENABLE OF ED-SERNO-STRT
						    POW-ENABLE OF ED-SERNO-END
		END-IF

@POWER POWRDBTN RADIO-LASTNAM CLICK
 ENVIRONMENT DIVISION.
 DATA        DIVISION.
 PROCEDURE   DIVISION.

* Enable the last name range edit fields
		MOVE POW-ON TO POW-ENABLE OF ED-LASTNM-STRT
					   POW-ENABLE OF ED-LASTNM-END

* Set the focus on the first range field.
		CALL SETFOCUS OF ED-LASTNM-STRT

* Set the report order type
     SET RQ-LAST-NAME TO TRUE

* Disable the other active edit fields
		IF POW-ENABLE OF ED-FRSTNM-STRT = POW-ON
			MOVE POW-OFF TO POW-ENABLE OF ED-FRSTNM-STRT
						    POW-ENABLE OF ED-FRSTNM-END
		END-IF
		IF POW-ENABLE OF ED-REGID-STRT = POW-ON
			MOVE POW-OFF TO POW-ENABLE OF ED-REGID-STRT
						    POW-ENABLE OF ED-REGID-END
		END-IF
		IF POW-ENABLE OF ED-SERNO-STRT = POW-ON
			MOVE POW-OFF TO POW-ENABLE OF ED-SERNO-STRT
						    POW-ENABLE OF ED-SERNO-END
		END-IF
@POWER POWRDBTN RADIO-REGNO CLICK
 ENVIRONMENT DIVISION.
 DATA        DIVISION.
 PROCEDURE   DIVISION.

* Enable the registration number range edit fields
		MOVE POW-ON TO POW-ENABLE OF ED-REGID-STRT
					   POW-ENABLE OF ED-REGID-END

* Set the focus on the first range field.
		CALL SETFOCUS OF ED-REGID-STRT

* Set the report order type
     SET RQ-REGISTRATION-ID TO TRUE

* Disable the other active edit fields
		IF POW-ENABLE OF ED-FRSTNM-STRT = POW-ON
			MOVE POW-OFF TO POW-ENABLE OF ED-FRSTNM-STRT
						    POW-ENABLE OF ED-FRSTNM-END
		END-IF
		IF POW-ENABLE OF ED-LASTNM-STRT = POW-ON
			MOVE POW-OFF TO POW-ENABLE OF ED-LASTNM-STRT
						    POW-ENABLE OF ED-LASTNM-END
		END-IF
		IF POW-ENABLE OF ED-SERNO-STRT = POW-ON
			MOVE POW-OFF TO POW-ENABLE OF ED-SERNO-STRT
						    POW-ENABLE OF ED-SERNO-END
		END-IF
@POWER POWRDBTN RADIO-SERNO CLICK
 ENVIRONMENT DIVISION.
 DATA        DIVISION.
 PROCEDURE   DIVISION.

* Enable the serial number range edit fields
		MOVE POW-ON TO POW-ENABLE OF ED-SERNO-STRT
					   POW-ENABLE OF ED-SERNO-END

* Set the focus on the first range field.
		CALL SETFOCUS OF ED-SERNO-STRT

* Set the report order type
     SET RQ-SERIAL-NUMBER TO TRUE

* Disable the other active edit fields
		IF POW-ENABLE OF ED-LASTNM-STRT = POW-ON
			MOVE POW-OFF TO POW-ENABLE OF ED-LASTNM-STRT
						    POW-ENABLE OF ED-LASTNM-END
		END-IF
		IF POW-ENABLE OF ED-REGID-STRT = POW-ON
			MOVE POW-OFF TO POW-ENABLE OF ED-REGID-STRT
						    POW-ENABLE OF ED-REGID-END
		END-IF
		IF POW-ENABLE OF ED-FRSTNM-STRT = POW-ON
			MOVE POW-OFF TO POW-ENABLE OF ED-FRSTNM-STRT
						    POW-ENABLE OF ED-FRSTNM-END
		END-IF
@POWER POWPSBTN BUTTON-CANCEL CLICK
 ENVIRONMENT DIVISION.
 DATA        DIVISION.
 PROCEDURE   DIVISION.

		CALL CLOSESHEET OF COBOLREG
		EXIT PROGRAM
		.
@POWER POWPSBTN BUTTON-PRINT CLICK
 ENVIRONMENT DIVISION.
 DATA        DIVISION.
 PROCEDURE   DIVISION.

     CALL CONST-INVOKE-PRINT-PROG
		EXIT PROGRAM
		.

@POWER POWEDIT ED-FRSTNM-STRT CHANGE
 ENVIRONMENT DIVISION.
 DATA        DIVISION.
 PROCEDURE   DIVISION.
			
		
@POWER POWEDIT ED-FRSTNM-STRT RETURN
 ENVIRONMENT DIVISION.
 DATA        DIVISION.
 PROCEDURE   DIVISION.

     CALL CONST-INVOKE-PRINT-PROG
		EXIT PROGRAM
		.
@POWER POWEDIT ED-FRSTNM-END RETURN
 ENVIRONMENT DIVISION.
 DATA        DIVISION.
 PROCEDURE   DIVISION.

     CALL CONST-INVOKE-PRINT-PROG
		EXIT PROGRAM
		.
@POWER POWEDIT ED-LASTNM-STRT RETURN
 ENVIRONMENT DIVISION.
 DATA        DIVISION.
 PROCEDURE   DIVISION.

     CALL CONST-INVOKE-PRINT-PROG
		EXIT PROGRAM
		.
@POWER POWEDIT ED-LASTNM-END RETURN
 ENVIRONMENT DIVISION.
 DATA        DIVISION.
 PROCEDURE   DIVISION.

     CALL CONST-INVOKE-PRINT-PROG
		EXIT PROGRAM
		.
@POWER POWEDIT ED-REGID-STRT CHANGE
 ENVIRONMENT DIVISION.
 DATA        DIVISION.
	WORKING-STORAGE SECTION.
 01  WK-AREA 				PIC X(256).
 01  STORE-AREA				PIC X(9).
 01  WK-POINTER				PIC 9(4) COMP.
 01  CALL-COUNT				PIC 99.

 PROCEDURE   DIVISION.

 A000-MAIN.

* Check for error message and hide it
		IF REG-ID-ST-ERROR-DISPLAYED
		  ADD 1 TO CALL-COUNT

*      When POW-TEXT is updated another call to this 
*      event is generated so wait for second change 
*      event to hide message
		  IF CALL-COUNT > 1
			MOVE POW-OFF TO POW-VISIBLE OF TX-RGID-S-ERR
			SET REG-ID-NO-ERROR-DISPLAYED TO TRUE

		  END-IF
		END-IF

* Use WK-AREA to manipulate the input string
		MOVE POW-TEXT OF ED-REGID-STRT TO WK-AREA
		MOVE 1 TO WK-POINTER

* Check data is numeric
		PERFORM B100-CHECK-NUMERIC
			UNTIL REG-ID-ST-NON-NUMERIC
			   OR WK-POINTER > CONST-REG-ID-LENGTH
		IF REG-ID-ST-NON-NUMERIC

*        Display a "tooltip" style error warning
			MOVE POW-ON TO POW-ENABLE OF TX-RGID-S-ERR
			MOVE POW-ON TO POW-VISIBLE OF TX-RGID-S-ERR
			SET REG-ID-ST-ERROR-DISPLAYED TO TRUE
			MOVE 0 TO CALL-COUNT

*        Restore the number to the previous good value
			MOVE STORE-AREA TO WK-AREA(1:CONST-REG-ID-LENGTH)
			MOVE WK-AREA TO POW-TEXT OF ED-REGID-STRT

*        NOTE: The above move to POW-TEXT generates another 
*          call to this procedure.  Only update POW-TEXT in
*          a CHANGE event within a conditional piece of code,
*		  otherwise an infinite loop results.

		ELSE

*        Store a good value
			MOVE WK-AREA (1:CONST-REG-ID-LENGTH) TO STORE-AREA

		END-IF

	    EXIT PROGRAM
		.
	
 B100-CHECK-NUMERIC.

*  Note - need to allow for field being all spaces, or space filled
*         so first comparison accepts spaces.
		IF  (WK-AREA (WK-POINTER:1) < CONST-ASCII-ZERO
				AND
			 WK-AREA (WK-POINTER:1) NOT = SPACE)
				OR
		     WK-AREA (WK-POINTER:1) > CONST-ASCII-NINE
			SET REG-ID-ST-NON-NUMERIC TO TRUE
		END-IF

* Check for spaces embedded between numbers
		IF WK-AREA (WK-POINTER:1) = SPACE
			AND
		   WK-AREA (WK-POINTER + 1:1) NOT = SPACE
			SET REG-ID-ST-NON-NUMERIC TO TRUE
		END-IF
		ADD 1 TO WK-POINTER
		.

@POWER POWEDIT ED-REGID-STRT EDIT
 ENVIRONMENT DIVISION.
 DATA        DIVISION.
 PROCEDURE   DIVISION.

* Note: This event is only invoked if it is checked in the object's
*  STYLE, EVENT dialog box.

		IF REG-ID-EN-ERROR-DISPLAYED
			MOVE POW-OFF TO POW-VISIBLE OF TX-RGID-E-ERR
			SET REG-ID-NO-ERROR-DISPLAYED TO TRUE
		END-IF
		EXIT PROGRAM
		.
@POWER POWEDIT ED-REGID-STRT RETURN
 ENVIRONMENT DIVISION.
 DATA        DIVISION.
 PROCEDURE   DIVISION.

     CALL CONST-INVOKE-PRINT-PROG
		EXIT PROGRAM
		.
@POWER POWEDIT ED-REGID-END CHANGE
 ENVIRONMENT DIVISION.
 DATA        DIVISION.
	WORKING-STORAGE SECTION.
 01  WK-AREA 				PIC X(256).
 01  STORE-AREA				PIC X(9).
 01  WK-POINTER				PIC 9(4) COMP.
 01  CALL-COUNT				PIC 99.

 PROCEDURE   DIVISION.

 A000-MAIN.

* Check for error message and hide it
		IF REG-ID-EN-ERROR-DISPLAYED
		  ADD 1 TO CALL-COUNT

*      When POW-TEXT is updated another call to this 
*      event is generated so wait for second change 
*      event to hide message
		  IF CALL-COUNT > 1
			MOVE POW-OFF TO POW-VISIBLE OF TX-RGID-E-ERR
			SET REG-ID-NO-ERROR-DISPLAYED TO TRUE

		  END-IF
		END-IF

* Use WK-AREA to manipulate the input string
		MOVE POW-TEXT OF ED-REGID-END TO WK-AREA
		MOVE 1 TO WK-POINTER

* Check data is numeric
 	PERFORM B100-CHECK-NUMERIC
			UNTIL REG-ID-EN-NON-NUMERIC
			   OR WK-POINTER > CONST-REG-ID-LENGTH
		IF REG-ID-EN-NON-NUMERIC

*        Display a "tooltip" style error warning
			MOVE POW-ON TO POW-ENABLE OF TX-RGID-E-ERR
			MOVE POW-ON TO POW-VISIBLE OF TX-RGID-E-ERR
			SET REG-ID-EN-ERROR-DISPLAYED TO TRUE
			MOVE 0 TO CALL-COUNT

*        Restore the number to the previous good value
			MOVE STORE-AREA TO WK-AREA(1:CONST-REG-ID-LENGTH)
			MOVE WK-AREA TO POW-TEXT OF ED-REGID-END
*        NOTE: The above move to POW-TEXT generates another 
*          call to this procedure.  Only update POW-TEXT in
*          a CHANGE event within a conditional piece of code,
*		  otherwise an infinite loop results.

		ELSE

*        Store a good value
			MOVE WK-AREA (1:CONST-REG-ID-LENGTH) TO STORE-AREA

		END-IF

		EXIT PROGRAM
		.
	
 B100-CHECK-NUMERIC.

*  Note - need to allow for field being all spaces, or space filled
*         so first comparison accepts spaces.
		IF  (WK-AREA (WK-POINTER:1) < CONST-ASCII-ZERO
				AND
			 WK-AREA (WK-POINTER:1) NOT = SPACE)
				OR
		     WK-AREA (WK-POINTER:1) > CONST-ASCII-NINE
			SET REG-ID-EN-NON-NUMERIC TO TRUE
		END-IF

* Check for spaces embedded between numbers
		IF WK-AREA (WK-POINTER:1) = SPACE
			AND
		   WK-AREA (WK-POINTER + 1:1) NOT = SPACE
			SET REG-ID-EN-NON-NUMERIC TO TRUE
		END-IF
		ADD 1 TO WK-POINTER
		.

@POWER POWEDIT ED-REGID-END EDIT
 ENVIRONMENT DIVISION.
 DATA        DIVISION.
 PROCEDURE   DIVISION.

* Note: This event is only invoked if it is checked in the object's
*  STYLE, EVENT dialog box.

		IF REG-ID-ST-ERROR-DISPLAYED
			MOVE POW-OFF TO POW-VISIBLE OF TX-RGID-S-ERR
			SET REG-ID-NO-ERROR-DISPLAYED TO TRUE
		END-IF
		EXIT PROGRAM
		.
@POWER POWEDIT ED-REGID-END RETURN
 ENVIRONMENT DIVISION.
 DATA        DIVISION.
 PROCEDURE   DIVISION.

     CALL CONST-INVOKE-PRINT-PROG
		EXIT PROGRAM
		.
@POWER POWEDIT ED-SERNO-STRT RETURN
 ENVIRONMENT DIVISION.
 DATA        DIVISION.
 PROCEDURE   DIVISION.

     CALL CONST-INVOKE-PRINT-PROG
		EXIT PROGRAM
		.
@POWER POWEDIT ED-SERNO-END RETURN
 ENVIRONMENT DIVISION.
 DATA        DIVISION.
 PROCEDURE   DIVISION.

     CALL CONST-INVOKE-PRINT-PROG
		EXIT PROGRAM
		.
@POWER POWLABEL DEMO-DESCRIP CLICK
 ENVIRONMENT DIVISION.
 DATA        DIVISION.
 PROCEDURE   DIVISION.

* The COBOL-Registrations demo program shows how to take 
*  advantage of PowerFORM working with PowerCOBOL.  It is 
*  a full application taking data from a file of (COBOL) 
*  customer registrations and printing specified ranges 
*  of data, along with a summary report.
*
* There are two parts to the demo:
*
*  1. COBOL-REGISTRATIONS.WIN
*    The PowerCOBOL sheet. This accepts the desired range 
*    from the user and invokes the print program.
*    See below for a description of features.
*
*  2. PRINT-REGISTRATIONS.COB
*    The print program.  It reads the data from the 
*    COBOL-Registrations file and prints it out using the 
*    PRINTREG PowerFORM descriptor.
*    It is a COBOL85 program, written using the Programming 
*    STAFF editor but compiled as part of the PowerCOBOL
*    project.
*    See the source for more information about the techniques 
*    it demonstrates.
*
*
* TECHNIQUES DEMONSTRATED IN COBOL-REGISTRATIONS.WIN:
*
*	- Use of a COMMON sub-program to service the same function
*      from many different events.
*         (See the INVOKE-PRINT program in the sheet's 
*          PROCEDURE code)
*	- Enabling and disabling edit items according to radio
*      button selection.
*	     (See the CLICK code for the radio button items)
*    - Accepting only numeric input to an edit item.  
*         (See the CHANGE code for the REGISTRATION ID range
*          edit fields)
*    - Right aligning numeric field input
*         (See the INVOKE-PRINT program in the sheet's 
*          PROCEDURE code)
*    - Displaying a "tooltip" style error message.
*         (See the CHANGE event and the EDIT event code for 
*          the REGISTRATION ID range edit items)
*	- Verifying data across fields.
*         (See the INVOKE-PRINT program in the sheet's 
*          PROCEDURE code)
*    - Invoking the default action (Print) on a click of the
*      button or the Return key.
*         (See the RETURN events for all the range edit items)
*    - Limiting the length of an edit item.
*         (See the ExStyle dialog box from the Style dialog box
*          for any of the range edit items)
*    - Using a Message Box to display error messages.
*         (See the INVOKE-PRINT program in the sheet's 
*          PROCEDURE code)
*    - Using GLOBAL data to be accessible to all event code.
*         (See the sheet's WORKING-STORAGE code)
*
*
*	NOTES ON USING COBOL-REGISTRATIONS.WIN
*
*  	When you compile the sheet some errors are displayed:
*
*	  -	Certain data items are "NOT FOUND, UNDEFINED OR
*        DEFINED IN A COPY STATEMENT".  This is because
*        the PowerCOBOL preprocessor does not look in the 
*        Registration-Record.CBL file.  The errors are
*        informational and do not affect the compiled code.
*
*      - An in-line PERFORM statement in the sheet procedure
*        code doesn't contain a statement.  It uses the UNTIL
*        clause to position a pointer and works as expected.
*        The error is informational.
* 
*    Coding conventions:
* 
*	  - Common data items used, or likely to be used by 
*        several procedures, are defined in the sheet's
*        WORKING and CONSTANT code areas. 
*        All items in the CONSTANT code area are prefixed 
*        with the string "CONST-".  
*        There are only two records in the WORKING code area
*        and, as one of these is shared with the print program,
*        they are not prefixed with a WORKING prefix. They have
*        the prefixes "RQ-" (for Report Request) and "REG-ID-"
*        (for Registration ID statuses).
*
*      - The prefix "WK-" is used for local work areas whose
*        contents are expected to change on each invocation of
*        a procedure.

