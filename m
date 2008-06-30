Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5U1tgQn026076
	for <video4linux-list@redhat.com>; Sun, 29 Jun 2008 21:55:42 -0400
Received: from mail9.dslextreme.com (mail9.dslextreme.com [66.51.199.94])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m5U1tLII014342
	for <video4linux-list@redhat.com>; Sun, 29 Jun 2008 21:55:22 -0400
Message-ID: <48683B2F.7000407@gimpelevich.san-francisco.ca.us>
Date: Sun, 29 Jun 2008 18:47:27 -0700
From: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
References: <20050806200358.12455.qmail@web60322.mail.yahoo.com>
	<200803161724.20459.peter.missel@onlinehome.de>
	<pan.2008.03.16.17.00.26.941363@gimpelevich.san-francisco.ca.us>
	<200803161840.37910.peter.missel@onlinehome.de>
	<pan.2008.03.16.17.49.51.923202@gimpelevich.san-francisco.ca.us>
	<1206573402.3912.50.camel@pc08.localdom.local>
	<653f28469c9babb5326973c119fd78db@gimpelevich.san-francisco.ca.us>
	<loom.20080627T025843-957@post.gmane.org>
	<1214599398.2640.23.camel@pc10.localdom.local>
	<486597B6.2010300@gimpelevich.san-francisco.ca.us>
	<1214778949.8680.18.camel@pc10.localdom.local>
In-Reply-To: <1214778949.8680.18.camel@pc10.localdom.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, mchehab@infradead.org
Subject: Re: [PATCH] Re: LifeVideo To-Go Cardbus, tuner problems
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

hermann pitton wrote:
>>> And as said, send at least relevant dmesg output when loading the driver
>>> and tuner modules, preferably with i2c_scan=1 enabled.
>> I would need to borrow the card again to do that, and I'm not sure it 
>> would be all that useful for differentiation.
> 
> OK, but this is exactly what should not happen.

I have requested the card's owner to provide that; it is at the bottom 
of this message, both with and without i2c_scan=1.

>>> As just seen with an early Compro saa7133, we have no safety, that not
>>> later on devices appear with the same PCI subsystem, which are in fact
>>> different, and have no means then to keep the auto detection working
>>> without such potentially useful information.
>> Seems to me that the contents of the tveeprom may be a more reliable 
>> mechanism.
> 
> How you mean?
> 
> Having at least "dmesg" with the eeprom dump and gpio init of the card
> is the minimum prerequisite to even think about it.
> 
> Only Hauppauge provides support for what they are encoding in the
> eeprom.
> 
> Philips has a standard for eeprom programming, manufacturers are advised
> to go with, but do they?
> 
> For sure not.
> 
> Since win98 at least they modified eeprom content at their behalves,
> most obviously are the differences for tuner enumeration, but kept the
> original Philips driver file names to render each other useless by
> overriding the files.
> 
> Best so far that time was, "please uninstall all other TV cards and
> drivers on your system", before you try ours.
> 
> Since some time you can find something with !!! in the Philips/NXP
> drivers there, _not_ to continue to do so.

That's unfortunate, and in my first post on this matter, I wanted to 
avoid autodetection altogether.

> You/we don't know if it is a saa7133/35 or 7131e bridge.
> 
> You/we don't know if it is a tda8275, tda8275c1, tda8275a or tda8275ac1
> tuner.

Correct, and I think Mauro should not have overlooked your objection to 
committing the patch.

