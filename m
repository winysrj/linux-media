Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:27495 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578Ab2AGXB4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Jan 2012 18:01:56 -0500
Message-ID: <4F08CEDE.7030105@maxwell.research.nokia.com>
Date: Sun, 08 Jan 2012 01:01:50 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <snjw23@gmail.com>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	dacohen@gmail.com
Subject: Re: [RFC 16/17] smiapp: Add driver.
References: <4EF0EFC9.6080501@maxwell.research.nokia.com> <1324412889-17961-16-git-send-email-sakari.ailus@maxwell.research.nokia.com> <4F072B6C.9060808@gmail.com>
In-Reply-To: <4F072B6C.9060808@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Thanks for the review!!!

Sylwester Nawrocki wrote:
> Hi Sakari,
> 
> I have a just a few comments below. It was rather brief a review, given the
> size of the patch.. :-)

Good points. I'll make the changes, as well as those Laurent pointed
out, and send a new version of the driver. I expect I'll be able to do
that early next week.

> On 12/20/2011 09:28 PM, Sakari Ailus wrote:
>> Add driver for SMIA++/SMIA image sensors. The driver exposes the sensor as
>> three subdevs, pixel array, binner and scaler --- in case the device has a
>> scaler.
>>
>> Currently it relies on the board code for external clock handling. There is
>> no fast way out of this dependency before the ISP drivers (omap3isp) among
>> others will be able to export that clock through the clock framework
>> instead.
>>
>> Signed-off-by: Sakari Ailus<sakari.ailus@maxwell.research.nokia.com>
>> ---
>>   drivers/media/video/Kconfig           |   13 +
>>   drivers/media/video/Makefile          |    3 +
>>   drivers/media/video/smiapp-core.c     | 2595 +++++++++++++++++++++++++++++++++
>>   drivers/media/video/smiapp-debug.h    |   32 +
>>   drivers/media/video/smiapp-limits.c   |  132 ++
>>   drivers/media/video/smiapp-limits.h   |  128 ++
>>   drivers/media/video/smiapp-pll.c      |  664 +++++++++
>>   drivers/media/video/smiapp-quirk.c    |  264 ++++
>>   drivers/media/video/smiapp-quirk.h    |   72 +
>>   drivers/media/video/smiapp-reg-defs.h |  733 ++++++++++
>>   drivers/media/video/smiapp-reg.h      |  119 ++
>>   drivers/media/video/smiapp-regs.c     |  222 +++
>>   drivers/media/video/smiapp.h          |  250 ++++
>>   include/media/smiapp-regs.h           |   51 +
>>   include/media/smiapp.h                |   82 +
>>   15 files changed, 5360 insertions(+), 0 deletions(-)
>>   create mode 100644 drivers/media/video/smiapp-core.c
>>   create mode 100644 drivers/media/video/smiapp-debug.h
>>   create mode 100644 drivers/media/video/smiapp-limits.c
>>   create mode 100644 drivers/media/video/smiapp-limits.h
>>   create mode 100644 drivers/media/video/smiapp-pll.c
>>   create mode 100644 drivers/media/video/smiapp-quirk.c
>>   create mode 100644 drivers/media/video/smiapp-quirk.h
>>   create mode 100644 drivers/media/video/smiapp-reg-defs.h
>>   create mode 100644 drivers/media/video/smiapp-reg.h
>>   create mode 100644 drivers/media/video/smiapp-regs.c
>>   create mode 100644 drivers/media/video/smiapp.h
> 
> How about creating new directory, e.g. drivers/media/video/smiapp/ ? 

Good question. When I started working on this, I just had a few files
which didn't justify creating a new directory. I think you're right; now
it's time for that.

>>   create mode 100644 include/media/smiapp-regs.h
>>   create mode 100644 include/media/smiapp.h
>>
>> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
>> index 4e8a0c4..0aa8f13 100644
>> --- a/drivers/media/video/Kconfig
>> +++ b/drivers/media/video/Kconfig
>> @@ -524,6 +524,19 @@ config VIDEO_S5K6AA
>>   	  This is a V4L2 sensor-level driver for Samsung S5K6AA(FX) 1.3M
>>   	  camera sensor with an embedded SoC image signal processor.
>>
>> +config VIDEO_SMIAPP
>> +	tristate "SMIA++/SMIA sensor support"
>> +	depends on I2C&&  VIDEO_V4L2
> 
> There is no dependency on VIDEO_V4L2_SUBDEV_API ?

