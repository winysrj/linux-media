Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46630 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751876AbbCYAkl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2015 20:40:41 -0400
Date: Wed, 25 Mar 2015 02:40:38 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, kyungmin.park@samsung.com,
	pavel@ucw.cz, cooloney@gmail.com, rpurdie@rpsys.net,
	s.nawrocki@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v1 07/11] media: Add registration helpers for V4L2 flash
 sub-devices
Message-ID: <20150325004037.GE18321@valkosipuli.retiisi.org.uk>
References: <1426863811-12516-1-git-send-email-j.anaszewski@samsung.com>
 <1426863811-12516-8-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1426863811-12516-8-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

One more comment on this one:

On Fri, Mar 20, 2015 at 04:03:27PM +0100, Jacek Anaszewski wrote:
...
> +struct v4l2_flash *v4l2_flash_init(struct led_classdev_flash *fled_cdev,
> +				   const struct v4l2_flash_ops *ops,
> +				   struct v4l2_flash_ctrl_config *config)
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
> +	sd->dev = led_cdev->dev;
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
> +		return ERR_PTR(ret);
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
> +	media_entity_cleanup(&sd->entity);
> +
> +	return ERR_PTR(ret);
> +}
> +EXPORT_SYMBOL_GPL(v4l2_flash_init);
> +
> +void v4l2_flash_release(struct v4l2_flash *v4l2_flash)
> +{
> +	struct v4l2_subdev *sd = &v4l2_flash->sd;
> +	struct led_classdev *led_cdev = &v4l2_flash->fled_cdev->led_cdev;
> +
> +	v4l2_async_unregister_subdev(sd);
> +	of_node_put(led_cdev->dev->of_node);
> +	v4l2_ctrl_handler_free(sd->ctrl_handler);
> +	media_entity_cleanup(&sd->entity);
> +}
> +EXPORT_SYMBOL_GPL(v4l2_flash_release);

It'd be very nice if v4l2_flash_release() could graciously behave with NULL
or negative error code as an argument, such as those produced by
v4l2_flash_init(). This makes error handling a lot easier in drivers.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
