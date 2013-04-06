Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1122 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932855Ab3DFL0I (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Apr 2013 07:26:08 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 5/7] v4l2: add range support for VIDIOC_DBG_G_CHIP_INFO
Date: Sat,  6 Apr 2013 13:25:50 +0200
Message-Id: <1365247552-26795-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365247552-26795-1-git-send-email-hverkuil@xs4all.nl>
References: <1365247552-26795-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

More devices than expected have several register ranges. By exposing these
ranges through the G_CHIP_INFO API life is simplified for debug tools. By
keeping such information in the driver itself is it also easy to keep the
code up to date or to modify the ranges depending on the exact variant
of the device.

This code is active only when the VIDEO_ADV_DEBUG config option is set, so
this does not increase the driver size in normal circumstances.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |    2 +-
 drivers/media/v4l2-core/v4l2-ioctl.c    |   12 +++++++-----
 include/media/v4l2-subdev.h             |    1 +
 include/uapi/linux/videodev2.h          |    8 ++++++--
 4 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index c27c1f6..77a47aa 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1338,7 +1338,7 @@ static int vidioc_g_chip_info(struct file *file, void *priv,
 	struct em28xx_fh      *fh  = priv;
 	struct em28xx         *dev = fh->dev;
 
-	if (chip->match.addr > 1)
+	if (chip->match.addr > 1 || chip->range)
 		return -EINVAL;
 	if (chip->match.addr == 1)
 		strlcpy(chip->name, "ac97", sizeof(chip->name));
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index f81bda1..ce923ce 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1877,7 +1877,7 @@ static int v4l_dbg_g_chip_info(const struct v4l2_ioctl_ops *ops,
 			strlcpy(p->name, "bridge", sizeof(p->name));
 		if (ops->vidioc_g_chip_info)
 			return ops->vidioc_g_chip_info(file, fh, arg);
-		if (p->match.addr)
+		if (p->match.addr || p->range)
 			return -EINVAL;
 		return 0;
 
@@ -1887,12 +1887,14 @@ static int v4l_dbg_g_chip_info(const struct v4l2_ioctl_ops *ops,
 		v4l2_device_for_each_subdev(sd, vfd->v4l2_dev) {
 			if (p->match.addr != idx++)
 				continue;
-			if (sd->ops->core && sd->ops->core->s_register)
+			if (v4l2_subdev_has_op(sd, core, s_register))
 				p->flags |= V4L2_CHIP_FL_WRITABLE;
-			if (sd->ops->core && sd->ops->core->g_register)
+			if (v4l2_subdev_has_op(sd, core, g_register))
 				p->flags |= V4L2_CHIP_FL_READABLE;
 			strlcpy(p->name, sd->name, sizeof(p->name));
-			return 0;
+			if (v4l2_subdev_has_op(sd, core, g_chip_info))
+				return v4l2_subdev_call(sd, core, g_chip_info, arg);
+			return p->range ? -EINVAL : 0;
 		}
 		break;
 	}
@@ -2116,7 +2118,7 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO_STD(VIDIOC_QUERY_DV_TIMINGS, vidioc_query_dv_timings, v4l_print_dv_timings, 0),
 	IOCTL_INFO_STD(VIDIOC_DV_TIMINGS_CAP, vidioc_dv_timings_cap, v4l_print_dv_timings_cap, INFO_FL_CLEAR(v4l2_dv_timings_cap, type)),
 	IOCTL_INFO_FNC(VIDIOC_ENUM_FREQ_BANDS, v4l_enum_freq_bands, v4l_print_freq_band, 0),
-	IOCTL_INFO_FNC(VIDIOC_DBG_G_CHIP_INFO, v4l_dbg_g_chip_info, v4l_print_dbg_chip_info, INFO_FL_CLEAR(v4l2_dbg_chip_info, match)),
+	IOCTL_INFO_FNC(VIDIOC_DBG_G_CHIP_INFO, v4l_dbg_g_chip_info, v4l_print_dbg_chip_info, INFO_FL_CLEAR(v4l2_dbg_chip_info, range)),
 };
 #define V4L2_IOCTLS ARRAY_SIZE(v4l2_ioctls)
 
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 5298d67..5de1785 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -146,6 +146,7 @@ struct v4l2_subdev_io_pin_config {
  */
 struct v4l2_subdev_core_ops {
 	int (*g_chip_ident)(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip);
+	int (*g_chip_info)(struct v4l2_subdev *sd, struct v4l2_dbg_chip_info *chip);
 	int (*log_status)(struct v4l2_subdev *sd);
 	int (*s_io_pin_config)(struct v4l2_subdev *sd, size_t n,
 				      struct v4l2_subdev_io_pin_config *pincfg);
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index be43b46..6868ad5 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1842,9 +1842,13 @@ struct v4l2_dbg_chip_ident {
 /* VIDIOC_DBG_G_CHIP_INFO */
 struct v4l2_dbg_chip_info {
 	struct v4l2_dbg_match match;
-	char name[32];
+	__u32 range;
 	__u32 flags;
-	__u32 reserved[8];
+	char name[32];
+	char range_name[32];
+	__u64 range_start;
+	__u64 range_size;
+	__u32 reserved[16];
 } __attribute__ ((packed));
 
 /**
-- 
1.7.10.4

