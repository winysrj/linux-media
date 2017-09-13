Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:59923 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751031AbdIMH7M (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Sep 2017 03:59:12 -0400
Subject: Re: [PATCH v12 23/26] et8ek8: Add support for flash and lens devices
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, maxime.ripard@free-electrons.com,
        robh@kernel.org, laurent.pinchart@ideasonboard.com,
        devicetree@vger.kernel.org, pavel@ucw.cz, sre@kernel.org
References: <20170912134200.19556-1-sakari.ailus@linux.intel.com>
 <20170912134200.19556-24-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b49cb26b-75cb-6a7c-e459-e468efc40ac5@xs4all.nl>
Date: Wed, 13 Sep 2017 09:59:08 +0200
MIME-Version: 1.0
In-Reply-To: <20170912134200.19556-24-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/12/2017 03:41 PM, Sakari Ailus wrote:
> From: Pavel Machek <pavel@ucw.cz>
> 
> Parse async sub-devices by using
> v4l2_subdev_fwnode_reference_parse_sensor_common().
> 
> These types devices aren't directly related to the sensor, but are
> nevertheless handled by the et8ek8 driver due to the relationship of these
> component to the main part of the camera module --- the sensor.
> 
> [Sakari Ailus: Rename fwnode function, check for ret < 0 only.]
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/i2c/et8ek8/et8ek8_driver.c | 21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/et8ek8/et8ek8_driver.c b/drivers/media/i2c/et8ek8/et8ek8_driver.c
> index c14f0fd6ded3..0ef1b8025935 100644
> --- a/drivers/media/i2c/et8ek8/et8ek8_driver.c
> +++ b/drivers/media/i2c/et8ek8/et8ek8_driver.c
> @@ -34,10 +34,12 @@
>  #include <linux/sort.h>
>  #include <linux/v4l2-mediabus.h>
>  
> +#include <media/v4l2-async.h>
>  #include <media/media-entity.h>
>  #include <media/v4l2-ctrls.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-subdev.h>
> +#include <media/v4l2-fwnode.h>
>  
>  #include "et8ek8_reg.h"
>  
> @@ -46,6 +48,7 @@
>  #define ET8EK8_MAX_MSG		8
>  
>  struct et8ek8_sensor {
> +	struct v4l2_async_notifier notifier;
>  	struct v4l2_subdev subdev;
>  	struct media_pad pad;
>  	struct v4l2_mbus_framefmt format;
> @@ -1446,6 +1449,11 @@ static int et8ek8_probe(struct i2c_client *client,
>  	sensor->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
>  	sensor->subdev.internal_ops = &et8ek8_internal_ops;
>  
> +	ret = v4l2_async_notifier_parse_fwnode_sensor_common(
> +		&client->dev, &sensor->notifier);
> +	if (ret < 0)
> +		goto err_release;
> +
>  	sensor->pad.flags = MEDIA_PAD_FL_SOURCE;
>  	ret = media_entity_pads_init(&sensor->subdev.entity, 1, &sensor->pad);
>  	if (ret < 0) {
> @@ -1453,18 +1461,27 @@ static int et8ek8_probe(struct i2c_client *client,
>  		goto err_mutex;
>  	}
>  
> +	ret = v4l2_async_subdev_notifier_register(&sensor->subdev,
> +						  &sensor->notifier);
> +	if (ret)
> +		goto err_entity;
> +
>  	ret = v4l2_async_register_subdev(&sensor->subdev);
>  	if (ret < 0)
> -		goto err_entity;
> +		goto err_async;
>  
>  	dev_dbg(dev, "initialized!\n");
>  
>  	return 0;
>  
> +err_async:
> +	v4l2_async_notifier_unregister(&sensor->notifier);
>  err_entity:
>  	media_entity_cleanup(&sensor->subdev.entity);
>  err_mutex:
>  	mutex_destroy(&sensor->power_lock);
> +err_release:
> +	v4l2_async_notifier_release(&sensor->notifier);
>  	return ret;
>  }
>  
> @@ -1480,6 +1497,8 @@ static int __exit et8ek8_remove(struct i2c_client *client)
>  	}
>  
>  	v4l2_device_unregister_subdev(&sensor->subdev);
> +	v4l2_async_notifier_unregister(&sensor->notifier);
> +	v4l2_async_notifier_release(&sensor->notifier);
>  	device_remove_file(&client->dev, &dev_attr_priv_mem);
>  	v4l2_ctrl_handler_free(&sensor->ctrl_handler);
>  	v4l2_async_unregister_subdev(&sensor->subdev);
> 
