Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:38430 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751111AbdIKJs2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 05:48:28 -0400
Subject: Re: [PATCH v10 21/24] smiapp: Add support for flash and lens devices
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, robh@kernel.org,
        laurent.pinchart@ideasonboard.com, linux-acpi@vger.kernel.org,
        mika.westerberg@intel.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
References: <20170911080008.21208-1-sakari.ailus@linux.intel.com>
 <20170911080008.21208-22-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <04981ec0-710e-1367-03fc-501314c45d5f@xs4all.nl>
Date: Mon, 11 Sep 2017 11:48:23 +0200
MIME-Version: 1.0
In-Reply-To: <20170911080008.21208-22-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/11/2017 10:00 AM, Sakari Ailus wrote:
> Parse async sub-devices by using
> v4l2_subdev_fwnode_reference_parse_sensor_common().
> 
> These types devices aren't directly related to the sensor, but are
> nevertheless handled by the smiapp driver due to the relationship of these
> component to the main part of the camera module --- the sensor.
> 
> This does not yet address providing the user space with information on how
> to associate the sensor or lens devices but the kernel now has the
> necessary information to do that.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/i2c/smiapp/smiapp-core.c | 38 +++++++++++++++++++++++++++-------
>  drivers/media/i2c/smiapp/smiapp.h      |  4 +++-
>  2 files changed, 33 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
> index 700f433261d0..a65a839135d2 100644
> --- a/drivers/media/i2c/smiapp/smiapp-core.c
> +++ b/drivers/media/i2c/smiapp/smiapp-core.c
> @@ -31,7 +31,7 @@
>  #include <linux/regulator/consumer.h>
>  #include <linux/slab.h>
>  #include <linux/smiapp.h>
> -#include <linux/v4l2-mediabus.h>
> +#include <media/v4l2-async.h>
>  #include <media/v4l2-fwnode.h>
>  #include <media/v4l2-device.h>
>  
> @@ -2887,17 +2887,24 @@ static int smiapp_probe(struct i2c_client *client,
>  	v4l2_i2c_subdev_init(&sensor->src->sd, client, &smiapp_ops);
>  	sensor->src->sd.internal_ops = &smiapp_internal_src_ops;
>  
> +	rval = v4l2_fwnode_reference_parse_sensor_common(
> +		&client->dev, &sensor->notifier);
> +	if (rval < 0)
> +		return rval;
> +
>  	sensor->vana = devm_regulator_get(&client->dev, "vana");
>  	if (IS_ERR(sensor->vana)) {
>  		dev_err(&client->dev, "could not get regulator for vana\n");
> -		return PTR_ERR(sensor->vana);
> +		rval = PTR_ERR(sensor->vana);
> +		goto out_release_async_notifier;
>  	}
>  
>  	sensor->ext_clk = devm_clk_get(&client->dev, NULL);
>  	if (IS_ERR(sensor->ext_clk)) {
>  		dev_err(&client->dev, "could not get clock (%ld)\n",
>  			PTR_ERR(sensor->ext_clk));
> -		return -EPROBE_DEFER;
> +		rval = -EPROBE_DEFER;
> +		goto out_release_async_notifier;
>  	}
>  
>  	rval = clk_set_rate(sensor->ext_clk, sensor->hwcfg->ext_clk);
> @@ -2905,17 +2912,19 @@ static int smiapp_probe(struct i2c_client *client,
>  		dev_err(&client->dev,
>  			"unable to set clock freq to %u\n",
>  			sensor->hwcfg->ext_clk);
> -		return rval;
> +		goto out_release_async_notifier;
>  	}
>  
>  	sensor->xshutdown = devm_gpiod_get_optional(&client->dev, "xshutdown",
>  						    GPIOD_OUT_LOW);
> -	if (IS_ERR(sensor->xshutdown))
> -		return PTR_ERR(sensor->xshutdown);
> +	if (IS_ERR(sensor->xshutdown)) {
> +		rval = PTR_ERR(sensor->xshutdown);
> +		goto out_release_async_notifier;
> +	}
>  
>  	rval = smiapp_power_on(&client->dev);
>  	if (rval < 0)
> -		return rval;
> +		goto out_release_async_notifier;
>  
>  	rval = smiapp_identify_module(sensor);
>  	if (rval) {
> @@ -3092,9 +3101,14 @@ static int smiapp_probe(struct i2c_client *client,
>  	if (rval < 0)
>  		goto out_media_entity_cleanup;
>  
> +	rval = v4l2_async_subdev_notifier_register(&sensor->src->sd,
> +						   &sensor->notifier);
> +	if (rval)
> +		goto out_media_entity_cleanup;
> +
>  	rval = v4l2_async_register_subdev(&sensor->src->sd);
>  	if (rval < 0)
> -		goto out_media_entity_cleanup;
> +		goto out_unregister_async_notifier;
>  
>  	pm_runtime_set_active(&client->dev);
>  	pm_runtime_get_noresume(&client->dev);
> @@ -3105,6 +3119,9 @@ static int smiapp_probe(struct i2c_client *client,
>  
>  	return 0;
>  
> +out_unregister_async_notifier:
> +	v4l2_async_notifier_unregister(&sensor->notifier);
> +
>  out_media_entity_cleanup:
>  	media_entity_cleanup(&sensor->src->sd.entity);
>  
> @@ -3114,6 +3131,9 @@ static int smiapp_probe(struct i2c_client *client,
>  out_power_off:
>  	smiapp_power_off(&client->dev);
>  
> +out_release_async_notifier:
> +	v4l2_async_notifier_release(&sensor->notifier);
> +
>  	return rval;
>  }
>  
> @@ -3124,6 +3144,8 @@ static int smiapp_remove(struct i2c_client *client)
>  	unsigned int i;
>  
>  	v4l2_async_unregister_subdev(subdev);
> +	v4l2_async_notifier_unregister(&sensor->notifier);
> +	v4l2_async_notifier_release(&sensor->notifier);
>  
>  	pm_runtime_disable(&client->dev);
>  	if (!pm_runtime_status_suspended(&client->dev))
> diff --git a/drivers/media/i2c/smiapp/smiapp.h b/drivers/media/i2c/smiapp/smiapp.h
> index f74d695018b9..be92cb5713f4 100644
> --- a/drivers/media/i2c/smiapp/smiapp.h
> +++ b/drivers/media/i2c/smiapp/smiapp.h
> @@ -20,9 +20,10 @@
>  #define __SMIAPP_PRIV_H_
>  
>  #include <linux/mutex.h>
> +#include <media/i2c/smiapp.h>
> +#include <media/v4l2-async.h>
>  #include <media/v4l2-ctrls.h>
>  #include <media/v4l2-subdev.h>
> -#include <media/i2c/smiapp.h>
>  
>  #include "smiapp-pll.h"
>  #include "smiapp-reg.h"
> @@ -172,6 +173,7 @@ struct smiapp_subdev {
>   * struct smiapp_sensor - Main device structure
>   */
>  struct smiapp_sensor {
> +	struct v4l2_async_notifier notifier;
>  	/*
>  	 * "mutex" is used to serialise access to all fields here
>  	 * except v4l2_ctrls at the end of the struct. "mutex" is also
> 
