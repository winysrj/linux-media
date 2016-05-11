Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.135]:53947 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932202AbcEKJYg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 May 2016 05:24:36 -0400
From: Alban Bedel <alban.bedel@avionic-design.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-kernel@vger.kernel.org,
	Alban Bedel <alban.bedel@avionic-design.de>
Subject: [PATCH v2] [media] v4l2-async: Pass the v4l2_async_subdev to the unbind callback
Date: Wed, 11 May 2016 11:24:04 +0200
Message-Id: <1462958644-3521-1-git-send-email-alban.bedel@avionic-design.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_async_cleanup() is always called before calling the unbind()
callback. However v4l2_async_cleanup() clears the asd member, so when
calling the unbind() callback the v4l2_async_subdev is always NULL. To
fix this save the asd before calling v4l2_async_cleanup().

Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
---
 drivers/media/v4l2-core/v4l2-async.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index a4b224d..ceb28d4 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -220,6 +220,7 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
 	list_del(&notifier->list);
 
 	list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
+		struct v4l2_async_subdev *asd = sd->asd;
 		struct device *d;
 
 		d = get_device(sd->dev);
@@ -230,7 +231,7 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
 		device_release_driver(d);
 
 		if (notifier->unbind)
-			notifier->unbind(notifier, sd, sd->asd);
+			notifier->unbind(notifier, sd, asd);
 
 		/*
 		 * Store device at the device cache, in order to call
@@ -313,6 +314,7 @@ EXPORT_SYMBOL(v4l2_async_register_subdev);
 void v4l2_async_unregister_subdev(struct v4l2_subdev *sd)
 {
 	struct v4l2_async_notifier *notifier = sd->notifier;
+	struct v4l2_async_subdev *asd = sd->asd;
 
 	if (!sd->asd) {
 		if (!list_empty(&sd->async_list))
@@ -327,7 +329,7 @@ void v4l2_async_unregister_subdev(struct v4l2_subdev *sd)
 	v4l2_async_cleanup(sd);
 
 	if (notifier->unbind)
-		notifier->unbind(notifier, sd, sd->asd);
+		notifier->unbind(notifier, sd, asd);
 
 	mutex_unlock(&list_lock);
 }
-- 
2.8.2

