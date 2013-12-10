Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3849 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059Ab3LJPGC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Dec 2013 10:06:02 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 01/22] adv7842: Re-worked query_dv_timings()
Date: Tue, 10 Dec 2013 16:03:47 +0100
Message-Id: <0b624eb4cc9c2b7c88323771dca10c503785fcb7.1386687810.git.hans.verkuil@cisco.com>
In-Reply-To: <1386687848-21265-1-git-send-email-hverkuil@xs4all.nl>
References: <1386687848-21265-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Martin Bugge <marbugge@cisco.com>

This simplified the code quite a bit.

Signed-off-by: Martin Bugge <marbugge@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7842.c | 112 ++++++++++++++------------------------------
 1 file changed, 35 insertions(+), 77 deletions(-)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index b154f36..22fa4ca 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -1314,6 +1314,8 @@ static int adv7842_query_dv_timings(struct v4l2_subdev *sd,
 	struct v4l2_bt_timings *bt = &timings->bt;
 	struct stdi_readback stdi = { 0 };
 
+	v4l2_dbg(1, debug, sd, "%s:\n", __func__);
+
 	/* SDP block */
 	if (state->mode == ADV7842_MODE_SDP)
 		return -ENODATA;
@@ -1325,92 +1327,46 @@ static int adv7842_query_dv_timings(struct v4l2_subdev *sd,
 	}
 	bt->interlaced = stdi.interlaced ?
 		V4L2_DV_INTERLACED : V4L2_DV_PROGRESSIVE;
-	bt->polarities = ((hdmi_read(sd, 0x05) & 0x10) ? V4L2_DV_VSYNC_POS_POL : 0) |
-		((hdmi_read(sd, 0x05) & 0x20) ? V4L2_DV_HSYNC_POS_POL : 0);
-	bt->vsync = stdi.lcvs;
 
 	if (is_digital_input(sd)) {
-		bool lock = hdmi_read(sd, 0x04) & 0x02;
-		bool interlaced = hdmi_read(sd, 0x0b) & 0x20;
-		unsigned w = (hdmi_read(sd, 0x07) & 0x1f) * 256 + hdmi_read(sd, 0x08);
-		unsigned h = (hdmi_read(sd, 0x09) & 0x1f) * 256 + hdmi_read(sd, 0x0a);
-		unsigned w_total = (hdmi_read(sd, 0x1e) & 0x3f) * 256 +
-			hdmi_read(sd, 0x1f);
-		unsigned h_total = ((hdmi_read(sd, 0x26) & 0x3f) * 256 +
-				    hdmi_read(sd, 0x27)) / 2;
-		unsigned freq = (((hdmi_read(sd, 0x51) << 1) +
-					(hdmi_read(sd, 0x52) >> 7)) * 1000000) +
-			((hdmi_read(sd, 0x52) & 0x7f) * 1000000) / 128;
-		int i;
+		uint32_t freq;
+
+		timings->type = V4L2_DV_BT_656_1120;
+		bt->width = (hdmi_read(sd, 0x07) & 0x0f) * 256 + hdmi_read(sd, 0x08);
+		bt->height = (hdmi_read(sd, 0x09) & 0x0f) * 256 + hdmi_read(sd, 0x0a);
+		freq = (hdmi_read(sd, 0x06) * 1000000) +
+		       ((hdmi_read(sd, 0x3b) & 0x30) >> 4) * 250000;
 
 		if (is_hdmi(sd)) {
 			/* adjust for deep color mode */
-			freq = freq * 8 / (((hdmi_read(sd, 0x0b) & 0xc0)>>6) * 2 + 8);
-		}
-
-		/* No lock? */
-		if (!lock) {
-			v4l2_dbg(1, debug, sd, "%s: no lock on TMDS signal\n", __func__);
-			return -ENOLCK;
+			freq = freq * 8 / (((hdmi_read(sd, 0x0b) & 0xc0) >> 5) + 8);
 		}
-		/* Interlaced? */
-		if (interlaced) {
-			v4l2_dbg(1, debug, sd, "%s: interlaced video not supported\n", __func__);
-			return -ERANGE;
-		}
-
-		for (i = 0; v4l2_dv_timings_presets[i].bt.width; i++) {
-			const struct v4l2_bt_timings *bt = &v4l2_dv_timings_presets[i].bt;
-
-			if (!v4l2_valid_dv_timings(&v4l2_dv_timings_presets[i],
-						   adv7842_get_dv_timings_cap(sd),
-						   adv7842_check_dv_timings, NULL))
-				continue;
-			if (w_total != htotal(bt) || h_total != vtotal(bt))
-				continue;
-
-			if (w != bt->width || h != bt->height)
-				continue;
-
-			if (abs(freq - bt->pixelclock) > 1000000)
-				continue;
-			*timings = v4l2_dv_timings_presets[i];
-			return 0;
-		}
-
-		timings->type = V4L2_DV_BT_656_1120;
-
-		bt->width = w;
-		bt->height = h;
-		bt->interlaced = (hdmi_read(sd, 0x0b) & 0x20) ?
-			V4L2_DV_INTERLACED : V4L2_DV_PROGRESSIVE;
-		bt->polarities = ((hdmi_read(sd, 0x05) & 0x10) ?
-			V4L2_DV_VSYNC_POS_POL : 0) | ((hdmi_read(sd, 0x05) & 0x20) ?
-			V4L2_DV_HSYNC_POS_POL : 0);
-		bt->pixelclock = (((hdmi_read(sd, 0x51) << 1) +
-				   (hdmi_read(sd, 0x52) >> 7)) * 1000000) +
-				 ((hdmi_read(sd, 0x52) & 0x7f) * 1000000) / 128;
-		bt->hfrontporch = (hdmi_read(sd, 0x20) & 0x1f) * 256 +
+		bt->pixelclock = freq;
+		bt->hfrontporch = (hdmi_read(sd, 0x20) & 0x03) * 256 +
 			hdmi_read(sd, 0x21);
-		bt->hsync = (hdmi_read(sd, 0x22) & 0x1f) * 256 +
+		bt->hsync = (hdmi_read(sd, 0x22) & 0x03) * 256 +
 			hdmi_read(sd, 0x23);
-		bt->hbackporch = (hdmi_read(sd, 0x24) & 0x1f) * 256 +
+		bt->hbackporch = (hdmi_read(sd, 0x24) & 0x03) * 256 +
 			hdmi_read(sd, 0x25);
-		bt->vfrontporch = ((hdmi_read(sd, 0x2a) & 0x3f) * 256 +
-				   hdmi_read(sd, 0x2b)) / 2;
-		bt->il_vfrontporch = ((hdmi_read(sd, 0x2c) & 0x3f) * 256 +
-				      hdmi_read(sd, 0x2d)) / 2;
-		bt->vsync = ((hdmi_read(sd, 0x2e) & 0x3f) * 256 +
-			     hdmi_read(sd, 0x2f)) / 2;
-		bt->il_vsync = ((hdmi_read(sd, 0x30) & 0x3f) * 256 +
-				hdmi_read(sd, 0x31)) / 2;
-		bt->vbackporch = ((hdmi_read(sd, 0x32) & 0x3f) * 256 +
-				  hdmi_read(sd, 0x33)) / 2;
-		bt->il_vbackporch = ((hdmi_read(sd, 0x34) & 0x3f) * 256 +
-				     hdmi_read(sd, 0x35)) / 2;
-
-		bt->standards = 0;
-		bt->flags = 0;
+		bt->vfrontporch = ((hdmi_read(sd, 0x2a) & 0x1f) * 256 +
+			hdmi_read(sd, 0x2b)) / 2;
+		bt->vsync = ((hdmi_read(sd, 0x2e) & 0x1f) * 256 +
+			hdmi_read(sd, 0x2f)) / 2;
+		bt->vbackporch = ((hdmi_read(sd, 0x32) & 0x1f) * 256 +
+			hdmi_read(sd, 0x33)) / 2;
+		bt->polarities = ((hdmi_read(sd, 0x05) & 0x10) ? V4L2_DV_VSYNC_POS_POL : 0) |
+			((hdmi_read(sd, 0x05) & 0x20) ? V4L2_DV_HSYNC_POS_POL : 0);
+		if (bt->interlaced == V4L2_DV_INTERLACED) {
+			bt->height += (hdmi_read(sd, 0x0b) & 0x0f) * 256 +
+					hdmi_read(sd, 0x0c);
+			bt->il_vfrontporch = ((hdmi_read(sd, 0x2c) & 0x1f) * 256 +
+					hdmi_read(sd, 0x2d)) / 2;
+			bt->il_vsync = ((hdmi_read(sd, 0x30) & 0x1f) * 256 +
+					hdmi_read(sd, 0x31)) / 2;
+			bt->vbackporch = ((hdmi_read(sd, 0x34) & 0x1f) * 256 +
+					hdmi_read(sd, 0x35)) / 2;
+		}
+		adv7842_fill_optional_dv_timings_fields(sd, timings);
 	} else {
 		/* Interlaced? */
 		if (stdi.interlaced) {
@@ -1437,6 +1393,8 @@ static int adv7842_s_dv_timings(struct v4l2_subdev *sd,
 	struct v4l2_bt_timings *bt;
 	int err;
 
+	v4l2_dbg(1, debug, sd, "%s:\n", __func__);
+
 	if (state->mode == ADV7842_MODE_SDP)
 		return -ENODATA;
 
-- 
1.8.4.rc3

