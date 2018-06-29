Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:59081 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752905AbeF2Qm4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Jun 2018 12:42:56 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: mchehab@kernel.org, laurent.pinchart@ideasonboard.com,
        maxime.ripard@bootlin.com, sam@elite-embedded.com,
        hugues.fruchet@st.com, loic.poulain@linaro.org, daniel@zonque.org
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, Jacopo Mondi <jacopo@jmondi.org>
Subject: [PATCH 1/2] media: i2c: ov5640: Re-work MIPI start sequence
Date: Fri, 29 Jun 2018 18:42:39 +0200
Message-Id: <1530290560-25806-2-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1530290560-25806-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1530290560-25806-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jacopo Mondi <jacopo@jmondi.org>

Change the MIPI CSI-2 interface startup sequence to the following:

Initialization:
0x3019 = 0x70 : Lane1, Lane2 and clock in LP11 when in 'sleep mode'
0x300e = 0x58 : 2 lanes mode, power down TX and RX, MIPI CSI-2 off
0x4800 = 0x20 : Gate clock when not transmitting, LP00 when not transmitting

Stream on:
0x300e = 0x4c : 2 lanes mode, power up TX and enable MIPI

Stream off:
0x300e = 0x58 : 2 lanes mode, power down TX and RX, MIPI CSI-2 off

Signed-off-by: Jacopo Mondi <jacopo@jmondi.org>
---
 drivers/media/i2c/ov5640.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 1ecbb7a..465acce 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -259,6 +259,7 @@ static inline struct v4l2_subdev *ctrl_to_sd(struct v4l2_ctrl *ctrl)
 static const struct reg_value ov5640_init_setting_30fps_VGA[] = {
 	{0x3103, 0x11, 0, 0}, {0x3008, 0x82, 0, 5}, {0x3008, 0x42, 0, 0},
 	{0x3103, 0x03, 0, 0}, {0x3017, 0x00, 0, 0}, {0x3018, 0x00, 0, 0},
+	{0x3019, 0x70, 0, 0},
 	{0x3034, 0x18, 0, 0}, {0x3035, 0x14, 0, 0}, {0x3036, 0x38, 0, 0},
 	{0x3037, 0x13, 0, 0}, {0x3630, 0x36, 0, 0},
 	{0x3631, 0x0e, 0, 0}, {0x3632, 0xe2, 0, 0}, {0x3633, 0x12, 0, 0},
@@ -286,10 +287,10 @@ static const struct reg_value ov5640_init_setting_30fps_VGA[] = {
 	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
 	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x3000, 0x00, 0, 0},
 	{0x3002, 0x1c, 0, 0}, {0x3004, 0xff, 0, 0}, {0x3006, 0xc3, 0, 0},
-	{0x300e, 0x45, 0, 0}, {0x302e, 0x08, 0, 0}, {0x4300, 0x3f, 0, 0},
+	{0x300e, 0x58, 0, 0}, {0x302e, 0x08, 0, 0}, {0x4300, 0x3f, 0, 0},
 	{0x501f, 0x00, 0, 0}, {0x4713, 0x03, 0, 0}, {0x4407, 0x04, 0, 0},
 	{0x440e, 0x00, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
-	{0x4837, 0x0a, 0, 0}, {0x4800, 0x04, 0, 0}, {0x3824, 0x02, 0, 0},
+	{0x4837, 0x0a, 0, 0}, {0x4800, 0x20, 0, 0}, {0x3824, 0x02, 0, 0},
 	{0x5000, 0xa7, 0, 0}, {0x5001, 0xa3, 0, 0}, {0x5180, 0xff, 0, 0},
 	{0x5181, 0xf2, 0, 0}, {0x5182, 0x00, 0, 0}, {0x5183, 0x14, 0, 0},
 	{0x5184, 0x25, 0, 0}, {0x5185, 0x24, 0, 0}, {0x5186, 0x09, 0, 0},
@@ -1102,12 +1103,21 @@ static int ov5640_set_stream_mipi(struct ov5640_dev *sensor, bool on)
 {
 	int ret;
 
-	ret = ov5640_mod_reg(sensor, OV5640_REG_MIPI_CTRL00, BIT(5),
-			     on ? 0 : BIT(5));
-	if (ret)
-		return ret;
-	ret = ov5640_write_reg(sensor, OV5640_REG_PAD_OUTPUT00,
-			       on ? 0x00 : 0x70);
+	/*
+	 * powerup MIPI TX PHY & enable MIPI
+	 *
+	 * 0x4c: [7:5] 010 two lanes MIPI (FIXME: 'debug mode' in manual)
+	 *	 [4]   0 power on MIPI TX
+	 *	 [3]   1 power off MIPI RX
+	 *	 [2]   1 enable MIPI
+	 *
+	 * 0x58: [7:5] 010 two lanes MIPI (FIXME: 'debug mode' in manual)
+	 *	 [4]   1 power off MIPI TX
+	 *	 [3]   1 power off MIPI RX
+	 *	 [2]   0 disable MIPI
+	 */
+	ret = ov5640_write_reg(sensor,
+			       OV5640_REG_IO_MIPI_CTRL00, on ? 0x4c : 0x58);
 	if (ret)
 		return ret;
 
-- 
2.7.4
