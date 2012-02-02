Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:43158 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754226Ab2BBXzD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Feb 2012 18:55:03 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, dacohen@gmail.com,
	snjw23@gmail.com, andriy.shevchenko@linux.intel.com,
	t.stanislaws@samsung.com, tuukkat76@gmail.com,
	k.debski@samsung.com, riverful@gmail.com, hverkuil@xs4all.nl,
	teturtia@gmail.com
Subject: [PATCH v2 05/31] v4l: Support s_crop and g_crop through s/g_selection
Date: Fri,  3 Feb 2012 01:54:25 +0200
Message-Id: <1328226891-8968-5-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20120202235231.GC841@valkosipuli.localdomain>
References: <20120202235231.GC841@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fall back to s_selection if s_crop isn't implemented by a driver. Same for
g_selection / g_crop.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/v4l2-subdev.c |   37 +++++++++++++++++++++++++++++++++++--
 1 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
index 6bc5039..2c8d467 100644
--- a/drivers/media/video/v4l2-subdev.c
+++ b/drivers/media/video/v4l2-subdev.c
@@ -220,6 +220,8 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 
 	case VIDIOC_SUBDEV_G_CROP: {
 		struct v4l2_subdev_crop *crop = arg;
+		struct v4l2_subdev_selection sel;
+		int rval;
 
 		if (crop->which != V4L2_SUBDEV_FORMAT_TRY &&
 		    crop->which != V4L2_SUBDEV_FORMAT_ACTIVE)
@@ -228,11 +230,27 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (crop->pad >= sd->entity.num_pads)
 			return -EINVAL;
 
-		return v4l2_subdev_call(sd, pad, get_crop, subdev_fh, crop);
+		rval = v4l2_subdev_call(sd, pad, get_crop, subdev_fh, crop);
+		if (rval != -ENOIOCTLCMD)
+			return rval;
+
+		memset(&sel, 0, sizeof(sel));
+		sel.which = crop->which;
+		sel.pad = crop->pad;
+		sel.target = V4L2_SUBDEV_SEL_TGT_CROP_ACTIVE;
+
+		rval = v4l2_subdev_call(
+			sd, pad, get_selection, subdev_fh, &sel);
+
+		crop->rect = sel.r;
+
+		return rval;
 	}
 
 	case VIDIOC_SUBDEV_S_CROP: {
 		struct v4l2_subdev_crop *crop = arg;
+		struct v4l2_subdev_selection sel;
+		int rval;
 
 		if (crop->which != V4L2_SUBDEV_FORMAT_TRY &&
 		    crop->which != V4L2_SUBDEV_FORMAT_ACTIVE)
@@ -241,7 +259,22 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (crop->pad >= sd->entity.num_pads)
 			return -EINVAL;
 
-		return v4l2_subdev_call(sd, pad, set_crop, subdev_fh, crop);
+		rval = v4l2_subdev_call(sd, pad, set_crop, subdev_fh, crop);
+		if (rval != -ENOIOCTLCMD)
+			return rval;
+
+		memset(&sel, 0, sizeof(sel));
+		sel.which = crop->which;
+		sel.pad = crop->pad;
+		sel.target = V4L2_SUBDEV_SEL_TGT_CROP_ACTIVE;
+		sel.r = crop->rect;
+
+		rval = v4l2_subdev_call(
+			sd, pad, set_selection, subdev_fh, &sel);
+
+		crop->rect = sel.r;
+
+		return rval;
 	}
 
 	case VIDIOC_SUBDEV_ENUM_MBUS_CODE: {
-- 
1.7.2.5

