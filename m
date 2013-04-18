Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:58969 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936362Ab3DRVf5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Apr 2013 17:35:57 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 04/24] V4L2: fix Oops on rmmod path
Date: Thu, 18 Apr 2013 23:35:25 +0200
Message-Id: <1366320945-21591-5-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
References: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_async_cleanup() clears the sd->dev pointer, avoid dereferencing it in
v4l2_async_unregister().

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/v4l2-core/v4l2-async.c |   18 ++++++------------
 1 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 98db2e0..5d6b428 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -123,16 +123,6 @@ static void v4l2_async_cleanup(struct v4l2_async_subdev_list *asdl)
 	sd->dev = NULL;
 }
 
-static void v4l2_async_unregister(struct v4l2_async_subdev_list *asdl)
-{
-	struct v4l2_subdev *sd = v4l2_async_to_subdev(asdl);
-
-	v4l2_async_cleanup(asdl);
-
-	/* If we handled USB devices, we'd have to lock the parent too */
-	device_release_driver(sd->dev);
-}
-
 int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
 				 struct v4l2_async_notifier *notifier)
 {
@@ -203,9 +193,13 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
 	list_for_each_entry_safe(asdl, tmp, &notifier->done, list) {
 		if (dev) {
 			struct v4l2_subdev *sd = v4l2_async_to_subdev(asdl);
-			dev[i++] = get_device(sd->dev);
+			dev[i] = get_device(sd->dev);
 		}
-		v4l2_async_unregister(asdl);
+		v4l2_async_cleanup(asdl);
+
+		/* If we handled USB devices, we'd have to lock the parent too */
+		if (dev)
+			device_release_driver(dev[i++]);
 
 		if (notifier->unbind)
 			notifier->unbind(notifier, asdl);
-- 
1.7.2.5

