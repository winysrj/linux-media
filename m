Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:34064 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1425889AbeCBOfZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Mar 2018 09:35:25 -0500
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH 09/12] media: ov5640: Compute the clock rate at runtime
Date: Fri,  2 Mar 2018 15:34:57 +0100
Message-Id: <20180302143500.32650-10-maxime.ripard@bootlin.com>
In-Reply-To: <20180302143500.32650-1-maxime.ripard@bootlin.com>
References: <20180302143500.32650-1-maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The clock rate, while hardcoded until now, is actually a function of the
resolution, framerate and bytes per pixel. Now that we have an algorithm to
adjust our clock rate, we can select it dynamically when we change the
mode.

This changes a bit the clock rate being used, with the following effect:

+------+------+------+------+-----+-----------------+----------------+-----------+
| Hact | Vact | Htot | Vtot | FPS | Hardcoded clock | Computed clock | Deviation |
+------+------+------+------+-----+-----------------+----------------+-----------+
|  640 |  480 | 1896 | 1080 |  15 |        56000000 |       61430400 | 8.84 %    |
|  640 |  480 | 1896 | 1080 |  30 |       112000000 |      122860800 | 8.84 %    |
| 1024 |  768 | 1896 | 1080 |  15 |        56000000 |       61430400 | 8.84 %    |
| 1024 |  768 | 1896 | 1080 |  30 |       112000000 |      122860800 | 8.84 %    |
|  320 |  240 | 1896 |  984 |  15 |        56000000 |       55969920 | 0.05 %    |
|  320 |  240 | 1896 |  984 |  30 |       112000000 |      111939840 | 0.05 %    |
|  176 |  144 | 1896 |  984 |  15 |        56000000 |       55969920 | 0.05 %    |
|  176 |  144 | 1896 |  984 |  30 |       112000000 |      111939840 | 0.05 %    |
|  720 |  480 | 1896 |  984 |  15 |        56000000 |       55969920 | 0.05 %    |
|  720 |  480 | 1896 |  984 |  30 |       112000000 |      111939840 | 0.05 %    |
|  720 |  576 | 1896 |  984 |  15 |        56000000 |       55969920 | 0.05 %    |
|  720 |  576 | 1896 |  984 |  30 |       112000000 |      111939840 | 0.05 %    |
| 1280 |  720 | 1892 |  740 |  15 |        42000000 |       42002400 | 0.01 %    |
| 1280 |  720 | 1892 |  740 |  30 |        84000000 |       84004800 | 0.01 %    |
| 1920 | 1080 | 2500 | 1120 |  15 |        84000000 |       84000000 | 0.00 %    |
| 1920 | 1080 | 2500 | 1120 |  30 |       168000000 |      168000000 | 0.00 %    |
| 2592 | 1944 | 2844 | 1944 |  15 |        84000000 |      165862080 | 49.36 %   |
+------+------+------+------+-----+-----------------+----------------+-----------+

Only the 640x480, 1024x768 and 2592x1944 modes are significantly affected
by the new formula.

In this case, 640x480 and 1024x768 are actually fixed by this driver.
Indeed, the sensor was sending data at, for example, 27.33fps instead of
30fps. This is -9%, which is roughly what we're seeing in the array.
Testing these modes with the new clock setup actually fix that error, and
data are now sent at around 30fps.

2592x1944, on the other hand, is probably due to the fact that this mode
can only be used using MIPI-CSI2, in a two lane mode. This would have to be
tested though.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/media/i2c/ov5640.c | 41 +++++++++++++++++------------------------
 1 file changed, 17 insertions(+), 24 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 323cde27dd8b..bdf378d80e07 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -126,6 +126,12 @@ static const struct ov5640_pixfmt ov5640_formats[] = {
 	{ MEDIA_BUS_FMT_RGB565_2X8_BE, V4L2_COLORSPACE_SRGB, },
 };
 
