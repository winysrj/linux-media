Return-path: <linux-media-owner@vger.kernel.org>
Received: from pro10.proekspert.ee ([212.47.207.10]:45057 "HELO
	mail.proekspert.ee" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751591AbZJMHGB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Oct 2009 03:06:01 -0400
Date: Tue, 13 Oct 2009 09:54:05 +0300 (EEST)
From: Lauri Laanmets <lauri.laanmets@proekspert.ee>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
Message-ID: <5247569.9431255416845783.JavaMail.root@mail>
In-Reply-To: <31497292.9391255416643929.JavaMail.root@mail>
Subject: Re: DVB support for MSI DigiVox A/D II and KWorld 320U
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

> Check the dvb_gpio setting in the board profile.  On some of those
> boards you need to take put one of the GPO pins high to take the demod
> out of reset.  The KWorld 315u and 330u are both like that.

Absolutely true. Using the same pin setting as KWorld 330U made the I2C communication work correctly and the device is found.

Now the trouble is that scanning channels doesn't work, blue LED doesn't light up and the device is not heated up.

I'm quite newbie in this field, is there a good way to know what registers to set exactly?

I see that the working "mcentral" code had the following setting:

#define EETI_DEFAULT_GPIO {						\
	.ts1_on     = _BIT_VAL(EM28XX_GPIO0,  0, 0), 			\
	.a_on       = _BIT_VAL(EM28XX_GPIO1,  0, 0), 			\
	.xc3028_sec = _BIT_VAL(EM28XX_GPIO2,  1, 0), 			\
	/* reserved */							\
	.t1_reset   = _BIT_VAL(EM28XX_GPIO4,  0, 1), 			\
	/* reserved */							\
	.t1_on      = _BIT_VAL(EM28XX_GPIO6,  0, 0), 			\
	.t2_on      = _BIT_VAL(EM28XX_GPIO7,  1, 0), 			\
									\
	.l1_on      = _BIT_VAL(EM28XX_GOP2,   1, 0), 			\
	.d1_reset   = _BIT_VAL(EM28XX_GOP3,   0, 1), 			\
}

But the v4l-dvb uses:

static struct em28xx_reg_seq kworld_330u_digital[] = {
	{EM28XX_R08_GPIO,	0x6e,	~EM_GPIO_4,	10},
	{EM2880_R04_GPO,	0x08,	0xff,		10},
	{ -1,			-1,	-1,		-1},
};

Lauri
