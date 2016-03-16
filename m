Return-path: <linux-media-owner@vger.kernel.org>
Received: from [198.137.202.9] ([198.137.202.9]:39057 "EHLO
	bombadil.infradead.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S965880AbcCPMFC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2016 08:05:02 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	=?UTF-8?q?Rafael=20Louren=C3=A7o=20de=20Lima=20Chehab?=
	<chehabrafael@gmail.com>
Subject: [PATCH 3/5] [media] au0828: Unregister notifiers
Date: Wed, 16 Mar 2016 09:04:04 -0300
Message-Id: <cdba12a00adbecabb66a662982991178383917b2.1458129823.git.mchehab@osg.samsung.com>
In-Reply-To: <dba4d41bdfa6bb8dc51cb0f692102919b2b7c8b4.1458129823.git.mchehab@osg.samsung.com>
References: <dba4d41bdfa6bb8dc51cb0f692102919b2b7c8b4.1458129823.git.mchehab@osg.samsung.com>
In-Reply-To: <dba4d41bdfa6bb8dc51cb0f692102919b2b7c8b4.1458129823.git.mchehab@osg.samsung.com>
References: <dba4d41bdfa6bb8dc51cb0f692102919b2b7c8b4.1458129823.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If au0828 gets removed, we need to remove the notifiers.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-core.c | 34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 2fcd17d9b1a6..06da73f1ff22 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -131,21 +131,35 @@ static int recv_control_msg(struct au0828_dev *dev, u16 request, u32 value,
 	return status;
 }
 
+#ifdef CONFIG_MEDIA_CONTROLLER
+static void au0828_media_graph_notify(struct media_entity *new,
+				      void *notify_data);
+#endif
+
 static void au0828_unregister_media_device(struct au0828_dev *dev)
 {
-
 #ifdef CONFIG_MEDIA_CONTROLLER
-	if (dev->media_dev &&
-		media_devnode_is_registered(&dev->media_dev->devnode)) {
-		/* clear enable_source, disable_source */
-		dev->media_dev->source_priv = NULL;
-		dev->media_dev->enable_source = NULL;
-		dev->media_dev->disable_source = NULL;
+	struct media_device *mdev = dev->media_dev;
+	struct media_entity_notify *notify, *nextp;
 
-		media_device_unregister(dev->media_dev);
-		media_device_cleanup(dev->media_dev);
-		dev->media_dev = NULL;
+	if (!mdev || !media_devnode_is_registered(&mdev->devnode))
+		return;
+
+	/* Remove au0828 entity_notify callbacks */
+	list_for_each_entry_safe(notify, nextp, &mdev->entity_notify, list) {
+		if (notify->notify != au0828_media_graph_notify)
+			continue;
+		media_device_unregister_entity_notify(mdev, notify);
 	}
+
+	/* clear enable_source, disable_source */
+	dev->media_dev->source_priv = NULL;
+	dev->media_dev->enable_source = NULL;
+	dev->media_dev->disable_source = NULL;
+
+	media_device_unregister(dev->media_dev);
+	media_device_cleanup(dev->media_dev);
+	dev->media_dev = NULL;
 #endif
 }
 
-- 
2.5.0

