Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53824 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752820AbbIFRbf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Sep 2015 13:31:35 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 18/18] [media] dvbdev: Don't create indirect links
Date: Sun,  6 Sep 2015 14:31:01 -0300
Message-Id: <2460617268cac8bbabad0db7372914379f7c8644.1441559233.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1441559233.git.mchehab@osg.samsung.com>
References: <cover.1441559233.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1441559233.git.mchehab@osg.samsung.com>
References: <cover.1441559233.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Indirect links are those whose the interface indirectly controls
other functions.

There are two interfaces that have indirect controls at the DVB
side:
- the network interface, with also controls the demux;
- the DVR interface with also controls the demux.

One could argue that the frontend control to the tuner is indirect.
Well, that's debateable. There's no way to create subdef interfaces
for tuner and demod, as those devices are tightly coupled. So, it
was decided that just one interface is the best to control both
entities, and there's no plan (or easy way) to decouple both. So,
the DVB frontend interface should link to both entities.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index ea76fe54e0e4..e9f24c1479dd 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -619,7 +619,7 @@ int dvb_create_media_graph(struct dvb_adapter *adap)
 		}
 	}
 
-	/* Create indirect interface links for FE->tuner, DVR->demux and CA->ca */
+	/* Create interface links for FE->tuner, DVR->demux and CA->ca */
 	media_device_for_each_intf(intf, mdev) {
 		if (intf->type == MEDIA_INTF_T_DVB_CA && ca) {
 			link = media_create_intf_link(ca, intf,
@@ -634,13 +634,19 @@ int dvb_create_media_graph(struct dvb_adapter *adap)
 			if (!link)
 				return -ENOMEM;
 		}
-
+#if 0
+		/*
+		 * Indirect link - let's not create yet, as we don't know how
+		 *		   to handle indirect links, nor if this will
+		 *		   actually be needed.
+		 */
 		if (intf->type == MEDIA_INTF_T_DVB_DVR && demux) {
 			link = media_create_intf_link(demux, intf,
 						      MEDIA_LNK_FL_ENABLED);
 			if (!link)
 				return -ENOMEM;
 		}
+#endif
 		if (intf->type == MEDIA_INTF_T_DVB_DVR) {
 			ret = dvb_create_io_intf_links(adap, intf, DVR_TSOUT);
 			if (ret)
-- 
2.4.3


