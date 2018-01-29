Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:14170 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751387AbeA2P1L (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Jan 2018 10:27:11 -0500
From: "Yeh, Andy" <andy.yeh@intel.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "Chiang, AlanX" <alanx.chiang@intel.com>
Subject: RE: [PATCH v3] media: dw9807: Add dw9807 vcm driver
Date: Mon, 29 Jan 2018 15:27:03 +0000
Message-ID: <8E0971CCB6EA9D41AF58191A2D3978B61D4F6EFE@PGSMSX111.gar.corp.intel.com>
References: <1516901932-22636-1-git-send-email-andy.yeh@intel.com>
 <20180126085649.j4i6zr4hbww3jx3o@paasikivi.fi.intel.com>
In-Reply-To: <20180126085649.j4i6zr4hbww3jx3o@paasikivi.fi.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

All comments are all addressed, except below one. And will separate the DT binding.

> +	while (dw9807_i2c_check(client) != 0) {
> +		if (MAX_RETRY == ++retry) {
> +			dev_err(&client->dev, "Cannot do the write operation because VCM is busy\n");
> +			return -EIO;
> +		}
> +		usleep_range(DW9807_CTRL_DELAY_US, DW9807_CTRL_DELAY_US + 10);

I wonder how common it is that you'll end up here. That'd likely be troublesome for the AF control. Ideally a read-only control would tell you this, but that could well be added later on.

Our comment:
(DW9807_STATUS_ADDR	0x05) is the read-only control. By referring to the datasheet as below. So Alan implemented this checking with a while loop until it read out 0.

"
VBUSY: VBUSY bit must be checked '0' before "VCM MSB and LSB" registers are written.
During ringing control mode operation, VBUSY bit keep '1'.
While VBUSY = '1', the I2C command for VCM is ignored.
"


Regards, Andy

-----Original Message-----
From: Sakari Ailus [mailto:sakari.ailus@linux.intel.com] 
Sent: Friday, January 26, 2018 4:57 PM
To: Yeh, Andy <andy.yeh@intel.com>
Cc: linux-media@vger.kernel.org; tfiga@chromium.org; Chiang, AlanX <alanx.chiang@intel.com>
Subject: Re: [PATCH v3] media: dw9807: Add dw9807 vcm driver

Hi Andy,

There seem to be two different v3 versions of the dw9807 driver patch. I assume this is the right one.

A few more comments below.

On Fri, Jan 26, 2018 at 01:38:52AM +0800, Andy Yeh wrote:
> From: Alan Chiang <alanx.chiang@intel.com>
> 
> DW9807 is a 10 bit DAC from Dongwoon, designed for linear control of 
> voice coil motor. This driver creates a V4L2 subdevice and provides 
> control to set the desired focus.
> 
> Signed-off-by: Andy Yeh <andy.yeh@intel.com>
> ---
> since v1:
> - changed author.
> since v2:
> - addressed outstanding comments.
> - enabled sequential write to update 2 registers in a single transaction.
> 
>  .../bindings/media/i2c/dongwoon,dw9807.txt         |   9 +
>  MAINTAINERS                                        |   7 +
>  drivers/media/i2c/Kconfig                          |  10 +
>  drivers/media/i2c/Makefile                         |   1 +
>  drivers/media/i2c/dw9807.c                         | 349 +++++++++++++++++++++
>  5 files changed, 376 insertions(+)
>  create mode 100644 
> Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt
>  create mode 100644 drivers/media/i2c/dw9807.c
> 
> diff --git 
> a/Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt 
> b/Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt
> new file mode 100644
> index 0000000..0a1a860
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt
> @@ -0,0 +1,9 @@
> +Dongwoon Anatech DW9807 voice coil lens driver
> +
> +DW9807 is a 10-bit DAC with current sink capability. It is intended 
> +for controlling voice coil lenses.

Could you implement the changes proposed in the review, or if there are questions, answer to the comments, please?

In particular, the DT bindings should go to a separate patch.

> +
> +Mandatory properties:
> +
> +- compatible: "dongwoon,dw9807"
> +- reg: I2C slave address
> diff --git a/MAINTAINERS b/MAINTAINERS index 810d5d9..4f1704e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4385,6 +4385,13 @@ T:	git git://linuxtv.org/media_tree.git
>  S:	Maintained
>  F:	drivers/media/i2c/dw9714.c
>  
> +DONGWOON DW9807 LENS VOICE COIL DRIVER
> +M:	Sakari Ailus <sakari.ailus@linux.intel.com>
> +L:	linux-media@vger.kernel.org
> +T:	git git://linuxtv.org/media_tree.git
> +S:	Maintained
> +F:	drivers/media/i2c/dw9807.c
> +
>  DOUBLETALK DRIVER
>  M:	"James R. Van Zandt" <jrv@vanzandt.mv.com>
>  L:	blinux-list@redhat.com
> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig 
> index cb5d7ff..fd01842 100644
> --- a/drivers/media/i2c/Kconfig
> +++ b/drivers/media/i2c/Kconfig
> @@ -325,6 +325,16 @@ config VIDEO_DW9714
>  	  capability. This is designed for linear control of
>  	  voice coil motors, controlled via I2C serial interface.
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
>  config VIDEO_SAA7110
>  	tristate "Philips SAA7110 video decoder"
>  	depends on VIDEO_V4L2 && I2C
> diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile 
> index 548a9ef..1b62639 100644
> --- a/drivers/media/i2c/Makefile
> +++ b/drivers/media/i2c/Makefile
> @@ -23,6 +23,7 @@ obj-$(CONFIG_VIDEO_SAA7185) += saa7185.o
>  obj-$(CONFIG_VIDEO_SAA6752HS) += saa6752hs.o
>  obj-$(CONFIG_VIDEO_AD5820)  += ad5820.o
>  obj-$(CONFIG_VIDEO_DW9714)  += dw9714.o
> +obj-$(CONFIG_VIDEO_DW9807)  += dw9807.o
>  obj-$(CONFIG_VIDEO_ADV7170) += adv7170.o
>  obj-$(CONFIG_VIDEO_ADV7175) += adv7175.o
>  obj-$(CONFIG_VIDEO_ADV7180) += adv7180.o diff --git 
> a/drivers/media/i2c/dw9807.c b/drivers/media/i2c/dw9807.c new file 
> mode 100644 index 0000000..4d243db
> --- /dev/null
> +++ b/drivers/media/i2c/dw9807.c
> @@ -0,0 +1,349 @@
> +// Copyright (C) 2018 Intel Corporation // SPDX-License-Identifier: 
> +GPL-2.0
> +
> +#include <linux/acpi.h>
> +#include <linux/delay.h>
> +#include <linux/i2c.h>
> +#include <linux/module.h>
> +#include <linux/pm_runtime.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +
> +#define DW9807_NAME		"dw9807"
> +#define DW9807_MAX_FOCUS_POS	1023
> +/*
> + * This sets the minimum granularity for the focus positions.
> + * A value of 1 gives maximum accuracy for a desired focus position  
> +*/
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
> +	struct i2c_client *client;

You could use v4l2_get_subdevdata on the sub-device to obtain the client, just as the dw9714 driver does.

> +	struct v4l2_ctrl_handler ctrls_vcm;
> +	struct v4l2_subdev sd;
> +	u16 current_val;
> +};
> +
> +static inline struct dw9807_device *to_dw9807_vcm(struct v4l2_ctrl 
> +*ctrl)

You only use this once. How about simply using container_of() there instead?

> +{
> +	return container_of(ctrl->handler, struct dw9807_device, ctrls_vcm); 
> +}
> +
> +static inline struct dw9807_device *sd_to_dw9807_vcm(struct 
> +v4l2_subdev *subdev) {
> +	return container_of(subdev, struct dw9807_device, sd); }
> +
> +static int dw9807_i2c_check(struct i2c_client *client) {
> +	int ret;

It's usually best to declare temporary and loop variables as last, typically this leads to shorter declarations being last.

> +	int status_addr = DW9807_STATUS_ADDR;

const char ?

> +	u8 status_result = 0x1;

char

> +
> +	ret = i2c_master_send(client, (const char *)&status_addr, sizeof(status_addr));
> +	if (ret != sizeof(status_addr)) {
> +		dev_err(&client->dev, "I2C write STATUS address fail ret = %d\n",
> +			ret);
> +		return -EIO;
> +	}
> +
> +	ret = i2c_master_recv(client, (char *)&status_result, sizeof(status_result));
> +	if (ret != sizeof(status_result)) {
> +		dev_err(&client->dev, "I2C read STATUS value fail ret=%d\n",
> +			ret);
> +		return -EIO;
> +	}
> +
> +	return status_result;
> +}
> +
> +static int dw9807_i2c_write(struct i2c_client *client, u16 data)

The name of the function suggests a generic write command but it's actually about setting the coil current. How about reflecting that in the function name?

> +{
> +	int ret, retry = 0;
> +	u8 tx_data[3];

const char ?

And remove the typecasts below.

> +
> +	tx_data[0] = DW9807_MSB_ADDR;
> +	tx_data[1] = (u8)((data >> 8) & 0x03);
> +	tx_data[2] = (u8)(data & 0xFF);
> +
> +	/* According to the datasheet, need to check the bus status before 
> +we

/*
 * ...

> +	 * write VCM position. This ensure that we really write the value
> +	 * into the register
> +	 */
> +	while (dw9807_i2c_check(client) != 0) {
> +		if (MAX_RETRY == ++retry) {
> +			dev_err(&client->dev, "Cannot do the write operation because VCM is busy\n");
> +			return -EIO;
> +		}
> +		usleep_range(DW9807_CTRL_DELAY_US, DW9807_CTRL_DELAY_US + 10);

I wonder how common it is that you'll end up here. That'd likely be troublesome for the AF control. Ideally a read-only control would tell you this, but that could well be added later on.

> +	}
> +
> +	/* Write VCM position to registers */
> +	ret = i2c_master_send(client, (const char *)&tx_data, sizeof(tx_data));
> +	if (ret != sizeof(tx_data)) {
> +		dev_err(&client->dev, "I2C write MSB fail\n");
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
> +static int dw9807_set_ctrl(struct v4l2_ctrl *ctrl) {
> +	struct dw9807_device *dev_vcm = to_dw9807_vcm(ctrl);
> +
> +	if (ctrl->id == V4L2_CID_FOCUS_ABSOLUTE) {
> +		struct i2c_client *client = dev_vcm->client;
> +
> +		dev_vcm->current_val = ctrl->val;
> +		return dw9807_i2c_write(client, ctrl->val);
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +static const struct v4l2_ctrl_ops dw9807_vcm_ctrl_ops = {
> +	.s_ctrl = dw9807_set_ctrl,
> +};
> +
> +static int dw9807_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh 
> +*fh) {
> +	struct dw9807_device *dw9807_dev = sd_to_dw9807_vcm(sd);
> +	struct device *dev = &dw9807_dev->client->dev;
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
> +static int dw9807_close(struct v4l2_subdev *sd, struct v4l2_subdev_fh 
> +*fh) {
> +	struct dw9807_device *dw9807_dev = sd_to_dw9807_vcm(sd);
> +	struct device *dev = &dw9807_dev->client->dev;
> +
> +	pm_runtime_put(dev);
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
> +static void dw9807_subdev_cleanup(struct dw9807_device *dw9807_dev) {
> +	v4l2_async_unregister_subdev(&dw9807_dev->sd);
> +	v4l2_ctrl_handler_free(&dw9807_dev->ctrls_vcm);
> +	media_entity_cleanup(&dw9807_dev->sd.entity);
> +}
> +
> +static int dw9807_init_controls(struct dw9807_device *dev_vcm) {
> +	struct v4l2_ctrl_handler *hdl = &dev_vcm->ctrls_vcm;
> +	const struct v4l2_ctrl_ops *ops = &dw9807_vcm_ctrl_ops;
> +	struct i2c_client *client = dev_vcm->client;
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
> +static int dw9807_probe(struct i2c_client *client) {
> +	struct dw9807_device *dw9807_dev;
> +	int rval;
> +
> +	dw9807_dev = devm_kzalloc(&client->dev, sizeof(*dw9807_dev),
> +				  GFP_KERNEL);
> +	if (dw9807_dev == NULL)
> +		return -ENOMEM;
> +
> +	dw9807_dev->client = client;
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
> +	dev_err(&client->dev, "Probe failed: %d\n", rval);

Not needed. If you've been given the same comment on a similar driver, you should apply it elsewhere.

> +	return rval;
> +}
> +
> +static int dw9807_remove(struct i2c_client *client) {
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
> + * The lens position is gradually moved in units of 
> +DW9807_CTRL_STEPS,
> + * to make the movements smoothly.
> + */
> +static int __maybe_unused dw9807_vcm_suspend(struct device *dev) {
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +	struct dw9807_device *dw9807_dev = sd_to_dw9807_vcm(sd);
> +	int ret, val;
> +	u8 tx_data[2];

const char

And assign in variable declaration; same below.

> +
> +	for (val = dw9807_dev->current_val & ~(DW9807_CTRL_STEPS - 1);
> +	     val >= 0; val -= DW9807_CTRL_STEPS) {
> +		ret = dw9807_i2c_write(client, val);
> +		if (ret)
> +			dev_err_once(dev, "%s I2C failure: %d", __func__, ret);
> +		usleep_range(DW9807_CTRL_DELAY_US, DW9807_CTRL_DELAY_US + 10);
> +	}
> +
> +	/* Power down */
> +	tx_data[0] = DW9807_CTL_ADDR;
> +	tx_data[1] = 0x01;
> +
> +	ret = i2c_master_send(client, (const char *)&tx_data, 
> +sizeof(tx_data));
> +
> +	if (ret != sizeof(tx_data)) {
> +		dev_err(&client->dev, "I2C write CTL fail\n");
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * This function sets the vcm position to the value set by the user
> + * through v4l2_ctrl_ops s_ctrl handler
> + * The lens position is gradually moved in units of 
> +DW9807_CTRL_STEPS,
> + * to make the movements smoothly.
> + */
> +static int  __maybe_unused dw9807_vcm_resume(struct device *dev) {
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +	struct dw9807_device *dw9807_dev = sd_to_dw9807_vcm(sd);
> +	int ret, val;
> +	u8 tx_data[2];

const char

> +
> +	/* Power on */
> +	tx_data[0] = DW9807_CTL_ADDR;
> +	tx_data[1] = 0x00;
> +
> +	ret = i2c_master_send(client, (const char *)&tx_data, sizeof(tx_data));
> +	if (ret != sizeof(tx_data)) {
> +		dev_err(&client->dev, "I2C write CTL fail\n");
> +		return -EIO;
> +	}
> +
> +	for (val = dw9807_dev->current_val % DW9807_CTRL_STEPS;
> +	     val < dw9807_dev->current_val + DW9807_CTRL_STEPS - 1;
> +	     val += DW9807_CTRL_STEPS) {
> +		ret = dw9807_i2c_write(client, val);
> +		if (ret)
> +			dev_err_ratelimited(dev, "%s I2C failure: %d",
> +						__func__, ret);
> +		usleep_range(DW9807_CTRL_DELAY_US, DW9807_CTRL_DELAY_US + 10);
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct i2c_device_id dw9807_id_table[] = {
> +	{ DW9807_NAME, 0},
> +	{ { 0 } }
> +};
> +
> +MODULE_DEVICE_TABLE(i2c, dw9807_id_table);
> +
> +static const struct of_device_id dw9807_of_table[] = {
> +	{ .compatible = "dongwoon,dw9807" },
> +	{ { 0 } }
> +};
> +MODULE_DEVICE_TABLE(of, dw9807_of_table);
> +
> +static const struct dev_pm_ops dw9807_pm_ops = {
> +	SET_SYSTEM_SLEEP_PM_OPS(dw9807_vcm_suspend, dw9807_vcm_resume)
> +	SET_RUNTIME_PM_OPS(dw9807_vcm_suspend, dw9807_vcm_resume, NULL) };
> +
> +static struct i2c_driver dw9807_i2c_driver = {
> +	.driver = {
> +		.name = DW9807_NAME,
> +		.pm = &dw9807_pm_ops,
> +		.of_match_table = dw9807_of_table,
> +	},
> +	.probe_new = dw9807_probe,
> +	.remove = dw9807_remove,
> +	.id_table = dw9807_id_table,

Please remove id_table. You don't need that.

> +};
> +
> +module_i2c_driver(dw9807_i2c_driver);
> +
> +MODULE_DESCRIPTION("DW9807 VCM driver"); MODULE_LICENSE("GPL v2");

--
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
