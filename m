Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:9533 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750997AbcISUuI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 16:50:08 -0400
Subject: Re: [PATCH v2 04/17] smiapp: Split off sub-device registration into
 two
To: Sebastian Reichel <sre@kernel.org>
Cc: linux-media@vger.kernel.org
References: <1473938551-14503-1-git-send-email-sakari.ailus@linux.intel.com>
 <1473938551-14503-5-git-send-email-sakari.ailus@linux.intel.com>
 <20160919203022.v4vih6stlfci5cft@earth>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <57E04F7A.4080009@linux.intel.com>
Date: Mon, 19 Sep 2016 23:50:02 +0300
MIME-Version: 1.0
In-Reply-To: <20160919203022.v4vih6stlfci5cft@earth>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sebastian,

Sebastian Reichel wrote:
> Hi,
>
> On Thu, Sep 15, 2016 at 02:22:18PM +0300, Sakari Ailus wrote:
>> Remove the loop in sub-device registration and create each sub-device
>> explicitly instead.
>
> Reviewed-By: Sebastian Reichel <sre@kernel.org>

Thanks!

>
>> +static int smiapp_register_subdevs(struct smiapp_sensor *sensor)
>> +{
>> +	int rval;
>> +
>> +	if (sensor->scaler) {
>> +		rval = smiapp_register_subdev(
>> +			sensor, sensor->binner, sensor->scaler,
>> +			SMIAPP_PAD_SRC, SMIAPP_PAD_SINK,
>> +			MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE);
>> +		if (rval < 0)
>>   			return rval;
>> -		}
>>   	}
>>
>> -	return 0;
>> +	return smiapp_register_subdev(
>> +		sensor, sensor->pixel_array, sensor->binner,
>> +		SMIAPP_PA_PAD_SRC, SMIAPP_PAD_SINK,
>> +		MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE);
>>   }
>
> I haven't looked at the remaining code, but is sensor->scaler
> stuff being cleaned up properly if the binner part fails?

That's a very good question. I don't think it is. But that's how the 
code has always been --- there are issues left to be resolved if 
registered() fails for a reason or another. For instance, removing and 
reloading the omap3-isp module will cause a failure in the smiapp driver 
unless it's unloaded as well.

I think I prefer to fix that in a different patch(set) as this one is 
quite large already.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
