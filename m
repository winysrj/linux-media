Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m26Lqnjg014446
	for <video4linux-list@redhat.com>; Thu, 6 Mar 2008 16:52:49 -0500
Received: from bay0-omc1-s26.bay0.hotmail.com (bay0-omc1-s26.bay0.hotmail.com
	[65.54.246.98])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m26LqDIb011766
	for <video4linux-list@redhat.com>; Thu, 6 Mar 2008 16:52:13 -0500
Message-ID: <BAY122-W356EE227C3E496A044E7B3AA120@phx.gbl>
From: Elvis Chen <chene77@hotmail.com>
To: <video4linux-list@redhat.com>
Date: Thu, 6 Mar 2008 21:52:05 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Subject: is it possible to grab images from 2 PVR-150 in a loop/timer?
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


greetings,

a few days ago I posted a message to the list asking about how to progra, w=
ith PVR-150.  With the help from this group, I managed to grab images from =
2 tuner (both PVR-150, /dev/video32 and /dev/video33).  The steps of displa=
ying the final image on the screen is to 1) demacro the yuv microblock of t=
he hm12 device, and 2) convert the final yuv image to RGB, and 3) display t=
he final RGB images in a 3D visualization software (www.vtk.org).  This wor=
ks as long as I am grabbing only 1 image from each device.

To facilitate the development, I'm using qt as the widget set.

But as soon as I try to grab images *from both tuners* and *contineously*, =
I get corrupted images.  Using a for-loop (or a qt-timer), I can grab image=
s from *ONE* tuner and display the video on the screen, and it works fine. =
 However, if I try to do that to both tuners, either in a for-loop or at a =
pre-set interval through QTimer, both images are corrupted.  They both look=
 like they are down-sampled, and with duplicated-shifted pixels.

I can show some pictures in a private email, as I don't think sending a bin=
ary image in the email list is a good idea.

Can anyone shed some light into what might be wrong?

thank you,

Elvis

_________________________________________________________________

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
