Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:51418 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725895AbeLCIoq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Dec 2018 03:44:46 -0500
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Samuel Bobrowicz <sam@elite-embedded.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Daniel Mack <daniel@zonque.org>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH v6 07/12] media: ov5640: Remove pixel clock rates
Date: Mon,  3 Dec 2018 09:44:22 +0100
Message-Id: <97210228e81c737750b399384e2b2511ed77435c.1543826654.git-series.maxime.ripard@bootlin.com>
In-Reply-To: <cover.b1632e0c1a10c3f9f674e00142a554fa79eac762.1543826654.git-series.maxime.ripard@bootlin.com>
References: <cover.b1632e0c1a10c3f9f674e00142a554fa79eac762.1543826654.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The pixel clock rates were introduced to report the initially static clock
rate.

Since this is now handled dynamically, we can remove them entirely.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
Tested-by: Adam Ford <aford173@gmail.com> #imx6dq
---
 drivers/media/i2c/ov5640.c | 21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 536261618d0d..06afe7572f0e 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -173,7 +173,6 @@ struct ov5640_mode_info {
 	u32 htot;
 	u32 vact;
 	u32 vtot;
-	u32 pixel_clock;
 	const struct reg_value *reg_data;
 	u32 reg_data_size;
 };
@@ -697,7 +696,6 @@ static const struct reg_value ov5640_setting_15fps_QSXGA_2592_1944[] = {
 /* power-on sensor init reg table */
 static const struct ov5640_mode_info ov5640_mode_init_data = {
 	0, SUBSAMPLING, 640, 1896, 480, 984,
-	56000000,
 	ov5640_init_setting_30fps_VGA,
 	ARRAY_SIZE(ov5640_init_setting_30fps_VGA),
 };
@@ -707,91 +705,74 @@ ov5640_mode_data[OV5640_NUM_FRAMERATES][OV5640_NUM_MODES] = {
 	{
 		{OV5640_MODE_QCIF_176_144, SUBSAMPLING,
 		 176, 1896, 144, 984,
-		 28000000,
 		 ov5640_setting_15fps_QCIF_176_144,
 		 ARRAY_SIZE(ov5640_setting_15fps_QCIF_176_144)},
 		{OV5640_MODE_QVGA_320_240, SUBSAMPLING,
 		 320, 1896, 240, 984,
-		 28000000,
 		 ov5640_setting_15fps_QVGA_320_240,
 		 ARRAY_SIZE(ov5640_setting_15fps_QVGA_320_240)},
 		{OV5640_MODE_VGA_640_480, SUBSAMPLING,
 		 640, 1896, 480, 1080,
-		 28000000,
 		 ov5640_setting_15fps_VGA_640_480,
 		 ARRAY_SIZE(ov5640_setting_15fps_VGA_640_480)},
 		{OV5640_MODE_NTSC_720_480, SUBSAMPLING,
 		 720, 1896, 480, 984,
-		 28000000,
 		 ov5640_setting_15fps_NTSC_720_480,
 		 ARRAY_SIZE(ov5640_setting_15fps_NTSC_720_480)},
 		{OV5640_MODE_PAL_720_576, SUBSAMPLING,
 		 720, 1896, 576, 984,
-		 28000000,
 		 ov5640_setting_15fps_PAL_720_576,
 		 ARRAY_SIZE(ov5640_setting_15fps_PAL_720_576)},
 		{OV5640_MODE_XGA_1024_768, SUBSAMPLING,
 		 1024, 1896, 768, 1080,
-		 28000000,
 		 ov5640_setting_15fps_XGA_1024_768,
 		 ARRAY_SIZE(ov5640_setting_15fps_XGA_1024_768)},
 		{OV5640_MODE_720P_1280_720, SUBSAMPLING,
 		 1280, 1892, 720, 740,
-		 21000000,
 		 ov5640_setting_15fps_720P_1280_720,
 		 ARRAY_SIZE(ov5640_setting_15fps_720P_1280_720)},
 		{OV5640_MODE_1080P_1920_1080, SCALING,
 		 1920, 2500, 1080, 1120,
-		 42000000,
 		 ov5640_setting_15fps_1080P_1920_1080,
 		 ARRAY_SIZE(ov5640_setting_15fps_1080P_1920_1080)},
 		{OV5640_MODE_QSXGA_2592_1944, SCALING,
 		 2592, 2844, 1944, 1968,
-		 84000000,
 		 ov5640_setting_15fps_QSXGA_2592_1944,
 		 ARRAY_SIZE(ov5640_setting_15fps_QSXGA_2592_1944)},
 	}, {
 		{OV5640_MODE_QCIF_176_144, SUBSAMPLING,
 		 176, 1896, 144, 984,
-		 56000000,
 		 ov5640_setting_30fps_QCIF_176_144,
 		 ARRAY_SIZE(ov5640_setting_30fps_QCIF_176_144)},
 		{OV5640_MODE_QVGA_320_240, SUBSAMPLING,
 		 320, 1896, 240, 984,
-		 56000000,
 		 ov5640_setting_30fps_QVGA_320_240,
 		 ARRAY_SIZE(ov5640_setting_30fps_QVGA_320_240)},
 		{OV5640_MODE_VGA_640_480, SUBSAMPLING,
 		 640, 1896, 480, 1080,
-		 56000000,
 		 ov5640_setting_30fps_VGA_640_480,
 		 ARRAY_SIZE(ov5640_setting_30fps_VGA_640_480)},
 		{OV5640_MODE_NTSC_720_480, SUBSAMPLING,
 		 720, 1896, 480, 984,
-		 56000000,
 		 ov5640_setting_30fps_NTSC_720_480,
 		 ARRAY_SIZE(ov5640_setting_30fps_NTSC_720_480)},
 		{OV5640_MODE_PAL_720_576, SUBSAMPLING,
 		 720, 1896, 576, 984,
-		 56000000,
 		 ov5640_setting_30fps_PAL_720_576,
 		 ARRAY_SIZE(ov5640_setting_30fps_PAL_720_576)},
 		{OV5640_MODE_XGA_1024_768, SUBSAMPLING,
 		 1024, 1896, 768, 1080,
-		 56000000,
 		 ov5640_setting_30fps_XGA_1024_768,
 		 ARRAY_SIZE(ov5640_setting_30fps_XGA_1024_768)},
 		{OV5640_MODE_720P_1280_720, SUBSAMPLING,
 		 1280, 1892, 720, 740,
-		 42000000,
 		 ov5640_setting_30fps_720P_1280_720,
 		 ARRAY_SIZE(ov5640_setting_30fps_720P_1280_720)},
 		{OV5640_MODE_1080P_1920_1080, SCALING,
 		 1920, 2500, 1080, 1120,
-		 84000000,
 		 ov5640_setting_30fps_1080P_1920_1080,
 		 ARRAY_SIZE(ov5640_setting_30fps_1080P_1920_1080)},
-		{OV5640_MODE_QSXGA_2592_1944, -1, 0, 0, 0, 0, 0, NULL, 0},
+		{OV5640_MODE_QSXGA_2592_1944, -1, 0, 0, 0, 0, NULL, 0},
 	},
 };
 
-- 
git-series 0.9.1
