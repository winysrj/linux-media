Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54972 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab2EJKbQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 06:31:16 -0400
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M3S005EIYJLKG@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 May 2012 11:30:57 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M3S00537YJQUK@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 May 2012 11:31:03 +0100 (BST)
Date: Thu, 10 May 2012 12:30:55 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 20/23] m5mols: Add image stabilization control
In-reply-to: <1336645858-30366-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1336645858-30366-21-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1336645858-30366-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/m5mols/m5mols.h          |    2 ++
 drivers/media/video/m5mols/m5mols_controls.c |   20 ++++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/drivers/media/video/m5mols/m5mols.h b/drivers/media/video/m5mols/m5mols.h
index 978a4ab..305a75b 100644
--- a/drivers/media/video/m5mols/m5mols.h
+++ b/drivers/media/video/m5mols/m5mols.h
@@ -170,6 +170,7 @@ struct m5mols_version {
  * @saturation: saturation control
  * @zoom: zoom control
  * @wdr: wide dynamic range control
+ * @stabilization: image stabilization control
  * @ver: information of the version
  * @cap: the capture mode attributes
  * @power: current sensor's power status
@@ -209,6 +210,7 @@ struct m5mols_info {
 	struct v4l2_ctrl *saturation;
 	struct v4l2_ctrl *zoom;
 	struct v4l2_ctrl *wdr;
+	struct v4l2_ctrl *stabilization;
 
 	struct m5mols_version ver;
 	struct m5mols_capture cap;
diff --git a/drivers/media/video/m5mols/m5mols_controls.c b/drivers/media/video/m5mols/m5mols_controls.c
index 512c360..6c607d4 100644
--- a/drivers/media/video/m5mols/m5mols_controls.c
+++ b/drivers/media/video/m5mols/m5mols_controls.c
@@ -375,6 +375,19 @@ static int m5mols_set_wdr(struct m5mols_info *info, int wdr)
 	return m5mols_write(&info->sd, CAPP_WDR_EN, wdr);
 }
 
+static int m5mols_set_stabilization(struct m5mols_info *info, int val)
+{
+	struct v4l2_subdev *sd = &info->sd;
+	unsigned int evp = val ? 0xe : 0x0;
+	int ret;
+
+	ret = m5mols_write(sd, AE_EV_PRESET_MONITOR, evp);
+	if (ret < 0)
+		return ret;
+
+	return m5mols_write(sd, AE_EV_PRESET_CAPTURE, evp);
+}
+
 static int m5mols_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct v4l2_subdev *sd = to_sd(ctrl);
@@ -455,6 +468,10 @@ static int m5mols_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_WIDE_DYNAMIC_RANGE:
 		ret = m5mols_set_wdr(info, ctrl->val);
 		break;
+
+	case V4L2_CID_IMAGE_STABILIZATION:
+		ret = m5mols_set_stabilization(info, ctrl->val);
+		break;
 	}
 
 	if (ret == 0 && info->mode != last_mode)
@@ -535,6 +552,9 @@ int m5mols_init_controls(struct v4l2_subdev *sd)
 	info->wdr = v4l2_ctrl_new_std(&info->handle, &m5mols_ctrl_ops,
 			V4L2_CID_WIDE_DYNAMIC_RANGE, 0, 1, 1, 0);
 
+	info->stabilization = v4l2_ctrl_new_std(&info->handle, &m5mols_ctrl_ops,
+			V4L2_CID_IMAGE_STABILIZATION, 0, 1, 1, 0);
+
 	if (info->handle.error) {
 		int ret = info->handle.error;
 		v4l2_err(sd, "Failed to initialize controls: %d\n", ret);
-- 
1.7.10

