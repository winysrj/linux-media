Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44864 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751223AbdAOTFV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 15 Jan 2017 14:05:21 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH] v4l: subdev: Clean up properly in subdev devnode registration error path
Date: Sun, 15 Jan 2017 21:05:30 +0200
Message-Id: <20170115190530.19311-1-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Set the subdev devnode pointer right after registration to ensure that
later errors won't skip the subdev when unregistering all devnodes.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/v4l2-core/v4l2-device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
index 62bbed76dbbc..f364cc1b521d 100644
--- a/drivers/media/v4l2-core/v4l2-device.c
+++ b/drivers/media/v4l2-core/v4l2-device.c
@@ -253,6 +253,7 @@ int v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev)
 			kfree(vdev);
 			goto clean_up;
 		}
+		sd->devnode = vdev;
 #if defined(CONFIG_MEDIA_CONTROLLER)
 		sd->entity.info.dev.major = VIDEO_MAJOR;
 		sd->entity.info.dev.minor = vdev->minor;
@@ -270,7 +271,6 @@ int v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev)
 			}
 		}
 #endif
-		sd->devnode = vdev;
 	}
 	return 0;
 
-- 
Regards,

Laurent Pinchart

