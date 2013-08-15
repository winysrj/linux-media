Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2469 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166Ab3HOLhb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Aug 2013 07:37:31 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>,
	Mats Randgaard <matrandg@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 11/12] ad9389b/adv7604/ths8200: use new v4l2_print_dv_timings helper.
Date: Thu, 15 Aug 2013 13:36:33 +0200
Message-Id: <0ebea6c8fd6ea31bb22d5c1ea6830103829b0225.1376566340.git.hans.verkuil@cisco.com>
In-Reply-To: <1376566594-427-1-git-send-email-hverkuil@xs4all.nl>
References: <1376566594-427-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <b1134caad54251cdfc8191a446a160ecc986f9b9.1376566340.git.hans.verkuil@cisco.com>
References: <b1134caad54251cdfc8191a446a160ecc986f9b9.1376566340.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

These three drivers all have code to log the dv_timings contents. Replace
that code with the new helper function.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/ad9389b.c | 17 +++----------
 drivers/media/i2c/adv7604.c | 61 ++++++---------------------------------------
 drivers/media/i2c/ths8200.c | 38 ++--------------------------
 3 files changed, 14 insertions(+), 102 deletions(-)

diff --git a/drivers/media/i2c/ad9389b.c b/drivers/media/i2c/ad9389b.c
index 92cdb25..1c6d352 100644
--- a/drivers/media/i2c/ad9389b.c
+++ b/drivers/media/i2c/ad9389b.c
@@ -443,20 +443,11 @@ static int ad9389b_log_status(struct v4l2_subdev *sd)
 				vic_detect, vic_sent);
 		}
 	}
-	if (state->dv_timings.type == V4L2_DV_BT_656_1120) {
-		struct v4l2_bt_timings *bt = bt = &state->dv_timings.bt;
-		u32 frame_width = V4L2_DV_BT_FRAME_WIDTH(bt);
-		u32 frame_height = V4L2_DV_BT_FRAME_HEIGHT(bt);
-		u32 frame_size = frame_width * frame_height;
-
-		v4l2_info(sd, "timings: %ux%u%s%u (%ux%u). Pix freq. = %u Hz. Polarities = 0x%x\n",
-			bt->width, bt->height, bt->interlaced ? "i" : "p",
-			frame_size > 0 ?  (unsigned)bt->pixelclock / frame_size : 0,
-			frame_width, frame_height,
-			(unsigned)bt->pixelclock, bt->polarities);
-	} else {
+	if (state->dv_timings.type == V4L2_DV_BT_656_1120)
+		v4l2_print_dv_timings(sd->name, "timings: ",
+				&state->dv_timings, false);
+	else
 		v4l2_info(sd, "no timings set\n");
-	}
 	return 0;
 }
 
diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index e732c9b..ba8602c 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -1051,53 +1051,6 @@ static int adv7604_g_input_status(struct v4l2_subdev *sd, u32 *status)
 
 /* ----------------------------------------------------------------------- */
 
-static void adv7604_print_timings(struct v4l2_subdev *sd,
-				  struct v4l2_dv_timings *timings,
-				  const char *txt, bool detailed)
-{
-	struct v4l2_bt_timings *bt = &timings->bt;
-	u32 htot, vtot;
-
-	if (timings->type != V4L2_DV_BT_656_1120)
-		return;
-
-	htot = htotal(bt);
-	vtot = vtotal(bt);
-
-	v4l2_info(sd, "%s %dx%d%s%d (%dx%d)",
-			txt, bt->width, bt->height, bt->interlaced ? "i" : "p",
-			(htot * vtot) > 0 ? ((u32)bt->pixelclock /
-				(htot * vtot)) : 0,
-			htot, vtot);
-
-	if (!detailed)
-		return;
-
-	v4l2_info(sd, "    horizontal: fp = %d, %ssync = %d, bp = %d\n",
-			bt->hfrontporch,
-			(bt->polarities & V4L2_DV_HSYNC_POS_POL) ? "+" : "-",
-			bt->hsync, bt->hbackporch);
-	v4l2_info(sd, "    vertical: fp = %d, %ssync = %d, bp = %d\n",
-			bt->vfrontporch,
-			(bt->polarities & V4L2_DV_VSYNC_POS_POL) ? "+" : "-",
-			bt->vsync, bt->vbackporch);
-	v4l2_info(sd, "    pixelclock: %lld\n", bt->pixelclock);
-	v4l2_info(sd, "    flags (0x%x):%s%s%s%s\n", bt->flags,
-			(bt->flags & V4L2_DV_FL_REDUCED_BLANKING) ?
-			" Reduced blanking," : "",
-			(bt->flags & V4L2_DV_FL_CAN_REDUCE_FPS) ?
-			" Can reduce FPS," : "",
-			(bt->flags & V4L2_DV_FL_REDUCED_FPS) ?
-			" Reduced FPS," : "",
-			(bt->flags & V4L2_DV_FL_HALF_LINE) ?
-			" Half line," : "");
-	v4l2_info(sd, "    standards (0x%x):%s%s%s%s\n", bt->standards,
-			(bt->standards & V4L2_DV_BT_STD_CEA861) ?  " CEA," : "",
-			(bt->standards & V4L2_DV_BT_STD_DMT) ?  " DMT," : "",
-			(bt->standards & V4L2_DV_BT_STD_CVT) ?  " CVT" : "",
-			(bt->standards & V4L2_DV_BT_STD_GTF) ?  " GTF" : "");
-}
-
 struct stdi_readback {
 	u16 bl, lcf, lcvs;
 	u8 hs_pol, vs_pol;
@@ -1360,8 +1313,8 @@ found:
 	}
 
 	if (debug > 1)