+/*
+ * FIXME: If we ever have something else, we'll obviously need to have
+ * something smarter.
+ */
+#define OV5640_FORMATS_BPP	2
+
 /*
  * FIXME: remove this when a subdev API becomes available
  * to set the MIPI CSI-2 virtual channel.
@@ -172,7 +178,6 @@ struct ov5640_mode_info {
 	u32 htot;
 	u32 vact;
 	u32 vtot;
-	u32 clock;
 	const struct reg_value *reg_data;
 	u32 reg_data_size;
 };
@@ -696,7 +701,6 @@ static const struct reg_value ov5640_setting_15fps_QSXGA_2592_1944[] = {
 /* power-on sensor init reg table */
 static const struct ov5640_mode_info ov5640_mode_init_data = {
 	0, SUBSAMPLING, 640, 1896, 480, 984,
-	112000000,
 	ov5640_init_setting_30fps_VGA,
 	ARRAY_SIZE(ov5640_init_setting_30fps_VGA),
 };
@@ -706,91 +710,74 @@ ov5640_mode_data[OV5640_NUM_FRAMERATES][OV5640_NUM_MODES] = {
 	{
 		{OV5640_MODE_QCIF_176_144, SUBSAMPLING,
 		 176, 1896, 144, 984,
-		 56000000,
 		 ov5640_setting_15fps_QCIF_176_144,
 		 ARRAY_SIZE(ov5640_setting_15fps_QCIF_176_144)},
 		{OV5640_MODE_QVGA_320_240, SUBSAMPLING,
 		 320, 1896, 240, 984,
-		 56000000,
 		 ov5640_setting_15fps_QVGA_320_240,
 		 ARRAY_SIZE(ov5640_setting_15fps_QVGA_320_240)},
 		{OV5640_MODE_VGA_640_480, SUBSAMPLING,
 		 640, 1896, 480, 1080,
-		 56000000,
 		 ov5640_setting_15fps_VGA_640_480,
 		 ARRAY_SIZE(ov5640_setting_15fps_VGA_640_480)},
 		{OV5640_MODE_NTSC_720_480, SUBSAMPLING,
 		 720, 1896, 480, 984,
-		 56000000,
 		 ov5640_setting_15fps_NTSC_720_480,
 		 ARRAY_SIZE(ov5640_setting_15fps_NTSC_720_480)},
 		{OV5640_MODE_PAL_720_576, SUBSAMPLING,
 		 720, 1896, 576, 984,
-		 56000000,
 		 ov5640_setting_15fps_PAL_720_576,
 		 ARRAY_SIZE(ov5640_setting_15fps_PAL_720_576)},
 		{OV5640_MODE_XGA_1024_768, SUBSAMPLING,
 		 1024, 1896, 768, 1080,
-		 56000000,
 		 ov5640_setting_15fps_XGA_1024_768,
 		 ARRAY_SIZE(ov5640_setting_15fps_XGA_1024_768)},
 		{OV5640_MODE_720P_1280_720, SUBSAMPLING,
 		 1280, 1892, 720, 740,
-		 42000000,
 		 ov5640_setting_15fps_720P_1280_720,
 		 ARRAY_SIZE(ov5640_setting_15fps_720P_1280_720)},
 		{OV5640_MODE_1080P_1920_1080, SCALING,
 		 1920, 2500, 1080, 1120,
-		 84000000,
 		 ov5640_setting_15fps_1080P_1920_1080,
 		 ARRAY_SIZE(ov5640_setting_15fps_1080P_1920_1080)},
 		{OV5640_MODE_QSXGA_2592_1944, SCALING,
 		 2592, 2844, 1944, 1968,
-		 168000000,
 		 ov5640_setting_15fps_QSXGA_2592_1944,
 		 ARRAY_SIZE(ov5640_setting_15fps_QSXGA_2592_1944)},
 	}, {
 		{OV5640_MODE_QCIF_176_144, SUBSAMPLING,
 		 176, 1896, 144, 984,
-		 112000000,
 		 ov5640_setting_30fps_QCIF_176_144,
 		 ARRAY_SIZE(ov5640_setting_30fps_QCIF_176_144)},
 		{OV5640_MODE_QVGA_320_240, SUBSAMPLING,
 		 320, 1896, 240, 984,
-		 112000000,
 		 ov5640_setting_30fps_QVGA_320_240,
 		 ARRAY_SIZE(ov5640_setting_30fps_QVGA_320_240)},
 		{OV5640_MODE_VGA_640_480, SUBSAMPLING,
 		 640, 1896, 480, 1080,
-		 112000000,
 		 ov5640_setting_30fps_VGA_640_480,
 		 ARRAY_SIZE(ov5640_setting_30fps_VGA_640_480)},
 		{OV5640_MODE_NTSC_720_480, SUBSAMPLING,
 		 720, 1896, 480, 984,
-		 112000000,
 		 ov5640_setting_30fps_NTSC_720_480,
 		 ARRAY_SIZE(ov5640_setting_30fps_NTSC_720_480)},
 		{OV5640_MODE_PAL_720_576, SUBSAMPLING,
 		 720, 1896, 576, 984,
-		 112000000,
 		 ov5640_setting_30fps_PAL_720_576,
 		 ARRAY_SIZE(ov5640_setting_30fps_PAL_720_576)},
 		{OV5640_MODE_XGA_1024_768, SUBSAMPLING,
 		 1024, 1896, 768, 1080,
-		 112000000,
 		 ov5640_setting_30fps_XGA_1024_768,
 		 ARRAY_SIZE(ov5640_setting_30fps_XGA_1024_768)},
 		{OV5640_MODE_720P_1280_720, SUBSAMPLING,
 		 1280, 1892, 720, 740,
-		 84000000,
 		 ov5640_setting_30fps_720P_1280_720,
 		 ARRAY_SIZE(ov5640_setting_30fps_720P_1280_720)},
 		{OV5640_MODE_1080P_1920_1080, SCALING,
 		 1920, 2500, 1080, 1120,
-		 168000000,
 		 ov5640_setting_30fps_1080P_1920_1080,
 		 ARRAY_SIZE(ov5640_setting_30fps_1080P_1920_1080)},
-		{OV5640_MODE_QSXGA_2592_1944, -1, 0, 0, 0, 0, 0, NULL, 0},
+		{OV5640_MODE_QSXGA_2592_1944, -1, 0, 0, 0, 0, NULL, 0},
 	},
 };
 
