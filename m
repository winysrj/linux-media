Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:35985 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758870Ab2EJKbQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 06:31:16 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M3S008ZYYK5CW40@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 May 2012 11:31:17 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M3S00DF4YJS3I@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 May 2012 11:31:05 +0100 (BST)
Date: Thu, 10 May 2012 12:30:56 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 21/23] m5mols: Add exposure metering control
In-reply-to: <1336645858-30366-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1336645858-30366-22-git-send-email-s.nawrocki@samsung.com>
References: <1336645858-30366-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds V4L2_CID_EXPOSURE_METERING control which allows
to select the light metering mode for automatic exposure as one
of the following modes: spot (small area at the frame center),
center weighted and frame averaged.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/m5mols/m5mols.h          |    2 ++
 drivers/media/video/m5mols/m5mols_controls.c |   34 ++++++++++++++++++++++----
 2 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/m5mols/m5mols.h b/drivers/media/video/m5mols/m5mols.h
index 305a75b..b783465 100644
--- a/drivers/media/video/m5mols/m5mols.h
+++ b/drivers/media/video/m5mols/m5mols.h
@@ -163,6 +163,7 @@ struct m5mols_version {
  * @auto_exposure: auto/manual exposure control
  * @exposure_bias: exposure compensation control
  * @exposure: manual exposure control
+ * @metering: exposure metering control
  * @auto_iso: auto/manual ISO sensitivity control
  * @iso: manual ISO sensitivity control
  * @auto_wb: auto white balance control
@@ -198,6 +199,7 @@ struct m5mols_info {
 		struct v4l2_ctrl *auto_exposure;
 		struct v4l2_ctrl *exposure_bias;
 		struct v4l2_ctrl *exposure;
+		struct v4l2_ctrl *metering;
 	};
 	struct {
 		/* iso/auto iso cluster */
diff --git a/drivers/media/video/m5mols/m5mols_controls.c b/drivers/media/video/m5mols/m5mols_controls.c
index 6c607d4..ebc3a904 100644
--- a/drivers/media/video/m5mols/m5mols_controls.c
+++ b/drivers/media/video/m5mols/m5mols_controls.c
@@ -227,7 +227,25 @@ int m5mols_lock_3a(struct m5mols_info *info, bool lock)
 	return ret;
 }
 
-/* Set exposure/auto exposure cluster */
+static int m5mols_set_metering_mode(struct m5mols_info *info, int mode)
+{
+	unsigned int metering;
+
+	switch (mode) {
+	case V4L2_EXPOSURE_METERING_CENTER_WEIGHTED:
+		metering = REG_AE_CENTER;
+		break;
+	case V4L2_EXPOSURE_METERING_SPOT:
+		metering = REG_AE_SPOT;
+		break;
+	default:
+		metering = REG_AE_ALL;
+		break;
+	}
+
+	return m5mols_write(&info->sd, AE_MODE, metering);
+}
+
 static int m5mols_set_exposure(struct m5mols_info *info, int exposure)
 {
 	struct v4l2_subdev *sd = &info->sd;
@@ -238,12 +256,14 @@ static int m5mols_set_exposure(struct m5mols_info *info, int exposure)
 		return ret;
 
 	if (exposure == V4L2_EXPOSURE_AUTO) {
-		ret = m5mols_write(sd, AE_MODE, REG_AE_ALL);
+		ret = m5mols_set_metering_mode(info, info->metering->val);
 		if (ret < 0)
 			return ret;
 
-		v4l2_dbg(1, m5mols_debug, sd, "%s: exposure bias: %#x\n",
-			 __func__, info->exposure_bias->val);
+		v4l2_dbg(1, m5mols_debug, sd,
+			 "%s: exposure bias: %#x, metering: %#x\n",
+			 __func__, info->exposure_bias->val,
+			 info->metering->val);
 
 		return m5mols_write(sd, AE_INDEX, info->exposure_bias->val);
 	}
@@ -532,6 +552,10 @@ int m5mols_init_controls(struct v4l2_subdev *sd)
 			ARRAY_SIZE(ev_bias_qmenu)/2 - 1,
 			ev_bias_qmenu);
 
+	info->metering = v4l2_ctrl_new_std_menu(&info->handle,
+			&m5mols_ctrl_ops, V4L2_CID_EXPOSURE_METERING,
+			2, ~0x7, V4L2_EXPOSURE_METERING_AVERAGE);
+
 	/* ISO control cluster */
 	info->auto_iso = v4l2_ctrl_new_std_menu(&info->handle, &m5mols_ctrl_ops,
 			V4L2_CID_ISO_SENSITIVITY_AUTO, 1, ~0x03, 1);
@@ -562,7 +586,7 @@ int m5mols_init_controls(struct v4l2_subdev *sd)
 		return ret;
 	}
 
-	v4l2_ctrl_auto_cluster(3, &info->auto_exposure, 1, false);
+	v4l2_ctrl_auto_cluster(4, &info->auto_exposure, 1, false);
 	info->auto_iso->flags |= V4L2_CTRL_FLAG_VOLATILE |
 				V4L2_CTRL_FLAG_UPDATE;
 	v4l2_ctrl_auto_cluster(2, &info->auto_iso, 0, false);
-- 
1.7.10

