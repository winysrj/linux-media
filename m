Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6TKnLUT027492
	for <video4linux-list@redhat.com>; Tue, 29 Jul 2008 16:49:21 -0400
Received: from mail-in-12.arcor-online.net (mail-in-12.arcor-online.net
	[151.189.21.52])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6TKn67i014528
	for <video4linux-list@redhat.com>; Tue, 29 Jul 2008 16:49:07 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Ian.Davidson@bigfoot.com
In-Reply-To: <488C9266.7010108@blueyonder.co.uk>
References: <488C9266.7010108@blueyonder.co.uk>
Content-Type: text/plain
Date: Tue, 29 Jul 2008 22:42:58 +0200
Message-Id: <1217364178.2699.17.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: Video 4 Linux <video4linux-list@redhat.com>
Subject: Re: xawtv - no picture
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

Hi Ian,

Am Sonntag, den 27.07.2008, 16:21 +0100 schrieb Ian Davidson:
> I am trying to run xawtv (or actually streamer) to capture video - but 
> at the moment, it is not working.
> 
> For details of my system, please see 
> http://www.smolts.org/client/show_all/pub_86fd06ee-583b-40d2-b23b-92749309023b
> 
> I have a K-World DVB-T 210SE card which I hope will allow me to capture 
> the video (although that is not very evident in the above link)
> 
> Here is a section of the dmesg output
> Linux video capture interface: v2.00
> saa7130/34: v4l2 driver version 0.2.14 loaded
> ACPI: PCI Interrupt 0000:04:02.0[A] -> GSI 18 (level, low) -> IRQ 18
> saa7133[0]: found at 0000:04:02.0, rev: 209, irq: 18, latency: 64, mmio: 
> 0xfebff800
> saa7133[0]: subsystem: 17de:7253, board: UNKNOWN/GENERIC 

that board seems to be not reported yet.

> [card=0,autodetected]

That card=0 has only input on videomux 0 enabled.
This is on most boards composite over the s-video connector.

On KWORLD_DVBT_210 card=114, which is likely close to it or even fully
compatible, the composite over s-video connector is not enabled yet.

Only composite on vmux = 3 and s-video on vmux = 8. Depending on how
composite is connected through the breakout cable, we might need a
section with composite2 vmux = 0 in saa7134-cards.c.

> saa7133[0]: board init: gpio is 100
> parport_pc 00:07: reported by Plug and Play ACPI
> parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
> saa7133[0]: i2c eeprom 00: de 17 53 72 ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: registered device video0 [v4l2]
> saa7133[0]: registered device vbi0
> ppdev: user-space parallel port driver
> 
> When I try to run xawtv, this is what I get
> [Ian@localhost ~]$ xawtv
> This is xawtv-3.95, running on Linux/i686 (2.6.25.10-86.fc9.i686)
> xinerama 0: 1440x900+0+0
> WARNING: No DGA support available for this display.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

