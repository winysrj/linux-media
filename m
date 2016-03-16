Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:33987 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965098AbcCPVdK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2016 17:33:10 -0400
Received: by mail-wm0-f44.google.com with SMTP id p65so361798wmp.1
        for <linux-media@vger.kernel.org>; Wed, 16 Mar 2016 14:33:09 -0700 (PDT)
Subject: Re: [PATCH] media: rc: remove unneeded mutex in rc_register_device
To: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <56E9ABB0.3010106@gmail.com> <56E9B4FA.3060707@mentor.com>
Cc: linux-media@vger.kernel.org
From: Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <56E9CEFB.1050601@gmail.com>
Date: Wed, 16 Mar 2016 22:24:11 +0100
MIME-Version: 1.0
In-Reply-To: <56E9B4FA.3060707@mentor.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 16.03.2016 um 20:33 schrieb Vladimir Zapolskiy:
> On 16.03.2016 20:53, Heiner Kallweit wrote:
>> Access to dev->initialized is atomic, therefore we don't have to
>> protect it with a mutex.
> 
> Mutexes are used to split the code to mutually exclusive execution blocks,
> so not arguing about the apparently correct change itself I want to
> emphasize that the given explanation of the change in the commit message is
> wrong. Atomic access does not cancel a specific care about execution
> ordering.
> 
> Indirectly it applies to ("rc-core: allow calling rc_open with device not
> initialized"), where "initialized" bool property was changed to atomic_t
> type --- this (sub-)change is just useless.
> 
> Please grasp the topic and reword the commit message.
> 
Thanks for the hint, you're right.
Will change the commit message and send a v2.

Regards, Heiner

>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>>  drivers/media/rc/rc-main.c | 2 --
>>  1 file changed, 2 deletions(-)
>>
>> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
>> index 4e9bbe7..68541b1 100644
>> --- a/drivers/media/rc/rc-main.c
>> +++ b/drivers/media/rc/rc-main.c
>> @@ -1492,9 +1492,7 @@ int rc_register_device(struct rc_dev *dev)
>>  	}
>>  
>>  	/* Allow the RC sysfs nodes to be accessible */
>> -	mutex_lock(&dev->lock);
>>  	atomic_set(&dev->initialized, 1);
>> -	mutex_unlock(&dev->lock);
>>  
>>  	IR_dprintk(1, "Registered rc%u (driver: %s, remote: %s, mode %s)\n",
>>  		   dev->minor,
>>
> 
> --
> With best wishes,
> Vladimir
> 

