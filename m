Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m21LXolo011929
	for <video4linux-list@redhat.com>; Sat, 1 Mar 2008 16:33:50 -0500
Received: from bay0-omc1-s28.bay0.hotmail.com (bay0-omc1-s28.bay0.hotmail.com
	[65.54.246.100])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m21LXEub015053
	for <video4linux-list@redhat.com>; Sat, 1 Mar 2008 16:33:14 -0500
Message-ID: <BAY122-W46E61F0928F2E422B22355AA150@phx.gbl>
From: Elvis Chen <chene77@hotmail.com>
To: <video4linux-list@redhat.com>
Date: Sat, 1 Mar 2008 21:33:08 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Subject: newbie programming help:  grabbing image(s) from /dev/video0,
 example code?
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


Greetings,

I'm a researcher in computer-science.  I'm very new to V4L2 but am reasonab=
ly proficient in  C++ programming.  I seek your help in getting something s=
imple done, in the meanwhile I'm trying to learn V4L2 programming API (http=
://v4l2spec.bytesex.org/)

We have 2 Hauppauge WInTV PVR-150 installed on a ubuntu 7.10 x86_64 machine=
.  They appear to the linux as /dev/video0 and /dev/video1, respectively.  =
What we like to do is to capture still images (or video) via s-video inputs=
 on each card, and perform image-processing algorithms on them (in C++) and=
 display the resultant images on the screen (C++/OpenGL).  Basically what I=
 want to do is very simple:  open a linux/video device, capture an image, s=
tore it as a C array/buffer, display it, and refresh the C array/buffer.

Both cards work with kdetv and mplayer, so hardware-wise they work fine.

My first attempt was to find a small/simple API to access the linux/video d=
evice.  I came across videodog  (http://linux.softpedia.com/get/Multimedia/=
Video/VideoDog-9261.shtml) but it looks like it isn't been developed anymor=
e (no source either).  Currently I'm trying to learn V4L2 (and trying to ut=
ilize the sample capture.c).


Can anyone please give me a pointer on where I should start learning the V4=
L2 API?  Are there more example codes available?


any help is very much appreciated,

_________________________________________________________________

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
