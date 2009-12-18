Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:46710 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969AbZLRX6b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2009 18:58:31 -0500
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	khilman@deeprootsystems.com, hvaibhav@ti.com, nsekhar@ti.com
Cc: davinci-linux-open-source@linux.davincidsp.com,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH - v2 4/6] V4L - vpfe_capture - bug fixes and enhancements
Date: Fri, 18 Dec 2009 18:58:25 -0500
Message-Id: <1261180705-8150-6-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1261180705-8150-5-git-send-email-m-karicheri2@ti.com>
References: <1261180705-8150-1-git-send-email-m-karicheri2@ti.com>
 <1261180705-8150-2-git-send-email-m-karicheri2@ti.com>
 <1261180705-8150-3-git-send-email-m-karicheri2@ti.com>
 <1261180705-8150-4-git-send-email-m-karicheri2@ti.com>
 <1261180705-8150-5-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <m-karicheri2@ti.com>

Updated based on comments against v1 of the patch

Added a experimental IOCTL, to read the CCDC parameters.
Default handler was not getting the original pointer from the core.
So a wrapper function added to handle the default handler properly.
Also fixed a bug in the probe() in the linux-next tree

Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
---
Applies to linux-next of v4l-dvb
 drivers/media/video/davinci/vpfe_capture.c |  120 +++++++++++++++++-----------
 include/media/davinci/vpfe_capture.h       |   12 ++-
 2 files changed, 81 insertions(+), 51 deletions(-)

diff --git a/drivers/media/video/davinci/vpfe_capture.c b/drivers/media/video/davinci/vpfe_capture.c
index 9e3a531..99ffc62 100644
--- a/drivers/media/video/davinci/vpfe_capture.c
+++ b/drivers/media/video/davinci/vpfe_capture.c
@@ -758,12 +758,83 @@ static unsigned int vpfe_poll(struct file *file, poll_table *wait)
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
+		return -EINVAL;
+	}
+
+	if (vpfe_dev->started) {
+		/* only allowed if streaming is not started */
+		v4l2_err(&vpfe_dev->v4l2_dev, "device already started\n");
+		return -EBUSY;
+	}
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
+	default:
+		ret = -EINVAL;
+		break;
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
@@ -1681,50 +1752,6 @@ unlock_out:
 	return ret;
 }
 
-
-static long vpfe_param_handler(struct file *file, void *priv,
-		int cmd, void *param)
-{
-	struct vpfe_device *vpfe_dev = video_drvdata(file);
-	int ret = 0;
-
-	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_param_handler\n");
-
-	if (vpfe_dev->started) {
-		/* only allowed if streaming is not started */
-		v4l2_err(&vpfe_dev->v4l2_dev, "device already started\n");
-		return -EBUSY;
-	}
-
-	ret = mutex_lock_interruptible(&vpfe_dev->lock);
-	if (ret)
-		return ret;
-
-	switch (cmd) {
-	case VPFE_CMD_S_CCDC_RAW_PARAMS:
-		v4l2_warn(&vpfe_dev->v4l2_dev,
-			  "VPFE_CMD_S_CCDC_RAW_PARAMS: experimental ioctl\n");
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
-		}
-		break;
-	default:
-		ret = -EINVAL;
-	}
-unlock_out:
-	mutex_unlock(&vpfe_dev->lock);
-	return ret;
-}
-
-
 /* vpfe capture ioctl operations */
 static const struct v4l2_ioctl_ops vpfe_ioctl_ops = {
 	.vidioc_querycap	 = vpfe_querycap,
@@ -1750,7 +1777,6 @@ static const struct v4l2_ioctl_ops vpfe_ioctl_ops = {
 	.vidioc_cropcap		 = vpfe_cropcap,
 	.vidioc_g_crop		 = vpfe_g_crop,
 	.vidioc_s_crop		 = vpfe_s_crop,
-	.vidioc_default		 = vpfe_param_handler,
 };
 
 static struct vpfe_device *vpfe_initialize(void)
@@ -1921,8 +1947,8 @@ static __init int vpfe_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, vpfe_dev);
 	/* set driver private data */
 	video_set_drvdata(vpfe_dev->video_dev, vpfe_dev);
-	i2c_adap = i2c_get_adapter(vpfe_cfg->i2c_adapter_id);
 	vpfe_cfg = pdev->dev.platform_data;
+	i2c_adap = i2c_get_adapter(vpfe_cfg->i2c_adapter_id);
 	num_subdevs = vpfe_cfg->num_subdevs;
 	vpfe_dev->sd = kmalloc(sizeof(struct v4l2_subdev *) * num_subdevs,
 				GFP_KERNEL);
diff --git a/include/media/davinci/vpfe_capture.h b/include/media/davinci/vpfe_capture.h
index d863e5e..23043bd 100644
--- a/include/media/davinci/vpfe_capture.h
+++ b/include/media/davinci/vpfe_capture.h
@@ -31,8 +31,6 @@
 #include <media/videobuf-dma-contig.h>
 #include <media/davinci/vpfe_types.h>
 
-#define VPFE_CAPTURE_NUM_DECODERS        5
-
 /* Macros */
 #define VPFE_MAJOR_RELEASE              0
 #define VPFE_MINOR_RELEASE              0
@@ -91,8 +89,9 @@ struct vpfe_config {
 	char *card_name;
 	/* ccdc name */
 	char *ccdc;
-	/* vpfe clock */
+	/* vpfe clock. Obsolete! Will be removed in next patch */
 	struct clk *vpssclk;
+	/* Obsolete! Will be removed in next patch */
 	struct clk *slaveclk;
 };
 
@@ -193,8 +192,13 @@ struct vpfe_config_params {
  * color space conversion, culling etc. This is an experimental ioctl that
  * will change in future kernels. So use this ioctl with care !
  * TODO: This is to be split into multiple ioctls and also explore the
- * possibility of extending the v4l2 api to include this
+ * possibility of extending the v4l2 api to include this.
+ * VPFE_CMD_G_CCDC_RAW_PARAMS - EXPERIMENTAL IOCTL to get the current raw
+ * capture parameters
  **/
 #define VPFE_CMD_S_CCDC_RAW_PARAMS _IOW('V', BASE_VIDIOC_PRIVATE + 1, \
 					void *)
+#define VPFE_CMD_G_CCDC_RAW_PARAMS _IOR('V', BASE_VIDIOC_PRIVATE + 2, \
+					void *)
+
 #endif				/* _DAVINCI_VPFE_H */
-- 
1.6.0.4

