Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49782 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758269Ab2HJOQT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Aug 2012 10:16:19 -0400
Received: by mail-ey0-f174.google.com with SMTP id c11so519125eaa.19
        for <linux-media@vger.kernel.org>; Fri, 10 Aug 2012 07:16:18 -0700 (PDT)
From: Sangwook Lee <sangwook.lee@linaro.org>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com, suapapa@insignal.co.kr,
	quartz.jang@samsung.com, linaro-dev@lists.linaro.org,
	patches@linaro.org, usman.ahmad@linaro.org,
	Sangwook Lee <sangwook.lee@linaro.org>
Subject: [PATCH v4 2/2] v4l: Add v4l2 subdev driver for S5K4ECGX sensor
Date: Fri, 10 Aug 2012 15:14:56 +0100
Message-Id: <1344608096-22059-3-git-send-email-sangwook.lee@linaro.org>
In-Reply-To: <1344608096-22059-1-git-send-email-sangwook.lee@linaro.org>
References: <1344608096-22059-1-git-send-email-sangwook.lee@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver implements preview mode of the S5K4ECGX sensor.
capture (snapshot) operation, face detection are missing now.

Following controls are supported:
contrast/saturation/brightness/sharpness

Signed-off-by: Sangwook Lee <sangwook.lee@linaro.org>
---
 drivers/media/video/Kconfig    |    8 +
 drivers/media/video/Makefile   |    1 +
 drivers/media/video/s5k4ecgx.c |  941 ++++++++++++++++++++++++++++++++++++++++
 include/media/s5k4ecgx.h       |   37 ++
 4 files changed, 987 insertions(+)
 create mode 100644 drivers/media/video/s5k4ecgx.c
 create mode 100644 include/media/s5k4ecgx.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index c128fac..d405cb1 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -580,6 +580,14 @@ config VIDEO_S5K6AA
 	  This is a V4L2 sensor-level driver for Samsung S5K6AA(FX) 1.3M
 	  camera sensor with an embedded SoC image signal processor.
 
+config VIDEO_S5K4ECGX
+	tristate "Samsung S5K4ECGX sensor support"
+	depends on MEDIA_CAMERA_SUPPORT
+	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	---help---
+	  This is a V4L2 sensor-level driver for Samsung S5K4ECGX 5M
+	  camera sensor with an embedded SoC image signal processor.
+
 source "drivers/media/video/smiapp/Kconfig"
 
 comment "Flash devices"
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index b7da9fa..ec39c47 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -80,6 +80,7 @@ obj-$(CONFIG_VIDEO_SR030PC30)	+= sr030pc30.o
 obj-$(CONFIG_VIDEO_NOON010PC30)	+= noon010pc30.o
 obj-$(CONFIG_VIDEO_M5MOLS)	+= m5mols/
 obj-$(CONFIG_VIDEO_S5K6AA)	+= s5k6aa.o
+obj-$(CONFIG_VIDEO_S5K4ECGX)    += s5k4ecgx.o
 obj-$(CONFIG_VIDEO_SMIAPP)	+= smiapp/
 obj-$(CONFIG_VIDEO_ADP1653)	+= adp1653.o
 obj-$(CONFIG_VIDEO_AS3645A)	+= as3645a.o
