Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34834 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752506AbdIXPAd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Sep 2017 11:00:33 -0400
From: Devid Antonio Floni <d.filoni@ubuntu.com>
Cc: andriy.shevchenko@linux.intel.com, sakari.ailus@linux.intel.com,
        d.filoni@ubuntu.com, Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        =?UTF-8?q?J=C3=A9r=C3=A9my=20Lefaure?=
        <jeremy.lefaure@lse.epita.fr>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH v2] staging: atomisp: add a driver for ov5648 camera sensor
Date: Sun, 24 Sep 2017 16:59:38 +0200
Message-Id: <1506265198-13384-1-git-send-email-d.filoni@ubuntu.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ov5648 5-megapixel camera sensor from OmniVision supports up to 2592x1944
resolution and MIPI CSI-2 interface. Output format is raw sRGB/Bayer with
10 bits per colour (SGRBG10_1X10).

This patch is a port of ov5648 driver after applying following
01org/ProductionKernelQuilts patches:
 - 0004-ov2680-ov5648-Fork-lift-source-from-CTS.patch
 - 0005-ov2680-ov5648-gminification.patch
 - 0006-ov5648-Focus-support.patch
 - 0007-Fix-resolution-issues-on-rear-camera.patch
 - 0008-ov2680-ov5648-Enabled-the-set_exposure-functions.patch
 - 0010-IRDA-cameras-mode-list-cleanup-unification.patch
 - 0012-ov5648-Add-1296x972-binned-mode.patch
 - 0014-ov5648-Adapt-to-Atomisp2-Gmin-VCM-framework.patch
 - 0015-dw9714-Gmin-Atomisp-specific-VCM-driver.patch
 - 0017-ov5648-Fix-deadlock-on-I2C-error.patch
 - 0018-gc2155-Fix-deadlock-on-error.patch
 - 0019-ov5648-Add-1280x960-binned-mode.patch
 - 0020-ov5648-Make-1280x960-as-default-video-resolution.patch
 - 0021-MALATA-Fix-testCameraToSurfaceTextureMetadata-CTS.patch
 - 0023-OV5648-Added-5MP-video-resolution.patch

New changes introduced during the port:
 - Rename entity types to entity functions
 - Replace v4l2_subdev_fh by v4l2_subdev_pad_config
 - Make use of media_bus_format enum
 - Rename media_entity_init function to media_entity_pads_init
 - Replace try_mbus_fmt by set_fmt
 - Replace s_mbus_fmt by set_fmt
 - Replace g_mbus_fmt by get_fmt
 - Use s_ctrl/g_volatile_ctrl instead of ctrl core ops
 - Update gmin platform API path
 - Constify acpi_device_id
 - Add "INT5648" value to acpi_device_id
 - Fix some checkpatch errors and warnings
 - Remove FSF's mailing address from the sample GPL notice

Changes in v2:
 - Fix indentation
 - Add atomisp prefix to Kconfig option

"INT5648" ACPI device id can be found in following production hardware:
    BIOS Information
        Vendor: LENOVO
        Version: 1HCN40WW
        Release Date: 11/04/2016
        ...
        BIOS Revision: 0.40
        Firmware Revision: 0.0
    ...
    System Information
        Manufacturer: LENOVO
        Product Name: 80SG
        Version: MIIX 310-10ICR
        ...
        SKU Number: LENOVO_MT_80SG_BU_idea_FM_MIIX 310-10ICR
        Family: IDEAPAD
    ...

Device DSDT excerpt:
    Device (CA00)
    {
        Name (_ADR, Zero)  // _ADR: Address
        Name (_HID, "INT5648")  // _HID: Hardware ID
        Name (_CID, "INT5648")  // _CID: Compatible ID
        Name (_SUB, "INTL0000")  // _SUB: Subsystem ID
        Name (_DDN, "ov5648")  // _DDN: DOS Device Name
    ...

I was not able to properly test this patch on my Lenovo Miix 310 due to other
issues with atomisp, the output is the same as ov2680 driver (OVTI2680)
which is very similar.

Signed-off-by: Devid Antonio Floni <d.filoni@ubuntu.com>
---
 drivers/staging/media/atomisp/i2c/Kconfig          |   11 +
 drivers/staging/media/atomisp/i2c/Makefile         |    1 +
 drivers/staging/media/atomisp/i2c/atomisp-ov5648.c | 1867 ++++++++++++++++++++
 drivers/staging/media/atomisp/i2c/ov5648.h         |  835 +++++++++
 4 files changed, 2714 insertions(+)
 create mode 100644 drivers/staging/media/atomisp/i2c/atomisp-ov5648.c
 create mode 100644 drivers/staging/media/atomisp/i2c/ov5648.h

diff --git a/drivers/staging/media/atomisp/i2c/Kconfig b/drivers/staging/media/atomisp/i2c/Kconfig
index 09b1a97..87032ff 100644
--- a/drivers/staging/media/atomisp/i2c/Kconfig
+++ b/drivers/staging/media/atomisp/i2c/Kconfig
@@ -89,6 +89,17 @@ config VIDEO_ATOMISP_OV2680
 
 	 It currently only works with the atomisp driver.
 
+config VIDEO_ATOMISP_OV5648
+       tristate "Omnivision OV5648 sensor support"
+       depends on I2C && VIDEO_V4L2
+       ---help---
+	 This is a Video4Linux2 sensor-level driver for the Omnivision
+	 OV5648 raw camera.
+
+	 ov5648 is a 5M raw sensor.
+
+	 It currently only works with the atomisp driver.
+
 #
 # Kconfig for flash drivers
 #
diff --git a/drivers/staging/media/atomisp/i2c/Makefile b/drivers/staging/media/atomisp/i2c/Makefile
index 3d27c75..f9fcaef 100644
--- a/drivers/staging/media/atomisp/i2c/Makefile
+++ b/drivers/staging/media/atomisp/i2c/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_VIDEO_ATOMISP_MT9M114)    += atomisp-mt9m114.o
 obj-$(CONFIG_VIDEO_ATOMISP_GC2235)     += atomisp-gc2235.o
 obj-$(CONFIG_VIDEO_ATOMISP_OV2722)     += atomisp-ov2722.o
 obj-$(CONFIG_VIDEO_ATOMISP_OV2680)     += atomisp-ov2680.o
+obj-$(CONFIG_VIDEO_ATOMISP_OV5648)     += atomisp-ov5648.o
 obj-$(CONFIG_VIDEO_ATOMISP_GC0310)     += atomisp-gc0310.o
 
 obj-$(CONFIG_VIDEO_ATOMISP_MSRLIST_HELPER) += atomisp-libmsrlisthelper.o
