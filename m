Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([91.232.154.25]:40775 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755554AbdLOSMZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 13:12:25 -0500
Subject: Re: [PATCH] [media] tda18212: fix use-after-free in tda18212_remove()
To: Daniel Scheller <d.scheller.oss@gmail.com>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com, zzam@gentoo.org
References: <20171215164337.3236-1-d.scheller.oss@gmail.com>
 <3c5e3614-ee61-f69a-283f-2c1b16aa2cbc@iki.fi>
 <20171215190008.1dde2633@macbox>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <9d4e4ccd-9d96-b2eb-6b49-7f50dc08e109@iki.fi>
Date: Fri, 15 Dec 2017 20:12:18 +0200
MIME-Version: 1.0
In-Reply-To: <20171215190008.1dde2633@macbox>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 12/15/2017 08:00 PM, Daniel Scheller wrote:
> Hi,
> 
> On Fri, 15 Dec 2017 19:30:18 +0200
> Antti Palosaari <crope@iki.fi> wrote:
> 
> Thanks for your reply.
> 
>> Hello
>> I think shared frontend structure, which is owned by demod driver,
>> should be there and valid on time tuner driver is removed. And thus
>> should not happen. Did you make driver unload on different order eg.
>> not just reverse order than driver load?
>>
>> IMHO these should go always
>>
>> on load:
>> 1) load demod driver (which makes shared frontend structure where
>> also some tuner driver data lives)
>> 2) load tuner driver
>> 3) register frontend
>>
>> on unload
>> 1) unregister frontend
>> 2) remove tuner driver
>> 3) remove demod driver (frees shared data)
> 
> In ddbridge, we do (like in usb/em28xx and platform/sti/c8sectpfe, both
> also use some demod+tda18212 combo):
> 
> dvb_unregister_frontend();
> dvb_frontend_detach();
> module_put(tda18212client->...owner);
> i2c_unregister_device(tda18212client);
> 
> fe_detach() clears out the frontend references and frees/invalidates
> the allocated resources. tuner_ops obviously isn't there then anymore.

yeah, but that's even ideally wrong. frontend design currently relies to 
shared data which is owned by demod driver and thus it should be last 
thing to be removed. Sure change like you did prevents issue, but 
logically it is still wrong and may not work on some other case.

> 
> The two mentioned drivers will very likely yield the same (or
> similar) KASAN report. em28xx was even changed lately to do the teardown
> the way ddbridge does in 910b0797fa9e8 ([1], cc'ing Matthias
> here).
> 
> With that commit in mind I'm a bit unsure on what is correct or not.
> OTOH, as dvb_frontend_detach() cleans up everything, IMHO there's no
> need for the tuner driver to try to clean up further.
> 
> Please advise.
> 
> [1] https://git.linuxtv.org/media_tree.git/commit/?id=910b0797fa9e8.

em28xx does it currently just correct.
1) unregister frontend
2) remove I2C SEC
3) remove I2C tuner
4) remove I2C demod (frees shared frontend data)

regards
Antti

-- 
http://palosaari.fi/
