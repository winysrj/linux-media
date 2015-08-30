Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48356 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207AbbH3DHo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Aug 2015 23:07:44 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH v8 27/55] [media] dvbdev: add support for indirect interface links
Date: Sun, 30 Aug 2015 00:06:38 -0300
Message-Id: <2e77a279dd0e4cb7721766fafed79ed19a38cb7c.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some interfaces indirectly control multiple entities.
Add support for those.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 6bf61d42c017..14d32cdcdd47 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -441,6 +441,7 @@ void dvb_create_media_graph(struct dvb_adapter *adap)
 	struct media_device *mdev = adap->mdev;
 	struct media_entity *entity, *tuner = NULL, *fe = NULL;
 	struct media_entity *demux = NULL, *dvr = NULL, *ca = NULL;
+	struct media_interface *intf;
 
 	if (!mdev)
 		return;
@@ -476,6 +477,18 @@ void dvb_create_media_graph(struct dvb_adapter *adap)
 
 	if (demux && ca)
 		media_create_pad_link(demux, 1, ca, 0, MEDIA_LNK_FL_ENABLED);
+
+	/* Create indirect interface links for FE->tuner, DVR->demux and CA->ca */
+	list_for_each_entry(intf, &mdev->interfaces, list) {
+		if (intf->type == MEDIA_INTF_T_DVB_CA && ca)
+			media_create_intf_link(ca, intf, 0);
+		if (intf->type == MEDIA_INTF_T_DVB_FE && tuner)
+			media_create_intf_link(tuner, intf, 0);
+		if (intf->type == MEDIA_INTF_T_DVB_DVR && demux)
+			media_create_intf_link(demux, intf, 0);
+	}
+
+
 }
 EXPORT_SYMBOL_GPL(dvb_create_media_graph);
 #endif
-- 
2.4.3

