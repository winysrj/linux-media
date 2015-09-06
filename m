Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53839 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbbIFRbf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Sep 2015 13:31:35 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 07/18] [media] dvbdev: returns error if graph object creation fails
Date: Sun,  6 Sep 2015 14:30:50 -0300
Message-Id: <53c51b68fe6dce9073746be61a23cca30c64ac9e.1441559233.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1441559233.git.mchehab@osg.samsung.com>
References: <cover.1441559233.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1441559233.git.mchehab@osg.samsung.com>
References: <cover.1441559233.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Right now, if something gets wrong at dvb_create_media_entity()
or at dvb_create_media_graph(), the device will still be
registered.

Change the logic to properly handle it and free all media graph
objects if something goes wrong at dvb_register_device().

Also, change the logic at dvb_create_media_graph() to return
an error code if something goes wrong. It is up to the
caller to implement the right logic and to call
dvb_unregister_device() to unregister the already-created
objects.

While here, add a missing logic to unregister the created
interfaces.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 5c4fb41060b4..5c51084a331a 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -183,7 +183,29 @@ skip:
 	return -ENFILE;
 }
 
-static void dvb_create_tsout_entity(struct dvb_device *dvbdev,
+static void dvb_media_device_free(struct dvb_device *dvbdev)
+{
+#if defined(CONFIG_MEDIA_CONTROLLER_DVB)
+	if (dvbdev->entity) {
+		int i;
+
+		for (i = 0; i < dvbdev->tsout_num_entities; i++) {
+			media_device_unregister_entity(&dvbdev->tsout_entity[i]);
+			kfree(dvbdev->tsout_entity[i].name);
+		}
+		media_device_unregister_entity(dvbdev->entity);
+
+		kfree(dvbdev->entity);
+		kfree(dvbdev->pads);
+		kfree(dvbdev->tsout_entity);
+		kfree(dvbdev->tsout_pads);
+	}
+	if (dvbdev->intf_devnode)
+		media_devnode_remove(dvbdev->intf_devnode);
+#endif
+}
+
+static int dvb_create_tsout_entity(struct dvb_device *dvbdev,
 				    const char *name, int npads)
 {
 #if defined(CONFIG_MEDIA_CONTROLLER_DVB)
@@ -192,77 +214,60 @@ static void dvb_create_tsout_entity(struct dvb_device *dvbdev,
 	dvbdev->tsout_pads = kcalloc(npads, sizeof(*dvbdev->tsout_pads),
 				     GFP_KERNEL);
 	if (!dvbdev->tsout_pads)
-		return;
+		return -ENOMEM;
+
 	dvbdev->tsout_entity = kcalloc(npads, sizeof(*dvbdev->tsout_entity),
 				       GFP_KERNEL);
-	if (!dvbdev->tsout_entity) {
-		kfree(dvbdev->tsout_pads);
-		dvbdev->tsout_pads = NULL;
-		return;
-	}
+	if (!dvbdev->tsout_entity)
+		return -ENOMEM;
+
 	for (i = 0; i < npads; i++) {
 		struct media_pad *pads = &dvbdev->tsout_pads[i];
 		struct media_entity *entity = &dvbdev->tsout_entity[i];
 
 		entity->name = kasprintf(GFP_KERNEL, "%s #%d", name, i);
-		if (!entity->name) {
-			ret = -ENOMEM;
-			break;
-		}
+		if (!entity->name)
+			return ret;
 
 		entity->type = MEDIA_ENT_T_DVB_TSOUT;
 		pads->flags = MEDIA_PAD_FL_SINK;
 
 		ret = media_entity_init(entity, 1, pads);
 		if (ret < 0)
-			break;
+			return ret;
 
 		ret = media_device_register_entity(dvbdev->adapter->mdev,
 						   entity);
 		if (ret < 0)
-			break;
+			return ret;
 	}
-
-	if (!ret) {
-		dvbdev->tsout_num_entities = npads;
-		return;
-	}
-
-	for (i--; i >= 0; i--) {
-		media_device_unregister_entity(&dvbdev->tsout_entity[i]);
-		kfree(dvbdev->tsout_entity[i].name);
-	}
-
-	printk(KERN_ERR
-		"%s: media_device_register_entity failed for %s\n",
-		__func__, name);
-
-	kfree(dvbdev->tsout_entity);
-	kfree(dvbdev->tsout_pads);
-	dvbdev->tsout_entity = NULL;
-	dvbdev->tsout_pads = NULL;
 #endif
+	return 0;
 }
 
 #define DEMUX_TSOUT	"demux-tsout"
 #define DVR_TSOUT	"dvr-tsout"
 
-static void dvb_create_media_entity(struct dvb_device *dvbdev,
-				    int type, int demux_sink_pads)
+static int dvb_create_media_entity(struct dvb_device *dvbdev,
+				   int type, int demux_sink_pads)
 {
 #if defined(CONFIG_MEDIA_CONTROLLER_DVB)
-	int i, ret = 0, npads;
+	int i, ret, npads;
 
 	switch (type) {
 	case DVB_DEVICE_FRONTEND:
 		npads = 2;
 		break;
 	case DVB_DEVICE_DVR:
-		dvb_create_tsout_entity(dvbdev, DVR_TSOUT, demux_sink_pads);
-		return;
+		ret = dvb_create_tsout_entity(dvbdev, DVR_TSOUT,
+					      demux_sink_pads);
+		return ret;
 	case DVB_DEVICE_DEMUX:
 		npads = 1 + demux_sink_pads;
-		dvb_create_tsout_entity(dvbdev, DEMUX_TSOUT, demux_sink_pads);
+		ret = dvb_create_tsout_entity(dvbdev, DEMUX_TSOUT,
+					      demux_sink_pads);
+		if (ret < 0)
+			return ret;
 		break;
 	case DVB_DEVICE_CA:
 		npads = 2;
@@ -277,24 +282,22 @@ static void dvb_create_media_entity(struct dvb_device *dvbdev,
 		 * the Media Controller, let's not create the decap
 		 * entities yet.
 		 */
-		return;
+		return 0;
 	default:
-		return;
+		return 0;
 	}
 
 	dvbdev->entity = kzalloc(sizeof(*dvbdev->entity), GFP_KERNEL);
 	if (!dvbdev->entity)
-		return;
+		return -ENOMEM;
 
 	dvbdev->entity->name = dvbdev->name;
 
 	if (npads) {
 		dvbdev->pads = kcalloc(npads, sizeof(*dvbdev->pads),
 				       GFP_KERNEL);
-		if (!dvbdev->pads) {
-			kfree(dvbdev->entity);
-			return;
-		}
+		if (!dvbdev->pads)
+			return -ENOMEM;
 	}
 
 	switch (type) {
@@ -316,49 +319,43 @@ static void dvb_create_media_entity(struct dvb_device *dvbdev,
 		break;
 	default:
 		kfree(dvbdev->entity);
+		kfree(dvbdev->pads);
 		dvbdev->entity = NULL;
-		return;
+		return 0;
 	}
 
-	if (npads)
+	if (npads) {
 		ret = media_entity_init(dvbdev->entity, npads, dvbdev->pads);
-	if (!ret)
-		ret = media_device_register_entity(dvbdev->adapter->mdev,
-						   dvbdev->entity);
-	if (ret < 0) {
-		printk(KERN_ERR
-			"%s: media_device_register_entity failed for %s\n",
-			__func__, dvbdev->entity->name);
-
-		media_device_unregister_entity(dvbdev->entity);
-		for (i = 0; i < dvbdev->tsout_num_entities; i++) {
-			media_device_unregister_entity(&dvbdev->tsout_entity[i]);
-			kfree(dvbdev->tsout_entity[i].name);
-		}
-		kfree(dvbdev->pads);
-		kfree(dvbdev->entity);
-		kfree(dvbdev->tsout_pads);
-		kfree(dvbdev->tsout_entity);
-		dvbdev->entity = NULL;
-		return;
+		if (ret)
+			return ret;
 	}
+	ret = media_device_register_entity(dvbdev->adapter->mdev,
+					   dvbdev->entity);
+	if (ret)
+		return (ret);
 
 	printk(KERN_DEBUG "%s: media entity '%s' registered.\n",
 		__func__, dvbdev->entity->name);
+
 #endif
+	return 0;
 }
 
-static void dvb_register_media_device(struct dvb_device *dvbdev,
-				      int type, int minor,
-				      unsigned demux_sink_pads)
+static int dvb_register_media_device(struct dvb_device *dvbdev,
+				     int type, int minor,
+				     unsigned demux_sink_pads)
 {
 #if defined(CONFIG_MEDIA_CONTROLLER_DVB)
+	struct media_link *link;
 	u32 intf_type;
+	int ret;
 
 	if (!dvbdev->adapter->mdev)
-		return;
+		return 0;
 
-	dvb_create_media_entity(dvbdev, type, demux_sink_pads);
+	ret = dvb_create_media_entity(dvbdev, type, demux_sink_pads);
+	if (ret)
+		return ret;
 
 	switch (type) {
 	case DVB_DEVICE_FRONTEND:
@@ -377,13 +374,16 @@ static void dvb_register_media_device(struct dvb_device *dvbdev,
 		intf_type = MEDIA_INTF_T_DVB_NET;
 		break;
 	default:
-		return;
+		return 0;
 	}
 
 	dvbdev->intf_devnode = media_devnode_create(dvbdev->adapter->mdev,
-						 intf_type, 0,
-						 DVB_MAJOR, minor,
-						 GFP_KERNEL);
+						    intf_type, 0,
+						    DVB_MAJOR, minor,
+						    GFP_KERNEL);
+
+	if (!dvbdev->intf_devnode)
+		return -ENOMEM;
 
 	/*
 	 * Create the "obvious" link, e. g. the ones that represent
@@ -393,13 +393,15 @@ static void dvb_register_media_device(struct dvb_device *dvbdev,
 	 *		DVB demux intf -> dvr
 	 */
 
-	if (!dvbdev->entity || !dvbdev->intf_devnode)
-		return;
-
-	media_create_intf_link(dvbdev->entity, &dvbdev->intf_devnode->intf,
-			       MEDIA_LNK_FL_ENABLED);
+	if (!dvbdev->entity)
+		return 0;
 
+	link = media_create_intf_link(dvbdev->entity, &dvbdev->intf_devnode->intf,
+				      MEDIA_LNK_FL_ENABLED);
+	if (!link)
+		return -ENOMEM;
 #endif
+	return 0;
 }
 
 int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
@@ -410,7 +412,7 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
 	struct file_operations *dvbdevfops;
 	struct device *clsdev;
 	int minor;
-	int id;
+	int id, ret;
 
 	mutex_lock(&dvbdev_register_lock);
 
@@ -428,6 +430,17 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
 		return -ENOMEM;
 	}
 
+	ret = dvb_register_media_device(dvbdev, type, minor, demux_sink_pads);
+	if (ret) {
+		printk(KERN_ERR
+		      "%s: dvb_register_media_device failed to create the mediagraph\n",
+		      __func__);
+
+		dvb_media_device_free(dvbdev);
+		mutex_unlock(&dvbdev_register_lock);
+		return ret;
+	}
+
 	dvbdevfops = kzalloc(sizeof(struct file_operations), GFP_KERNEL);
 
 	if (!dvbdevfops){
@@ -483,8 +496,6 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
 	dprintk(KERN_DEBUG "DVB: register adapter%d/%s%d @ minor: %i (0x%02x)\n",
 		adap->num, dnames[type], id, minor, minor);
 
-	dvb_register_media_device(dvbdev, type, minor, demux_sink_pads);
-
 	return 0;
 }
 EXPORT_SYMBOL(dvb_register_device);
@@ -499,25 +510,10 @@ void dvb_unregister_device(struct dvb_device *dvbdev)
 	dvb_minors[dvbdev->minor] = NULL;
 	up_write(&minor_rwsem);
 
+	dvb_media_device_free(dvbdev);
+
 	device_destroy(dvb_class, MKDEV(DVB_MAJOR, dvbdev->minor));
 
-#if defined(CONFIG_MEDIA_CONTROLLER_DVB)
-	if (dvbdev->entity) {
-		int i;
-
-		media_device_unregister_entity(dvbdev->entity);
-		for (i = 0; i < dvbdev->tsout_num_entities; i++) {
-			media_device_unregister_entity(&dvbdev->tsout_entity[i]);
-			kfree(dvbdev->tsout_entity[i].name);
-		}
-
-		kfree(dvbdev->entity);
-		kfree(dvbdev->pads);
-		kfree(dvbdev->tsout_entity);
-		kfree(dvbdev->tsout_pads);
-	}
-#endif
-
 	list_del (&dvbdev->list_head);
 	kfree (dvbdev->fops);
 	kfree (dvbdev);
@@ -526,17 +522,19 @@ EXPORT_SYMBOL(dvb_unregister_device);
 
 
 #ifdef CONFIG_MEDIA_CONTROLLER_DVB
-void dvb_create_media_graph(struct dvb_adapter *adap)
+int dvb_create_media_graph(struct dvb_adapter *adap)
 {
 	struct media_device *mdev = adap->mdev;
 	struct media_entity *entity, *tuner = NULL, *demod = NULL;
 	struct media_entity *demux = NULL, *ca = NULL;
+	struct media_link *link;
 	struct media_interface *intf;
 	unsigned demux_pad = 0;
 	unsigned dvr_pad = 0;
+	int ret;
 
 	if (!mdev)
-		return;
+		return 0;
 
 	media_device_for_each_entity(entity, mdev) {
 		switch (entity->type) {
@@ -555,57 +553,94 @@ void dvb_create_media_graph(struct dvb_adapter *adap)
 		}
 	}
 
-	if (tuner && demod)
-		media_create_pad_link(tuner, TUNER_PAD_IF_OUTPUT, demod, 0, 0);
+	if (tuner && demod) {
+		ret = media_create_pad_link(tuner, TUNER_PAD_IF_OUTPUT,
+					    demod, 0, MEDIA_LNK_FL_ENABLED);
+		if (ret)
+			return ret;
+	}
 
-	if (demod && demux)
-		media_create_pad_link(demod, 1, demux, 0, MEDIA_LNK_FL_ENABLED);
-	if (demux && ca)
-		media_create_pad_link(demux, 1, ca, 0, MEDIA_LNK_FL_ENABLED);
+	if (demod && demux) {
+		ret = media_create_pad_link(demod, 1, demux,
+					    0, MEDIA_LNK_FL_ENABLED);
+		if (ret)
+			return -ENOMEM;
+	}
+	if (demux && ca) {
+		ret = media_create_pad_link(demux, 1, ca,
+					    0, MEDIA_LNK_FL_ENABLED);
+		if (!ret)
+			return -ENOMEM;
+	}
 
 	/* Create demux links for each ringbuffer/pad */
 	if (demux) {
 		media_device_for_each_entity(entity, mdev) {
 			if (entity->type == MEDIA_ENT_T_DVB_TSOUT) {
 				if (!strncmp(entity->name, DVR_TSOUT,
-					strlen(DVR_TSOUT)))
-					media_create_pad_link(demux,
-							      ++dvr_pad,
-							entity, 0, 0);
+				    strlen(DVR_TSOUT))) {
+					ret = media_create_pad_link(demux,
+								++dvr_pad,
+							    entity, 0, 0);
+					if (ret)
+						return ret;
+				}
 				if (!strncmp(entity->name, DEMUX_TSOUT,
-					strlen(DEMUX_TSOUT)))
-					media_create_pad_link(demux,
+				    strlen(DEMUX_TSOUT))) {
+					ret = media_create_pad_link(demux,
 							      ++demux_pad,
-							entity, 0, 0);
+							    entity, 0, 0);
+					if (ret)
+						return ret;
+				}
 			}
 		}
 	}
 
 	/* Create indirect interface links for FE->tuner, DVR->demux and CA->ca */
 	media_device_for_each_intf(intf, mdev) {
-		if (intf->type == MEDIA_INTF_T_DVB_CA && ca)
-			media_create_intf_link(ca, intf, MEDIA_LNK_FL_ENABLED);
+		if (intf->type == MEDIA_INTF_T_DVB_CA && ca) {
+			link = media_create_intf_link(ca, intf,
+						      MEDIA_LNK_FL_ENABLED);
+			if (!link)
+				return -ENOMEM;
+		}
 
-		if (intf->type == MEDIA_INTF_T_DVB_FE && tuner)
-			media_create_intf_link(tuner, intf,
-					       MEDIA_LNK_FL_ENABLED);
+		if (intf->type == MEDIA_INTF_T_DVB_FE && tuner) {
+			link = media_create_intf_link(tuner, intf,
+						      MEDIA_LNK_FL_ENABLED);
+			if (!link)
+				return -ENOMEM;
+		}
 
-		if (intf->type == MEDIA_INTF_T_DVB_DVR && demux)
-			media_create_intf_link(demux, intf,
-					       MEDIA_LNK_FL_ENABLED);
+		if (intf->type == MEDIA_INTF_T_DVB_DVR && demux) {
+			link = media_create_intf_link(demux, intf,
+						      MEDIA_LNK_FL_ENABLED);
+			if (!link)
+				return -ENOMEM;
+		}
 
 		media_device_for_each_entity(entity, mdev) {
 			if (entity->type == MEDIA_ENT_T_DVB_TSOUT) {
-				if (!strcmp(entity->name, DVR_TSOUT))
-					media_create_intf_link(entity, intf,
-							       MEDIA_LNK_FL_ENABLED);
-				if (!strcmp(entity->name, DEMUX_TSOUT))
-					media_create_intf_link(entity, intf,
-							       MEDIA_LNK_FL_ENABLED);
+				if (!strcmp(entity->name, DVR_TSOUT)) {
+					link = media_create_intf_link(entity,
+							intf,
+							MEDIA_LNK_FL_ENABLED);
+					if (!link)
+						return -ENOMEM;
+				}
+				if (!strcmp(entity->name, DEMUX_TSOUT)) {
+					link = media_create_intf_link(entity,
+							intf,
+							MEDIA_LNK_FL_ENABLED);
+					if (!link)
+						return -ENOMEM;
+				}
 				break;
 			}
 		}
 	}
+	return 0;
 }
 EXPORT_SYMBOL_GPL(dvb_create_media_graph);
 #endif
diff --git a/drivers/media/dvb-core/dvbdev.h b/drivers/media/dvb-core/dvbdev.h
index 0b140e8595de..9e24aafeb9ea 100644
--- a/drivers/media/dvb-core/dvbdev.h
+++ b/drivers/media/dvb-core/dvbdev.h
@@ -210,7 +210,7 @@ int dvb_register_device(struct dvb_adapter *adap,
 void dvb_unregister_device(struct dvb_device *dvbdev);
 
 #ifdef CONFIG_MEDIA_CONTROLLER_DVB
-void dvb_create_media_graph(struct dvb_adapter *adap);
+int dvb_create_media_graph(struct dvb_adapter *adap);
 static inline void dvb_register_media_controller(struct dvb_adapter *adap,
 						 struct media_device *mdev)
 {
@@ -218,7 +218,10 @@ static inline void dvb_register_media_controller(struct dvb_adapter *adap,
 }
 
 #else
-static inline void dvb_create_media_graph(struct dvb_adapter *adap) {}
+static inline int dvb_create_media_graph(struct dvb_adapter *adap)
+{
+	return 0;
+};
 #define dvb_register_media_controller(a, b) {}
 #endif
 
-- 
2.4.3


