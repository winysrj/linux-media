Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58152 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab2HBVSz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Aug 2012 17:18:55 -0400
Received: by bkwj10 with SMTP id j10so4442030bkw.19
        for <linux-media@vger.kernel.org>; Thu, 02 Aug 2012 14:18:54 -0700 (PDT)
Message-ID: <501AEEBC.30803@gmail.com>
Date: Thu, 02 Aug 2012 23:18:52 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sangwook Lee <sangwook.lee@linaro.org>
CC: LMML <linux-media@vger.kernel.org>, quartz.jang@samsung.com,
	linaro-dev@lists.linaro.org, patches@linaro.org,
	suapapa@insignal.co.kr,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	sakari.ailus@maxwell.research.nokia.com
Subject: Re: [PATH v3 2/2] v4l: Add v4l2 subdev driver for S5K4ECGX sensor
References: <1343914971-23007-1-git-send-email-sangwook.lee@linaro.org> <1343914971-23007-3-git-send-email-sangwook.lee@linaro.org>
In-Reply-To: <1343914971-23007-3-git-send-email-sangwook.lee@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/02/2012 03:42 PM, Sangwook Lee wrote:
> This driver implements preview mode of the S5K4ECGX sensor.
> capture (snapshot) operation, face detection are missing now.
> 
> Following controls are supported:
> contrast/saturation/brightness/sharpness
> 
> Signed-off-by: Sangwook Lee<sangwook.lee-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
...
> +static const char * const s5k4ecgx_supply_names[] = {
> +	/*
> +	 * vdd_2.8v is for Analog power supply 2.8V(vdda)
> +	 * and Digital IO(vddio, vddd_core)
> +	 */
> +	"vdd_2.8v",

Might be better to avoid voltage value in regulator supply names. Can you
just make it on of: vdda, vddio, vddcore ? On some systems all 3 power pads
might be used and all 3 voltage supply names might be needed. I guess it can
be changed if there is a need for it. Also we could specify all 3 entries as
above and add such regulator supply names at a corresponding regulator.

> +	/* vdd_1.8v is for regulator input */
> +	"vdd_1.8v",

I would suggest just using "vddreg".

> +static int s5k4ecgx_write(struct i2c_client *client, u32 addr, u16 val)
> +{
> +	int ret = 0;

Unneeded initialization.

> +	u16 high = addr>>  16, low =  addr&  0xffff;
> +
> +	ret = s5k4ecgx_i2c_write(client, REG_CMDWR_ADDRH, high);
> +	ret |= s5k4ecgx_i2c_write(client, REG_CMDWR_ADDRL, low);
> +	ret |= s5k4ecgx_i2c_write(client, REG_CMDBUF0_ADDR, val);
> +	if (ret)
> +		return -ENODEV;
> +
> +	return 0;
> +}
> +
> +static int s5k4ecgx_read(struct i2c_client *client, u32 addr, u16 *val)
> +{
> +	int ret = 0;

Ditto.

> +	u16 high = addr>>  16, low =  addr&  0xffff;
> +
> +	ret  = s5k4ecgx_i2c_write(client, REG_CMDRD_ADDRH, high);
> +	ret  |= s5k4ecgx_i2c_write(client, REG_CMDRD_ADDRL, low);
> +	ret  |= s5k4ecgx_i2c_read(client, REG_CMDBUF0_ADDR, val);
> +	if (ret) {
> +		dev_err(&client->dev, "Failed to execute read command\n");
> +		return -ENODEV;
> +	}
> +
> +	return 0;
> +}
> +
> +static int s5k4ecgx_set_ahb_address(struct v4l2_subdev *sd)
> +{
> +	int ret;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +
> +	/* Set APB peripherals start address */
> +	ret = s5k4ecgx_i2c_write(client, AHB_MSB_ADDR_PTR, GEN_REG_OFFSH);
> +	if (ret)
> +		return ret;
> +	/*
> +	 * FIMXE: This is copied from s5k6aa, because of no information
> +	 * in s5k4ecgx's datasheet.
> +	 * sw_reset is activated to put device into idle status
> +	 */
> +	ret = s5k4ecgx_i2c_write(client, 0x0010, 0x0001);
> +	if (ret)
> +		return ret;
> +
> +	/* FIXME: no information avaialbe about this register */

avaialbe -> available

> +	ret = s5k4ecgx_i2c_write(client, 0x1030, 0x0000);
> +	if (ret)
> +		return ret;
> +	/* Halt ARM CPU */
> +	ret = s5k4ecgx_i2c_write(client, 0x0014, 0x0001);
> +
> +	return ret;

	return s5k4ecgx_i2c_write(...); ?
> +}
> +
> +static int s5k4ecgx_write_array(struct v4l2_subdev *sd,
> +				const struct regval_list *reg)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	u16 addr_incr = 0;
> +	int ret = 0;

Unneeded initialization.

> +
> +	while (reg->addr != TOK_TERM) {
> +		if (addr_incr != 2)
> +			ret = s5k4ecgx_write(client, reg->addr, reg->val);
> +		else
> +			ret = s5k4ecgx_i2c_write(client, REG_CMDBUF0_ADDR,
> +						reg->val);
> +		if (ret)
> +			break;
> +		/* Assume that msg->addr is always less than 0xfffc */
> +		addr_incr = (reg + 1)->addr - reg->addr;
> +		reg++;
> +	}
> +
> +	return ret;
> +}
...
> +
> +static int s5k4ecgx_init_sensor(struct v4l2_subdev *sd)
> +{
> +	int ret = 0;

Ditto.

> +
> +	ret = s5k4ecgx_set_ahb_address(sd);
> +	/* The delay is from manufacturer's settings */
> +	msleep(100);
> +
> +	ret |= s5k4ecgx_write_array(sd, s5k4ecgx_apb_regs);
> +	ret |= s5k4ecgx_write_array(sd, s5k4ecgx_img_regs);
> +
> +	if (ret)
> +		v4l2_err(sd, "Failed to write initial settings\n");
> +
> +	return 0;
> +}
> +
...
> +static int s5k4ecgx_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +
> +	struct v4l2_subdev *sd =&container_of(ctrl->handler, struct s5k4ecgx,
> +						handler)->sd;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	struct s5k4ecgx *priv = to_s5k4ecgx(sd);
> +	int err = 0;

