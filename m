Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:6487 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750997AbcISU6j (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 16:58:39 -0400
Subject: Re: [PATCH v2 01/17] smiapp: Move sub-device initialisation into a
 separate function
To: Sebastian Reichel <sre@ring0.de>
Cc: linux-media@vger.kernel.org
References: <1473938551-14503-1-git-send-email-sakari.ailus@linux.intel.com>
 <1473938551-14503-2-git-send-email-sakari.ailus@linux.intel.com>
 <20160919201131.f5eeca2vvjabqhpm@earth>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <57E05179.4080902@linux.intel.com>
Date: Mon, 19 Sep 2016 23:58:33 +0300
MIME-Version: 1.0
In-Reply-To: <20160919201131.f5eeca2vvjabqhpm@earth>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sebastian,

Thank you for the review!

Sebastian Reichel wrote:
> Hi,
>
> On Thu, Sep 15, 2016 at 02:22:15PM +0300, Sakari Ailus wrote:
>> Simplify smiapp_init() by moving the initialisation of individual
>> sub-devices to a separate function.
>
> Reviewed-By: Sebastian Reichel <sre@kernel.org>
>
>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>> ---
>>   drivers/media/i2c/smiapp/smiapp-core.c | 108 +++++++++++++++------------------
>>   1 file changed, 49 insertions(+), 59 deletions(-)
>>
>> diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
>> index 44f8c7e..862017e 100644
>> --- a/drivers/media/i2c/smiapp/smiapp-core.c
>> +++ b/drivers/media/i2c/smiapp/smiapp-core.c
>>
>> [...]
>>
>> +	if (sensor->scaler)
>> +		smiapp_create_subdev(sensor, sensor->scaler, "scaler");
>
> I would add the NULL check to smiapp_create_subdev.

I first thought I'd say it makes it cleaner what's optional and what's 
not. The same is however visible some ten--twenty lines above this code, 
so not really an argument for that. Will fix.

>
>> +	smiapp_create_subdev(sensor, sensor->binner, "binner");
>> +	smiapp_create_subdev(sensor, sensor->pixel_array, "pixel_array");
>>
>>   	dev_dbg(&client->dev, "profile %d\n", sensor->minfo.smiapp_profile);
>>
>
> -- Sebastian
>


-- 
Sakari Ailus
sakari.ailus@linux.intel.com
