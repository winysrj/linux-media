Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49743 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbcELASO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 May 2016 20:18:14 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH/RFC v2 2/4] v4l: Add metadata video device type
Date: Thu, 12 May 2016 03:18:01 +0300
Message-Id: <1463012283-3078-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1463012283-3078-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1463012283-3078-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The metadata video device is used to transfer metadata between
userspace and kernelspace. It supports the metadata buffer type only.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 Documentation/DocBook/media/v4l/dev-meta.xml | 10 +++++++---
 drivers/media/v4l2-core/v4l2-dev.c           | 21 ++++++++++++++++++++-
 drivers/media/v4l2-core/v4l2-ioctl.c         | 15 ++++++++++-----
 include/media/v4l2-dev.h                     |  3 ++-
 include/uapi/linux/media.h                   |  2 ++
 5 files changed, 41 insertions(+), 10 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/dev-meta.xml b/Documentation/DocBook/media/v4l/dev-meta.xml
index 9b5b1fba2007..75bd22521af7 100644
--- a/Documentation/DocBook/media/v4l/dev-meta.xml
+++ b/Documentation/DocBook/media/v4l/dev-meta.xml
@@ -14,9 +14,13 @@ intended for transfer of metadata to userspace and control of that operation.
   </para>
 
   <para>
-The metadata interface is implemented on video capture devices. The device can
-be dedicated to metadata or can implement both video and metadata capture as
-specified in its reported capabilities.
+The metadata interface can be implemented on video capture devices, metadata
+devices or both, at the discretion of drivers. Metadata devices are accessed
+through character device special files named
+<filename>/dev/v4l-meta[0-9]+</filename> with major number 81 and dynamically
+allocated minor numbers. Video devices that support metadata capture can be
+dedicated to metadata or can implement both metadata capture and video capture
+and/or output, as specified in the device's reported capabilities.
   </para>
 
   <section>
diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 74b79e60ac38..5a8d7b03ab97 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -527,6 +527,7 @@ static void determine_valid_ioctls(struct video_device *vdev)
 	bool is_vbi = vdev->vfl_type == VFL_TYPE_VBI;
 	bool is_radio = vdev->vfl_type == VFL_TYPE_RADIO;
 	bool is_sdr = vdev->vfl_type == VFL_TYPE_SDR;
+	bool is_meta = vdev->vfl_type == VFL_TYPE_META;
 	bool is_rx = vdev->vfl_dir != VFL_DIR_TX;
 	bool is_tx = vdev->vfl_dir != VFL_DIR_RX;
 
@@ -664,9 +665,18 @@ static void determine_valid_ioctls(struct video_device *vdev)
 			set_bit(_IOC_NR(VIDIOC_S_FMT), valid_ioctls);
 		if (ops->vidioc_try_fmt_sdr_out)
 			set_bit(_IOC_NR(VIDIOC_TRY_FMT), valid_ioctls);
+	} else if (is_meta && is_rx) {
+		if (ops->vidioc_enum_fmt_meta_cap)
+			set_bit(_IOC_NR(VIDIOC_ENUM_FMT), valid_ioctls);
+		if (ops->vidioc_g_fmt_meta_cap)
+			set_bit(_IOC_NR(VIDIOC_G_FMT), valid_ioctls);
+		if (ops->vidioc_s_fmt_meta_cap)
+			set_bit(_IOC_NR(VIDIOC_S_FMT), valid_ioctls);
+		if (ops->vidioc_try_fmt_meta_cap)
+			set_bit(_IOC_NR(VIDIOC_TRY_FMT), valid_ioctls);
 	}
 
