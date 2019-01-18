Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 973D9C43612
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 08:52:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 626022087E
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 08:52:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727644AbfARIwO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 03:52:14 -0500
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:58376 "EHLO
        wens.csie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727585AbfARIwO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 03:52:14 -0500
Received: by wens.csie.org (Postfix, from userid 1000)
        id 889BD5FD20; Fri, 18 Jan 2019 16:52:09 +0800 (CST)
From:   Chen-Yu Tsai <wens@csie.org>
To:     Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Chen-Yu Tsai <wens@csie.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH 6/6] media: ov5640: Consolidate JPEG compression mode setting
Date:   Fri, 18 Jan 2019 16:52:06 +0800
Message-Id: <20190118085206.2598-7-wens@csie.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190118085206.2598-1-wens@csie.org>
References: <20190118085206.2598-1-wens@csie.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The register value lists for all the supported resolution settings all
include a register address/value pair for setting the JPEG compression
mode. With the exception of 1080p (which sets mode 2), all resolutions
use mode 3.

The only difference between mode 2 and mode 3 is that mode 2 may have
padding data on the last line, while mode 3 does not add padding data.

As these register values were from dumps of running systems, and the
difference between the modes is quite small, using mode 3 for all
configurations should be OK.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 drivers/media/i2c/ov5640.c | 34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 1c1dc401c678..3d2c5de73283 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -85,6 +85,7 @@
 #define OV5640_REG_FORMAT_CONTROL00	0x4300
 #define OV5640_REG_VFIFO_HSIZE		0x4602
 #define OV5640_REG_VFIFO_VSIZE		0x4604
+#define OV5640_REG_JPG_MODE_SELECT	0x4713
 #define OV5640_REG_POLARITY_CTRL00	0x4740
 #define OV5640_REG_MIPI_CTRL00		0x4800
 #define OV5640_REG_DEBUG_MODE		0x4814
@@ -303,7 +304,7 @@ static const struct reg_value ov5640_init_setting_30fps_VGA[] = {
 	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x3000, 0x00, 0, 0},
 	{0x3002, 0x1c, 0, 0}, {0x3004, 0xff, 0, 0}, {0x3006, 0xc3, 0, 0},
 	{0x302e, 0x08, 0, 0}, {0x4300, 0x3f, 0, 0},
-	{0x501f, 0x00, 0, 0}, {0x4713, 0x03, 0, 0}, {0x4407, 0x04, 0, 0},
+	{0x501f, 0x00, 0, 0}, {0x4407, 0x04, 0, 0},
 	{0x440e, 0x00, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
 	{0x4837, 0x0a, 0, 0}, {0x3824, 0x02, 0, 0},
 	{0x5000, 0xa7, 0, 0}, {0x5001, 0xa3, 0, 0}, {0x5180, 0xff, 0, 0},
@@ -372,7 +373,7 @@ static const struct reg_value ov5640_setting_VGA_640_480[] = {
 	{0x3a03, 0xd8, 0, 0}, {0x3a08, 0x01, 0, 0}, {0x3a09, 0x27, 0, 0},
 	{0x3a0a, 0x00, 0, 0}, {0x3a0b, 0xf6, 0, 0}, {0x3a0e, 0x03, 0, 0},
 	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
-	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x4713, 0x03, 0, 0},
+	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0},
 	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
 	{0x3824, 0x02, 0, 0}, {0x5001, 0xa3, 0, 0},
 };
@@ -391,7 +392,7 @@ static const struct reg_value ov5640_setting_XGA_1024_768[] = {
 	{0x3a03, 0xd8, 0, 0}, {0x3a08, 0x01, 0, 0}, {0x3a09, 0x27, 0, 0},
 	{0x3a0a, 0x00, 0, 0}, {0x3a0b, 0xf6, 0, 0}, {0x3a0e, 0x03, 0, 0},
 	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
-	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x4713, 0x03, 0, 0},
+	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0},
 	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
 	{0x3824, 0x02, 0, 0}, {0x5001, 0xa3, 0, 0},
 };
@@ -410,7 +411,7 @@ static const struct reg_value ov5640_setting_QVGA_320_240[] = {
 	{0x3a03, 0xd8, 0, 0}, {0x3a08, 0x01, 0, 0}, {0x3a09, 0x27, 0, 0},
 	{0x3a0a, 0x00, 0, 0}, {0x3a0b, 0xf6, 0, 0}, {0x3a0e, 0x03, 0, 0},
 	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
-	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x4713, 0x03, 0, 0},
+	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0},
 	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
 	{0x3824, 0x02, 0, 0}, {0x5001, 0xa3, 0, 0},
 };
@@ -429,7 +430,7 @@ static const struct reg_value ov5640_setting_QCIF_176_144[] = {
 	{0x3a03, 0xd8, 0, 0}, {0x3a08, 0x01, 0, 0}, {0x3a09, 0x27, 0, 0},
 	{0x3a0a, 0x00, 0, 0}, {0x3a0b, 0xf6, 0, 0}, {0x3a0e, 0x03, 0, 0},
 	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
-	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x4713, 0x03, 0, 0},
+	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0},
 	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
 	{0x3824, 0x02, 0, 0}, {0x5001, 0xa3, 0, 0},
 };
