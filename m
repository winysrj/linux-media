Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:35963 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758424Ab2EJKbP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 06:31:15 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M3S008ZYYK5CW40@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 May 2012 11:31:17 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M3S00DOFYJS9S@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 May 2012 11:31:05 +0100 (BST)
Date: Thu, 10 May 2012 12:30:54 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 19/23] m5mols: Add wide dynamic range control
In-reply-to: <1336645858-30366-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1336645858-30366-20-git-send-email-s.nawrocki@samsung.com>
References: <1336645858-30366-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/m5mols/m5mols.h          |    2 ++
 drivers/media/video/m5mols/m5mols_controls.c |   22 ++++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/drivers/media/video/m5mols/m5mols.h b/drivers/media/video/m5mols/m5mols.h
index 03421fc..978a4ab 100644
--- a/drivers/media/video/m5mols/m5mols.h
+++ b/drivers/media/video/m5mols/m5mols.h
@@ -169,6 +169,7 @@ struct m5mols_version {
  * @colorfx: color effect control
  * @saturation: saturation control
  * @zoom: zoom control
+ * @wdr: wide dynamic range control
  * @ver: information of the version
  * @cap: the capture mode attributes
  * @power: current sensor's power status
@@ -207,6 +208,7 @@ struct m5mols_info {
 	struct v4l2_ctrl *colorfx;
 	struct v4l2_ctrl *saturation;
 	struct v4l2_ctrl *zoom;
+	struct v4l2_ctrl *wdr;
 
 	struct m5mols_version ver;
 	struct m5mols_capture cap;
diff --git a/drivers/media/video/m5mols/m5mols_controls.c b/drivers/media/video/m5mols/m5mols_controls.c
index 7978363..512c360 100644
--- a/drivers/media/video/m5mols/m5mols_controls.c
+++ b/drivers/media/video/m5mols/m5mols_controls.c
@@ -360,6 +360,21 @@ static int m5mols_set_iso(struct m5mols_info *info, int auto_iso)
 	return m5mols_write(&info->sd, AE_ISO, iso);
 }
 
+static int m5mols_set_wdr(struct m5mols_info *info, int wdr)
+{
+	int ret;
+
+	ret = m5mols_write(&info->sd, MON_TONE_CTL, wdr ? 9 : 5);
+	if (ret < 0)
+		return ret;
+
+	ret = m5mols_set_mode(info, REG_CAPTURE);
+	if (ret < 0)
+		return ret;
+
+	return m5mols_write(&info->sd, CAPP_WDR_EN, wdr);
+}
+
 static int m5mols_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct v4l2_subdev *sd = to_sd(ctrl);
@@ -436,6 +451,10 @@ static int m5mols_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_COLORFX:
 		ret = m5mols_set_color_effect(info, ctrl->val);
 		break;
+
+	case V4L2_CID_WIDE_DYNAMIC_RANGE:
+		ret = m5mols_set_wdr(info, ctrl->val);
+		break;
 	}
 
 	if (ret == 0 && info->mode != last_mode)
@@ -513,6 +532,9 @@ int m5mols_init_controls(struct v4l2_subdev *sd)
 	info->colorfx = v4l2_ctrl_new_std_menu(&info->handle, &m5mols_ctrl_ops,
 			V4L2_CID_COLORFX, 4, 0, V4L2_COLORFX_NONE);
 
+	info->wdr = v4l2_ctrl_new_std(&info->handle, &m5mols_ctrl_ops,
+			V4L2_CID_WIDE_DYNAMIC_RANGE, 0, 1, 1, 0);
+
 	if (info->handle.error) {
 		int ret = info->handle.error;
 		v4l2_err(sd, "Failed to initialize controls: %d\n", ret);
-- 
1.7.10

