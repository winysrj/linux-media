Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49407 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877AbbBMW6T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2015 17:58:19 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCHv4 14/25] [media] dvbdev: add pad for the DVB devnodes
Date: Fri, 13 Feb 2015 20:57:57 -0200
Message-Id: <ae0d3cd4580a18176edce68fd57288eda217c436.1423867976.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1423867976.git.mchehab@osg.samsung.com>
References: <cover.1423867976.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1423867976.git.mchehab@osg.samsung.com>
References: <cover.1423867976.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We want to represent the links between the several DVB devnodes,
so let's create PADs for them.

The DVB net devnode is a different matter, as it is not related
to the media stream, but with network. So, at least for now, let's
not add any pad for it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index f98fd3b29afe..79c96edf71ef 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -184,7 +184,7 @@ static void dvb_register_media_device(struct dvb_device *dvbdev,
 				      int type, int minor)
 {
 #if defined(CONFIG_MEDIA_CONTROLLER_DVB)
-	int ret;
+	int ret = 0, npads;
 
 	if (!dvbdev->adapter->mdev)
 		return;
@@ -196,18 +196,46 @@ static void dvb_register_media_device(struct dvb_device *dvbdev,
 	dvbdev->entity->info.dev.major = DVB_MAJOR;
 	dvbdev->entity->info.dev.minor = minor;
 	dvbdev->entity->name = dvbdev->name;
+
+	switch (type) {
+	case DVB_DEVICE_CA:
+	case DVB_DEVICE_DEMUX:
+		npads = 2;
+		break;
+	case DVB_DEVICE_NET:
+		npads = 0;
+		break;
+	default:
+		npads = 1;
+	}
+
+	if (npads) {
+		dvbdev->pads = kcalloc(npads, sizeof(*dvbdev->pads),
+				       GFP_KERNEL);
+		if (!dvbdev->pads) {
+			kfree(dvbdev->entity);
+			return;
+		}
+	}
+
 	switch (type) {
 	case DVB_DEVICE_FRONTEND:
 		dvbdev->entity->type = MEDIA_ENT_T_DEVNODE_DVB_FE;
+		dvbdev->pads[0].flags = MEDIA_PAD_FL_SOURCE;
 		break;
 	case DVB_DEVICE_DEMUX:
 		dvbdev->entity->type = MEDIA_ENT_T_DEVNODE_DVB_DEMUX;
+		dvbdev->pads[0].flags = MEDIA_PAD_FL_SOURCE;
+		dvbdev->pads[1].flags = MEDIA_PAD_FL_SINK;
 		break;
 	case DVB_DEVICE_DVR:
 		dvbdev->entity->type = MEDIA_ENT_T_DEVNODE_DVB_DVR;
+		dvbdev->pads[0].flags = MEDIA_PAD_FL_SINK;
 		break;
 	case DVB_DEVICE_CA:
 		dvbdev->entity->type = MEDIA_ENT_T_DEVNODE_DVB_CA;
+		dvbdev->pads[0].flags = MEDIA_PAD_FL_SOURCE;
+		dvbdev->pads[1].flags = MEDIA_PAD_FL_SINK;
 		break;
 	case DVB_DEVICE_NET:
 		dvbdev->entity->type = MEDIA_ENT_T_DEVNODE_DVB_NET;
@@ -218,12 +246,16 @@ static void dvb_register_media_device(struct dvb_device *dvbdev,
 		return;
 	}
 
-	ret = media_device_register_entity(dvbdev->adapter->mdev,
-					   dvbdev->entity);
+	if (npads)
+		ret = media_entity_init(dvbdev->entity, npads, dvbdev->pads, 0);
+	if (!ret)
+		ret = media_device_register_entity(dvbdev->adapter->mdev,
+						   dvbdev->entity);
 	if (ret < 0) {
 		printk(KERN_ERR
 			"%s: media_device_register_entity failed for %s\n",
 			__func__, dvbdev->entity->name);
+		kfree(dvbdev->pads);
 		kfree(dvbdev->entity);
 		dvbdev->entity = NULL;
 		return;
@@ -336,6 +368,7 @@ void dvb_unregister_device(struct dvb_device *dvbdev)
 	if (dvbdev->entity) {
 		media_device_unregister_entity(dvbdev->entity);
 		kfree(dvbdev->entity);
+		kfree(dvbdev->pads);
 	}
 #endif
 
diff --git a/drivers/media/dvb-core/dvbdev.h b/drivers/media/dvb-core/dvbdev.h
index 485d8e660aea..464067c43a35 100644
--- a/drivers/media/dvb-core/dvbdev.h
+++ b/drivers/media/dvb-core/dvbdev.h
@@ -101,8 +101,9 @@ struct dvb_device {
 #if defined(CONFIG_MEDIA_CONTROLLER_DVB)
 	const char *name;
 
-	/* Filled inside dvbdev.c */
+	/* Allocated and filled inside dvbdev.c */
 	struct media_entity *entity;
+	struct media_pad *pads;
 #endif
 
 	void *priv;
-- 
2.1.0

