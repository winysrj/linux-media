Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36680 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751489AbcEANl5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 1 May 2016 09:41:57 -0400
Date: Sun, 1 May 2016 16:41:22 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: sre@kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
	linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 03/24] et8ek8: Toshiba 5MP sensor driver
Message-ID: <20160501134122.GG26360@valkosipuli.retiisi.org.uk>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <1461532104-24032-4-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20160501104428.GC26360@valkosipuli.retiisi.org.uk>
 <5725FBA7.90602@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5725FBA7.90602@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ivaylo,

On Sun, May 01, 2016 at 03:50:47PM +0300, Ivaylo Dimitrov wrote:
> Hi,
> 
> On  1.05.2016 13:44, Sakari Ailus wrote:
> >Hi Ivaylo,
> >
> >On Mon, Apr 25, 2016 at 12:08:03AM +0300, Ivaylo Dimitrov wrote:
> >>add driver
> >>
> >>Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> >>---
> >>  drivers/media/i2c/smia/Kconfig  |    8 +
> >>  drivers/media/i2c/smia/Makefile |    1 +
> >>  drivers/media/i2c/smia/et8ek8.c | 1788 +++++++++++++++++++++++++++++++++++++++
> >>  3 files changed, 1797 insertions(+)
> >>  create mode 100644 drivers/media/i2c/smia/et8ek8.c
> >>
> >>diff --git a/drivers/media/i2c/smia/Kconfig b/drivers/media/i2c/smia/Kconfig
> >>index d9be497..13ca043 100644
> >>--- a/drivers/media/i2c/smia/Kconfig
> >>+++ b/drivers/media/i2c/smia/Kconfig
> >>@@ -7,3 +7,11 @@ config VIDEO_SMIAREGS
> >>
> >>  	  Also a few helper functions are provided to work with binary
> >>  	  register lists.
> >>+
> >>+config VIDEO_ET8EK8
> >>+	tristate "ET8EK8 camera sensor support"
> >>+	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
> >>+	select VIDEO_SMIAREGS
> >>+	---help---
> >>+	  This is a driver for the Toshiba ET8EK8 5 MP camera sensor.
> >>+	  It is used for example in Nokia N900 (RX-51).
> >>diff --git a/drivers/media/i2c/smia/Makefile b/drivers/media/i2c/smia/Makefile
> >>index cff67bc..56cf15e 100644
> >>--- a/drivers/media/i2c/smia/Makefile
> >>+++ b/drivers/media/i2c/smia/Makefile
> >>@@ -1 +1,2 @@
> >>  obj-$(CONFIG_VIDEO_SMIAREGS)  += smiaregs.o
> >>+obj-$(CONFIG_VIDEO_ET8EK8)    += et8ek8.o
> >>diff --git a/drivers/media/i2c/smia/et8ek8.c b/drivers/media/i2c/smia/et8ek8.c
> >>new file mode 100644
> >>index 0000000..46c112d
> >>--- /dev/null
> >>+++ b/drivers/media/i2c/smia/et8ek8.c
> >>@@ -0,0 +1,1788 @@
> >>+/*
> >>+ * drivers/media/video/et8ek8.c
> >>+ *
> >>+ * Copyright (C) 2008 Nokia Corporation
> >>+ *
> >>+ * Contact: Sakari Ailus <sakari.ailus@nokia.com>
> >>+ *          Tuukka Toivonen <tuukka.o.toivonen@nokia.com>
> >>+ *
> >>+ * Based on code from Toni Leinonen <toni.leinonen@offcode.fi>.
> >>+ *
> >>+ * This driver is based on the Micron MT9T012 camera imager driver
> >>+ * (C) Texas Instruments.
> >>+ *
> >>+ * This program is free software; you can redistribute it and/or
> >>+ * modify it under the terms of the GNU General Public License
> >>+ * version 2 as published by the Free Software Foundation.
> >>+ *
> >>+ * This program is distributed in the hope that it will be useful, but
> >>+ * WITHOUT ANY WARRANTY; without even the implied warranty of
> >>+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> >>+ * General Public License for more details.
> >>+ *
> >>+ * You should have received a copy of the GNU General Public License
> >>+ * along with this program; if not, write to the Free Software
> >>+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
> >>+ * 02110-1301 USA
> >>+ *
> >>+ */
> >>+
> >>+#define DEBUG
> >>+
> >>+#include <linux/clk.h>
> >>+#include <linux/delay.h>
> >>+#include <linux/i2c.h>
> >>+#include <linux/kernel.h>
> >>+#include <linux/module.h>
> >>+#include <linux/mutex.h>
> >>+#include <linux/gpio/consumer.h>
> >>+#include <linux/regulator/consumer.h>
> >>+#include <linux/slab.h>
> >>+#include <linux/version.h>
> >>+#include <linux/v4l2-mediabus.h>
> >>+
> >>+#include <media/media-entity.h>
> >>+#include <media/smiaregs.h>
> >>+#include <media/v4l2-ctrls.h>
> >>+#include <media/v4l2-device.h>
> >>+#include <media/v4l2-subdev.h>
> >>+
> >>+#define ET8EK8_NAME		"et8ek8"
> >>+#define ET8EK8_XCLK_HZ		9600000
> >>+#define ET8EK8_PRIV_MEM_SIZE	128
> >>+
> >>+#define CTRL_GAIN		0
> >>+#define CTRL_EXPOSURE		1
> >>+#define CTRL_TEST_PATTERN	2
> >>+
> >>+#define CID_TO_CTRL(id)		((id)==V4L2_CID_GAIN ? CTRL_GAIN : \
> >>+				 (id)==V4L2_CID_EXPOSURE ? CTRL_EXPOSURE : \
> >>+				 (id)==V4L2_CID_TEST_PATTERN ? CTRL_TEST_PATTERN : \
> >>+				 -EINVAL)
> >>+
> >>+struct et8ek8_sensor {
> >>+	struct v4l2_subdev subdev;
> >>+	struct media_pad pad;
> >>+	struct v4l2_mbus_framefmt format;
> >>+	struct gpio_desc *reset;
> >>+	struct regulator *vana;
> >>+	struct clk *ext_clk;
> >>+
> >>+	u16 version;
> >>+
> >>+	struct v4l2_ctrl_handler ctrl_handler;
> >>+	struct v4l2_ctrl *exposure;
> >>+	struct v4l2_ctrl *pixel_rate;
> >>+	struct smia_reglist *current_reglist;
> >>+
> >>+	u8 priv_mem[ET8EK8_PRIV_MEM_SIZE];
> >>+
> >>+	struct mutex power_lock;
> >>+	int power_count;
> >>+};
> >>+
> >>+#define to_et8ek8_sensor(sd)	container_of(sd, struct et8ek8_sensor, subdev)
> >>+
> >>+enum et8ek8_versions {
> >>+	ET8EK8_REV_1 = 0x0001,
> >>+	ET8EK8_REV_2,
> >>+};
> >>+
> >>+/*
> >>+ * This table describes what should be written to the sensor register
> >>+ * for each gain value. The gain(index in the table) is in terms of
> >>+ * 0.1EV, i.e. 10 indexes in the table give 2 time more gain [0] in
> >>+ * the *analog gain, [1] in the digital gain
> >>+ *
> >>+ * Analog gain [dB] = 20*log10(regvalue/32); 0x20..0x100
> >>+ */
> >>+static struct et8ek8_gain {
> >>+	u16 analog;
> >>+	u16 digital;
> >>+} const et8ek8_gain_table[] = {
> >>+	{ 32,    0},  /* x1 */
> >>+	{ 34,    0},
> >>+	{ 37,    0},
> >>+	{ 39,    0},
> >>+	{ 42,    0},
> >>+	{ 45,    0},
> >>+	{ 49,    0},
> >>+	{ 52,    0},
> >>+	{ 56,    0},
> >>+	{ 60,    0},
> >>+	{ 64,    0},  /* x2 */
> >>+	{ 69,    0},
> >>+	{ 74,    0},
> >>+	{ 79,    0},
> >>+	{ 84,    0},
> >>+	{ 91,    0},
> >>+	{ 97,    0},
> >>+	{104,    0},
> >>+	{111,    0},
> >>+	{119,    0},
> >>+	{128,    0},  /* x4 */
> >>+	{137,    0},
> >>+	{147,    0},
> >>+	{158,    0},
> >>+	{169,    0},
> >>+	{181,    0},
> >>+	{194,    0},
> >>+	{208,    0},
> >>+	{223,    0},
> >>+	{239,    0},
> >>+	{256,    0},  /* x8 */
> >>+	{256,   73},
> >>+	{256,  152},
> >>+	{256,  236},
> >>+	{256,  327},
> >>+	{256,  424},
> >>+	{256,  528},
> >>+	{256,  639},
> >>+	{256,  758},
> >>+	{256,  886},
> >>+	{256, 1023},  /* x16 */
> >>+};
> >>+
> >>+/* Register definitions */
> >>+#define REG_REVISION_NUMBER_L	0x1200
> >>+#define REG_REVISION_NUMBER_H	0x1201
> >>+
> >>+#define PRIV_MEM_START_REG	0x0008
> >>+#define PRIV_MEM_WIN_SIZE	8
> >>+
> >>+#define ET8EK8_I2C_DELAY	3	/* msec delay b/w accesses */
> >>+
> >>+#define USE_CRC			1
> >>+
> >>+/*
> >>+ *
> >>+ * Stingray sensor mode settings for Scooby
> >>+ *
> >>+ *
> >>+ */
> >>+
> >
> >It'd be nice to get rid of the register lists, however considering where the
> >sensor is used it's unlikely going to find its way elsewhere, so the gain
> >might not be worth the effort.
> >
> >I'd still integrate the functionality in the smia register list library to
> >the driver. That sort of functionality ideally should not be needed at all
> >but sadly, the documentation of some sensors is too bad to write proper
> >drivers. :-(
> >
> >(SMIA is an ill-conceived name for this library btw., it's got nothing to do
> >with SMIA as such. I'd call it et8ek8_reglist for example. Perhaps the
> >library only would be a better choice.)

s/the/renaming the/

> >
> 
> ok.  I removed the custom controls found in smia_reglist library and it
> doesn't affect the functionality of the driver (at least I noticed no
> chagne), so maybe it is a good idea to remove the library and move the code
> to the driver. there are only a couple of functions remaining there after
> controls are removed.

Ack.

