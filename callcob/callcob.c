#include <windows.h>
void JMPCINT2();
void JMPCINT3();
long WINAPI COB1 (long *);
long WINAPI COB2 (char *);
int WINAPI WinMain(HINSTANCE hInst,HINSTANCE hPrev,LPSTR lpCmd,int nCmd)
{ 
	int n100 = 100;
	char cABCDE [5] = {"ABCDE"};
	char cString [20];

	MessageBoxEx (NULL, "Start COBOL", "CallCOB", MB_APPLMODAL,  LANG_ENGLISH);
	
	JMPCINT2();
	COB1(&n100);
	itoa (n100, cString, 10);
	MessageBoxEx (NULL, cString, "Check Data", MB_APPLMODAL,  LANG_ENGLISH);
	COB2(cABCDE);
	MessageBoxEx (NULL, cABCDE, "Check Data", MB_APPLMODAL,  LANG_ENGLISH);
	JMPCINT3();

	MessageBoxEx (NULL, "End COBOL", "CallCOB", MB_APPLMODAL,  LANG_ENGLISH);

	return (0);
}
