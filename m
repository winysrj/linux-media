Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43211 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727061AbeJRB3x (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 Oct 2018 21:29:53 -0400
Received: by mail-pl1-f193.google.com with SMTP id 30-v6so13005672plb.10
        for <linux-media@vger.kernel.org>; Wed, 17 Oct 2018 10:33:11 -0700 (PDT)
From: Sam Bobrowicz <sam@elite-embedded.com>
To: linux-media@vger.kernel.org
Cc: maxime.ripard@bootlin.com, jacopo@jmondi.org,
        laurent.pinchart@ideasonboard.com, hugues.fruchet@st.com,
        Sam Bobrowicz <sam@elite-embedded.com>
Subject: [RFC PATCH] media: ov5640: calculate PLL settings for modes
Date: Wed, 17 Oct 2018 10:31:48 -0700
Message-Id: <1539797508-127629-1-git-send-email-sam@elite-embedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove the PLL settings from the register blobs and
calculate them based on required clocks. This allows
more mode and input clock (xclk) configurations.

Also ensure that PCLK PERIOD register 0x4837 is set
so that MIPI receivers are not broken by this patch.

Last, a change to the init register blob that helps
ensure the following DPHY spec requirement is met:

MIN HS_ZERO + MIN HS_PREPARE > 145 + t_UI * 10

Signed-off-by: Sam Bobrowicz <sam@elite-embedded.com>
---

 This is a modified version of Maxime's patch that works on my platform.
 My platform is a dual-lane MIPI CSI2 module with xclk=24MHz connected 
 to a Xilinx Zynq Ultrascale+.

 One issue I am currently experiencing with this patch is that some 
 15Hz framerates are not working. This seems to be due to the slower 
 clocks which are generated, and may be caused by the large ADC clock
 to SCLK ratio. I will be exploring some fixes this weekend. Thoughts on
 this would be appreciated.
 
 I am submitting this so that it can be compared to Maxime's, which has 
 been reported to not be functional on MIPI platforms. I do a number of
 things differently, and I hope that those which are useful will be 
 integrated into his patch. 

 I think this patch (or the modified version of Maxime's patch) should 
 be tested under the following conditions:

 1) MIPI mode, xclk=24MHz
 2) MIPI mode, xclk!=24MHz
 3) DVP mode
 4) JPEG format

 I'm setup to test the first two, but don't have the hardware/software 
 to test 3 and 4. 

 This patch is based on the current master of media_linux 
 "media: ov5640: fix framerate update".

 drivers/media/i2c/ov5640.c | 332 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 281 insertions(+), 51 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index eaefdb5..c076955 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -85,6 +85,7 @@
 #define OV5640_REG_POLARITY_CTRL00	0x4740
 #define OV5640_REG_MIPI_CTRL00		0x4800
 #define OV5640_REG_DEBUG_MODE		0x4814
+#define OV5640_REG_PCLK_PERIOD		0x4837
 #define OV5640_REG_ISP_FORMAT_MUX_CTRL	0x501f
 #define OV5640_REG_PRE_ISP_TEST_SET1	0x503d
 #define OV5640_REG_SDE_CTRL0		0x5580
@@ -94,9 +95,6 @@
 #define OV5640_REG_SDE_CTRL5		0x5585
 #define OV5640_REG_AVG_READOUT		0x56a1
 
