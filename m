Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757737Ab3DBWo7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Apr 2013 18:44:59 -0400
Date: Tue, 2 Apr 2013 19:44:52 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/3] em28xx: add support for two buses on em2874 and
 upper
Message-ID: <20130402194452.224c98d5@redhat.com>
In-Reply-To: <515B2B49.8050805@googlemail.com>
References: <1362480928-20382-1-git-send-email-mchehab@redhat.com>
	<CAGoCfiwB9BT2mDQqu2cwsRM-0eraqyxdY0V3fnH+S2RSNiGSdQ@mail.gmail.com>
	<51378067.3000506@googlemail.com>
	<20130318182205.44f44e20@redhat.com>
	<5159C05B.10902@googlemail.com>
	<20130401162205.379bda4f@redhat.com>
	<5159F080.1030503@googlemail.com>
	<20130401191224.4da92bd8@redhat.com>
	<515B2B49.8050805@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 02 Apr 2013 21:02:33 +0200
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:


> > We don't have enough documentation to write a driver for avf4910b. Some
> > developers at the ML are trying to implement support for it for HVR-930C:
> >
> > 	http://www.mail-archive.com/linux-media@vger.kernel.org/msg59296.html
> >
> > There is a code pointed there for avf4910a:
> > 	https://github.com/wurststulle/ngene_2400i/blob/2377b1fd99d91ff355a5e46881ef27ccc87cb376/avf4910a.c
> >
> > Also, maybe to access the avf4910b some different GPIO setting may be needed,
> > as it might be powered off by the GPIO settings initialized at device i
> >
> 
> Yeah, I remember that.
> Anyway, I don't have time for this at the moment.
> I also think this is really Hauppauges job. These devices are still
> expensive (65-100€) but half working only.
> That's why I'm going to do it with all my Hauppauge devices: wait 5
> years and then buy them used for max. 10€.
> Maybe I'll get back to this if it is still not working then and I find
> some free time, but no guarantee... ;)

It's up to you. Even if Hauppauge would be interested on doing it, I
suspect they won't do anything anytime soon, as it may be hard to find
someone at Trident to ack with a source code release, as Trident bankrupted.

I probably won't have any spare time anytime soon for doing that, although
it could be fun. So, perhaps one day I might try to write a driver for
avf4910b, at least to make it work with PAL/M.

> >>>> Removing the temporary switches to bus A makes no difference (as expected).
> >>>>
> >>>>> There are some things there on the init sequence that can be
> >>>>> cleaned/removed. Those sequences generally comes from observing
> >>>>> what the original driver does. While it produces a working driver,
> >>>>> in general, it is not optimized and part of the init sequence can
> >>>>> be removed.
> >>>> Do you want me to send patches to remove these writes ?
> >>>> Which i2c speed settings do you suggest for the HVR-930C and the
> >>>> HTC-Stick (board settings:
> >>>> EM28XX_I2C_FREQ_400_KHZ, code overwrites it with EM28XX_I2C_FREQ_100_KHZ) ?
> >>> Sure. The better would be to even remove the hauppauge_hvr930c_init()
> >>> function, as this is just a hack, and use the setup via the em28xx-cards
> >>> commented entries:
> >>>
> >>> 		.tuner_type   = TUNER_XC5000,
> >>> 		.tuner_addr   = 0x41,
> >>> 		.dvb_gpio     = hauppauge_930c_digital,
> >>> 		.tuner_gpio   = hauppauge_930c_gpio,
> >> Hmm... tuner address is 0x61 for the device I tested !
> >> The register sequences in em28xx-cards.c also seem to be different to
> >> the ones used in hauppauge_hvr930c_init() in em28xx-dvb.c...
> > I'm not telling that the entries there are right. They aren't. If they
> > where working, that data there weren't commented. This device entry
> > started with a clone from Terratec H5, which was the first em28xx
> > device with DRX-K.
> >
> > On Terratec H5, the tuner is different (based on tda8290/tda8275).
> > The current device initialization started as a clone of the code
> > under terratec_h5_init().
> >
> > As it worked like that, the patch author that added support for HVR-930
> > likely didn't touch on it.
> 
> :-/
> So the whole code for these devices is basically a quick and dirty hack.

