Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:33702 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031969Ab2COQyw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 12:54:52 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M0X0060ZQZ61K10@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 15 Mar 2012 16:54:42 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M0X004Q0QZ45P@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 15 Mar 2012 16:54:42 +0000 (GMT)
Date: Thu, 15 Mar 2012 17:54:35 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC 21/23] m5mols: Add JPEG compression quality control
In-reply-to: <1331830477-12146-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com
Message-id: <1331830477-12146-22-git-send-email-s.nawrocki@samsung.com>
References: <1331830477-12146-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/m5mols/m5mols.h          |    1 +
 drivers/media/video/m5mols/m5mols_controls.c |   10 ++++++++--
 drivers/media/video/m5mols/m5mols_reg.h      |    1 +
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/m5mols/m5mols.h b/drivers/media/video/m5mols/m5mols.h
index d95ccb8..319db1e 100644
--- a/drivers/media/video/m5mols/m5mols.h
+++ b/drivers/media/video/m5mols/m5mols.h
@@ -227,6 +227,7 @@ struct m5mols_info {
 	struct v4l2_ctrl *zoom;
 	struct v4l2_ctrl *wdr;
 	struct v4l2_ctrl *stabilization;
+	struct v4l2_ctrl *jpeg_quality;
 
 	struct m5mols_version ver;
 	struct m5mols_capture cap;
diff --git a/drivers/media/video/m5mols/m5mols_controls.c b/drivers/media/video/m5mols/m5mols_controls.c
index b7b46eb..7e2ea62 100644
--- a/drivers/media/video/m5mols/m5mols_controls.c
+++ b/drivers/media/video/m5mols/m5mols_controls.c
@@ -577,6 +577,10 @@ static int m5mols_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_IMAGE_STABILIZATION:
 		ret = m5mols_set_stabilization(info, ctrl->val);
 		break;
+
+	case V4L2_CID_JPEG_COMPRESSION_QUALITY:
+		ret = m5mols_write(sd, CAPP_JPEG_RATIO, ctrl->val);
+		break;
 	}
 
 	if (ret == 0 && info->mode != last_mode)
@@ -615,8 +619,7 @@ int m5mols_init_controls(struct v4l2_subdev *sd)
 		return ret;
 
 	zoom_step = is_manufacturer(info, REG_SAMSUNG_OPTICS) ? 31 : 1;
-
-	v4l2_ctrl_handler_init(&info->handle, 6);
+	v4l2_ctrl_handler_init(&info->handle, 20);
 
 	/* White balance control cluster */
 	info->auto_wb = v4l2_ctrl_new_std(&info->handle, &m5mols_ctrl_ops,
@@ -693,6 +696,9 @@ int m5mols_init_controls(struct v4l2_subdev *sd)
 	info->stabilization = v4l2_ctrl_new_std(&info->handle, &m5mols_ctrl_ops,
 			V4L2_CID_IMAGE_STABILIZATION, 0, 1, 1, 0);
 
+	info->jpeg_quality = v4l2_ctrl_new_std(&info->handle, &m5mols_ctrl_ops,
+			V4L2_CID_JPEG_COMPRESSION_QUALITY, 1, 100, 1, 80);
+
 	if (info->handle.error) {
 		int ret = info->handle.error;
 		v4l2_err(sd, "Failed to initialize controls: %d\n", ret);
diff --git a/drivers/media/video/m5mols/m5mols_reg.h b/drivers/media/video/m5mols/m5mols_reg.h
index f058c62..6123658 100644
--- a/drivers/media/video/m5mols/m5mols_reg.h
+++ b/drivers/media/video/m5mols/m5mols_reg.h
@@ -315,6 +315,7 @@
 #define REG_JPEG		0x10
 
 #define CAPP_MAIN_IMAGE_SIZE	I2C_REG(CAT_CAPT_PARM, 0x01, 1)
+#define CAPP_JPEG_RATIO		I2C_REG(CAT_CAPT_PARM, 0x17, 1)
 
 #define CAPP_MCC_MODE		I2C_REG(CAT_CAPT_PARM, 0x1d, 1)
 #define REG_MCC_OFF		0x00
-- 
1.7.9.2