-#define OV5640_SCLK2X_ROOT_DIVIDER_DEFAULT	1
-#define OV5640_SCLK_ROOT_DIVIDER_DEFAULT	2
-
 enum ov5640_mode_id {
 	OV5640_MODE_QCIF_176_144 = 0,
 	OV5640_MODE_QVGA_320_240,
@@ -171,6 +169,7 @@ struct reg_value {
 struct ov5640_mode_info {
 	enum ov5640_mode_id id;
 	enum ov5640_downsize_mode dn_mode;
+	bool scaler; /* Mode uses ISP scaler (reg 0x5001,BIT(5)=='1') */
 	u32 hact;
 	u32 htot;
 	u32 vact;
@@ -291,7 +290,7 @@ static const struct reg_value ov5640_init_setting_30fps_VGA[] = {
 	{0x302e, 0x08, 0, 0}, {0x4300, 0x3f, 0, 0},
 	{0x501f, 0x00, 0, 0}, {0x4713, 0x03, 0, 0}, {0x4407, 0x04, 0, 0},
 	{0x440e, 0x00, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
-	{0x4837, 0x0a, 0, 0}, {0x3824, 0x02, 0, 0},
+	{0x3824, 0x02, 0, 0}, {0x482a, 0x06, 0, 0},
 	{0x5000, 0xa7, 0, 0}, {0x5001, 0xa3, 0, 0}, {0x5180, 0xff, 0, 0},
 	{0x5181, 0xf2, 0, 0}, {0x5182, 0x00, 0, 0}, {0x5183, 0x14, 0, 0},
 	{0x5184, 0x25, 0, 0}, {0x5185, 0x24, 0, 0}, {0x5186, 0x09, 0, 0},
@@ -345,7 +344,7 @@ static const struct reg_value ov5640_init_setting_30fps_VGA[] = {
 };
 
 static const struct reg_value ov5640_setting_30fps_VGA_640_480[] = {
-	{0x3035, 0x14, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3814, 0x31, 0, 0},
 	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
@@ -364,7 +363,7 @@ static const struct reg_value ov5640_setting_30fps_VGA_640_480[] = {
 };
 
 static const struct reg_value ov5640_setting_15fps_VGA_640_480[] = {
-	{0x3035, 0x22, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3814, 0x31, 0, 0},
 	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
@@ -383,7 +382,7 @@ static const struct reg_value ov5640_setting_15fps_VGA_640_480[] = {
 };
 
 static const struct reg_value ov5640_setting_30fps_XGA_1024_768[] = {
-	{0x3035, 0x14, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3814, 0x31, 0, 0},
 	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
@@ -399,11 +398,10 @@ static const struct reg_value ov5640_setting_30fps_XGA_1024_768[] = {
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
@@ -422,7 +420,7 @@ static const struct reg_value ov5640_setting_15fps_XGA_1024_768[] = {
 };
 
 static const struct reg_value ov5640_setting_30fps_QVGA_320_240[] = {
-	{0x3035, 0x14, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3814, 0x31, 0, 0},
 	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
@@ -441,7 +439,7 @@ static const struct reg_value ov5640_setting_30fps_QVGA_320_240[] = {
 };
 
 static const struct reg_value ov5640_setting_15fps_QVGA_320_240[] = {
-	{0x3035, 0x22, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3814, 0x31, 0, 0},
 	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
@@ -460,7 +458,7 @@ static const struct reg_value ov5640_setting_15fps_QVGA_320_240[] = {
 };
 
 static const struct reg_value ov5640_setting_30fps_QCIF_176_144[] = {
-	{0x3035, 0x14, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3814, 0x31, 0, 0},
 	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
@@ -479,7 +477,7 @@ static const struct reg_value ov5640_setting_30fps_QCIF_176_144[] = {
 };
 
 static const struct reg_value ov5640_setting_15fps_QCIF_176_144[] = {
-	{0x3035, 0x22, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3814, 0x31, 0, 0},
 	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
@@ -498,7 +496,7 @@ static const struct reg_value ov5640_setting_15fps_QCIF_176_144[] = {
 };
 
 static const struct reg_value ov5640_setting_30fps_NTSC_720_480[] = {
-	{0x3035, 0x12, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3814, 0x31, 0, 0},
 	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
@@ -517,7 +515,7 @@ static const struct reg_value ov5640_setting_30fps_NTSC_720_480[] = {
 };
 
 static const struct reg_value ov5640_setting_15fps_NTSC_720_480[] = {
-	{0x3035, 0x22, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3814, 0x31, 0, 0},
 	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
@@ -536,7 +534,7 @@ static const struct reg_value ov5640_setting_15fps_NTSC_720_480[] = {
 };
 
 static const struct reg_value ov5640_setting_30fps_PAL_720_576[] = {
-	{0x3035, 0x12, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3814, 0x31, 0, 0},
 	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
@@ -555,7 +553,7 @@ static const struct reg_value ov5640_setting_30fps_PAL_720_576[] = {
 };
 
 static const struct reg_value ov5640_setting_15fps_PAL_720_576[] = {
-	{0x3035, 0x22, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3814, 0x31, 0, 0},
 	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
@@ -575,7 +573,7 @@ static const struct reg_value ov5640_setting_15fps_PAL_720_576[] = {
 
 static const struct reg_value ov5640_setting_30fps_720P_1280_720[] = {
 	{0x3008, 0x42, 0, 0},
-	{0x3035, 0x21, 0, 0}, {0x3036, 0x54, 0, 0}, {0x3c07, 0x07, 0, 0},
+	{0x3c07, 0x07, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3814, 0x31, 0, 0},
 	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
@@ -595,7 +593,7 @@ static const struct reg_value ov5640_setting_30fps_720P_1280_720[] = {
 };
 
 static const struct reg_value ov5640_setting_15fps_720P_1280_720[] = {
-	{0x3035, 0x41, 0, 0}, {0x3036, 0x54, 0, 0}, {0x3c07, 0x07, 0, 0},
+	{0x3c07, 0x07, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3814, 0x31, 0, 0},
 	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
@@ -615,7 +613,7 @@ static const struct reg_value ov5640_setting_15fps_720P_1280_720[] = {
 
 static const struct reg_value ov5640_setting_30fps_1080P_1920_1080[] = {
 	{0x3008, 0x42, 0, 0},
-	{0x3035, 0x21, 0, 0}, {0x3036, 0x54, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3814, 0x11, 0, 0},
 	{0x3815, 0x11, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
@@ -630,8 +628,8 @@ static const struct reg_value ov5640_setting_30fps_1080P_1920_1080[] = {
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
@@ -648,7 +646,7 @@ static const struct reg_value ov5640_setting_30fps_1080P_1920_1080[] = {
 
 static const struct reg_value ov5640_setting_15fps_1080P_1920_1080[] = {
 	{0x3008, 0x42, 0, 0},
-	{0x3035, 0x21, 0, 0}, {0x3036, 0x54, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3814, 0x11, 0, 0},
 	{0x3815, 0x11, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
@@ -663,8 +661,8 @@ static const struct reg_value ov5640_setting_15fps_1080P_1920_1080[] = {
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
@@ -679,7 +677,7 @@ static const struct reg_value ov5640_setting_15fps_1080P_1920_1080[] = {
 };
 
 static const struct reg_value ov5640_setting_15fps_QSXGA_2592_1944[] = {
-	{0x3035, 0x21, 0, 0}, {0x3036, 0x54, 0, 0}, {0x3c07, 0x08, 0, 0},
+	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3814, 0x11, 0, 0},
 	{0x3815, 0x11, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
@@ -699,7 +697,7 @@ static const struct reg_value ov5640_setting_15fps_QSXGA_2592_1944[] = {
 
 /* power-on sensor init reg table */
 static const struct ov5640_mode_info ov5640_mode_init_data = {
-	0, SUBSAMPLING, 640, 1896, 480, 984,
+	0, SUBSAMPLING, 0, 640, 1896, 480, 984,
 	ov5640_init_setting_30fps_VGA,
 	ARRAY_SIZE(ov5640_init_setting_30fps_VGA),
 };
@@ -707,76 +705,76 @@ static const struct ov5640_mode_info ov5640_mode_init_data = {
 static const struct ov5640_mode_info
 ov5640_mode_data[OV5640_NUM_FRAMERATES][OV5640_NUM_MODES] = {
 	{
-		{OV5640_MODE_QCIF_176_144, SUBSAMPLING,
+		{OV5640_MODE_QCIF_176_144, SUBSAMPLING, 1,
 		 176, 1896, 144, 984,
 		 ov5640_setting_15fps_QCIF_176_144,
 		 ARRAY_SIZE(ov5640_setting_15fps_QCIF_176_144)},
-		{OV5640_MODE_QVGA_320_240, SUBSAMPLING,
+		{OV5640_MODE_QVGA_320_240, SUBSAMPLING, 1,
 		 320, 1896, 240, 984,
 		 ov5640_setting_15fps_QVGA_320_240,
 		 ARRAY_SIZE(ov5640_setting_15fps_QVGA_320_240)},
-		{OV5640_MODE_VGA_640_480, SUBSAMPLING,
+		{OV5640_MODE_VGA_640_480, SUBSAMPLING, 1,
 		 640, 1896, 480, 1080,
 		 ov5640_setting_15fps_VGA_640_480,
 		 ARRAY_SIZE(ov5640_setting_15fps_VGA_640_480)},
-		{OV5640_MODE_NTSC_720_480, SUBSAMPLING,
+		{OV5640_MODE_NTSC_720_480, SUBSAMPLING, 1,
 		 720, 1896, 480, 984,
 		 ov5640_setting_15fps_NTSC_720_480,
 		 ARRAY_SIZE(ov5640_setting_15fps_NTSC_720_480)},
-		{OV5640_MODE_PAL_720_576, SUBSAMPLING,
+		{OV5640_MODE_PAL_720_576, SUBSAMPLING, 1,
 		 720, 1896, 576, 984,
 		 ov5640_setting_15fps_PAL_720_576,
 		 ARRAY_SIZE(ov5640_setting_15fps_PAL_720_576)},
-		{OV5640_MODE_XGA_1024_768, SUBSAMPLING,
+		{OV5640_MODE_XGA_1024_768, SUBSAMPLING, 1,
 		 1024, 1896, 768, 1080,
 		 ov5640_setting_15fps_XGA_1024_768,
 		 ARRAY_SIZE(ov5640_setting_15fps_XGA_1024_768)},
-		{OV5640_MODE_720P_1280_720, SUBSAMPLING,
+		{OV5640_MODE_720P_1280_720, SUBSAMPLING, 0,
 		 1280, 1892, 720, 740,
 		 ov5640_setting_15fps_720P_1280_720,
 		 ARRAY_SIZE(ov5640_setting_15fps_720P_1280_720)},
-		{OV5640_MODE_1080P_1920_1080, SCALING,
+		{OV5640_MODE_1080P_1920_1080, SCALING, 0,
 		 1920, 2500, 1080, 1120,
 		 ov5640_setting_15fps_1080P_1920_1080,
 		 ARRAY_SIZE(ov5640_setting_15fps_1080P_1920_1080)},
-		{OV5640_MODE_QSXGA_2592_1944, SCALING,
+		{OV5640_MODE_QSXGA_2592_1944, SCALING, 0,
 		 2592, 2844, 1944, 1968,
 		 ov5640_setting_15fps_QSXGA_2592_1944,
 		 ARRAY_SIZE(ov5640_setting_15fps_QSXGA_2592_1944)},
 	}, {
-		{OV5640_MODE_QCIF_176_144, SUBSAMPLING,
+		{OV5640_MODE_QCIF_176_144, SUBSAMPLING, 1,
 		 176, 1896, 144, 984,
 		 ov5640_setting_30fps_QCIF_176_144,
 		 ARRAY_SIZE(ov5640_setting_30fps_QCIF_176_144)},
-		{OV5640_MODE_QVGA_320_240, SUBSAMPLING,
+		{OV5640_MODE_QVGA_320_240, SUBSAMPLING, 1,
 		 320, 1896, 240, 984,
 		 ov5640_setting_30fps_QVGA_320_240,
 		 ARRAY_SIZE(ov5640_setting_30fps_QVGA_320_240)},
-		{OV5640_MODE_VGA_640_480, SUBSAMPLING,
+		{OV5640_MODE_VGA_640_480, SUBSAMPLING, 1,
 		 640, 1896, 480, 1080,
 		 ov5640_setting_30fps_VGA_640_480,
 		 ARRAY_SIZE(ov5640_setting_30fps_VGA_640_480)},
-		{OV5640_MODE_NTSC_720_480, SUBSAMPLING,
+		{OV5640_MODE_NTSC_720_480, SUBSAMPLING, 1,
 		 720, 1896, 480, 984,
 		 ov5640_setting_30fps_NTSC_720_480,
 		 ARRAY_SIZE(ov5640_setting_30fps_NTSC_720_480)},
-		{OV5640_MODE_PAL_720_576, SUBSAMPLING,
+		{OV5640_MODE_PAL_720_576, SUBSAMPLING, 1,
 		 720, 1896, 576, 984,
 		 ov5640_setting_30fps_PAL_720_576,
 		 ARRAY_SIZE(ov5640_setting_30fps_PAL_720_576)},
-		{OV5640_MODE_XGA_1024_768, SUBSAMPLING,
+		{OV5640_MODE_XGA_1024_768, SUBSAMPLING, 1,
 		 1024, 1896, 768, 1080,
 		 ov5640_setting_30fps_XGA_1024_768,
 		 ARRAY_SIZE(ov5640_setting_30fps_XGA_1024_768)},
-		{OV5640_MODE_720P_1280_720, SUBSAMPLING,
+		{OV5640_MODE_720P_1280_720, SUBSAMPLING, 0,
 		 1280, 1892, 720, 740,
 		 ov5640_setting_30fps_720P_1280_720,
 		 ARRAY_SIZE(ov5640_setting_30fps_720P_1280_720)},
-		{OV5640_MODE_1080P_1920_1080, SCALING,
+		{OV5640_MODE_1080P_1920_1080, SCALING, 0,
 		 1920, 2500, 1080, 1120,
 		 ov5640_setting_30fps_1080P_1920_1080,
 		 ARRAY_SIZE(ov5640_setting_30fps_1080P_1920_1080)},
-		{OV5640_MODE_QSXGA_2592_1944, -1, 0, 0, 0, 0, NULL, 0},
+		{OV5640_MODE_QSXGA_2592_1944, -1, 0, 0, 0, 0, 0, NULL, 0},
 	},
 };
 
@@ -909,6 +907,232 @@ static int ov5640_mod_reg(struct ov5640_dev *sensor, u16 reg,
 	return ov5640_write_reg(sensor, reg, val);
 }
 
+/*
+ *
+ * The current best guess of the clock tree, as reverse engineered by several
+ * people on the media mailing list:
+ *
+ *   +--------------+
+ *   |  Ext. Clock  |
+ *   +------+-------+
+ *          |
+ *   +------+-------+ - reg 0x3037[3:0] for the pre-divider
+ *   | System PLL   | - reg 0x3036 for the multiplier
+ *   +--+-----------+ - reg 0x3035[7:4] for the system divider
+ *      |
+ *      |   +--------------+
+ *      |---+  MIPI Rate   | - reg 0x3035[3:0] for the MIPI root divider
+ *      |   +--------------+
+ *      |
+ *   +--+-----------+
+ *   | PLL Root Div | - (reg 0x3037[4])+1 for the root divider
+ *   +--+-----------+
+ *          |
+ *   +------+-------+
+ *   | MIPI Bit Div | - reg 0x3034[3:0]/4 for divider when in MIPI mode, else 1
+ *   +--+-----------+
+ *      |
+ *      |   +--------------+
+ *      |---+     SCLK     | - log2(reg 0x3108[1:0]) for the root divider
+ *      |   +--------------+
+ *      |
+ *   +--+-----------+ - reg 0x3035[3:0] for the MIPI root divider
+ *   |    PCLK      | - log2(reg 0x3108[5:4]) for the DVP root divider
+ *   +--------------+
+ *
+ * Not all limitations of register values are documented above, see ov5640
+ * datasheet.
+ *
+ * In order for the sensor to operate correctly the ratio of
+ * SCLK:PCLK:MIPI RATE must be 1:2:8 when the scalar in the ISP is not
+ * enabled, and 1:1:4 when it is enabled (MIPI rate doesn't matter in DVP mode).
+ * The ratio of these different clocks is maintained by the constant div values
+ * below, with PCLK div being selected based on if the mode is using the scalar.
+ */
+
+/*
+ * This is supposed to be ranging from 1 to 16, but the value is
+ * always set to either 1 or 2 in the vendor kernels.
+ */
+#define OV5640_SYSDIV_MIN	1
+#define OV5640_SYSDIV_MAX	12
+
+/*
+ *This is supposed to be ranging from 4-252, but must be even when >127
+ */
+#define OV5640_PLL_MULT_MIN	4
+#define OV5640_PLL_MULT_MAX	252
+
+/*
+ * This is supposed to be ranging from 1 to 2, but the value is always
+ * set to 1 in the vendor kernels.
+ */
+#define OV5640_PLL_DVP_ROOT_DIV		1
+#define OV5640_PLL_MIPI_ROOT_DIV	2
+
+/*
+ * This is supposed to be ranging from 1 to 8, but the value is always
+ * set to 2 in the vendor kernels.
+ */
+#define OV5640_SCLK_ROOT_DIV	2
+
+/*
+ * This is equal to the MIPI bit rate divided by 4. Now it is hardcoded to
+ * only work with 8-bit formats, so this value will need to be set in
+ * software if support for 10-bit formats is added. The bit divider is
+ * only active when in MIPI mode (not DVP)
+ */
+#define OV5640_BIT_DIV		2
+
+static unsigned long ov5640_compute_sclk(struct ov5640_dev *sensor,
+					 u8 sys_div, u8 pll_prediv,
+					 u8 pll_mult, u8 pll_div,
+					 u8 sclk_div)
+{
+	unsigned long rate = clk_get_rate(sensor->xclk);
+
+	rate = rate / pll_prediv * pll_mult / sys_div / pll_div;
+	if (sensor->ep.bus_type == V4L2_MBUS_CSI2_DPHY)
+		rate = rate / OV5640_BIT_DIV;
+
+	return rate / sclk_div;
+}
+
+static unsigned long ov5640_calc_sclk(struct ov5640_dev *sensor,
+				      unsigned long rate,
+				      u8 *sysdiv, u8 *prediv, u8 pll_rdiv,
+				      u8 *mult, u8 *sclk_rdiv)
+{
+	unsigned long best = ~0;
+	u8 best_sysdiv = 1, best_mult = 1;
+	u8 _sysdiv, _pll_mult, _prediv, pll_min, pll_max;
+	unsigned long xclk = clk_get_rate(sensor->xclk);
+
+	/* Choose prediv to clamp input clock to 4.5-9MHz */
+	if (xclk < 36000000)
+		_prediv = (xclk/9000000)+1;
+	else
+		_prediv = 6;
+
+	/* Calculate min and max PLL mult given 500MHz<VCO<1000MHZ */
+	pll_min = 500000000 / (xclk/_prediv);
+	if (pll_min < OV5640_PLL_MULT_MIN)
+		pll_min = OV5640_PLL_MULT_MIN;
+	pll_max = 1000000000 / (xclk/_prediv);
+	if (pll_max < OV5640_PLL_MULT_MAX)
+		pll_max = OV5640_PLL_MULT_MAX;
+
+	for (_sysdiv = OV5640_SYSDIV_MIN;
+	     _sysdiv <= OV5640_SYSDIV_MAX;
+	     _sysdiv++) {
+		for (_pll_mult = pll_min;
+		     _pll_mult <= pll_max;
+		     _pll_mult++) {
+			unsigned long _rate;
+
+			/*
+			 * The PLL multiplier cannot be odd if above
+			 * 127.
+			 */
+			if (_pll_mult > 127 && (_pll_mult % 2))
+				continue;
+
+			_rate = ov5640_compute_sclk(sensor, _sysdiv,
+						    _prediv,
+						    _pll_mult,
+						    pll_rdiv,
+						    OV5640_SCLK_ROOT_DIV);
+
+			if (abs(rate - _rate) < abs(rate - best)) {
+				best = _rate;
+				best_sysdiv = _sysdiv;
+				best_mult = _pll_mult;
+			}
+
+			if (_rate == rate)
+				goto out;
+			if (_rate > rate)
+				break;
+		}
+	}
+
+out:
+	*sysdiv = best_sysdiv;
+	*prediv = _prediv;
+	*mult = best_mult;
+	*sclk_rdiv = OV5640_SCLK_ROOT_DIV;
+	return best;
+}
+
+static int ov5640_set_sclk(struct ov5640_dev *sensor,
+			   const struct ov5640_mode_info *mode)
+{
+	u8 sysdiv, prediv, mult, pll_rdiv, sclk_rdiv, mipi_div;
+	u8 pclk_period, pclk_div;
+	int ret;
+	unsigned long sclk, rate, pclk;
+	unsigned char bpp;
+
+	/*
+	 * All the formats we support have 2 bytes per pixel, except for JPEG
+	 * which is 1 byte per pixel.
+	 */
+	bpp = sensor->fmt.code == MEDIA_BUS_FMT_JPEG_1X8 ? 1 : 2;
+	rate = mode->vtot * mode->htot * bpp;
+	rate *= ov5640_framerates[sensor->current_fr];
+
+	if (sensor->ep.bus_type == V4L2_MBUS_CSI2_DPHY)
+		rate = rate / sensor->ep.bus.mipi_csi2.num_data_lanes;
+
+	pll_rdiv = (sensor->ep.bus_type == V4L2_MBUS_CSI2_DPHY) ?
+		   OV5640_PLL_MIPI_ROOT_DIV : OV5640_PLL_DVP_ROOT_DIV;
+
+	sclk = ov5640_calc_sclk(sensor, rate, &sysdiv, &prediv, pll_rdiv,
+				&mult, &sclk_rdiv);
+
+	if (sensor->ep.bus_type == V4L2_MBUS_CSI2_DPHY) {
+		mipi_div = (sensor->current_mode->scaler) ? 2 : 1;
+		pclk_div = 1;
+
+		/*
+		 * Calculate pclk period * number of CSI2 lanes in ns for MIPI
+		 * timing.
+		 */
+		pclk = sclk * sclk_rdiv / mipi_div;
+		pclk_period = (u8) ((1000000000UL + pclk/2UL) / pclk);
+		pclk_period = pclk_period *
+			      sensor->ep.bus.mipi_csi2.num_data_lanes;
+		ret = ov5640_write_reg(sensor, OV5640_REG_PCLK_PERIOD,
+				    pclk_period);
+		if (ret)
+			return ret;
+	} else {
+		mipi_div = 1;
+		pclk_div = (sensor->current_mode->scaler) ? 2 : 1;
+	}
+
+	ret = ov5640_mod_reg(sensor, OV5640_REG_SC_PLL_CTRL1,
+			     0xff, (sysdiv << 4) | (mipi_div & 0x0f));
+	if (ret)
+		return ret;
+
+	ret = ov5640_mod_reg(sensor, OV5640_REG_SC_PLL_CTRL2,
+			     0xff, mult);
+	if (ret)
+		return ret;
+
+	ret = ov5640_mod_reg(sensor, OV5640_REG_SC_PLL_CTRL3,
+			     0x1f, prediv | ((pll_rdiv - 1) << 4));
+	if (ret)
+		return ret;
+
+	return ov5640_mod_reg(sensor, OV5640_REG_SYS_ROOT_DIVIDER, 0x3F,
+			      (ilog2(pclk_div) << 4) |
+			      (ilog2(sclk_rdiv/2) << 2) |
+			      ilog2(sclk_rdiv));
+}
+
+
 /* download ov5640 settings to sensor through i2c */
 static int ov5640_set_timings(struct ov5640_dev *sensor,
 			      const struct ov5640_mode_info *mode)
@@ -1502,6 +1726,11 @@ static int ov5640_set_mode_exposure_calc(struct ov5640_dev *sensor,
 	if (ret < 0)
 		return ret;
 
+	/* Set PLL registers for new mode */
+	ret = ov5640_set_sclk(sensor, mode);
+	if (ret < 0)
+		return ret;
+
 	/* Write capture setting */
 	ret = ov5640_load_regs(sensor, mode);
 	if (ret < 0)
@@ -1623,9 +1852,16 @@ static int ov5640_set_mode_exposure_calc(struct ov5640_dev *sensor,
 static int ov5640_set_mode_direct(struct ov5640_dev *sensor,
 				  const struct ov5640_mode_info *mode)
 {
+	int ret;
+
 	if (!mode->reg_data)
 		return -EINVAL;
 
+	/* Set PLL registers for new mode */
+	ret = ov5640_set_sclk(sensor, mode);
+	if (ret < 0)
+		return ret;
+
 	/* Write capture setting */
 	return ov5640_load_regs(sensor, mode);
 }
@@ -1723,12 +1959,6 @@ static int ov5640_restore_mode(struct ov5640_dev *sensor)
 		return ret;
 	sensor->last_mode = &ov5640_mode_init_data;
 
-	ret = ov5640_mod_reg(sensor, OV5640_REG_SYS_ROOT_DIVIDER, 0x3f,
-			     (ilog2(OV5640_SCLK2X_ROOT_DIVIDER_DEFAULT) << 2) |
-			     ilog2(OV5640_SCLK_ROOT_DIVIDER_DEFAULT));
-	if (ret)
-		return ret;
-
 	/* now restore the last capture mode */
 	ret = ov5640_set_mode(sensor);
 	if (ret < 0)
-- 
2.7.4
