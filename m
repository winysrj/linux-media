Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:34549 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118AbZJPKUB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Oct 2009 06:20:01 -0400
Received: from dbdp31.itg.ti.com ([172.24.170.98])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id n9GAJMb8017513
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 16 Oct 2009 05:19:24 -0500
From: hvaibhav@ti.com
To: linux-media@vger.kernel.org
Cc: Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH 1/4] V4L2: Added New V4L2 CIDs VIDIOC_S/G_COLOR_SPACE_CONV
Date: Fri, 16 Oct 2009 15:49:20 +0530
Message-Id: <1255688360-6278-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vaibhav Hiremath <hvaibhav@ti.com>


Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 drivers/media/video/v4l2-ioctl.c |   19 +++++++++++++++++++
 include/linux/videodev2.h        |   14 ++++++++++++++
 include/media/v4l2-ioctl.h       |    4 ++++
 3 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 30cc334..d3140e0 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -284,6 +284,8 @@ static const char *v4l2_ioctls[] = {
 	[_IOC_NR(VIDIOC_DBG_G_CHIP_IDENT)] = "VIDIOC_DBG_G_CHIP_IDENT",
 	[_IOC_NR(VIDIOC_S_HW_FREQ_SEEK)]   = "VIDIOC_S_HW_FREQ_SEEK",
 #endif
+	[_IOC_NR(VIDIOC_S_COLOR_SPACE_CONV)]   = "VIDIOC_S_COLOR_SPACE_CONV",
+	[_IOC_NR(VIDIOC_G_COLOR_SPACE_CONV)]   = "VIDIOC_G_COLOR_SPACE_CONV",
 };
 #define V4L2_IOCTLS ARRAY_SIZE(v4l2_ioctls)
 
@@ -1795,6 +1797,23 @@ static long __video_do_ioctl(struct file *file,
 		break;
 	}
 
+	/*---------------Color space conversion------------------------------*/
+	case VIDIOC_S_COLOR_SPACE_CONV:
+	{
+		struct v4l2_color_space_conv *p = arg;
+		if (!ops->vidioc_s_color_space_conv)
+			break;
+		ret = ops->vidioc_s_color_space_conv(file, fh, p);
+		break;
+	}
+	case VIDIOC_G_COLOR_SPACE_CONV:
+	{
+		struct v4l2_color_space_conv *p = arg;
+		if (!ops->vidioc_g_color_space_conv)
+			break;
+		ret = ops->vidioc_g_color_space_conv(file, fh, p);
+		break;
+	}
 	default:
 	{
 		if (!ops->vidioc_default)
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index b59e78c..b6fe1de 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1281,6 +1281,18 @@ struct v4l2_rds_data {
 #define V4L2_RDS_BLOCK_ERROR 	 0x80
 
 /*
+ * Color conversion
+ * User needs to pass pointer to color conversion matrix
+ * defined by hardware
+ */
+struct v4l2_color_space_conv {
+	__s32 coefficients[3][3];
+	__s32 const_factor;
+	__s32 input_offs[3];
+	__s32 output_offs[3];
+};
+
+/*
  *	A U D I O
  */
 struct v4l2_audio {
@@ -1619,6 +1631,8 @@ struct v4l2_dbg_chip_ident {
 #endif
 
 #define VIDIOC_S_HW_FREQ_SEEK	 _IOW('V', 82, struct v4l2_hw_freq_seek)
+#define VIDIOC_S_COLOR_SPACE_CONV _IOW('V', 83, struct v4l2_color_space_conv)
+#define VIDIOC_G_COLOR_SPACE_CONV _IOR('V', 84, struct v4l2_color_space_conv)
 /* Reminder: when adding new ioctls please add support for them to
    drivers/media/video/v4l2-compat-ioctl32.c as well! */
 
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index 7a4529d..0e31ace 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -242,6 +242,10 @@ struct v4l2_ioctl_ops {
 	/* For other private ioctls */
 	long (*vidioc_default)	       (struct file *file, void *fh,
 					int cmd, void *arg);
+	int (*vidioc_s_color_space_conv)     (struct file *file, void *fh,
+					struct v4l2_color_space_conv *a);
+	int (*vidioc_g_color_space_conv)     (struct file *file, void *fh,
+					struct v4l2_color_space_conv *a);
 };
 
 
-- 
1.6.2.4

