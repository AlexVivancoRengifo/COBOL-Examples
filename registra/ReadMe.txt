*
* (These comments are also contained in the program
*   source code)
*
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
*
*  2. PRINT-REGISTRATIONS.COB
*    The print program.  It reads the data from the 
*    COBOL-Registrations file and prints it out using the 
*    PRINTREG PowerFORM descriptor.
*    It is a COBOL85 program, written using the Programming 
*    STAFF editor but compiled as part of the PowerCOBOL
*    project.
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
* TECHNIQUES DEMONSTRATED IN PRINT-REGISTRATIONS.COB:
*
*    - Printing fixed and floating partitions
*	  (See the various WRITE statements)
*    - Splitting text across several lines
*	  (See W100-WORD-WRAP)
*    - Right aligning text
*         (See B100-RIGHT-JUSTIFY)
*    - Printing variable length lists
*         (See handling of BUYING-FACTOR-FIELDS in
*          M100-MOVE-DATA)
*
*
* NOTES ON USING COBOL-REGISTRATIONS.WIN
*
*  	When you compile the sheet some errors are displayed:
*
*	- Certain data items are "NOT FOUND, UNDEFINED OR
*        DEFINED IN A COPY STATEMENT".  This is because
*        the PowerCOBOL preprocessor does not look in the 
*        Registration-Record.CBL file.  The errors are
*        informational and do not affect the compiled code.
*
*       - There are some in-line PERFORM statements in the code
*        that do not contain a statement.  They use the UNTIL
*        clause to position a pointer and work as expected.
*        The errors are informational.
*
*
