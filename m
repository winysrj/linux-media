Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:54985 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936487Ab3DRVf7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Apr 2013 17:35:59 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 20/24] V4L2: add a subdev pointer to struct v4l2_subdev_fh
Date: Thu, 18 Apr 2013 23:35:41 +0200
Message-Id: <1366320945-21591-21-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
References: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is useful for cases, when there's no video-device associated with a
V4L2 file-handle, e.g. in case of a dummy file-handle.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/v4l2-core/v4l2-subdev.c |    1 +
 include/media/v4l2-subdev.h           |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index 996c248..ec9f0d8 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -34,6 +34,7 @@
 
 static int subdev_fh_init(struct v4l2_subdev_fh *fh, struct v4l2_subdev *sd)
 {
+	fh->subdev = sd;
 #if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
 	fh->pad = kzalloc(sizeof(*fh->pad) * sd->entity.num_pads, GFP_KERNEL);
 	if (fh->pad == NULL)
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 4424a7c..0581781 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -626,6 +626,7 @@ struct v4l2_subdev_try_buf {
 
 struct v4l2_subdev_fh {
 	struct v4l2_fh vfh;
+	struct v4l2_subdev *subdev;
 #if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
 	struct v4l2_subdev_try_buf *pad;
 #endif
@@ -640,8 +641,7 @@ struct v4l2_subdev_fh {
 	v4l2_subdev_get_try_##fun_name(struct v4l2_subdev_fh *fh,	\
 				       unsigned int pad)		\
 	{								\
-		BUG_ON(pad >= vdev_to_v4l2_subdev(			\
-					fh->vfh.vdev)->entity.num_pads); \
+		BUG_ON(pad >= fh->subdev->entity.num_pads);		\
 		return &fh->pad[pad].field_name;			\
 	}
 
-- 
1.7.2.5

