Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58153 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784Ab1BNMU7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 07:20:59 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [PATCH v7 4/6] v4l: subdev: Uninline the v4l2_subdev_init function
Date: Mon, 14 Feb 2011 13:20:57 +0100
Message-Id: <1297686059-9622-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1297686059-9622-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1297686059-9622-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The function isn't small or performance sensitive enough to be inlined.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/v4l2-subdev.c |   41 +++++++++++++++++++++++++-----------
 include/media/v4l2-subdev.h       |   15 +-----------
 2 files changed, 30 insertions(+), 26 deletions(-)

diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
index 4014cb6..6cf7664 100644
--- a/drivers/media/video/v4l2-subdev.c
+++ b/drivers/media/video/v4l2-subdev.c
@@ -1,22 +1,23 @@
 /*
- *  V4L2 subdevice support.
+ * V4L2 sub-device
  *
- *  Copyright (C) 2010 Nokia Corporation
+ * Copyright (C) 2010 Nokia Corporation
  *
- *  Contact: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ * Contact: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *	    Sakari Ailus <sakari.ailus@iki.fi>
  *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation.
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
  *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
  *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 #include <linux/types.h>
@@ -58,3 +59,17 @@ const struct v4l2_file_operations v4l2_subdev_fops = {
 	.unlocked_ioctl = subdev_ioctl,
 	.release = subdev_close,
 };
+
+void v4l2_subdev_init(struct v4l2_subdev *sd, const struct v4l2_subdev_ops *ops)
+{
+	INIT_LIST_HEAD(&sd->list);
+	BUG_ON(!ops);
+	sd->ops = ops;
+	sd->v4l2_dev = NULL;
+	sd->flags = 0;
+	sd->name[0] = '\0';
+	sd->grp_id = 0;
+	sd->dev_priv = NULL;
+	sd->host_priv = NULL;
+}
+EXPORT_SYMBOL(v4l2_subdev_init);
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 2f859d5..2e4bef47 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -485,19 +485,8 @@ static inline void *v4l2_get_subdev_hostdata(const struct v4l2_subdev *sd)
 	return sd->host_priv;
 }
 
-static inline void v4l2_subdev_init(struct v4l2_subdev *sd,
-					const struct v4l2_subdev_ops *ops)
-{
-	INIT_LIST_HEAD(&sd->list);
-	BUG_ON(!ops);
-	sd->ops = ops;
-	sd->v4l2_dev = NULL;
-	sd->flags = 0;
-	sd->name[0] = '\0';
-	sd->grp_id = 0;
-	sd->dev_priv = NULL;
-	sd->host_priv = NULL;
-}
+void v4l2_subdev_init(struct v4l2_subdev *sd,
+		      const struct v4l2_subdev_ops *ops);
 
 /* Call an ops of a v4l2_subdev, doing the right checks against
    NULL pointers.
-- 
1.7.3.4

