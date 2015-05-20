Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:36526 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745AbbETOUz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2015 10:20:55 -0400
Message-id: <555C9843.3020409@samsung.com>
Date: Wed, 20 May 2015 16:20:51 +0200
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
	cooloney@gmail.com, g.liakhovetski@gmx.de, s.nawrocki@samsung.com,
	laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com
Subject: Re: [PATCH 1/5] v4l: async: Add a pointer to of_node to struct
 v4l2_subdev, match it
References: <1432076645-4799-1-git-send-email-sakari.ailus@iki.fi>
 <1432076645-4799-2-git-send-email-sakari.ailus@iki.fi>
In-reply-to: <1432076645-4799-2-git-send-email-sakari.ailus@iki.fi>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/20/2015 01:04 AM, Sakari Ailus wrote:
> V4L2 async sub-devices are currently matched (OF case) based on the struct
> device_node pointer in struct device. LED devices may have more than one
> LED, and in that case the OF node to match is not directly the device's
> node, but a LED's node.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>   drivers/media/v4l2-core/v4l2-async.c  |   34 +++++++++++++++++++++------------
>   drivers/media/v4l2-core/v4l2-device.c |    3 +++
>   include/media/v4l2-subdev.h           |    2 ++
>   3 files changed, 27 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index 85a6a34..bcdd140 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -22,10 +22,10 @@
>   #include <media/v4l2-device.h>
>   #include <media/v4l2-subdev.h>
>
> -static bool match_i2c(struct device *dev, struct v4l2_async_subdev *asd)
> +static bool match_i2c(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
>   {
>   #if IS_ENABLED(CONFIG_I2C)
> -	struct i2c_client *client = i2c_verify_client(dev);
> +	struct i2c_client *client = i2c_verify_client(sd->dev);
>   	return client &&
>   		asd->match.i2c.adapter_id == client->adapter->nr &&
>   		asd->match.i2c.address == client->addr;
> @@ -34,14 +34,27 @@ static bool match_i2c(struct device *dev, struct v4l2_async_subdev *asd)
>   #endif
>   }
>
> -static bool match_devname(struct device *dev, struct v4l2_async_subdev *asd)
> +static bool match_devname(struct v4l2_subdev *sd,
> +			  struct v4l2_async_subdev *asd)
>   {
> -	return !strcmp(asd->match.device_name.name, dev_name(dev));
> +	return !strcmp(asd->match.device_name.name, dev_name(sd->dev));
>   }
>
> -static bool match_of(struct device *dev, struct v4l2_async_subdev *asd)
> +static bool match_of(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
>   {
> -	return dev->of_node == asd->match.of.node;
> +	struct device_node *of_node =
> +		sd->of_node ? sd->of_node : sd->dev->of_node;
> +
> +	return of_node == asd->match.of.node;
> +}
> +
> +static bool match_custom(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
> +{
> +	if (!asd->match.custom.match)
> +		/* Match always */
> +		return true;
> +
> +	return asd->match.custom.match(sd->dev, asd);
>   }
>
>   static LIST_HEAD(subdev_list);
> @@ -51,17 +64,14 @@ static DEFINE_MUTEX(list_lock);
>   static struct v4l2_async_subdev *v4l2_async_belongs(struct v4l2_async_notifier *notifier,
>   						    struct v4l2_subdev *sd)
>   {
> +	bool (*match)(struct v4l2_subdev *, struct v4l2_async_subdev *);
>   	struct v4l2_async_subdev *asd;
> -	bool (*match)(struct device *, struct v4l2_async_subdev *);
>
>   	list_for_each_entry(asd, &notifier->waiting, list) {
>   		/* bus_type has been verified valid before */
>   		switch (asd->match_type) {
>   		case V4L2_ASYNC_MATCH_CUSTOM:
> -			match = asd->match.custom.match;
> -			if (!match)
> -				/* Match always */
> -				return asd;
> +			match = match_custom;
>   			break;
>   		case V4L2_ASYNC_MATCH_DEVNAME:
>   			match = match_devname;
> @@ -79,7 +89,7 @@ static struct v4l2_async_subdev *v4l2_async_belongs(struct v4l2_async_notifier *
>   		}
>
>   		/* match cannot be NULL here */
> -		if (match(sd->dev, asd))
> +		if (match(sd, asd))
>   			return asd;
>   	}
>
> diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
> index 5b0a30b..a741c6c 100644
> --- a/drivers/media/v4l2-core/v4l2-device.c
> +++ b/drivers/media/v4l2-core/v4l2-device.c
> @@ -157,6 +157,9 @@ int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
>   	/* Warn if we apparently re-register a subdev */
>   	WARN_ON(sd->v4l2_dev != NULL);
>
> +	if (!sd->of_node && sd->dev)
> +		sd->of_node = sd->dev->of_node;
> +
>   	/*
>   	 * The reason to acquire the module here is to avoid unloading
>   	 * a module of sub-device which is registered to a media
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 8f5da73..5c51987 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -603,6 +603,8 @@ struct v4l2_subdev {
>   	struct video_device *devnode;
>   	/* pointer to the physical device, if any */
>   	struct device *dev;
> +	/* A device_node of the sub-device, iff not dev->of_node. */
> +	struct device_node *of_node;
>   	/* Links this subdev to a global subdev_list or @notifier->done list. */
>   	struct list_head async_list;
>   	/* Pointer to respective struct v4l2_async_subdev. */
>

I've tested it with V4L2_ASYNC_MATCH_OF matching type.
For this you can add my:

Tested-by: Jacek Anaszewski <j.anaszewski@samsung.com>

-- 
Best Regards,
Jacek Anaszewski
