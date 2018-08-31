Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38416 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727261AbeHaKCu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Aug 2018 06:02:50 -0400
Received: by mail-wr1-f68.google.com with SMTP id w11-v6so10027531wrc.5
        for <linux-media@vger.kernel.org>; Thu, 30 Aug 2018 22:57:01 -0700 (PDT)
Subject: Re: [PATCH v3 1/2] media: dt-bindings: bind nokia,n900-ir to generic
 pwm-ir-tx driver
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org, Rob Herring <robh@kernel.org>,
        =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali.rohar@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        Timo Kokkonen <timo.t.kokkonen@iki.fi>,
        Tony Lindgren <tony@atomide.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
References: <20180713122230.19278-1-sean@mess.org>
 <20180829140731.1d6491c0@coco.lan>
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Message-ID: <f55b4c44-d58a-d2e0-4a7e-7c45b7b438fb@gmail.com>
Date: Fri, 31 Aug 2018 08:52:55 +0300
MIME-Version: 1.0
In-Reply-To: <20180829140731.1d6491c0@coco.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 29.08.2018 20:07, Mauro Carvalho Chehab wrote:
> Em Fri, 13 Jul 2018 13:22:29 +0100
> Sean Young <sean@mess.org> escreveu:
> 
>> The generic pwm-ir-tx driver should work for the Nokia n900.
>>
>> Compile tested only.
> 
> It would be good to have some tests...
> 

Unfortunately, it turned out I won't be able to test soon, so please, 
somebody else do it.

>>
>> Cc: Rob Herring <robh@kernel.org>
>> Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
>> Cc: Pali Rohár <pali.rohar@gmail.com>
>> Cc: Pavel Machek <pavel@ucw.cz>
>> Cc: Timo Kokkonen <timo.t.kokkonen@iki.fi>
>> Cc: Tony Lindgren <tony@atomide.com>
> 
> And some acks
> 
> Before merging it.
> 
>> Signed-off-by: Sean Young <sean@mess.org>
>> ---
>>   arch/arm/boot/dts/omap3-n900.dts | 2 +-
>>   drivers/media/rc/pwm-ir-tx.c     | 1 +
>>   2 files changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n900.dts
>> index 182a53991c90..fd12dea15799 100644
>> --- a/arch/arm/boot/dts/omap3-n900.dts
>> +++ b/arch/arm/boot/dts/omap3-n900.dts
>> @@ -154,7 +154,7 @@
>>   	};
>>   
>>   	ir: n900-ir {
>> -		compatible = "nokia,n900-ir";
>> +		compatible = "nokia,n900-ir", "pwm-ir-tx";
>>   		pwms = <&pwm9 0 26316 0>; /* 38000 Hz */
>>   	};
>>   
>> diff --git a/drivers/media/rc/pwm-ir-tx.c b/drivers/media/rc/pwm-ir-tx.c
>> index 27d0f5837a76..272947b430c8 100644
>> --- a/drivers/media/rc/pwm-ir-tx.c
>> +++ b/drivers/media/rc/pwm-ir-tx.c
>> @@ -30,6 +30,7 @@ struct pwm_ir {
>>   };
>>   
>>   static const struct of_device_id pwm_ir_of_match[] = {
>> +	{ .compatible = "nokia,n900-ir" },
>>   	{ .compatible = "pwm-ir-tx", },
>>   	{ },
>>   };
> 
> 
> 
> Thanks,
> Mauro
> 
