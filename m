Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55916 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbbHaJ0O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2015 05:26:14 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 2/2] [media] media-controller: enable all interface links at init
Date: Mon, 31 Aug 2015 06:25:52 -0300
Message-Id: <5a0cfdf9f7ce35a459aedc04d3e867286ae24071.1441013143.git.mchehab@osg.samsung.com>
In-Reply-To: <241578af13805088e8a37686245c3b98a1fa9791.1441013143.git.mchehab@osg.samsung.com>
References: <241578af13805088e8a37686245c3b98a1fa9791.1441013143.git.mchehab@osg.samsung.com>
In-Reply-To: <241578af13805088e8a37686245c3b98a1fa9791.1441013143.git.mchehab@osg.samsung.com>
References: <241578af13805088e8a37686245c3b98a1fa9791.1441013143.git.mchehab@osg.samsung.com>
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
index 95b5b4b11230..e4234deac34d 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -583,17 +583,21 @@ void dvb_create_media_graph(struct dvb_adapter *adap)
 			media_create_intf_link(ca, intf, 0);
 
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
index 427a5a32b3de..d7ee31a20c12 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -787,7 +787,8 @@ static int video_register_media_controller(struct video_device *vdev, int type)
 
 	if (create_entity)
 		media_create_intf_link(&vdev->entity,
-				       &vdev->intf_devnode->intf, 0);
+				       &vdev->intf_devnode->intf,
+				       MEDIA_LNK_FL_ENABLED);
 
 	/* FIXME: how to create the other interface links? */
 
diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
index 17ec73b1796e..3e4d7cb9ed97 100644
--- a/drivers/media/v4l2-core/v4l2-device.c
+++ b/drivers/media/v4l2-core/v4l2-device.c
@@ -253,7 +253,8 @@ int v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev)
 		/* Interface is created by __video_register_device() */
 		if (vdev->v4l2_dev->mdev)
 			media_create_intf_link(&sd->entity,
-					       &vdev->intf_devnode->intf, 0);
+					       &vdev->intf_devnode->intf,
+					       MEDIA_LNK_FL_ENABLED);
 #endif
 		sd->devnode = vdev;
 	}
-- 
2.4.3

