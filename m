Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9GLu5su000764
	for <video4linux-list@redhat.com>; Thu, 16 Oct 2008 17:56:05 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9GLtsD5013911
	for <video4linux-list@redhat.com>; Thu, 16 Oct 2008 17:55:54 -0400
From: Andy Walls <awalls@radix.net>
To: Dave Huseby <dave@linuxprogrammer.org>
In-Reply-To: <29997427.911224192415143.JavaMail.dave@mycroft>
References: <29997427.911224192415143.JavaMail.dave@mycroft>
Content-Type: text/plain
Date: Thu, 16 Oct 2008 17:57:37 -0400
Message-Id: <1224194257.3119.5.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: strange hauppauge wintv device number
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

On Thu, 2008-10-16 at 14:26 -0700, Dave Huseby wrote:
> Hi Everybody,
> 
> I just bought an old hauppauge wintv card off of ebay and even though it is a model 401--which everybody claims to be supported by linux--it isn't working with tvtime or xawtv.  I noticed that its subsystem id is not detected by the bttv driver in the 2.6 kernel.  Here's the lspci dump:
> 
> 01:01.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capture (rev 11)
>         Subsystem: Hauppauge computer works Inc. Unknown device 03eb    <----- 03eb instead of the usual 13eb
>         Flags: bus master, medium devsel, latency 64, IRQ 21
>         Memory at cfdfe000 (32-bit, prefetchable) [size=4K]
>         Capabilities: [44] Vital Product Data
>         Capabilities: [4c] Power Management version 2
> 
> 01:01.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (rev 11)
>         Subsystem: Hauppauge computer works Inc. Unknown device 03eb    <----- 03eb instead of the usual 13eb
>         Flags: medium devsel, IRQ 21
>         Memory at cfdff000 (32-bit, prefetchable) [size=4K]
>         Capabilities: [44] Vital Product Data
>         Capabilities: [4c] Power Management version 2

A user on the list had a similar problem in early May of this year.  His
device Vendor ID was coming across as 009e instead of 109e for
Brooktree.  He resolved his problem by pulling the card out, blowing the
dust out of the slot, and reinstalling the card.  

Regards,
Andy


