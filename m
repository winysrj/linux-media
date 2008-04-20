Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3K0mGFA003792
	for <video4linux-list@redhat.com>; Sat, 19 Apr 2008 20:48:16 -0400
Received: from mail-in-06.arcor-online.net (mail-in-06.arcor-online.net
	[151.189.21.46])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3K0m2tl024318
	for <video4linux-list@redhat.com>; Sat, 19 Apr 2008 20:48:02 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: ian@pickworth.me.uk
In-Reply-To: <480A5CC3.6030408@pickworth.me.uk>
References: <480A5CC3.6030408@pickworth.me.uk>
Content-Type: text/plain
Date: Sun, 20 Apr 2008 02:47:54 +0200
Message-Id: <1208652474.14680.8.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Hauppauge WinTV regreession from 2.6.24 to 2.6.25
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

Am Samstag, den 19.04.2008, 21:57 +0100 schrieb Ian Pickworth:
> I am testing a kernel upgrade from 2.6.24.to 2.6.25, and the drivers for 
>    the Hauppauge WinTV appear to have suffered some regression between 
> the two kernel versions.
> 
> The problem is that the tuner is not being detected and set correctly 
> for either the video or the radio device on the card.
> 
> Details are below - the problem appears to be in the detection of the 
> tuner type from the tda9887 chip not then being picked up by the tuner 
> module. So, in 2.6.24 it successfully gets:
> 
> tuner-simple 4-0061: type set to 38 (Philips PAL/SECAM multi (FM1216ME MK3))
> 
> but in 2.6.25 it seems to fail:
> 
> tuner' 4-0061: tuner type not set
> 
> I'm not sure what more information I can provide - if anything will help 
> diagnose the problem better please shout. I am just using the stock 
> Gentoo kernel by the way - drivers are as they come with the kernel 
> release in both cases.
> 
> Regards
> Ian
> 

nice to hear from you!

I don't have that tuner in any box currently and the variant I had was
always a _little_ bit critical in standard PCI slots.

Ian, are you sure that it is the released 2.6.25 showing that?

Than we should have some alert around.

Cheers,
Hermann


