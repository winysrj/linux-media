Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:54678 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754583AbZLAViw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Dec 2009 16:38:52 -0500
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	khilman@deeprootsystems.com
Cc: davinci-linux-open-source@linux.davincidsp.com, hvaibhav@ti.com,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH 2/5 - v0] V4L - vpfe capture enhancements to support DM365
Date: Tue,  1 Dec 2009 16:38:50 -0500
Message-Id: <1259703533-1789-2-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1259703533-1789-1-git-send-email-m-karicheri2@ti.com>
References: <1259703533-1789-1-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <m-karicheri2@ti.com>

This patch adds support for handling CCDC configuration ioctl. A new
IOCTL added to support reading current configuration at CCDC.

NOTE: This is the initial version for review.

Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
---
 drivers/media/video/davinci/vpfe_capture.c |   74 +++++++++++++++++++++++++++-
 include/media/davinci/vpfe_capture.h       |    5 ++-
 2 files changed, 76 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/davinci/vpfe_capture.c b/drivers/media/video/davinci/vpfe_capture.c
index 35bbb08..ae8f993 100644
--- a/drivers/media/video/davinci/vpfe_capture.c
+++ b/drivers/media/video/davinci/vpfe_capture.c
@@ -759,12 +759,83 @@ static unsigned int vpfe_poll(struct file *file, poll_table *wait)
 	return 0;
 }
 
+static long vpfe_param_handler(struct file *file, void *priv,
+		int cmd, void *param)
+{
+	struct vpfe_device *vpfe_dev = video_drvdata(file);
+	int ret = 0;
+
+	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_param_handler\n");
+
+	if (NULL == param) {
+		v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev,
+			"Invalid user ptr\n");
+	}
+
+	if (vpfe_dev->started) {
+		/* only allowed if streaming is not started */
+		v4l2_err(&vpfe_dev->v4l2_dev, "device already started\n");
+		return -EBUSY;
+	}
+
+
+	switch (cmd) {
+	case VPFE_CMD_S_CCDC_RAW_PARAMS:
+		v4l2_warn(&vpfe_dev->v4l2_dev,
+			  "VPFE_CMD_S_CCDC_RAW_PARAMS: experimental ioctl\n");
+		ret = mutex_lock_interruptible(&vpfe_dev->lock);
+		if (ret)
+			return ret;
+		ret = ccdc_dev->hw_ops.set_params(param);
+		if (ret) {
+			v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev,
+				"Error in setting parameters in CCDC\n");
+			goto unlock_out;
+		}
+
+		if (vpfe_get_ccdc_image_format(vpfe_dev, &vpfe_dev->fmt) < 0) {
+			v4l2_err(&vpfe_dev->v4l2_dev,
+				"Invalid image format at CCDC\n");
+			ret = -EINVAL;
+		}
+unlock_out:
+		mutex_unlock(&vpfe_dev->lock);
+		break;
+	case VPFE_CMD_G_CCDC_RAW_PARAMS:
+		v4l2_warn(&vpfe_dev->v4l2_dev,
+			  "VPFE_CMD_G_CCDC_RAW_PARAMS: experimental ioctl\n");
+		if (!ccdc_dev->hw_ops.get_params) {
+			ret = -EINVAL;
+			break;
+		}
+		ret = ccdc_dev->hw_ops.get_params(param);
+		if (ret) {
+			v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev,
+				"Error in getting parameters from CCDC\n");
+		}
+		break;
+
+	default:
+		ret = -EINVAL;
+	}
+	return ret;
+}
+
+static long vpfe_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	if (cmd == VPFE_CMD_S_CCDC_RAW_PARAMS ||
+	    cmd == VPFE_CMD_G_CCDC_RAW_PARAMS)
+		return vpfe_param_handler(file, file->private_data, cmd,
+					 (void *)arg);
+	return video_ioctl2(file, cmd, arg);
+}
+
 /* vpfe capture driver file operations */
 static const struct v4l2_file_operations vpfe_fops = {
 	.owner = THIS_MODULE,
 	.open = vpfe_open,
 	.release = vpfe_release,
-	.unlocked_ioctl = video_ioctl2,
+	.unlocked_ioctl = vpfe_ioctl,
 	.mmap = vpfe_mmap,
 	.poll = vpfe_poll
 };
@@ -1751,7 +1822,6 @@ static const struct v4l2_ioctl_ops vpfe_ioctl_ops = {
 	.vidioc_cropcap		 = vpfe_cropcap,
 	.vidioc_g_crop		 = vpfe_g_crop,
 	.vidioc_s_crop		 = vpfe_s_crop,
-	.vidioc_default		 = vpfe_param_handler,
 };
 
 static struct vpfe_device *vpfe_initialize(void)
diff --git a/include/media/davinci/vpfe_capture.h b/include/media/davinci/vpfe_capture.h
index 7b62a5c..1e6817c 100644
--- a/include/media/davinci/vpfe_capture.h
+++ b/include/media/davinci/vpfe_capture.h
@@ -71,7 +71,7 @@ struct vpfe_subdev_info {
 	/* Sub dev routing information for each input */
 	struct vpfe_route *routes;
 	/* check if sub dev supports routing */
-	int can_route;
+	int can_route:1;
 	/* ccdc bus/interface configuration */
 	struct vpfe_hw_if_param ccdc_if_params;
 	/* i2c subdevice board info */
@@ -202,4 +202,7 @@ struct vpfe_config_params {
  **/
 #define VPFE_CMD_S_CCDC_RAW_PARAMS _IOW('V', BASE_VIDIOC_PRIVATE + 1, \
 					void *)
+#define VPFE_CMD_G_CCDC_RAW_PARAMS _IOR('V', BASE_VIDIOC_PRIVATE + 2, \
+					void *)
+
 #endif				/* _DAVINCI_VPFE_H */
-- 
1.6.0.4

