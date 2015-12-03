Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:34064 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbbLCTDh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Dec 2015 14:03:37 -0500
Received: by wmvv187 with SMTP id v187so42181417wmv.1
        for <linux-media@vger.kernel.org>; Thu, 03 Dec 2015 11:03:36 -0800 (PST)
Subject: Re: [PATCH 2/2] media: rc: improve lirc module detection
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <56508E30.8010205@gmail.com> <20151203150828.5ebdc89b@recife.lan>
Cc: linux-media@vger.kernel.org
From: Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <566091F8.9030300@gmail.com>
Date: Thu, 3 Dec 2015 20:03:20 +0100
MIME-Version: 1.0
In-Reply-To: <20151203150828.5ebdc89b@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 03.12.2015 um 18:08 schrieb Mauro Carvalho Chehab:
> Em Sat, 21 Nov 2015 16:30:56 +0100
> Heiner Kallweit <hkallweit1@gmail.com> escreveu:
> 
>> Improve detection whether lirc codec is loaded and avoid dependency
>> on config symbols and having to check for a specific module.
>>
>> This also fixes the bug that the current check checks for module
>> lirc_dev instead of ir_lirc_codec (which depends on lirc_dev).
>> If the ir_lirc_codec module is unloaded the check would still
>> return OK.
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>>  drivers/media/rc/ir-lirc-codec.c |  4 ++++
>>  drivers/media/rc/rc-main.c       | 19 +++++--------------
>>  2 files changed, 9 insertions(+), 14 deletions(-)
>>
>> diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
>> index a32659f..7fc5b3f 100644
>> --- a/drivers/media/rc/ir-lirc-codec.c
>> +++ b/drivers/media/rc/ir-lirc-codec.c
>> @@ -22,6 +22,8 @@
>>  
>>  #define LIRCBUF_SIZE 256
>>  
>> +extern atomic_t ir_raw_lirc_available;
>> +
> 
> No, this is not good, due to several reasons:
> 
> - it lacks an EXPORT_SYMBOL_GPL(ir_raw_lirc_available);
> - if lirc module is not compiled, the RC core will have a missed
>   symbol.
> 
> The right thing to do is to have a var inside the RC core and a
> way for LIRC to tell the core that it was loaded.
> 
IMHO that's actually the case.
The var is defined in rc_main.c and also exported from there.
Your comment is at the position where the variable is declared as "extern"
in the (potential) lirc module.

> I would prefer to not export a var. So, perhaps this could be
> done by calling some function.
> 
Sure, we could define the var static and add a public setter.
Would you prefer this?

> Anyway, the way the patch is, it will break compilation, depending
> on the config options.
> 
> Regards,
> Mauro
> 
Rgds, Heiner
> 
>>  /**
>>   * ir_lirc_decode() - Send raw IR data to lirc_dev to be relayed to the
>>   *		      lircd userspace daemon for decoding.
>> @@ -398,6 +400,7 @@ static int ir_lirc_register(struct rc_dev *dev)
>>  
>>  	dev->raw->lirc.drv = drv;
>>  	dev->raw->lirc.dev = dev;
>> +	atomic_set(&ir_raw_lirc_available, 1);
>>  	return 0;
>>  
>>  lirc_register_failed:
>> @@ -413,6 +416,7 @@ static int ir_lirc_unregister(struct rc_dev *dev)
>>  {
>>  	struct lirc_codec *lirc = &dev->raw->lirc;
>>  
>> +	atomic_set(&ir_raw_lirc_available, 0);
>>  	lirc_unregister_driver(lirc->drv->minor);
>>  	lirc_buffer_free(lirc->drv->rbuf);
>>  	kfree(lirc->drv);
>> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
>> index 1042fa3..0bd11b4 100644
>> --- a/drivers/media/rc/rc-main.c
>> +++ b/drivers/media/rc/rc-main.c
>> @@ -829,21 +829,12 @@ struct rc_filter_attribute {
>>  		.mask = (_mask),					\
>>  	}
>>  
>> -static bool lirc_is_present(void)
>> +atomic_t ir_raw_lirc_available = ATOMIC_INIT(0);
>> +EXPORT_SYMBOL(ir_raw_lirc_available);
>> +
>> +static inline bool lirc_is_present(void)
>>  {
>> -#if defined(CONFIG_LIRC_MODULE)
>> -	struct module *lirc;
>> -
>> -	mutex_lock(&module_mutex);
>> -	lirc = find_module("lirc_dev");
>> -	mutex_unlock(&module_mutex);
>> -
>> -	return lirc ? true : false;
>> -#elif defined(CONFIG_LIRC)
>> -	return true;
>> -#else
>> -	return false;
>> -#endif
>> +	return atomic_read(&ir_raw_lirc_available) != 0;
>>  }
>>  
>>  /**
> 

