Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m564vhwV008956
	for <video4linux-list@redhat.com>; Fri, 6 Jun 2008 00:57:43 -0400
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.183])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m564vSUU029270
	for <video4linux-list@redhat.com>; Fri, 6 Jun 2008 00:57:28 -0400
Received: by wa-out-1112.google.com with SMTP id j32so596174waf.7
	for <video4linux-list@redhat.com>; Thu, 05 Jun 2008 21:57:28 -0700 (PDT)
Date: Thu, 5 Jun 2008 22:57:20 -0600
From: Collin Day <dcday137@gmail.com>
To: video4linux-list@redhat.com
Message-ID: <20080605225720.6e9db3ad@Krypton.homenet>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: KWORLD DVD Maker
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

I have a Kworld DVD Maker that I don't think is the same as the Kworld
USB 2800 device mentioned in the em28xx.h card list (the one mentioned
has only PAL formats listed). It has an empia2860 chip and a saa7113h
chip inside (I took it apart). So far, I have tried adding this to
em28xx.h:

#define EM2860_BOARD_KWORLD_DVDMAKER		  62

and the following to the card list in em28xx-cards.h:

	[EM2860_BOARD_KWORLD_DVDMAKER] = {
		.name         = "Kworld DVDMAKER",
		.em_type      = EM2860,
		.vchannels    = 3,
		.norm         = V4L2_STD_NTSC,
		.decoder      = EM28XX_SAA7113,
		.dev_modes      = EM28XX_VIDEO,
		.input          = {{
			.type     = EM28XX_VMUX_COMPOSITE1,
			.vmux     = SAA7115_COMPOSITE0,
			.amux     = 1,
		},{
			.type     = EM28XX_VMUX_SVIDEO,
			.vmux     = SAA7115_SVIDEO3,
			.amux     = 1,
		}},
		.tvnorms	= {
			{
				.name = "NTSC",
				.id = V4L2_STD_NTSC,
			}
		},
	}

I am assuming most of this is right, although I am not sure what
vchannels is - so I left it at 3.  I am guessing it is either 3 or
one.  Also, it is NTSC and it has a video composite port - for a
picture, see here:

http://www.videohelp.com/forum/archive/anyone-has-xpert-dvd-maker-usb2-0-t193900.html

I have been trying to run it using a video input with the following:

 mplayer tv:// -tv
width=360:height=288:device=/dev/video0:driver=v4l2:norm=NTSC

The terminal outputs:

MPlayer dev-SVN-r26753-4.2.4 (C) 2000-2008 MPlayer
Team CPU: Intel(R) Core(TM)2 Duo CPU     E6750  @ 2.66GHz (Family: 6,
Model: 15, Stepping: 11) MMX2 supported but disabled
SSE supported but disabled
SSE2 supported but disabled
CPUflags:  MMX: 1 MMX2: 0 3DNow: 0 3DNow2: 0 SSE: 0 SSE2: 0
Compiled for x86 CPU with extensions: MMX
Can't open joystick device /dev/input/js0: No such file or directory
Can't init input joystick

Playing tv://.
TV file format detected.
Selected driver: v4l2
 name: Video 4 Linux 2 input
 author: Martin Olschewski <olschewski@zpr.uni-koeln.de>
 comment: first try, more to come ;-)
Selected device: Kworld DVDMAKER
 Capabilites:  video capture  audio  read/write  streaming
 supported norms: 0 = NTSC;
 inputs: 0 = Composite1; 1 = S-Video;
 Current input: 0
 Current format: YUYV
Selected input hasn't got a tuner!
v4l2: ioctl query control failed: Invalid argument
==========================================================================
Opening video decoder: [raw] RAW Uncompressed Video
VDec: vo config request - 360 x 288 (preferred colorspace: Packed YUY2)
VDec: using Packed YUY2 as output csp (no 0)
Movie-Aspect is undefined - no prescaling applied.
VO: [xv] 360x288 => 360x288 Packed YUY2 
Selected video codec: [rawyuy2] vfm: raw (RAW YUY2)
==========================================================================
Audio: no sound
Starting playback...
v4l2: select timeout
v4l2: select timeout ??% ??,?% 0 0 
v4l2: select timeout ??% ??,?% 0 0 
v4l2: select timeout ??% ??,?% 0 0 
v4l2: select timeout ??% ??,?% 0 0 
v4l2: select timeout ??% ??,?% 0 0 
v4l2: 0 frames successfully processed, 1 frames dropped.

Exiting... (Quit)


and all I get while this is going on is a green screen.  Anyone have any
ideas or can anyone point me some pointers so I can figure out how to
get this to work or how to debug it? It seems it should work since I
believe both chips are supported under v4l2.  I know the device works
because I have used it under Windows.

Could it have something to do with the following line from above?:

v4l2: ioctl query control failed: Invalid argument 

Thanks for any help!

-C

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
