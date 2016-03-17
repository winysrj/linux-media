Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:35492 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbcCQGlO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Mar 2016 02:41:14 -0400
Received: by mail-wm0-f42.google.com with SMTP id l68so213679605wml.0
        for <linux-media@vger.kernel.org>; Wed, 16 Mar 2016 23:41:13 -0700 (PDT)
Subject: Re: [PATCH] media: rc: reduce size of struct ir_raw_event
To: Sean Young <sean@mess.org>
References: <56E9CDAE.2040200@gmail.com>
 <20160316222826.GA6635@gofer.mess.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
From: Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <56EA517B.5030903@gmail.com>
Date: Thu, 17 Mar 2016 07:40:59 +0100
MIME-Version: 1.0
In-Reply-To: <20160316222826.GA6635@gofer.mess.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 16.03.2016 um 23:28 schrieb Sean Young:
> On Wed, Mar 16, 2016 at 10:18:38PM +0100, Heiner Kallweit wrote:
>> struct ir_raw_event currently has a size of 12 bytes on most (all?)
>> architectures. This can be reduced to 8 bytes whilst maintaining
>> full backwards compatibility.
>> This saves 2KB in size of struct ir_raw_event_ctrl (as element
>> kfifo is reduced by 512 * 4 bytes) and it allows to copy the
>> full struct ir_raw_event with a single 64 bit operation.
>>
>> Successfully tested with the Nuvoton driver and successfully
>> compile-tested with the ene_ir driver (as it uses the carrier /
>> duty_cycle elements).
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>>  include/media/rc-core.h | 26 ++++++++------------------
>>  1 file changed, 8 insertions(+), 18 deletions(-)
>>
>> diff --git a/include/media/rc-core.h b/include/media/rc-core.h
>> index 0f77b3d..b8f27c9 100644
>> --- a/include/media/rc-core.h
>> +++ b/include/media/rc-core.h
>> @@ -214,27 +214,17 @@ enum raw_event_type {
>>  
>>  struct ir_raw_event {
>>  	union {
>> -		u32             duration;
>> -
>> -		struct {
>> -			u32     carrier;
>> -			u8      duty_cycle;
>> -		};
>> +		u32	duration;
>> +		u32	carrier;
>>  	};
>> -
>> -	unsigned                pulse:1;
>> -	unsigned                reset:1;
>> -	unsigned                timeout:1;
>> -	unsigned                carrier_report:1;
>> +	u8		duty_cycle;
> 
> Moving duty_cycle does indeed reduce the structure size from 12 to 8.
> 
>> +	u8		pulse:1;
>> +	u8		reset:1;
>> +	u8		timeout:1;
>> +	u8		carrier_report:1;
> 
> Why are you changing the type of the bitfields? 
> 
I did this to make sure that the compiler uses one byte for
the bit field. When testing gcc also used just one byte when
keeping the original "unsigned" type for the bit field members.
Therefore it wouldn't be strictly neeeded.

But I'm not sure whether it's guaranteed that the compiler packs a
bit field to the smallest possible data type and we can rely on it.
AFAIK C99 is a little more specific about this implementation detail of
bit fields but C89/C90 is used for kernel compilation.

Heiner

>>  };
>>  
>> -#define DEFINE_IR_RAW_EVENT(event) \
>> -	struct ir_raw_event event = { \
>> -		{ .duration = 0 } , \
>> -		.pulse = 0, \
>> -		.reset = 0, \
>> -		.timeout = 0, \
>> -		.carrier_report = 0 }
>> +#define DEFINE_IR_RAW_EVENT(event) struct ir_raw_event event = {}
> 
> Seems fine. I've always kinda wondered why this macro is needed.
> 
> 
> Sean
> 