@@ -448,7 +449,7 @@ static const struct reg_value ov5640_setting_NTSC_720_480[] = {
 	{0x3a03, 0xd8, 0, 0}, {0x3a08, 0x01, 0, 0}, {0x3a09, 0x27, 0, 0},
 	{0x3a0a, 0x00, 0, 0}, {0x3a0b, 0xf6, 0, 0}, {0x3a0e, 0x03, 0, 0},
 	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
-	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x4713, 0x03, 0, 0},
+	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0},
 	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
 	{0x3824, 0x02, 0, 0}, {0x5001, 0xa3, 0, 0},
 };
@@ -467,7 +468,7 @@ static const struct reg_value ov5640_setting_PAL_720_576[] = {
 	{0x3a03, 0xd8, 0, 0}, {0x3a08, 0x01, 0, 0}, {0x3a09, 0x27, 0, 0},
 	{0x3a0a, 0x00, 0, 0}, {0x3a0b, 0xf6, 0, 0}, {0x3a0e, 0x03, 0, 0},
 	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
-	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x4713, 0x03, 0, 0},
+	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0},
 	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
 	{0x3824, 0x02, 0, 0}, {0x5001, 0xa3, 0, 0},
 };
@@ -486,7 +487,7 @@ static const struct reg_value ov5640_setting_720P_1280_720[] = {
 	{0x3a03, 0xe4, 0, 0}, {0x3a08, 0x01, 0, 0}, {0x3a09, 0xbc, 0, 0},
 	{0x3a0a, 0x01, 0, 0}, {0x3a0b, 0x72, 0, 0}, {0x3a0e, 0x01, 0, 0},
 	{0x3a0d, 0x02, 0, 0}, {0x3a14, 0x02, 0, 0}, {0x3a15, 0xe4, 0, 0},
-	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x4713, 0x03, 0, 0},
+	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0},
 	{0x4407, 0x04, 0, 0}, {0x460b, 0x37, 0, 0}, {0x460c, 0x20, 0, 0},
 	{0x3824, 0x04, 0, 0}, {0x5001, 0x83, 0, 0},
 };
@@ -506,7 +507,7 @@ static const struct reg_value ov5640_setting_1080P_1920_1080[] = {
 	{0x3a03, 0xd8, 0, 0}, {0x3a08, 0x01, 0, 0}, {0x3a09, 0x27, 0, 0},
 	{0x3a0a, 0x00, 0, 0}, {0x3a0b, 0xf6, 0, 0}, {0x3a0e, 0x03, 0, 0},
 	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
-	{0x4001, 0x02, 0, 0}, {0x4004, 0x06, 0, 0}, {0x4713, 0x03, 0, 0},
+	{0x4001, 0x02, 0, 0}, {0x4004, 0x06, 0, 0},
 	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
 	{0x3824, 0x02, 0, 0}, {0x5001, 0x83, 0, 0},
 	{0x3c07, 0x07, 0, 0}, {0x3c08, 0x00, 0, 0},
@@ -518,7 +519,7 @@ static const struct reg_value ov5640_setting_1080P_1920_1080[] = {
 	{0x3a02, 0x04, 0, 0}, {0x3a03, 0x60, 0, 0}, {0x3a08, 0x01, 0, 0},
 	{0x3a09, 0x50, 0, 0}, {0x3a0a, 0x01, 0, 0}, {0x3a0b, 0x18, 0, 0},
 	{0x3a0e, 0x03, 0, 0}, {0x3a0d, 0x04, 0, 0}, {0x3a14, 0x04, 0, 0},
-	{0x3a15, 0x60, 0, 0}, {0x4713, 0x02, 0, 0}, {0x4407, 0x04, 0, 0},
+	{0x3a15, 0x60, 0, 0}, {0x4407, 0x04, 0, 0},
 	{0x460b, 0x37, 0, 0}, {0x460c, 0x20, 0, 0}, {0x3824, 0x04, 0, 0},
 	{0x4005, 0x1a, 0, 0}, {0x3008, 0x02, 0, 0},
 };
@@ -537,7 +538,7 @@ static const struct reg_value ov5640_setting_QSXGA_2592_1944[] = {
 	{0x3a03, 0xd8, 0, 0}, {0x3a08, 0x01, 0, 0}, {0x3a09, 0x27, 0, 0},
 	{0x3a0a, 0x00, 0, 0}, {0x3a0b, 0xf6, 0, 0}, {0x3a0e, 0x03, 0, 0},
 	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
-	{0x4001, 0x02, 0, 0}, {0x4004, 0x06, 0, 0}, {0x4713, 0x03, 0, 0},
+	{0x4001, 0x02, 0, 0}, {0x4004, 0x06, 0, 0},
 	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
 	{0x3824, 0x02, 0, 0}, {0x5001, 0x83, 0, 70},
 };
@@ -1051,6 +1052,17 @@ static int ov5640_set_jpeg_timings(struct ov5640_dev *sensor,
 {
 	int ret;
 
+	/*
+	 * compression mode 3 timing
+	 *
+	 * Data is transmitted with programmable width (VFIFO_HSIZE).
+	 * No padding done. Last line may have less data. Varying
+	 * number of lines per frame, depending on amount of data.
+	 */
+	ret = ov5640_mod_reg(sensor, OV5640_REG_JPEG_MODE_SELECT, 0x7, 0x3);
+	if (ret < 0)
+		return ret;
+
 	ret = ov5640_write_reg16(sensor, OV5640_REG_VFIFO_HSIZE, mode->hact);
 	if (ret < 0)
 		return ret;
-- 
2.20.1

