Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx6-14.smtp.antispamcloud.com ([95.211.2.226]:37689 "EHLO
	mx6-14.smtp.antispamcloud.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964936AbbHKNvF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2015 09:51:05 -0400
Message-ID: <55C9E97A.1000004@topic.nl>
Date: Tue, 11 Aug 2015 14:24:26 +0200
From: Mike Looijmans <mike.looijmans@topic.nl>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, <lars@metafoo.de>
CC: <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [media] i2c/adv7511: Fix license, set to GPL v2
References: <1438081066-31748-1-git-send-email-mike.looijmans@topic.nl> <55C9E060.6050901@xs4all.nl>
In-Reply-To: <55C9E060.6050901@xs4all.nl>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

﻿Okay, I split it up and sent it to the proper lists.

Just noticed I forgot to set the "in-reply-to" headers though. Hope that won't 
be a problem.

On 11-08-15 13:45, Hans Verkuil wrote:
> Hi Mike,
>
> Please split up this patch: these are two different drivers with different
> authors and different subsystems.
>
> The media/i2c/adv7511.c patch I can handle, but the patch for the drm driver
> should go to the dri-devel mailinglist. I can't take that change.
>
> Easiest is just to post two patches, one for each driver.
>
> Regards,
>
> 	Hans
>
> On 07/28/15 12:57, Mike Looijmans wrote:
>> Header claims GPL v2, so make the MODULE_LICENSE reflect that properly.
>>
>> Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>
>> ---
>>   drivers/gpu/drm/i2c/adv7511_core.c | 2 +-
>>   drivers/media/i2c/adv7511.c        | 2 +-
>>   2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/i2c/adv7511_core.c b/drivers/gpu/drm/i2c/adv7511_core.c
>> index 2564b5d..12e8134 100644
>> --- a/drivers/gpu/drm/i2c/adv7511_core.c
>> +++ b/drivers/gpu/drm/i2c/adv7511_core.c
>> @@ -956,4 +956,4 @@ module_exit(adv7511_exit);
>>
>>   MODULE_AUTHOR("Lars-Peter Clausen <lars@metafoo.de>");
>>   MODULE_DESCRIPTION("ADV7511 HDMI transmitter driver");
>> -MODULE_LICENSE("GPL");
>> +MODULE_LICENSE("GPL v2");
>> diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
>> index 02d76c6..1a4275d 100644
>> --- a/drivers/media/i2c/adv7511.c
>> +++ b/drivers/media/i2c/adv7511.c
>> @@ -41,7 +41,7 @@ MODULE_PARM_DESC(debug, "debug level (0-2)");
>>
>>   MODULE_DESCRIPTION("Analog Devices ADV7511 HDMI Transmitter Device Driver");
>>   MODULE_AUTHOR("Hans Verkuil");
>> -MODULE_LICENSE("GPL");
>> +MODULE_LICENSE("GPL v2");
>>
>>   #define MASK_ADV7511_EDID_RDY_INT   0x04
>>   #define MASK_ADV7511_MSEN_INT       0x40
>>



Kind regards,

Mike Looijmans
System Expert

TOPIC Embedded Products
Eindhovenseweg 32-C, NL-5683 KH Best
Postbus 440, NL-5680 AK Best
Telefoon: +31 (0) 499 33 69 79
Telefax: +31 (0) 499 33 69 70
E-mail: mike.looijmans@topicproducts.com
Website: www.topicproducts.com

Please consider the environment before printing this e-mail





