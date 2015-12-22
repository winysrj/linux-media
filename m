Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:37254 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbbLVOWI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Dec 2015 09:22:08 -0500
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: linux-media@vger.kernel.org, linux-sh@vger.kernel.org
Cc: magnus.damm@gmail.com, laurent.pinchart@ideasonboard.com,
	hans.verkuil@cisco.com, ian.molton@codethink.co.uk,
	lars@metafoo.de, william.towle@codethink.co.uk,
	Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Subject: [PATCH v2 1/2] media: adv7604: implement get_selection
Date: Tue, 22 Dec 2015 15:22:01 +0100
Message-Id: <1450794122-31293-2-git-send-email-ulrich.hecht+renesas@gmail.com>
In-Reply-To: <1450794122-31293-1-git-send-email-ulrich.hecht+renesas@gmail.com>
References: <1450794122-31293-1-git-send-email-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The rcar_vin driver relies on this.

Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
---
 drivers/media/i2c/adv7604.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index be5980c..8ad5c28 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -1885,6 +1885,26 @@ static int adv76xx_get_format(struct v4l2_subdev *sd,
 	return 0;
 }
 
+static int adv76xx_get_selection(struct v4l2_subdev *sd,
+				 struct v4l2_subdev_pad_config *cfg,
+				 struct v4l2_subdev_selection *sel)
+{
+	struct adv76xx_state *state = to_state(sd);
+
+	if (sel->which != V4L2_SUBDEV_FORMAT_ACTIVE)
+		return -EINVAL;
+	/* Only CROP, CROP_DEFAULT and CROP_BOUNDS are supported */
+	if (sel->target > V4L2_SEL_TGT_CROP_BOUNDS)
+		return -EINVAL;
+
+	sel->r.left	= 0;
+	sel->r.top	= 0;
+	sel->r.width	= state->timings.bt.width;
+	sel->r.height	= state->timings.bt.height;
+
+	return 0;
+}
+
 static int adv76xx_set_format(struct v4l2_subdev *sd,
 			      struct v4l2_subdev_pad_config *cfg,
 			      struct v4l2_subdev_format *format)
@@ -2415,6 +2435,7 @@ static const struct v4l2_subdev_video_ops adv76xx_video_ops = {
 
 static const struct v4l2_subdev_pad_ops adv76xx_pad_ops = {
 	.enum_mbus_code = adv76xx_enum_mbus_code,
+	.get_selection = adv76xx_get_selection,
 	.get_fmt = adv76xx_get_format,
 	.set_fmt = adv76xx_set_format,
 	.get_edid = adv76xx_get_edid,
-- 
2.6.3