Unneded initilization.

> +
> +	v4l2_dbg(1, debug, sd, "ctrl: 0x%x, value: %d\n", ctrl->id, ctrl->val);
> +
> +	mutex_lock(&priv->lock);
> +	switch (ctrl->id) {
> +	case V4L2_CID_CONTRAST:
> +		err = s5k4ecgx_write(client, REG_USER_CONTRAST, ctrl->val);
> +		break;
> +
> +	case V4L2_CID_SATURATION:
> +		err = s5k4ecgx_write(client, REG_USER_SATURATION, ctrl->val);
> +		break;
> +
> +	case V4L2_CID_SHARPNESS:
> +		ctrl->val *= SHARPNESS_DIV;
> +		err |= s5k4ecgx_write(client, REG_USER_SHARP1, ctrl->val);
> +		err |= s5k4ecgx_write(client, REG_USER_SHARP2, ctrl->val);
> +		err |= s5k4ecgx_write(client, REG_USER_SHARP3, ctrl->val);
> +		err |= s5k4ecgx_write(client, REG_USER_SHARP4, ctrl->val);
> +		err |= s5k4ecgx_write(client, REG_USER_SHARP5, ctrl->val);
> +		break;
> +
> +	case V4L2_CID_BRIGHTNESS:
> +		err = s5k4ecgx_write(client, REG_USER_BRIGHTNESS, ctrl->val);
> +		break;
> +	}
> +	mutex_unlock(&priv->lock);
> +	if (err<  0)
> +		v4l2_err(sd, "Failed to write s_ctrl err %d\n", err);
> +
> +	return err;
> +}
...
> +static const struct v4l2_subdev_core_ops s5k4ecgx_core_ops = {
> +	.s_power = s5k4ecgx_s_power,
> +	.log_status	= s5k4ecgx_log_status,

nit: inconsistent indentation.

> +};
> +
> +static int __s5k4ecgx_s_stream(struct v4l2_subdev *sd, int on)
> +{
> +	struct s5k4ecgx *priv = to_s5k4ecgx(sd);
> +	int err = 0;
> +
> +	if (on)
> +		err = s5k4ecgx_write_array(sd, prev_regs[priv->curr_win->idx]);
> +
> +	return err;

	if (on)
		return s5k4ecgx_write_array(sd, prev_regs[priv->curr_win->idx]);

	return 0;

> +}
> +
...
> +/*
> + * Fetching platform data is being done with s_config subdev call.

This comment is false, care to remove it ?

> + * In probe routine, we just register subdev device
> + */
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
> +	priv = kzalloc(sizeof(struct s5k4ecgx), GFP_KERNEL);

