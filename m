Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43035 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab2IIQAW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Sep 2012 12:00:22 -0400
Received: by eaac11 with SMTP id c11so510192eaa.19
        for <linux-media@vger.kernel.org>; Sun, 09 Sep 2012 09:00:20 -0700 (PDT)
Message-ID: <504CBD47.5050802@gmail.com>
Date: Sun, 09 Sep 2012 18:01:11 +0200
From: Francesco Lavra <francescolavra.fl@gmail.com>
MIME-Version: 1.0
To: Sangwook Lee <sangwook.lee@linaro.org>
CC: linux-media@vger.kernel.org, linaro-dev@lists.linaro.org,
	patches@linaro.org, mchehab@infradead.org,
	kyungmin.park@samsung.com, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com
Subject: Re: [RFC PATCH v6] media: add v4l2 subdev driver for S5K4ECGX sensor
References: <1346944114-17527-1-git-send-email-sangwook.lee@linaro.org>
In-Reply-To: <1346944114-17527-1-git-send-email-sangwook.lee@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
I'm going to report the (few) things which are also present in
Sylwester's tree.

On 09/06/2012 05:08 PM, Sangwook Lee wrote:
> This patch adds driver for S5K4ECGX sensor with embedded ISP SoC,
> S5K4ECGX, which is a 5M CMOS Image sensor from Samsung
> The driver implements preview mode of the S5K4ECGX sensor.
> capture (snapshot) operation, face detection are missing now.
> Following controls are supported:
> contrast/saturation/brightness/sharpness
> 
> Signed-off-by: Sangwook Lee <sangwook.lee@linaro.org>
> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

[snip]

> +static const char * const s5k4ecgx_supply_names[] = {
> +	/*
> +	 * Usually 2.8V is used for analog power (vdda)
> +	 * and digital IO (vddio, vddd_core)

s/vddd_core/vddcore

[snip]

> +static int s5k4ecgx_load_firmware(struct v4l2_subdev *sd)
> +{
> +	const struct firmware *fw;
> +	int err, i, regs_num;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	u16 val;
> +	u32 addr, crc, crc_file, addr_inc = 0;
> +
> +	err = request_firmware(&fw, S5K4ECGX_FIRMWARE, sd->v4l2_dev->dev);
> +	if (err) {
> +		v4l2_err(sd, "Failed to read firmware %s\n", S5K4ECGX_FIRMWARE);
> +		return err;
> +	}
> +	regs_num = *(u32 *)(fw->data);
> +	v4l2_dbg(3, debug, sd, "FW: %s size %d register sets %d\n",
> +		 S5K4ECGX_FIRMWARE, fw->size, regs_num);
> +	regs_num++; /* Add header */
> +	if (fw->size != regs_num * FW_RECORD_SIZE + FW_CRC_SIZE) {
> +		err = -EINVAL;
> +		goto fw_out;
> +	}
> +	crc_file = *(u32 *)(fw->data + regs_num * FW_RECORD_SIZE);

Depending on the value of regs_num, this may result in unaligned access

[snip]

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

[snip]

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

Maybe s5k4ecgx_free_gpios() should be called?

Regards,
Francesco
