Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48590 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351AbaIGBFZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Sep 2014 21:05:25 -0400
Message-ID: <540BAF4E.5080504@iki.fi>
Date: Sun, 07 Sep 2014 04:05:18 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Akihiro TSUKADA <tskd08@gmail.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org, Matthias Schwarzott <zzam@gentoo.org>
Subject: Re: [PATCH v2 4/5] tc90522: add driver for Toshiba TC90522 quad demodulator
References: <1409153356-1887-1-git-send-email-tskd08@gmail.com> <1409153356-1887-5-git-send-email-tskd08@gmail.com> <5402F91E.7000508@gentoo.org> <540323F0.90809@gmail.com> <54037BFE.60606@iki.fi> <5404423A.3020307@gmail.com> <540A6B27.2010704@iki.fi> <20140905232758.36946673.m.chehab@samsung.com> <540AA4FD.5000703@gmail.com> <540AAED4.8070108@iki.fi> <540B61EE.8080708@gmail.com>
In-Reply-To: <540B61EE.8080708@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 09/06/2014 10:35 PM, Akihiro TSUKADA wrote:
> moikka!,
>
>> Basically it is 2 functions, af9035_add_i2c_dev() and af9035_del_i2c_dev()
>
> I used request_module()/try_module_get()/module_put()
> just like the above example (and bridge-core.c).
> It works, but when I unload bridge driver(earth_pt3),
> its demod and tuner modules stay loaded, with the refcount of 0.
> Is it ok that the auto loaded modules remain with 0 ref count?

So there is no other problem than those modules were left loaded? If you 
could unload those using rmmod it is OK then. Ref counting is here to 
prevent unloading demod and tuner driver while those are used by some 
other module. So when bridge is loaded, you should not be able to unload 
demod or tuner. But when bridge is unloaded, you should be able to 
unload demod and tuner.

And your question, I think there is no way to unload modules 
automatically or at least no need.

>> Yet, using config to OUT seems to be bit hacky for my eyes too. I though
>> replacing all OUT with ops when converted af9033 driver. Currently
>> caller fills struct af9033_ops and then af9033 I2C probe populates ops.
>> See that patch:
>> https://patchwork.linuxtv.org/patch/25746/
>>
>> Does this kind of ops sounds any better?
>
> Do you mean using ops in struct config?
> if so, I don't find much difference with the current situation
> where demod/tuner probe() sets dvb_frontend* to config->fe.

Alloc driver specific ops in bridge driver, then put pointer to that ops 
to config struct. Driver fills ops during probe. Maybe that patch clears 
the idea:
af9033: Don't export functions for the hardware filter
https://patchwork.linuxtv.org/patch/23087/

Functionality is not much different than passing pointer to frontend 
pointer from bridge to I2C demod driver via platform_data...

Somehow you will need to transfer data during driver loading and there 
is not many alternatives:
* platform data pointer
* driver data pointer
* export function
* i2c_clients_command (legacy)
* device ID string (not very suitable)
* + the rest from i2c client, not related at all

regards
Antti

-- 
http://palosaari.fi/
