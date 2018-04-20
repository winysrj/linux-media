Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:59858 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754486AbeDTJt4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 05:49:56 -0400
From: Daniel Mack <daniel@zonque.org>
To: linux-media@vger.kernel.org
Cc: slongerbeam@gmail.com, mchehab@kernel.org,
        Daniel Mack <daniel@zonque.org>
Subject: [PATCH 1/3] media: ov5640: initialize mode data structs by name
Date: Fri, 20 Apr 2018 11:44:17 +0200
Message-Id: <20180420094419.11267-1-daniel@zonque.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch initializes the members of struct ov5640_mode_info by name for
better readability. This makes later additions to this struct easier.

No functional change intended.

Signed-off-by: Daniel Mack <daniel@zonque.org>
---
 drivers/media/i2c/ov5640.c | 207 +++++++++++++++++++++++++++++++++------------
 1 file changed, 152 insertions(+), 55 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 852026baa2e7..96f1564abdf5 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -728,67 +728,164 @@ static const struct reg_value ov5640_setting_15fps_QSXGA_2592_1944[] = {
 
 /* power-on sensor init reg table */
 static const struct ov5640_mode_info ov5640_mode_init_data = {
-	0, SUBSAMPLING, 640, 480, ov5640_init_setting_30fps_VGA,
-	ARRAY_SIZE(ov5640_init_setting_30fps_VGA),
+	.id		= 0,
+	.dn_mode	= SUBSAMPLING,
+	.width		= 640,
+	.height		= 480,
+	.reg_data	= ov5640_init_setting_30fps_VGA,
+	.reg_data_size	= ARRAY_SIZE(ov5640_init_setting_30fps_VGA),
 };
 
 static const struct ov5640_mode_info
 ov5640_mode_data[OV5640_NUM_FRAMERATES][OV5640_NUM_MODES] = {
+{
+	{
+		.id		= OV5640_MODE_QCIF_176_144,
+		.dn_mode	= SUBSAMPLING,
+		.width		= 176,
+		.height		= 144,
+		.reg_data	= ov5640_setting_15fps_QCIF_176_144,
+		.reg_data_size	= ARRAY_SIZE(ov5640_setting_15fps_QCIF_176_144),
+	},
+	{
+		.id		= OV5640_MODE_QVGA_320_240,
+		.dn_mode	= SUBSAMPLING,
+		.width		= 320,
+		.height		= 240,
+		.reg_data	= ov5640_setting_15fps_QVGA_320_240,
+		.reg_data_size	= ARRAY_SIZE(ov5640_setting_15fps_QVGA_320_240),
+	},
 	{
-		{OV5640_MODE_QCIF_176_144, SUBSAMPLING, 176, 144,
-		 ov5640_setting_15fps_QCIF_176_144,
-		 ARRAY_SIZE(ov5640_setting_15fps_QCIF_176_144)},
-		{OV5640_MODE_QVGA_320_240, SUBSAMPLING, 320,  240,
-		 ov5640_setting_15fps_QVGA_320_240,
-		 ARRAY_SIZE(ov5640_setting_15fps_QVGA_320_240)},
-		{OV5640_MODE_VGA_640_480, SUBSAMPLING, 640,  480,
-		 ov5640_setting_15fps_VGA_640_480,
-		 ARRAY_SIZE(ov5640_setting_15fps_VGA_640_480)},
-		{OV5640_MODE_NTSC_720_480, SUBSAMPLING, 720, 480,
-		 ov5640_setting_15fps_NTSC_720_480,
-		 ARRAY_SIZE(ov5640_setting_15fps_NTSC_720_480)},
-		{OV5640_MODE_PAL_720_576, SUBSAMPLING, 720, 576,
-		 ov5640_setting_15fps_PAL_720_576,
-		 ARRAY_SIZE(ov5640_setting_15fps_PAL_720_576)},
-		{OV5640_MODE_XGA_1024_768, SUBSAMPLING, 1024, 768,
-		 ov5640_setting_15fps_XGA_1024_768,
-		 ARRAY_SIZE(ov5640_setting_15fps_XGA_1024_768)},
-		{OV5640_MODE_720P_1280_720, SUBSAMPLING, 1280, 720,
-		 ov5640_setting_15fps_720P_1280_720,
-		 ARRAY_SIZE(ov5640_setting_15fps_720P_1280_720)},
-		{OV5640_MODE_1080P_1920_1080, SCALING, 1920, 1080,
-		 ov5640_setting_15fps_1080P_1920_1080,
-		 ARRAY_SIZE(ov5640_setting_15fps_1080P_1920_1080)},
-		{OV5640_MODE_QSXGA_2592_1944, SCALING, 2592, 1944,
-		 ov5640_setting_15fps_QSXGA_2592_1944,
-		 ARRAY_SIZE(ov5640_setting_15fps_QSXGA_2592_1944)},
-	}, {
-		{OV5640_MODE_QCIF_176_144, SUBSAMPLING, 176, 144,
-		 ov5640_setting_30fps_QCIF_176_144,
-		 ARRAY_SIZE(ov5640_setting_30fps_QCIF_176_144)},
-		{OV5640_MODE_QVGA_320_240, SUBSAMPLING, 320,  240,
-		 ov5640_setting_30fps_QVGA_320_240,
-		 ARRAY_SIZE(ov5640_setting_30fps_QVGA_320_240)},
-		{OV5640_MODE_VGA_640_480, SUBSAMPLING, 640,  480,
-		 ov5640_setting_30fps_VGA_640_480,
-		 ARRAY_SIZE(ov5640_setting_30fps_VGA_640_480)},
-		{OV5640_MODE_NTSC_720_480, SUBSAMPLING, 720, 480,
-		 ov5640_setting_30fps_NTSC_720_480,
-		 ARRAY_SIZE(ov5640_setting_30fps_NTSC_720_480)},
-		{OV5640_MODE_PAL_720_576, SUBSAMPLING, 720, 576,
-		 ov5640_setting_30fps_PAL_720_576,
-		 ARRAY_SIZE(ov5640_setting_30fps_PAL_720_576)},
-		{OV5640_MODE_XGA_1024_768, SUBSAMPLING, 1024, 768,
-		 ov5640_setting_30fps_XGA_1024_768,
-		 ARRAY_SIZE(ov5640_setting_30fps_XGA_1024_768)},
-		{OV5640_MODE_720P_1280_720, SUBSAMPLING, 1280, 720,
-		 ov5640_setting_30fps_720P_1280_720,
-		 ARRAY_SIZE(ov5640_setting_30fps_720P_1280_720)},
-		{OV5640_MODE_1080P_1920_1080, SCALING, 1920, 1080,
-		 ov5640_setting_30fps_1080P_1920_1080,
-		 ARRAY_SIZE(ov5640_setting_30fps_1080P_1920_1080)},
-		{OV5640_MODE_QSXGA_2592_1944, -1, 0, 0, NULL, 0},
+		.id		= OV5640_MODE_VGA_640_480,
+		.dn_mode	= SUBSAMPLING,
+		.width		= 640,
+		.height		= 480,
+		.reg_data	= ov5640_setting_15fps_VGA_640_480,
+		.reg_data_size	= ARRAY_SIZE(ov5640_setting_15fps_VGA_640_480)
 	},
+	{
+		.id		= OV5640_MODE_NTSC_720_480,
+		.dn_mode	= SUBSAMPLING,
+		.width		= 720,
+		.height		= 480,
+		.reg_data	= ov5640_setting_15fps_NTSC_720_480,
+		.reg_data_size	= ARRAY_SIZE(ov5640_setting_15fps_NTSC_720_480),
+	},
+	{
+		.id		= OV5640_MODE_PAL_720_576,
+		.dn_mode	= SUBSAMPLING,
+		.width		= 720,
+		.height		= 576,
+		.reg_data	= ov5640_setting_15fps_PAL_720_576,
+		.reg_data_size	= ARRAY_SIZE(ov5640_setting_15fps_PAL_720_576),
+	},
+	{
+		.id		= OV5640_MODE_XGA_1024_768,
+		.dn_mode	= SUBSAMPLING,
+		.width		= 1024,
+		.height		= 768,
+		.reg_data	= ov5640_setting_15fps_XGA_1024_768,
+		.reg_data_size	= ARRAY_SIZE(ov5640_setting_15fps_XGA_1024_768),
+	},
+	{
+		.id		= OV5640_MODE_720P_1280_720,
+		.dn_mode	= SUBSAMPLING,
+		.width		= 1280,
+		.height		= 720,
+		.reg_data	= ov5640_setting_15fps_720P_1280_720,
+		.reg_data_size	= ARRAY_SIZE(ov5640_setting_15fps_720P_1280_720),
+	},
+	{
+		.id		= OV5640_MODE_1080P_1920_1080,
+		.dn_mode	= SCALING,
+		.width		= 1920,
+		.height		= 1080,
+		.reg_data	= ov5640_setting_15fps_1080P_1920_1080,
+		.reg_data_size	= ARRAY_SIZE(ov5640_setting_15fps_1080P_1920_1080),
+	},
+	{
+		.id		= OV5640_MODE_QSXGA_2592_1944,
+		.dn_mode	= SCALING,
+		.width		= 2592,
+		.height		= 1944,
+		.reg_data	= ov5640_setting_15fps_QSXGA_2592_1944,
+		.reg_data_size	= ARRAY_SIZE(ov5640_setting_15fps_QSXGA_2592_1944),
+	},
+},
+{
+	{
+		.id		= OV5640_MODE_QCIF_176_144,
+		.dn_mode	= SUBSAMPLING,
+		.width		= 176,
+		.height		= 144,
+		.reg_data	= ov5640_setting_30fps_QCIF_176_144,
+		.reg_data_size	= ARRAY_SIZE(ov5640_setting_30fps_QCIF_176_144),
+	},
+	{
+		.id		= OV5640_MODE_QVGA_320_240,
+		.dn_mode	= SUBSAMPLING,
+		.width		= 320,
+		.height		= 240,
+		.reg_data	= ov5640_setting_30fps_QVGA_320_240,
+		.reg_data_size	= ARRAY_SIZE(ov5640_setting_30fps_QVGA_320_240),
+	},
+	{
+		.id		= OV5640_MODE_VGA_640_480,
+		.dn_mode	= SUBSAMPLING,
+		.width		= 640,
+		.height		= 480,
+		.reg_data	= ov5640_setting_30fps_VGA_640_480,
+		.reg_data_size	= ARRAY_SIZE(ov5640_setting_30fps_VGA_640_480),
+	},
+	{
+		.id		= OV5640_MODE_NTSC_720_480,
+		.dn_mode	= SUBSAMPLING,
+		.width		= 720,
+		.height		= 480,
+		.reg_data	= ov5640_setting_30fps_NTSC_720_480,
+		.reg_data_size	= ARRAY_SIZE(ov5640_setting_30fps_NTSC_720_480),
+	},
+	{
+		.id		= OV5640_MODE_PAL_720_576,
+		.dn_mode	= SUBSAMPLING,
+		.width		= 720,
+		.height		= 576,
+		.reg_data	= ov5640_setting_30fps_PAL_720_576,
+		.reg_data_size	= ARRAY_SIZE(ov5640_setting_30fps_PAL_720_576),
+	},
+	{
+		.id		= OV5640_MODE_XGA_1024_768,
+		.dn_mode	= SUBSAMPLING,
+		.width		= 1024,
+		.height		= 768,
+		.reg_data	= ov5640_setting_30fps_XGA_1024_768,
+		.reg_data_size	= ARRAY_SIZE(ov5640_setting_30fps_XGA_1024_768),
+	},
+	{
+		.id		= OV5640_MODE_720P_1280_720,
+		.dn_mode	= SUBSAMPLING,
+		.width		= 1280,
+		.height		= 720,
+		.reg_data	= ov5640_setting_30fps_720P_1280_720,
+		.reg_data_size	= ARRAY_SIZE(ov5640_setting_30fps_720P_1280_720),
+	},
+	{
+		.id		= OV5640_MODE_1080P_1920_1080,
+		.dn_mode	= SCALING,
+		.width		= 1920,
+		.height		= 1080,
+		.reg_data	= ov5640_setting_30fps_1080P_1920_1080,
+		.reg_data_size	= ARRAY_SIZE(ov5640_setting_30fps_1080P_1920_1080),
+	},
+	{
+		.id		= OV5640_MODE_QSXGA_2592_1944,
+		.dn_mode	= -1,
+		.width		= 0,
+		.height		= 0,
+		.reg_data	= NULL,
+		.reg_data_size	= 0,
+	}
+}
 };
 
 static int ov5640_init_slave_id(struct ov5640_dev *sensor)
-- 
2.14.3
