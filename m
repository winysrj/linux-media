Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:35801 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213Ab3CFRnS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2013 12:43:18 -0500
Received: by mail-ee0-f51.google.com with SMTP id d17so5839199eek.24
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2013 09:43:17 -0800 (PST)
Message-ID: <51378067.3000506@googlemail.com>
Date: Wed, 06 Mar 2013 18:44:07 +0100
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/3] em28xx: add support for two buses on em2874 and upper
References: <1362480928-20382-1-git-send-email-mchehab@redhat.com> <CAGoCfiwB9BT2mDQqu2cwsRM-0eraqyxdY0V3fnH+S2RSNiGSdQ@mail.gmail.com>
In-Reply-To: <CAGoCfiwB9BT2mDQqu2cwsRM-0eraqyxdY0V3fnH+S2RSNiGSdQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 05.03.2013 16:43, schrieb Devin Heitmueller:
> 2013/3/5 Mauro Carvalho Chehab <mchehab@redhat.com>:
>> The em2874 chips and upper have 2 buses. On all known devices, bus 0 is
>> currently used only by eeprom, and bus 1 for the rest. Add support to
>> register both buses.
> Did you add a mutex to ensure that both buses cannot be used at the
> same time?  Because using the bus requires you to toggle a register
> (thus you cannot be using both busses at the same time), you cannot
> rely on the existing i2c adapter lock anymore.
>
> You don't want a situation where something is actively talking on bus
> 0, and then something else tries to talk on bus 1, flips the register
> bit and then the thread talking on bus 0 starts failing.
>
> Devin

Hmm... there are several writes to EM28XX_R06_I2C_CLK in em28xx-dvb...
See hauppauge_hvr930c_init(), terratec_h5_init() and
terratec_htc_stick_init().
These functions are called from em28xx_dvb_init() at module init.
Module init is async, so yes, this is (or could at least become) a
problem...

I wonder if we can't simply remove all those writes to
EM28XX_R06_I2C_CLK from em28xx-dvb.
This is what the functions are doing:

hauppauge_hvr930c_init()
    ...
    em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x40);
    msleep(10);
    em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x44);
    msleep(10);
    ... [init sequence for slave at address 0x82]
    em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x44);
    msleep(30);
    em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x45);
    msleep(10);

terratec_h5_init():
    ...
    em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x40);
    msleep(10);
    em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x45);
    msleep(10);
    ...

terratec_htc_stick_init()
    ...
    em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x40);
    msleep(10);
    em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x44);
    msleep(10);
    ...

All three boards are using the following settings:
        .i2c_speed    = EM2874_I2C_SECONDARY_BUS_SELECT |
EM28XX_I2C_CLK_WAIT_ENABLE | EM28XX_I2C_FREQ_400_KHZ = 0x45

So what these functions are doing is
- switch to bus A and do nothing fo 10ms
- overwrite board settings for reg 0x06 with a local value (clears
EM28XX_I2C_FREQ_400_KHZ permanently for the HTC-Stick !).

I can test the HVR-930C next week.

Regards,
Frank


