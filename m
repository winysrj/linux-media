Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m52FbB7C026929
	for <video4linux-list@redhat.com>; Mon, 2 Jun 2008 11:37:11 -0400
Received: from mout.perfora.net (mout.perfora.net [74.208.4.194])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m52FafWe007989
	for <video4linux-list@redhat.com>; Mon, 2 Jun 2008 11:36:41 -0400
From: "John A. Sullivan III" <jsullivan@opensourcedevel.com>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=UTF-8
Date: Mon, 02 Jun 2008 11:37:14 -0400
Message-Id: <1212421034.7097.19.camel@jaspav.missionsit.net.missionsit.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: NX client and remote video input devices
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

Hello, all.  We are planning to launch a business to provide linux
based, virtual desktops and office environments to small business using
NoMachine's  NX technology.  One of the difficult issues we are facing
is video input especially for those wishing to use video over IP.  We
would like to use NX's native abilities rather than trying to manage a
second data stream for video via ssh or netcat and we are not even sure
such an arrangement would give us the control we would want over the
input device.

The basic set up is an end user at a physical desktop with a web cam
viewing a virtual desktop and needing to see the input of the web cam on
the virtual desktop as well as being able to control the input device,
e.g., start, stop, pause.  Something like this using mplayer as a
typical application:

﻿
            user                                   mplayer
              |                                        |
CAM______physical desktop-----------------------virtual desktop
             |                                          |
             |                                          |
          NXClient----------SMB share----------------NXServer

The SMB share is something NX supports natively.  We noticed we could
create a symbolic link to /dev/video0 and use this link to manage the
video input device.  However, when we try to mount this symbolic link as
an SMB share, we get an initial blinking light on our Logitech web cam
but then receive an error.  Here is the result of trying to use mplayer
to control the web cam input:

﻿jsullivan@denisedell:~$ mplayer -fps 15 tv:// -tv
driver=v4l2:width=640:height=480:device=/home/jsullivan/MyShares/NXSHARES/video0
MPlayer 1.0rc2-4.2.3 (C) 2000-2007 MPlayer Team
CPU: Intel(R) Pentium(R) 4 CPU 2.80GHz (Family: 15, Model: 3, Stepping:
4)
CPUflags:  MMX: 1 MMX2: 1 3DNow: 0 3DNow2: 0 SSE: 1 SSE2: 1
Compiled with runtime CPU detection.
mplayer: could not connect to socket
mplayer: No such file or directory
Failed to open LIRC support. You will not be able to use your remote
control.

Playing tv://.
TV file format detected.
Selected driver: v4l2
 name: Video 4 Linux 2 input
 author: Martin Olschewski <olschewski@zpr.uni-koeln.de>
 comment: first try, more to come ;-)
v4l2: ioctl query capabilities failed: Inappropriate ioctl for device
v4l2: ioctl set mute failed: Inappropriate ioctl for device
v4l2: 0 frames successfully processed, 0 frames dropped.


Exiting... (End of file)

How can we control and access a video input device on a remote computer?
This is a high priority project for us (our first potential customer) so
any help would be greatly appreciated.  Thanks - John
-- 
John A. Sullivan III
Open Source Development Corporation
+1 207-985-7880
jsullivan@opensourcedevel.com

http://www.spiritualoutreach.com
Making Christianity intelligible to secular society


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
