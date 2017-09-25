Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:34068 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753848AbdIYJLj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Sep 2017 05:11:39 -0400
Message-ID: <1506330692.16112.68.camel@linux.intel.com>
Subject: Re: [PATCH v2] staging: atomisp: add a driver for ov5648 camera
 sensor
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Devid Antonio Floni <d.filoni@ubuntu.com>
Cc: sakari.ailus@linux.intel.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        =?ISO-8859-1?Q?J=E9r=E9my?= Lefaure <jeremy.lefaure@lse.epita.fr>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Date: Mon, 25 Sep 2017 12:11:32 +0300
In-Reply-To: <1506265198-13384-1-git-send-email-d.filoni@ubuntu.com>
References: <1506265198-13384-1-git-send-email-d.filoni@ubuntu.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2017-09-24 at 16:59 +0200, Devid Antonio Floni wrote:
> The ov5648 5-megapixel camera sensor from OmniVision supports up to
> 2592x1944
> resolution and MIPI CSI-2 interface. Output format is raw sRGB/Bayer
> with
> 10 bits per colour (SGRBG10_1X10).
> 
> This patch is a port of ov5648 driver after applying following
> 01org/ProductionKernelQuilts patches:
>  - 0004-ov2680-ov5648-Fork-lift-source-from-CTS.patch
>  - 0005-ov2680-ov5648-gminification.patch
>  - 0006-ov5648-Focus-support.patch
>  - 0007-Fix-resolution-issues-on-rear-camera.patch
>  - 0008-ov2680-ov5648-Enabled-the-set_exposure-functions.patch
>  - 0010-IRDA-cameras-mode-list-cleanup-unification.patch
>  - 0012-ov5648-Add-1296x972-binned-mode.patch
>  - 0014-ov5648-Adapt-to-Atomisp2-Gmin-VCM-framework.patch
>  - 0015-dw9714-Gmin-Atomisp-specific-VCM-driver.patch
>  - 0017-ov5648-Fix-deadlock-on-I2C-error.patch
>  - 0018-gc2155-Fix-deadlock-on-error.patch
>  - 0019-ov5648-Add-1280x960-binned-mode.patch
>  - 0020-ov5648-Make-1280x960-as-default-video-resolution.patch
>  - 0021-MALATA-Fix-testCameraToSurfaceTextureMetadata-CTS.patch
>  - 0023-OV5648-Added-5MP-video-resolution.patch

> 
> New changes introduced during the port:
>  - Rename entity types to entity functions
>  - Replace v4l2_subdev_fh by v4l2_subdev_pad_config
>  - Make use of media_bus_format enum
>  - Rename media_entity_init function to media_entity_pads_init
>  - Replace try_mbus_fmt by set_fmt
>  - Replace s_mbus_fmt by set_fmt
>  - Replace g_mbus_fmt by get_fmt
>  - Use s_ctrl/g_volatile_ctrl instead of ctrl core ops
>  - Update gmin platform API path
>  - Constify acpi_device_id
>  - Add "INT5648" value to acpi_device_id
>  - Fix some checkpatch errors and warnings
>  - Remove FSF's mailing address from the sample GPL notice
> 

> Changes in v2:
>  - Fix indentation
>  - Add atomisp prefix to Kconfig option

The above paragraph usually goes after --- delimiter line.


While v2 is better, it needs much more work. See my few comments (tip of
an iceberg) below.

