Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0A2simD019456
	for <video4linux-list@redhat.com>; Fri, 9 Jan 2009 21:54:44 -0500
Received: from web95212.mail.in2.yahoo.com (web95212.mail.in2.yahoo.com
	[203.104.18.188])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n0A2sNWC007559
	for <video4linux-list@redhat.com>; Fri, 9 Jan 2009 21:54:24 -0500
Date: Sat, 10 Jan 2009 08:24:22 +0530 (IST)
From: niamathullah sharief <shariefbe@yahoo.co.in>
To: michael_h_williamson@yahoo.com,
	video4linux list <video4linux-list@redhat.com>
In-Reply-To: <997415.76985.qm@web65510.mail.ac4.yahoo.com>
MIME-Version: 1.0
Message-ID: <727883.70706.qm@web95212.mail.in2.yahoo.com>
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


No i am using "creative" webcam...dont know the exact model...bit it is con=
nected only with usb port....
--- On Sat, 10/1/09, Michael Williamson <michael_h_williamson@yahoo.com> wr=
ote:
From: Michael Williamson <michael_h_williamson@yahoo.com>
Subject: Re: About xawtv
To: shariefbe@yahoo.co.in
Date: Saturday, 10 January, 2009, 12:51 AM



--- On Fri, 1/9/09, niamathullah sharief <shariefbe@yahoo.co.in> wrote:

> From: niamathullah sharief <shariefbe@yahoo.co.in>
> Subject: Re: About xawtv
> To: michael_h_williamson@yahoo.com, "video4linux list"
<video4linux-list@redhat.com>
> Date: Friday, January 9, 2009, 11:04 AM
> Hi michael i am getting this error when i run that command
> which you gave to me..
>=20
> sharief@sharief-desktop:~/Desktop/video drivers$ gcc
> vgrab5.c -Wall -o vgrab5
> sharief@sharief-desktop:~/Desktop/video drivers$ ./vgrab5
> /dev/video0 > t.pgm
> ioctl (VIDIOC_S_FMT) failed, 22
> VIDIOC_S_FMT: Invalid argument
>=20
> =C2=A0 what is the error?what to do?


What kind of camera are you using? Does it connect to a USB=20
port, or to a coaxial style connector? If it is a coaxial (RCA) video
connector, then try changing the width and height to this:

   vf.fmt.pix.width =3D 640;
   vf.fmt.pix.height =3D 480;

-Mike




=0A=0A=0A      Add more friends to your messenger and enjoy! Go to http://m=
essenger.yahoo.com/invite/
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
