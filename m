Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35884 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753613AbbETOov (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2015 10:44:51 -0400
Date: Wed, 20 May 2015 17:44:47 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, s.nawrocki@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v8 1/8] media: Add registration helpers for V4L2 flash
 sub-devices
Message-ID: <20150520144447.GB8601@valkosipuli.retiisi.org.uk>
References: <1432131015-22397-1-git-send-email-j.anaszewski@samsung.com>
 <1432131015-22397-2-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1432131015-22397-2-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

On Wed, May 20, 2015 at 04:10:08PM +0200, Jacek Anaszewski wrote:
...
> +struct v4l2_flash *v4l2_flash_init(
> +	struct device *dev, struct device_node *of_node,
> +	struct led_classdev_flash *fled_cdev, const struct v4l2_flash_ops *ops,
> +	struct v4l2_flash_config *config)
> +{
> +	struct v4l2_flash *v4l2_flash;
> +	struct led_classdev *led_cdev = &fled_cdev->led_cdev;
> +	struct v4l2_subdev *sd;
> +	int ret;
> +
> +	if (!fled_cdev || !ops || !config)
> +		return ERR_PTR(-EINVAL);
> +
> +	v4l2_flash = devm_kzalloc(led_cdev->dev, sizeof(*v4l2_flash),
> +					GFP_KERNEL);
> +	if (!v4l2_flash)
> +		return ERR_PTR(-ENOMEM);
> +
> +	sd = &v4l2_flash->sd;
> +	v4l2_flash->fled_cdev = fled_cdev;
> +	v4l2_flash->ops = ops;
> +	sd->dev = dev;
> +	sd->of_node = of_node;
> +	v4l2_subdev_init(sd, &v4l2_flash_subdev_ops);
> +	sd->internal_ops = &v4l2_flash_subdev_internal_ops;
> +	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +	strlcpy(sd->name, config->dev_name, sizeof(sd->name));
> +
> +	ret = media_entity_init(&sd->entity, 0, NULL, 0);
> +	if (ret < 0)
> +		return ERR_PTR(ret);
> +
> +	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_FLASH;
> +
> +	ret = v4l2_flash_init_controls(v4l2_flash, config);
> +	if (ret < 0)
> +		goto err_init_controls;
> +
> +	of_node_get(led_cdev->dev->of_node);
> +
> +	ret = v4l2_async_register_subdev(sd);
> +	if (ret < 0)
> +		goto err_async_register_sd;
> +
> +	return v4l2_flash;
> +
> +err_async_register_sd:
> +	of_node_put(led_cdev->dev->of_node);
> +	v4l2_ctrl_handler_free(sd->ctrl_handler);
> +err_init_controls:
> +	media_entity_cleanup(&sd->entity);
> +
> +	return ERR_PTR(ret);
> +}
> +EXPORT_SYMBOL_GPL(v4l2_flash_init);
> +
> +void v4l2_flash_release(struct v4l2_flash *v4l2_flash)
> +{
> +	struct v4l2_subdev *sd;
> +	struct led_classdev *led_cdev;
> +
> +	if (IS_ERR(v4l2_flash))

I propose to use IS_ERR_OR_NULL() instead. Then this can be safely called
without calling v4l2_flash_init() first, making error handling easier.

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

> +		return;
> +
> +	sd = &v4l2_flash->sd;
> +	led_cdev = &v4l2_flash->fled_cdev->led_cdev;
> +
> +	v4l2_async_unregister_subdev(sd);
> +	of_node_put(led_cdev->dev->of_node);
> +	v4l2_ctrl_handler_free(sd->ctrl_handler);
> +	media_entity_cleanup(&sd->entity);
> +}
> +EXPORT_SYMBOL_GPL(v4l2_flash_release);

...

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
