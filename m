Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:26515 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752967AbdEIN1h (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 May 2017 09:27:37 -0400
From: "Mani, Rajmohan" <rajmohan.mani@intel.com>
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Tomasz Figa <tfiga@chromium.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "mchehab@kernel.org" <mchehab@kernel.org>
Subject: RE: [PATCH] dw9714: Initial driver for dw9714 VCM
Date: Tue, 9 May 2017 13:27:35 +0000
Message-ID: <6F87890CF0F5204F892DEA1EF0D77A595AA05B31@FMSMSX114.amr.corp.intel.com>
References: <1494156804-9784-1-git-send-email-rajmohan.mani@intel.com>
 <20170508205503.GL7456@valkosipuli.retiisi.org.uk>
In-Reply-To: <20170508205503.GL7456@valkosipuli.retiisi.org.uk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,
Please see comments inline below.

> -----Original Message-----
> From: Sakari Ailus [mailto:sakari.ailus@iki.fi]
> Sent: Tuesday, May 09, 2017 4:55 AM
> To: Mani, Rajmohan <rajmohan.mani@intel.com>
> Cc: linux-media@vger.kernel.org; mchehab@kernel.org
> Subject: Re: [PATCH] dw9714: Initial driver for dw9714 VCM
> 
> Hi Rajmohan,
> 
> A few comments below...
> 
> On Sun, May 07, 2017 at 04:33:24AM -0700, rajmohan.mani@intel.com
> wrote:
> > From: Rajmohan Mani <rajmohan.mani@intel.com>
> >
> > DW9714 is a 10 bit DAC, designed for linear control of voice coil
> > motor.
> >
> > This driver creates a V4L2 subdevice and provides control to set the
> > desired focus.
> >
> > Signed-off-by: Rajmohan Mani <rajmohan.mani@intel.com>
> > ---
> >  drivers/media/i2c/Kconfig  |   9 ++
> >  drivers/media/i2c/Makefile |   1 +
> >  drivers/media/i2c/dw9714.c | 333
> > +++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 343 insertions(+)
> >  create mode 100644 drivers/media/i2c/dw9714.c
> >
> > diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> > index fd181c9..4f0a7ad 100644
> > --- a/drivers/media/i2c/Kconfig
> > +++ b/drivers/media/i2c/Kconfig
> > @@ -300,6 +300,15 @@ config VIDEO_AD5820
> >  	  This is a driver for the AD5820 camera lens voice coil.
> >  	  It is used for example in Nokia N900 (RX-51).
> >
> > +config VIDEO_DW9714
> > +	tristate "DW9714 lens voice coil support"
> > +	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
> 
> You should also depend on VIDEO_V4L2_SUBDEV_API .

Ack

> 
> > +	---help---
> > +	  This is a driver for the DW9714 camera lens voice coil.
> > +	  DW9714 is a 10 bit DAC with 120mA output current sink
> > +	  capability. This is designed for linear control of
> > +	  voice coil motors, controlled via I2C serial interface.
> > +
> >  config VIDEO_SAA7110
> >  	tristate "Philips SAA7110 video decoder"
> >  	depends on VIDEO_V4L2 && I2C
> > diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
> > index 62323ec..987bd1f 100644
> > --- a/drivers/media/i2c/Makefile
> > +++ b/drivers/media/i2c/Makefile
> > @@ -21,6 +21,7 @@ obj-$(CONFIG_VIDEO_SAA7127) += saa7127.o
> >  obj-$(CONFIG_VIDEO_SAA7185) += saa7185.o
> >  obj-$(CONFIG_VIDEO_SAA6752HS) += saa6752hs.o
> >  obj-$(CONFIG_VIDEO_AD5820)  += ad5820.o
> > +obj-$(CONFIG_VIDEO_DW9714)  += dw9714.o
> >  obj-$(CONFIG_VIDEO_ADV7170) += adv7170.o
> >  obj-$(CONFIG_VIDEO_ADV7175) += adv7175.o
> >  obj-$(CONFIG_VIDEO_ADV7180) += adv7180.o diff --git
> > a/drivers/media/i2c/dw9714.c b/drivers/media/i2c/dw9714.c new file
> > mode 100644 index 0000000..276d3f2
> > --- /dev/null
> > +++ b/drivers/media/i2c/dw9714.c
> > @@ -0,0 +1,333 @@
> > +/*
> > + * Copyright (c) 2015--2017 Intel Corporation.
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License
> > +version
> > + * 2 as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#include <linux/acpi.h>
> > +#include <linux/delay.h>
> > +#include <linux/i2c.h>
> > +#include <linux/module.h>
> > +#include <linux/pm_runtime.h>
> > +#include <media/v4l2-ctrls.h>
> > +#include <media/v4l2-device.h>
> > +
> > +#define DW9714_NAME		"dw9714"
> > +#define DW9714_MAX_FOCUS_POS	1023
> > +#define DW9714_CTRL_STEPS	16	/* Keep this value power of 2
> */
> > +#define DW9714_CTRL_DELAY_US	1000
> > +/*
> > + * S[3:2] = 0x00, codes per step for "Linear Slope Control"
> > + * S[1:0] = 0x00, step period
> > + */
> > +#define DW9714_DEFAULT_S 0x0
> > +#define DW9714_VAL(data, s) (u16)((data) << 4 | (s))
> > +
> > +/* dw9714 device structure */
> > +struct dw9714_device {
> > +	struct i2c_client *client;
> > +	struct v4l2_ctrl_handler ctrls_vcm;
> > +	struct v4l2_subdev sd;
> > +	u16 current_val;
> > +};
> > +
> > +#define to_dw9714_vcm(_ctrl)	\
> > +	container_of(_ctrl->handler, struct dw9714_device, ctrls_vcm)
> > +
> > +static int dw9714_i2c_write(struct i2c_client *client, u16 data) {
> > +	const int num_msg = 1;
> > +	int ret;
> > +	u16 val = cpu_to_be16(data);
> > +	struct i2c_msg msg = {
> > +		.addr = client->addr,
> > +		.flags = 0,
> > +		.len = sizeof(val),
> > +		.buf = (u8 *) &val,
> > +	};
> > +
> > +	ret = i2c_transfer(client->adapter, &msg, num_msg);
> > +
> > +	/*One retry */
> > +	if (ret != num_msg)
> > +		ret = i2c_transfer(client->adapter, &msg, num_msg);
> > +
> > +	if (ret != num_msg) {
> > +		dev_err(&client->dev, "I2C write fail fail\n");
> > +		return -EIO;
> > +	} else {
> > +		return 0;
> > +	}
> > +}
> > +
> > +static int dw9714_t_focus_vcm(struct dw9714_device *dw9714_dev, u16
> > +val) {
> > +	struct i2c_client *client = dw9714_dev->client;
> > +	int ret = -EINVAL;
> > +
> > +	dev_dbg(&client->dev, "Setting new value VCM: %d\n", val);
> > +	dw9714_dev->current_val = val;
> > +
> > +	ret = dw9714_i2c_write(client, DW9714_VAL(val,
> DW9714_DEFAULT_S));
> > +	return ret;
> > +}
> > +
> > +static int dw9714_set_ctrl(struct v4l2_ctrl *ctrl) {
> > +	struct dw9714_device *dev_vcm = to_dw9714_vcm(ctrl);
> > +
> > +	if (ctrl->id == V4L2_CID_FOCUS_ABSOLUTE)
> > +		return dw9714_t_focus_vcm(dev_vcm, ctrl->val);
> > +	else
> > +		return -EINVAL;
> > +}
> > +
> > +static const struct v4l2_ctrl_ops dw9714_vcm_ctrl_ops = {
> > +	.s_ctrl = dw9714_set_ctrl,
> > +};
> > +
> > +static int dw9714_init_controls(struct dw9714_device *dev_vcm) {
> > +	struct v4l2_ctrl_handler *hdl = &dev_vcm->ctrls_vcm;
> > +	const struct v4l2_ctrl_ops *ops = &dw9714_vcm_ctrl_ops;
> > +	struct i2c_client *client = dev_vcm->client;
> > +
> > +	v4l2_ctrl_handler_init(hdl, 1);
> > +
> > +	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_FOCUS_ABSOLUTE,
> > +			  0, DW9714_MAX_FOCUS_POS, 1, 0);
> > +
> > +	if (hdl->error)
> > +		dev_err(&client->dev, "dw9714_init_controls fail\n");
> > +	dev_vcm->sd.ctrl_handler = hdl;
> > +	return hdl->error;
> > +}
> > +
> > +static void dw9714_subdev_cleanup(struct dw9714_device *dw9714_dev) {
> > +	v4l2_ctrl_handler_free(&dw9714_dev->ctrls_vcm);
> 
> Please release the control handler after unregistering the sub-device.

Ack

> 
> > +	v4l2_async_unregister_subdev(&dw9714_dev->sd);
> > +	v4l2_device_unregister_subdev(&dw9714_dev->sd);
> > +	media_entity_cleanup(&dw9714_dev->sd.entity);
> > +}
> > +
> > +static int dw9714_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh
> > +*fh) {
> > +	struct dw9714_device *dw9714_dev = container_of(sd,
> > +							struct
> dw9714_device,
> > +							sd);
> > +	struct device *dev = &dw9714_dev->client->dev;
> > +	int rval;
> > +
> > +	rval = pm_runtime_get_sync(dev);
> 
> If this fails you'll need to do pm_runtime_put(dev);

Ack

> 
> > +	dev_dbg(dev, "%s rval = %d\n", __func__, rval);
> > +
> > +	return rval;
> > +}
> > +
> > +static int dw9714_close(struct v4l2_subdev *sd, struct v4l2_subdev_fh
> > +*fh) {
> > +	struct dw9714_device *dw9714_dev = container_of(sd,
> > +							struct
> dw9714_device,
> > +							sd);
> > +	struct device *dev = &dw9714_dev->client->dev;
> > +
> > +	dev_dbg(dev, "%s\n", __func__);
> > +	pm_runtime_put(dev);
> > +
> > +	return 0;
> > +}
> > +
> > +static const struct v4l2_subdev_internal_ops dw9714_int_ops = {
> > +	.open = dw9714_open,
> > +	.close = dw9714_close,
> > +};
> > +
> > +static const struct v4l2_subdev_ops dw9714_ops = { };
> 
> You should use v4l2_subdev_internal_ops here.
> 