@@ -1854,6 +1841,7 @@ static int ov5640_set_mode(struct ov5640_dev *sensor,
 {
 	const struct ov5640_mode_info *mode = sensor->current_mode;
 	enum ov5640_downsize_mode dn_mode, orig_dn_mode;
+	unsigned long rate;
 	int ret;
 
 	dn_mode = mode->dn_mode;
@@ -1868,10 +1856,15 @@ static int ov5640_set_mode(struct ov5640_dev *sensor,
 	if (ret)
 		return ret;
 
-	if (sensor->ep.bus_type == V4L2_MBUS_CSI2)
-		ret = ov5640_set_mipi_pclk(sensor, mode->clock);
-	else
-		ret = ov5640_set_dvp_pclk(sensor, mode->clock);
+	rate = mode->vtot * mode->htot * OV5640_FORMATS_BPP;
+	rate *= ov5640_framerates[sensor->current_fr];
+
+	if (sensor->ep.bus_type == V4L2_MBUS_CSI2) {
+		rate = rate / sensor->ep.bus.mipi_csi2.num_data_lanes;
+		ret = ov5640_set_mipi_pclk(sensor, rate);
+	} else {
+		ret = ov5640_set_dvp_pclk(sensor, rate);
+	}
 
 	if (ret < 0)
 		return 0;
-- 
2.14.3
