Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:51426 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725897AbeLCIor (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Dec 2018 03:44:47 -0500
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
Subject: [PATCH v6 03/12] media: ov5640: Remove the clocks registers initialization
Date: Mon,  3 Dec 2018 09:44:18 +0100
Message-Id: <f3d47381bc4a6469a404ba776a0cae532a890709.1543826654.git-series.maxime.ripard@bootlin.com>
In-Reply-To: <cover.b1632e0c1a10c3f9f674e00142a554fa79eac762.1543826654.git-series.maxime.ripard@bootlin.com>
References: <cover.b1632e0c1a10c3f9f674e00142a554fa79eac762.1543826654.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Part of the hardcoded initialization sequence is to set up the proper clock
dividers. However, this is now done dynamically through proper code and as
such, the static one is now redundant.

Let's remove it.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
Tested-by: Adam Ford <aford173@gmail.com> #imx6dq
---
 drivers/media/i2c/ov5640.c | 46 ++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 24 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 4254ac958424..588b98e2e99f 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -263,8 +263,7 @@ static inline struct v4l2_subdev *ctrl_to_sd(struct v4l2_ctrl *ctrl)
 static const struct reg_value ov5640_init_setting_30fps_VGA[] = {
 	{0x3103, 0x11, 0, 0}, {0x3008, 0x82, 0, 5}, {0x3008, 0x42, 0, 0},
 	{0x3103, 0x03, 0, 0}, {0x3017, 0x00, 0, 0}, {0x3018, 0x00, 0, 0},
-	{0x3034, 0x18, 0, 0}, {0x3035, 0x14, 0, 0}, {0x3036, 0x38, 0, 0},
-	{0x3037, 0x13, 0, 0}, {0x3630, 0x36, 0, 0},
+	{0x3630, 0x36, 0, 0},
 	{0x3631, 0x0e, 0, 0}, {0x3632, 0xe2, 0, 0}, {0x3633, 0x12, 0, 0},
 	{0x3621, 0xe0, 0, 0}, {0x3704, 0xa0, 0, 0}, {0x3703, 0x5a, 0, 0},
 	{0x3715, 0x78, 0, 0}, {0x3717, 0x01, 0, 0}, {0x370b, 0x60, 0, 0},
@@ -347,7 +346,7 @@ static const struct reg_value ov5640_init_setting_30fps_VGA[] = {
 };
 
 static const struct reg_value ov5640_setting_30fps_VGA_640_480[] = {
-	{0x3035, 0x14, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3814, 0x31, 0, 0},
 	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
@@ -366,7 +365,7 @@ static const struct reg_value ov5640_setting_30fps_VGA_640_480[] = {
 };
 
 static const struct reg_value ov5640_setting_15fps_VGA_640_480[] = {
-	{0x3035, 0x22, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3814, 0x31, 0, 0},
 	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
@@ -385,7 +384,7 @@ static const struct reg_value ov5640_setting_15fps_VGA_640_480[] = {
 };
 
 static const struct reg_value ov5640_setting_30fps_XGA_1024_768[] = {
-	{0x3035, 0x14, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3814, 0x31, 0, 0},
 	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
@@ -401,11 +400,10 @@ static const struct reg_value ov5640_setting_30fps_XGA_1024_768[] = {
 	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x4713, 0x03, 0, 0},
 	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
 	{0x3824, 0x02, 0, 0}, {0x5001, 0xa3, 0, 0}, {0x3503, 0x00, 0, 0},
-	{0x3035, 0x12, 0, 0},
 };
 
 static const struct reg_value ov5640_setting_15fps_XGA_1024_768[] = {
-	{0x3035, 0x22, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3814, 0x31, 0, 0},
 	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
@@ -424,7 +422,7 @@ static const struct reg_value ov5640_setting_15fps_XGA_1024_768[] = {
 };
 
 static const struct reg_value ov5640_setting_30fps_QVGA_320_240[] = {
-	{0x3035, 0x14, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3814, 0x31, 0, 0},
 	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
@@ -443,7 +441,7 @@ static const struct reg_value ov5640_setting_30fps_QVGA_320_240[] = {
 };
 
 static const struct reg_value ov5640_setting_15fps_QVGA_320_240[] = {
-	{0x3035, 0x22, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3814, 0x31, 0, 0},
 	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
@@ -462,7 +460,7 @@ static const struct reg_value ov5640_setting_15fps_QVGA_320_240[] = {
 };
 
 static const struct reg_value ov5640_setting_30fps_QCIF_176_144[] = {
-	{0x3035, 0x14, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3814, 0x31, 0, 0},
 	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
@@ -481,7 +479,7 @@ static const struct reg_value ov5640_setting_30fps_QCIF_176_144[] = {
 };
 
 static const struct reg_value ov5640_setting_15fps_QCIF_176_144[] = {
-	{0x3035, 0x22, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3814, 0x31, 0, 0},
 	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
@@ -500,7 +498,7 @@ static const struct reg_value ov5640_setting_15fps_QCIF_176_144[] = {
 };
 
 static const struct reg_value ov5640_setting_30fps_NTSC_720_480[] = {
-	{0x3035, 0x12, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3814, 0x31, 0, 0},
 	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
@@ -519,7 +517,7 @@ static const struct reg_value ov5640_setting_30fps_NTSC_720_480[] = {
 };
 
 static const struct reg_value ov5640_setting_15fps_NTSC_720_480[] = {
-	{0x3035, 0x22, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3814, 0x31, 0, 0},
 	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
@@ -538,7 +536,7 @@ static const struct reg_value ov5640_setting_15fps_NTSC_720_480[] = {
 };
 
 static const struct reg_value ov5640_setting_30fps_PAL_720_576[] = {
-	{0x3035, 0x12, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3814, 0x31, 0, 0},
 	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
@@ -557,7 +555,7 @@ static const struct reg_value ov5640_setting_30fps_PAL_720_576[] = {
 };
 
 static const struct reg_value ov5640_setting_15fps_PAL_720_576[] = {
-	{0x3035, 0x22, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3814, 0x31, 0, 0},
 	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
@@ -577,7 +575,7 @@ static const struct reg_value ov5640_setting_15fps_PAL_720_576[] = {
 
 static const struct reg_value ov5640_setting_30fps_720P_1280_720[] = {
 	{0x3008, 0x42, 0, 0},
-	{0x3035, 0x21, 0, 0}, {0x3036, 0x54, 0, 0}, {0x3c07, 0x07, 0, 0},
+	{0x3c07, 0x07, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3814, 0x31, 0, 0},
 	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
@@ -597,7 +595,7 @@ static const struct reg_value ov5640_setting_30fps_720P_1280_720[] = {
 };
 
 static const struct reg_value ov5640_setting_15fps_720P_1280_720[] = {
-	{0x3035, 0x41, 0, 0}, {0x3036, 0x54, 0, 0}, {0x3c07, 0x07, 0, 0},
+	{0x3c07, 0x07, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3814, 0x31, 0, 0},
 	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
@@ -617,7 +615,7 @@ static const struct reg_value ov5640_setting_15fps_720P_1280_720[] = {
 
 static const struct reg_value ov5640_setting_30fps_1080P_1920_1080[] = {
 	{0x3008, 0x42, 0, 0},
-	{0x3035, 0x21, 0, 0}, {0x3036, 0x54, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3814, 0x11, 0, 0},
 	{0x3815, 0x11, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
@@ -632,8 +630,8 @@ static const struct reg_value ov5640_setting_30fps_1080P_1920_1080[] = {
 	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
 	{0x4001, 0x02, 0, 0}, {0x4004, 0x06, 0, 0}, {0x4713, 0x03, 0, 0},
 	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
-	{0x3824, 0x02, 0, 0}, {0x5001, 0x83, 0, 0}, {0x3035, 0x11, 0, 0},
-	{0x3036, 0x54, 0, 0}, {0x3c07, 0x07, 0, 0}, {0x3c08, 0x00, 0, 0},
+	{0x3824, 0x02, 0, 0}, {0x5001, 0x83, 0, 0},
+	{0x3c07, 0x07, 0, 0}, {0x3c08, 0x00, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3800, 0x01, 0, 0}, {0x3801, 0x50, 0, 0}, {0x3802, 0x01, 0, 0},
 	{0x3803, 0xb2, 0, 0}, {0x3804, 0x08, 0, 0}, {0x3805, 0xef, 0, 0},
@@ -650,7 +648,7 @@ static const struct reg_value ov5640_setting_30fps_1080P_1920_1080[] = {
 
 static const struct reg_value ov5640_setting_15fps_1080P_1920_1080[] = {
 	{0x3008, 0x42, 0, 0},
-	{0x3035, 0x21, 0, 0}, {0x3036, 0x54, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3814, 0x11, 0, 0},
 	{0x3815, 0x11, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
@@ -665,8 +663,8 @@ static const struct reg_value ov5640_setting_15fps_1080P_1920_1080[] = {
 	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
 	{0x4001, 0x02, 0, 0}, {0x4004, 0x06, 0, 0}, {0x4713, 0x03, 0, 0},
 	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
-	{0x3824, 0x02, 0, 0}, {0x5001, 0x83, 0, 0}, {0x3035, 0x21, 0, 0},
-	{0x3036, 0x54, 0, 1}, {0x3c07, 0x07, 0, 0}, {0x3c08, 0x00, 0, 0},
+	{0x3824, 0x02, 0, 0}, {0x5001, 0x83, 0, 0},
+	{0x3c07, 0x07, 0, 0}, {0x3c08, 0x00, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3800, 0x01, 0, 0}, {0x3801, 0x50, 0, 0}, {0x3802, 0x01, 0, 0},
 	{0x3803, 0xb2, 0, 0}, {0x3804, 0x08, 0, 0}, {0x3805, 0xef, 0, 0},
@@ -681,7 +679,7 @@ static const struct reg_value ov5640_setting_15fps_1080P_1920_1080[] = {
 };
 
 static const struct reg_value ov5640_setting_15fps_QSXGA_2592_1944[] = {
-	{0x3035, 0x21, 0, 0}, {0x3036, 0x54, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3814, 0x11, 0, 0},
 	{0x3815, 0x11, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
-- 
git-series 0.9.1
