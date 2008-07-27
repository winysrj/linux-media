Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6RFLcnR021210
	for <video4linux-list@redhat.com>; Sun, 27 Jul 2008 11:21:38 -0400
Received: from smtp-out4.blueyonder.co.uk (smtp-out4.blueyonder.co.uk
	[195.188.213.7])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6RFL2Sf014139
	for <video4linux-list@redhat.com>; Sun, 27 Jul 2008 11:21:02 -0400
Received: from [172.23.170.141] (helo=anti-virus02-08)
	by smtp-out4.blueyonder.co.uk with smtp (Exim 4.52)
	id 1KN83R-0000Rp-C0
	for video4linux-list@redhat.com; Sun, 27 Jul 2008 16:21:01 +0100
Received: from [82.46.193.134] (helo=[82.46.193.134])
	by asmtp-out4.blueyonder.co.uk with esmtpa (Exim 4.52)
	id 1KN83Q-00050h-J7
	for video4linux-list@redhat.com; Sun, 27 Jul 2008 16:21:00 +0100
Message-ID: <488C9266.7010108@blueyonder.co.uk>
Date: Sun, 27 Jul 2008 16:21:10 +0100
From: Ian Davidson <id012c3076@blueyonder.co.uk>
MIME-Version: 1.0
To: Video 4 Linux <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: xawtv - no picture
Reply-To: Ian.Davidson@bigfoot.com
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

I am trying to run xawtv (or actually streamer) to capture video - but 
at the moment, it is not working.

For details of my system, please see 
http://www.smolts.org/client/show_all/pub_86fd06ee-583b-40d2-b23b-92749309023b

I have a K-World DVB-T 210SE card which I hope will allow me to capture 
the video (although that is not very evident in the above link)

Here is a section of the dmesg output
Linux video capture interface: v2.00
saa7130/34: v4l2 driver version 0.2.14 loaded
ACPI: PCI Interrupt 0000:04:02.0[A] -> GSI 18 (level, low) -> IRQ 18
saa7133[0]: found at 0000:04:02.0, rev: 209, irq: 18, latency: 64, mmio: 
0xfebff800
saa7133[0]: subsystem: 17de:7253, board: UNKNOWN/GENERIC 
[card=0,autodetected]
saa7133[0]: board init: gpio is 100
parport_pc 00:07: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
saa7133[0]: i2c eeprom 00: de 17 53 72 ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
ppdev: user-space parallel port driver

When I try to run xawtv, this is what I get
[Ian@localhost ~]$ xawtv
This is xawtv-3.95, running on Linux/i686 (2.6.25.10-86.fc9.i686)
xinerama 0: 1440x900+0+0
WARNING: No DGA support available for this display.
WARNING: couldn't find framebuffer base address, try manual
         configuration ("v4l-conf -a <addr>")
