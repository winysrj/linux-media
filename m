Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52399 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758069Ab3DAWMb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Apr 2013 18:12:31 -0400
Date: Mon, 1 Apr 2013 19:12:24 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [PATCH 0/3] em28xx: add support for two buses on em2874 and
 upper
Message-ID: <20130401191224.4da92bd8@redhat.com>
In-Reply-To: <5159F080.1030503@googlemail.com>
References: <1362480928-20382-1-git-send-email-mchehab@redhat.com>
	<CAGoCfiwB9BT2mDQqu2cwsRM-0eraqyxdY0V3fnH+S2RSNiGSdQ@mail.gmail.com>
	<51378067.3000506@googlemail.com>
	<20130318182205.44f44e20@redhat.com>
	<5159C05B.10902@googlemail.com>
	<20130401162205.379bda4f@redhat.com>
	<5159F080.1030503@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 01 Apr 2013 22:39:28 +0200
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Am 01.04.2013 21:22, schrieb Mauro Carvalho Chehab:
> > Em Mon, 01 Apr 2013 19:14:03 +0200
> > Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
> >
> >> Am 18.03.2013 22:22, schrieb Mauro Carvalho Chehab:
> >>> Em Wed, 06 Mar 2013 18:44:07 +0100
> >>> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
> >>>
> >>>> Am 05.03.2013 16:43, schrieb Devin Heitmueller:
> >>>>> 2013/3/5 Mauro Carvalho Chehab <mchehab@redhat.com>:
> >>>>>> The em2874 chips and upper have 2 buses. On all known devices, bus 0 is
> >>>>>> currently used only by eeprom, and bus 1 for the rest. Add support to
> >>>>>> register both buses.
> >>>>> Did you add a mutex to ensure that both buses cannot be used at the
> >>>>> same time?  Because using the bus requires you to toggle a register
> >>>>> (thus you cannot be using both busses at the same time), you cannot
> >>>>> rely on the existing i2c adapter lock anymore.
> >>>>>
> >>>>> You don't want a situation where something is actively talking on bus
> >>>>> 0, and then something else tries to talk on bus 1, flips the register
> >>>>> bit and then the thread talking on bus 0 starts failing.
> >>>>>
> >>>>> Devin
> >>>> Hmm... there are several writes to EM28XX_R06_I2C_CLK in em28xx-dvb...
> >>>> See hauppauge_hvr930c_init(), terratec_h5_init() and
> >>>> terratec_htc_stick_init().
> >>>> These functions are called from em28xx_dvb_init() at module init.
> >>>> Module init is async, so yes, this is (or could at least become) a
> >>>> problem...
> >>>>
> >>>> I wonder if we can't simply remove all those writes to
> >>>> EM28XX_R06_I2C_CLK from em28xx-dvb.
> >>>> This is what the functions are doing:
> >>>>
> >>>> hauppauge_hvr930c_init()
> >>>>     ...
> >>>>     em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x40);
> >>>>     msleep(10);
> >>>>     em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x44);
> >>>>     msleep(10);
> >>>>     ... [init sequence for slave at address 0x82]
> >>>>     em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x44);
> >>>>     msleep(30);
> >>>>     em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x45);
> >>>>     msleep(10);
> >>>>
> >>>> terratec_h5_init():
> >>>>     ...
> >>>>     em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x40);
> >>>>     msleep(10);
> >>>>     em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x45);
> >>>>     msleep(10);
> >>>>     ...
> >>>>
> >>>> terratec_htc_stick_init()
> >>>>     ...
> >>>>     em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x40);
> >>>>     msleep(10);
> >>>>     em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x44);
> >>>>     msleep(10);
> >>>>     ...
> >>>>
> >>>> All three boards are using the following settings:
> >>>>         .i2c_speed    = EM2874_I2C_SECONDARY_BUS_SELECT |
> >>>> EM28XX_I2C_CLK_WAIT_ENABLE | EM28XX_I2C_FREQ_400_KHZ = 0x45
> >>>>
> >>>> So what these functions are doing is
> >>>> - switch to bus A and do nothing fo 10ms
> >>>> - overwrite board settings for reg 0x06 with a local value (clears
> >>>> EM28XX_I2C_FREQ_400_KHZ permanently for the HTC-Stick !).
> >>>>
> >>>> I can test the HVR-930C next week.
> >> Ok, I finally had the chance to test with a HVR-930C, but it seems my
> >> device () is different.
> 
> I forgot to insert the device/model of the device I tested: it's 16009, B1F0

