Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38388 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbaLGXt3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Dec 2014 18:49:29 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	prabhakar.csengg@gmail.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 6/8] v4l2-subdev: add v4l2_subdev_create_pad_configs
Date: Mon, 08 Dec 2014 01:50:11 +0200
Message-ID: <6152026.ecLNx03bSo@avalon>
In-Reply-To: <1417686899-30149-7-git-send-email-hverkuil@xs4all.nl>
References: <1417686899-30149-1-git-send-email-hverkuil@xs4all.nl> <1417686899-30149-7-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Thursday 04 December 2014 10:54:57 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> When a new subdevice is registered this new function is called to allocate
> and initialize a pad_config array. This allows bridge drivers to use the
> pad ops that require such an array as argument.

While I agree that a v4l2_subdev_create_pad_configs() function is needed, I 
don't think the pad configs should be stored in the subdev structure. This 
would defeat the whole point of having a try mechanism based on private 
configs. Bridge drivers should instead create the configs on demand, use them, 
and delete them afterwards.

> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/v4l2-core/v4l2-device.c | 11 ++++++++++-
>  drivers/media/v4l2-core/v4l2-subdev.c | 36 ++++++++++++++++++++++++++++++++
>  include/media/v4l2-subdev.h           |  4 ++++
>  3 files changed, 50 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-device.c
> b/drivers/media/v4l2-core/v4l2-device.c index 015f92a..5c8d402 100644
> --- a/drivers/media/v4l2-core/v4l2-device.c
> +++ b/drivers/media/v4l2-core/v4l2-device.c
> @@ -183,12 +183,16 @@ int v4l2_device_register_subdev(struct v4l2_device
> *v4l2_dev, if (err)
>  		goto error_unregister;
> 
> +	err = v4l2_subdev_create_pad_configs(sd);
> +	if (err)
> +		goto error_unregister;
> +

I don't thin

>  #if defined(CONFIG_MEDIA_CONTROLLER)
>  	/* Register the entity. */
>  	if (v4l2_dev->mdev) {
>  		err = media_device_register_entity(v4l2_dev->mdev, entity);
>  		if (err < 0)
> -			goto error_unregister;
> +			goto error_free_pad_configs;
>  	}
>  #endif
> 
> @@ -198,6 +202,9 @@ int v4l2_device_register_subdev(struct v4l2_device
> *v4l2_dev,
> 
>  	return 0;
> 
> +error_free_pad_configs:
> +	kfree(sd->pad_configs);
> +	sd->pad_configs = NULL;
>  error_unregister:
>  	if (sd->internal_ops && sd->internal_ops->unregistered)
>  		sd->internal_ops->unregistered(sd);
> @@ -282,6 +289,8 @@ void v4l2_device_unregister_subdev(struct v4l2_subdev
> *sd)
> 
>  	if (sd->internal_ops && sd->internal_ops->unregistered)
>  		sd->internal_ops->unregistered(sd);
> +	kfree(sd->pad_configs);
> +	sd->pad_configs = NULL;
>  	sd->v4l2_dev = NULL;
> 
>  #if defined(CONFIG_MEDIA_CONTROLLER)
> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c
> b/drivers/media/v4l2-core/v4l2-subdev.c index 3c8b198..a7b874e 100644
> --- a/drivers/media/v4l2-core/v4l2-subdev.c
> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
> @@ -560,6 +560,41 @@ int v4l2_subdev_link_validate(struct media_link *link)
>  EXPORT_SYMBOL_GPL(v4l2_subdev_link_validate);
>  #endif /* CONFIG_MEDIA_CONTROLLER */
> 
> +int v4l2_subdev_create_pad_configs(struct v4l2_subdev *sd)
> +{
> +#if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
> +	struct v4l2_subdev_format fmt = {
> +		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> +	};
> +	unsigned pads = sd->entity.num_pads;
> +	unsigned pad;
> +	int err;
> +
> +	if (pads == 0)
> +		return 0;
> +	sd->pad_configs = kcalloc(pads, sizeof(*sd->pad_configs), GFP_KERNEL);
> +	if (sd->pad_configs == NULL)
> +		return -ENOMEM;
> +	for (pad = 0; pad < pads; pad++) {
> +		fmt.pad = pad;
> +		err = v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt);
> +
> +		if (err && err != -ENOIOCTLCMD) {
> +			kfree(sd->pad_configs);
> +			sd->pad_configs = NULL;
> +			return err;
> +		}
> +		sd->pad_configs[pad].try_fmt = fmt.format;
> +		sd->pad_configs[pad].try_crop.width = fmt.format.width;
> +		sd->pad_configs[pad].try_crop.height = fmt.format.height;
> +		sd->pad_configs[pad].try_compose.width = fmt.format.width;
> +		sd->pad_configs[pad].try_compose.height = fmt.format.height;
> +	}
> +#endif
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_subdev_create_pad_configs);
> +
>  void v4l2_subdev_init(struct v4l2_subdev *sd, const struct v4l2_subdev_ops
> *ops) {
>  	INIT_LIST_HEAD(&sd->list);
> @@ -571,6 +606,7 @@ void v4l2_subdev_init(struct v4l2_subdev *sd, const
> struct v4l2_subdev_ops *ops) sd->grp_id = 0;
>  	sd->dev_priv = NULL;
>  	sd->host_priv = NULL;
> +	sd->pad_configs = NULL;
>  #if defined(CONFIG_MEDIA_CONTROLLER)
>  	sd->entity.name = sd->name;
>  	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV;
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 175dc4f..e9e8b15 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -611,6 +611,8 @@ struct v4l2_subdev {
>  	char name[V4L2_SUBDEV_NAME_SIZE];
>  	/* can be used to group similar subdevs, value is driver-specific */
>  	u32 grp_id;
> +	/* Used by bridge drivers to allocate a pad config array */
> +	struct v4l2_subdev_pad_config *pad_configs;
>  	/* pointer to private data */
>  	void *dev_priv;
>  	void *host_priv;
> @@ -689,6 +691,8 @@ int v4l2_subdev_link_validate_default(struct v4l2_subdev
> *sd, struct v4l2_subdev_format *sink_fmt);
>  int v4l2_subdev_link_validate(struct media_link *link);
>  #endif /* CONFIG_MEDIA_CONTROLLER */
> +
> +int v4l2_subdev_create_pad_configs(struct v4l2_subdev *sd);
>  void v4l2_subdev_init(struct v4l2_subdev *sd,
>  		      const struct v4l2_subdev_ops *ops);

-- 
Regards,

Laurent Pinchart

