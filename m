Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933018Ab3CRVWM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 17:22:12 -0400
Date: Mon, 18 Mar 2013 18:22:05 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/3] em28xx: add support for two buses on em2874 and
 upper
Message-ID: <20130318182205.44f44e20@redhat.com>
In-Reply-To: <51378067.3000506@googlemail.com>
References: <1362480928-20382-1-git-send-email-mchehab@redhat.com>
	<CAGoCfiwB9BT2mDQqu2cwsRM-0eraqyxdY0V3fnH+S2RSNiGSdQ@mail.gmail.com>
	<51378067.3000506@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 06 Mar 2013 18:44:07 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Am 05.03.2013 16:43, schrieb Devin Heitmueller:
> > 2013/3/5 Mauro Carvalho Chehab <mchehab@redhat.com>:
> >> The em2874 chips and upper have 2 buses. On all known devices, bus 0 is
> >> currently used only by eeprom, and bus 1 for the rest. Add support to
> >> register both buses.
> > Did you add a mutex to ensure that both buses cannot be used at the
> > same time?  Because using the bus requires you to toggle a register
> > (thus you cannot be using both busses at the same time), you cannot
> > rely on the existing i2c adapter lock anymore.
> >
> > You don't want a situation where something is actively talking on bus
> > 0, and then something else tries to talk on bus 1, flips the register
> > bit and then the thread talking on bus 0 starts failing.
> >
> > Devin
> 
> Hmm... there are several writes to EM28XX_R06_I2C_CLK in em28xx-dvb...
> See hauppauge_hvr930c_init(), terratec_h5_init() and
> terratec_htc_stick_init().
> These functions are called from em28xx_dvb_init() at module init.
> Module init is async, so yes, this is (or could at least become) a
> problem...
> 
> I wonder if we can't simply remove all those writes to
> EM28XX_R06_I2C_CLK from em28xx-dvb.
> This is what the functions are doing:
> 
> hauppauge_hvr930c_init()
>     ...
>     em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x40);
>     msleep(10);
>     em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x44);
>     msleep(10);
>     ... [init sequence for slave at address 0x82]
>     em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x44);
>     msleep(30);
>     em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x45);
>     msleep(10);
> 
> terratec_h5_init():
>     ...
>     em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x40);
>     msleep(10);
>     em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x45);
>     msleep(10);
>     ...
> 
> terratec_htc_stick_init()
>     ...
>     em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x40);
>     msleep(10);
>     em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x44);
>     msleep(10);
>     ...
> 
> All three boards are using the following settings:
>         .i2c_speed    = EM2874_I2C_SECONDARY_BUS_SELECT |
> EM28XX_I2C_CLK_WAIT_ENABLE | EM28XX_I2C_FREQ_400_KHZ = 0x45
> 
> So what these functions are doing is
> - switch to bus A and do nothing fo 10ms
> - overwrite board settings for reg 0x06 with a local value (clears
> EM28XX_I2C_FREQ_400_KHZ permanently for the HTC-Stick !).
> 
> I can test the HVR-930C next week.

There are some things there on the init sequence that can be
cleaned/removed. Those sequences generally comes from observing
what the original driver does. While it produces a working driver,
in general, it is not optimized and part of the init sequence can
be removed.

Regards,
Mauro
