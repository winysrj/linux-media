Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:44946 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab2HJLVe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Aug 2012 07:21:34 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: marbugge@cisco.com, Soby Mathew <soby.mathew@st.com>,
	mats.randgaard@cisco.com, manjunath.hadli@ti.com,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	dri-devel@lists.freedesktop.org
Subject: [RFCv3 PATCH 5/8] v4l2-common: add v4l_match_dv_timings.
Date: Fri, 10 Aug 2012 13:21:21 +0200
Message-Id: <2e7ff1685d7f232a97f551be4ab897b21e252c1e.1344592468.git.hans.verkuil@cisco.com>
In-Reply-To: <1344597684-8413-1-git-send-email-hans.verkuil@cisco.com>
References: <1344597684-8413-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <bf682233fde61ca77ed4512ba77271f6daeedb31.1344592468.git.hans.verkuil@cisco.com>
References: <bf682233fde61ca77ed4512ba77271f6daeedb31.1344592468.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the v4l_match_dv_timings function that can be used to compare two
v4l2_dv_timings structs.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-common.c |   33 +++++++++++++++++++++++++++++++++
 include/media/v4l2-common.h       |    4 ++++
 2 files changed, 37 insertions(+)

diff --git a/drivers/media/video/v4l2-common.c b/drivers/media/video/v4l2-common.c
index 1baec83..38da47c 100644
--- a/drivers/media/video/v4l2-common.c
+++ b/drivers/media/video/v4l2-common.c
@@ -597,6 +597,39 @@ int v4l_fill_dv_preset_info(u32 preset, struct v4l2_dv_enum_preset *info)
 }
 EXPORT_SYMBOL_GPL(v4l_fill_dv_preset_info);
 
+/**
+ * v4l_match_dv_timings - check if two timings match
+ * @t1 - compare this v4l2_dv_timings struct...
+ * @t2 - with this struct.
+ * @pclock_delta - the allowed pixelclock deviation.
+ *
+ * Compare t1 with t2 with a given margin of error for the pixelclock.
+ */
+bool v4l_match_dv_timings(const struct v4l2_dv_timings *t1,
+			  const struct v4l2_dv_timings *t2,
+			  unsigned pclock_delta)
+{
+	if (t1->type != t2->type || t1->type != V4L2_DV_BT_656_1120)
+		return false;
+	if (t1->bt.width == t2->bt.width &&
+	    t1->bt.height == t2->bt.height &&
+	    t1->bt.interlaced == t2->bt.interlaced &&
+	    t1->bt.polarities == t2->bt.polarities &&
+	    t1->bt.pixelclock >= t2->bt.pixelclock - pclock_delta &&
+	    t1->bt.pixelclock <= t2->bt.pixelclock + pclock_delta &&
+	    t1->bt.hfrontporch == t2->bt.hfrontporch &&
+	    t1->bt.vfrontporch == t2->bt.vfrontporch &&
+	    t1->bt.vsync == t2->bt.vsync &&
+	    t1->bt.vbackporch == t2->bt.vbackporch &&
+	    (!t1->bt.interlaced ||
+		(t1->bt.il_vfrontporch == t2->bt.il_vfrontporch &&
+		 t1->bt.il_vsync == t2->bt.il_vsync &&
+		 t1->bt.il_vbackporch == t2->bt.il_vbackporch)))
+		return true;
+	return false;
+}
+EXPORT_SYMBOL_GPL(v4l_match_dv_timings);
+
 const struct v4l2_frmsize_discrete *v4l2_find_nearest_format(
 		const struct v4l2_discrete_probe *probe,
 		s32 width, s32 height)
diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index a298ec4..b43b968 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -212,4 +212,8 @@ const struct v4l2_frmsize_discrete *v4l2_find_nearest_format(
 		const struct v4l2_discrete_probe *probe,
 		s32 width, s32 height);
 
+bool v4l_match_dv_timings(const struct v4l2_dv_timings *t1,
+			  const struct v4l2_dv_timings *t2,
+			  unsigned pclock_delta);
+
 #endif /* V4L2_COMMON_H_ */
-- 
1.7.10.4

