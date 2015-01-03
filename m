Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56123 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbbACUJv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Jan 2015 15:09:51 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 6/7] dvbdev: add a function to create DVB media graph
Date: Sat,  3 Jan 2015 18:09:38 -0200
Message-Id: <25835dd95474154c524a1df9f29050b52918dc5d.1420315245.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1420315245.git.mchehab@osg.samsung.com>
References: <cover.1420315245.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1420315245.git.mchehab@osg.samsung.com>
References: <cover.1420315245.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We need to create a DVB graph, linking the several DVB devnodes.

Add such function. Please notice that this helper function
doesn't take into account devices with multiple DVB adapters
and frontends.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index f7294d2ef816..7efa157072ed 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -380,6 +380,53 @@ void dvb_unregister_device(struct dvb_device *dvbdev)
 }
 EXPORT_SYMBOL(dvb_unregister_device);
 
+
+void dvb_create_media_graph(struct media_device *mdev)
+{
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct media_entity *entity, *tuner = NULL, *fe = NULL;
+	struct media_entity *demux = NULL, *dvr = NULL, *ca = NULL;
+
+	if (!mdev)
+		return;
+
+	media_device_for_each_entity(entity, mdev) {
+		printk("entity %s, type %d\n", entity->name, entity->type);
+
+		switch (entity->type) {
+		case MEDIA_ENT_T_V4L2_SUBDEV_TUNER:
+			tuner = entity;
+			break;
+		case MEDIA_ENT_T_DEVNODE_DVB_FE:
+			fe = entity;
+			break;
+		case MEDIA_ENT_T_DEVNODE_DVB_DEMUX:
+			demux = entity;
+			break;
+		case MEDIA_ENT_T_DEVNODE_DVB_DVR:
+			dvr = entity;
+			break;
+		case MEDIA_ENT_T_DEVNODE_DVB_CA:
+			ca = entity;
+			break;
+		}
+	}
+
+	if (tuner && fe)
+		media_entity_create_link(tuner, 0, fe, 0, 0);
+
+	if (fe && demux)
+		media_entity_create_link(fe, 1, demux, 0, 0);
+
+	if (demux && dvr)
+		media_entity_create_link(demux, 1, dvr, 0, 0);
+
+	if (demux && ca)
+		media_entity_create_link(demux, 1, ca, 0, 0);
+#endif
+}
+EXPORT_SYMBOL_GPL(dvb_create_media_graph);
+
 static int dvbdev_check_free_adapter_num(int num)
 {
 	struct list_head *entry;
diff --git a/drivers/media/dvb-core/dvbdev.h b/drivers/media/dvb-core/dvbdev.h
index 513ca92028dd..df04b55b883a 100644
--- a/drivers/media/dvb-core/dvbdev.h
+++ b/drivers/media/dvb-core/dvbdev.h
@@ -119,6 +119,7 @@ extern int dvb_register_device (struct dvb_adapter *adap,
 				int type);
 
 extern void dvb_unregister_device (struct dvb_device *dvbdev);
+void dvb_create_media_graph(struct media_device *mdev);
 
 extern int dvb_generic_open (struct inode *inode, struct file *file);
 extern int dvb_generic_release (struct inode *inode, struct file *file);
-- 
2.1.0

