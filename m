Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:35337 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbbKYRie (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Nov 2015 12:38:34 -0500
From: Lucas Stach <l.stach@pengutronix.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, patchwork-lst@pengutronix.de
Subject: [PATCH v2 9/9] [media] tvp5150: disable output while signal not locked
Date: Wed, 25 Nov 2015 18:38:36 +0100
Message-Id: <1448473116-24735-9-git-send-email-l.stach@pengutronix.de>
In-Reply-To: <1448473116-24735-1-git-send-email-l.stach@pengutronix.de>
References: <1448473116-24735-1-git-send-email-l.stach@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Philipp Zabel <p.zabel@pengutronix.de>

To avoid short frames on stream start, keep output pins at high impedance
while we are not properly locked onto the input signal.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/i2c/tvp5150.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 85c5c73098fa..627f8bb58074 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -51,6 +51,7 @@ struct tvp5150 {
 	v4l2_std_id detected_norm;
 	u32 input;
 	u32 output;
+	u32 oe;
 	int enable;
 	bool lock;
 };
@@ -809,8 +810,11 @@ static irqreturn_t tvp5150_isr(int irq, void *dev_id)
 	if (status) {
 		regmap_write(map, TVP5150_INT_STATUS_REG_A, status);
 
-		if (status & TVP5150_INT_A_LOCK)
+		if (status & TVP5150_INT_A_LOCK) {
 			decoder->lock = !!(status & TVP5150_INT_A_LOCK_STATUS);
+			regmap_update_bits(decoder->regmap, TVP5150_MISC_CTL,
+					   0xd, decoder->lock ? decoder->oe : 0);
+		}
 
 		return IRQ_HANDLED;
 	}
@@ -841,6 +845,7 @@ static int tvp5150_enable(struct v4l2_subdev *sd)
 				   0x7, 0x7);
 		/* disable HSYNC, VSYNC/PALI, AVID, and FID/GLCO */
 		regmap_update_bits(decoder->regmap, TVP5150_MISC_CTL, 0x4, 0x0);
+		decoder->oe = 0x9;
 		break;
 	case V4L2_MBUS_PARALLEL:
 		/* 8-bit YUV 4:2:2 */
@@ -848,6 +853,7 @@ static int tvp5150_enable(struct v4l2_subdev *sd)
 				   0x7, 0x0);
 		/* enable HSYNC, VSYNC/PALI, AVID, and FID/GLCO */
 		regmap_update_bits(decoder->regmap, TVP5150_MISC_CTL, 0x4, 0x4);
+		decoder->oe = 0xd;
 		break;
 	default:
 		return -EINVAL;
@@ -994,9 +1000,9 @@ static int tvp5150_s_stream(struct v4l2_subdev *sd, int enable)
 	struct tvp5150 *decoder = container_of(sd, struct tvp5150, sd);
 
 	if (enable) {
-		/* Enable YUV(OUT7:0), clock */
+		/* Enable YUV(OUT7:0), (SYNC), clock signal, if locked */
 		regmap_update_bits(decoder->regmap, TVP5150_MISC_CTL, 0xd,
-			(decoder->bus_type == V4L2_MBUS_BT656) ? 0x9 : 0xd);
+				   decoder->lock ? decoder->oe : 0);
 		if (decoder->irq) {
 			/* Enable lock interrupt */
 			regmap_update_bits(decoder->regmap,
-- 
2.6.2

