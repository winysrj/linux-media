Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-04v.sys.comcast.net ([96.114.154.163]:43542 "EHLO
	resqmta-po-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758767AbbIVR2C (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2015 13:28:02 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com,
	tiwai@suse.de, pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, perex@perex.cz,
	stefanr@s5r6.in-berlin.de, crope@iki.fi, dan.carpenter@oracle.com,
	tskd08@gmail.com, ruchandani.tina@gmail.com, arnd@arndb.de,
	chehabrafael@gmail.com, prabhakar.csengg@gmail.com,
	Julia.Lawall@lip6.fr, elfring@users.sourceforge.net,
	ricardo.ribalda@gmail.com, chris.j.arges@canonical.com,
	pierre-louis.bossart@linux.intel.com, gtmkramer@xs4all.nl,
	clemens@ladisch.de, misterpib@gmail.com, takamichiho@gmail.com,
	pmatilai@laiskiainen.org, damien@zamaudio.com, daniel@zonque.org,
	vladcatoi@gmail.com, normalperson@yhbt.net, joe@oampo.co.uk,
	bugzilla.frnkcg@spamgourmet.com, jussi@sonarnerd.net
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: [PATCH v3 02/21] media: Media Controller register/unregister entity_notify API
Date: Tue, 22 Sep 2015 11:19:21 -0600
Message-Id: <21da4006a0f95ec7aad81539e58df5ef04a173cb.1442937669.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1442937669.git.shuahkh@osg.samsung.com>
References: <cover.1442937669.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1442937669.git.shuahkh@osg.samsung.com>
References: <cover.1442937669.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add new interfaces to register and unregister entity_notify
hook to media device to allow drivers to take appropriate
actions when as new entities get added to the shared media
device.When a new entity is registered, all registered
entity_notify hooks are invoked to allow drivers or modules
that registered hook to take appropriate action. For example,
ALSA driver registers an entity_notify hook to parse the list
of registered entities to determine if decoder has been linked
to ALSA entity. au0828 bridge driver registers an entity_notify
hook to create media graph for the device.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/media-device.c | 45 ++++++++++++++++++++++++++++++++++++++++++++
 include/media/media-device.h | 23 ++++++++++++++++++++++
 2 files changed, 68 insertions(+)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index c55ab50..22565a8 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -381,6 +381,7 @@ int __must_check __media_device_register(struct media_device *mdev,
 
 	mdev->entity_id = 1;
 	INIT_LIST_HEAD(&mdev->entities);
+	INIT_LIST_HEAD(&mdev->entity_notify);
 	spin_lock_init(&mdev->lock);
 	mutex_init(&mdev->graph_mutex);
 
@@ -411,9 +412,12 @@ void media_device_unregister(struct media_device *mdev)
 {
 	struct media_entity *entity;
 	struct media_entity *next;
+	struct media_entity_notify *notify, *nextp;
 
 	list_for_each_entry_safe(entity, next, &mdev->entities, list)
 		media_device_unregister_entity(entity);
+	list_for_each_entry_safe(notify, nextp, &mdev->entity_notify, list)
+		media_device_unregister_entity_notify(mdev, notify);
 
 	device_remove_file(&mdev->devnode.dev, &dev_attr_model);
 	media_devnode_unregister(&mdev->devnode);
@@ -421,6 +425,39 @@ void media_device_unregister(struct media_device *mdev)
 EXPORT_SYMBOL_GPL(media_device_unregister);
 
 /**
+ * media_device_register_entity_notify - Register a media entity notify
+ * callback with a media device. When a new entity is registered, all
+ * the registered media_entity_notify callbacks are invoked.
+ * @mdev:	The media device
+ * @nptr:	The media_entity_notify
+ */
+int __must_check media_device_register_entity_notify(struct media_device *mdev,
+					struct media_entity_notify *nptr)
+{
+	spin_lock(&mdev->lock);
+	list_add_tail(&nptr->list, &mdev->entity_notify);
+	spin_unlock(&mdev->lock);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(media_device_register_entity_notify);
+
+/**
+ * media_device_unregister_entity_notify - Unregister a media entity notify
+ * callback with a media device. When a new entity is registered, all
+ * the registered media_entity_notify callbacks are invoked.
+ * @mdev:	The media device
+ * @nptr:	The media_entity_notify
+ */
+void media_device_unregister_entity_notify(struct media_device *mdev,
+					struct media_entity_notify *nptr)
+{
+	spin_lock(&mdev->lock);
+	list_del(&nptr->list);
+	spin_unlock(&mdev->lock);
+}
+EXPORT_SYMBOL_GPL(media_device_unregister_entity_notify);
+
+/**
  * media_device_register_entity - Register an entity with a media device
  * @mdev:	The media device
  * @entity:	The entity
@@ -428,6 +465,8 @@ EXPORT_SYMBOL_GPL(media_device_unregister);
 int __must_check media_device_register_entity(struct media_device *mdev,
 					      struct media_entity *entity)
 {
+	struct media_entity_notify *notify, *next;
+
 	/* Warn if we apparently re-register an entity */
 	WARN_ON(entity->parent != NULL);
 	entity->parent = mdev;
@@ -440,6 +479,11 @@ int __must_check media_device_register_entity(struct media_device *mdev,
 	list_add_tail(&entity->list, &mdev->entities);
 	spin_unlock(&mdev->lock);
 
+	/* invoke entity_notify callbacks */
+	list_for_each_entry_safe(notify, next, &mdev->entity_notify, list) {
+		(notify)->notify(entity, notify->notify_data);
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(media_device_register_entity);
@@ -462,6 +506,7 @@ void media_device_unregister_entity(struct media_entity *entity)
 	list_del(&entity->list);
 	spin_unlock(&mdev->lock);
 	entity->parent = NULL;
+	/* invoke entity_notify callbacks to handle entity removal?? */
 }
 EXPORT_SYMBOL_GPL(media_device_unregister_entity);
 
diff --git a/include/media/media-device.h b/include/media/media-device.h
index a44f18f..a3854f6 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -32,6 +32,12 @@
 
 struct device;
 
+struct media_entity_notify {
+	struct list_head list;
+	void *notify_data;
+	void (*notify)(struct media_entity *entity, void *notify_data);
+};
+
 /**
  * struct media_device - Media device
  * @dev:	Parent device
@@ -70,6 +76,8 @@ struct media_device {
 
 	u32 entity_id;
 	struct list_head entities;
+	/* notify callback list invoked when a new entity is registered */
+	struct list_head entity_notify;
 
 	/* Protects the entities list */
 	spinlock_t lock;
@@ -94,6 +102,10 @@ int __must_check __media_device_register(struct media_device *mdev,
 #define media_device_register(mdev) __media_device_register(mdev, THIS_MODULE)
 void media_device_unregister(struct media_device *mdev);
 
+int __must_check media_device_register_entity_notify(struct media_device *mdev,
+					struct media_entity_notify *nptr);
+void media_device_unregister_entity_notify(struct media_device *mdev,
+					struct media_entity_notify *nptr);
 int __must_check media_device_register_entity(struct media_device *mdev,
 					      struct media_entity *entity);
 void media_device_unregister_entity(struct media_entity *entity);
@@ -112,6 +124,17 @@ static inline int media_device_register(struct media_device *mdev)
 static inline void media_device_unregister(struct media_device *mdev)
 {
 }
+static inline int media_device_register_entity_notify(
+					struct media_device *mdev,
+					struct media_entity_notify *nptr)
+{
+	return 0;
+}
+static inline void media_device_unregister_entity_notify(
+					struct media_device *mdev,
+					struct media_entity_notify *nptr)
+{
+}
 static inline int media_device_register_entity(struct media_device *mdev,
 						struct media_entity *entity)
 {
-- 
2.1.4

