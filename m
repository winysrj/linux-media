Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36699 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757249Ab3HGKkz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Aug 2013 06:40:55 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] V4L: async: Make sure subdevs are stored in a list before being moved
Date: Wed,  7 Aug 2013 12:41:55 +0200
Message-Id: <1375872115-32505-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Subdevices have an async_list field used to store them in the global
list of subdevices or in the notifier done lists. List entries are moved
from the former to the latter in v4l2_async_test_notify() using
list_move(). However, v4l2_async_test_notify() can be called right away
when the subdev is registered with v4l2_async_register_subdev(), in
which case the entry is not stored in any list.

Although this behaviour is not correct, the code doesn't crash at the
moment as the async_list field is initialized as a list head, despite
being a list entry.

Add the subdev to the global subdevs list a registration time before
matching them with the notifiers to make sure the list_move() call will
get a subdev that is stored in a list, and remove the list head
initialization for the subdev async_list field.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/v4l2-core/v4l2-async.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index b350ab9..4485dfe 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -122,7 +122,7 @@ static void v4l2_async_cleanup(struct v4l2_subdev *sd)
 {
 	v4l2_device_unregister_subdev(sd);
 	/* Subdevice driver will reprobe and put the subdev back onto the list */
-	list_del_init(&sd->async_list);
+	list_del(&sd->async_list);
 	sd->asd = NULL;
 	sd->dev = NULL;
 }
@@ -238,7 +238,11 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
 
 	mutex_lock(&list_lock);
 
-	INIT_LIST_HEAD(&sd->async_list);
+	/*
+	 * Add the subdev to the global subdevs list. It will be moved to the
+	 * notifier done list by v4l2_async_test_notify().
+	 */
+	list_add(&sd->async_list, &subdev_list);
 
 	list_for_each_entry(notifier, &notifier_list, list) {
 		struct v4l2_async_subdev *asd = v4l2_async_belongs(notifier, sd);
@@ -249,9 +253,6 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
 		}
 	}
 
-	/* None matched, wait for hot-plugging */
-	list_add(&sd->async_list, &subdev_list);
-
 	mutex_unlock(&list_lock);
 
 	return 0;
-- 
Regards,

Laurent Pinchart

