Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBS5Erhr011803
	for <video4linux-list@redhat.com>; Sun, 28 Dec 2008 00:14:53 -0500
Received: from qw-out-2122.google.com (qw-out-2122.google.com [74.125.92.27])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBS5EXIC024246
	for <video4linux-list@redhat.com>; Sun, 28 Dec 2008 00:14:33 -0500
Received: by qw-out-2122.google.com with SMTP id 3so1629880qwe.39
	for <video4linux-list@redhat.com>; Sat, 27 Dec 2008 21:14:33 -0800 (PST)
Message-ID: <99cd09480812272114n356fd157o5a416b46e1723250@mail.gmail.com>
Date: Sun, 28 Dec 2008 00:14:32 -0500
From: xelapond <xelapond@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: PS3Eye on Debian
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

Hello,

I have been trying to get my PS3Eye Camera to work on Debian, and to partial
success.  I did as recommended
here<http://forums.ps2dev.org/viewtopic.php?t=9238&postdays=0&postorder=asc&start=90&sid=04c17e156208a7226117b24df91b2fd6>and
got the gspca sources from
http://linuxtv.org/hg/~jfrancois/gspca/, and compiled those.  It compiled
successfully(it complained about __memcpy once, but nothing big).  I can now
access the camera through /dev/video0.  It works fine in
gstreamer-properties, but when I try to open it in anything else(for
instance mplayer), I get errors.  I have posted the output of mplayer below:

alex@Andromeda:~$ mplayer -vo ov534 -ao alsa -tv
driver=v4l2:device=/dev/video0 tv://
MPlayer 1.0rc2-4.2.3 (C) 2000-2007 MPlayer Team
CPU: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz (Family: 6, Model: 15,
Stepping: 11)
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
Selected device: USB Camera-B4.04.27.1
 Capabilites:  video capture  read/write  streaming
 supported norms:
 inputs: 0 = ov534;
 Current input: 0
 Current format: YUYV
tv.c: norm_from_string(pal): Bogus norm parameter, setting default.
v4l2: ioctl enum norm failed: Invalid argument
Error: Cannot set norm!
Selected input hasn't got a tuner!
v4l2: ioctl set mute failed: Invalid argument
v4l2: ioctl query control failed: Invalid argument
v4l2: ioctl query control failed: Invalid argument
v4l2: ioctl query control failed: Invalid argument
v4l2: ioctl query control failed: Invalid argument
FPS not specified in the header or invalid, use the -fps option.
No stream found.

v4l2: ioctl set mute failed: Invalid argument
v4l2: 0 frames successfully processed, 0 frames dropped.

Exiting... (End of file)
alex@Andromeda:~$

Any ideas how I can get this to work?  Ultimately I would like to be able to
use the camera within openFrameworks, which uses unicap.

Thanks!

Alex
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