Yes, there is.

>> +	---help---
>> +	  This is a generic driver for SMIA++/SMIA camera modules.
>> +
>> +config VIDEO_SMIAPP_DEBUG
>> +	bool "Enable debugging for the generic SMIA++/SMIA driver"
>> +	depends on VIDEO_SMIAPP
>> +	---help---
>> +	  Enable debugging output in the generic SMIA++/SMIA driver. If you
>> +	  are developing the driver you might want to enable this.
>> +
>>   comment "Flash devices"
>>
>>   config VIDEO_ADP1653
>> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
>> index ddeaa6c..82a0cea 100644
>> --- a/drivers/media/video/Makefile
>> +++ b/drivers/media/video/Makefile
>> @@ -73,6 +73,9 @@ obj-$(CONFIG_VIDEO_SR030PC30)	+= sr030pc30.o
>>   obj-$(CONFIG_VIDEO_NOON010PC30)	+= noon010pc30.o
>>   obj-$(CONFIG_VIDEO_M5MOLS)	+= m5mols/
>>   obj-$(CONFIG_VIDEO_S5K6AA)	+= s5k6aa.o
>> +smiapp-objs			+= smiapp-core.o smiapp-regs.o smiapp-pll.o \
>> +				   smiapp-quirk.o smiapp-limits.o
>> +obj-$(CONFIG_VIDEO_SMIAPP)	+= smiapp.o
>>   obj-$(CONFIG_VIDEO_ADP1653)	+= adp1653.o
>>
>>   obj-$(CONFIG_SOC_CAMERA_IMX074)		+= imx074.o
>> diff --git a/drivers/media/video/smiapp-core.c b/drivers/media/video/smiapp-core.c
>> new file mode 100644
>> index 0000000..1d15c1d
>> --- /dev/null
>> +++ b/drivers/media/video/smiapp-core.c
>> @@ -0,0 +1,2595 @@
>> +/*
>> + * drivers/media/video/smiapp-core.c
>> + *
>> + * Generic driver for SMIA/SMIA++ compliant camera modules
>> + *
>> + * Copyright (C) 2010--2011 Nokia Corporation
>> + * Contact: Sakari Ailus<sakari.ailus@maxwell.research.nokia.com>
>> + *
>> + * Based on smiapp driver by Vimarsh Zutshi
>> + * Based on jt8ev1.c by Vimarsh Zutshi
>> + * Based on smia-sensor.c by Tuukka Toivonen<tuukkat76@gmail.com>
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License
>> + * version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful, but
>> + * WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>> + * General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program; if not, write to the Free Software
>> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
>> + * 02110-1301 USA
>> + *
>> + */
>> +
>> +#include "smiapp-debug.h"
>> +
>> +#include<linux/delay.h>
>> +#include<linux/device.h>
>> +#include<linux/module.h>
>> +#include<linux/regulator/consumer.h>
>> +#include<linux/v4l2-mediabus.h>
>> +#include<media/v4l2-device.h>
>> +
>> +#include "smiapp.h"
>> +
>> +#define SMIAPP_ALIGN_DIM(dim, flags)	      \
>> +	(flags&  V4L2_SUBDEV_SEL_FLAG_SIZE_GE \
>> +	 ? ALIGN(dim, 2)		      \
>> +	 : dim&  ~1)
>> +
>> +/*
>> + * smiapp_module_idents - supported camera modules
>> + */
>> +static const struct smiapp_module_ident smiapp_module_idents[] = {
>> +	SMIAPP_IDENT_LQ(0x10, 0x4141, -1, "jt8ev1",&smiapp_jt8ev1_quirk),
>> +	SMIAPP_IDENT_LQ(0x10, 0x4241, -1, "imx125es",&smiapp_imx125es_quirk),
>> +	SMIAPP_IDENT_L(0x01, 0x022b, -1, "vs6555"),
>> +	SMIAPP_IDENT_L(0x0c, 0x208a, -1, "tcm8330md"),
>> +	SMIAPP_IDENT_L(0x01, 0x022e, -1, "vw6558"),
>> +	SMIAPP_IDENT_LQ(0x0c, 0x2134, -1, "tcm8500md",&smiapp_tcm8500md_quirk),
>> +	SMIAPP_IDENT_L(0x07, 0x7698, -1, "ovm7698"),
>> +	SMIAPP_IDENT_L(0x0b, 0x4242, -1, "smiapp-003"),
>> +	SMIAPP_IDENT_LQ(0x0c, 0x560f, -1, "jt8ew9",&smiapp_jt8ew9_quirk),
>> +	SMIAPP_IDENT_L(0x0c, 0x213e, -1, "et8en2"),
>> +	SMIAPP_IDENT_L(0x0c, 0x2184, -1, "tcm8580md"),
>> +};
>> +
>> +/*
>> + *
>> + * Dynamic Capability Identification
>> + *
>> + */
>> +
> [...]
>> +/*
>> + *
>> + * V4L2 Controls handling
>> + *
>> + */
>> +
>> +static void __smiapp_update_exposure_limits(struct smiapp_sensor *sensor)
>> +{
>> +	struct v4l2_ctrl *ctrl = sensor->exposure;
>> +	int max;
>> +
>> +	max = sensor->pixel_array->compose[SMIAPP_PAD_SOURCE].height
>> +		+ sensor->vblank->val -
>> +		sensor->limits[SMIAPP_LIMIT_COARSE_INTEGRATION_TIME_MAX_MARGIN];
>> +
>> +	ctrl->maximum = max;
>> +	if (ctrl->default_value>  max)
>> +		ctrl->default_value = max;
>> +	if (ctrl->val>  max)
>> +		ctrl->val = max;
>> +	if (ctrl->cur.val>  max)
>> +		ctrl->cur.val = max;
>> +}
> 
> One more driver that needs control value range update. :)

