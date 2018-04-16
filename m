Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:53162 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753197AbeDPMhY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 08:37:24 -0400
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
Subject: [PATCH v2 04/12] media: ov5640: Init properly the SCLK dividers
Date: Mon, 16 Apr 2018 14:36:53 +0200
Message-Id: <20180416123701.15901-5-maxime.ripard@bootlin.com>
In-Reply-To: <20180416123701.15901-1-maxime.ripard@bootlin.com>
References: <20180416123701.15901-1-maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The SCLK and SCLK2X dividers are fixed in stone in the initialization
array. Let's make explicit what we're doing and move that away from the
huge array to the initialization code.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/media/i2c/ov5640.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index a41e4cd5fd17..5b7995abc0e6 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -92,6 +92,9 @@
 #define OV5640_REG_SDE_CTRL5		0x5585
 #define OV5640_REG_AVG_READOUT		0x56a1
 
+#define OV5640_SCLK2X_ROOT_DIVIDER_DEFAULT	1
+#define OV5640_SCLK_ROOT_DIVIDER_DEFAULT	2
+
 enum ov5640_mode_id {
 	OV5640_MODE_QCIF_176_144 = 0,
 	OV5640_MODE_QVGA_320_240,
@@ -251,7 +254,7 @@ static const struct reg_value ov5640_init_setting_30fps_VGA[] = {
 	{0x3103, 0x11, 0, 0}, {0x3008, 0x82, 0, 5}, {0x3008, 0x42, 0, 0},
 	{0x3103, 0x03, 0, 0}, {0x3017, 0x00, 0, 0}, {0x3018, 0x00, 0, 0},
 	{0x3034, 0x18, 0, 0}, {0x3035, 0x14, 0, 0}, {0x3036, 0x38, 0, 0},
-	{0x3037, 0x13, 0, 0}, {0x3108, 0x01, 0, 0}, {0x3630, 0x36, 0, 0},
+	{0x3037, 0x13, 0, 0}, {0x3630, 0x36, 0, 0},
 	{0x3631, 0x0e, 0, 0}, {0x3632, 0xe2, 0, 0}, {0x3633, 0x12, 0, 0},
 	{0x3621, 0xe0, 0, 0}, {0x3704, 0xa0, 0, 0}, {0x3703, 0x5a, 0, 0},
 	{0x3715, 0x78, 0, 0}, {0x3717, 0x01, 0, 0}, {0x370b, 0x60, 0, 0},
@@ -1662,6 +1665,12 @@ static int ov5640_restore_mode(struct ov5640_dev *sensor)
 	if (ret < 0)
 		return ret;
 
+	ret = ov5640_mod_reg(sensor, OV5640_REG_SYS_ROOT_DIVIDER, 0x3f,
+			     (ilog2(OV5640_SCLK2X_ROOT_DIVIDER_DEFAULT) << 2) |
+			     ilog2(OV5640_SCLK_ROOT_DIVIDER_DEFAULT));
+	if (ret)
+		return ret;
+
 	/* now restore the last capture mode */
 	ret = ov5640_set_mode(sensor, &ov5640_mode_init_data);
 	if (ret < 0)
-- 
2.17.0
