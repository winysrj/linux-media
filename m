Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58958 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558AbbHWUSK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Aug 2015 16:18:10 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v7 43/44] [media] media_device: add a topology version field
Date: Sun, 23 Aug 2015 17:18:00 -0300
Message-Id: <bc15cafca85403057358c929e0574285c3e07f0a.1440359643.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440359643.git.mchehab@osg.samsung.com>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440359643.git.mchehab@osg.samsung.com>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Every time a graph object is added or removed, the version
of the topology changes. That's a requirement for the new
MEDIA_IOC_G_TOPOLOGY, in order to allow userspace to know
that the topology has changed after a previous call to it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index ef26c01a5a9a..fc6bb48027ab 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -183,6 +183,9 @@ void media_gobj_init(struct media_device *mdev,
 		gobj->id = media_gobj_gen_id(type, ++mdev->intf_devnode_id);
 		break;
 	}
+
+	mdev->topology_version++;
+
 	dev_dbg_obj(__func__, gobj);
 }
 
@@ -198,6 +201,8 @@ void media_gobj_remove(struct media_gobj *gobj)
 	/* Remove the object from mdev list */
 	list_del(&gobj->list);
 
+	gobj->mdev->topology_version++;
+
 	dev_dbg_obj(__func__, gobj);
 }
 
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 0d1b9c687454..1b12774a9ab4 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -41,6 +41,8 @@ struct device;
  * @bus_info:	Unique and stable device location identifier
  * @hw_revision: Hardware device revision
  * @driver_version: Device driver version
+ * @topology_version: Monotonic counter for storing the version of the graph
+ *		topology. Should be incremented each time the topology changes.
  * @entity_id:	Unique ID used on the last entity registered
  * @pad_id:	Unique ID used on the last pad registered
  * @link_id:	Unique ID used on the last link registered
@@ -74,6 +76,8 @@ struct media_device {
 	u32 hw_revision;
 	u32 driver_version;
 
+	u32 topology_version;
+
 	u32 entity_id;
 	u32 pad_id;
 	u32 link_id;
-- 
2.4.3

