Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f176.google.com ([209.85.215.176]:51399 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760633Ab3DBTBc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Apr 2013 15:01:32 -0400
Received: by mail-ea0-f176.google.com with SMTP id h10so386509eaj.21
        for <linux-media@vger.kernel.org>; Tue, 02 Apr 2013 12:01:31 -0700 (PDT)
Message-ID: <515B2B49.8050805@googlemail.com>
Date: Tue, 02 Apr 2013 21:02:33 +0200
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/3] em28xx: add support for two buses on em2874 and upper
References: <1362480928-20382-1-git-send-email-mchehab@redhat.com> <CAGoCfiwB9BT2mDQqu2cwsRM-0eraqyxdY0V3fnH+S2RSNiGSdQ@mail.gmail.com> <51378067.3000506@googlemail.com> <20130318182205.44f44e20@redhat.com> <5159C05B.10902@googlemail.com> <20130401162205.379bda4f@redhat.com> <5159F080.1030503@googlemail.com> <20130401191224.4da92bd8@redhat.com>
In-Reply-To: <20130401191224.4da92bd8@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 02.04.2013 00:12, schrieb Mauro Carvalho Chehab:
> Em Mon, 01 Apr 2013 22:39:28 +0200
> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>
>> Am 01.04.2013 21:22, schrieb Mauro Carvalho Chehab:
>>> Em Mon, 01 Apr 2013 19:14:03 +0200
>>> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>>>
>>>> Am 18.03.2013 22:22, schrieb Mauro Carvalho Chehab:
>>>>> Em Wed, 06 Mar 2013 18:44:07 +0100
>>>>> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>>>>>
>>>>>> Am 05.03.2013 16:43, schrieb Devin Heitmueller:
>>>>>>> 2013/3/5 Mauro Carvalho Chehab <mchehab@redhat.com>:
>>>>>>>> The em2874 chips and upper have 2 buses. On all known devices, bus 0 is
>>>>>>>> currently used only by eeprom, and bus 1 for the rest. Add support to
>>>>>>>> register both buses.
>>>>>>> Did you add a mutex to ensure that both buses cannot be used at the
>>>>>>> same time?  Because using the bus requires you to toggle a register
>>>>>>> (thus you cannot be using both busses at the same time), you cannot
>>>>>>> rely on the existing i2c adapter lock anymore.
>>>>>>>
>>>>>>> You don't want a situation where something is actively talking on bus
>>>>>>> 0, and then something else tries to talk on bus 1, flips the register
>>>>>>> bit and then the thread talking on bus 0 starts failing.
>>>>>>>
>>>>>>> Devin
>>>>>> Hmm... there are several writes to EM28XX_R06_I2C_CLK in em28xx-dvb...
>>>>>> See hauppauge_hvr930c_init(), terratec_h5_init() and
>>>>>> terratec_htc_stick_init().
>>>>>> These functions are called from em28xx_dvb_init() at module init.
>>>>>> Module init is async, so yes, this is (or could at least become) a
>>>>>> problem...
>>>>>>
>>>>>> I wonder if we can't simply remove all those writes to
>>>>>> EM28XX_R06_I2C_CLK from em28xx-dvb.
>>>>>> This is what the functions are doing:
>>>>>>
>>>>>> hauppauge_hvr930c_init()
>>>>>>     ...
>>>>>>     em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x40);
>>>>>>     msleep(10);
>>>>>>     em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x44);
>>>>>>     msleep(10);
>>>>>>     ... [init sequence for slave at address 0x82]
>>>>>>     em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x44);
>>>>>>     msleep(30);
>>>>>>     em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x45);
>>>>>>     msleep(10);
>>>>>>
>>>>>> terratec_h5_init():
>>>>>>     ...
>>>>>>     em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x40);
>>>>>>     msleep(10);
>>>>>>     em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x45);
>>>>>>     msleep(10);
>>>>>>     ...
>>>>>>
>>>>>> terratec_htc_stick_init()
>>>>>>     ...
>>>>>>     em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x40);
>>>>>>     msleep(10);
>>>>>>     em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x44);
>>>>>>     msleep(10);
>>>>>>     ...
>>>>>>
>>>>>> All three boards are using the following settings:
>>>>>>         .i2c_speed    = EM2874_I2C_SECONDARY_BUS_SELECT |
>>>>>> EM28XX_I2C_CLK_WAIT_ENABLE | EM28XX_I2C_FREQ_400_KHZ = 0x45
>>>>>>
>>>>>> So what these functions are doing is
>>>>>> - switch to bus A and do nothing fo 10ms
>>>>>> - overwrite board settings for reg 0x06 with a local value (clears
>>>>>> EM28XX_I2C_FREQ_400_KHZ permanently for the HTC-Stick !).
>>>>>>
>>>>>> I can test the HVR-930C next week.
>>>> Ok, I finally had the chance to test with a HVR-930C, but it seems my
>>>> device () is different.
>> I forgot to insert the device/model of the device I tested: it's 16009, B1F0
> It has the same model as the one I have here.

Ok.