-	if (is_vid || is_vbi || is_sdr) {
+	if (is_vid || is_vbi || is_sdr || is_meta) {
 		/* ioctls valid for video, metadata, vbi or sdr */
 		SET_VALID_IOCTL(ops, VIDIOC_REQBUFS, vidioc_reqbufs);
 		SET_VALID_IOCTL(ops, VIDIOC_QUERYBUF, vidioc_querybuf);
@@ -767,6 +777,10 @@ static int video_register_media_controller(struct video_device *vdev, int type)
 		intf_type = MEDIA_INTF_T_V4L_SUBDEV;
 		/* Entity will be created via v4l2_device_register_subdev() */
 		break;
+	case VFL_TYPE_META:
+		intf_type = MEDIA_INTF_T_V4L_META;
+		vdev->entity.function = MEDIA_ENT_F_IO_META;
+		break;
 	default:
 		return 0;
 	}
@@ -849,6 +863,8 @@ static int video_register_media_controller(struct video_device *vdev, int type)
  *	%VFL_TYPE_SUBDEV - A subdevice
  *
  *	%VFL_TYPE_SDR - Software Defined Radio
+ *
+ *	%VFL_TYPE_META - Metadata
  */
 int __video_register_device(struct video_device *vdev, int type, int nr,
 		int warn_if_nr_in_use, struct module *owner)
@@ -892,6 +908,9 @@ int __video_register_device(struct video_device *vdev, int type, int nr,
 		/* Use device name 'swradio' because 'sdr' was already taken. */
 		name_base = "swradio";
 		break;
+	case VFL_TYPE_META:
+		name_base = "v4l-meta";
+		break;
 	default:
 		printk(KERN_ERR "%s called with unknown type: %d\n",
 		       __func__, type);
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 5d003152ff68..256938fff9e0 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -935,6 +935,7 @@ static int check_fmt(struct file *file, enum v4l2_buf_type type)
 	bool is_vid = vfd->vfl_type == VFL_TYPE_GRABBER;
 	bool is_vbi = vfd->vfl_type == VFL_TYPE_VBI;
 	bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
+	bool is_meta = vfd->vfl_type == VFL_TYPE_META;
 	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
 	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
 
@@ -993,7 +994,7 @@ static int check_fmt(struct file *file, enum v4l2_buf_type type)
 			return 0;
 		break;
 	case V4L2_BUF_TYPE_META_CAPTURE:
-		if (is_vid && is_rx && ops->vidioc_g_fmt_meta_cap)
+		if ((is_vid || is_meta) && is_rx && ops->vidioc_g_fmt_meta_cap)
 			return 0;
 		break;
 	default:
@@ -1324,6 +1325,7 @@ static int v4l_enum_fmt(const struct v4l2_ioctl_ops *ops,
 	struct video_device *vfd = video_devdata(file);
 	bool is_vid = vfd->vfl_type == VFL_TYPE_GRABBER;
 	bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
+	bool is_meta = vfd->vfl_type == VFL_TYPE_META;
 	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
 	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
 	int ret = -EINVAL;
@@ -1365,7 +1367,7 @@ static int v4l_enum_fmt(const struct v4l2_ioctl_ops *ops,
 		ret = ops->vidioc_enum_fmt_sdr_out(file, fh, arg);
 		break;
 	case V4L2_BUF_TYPE_META_CAPTURE:
-		if (unlikely(!is_rx || !is_vid || !ops->vidioc_enum_fmt_meta_cap))
+		if (unlikely(!is_rx || !(is_vid || is_meta) || !ops->vidioc_enum_fmt_meta_cap))
 			break;
 		ret = ops->vidioc_enum_fmt_meta_cap(file, fh, arg);
 		break;
@@ -1382,6 +1384,7 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
 	struct video_device *vfd = video_devdata(file);
 	bool is_vid = vfd->vfl_type == VFL_TYPE_GRABBER;
 	bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
+	bool is_meta = vfd->vfl_type == VFL_TYPE_META;
 	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
 	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
 	int ret;
@@ -1468,7 +1471,7 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
 			break;
 		return ops->vidioc_g_fmt_sdr_out(file, fh, arg);
 	case V4L2_BUF_TYPE_META_CAPTURE:
-		if (unlikely(!is_rx || !is_vid || !ops->vidioc_g_fmt_meta_cap))
+		if (unlikely(!is_rx || !(is_vid || is_meta) || !ops->vidioc_g_fmt_meta_cap))
 			break;
 		return ops->vidioc_g_fmt_meta_cap(file, fh, arg);
 	}
@@ -1482,6 +1485,7 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
 	struct video_device *vfd = video_devdata(file);
 	bool is_vid = vfd->vfl_type == VFL_TYPE_GRABBER;
 	bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
+	bool is_meta = vfd->vfl_type == VFL_TYPE_META;
 	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
 	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
 	int ret;
@@ -1559,7 +1563,7 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
 		CLEAR_AFTER_FIELD(p, fmt.sdr);
 		return ops->vidioc_s_fmt_sdr_out(file, fh, arg);
 	case V4L2_BUF_TYPE_META_CAPTURE:
-		if (unlikely(!is_rx || !is_vid || !ops->vidioc_s_fmt_meta_cap))
+		if (unlikely(!is_rx || !(is_vid || is_meta) || !ops->vidioc_s_fmt_meta_cap))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.meta);
 		return ops->vidioc_s_fmt_meta_cap(file, fh, arg);
@@ -1574,6 +1578,7 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
 	struct video_device *vfd = video_devdata(file);
 	bool is_vid = vfd->vfl_type == VFL_TYPE_GRABBER;
 	bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
+	bool is_meta = vfd->vfl_type == VFL_TYPE_META;
 	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
 	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
 	int ret;
@@ -1648,7 +1653,7 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
 		CLEAR_AFTER_FIELD(p, fmt.sdr);
 		return ops->vidioc_try_fmt_sdr_out(file, fh, arg);
 	case V4L2_BUF_TYPE_META_CAPTURE:
-		if (unlikely(!is_rx || !is_vid || !ops->vidioc_try_fmt_meta_cap))
+		if (unlikely(!is_rx || !(is_vid || is_meta) || !ops->vidioc_try_fmt_meta_cap))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.meta);
 		return ops->vidioc_try_fmt_meta_cap(file, fh, arg);
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index 25a3190308fb..eeab952d4940 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -25,7 +25,8 @@
 #define VFL_TYPE_RADIO		2
 #define VFL_TYPE_SUBDEV		3
 #define VFL_TYPE_SDR		4
-#define VFL_TYPE_MAX		5
+#define VFL_TYPE_META		5
+#define VFL_TYPE_MAX		6
 
 /* Is this a receiver, transmitter or mem-to-mem? */
 /* Ignored for VFL_TYPE_SUBDEV. */
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index df59edee25d1..e226bc35c639 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -77,6 +77,7 @@ struct media_device_info {
 #define MEDIA_ENT_F_IO_DTV		(MEDIA_ENT_F_BASE + 0x01001)
 #define MEDIA_ENT_F_IO_VBI		(MEDIA_ENT_F_BASE + 0x01002)
 #define MEDIA_ENT_F_IO_SWRADIO		(MEDIA_ENT_F_BASE + 0x01003)
+#define MEDIA_ENT_F_IO_META		(MEDIA_ENT_F_BASE + 0x01004)
 
 /*
  * Analog TV IF-PLL decoders
@@ -297,6 +298,7 @@ struct media_links_enum {
 #define MEDIA_INTF_T_V4L_RADIO  (MEDIA_INTF_T_V4L_BASE + 2)
 #define MEDIA_INTF_T_V4L_SUBDEV (MEDIA_INTF_T_V4L_BASE + 3)
 #define MEDIA_INTF_T_V4L_SWRADIO (MEDIA_INTF_T_V4L_BASE + 4)
+#define MEDIA_INTF_T_V4L_META   (MEDIA_INTF_T_V4L_BASE + 5)
 
 #define MEDIA_INTF_T_ALSA_PCM_CAPTURE   (MEDIA_INTF_T_ALSA_BASE)
 #define MEDIA_INTF_T_ALSA_PCM_PLAYBACK  (MEDIA_INTF_T_ALSA_BASE + 1)
-- 
2.7.3

