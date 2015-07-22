Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-07v.sys.comcast.net ([96.114.154.166]:45222 "EHLO
	resqmta-po-07v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752524AbbGVWmm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2015 18:42:42 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, tiwai@suse.de,
	sakari.ailus@linux.intel.com, perex@perex.cz, crope@iki.fi,
	arnd@arndb.de, stefanr@s5r6.in-berlin.de,
	ruchandani.tina@gmail.com, chehabrafael@gmail.com,
	dan.carpenter@oracle.com, prabhakar.csengg@gmail.com,
	chris.j.arges@canonical.com, agoode@google.com,
	pierre-louis.bossart@linux.intel.com, gtmkramer@xs4all.nl,
	clemens@ladisch.de, daniel@zonque.org, vladcatoi@gmail.com,
	misterpib@gmail.com, damien@zamaudio.com, pmatilai@laiskiainen.org,
	takamichiho@gmail.com, normalperson@yhbt.net,
	bugzilla.frnkcg@spamgourmet.com, joe@oampo.co.uk,
	calcprogrammer1@gmail.com, jussi@sonarnerd.net,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	kgene@kernel.org, hyun.kwon@xilinx.com, michal.simek@xilinx.com,
	soren.brinkmann@xilinx.com, pawel@osciak.com,
	m.szyprowski@samsung.com, gregkh@linuxfoundation.org,
	skd08@gmail.com, nsekhar@ti.com,
	boris.brezillon@free-electrons.com, Julia.Lawall@lip6.fr,
	elfring@users.sourceforge.net, p.zabel@pengutronix.de,
	ricardo.ribalda@gmail.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org, linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, devel@driverdev.osuosl.org
Subject: [PATCH v2 05/19] media: Convert graph_mutex to a spinlock and call it graph_lock
Date: Wed, 22 Jul 2015 16:42:06 -0600
Message-Id: <50c4c93ef0cd505e46d18c66b7ce6343f7fa0722.1437599281.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1437599281.git.shuahkh@osg.samsung.com>
References: <cover.1437599281.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1437599281.git.shuahkh@osg.samsung.com>
References: <cover.1437599281.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ALSA driver calls Media Controller start/stop pipeline
interfaces from IRQ handler. Start/stop pipeline lock
graph_mutex which is unsafe from a IRQ handler. Convert
graph_mutex into a spinlock and call it graph_lock. IRQ
safe start/stop pipeline interfaces will be added based
on this change.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/media-device.c | 14 +++++++-------
 drivers/media/media-entity.c | 18 +++++++++---------
 include/media/media-device.h |  4 ++--
 3 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 22565a8..b0fafd7 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -251,17 +251,17 @@ static long media_device_ioctl(struct file *filp, unsigned int cmd,
 		break;
 
 	case MEDIA_IOC_ENUM_LINKS:
-		mutex_lock(&dev->graph_mutex);
+		spin_lock(&dev->graph_lock);
 		ret = media_device_enum_links(dev,
 				(struct media_links_enum __user *)arg);
-		mutex_unlock(&dev->graph_mutex);
+		spin_unlock(&dev->graph_lock);
 		break;
 
 	case MEDIA_IOC_SETUP_LINK:
-		mutex_lock(&dev->graph_mutex);
+		spin_lock(&dev->graph_lock);
 		ret = media_device_setup_link(dev,
 				(struct media_link_desc __user *)arg);
-		mutex_unlock(&dev->graph_mutex);
+		spin_unlock(&dev->graph_lock);
 		break;
 
 	default:
@@ -315,10 +315,10 @@ static long media_device_compat_ioctl(struct file *filp, unsigned int cmd,
 		return media_device_ioctl(filp, cmd, arg);
 
 	case MEDIA_IOC_ENUM_LINKS32:
-		mutex_lock(&dev->graph_mutex);
+		spin_lock(&dev->graph_lock);
 		ret = media_device_enum_links32(dev,
 				(struct media_links_enum32 __user *)arg);
-		mutex_unlock(&dev->graph_mutex);
+		spin_unlock(&dev->graph_lock);
 		break;
 
 	default:
@@ -383,7 +383,7 @@ int __must_check __media_device_register(struct media_device *mdev,
 	INIT_LIST_HEAD(&mdev->entities);
 	INIT_LIST_HEAD(&mdev->entity_notify);
 	spin_lock_init(&mdev->lock);
-	mutex_init(&mdev->graph_mutex);
+	spin_lock_init(&mdev->graph_lock);
 
 	/* Register the device node. */
 	mdev->devnode.fops = &media_device_fops;
diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 4d8e01c..31132573 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -230,7 +230,7 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 	struct media_entity *entity_err = entity;
 	int ret;
 
-	mutex_lock(&mdev->graph_mutex);
+	spin_lock(&mdev->graph_lock);
 
 	media_entity_graph_walk_start(&graph, entity);
 
@@ -303,7 +303,7 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 		}
 	}
 
-	mutex_unlock(&mdev->graph_mutex);
+	spin_unlock(&mdev->graph_lock);
 
 	return 0;
 
@@ -327,7 +327,7 @@ error:
 			break;
 	}
 
-	mutex_unlock(&mdev->graph_mutex);
+	spin_unlock(&mdev->graph_lock);
 
 	return ret;
 }
