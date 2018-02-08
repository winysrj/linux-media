Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:44719 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752028AbeBHIhB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Feb 2018 03:37:01 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 05/15] v4l2-subdev: clear reserved fields
Date: Thu,  8 Feb 2018 09:36:45 +0100
Message-Id: <20180208083655.32248-6-hverkuil@xs4all.nl>
In-Reply-To: <20180208083655.32248-1-hverkuil@xs4all.nl>
References: <20180208083655.32248-1-hverkuil@xs4all.nl>
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
---
 drivers/media/v4l2-core/v4l2-subdev.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index be7a19272614..6cabfa32d2ed 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -276,6 +276,8 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (rval)
 			return rval;
 
+		memset(format->reserved, 0, sizeof(format->reserved));
+		memset(format->format.reserved, 0, sizeof(format->format.reserved));
 		return v4l2_subdev_call(sd, pad, get_fmt, subdev_fh->pad, format);
 	}
 
@@ -286,6 +288,8 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (rval)
 			return rval;
 
+		memset(format->reserved, 0, sizeof(format->reserved));
+		memset(format->format.reserved, 0, sizeof(format->format.reserved));
 		return v4l2_subdev_call(sd, pad, set_fmt, subdev_fh->pad, format);
 	}
 
@@ -293,6 +297,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		struct v4l2_subdev_crop *crop = arg;
 		struct v4l2_subdev_selection sel;
 
+		memset(crop->reserved, 0, sizeof(crop->reserved));
 		rval = check_crop(sd, crop);
 		if (rval)
 			return rval;
@@ -318,6 +323,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (rval)
 			return rval;
 
+		memset(crop->reserved, 0, sizeof(crop->reserved));
 		memset(&sel, 0, sizeof(sel));
 		sel.which = crop->which;
 		sel.pad = crop->pad;
@@ -342,6 +348,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (code->pad >= sd->entity.num_pads)
 			return -EINVAL;
 
+		memset(code->reserved, 0, sizeof(code->reserved));
 		return v4l2_subdev_call(sd, pad, enum_mbus_code, subdev_fh->pad,
 					code);
 	}
@@ -356,6 +363,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (fse->pad >= sd->entity.num_pads)
 			return -EINVAL;
 
+		memset(fse->reserved, 0, sizeof(fse->reserved));
 		return v4l2_subdev_call(sd, pad, enum_frame_size, subdev_fh->pad,
 					fse);
 	}
@@ -366,6 +374,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (fi->pad >= sd->entity.num_pads)
 			return -EINVAL;
 
+		memset(fi->reserved, 0, sizeof(fi->reserved));
 		return v4l2_subdev_call(sd, video, g_frame_interval, arg);
 	}
 
@@ -375,6 +384,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (fi->pad >= sd->entity.num_pads)
 			return -EINVAL;
 
+		memset(fi->reserved, 0, sizeof(fi->reserved));
 		return v4l2_subdev_call(sd, video, s_frame_interval, arg);
 	}
 
@@ -388,6 +398,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (fie->pad >= sd->entity.num_pads)
 			return -EINVAL;
 
+		memset(fie->reserved, 0, sizeof(fie->reserved));
 		return v4l2_subdev_call(sd, pad, enum_frame_interval, subdev_fh->pad,
 					fie);
 	}
@@ -399,6 +410,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (rval)
 			return rval;
 
+		memset(sel->reserved, 0, sizeof(sel->reserved));
 		return v4l2_subdev_call(
 			sd, pad, get_selection, subdev_fh->pad, sel);
 	}
@@ -410,6 +422,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (rval)
 			return rval;
 
+		memset(sel->reserved, 0, sizeof(sel->reserved));
 		return v4l2_subdev_call(
 			sd, pad, set_selection, subdev_fh->pad, sel);
 	}
-- 
2.15.1
