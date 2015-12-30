Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52503 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801AbbL3Ntl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Dec 2015 08:49:41 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Jonathan Corbet <corbet@lwn.net>,
	=?UTF-8?q?Rafael=20Louren=C3=A7o=20de=20Lima=20Chehab?=
	<chehabrafael@gmail.com>, Olli Salonen <olli.salonen@iki.fi>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Luis de Bethencourt <luis@debethencourt.com>
Subject: [PATCH 2/6] [media] dvbdev: Add RF connector if needed
Date: Wed, 30 Dec 2015 11:48:52 -0200
Message-Id: <879ba93734fa3538720cfa814991c832d971ffa5.1451482760.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1451482760.git.mchehab@osg.samsung.com>
References: <cover.1451482760.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1451482760.git.mchehab@osg.samsung.com>
References: <cover.1451482760.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Several pure digital TV devices have a frontend with the tuner
integrated on it. Add the RF connector when dvb_create_media_graph()
is called on such devices.

Tested with siano and dvb_usb_mxl111sf drivers.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/common/siano/smsdvb-main.c    |  2 +-
 drivers/media/dvb-core/dvbdev.c             | 49 +++++++++++++++++++++++++++--
 drivers/media/dvb-core/dvbdev.h             | 20 ++++++++++--
 drivers/media/usb/au0828/au0828-dvb.c       |  2 +-
 drivers/media/usb/cx231xx/cx231xx-dvb.c     |  2 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c |  2 +-
 drivers/media/usb/dvb-usb/dvb-usb-dvb.c     |  2 +-
 7 files changed, 70 insertions(+), 9 deletions(-)

diff --git a/drivers/media/common/siano/smsdvb-main.c b/drivers/media/common/siano/smsdvb-main.c
index 8a1ea2192439..d31f468830cf 100644
--- a/drivers/media/common/siano/smsdvb-main.c
+++ b/drivers/media/common/siano/smsdvb-main.c
@@ -1184,7 +1184,7 @@ static int smsdvb_hotplug(struct smscore_device_t *coredev,
 	if (smsdvb_debugfs_create(client) < 0)
 		pr_info("failed to create debugfs node\n");
 
-	rc = dvb_create_media_graph(&client->adapter);
+	rc = dvb_create_media_graph(&client->adapter, true);
 	if (rc < 0) {
 		pr_err("dvb_create_media_graph failed %d\n", rc);
 		goto client_error;
diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 860dd7d06b60..28e340583ede 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -213,6 +213,13 @@ static void dvb_media_device_free(struct dvb_device *dvbdev)
 		media_devnode_remove(dvbdev->intf_devnode);
 		dvbdev->intf_devnode = NULL;
 	}
+
+	if (dvbdev->adapter->conn) {
+		media_device_unregister_entity(dvbdev->adapter->conn);
+		dvbdev->adapter->conn = NULL;
+		kfree(dvbdev->adapter->conn_pads);
+		dvbdev->adapter->conn_pads = NULL;
+	}
 #endif
 }
 
@@ -559,16 +566,18 @@ static int dvb_create_io_intf_links(struct dvb_adapter *adap,
 	return 0;
 }
 
-int dvb_create_media_graph(struct dvb_adapter *adap)
+int dvb_create_media_graph(struct dvb_adapter *adap,
+			   bool create_rf_connector)
 {
 	struct media_device *mdev = adap->mdev;
-	struct media_entity *entity, *tuner = NULL, *demod = NULL;
+	struct media_entity *entity, *tuner = NULL, *demod = NULL, *conn;
 	struct media_entity *demux = NULL, *ca = NULL;
 	struct media_link *link;
 	struct media_interface *intf;
 	unsigned demux_pad = 0;
 	unsigned dvr_pad = 0;
 	int ret;
+	static const char *connector_name = "Television";
 
 	if (!mdev)
 		return 0;
@@ -590,6 +599,42 @@ int dvb_create_media_graph(struct dvb_adapter *adap)
 		}
 	}
 
