Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:46475 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754751Ab0BABRy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Jan 2010 20:17:54 -0500
Subject: Re: [PATCH] saa7134: Fix IR support of some ASUS TV-FM 7135
	variants
From: hermann pitton <hermann-pitton@arcor.de>
To: Jean Delvare <khali@linux-fr.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	LMML <linux-media@vger.kernel.org>, Daro <ghost-rider@aster.pl>,
	Roman Kellner <muzungu@gmx.net>
In-Reply-To: <20100130115632.03da7e1b@hyperion.delvare>
References: <20100127120211.2d022375@hyperion.delvare>
	 <4B630179.3080006@redhat.com> <1264812461.16350.90.camel@localhost>
	 <20100130115632.03da7e1b@hyperion.delvare>
Content-Type: text/plain
Date: Mon, 01 Feb 2010 02:16:35 +0100
Message-Id: <1264986995.21486.20.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all interested,

Am Samstag, den 30.01.2010, 11:56 +0100 schrieb Jean Delvare:
> Hi Mauro, Hermann,
> 
> On Sat, 30 Jan 2010 01:47:41 +0100, hermann pitton wrote:
> > Am Freitag, den 29.01.2010, 13:40 -0200 schrieb Mauro Carvalho Chehab:
> > > Jean Delvare wrote:
> > > > From: Jean Delvare <khali@linux-fr.org>
> > > > Subject: saa7134: Fix IR support of some ASUS TV-FM 7135 variants
> > > > 
> > > > Some variants of the ASUS TV-FM 7135 are handled as the ASUSTeK P7131
> > > > Analog (card=146). However, by the time we find out, some
> > > > card-specific initialization is missed. In particular, the fact that
> > > > the IR is GPIO-based. Set it when we change the card type.
> > > > 
> > > > We also have to move the initialization of IR until after the card
> > > > number has been changed. I hope that this won't cause any problem.
> > > 
> > > Hi Jean,
> > > 
> > > Moving the initialization will likely cause regressions. The reason why there
> > > are two init codes there were due to the way the old i2c code used to work.
> > > This got fixed after the i2c rework, but it caused regressions on that time.
> 
> I don't think there is any problem with having two init sequences. You
> need the EEPROM to identify some devices, you need I2C support to
> access the EEPROM, and you need some initialization to get I2C
> operational.
> 
> This doesn't mean that some adjustments to the exact sequence aren't
> possible. In particular, I don't see what else can depend on IR being
> initialized, so I can't really see what harm can be done in moving IR
> init code _later_ in the sequence. Looking at saa7134_input_init1(), I
> see that it is essentially setting up software parameters in the
> saa7134_dev structure, there is almost no hardware access. Only for a
> few cards, we change a couple bits in registers GPIO_GPMODE* and
> GPIO_GPSTATUS*. I honestly can't see how doing this _later_ in the init
> sequence could be a problem.
> 
> > > The proper way would be to just muve the IR initialization on this board
> > > from init1 to init2, instead of changing it for all other devices.
> 
> Hmm, OK. I think it's wrong, but I'm not the one to decide. Patch below.
> 
> > Mauro, I do agree with you that it is likely better to go a way with
> > minimum chances for regressions, also given the current testing base and
> > that only this single card is involved..
> 
> I admit I am very surprised that we apparently can't get anyone to test
> changes to a driver that supports 176 different models of TV cards :(
> 
> > Do we end up with something card specific in core code here?
> > After all, we know this is a no go.
> > 
> > Hartmut and me thought back and forth on how to deal with it for quite
> > some while, unfortunately Hartmut is not present currently on the list,
> > but he voted for to have a separate entry for that card finally too.
> > 
> > What we seem to have now is:
> > 
> > 1. We don't know, if Jean's patch really would cause regressions,
> >    but it is likely hard to get all the testing done. No problems with a
> >    FlyVideo3000 gpio remote at the time Roman suggested it, but I had
> >    not any i2c remote that time ...
> 
> I doubt it matters, given that saa7134_input_init1() only cares about
> GPIO-based IR:
> 
> int saa7134_input_init1(struct saa7134_dev *dev)
> {
> 	(...)
> 	if (dev->has_remote != SAA7134_REMOTE_GPIO)
> 		return -ENODEV;
> 
> So the moving the call to this function should have no effect on boards
> with I2C-based IR.
> 
> > (...)
> > Given what is also in the cruft for bttv, I would not care too much for
> > that single card on that now also ancient driver, just print what the
> > user can do to escape and any google would find it quickly too. For Asus
> > it is a unique problem on that driver so far.
> 
> This isn't how we're going to make Linux popular.
> 
> > I should have some time on Sunday afternoon for testing, if we should go
> > that way.
> 
> Any testing you can provide is very welcome, thanks.
> 
> * * * * *
> 
> From: Jean Delvare <khali@linux-fr.org>
> Subject: saa7134: Fix IR support of some ASUS TV-FM 7135 variants
> 
> Some variants of the ASUS TV-FM 7135 are handled as the ASUSTeK P7131
> Analog (card=146). However, by the time we find out, some
> card-specific initialization is missed. In particular, the fact that
> the IR is GPIO-based. Set it when we change the card type, and run
> saa7134_input_init1().
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: Daro <ghost-rider@aster.pl>
> Cc: Roman Kellner <muzungu@gmx.net>
> ---
>  linux/drivers/media/video/saa7134/saa7134-cards.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> --- v4l-dvb.orig/linux/drivers/media/video/saa7134/saa7134-cards.c	2010-01-30 10:56:50.000000000 +0100
> +++ v4l-dvb/linux/drivers/media/video/saa7134/saa7134-cards.c	2010-01-30 11:52:18.000000000 +0100
> @@ -7299,6 +7299,11 @@ int saa7134_board_init2(struct saa7134_d
>  		       printk(KERN_INFO "%s: P7131 analog only, using "
>  						       "entry of %s\n",
>  		       dev->name, saa7134_boards[dev->board].name);
> +
> +			/* IR init has already happened for other cards, so
> +			 * we have to catch up. */
> +			dev->has_remote = SAA7134_REMOTE_GPIO;
> +			saa7134_input_init1(dev);
>  	       }
>  	       break;
>  	case SAA7134_BOARD_HAUPPAUGE_HVR1150:
> 

we had more than 50cm of snow within the last two days and it is still
going on. The garden is already good for some ski jumping ...

For now, I only faked a P7131 Dual with a broken IR receiver on a 2.6.29
with recent, you can see that gpio 0x40000 doesn't go high, but your
patch should enable the remote on that P7131 analog only.

Seems Daro is on the list, please test it too for _auto detection_ on
the real device..

We must keep drivers simple enough to be maintainable, so, since Mauro
does maintain the saa7134 finally too these times, we should start here.

I'm open for all other possible improvements, but we should only
implement them, if real hardware is really in need of.

Cheers,
Hermann

saa7134[0] Tuner type is 63
tuner 2-0043: chip found @ 0x86 (saa7134[0])
tda9887 2-0043: creating new instance
tda9887 2-0043: tda988[5/6/7] found
tuner 2-0043: type set to tda9887
tuner 2-0043: tv freq set to 0.00
tuner 2-0043: TV freq (0.00) out of range (44-958)
tuner 2-0043: saa7134[0] tuner I2C addr 0x86 with type 74 used for 0x0e
tuner 2-0061: Setting mode_mask to 0x0e
tuner 2-0061: chip found @ 0xc2 (saa7134[0])
tuner 2-0061: tuner 0x61: Tuner type absent
tuner 2-0043: Calling set_type_addr for type=63, addr=0xff, mode=0x0e, config=0x00
tuner 2-0043: set addr discarded for type 74, mask e. Asked to change tuner at addr 0xff, with mask e
tuner 2-0061: Calling set_type_addr for type=63, addr=0xff, mode=0x0e, config=0x00
tuner 2-0061: defining GPIO callback
tuner-simple 2-0061: creating new instance
tuner-simple 2-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
tuner 2-0061: type set to Philips FMD1216ME MK3 Hybrid Tuner
tuner 2-0061: tv freq set to 400.00
tuner 2-0061: saa7134[0] tuner I2C addr 0xc2 with type 63 used for 0x0e
tuner 2-0043: switching to v4l2
tuner 2-0061: switching to v4l2
tuner 2-0061: tv freq set to 400.00
tuner 2-0061: tv freq set to 400.00
tuner 2-0043: Putting tuner to sleep
tuner 2-0043: Cmd s_power accepted for analog TV
tuner 2-0061: Putting tuner to sleep
tuner 2-0061: Cmd s_power accepted for analog TV
saa7134[0]: registered device video0 [v4l2]
saa7134[0]: registered device vbi0
saa7134[0]: registered device radio0
saa7133[1]: setting pci latency timer to 64
saa7133[1]: found at 0000:01:08.0, rev: 208, irq: 18, latency: 64, mmio: 0xe8001000
saa7133[1]: subsystem: 1043:4862, board: ASUSTeK P7131 Dual [card=78,autodetected]
saa7133[1]: board init: gpio is 0
IRQ 18/saa7133[1]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7133[1]: i2c eeprom 00: 43 10 62 48 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7133[1]: i2c eeprom 10: 00 01 20 00 ff 20 ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom 20: 01 40 01 02 03 01 01 03 08 ff 00 d6 ff ff ff ff
saa7133[1]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom 40: ff 21 00 c2 96 10 03 32 15 00 ff ff ff ff ff ff
saa7133[1]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[1]: P7131 analog only, using entry of ASUSTeK P7131 Analog
input: saa7134 IR (ASUSTeK P7131 Analo as /class/input/input8
Creating IR device irrcv0
tuner 3-004b: tda829x detected
tuner 3-004b: Setting mode_mask to 0x0e
tuner 3-004b: chip found @ 0x96 (saa7133[1])
tuner 3-004b: tuner 0x4b: Tuner type absent
tuner 3-004b: Calling set_type_addr for type=54, addr=0xff, mode=0x0e, config=0x00
tuner 3-004b: defining GPIO callback
tda829x 3-004b: setting tuner address to 61
tda829x 3-004b: type set to tda8290+75a
tuner 3-004b: type set to tda8290+75a
tuner 3-004b: tv freq set to 400.00
tuner 3-004b: saa7133[1] tuner I2C addr 0x96 with type 54 used for 0x0e
tuner 3-004b: switching to v4l2
tuner 3-004b: tv freq set to 400.00
tuner 3-004b: tv freq set to 400.00
tuner 3-004b: Putting tuner to sleep
tuner 3-004b: Cmd s_power accepted for analog TV
saa7133[1]: registered device video1 [v4l2]
saa7133[1]: registered device vbi1
saa7133[1]: registered device radio1
saa7133[2]: setting pci latency timer to 64
saa7133[2]: found at 0000:01:09.0, rev: 209, irq: 17, latency: 64, mmio: 0xe8002000
saa7133[2]: subsystem: 16be:0010, board: Medion/Creatix CTX953 Hybrid [card=134,autodetected]
saa7133[2]: board init: gpio is 0
IRQ 17/saa7133[2]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7133[2]: i2c eeprom 00: be 16 10 00 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7133[2]: i2c eeprom 10: 00 ff 86 0f ff 20 ff 00 01 50 32 79 01 3c ca 50
saa7133[2]: i2c eeprom 20: 01 40 01 02 02 03 01 00 06 ff 00 2c 02 51 96 2b
saa7133[2]: i2c eeprom 30: a7 58 7a 1f 03 8e 84 5e da 7a 04 b3 05 87 b2 3c
saa7133[2]: i2c eeprom 40: ff 21 00 c0 96 10 03 22 15 00 fd 79 44 9f c2 8f
saa7133[2]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tuner 4-004b: tda829x detected
tuner 4-004b: Setting mode_mask to 0x0e
tuner 4-004b: chip found @ 0x96 (saa7133[2])
tuner 4-004b: tuner 0x4b: Tuner type absent
tuner 4-004b: Calling set_type_addr for type=54, addr=0xff, mode=0x0e, config=0x00
tuner 4-004b: defining GPIO callback
tda829x 4-004b: setting tuner address to 60
tda829x 4-004b: type set to tda8290+75a
tuner 4-004b: type set to tda8290+75a
tuner 4-004b: tv freq set to 400.00
tuner 4-004b: saa7133[2] tuner I2C addr 0x96 with type 54 used for 0x0e
tuner 4-004b: switching to v4l2
tuner 4-004b: tv freq set to 400.00
tuner 4-004b: tv freq set to 400.00
tuner 4-004b: Putting tuner to sleep
tuner 4-004b: Cmd s_power accepted for analog TV
saa7133[2]: registered device video2 [v4l2]
saa7133[2]: registered device vbi2
saa7134[3]: setting pci latency timer to 64
saa7134[3]: found at 0000:01:0a.0, rev: 1, irq: 16, latency: 64, mmio: 0xe8003000
saa7134[3]: subsystem: 5168:0138, board: LifeView FlyVIDEO3000 [card=2,autodetected]
saa7134[3]: board init: gpio is 39000
saa7134[3]: there are different flyvideo cards with different tuners
saa7134[3]: out there, you might have to use the tuner=<nr> insmod
saa7134[3]: option to override the default value.
input: saa7134 IR (LifeView FlyVIDEO30 as /class/input/input9
Creating IR device irrcv1
IRQ 16/saa7134[3]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7134[3]: i2c eeprom 00: 68 51 38 01 10 28 ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[3]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tuner 5-0061: Setting mode_mask to 0x0e
tuner 5-0061: chip found @ 0xc2 (saa7134[3])
tuner 5-0061: tuner 0x61: Tuner type absent
tuner 5-0061: Calling set_type_addr for type=5, addr=0xff, mode=0x0e, config=0x00
tuner 5-0061: defining GPIO callback
tuner-simple 5-0061: creating new instance
tuner-simple 5-0061: type set to 5 (Philips PAL_BG (FI1216 and compatibles))
tuner 5-0061: type set to Philips PAL_BG (FI1216 and compatibles)
tuner 5-0061: tv freq set to 400.00
tuner 5-0061: saa7134[3] tuner I2C addr 0xc2 with type 5 used for 0x0e
tuner 5-0061: switching to v4l2
tuner 5-0061: tv freq set to 400.00
tuner 5-0061: tv freq set to 400.00
tuner 5-0061: Putting tuner to sleep
tuner 5-0061: Cmd s_power accepted for analog TV
saa7134[3]: registered device video3 [v4l2]
saa7134[3]: registered device vbi3
saa7134[3]: registered device radio2
dvb_init() allocating 1 frontend
tuner-simple 2-0061: attaching existing instance
tuner-simple 2-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
DVB: registering new adapter (saa7134[0])
DVB: registering adapter 0 frontend 0 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 53MHz sampling clock
tda1004x: found firmware revision 26 -- ok
dvb_init() allocating 1 frontend
DVB: registering new adapter (saa7133[2])
DVB: registering adapter 1 frontend 0 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision 26 -- ok





