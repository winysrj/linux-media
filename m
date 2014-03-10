Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48726 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbaCJXOs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 19:14:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2 31/48] adv7604: Add 16-bit read functions for CP and HDMI
Date: Tue, 11 Mar 2014 00:15:42 +0100
Message-Id: <1394493359-14115-32-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1394493359-14115-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1394493359-14115-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/adv7604.c | 48 ++++++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 81d737c..75b3dae 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -542,6 +542,11 @@ static inline int hdmi_read(struct v4l2_subdev *sd, u8 reg)
 	return adv_smbus_read_byte_data(state->i2c_hdmi, reg);
 }
 
+static u16 hdmi_read16(struct v4l2_subdev *sd, u8 reg, u16 mask)
+{
+	return ((hdmi_read(sd, reg) << 8) | hdmi_read(sd, reg + 1)) & mask;
+}
+
 static inline int hdmi_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 {
 	struct adv7604_state *state = to_state(sd);
@@ -575,6 +580,11 @@ static inline int cp_read(struct v4l2_subdev *sd, u8 reg)
 	return adv_smbus_read_byte_data(state->i2c_cp, reg);
 }
 
+static u16 cp_read16(struct v4l2_subdev *sd, u8 reg, u16 mask)
+{
+	return ((cp_read(sd, reg) << 8) | cp_read(sd, reg + 1)) & mask;
+}
+
 static inline int cp_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 {
 	struct adv7604_state *state = to_state(sd);
@@ -1203,8 +1213,8 @@ static int read_stdi(struct v4l2_subdev *sd, struct stdi_readback *stdi)
 	}
 
 	/* read STDI */
-	stdi->bl = ((cp_read(sd, 0xb1) & 0x3f) << 8) | cp_read(sd, 0xb2);
-	stdi->lcf = ((cp_read(sd, 0xb3) & 0x7) << 8) | cp_read(sd, 0xb4);
+	stdi->bl = cp_read16(sd, 0xb1, 0x3fff);
+	stdi->lcf = cp_read16(sd, 0xb3, 0x7ff);
 	stdi->lcvs = cp_read(sd, 0xb3) >> 3;
 	stdi->interlaced = io_read(sd, 0x12) & 0x10;
 
@@ -1315,8 +1325,8 @@ static int adv7604_query_dv_timings(struct v4l2_subdev *sd,
 
 		timings->type = V4L2_DV_BT_656_1120;
 
-		bt->width = (hdmi_read(sd, 0x07) & 0x0f) * 256 + hdmi_read(sd, 0x08);
-		bt->height = (hdmi_read(sd, 0x09) & 0x0f) * 256 + hdmi_read(sd, 0x0a);
+		bt->width = hdmi_read16(sd, 0x07, 0xfff);
+		bt->height = hdmi_read16(sd, 0x09, 0xfff);
 		freq = (hdmi_read(sd, 0x06) * 1000000) +
 			((hdmi_read(sd, 0x3b) & 0x30) >> 4) * 250000;
 		if (is_hdmi(sd)) {
@@ -1326,29 +1336,19 @@ static int adv7604_query_dv_timings(struct v4l2_subdev *sd,
 			freq = freq * 8 / bits_per_channel;
 		}
 		bt->pixelclock = freq;
-		bt->hfrontporch = (hdmi_read(sd, 0x20) & 0x03) * 256 +
-			hdmi_read(sd, 0x21);
-		bt->hsync = (hdmi_read(sd, 0x22) & 0x03) * 256 +
-			hdmi_read(sd, 0x23);
-		bt->hbackporch = (hdmi_read(sd, 0x24) & 0x03) * 256 +
-			hdmi_read(sd, 0x25);
-		bt->vfrontporch = ((hdmi_read(sd, 0x2a) & 0x1f) * 256 +
-			hdmi_read(sd, 0x2b)) / 2;
-		bt->vsync = ((hdmi_read(sd, 0x2e) & 0x1f) * 256 +
-			hdmi_read(sd, 0x2f)) / 2;
-		bt->vbackporch = ((hdmi_read(sd, 0x32) & 0x1f) * 256 +
-			hdmi_read(sd, 0x33)) / 2;
+		bt->hfrontporch = hdmi_read16(sd, 0x20, 0x3ff);
+		bt->hsync = hdmi_read16(sd, 0x22, 0x3ff);
+		bt->hbackporch = hdmi_read16(sd, 0x24, 0x3ff);
+		bt->vfrontporch = hdmi_read16(sd, 0x2a, 0x1fff) / 2;
+		bt->vsync = hdmi_read16(sd, 0x2e, 0x1fff) / 2;
+		bt->vbackporch = hdmi_read16(sd, 0x32, 0x1fff) / 2;
 		bt->polarities = ((hdmi_read(sd, 0x05) & 0x10) ? V4L2_DV_VSYNC_POS_POL : 0) |
 			((hdmi_read(sd, 0x05) & 0x20) ? V4L2_DV_HSYNC_POS_POL : 0);
 		if (bt->interlaced == V4L2_DV_INTERLACED) {
-			bt->height += (hdmi_read(sd, 0x0b) & 0x0f) * 256 +
-					hdmi_read(sd, 0x0c);
-			bt->il_vfrontporch = ((hdmi_read(sd, 0x2c) & 0x1f) * 256 +
-					hdmi_read(sd, 0x2d)) / 2;
-			bt->il_vsync = ((hdmi_read(sd, 0x30) & 0x1f) * 256 +
-					hdmi_read(sd, 0x31)) / 2;
-			bt->vbackporch = ((hdmi_read(sd, 0x34) & 0x1f) * 256 +
-					hdmi_read(sd, 0x35)) / 2;
+			bt->height += hdmi_read16(sd, 0x0b, 0xfff);
+			bt->il_vfrontporch = hdmi_read16(sd, 0x2c, 0x1fff) / 2;
+			bt->il_vsync = hdmi_read16(sd, 0x30, 0x1fff) / 2;
+			bt->vbackporch = hdmi_read16(sd, 0x34, 0x1fff) / 2;
 		}
 		adv7604_fill_optional_dv_timings_fields(sd, timings);
 	} else {
-- 
1.8.3.2