> 
> "INT5648" ACPI device id can be found in following production
> hardware:
>     BIOS Information
>         Vendor: LENOVO
>         Version: 1HCN40WW
>         Release Date: 11/04/2016
>         ...
>         BIOS Revision: 0.40
>         Firmware Revision: 0.0
>     ...
>     System Information
>         Manufacturer: LENOVO
>         Product Name: 80SG
>         Version: MIIX 310-10ICR
>         ...
>         SKU Number: LENOVO_MT_80SG_BU_idea_FM_MIIX 310-10ICR
>         Family: IDEAPAD
>     ...
> 
> Device DSDT excerpt:
>     Device (CA00)
>     {
>         Name (_ADR, Zero)  // _ADR: Address
>         Name (_HID, "INT5648")  // _HID: Hardware ID
>         Name (_CID, "INT5648")  // _CID: Compatible ID
>         Name (_SUB, "INTL0000")  // _SUB: Subsystem ID
>         Name (_DDN, "ov5648")  // _DDN: DOS Device Name
>     ...

Thanks for the above description!

> 
> I was not able to properly test this patch on my Lenovo Miix 310 due
> to other
> issues with atomisp, the output is the same as ov2680 driver
> (OVTI2680)
> which is very similar.


> +#include <linux/module.h>

(1)

> +#include <linux/types.h>
> +#include <linux/kernel.h>
> +#include <linux/mm.h>
> +#include <linux/string.h>
> +#include <linux/errno.h>

> +#include <linux/init.h>

(2)

> +#include <linux/kmod.h>
> +#include <linux/device.h>
> +#include <linux/delay.h>
> +#include <linux/slab.h>
> +#include <linux/i2c.h>
> +#include <linux/gpio.h>
> +#include <linux/moduleparam.h>
> +#include <media/v4l2-device.h>
> +#include <linux/io.h>
> +#include "../include/linux/atomisp_gmin_platform.h"
> +
> +#include "ov5648.h"

One of (1) and (2) is redundant.

Can we also keep them in alphabetical order? Rationale is to fast search
among and avoiding duplication.

> +static int ov5648_read_reg(struct i2c_client *client,
> +			   u16 data_length, u16 reg, u16 *val)
> +{
> +	int err;
> +	struct i2c_msg msg[2];
> +	unsigned char data[6];
> +

> +	if (!client->adapter) {
> +		dev_err(&client->dev, "%s error, no client-
> >adapter\n",
> +			__func__);
> +		return -ENODEV;
> +	}

Hmm... When it's possible?

> +
> +	if (data_length != OV5648_8BIT && data_length != OV5648_16BIT
> +					&& data_length !=
> OV5648_32BIT) {
> +		dev_err(&client->dev, "%s error, invalid data
> length\n",
> +			__func__);
> +		return -EINVAL;
> +	}
> +
> 

> +
> +	err = i2c_transfer(client->adapter, msg, 2);
> +	if (err != 2) {

> +		if (err >= 0)
> +			err = -EIO;

This will hide an error below (in case it's returned -EIO vs. err ==
1)...

> +		dev_err(&client->dev,
> +			"read from offset 0x%x error %d", reg, err);

...thus would be better to

dev_err();
return err < 0 ? err : - EIO;


> +		return err;
> +	}
> +
> +	*val = 0;
> +	/* high byte comes first */
> +	if (data_length == OV5648_8BIT)
> +		*val = (u8)data[0];
> +	else if (data_length == OV5648_16BIT)
> +		*val = be16_to_cpu(*(u16 *)&data[0]);
> +	else
> +		*val = be32_to_cpu(*(u32 *)&data[0]);

If you can use i2c_smbus_*() functions they will convert endianess at
the same time.

> +
> +	return 0;
> +}
> 

> +static int ov5648_write_reg(struct i2c_client *client, u16
> data_length,
> +			    u16 reg, u16 val)
> +{
> +	int ret;
> +	unsigned char data[4] = {0};
> +	u16 *wreg = (u16 *)data;
> +	const u16 len = data_length + sizeof(u16); /* 16-bit address
> + data */
> +
> +	if (data_length != OV5648_8BIT && data_length !=
> OV5648_16BIT) {

Where 32 bit data width gone?

> +		dev_err(&client->dev,
> +			"%s error, invalid data_length\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	/* high byte goes out first */
> +	*wreg = cpu_to_be16(reg);
> +
> +	if (data_length == OV5648_8BIT) {
> +		data[2] = (u8)(val);
> +	} else {
> +		/* OV5648_16BIT */
> +		u16 *wdata = (u16 *)&data[2];
> +		*wdata = cpu_to_be16(val);
> +	}
> +
> +	ret = ov5648_i2c_write(client, len, data);
> +	if (ret)
> +		dev_err(&client->dev,
> +			"write error: wrote 0x%x to offset 0x%x error
> %d",
> +			val, reg, ret);
> +
> +	return ret;
> +}


> +static int ov5648_write_reg_array(struct i2c_client *client,
> +				  const struct ov5648_reg *reglist)
> +{
> +	const struct ov5648_reg *next = reglist;
> +	struct ov5648_write_ctrl ctrl;
> +	int err;
> +
> +	ctrl.index = 0;
> +	for (; next->type != OV5648_TOK_TERM; next++) {

Better to 
for (next = reglist; ...) {

> +		switch (next->type & OV5648_TOK_MASK) {
> +		case OV5648_TOK_DELAY:
> +			err = __ov5648_flush_reg_array(client,
> &ctrl);
> +			if (err)
> +				return err;

> +			msleep(next->val);

Oy vey, how can you guarantee that this will not be long enough to make
user experience awful?

> +			break;
> +		default:
> +			/*
> +			 * If next address is not consecutive, data
> needs to be
> +			 * flushed before proceed.
> +			 */
> +			if
> (!__ov5648_write_reg_is_consecutive(client, &ctrl,
> +								next)
> ) {
> +				err =
> __ov5648_flush_reg_array(client, &ctrl);
> +			if (err)
> +				return err;
> +			}
> +			err = __ov5648_buf_reg_array(client, &ctrl,
> next);
> +			if (err) {
> +				dev_err(&client->dev, "%s: write
> error, aborted\n",
> +					 __func__);
> +				return err;
> +			}
> +			break;
> +		}
> +	}
> +
> +	return __ov5648_flush_reg_array(client, &ctrl);
> +}

+ empty line.

> +static int ov5648_g_focal(struct v4l2_subdev *sd, s32 *val)
> +{
> +	*val = (OV5648_FOCAL_LENGTH_NUM << 16) |
> OV5648_FOCAL_LENGTH_DEM;
> +	return 0;
> +}
> +
> +static int ov5648_g_fnumber(struct v4l2_subdev *sd, s32 *val)
> +{

> +	/*const f number for imx*/

Bad style.

> +	*val = (OV5648_F_NUMBER_DEFAULT_NUM << 16) |
> OV5648_F_NUMBER_DEM;
> +	return 0;
> +}

> +static int ov5648_get_intg_factor(struct i2c_client *client,
> +				struct camera_mipi_info *info,
> +				const struct ov5648_resolution *res)
> +{
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +	struct ov5648_device *dev = to_ov5648_sensor(sd);
> +	struct atomisp_sensor_mode_data *buf = &info->data;
> +	unsigned int pix_clk_freq_hz;
> +	u16 reg_val;
> +	int ret;
> +
> +	if (!info)
> +		return -EINVAL;
> +

> +	/* pixel clock */

Isn't it obvious from the code?

> +	pix_clk_freq_hz = res->pix_clk_freq * 1000000;
> +
> +	dev->vt_pix_clk_freq_mhz = pix_clk_freq_hz;
> +	buf->vt_pix_clk_freq_mhz = pix_clk_freq_hz;
> +
> +	/* get integration time */

Ditto.

> +	buf->coarse_integration_time_min =
> OV5648_COARSE_INTG_TIME_MIN;
> +	buf->coarse_integration_time_max_margin =
> +		OV5648_COARSE_INTG_TIME_MAX_MARGIN;
> +
> +	buf->fine_integration_time_min = OV5648_FINE_INTG_TIME_MIN;
> +	buf->fine_integration_time_max_margin =
> +		OV5648_FINE_INTG_TIME_MAX_MARGIN;
> +
> +	buf->fine_integration_time_def = OV5648_FINE_INTG_TIME_MIN;
> +	buf->frame_length_lines = res->lines_per_frame;
> +	buf->line_length_pck = res->pixels_per_line;
> +	buf->read_mode = res->bin_mode;
> +
> +	/* get the cropping and output resolution to ISP for this
> mode. */
> 

Style of comments.

Make them consistent over the code and be following the code-style
rules.

> +}

> +	// EXPOSURE CONTROL DISABLED FOR INITIAL CHECKIN, TUNING
> DOESN'T WORK

Huh?

This style of comments should not be in upstream code.

> +	return ov5648_set_exposure(sd, exp, gain, digitgain);
> +}

> +err:

> +	return ret;

In above like cases err: label is redundant.

> +}

> +static int ov5648_h_flip(struct v4l2_subdev *sd, s32 value)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	int ret;
> +	u16 val;

+ empty line.

> +	dev_dbg(&client->dev, "@%s: value:%d\n", __func__, value);

Please, remove __func__ from all dev_dbg() and pr_debug() calls.
Dynamic debug can do it for you.

Moreover, if you wish to do better debug, switch to trace points.

> +static int ov5648_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct ov5648_device *dev = container_of(ctrl->handler,
> +		struct ov5648_device, ctrl_handler);

> +	int ret = 0;

Redundant assignment. Check the rest of the code for it and remove where
it's not needed. Otherwise it might hide a potential error.

> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_EXPOSURE_ABSOLUTE:
> +		ret = ov5648_q_exposure(&dev->sd, &ctrl->val);
> +		break;
> +	case V4L2_CID_FOCAL_ABSOLUTE:
> +		ret = ov5648_g_focal(&dev->sd, &ctrl->val);
> +		break;
> +	case V4L2_CID_FNUMBER_ABSOLUTE:
> +		ret = ov5648_g_fnumber(&dev->sd, &ctrl->val);
> +		break;
> +	case V4L2_CID_FNUMBER_RANGE:
> +		ret = ov5648_g_fnumber_range(&dev->sd, &ctrl->val);
> +		break;
> +	case V4L2_CID_BIN_FACTOR_HORZ:
> +		ret = ov5648_g_bin_factor_x(&dev->sd, &ctrl->val);
> +		break;
> +	case V4L2_CID_BIN_FACTOR_VERT:
> +		ret = ov5648_g_bin_factor_y(&dev->sd, &ctrl->val);
> +		break;
> +	default:
> +		ret = -EINVAL;
> +	}
> +
> +	return ret;
> +}

