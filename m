Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54972 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758827Ab2EJKbQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 06:31:16 -0400
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M3S005EIYJLKG@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 May 2012 11:30:57 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M3S00538YJQUK@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 May 2012 11:31:03 +0100 (BST)
Date: Thu, 10 May 2012 12:30:57 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 22/23] m5mols: Add JPEG compression quality control
In-reply-to: <1336645858-30366-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1336645858-30366-23-git-send-email-s.nawrocki@samsung.com>
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
 drivers/media/video/m5mols/m5mols_controls.c |   10 ++++++++--
 drivers/media/video/m5mols/m5mols_reg.h      |    1 +
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/m5mols/m5mols.h b/drivers/media/video/m5mols/m5mols.h
index b783465..00f8d31 100644
--- a/drivers/media/video/m5mols/m5mols.h
+++ b/drivers/media/video/m5mols/m5mols.h
@@ -172,6 +172,7 @@ struct m5mols_version {
  * @zoom: zoom control
  * @wdr: wide dynamic range control
  * @stabilization: image stabilization control
+ * @jpeg_quality: JPEG compression quality control
  * @ver: information of the version
  * @cap: the capture mode attributes
  * @power: current sensor's power status
@@ -213,6 +214,7 @@ struct m5mols_info {
 	struct v4l2_ctrl *zoom;
 	struct v4l2_ctrl *wdr;
 	struct v4l2_ctrl *stabilization;
+	struct v4l2_ctrl *jpeg_quality;
 
 	struct m5mols_version ver;
 	struct m5mols_capture cap;
diff --git a/drivers/media/video/m5mols/m5mols_controls.c b/drivers/media/video/m5mols/m5mols_controls.c
index ebc3a904..1c3b1e0 100644
--- a/drivers/media/video/m5mols/m5mols_controls.c
+++ b/drivers/media/video/m5mols/m5mols_controls.c
@@ -492,6 +492,10 @@ static int m5mols_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_IMAGE_STABILIZATION:
 		ret = m5mols_set_stabilization(info, ctrl->val);
 		break;
+
+	case V4L2_CID_JPEG_COMPRESSION_QUALITY:
+		ret = m5mols_write(sd, CAPP_JPEG_RATIO, ctrl->val);
+		break;
 	}
 
 	if (ret == 0 && info->mode != last_mode)
@@ -530,8 +534,7 @@ int m5mols_init_controls(struct v4l2_subdev *sd)
 		return ret;
 
 	zoom_step = is_manufacturer(info, REG_SAMSUNG_OPTICS) ? 31 : 1;
-
-	v4l2_ctrl_handler_init(&info->handle, 6);
+	v4l2_ctrl_handler_init(&info->handle, 20);
 
 	info->auto_wb = v4l2_ctrl_new_std_menu(&info->handle,
 			&m5mols_ctrl_ops, V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE,
@@ -579,6 +582,9 @@ int m5mols_init_controls(struct v4l2_subdev *sd)
 	info->stabilization = v4l2_ctrl_new_std(&info->handle, &m5mols_ctrl_ops,
 			V4L2_CID_IMAGE_STABILIZATION, 0, 1, 1, 0);
 
+	info->jpeg_quality = v4l2_ctrl_new_std(&info->handle, &m5mols_ctrl_ops,
+			V4L2_CID_JPEG_COMPRESSION_QUALITY, 1, 100, 1, 80);
+
 	if (info->handle.error) {
 		int ret = info->handle.error;
 		v4l2_err(sd, "Failed to initialize controls: %d\n", ret);
diff --git a/drivers/media/video/m5mols/m5mols_reg.h b/drivers/media/video/m5mols/m5mols_reg.h
index ae4aced..14d4be7 100644
--- a/drivers/media/video/m5mols/m5mols_reg.h
+++ b/drivers/media/video/m5mols/m5mols_reg.h
@@ -310,6 +310,7 @@
 #define REG_JPEG		0x10
 
 #define CAPP_MAIN_IMAGE_SIZE	I2C_REG(CAT_CAPT_PARM, 0x01, 1)
+#define CAPP_JPEG_RATIO		I2C_REG(CAT_CAPT_PARM, 0x17, 1)
 
 #define CAPP_MCC_MODE		I2C_REG(CAT_CAPT_PARM, 0x1d, 1)
 #define REG_MCC_OFF		0x00
-- 
1.7.10

