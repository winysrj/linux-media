Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:17532 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751021AbeEUHJY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 03:09:24 -0400
Subject: Re: [PATCH v2 1/3] media: dw9807: Add dw9807 vcm driver
To: bingbu.cao@intel.com, linux-media@vger.kernel.org
Cc: sakari.ailus@linux.intel.com, tian.shu.qiu@linux.intel.com,
        rajmohan.mani@intel.com, mchehab@kernel.org
References: <1526529744-25446-1-git-send-email-bingbu.cao@intel.com>
 <1526886637-14378-1-git-send-email-bingbu.cao@intel.com>
From: Bing Bu Cao <bingbu.cao@linux.intel.com>
Message-ID: <195af897-f999-9b7b-9fb6-40922b637bdd@linux.intel.com>
Date: Mon, 21 May 2018 15:11:53 +0800
MIME-Version: 1.0
In-Reply-To: <1526886637-14378-1-git-send-email-bingbu.cao@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Please ignore this patch.

On 2018年05月21日 15:10, bingbu.cao@intel.com wrote:
> From: Alan Chiang <alanx.chiang@intel.com>
>
> DW9807 is a 10 bit DAC from Dongwoon, designed for linear
> control of voice coil motor.
>
> This driver creates a V4L2 subdevice and
> provides control to set the desired focus.
>
> Signed-off-by: Andy Yeh <andy.yeh@intel.com>
> Reviewed-by: Jacopo Mondi <jacopo@jmondi.org>
> Reviewed-by: Tomasz Figa <tfiga@chromium.org>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>   MAINTAINERS                |   7 +
>   drivers/media/i2c/Kconfig  |  10 ++
>   drivers/media/i2c/Makefile |   1 +
>   drivers/media/i2c/dw9807.c | 329 +++++++++++++++++++++++++++++++++++++++++++++
>   4 files changed, 347 insertions(+)
>   create mode 100644 drivers/media/i2c/dw9807.c
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 49003f77cedd..4d6f837b2337 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4375,6 +4375,13 @@ T:	git git://linuxtv.org/media_tree.git
>   S:	Maintained
>   F:	drivers/media/i2c/dw9714.c
>   
> +DONGWOON DW9807 LENS VOICE COIL DRIVER
> +M:	Sakari Ailus <sakari.ailus@linux.intel.com>
> +L:	linux-media@vger.kernel.org
> +T:	git git://linuxtv.org/media_tree.git
> +S:	Maintained
> +F:	drivers/media/i2c/dw9807.c
> +
>   DOUBLETALK DRIVER
>   M:	"James R. Van Zandt" <jrv@vanzandt.mv.com>
>   L:	blinux-list@redhat.com
> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> index b95b44702ccb..e6a721c5e3b0 100644
> --- a/drivers/media/i2c/Kconfig
> +++ b/drivers/media/i2c/Kconfig
> @@ -336,6 +336,16 @@ config VIDEO_DW9714
>   	  capability. This is designed for linear control of
>   	  voice coil motors, controlled via I2C serial interface.
>   
> +config VIDEO_DW9807
> +	tristate "DW9807 lens voice coil support"
> +	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
> +	depends on VIDEO_V4L2_SUBDEV_API
> +	---help---
> +	  This is a driver for the DW9807 camera lens voice coil.
> +	  DW9807 is a 10 bit DAC with 100mA output current sink
> +	  capability. This is designed for linear control of
> +	  voice coil motors, controlled via I2C serial interface.
> +
>   config VIDEO_SAA7110
>   	tristate "Philips SAA7110 video decoder"
>   	depends on VIDEO_V4L2 && I2C
> diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
> index ff6e2914abda..5cf15edacb2b 100644
> --- a/drivers/media/i2c/Makefile
> +++ b/drivers/media/i2c/Makefile
> @@ -24,6 +24,7 @@ obj-$(CONFIG_VIDEO_SAA7185) += saa7185.o
>   obj-$(CONFIG_VIDEO_SAA6752HS) += saa6752hs.o
>   obj-$(CONFIG_VIDEO_AD5820)  += ad5820.o
>   obj-$(CONFIG_VIDEO_DW9714)  += dw9714.o
> +obj-$(CONFIG_VIDEO_DW9807)  += dw9807.o
>   obj-$(CONFIG_VIDEO_ADV7170) += adv7170.o
>   obj-$(CONFIG_VIDEO_ADV7175) += adv7175.o
>   obj-$(CONFIG_VIDEO_ADV7180) += adv7180.o
> diff --git a/drivers/media/i2c/dw9807.c b/drivers/media/i2c/dw9807.c
> new file mode 100644
> index 000000000000..6ebb98717fb1
> --- /dev/null
> +++ b/drivers/media/i2c/dw9807.c
> @@ -0,0 +1,329 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (C) 2018 Intel Corporation
> +
> +#include <linux/acpi.h>
> +#include <linux/delay.h>
> +#include <linux/i2c.h>
> +#include <linux/iopoll.h>
> +#include <linux/module.h>
> +#include <linux/pm_runtime.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +
> +#define DW9807_MAX_FOCUS_POS	1023
> +/*
> + * This sets the minimum granularity for the focus positions.
> + * A value of 1 gives maximum accuracy for a desired focus position.
> + */
> +#define DW9807_FOCUS_STEPS	1
> +/*
> + * This acts as the minimum granularity of lens movement.
> + * Keep this value power of 2, so the control steps can be
> + * uniformly adjusted for gradual lens movement, with desired
> + * number of control steps.
> + */
> +#define DW9807_CTRL_STEPS	16
> +#define DW9807_CTRL_DELAY_US	1000
> +
> +#define DW9807_CTL_ADDR		0x02
> +/*
> + * DW9807 separates two registers to control the VCM position.
> + * One for MSB value, another is LSB value.
> + */
> +#define DW9807_MSB_ADDR		0x03
> +#define DW9807_LSB_ADDR		0x04
> +#define DW9807_STATUS_ADDR	0x05
> +#define DW9807_MODE_ADDR	0x06
> +#define DW9807_RESONANCE_ADDR	0x07
> +
> +#define MAX_RETRY		10
> +
> +struct dw9807_device {
> +	struct v4l2_ctrl_handler ctrls_vcm;
> +	struct v4l2_subdev sd;
> +	u16 current_val;
> +};
> +
> +static inline struct dw9807_device *sd_to_dw9807_vcm(
> +					struct v4l2_subdev *subdev)
> +{
> +	return container_of(subdev, struct dw9807_device, sd);
> +}
> +
> +static int dw9807_i2c_check(struct i2c_client *client)
> +{
> +	const char status_addr = DW9807_STATUS_ADDR;
> +	char status_result;
> +	int ret;
> +
> +	ret = i2c_master_send(client, &status_addr, sizeof(status_addr));
> +	if (ret < 0) {
> +		dev_err(&client->dev, "I2C write STATUS address fail ret = %d\n",
> +			ret);
> +		return ret;
> +	}
> +
> +	ret = i2c_master_recv(client, &status_result, sizeof(status_result));
> +	if (ret < 0) {
> +		dev_err(&client->dev, "I2C read STATUS value fail ret = %d\n",
> +			ret);
> +		return ret;
> +	}
> +
> +	return status_result;
> +}
> +
> +static int dw9807_set_dac(struct i2c_client *client, u16 data)
> +{
> +	const char tx_data[3] = {
> +		DW9807_MSB_ADDR, ((data >> 8) & 0x03), (data & 0xff)
> +	};
> +	int val, ret;
> +
> +	/*
> +	 * According to the datasheet, need to check the bus status before we
> +	 * write VCM position. This ensure that we really write the value
> +	 * into the register
> +	 */
> +	ret = readx_poll_timeout(dw9807_i2c_check, client, val, val <= 0,
> +			DW9807_CTRL_DELAY_US, MAX_RETRY * DW9807_CTRL_DELAY_US);
> +
> +	if (ret || val < 0) {
> +		if (ret) {
> +			dev_warn(&client->dev,
> +				"Cannot do the write operation because VCM is busy\n");
> +		}
> +
> +		return ret ? -EBUSY : val;
> +	}
> +
> +	/* Write VCM position to registers */
> +	ret = i2c_master_send(client, tx_data, sizeof(tx_data));
> +	if (ret < 0) {
> +		dev_err(&client->dev,
> +			"I2C write MSB fail ret=%d\n", ret);
> +
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int dw9807_set_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct dw9807_device *dev_vcm = container_of(ctrl->handler,
> +		struct dw9807_device, ctrls_vcm);
> +
> +	if (ctrl->id == V4L2_CID_FOCUS_ABSOLUTE) {
> +		struct i2c_client *client = v4l2_get_subdevdata(&dev_vcm->sd);
> +
> +		dev_vcm->current_val = ctrl->val;
> +		return dw9807_set_dac(client, ctrl->val);
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +static const struct v4l2_ctrl_ops dw9807_vcm_ctrl_ops = {
> +	.s_ctrl = dw9807_set_ctrl,
> +};
> +
> +static int dw9807_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
> +{
> +	int rval;
> +
> +	rval = pm_runtime_get_sync(sd->dev);
> +	if (rval < 0) {
> +		pm_runtime_put_noidle(sd->dev);
> +		return rval;
> +	}
> +
> +	return 0;
> +}
> +
> +static int dw9807_close(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
> +{
> +	pm_runtime_put(sd->dev);
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_subdev_internal_ops dw9807_int_ops = {
> +	.open = dw9807_open,
> +	.close = dw9807_close,
> +};
> +
> +static const struct v4l2_subdev_ops dw9807_ops = { };
> +
> +static void dw9807_subdev_cleanup(struct dw9807_device *dw9807_dev)
> +{
> +	v4l2_async_unregister_subdev(&dw9807_dev->sd);
> +	v4l2_ctrl_handler_free(&dw9807_dev->ctrls_vcm);
> +	media_entity_cleanup(&dw9807_dev->sd.entity);
> +}
> +
> +static int dw9807_init_controls(struct dw9807_device *dev_vcm)
> +{
> +	struct v4l2_ctrl_handler *hdl = &dev_vcm->ctrls_vcm;
> +	const struct v4l2_ctrl_ops *ops = &dw9807_vcm_ctrl_ops;
> +	struct i2c_client *client = v4l2_get_subdevdata(&dev_vcm->sd);
> +
> +	v4l2_ctrl_handler_init(hdl, 1);
> +
> +	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_FOCUS_ABSOLUTE,
> +			  0, DW9807_MAX_FOCUS_POS, DW9807_FOCUS_STEPS, 0);
> +
> +	dev_vcm->sd.ctrl_handler = hdl;
> +	if (hdl->error) {
> +		dev_err(&client->dev, "%s fail error: 0x%x\n",
> +			__func__, hdl->error);
> +		return hdl->error;
> +	}
> +
> +	return 0;
> +}
> +
> +static int dw9807_probe(struct i2c_client *client)
> +{
> +	struct dw9807_device *dw9807_dev;
> +	int rval;
> +
> +	dw9807_dev = devm_kzalloc(&client->dev, sizeof(*dw9807_dev),
> +				  GFP_KERNEL);
> +	if (dw9807_dev == NULL)
> +		return -ENOMEM;
> +
> +	v4l2_i2c_subdev_init(&dw9807_dev->sd, client, &dw9807_ops);
> +	dw9807_dev->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +	dw9807_dev->sd.internal_ops = &dw9807_int_ops;
> +
> +	rval = dw9807_init_controls(dw9807_dev);
> +	if (rval)
> +		goto err_cleanup;
> +
> +	rval = media_entity_pads_init(&dw9807_dev->sd.entity, 0, NULL);
> +	if (rval < 0)
> +		goto err_cleanup;
> +
> +	dw9807_dev->sd.entity.function = MEDIA_ENT_F_LENS;
> +
> +	rval = v4l2_async_register_subdev(&dw9807_dev->sd);
> +	if (rval < 0)
> +		goto err_cleanup;
> +
> +	pm_runtime_set_active(&client->dev);
> +	pm_runtime_enable(&client->dev);
> +	pm_runtime_idle(&client->dev);
> +
> +	return 0;
> +
> +err_cleanup:
> +	dw9807_subdev_cleanup(dw9807_dev);
> +
> +	return rval;
> +}
> +
> +static int dw9807_remove(struct i2c_client *client)
> +{
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +	struct dw9807_device *dw9807_dev = sd_to_dw9807_vcm(sd);
> +
> +	pm_runtime_disable(&client->dev);
> +	pm_runtime_set_suspended(&client->dev);
> +
> +	dw9807_subdev_cleanup(dw9807_dev);
> +
> +	return 0;
> +}
> +
> +/*
> + * This function sets the vcm position, so it consumes least current
> + * The lens position is gradually moved in units of DW9807_CTRL_STEPS,
> + * to make the movements smoothly.
> + */
> +static int __maybe_unused dw9807_vcm_suspend(struct device *dev)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +	struct dw9807_device *dw9807_dev = sd_to_dw9807_vcm(sd);
> +	const char tx_data[2] = { DW9807_CTL_ADDR, 0x01 };
> +	int ret, val;
> +
> +	for (val = dw9807_dev->current_val & ~(DW9807_CTRL_STEPS - 1);
> +	     val >= 0; val -= DW9807_CTRL_STEPS) {
> +		ret = dw9807_set_dac(client, val);
> +		if (ret)
> +			dev_err_once(dev, "%s I2C failure: %d", __func__, ret);
> +		usleep_range(DW9807_CTRL_DELAY_US, DW9807_CTRL_DELAY_US + 10);
> +	}
> +
> +	/* Power down */
> +	ret = i2c_master_send(client, tx_data, sizeof(tx_data));
> +	if (ret < 0) {
> +		dev_err(&client->dev, "I2C write CTL fail ret = %d\n", ret);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * This function sets the vcm position to the value set by the user
> + * through v4l2_ctrl_ops s_ctrl handler
> + * The lens position is gradually moved in units of DW9807_CTRL_STEPS,
> + * to make the movements smoothly.
> + */
> +static int  __maybe_unused dw9807_vcm_resume(struct device *dev)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +	struct dw9807_device *dw9807_dev = sd_to_dw9807_vcm(sd);
> +	const char tx_data[2] = { DW9807_CTL_ADDR, 0x00 };
> +	int ret, val;
> +
> +	/* Power on */
> +	ret = i2c_master_send(client, tx_data, sizeof(tx_data));
> +	if (ret < 0) {
> +		dev_err(&client->dev, "I2C write CTL fail ret = %d\n", ret);
> +		return ret;
> +	}
> +
> +	for (val = dw9807_dev->current_val % DW9807_CTRL_STEPS;
> +	     val < dw9807_dev->current_val + DW9807_CTRL_STEPS - 1;
> +	     val += DW9807_CTRL_STEPS) {
> +		ret = dw9807_set_dac(client, val);
> +		if (ret)
> +			dev_err_ratelimited(dev, "%s I2C failure: %d",
> +						__func__, ret);
> +		usleep_range(DW9807_CTRL_DELAY_US, DW9807_CTRL_DELAY_US + 10);
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id dw9807_of_table[] = {
> +	{ .compatible = "dongwoon,dw9807" },
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, dw9807_of_table);
> +
> +static const struct dev_pm_ops dw9807_pm_ops = {
> +	SET_SYSTEM_SLEEP_PM_OPS(dw9807_vcm_suspend, dw9807_vcm_resume)
> +	SET_RUNTIME_PM_OPS(dw9807_vcm_suspend, dw9807_vcm_resume, NULL)
> +};
> +
> +static struct i2c_driver dw9807_i2c_driver = {
> +	.driver = {
> +		.name = "dw9807",
> +		.pm = &dw9807_pm_ops,
> +		.of_match_table = dw9807_of_table,
> +	},
> +	.probe_new = dw9807_probe,
> +	.remove = dw9807_remove,
> +};
> +
> +module_i2c_driver(dw9807_i2c_driver);
> +
> +MODULE_AUTHOR("Chiang, Alan <alanx.chiang@intel.com>");
> +MODULE_DESCRIPTION("DW9807 VCM driver");
> +MODULE_LICENSE("GPL v2");