> WARNING: couldn't find framebuffer base address, try manual
>          configuration ("v4l-conf -a <addr>")
> ioctl: 
> VIDIOC_TRY_FMT(type=VIDEO_OVERLAY;fmt.win.w.left=3;fmt.win.w.top=48;fmt.win.w.width=384;fmt.win.w.height=288;fmt.win.field=ANY;fmt.win.chromakey=0;fmt.win.clips=(nil);fmt.win.clipcount=0;fmt.win.bitmap=(nil)): 
> Invalid argument
> ioctl: 
> VIDIOC_S_FMT(type=VIDEO_OVERLAY;fmt.win.w.left=3;fmt.win.w.top=48;fmt.win.w.width=384;fmt.win.w.height=288;fmt.win.field=ANY;fmt.win.chromakey=0;fmt.win.clips=0x9414cb4;fmt.win.clipcount=0;fmt.win.bitmap=(nil)): 
> Invalid argument
> ioctl: VIDIOC_OVERLAY(int=0): Invalid argument
> ioctl: 
> VIDIOC_TRY_FMT(type=VIDEO_OVERLAY;fmt.win.w.left=3;fmt.win.w.top=48;fmt.win.w.width=384;fmt.win.w.height=288;fmt.win.field=ANY;fmt.win.chromakey=0;fmt.win.clips=(nil);fmt.win.clipcount=0;fmt.win.bitmap=(nil)): 
> Invalid argument
> ioctl: 
> VIDIOC_S_FMT(type=VIDEO_OVERLAY;fmt.win.w.left=3;fmt.win.w.top=48;fmt.win.w.width=384;fmt.win.w.height=288;fmt.win.field=ANY;fmt.win.chromakey=0;fmt.win.clips=0x9414cb4;fmt.win.clipcount=1;fmt.win.bitmap=(nil)): 
> Invalid argument
> ioctl: VIDIOC_OVERLAY(int=0): Invalid argument
> ioctl: 
> VIDIOC_TRY_FMT(type=VIDEO_OVERLAY;fmt.win.w.left=3;fmt.win.w.top=48;fmt.win.w.width=384;fmt.win.w.height=288;fmt.win.field=ANY;fmt.win.chromakey=0;fmt.win.clips=(nil);fmt.win.clipcount=0;fmt.win.bitmap=(nil)): 
> Invalid argument
> ioctl: 
> VIDIOC_S_FMT(type=VIDEO_OVERLAY;fmt.win.w.left=3;fmt.win.w.top=48;fmt.win.w.width=384;fmt.win.w.height=288;fmt.win.field=ANY;fmt.win.chromakey=0;fmt.win.clips=0x9414cb4;fmt.win.clipcount=1;fmt.win.bitmap=(nil)): 
> Invalid argument
> ioctl: VIDIOC_OVERLAY(int=0): Invalid argument
> ioctl: 
> VIDIOC_TRY_FMT(type=VIDEO_OVERLAY;fmt.win.w.left=3;fmt.win.w.top=48;fmt.win.w.width=384;fmt.win.w.height=288;fmt.win.field=ANY;fmt.win.chromakey=0;fmt.win.clips=(nil);fmt.win.clipcount=0;fmt.win.bitmap=(nil)): 
> Invalid argument
> ioctl: 
> VIDIOC_S_FMT(type=VIDEO_OVERLAY;fmt.win.w.left=3;fmt.win.w.top=48;fmt.win.w.width=384;fmt.win.w.height=288;fmt.win.field=ANY;fmt.win.chromakey=0;fmt.win.clips=0x9414cb4;fmt.win.clipcount=1;fmt.win.bitmap=(nil)): 
> Invalid argument
> ioctl: VIDIOC_OVERLAY(int=0): Invalid argument
> ioctl: 
> VIDIOC_TRY_FMT(type=VIDEO_OVERLAY;fmt.win.w.left=3;fmt.win.w.top=48;fmt.win.w.width=384;fmt.win.w.height=288;fmt.win.field=ANY;fmt.win.chromakey=0;fmt.win.clips=(nil);fmt.win.clipcount=0;fmt.win.bitmap=(nil)): 
> Invalid argument
> ioctl: 
> VIDIOC_S_FMT(type=VIDEO_OVERLAY;fmt.win.w.left=3;fmt.win.w.top=48;fmt.win.w.width=384;fmt.win.w.height=288;fmt.win.field=ANY;fmt.win.chromakey=0;fmt.win.clips=0x9414cb4;fmt.win.clipcount=1;fmt.win.bitmap=(nil)): 
> Invalid argument
> ioctl: VIDIOC_OVERLAY(int=0): Invalid argument
> ioctl: 
> VIDIOC_TRY_FMT(type=VIDEO_OVERLAY;fmt.win.w.left=3;fmt.win.w.top=48;fmt.win.w.width=384;fmt.win.w.height=288;fmt.win.field=ANY;fmt.win.chromakey=0;fmt.win.clips=(nil);fmt.win.clipcount=0;fmt.win.bitmap=(nil)): 
> Invalid argument
> ioctl: 
> VIDIOC_S_FMT(type=VIDEO_OVERLAY;fmt.win.w.left=3;fmt.win.w.top=48;fmt.win.w.width=384;fmt.win.w.height=288;fmt.win.field=ANY;fmt.win.chromakey=0;fmt.win.clips=0x9414cb4;fmt.win.clipcount=0;fmt.win.bitmap=(nil)): 
> Invalid argument
> ioctl: VIDIOC_OVERLAY(int=0): Invalid argument
> ioctl: 
> VIDIOC_TRY_FMT(type=VIDEO_OVERLAY;fmt.win.w.left=3;fmt.win.w.top=48;fmt.win.w.width=384;fmt.win.w.height=288;fmt.win.field=ANY;fmt.win.chromakey=0;fmt.win.clips=(nil);fmt.win.clipcount=0;fmt.win.bitmap=(nil)): 
> Invalid argument
> ioctl: 
> VIDIOC_S_FMT(type=VIDEO_OVERLAY;fmt.win.w.left=3;fmt.win.w.top=48;fmt.win.w.width=384;fmt.win.w.height=288;fmt.win.field=ANY;fmt.win.chromakey=0;fmt.win.clips=0x9414cb4;fmt.win.clipcount=1;fmt.win.bitmap=(nil)): 
> Invalid argument
> ioctl: VIDIOC_OVERLAY(int=0): Invalid argument
> [Ian@localhost ~]$
> 
> Also, the screen is black, although the camera was turned on.
> 
> I feel that it is trying to tell me something - but I do not understand 
> what it is saying.  Is there any hope?
> 
> Ian
> 

On most binary video-card drivers you can't set overlay preview mode
anymore.

You might try to force xawtv -remote -nodga -c /dev/video0 on card=114
to have it in mmap/grabdisplay mode.

Please test whatever you can that we might add the card to auto
detection.

Cheers,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
