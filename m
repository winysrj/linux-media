Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bn1blp0181.outbound.protection.outlook.com ([207.46.163.181]:32471
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751060AbaD3EiF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Apr 2014 00:38:05 -0400
From: Liu Ying <Ying.Liu@freescale.com>
To: <linux-media@vger.kernel.org>
CC: <m.chehab@samsung.com>, <a.hajda@samsung.com>,
	<laurent.pinchart@ideasonboard.com>, <sakari.ailus@iki.fi>,
	<s.nawrocki@samsung.com>, <hans.verkuil@cisco.com>
Subject: [PATCH] [media] v4l2-device: fix potential NULL pointer dereference for subdev unregister path
Date: Wed, 30 Apr 2014 12:25:21 +0800
Message-ID: <1398831921-5652-1-git-send-email-Ying.Liu@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The pointer 'sd->v4l2_dev' is likely to be NULL and dereferenced in the subdev
unregister path.  The issue should happen if CONFIG_MEDIA_CONTROLLER is defined.

This patch fixes the issue by setting the pointer to be NULL after it will not
be derefereneced any more in the path.

Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org
Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
 drivers/media/v4l2-core/v4l2-device.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
index 02d1b63..d98d96f 100644
--- a/drivers/media/v4l2-core/v4l2-device.c
+++ b/drivers/media/v4l2-core/v4l2-device.c
@@ -271,7 +271,6 @@ void v4l2_device_unregister_subdev(struct v4l2_subdev *sd)
 
 	if (sd->internal_ops && sd->internal_ops->unregistered)
 		sd->internal_ops->unregistered(sd);
-	sd->v4l2_dev = NULL;
 
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	if (v4l2_dev->mdev) {
@@ -279,6 +278,7 @@ void v4l2_device_unregister_subdev(struct v4l2_subdev *sd)
 		media_device_unregister_entity(&sd->entity);
 	}
 #endif
+	v4l2_dev = NULL;
 	video_unregister_device(sd->devnode);
 	module_put(sd->owner);
 }
-- 
1.7.9.5