diff --git a/drivers/media/video/s5k4ecgx.c b/drivers/media/video/s5k4ecgx.c
new file mode 100644
index 0000000..4e57738
--- /dev/null
+++ b/drivers/media/video/s5k4ecgx.c
@@ -0,0 +1,941 @@
+/*
+ * Driver for s5k4ecgx (5MP Camera) from Samsung
+ * a quarter-inch optical format 1.4 micron 5 megapixel (Mp)
+ * CMOS image sensor.
+ *
+ * Copyright (C) 2012, Linaro, Sangwook Lee <sangwook.lee@linaro.org>
+ * Copyright (C) 2012, Insignal Co,. Ltd,  Homin Lee <suapapa@insignal.co.kr>
+ *
+ * Based on s5k6aa, noon010pc30 driver
+ * Copyright (C) 2011, Samsung Electronics Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/clk.h>
+#include <linux/ctype.h>
+#include <linux/delay.h>
+#include <linux/firmware.h>
+#include <linux/gpio.h>
+#include <linux/i2c.h>
+#include <linux/module.h>
+#include <linux/regulator/consumer.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+
+#include <media/media-entity.h>
+#include <media/s5k4ecgx.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-mediabus.h>
+#include <media/v4l2-subdev.h>
+
+#include "s5k4ecgx_regs.h"
+
+static int debug;
+module_param(debug, int, 0644);
+
+#define S5K4ECGX_DRIVER_NAME		"s5k4ecgx"
+
+#define S5K4ECGX_FIRMWARE		"s5k4ecgx.fw"
+/* Firmware parsing token */
+#define FW_START_TOKEN			'{'
+#define FW_END_TOKEN			'}'
+
+/* Firmware revision information */
+#define REG_FW_REVISION			0x700001a6
+#define REG_FW_VERSION			0x700001a4
+#define S5K4ECGX_REVISION_1_1		0x11
+#define S5K4ECGX_FW_VERSION		0x4ec0
+
+/* General purpose parameters */
+#define REG_USER_BRIGHTNESS		0x7000022c /* Brigthness */
+#define REG_USER_CONTRAST		0x7000022e /* Contrast */
+#define REG_USER_SATURATION		0x70000230 /* Saturation */
+
+#define REG_USER_SHARP1			0x70000a28
+#define REG_USER_SHARP2			0x70000ade
+#define REG_USER_SHARP3			0x70000b94
+#define REG_USER_SHARP4			0x70000c4a
+#define REG_USER_SHARP5			0x70000d00
+
+/* Reduce sharpness range for user space API */
+#define SHARPNESS_DIV			8208
+#define TOK_TERM			0xffffffff
+
+/*
+ * FIMXE: This is copied from s5k6aa, because of no information
+ * in s5k4ecgx's datasheet
+ * H/W register Interface (0xd0000000 - 0xd0000fff)
+ */
+#define AHB_MSB_ADDR_PTR		0xfcfc
+#define GEN_REG_OFFSH			0xd000
+#define REG_CMDWR_ADDRH			0x0028
+#define REG_CMDWR_ADDRL			0x002a
+#define REG_CMDRD_ADDRH			0x002c
+#define REG_CMDRD_ADDRL			0x002e
+#define REG_CMDBUF0_ADDR		0x0f12
+
+/*
+ * Preview size lists supported by sensor
+ */
+static const struct regval_list *prev_regs[] = {
+	s5k4ecgx_176_prev,
+	s5k4ecgx_352_prev,
+	s5k4ecgx_640_prev,
+	s5k4ecgx_720_prev,
+};
+
+struct s5k4ecgx_frmsize {
+	u32 idx; /* Should indicate index of prev_regs */
+	u32 width;
+	u32 height;
+};
+
+/*
+ * TODO: currently only preview is supported and snapshopt(capture)
+ * is not implemented yet
+ */
+static const struct s5k4ecgx_frmsize s5k4ecgx_sizes[] = {
+	{0, 176, 144},
+	{1, 352, 288},
+	{2, 640, 480},
+	{3, 720, 480},
+};
+
+#define S5K4ECGX_NUM_PREV ARRAY_SIZE(s5k4ecgx_sizes)
+
+struct s5k4ecgx_format {
+	enum v4l2_mbus_pixelcode code;
+	u32 colorspace;
+};
+
+/* By default value, output from sensor will be YUV422 0-255 */
+static const struct s5k4ecgx_format s5k4ecgx_formats[] = {
+	{ V4L2_MBUS_FMT_YUYV8_2X8, V4L2_COLORSPACE_JPEG },
+};
+
+static const char * const s5k4ecgx_supply_names[] = {
+	/*
+	 * Usually 2.8v is used for analog power(vdda)
+	 * and digital IO(vddio, vddd_core)
+	 */
+	"vdda",
+	"vddio",
+	"vddcore",
+	"vddreg", /* vddreg is 1.8v for regulator input */
+};
+
+#define S5K4ECGX_NUM_SUPPLIES ARRAY_SIZE(s5k4ecgx_supply_names)
+
+enum s5k4ecgx_gpio_id {
+	STBY,
+	RST,
+	GPIO_NUM,
+};
+
+struct s5k4ecgx {
+	struct v4l2_subdev sd;
+	struct media_pad pad;
+	struct v4l2_ctrl_handler handler;
+
+	struct s5k4ecgx_platform_data *pdata;
+	const struct s5k4ecgx_format *curr_fmt;
+	const struct s5k4ecgx_frmsize *curr_win;
+	struct v4l2_fract timeperframe;
+	struct mutex lock;
+	int streaming;
+
+	struct regulator_bulk_data supplies[S5K4ECGX_NUM_SUPPLIES];
+	struct s5k4ecgx_gpio gpio[GPIO_NUM];
+};
+
+static inline struct s5k4ecgx *to_s5k4ecgx(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct s5k4ecgx, sd);
+}
+
+static int s5k4ecgx_i2c_read(struct i2c_client *client, u16 addr, u16 *val)
+{
+	u8 wbuf[2] = { addr >> 8, addr & 0xff };
+	struct i2c_msg msg[2];
+	u8 rbuf[2];
+	int ret;
+
+	msg[0].addr = client->addr;
+	msg[0].flags = 0;
+	msg[0].len = 2;
+	msg[0].buf = wbuf;
+
+	msg[1].addr = client->addr;
+	msg[1].flags = I2C_M_RD;
+	msg[1].len = 2;
+	msg[1].buf = rbuf;
+
+	ret = i2c_transfer(client->adapter, msg, 2);
+	*val = be16_to_cpu(*((u16 *)rbuf));
+
+	v4l2_dbg(4, debug, client, "i2c_read: 0x%04X : 0x%04x\n", addr, *val);
+
+	return ret == 2 ? 0 : ret;
+}
+
+static int s5k4ecgx_i2c_write(struct i2c_client *client, u16 addr, u16 val)
+{
+	u8 buf[4] = { addr >> 8, addr & 0xff, val >> 8, val & 0xff };
+
+	int ret = i2c_master_send(client, buf, 4);
+	v4l2_dbg(4, debug, client, "i2c_write: 0x%04X : 0x%04x\n", addr, val);
+
+	return ret == 4 ? 0 : ret;
+}
+
+static int s5k4ecgx_write(struct i2c_client *client, u32 addr, u16 val)
+{
+	int ret;
+	u16 high = addr >> 16, low =  addr & 0xffff;
+
+	ret = s5k4ecgx_i2c_write(client, REG_CMDWR_ADDRH, high);
+	ret |= s5k4ecgx_i2c_write(client, REG_CMDWR_ADDRL, low);
+	ret |= s5k4ecgx_i2c_write(client, REG_CMDBUF0_ADDR, val);
+	if (ret)
+		return -ENODEV;
+
+	return 0;
+}
+
+static int s5k4ecgx_read(struct i2c_client *client, u32 addr, u16 *val)
+{
+	int ret;
+	u16 high = addr >> 16, low =  addr & 0xffff;
+
+	ret  = s5k4ecgx_i2c_write(client, REG_CMDRD_ADDRH, high);
+	ret  |= s5k4ecgx_i2c_write(client, REG_CMDRD_ADDRL, low);
+	ret  |= s5k4ecgx_i2c_read(client, REG_CMDBUF0_ADDR, val);
+	if (ret) {
+		dev_err(&client->dev, "Failed to execute read command\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static int s5k4ecgx_write_array(struct v4l2_subdev *sd,
+				const struct regval_list *reg)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	u16 addr_incr = 0;
+	int ret;
+
+	while (reg->addr != TOK_TERM) {
+		if (addr_incr != 2)
+			ret = s5k4ecgx_write(client, reg->addr, reg->val);
+		else
+			ret = s5k4ecgx_i2c_write(client, REG_CMDBUF0_ADDR,
+						reg->val);
+		if (ret)
+			break;
+		/* Assume that msg->addr is always less than 0xfffc */
+		addr_incr = (reg + 1)->addr - reg->addr;
+		reg++;
+	}
+
+	return ret;
+}
+
+static int s5k4ecgx_read_fw_ver(struct v4l2_subdev *sd)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	u16 fw_ver, hw_rev;
+	int ret;
+
+	ret = s5k4ecgx_read(client, REG_FW_VERSION, &fw_ver);
+	if (fw_ver != S5K4ECGX_FW_VERSION && ret) {
+		v4l2_err(sd, "FW version check failed!");
+		return -ENODEV;
+	}
+
+	ret = s5k4ecgx_read(client, REG_FW_REVISION, &hw_rev);
+	if (ret)
+		return ret;
+
+	if (hw_rev == S5K4ECGX_REVISION_1_1) {
+		v4l2_info(sd, "chip found FW ver: 0x%x, HW rev: 0x%x\n",
+						fw_ver, hw_rev);
+	} else {
+		v4l2_err(sd, "Unknown H/W revision 0x%x\n", hw_rev);
+		return -ENODEV;
+	};
+
+	return 0;
+}
+
+static int s5k4ecgx_set_ahb_address(struct v4l2_subdev *sd)
+{
+	int ret;
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	/* Set APB peripherals start address */
+	ret = s5k4ecgx_i2c_write(client, AHB_MSB_ADDR_PTR, GEN_REG_OFFSH);
+	if (ret)
+		return ret;
+	/*
+	 * FIXME: This is copied from s5k6aa, because of no information
+	 * in s5k4ecgx's datasheet.
+	 * sw_reset is activated to put device into idle status
+	 */
+	ret = s5k4ecgx_i2c_write(client, 0x0010, 0x0001);
+	if (ret)
+		return ret;
+
+	/* FIXME: no information availalbe about this register */
+	ret = s5k4ecgx_i2c_write(client, 0x1030, 0x0000);
+	if (ret)
+		return ret;
+	/* Halt ARM CPU */
+	ret = s5k4ecgx_i2c_write(client, 0x0014, 0x0001);
+
+	return ret;
+}
+
+/**
+ * parse_line() - parse a line from a s5k4ecgx fimware file
+ *
+ * This function uses tokens to separate the patterns.
+ * The form of the pattern should be as follows:
+ * - use only C-sytle comments
+ * - use one "token address, value token" in a line
+ *	  ex) {0xd002020, 0x5a5a}
+ * - address should be a 32bit hex number
+ * - value should be a 16bit hex number
+ */
+static int parse_line(struct v4l2_subdev *sd, const struct firmware *fw,
+		      int offset, int *found, struct regval_list *reg)
+{
+	int ret;
+	u8 *p1 = (u8 *)(fw->data + offset);
+	u8 *p2 = p1;
+
+	*found = 0;
+	/* Skip leading white-space characters */
+	while (isspace(*p2))
+		p2++;
+	/* Skip empty last lines */
+	if (p2 == fw->data + fw->size)
+		return p2 - p1;
+
+	while (*p2 != '\n') {
+		/* Search for start token */
+		if (*p2 == FW_START_TOKEN) {
+			p2++;
+			ret = sscanf(p2, "%x,%hx", &reg->addr, &reg->val);
+			if (ret != 2)
+				return -EINVAL;
+			/* Fast forward as searching for end token */
+			while (*p2 != FW_END_TOKEN && *p2 != '\n') {
+				p2++;
+				if (p2 == fw->data + fw->size)
+					return -EINVAL;
+			}
+			if (*p2 != FW_END_TOKEN)
+				return -EINVAL;
+			*found = 1;
+		}
+		/* In case of missing '\n' in the last line */
+		if (p2 == fw->data + fw->size) {
+			v4l2_dbg(1, debug, sd, "Firmware: missing newline\n");
+			break;
+		}
+		p2++;
+	}
+
+	return p2 - p1;
+}
+
+static int parse_firmware(struct v4l2_subdev *sd, const struct firmware *fw)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	int count = 0, found, read_bytes, ret, total_read_bytes;
+	struct regval_list reg;
+	u32 addr_inc = 0;
+
+	for (total_read_bytes = 0; total_read_bytes < fw->size;) {
+		read_bytes = parse_line(sd, fw, total_read_bytes, &found, &reg);
+		if (read_bytes < 0) {
+			v4l2_err(sd, "Firmware: format error\n");
+			return -EINVAL;
+		}
+		total_read_bytes += read_bytes;
+		if (found) {
+			v4l2_dbg(4, debug, sd, "reg: add 0x%x val 0x%04hx\n",
+				 reg.addr, reg.val);
+			if (reg.addr - addr_inc != 2)
+				ret = s5k4ecgx_write(client, reg.addr, reg.val);
+			else
+				ret = s5k4ecgx_i2c_write(client,
+						REG_CMDBUF0_ADDR, reg.val);
+			if (ret)
+				return -EIO;
+			addr_inc = reg.addr;
+			count++; /* Save number of registers written */
+		}
+	}
+	v4l2_dbg(1, debug, client, "Wrote total %d registers\n", count);
+
+	return 0;
+}
+
+static int s5k4ecgx_load_firmware(struct v4l2_subdev *sd)
+{
+	const struct firmware *fw;
+	int err;
+
+	err = request_firmware(&fw, S5K4ECGX_FIRMWARE, sd->v4l2_dev->dev);
+	if (err) {
+		v4l2_err(sd, "Failed to read firmware %s\n", S5K4ECGX_FIRMWARE);
+		return -EINVAL;
+	}
+	err = parse_firmware(sd, fw);
+	if (err)
+		v4l2_err(sd, "Failed to parse firmware\n");
+	release_firmware(fw);
+
+	return err;
+}
+
+static int s5k4ecgx_init_sensor(struct v4l2_subdev *sd)
+{
+	int ret;
+
+	ret = s5k4ecgx_set_ahb_address(sd);
+	/* The delay is from manufacturer's settings */
+	msleep(100);
+
+	ret |= s5k4ecgx_load_firmware(sd);
+
+	if (ret)
+		v4l2_err(sd, "Failed to write initial settings\n");
+
+	return 0;
+}
+
+static int s5k4ecgx_gpio_set_value(struct s5k4ecgx *priv, int id, u32 val)
+{
+	if (!gpio_is_valid(priv->gpio[id].gpio))
+		return 0;
+	gpio_set_value(priv->gpio[id].gpio, val);
+
+	return 1;
+}
+
+static int __s5k4ecgx_power_on(struct s5k4ecgx *priv)
+{
+	int ret;
+
+	ret = regulator_bulk_enable(S5K4ECGX_NUM_SUPPLIES, priv->supplies);
+	if (ret)
+		return ret;
+	usleep_range(30, 50);
+
+	/* The polarity of STBY is controlled by TSP */
+	if (s5k4ecgx_gpio_set_value(priv, STBY, priv->gpio[STBY].level))
+		usleep_range(30, 50);
+
+	if (s5k4ecgx_gpio_set_value(priv, RST, priv->gpio[RST].level))
+		usleep_range(30, 50);
+
+	return 0;
+}
+
+static int __s5k4ecgx_power_off(struct s5k4ecgx *priv)
+{
+	if (s5k4ecgx_gpio_set_value(priv, RST, !priv->gpio[RST].level))
+		usleep_range(30, 50);
+
+	if (s5k4ecgx_gpio_set_value(priv, STBY, !priv->gpio[STBY].level))
+		usleep_range(30, 50);
+
+	priv->streaming = 0;
+
+	return regulator_bulk_disable(S5K4ECGX_NUM_SUPPLIES, priv->supplies);
+}
+
+/* Find nearest matching image pixel size. */
+static int s5k4ecgx_try_frame_size(struct v4l2_mbus_framefmt *mf,
+				  const struct s5k4ecgx_frmsize **size)
+{
+	unsigned int min_err = ~0;
+	int i = ARRAY_SIZE(s5k4ecgx_sizes);
+	const struct s5k4ecgx_frmsize *fsize = &s5k4ecgx_sizes[0],
+		*match = NULL;
+
+	while (i--) {
+		int err = abs(fsize->width - mf->width)
+				+ abs(fsize->height - mf->height);
+		if (err < min_err) {
+			min_err = err;
+			match = fsize;
+		}
+		fsize++;
+	}
+	if (match) {
+		mf->width  = match->width;
+		mf->height = match->height;
+		if (size)
+			*size = match;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static int s5k4ecgx_enum_mbus_code(struct v4l2_subdev *sd,
+				   struct v4l2_subdev_fh *fh,
+				   struct v4l2_subdev_mbus_code_enum *code)
+{
+	if (code->index >= ARRAY_SIZE(s5k4ecgx_formats))
+		return -EINVAL;
+	code->code = s5k4ecgx_formats[code->index].code;
+
+	return 0;
+}
+
+static int s5k4ecgx_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			   struct v4l2_subdev_format *fmt)
+{
+	struct s5k4ecgx *priv = to_s5k4ecgx(sd);
+	struct v4l2_mbus_framefmt *mf;
+
+	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
+		if (fh) {
+			mf = v4l2_subdev_get_try_format(fh, 0);
+			fmt->format = *mf;
+		}
+		return 0;
+	}
+	mf = &fmt->format;
+
+	mutex_lock(&priv->lock);
+	mf->width = priv->curr_win->width;
+	mf->height = priv->curr_win->height;
+	mf->code = priv->curr_fmt->code;
+	mf->colorspace = priv->curr_fmt->colorspace;
+	mf->field = V4L2_FIELD_NONE;
+	mutex_unlock(&priv->lock);
+
+	return 0;
+}
+
+static const struct s5k4ecgx_format *s5k4ecgx_try_fmt(struct v4l2_subdev *sd,
+					    struct v4l2_mbus_framefmt *mf)
+{
+	int i = ARRAY_SIZE(s5k4ecgx_formats);
+
+	while (--i)
+		if (mf->code == s5k4ecgx_formats[i].code)
+			break;
+	mf->code = s5k4ecgx_formats[i].code;
+
+	return &s5k4ecgx_formats[i];
+}
+
+static int s5k4ecgx_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			    struct v4l2_subdev_format *fmt)
+{
+	struct s5k4ecgx *priv = to_s5k4ecgx(sd);
+	const struct s5k4ecgx_frmsize *size = NULL;
+	const struct s5k4ecgx_format *sf;
+	struct v4l2_mbus_framefmt *mf;
+	int ret = 0;
+
+	sf = s5k4ecgx_try_fmt(sd, &fmt->format);
+	s5k4ecgx_try_frame_size(&fmt->format, &size);
+	fmt->format.colorspace = V4L2_COLORSPACE_JPEG;
+
+	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
+		if (fh) {
+			mf = v4l2_subdev_get_try_format(fh, 0);
+			*mf = fmt->format;
+		}
+		return 0;
+	}
+
+	mutex_lock(&priv->lock);
+	if (!priv->streaming) {
+		s5k4ecgx_try_frame_size(&fmt->format, &size);
+		priv->curr_win = size;
+		priv->curr_fmt = sf;
+	} else {
+		ret = -EBUSY;
+	}
+	mutex_unlock(&priv->lock);
+
+	return ret;
+}
+
+static const struct v4l2_subdev_pad_ops s5k4ecgx_pad_ops = {
+	.enum_mbus_code	= s5k4ecgx_enum_mbus_code,
+	.get_fmt	= s5k4ecgx_get_fmt,
+	.set_fmt	= s5k4ecgx_set_fmt,
+};
+
+/*
+ * V4L2 subdev controls
+ */
+static int s5k4ecgx_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+
+	struct v4l2_subdev *sd = &container_of(ctrl->handler, struct s5k4ecgx,
+						handler)->sd;
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct s5k4ecgx *priv = to_s5k4ecgx(sd);
+	int err;
+
+	v4l2_dbg(1, debug, sd, "ctrl: 0x%x, value: %d\n", ctrl->id, ctrl->val);
+
+	mutex_lock(&priv->lock);
+	switch (ctrl->id) {
+	case V4L2_CID_CONTRAST:
+		err = s5k4ecgx_write(client, REG_USER_CONTRAST, ctrl->val);
+		break;
+
+	case V4L2_CID_SATURATION:
+		err = s5k4ecgx_write(client, REG_USER_SATURATION, ctrl->val);
+		break;
+
+	case V4L2_CID_SHARPNESS:
+		ctrl->val *= SHARPNESS_DIV;
+		err = s5k4ecgx_write(client, REG_USER_SHARP1, ctrl->val);
+		err |= s5k4ecgx_write(client, REG_USER_SHARP2, ctrl->val);
+		err |= s5k4ecgx_write(client, REG_USER_SHARP3, ctrl->val);
+		err |= s5k4ecgx_write(client, REG_USER_SHARP4, ctrl->val);
+		err |= s5k4ecgx_write(client, REG_USER_SHARP5, ctrl->val);
+		break;
+
+	case V4L2_CID_BRIGHTNESS:
+		err = s5k4ecgx_write(client, REG_USER_BRIGHTNESS, ctrl->val);
+		break;
+	}
+	mutex_unlock(&priv->lock);
+	if (err < 0)
+		v4l2_err(sd, "Failed to write s_ctrl err %d\n", err);
+
+	return err;
+}
+
+static const struct v4l2_ctrl_ops s5k4ecgx_ctrl_ops = {
+	.s_ctrl = s5k4ecgx_s_ctrl,
+};
+
+/*
+ * Reading s5k4ecgx version information
+ */
+static int s5k4ecgx_registered(struct v4l2_subdev *sd)
+{
+	int ret;
+	struct s5k4ecgx *priv = to_s5k4ecgx(sd);
+
+	mutex_lock(&priv->lock);
+	ret = __s5k4ecgx_power_on(priv);
+	if (!ret) {
+		ret = s5k4ecgx_read_fw_ver(sd);
+		__s5k4ecgx_power_off(priv);
+	}
+	mutex_unlock(&priv->lock);
+
+	return ret;
+}
+
+/*
+ * V4L2 subdev internal operations
+ */
+static int s5k4ecgx_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+
+	struct v4l2_mbus_framefmt *mf = v4l2_subdev_get_try_format(fh, 0);
+
+	mf->width = s5k4ecgx_sizes[0].width;
+	mf->height = s5k4ecgx_sizes[0].height;
+	mf->code = s5k4ecgx_formats[0].code;
+	mf->colorspace = V4L2_COLORSPACE_JPEG;
+	mf->field = V4L2_FIELD_NONE;
+
+	return 0;
+}
+
+static const struct v4l2_subdev_internal_ops s5k4ecgx_subdev_internal_ops = {
+	.registered = s5k4ecgx_registered,
+	.open = s5k4ecgx_open,
+};
+
+static int s5k4ecgx_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct s5k4ecgx *priv = to_s5k4ecgx(sd);
+	int ret;
+
+	v4l2_dbg(1, debug, sd, "Switching %s\n", on ? "on" : "off");
+
+	if (on) {
+		ret = __s5k4ecgx_power_on(priv);
+		if (!ret) {
+			/* Time to stablize sensor */
+			msleep(100);
+			if (s5k4ecgx_init_sensor(sd) < 0) {
+				ret = __s5k4ecgx_power_off(priv);
+				return -EIO;
+			}
+		}
+	} else {
+		ret = __s5k4ecgx_power_off(priv);
+	}
+
+	return 0;
+}
+
+static int s5k4ecgx_log_status(struct v4l2_subdev *sd)
+{
+	v4l2_ctrl_handler_log_status(sd->ctrl_handler, sd->name);
+
+	return 0;
+}
+
+static const struct v4l2_subdev_core_ops s5k4ecgx_core_ops = {
+	.s_power	= s5k4ecgx_s_power,
+	.log_status	= s5k4ecgx_log_status,
+};
+
+static int __s5k4ecgx_s_stream(struct v4l2_subdev *sd, int on)
+{
+	struct s5k4ecgx *priv = to_s5k4ecgx(sd);
+	int err = 0;
+
+	if (on) {
+		err = s5k4ecgx_write_array(sd, prev_regs[priv->curr_win->idx]);
+		err |= s5k4ecgx_write_array(sd, s5k4ecgx_com1_prev);
+		err |= s5k4ecgx_write_array(sd, s5k4ecgx_com2_prev);
+	}
+
+	return err ? -EIO : 0;
+}
+
+static int s5k4ecgx_s_stream(struct v4l2_subdev *sd, int on)
+{
+	struct s5k4ecgx *priv = to_s5k4ecgx(sd);
+	int ret = 0;
+
+	v4l2_dbg(1, debug, sd, "Turn streaming %s\n", on ? "on" : "off");
+
+	mutex_lock(&priv->lock);
+	if (on) {
+		/* Ignore if s_stream is called twice */
+		if (!priv->streaming) {
+			ret = __s5k4ecgx_s_stream(sd, on);
+			if (!ret)
+				priv->streaming = 1;
+		}
+	}
+	mutex_unlock(&priv->lock);
+
+	return ret;
+}
+
+static const struct v4l2_subdev_video_ops s5k4ecgx_video_ops = {
+	.s_stream = s5k4ecgx_s_stream,
+};
+
+static const struct v4l2_subdev_ops s5k4ecgx_ops = {
+	.core = &s5k4ecgx_core_ops,
+	.pad = &s5k4ecgx_pad_ops,
+	.video = &s5k4ecgx_video_ops,
+};
+
+/*
+ * GPIO setup
+ */
+static int s5k4ecgx_config_gpio(int nr, int val, const char *name)
+{
+	unsigned long flags = val ? GPIOF_OUT_INIT_HIGH : GPIOF_OUT_INIT_LOW;
+	int ret;
+
+	if (!gpio_is_valid(nr))
+		return 0;
+	ret = gpio_request_one(nr, flags, name);
+	if (!ret)
+		gpio_export(nr, 0);
+
+	return ret;
+}
+
+static void s5k4ecgx_free_gpios(struct s5k4ecgx *priv)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(priv->gpio); i++) {
+		if (!gpio_is_valid(priv->gpio[i].gpio))
+			continue;
+		gpio_free(priv->gpio[i].gpio);
+		priv->gpio[i].gpio = -EINVAL;
+	}
+}
+
+static int s5k4ecgx_config_gpios(struct s5k4ecgx *priv,
+				  const struct s5k4ecgx_platform_data *pdata)
+{
+	const struct s5k4ecgx_gpio *gpio = &pdata->gpio_stby;
+	int ret;
+
+	priv->gpio[STBY].gpio = -EINVAL;
+	priv->gpio[RST].gpio  = -EINVAL;
+
+	ret = s5k4ecgx_config_gpio(gpio->gpio, gpio->level, "S5K4ECGX_STBY");
+
+	if (ret) {
+		s5k4ecgx_free_gpios(priv);
+		return ret;
+	}
+	priv->gpio[STBY] = *gpio;
+	if (gpio_is_valid(gpio->gpio))
+		gpio_set_value(gpio->gpio, 0);
+
+	gpio = &pdata->gpio_reset;
+
+	ret = s5k4ecgx_config_gpio(gpio->gpio, gpio->level, "S5K4ECGX_RST");
+	if (ret) {
+		s5k4ecgx_free_gpios(priv);
+		return ret;
+	}
+	priv->gpio[RST] = *gpio;
+	if (gpio_is_valid(gpio->gpio))
+		gpio_set_value(gpio->gpio, 0);
+
+	return 0;
+}
+
+static int s5k4ecgx_init_v4l2_ctrls(struct s5k4ecgx *priv)
+{
+	const struct v4l2_ctrl_ops *ops = &s5k4ecgx_ctrl_ops;
+	struct v4l2_ctrl_handler *hdl = &priv->handler;
+	int ret;
+
+	ret =  v4l2_ctrl_handler_init(hdl, 4);
+	if (ret)
+		return ret;
+
+	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_BRIGHTNESS, -208, 127, 1, 0);
+	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_CONTRAST, -127, 127, 1, 0);
+	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_SATURATION, -127, 127, 1, 0);
+
+	/* Sharpness default is 24612, and then (24612/SHARPNESS_DIV) = 2 */
+	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_SHARPNESS, -32704/SHARPNESS_DIV,
+			  24612/SHARPNESS_DIV, 1, 2);
+	if (hdl->error) {
+		ret = hdl->error;
+		v4l2_ctrl_handler_free(hdl);
+		return ret;
+	}
+	priv->sd.ctrl_handler = hdl;
+
+	return 0;
+};
+
+static int s5k4ecgx_probe(struct i2c_client *client,
+			  const struct i2c_device_id *id)
+{
+	int	ret, i;
+	struct v4l2_subdev *sd;
+	struct s5k4ecgx *priv;
+	struct s5k4ecgx_platform_data *pdata = client->dev.platform_data;
+
+	if (pdata == NULL) {
+		dev_err(&client->dev, "platform data is missing!\n");
+		return -EINVAL;
+	}
+	priv = devm_kzalloc(&client->dev, sizeof(struct s5k4ecgx), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	mutex_init(&priv->lock);
+	priv->streaming = 0;
+
+	sd = &priv->sd;
+	/* Registering subdev */
+	v4l2_i2c_subdev_init(sd, client, &s5k4ecgx_ops);
+	strlcpy(sd->name, S5K4ECGX_DRIVER_NAME, sizeof(sd->name));
+
+	sd->internal_ops = &s5k4ecgx_subdev_internal_ops;
+	/* Support v4l2 sub-device userspace API */
+	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+
+	priv->pad.flags = MEDIA_PAD_FL_SOURCE;
+	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
+	ret = media_entity_init(&sd->entity, 1, &priv->pad, 0);
+	if (ret)
+		return ret;
+
+	ret = s5k4ecgx_config_gpios(priv, pdata);
+	if (ret) {
+		dev_err(&client->dev, "Failed to set gpios\n");
+		goto out_err1;
+	}
+	for (i = 0; i < S5K4ECGX_NUM_SUPPLIES; i++)
+		priv->supplies[i].supply = s5k4ecgx_supply_names[i];
+
+	ret = devm_regulator_bulk_get(&client->dev, S5K4ECGX_NUM_SUPPLIES,
+				 priv->supplies);
+	if (ret) {
+		dev_err(&client->dev, "Failed to get regulators\n");
+		goto out_err2;
+	}
+	ret = s5k4ecgx_init_v4l2_ctrls(priv);
+	if (ret)
+		goto out_err2;
+
+	return 0;
+
+out_err2:
+	s5k4ecgx_free_gpios(priv);
+out_err1:
+	media_entity_cleanup(&priv->sd.entity);
+
+	return ret;
+}
+
+static int s5k4ecgx_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct s5k4ecgx *priv = to_s5k4ecgx(sd);
+
+	mutex_destroy(&priv->lock);
+	v4l2_device_unregister_subdev(sd);
+	v4l2_ctrl_handler_free(&priv->handler);
+	media_entity_cleanup(&sd->entity);
+
+	return 0;
+}
+
+static const struct i2c_device_id s5k4ecgx_id[] = {
+	{ S5K4ECGX_DRIVER_NAME, 0 },
+	{}
+};
+MODULE_DEVICE_TABLE(i2c, s5k4ecgx_id);
+
+static struct i2c_driver v4l2_i2c_driver = {
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name = S5K4ECGX_DRIVER_NAME,
+	},
+	.probe = s5k4ecgx_probe,
+	.remove = s5k4ecgx_remove,
+	.id_table = s5k4ecgx_id,
+};
+
+module_i2c_driver(v4l2_i2c_driver);
+
+MODULE_DESCRIPTION("Samsung S5K4ECGX 5MP SOC camera");
+MODULE_AUTHOR("Sangwook Lee <sangwook.lee@linaro.org>");
+MODULE_AUTHOR("Seok-Young Jang <quartz.jang@samsung.com>");
+MODULE_LICENSE("GPL");
+MODULE_FIRMWARE(S5K4ECGX_FIRMWARE);
diff --git a/include/media/s5k4ecgx.h b/include/media/s5k4ecgx.h
new file mode 100644
index 0000000..fbed5cb
--- /dev/null
+++ b/include/media/s5k4ecgx.h
@@ -0,0 +1,37 @@
+/*
+ * S5K4ECGX image sensor header file
+ *
+ * Copyright (C) 2012, Linaro
+ * Copyright (C) 2011, Samsung Electronics Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef S5K4ECGX_H
+#define S5K4ECGX_H
+
+/**
+ * struct s5k4ecgx_gpio - data structure describing a GPIO
+ * @gpio : GPIO number
+ * @level: indicates active state of the @gpio
+ */
+struct s5k4ecgx_gpio {
+	int gpio;
+	int level;
+};
+
+/**
+ * struct ss5k4ecgx_platform_data- s5k4ecgx driver platform data
+ * @gpio_reset:	 GPIO driving RESET pin
+ * @gpio_stby :	 GPIO driving STBY pin
+ */
+
+struct s5k4ecgx_platform_data {
+	struct s5k4ecgx_gpio gpio_reset;
+	struct s5k4ecgx_gpio gpio_stby;
+};
+
+#endif /* S5K4ECGX_H */
-- 
1.7.9.5