-		adv7604_print_timings(sd, timings,
-				"adv7604_query_dv_timings:", true);
+		v4l2_print_dv_timings(sd->name, "adv7604_query_dv_timings: ",
+				      timings, true);
 
 	return 0;
 }
@@ -1403,8 +1356,8 @@ static int adv7604_s_dv_timings(struct v4l2_subdev *sd,
 
 
 	if (debug > 1)
-		adv7604_print_timings(sd, timings,
-				"adv7604_s_dv_timings:", true);
+		v4l2_print_dv_timings(sd->name, "adv7604_s_dv_timings: ",
+				      timings, true);
 	return 0;
 }
 
@@ -1770,8 +1723,10 @@ static int adv7604_log_status(struct v4l2_subdev *sd)
 	if (adv7604_query_dv_timings(sd, &timings))
 		v4l2_info(sd, "No video detected\n");
 	else
-		adv7604_print_timings(sd, &timings, "Detected format:", true);
-	adv7604_print_timings(sd, &state->timings, "Configured format:", true);
+		v4l2_print_dv_timings(sd->name, "Detected format: ",
+				      &timings, true);
+	v4l2_print_dv_timings(sd->name, "Configured format: ",
+			      &state->timings, true);
 
 	if (no_signal(sd))
 		return 0;
diff --git a/drivers/media/i2c/ths8200.c b/drivers/media/i2c/ths8200.c
index 7a60a8f..49041e5 100644
--- a/drivers/media/i2c/ths8200.c
+++ b/drivers/media/i2c/ths8200.c
@@ -133,39 +133,6 @@ static int ths8200_s_register(struct v4l2_subdev *sd,
 }
 #endif
 
-static void ths8200_print_timings(struct v4l2_subdev *sd,
-				  struct v4l2_dv_timings *timings,
-				  const char *txt, bool detailed)
-{
-	struct v4l2_bt_timings *bt = &timings->bt;
-	u32 htot, vtot;
-
-	if (timings->type != V4L2_DV_BT_656_1120)
-		return;
-
-	htot = htotal(bt);
-	vtot = vtotal(bt);
-
-	v4l2_info(sd, "%s %dx%d%s%d (%dx%d)",
-		  txt, bt->width, bt->height, bt->interlaced ? "i" : "p",
-		  (htot * vtot) > 0 ? ((u32)bt->pixelclock / (htot * vtot)) : 0,
-		  htot, vtot);
-
-	if (detailed) {
-		v4l2_info(sd, "    horizontal: fp = %d, %ssync = %d, bp = %d\n",
-			  bt->hfrontporch,
-			  (bt->polarities & V4L2_DV_HSYNC_POS_POL) ? "+" : "-",
-			  bt->hsync, bt->hbackporch);
-		v4l2_info(sd, "    vertical: fp = %d, %ssync = %d, bp = %d\n",
-			  bt->vfrontporch,
-			  (bt->polarities & V4L2_DV_VSYNC_POS_POL) ? "+" : "-",
-			  bt->vsync, bt->vbackporch);
-		v4l2_info(sd,
-			  "    pixelclock: %lld, flags: 0x%x, standards: 0x%x\n",
-			  bt->pixelclock, bt->flags, bt->standards);
-	}
-}
-
 static int ths8200_log_status(struct v4l2_subdev *sd)
 {
 	struct ths8200_state *state = to_state(sd);
@@ -182,9 +149,8 @@ static int ths8200_log_status(struct v4l2_subdev *sd)
 		  ths8200_read(sd, THS8200_DTG2_PIXEL_CNT_LSB),
 		  (ths8200_read(sd, THS8200_DTG2_LINE_CNT_MSB) & 0x07) * 256 +
 		  ths8200_read(sd, THS8200_DTG2_LINE_CNT_LSB));
-	ths8200_print_timings(sd, &state->dv_timings,
-			      "Configured format:", true);
-
+	v4l2_print_dv_timings(sd->name, "Configured format:",
+			      &state->dv_timings, true);
 	return 0;
 }
 
-- 
1.8.3.2

