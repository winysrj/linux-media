Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62947 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab3FITmI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Jun 2013 15:42:08 -0400
Received: by mail-bk0-f46.google.com with SMTP id na10so2964123bkb.5
        for <linux-media@vger.kernel.org>; Sun, 09 Jun 2013 12:42:07 -0700 (PDT)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	a.hajda@samsung.com, hj210.choi@samsung.com, s.nawrocki@samsung.com
Subject: [RFC PATCH v2 2/2] V4L: Remove all links of a media entity when unregistering subdev
Date: Sun,  9 Jun 2013 21:41:39 +0200
Message-Id: <1370806899-17709-3-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1370806899-17709-1-git-send-email-s.nawrocki@samsung.com>
References: <1370806899-17709-1-git-send-email-s.nawrocki@samsung.com>
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
 1 files changed, 3 insertions(+), 1 deletions(-)

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
1.7.4.1

