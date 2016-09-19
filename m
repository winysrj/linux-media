Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:9020 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932094AbcISVT7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 17:19:59 -0400
Subject: Re: [PATCH v2 09/17] smiapp: Read frame format earlier
To: Sebastian Reichel <sre@kernel.org>
Cc: linux-media@vger.kernel.org
References: <1473938551-14503-1-git-send-email-sakari.ailus@linux.intel.com>
 <1473938551-14503-10-git-send-email-sakari.ailus@linux.intel.com>
 <20160919211405.bx37cjzzkjh5r2qo@earth>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <57E0567A.4070609@linux.intel.com>
Date: Tue, 20 Sep 2016 00:19:54 +0300
MIME-Version: 1.0
In-Reply-To: <20160919211405.bx37cjzzkjh5r2qo@earth>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sebastian,

Sebastian Reichel wrote:
> Hi,
>
> On Thu, Sep 15, 2016 at 02:22:23PM +0300, Sakari Ailus wrote:
>> The information gathered during frame format reading will be required
>> earlier in the initialisation when it was available. Also return an error
>> if frame format cannot be obtained.
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>> ---
>>   drivers/media/i2c/smiapp/smiapp-core.c | 8 ++++++--
>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
>> index 0b5671c..c9aee83 100644
>> --- a/drivers/media/i2c/smiapp/smiapp-core.c
>> +++ b/drivers/media/i2c/smiapp/smiapp-core.c
>> @@ -2890,6 +2890,12 @@ static int smiapp_probe(struct i2c_client *client,
>>   		goto out_power_off;
>>   	}
>>
>> +	rval = smiapp_read_frame_fmt(sensor);
>> +	if (rval) {
>> +		rval = -ENODEV;
>> +		goto out_power_off;
>> +	}
>> +
>>   	/*
>>   	 * Handle Sensor Module orientation on the board.
>>   	 *
>> @@ -3013,8 +3019,6 @@ static int smiapp_probe(struct i2c_client *client,
>>
>>   	sensor->pixel_array->sd.entity.function = MEDIA_ENT_F_CAM_SENSOR;
>>
>> -	/* final steps */
>> -	smiapp_read_frame_fmt(sensor);
>>   	rval = smiapp_init_controls(sensor);
>>   	if (rval < 0)
>>   		goto out_cleanup;
>
> Is this missing a Fixes tag, or will it only be required earlier for
> future patches?

It's primarily for future patches. Reading the frame format will require 
limits but hardly any other information. On the other hand, the frame 
format will very likely be needed elsewhere, hence the move.

The missing return value check is just a bug which I believe has been 
there since around 2011.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
