Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:57067 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755440Ab2GQVpb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jul 2012 17:45:31 -0400
Message-ID: <5005DCF4.6020401@linux.intel.com>
Date: Wed, 18 Jul 2012 00:45:24 +0300
From: David Cohen <david.a.cohen@linux.intel.com>
MIME-Version: 1.0
To: Sangwook Lee <sangwook.lee@linaro.org>
CC: linux-media@vger.kernel.org, mchehab@infradead.org,
	laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	kyungmin.park@samsung.com, sakari.ailus@maxwell.research.nokia.com,
	suapapa@insignal.co.kr, quartz.jang@samsung.com,
	linaro-dev@lists.linaro.org, patches@linaro.org
Subject: Re: [PATCH 2/2] v4l: Add v4l2 subdev driver for S5K4ECGX sensor
References: <1342541830-22667-1-git-send-email-sangwook.lee@linaro.org> <1342541830-22667-3-git-send-email-sangwook.lee@linaro.org>
In-Reply-To: <1342541830-22667-3-git-send-email-sangwook.lee@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sangwook,

I've few comments, some just nitpicking. Feel free to disagree. :)

On 07/17/2012 07:17 PM, Sangwook Lee wrote:
> This dirver implements preview mode of the S5K4ECGX sensor.
> capture (snapshot) operation, face detection are missing now.
>
> Following controls are supported:
> contrast/saturation/birghtness/sharpness
>
> Signed-off-by: Sangwook Lee <sangwook.lee@linaro.org>
> ---
>   drivers/media/video/Kconfig    |    7 +
>   drivers/media/video/Makefile   |    1 +
>   drivers/media/video/s5k4ecgx.c |  871 ++++++++++++++++++++++++++++++++++++++++
>   include/media/s5k4ecgx.h       |   29 ++
>   4 files changed, 908 insertions(+)
>   create mode 100644 drivers/media/video/s5k4ecgx.c
>   create mode 100644 include/media/s5k4ecgx.h
>

[snip]

> +/*
> + * V4L2 subdev controls
> + */
> +static int s5k4ecgx_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +
> +	struct v4l2_subdev *sd = &container_of(ctrl->handler, struct s5k4ecgx,
> +						handler)->sd;
> +	struct s5k4ecgx *priv = to_s5k4ecgx(sd);
> +	int err = 0;
> +
> +	v4l2_dbg(1, debug, sd, "ctrl: 0x%x, value: %d\n", ctrl->id, ctrl->val);
> +	mutex_lock(&priv->lock);
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_CONTRAST:
> +		err = s5k4ecgx_write_ctrl(sd, REG_USER_CONTRAST, ctrl->val);
> +		break;
> +
> +	case V4L2_CID_SATURATION:
> +		err = s5k4ecgx_write_ctrl(sd, REG_USER_SATURATION, ctrl->val);
> +		break;
> +
> +	case V4L2_CID_SHARPNESS:
> +		err |= s5k4ecgx_write_ctrl(sd, REG_USER_SHARP1, ctrl->val);
> +		err |= s5k4ecgx_write_ctrl(sd, REG_USER_SHARP2, ctrl->val);
> +		err |= s5k4ecgx_write_ctrl(sd, REG_USER_SHARP3, ctrl->val);
> +		err |= s5k4ecgx_write_ctrl(sd, REG_USER_SHARP4, ctrl->val);
> +		err |= s5k4ecgx_write_ctrl(sd, REG_USER_SHARP5, ctrl->val);
> +		break;
> +
> +	case V4L2_CID_BRIGHTNESS:
> +		err = s5k4ecgx_write_ctrl(sd, REG_USER_BRIGHTNESS, ctrl->val);
> +		break;
> +	default:
> +		v4l2_dbg(1, debug, sd, "unknown set ctrl id 0x%x\n", ctrl->id);
> +		err = -ENOIOCTLCMD;
> +		break;
> +	}
> +
> +	/* Review this */
> +	priv->reg_type = TOK_TERM;
> +
> +	if (err < 0)
> +		v4l2_err(sd, "Failed to write videoc_s_ctrl err %d\n", err);

