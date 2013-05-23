Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:4068 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758012Ab3EWKlA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 May 2013 06:41:00 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andrzej Hajda <a.hajda@samsung.com>
Subject: Re: [PATCH RFC v3 3/3] media: added managed v4l2/i2c subdevice initialization
Date: Thu, 23 May 2013 12:40:41 +0200
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	hj210.choi@samsung.com, sw0312.kim@samsung.com
References: <1368692074-483-1-git-send-email-a.hajda@samsung.com> <1368692074-483-4-git-send-email-a.hajda@samsung.com>
In-Reply-To: <1368692074-483-4-git-send-email-a.hajda@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201305231240.42035.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu 16 May 2013 10:14:34 Andrzej Hajda wrote:
> This patch adds managed version of initialization
> function for v4l2/i2c subdevices.
> 
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
> v3:
> 	- removed devm_v4l2_subdev_(init|free),
> v2:
> 	- changes of v4l2-ctrls.h moved to proper patch
> ---
>  drivers/media/v4l2-core/v4l2-common.c |   10 ++++++++++
>  drivers/media/v4l2-core/v4l2-subdev.c |   25 +++++++++++++++++++++++++
>  include/media/v4l2-common.h           |    2 ++
>  include/media/v4l2-subdev.h           |    2 ++
>  4 files changed, 39 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
> index 3fed63f..96aac931 100644
> --- a/drivers/media/v4l2-core/v4l2-common.c
> +++ b/drivers/media/v4l2-core/v4l2-common.c
> @@ -301,7 +301,17 @@ void v4l2_i2c_subdev_init(struct v4l2_subdev *sd, struct i2c_client *client,
>  }
>  EXPORT_SYMBOL_GPL(v4l2_i2c_subdev_init);
>  
> +int devm_v4l2_i2c_subdev_init(struct v4l2_subdev *sd, struct i2c_client *client,
> +			      const struct v4l2_subdev_ops *ops)
> +{
> +	int ret;
>  
> +	ret = devm_v4l2_subdev_bind(&client->dev, sd);
> +	if (!ret)
> +		v4l2_i2c_subdev_init(sd, client, ops);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(devm_v4l2_i2c_subdev_init);
>  
>  /* Load an i2c sub-device. */
>  struct v4l2_subdev *v4l2_i2c_new_subdev_board(struct v4l2_device *v4l2_dev,
> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
> index 996c248..d79ee22 100644
> --- a/drivers/media/v4l2-core/v4l2-subdev.c
> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
> @@ -474,3 +474,28 @@ void v4l2_subdev_init(struct v4l2_subdev *sd, const struct v4l2_subdev_ops *ops)
>  #endif
>  }
>  EXPORT_SYMBOL(v4l2_subdev_init);
> +
> +static void devm_v4l2_subdev_release(struct device *dev, void *res)
> +{
> +	struct v4l2_subdev **sd = res;
> +
> +	v4l2_device_unregister_subdev(*sd);
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +	media_entity_cleanup(&(*sd)->entity);
> +#endif
> +}
> +
> +int devm_v4l2_subdev_bind(struct device *dev, struct v4l2_subdev *sd)
> +{
> +	struct v4l2_subdev **dr;
> +
> +	dr = devres_alloc(devm_v4l2_subdev_release, sizeof(*dr), GFP_KERNEL);
> +	if (!dr)
> +		return -ENOMEM;
> +
> +	*dr = sd;
> +	devres_add(dev, dr);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(devm_v4l2_subdev_bind);
> diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
> index 1d93c48..da62e2b 100644
> --- a/include/media/v4l2-common.h
> +++ b/include/media/v4l2-common.h
> @@ -136,6 +136,8 @@ struct v4l2_subdev *v4l2_i2c_new_subdev_board(struct v4l2_device *v4l2_dev,
>  /* Initialize a v4l2_subdev with data from an i2c_client struct */
>  void v4l2_i2c_subdev_init(struct v4l2_subdev *sd, struct i2c_client *client,
>  		const struct v4l2_subdev_ops *ops);
> +int devm_v4l2_i2c_subdev_init(struct v4l2_subdev *sd, struct i2c_client *client,
> +		const struct v4l2_subdev_ops *ops);
>  /* Return i2c client address of v4l2_subdev. */
>  unsigned short v4l2_i2c_subdev_addr(struct v4l2_subdev *sd);
>  
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 5298d67..e086cfe 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -657,6 +657,8 @@ int v4l2_subdev_link_validate(struct media_link *link);
>  void v4l2_subdev_init(struct v4l2_subdev *sd,
>  		      const struct v4l2_subdev_ops *ops);
>  
> +int devm_v4l2_subdev_bind(struct device *dev, struct v4l2_subdev *sd);
> +
>  /* Call an ops of a v4l2_subdev, doing the right checks against
>     NULL pointers.
>  
> 
