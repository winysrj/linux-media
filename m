Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40548 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783AbaIFGvF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Sep 2014 02:51:05 -0400
Message-ID: <540AAED4.8070108@iki.fi>
Date: Sat, 06 Sep 2014 09:51:00 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Akihiro TSUKADA <tskd08@gmail.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org, Matthias Schwarzott <zzam@gentoo.org>
Subject: Re: [PATCH v2 4/5] tc90522: add driver for Toshiba TC90522 quad demodulator
References: <1409153356-1887-1-git-send-email-tskd08@gmail.com> <1409153356-1887-5-git-send-email-tskd08@gmail.com> <5402F91E.7000508@gentoo.org> <540323F0.90809@gmail.com> <54037BFE.60606@iki.fi> <5404423A.3020307@gmail.com> <540A6B27.2010704@iki.fi> <20140905232758.36946673.m.chehab@samsung.com> <540AA4FD.5000703@gmail.com>
In-Reply-To: <540AA4FD.5000703@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

moikka!

On 09/06/2014 09:09 AM, Akihiro TSUKADA wrote:
> Moi!
>
>> Yes, using the I2C binding way provides a better decoupling than using the
>> legacy way. The current dvb_attach() macros are hacks that were created
>> by the time where the I2C standard bind didn't work with DVB.
>
> I understand. I converted my code to use i2c binding model,
> but I'm uncertain about a few things.
>
> 1. How to load the modules of i2c driver?
> Currently I use request_module()/module_put()
> like an example (ddbrige-core.c) from Antti does,
> but I'd prefer implicit module loading/ref-counting
> like in dvb_attach() if it exists.

Maybe I haven't found the best way yet, but that was implementation I 
made for AF9035 driver:
https://patchwork.linuxtv.org/patch/25764/

Basically it is 2 functions, af9035_add_i2c_dev() and af9035_del_i2c_dev()

> 2. Is there a standard way to pass around dvb_frontend*, i2c_client*,
> regmap* between bridge(dvb_adapter) and demod/tuner drivers?
> Currently I use config structure for the purpose, which is set to
> dev.platform_data (via i2c_board_info/i2c_new_device()) or
> dev.driver_data (via i2c_{get,set}_clientdata()),
> but using config as both IN/OUT looks a bit hacky.

In my understanding, platform_data is place to pass environment specific 
config to driver. get/set client_data() is aimed to carry pointer for 
device specific instance "state" inside a driver. Is it possible to set 
I2C client data before calling i2c_new_device() and pass pointer to driver?

There is also IOCTL style command for I2C, but it is legacy and should 
not be used.

Documentation/i2c/busses/i2c-ocores

Yet, using config to OUT seems to be bit hacky for my eyes too. I though 
replacing all OUT with ops when converted af9033 driver. Currently 
caller fills struct af9033_ops and then af9033 I2C probe populates ops. 
See that patch:
https://patchwork.linuxtv.org/patch/25746/

Does this kind of ops sounds any better?

EXPORT_SYMBOL() is easiest way to offer outputs, like 
EXPORT_SYMBOL(get_frontend), EXPORT_SYMBOL(get_i2c_adapter). But we want 
avoid those exported symbols.

> 3. Should I also use RegMap API for register access?
> I tried using it but gave up,
> because it does not fit well to one of my use-case,
> where (only) reads must be done via 0xfb register, like
>     READ(reg, buf, len) -> [addr/w, 0xfb, reg], [addr/r, buf[0]...],
>     WRITE(reg, buf, len) -> [addr/w, reg, buf[0]...],
> and regmap looked to me overkill for 8bit-reg, 8bit-val cases
> and did not simplify the code.
> so I'd like to go without RegMap if possible,
> since I'm already puzzled enough by I2C binding, regmap, clock source,
> as well as dvb-core, PCI ;)

I prefer RegMap API, but I am only one who has started using it yet. And 
I haven't converted any demod driver having I2C bus/gate/repeater for 
tuner to that API. It is because of I2C locking with I2C mux adapter, 
you need use unlocked version of i2c_transfer() for I2C mux as I2C bus 
lock is already taken. RegMap API does not support that, but I think it 
should be possible if you implement own xfer callback for regmap. For RF 
tuners RegMap API should be trivial and it will reduce ~100 LOC from driver.

But if you decide avoid RegMap API, I ask you add least implementing 
those I2C read / write function parameters similarly than RegMap API 
does. Defining all kind of weird register write / read functions makes 
life harder. I converted recently IT913x driver to RegMap API and 
biggest pain was there very different register read / write routines. So 
I need to do a lot of work in order convert functions first some common 
style and then it was trivial to change RegMap API.

https://patchwork.linuxtv.org/patch/25766/
https://patchwork.linuxtv.org/patch/25757/

I quickly overlooked that demod driver and one which looked crazy was 
LNA stuff. You implement set_lna callback in demod, but it is then 
passed back to PCI driver using frontend callback. Is there some reason 
you hooked it via demod? You could implement set_lna in PCI driver too.

regards
Antti

-- 
http://palosaari.fi/
