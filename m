Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:14787 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab3AKOcO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jan 2013 09:32:14 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MGG00002TM5ZC60@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 11 Jan 2013 14:32:12 +0000 (GMT)
Received: from AMDC1061.digital.local ([106.116.147.88])
 by eusync3.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0MGG00281TPF0J40@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Fri, 11 Jan 2013 14:32:11 +0000 (GMT)
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH RFC v2] [media] s5c73m3: Add driver
Date: Fri, 11 Jan 2013 15:31:41 +0100
Message-id: <1357914701-10505-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add driver for S5C73M3 image sensor. The driver exposes the sensor as
two subdevs: pure sensor and output interface. Two subdev architecture
supports interleaved UYVY/JPEG image format with separate frame size
for both sub-formats, there is a spearate pad for each sub-format.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
v2: removed some debug messages, pr_* family calls replaced by v4l2_* calls

 drivers/media/i2c/Kconfig                 |    7 +
 drivers/media/i2c/Makefile                |    1 +
 drivers/media/i2c/s5c73m3/Makefile        |    2 +
 drivers/media/i2c/s5c73m3/s5c73m3-core.c  | 1718 +++++++++++++++++++++++++++++
 drivers/media/i2c/s5c73m3/s5c73m3-ctrls.c |  563 ++++++++++
 drivers/media/i2c/s5c73m3/s5c73m3-spi.c   |  156 +++
 drivers/media/i2c/s5c73m3/s5c73m3.h       |  459 ++++++++
 include/media/s5c73m3.h                   |   55 +
 8 files changed, 2961 insertions(+)
 create mode 100644 drivers/media/i2c/s5c73m3/Makefile
 create mode 100644 drivers/media/i2c/s5c73m3/s5c73m3-core.c
 create mode 100644 drivers/media/i2c/s5c73m3/s5c73m3-ctrls.c
 create mode 100644 drivers/media/i2c/s5c73m3/s5c73m3-spi.c
 create mode 100644 drivers/media/i2c/s5c73m3/s5c73m3.h
 create mode 100644 include/media/s5c73m3.h

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 24d78e2..66245eb 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -516,6 +516,13 @@ config VIDEO_S5K4ECGX
 
 source "drivers/media/i2c/smiapp/Kconfig"
 
+config VIDEO_S5C73M3
+	tristate "Samsung S5C73M3 sensor support"
+	depends on I2C && SPI && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	---help---
+	This is a V4L2 sensor-level driver for Samsung S5C73M3
+	8 Mpixel camera.
+
 comment "Flash devices"
 
 config VIDEO_ADP1653
diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
index b1d62df..0e24e77 100644
--- a/drivers/media/i2c/Makefile
+++ b/drivers/media/i2c/Makefile
@@ -58,6 +58,7 @@ obj-$(CONFIG_VIDEO_SR030PC30)	+= sr030pc30.o
 obj-$(CONFIG_VIDEO_NOON010PC30)	+= noon010pc30.o
 obj-$(CONFIG_VIDEO_S5K6AA)	+= s5k6aa.o
 obj-$(CONFIG_VIDEO_S5K4ECGX)	+= s5k4ecgx.o
+obj-$(CONFIG_VIDEO_S5C73M3)	+= s5c73m3/
 obj-$(CONFIG_VIDEO_ADP1653)	+= adp1653.o
 obj-$(CONFIG_VIDEO_AS3645A)	+= as3645a.o
 obj-$(CONFIG_VIDEO_SMIAPP_PLL)	+= smiapp-pll.o
