/* xgetfocus.c - link against libX11 */
#include <X11/Xlib.h>
#include <stdio.h>

int main(int argc, char *argv[])
{
Display *display;
Window focus;
int revert;

display = XOpenDisplay(NULL);
XGetInputFocus(display, &focus, &revert);
printf("%d\n", (unsigned)focus);

return 0;
}
