Return-path: <linux-media-owner@vger.kernel.org>
Received: from pro10.proekspert.ee ([212.47.207.10]:33116 "HELO
	mail.proekspert.ee" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754098AbZKMIhU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Nov 2009 03:37:20 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail.proekspert.ee (Postfix) with ESMTP id 7FC1C248690
	for <linux-media@vger.kernel.org>; Fri, 13 Nov 2009 10:37:24 +0200 (EET)
Received: from mail.proekspert.ee ([127.0.0.1])
	by localhost (mail.proekspert.ee [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NZnkKi8aIMlX for <linux-media@vger.kernel.org>;
	Fri, 13 Nov 2009 10:37:23 +0200 (EET)
Received: from mail.proekspert.ee (mail.proekspert.ee [192.168.50.1])
	by mail.proekspert.ee (Postfix) with ESMTP id 8B2BB24868E
	for <linux-media@vger.kernel.org>; Fri, 13 Nov 2009 10:37:23 +0200 (EET)
Date: Fri, 13 Nov 2009 10:37:23 +0200 (EET)
From: Lauri Laanmets <lauri.laanmets@proekspert.ee>
To: linux-media@vger.kernel.org
Message-ID: <28911112.17998.1258101443429.JavaMail.root@mail>
In-Reply-To: <5247569.9431255416845783.JavaMail.root@mail>
Subject: Fwd: DVB support for MSI DigiVox A/D II and KWorld 320U
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

I have managed to attach the device without any error messages now but the tuning and playback of DVB still doesn't work. I get a lot of these error messages:

[  247.268152] em28xx #0: reading i2c device failed (error=-110)
[  247.268161] xc2028 1-0061: i2c input error: rc = -110 (should be 2)

and

[  433.232124] xc2028 1-0061: Loading SCODE for type=DTV6 ATSC OREN538 SCODE HAS_IF_5580 (60110020), id 0000000000000000.
[  433.256017] xc2028 1-0061: Incorrect readback of firmware version.
[  433.372019] xc2028 1-0061: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
[  437.940029] xc2028 1-0061: Loading firmware for type=D2620 DTV78 (108), id 0000000000000000.

Do anybody have an idea what to do next? Or maybe somebody is willing to help me understanding the mcentral code because that one works fine.

Regards
Lauri

----- Forwarded Message -----
From: "Lauri Laanmets" <lauri.laanmets@proekspert.ee>
To: "Devin Heitmueller" <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
Sent: Tuesday, October 13, 2009 9:54:05 AM
Subject: Re: DVB support for MSI DigiVox A/D II and KWorld 320U

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
