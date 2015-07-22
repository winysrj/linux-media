Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-02v.sys.comcast.net ([96.114.154.161]:51938 "EHLO
	resqmta-po-02v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751865AbbGVWme (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2015 18:42:34 -0400
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
Subject: [PATCH v2 01/19] Revert "[media] media: media controller entity framework enhancements for ALSA"
Date: Wed, 22 Jul 2015 16:42:02 -0600
Message-Id: <49da931303fc040178a22dc46c161eeaf0d7a350.1437599281.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1437599281.git.shuahkh@osg.samsung.com>
References: <cover.1437599281.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1437599281.git.shuahkh@osg.samsung.com>
References: <cover.1437599281.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This reverts commit ed64cf1e182fb30fe67652386c0880fcf3302f97.
This patch is no longer necessary as the entity register
callback is implemented at media_device level.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/media-device.c | 7 -------
 include/media/media-entity.h | 4 ----
 2 files changed, 11 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 76590ba..c55ab50 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -428,8 +428,6 @@ EXPORT_SYMBOL_GPL(media_device_unregister);
 int __must_check media_device_register_entity(struct media_device *mdev,
 					      struct media_entity *entity)
 {
-	struct media_entity *eptr;
-
 	/* Warn if we apparently re-register an entity */
 	WARN_ON(entity->parent != NULL);
 	entity->parent = mdev;
@@ -442,11 +440,6 @@ int __must_check media_device_register_entity(struct media_device *mdev,
 	list_add_tail(&entity->list, &mdev->entities);
 	spin_unlock(&mdev->lock);
 
-	media_device_for_each_entity(eptr, mdev) {
-		if (eptr != entity)
-			media_entity_call(eptr, register_notify);
-	}
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(media_device_register_entity);
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 0bc4c2f..0c003d8 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -46,7 +46,6 @@ struct media_pad {
 
 /**
  * struct media_entity_operations - Media entity operations
- * @register_notify	Notify entity of newly registered entity
  * @link_setup:		Notify the entity of link changes. The operation can
  *			return an error, in which case link setup will be
  *			cancelled. Optional.
@@ -55,7 +54,6 @@ struct media_pad {
  *			validates all links by calling this operation. Optional.
  */
 struct media_entity_operations {
-	int (*register_notify)(struct media_entity *entity);
 	int (*link_setup)(struct media_entity *entity,
 			  const struct media_pad *local,
 			  const struct media_pad *remote, u32 flags);
@@ -103,8 +101,6 @@ struct media_entity {
 		/* Sub-device specifications */
 		/* Nothing needed yet */
 	} info;
-
-	void *private;			/* private data for the entity */
 };
 
 static inline u32 media_entity_type(struct media_entity *entity)
-- 
2.1.4