diff --git a/drivers/media/i2c/s5c73m3/Makefile b/drivers/media/i2c/s5c73m3/Makefile
new file mode 100644
index 0000000..fa4df34
--- /dev/null
+++ b/drivers/media/i2c/s5c73m3/Makefile
@@ -0,0 +1,2 @@
+s5c73m3-objs			:= s5c73m3-core.o s5c73m3-spi.o s5c73m3-ctrls.o
+obj-$(CONFIG_VIDEO_S5C73M3)	+= s5c73m3.o
diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
new file mode 100644
index 0000000..ce0488e
--- /dev/null
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
@@ -0,0 +1,1718 @@
+/*
+ * Samsung LSI S5C73M3 8M pixel camera driver
+ *
+ * Copyright (C) 2012, Samsung Electronics, Co., Ltd.
+ * Sylwester Nawrocki <s.nawrocki@samsung.com>
+ * Andrzej Hajda <a.hajda@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/sizes.h>
+#include <linux/delay.h>
+#include <linux/firmware.h>
+#include <linux/gpio.h>
+#include <linux/i2c.h>
+#include <linux/init.h>
+#include <linux/media.h>
+#include <linux/module.h>
+#include <linux/regulator/consumer.h>
+#include <linux/slab.h>
+#include <linux/spi/spi.h>
+#include <linux/videodev2.h>
+#include <media/media-entity.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-subdev.h>
+#include <media/v4l2-mediabus.h>
+#include <media/s5c73m3.h>
+
+#include "s5c73m3.h"
+
+int s5c73m3_dbg;
+module_param_named(debug, s5c73m3_dbg, int, 0644);
+
+int boot_from_rom = 1;
+module_param(boot_from_rom, int, 0644);
+
+int update_fw;
+module_param(update_fw, int, 0644);
+
+#define S5C73M3_EMBEDDED_DATA_MAXLEN	SZ_4K
+
+static const char * const s5c73m3_supply_names[S5C73M3_MAX_SUPPLIES] = {
+	"VDD_INT",	/* Digital Core supply (1.2V), CAM_ISP_CORE_1.2V */
+	"VDDA",		/* Analog Core supply (1.2V), CAM_SENSOR_CORE_1.2V */
+	"VDD_REG",	/* Regulator input supply (2.8V), CAM_SENSOR_A2.8V */
+	"VDDIO_HOST",	/* Digital Host I/O power supply (1.8V...2.8V),
+			   CAM_ISP_SENSOR_1.8V */
+	"VDDIO_CIS",	/* Digital CIS I/O power (1.2V...1.8V),
+			   CAM_ISP_MIPI_1.2V */
+	"VDD_AF",	/* Lens, CAM_AF_2.8V */
+};
+
+static const struct s5c73m3_frame_size s5c73m3_isp_resolutions[] = {
+	{ 320,	240,	COMM_CHG_MODE_YUV_320_240 },
+	{ 352,	288,	COMM_CHG_MODE_YUV_352_288 },
+	{ 640,	480,	COMM_CHG_MODE_YUV_640_480 },
+	{ 880,	720,	COMM_CHG_MODE_YUV_880_720 },
+	{ 960,	720,	COMM_CHG_MODE_YUV_960_720 },
+	{ 1008,	672,	COMM_CHG_MODE_YUV_1008_672 },
+	{ 1184,	666,	COMM_CHG_MODE_YUV_1184_666 },
+	{ 1280,	720,	COMM_CHG_MODE_YUV_1280_720 },
+	{ 1536,	864,	COMM_CHG_MODE_YUV_1536_864 },
+	{ 1600,	1200,	COMM_CHG_MODE_YUV_1600_1200 },
+	{ 1632,	1224,	COMM_CHG_MODE_YUV_1632_1224 },
+	{ 1920,	1080,	COMM_CHG_MODE_YUV_1920_1080 },
+	{ 1920,	1440,	COMM_CHG_MODE_YUV_1920_1440 },
+	{ 2304,	1296,	COMM_CHG_MODE_YUV_2304_1296 },
+	{ 3264,	2448,	COMM_CHG_MODE_YUV_3264_2448 },
+};
+
+static const struct s5c73m3_frame_size s5c73m3_jpeg_resolutions[] = {
+	{ 640,	480,	COMM_CHG_MODE_JPEG_640_480 },
+	{ 800,	450,	COMM_CHG_MODE_JPEG_800_450 },
+	{ 800,	600,	COMM_CHG_MODE_JPEG_800_600 },
+	{ 1024,	768,	COMM_CHG_MODE_JPEG_1024_768 },
+	{ 1280,	720,	COMM_CHG_MODE_JPEG_1280_720 },
+	{ 1280,	960,	COMM_CHG_MODE_JPEG_1280_960 },
+	{ 1600,	900,	COMM_CHG_MODE_JPEG_1600_900 },
+	{ 1600,	1200,	COMM_CHG_MODE_JPEG_1600_1200 },
+	{ 2048,	1152,	COMM_CHG_MODE_JPEG_2048_1152 },
+	{ 2048,	1536,	COMM_CHG_MODE_JPEG_2048_1536 },
+	{ 2560,	1440,	COMM_CHG_MODE_JPEG_2560_1440 },
+	{ 2560,	1920,	COMM_CHG_MODE_JPEG_2560_1920 },
+	{ 3264,	1836,	COMM_CHG_MODE_JPEG_3264_1836 },
+	{ 3264,	2176,	COMM_CHG_MODE_JPEG_3264_2176 },
+	{ 3264,	2448,	COMM_CHG_MODE_JPEG_3264_2448 },
+};
+
+static const struct s5c73m3_frame_size * const s5c73m3_resolutions[] = {
+	[RES_ISP] = s5c73m3_isp_resolutions,
+	[RES_JPEG] = s5c73m3_jpeg_resolutions
+};
+
+static const int s5c73m3_resolutions_len[] = {
+	[RES_ISP] = ARRAY_SIZE(s5c73m3_isp_resolutions),
+	[RES_JPEG] = ARRAY_SIZE(s5c73m3_jpeg_resolutions)
+};
+
+static const struct s5c73m3_interval s5c73m3_intervals[] = {
+	{ COMM_FRAME_RATE_FIXED_7FPS, {142857, 1000000}, {3264, 2448} },
+	{ COMM_FRAME_RATE_FIXED_15FPS, {66667, 1000000}, {3264, 2448} },
+	{ COMM_FRAME_RATE_FIXED_20FPS, {50000, 1000000}, {2304, 1296} },
+	{ COMM_FRAME_RATE_FIXED_30FPS, {33333, 1000000}, {2304, 1296} },
+};
+
+#define S5C73M3_DEFAULT_FRAME_INTERVAL 3 /* 30 fps */
+
+static void s5c73m3_fill_mbus_fmt(struct v4l2_mbus_framefmt *mf,
+				  const struct s5c73m3_frame_size *fs,
+				  u32 code)
+{
+	mf->width = fs->width;
+	mf->height = fs->height;
+	mf->code = code;
+	mf->colorspace = V4L2_COLORSPACE_JPEG;
+	mf->field = V4L2_FIELD_NONE;
+}
+
+static int s5c73m3_i2c_write(struct i2c_client *client, u16 addr, u16 data)
+{
+	u8 buf[4] = { addr >> 8, addr & 0xff, data >> 8, data & 0xff };
+
+	int ret = i2c_master_send(client, buf, sizeof(buf));
+
+	v4l_dbg(4, s5c73m3_dbg, client, "%s: addr 0x%04x, data 0x%04x\n",
+		 __func__, addr, data);
+
+	if (ret == 4)
+		return 0;
+
+	return ret < 0 ? ret : -EREMOTEIO;
+}
+
+static int s5c73m3_i2c_read(struct i2c_client *client, u16 addr, u16 *data)
+{
+	int ret;
+	u8 rbuf[2], wbuf[2] = { addr >> 8, addr & 0xff };
+	struct i2c_msg msg[2] = {
+		{
+			.addr = client->addr,
+			.flags = 0,
+			.len = sizeof(wbuf),
+			.buf = wbuf
+		}, {
+			.addr = client->addr,
+			.flags = I2C_M_RD,
+			.len = sizeof(rbuf),
+			.buf = rbuf
+		}
+	};
+	/*
+	 * Issue repeated START after writing 2 address bytes and
+	 * just one STOP only after reading the data bytes.
+	 */
+	ret = i2c_transfer(client->adapter, msg, 2);
+	if (ret == 2) {
+		*data = be16_to_cpup((u16 *)rbuf);
+		v4l2_dbg(4, s5c73m3_dbg, client,
+			 "%s: addr: 0x%04x, data: 0x%04x\n",
+			 __func__, addr, *data);
+		return 0;
+	}
+
+	v4l2_err(client, "I2C read failed: addr: %04x, (%d)\n", addr, ret);
+
+	return ret >= 0 ? -EREMOTEIO : ret;
+}
+
+int s5c73m3_write(struct s5c73m3 *state, u32 addr, u16 data)
+{
+	struct i2c_client *client = state->i2c_client;
+	int ret;
+
+	if ((addr ^ state->i2c_write_address) & 0xffff0000) {
+		ret = s5c73m3_i2c_write(client, REG_CMDWR_ADDRH, addr >> 16);
+		if (ret < 0) {
+			state->i2c_write_address = 0;
+			return ret;
+		}
+	}
+
+	if ((addr ^ state->i2c_write_address) & 0xffff) {
+		ret = s5c73m3_i2c_write(client, REG_CMDWR_ADDRL, addr & 0xffff);
+		if (ret < 0) {
+			state->i2c_write_address = 0;
+			return ret;
+		}
+	}
+
+	state->i2c_write_address = addr;
+
+	ret = s5c73m3_i2c_write(client, REG_CMDBUF_ADDR, data);
+	if (ret < 0)
+		return ret;
+
+	state->i2c_write_address += 2;
+
+	return ret;
+}
+
+int s5c73m3_read(struct s5c73m3 *state, u32 addr, u16 *data)
+{
+	struct i2c_client *client = state->i2c_client;
+	int ret;
+
+	if ((addr ^ state->i2c_read_address) & 0xffff0000) {
+		ret = s5c73m3_i2c_write(client, REG_CMDRD_ADDRH, addr >> 16);
+		if (ret < 0) {
+			state->i2c_read_address = 0;
+			return ret;
+		}
+	}
+
+	if ((addr ^ state->i2c_read_address) & 0xffff) {
+		ret = s5c73m3_i2c_write(client, REG_CMDRD_ADDRL, addr & 0xffff);
+		if (ret < 0) {
+			state->i2c_read_address = 0;
+			return ret;
+		}
+	}
+
+	state->i2c_read_address = addr;
+
+	ret = s5c73m3_i2c_read(client, REG_CMDBUF_ADDR, data);
+	if (ret < 0)
+		return ret;
+
+	state->i2c_read_address += 2;
+
+	return ret;
+}
+
+static int s5c73m3_check_status(struct s5c73m3 *state, unsigned int value)
+{
+	unsigned long start = jiffies;
+	unsigned long end = start + msecs_to_jiffies(1000);
+	int ret = 0;
+	u16 status;
+	int count = 0;
+
+	while (time_is_after_jiffies(end)) {
+		ret = s5c73m3_read(state, REG_STATUS, &status);
+		if (ret < 0 || status == value)
+			break;
+		usleep_range(500, 1000);
+		++count;
+	}
+
+	if (count > 0)
+		v4l2_dbg(1, s5c73m3_dbg, &state->sensor_sd,
+			 "status check took %dms\n",
+			 jiffies_to_msecs(jiffies - start));
+
+	if (ret == 0 && status != value) {
+		u16 i2c_status = 0;
+		u16 i2c_seq_status = 0;
+
+		s5c73m3_read(state, REG_I2C_STATUS, &i2c_status);
+		s5c73m3_read(state, REG_I2C_SEQ_STATUS,
+							&i2c_seq_status);
+
+		v4l2_err(&state->sensor_sd, "Wrong status %d expected=%d i2c_status=%d i2c_seq_status=%d",
+			 status, value, i2c_status, i2c_seq_status);
+
+		return -ETIMEDOUT;
+	}
+
+	return ret;
+}
+
+int s5c73m3_isp_command(struct s5c73m3 *state, u16 command, u16 data)
+{
+	int ret;
+
+	ret = s5c73m3_check_status(state, REG_STATUS_ISP_COMMAND_COMPLETED);
+	if (ret < 0)
+		return ret;
+
+	ret = s5c73m3_write(state, 0x00095000, command);
+	if (ret < 0)
+		return ret;
+
+	ret = s5c73m3_write(state, 0x00095002, data);
+	if (ret < 0)
+		return ret;
+
+	return s5c73m3_write(state, REG_STATUS, 0x0001);
+}
+
+int s5c73m3_isp_comm_result(struct s5c73m3 *state, u16 command, u16 *data)
+{
+	return s5c73m3_read(state, COMM_RESULT_OFFSET + command, data);
+}
+
+static int s5c73m3_set_af_softlanding(struct s5c73m3 *state)
+{
+	unsigned long start = jiffies;
+	u16 af_softlanding;
+	int count = 0;
+	int ret;
+	const char *msg;
+
+	ret = s5c73m3_isp_command(state, COMM_AF_SOFTLANDING,
+					COMM_AF_SOFTLANDING_ON);
+	if (ret < 0) {
+		v4l2_info(&state->sensor_sd, "AF soft-landing failed\n");
+		return ret;
+	}
+
+	for (;;) {
+		ret = s5c73m3_isp_comm_result(state, COMM_AF_SOFTLANDING,
+							&af_softlanding);
+		if (ret < 0) {
+			msg = "failed";
+			break;
+		}
+		if (af_softlanding == COMM_AF_SOFTLANDING_RES_COMPLETE) {
+			msg = "succeeded";
+			break;
+		}
+		if (++count > 100) {
+			ret = -ETIME;
+			msg = "timed out";
+			break;
+		}
+		msleep(25);
+	}
+
+	v4l2_info(&state->sensor_sd, "AF soft-landing %s after %dms\n",
+		  msg, jiffies_to_msecs(jiffies - start));
+
+	return ret;
+}
+
+static int s5c73m3_load_fw(struct v4l2_subdev *sd)
+{
+	struct s5c73m3 *state = sensor_sd_to_s5c73m3(sd);
+	struct i2c_client *client = state->i2c_client;
+	const struct firmware *fw;
+	int ret;
+	char fw_name[20];
+
+	snprintf(fw_name, sizeof(fw_name), "SlimISP_%.2s.bin",
+							state->fw_file_version);
+	ret = request_firmware(&fw, fw_name, &client->dev);
+	if (ret < 0) {
+		v4l2_err(sd, "Firmware request failed (%s)\n", fw_name);
+		return -EINVAL;
+	}
+
+	v4l2_info(sd, "Loading firmware (%s, %d B)\n", fw_name, fw->size);
+
+	ret = s5c73m3_spi_write(state, fw->data, fw->size, 64);
+
+	if (ret >= 0)
+		state->isp_ready = 1;
+	else
+		v4l2_err(sd, "SPI write failed\n");
+
+	release_firmware(fw);
+
+	return ret;
+}
+
+static int s5c73m3_set_frame_size(struct s5c73m3 *state)
+{
+	const struct s5c73m3_frame_size *prev_size =
+					state->sensor_pix_size[RES_ISP];
+	const struct s5c73m3_frame_size *cap_size =
+					state->sensor_pix_size[RES_JPEG];
+	unsigned int chg_mode;
+	int ret;
+
+	v4l2_dbg(1, s5c73m3_dbg, &state->sensor_sd,
+		 "Preview size: %dx%d, reg_val: 0x%x\n",
+		 prev_size->width, prev_size->height, prev_size->reg_val);
+
+	chg_mode = prev_size->reg_val | COMM_CHG_MODE_NEW;
+
+	if (state->mbus_code == S5C73M3_JPEG_FMT) {
+		v4l2_dbg(1, s5c73m3_dbg, &state->sensor_sd,
+			 "Capture size: %dx%d, reg_val: 0x%x\n",
+			 cap_size->width, cap_size->height, cap_size->reg_val);
+		chg_mode |= cap_size->reg_val;
+	}
+
+	return s5c73m3_isp_command(state, COMM_CHG_MODE, chg_mode);
+}
+
+static int s5c73m3_set_frame_rate(struct s5c73m3 *state)
+{
+	int ret;
+
+	if (state->ctrls.stabilization->val)
+		return 0;
+
+	if (WARN_ON(state->fiv == NULL))
+		return -EINVAL;
+
+	ret = s5c73m3_isp_command(state, COMM_FRAME_RATE, state->fiv->fps_reg);
+	if (!ret)
+		state->apply_fiv = 0;
+
+	return ret;
+}
+
+static int __s5c73m3_s_stream(struct s5c73m3 *state, struct v4l2_subdev *sd,
+								int on)
+{
+	u16 mode;
+	int ret;
+
+	if (on && state->apply_fmt) {
+		if (state->mbus_code == S5C73M3_JPEG_FMT)
+			mode = COMM_IMG_OUTPUT_INTERLEAVED;
+		else
+			mode = COMM_IMG_OUTPUT_YUV;
+
+		ret = s5c73m3_isp_command(state, COMM_IMG_OUTPUT, mode);
+		if (!ret)
+			ret = s5c73m3_set_frame_size(state);
+		if (ret)
+			return ret;
+		state->apply_fmt = 0;
+	}
+
+	ret = s5c73m3_isp_command(state, COMM_SENSOR_STREAMING, !!on);
+	if (ret)
+		return ret;
+
+	state->streaming = !!on;
+
+	if (!on)
+		return ret;
+
+	if (state->apply_fiv) {
+		ret = s5c73m3_set_frame_rate(state);
+		if (ret < 0)
+			v4l2_err(sd, "Error setting frame rate(%d)\n", ret);
+	}
+
+	return s5c73m3_check_status(state, REG_STATUS_ISP_COMMAND_COMPLETED);
+}
+
+static int s5c73m3_oif_s_stream(struct v4l2_subdev *sd, int on)
+{
+	struct s5c73m3 *state = oif_sd_to_s5c73m3(sd);
+	int ret;
+
+	mutex_lock(&state->lock);
+	ret = __s5c73m3_s_stream(state, sd, on);
+	mutex_unlock(&state->lock);
+
+	return ret;
+}
+
+static int s5c73m3_system_status_wait(struct s5c73m3 *state, u32 value,
+				      unsigned int delay, unsigned int steps)
+{
+	u16 reg = 0;
+
+	while (steps-- > 0) {
+		int ret = s5c73m3_read(state, 0x30100010, &reg);
+		if (ret < 0)
+			return ret;
+		if (reg == value)
+			return 0;
+		usleep_range(delay, delay + 25);
+	}
+	return -ETIMEDOUT;
+}
+
+static int s5c73m3_read_fw_version(struct s5c73m3 *state)
+{
+	struct v4l2_subdev *sd = &state->sensor_sd;
+	int i, ret;
+	u16 data[2];
+	int offset;
+
+	offset = state->isp_ready ? 0x60 : 0;
+
+	for (i = 0; i < S5C73M3_SENSOR_FW_LEN / 2; i++) {
+		ret = s5c73m3_read(state, offset + i * 2, data);
+		if (ret < 0)
+			return ret;
+		state->sensor_fw[i * 2] = (char)(*data & 0xff);
+		state->sensor_fw[i * 2 + 1] = (char)(*data >> 8);
+	}
+	state->sensor_fw[S5C73M3_SENSOR_FW_LEN] = '\0';
+
+
+	for (i = 0; i < S5C73M3_SENSOR_TYPE_LEN / 2; i++) {
+		ret = s5c73m3_read(state, offset + 6 + i * 2, data);
+		if (ret < 0)
+			return ret;
+		state->sensor_type[i * 2] = (char)(*data & 0xff);
+		state->sensor_type[i * 2 + 1] = (char)(*data >> 8);
+	}
+	state->sensor_type[S5C73M3_SENSOR_TYPE_LEN] = '\0';
+
+	ret = s5c73m3_read(state, offset + 0x14, data);
+	if (ret >= 0) {
+		ret = s5c73m3_read(state, offset + 0x16, data + 1);
+		if (ret >= 0)
+			state->fw_size = data[0] + (data[1] << 16);
+	}
+
+	v4l2_info(sd, "Sensor type: %s, FW version: %s\n",
+		  state->sensor_type, state->sensor_fw);
+	return ret;
+}
+
+static int s5c73m3_fw_update_from(struct s5c73m3 *state)
+{
+	struct v4l2_subdev *sd = &state->sensor_sd;
+	u16 status = COMM_FW_UPDATE_NOT_READY;
+	int ret;
+	int count = 0;
+
+	v4l2_warn(sd, "Updating F-ROM firmware.\n");
+	do {
+		if (status == COMM_FW_UPDATE_NOT_READY) {
+			ret = s5c73m3_isp_command(state, COMM_FW_UPDATE, 0);
+			if (ret < 0)
+				return ret;
+		}
+
+		ret = s5c73m3_read(state, 0x00095906, &status);
+		if (ret < 0)
+			return ret;
+		switch (status) {
+		case COMM_FW_UPDATE_FAIL:
+			v4l2_warn(sd, "Updating F-ROM firmware failed.\n");
+			return -EIO;
+		case COMM_FW_UPDATE_SUCCESS:
+			v4l2_warn(sd, "Updating F-ROM firmware finished.\n");
+			return 0;
+		}
+		++count;
+		msleep(20);
+	} while (count < 500);
+
+	v4l2_warn(sd, "Updating F-ROM firmware timed-out.\n");
+	return -ETIMEDOUT;
+}
+
+static int s5c73m3_spi_boot(struct s5c73m3 *state, bool load_fw)
+{
+	struct v4l2_subdev *sd = &state->sensor_sd;
+	int ret;
+
+	/* Run ARM MCU */
+	ret = s5c73m3_write(state, 0x30000004, 0xffff);
+	if (ret < 0)
+		return ret;
+
+	usleep_range(400, 500);
+
+	/* Check booting status */
+	ret = s5c73m3_system_status_wait(state, 0x0c, 100, 3);
+	if (ret < 0) {
+		v4l2_err(sd, "booting failed: %d\n", ret);
+		return ret;
+	}
+
+	/* P,M,S and Boot Mode */
+	ret = s5c73m3_write(state, 0x30100014, 0x2146);
+	if (ret < 0)
+		return ret;
+
+	ret = s5c73m3_write(state, 0x30100010, 0x210c);
+	if (ret < 0)
+		return ret;
+
+	usleep_range(200, 250);
+
+	/* Check SPI status */
+	ret = s5c73m3_system_status_wait(state, 0x210d, 100, 3);
+	if (ret < 0) {
+		v4l2_err(sd, "SPI not ready: %d\n", ret);
+		return ret;
+	}
+
+	/* Firmware download over SPI */
+	if (load_fw)
+		s5c73m3_load_fw(sd);
+
+	/* MCU reset */
+	ret = s5c73m3_write(state, 0x30000004, 0xfffd);
+	if (ret < 0)
+		return ret;
+
+	/* Remap */
+	ret = s5c73m3_write(state, 0x301000a4, 0x0183);
+	if (ret < 0)
+		return ret;
+
+	/* MCU restart */
+	ret = s5c73m3_write(state, 0x30000004, 0xffff);
+	if (ret < 0 || !load_fw)
+		return ret;
+
+	ret = s5c73m3_read_fw_version(state);
+	if (ret < 0)
+		return ret;
+
+	if (load_fw && update_fw) {
+		ret = s5c73m3_fw_update_from(state);
+		update_fw = 0;
+	}
+
+	return ret;
+}
+
+static int s5c73m3_set_timing_register_for_vdd(struct s5c73m3 *state)
+{
+	static const u32 regs[][2] = {
+		{ 0x30100018, 0x0618 },
+		{ 0x3010001c, 0x10c1 },
+		{ 0x30100020, 0x249e }
+	};
+	int ret;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(regs); i++) {
+		ret = s5c73m3_write(state, regs[i][0], regs[i][1]);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+static void s5c73m3_set_fw_file_version(struct s5c73m3 *state)
+{
+	switch (state->sensor_fw[0]) {
+	case 'G':
+	case 'O':
+		state->fw_file_version[0] = 'G';
+		break;
+	case 'S':
+	case 'Z':
+		state->fw_file_version[0] = 'Z';
+		break;
+	default:
+		state->fw_file_version[0] = 'G';
+	}
+
+	switch (state->sensor_fw[1]) {
+	case 'C'...'F':
+		state->fw_file_version[1] = state->sensor_fw[1];
+		break;
+	default:
+		state->fw_file_version[1] = 'C';
+	}
+}
+
+static int s5c73m3_get_fw_version(struct s5c73m3 *state)
+{
+	struct v4l2_subdev *sd = &state->sensor_sd;
+	int ret;
+
+	/* Run ARM MCU */
+	ret = s5c73m3_write(state, 0x30000004, 0xffff);
+	if (ret < 0)
+		return ret;
+	usleep_range(400, 500);
+
+	/* Check booting status */
+	ret = s5c73m3_system_status_wait(state, 0x0c, 100, 3);
+	if (ret < 0) {
+
+		v4l2_err(sd, "%s: booting failed: %d\n", __func__, ret);
+		return ret;
+	}
+
+	/* Change I/O Driver Current in order to read from F-ROM */
+	ret = s5c73m3_write(state, 0x30100120, 0x0820);
+	ret = s5c73m3_write(state, 0x30100124, 0x0820);
+
+	/* Offset Setting */
+	ret = s5c73m3_write(state, 0x00010418, 0x0008);
+
+	/* P,M,S and Boot Mode */
+	ret = s5c73m3_write(state, 0x30100014, 0x2146);
+	if (ret < 0)
+		return ret;
+	ret = s5c73m3_write(state, 0x30100010, 0x230c);
+	if (ret < 0)
+		return ret;
+
+	usleep_range(200, 250);
+
+	/* Check SPI status */
+	ret = s5c73m3_system_status_wait(state, 0x230e, 100, 300);
+	if (ret < 0) {
+		v4l2_err(sd, "SPI not ready: %d\n", ret);
+		return ret;
+	}
+	/* ARM reset */
+	ret = s5c73m3_write(state, 0x30000004, 0xfffd);
+	if (ret < 0)
+		return ret;
+
+	/* Remap */
+	ret = s5c73m3_write(state, 0x301000a4, 0x0183);
+	if (ret < 0)
+		return ret;
+
+	s5c73m3_set_timing_register_for_vdd(state);
+
+	ret = s5c73m3_read_fw_version(state);
+
+	s5c73m3_set_fw_file_version(state);
+
+	return ret;
+}
+
+static int s5c73m3_rom_boot(struct s5c73m3 *state, bool load_fw)
+{
+	static const u32 boot_regs[][2] = {
+		{ 0x3100010c, 0x0044 },
+		{ 0x31000108, 0x000d },
+		{ 0x31000304, 0x0001 },
+		{ 0x00010000, 0x5800 },
+		{ 0x00010002, 0x0002 },
+		{ 0x31000000, 0x0001 },
+		{ 0x30100014, 0x1b85 },
+		{ 0x30100010, 0x230c }
+	};
+	struct v4l2_subdev *sd = &state->sensor_sd;
+	int i, ret;
+
+	/* Run ARM MCU */
+	ret = s5c73m3_write(state, 0x30000004, 0xffff);
+	if (ret < 0)
+		return ret;
+	usleep_range(400, 450);
+
+	/* Check booting status */
+	ret = s5c73m3_system_status_wait(state, 0x0c, 100, 4);
+	if (ret < 0) {
+		v4l2_err(sd, "Booting failed: %d\n", ret);
+		return ret;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(boot_regs); i++) {
+		ret = s5c73m3_write(state, boot_regs[i][0], boot_regs[i][1]);
+		if (ret < 0)
+			return ret;
+	}
+	msleep(200);
+
+	/* Check the binary read status */
+	ret = s5c73m3_system_status_wait(state, 0x230e, 1000, 150);
+	if (ret < 0) {
+		v4l2_err(sd, "Binary read failed: %d\n", ret);
+		return ret;
+	}
+
+	/* ARM reset */
+	ret = s5c73m3_write(state, 0x30000004, 0xfffd);
+	if (ret < 0)
+		return ret;
+	/* Remap */
+	ret = s5c73m3_write(state, 0x301000a4, 0x0183);
+	if (ret < 0)
+		return ret;
+	/* MCU re-start */
+	ret = s5c73m3_write(state, 0x30000004, 0xffff);
+	if (ret < 0)
+		return ret;
+
+	state->isp_ready = 1;
+
+	return s5c73m3_read_fw_version(state);
+}
+
+static int s5c73m3_isp_init(struct s5c73m3 *state)
+{
+	int ret;
+
+	state->i2c_read_address = 0;
+	state->i2c_write_address = 0;
+
+	ret = s5c73m3_i2c_write(state->i2c_client, AHB_MSB_ADDR_PTR, 0x3310);
+	if (ret < 0)
+		return ret;
+
+	if (boot_from_rom)
+		return s5c73m3_rom_boot(state, true);
+	else
+		return s5c73m3_spi_boot(state, true);
+}
+
+static const struct s5c73m3_frame_size *s5c73m3_find_frame_size(
+					struct v4l2_mbus_framefmt *fmt,
+					enum s5c73m3_resolution_types idx)
+{
+	const struct s5c73m3_frame_size *fs;
+	const struct s5c73m3_frame_size *best_fs;
+	int best_dist = INT_MAX;
+	int i;
+
+	fs = s5c73m3_resolutions[idx];
+	best_fs = NULL;
+	for (i = 0; i < s5c73m3_resolutions_len[idx]; ++i) {
+		int dist = abs(fs->width - fmt->width) +
+						abs(fs->height - fmt->height);
+		if (dist < best_dist) {
+			best_dist = dist;
+			best_fs = fs;
+		}
+		++fs;
+	}
+
+	return best_fs;
+}
+
+static void s5c73m3_oif_try_format(struct s5c73m3 *state,
+				   struct v4l2_subdev_fh *fh,
+				   struct v4l2_subdev_format *fmt,
+				   const struct s5c73m3_frame_size **fs)
+{
+	u32 code;
+
+	switch (fmt->pad) {
+	case OIF_ISP_PAD:
+		*fs = s5c73m3_find_frame_size(&fmt->format, RES_ISP);
+		code = S5C73M3_ISP_FMT;
+		break;
+	case OIF_JPEG_PAD:
+		*fs = s5c73m3_find_frame_size(&fmt->format, RES_JPEG);
+		code = S5C73M3_JPEG_FMT;
+		break;
+	case OIF_SOURCE_PAD:
+	default:
+		if (fmt->format.code == S5C73M3_JPEG_FMT)
+			code = S5C73M3_JPEG_FMT;
+		else
+			code = S5C73M3_ISP_FMT;
+
+		if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+			*fs = state->oif_pix_size[RES_ISP];
+		else
+			*fs = s5c73m3_find_frame_size(
+						v4l2_subdev_get_try_format(fh,
+							OIF_ISP_PAD),
+						RES_ISP);
+		break;
+	}
+
+	s5c73m3_fill_mbus_fmt(&fmt->format, *fs, code);
+}
+
+static void s5c73m3_try_format(struct s5c73m3 *state,
+			      struct v4l2_subdev_fh *fh,
+			      struct v4l2_subdev_format *fmt,
+			      const struct s5c73m3_frame_size **fs)
+{
+	u32 code;
+
+	if (fmt->pad == S5C73M3_ISP_PAD) {
+		*fs = s5c73m3_find_frame_size(&fmt->format, RES_ISP);
+		code = S5C73M3_ISP_FMT;
+	} else {
+		*fs = s5c73m3_find_frame_size(&fmt->format, RES_JPEG);
+		code = S5C73M3_JPEG_FMT;
+	}
+
+	s5c73m3_fill_mbus_fmt(&fmt->format, *fs, code);
+}
+
+static int s5c73m3_oif_g_frame_interval(struct v4l2_subdev *sd,
+				   struct v4l2_subdev_frame_interval *fi)
+{
+	struct s5c73m3 *state = oif_sd_to_s5c73m3(sd);
+
+	if (fi->pad != OIF_SOURCE_PAD)
+		return -EINVAL;
+
+	mutex_lock(&state->lock);
+	fi->interval = state->fiv->interval;
+	mutex_unlock(&state->lock);
+
+	return 0;
+}
+
+static int __s5c73m3_set_frame_interval(struct s5c73m3 *state,
+					struct v4l2_subdev_frame_interval *fi)
+{
+	const struct s5c73m3_frame_size *prev_size =
+						state->sensor_pix_size[RES_ISP];
+	const struct s5c73m3_interval *fiv = &s5c73m3_intervals[0];
+	unsigned int ret, min_err = UINT_MAX;
+	unsigned int i, fr_time;
+
+	if (fi->interval.denominator == 0)
+		return -EINVAL;
+
+	fr_time = fi->interval.numerator * 1000 / fi->interval.denominator;
+
+	for (i = 0; i < ARRAY_SIZE(s5c73m3_intervals); i++) {
+		const struct s5c73m3_interval *iv = &s5c73m3_intervals[i];
+
+		if (prev_size->width > iv->size.width ||
+		    prev_size->height > iv->size.height)
+			continue;
+
+		ret = abs(iv->interval.numerator / 1000 - fr_time);
+		if (ret < min_err) {
+			fiv = iv;
+			min_err = ret;
+		}
+	}
+	state->fiv = fiv;
+
+	v4l2_dbg(1, s5c73m3_dbg, &state->sensor_sd,
+		 "Changed frame interval to %u us\n", fiv->interval.numerator);
+	return 0;
+}
+
+static int s5c73m3_oif_s_frame_interval(struct v4l2_subdev *sd,
+				   struct v4l2_subdev_frame_interval *fi)
+{
+	struct s5c73m3 *state = oif_sd_to_s5c73m3(sd);
+	int ret;
+
+	if (fi->pad != OIF_SOURCE_PAD)
+		return -EINVAL;
+
+	v4l2_dbg(1, s5c73m3_dbg, sd, "Setting %d/%d frame interval\n",
+		 fi->interval.numerator, fi->interval.denominator);
+
+	mutex_lock(&state->lock);
+
+	ret = __s5c73m3_set_frame_interval(state, fi);
+	if (!ret) {
+		if (state->streaming)
+			ret = s5c73m3_set_frame_rate(state);
+		else
+			state->apply_fiv = 1;
+	}
+	mutex_unlock(&state->lock);
+	return ret;
+}
+
+static int s5c73m3_oif_enum_frame_interval(struct v4l2_subdev *sd,
+			      struct v4l2_subdev_fh *fh,
+			      struct v4l2_subdev_frame_interval_enum *fie)
+{
+	struct s5c73m3 *state = oif_sd_to_s5c73m3(sd);
+	const struct s5c73m3_interval *fi;
+	int ret = 0;
+
+	if (fie->pad != OIF_SOURCE_PAD)
+		return -EINVAL;
+	if (fie->index > ARRAY_SIZE(s5c73m3_intervals))
+		return -EINVAL;
+
+	mutex_lock(&state->lock);
+	fi = &s5c73m3_intervals[fie->index];
+	if (fie->width > fi->size.width || fie->height > fi->size.height)
+		ret = -EINVAL;
+	else
+		fie->interval = fi->interval;
+	mutex_unlock(&state->lock);
+
+	return ret;
+}
+
+static int s5c73m3_oif_get_pad_code(int pad, int index)
+{
+	if (pad == OIF_SOURCE_PAD) {
+		if (index > 1)
+			return -EINVAL;
+		return (index == 0) ? S5C73M3_ISP_FMT : S5C73M3_JPEG_FMT;
+	}
+
+	if (index > 0)
+		return -EINVAL;
+
+	return (pad == OIF_ISP_PAD) ? S5C73M3_ISP_FMT : S5C73M3_JPEG_FMT;
+}
+
+static int s5c73m3_get_fmt(struct v4l2_subdev *sd,
+			   struct v4l2_subdev_fh *fh,
+			   struct v4l2_subdev_format *fmt)
+{
+	struct s5c73m3 *state = sensor_sd_to_s5c73m3(sd);
+	const struct s5c73m3_frame_size *fs;
+	u32 code;
+
+	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
+		fmt->format = *v4l2_subdev_get_try_format(fh, fmt->pad);
+		return 0;
+	}
+
+	mutex_lock(&state->lock);
+
+	switch (fmt->pad) {
+	case S5C73M3_ISP_PAD:
+		code = S5C73M3_ISP_FMT;
+		fs = state->sensor_pix_size[RES_ISP];
+		break;
+	case S5C73M3_JPEG_PAD:
+		code = S5C73M3_JPEG_FMT;
+		fs = state->sensor_pix_size[RES_JPEG];
+		break;
+	default:
+		mutex_unlock(&state->lock);
+		return -EINVAL;
+	}
+	s5c73m3_fill_mbus_fmt(&fmt->format, fs, code);
+
+	mutex_unlock(&state->lock);
+	return 0;
+}
+
+static int s5c73m3_oif_get_fmt(struct v4l2_subdev *sd,
+			   struct v4l2_subdev_fh *fh,
+			   struct v4l2_subdev_format *fmt)
+{
+	struct s5c73m3 *state = oif_sd_to_s5c73m3(sd);
+	const struct s5c73m3_frame_size *fs;
+	u32 code;
+
+	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
+		fmt->format = *v4l2_subdev_get_try_format(fh, fmt->pad);
+		return 0;
+	}
+
+	mutex_lock(&state->lock);
+
+	switch (fmt->pad) {
+	case OIF_ISP_PAD:
+		code = S5C73M3_ISP_FMT;
+		fs = state->oif_pix_size[RES_ISP];
+		break;
+	case OIF_JPEG_PAD:
+		code = S5C73M3_JPEG_FMT;
+		fs = state->oif_pix_size[RES_JPEG];
+		break;
+	case OIF_SOURCE_PAD:
+		code = state->mbus_code;
+		fs = state->oif_pix_size[RES_ISP];
+		break;
+	default:
+		mutex_unlock(&state->lock);
+		return -EINVAL;
+	}
+	s5c73m3_fill_mbus_fmt(&fmt->format, fs, code);
+
+	mutex_unlock(&state->lock);
+	return 0;
+}
+
+static int s5c73m3_set_fmt(struct v4l2_subdev *sd,
+			   struct v4l2_subdev_fh *fh,
+			   struct v4l2_subdev_format *fmt)
+{
+	const struct s5c73m3_frame_size *frame_size = NULL;
+	struct s5c73m3 *state = sensor_sd_to_s5c73m3(sd);
+	struct v4l2_mbus_framefmt *mf;
+	int ret = 0;
+
+	mutex_lock(&state->lock);
+
+	s5c73m3_try_format(state, fh, fmt, &frame_size);
+
+	v4l2_dbg(1, sd, debug, "set pad=%d,which=%d,code=%08x,size=%dx%d\n",
+		 fmt->pad, fmt->which, fmt->format.code, fmt->format.width,
+		 fmt->format.height);
+
+	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
+		mf = v4l2_subdev_get_try_format(fh, fmt->pad);
+		*mf = fmt->format;
+	} else {
+		switch (fmt->pad) {
+		case S5C73M3_ISP_PAD:
+			state->sensor_pix_size[RES_ISP] = frame_size;
+			break;
+		case S5C73M3_JPEG_PAD:
+			state->sensor_pix_size[RES_JPEG] = frame_size;
+			break;
+		default:
+			ret = -EBUSY;
+		}
+
+		if (state->streaming)
+			ret = -EBUSY;
+		else
+			state->apply_fmt = 1;
+	}
+
+	mutex_unlock(&state->lock);
+
+	return ret;
+}
+
+static int s5c73m3_oif_set_fmt(struct v4l2_subdev *sd,
+			 struct v4l2_subdev_fh *fh,
+			 struct v4l2_subdev_format *fmt)
+{
+	const struct s5c73m3_frame_size *frame_size = NULL;
+	struct s5c73m3 *state = oif_sd_to_s5c73m3(sd);
+	struct v4l2_mbus_framefmt *mf;
+	int ret = 0;
+
+	mutex_lock(&state->lock);
+
+	s5c73m3_oif_try_format(state, fh, fmt, &frame_size);
+
+	v4l2_dbg(1, sd, debug, "set pad=%d,which=%d,code=%08x,size=%dx%d\n",
+		 fmt->pad, fmt->which, fmt->format.code, fmt->format.width,
+		 fmt->format.height);
+
+	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
+		mf = v4l2_subdev_get_try_format(fh, fmt->pad);
+		*mf = fmt->format;
+	} else {
+		switch (fmt->pad) {
+		case OIF_ISP_PAD:
+			state->oif_pix_size[RES_ISP] = frame_size;
+			break;
+		case OIF_JPEG_PAD:
+			state->oif_pix_size[RES_JPEG] = frame_size;
+			break;
+		case OIF_SOURCE_PAD:
+			state->mbus_code = fmt->format.code;
+			break;
+		default:
+			ret = -EBUSY;
+		}
+
+		if (state->streaming)
+			ret = -EBUSY;
+		else
+			state->apply_fmt = 1;
+	}
+
+	mutex_unlock(&state->lock);
+
+	return ret;
+}
+
+static int s5c73m3_oif_get_frame_desc(struct v4l2_subdev *sd, unsigned int pad,
+				  struct v4l2_mbus_frame_desc *fd)
+{
+	struct s5c73m3 *state = oif_sd_to_s5c73m3(sd);
+	int i;
+
+	if (pad != OIF_SOURCE_PAD || fd == NULL)
+		return -EINVAL;
+
+	mutex_lock(&state->lock);
+	fd->num_entries = 2;
+	for (i = 0; i < fd->num_entries; i++)
+		fd->entry[i] = state->frame_desc.entry[i];
+	mutex_unlock(&state->lock);
+
+	return 0;
+}
+
+static int s5c73m3_oif_set_frame_desc(struct v4l2_subdev *sd, unsigned int pad,
+				      struct v4l2_mbus_frame_desc *fd)
+{
+	struct s5c73m3 *state = oif_sd_to_s5c73m3(sd);
+	struct v4l2_mbus_frame_desc *frame_desc = &state->frame_desc;
+	int i;
+
+	if (pad != OIF_SOURCE_PAD || fd == NULL)
+		return -EINVAL;
+
+	fd->entry[0].length = 10 * SZ_1M;
+	fd->entry[1].length = max_t(u32, fd->entry[1].length,
+				    S5C73M3_EMBEDDED_DATA_MAXLEN);
+	fd->num_entries = 2;
+
+	mutex_lock(&state->lock);
+	for (i = 0; i < fd->num_entries; i++)
+		frame_desc->entry[i] = fd->entry[i];
+	mutex_unlock(&state->lock);
+
+	return 0;
+}
+
+static int s5c73m3_enum_mbus_code(struct v4l2_subdev *sd,
+				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_mbus_code_enum *code)
+{
+	static const int codes[] = {
+			[S5C73M3_ISP_PAD] = S5C73M3_ISP_FMT,
+			[S5C73M3_JPEG_PAD] = S5C73M3_JPEG_FMT};
+
+	if (code->index > 0 || code->pad >= S5C73M3_NUM_PADS)
+		return -EINVAL;
+
+	code->code = codes[code->pad];
+
+	return 0;
+}
+
+static int s5c73m3_oif_enum_mbus_code(struct v4l2_subdev *sd,
+				struct v4l2_subdev_fh *fh,
+				struct v4l2_subdev_mbus_code_enum *code)
+{
+	int ret;
+
+	ret = s5c73m3_oif_get_pad_code(code->pad, code->index);
+	if (ret < 0)
+		return ret;
+
+	code->code = ret;
+
+	return 0;
+}
+
+static int s5c73m3_enum_frame_size(struct v4l2_subdev *sd,
+				   struct v4l2_subdev_fh *fh,
+				   struct v4l2_subdev_frame_size_enum *fse)
+{
+	int idx;
+
+	if (fse->pad == S5C73M3_ISP_PAD) {
+		if (fse->code != S5C73M3_ISP_FMT)
+			return -EINVAL;
+		idx = RES_ISP;
+	} else{
+		if (fse->code != S5C73M3_JPEG_FMT)
+			return -EINVAL;
+		idx = RES_JPEG;
+	}
+
+	if (fse->index >= s5c73m3_resolutions_len[idx])
+		return -EINVAL;
+
+	fse->min_width  = s5c73m3_resolutions[idx][fse->index].width;
+	fse->max_width  = fse->min_width;
+	fse->max_height = s5c73m3_resolutions[idx][fse->index].height;
+	fse->min_height = fse->max_height;
+
+	return 0;
+}
+
+static int s5c73m3_oif_enum_frame_size(struct v4l2_subdev *sd,
+				   struct v4l2_subdev_fh *fh,
+				   struct v4l2_subdev_frame_size_enum *fse)
+{
+	int idx;
+
+	if (fse->pad == OIF_SOURCE_PAD) {
+		if (fse->index > 0)
+			return -EINVAL;
+
+		switch (fse->code) {
+		case S5C73M3_JPEG_FMT:
+		case S5C73M3_ISP_FMT: {
+			struct v4l2_mbus_framefmt *mf =
+				v4l2_subdev_get_try_format(fh, OIF_ISP_PAD);
+
+			fse->max_width = fse->min_width = mf->width;
+			fse->max_height = fse->min_height = mf->height;
+			return 0;
+		}
+		default:
+			return -EINVAL;
+		}
+	}
+
+	if (fse->code != s5c73m3_oif_get_pad_code(fse->pad, 0))
+		return -EINVAL;
+
+	if (fse->pad == OIF_JPEG_PAD)
+		idx = RES_JPEG;
+	else
+		idx = RES_ISP;
+
+	if (fse->index >= s5c73m3_resolutions_len[idx])
+		return -EINVAL;
+
+	fse->min_width  = s5c73m3_resolutions[idx][fse->index].width;
+	fse->max_width  = fse->min_width;
+	fse->max_height = s5c73m3_resolutions[idx][fse->index].height;
+	fse->min_height = fse->max_height;
+
+	return 0;
+}
+
+static int s5c73m3_oif_log_status(struct v4l2_subdev *sd)
+{
+	struct s5c73m3 *state = oif_sd_to_s5c73m3(sd);
+
+	v4l2_ctrl_handler_log_status(sd->ctrl_handler, sd->name);
+
+	v4l2_info(sd, "power: %d, apply_fmt: %d\n", state->power,
+							state->apply_fmt);
+
+	return 0;
+}
+
+static int s5c73m3_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	struct v4l2_mbus_framefmt *mf;
+
+	mf = v4l2_subdev_get_try_format(fh, S5C73M3_ISP_PAD);
+	s5c73m3_fill_mbus_fmt(mf, &s5c73m3_isp_resolutions[1],
+						S5C73M3_ISP_FMT);
+
+	mf = v4l2_subdev_get_try_format(fh, S5C73M3_JPEG_PAD);
+	s5c73m3_fill_mbus_fmt(mf, &s5c73m3_jpeg_resolutions[1],
+					S5C73M3_JPEG_FMT);
+
+	return 0;
+}
+
+static int s5c73m3_oif_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	struct v4l2_mbus_framefmt *mf;
+
+	mf = v4l2_subdev_get_try_format(fh, OIF_ISP_PAD);
+	s5c73m3_fill_mbus_fmt(mf, &s5c73m3_isp_resolutions[1],
+						S5C73M3_ISP_FMT);
+
+	mf = v4l2_subdev_get_try_format(fh, OIF_JPEG_PAD);
+	s5c73m3_fill_mbus_fmt(mf, &s5c73m3_jpeg_resolutions[1],
+					S5C73M3_JPEG_FMT);
+
+	mf = v4l2_subdev_get_try_format(fh, OIF_SOURCE_PAD);
+	s5c73m3_fill_mbus_fmt(mf, &s5c73m3_isp_resolutions[1],
+						S5C73M3_ISP_FMT);
+	return 0;
+}
+
+static int s5c73m3_gpio_set_value(struct s5c73m3 *priv, int id, u32 val)
+{
+	if (!gpio_is_valid(priv->gpio[id].gpio))
+		return 0;
+	gpio_set_value(priv->gpio[id].gpio, !!val);
+	return 1;
+}
+
+static int s5c73m3_gpio_assert(struct s5c73m3 *priv, int id)
+{
+	return s5c73m3_gpio_set_value(priv, id, priv->gpio[id].level);
+}
+
+static int s5c73m3_gpio_deassert(struct s5c73m3 *priv, int id)
+{
+	return s5c73m3_gpio_set_value(priv, id, !priv->gpio[id].level);
+}
+
+static int __s5c73m3_power_on(struct s5c73m3 *state)
+{
+	int i, ret;
+
+	for (i = 0; i < S5C73M3_MAX_SUPPLIES; i++) {
+		ret = regulator_enable(state->supplies[i].consumer);
+		if (ret)
+			goto err;
+	}
+
+	s5c73m3_gpio_deassert(state, STBY);
+	usleep_range(100, 200);
+
+	s5c73m3_gpio_deassert(state, RST);
+	usleep_range(50, 100);
+
+	return 0;
+err:
+	for (--i; i >= 0; i--)
+		regulator_disable(state->supplies[i].consumer);
+	return ret;
+}
+
+static int __s5c73m3_power_off(struct s5c73m3 *state)
+{
+	int i, ret;
+
+	if (s5c73m3_gpio_assert(state, RST))
+		usleep_range(10, 50);
+
+	if (s5c73m3_gpio_assert(state, STBY))
+		usleep_range(100, 200);
+	state->streaming = 0;
+	state->isp_ready = 0;
+
+	for (i = S5C73M3_MAX_SUPPLIES - 1; i >= 0; i--) {
+		ret = regulator_disable(state->supplies[i].consumer);
+		if (ret)
+			goto err;
+	}
+	return 0;
+err:
+	for (++i; i < S5C73M3_MAX_SUPPLIES; i++)
+		regulator_enable(state->supplies[i].consumer);
+
+	return ret;
+}
+
+static int s5c73m3_oif_set_power(struct v4l2_subdev *sd, int on)
+{
+	struct s5c73m3 *state = oif_sd_to_s5c73m3(sd);
+	int ret = 0;
+
+	mutex_lock(&state->lock);
+
+	if (on && !state->power) {
+		ret = __s5c73m3_power_on(state);
+		if (!ret)
+			ret = s5c73m3_isp_init(state);
+		if (!ret) {
+			state->apply_fiv = 1;
+			state->apply_fmt = 1;
+		}
+	} else if (!on == state->power) {
+		ret = s5c73m3_set_af_softlanding(state);
+		if (!ret)
+			ret = __s5c73m3_power_off(state);
+		else
+			v4l2_err(sd, "Soft landing lens failed\n");
+	}
+	if (!ret)
+		state->power += on ? 1 : -1;
+
+	v4l2_dbg(1, s5c73m3_dbg, sd, "%s: power: %d\n",
+		 __func__, state->power);
+
+	mutex_unlock(&state->lock);
+	return ret;
+}
+
+static int s5c73m3_oif_registered(struct v4l2_subdev *sd)
+{
+	struct s5c73m3 *state = oif_sd_to_s5c73m3(sd);
+	int ret;
+
+	ret = v4l2_device_register_subdev(sd->v4l2_dev, &state->sensor_sd);
+	if (ret) {
+		v4l2_err(sd->v4l2_dev, "Failed to register %s\n",
+							state->oif_sd.name);
+		return ret;
+	}
+
+	ret = media_entity_create_link(&state->sensor_sd.entity,
+			S5C73M3_ISP_PAD, &state->oif_sd.entity, OIF_ISP_PAD,
+			MEDIA_LNK_FL_IMMUTABLE | MEDIA_LNK_FL_ENABLED);
+
+	ret = media_entity_create_link(&state->sensor_sd.entity,
+			S5C73M3_JPEG_PAD, &state->oif_sd.entity, OIF_JPEG_PAD,
+			MEDIA_LNK_FL_IMMUTABLE | MEDIA_LNK_FL_ENABLED);
+
+	mutex_lock(&state->lock);
+	ret = __s5c73m3_power_on(state);
+	if (ret == 0)
+		s5c73m3_get_fw_version(state);
+
+	__s5c73m3_power_off(state);
+	mutex_unlock(&state->lock);
+
+	v4l2_dbg(1, s5c73m3_dbg, sd, "%s: Booting %s (%d)\n",
+		 __func__, ret ? "failed" : "succeded", ret);
+
+	return ret;
+}
+
+static const struct v4l2_subdev_internal_ops s5c73m3_internal_ops = {
+	.open		= s5c73m3_open,
+};
+
+static const struct v4l2_subdev_pad_ops s5c73m3_pad_ops = {
+	.enum_mbus_code		= s5c73m3_enum_mbus_code,
+	.enum_frame_size	= s5c73m3_enum_frame_size,
+	.get_fmt		= s5c73m3_get_fmt,
+	.set_fmt		= s5c73m3_set_fmt,
+};
+
+static const struct v4l2_subdev_ops s5c73m3_subdev_ops = {
+	.pad	= &s5c73m3_pad_ops,
+};
+
+static const struct v4l2_subdev_internal_ops oif_internal_ops = {
+	.registered	= s5c73m3_oif_registered,
+	.open		= s5c73m3_oif_open,
+};
+
+static const struct v4l2_subdev_pad_ops s5c73m3_oif_pad_ops = {
+	.enum_mbus_code		= s5c73m3_oif_enum_mbus_code,
+	.enum_frame_size	= s5c73m3_oif_enum_frame_size,
+	.enum_frame_interval	= s5c73m3_oif_enum_frame_interval,
+	.get_fmt		= s5c73m3_oif_get_fmt,
+	.set_fmt		= s5c73m3_oif_set_fmt,
+	.get_frame_desc		= s5c73m3_oif_get_frame_desc,
+	.set_frame_desc		= s5c73m3_oif_set_frame_desc,
+};
+
+static const struct v4l2_subdev_core_ops s5c73m3_oif_core_ops = {
+	.s_power	= s5c73m3_oif_set_power,
+	.log_status	= s5c73m3_oif_log_status,
+};
+
+static const struct v4l2_subdev_video_ops s5c73m3_oif_video_ops = {
+	.s_stream		= s5c73m3_oif_s_stream,
+	.g_frame_interval	= s5c73m3_oif_g_frame_interval,
+	.s_frame_interval	= s5c73m3_oif_s_frame_interval,
+};
+
+static const struct v4l2_subdev_ops oif_subdev_ops = {
+	.core	= &s5c73m3_oif_core_ops,
+	.pad	= &s5c73m3_oif_pad_ops,
+	.video	= &s5c73m3_oif_video_ops,
+};
+
+static int s5c73m3_configure_gpio(int nr, int val, const char *name)
+{
+	unsigned long flags = val ? GPIOF_OUT_INIT_HIGH : GPIOF_OUT_INIT_LOW;
+	int ret;
+
+	if (!gpio_is_valid(nr))
+		return 0;
+	ret = gpio_request_one(nr, flags, name);
+	if (!ret)
+		gpio_export(nr, 0);
+	return ret;
+}
+
+static int s5c73m3_free_gpios(struct s5c73m3 *state)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(state->gpio); i++) {
+		if (!gpio_is_valid(state->gpio[i].gpio))
+			continue;
+		gpio_free(state->gpio[i].gpio);
+		state->gpio[i].gpio = -EINVAL;
+	}
+	return 0;
+}
+
+static int s5c73m3_configure_gpios(struct s5c73m3 *state,
+				   const struct s5c73m3_platform_data *pdata)
+{
+	const struct s5c73m3_gpio *gpio = &pdata->gpio_stby;
+	int ret;
+
+	state->gpio[STBY].gpio = -EINVAL;
+	state->gpio[RST].gpio  = -EINVAL;
+
+	ret = s5c73m3_configure_gpio(gpio->gpio, gpio->level, "S5C73M3_STBY");
+	if (ret) {
+		s5c73m3_free_gpios(state);
+		return ret;
+	}
+	state->gpio[STBY] = *gpio;
+	if (gpio_is_valid(gpio->gpio))
+		gpio_set_value(gpio->gpio, 0);
+
+	gpio = &pdata->gpio_reset;
+	ret = s5c73m3_configure_gpio(gpio->gpio, gpio->level, "S5C73M3_RST");
+	if (ret) {
+		s5c73m3_free_gpios(state);
+		return ret;
+	}
+	state->gpio[RST] = *gpio;
+	if (gpio_is_valid(gpio->gpio))
+		gpio_set_value(gpio->gpio, 0);
+
+	return 0;
+}
+
+static int __devinit s5c73m3_probe(struct i2c_client *client,
+				   const struct i2c_device_id *id)
+{
+	const struct s5c73m3_platform_data *pdata = client->dev.platform_data;
+	struct v4l2_subdev *sd;
+	struct v4l2_subdev *oif_sd;
+	struct s5c73m3 *state;
+	int ret, i;
+
+	if (pdata == NULL) {
+		dev_err(&client->dev, "Platform data not specified\n");
+		return -EINVAL;
+	}
+
+	state = devm_kzalloc(&client->dev, sizeof(*state), GFP_KERNEL);
+	if (!state)
+		return -ENOMEM;
+
+	mutex_init(&state->lock);
+	sd = &state->sensor_sd;
+	oif_sd = &state->oif_sd;
+
+	v4l2_subdev_init(sd, &s5c73m3_subdev_ops);
+	sd->owner = client->driver->driver.owner;
+	v4l2_set_subdevdata(sd, state);
+	strlcpy(sd->name, "S5C73M3", sizeof(sd->name));
+
+	sd->internal_ops = &s5c73m3_internal_ops;
+	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+
+	state->sensor_pads[S5C73M3_JPEG_PAD].flags = MEDIA_PAD_FL_SOURCE;
+	state->sensor_pads[S5C73M3_ISP_PAD].flags = MEDIA_PAD_FL_SOURCE;
+	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV;
+
+	ret = media_entity_init(&sd->entity, S5C73M3_NUM_PADS,
+							state->sensor_pads, 0);
+	if (ret < 0)
+		return ret;
+
+	v4l2_i2c_subdev_init(oif_sd, client, &oif_subdev_ops);
+	strcpy(oif_sd->name, "S5C73M3-OIF");
+
+	oif_sd->internal_ops = &oif_internal_ops;
+	oif_sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+
+	state->oif_pads[OIF_ISP_PAD].flags = MEDIA_PAD_FL_SINK;
+	state->oif_pads[OIF_JPEG_PAD].flags = MEDIA_PAD_FL_SINK;
+	state->oif_pads[OIF_SOURCE_PAD].flags = MEDIA_PAD_FL_SOURCE;
+	oif_sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV;
+
+	ret = media_entity_init(&oif_sd->entity, OIF_NUM_PADS,
+							state->oif_pads, 0);
+	if (ret < 0)
+		return ret;
+
+	state->mclk_frequency = pdata->mclk_frequency;
+	state->bus_type = pdata->bus_type;
+
+	ret = s5c73m3_configure_gpios(state, pdata);
+	if (ret)
+		goto out_err1;
+
+	for (i = 0; i < S5C73M3_MAX_SUPPLIES; i++)
+		state->supplies[i].supply = s5c73m3_supply_names[i];
+
+	ret = regulator_bulk_get(&client->dev, S5C73M3_MAX_SUPPLIES,
+			       state->supplies);
+	if (ret) {
+		dev_err(&client->dev, "failed to get regulators\n");
+		goto out_err2;
+	}
+
+	ret = s5c73m3_init_controls(state);
+	if (ret)
+		goto out_err3;
+
+	state->sensor_pix_size[RES_ISP] = &s5c73m3_isp_resolutions[1];
+	state->sensor_pix_size[RES_JPEG] = &s5c73m3_jpeg_resolutions[1];
+	state->oif_pix_size[RES_ISP] = state->sensor_pix_size[RES_ISP];
+	state->oif_pix_size[RES_JPEG] = state->sensor_pix_size[RES_JPEG];
+
+	state->mbus_code = S5C73M3_ISP_FMT;
+
+	state->fiv = &s5c73m3_intervals[S5C73M3_DEFAULT_FRAME_INTERVAL];
+
+	ret = s5c73m3_register_spi_driver(state);
+	if (ret < 0)
+		goto out_err3;
+
+	state->i2c_client = client;
+
+	v4l2_info(sd, "%s: completed succesfully\n", __func__);
+	return 0;
+
+out_err3:
+	regulator_bulk_free(S5C73M3_MAX_SUPPLIES, state->supplies);
+out_err2:
+	s5c73m3_free_gpios(state);
+out_err1:
+	media_entity_cleanup(&sd->entity);
+	return ret;
+}
+
+static int __devexit s5c73m3_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct s5c73m3 *state = sensor_sd_to_s5c73m3(sd);
+
+	v4l2_device_unregister_subdev(sd);
+
+	v4l2_ctrl_handler_free(sd->ctrl_handler);
+	media_entity_cleanup(&sd->entity);
+
+	s5c73m3_unregister_spi_driver(state);
+	regulator_bulk_free(S5C73M3_MAX_SUPPLIES, state->supplies);
+	s5c73m3_free_gpios(state);
+
+	return 0;
+}
+
+static const struct i2c_device_id s5c73m3_id[] = {
+	{ DRIVER_NAME, 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, s5c73m3_id);
+
+static struct i2c_driver s5c73m3_i2c_driver = {
+	.driver = {
+		.name	= DRIVER_NAME,
+	},
+	.probe		= s5c73m3_probe,
+	.remove		= __devexit_p(s5c73m3_remove),
+	.id_table	= s5c73m3_id,
+};
+
+module_i2c_driver(s5c73m3_i2c_driver);
+
+MODULE_DESCRIPTION("Samsung S5C73M3 camera driver");
+MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-ctrls.c b/drivers/media/i2c/s5c73m3/s5c73m3-ctrls.c
new file mode 100644
index 0000000..8001cde
--- /dev/null
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-ctrls.c
@@ -0,0 +1,563 @@
+/*
+ * Samsung LSI S5C73M3 8M pixel camera driver
+ *
+ * Copyright (C) 2012, Samsung Electronics, Co., Ltd.
+ * Sylwester Nawrocki <s.nawrocki@samsung.com>
+ * Andrzej Hajda <a.hajda@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/sizes.h>
+#include <linux/delay.h>
+#include <linux/firmware.h>
+#include <linux/gpio.h>
+#include <linux/i2c.h>
+#include <linux/init.h>
+#include <linux/media.h>
+#include <linux/module.h>
+#include <linux/regulator/consumer.h>
+#include <linux/slab.h>
+#include <linux/spi/spi.h>
+#include <linux/videodev2.h>
+#include <media/media-entity.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-subdev.h>
+#include <media/v4l2-mediabus.h>
+#include <media/s5c73m3.h>
+
+#include "s5c73m3.h"
+
+static int s5c73m3_get_af_status(struct s5c73m3 *state, struct v4l2_ctrl *ctrl)
+{
+	u16 reg = REG_AF_STATUS_UNFOCUSED;
+
+	int ret = s5c73m3_read(state, REG_AF_STATUS, &reg);
+
+	switch (reg) {
+	case REG_CAF_STATUS_FIND_SEARCH_DIR:
+	case REG_AF_STATUS_FOCUSING:
+	case REG_CAF_STATUS_FOCUSING:
+		ctrl->val = V4L2_AUTO_FOCUS_STATUS_BUSY;
+		break;
+	case REG_CAF_STATUS_FOCUSED:
+	case REG_AF_STATUS_FOCUSED:
+		ctrl->val = V4L2_AUTO_FOCUS_STATUS_REACHED;
+		break;
+	default:
+		v4l2_info(&state->sensor_sd, "Unknown AF status %#x\n", reg);
+		/* Fall through */
+	case REG_CAF_STATUS_UNFOCUSED:
+	case REG_AF_STATUS_UNFOCUSED:
+	case REG_AF_STATUS_INVALID:
+		ctrl->val = V4L2_AUTO_FOCUS_STATUS_FAILED;
+		break;
+	}
+
+	return ret;
+}
+
+static int s5c73m3_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct v4l2_subdev *sd = ctrl_to_sensor_sd(ctrl);
+	struct s5c73m3 *state = sensor_sd_to_s5c73m3(sd);
+	int ret;
+
+	if (state->power == 0)
+		return -EBUSY;
+
+	switch (ctrl->id) {
+	case V4L2_CID_FOCUS_AUTO:
+		ret = s5c73m3_get_af_status(state, state->ctrls.af_status);
+		if (ret)
+			return ret;
+		break;
+	}
+
+	return 0;
+}
+
+static int s5c73m3_set_colorfx(struct s5c73m3 *state, int val)
+{
+	static const unsigned short colorfx[][2] = {
+		{ V4L2_COLORFX_NONE,	 COMM_IMAGE_EFFECT_NONE },
+		{ V4L2_COLORFX_BW,	 COMM_IMAGE_EFFECT_MONO },
+		{ V4L2_COLORFX_SEPIA,	 COMM_IMAGE_EFFECT_SEPIA },
+		{ V4L2_COLORFX_NEGATIVE, COMM_IMAGE_EFFECT_NEGATIVE },
+		{ V4L2_COLORFX_AQUA,	 COMM_IMAGE_EFFECT_AQUA },
+	};
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(colorfx); i++) {
+		if (colorfx[i][0] != val)
+			continue;
+
+		v4l2_dbg(1, s5c73m3_dbg, &state->sensor_sd,
+			 "Setting %s color effect\n",
+			 v4l2_ctrl_get_menu(state->ctrls.colorfx->id)[i]);
+
+		return s5c73m3_isp_command(state, COMM_IMAGE_EFFECT,
+					 colorfx[i][1]);
+	}
+	return -EINVAL;
+}
+
+/* Set exposure metering/exposure bias */
+static int s5c73m3_set_exposure(struct s5c73m3 *state, int auto_exp)
+{
+	struct v4l2_subdev *sd = &state->sensor_sd;
+	struct s5c73m3_ctrls *ctrls = &state->ctrls;
+	int ret = 0;
+
+	if (ctrls->exposure_metering->is_new) {
+		u16 metering;
+
+		switch (ctrls->exposure_metering->val) {
+		case V4L2_EXPOSURE_METERING_CENTER_WEIGHTED:
+			metering = COMM_METERING_CENTER;
+			break;
+		case V4L2_EXPOSURE_METERING_SPOT:
+			metering = COMM_METERING_SPOT;
+			break;
+		default:
+			metering = COMM_METERING_AVERAGE;
+			break;
+		}
+
+		ret = s5c73m3_isp_command(state, COMM_METERING, metering);
+	}
+
+	if (!ret && ctrls->exposure_bias->is_new) {
+		u16 exp_bias = ctrls->exposure_bias->val;
+		ret = s5c73m3_isp_command(state, COMM_EV, exp_bias);
+	}
+
+	v4l2_dbg(1, s5c73m3_dbg, sd,
+		 "%s: exposure bias: %#x, metering: %#x (%d)\n",  __func__,
+		 ctrls->exposure_bias->val, ctrls->exposure_metering->val, ret);
+
+	return ret;
+}
+
+static int s5c73m3_set_white_balance(struct s5c73m3 *state, int val)
+{
+	static const unsigned short wb[][2] = {
+		{ V4L2_WHITE_BALANCE_INCANDESCENT,  COMM_AWB_MODE_INCANDESCENT},
+		{ V4L2_WHITE_BALANCE_FLUORESCENT,   COMM_AWB_MODE_FLUORESCENT1},
+		{ V4L2_WHITE_BALANCE_FLUORESCENT_H, COMM_AWB_MODE_FLUORESCENT2},
+		{ V4L2_WHITE_BALANCE_CLOUDY,        COMM_AWB_MODE_CLOUDY},
+		{ V4L2_WHITE_BALANCE_DAYLIGHT,      COMM_AWB_MODE_DAYLIGHT},
+		{ V4L2_WHITE_BALANCE_AUTO,          COMM_AWB_MODE_AUTO},
+	};
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(wb); i++) {
+		if (wb[i][0] != val)
+			continue;
+
+		v4l2_dbg(1, s5c73m3_dbg, &state->sensor_sd,
+			 "Setting white balance to: %s\n",
+			 v4l2_ctrl_get_menu(state->ctrls.auto_wb->id)[i]);
+
+		return s5c73m3_isp_command(state, COMM_AWB_MODE, wb[i][1]);
+	}
+
+	return -EINVAL;
+}
+
+static int s5c73m3_af_run(struct s5c73m3 *state, bool on)
+{
+	struct s5c73m3_ctrls *c = &state->ctrls;
+
+	if (!on)
+		return s5c73m3_isp_command(state, COMM_AF_CON,
+							COMM_AF_CON_STOP);
+
+	if (c->focus_auto->val)
+		return s5c73m3_isp_command(state, COMM_AF_MODE,
+					   COMM_AF_MODE_PREVIEW_CAF_START);
+
+	return s5c73m3_isp_command(state, COMM_AF_CON, COMM_AF_CON_START);
+}
+
+static int s5c73m3_3a_lock(struct s5c73m3 *state, struct v4l2_ctrl *ctrl)
+{
+	bool awb_lock = ctrl->val & V4L2_LOCK_WHITE_BALANCE;
+	bool ae_lock = ctrl->val & V4L2_LOCK_EXPOSURE;
+	bool af_lock = ctrl->val & V4L2_LOCK_FOCUS;
+	int ret = 0;
+
+	if ((ctrl->val ^ ctrl->cur.val) & V4L2_LOCK_EXPOSURE) {
+		ret = s5c73m3_isp_command(state, COMM_AE_CON,
+				ae_lock ? COMM_AE_STOP : COMM_AE_START);
+		if (ret)
+			return ret;
+	}
+
+	if (((ctrl->val ^ ctrl->cur.val) & V4L2_LOCK_WHITE_BALANCE)
+	    && state->ctrls.auto_wb->val) {
+		ret = s5c73m3_isp_command(state, COMM_AWB_CON,
+			awb_lock ? COMM_AWB_STOP : COMM_AWB_START);
+		if (ret)
+			return ret;
+	}
+
+	if ((ctrl->val ^ ctrl->cur.val) & V4L2_LOCK_FOCUS)
+		ret = s5c73m3_af_run(state, ~af_lock);
+
+	return ret;
+}
+
+static int s5c73m3_set_auto_focus(struct s5c73m3 *state, int caf)
+{
+	struct s5c73m3_ctrls *c = &state->ctrls;
+	int ret = 1;
+
+	if (c->af_distance->is_new) {
+		u16 mode = (c->af_distance->val == V4L2_AUTO_FOCUS_RANGE_MACRO)
+				? COMM_AF_MODE_MACRO : COMM_AF_MODE_NORMAL;
+		ret = s5c73m3_isp_command(state, COMM_AF_MODE, mode);
+		if (ret != 0)
+			return ret;
+	}
+
+	if (!ret || (c->focus_auto->is_new && c->focus_auto->val) ||
+							c->af_start->is_new)
+		ret = s5c73m3_af_run(state, 1);
+	else if ((c->focus_auto->is_new && !c->focus_auto->val) ||
+							c->af_stop->is_new)
+		ret = s5c73m3_af_run(state, 0);
+	else
+		ret = 0;
+
+	return ret;
+}
+
+static int s5c73m3_set_contrast(struct s5c73m3 *state, int val)
+{
+	u16 reg = (val < 0) ? -val + 2 : val;
+	return s5c73m3_isp_command(state, COMM_CONTRAST, reg);
+}
+
+static int s5c73m3_set_saturation(struct s5c73m3 *state, int val)
+{
+	u16 reg = (val < 0) ? -val + 2 : val;
+	return s5c73m3_isp_command(state, COMM_SATURATION, reg);
+}
+
+static int s5c73m3_set_sharpness(struct s5c73m3 *state, int val)
+{
+	u16 reg = (val < 0) ? -val + 2 : val;
+	return s5c73m3_isp_command(state, COMM_SHARPNESS, reg);
+}
+
+static int s5c73m3_set_iso(struct s5c73m3 *state, int val)
+{
+	u32 iso;
+
+	if (val == V4L2_ISO_SENSITIVITY_MANUAL)
+		iso = state->ctrls.iso->val + 1;
+	else
+		iso = 0;
+
+	return s5c73m3_isp_command(state, COMM_ISO, iso);
+}
+
+static int s5c73m3_set_stabilization(struct s5c73m3 *state, int val)
+{
+	struct v4l2_subdev *sd = &state->sensor_sd;
+
+	v4l2_dbg(1, s5c73m3_dbg, sd, "Image stabilization: %d\n", val);
+
+	return s5c73m3_isp_command(state, COMM_FRAME_RATE, val ?
+			COMM_FRAME_RATE_ANTI_SHAKE : COMM_FRAME_RATE_AUTO_SET);
+}
+
+static int s5c73m3_set_jpeg_quality(struct s5c73m3 *state, int quality)
+{
+	int reg;
+
+	if (quality <= 65)
+		reg = COMM_IMAGE_QUALITY_NORMAL;
+	else if (quality <= 75)
+		reg = COMM_IMAGE_QUALITY_FINE;
+	else
+		reg = COMM_IMAGE_QUALITY_SUPERFINE;
+
+	return s5c73m3_isp_command(state, COMM_IMAGE_QUALITY, reg);
+}
+
+static int s5c73m3_set_scene_program(struct s5c73m3 *state, int val)
+{
+	static const unsigned short scene_lookup[] = {
+		COMM_SCENE_MODE_NONE,	     /* V4L2_SCENE_MODE_NONE */
+		COMM_SCENE_MODE_AGAINST_LIGHT,/* V4L2_SCENE_MODE_BACKLIGHT */
+		COMM_SCENE_MODE_BEACH,	     /* V4L2_SCENE_MODE_BEACH_SNOW */
+		COMM_SCENE_MODE_CANDLE,	     /* V4L2_SCENE_MODE_CANDLE_LIGHT */
+		COMM_SCENE_MODE_DAWN,	     /* V4L2_SCENE_MODE_DAWN_DUSK */
+		COMM_SCENE_MODE_FALL,	     /* V4L2_SCENE_MODE_FALL_COLORS */
+		COMM_SCENE_MODE_FIRE,	     /* V4L2_SCENE_MODE_FIREWORKS */
+		COMM_SCENE_MODE_LANDSCAPE,    /* V4L2_SCENE_MODE_LANDSCAPE */
+		COMM_SCENE_MODE_NIGHT,	     /* V4L2_SCENE_MODE_NIGHT */
+		COMM_SCENE_MODE_INDOOR,	     /* V4L2_SCENE_MODE_PARTY_INDOOR */
+		COMM_SCENE_MODE_PORTRAIT,     /* V4L2_SCENE_MODE_PORTRAIT */
+		COMM_SCENE_MODE_SPORTS,	     /* V4L2_SCENE_MODE_SPORTS */
+		COMM_SCENE_MODE_SUNSET,	     /* V4L2_SCENE_MODE_SUNSET */
+		COMM_SCENE_MODE_TEXT,	     /* V4L2_SCENE_MODE_TEXT */
+	};
+
+	v4l2_dbg(1, s5c73m3_dbg, &state->sensor_sd, "Setting %s scene mode\n",
+		 v4l2_ctrl_get_menu(state->ctrls.scene_mode->id)[val]);
+
+	return s5c73m3_isp_command(state, COMM_SCENE_MODE, scene_lookup[val]);
+}
+
+static int s5c73m3_set_power_line_freq(struct s5c73m3 *state, int val)
+{
+	unsigned int pwr_line_freq = COMM_FLICKER_NONE;
+
+	switch (val) {
+	case V4L2_CID_POWER_LINE_FREQUENCY_DISABLED:
+		pwr_line_freq = COMM_FLICKER_NONE;
+		break;
+	case V4L2_CID_POWER_LINE_FREQUENCY_50HZ:
+		pwr_line_freq = COMM_FLICKER_AUTO_50HZ;
+		break;
+	case V4L2_CID_POWER_LINE_FREQUENCY_60HZ:
+		pwr_line_freq = COMM_FLICKER_AUTO_60HZ;
+		break;
+	default:
+	case V4L2_CID_POWER_LINE_FREQUENCY_AUTO:
+		pwr_line_freq = COMM_FLICKER_NONE;
+	}
+
+	return s5c73m3_isp_command(state, COMM_FLICKER_MODE, pwr_line_freq);
+}
+
+static int s5c73m3_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct v4l2_subdev *sd = ctrl_to_sensor_sd(ctrl);
+	struct s5c73m3 *state = sensor_sd_to_s5c73m3(sd);
+	int ret = 0;
+
+	v4l2_dbg(1, s5c73m3_dbg, sd, "set_ctrl: %s, value: %d\n",
+		 ctrl->name, ctrl->val);
+
+	mutex_lock(&state->lock);
+	/*
+	 * If the device is not powered up by the host driver do
+	 * not apply any controls to H/W at this time. Instead
+	 * the controls will be restored right after power-up.
+	 */
+	if (state->power == 0)
+		goto unlock;
+
+	if (ctrl->flags & V4L2_CTRL_FLAG_INACTIVE) {
+		ret = -EINVAL;
+		goto unlock;
+	}
+
+	switch (ctrl->id) {
+	case V4L2_CID_3A_LOCK:
+		ret = s5c73m3_3a_lock(state, ctrl);
+		break;
+
+	case V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE:
+		ret = s5c73m3_set_white_balance(state, ctrl->val);
+		break;
+
+	case V4L2_CID_CONTRAST:
+		ret = s5c73m3_set_contrast(state, ctrl->val);
+		break;
+
+	case V4L2_CID_COLORFX:
+		ret = s5c73m3_set_colorfx(state, ctrl->val);
+		break;
+
+	case V4L2_CID_EXPOSURE_AUTO:
+		ret = s5c73m3_set_exposure(state, ctrl->val);
+		break;
+
+	case V4L2_CID_FOCUS_AUTO:
+		ret = s5c73m3_set_auto_focus(state, ctrl->val);
+		break;
+
+	case V4L2_CID_IMAGE_STABILIZATION:
+		ret = s5c73m3_set_stabilization(state, ctrl->val);
+		break;
+
+	case V4L2_CID_ISO_SENSITIVITY:
+		ret = s5c73m3_set_iso(state, ctrl->val);
+		break;
+
+	case V4L2_CID_JPEG_COMPRESSION_QUALITY:
+		ret = s5c73m3_set_jpeg_quality(state, ctrl->val);
+		break;
+
+	case V4L2_CID_POWER_LINE_FREQUENCY:
+		ret = s5c73m3_set_power_line_freq(state, ctrl->val);
+		break;
+
+	case V4L2_CID_SATURATION:
+		ret = s5c73m3_set_saturation(state, ctrl->val);
+		break;
+
+	case V4L2_CID_SCENE_MODE:
+		ret = s5c73m3_set_scene_program(state, ctrl->val);
+		break;
+
+	case V4L2_CID_SHARPNESS:
+		ret = s5c73m3_set_sharpness(state, ctrl->val);
+		break;
+
+	case V4L2_CID_WIDE_DYNAMIC_RANGE:
+		ret = s5c73m3_isp_command(state, COMM_WDR, !!ctrl->val);
+		break;
+
+	case V4L2_CID_ZOOM_ABSOLUTE:
+		ret = s5c73m3_isp_command(state, COMM_ZOOM_STEP, ctrl->val);
+		break;
+	}
+unlock:
+	mutex_unlock(&state->lock);
+	return ret;
+}
+
+static const struct v4l2_ctrl_ops s5c73m3_ctrl_ops = {
+	.g_volatile_ctrl	= s5c73m3_g_volatile_ctrl,
+	.s_ctrl			= s5c73m3_s_ctrl,
+};
+
+/* Supported manual ISO values */
+static const s64 iso_qmenu[] = {
+	/* COMM_ISO: 0x0001...0x0004 */
+	100, 200, 400, 800,
+};
+
+/* Supported exposure bias values (-2.0EV...+2.0EV) */
+static const s64 ev_bias_qmenu[] = {
+	/* COMM_EV: 0x0000...0x0008 */
+	-2000, -1500, -1000, -500, 0, 500, 1000, 1500, 2000
+};
+
+int s5c73m3_init_controls(struct s5c73m3 *state)
+{
+	const struct v4l2_ctrl_ops *ops = &s5c73m3_ctrl_ops;
+	struct s5c73m3_ctrls *ctrls = &state->ctrls;
+	struct v4l2_ctrl_handler *hdl = &ctrls->handler;
+
+	int ret = v4l2_ctrl_handler_init(hdl, 22);
+	if (ret)
+		return ret;
+
+	/* White balance */
+	ctrls->auto_wb = v4l2_ctrl_new_std_menu(hdl, ops,
+			V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE,
+			9, ~0x15e, V4L2_WHITE_BALANCE_AUTO);
+
+	/* Exposure (only automatic exposure) */
+	ctrls->auto_exposure = v4l2_ctrl_new_std_menu(hdl, ops,
+			V4L2_CID_EXPOSURE_AUTO, 0, ~0x01, V4L2_EXPOSURE_AUTO);
+
+	ctrls->exposure_bias = v4l2_ctrl_new_int_menu(hdl, ops,
+			V4L2_CID_AUTO_EXPOSURE_BIAS,
+			ARRAY_SIZE(ev_bias_qmenu) - 1,
+			ARRAY_SIZE(ev_bias_qmenu)/2 - 1,
+			ev_bias_qmenu);
+
+	ctrls->exposure_metering = v4l2_ctrl_new_std_menu(hdl, ops,
+			V4L2_CID_EXPOSURE_METERING,
+			2, ~0x7, V4L2_EXPOSURE_METERING_AVERAGE);
+
+	/* Auto focus */
+	ctrls->focus_auto = v4l2_ctrl_new_std(hdl, ops,
+			V4L2_CID_FOCUS_AUTO, 0, 1, 1, 0);
+
+	ctrls->af_start = v4l2_ctrl_new_std(hdl, ops,
+			V4L2_CID_AUTO_FOCUS_START, 0, 1, 1, 0);
+
+	ctrls->af_stop = v4l2_ctrl_new_std(hdl, ops,
+			V4L2_CID_AUTO_FOCUS_STOP, 0, 1, 1, 0);
+
+	ctrls->af_status = v4l2_ctrl_new_std(hdl, ops,
+			V4L2_CID_AUTO_FOCUS_STATUS, 0,
+			(V4L2_AUTO_FOCUS_STATUS_BUSY |
+			 V4L2_AUTO_FOCUS_STATUS_REACHED |
+			 V4L2_AUTO_FOCUS_STATUS_FAILED),
+			0, V4L2_AUTO_FOCUS_STATUS_IDLE);
+
+	ctrls->af_distance = v4l2_ctrl_new_std_menu(hdl, ops,
+			V4L2_CID_AUTO_FOCUS_RANGE,
+			V4L2_AUTO_FOCUS_RANGE_MACRO,
+			~(1 << V4L2_AUTO_FOCUS_RANGE_NORMAL |
+			  1 << V4L2_AUTO_FOCUS_RANGE_MACRO),
+			V4L2_AUTO_FOCUS_RANGE_NORMAL);
+	/* ISO sensitivity */
+	ctrls->auto_iso = v4l2_ctrl_new_std_menu(hdl, ops,
+			V4L2_CID_ISO_SENSITIVITY_AUTO, 1, 0,
+			V4L2_ISO_SENSITIVITY_AUTO);
+
+	ctrls->iso = v4l2_ctrl_new_int_menu(hdl, ops,
+			V4L2_CID_ISO_SENSITIVITY, ARRAY_SIZE(iso_qmenu) - 1,
+			ARRAY_SIZE(iso_qmenu)/2 - 1, iso_qmenu);
+
+	ctrls->contrast = v4l2_ctrl_new_std(hdl, ops,
+			V4L2_CID_CONTRAST, -2, 2, 1, 0);
+
+	ctrls->saturation = v4l2_ctrl_new_std(hdl, ops,
+			V4L2_CID_SATURATION, -2, 2, 1, 0);
+
+	ctrls->sharpness = v4l2_ctrl_new_std(hdl, ops,
+			V4L2_CID_SHARPNESS, -2, 2, 1, 0);
+
+	ctrls->zoom = v4l2_ctrl_new_std(hdl, ops,
+			V4L2_CID_ZOOM_ABSOLUTE, 0, 30, 1, 0);
+
+	ctrls->colorfx = v4l2_ctrl_new_std_menu(hdl, ops, V4L2_CID_COLORFX,
+			V4L2_COLORFX_AQUA, ~0x40f, V4L2_COLORFX_NONE);
+
+	ctrls->wdr = v4l2_ctrl_new_std(hdl, ops,
+			V4L2_CID_WIDE_DYNAMIC_RANGE, 0, 1, 1, 0);
+
+	ctrls->stabilization = v4l2_ctrl_new_std(hdl, ops,
+			V4L2_CID_IMAGE_STABILIZATION, 0, 1, 1, 0);
+
+	v4l2_ctrl_new_std_menu(hdl, ops, V4L2_CID_POWER_LINE_FREQUENCY,
+			       V4L2_CID_POWER_LINE_FREQUENCY_AUTO, 0,
+			       V4L2_CID_POWER_LINE_FREQUENCY_AUTO);
+
+	ctrls->jpeg_quality = v4l2_ctrl_new_std(hdl, ops,
+			V4L2_CID_JPEG_COMPRESSION_QUALITY, 1, 100, 1, 80);
+
+	ctrls->scene_mode = v4l2_ctrl_new_std_menu(hdl, ops,
+			V4L2_CID_SCENE_MODE, V4L2_SCENE_MODE_TEXT, ~0x3fff,
+			V4L2_SCENE_MODE_NONE);
+
+	ctrls->aaa_lock = v4l2_ctrl_new_std(hdl, ops,
+			V4L2_CID_3A_LOCK, 0, 0x7, 0, 0);
+
+	if (hdl->error) {
+		ret = hdl->error;
+		v4l2_ctrl_handler_free(hdl);
+		return ret;
+	}
+
+	v4l2_ctrl_auto_cluster(3, &ctrls->auto_exposure, 0, false);
+	ctrls->auto_iso->flags |= V4L2_CTRL_FLAG_VOLATILE |
+				V4L2_CTRL_FLAG_UPDATE;
+	v4l2_ctrl_auto_cluster(2, &ctrls->auto_iso, 0, false);
+	ctrls->af_status->flags |= V4L2_CTRL_FLAG_VOLATILE;
+	v4l2_ctrl_cluster(6, &ctrls->focus_auto);
+
+	state->sensor_sd.ctrl_handler = hdl;
+
+	return 0;
+}
diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-spi.c b/drivers/media/i2c/s5c73m3/s5c73m3-spi.c
new file mode 100644
index 0000000..889139c
--- /dev/null
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-spi.c
@@ -0,0 +1,156 @@
+/*
+ * Samsung LSI S5C73M3 8M pixel camera driver
+ *
+ * Copyright (C) 2012, Samsung Electronics, Co., Ltd.
+ * Sylwester Nawrocki <s.nawrocki@samsung.com>
+ * Andrzej Hajda <a.hajda@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/sizes.h>
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/media.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/spi/spi.h>
+
+#include "s5c73m3.h"
+
+#define S5C73M3_SPI_DRV_NAME "S5C73M3-SPI"
+
+enum spi_direction {
+	SPI_DIR_RX,
+	SPI_DIR_TX
+};
+
+static int spi_xmit(struct spi_device *spi_dev, void *addr, const int len,
+							enum spi_direction dir)
+{
+	struct spi_message msg;
+	int r;
+	struct spi_transfer xfer = {
+		.len	= len,
+	};
+
+	if (dir == SPI_DIR_TX)
+		xfer.tx_buf = addr;
+	else
+		xfer.rx_buf = addr;
+
+	if (spi_dev == NULL) {
+		dev_err(&spi_dev->dev, "SPI device is uninitialized\n");
+		return -ENODEV;
+	}
+
+	spi_message_init(&msg);
+	spi_message_add_tail(&xfer, &msg);
+
+	r = spi_sync(spi_dev, &msg);
+	if (r < 0)
+		dev_err(&spi_dev->dev, "%s spi_sync failed %d\n", __func__, r);
+
+	return r;
+}
+
+int s5c73m3_spi_write(struct s5c73m3 *state, const void *addr,
+		      const unsigned int len, const unsigned int tx_size)
+{
+	struct spi_device *spi_dev = state->spi_dev;
+	u32 count = len / tx_size;
+	u32 extra = len % tx_size;
+	unsigned int i, j = 0;
+	u8 padding[32];
+	int r = 0;
+
+	memset(padding, 0, sizeof(padding));
+
+	for (i = 0; i < count ; i++) {
+		r = spi_xmit(spi_dev, (void *)addr + j, tx_size, SPI_DIR_TX);
+		if (r < 0)
+			return r;
+		j += tx_size;
+	}
+
+	if (extra > 0) {
+		r = spi_xmit(spi_dev, (void *)addr + j, extra, SPI_DIR_TX);
+		if (r < 0)
+			return r;
+	}
+
+	return spi_xmit(spi_dev, padding, sizeof(padding), SPI_DIR_TX);
+}
+
+int s5c73m3_spi_read(struct s5c73m3 *state, void *addr,
+		     const unsigned int len, const unsigned int tx_size)
+{
+	struct spi_device *spi_dev = state->spi_dev;
+	u32 count = len / tx_size;
+	u32 extra = len % tx_size;
+	unsigned int i, j = 0;
+	int r = 0;
+
+	for (i = 0; i < count ; i++) {
+		r = spi_xmit(spi_dev, addr + j, tx_size, SPI_DIR_RX);
+		if (r < 0)
+			return r;
+		j += tx_size;
+	}
+
+	if (extra > 0)
+		return spi_xmit(spi_dev, addr + j, extra, SPI_DIR_RX);
+
+	return 0;
+}
+
+static int __devinit s5c73m3_spi_probe(struct spi_device *spi)
+{
+	int r;
+	struct s5c73m3 *state = container_of(spi->dev.driver, struct s5c73m3,
+					     spidrv.driver);
+	spi->bits_per_word = 32;
+
+	r = spi_setup(spi);
+	if (r < 0) {
+		dev_err(&spi->dev, "spi_setup() failed\n");
+		return r;
+	}
+
+	mutex_lock(&state->lock);
+	state->spi_dev = spi;
+	mutex_unlock(&state->lock);
+
+	v4l2_info(&state->sensor_sd, "S5C73M3 SPI probed successfully\n");
+	return 0;
+}
+
+static int __devexit s5c73m3_spi_remove(struct spi_device *spi)
+{
+	return 0;
+}
+
+int s5c73m3_register_spi_driver(struct s5c73m3 *state)
+{
+	struct spi_driver *spidrv = &state->spidrv;
+
+	spidrv->remove = __devexit_p(s5c73m3_spi_remove);
+	spidrv->probe = s5c73m3_spi_probe;
+	spidrv->driver.name = S5C73M3_SPI_DRV_NAME;
+	spidrv->driver.bus = &spi_bus_type;
+	spidrv->driver.owner = THIS_MODULE;
+
+	return spi_register_driver(spidrv);
+}
+
+void s5c73m3_unregister_spi_driver(struct s5c73m3 *state)
+{
+	spi_unregister_driver(&state->spidrv);
+}
diff --git a/drivers/media/i2c/s5c73m3/s5c73m3.h b/drivers/media/i2c/s5c73m3/s5c73m3.h
new file mode 100644
index 0000000..fe0bf95
--- /dev/null
+++ b/drivers/media/i2c/s5c73m3/s5c73m3.h
@@ -0,0 +1,459 @@
+/*
+ * Samsung LSI S5C73M3 8M pixel camera driver
+ *
+ * Copyright (C) 2012, Samsung Electronics, Co., Ltd.
+ * Sylwester Nawrocki <s.nawrocki@samsung.com>
+ * Andrzej Hajda <a.hajda@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#ifndef S5C73M3_H_
+#define S5C73M3_H_
+
+#include <linux/kernel.h>
+#include <linux/regulator/consumer.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-subdev.h>
+#include <media/s5c73m3.h>
+
+#define DRIVER_NAME			"S5C73M3"
+
+#define S5C73M3_ISP_FMT			V4L2_MBUS_FMT_VYUY8_2X8
+#define S5C73M3_JPEG_FMT		V4L2_MBUS_FMT_S5C_UYVY_JPEG_1X8
+
+/* Subdevs pad index definitions */
+enum s5c73m3_pads {
+	S5C73M3_ISP_PAD,
+	S5C73M3_JPEG_PAD,
+	S5C73M3_NUM_PADS
+};
+
+enum s5c73m3_oif_pads {
+	OIF_ISP_PAD,
+	OIF_JPEG_PAD,
+	OIF_SOURCE_PAD,
+	OIF_NUM_PADS
+};
+
+#define S5C73M3_SENSOR_FW_LEN		6
+#define S5C73M3_SENSOR_TYPE_LEN		12
+
+#define S5C73M3_REG(_addrh, _addrl) (((_addrh) << 16) | _addrl)
+
+#define AHB_MSB_ADDR_PTR			0xfcfc
+#define REG_CMDWR_ADDRH				0x0050
+#define REG_CMDWR_ADDRL				0x0054
+#define REG_CMDRD_ADDRH				0x0058
+#define REG_CMDRD_ADDRL				0x005c
+#define REG_CMDBUF_ADDR				0x0f14
+
+#define REG_I2C_SEQ_STATUS			S5C73M3_REG(0x0009, 0x59A6)
+#define  SEQ_END_PLL				(1<<0x0)
+#define  SEQ_END_SENSOR				(1<<0x1)
+#define  SEQ_END_GPIO				(1<<0x2)
+#define  SEQ_END_FROM				(1<<0x3)
+#define  SEQ_END_STABLE_AE_AWB			(1<<0x4)
+#define  SEQ_END_READY_I2C_CMD			(1<<0x5)
+
+#define REG_I2C_STATUS				S5C73M3_REG(0x0009, 0x599E)
+#define  I2C_STATUS_CIS_I2C			(1<<0x0)
+#define  I2C_STATUS_AF_INIT			(1<<0x1)
+#define  I2C_STATUS_CAL_DATA			(1<<0x2)
+#define  I2C_STATUS_FRAME_COUNT			(1<<0x3)
+#define  I2C_STATUS_FROM_INIT			(1<<0x4)
+#define  I2C_STATUS_I2C_CIS_STREAM_OFF		(1<<0x5)
+#define  I2C_STATUS_I2C_N_CMD_OVER		(1<<0x6)
+#define  I2C_STATUS_I2C_N_CMD_MISMATCH		(1<<0x7)
+#define  I2C_STATUS_CHECK_BIN_CRC		(1<<0x8)
+#define  I2C_STATUS_EXCEPTION			(1<<0x9)
+#define  I2C_STATUS_INIF_INIT_STATE		(0x8)
+
+#define REG_STATUS				S5C73M3_REG(0x0009, 0x5080)
+#define  REG_STATUS_BOOT_SUB_MAIN_ENTER		0xff01
+#define  REG_STATUS_BOOT_SRAM_TIMING_OK		0xff02
+#define  REG_STATUS_BOOT_INTERRUPTS_EN		0xff03
+#define  REG_STATUS_BOOT_R_PLL_DONE		0xff04
+#define  REG_STATUS_BOOT_R_PLL_LOCKTIME_DONE	0xff05
+#define  REG_STATUS_BOOT_DELAY_COUNT_DONE	0xff06
+#define  REG_STATUS_BOOT_I_PLL_DONE		0xff07
+#define  REG_STATUS_BOOT_I_PLL_LOCKTIME_DONE	0xff08
+#define  REG_STATUS_BOOT_PLL_INIT_OK		0xff09
+#define  REG_STATUS_BOOT_SENSOR_INIT_OK		0xff0a
+#define  REG_STATUS_BOOT_GPIO_SETTING_OK	0xff0b
+#define  REG_STATUS_BOOT_READ_CAL_DATA_OK	0xff0c
+#define  REG_STATUS_BOOT_STABLE_AE_AWB_OK	0xff0d
+#define  REG_STATUS_ISP_COMMAND_COMPLETED	0xffff
+#define  REG_STATUS_EXCEPTION_OCCURED		0xdead
+
+#define COMM_RESULT_OFFSET			S5C73M3_REG(0x0009, 0x5000)
+
+#define COMM_IMG_OUTPUT				0x0902
+#define  COMM_IMG_OUTPUT_HDR			0x0008
+#define  COMM_IMG_OUTPUT_YUV			0x0009
+#define  COMM_IMG_OUTPUT_INTERLEAVED		0x000d
+
+#define COMM_STILL_PRE_FLASH			0x0a00
+#define  COMM_STILL_PRE_FLASH_FIRE		0x0000
+#define  COMM_STILL_PRE_FLASH_NON_FIRED		0x0000
+#define  COMM_STILL_PRE_FLASH_FIRED		0x0001
+
+#define COMM_STILL_MAIN_FLASH			0x0a02
+#define  COMM_STILL_MAIN_FLASH_CANCEL		0x0001
+#define  COMM_STILL_MAIN_FLASH_FIRE		0x0002
+
+#define COMM_ZOOM_STEP				0x0b00
+
+#define COMM_IMAGE_EFFECT			0x0b0a
+#define  COMM_IMAGE_EFFECT_NONE			0x0001
+#define  COMM_IMAGE_EFFECT_NEGATIVE		0x0002
+#define  COMM_IMAGE_EFFECT_AQUA			0x0003
+#define  COMM_IMAGE_EFFECT_SEPIA		0x0004
+#define  COMM_IMAGE_EFFECT_MONO			0x0005
+
+#define COMM_IMAGE_QUALITY			0x0b0c
+#define  COMM_IMAGE_QUALITY_SUPERFINE		0x0000
+#define  COMM_IMAGE_QUALITY_FINE		0x0001
+#define  COMM_IMAGE_QUALITY_NORMAL		0x0002
+
+#define COMM_FLASH_MODE				0x0b0e
+#define  COMM_FLASH_MODE_OFF			0x0000
+#define  COMM_FLASH_MODE_ON			0x0001
+#define  COMM_FLASH_MODE_AUTO			0x0002
+
+#define COMM_FLASH_STATUS			0x0b80
+#define  COMM_FLASH_STATUS_OFF			0x0001
+#define  COMM_FLASH_STATUS_ON			0x0002
+#define  COMM_FLASH_STATUS_AUTO			0x0003
+
+#define COMM_FLASH_TORCH			0x0b12
+#define  COMM_FLASH_TORCH_OFF			0x0000
+#define  COMM_FLASH_TORCH_ON			0x0001
+
+#define COMM_AE_NEEDS_FLASH			0x0cba
+#define  COMM_AE_NEEDS_FLASH_OFF		0x0000
+#define  COMM_AE_NEEDS_FLASH_ON			0x0001
+
+#define COMM_CHG_MODE				0x0b10
+#define  COMM_CHG_MODE_NEW			0x8000
+#define  COMM_CHG_MODE_SUBSAMPLING_HALF		0x2000
+#define  COMM_CHG_MODE_SUBSAMPLING_QUARTER	0x4000
+
+#define  COMM_CHG_MODE_YUV_320_240		0x0001
+#define  COMM_CHG_MODE_YUV_640_480		0x0002
+#define  COMM_CHG_MODE_YUV_880_720		0x0003
+#define  COMM_CHG_MODE_YUV_960_720		0x0004
+#define  COMM_CHG_MODE_YUV_1184_666		0x0005
+#define  COMM_CHG_MODE_YUV_1280_720		0x0006
+#define  COMM_CHG_MODE_YUV_1536_864		0x0007
+#define  COMM_CHG_MODE_YUV_1600_1200		0x0008
+#define  COMM_CHG_MODE_YUV_1632_1224		0x0009
+#define  COMM_CHG_MODE_YUV_1920_1080		0x000a
+#define  COMM_CHG_MODE_YUV_1920_1440		0x000b
+#define  COMM_CHG_MODE_YUV_2304_1296		0x000c
+#define  COMM_CHG_MODE_YUV_3264_2448		0x000d
+#define  COMM_CHG_MODE_YUV_352_288		0x000e
+#define  COMM_CHG_MODE_YUV_1008_672		0x000f
+
+#define  COMM_CHG_MODE_JPEG_640_480		0x0010
+#define  COMM_CHG_MODE_JPEG_800_450		0x0020
+#define  COMM_CHG_MODE_JPEG_800_600		0x0030
+#define  COMM_CHG_MODE_JPEG_1280_720		0x0040
+#define  COMM_CHG_MODE_JPEG_1280_960		0x0050
+#define  COMM_CHG_MODE_JPEG_1600_900		0x0060
+#define  COMM_CHG_MODE_JPEG_1600_1200		0x0070
+#define  COMM_CHG_MODE_JPEG_2048_1152		0x0080
+#define  COMM_CHG_MODE_JPEG_2048_1536		0x0090
+#define  COMM_CHG_MODE_JPEG_2560_1440		0x00a0
+#define  COMM_CHG_MODE_JPEG_2560_1920		0x00b0
+#define  COMM_CHG_MODE_JPEG_3264_2176		0x00c0
+#define  COMM_CHG_MODE_JPEG_1024_768		0x00d0
+#define  COMM_CHG_MODE_JPEG_3264_1836		0x00e0
+#define  COMM_CHG_MODE_JPEG_3264_2448		0x00f0
+
+#define COMM_AF_CON				0x0e00
+#define  COMM_AF_CON_STOP			0x0000
+#define  COMM_AF_CON_SCAN			0x0001 /* Full Search */
+#define  COMM_AF_CON_START			0x0002 /* Fast Search */
+
+#define COMM_AF_CAL				0x0e06
+#define COMM_AF_TOUCH_AF			0x0e0a
+
+#define REG_AF_STATUS				S5C73M3_REG(0x0009, 0x5e80)
+#define  REG_CAF_STATUS_FIND_SEARCH_DIR		0x0001
+#define  REG_CAF_STATUS_FOCUSING		0x0002
+#define  REG_CAF_STATUS_FOCUSED			0x0003
+#define  REG_CAF_STATUS_UNFOCUSED		0x0004
+#define  REG_AF_STATUS_INVALID			0x0010
+#define  REG_AF_STATUS_FOCUSING			0x0020
+#define  REG_AF_STATUS_FOCUSED			0x0030
+#define  REG_AF_STATUS_UNFOCUSED		0x0040
+
+#define REG_AF_TOUCH_POSITION			S5C73M3_REG(0x0009, 0x5e8e)
+#define COMM_AF_FACE_ZOOM			0x0e10
+
+#define COMM_AF_MODE				0x0e02
+#define  COMM_AF_MODE_NORMAL			0x0000
+#define  COMM_AF_MODE_MACRO			0x0001
+#define  COMM_AF_MODE_MOVIE_CAF_START		0x0002
+#define  COMM_AF_MODE_MOVIE_CAF_STOP		0x0003
+#define  COMM_AF_MODE_PREVIEW_CAF_START		0x0004
+#define  COMM_AF_MODE_PREVIEW_CAF_STOP		0x0005
+
+#define COMM_AF_SOFTLANDING			0x0e16
+#define  COMM_AF_SOFTLANDING_ON			0x0000
+#define  COMM_AF_SOFTLANDING_RES_COMPLETE	0x0001
+
+#define COMM_FACE_DET				0x0e0c
+#define  COMM_FACE_DET_OFF			0x0000
+#define  COMM_FACE_DET_ON			0x0001
+
+#define COMM_FACE_DET_OSD			0x0e0e
+#define  COMM_FACE_DET_OSD_OFF			0x0000
+#define  COMM_FACE_DET_OSD_ON			0x0001
+
+#define COMM_AE_CON				0x0c00
+#define  COMM_AE_STOP				0x0000 /* lock */
+#define  COMM_AE_START				0x0001 /* unlock */
+
+#define COMM_ISO				0x0c02
+#define  COMM_ISO_AUTO				0x0000
+#define  COMM_ISO_100				0x0001
+#define  COMM_ISO_200				0x0002
+#define  COMM_ISO_400				0x0003
+#define  COMM_ISO_800				0x0004
+#define  COMM_ISO_SPORTS			0x0005
+#define  COMM_ISO_NIGHT				0x0006
+#define  COMM_ISO_INDOOR			0x0007
+
+/* 0x00000 (-2.0 EV)...0x0008 (2.0 EV), 0.5EV step */
+#define COMM_EV					0x0c04
+
+#define COMM_METERING				0x0c06
+#define  COMM_METERING_CENTER			0x0000
+#define  COMM_METERING_SPOT			0x0001
+#define  COMM_METERING_AVERAGE			0x0002
+#define  COMM_METERING_SMART			0x0003
+
+#define COMM_WDR				0x0c08
+#define  COMM_WDR_OFF				0x0000
+#define  COMM_WDR_ON				0x0001
+
+#define COMM_FLICKER_MODE			0x0c12
+#define  COMM_FLICKER_NONE			0x0000
+#define  COMM_FLICKER_MANUAL_50HZ		0x0001
+#define  COMM_FLICKER_MANUAL_60HZ		0x0002
+#define  COMM_FLICKER_AUTO			0x0003
+#define  COMM_FLICKER_AUTO_50HZ			0x0004
+#define  COMM_FLICKER_AUTO_60HZ			0x0005
+
+#define COMM_FRAME_RATE				0x0c1e
+#define  COMM_FRAME_RATE_AUTO_SET		0x0000
+#define  COMM_FRAME_RATE_FIXED_30FPS		0x0002
+#define  COMM_FRAME_RATE_FIXED_20FPS		0x0003
+#define  COMM_FRAME_RATE_FIXED_15FPS		0x0004
+#define  COMM_FRAME_RATE_FIXED_60FPS		0x0007
+#define  COMM_FRAME_RATE_FIXED_120FPS		0x0008
+#define  COMM_FRAME_RATE_FIXED_7FPS		0x0009
+#define  COMM_FRAME_RATE_FIXED_10FPS		0x000a
+#define  COMM_FRAME_RATE_FIXED_90FPS		0x000b
+#define  COMM_FRAME_RATE_ANTI_SHAKE		0x0013
+
+/* 0x0000...0x0004 -> sharpness: 0, 1, 2, -1, -2 */
+#define COMM_SHARPNESS				0x0c14
+
+/* 0x0000...0x0004 -> saturation: 0, 1, 2, -1, -2 */
+#define COMM_SATURATION				0x0c16
+
+/* 0x0000...0x0004 -> contrast: 0, 1, 2, -1, -2 */
+#define COMM_CONTRAST				0x0c18
+
+#define COMM_SCENE_MODE				0x0c1a
+#define  COMM_SCENE_MODE_NONE			0x0000
+#define  COMM_SCENE_MODE_PORTRAIT		0x0001
+#define  COMM_SCENE_MODE_LANDSCAPE		0x0002
+#define  COMM_SCENE_MODE_SPORTS			0x0003
+#define  COMM_SCENE_MODE_INDOOR			0x0004
+#define  COMM_SCENE_MODE_BEACH			0x0005
+#define  COMM_SCENE_MODE_SUNSET			0x0006
+#define  COMM_SCENE_MODE_DAWN			0x0007
+#define  COMM_SCENE_MODE_FALL			0x0008
+#define  COMM_SCENE_MODE_NIGHT			0x0009
+#define  COMM_SCENE_MODE_AGAINST_LIGHT		0x000a
+#define  COMM_SCENE_MODE_FIRE			0x000b
+#define  COMM_SCENE_MODE_TEXT			0x000c
+#define  COMM_SCENE_MODE_CANDLE			0x000d
+
+#define COMM_AE_AUTO_BRACKET			0x0b14
+#define  COMM_AE_AUTO_BRAKET_EV05		0x0080
+#define  COMM_AE_AUTO_BRAKET_EV10		0x0100
+#define  COMM_AE_AUTO_BRAKET_EV15		0x0180
+#define  COMM_AE_AUTO_BRAKET_EV20		0x0200
+
+#define COMM_SENSOR_STREAMING			0x090a
+#define  COMM_SENSOR_STREAMING_OFF		0x0000
+#define  COMM_SENSOR_STREAMING_ON		0x0001
+
+#define COMM_AWB_MODE				0x0d02
+#define  COMM_AWB_MODE_INCANDESCENT		0x0000
+#define  COMM_AWB_MODE_FLUORESCENT1		0x0001
+#define  COMM_AWB_MODE_FLUORESCENT2		0x0002
+#define  COMM_AWB_MODE_DAYLIGHT			0x0003
+#define  COMM_AWB_MODE_CLOUDY			0x0004
+#define  COMM_AWB_MODE_AUTO			0x0005
+
+#define COMM_AWB_CON				0x0d00
+#define  COMM_AWB_STOP				0x0000 /* lock */
+#define  COMM_AWB_START				0x0001 /* unlock */
+
+#define COMM_FW_UPDATE				0x0906
+#define  COMM_FW_UPDATE_NOT_READY		0x0000
+#define  COMM_FW_UPDATE_SUCCESS			0x0005
+#define  COMM_FW_UPDATE_FAIL			0x0007
+#define  COMM_FW_UPDATE_BUSY			0xffff
+
+
+#define S5C73M3_MAX_SUPPLIES			6
+
+struct s5c73m3_ctrls {
+	struct v4l2_ctrl_handler handler;
+	struct {
+		/* exposure/exposure bias cluster */
+		struct v4l2_ctrl *auto_exposure;
+		struct v4l2_ctrl *exposure_bias;
+		struct v4l2_ctrl *exposure_metering;
+	};
+	struct {
+		/* iso/auto iso cluster */
+		struct v4l2_ctrl *auto_iso;
+		struct v4l2_ctrl *iso;
+	};
+	struct v4l2_ctrl *auto_wb;
+	struct {
+		/* continuous auto focus/auto focus cluster */
+		struct v4l2_ctrl *focus_auto;
+		struct v4l2_ctrl *af_start;
+		struct v4l2_ctrl *af_stop;
+		struct v4l2_ctrl *af_status;
+		struct v4l2_ctrl *af_distance;
+	};
+
+	struct v4l2_ctrl *aaa_lock;
+	struct v4l2_ctrl *colorfx;
+	struct v4l2_ctrl *contrast;
+	struct v4l2_ctrl *saturation;
+	struct v4l2_ctrl *sharpness;
+	struct v4l2_ctrl *zoom;
+	struct v4l2_ctrl *wdr;
+	struct v4l2_ctrl *stabilization;
+	struct v4l2_ctrl *jpeg_quality;
+	struct v4l2_ctrl *scene_mode;
+};
+
+enum s5c73m3_gpio_id {
+	STBY,
+	RST,
+	GPIO_NUM,
+};
+
+enum s5c73m3_resolution_types {
+	RES_ISP,
+	RES_JPEG,
+};
+
+struct s5c73m3_interval {
+	u16 fps_reg;
+	struct v4l2_fract interval;
+	/* Maximum rectangle for the interval */
+	struct v4l2_frmsize_discrete size;
+};
+
+struct s5c73m3 {
+	struct v4l2_subdev sensor_sd;
+	struct media_pad sensor_pads[S5C73M3_NUM_PADS];
+
+	struct v4l2_subdev oif_sd;
+	struct media_pad oif_pads[OIF_NUM_PADS];
+
+	struct spi_driver spidrv;
+	struct spi_device *spi_dev;
+	struct i2c_client *i2c_client;
+	u32 i2c_write_address;
+	u32 i2c_read_address;
+
+	struct regulator_bulk_data supplies[S5C73M3_MAX_SUPPLIES];
+	struct s5c73m3_gpio gpio[GPIO_NUM];
+
+	/* External master clock frequency */
+	unsigned long mclk_frequency;
+	/* Video bus type - MIPI-CSI2/paralell */
+	enum v4l2_mbus_type bus_type;
+
+	const struct s5c73m3_frame_size *sensor_pix_size[2];
+	const struct s5c73m3_frame_size *oif_pix_size[2];
+	enum v4l2_mbus_pixelcode mbus_code;
+
+	const struct s5c73m3_interval *fiv;
+
+	struct v4l2_mbus_frame_desc frame_desc;
+	/* protects the struct members below */
+	struct mutex lock;
+
+	struct s5c73m3_ctrls ctrls;
+
+	u8 streaming:1;
+	u8 apply_fmt:1;
+	u8 apply_fiv:1;
+	u8 isp_ready:1;
+
+	short power;
+
+	char sensor_fw[S5C73M3_SENSOR_FW_LEN + 2];
+	char sensor_type[S5C73M3_SENSOR_TYPE_LEN + 2];
+	char fw_file_version[2];
+	unsigned int fw_size;
+};
+
+struct s5c73m3_frame_size {
+	u32 width;
+	u32 height;
+	u8 reg_val;
+};
+
+extern int s5c73m3_dbg;
+
+int s5c73m3_register_spi_driver(struct s5c73m3 *state);
+void s5c73m3_unregister_spi_driver(struct s5c73m3 *state);
+int s5c73m3_spi_write(struct s5c73m3 *state, const void *addr,
+		      const unsigned int len, const unsigned int tx_size);
+int s5c73m3_spi_read(struct s5c73m3 *state, void *addr,
+		      const unsigned int len, const unsigned int tx_size);
+
+int s5c73m3_read(struct s5c73m3 *state, u32 addr, u16 *data);
+int s5c73m3_write(struct s5c73m3 *state, u32 addr, u16 data);
+int s5c73m3_isp_command(struct s5c73m3 *state, u16 command, u16 data);
+int s5c73m3_init_controls(struct s5c73m3 *state);
+
+static inline struct v4l2_subdev *ctrl_to_sensor_sd(struct v4l2_ctrl *ctrl)
+{
+	return &container_of(ctrl->handler, struct s5c73m3,
+			     ctrls.handler)->sensor_sd;
+}
+
+static inline struct s5c73m3 *sensor_sd_to_s5c73m3(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct s5c73m3, sensor_sd);
+}
+
+static inline struct s5c73m3 *oif_sd_to_s5c73m3(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct s5c73m3, oif_sd);
+}
+#endif	/* S5C73M3_H_ */
diff --git a/include/media/s5c73m3.h b/include/media/s5c73m3.h
new file mode 100644
index 0000000..ccb9e54
--- /dev/null
+++ b/include/media/s5c73m3.h
@@ -0,0 +1,55 @@
+/*
+ * Samsung LSI S5C73M3 8M pixel camera driver
+ *
+ * Copyright (C) 2012, Samsung Electronics, Co., Ltd.
+ * Sylwester Nawrocki <s.nawrocki@samsung.com>
+ * Andrzej Hajda <a.hajda@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#ifndef MEDIA_S5C73M3__
+#define MEDIA_S5C73M3__
+
+#include <linux/videodev2.h>
+#include <media/v4l2-mediabus.h>
+
+/**
+ * struct s5c73m3_gpio - data structure describing a GPIO
+ * @gpio:  GPIO number
+ * @level: indicates active state of the @gpio
+ */
+struct s5c73m3_gpio {
+	int gpio;
+	int level;
+};
+
+/**
+ * struct s5c73m3_platform_data - s5c73m3 driver platform data
+ * @mclk_frequency: sensor's master clock frequency in Hz
+ * @gpio_reset:  GPIO driving RESET pin
+ * @gpio_stby:   GPIO driving STBY pin
+ * @nlanes:      maximum number of MIPI-CSI lanes used
+ * @horiz_flip:  default horizontal image flip value, non zero to enable
+ * @vert_flip:   default vertical image flip value, non zero to enable
+ */
+
+struct s5c73m3_platform_data {
+	unsigned long mclk_frequency;
+
+	struct s5c73m3_gpio gpio_reset;
+	struct s5c73m3_gpio gpio_stby;
+
+	enum v4l2_mbus_type bus_type;
+	u8 nlanes;
+	u8 horiz_flip;
+	u8 vert_flip;
+};
+
+#endif /* MEDIA_S5C73M3__ */
-- 
1.7.10.4

