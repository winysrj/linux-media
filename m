Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:59196 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715Ab0CROoP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Mar 2010 10:44:15 -0400
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: davinci-linux-open-source@linux.davincidsp.com,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH] V4L - vpfe capture - fix for kernel crash
Date: Thu, 18 Mar 2010 10:44:12 -0400
Message-Id: <1268923452-16329-1-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <m-karicheri2@ti.com>

As part of upstream merge, set_params() function was removed from isif.c.
This requires removal of BUG_ON() and check for set_params ptr in
vpfe_capture.c. Without this kernel crash dump is seen while bootup on DM365

Also made following changes:-

 1) converted error messages to debug messages since it is not right to flood
    the console with error messages for user mistakes.
 2) returns -EINVAL if ioctl is not supported

Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
---
 drivers/media/video/davinci/vpfe_capture.c |   33 +++++++++++++++++-----------
 1 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/media/video/davinci/vpfe_capture.c b/drivers/media/video/davinci/vpfe_capture.c
index 91f665b..1d46210 100644
--- a/drivers/media/video/davinci/vpfe_capture.c
+++ b/drivers/media/video/davinci/vpfe_capture.c
@@ -222,7 +222,6 @@ int vpfe_register_ccdc_device(struct ccdc_hw_device *dev)
 	BUG_ON(!dev->hw_ops.get_frame_format);
 	BUG_ON(!dev->hw_ops.get_pixel_format);
 	BUG_ON(!dev->hw_ops.set_pixel_format);
-	BUG_ON(!dev->hw_ops.set_params);
 	BUG_ON(!dev->hw_ops.set_image_window);
 	BUG_ON(!dev->hw_ops.get_image_window);
 	BUG_ON(!dev->hw_ops.get_line_length);
@@ -1688,11 +1687,12 @@ static long vpfe_param_handler(struct file *file, void *priv,
 	struct vpfe_device *vpfe_dev = video_drvdata(file);
 	int ret = 0;
 
-	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_param_handler\n");
+	v4l2_dbg(2, debug, &vpfe_dev->v4l2_dev, "vpfe_param_handler\n");
 
 	if (vpfe_dev->started) {
 		/* only allowed if streaming is not started */
-		v4l2_err(&vpfe_dev->v4l2_dev, "device already started\n");
+		v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev,
+			"device already started\n");
 		return -EBUSY;
 	}
 
@@ -1704,16 +1704,23 @@ static long vpfe_param_handler(struct file *file, void *priv,
 	case VPFE_CMD_S_CCDC_RAW_PARAMS:
 		v4l2_warn(&vpfe_dev->v4l2_dev,
 			  "VPFE_CMD_S_CCDC_RAW_PARAMS: experimental ioctl\n");
-		ret = ccdc_dev->hw_ops.set_params(param);
-		if (ret) {
-			v4l2_err(&vpfe_dev->v4l2_dev,
-				"Error in setting parameters in CCDC\n");
-			goto unlock_out;
-		}
-		if (vpfe_get_ccdc_image_format(vpfe_dev, &vpfe_dev->fmt) < 0) {
-			v4l2_err(&vpfe_dev->v4l2_dev,
-				"Invalid image format at CCDC\n");
-			goto unlock_out;
+		if (ccdc_dev->hw_ops.set_params) {
+			ret = ccdc_dev->hw_ops.set_params(param);
+			if (ret) {
+				v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev,
+					"Error setting parameters in CCDC\n");
+				goto unlock_out;
+			}
+			if (vpfe_get_ccdc_image_format(vpfe_dev,
+						       &vpfe_dev->fmt) < 0) {
+				v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev,
+					"Invalid image format at CCDC\n");
+				goto unlock_out;
+			}
+		} else {
+			ret = -EINVAL;
+			v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev,
+				"VPFE_CMD_S_CCDC_RAW_PARAMS not supported\n");
 		}
 		break;
 	default:
-- 
1.6.0.4

