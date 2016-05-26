Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35455 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbcEZDqO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2016 23:46:14 -0400
Subject: Re: [PATCHv3] support for AD5820 camera auto-focus coil
To: Pavel Machek <pavel@ucw.cz>
References: <20160517181927.GA28741@amd> <20160521054336.GA27123@amd>
 <573FFF51.1000004@gmail.com> <20160521105607.GA20071@amd>
 <574049EF.2090208@gmail.com> <20160524090433.GA1277@amd>
 <57441BF8.60606@gmail.com> <20160524202059.GB18536@amd>
Cc: pali.rohar@gmail.com, sre@kernel.org,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
	aaro.koskinen@iki.fi, patrikbachan@gmail.com, serge@hallyn.com,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	sakari.ailus@iki.fi
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Message-ID: <57467180.5070201@gmail.com>
Date: Thu, 26 May 2016 06:46:08 +0300
MIME-Version: 1.0
In-Reply-To: <20160524202059.GB18536@amd>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 24.05.2016 23:20, Pavel Machek wrote:
> Hi!
>
>>>> devm_regulator_get()?
>>>
>>> I'd rather avoid devm_ here. Driver is simple enough to allow it.
>>>
>>
>> Now thinking about it, what would happen here if regulator_get() returns
>> -EPROBE_DEFER? Wouldn't it be better to move regulator_get to the probe()
>> function, something like:
>
> Ok, I can do it.
>
> Oh, and don't try to complain about newlines before returns. It looks
> better this way.
>

All I complain about is missing empty line before a final return at the 
end of a function :). I guess it is a matter of preference though.

>> static int ad5820_probe(struct i2c_client *client,
>> 			const struct i2c_device_id *devid)
>> {
>> 	struct ad5820_device *coil;
>> 	int ret = 0;
>>
>> 	coil = devm_kzalloc(sizeof(*coil), GFP_KERNEL);
>> 	if (coil == NULL)
>> 		return -ENOMEM;
>>
>> 	coil->vana = devm_regulator_get(&client->dev, NULL);
>> 	if (IS_ERR(coil->vana)) {
>> 		ret = PTR_ERR(coil->vana);
>> 		if (ret != -EPROBE_DEFER)
>> 			dev_err(&client->dev, "could not get regulator for vana\n");
>> 		return ret;
>> 	}
>>
>> 	mutex_init(&coil->power_lock);
>> ...
>>
>> with the appropriate changes to remove() because of the devm API
>> 			usage.
>
> Something like this?
>

Didn't try to apply it, but yes, looks right. Besides the missing
mutex_destroy(&coil->power_lock); pointed out by Sakari.

> diff --git a/drivers/media/i2c/ad5820.c b/drivers/media/i2c/ad5820.c
> index f956bd3..f871366 100644
> --- a/drivers/media/i2c/ad5820.c
> +++ b/drivers/media/i2c/ad5820.c
> @@ -8,7 +8,7 @@
>    * Copyright (C) 2016 Pavel Machek <pavel@ucw.cz>
>    *
>    * Contact: Tuukka Toivonen
> - *          Sakari Ailus
> + *	    Sakari Ailus
>    *
>    * Based on af_d88.c by Texas Instruments.
>    *
> @@ -263,13 +263,6 @@ static int ad5820_init_controls(struct ad5820_device *coil)
>   static int ad5820_registered(struct v4l2_subdev *subdev)
>   {
>   	struct ad5820_device *coil = to_ad5820_device(subdev);
> -	struct i2c_client *client = v4l2_get_subdevdata(subdev);
> -
> -	coil->vana = regulator_get(&client->dev, "VANA");
> -	if (IS_ERR(coil->vana)) {
> -		dev_err(&client->dev, "could not get regulator for vana\n");
> -		return -ENODEV;
> -	}
>
>   	return ad5820_init_controls(coil);
>   }
> @@ -367,10 +360,18 @@ static int ad5820_probe(struct i2c_client *client,
>   	struct ad5820_device *coil;
>   	int ret = 0;
>
> -	coil = kzalloc(sizeof(*coil), GFP_KERNEL);
> +	coil = devm_kzalloc(sizeof(*coil), GFP_KERNEL);
>   	if (!coil)
>   		return -ENOMEM;
>
> +	coil->vana = devm_regulator_get(&client->dev, NULL);
> +	if (IS_ERR(coil->vana)) {
> +		ret = PTR_ERR(coil->vana);
> +		if (ret != -EPROBE_DEFER)
> +			dev_err(&client->dev, "could not get regulator for vana\n");
> +		return ret;
> +	}
> +	
>   	mutex_init(&coil->power_lock);
>
>   	v4l2_i2c_subdev_init(&coil->subdev, client, &ad5820_ops);
> @@ -390,10 +391,6 @@ static int ad5820_probe(struct i2c_client *client,
>
>   cleanup:
>   	media_entity_cleanup(&coil->subdev.entity);
> -
> -free:
> -	kfree(coil);
> -
>   	return ret;
>   }
>
> @@ -405,11 +402,6 @@ static int __exit ad5820_remove(struct i2c_client *client)
>   	v4l2_device_unregister_subdev(&coil->subdev);
>   	v4l2_ctrl_handler_free(&coil->ctrls);
>   	media_entity_cleanup(&coil->subdev.entity);
> -	if (coil->vana)
> -		regulator_put(coil->vana);
> -
> -	kfree(coil);
> -
>   	return 0;
>   }
>
