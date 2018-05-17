Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:43876 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751647AbeEQIyL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 04:54:11 -0400
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
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH v3 08/12] media: ov5640: Enhance FPS handling
Date: Thu, 17 May 2018 10:54:01 +0200
Message-Id: <20180517085405.10104-9-maxime.ripard@bootlin.com>
In-Reply-To: <20180517085405.10104-1-maxime.ripard@bootlin.com>
References: <20180517085405.10104-1-maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that we have moved the clock generation logic out of the bytes array,
these arrays are identical between the 15fps and 30fps variants.

Remove the duplicate entries, and convert the code accordingly.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/media/i2c/ov5640.c | 316 +++++++------------------------------
 1 file changed, 60 insertions(+), 256 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 48f3c9e640ed..785a692946b6 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -334,64 +334,7 @@ static const struct reg_value ov5640_init_setting_30fps_VGA[] = {
 	{0x3a1f, 0x14, 0, 0}, {0x3008, 0x02, 0, 0}, {0x3c00, 0x04, 0, 300},
 };
 
-static const struct reg_value ov5640_setting_30fps_VGA_640_480[] = {
-	{0x3c07, 0x08, 0, 0},
-	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
-	{0x3820, 0x41, 0, 0}, {0x3821, 0x07, 0, 0}, {0x3814, 0x31, 0, 0},
-	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
-	{0x3802, 0x00, 0, 0}, {0x3803, 0x04, 0, 0}, {0x3804, 0x0a, 0, 0},
-	{0x3805, 0x3f, 0, 0}, {0x3806, 0x07, 0, 0}, {0x3807, 0x9b, 0, 0},
-	{0x3810, 0x00, 0, 0},
-	{0x3811, 0x10, 0, 0}, {0x3812, 0x00, 0, 0}, {0x3813, 0x06, 0, 0},
-	{0x3618, 0x00, 0, 0}, {0x3612, 0x29, 0, 0}, {0x3708, 0x64, 0, 0},
-	{0x3709, 0x52, 0, 0}, {0x370c, 0x03, 0, 0}, {0x3a02, 0x03, 0, 0},
-	{0x3a03, 0xd8, 0, 0}, {0x3a08, 0x01, 0, 0}, {0x3a09, 0x0e, 0, 0},
-	{0x3a0a, 0x00, 0, 0}, {0x3a0b, 0xf6, 0, 0}, {0x3a0e, 0x03, 0, 0},
-	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
-	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x4713, 0x03, 0, 0},
-	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
-	{0x3824, 0x02, 0, 0}, {0x5001, 0xa3, 0, 0}, {0x3503, 0x00, 0, 0},
-};
-
-static const struct reg_value ov5640_setting_15fps_VGA_640_480[] = {
-	{0x3c07, 0x08, 0, 0},
-	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
-	{0x3820, 0x41, 0, 0}, {0x3821, 0x07, 0, 0}, {0x3814, 0x31, 0, 0},
-	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
-	{0x3802, 0x00, 0, 0}, {0x3803, 0x04, 0, 0}, {0x3804, 0x0a, 0, 0},
-	{0x3805, 0x3f, 0, 0}, {0x3806, 0x07, 0, 0}, {0x3807, 0x9b, 0, 0},
-	{0x3810, 0x00, 0, 0},
-	{0x3811, 0x10, 0, 0}, {0x3812, 0x00, 0, 0}, {0x3813, 0x06, 0, 0},
-	{0x3618, 0x00, 0, 0}, {0x3612, 0x29, 0, 0}, {0x3708, 0x64, 0, 0},
-	{0x3709, 0x52, 0, 0}, {0x370c, 0x03, 0, 0}, {0x3a02, 0x03, 0, 0},
-	{0x3a03, 0xd8, 0, 0}, {0x3a08, 0x01, 0, 0}, {0x3a09, 0x27, 0, 0},
-	{0x3a0a, 0x00, 0, 0}, {0x3a0b, 0xf6, 0, 0}, {0x3a0e, 0x03, 0, 0},
-	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
-	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x4713, 0x03, 0, 0},
-	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
-	{0x3824, 0x02, 0, 0}, {0x5001, 0xa3, 0, 0},
-};
-
-static const struct reg_value ov5640_setting_30fps_XGA_1024_768[] = {
-	{0x3c07, 0x08, 0, 0},
-	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
-	{0x3820, 0x41, 0, 0}, {0x3821, 0x07, 0, 0}, {0x3814, 0x31, 0, 0},
-	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
-	{0x3802, 0x00, 0, 0}, {0x3803, 0x04, 0, 0}, {0x3804, 0x0a, 0, 0},
-	{0x3805, 0x3f, 0, 0}, {0x3806, 0x07, 0, 0}, {0x3807, 0x9b, 0, 0},
-	{0x3810, 0x00, 0, 0},
-	{0x3811, 0x10, 0, 0}, {0x3812, 0x00, 0, 0}, {0x3813, 0x06, 0, 0},
-	{0x3618, 0x00, 0, 0}, {0x3612, 0x29, 0, 0}, {0x3708, 0x64, 0, 0},
-	{0x3709, 0x52, 0, 0}, {0x370c, 0x03, 0, 0}, {0x3a02, 0x03, 0, 0},
-	{0x3a03, 0xd8, 0, 0}, {0x3a08, 0x01, 0, 0}, {0x3a09, 0x0e, 0, 0},
-	{0x3a0a, 0x00, 0, 0}, {0x3a0b, 0xf6, 0, 0}, {0x3a0e, 0x03, 0, 0},
-	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
-	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x4713, 0x03, 0, 0},
-	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
-	{0x3824, 0x02, 0, 0}, {0x5001, 0xa3, 0, 0}, {0x3503, 0x00, 0, 0},
-};
-
-static const struct reg_value ov5640_setting_15fps_XGA_1024_768[] = {
+static const struct reg_value ov5640_setting_VGA_640_480[] = {
 	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3820, 0x41, 0, 0}, {0x3821, 0x07, 0, 0}, {0x3814, 0x31, 0, 0},
@@ -410,7 +353,7 @@ static const struct reg_value ov5640_setting_15fps_XGA_1024_768[] = {
 	{0x3824, 0x02, 0, 0}, {0x5001, 0xa3, 0, 0},
 };
 
-static const struct reg_value ov5640_setting_30fps_QVGA_320_240[] = {
+static const struct reg_value ov5640_setting_XGA_1024_768[] = {
 	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3820, 0x41, 0, 0}, {0x3821, 0x07, 0, 0}, {0x3814, 0x31, 0, 0},
@@ -429,7 +372,7 @@ static const struct reg_value ov5640_setting_30fps_QVGA_320_240[] = {
 	{0x3824, 0x02, 0, 0}, {0x5001, 0xa3, 0, 0},
 };
 
-static const struct reg_value ov5640_setting_15fps_QVGA_320_240[] = {
+static const struct reg_value ov5640_setting_QVGA_320_240[] = {
 	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3820, 0x41, 0, 0}, {0x3821, 0x07, 0, 0}, {0x3814, 0x31, 0, 0},
@@ -448,7 +391,7 @@ static const struct reg_value ov5640_setting_15fps_QVGA_320_240[] = {
 	{0x3824, 0x02, 0, 0}, {0x5001, 0xa3, 0, 0},
 };
 
-static const struct reg_value ov5640_setting_30fps_QCIF_176_144[] = {
+static const struct reg_value ov5640_setting_QCIF_176_144[] = {
 	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3820, 0x41, 0, 0}, {0x3821, 0x07, 0, 0}, {0x3814, 0x31, 0, 0},
@@ -467,26 +410,7 @@ static const struct reg_value ov5640_setting_30fps_QCIF_176_144[] = {
 	{0x3824, 0x02, 0, 0}, {0x5001, 0xa3, 0, 0},
 };
 
-static const struct reg_value ov5640_setting_15fps_QCIF_176_144[] = {
-	{0x3c07, 0x08, 0, 0},
-	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
-	{0x3820, 0x41, 0, 0}, {0x3821, 0x07, 0, 0}, {0x3814, 0x31, 0, 0},
-	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
-	{0x3802, 0x00, 0, 0}, {0x3803, 0x04, 0, 0}, {0x3804, 0x0a, 0, 0},
-	{0x3805, 0x3f, 0, 0}, {0x3806, 0x07, 0, 0}, {0x3807, 0x9b, 0, 0},
-	{0x3810, 0x00, 0, 0},
-	{0x3811, 0x10, 0, 0}, {0x3812, 0x00, 0, 0}, {0x3813, 0x06, 0, 0},
-	{0x3618, 0x00, 0, 0}, {0x3612, 0x29, 0, 0}, {0x3708, 0x64, 0, 0},
-	{0x3709, 0x52, 0, 0}, {0x370c, 0x03, 0, 0}, {0x3a02, 0x03, 0, 0},
-	{0x3a03, 0xd8, 0, 0}, {0x3a08, 0x01, 0, 0}, {0x3a09, 0x27, 0, 0},
-	{0x3a0a, 0x00, 0, 0}, {0x3a0b, 0xf6, 0, 0}, {0x3a0e, 0x03, 0, 0},
-	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
-	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x4713, 0x03, 0, 0},
-	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
-	{0x3824, 0x02, 0, 0}, {0x5001, 0xa3, 0, 0},
-};
-
-static const struct reg_value ov5640_setting_30fps_NTSC_720_480[] = {
+static const struct reg_value ov5640_setting_NTSC_720_480[] = {
 	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3820, 0x41, 0, 0}, {0x3821, 0x07, 0, 0}, {0x3814, 0x31, 0, 0},
@@ -505,26 +429,7 @@ static const struct reg_value ov5640_setting_30fps_NTSC_720_480[] = {
 	{0x3824, 0x02, 0, 0}, {0x5001, 0xa3, 0, 0},
 };
 
-static const struct reg_value ov5640_setting_15fps_NTSC_720_480[] = {
-	{0x3c07, 0x08, 0, 0},
-	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
-	{0x3820, 0x41, 0, 0}, {0x3821, 0x07, 0, 0}, {0x3814, 0x31, 0, 0},
-	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
-	{0x3802, 0x00, 0, 0}, {0x3803, 0x04, 0, 0}, {0x3804, 0x0a, 0, 0},
-	{0x3805, 0x3f, 0, 0}, {0x3806, 0x07, 0, 0}, {0x3807, 0x9b, 0, 0},
-	{0x3810, 0x00, 0, 0},
-	{0x3811, 0x10, 0, 0}, {0x3812, 0x00, 0, 0}, {0x3813, 0x3c, 0, 0},
-	{0x3618, 0x00, 0, 0}, {0x3612, 0x29, 0, 0}, {0x3708, 0x64, 0, 0},
-	{0x3709, 0x52, 0, 0}, {0x370c, 0x03, 0, 0}, {0x3a02, 0x03, 0, 0},
-	{0x3a03, 0xd8, 0, 0}, {0x3a08, 0x01, 0, 0}, {0x3a09, 0x27, 0, 0},
-	{0x3a0a, 0x00, 0, 0}, {0x3a0b, 0xf6, 0, 0}, {0x3a0e, 0x03, 0, 0},
-	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
-	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x4713, 0x03, 0, 0},
-	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
-	{0x3824, 0x02, 0, 0}, {0x5001, 0xa3, 0, 0},
-};
-
-static const struct reg_value ov5640_setting_30fps_PAL_720_576[] = {
+static const struct reg_value ov5640_setting_PAL_720_576[] = {
 	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3820, 0x41, 0, 0}, {0x3821, 0x07, 0, 0}, {0x3814, 0x31, 0, 0},
@@ -543,47 +448,7 @@ static const struct reg_value ov5640_setting_30fps_PAL_720_576[] = {
 	{0x3824, 0x02, 0, 0}, {0x5001, 0xa3, 0, 0},
 };
 
-static const struct reg_value ov5640_setting_15fps_PAL_720_576[] = {
-	{0x3c07, 0x08, 0, 0},
-	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
-	{0x3820, 0x41, 0, 0}, {0x3821, 0x07, 0, 0}, {0x3814, 0x31, 0, 0},
-	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
-	{0x3802, 0x00, 0, 0}, {0x3803, 0x04, 0, 0}, {0x3804, 0x0a, 0, 0},
-	{0x3805, 0x3f, 0, 0}, {0x3806, 0x07, 0, 0}, {0x3807, 0x9b, 0, 0},
-	{0x3810, 0x00, 0, 0},
-	{0x3811, 0x38, 0, 0}, {0x3812, 0x00, 0, 0}, {0x3813, 0x06, 0, 0},
-	{0x3618, 0x00, 0, 0}, {0x3612, 0x29, 0, 0}, {0x3708, 0x64, 0, 0},
-	{0x3709, 0x52, 0, 0}, {0x370c, 0x03, 0, 0}, {0x3a02, 0x03, 0, 0},
-	{0x3a03, 0xd8, 0, 0}, {0x3a08, 0x01, 0, 0}, {0x3a09, 0x27, 0, 0},
-	{0x3a0a, 0x00, 0, 0}, {0x3a0b, 0xf6, 0, 0}, {0x3a0e, 0x03, 0, 0},
-	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
-	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x4713, 0x03, 0, 0},
-	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
-	{0x3824, 0x02, 0, 0}, {0x5001, 0xa3, 0, 0},
-};
-
-static const struct reg_value ov5640_setting_30fps_720P_1280_720[] = {
-	{0x3008, 0x42, 0, 0},
-	{0x3c07, 0x07, 0, 0},
-	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
-	{0x3820, 0x41, 0, 0}, {0x3821, 0x07, 0, 0}, {0x3814, 0x31, 0, 0},
-	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
-	{0x3802, 0x00, 0, 0}, {0x3803, 0xfa, 0, 0}, {0x3804, 0x0a, 0, 0},
-	{0x3805, 0x3f, 0, 0}, {0x3806, 0x06, 0, 0}, {0x3807, 0xa9, 0, 0},
-	{0x3810, 0x00, 0, 0},
-	{0x3811, 0x10, 0, 0}, {0x3812, 0x00, 0, 0}, {0x3813, 0x04, 0, 0},
-	{0x3618, 0x00, 0, 0}, {0x3612, 0x29, 0, 0}, {0x3708, 0x64, 0, 0},
-	{0x3709, 0x52, 0, 0}, {0x370c, 0x03, 0, 0}, {0x3a02, 0x02, 0, 0},
-	{0x3a03, 0xe4, 0, 0}, {0x3a08, 0x01, 0, 0}, {0x3a09, 0xbc, 0, 0},
-	{0x3a0a, 0x01, 0, 0}, {0x3a0b, 0x72, 0, 0}, {0x3a0e, 0x01, 0, 0},
-	{0x3a0d, 0x02, 0, 0}, {0x3a14, 0x02, 0, 0}, {0x3a15, 0xe4, 0, 0},
-	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x4713, 0x02, 0, 0},
-	{0x4407, 0x04, 0, 0}, {0x460b, 0x37, 0, 0}, {0x460c, 0x20, 0, 0},
-	{0x3824, 0x04, 0, 0}, {0x5001, 0x83, 0, 0}, {0x4005, 0x1a, 0, 0},
-	{0x3008, 0x02, 0, 0}, {0x3503, 0,    0, 0},
-};
-
-static const struct reg_value ov5640_setting_15fps_720P_1280_720[] = {
+static const struct reg_value ov5640_setting_720P_1280_720[] = {
 	{0x3c07, 0x07, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
 	{0x3820, 0x41, 0, 0}, {0x3821, 0x07, 0, 0}, {0x3814, 0x31, 0, 0},
@@ -602,40 +467,7 @@ static const struct reg_value ov5640_setting_15fps_720P_1280_720[] = {
 	{0x3824, 0x04, 0, 0}, {0x5001, 0x83, 0, 0},
 };
 
-static const struct reg_value ov5640_setting_30fps_1080P_1920_1080[] = {
-	{0x3008, 0x42, 0, 0},
-	{0x3c07, 0x08, 0, 0},
-	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
-	{0x3820, 0x40, 0, 0}, {0x3821, 0x06, 0, 0}, {0x3814, 0x11, 0, 0},
-	{0x3815, 0x11, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
-	{0x3802, 0x00, 0, 0}, {0x3803, 0x00, 0, 0}, {0x3804, 0x0a, 0, 0},
-	{0x3805, 0x3f, 0, 0}, {0x3806, 0x07, 0, 0}, {0x3807, 0x9f, 0, 0},
-	{0x3810, 0x00, 0, 0},
-	{0x3811, 0x10, 0, 0}, {0x3812, 0x00, 0, 0}, {0x3813, 0x04, 0, 0},
-	{0x3618, 0x04, 0, 0}, {0x3612, 0x29, 0, 0}, {0x3708, 0x21, 0, 0},
-	{0x3709, 0x12, 0, 0}, {0x370c, 0x00, 0, 0}, {0x3a02, 0x03, 0, 0},
-	{0x3a03, 0xd8, 0, 0}, {0x3a08, 0x01, 0, 0}, {0x3a09, 0x27, 0, 0},
-	{0x3a0a, 0x00, 0, 0}, {0x3a0b, 0xf6, 0, 0}, {0x3a0e, 0x03, 0, 0},
-	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
-	{0x4001, 0x02, 0, 0}, {0x4004, 0x06, 0, 0}, {0x4713, 0x03, 0, 0},
-	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
-	{0x3824, 0x02, 0, 0}, {0x5001, 0x83, 0, 0},
-	{0x3c07, 0x07, 0, 0}, {0x3c08, 0x00, 0, 0},
-	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
-	{0x3800, 0x01, 0, 0}, {0x3801, 0x50, 0, 0}, {0x3802, 0x01, 0, 0},
-	{0x3803, 0xb2, 0, 0}, {0x3804, 0x08, 0, 0}, {0x3805, 0xef, 0, 0},
-	{0x3806, 0x05, 0, 0}, {0x3807, 0xf1, 0, 0},
-	{0x3612, 0x2b, 0, 0}, {0x3708, 0x64, 0, 0},
-	{0x3a02, 0x04, 0, 0}, {0x3a03, 0x60, 0, 0}, {0x3a08, 0x01, 0, 0},
-	{0x3a09, 0x50, 0, 0}, {0x3a0a, 0x01, 0, 0}, {0x3a0b, 0x18, 0, 0},
-	{0x3a0e, 0x03, 0, 0}, {0x3a0d, 0x04, 0, 0}, {0x3a14, 0x04, 0, 0},
-	{0x3a15, 0x60, 0, 0}, {0x4713, 0x02, 0, 0}, {0x4407, 0x04, 0, 0},
-	{0x460b, 0x37, 0, 0}, {0x460c, 0x20, 0, 0}, {0x3824, 0x04, 0, 0},
-	{0x4005, 0x1a, 0, 0}, {0x3008, 0x02, 0, 0},
-	{0x3503, 0, 0, 0},
-};
-
-static const struct reg_value ov5640_setting_15fps_1080P_1920_1080[] = {
+static const struct reg_value ov5640_setting_1080P_1920_1080[] = {
 	{0x3008, 0x42, 0, 0},
 	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
@@ -667,7 +499,7 @@ static const struct reg_value ov5640_setting_15fps_1080P_1920_1080[] = {
 	{0x4005, 0x1a, 0, 0}, {0x3008, 0x02, 0, 0}, {0x3503, 0, 0, 0},
 };
 
-static const struct reg_value ov5640_setting_15fps_QSXGA_2592_1944[] = {
+static const struct reg_value ov5640_setting_QSXGA_2592_1944[] = {
 	{0x3820, 0x40, 0, 0}, {0x3821, 0x06, 0, 0},
 	{0x3c07, 0x08, 0, 0},
 	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
@@ -695,79 +527,43 @@ static const struct ov5640_mode_info ov5640_mode_init_data = {
 };
 
 static const struct ov5640_mode_info
-ov5640_mode_data[OV5640_NUM_FRAMERATES][OV5640_NUM_MODES] = {
-	{
-		{OV5640_MODE_QCIF_176_144, SUBSAMPLING,
-		 176, 1896, 144, 984,
-		 ov5640_setting_15fps_QCIF_176_144,
-		 ARRAY_SIZE(ov5640_setting_15fps_QCIF_176_144)},
-		{OV5640_MODE_QVGA_320_240, SUBSAMPLING,
-		 320, 1896, 240, 984,
-		 ov5640_setting_15fps_QVGA_320_240,
-		 ARRAY_SIZE(ov5640_setting_15fps_QVGA_320_240)},
-		{OV5640_MODE_VGA_640_480, SUBSAMPLING,
-		 640, 1896, 480, 1080,
-		 ov5640_setting_15fps_VGA_640_480,
-		 ARRAY_SIZE(ov5640_setting_15fps_VGA_640_480)},
-		{OV5640_MODE_NTSC_720_480, SUBSAMPLING,
-		 720, 1896, 480, 984,
-		 ov5640_setting_15fps_NTSC_720_480,
-		 ARRAY_SIZE(ov5640_setting_15fps_NTSC_720_480)},
-		{OV5640_MODE_PAL_720_576, SUBSAMPLING,
-		 720, 1896, 576, 984,
-		 ov5640_setting_15fps_PAL_720_576,
-		 ARRAY_SIZE(ov5640_setting_15fps_PAL_720_576)},
-		{OV5640_MODE_XGA_1024_768, SUBSAMPLING,
-		 1024, 1896, 768, 1080,
-		 ov5640_setting_15fps_XGA_1024_768,
-		 ARRAY_SIZE(ov5640_setting_15fps_XGA_1024_768)},
-		{OV5640_MODE_720P_1280_720, SUBSAMPLING,
-		 1280, 1892, 720, 740,
-		 ov5640_setting_15fps_720P_1280_720,
-		 ARRAY_SIZE(ov5640_setting_15fps_720P_1280_720)},
-		{OV5640_MODE_1080P_1920_1080, SCALING,
-		 1920, 2500, 1080, 1120,
-		 ov5640_setting_15fps_1080P_1920_1080,
-		 ARRAY_SIZE(ov5640_setting_15fps_1080P_1920_1080)},
-		{OV5640_MODE_QSXGA_2592_1944, SCALING,
-		 2592, 2844, 1944, 1968,
-		 ov5640_setting_15fps_QSXGA_2592_1944,
-		 ARRAY_SIZE(ov5640_setting_15fps_QSXGA_2592_1944)},
-	}, {
-		{OV5640_MODE_QCIF_176_144, SUBSAMPLING,
-		 176, 1896, 144, 984,
-		 ov5640_setting_30fps_QCIF_176_144,
-		 ARRAY_SIZE(ov5640_setting_30fps_QCIF_176_144)},
-		{OV5640_MODE_QVGA_320_240, SUBSAMPLING,
-		 320, 1896, 240, 984,
-		 ov5640_setting_30fps_QVGA_320_240,
-		 ARRAY_SIZE(ov5640_setting_30fps_QVGA_320_240)},
-		{OV5640_MODE_VGA_640_480, SUBSAMPLING,
-		 640, 1896, 480, 1080,
-		 ov5640_setting_30fps_VGA_640_480,
-		 ARRAY_SIZE(ov5640_setting_30fps_VGA_640_480)},
-		{OV5640_MODE_NTSC_720_480, SUBSAMPLING,
-		 720, 1896, 480, 984,
-		 ov5640_setting_30fps_NTSC_720_480,
-		 ARRAY_SIZE(ov5640_setting_30fps_NTSC_720_480)},
-		{OV5640_MODE_PAL_720_576, SUBSAMPLING,
-		 720, 1896, 576, 984,
-		 ov5640_setting_30fps_PAL_720_576,
-		 ARRAY_SIZE(ov5640_setting_30fps_PAL_720_576)},
-		{OV5640_MODE_XGA_1024_768, SUBSAMPLING,
-		 1024, 1896, 768, 1080,
-		 ov5640_setting_30fps_XGA_1024_768,
-		 ARRAY_SIZE(ov5640_setting_30fps_XGA_1024_768)},
-		{OV5640_MODE_720P_1280_720, SUBSAMPLING,
-		 1280, 1892, 720, 740,
-		 ov5640_setting_30fps_720P_1280_720,
-		 ARRAY_SIZE(ov5640_setting_30fps_720P_1280_720)},
-		{OV5640_MODE_1080P_1920_1080, SCALING,
-		 1920, 2500, 1080, 1120,
-		 ov5640_setting_30fps_1080P_1920_1080,
-		 ARRAY_SIZE(ov5640_setting_30fps_1080P_1920_1080)},
-		{OV5640_MODE_QSXGA_2592_1944, -1, 0, 0, 0, 0, NULL, 0},
-	},
+ov5640_mode_data[OV5640_NUM_MODES] = {
+	{OV5640_MODE_QCIF_176_144, SUBSAMPLING,
+	 176, 1896, 144, 984,
+	 ov5640_setting_QCIF_176_144,
+	 ARRAY_SIZE(ov5640_setting_QCIF_176_144)},
+	{OV5640_MODE_QVGA_320_240, SUBSAMPLING,
+	 320, 1896, 240, 984,
+	 ov5640_setting_QVGA_320_240,
+	 ARRAY_SIZE(ov5640_setting_QVGA_320_240)},
+	{OV5640_MODE_VGA_640_480, SUBSAMPLING,
+	 640, 1896, 480, 1080,
+	 ov5640_setting_VGA_640_480,
+	 ARRAY_SIZE(ov5640_setting_VGA_640_480)},
+	{OV5640_MODE_NTSC_720_480, SUBSAMPLING,
+	 720, 1896, 480, 984,
+	 ov5640_setting_NTSC_720_480,
+	 ARRAY_SIZE(ov5640_setting_NTSC_720_480)},
+	{OV5640_MODE_PAL_720_576, SUBSAMPLING,
+	 720, 1896, 576, 984,
+	 ov5640_setting_PAL_720_576,
+	 ARRAY_SIZE(ov5640_setting_PAL_720_576)},
+	{OV5640_MODE_XGA_1024_768, SUBSAMPLING,
+	 1024, 1896, 768, 1080,
+	 ov5640_setting_XGA_1024_768,
+	 ARRAY_SIZE(ov5640_setting_XGA_1024_768)},
+	{OV5640_MODE_720P_1280_720, SUBSAMPLING,
+	 1280, 1892, 720, 740,
+	 ov5640_setting_720P_1280_720,
+	 ARRAY_SIZE(ov5640_setting_720P_1280_720)},
+	{OV5640_MODE_1080P_1920_1080, SCALING,
+	 1920, 2500, 1080, 1120,
+	 ov5640_setting_1080P_1920_1080,
+	 ARRAY_SIZE(ov5640_setting_1080P_1920_1080)},
+	{OV5640_MODE_QSXGA_2592_1944, SCALING,
+	 2592, 2844, 1944, 1968,
+	 ov5640_setting_QSXGA_2592_1944,
+	 ARRAY_SIZE(ov5640_setting_QSXGA_2592_1944)},
 };
 
 static int ov5640_init_slave_id(struct ov5640_dev *sensor)
@@ -1627,7 +1423,7 @@ ov5640_find_mode(struct ov5640_dev *sensor, enum ov5640_frame_rate fr,
 	int i;
 
 	for (i = OV5640_NUM_MODES - 1; i >= 0; i--) {
-		mode = &ov5640_mode_data[fr][i];
+		mode = &ov5640_mode_data[i];
 
 		if (!mode->reg_data)
 			continue;
@@ -1635,12 +1431,20 @@ ov5640_find_mode(struct ov5640_dev *sensor, enum ov5640_frame_rate fr,
 		if ((nearest && mode->hact <= width &&
 		     mode->vact <= height) ||
 		    (!nearest && mode->hact == width &&
-		     mode->vact == height))
+		     mode->vact == height)) {
+
+			/* 2592x1944 can only operate at 15fps */
+			if (width == 2592 && height == 1944 &&
+			    fr != OV5640_15_FPS)
+				/* try to find another mode */
+				continue;
+
 			break;
+		}
 	}
 
 	if (nearest && i < 0)
-		mode = &ov5640_mode_data[fr][0];
+		mode = &ov5640_mode_data[0];
 
 	return mode;
 }
@@ -2620,10 +2424,10 @@ static int ov5640_enum_frame_size(struct v4l2_subdev *sd,
 		return -EINVAL;
 
 	fse->min_width =
-		ov5640_mode_data[0][fse->index].hact;
+		ov5640_mode_data[fse->index].hact;
 	fse->max_width = fse->min_width;
 	fse->min_height =
-		ov5640_mode_data[0][fse->index].vact;
+		ov5640_mode_data[fse->index].vact;
 	fse->max_height = fse->min_height;
 
 	return 0;
@@ -2836,7 +2640,7 @@ static int ov5640_probe(struct i2c_client *client,
 	sensor->frame_interval.denominator = ov5640_framerates[OV5640_30_FPS];
 	sensor->current_fr = OV5640_30_FPS;
 	sensor->current_mode =
-		&ov5640_mode_data[OV5640_30_FPS][OV5640_MODE_VGA_640_480];
+		&ov5640_mode_data[OV5640_MODE_VGA_640_480];
 	sensor->pending_mode_change = true;
 
 	sensor->ae_target = 52;
-- 
2.17.0