> For kernel 2.6.25, the system log shows:
> 
> ---------------
> [   43.473742] Linux video capture interface: v2.00
> [   43.485230] cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
> [   43.485529] ACPI: PCI Interrupt Link [LNK1] enabled at IRQ 11
> [   43.485532] ACPI: PCI Interrupt 0000:01:0a.0[A] -> Link [LNK1] -> GSI 
> 11 (level, low) -> IRQ 11
> [   43.485697] cx88[0]: subsystem: 0070:3401, board: Hauppauge WinTV 
> 34xxx models [card=1,autodetected]
> [   43.485700] cx88[0]: TV tuner type -1, Radio tuner type -1
> [   43.695400] tuner' 4-0043: chip found @ 0x86 (cx88[0])
> [   43.695406] tda9887 4-0043: tda988[5/6/7] found
> [   43.699724] tuner' 4-0061: chip found @ 0xc2 (cx88[0])
> [   43.754465] tveeprom 4-0050: Hauppauge model 34519, rev J157, serial# 
> 2906136
> [   43.754470] tveeprom 4-0050: tuner model is Philips FM1216 ME MK3 
> (idx 57, type 38)
> [   43.754473] tveeprom 4-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') 
> PAL(D/D1/K) (eeprom 0x74)
> [   43.754476] tveeprom 4-0050: audio processor is CX881 (idx 31)
> [   43.754478] tveeprom 4-0050: has radio
> [   43.754480] cx88[0]: hauppauge eeprom: model=34519
> [   43.771239] input: cx88 IR (Hauppauge WinTV 34xxx  as /class/input/input7
> [   43.800173] cx88[0]/0: found at 0000:01:0a.0, rev: 5, irq: 11, 
> latency: 32, mmio: 0xe9000000
> [   43.800237] cx88[0]/0: registered device video0 [v4l2]
> [   43.800253] cx88[0]/0: registered device vbi0
> [   43.800270] cx88[0]/0: registered device radio0
> [   43.800342] tuner' 4-0061: tuner type not set
> [   43.834391] cx2388x alsa driver version 0.0.6 loaded
> [   43.834450] ACPI: PCI Interrupt 0000:01:0a.1[A] -> Link [LNK1] -> GSI 
> 11 (level, low) -> IRQ 11
> [   43.834477] cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
> -----------------------------
> 
> and for 2.6.24 it shows:
> ----------------------
> Apr 19 16:59:24 ian2 kernel: [   92.488289] Linux video capture 
> interface: v2.00
> Apr 19 16:59:24 ian2 kernel: [   92.498392] cx88/0: cx2388x v4l2 driver 
> version 0.0.6 loaded
> Apr 19 16:59:24 ian2 kernel: [   92.498688] ACPI: PCI Interrupt Link 
> [LNK1] enabled at IRQ 11
> Apr 19 16:59:24 ian2 kernel: [   92.498691] ACPI: PCI Interrupt 
> 0000:01:0a.0[A] -> Link [LNK1] -> GSI 11 (level, low) -> IRQ 11
> Apr 19 16:59:24 ian2 kernel: [   92.498738] cx88[0]: subsystem: 
> 0070:3401, board: Hauppauge WinTV 34xxx models [card=1,autodetected]
> Apr 19 16:59:24 ian2 kernel: [   92.498740] cx88[0]: TV tuner type -1, 
> Radio tuner type -1
> Apr 19 16:59:24 ian2 kernel: [   92.661117] tveeprom 4-0050: Hauppauge 
> model 34519, rev J157, serial# 2906136
> Apr 19 16:59:24 ian2 kernel: [   92.661123] tveeprom 4-0050: tuner model 
> is Philips FM1216 ME MK3 (idx 57, type 38)
> Apr 19 16:59:24 ian2 kernel: [   92.661126] tveeprom 4-0050: TV 
> standards PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K) (eeprom 0x74)
> Apr 19 16:59:24 ian2 kernel: [   92.661129] tveeprom 4-0050: audio 
> processor is CX881 (idx 31)
> Apr 19 16:59:24 ian2 kernel: [   92.661131] tveeprom 4-0050: has radio
> Apr 19 16:59:24 ian2 kernel: [   92.661133] cx88[0]: hauppauge eeprom: 
> model=34519
> Apr 19 16:59:24 ian2 kernel: [   92.677844] input: cx88 IR (Hauppauge 
> WinTV 34xxx  as /devices/pci0000:00/0000:00:08.0/0000:01:0a.0/input/input7
> Apr 19 16:59:24 ian2 kernel: [   92.705395] cx88[0]/0: found at 
> 0000:01:0a.0, rev: 5, irq: 11, latency: 32, mmio: 0xe9000000
> Apr 19 16:59:24 ian2 kernel: [   92.716039] tuner 4-0043: chip found @ 
> 0x86 (cx88[0])
> Apr 19 16:59:24 ian2 kernel: [   92.716064] tda9887 4-0043: 
> tda988[5/6/7] found @ 0x43 (tuner)
> Apr 19 16:59:24 ian2 kernel: [   92.716066] tuner 4-0043: type set to 
> tda9887
> Apr 19 16:59:24 ian2 kernel: [   92.718643] tuner 4-0061: chip found @ 
> 0xc2 (cx88[0])
> Apr 19 16:59:24 ian2 kernel: [   92.718655] tuner-simple 4-0061: type 
> set to 38 (Philips PAL/SECAM multi (FM1216ME MK3))
> Apr 19 16:59:24 ian2 kernel: [   92.718658] tuner 4-0061: type set to 
> Philips PAL/SECAM m
> Apr 19 16:59:24 ian2 kernel: [   92.718661] tuner-simple 4-0061: type 
> set to 38 (Philips PAL/SECAM multi (FM1216ME MK3))
> Apr 19 16:59:24 ian2 kernel: [   92.718663] tuner 4-0061: type set to 
> Philips PAL/SECAM m
> Apr 19 16:59:24 ian2 kernel: [   92.740419] cx88[0]/0: registered device 
> video0 [v4l2]
> Apr 19 16:59:24 ian2 kernel: [   92.740438] cx88[0]/0: registered device 
> vbi0
> Apr 19 16:59:24 ian2 kernel: [   92.740453] cx88[0]/0: registered device 
> radio0
> Apr 19 16:59:24 ian2 kernel: [   92.778001] cx2388x alsa driver version 
> 0.0.6 loaded
> Apr 19 16:59:24 ian2 kernel: [   92.778064] ACPI: PCI Interrupt 
> 0000:01:0a.1[A] -> Link [LNK1] -> GSI 11 (level, low) -> IRQ 11
> Apr 19 16:59:24 ian2 kernel: [   92.778094] cx88[0]/1: CX88x/0: ALSA 
> support for cx2388x boards
> -----------------------------
> 
> --


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
