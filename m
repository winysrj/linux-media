Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:32937 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbaIAJyH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Sep 2014 05:54:07 -0400
Received: by mail-pa0-f42.google.com with SMTP id lf10so11924793pab.1
        for <linux-media@vger.kernel.org>; Mon, 01 Sep 2014 02:54:06 -0700 (PDT)
Message-ID: <5404423A.3020307@gmail.com>
Date: Mon, 01 Sep 2014 18:54:02 +0900
From: Akihiro TSUKADA <tskd08@gmail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
CC: Matthias Schwarzott <zzam@gentoo.org>, m.chehab@samsung.com
Subject: Re: [PATCH v2 4/5] tc90522: add driver for Toshiba TC90522 quad demodulator
References: <1409153356-1887-1-git-send-email-tskd08@gmail.com> <1409153356-1887-5-git-send-email-tskd08@gmail.com> <5402F91E.7000508@gentoo.org> <540323F0.90809@gmail.com> <54037BFE.60606@iki.fi>
In-Reply-To: <54037BFE.60606@iki.fi>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> Also, I would like to see all new drivers (demod and tuner) implemented
> as a standard kernel I2C drivers (or any other bus). I have converted
> already quite many drivers, si2168, si2157, m88ds3103, m88ts2022,
> it913x, tda18212, ...

I wrote the code in the old style using dvb_attach()
because (I felt) it is simpler than using i2c_new_device() by
introducing new i2c-related data structures,
registering to both dvb and i2c, without any new practical
features that i2c client provides.

But if the use of dvb_attach() is (almost) deprecated and
i2c client driver is the standard/prefered way,
I'll convert my code.

regards,
akihiro
