Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40636 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889Ab3J2VRT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Oct 2013 17:17:19 -0400
Message-ID: <527025DD.2060205@iki.fi>
Date: Tue, 29 Oct 2013 23:17:17 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] rtl2830: add parent for I2C adapter
References: <1382386335-3879-1-git-send-email-crope@iki.fi> <52658CA7.5080104@iki.fi>
In-Reply-To: <52658CA7.5080104@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Wolfram,

Phil email address was not valid anymore, so could you Wolfram, as a I2C 
subsystem maintainer, look and comment that. The fact is that my driver 
has a 3.12 regression and I want to know where it is coming from to make 
decision what to do!

regards
Antti


On 21.10.2013 23:20, Antti Palosaari wrote:
> Hello Phil and Wolfram,
>
> I found one of my drivers was crashing when DTV USB stick was plugged.
> Patch in that mail patch fixes the problem.
>
> I quickly looked possible I2C patches causing the problem and saw that
> one as most suspicions:
>
> commit 3923172b3d700486c1ca24df9c4c5405a83e2309
> i2c: reduce parent checking to a NOOP in non-I2C_MUX case
>
> My config has no CONFIG_I2C_MUX set currently, but I am not sure how it
> has been earlier.
>
> Any idea?
>
> regards
> Antti
>
>
> On 21.10.2013 23:12, Antti Palosaari wrote:
>> i2c i2c-6: adapter [RTL2830 tuner I2C adapter] registered
>> BUG: unable to handle kernel NULL pointer dereference at 0000000000000220
>> IP: [<ffffffffa0002900>] i2c_register_adapter+0x130/0x390 [i2c_core]
>>
>> Signed-off-by: Antti Palosaari <crope@iki.fi>
>> ---
>>   drivers/media/dvb-frontends/rtl2830.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/media/dvb-frontends/rtl2830.c
>> b/drivers/media/dvb-frontends/rtl2830.c
>> index 362d26d..68ee70b 100644
>> --- a/drivers/media/dvb-frontends/rtl2830.c
>> +++ b/drivers/media/dvb-frontends/rtl2830.c
>> @@ -700,6 +700,7 @@ struct dvb_frontend *rtl2830_attach(const struct
>> rtl2830_config *cfg,
>>           sizeof(priv->tuner_i2c_adapter.name));
>>       priv->tuner_i2c_adapter.algo = &rtl2830_tuner_i2c_algo;
>>       priv->tuner_i2c_adapter.algo_data = NULL;
>> +    priv->tuner_i2c_adapter.dev.parent = &i2c->dev;
>>       i2c_set_adapdata(&priv->tuner_i2c_adapter, priv);
>>       if (i2c_add_adapter(&priv->tuner_i2c_adapter) < 0) {
>>           dev_err(&i2c->dev,
>>
>
>


-- 
http://palosaari.fi/