> +#if 1

WTF?

> +/*
> + *Camera driver need to load AWB calibration data
> + *stored in OTP and write to gain registers after
> + *initialization of register settings.
> + * index: index of otp group. (1, 2, 3)
> + * return: 0, group index is empty
> + *		1, group index has invalid data
> + *		2, group index has valid data
> + */
> +static int check_otp(struct i2c_client *client, int index)
> +{
> +	int i;
> +	u16 flag = 0, rg = 0, bg = 0;
> +	if (index == 1) {
> +		/* read otp --Bank 0 */
> +		ov5648_write_reg(client, OV5648_8BIT, 0x3d84, 0xc0);
> +		ov5648_write_reg(client, OV5648_8BIT, 0x3d85, 0x00);
> +		ov5648_write_reg(client, OV5648_8BIT, 0x3d86, 0x0f);
> +		ov5648_write_reg(client, OV5648_8BIT, 0x3d81, 0x01);
> +		mdelay(5);
> +		ov5648_read_reg(client, OV5648_8BIT, 0x3d05, &flag);
> +		ov5648_read_reg(client, OV5648_8BIT, 0x3d07, &rg);
> +		ov5648_read_reg(client, OV5648_8BIT, 0x3d08, &bg);
> +	} else if (index == 2) {
> +		/* read otp --Bank 0 */
> +		ov5648_write_reg(client, OV5648_8BIT, 0x3d84, 0xc0);
> +		ov5648_write_reg(client, OV5648_8BIT, 0x3d85, 0x00);
> +		ov5648_write_reg(client, OV5648_8BIT, 0x3d86, 0x0f);
> +		ov5648_write_reg(client, OV5648_8BIT, 0x3d81, 0x01);
> +		mdelay(5);
> +		ov5648_read_reg(client, OV5648_8BIT, 0x3d0e, &flag);
> +
> +		/* read otp --Bank 1 */
> +		ov5648_write_reg(client, OV5648_8BIT, 0x3d84, 0xc0);
> +		ov5648_write_reg(client, OV5648_8BIT, 0x3d85, 0x10);
> +		ov5648_write_reg(client, OV5648_8BIT, 0x3d86, 0x1f);
> +		ov5648_write_reg(client, OV5648_8BIT, 0x3d81, 0x01);
> +		mdelay(5);
> +		ov5648_read_reg(client, OV5648_8BIT, 0x3d00, &rg);
> +		ov5648_read_reg(client, OV5648_8BIT, 0x3d01, &bg);
> +	} else if (index == 3) {
> +		/* read otp --Bank 1 */
> +		ov5648_write_reg(client, OV5648_8BIT, 0x3d84, 0xc0);
> +		ov5648_write_reg(client, OV5648_8BIT, 0x3d85, 0x10);
> +		ov5648_write_reg(client, OV5648_8BIT, 0x3d86, 0x1f);
> +		ov5648_write_reg(client, OV5648_8BIT, 0x3d81, 0x01);
> +		mdelay(5);
> +		ov5648_read_reg(client, OV5648_8BIT, 0x3d07, &flag);
> +		ov5648_read_reg(client, OV5648_8BIT, 0x3d09, &rg);
> +		ov5648_read_reg(client, OV5648_8BIT, 0x3d0a, &bg);
> +	}
> +
> +	flag = flag & 0x80;
> +
> +	/* clear otp buffer */
> +	for (i = 0; i < 16; i++)
> +		ov5648_write_reg(client, OV5648_8BIT, 0x3d00 + i,
> 0x00);
> +
> +	if (flag)
> +		return 1;
> +	else {
> +		if (rg == 0 && bg == 0)
> +			return 0;
> +		else
> +			return 2;
> +	}
> +
> +}
> +
> +/* index: index of otp group. (1, 2, 3)
> + * return: 0,
> + */
> +static int read_otp(struct i2c_client *client,
> +	    int index, struct otp_struct *otp_ptr)
> +{
> +	int i;
> +	u16 temp;
> +	/* read otp into buffer */
> +	if (index == 1) {
> +		/* read otp --Bank 0 */
> +		ov5648_write_reg(client, OV5648_8BIT, 0x3d84, 0xc0);
> +		ov5648_write_reg(client, OV5648_8BIT, 0x3d85, 0x00);
> +		ov5648_write_reg(client, OV5648_8BIT, 0x3d86, 0x0f);
> +		ov5648_write_reg(client, OV5648_8BIT, 0x3d81, 0x01);
> +		mdelay(5);
> +		ov5648_read_reg(client, OV5648_8BIT,
> +			0x3d05, &((*otp_ptr).module_integrator_id));
> +		(*otp_ptr).module_integrator_id =
> +			(*otp_ptr).module_integrator_id & 0x7f;
> +		ov5648_read_reg(client, OV5648_8BIT,
> +			0x3d06, &((*otp_ptr).lens_id));
> +		ov5648_read_reg(client, OV5648_8BIT, 0x3d0b, &temp);
> +		ov5648_read_reg(client, OV5648_8BIT,
> +			0x3d07, &((*otp_ptr).rg_ratio));
> +		(*otp_ptr).rg_ratio =
> +			((*otp_ptr).rg_ratio<<2) + ((temp>>6) &
> 0x03);
> +		ov5648_read_reg(client, OV5648_8BIT,
> +			0x3d08, &((*otp_ptr).bg_ratio));
> +		(*otp_ptr).bg_ratio =
> +			((*otp_ptr).bg_ratio<<2) + ((temp>>4) &
> 0x03);
> +		ov5648_read_reg(client, OV5648_8BIT,
> +			0x3d0c, &((*otp_ptr).light_rg));
> +		(*otp_ptr).light_rg =
> +			((*otp_ptr).light_rg<<2) + ((temp>>2) &
> 0x03);
> +		ov5648_read_reg(client, OV5648_8BIT,
> +			0x3d0d, &((*otp_ptr).light_bg));
> +		(*otp_ptr).light_bg =
> +			((*otp_ptr).light_bg<<2) + (temp & 0x03);
> +		ov5648_read_reg(client, OV5648_8BIT,
> +			0x3d09, &((*otp_ptr).user_data[0]));
> +		ov5648_read_reg(client, OV5648_8BIT,
> +			0x3d0a, &((*otp_ptr).user_data[1]));
> +	} else if (index == 2) {
> +		/* read otp --Bank 0 */
> +		ov5648_write_reg(client, OV5648_8BIT, 0x3d84, 0xc0);
> +		ov5648_write_reg(client, OV5648_8BIT, 0x3d85, 0x00);
> +		ov5648_write_reg(client, OV5648_8BIT, 0x3d86, 0x0f);
> +		ov5648_write_reg(client, OV5648_8BIT, 0x3d81, 0x01);
> +		mdelay(5);
> +		ov5648_read_reg(client, OV5648_8BIT,
> +			0x3d0e, &((*otp_ptr).module_integrator_id));
> +		(*otp_ptr).module_integrator_id =
> +			(*otp_ptr).module_integrator_id & 0x7f;
> +		ov5648_read_reg(client, OV5648_8BIT,
> +			0x3d0f, &((*otp_ptr).lens_id));
> +		/* read otp --Bank 1 */
> +		ov5648_write_reg(client, OV5648_8BIT, 0x3d84, 0xc0);
> +		ov5648_write_reg(client, OV5648_8BIT, 0x3d85, 0x10);
> +		ov5648_write_reg(client, OV5648_8BIT, 0x3d86, 0x1f);
> +		ov5648_write_reg(client, OV5648_8BIT, 0x3d81, 0x01);
> +		mdelay(5);
> +		ov5648_read_reg(client, OV5648_8BIT, 0x3d04, &temp);
> +		ov5648_read_reg(client, OV5648_8BIT,
> +			0x3d00, &((*otp_ptr).rg_ratio));
> +		(*otp_ptr).rg_ratio =
> +			((*otp_ptr).rg_ratio<<2) + ((temp>>6) &
> 0x03);
> +		ov5648_read_reg(client, OV5648_8BIT,
> +			0x3d01, &((*otp_ptr).bg_ratio));
> +		(*otp_ptr).bg_ratio =
> +			((*otp_ptr).bg_ratio<<2) + ((temp>>4) &
> 0x03);
> +		ov5648_read_reg(client, OV5648_8BIT,
> +			0x3d05, &((*otp_ptr).light_rg));
> +		(*otp_ptr).light_rg =
> +			((*otp_ptr).light_rg<<2) + ((temp>>2) &
> 0x03);
> +		ov5648_read_reg(client, OV5648_8BIT,
> +			0x3d06, &((*otp_ptr).light_bg));
> +		(*otp_ptr).light_bg =
> +			((*otp_ptr).light_bg<<2) + (temp & 0x03);
> +		ov5648_read_reg(client, OV5648_8BIT,
> +			0x3d02, &((*otp_ptr).user_data[0]));
> +		ov5648_read_reg(client, OV5648_8BIT,
> +			0x3d03, &((*otp_ptr).user_data[1]));
> +	} else if (index == 3) {
> +		/* read otp --Bank 1 */
> +		ov5648_write_reg(client, OV5648_8BIT, 0x3d84, 0xc0);
> +		ov5648_write_reg(client, OV5648_8BIT, 0x3d85, 0x10);
> +		ov5648_write_reg(client, OV5648_8BIT, 0x3d86, 0x1f);
> +		ov5648_write_reg(client, OV5648_8BIT, 0x3d81, 0x01);
> +		mdelay(5);
> +		ov5648_read_reg(client, OV5648_8BIT,
> +			0x3d07, &((*otp_ptr).module_integrator_id));
> +		(*otp_ptr).module_integrator_id =
> +			(*otp_ptr).module_integrator_id & 0x7f;
> +		ov5648_read_reg(client, OV5648_8BIT,
> +			0x3d08, &((*otp_ptr).lens_id));
> +		ov5648_read_reg(client, OV5648_8BIT, 0x3d0d, &temp);
> +		ov5648_read_reg(client, OV5648_8BIT,
> +			0x3d09, &((*otp_ptr).rg_ratio));
> +		(*otp_ptr).rg_ratio =
> +			((*otp_ptr).rg_ratio<<2) + ((temp>>6) &
> 0x03);
> +		ov5648_read_reg(client, OV5648_8BIT,
> +			0x3d0a, &((*otp_ptr).bg_ratio));
> +		(*otp_ptr).bg_ratio =
> +			((*otp_ptr).bg_ratio<<2) + ((temp>>4) &
> 0x03);
> +		ov5648_read_reg(client, OV5648_8BIT,
> +			0x3d0e, &((*otp_ptr).light_rg));
> +		(*otp_ptr).light_rg =
> +			((*otp_ptr).light_rg<<2) + ((temp>>2) &
> 0x03);
> +		ov5648_read_reg(client, OV5648_8BIT,
> +			0x3d0f, &((*otp_ptr).light_bg));
> +		(*otp_ptr).light_bg =
> +			((*otp_ptr).light_bg<<2) + (temp & 0x03);
> +		ov5648_read_reg(client, OV5648_8BIT,
> +			0x3d0b, &((*otp_ptr).user_data[0]));
> +		ov5648_read_reg(client, OV5648_8BIT,
> +			0x3d0c, &((*otp_ptr).user_data[1]));
> +	}
> +	/* clear otp buffer */
> +	for (i = 0; i < 16; i++)
> +		ov5648_write_reg(client, OV5648_8BIT, 0x3d00 + i,
> 0x00);
> +
> +	return 0;
> +}
> +/* R_gain, sensor red gain of AWB, 0x400 =1
> + * G_gain, sensor green gain of AWB, 0x400 =1
> + * B_gain, sensor blue gain of AWB, 0x400 =1
> + * return 0;
> + */
> +static int update_awb_gain(struct v4l2_subdev *sd)
> +{
> +
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	struct ov5648_device *dev = to_ov5648_sensor(sd);
> +	int R_gain = dev->current_otp.R_gain;
> +	int G_gain = dev->current_otp.G_gain;
> +	int B_gain = dev->current_otp.B_gain;
> +	if (R_gain > 0x400) {
> +		ov5648_write_reg(client, OV5648_8BIT, 0x5186,
> R_gain>>8);
> +		ov5648_write_reg(client, OV5648_8BIT, 0x5187, R_gain
> & 0x00ff);
> +	}
> +	if (G_gain > 0x400) {
> +		ov5648_write_reg(client, OV5648_8BIT, 0x5188,
> G_gain>>8);
> +		ov5648_write_reg(client, OV5648_8BIT, 0x5189, G_gain
> & 0x00ff);
> +	}
> +	if (B_gain > 0x400) {
> +		ov5648_write_reg(client, OV5648_8BIT, 0x518a,
> B_gain>>8);
> +		ov5648_write_reg(client, OV5648_8BIT, 0x518b, B_gain
> & 0x00ff);
> +	}
> +	#ifdef OV5648_DEBUG_EN
> +	dev_dbg(&client->dev, "_ov5648_: %s : rgain:%x ggain:%x
> bgain:%x\n", __func__, R_gain, G_gain, B_gain);
> +	#endif
> +	return 0;
> +}
> +
> +/* call this function after OV5648 initialization
> + * return: 0 update success
> + *		1, no OTP
> + */
> +static int update_otp(struct v4l2_subdev *sd)
> +{
> +	struct otp_struct current_otp;
> +	struct ov5648_device *dev = to_ov5648_sensor(sd);
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	int i, ret;
> +	int otp_index;
> +	u16 temp;
> +	int R_gain, G_gain, B_gain, G_gain_R, G_gain_B;
> +	u16 rg = 1, bg = 1;
> +
> +	//otp valid after mipi on and sw stream on
> +	ov5648_write_reg(client, OV5648_8BIT, OV5648_SW_STREAM,
> OV5648_START_STREAMING);
> +
> +	/* R/G and B/G of current camera module is read out from
> sensor OTP
> +	 * check first OTP with valid data
> +	 */
> +	for (i = 1; i <= 3; i++) {
> +		temp = check_otp(client, i);
> +		if (temp == 2) {
> +			otp_index = i;
> +			break;
> +		}
> +	}
> +	if (i > 3) {
> +		printk(KERN_INFO"@%s: no valid wb otp data\n",
> __func__);
> +		/* no valid wb OTP data */
> +		return 1;
> +	}
> +	read_otp(client, otp_index, &current_otp);
> +	if (current_otp.light_rg == 0) {
> +		/* no light source information in OTP */
> +		rg = current_otp.rg_ratio;
> +	} else {
> +		/* light source information found in OTP */
> +		rg = current_otp.rg_ratio * (current_otp.light_rg +
> 512) / 1024;
> +	}
> +	if (current_otp.light_bg == 0) {
> +		/* no light source information in OTP */
> +		bg = current_otp.bg_ratio;
> +	} else {
> +		/* light source information found in OTP */
> +		bg = current_otp.bg_ratio * (current_otp.light_bg +
> 512) / 1024;
> +	}
> +	#ifdef OV5648_DEBUG_EN
> +	dev_dbg(&client->dev, "_ov5648_: %s : rg:%x bg:%x\n",
> __func__, rg, bg);
> +	#endif
> +	if (rg == 0)
> +		rg = 1;
> +	if (bg == 0)
> +		bg = 1;
> +	/*calculate G gain
> +	 *0x400 = 1x gain
> +	 */
> +	if (bg < BG_Ratio_Typical) {
> +		if (rg < RG_Ratio_Typical) {
> +			/* current_otp.bg_ratio < BG_Ratio_typical &&
> +			 * current_otp.rg_ratio < RG_Ratio_typical
> +			 */
> +			G_gain = 0x400;
> +			B_gain = 0x400 * BG_Ratio_Typical / bg;
> +			R_gain = 0x400 * RG_Ratio_Typical / rg;
> +		} else {
> +			/* current_otp.bg_ratio < BG_Ratio_typical &&
> +			 * current_otp.rg_ratio >= RG_Ratio_typical
> +			 */
> +			R_gain = 0x400;
> +			G_gain = 0x400 * rg / RG_Ratio_Typical;
> +			B_gain = G_gain * BG_Ratio_Typical / bg;
> +		}
> +	} else {
> +		if (rg < RG_Ratio_Typical) {
> +			/* current_otp.bg_ratio >= BG_Ratio_typical
> &&
> +			 * current_otp.rg_ratio < RG_Ratio_typical
> +			 */
> +			B_gain = 0x400;
> +			G_gain = 0x400 * bg / BG_Ratio_Typical;
> +			R_gain = G_gain * RG_Ratio_Typical / rg;
> +		} else {
> +			/* current_otp.bg_ratio >= BG_Ratio_typical
> &&
> +			 * current_otp.rg_ratio >= RG_Ratio_typical
> +			 */
> +			G_gain_B = 0x400 * bg / BG_Ratio_Typical;
> +			G_gain_R = 0x400 * rg / RG_Ratio_Typical;
> +			if (G_gain_B > G_gain_R) {
> +				B_gain = 0x400;
> +				G_gain = G_gain_B;
> +				R_gain = G_gain * RG_Ratio_Typical /
> rg;
> +			} else {
> +				R_gain = 0x400;
> +				G_gain = G_gain_R;
> +				B_gain = G_gain * BG_Ratio_Typical /
> bg;
> +			}
> +		}
> +	}
> +
> +	dev->current_otp.R_gain = R_gain;
> +	dev->current_otp.G_gain = G_gain;
> +	dev->current_otp.B_gain = B_gain;
> +
> +	ret = ov5648_write_reg(client, OV5648_8BIT,
> +		OV5648_SW_STREAM, OV5648_STOP_STREAMING);
> +	return ret ;
> +}
> +
> +#endif
> +
> +static int power_ctrl(struct v4l2_subdev *sd, bool flag)
> +{
> +	int ret = 0;
> +	struct ov5648_device *dev = to_ov5648_sensor(sd);
> +	if (!dev || !dev->platform_data)
> +		return -ENODEV;
> +
> +	/* Non-gmin platforms use the legacy callback */
> +	if (dev->platform_data->power_ctrl)
> +		return dev->platform_data->power_ctrl(sd, flag);
> +
> +	if (flag) {
> +		ret |= dev->platform_data->v1p8_ctrl(sd, 1);
> +		ret |= dev->platform_data->v2p8_ctrl(sd, 1);
> +		usleep_range(10000, 15000);
> +	}
> +
> +	if (!flag || ret) {
> +		ret |= dev->platform_data->v1p8_ctrl(sd, 0);
> +		ret |= dev->platform_data->v2p8_ctrl(sd, 0);
> +	}
> +	return ret;
> +}
> +
> +static int gpio_ctrl(struct v4l2_subdev *sd, bool flag)
> +{

> +	int ret;
> +	struct ov5648_device *dev = to_ov5648_sensor(sd);

Better to use reversed xmas tree order in such blocks.

> +
> +	if (!dev || !dev->platform_data)
> +		return -ENODEV;
> +

When it's the case?

> +	/* Non-gmin platforms use the legacy callback */
> +	if (dev->platform_data->gpio_ctrl)
> +		return dev->platform_data->gpio_ctrl(sd, flag);

What the platforms? Are they sold in the open market?

> +
> +	/* GPIO0 == "RESETB", GPIO1 == "PWDNB", named in opposite
> +	 * senses but with the same behavior: both must be high for
> +	 * the device to opperate */
> +	if (flag) {
> +		ret = dev->platform_data->gpio0_ctrl(sd, 1);
> +		usleep_range(10000, 15000);
> +		ret |= dev->platform_data->gpio1_ctrl(sd, 1);
> +		usleep_range(10000, 15000);
> +	} else {
> +		ret = dev->platform_data->gpio1_ctrl(sd, 0);
> +		ret |= dev->platform_data->gpio0_ctrl(sd, 0);
> +	}
> +	return ret;
> +}
> +
> +static int power_up(struct v4l2_subdev *sd)
> +{
> +	struct ov5648_device *dev = to_ov5648_sensor(sd);
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	int ret;
> +
> +	dev_dbg(&client->dev, "@%s:\n", __func__);
> +	if (!dev->platform_data) {
> +		dev_err(&client->dev,
> +			"no camera_sensor_platform_data");
> +		return -ENODEV;
> +	}
> +
> +	/* power control */
> +	ret = power_ctrl(sd, 1);
> +	if (ret)
> +		goto fail_power;
> +
> +	/* according to DS, at least 5ms is needed between DOVDD and
> PWDN */
> +	usleep_range(5000, 6000);
> +
> +	/* gpio ctrl */
> +	ret = gpio_ctrl(sd, 1);
> +	if (ret) {
> +		ret = gpio_ctrl(sd, 1);
> +		if (ret)
> +			goto fail_power;
> +	}
> +
> +	/* flis clock control */
> +	ret = dev->platform_data->flisclk_ctrl(sd, 1);
> +	if (ret)
> +		goto fail_clk;
> +
> +	/* according to DS, 20ms is needed between PWDN and i2c
> access */
> +	msleep(20);
> +
> +	return 0;
> +
> +fail_clk:
> +	gpio_ctrl(sd, 0);
> +fail_power:
> +	power_ctrl(sd, 0);
> +	dev_err(&client->dev, "sensor power-up failed\n");
> +
> +	return ret;
> +}

> +
> +static int power_down(struct v4l2_subdev *sd)
> +{
> +	struct ov5648_device *dev = to_ov5648_sensor(sd);
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	int ret = 0;
> +
> +	h_flag = H_FLIP_DEFAULT;
> +	v_flag = V_FLIP_DEFAULT;
> +	dev_dbg(&client->dev, "@%s:\n", __func__);
> +	if (!dev->platform_data) {
> +		dev_err(&client->dev,
> +			"no camera_sensor_platform_data");
> +		return -ENODEV;
> +	}
> +
> +	ret = dev->platform_data->flisclk_ctrl(sd, 0);
> +	if (ret)
> +		dev_err(&client->dev, "flisclk failed\n");
> +
> +	/* gpio ctrl */
> +	ret = gpio_ctrl(sd, 0);
> +	if (ret) {
> +		ret = gpio_ctrl(sd, 0);
> +		if (ret)
> +			dev_err(&client->dev, "gpio failed 2\n");
> +	}
> +
> +	/* power control */
> +	ret = power_ctrl(sd, 0);
> +	if (ret)
> +		dev_err(&client->dev, "vprog failed.\n");
> +
> +	return ret;
> +}

For all above play around GPIO you need to register a voltage regulator
and use regulator framework.

> +#define LARGEST_ALLOWED_RATIO_MISMATCH 900
> +static int distance(struct ov5648_resolution *res, u32 w, u32 h)
> +{
> +	unsigned int w_ratio = ((res->width << 13) / w);

Redundant parens.

> +	unsigned int h_ratio;
> +	int match;
> +
> +	if (h == 0)
> +		return -1;
> +	h_ratio = ((res->height << 13) / h);

Ditto.

> +	if (h_ratio == 0)
> +		return -1;
> +	match   = abs(((w_ratio << 13) / h_ratio) - ((int)8192));

Ditto.

> +
> +	if ((w_ratio < (int)8192) || (h_ratio < (int)8192)  ||
> +		(match > LARGEST_ALLOWED_RATIO_MISMATCH))
> +		return -1;

Why (int) casting here and above?!

> +
> +	return w_ratio + h_ratio;
> +}

> +
> +/* Return the nearest higher resolution index */
> +static int nearest_resolution_index(int w, int h)
> +{
> +	int i;
> +	int idx = -1;
> +	int dist;
> +	int min_dist = INT_MAX;
> +	struct ov5648_resolution *tmp_res = NULL;

Reversed xmas tree order.

> +
> +	for (i = 0; i < N_RES; i++) {
> +		tmp_res = &ov5648_res[i];
> +		dist = distance(tmp_res, w, h);
> +		if (dist == -1)
> +			continue;
> +		if (dist < min_dist) {
> +			min_dist = dist;
> +			idx = i;
> +		}
> +	}
> +
> +	return idx;
> +}
> 

> +	id = ((((u16) high) << 8) | (u16) low);

Redundant parens. Please, check all lines to avoid such.

> +
> 

> +	revision = (u8) high & 0x0f;
> +
> +	dev_dbg(&client->dev, "sensor_revision = 0x%x\n", revision);
> +	dev_dbg(&client->dev, "detect ov5648 success\n");

It would be one line, moreover, instead of above, you may use

...("...%c...",  hex_asc_lo[high]);


> +	return 0;
> +}

