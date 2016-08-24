Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:54066 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753057AbcHXN5D (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Aug 2016 09:57:03 -0400
From: Alban Bedel <alban.bedel@avionic-design.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Alban Bedel <alban.bedel@avionic-design.de>
Subject: [PATCH v2] [media] v4l2-async: Always unregister the subdev on failure
Date: Wed, 24 Aug 2016 15:49:48 +0200
Message-Id: <20160824134948.21607-1-alban.bedel@avionic-design.de>
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
Changelog:
v2: * Added the missing unbind() calls as suggested by Javier.
---
 drivers/media/v4l2-core/v4l2-async.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index ceb28d47c3f9..abe512d0b4cb 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -113,23 +113,28 @@ static int v4l2_async_test_notify(struct v4l2_async_notifier *notifier,
 	list_move(&sd->async_list, &notifier->done);
 
 	ret = v4l2_device_register_subdev(notifier->v4l2_dev, sd);
-	if (ret < 0) {
-		if (notifier->unbind)
-			notifier->unbind(notifier, sd, asd);
-		return ret;
-	}
+	if (ret < 0)
+		goto err_subdev_register;
 
 	ret = v4l2_subdev_call(sd, core, registered_async);
-	if (ret < 0 && ret != -ENOIOCTLCMD) {
-		if (notifier->unbind)
-			notifier->unbind(notifier, sd, asd);
-		return ret;
+	if (ret < 0 && ret != -ENOIOCTLCMD)
+		goto err_subdev_call;
+
+	if (list_empty(&notifier->waiting) && notifier->complete) {
+		ret = notifier->complete(notifier);
+		if (ret < 0)
+			goto err_subdev_call;
 	}
 
-	if (list_empty(&notifier->waiting) && notifier->complete)
-		return notifier->complete(notifier);
-
 	return 0;
+
+err_subdev_call:
+	v4l2_device_unregister_subdev(sd);
+err_subdev_register:
+	if (notifier->unbind)
+		notifier->unbind(notifier, sd, asd);
+
+	return ret;
 }
 
 static void v4l2_async_cleanup(struct v4l2_subdev *sd)
-- 
2.9.3

