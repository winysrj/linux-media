Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n09H4V38007066
	for <video4linux-list@redhat.com>; Fri, 9 Jan 2009 12:04:31 -0500
Received: from web95208.mail.in2.yahoo.com (web95208.mail.in2.yahoo.com
	[203.104.18.184])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id n09H4ACL030149
	for <video4linux-list@redhat.com>; Fri, 9 Jan 2009 12:04:11 -0500
Date: Fri, 9 Jan 2009 22:34:08 +0530 (IST)
From: niamathullah sharief <shariefbe@yahoo.co.in>
To: michael_h_williamson@yahoo.com,
	video4linux list <video4linux-list@redhat.com>
In-Reply-To: <547683.47002.qm@web65506.mail.ac4.yahoo.com>
MIME-Version: 1.0
Message-ID: <86125.9199.qm@web95208.mail.in2.yahoo.com>
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


Hi michael i am getting this error when i run that command which you gave t=
o me..

sharief@sharief-desktop:~/Desktop/video drivers$ gcc vgrab5.c -Wall -o vgra=
b5
sharief@sharief-desktop:~/Desktop/video drivers$ ./vgrab5 /dev/video0 > t.p=
gm
ioctl (VIDIOC_S_FMT) failed, 22
VIDIOC_S_FMT: Invalid argument

=C2=A0 what is the error?what to do?

--- On Fri, 9/1/09, Michael Williamson <michael_h_williamson@yahoo.com> wro=
te:
From: Michael Williamson <michael_h_williamson@yahoo.com>
Subject: Re: About xawtv
To: shariefbe@yahoo.co.in
Date: Friday, 9 January, 2009, 10:14 PM



--- On Thu, 1/8/09, niamathullah sharief <shariefbe@yahoo.co.in> wrote:

> From: niamathullah sharief <shariefbe@yahoo.co.in>
> Subject: Re: About xawtv
> To: "Michael Williamson" <michael_h_williamson@yahoo.com>
> Cc: "video4linux list" <video4linux-list@redhat.com>
> Date: Thursday, January 8, 2009, 9:06 PM
> Thanks for your valuable reply...first program is ok...buty
> what this secand program?and you told thatattached another
> program, "rover.c", that displays pictures using
> the
> SDL library, which must be installed before compiling.
>=20
> what to install before compilation?whether firat program or
> anything else?

Hi,

The first program, "vgrab5.c", should compile with the command line

   # gcc vgrab5.c -Wall -o vgrab5

Does it? Then, running the program should grab a picture from
a video device, "/dev/video0" for example,

   # ./vgrab5 /dev/video0 > t.pgm

and save the picture as a ".pgm" file. You need a display program,=20
like ImageMagicks program "display" to display the picture

    # display t.pgm

or=20

    # gimp t.pgm

But it is black & white only.=20

The other program, "rover.c", is for operating a robot. I sent it to
you because it has example code for using the SDL library to display
the pictures. You can try to compile it, with

   # gcc rover.c -Wall -lSDL -lm -o rover

Does it compile without errors? But even if it does compile, it is=20
unlikely to be useful to you as it is.=20

-Mike



     =20
=0A=0A=0A      Check out the all-new Messenger 9.0! Go to http://in.messeng=
er.yahoo.com/
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
