Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38046 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750822AbdISMIV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 08:08:21 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, robh@kernel.org,
        hverkuil@xs4all.nl, devicetree@vger.kernel.org, pavel@ucw.cz,
        sre@kernel.org
Subject: Re: [PATCH v13 21/25] smiapp: Add support for flash and lens devices
Date: Tue, 19 Sep 2017 15:08:25 +0300
Message-ID: <1881974.bD6jRInLY1@avalon>
In-Reply-To: <20170915141724.23124-22-sakari.ailus@linux.intel.com>
References: <20170915141724.23124-1-sakari.ailus@linux.intel.com> <20170915141724.23124-22-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Friday, 15 September 2017 17:17:20 EEST Sakari Ailus wrote:
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
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Pavel Machek <pavel@ucw.cz>

Something is bothering me here, not so much in the contents of the patch 
itself than in its nature. There are four patches in this series that add 
support for flash and lens devices to the smiapp, et8ek8, ov5670 and ov13858 
drivers. We have way more sensor drivers than that, and I don't really want to 
patch them all to support flash and lens. I believe a less intrusive approach, 
more focussed on the V4L2 core, is needed.

> ---
>  drivers/media/i2c/smiapp/smiapp-core.c | 38 ++++++++++++++++++++++++-------
>  drivers/media/i2c/smiapp/smiapp.h      |  4 +++-
>  2 files changed, 33 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/i2c/smiapp/smiapp-core.c
> b/drivers/media/i2c/smiapp/smiapp-core.c index 700f433261d0..a4735a96ea41
> 100644
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
> +	rval = v4l2_async_notifier_parse_fwnode_sensor_common(
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
> diff --git a/drivers/media/i2c/smiapp/smiapp.h
> b/drivers/media/i2c/smiapp/smiapp.h index f74d695018b9..be92cb5713f4 100644
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


-- 
Regards,

Laurent Pinchart
