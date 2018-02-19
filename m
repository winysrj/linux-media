Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:50381 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751997AbeBSOIH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 09:08:07 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 01/10] v4l2-subdev: clear reserved fields
Date: Mon, 19 Feb 2018 15:07:53 +0100
Message-Id: <20180219140802.3514-2-hverkuil@xs4all.nl>
In-Reply-To: <20180219140802.3514-1-hverkuil@xs4all.nl>
References: <20180219140802.3514-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Clear the reserved fields for these ioctls according to the specification:

VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL
VIDIOC_SUBDEV_ENUM_FRAME_SIZE
VIDIOC_SUBDEV_ENUM_MBUS_CODE
VIDIOC_SUBDEV_G_CROP, VIDIOC_SUBDEV_S_CROP
VIDIOC_SUBDEV_G_FMT, VIDIOC_SUBDEV_S_FMT
VIDIOC_SUBDEV_G_FRAME_INTERVAL, VIDIOC_SUBDEV_S_FRAME_INTERVAL
VIDIOC_SUBDEV_G_SELECTION, VIDIOC_SUBDEV_S_SELECTION

Found with v4l2-compliance.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-subdev.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index c5639817db34..74fe8083cf26 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -260,6 +260,8 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (rval)
 			return rval;
 
+		memset(format->reserved, 0, sizeof(format->reserved));
+		memset(format->format.reserved, 0, sizeof(format->format.reserved));
 		return v4l2_subdev_call(sd, pad, get_fmt, subdev_fh->pad, format);
 	}
 
@@ -270,6 +272,8 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (rval)
 			return rval;
 
+		memset(format->reserved, 0, sizeof(format->reserved));
+		memset(format->format.reserved, 0, sizeof(format->format.reserved));
 		return v4l2_subdev_call(sd, pad, set_fmt, subdev_fh->pad, format);
 	}
 
@@ -281,6 +285,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (rval)
 			return rval;
 
+		memset(crop->reserved, 0, sizeof(crop->reserved));
 		memset(&sel, 0, sizeof(sel));
 		sel.which = crop->which;
 		sel.pad = crop->pad;
@@ -298,6 +303,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		struct v4l2_subdev_crop *crop = arg;
 		struct v4l2_subdev_selection sel;
 
+		memset(crop->reserved, 0, sizeof(crop->reserved));
 		rval = check_crop(sd, crop);
 		if (rval)
 			return rval;
@@ -326,6 +332,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (code->pad >= sd->entity.num_pads)
 			return -EINVAL;
 
+		memset(code->reserved, 0, sizeof(code->reserved));
 		return v4l2_subdev_call(sd, pad, enum_mbus_code, subdev_fh->pad,
 					code);
 	}
@@ -340,6 +347,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (fse->pad >= sd->entity.num_pads)
 			return -EINVAL;
 
+		memset(fse->reserved, 0, sizeof(fse->reserved));
 		return v4l2_subdev_call(sd, pad, enum_frame_size, subdev_fh->pad,
 					fse);
 	}
@@ -350,6 +358,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (fi->pad >= sd->entity.num_pads)
 			return -EINVAL;
 
+		memset(fi->reserved, 0, sizeof(fi->reserved));
 		return v4l2_subdev_call(sd, video, g_frame_interval, arg);
 	}
 
@@ -359,6 +368,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (fi->pad >= sd->entity.num_pads)
 			return -EINVAL;
 
+		memset(fi->reserved, 0, sizeof(fi->reserved));
 		return v4l2_subdev_call(sd, video, s_frame_interval, arg);
 	}
 
@@ -372,6 +382,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (fie->pad >= sd->entity.num_pads)
 			return -EINVAL;
 
+		memset(fie->reserved, 0, sizeof(fie->reserved));
 		return v4l2_subdev_call(sd, pad, enum_frame_interval, subdev_fh->pad,
 					fie);
 	}
@@ -383,6 +394,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (rval)
 			return rval;
 
+		memset(sel->reserved, 0, sizeof(sel->reserved));
 		return v4l2_subdev_call(
 			sd, pad, get_selection, subdev_fh->pad, sel);
 	}
@@ -394,6 +406,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (rval)
 			return rval;
 
+		memset(sel->reserved, 0, sizeof(sel->reserved));
 		return v4l2_subdev_call(
 			sd, pad, set_selection, subdev_fh->pad, sel);
 	}
-- 
2.15.1