> And here's the syslog output from loading the bttv driver:
> 
> Oct 16 08:18:52 mycroft kernel: [38883.101978] bttv: driver version 0.9.17 loaded
> Oct 16 08:18:52 mycroft kernel: [38883.101981] bttv: using 8 buffers with 2080k (520 pages) each for capture
> Oct 16 08:18:52 mycroft kernel: [38883.102021] bttv: Bt8xx card found (0).
> Oct 16 08:18:52 mycroft kernel: [38883.102031] bttv0: Bt878 (rev 17) at 0000:01:01.0, irq: 21, latency: 64, mmio: 0xcfdfe000
> Oct 16 08:18:52 mycroft kernel: [38883.102380] bttv0: subsystem: 0070:03eb (UNKNOWN)
> Oct 16 08:18:52 mycroft kernel: [38883.102382] please mail id, board name and the correct card= insmod option to video4linux-list@redhat.com
> Oct 16 08:18:52 mycroft kernel: [38883.102384] bttv0: using:  *** UNKNOWN/GENERIC ***  [card=0,autodetected]
> Oct 16 08:18:52 mycroft kernel: [38883.102408] bttv0: gpio: en=00000000, out=00000000 in=00ffffdb [init]
> Oct 16 08:18:52 mycroft kernel: [38883.107044] tuner 0-0061: chip found @ 0xc2 (bt878 #0 [sw])
> Oct 16 08:18:52 mycroft kernel: [38883.151676] bttv0: detected by eeprom: Hauppauge (bt848) [card=2]
> Oct 16 08:18:52 mycroft kernel: [38883.182590] tveeprom 0-0050: Hauppauge model 61381, rev D423, serial# 1908220
> Oct 16 08:18:52 mycroft kernel: [38883.182593] tveeprom 0-0050: tuner model is Philips FM1236 (idx 23, type 2)
> Oct 16 08:18:52 mycroft kernel: [38883.182596] tveeprom 0-0050: TV standards NTSC(M) (eeprom 0x08)
> Oct 16 08:18:52 mycroft kernel: [38883.182598] tveeprom 0-0050: audio processor is MSP3430 (idx 7)
> Oct 16 08:18:52 mycroft kernel: [38883.182600] tveeprom 0-0050: has radio
> Oct 16 08:18:52 mycroft kernel: [38883.182601] bttv0: Hauppauge eeprom indicates model#61381
> Oct 16 08:18:52 mycroft kernel: [38883.182603] bttv0: tuner type=2
> Oct 16 08:18:52 mycroft kernel: [38883.182608] tuner-simple 0-0061: type set to 2 (Philips NTSC (FI1236,FM1236 and compatibles))
> Oct 16 08:18:52 mycroft kernel: [38883.182611] tuner 0-0061: type set to Philips NTSC (FI123
> Oct 16 08:18:52 mycroft kernel: [38883.182614] bttv0: i2c: checking for MSP34xx @ 0x80... not found
> Oct 16 08:18:52 mycroft kernel: [38883.183217] bttv0: i2c: checking for TDA9875 @ 0xb0... not found
> Oct 16 08:18:52 mycroft kernel: [38883.183820] bttv0: i2c: checking for TDA7432 @ 0x8a... not found
> Oct 16 08:18:52 mycroft kernel: [38883.193182] bttv0: registered device video0
> Oct 16 08:18:52 mycroft kernel: [38883.193307] bttv0: registered device vbi0
> Oct 16 08:18:52 mycroft kernel: [38883.193410] bttv0: registered device radio0
> Oct 16 08:18:52 mycroft kernel: [38883.198385] bt878: AUDIO driver version 0.0.0 loaded
> Oct 16 08:18:52 mycroft kernel: [38883.198413] bt878: Bt878 AUDIO function found (0).
> Oct 16 08:18:52 mycroft kernel: [38883.198426] ACPI: PCI Interrupt 0000:01:01.1[A] -> GSI 22 (level, low) -> IRQ 21
> Oct 16 08:18:52 mycroft kernel: [38883.198432] bt878_probe: card id=[0x3eb0070], Unknown card.
> Oct 16 08:18:52 mycroft kernel: [38883.198432] Exiting..
> Oct 16 08:18:52 mycroft kernel: [38883.198435] ACPI: PCI interrupt for device 0000:01:01.1 disabled
> Oct 16 08:18:52 mycroft kernel: [38883.198440] bt878: probe of 0000:01:01.1 failed with error -22
> Oct 16 08:19:38 mycroft kernel: [38928.738571] bttv0: SCERROCERR @ 24c4d014,bits: FMTCHG* VSYNC* HSYNC* OFLOW* HLOCK* VPRES* 6* 7* I2CDONE* GPINT* 10* RISCI* FBUS* FTRGT* FDSR* PPERR* RIPERR* PABORT* OCERR* SCERR*
> 
> 
> As you can see, the subsystem id is 0070:03eb instead of the usual 0070:13eb as defined in the bttv-cards.c file.  I must have a really old card or one that was recalled or something.  Have anybody ever seen a 03eb?
> 
> I have tried a couple things to try to get it to work.  The first thing I tried was passing the card and tuner parameters to the bttv driver for the usual Hauppauge WinTV config.  That didn't work.  The next thing I tried was editing the bttv-cards.c file in the driver so that it would detect a 03eb device as if it were a 13eb device.  That didn't work either.
> 
> In both cases I keep getting a bunch of errors in my syslog:
> 
> Oct 16 10:11:38 mycroft kernel: [45633.943060] bttv0: SCERROCERR @ 05e3701c,bits: FMTCHG* VSYNC* HSYNC* OFLOW* HLOCK* VPRES* 6* 7* I2CDONE* GPINT* 10* RISCI* FBUS* FTRGT* FDSR* PPERR* RIPERR* PABORT* OCERR* SCERR*
> Oct 16 10:11:38 mycroft kernel: [45633.943091] bttv0: OCERR @ 05e37000,bits: VSYNC HSYNC OFLOW PPERR OCERR*
> Oct 16 10:11:38 mycroft kernel: [45634.004337] bttv0: SCERR @ 05e37014,bits: VSYNC HSYNC OFLOW FBUS PPERR PABORT SCERR*
> Oct 16 10:11:38 mycroft kernel: [45634.004347] bttv0: SCERR @ 05e37000,bits: OFLOW FBUS PPERR SCERR*
> Oct 16 10:11:38 mycroft kernel: [45634.064318] bttv0: SCERR @ 05e37014,bits: VSYNC HSYNC OFLOW FBUS PPERR PABORT SCERR*
> Oct 16 10:11:38 mycroft kernel: [45634.093110] bttv0: OCERR @ 05e37014,bits: VSYNC HSYNC OFLOW FBUS PPERR OCERR*
> 
> Does anybody have any ideas on how to fix this?  I'd love to update the driver to support my card, but I'd have to get the documentation on the EPROM format.
> 
> Thanks ahead of time,
> Dave
> 
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
