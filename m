Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:11135 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933410AbdEZB6n (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 May 2017 21:58:43 -0400
From: "Mani, Rajmohan" <rajmohan.mani@intel.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "mchehab@kernel.org" <mchehab@kernel.org>,
        "hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "sakari.ailus@iki.fi" <sakari.ailus@iki.fi>,
        "s.nawrocki@samsung.com" <s.nawrocki@samsung.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>
Subject: RE: [PATCH] dw9714: Initial driver for dw9714 VCM
Date: Fri, 26 May 2017 01:58:40 +0000
Message-ID: <6F87890CF0F5204F892DEA1EF0D77A595AA0A4B5@FMSMSX114.amr.corp.intel.com>
References: <1495763377-12254-1-git-send-email-rajmohan.mani@intel.com>
In-Reply-To: <1495763377-12254-1-git-send-email-rajmohan.mani@intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,
Please follow v5 of this patch for the latest and ignore this patch.
Sorry for the noise.

Raj

> -----Original Message-----
> From: Mani, Rajmohan
> Sent: Thursday, May 25, 2017 6:50 PM
> To: linux-media@vger.kernel.org
> Cc: mchehab@kernel.org; hverkuil@xs4all.nl; tfiga@chromium.org;
> sakari.ailus@iki.fi; s.nawrocki@samsung.com; Toivonen, Tuukka
> <tuukka.toivonen@intel.com>; Mani, Rajmohan <rajmohan.mani@intel.com>
> Subject: [PATCH] dw9714: Initial driver for dw9714 VCM
> 
> DW9714 is a 10 bit DAC, designed for linear control of voice coil motor.
> 
> This driver creates a V4L2 subdevice and provides control to set the desired
> focus.
> 
> Signed-off-by: Rajmohan Mani <rajmohan.mani@intel.com>
> ---
>  drivers/media/i2c/Kconfig  |   9 ++
>  drivers/media/i2c/Makefile |   1 +
>  drivers/media/i2c/dw9714.c | 292
> +++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 302 insertions(+)
>  create mode 100644 drivers/media/i2c/dw9714.c
> 
> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig index
> fd181c9..516e2f2 100644
> --- a/drivers/media/i2c/Kconfig
> +++ b/drivers/media/i2c/Kconfig
> @@ -300,6 +300,15 @@ config VIDEO_AD5820
>  	  This is a driver for the AD5820 camera lens voice coil.
>  	  It is used for example in Nokia N900 (RX-51).
> 
> +config VIDEO_DW9714
> +	tristate "DW9714 lens voice coil support"
> +	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER &&
> VIDEO_V4L2_SUBDEV_API
> +	---help---
> +	  This is a driver for the DW9714 camera lens voice coil.
> +	  DW9714 is a 10 bit DAC with 120mA output current sink
> +	  capability. This is designed for linear control of
> +	  voice coil motors, controlled via I2C serial interface.
> +
>  config VIDEO_SAA7110
>  	tristate "Philips SAA7110 video decoder"
>  	depends on VIDEO_V4L2 && I2C
> diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile index
> 62323ec..987bd1f 100644
> --- a/drivers/media/i2c/Makefile
> +++ b/drivers/media/i2c/Makefile
> @@ -21,6 +21,7 @@ obj-$(CONFIG_VIDEO_SAA7127) += saa7127.o
>  obj-$(CONFIG_VIDEO_SAA7185) += saa7185.o
>  obj-$(CONFIG_VIDEO_SAA6752HS) += saa6752hs.o
>  obj-$(CONFIG_VIDEO_AD5820)  += ad5820.o
> +obj-$(CONFIG_VIDEO_DW9714)  += dw9714.o
>  obj-$(CONFIG_VIDEO_ADV7170) += adv7170.o
>  obj-$(CONFIG_VIDEO_ADV7175) += adv7175.o
>  obj-$(CONFIG_VIDEO_ADV7180) += adv7180.o diff --git
> a/drivers/media/i2c/dw9714.c b/drivers/media/i2c/dw9714.c new file mode
> 100644 index 0000000..22c84de
> --- /dev/null
> +++ b/drivers/media/i2c/dw9714.c
> @@ -0,0 +1,292 @@
> +/*
> + * Copyright (c) 2015--2017 Intel Corporation.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License version
> + * 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/acpi.h>
> +#include <linux/delay.h>
> +#include <linux/i2c.h>
> +#include <linux/module.h>
> +#include <linux/pm_runtime.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +
> +#define DW9714_NAME		"dw9714"
> +#define DW9714_MAX_FOCUS_POS	1023
> +/*
> + * This acts as the minimum granularity of lens movement.
> + * Keep this value power of 2, so the control steps can be
> + * uniformly adjusted for gradual lens movement, with desired
> + * number of control steps.
> + */
> +#define DW9714_CTRL_STEPS	16
> +#define DW9714_CTRL_DELAY_US	1000
> +/*
> + * S[3:2] = 0x00, codes per step for "Linear Slope Control"
> + * S[1:0] = 0x00, step period
> + */
> +#define DW9714_DEFAULT_S 0x0
> +#define DW9714_VAL(data, s) ((data) << 4 | (s))
> +
> +/* dw9714 device structure */
> +struct dw9714_device {
> +	struct i2c_client *client;
> +	struct v4l2_ctrl_handler ctrls_vcm;
> +	struct v4l2_subdev sd;
> +	u16 current_val;
> +};
> +
> +static inline struct dw9714_device *to_dw9714_vcm(struct v4l2_ctrl
> +*ctrl) {
> +	return container_of(ctrl->handler, struct dw9714_device, ctrls_vcm); }
> +
> +static inline struct dw9714_device *sd_to_dw9714_vcm(struct v4l2_subdev
> +*subdev) {
> +	return container_of(subdev, struct dw9714_device, sd); }
> +
> +static int dw9714_i2c_write(struct i2c_client *client, u16 data) {
> +	int ret;
> +	u16 val = cpu_to_be16(data);
> +
> +	ret = i2c_master_send(client, (const char *)&val, sizeof(val));
> +	if (ret != sizeof(val)) {
> +		dev_err(&client->dev, "I2C write fail\n");
> +		return -EIO;
> +	}
> +	return 0;
> +}
> +
> +static int dw9714_t_focus_vcm(struct dw9714_device *dw9714_dev, u16
> +val) {
> +	struct i2c_client *client = dw9714_dev->client;
> +
> +	dw9714_dev->current_val = val;
> +
> +	return dw9714_i2c_write(client, DW9714_VAL(val,
> DW9714_DEFAULT_S)); }
> +
> +static int dw9714_set_ctrl(struct v4l2_ctrl *ctrl) {
> +	struct dw9714_device *dev_vcm = to_dw9714_vcm(ctrl);
> +
> +	if (ctrl->id == V4L2_CID_FOCUS_ABSOLUTE)
> +		return dw9714_t_focus_vcm(dev_vcm, ctrl->val);
> +
> +	return -EINVAL;
> +}
> +
> +static const struct v4l2_ctrl_ops dw9714_vcm_ctrl_ops = {
> +	.s_ctrl = dw9714_set_ctrl,
> +};
> +
> +static int dw9714_init_controls(struct dw9714_device *dev_vcm) {
> +	struct v4l2_ctrl_handler *hdl = &dev_vcm->ctrls_vcm;
> +	const struct v4l2_ctrl_ops *ops = &dw9714_vcm_ctrl_ops;
> +	struct i2c_client *client = dev_vcm->client;
> +
> +	v4l2_ctrl_handler_init(hdl, 1);
> +
> +	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_FOCUS_ABSOLUTE,
> +			  0, DW9714_MAX_FOCUS_POS,
> DW9714_CTRL_STEPS, 0);
> +
> +	if (hdl->error)
> +		dev_err(&client->dev, "dw9714_init_controls fail\n");
> +	dev_vcm->sd.ctrl_handler = hdl;
> +	return hdl->error;
> +}
> +
> +static void dw9714_subdev_cleanup(struct dw9714_device *dw9714_dev) {
> +	v4l2_async_unregister_subdev(&dw9714_dev->sd);
> +	v4l2_device_unregister_subdev(&dw9714_dev->sd);
> +	v4l2_ctrl_handler_free(&dw9714_dev->ctrls_vcm);
> +	media_entity_cleanup(&dw9714_dev->sd.entity);
> +}
> +
> +static int dw9714_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh
> +*fh) {
> +	struct dw9714_device *dw9714_dev = sd_to_dw9714_vcm(sd);
> +	struct device *dev = &dw9714_dev->client->dev;
> +	int rval;
> +
> +	rval = pm_runtime_get_sync(dev);
> +	if (rval < 0) {
> +		pm_runtime_put_noidle(dev);
> +		return rval;
> +	}
> +
> +	return 0;
> +}
> +
> +static int dw9714_close(struct v4l2_subdev *sd, struct v4l2_subdev_fh
> +*fh) {
> +	struct dw9714_device *dw9714_dev = sd_to_dw9714_vcm(sd);
> +	struct device *dev = &dw9714_dev->client->dev;
> +
> +	pm_runtime_put(dev);
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_subdev_internal_ops dw9714_int_ops = {
> +	.open = dw9714_open,
> +	.close = dw9714_close,
> +};
> +
> +static const struct v4l2_subdev_ops dw9714_ops = { };
> +
> +static int dw9714_probe(struct i2c_client *client,
> +			const struct i2c_device_id *devid)
> +{
> +	struct dw9714_device *dw9714_dev;
> +	int rval;
> +
> +	dw9714_dev = devm_kzalloc(&client->dev, sizeof(*dw9714_dev),
> +				  GFP_KERNEL);
> +
> +	if (dw9714_dev == NULL)
> +		return -ENOMEM;
> +
> +	dw9714_dev->client = client;
> +
> +	v4l2_i2c_subdev_init(&dw9714_dev->sd, client, &dw9714_ops);
> +	dw9714_dev->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +	dw9714_dev->sd.internal_ops = &dw9714_int_ops;
> +
> +	rval = dw9714_init_controls(dw9714_dev);
> +	if (rval)
> +		goto err_cleanup;
> +
> +	rval = media_entity_pads_init(&dw9714_dev->sd.entity, 0, NULL);
> +	if (rval < 0)
> +		goto err_cleanup;
> +
> +	dw9714_dev->sd.entity.function = MEDIA_ENT_F_LENS;
> +
> +	rval = v4l2_async_register_subdev(&dw9714_dev->sd);
> +	if (rval < 0)
> +		goto err_cleanup;
> +
> +	pm_runtime_enable(&client->dev);
> +
> +	return 0;
> +
> +err_cleanup:
> +	dw9714_subdev_cleanup(dw9714_dev);
> +	dev_err(&client->dev, "Probe failed: %d\n", rval);
> +	return rval;
> +}
> +
> +static int dw9714_remove(struct i2c_client *client) {
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +	struct dw9714_device *dw9714_dev = sd_to_dw9714_vcm(sd);
> +
> +	pm_runtime_disable(&client->dev);
> +	dw9714_subdev_cleanup(dw9714_dev);
> +
> +	return 0;
> +}
> +
> +/*
> + * This function sets the vcm position, so it consumes least current
> + * The lens position is gradually moved in units of DW9714_CTRL_STEPS,
> + * to make the movements smoothly.
> + */
> +static int __maybe_unused dw9714_vcm_suspend(struct device *dev) {
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +	struct dw9714_device *dw9714_dev = sd_to_dw9714_vcm(sd);
> +	int ret, val;
> +
> +	for (val = dw9714_dev->current_val & ~(DW9714_CTRL_STEPS - 1);
> +	     val >= 0; val -= DW9714_CTRL_STEPS) {
> +		ret = dw9714_i2c_write(client,
> +				       DW9714_VAL(val, DW9714_DEFAULT_S));
> +		if (ret)
> +			dev_err_once(dev, "%s I2C failure: %d", __func__, ret);
> +		usleep_range(DW9714_CTRL_DELAY_US,
> DW9714_CTRL_DELAY_US + 10);
> +	}
> +	return 0;
> +}
> +
> +/*
> + * This function sets the vcm position to the value set by the user
> + * through v4l2_ctrl_ops s_ctrl handler
> + * The lens position is gradually moved in units of DW9714_CTRL_STEPS,
> + * to make the movements smoothly.
> + */
> +static int  __maybe_unused dw9714_vcm_resume(struct device *dev) {
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +	struct dw9714_device *dw9714_dev = sd_to_dw9714_vcm(sd);
> +	int ret, val;
> +
> +	for (val = dw9714_dev->current_val % DW9714_CTRL_STEPS;
> +	     val < dw9714_dev->current_val + DW9714_CTRL_STEPS - 1;
> +	     val += DW9714_CTRL_STEPS) {
> +		ret = dw9714_i2c_write(client,
> +				       DW9714_VAL(val, DW9714_DEFAULT_S));
> +		if (ret)
> +			dev_err_ratelimited(dev, "%s I2C failure: %d",
> +						__func__, ret);
> +		usleep_range(DW9714_CTRL_DELAY_US,
> DW9714_CTRL_DELAY_US + 10);
> +	}
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_ACPI
> +static const struct acpi_device_id dw9714_acpi_match[] = {
> +	{"DW9714", 0},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(acpi, dw9714_acpi_match); #endif
> +
> +static const struct i2c_device_id dw9714_id_table[] = {
> +	{DW9714_NAME, 0},
> +	{}
> +};
> +
> +MODULE_DEVICE_TABLE(i2c, dw9714_id_table);
> +
> +static const struct dev_pm_ops dw9714_pm_ops = {
> +	SET_SYSTEM_SLEEP_PM_OPS(dw9714_vcm_suspend,
> dw9714_vcm_resume)
> +	SET_RUNTIME_PM_OPS(dw9714_vcm_suspend,
> dw9714_vcm_resume, NULL) };
> +
> +static struct i2c_driver dw9714_i2c_driver = {
> +	.driver = {
> +		.name = DW9714_NAME,
> +		.pm = &dw9714_pm_ops,
> +		.acpi_match_table = ACPI_PTR(dw9714_acpi_match),
> +	},
> +	.probe = dw9714_probe,
> +	.remove = dw9714_remove,
> +	.id_table = dw9714_id_table,
> +};
> +
> +module_i2c_driver(dw9714_i2c_driver);
> +
> +MODULE_AUTHOR("Tianshu Qiu <tian.shu.qiu@intel.com>");
> +MODULE_AUTHOR("Jian Xu Zheng <jian.xu.zheng@intel.com>");
> +MODULE_AUTHOR("Yuning Pu <yuning.pu@intel.com>");
> MODULE_AUTHOR("Jouni
> +Ukkonen <jouni.ukkonen@intel.com>"); MODULE_AUTHOR("Tommi Franttila
> +<tommi.franttila@intel.com>");
> +MODULE_DESCRIPTION("DW9714 VCM driver"); MODULE_LICENSE("GPL");
> --
> 1.9.1
