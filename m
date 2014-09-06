Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:42387 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbaIFTfP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Sep 2014 15:35:15 -0400
Received: by mail-pd0-f169.google.com with SMTP id y10so8736774pdj.14
        for <linux-media@vger.kernel.org>; Sat, 06 Sep 2014 12:35:14 -0700 (PDT)
Message-ID: <540B61EE.8080708@gmail.com>
Date: Sun, 07 Sep 2014 04:35:10 +0900
From: Akihiro TSUKADA <tskd08@gmail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org, Matthias Schwarzott <zzam@gentoo.org>
Subject: Re: [PATCH v2 4/5] tc90522: add driver for Toshiba TC90522 quad demodulator
References: <1409153356-1887-1-git-send-email-tskd08@gmail.com> <1409153356-1887-5-git-send-email-tskd08@gmail.com> <5402F91E.7000508@gentoo.org> <540323F0.90809@gmail.com> <54037BFE.60606@iki.fi> <5404423A.3020307@gmail.com> <540A6B27.2010704@iki.fi> <20140905232758.36946673.m.chehab@samsung.com> <540AA4FD.5000703@gmail.com> <540AAED4.8070108@iki.fi>
In-Reply-To: <540AAED4.8070108@iki.fi>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

moikka!,

> Basically it is 2 functions, af9035_add_i2c_dev() and af9035_del_i2c_dev()

I used request_module()/try_module_get()/module_put()
just like the above example (and bridge-core.c).
It works, but when I unload bridge driver(earth_pt3),
its demod and tuner modules stay loaded, with the refcount of 0.
Is it ok that the auto loaded modules remain with 0 ref count?

> Yet, using config to OUT seems to be bit hacky for my eyes too. I though
> replacing all OUT with ops when converted af9033 driver. Currently
> caller fills struct af9033_ops and then af9033 I2C probe populates ops.
> See that patch:
> https://patchwork.linuxtv.org/patch/25746/
> 
> Does this kind of ops sounds any better?

Do you mean using ops in struct config?
if so, I don't find much difference with the current situation
where demod/tuner probe() sets dvb_frontend* to config->fe. 

> I quickly overlooked that demod driver and one which looked crazy was
> LNA stuff. You implement set_lna callback in demod, but it is then
> passed back to PCI driver using frontend callback. Is there some reason
> you hooked it via demod? You could implement set_lna in PCI driver too.

Stupidly I forgot that FE's ops can be set from the PCI driver.
I will remove those callbacks and set the corresponding ops instead.

regards,
akihiro

