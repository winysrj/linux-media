Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:35747 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbcBKXly (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Feb 2016 18:41:54 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, tiwai@suse.com, clemens@ladisch.de,
	hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com,
	sakari.ailus@linux.intel.com, javier@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, pawel@osciak.com,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com,
	tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com,
	corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com,
	stefanr@s5r6.in-berlin.de, inki.dae@samsung.com,
	jh1009.sung@samsung.com, elfring@users.sourceforge.net,
	prabhakar.csengg@gmail.com, sw0312.kim@samsung.com,
	p.zabel@pengutronix.de, ricardo.ribalda@gmail.com,
	labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com,
	ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com,
	dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org,
	gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk,
	linuxbugs@vittgam.net, johan@oljud.se, klock.android@gmail.com,
	nenggun.kim@samsung.com, j.anaszewski@samsung.com,
	geliangtang@163.com, albert@huitsing.nl,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: [PATCH v3 05/22] media: Media Controller register/unregister entity_notify API
Date: Thu, 11 Feb 2016 16:41:21 -0700
Message-Id: <5045cdb7ec9cec401509dcf714bf1065d8b765dc.1455233153.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1455233150.git.shuahkh@osg.samsung.com>
References: <cover.1455233150.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1455233150.git.shuahkh@osg.samsung.com>
References: <cover.1455233150.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add new interfaces to register and unregister entity_notify
hook to media device. These interfaces allow drivers to add
hooks to take appropriate actions when new entities get added
to a shared media device. For example, au0828 bridge driver
registers an entity_notify hook to create links as needed
between media graph nodes.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/media-device.c | 42 +++++++++++++++++++++++++++++++++
 include/media/media-device.h | 56 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 98 insertions(+)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 4d1c13d..9c1cf70 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -536,6 +536,7 @@ static void media_device_release(struct media_devnode *mdev)
 int __must_check media_device_register_entity(struct media_device *mdev,
 					      struct media_entity *entity)
 {
+	struct media_entity_notify *notify, *next;
 	unsigned int i;
 	int ret;
 
@@ -575,6 +576,11 @@ int __must_check media_device_register_entity(struct media_device *mdev,
 		media_gobj_create(mdev, MEDIA_GRAPH_PAD,
 			       &entity->pads[i].graph_obj);
 
+	/* invoke entity_notify callbacks */
+	list_for_each_entry_safe(notify, next, &mdev->entity_notify, list) {
+		(notify)->notify(entity, notify->notify_data);
+	}
+
 	spin_unlock(&mdev->lock);
 
 	return 0;
@@ -608,6 +614,8 @@ static void __media_device_unregister_entity(struct media_entity *entity)
 	/* Remove the entity */
 	media_gobj_destroy(&entity->graph_obj);
 
+	/* invoke entity_notify callbacks to handle entity removal?? */
+
 	entity->graph_obj.mdev = NULL;
 }
 
@@ -640,6 +648,7 @@ void media_device_init(struct media_device *mdev)
 	INIT_LIST_HEAD(&mdev->interfaces);
 	INIT_LIST_HEAD(&mdev->pads);
 	INIT_LIST_HEAD(&mdev->links);
+	INIT_LIST_HEAD(&mdev->entity_notify);
 	spin_lock_init(&mdev->lock);
 	mutex_init(&mdev->graph_mutex);
 	ida_init(&mdev->entity_internal_idx);
@@ -685,11 +694,40 @@ int __must_check __media_device_register(struct media_device *mdev,
 }
 EXPORT_SYMBOL_GPL(__media_device_register);
 
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
+ * Note: Should be called with mdev->lock held.
+ */
+static void __media_device_unregister_entity_notify(struct media_device *mdev,
+					struct media_entity_notify *nptr)
+{
+	list_del(&nptr->list);
+}
+
+void media_device_unregister_entity_notify(struct media_device *mdev,
+					struct media_entity_notify *nptr)
+{
+	spin_lock(&mdev->lock);
+	__media_device_unregister_entity_notify(mdev, nptr);
+	spin_unlock(&mdev->lock);
+}
+EXPORT_SYMBOL_GPL(media_device_unregister_entity_notify);
+
 void media_device_unregister(struct media_device *mdev)
 {
 	struct media_entity *entity;
 	struct media_entity *next;
 	struct media_interface *intf, *tmp_intf;
+	struct media_entity_notify *notify, *nextp;
 
 	if (mdev == NULL)
 		return;
@@ -706,6 +744,10 @@ void media_device_unregister(struct media_device *mdev)
 	list_for_each_entry_safe(entity, next, &mdev->entities, graph_obj.list)
 		__media_device_unregister_entity(entity);
 
+	/* Remove all entity_notify callbacks from the media device */
+	list_for_each_entry_safe(notify, nextp, &mdev->entity_notify, list)
+		__media_device_unregister_entity_notify(mdev, notify);
+
 	/* Remove all interfaces from the media device */
 	list_for_each_entry_safe(intf, tmp_intf, &mdev->interfaces,
 				 graph_obj.list) {
diff --git a/include/media/media-device.h b/include/media/media-device.h
index d385589..075a482 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -265,6 +265,22 @@ struct ida;
 struct device;
 
 /**
+ * struct media_entity_notify - Media Entity Notify
+ *
+ * @list: List head
+ * @notify_data: Input data to invoke the callback
+ * @notify: Callback function pointer
+ *
+ * Drivers may register a callback to take action when
+ * new entities get registered with the media device.
+ */
+struct media_entity_notify {
+	struct list_head list;
+	void *notify_data;
+	void (*notify)(struct media_entity *entity, void *notify_data);
+};
+
+/**
  * struct media_device - Media device
  * @dev:	Parent device
  * @devnode:	Media device node
@@ -283,6 +299,7 @@ struct device;
  * @interfaces:	List of registered interfaces
  * @pads:	List of registered pads
  * @links:	List of registered links
+ * @entity_notify: List of registered entity_notify callbacks
  * @lock:	Entities list lock
  * @graph_mutex: Entities graph operation lock
  * @link_notify: Link state change notification callback
@@ -319,6 +336,9 @@ struct media_device {
 	struct list_head pads;
 	struct list_head links;
 
+	/* notify callback list invoked when a new entity is registered */
+	struct list_head entity_notify;
+
 	/* Protects the graph objects creation/removal */
 	spinlock_t lock;
 	/* Serializes graph operations. */
@@ -498,6 +518,31 @@ int __must_check media_device_register_entity(struct media_device *mdev,
 void media_device_unregister_entity(struct media_entity *entity);
 
 /**
+ * media_device_register_entity_notify() - Registers a media entity_notify
+ *					   callback
+ *
+ * @mdev:      The media device
+ * @nptr:      The media_entity_notify
+ *
+ * Note: When a new entity is registered, all the registered
+ * media_entity_notify callbacks are invoked.
+ */
+
+int __must_check media_device_register_entity_notify(struct media_device *mdev,
+					struct media_entity_notify *nptr);
+
+/**
+ * media_device_unregister_entity_notify() - Unregister a media entity notify
+ *					     callback
+ *
+ * @mdev:      The media device
+ * @nptr:      The media_entity_notify
+ *
+ */
+void media_device_unregister_entity_notify(struct media_device *mdev,
+					struct media_entity_notify *nptr);
+
+/**
  * media_device_get_devres() -	get media device as device resource
  *				creates if one doesn't exist
  *
@@ -552,6 +597,17 @@ static inline int media_device_register_entity(struct media_device *mdev,
 static inline void media_device_unregister_entity(struct media_entity *entity)
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
 static inline struct media_device *media_device_get_devres(struct device *dev)
 {
 	return NULL;
-- 
2.5.0

