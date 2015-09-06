Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53831 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbbIFRbf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Sep 2015 13:31:35 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 05/18] [media] media-controller: enable all interface links at init
Date: Sun,  6 Sep 2015 14:30:48 -0300
Message-Id: <2ddddaaaecbdbf624441793ca4c57e81530eaf05.1441559233.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1441559233.git.mchehab@osg.samsung.com>
References: <cover.1441559233.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1441559233.git.mchehab@osg.samsung.com>
References: <cover.1441559233.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Interface links are normally enabled, meaning that the interfaces are
bound to the entities. So, any ioctl send to the interface are reflected
at the entities managed by the interface.

However, when a device is usage, other interfaces for the same hardware
could be decoupled from the entities linked to them, because the
hardware may have some parts busy.

That's for example, what happens when an hybrid TV device is in usage.
If it is streaming analog TV or capturing signals from S-Video/Composite
connectors, typically the digital part of the hardware can't be used and
vice-versa.

This is generally due to some internal hardware or firmware limitation,
that it is not easily mapped via data pipelines.

What the Kernel drivers do internally is that they decouple the hardware
from the interface. So, all changes, if allowed, are done only at some
interface cache, but not physically changed at the hardware.

The usage is similar to the usage of the MEDIA_LNK_FL_ENABLED on data
links. So, let's use the same flag to indicate if ether the interface
to entity link is bound/enabled or not.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index a8e7e2398f7a..5c4fb41060b4 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -396,7 +396,8 @@ static void dvb_register_media_device(struct dvb_device *dvbdev,
 	if (!dvbdev->entity || !dvbdev->intf_devnode)
 		return;
 
-	media_create_intf_link(dvbdev->entity, &dvbdev->intf_devnode->intf, 0);
+	media_create_intf_link(dvbdev->entity, &dvbdev->intf_devnode->intf,
+			       MEDIA_LNK_FL_ENABLED);
 
 #endif
 }
@@ -583,20 +584,24 @@ void dvb_create_media_graph(struct dvb_adapter *adap)
 	/* Create indirect interface links for FE->tuner, DVR->demux and CA->ca */
 	media_device_for_each_intf(intf, mdev) {
 		if (intf->type == MEDIA_INTF_T_DVB_CA && ca)
-			media_create_intf_link(ca, intf, 0);
+			media_create_intf_link(ca, intf, MEDIA_LNK_FL_ENABLED);
 
 		if (intf->type == MEDIA_INTF_T_DVB_FE && tuner)
-			media_create_intf_link(tuner, intf, 0);
+			media_create_intf_link(tuner, intf,
+					       MEDIA_LNK_FL_ENABLED);
 
 		if (intf->type == MEDIA_INTF_T_DVB_DVR && demux)
-			media_create_intf_link(demux, intf, 0);
+			media_create_intf_link(demux, intf,
+					       MEDIA_LNK_FL_ENABLED);
 
 		media_device_for_each_entity(entity, mdev) {
 			if (entity->type == MEDIA_ENT_T_DVB_TSOUT) {
 				if (!strcmp(entity->name, DVR_TSOUT))
-					media_create_intf_link(entity, intf, 0);
+					media_create_intf_link(entity, intf,
+							       MEDIA_LNK_FL_ENABLED);
 				if (!strcmp(entity->name, DEMUX_TSOUT))
-					media_create_intf_link(entity, intf, 0);
+					media_create_intf_link(entity, intf,
+							       MEDIA_LNK_FL_ENABLED);
 				break;
 			}
 		}
diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 07123dd569c4..8429da66754a 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -788,7 +788,8 @@ static int video_register_media_controller(struct video_device *vdev, int type)
 		struct media_link *link;
 
 		link = media_create_intf_link(&vdev->entity,
-					      &vdev->intf_devnode->intf, 0);
+					      &vdev->intf_devnode->intf,
+					      MEDIA_LNK_FL_ENABLED);
 		if (!link) {
 			media_devnode_remove(vdev->intf_devnode);
 			media_device_unregister_entity(&vdev->entity);
diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
index e788a085ba96..bb58d90fde5e 100644
--- a/drivers/media/v4l2-core/v4l2-device.c
+++ b/drivers/media/v4l2-core/v4l2-device.c
@@ -256,7 +256,7 @@ int v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev)
 
 			link = media_create_intf_link(&sd->entity,
 						      &vdev->intf_devnode->intf,
-						      0);
+						      MEDIA_LNK_FL_ENABLED);
 			if (!link)
 				goto clean_up;
 		}
-- 
2.4.3


