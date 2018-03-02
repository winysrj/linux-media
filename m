Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:34063 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1425931AbeCBOfY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Mar 2018 09:35:24 -0500
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
Subject: [PATCH 08/12] media: ov5640: Adjust the clock based on the expected rate
Date: Fri,  2 Mar 2018 15:34:56 +0100
Message-Id: <20180302143500.32650-9-maxime.ripard@bootlin.com>
In-Reply-To: <20180302143500.32650-1-maxime.ripard@bootlin.com>
References: <20180302143500.32650-1-maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The clock structure for the PCLK is quite obscure in the documentation, and
was hardcoded through the bytes array of each and every mode.

This is troublesome, since we cannot adjust it at runtime based on other
parameters (such as the number of bytes per pixel), and we can't support
either framerates that have not been used by the various vendors, since we
don't have the needed initialization sequence.

We can however understand how the clock tree works, and then implement some
functions to derive the various parameters from a given rate. And now that
those parameters are calculated at runtime, we can remove them from the
initialization sequence.

The modes also gained a new parameter which is the clock that they are
running at, from the register writes they were doing, so for now the switch
to the new algorithm should be transparent.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/media/i2c/ov5640.c | 316 +++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 291 insertions(+), 25 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 0eeb1667bbe7..323cde27dd8b 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -172,6 +172,7 @@ struct ov5640_mode_info {
 	u32 htot;
 	u32 vact;
 	u32 vtot;
+	u32 clock;
 	const struct reg_value *reg_data;
 	u32 reg_data_size;
 };
