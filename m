Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0B3N0WI008851
	for <video4linux-list@redhat.com>; Sat, 10 Jan 2009 22:23:00 -0500
Received: from web95209.mail.in2.yahoo.com (web95209.mail.in2.yahoo.com
	[203.104.18.185])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n0B3Mdo2005974
	for <video4linux-list@redhat.com>; Sat, 10 Jan 2009 22:22:40 -0500
Date: Sun, 11 Jan 2009 08:52:37 +0530 (IST)
From: niamathullah sharief <shariefbe@yahoo.co.in>
To: Michael Williamson <michael_h_williamson@yahoo.com>,
	video4linux list <video4linux-list@redhat.com>
In-Reply-To: <195002.20065.qm@web65510.mail.ac4.yahoo.com>
MIME-Version: 1.0
Message-ID: <731085.28078.qm@web95209.mail.in2.yahoo.com>
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


Thanks williams...but now too i am getting the anither error....sharief@sha=
rief-desktop:~/Desktop/video drivers$ gcc vgrab.c -Wall -o vgrab
sharief@sharief-desktop:~/Desktop/video drivers$ ./vgrab > picture.pgm
open video failed: No such file or directory
sharief@sharief-desktop:~/Desktop/video drivers$

please help williams...no one here to help...--- On Sun, 11/1/09, Michael W=
illiamson <michael_h_williamson@yahoo.com> wrote:
From: Michael Williamson <michael_h_williamson@yahoo.com>
Subject: Re: About xawtv
To: shariefbe@yahoo.co.in
Date: Sunday, 11 January, 2009, 2:16 AM



--- On Fri, 1/9/09, niamathullah sharief <shariefbe@yahoo.co.in> wrote:

> From: niamathullah sharief <shariefbe@yahoo.co.in>
> Subject: Re: About xawtv
> To: michael_h_williamson@yahoo.com, "video4linux list"
<video4linux-list@redhat.com>
> Date: Friday, January 9, 2009, 8:54 PM
> No i am using "creative" webcam...dont know the
> exact model...bit it is connected only with usb port....
> --- On Sat, 10/1/09, Michael Williamson
> <michael_h_williamson@yahoo.com> wrote:
> From: Michael Williamson
> <michael_h_williamson@yahoo.com>
> Subject: Re: About xawtv
> To: shariefbe@yahoo.co.in
> Date: Saturday, 10 January, 2009, 12:51 AM
>=20
>=20
>=20
> --- On Fri, 1/9/09, niamathullah sharief
> <shariefbe@yahoo.co.in> wrote:
>=20
> > From: niamathullah sharief
> <shariefbe@yahoo.co.in>
> > Subject: Re: About xawtv
> > To: michael_h_williamson@yahoo.com, "video4linux
> list"
> <video4linux-list@redhat.com>
> > Date: Friday, January 9, 2009, 11:04 AM
> > Hi michael i am getting this error when i run that
> command
> > which you gave to me..
> >=20
> > sharief@sharief-desktop:~/Desktop/video drivers$ gcc
> > vgrab5.c -Wall -o vgrab5
> > sharief@sharief-desktop:~/Desktop/video drivers$
> ./vgrab5
> > /dev/video0 > t.pgm
> > ioctl (VIDIOC_S_FMT) failed, 22
> > VIDIOC_S_FMT: Invalid argument
> >=20
> > =C2=A0 what is the error?what to do?
>=20
>=20
> What kind of camera are you using? Does it connect to a USB
>=20
> port, or to a coaxial style connector? If it is a coaxial
> (RCA) video
> connector, then try changing the width and height to this:
>=20
>    vf.fmt.pix.width =3D 640;
>    vf.fmt.pix.height =3D 480;

Hi,

I have only used V4L with USB webcams successfully. The other programs
I sent use the V4L2 API. Try the attached program. It should compile
with=20

   # gcc vgrab.c -Wall -o vgrab

and run with

   # ./vgrab > picture.pgm

and display with

   # display picture.pgm



-Mike



      =0A=0A=0A      Add more friends to your messenger and enjoy! Go to ht=
tp://messenger.yahoo.com/invite/
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
