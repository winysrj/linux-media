Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-12v.sys.comcast.net ([96.114.154.171]:41589 "EHLO
	resqmta-po-12v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932711AbbFJOWD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2015 10:22:03 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, tiwai@suse.de, perex@perex.cz,
	agoode@google.com, pierre-louis.bossart@linux.intel.com,
	gtmkramer@xs4all.nl, clemens@ladisch.de, vladcatoi@gmail.com,
	damien@zamaudio.com, chris.j.arges@canonical.com,
	takamichiho@gmail.com, misterpib@gmail.com, daniel@zonque.org,
	pmatilai@laiskiainen.org, jussi@sonarnerd.net,
	normalperson@yhbt.net, fisch602@gmail.com, joe@oampo.co.uk
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: [PATCH v3 1/2] media: media controller entity framework enhancements for ALSA
Date: Wed, 10 Jun 2015 08:21:56 -0600
Message-Id: <3f740931e63a551c75aeed1c36955c468d448ef2.1433904553.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1433904553.git.shuahkh@osg.samsung.com>
References: <cover.1433904553.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1433904553.git.shuahkh@osg.samsung.com>
References: <cover.1433904553.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a new media entity operation register_notify is added
to media_entity_operations structure. This hook is called
from media_device_register_entity() whenever a new entity
is registered to notify other entities attached to that
media device of the newly created entity. Entity owners
can register the hook to create links and take any other
action when a new entity is registered. A new field is
added to the struct media_entity for entity owners to save
their private data that is used in the register_notify hook.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/media-device.c | 7 +++++++
 include/media/media-entity.h | 4 ++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index c55ab50..76590ba 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -428,6 +428,8 @@ EXPORT_SYMBOL_GPL(media_device_unregister);
 int __must_check media_device_register_entity(struct media_device *mdev,
 					      struct media_entity *entity)
 {
+	struct media_entity *eptr;
+
 	/* Warn if we apparently re-register an entity */
 	WARN_ON(entity->parent != NULL);
 	entity->parent = mdev;
@@ -440,6 +442,11 @@ int __must_check media_device_register_entity(struct media_device *mdev,
 	list_add_tail(&entity->list, &mdev->entities);
 	spin_unlock(&mdev->lock);
 
+	media_device_for_each_entity(eptr, mdev) {
+		if (eptr != entity)
+			media_entity_call(eptr, register_notify);
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(media_device_register_entity);
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 0c003d8..0bc4c2f 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -46,6 +46,7 @@ struct media_pad {
 
 /**
  * struct media_entity_operations - Media entity operations
+ * @register_notify	Notify entity of newly registered entity
  * @link_setup:		Notify the entity of link changes. The operation can
  *			return an error, in which case link setup will be
  *			cancelled. Optional.
@@ -54,6 +55,7 @@ struct media_pad {
  *			validates all links by calling this operation. Optional.
  */
 struct media_entity_operations {
+	int (*register_notify)(struct media_entity *entity);
 	int (*link_setup)(struct media_entity *entity,
 			  const struct media_pad *local,
 			  const struct media_pad *remote, u32 flags);
@@ -101,6 +103,8 @@ struct media_entity {
 		/* Sub-device specifications */
 		/* Nothing needed yet */
 	} info;
+
+	void *private;			/* private data for the entity */
 };
 
 static inline u32 media_entity_type(struct media_entity *entity)
-- 
2.1.4