> +
> +static int ov5648_s_stream(struct v4l2_subdev *sd, int enable)
> +{
> +	struct ov5648_device *dev = to_ov5648_sensor(sd);
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	int ret;

+ empty line.
Please check all functions.

> +	dev_dbg(&client->dev, "@%s:\n", __func__);

Noise. Remove.
Do this for all similar cases.

> +	mutex_lock(&dev->input_lock);
> +
> +	ret = ov5648_write_reg(client, OV5648_8BIT, OV5648_SW_STREAM,
> +				enable ? OV5648_START_STREAMING :
> +				OV5648_STOP_STREAMING);
> +
> +	mutex_unlock(&dev->input_lock);
> +
> +	return ret;
> +}

> +static int ov5648_remove(struct i2c_client *client)
> +{
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +	struct ov5648_device *dev = to_ov5648_sensor(sd);

> +	dev_dbg(&client->dev, "ov5648_remove...\n");

Noise, remove.

> +
> +	dev->platform_data->csi_cfg(sd, 0);
> +
> +	v4l2_device_unregister_subdev(sd);
> +	media_entity_cleanup(&dev->sd.entity);
> +	v4l2_ctrl_handler_free(&dev->ctrl_handler);
> +	kfree(dev);
> +
> +	return 0;
> +}

