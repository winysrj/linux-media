Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:64585 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031968Ab2COQyw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 12:54:52 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M0X007YTQZ8PJ00@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 15 Mar 2012 16:54:44 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M0X002OOQZ4O0@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 15 Mar 2012 16:54:41 +0000 (GMT)
Date: Thu, 15 Mar 2012 17:54:32 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC 18/23] m5mols: Add image stabilization control
In-reply-to: <1331830477-12146-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com
Message-id: <1331830477-12146-19-git-send-email-s.nawrocki@samsung.com>
References: <1331830477-12146-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/video/m5mols/m5mols.h          |    1 +
 drivers/media/video/m5mols/m5mols_controls.c |   16 ++++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/drivers/media/video/m5mols/m5mols.h b/drivers/media/video/m5mols/m5mols.h
index b2117df..213b15b 100644
--- a/drivers/media/video/m5mols/m5mols.h
+++ b/drivers/media/video/m5mols/m5mols.h
@@ -209,6 +209,7 @@ struct m5mols_info {
 	struct v4l2_ctrl *saturation;
 	struct v4l2_ctrl *zoom;
 	struct v4l2_ctrl *wdr;
+	struct v4l2_ctrl *stabilization;
 
 	struct m5mols_version ver;
 	struct m5mols_capture cap;
diff --git a/drivers/media/video/m5mols/m5mols_controls.c b/drivers/media/video/m5mols/m5mols_controls.c
index 08c581e..2c7beef 100644
--- a/drivers/media/video/m5mols/m5mols_controls.c
+++ b/drivers/media/video/m5mols/m5mols_controls.c
@@ -12,6 +12,7 @@
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
  */
+#define pr_fmt(fmt) "%s:%d "fmt, __func__, __LINE__
 
 #include <linux/i2c.h>
 #include <linux/delay.h>
@@ -359,6 +360,14 @@ static int m5mols_set_wdr(struct m5mols_info *info, int wdr)
 	return m5mols_write(&info->sd, CAPP_WDR_EN, wdr);
 }
 
+static int m5mols_set_stabilization(struct m5mols_info *info, int val)
+{
+	struct v4l2_subdev *sd = &info->sd;
+
+	v4l2_dbg(1, m5mols_debug, sd, "image stabilization: %d\n", val);
+	return 0;
+}
+
 static int m5mols_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct v4l2_subdev *sd = to_sd(ctrl);
@@ -435,6 +444,10 @@ static int m5mols_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_WIDE_DYNAMIC_RANGE:
 		ret = m5mols_set_wdr(info, ctrl->val);
 		break;
+
+	case V4L2_CID_IMAGE_STABILIZATION:
+		ret = m5mols_set_stabilization(info, ctrl->val);
+		break;
 	}
 
 	if (ret == 0 && info->mode != last_mode)
@@ -522,6 +535,9 @@ int m5mols_init_controls(struct v4l2_subdev *sd)
 	info->wdr = v4l2_ctrl_new_std(&info->handle, &m5mols_ctrl_ops,
 			V4L2_CID_WIDE_DYNAMIC_RANGE, 0, 1, 1, 0);
 
+	info->stabilization = v4l2_ctrl_new_std(&info->handle, &m5mols_ctrl_ops,
+			V4L2_CID_IMAGE_STABILIZATION, 0, 1, 1, 0);
+
 	if (info->handle.error) {
 		int ret = info->handle.error;
 		v4l2_err(sd, "Failed to initialize controls: %d\n", ret);
-- 
1.7.9.2

