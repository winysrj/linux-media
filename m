Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48426 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbbH3DHt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Aug 2015 23:07:49 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v8 25/55] [media] dvbdev: add support for interfaces
Date: Sun, 30 Aug 2015 00:06:36 -0300
Message-Id: <b43ac3b0574f7ca0e88867cd39f12fb6c30c97db.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that the infrastruct for that is set, add support for
interfaces.

Please notice that we're missing two links:
	DVB FE intf    -> tuner
	DVB demux intf -> dvr

Those should be added latter, after having the entire graph
set. With the current infrastructure, those should be added
at dvb_create_media_graph(), but it would also require some
extra core changes, to allow the function to enumerate the
interfaces.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 65f59f2124b4..6bf61d42c017 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -180,14 +180,36 @@ skip:
 	return -ENFILE;
 }
 
-static void dvb_register_media_device(struct dvb_device *dvbdev,
-				      int type, int minor)
+static void dvb_create_media_entity(struct dvb_device *dvbdev,
+				       int type, int minor)
 {
 #if defined(CONFIG_MEDIA_CONTROLLER_DVB)
 	int ret = 0, npads;
 
-	if (!dvbdev->adapter->mdev)
+	switch (type) {
+	case DVB_DEVICE_FRONTEND:
+		npads = 2;
+		break;
+	case DVB_DEVICE_DEMUX:
+		npads = 2;
+		break;
+	case DVB_DEVICE_CA:
+		npads = 2;
+		break;
+	case DVB_DEVICE_NET:
+		/*
+		 * We should be creating entities for the MPE/ULE
+		 * decapsulation hardware (or software implementation).
+		 *
+		 * However, the number of for the MPE/ULE decaps may not be
+		 * fixed. As we don't have yet dynamic support for PADs at
+		 * the Media Controller, let's not create the decap
+		 * entities yet.
+		 */
 		return;
+	default:
+		return;
+	}
 
 	dvbdev->entity = kzalloc(sizeof(*dvbdev->entity), GFP_KERNEL);
 	if (!dvbdev->entity)
@@ -197,19 +219,6 @@ static void dvb_register_media_device(struct dvb_device *dvbdev,
 	dvbdev->entity->info.dev.minor = minor;
 	dvbdev->entity->name = dvbdev->name;
 
-	switch (type) {
-	case DVB_DEVICE_CA:
-	case DVB_DEVICE_DEMUX:
-	case DVB_DEVICE_FRONTEND:
-		npads = 2;
-		break;
-	case DVB_DEVICE_NET:
-		npads = 0;
-		break;
-	default:
-		npads = 1;
-	}
-
 	if (npads) {
 		dvbdev->pads = kcalloc(npads, sizeof(*dvbdev->pads),
 				       GFP_KERNEL);
@@ -230,18 +239,11 @@ static void dvb_register_media_device(struct dvb_device *dvbdev,
 		dvbdev->pads[0].flags = MEDIA_PAD_FL_SINK;
 		dvbdev->pads[1].flags = MEDIA_PAD_FL_SOURCE;
 		break;
-	case DVB_DEVICE_DVR:
-		dvbdev->entity->type = MEDIA_ENT_T_DEVNODE_DVB_DVR;
-		dvbdev->pads[0].flags = MEDIA_PAD_FL_SINK;
-		break;
 	case DVB_DEVICE_CA:
 		dvbdev->entity->type = MEDIA_ENT_T_DEVNODE_DVB_CA;
 		dvbdev->pads[0].flags = MEDIA_PAD_FL_SINK;
 		dvbdev->pads[1].flags = MEDIA_PAD_FL_SOURCE;
 		break;
-	case DVB_DEVICE_NET:
-		dvbdev->entity->type = MEDIA_ENT_T_DEVNODE_DVB_NET;
-		break;
 	default:
 		kfree(dvbdev->entity);
 		dvbdev->entity = NULL;
@@ -263,11 +265,63 @@ static void dvb_register_media_device(struct dvb_device *dvbdev,
 		return;
 	}
 
-	printk(KERN_DEBUG "%s: media device '%s' registered.\n",
+	printk(KERN_DEBUG "%s: media entity '%s' registered.\n",
 		__func__, dvbdev->entity->name);
 #endif
 }
 
+static void dvb_register_media_device(struct dvb_device *dvbdev,
+				      int type, int minor)
+{
+#if defined(CONFIG_MEDIA_CONTROLLER_DVB)
+	u32 intf_type;
+
+	if (!dvbdev->adapter->mdev)
+		return;
+
+	dvb_create_media_entity(dvbdev, type, minor);
+
+	switch (type) {
+	case DVB_DEVICE_FRONTEND:
+		intf_type = MEDIA_INTF_T_DVB_FE;
+		break;
+	case DVB_DEVICE_DEMUX:
+		intf_type = MEDIA_INTF_T_DVB_DEMUX;
+		break;
+	case DVB_DEVICE_DVR:
+		intf_type = MEDIA_INTF_T_DVB_DVR;
+		break;
+	case DVB_DEVICE_CA:
+		intf_type = MEDIA_INTF_T_DVB_CA;
+		break;
+	case DVB_DEVICE_NET:
+		intf_type = MEDIA_INTF_T_DVB_NET;
+		break;
+	default:
+		return;
+	}
+
+	dvbdev->intf_devnode = media_devnode_create(dvbdev->adapter->mdev,
+						 intf_type, 0,
+						 DVB_MAJOR, minor,
+						 GFP_KERNEL);
+
+	/*
+	 * Create the "obvious" link, e. g. the ones that represent
+	 * a direct association between an interface and an entity.
+	 * Other links should be created elsewhere, like:
+	 *		DVB FE intf    -> tuner
+	 *		DVB demux intf -> dvr
+	 */
+
+	if (!dvbdev->entity || !dvbdev->intf_devnode)
+		return;
+
+	media_create_intf_link(dvbdev->entity, &dvbdev->intf_devnode->intf, 0);
+
+#endif
+}
+
 int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
 			const struct dvb_device *template, void *priv, int type)
 {
diff --git a/drivers/media/dvb-core/dvbdev.h b/drivers/media/dvb-core/dvbdev.h
index c61a4f03a66f..5f37b4dd1e69 100644
--- a/drivers/media/dvb-core/dvbdev.h
+++ b/drivers/media/dvb-core/dvbdev.h
@@ -149,6 +149,7 @@ struct dvb_device {
 
 	/* Allocated and filled inside dvbdev.c */
 	struct media_entity *entity;
+	struct media_intf_devnode *intf_devnode;
 	struct media_pad *pads;
 #endif
 
-- 
2.4.3

