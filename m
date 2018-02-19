Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:60134 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752481AbeBSKiM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 05:38:12 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 04/15] v4l2-subdev: clear reserved fields
Date: Mon, 19 Feb 2018 11:37:55 +0100
Message-Id: <20180219103806.17032-5-hverkuil@xs4all.nl>
In-Reply-To: <20180219103806.17032-1-hverkuil@xs4all.nl>
References: <20180219103806.17032-1-hverkuil@xs4all.nl>
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
index b14c5e1705ca..168ecb4bed23 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -284,6 +284,8 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (rval)
 			return rval;
 
+		memset(format->reserved, 0, sizeof(format->reserved));
+		memset(format->format.reserved, 0, sizeof(format->format.reserved));
 		return v4l2_subdev_call(sd, pad, get_fmt, subdev_fh->pad, format);
 	}
 
@@ -294,6 +296,8 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (rval)
 			return rval;
 
+		memset(format->reserved, 0, sizeof(format->reserved));
+		memset(format->format.reserved, 0, sizeof(format->format.reserved));
 		return v4l2_subdev_call(sd, pad, set_fmt, subdev_fh->pad, format);
 	}
 
@@ -301,6 +305,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		struct v4l2_subdev_crop *crop = arg;
 		struct v4l2_subdev_selection sel;
 
+		memset(crop->reserved, 0, sizeof(crop->reserved));
 		rval = check_crop(sd, crop);
 		if (rval)
 			return rval;
@@ -326,6 +331,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (rval)
 			return rval;
 
+		memset(crop->reserved, 0, sizeof(crop->reserved));
 		memset(&sel, 0, sizeof(sel));
 		sel.which = crop->which;
 		sel.pad = crop->pad;
@@ -350,6 +356,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (code->pad >= sd->entity.num_pads)
 			return -EINVAL;
 
+		memset(code->reserved, 0, sizeof(code->reserved));
 		return v4l2_subdev_call(sd, pad, enum_mbus_code, subdev_fh->pad,
 					code);
 	}
@@ -364,6 +371,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (fse->pad >= sd->entity.num_pads)
 			return -EINVAL;
 
+		memset(fse->reserved, 0, sizeof(fse->reserved));
 		return v4l2_subdev_call(sd, pad, enum_frame_size, subdev_fh->pad,
 					fse);
 	}
@@ -374,6 +382,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (fi->pad >= sd->entity.num_pads)
 			return -EINVAL;
 
+		memset(fi->reserved, 0, sizeof(fi->reserved));
 		return v4l2_subdev_call(sd, video, g_frame_interval, arg);
 	}
 
@@ -383,6 +392,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (fi->pad >= sd->entity.num_pads)
 			return -EINVAL;
 
+		memset(fi->reserved, 0, sizeof(fi->reserved));
 		return v4l2_subdev_call(sd, video, s_frame_interval, arg);
 	}
 
@@ -396,6 +406,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (fie->pad >= sd->entity.num_pads)
 			return -EINVAL;
 
+		memset(fie->reserved, 0, sizeof(fie->reserved));
 		return v4l2_subdev_call(sd, pad, enum_frame_interval, subdev_fh->pad,
 					fie);
 	}
@@ -407,6 +418,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (rval)
 			return rval;
 
+		memset(sel->reserved, 0, sizeof(sel->reserved));
 		return v4l2_subdev_call(
 			sd, pad, get_selection, subdev_fh->pad, sel);
 	}
@@ -418,6 +430,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (rval)
 			return rval;
 
+		memset(sel->reserved, 0, sizeof(sel->reserved));
 		return v4l2_subdev_call(
 			sd, pad, set_selection, subdev_fh->pad, sel);
 	}
-- 
2.16.1
