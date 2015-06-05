Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-07v.sys.comcast.net ([96.114.154.166]:46349 "EHLO
	resqmta-po-07v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751899AbbFEUL6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Jun 2015 16:11:58 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] media: define Media Controller API when CONFIG_MEDIA_CONTROLLER enabled
Date: Fri,  5 Jun 2015 14:11:54 -0600
Message-Id: <1433535114-5493-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change to define Media Controller API when CONFIG_MEDIA_CONTROLLER
is enabled. Define stubs for CONFIG_MEDIA_CONTROLLER disabled case.
This will help avoid drivers needing to enclose Media Controller
code within ifdef CONFIG_MEDIA_CONTROLLER block.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/media-device.c |  4 ++++
 include/media/media-device.h | 27 +++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index a4d5b24..c55ab50 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -30,6 +30,8 @@
 #include <media/media-devnode.h>
 #include <media/media-entity.h>
 
+#ifdef CONFIG_MEDIA_CONTROLLER
+
 /* -----------------------------------------------------------------------------
  * Userspace API
  */
@@ -495,3 +497,5 @@ struct media_device *media_device_find_devres(struct device *dev)
 	return devres_find(dev, media_device_release_devres, NULL, NULL);
 }
 EXPORT_SYMBOL_GPL(media_device_find_devres);
+
+#endif /* CONFIG_MEDIA_CONTROLLER */
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 22792cd..a44f18f 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -80,6 +80,8 @@ struct media_device {
 			   unsigned int notification);
 };
 
+#ifdef CONFIG_MEDIA_CONTROLLER
+
 /* Supported link_notify @notification values. */
 #define MEDIA_DEV_NOTIFY_PRE_LINK_CH	0
 #define MEDIA_DEV_NOTIFY_POST_LINK_CH	1
@@ -102,4 +104,29 @@ struct media_device *media_device_find_devres(struct device *dev);
 #define media_device_for_each_entity(entity, mdev)			\
 	list_for_each_entry(entity, &(mdev)->entities, list)
 
+#else
+static inline int media_device_register(struct media_device *mdev)
+{
+	return 0;
+}
+static inline void media_device_unregister(struct media_device *mdev)
+{
+}
+static inline int media_device_register_entity(struct media_device *mdev,
+						struct media_entity *entity)
+{
+	return 0;
+}
+static inline void media_device_unregister_entity(struct media_entity *entity)
+{
+}
+static inline struct media_device *media_device_get_devres(struct device *dev)
+{
+	return NULL;
+}
+static inline struct media_device *media_device_find_devres(struct device *dev)
+{
+	return NULL;
+}
+#endif /* CONFIG_MEDIA_CONTROLLER */
 #endif
-- 
2.1.4

