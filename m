Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:30756 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030493Ab2COQy4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 12:54:56 -0400
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M0X00CG5QZ7FH@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 15 Mar 2012 16:54:43 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M0X008JFQZ4T2@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 15 Mar 2012 16:54:41 +0000 (GMT)
Date: Thu, 15 Mar 2012 17:54:31 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC 17/23] m5mols: Add wide dynamic range control
In-reply-to: <1331830477-12146-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com
Message-id: <1331830477-12146-18-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1331830477-12146-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/video/m5mols/m5mols.h          |    1 +
 drivers/media/video/m5mols/m5mols_controls.c |   18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/drivers/media/video/m5mols/m5mols.h b/drivers/media/video/m5mols/m5mols.h
index 87bf690..b2117df 100644
--- a/drivers/media/video/m5mols/m5mols.h
+++ b/drivers/media/video/m5mols/m5mols.h
@@ -208,6 +208,7 @@ struct m5mols_info {
 	struct v4l2_ctrl *colorfx;
 	struct v4l2_ctrl *saturation;
 	struct v4l2_ctrl *zoom;
+	struct v4l2_ctrl *wdr;
 
 	struct m5mols_version ver;
 	struct m5mols_capture cap;
diff --git a/drivers/media/video/m5mols/m5mols_controls.c b/drivers/media/video/m5mols/m5mols_controls.c
index cca31db..08c581e 100644
--- a/drivers/media/video/m5mols/m5mols_controls.c
+++ b/drivers/media/video/m5mols/m5mols_controls.c
@@ -348,6 +348,17 @@ static int m5mols_set_iso(struct m5mols_info *info, int auto_iso)
 	return m5mols_write(&info->sd, AE_ISO, iso);
 }
 
+static int m5mols_set_wdr(struct m5mols_info *info, int wdr)
+{
+	int ret;
+
+	ret = m5mols_write(&info->sd, MON_TONE_CTL, wdr ? 2 : 0);
+	if (ret < 0)
+		return ret;
+
+	return m5mols_write(&info->sd, CAPP_WDR_EN, wdr);
+}
+
 static int m5mols_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct v4l2_subdev *sd = to_sd(ctrl);
@@ -420,6 +431,10 @@ static int m5mols_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_COLORFX:
 		ret = m5mols_set_color_effect(info, ctrl->val);
 		break;
+
+	case V4L2_CID_WIDE_DYNAMIC_RANGE:
+		ret = m5mols_set_wdr(info, ctrl->val);
+		break;
 	}
 
 	if (ret == 0 && info->mode != last_mode)
@@ -504,6 +519,9 @@ int m5mols_init_controls(struct v4l2_subdev *sd)
 			V4L2_CID_COLORFX, 4, 0, V4L2_COLORFX_NONE);
 	m5mols_set_ctrl_mode(info->colorfx, REG_PARAMETER);
 
+	info->wdr = v4l2_ctrl_new_std(&info->handle, &m5mols_ctrl_ops,
+			V4L2_CID_WIDE_DYNAMIC_RANGE, 0, 1, 1, 0);
+
 	if (info->handle.error) {
 		int ret = info->handle.error;
 		v4l2_err(sd, "Failed to initialize controls: %d\n", ret);
-- 
1.7.9.2

