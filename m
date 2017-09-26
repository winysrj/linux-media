Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:46351 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934968AbdIZI0i (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 04:26:38 -0400
Subject: Re: [PATCH v14 22/28] v4l: fwnode: Add a convenience function for
 registering sensors
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
References: <20170925222540.371-1-sakari.ailus@linux.intel.com>
 <20170925222540.371-24-sakari.ailus@linux.intel.com>
Cc: niklas.soderlund@ragnatech.se, maxime.ripard@free-electrons.com,
        robh@kernel.org, laurent.pinchart@ideasonboard.com,
        devicetree@vger.kernel.org, pavel@ucw.cz, sre@kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ac50fc71-c528-a703-04bb-6abc1fc7c19a@xs4all.nl>
Date: Tue, 26 Sep 2017 10:26:35 +0200
MIME-Version: 1.0
In-Reply-To: <20170925222540.371-24-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26/09/17 00:25, Sakari Ailus wrote:
> Add a convenience function for parsing firmware for information on related
> devices using v4l2_async_notifier_parse_fwnode_sensor_common() registering
> the notifier and finally the async sub-device itself.
> 
> This should be useful for sensor drivers that do not have device specific
> requirements related to firmware information parsing or the async
> framework.

I'm confused. This is a second patch 22/28 that appears to be identical to the
previous one.

I'm ignoring this one, I assume something went wrong when you mailed this series.

Regards,

	Hans

> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/v4l2-core/v4l2-async.c  |  5 +++++
>  drivers/media/v4l2-core/v4l2-fwnode.c | 41 +++++++++++++++++++++++++++++++++++
>  include/media/v4l2-async.h            | 22 +++++++++++++++++++
>  include/media/v4l2-subdev.h           |  3 +++
>  4 files changed, 71 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index 470607da96b2..f388892f43ec 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -570,6 +570,11 @@ void v4l2_async_unregister_subdev(struct v4l2_subdev *sd)
>  {
>  	struct v4l2_async_notifier *notifier = sd->notifier;
>  
> +	if (sd->subdev_notifier)
> +		v4l2_async_notifier_unregister(sd->subdev_notifier);
> +	v4l2_async_notifier_cleanup(sd->subdev_notifier);
> +	kfree(sd->subdev_notifier);
> +
>  	if (!sd->asd) {
>  		if (!list_empty(&sd->async_list))
>  			v4l2_async_cleanup(sd);
> diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
> index 4976096a1d83..622bdcc2df2d 100644
> --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> @@ -29,6 +29,7 @@
>  
>  #include <media/v4l2-async.h>
>  #include <media/v4l2-fwnode.h>
> +#include <media/v4l2-subdev.h>
>  
>  enum v4l2_fwnode_bus_type {
>  	V4L2_FWNODE_BUS_TYPE_GUESS = 0,
> @@ -814,6 +815,46 @@ int v4l2_async_notifier_parse_fwnode_sensor_common(
>  }
>  EXPORT_SYMBOL_GPL(v4l2_async_notifier_parse_fwnode_sensor_common);
>  
> +int v4l2_async_register_subdev_sensor_common(struct v4l2_subdev *sd)
> +{
> +	struct v4l2_async_notifier *notifier;
> +	int ret;
> +
> +	if (WARN_ON(!sd->dev))
> +		return -ENODEV;
> +
> +	notifier = kzalloc(sizeof(*notifier), GFP_KERNEL);
> +	if (!notifier)
> +		return -ENOMEM;
> +
> +	ret = v4l2_async_notifier_parse_fwnode_sensor_common(sd->dev,
> +							     notifier);
> +	if (ret < 0)
> +		goto out_cleanup;
> +
> +	ret = v4l2_async_subdev_notifier_register(sd, notifier);
> +	if (ret < 0)
> +		goto out_cleanup;
> +
> +	ret = v4l2_async_register_subdev(sd);
> +	if (ret < 0)
> +		goto out_unregister;
> +
> +	sd->subdev_notifier = notifier;
> +
> +	return 0;
> +
> +out_unregister:
> +	v4l2_async_notifier_unregister(notifier);
> +
> +out_cleanup:
> +	v4l2_async_notifier_cleanup(notifier);
> +	kfree(notifier);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_async_register_subdev_sensor_common);
> +
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Sakari Ailus <sakari.ailus@linux.intel.com>");
>  MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
> diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
> index 479c317fab2f..74f2ea27d117 100644
> --- a/include/media/v4l2-async.h
> +++ b/include/media/v4l2-async.h
> @@ -173,6 +173,28 @@ void v4l2_async_notifier_cleanup(struct v4l2_async_notifier *notifier);
>  int v4l2_async_register_subdev(struct v4l2_subdev *sd);
>  
>  /**
> + * v4l2_async_register_subdev_sensor_common - registers a sensor sub-device to
> + *					      the asynchronous sub-device
> + *					      framework and parse set up common
> + *					      sensor related devices
> + *
> + * @sd: pointer to struct &v4l2_subdev
> + *
> + * This function is just like v4l2_async_register_subdev() with the exception
> + * that calling it will also parse firmware interfaces for remote references
> + * using v4l2_async_notifier_parse_fwnode_sensor_common() and registers the
> + * async sub-devices. The sub-device is similarly unregistered by calling
> + * v4l2_async_unregister_subdev().
> + *
> + * While registered, the subdev module is marked as in-use.
> + *
> + * An error is returned if the module is no longer loaded on any attempts
> + * to register it.
> + */
> +int __must_check v4l2_async_register_subdev_sensor_common(
> +	struct v4l2_subdev *sd);
> +
> +/**
>   * v4l2_async_unregister_subdev - unregisters a sub-device to the asynchronous
>   * 	subdevice framework
>   *
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index e83872078376..ec399c770301 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -793,6 +793,8 @@ struct v4l2_subdev_platform_data {
>   *	list.
>   * @asd: Pointer to respective &struct v4l2_async_subdev.
>   * @notifier: Pointer to the managing notifier.
> + * @subdev_notifier: A sub-device notifier implicitly registered for the sub-
> + *		     device using v4l2_device_register_sensor_subdev().
>   * @pdata: common part of subdevice platform data
>   *
>   * Each instance of a subdev driver should create this struct, either
> @@ -823,6 +825,7 @@ struct v4l2_subdev {
>  	struct list_head async_list;
>  	struct v4l2_async_subdev *asd;
>  	struct v4l2_async_notifier *notifier;
> +	struct v4l2_async_notifier *subdev_notifier;
>  	struct v4l2_subdev_platform_data *pdata;
>  };
>  
> 
