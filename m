Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:33702 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031971Ab2COQyx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 12:54:53 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M0X0060ZQZ61K10@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 15 Mar 2012 16:54:42 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M0X008JGQZ4T2@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 15 Mar 2012 16:54:42 +0000 (GMT)
Date: Thu, 15 Mar 2012 17:54:34 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC 20/23] m5mols: Add exposure metering control
In-reply-to: <1331830477-12146-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com
Message-id: <1331830477-12146-21-git-send-email-s.nawrocki@samsung.com>
References: <1331830477-12146-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds V4L2_CID_EXPOSURE_METERING control which allows
to select the light metering mode for automatic exposure as one
of the following modes: spot (small area at the frame center),
center weighted and frame averaged.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/m5mols/m5mols.h          |    1 +
 drivers/media/video/m5mols/m5mols_controls.c |   27 ++++++++++++++++++++++----
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/m5mols/m5mols.h b/drivers/media/video/m5mols/m5mols.h
index cd70b71..d95ccb8 100644
--- a/drivers/media/video/m5mols/m5mols.h
+++ b/drivers/media/video/m5mols/m5mols.h
@@ -199,6 +199,7 @@ struct m5mols_info {
 		struct v4l2_ctrl *auto_exposure;
 		struct v4l2_ctrl *exposure_bias;
 		struct v4l2_ctrl *exposure;
+		struct v4l2_ctrl *exposure_metering;
 	};
 	struct {
 		/* iso/auto iso cluster */
diff --git a/drivers/media/video/m5mols/m5mols_controls.c b/drivers/media/video/m5mols/m5mols_controls.c
index 9ee089f..b7b46eb 100644
--- a/drivers/media/video/m5mols/m5mols_controls.c
+++ b/drivers/media/video/m5mols/m5mols_controls.c
@@ -240,12 +240,27 @@ static int m5mols_set_exposure(struct m5mols_info *info, int exposure)
 		return ret;
 
 	if (exposure == V4L2_EXPOSURE_AUTO) {
-		ret = m5mols_write(sd, AE_MODE, REG_AE_ALL);
+		unsigned int metering;
+
+		switch (info->exposure_metering->val) {
+		case V4L2_EXPOSURE_METERING_CENTER_WEIGHTED:
+			metering = REG_AE_CENTER;
+			break;
+		case V4L2_EXPOSURE_METERING_SPOT:
+			metering = REG_AE_SPOT;
+			break;
+		default:
+			metering = REG_AE_ALL;
+			break;
+		}
+
+		ret = m5mols_write(sd, AE_MODE, metering);
 		if (ret < 0)
 			return ret;
 
-		v4l2_dbg(1, m5mols_debug, sd, "%s: exposure bias: %#x\n",
-			 __func__, info->exposure_bias->val);
+		v4l2_dbg(1, m5mols_debug, sd,
+			 "%s: exposure bias: %#x, metering: %#x\n",
+			 __func__, info->exposure_bias->val, metering);
 
 		return m5mols_write(sd, AE_INDEX, info->exposure_bias->val);
 	}
@@ -628,6 +643,10 @@ int m5mols_init_controls(struct v4l2_subdev *sd)
 			ARRAY_SIZE(ev_bias_qmenu)/2 - 1,
 			ev_bias_qmenu);
 
+	info->exposure_metering = v4l2_ctrl_new_std_menu(&info->handle,
+			&m5mols_ctrl_ops, V4L2_CID_EXPOSURE_METERING,
+			2, ~0x7, V4L2_EXPOSURE_METERING_AVERAGE);
+
 	/* ISO control cluster */
 	info->auto_iso = v4l2_ctrl_new_std(&info->handle, &m5mols_ctrl_ops,
 			V4L2_CID_ISO_SENSITIVITY_AUTO, 0, 1, 1, 1);
@@ -681,7 +700,7 @@ int m5mols_init_controls(struct v4l2_subdev *sd)
 		return ret;
 	}
 
-	v4l2_ctrl_auto_cluster(3, &info->auto_exposure, 1, false);
+	v4l2_ctrl_auto_cluster(4, &info->auto_exposure, 1, false);
 	info->auto_iso->flags |= V4L2_CTRL_FLAG_VOLATILE |
 				V4L2_CTRL_FLAG_UPDATE;
 	v4l2_ctrl_auto_cluster(2, &info->auto_iso, 0, false);
-- 
1.7.9.2

