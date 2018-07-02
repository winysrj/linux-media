Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:56152 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752033AbeGBMnF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Jul 2018 08:43:05 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] media: mark entity-intf links as IMMUTABLE
Message-ID: <7a8dae57-3161-d787-c1bd-95abbdae5633@xs4all.nl>
Date: Mon, 2 Jul 2018 14:43:02 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently links between entities and an interface are just marked as
ENABLED. But (at least today) these links cannot be disabled by userspace
or the driver, so they should also be marked as IMMUTABLE.

It might become possible that drivers can disable such links (if for some
reason the device node cannot be used), so we might need to add a new link
flag at some point to mark interface links that can be changed by the driver
but not by userspace.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 64d6793674b9..3c8778570331 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -440,8 +440,10 @@ static int dvb_register_media_device(struct dvb_device *dvbdev,
 	if (!dvbdev->entity)
 		return 0;

-	link = media_create_intf_link(dvbdev->entity, &dvbdev->intf_devnode->intf,
-				      MEDIA_LNK_FL_ENABLED);
+	link = media_create_intf_link(dvbdev->entity,
+				      &dvbdev->intf_devnode->intf,
+				      MEDIA_LNK_FL_ENABLED |
+				      MEDIA_LNK_FL_IMMUTABLE);
 	if (!link)
 		return -ENOMEM;
 #endif
@@ -599,7 +601,8 @@ static int dvb_create_io_intf_links(struct dvb_adapter *adap,
 			if (strncmp(entity->name, name, strlen(name)))
 				continue;
 			link = media_create_intf_link(entity, intf,
-						      MEDIA_LNK_FL_ENABLED);
+						      MEDIA_LNK_FL_ENABLED |
+						      MEDIA_LNK_FL_IMMUTABLE);
 			if (!link)
 				return -ENOMEM;
 		}
@@ -754,14 +757,16 @@ int dvb_create_media_graph(struct dvb_adapter *adap,
 	media_device_for_each_intf(intf, mdev) {
 		if (intf->type == MEDIA_INTF_T_DVB_CA && ca) {
 			link = media_create_intf_link(ca, intf,
-						      MEDIA_LNK_FL_ENABLED);
+						      MEDIA_LNK_FL_ENABLED |
+						      MEDIA_LNK_FL_IMMUTABLE);
 			if (!link)
 				return -ENOMEM;
 		}

 		if (intf->type == MEDIA_INTF_T_DVB_FE && tuner) {
 			link = media_create_intf_link(tuner, intf,
-						      MEDIA_LNK_FL_ENABLED);
+						      MEDIA_LNK_FL_ENABLED |
+						      MEDIA_LNK_FL_IMMUTABLE);
 			if (!link)
 				return -ENOMEM;
 		}
@@ -773,7 +778,8 @@ int dvb_create_media_graph(struct dvb_adapter *adap,
 		 */
 		if (intf->type == MEDIA_INTF_T_DVB_DVR && demux) {
 			link = media_create_intf_link(demux, intf,
-						      MEDIA_LNK_FL_ENABLED);
+						      MEDIA_LNK_FL_ENABLED |
+						      MEDIA_LNK_FL_IMMUTABLE);
 			if (!link)
 				return -ENOMEM;
 		}
diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 4ffd7d60a901..5f43f63fa700 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -808,7 +808,8 @@ static int video_register_media_controller(struct video_device *vdev, int type)

 		link = media_create_intf_link(&vdev->entity,
 					      &vdev->intf_devnode->intf,
-					      MEDIA_LNK_FL_ENABLED);
+					      MEDIA_LNK_FL_ENABLED |
+					      MEDIA_LNK_FL_IMMUTABLE);
 		if (!link) {
 			media_devnode_remove(vdev->intf_devnode);
 			media_device_unregister_entity(&vdev->entity);
diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
index 937c6de85606..3940e55c72f1 100644
--- a/drivers/media/v4l2-core/v4l2-device.c
+++ b/drivers/media/v4l2-core/v4l2-device.c
@@ -267,7 +267,8 @@ int v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev)

 			link = media_create_intf_link(&sd->entity,
 						      &vdev->intf_devnode->intf,
-						      MEDIA_LNK_FL_ENABLED);
+						      MEDIA_LNK_FL_ENABLED |
+						      MEDIA_LNK_FL_IMMUTABLE);
 			if (!link) {
 				err = -ENOMEM;
 				goto clean_up;
