Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:33702 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031963Ab2COQyu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 12:54:50 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M0X0060GQZ5HR10@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 15 Mar 2012 16:54:41 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M0X0018TQZ4UK@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 15 Mar 2012 16:54:41 +0000 (GMT)
Date: Thu, 15 Mar 2012 17:54:29 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC 15/23] m5mols: Add white balance preset control
In-reply-to: <1331830477-12146-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com
Message-id: <1331830477-12146-16-git-send-email-s.nawrocki@samsung.com>
References: <1331830477-12146-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/m5mols/m5mols.h          |    6 +++++-
 drivers/media/video/m5mols/m5mols_controls.c |   25 +++++++++++++++++++++++--
 2 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/m5mols/m5mols.h b/drivers/media/video/m5mols/m5mols.h
index 475a7be..d04443b 100644
--- a/drivers/media/video/m5mols/m5mols.h
+++ b/drivers/media/video/m5mols/m5mols.h
@@ -198,8 +198,12 @@ struct m5mols_info {
 		struct v4l2_ctrl *auto_iso;
 		struct v4l2_ctrl *iso;
 	};
+	struct {
+		/* white bal. preset/auto white bal. cluster */
+		struct v4l2_ctrl *auto_wb;
+		struct v4l2_ctrl *wb_preset;
+	};
 
-	struct v4l2_ctrl *autowb;
 	struct v4l2_ctrl *colorfx;
 	struct v4l2_ctrl *saturation;
 	struct v4l2_ctrl *zoom;
diff --git a/drivers/media/video/m5mols/m5mols_controls.c b/drivers/media/video/m5mols/m5mols_controls.c
index f335f9c..98eaeb0 100644
--- a/drivers/media/video/m5mols/m5mols_controls.c
+++ b/drivers/media/video/m5mols/m5mols_controls.c
@@ -258,14 +258,28 @@ static int m5mols_set_exposure(struct m5mols_info *info, int exposure)
 
 static int m5mols_set_white_balance(struct m5mols_info *info, int awb)
 {
+	static const u8 wb_rval[] = {
+		REG_AWB_INCANDESCENT,
+		REG_AWB_FLUORESCENT_1,
+		REG_AWB_DAYLIGHT,
+		REG_AWB_CLOUDY,
+		REG_AWB_SHADE,
+	};
+	struct v4l2_subdev *sd = &info->sd;
 	int ret;
 
 	ret = m5mols_lock_awb(info, !awb);
 	if (ret < 0)
 		return ret;
 
-	return m5mols_write(&info->sd, AWB_MODE, awb ? REG_AWB_AUTO :
-			    REG_AWB_PRESET);
+	ret = m5mols_write(sd, AWB_MODE, awb ? REG_AWB_AUTO :
+			   REG_AWB_PRESET);
+	if (ret < 0)
+		return ret;
+	if (!awb)
+		ret = m5mols_write(sd, AWB_MANUAL,
+				   wb_rval[info->wb_preset->val - 1]);
+	return ret;
 }
 
 static int m5mols_set_saturation(struct m5mols_info *info, int val)
@@ -433,10 +447,15 @@ int m5mols_init_controls(struct v4l2_subdev *sd)
 
 	v4l2_ctrl_handler_init(&info->handle, 6);
 
+	/* White balance control cluster */
 	info->auto_wb = v4l2_ctrl_new_std(&info->handle, &m5mols_ctrl_ops,
 			V4L2_CID_AUTO_WHITE_BALANCE, 0, 1, 1, 1);
 	m5mols_set_ctrl_mode(info->auto_wb, REG_PARAMETER);
 
+	info->wb_preset = v4l2_ctrl_new_std_menu(&info->handle,
+			&m5mols_ctrl_ops, V4L2_CID_WHITE_BALANCE_PRESET,
+			5, ~0x3e, V4L2_WHITE_BALANCE_PRESET_DAYLIGHT);
+
 	info->auto_exposure = v4l2_ctrl_new_std_menu(&info->handle,
 			&m5mols_ctrl_ops, V4L2_CID_EXPOSURE_AUTO,
 			1, ~0x03, V4L2_EXPOSURE_AUTO);
@@ -475,6 +494,8 @@ int m5mols_init_controls(struct v4l2_subdev *sd)
 	info->auto_iso->flags |= V4L2_CTRL_FLAG_VOLATILE |
 				V4L2_CTRL_FLAG_UPDATE;
 	v4l2_ctrl_auto_cluster(2, &info->auto_iso, 0, false);
+
+	v4l2_ctrl_auto_cluster(2, &info->auto_wb, 0, false);
 	sd->ctrl_handler = &info->handle;
 
 	return 0;
-- 
1.7.9.2

