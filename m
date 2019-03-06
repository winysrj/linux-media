Return-Path: <SRS0=KHCC=RJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AEA1C43381
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:37:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60E8C206DD
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:37:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbfCFVhB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 16:37:01 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:53246 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725747AbfCFVhA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 6 Mar 2019 16:37:00 -0500
Received: from [IPv6:2001:a62:1a32:fa01:1fc3:d8be:bfc6:efb5] (unknown [IPv6:2001:a62:1a32:fa01:1fc3:d8be:bfc6:efb5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: zzam)
        by smtp.gentoo.org (Postfix) with ESMTPSA id B9125335D35;
        Wed,  6 Mar 2019 21:36:54 +0000 (UTC)
Subject: Re: [PATCH v2] media: si2165: fix a missing check of return value
To:     Sean Young <sean@mess.org>
Cc:     Kangjie Lu <kjlu@umn.edu>, pakki001@umn.edu,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20181221045403.59303-1-kjlu@umn.edu>
 <7a5d505d-692b-f067-51f6-815787cffba3@gentoo.org>
 <20190305211743.vi6zksuw2eltusif@gofer.mess.org>
From:   Matthias Schwarzott <zzam@gentoo.org>
Message-ID: <a6c6075d-27fd-4e07-2d9c-28186e75aab8@gentoo.org>
Date:   Wed, 6 Mar 2019 22:36:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.2
MIME-Version: 1.0
In-Reply-To: <20190305211743.vi6zksuw2eltusif@gofer.mess.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Am 05.03.19 um 22:17 schrieb Sean Young:
> On Fri, Dec 21, 2018 at 09:24:46AM +0100, Matthias Schwarzott wrote:
>> Am 21.12.18 um 05:54 schrieb Kangjie Lu:
>>> si2165_readreg8() may fail. Looking into si2165_readreg8(), we will find
>>> that "val_tmp" will be an uninitialized value when regmap_read() fails.
>>> "val_tmp" is then assigned to "val". So if si2165_readreg8() fails,
>>> "val" will be a random value. Further use will lead to undefined
>>> behaviors. The fix checks if si2165_readreg8() fails, and if so, returns
>>> its error code upstream.
>>>
>>> Signed-off-by: Kangjie Lu <kjlu@umn.edu>
>>
>> Reviewed-by: Matthias Schwarzott <zzam@gentoo.org>
> 
> Unless it is tested on the actual hardware we can't apply this. This could
> introduce regressions.
> 

I tested it on a Hauppauge WinTV-HVR5500 tuning to DVB-C.

Regards
Matthias

Tested-by: Matthias Schwarzott <zzam@gentoo.org>

> Sean
> 
>>
>>> ---
>>>  drivers/media/dvb-frontends/si2165.c | 8 +++++---
>>>  1 file changed, 5 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
>>> index feacd8da421d..d55d8f169dca 100644
>>> --- a/drivers/media/dvb-frontends/si2165.c
>>> +++ b/drivers/media/dvb-frontends/si2165.c
>>> @@ -275,18 +275,20 @@ static u32 si2165_get_fe_clk(struct si2165_state *state)
>>>  
>>>  static int si2165_wait_init_done(struct si2165_state *state)
>>>  {
>>> -	int ret = -EINVAL;
>>> +	int ret;
>>>  	u8 val = 0;
>>>  	int i;
>>>  
>>>  	for (i = 0; i < 3; ++i) {
>>> -		si2165_readreg8(state, REG_INIT_DONE, &val);
>>> +		ret = si2165_readreg8(state, REG_INIT_DONE, &val);
>>> +		if (ret < 0)
>>> +			return ret;
>>>  		if (val == 0x01)
>>>  			return 0;
>>>  		usleep_range(1000, 50000);
>>>  	}
>>>  	dev_err(&state->client->dev, "init_done was not set\n");
>>> -	return ret;
>>> +	return -EINVAL;
>>>  }
>>>  
>>>  static int si2165_upload_firmware_block(struct si2165_state *state,
>>>
> 

