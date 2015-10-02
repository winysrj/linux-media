Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-04v.sys.comcast.net ([96.114.154.163]:36544 "EHLO
	resqmta-po-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751660AbbJBWHj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Oct 2015 18:07:39 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com,
	tiwai@suse.de, pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, perex@perex.cz,
	dan.carpenter@oracle.com, tskd08@gmail.com, arnd@arndb.de,
	ruchandani.tina@gmail.com, corbet@lwn.net, k.kozlowski@samsung.com,
	chehabrafael@gmail.com, prabhakar.csengg@gmail.com,
	elfring@users.sourceforge.net, Julia.Lawall@lip6.fr,
	p.zabel@pengutronix.de, ricardo.ribalda@gmail.com,
	labbott@fedoraproject.org, chris.j.arges@canonical.com,
	pierre-louis.bossart@linux.intel.com, johan@oljud.se,
	wsa@the-dreams.de, jcragg@gmail.com, clemens@ladisch.de,
	daniel@zonque.org, gtmkramer@xs4all.nl, misterpib@gmail.com,
	takamichiho@gmail.com, pmatilai@laiskiainen.org,
	vladcatoi@gmail.com, damien@zamaudio.com, normalperson@yhbt.net,
	joe@oampo.co.uk, jussi@sonarnerd.net, calcprogrammer1@gmail.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: [PATCH MC Next Gen 01/20] media: Media Controller register/unregister entity_notify API
Date: Fri,  2 Oct 2015 16:07:13 -0600
Message-Id: <5664b92f73398d4fe2b83522250098f127e451c4.1443822799.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1443822799.git.shuahkh@osg.samsung.com>
References: <cover.1443822799.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1443822799.git.shuahkh@osg.samsung.com>
References: <cover.1443822799.git.shuahkh@osg.samsung.com>
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
 drivers/media/media-device.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 include/media/media-device.h | 25 +++++++++++++++++++++++++
 2 files changed, 68 insertions(+)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 1312e93..fba3a71 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -544,6 +544,7 @@ int __must_check __media_device_register(struct media_device *mdev,
 		return -EINVAL;
 
 	INIT_LIST_HEAD(&mdev->entities);
+	INIT_LIST_HEAD(&mdev->entity_notify);
 	INIT_LIST_HEAD(&mdev->interfaces);
 	INIT_LIST_HEAD(&mdev->pads);
 	INIT_LIST_HEAD(&mdev->links);
@@ -581,6 +582,7 @@ void media_device_unregister(struct media_device *mdev)
 	struct media_entity *next;
 	struct media_link *link, *tmp_link;
 	struct media_interface *intf, *tmp_intf;
+	struct media_entity_notify *notify, *nextp;
 
 	/* Remove interface links from the media device */
 	list_for_each_entry_safe(link, tmp_link, &mdev->links,
@@ -598,6 +600,8 @@ void media_device_unregister(struct media_device *mdev)
 
 	list_for_each_entry_safe(entity, next, &mdev->entities, graph_obj.list)
 		media_device_unregister_entity(entity);
+	list_for_each_entry_safe(notify, nextp, &mdev->entity_notify, list)
+		media_device_unregister_entity_notify(mdev, notify);
 
 	device_remove_file(&mdev->devnode.dev, &dev_attr_model);
 	media_devnode_unregister(&mdev->devnode);
@@ -607,6 +611,39 @@ void media_device_unregister(struct media_device *mdev)
 EXPORT_SYMBOL_GPL(media_device_unregister);
 
 /**
+ * media_device_register_entity_notify - Register a media entity notify
+ * callback with a media device. When a new entity is registered, all
+ * the registered media_entity_notify callbacks are invoked.
+ * @mdev:      The media device
+ * @nptr:      The media_entity_notify
+*/
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
+ * @mdev:      The media device
+ * @nptr:      The media_entity_notify
+ */
+void media_device_unregister_entity_notify(struct media_device *mdev,
+				struct media_entity_notify *nptr)
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
@@ -614,6 +651,7 @@ EXPORT_SYMBOL_GPL(media_device_unregister);
 int __must_check media_device_register_entity(struct media_device *mdev,
 					      struct media_entity *entity)
 {
+	struct media_entity_notify *notify, *next;
 	unsigned int i;
 
 	if (entity->function == MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN ||
@@ -636,6 +674,10 @@ int __must_check media_device_register_entity(struct media_device *mdev,
 		media_gobj_init(mdev, MEDIA_GRAPH_PAD,
 			       &entity->pads[i].graph_obj);
 
+	/* invoke entity_notify callbacks */
+	list_for_each_entry_safe(notify, next, &mdev->entity_notify, list) {
+		(notify)->notify(entity, notify->notify_data);
+	}
 	spin_unlock(&mdev->lock);
 
 	return 0;
@@ -682,6 +724,7 @@ void media_device_unregister_entity(struct media_entity *entity)
 	/* Remove the entity */
 	media_gobj_remove(&entity->graph_obj);
 
+	/* invoke entity_notify callbacks to handle entity removal?? */
 	spin_unlock(&mdev->lock);
 	entity->graph_obj.mdev = NULL;
 }
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 1b12774..bc53f4f 100644
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
@@ -84,6 +90,8 @@ struct media_device {
 	u32 intf_devnode_id;
 
 	struct list_head entities;
+	/* notify callback list invoked when a new entity is registered */
+	struct list_head entity_notify;
 	struct list_head interfaces;
 	struct list_head pads;
 	struct list_head links;
@@ -111,6 +119,11 @@ int __must_check __media_device_register(struct media_device *mdev,
 #define media_device_register(mdev) __media_device_register(mdev, THIS_MODULE)
 void media_device_unregister(struct media_device *mdev);
 
+int __must_check media_device_register_entity_notify(struct media_device *mdev,
+					struct media_entity_notify *nptr);
+void media_device_unregister_entity_notify(struct media_device *mdev,
+					struct media_entity_notify *nptr);
+
 int __must_check media_device_register_entity(struct media_device *mdev,
 					      struct media_entity *entity);
 void media_device_unregister_entity(struct media_entity *entity);
@@ -142,6 +155,18 @@ static inline int media_device_register(struct media_device *mdev)
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
+
 static inline int media_device_register_entity(struct media_device *mdev,
 						struct media_entity *entity)
 {
-- 
2.1.4