+	if (create_rf_connector) {
+		conn = kzalloc(sizeof(*conn), GFP_KERNEL);
+		if (!conn)
+			return -ENOMEM;
+		adap->conn = conn;
+
+		adap->conn_pads = kcalloc(1, sizeof(*adap->conn_pads),
+					    GFP_KERNEL);
+		if (!adap->conn_pads)
+			return -ENOMEM;
+
+		conn->flags = MEDIA_ENT_FL_CONNECTOR;
+		conn->function = MEDIA_ENT_F_CONN_RF;
+		conn->name = connector_name;
+		adap->conn_pads->flags = MEDIA_PAD_FL_SOURCE;
+
+		ret = media_entity_pads_init(conn, 1, adap->conn_pads);
+		if (ret)
+			return ret;
+
+		ret = media_device_register_entity(mdev, conn);
+		if (ret)
+			return ret;
+
+		if (!tuner)
+			ret = media_create_pad_link(conn, 0,
+						    demod, 0,
+						    MEDIA_LNK_FL_ENABLED);
+		else
+			ret = media_create_pad_link(conn, 0,
+						    tuner, TUNER_PAD_RF_INPUT,
+						    MEDIA_LNK_FL_ENABLED);
+		if (ret)
+			return ret;
+	}
+
 	if (tuner && demod) {
 		ret = media_create_pad_link(tuner, TUNER_PAD_IF_OUTPUT,
 					    demod, 0, MEDIA_LNK_FL_ENABLED);
diff --git a/drivers/media/dvb-core/dvbdev.h b/drivers/media/dvb-core/dvbdev.h
index abee18a402e1..b622d6a3b95e 100644
--- a/drivers/media/dvb-core/dvbdev.h
+++ b/drivers/media/dvb-core/dvbdev.h
@@ -75,6 +75,9 @@ struct dvb_frontend;
  *			used.
  * @mdev:		pointer to struct media_device, used when the media
  *			controller is used.
+ * @conn:		RF connector. Used only if the device has no separate
+ *			tuner.
+ * @conn_pads:		pointer to struct media_pad associated with @conn;
  */
 struct dvb_adapter {
 	int num;
@@ -94,6 +97,8 @@ struct dvb_adapter {
 
 #if defined(CONFIG_MEDIA_CONTROLLER_DVB)
 	struct media_device *mdev;
+	struct media_entity *conn;
+	struct media_pad *conn_pads;
 #endif
 };
 
@@ -214,7 +219,16 @@ int dvb_register_device(struct dvb_adapter *adap,
 void dvb_unregister_device(struct dvb_device *dvbdev);
 
 #ifdef CONFIG_MEDIA_CONTROLLER_DVB
-__must_check int dvb_create_media_graph(struct dvb_adapter *adap);
+/**
+ * dvb_create_media_graph - Creates media graph for the Digital TV part of the
+ * 				device.
+ *
+ * @adap:			pointer to struct dvb_adapter
+ * @create_rf_connector:	if true, it creates the RF connector too
+ */
+__must_check int dvb_create_media_graph(struct dvb_adapter *adap,
+					bool create_rf_connector);
+
 static inline void dvb_register_media_controller(struct dvb_adapter *adap,
 						 struct media_device *mdev)
 {
@@ -222,7 +236,9 @@ static inline void dvb_register_media_controller(struct dvb_adapter *adap,
 }
 
 #else
-static inline int dvb_create_media_graph(struct dvb_adapter *adap)
+static inline
+int dvb_create_media_graph(struct dvb_adapter *adap,
+			   bool create_rf_connector)
 {
 	return 0;
 };
diff --git a/drivers/media/usb/au0828/au0828-dvb.c b/drivers/media/usb/au0828/au0828-dvb.c
index cd542b49a6c2..94363a3ba400 100644
--- a/drivers/media/usb/au0828/au0828-dvb.c
+++ b/drivers/media/usb/au0828/au0828-dvb.c
@@ -486,7 +486,7 @@ static int dvb_register(struct au0828_dev *dev)
 	dvb->start_count = 0;
 	dvb->stop_count = 0;
 
-	result = dvb_create_media_graph(&dvb->adapter);
+	result = dvb_create_media_graph(&dvb->adapter, false);
 	if (result < 0)
 		goto fail_create_graph;
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index b7552d20ebdb..b8d5b2be9293 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -551,7 +551,7 @@ static int register_dvb(struct cx231xx_dvb *dvb,
 
 	/* register network adapter */
 	dvb_net_init(&dvb->adapter, &dvb->net, &dvb->demux.dmx);
-	result = dvb_create_media_graph(&dvb->adapter);
+	result = dvb_create_media_graph(&dvb->adapter, false);
 	if (result < 0)
 		goto fail_create_graph;
 
diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
index 0fa2c45917b0..e8491f73c0d9 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
@@ -706,7 +706,7 @@ static int dvb_usbv2_adapter_frontend_init(struct dvb_usb_adapter *adap)
 		}
 	}
 
-	ret = dvb_create_media_graph(&adap->dvb_adap);
+	ret = dvb_create_media_graph(&adap->dvb_adap, true);
 	if (ret < 0)
 		goto err_dvb_unregister_frontend;
 
diff --git a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
index 241463ef631e..9ddfcab268be 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
@@ -330,7 +330,7 @@ int dvb_usb_adapter_frontend_init(struct dvb_usb_adapter *adap)
 	if (ret)
 		return ret;
 
-	ret = dvb_create_media_graph(&adap->dvb_adap);
+	ret = dvb_create_media_graph(&adap->dvb_adap, true);
 	if (ret)
 		return ret;
 
-- 
2.5.0