ioctl: 
VIDIOC_TRY_FMT(type=VIDEO_OVERLAY;fmt.win.w.left=3;fmt.win.w.top=48;fmt.win.w.width=384;fmt.win.w.height=288;fmt.win.field=ANY;fmt.win.chromakey=0;fmt.win.clips=(nil);fmt.win.clipcount=0;fmt.win.bitmap=(nil)): 
Invalid argument
ioctl: 
VIDIOC_S_FMT(type=VIDEO_OVERLAY;fmt.win.w.left=3;fmt.win.w.top=48;fmt.win.w.width=384;fmt.win.w.height=288;fmt.win.field=ANY;fmt.win.chromakey=0;fmt.win.clips=0x9414cb4;fmt.win.clipcount=0;fmt.win.bitmap=(nil)): 
Invalid argument
ioctl: VIDIOC_OVERLAY(int=0): Invalid argument
ioctl: 
VIDIOC_TRY_FMT(type=VIDEO_OVERLAY;fmt.win.w.left=3;fmt.win.w.top=48;fmt.win.w.width=384;fmt.win.w.height=288;fmt.win.field=ANY;fmt.win.chromakey=0;fmt.win.clips=(nil);fmt.win.clipcount=0;fmt.win.bitmap=(nil)): 
Invalid argument
ioctl: 
VIDIOC_S_FMT(type=VIDEO_OVERLAY;fmt.win.w.left=3;fmt.win.w.top=48;fmt.win.w.width=384;fmt.win.w.height=288;fmt.win.field=ANY;fmt.win.chromakey=0;fmt.win.clips=0x9414cb4;fmt.win.clipcount=1;fmt.win.bitmap=(nil)): 
Invalid argument
ioctl: VIDIOC_OVERLAY(int=0): Invalid argument
ioctl: 
VIDIOC_TRY_FMT(type=VIDEO_OVERLAY;fmt.win.w.left=3;fmt.win.w.top=48;fmt.win.w.width=384;fmt.win.w.height=288;fmt.win.field=ANY;fmt.win.chromakey=0;fmt.win.clips=(nil);fmt.win.clipcount=0;fmt.win.bitmap=(nil)): 
Invalid argument
ioctl: 
VIDIOC_S_FMT(type=VIDEO_OVERLAY;fmt.win.w.left=3;fmt.win.w.top=48;fmt.win.w.width=384;fmt.win.w.height=288;fmt.win.field=ANY;fmt.win.chromakey=0;fmt.win.clips=0x9414cb4;fmt.win.clipcount=1;fmt.win.bitmap=(nil)): 
Invalid argument
ioctl: VIDIOC_OVERLAY(int=0): Invalid argument
ioctl: 
VIDIOC_TRY_FMT(type=VIDEO_OVERLAY;fmt.win.w.left=3;fmt.win.w.top=48;fmt.win.w.width=384;fmt.win.w.height=288;fmt.win.field=ANY;fmt.win.chromakey=0;fmt.win.clips=(nil);fmt.win.clipcount=0;fmt.win.bitmap=(nil)): 
Invalid argument
ioctl: 
VIDIOC_S_FMT(type=VIDEO_OVERLAY;fmt.win.w.left=3;fmt.win.w.top=48;fmt.win.w.width=384;fmt.win.w.height=288;fmt.win.field=ANY;fmt.win.chromakey=0;fmt.win.clips=0x9414cb4;fmt.win.clipcount=1;fmt.win.bitmap=(nil)): 
Invalid argument
ioctl: VIDIOC_OVERLAY(int=0): Invalid argument
ioctl: 
VIDIOC_TRY_FMT(type=VIDEO_OVERLAY;fmt.win.w.left=3;fmt.win.w.top=48;fmt.win.w.width=384;fmt.win.w.height=288;fmt.win.field=ANY;fmt.win.chromakey=0;fmt.win.clips=(nil);fmt.win.clipcount=0;fmt.win.bitmap=(nil)): 
Invalid argument
ioctl: 
VIDIOC_S_FMT(type=VIDEO_OVERLAY;fmt.win.w.left=3;fmt.win.w.top=48;fmt.win.w.width=384;fmt.win.w.height=288;fmt.win.field=ANY;fmt.win.chromakey=0;fmt.win.clips=0x9414cb4;fmt.win.clipcount=1;fmt.win.bitmap=(nil)): 
Invalid argument
ioctl: VIDIOC_OVERLAY(int=0): Invalid argument
ioctl: 
VIDIOC_TRY_FMT(type=VIDEO_OVERLAY;fmt.win.w.left=3;fmt.win.w.top=48;fmt.win.w.width=384;fmt.win.w.height=288;fmt.win.field=ANY;fmt.win.chromakey=0;fmt.win.clips=(nil);fmt.win.clipcount=0;fmt.win.bitmap=(nil)): 
Invalid argument
ioctl: 
VIDIOC_S_FMT(type=VIDEO_OVERLAY;fmt.win.w.left=3;fmt.win.w.top=48;fmt.win.w.width=384;fmt.win.w.height=288;fmt.win.field=ANY;fmt.win.chromakey=0;fmt.win.clips=0x9414cb4;fmt.win.clipcount=0;fmt.win.bitmap=(nil)): 
Invalid argument
ioctl: VIDIOC_OVERLAY(int=0): Invalid argument
ioctl: 
VIDIOC_TRY_FMT(type=VIDEO_OVERLAY;fmt.win.w.left=3;fmt.win.w.top=48;fmt.win.w.width=384;fmt.win.w.height=288;fmt.win.field=ANY;fmt.win.chromakey=0;fmt.win.clips=(nil);fmt.win.clipcount=0;fmt.win.bitmap=(nil)): 
Invalid argument
ioctl: 
VIDIOC_S_FMT(type=VIDEO_OVERLAY;fmt.win.w.left=3;fmt.win.w.top=48;fmt.win.w.width=384;fmt.win.w.height=288;fmt.win.field=ANY;fmt.win.chromakey=0;fmt.win.clips=0x9414cb4;fmt.win.clipcount=1;fmt.win.bitmap=(nil)): 
Invalid argument
ioctl: VIDIOC_OVERLAY(int=0): Invalid argument
[Ian@localhost ~]$

Also, the screen is black, although the camera was turned on.

I feel that it is trying to tell me something - but I do not understand 
what it is saying.  Is there any hope?

Ian

-- 
Ian Davidson
239 Streetsbrook Road, Solihull, West Midlands, B91 1HE
-- 
Facts used in this message may or may not reflect an underlying objective reality. 
Facts are supplied for personal use only. 
Recipients quoting supplied information do so at their own risk. 
Facts supplied may vary in whole or part from widely accepted standards. 
While painstakingly researched, facts may or may not be indicative of actually occurring events or natural phenomena. 
The author accepts no responsibility for personal loss or injury resulting from memorisation and subsequent use.


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