:-)

Are there other drivers that would need something like that, too?
Anything in the control framework that I have missed related to this?

>> +
> [...]
>> +
>> +#define SCALING_GOODNESS		100000
>> +#define SCALING_GOODNESS_EXTREME	100000000
> 
> Interesting parameter.. :)
> 
>> +static int scaling_goodness(struct v4l2_subdev *subdev, int w, int ask_w,
>> +			    int h, int ask_h, u32 flags)
>> +{
>> +	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
>> +	struct i2c_client *client = v4l2_get_subdevdata(subdev);
>> +	int val = 0;
>> +
>> +	w&= ~1;
>> +	ask_w&= ~1;
>> +	h&= ~1;
>> +	ask_h&= ~1;
>> +
>> +	if (flags&  V4L2_SUBDEV_SEL_FLAG_SIZE_GE) {
>> +		if (w<  ask_w)
>> +			val -= SCALING_GOODNESS;
>> +		if (h<  ask_h)
>> +			val -= SCALING_GOODNESS;
>> +	}
>> +
>> +	if (flags&  V4L2_SUBDEV_SEL_FLAG_SIZE_LE) {
>> +		if (w>  ask_w)
>> +			val -= SCALING_GOODNESS;
>> +		if (h>  ask_h)
>> +			val -= SCALING_GOODNESS;
>> +	}
>> +
>> +	val -= abs(w - ask_w);
>> +	val -= abs(h - ask_h);
>> +
>> +	if (w<  sensor->limits[SMIAPP_LIMIT_MIN_X_OUTPUT_SIZE])
>> +		val -= SCALING_GOODNESS_EXTREME;
>> +
>> +	dev_dbg(&client->dev, "w %d ask_w %d h %d ask_h %d goodness %d\n",
>> +		w, ask_h, h, ask_h, val);
>> +
>> +	return val;
>> +}
>> +
> [...]
>> +static int smiapp_set_selection(struct v4l2_subdev *subdev,
>> +				struct v4l2_subdev_fh *fh,
>> +				struct v4l2_subdev_selection *sel)
>> +{
>> +	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
>> +	struct smiapp_subdev *ssd = to_smiapp_subdev(subdev);
>> +	struct v4l2_rect *comps, *crops;
>> +	int ret;
>> +
>> +	ret = __smiapp_sel_supported(subdev, sel);
>> +	if (ret)
>> +		return ret;
>> +
>> +	sel->r.left = sel->r.left&  ~1;
>> +	sel->r.top = sel->r.top&  ~1;
>> +	sel->r.width = SMIAPP_ALIGN_DIM(sel->r.width, sel->flags);
>> +	sel->r.height = SMIAPP_ALIGN_DIM(sel->r.height, sel->flags);
>> +
>> +	if (sel->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
>> +		crops = ssd->crop;
>> +		comps = ssd->compose;
>> +	} else {
>> +		crops = fh->try_crop;
>> +		comps = fh->try_compose;
>> +	}
>> +
>> +	sel->r.left&= ~1;
>> +	sel->r.top&= ~1;
>> +	sel->r.width&= ~1;
>> +	sel->r.height&= ~1;
>> +
>> +	sel->r.left = max(0, sel->r.left);
>> +	sel->r.top = max(0, sel->r.top);
>> +	sel->r.width = max(0, sel->r.width);
>> +	sel->r.height = max(0, sel->r.height);
>> +
>> +	sel->r.width = max_t(unsigned int,
>> +			     sensor->limits[SMIAPP_LIMIT_MIN_X_OUTPUT_SIZE],
>> +			     sel->r.width);
>> +	sel->r.height = max_t(unsigned int,
>> +			      sensor->limits[SMIAPP_LIMIT_MIN_Y_OUTPUT_SIZE],
>> +			      sel->r.height);
>> +
>> +	switch (sel->target) {
>> +	case V4L2_SUBDEV_SEL_TGT_CROP_ACTIVE:
>> +		return smiapp_set_crop(subdev, fh, sel);
>> +	case V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTIVE:
>> +		return smiapp_set_compose(subdev, fh, sel);
>> +	}
>> +
>> +	BUG();
>> +}
>> +
>> +static int smiapp_validate_pipeline(struct v4l2_subdev *subdev)
>> +{
>> +	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
>> +	struct smiapp_subdev *ssds[] = {
>> +		sensor->scaler, sensor->binner, sensor->pixel_array };
>> +	int i;
>> +	struct smiapp_subdev *last = NULL;
>> +
>> +	if (sensor->src->crop[SMIAPP_PAD_SOURCE].width
>> +	<  sensor->limits[SMIAPP_LIMIT_MIN_X_OUTPUT_SIZE])
>> +		return -EPIPE;
>> +	if (sensor->src->crop[SMIAPP_PAD_SOURCE].height
>> +	<  sensor->limits[SMIAPP_LIMIT_MIN_Y_OUTPUT_SIZE])
>> +		return -EPIPE;
>> +
>> +	for (i = 0; i<  SMIAPP_SUBDEVS; i++) {
>> +		struct smiapp_subdev *this = ssds[i];
>> +
>> +		if (!this)
>> +			continue;
>> +
>> +		if (!last) {
>> +			last = this;
>> +			continue;
>> +		}
>> +
>> +		if (last->sink_fmt.width
>> +		    != this->compose[SMIAPP_PAD_SOURCE].width)
>> +			return -EPIPE;
>> +		if (last->sink_fmt.height
>> +		    != this->compose[SMIAPP_PAD_SOURCE].height)
>> +			return -EPIPE;
>> +
>> +		last = this;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
> [...]
>> +
>> +static int __init smiapp_init(void)
>> +{
>> +	int rval;
>> +
>> +	rval = i2c_add_driver(&smiapp_i2c_driver);
>> +	if (rval)
>> +		printk(KERN_ERR "Failed registering driver" SMIAPP_NAME "\n");
> 
> Using pr_<level> is expected for new drivers.

Fixed.

>> +
>> +	return rval;
>> +}
>> +
>> +static void __exit smiapp_exit(void)
>> +{
>> +	i2c_del_driver(&smiapp_i2c_driver);
>> +}
>> +
>> +module_init(smiapp_init);
>> +module_exit(smiapp_exit);
>> +
>> +MODULE_AUTHOR("Sakari Ailus<sakari.ailus@maxwell.research.nokia.com>");
>> +MODULE_DESCRIPTION("Generic SMIA/SMIA++ camera module driver");
>> +MODULE_LICENSE("GPL");
> 
> [...]
>> +/*
>> + * Write to a 8/16-bit register.
>> + * Returns zero if successful, or non-zero otherwise.
>> + */
>> +int smia_i2c_write_reg(struct i2c_client *client, u32 reg, u32 val)
>> +{
>> +	struct i2c_msg msg[1];
>> +	unsigned char data[6];
>> +	unsigned int retries = 5;
>> +	unsigned int flags = reg>>  24;
>> +	unsigned int len = (u8)(reg>>  16);
>> +	u16 offset = reg;
>> +	int r;
>> +
>> +	if (!client->adapter)
>> +		return -ENODEV;
>> +
>> +	if ((len != SMIA_REG_8BIT&&  len != SMIA_REG_16BIT&&
>> +	     len != SMIA_REG_32BIT) || flags)
>> +		return -EINVAL;
>> +
>> +	smia_i2c_create_msg(client, len, offset, val, msg, data);
>> +
>> +	do {
>> +		/*
>> +		 * Due to unknown reason sensor stops responding. This
>> +		 * loop is a temporaty solution until the root cause
>> +		 * is found.
>> +		 */
>> +		r = i2c_transfer(client->adapter, msg, 1);
>> +		if (r>= 0)
>> +			break;
> 
> I think r == 0 indicates failure (0 messages transferred), it's probably
> never returned in that case though. It might be better to test for r == 1.

Fixed. By doing so one must make sure that when an error is encountered,
a negative error code will be returned.

>> +
>> +		usleep_range(2000, 2000);
>> +	} while (retries--);
>> +
>> +	if (r<  0)
>> +		dev_err(&client->dev,
>> +			"wrote 0x%x to offset 0x%x error %d\n", val, offset, r);
>> +	else
>> +		r = 0; /* on success i2c_transfer() return messages trasfered */
>> +
>> +	if (retries<  5)
>> +		dev_err(&client->dev, "sensor i2c stall encountered. "
>> +			"retries: %d\n", 5 - retries);
>> +
>> +	return r;
>> +}
> [...]
>> diff --git a/include/media/smiapp-regs.h b/include/media/smiapp-regs.h
>> new file mode 100644
>> index 0000000..3109b02
>> --- /dev/null
>> +++ b/include/media/smiapp-regs.h
>> @@ -0,0 +1,51 @@
>> +/*
>> + * include/media/smiapp-regs.h
>> + *
>> + * Generic driver for SMIA/SMIA++ compliant camera modules
>> + *
>> + * Copyright (C) 2011 Nokia Corporation
>> + * Contact: Sakari Ailus<sakari.ailus@maxwell.research.nokia.com>
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License
>> + * version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful, but
>> + * WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>> + * General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program; if not, write to the Free Software
>> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
>> + * 02110-1301 USA
>> + *
>> + */
>> +
>> +#ifndef SMIAPP_REGS_H
>> +#define SMIAPP_REGS_H
>> +
>> +#include<linux/i2c.h>
>> +#include<linux/types.h>
> 
>> +#include<linux/videodev2.h>
>> +#include<linux/v4l2-subdev.h>
> 
> Are these two headers really needed ?
> 
>> +
>> +struct v4l2_mbus_framefmt;
>> +struct v4l2_subdev_pad_mbus_code_enum;
> 
> Also these 2 lines seem redundant.

Removed both. I think they're remnants from the time this header file
used to contain something else as well.

>> +
>> +/* Use upper 8 bits of the type field for flags */
>> +#define SMIA_REG_FLAG_FLOAT		(1<<  24)
>> +
>> +#define SMIA_REG_8BIT			1
>> +#define SMIA_REG_16BIT			2
>> +#define SMIA_REG_32BIT			4
>> +struct smia_reg {
>> +	u16 type;
>> +	u16 reg;			/* 16-bit offset */
>> +	u32 val;			/* 8/16/32-bit value */
>> +};
>> +
>> +int smia_i2c_read_reg(struct i2c_client *client, u32 reg, u32 *val);
>> +int smia_i2c_write_reg(struct i2c_client *client, u32 reg, u32 val);
>> +
>> +#endif
>> diff --git a/include/media/smiapp.h b/include/media/smiapp.h
>> new file mode 100644
>> index 0000000..b302570
>> --- /dev/null
>> +++ b/include/media/smiapp.h
>> @@ -0,0 +1,82 @@
>> +/*
>> + * include/media/smiapp.h
>> + *
>> + * Generic driver for SMIA/SMIA++ compliant camera modules
>> + *
>> + * Copyright (C) 2011 Nokia Corporation
>> + * Contact: Sakari Ailus<sakari.ailus@maxwell.research.nokia.com>
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License
>> + * version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful, but
>> + * WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>> + * General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program; if not, write to the Free Software
>> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
>> + * 02110-1301 USA
>> + *
>> + */
>> +
>> +#ifndef __SMIAPP_H_
>> +#define __SMIAPP_H_
>> +
>> +#include<media/smiapp-regs.h>
>> +#include<media/v4l2-subdev.h>
>> +
>> +#define SMIAPP_NAME		"smiapp"
>> +
>> +#define SMIAPP_DFL_I2C_ADDR	(0x20>>  1) /* Default I2C Address */
>> +#define SMIAPP_ALT_I2C_ADDR	(0x6e>>  1) /* Alternate I2C Address */
>> +
>> +#define SMIAPP_CSI_SIGNALLING_MODE_CCP2_DATA_CLOCK	0
>> +#define SMIAPP_CSI_SIGNALLING_MODE_CCP2_DATA_STROBE	1
>> +#define SMIAPP_CSI_SIGNALLING_MODE_CSI2			2
>> +
>> +/*
>> + * Sometimes due to board layout considerations the camera module can be
>> + * mounted rotated. The typical rotation used is 180 degrees which can be
>> + * corrected by giving a default H-FLIP and V-FLIP in the sensor readout.
>> + * FIXME: rotation also changes the bayer pattern.
>> + */
>> +enum smiapp_module_board_orient {
>> +	SMIAPP_MODULE_BOARD_ORIENT_0 = 0,
>> +	SMIAPP_MODULE_BOARD_ORIENT_180,
>> +};
>> +
>> +struct smiapp_flash_strobe_parms {
>> +	u8 mode;
>> +	u32 strobe_width_high_us;
>> +	u16 strobe_delay;
>> +	u16 stobe_start_point;
>> +	u8 trigger;
>> +};
>> +
>> +struct smiapp_platform_data {
>> +	/*
>> +	 * Change the cci address if i2c_addr_alt is set.
>> +	 * Both default and alternate cci addr need to be present
>> +	 */
>> +	unsigned short i2c_addr_dfl;	/* Default i2c addr */
>> +	unsigned short i2c_addr_alt;	/* Alternate i2c addr */
>> +
>> +	unsigned int nvm_size;			/* bytes */
>> +	unsigned int ext_clk;			/* sensor external clk */
>> +
>> +	unsigned int lanes;		/* Number of CSI-2 lanes */
>> +	u8 csi_signalling_mode;		/* SMIAPP_CSI_SIGNALLING_MODE_* */
>> +	const s64 *op_sys_clock;
>> +
>> +	enum smiapp_module_board_orient module_board_orient;
>> +
>> +	struct smiapp_flash_strobe_parms *strobe_setup;
>> +
>> +	int (*set_xclk)(struct v4l2_subdev *sd, int hz);
>> +	int (*set_xshutdown)(struct v4l2_subdev *sd, u8 set);
> 
> There is no chance to avoid this callback, e.g. by passing GPIO(s) number(s)
> directly to the driver ?

I think Laurent also commented that. Yes, I'll fix that. We won't get
completely rid of these callbacks until we can have the generic clock
framework so we could control the ISP external clock to the sensor using
the regular clk_* functions.

>> +};
>> +
>> +#endif /* __SMIAPP_H_  */

Cheers,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
