Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.75]:54643 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932517AbcEKPkW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 May 2016 11:40:22 -0400
From: Alban Bedel <alban.bedel@avionic-design.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Bryan Wu <cooloney@gmail.com>, linux-kernel@vger.kernel.org,
	Alban Bedel <alban.bedel@avionic-design.de>
Subject: [PATCH] [media] v4l2-async: Always unregister the subdev on failure
Date: Wed, 11 May 2016 17:40:01 +0200
Message-Id: <1462981201-14768-1-git-send-email-alban.bedel@avionic-design.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In v4l2_async_test_notify() if the registered_async callback or the
complete notifier returns an error the subdev is not unregistered.
This leave paths where v4l2_async_register_subdev() can fail but
leave the subdev still registered.

Add the required calls to v4l2_device_unregister_subdev() to plug
these holes.

Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
---
 drivers/media/v4l2-core/v4l2-async.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index ceb28d4..43393f8 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -121,13 +121,19 @@ static int v4l2_async_test_notify(struct v4l2_async_notifier *notifier,
 
 	ret = v4l2_subdev_call(sd, core, registered_async);
 	if (ret < 0 && ret != -ENOIOCTLCMD) {
+		v4l2_device_unregister_subdev(sd);
 		if (notifier->unbind)
 			notifier->unbind(notifier, sd, asd);
 		return ret;
 	}
 
-	if (list_empty(&notifier->waiting) && notifier->complete)
-		return notifier->complete(notifier);
+	if (list_empty(&notifier->waiting) && notifier->complete) {
+		ret = notifier->complete(notifier);
+		if (ret < 0) {
+			v4l2_device_unregister_subdev(sd);
+			return ret;
+		}
+	}
 
 	return 0;
 }
-- 
2.8.2

