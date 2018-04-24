Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:52674 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757207AbeDXMtV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 08:49:21 -0400
Received: by mail-wm0-f53.google.com with SMTP id w195so716921wmw.2
        for <linux-media@vger.kernel.org>; Tue, 24 Apr 2018 05:49:20 -0700 (PDT)
Subject: Re: [PATCH v2 2/2] media: Add a driver for the ov7251 camera sensor
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: mchehab@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1521778460-8717-1-git-send-email-todor.tomov@linaro.org>
 <1521778460-8717-3-git-send-email-todor.tomov@linaro.org>
 <20180329115147.nai3dgverqpjympu@paasikivi.fi.intel.com>
 <3b45d013-d9e7-04bf-22a3-06b858c2c7bd@linaro.org>
 <20180417201021.q6t4imtoaeh5vtsi@kekkonen.localdomain>
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <b84b4f78-8085-b536-7113-f0a257d3359e@linaro.org>
Date: Tue, 24 Apr 2018 15:49:18 +0300
MIME-Version: 1.0
In-Reply-To: <20180417201021.q6t4imtoaeh5vtsi@kekkonen.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 17.04.2018 23:10, Sakari Ailus wrote:
> Hi Todor,
> 
> On Tue, Apr 17, 2018 at 06:32:07PM +0300, Todor Tomov wrote:
> ...
>>>> +static int ov7251_regulators_enable(struct ov7251 *ov7251)
>>>> +{
>>>> +	int ret;
>>>> +
>>>> +	ret = regulator_enable(ov7251->io_regulator);
>>>
>>> How about regulator_bulk_enable() here, and bulk_disable below?
>>
>> I'm not using the bulk API because usually there is a power up
>> sequence and intervals that must be followed. For this sensor
>> the only constraint is that core regulator must be enabled
>> after io regulator. But the bulk API doesn't guarantee the
>> order.
> 
> Could you add a comment explaining this? Otherwise it won't take long until
> someone "fixes" the code.

Sure :D
I'm adding a comment.

> 
> ...
> 
>>>> +static int ov7251_read_reg(struct ov7251 *ov7251, u16 reg, u8 *val)
>>>> +{
>>>> +	u8 regbuf[2];
>>>> +	int ret;
>>>> +
>>>> +	regbuf[0] = reg >> 8;
>>>> +	regbuf[1] = reg & 0xff;
>>>> +
>>>> +	ret = i2c_master_send(ov7251->i2c_client, regbuf, 2);
>>>> +	if (ret < 0) {
>>>> +		dev_err(ov7251->dev, "%s: write reg error %d: reg=%x\n",
>>>> +			__func__, ret, reg);
>>>> +		return ret;
>>>> +	}
>>>> +
>>>> +	ret = i2c_master_recv(ov7251->i2c_client, val, 1);
>>>> +	if (ret < 0) {
>>>> +		dev_err(ov7251->dev, "%s: read reg error %d: reg=%x\n",
>>>> +			__func__, ret, reg);
>>>> +		return ret;
>>>> +	}
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +static int ov7251_set_exposure(struct ov7251 *ov7251, s32 exposure)
>>>> +{
>>>> +	int ret;
>>>> +
>>>> +	ret = ov7251_write_reg(ov7251, OV7251_AEC_EXPO_0,
>>>> +			       (exposure & 0xf000) >> 12);
>>>> +	if (ret < 0)
>>>> +		return ret;
>>>> +
>>>> +	ret = ov7251_write_reg(ov7251, OV7251_AEC_EXPO_1,
>>>> +			       (exposure & 0x0ff0) >> 4);
>>>> +	if (ret < 0)
>>>> +		return ret;
>>>> +
>>>> +	return ov7251_write_reg(ov7251, OV7251_AEC_EXPO_2,
>>>> +				(exposure & 0x000f) << 4);
>>>
>>> It's not a good idea to access multi-octet registers separately. Depending
>>> on the hardware implementation, the hardware could latch the value in the
>>> middle of an update. This is only an issue during streaming in practice
>>> though.
>>
>> Good point. The sensor has a group write functionality which can be used
>> to solve this but in general is intended
>> to apply a group of exposure and gain settings in the same frame. However
>> it seems to me that is not possible to use this functionality efficiently
>> with the currently available user controls. The group write is configured
>> using an id for a group of commands. So if we configure exposure and gain
>> separately (a group for each):
>> - if the driver uses same group id for exposure and gain, if both controls
>>   are received in one frame the second will overwrite the first (the
>>   first will not be applied);
>> - if the driver uses different group id for exposure and gain, it will not
>>   be possible for the user to change exposure and gain in the same frame
>>   (as some exposure algorithms do) and it will lead again to frames with
>>   "incorrect" brightness.
>>
>> To do this correctly we will have to extend the API to be able to apply
>> exposure and gain "atomically":
>> - a single user control which will set both exposure and gain and it will
>>   guarantee that they will be applied in the same frame;
>> - some kind of: begin, set exposure, set gain, end, launch -API
>>
>> What do you think?
>>
>> Actually, I'm a little bit surprised that I didn't find anything
>> like this already. And there are already a number of sensor drivers
>> which update more than one register to set exposure.
> 
> The latter of the two would be preferred as it isn't limited to exposure
> and gain only. Still, you could address the problem for this driver by
> simply writing the register in a single transaction.

Thanks for suggestion. I've tried the single transaction, I will send the
next version of the driver shortly.

-- 
Best regards,
Todor Tomov
