Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54661 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbbIFMD7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Sep 2015 08:03:59 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Markus Elfring <elfring@users.sourceforge.net>,
	Jonathan Corbet <corbet@lwn.net>,
	Akihiro Tsukada <tskd08@gmail.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Tina Ruchandani <ruchandani.tina@gmail.com>,
	Antti Palosaari <crope@iki.fi>, Joe Perches <joe@perches.com>,
	"David S. Miller" <davem@davemloft.net>,
	Vaishali Thakkar <vthakkar1994@gmail.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Takeshi Yoshimura <yos@sslab.ics.keio.ac.jp>,
	linux1394-devel@lists.sourceforge.net
Subject: Re: [PATCH v8 42/55] [media] dvb: modify core to implement interfaces/entities at MC new gen
Date: Sun,  6 Sep 2015 09:03:02 -0300
Message-Id: <b753f6eee1f38b7f20228807a2ee9ffd05fe45cb.1441540862.git.mchehab@osg.samsung.com>
In-Reply-To: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com>
References: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com>
In-Reply-To: <13388f87683ec54554a57235d8ecc2713c740087.1440902901.git.mchehab@osg.samsung.com>
References: <13388f87683ec54554a57235d8ecc2713c740087.1440902901.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Media Controller New Generation redefines the types for both
interfaces and entities to be used on DVB. Make the needed
changes at the DVB core for all interfaces, entities and
data and interface links to appear in the graph.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index d0e3f9d85f34..baaed28ee975 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -1242,9 +1242,9 @@ int dvb_dmxdev_init(struct dmxdev *dmxdev, struct dvb_adapter *dvb_adapter)
 	}
 
 	dvb_register_device(dvb_adapter, &dmxdev->dvbdev, &dvbdev_demux, dmxdev,
-			    DVB_DEVICE_DEMUX);
+			    DVB_DEVICE_DEMUX, dmxdev->filternum);
 	dvb_register_device(dvb_adapter, &dmxdev->dvr_dvbdev, &dvbdev_dvr,
-			    dmxdev, DVB_DEVICE_DVR);
+			    dmxdev, DVB_DEVICE_DVR, dmxdev->filternum);
 
 	dvb_ringbuffer_init(&dmxdev->dvr_buffer, NULL, 8192);
 
diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index fb66184dc9b6..f82cd1ff4f3a 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -1695,7 +1695,7 @@ int dvb_ca_en50221_init(struct dvb_adapter *dvb_adapter,
 	pubca->private = ca;
 
 	/* register the DVB device */
-	ret = dvb_register_device(dvb_adapter, &ca->dvbdev, &dvbdev_ca, ca, DVB_DEVICE_CA);
+	ret = dvb_register_device(dvb_adapter, &ca->dvbdev, &dvbdev_ca, ca, DVB_DEVICE_CA, 0);
 	if (ret)
 		goto free_slot_info;
 
diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 2d06bcff0946..58601bfe0b8d 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2754,7 +2754,7 @@ int dvb_register_frontend(struct dvb_adapter* dvb,
 			fe->dvb->num, fe->id, fe->ops.info.name);
 
 	dvb_register_device (fe->dvb, &fepriv->dvbdev, &dvbdev_template,
-			     fe, DVB_DEVICE_FRONTEND);
+			     fe, DVB_DEVICE_FRONTEND, 0);
 
 	/*
 	 * Initialize the cache to the proper values according with the
diff --git a/drivers/media/dvb-core/dvb_net.c b/drivers/media/dvb-core/dvb_net.c
index b81e026edab3..14f51b68f4fe 100644
--- a/drivers/media/dvb-core/dvb_net.c
+++ b/drivers/media/dvb-core/dvb_net.c
@@ -1503,6 +1503,6 @@ int dvb_net_init (struct dvb_adapter *adap, struct dvb_net *dvbnet,
 		dvbnet->state[i] = 0;
 
 	return dvb_register_device(adap, &dvbnet->dvbdev, &dvbdev_net,
-			     dvbnet, DVB_DEVICE_NET);
+			     dvbnet, DVB_DEVICE_NET, 0);
 }
 EXPORT_SYMBOL(dvb_net_init);
diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index dadcf1655070..6babc688801b 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -180,18 +180,86 @@ skip:
 	return -ENFILE;
 }
 
+static void dvb_create_tsout_entity(struct dvb_device *dvbdev,
+				    const char *name, int npads)
+{
+#if defined(CONFIG_MEDIA_CONTROLLER_DVB)
+	int i, ret = 0;
+
+	dvbdev->tsout_pads = kcalloc(npads, sizeof(*dvbdev->tsout_pads),
+				     GFP_KERNEL);
+	if (!dvbdev->tsout_pads)
+		return;
+	dvbdev->tsout_entity = kcalloc(npads, sizeof(*dvbdev->tsout_entity),
+				       GFP_KERNEL);
+	if (!dvbdev->tsout_entity) {
+		kfree(dvbdev->tsout_pads);
+		dvbdev->tsout_pads = NULL;
+		return;
+	}
+	for (i = 0; i < npads; i++) {
+		struct media_pad *pads = &dvbdev->tsout_pads[i];
+		struct media_entity *entity = &dvbdev->tsout_entity[i];
+
+		entity->name = kasprintf(GFP_KERNEL, "%s #%d", name, i);
+		if (!entity->name) {
+			ret = -ENOMEM;
+			break;
+		}
+
+		entity->type = MEDIA_ENT_T_DVB_TSOUT;
+		pads->flags = MEDIA_PAD_FL_SINK;
+
+		ret = media_entity_init(entity, 1, pads);
+		if (ret < 0)
+			break;
+
+		ret = media_device_register_entity(dvbdev->adapter->mdev,
+						   entity);
+		if (ret < 0)
+			break;
+	}
+
+	if (!ret) {
+		dvbdev->tsout_num_entities = npads;
+		return;
+	}
+
+	for (i--; i >= 0; i--) {
+		media_device_unregister_entity(&dvbdev->tsout_entity[i]);
+		kfree(dvbdev->tsout_entity[i].name);
+	}
+
+	printk(KERN_ERR
+		"%s: media_device_register_entity failed for %s\n",
+		__func__, name);
+
+	kfree(dvbdev->tsout_entity);
+	kfree(dvbdev->tsout_pads);
+	dvbdev->tsout_entity = NULL;
+	dvbdev->tsout_pads = NULL;
+#endif
+}
+
+#define DEMUX_TSOUT	"demux-tsout"
+#define DVR_TSOUT	"dvr-tsout"
+
 static void dvb_create_media_entity(struct dvb_device *dvbdev,
-				       int type, int minor)
+				    int type, int demux_sink_pads)
 {
 #if defined(CONFIG_MEDIA_CONTROLLER_DVB)
-	int ret = 0, npads;
+	int i, ret = 0, npads;
 
 	switch (type) {
 	case DVB_DEVICE_FRONTEND:
 		npads = 2;
 		break;
+	case DVB_DEVICE_DVR:
+		dvb_create_tsout_entity(dvbdev, DVR_TSOUT, demux_sink_pads);
+		return;
 	case DVB_DEVICE_DEMUX:
-		npads = 2;
+		npads = 1 + demux_sink_pads;
+		dvb_create_tsout_entity(dvbdev, DEMUX_TSOUT, demux_sink_pads);
 		break;
 	case DVB_DEVICE_CA:
 		npads = 2;
@@ -215,8 +283,6 @@ static void dvb_create_media_entity(struct dvb_device *dvbdev,
 	if (!dvbdev->entity)
 		return;
 
-	dvbdev->entity->info.dev.major = DVB_MAJOR;
-	dvbdev->entity->info.dev.minor = minor;
 	dvbdev->entity->name = dvbdev->name;
 
 	if (npads) {
@@ -237,7 +303,8 @@ static void dvb_create_media_entity(struct dvb_device *dvbdev,
 	case DVB_DEVICE_DEMUX:
 		dvbdev->entity->type = MEDIA_ENT_T_DVB_DEMUX;
 		dvbdev->pads[0].flags = MEDIA_PAD_FL_SINK;
-		dvbdev->pads[1].flags = MEDIA_PAD_FL_SOURCE;
+		for (i = 1; i < npads; i++)
+			dvbdev->pads[i].flags = MEDIA_PAD_FL_SOURCE;
 		break;
 	case DVB_DEVICE_CA:
 		dvbdev->entity->type = MEDIA_ENT_T_DVB_CA;
@@ -259,8 +326,16 @@ static void dvb_create_media_entity(struct dvb_device *dvbdev,
 		printk(KERN_ERR
 			"%s: media_device_register_entity failed for %s\n",
 			__func__, dvbdev->entity->name);
+
+		media_device_unregister_entity(dvbdev->entity);
+		for (i = 0; i < dvbdev->tsout_num_entities; i++) {
+			media_device_unregister_entity(&dvbdev->tsout_entity[i]);
+			kfree(dvbdev->tsout_entity[i].name);
+		}
 		kfree(dvbdev->pads);
 		kfree(dvbdev->entity);
+		kfree(dvbdev->tsout_pads);
+		kfree(dvbdev->tsout_entity);
 		dvbdev->entity = NULL;
 		return;
 	}
@@ -271,7 +346,8 @@ static void dvb_create_media_entity(struct dvb_device *dvbdev,
 }
 
 static void dvb_register_media_device(struct dvb_device *dvbdev,
-				      int type, int minor)
+				      int type, int minor,
+				      unsigned demux_sink_pads)
 {
 #if defined(CONFIG_MEDIA_CONTROLLER_DVB)
 	u32 intf_type;
@@ -279,7 +355,7 @@ static void dvb_register_media_device(struct dvb_device *dvbdev,
 	if (!dvbdev->adapter->mdev)
 		return;
 
-	dvb_create_media_entity(dvbdev, type, minor);
+	dvb_create_media_entity(dvbdev, type, demux_sink_pads);
 
 	switch (type) {
 	case DVB_DEVICE_FRONTEND:
@@ -323,7 +399,8 @@ static void dvb_register_media_device(struct dvb_device *dvbdev,
 }
 
 int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
-			const struct dvb_device *template, void *priv, int type)
+			const struct dvb_device *template, void *priv, int type,
+			int demux_sink_pads)
 {
 	struct dvb_device *dvbdev;
 	struct file_operations *dvbdevfops;
@@ -402,7 +479,7 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
 	dprintk(KERN_DEBUG "DVB: register adapter%d/%s%d @ minor: %i (0x%02x)\n",
 		adap->num, dnames[type], id, minor, minor);
 
-	dvb_register_media_device(dvbdev, type, minor);
+	dvb_register_media_device(dvbdev, type, minor, demux_sink_pads);
 
 	return 0;
 }
@@ -422,9 +499,18 @@ void dvb_unregister_device(struct dvb_device *dvbdev)
 
 #if defined(CONFIG_MEDIA_CONTROLLER_DVB)
 	if (dvbdev->entity) {
+		int i;
+
 		media_device_unregister_entity(dvbdev->entity);
+		for (i = 0; i < dvbdev->tsout_num_entities; i++) {
+			media_device_unregister_entity(&dvbdev->tsout_entity[i]);
+			kfree(dvbdev->tsout_entity[i].name);
+		}
+
 		kfree(dvbdev->entity);
 		kfree(dvbdev->pads);
+		kfree(dvbdev->tsout_entity);
+		kfree(dvbdev->tsout_pads);
 	}
 #endif
 
@@ -440,8 +526,10 @@ void dvb_create_media_graph(struct dvb_adapter *adap)
 {
 	struct media_device *mdev = adap->mdev;
 	struct media_entity *entity, *tuner = NULL, *demod = NULL;
-	struct media_entity *demux = NULL, *dvr = NULL, *ca = NULL;
+	struct media_entity *demux = NULL, *ca = NULL;
 	struct media_interface *intf;
+	unsigned demux_pad = 0;
+	unsigned dvr_pad = 0;
 
 	if (!mdev)
 		return;
@@ -457,9 +545,6 @@ void dvb_create_media_graph(struct dvb_adapter *adap)
 		case MEDIA_ENT_T_DVB_DEMUX:
 			demux = entity;
 			break;
-		case MEDIA_ENT_T_DVB_TSOUT:
-			dvr = entity;
-			break;
 		case MEDIA_ENT_T_DVB_CA:
 			ca = entity;
 			break;
@@ -471,21 +556,46 @@ void dvb_create_media_graph(struct dvb_adapter *adap)
 
 	if (demod && demux)
 		media_create_pad_link(demod, 1, demux, 0, MEDIA_LNK_FL_ENABLED);
-
-	if (demux && dvr)
-		media_create_pad_link(demux, 1, dvr, 0, MEDIA_LNK_FL_ENABLED);
-
 	if (demux && ca)
 		media_create_pad_link(demux, 1, ca, 0, MEDIA_LNK_FL_ENABLED);
 
+	/* Create demux links for each ringbuffer/pad */
+	if (demux) {
+		media_device_for_each_entity(entity, mdev) {
+			if (entity->type == MEDIA_ENT_T_DVB_TSOUT) {
+				if (!strncmp(entity->name, DVR_TSOUT,
+					strlen(DVR_TSOUT)))
+					media_create_pad_link(demux,
+							      ++dvr_pad,
+							entity, 0, 0);
+				if (!strncmp(entity->name, DEMUX_TSOUT,
+					strlen(DEMUX_TSOUT)))
+					media_create_pad_link(demux,
+							      ++demux_pad,
+							entity, 0, 0);
+			}
+		}
+	}
+
 	/* Create indirect interface links for FE->tuner, DVR->demux and CA->ca */
 	list_for_each_entry(intf, &mdev->interfaces, list) {
 		if (intf->type == MEDIA_INTF_T_DVB_CA && ca)
 			media_create_intf_link(ca, intf, 0);
 		if (intf->type == MEDIA_INTF_T_DVB_FE && tuner)
 			media_create_intf_link(tuner, intf, 0);
+
 		if (intf->type == MEDIA_INTF_T_DVB_DVR && demux)
 			media_create_intf_link(demux, intf, 0);
+
+		media_device_for_each_entity(entity, mdev) {
+			if (entity->type == MEDIA_ENT_T_DVB_TSOUT) {
+				if (!strcmp(entity->name, DVR_TSOUT))
+					media_create_intf_link(entity, intf, 0);
+				if (!strcmp(entity->name, DEMUX_TSOUT))
+					media_create_intf_link(entity, intf, 0);
+				break;
+			}
+		}
 	}
 }
 EXPORT_SYMBOL_GPL(dvb_create_media_graph);
