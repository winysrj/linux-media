Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56464 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455AbcESXke (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 May 2016 19:40:34 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH v4 4/6] v4l: vsp1: Don't register media device when userspace API is disabled
Date: Fri, 20 May 2016 02:40:30 +0300
Message-Id: <1463701232-22008-5-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1463701232-22008-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1463701232-22008-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The media device doesn't need to be exposed to userspace when the VSP is
fully controlled by the DU driver. Don't register it in that case.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drv.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index d369fad797aa..c7e28cc97bdc 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -218,7 +218,8 @@ static void vsp1_destroy_entities(struct vsp1_device *vsp1)
 	}
 
 	v4l2_device_unregister(&vsp1->v4l2_dev);
-	media_device_unregister(&vsp1->media_dev);
+	if (vsp1->info->uapi)
+		media_device_unregister(&vsp1->media_dev);
 	media_device_cleanup(&vsp1->media_dev);
 
 	if (!vsp1->info->uapi)
@@ -403,14 +404,15 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 	/* Register subdev nodes if the userspace API is enabled or initialize
 	 * the DRM pipeline otherwise.
 	 */
-	if (vsp1->info->uapi)
+	if (vsp1->info->uapi) {
 		ret = v4l2_device_register_subdev_nodes(&vsp1->v4l2_dev);
-	else
-		ret = vsp1_drm_init(vsp1);
-	if (ret < 0)
-		goto done;
+		if (ret < 0)
+			goto done;
 
-	ret = media_device_register(mdev);
+		ret = media_device_register(mdev);
+	} else {
+		ret = vsp1_drm_init(vsp1);
+	}
 
 done:
 	if (ret < 0)
-- 
2.7.3

