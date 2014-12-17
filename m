Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:34315 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbaLQASx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Dec 2014 19:18:53 -0500
Message-ID: <5490CBE6.2030004@southpole.se>
Date: Wed, 17 Dec 2014 01:18:46 +0100
From: Benjamin Larsson <benjamin@southpole.se>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] mn88472: implement lock for all delivery systems
References: <1418686808-2530-1-git-send-email-benjamin@southpole.se> <548FA852.50004@iki.fi>
In-Reply-To: <548FA852.50004@iki.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 12/16/2014 04:34 AM, Antti Palosaari wrote:
> Moikka!
>
> On 12/16/2014 01:40 AM, Benjamin Larsson wrote:
>> Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
>> ---
>>   drivers/staging/media/mn88472/mn88472.c | 23 ++++++++++++++++++++---
>>   1 file changed, 20 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/staging/media/mn88472/mn88472.c 
>> b/drivers/staging/media/mn88472/mn88472.c
>> index 68f5036..426f0ed 100644
>> --- a/drivers/staging/media/mn88472/mn88472.c
>> +++ b/drivers/staging/media/mn88472/mn88472.c
>> @@ -238,6 +238,7 @@ static int mn88472_read_status(struct 
>> dvb_frontend *fe, fe_status_t *status)
>>       struct dtv_frontend_properties *c = &fe->dtv_property_cache;
>>       int ret;
>>       unsigned int utmp;
>> +    int lock = 0;
>>
>>       *status = 0;
>>
>> @@ -248,21 +249,37 @@ static int mn88472_read_status(struct 
>> dvb_frontend *fe, fe_status_t *status)
>>
>>       switch (c->delivery_system) {
>>       case SYS_DVBT:
>> +        ret = regmap_read(dev->regmap[0], 0x7F, &utmp);
>> +        if (ret)
>> +            goto err;
>> +        if ((utmp&0xF) > 8)
>
> You didn't read Kernel coding style doc?
>
> around line 206 Documentation/CodingStyle
> ---------------------------
> Use one space around (on each side of) most binary and ternary operators,
> such as any of these:
>
>     =  +  -  <  >  *  /  %  |  &  ^  <=  >=  == !=  ?  :
> ---------------------------

Fixed.

>
>> +            lock = 1;
>> +        break;
>>       case SYS_DVBT2:
>> -        /* FIXME: implement me */
>> -        utmp = 0x08; /* DVB-C lock value */
>> +        msleep(150);
>
> This sleep does not look correct. Why it is here? In order to provide 
> more time for lock waiting? In that case you must increase 
> .get_tune_settings() timeout. On some other case you will need to add 
> comment why such strange thing is needed.

Increased.

>
>> +        ret = regmap_read(dev->regmap[2], 0x92, &utmp);
>> +        if (ret)
>> +            goto err;
>> +        if ((utmp&0xF) >= 0x07)
>> +            *status |= FE_HAS_SIGNAL;
>> +        if ((utmp&0xF) >= 0x0a)
>> +            *status |= FE_HAS_CARRIER;
>> +        if ((utmp&0xF) >= 0x0d)
>> +            *status |= FE_HAS_VITERBI | FE_HAS_SYNC | FE_HAS_LOCK;
>>           break;
>>       case SYS_DVBC_ANNEX_A:
>>           ret = regmap_read(dev->regmap[1], 0x84, &utmp);
>>           if (ret)
>>               goto err;
>> +        if ((utmp&0xF) > 7)
>> +            lock = 1;
>>           break;
>>       default:
>>           ret = -EINVAL;
>>           goto err;
>>       }
>>
>> -    if (utmp == 0x08)
>> +    if (lock)
>>           *status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_VITERBI |
>>                   FE_HAS_SYNC | FE_HAS_LOCK;
>
> Antti
>

Sent v2 patch.

MvH
Benjamin Larsson