I like to hold locks only when strictly necessary. You could write
this error message after it's released.

> +	mutex_unlock(&priv->lock);
> +
> +	return err;
> +}
> +
> +static const struct v4l2_ctrl_ops s5k4ecgx_ctrl_ops = {
> +	.s_ctrl = s5k4ecgx_s_ctrl,
> +};
> +
> +/*
> + * Reading s5k4ecgx version information
> + */
> +static int s5k4ecgx_registered(struct v4l2_subdev *sd)
> +{
> +	struct s5k4ecgx *priv = to_s5k4ecgx(sd);
> +	int ret;
> +
> +	if (!priv->set_power) {
> +		v4l2_err(sd, "Failed to call power-up function!\n");

Maybe it's more accurate to say function isn't set.

> +		return -EIO;
> +	}
> +
> +	mutex_lock(&priv->lock);
> +	priv->set_power(true);
> +	/* Time to stablize sensor */
> +	mdelay(priv->mdelay);
> +	ret = s5k4ecgx_read_fw_ver(sd);
> +	priv->set_power(false);
> +	mutex_unlock(&priv->lock);
> +
> +	return ret;
> +}
> +
> +/*
> + *  V4L2 subdev internal operations
> + */
> +static int s5k4ecgx_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
> +{
> +
> +	struct v4l2_mbus_framefmt *format = v4l2_subdev_get_try_format(fh, 0);
> +	struct v4l2_rect *crop = v4l2_subdev_get_try_crop(fh, 0);
> +
> +	format->colorspace = s5k4ecgx_formats[0].colorspace;
> +	format->code = s5k4ecgx_formats[0].code;
> +	format->width = S5K4ECGX_OUT_WIDTH_DEF;
> +	format->height = S5K4ECGX_OUT_HEIGHT_DEF;
> +	format->field = V4L2_FIELD_NONE;
> +
> +	crop->width = S5K4ECGX_WIN_WIDTH_MAX;
> +	crop->height = S5K4ECGX_WIN_HEIGHT_MAX;
> +	crop->left = 0;
> +	crop->top = 0;
> +
> +	return 0;
> +}
> +
> +
> +static const struct v4l2_subdev_internal_ops s5k4ecgx_subdev_internal_ops = {
> +	.registered = s5k4ecgx_registered,
> +	.open = s5k4ecgx_open,
> +};
> +
> +static int s5k4ecgx_s_power(struct v4l2_subdev *sd, int val)
> +{
> +	struct s5k4ecgx *priv = to_s5k4ecgx(sd);
> +
> +	if (!priv->set_power)
> +		return -EIO;
> +
> +	v4l2_dbg(1, debug, sd, "Switching %s\n", val ? "on" : "off");
> +
> +	if (val) {
> +		priv->set_power(val);
> +		/* Time to stablize sensor */
> +		mdelay(priv->mdelay);
> +		/* Loading firmware into ARM7 core of sensor */
> +		if (s5k4ecgx_write_array(sd, s5k4ecgx_init_regs) < 0)
> +			return -EIO;

Shouldn't you s_power(0) in case of error?

> +		s5k4ecgx_init_parameters(sd);
> +	} else {
> +		priv->set_power(val);
> +	}
> +
> +	return 0;
> +}
> +
> +static int s5k4ecgx_log_status(struct v4l2_subdev *sd)
> +{
> +	v4l2_ctrl_handler_log_status(sd->ctrl_handler, sd->name);
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_subdev_core_ops s5k4ecgx_core_ops = {
> +	.s_power = s5k4ecgx_s_power,
> +	.log_status	= s5k4ecgx_log_status,
> +};
> +
> +static int __s5k4ecgx_s_stream(struct v4l2_subdev *sd, int on)
> +{
> +	struct s5k4ecgx *priv = to_s5k4ecgx(sd);
> +	int err = 0;
> +
> +	if (on)
> +		err = s5k4ecgx_write_array(sd, pview_size[priv->p_now->idx]);
> +
> +	return err;
> +}
> +
> +static int s5k4ecgx_s_stream(struct v4l2_subdev *sd, int on)
> +{
> +	struct s5k4ecgx *priv = to_s5k4ecgx(sd);
> +	int ret = 0;
> +
> +	v4l2_dbg(1, debug, sd, "Turn streaming %s\n", on ? "on" : "off");
> +	mutex_lock(&priv->lock);
> +	if (on && !priv->streaming)
> +		ret = __s5k4ecgx_s_stream(sd, on);
> +	else
> +		priv->streaming = 0;

Is s_stream(1) is called twice, either you ignore it or return error.
But turning it to s_stream(0) isn't correct to me.

> +	mutex_unlock(&priv->lock);
> +
> +	return ret;
> +}
> +
> +static const struct v4l2_subdev_video_ops s5k4ecgx_video_ops = {
> +	.s_stream = s5k4ecgx_s_stream,
> +};
> +
> +static const struct v4l2_subdev_ops s5k4ecgx_ops = {
> +	.core = &s5k4ecgx_core_ops,
> +	.pad = &s5k4ecgx_pad_ops,
> +	.video = &s5k4ecgx_video_ops,
> +};
> +
> +static int s5k4ecgx_initialize_ctrls(struct s5k4ecgx *priv)
> +{
> +	const struct v4l2_ctrl_ops *ops = &s5k4ecgx_ctrl_ops;
> +	struct v4l2_ctrl_handler *hdl = &priv->handler;
> +	int ret;
> +
> +	ret =  v4l2_ctrl_handler_init(hdl, 16);
> +	if (ret)
> +		return ret;
> +
> +	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_BRIGHTNESS, -208, 127, 1, 0);
> +	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_CONTRAST, -127, 127, 1, 0);
> +	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_SATURATION, -127, 127, 1, 0);
> +
> +	/* For sharpness, 0x6024 is default value */
> +	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_SHARPNESS, -32704, 24612, 8208,
> +			  24612);
> +	if (hdl->error) {
> +		ret = hdl->error;
> +		v4l2_ctrl_handler_free(hdl);
> +		return ret;
> +	}
> +	priv->sd.ctrl_handler = hdl;
> +
> +	return 0;
> +};
> +
> +/*
> + * Set initial values for all preview presets
> + */
> +static void s5k4ecgx_presets_data_init(struct s5k4ecgx *priv)
> +{
> +	struct s5k4ecgx_preset *preset = &priv->presets[0];
> +	int i;
> +
> +	for (i = 0; i < S5K4ECGX_MAX_PRESETS; i++) {
> +		preset->mbus_fmt.width	= S5K4ECGX_OUT_WIDTH_DEF;
> +		preset->mbus_fmt.height	= S5K4ECGX_OUT_HEIGHT_DEF;
> +		preset->mbus_fmt.code	= s5k4ecgx_formats[0].code;
> +		preset->index		= i;
> +		preset->clk_id		= 0;
> +		preset++;
> +	}
> +	priv->preset = &priv->presets[0];
> +}
> +
> +/*
> +  * Fetching platform data is being done with s_config subdev call.
> +  * In probe routine, we just register subdev device
> +  */
> +static int s5k4ecgx_probe(struct i2c_client *client,
> +			  const struct i2c_device_id *id)
> +{
> +	struct v4l2_subdev *sd;
> +	struct s5k4ecgx *priv;
> +	struct s5k4ecgx_platform_data *pdata = client->dev.platform_data;
> +	int	ret;
> +
> +	if (pdata == NULL) {
> +		dev_err(&client->dev, "platform data is missing!\n");
> +		return -EINVAL;
> +	}
> +	priv = kzalloc(sizeof(struct s5k4ecgx), GFP_KERNEL);
> +
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	mutex_init(&priv->lock);
> +
> +	priv->set_power = pdata->set_power;
> +	priv->mdelay = pdata->mdelay;
> +
> +	sd = &priv->sd;
> +	/* Registering subdev */
> +	v4l2_i2c_subdev_init(sd, client, &s5k4ecgx_ops);
> +	strlcpy(sd->name, S5K4ECGX_DRIVER_NAME, sizeof(sd->name));
> +
> +	sd->internal_ops = &s5k4ecgx_subdev_internal_ops;
> +	/* Support v4l2 sub-device userspace API */
> +	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +
> +	priv->pad.flags = MEDIA_PAD_FL_SOURCE;
> +	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
> +	ret = media_entity_init(&sd->entity, 1, &priv->pad, 0);
> +	if (ret)
> +		goto out_err;
> +
> +	ret = s5k4ecgx_initialize_ctrls(priv);
> +	s5k4ecgx_presets_data_init(priv);
> +
> +	if (ret)
> +		goto out_err;
> +	else

This "else" could be removed.

> +		return 0;
> +
> + out_err:
> +	media_entity_cleanup(&priv->sd.entity);
> +	kfree(priv);
> +
> +	return ret;
> +}
> +
> +static int s5k4ecgx_remove(struct i2c_client *client)
> +{
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +	struct s5k4ecgx *priv = to_s5k4ecgx(sd);
> +
> +	v4l2_device_unregister_subdev(sd);
> +	v4l2_ctrl_handler_free(&priv->handler);
> +	media_entity_cleanup(&sd->entity);
> +	mutex_destroy(&priv->lock);

For debugging purpose, maybe mutex_destroy() could be first one.

Kind regards.

David Cohen

> +	kfree(priv);
> +
> +	return 0;
> +}
> +
> +static const struct i2c_device_id s5k4ecgx_id[] = {
> +	{ S5K4ECGX_DRIVER_NAME, 0 },
> +	{}
> +};
> +MODULE_DEVICE_TABLE(i2c, s5k4ecgx_id);
> +
> +static struct i2c_driver v4l2_i2c_driver = {
> +	.driver = {
> +		.owner	= THIS_MODULE,
> +		.name = S5K4ECGX_DRIVER_NAME,
> +	},
> +	.probe = s5k4ecgx_probe,
> +	.remove = s5k4ecgx_remove,
> +	.id_table = s5k4ecgx_id,
> +};
> +
> +module_i2c_driver(v4l2_i2c_driver);
> +
> +MODULE_DESCRIPTION("Samsung S5K4ECGX 5MP SOC camera");
> +MODULE_AUTHOR("Sangwook Lee <sangwook.lee@linaro.org>");
> +MODULE_AUTHOR("Seok-Young Jang <quartz.jang@samsung.com>");
> +MODULE_LICENSE("GPL");
> diff --git a/include/media/s5k4ecgx.h b/include/media/s5k4ecgx.h
> new file mode 100644
> index 0000000..e041761
> --- /dev/null
> +++ b/include/media/s5k4ecgx.h
> @@ -0,0 +1,29 @@
> +/*
> + * S5K4ECGX Platform data header
> + *
> + * Copyright (C) 2012, Linaro
> + *
> + * Copyright (C) 2010, SAMSUNG ELECTRONICS
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#ifndef S5K4ECGX_H
> +#define S5K4ECGX_H
> +
> +/**
> + * struct ss5k4ecgx_platform_data- s5k4ecgx driver platform data
> + * @set_power: an callback to give the chance to turn off/on
> + *		 camera which is depending on the board code
> + * @mdelay   : delay (ms) needed after enabling power
> + */
> +
> +struct s5k4ecgx_platform_data {
> +	int (*set_power)(int);
> +	int mdelay;
> +};
> +
> +#endif /* S5K4ECGX_H */
>


