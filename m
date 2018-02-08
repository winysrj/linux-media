Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway32.websitewelcome.com ([192.185.145.171]:15430 "EHLO
        gateway32.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752432AbeBHQjq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Feb 2018 11:39:46 -0500
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway32.websitewelcome.com (Postfix) with ESMTP id D1DEC281AA
        for <linux-media@vger.kernel.org>; Thu,  8 Feb 2018 10:39:45 -0600 (CST)
Subject: Re: [PATCH v3 4/8] i2c: ov9650: use 64-bit arithmetic instead of
 32-bit
To: Sakari Ailus <sakari.ailus@iki.fi>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1517929336.git.gustavo@embeddedor.com>
 <6f6fd607cf3428d6ab115f1deaa82c4963b170f1.1517929336.git.gustavo@embeddedor.com>
 <20180207215944.quwowjy52dclk7uc@valkosipuli.retiisi.org.uk>
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Message-ID: <3518830f-180c-2bf0-1319-eb4af8cc556f@embeddedor.com>
Date: Thu, 8 Feb 2018 10:39:39 -0600
MIME-Version: 1.0
In-Reply-To: <20180207215944.quwowjy52dclk7uc@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 02/07/2018 03:59 PM, Sakari Ailus wrote:
> Hi Gustavo,
> 
> On Tue, Feb 06, 2018 at 10:47:50AM -0600, Gustavo A. R. Silva wrote:
>> Add suffix ULL to constants 10000 and 1000000 in order to give the
>> compiler complete information about the proper arithmetic to use.
>> Notice that these constants are used in contexts that expect
>> expressions of type u64 (64 bits, unsigned).
>>
>> The following expressions:
>>
>> (u64)(fi->interval.numerator * 10000)
>> (u64)(iv->interval.numerator * 10000)
>> fiv->interval.numerator * 1000000 / fiv->interval.denominator
>>
>> are currently being evaluated using 32-bit arithmetic.
>>
>> Notice that those casts to u64 for the first two expressions are only
>> effective after such expressions are evaluated using 32-bit arithmetic,
>> which leads to potential integer overflows. So based on those casts, it
>> seems that the original intention of the code is to actually use 64-bit
>> arithmetic instead of 32-bit.
>>
>> Also, notice that once the suffix ULL is added to the constants, the
>> outer casts to u64 are no longer needed.
>>
>> Addresses-Coverity-ID: 1324146 ("Unintentional integer overflow")
>> Fixes: 84a15ded76ec ("[media] V4L: Add driver for OV9650/52 image sensors")
>> Fixes: 79211c8ed19c ("remove abs64()")
>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>> ---
>> Changes in v2:
>>   - Update subject and changelog to better reflect the proposed code changes.
>>   - Add suffix ULL to constants instead of casting variables.
>>   - Remove unnecessary casts to u64 as part of the code change.
>>   - Extend the same code change to other similar expressions.
>>
>> Changes in v3:
>>   - None.
>>
>>   drivers/media/i2c/ov9650.c | 9 +++++----
>>   1 file changed, 5 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/media/i2c/ov9650.c b/drivers/media/i2c/ov9650.c
>> index e519f27..e716e98 100644
>> --- a/drivers/media/i2c/ov9650.c
>> +++ b/drivers/media/i2c/ov9650.c
>> @@ -1130,7 +1130,7 @@ static int __ov965x_set_frame_interval(struct ov965x *ov965x,
>>   	if (fi->interval.denominator == 0)
>>   		return -EINVAL;
>>   
>> -	req_int = (u64)(fi->interval.numerator * 10000) /
>> +	req_int = fi->interval.numerator * 10000ULL /
>>   		fi->interval.denominator;
> 
> This has been addressed by your earlier patch "i2c: ov9650: fix potential integer overflow in
> __ov965x_set_frame_interval" I tweaked a little. It's not in media tree
> master yet.
> 

Yeah. Actually this patch is supposed to be an improved version of the 
one you mention. That is why this is version 3.

Also, I wonder if the same issue you mention below regarding 32-bit ARM 
applies in this case too?

>>   
>>   	for (i = 0; i < ARRAY_SIZE(ov965x_intervals); i++) {
>> @@ -1139,7 +1139,7 @@ static int __ov965x_set_frame_interval(struct ov965x *ov965x,
>>   		if (mbus_fmt->width != iv->size.width ||
>>   		    mbus_fmt->height != iv->size.height)
>>   			continue;
>> -		err = abs((u64)(iv->interval.numerator * 10000) /
>> +		err = abs(iv->interval.numerator * 10000ULL /
> 
> This and the chunk below won't work on e.g. 32-bit ARM. do_div(), please.
> 

Thanks for pointing this out.

>>   			    iv->interval.denominator - req_int);
>>   		if (err < min_err) {
>>   			fiv = iv;
>> @@ -1148,8 +1148,9 @@ static int __ov965x_set_frame_interval(struct ov965x *ov965x,
>>   	}
>>   	ov965x->fiv = fiv;
>>   
>> -	v4l2_dbg(1, debug, &ov965x->sd, "Changed frame interval to %u us\n",
>> -		 fiv->interval.numerator * 1000000 / fiv->interval.denominator);
>> +	v4l2_dbg(1, debug, &ov965x->sd, "Changed frame interval to %llu us\n",
>> +		 fiv->interval.numerator * 1000000ULL /
>> +		 fiv->interval.denominator);

I wonder if do_div should be used for the code above?

I appreciate your feedback.

Thank you!
-- 
Gustavo