Yes.

> I also checked the init sequences in em28xx-dvb.c and the GPIO sequences
> and board parameters which are currently commented out...
> 
> No, thank you, I'm not going to touch this under the current circumstances !

Again, it is up to you to do whatever you want with your time ;)

The hack works, so there's no real need to fix it, although doing it
might save some power if the analog demod is turned on while in
digital mode.

> What I'm still going to do is to remove at least these writes to reg
> 0x06 in em28xx-dvb.c.

Ok.

> >
> > The tuner for HVR930C is clearly at 0x61 address, as it can be seen at
> > em28xx-dvb:
> >
> >                 /* Attach xc5000 */
> >                	memset(&cfg, 0, sizeof(cfg));
> >                 cfg.i2c_address  = 0x61;
> >                 cfg.if_khz = 4000;
> >
> >                 if (dvb->fe[0]->ops.i2c_gate_ctrl)
> >                         dvb->fe[0]->ops.i2c_gate_ctrl(dvb->fe[0], 1);
> >                	if (!dvb_attach(xc5000_attach, dvb->fe[0], &dev->i2c_adap[dev->def_i2c_bus],
> >                                 &cfg)) {
> >                         result = -EINVAL;
> >                         goto out_free;
> >                 }
> >
> >> Are you sure this will work for _all_ variants of the HVR-930C ?
> > Well, the current code will only work with a HVR-930C with a xc5000 tuner,
> > a drx-k demod and an em28xx (and an avf4910b analog TV demod).
> >
> > Any other model with a different layout, if are there any, won't work 
> > anyway.
> >
> > While we can't discard that a different model might have a different GPIO
> > setting, Hauppauge tends to keep the GPIO settings equal for the same
> > device brand name. 
> >
> > So, it seems very unlikely that any change here will keep it working for
> > model 16009 while breaking it for other devices.
> 
> Ok, so if the changes work with my device, I can assume it works for the
> others (if existing and working with the current code), too.

Yes.

> >
> >> I think it would be better if you would create those patches.
> >> I really don't like writing patches without completely understanding the
> >> code, not beeing able to test them and commit messages saying "Mauro
> >> told me to do this"... ;)
> >> You also didn't answer my question concerning the i2c speed settings. ;)
> > What question?
> >
> > Each bus may have a different max I2C speed, but the speed should not
> > change on the same I2C bus over the time. If the driver is doing that,
> > this is a bug that needs to be fixed.
> 
> For the HVR-930C and the HTC stick the board setting is 400KHz which we
> overwrite in em28xx-dvb with 100KHz.
> Which means that the current code (if it is really working) uses 100KHz.
> So should I change the board setting to 100KHz when removing these
> writes to be sure we don't break anything ?
> 
> I checked several datasheets of different i2c client devices, but none
> of them says anything concerning the supported i2c speeds...
> Can we assume that all devices are working with 100KHz ? 

You can't really assume anything other than what is done by the original
driver ;)

AFAIKT, most of I2C chips work fine at 100kHz, and even at 400kHz, but
the board's layout might affect the bus speed. Most old analog tuners
only support 10kHz, but I know only a few em28xx devices with those tuners
(I have two such models here).

> And does 400KHz really make things faster ? ;)

Good question. 400kHz is 4 times 100kHz, so, it is obviously faster ;)

A faster firmware load means that the system would boot faster, if the
device is connected (and recognized) during boot time. So, a faster
speed is better for xc5000, for example.

On the other hand, firmware load at 10kHz is very frustrating, as it may
take ~30 seconds to load a firmware, and firmware needs to be loaded
when the tuner is activated.

Regards,
Mauro
