Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:60102 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab2GRJGs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jul 2012 05:06:48 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, device-drivers-devel@blackfin.uclinux.org
Subject: [RFCv2 PATCH 3/7] v4l2-subdev: add support for the new edid ioctls.
Date: Wed, 18 Jul 2012 11:06:16 +0200
Message-Id: <c9e4cb743bfc9078b7a9399ddec22a9c01163988.1342601681.git.hans.verkuil@cisco.com>
In-Reply-To: <1342602380-5854-1-git-send-email-hans.verkuil@cisco.com>
References: <1342602380-5854-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <c9c25dde447e731e6f0925bd175550196c5612e0.1342601681.git.hans.verkuil@cisco.com>
References: <c9c25dde447e731e6f0925bd175550196c5612e0.1342601681.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-ioctl.c  |   13 +++++++++++++
 drivers/media/video/v4l2-subdev.c |    6 ++++++
 include/media/v4l2-subdev.h       |    2 ++
 3 files changed, 21 insertions(+)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 70e0efb..b2aa957 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -2099,6 +2099,19 @@ static int check_array_args(unsigned int cmd, void *parg, size_t *array_size,
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
index 9182f81..dced41c 100644
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