>
>>>> It has no slave device at i2c address 0x82, so I can't test this part.
>>>> Btw, which slave device is this ?
> AFAIKT, at address 0x41, there is the analog demod (avf4910b). It is not
> used by Digital TV (although I'm not sure if, for this device, it needs
> to be initialized or not).
>
> We don't have enough documentation to write a driver for avf4910b. Some
> developers at the ML are trying to implement support for it for HVR-930C:
>
> 	http://www.mail-archive.com/linux-media@vger.kernel.org/msg59296.html
>
> There is a code pointed there for avf4910a:
> 	https://github.com/wurststulle/ngene_2400i/blob/2377b1fd99d91ff355a5e46881ef27ccc87cb376/avf4910a.c
>
> Also, maybe to access the avf4910b some different GPIO setting may be needed,
> as it might be powered off by the GPIO settings initialized at device i
>

Yeah, I remember that.
Anyway, I don't have time for this at the moment.
I also think this is really Hauppauges job. These devices are still
expensive (65-100€) but half working only.
That's why I'm going to do it with all my Hauppauge devices: wait 5
years and then buy them used for max. 10€.
Maybe I'll get back to this if it is still not working then and I find
some free time, but no guarantee... ;)

>
>>>> Removing the temporary switches to bus A makes no difference (as expected).
>>>>
>>>>> There are some things there on the init sequence that can be
>>>>> cleaned/removed. Those sequences generally comes from observing
>>>>> what the original driver does. While it produces a working driver,
>>>>> in general, it is not optimized and part of the init sequence can
>>>>> be removed.
>>>> Do you want me to send patches to remove these writes ?
>>>> Which i2c speed settings do you suggest for the HVR-930C and the
>>>> HTC-Stick (board settings:
>>>> EM28XX_I2C_FREQ_400_KHZ, code overwrites it with EM28XX_I2C_FREQ_100_KHZ) ?
>>> Sure. The better would be to even remove the hauppauge_hvr930c_init()
>>> function, as this is just a hack, and use the setup via the em28xx-cards
>>> commented entries:
>>>
>>> 		.tuner_type   = TUNER_XC5000,
>>> 		.tuner_addr   = 0x41,
>>> 		.dvb_gpio     = hauppauge_930c_digital,
>>> 		.tuner_gpio   = hauppauge_930c_gpio,
>> Hmm... tuner address is 0x61 for the device I tested !
>> The register sequences in em28xx-cards.c also seem to be different to
>> the ones used in hauppauge_hvr930c_init() in em28xx-dvb.c...
> I'm not telling that the entries there are right. They aren't. If they
> where working, that data there weren't commented. This device entry
> started with a clone from Terratec H5, which was the first em28xx
> device with DRX-K.
>
> On Terratec H5, the tuner is different (based on tda8290/tda8275).
> The current device initialization started as a clone of the code
> under terratec_h5_init().
>
> As it worked like that, the patch author that added support for HVR-930
> likely didn't touch on it.

:-/
So the whole code for these devices is basically a quick and dirty hack.
I also checked the init sequences in em28xx-dvb.c and the GPIO sequences
and board parameters which are currently commented out...

No, thank you, I'm not going to touch this under the current circumstances !

What I'm still going to do is to remove at least these writes to reg
0x06 in em28xx-dvb.c.

>
> The tuner for HVR930C is clearly at 0x61 address, as it can be seen at
> em28xx-dvb:
>
>                 /* Attach xc5000 */
>                	memset(&cfg, 0, sizeof(cfg));
>                 cfg.i2c_address  = 0x61;
>                 cfg.if_khz = 4000;
>
>                 if (dvb->fe[0]->ops.i2c_gate_ctrl)
>                         dvb->fe[0]->ops.i2c_gate_ctrl(dvb->fe[0], 1);
>                	if (!dvb_attach(xc5000_attach, dvb->fe[0], &dev->i2c_adap[dev->def_i2c_bus],
>                                 &cfg)) {
>                         result = -EINVAL;
>                         goto out_free;
>                 }
>
>> Are you sure this will work for _all_ variants of the HVR-930C ?
> Well, the current code will only work with a HVR-930C with a xc5000 tuner,
> a drx-k demod and an em28xx (and an avf4910b analog TV demod).
>
> Any other model with a different layout, if are there any, won't work 
> anyway.
>
> While we can't discard that a different model might have a different GPIO
> setting, Hauppauge tends to keep the GPIO settings equal for the same
> device brand name. 
>
> So, it seems very unlikely that any change here will keep it working for
> model 16009 while breaking it for other devices.

Ok, so if the changes work with my device, I can assume it works for the
others (if existing and working with the current code), too.

>
>> I think it would be better if you would create those patches.
>> I really don't like writing patches without completely understanding the
>> code, not beeing able to test them and commit messages saying "Mauro
>> told me to do this"... ;)
>> You also didn't answer my question concerning the i2c speed settings. ;)
> What question?
>
> Each bus may have a different max I2C speed, but the speed should not
> change on the same I2C bus over the time. If the driver is doing that,
> this is a bug that needs to be fixed.

For the HVR-930C and the HTC stick the board setting is 400KHz which we
overwrite in em28xx-dvb with 100KHz.
Which means that the current code (if it is really working) uses 100KHz.
So should I change the board setting to 100KHz when removing these
writes to be sure we don't break anything ?

I checked several datasheets of different i2c client devices, but none
of them says anything concerning the supported i2c speeds...
Can we assume that all devices are working with 100KHz ? And does 400KHz
really make things faster ? ;)

Regards,
Frank

>
> Regards,
> Mauro

