Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0E0x6sI004537
	for <video4linux-list@redhat.com>; Tue, 13 Jan 2009 19:59:06 -0500
Received: from web95209.mail.in2.yahoo.com (web95209.mail.in2.yahoo.com
	[203.104.18.185])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n0E0wjvH028513
	for <video4linux-list@redhat.com>; Tue, 13 Jan 2009 19:58:46 -0500
Date: Wed, 14 Jan 2009 06:28:44 +0530 (IST)
From: niamathullah sharief <shariefbe@yahoo.co.in>
To: Michael Williamson <michael_h_williamson@yahoo.com>,
	Kernel newbies <kernelnewbies@nl.linux.org>,
	video4linux list <video4linux-list@redhat.com>
In-Reply-To: <878642.52030.qm@web65512.mail.ac4.yahoo.com>
MIME-Version: 1.0
Message-ID: <42835.5687.qm@web95209.mail.in2.yahoo.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: 
Subject: Re: About xawtv
Reply-To: shariefbe@yahoo.co.in
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

I think i =C2=A0want header file..see the below errors when i used to compi=
le it...sharief@sharief-desktop:~/Desktop/video drivers$ gcc vgrabx.c -Wall=
 -lX11 -o vgrabx
vgrabx.c:29:22: error: X11/Xlib.h: No such file or directory
vgrabx.c:30:23: error: X11/Xutil.h: No such file or directory
vgrabx.c:34: error: expected =E2=80=98=3D=E2=80=99, =E2=80=98,=E2=80=99, =
=E2=80=98;=E2=80=99, =E2=80=98asm=E2=80=99 or =E2=80=98__attribute__=E2=80=
=99 before =E2=80=98*=E2=80=99 token
vgrabx.c:36: error: expected =E2=80=98=3D=E2=80=99, =E2=80=98,=E2=80=99, =
=E2=80=98;=E2=80=99, =E2=80=98asm=E2=80=99 or =E2=80=98__attribute__=E2=80=
=99 before =E2=80=98X_color=E2=80=99
vgrabx.c:38: error: expected =E2=80=98=3D=E2=80=99, =E2=80=98,=E2=80=99, =
=E2=80=98;=E2=80=99, =E2=80=98asm=E2=80=99 or =E2=80=98__attribute__=E2=80=
=99 before =E2=80=98X_window=E2=80=99
vgrabx.c:39: error: expected =E2=80=98=3D=E2=80=99, =E2=80=98,=E2=80=99, =
=E2=80=98;=E2=80=99, =E2=80=98asm=E2=80=99 or =E2=80=98__attribute__=E2=80=
=99 before =E2=80=98X_image=E2=80=99
vgrabx.c: In function =E2=80=98main=E2=80=99:
vgrabx.c:70: error: =E2=80=98X_display=E2=80=99 undeclared (first use in th=
is function)
vgrabx.c:70: error: (Each undeclared identifier is reported only once
vgrabx.c:70: error: for each function it appears in.)
vgrabx.c:70: warning: implicit declaration of function =E2=80=98XOpenDispla=
y=E2=80=99
vgrabx.c:72: warning: implicit declaration of function =E2=80=98XDefaultScr=
een=E2=80=99
vgrabx.c:77: warning: implicit declaration of function =E2=80=98XAllocNamed=
Color=E2=80=99
vgrabx.c:77: warning: implicit declaration of function =E2=80=98DefaultColo=
rmap=E2=80=99
vgrabx.c:78: error: =E2=80=98X_color=E2=80=99 undeclared (first use in this=
 function)
vgrabx.c:78: error: =E2=80=98X_color2=E2=80=99 undeclared (first use in thi=
s function)
vgrabx.c:98: error: =E2=80=98X_image=E2=80=99 undeclared (first use in this=
 function)
vgrabx.c:101: error: =E2=80=98ZPixmap=E2=80=99 undeclared (first use in thi=
s function)
vgrabx.c:103: warning: implicit declaration of function =E2=80=98XImageByte=
Order=E2=80=99
vgrabx.c:104: warning: implicit declaration of function =E2=80=98XBitmapUni=
t=E2=80=99
vgrabx.c:105: warning: implicit declaration of function =E2=80=98XBitmapBit=
Order=E2=80=99
vgrabx.c:106: warning: implicit declaration of function =E2=80=98XBitmapPad=
=E2=80=99
vgrabx.c:107: warning: implicit declaration of function =E2=80=98XDefaultDe=
pth=E2=80=99
vgrabx.c:116: warning: implicit declaration of function =E2=80=98XInitImage=
=E2=80=99
vgrabx.c:118: error: =E2=80=98X_window=E2=80=99 undeclared (first use in th=
is function)
vgrabx.c:118: warning: implicit declaration of function =E2=80=98XCreateSim=
pleWindow=E2=80=99
vgrabx.c:118: warning: implicit declaration of function =E2=80=98XDefaultRo=
otWindow=E2=80=99
vgrabx.c:120: warning: implicit declaration of function =E2=80=98XMapWindow=
=E2=80=99
vgrabx.c:459: warning: implicit declaration of function =E2=80=98XPutImage=
=E2=80=99
vgrabx.c:459: warning: implicit declaration of function =E2=80=98XDefaultGC=
=E2=80=99
vgrabx.c:475: warning: implicit declaration of function =E2=80=98XDestroyWi=
ndow=E2=80=99
vgrabx.c:476: warning: implicit declaration of function =E2=80=98XFreeColor=
s=E2=80=99
vgrabx.c:481: warning: implicit declaration of function =E2=80=98XCloseDisp=
lay=E2=80=99
sharief@sharief-desktop:~/Desktop/video drivers$=C2=A0




--- On Tue, 13/1/09, Michael Williamson <michael_h_williamson@yahoo.com> wr=
ote:
From: Michael Williamson <michael_h_williamson@yahoo.com>
Subject: Re: About xawtv
To: shariefbe@yahoo.co.in
Date: Tuesday, 13 January, 2009, 10:49 PM



--- On Tue, 1/13/09, niamathullah sharief <shariefbe@yahoo.co.in> wrote:

> From: niamathullah sharief <shariefbe@yahoo.co.in>
> Subject: Re: About xawtv
> To: michael_h_williamson@yahoo.com, "video4linux list"
<video4linux-list@redhat.com>, "Kernel newbies"
<kernelnewbies@nl.linux.org>
> Date: Tuesday, January 13, 2009, 2:50 AM
> ya ok micheal..i am ready to install SDL library...but is
> the xawtv software is using this SDL library to display the
> captured pictures..?i think no....then how it is
> displaying..?I think this vgrab.c requires this SDL
> library....do you have any other program to display the
> captured pictures continuously as video without using this
> =C2=A0SDL library...?sorry if i asked any wrong
> question....Thanks a lot micheal....


I have used the 'X11' library for picture display.=20
The attached program is an example. Compile it with:

   # gcc vgrabx.c -Wall -lX11 -o vgrabx

-Mike



      =0A=0A=0A      Add more friends to your messenger and enjoy! Go to ht=
tp://messenger.yahoo.com/invite/
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