devm_kzalloc ?

> +	if (!priv)
> +		return -ENOMEM;
> +
> +	mutex_init(&priv->lock);
> +	priv->msleep = pdata->msleep;
> +	priv->streaming = 0;
> +
> +	sd =&priv->sd;
> +	/* Registering subdev */
> +	v4l2_i2c_subdev_init(sd, client,&s5k4ecgx_ops);
> +	strlcpy(sd->name, S5K4ECGX_DRIVER_NAME, sizeof(sd->name));
> +
> +	sd->internal_ops =&s5k4ecgx_subdev_internal_ops;
> +	/* Support v4l2 sub-device userspace API */
> +	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +
> +	priv->pad.flags = MEDIA_PAD_FL_SOURCE;
> +	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
> +	ret = media_entity_init(&sd->entity, 1,&priv->pad, 0);
> +	if (ret)
> +		goto out_err1;
> +
> +	ret = s5k4ecgx_config_gpios(priv, pdata);
> +	if (ret) {
> +		dev_err(&client->dev, "Failed to set gpios\n");
> +		goto out_err2;
> +	}
> +	for (i = 0; i<  S5K4ECGX_NUM_SUPPLIES; i++)
> +		priv->supplies[i].supply = s5k4ecgx_supply_names[i];
> +
> +	ret = regulator_bulk_get(&client->dev, S5K4ECGX_NUM_SUPPLIES,
> +				 priv->supplies);

How about using devm_regulator_bulk_get() ?

> +	if (ret) {
> +		dev_err(&client->dev, "Failed to get regulators\n");
> +		goto out_err3;
> +	}
> +
> +	ret = s5k4ecgx_init_v4l2_ctrls(priv);
> +
> +	if (ret)
> +		goto out_err4;
> +
> +	return 0;
> +
> +out_err4:
> +	regulator_bulk_free(S5K4ECGX_NUM_SUPPLIES, priv->supplies);
> +out_err3:
> +	s5k4ecgx_free_gpios(priv);
> +out_err2:
> +	media_entity_cleanup(&priv->sd.entity);
> +out_err1:
> +	kfree(priv);
> +
> +	return ret;
> +}
> +
...
> +/**
> + * struct ss5k4ecgx_platform_data- s5k4ecgx driver platform data
> + * @gpio_reset:	 GPIO driving RESET pin
> + * @gpio_stby :	 GPIO driving STBY pin
> + * @msleep    :	 delay (ms) needed after enabling power

Can't it be some default value hardcoded at the driver ?

> + */
> +
> +struct s5k4ecgx_platform_data {
> +	struct s5k4ecgx_gpio gpio_reset;
> +	struct s5k4ecgx_gpio gpio_stby;
> +	int msleep;
> +};
> +
> +#endif /* S5K4ECGX_H */

--

Regards,
Sylwester
