Return-path: <linux-media-owner@vger.kernel.org>
Received: from killer.cirr.com ([192.67.63.5]:52908 "EHLO killer.cirr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754155Ab0EZA6Q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 25 May 2010 20:58:16 -0400
Received: from afc by tashi.lonestar.org with local (Exim 4.69)
	(envelope-from <afc@shibaya.lonestar.org>)
	id 1OH4lg-0006IK-QH
	for linux-media@vger.kernel.org; Tue, 25 May 2010 20:46:44 -0400
Date: Tue, 25 May 2010 20:46:44 -0400
From: "A. F. Cano" <afc@shibaya.lonestar.org>
To: linux-media@vger.kernel.org
Subject: Subject: Composite input from OnAir Creator - use as security
	camera
Message-ID: <20100526004644.GA23817@shibaya.lonestar.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hello,

I would like to be able to capture video from a camera connected to the
composite video input of an OnAir Creator.  I have tried motion, mplayer,
kaffeine, mythtv, xawtv and none have worked so far.  Hopefully it's something
trivial that I'm doing wrong.  I am using an up to date Debian Lenny
distribution.

Months (or even 1+ years) ago, I gave the OnAir Creator a try and had issues
with having to hunt down the firmware file.  Since I don't get firmware error
messages, I presume this issue is no longer relevant, or is it?  My previous
experience was with Etch, Lenny was installed from scratch, so if the firmware
didn't get installed automatically, it isn't in place.

This is the kernel used:

Linux version 2.6.26-2-686 (Debian 2.6.26-21lenny4) (dannf@debian.org) (gcc version 4.1.3 20080704 (prerelease) (Debian 4.1.2-25)) #1 SMP Tue Mar 9 17:35:51 UTC 2010

It seems the problem is that an ioctl() call is failing.  Is this a case of
Lenny being too old or is there a more fundamental problem?  Do I need to send
something to the Creator to get it to start sending? or is this automatic when
the applications start?

It would be nice to use the Creator inputs (composite for now, but if I could
get it to work the S-video input would be even better) for digitizing old
analog video tapes, essentially making a video-capture device.

o Motion

"motion" would be the ideal application.  I have it properly configured and it
works with usb web cams, but the quality of the picture is horrible.  I have
an old NTSC video conferencing camera that has a much better picture, but
motion doesn't seem to be able to deal with the OnAir Creator:


[1] cap.driver: "pvrusb2"
[1] cap.card: "OnAir Creator Hybrid USB tuner"
[1] cap.bus_info: "usb 4-3 address 11"
[1] cap.capabilities=0x01070011
[1] - VIDEO_CAPTURE
[1] - VBI_CAPTURE
[1] - TUNER
[1] - AUDIO
[1] - READWRITE
[1] VIDIOC_S_FREQUENCY: Numerical result out of range
[1] Supported palettes:
[1] 0:
[1] Unable to find a compatible palette format.
[1] ioctl(VIDIOCGMBUF) - Error device does not support memory map
[1] V4L capturing using read is deprecated!
[1] Motion only supports mmap.
[1] Capture error calling vid_start
[1] Thread finishing...

Is there anything that can be done about this? or is "motion" a lost cause?

o Mplayer

$ mplayer -tv input=1:normid=16 tv://
MPlayer dev-SVN-r26940
CPU: Intel(R) Pentium(R) M processor 1400MHz (Family: 6, Model: 9, Stepping: 5)
CPUflags:  MMX: 1 MMX2: 1 3DNow: 0 3DNow2: 0 SSE: 1 SSE2: 1
Compiled with runtime CPU detection.
Can't open joystick device /dev/input/js0: No such file or directory
Can't init input joystick
mplayer: could not connect to socket
mplayer: No such file or directory
Failed to open LIRC support. You will not be able to use your remote control.

Playing tv://.
TV file format detected.
Selected driver: v4l2
 name: Video 4 Linux 2 input
 author: Martin Olschewski <olschewski@zpr.uni-koeln.de>
 comment: first try, more to come ;-)
Selected device: OnAir Creator Hybrid USB tuner
 Tuner cap:
 Tuner rxs:
 Capabilites:  video capture  VBI capture device  tuner  audio  read/write
 supported norms: 0 = PAL-B/G; 1 = PAL-D/K; 2 = SECAM-B/G; 3 = SECAM-D/K; 4 = PAL-B; 5 = PAL-B1; 6 = PAL-G; 7 = PAL-H; 8 = PAL-I; 9 = PAL-D; 10 = PAL-D1; 11 = PAL-K; 12 = PAL-M; 13 = PAL-N; 14 = PAL-Nc; 15 = PAL-60; 16 = NTSC-M; 17 = NTSC-Mj; 18 = NTSC-443; 19 = NTSC-Mk; 20 = SECAM-B; 21 = SECAM-D; 22 = SECAM-G; 23 = SECAM-H; 24 = SECAM-K; 25 = SECAM-K1; 26 = SECAM-L; 27 = SECAM-LC;
 inputs: 0 = television; 1 = composite; 2 = s-video;
 Current input: 1
 Current format: unknown (0x0)
v4l2: current audio mode is : MONO
v4l2: ioctl request buffers failed: Invalid argument
v4l2: 0 frames successfully processed, 0 frames dropped.


Exiting... (End of file)

So in this case, with the input=1 option, it seems that at least I'm getting to
the correct input, but overall it also fails.  Can mplayer be given other
options to make it work? or is this also a lost cause?  I have tried with all
the NTSC norms: same result.

o Kaffeine and MythTV

In those two apps, I can't find where to configure it to use the composite
input.  Plus, they are way too much for what I need, but if I could use
MythTV with zone minder as has been mentioned in the MythTV list, it would do
nicely.  Unfortunately, zone minder doesn't seem to be in Lenny.

Months (years?) ago, I did manage to get MythTV to work with analog signals
but the reception was horrible so I gave up.  Watching TV is not a high
priority and I never installed the amplified roof antenna.  I never figured
out how to select the composite or S-video inputs from within MythTV.

o xawtv

xawtv doesn't have a norm for NTSC (only PAL and SECAM) so even though I can
select the composite input:  no picture.  It also says:

v4l-conf had some trouble, trying to continue anyway
Warning: Cannot convert string "-*-ledfixed-medium-r-*--39-*-*-*-c-*-*-*" to type FontStruct
v4l2: read: rc=262144/size=442368

So,  what else can I try?  Any hints welcome.  Thanks.

A.