diff --git a/drivers/media/dvb-core/dvbdev.h b/drivers/media/dvb-core/dvbdev.h
index 5f37b4dd1e69..0b140e8595de 100644
--- a/drivers/media/dvb-core/dvbdev.h
+++ b/drivers/media/dvb-core/dvbdev.h
@@ -148,9 +148,11 @@ struct dvb_device {
 	const char *name;
 
 	/* Allocated and filled inside dvbdev.c */
-	struct media_entity *entity;
 	struct media_intf_devnode *intf_devnode;
-	struct media_pad *pads;
+
+	unsigned tsout_num_entities;
+	struct media_entity *entity, *tsout_entity;
+	struct media_pad *pads, *tsout_pads;
 #endif
 
 	void *priv;
@@ -197,7 +199,8 @@ int dvb_register_device(struct dvb_adapter *adap,
 			struct dvb_device **pdvbdev,
 			const struct dvb_device *template,
 			void *priv,
-			int type);
+			int type,
+			int demux_sink_pads);
 
 /**
  * dvb_unregister_device - Unregisters a DVB device
diff --git a/drivers/media/firewire/firedtv-ci.c b/drivers/media/firewire/firedtv-ci.c
index e63f582378bf..edbb30fdd9d9 100644
--- a/drivers/media/firewire/firedtv-ci.c
+++ b/drivers/media/firewire/firedtv-ci.c
@@ -241,7 +241,7 @@ int fdtv_ca_register(struct firedtv *fdtv)
 		return -EFAULT;
 
 	err = dvb_register_device(&fdtv->adapter, &fdtv->cadev,
-				  &fdtv_ca, fdtv, DVB_DEVICE_CA);
+				  &fdtv_ca, fdtv, DVB_DEVICE_CA, 0);
 
 	if (stat.ca_application_info == 0)
 		dev_err(fdtv->device, "CaApplicationInfo is not set\n");
diff --git a/drivers/media/pci/bt8xx/dst_ca.c b/drivers/media/pci/bt8xx/dst_ca.c
index c5cc14ef8347..0149a9ed6e58 100644
--- a/drivers/media/pci/bt8xx/dst_ca.c
+++ b/drivers/media/pci/bt8xx/dst_ca.c
@@ -705,7 +705,8 @@ struct dvb_device *dst_ca_attach(struct dst_state *dst, struct dvb_adapter *dvb_
 	struct dvb_device *dvbdev;
 
 	dprintk(verbose, DST_CA_ERROR, 1, "registering DST-CA device");
-	if (dvb_register_device(dvb_adapter, &dvbdev, &dvbdev_ca, dst, DVB_DEVICE_CA) == 0) {
+	if (dvb_register_device(dvb_adapter, &dvbdev, &dvbdev_ca, dst,
+			        DVB_DEVICE_CA, 0) == 0) {
 		dst->dst_ca = dvbdev;
 		return dst->dst_ca;
 	}
diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 0ac2dd35fe50..4caca5df2931 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -1065,7 +1065,7 @@ static int ddb_ci_attach(struct ddb_port *port)
 			    port->en, 0, 1);
 	ret = dvb_register_device(&port->output->adap, &port->output->dev,
 				  &dvbdev_ci, (void *) port->output,
-				  DVB_DEVICE_SEC);
+				  DVB_DEVICE_SEC, 0);
 	return ret;
 }
 
diff --git a/drivers/media/pci/ngene/ngene-core.c b/drivers/media/pci/ngene/ngene-core.c
index 1b92d836a564..4e924e2d1638 100644
--- a/drivers/media/pci/ngene/ngene-core.c
+++ b/drivers/media/pci/ngene/ngene-core.c
@@ -1513,7 +1513,7 @@ static int init_channel(struct ngene_channel *chan)
 		set_transfer(&chan->dev->channel[2], 1);
 		dvb_register_device(adapter, &chan->ci_dev,
 				    &ngene_dvbdev_ci, (void *) chan,
-				    DVB_DEVICE_SEC);
+				    DVB_DEVICE_SEC, 0);
 		if (!chan->ci_dev)
 			goto err;
 	}
diff --git a/drivers/media/pci/ttpci/av7110.c b/drivers/media/pci/ttpci/av7110.c
index 3f24fce74fc1..63f1d56bdfb2 100644
--- a/drivers/media/pci/ttpci/av7110.c
+++ b/drivers/media/pci/ttpci/av7110.c
@@ -1361,7 +1361,7 @@ static int av7110_register(struct av7110 *av7110)
 
 #ifdef CONFIG_DVB_AV7110_OSD
 	dvb_register_device(&av7110->dvb_adapter, &av7110->osd_dev,
-			    &dvbdev_osd, av7110, DVB_DEVICE_OSD);
+			    &dvbdev_osd, av7110, DVB_DEVICE_OSD, 0);
 #endif
 
 	dvb_net_init(&av7110->dvb_adapter, &av7110->dvb_net, &dvbdemux->dmx);
diff --git a/drivers/media/pci/ttpci/av7110_av.c b/drivers/media/pci/ttpci/av7110_av.c
index 9544cfc06601..da11501fe5d2 100644
--- a/drivers/media/pci/ttpci/av7110_av.c
+++ b/drivers/media/pci/ttpci/av7110_av.c
@@ -1589,10 +1589,10 @@ int av7110_av_register(struct av7110 *av7110)
 	memset(&av7110->video_size, 0, sizeof (video_size_t));
 
 	dvb_register_device(&av7110->dvb_adapter, &av7110->video_dev,
-			    &dvbdev_video, av7110, DVB_DEVICE_VIDEO);
+			    &dvbdev_video, av7110, DVB_DEVICE_VIDEO, 0);
 
 	dvb_register_device(&av7110->dvb_adapter, &av7110->audio_dev,
-			    &dvbdev_audio, av7110, DVB_DEVICE_AUDIO);
+			    &dvbdev_audio, av7110, DVB_DEVICE_AUDIO, 0);
 
 	return 0;
 }
diff --git a/drivers/media/pci/ttpci/av7110_ca.c b/drivers/media/pci/ttpci/av7110_ca.c
index a6079b90252a..235f0202dc7e 100644
--- a/drivers/media/pci/ttpci/av7110_ca.c
+++ b/drivers/media/pci/ttpci/av7110_ca.c
@@ -378,7 +378,7 @@ static struct dvb_device dvbdev_ca = {
 int av7110_ca_register(struct av7110 *av7110)
 {
 	return dvb_register_device(&av7110->dvb_adapter, &av7110->ca_dev,
-				   &dvbdev_ca, av7110, DVB_DEVICE_CA);
+				   &dvbdev_ca, av7110, DVB_DEVICE_CA, 0);
 }
 
 void av7110_ca_unregister(struct av7110 *av7110)
-- 
2.4.3