It has the same model as the one I have here.

> 
> >> It has no slave device at i2c address 0x82, so I can't test this part.
> >> Btw, which slave device is this ?

AFAIKT, at address 0x41, there is the analog demod (avf4910b). It is not
used by Digital TV (although I'm not sure if, for this device, it needs
to be initialized or not).

We don't have enough documentation to write a driver for avf4910b. Some
developers at the ML are trying to implement support for it for HVR-930C:

	http://www.mail-archive.com/linux-media@vger.kernel.org/msg59296.html

There is a code pointed there for avf4910a:
	https://github.com/wurststulle/ngene_2400i/blob/2377b1fd99d91ff355a5e46881ef27ccc87cb376/avf4910a.c

Also, maybe to access the avf4910b some different GPIO setting may be needed,
as it might be powered off by the GPIO settings initialized at device init.

> >>
> >> Removing the temporary switches to bus A makes no difference (as expected).
> >>
> >>> There are some things there on the init sequence that can be
> >>> cleaned/removed. Those sequences generally comes from observing
> >>> what the original driver does. While it produces a working driver,
> >>> in general, it is not optimized and part of the init sequence can
> >>> be removed.
> >> Do you want me to send patches to remove these writes ?
> >> Which i2c speed settings do you suggest for the HVR-930C and the
> >> HTC-Stick (board settings:
> >> EM28XX_I2C_FREQ_400_KHZ, code overwrites it with EM28XX_I2C_FREQ_100_KHZ) ?
> > Sure. The better would be to even remove the hauppauge_hvr930c_init()
> > function, as this is just a hack, and use the setup via the em28xx-cards
> > commented entries:
> >
> > 		.tuner_type   = TUNER_XC5000,
> > 		.tuner_addr   = 0x41,
> > 		.dvb_gpio     = hauppauge_930c_digital,
> > 		.tuner_gpio   = hauppauge_930c_gpio,
> 
> Hmm... tuner address is 0x61 for the device I tested !
> The register sequences in em28xx-cards.c also seem to be different to
> the ones used in hauppauge_hvr930c_init() in em28xx-dvb.c...

I'm not telling that the entries there are right. They aren't. If they
where working, that data there weren't commented. This device entry
started with a clone from Terratec H5, which was the first em28xx
device with DRX-K.

On Terratec H5, the tuner is different (based on tda8290/tda8275).
The current device initialization started as a clone of the code
under terratec_h5_init().

As it worked like that, the patch author that added support for HVR-930
likely didn't touch on it.

The tuner for HVR930C is clearly at 0x61 address, as it can be seen at
em28xx-dvb:

                /* Attach xc5000 */
               	memset(&cfg, 0, sizeof(cfg));
                cfg.i2c_address  = 0x61;
                cfg.if_khz = 4000;

                if (dvb->fe[0]->ops.i2c_gate_ctrl)
                        dvb->fe[0]->ops.i2c_gate_ctrl(dvb->fe[0], 1);
               	if (!dvb_attach(xc5000_attach, dvb->fe[0], &dev->i2c_adap[dev->def_i2c_bus],
                                &cfg)) {
                        result = -EINVAL;
                        goto out_free;
                }

> Are you sure this will work for _all_ variants of the HVR-930C ?

Well, the current code will only work with a HVR-930C with a xc5000 tuner,
a drx-k demod and an em28xx (and an avf4910b analog TV demod).

Any other model with a different layout, if are there any, won't work 
anyway.

While we can't discard that a different model might have a different GPIO
setting, Hauppauge tends to keep the GPIO settings equal for the same
device brand name. 

So, it seems very unlikely that any change here will keep it working for
model 16009 while breaking it for other devices.

> I think it would be better if you would create those patches.
> I really don't like writing patches without completely understanding the
> code, not beeing able to test them and commit messages saying "Mauro
> told me to do this"... ;)

> You also didn't answer my question concerning the i2c speed settings. ;)

What question?

Each bus may have a different max I2C speed, but the speed should not
change on the same I2C bus over the time. If the driver is doing that,
this is a bug that needs to be fixed.

Regards,
Mauro