> +
> +static int ov5648_probe(struct i2c_client *client,
> +			const struct i2c_device_id *id)
> +{
> +	struct ov5648_device *dev;
> +	size_t len = CAMERA_MODULE_ID_LEN * sizeof(char);
> +	int ret;
> +	void *pdata;
> +	unsigned int i;
> +
> +	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
> +	if (!dev) {
> +		dev_err(&client->dev, "out of memory\n");
> +		return -ENOMEM;
> +	}
> +
> +	dev->camera_module = kzalloc(len, GFP_KERNEL);
> +	if (!dev->camera_module) {
> +		kfree(dev);
> +		dev_err(&client->dev, "out of memory\n");
> +		return -ENOMEM;
> +	}
> +
> +	mutex_init(&dev->input_lock);
> +
> +	dev->fmt_idx = 0;

> +	//otp functions

Wrong style, noisy comment. Remove.

> +	dev->current_otp.otp_en = 1;// enable otp functions

Ditto.

> +	v4l2_i2c_subdev_init(&(dev->sd), client, &ov5648_ops);
> +
> +	if (gmin_get_config_var(&client->dev, "CameraModule",
> +				dev->camera_module, &len)) {
> +		kfree(dev->camera_module);
> +		dev->camera_module = NULL;
> +		dev_info(&client->dev, "Camera module id is
> missing\n");
> +	}
> +
> +	if (ACPI_COMPANION(&client->dev))
> +		pdata = gmin_camera_platform_data(&dev->sd,
> +						  ATOMISP_INPUT_FORMA
> T_RAW_10,
> +						  atomisp_bayer_order
> _bggr);
> +	else

> +		pdata = client->dev.platform_data;

What kind of platforms will use platform_data?

> +out_free:
> +	v4l2_device_unregister_subdev(&dev->sd);

Doesn't v4l2 have devm_*() helpers?

> +	kfree(dev->camera_module);
> +	kfree(dev);

Shouldn't those be devm_kzalloc() ?

> +	return ret;
> +}

> +
> +static const struct acpi_device_id ov5648_acpi_match[] = {

> +	{"XXOV5648"},

WTF is that?

> +	{"INT5648"},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(acpi, ov5648_acpi_match);
> +

> +MODULE_DEVICE_TABLE(i2c, ov5648_id);

Where is the table?

> +static struct i2c_driver ov5648_driver = {
> +	.driver = {

> +		.owner = THIS_MODULE,

Redundant.

> +		.name = OV5648_NAME,
> +		.acpi_match_table = ACPI_PTR(ov5648_acpi_match),
> +	},
> +	.probe = ov5648_probe,
> +	.remove = ov5648_remove,
> +	.id_table = ov5648_id,
> +};
> +

> +static int init_ov5648(void)
> +{
> +	return i2c_add_driver(&ov5648_driver);
> +}
> +
> +static void exit_ov5648(void)
> +{
> +
> +	i2c_del_driver(&ov5648_driver);
> +}
> +
> +module_init(init_ov5648);
> +module_exit(exit_ov5648);

module_i2c_driver();

> +#ifndef __OV5648_H__
> +#define __OV5648_H__

+ empty line.

> +#include <linux/kernel.h>
> +#include <linux/types.h>
> +#include <linux/i2c.h>
> +#include <linux/delay.h>
> +#include <linux/videodev2.h>
> +#include <linux/spinlock.h>
> +#include <media/v4l2-subdev.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <linux/v4l2-mediabus.h>
> +#include <media/media-entity.h>
> +#include <linux/acpi.h>
> +#include  "../include/linux/atomisp_platform.h"

Why? Are they all needed for definitions below?
I'm pretty sure you may leave only couple out of them.

> +
> +#define OV5648_NAME		"ov5648"

Why it's here?

> +static const struct i2c_device_id ov5648_id[] = {
> +	{OV5648_NAME, 0},
> +	{}
> +};

WTF?! It shouldn't be in the header!

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
