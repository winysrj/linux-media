Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:47181 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753342AbdFMO31 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Jun 2017 10:29:27 -0400
From: "Yang, Hyungwoo" <hyungwoo.yang@intel.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "Hsu, Cedric" <cedric.hsu@intel.com>
Subject: RE: [PATCH v10 1/1] [media] i2c: add support for OV13858 sensor
Date: Tue, 13 Jun 2017 14:29:25 +0000
Message-ID: <7A4F467111FEF64486F40DFE7DF3500A03EBA69F@ORSMSX111.amr.corp.intel.com>
References: <1497315360-29216-1-git-send-email-hyungwoo.yang@intel.com>
 <1497315360-29216-2-git-send-email-hyungwoo.yang@intel.com>
 <20170613101745.GC12407@valkosipuli.retiisi.org.uk>
In-Reply-To: <20170613101745.GC12407@valkosipuli.retiisi.org.uk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Here is the _DSD for 19.2Mhz





i've inlined my comments.



-----Original Message-----
> From: Sakari Ailus [mailto:sakari.ailus@iki.fi] 
> Sent: Tuesday, June 13, 2017 3:18 AM
> To: Yang, Hyungwoo <hyungwoo.yang@intel.com>
> Cc: linux-media@vger.kernel.org; sakari.ailus@linux.intel.com; Zheng, Jian Xu <jian.xu.zheng@intel.com>; tfiga@chromium.org; Hsu, Cedric <cedric.hsu@intel.com>
> Subject: Re: [PATCH v10 1/1] [media] i2c: add support for OV13858 sensor
> 
> Hi Hyungwoo,
> 
> On Mon, Jun 12, 2017 at 05:56:00PM -0700, Hyungwoo Yang wrote:
> > This patch adds driver for Omnivision's ov13858 sensor, the driver 
> > supports following features:
> > 
> > - manual exposure/gain(analog and digital) control support
> > - two link frequencies
> > - VBLANK/HBLANK support
> > - test pattern support
> > - media controller support
> > - runtime pm support
> > - supported resolutions
> >   + 4224x3136 at 30FPS
> >   + 2112x1568 at 30FPS(default) and 60FPS
> >   + 2112x1188 at 30FPS(default) and 60FPS
> >   + 1056x784 at 30FPS(default) and 60FPS
> > 
> > Signed-off-by: Hyungwoo Yang <hyungwoo.yang@intel.com>
> > ---
> >  drivers/media/i2c/Kconfig   |    8 +
> >  drivers/media/i2c/Makefile  |    1 +
> >  drivers/media/i2c/ov13858.c | 1920 
> > +++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 1929 insertions(+)
> >  create mode 100644 drivers/media/i2c/ov13858.c
> > 
> > diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig 
> > index c380e24..26a9a3c 100644
> > --- a/drivers/media/i2c/Kconfig
> > +++ b/drivers/media/i2c/Kconfig
> > @@ -600,6 +600,14 @@ config VIDEO_OV9650
> >  	  This is a V4L2 sensor-level driver for the Omnivision
> >  	  OV9650 and OV9652 camera sensors.
> >  
> > +config VIDEO_OV13858
> > +	tristate "OmniVision OV13858 sensor support"
> > +	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
> > +	depends on MEDIA_CAMERA_SUPPORT
> 
> select V4L2_FWNODE
> 
> > +	---help---
> > +	  This is a Video4Linux2 sensor-level driver for the OmniVision
> > +	  OV13858 camera.
> > +
> >  config VIDEO_VS6624
> >  	tristate "ST VS6624 sensor support"
> >  	depends on VIDEO_V4L2 && I2C
> > diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile 
> > index 62323ec..3f4dc02 100644
> > --- a/drivers/media/i2c/Makefile
> > +++ b/drivers/media/i2c/Makefile
> > @@ -63,6 +63,7 @@ obj-$(CONFIG_VIDEO_OV5647) += ov5647.o
> >  obj-$(CONFIG_VIDEO_OV7640) += ov7640.o
> >  obj-$(CONFIG_VIDEO_OV7670) += ov7670.o
> >  obj-$(CONFIG_VIDEO_OV9650) += ov9650.o
> > +obj-$(CONFIG_VIDEO_OV13858) += ov13858.o
> >  obj-$(CONFIG_VIDEO_MT9M032) += mt9m032.o
> >  obj-$(CONFIG_VIDEO_MT9M111) += mt9m111.o
> >  obj-$(CONFIG_VIDEO_MT9P031) += mt9p031.o diff --git 
> > a/drivers/media/i2c/ov13858.c b/drivers/media/i2c/ov13858.c new file 
> > mode 100644 index 0000000..0334cee
> > --- /dev/null
> > +++ b/drivers/media/i2c/ov13858.c
> 
> ...
> 
> > +static int ov13858_read_platform_data(struct device *dev,
> > +				      struct ov13858 *ov13858)
> > +{
> > +	struct fwnode_handle *child, *fwn_freq;
> > +	struct ov13858_link_freq_config *freq_cfg;
> > +	struct ov13858_reg *pll_regs;
> > +	int i, freq_id = 0, ret, num_of_values, num_of_pairs;
> > +	u32 val, *val_array;
> > +
> > +	/* For now, platform data is only available from fwnode */
> > +	if (!dev_fwnode(dev)) {
> > +		dev_err(dev, "no platform data\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	ret = device_property_read_u32(dev, "skip-frames", &val);
> 
> This is a property of the sensor (or its configuration), not the hardware platform. Please use a constant if the value does not depend on configuration.
> 
> > +	if (ret)
> > +		return ret;
> > +	ov13858->num_of_skip_frames = val;
> > +
> > +	device_for_each_child_node(dev, child) {
> > +		if (!fwnode_property_present(child, "link"))
> > +			continue;
> 
> You shouldn't need these here.
> 

?? just get child and see if the expected property is found ?
Acked

> > +
> > +		/* Limited number of link frequencies are allowed */
> > +		if (freq_id == OV13858_NUM_OF_LINK_FREQS) {
> > +			dev_err(dev, "no more than two freqs\n");
> > +			ret = -EINVAL;
> > +			goto error;
> > +		}
> > +
> > +		fwn_freq = fwnode_get_next_child_node(child, NULL);
> > +		if (!fwn_freq) {
> > +			ret = -EINVAL;
> > +			goto error;
> > +		}
> > +
> > +		/* Get link freq menu item for LINK_FREQ control */
> > +		ret = fwnode_property_read_u32(fwn_freq, "link-rate", &val);
> 
> If you need to know the valid link frequencies (among other things), please use v4l2_fwnode_endpoint_alloc_parse() instead. It parses the firmware tables for you.
> 

Acked.

> > +		if (ret) {
> > +			dev_err(dev, "link-rate error : %d\n",  ret);
> > +			goto error;
> > +		}
> > +		link_freq_menu_items[freq_id] = val;
> > +
> > +		freq_cfg = &link_freq_configs[freq_id];
> > +		ret = fwnode_property_read_u32(fwn_freq, "pixel-rate", &val);
> 
> This is something a sensor driver needs to know. It may not be present in device firmware.
> 

Real frequency of the link can be different from input clock frequency so pixel reate which is dependent on link frequency should be here.

> > +		if (ret) {
> > +			dev_err(dev, "pixel-rate error : %d\n",  ret);
> > +			goto error;
> > +		}
> > +		freq_cfg->pixel_rate = val;
> > +
> > +		num_of_values = fwnode_property_read_u32_array(fwn_freq,
> > +							       "pll-regs",
> 
> This is something that could go to device firmware but I don't really see a reason for that at the moment. Can this continue to be a part of the driver for now?
> 
> Could you also check that the external clock frequency matches with what your register lists assume? The property should be called "clock-frequency"
> and it's a u32.

Are you saying, for now, let's remove pll reg/value pairs from _DSD  and just support only one input clock frequency ?

> 
> > +							       NULL, 0);
> > +		if (num_of_values <= 0 || num_of_values & 0x01) {
> > +			dev_err(dev, "invalid pll-regs\n");
> > +			ret = -EINVAL;
> > +			goto error;
> > +		}
> > +
> > +		/* Get num of addr-value pairs */
> > +		num_of_pairs = num_of_values / 2;
> > +		val_array = devm_kzalloc(dev,
> > +					 sizeof(u32) * num_of_values,
> > +					 GFP_KERNEL);
> > +		if (!val_array) {
> > +			ret = -ENOMEM;
> > +			goto error;
> > +		}
> > +
> > +		pll_regs = devm_kzalloc(dev,
> > +					sizeof(*pll_regs) * num_of_pairs,
> > +					GFP_KERNEL);
> > +		if (!pll_regs) {
> > +			ret = -ENOMEM;
> > +			goto error;
> > +		}
> > +
> > +		fwnode_property_read_u32_array(fwn_freq, "pll-regs",
> > +					       val_array, num_of_values);
> > +		for (i = 0; i < num_of_pairs; i++) {
> > +			pll_regs[i].address = val_array[i * 2];
> > +			pll_regs[i].val = val_array[i * 2 + 1];
> > +		}
> > +
> > +		devm_kfree(dev, val_array);
> > +
> > +		freq_cfg->reg_list.num_of_regs = num_of_pairs;
> > +		freq_cfg->reg_list.regs = pll_regs;
> > +
> > +		freq_id++;
> > +	}
> > +
> > +	if (freq_id != OV13858_NUM_OF_LINK_FREQS)
> > +		return -EINVAL;
> > +
> > +	return 0;
> > +
> > +error:
> > +	fwnode_handle_put(child);
> > +	return ret;
> > +}
> > +
> > +static int ov13858_probe(struct i2c_client *client,
> > +			 const struct i2c_device_id *devid) {
> > +	struct ov13858 *ov13858;
> > +	int ret;
> > +
> > +	ov13858 = devm_kzalloc(&client->dev, sizeof(*ov13858), GFP_KERNEL);
> > +	if (!ov13858)
> > +		return -ENOMEM;
> > +
> > +	ret = ov13858_read_platform_data(&client->dev, ov13858);
> > +	if (ret)
> > +		return ret;
> > +
> > +	/* Initialize subdev */
> > +	v4l2_i2c_subdev_init(&ov13858->sd, client, &ov13858_subdev_ops);
> > +
> > +	/* Check module identity */
> > +	ret = ov13858_identify_module(ov13858);
> > +	if (ret) {
> > +		dev_err(&client->dev, "failed to find sensor: %d\n", ret);
> > +		return ret;
> > +	}
> > +
> > +	/* Set default mode to max resolution */
> > +	ov13858->cur_mode = &supported_modes[0];
> > +
> > +	ret = ov13858_init_controls(ov13858);
> > +	if (ret)
> > +		return ret;
> > +
> > +	/* Initialize subdev */
> > +	ov13858->sd.internal_ops = &ov13858_internal_ops;
> > +	ov13858->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> > +	ov13858->sd.entity.ops = &ov13858_subdev_entity_ops;
> > +	ov13858->sd.entity.function = MEDIA_ENT_F_CAM_SENSOR;
> > +
> > +	/* Initialize source pad */
> > +	ov13858->pad.flags = MEDIA_PAD_FL_SOURCE;
> > +	ret = media_entity_pads_init(&ov13858->sd.entity, 1, &ov13858->pad);
> > +	if (ret) {
> > +		dev_err(&client->dev, "%s failed:%d\n", __func__, ret);
> > +		goto error_handler_free;
> > +	}
> > +
> > +	ret = v4l2_async_register_subdev(&ov13858->sd);
> > +	if (ret < 0)
> > +		goto error_media_entity;
> > +
> > +	/*
> > +	 * Device is already turned on by i2c-core with ACPI domain PM.
> > +	 * Enable runtime PM and turn off the device.
> > +	 */
> > +	pm_runtime_get_noresume(&client->dev);
> > +	pm_runtime_set_active(&client->dev);
> > +	pm_runtime_enable(&client->dev);
> > +	pm_runtime_put(&client->dev);
> > +
> > +	return 0;
> > +
> > +error_media_entity:
> > +	media_entity_cleanup(&ov13858->sd.entity);
> > +
> > +error_handler_free:
> > +	ov13858_free_controls(ov13858);
> > +	dev_err(&client->dev, "%s failed:%d\n", __func__, ret);
> > +
> > +	return ret;
> > +}
> > +
> > +static int ov13858_remove(struct i2c_client *client) {
> > +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> > +	struct ov13858 *ov13858 = to_ov13858(sd);
> > +
> > +	v4l2_async_unregister_subdev(sd);
> > +	media_entity_cleanup(&sd->entity);
> > +	ov13858_free_controls(ov13858);
> > +
> > +	/*
> > +	 * Disable runtime PM but keep the device turned on.
> > +	 * i2c-core with ACPI domain PM will turn off the device.
> > +	 */
> > +	pm_runtime_get_sync(&client->dev);
> > +	pm_runtime_disable(&client->dev);
> > +	pm_runtime_set_suspended(&client->dev);
> > +	pm_runtime_put_noidle(&client->dev);
> > +
> > +	return 0;
> > +}
> > +
> > +static const struct i2c_device_id ov13858_id_table[] = {
> > +	{"ov13858", 0},
> > +	{},
> > +};
> > +
> > +MODULE_DEVICE_TABLE(i2c, ov13858_id_table);
> > +
> > +static const struct dev_pm_ops ov13858_pm_ops = {
> > +	SET_SYSTEM_SLEEP_PM_OPS(ov13858_suspend, ov13858_resume) };
> > +
> > +#ifdef CONFIG_ACPI
> > +static const struct acpi_device_id ov13858_acpi_ids[] = {
> > +	{"OVTID858"},
> > +	{ /* sentinel */ }
> > +};
> > +
> > +MODULE_DEVICE_TABLE(acpi, ov13858_acpi_ids); #endif
> > +
> > +static struct i2c_driver ov13858_i2c_driver = {
> > +	.driver = {
> > +		.name = "ov13858",
> > +		.owner = THIS_MODULE,
> > +		.pm = &ov13858_pm_ops,
> > +		.acpi_match_table = ACPI_PTR(ov13858_acpi_ids),
> > +	},
> > +	.probe = ov13858_probe,
> > +	.remove = ov13858_remove,
> > +	.id_table = ov13858_id_table,
> > +};
> > +
> > +module_i2c_driver(ov13858_i2c_driver);
> > +
> > +MODULE_AUTHOR("Kan, Chris <chris.kan@intel.com>"); 
> > +MODULE_AUTHOR("Rapolu, Chiranjeevi <chiranjeevi.rapolu@intel.com>"); 
> > +MODULE_AUTHOR("Yang, Hyungwoo <hyungwoo.yang@intel.com>"); 
> > +MODULE_DESCRIPTION("Omnivision ov13858 sensor driver"); 
> > +MODULE_LICENSE("GPL v2");
> 
> --
> Regards,
> 
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
>
