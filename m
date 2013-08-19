Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1149 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab3HSOou (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Aug 2013 10:44:50 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: marbugge@cisco.com, matrandg@cisco.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 15/20] v4l2-dv-timings: export the timings list.
Date: Mon, 19 Aug 2013 16:44:24 +0200
Message-Id: <1376923469-30694-16-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1376923469-30694-1-git-send-email-hverkuil@xs4all.nl>
References: <1376923469-30694-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Some drivers need to be able to access the full list of timings.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-dv-timings.c | 18 ++++++++++--------
 include/media/v4l2-dv-timings.h           |  4 ++++
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index c2f5af7..f515997 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -26,7 +26,7 @@
 #include <linux/v4l2-dv-timings.h>
 #include <media/v4l2-dv-timings.h>
 
-static const struct v4l2_dv_timings timings[] = {
+const struct v4l2_dv_timings v4l2_dv_timings_presets[] = {
 	V4L2_DV_BT_CEA_640X480P59_94,
 	V4L2_DV_BT_CEA_720X480I59_94,
 	V4L2_DV_BT_CEA_720X480P59_94,
@@ -127,7 +127,9 @@ static const struct v4l2_dv_timings timings[] = {
 	V4L2_DV_BT_DMT_2560X1600P75,
 	V4L2_DV_BT_DMT_2560X1600P85,
 	V4L2_DV_BT_DMT_2560X1600P120_RB,
+	{ }
 };
+EXPORT_SYMBOL_GPL(v4l2_dv_timings_presets);
 
 bool v4l2_dv_valid_timings(const struct v4l2_dv_timings *t,
 			   const struct v4l2_dv_timings_cap *dvcap)
@@ -159,10 +161,10 @@ int v4l2_enum_dv_timings_cap(struct v4l2_enum_dv_timings *t,
 	u32 i, idx;
 
 	memset(t->reserved, 0, sizeof(t->reserved));
-	for (i = idx = 0; i < ARRAY_SIZE(timings); i++) {
-		if (v4l2_dv_valid_timings(timings + i, cap) &&
+	for (i = idx = 0; v4l2_dv_timings_presets[i].bt.width; i++) {
+		if (v4l2_dv_valid_timings(v4l2_dv_timings_presets + i, cap) &&
 		    idx++ == t->index) {
-			t->timings = timings[i];
+			t->timings = v4l2_dv_timings_presets[i];
 			return 0;
 		}
 	}
@@ -179,10 +181,10 @@ bool v4l2_find_dv_timings_cap(struct v4l2_dv_timings *t,
 	if (!v4l2_dv_valid_timings(t, cap))
 		return false;
 
-	for (i = 0; i < ARRAY_SIZE(timings); i++) {
-		if (v4l2_dv_valid_timings(timings + i, cap) &&
-		    v4l2_match_dv_timings(t, timings + i, pclock_delta)) {
-			*t = timings[i];
+	for (i = 0; i < v4l2_dv_timings_presets[i].bt.width; i++) {
+		if (v4l2_dv_valid_timings(v4l2_dv_timings_presets + i, cap) &&
+		    v4l2_match_dv_timings(t, v4l2_dv_timings_presets + i, pclock_delta)) {
+			*t = v4l2_dv_timings_presets[i];
 			return true;
 		}
 	}
diff --git a/include/media/v4l2-dv-timings.h b/include/media/v4l2-dv-timings.h
index 43f6b67..0fe310b 100644
--- a/include/media/v4l2-dv-timings.h
+++ b/include/media/v4l2-dv-timings.h
@@ -23,6 +23,10 @@
 
 #include <linux/videodev2.h>
 
+/** v4l2_dv_timings_presets: list of all dv_timings presets.
+ */
+extern const struct v4l2_dv_timings v4l2_dv_timings_presets[];
+
 /** v4l2_dv_valid_timings() - are these timings valid?
   * @t:	  the v4l2_dv_timings struct.
   * @cap: the v4l2_dv_timings_cap capabilities.
-- 
1.8.3.2

