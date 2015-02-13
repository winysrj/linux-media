Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49417 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872AbbBMW6T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2015 17:58:19 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCHv4 20/25] [media] dvbdev: add a function to create DVB media graph
Date: Fri, 13 Feb 2015 20:58:03 -0200
Message-Id: <e878dcbcb6d4a272f8bd995cd1349385f1548f36.1423867976.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1423867976.git.mchehab@osg.samsung.com>
References: <cover.1423867976.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1423867976.git.mchehab@osg.samsung.com>
References: <cover.1423867976.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We need to create a DVB graph, linking the several DVB devnodes.

Add such function. Please notice that this helper function
doesn't take into account devices with multiple DVB adapters
and frontends.

For devices with multiple adapters, they should either create two
different media controller instances or to improve this function
to take the adapter ID into account.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index c5de02455b17..a991819ed1e1 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -380,6 +380,51 @@ void dvb_unregister_device(struct dvb_device *dvbdev)
 }
 EXPORT_SYMBOL(dvb_unregister_device);
 
+
+void dvb_create_media_graph(struct media_device *mdev)
+{
+#ifdef CONFIG_MEDIA_CONTROLLER_DVB
+	struct media_entity *entity, *tuner = NULL, *fe = NULL;
+	struct media_entity *demux = NULL, *dvr = NULL, *ca = NULL;
+
+	if (!mdev)
+		return;
+
+	media_device_for_each_entity(entity, mdev) {
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
index 464067c43a35..467c1311bd4c 100644
--- a/drivers/media/dvb-core/dvbdev.h
+++ b/drivers/media/dvb-core/dvbdev.h
@@ -122,6 +122,7 @@ extern int dvb_register_device (struct dvb_adapter *adap,
 				int type);
 
 extern void dvb_unregister_device (struct dvb_device *dvbdev);
+void dvb_create_media_graph(struct media_device *mdev);
 
 extern int dvb_generic_open (struct inode *inode, struct file *file);
 extern int dvb_generic_release (struct inode *inode, struct file *file);
-- 
2.1.0

