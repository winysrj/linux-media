Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:59862 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754327AbeDTJt4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 05:49:56 -0400
From: Daniel Mack <daniel@zonque.org>
To: linux-media@vger.kernel.org
Cc: slongerbeam@gmail.com, mchehab@kernel.org,
        Daniel Mack <daniel@zonque.org>
Subject: [PATCH 2/3] media: ov5640: add PIXEL_RATE and LINK_FREQ controls
Date: Fri, 20 Apr 2018 11:44:18 +0200
Message-Id: <20180420094419.11267-2-daniel@zonque.org>
In-Reply-To: <20180420094419.11267-1-daniel@zonque.org>
References: <20180420094419.11267-1-daniel@zonque.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add v4l2 controls to report the pixel and MIPI link rates of each mode.
The camss camera subsystem needs them to set up the correct hardware
clocks.

Tested on msm8016 based hardware.

Signed-off-by: Daniel Mack <daniel@zonque.org>
---
 drivers/media/i2c/ov5640.c | 77 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 96f1564abdf5..78669ed386cd 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -91,6 +91,20 @@
 #define OV5640_REG_SDE_CTRL5		0x5585
 #define OV5640_REG_AVG_READOUT		0x56a1
 
+#define OV5640_LINK_FREQ_111	0
+#define OV5640_LINK_FREQ_166	1
+#define OV5640_LINK_FREQ_222	2
+#define OV5640_LINK_FREQ_333	3
+#define OV5640_LINK_FREQ_666	4
+
+static const s64 link_freq_menu_items[] = {
+	111066666,
+	166600000,
+	222133333,
+	332200000,
+	666400000,
+};
+
 enum ov5640_mode_id {
 	OV5640_MODE_QCIF_176_144 = 0,
 	OV5640_MODE_QVGA_320_240,
@@ -167,12 +181,18 @@ struct ov5640_mode_info {
 	enum ov5640_downsize_mode dn_mode;
 	u32 width;
 	u32 height;
+	u32 pixel_rate;
+	u32 link_freq_idx;
 	const struct reg_value *reg_data;
 	u32 reg_data_size;
 };
 
 struct ov5640_ctrls {
 	struct v4l2_ctrl_handler handler;
+	struct {
+		struct v4l2_ctrl *link_freq;
+		struct v4l2_ctrl *pixel_rate;
+	};
 	struct {
 		struct v4l2_ctrl *auto_exp;
 		struct v4l2_ctrl *exposure;
@@ -732,6 +752,8 @@ static const struct ov5640_mode_info ov5640_mode_init_data = {
 	.dn_mode	= SUBSAMPLING,
 	.width		= 640,
 	.height		= 480,
+	.pixel_rate	= 27766666,
+	.link_freq_idx	= OV5640_LINK_FREQ_111,
 	.reg_data	= ov5640_init_setting_30fps_VGA,
 	.reg_data_size	= ARRAY_SIZE(ov5640_init_setting_30fps_VGA),
 };
@@ -744,6 +766,8 @@ ov5640_mode_data[OV5640_NUM_FRAMERATES][OV5640_NUM_MODES] = {
 		.dn_mode	= SUBSAMPLING,
 		.width		= 176,
 		.height		= 144,
+		.pixel_rate	= 27766666,
+		.link_freq_idx	= OV5640_LINK_FREQ_111,
 		.reg_data	= ov5640_setting_15fps_QCIF_176_144,
 		.reg_data_size	= ARRAY_SIZE(ov5640_setting_15fps_QCIF_176_144),
 	},
@@ -752,6 +776,8 @@ ov5640_mode_data[OV5640_NUM_FRAMERATES][OV5640_NUM_MODES] = {
 		.dn_mode	= SUBSAMPLING,
 		.width		= 320,
 		.height		= 240,
+		.pixel_rate	= 27766666,
+		.link_freq_idx	= OV5640_LINK_FREQ_111,
 		.reg_data	= ov5640_setting_15fps_QVGA_320_240,
 		.reg_data_size	= ARRAY_SIZE(ov5640_setting_15fps_QVGA_320_240),
 	},
@@ -760,6 +786,8 @@ ov5640_mode_data[OV5640_NUM_FRAMERATES][OV5640_NUM_MODES] = {
 		.dn_mode	= SUBSAMPLING,
 		.width		= 640,
 		.height		= 480,
+		.pixel_rate	= 27766666,
+		.link_freq_idx	= OV5640_LINK_FREQ_111,
 		.reg_data	= ov5640_setting_15fps_VGA_640_480,
 		.reg_data_size	= ARRAY_SIZE(ov5640_setting_15fps_VGA_640_480)
 	},
@@ -768,6 +796,8 @@ ov5640_mode_data[OV5640_NUM_FRAMERATES][OV5640_NUM_MODES] = {
 		.dn_mode	= SUBSAMPLING,
 		.width		= 720,
 		.height		= 480,
+		.pixel_rate	= 27766666,
+		.link_freq_idx	= OV5640_LINK_FREQ_111,
 		.reg_data	= ov5640_setting_15fps_NTSC_720_480,
 		.reg_data_size	= ARRAY_SIZE(ov5640_setting_15fps_NTSC_720_480),
 	},
@@ -776,6 +806,8 @@ ov5640_mode_data[OV5640_NUM_FRAMERATES][OV5640_NUM_MODES] = {
 		.dn_mode	= SUBSAMPLING,
 		.width		= 720,
 		.height		= 576,
+		.pixel_rate	= 27766666,
+		.link_freq_idx	= OV5640_LINK_FREQ_111,
 		.reg_data	= ov5640_setting_15fps_PAL_720_576,
 		.reg_data_size	= ARRAY_SIZE(ov5640_setting_15fps_PAL_720_576),
 	},
@@ -784,6 +816,8 @@ ov5640_mode_data[OV5640_NUM_FRAMERATES][OV5640_NUM_MODES] = {
 		.dn_mode	= SUBSAMPLING,
 		.width		= 1024,
 		.height		= 768,
+		.pixel_rate	= 27766666,
+		.link_freq_idx	= OV5640_LINK_FREQ_111,
 		.reg_data	= ov5640_setting_15fps_XGA_1024_768,
 		.reg_data_size	= ARRAY_SIZE(ov5640_setting_15fps_XGA_1024_768),
 	},
@@ -792,6 +826,8 @@ ov5640_mode_data[OV5640_NUM_FRAMERATES][OV5640_NUM_MODES] = {
 		.dn_mode	= SUBSAMPLING,
 		.width		= 1280,
 		.height		= 720,
+		.pixel_rate	= 41650000,
+		.link_freq_idx	= OV5640_LINK_FREQ_166,
 		.reg_data	= ov5640_setting_15fps_720P_1280_720,
 		.reg_data_size	= ARRAY_SIZE(ov5640_setting_15fps_720P_1280_720),
 	},
@@ -800,6 +836,8 @@ ov5640_mode_data[OV5640_NUM_FRAMERATES][OV5640_NUM_MODES] = {
 		.dn_mode	= SCALING,
 		.width		= 1920,
 		.height		= 1080,
+		.pixel_rate	= 83300000,
+		.link_freq_idx	= OV5640_LINK_FREQ_333,
 		.reg_data	= ov5640_setting_15fps_1080P_1920_1080,
 		.reg_data_size	= ARRAY_SIZE(ov5640_setting_15fps_1080P_1920_1080),
 	},
@@ -808,6 +846,8 @@ ov5640_mode_data[OV5640_NUM_FRAMERATES][OV5640_NUM_MODES] = {
 		.dn_mode	= SCALING,
 		.width		= 2592,
 		.height		= 1944,
+		.pixel_rate	= 83300000,
+		.link_freq_idx	= OV5640_LINK_FREQ_333,
 		.reg_data	= ov5640_setting_15fps_QSXGA_2592_1944,
 		.reg_data_size	= ARRAY_SIZE(ov5640_setting_15fps_QSXGA_2592_1944),
 	},
@@ -818,6 +858,8 @@ ov5640_mode_data[OV5640_NUM_FRAMERATES][OV5640_NUM_MODES] = {
 		.dn_mode	= SUBSAMPLING,
 		.width		= 176,
 		.height		= 144,
+		.pixel_rate	= 27766666,
+		.link_freq_idx	= OV5640_LINK_FREQ_111,
 		.reg_data	= ov5640_setting_30fps_QCIF_176_144,
 		.reg_data_size	= ARRAY_SIZE(ov5640_setting_30fps_QCIF_176_144),
 	},
@@ -826,6 +868,8 @@ ov5640_mode_data[OV5640_NUM_FRAMERATES][OV5640_NUM_MODES] = {
 		.dn_mode	= SUBSAMPLING,
 		.width		= 320,
 		.height		= 240,
+		.pixel_rate	= 27766666,
+		.link_freq_idx	= OV5640_LINK_FREQ_111,
 		.reg_data	= ov5640_setting_30fps_QVGA_320_240,
 		.reg_data_size	= ARRAY_SIZE(ov5640_setting_30fps_QVGA_320_240),
 	},
@@ -834,6 +878,8 @@ ov5640_mode_data[OV5640_NUM_FRAMERATES][OV5640_NUM_MODES] = {
 		.dn_mode	= SUBSAMPLING,
 		.width		= 640,
 		.height		= 480,
+		.pixel_rate	= 27766666,
+		.link_freq_idx	= OV5640_LINK_FREQ_111,
 		.reg_data	= ov5640_setting_30fps_VGA_640_480,
 		.reg_data_size	= ARRAY_SIZE(ov5640_setting_30fps_VGA_640_480),
 	},
@@ -842,6 +888,8 @@ ov5640_mode_data[OV5640_NUM_FRAMERATES][OV5640_NUM_MODES] = {
 		.dn_mode	= SUBSAMPLING,
 		.width		= 720,
 		.height		= 480,
+		.pixel_rate	= 55533333,
+		.link_freq_idx	= OV5640_LINK_FREQ_222,
 		.reg_data	= ov5640_setting_30fps_NTSC_720_480,
 		.reg_data_size	= ARRAY_SIZE(ov5640_setting_30fps_NTSC_720_480),
 	},
@@ -850,6 +898,8 @@ ov5640_mode_data[OV5640_NUM_FRAMERATES][OV5640_NUM_MODES] = {
 		.dn_mode	= SUBSAMPLING,
 		.width		= 720,
 		.height		= 576,
+		.pixel_rate	= 55533333,
+		.link_freq_idx	= OV5640_LINK_FREQ_222,
 		.reg_data	= ov5640_setting_30fps_PAL_720_576,
 		.reg_data_size	= ARRAY_SIZE(ov5640_setting_30fps_PAL_720_576),
 	},
@@ -858,6 +908,8 @@ ov5640_mode_data[OV5640_NUM_FRAMERATES][OV5640_NUM_MODES] = {
 		.dn_mode	= SUBSAMPLING,
 		.width		= 1024,
 		.height		= 768,
+		.pixel_rate	= 55533333,
+		.link_freq_idx	= OV5640_LINK_FREQ_222,
 		.reg_data	= ov5640_setting_30fps_XGA_1024_768,
 		.reg_data_size	= ARRAY_SIZE(ov5640_setting_30fps_XGA_1024_768),
 	},
@@ -866,6 +918,8 @@ ov5640_mode_data[OV5640_NUM_FRAMERATES][OV5640_NUM_MODES] = {
 		.dn_mode	= SUBSAMPLING,
 		.width		= 1280,
 		.height		= 720,
+		.pixel_rate	= 83300000,
+		.link_freq_idx	= OV5640_LINK_FREQ_333,
 		.reg_data	= ov5640_setting_30fps_720P_1280_720,
 		.reg_data_size	= ARRAY_SIZE(ov5640_setting_30fps_720P_1280_720),
 	},
@@ -874,6 +928,8 @@ ov5640_mode_data[OV5640_NUM_FRAMERATES][OV5640_NUM_MODES] = {
 		.dn_mode	= SCALING,
 		.width		= 1920,
 		.height		= 1080,
+		.pixel_rate	= 166600000,
+		.link_freq_idx	= OV5640_LINK_FREQ_666,
 		.reg_data	= ov5640_setting_30fps_1080P_1920_1080,
 		.reg_data_size	= ARRAY_SIZE(ov5640_setting_30fps_1080P_1920_1080),
 	},
@@ -882,6 +938,8 @@ ov5640_mode_data[OV5640_NUM_FRAMERATES][OV5640_NUM_MODES] = {
 		.dn_mode	= -1,
 		.width		= 0,
 		.height		= 0,
+		.pixel_rate	= 0,
+		.link_freq_idx	= 0,
 		.reg_data	= NULL,
 		.reg_data_size	= 0,
 	}
@@ -2024,6 +2082,11 @@ static int ov5640_set_fmt(struct v4l2_subdev *sd,
 	sensor->current_mode = new_mode;
 	sensor->fmt = *mbus_fmt;
 	sensor->pending_mode_change = true;
+
+	__v4l2_ctrl_s_ctrl(sensor->ctrls.link_freq, new_mode->link_freq_idx);
+	__v4l2_ctrl_s_ctrl_int64(sensor->ctrls.pixel_rate,
+				 new_mode->pixel_rate);
+
 out:
 	mutex_unlock(&sensor->lock);
 	return ret;
@@ -2350,6 +2413,20 @@ static int ov5640_init_controls(struct ov5640_dev *sensor)
 	/* we can use our own mutex for the ctrl lock */
 	hdl->lock = &sensor->lock;
 
+	/* Clock related controls */
+	ctrls->link_freq =
+		v4l2_ctrl_new_int_menu(hdl, ops,
+				       V4L2_CID_LINK_FREQ,
+				       ARRAY_SIZE(link_freq_menu_items) - 1,
+				       0, link_freq_menu_items);
+	ctrls->link_freq->flags |= V4L2_CTRL_FLAG_READ_ONLY;
+
+	ctrls->pixel_rate =
+		v4l2_ctrl_new_std(hdl, ops,
+				  V4L2_CID_PIXEL_RATE, 0, INT_MAX, 1,
+				  ov5640_mode_init_data.pixel_rate);
+	ctrls->pixel_rate->flags |= V4L2_CTRL_FLAG_READ_ONLY;
+
 	/* Auto/manual white balance */
 	ctrls->auto_wb = v4l2_ctrl_new_std(hdl, ops,
 					   V4L2_CID_AUTO_WHITE_BALANCE,
-- 
2.14.3