I am not sure I understand what you mean here. Can you please elaborate?

> > +
> > +static int dw9714_probe(struct i2c_client *client,
> > +			const struct i2c_device_id *devid) {
> > +	struct dw9714_device *dw9714_dev;
> > +	int rval;
> > +
> > +	dw9714_dev = devm_kzalloc(&client->dev, sizeof(*dw9714_dev),
> > +				  GFP_KERNEL);
> > +
> > +	if (dw9714_dev == NULL)
> > +		return -ENOMEM;
> > +
> > +	dw9714_dev->client = client;
> > +
> > +	v4l2_i2c_subdev_init(&dw9714_dev->sd, client, &dw9714_ops);
> > +	dw9714_dev->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> > +	dw9714_dev->sd.internal_ops = &dw9714_int_ops;
> > +
> > +	snprintf(dw9714_dev->sd.name,
> > +		 sizeof(dw9714_dev->sd.name),
> > +		 DW9714_NAME " %d-%4.4x", i2c_adapter_id(client-
> >adapter),
> > +		 client->addr);
> > +
> > +	rval = dw9714_init_controls(dw9714_dev);
> > +	if (rval)
> > +		goto err_cleanup;
> > +
> > +	rval = media_entity_pads_init(&dw9714_dev->sd.entity, 0, NULL);
> > +	if (rval < 0)
> > +		goto err_cleanup;
> > +
> > +	dw9714_dev->sd.entity.function = MEDIA_ENT_F_LENS;
> > +
> > +	rval = v4l2_async_register_subdev(&dw9714_dev->sd);
> > +	if (rval < 0)
> > +		goto err_cleanup;
> > +
> > +	pm_runtime_enable(&client->dev);
> 
> Getting PM runtime right doesn't seem to be easy. :-I
> 
> pm_runtime_enable() alone doesn't do the trick. I wonder if adding
> pm_runtime_suspend() would do the trick.
> 

Based on the comments exchanged between you and Tomasz, I believe it is ok if we stop with just pm_runtime_enable().
P.S: Adding pm_runtime_suspend() did not result in dw9714_runtime_suspend() being invoked.

> > +
> > +	return 0;
> > +
> > +err_cleanup:
> > +	dw9714_subdev_cleanup(dw9714_dev);
> > +	dev_err(&client->dev, "Probe failed: %d\n", rval);
> > +	return rval;
> > +}
> > +
> > +static int dw9714_remove(struct i2c_client *client) {
> > +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> > +	struct dw9714_device *dw9714_dev = container_of(sd,
> > +							struct
> dw9714_device,
> > +							sd);
> > +
> > +	pm_runtime_disable(&client->dev);
> > +	dw9714_subdev_cleanup(dw9714_dev);
> > +
> > +	return 0;
> > +}
> > +
> > +#ifdef CONFIG_PM
> > +
> > +static int dw9714_runtime_suspend(struct device *dev) {
> > +	return 0;
> > +}
> > +
> > +static int dw9714_runtime_resume(struct device *dev) {
> > +	return 0;
> 
> I think it'd be fine to remove empty callbacks.

Given that we need to do whatever that's done in dw9714_suspend/resume functions in dw9714_runtime_suspend/resume, these functions are not going to be empty callbacks.
> 
> > +}
> > +
> > +/* This function sets the vcm position, so it consumes least current
> > +*/ static int dw9714_suspend(struct device *dev) {
> > +	struct i2c_client *client = to_i2c_client(dev);
> > +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> > +	struct dw9714_device *dw9714_dev = container_of(sd,
> > +							struct
> dw9714_device,
> > +							sd);
> > +	int ret, val;
> > +
> > +	dev_dbg(dev, "%s\n", __func__);
> > +
> > +	for (val = dw9714_dev->current_val & ~(DW9714_CTRL_STEPS - 1);
> > +	     val >= 0; val -= DW9714_CTRL_STEPS) {
> > +		ret = dw9714_i2c_write(client,
> > +				       DW9714_VAL((u16) val,
> DW9714_DEFAULT_S));
> > +		if (ret)
> > +			dev_err(dev, "%s I2C failure: %d", __func__, ret);
> > +		usleep_range(DW9714_CTRL_DELAY_US,
> DW9714_CTRL_DELAY_US + 10);
> > +	}
> > +	return 0;
> > +}
> > +
> > +/*
> > + * This function sets the vcm position, so the focus position is set
> > + * closer to the camera
> > + */
> > +static int dw9714_resume(struct device *dev) {
> > +	struct i2c_client *client = to_i2c_client(dev);
> > +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> > +	struct dw9714_device *dw9714_dev = container_of(sd,
> > +							struct
> dw9714_device,
> > +							sd);
> > +	int ret, val;
> > +
> > +	dev_dbg(dev, "%s\n", __func__);
> > +
> > +	for (val = dw9714_dev->current_val % DW9714_CTRL_STEPS;
> > +	     val < dw9714_dev->current_val + DW9714_CTRL_STEPS - 1;
> > +	     val += DW9714_CTRL_STEPS) {
> > +		ret = dw9714_i2c_write(client,
> > +				       DW9714_VAL((u16) val,
> DW9714_DEFAULT_S));
> > +		if (ret)
> > +			dev_err(dev, "%s I2C failure: %d", __func__, ret);
> > +		usleep_range(DW9714_CTRL_DELAY_US,
> DW9714_CTRL_DELAY_US + 10);
> > +	}
> > +
> > +	/* restore v4l2 control values */
> > +	ret = v4l2_ctrl_handler_setup(&dw9714_dev->ctrls_vcm);
> 
> Doesn't this need to be done for runtime_resume as well?

Ack.
I will add dw9714_vcm_suspend/resume functions and invoke them from dw9714_suspend/resume and dw9714_runtime_suspend/resume functions

> 
> > +	dev_dbg(dev, "%s ret = %d\n", __func__, ret);
> > +	return ret;
> > +}
> > +
> > +#else
> > +
> > +#define dw9714_suspend	NULL
> > +#define dw9714_resume	NULL
> > +#define dw9714_runtime_suspend	NULL
> > +#define dw9714_runtime_resume	NULL
> > +
> > +#endif /* CONFIG_PM */
> > +
> > +#ifdef CONFIG_ACPI
> > +static const struct acpi_device_id dw9714_acpi_match[] = {
> > +	{"DW9714", 0},
> > +	{},
> > +};
> > +MODULE_DEVICE_TABLE(acpi, dw9714_acpi_match); #endif
> > +
> > +static const struct i2c_device_id dw9714_id_table[] = {
> > +	{DW9714_NAME, 0},
> > +	{}
> > +};
> > +
> > +MODULE_DEVICE_TABLE(i2c, dw9714_id_table);
> > +
> > +static const struct dev_pm_ops dw9714_pm_ops = {
> > +	.suspend = dw9714_suspend,
> > +	.resume = dw9714_resume,
> > +	.runtime_suspend = dw9714_runtime_suspend,
> > +	.runtime_resume = dw9714_runtime_resume, };
> > +
> > +static struct i2c_driver dw9714_i2c_driver = {
> > +	.driver = {
> > +		.name = DW9714_NAME,
> > +		.pm = &dw9714_pm_ops,
> > +#ifdef CONFIG_ACPI
> > +		.acpi_match_table = ACPI_PTR(dw9714_acpi_match), #endif
> > +	},
> > +	.probe = dw9714_probe,
> > +	.remove = dw9714_remove,
> > +	.id_table = dw9714_id_table,
> > +};
> > +
> > +module_i2c_driver(dw9714_i2c_driver);
> > +
> > +MODULE_AUTHOR("Tianshu Qiu <tian.shu.qiu@intel.com>");
> > +MODULE_AUTHOR("Jian Xu Zheng <jian.xu.zheng@intel.com>");
> > +MODULE_AUTHOR("Yuning Pu <yuning.pu@intel.com>");
> > +MODULE_AUTHOR("Jouni Ukkonen <jouni.ukkonen@intel.com>");
> > +MODULE_AUTHOR("Tommi Franttila <tommi.franttila@intel.com>");
> > +MODULE_DESCRIPTION("DW9714 VCM driver"); MODULE_LICENSE("GPL");
> 
> --
> Regards,
> 
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
