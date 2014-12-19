Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:48532 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752379AbaLSOwA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 09:52:00 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, g.liakhovetski@gmx.de,
	prabhakar.csengg@gmail.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 02/11] v4l2-subdev: drop get/set_crop pad ops
Date: Fri, 19 Dec 2014 15:51:27 +0100
Message-Id: <1419000696-25202-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1419000696-25202-1-git-send-email-hverkuil@xs4all.nl>
References: <1419000696-25202-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Drop the duplicate get/set_crop pad ops and only use get/set_selection.
It makes no sense to have two duplicate ops in the internal subdev API.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/v4l2-core/v4l2-subdev.c | 8 --------
 include/media/v4l2-subdev.h           | 4 ----
 2 files changed, 12 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index 543631c..19a034e 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -283,10 +283,6 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (rval)
 			return rval;
 
-		rval = v4l2_subdev_call(sd, pad, get_crop, subdev_fh, crop);
-		if (rval != -ENOIOCTLCMD)
-			return rval;
-
 		memset(&sel, 0, sizeof(sel));
 		sel.which = crop->which;
 		sel.pad = crop->pad;
@@ -308,10 +304,6 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (rval)
 			return rval;
 
-		rval = v4l2_subdev_call(sd, pad, set_crop, subdev_fh, crop);
-		if (rval != -ENOIOCTLCMD)
-			return rval;
-
 		memset(&sel, 0, sizeof(sel));
 		sel.which = crop->which;
 		sel.pad = crop->pad;
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 5860292..b052184 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -503,10 +503,6 @@ struct v4l2_subdev_pad_ops {
 		       struct v4l2_subdev_format *format);
 	int (*set_fmt)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 		       struct v4l2_subdev_format *format);
-	int (*set_crop)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
-		       struct v4l2_subdev_crop *crop);
-	int (*get_crop)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
-		       struct v4l2_subdev_crop *crop);
 	int (*get_selection)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 			     struct v4l2_subdev_selection *sel);
 	int (*set_selection)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
-- 
2.1.3

