Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54184 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761047Ab2ILSGz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Sep 2012 14:06:55 -0400
Received: by bkwj10 with SMTP id j10so63547bkw.19
        for <linux-media@vger.kernel.org>; Wed, 12 Sep 2012 11:06:54 -0700 (PDT)
Message-ID: <5050CF7B.9040204@gmail.com>
Date: Wed, 12 Sep 2012 20:07:55 +0200
From: Francesco Lavra <francescolavra.fl@gmail.com>
MIME-Version: 1.0
To: Sangwook Lee <sangwook.lee@linaro.org>
CC: linux-media@vger.kernel.org, mchehab@infradead.org,
	laurent.pinchart@ideasonboard.com, kyungmin.park@samsung.com,
	hans.verkuil@cisco.com, linaro-dev@lists.linaro.org,
	patches@linaro.org, Scott Bambrough <scott.bambrough@linaro.org>,
	Homin Lee <suapapa@insignal.co.kr>
Subject: Re: [RFC PATCH v7] media: add v4l2 subdev driver for S5K4ECGX sensor
References: <1347449164-6306-1-git-send-email-sangwook.lee@linaro.org>
In-Reply-To: <1347449164-6306-1-git-send-email-sangwook.lee@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sangwook,
two remarks from my review on September 9th haven't been addressed.
I believe those remarks are correct, but please let me know if I'm
missing something.
See below.

On 09/12/2012 01:26 PM, Sangwook Lee wrote:
> +static int s5k4ecgx_s_power(struct v4l2_subdev *sd, int on)
> +{
> +	struct s5k4ecgx *priv = to_s5k4ecgx(sd);
> +	int ret;
> +
> +	v4l2_dbg(1, debug, sd, "Switching %s\n", on ? "on" : "off");
> +
> +	if (on) {
> +		ret = __s5k4ecgx_power_on(priv);
> +		if (ret < 0)
> +			return ret;
> +		/* Time to stabilize sensor */
> +		msleep(100);
> +		ret = s5k4ecgx_init_sensor(sd);
> +		if (ret < 0)
> +			__s5k4ecgx_power_off(priv);
> +		else
> +			priv->set_params = 1;
> +	} else {
> +		ret = __s5k4ecgx_power_off(priv);
> +	}
> +
> +	return 0;

return ret;

> +static int s5k4ecgx_probe(struct i2c_client *client,
> +			  const struct i2c_device_id *id)
> +{
> +	int	ret, i;
> +	struct v4l2_subdev *sd;
> +	struct s5k4ecgx *priv;
> +	struct s5k4ecgx_platform_data *pdata = client->dev.platform_data;
> +
> +	if (pdata == NULL) {
> +		dev_err(&client->dev, "platform data is missing!\n");
> +		return -EINVAL;
> +	}
> +	priv = devm_kzalloc(&client->dev, sizeof(struct s5k4ecgx), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	mutex_init(&priv->lock);
> +	priv->streaming = 0;
> +
> +	sd = &priv->sd;
> +	/* Registering subdev */
> +	v4l2_i2c_subdev_init(sd, client, &s5k4ecgx_ops);
> +	strlcpy(sd->name, S5K4ECGX_DRIVER_NAME, sizeof(sd->name));
> +
> +	sd->internal_ops = &s5k4ecgx_subdev_internal_ops;
> +	/* Support v4l2 sub-device user space API */
> +	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +
> +	priv->pad.flags = MEDIA_PAD_FL_SOURCE;
> +	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
> +	ret = media_entity_init(&sd->entity, 1, &priv->pad, 0);
> +	if (ret)
> +		return ret;
> +
> +	ret = s5k4ecgx_config_gpios(priv, pdata);
> +	if (ret) {
> +		dev_err(&client->dev, "Failed to set gpios\n");
> +		goto out_err1;
> +	}
> +	for (i = 0; i < S5K4ECGX_NUM_SUPPLIES; i++)
> +		priv->supplies[i].supply = s5k4ecgx_supply_names[i];
> +
> +	ret = devm_regulator_bulk_get(&client->dev, S5K4ECGX_NUM_SUPPLIES,
> +				 priv->supplies);
> +	if (ret) {
> +		dev_err(&client->dev, "Failed to get regulators\n");
> +		goto out_err2;
> +	}
> +	ret = s5k4ecgx_init_v4l2_ctrls(priv);
> +	if (ret)
> +		goto out_err2;
> +
> +	priv->curr_pixfmt = &s5k4ecgx_formats[0];
> +	priv->curr_frmsize = &s5k4ecgx_prev_sizes[0];
> +
> +	return 0;
> +
> +out_err2:
> +	s5k4ecgx_free_gpios(priv);
> +out_err1:
> +	media_entity_cleanup(&priv->sd.entity);
> +
> +	return ret;
> +}
> +
> +static int s5k4ecgx_remove(struct i2c_client *client)
> +{
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +	struct s5k4ecgx *priv = to_s5k4ecgx(sd);
> +
> +	mutex_destroy(&priv->lock);
> +	v4l2_device_unregister_subdev(sd);
> +	v4l2_ctrl_handler_free(&priv->handler);
> +	media_entity_cleanup(&sd->entity);
> +
> +	return 0;

s5k4ecgx_free_gpios() should be called to release the GPIOs

Thanks,
Francesco