diff --git a/drivers/staging/media/atomisp/i2c/atomisp-ov5648.c b/drivers/staging/media/atomisp/i2c/atomisp-ov5648.c
new file mode 100644
index 0000000..694698c
--- /dev/null
+++ b/drivers/staging/media/atomisp/i2c/atomisp-ov5648.c
@@ -0,0 +1,1867 @@
+/*
+ * Support for OmniVision OV5648 5M camera sensor.
+ * Based on OmniVision OV2722 driver.
+ *
+ * Copyright (c) 2013 Intel Corporation. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/string.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/kmod.h>
+#include <linux/device.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/gpio.h>
+#include <linux/moduleparam.h>
+#include <media/v4l2-device.h>
+#include <linux/io.h>
+#include "../include/linux/atomisp_gmin_platform.h"
+
+#include "ov5648.h"
+
+#define OV5648_DEBUG_EN 0
+
+#define H_FLIP_DEFAULT 1
+#define V_FLIP_DEFAULT 0
+static int h_flag = H_FLIP_DEFAULT;
+static int v_flag = V_FLIP_DEFAULT;
+
+/* i2c read/write stuff */
+static int ov5648_read_reg(struct i2c_client *client,
+			   u16 data_length, u16 reg, u16 *val)
+{
+	int err;
+	struct i2c_msg msg[2];
+	unsigned char data[6];
+
+	if (!client->adapter) {
+		dev_err(&client->dev, "%s error, no client->adapter\n",
+			__func__);
+		return -ENODEV;
+	}
+
+	if (data_length != OV5648_8BIT && data_length != OV5648_16BIT
+					&& data_length != OV5648_32BIT) {
+		dev_err(&client->dev, "%s error, invalid data length\n",
+			__func__);
+		return -EINVAL;
+	}
+
+	memset(msg, 0, sizeof(msg));
+
+	msg[0].addr = client->addr;
+	msg[0].flags = 0;
+	msg[0].len = I2C_MSG_LENGTH;
+	msg[0].buf = data;
+
+	/* high byte goes out first */
+	data[0] = (u8)(reg >> 8);
+	data[1] = (u8)(reg & 0xff);
+
+	msg[1].addr = client->addr;
+	msg[1].len = data_length;
+	msg[1].flags = I2C_M_RD;
+	msg[1].buf = data;
+
+	err = i2c_transfer(client->adapter, msg, 2);
+	if (err != 2) {
+		if (err >= 0)
+			err = -EIO;
+		dev_err(&client->dev,
+			"read from offset 0x%x error %d", reg, err);
+		return err;
+	}
+
+	*val = 0;
+	/* high byte comes first */
+	if (data_length == OV5648_8BIT)
+		*val = (u8)data[0];
+	else if (data_length == OV5648_16BIT)
+		*val = be16_to_cpu(*(u16 *)&data[0]);
+	else
+		*val = be32_to_cpu(*(u32 *)&data[0]);
+
+	return 0;
+}
+
+static int ov5648_i2c_write(struct i2c_client *client, u16 len, u8 *data)
+{
+	struct i2c_msg msg;
+	const int num_msg = 1;
+	int ret;
+
+	msg.addr = client->addr;
+	msg.flags = 0;
+	msg.len = len;
+	msg.buf = data;
+	ret = i2c_transfer(client->adapter, &msg, 1);
+
+	return ret == num_msg ? 0 : -EIO;
+}
+
+static int ov5648_write_reg(struct i2c_client *client, u16 data_length,
+			    u16 reg, u16 val)
+{
+	int ret;
+	unsigned char data[4] = {0};
+	u16 *wreg = (u16 *)data;
+	const u16 len = data_length + sizeof(u16); /* 16-bit address + data */
+
+	if (data_length != OV5648_8BIT && data_length != OV5648_16BIT) {
+		dev_err(&client->dev,
+			"%s error, invalid data_length\n", __func__);
+		return -EINVAL;
+	}
+
+	/* high byte goes out first */
+	*wreg = cpu_to_be16(reg);
+
+	if (data_length == OV5648_8BIT) {
+		data[2] = (u8)(val);
+	} else {
+		/* OV5648_16BIT */
+		u16 *wdata = (u16 *)&data[2];
+		*wdata = cpu_to_be16(val);
+	}
+
+	ret = ov5648_i2c_write(client, len, data);
+	if (ret)
+		dev_err(&client->dev,
+			"write error: wrote 0x%x to offset 0x%x error %d",
+			val, reg, ret);
+
+	return ret;
+}
+
+/*
+ * ov5648_write_reg_array - Initializes a list of OV5648 registers
+ * @client: i2c driver client structure
+ * @reglist: list of registers to be written
+ *
+ * This function initializes a list of registers. When consecutive addresses
+ * are found in a row on the list, this function creates a buffer and sends
+ * consecutive data in a single i2c_transfer().
+ *
+ * __ov5648_flush_reg_array, __ov5648_buf_reg_array() and
+ * __ov5648_write_reg_is_consecutive() are internal functions to
+ * ov5648_write_reg_array_fast() and should be not used anywhere else.
+ *
+ */
+
+static int __ov5648_flush_reg_array(struct i2c_client *client,
+				    struct ov5648_write_ctrl *ctrl)
+{
+	u16 size;
+
+	if (ctrl->index == 0)
+		return 0;
+
+	size = sizeof(u16) + ctrl->index; /* 16-bit address + data */
+	ctrl->buffer.addr = cpu_to_be16(ctrl->buffer.addr);
+	ctrl->index = 0;
+
+	return ov5648_i2c_write(client, size, (u8 *)&ctrl->buffer);
+}
+
+static int __ov5648_buf_reg_array(struct i2c_client *client,
+				  struct ov5648_write_ctrl *ctrl,
+				  const struct ov5648_reg *next)
+{
+	int size;
+	u16 *data16;
+
+	switch (next->type) {
+	case OV5648_8BIT:
+		size = 1;
+		ctrl->buffer.data[ctrl->index] = (u8)next->val;
+		break;
+	case OV5648_16BIT:
+		size = 2;
+		data16 = (u16 *)&ctrl->buffer.data[ctrl->index];
+		*data16 = cpu_to_be16((u16)next->val);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/* When first item is added, we need to store its starting address */
+	if (ctrl->index == 0)
+		ctrl->buffer.addr = next->reg;
+
+	ctrl->index += size;
+
+	/*
+	 * Buffer cannot guarantee free space for u32? Better flush it to avoid
+	 * possible lack of memory for next item.
+	 */
+	if (ctrl->index + sizeof(u16) >= OV5648_MAX_WRITE_BUF_SIZE)
+		return __ov5648_flush_reg_array(client, ctrl);
+
+	return 0;
+}
+
+static int __ov5648_write_reg_is_consecutive(struct i2c_client *client,
+					     struct ov5648_write_ctrl *ctrl,
+					     const struct ov5648_reg *next)
+{
+	if (ctrl->index == 0)
+		return 1;
+
+	return ctrl->buffer.addr + ctrl->index == next->reg;
+}
+
+static int ov5648_write_reg_array(struct i2c_client *client,
+				  const struct ov5648_reg *reglist)
+{
+	const struct ov5648_reg *next = reglist;
+	struct ov5648_write_ctrl ctrl;
+	int err;
+
+	ctrl.index = 0;
+	for (; next->type != OV5648_TOK_TERM; next++) {
+		switch (next->type & OV5648_TOK_MASK) {
+		case OV5648_TOK_DELAY:
+			err = __ov5648_flush_reg_array(client, &ctrl);
+			if (err)
+				return err;
+			msleep(next->val);
+			break;
+		default:
+			/*
+			 * If next address is not consecutive, data needs to be
+			 * flushed before proceed.
+			 */
+			if (!__ov5648_write_reg_is_consecutive(client, &ctrl,
+								next)) {
+				err = __ov5648_flush_reg_array(client, &ctrl);
+			if (err)
+				return err;
+			}
+			err = __ov5648_buf_reg_array(client, &ctrl, next);
+			if (err) {
+				dev_err(&client->dev, "%s: write error, aborted\n",
+					 __func__);
+				return err;
+			}
+			break;
+		}
+	}
+
+	return __ov5648_flush_reg_array(client, &ctrl);
+}
+static int ov5648_g_focal(struct v4l2_subdev *sd, s32 *val)
+{
+	*val = (OV5648_FOCAL_LENGTH_NUM << 16) | OV5648_FOCAL_LENGTH_DEM;
+	return 0;
+}
+
+static int ov5648_g_fnumber(struct v4l2_subdev *sd, s32 *val)
+{
+	/*const f number for imx*/
+	*val = (OV5648_F_NUMBER_DEFAULT_NUM << 16) | OV5648_F_NUMBER_DEM;
+	return 0;
+}
+
+static int ov5648_g_fnumber_range(struct v4l2_subdev *sd, s32 *val)
+{
+	*val = (OV5648_F_NUMBER_DEFAULT_NUM << 24) |
+		(OV5648_F_NUMBER_DEM << 16) |
+		(OV5648_F_NUMBER_DEFAULT_NUM << 8) | OV5648_F_NUMBER_DEM;
+	return 0;
+}
+
+static int ov5648_g_bin_factor_x(struct v4l2_subdev *sd, s32 *val)
+{
+	struct ov5648_device *dev = to_ov5648_sensor(sd);
+
+	*val = ov5648_res[dev->fmt_idx].bin_factor_x;
+
+	return 0;
+}
+
+static int ov5648_g_bin_factor_y(struct v4l2_subdev *sd, s32 *val)
+{
+	struct ov5648_device *dev = to_ov5648_sensor(sd);
+
+	*val = ov5648_res[dev->fmt_idx].bin_factor_y;
+
+	return 0;
+}
+
+static int ov5648_get_intg_factor(struct i2c_client *client,
+				struct camera_mipi_info *info,
+				const struct ov5648_resolution *res)
+{
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct ov5648_device *dev = to_ov5648_sensor(sd);
+	struct atomisp_sensor_mode_data *buf = &info->data;
+	unsigned int pix_clk_freq_hz;
+	u16 reg_val;
+	int ret;
+
+	if (!info)
+		return -EINVAL;
+
+	/* pixel clock */
+	pix_clk_freq_hz = res->pix_clk_freq * 1000000;
+
+	dev->vt_pix_clk_freq_mhz = pix_clk_freq_hz;
+	buf->vt_pix_clk_freq_mhz = pix_clk_freq_hz;
+
+	/* get integration time */
+	buf->coarse_integration_time_min = OV5648_COARSE_INTG_TIME_MIN;
+	buf->coarse_integration_time_max_margin =
+		OV5648_COARSE_INTG_TIME_MAX_MARGIN;
+
+	buf->fine_integration_time_min = OV5648_FINE_INTG_TIME_MIN;
+	buf->fine_integration_time_max_margin =
+		OV5648_FINE_INTG_TIME_MAX_MARGIN;
+
+	buf->fine_integration_time_def = OV5648_FINE_INTG_TIME_MIN;
+	buf->frame_length_lines = res->lines_per_frame;
+	buf->line_length_pck = res->pixels_per_line;
+	buf->read_mode = res->bin_mode;
+
+	/* get the cropping and output resolution to ISP for this mode. */
+	ret =  ov5648_read_reg(client, OV5648_16BIT,
+		OV5648_HORIZONTAL_START_H, &reg_val);
+	if (ret)
+		return ret;
+	buf->crop_horizontal_start = reg_val;
+
+	ret =  ov5648_read_reg(client, OV5648_16BIT,
+		OV5648_VERTICAL_START_H, &reg_val);
+	if (ret)
+		return ret;
+	buf->crop_vertical_start = reg_val;
+
+	ret = ov5648_read_reg(client, OV5648_16BIT,
+		OV5648_HORIZONTAL_END_H, &reg_val);
+	if (ret)
+		return ret;
+	buf->crop_horizontal_end = reg_val;
+
+	ret = ov5648_read_reg(client, OV5648_16BIT,
+		OV5648_VERTICAL_END_H, &reg_val);
+	if (ret)
+		return ret;
+	buf->crop_vertical_end = reg_val;
+
+	ret = ov5648_read_reg(client, OV5648_16BIT,
+		OV5648_HORIZONTAL_OUTPUT_SIZE_H, &reg_val);
+	if (ret)
+		return ret;
+	buf->output_width = reg_val;
+
+	ret = ov5648_read_reg(client, OV5648_16BIT,
+		OV5648_VERTICAL_OUTPUT_SIZE_H, &reg_val);
+	if (ret)
+		return ret;
+	buf->output_height = reg_val;
+
+	buf->binning_factor_x = res->bin_factor_x ?
+		res->bin_factor_x : 1;
+	buf->binning_factor_y = res->bin_factor_y ?
+		res->bin_factor_y : 1;
+	return 0;
+}
+
+static long __ov5648_set_exposure(struct v4l2_subdev *sd, int coarse_itg,
+				 int gain, int digitgain)
+
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct ov5648_device *dev = to_ov5648_sensor(sd);
+	u16 vts, hts;
+	int ret, exp_val, vts_val;
+	int temp;
+
+	if (dev->run_mode == CI_MODE_VIDEO)
+		ov5648_res = ov5648_res_video;
+	else if (dev->run_mode == CI_MODE_STILL_CAPTURE)
+		ov5648_res = ov5648_res_still;
+	else
+		ov5648_res = ov5648_res_preview;
+
+
+	hts = ov5648_res[dev->fmt_idx].pixels_per_line;
+	vts = ov5648_res[dev->fmt_idx].lines_per_frame;
+
+	/* group hold */
+	ret = ov5648_write_reg(client, OV5648_8BIT,
+		OV5648_GROUP_ACCESS, 0x00);
+	if (ret)
+		return ret;
+
+	/* Increase the VTS to match exposure + 4 */
+	if (coarse_itg + OV5648_INTEGRATION_TIME_MARGIN > vts)
+		vts_val = coarse_itg + OV5648_INTEGRATION_TIME_MARGIN;
+	else
+		vts_val = vts;
+	{
+		ret = ov5648_write_reg(client, OV5648_8BIT,
+			OV5648_TIMING_VTS_H, (vts_val >> 8) & 0xFF);
+		if (ret)
+			return ret;
+		ret = ov5648_write_reg(client, OV5648_8BIT,
+			OV5648_TIMING_VTS_L, vts_val & 0xFF);
+		if (ret)
+			return ret;
+	}
+
+	/* set exposure */
+	/* Lower four bit should be 0*/
+	exp_val = coarse_itg << 4;
+
+	ret = ov5648_write_reg(client, OV5648_8BIT,
+		OV5648_EXPOSURE_L, exp_val & 0xFF);
+	if (ret)
+		return ret;
+
+	ret = ov5648_write_reg(client, OV5648_8BIT,
+		OV5648_EXPOSURE_M, (exp_val >> 8) & 0xFF);
+	if (ret)
+		return ret;
+
+	ret = ov5648_write_reg(client, OV5648_8BIT,
+		OV5648_EXPOSURE_H, (exp_val >> 16) & 0x0F);
+	if (ret)
+		return ret;
+
+	/* Digital gain */
+	if (digitgain != dev->pre_digitgain) {
+		dev->pre_digitgain = digitgain;
+		temp = digitgain*(dev->current_otp.R_gain)>>10;
+		if (temp >= 0x400) {
+			ret = ov5648_write_reg(client, OV5648_16BIT,
+				OV5648_MWB_RED_GAIN_H, temp);
+			if (ret)
+				return ret;
+		}
+
+		temp = digitgain*(dev->current_otp.G_gain)>>10;
+		if (temp >= 0x400) {
+			ret = ov5648_write_reg(client, OV5648_16BIT,
+				OV5648_MWB_GREEN_GAIN_H, temp);
+			if (ret)
+				return ret;
+		}
+
+		temp = digitgain*(dev->current_otp.B_gain)>>10;
+		if (temp >= 0x400) {
+			ret = ov5648_write_reg(client, OV5648_16BIT,
+				OV5648_MWB_BLUE_GAIN_H, temp);
+			if (ret)
+				return ret;
+		}
+	}
+
+	/* Analog gain */
+	ret = ov5648_write_reg(client, OV5648_8BIT,
+		OV5648_AGC_L, gain & 0xff);
+	if (ret)
+		return ret;
+
+	ret = ov5648_write_reg(client, OV5648_8BIT,
+		OV5648_AGC_H, (gain >> 8) & 0xff);
+	if (ret)
+		return ret;
+
+	/* End group */
+	ret = ov5648_write_reg(client, OV5648_8BIT,
+		OV5648_GROUP_ACCESS, 0x10);
+	if (ret)
+		return ret;
+
+	/* Delay launch group */
+	ret = ov5648_write_reg(client, OV5648_8BIT,
+		OV5648_GROUP_ACCESS, 0xa0);
+	if (ret)
+		return ret;
+
+	return ret;
+}
+
+static int ov5648_set_exposure(struct v4l2_subdev *sd, int exposure,
+			       int gain, int digitgain)
+{
+	struct ov5648_device *dev = to_ov5648_sensor(sd);
+	int ret;
+
+	mutex_lock(&dev->input_lock);
+	ret = __ov5648_set_exposure(sd, exposure, gain, digitgain);
+	mutex_unlock(&dev->input_lock);
+
+	return ret;
+}
+
+static long ov5648_s_exposure(struct v4l2_subdev *sd,
+			      struct atomisp_exposure *exposure)
+{
+	int exp = exposure->integration_time[0];
+	int gain = exposure->gain[0];
+	int digitgain = exposure->gain[1];
+
+	/* we should not accept the invalid value below. */
+	if (gain == 0) {
+		struct i2c_client *client = v4l2_get_subdevdata(sd);
+		v4l2_err(client, "%s: invalid value\n", __func__);
+		return -EINVAL;
+	}
+
+	// EXPOSURE CONTROL DISABLED FOR INITIAL CHECKIN, TUNING DOESN'T WORK
+	return ov5648_set_exposure(sd, exp, gain, digitgain);
+}
+
+static long ov5648_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
+{
+
+	switch (cmd) {
+	case ATOMISP_IOC_S_EXPOSURE:
+		return ov5648_s_exposure(sd, arg);
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+/* This returns the exposure time being used. This should only be used
+   for filling in EXIF data, not for actual image processing. */
+static int ov5648_q_exposure(struct v4l2_subdev *sd, s32 *value)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	u16 reg_v, reg_v2;
+	int ret;
+
+	/* get exposure */
+	ret = ov5648_read_reg(client, OV5648_8BIT,
+					OV5648_EXPOSURE_L,
+					&reg_v);
+	if (ret)
+		goto err;
+
+	ret = ov5648_read_reg(client, OV5648_8BIT,
+					OV5648_EXPOSURE_M,
+					&reg_v2);
+	if (ret)
+		goto err;
+
+	reg_v += reg_v2 << 8;
+	ret = ov5648_read_reg(client, OV5648_8BIT,
+					OV5648_EXPOSURE_H,
+					&reg_v2);
+	if (ret)
+		goto err;
+
+	*value = reg_v + (((u32)reg_v2 << 16));
+err:
+	return ret;
+}
+
+static int ov5648_vcm_power_up(struct v4l2_subdev *sd)
+{
+	struct ov5648_device *dev = to_ov5648_sensor(sd);
+	struct camera_sensor_platform_data *pdata = dev->platform_data;
+	struct camera_vcm_control *vcm;
+
+	if (!dev->vcm_driver)
+		if (pdata && pdata->get_vcm_ctrl)
+			dev->vcm_driver =
+				pdata->get_vcm_ctrl(&dev->sd,
+						dev->camera_module);
+
+	vcm = dev->vcm_driver;
+	if (vcm && vcm->ops && vcm->ops->power_up)
+		return vcm->ops->power_up(sd, vcm);
+
+	return 0;
+}
+
+static int ov5648_vcm_power_down(struct v4l2_subdev *sd)
+{
+	struct ov5648_device *dev = to_ov5648_sensor(sd);
+	struct camera_vcm_control *vcm = dev->vcm_driver;
+
+	if (vcm && vcm->ops && vcm->ops->power_down)
+		return vcm->ops->power_down(sd, vcm);
+
+	return 0;
+}
+
+static int ov5648_v_flip(struct v4l2_subdev *sd, s32 value)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	int ret;
+	u16 val;
+
+	dev_dbg(&client->dev, "@%s: value:%d\n", __func__, value);
+	ret = ov5648_read_reg(client, OV5648_8BIT, OV5648_VFLIP_REG, &val);
+	if (ret)
+		return ret;
+	if (value) {
+		val |= OV5648_VFLIP_VALUE;
+	} else {
+		val &= ~OV5648_VFLIP_VALUE;
+	}
+	ret = ov5648_write_reg(client, OV5648_8BIT,
+			OV5648_VFLIP_REG, val);
+	if (ret)
+		return ret;
+	return ret;
+}
+
+static int ov5648_h_flip(struct v4l2_subdev *sd, s32 value)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	int ret;
+	u16 val;
+	dev_dbg(&client->dev, "@%s: value:%d\n", __func__, value);
+
+	ret = ov5648_read_reg(client, OV5648_8BIT, OV5648_HFLIP_REG, &val);
+	if (ret)
+		return ret;
+	if (value) {
+		val |= OV5648_HFLIP_VALUE;
+	} else {
+		val &= ~OV5648_HFLIP_VALUE;
+	}
+	ret = ov5648_write_reg(client, OV5648_8BIT,
+			OV5648_HFLIP_REG, val);
+	if (ret)
+		return ret;
+	return ret;
+}
+
+static int ov5648_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct ov5648_device *dev = container_of(ctrl->handler,
+		struct ov5648_device, ctrl_handler);
+	struct i2c_client *client = v4l2_get_subdevdata(&dev->sd);
+	int ret = 0;
+
+	switch (ctrl->id) {
+	case V4L2_CID_VFLIP:
+		dev_dbg(&client->dev, "%s: CID_VFLIP:%d.\n",
+			__func__, ctrl->val);
+		ret = ov5648_v_flip(&dev->sd, ctrl->val);
+		break;
+	case V4L2_CID_HFLIP:
+		dev_dbg(&client->dev, "%s: CID_HFLIP:%d.\n",
+			__func__, ctrl->val);
+		ret = ov5648_h_flip(&dev->sd, ctrl->val);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+	return ret;
+}
+
+static int ov5648_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct ov5648_device *dev = container_of(ctrl->handler,
+		struct ov5648_device, ctrl_handler);
+	int ret = 0;
+
+	switch (ctrl->id) {
+	case V4L2_CID_EXPOSURE_ABSOLUTE:
+		ret = ov5648_q_exposure(&dev->sd, &ctrl->val);
+		break;
+	case V4L2_CID_FOCAL_ABSOLUTE:
+		ret = ov5648_g_focal(&dev->sd, &ctrl->val);
+		break;
+	case V4L2_CID_FNUMBER_ABSOLUTE:
+		ret = ov5648_g_fnumber(&dev->sd, &ctrl->val);
+		break;
+	case V4L2_CID_FNUMBER_RANGE:
+		ret = ov5648_g_fnumber_range(&dev->sd, &ctrl->val);
+		break;
+	case V4L2_CID_BIN_FACTOR_HORZ:
+		ret = ov5648_g_bin_factor_x(&dev->sd, &ctrl->val);
+		break;
+	case V4L2_CID_BIN_FACTOR_VERT:
+		ret = ov5648_g_bin_factor_y(&dev->sd, &ctrl->val);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static const struct v4l2_ctrl_ops ctrl_ops = {
+	.s_ctrl = ov5648_s_ctrl,
+	.g_volatile_ctrl = ov5648_g_volatile_ctrl
+};
+
+struct v4l2_ctrl_config ov5648_controls[] = {
+	{
+	 .ops = &ctrl_ops,
+	 .id = V4L2_CID_EXPOSURE_ABSOLUTE,
+	 .type = V4L2_CTRL_TYPE_INTEGER,
+	 .name = "exposure",
+	 .min = 0x0,
+	 .max = 0xffff,
+	 .step = 0x01,
+	 .def = 0x00,
+	 .flags = 0,
+	},
+	{
+	 .ops = &ctrl_ops,
+	 .id = V4L2_CID_FOCAL_ABSOLUTE,
+	 .type = V4L2_CTRL_TYPE_INTEGER,
+	 .name = "focal length",
+	 .min = OV5648_FOCAL_LENGTH_DEFAULT,
+	 .max = OV5648_FOCAL_LENGTH_DEFAULT,
+	 .step = 0x01,
+	 .def = OV5648_FOCAL_LENGTH_DEFAULT,
+	 .flags = 0,
+	},
+	{
+	 .ops = &ctrl_ops,
+	 .id = V4L2_CID_FNUMBER_ABSOLUTE,
+	 .type = V4L2_CTRL_TYPE_INTEGER,
+	 .name = "f-number",
+	 .min = OV5648_F_NUMBER_DEFAULT,
+	 .max = OV5648_F_NUMBER_DEFAULT,
+	 .step = 0x01,
+	 .def = OV5648_F_NUMBER_DEFAULT,
+	 .flags = 0,
+	},
+	{
+	 .ops = &ctrl_ops,
+	 .id = V4L2_CID_FNUMBER_RANGE,
+	 .type = V4L2_CTRL_TYPE_INTEGER,
+	 .name = "f-number range",
+	 .min = OV5648_F_NUMBER_RANGE,
+	 .max =  OV5648_F_NUMBER_RANGE,
+	 .step = 0x01,
+	 .def = OV5648_F_NUMBER_RANGE,
+	 .flags = 0,
+	},
+	{
+	 .ops = &ctrl_ops,
+	 .id = V4L2_CID_BIN_FACTOR_HORZ,
+	 .type = V4L2_CTRL_TYPE_INTEGER,
+	 .name = "horizontal binning factor",
+	 .min = 0,
+	 .max = OV5648_BIN_FACTOR_MAX,
+	 .step = 1,
+	 .def = 0,
+	 .flags = 0,
+	},
+	{
+	 .ops = &ctrl_ops,
+	 .id = V4L2_CID_BIN_FACTOR_VERT,
+	 .type = V4L2_CTRL_TYPE_INTEGER,
+	 .name = "vertical binning factor",
+	 .min = 0,
+	 .max = OV5648_BIN_FACTOR_MAX,
+	 .step = 1,
+	 .def = 0,
+	 .flags = 0,
+	},
+	{
+	 .ops = &ctrl_ops,
+	 .id = V4L2_CID_VFLIP,
+	 .type = V4L2_CTRL_TYPE_BOOLEAN,
+	 .name = "Flip",
+	 .min = 0,
+	 .max = 1,
+	 .step = 1,
+	 .def = 0,
+	},
+	{
+	 .ops = &ctrl_ops,
+	 .id = V4L2_CID_HFLIP,
+	 .type = V4L2_CTRL_TYPE_BOOLEAN,
+	 .name = "Mirror",
+	 .min = 0,
+	 .max = 1,
+	 .step = 1,
+	 .def = 0,
+	},
+};
+
+static int ov5648_init(struct v4l2_subdev *sd)
+{
+	struct ov5648_device *dev = to_ov5648_sensor(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	int ret = 0;
+
+	mutex_lock(&dev->input_lock);
+
+	/* restore settings */
+	ov5648_res = ov5648_res_preview;
+	N_RES = N_RES_PREVIEW;
+
+	ret = ov5648_write_reg_array(client, ov5648_global_settings);
+	if (ret) {
+		dev_err(&client->dev, "ov5648 write global settings err.\n");
+		mutex_unlock(&dev->input_lock);
+		return ret;
+	}
+
+	mutex_unlock(&dev->input_lock);
+
+	return 0;
+}
+
+#if 1
+/*
+ *Camera driver need to load AWB calibration data
+ *stored in OTP and write to gain registers after
+ *initialization of register settings.
+ * index: index of otp group. (1, 2, 3)
+ * return: 0, group index is empty
+ *		1, group index has invalid data
+ *		2, group index has valid data
+ */
+static int check_otp(struct i2c_client *client, int index)
+{
+	int i;
+	u16 flag = 0, rg = 0, bg = 0;
+	if (index == 1) {
+		/* read otp --Bank 0 */
+		ov5648_write_reg(client, OV5648_8BIT, 0x3d84, 0xc0);
+		ov5648_write_reg(client, OV5648_8BIT, 0x3d85, 0x00);
+		ov5648_write_reg(client, OV5648_8BIT, 0x3d86, 0x0f);
+		ov5648_write_reg(client, OV5648_8BIT, 0x3d81, 0x01);
+		mdelay(5);
+		ov5648_read_reg(client, OV5648_8BIT, 0x3d05, &flag);
+		ov5648_read_reg(client, OV5648_8BIT, 0x3d07, &rg);
+		ov5648_read_reg(client, OV5648_8BIT, 0x3d08, &bg);
+	} else if (index == 2) {
+		/* read otp --Bank 0 */
+		ov5648_write_reg(client, OV5648_8BIT, 0x3d84, 0xc0);
+		ov5648_write_reg(client, OV5648_8BIT, 0x3d85, 0x00);
+		ov5648_write_reg(client, OV5648_8BIT, 0x3d86, 0x0f);
+		ov5648_write_reg(client, OV5648_8BIT, 0x3d81, 0x01);
+		mdelay(5);
+		ov5648_read_reg(client, OV5648_8BIT, 0x3d0e, &flag);
+
+		/* read otp --Bank 1 */
+		ov5648_write_reg(client, OV5648_8BIT, 0x3d84, 0xc0);
+		ov5648_write_reg(client, OV5648_8BIT, 0x3d85, 0x10);
+		ov5648_write_reg(client, OV5648_8BIT, 0x3d86, 0x1f);
+		ov5648_write_reg(client, OV5648_8BIT, 0x3d81, 0x01);
+		mdelay(5);
+		ov5648_read_reg(client, OV5648_8BIT, 0x3d00, &rg);
+		ov5648_read_reg(client, OV5648_8BIT, 0x3d01, &bg);
+	} else if (index == 3) {
+		/* read otp --Bank 1 */
+		ov5648_write_reg(client, OV5648_8BIT, 0x3d84, 0xc0);
+		ov5648_write_reg(client, OV5648_8BIT, 0x3d85, 0x10);
+		ov5648_write_reg(client, OV5648_8BIT, 0x3d86, 0x1f);
+		ov5648_write_reg(client, OV5648_8BIT, 0x3d81, 0x01);
+		mdelay(5);
+		ov5648_read_reg(client, OV5648_8BIT, 0x3d07, &flag);
+		ov5648_read_reg(client, OV5648_8BIT, 0x3d09, &rg);
+		ov5648_read_reg(client, OV5648_8BIT, 0x3d0a, &bg);
+	}
+
+	flag = flag & 0x80;
+
+	/* clear otp buffer */
+	for (i = 0; i < 16; i++)
+		ov5648_write_reg(client, OV5648_8BIT, 0x3d00 + i, 0x00);
+
+	if (flag)
+		return 1;
+	else {
+		if (rg == 0 && bg == 0)
+			return 0;
+		else
+			return 2;
+	}
+
+}
+
+/* index: index of otp group. (1, 2, 3)
+ * return: 0,
+ */
+static int read_otp(struct i2c_client *client,
+	    int index, struct otp_struct *otp_ptr)
+{
+	int i;
+	u16 temp;
+	/* read otp into buffer */
+	if (index == 1) {
+		/* read otp --Bank 0 */
+		ov5648_write_reg(client, OV5648_8BIT, 0x3d84, 0xc0);
+		ov5648_write_reg(client, OV5648_8BIT, 0x3d85, 0x00);
+		ov5648_write_reg(client, OV5648_8BIT, 0x3d86, 0x0f);
+		ov5648_write_reg(client, OV5648_8BIT, 0x3d81, 0x01);
+		mdelay(5);
+		ov5648_read_reg(client, OV5648_8BIT,
+			0x3d05, &((*otp_ptr).module_integrator_id));
+		(*otp_ptr).module_integrator_id =
+			(*otp_ptr).module_integrator_id & 0x7f;
+		ov5648_read_reg(client, OV5648_8BIT,
+			0x3d06, &((*otp_ptr).lens_id));
+		ov5648_read_reg(client, OV5648_8BIT, 0x3d0b, &temp);
+		ov5648_read_reg(client, OV5648_8BIT,
+			0x3d07, &((*otp_ptr).rg_ratio));
+		(*otp_ptr).rg_ratio =
+			((*otp_ptr).rg_ratio<<2) + ((temp>>6) & 0x03);
+		ov5648_read_reg(client, OV5648_8BIT,
+			0x3d08, &((*otp_ptr).bg_ratio));
+		(*otp_ptr).bg_ratio =
+			((*otp_ptr).bg_ratio<<2) + ((temp>>4) & 0x03);
+		ov5648_read_reg(client, OV5648_8BIT,
+			0x3d0c, &((*otp_ptr).light_rg));
+		(*otp_ptr).light_rg =
+			((*otp_ptr).light_rg<<2) + ((temp>>2) & 0x03);
+		ov5648_read_reg(client, OV5648_8BIT,
+			0x3d0d, &((*otp_ptr).light_bg));
+		(*otp_ptr).light_bg =
+			((*otp_ptr).light_bg<<2) + (temp & 0x03);
+		ov5648_read_reg(client, OV5648_8BIT,
+			0x3d09, &((*otp_ptr).user_data[0]));
+		ov5648_read_reg(client, OV5648_8BIT,
+			0x3d0a, &((*otp_ptr).user_data[1]));
+	} else if (index == 2) {
+		/* read otp --Bank 0 */
+		ov5648_write_reg(client, OV5648_8BIT, 0x3d84, 0xc0);
+		ov5648_write_reg(client, OV5648_8BIT, 0x3d85, 0x00);
+		ov5648_write_reg(client, OV5648_8BIT, 0x3d86, 0x0f);
+		ov5648_write_reg(client, OV5648_8BIT, 0x3d81, 0x01);
+		mdelay(5);
+		ov5648_read_reg(client, OV5648_8BIT,
+			0x3d0e, &((*otp_ptr).module_integrator_id));
+		(*otp_ptr).module_integrator_id =
+			(*otp_ptr).module_integrator_id & 0x7f;
+		ov5648_read_reg(client, OV5648_8BIT,
+			0x3d0f, &((*otp_ptr).lens_id));
+		/* read otp --Bank 1 */
+		ov5648_write_reg(client, OV5648_8BIT, 0x3d84, 0xc0);
+		ov5648_write_reg(client, OV5648_8BIT, 0x3d85, 0x10);
+		ov5648_write_reg(client, OV5648_8BIT, 0x3d86, 0x1f);
+		ov5648_write_reg(client, OV5648_8BIT, 0x3d81, 0x01);
+		mdelay(5);
+		ov5648_read_reg(client, OV5648_8BIT, 0x3d04, &temp);
+		ov5648_read_reg(client, OV5648_8BIT,
+			0x3d00, &((*otp_ptr).rg_ratio));
+		(*otp_ptr).rg_ratio =
+			((*otp_ptr).rg_ratio<<2) + ((temp>>6) & 0x03);
+		ov5648_read_reg(client, OV5648_8BIT,
+			0x3d01, &((*otp_ptr).bg_ratio));
+		(*otp_ptr).bg_ratio =
+			((*otp_ptr).bg_ratio<<2) + ((temp>>4) & 0x03);
+		ov5648_read_reg(client, OV5648_8BIT,
+			0x3d05, &((*otp_ptr).light_rg));
+		(*otp_ptr).light_rg =
+			((*otp_ptr).light_rg<<2) + ((temp>>2) & 0x03);
+		ov5648_read_reg(client, OV5648_8BIT,
+			0x3d06, &((*otp_ptr).light_bg));
+		(*otp_ptr).light_bg =
+			((*otp_ptr).light_bg<<2) + (temp & 0x03);
+		ov5648_read_reg(client, OV5648_8BIT,
+			0x3d02, &((*otp_ptr).user_data[0]));
+		ov5648_read_reg(client, OV5648_8BIT,
+			0x3d03, &((*otp_ptr).user_data[1]));
+	} else if (index == 3) {
+		/* read otp --Bank 1 */
+		ov5648_write_reg(client, OV5648_8BIT, 0x3d84, 0xc0);
+		ov5648_write_reg(client, OV5648_8BIT, 0x3d85, 0x10);
+		ov5648_write_reg(client, OV5648_8BIT, 0x3d86, 0x1f);
+		ov5648_write_reg(client, OV5648_8BIT, 0x3d81, 0x01);
+		mdelay(5);
+		ov5648_read_reg(client, OV5648_8BIT,
+			0x3d07, &((*otp_ptr).module_integrator_id));
+		(*otp_ptr).module_integrator_id =
+			(*otp_ptr).module_integrator_id & 0x7f;
+		ov5648_read_reg(client, OV5648_8BIT,
+			0x3d08, &((*otp_ptr).lens_id));
+		ov5648_read_reg(client, OV5648_8BIT, 0x3d0d, &temp);
+		ov5648_read_reg(client, OV5648_8BIT,
+			0x3d09, &((*otp_ptr).rg_ratio));
+		(*otp_ptr).rg_ratio =
+			((*otp_ptr).rg_ratio<<2) + ((temp>>6) & 0x03);
+		ov5648_read_reg(client, OV5648_8BIT,
+			0x3d0a, &((*otp_ptr).bg_ratio));
+		(*otp_ptr).bg_ratio =
+			((*otp_ptr).bg_ratio<<2) + ((temp>>4) & 0x03);
+		ov5648_read_reg(client, OV5648_8BIT,
+			0x3d0e, &((*otp_ptr).light_rg));
+		(*otp_ptr).light_rg =
+			((*otp_ptr).light_rg<<2) + ((temp>>2) & 0x03);
+		ov5648_read_reg(client, OV5648_8BIT,
+			0x3d0f, &((*otp_ptr).light_bg));
+		(*otp_ptr).light_bg =
+			((*otp_ptr).light_bg<<2) + (temp & 0x03);
+		ov5648_read_reg(client, OV5648_8BIT,
+			0x3d0b, &((*otp_ptr).user_data[0]));
+		ov5648_read_reg(client, OV5648_8BIT,
+			0x3d0c, &((*otp_ptr).user_data[1]));
+	}
+	/* clear otp buffer */
+	for (i = 0; i < 16; i++)
+		ov5648_write_reg(client, OV5648_8BIT, 0x3d00 + i, 0x00);
+
+	return 0;
+}
+/* R_gain, sensor red gain of AWB, 0x400 =1
+ * G_gain, sensor green gain of AWB, 0x400 =1
+ * B_gain, sensor blue gain of AWB, 0x400 =1
+ * return 0;
+ */
+static int update_awb_gain(struct v4l2_subdev *sd)
+{
+
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct ov5648_device *dev = to_ov5648_sensor(sd);
+	int R_gain = dev->current_otp.R_gain;
+	int G_gain = dev->current_otp.G_gain;
+	int B_gain = dev->current_otp.B_gain;
+	if (R_gain > 0x400) {
+		ov5648_write_reg(client, OV5648_8BIT, 0x5186, R_gain>>8);
+		ov5648_write_reg(client, OV5648_8BIT, 0x5187, R_gain & 0x00ff);
+	}
+	if (G_gain > 0x400) {
+		ov5648_write_reg(client, OV5648_8BIT, 0x5188, G_gain>>8);
+		ov5648_write_reg(client, OV5648_8BIT, 0x5189, G_gain & 0x00ff);
+	}
+	if (B_gain > 0x400) {
+		ov5648_write_reg(client, OV5648_8BIT, 0x518a, B_gain>>8);
+		ov5648_write_reg(client, OV5648_8BIT, 0x518b, B_gain & 0x00ff);
+	}
+	#ifdef OV5648_DEBUG_EN
+	dev_dbg(&client->dev, "_ov5648_: %s : rgain:%x ggain:%x bgain:%x\n", __func__, R_gain, G_gain, B_gain);
+	#endif
+	return 0;
+}
+
+/* call this function after OV5648 initialization
+ * return: 0 update success
+ *		1, no OTP
+ */
+static int update_otp(struct v4l2_subdev *sd)
+{
+	struct otp_struct current_otp;
+	struct ov5648_device *dev = to_ov5648_sensor(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	int i, ret;
+	int otp_index;
+	u16 temp;
+	int R_gain, G_gain, B_gain, G_gain_R, G_gain_B;
+	u16 rg = 1, bg = 1;
+
+	//otp valid after mipi on and sw stream on
+	ov5648_write_reg(client, OV5648_8BIT, OV5648_SW_STREAM, OV5648_START_STREAMING);
+
+	/* R/G and B/G of current camera module is read out from sensor OTP
+	 * check first OTP with valid data
+	 */
+	for (i = 1; i <= 3; i++) {
+		temp = check_otp(client, i);
+		if (temp == 2) {
+			otp_index = i;
+			break;
+		}
+	}
+	if (i > 3) {
+		printk(KERN_INFO"@%s: no valid wb otp data\n", __func__);
+		/* no valid wb OTP data */
+		return 1;
+	}
+	read_otp(client, otp_index, &current_otp);
+	if (current_otp.light_rg == 0) {
+		/* no light source information in OTP */
+		rg = current_otp.rg_ratio;
+	} else {
+		/* light source information found in OTP */
+		rg = current_otp.rg_ratio * (current_otp.light_rg + 512) / 1024;
+	}
+	if (current_otp.light_bg == 0) {
+		/* no light source information in OTP */
+		bg = current_otp.bg_ratio;
+	} else {
+		/* light source information found in OTP */
+		bg = current_otp.bg_ratio * (current_otp.light_bg + 512) / 1024;
+	}
+	#ifdef OV5648_DEBUG_EN
+	dev_dbg(&client->dev, "_ov5648_: %s : rg:%x bg:%x\n", __func__, rg, bg);
+	#endif
+	if (rg == 0)
+		rg = 1;
+	if (bg == 0)
+		bg = 1;
+	/*calculate G gain
+	 *0x400 = 1x gain
+	 */
+	if (bg < BG_Ratio_Typical) {
+		if (rg < RG_Ratio_Typical) {
+			/* current_otp.bg_ratio < BG_Ratio_typical &&
+			 * current_otp.rg_ratio < RG_Ratio_typical
+			 */
+			G_gain = 0x400;
+			B_gain = 0x400 * BG_Ratio_Typical / bg;
+			R_gain = 0x400 * RG_Ratio_Typical / rg;
+		} else {
+			/* current_otp.bg_ratio < BG_Ratio_typical &&
+			 * current_otp.rg_ratio >= RG_Ratio_typical
+			 */
+			R_gain = 0x400;
+			G_gain = 0x400 * rg / RG_Ratio_Typical;
+			B_gain = G_gain * BG_Ratio_Typical / bg;
+		}
+	} else {
+		if (rg < RG_Ratio_Typical) {
+			/* current_otp.bg_ratio >= BG_Ratio_typical &&
+			 * current_otp.rg_ratio < RG_Ratio_typical
+			 */
+			B_gain = 0x400;
+			G_gain = 0x400 * bg / BG_Ratio_Typical;
+			R_gain = G_gain * RG_Ratio_Typical / rg;
+		} else {
+			/* current_otp.bg_ratio >= BG_Ratio_typical &&
+			 * current_otp.rg_ratio >= RG_Ratio_typical
+			 */
+			G_gain_B = 0x400 * bg / BG_Ratio_Typical;
+			G_gain_R = 0x400 * rg / RG_Ratio_Typical;
+			if (G_gain_B > G_gain_R) {
+				B_gain = 0x400;
+				G_gain = G_gain_B;
+				R_gain = G_gain * RG_Ratio_Typical / rg;
+			} else {
+				R_gain = 0x400;
+				G_gain = G_gain_R;
+				B_gain = G_gain * BG_Ratio_Typical / bg;
+			}
+		}
+	}
+
+	dev->current_otp.R_gain = R_gain;
+	dev->current_otp.G_gain = G_gain;
+	dev->current_otp.B_gain = B_gain;
+
+	ret = ov5648_write_reg(client, OV5648_8BIT,
+		OV5648_SW_STREAM, OV5648_STOP_STREAMING);
+	return ret ;
+}
+
+#endif
+
+static int power_ctrl(struct v4l2_subdev *sd, bool flag)
+{
+	int ret = 0;
+	struct ov5648_device *dev = to_ov5648_sensor(sd);
+	if (!dev || !dev->platform_data)
+		return -ENODEV;
+
+	/* Non-gmin platforms use the legacy callback */
+	if (dev->platform_data->power_ctrl)
+		return dev->platform_data->power_ctrl(sd, flag);
+
+	if (flag) {
+		ret |= dev->platform_data->v1p8_ctrl(sd, 1);
+		ret |= dev->platform_data->v2p8_ctrl(sd, 1);
+		usleep_range(10000, 15000);
+	}
+
+	if (!flag || ret) {
+		ret |= dev->platform_data->v1p8_ctrl(sd, 0);
+		ret |= dev->platform_data->v2p8_ctrl(sd, 0);
+	}
+	return ret;
+}
+
+static int gpio_ctrl(struct v4l2_subdev *sd, bool flag)
+{
+	int ret;
+	struct ov5648_device *dev = to_ov5648_sensor(sd);
+
+	if (!dev || !dev->platform_data)
+		return -ENODEV;
+
+	/* Non-gmin platforms use the legacy callback */
+	if (dev->platform_data->gpio_ctrl)
+		return dev->platform_data->gpio_ctrl(sd, flag);
+
+	/* GPIO0 == "RESETB", GPIO1 == "PWDNB", named in opposite
+	 * senses but with the same behavior: both must be high for
+	 * the device to opperate */
+	if (flag) {
+		ret = dev->platform_data->gpio0_ctrl(sd, 1);
+		usleep_range(10000, 15000);
+		ret |= dev->platform_data->gpio1_ctrl(sd, 1);
+		usleep_range(10000, 15000);
+	} else {
+		ret = dev->platform_data->gpio1_ctrl(sd, 0);
+		ret |= dev->platform_data->gpio0_ctrl(sd, 0);
+	}
+	return ret;
+}
+
+static int power_up(struct v4l2_subdev *sd)
+{
+	struct ov5648_device *dev = to_ov5648_sensor(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	int ret;
+
+	dev_dbg(&client->dev, "@%s:\n", __func__);
+	if (!dev->platform_data) {
+		dev_err(&client->dev,
+			"no camera_sensor_platform_data");
+		return -ENODEV;
+	}
+
+	/* power control */
+	ret = power_ctrl(sd, 1);
+	if (ret)
+		goto fail_power;
+
+	/* according to DS, at least 5ms is needed between DOVDD and PWDN */
+	usleep_range(5000, 6000);
+
+	/* gpio ctrl */
+	ret = gpio_ctrl(sd, 1);
+	if (ret) {
+		ret = gpio_ctrl(sd, 1);
+		if (ret)
+			goto fail_power;
+	}
+
+	/* flis clock control */
+	ret = dev->platform_data->flisclk_ctrl(sd, 1);
+	if (ret)
+		goto fail_clk;
+
+	/* according to DS, 20ms is needed between PWDN and i2c access */
+	msleep(20);
+
+	return 0;
+
+fail_clk:
+	gpio_ctrl(sd, 0);
+fail_power:
+	power_ctrl(sd, 0);
+	dev_err(&client->dev, "sensor power-up failed\n");
+
+	return ret;
+}
+
+static int power_down(struct v4l2_subdev *sd)
+{
+	struct ov5648_device *dev = to_ov5648_sensor(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	int ret = 0;
+
+	h_flag = H_FLIP_DEFAULT;
+	v_flag = V_FLIP_DEFAULT;
+	dev_dbg(&client->dev, "@%s:\n", __func__);
+	if (!dev->platform_data) {
+		dev_err(&client->dev,
+			"no camera_sensor_platform_data");
+		return -ENODEV;
+	}
+
+	ret = dev->platform_data->flisclk_ctrl(sd, 0);
+	if (ret)
+		dev_err(&client->dev, "flisclk failed\n");
+
+	/* gpio ctrl */
+	ret = gpio_ctrl(sd, 0);
+	if (ret) {
+		ret = gpio_ctrl(sd, 0);
+		if (ret)
+			dev_err(&client->dev, "gpio failed 2\n");
+	}
+
+	/* power control */
+	ret = power_ctrl(sd, 0);
+	if (ret)
+		dev_err(&client->dev, "vprog failed.\n");
+
+	return ret;
+}
+
+static int ov5648_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	int ret = 0;
+
+	dev_dbg(&client->dev, "@%s:\n", __func__);
+	if (on == 0) {
+		ret = power_down(sd);
+		ret |= ov5648_vcm_power_down(sd);
+	} else {
+		ret = ov5648_vcm_power_up(sd);
+		if (ret)
+			return ret;
+
+		ret |= power_up(sd);
+		if (!ret)
+			return ov5648_init(sd);
+	}
+	return ret;
+}
+
+/*
+ * distance - calculate the distance
+ * @res: resolution
+ * @w: width
+ * @h: height
+ *
+ * Get the gap between resolution and w/h.
+ * res->width/height smaller than w/h wouldn't be considered.
+ * Returns the value of gap or -1 if fail.
+ */
+#define LARGEST_ALLOWED_RATIO_MISMATCH 900
+static int distance(struct ov5648_resolution *res, u32 w, u32 h)
+{
+	unsigned int w_ratio = ((res->width << 13) / w);
+	unsigned int h_ratio;
+	int match;
+
+	if (h == 0)
+		return -1;
+	h_ratio = ((res->height << 13) / h);
+	if (h_ratio == 0)
+		return -1;
+	match   = abs(((w_ratio << 13) / h_ratio) - ((int)8192));
+
+	if ((w_ratio < (int)8192) || (h_ratio < (int)8192)  ||
+		(match > LARGEST_ALLOWED_RATIO_MISMATCH))
+		return -1;
+
+	return w_ratio + h_ratio;
+}
+
+/* Return the nearest higher resolution index */
+static int nearest_resolution_index(int w, int h)
+{
+	int i;
+	int idx = -1;
+	int dist;
+	int min_dist = INT_MAX;
+	struct ov5648_resolution *tmp_res = NULL;
+
+	for (i = 0; i < N_RES; i++) {
+		tmp_res = &ov5648_res[i];
+		dist = distance(tmp_res, w, h);
+		if (dist == -1)
+			continue;
+		if (dist < min_dist) {
+			min_dist = dist;
+			idx = i;
+		}
+	}
+
+	return idx;
+}
+
+static int get_resolution_index(int w, int h)
+{
+	int i;
+
+	for (i = 0; i < N_RES; i++) {
+		if (w != ov5648_res[i].width)
+			continue;
+		if (h != ov5648_res[i].height)
+			continue;
+
+		return i;
+	}
+
+	return -1;
+}
+
+static int ov5648_set_fmt(struct v4l2_subdev *sd,
+			  struct v4l2_subdev_pad_config *cfg,
+			  struct v4l2_subdev_format *format)
+{
+	struct v4l2_mbus_framefmt *fmt = &format->format;
+	struct ov5648_device *dev = to_ov5648_sensor(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct camera_mipi_info *ov5648_info = NULL;
+	int ret = 0;
+	int idx;
+
+	if (format->pad)
+		return -EINVAL;
+
+	if (!fmt)
+		return -EINVAL;
+
+	ov5648_info = v4l2_get_subdev_hostdata(sd);
+	if (!ov5648_info)
+		return -EINVAL;
+
+	mutex_lock(&dev->input_lock);
+	idx = nearest_resolution_index(fmt->width,
+					fmt->height);
+	if (idx == -1) {
+		/* return the largest resolution */
+		fmt->width = ov5648_res[0].width;
+		fmt->height = ov5648_res[0].height;
+	} else {
+		fmt->width = ov5648_res[idx].width;
+		fmt->height = ov5648_res[idx].height;
+	}
+	fmt->code = MEDIA_BUS_FMT_SGRBG10_1X10;
+	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
+		cfg->try_fmt = *fmt;
+		mutex_unlock(&dev->input_lock);
+		return 0;
+		}
+	dev->fmt_idx = get_resolution_index(fmt->width,
+					      fmt->height);
+	if (dev->fmt_idx == -1) {
+		dev_err(&client->dev, "get resolution fail\n");
+		mutex_unlock(&dev->input_lock);
+		return -EINVAL;
+	}
+
+	ret = ov5648_write_reg_array(client, ov5648_res[dev->fmt_idx].regs);
+	if (ret)
+		dev_err(&client->dev, "ov5648 write register err.\n");
+	else if (dev->current_otp.otp_en == 1)
+		update_awb_gain(sd);
+
+	/*recall flip functions to avoid flip registers
+	 * were overrided by default setting
+	 */
+	if (h_flag)
+		ov5648_h_flip(sd, h_flag);
+	if (v_flag)
+		ov5648_v_flip(sd, v_flag);
+
+	ret = ov5648_get_intg_factor(client, ov5648_info,
+					&ov5648_res[dev->fmt_idx]);
+	if (ret) {
+		dev_err(&client->dev, "failed to get integration_factor\n");
+		goto err;
+	}
+
+err:
+	mutex_unlock(&dev->input_lock);
+	return ret;
+}
+
+static int ov5648_get_fmt(struct v4l2_subdev *sd,
+			  struct v4l2_subdev_pad_config *cfg,
+			  struct v4l2_subdev_format *format)
+{
+	struct v4l2_mbus_framefmt *fmt = &format->format;
+	struct ov5648_device *dev = to_ov5648_sensor(sd);
+
+	if (format->pad)
+		return -EINVAL;
+
+	if (!fmt)
+		return -EINVAL;
+
+	fmt->width = ov5648_res[dev->fmt_idx].width;
+	fmt->height = ov5648_res[dev->fmt_idx].height;
+	fmt->code = MEDIA_BUS_FMT_SBGGR10_1X10;
+
+	return 0;
+}
+
+static int ov5648_detect(struct i2c_client *client)
+{
+	struct i2c_adapter *adapter = client->adapter;
+	u16 high, low;
+	int ret;
+	u16 id;
+	u8 revision;
+
+	if (!i2c_check_functionality(adapter, I2C_FUNC_I2C))
+		return -ENODEV;
+
+	ret = ov5648_read_reg(client, OV5648_8BIT,
+					OV5648_SC_CMMN_CHIP_ID_H, &high);
+	if (ret) {
+		dev_err(&client->dev, "sensor_id_high = 0x%x\n", high);
+		return -ENODEV;
+	}
+	ret = ov5648_read_reg(client, OV5648_8BIT,
+					OV5648_SC_CMMN_CHIP_ID_L, &low);
+	id = ((((u16) high) << 8) | (u16) low);
+
+	if (id != OV5648_ID) {
+		dev_err(&client->dev, "sensor ID error\n");
+		return -ENODEV;
+	}
+
+	ret = ov5648_read_reg(client, OV5648_8BIT,
+					OV5648_SC_CMMN_SUB_ID, &high);
+	revision = (u8) high & 0x0f;
+
+	dev_dbg(&client->dev, "sensor_revision = 0x%x\n", revision);
+	dev_dbg(&client->dev, "detect ov5648 success\n");
+	return 0;
+}
+
+static int ov5648_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct ov5648_device *dev = to_ov5648_sensor(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	int ret;
+	dev_dbg(&client->dev, "@%s:\n", __func__);
+	mutex_lock(&dev->input_lock);
+
+	ret = ov5648_write_reg(client, OV5648_8BIT, OV5648_SW_STREAM,
+				enable ? OV5648_START_STREAMING :
+				OV5648_STOP_STREAMING);
+
+	mutex_unlock(&dev->input_lock);
+
+	return ret;
+}
+
+static int ov5648_s_config(struct v4l2_subdev *sd,
+			   int irq, void *platform_data)
+{
+	struct ov5648_device *dev = to_ov5648_sensor(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	int ret = 0;
+
+	if (!platform_data)
+		return -ENODEV;
+
+	dev->platform_data =
+		(struct camera_sensor_platform_data *)platform_data;
+
+	mutex_lock(&dev->input_lock);
+	/* power off the module, then power on it in future
+	 * as first power on by board may not fulfill the
+	 * power on sequqence needed by the module
+	 */
+	ret = power_down(sd);
+	if (ret) {
+		dev_err(&client->dev, "ov5648 power-off err.\n");
+		goto fail_power_off;
+	}
+
+	ret = power_up(sd);
+	if (ret) {
+		dev_err(&client->dev, "ov5648 power-up err.\n");
+		goto fail_power_on;
+	}
+
+	ret = dev->platform_data->csi_cfg(sd, 1);
+	if (ret)
+		goto fail_csi_cfg;
+
+	/* config & detect sensor */
+	ret = ov5648_detect(client);
+	if (ret) {
+		dev_err(&client->dev, "ov5648_detect err s_config.\n");
+		goto fail_csi_cfg;
+	}
+	if (dev->current_otp.otp_en == 1)
+		update_otp(sd);
+	/* turn off sensor, after probed */
+	ret = power_down(sd);
+	if (ret) {
+		dev_err(&client->dev, "ov5648 power-off err.\n");
+		goto fail_csi_cfg;
+	}
+	mutex_unlock(&dev->input_lock);
+
+	return 0;
+
+fail_csi_cfg:
+	dev->platform_data->csi_cfg(sd, 0);
+fail_power_on:
+	power_down(sd);
+	dev_err(&client->dev, "sensor power-gating failed\n");
+fail_power_off:
+	mutex_unlock(&dev->input_lock);
+	return ret;
+}
+
+static int ov5648_g_parm(struct v4l2_subdev *sd,
+			struct v4l2_streamparm *param)
+{
+	struct ov5648_device *dev = to_ov5648_sensor(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	if (!param)
+		return -EINVAL;
+
+	if (param->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+		dev_err(&client->dev,  "unsupported buffer type.\n");
+		return -EINVAL;
+	}
+
+	memset(param, 0, sizeof(*param));
+	param->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+
+	if (dev->fmt_idx >= 0 && dev->fmt_idx < N_RES) {
+		param->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
+		param->parm.capture.timeperframe.numerator = 1;
+		param->parm.capture.capturemode = dev->run_mode;
+		param->parm.capture.timeperframe.denominator =
+			ov5648_res[dev->fmt_idx].fps;
+	}
+	return 0;
+}
+
+static int ov5648_s_parm(struct v4l2_subdev *sd,
+			struct v4l2_streamparm *param)
+{
+	struct ov5648_device *dev = to_ov5648_sensor(sd);
+	dev->run_mode = param->parm.capture.capturemode;
+
+	mutex_lock(&dev->input_lock);
+	switch (dev->run_mode) {
+	case CI_MODE_VIDEO:
+		ov5648_res = ov5648_res_video;
+		N_RES = N_RES_VIDEO;
+		break;
+	case CI_MODE_STILL_CAPTURE:
+		ov5648_res = ov5648_res_still;
+		N_RES = N_RES_STILL;
+		break;
+	default:
+		ov5648_res = ov5648_res_preview;
+		N_RES = N_RES_PREVIEW;
+	}
+	mutex_unlock(&dev->input_lock);
+	return 0;
+}
+
+static int ov5648_g_frame_interval(struct v4l2_subdev *sd,
+				   struct v4l2_subdev_frame_interval *interval)
+{
+	struct ov5648_device *dev = to_ov5648_sensor(sd);
+
+	interval->interval.numerator = 1;
+	interval->interval.denominator = ov5648_res[dev->fmt_idx].fps;
+
+	return 0;
+}
+
+static int ov5648_enum_mbus_code(struct v4l2_subdev *sd,
+				 struct v4l2_subdev_pad_config *cfg,
+				 struct v4l2_subdev_mbus_code_enum *code)
+{
+	if (code->index >= MAX_FMTS)
+		return -EINVAL;
+
+	code->code = MEDIA_BUS_FMT_SBGGR10_1X10;
+	return 0;
+}
+
+static int ov5648_enum_frame_size(struct v4l2_subdev *sd,
+				  struct v4l2_subdev_pad_config *cfg,
+				  struct v4l2_subdev_frame_size_enum *fse)
+{
+	int index = fse->index;
+
+	if (index >= N_RES)
+		return -EINVAL;
+
+	fse->min_width = ov5648_res[index].width;
+	fse->min_height = ov5648_res[index].height;
+	fse->max_width = ov5648_res[index].width;
+	fse->max_height = ov5648_res[index].height;
+
+	return 0;
+
+}
+
+static int ov5648_g_skip_frames(struct v4l2_subdev *sd, u32 *frames)
+{
+	struct ov5648_device *dev = to_ov5648_sensor(sd);
+
+	mutex_lock(&dev->input_lock);
+	*frames = ov5648_res[dev->fmt_idx].skip_frames;
+	mutex_unlock(&dev->input_lock);
+
+	return 0;
+}
+
+
+static const struct v4l2_subdev_sensor_ops ov5648_sensor_ops = {
+	.g_skip_frames	= ov5648_g_skip_frames,
+};
+
+static const struct v4l2_subdev_video_ops ov5648_video_ops = {
+	.s_stream = ov5648_s_stream,
+	.g_parm = ov5648_g_parm,
+	.s_parm = ov5648_s_parm,
+	.g_frame_interval = ov5648_g_frame_interval,
+};
+
+static const struct v4l2_subdev_core_ops ov5648_core_ops = {
+	.s_power = ov5648_s_power,
+	.ioctl = ov5648_ioctl,
+};
+
+static const struct v4l2_subdev_pad_ops ov5648_pad_ops = {
+	.enum_mbus_code = ov5648_enum_mbus_code,
+	.enum_frame_size = ov5648_enum_frame_size,
+	.get_fmt = ov5648_get_fmt,
+	.set_fmt = ov5648_set_fmt,
+};
+
+static const struct v4l2_subdev_ops ov5648_ops = {
+	.core = &ov5648_core_ops,
+	.video = &ov5648_video_ops,
+	.pad = &ov5648_pad_ops,
+	.sensor = &ov5648_sensor_ops,
+};
+
+static int ov5648_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct ov5648_device *dev = to_ov5648_sensor(sd);
+	dev_dbg(&client->dev, "ov5648_remove...\n");
+
+	dev->platform_data->csi_cfg(sd, 0);
+
+	v4l2_device_unregister_subdev(sd);
+	media_entity_cleanup(&dev->sd.entity);
+	v4l2_ctrl_handler_free(&dev->ctrl_handler);
+	kfree(dev);
+
+	return 0;
+}
+
+static int ov5648_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
+{
+	struct ov5648_device *dev;
+	size_t len = CAMERA_MODULE_ID_LEN * sizeof(char);
+	int ret;
+	void *pdata;
+	unsigned int i;
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev) {
+		dev_err(&client->dev, "out of memory\n");
+		return -ENOMEM;
+	}
+
+	dev->camera_module = kzalloc(len, GFP_KERNEL);
+	if (!dev->camera_module) {
+		kfree(dev);
+		dev_err(&client->dev, "out of memory\n");
+		return -ENOMEM;
+	}
+
+	mutex_init(&dev->input_lock);
+
+	dev->fmt_idx = 0;
+	//otp functions
+	dev->current_otp.otp_en = 1;// enable otp functions
+	v4l2_i2c_subdev_init(&(dev->sd), client, &ov5648_ops);
+
+	if (gmin_get_config_var(&client->dev, "CameraModule",
+				dev->camera_module, &len)) {
+		kfree(dev->camera_module);
+		dev->camera_module = NULL;
+		dev_info(&client->dev, "Camera module id is missing\n");
+	}
+
+	if (ACPI_COMPANION(&client->dev))
+		pdata = gmin_camera_platform_data(&dev->sd,
+						  ATOMISP_INPUT_FORMAT_RAW_10,
+						  atomisp_bayer_order_bggr);
+	else
+		pdata = client->dev.platform_data;
+
+	if (!pdata) {
+		ret = -EINVAL;
+		goto out_free;
+	}
+
+	ret = ov5648_s_config(&dev->sd, client->irq, pdata);
+	if (ret)
+		goto out_free;
+
+	ret = atomisp_register_i2c_module(&dev->sd, pdata, RAW_CAMERA);
+	if (ret)
+		goto out_free;
+
+	dev->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	dev->pad.flags = MEDIA_PAD_FL_SOURCE;
+	dev->format.code = MEDIA_BUS_FMT_SBGGR10_1X10;
+	dev->sd.entity.function = MEDIA_ENT_F_CAM_SENSOR;
+	ret =
+	    v4l2_ctrl_handler_init(&dev->ctrl_handler,
+				   ARRAY_SIZE(ov5648_controls));
+	if (ret) {
+		ov5648_remove(client);
+		return ret;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(ov5648_controls); i++)
+		v4l2_ctrl_new_custom(&dev->ctrl_handler, &ov5648_controls[i],
+				     NULL);
+
+	if (dev->ctrl_handler.error) {
+		ov5648_remove(client);
+		return dev->ctrl_handler.error;
+	}
+
+	/* Use same lock for controls as for everything else. */
+	dev->ctrl_handler.lock = &dev->input_lock;
+	dev->sd.ctrl_handler = &dev->ctrl_handler;
+
+	ret = media_entity_pads_init(&dev->sd.entity, 1, &dev->pad);
+	if (ret)
+		ov5648_remove(client);
+
+	return ret;
+out_free:
+	v4l2_device_unregister_subdev(&dev->sd);
+	kfree(dev->camera_module);
+	kfree(dev);
+	return ret;
+}
+
+static const struct acpi_device_id ov5648_acpi_match[] = {
+	{"XXOV5648"},
+	{"INT5648"},
+	{},
+};
+MODULE_DEVICE_TABLE(acpi, ov5648_acpi_match);
+
+MODULE_DEVICE_TABLE(i2c, ov5648_id);
+static struct i2c_driver ov5648_driver = {
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = OV5648_NAME,
+		.acpi_match_table = ACPI_PTR(ov5648_acpi_match),
+	},
+	.probe = ov5648_probe,
+	.remove = ov5648_remove,
+	.id_table = ov5648_id,
+};
+
+static int init_ov5648(void)
+{
+	return i2c_add_driver(&ov5648_driver);
+}
+
+static void exit_ov5648(void)
+{
+
+	i2c_del_driver(&ov5648_driver);
+}
+
+module_init(init_ov5648);
+module_exit(exit_ov5648);
+
+MODULE_DESCRIPTION("A low-level driver for OmniVision 5648 sensors");
+MODULE_LICENSE("GPL");
diff --git a/drivers/staging/media/atomisp/i2c/ov5648.h b/drivers/staging/media/atomisp/i2c/ov5648.h
new file mode 100644
index 0000000..dc12726
--- /dev/null
+++ b/drivers/staging/media/atomisp/i2c/ov5648.h
@@ -0,0 +1,835 @@
+/*
+ * Support for OmniVision OV5648 5M camera sensor.
+ * Based on OmniVision OV2722 driver.
+ *
+ * Copyright (c) 2013 Intel Corporation. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __OV5648_H__
+#define __OV5648_H__
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/i2c.h>
+#include <linux/delay.h>
+#include <linux/videodev2.h>
+#include <linux/spinlock.h>
+#include <media/v4l2-subdev.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <linux/v4l2-mediabus.h>
+#include <media/media-entity.h>
+#include <linux/acpi.h>
+#include  "../include/linux/atomisp_platform.h"
+
+#define OV5648_NAME		"ov5648"
+
+/* Defines for register writes and register array processing */
+#define I2C_MSG_LENGTH		0x2
+#define I2C_RETRY_COUNT		5
+
+#define OV5648_FOCAL_LENGTH_NUM	334	/*3.34mm */
+#define OV5648_FOCAL_LENGTH_DEM	100
+#define OV5648_F_NUMBER_DEFAULT_NUM	28
+#define OV5648_F_NUMBER_DEM	10
+
+#define MAX_FMTS		1
+
+/* sensor_mode_data read_mode adaptation */
+#define OV5648_READ_MODE_BINNING_ON	0x0400
+#define OV5648_READ_MODE_BINNING_OFF	0x00
+#define OV5648_INTEGRATION_TIME_MARGIN	8
+
+#define OV5648_MAX_EXPOSURE_VALUE	0xFFF1
+#define OV5648_MAX_GAIN_VALUE		0xFF
+
+/*
+ * focal length bits definition:
+ * bits 31-16: numerator, bits 15-0: denominator
+ */
+#define OV5648_FOCAL_LENGTH_DEFAULT 0x1B70064
+
+/*
+ * current f-number bits definition:
+ * bits 31-16: numerator, bits 15-0: denominator
+ */
+#define OV5648_F_NUMBER_DEFAULT 0x18000a
+
+/*
+ * f-number range bits definition:
+ * bits 31-24: max f-number numerator
+ * bits 23-16: max f-number denominator
+ * bits 15-8: min f-number numerator
+ * bits 7-0: min f-number denominator
+ */
+#define OV5648_F_NUMBER_RANGE 0x180a180a
+#define OV5648_ID	0x5648
+
+#define OV5648_FINE_INTG_TIME_MIN 0
+#define OV5648_FINE_INTG_TIME_MAX_MARGIN 0
+#define OV5648_COARSE_INTG_TIME_MIN 1
+#define OV5648_COARSE_INTG_TIME_MAX_MARGIN 6
+
+#define OV5648_BIN_FACTOR_MAX 4
+/*
+ * OV5648 System control registers
+ */
+#define OV5648_SW_SLEEP			0x0100
+#define OV5648_SW_RESET			0x0103
+#define OV5648_SW_STREAM		0x0100
+
+#define OV5648_SC_CMMN_CHIP_ID_H	0x300A
+#define OV5648_SC_CMMN_CHIP_ID_L	0x300B
+#define OV5648_SC_CMMN_SCCB_ID		0x300C
+#define OV5648_SC_CMMN_SUB_ID		0x302A	/* process, version */
+
+#define OV5648_GROUP_ACCESS 0x3208 /*Bit[7:4] Group control, Bit[3:0] Group ID*/
+
+#define OV5648_EXPOSURE_H	0x3500 /*Bit[3:0] Bit[19:16] of exposure, remaining 16 bits lies in Reg0x3501&Reg0x3502*/
+#define OV5648_EXPOSURE_M	0x3501	/*Bit[15:8] of exposure*/
+#define OV5648_EXPOSURE_L	0x3502	/*Bit[7:0] of exposure*/
+#define OV5648_AGC_H		0x350A	/*Bit[1:0] means Bit[9:8] of gain */
+#define OV5648_AGC_L		0x350B	/*Bit[7:0] of gain */
+
+#define OV5648_HORIZONTAL_START_H	0x3800	/*Bit[11:8] */
+#define OV5648_HORIZONTAL_START_L	0x3801	/*Bit[7:0] */
+#define OV5648_VERTICAL_START_H		0x3802	/*Bit[11:8] */
+#define OV5648_VERTICAL_START_L		0x3803	/*Bit[7:0] */
+#define OV5648_HORIZONTAL_END_H		0x3804	/*Bit[11:8] */
+#define OV5648_HORIZONTAL_END_L		0x3805	/*Bit[7:0] */
+#define OV5648_VERTICAL_END_H		0x3806	/*Bit[11:8] */
+#define OV5648_VERTICAL_END_L		0x3807	/*Bit[7:0] */
+#define OV5648_HORIZONTAL_OUTPUT_SIZE_H	0x3808	/*Bit[3:0] */
+#define OV5648_HORIZONTAL_OUTPUT_SIZE_L	0x3809	/*Bit[7:0] */
+#define OV5648_VERTICAL_OUTPUT_SIZE_H	0x380a	/*Bit[3:0] */
+#define OV5648_VERTICAL_OUTPUT_SIZE_L	0x380b	/*Bit[7:0] */
+#define OV5648_TIMING_HTS_H		0x380C	/*HTS High 8-bit*/
+#define OV5648_TIMING_HTS_L		0x380D	/*HTS Low 8-bit*/
+#define OV5648_TIMING_VTS_H		0x380e	/*VTS High 8-bit */
+#define OV5648_TIMING_VTS_L		0x380f	/*VTS Low 8-bit*/
+
+#define OV5648_VFLIP_REG		0x3820
+#define OV5648_HFLIP_REG		0x3821
+#define OV5648_VFLIP_VALUE		0x06
+#define OV5648_HFLIP_VALUE		0x06
+
+#define OV5648_MWB_RED_GAIN_H		0x5186
+#define OV5648_MWB_GREEN_GAIN_H		0x5188
+#define OV5648_MWB_BLUE_GAIN_H		0x518A
+#define OV5648_MWB_GAIN_MAX		0x0fff
+
+#define OV5648_START_STREAMING		0x01
+#define OV5648_STOP_STREAMING		0x00
+
+// Add OTP operation
+#define BG_Ratio_Typical  0x16E
+#define RG_Ratio_Typical  0x189
+
+struct otp_struct {
+		u16 otp_en;
+		u16 module_integrator_id;
+		u16 lens_id;
+		u16 rg_ratio;
+		u16 bg_ratio;
+		u16 user_data[2];
+		u16 light_rg;
+		u16 light_bg;
+		int R_gain;
+		int G_gain;
+		int B_gain;
+};
+
+struct regval_list {
+	u16 reg_num;
+	u8 value;
+};
+
+struct ov5648_resolution {
+	u8 *desc;
+	const struct ov5648_reg *regs;
+	int res;
+	int width;
+	int height;
+	int fps;
+	int pix_clk_freq;
+	u32 skip_frames;
+	u16 pixels_per_line;
+	u16 lines_per_frame;
+	u8 bin_factor_x;
+	u8 bin_factor_y;
+	u8 bin_mode;
+	bool used;
+};
+
+struct ov5648_format {
+	u8 *desc;
+	u32 pixelformat;
+	struct ov5648_reg *regs;
+};
+
+/*
+ * ov5648 device structure.
+ */
+struct ov5648_device {
+	struct v4l2_subdev sd;
+	struct media_pad pad;
+	struct v4l2_mbus_framefmt format;
+	struct mutex input_lock;
+	struct v4l2_ctrl_handler ctrl_handler;
+
+	struct camera_sensor_platform_data *platform_data;
+	int vt_pix_clk_freq_mhz;
+	int fmt_idx;
+	int run_mode;
+	u8 res;
+	u8 type;
+
+	char *camera_module;
+	struct camera_vcm_control *vcm_driver;
+	struct otp_struct current_otp;
+	int pre_digitgain;
+};
+
+enum ov5648_tok_type {
+	OV5648_8BIT = 0x0001,
+	OV5648_16BIT = 0x0002,
+	OV5648_32BIT = 0x0004,
+	OV5648_TOK_TERM = 0xf000,/* terminating token for reg list */
+	OV5648_TOK_DELAY = 0xfe00,/* delay token for reg list */
+	OV5648_TOK_MASK = 0xfff0
+};
+
+/**
+ * struct ov5648_reg - MI sensor  register format
+ * @type: type of the register
+ * @reg: 16-bit offset to register
+ * @val: 8/16/32-bit register value
+ *
+ * Define a structure for sensor register initialization values
+ */
+struct ov5648_reg {
+	enum ov5648_tok_type type;
+	u16 reg;
+	u32 val;		/* @set value for read/mod/write, @mask */
+};
+
+#define to_ov5648_sensor(x) container_of(x, struct ov5648_device, sd)
+
+#define OV5648_MAX_WRITE_BUF_SIZE	30
+
+struct ov5648_write_buffer {
+	u16 addr;
+	u8 data[OV5648_MAX_WRITE_BUF_SIZE];
+};
+
+struct ov5648_write_ctrl {
+	int index;
+	struct ov5648_write_buffer buffer;
+};
+
+static const struct i2c_device_id ov5648_id[] = {
+	{OV5648_NAME, 0},
+	{}
+};
+
+static const struct ov5648_reg ov5648_global_settings[] = {
+	{OV5648_8BIT, 0x0103, 0x01},
+	{OV5648_8BIT, 0x3001, 0x00},
+	{OV5648_8BIT, 0x3002, 0x00},
+	{OV5648_8BIT, 0x3011, 0x02},
+	{OV5648_8BIT, 0x3017, 0x05},
+	{OV5648_8BIT, 0x3018, 0x4c},
+	{OV5648_8BIT, 0x301c, 0xd2},
+	{OV5648_8BIT, 0x3022, 0x00},
+	{OV5648_8BIT, 0x3034, 0x1a},
+	{OV5648_8BIT, 0x3035, 0x21},
+	{OV5648_8BIT, 0x3036, 0x69},
+	{OV5648_8BIT, 0x3037, 0x03},
+	{OV5648_8BIT, 0x3038, 0x00},
+	{OV5648_8BIT, 0x3039, 0x00},
+	{OV5648_8BIT, 0x303a, 0x00},
+	{OV5648_8BIT, 0x303b, 0x19},
+	{OV5648_8BIT, 0x303c, 0x11},
+	{OV5648_8BIT, 0x303d, 0x30},
+	{OV5648_8BIT, 0x3105, 0x11},
+	{OV5648_8BIT, 0x3106, 0x05},
+	{OV5648_8BIT, 0x3304, 0x28},
+	{OV5648_8BIT, 0x3305, 0x41},
+	{OV5648_8BIT, 0x3306, 0x30},
+	{OV5648_8BIT, 0x3308, 0x00},
+	{OV5648_8BIT, 0x3309, 0xc8},
+	{OV5648_8BIT, 0x330a, 0x01},
+	{OV5648_8BIT, 0x330b, 0x90},
+	{OV5648_8BIT, 0x330c, 0x02},
+	{OV5648_8BIT, 0x330d, 0x58},
+	{OV5648_8BIT, 0x330e, 0x03},
+	{OV5648_8BIT, 0x330f, 0x20},
+	{OV5648_8BIT, 0x3300, 0x00},
+	{OV5648_8BIT, 0x3500, 0x00},
+	{OV5648_8BIT, 0x3501, 0x7b},
+	{OV5648_8BIT, 0x3502, 0x00},
+	{OV5648_8BIT, 0x3503, 0x07},
+	{OV5648_8BIT, 0x350a, 0x00},
+	{OV5648_8BIT, 0x350b, 0x40},
+	{OV5648_8BIT, 0x3601, 0x33},
+	{OV5648_8BIT, 0x3602, 0x00},
+	{OV5648_8BIT, 0x3611, 0x0e},
+	{OV5648_8BIT, 0x3612, 0x2b},
+	{OV5648_8BIT, 0x3614, 0x50},
+	{OV5648_8BIT, 0x3620, 0x33},
+	{OV5648_8BIT, 0x3622, 0x00},
+	{OV5648_8BIT, 0x3630, 0xad},
+	{OV5648_8BIT, 0x3631, 0x00},
+	{OV5648_8BIT, 0x3632, 0x94},
+	{OV5648_8BIT, 0x3633, 0x17},
+	{OV5648_8BIT, 0x3634, 0x14},
+	{OV5648_8BIT, 0x3704, 0xc0},
+	{OV5648_8BIT, 0x3705, 0x2a},
+	{OV5648_8BIT, 0x3708, 0x63},
+	{OV5648_8BIT, 0x3709, 0x12},
+	{OV5648_8BIT, 0x370b, 0x23},
+	{OV5648_8BIT, 0x370c, 0xc0},
+	{OV5648_8BIT, 0x370d, 0x00},
+	{OV5648_8BIT, 0x370e, 0x00},
+	{OV5648_8BIT, 0x371c, 0x07},
+	{OV5648_8BIT, 0x3739, 0xd2},
+	{OV5648_8BIT, 0x373c, 0x00},
+	{OV5648_8BIT, 0x3800, 0x00},
+	{OV5648_8BIT, 0x3801, 0x00},
+	{OV5648_8BIT, 0x3802, 0x00},
+	{OV5648_8BIT, 0x3803, 0x00},
+	{OV5648_8BIT, 0x3804, 0x0a},
+	{OV5648_8BIT, 0x3805, 0x3f},
+	{OV5648_8BIT, 0x3806, 0x07},
+	{OV5648_8BIT, 0x3807, 0xa3},
+	{OV5648_8BIT, 0x3808, 0x0a},
+	{OV5648_8BIT, 0x3809, 0x20},
+	{OV5648_8BIT, 0x380a, 0x07},
+	{OV5648_8BIT, 0x380b, 0x98},
+	{OV5648_8BIT, 0x380c, 0x0b},
+	{OV5648_8BIT, 0x380d, 0x00},
+	{OV5648_8BIT, 0x380e, 0x07},
+	{OV5648_8BIT, 0x380f, 0xc0},
+	{OV5648_8BIT, 0x3810, 0x00},
+	{OV5648_8BIT, 0x3811, 0x10},
+	{OV5648_8BIT, 0x3812, 0x00},
+	{OV5648_8BIT, 0x3813, 0x06},
+	{OV5648_8BIT, 0x3814, 0x11},
+	{OV5648_8BIT, 0x3815, 0x11},
+	{OV5648_8BIT, 0x3817, 0x00},
+	{OV5648_8BIT, 0x3820, 0x40},
+	{OV5648_8BIT, 0x3821, 0x06},
+	{OV5648_8BIT, 0x3826, 0x03},
+	{OV5648_8BIT, 0x3829, 0x00},
+	{OV5648_8BIT, 0x382b, 0x0b},
+	{OV5648_8BIT, 0x3830, 0x00},
+	{OV5648_8BIT, 0x3836, 0x00},
+	{OV5648_8BIT, 0x3837, 0x00},
+	{OV5648_8BIT, 0x3838, 0x00},
+	{OV5648_8BIT, 0x3839, 0x04},
+	{OV5648_8BIT, 0x383a, 0x00},
+	{OV5648_8BIT, 0x383b, 0x01},
+	{OV5648_8BIT, 0x3b00, 0x00},
+	{OV5648_8BIT, 0x3b02, 0x08},
+	{OV5648_8BIT, 0x3b03, 0x00},
+	{OV5648_8BIT, 0x3b04, 0x04},
+	{OV5648_8BIT, 0x3b05, 0x00},
+	{OV5648_8BIT, 0x3b06, 0x04},
+	{OV5648_8BIT, 0x3b07, 0x08},
+	{OV5648_8BIT, 0x3b08, 0x00},
+	{OV5648_8BIT, 0x3b09, 0x02},
+	{OV5648_8BIT, 0x3b0a, 0x04},
+	{OV5648_8BIT, 0x3b0b, 0x00},
+	{OV5648_8BIT, 0x3b0c, 0x3d},
+	{OV5648_8BIT, 0x3f01, 0x0d},
+	{OV5648_8BIT, 0x3f0f, 0xf5},
+	{OV5648_8BIT, 0x4000, 0x89},
+	{OV5648_8BIT, 0x4001, 0x02},
+	{OV5648_8BIT, 0x4002, 0x45},
+	{OV5648_8BIT, 0x4004, 0x04},
+	{OV5648_8BIT, 0x4005, 0x18},
+	{OV5648_8BIT, 0x4006, 0x08},
+	{OV5648_8BIT, 0x4007, 0x10},
+	{OV5648_8BIT, 0x4008, 0x00},
+	{OV5648_8BIT, 0x4050, 0x6e},
+	{OV5648_8BIT, 0x4051, 0x8f},
+	{OV5648_8BIT, 0x4300, 0xf8},
+	{OV5648_8BIT, 0x4303, 0xff},
+	{OV5648_8BIT, 0x4304, 0x00},
+	{OV5648_8BIT, 0x4307, 0xff},
+	{OV5648_8BIT, 0x4520, 0x00},
+	{OV5648_8BIT, 0x4521, 0x00},
+	{OV5648_8BIT, 0x4511, 0x22},
+	{OV5648_8BIT, 0x4801, 0x0f},
+	{OV5648_8BIT, 0x4814, 0x2a},
+	{OV5648_8BIT, 0x481f, 0x3c},
+	{OV5648_8BIT, 0x4823, 0x3c},
+	{OV5648_8BIT, 0x4826, 0x00},
+	{OV5648_8BIT, 0x481b, 0x3c},
+	{OV5648_8BIT, 0x4827, 0x32},
+	{OV5648_8BIT, 0x4837, 0x17},
+	{OV5648_8BIT, 0x4b00, 0x06},
+	{OV5648_8BIT, 0x4b01, 0x0a},
+	{OV5648_8BIT, 0x4b04, 0x10},
+	{OV5648_8BIT, 0x5000, 0xff},
+	{OV5648_8BIT, 0x5001, 0x00},
+	{OV5648_8BIT, 0x5002, 0x41},
+	{OV5648_8BIT, 0x5003, 0x0a},
+	{OV5648_8BIT, 0x5004, 0x00},
+	{OV5648_8BIT, 0x5043, 0x00},
+	{OV5648_8BIT, 0x5013, 0x00},
+	{OV5648_8BIT, 0x501f, 0x03},
+	{OV5648_8BIT, 0x503d, 0x00},
+	{OV5648_8BIT, 0x5a00, 0x08},
+	{OV5648_8BIT, 0x5b00, 0x01},
+	{OV5648_8BIT, 0x5b01, 0x40},
+	{OV5648_8BIT, 0x5b02, 0x00},
+	{OV5648_8BIT, 0x5b03, 0xf0},
+	{OV5648_TOK_TERM, 0, 0}
+};
+
+/*
+ * Register settings for various resolution
+ */
+/*B720P(1296X736) 30fps 2lane 10Bit (Binning)*/
+static struct ov5648_reg const ov5648_720p_30fps_2lanes[] = {
+	{OV5648_8BIT, 0x3708, 0x66},
+	{OV5648_8BIT, 0x3709, 0x52},
+	{OV5648_8BIT, 0x370c, 0xcf},
+	{OV5648_8BIT, 0x3800, 0x00},/* xstart = 0 */
+	{OV5648_8BIT, 0x3801, 0x00},/*;xstart10 */
+	{OV5648_8BIT, 0x3802, 0x00},/* ystart = 226 */
+	{OV5648_8BIT, 0x3803, 0xe2},/* ystart ;fe */
+	{OV5648_8BIT, 0x3804, 0x0a},/* xend = 2607 */
+	{OV5648_8BIT, 0x3805, 0x2f},/* xend */
+	{OV5648_8BIT, 0x3806, 0x06},/* yend = 1701 */
+	{OV5648_8BIT, 0x3807, 0xa5},/* yend */
+	{OV5648_8BIT, 0x3808, 0x05},/* x output size = 1296 */
+	{OV5648_8BIT, 0x3809, 0x10},/*;x output size 00 */
+	{OV5648_8BIT, 0x380a, 0x02},/* y output size = 736 */
+	{OV5648_8BIT, 0x380b, 0xe0},/*;y output size d0 */
+	{OV5648_8BIT, 0x380c, 0x09},/* hts = 1864  2400 */
+	{OV5648_8BIT, 0x380d, 0x60},/* hts 48 */
+	{OV5648_8BIT, 0x380e, 0x04},/* vts = 754; 1120 */
+	{OV5648_8BIT, 0x380f, 0x60},/* vts f2 */
+	{OV5648_8BIT, 0x3810, 0x00},/* isp x win (offset)= 0 */
+	{OV5648_8BIT, 0x3811, 0x00},/* isp x win;08 */
+	{OV5648_8BIT, 0x3812, 0x00},/* isp y win (offset)= 0 */
+	{OV5648_8BIT, 0x3813, 0x00},/* isp y win;02 */
+	{OV5648_8BIT, 0x3814, 0x31},/* x inc */
+	{OV5648_8BIT, 0x3815, 0x31},/* y inc */
+	{OV5648_8BIT, 0x3817, 0x00},/* hsync start */
+	{OV5648_8BIT, 0x3820, 0x08},/* flip off; v bin off */
+	{OV5648_8BIT, 0x3821, 0x01},/* mirror off; h bin on */
+	{OV5648_8BIT, 0x4004, 0x02},/* black line number */
+	{OV5648_8BIT, 0x4005, 0x18},/* blc level trigger */
+	{OV5648_8BIT, 0x4837, 0x17},/* MIPI global timing ;2f;18 */
+
+	{OV5648_8BIT, 0x350b, 0x80},/* gain 8x */
+	{OV5648_8BIT, 0x3501, 0x2d},/* exposure */
+	{OV5648_8BIT, 0x3502, 0xc0},/* exposure */
+	/*;add 19.2MHz 30fps */
+
+	{OV5648_8BIT, 0x380e, 0x02},
+	{OV5648_8BIT, 0x380f, 0xf2},
+	{OV5648_8BIT, 0x3034, 0x1a},/* mipi 10bit mode */
+	{OV5648_8BIT, 0x3035, 0x21},
+	{OV5648_8BIT, 0x3036, 0x58},
+	{OV5648_8BIT, 0x3037, 0x02},
+	{OV5648_8BIT, 0x3038, 0x00},
+	{OV5648_8BIT, 0x3039, 0x00},
+	{OV5648_8BIT, 0x3106, 0x05},
+	{OV5648_8BIT, 0x3105, 0x11},
+	{OV5648_8BIT, 0x303a, 0x00},
+	{OV5648_8BIT, 0x303b, 0x16},
+	{OV5648_8BIT, 0x303c, 0x11},
+	{OV5648_8BIT, 0x303d, 0x20},
+
+	{OV5648_TOK_TERM, 0, 0}
+};
+
+/*B720P(1296X864) 30fps 2lane 10Bit (Binning)*/
+static struct ov5648_reg const ov5648_1296x864_30fps_2lanes[] = {
+	{OV5648_8BIT, 0x3708, 0x66},
+	{OV5648_8BIT, 0x3709, 0x52},
+	{OV5648_8BIT, 0x370c, 0xcf},
+	{OV5648_8BIT, 0x3800, 0x00},/* xstart = 0 */
+	{OV5648_8BIT, 0x3801, 0x00},/* xstart ;10 */
+	{OV5648_8BIT, 0x3802, 0x00},/* ystart = 98 */
+	{OV5648_8BIT, 0x3803, 0x62},/* ystart */
+	{OV5648_8BIT, 0x3804, 0x0a},/* xend = 2607 */
+	{OV5648_8BIT, 0x3805, 0x2f},/* xend */
+	{OV5648_8BIT, 0x3806, 0x07},/* yend = 1845 */
+	{OV5648_8BIT, 0x3807, 0x35},/* yend */
+	{OV5648_8BIT, 0x3808, 0x05},/* x output size = 1296 */
+	{OV5648_8BIT, 0x3809, 0x10},/*;x output size */
+	{OV5648_8BIT, 0x380a, 0x03},/* y output size = 864 */
+	{OV5648_8BIT, 0x380b, 0x60},/*;y output size */
+	{OV5648_8BIT, 0x380c, 0x09},/* hts = 1864 ;2400 */
+	{OV5648_8BIT, 0x380d, 0x60},/* hts48 */
+	{OV5648_8BIT, 0x380e, 0x04},/* vts = 754; 1120 */
+	{OV5648_8BIT, 0x380f, 0x60},/* vts f2 */
+	{OV5648_8BIT, 0x3810, 0x00},/* isp x win (offset)= 0 */
+	{OV5648_8BIT, 0x3811, 0x00},/* isp x win;08 */
+	{OV5648_8BIT, 0x3812, 0x00},/* isp y win (offset)= 0 */
+	{OV5648_8BIT, 0x3813, 0x00},/* isp y win;02 */
+	{OV5648_8BIT, 0x3814, 0x31},/* x inc */
+	{OV5648_8BIT, 0x3815, 0x31},/* y inc */
+	{OV5648_8BIT, 0x3817, 0x00},/* hsync start */
+	{OV5648_8BIT, 0x3820, 0x08},/* flip off; v bin off */
+	{OV5648_8BIT, 0x3821, 0x01},/* mirror off; h bin on */
+	{OV5648_8BIT, 0x4004, 0x02},/* black line number */
+	{OV5648_8BIT, 0x4005, 0x18},/* blc level trigger */
+	{OV5648_8BIT, 0x4837, 0x17},/* MIPI global timing ;2f;18 */
+
+	{OV5648_8BIT, 0x350b, 0x80},/* gain 8x */
+	{OV5648_8BIT, 0x3501, 0x35},/* exposure */
+	{OV5648_8BIT, 0x3502, 0xc0},/* exposure */
+	/*;add 19.2MHz 30fps*/
+
+	{OV5648_8BIT, 0x380e, 0x02},
+	{OV5648_8BIT, 0x380f, 0xf2},
+	{OV5648_8BIT, 0x3034, 0x1a},/* mipi 10bit mode */
+	{OV5648_8BIT, 0x3035, 0x21},
+	{OV5648_8BIT, 0x3036, 0x58},
+	{OV5648_8BIT, 0x3037, 0x02},
+	{OV5648_8BIT, 0x3038, 0x00},
+	{OV5648_8BIT, 0x3039, 0x00},
+	{OV5648_8BIT, 0x3106, 0x05},
+	{OV5648_8BIT, 0x3105, 0x11},
+	{OV5648_8BIT, 0x303a, 0x00},
+	{OV5648_8BIT, 0x303b, 0x16},
+	{OV5648_8BIT, 0x303c, 0x11},
+	{OV5648_8BIT, 0x303d, 0x20},
+
+	{OV5648_TOK_TERM, 0, 0}
+};
+
+static struct ov5648_reg const ov5648_1080p_30fps_2lanes[] = {
+	{OV5648_8BIT, 0x3708, 0x63},
+	{OV5648_8BIT, 0x3709, 0x12},
+	{OV5648_8BIT, 0x370c, 0xc0},
+	{OV5648_8BIT, 0x3800, 0x01},/* xstart = 320 */
+	{OV5648_8BIT, 0x3801, 0x40},/* xstart */
+	{OV5648_8BIT, 0x3802, 0x01},/* ystart = 418 */
+	{OV5648_8BIT, 0x3803, 0xa2},/* ystart */
+	{OV5648_8BIT, 0x3804, 0x08},/* xend = 2287 */
+	{OV5648_8BIT, 0x3805, 0xef},/* xend */
+	{OV5648_8BIT, 0x3806, 0x05},/* yend = 1521 */
+	{OV5648_8BIT, 0x3807, 0xf1},/* yend */
+	{OV5648_8BIT, 0x3808, 0x07},/* x output size = 1940 */
+	{OV5648_8BIT, 0x3809, 0x94},/* x output size */
+	{OV5648_8BIT, 0x380a, 0x04},/* y output size = 1096 */
+	{OV5648_8BIT, 0x380b, 0x48},/* y output size */
+	{OV5648_8BIT, 0x380c, 0x09},/* hts = 2500 */
+	{OV5648_8BIT, 0x380d, 0xc4},/* hts */
+	{OV5648_8BIT, 0x380e, 0x04},/* vts = 1120 */
+	{OV5648_8BIT, 0x380f, 0x60},/* vts */
+	{OV5648_8BIT, 0x3810, 0x00},/* isp x win = 16 */
+	{OV5648_8BIT, 0x3811, 0x10},/* isp x win */
+	{OV5648_8BIT, 0x3812, 0x00},/* isp y win = 4 */
+	{OV5648_8BIT, 0x3813, 0x04},/* isp y win */
+	{OV5648_8BIT, 0x3814, 0x11},/* x inc */
+	{OV5648_8BIT, 0x3815, 0x11},/* y inc */
+	{OV5648_8BIT, 0x3817, 0x00},/* hsync start */
+	{OV5648_8BIT, 0x3820, 0x40},/* flip off; v bin off */
+	{OV5648_8BIT, 0x3821, 0x06},/* mirror off; v bin off */
+	{OV5648_8BIT, 0x4004, 0x04},/* black line number */
+	{OV5648_8BIT, 0x4005, 0x18},/* blc always update */
+	{OV5648_8BIT, 0x4837, 0x18},/* MIPI global timing */
+
+	{OV5648_8BIT, 0x350b, 0x40},/* gain 4x */
+	{OV5648_8BIT, 0x3501, 0x45},/* exposure */
+	{OV5648_8BIT, 0x3502, 0x80},/* exposure */
+	/*;add 19.2MHz 30fps */
+
+	{OV5648_8BIT, 0x3034, 0x1a},/* mipi 10bit mode */
+	{OV5648_8BIT, 0x3035, 0x21},
+	{OV5648_8BIT, 0x3036, 0x58},
+	{OV5648_8BIT, 0x3037, 0x02},
+	{OV5648_8BIT, 0x3038, 0x00},
+	{OV5648_8BIT, 0x3039, 0x00},
+	{OV5648_8BIT, 0x3106, 0x05},
+	{OV5648_8BIT, 0x3105, 0x11},
+	{OV5648_8BIT, 0x303a, 0x00},
+	{OV5648_8BIT, 0x303b, 0x16},
+	{OV5648_8BIT, 0x303c, 0x11},
+	{OV5648_8BIT, 0x303d, 0x20},
+
+	{OV5648_TOK_TERM, 0, 0}
+};
+
+/* 2x2 subsampled 4:3 mode giving 1280x960.
+ * 84.48Mhz / (HTS*VTS) == 84.48e6/(2500*1126) == 30.01 fps */
+static struct ov5648_reg const ov5648_1280x960_30fps_2lanes[] = {
+	{OV5648_8BIT, 0x3034, 0x1a},
+	{OV5648_8BIT, 0x3035, 0x21},
+	{OV5648_8BIT, 0x3036, 0x58},
+	{OV5648_8BIT, 0x3037, 0x02},
+	{OV5648_8BIT, 0x3038, 0x00},
+	{OV5648_8BIT, 0x3039, 0x00},
+	{OV5648_8BIT, 0x3106, 0x05},
+	{OV5648_8BIT, 0x3105, 0x11},
+	{OV5648_8BIT, 0x303a, 0x00},
+	{OV5648_8BIT, 0x303b, 0x15},
+	{OV5648_8BIT, 0x303c, 0x11},
+	{OV5648_8BIT, 0x303d, 0x20},
+
+	{OV5648_8BIT, 0x350a, 0x00}, /* Def. analog gain = 0x040/16.0 = 4x */
+	{OV5648_8BIT, 0x350b, 0x40},
+	{OV5648_8BIT, 0x3501, 0x45}, /* Def. exposure = 0x45e0 (1118 lines) */
+	{OV5648_8BIT, 0x3502, 0xe0},
+
+	{OV5648_8BIT, 0x3708, 0x66},
+	{OV5648_8BIT, 0x3709, 0x52},
+	{OV5648_8BIT, 0x370c, 0xcf},
+
+	{OV5648_8BIT, 0x3800, 0x00}, /* Xstart = 0x0000 */
+	{OV5648_8BIT, 0x3801, 0x00},
+	{OV5648_8BIT, 0x3802, 0x00}, /* Ystart = 0x0000 */
+	{OV5648_8BIT, 0x3803, 0x00},
+	{OV5648_8BIT, 0x3804, 0x0a}, /* Xend = 0x0a3f = 2623 */
+	{OV5648_8BIT, 0x3805, 0x3f},
+	{OV5648_8BIT, 0x3806, 0x07}, /* Yend = 0x07a3 = 1955 */
+	{OV5648_8BIT, 0x3807, 0xa3},
+	{OV5648_8BIT, 0x3808, 0x05}, /* H output size = 0x0510 = 1280 */
+	{OV5648_8BIT, 0x3809, 0x00},
+	{OV5648_8BIT, 0x380a, 0x03}, /* V output size = 0x03cc = 960 */
+	{OV5648_8BIT, 0x380b, 0xc0},
+	{OV5648_8BIT, 0x380c, 0x09}, /* H total size = 0x09c4 = 2500 */
+	{OV5648_8BIT, 0x380d, 0xc4},
+	{OV5648_8BIT, 0x380e, 0x04}, /* V total size = 0x0466 = 1126 */
+	{OV5648_8BIT, 0x380f, 0x66},
+	{OV5648_8BIT, 0x3810, 0x00}, /* X window offset = 16 */
+	{OV5648_8BIT, 0x3811, 0x10},
+	{OV5648_8BIT, 0x3812, 0x00}, /* Y window offset = 10 */
+	{OV5648_8BIT, 0x3813, 0x0a},
+	{OV5648_8BIT, 0x3814, 0x31}, /* X subsample step: odd = 3, even = 1 */
+	{OV5648_8BIT, 0x3815, 0x31}, /* Y subsample step: odd = 3, even = 1 */
+	{OV5648_8BIT, 0x3817, 0x00}, /* HSync start = 0 */
+	{OV5648_8BIT, 0x3820, 0x08}, /* V flip off, V binning off */
+	{OV5648_8BIT, 0x3821, 0x07}, /* H mirror on, H binning on */
+
+	{OV5648_8BIT, 0x4004, 0x02},
+	{OV5648_8BIT, 0x4005, 0x18},
+	{OV5648_8BIT, 0x4837, 0x18},
+	{OV5648_TOK_TERM, 0, 0}
+};
+
+static struct ov5648_reg const ov5648_5M_15fps_2lanes[] = {
+	/*;add 19.2MHz */
+	{OV5648_8BIT, 0x3034, 0x1a},
+	{OV5648_8BIT, 0x3035, 0x21},
+	{OV5648_8BIT, 0x3036, 0x58},
+	{OV5648_8BIT, 0x3037, 0x02},
+	{OV5648_8BIT, 0x3038, 0x00},
+	{OV5648_8BIT, 0x3039, 0x00},
+	{OV5648_8BIT, 0x3106, 0x05},
+	{OV5648_8BIT, 0x3105, 0x11},
+	{OV5648_8BIT, 0x303a, 0x00},
+	{OV5648_8BIT, 0x303b, 0x16},
+	{OV5648_8BIT, 0x303c, 0x11},
+	{OV5648_8BIT, 0x303d, 0x20},
+
+	{OV5648_8BIT, 0x3708, 0x63},
+	{OV5648_8BIT, 0x3709, 0x12},
+	{OV5648_8BIT, 0x370c, 0xc0},
+	{OV5648_8BIT, 0x3800, 0x00},/* xstart = 0 */
+	{OV5648_8BIT, 0x3801, 0x00},/* xstart */
+	{OV5648_8BIT, 0x3802, 0x00},/* ystart = 0 */
+	{OV5648_8BIT, 0x3803, 0x00},/* ystart */
+	{OV5648_8BIT, 0x3804, 0x0a},/* xend = 2623 */
+	{OV5648_8BIT, 0x3805, 0x3f},/* xend */
+	{OV5648_8BIT, 0x3806, 0x07},/* yend = 1955 */
+	{OV5648_8BIT, 0x3807, 0xa3},/* yend */
+	{OV5648_8BIT, 0x3808, 0x0a},/* x output size = 2592 */
+	{OV5648_8BIT, 0x3809, 0x20},/* x output size */
+	{OV5648_8BIT, 0x380a, 0x07},/* y output size = 1944 */
+	{OV5648_8BIT, 0x380b, 0x98},/* y output size */
+	{OV5648_8BIT, 0x380c, 0x0b},/* hts = 2838 */
+	{OV5648_8BIT, 0x380d, 0x16},/* hts */
+	{OV5648_8BIT, 0x380e, 0x07},/* vts = 1984 */
+	{OV5648_8BIT, 0x380f, 0xc0},/* vts */
+	{OV5648_8BIT, 0x3810, 0x00},/* isp x win = 16 */
+	{OV5648_8BIT, 0x3811, 0x10},/* isp x win */
+	{OV5648_8BIT, 0x3812, 0x00},/* isp y win = 6 */
+	{OV5648_8BIT, 0x3813, 0x06},/* isp y win */
+	{OV5648_8BIT, 0x3814, 0x11},/* x inc */
+	{OV5648_8BIT, 0x3815, 0x11},/* y inc */
+	{OV5648_8BIT, 0x3817, 0x00},/* hsync start */
+	{OV5648_8BIT, 0x3820, 0x40},/* flip off; v bin off */
+	{OV5648_8BIT, 0x3821, 0x06},/* mirror off; v bin off */
+	{OV5648_8BIT, 0x4004, 0x04},/* black line number */
+	{OV5648_8BIT, 0x4005, 0x18},/* blc always update */
+	{OV5648_8BIT, 0x4837, 0x18},/* MIPI global timing */
+
+	{OV5648_8BIT, 0x350b, 0x40},
+	{OV5648_8BIT, 0x3501, 0x7b},
+	{OV5648_8BIT, 0x3502, 0x00},
+
+	{OV5648_TOK_TERM, 0, 0}
+};
+
+struct ov5648_resolution ov5648_res_preview[] = {
+	{
+	 .desc = "ov5648_5M_15fps",
+	 .width = 2592,
+	 .height = 1944,
+	 .pix_clk_freq = 84,
+	 .fps = 15,
+	 .used = 0,
+	 .pixels_per_line = 2838,
+	 .lines_per_frame = 1984,
+	 .bin_factor_x = 1,
+	 .bin_factor_y = 1,
+	 .bin_mode = 0,
+	 .skip_frames = 3,
+	 .regs = ov5648_5M_15fps_2lanes,
+	 },
+	{
+	 .desc = "ov5648_1280x960_30fps",
+	 .width = 1280,
+	 .height = 960,
+	 .pix_clk_freq = 84,
+	 .fps = 30,
+	 .used = 0,
+	 .pixels_per_line = 2500,
+	 .lines_per_frame = 1126,
+	 .bin_factor_x = 2,
+	 .bin_factor_y = 2,
+	 .bin_mode = 1,
+	 .skip_frames = 3,
+	 .regs = ov5648_1280x960_30fps_2lanes,
+	 },
+	{
+	 .desc = "ov5648_720P_30fps",
+	 .width = 1296,
+	 .height = 736,
+	 .fps = 30,
+	 .pix_clk_freq = 84,
+	 .used = 0,
+	 .pixels_per_line = 2397,
+	 .lines_per_frame = 1186,
+	 .bin_factor_x = 2,
+	 .bin_factor_y = 2,
+	 .bin_mode = 1,
+	 .skip_frames = 3,
+	 .regs = ov5648_720p_30fps_2lanes,
+	 },
+};
+
+#define N_RES_PREVIEW (ARRAY_SIZE(ov5648_res_preview))
+
+struct ov5648_resolution ov5648_res_still[] = {
+	{
+	 .desc = "ov5648_5M_15fps",
+	 .width = 2592,
+	 .height = 1944,
+	 .pix_clk_freq = 84,
+	 .fps = 15,
+	 .used = 0,
+	 .pixels_per_line = 2838,
+	 .lines_per_frame = 1984,
+	 .bin_factor_x = 1,
+	 .bin_factor_y = 1,
+	 .bin_mode = 0,
+	 .skip_frames = 3,
+	 .regs = ov5648_5M_15fps_2lanes,
+	 },
+	{
+	 .desc = "ov5648_1280x960_30fps",
+	 .width = 1280,
+	 .height = 960,
+	 .pix_clk_freq = 84,
+	 .fps = 30,
+	 .used = 0,
+	 .pixels_per_line = 2500,
+	 .lines_per_frame = 1126,
+	 .bin_factor_x = 2,
+	 .bin_factor_y = 2,
+	 .bin_mode = 1,
+	 .skip_frames = 3,
+	 .regs = ov5648_1280x960_30fps_2lanes,
+	 },
+	{
+	 .desc = "ov5648_720P_30fps",
+	 .width = 1296,
+	 .height = 736,
+	 .fps = 30,
+	 .pix_clk_freq = 84,
+	 .used = 0,
+	 .pixels_per_line = 2397,
+	 .lines_per_frame = 1186,
+	 .bin_factor_x = 2,
+	 .bin_factor_y = 2,
+	 .bin_mode = 1,
+	 .skip_frames = 3,
+	 .regs = ov5648_720p_30fps_2lanes,
+	 },
+};
+
+#define N_RES_STILL (ARRAY_SIZE(ov5648_res_still))
+
+struct ov5648_resolution ov5648_res_video[] = {
+	{
+	 .desc = "ov5648_5M_15fps",
+	 .width = 2592,
+	 .height = 1944,
+	 .pix_clk_freq = 84,
+	 .fps = 15,
+	 .used = 0,
+	 .pixels_per_line = 2838,
+	 .lines_per_frame = 1984,
+	 .bin_factor_x = 1,
+	 .bin_factor_y = 1,
+	 .bin_mode = 0,
+	 .skip_frames = 3,
+	 .regs = ov5648_5M_15fps_2lanes,
+	 },
+	{
+	 .desc = "ov5648_1280x960_30fps",
+	 .width = 1280,
+	 .height = 960,
+	 .pix_clk_freq = 84,
+	 .fps = 30,
+	 .used = 0,
+	 .pixels_per_line = 2500,
+	 .lines_per_frame = 1126,
+	 .bin_factor_x = 2,
+	 .bin_factor_y = 2,
+	 .bin_mode = 1,
+	 .skip_frames = 3,
+	 .regs = ov5648_1280x960_30fps_2lanes,
+	 },
+	{
+	 .desc = "ov5648_720P_30fps",
+	 .width = 1296,
+	 .height = 736,
+	 .fps = 30,
+	 .pix_clk_freq = 84,
+	 .used = 0,
+	 .pixels_per_line = 2397,
+	 .lines_per_frame = 1186,
+	 .bin_factor_x = 2,
+	 .bin_factor_y = 2,
+	 .bin_mode = 1,
+	 .skip_frames = 3,
+	 .regs = ov5648_720p_30fps_2lanes,
+	 },
+};
+
+#define N_RES_VIDEO (ARRAY_SIZE(ov5648_res_video))
+
+static struct ov5648_resolution *ov5648_res = ov5648_res_preview;
+static int N_RES = N_RES_PREVIEW;
+//static int has_otp = -1;	/*0:has valid otp, 1:no valid otp */
+
+#endif
-- 
2.7.4
