Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:30537 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab3FJO5L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jun 2013 10:57:11 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MO600EQDMVAH690@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 10 Jun 2013 23:57:10 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	kyungmin.park@samsung.com, a.hajda@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC PATCH v3 2/2] V4L: Remove all links of a media entity when
 unregistering subdev
Date: Mon, 10 Jun 2013 16:54:30 +0200
Message-id: <1370876070-23699-4-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1370876070-23699-1-git-send-email-s.nawrocki@samsung.com>
References: <1370876070-23699-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove all links of the subdev's media entity after internal_ops
'unregistered' call and right before unregistering the entity from
a media device.

It is assumed here that an unregistered (orphan) media entity cannot
have links to other entities registered to a media device.

It is also assumed the media links should be created/removed with
the media graph's mutex held.

The above implies that the caller of v4l2_device_unregister_subdev()
must not hold the graph's mutex.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/v4l2-core/v4l2-device.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
index 8ed5da2..2dbfebc 100644
--- a/drivers/media/v4l2-core/v4l2-device.c
+++ b/drivers/media/v4l2-core/v4l2-device.c
@@ -269,8 +269,10 @@ void v4l2_device_unregister_subdev(struct v4l2_subdev *sd)
 	sd->v4l2_dev = NULL;
 
 #if defined(CONFIG_MEDIA_CONTROLLER)
-	if (v4l2_dev->mdev)
+	if (v4l2_dev->mdev) {
+		media_entity_remove_links(&sd->entity);
 		media_device_unregister_entity(&sd->entity);
+	}
 #endif
 	video_unregister_device(sd->devnode);
 	module_put(sd->owner);
-- 
1.7.9.5