@@ -350,7 +350,7 @@ void media_entity_pipeline_stop(struct media_entity *entity)
 	struct media_device *mdev = entity->parent;
 	struct media_entity_graph graph;
 
-	mutex_lock(&mdev->graph_mutex);
+	spin_lock(&mdev->graph_lock);
 
 	media_entity_graph_walk_start(&graph, entity);
 
@@ -360,7 +360,7 @@ void media_entity_pipeline_stop(struct media_entity *entity)
 			entity->pipe = NULL;
 	}
 
-	mutex_unlock(&mdev->graph_mutex);
+	spin_unlock(&mdev->graph_lock);
 }
 EXPORT_SYMBOL_GPL(media_entity_pipeline_stop);
 
@@ -519,9 +519,9 @@ void media_entity_remove_links(struct media_entity *entity)
 	if (entity->parent == NULL)
 		return;
 
-	mutex_lock(&entity->parent->graph_mutex);
+	spin_lock(&entity->parent->graph_lock);
 	__media_entity_remove_links(entity);
-	mutex_unlock(&entity->parent->graph_mutex);
+	spin_unlock(&entity->parent->graph_lock);
 }
 EXPORT_SYMBOL_GPL(media_entity_remove_links);
 
@@ -611,9 +611,9 @@ int media_entity_setup_link(struct media_link *link, u32 flags)
 {
 	int ret;
 
-	mutex_lock(&link->source->entity->parent->graph_mutex);
+	spin_lock(&link->source->entity->parent->graph_lock);
 	ret = __media_entity_setup_link(link, flags);
-	mutex_unlock(&link->source->entity->parent->graph_mutex);
+	spin_unlock(&link->source->entity->parent->graph_lock);
 
 	return ret;
 }
diff --git a/include/media/media-device.h b/include/media/media-device.h
index a3854f6..e73642c 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -50,7 +50,7 @@ struct media_entity_notify {
  * @entity_id:	ID of the next entity to be registered
  * @entities:	List of registered entities
  * @lock:	Entities list lock
- * @graph_mutex: Entities graph operation lock
+ * @graph_lock: Entities graph operation lock
  * @link_notify: Link state change notification callback
  *
  * This structure represents an abstract high-level media device. It allows easy
@@ -82,7 +82,7 @@ struct media_device {
 	/* Protects the entities list */
 	spinlock_t lock;
 	/* Serializes graph operations. */
-	struct mutex graph_mutex;
+	spinlock_t graph_lock;
 
 	int (*link_notify)(struct media_link *link, u32 flags,
 			   unsigned int notification);
-- 
2.1.4

