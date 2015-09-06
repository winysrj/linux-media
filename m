Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53835 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbbIFRbf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Sep 2015 13:31:35 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 17/18] [media] dvbdev: move indirect links on dvr/demux to a separate function
Date: Sun,  6 Sep 2015 14:31:00 -0300
Message-Id: <85b36c34704eeba890472e7973d2e01a69c4b87c.1441559233.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1441559233.git.mchehab@osg.samsung.com>
References: <cover.1441559233.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1441559233.git.mchehab@osg.samsung.com>
References: <cover.1441559233.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cleanup the code a little bit by moving the routine that creates
links between DVR and demux to the I/O entitis into a separate
function.

While here, fix the code to use strncmp() instead of strcmp().

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 8527fc40e6a0..ea76fe54e0e4 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -522,6 +522,28 @@ EXPORT_SYMBOL(dvb_unregister_device);
 
 
 #ifdef CONFIG_MEDIA_CONTROLLER_DVB
+
+static int dvb_create_io_intf_links(struct dvb_adapter *adap,
+				    struct media_interface *intf,
+				    char *name)
+{
+	struct media_device *mdev = adap->mdev;
+	struct media_entity *entity;
+	struct media_link *link;
+
+	media_device_for_each_entity(entity, mdev) {
+		if (entity->function == MEDIA_ENT_F_IO) {
+			if (strncmp(entity->name, name, strlen(name)))
+				continue;
+			link = media_create_intf_link(entity, intf,
+						      MEDIA_LNK_FL_ENABLED);
+			if (!link)
+				return -ENOMEM;
+		}
+	}
+	return 0;
+}
+
 int dvb_create_media_graph(struct dvb_adapter *adap)
 {
 	struct media_device *mdev = adap->mdev;
@@ -619,25 +641,15 @@ int dvb_create_media_graph(struct dvb_adapter *adap)
 			if (!link)
 				return -ENOMEM;
 		}
-
-		media_device_for_each_entity(entity, mdev) {
-			if (entity->function == MEDIA_ENT_F_IO) {
-				if (!strcmp(entity->name, DVR_TSOUT)) {
-					link = media_create_intf_link(entity,
-							intf,
-							MEDIA_LNK_FL_ENABLED);
-					if (!link)
-						return -ENOMEM;
-				}
-				if (!strcmp(entity->name, DEMUX_TSOUT)) {
-					link = media_create_intf_link(entity,
-							intf,
-							MEDIA_LNK_FL_ENABLED);
-					if (!link)
-						return -ENOMEM;
-				}
-				break;
-			}
+		if (intf->type == MEDIA_INTF_T_DVB_DVR) {
+			ret = dvb_create_io_intf_links(adap, intf, DVR_TSOUT);
+			if (ret)
+				return ret;
+		}
+		if (intf->type == MEDIA_INTF_T_DVB_DEMUX) {
+			ret = dvb_create_io_intf_links(adap, intf, DEMUX_TSOUT);
+			if (ret)
+				return ret;
 		}
 	}
 	return 0;
-- 
2.4.3


