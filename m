Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:34044 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1425873AbeCBOfY (ORCPT <rfc822;linux-media@vger.kernel.org>);
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
Subject: [PATCH 06/12] media: ov5640: Add horizontal and vertical totals
Date: Fri,  2 Mar 2018 15:34:54 +0100
Message-Id: <20180302143500.32650-7-maxime.ripard@bootlin.com>
In-Reply-To: <20180302143500.32650-1-maxime.ripard@bootlin.com>
References: <20180302143500.32650-1-maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All the initialization arrays are changing the horizontal and vertical
totals for some value.

In order to clean up the driver, and since we're going to need that value
later on, let's introduce in the ov5640_mode_info structure the horizontal
and vertical total sizes, and move these out of the bytes array.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/media/i2c/ov5640.c | 156 ++++++++++++++++++++++++++++-----------------
 1 file changed, 97 insertions(+), 59 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 8c04f2880715..443b167bcd20 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -167,7 +167,9 @@ struct ov5640_mode_info {
 	enum ov5640_mode_id id;
 	enum ov5640_downsize_mode dn_mode;
 	u32 hact;
+	u32 htot;
 	u32 vact;
+	u32 vtot;
 	const struct reg_value *reg_data;
 	u32 reg_data_size;
 };
@@ -270,8 +272,8 @@ static const struct reg_value ov5640_init_setting_30fps_VGA[] = {
 	{0x3802, 0x00, 0, 0}, {0x3803, 0x04, 0, 0}, {0x3804, 0x0a, 0, 0},
 	{0x3805, 0x3f, 0, 0}, {0x3806, 0x07, 0, 0}, {0x3807, 0x9b, 0, 0},
 	{0x3808, 0x02, 0, 0}, {0x3809, 0x80, 0, 0}, {0x380a, 0x01, 0, 0},
-	{0x380b, 0xe0, 0, 0}, {0x380c, 0x07, 0, 0}, {0x380d, 0x68, 0, 0},
-	{0x380e, 0x03, 0, 0}, {0x380f, 0xd8, 0, 0}, {0x3810, 0x00, 0, 0},
+	{0x380b, 0xe0, 0, 0},
+	{0x3810, 0x00, 0, 0},
 	{0x3811, 0x10, 0, 0}, {0x3812, 0x00, 0, 0}, {0x3813, 0x06, 0, 0},
 	{0x3618, 0x00, 0, 0}, {0x3612, 0x29, 0, 0}, {0x3708, 0x64, 0, 0},
 	{0x3709, 0x52, 0, 0}, {0x370c, 0x03, 0, 0}, {0x3a02, 0x03, 0, 0},
@@ -345,8 +347,8 @@ static const struct reg_value ov5640_setting_30fps_VGA_640_480[] = {
 	{0x3802, 0x00, 0, 0}, {0x3803, 0x04, 0, 0}, {0x3804, 0x0a, 0, 0},
 	{0x3805, 0x3f, 0, 0}, {0x3806, 0x07, 0, 0}, {0x3807, 0x9b, 0, 0},
 	{0x3808, 0x02, 0, 0}, {0x3809, 0x80, 0, 0}, {0x380a, 0x01, 0, 0},
-	{0x380b, 0xe0, 0, 0}, {0x380c, 0x07, 0, 0}, {0x380d, 0x68, 0, 0},
-	{0x380e, 0x04, 0, 0}, {0x380f, 0x38, 0, 0}, {0x3810, 0x00, 0, 0},
+	{0x380b, 0xe0, 0, 0},
+	{0x3810, 0x00, 0, 0},
 	{0x3811, 0x10, 0, 0}, {0x3812, 0x00, 0, 0}, {0x3813, 0x06, 0, 0},
 	{0x3618, 0x00, 0, 0}, {0x3612, 0x29, 0, 0}, {0x3708, 0x64, 0, 0},
 	{0x3709, 0x52, 0, 0}, {0x370c, 0x03, 0, 0}, {0x3a02, 0x03, 0, 0},
@@ -366,8 +368,8 @@ static const struct reg_value ov5640_setting_15fps_VGA_640_480[] = {
 	{0x3802, 0x00, 0, 0}, {0x3803, 0x04, 0, 0}, {0x3804, 0x0a, 0, 0},
 	{0x3805, 0x3f, 0, 0}, {0x3806, 0x07, 0, 0}, {0x3807, 0x9b, 0, 0},
 	{0x3808, 0x02, 0, 0}, {0x3809, 0x80, 0, 0}, {0x380a, 0x01, 0, 0},
-	{0x380b, 0xe0, 0, 0}, {0x380c, 0x07, 0, 0}, {0x380d, 0x68, 0, 0},
-	{0x380e, 0x03, 0, 0}, {0x380f, 0xd8, 0, 0}, {0x3810, 0x00, 0, 0},
+	{0x380b, 0xe0, 0, 0},
+	{0x3810, 0x00, 0, 0},
 	{0x3811, 0x10, 0, 0}, {0x3812, 0x00, 0, 0}, {0x3813, 0x06, 0, 0},
 	{0x3618, 0x00, 0, 0}, {0x3612, 0x29, 0, 0}, {0x3708, 0x64, 0, 0},
 	{0x3709, 0x52, 0, 0}, {0x370c, 0x03, 0, 0}, {0x3a02, 0x03, 0, 0},
@@ -388,8 +390,8 @@ static const struct reg_value ov5640_setting_30fps_XGA_1024_768[] = {
 	{0x3802, 0x00, 0, 0}, {0x3803, 0x04, 0, 0}, {0x3804, 0x0a, 0, 0},
 	{0x3805, 0x3f, 0, 0}, {0x3806, 0x07, 0, 0}, {0x3807, 0x9b, 0, 0},
 	{0x3808, 0x02, 0, 0}, {0x3809, 0x80, 0, 0}, {0x380a, 0x01, 0, 0},
-	{0x380b, 0xe0, 0, 0}, {0x380c, 0x07, 0, 0}, {0x380d, 0x68, 0, 0},
-	{0x380e, 0x04, 0, 0}, {0x380f, 0x38, 0, 0}, {0x3810, 0x00, 0, 0},
+	{0x380b, 0xe0, 0, 0},
+	{0x3810, 0x00, 0, 0},
 	{0x3811, 0x10, 0, 0}, {0x3812, 0x00, 0, 0}, {0x3813, 0x06, 0, 0},
 	{0x3618, 0x00, 0, 0}, {0x3612, 0x29, 0, 0}, {0x3708, 0x64, 0, 0},
 	{0x3709, 0x52, 0, 0}, {0x370c, 0x03, 0, 0}, {0x3a02, 0x03, 0, 0},
@@ -411,8 +413,8 @@ static const struct reg_value ov5640_setting_15fps_XGA_1024_768[] = {
 	{0x3802, 0x00, 0, 0}, {0x3803, 0x04, 0, 0}, {0x3804, 0x0a, 0, 0},
 	{0x3805, 0x3f, 0, 0}, {0x3806, 0x07, 0, 0}, {0x3807, 0x9b, 0, 0},
 	{0x3808, 0x02, 0, 0}, {0x3809, 0x80, 0, 0}, {0x380a, 0x01, 0, 0},
-	{0x380b, 0xe0, 0, 0}, {0x380c, 0x07, 0, 0}, {0x380d, 0x68, 0, 0},
-	{0x380e, 0x03, 0, 0}, {0x380f, 0xd8, 0, 0}, {0x3810, 0x00, 0, 0},
+	{0x380b, 0xe0, 0, 0},
+	{0x3810, 0x00, 0, 0},
 	{0x3811, 0x10, 0, 0}, {0x3812, 0x00, 0, 0}, {0x3813, 0x06, 0, 0},
 	{0x3618, 0x00, 0, 0}, {0x3612, 0x29, 0, 0}, {0x3708, 0x64, 0, 0},
 	{0x3709, 0x52, 0, 0}, {0x370c, 0x03, 0, 0}, {0x3a02, 0x03, 0, 0},
@@ -433,8 +435,8 @@ static const struct reg_value ov5640_setting_30fps_QVGA_320_240[] = {
 	{0x3802, 0x00, 0, 0}, {0x3803, 0x04, 0, 0}, {0x3804, 0x0a, 0, 0},
 	{0x3805, 0x3f, 0, 0}, {0x3806, 0x07, 0, 0}, {0x3807, 0x9b, 0, 0},
 	{0x3808, 0x01, 0, 0}, {0x3809, 0x40, 0, 0}, {0x380a, 0x00, 0, 0},
-	{0x380b, 0xf0, 0, 0}, {0x380c, 0x07, 0, 0}, {0x380d, 0x68, 0, 0},
-	{0x380e, 0x03, 0, 0}, {0x380f, 0xd8, 0, 0}, {0x3810, 0x00, 0, 0},
+	{0x380b, 0xf0, 0, 0},
+	{0x3810, 0x00, 0, 0},
 	{0x3811, 0x10, 0, 0}, {0x3812, 0x00, 0, 0}, {0x3813, 0x06, 0, 0},
 	{0x3618, 0x00, 0, 0}, {0x3612, 0x29, 0, 0}, {0x3708, 0x64, 0, 0},
 	{0x3709, 0x52, 0, 0}, {0x370c, 0x03, 0, 0}, {0x3a02, 0x03, 0, 0},
@@ -454,8 +456,8 @@ static const struct reg_value ov5640_setting_15fps_QVGA_320_240[] = {
 	{0x3802, 0x00, 0, 0}, {0x3803, 0x04, 0, 0}, {0x3804, 0x0a, 0, 0},
 	{0x3805, 0x3f, 0, 0}, {0x3806, 0x07, 0, 0}, {0x3807, 0x9b, 0, 0},
 	{0x3808, 0x01, 0, 0}, {0x3809, 0x40, 0, 0}, {0x380a, 0x00, 0, 0},
-	{0x380b, 0xf0, 0, 0}, {0x380c, 0x07, 0, 0}, {0x380d, 0x68, 0, 0},
-	{0x380e, 0x03, 0, 0}, {0x380f, 0xd8, 0, 0}, {0x3810, 0x00, 0, 0},
+	{0x380b, 0xf0, 0, 0},
+	{0x3810, 0x00, 0, 0},
 	{0x3811, 0x10, 0, 0}, {0x3812, 0x00, 0, 0}, {0x3813, 0x06, 0, 0},
 	{0x3618, 0x00, 0, 0}, {0x3612, 0x29, 0, 0}, {0x3708, 0x64, 0, 0},
 	{0x3709, 0x52, 0, 0}, {0x370c, 0x03, 0, 0}, {0x3a02, 0x03, 0, 0},
@@ -475,8 +477,8 @@ static const struct reg_value ov5640_setting_30fps_QCIF_176_144[] = {
 	{0x3802, 0x00, 0, 0}, {0x3803, 0x04, 0, 0}, {0x3804, 0x0a, 0, 0},
 	{0x3805, 0x3f, 0, 0}, {0x3806, 0x07, 0, 0}, {0x3807, 0x9b, 0, 0},
 	{0x3808, 0x00, 0, 0}, {0x3809, 0xb0, 0, 0}, {0x380a, 0x00, 0, 0},
-	{0x380b, 0x90, 0, 0}, {0x380c, 0x07, 0, 0}, {0x380d, 0x68, 0, 0},
-	{0x380e, 0x03, 0, 0}, {0x380f, 0xd8, 0, 0}, {0x3810, 0x00, 0, 0},
+	{0x380b, 0x90, 0, 0},
+	{0x3810, 0x00, 0, 0},
 	{0x3811, 0x10, 0, 0}, {0x3812, 0x00, 0, 0}, {0x3813, 0x06, 0, 0},
 	{0x3618, 0x00, 0, 0}, {0x3612, 0x29, 0, 0}, {0x3708, 0x64, 0, 0},
 	{0x3709, 0x52, 0, 0}, {0x370c, 0x03, 0, 0}, {0x3a02, 0x03, 0, 0},
@@ -495,8 +497,8 @@ static const struct reg_value ov5640_setting_15fps_QCIF_176_144[] = {
 	{0x3802, 0x00, 0, 0}, {0x3803, 0x04, 0, 0}, {0x3804, 0x0a, 0, 0},
 	{0x3805, 0x3f, 0, 0}, {0x3806, 0x07, 0, 0}, {0x3807, 0x9b, 0, 0},
 	{0x3808, 0x00, 0, 0}, {0x3809, 0xb0, 0, 0}, {0x380a, 0x00, 0, 0},
-	{0x380b, 0x90, 0, 0}, {0x380c, 0x07, 0, 0}, {0x380d, 0x68, 0, 0},
-	{0x380e, 0x03, 0, 0}, {0x380f, 0xd8, 0, 0}, {0x3810, 0x00, 0, 0},
+	{0x380b, 0x90, 0, 0},
+	{0x3810, 0x00, 0, 0},
 	{0x3811, 0x10, 0, 0}, {0x3812, 0x00, 0, 0}, {0x3813, 0x06, 0, 0},
 	{0x3618, 0x00, 0, 0}, {0x3612, 0x29, 0, 0}, {0x3708, 0x64, 0, 0},
 	{0x3709, 0x52, 0, 0}, {0x370c, 0x03, 0, 0}, {0x3a02, 0x03, 0, 0},
@@ -516,8 +518,8 @@ static const struct reg_value ov5640_setting_30fps_NTSC_720_480[] = {
 	{0x3802, 0x00, 0, 0}, {0x3803, 0x04, 0, 0}, {0x3804, 0x0a, 0, 0},
 	{0x3805, 0x3f, 0, 0}, {0x3806, 0x07, 0, 0}, {0x3807, 0x9b, 0, 0},
 	{0x3808, 0x02, 0, 0}, {0x3809, 0xd0, 0, 0}, {0x380a, 0x01, 0, 0},
-	{0x380b, 0xe0, 0, 0}, {0x380c, 0x07, 0, 0}, {0x380d, 0x68, 0, 0},
-	{0x380e, 0x03, 0, 0}, {0x380f, 0xd8, 0, 0}, {0x3810, 0x00, 0, 0},
+	{0x380b, 0xe0, 0, 0},
+	{0x3810, 0x00, 0, 0},
 	{0x3811, 0x10, 0, 0}, {0x3812, 0x00, 0, 0}, {0x3813, 0x3c, 0, 0},
 	{0x3618, 0x00, 0, 0}, {0x3612, 0x29, 0, 0}, {0x3708, 0x64, 0, 0},
 	{0x3709, 0x52, 0, 0}, {0x370c, 0x03, 0, 0}, {0x3a02, 0x03, 0, 0},
@@ -537,8 +539,8 @@ static const struct reg_value ov5640_setting_15fps_NTSC_720_480[] = {
 	{0x3802, 0x00, 0, 0}, {0x3803, 0x04, 0, 0}, {0x3804, 0x0a, 0, 0},
 	{0x3805, 0x3f, 0, 0}, {0x3806, 0x07, 0, 0}, {0x3807, 0x9b, 0, 0},
 	{0x3808, 0x02, 0, 0}, {0x3809, 0xd0, 0, 0}, {0x380a, 0x01, 0, 0},
-	{0x380b, 0xe0, 0, 0}, {0x380c, 0x07, 0, 0}, {0x380d, 0x68, 0, 0},
-	{0x380e, 0x03, 0, 0}, {0x380f, 0xd8, 0, 0}, {0x3810, 0x00, 0, 0},
+	{0x380b, 0xe0, 0, 0},
+	{0x3810, 0x00, 0, 0},
 	{0x3811, 0x10, 0, 0}, {0x3812, 0x00, 0, 0}, {0x3813, 0x3c, 0, 0},
 	{0x3618, 0x00, 0, 0}, {0x3612, 0x29, 0, 0}, {0x3708, 0x64, 0, 0},
 	{0x3709, 0x52, 0, 0}, {0x370c, 0x03, 0, 0}, {0x3a02, 0x03, 0, 0},
@@ -558,8 +560,8 @@ static const struct reg_value ov5640_setting_30fps_PAL_720_576[] = {
 	{0x3802, 0x00, 0, 0}, {0x3803, 0x04, 0, 0}, {0x3804, 0x0a, 0, 0},
 	{0x3805, 0x3f, 0, 0}, {0x3806, 0x07, 0, 0}, {0x3807, 0x9b, 0, 0},
 	{0x3808, 0x02, 0, 0}, {0x3809, 0xd0, 0, 0}, {0x380a, 0x02, 0, 0},
-	{0x380b, 0x40, 0, 0}, {0x380c, 0x07, 0, 0}, {0x380d, 0x68, 0, 0},
-	{0x380e, 0x03, 0, 0}, {0x380f, 0xd8, 0, 0}, {0x3810, 0x00, 0, 0},
+	{0x380b, 0x40, 0, 0},
+	{0x3810, 0x00, 0, 0},
 	{0x3811, 0x38, 0, 0}, {0x3812, 0x00, 0, 0}, {0x3813, 0x06, 0, 0},
 	{0x3618, 0x00, 0, 0}, {0x3612, 0x29, 0, 0}, {0x3708, 0x64, 0, 0},
 	{0x3709, 0x52, 0, 0}, {0x370c, 0x03, 0, 0}, {0x3a02, 0x03, 0, 0},
@@ -579,8 +581,8 @@ static const struct reg_value ov5640_setting_15fps_PAL_720_576[] = {
 	{0x3802, 0x00, 0, 0}, {0x3803, 0x04, 0, 0}, {0x3804, 0x0a, 0, 0},
 	{0x3805, 0x3f, 0, 0}, {0x3806, 0x07, 0, 0}, {0x3807, 0x9b, 0, 0},
 	{0x3808, 0x02, 0, 0}, {0x3809, 0xd0, 0, 0}, {0x380a, 0x02, 0, 0},
-	{0x380b, 0x40, 0, 0}, {0x380c, 0x07, 0, 0}, {0x380d, 0x68, 0, 0},
-	{0x380e, 0x03, 0, 0}, {0x380f, 0xd8, 0, 0}, {0x3810, 0x00, 0, 0},
+	{0x380b, 0x40, 0, 0},
+	{0x3810, 0x00, 0, 0},
 	{0x3811, 0x38, 0, 0}, {0x3812, 0x00, 0, 0}, {0x3813, 0x06, 0, 0},
 	{0x3618, 0x00, 0, 0}, {0x3612, 0x29, 0, 0}, {0x3708, 0x64, 0, 0},
 	{0x3709, 0x52, 0, 0}, {0x370c, 0x03, 0, 0}, {0x3a02, 0x03, 0, 0},
@@ -601,8 +603,8 @@ static const struct reg_value ov5640_setting_30fps_720P_1280_720[] = {
 	{0x3802, 0x00, 0, 0}, {0x3803, 0xfa, 0, 0}, {0x3804, 0x0a, 0, 0},
 	{0x3805, 0x3f, 0, 0}, {0x3806, 0x06, 0, 0}, {0x3807, 0xa9, 0, 0},
 	{0x3808, 0x05, 0, 0}, {0x3809, 0x00, 0, 0}, {0x380a, 0x02, 0, 0},
-	{0x380b, 0xd0, 0, 0}, {0x380c, 0x07, 0, 0}, {0x380d, 0x64, 0, 0},
-	{0x380e, 0x02, 0, 0}, {0x380f, 0xe4, 0, 0}, {0x3810, 0x00, 0, 0},
+	{0x380b, 0xd0, 0, 0},
+	{0x3810, 0x00, 0, 0},
 	{0x3811, 0x10, 0, 0}, {0x3812, 0x00, 0, 0}, {0x3813, 0x04, 0, 0},
 	{0x3618, 0x00, 0, 0}, {0x3612, 0x29, 0, 0}, {0x3708, 0x64, 0, 0},
 	{0x3709, 0x52, 0, 0}, {0x370c, 0x03, 0, 0}, {0x3a02, 0x02, 0, 0},
@@ -623,8 +625,8 @@ static const struct reg_value ov5640_setting_15fps_720P_1280_720[] = {
 	{0x3802, 0x00, 0, 0}, {0x3803, 0xfa, 0, 0}, {0x3804, 0x0a, 0, 0},
 	{0x3805, 0x3f, 0, 0}, {0x3806, 0x06, 0, 0}, {0x3807, 0xa9, 0, 0},
 	{0x3808, 0x05, 0, 0}, {0x3809, 0x00, 0, 0}, {0x380a, 0x02, 0, 0},
-	{0x380b, 0xd0, 0, 0}, {0x380c, 0x07, 0, 0}, {0x380d, 0x64, 0, 0},
-	{0x380e, 0x02, 0, 0}, {0x380f, 0xe4, 0, 0}, {0x3810, 0x00, 0, 0},
+	{0x380b, 0xd0, 0, 0},
+	{0x3810, 0x00, 0, 0},
 	{0x3811, 0x10, 0, 0}, {0x3812, 0x00, 0, 0}, {0x3813, 0x04, 0, 0},
 	{0x3618, 0x00, 0, 0}, {0x3612, 0x29, 0, 0}, {0x3708, 0x64, 0, 0},
 	{0x3709, 0x52, 0, 0}, {0x370c, 0x03, 0, 0}, {0x3a02, 0x02, 0, 0},
@@ -645,8 +647,8 @@ static const struct reg_value ov5640_setting_30fps_1080P_1920_1080[] = {
 	{0x3802, 0x00, 0, 0}, {0x3803, 0x00, 0, 0}, {0x3804, 0x0a, 0, 0},
 	{0x3805, 0x3f, 0, 0}, {0x3806, 0x07, 0, 0}, {0x3807, 0x9f, 0, 0},
 	{0x3808, 0x0a, 0, 0}, {0x3809, 0x20, 0, 0}, {0x380a, 0x07, 0, 0},
-	{0x380b, 0x98, 0, 0}, {0x380c, 0x0b, 0, 0}, {0x380d, 0x1c, 0, 0},
-	{0x380e, 0x07, 0, 0}, {0x380f, 0xb0, 0, 0}, {0x3810, 0x00, 0, 0},
+	{0x380b, 0x98, 0, 0},
+	{0x3810, 0x00, 0, 0},
 	{0x3811, 0x10, 0, 0}, {0x3812, 0x00, 0, 0}, {0x3813, 0x04, 0, 0},
 	{0x3618, 0x04, 0, 0}, {0x3612, 0x29, 0, 0}, {0x3708, 0x21, 0, 0},
 	{0x3709, 0x12, 0, 0}, {0x370c, 0x00, 0, 0}, {0x3a02, 0x03, 0, 0},
@@ -662,8 +664,7 @@ static const struct reg_value ov5640_setting_30fps_1080P_1920_1080[] = {
 	{0x3803, 0xb2, 0, 0}, {0x3804, 0x08, 0, 0}, {0x3805, 0xef, 0, 0},
 	{0x3806, 0x05, 0, 0}, {0x3807, 0xf1, 0, 0}, {0x3808, 0x07, 0, 0},
 	{0x3809, 0x80, 0, 0}, {0x380a, 0x04, 0, 0}, {0x380b, 0x38, 0, 0},
-	{0x380c, 0x09, 0, 0}, {0x380d, 0xc4, 0, 0}, {0x380e, 0x04, 0, 0},
-	{0x380f, 0x60, 0, 0}, {0x3612, 0x2b, 0, 0}, {0x3708, 0x64, 0, 0},
+	{0x3612, 0x2b, 0, 0}, {0x3708, 0x64, 0, 0},
 	{0x3a02, 0x04, 0, 0}, {0x3a03, 0x60, 0, 0}, {0x3a08, 0x01, 0, 0},
 	{0x3a09, 0x50, 0, 0}, {0x3a0a, 0x01, 0, 0}, {0x3a0b, 0x18, 0, 0},
 	{0x3a0e, 0x03, 0, 0}, {0x3a0d, 0x04, 0, 0}, {0x3a14, 0x04, 0, 0},
@@ -682,8 +683,8 @@ static const struct reg_value ov5640_setting_15fps_1080P_1920_1080[] = {
 	{0x3802, 0x00, 0, 0}, {0x3803, 0x00, 0, 0}, {0x3804, 0x0a, 0, 0},
 	{0x3805, 0x3f, 0, 0}, {0x3806, 0x07, 0, 0}, {0x3807, 0x9f, 0, 0},
 	{0x3808, 0x0a, 0, 0}, {0x3809, 0x20, 0, 0}, {0x380a, 0x07, 0, 0},
-	{0x380b, 0x98, 0, 0}, {0x380c, 0x0b, 0, 0}, {0x380d, 0x1c, 0, 0},
-	{0x380e, 0x07, 0, 0}, {0x380f, 0xb0, 0, 0}, {0x3810, 0x00, 0, 0},
+	{0x380b, 0x98, 0, 0},
+	{0x3810, 0x00, 0, 0},
 	{0x3811, 0x10, 0, 0}, {0x3812, 0x00, 0, 0}, {0x3813, 0x04, 0, 0},
 	{0x3618, 0x04, 0, 0}, {0x3612, 0x29, 0, 0}, {0x3708, 0x21, 0, 0},
 	{0x3709, 0x12, 0, 0}, {0x370c, 0x00, 0, 0}, {0x3a02, 0x03, 0, 0},
@@ -699,8 +700,7 @@ static const struct reg_value ov5640_setting_15fps_1080P_1920_1080[] = {
 	{0x3803, 0xb2, 0, 0}, {0x3804, 0x08, 0, 0}, {0x3805, 0xef, 0, 0},
 	{0x3806, 0x05, 0, 0}, {0x3807, 0xf1, 0, 0}, {0x3808, 0x07, 0, 0},
 	{0x3809, 0x80, 0, 0}, {0x380a, 0x04, 0, 0}, {0x380b, 0x38, 0, 0},
-	{0x380c, 0x09, 0, 0}, {0x380d, 0xc4, 0, 0}, {0x380e, 0x04, 0, 0},
-	{0x380f, 0x60, 0, 0}, {0x3612, 0x2b, 0, 0}, {0x3708, 0x64, 0, 0},
+	{0x3612, 0x2b, 0, 0}, {0x3708, 0x64, 0, 0},
 	{0x3a02, 0x04, 0, 0}, {0x3a03, 0x60, 0, 0}, {0x3a08, 0x01, 0, 0},
 	{0x3a09, 0x50, 0, 0}, {0x3a0a, 0x01, 0, 0}, {0x3a0b, 0x18, 0, 0},
 	{0x3a0e, 0x03, 0, 0}, {0x3a0d, 0x04, 0, 0}, {0x3a14, 0x04, 0, 0},
@@ -718,8 +718,8 @@ static const struct reg_value ov5640_setting_15fps_QSXGA_2592_1944[] = {
 	{0x3802, 0x00, 0, 0}, {0x3803, 0x00, 0, 0}, {0x3804, 0x0a, 0, 0},
 	{0x3805, 0x3f, 0, 0}, {0x3806, 0x07, 0, 0}, {0x3807, 0x9f, 0, 0},
 	{0x3808, 0x0a, 0, 0}, {0x3809, 0x20, 0, 0}, {0x380a, 0x07, 0, 0},
-	{0x380b, 0x98, 0, 0}, {0x380c, 0x0b, 0, 0}, {0x380d, 0x1c, 0, 0},
-	{0x380e, 0x07, 0, 0}, {0x380f, 0xb0, 0, 0}, {0x3810, 0x00, 0, 0},
+	{0x380b, 0x98, 0, 0},
+	{0x3810, 0x00, 0, 0},
 	{0x3811, 0x10, 0, 0}, {0x3812, 0x00, 0, 0}, {0x3813, 0x04, 0, 0},
 	{0x3618, 0x04, 0, 0}, {0x3612, 0x29, 0, 0}, {0x3708, 0x21, 0, 0},
 	{0x3709, 0x12, 0, 0}, {0x370c, 0x00, 0, 0}, {0x3a02, 0x03, 0, 0},
@@ -733,66 +733,84 @@ static const struct reg_value ov5640_setting_15fps_QSXGA_2592_1944[] = {
 
 /* power-on sensor init reg table */
 static const struct ov5640_mode_info ov5640_mode_init_data = {
-	0, SUBSAMPLING, 640, 480, ov5640_init_setting_30fps_VGA,
+	0, SUBSAMPLING, 640, 1896, 480, 984,
+	ov5640_init_setting_30fps_VGA,
 	ARRAY_SIZE(ov5640_init_setting_30fps_VGA),
 };
 
 static const struct ov5640_mode_info
 ov5640_mode_data[OV5640_NUM_FRAMERATES][OV5640_NUM_MODES] = {
 	{
-		{OV5640_MODE_QCIF_176_144, SUBSAMPLING, 176, 144,
+		{OV5640_MODE_QCIF_176_144, SUBSAMPLING,
+		 176, 1896, 144, 984,
 		 ov5640_setting_15fps_QCIF_176_144,
 		 ARRAY_SIZE(ov5640_setting_15fps_QCIF_176_144)},
-		{OV5640_MODE_QVGA_320_240, SUBSAMPLING, 320,  240,
+		{OV5640_MODE_QVGA_320_240, SUBSAMPLING,
+		 320, 1896, 240, 984,
 		 ov5640_setting_15fps_QVGA_320_240,
 		 ARRAY_SIZE(ov5640_setting_15fps_QVGA_320_240)},
-		{OV5640_MODE_VGA_640_480, SUBSAMPLING, 640,  480,
+		{OV5640_MODE_VGA_640_480, SUBSAMPLING,
+		 640, 1896, 480, 1080,
 		 ov5640_setting_15fps_VGA_640_480,
 		 ARRAY_SIZE(ov5640_setting_15fps_VGA_640_480)},
-		{OV5640_MODE_NTSC_720_480, SUBSAMPLING, 720, 480,
+		{OV5640_MODE_NTSC_720_480, SUBSAMPLING,
+		 720, 1896, 480, 984,
 		 ov5640_setting_15fps_NTSC_720_480,
 		 ARRAY_SIZE(ov5640_setting_15fps_NTSC_720_480)},
-		{OV5640_MODE_PAL_720_576, SUBSAMPLING, 720, 576,
+		{OV5640_MODE_PAL_720_576, SUBSAMPLING,
+		 720, 1896, 576, 984,
 		 ov5640_setting_15fps_PAL_720_576,
 		 ARRAY_SIZE(ov5640_setting_15fps_PAL_720_576)},
-		{OV5640_MODE_XGA_1024_768, SUBSAMPLING, 1024, 768,
+		{OV5640_MODE_XGA_1024_768, SUBSAMPLING,
+		 1024, 1896, 768, 1080,
 		 ov5640_setting_15fps_XGA_1024_768,
 		 ARRAY_SIZE(ov5640_setting_15fps_XGA_1024_768)},
-		{OV5640_MODE_720P_1280_720, SUBSAMPLING, 1280, 720,
+		{OV5640_MODE_720P_1280_720, SUBSAMPLING,
+		 1280, 1892, 720, 740,
 		 ov5640_setting_15fps_720P_1280_720,
 		 ARRAY_SIZE(ov5640_setting_15fps_720P_1280_720)},
-		{OV5640_MODE_1080P_1920_1080, SCALING, 1920, 1080,
+		{OV5640_MODE_1080P_1920_1080, SCALING,
+		 1920, 2500, 1080, 1120,
 		 ov5640_setting_15fps_1080P_1920_1080,
 		 ARRAY_SIZE(ov5640_setting_15fps_1080P_1920_1080)},
-		{OV5640_MODE_QSXGA_2592_1944, SCALING, 2592, 1944,
+		{OV5640_MODE_QSXGA_2592_1944, SCALING,
+		 2592, 2844, 1944, 1968,
 		 ov5640_setting_15fps_QSXGA_2592_1944,
 		 ARRAY_SIZE(ov5640_setting_15fps_QSXGA_2592_1944)},
 	}, {
-		{OV5640_MODE_QCIF_176_144, SUBSAMPLING, 176, 144,
+		{OV5640_MODE_QCIF_176_144, SUBSAMPLING,
+		 176, 1896, 144, 984,
 		 ov5640_setting_30fps_QCIF_176_144,
 		 ARRAY_SIZE(ov5640_setting_30fps_QCIF_176_144)},
-		{OV5640_MODE_QVGA_320_240, SUBSAMPLING, 320,  240,
+		{OV5640_MODE_QVGA_320_240, SUBSAMPLING,
+		 320, 1896, 240, 984,
 		 ov5640_setting_30fps_QVGA_320_240,
 		 ARRAY_SIZE(ov5640_setting_30fps_QVGA_320_240)},
-		{OV5640_MODE_VGA_640_480, SUBSAMPLING, 640,  480,
+		{OV5640_MODE_VGA_640_480, SUBSAMPLING,
+		 640, 1896, 480, 1080,
 		 ov5640_setting_30fps_VGA_640_480,
 		 ARRAY_SIZE(ov5640_setting_30fps_VGA_640_480)},
-		{OV5640_MODE_NTSC_720_480, SUBSAMPLING, 720, 480,
+		{OV5640_MODE_NTSC_720_480, SUBSAMPLING,
+		 720, 1896, 480, 984,
 		 ov5640_setting_30fps_NTSC_720_480,
 		 ARRAY_SIZE(ov5640_setting_30fps_NTSC_720_480)},
-		{OV5640_MODE_PAL_720_576, SUBSAMPLING, 720, 576,
+		{OV5640_MODE_PAL_720_576, SUBSAMPLING,
+		 720, 1896, 576, 984,
 		 ov5640_setting_30fps_PAL_720_576,
 		 ARRAY_SIZE(ov5640_setting_30fps_PAL_720_576)},
-		{OV5640_MODE_XGA_1024_768, SUBSAMPLING, 1024, 768,
+		{OV5640_MODE_XGA_1024_768, SUBSAMPLING,
+		 1024, 1896, 768, 1080,
 		 ov5640_setting_30fps_XGA_1024_768,
 		 ARRAY_SIZE(ov5640_setting_30fps_XGA_1024_768)},
-		{OV5640_MODE_720P_1280_720, SUBSAMPLING, 1280, 720,
+		{OV5640_MODE_720P_1280_720, SUBSAMPLING,
+		 1280, 1892, 720, 740,
 		 ov5640_setting_30fps_720P_1280_720,
 		 ARRAY_SIZE(ov5640_setting_30fps_720P_1280_720)},
-		{OV5640_MODE_1080P_1920_1080, SCALING, 1920, 1080,
+		{OV5640_MODE_1080P_1920_1080, SCALING,
+		 1920, 2500, 1080, 1120,
 		 ov5640_setting_30fps_1080P_1920_1080,
 		 ARRAY_SIZE(ov5640_setting_30fps_1080P_1920_1080)},
-		{OV5640_MODE_QSXGA_2592_1944, -1, 0, 0, NULL, 0},
+		{OV5640_MODE_QSXGA_2592_1944, -1, 0, 0, 0, 0, NULL, 0},
 	},
 };
 
@@ -1375,6 +1393,22 @@ static int ov5640_set_virtual_channel(struct ov5640_dev *sensor)
 	return ov5640_write_reg(sensor, OV5640_REG_DEBUG_MODE, temp);
 }
 
+static int ov5640_set_timings(struct ov5640_dev *sensor,
+			      const struct ov5640_mode_info *mode)
+{
+	int ret;
+
+	ret = ov5640_write_reg16(sensor, OV5640_REG_TIMING_HTS, mode->htot);
+	if (ret < 0)
+		return ret;
+
+	ret = ov5640_write_reg16(sensor, OV5640_REG_TIMING_VTS, mode->vtot);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
 static const struct ov5640_mode_info *
 ov5640_find_mode(struct ov5640_dev *sensor, enum ov5640_frame_rate fr,
 		 int width, int height, bool nearest)
@@ -1621,6 +1655,10 @@ static int ov5640_set_mode(struct ov5640_dev *sensor,
 		ret = ov5640_set_mode_direct(sensor, mode);
 	}
 
+	if (ret < 0)
+		return ret;
+
+	ret = ov5640_set_timings(sensor, mode);
 	if (ret < 0)
 		return ret;
 
-- 
2.14.3
