Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54972 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758842Ab2EJKbO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 06:31:14 -0400
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M3S005EIYJLKG@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 May 2012 11:30:57 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M3S00DF7YJQCT@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 May 2012 11:31:03 +0100 (BST)
Date: Thu, 10 May 2012 12:30:52 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 17/23] m5mols: Add auto and preset white balance control
In-reply-to: <1336645858-30366-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1336645858-30366-18-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1336645858-30366-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/m5mols/m5mols.h          |    4 +--
 drivers/media/video/m5mols/m5mols_controls.c |   47 ++++++++++++++++++++------
 2 files changed, 39 insertions(+), 12 deletions(-)

diff --git a/drivers/media/video/m5mols/m5mols.h b/drivers/media/video/m5mols/m5mols.h
index 598bb0f..fa1f2c1 100644
--- a/drivers/media/video/m5mols/m5mols.h
+++ b/drivers/media/video/m5mols/m5mols.h
@@ -164,7 +164,7 @@ struct m5mols_version {
  * @exposure: manual exposure control
  * @auto_iso: auto/manual ISO sensitivity control
  * @iso: manual ISO sensitivity control
- * @autowb: Auto White Balance control
+ * @auto_wb: auto white balance control
  * @colorfx: color effect control
  * @saturation: saturation control
  * @zoom: zoom control
@@ -200,8 +200,8 @@ struct m5mols_info {
 		struct v4l2_ctrl *auto_iso;
 		struct v4l2_ctrl *iso;
 	};
-
 	struct v4l2_ctrl *auto_wb;
+
 	struct v4l2_ctrl *colorfx;
 	struct v4l2_ctrl *saturation;
 	struct v4l2_ctrl *zoom;
diff --git a/drivers/media/video/m5mols/m5mols_controls.c b/drivers/media/video/m5mols/m5mols_controls.c
index f1c8850..1ab21f0 100644
--- a/drivers/media/video/m5mols/m5mols_controls.c
+++ b/drivers/media/video/m5mols/m5mols_controls.c
@@ -256,16 +256,42 @@ static int m5mols_set_exposure(struct m5mols_info *info, int exposure)
 	return ret;
 }
 
-static int m5mols_set_white_balance(struct m5mols_info *info, int awb)
+static int m5mols_set_white_balance(struct m5mols_info *info, int val)
 {
-	int ret;
+	static const unsigned short wb[][2] = {
+		{ V4L2_WHITE_BALANCE_INCANDESCENT,  REG_AWB_INCANDESCENT },
+		{ V4L2_WHITE_BALANCE_FLUORESCENT,   REG_AWB_FLUORESCENT_1 },
+		{ V4L2_WHITE_BALANCE_FLUORESCENT_H, REG_AWB_FLUORESCENT_2 },
+		{ V4L2_WHITE_BALANCE_HORIZON,       REG_AWB_HORIZON },
+		{ V4L2_WHITE_BALANCE_DAYLIGHT,      REG_AWB_DAYLIGHT },
+		{ V4L2_WHITE_BALANCE_FLASH,         REG_AWB_LEDLIGHT },
+		{ V4L2_WHITE_BALANCE_CLOUDY,        REG_AWB_CLOUDY },
+		{ V4L2_WHITE_BALANCE_SHADE,         REG_AWB_SHADE },
+		{ V4L2_WHITE_BALANCE_AUTO,          REG_AWB_AUTO },
+	};
+	int i;
+	struct v4l2_subdev *sd = &info->sd;
+	int ret = -EINVAL;
 
-	ret = m5mols_lock_awb(info, !awb);
-	if (ret < 0)
-		return ret;
+	for (i = 0; i < ARRAY_SIZE(wb); i++) {
+		int awb;
+		if (wb[i][0] != val)
+			continue;
+
+		v4l2_dbg(1, m5mols_debug, sd,
+			 "Setting white balance to: %#x\n", wb[i][0]);
 
-	return m5mols_write(&info->sd, AWB_MODE, awb ? REG_AWB_AUTO :
-			    REG_AWB_PRESET);
+		awb = wb[i][0] == V4L2_WHITE_BALANCE_AUTO;
+		ret = m5mols_write(sd, AWB_MODE, awb ? REG_AWB_AUTO :
+						 REG_AWB_PRESET);
+		if (ret < 0)
+			return ret;
+
+		if (!awb)
+			ret = m5mols_write(sd, AWB_MANUAL, wb[i][1]);
+	}
+
+	return ret;
 }
 
 static int m5mols_set_saturation(struct m5mols_info *info, int val)
@@ -391,7 +417,7 @@ static int m5mols_s_ctrl(struct v4l2_ctrl *ctrl)
 		ret = m5mols_set_iso(info, ctrl->val);
 		break;
 
-	case V4L2_CID_AUTO_WHITE_BALANCE:
+	case V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE:
 		ret = m5mols_set_white_balance(info, ctrl->val);
 		break;
 
@@ -437,8 +463,9 @@ int m5mols_init_controls(struct v4l2_subdev *sd)
 
 	v4l2_ctrl_handler_init(&info->handle, 6);
 
-	info->auto_wb = v4l2_ctrl_new_std(&info->handle, &m5mols_ctrl_ops,
-			V4L2_CID_AUTO_WHITE_BALANCE, 0, 1, 1, 1);
+	info->auto_wb = v4l2_ctrl_new_std_menu(&info->handle,
+			&m5mols_ctrl_ops, V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE,
+			9, ~0x3fe, V4L2_WHITE_BALANCE_AUTO);
 
 	info->auto_exposure = v4l2_ctrl_new_std_menu(&info->handle,
 			&m5mols_ctrl_ops, V4L2_CID_EXPOSURE_AUTO,
-- 
1.7.10

