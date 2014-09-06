Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:58724 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbaIFGJH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Sep 2014 02:09:07 -0400
Received: by mail-pa0-f53.google.com with SMTP id fa1so23186440pad.26
        for <linux-media@vger.kernel.org>; Fri, 05 Sep 2014 23:09:06 -0700 (PDT)
Message-ID: <540AA4FD.5000703@gmail.com>
Date: Sat, 06 Sep 2014 15:09:01 +0900
From: Akihiro TSUKADA <tskd08@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org, Matthias Schwarzott <zzam@gentoo.org>
Subject: Re: [PATCH v2 4/5] tc90522: add driver for Toshiba TC90522 quad demodulator
References: <1409153356-1887-1-git-send-email-tskd08@gmail.com> <1409153356-1887-5-git-send-email-tskd08@gmail.com> <5402F91E.7000508@gentoo.org> <540323F0.90809@gmail.com> <54037BFE.60606@iki.fi> <5404423A.3020307@gmail.com> <540A6B27.2010704@iki.fi> <20140905232758.36946673.m.chehab@samsung.com>
In-Reply-To: <20140905232758.36946673.m.chehab@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moi!

> Yes, using the I2C binding way provides a better decoupling than using the
> legacy way. The current dvb_attach() macros are hacks that were created
> by the time where the I2C standard bind didn't work with DVB.

I understand. I converted my code to use i2c binding model,
but I'm uncertain about a few things.

1. How to load the modules of i2c driver?
Currently I use request_module()/module_put()
like an example (ddbrige-core.c) from Antti does,
but I'd prefer implicit module loading/ref-counting
like in dvb_attach() if it exists.


2. Is there a standard way to pass around dvb_frontend*, i2c_client*,
regmap* between bridge(dvb_adapter) and demod/tuner drivers?
Currently I use config structure for the purpose, which is set to
dev.platform_data (via i2c_board_info/i2c_new_device()) or
dev.driver_data (via i2c_{get,set}_clientdata()),
but using config as both IN/OUT looks a bit hacky.

3. Should I also use RegMap API for register access?
I tried using it but gave up,
because it does not fit well to one of my use-case,
where (only) reads must be done via 0xfb register, like
   READ(reg, buf, len) -> [addr/w, 0xfb, reg], [addr/r, buf[0]...],
   WRITE(reg, buf, len) -> [addr/w, reg, buf[0]...],
and regmap looked to me overkill for 8bit-reg, 8bit-val cases
and did not simplify the code.
so I'd like to go without RegMap if possible,
since I'm already puzzled enough by I2C binding, regmap, clock source,
as well as dvb-core, PCI ;)

regards,
Akihiro