@@ -255,8 +256,8 @@ static const struct reg_value ov5640_init_setting_30fps_VGA[] = {
 
 	{0x3103, 0x11, 0, 0}, {0x3008, 0x82, 0, 5}, {0x3008, 0x42, 0, 0},
 	{0x3103, 0x03, 0, 0}, {0x3017, 0x00, 0, 0}, {0x3018, 0x00, 0, 0},
-	{0x3034, 0x18, 0, 0}, {0x3035, 0x14, 0, 0}, {0x3036, 0x38, 0, 0},
-	{0x3037, 0x13, 0, 0}, {0x3630, 0x36, 0, 0},
+	{0x3034, 0x18, 0, 0},
+	{0x3630, 0x36, 0, 0},
 	{0x3631, 0x0e, 0, 0}, {0x3632, 0xe2, 0, 0}, {0x3633, 0x12, 0, 0},
 	{0x3621, 0xe0, 0, 0}, {0x3704, 0xa0, 0, 0}, {0x3703, 0x5a, 0, 0},
 	{0x3715, 0x78, 0, 0}, {0x3717, 0x01, 0, 0}, {0x370b, 0x60, 0, 0},
@@ -340,7 +341,7 @@ static const struct reg_value ov5640_init_setting_30fps_VGA[] = {
 
 static const struct reg_value ov5640_setting_30fps_VGA_640_480[] = {
 
-	{0x3035, 0x14, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3820, 0x41, 0, 0}, {0x3821, 0x07, 0, 0}, {0x3814, 0x31, 0, 0},
 	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
@@ -359,7 +360,7 @@ static const struct reg_value ov5640_setting_30fps_VGA_640_480[] = {
 };
 
 static const struct reg_value ov5640_setting_15fps_VGA_640_480[] = {
-	{0x3035, 0x22, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3820, 0x41, 0, 0}, {0x3821, 0x07, 0, 0}, {0x3814, 0x31, 0, 0},
 	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
@@ -379,7 +380,7 @@ static const struct reg_value ov5640_setting_15fps_VGA_640_480[] = {
 
 static const struct reg_value ov5640_setting_30fps_XGA_1024_768[] = {
 
-	{0x3035, 0x14, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3820, 0x41, 0, 0}, {0x3821, 0x07, 0, 0}, {0x3814, 0x31, 0, 0},
 	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
@@ -395,11 +396,10 @@ static const struct reg_value ov5640_setting_30fps_XGA_1024_768[] = {
 	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x4713, 0x03, 0, 0},
 	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
 	{0x3824, 0x02, 0, 0}, {0x5001, 0xa3, 0, 0}, {0x3503, 0x00, 0, 0},
-	{0x3035, 0x12, 0, 0},
 };
 
 static const struct reg_value ov5640_setting_15fps_XGA_1024_768[] = {
-	{0x3035, 0x22, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3820, 0x41, 0, 0}, {0x3821, 0x07, 0, 0}, {0x3814, 0x31, 0, 0},
 	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
@@ -418,7 +418,7 @@ static const struct reg_value ov5640_setting_15fps_XGA_1024_768[] = {
 };
 
 static const struct reg_value ov5640_setting_30fps_QVGA_320_240[] = {
-	{0x3035, 0x14, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3820, 0x41, 0, 0}, {0x3821, 0x07, 0, 0}, {0x3814, 0x31, 0, 0},
 	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
@@ -437,7 +437,7 @@ static const struct reg_value ov5640_setting_30fps_QVGA_320_240[] = {
 };
 
 static const struct reg_value ov5640_setting_15fps_QVGA_320_240[] = {
-	{0x3035, 0x22, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3820, 0x41, 0, 0}, {0x3821, 0x07, 0, 0}, {0x3814, 0x31, 0, 0},
 	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
@@ -456,7 +456,7 @@ static const struct reg_value ov5640_setting_15fps_QVGA_320_240[] = {
 };
 
 static const struct reg_value ov5640_setting_30fps_QCIF_176_144[] = {
-	{0x3035, 0x14, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3820, 0x41, 0, 0}, {0x3821, 0x07, 0, 0}, {0x3814, 0x31, 0, 0},
 	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
@@ -474,7 +474,7 @@ static const struct reg_value ov5640_setting_30fps_QCIF_176_144[] = {
 	{0x3824, 0x02, 0, 0}, {0x5001, 0xa3, 0, 0},
 };
 static const struct reg_value ov5640_setting_15fps_QCIF_176_144[] = {
-	{0x3035, 0x22, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3820, 0x41, 0, 0}, {0x3821, 0x07, 0, 0}, {0x3814, 0x31, 0, 0},
 	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
@@ -493,7 +493,7 @@ static const struct reg_value ov5640_setting_15fps_QCIF_176_144[] = {
 };
 
 static const struct reg_value ov5640_setting_30fps_NTSC_720_480[] = {
-	{0x3035, 0x12, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3820, 0x41, 0, 0}, {0x3821, 0x07, 0, 0}, {0x3814, 0x31, 0, 0},
 	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
@@ -512,7 +512,7 @@ static const struct reg_value ov5640_setting_30fps_NTSC_720_480[] = {
 };
 
 static const struct reg_value ov5640_setting_15fps_NTSC_720_480[] = {
-	{0x3035, 0x22, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3820, 0x41, 0, 0}, {0x3821, 0x07, 0, 0}, {0x3814, 0x31, 0, 0},
 	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
@@ -531,7 +531,7 @@ static const struct reg_value ov5640_setting_15fps_NTSC_720_480[] = {
 };
 
 static const struct reg_value ov5640_setting_30fps_PAL_720_576[] = {
-	{0x3035, 0x12, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3820, 0x41, 0, 0}, {0x3821, 0x07, 0, 0}, {0x3814, 0x31, 0, 0},
 	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
@@ -550,7 +550,7 @@ static const struct reg_value ov5640_setting_30fps_PAL_720_576[] = {
 };
 
 static const struct reg_value ov5640_setting_15fps_PAL_720_576[] = {
-	{0x3035, 0x22, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3820, 0x41, 0, 0}, {0x3821, 0x07, 0, 0}, {0x3814, 0x31, 0, 0},
 	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
@@ -570,7 +570,7 @@ static const struct reg_value ov5640_setting_15fps_PAL_720_576[] = {
 
 static const struct reg_value ov5640_setting_30fps_720P_1280_720[] = {
 	{0x3008, 0x42, 0, 0},
-	{0x3035, 0x21, 0, 0}, {0x3036, 0x54, 0, 0}, {0x3c07, 0x07, 0, 0},
+	{0x3c07, 0x07, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3820, 0x41, 0, 0}, {0x3821, 0x07, 0, 0}, {0x3814, 0x31, 0, 0},
 	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
@@ -590,7 +590,7 @@ static const struct reg_value ov5640_setting_30fps_720P_1280_720[] = {
 };
 
 static const struct reg_value ov5640_setting_15fps_720P_1280_720[] = {
-	{0x3035, 0x41, 0, 0}, {0x3036, 0x54, 0, 0}, {0x3c07, 0x07, 0, 0},
+	{0x3c07, 0x07, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3820, 0x41, 0, 0}, {0x3821, 0x07, 0, 0}, {0x3814, 0x31, 0, 0},
 	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
@@ -610,7 +610,7 @@ static const struct reg_value ov5640_setting_15fps_720P_1280_720[] = {
 
 static const struct reg_value ov5640_setting_30fps_1080P_1920_1080[] = {
 	{0x3008, 0x42, 0, 0},
-	{0x3035, 0x21, 0, 0}, {0x3036, 0x54, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3820, 0x40, 0, 0}, {0x3821, 0x06, 0, 0}, {0x3814, 0x11, 0, 0},
 	{0x3815, 0x11, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
@@ -625,8 +625,8 @@ static const struct reg_value ov5640_setting_30fps_1080P_1920_1080[] = {
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
@@ -643,7 +643,7 @@ static const struct reg_value ov5640_setting_30fps_1080P_1920_1080[] = {
 
 static const struct reg_value ov5640_setting_15fps_1080P_1920_1080[] = {
 	{0x3008, 0x42, 0, 0},
-	{0x3035, 0x21, 0, 0}, {0x3036, 0x54, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3820, 0x40, 0, 0}, {0x3821, 0x06, 0, 0}, {0x3814, 0x11, 0, 0},
 	{0x3815, 0x11, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
@@ -658,8 +658,8 @@ static const struct reg_value ov5640_setting_15fps_1080P_1920_1080[] = {
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
@@ -675,7 +675,7 @@ static const struct reg_value ov5640_setting_15fps_1080P_1920_1080[] = {
 
 static const struct reg_value ov5640_setting_15fps_QSXGA_2592_1944[] = {
 	{0x3820, 0x40, 0, 0}, {0x3821, 0x06, 0, 0},
-	{0x3035, 0x21, 0, 0}, {0x3036, 0x54, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3820, 0x40, 0, 0}, {0x3821, 0x06, 0, 0}, {0x3814, 0x11, 0, 0},
 	{0x3815, 0x11, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
@@ -696,6 +696,7 @@ static const struct reg_value ov5640_setting_15fps_QSXGA_2592_1944[] = {
 /* power-on sensor init reg table */
 static const struct ov5640_mode_info ov5640_mode_init_data = {
 	0, SUBSAMPLING, 640, 1896, 480, 984,
+	112000000,
 	ov5640_init_setting_30fps_VGA,
 	ARRAY_SIZE(ov5640_init_setting_30fps_VGA),
 };
@@ -705,74 +706,91 @@ ov5640_mode_data[OV5640_NUM_FRAMERATES][OV5640_NUM_MODES] = {
 	{
 		{OV5640_MODE_QCIF_176_144, SUBSAMPLING,
 		 176, 1896, 144, 984,
+		 56000000,
 		 ov5640_setting_15fps_QCIF_176_144,
 		 ARRAY_SIZE(ov5640_setting_15fps_QCIF_176_144)},
 		{OV5640_MODE_QVGA_320_240, SUBSAMPLING,
 		 320, 1896, 240, 984,
+		 56000000,
 		 ov5640_setting_15fps_QVGA_320_240,
 		 ARRAY_SIZE(ov5640_setting_15fps_QVGA_320_240)},
 		{OV5640_MODE_VGA_640_480, SUBSAMPLING,
 		 640, 1896, 480, 1080,
+		 56000000,
 		 ov5640_setting_15fps_VGA_640_480,
 		 ARRAY_SIZE(ov5640_setting_15fps_VGA_640_480)},
 		{OV5640_MODE_NTSC_720_480, SUBSAMPLING,
 		 720, 1896, 480, 984,
+		 56000000,
 		 ov5640_setting_15fps_NTSC_720_480,
 		 ARRAY_SIZE(ov5640_setting_15fps_NTSC_720_480)},
 		{OV5640_MODE_PAL_720_576, SUBSAMPLING,
 		 720, 1896, 576, 984,
+		 56000000,
 		 ov5640_setting_15fps_PAL_720_576,
 		 ARRAY_SIZE(ov5640_setting_15fps_PAL_720_576)},
 		{OV5640_MODE_XGA_1024_768, SUBSAMPLING,
 		 1024, 1896, 768, 1080,
+		 56000000,
 		 ov5640_setting_15fps_XGA_1024_768,
 		 ARRAY_SIZE(ov5640_setting_15fps_XGA_1024_768)},
 		{OV5640_MODE_720P_1280_720, SUBSAMPLING,
 		 1280, 1892, 720, 740,
+		 42000000,
 		 ov5640_setting_15fps_720P_1280_720,
 		 ARRAY_SIZE(ov5640_setting_15fps_720P_1280_720)},
 		{OV5640_MODE_1080P_1920_1080, SCALING,
 		 1920, 2500, 1080, 1120,
+		 84000000,
 		 ov5640_setting_15fps_1080P_1920_1080,
 		 ARRAY_SIZE(ov5640_setting_15fps_1080P_1920_1080)},
 		{OV5640_MODE_QSXGA_2592_1944, SCALING,
 		 2592, 2844, 1944, 1968,
+		 168000000,
 		 ov5640_setting_15fps_QSXGA_2592_1944,
 		 ARRAY_SIZE(ov5640_setting_15fps_QSXGA_2592_1944)},
 	}, {
 		{OV5640_MODE_QCIF_176_144, SUBSAMPLING,
 		 176, 1896, 144, 984,
+		 112000000,
 		 ov5640_setting_30fps_QCIF_176_144,
 		 ARRAY_SIZE(ov5640_setting_30fps_QCIF_176_144)},
 		{OV5640_MODE_QVGA_320_240, SUBSAMPLING,
 		 320, 1896, 240, 984,
+		 112000000,
 		 ov5640_setting_30fps_QVGA_320_240,
 		 ARRAY_SIZE(ov5640_setting_30fps_QVGA_320_240)},
 		{OV5640_MODE_VGA_640_480, SUBSAMPLING,
 		 640, 1896, 480, 1080,
+		 112000000,
 		 ov5640_setting_30fps_VGA_640_480,
 		 ARRAY_SIZE(ov5640_setting_30fps_VGA_640_480)},
 		{OV5640_MODE_NTSC_720_480, SUBSAMPLING,
 		 720, 1896, 480, 984,
+		 112000000,
 		 ov5640_setting_30fps_NTSC_720_480,
 		 ARRAY_SIZE(ov5640_setting_30fps_NTSC_720_480)},
 		{OV5640_MODE_PAL_720_576, SUBSAMPLING,
 		 720, 1896, 576, 984,
+		 112000000,
 		 ov5640_setting_30fps_PAL_720_576,
 		 ARRAY_SIZE(ov5640_setting_30fps_PAL_720_576)},
 		{OV5640_MODE_XGA_1024_768, SUBSAMPLING,
 		 1024, 1896, 768, 1080,
+		 112000000,
 		 ov5640_setting_30fps_XGA_1024_768,
 		 ARRAY_SIZE(ov5640_setting_30fps_XGA_1024_768)},
 		{OV5640_MODE_720P_1280_720, SUBSAMPLING,
 		 1280, 1892, 720, 740,
+		 84000000,
 		 ov5640_setting_30fps_720P_1280_720,
 		 ARRAY_SIZE(ov5640_setting_30fps_720P_1280_720)},
 		{OV5640_MODE_1080P_1920_1080, SCALING,
 		 1920, 2500, 1080, 1120,
+		 168000000,
 		 ov5640_setting_30fps_1080P_1920_1080,
 		 ARRAY_SIZE(ov5640_setting_30fps_1080P_1920_1080)},
-		{OV5640_MODE_QSXGA_2592_1944, -1, 0, 0, 0, 0, NULL, 0},
+		{OV5640_MODE_QSXGA_2592_1944, -1, 0, 0, 0, 0, 0, NULL, 0},
 	},
 };
 
@@ -902,6 +920,246 @@ static int ov5640_mod_reg(struct ov5640_dev *sensor, u16 reg,
 	return ov5640_write_reg(sensor, reg, val);
 }
 
+/*
+ * After spending way too much time trying the various combinations, I
+ * believe the clock tree is as follows:
+ *
+ *   +--------------+
+ *   |  Oscillator  |
+ *   +------+-------+
+ *          |
+ *   +------+-------+
+ *   | System clock | - reg 0x3035, bits 4-7
+ *   +------+-------+
+ *          |
+ *   +------+-------+ - reg 0x3036, for the multiplier
+ *   |     PLL      | - reg 0x3037, bits 4 for the root divider
+ *   +------+-------+ - reg 0x3037, bits 0-3 for the pre-divider
+ *          |
+ *   +------+-------+
+ *   |     SCLK     | - reg 0x3108, bits 0-1 for the root divider
+ *   +------+-------+
+ *          |
+ *   +------+-------+
+ *   |    PCLK      | - reg 0x3108, bits 4-5 for the root divider
+ *   +--------------+
+ *
+ * This is deviating from the datasheet at least for the register
+ * 0x3108, since it's said here that the PCLK would be clocked from
+ * the PLL. However, changing the SCLK divider value has a direct
+ * effect on the PCLK rate, which wouldn't be the case if both PCLK
+ * and SCLK were to be sourced from the PLL.
+ *
+ * These parameters also match perfectly the rate that is output by
+ * the sensor, so we shouldn't have too much factors missing (or they
+ * would be set to 1).
+ */
+
+/*
+ * FIXME: This is supposed to be ranging from 1 to 16, but the value
+ * is always set to either 1 or 2 in the vendor kernels.
+ */
+#define OV5640_SYSDIV_MIN	1
+#define OV5640_SYSDIV_MAX	2
+
+static unsigned long ov5640_calc_sysclk(struct ov5640_dev *sensor,
+					unsigned long rate,
+					u8 *sysdiv)
+{
+	unsigned long best = ~0;
+	u8 best_sysdiv = 1;
+	u8 _sysdiv;
+
+	for (_sysdiv = OV5640_SYSDIV_MIN;
+	     _sysdiv <= OV5640_SYSDIV_MAX;
+	     _sysdiv++) {
+		unsigned long tmp;
+
+		tmp = sensor->xclk_freq / _sysdiv;
+		if (abs(rate - tmp) < abs(rate - best)) {
+			best = tmp;
+			best_sysdiv = _sysdiv;
+		}
+
+		if (tmp == rate)
+			goto out;
+	}
+
+out:
+	*sysdiv = best_sysdiv;
+	return best;
+}
+
+/*
+ * FIXME: This is supposed to be ranging from 1 to 8, but the value is
+ * always set to 3 in the vendor kernels.
+ */
+#define OV5640_PLL_PREDIV_MIN	3
+#define OV5640_PLL_PREDIV_MAX	3
+
+/*
+ * FIXME: This is supposed to be ranging from 1 to 2, but the value is
+ * always set to 1 in the vendor kernels.
+ */
+#define OV5640_PLL_ROOT_DIV_MIN	1
+#define OV5640_PLL_ROOT_DIV_MAX	1
+
+#define OV5640_PLL_MULT_MIN	4
+#define OV5640_PLL_MULT_MAX	252
+
+static unsigned long ov5640_calc_pll(struct ov5640_dev *sensor,
+				     unsigned long rate,
+				     u8 *sysdiv, u8 *prediv, u8 *rdiv, u8 *mult)
+{
+	unsigned long best = ~0;
+	u8 best_sysdiv = 1, best_prediv = 1, best_mult = 1, best_rdiv = 1;
+	u8 _prediv, _mult, _rdiv;
+
+	for (_prediv = OV5640_PLL_PREDIV_MIN;
+	     _prediv <= OV5640_PLL_PREDIV_MAX;
+	     _prediv++) {
+		for (_mult = OV5640_PLL_MULT_MIN;
+		     _mult <= OV5640_PLL_MULT_MAX;
+		     _mult++) {
+			for (_rdiv = OV5640_PLL_ROOT_DIV_MIN;
+			     _rdiv <= OV5640_PLL_ROOT_DIV_MAX;
+			     _rdiv++) {
+				unsigned long pll;
+				unsigned long sysclk;
+				u8 _sysdiv;
+
+				/*
+				 * The PLL multiplier cannot be odd if
+				 * above 127.
+				 */
+				if (_mult > 127 && !(_mult % 2))
+					continue;
+
+				sysclk = rate * _prediv * _rdiv / _mult;
+				sysclk = ov5640_calc_sysclk(sensor, sysclk,
+							    &_sysdiv);
+
+				pll = sysclk / _rdiv / _prediv * _mult;
+				if (abs(rate - pll) < abs(rate - best)) {
+					best = pll;
+					best_sysdiv = _sysdiv;
+					best_prediv = _prediv;
+					best_mult = _mult;
+					best_rdiv = _rdiv;
+				}
+
+				if (pll == rate)
+					goto out;
+			}
+		}
+	}
+
+out:
+	*sysdiv = best_sysdiv;
+	*prediv = best_prediv;
+	*mult = best_mult;
+	*rdiv = best_rdiv;
+
+	return best;
+}
+
+/*
+ * FIXME: This is supposed to be ranging from 1 to 8, but the value is
+ * always set to 1 in the vendor kernels.
+ */
+#define OV5640_PCLK_ROOT_DIV_MIN	1
+#define OV5640_PCLK_ROOT_DIV_MAX	1
+
+static unsigned long ov5640_calc_pclk(struct ov5640_dev *sensor,
+				      unsigned long rate,
+				      u8 *sysdiv, u8 *prediv, u8 *pll_rdiv,
+				      u8 *mult, u8 *pclk_rdiv)
+{
+	unsigned long best = ~0;
+	u8 best_sysdiv = 1, best_prediv = 1, best_mult = 1, best_pll_rdiv = 1;
+	u8 best_pclk_rdiv = 1;
+	u8 _pclk_rdiv;
+
+	for (_pclk_rdiv = OV5640_PCLK_ROOT_DIV_MIN;
+	     _pclk_rdiv <= OV5640_PCLK_ROOT_DIV_MAX;
+	     _pclk_rdiv <<= 1) {
+		unsigned long pll, pclk;
+		u8 sysdiv, prediv, mult, pll_rdiv;
+
+		pll = rate * OV5640_SCLK_ROOT_DIVIDER_DEFAULT * _pclk_rdiv;
+		pll = ov5640_calc_pll(sensor, pll, &sysdiv, &prediv, &pll_rdiv,
+				      &mult);
+
+		pclk = pll / OV5640_SCLK_ROOT_DIVIDER_DEFAULT / _pclk_rdiv;
+		if (abs(rate - pclk) < abs(rate - best)) {
+			best = pclk;
+			best_sysdiv = sysdiv;
+			best_prediv = prediv;
+			best_pll_rdiv = pll_rdiv;
+			best_pclk_rdiv = _pclk_rdiv;
+			best_mult = mult;
+		}
+
+		if (pclk == rate)
+			goto out;
+	}
+
+out:
+	*sysdiv = best_sysdiv;
+	*prediv = best_prediv;
+	*pll_rdiv = best_pll_rdiv;
+	*mult = best_mult;
+	*pclk_rdiv = best_pclk_rdiv;
+	return best;
+}
+
+static int ov5640_set_dvp_pclk(struct ov5640_dev *sensor, unsigned long rate)
+{
+	u8 sysdiv, prediv, mult, pll_rdiv, pclk_rdiv;
+	int ret;
+
+	ov5640_calc_pclk(sensor, rate, &sysdiv, &prediv, &pll_rdiv, &mult,
+			 &pclk_rdiv);
+	ret = ov5640_mod_reg(sensor, OV5640_REG_SC_PLL_CTRL1,
+			     0xf0, sysdiv << 4);
+	if (ret)
+		return ret;
+
+	ret = ov5640_mod_reg(sensor, OV5640_REG_SC_PLL_CTRL2,
+			     0xff, mult);
+	if (ret)
+		return ret;
+
+	ret = ov5640_mod_reg(sensor, OV5640_REG_SC_PLL_CTRL3,
+			     0xff, prediv | ((pll_rdiv - 1) << 4));
+	if (ret)
+		return ret;
+
+	return ov5640_mod_reg(sensor, OV5640_REG_SYS_ROOT_DIVIDER,
+			      0x30, ilog2(pclk_rdiv) << 4);
+}
+
+static int ov5640_set_mipi_pclk(struct ov5640_dev *sensor, unsigned long rate)
+{
+	u8 sysdiv, prediv, mult, pll_rdiv, pclk_rdiv;
+	int ret;
+
+	ov5640_calc_pclk(sensor, rate, &sysdiv, &prediv, &pll_rdiv, &mult,
+			 &pclk_rdiv);
+	ret = ov5640_write_reg(sensor, OV5640_REG_SC_PLL_CTRL1,
+			       (sysdiv << 4) | pclk_rdiv);
+	if (ret)
+		return ret;
+
+	ret = ov5640_mod_reg(sensor, OV5640_REG_SC_PLL_CTRL2,
+			     0xff, mult);
+	if (ret)
+		return ret;
+
+	return ov5640_mod_reg(sensor, OV5640_REG_SC_PLL_CTRL3,
+			      0xff, prediv | ((pll_rdiv - 1) << 4));
+}
+
 /* download ov5640 settings to sensor through i2c */
 static int ov5640_load_regs(struct ov5640_dev *sensor,
 			    const struct ov5640_mode_info *mode)
@@ -1610,6 +1868,14 @@ static int ov5640_set_mode(struct ov5640_dev *sensor,
 	if (ret)
 		return ret;
 
+	if (sensor->ep.bus_type == V4L2_MBUS_CSI2)
+		ret = ov5640_set_mipi_pclk(sensor, mode->clock);
+	else
+		ret = ov5640_set_dvp_pclk(sensor, mode->clock);
+
+	if (ret < 0)
+		return 0;
+
 	if ((dn_mode == SUBSAMPLING && orig_dn_mode == SCALING) ||
 	    (dn_mode == SCALING && orig_dn_mode == SUBSAMPLING)) {
 		/*
-- 
2.14.3
