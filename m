Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:39805 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753427AbeF1QVY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Jun 2018 12:21:24 -0400
From: Marco Felsch <m.felsch@pengutronix.de>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com
Cc: p.zabel@pengutronix.de, afshin.nasser@gmail.com,
        javierm@redhat.com, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 14/22] [media] tvp5150: issue source change events
Date: Thu, 28 Jun 2018 18:20:46 +0200
Message-Id: <20180628162054.25613-15-m.felsch@pengutronix.de>
In-Reply-To: <20180628162054.25613-1-m.felsch@pengutronix.de>
References: <20180628162054.25613-1-m.felsch@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Philipp Zabel <p.zabel@pengutronix.de>

Issue a V4L2_EVENT_SOURCE_CHANGE notification when the TVP5150 locks
onto a signal and when it loses the lock.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
[m.felsch@pengutronix.de: partly mainline part port]
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
---
 drivers/media/i2c/tvp5150.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 27cfd08be3d2..6296c68ac816 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -796,6 +796,11 @@ static v4l2_std_id tvp5150_read_std(struct v4l2_subdev *sd)
 	}
 }
 
+static const struct v4l2_event tvp5150_ev_fmt = {
+	.type = V4L2_EVENT_SOURCE_CHANGE,
+	.u.src_change.changes = V4L2_EVENT_SRC_CH_RESOLUTION,
+};
+
 static irqreturn_t tvp5150_isr(int irq, void *dev_id)
 {
 	struct tvp5150 *decoder = dev_id;
@@ -811,6 +816,7 @@ static irqreturn_t tvp5150_isr(int irq, void *dev_id)
 
 		if (status & TVP5150_INT_A_LOCK) {
 			decoder->lock = !!(status & TVP5150_INT_A_LOCK_STATUS);
+			v4l2_subdev_notify_event(&decoder->sd, &tvp5150_ev_fmt);
 			regmap_update_bits(map, TVP5150_MISC_CTL, mask,
 					   decoder->lock ? decoder->oe : 0);
 		}
@@ -1216,6 +1222,7 @@ static int tvp5150_s_stream(struct v4l2_subdev *sd, int enable)
 		/* Enable outputs if decoder is locked */
 		val = decoder->lock ? decoder->oe : 0;
 		int_val = TVP5150_INT_A_LOCK;
+		v4l2_subdev_notify_event(&decoder->sd, &tvp5150_ev_fmt);
 	}
 
 	regmap_update_bits(decoder->regmap, TVP5150_MISC_CTL, mask, val);
@@ -1432,7 +1439,6 @@ static const struct v4l2_subdev_internal_ops tvp5150_internal_ops = {
 	.registered = tvp5150_registered,
 };
 
-
 /****************************************************************************
 			I2C Client & Driver
  ****************************************************************************/
-- 
2.17.1
