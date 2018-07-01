Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:41504 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752197AbeGBQH1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2018 12:07:27 -0400
Subject: Re: [PATCH] media: i2c: lm3560: add support for lm3559 chip
To: Pavel Machek <pavel@ucw.cz>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, sre@kernel.org,
        nekit1000@gmail.com, mpartap@gmx.net, merlijn@wizzup.org,
        m.chehab@samsung.com, sakari.ailus@iki.fi,
        linux-media@vger.kernel.org
References: <20180506080607.GA24212@amd> <20180623213328.GA19154@amd>
From: Daniel Jeong <gshark.jeong@gmail.com>
Message-ID: <92fcf91d-f955-9a16-bf99-aad95f39a92a@gmail.com>
Date: Mon, 2 Jul 2018 03:00:46 +0900
MIME-Version: 1.0
In-Reply-To: <20180623213328.GA19154@amd>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

> On Sun 2018-05-06 10:06:07, Pavel Machek wrote:
>> Add support for LM3559, as found in Motorola Droid 4 phone, for
>> example. SW interface seems to be identical.
>>
>> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> Ping?

>fping daniel
daniel is alive. :)

>
> Could this and media: i2c: lm3560: use conservative defaults be
> applied for v4.19? This is not too complex...
>
> 								Pavel

The lm3559 datasheet should be reviewed first
to know whether those products have same register map and field data for each register.

> 								
>> diff --git a/drivers/media/i2c/lm3560.c b/drivers/media/i2c/lm3560.c
>> index b600e03a..c4e5ed5 100644
>> --- a/drivers/media/i2c/lm3560.c
>> +++ b/drivers/media/i2c/lm3560.c
>> @@ -1,6 +1,6 @@
>>   /*
>>    * drivers/media/i2c/lm3560.c
>> - * General device driver for TI lm3560, FLASH LED Driver
>> + * General device driver for TI lm3559, lm3560, FLASH LED Driver
>>    *
>>    * Copyright (C) 2013 Texas Instruments
>>    *
>> @@ -465,6 +479,7 @@ static int lm3560_remove(struct i2c_client *client)
>>   }
>>   
>>   static const struct i2c_device_id lm3560_id_table[] = {
>> +	{LM3559_NAME, 0},
>>   	{LM3560_NAME, 0},
>>   	{}
>>   };
>> diff --git a/include/media/i2c/lm3560.h b/include/media/i2c/lm3560.h
>> index a5bd310..0e2b1c7 100644
>> --- a/include/media/i2c/lm3560.h
>> +++ b/include/media/i2c/lm3560.h
>> @@ -22,6 +22,7 @@
>>   
>>   #include <media/v4l2-subdev.h>
>>   
>> +#define LM3559_NAME	"lm3559"
>>   #define LM3560_NAME	"lm3560"
>>   #define LM3560_I2C_ADDR	(0x53)
>>   
>>
>
>
