Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48544 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbbH3DHx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Aug 2015 23:07:53 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v8 48/55] [media] media_device: add a topology version field
Date: Sun, 30 Aug 2015 00:06:59 -0300
Message-Id: <e8cb8de5ad8f2da3c32418d67340fe4bb663ce5c.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Every time a graph object is added or removed, the version
of the topology changes. That's a requirement for the new
MEDIA_IOC_G_TOPOLOGY, in order to allow userspace to know
that the topology has changed after a previous call to it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index c89f51bc688d..c18f4af52771 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -185,6 +185,9 @@ void media_gobj_init(struct media_device *mdev,
 		list_add_tail(&gobj->list, &mdev->interfaces);
 		break;
 	}
+
+	mdev->topology_version++;
+
 	dev_dbg_obj(__func__, gobj);
 }
 
@@ -199,6 +202,8 @@ void media_gobj_remove(struct media_gobj *gobj)
 {
 	dev_dbg_obj(__func__, gobj);
 
+	gobj->mdev->topology_version++;
+
 	/* Remove the object from mdev list */
 	list_del(&gobj->list);
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

