Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:59946 "EHLO
	metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934511AbcCNPXj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2016 11:23:39 -0400
From: Lucas Stach <l.stach@pengutronix.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, patchwork-lst@pengutronix.de
Subject: [PATCH v3 6/9] [media] tvp5150: trigger autodetection on subdev open to reset cropping
Date: Mon, 14 Mar 2016 16:23:34 +0100
Message-Id: <1457969017-4088-6-git-send-email-l.stach@pengutronix.de>
In-Reply-To: <1457969017-4088-1-git-send-email-l.stach@pengutronix.de>
References: <1457969017-4088-1-git-send-email-l.stach@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Philipp Zabel <p.zabel@pengutronix.de>

If cropping isn't set explicitly by userspace, reset it to the maximum
possible rectangle in subdevice open if a standard change is detected.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
---
 drivers/media/i2c/tvp5150.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index f5e6bfa9dd7f..d0b5e148dcd8 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -46,6 +46,7 @@ struct tvp5150 {
 	struct regmap *regmap;
 
 	v4l2_std_id norm;	/* Current set standard */
+	v4l2_std_id detected_norm;
 	u32 input;
 	u32 output;
 	int enable;
@@ -1220,13 +1221,19 @@ static int tvp5150_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 	struct tvp5150 *decoder = to_tvp5150(sd);
 	v4l2_std_id std;
 
-	if (decoder->norm == V4L2_STD_ALL)
+	if (decoder->norm == V4L2_STD_ALL) {
 		std = tvp5150_read_std(sd);
-	else
-		std = decoder->norm;
+		if (std != decoder->detected_norm) {
+			decoder->detected_norm = std;
+
+			if (std & V4L2_STD_525_60)
+				decoder->rect.height = TVP5150_V_MAX_525_60;
+			else
+				decoder->rect.height = TVP5150_V_MAX_OTHERS;
+			decoder->format.height = decoder->rect.height;
+		}
+	}
 
-	tvp5150_set_default(std, v4l2_subdev_get_try_crop(fh, 0),
-				 v4l2_subdev_get_try_format(fh, 0));
 	return 0;
 }
 #endif
@@ -1443,6 +1450,7 @@ static int tvp5150_probe(struct i2c_client *c,
 	}
 
 	core->norm = V4L2_STD_ALL;	/* Default is autodetect */
+	core->detected_norm = V4L2_STD_UNKNOWN;
 	core->input = TVP5150_COMPOSITE1;
 	core->enable = 1;
 
-- 
2.7.0

