Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f196.google.com ([209.85.210.196]:48400 "EHLO
	mail-yx0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757131Ab0BKVvi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Feb 2010 16:51:38 -0500
Received: by yxe34 with SMTP id 34so1658194yxe.16
        for <linux-media@vger.kernel.org>; Thu, 11 Feb 2010 13:51:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B7330B2.4050308@redhat.com>
References: <f535cc5a1002100021u37bf47a5y50a0a90873a082e2@mail.gmail.com>
	<f535cc5a1002101058h4d8e4bd1p6fd03abd4f724f52@mail.gmail.com>
	<f535cc5a1002101101k709bbe9bv504cf33fab14dedc@mail.gmail.com>
	<f535cc5a1002101102w146050c5v91ddc6ec86542153@mail.gmail.com>
	<4B731A10.9000108@redhat.com> <829197381002101255x2af2776ftd1c7a7d32584946@mail.gmail.com>
	<f535cc5a1002101310y3faf7688hdbb0db0b1d45e081@mail.gmail.com>
	<4B7330B2.4050308@redhat.com>
From: Carlos Jenkins <carlos.jenkins.perez@gmail.com>
Date: Thu, 11 Feb 2010 15:51:17 -0600
Message-ID: <f535cc5a1002111351u78cb7b6dv44ac4b5a15696be5@mail.gmail.com>
Subject: Re: Want to help in MSI TV VOX USB 2.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone :)

Here the results, testing with Mplayer:

shell$ sudo modprobe em28xx card=5 tuner=66 --first-time --verbose
shell$ dmesg

[ 2520.516403] usbcore: registered new interface driver em28xx
[ 2520.516413] em28xx driver loaded
[ 2526.068029] usb 1-6: new high speed USB device using ehci_hcd and address 9
[ 2526.201224] usb 1-6: configuration #1 chosen from 1 choice
[ 2526.202159] em28xx: New device @ 480 Mbps (eb1a:2820, interface 0, class 0)
[ 2526.202286] em28xx #0: chip ID is em2820 (or em2710)
[ 2526.304907] em28xx #0: board has no eeprom
[ 2526.306030] em28xx #0: Identified as MSI VOX USB 2.0 (card=5)
[ 2526.669043] saa7115 5-0021: saa7114 found (1f7114d0e000000) @ 0x42
(em28xx #0)
[ 2528.824906] All bytes are equal. It is not a TEA5767
[ 2528.825133] tuner 5-0060: chip found @ 0xc0 (em28xx #0)
[ 2528.826040] tuner-simple 5-0060: creating new instance
[ 2528.826048] tuner-simple 5-0060: type set to 66 (LG TALN series)
[ 2528.849779] em28xx #0: Config register raw data: 0x00
[ 2528.980036] em28xx #0: v4l2 driver version 0.1.2
[ 2529.376156] em28xx #0: V4L2 video device registered as video0

*************************************

shell$ ls /dev/ | grep video
video0

*************************************

shell$ mplayer -tv
driver=v4l2:device=/dev/video0:norm=NTSC:chanlist=us-bcast tv://
MPlayer SVN-r29237-4.4.1 (C) 2000-2009 MPlayer Team
mplayer: could not connect to socket
mplayer: No such file or directory
Failed to open LIRC support. You will not be able to use your remote control.

Playing tv://.
TV file format detected.
Selected driver: v4l2
 name: Video 4 Linux 2 input
 author: Martin Olschewski <olschewski@zpr.uni-koeln.de>
 comment: first try, more to come ;-)
Selected device: MSI VOX USB 2.0
 Tuner cap:
 Tuner rxs:
 Capabilites:  video capture  tuner  read/write  streaming
 supported norms: 0 = NTSC; 1 = NTSC-M; 2 = NTSC-M-JP; 3 = NTSC-M-KR;
4 = NTSC-443; 5 = PAL; 6 = PAL-BG; 7 = PAL-H; 8 = PAL-I; 9 = PAL-DK;
10 = PAL-M; 11 = PAL-N; 12 = PAL-Nc; 13 = PAL-60; 14 = SECAM; 15 =
SECAM-B; 16 = SECAM-G; 17 = SECAM-H; 18 = SECAM-DK; 19 = SECAM-L; 20 =
SECAM-Lc;
 inputs: 0 = Television; 1 = Composite1; 2 = S-Video;
 Current input: 0
 Current format: YUYV
v4l2: current audio mode is : MONO
v4l2: ioctl set format failed: Invalid argument
v4l2: ioctl set format failed: Invalid argument
v4l2: ioctl set format failed: Invalid argument
open: No such file or directory
[MGA] Couldn't open: /dev/mga_vid
open: No such file or directory
[MGA] Couldn't open: /dev/mga_vid
[VO_TDFXFB] Can't open /dev/fb0: No such file or directory.
[VO_3DFX] Unable to open /dev/3dfx.
==========================================================================
Opening video decoder: [raw] RAW Uncompressed Video
VDec: vo config request - 640 x 480 (preferred colorspace: Packed YUY2)
VDec: using Packed YUY2 as output csp (no 0)
Movie-Aspect is undefined - no prescaling applied.
VO: [xv] 640x480 => 640x480 Packed YUY2
Selected video codec: [rawyuy2] vfm: raw (RAW YUY2)
==========================================================================
Audio: no sound
Starting playback...
v4l2: select timeout
v4l2: select timeout ??% ??,?% 0 0
v4l2: select timeout ??% ??,?% 0 0
[... Ad infinitum ...]
v4l2: select timeout ??% ??,?% 0 0
v4l2: select timeout ??% ??,?% 0 0
v4l2: 0 frames successfully processed, 1 frames dropped.

Exiting... (Quit)

Still no video.

> At the board entry for your card (at em28xx-cards.c), you may try to remove the
> .max_range line from your board entry:
>
> ...
>        [EM2820_BOARD_MSI_VOX_USB_2] = {
> ...
>                .max_range_640_480 = 1,

I'll try that, but as you said, this should not be a problem.

Thanks again.
Cheers
