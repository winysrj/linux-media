Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51200 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529AbbIILcj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Sep 2015 07:32:39 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 2/2] [media] media-device: use unsigned ints on some places
Date: Wed,  9 Sep 2015 08:32:03 -0300
Message-Id: <b1205852042ddb1aff6a53077e7e28d75fcb02c0.1441798267.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1441798267.git.mchehab@osg.samsung.com>
References: <cover.1441798267.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1441798267.git.mchehab@osg.samsung.com>
References: <cover.1441798267.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The entity->num_pads are defined as u16. So, better to use an
unsigned int, as this prevents additional warnings when W=2
(or W=1 on some architectures).

The "i" counter at __media_device_get_topology() is also a
monotonic counter that should never be below zero. So,
make it unsigned too.

Suggested-by: Sakari Ailus <sakari.ailus@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 13987710e5bc..1312e93ebd6e 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -243,7 +243,8 @@ static long __media_device_get_topology(struct media_device *mdev,
 	struct media_v2_interface uintf;
 	struct media_v2_pad upad;
 	struct media_v2_link ulink;
-	int ret = 0, i;
+	int ret = 0;
+	unsigned int i;
 
 	topo->topology_version = mdev->topology_version;
 
@@ -613,7 +614,7 @@ EXPORT_SYMBOL_GPL(media_device_unregister);
 int __must_check media_device_register_entity(struct media_device *mdev,
 					      struct media_entity *entity)
 {
-	int i;
+	unsigned int i;
 
 	if (entity->function == MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN ||
 	    entity->function == MEDIA_ENT_F_UNKNOWN)
@@ -650,9 +651,9 @@ EXPORT_SYMBOL_GPL(media_device_register_entity);
  */
 void media_device_unregister_entity(struct media_entity *entity)
 {
-	int i;
 	struct media_device *mdev = entity->graph_obj.mdev;
 	struct media_link *link, *tmp;
+	unsigned int i;
 
 	if (mdev == NULL)
 		return;
-- 
2.4.3


