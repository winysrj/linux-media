Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-2.cisco.com ([72.163.197.26]:12077 "EHLO
	bgl-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756816AbbIVO1e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2015 10:27:34 -0400
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Prashant Laddha <prladdha@cisco.com>
Subject: [RFC v2 1/4] v4l2-dv-timings: add condition checks for reduced fps
Date: Tue, 22 Sep 2015 19:57:28 +0530
Message-Id: <1442932051-24972-2-git-send-email-prladdha@cisco.com>
In-Reply-To: <1442932051-24972-1-git-send-email-prladdha@cisco.com>
References: <1442932051-24972-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Added a helper function to check necessary conditions required for
reduced fps. The reduced fps is supported for CVT and CEA861 timings.
CVT supports reduced fps only if reduced blanking v2 (indicated by
vsync = 8) is true. Whereas CEA861 supports reduced fps if
V4L2_DV_FL_CAN_REDUCE_FPS flag is true.

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Prashant Laddha <prladdha@cisco.com>
---
 drivers/media/v4l2-core/v4l2-dv-timings.c |  5 +++++
 include/media/v4l2-dv-timings.h           | 21 +++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index 6a83d61..d8e62f6 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -210,7 +210,12 @@ bool v4l2_find_dv_timings_cap(struct v4l2_dv_timings *t,
 					  fnc, fnc_handle) &&
 		    v4l2_match_dv_timings(t, v4l2_dv_timings_presets + i,
 					  pclock_delta)) {
+			u32 flags = t->bt.flags & V4L2_DV_FL_REDUCED_FPS;
+
 			*t = v4l2_dv_timings_presets[i];
+			if (can_reduce_fps(&t->bt))
+				t->bt.flags |= flags;
+
 			return true;
 		}
 	}
diff --git a/include/media/v4l2-dv-timings.h b/include/media/v4l2-dv-timings.h
index b6130b5..49c2328 100644
--- a/include/media/v4l2-dv-timings.h
+++ b/include/media/v4l2-dv-timings.h
@@ -183,4 +183,25 @@ bool v4l2_detect_gtf(unsigned frame_height, unsigned hfreq, unsigned vsync,
  */
 struct v4l2_fract v4l2_calc_aspect_ratio(u8 hor_landscape, u8 vert_portrait);
 
+/*
+ * reduce_fps - check if conditions for reduced fps are true.
+ * bt - v4l2 timing structure
+ * For different timings reduced fps is allowed if following conditions
+ * are met -
+ * For CVT timings: if reduced blanking v2 (vsync == 8) is true.
+ * For CEA861 timings: if V4L2_DV_FL_CAN_REDUCE_FPS flag is true.
+ */
+static inline  bool can_reduce_fps(struct v4l2_bt_timings *bt)
+{
+	if ((bt->standards & V4L2_DV_BT_STD_CVT) && (bt->vsync == 8))
+		return true;
+
+	if ((bt->standards & V4L2_DV_BT_STD_CEA861) &&
+	    (bt->flags & V4L2_DV_FL_CAN_REDUCE_FPS))
+		return true;
+
+	return false;
+}
+
+
 #endif
-- 
1.9.1

