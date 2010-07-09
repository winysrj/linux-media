Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:40684 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757341Ab0GIPcL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Jul 2010 11:32:11 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [RFC/PATCH v2 4/7] v4l: subdev: Uninline the v4l2_subdev_init function
Date: Fri,  9 Jul 2010 17:31:49 +0200
Message-Id: <1278689512-30849-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1278689512-30849-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1278689512-30849-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The function isn't small or performance sensitive enough to be inlined.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/v4l2-subdev.c |   14 ++++++++++++++
 include/media/v4l2-subdev.h       |   15 ++-------------
 2 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
index f016376..37142ae 100644
--- a/drivers/media/video/v4l2-subdev.c
+++ b/drivers/media/video/v4l2-subdev.c
@@ -63,3 +63,17 @@ const struct v4l2_file_operations v4l2_subdev_fops = {
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
+	sd->priv = NULL;
+	sd->initialized = 1;
+}
+EXPORT_SYMBOL(v4l2_subdev_init);
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index dc0ccd3..9ee45c8 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -444,19 +444,8 @@ static inline void *v4l2_get_subdevdata(const struct v4l2_subdev *sd)
 	return sd->priv;
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
-	sd->priv = NULL;
-	sd->initialized = 1;
-}
+void v4l2_subdev_init(struct v4l2_subdev *sd,
+		      const struct v4l2_subdev_ops *ops);
 
 /* Call an ops of a v4l2_subdev, doing the right checks against
    NULL pointers.
-- 
1.7.1

