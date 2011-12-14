Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:31136 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756662Ab1LNPJW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Dec 2011 10:09:22 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, snjw23@gmail.com,
	t.stanislaws@samsung.com, dacohen@gmail.com,
	andriy.shevchenko@linux.intel.com, g.liakhovetski@gmx.de,
	hverkuil@xs4all.nl
Subject: [RFC v2 2/3] v4l: Support s_crop and g_crop through s/g_selection
Date: Wed, 14 Dec 2011 17:09:05 +0200
Message-Id: <1323875346-16976-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20111214150846.GM1967@valkosipuli.localdomain>
References: <20111214150846.GM1967@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Revert to s_selection if s_crop isn't implemented by a driver. Same for
g_selection / g_crop.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/video/v4l2-subdev.c |   37 +++++++++++++++++++++++++++++++++++--
 1 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
index e8ae098..f8de551 100644
--- a/drivers/media/video/v4l2-subdev.c
+++ b/drivers/media/video/v4l2-subdev.c
@@ -226,6 +226,8 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 
 	case VIDIOC_SUBDEV_G_CROP: {
 		struct v4l2_subdev_crop *crop = arg;
+		struct v4l2_subdev_selection sel;
+		int rval;
 
 		if (crop->which != V4L2_SUBDEV_FORMAT_TRY &&
 		    crop->which != V4L2_SUBDEV_FORMAT_ACTIVE)
@@ -234,11 +236,27 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (crop->pad >= sd->entity.num_pads)
 			return -EINVAL;
 
-		return v4l2_subdev_call(sd, pad, get_crop, subdev_fh, crop);
+		rval = v4l2_subdev_call(sd, pad, get_crop, subdev_fh, crop);
+		if (rval != -ENOIOCTLCMD)
+			return rval;
+
+		memset(&sel, 0, sizeof(sel));
+		sel.which = V4L2_SUBDEV_FORMAT_ACTIVE;
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
@@ -247,7 +265,22 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (crop->pad >= sd->entity.num_pads)
 			return -EINVAL;
 
-		return v4l2_subdev_call(sd, pad, set_crop, subdev_fh, crop);
+		rval = v4l2_subdev_call(sd, pad, set_crop, subdev_fh, crop);
+		if (rval != -ENOIOCTLCMD)
+			return rval;
+
+		memset(&sel, 0, sizeof(sel));
+		sel.which = V4L2_SUBDEV_FORMAT_ACTIVE;
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

