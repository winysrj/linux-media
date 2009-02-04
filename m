Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:39740 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbZBDFfq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Feb 2009 00:35:46 -0500
Received: from dbdp31.itg.ti.com ([172.24.170.98])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id n145ZdVE008716
	for <linux-media@vger.kernel.org>; Tue, 3 Feb 2009 23:35:45 -0600
From: Hardik Shah <hardik.shah@ti.com>
To: linux-media@vger.kernel.org
Cc: Hardik Shah <hardik.shah@ti.com>, Brijesh Jadav <brijesh.j@ti.com>,
	Hari Nagalla <hnagalla@ti.com>,
	Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH 1/2v3] New V4L2 ioctls for OMAP class of Devices
Date: Wed,  4 Feb 2009 11:05:34 +0530
Message-Id: <1233725734-592-1-git-send-email-hardik.shah@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

1.  Control ID added for rotation.  Same as HFLIP.
2.  Control ID added for setting background color on
    output device.
3.  New ioctl added for setting the color space conversion from
    YUV to RGB.
4.  Updated the v4l2-common.c file accordingly.
5.  Updated the color_space_conv matrix structure according to
    comments from Hans Verikul and others.

Signed-off-by: Brijesh Jadav <brijesh.j@ti.com>
Signed-off-by: Hari Nagalla <hnagalla@ti.com>
Signed-off-by: Hardik Shah <hardik.shah@ti.com>
Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 linux/drivers/media/video/v4l2-common.c |   16 ++++++++++++++--
 linux/drivers/media/video/v4l2-ioctl.c  |   19 ++++++++++++++++++-
 linux/include/linux/videodev2.h         |   26 ++++++++++++++++++++++----
 linux/include/media/v4l2-ioctl.h        |    4 ++++
 4 files changed, 58 insertions(+), 7 deletions(-)

diff --git a/linux/drivers/media/video/v4l2-common.c b/linux/drivers/media/video/v4l2-common.c
index 6cc7d40..b645821 100644
--- a/linux/drivers/media/video/v4l2-common.c
+++ b/linux/drivers/media/video/v4l2-common.c
@@ -78,7 +78,6 @@ MODULE_LICENSE("GPL");
  *  Video Standard Operations (contributed by Michael Schimek)
  */

-
 /* ----------------------------------------------------------------- */
 /* priority handling                                                 */

@@ -413,6 +412,8 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_BACKLIGHT_COMPENSATION:	return "Backlight Compensation";
 	case V4L2_CID_CHROMA_AGC:		return "Chroma AGC";
 	case V4L2_CID_COLOR_KILLER:		return "Color Killer";
+	case V4L2_CID_ROTATION:         	return "Rotation";
+	case V4L2_CID_BG_COLOR:         	return "Background color";

 	/* MPEG controls */
 	case V4L2_CID_MPEG_CLASS: 		return "MPEG Encoder Controls";
@@ -528,6 +529,10 @@ int v4l2_ctrl_query_fill(struct v4l2_queryctrl *qctrl, s32 min, s32 max, s32 ste
 		qctrl->flags |= V4L2_CTRL_FLAG_READ_ONLY;
 		min = max = step = def = 0;
 		break;
+	case V4L2_CID_BG_COLOR:
+		 qctrl->type = V4L2_CTRL_TYPE_INTEGER;
+		 step = 1;
+		 break;
 	default:
 		qctrl->type = V4L2_CTRL_TYPE_INTEGER;
 		break;
@@ -548,6 +553,7 @@ int v4l2_ctrl_query_fill(struct v4l2_queryctrl *qctrl, s32 min, s32 max, s32 ste
 	case V4L2_CID_CONTRAST:
 	case V4L2_CID_SATURATION:
 	case V4L2_CID_HUE:
+	case V4L2_CID_BG_COLOR:
 		qctrl->flags |= V4L2_CTRL_FLAG_SLIDER;
 		break;
 	}
@@ -586,6 +592,13 @@ int v4l2_ctrl_query_fill_std(struct v4l2_queryctrl *qctrl)
 		return v4l2_ctrl_query_fill(qctrl, 0, 127, 1, 64);
 	case V4L2_CID_HUE:
 		return v4l2_ctrl_query_fill(qctrl, -128, 127, 1, 0);
+	case V4L2_CID_BG_COLOR:
+		/* Max value is 2^24 as RGB888 is used for background color */
+		return v4l2_ctrl_query_fill(qctrl, 0, 16777216, 1, 0);
+	case V4L2_CID_ROTATION:
+		/* Standard rotation values supported will be 0, 90, 180,
+		   270 degree */
+		return v4l2_ctrl_query_fill(qctrl, 0, 270, 90, 0);

 	/* MPEG controls */
 	case V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ:
@@ -927,7 +940,6 @@ static struct i2c_client *v4l2_i2c_legacy_find_client(struct i2c_adapter *adap,
 }
 #endif

-
 /* Load an i2c sub-device. It assumes that i2c_get_adapdata(adapter)
    returns the v4l2_device and that i2c_get_clientdata(client)
    returns the v4l2_subdev. */
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
index e5be28a..82f1776 100644
--- a/linux/include/linux/videodev2.h
+++ b/linux/include/linux/videodev2.h
@@ -880,8 +880,10 @@ enum v4l2_power_line_frequency {
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
@@ -1193,6 +1195,22 @@ struct v4l2_hw_freq_seek {
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
+	__u32 capability;
+	__u32 precision;
+	__u32 reserved[4];
+};
+#define V4L2_COLOR_SPACE_CAP_COEFF	0x00001
+#define V4L2_COLOR_SPACE_CAP_OFFS	0x00002
+
+/*
  *	A U D I O
  */
 struct v4l2_audio {
@@ -1245,7 +1263,6 @@ struct v4l2_enc_idx {
 	struct v4l2_enc_idx_entry entry[V4L2_ENC_IDX_ENTRIES];
 };

-
 #define V4L2_ENC_CMD_START      (0)
 #define V4L2_ENC_CMD_STOP       (1)
 #define V4L2_ENC_CMD_PAUSE      (2)
@@ -1266,7 +1283,6 @@ struct v4l2_encoder_cmd {

 #endif

-
 /*
  *	D A T A   S E R V I C E S   ( V B I )
  *
@@ -1356,7 +1372,6 @@ struct v4l2_format {
 	} fmt;
 };

-
 /*	Stream type-dependent parameters
  */
 struct v4l2_streamparm {
@@ -1494,6 +1509,9 @@ struct v4l2_chip_ident_old {
 #endif

 #define VIDIOC_S_HW_FREQ_SEEK	 _IOW('V', 82, struct v4l2_hw_freq_seek)
+
+#define VIDIOC_S_COLOR_SPACE_CONV      _IOW('V', 83, struct v4l2_color_space_conversion)
+#define VIDIOC_G_COLOR_SPACE_CONV      _IOR('V', 84, struct v4l2_color_space_conversion)
 /* Reminder: when adding new ioctls please add support for them to
    drivers/media/video/v4l2-compat-ioctl32.c as well! */

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

