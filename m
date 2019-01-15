Return-Path: <SRS0=JQ9q=P6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB5BAC282C3
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 08:06:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F45620870
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 08:06:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbfAVIGV (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 22 Jan 2019 03:06:21 -0500
Received: from mga11.intel.com ([192.55.52.93]:3039 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727219AbfAVIGU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Jan 2019 03:06:20 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Jan 2019 00:00:17 -0800
X-ExtLoopCount2: 2 from 10.252.59.124
X-IronPort-AV: E=Sophos;i="5.56,505,1539673200"; 
   d="scan'208";a="116425287"
Received: from ionitama-mobl2.ger.corp.intel.com (HELO kekkonen.fi.intel.com) ([10.252.59.124])
  by fmsmga007.fm.intel.com with ESMTP; 22 Jan 2019 00:00:16 -0800
Received: by kekkonen.fi.intel.com (Postfix, from userid 1000)
        id ADF0421E54; Tue, 22 Jan 2019 10:00:12 +0200 (EET)
Received: from paasikivi.fi.intel.com (localhost [127.0.0.1])
        by paasikivi.fi.intel.com (Postfix) with ESMTP id F0DCE204FB
        for <sailus@localhost>; Tue, 15 Jan 2019 10:26:30 +0200 (EET)
Received: from linux.intel.com [10.54.29.200]
        by paasikivi.fi.intel.com with IMAP (fetchmail-6.3.26)
        for <sailus@localhost> (single-drop); Tue, 15 Jan 2019 10:26:30 +0200 (EET)
Received: from fmsmga001.fm.intel.com (fmsmga001.fm.intel.com [10.253.24.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 5A804580261
        for <sakari.ailus@linux.intel.com>; Tue, 15 Jan 2019 00:26:29 -0800 (PST)
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,481,1539673200"; 
   d="scan'208";a="138374614"
Received: from benkao-pc.itwn.intel.com ([10.5.253.162])
  by fmsmga001.fm.intel.com with ESMTP; 15 Jan 2019 00:26:27 -0800
From:   Ben Kao <ben.kao@intel.com>
To:     linux-media@vger.kernel.org
Cc:     sakari.ailus@linux.intel.com, andy.yeh@intel.com,
        tfiga@chromium.org, Ben Kao <ben.kao@intel.com>
Subject: [PATCH v3] media: ov8856: Add support for OV8856 sensor
Date:   Tue, 15 Jan 2019 16:30:29 +0800
Message-Id: <1547541029-29492-1-git-send-email-ben.kao@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This patch adds driver for Omnivision's ov8856 sensor,
the driver supports following features:

- manual exposure/gain(analog and digital) control support
- two link frequencies
- VBLANK/HBLANK support
- test pattern support
- media controller support
- runtime PM support
- enable Vsync signal output
- supported resolutions
  + 3280x2464 at 30FPS
  + 1640x1232 at 30FPS

Signed-off-by: Ben Kao <ben.kao@intel.com>
---
since v2:
--Add MAINTAINERS entry for ov8856 driver.
--Modify the type of variables buf_i/var_i to "unsigned int" in
  ov8856_write_reg().
--Add link_validate function.
--Remove "ifdef CONFIG_ACPI" in ov8856_i2c_driver{}.
--Move ov8856_check_hwcfg() to the top of ov8856_probe().
--Remove unnecessary blank lines.
--Remove unnecessary V4L2_SUBDEV_FL_HAS_EVENTS flag.
--Enable Vsync signal output.
since v3:
--Correct the year of Copyright.
--Remove unnecessary define V4L2_CID_DIGITAL_GAIN
--Set ret in switch default case of ov8856_set_ctrl().
--Modify ov8856_write_reg() / ov8856_read_reg() to be simplified.
---
 MAINTAINERS                |    7 +
 drivers/media/i2c/Kconfig  |   12 +
 drivers/media/i2c/Makefile |    1 +
 drivers/media/i2c/ov8856.c | 1267 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 1287 insertions(+)
 create mode 100644 drivers/media/i2c/ov8856.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 4d04ceb..a17afe5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11231,6 +11231,13 @@ S:	Maintained
 F:	drivers/media/i2c/ov7740.c
 F:	Documentation/devicetree/bindings/media/i2c/ov7740.txt
 
+OMNIVISION OV8856 SENSOR DRIVER
+M:	Ben Kao <ben.kao@intel.com>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Maintained
+F:	drivers/media/i2c/ov8856.c
+
 OMNIVISION OV9650 SENSOR DRIVER
 M:	Sakari Ailus <sakari.ailus@linux.intel.com>
 R:	Akinobu Mita <akinobu.mita@gmail.com>
diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 4c936e1..34e73a6 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -820,6 +820,18 @@ config VIDEO_OV7740
 	  This is a Video4Linux2 sensor driver for the OmniVision
 	  OV7740 VGA camera sensor.
 
+config VIDEO_OV8856
+	tristate "OmniVision OV8856 sensor support"
+	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	depends on MEDIA_CAMERA_SUPPORT
+	select V4L2_FWNODE
+	help
+	  This is a Video4Linux2 sensor driver for the OmniVision
+	  OV8856 camera sensor.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called ov8856.
+
 config VIDEO_OV9650
 	tristate "OmniVision OV9650/OV9652 sensor support"
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
index 65fae77..c0bb378 100644
--- a/drivers/media/i2c/Makefile
+++ b/drivers/media/i2c/Makefile
@@ -78,6 +78,7 @@ obj-$(CONFIG_VIDEO_OV7640) += ov7640.o
 obj-$(CONFIG_VIDEO_OV7670) += ov7670.o
 obj-$(CONFIG_VIDEO_OV772X) += ov772x.o
 obj-$(CONFIG_VIDEO_OV7740) += ov7740.o
+obj-$(CONFIG_VIDEO_OV8856) += ov8856.o
 obj-$(CONFIG_VIDEO_OV9650) += ov9650.o
 obj-$(CONFIG_VIDEO_OV13858) += ov13858.o
 obj-$(CONFIG_VIDEO_MT9M032) += mt9m032.o
diff --git a/drivers/media/i2c/ov8856.c b/drivers/media/i2c/ov8856.c
new file mode 100644
index 0000000..c0d4408
--- /dev/null
+++ b/drivers/media/i2c/ov8856.c
@@ -0,0 +1,1267 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2019 Intel Corporation.
+
+#include <asm/unaligned.h>
+#include <linux/acpi.h>
+#include <linux/delay.h>
+#include <linux/i2c.h>
+#include <linux/module.h>
+#include <linux/pm_runtime.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-fwnode.h>
+
+#define OV8856_REG_VALUE_08BIT		1
+#define OV8856_REG_VALUE_16BIT		2
+#define OV8856_REG_VALUE_24BIT		3
+
+#define OV8856_LINK_FREQ_360MHZ		360000000ULL
+#define OV8856_LINK_FREQ_180MHZ		180000000ULL
+#define OV8856_SCLK			144000000ULL
+#define OV8856_MCLK			19200000
+#define OV8856_DATA_LANES		4
+#define OV8856_RGB_DEPTH		10
+
+#define OV8856_REG_CHIP_ID		0x300a
+#define OV8856_CHIP_ID			0x00885a
+
+#define OV8856_REG_MODE_SELECT		0x0100
+#define OV8856_MODE_STANDBY		0x00
+#define OV8856_MODE_STREAMING		0x01
+
+/* vertical-timings from sensor */
+#define OV8856_REG_VTS			0x380e
+#define OV8856_VTS_MAX			0x7fff
+
+/* horizontal-timings from sensor */
+#define OV8856_REG_HTS			0x380c
+
+/* Exposure controls from sensor */
+#define OV8856_REG_EXPOSURE		0x3500
+#define	OV8856_EXPOSURE_MIN		6
+#define OV8856_EXPOSURE_MAX_MARGIN	6
+#define	OV8856_EXPOSURE_STEP		1
+
+/* Analog gain controls from sensor */
+#define OV8856_REG_ANALOG_GAIN		0x3508
+#define	OV8856_ANAL_GAIN_MIN		128
+#define	OV8856_ANAL_GAIN_MAX		2047
+#define	OV8856_ANAL_GAIN_STEP		1
+
+/* Digital gain controls from sensor */
+#define OV8856_REG_MWB_R_GAIN		0x5019
+#define OV8856_REG_MWB_G_GAIN		0x501b
+#define OV8856_REG_MWB_B_GAIN		0x501d
+#define OV8856_DGTL_GAIN_MIN		0
+#define OV8856_DGTL_GAIN_MAX		4095
+#define OV8856_DGTL_GAIN_STEP		1
+#define OV8856_DGTL_GAIN_DEFAULT	1024
+
+/* Test Pattern Control */
+#define OV8856_REG_TEST_PATTERN		0x5e00
+#define OV8856_TEST_PATTERN_ENABLE	BIT(7)
+#define OV8856_TEST_PATTERN_BAR_SHIFT	2
+
+#define to_ov8856(_sd)			container_of(_sd, struct ov8856, sd)
+
+enum {
+	OV8856_LINK_FREQ_720MBPS,
+	OV8856_LINK_FREQ_360MBPS,
+};
+
+struct ov8856_reg {
+	u16 address;
+	u8 val;
+};
+
+struct ov8856_reg_list {
+	u32 num_of_regs;
+	const struct ov8856_reg *regs;
+};
+
+struct ov8856_link_freq_config {
+	const struct ov8856_reg_list reg_list;
+};
+
+struct ov8856_mode {
+	/* Frame width in pixels */
+	u32 width;
+
+	/* Frame height in pixels */
+	u32 height;
+
+	/* Horizontal timining size */
+	u32 hts;
+
+	/* Default vertical timining size */
+	u32 vts_def;
+
+	/* Min vertical timining size */
+	u32 vts_min;
+
+	/* Link frequency needed for this resolution */
+	u32 link_freq_index;
+
+	/* Sensor register settings for this resolution */
+	const struct ov8856_reg_list reg_list;
+};
+
+static const struct ov8856_reg mipi_data_rate_720mbps[] = {
+	{0x0103, 0x01},
+	{0x0100, 0x00},
+	{0x0302, 0x4b},
+	{0x0303, 0x01},
+	{0x030b, 0x02},
+	{0x030d, 0x4b},
+	{0x031e, 0x0c},
+};
+
+static const struct ov8856_reg mipi_data_rate_360mbps[] = {
+	{0x0103, 0x01},
+	{0x0100, 0x00},
+	{0x0302, 0x4b},
+	{0x0303, 0x03},
+	{0x030b, 0x02},
+	{0x030d, 0x4b},
+	{0x031e, 0x0c},
+};
+
+static const struct ov8856_reg mode_3280x2464_regs[] = {
+	{0x3000, 0x20},
+	{0x3003, 0x08},
+	{0x300e, 0x20},
+	{0x3010, 0x00},
+	{0x3015, 0x84},
+	{0x3018, 0x72},
+	{0x3021, 0x23},
+	{0x3033, 0x24},
+	{0x3500, 0x00},
+	{0x3501, 0x9a},
+	{0x3502, 0x20},
+	{0x3503, 0x08},
+	{0x3505, 0x83},
+	{0x3508, 0x01},
+	{0x3509, 0x80},
+	{0x350c, 0x00},
+	{0x350d, 0x80},
+	{0x350e, 0x04},
+	{0x350f, 0x00},
+	{0x3510, 0x00},
+	{0x3511, 0x02},
+	{0x3512, 0x00},
+	{0x3600, 0x72},
+	{0x3601, 0x40},
+	{0x3602, 0x30},
+	{0x3610, 0xc5},
+	{0x3611, 0x58},
+	{0x3612, 0x5c},
+	{0x3613, 0xca},
+	{0x3614, 0x20},
+	{0x3628, 0xff},
+	{0x3629, 0xff},
+	{0x362a, 0xff},
+	{0x3633, 0x10},
+	{0x3634, 0x10},
+	{0x3635, 0x10},
+	{0x3636, 0x10},
+	{0x3663, 0x08},
+	{0x3669, 0x34},
+	{0x366e, 0x10},
+	{0x3706, 0x86},
+	{0x370b, 0x7e},
+	{0x3714, 0x23},
+	{0x3730, 0x12},
+	{0x3733, 0x10},
+	{0x3764, 0x00},
+	{0x3765, 0x00},
+	{0x3769, 0x62},
+	{0x376a, 0x2a},
+	{0x376b, 0x30},
+	{0x3780, 0x00},
+	{0x3781, 0x24},
+	{0x3782, 0x00},
+	{0x3783, 0x23},
+	{0x3798, 0x2f},
+	{0x37a1, 0x60},
+	{0x37a8, 0x6a},
+	{0x37ab, 0x3f},
+	{0x37c2, 0x04},
+	{0x37c3, 0xf1},
+	{0x37c9, 0x80},
+	{0x37cb, 0x16},
+	{0x37cc, 0x16},
+	{0x37cd, 0x16},
+	{0x37ce, 0x16},
+	{0x3800, 0x00},
+	{0x3801, 0x00},
+	{0x3802, 0x00},
+	{0x3803, 0x07},
+	{0x3804, 0x0c},
+	{0x3805, 0xdf},
+	{0x3806, 0x09},
+	{0x3807, 0xa6},
+	{0x3808, 0x0c},
+	{0x3809, 0xd0},
+	{0x380a, 0x09},
+	{0x380b, 0xa0},
+	{0x380c, 0x07},
+	{0x380d, 0x88},
+	{0x380e, 0x09},
+	{0x380f, 0xb8},
+	{0x3810, 0x00},
+	{0x3811, 0x00},
+	{0x3812, 0x00},
+	{0x3813, 0x00},
+	{0x3814, 0x01},
+	{0x3815, 0x01},
+	{0x3816, 0x00},
+	{0x3817, 0x00},
+	{0x3818, 0x00},
+	{0x3819, 0x10},
+	{0x3820, 0x80},
+	{0x3821, 0x46},
+	{0x382a, 0x01},
+	{0x382b, 0x01},
+	{0x3830, 0x06},
+	{0x3836, 0x02},
+	{0x3862, 0x04},
+	{0x3863, 0x08},
+	{0x3cc0, 0x33},
+	{0x3d85, 0x17},
+	{0x3d8c, 0x73},
+	{0x3d8d, 0xde},
+	{0x4001, 0xe0},
+	{0x4003, 0x40},
+	{0x4008, 0x00},
+	{0x4009, 0x0b},
+	{0x400a, 0x00},
+	{0x400b, 0x84},
+	{0x400f, 0x80},
+	{0x4010, 0xf0},
+	{0x4011, 0xff},
+	{0x4012, 0x02},
+	{0x4013, 0x01},
+	{0x4014, 0x01},
+	{0x4015, 0x01},
+	{0x4042, 0x00},
+	{0x4043, 0x80},
+	{0x4044, 0x00},
+	{0x4045, 0x80},
+	{0x4046, 0x00},
+	{0x4047, 0x80},
+	{0x4048, 0x00},
+	{0x4049, 0x80},
+	{0x4041, 0x03},
+	{0x404c, 0x20},
+	{0x404d, 0x00},
+	{0x404e, 0x20},
+	{0x4203, 0x80},
+	{0x4307, 0x30},
+	{0x4317, 0x00},
+	{0x4503, 0x08},
+	{0x4601, 0x80},
+	{0x4800, 0x44},
+	{0x4816, 0x53},
+	{0x481b, 0x58},
+	{0x481f, 0x27},
+	{0x4837, 0x16},
+	{0x483c, 0x0f},
+	{0x484b, 0x05},
+	{0x5000, 0x57},
+	{0x5001, 0x0a},
+	{0x5004, 0x04},
+	{0x502e, 0x03},
+	{0x5030, 0x41},
+	{0x5780, 0x14},
+	{0x5781, 0x0f},
+	{0x5782, 0x44},
+	{0x5783, 0x02},
+	{0x5784, 0x01},
+	{0x5785, 0x01},
+	{0x5786, 0x00},
+	{0x5787, 0x04},
+	{0x5788, 0x02},
+	{0x5789, 0x0f},
+	{0x578a, 0xfd},
+	{0x578b, 0xf5},
+	{0x578c, 0xf5},
+	{0x578d, 0x03},
+	{0x578e, 0x08},
+	{0x578f, 0x0c},
+	{0x5790, 0x08},
+	{0x5791, 0x04},
+	{0x5792, 0x00},
+	{0x5793, 0x52},
+	{0x5794, 0xa3},
+	{0x5795, 0x02},
+	{0x5796, 0x20},
+	{0x5797, 0x20},
+	{0x5798, 0xd5},
+	{0x5799, 0xd5},
+	{0x579a, 0x00},
+	{0x579b, 0x50},
+	{0x579c, 0x00},
+	{0x579d, 0x2c},
+	{0x579e, 0x0c},
+	{0x579f, 0x40},
+	{0x57a0, 0x09},
+	{0x57a1, 0x40},
+	{0x59f8, 0x3d},
+	{0x5a08, 0x02},
+	{0x5b00, 0x02},
+	{0x5b01, 0x10},
+	{0x5b02, 0x03},
+	{0x5b03, 0xcf},
+	{0x5b05, 0x6c},
+	{0x5e00, 0x00}
+};
+
+static const struct ov8856_reg mode_1640x1232_regs[] = {
+	{0x3000, 0x20},
+	{0x3003, 0x08},
+	{0x300e, 0x20},
+	{0x3010, 0x00},
+	{0x3015, 0x84},
+	{0x3018, 0x72},
+	{0x3021, 0x23},
+	{0x3033, 0x24},
+	{0x3500, 0x00},
+	{0x3501, 0x4c},
+	{0x3502, 0xe0},
+	{0x3503, 0x08},
+	{0x3505, 0x83},
+	{0x3508, 0x01},
+	{0x3509, 0x80},
+	{0x350c, 0x00},
+	{0x350d, 0x80},
+	{0x350e, 0x04},
+	{0x350f, 0x00},
+	{0x3510, 0x00},
+	{0x3511, 0x02},
+	{0x3512, 0x00},
+	{0x3600, 0x72},
+	{0x3601, 0x40},
+	{0x3602, 0x30},
+	{0x3610, 0xc5},
+	{0x3611, 0x58},
+	{0x3612, 0x5c},
+	{0x3613, 0xca},
+	{0x3614, 0x20},
+	{0x3628, 0xff},
+	{0x3629, 0xff},
+	{0x362a, 0xff},
+	{0x3633, 0x10},
+	{0x3634, 0x10},
+	{0x3635, 0x10},
+	{0x3636, 0x10},
+	{0x3663, 0x08},
+	{0x3669, 0x34},
+	{0x366e, 0x08},
+	{0x3706, 0x86},
+	{0x370b, 0x7e},
+	{0x3714, 0x27},
+	{0x3730, 0x12},
+	{0x3733, 0x10},
+	{0x3764, 0x00},
+	{0x3765, 0x00},
+	{0x3769, 0x62},
+	{0x376a, 0x2a},
+	{0x376b, 0x30},
+	{0x3780, 0x00},
+	{0x3781, 0x24},
+	{0x3782, 0x00},
+	{0x3783, 0x23},
+	{0x3798, 0x2f},
+	{0x37a1, 0x60},
+	{0x37a8, 0x6a},
+	{0x37ab, 0x3f},
+	{0x37c2, 0x14},
+	{0x37c3, 0xf1},
+	{0x37c9, 0x80},
+	{0x37cb, 0x16},
+	{0x37cc, 0x16},
+	{0x37cd, 0x16},
+	{0x37ce, 0x16},
+	{0x3800, 0x00},
+	{0x3801, 0x00},
+	{0x3802, 0x00},
+	{0x3803, 0x07},
+	{0x3804, 0x0c},
+	{0x3805, 0xdf},
+	{0x3806, 0x09},
+	{0x3807, 0xa6},
+	{0x3808, 0x06},
+	{0x3809, 0x68},
+	{0x380a, 0x04},
+	{0x380b, 0xd0},
+	{0x380c, 0x0e},
+	{0x380d, 0xec},
+	{0x380e, 0x04},
+	{0x380f, 0xe8},
+	{0x3810, 0x00},
+	{0x3811, 0x00},
+	{0x3812, 0x00},
+	{0x3813, 0x00},
+	{0x3814, 0x03},
+	{0x3815, 0x01},
+	{0x3816, 0x00},
+	{0x3817, 0x00},
+	{0x3818, 0x00},
+	{0x3819, 0x10},
+	{0x3820, 0x90},
+	{0x3821, 0x67},
+	{0x382a, 0x03},
+	{0x382b, 0x01},
+	{0x3830, 0x06},
+	{0x3836, 0x02},
+	{0x3862, 0x04},
+	{0x3863, 0x08},
+	{0x3cc0, 0x33},
+	{0x3d85, 0x17},
+	{0x3d8c, 0x73},
+	{0x3d8d, 0xde},
+	{0x4001, 0xe0},
+	{0x4003, 0x40},
+	{0x4008, 0x00},
+	{0x4009, 0x05},
+	{0x400a, 0x00},
+	{0x400b, 0x84},
+	{0x400f, 0x80},
+	{0x4010, 0xf0},
+	{0x4011, 0xff},
+	{0x4012, 0x02},
+	{0x4013, 0x01},
+	{0x4014, 0x01},
+	{0x4015, 0x01},
+	{0x4042, 0x00},
+	{0x4043, 0x80},
+	{0x4044, 0x00},
+	{0x4045, 0x80},
+	{0x4046, 0x00},
+	{0x4047, 0x80},
+	{0x4048, 0x00},
+	{0x4049, 0x80},
+	{0x4041, 0x03},
+	{0x404c, 0x20},
+	{0x404d, 0x00},
+	{0x404e, 0x20},
+	{0x4203, 0x80},
+	{0x4307, 0x30},
+	{0x4317, 0x00},
+	{0x4503, 0x08},
+	{0x4601, 0x80},
+	{0x4800, 0x44},
+	{0x4816, 0x53},
+	{0x481b, 0x58},
+	{0x481f, 0x27},
+	{0x4837, 0x16},
+	{0x483c, 0x0f},
+	{0x484b, 0x05},
+	{0x5000, 0x57},
+	{0x5001, 0x0a},
+	{0x5004, 0x04},
+	{0x502e, 0x03},
+	{0x5030, 0x41},
+	{0x5780, 0x14},
+	{0x5781, 0x0f},
+	{0x5782, 0x44},
+	{0x5783, 0x02},
+	{0x5784, 0x01},
+	{0x5785, 0x01},
+	{0x5786, 0x00},
+	{0x5787, 0x04},
+	{0x5788, 0x02},
+	{0x5789, 0x0f},
+	{0x578a, 0xfd},
+	{0x578b, 0xf5},
+	{0x578c, 0xf5},
+	{0x578d, 0x03},
+	{0x578e, 0x08},
+	{0x578f, 0x0c},
+	{0x5790, 0x08},
+	{0x5791, 0x04},
+	{0x5792, 0x00},
+	{0x5793, 0x52},
+	{0x5794, 0xa3},
+	{0x5795, 0x00},
+	{0x5796, 0x10},
+	{0x5797, 0x10},
+	{0x5798, 0x73},
+	{0x5799, 0x73},
+	{0x579a, 0x00},
+	{0x579b, 0x28},
+	{0x579c, 0x00},
+	{0x579d, 0x16},
+	{0x579e, 0x06},
+	{0x579f, 0x20},
+	{0x57a0, 0x04},
+	{0x57a1, 0xa0},
+	{0x59f8, 0x3d},
+	{0x5a08, 0x02},
+	{0x5b00, 0x02},
+	{0x5b01, 0x10},
+	{0x5b02, 0x03},
+	{0x5b03, 0xcf},
+	{0x5b05, 0x6c},
+	{0x5e00, 0x00}
+};
+
+static const char * const ov8856_test_pattern_menu[] = {
+	"Disabled",
+	"Standard Color Bar",
+	"Top-Bottom Darker Color Bar",
+	"Right-Left Darker Color Bar",
+	"Bottom-Top Darker Color Bar"
+};
+
+static const s64 link_freq_menu_items[] = {
+	OV8856_LINK_FREQ_360MHZ,
+	OV8856_LINK_FREQ_180MHZ
+};
+
+static const struct ov8856_link_freq_config link_freq_configs[] = {
+	[OV8856_LINK_FREQ_720MBPS] = {
+		.reg_list = {
+			.num_of_regs = ARRAY_SIZE(mipi_data_rate_720mbps),
+			.regs = mipi_data_rate_720mbps,
+		}
+	},
+	[OV8856_LINK_FREQ_360MBPS] = {
+		.reg_list = {
+			.num_of_regs = ARRAY_SIZE(mipi_data_rate_360mbps),
+			.regs = mipi_data_rate_360mbps,
+		}
+	}
+};
+
+static const struct ov8856_mode supported_modes[] = {
+	{
+		.width = 3280,
+		.height = 2464,
+		.hts = 1928,
+		.vts_def = 2488,
+		.vts_min = 2488,
+		.reg_list = {
+			.num_of_regs = ARRAY_SIZE(mode_3280x2464_regs),
+			.regs = mode_3280x2464_regs,
+		},
+		.link_freq_index = OV8856_LINK_FREQ_720MBPS,
+	},
+	{
+		.width = 1640,
+		.height = 1232,
+		.hts = 3820,
+		.vts_def = 1256,
+		.vts_min = 1256,
+		.reg_list = {
+			.num_of_regs = ARRAY_SIZE(mode_1640x1232_regs),
+			.regs = mode_1640x1232_regs,
+		},
+		.link_freq_index = OV8856_LINK_FREQ_360MBPS,
+	}
+};
+
+struct ov8856 {
+	struct v4l2_subdev sd;
+	struct media_pad pad;
+	struct v4l2_ctrl_handler ctrl_handler;
+
+	/* V4L2 Controls */
+	struct v4l2_ctrl *link_freq;
+	struct v4l2_ctrl *pixel_rate;
+	struct v4l2_ctrl *vblank;
+	struct v4l2_ctrl *hblank;
+	struct v4l2_ctrl *exposure;
+
+	/* Current mode */
+	const struct ov8856_mode *cur_mode;
+
+	/* To serialize asynchronus callbacks */
+	struct mutex mutex;
+
+	/* Streaming on/off */
+	bool streaming;
+};
+
+static u64 to_pixel_rate(u32 f_index)
+{
+	u64 pixel_rate = link_freq_menu_items[f_index] * 2 * OV8856_DATA_LANES;
+
+	do_div(pixel_rate, OV8856_RGB_DEPTH);
+
+	return pixel_rate;
+}
+
+static u64 to_pixels_per_line(u32 hts, u32 f_index)
+{
+	u64 ppl = hts * to_pixel_rate(f_index);
+
+	do_div(ppl, OV8856_SCLK);
+
+	return ppl;
+}
+
+static int ov8856_read_reg(struct ov8856 *ov8856, u16 reg, u16 len, u32 *val)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&ov8856->sd);
+	struct i2c_msg msgs[2];
+	u8 addr_buf[2] = {reg >> 8, reg & 0xff};
+	u8 data_buf[4] = {0, };
+	int ret;
+
+	if (len > 4)
+		return -EINVAL;
+
+	msgs[0].addr = client->addr;
+	msgs[0].flags = 0;
+	msgs[0].len = ARRAY_SIZE(addr_buf);
+	msgs[0].buf = addr_buf;
+	msgs[1].addr = client->addr;
+	msgs[1].flags = I2C_M_RD;
+	msgs[1].len = len;
+	msgs[1].buf = &data_buf[4 - len];
+
+	ret = i2c_transfer(client->adapter, msgs, ARRAY_SIZE(msgs));
+	if (ret != ARRAY_SIZE(msgs))
+		return -EIO;
+
+	*val = get_unaligned_be32(data_buf);
+
+	return 0;
+}
+
+static int ov8856_write_reg(struct ov8856 *ov8856, u16 reg, u16 len, u32 val)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&ov8856->sd);
+	u8 buf[6];
+
+	if (len > 4)
+		return -EINVAL;
+
+	put_unaligned_be16(reg, buf);
+	put_unaligned_be32(val << 8 * (4 - len), buf + 2);
+	if (i2c_master_send(client, buf, len + 2) != len + 2)
+		return -EIO;
+
+	return 0;
+}
+
+static int ov8856_write_reg_list(struct ov8856 *ov8856,
+				 const struct ov8856_reg_list *r_list)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&ov8856->sd);
+	unsigned int i;
+	int ret;
+
+	for (i = 0; i < r_list->num_of_regs; i++) {
+		ret = ov8856_write_reg(ov8856, r_list->regs[i].address, 1,
+				       r_list->regs[i].val);
+		if (ret) {
+			dev_err_ratelimited(&client->dev,
+				    "failed to write reg 0x%4.4x. error = %d",
+				    r_list->regs[i].address, ret);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int ov8856_update_digital_gain(struct ov8856 *ov8856, u32 d_gain)
+{
+	int ret;
+
+	ret = ov8856_write_reg(ov8856, OV8856_REG_MWB_R_GAIN,
+			       OV8856_REG_VALUE_16BIT, d_gain);
+	if (ret)
+		return ret;
+
+	ret = ov8856_write_reg(ov8856, OV8856_REG_MWB_G_GAIN,
+			       OV8856_REG_VALUE_16BIT, d_gain);
+	if (ret)
+		return ret;
+
+	return ov8856_write_reg(ov8856, OV8856_REG_MWB_B_GAIN,
+				OV8856_REG_VALUE_16BIT, d_gain);
+}
+
+static int ov8856_test_pattern(struct ov8856 *ov8856, u32 pattern)
+{
+	if (pattern)
+		pattern = (pattern - 1) << OV8856_TEST_PATTERN_BAR_SHIFT |
+			  OV8856_TEST_PATTERN_ENABLE;
+
+	return ov8856_write_reg(ov8856, OV8856_REG_TEST_PATTERN,
+				OV8856_REG_VALUE_08BIT, pattern);
+}
+
+static int ov8856_set_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct ov8856 *ov8856 = container_of(ctrl->handler,
+					     struct ov8856, ctrl_handler);
+	struct i2c_client *client = v4l2_get_subdevdata(&ov8856->sd);
+	s64 exposure_max;
+	int ret = 0;
+
+	/* Propagate change of current control to all related controls */
+	if (ctrl->id == V4L2_CID_VBLANK) {
+		/* Update max exposure while meeting expected vblanking */
+		exposure_max = ov8856->cur_mode->height + ctrl->val -
+			       OV8856_EXPOSURE_MAX_MARGIN;
+		__v4l2_ctrl_modify_range(ov8856->exposure,
+					 ov8856->exposure->minimum,
+					 exposure_max, ov8856->exposure->step,
+					 exposure_max);
+	}
+
+	/* V4L2 controls values will be applied only when power is already up */
+	if (!pm_runtime_get_if_in_use(&client->dev))
+		return 0;
+
+	switch (ctrl->id) {
+	case V4L2_CID_ANALOGUE_GAIN:
+		ret = ov8856_write_reg(ov8856, OV8856_REG_ANALOG_GAIN,
+				       OV8856_REG_VALUE_16BIT, ctrl->val);
+		break;
+
+	case V4L2_CID_DIGITAL_GAIN:
+		ret = ov8856_update_digital_gain(ov8856, ctrl->val);
+		break;
+
+	case V4L2_CID_EXPOSURE:
+		/* 4 least significant bits of expsoure are fractional part */
+		ret = ov8856_write_reg(ov8856, OV8856_REG_EXPOSURE,
+				       OV8856_REG_VALUE_24BIT, ctrl->val << 4);
+		break;
+
+	case V4L2_CID_VBLANK:
+		ret = ov8856_write_reg(ov8856, OV8856_REG_VTS,
+				       OV8856_REG_VALUE_16BIT,
+				       ov8856->cur_mode->height + ctrl->val);
+		break;
+
+	case V4L2_CID_TEST_PATTERN:
+		ret = ov8856_test_pattern(ov8856, ctrl->val);
+		break;
+
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	pm_runtime_put(&client->dev);
+
+	return ret;
+}
+
+static const struct v4l2_ctrl_ops ov8856_ctrl_ops = {
+	.s_ctrl = ov8856_set_ctrl,
+};
+
+static int ov8856_init_controls(struct ov8856 *ov8856)
+{
+	struct v4l2_ctrl_handler *ctrl_hdlr;
+	s64 exposure_max, h_blank;
+	int ret;
+
+	ctrl_hdlr = &ov8856->ctrl_handler;
+	ret = v4l2_ctrl_handler_init(ctrl_hdlr, 8);
+	if (ret)
+		return ret;
+
+	ctrl_hdlr->lock = &ov8856->mutex;
+	ov8856->link_freq = v4l2_ctrl_new_int_menu(ctrl_hdlr, &ov8856_ctrl_ops,
+					   V4L2_CID_LINK_FREQ,
+					   ARRAY_SIZE(link_freq_menu_items) - 1,
+					   0, link_freq_menu_items);
+	if (ov8856->link_freq)
+		ov8856->link_freq->flags |= V4L2_CTRL_FLAG_READ_ONLY;
+
+	ov8856->pixel_rate = v4l2_ctrl_new_std(ctrl_hdlr, &ov8856_ctrl_ops,
+				       V4L2_CID_PIXEL_RATE, 0,
+				       to_pixel_rate(OV8856_LINK_FREQ_720MBPS),
+				       1,
+				       to_pixel_rate(OV8856_LINK_FREQ_720MBPS));
+	ov8856->vblank = v4l2_ctrl_new_std(ctrl_hdlr, &ov8856_ctrl_ops,
+			  V4L2_CID_VBLANK,
+			  ov8856->cur_mode->vts_min - ov8856->cur_mode->height,
+			  OV8856_VTS_MAX - ov8856->cur_mode->height, 1,
+			  ov8856->cur_mode->vts_def - ov8856->cur_mode->height);
+	h_blank = to_pixels_per_line(ov8856->cur_mode->hts,
+		  ov8856->cur_mode->link_freq_index) - ov8856->cur_mode->width;
+	ov8856->hblank = v4l2_ctrl_new_std(ctrl_hdlr, &ov8856_ctrl_ops,
+					   V4L2_CID_HBLANK, h_blank, h_blank, 1,
+					   h_blank);
+	if (ov8856->hblank)
+		ov8856->hblank->flags |= V4L2_CTRL_FLAG_READ_ONLY;
+
+	v4l2_ctrl_new_std(ctrl_hdlr, &ov8856_ctrl_ops, V4L2_CID_ANALOGUE_GAIN,
+			  OV8856_ANAL_GAIN_MIN, OV8856_ANAL_GAIN_MAX,
+			  OV8856_ANAL_GAIN_STEP, OV8856_ANAL_GAIN_MIN);
+	v4l2_ctrl_new_std(ctrl_hdlr, &ov8856_ctrl_ops, V4L2_CID_DIGITAL_GAIN,
+			  OV8856_DGTL_GAIN_MIN, OV8856_DGTL_GAIN_MAX,
+			  OV8856_DGTL_GAIN_STEP, OV8856_DGTL_GAIN_DEFAULT);
+	exposure_max = ov8856->cur_mode->vts_def - OV8856_EXPOSURE_MAX_MARGIN;
+	ov8856->exposure = v4l2_ctrl_new_std(ctrl_hdlr, &ov8856_ctrl_ops,
+					     V4L2_CID_EXPOSURE,
+					     OV8856_EXPOSURE_MIN, exposure_max,
+					     OV8856_EXPOSURE_STEP,
+					     exposure_max);
+	v4l2_ctrl_new_std_menu_items(ctrl_hdlr, &ov8856_ctrl_ops,
+				     V4L2_CID_TEST_PATTERN,
+				     ARRAY_SIZE(ov8856_test_pattern_menu) - 1,
+				     0, 0, ov8856_test_pattern_menu);
+	if (ctrl_hdlr->error)
+		return ctrl_hdlr->error;
+
+	ov8856->sd.ctrl_handler = ctrl_hdlr;
+
+	return 0;
+}
+
+static void ov8856_update_pad_format(const struct ov8856_mode *mode,
+				     struct v4l2_mbus_framefmt *fmt)
+{
+	fmt->width = mode->width;
+	fmt->height = mode->height;
+	fmt->code = MEDIA_BUS_FMT_SGRBG10_1X10;
+	fmt->field = V4L2_FIELD_NONE;
+}
+
+static int ov8856_start_streaming(struct ov8856 *ov8856)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&ov8856->sd);
+	const struct ov8856_reg_list *reg_list;
+	int link_freq_index, ret;
+
+	link_freq_index = ov8856->cur_mode->link_freq_index;
+	reg_list = &link_freq_configs[link_freq_index].reg_list;
+	ret = ov8856_write_reg_list(ov8856, reg_list);
+	if (ret) {
+		dev_err(&client->dev, "failed to set plls");
+		return ret;
+	}
+
+	reg_list = &ov8856->cur_mode->reg_list;
+	ret = ov8856_write_reg_list(ov8856, reg_list);
+	if (ret) {
+		dev_err(&client->dev, "failed to set mode");
+		return ret;
+	}
+
+	ret = __v4l2_ctrl_handler_setup(ov8856->sd.ctrl_handler);
+	if (ret)
+		return ret;
+
+	ret = ov8856_write_reg(ov8856, OV8856_REG_MODE_SELECT,
+			       OV8856_REG_VALUE_08BIT, OV8856_MODE_STREAMING);
+	if (ret) {
+		dev_err(&client->dev, "failed to set stream");
+		return ret;
+	}
+
+	return 0;
+}
+
+static void ov8856_stop_streaming(struct ov8856 *ov8856)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&ov8856->sd);
+
+	if (ov8856_write_reg(ov8856, OV8856_REG_MODE_SELECT,
+			     OV8856_REG_VALUE_08BIT, OV8856_MODE_STANDBY))
+		dev_err(&client->dev, "failed to set stream");
+}
+
+static int ov8856_set_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct ov8856 *ov8856 = to_ov8856(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	int ret = 0;
+
+	if (ov8856->streaming == enable)
+		return 0;
+
+	mutex_lock(&ov8856->mutex);
+	if (enable) {
+		ret = pm_runtime_get_sync(&client->dev);
+		if (ret < 0) {
+			pm_runtime_put_noidle(&client->dev);
+			mutex_unlock(&ov8856->mutex);
+			return ret;
+		}
+
+		ret = ov8856_start_streaming(ov8856);
+		if (ret) {
+			enable = 0;
+			ov8856_stop_streaming(ov8856);
+			pm_runtime_put(&client->dev);
+		}
+	} else {
+		ov8856_stop_streaming(ov8856);
+		pm_runtime_put(&client->dev);
+	}
+
+	ov8856->streaming = enable;
+	mutex_unlock(&ov8856->mutex);
+
+	return ret;
+}
+
+static int __maybe_unused ov8856_suspend(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct ov8856 *ov8856 = to_ov8856(sd);
+
+	mutex_lock(&ov8856->mutex);
+	if (ov8856->streaming)
+		ov8856_stop_streaming(ov8856);
+
+	mutex_unlock(&ov8856->mutex);
+
+	return 0;
+}
+
+static int __maybe_unused ov8856_resume(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct ov8856 *ov8856 = to_ov8856(sd);
+	int ret;
+
+	mutex_lock(&ov8856->mutex);
+	if (ov8856->streaming) {
+		ret = ov8856_start_streaming(ov8856);
+		if (ret) {
+			ov8856->streaming = false;
+			ov8856_stop_streaming(ov8856);
+			mutex_unlock(&ov8856->mutex);
+			return ret;
+		}
+	}
+
+	mutex_unlock(&ov8856->mutex);
+
+	return 0;
+}
+
+static int ov8856_set_format(struct v4l2_subdev *sd,
+			     struct v4l2_subdev_pad_config *cfg,
+			     struct v4l2_subdev_format *fmt)
+{
+	struct ov8856 *ov8856 = to_ov8856(sd);
+	const struct ov8856_mode *mode;
+	s32 vblank_def, h_blank;
+
+	mode = v4l2_find_nearest_size(supported_modes,
+				      ARRAY_SIZE(supported_modes), width,
+				      height, fmt->format.width,
+				      fmt->format.height);
+
+	mutex_lock(&ov8856->mutex);
+	ov8856_update_pad_format(mode, &fmt->format);
+	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
+		*v4l2_subdev_get_try_format(sd, cfg, fmt->pad) = fmt->format;
+	} else {
+		ov8856->cur_mode = mode;
+		__v4l2_ctrl_s_ctrl(ov8856->link_freq, mode->link_freq_index);
+		__v4l2_ctrl_s_ctrl_int64(ov8856->pixel_rate,
+					 to_pixel_rate(mode->link_freq_index));
+
+		/* Update limits and set FPS to default */
+		vblank_def = mode->vts_def - mode->height;
+		__v4l2_ctrl_modify_range(ov8856->vblank,
+					 mode->vts_min - mode->height,
+					 OV8856_VTS_MAX - mode->height, 1,
+					 vblank_def);
+		__v4l2_ctrl_s_ctrl(ov8856->vblank, vblank_def);
+		h_blank = to_pixels_per_line(mode->hts, mode->link_freq_index) -
+			  mode->width;
+		__v4l2_ctrl_modify_range(ov8856->hblank, h_blank, h_blank, 1,
+					 h_blank);
+	}
+
+	mutex_unlock(&ov8856->mutex);
+
+	return 0;
+}
+
+static int ov8856_get_format(struct v4l2_subdev *sd,
+			     struct v4l2_subdev_pad_config *cfg,
+			     struct v4l2_subdev_format *fmt)
+{
+	struct ov8856 *ov8856 = to_ov8856(sd);
+
+	mutex_lock(&ov8856->mutex);
+	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY)
+		fmt->format = *v4l2_subdev_get_try_format(&ov8856->sd, cfg,
+							  fmt->pad);
+	else
+		ov8856_update_pad_format(ov8856->cur_mode, &fmt->format);
+
+	mutex_unlock(&ov8856->mutex);
+
+	return 0;
+}
+
+static int ov8856_enum_mbus_code(struct v4l2_subdev *sd,
+				 struct v4l2_subdev_pad_config *cfg,
+				 struct v4l2_subdev_mbus_code_enum *code)
+{
+	/* Only one bayer order GRBG is supported */
+	if (code->index > 0)
+		return -EINVAL;
+
+	code->code = MEDIA_BUS_FMT_SGRBG10_1X10;
+
+	return 0;
+}
+
+static int ov8856_enum_frame_size(struct v4l2_subdev *sd,
+				  struct v4l2_subdev_pad_config *cfg,
+				  struct v4l2_subdev_frame_size_enum *fse)
+{
+	if (fse->index >= ARRAY_SIZE(supported_modes))
+		return -EINVAL;
+
+	if (fse->code != MEDIA_BUS_FMT_SGRBG10_1X10)
+		return -EINVAL;
+
+	fse->min_width = supported_modes[fse->index].width;
+	fse->max_width = fse->min_width;
+	fse->min_height = supported_modes[fse->index].height;
+	fse->max_height = fse->min_height;
+
+	return 0;
+}
+
+static int ov8856_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	struct ov8856 *ov8856 = to_ov8856(sd);
+
+	mutex_lock(&ov8856->mutex);
+	ov8856_update_pad_format(&supported_modes[0],
+				 v4l2_subdev_get_try_format(sd, fh->pad, 0));
+	mutex_unlock(&ov8856->mutex);
+
+	return 0;
+}
+
+static const struct v4l2_subdev_video_ops ov8856_video_ops = {
+	.s_stream = ov8856_set_stream,
+};
+
+static const struct v4l2_subdev_pad_ops ov8856_pad_ops = {
+	.set_fmt = ov8856_set_format,
+	.get_fmt = ov8856_get_format,
+	.enum_mbus_code = ov8856_enum_mbus_code,
+	.enum_frame_size = ov8856_enum_frame_size,
+};
+
+static const struct v4l2_subdev_ops ov8856_subdev_ops = {
+	.video = &ov8856_video_ops,
+	.pad = &ov8856_pad_ops,
+};
+
+static const struct media_entity_operations ov8856_subdev_entity_ops = {
+	.link_validate = v4l2_subdev_link_validate,
+};
+
+static const struct v4l2_subdev_internal_ops ov8856_internal_ops = {
+	.open = ov8856_open,
+};
+
+static int ov8856_identify_module(struct ov8856 *ov8856)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&ov8856->sd);
+	int ret;
+	u32 val;
+
+	ret = ov8856_read_reg(ov8856, OV8856_REG_CHIP_ID,
+			      OV8856_REG_VALUE_24BIT, &val);
+	if (ret)
+		return ret;
+
+	if (val != OV8856_CHIP_ID) {
+		dev_err(&client->dev, "chip id mismatch: %x!=%x",
+			OV8856_CHIP_ID, val);
+		return -ENXIO;
+	}
+
+	return 0;
+}
+
+static int ov8856_check_hwcfg(struct device *dev)
+{
+	struct fwnode_handle *ep;
+	struct fwnode_handle *fwnode = dev_fwnode(dev);
+	struct v4l2_fwnode_endpoint bus_cfg = {
+		.bus_type = V4L2_MBUS_CSI2_DPHY
+	};
+	u32 mclk;
+	int ret;
+	unsigned int i, j;
+
+	if (!fwnode)
+		return -ENXIO;
+
+	fwnode_property_read_u32(fwnode, "clock-frequency", &mclk);
+	if (mclk != OV8856_MCLK) {
+		dev_err(dev, "external clock %d is not supported", mclk);
+		return -EINVAL;
+	}
+
+	ep = fwnode_graph_get_next_endpoint(fwnode, NULL);
+	if (!ep)
+		return -ENXIO;
+
+	ret = v4l2_fwnode_endpoint_alloc_parse(ep, &bus_cfg);
+	fwnode_handle_put(ep);
+	if (ret)
+		return ret;
+
+	if (bus_cfg.bus.mipi_csi2.num_data_lanes != OV8856_DATA_LANES) {
+		dev_err(dev, "number of CSI2 data lanes %d is not supported",
+			bus_cfg.bus.mipi_csi2.num_data_lanes);
+		ret = -EINVAL;
+		goto check_hwcfg_error;
+	}
+
+	if (!bus_cfg.nr_of_link_frequencies) {
+		dev_err(dev, "no link frequencies defined");
+		ret = -EINVAL;
+		goto check_hwcfg_error;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(link_freq_menu_items); i++) {
+		for (j = 0; j < bus_cfg.nr_of_link_frequencies; j++) {
+			if (link_freq_menu_items[i] ==
+				bus_cfg.link_frequencies[j])
+				break;
+		}
+
+		if (j == bus_cfg.nr_of_link_frequencies) {
+			dev_err(dev, "no link frequency %lld supported",
+				link_freq_menu_items[i]);
+			ret = -EINVAL;
+			goto check_hwcfg_error;
+		}
+	}
+
+check_hwcfg_error:
+	v4l2_fwnode_endpoint_free(&bus_cfg);
+
+	return ret;
+}
+
+static int ov8856_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct ov8856 *ov8856 = to_ov8856(sd);
+
+	v4l2_async_unregister_subdev(sd);
+	media_entity_cleanup(&sd->entity);
+	v4l2_ctrl_handler_free(sd->ctrl_handler);
+	pm_runtime_disable(&client->dev);
+	mutex_destroy(&ov8856->mutex);
+
+	return 0;
+}
+
+static int ov8856_probe(struct i2c_client *client)
+{
+	struct ov8856 *ov8856;
+	int ret;
+
+	ret = ov8856_check_hwcfg(&client->dev);
+	if (ret) {
+		dev_err(&client->dev, "failed to check HW configuration: %d",
+			ret);
+		return ret;
+	}
+
+	ov8856 = devm_kzalloc(&client->dev, sizeof(*ov8856), GFP_KERNEL);
+	if (!ov8856)
+		return -ENOMEM;
+
+	v4l2_i2c_subdev_init(&ov8856->sd, client, &ov8856_subdev_ops);
+	ret = ov8856_identify_module(ov8856);
+	if (ret) {
+		dev_err(&client->dev, "failed to find sensor: %d", ret);
+		return ret;
+	}
+
+	mutex_init(&ov8856->mutex);
+	ov8856->cur_mode = &supported_modes[0];
+	ret = ov8856_init_controls(ov8856);
+	if (ret) {
+		dev_err(&client->dev, "failed to init controls: %d", ret);
+		goto probe_error_v4l2_ctrl_handler_free;
+	}
+
+	ov8856->sd.internal_ops = &ov8856_internal_ops;
+	ov8856->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	ov8856->sd.entity.ops = &ov8856_subdev_entity_ops;
+	ov8856->sd.entity.function = MEDIA_ENT_F_CAM_SENSOR;
+	ov8856->pad.flags = MEDIA_PAD_FL_SOURCE;
+	ret = media_entity_pads_init(&ov8856->sd.entity, 1, &ov8856->pad);
+	if (ret) {
+		dev_err(&client->dev, "failed to init entity pads: %d", ret);
+		goto probe_error_v4l2_ctrl_handler_free;
+	}
+
+	ret = v4l2_async_register_subdev_sensor_common(&ov8856->sd);
+	if (ret < 0) {
+		dev_err(&client->dev, "failed to register V4L2 subdev: %d",
+			ret);
+		goto probe_error_media_entity_cleanup;
+	}
+
+	/*
+	 * Device is already turned on by i2c-core with ACPI domain PM.
+	 * Enable runtime PM and turn off the device.
+	 */
+	pm_runtime_set_active(&client->dev);
+	pm_runtime_enable(&client->dev);
+	pm_runtime_idle(&client->dev);
+
+	return 0;
+
+probe_error_media_entity_cleanup:
+	media_entity_cleanup(&ov8856->sd.entity);
+
+probe_error_v4l2_ctrl_handler_free:
+	v4l2_ctrl_handler_free(ov8856->sd.ctrl_handler);
+	mutex_destroy(&ov8856->mutex);
+
+	return ret;
+}
+
+static const struct dev_pm_ops ov8856_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(ov8856_suspend, ov8856_resume)
+};
+
+#ifdef CONFIG_ACPI
+static const struct acpi_device_id ov8856_acpi_ids[] = {
+	{"OVTI8856"},
+	{}
+};
+
+MODULE_DEVICE_TABLE(acpi, ov8856_acpi_ids);
+#endif
+
+static struct i2c_driver ov8856_i2c_driver = {
+	.driver = {
+		.name = "ov8856",
+		.pm = &ov8856_pm_ops,
+		.acpi_match_table = ACPI_PTR(ov8856_acpi_ids),
+	},
+	.probe_new = ov8856_probe,
+	.remove = ov8856_remove,
+};
+
+module_i2c_driver(ov8856_i2c_driver);
+
+MODULE_AUTHOR("Ben Kao <ben.kao@intel.com>");
+MODULE_DESCRIPTION("OmniVision OV8856 sensor driver");
+MODULE_LICENSE("GPL v2");
-- 
2.7.4

