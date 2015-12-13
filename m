Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38521 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbbLMLB7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Dec 2015 06:01:59 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/4] [media] media-device.h: document the last functions
Date: Sun, 13 Dec 2015 09:01:41 -0200
Message-Id: <68bf3676b7c185a90552b41b7b984f3eb37cee49.1450004500.git.mchehab@osg.samsung.com>
In-Reply-To: <fdbcf0a3ea104306c7532b304c71edc606def019.1450004500.git.mchehab@osg.samsung.com>
References: <fdbcf0a3ea104306c7532b304c71edc606def019.1450004500.git.mchehab@osg.samsung.com>
In-Reply-To: <fdbcf0a3ea104306c7532b304c71edc606def019.1450004500.git.mchehab@osg.samsung.com>
References: <fdbcf0a3ea104306c7532b304c71edc606def019.1450004500.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add kernel-doc documentation for media_device_get_devres and
media_device_find_devres.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/media-device.c |  7 -------
 include/media/media-device.h | 22 ++++++++++++++++++++++
 2 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index c12481c753a0..ca16bd3091bd 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -689,10 +689,6 @@ static void media_device_release_devres(struct device *dev, void *res)
 {
 }
 
-/*
- * media_device_get_devres() -	get media device as device resource
- *				creates if one doesn't exist
-*/
 struct media_device *media_device_get_devres(struct device *dev)
 {
 	struct media_device *mdev;
@@ -709,9 +705,6 @@ struct media_device *media_device_get_devres(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(media_device_get_devres);
 
-/*
- * media_device_find_devres() - find media device as device resource
-*/
 struct media_device *media_device_find_devres(struct device *dev)
 {
 	return devres_find(dev, media_device_release_devres, NULL, NULL);
diff --git a/include/media/media-device.h b/include/media/media-device.h
index b0594be5d631..0c3611d1abea 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -449,7 +449,29 @@ int __must_check media_device_register_entity(struct media_device *mdev,
  * the driver if required.
  */
 void media_device_unregister_entity(struct media_entity *entity);
+
+/**
+ * media_device_get_devres() -	get media device as device resource
+ *				creates if one doesn't exist
+ *
+ * @dev: pointer to struct &device.
+ *
+ * Sometimes, the media controller &media_device needs to be shared by more
+ * than one driver. This function adds support for that, by dynamically
+ * allocating the &media_device and allowing it to be obtained from the
+ * struct &device associated with the common device where all sub-device
+ * components belong. So, for example, on an USB device with multiple
+ * interfaces, each interface may be handled by a separate per-interface
+ * drivers. While each interface have its own &device, they all share a
+ * common &device associated with the hole USB device.
+ */
 struct media_device *media_device_get_devres(struct device *dev);
+
+/**
+ * media_device_find_devres() - find media device as device resource
+ *
+ * @dev: pointer to struct &device.
+ */
 struct media_device *media_device_find_devres(struct device *dev);
 
 /* Iterate over all entities. */
-- 
2.5.0

