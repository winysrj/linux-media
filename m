Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2563 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab3HSOoq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Aug 2013 10:44:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: marbugge@cisco.com, matrandg@cisco.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 05/20] adv7604: print flags and standards in timing information
Date: Mon, 19 Aug 2013 16:44:14 +0200
Message-Id: <1376923469-30694-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1376923469-30694-1-git-send-email-hverkuil@xs4all.nl>
References: <1376923469-30694-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mats Randgaard <matrandg@cisco.com>

Signed-off-by: Mats Randgaard <matrandg@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c | 41 ++++++++++++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 13 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 34fcdf3..e732c9b 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -1052,7 +1052,8 @@ static int adv7604_g_input_status(struct v4l2_subdev *sd, u32 *status)
 /* ----------------------------------------------------------------------- */
 
 static void adv7604_print_timings(struct v4l2_subdev *sd,
-	struct v4l2_dv_timings *timings, const char *txt, bool detailed)
+				  struct v4l2_dv_timings *timings,
+				  const char *txt, bool detailed)
 {
 	struct v4l2_bt_timings *bt = &timings->bt;
 	u32 htot, vtot;
@@ -1069,18 +1070,32 @@ static void adv7604_print_timings(struct v4l2_subdev *sd,
 				(htot * vtot)) : 0,
 			htot, vtot);
 
-	if (detailed) {
-		v4l2_info(sd, "    horizontal: fp = %d, %ssync = %d, bp = %d\n",
-				bt->hfrontporch,
-				(bt->polarities & V4L2_DV_HSYNC_POS_POL) ? "+" : "-",
-				bt->hsync, bt->hbackporch);
-		v4l2_info(sd, "    vertical: fp = %d, %ssync = %d, bp = %d\n",
-				bt->vfrontporch,
-				(bt->polarities & V4L2_DV_VSYNC_POS_POL) ? "+" : "-",
-				bt->vsync, bt->vbackporch);
-		v4l2_info(sd, "    pixelclock: %lld, flags: 0x%x, standards: 0x%x\n",
-				bt->pixelclock, bt->flags, bt->standards);
-	}
+	if (!detailed)
+		return;
+
+	v4l2_info(sd, "    horizontal: fp = %d, %ssync = %d, bp = %d\n",
+			bt->hfrontporch,
+			(bt->polarities & V4L2_DV_HSYNC_POS_POL) ? "+" : "-",
+			bt->hsync, bt->hbackporch);
+	v4l2_info(sd, "    vertical: fp = %d, %ssync = %d, bp = %d\n",
+			bt->vfrontporch,
+			(bt->polarities & V4L2_DV_VSYNC_POS_POL) ? "+" : "-",
+			bt->vsync, bt->vbackporch);
+	v4l2_info(sd, "    pixelclock: %lld\n", bt->pixelclock);
+	v4l2_info(sd, "    flags (0x%x):%s%s%s%s\n", bt->flags,
+			(bt->flags & V4L2_DV_FL_REDUCED_BLANKING) ?
+			" Reduced blanking," : "",
+			(bt->flags & V4L2_DV_FL_CAN_REDUCE_FPS) ?
+			" Can reduce FPS," : "",
+			(bt->flags & V4L2_DV_FL_REDUCED_FPS) ?
+			" Reduced FPS," : "",
+			(bt->flags & V4L2_DV_FL_HALF_LINE) ?
+			" Half line," : "");
+	v4l2_info(sd, "    standards (0x%x):%s%s%s%s\n", bt->standards,
+			(bt->standards & V4L2_DV_BT_STD_CEA861) ?  " CEA," : "",
+			(bt->standards & V4L2_DV_BT_STD_DMT) ?  " DMT," : "",
+			(bt->standards & V4L2_DV_BT_STD_CVT) ?  " CVT" : "",
+			(bt->standards & V4L2_DV_BT_STD_GTF) ?  " GTF" : "");
 }
 
 struct stdi_readback {
-- 
1.8.3.2

