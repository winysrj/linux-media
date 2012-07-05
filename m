Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:29304 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932627Ab2GEOf6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2012 10:35:58 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, device-drivers-devel@blackfin.uclinux.org
Subject: [RFCv1 PATCH 3/7] v4l2-subdev: add support for the new edid ioctls.
Date: Thu,  5 Jul 2012 16:26:11 +0200
Message-Id: <7fa4098d7af62de080e15b46f5bc1744509ac1f9.1341497271.git.hans.verkuil@cisco.com>
In-Reply-To: <1341498375-9411-1-git-send-email-hans.verkuil@cisco.com>
References: <1341498375-9411-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <e47312104a7f92ad99d1021e317b7d16e0344be3.1341497271.git.hans.verkuil@cisco.com>
References: <e47312104a7f92ad99d1021e317b7d16e0344be3.1341497271.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-ioctl.c  |   13 +++++++++++++
 drivers/media/video/v4l2-subdev.c |    6 ++++++
 include/media/v4l2-subdev.h       |    2 ++
 3 files changed, 21 insertions(+)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index d7fa896..248cc28 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -2169,6 +2169,19 @@ static int check_array_args(unsigned int cmd, void *parg, size_t *array_size,
 		break;
 	}
 
+	case VIDIOC_SUBDEV_G_EDID:
+	case VIDIOC_SUBDEV_S_EDID: {
+		struct v4l2_subdev_edid *edid = parg;
+
+		if (edid->blocks) {
+			*user_ptr = (void __user *)edid->edid;
+			*kernel_ptr = (void *)&edid->edid;
+			*array_size = edid->blocks * 128;
+			ret = 1;
+		}
+		break;
+	}
+
 	case VIDIOC_S_EXT_CTRLS:
 	case VIDIOC_G_EXT_CTRLS:
 	case VIDIOC_TRY_EXT_CTRLS: {
diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
index db6e859..3d46cd6 100644
--- a/drivers/media/video/v4l2-subdev.c
+++ b/drivers/media/video/v4l2-subdev.c
@@ -348,6 +348,12 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		return v4l2_subdev_call(
 			sd, pad, set_selection, subdev_fh, sel);
 	}
+
+	case VIDIOC_SUBDEV_G_EDID:
+		return v4l2_subdev_call(sd, pad, get_edid, arg);
+
+	case VIDIOC_SUBDEV_S_EDID:
+		return v4l2_subdev_call(sd, pad, set_edid, arg);
 #endif
 	default:
 		return v4l2_subdev_call(sd, core, ioctl, cmd, arg);
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index c35a354..74c578f 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -476,6 +476,8 @@ struct v4l2_subdev_pad_ops {
 			     struct v4l2_subdev_selection *sel);
 	int (*set_selection)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 			     struct v4l2_subdev_selection *sel);
+	int (*get_edid)(struct v4l2_subdev *sd, struct v4l2_subdev_edid *edid);
+	int (*set_edid)(struct v4l2_subdev *sd, struct v4l2_subdev_edid *edid);
 #ifdef CONFIG_MEDIA_CONTROLLER
 	int (*link_validate)(struct v4l2_subdev *sd, struct media_link *link,
 			     struct v4l2_subdev_format *source_fmt,
-- 
1.7.10

