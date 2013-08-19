Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3622 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab3HSOoq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Aug 2013 10:44:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: marbugge@cisco.com, matrandg@cisco.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 10/20] v4l2-dv-timings: add v4l2_print_dv_timings helper
Date: Mon, 19 Aug 2013 16:44:19 +0200
Message-Id: <1376923469-30694-11-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1376923469-30694-1-git-send-email-hverkuil@xs4all.nl>
References: <1376923469-30694-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Drivers often have to log the contents of a dv_timings struct. Adding
this helper will make it easier for drivers to do so.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-dv-timings.c | 49 +++++++++++++++++++++++++++++++
 include/media/v4l2-dv-timings.h           |  9 ++++++
 2 files changed, 58 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index 72cf224..917e58c 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -223,6 +223,55 @@ bool v4l_match_dv_timings(const struct v4l2_dv_timings *t1,
 }
 EXPORT_SYMBOL_GPL(v4l_match_dv_timings);
 
+void v4l2_print_dv_timings(const char *dev_prefix, const char *prefix,
+			   const struct v4l2_dv_timings *t, bool detailed)
+{
+	const struct v4l2_bt_timings *bt = &t->bt;
+	u32 htot, vtot;
+
+	if (t->type != V4L2_DV_BT_656_1120)
+		return;
+
+	htot = V4L2_DV_BT_FRAME_WIDTH(bt);
+	vtot = V4L2_DV_BT_FRAME_HEIGHT(bt);
+
+	if (prefix == NULL)
+		prefix = "";
+
+	pr_info("%s: %s%ux%u%s%u (%ux%u)\n", dev_prefix, prefix,
+		bt->width, bt->height, bt->interlaced ? "i" : "p",
+		(htot * vtot) > 0 ? ((u32)bt->pixelclock / (htot * vtot)) : 0,
+		htot, vtot);
+
+	if (!detailed)
+		return;
+
+	pr_info("%s: horizontal: fp = %u, %ssync = %u, bp = %u\n",
+			dev_prefix, bt->hfrontporch,
+			(bt->polarities & V4L2_DV_HSYNC_POS_POL) ? "+" : "-",
+			bt->hsync, bt->hbackporch);
+	pr_info("%s: vertical: fp = %u, %ssync = %u, bp = %u\n",
+			dev_prefix, bt->vfrontporch,
+			(bt->polarities & V4L2_DV_VSYNC_POS_POL) ? "+" : "-",
+			bt->vsync, bt->vbackporch);
+	pr_info("%s: pixelclock: %llu\n", dev_prefix, bt->pixelclock);
+	pr_info("%s: flags (0x%x):%s%s%s%s\n", dev_prefix, bt->flags,
+			(bt->flags & V4L2_DV_FL_REDUCED_BLANKING) ?
+			" REDUCED_BLANKING" : "",
+			(bt->flags & V4L2_DV_FL_CAN_REDUCE_FPS) ?
+			" CAN_REDUCE_FPS" : "",
+			(bt->flags & V4L2_DV_FL_REDUCED_FPS) ?
+			" REDUCED_FPS" : "",
+			(bt->flags & V4L2_DV_FL_HALF_LINE) ?
+			" HALF_LINE" : "");
+	pr_info("%s: standards (0x%x):%s%s%s%s\n", dev_prefix, bt->standards,
+			(bt->standards & V4L2_DV_BT_STD_CEA861) ?  " CEA" : "",
+			(bt->standards & V4L2_DV_BT_STD_DMT) ?  " DMT" : "",
+			(bt->standards & V4L2_DV_BT_STD_CVT) ?  " CVT" : "",
+			(bt->standards & V4L2_DV_BT_STD_GTF) ?  " GTF" : "");
+}
+EXPORT_SYMBOL_GPL(v4l2_print_dv_timings);
+
 /*
  * CVT defines
  * Based on Coordinated Video Timings Standard
diff --git a/include/media/v4l2-dv-timings.h b/include/media/v4l2-dv-timings.h
index 4c7bb54..696e5c2 100644
--- a/include/media/v4l2-dv-timings.h
+++ b/include/media/v4l2-dv-timings.h
@@ -76,6 +76,15 @@ bool v4l_match_dv_timings(const struct v4l2_dv_timings *measured,
 			  const struct v4l2_dv_timings *standard,
 			  unsigned pclock_delta);
 
+/** v4l2_print_dv_timings() - log the contents of a dv_timings struct
+  * @dev_prefix:device prefix for each log line.
+  * @prefix:	additional prefix for each log line, may be NULL.
+  * @t:		the timings data.
+  * @detailed:	if true, give a detailed log.
+  */
+void v4l2_print_dv_timings(const char *dev_prefix, const char *prefix,
+			   const struct v4l2_dv_timings *t, bool detailed);
+
 /** v4l2_detect_cvt - detect if the given timings follow the CVT standard
  * @frame_height - the total height of the frame (including blanking) in lines.
  * @hfreq - the horizontal frequency in Hz.
-- 
1.8.3.2

