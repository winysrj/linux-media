Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:15409 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752601AbcISVKF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 17:10:05 -0400
Subject: Re: [PATCH v2 07/17] smiapp: Always initialise the sensor in probe
To: Sebastian Reichel <sre@kernel.org>
Cc: linux-media@vger.kernel.org
References: <1473938551-14503-1-git-send-email-sakari.ailus@linux.intel.com>
 <1473938551-14503-8-git-send-email-sakari.ailus@linux.intel.com>
 <20160919205925.myramm47julqwcxb@earth>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <57E05427.1030800@linux.intel.com>
Date: Tue, 20 Sep 2016 00:09:59 +0300
MIME-Version: 1.0
In-Reply-To: <20160919205925.myramm47julqwcxb@earth>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sebastian Reichel wrote:
> Hi,
>
> On Thu, Sep 15, 2016 at 02:22:21PM +0300, Sakari Ailus wrote:
>> Initialise the sensor in probe. The reason why it wasn't previously done
>> in case of platform data was that the probe() of the driver that provided
>> the clock through the set_xclk() callback would need to finish before the
>> probe() function of the smiapp driver. The set_xclk() callback no longer
>> exists.
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>> ---
>>   drivers/media/i2c/smiapp/smiapp-core.c | 53 ++++++++++++----------------------
>>   1 file changed, 19 insertions(+), 34 deletions(-)
>>
>> diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
>> index 5d251b4..13322f3 100644
>> --- a/drivers/media/i2c/smiapp/smiapp-core.c
>> +++ b/drivers/media/i2c/smiapp/smiapp-core.c
>> @@ -2530,8 +2530,19 @@ static int smiapp_register_subdev(struct smiapp_sensor *sensor,
>>   	return 0;
>>   }
>>
>> -static int smiapp_register_subdevs(struct smiapp_sensor *sensor)
>> +static void smiapp_cleanup(struct smiapp_sensor *sensor)
>> +{
>> +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
>> +
>> +	device_remove_file(&client->dev, &dev_attr_nvm);
>> +	device_remove_file(&client->dev, &dev_attr_ident);
>> +
>> +	smiapp_free_controls(sensor);
>> +}
>> +
>> +static int smiapp_registered(struct v4l2_subdev *subdev)
>>   {
>> +	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
>>   	int rval;
>>
>>   	if (sensor->scaler) {
>> @@ -2540,23 +2551,18 @@ static int smiapp_register_subdevs(struct smiapp_sensor *sensor)
>>   			SMIAPP_PAD_SRC, SMIAPP_PAD_SINK,
>>   			MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE);
>>   		if (rval < 0)
>> -			return rval;
>> +			goto out_err;
>>   	}
>>
>>   	return smiapp_register_subdev(
>>   		sensor, sensor->pixel_array, sensor->binner,
>>   		SMIAPP_PA_PAD_SRC, SMIAPP_PAD_SINK,
>>   		MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE);
>
> I guess you should also handle errors from the second
> smiapp_register_subdev call?

Um, yes. Perhaps it'd be better just fix it here now that we still 
remember the problem. :-) I'll fix that for v2.

>
>> -}
>>
>> -static void smiapp_cleanup(struct smiapp_sensor *sensor)
>> -{
>> -	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
>> -
>> -	device_remove_file(&client->dev, &dev_attr_nvm);
>> -	device_remove_file(&client->dev, &dev_attr_ident);
>> +out_err:
>> +	smiapp_cleanup(sensor);
>>
>> -	smiapp_free_controls(sensor);
>> +	return rval;
>>   }
>
> -- Sebastian
>


-- 
Sakari Ailus
sakari.ailus@linux.intel.com