> 
> >>+/* Mode1_poweron_Mode2_16VGA_2592x1968_12.07fps */
> >>+static struct smia_reglist mode1_poweron_mode2_16vga_2592x1968_12_07fps = {	/* 1 */
> >>+/* (without the +1)
> >>+ * SPCK       = 80 MHz
> >>+ * CCP2       = 640 MHz
> >>+ * VCO        = 640 MHz
> >>+ * VCOUNT     = 84 (2016)
> >>+ * HCOUNT     = 137 (3288)
> >>+ * CKREF_DIV  = 2
> >>+ * CKVAR_DIV  = 200
> >>+ * VCO_DIV    = 0
> >>+ * SPCK_DIV   = 7
> >>+ * MRCK_DIV   = 7
> >>+ * LVDSCK_DIV = 0
> >>+ */
> >>+	.type = SMIA_REGLIST_POWERON,
> >>+	.mode = {
> >>+		.sensor_width = 2592,
> >>+		.sensor_height = 1968,
> >>+		.sensor_window_origin_x = 0,
> >>+		.sensor_window_origin_y = 0,
> >>+		.sensor_window_width = 2592,
> >>+		.sensor_window_height = 1968,
> >>+		.width = 3288,
> >>+		.height = 2016,
> >>+		.window_origin_x = 0,
> >>+		.window_origin_y = 0,
> >>+		.window_width = 2592,
> >>+		.window_height = 1968,
> >>+		.pixel_clock = 80000000,
> >>+		.ext_clock = 9600000,
> >>+		.timeperframe = {
> >>+			.numerator = 100,
> >>+			.denominator = 1207
> >>+		},
> >>+		.max_exp = 2012,
> >>+		/* .max_gain = 0, */
> >>+		.pixel_format = V4L2_PIX_FMT_SGRBG10,
> >>+		.sensitivity = 65536
> >>+	},
> >>+	.regs = {
> >>+		{ SMIA_REG_8BIT, 0x126C, 0xCC },	/* Need to set firstly */
> >>+		{ SMIA_REG_8BIT, 0x1269, 0x00 },	/* Strobe and Data of CCP2 delay are minimized. */
> >>+		{ SMIA_REG_8BIT, 0x1220, 0x89 },	/* Refined value of Min H_COUNT  */
> >>+		{ SMIA_REG_8BIT, 0x123A, 0x07 },	/* Frequency of SPCK setting (SPCK=MRCK) */
> >>+		{ SMIA_REG_8BIT, 0x1241, 0x94 },	/* Initial setting */
> >>+		{ SMIA_REG_8BIT, 0x1242, 0x02 },	/* Initial setting */
> >>+		{ SMIA_REG_8BIT, 0x124B, 0x00 },	/* Initial setting */
> >>+		{ SMIA_REG_8BIT, 0x1255, 0xFF },	/* Initial setting */
> >>+		{ SMIA_REG_8BIT, 0x1256, 0x9F },	/* Initial setting */
> >>+		{ SMIA_REG_8BIT, 0x1258, 0x00 },	/* Initial setting */
> >>+		{ SMIA_REG_8BIT, 0x125D, 0x88 },	/* From parallel out to serial out */
> >>+		{ SMIA_REG_8BIT, 0x125E, 0xC0 },	/* From w/ embeded data to w/o embeded data */
> >>+		{ SMIA_REG_8BIT, 0x1263, 0x98 },	/* Initial setting */
> >>+		{ SMIA_REG_8BIT, 0x1268, 0xC6 },	/* CCP2 out is from STOP to ACTIVE */
> >>+		{ SMIA_REG_8BIT, 0x1434, 0x00 },	/* Initial setting */
> >>+		{ SMIA_REG_8BIT, 0x1163, 0x44 },	/* Initial setting */
> >>+		{ SMIA_REG_8BIT, 0x1166, 0x29 },	/* Initial setting */
> >>+		{ SMIA_REG_8BIT, 0x1140, 0x02 },	/* Initial setting */
> >>+		{ SMIA_REG_8BIT, 0x1011, 0x24 },	/* Initial setting */
> >>+		{ SMIA_REG_8BIT, 0x1151, 0x80 },	/* Initial setting */
> >>+		{ SMIA_REG_8BIT, 0x1152, 0x23 },	/* Initial setting */
> >>+		{ SMIA_REG_8BIT, 0x1014, 0x05 },	/* Initial setting( for improvement2 of lower frequency noise ) */
> >>+		{ SMIA_REG_8BIT, 0x1033, 0x06 },
> >>+		{ SMIA_REG_8BIT, 0x1034, 0x79 },
> >>+		{ SMIA_REG_8BIT, 0x1423, 0x3F },
> >>+		{ SMIA_REG_8BIT, 0x1424, 0x3F },
> >>+		{ SMIA_REG_8BIT, 0x1426, 0x00 },
> >>+		{ SMIA_REG_8BIT, 0x1439, 0x00 },	/* Switch of Preset-White-balance (0d:disable / 1d:enable) */
> >>+		{ SMIA_REG_8BIT, 0x161F, 0x60 },	/* Switch of blemish correction (0d:disable / 1d:enable) */
> >>+		{ SMIA_REG_8BIT, 0x1634, 0x00 },	/* Switch of auto noise correction (0d:disable / 1d:enable) */
> >>+		{ SMIA_REG_8BIT, 0x1646, 0x00 },	/* Initial setting */
> >>+		{ SMIA_REG_8BIT, 0x1648, 0x00 },	/* Initial setting */
> >>+		{ SMIA_REG_8BIT, 0x113E, 0x01 },	/* Initial setting */
> >>+		{ SMIA_REG_8BIT, 0x113F, 0x22 },	/* Initial setting */
> >>+		{ SMIA_REG_8BIT, 0x1239, 0x64 },
> >>+		{ SMIA_REG_8BIT, 0x1238, 0x02 },
> >>+		{ SMIA_REG_8BIT, 0x123B, 0x70 },
> >>+		{ SMIA_REG_8BIT, 0x123A, 0x07 },
> >>+		{ SMIA_REG_8BIT, 0x121B, 0x64 },
> >>+		{ SMIA_REG_8BIT, 0x121D, 0x64 },
> >>+		{ SMIA_REG_8BIT, 0x1221, 0x00 },
> >>+		{ SMIA_REG_8BIT, 0x1220, 0x89 },
> >>+		{ SMIA_REG_8BIT, 0x1223, 0x00 },
> >>+		{ SMIA_REG_8BIT, 0x1222, 0x54 },
> >>+		{ SMIA_REG_8BIT, 0x125D, 0x88 },	/* CCP_LVDS_MODE/  */
> >>+		{ SMIA_REG_TERM, 0, 0}
> >>+	}
> >>+};
> >>+
> >>+/* Mode1_16VGA_2592x1968_13.12fps_DPCM10-8 */
> >>+static struct smia_reglist mode1_16vga_2592x1968_13_12fps_dpcm10_8 = {	/* 2 */
> >>+/* (without the +1)
> >>+ * SPCK       = 80 MHz
> >>+ * CCP2       = 560 MHz
> >>+ * VCO        = 560 MHz
> >>+ * VCOUNT     = 84 (2016)
> >>+ * HCOUNT     = 128 (3072)
> >>+ * CKREF_DIV  = 2
> >>+ * CKVAR_DIV  = 175
> >>+ * VCO_DIV    = 0
> >>+ * SPCK_DIV   = 6
> >>+ * MRCK_DIV   = 7
> >>+ * LVDSCK_DIV = 0
> >>+ */
> >>+	.type = SMIA_REGLIST_MODE,
> >>+	.mode = {
> >>+		.sensor_width = 2592,
> >>+		.sensor_height = 1968,
> >>+		.sensor_window_origin_x = 0,
> >>+		.sensor_window_origin_y = 0,
> >>+		.sensor_window_width = 2592,
> >>+		.sensor_window_height = 1968,
> >>+		.width = 3072,
> >>+		.height = 2016,
> >>+		.window_origin_x = 0,
> >>+		.window_origin_y = 0,
> >>+		.window_width = 2592,
> >>+		.window_height = 1968,
> >>+		.pixel_clock = 80000000,
> >>+		.ext_clock = 9600000,
> >>+		.timeperframe = {
> >>+			.numerator = 100,
> >>+			.denominator = 1292
> >>+		},
> >>+		.max_exp = 2012,
> >>+		/* .max_gain = 0, */
> >>+		.pixel_format = V4L2_PIX_FMT_SGRBG10DPCM8,
> >>+		.sensitivity = 65536
> >>+	},
> >>+	.regs = {
> >>+		{ SMIA_REG_8BIT, 0x1239, 0x57 },
> >>+		{ SMIA_REG_8BIT, 0x1238, 0x82 },
> >>+		{ SMIA_REG_8BIT, 0x123B, 0x70 },
> >>+		{ SMIA_REG_8BIT, 0x123A, 0x06 },
> >>+		{ SMIA_REG_8BIT, 0x121B, 0x64 },
> >>+		{ SMIA_REG_8BIT, 0x121D, 0x64 },
> >>+		{ SMIA_REG_8BIT, 0x1221, 0x00 },
> >>+		{ SMIA_REG_8BIT, 0x1220, 0x80 },	/* <-changed to v14 7E->80 */
> >>+		{ SMIA_REG_8BIT, 0x1223, 0x00 },
> >>+		{ SMIA_REG_8BIT, 0x1222, 0x54 },
> >>+		{ SMIA_REG_8BIT, 0x125D, 0x83 },	/* CCP_LVDS_MODE/  */
> >>+		{ SMIA_REG_TERM, 0, 0}
> >>+	}
> >>+};
> >>+
> >>+/* Mode3_4VGA_1296x984_29.99fps_DPCM10-8 */
> >>+static struct smia_reglist mode3_4vga_1296x984_29_99fps_dpcm10_8 = {	/* 3 */
> >>+/* (without the +1)
> >>+ * SPCK       = 96.5333333333333 MHz
> >>+ * CCP2       = 579.2 MHz
> >>+ * VCO        = 579.2 MHz
> >>+ * VCOUNT     = 84 (2016)
> >>+ * HCOUNT     = 133 (3192)
> >>+ * CKREF_DIV  = 2
> >>+ * CKVAR_DIV  = 181
> >>+ * VCO_DIV    = 0
> >>+ * SPCK_DIV   = 5
> >>+ * MRCK_DIV   = 7
> >>+ * LVDSCK_DIV = 0
> >>+ */
> >>+	.type = SMIA_REGLIST_MODE,
> >>+	.mode = {
> >>+		.sensor_width = 2592,
> >>+		.sensor_height = 1968,
> >>+		.sensor_window_origin_x = 0,
> >>+		.sensor_window_origin_y = 0,
> >>+		.sensor_window_width = 2592,
> >>+		.sensor_window_height = 1968,
> >>+		.width = 3192,
> >>+		.height = 1008,
> >>+		.window_origin_x = 0,
> >>+		.window_origin_y = 0,
> >>+		.window_width = 1296,
> >>+		.window_height = 984,
> >>+		.pixel_clock = 96533333,
> >>+		.ext_clock = 9600000,
> >>+		.timeperframe = {
> >>+			.numerator = 100,
> >>+			.denominator = 3000
> >>+		},
> >>+		.max_exp = 1004,
> >>+		/* .max_gain = 0, */
> >>+		.pixel_format = V4L2_PIX_FMT_SGRBG10DPCM8,
> >>+		.sensitivity = 65536
> >>+	},
> >>+	.regs = {
> >>+		{ SMIA_REG_8BIT, 0x1239, 0x5A },	/*        */
> >>+		{ SMIA_REG_8BIT, 0x1238, 0x82 },	/*        */
> >>+		{ SMIA_REG_8BIT, 0x123B, 0x70 },	/*        */
> >>+		{ SMIA_REG_8BIT, 0x123A, 0x05 },	/*        */
> >>+		{ SMIA_REG_8BIT, 0x121B, 0x63 },	/*        */
> >>+		{ SMIA_REG_8BIT, 0x1220, 0x85 },	/*        */
> >>+		{ SMIA_REG_8BIT, 0x1221, 0x00 },	/*        */
> >>+		{ SMIA_REG_8BIT, 0x1222, 0x54 },	/*        */
> >>+		{ SMIA_REG_8BIT, 0x1223, 0x00 },	/*        */
> >>+		{ SMIA_REG_8BIT, 0x121D, 0x63 },
> >>+		{ SMIA_REG_8BIT, 0x125D, 0x83 },	/* CCP_LVDS_MODE/  */
> >>+		{ SMIA_REG_TERM, 0, 0}
> >>+	}
> >>+};
> >>+
> >>+/* Mode4_SVGA_864x656_29.88fps */
> >>+static struct smia_reglist mode4_svga_864x656_29_88fps = {	/* 4 */
> >>+/* (without the +1)
> >>+ * SPCK       = 80 MHz
> >>+ * CCP2       = 320 MHz
> >>+ * VCO        = 640 MHz
> >>+ * VCOUNT     = 84 (2016)
> >>+ * HCOUNT     = 166 (3984)
> >>+ * CKREF_DIV  = 2
> >>+ * CKVAR_DIV  = 200
> >>+ * VCO_DIV    = 0
> >>+ * SPCK_DIV   = 7
> >>+ * MRCK_DIV   = 7
> >>+ * LVDSCK_DIV = 1
> >>+ */
> >>+	.type = SMIA_REGLIST_MODE,
> >>+	.mode = {
> >>+		.sensor_width = 2592,
> >>+		.sensor_height = 1968,
> >>+		.sensor_window_origin_x = 0,
> >>+		.sensor_window_origin_y = 0,
> >>+		.sensor_window_width = 2592,
> >>+		.sensor_window_height = 1968,
> >>+		.width = 3984,
> >>+		.height = 672,
> >>+		.window_origin_x = 0,
> >>+		.window_origin_y = 0,
> >>+		.window_width = 864,
> >>+		.window_height = 656,
> >>+		.pixel_clock = 80000000,
> >>+		.ext_clock = 9600000,
> >>+		.timeperframe = {
> >>+			.numerator = 100,
> >>+			.denominator = 2988
> >>+		},
> >>+		.max_exp = 668,
> >>+		/* .max_gain = 0, */
> >>+		.pixel_format = V4L2_PIX_FMT_SGRBG10,
> >>+		.sensitivity = 65536
> >>+	},
> >>+	.regs = {
> >>+		{ SMIA_REG_8BIT, 0x1239, 0x64 },
> >>+		{ SMIA_REG_8BIT, 0x1238, 0x02 },
> >>+		{ SMIA_REG_8BIT, 0x123B, 0x71 },
> >>+		{ SMIA_REG_8BIT, 0x123A, 0x07 },
> >>+		{ SMIA_REG_8BIT, 0x121B, 0x62 },
> >>+		{ SMIA_REG_8BIT, 0x121D, 0x62 },
> >>+		{ SMIA_REG_8BIT, 0x1221, 0x00 },
> >>+		{ SMIA_REG_8BIT, 0x1220, 0xA6 },
> >>+		{ SMIA_REG_8BIT, 0x1223, 0x00 },
> >>+		{ SMIA_REG_8BIT, 0x1222, 0x54 },
> >>+		{ SMIA_REG_8BIT, 0x125D, 0x88 },	/* CCP_LVDS_MODE/  */
> >>+		{ SMIA_REG_TERM, 0, 0}
> >>+	}
> >>+};
> >>+
> >>+/* Mode5_VGA_648x492_29.93fps */
> >>+static struct smia_reglist mode5_vga_648x492_29_93fps = {	/* 5 */
> >>+/* (without the +1)
> >>+ * SPCK       = 80 MHz
> >>+ * CCP2       = 320 MHz
> >>+ * VCO        = 640 MHz
> >>+ * VCOUNT     = 84 (2016)
> >>+ * HCOUNT     = 221 (5304)
> >>+ * CKREF_DIV  = 2
> >>+ * CKVAR_DIV  = 200
> >>+ * VCO_DIV    = 0
> >>+ * SPCK_DIV   = 7
> >>+ * MRCK_DIV   = 7
> >>+ * LVDSCK_DIV = 1
> >>+ */
> >>+	.type = SMIA_REGLIST_MODE,
> >>+	.mode = {
> >>+		.sensor_width = 2592,
> >>+		.sensor_height = 1968,
> >>+		.sensor_window_origin_x = 0,
> >>+		.sensor_window_origin_y = 0,
> >>+		.sensor_window_width = 2592,
> >>+		.sensor_window_height = 1968,
> >>+		.width = 5304,
> >>+		.height = 504,
> >>+		.window_origin_x = 0,
> >>+		.window_origin_y = 0,
> >>+		.window_width = 648,
> >>+		.window_height = 492,
> >>+		.pixel_clock = 80000000,
> >>+		.ext_clock = 9600000,
> >>+		.timeperframe = {
> >>+			.numerator = 100,
> >>+			.denominator = 2993
> >>+		},
> >>+		.max_exp = 500,
> >>+		/* .max_gain = 0, */
> >>+		.pixel_format = V4L2_PIX_FMT_SGRBG10,
> >>+		.sensitivity = 65536
> >>+	},
> >>+	.regs = {
> >>+		{ SMIA_REG_8BIT, 0x1239, 0x64 },
> >>+		{ SMIA_REG_8BIT, 0x1238, 0x02 },
> >>+		{ SMIA_REG_8BIT, 0x123B, 0x71 },
> >>+		{ SMIA_REG_8BIT, 0x123A, 0x07 },
> >>+		{ SMIA_REG_8BIT, 0x121B, 0x61 },
> >>+		{ SMIA_REG_8BIT, 0x121D, 0x61 },
> >>+		{ SMIA_REG_8BIT, 0x1221, 0x00 },
> >>+		{ SMIA_REG_8BIT, 0x1220, 0xDD },
> >>+		{ SMIA_REG_8BIT, 0x1223, 0x00 },
> >>+		{ SMIA_REG_8BIT, 0x1222, 0x54 },
> >>+		{ SMIA_REG_8BIT, 0x125D, 0x88 },	/* CCP_LVDS_MODE/  */
> >>+		{ SMIA_REG_TERM, 0, 0}
> >>+	}
> >>+};
> >>+
> >>+/* Mode2_16VGA_2592x1968_3.99fps */
> >>+static struct smia_reglist mode2_16vga_2592x1968_3_99fps = {	/* 6 */
> >>+/* (without the +1)
> >>+ * SPCK       = 80 MHz
> >>+ * CCP2       = 640 MHz
> >>+ * VCO        = 640 MHz
> >>+ * VCOUNT     = 254 (6096)
> >>+ * HCOUNT     = 137 (3288)
> >>+ * CKREF_DIV  = 2
> >>+ * CKVAR_DIV  = 200
> >>+ * VCO_DIV    = 0
> >>+ * SPCK_DIV   = 7
> >>+ * MRCK_DIV   = 7
> >>+ * LVDSCK_DIV = 0
> >>+ */
> >>+	.type = SMIA_REGLIST_MODE,
> >>+	.mode = {
> >>+		.sensor_width = 2592,
> >>+		.sensor_height = 1968,
> >>+		.sensor_window_origin_x = 0,
> >>+		.sensor_window_origin_y = 0,
> >>+		.sensor_window_width = 2592,
> >>+		.sensor_window_height = 1968,
> >>+		.width = 3288,
> >>+		.height = 6096,
> >>+		.window_origin_x = 0,
> >>+		.window_origin_y = 0,
> >>+		.window_width = 2592,
> >>+		.window_height = 1968,
> >>+		.pixel_clock = 80000000,
> >>+		.ext_clock = 9600000,
> >>+		.timeperframe = {
> >>+			.numerator = 100,
> >>+			.denominator = 399
> >>+		},
> >>+		.max_exp = 6092,
> >>+		/* .max_gain = 0, */
> >>+		.pixel_format = V4L2_PIX_FMT_SGRBG10,
> >>+		.sensitivity = 65536
> >>+	},
> >>+	.regs = {
> >>+		{ SMIA_REG_8BIT, 0x1239, 0x64 },
> >>+		{ SMIA_REG_8BIT, 0x1238, 0x02 },
> >>+		{ SMIA_REG_8BIT, 0x123B, 0x70 },
> >>+		{ SMIA_REG_8BIT, 0x123A, 0x07 },
> >>+		{ SMIA_REG_8BIT, 0x121B, 0x64 },
> >>+		{ SMIA_REG_8BIT, 0x121D, 0x64 },
> >>+		{ SMIA_REG_8BIT, 0x1221, 0x00 },
> >>+		{ SMIA_REG_8BIT, 0x1220, 0x89 },
> >>+		{ SMIA_REG_8BIT, 0x1223, 0x00 },
> >>+		{ SMIA_REG_8BIT, 0x1222, 0xFE },
> >>+		{ SMIA_REG_TERM, 0, 0}
> >>+	}
> >>+};
> >>+
> >>+/* Mode_648x492_5fps */
> >>+static struct smia_reglist mode_648x492_5fps = {	/* 7 */
> >>+/* (without the +1)
> >>+ * SPCK       = 13.3333333333333 MHz
> >>+ * CCP2       = 53.3333333333333 MHz
> >>+ * VCO        = 640 MHz
> >>+ * VCOUNT     = 84 (2016)
> >>+ * HCOUNT     = 221 (5304)
> >>+ * CKREF_DIV  = 2
> >>+ * CKVAR_DIV  = 200
> >>+ * VCO_DIV    = 5
> >>+ * SPCK_DIV   = 7
> >>+ * MRCK_DIV   = 7
> >>+ * LVDSCK_DIV = 1
> >>+ */
> >>+	.type = SMIA_REGLIST_MODE,
> >>+	.mode = {
> >>+		.sensor_width = 2592,
> >>+		.sensor_height = 1968,
> >>+		.sensor_window_origin_x = 0,
> >>+		.sensor_window_origin_y = 0,
> >>+		.sensor_window_width = 2592,
> >>+		.sensor_window_height = 1968,
> >>+		.width = 5304,
> >>+		.height = 504,
> >>+		.window_origin_x = 0,
> >>+		.window_origin_y = 0,
> >>+		.window_width = 648,
> >>+		.window_height = 492,
> >>+		.pixel_clock = 13333333,
> >>+		.ext_clock = 9600000,
> >>+		.timeperframe = {
> >>+			.numerator = 100,
> >>+			.denominator = 499
> >>+		},
> >>+		.max_exp = 500,
> >>+		/* .max_gain = 0, */
> >>+		.pixel_format = V4L2_PIX_FMT_SGRBG10,
> >>+		.sensitivity = 65536
> >>+	},
> >>+	.regs = {
> >>+		{ SMIA_REG_8BIT, 0x1239, 0x64 },
> >>+		{ SMIA_REG_8BIT, 0x1238, 0x02 },
> >>+		{ SMIA_REG_8BIT, 0x123B, 0x71 },
> >>+		{ SMIA_REG_8BIT, 0x123A, 0x57 },
> >>+		{ SMIA_REG_8BIT, 0x121B, 0x61 },
> >>+		{ SMIA_REG_8BIT, 0x121D, 0x61 },
> >>+		{ SMIA_REG_8BIT, 0x1221, 0x00 },
> >>+		{ SMIA_REG_8BIT, 0x1220, 0xDD },
> >>+		{ SMIA_REG_8BIT, 0x1223, 0x00 },
> >>+		{ SMIA_REG_8BIT, 0x1222, 0x54 },
> >>+		{ SMIA_REG_8BIT, 0x125D, 0x88 },	/* CCP_LVDS_MODE/  */
> >>+		{ SMIA_REG_TERM, 0, 0}
> >>+	}
> >>+};
> >>+
> >>+/* Mode3_4VGA_1296x984_5fps */
> >>+static struct smia_reglist mode3_4vga_1296x984_5fps = {	/* 8 */
> >>+/* (without the +1)
> >>+ * SPCK       = 49.4 MHz
> >>+ * CCP2       = 395.2 MHz
> >>+ * VCO        = 790.4 MHz
> >>+ * VCOUNT     = 250 (6000)
> >>+ * HCOUNT     = 137 (3288)
> >>+ * CKREF_DIV  = 2
> >>+ * CKVAR_DIV  = 247
> >>+ * VCO_DIV    = 1
> >>+ * SPCK_DIV   = 7
> >>+ * MRCK_DIV   = 7
> >>+ * LVDSCK_DIV = 0
> >>+ */
> >>+	.type = SMIA_REGLIST_MODE,
> >>+	.mode = {
> >>+		.sensor_width = 2592,
> >>+		.sensor_height = 1968,
> >>+		.sensor_window_origin_x = 0,
> >>+		.sensor_window_origin_y = 0,
> >>+		.sensor_window_width = 2592,
> >>+		.sensor_window_height = 1968,
> >>+		.width = 3288,
> >>+		.height = 3000,
> >>+		.window_origin_x = 0,
> >>+		.window_origin_y = 0,
> >>+		.window_width = 1296,
> >>+		.window_height = 984,
> >>+		.pixel_clock = 49400000,
> >>+		.ext_clock = 9600000,
> >>+		.timeperframe = {
> >>+			.numerator = 100,
> >>+			.denominator = 501
> >>+		},
> >>+		.max_exp = 2996,
> >>+		/* .max_gain = 0, */
> >>+		.pixel_format = V4L2_PIX_FMT_SGRBG10,
> >>+		.sensitivity = 65536
> >>+	},
> >>+	.regs = {
> >>+		{ SMIA_REG_8BIT, 0x1239, 0x7B },
> >>+		{ SMIA_REG_8BIT, 0x1238, 0x82 },
> >>+		{ SMIA_REG_8BIT, 0x123B, 0x70 },
> >>+		{ SMIA_REG_8BIT, 0x123A, 0x17 },
> >>+		{ SMIA_REG_8BIT, 0x121B, 0x63 },
> >>+		{ SMIA_REG_8BIT, 0x121D, 0x63 },
> >>+		{ SMIA_REG_8BIT, 0x1221, 0x00 },
> >>+		{ SMIA_REG_8BIT, 0x1220, 0x89 },
> >>+		{ SMIA_REG_8BIT, 0x1223, 0x00 },
> >>+		{ SMIA_REG_8BIT, 0x1222, 0xFA },
> >>+		{ SMIA_REG_8BIT, 0x125D, 0x88 },	/* CCP_LVDS_MODE/  */
> >>+		{ SMIA_REG_TERM, 0, 0}
> >>+	}
> >>+};
> >>+
> >>+/* Mode_4VGA_1296x984_25fps_DPCM10-8 */
> >>+static struct smia_reglist mode_4vga_1296x984_25fps_dpcm10_8 = {	/* 9 */
> >>+/* (without the +1)
> >>+ * SPCK       = 84.2666666666667 MHz
> >>+ * CCP2       = 505.6 MHz
> >>+ * VCO        = 505.6 MHz
> >>+ * VCOUNT     = 88 (2112)
> >>+ * HCOUNT     = 133 (3192)
> >>+ * CKREF_DIV  = 2
> >>+ * CKVAR_DIV  = 158
> >>+ * VCO_DIV    = 0
> >>+ * SPCK_DIV   = 5
> >>+ * MRCK_DIV   = 7
> >>+ * LVDSCK_DIV = 0
> >>+ */
> >>+	.type = SMIA_REGLIST_MODE,
> >>+	.mode = {
> >>+		.sensor_width = 2592,
> >>+		.sensor_height = 1968,
> >>+		.sensor_window_origin_x = 0,
> >>+		.sensor_window_origin_y = 0,
> >>+		.sensor_window_width = 2592,
> >>+		.sensor_window_height = 1968,
> >>+		.width = 3192,
> >>+		.height = 1056,
> >>+		.window_origin_x = 0,
> >>+		.window_origin_y = 0,
> >>+		.window_width = 1296,
> >>+		.window_height = 984,
> >>+		.pixel_clock = 84266667,
> >>+		.ext_clock = 9600000,
> >>+		.timeperframe = {
> >>+			.numerator = 100,
> >>+			.denominator = 2500
> >>+		},
> >>+		.max_exp = 1052,
> >>+		/* .max_gain = 0, */
> >>+		.pixel_format = V4L2_PIX_FMT_SGRBG10DPCM8,
> >>+		.sensitivity = 65536
> >>+	},
> >>+	.regs = {
> >>+		{ SMIA_REG_8BIT, 0x1239, 0x4F },	/*        */
> >>+		{ SMIA_REG_8BIT, 0x1238, 0x02 },	/*        */
> >>+		{ SMIA_REG_8BIT, 0x123B, 0x70 },	/*        */
> >>+		{ SMIA_REG_8BIT, 0x123A, 0x05 },	/*        */
> >>+		{ SMIA_REG_8BIT, 0x121B, 0x63 },	/*        */
> >>+		{ SMIA_REG_8BIT, 0x1220, 0x85 },	/*        */
> >>+		{ SMIA_REG_8BIT, 0x1221, 0x00 },	/*        */
> >>+		{ SMIA_REG_8BIT, 0x1222, 0x58 },	/*        */
> >>+		{ SMIA_REG_8BIT, 0x1223, 0x00 },	/*        */
> >>+		{ SMIA_REG_8BIT, 0x121D, 0x63 },	/*        */
> >>+		{ SMIA_REG_8BIT, 0x125D, 0x83 },	/*        */
> >>+		{ SMIA_REG_TERM, 0, 0}
> >>+	}
> >>+};
> >>+
> >>+static struct smia_meta_reglist et8ek8_smia_meta_reglist = {
> >>+	.magic   = SMIA_MAGIC,
> >>+	.version = "V14 03-June-2008",
> >>+	.reglist = {
> >>+		{ .ptr = &mode1_poweron_mode2_16vga_2592x1968_12_07fps },
> >>+		{ .ptr = &mode1_16vga_2592x1968_13_12fps_dpcm10_8 },
> >>+		{ .ptr = &mode3_4vga_1296x984_29_99fps_dpcm10_8 },
> >>+		{ .ptr = &mode4_svga_864x656_29_88fps },
> >>+		{ .ptr = &mode5_vga_648x492_29_93fps },
> >>+		{ .ptr = &mode2_16vga_2592x1968_3_99fps },
> >>+		{ .ptr = &mode_648x492_5fps },
> >>+		{ .ptr = &mode3_4vga_1296x984_5fps },
> >>+		{ .ptr = &mode_4vga_1296x984_25fps_dpcm10_8 },
> >>+		{ .ptr = 0 }
> >>+	}
> >>+};
> >>+
> >>+/*
> >>+ * Return time of one row in microseconds, .8 fixed point format.
> >>+ * If the sensor is not set to any mode, return zero.
> >>+ */
> >>+static int et8ek8_get_row_time(struct et8ek8_sensor *sensor)
> >>+{
> >>+	unsigned int clock;	/* Pixel clock in Hz>>10 fixed point */
> >>+	unsigned int rt;	/* Row time in .8 fixed point */
> >>+
> >>+	if (!sensor->current_reglist)
> >>+		return 0;
> >>+
> >>+	clock = sensor->current_reglist->mode.pixel_clock;
> >>+	clock = (clock + (1 << 9)) >> 10;
> >>+	rt = sensor->current_reglist->mode.width * (1000000 >> 2);
> >>+	rt = (rt + (clock >> 1)) / clock;
> >>+
> >>+	return rt;
> >>+}
> >>+
> >>+/*
> >>+ * Convert exposure time `us' to rows. Modify `us' to make it to
> >>+ * correspond to the actual exposure time.
> >>+ */
> >>+static int et8ek8_exposure_us_to_rows(struct et8ek8_sensor *sensor, u32 *us)
> >>+{
> >>+	unsigned int rows;	/* Exposure value as written to HW (ie. rows) */
> >>+	unsigned int rt;	/* Row time in .8 fixed point */
> >>+
> >>+	/* Assume that the maximum exposure time is at most ~8 s,
> >>+	 * and the maximum width (with blanking) ~8000 pixels.
> >>+	 * The formula here is in principle as simple as
> >>+	 *    rows = exptime / 1e6 / width * pixel_clock
> >>+	 * but to get accurate results while coping with value ranges,
> >>+	 * have to do some fixed point math.
> >>+	 */
> >>+
> >>+	rt = et8ek8_get_row_time(sensor);
> >>+	rows = ((*us << 8) + (rt >> 1)) / rt;
> >>+
> >>+	if (rows > sensor->current_reglist->mode.max_exp)
> >>+		rows = sensor->current_reglist->mode.max_exp;
> >>+
> >>+	/* Set the exposure time to the rounded value */
> >>+	*us = (rt * rows + (1 << 7)) >> 8;
> >>+
> >>+	return rows;
> >>+}
> >>+
> >>+/*
> >>+ * Convert exposure time in rows to microseconds
> >>+ */
> >>+static int et8ek8_exposure_rows_to_us(struct et8ek8_sensor *sensor, int rows)
> >>+{
> >>+	return (et8ek8_get_row_time(sensor) * rows + (1 << 7)) >> 8;
> >>+}
> >>+
> >>+/* Called to change the V4L2 gain control value. This function
> >>+ * rounds and clamps the given value and updates the V4L2 control value.
> >>+ * If power is on, also updates the sensor analog and digital gains.
> >>+ * gain is in 0.1 EV (exposure value) units.
> >>+ */
> >>+static int et8ek8_set_gain(struct et8ek8_sensor *sensor, s32 gain)
> >>+{
> >>+	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
> >>+	struct et8ek8_gain new;
> >>+	int r;
> >>+
> >>+	new = et8ek8_gain_table[gain];
> >>+
> >>+	/* FIXME: optimise I2C writes! */
> >>+	r = smia_i2c_write_reg(client, SMIA_REG_8BIT,
> >>+				0x124a, new.analog >> 8);
> >>+	if (r)
> >>+		return r;
> >>+	r = smia_i2c_write_reg(client, SMIA_REG_8BIT,
> >>+				0x1249, new.analog & 0xff);
> >>+	if (r)
> >>+		return r;
> >>+
> >>+	r = smia_i2c_write_reg(client, SMIA_REG_8BIT,
> >>+				0x124d, new.digital >> 8);
> >>+	if (r)
> >>+		return r;
> >>+	r = smia_i2c_write_reg(client, SMIA_REG_8BIT,
> >>+				0x124c, new.digital & 0xff);
> >>+
> >>+	return r;
> >>+}
> >>+
> >>+static int et8ek8_set_test_pattern(struct et8ek8_sensor *sensor, s32 mode)
> >>+{
> >>+	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
> >>+	int cbh_mode, cbv_mode, tp_mode, din_sw, r1420, rval;
> >>+
> >>+	/* Values for normal mode */
> >>+	cbh_mode = 0;
> >>+	cbv_mode = 0;
> >>+	tp_mode  = 0;
> >>+	din_sw   = 0x00;
> >>+	r1420    = 0xF0;
> >>+
> >>+	if (mode != 0) {
> >>+		/* Test pattern mode */
> >>+		if (mode < 5) {
> >>+			cbh_mode = 1;
> >>+			cbv_mode = 1;
> >>+			tp_mode  = mode + 3;
> >>+		} else {
> >>+			cbh_mode = 0;
> >>+			cbv_mode = 0;
> >>+			tp_mode  = mode - 4 + 3;
> >>+		}
> >>+		din_sw   = 0x01;
> >>+		r1420    = 0xE0;
> >>+	}
> >>+
> >>+	rval = smia_i2c_write_reg(client, SMIA_REG_8BIT, 0x111B, tp_mode << 4);
> >>+	if (rval)
> >>+		goto out;
> >>+
> >>+	rval = smia_i2c_write_reg(client, SMIA_REG_8BIT, 0x1121, cbh_mode << 7);
> >>+	if (rval)
> >>+		goto out;
> >>+
> >>+	rval = smia_i2c_write_reg(client, SMIA_REG_8BIT, 0x1124, cbv_mode << 7);
> >>+	if (rval)
> >>+		goto out;
> >>+
> >>+	rval = smia_i2c_write_reg(client, SMIA_REG_8BIT, 0x112C, din_sw);
> >>+	if (rval)
> >>+		goto out;
> >>+
> >>+	rval = smia_i2c_write_reg(client, SMIA_REG_8BIT, 0x1420, r1420);
> >>+	if (rval)
> >>+		goto out;
> >>+
> >>+out:
> >>+	return rval;
> >>+}
> >>+
> >>+/* -----------------------------------------------------------------------------
> >>+ * V4L2 controls
> >>+ */
> >>+
> >>+static int et8ek8_get_ctrl(struct v4l2_ctrl *ctrl)
> >>+{
> >>+	struct et8ek8_sensor *sensor =
> >>+		container_of(ctrl->handler, struct et8ek8_sensor, ctrl_handler);
> >>+	const struct smia_mode *mode = &sensor->current_reglist->mode;
> >>+
> >>+	switch (ctrl->id) {
> >>+	case V4L2_CID_MODE_FRAME_WIDTH:
> >>+		ctrl->cur.val = mode->width;
> >>+		break;
> >>+	case V4L2_CID_MODE_FRAME_HEIGHT:
> >>+		ctrl->cur.val = mode->height;
> >>+		break;
> >>+	case V4L2_CID_MODE_VISIBLE_WIDTH:
> >>+		ctrl->cur.val = mode->window_width;
> >>+		break;
> >>+	case V4L2_CID_MODE_VISIBLE_HEIGHT:
> >>+		ctrl->cur.val = mode->window_height;
> >>+		break;
> >>+	case V4L2_CID_MODE_PIXELCLOCK:
> >>+		ctrl->cur.val = mode->pixel_clock;
> >
> >Please use V4L2_CID_PIXEL_RATE instead. It's a 64-bit control.
> >
> 
> I already used it in set() operation, I think I is better to remove
> V4L2_CID_PIXEL_RATE and V4L2_CID_MODE_OPSYSCLOCK altogether as those are
> standart controls.
> 
> >>+		break;
> >>+	case V4L2_CID_MODE_SENSITIVITY:
> >>+		ctrl->cur.val = mode->sensitivity;
> >>+		break;
> >>+	case V4L2_CID_MODE_OPSYSCLOCK:
> >>+		ctrl->cur.val = mode->opsys_clock;
> >>+		break;
> >
> >V4L2_CID_LINK_FREQ.
> >

Ack.

> 
> see ^^^
> 
> >>+	}
> >>+
> >>+	return 0;
> >>+}
> >>+
> >>+static int et8ek8_set_ctrl(struct v4l2_ctrl *ctrl)
> >>+{
> >>+	struct et8ek8_sensor *sensor =
> >>+		container_of(ctrl->handler, struct et8ek8_sensor, ctrl_handler);
> >>+	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
> >>+	int uninitialized_var(rows);
> >>+
> >>+	if (ctrl->id == V4L2_CID_EXPOSURE)
> >>+		rows = et8ek8_exposure_us_to_rows(sensor, (u32 *)&ctrl->val);
> >>+
> >>+	switch (ctrl->id) {
> >>+	case V4L2_CID_GAIN:
> >>+		return et8ek8_set_gain(sensor, ctrl->val);
> >>+
> >>+	case V4L2_CID_EXPOSURE:
> >>+		return smia_i2c_write_reg(client, SMIA_REG_16BIT, 0x1243,
> >>+					  swab16(rows));
> >>+
> >>+	case V4L2_CID_TEST_PATTERN:
> >>+		return et8ek8_set_test_pattern(sensor, ctrl->val);
> >>+
> >>+	case V4L2_CID_PIXEL_RATE:
> >>+		/* For v4l2_ctrl_s_ctrl_int64() used internally. */
> >>+		return 0;
> >>+
> >>+	default:
> >>+		return -EINVAL;
> >>+	}
> >>+}
> >>+
> >>+static const struct v4l2_ctrl_ops et8ek8_ctrl_ops = {
> >>+	.g_volatile_ctrl = et8ek8_get_ctrl,
> >>+	.s_ctrl = et8ek8_set_ctrl,
> >>+};
> >>+
> >>+static const char *et8ek8_test_pattern_menu[] = {
> >>+	"Normal",
> >>+	"Vertical colorbar",
> >>+	"Horizontal colorbar",
> >>+	"Scale",
> >>+	"Ramp",
> >>+	"Small vertical colorbar",
> >>+	"Small horizontal colorbar",
> >>+	"Small scale",
> >>+	"Small ramp",
> >>+};
> >>+
> >>+static const struct v4l2_ctrl_config et8ek8_ctrls[] = {
> >>+	{
> >>+		.ops		= &et8ek8_ctrl_ops,
> >>+		.id		= V4L2_CID_TEST_PATTERN,
> >>+		.type		= V4L2_CTRL_TYPE_MENU,
> >>+		.name		= "Test pattern mode",
> >>+		.min		= 0,
> >>+		.max		= ARRAY_SIZE(et8ek8_test_pattern_menu) - 1,
> >>+		.step		= 0,
> >>+		.def		= 0,
> >>+		.flags		= 0,
> >>+		.qmenu		= et8ek8_test_pattern_menu,
> >>+	},
> >>+	{
> >>+		.id		= V4L2_CID_MODE_CLASS,
> >>+		.type		= V4L2_CTRL_TYPE_CTRL_CLASS,
> >>+		.name		= "SMIA-type sensor information",
> >>+		.min		= 0,
> >>+		.max		= 0,
> >>+		.step		= 1,
> >>+		.def		= 0,
> >>+		.flags		= V4L2_CTRL_FLAG_READ_ONLY
> >>+				| V4L2_CTRL_FLAG_WRITE_ONLY,
> >>+	},
> >>+	{
> >>+		.ops		= &et8ek8_ctrl_ops,
> >>+		.id		= V4L2_CID_MODE_FRAME_WIDTH,
> >>+		.type		= V4L2_CTRL_TYPE_INTEGER,
> >>+		.name		= "Frame width",
> >>+		.min		= 0,
> >>+		.max		= 0,
> >>+		.step		= 1,
> >>+		.def		= 0,
> >>+		.flags		= V4L2_CTRL_FLAG_READ_ONLY
> >>+				  | V4L2_CTRL_FLAG_VOLATILE,
> >>+	},
> >>+	{
> >>+		.ops		= &et8ek8_ctrl_ops,
> >>+		.id		= V4L2_CID_MODE_FRAME_HEIGHT,
> >>+		.type		= V4L2_CTRL_TYPE_INTEGER,
> >>+		.name		= "Frame height",
> >>+		.min		= 0,
> >>+		.max		= 0,
> >>+		.step		= 1,
> >>+		.def		= 0,
> >>+		.flags		= V4L2_CTRL_FLAG_READ_ONLY
> >>+				  | V4L2_CTRL_FLAG_VOLATILE,
> >>+	},
> >>+	{
> >>+		.ops		= &et8ek8_ctrl_ops,
> >>+		.id		= V4L2_CID_MODE_VISIBLE_WIDTH,
> >>+		.type		= V4L2_CTRL_TYPE_INTEGER,
> >>+		.name		= "Visible width",
> >>+		.min		= 0,
> >>+		.max		= 0,
> >>+		.step		= 1,
> >>+		.def		= 0,
> >>+		.flags		= V4L2_CTRL_FLAG_READ_ONLY
> >>+				  | V4L2_CTRL_FLAG_VOLATILE,
> >>+	},
> >>+	{
> >>+		.ops		= &et8ek8_ctrl_ops,
> >>+		.id		= V4L2_CID_MODE_VISIBLE_HEIGHT,
> >>+		.type		= V4L2_CTRL_TYPE_INTEGER,
> >>+		.name		= "Visible height",
> >>+		.min		= 0,
> >>+		.max		= 0,
> >>+		.step		= 1,
> >>+		.def		= 0,
> >>+		.flags		= V4L2_CTRL_FLAG_READ_ONLY
> >>+				  | V4L2_CTRL_FLAG_VOLATILE,
> >>+	},
> >>+	{
> >>+		.ops		= &et8ek8_ctrl_ops,
> >>+		.id		= V4L2_CID_MODE_PIXELCLOCK,
> >>+		.type		= V4L2_CTRL_TYPE_INTEGER,
> >>+		.name		= "Pixel clock [Hz]",
> >>+		.min		= 0,
> >>+		.max		= 0,
> >>+		.step		= 1,
> >>+		.def		= 0,
> >>+		.flags		= V4L2_CTRL_FLAG_READ_ONLY
> >>+				  | V4L2_CTRL_FLAG_VOLATILE,
> >>+	},
> >>+	{
> >>+		.ops		= &et8ek8_ctrl_ops,
> >>+		.id		= V4L2_CID_MODE_SENSITIVITY,
> >>+		.type		= V4L2_CTRL_TYPE_INTEGER,
> >>+		.name		= "Sensivity",
> >>+		.min		= 0,
> >>+		.max		= 0,
> >>+		.step		= 1,
> >>+		.def		= 0,
> >>+		.flags		= V4L2_CTRL_FLAG_READ_ONLY
> >>+				  | V4L2_CTRL_FLAG_VOLATILE,
> >>+	},
> >>+	{
> >>+		.ops		= &et8ek8_ctrl_ops,
> >>+		.id		= V4L2_CID_MODE_OPSYSCLOCK,
> >>+		.type		= V4L2_CTRL_TYPE_INTEGER,
> >>+		.name		= "Output pixel clock [Hz]",
> >>+		.min		= 0,
> >>+		.max		= 0,
> >>+		.step		= 1,
> >>+		.def		= 0,
> >>+		.flags		= V4L2_CTRL_FLAG_READ_ONLY
> >>+				  | V4L2_CTRL_FLAG_VOLATILE,
> >
> >Many of the above controls are or standard controls should be used, please
> >use the native V4L2 control framework functions to create the controls
> >instead of the custom one. You get control names for free, for instance.
> >
> 
> ok.
> 
> >>+	},
> >>+};
> >>+
> >>+static int et8ek8_init_controls(struct et8ek8_sensor *sensor)
> >>+{
> >>+	unsigned int i;
> >>+	u32 min, max;
> >>+
> >>+	v4l2_ctrl_handler_init(&sensor->ctrl_handler,
> >>+			       ARRAY_SIZE(et8ek8_ctrls) + 2);
> >>+
> >>+	/* V4L2_CID_GAIN */
> >>+	v4l2_ctrl_new_std(&sensor->ctrl_handler, &et8ek8_ctrl_ops,
> >>+			  V4L2_CID_GAIN, 0, ARRAY_SIZE(et8ek8_gain_table) - 1,
> >>+			  1, 0);
> >>+
> >>+	/* V4L2_CID_EXPOSURE */
> >>+	min = et8ek8_exposure_rows_to_us(sensor, 1);
> >>+	max = et8ek8_exposure_rows_to_us(sensor,
> >>+				sensor->current_reglist->mode.max_exp);
> >>+	sensor->exposure =
> >>+		v4l2_ctrl_new_std(&sensor->ctrl_handler, &et8ek8_ctrl_ops,
> >>+				  V4L2_CID_EXPOSURE, min, max, min, max);
> >>+	sensor->pixel_rate =
> >>+		v4l2_ctrl_new_std(&sensor->ctrl_handler, &et8ek8_ctrl_ops,
> >>+		V4L2_CID_PIXEL_RATE, 1, INT_MAX, 1, 1);
> >>+
> >>+	/* V4L2_CID_TEST_PATTERN and V4L2_CID_MODE_* */
> >>+	for (i = 0; i < ARRAY_SIZE(et8ek8_ctrls); ++i)
> >>+		v4l2_ctrl_new_custom(&sensor->ctrl_handler, &et8ek8_ctrls[i],
> >>+				     NULL);
> >>+
> >>+	if (sensor->ctrl_handler.error)
> >>+		return sensor->ctrl_handler.error;
> >>+
> >>+	sensor->subdev.ctrl_handler = &sensor->ctrl_handler;
> >>+	return 0;
> >>+}
> >>+
> >>+static void et8ek8_update_controls(struct et8ek8_sensor *sensor)
> >>+{
> >>+	struct v4l2_ctrl *ctrl = sensor->exposure;
> >>+	u32 min, max;
> >>+
> >>+	min = et8ek8_exposure_rows_to_us(sensor, 1);
> >>+	max = et8ek8_exposure_rows_to_us(sensor,
> >>+					 sensor->current_reglist->mode.max_exp);
> >>+
> >>+	v4l2_ctrl_lock(ctrl);
> >>+	ctrl->minimum = min;
> >>+	ctrl->maximum = max;
> >>+	ctrl->step = min;
> >>+	ctrl->default_value = max;
> >>+	ctrl->val = max;
> >>+	ctrl->cur.val = max;
> >>+	__v4l2_ctrl_s_ctrl_int64(sensor->pixel_rate,
> >>+				 sensor->current_reglist->mode.ext_clock);
> >>+	v4l2_ctrl_unlock(ctrl);
> >>+}
> >>+
> >>+static int et8ek8_configure(struct et8ek8_sensor *sensor)
> >>+{
> >>+	struct v4l2_subdev *subdev = &sensor->subdev;
> >>+	struct i2c_client *client = v4l2_get_subdevdata(subdev);
> >>+	int rval;
> >>+
> >>+	rval = smia_i2c_write_regs(client, sensor->current_reglist->regs);
> >>+	if (rval)
> >>+		goto fail;
> >>+
> >>+	/* Controls set while the power to the sensor is turned off are saved
> >>+	 * but not applied to the hardware. Now that we're about to start
> >>+	 * streaming apply all the current values to the hardware.
> >>+	 */
> >>+	rval = v4l2_ctrl_handler_setup(&sensor->ctrl_handler);
> >>+	if (rval)
> >>+		goto fail;
> >>+
> >>+	return 0;
> >>+
> >>+fail:
> >>+	dev_err(&client->dev, "sensor configuration failed\n");
> >>+	return rval;
> >>+}
> >>+
> >>+static int et8ek8_stream_on(struct et8ek8_sensor *sensor)
> >>+{
> >>+	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
> >>+
> >>+	return smia_i2c_write_reg(client, SMIA_REG_8BIT, 0x1252, 0xb0);
> >>+}
> >>+
> >>+static int et8ek8_stream_off(struct et8ek8_sensor *sensor)
> >>+{
> >>+	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
> >>+
> >>+	return smia_i2c_write_reg(client, SMIA_REG_8BIT, 0x1252, 0x30);
> >>+}
> >>+
> >>+static int et8ek8_s_stream(struct v4l2_subdev *subdev, int streaming)
> >>+{
> >>+	struct et8ek8_sensor *sensor = to_et8ek8_sensor(subdev);
> >>+	int ret;
> >>+
> >>+	if (!streaming)
> >>+		return et8ek8_stream_off(sensor);
> >>+
> >>+	ret = et8ek8_configure(sensor);
> >>+	if (ret < 0)
> >>+		return ret;
> >>+
> >>+	return et8ek8_stream_on(sensor);
> >>+}
> >>+
> >>+/* --------------------------------------------------------------------------
> >>+ * V4L2 subdev operations
> >>+ */
> >>+
> >>+static int et8ek8_power_off(struct et8ek8_sensor *sensor)
> >>+{
> >>+	int rval;
> >>+
> >>+	gpiod_set_value(sensor->reset, 0);
> >>+	udelay(1);
> >>+
> >>+	clk_disable_unprepare(sensor->ext_clk);
> >>+
> >>+	rval = regulator_disable(sensor->vana);
> >>+	return rval;
> >>+}
> >>+
> >>+static int et8ek8_power_on(struct et8ek8_sensor *sensor)
> >>+{
> >>+	struct v4l2_subdev *subdev = &sensor->subdev;
> >>+	struct i2c_client *client = v4l2_get_subdevdata(subdev);
> >>+	unsigned int hz = ET8EK8_XCLK_HZ;
> >>+	int val, rval;
> >>+
> >>+	rval = regulator_enable(sensor->vana);
> >>+	if (rval) {
> >>+		dev_err(&client->dev, "failed to enable vana regulator\n");
> >>+		return rval;
> >>+	}
> >>+
> >>+	if (sensor->current_reglist)
> >>+		hz = sensor->current_reglist->mode.ext_clock;
> >>+
> >>+	rval = clk_set_rate(sensor->ext_clk, hz);
> >>+	if (rval < 0) {
> >>+		dev_err(&client->dev,
> >>+			"unable to set extclk clock freq to %u\n", hz);
> >>+		goto out;
> >>+	}
> >>+	rval = clk_prepare_enable(sensor->ext_clk);
> >>+	if (rval < 0) {
> >>+		dev_err(&client->dev, "failed to enable extclk\n");
> >>+		goto out;
> >>+	}
> >>+
> >>+	if (rval)
> >>+		goto out;
> >>+
> >>+	udelay(10);			/* I wish this is a good value */
> >>+
> >>+	gpiod_set_value(sensor->reset, 1);
> >>+
> >>+	msleep(5000*1000/hz+1);				/* Wait 5000 cycles */
> >>+
> >>+	rval = smia_i2c_reglist_find_write(client,
> >>+					   &et8ek8_smia_meta_reglist,
> >>+					   SMIA_REGLIST_POWERON);
> >>+	if (rval)
> >>+		goto out;
> >>+
> >>+#ifdef USE_CRC
> >>+	rval = smia_i2c_read_reg(client,
> >>+				 SMIA_REG_8BIT, 0x1263, &val);
> >>+	if (rval)
> >>+		goto out;
> >>+#if USE_CRC
> >>+	val |= (1<<4);
> >>+#else
> >>+	val &= ~(1<<4);
> >>+#endif
> >>+	rval = smia_i2c_write_reg(client,
> >>+				  SMIA_REG_8BIT, 0x1263, val);
> >>+	if (rval)
> >>+		goto out;
> >>+#endif
> >>+
> >>+out:
> >>+	if (rval)
> >>+		et8ek8_power_off(sensor);
> >>+
> >>+	return rval;
> >>+}
> >>+
> >>+/* --------------------------------------------------------------------------
> >>+ * V4L2 subdev video operations
> >>+ */
> >>+
> >>+static int et8ek8_enum_mbus_code(struct v4l2_subdev *subdev,
> >>+				 struct v4l2_subdev_pad_config *cfg,
> >>+				 struct v4l2_subdev_mbus_code_enum *code)
> >>+{
> >>+	return smia_reglist_enum_mbus_code(&et8ek8_smia_meta_reglist, code);
> >>+}
> >>+
> >>+static int et8ek8_enum_frame_size(struct v4l2_subdev *subdev,
> >>+				  struct v4l2_subdev_pad_config *cfg,
> >>+				  struct v4l2_subdev_frame_size_enum *fse)
> >>+{
> >>+	return smia_reglist_enum_frame_size(&et8ek8_smia_meta_reglist, fse);
> >>+}
> >>+
> >>+static int et8ek8_enum_frame_ival(struct v4l2_subdev *subdev,
> >>+				  struct v4l2_subdev_pad_config *cfg,
> >>+				  struct v4l2_subdev_frame_interval_enum *fie)
> >>+{
> >>+	return smia_reglist_enum_frame_ival(&et8ek8_smia_meta_reglist, fie);
> >>+}
> >>+
> >>+static struct v4l2_mbus_framefmt *
> >>+__et8ek8_get_pad_format(struct et8ek8_sensor *sensor,
> >>+			struct v4l2_subdev_pad_config *cfg,
> >>+			unsigned int pad, enum v4l2_subdev_format_whence which)
> >>+{
> >>+	switch (which) {
> >>+	case V4L2_SUBDEV_FORMAT_TRY:
> >>+		return v4l2_subdev_get_try_format(&sensor->subdev, cfg, pad);
> >>+	case V4L2_SUBDEV_FORMAT_ACTIVE:
> >>+		return &sensor->format;
> >>+	default:
> >>+		return NULL;
> >>+	}
> >>+}
> >>+
> >>+static int et8ek8_get_pad_format(struct v4l2_subdev *subdev,
> >>+				 struct v4l2_subdev_pad_config *cfg,
> >>+				 struct v4l2_subdev_format *fmt)
> >>+{
> >>+	struct et8ek8_sensor *sensor = to_et8ek8_sensor(subdev);
> >>+	struct v4l2_mbus_framefmt *format;
> >>+
> >>+	format = __et8ek8_get_pad_format(sensor, cfg, fmt->pad, fmt->which);
> >>+	if (format == NULL)
> >>+		return -EINVAL;
> >>+
> >>+	fmt->format = *format;
> >>+	return 0;
> >>+}
> >>+
> >>+static int et8ek8_set_pad_format(struct v4l2_subdev *subdev,
> >>+				 struct v4l2_subdev_pad_config *cfg,
> >>+				 struct v4l2_subdev_format *fmt)
> >>+{
> >>+	struct et8ek8_sensor *sensor = to_et8ek8_sensor(subdev);
> >>+	struct v4l2_mbus_framefmt *format;
> >>+        struct smia_reglist *reglist;
> >>+
> >>+	format = __et8ek8_get_pad_format(sensor, cfg, fmt->pad, fmt->which);
> >>+	if (format == NULL)
> >>+		return -EINVAL;
> >>+
> >>+	reglist = smia_reglist_find_mode_fmt(&et8ek8_smia_meta_reglist,
> >>+					     &fmt->format);
> >>+	smia_reglist_to_mbus(reglist, &fmt->format);
> >>+	*format = fmt->format;
> >>+
> >>+	if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
> >>+		sensor->current_reglist = reglist;
> >>+		et8ek8_update_controls(sensor);
> >>+	}
> >>+
> >>+	return 0;
> >>+}
> >>+
> >>+static int et8ek8_get_frame_interval(struct v4l2_subdev *subdev,
> >>+				     struct v4l2_subdev_frame_interval *fi)
> >>+{
> >>+	struct et8ek8_sensor *sensor = to_et8ek8_sensor(subdev);
> >>+
> >>+	memset(fi, 0, sizeof(*fi));
> >>+	fi->interval = sensor->current_reglist->mode.timeperframe;
> >>+
> >>+	return 0;
> >>+}
> >>+
> >>+static int et8ek8_set_frame_interval(struct v4l2_subdev *subdev,
> >>+				     struct v4l2_subdev_frame_interval *fi)
> >>+{
> >>+	struct et8ek8_sensor *sensor = to_et8ek8_sensor(subdev);
> >>+	struct smia_reglist *reglist;
> >>+
> >>+	reglist = smia_reglist_find_mode_ival(&et8ek8_smia_meta_reglist,
> >>+					      sensor->current_reglist,
> >>+					      &fi->interval);
> >>+
> >>+	if (!reglist)
> >>+		return -EINVAL;
> >>+
> >>+	if (sensor->current_reglist->mode.ext_clock != reglist->mode.ext_clock)
> >>+		return -EINVAL;
> >>+
> >>+	sensor->current_reglist = reglist;
> >>+	et8ek8_update_controls(sensor);
> >>+
> >>+	return 0;
> >>+}
> >>+
> >>+static int et8ek8_g_priv_mem(struct v4l2_subdev *subdev)
> >>+{
> >>+	struct et8ek8_sensor *sensor = to_et8ek8_sensor(subdev);
> >>+	struct i2c_client *client = v4l2_get_subdevdata(subdev);
> >>+	unsigned int length = ET8EK8_PRIV_MEM_SIZE;
> >>+	unsigned int offset = 0;
> >>+	u8 *ptr  = sensor->priv_mem;
> >>+	int rval = 0;
> >>+
> >>+	/* Read the EEPROM window-by-window, each window 8 bytes */
> >>+	do {
> >>+		u8 buffer[PRIV_MEM_WIN_SIZE];
> >>+		struct i2c_msg msg;
> >>+		int bytes, i;
> >>+		int ofs;
> >>+
> >>+		/* Set the current window */
> >>+		rval = smia_i2c_write_reg(client,
> >>+					  SMIA_REG_8BIT,
> >>+					  0x0001,
> >>+					  0xe0 | (offset >> 3));
> >>+		if (rval < 0)
> >>+			goto out;
> >>+
> >>+		/* Wait for status bit */
> >>+		for (i = 0; i < 1000; ++i) {
> >>+			u32 status;
> >>+			rval = smia_i2c_read_reg(client,
> >>+						 SMIA_REG_8BIT,
> >>+						 0x0003,
> >>+						 &status);
> >>+			if (rval < 0)
> >>+				goto out;
> >>+			if ((status & 0x08) == 0)
> >>+				break;
> >>+			msleep(1);
> >>+		};
> >>+
> >>+		if (i == 1000) {
> >>+			rval = -EIO;
> >>+			goto out;
> >>+		}
> >>+
> >>+		/* Read window, 8 bytes at once, and copy to user space */
> >>+		ofs = offset & 0x07;	/* Offset within this window */
> >>+		bytes = length + ofs > 8 ? 8-ofs : length;
> >>+		msg.addr = client->addr;
> >>+		msg.flags = 0;
> >>+		msg.len = 2;
> >>+		msg.buf = buffer;
> >>+		ofs += PRIV_MEM_START_REG;
> >>+		buffer[0] = (u8)(ofs >> 8);
> >>+		buffer[1] = (u8)(ofs & 0xFF);
> >>+		rval = i2c_transfer(client->adapter, &msg, 1);
> >>+		if (rval < 0)
> >>+			goto out;
> >>+		mdelay(ET8EK8_I2C_DELAY);
> >>+		msg.addr = client->addr;
> >>+		msg.len = bytes;
> >>+		msg.flags = I2C_M_RD;
> >>+		msg.buf = buffer;
> >>+		memset(buffer, 0, sizeof(buffer));
> >>+		rval = i2c_transfer(client->adapter, &msg, 1);
> >>+		if (rval < 0)
> >>+			goto out;
> >>+		rval = 0;
> >>+		memcpy(ptr, buffer, bytes);
> >>+
> >>+		length -= bytes;
> >>+		offset += bytes;
> >>+		ptr    += bytes;
> >>+	} while (length > 0);
> >>+
> >>+out:
> >>+	return rval;
> >>+}
> >>+
> >>+static int et8ek8_dev_init(struct v4l2_subdev *subdev)
> >>+{
> >>+	struct et8ek8_sensor *sensor = to_et8ek8_sensor(subdev);
> >>+	struct i2c_client *client = v4l2_get_subdevdata(subdev);
> >>+	int rval, rev_l, rev_h;
> >>+
> >>+	rval = et8ek8_power_on(sensor);
> >>+	if (rval) {
> >>+		dev_err(&client->dev, "could not power on\n");
> >>+		return rval;
> >>+	}
> >>+
> >>+	if (smia_i2c_read_reg(client, SMIA_REG_8BIT,
> >>+			      REG_REVISION_NUMBER_L, &rev_l) != 0
> >>+	    || smia_i2c_read_reg(client, SMIA_REG_8BIT,
> >>+				 REG_REVISION_NUMBER_H, &rev_h) != 0) {
> >>+		dev_err(&client->dev,
> >>+			"no et8ek8 sensor detected\n");
> >>+		rval = -ENODEV;
> >>+		goto out_poweroff;
> >>+	}
> >>+	sensor->version = (rev_h << 8) + rev_l;
> >>+	if (sensor->version != ET8EK8_REV_1
> >>+	    && sensor->version != ET8EK8_REV_2)
> >>+		dev_info(&client->dev,
> >>+			 "unknown version 0x%x detected, "
> >>+			 "continuing anyway\n", sensor->version);
> >>+
> >>+	rval = smia_reglist_import(&et8ek8_smia_meta_reglist);
> >>+	if (rval) {
> >>+		dev_err(&client->dev,
> >>+			"invalid register list %s, import failed\n",
> >>+			ET8EK8_NAME);
> >>+		goto out_poweroff;
> >>+	}
> >>+
> >>+	sensor->current_reglist =
> >>+		smia_reglist_find_type(&et8ek8_smia_meta_reglist,
> >>+				       SMIA_REGLIST_MODE);
> >>+	if (!sensor->current_reglist) {
> >>+		dev_err(&client->dev,
> >>+			"invalid register list %s, no mode found\n",
> >>+			ET8EK8_NAME);
> >>+		rval = -ENODEV;
> >>+		goto out_poweroff;
> >>+	}
> >>+
> >>+	smia_reglist_to_mbus(sensor->current_reglist, &sensor->format);
> >>+
> >>+	rval = smia_i2c_reglist_find_write(client,
> >>+					   &et8ek8_smia_meta_reglist,
> >>+					   SMIA_REGLIST_POWERON);
> >>+	if (rval) {
> >>+		dev_err(&client->dev,
> >>+			"invalid register list %s, no POWERON mode found\n",
> >>+			ET8EK8_NAME);
> >>+		goto out_poweroff;
> >>+	}
> >>+	rval = et8ek8_stream_on(sensor);	/* Needed to be able to read EEPROM */
> >>+	if (rval)
> >>+		goto out_poweroff;
> >>+	rval = et8ek8_g_priv_mem(subdev);
> >>+	if (rval)
> >>+		dev_warn(&client->dev,
> >>+			"can not read OTP (EEPROM) memory from sensor\n");
> >>+	rval = et8ek8_stream_off(sensor);
> >>+	if (rval)
> >>+		goto out_poweroff;
> >>+
> >>+	rval = et8ek8_power_off(sensor);
> >>+	if (rval)
> >>+		goto out_poweroff;
> >>+
> >>+	return 0;
> >>+
> >>+out_poweroff:
> >>+	et8ek8_power_off(sensor);
> >>+
> >>+	return rval;
> >>+}
> >>+
> >>+/* --------------------------------------------------------------------------
> >>+ * sysfs attributes
> >>+ */
> >>+static ssize_t
> >>+et8ek8_priv_mem_read(struct device *dev, struct device_attribute *attr,
> >>+		     char *buf)
> >>+{
> >>+	struct v4l2_subdev *subdev = i2c_get_clientdata(to_i2c_client(dev));
> >>+	struct et8ek8_sensor *sensor = to_et8ek8_sensor(subdev);
> >>+
> >>+#if PAGE_SIZE < ET8EK8_PRIV_MEM_SIZE
> >>+#error PAGE_SIZE too small!
> >>+#endif
> >>+
> >>+	memcpy(buf, sensor->priv_mem, ET8EK8_PRIV_MEM_SIZE);
> >>+
> >>+	return ET8EK8_PRIV_MEM_SIZE;
> >>+}
> >>+static DEVICE_ATTR(priv_mem, S_IRUGO, et8ek8_priv_mem_read, NULL);
> >>+
> >>+/* --------------------------------------------------------------------------
> >>+ * V4L2 subdev core operations
> >>+ */
> >>+
> >>+static int
> >>+et8ek8_registered(struct v4l2_subdev *subdev)
> >>+{
> >>+	struct et8ek8_sensor *sensor = to_et8ek8_sensor(subdev);
> >>+	struct i2c_client *client = v4l2_get_subdevdata(subdev);
> >>+	struct v4l2_mbus_framefmt *format;
> >>+	int rval;
> >>+
> >>+	dev_dbg(&client->dev, "registered!");
> >>+
> >>+	if (device_create_file(&client->dev, &dev_attr_priv_mem) != 0) {
> >>+		dev_err(&client->dev, "could not register sysfs entry\n");
> >>+		return -EBUSY;
> >>+	}
> >>+
> >>+	rval = et8ek8_dev_init(subdev);
> >>+	if (rval)
> >>+		return rval;
> >>+
> >>+	rval = et8ek8_init_controls(sensor);
> >>+	if (rval) {
> >>+		dev_err(&client->dev, "controls initialization failed\n");
> >>+		return rval;
> >>+	}
> >>+
> >>+	format = __et8ek8_get_pad_format(sensor, NULL, 0,
> >>+					 V4L2_SUBDEV_FORMAT_ACTIVE);
> >>+	return 0;
> >>+}
> >>+
> >>+static int __et8ek8_set_power(struct et8ek8_sensor *sensor, bool on)
> >>+{
> >>+	return on ? et8ek8_power_on(sensor) : et8ek8_power_off(sensor);
> >>+}
> >>+
> >>+static int et8ek8_set_power(struct v4l2_subdev *subdev, int on)
> >>+{
> >>+	struct et8ek8_sensor *sensor = to_et8ek8_sensor(subdev);
> >>+	int ret = 0;
> >>+
> >>+	mutex_lock(&sensor->power_lock);
> >>+
> >>+	/* If the power count is modified from 0 to != 0 or from != 0 to 0,
> >>+	 * update the power state.
> >>+	 */
> >>+	if (sensor->power_count == !on) {
> >>+		ret = __et8ek8_set_power(sensor, !!on);
> >>+		if (ret < 0)
> >>+			goto done;
> >>+	}
> >>+
> >>+	/* Update the power count. */
> >>+	sensor->power_count += on ? 1 : -1;
> >>+	WARN_ON(sensor->power_count < 0);
> >>+
> >>+done:
> >>+	mutex_unlock(&sensor->power_lock);
> >>+	return ret;
> >>+}
> >>+
> >>+static int et8ek8_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
> >>+{
> >>+	struct et8ek8_sensor *sensor = to_et8ek8_sensor(sd);
> >>+	struct v4l2_mbus_framefmt *format;
> >>+	struct smia_reglist *reglist;
> >>+
> >>+	reglist = smia_reglist_find_type(&et8ek8_smia_meta_reglist,
> >>+					 SMIA_REGLIST_MODE);
> >>+	format = __et8ek8_get_pad_format(sensor, fh->pad, 0, V4L2_SUBDEV_FORMAT_TRY);
> >>+	smia_reglist_to_mbus(reglist, format);
> >>+
> >>+	return et8ek8_set_power(sd, true);
> >>+}
> >>+
> >>+static int et8ek8_close(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
> >>+{
> >>+	return et8ek8_set_power(sd, false);
> >>+}
> >>+
> >>+static const struct v4l2_subdev_video_ops et8ek8_video_ops = {
> >>+	.s_stream = et8ek8_s_stream,
> >>+	.g_frame_interval = et8ek8_get_frame_interval,
> >>+	.s_frame_interval = et8ek8_set_frame_interval,
> >>+};
> >>+
> >>+static const struct v4l2_subdev_core_ops et8ek8_core_ops = {
> >>+	.s_power = et8ek8_set_power,
> >>+};
> >>+
> >>+static const struct v4l2_subdev_pad_ops et8ek8_pad_ops = {
> >>+	.enum_mbus_code = et8ek8_enum_mbus_code,
> >>+        .enum_frame_size = et8ek8_enum_frame_size,
> >>+        .enum_frame_interval = et8ek8_enum_frame_ival,
> >>+	.get_fmt = et8ek8_get_pad_format,
> >>+	.set_fmt = et8ek8_set_pad_format,
> >>+};
> >>+
> >>+static const struct v4l2_subdev_ops et8ek8_ops = {
> >>+	.core = &et8ek8_core_ops,
> >>+	.video = &et8ek8_video_ops,
> >>+	.pad = &et8ek8_pad_ops,
> >>+};
> >>+
> >>+static const struct v4l2_subdev_internal_ops et8ek8_internal_ops = {
> >>+	.registered = et8ek8_registered,
> >>+	.open = et8ek8_open,
> >>+	.close = et8ek8_close,
> >>+};
> >>+
> >>+/* --------------------------------------------------------------------------
> >>+ * I2C driver
> >>+ */
> >>+#ifdef CONFIG_PM
> >>+
> >>+static int et8ek8_suspend(struct device *dev)
> >>+{
> >>+	struct i2c_client *client = to_i2c_client(dev);
> >>+	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
> >>+	struct et8ek8_sensor *sensor = to_et8ek8_sensor(subdev);
> >>+
> >>+	if (!sensor->power_count)
> >>+		return 0;
> >>+
> >>+	return __et8ek8_set_power(sensor, false);
> >>+}
> >>+
> >>+static int et8ek8_resume(struct device *dev)
> >>+{
> >>+	struct i2c_client *client = to_i2c_client(dev);
> >>+	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
> >>+	struct et8ek8_sensor *sensor = to_et8ek8_sensor(subdev);
> >>+
> >>+	if (!sensor->power_count)
> >>+		return 0;
> >>+
> >>+	return __et8ek8_set_power(sensor, true);
> >>+}
> >>+
> >>+static struct dev_pm_ops et8ek8_pm_ops = {
> >>+	.suspend	= et8ek8_suspend,
> >>+	.resume		= et8ek8_resume,
> >>+};
> >>+
> >>+#else
> >>+
> >>+#define et8ek8_pm_ops	NULL
> >>+
> >>+#endif /* CONFIG_PM */
> >>+
> >>+static int et8ek8_probe(struct i2c_client *client,
> >>+			const struct i2c_device_id *devid)
> >>+{
> >>+	struct et8ek8_sensor *sensor;
> >>+	int ret;
> >>+
> >>+	sensor = devm_kzalloc(&client->dev, sizeof(*sensor), GFP_KERNEL);
> >>+	if (!sensor)
> >>+		return -ENOMEM;
> >>+
> >>+	sensor->reset = devm_gpiod_get(&client->dev, "reset", GPIOD_OUT_LOW);
> >>+	if (IS_ERR(sensor->reset)) {
> >>+		dev_dbg(&client->dev, "could not request reset gpio\n");
> >>+		return PTR_ERR(sensor->reset);;
> >>+	}
> >>+
> >>+	sensor->vana = devm_regulator_get(&client->dev, "vana");
> >>+	if (IS_ERR(sensor->vana)) {
> >>+		dev_err(&client->dev, "could not get regulator for vana\n");
> >>+		return PTR_ERR(sensor->vana);
> >>+	}
> >>+
> >>+	sensor->ext_clk = devm_clk_get(&client->dev, "extclk");
> >>+	if (IS_ERR(sensor->ext_clk)) {
> >>+		dev_err(&client->dev, "could not get clock\n");
> >>+		return PTR_ERR(sensor->ext_clk);
> >>+	}
> >>+
> >>+	mutex_init(&sensor->power_lock);
> >>+
> >>+	v4l2_i2c_subdev_init(&sensor->subdev, client, &et8ek8_ops);
> >>+	sensor->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> >>+	sensor->subdev.internal_ops = &et8ek8_internal_ops;
> >>+
> >>+	sensor->pad.flags = MEDIA_PAD_FL_SOURCE;
> >>+	ret = media_entity_pads_init(&sensor->subdev.entity, 1, &sensor->pad);
> >>+	if (ret < 0) {
> >>+		dev_err(&client->dev, "media entity init failed!\n");
> >>+		return ret;
> >>+	}
> >>+
> >>+	ret = v4l2_async_register_subdev(&sensor->subdev);
> >>+	if (ret < 0) {
> >>+		media_entity_cleanup(&sensor->subdev.entity);
> >>+		return ret;
> >>+	}
> >>+
> >>+	dev_dbg(&client->dev, "initialized!\n");
> >>+
> >>+	return 0;
> >>+}
> >>+
> >>+static int __exit et8ek8_remove(struct i2c_client *client)
> >>+{
> >>+	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
> >>+	struct et8ek8_sensor *sensor = to_et8ek8_sensor(subdev);
> >>+
> >>+	if (sensor->power_count) {
> >>+		gpiod_set_value(sensor->reset, 0);
> >>+		clk_disable_unprepare(sensor->ext_clk);
> >>+		sensor->power_count = 0;
> >>+	}
> >>+
> >>+	v4l2_device_unregister_subdev(&sensor->subdev);
> >>+	device_remove_file(&client->dev, &dev_attr_priv_mem);
> >>+	v4l2_ctrl_handler_free(&sensor->ctrl_handler);
> >>+	media_entity_cleanup(&sensor->subdev.entity);
> >>+
> >>+	return 0;
> >>+}
> >>+
> >>+static const struct of_device_id et8ek8_of_table[] = {
> >>+	{ .compatible = "toshiba,et8ek8" },
> >>+	{ },
> >>+};
> >>+
> >>+static const struct i2c_device_id et8ek8_id_table[] = {
> >>+	{ ET8EK8_NAME, 0 },
> >>+	{ }
> >>+};
> >>+MODULE_DEVICE_TABLE(i2c, et8ek8_id_table);
> >>+
> >>+static struct i2c_driver et8ek8_i2c_driver = {
> >>+	.driver		= {
> >>+		.name	= ET8EK8_NAME,
> >>+		.pm	= &et8ek8_pm_ops,
> >>+		.of_match_table	= et8ek8_of_table,
> >>+	},
> >>+	.probe		= et8ek8_probe,
> >>+	.remove		= __exit_p(et8ek8_remove),
> >>+	.id_table	= et8ek8_id_table,
> >>+};
> >>+
> >>+module_i2c_driver(et8ek8_i2c_driver);
> >>+
> >>+MODULE_AUTHOR("Sakari Ailus <sakari.ailus@nokia.com>");
> >
> >s/nokia.com/iki.fi/ please.
> >
> 
> ok
> 
> >>+MODULE_DESCRIPTION("Toshiba ET8EK8 camera sensor driver");
> >>+MODULE_LICENSE("GPL");
> >
> 
> Lets see if I understand correctly what needs to be done:
> 
> 1. Replace custom controls with standart controls where possible
> 2. Move the used code from smia_reglist to et8ek8 driver, drop the remnants.

Yeah.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
