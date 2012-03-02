Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:27995 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932115Ab2CBRcx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Mar 2012 12:32:53 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, dacohen@gmail.com,
	snjw23@gmail.com, andriy.shevchenko@linux.intel.com,
	t.stanislaws@samsung.com, tuukkat76@gmail.com,
	k.debski@samsung.com, riverful@gmail.com, hverkuil@xs4all.nl,
	teturtia@gmail.com
Subject: [PATCH v4 07/34] v4l: Support s_crop and g_crop through s/g_selection
Date: Fri,  2 Mar 2012 19:30:15 +0200
Message-Id: <1330709442-16654-7-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20120302173219.GA15695@valkosipuli.localdomain>
References: <20120302173219.GA15695@valkosipuli.localdomain>
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
index 7d22538..eda34cd 100644
--- a/drivers/media/video/v4l2-subdev.c
+++ b/drivers/media/video/v4l2-subdev.c
@@ -228,6 +228,8 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 
 	case VIDIOC_SUBDEV_G_CROP: {
 		struct v4l2_subdev_crop *crop = arg;
+		struct v4l2_subdev_selection sel;
+		int rval;
 
 		if (crop->which != V4L2_SUBDEV_FORMAT_TRY &&
 		    crop->which != V4L2_SUBDEV_FORMAT_ACTIVE)
@@ -236,11 +238,27 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
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
@@ -249,7 +267,22 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
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