[96653.944000] pccard: CardBus card inserted into slot 0
[96653.944000] PCI: Enabling device 0000:03:00.0 (0000 -> 0002)
[96653.944000] ACPI: PCI Interrupt 0000:03:00.0[A] -> Link [LNKF] -> GSI
9 (level, low) -> IRQ 9
[96653.944000] saa7133[0]: found at 0000:03:00.0, rev: 240, irq: 9,
latency: 0, mmio: 0x34000000
[96653.944000] PCI: Setting latency timer of device 0000:03:00.0 to 64
[96653.944000] saa7133[0]: subsystem: 5169:1502, board: LifeView FlyTV
Platinum Mini [card=39,insmod option]
[96653.944000] saa7133[0]: board init: gpio is c010000
[96654.120000] tuner 0-004b: chip found @ 0x96 (saa7133[0])
[96654.168000] tuner 0-004b: setting tuner address to 61
[96654.208000] tuner 0-004b: type set to tda8290+75
[96655.856000] tuner 0-004b: setting tuner address to 61
[96655.896000] tuner 0-004b: type set to tda8290+75
[96657.524000] saa7133[0]: i2c eeprom 00: 69 51 02 15 54 20 1c 00 43 43
a9 1c 55 d2 b2 92
[96657.524000] saa7133[0]: i2c eeprom 10: 00 ff 22 0f ff 20 ff ff ff ff
ff ff ff ff ff ff
[96657.524000] saa7133[0]: i2c eeprom 20: 01 40 01 03 03 01 01 03 08 ff
01 bb ff ff ff ff
[96657.524000] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[96657.524000] saa7133[0]: i2c eeprom 40: ff 14 00 c2 96 ff 00 ff ff ff
ff ff ff ff ff ff
[96657.524000] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[96657.524000] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[96657.524000] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[96657.540000] saa7133[0]: i2c scan: found device @ 0x96  [???]
[96657.548000] saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]
[96660.632000] saa7133[0]: registered device video0 [v4l2]
[96660.632000] saa7133[0]: registered device vbi0
[96660.632000] saa7133[0]/alsa: saa7133[0] at 0x34000000 irq 9
registered as card -2


==============
[95421.776000] pccard: CardBus card inserted into slot 0
[95422.280000] Linux video capture interface: v2.00
[95422.492000] saa7130/34: v4l2 driver version 0.2.14 loaded
[95422.492000] PCI: Enabling device 0000:03:00.0 (0000 -> 0002)
[95422.492000] ACPI: PCI Interrupt 0000:03:00.0[A] -> Link [LNKF] -> GSI
9 (level, low) -> IRQ 9
[95422.492000] saa7133[0]: found at 0000:03:00.0, rev: 240, irq: 9,
latency: 0, mmio: 0x34000000
[95422.492000] PCI: Setting latency timer of device 0000:03:00.0 to 64
[95422.492000] saa7133[0]: subsystem: 5169:1502, board: LifeView FlyTV
Platinum Mini [card=39,insmod option]
[95422.492000] saa7133[0]: board init: gpio is c010000
[95422.628000] saa7133[0]: i2c eeprom 00: 69 51 02 15 54 20 1c 00 43 43
a9 1c 55 d2 b2 92
[95422.628000] saa7133[0]: i2c eeprom 10: 00 ff 22 0f ff 20 ff ff ff ff
ff ff ff ff ff ff
[95422.628000] saa7133[0]: i2c eeprom 20: 01 40 01 03 03 01 01 03 08 ff
01 bb ff ff ff ff
[95422.628000] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[95422.628000] saa7133[0]: i2c eeprom 40: ff 14 00 c2 96 ff 00 ff ff ff
ff ff ff ff ff ff
[95422.628000] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[95422.628000] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[95422.628000] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[95423.152000] tuner 0-004b: chip found @ 0x96 (saa7133[0])
[95423.200000] tuner 0-004b: setting tuner address to 61
[95423.240000] tuner 0-004b: type set to tda8290+75
[95425.088000] tuner 0-004b: setting tuner address to 61
[95425.132000] tuner 0-004b: type set to tda8290+75
[95426.860000] saa7133[0]: registered device video0 [v4l2]
[95426.860000] saa7133[0]: registered device vbi0
[95427.116000] saa7134 ALSA driver for DMA sound loaded
[95427.116000] saa7133[0]/alsa: saa7133[0] at 0x34000000 irq 9
registered as card -2

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
