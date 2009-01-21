Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:45529 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756228AbZAULyI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Jan 2009 06:54:08 -0500
From: Hardik Shah <hardik.shah@ti.com>
To: video4linux-list@redhat.com, linux-media@vger.kernel.org
Cc: Hardik Shah <hardik.shah@ti.com>, Brijesh Jadav <brijesh.j@ti.com>,
	Hari Nagalla <hnagalla@ti.com>, Manjunath Hadli <mrh@ti.com>,
	R Sivaraj <sivaraj@ti.com>, Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH] New V4L2 ioctls for OMAP class of Devices
Date: Wed, 21 Jan 2009 17:23:40 +0530
Message-Id: <1232538820-20307-1-git-send-email-hardik.shah@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

1.  Control ID added for rotation.  Same as HFLIP.
2.  Control ID added for setting background color on
    output device.
3.  New ioctl added for setting the color space conversion from
    YUV to RGB.

Signed-off-by: Brijesh Jadav <brijesh.j@ti.com>
Signed-off-by: Hari Nagalla <hnagalla@ti.com>
Signed-off-by: Hardik Shah <hardik.shah@ti.com>
Signed-off-by: Manjunath Hadli <mrh@ti.com>
Signed-off-by: R Sivaraj <sivaraj@ti.com>
Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 linux/drivers/media/video/v4l2-ioctl.c |   19 ++++++++++++++++++-
 linux/include/linux/videodev2.h        |   19 ++++++++++++++++++-
 linux/include/media/v4l2-ioctl.h       |    4 ++++
 3 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/linux/drivers/media/video/v4l2-ioctl.c b/linux/drivers/media/video/v4l2-ioctl.c
index 165bc90..7599da8 100644
--- a/linux/drivers/media/video/v4l2-ioctl.c
+++ b/linux/drivers/media/video/v4l2-ioctl.c
@@ -270,6 +270,8 @@ static const char *v4l2_ioctls[] = {
 	[_IOC_NR(VIDIOC_DBG_G_CHIP_IDENT)] = "VIDIOC_DBG_G_CHIP_IDENT",
 	[_IOC_NR(VIDIOC_S_HW_FREQ_SEEK)]   = "VIDIOC_S_HW_FREQ_SEEK",
 #endif
+	[_IOC_NR(VIDIOC_S_COLOR_SPACE_CONV)]   = "VIDIOC_S_COLOR_SPACE_CONV",
+	[_IOC_NR(VIDIOC_G_COLOR_SPACE_CONV)]   = "VIDIOC_G_COLOR_SPACE_CONV",
 };
 #define V4L2_IOCTLS ARRAY_SIZE(v4l2_ioctls)

@@ -1838,7 +1840,22 @@ static long __video_do_ioctl(struct file *file,
 		}
 		break;
 	}
-
+	case VIDIOC_S_COLOR_SPACE_CONV:
+	{
+		struct v4l2_color_space_conversion *p = arg;
+		if (!ops->vidioc_s_color_space_conv)
+			break;
+		ret = ops->vidioc_s_color_space_conv(file, fh, p);
+		break;
+	}
+	case VIDIOC_G_COLOR_SPACE_CONV:
+	{
+		struct v4l2_color_space_conversion *p = arg;
+		if (!ops->vidioc_g_color_space_conv)
+			break;
+		ret = ops->vidioc_g_color_space_conv(file, fh, p);
+		break;
+	}
 	default:
 	{
 		if (!ops->vidioc_default)
diff --git a/linux/include/linux/videodev2.h b/linux/include/linux/videodev2.h
index b0c5010..9fbc3b0 100644
--- a/linux/include/linux/videodev2.h
+++ b/linux/include/linux/videodev2.h
@@ -879,8 +879,10 @@ enum v4l2_power_line_frequency {
 #define V4L2_CID_BACKLIGHT_COMPENSATION 	(V4L2_CID_BASE+28)
 #define V4L2_CID_CHROMA_AGC                     (V4L2_CID_BASE+29)
 #define V4L2_CID_COLOR_KILLER                   (V4L2_CID_BASE+30)
+#define V4L2_CID_ROTATION			(V4L2_CID_BASE+31)
+#define V4L2_CID_BG_COLOR			(V4L2_CID_BASE+32)
 /* last CID + 1 */
-#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+31)
+#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+33)

 /*  MPEG-class control IDs defined by V4L2 */
 #define V4L2_CID_MPEG_BASE 			(V4L2_CTRL_CLASS_MPEG | 0x900)
@@ -1192,6 +1194,17 @@ struct v4l2_hw_freq_seek {
 };

 /*
+ * Color conversion
+ * User needs to pass pointer to color conversion matrix
+ * defined by hardware
+ */
+struct v4l2_color_space_conversion {
+	__s32 coefficients[3][3];
+	__s32 const_factor;
+	__s32 offsets[3];
+};
+
+/*
  *	A U D I O
  */
 struct v4l2_audio {
@@ -1493,9 +1506,13 @@ struct v4l2_chip_ident_old {
 #endif

 #define VIDIOC_S_HW_FREQ_SEEK	 _IOW('V', 82, struct v4l2_hw_freq_seek)
+
+#define VIDIOC_S_COLOR_SPACE_CONV      _IOW('V', 83, struct v4l2_color_space_conversion)
+#define VIDIOC_G_COLOR_SPACE_CONV      _IOR('V', 84, struct v4l2_color_space_conversion)
 /* Reminder: when adding new ioctls please add support for them to
    drivers/media/video/v4l2-compat-ioctl32.c as well! */

+
 #ifdef __OLD_VIDIOC_
 /* for compatibility, will go away some day */
 #define VIDIOC_OVERLAY_OLD     	_IOWR('V', 14, int)
diff --git a/linux/include/media/v4l2-ioctl.h b/linux/include/media/v4l2-ioctl.h
index b01c044..0c44ecf 100644
--- a/linux/include/media/v4l2-ioctl.h
+++ b/linux/include/media/v4l2-ioctl.h
@@ -241,6 +241,10 @@ struct v4l2_ioctl_ops {
 	/* For other private ioctls */
 	long (*vidioc_default)	       (struct file *file, void *fh,
 					int cmd, void *arg);
+	int (*vidioc_s_color_space_conv)     (struct file *file, void *fh,
+					struct v4l2_color_space_conversion *a);
+	int (*vidioc_g_color_space_conv)     (struct file *file, void *fh,
+					struct v4l2_color_space_conversion *a);
 };


--
1.5.6

