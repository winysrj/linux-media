Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42245 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754215Ab2IXA24 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Sep 2012 20:28:56 -0400
Message-ID: <505FA933.6060708@iki.fi>
Date: Mon, 24 Sep 2012 03:28:35 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 07/16] rtl2830: use .get_if_frequency()
References: <1347495837-3244-1-git-send-email-crope@iki.fi> <1347495837-3244-7-git-send-email-crope@iki.fi> <20120923201742.4eaf7455@redhat.com> <505FA471.5010805@iki.fi> <20120923212346.2ff462f1@redhat.com>
In-Reply-To: <20120923212346.2ff462f1@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/24/2012 03:23 AM, Mauro Carvalho Chehab wrote:
> Em Mon, 24 Sep 2012 03:08:17 +0300
> Antti Palosaari <crope@iki.fi> escreveu:
>
>> On 09/24/2012 02:17 AM, Mauro Carvalho Chehab wrote:
>>> Em Thu, 13 Sep 2012 03:23:48 +0300
>>> Antti Palosaari <crope@iki.fi> escreveu:
>>>
>>>> Use .get_if_frequency() as all used tuner drivers
>>>> (mt2060/qt1010/mxl5005s) supports it.
>>>>
>>>> Signed-off-by: Antti Palosaari <crope@iki.fi>
>>>
>>>> @@ -240,26 +237,6 @@ static int rtl2830_init(struct dvb_frontend *fe)
>>>>    	if (ret)
>>>>    		goto err;
>>>>
>>>> -	num = priv->cfg.if_dvbt % priv->cfg.xtal;
>>>> -	num *= 0x400000;
>>>> -	num = div_u64(num, priv->cfg.xtal);
>>>> -	num = -num;
>>>> -	if_ctl = num & 0x3fffff;
>>>> -	dev_dbg(&priv->i2c->dev, "%s: if_ctl=%08x\n", __func__, if_ctl);
>>>> -
>>>> -	ret = rtl2830_rd_reg_mask(priv, 0x119, &tmp, 0xc0); /* b[7:6] */
>>>> -	if (ret)
>>>> -		goto err;
>>>> -
>>>> -	buf[0] = tmp << 6;
>>>> -	buf[0] |= (if_ctl >> 16) & 0x3f;
>>>> -	buf[1] = (if_ctl >>  8) & 0xff;
>>>> -	buf[2] = (if_ctl >>  0) & 0xff;
>>>
>>> Patch applied, but there was a context difference above:
>>>
>>>    --- a/drivers/media/dvb-frontends/rtl2830.c
>>>    +++ b/drivers/media/dvb-frontends/rtl2830.c
>>>    @@ -182,9 +182,6 @@ static int rtl2830_init(struct dvb_frontend *fe)
>>> @@ -28,7 +50,7 @@ index eca1d72..3954760 100644
>>>    -		goto err;
>>>    -
>>>    -	buf[0] = tmp << 6;
>>> --	buf[0] = (if_ctl >> 16) & 0x3f;
>>> +-	buf[0] |= (if_ctl >> 16) & 0x3f;
>>>    -	buf[1] = (if_ctl >>  8) & 0xff;
>>>    -	buf[2] = (if_ctl >>  0) & 0xff;
>>>    -
>>>
>>> (that's the diff between the patch applied and your original one)
>>
>> Because of that:
>>
>> http://patchwork.linuxtv.org/patch/14066/
>
> That's why I ask driver maintainers to send me pull requests, instead of
> sending long series of patches at the mailing list, and tagging the patches
> for review at ML as RFC: it is not warranted that the patches will be merged
> at the order they're sent to the mailing list.

Do you mean I start again review & pick those patches myself from the 
mailing list and pull-request then from git tree? It is fine for me.

How about my own patches for my own drivers. Should I sent those to the 
mailing list and then pull-request via git? If yes, is there some tag 
which could be used to inform that this patch will be pull-requested via 
git tree?

regards
Antti

-- 
http://palosaari.fi/
