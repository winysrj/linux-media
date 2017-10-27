Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:44816 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752052AbdJ0NGE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Oct 2017 09:06:04 -0400
Received: by mail-lf0-f66.google.com with SMTP id 75so7370725lfx.1
        for <linux-media@vger.kernel.org>; Fri, 27 Oct 2017 06:06:03 -0700 (PDT)
Date: Fri, 27 Oct 2017 15:06:01 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, maxime.ripard@free-electrons.com,
        hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        pavel@ucw.cz, sre@kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v16 26/32] v4l: fwnode: Add a convenience function for
 registering sensors
Message-ID: <20171027130601.GD8854@bigcity.dyn.berto.se>
References: <20171026075342.5760-1-sakari.ailus@linux.intel.com>
 <20171026075342.5760-27-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171026075342.5760-27-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2017-10-26 10:53:36 +0300, Sakari Ailus wrote:
> Add a convenience function for parsing firmware for information on related
> devices using v4l2_async_notifier_parse_fwnode_sensor_common() registering
> the notifier and finally the async sub-device itself.
> 
> This should be useful for sensor drivers that do not have device specific
> requirements related to firmware information parsing or the async
> framework.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
>  drivers/media/v4l2-core/v4l2-async.c  | 19 ++++++++++++----
>  drivers/media/v4l2-core/v4l2-fwnode.c | 41 +++++++++++++++++++++++++++++++++++
>  include/media/v4l2-async.h            | 22 +++++++++++++++++++
>  include/media/v4l2-subdev.h           |  3 +++
>  4 files changed, 81 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index b4e88eef195f..e81a72b8d46e 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -474,19 +474,25 @@ int v4l2_async_subdev_notifier_register(struct v4l2_subdev *sd,
>  }
>  EXPORT_SYMBOL(v4l2_async_subdev_notifier_register);
>  
> -void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
> +static void __v4l2_async_notifier_unregister(
> +	struct v4l2_async_notifier *notifier)
>  {
> -	if (!notifier->v4l2_dev && !notifier->sd)
> +	if (!notifier || (!notifier->v4l2_dev && !notifier->sd))
>  		return;
>  
> -	mutex_lock(&list_lock);
> -
>  	v4l2_async_notifier_unbind_all_subdevs(notifier);
>  
>  	notifier->sd = NULL;
>  	notifier->v4l2_dev = NULL;
>  
>  	list_del(&notifier->list);
> +}
> +
> +void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
> +{
> +	mutex_lock(&list_lock);
> +
> +	__v4l2_async_notifier_unregister(notifier);
>  
>  	mutex_unlock(&list_lock);
>  }
> @@ -596,6 +602,11 @@ void v4l2_async_unregister_subdev(struct v4l2_subdev *sd)
>  {
>  	mutex_lock(&list_lock);
>  
> +	__v4l2_async_notifier_unregister(sd->subdev_notifier);
> +	v4l2_async_notifier_cleanup(sd->subdev_notifier);
> +	kfree(sd->subdev_notifier);
> +	sd->subdev_notifier = NULL;
> +
>  	if (sd->asd) {
>  		struct v4l2_async_notifier *notifier = sd->notifier;
>  
> diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
> index 1234bd1a2f49..82af608fd626 100644
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
> @@ -900,6 +901,46 @@ int v4l2_async_notifier_parse_fwnode_sensor_common(
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
> index 8d8cfc3f3100..6152434cbe82 100644
> --- a/include/media/v4l2-async.h
> +++ b/include/media/v4l2-async.h
> @@ -174,6 +174,28 @@ void v4l2_async_notifier_cleanup(struct v4l2_async_notifier *notifier);
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
> -- 
> 2.11.0
> 

-- 
Regards,
Niklas Söderlund
