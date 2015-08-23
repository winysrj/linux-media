Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58956 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbbHWUSK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Aug 2015 16:18:10 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH v7 23/44] [media] dvbdev: add support for indirect interface links
Date: Sun, 23 Aug 2015 17:17:40 -0300
Message-Id: <c3591e8e83b785ede03633be38cb601c6284542e.1440359643.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440359643.git.mchehab@osg.samsung.com>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440359643.git.mchehab@osg.samsung.com>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some interfaces indirectly control multiple entities.
Add support for those.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 747372ba4fe1..5a2bd03f5dc0 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -440,6 +440,7 @@ void dvb_create_media_graph(struct dvb_adapter *adap)
 	struct media_device *mdev = adap->mdev;
 	struct media_entity *entity, *tuner = NULL, *fe = NULL;
 	struct media_entity *demux = NULL, *dvr = NULL, *ca = NULL;
+	struct media_interface *intf;
 
 	if (!mdev)
 		return;
@@ -475,6 +476,17 @@ void dvb_create_media_graph(struct dvb_adapter *adap)
 
 	if (demux && ca)
 		media_create_pad_link(demux, 1, ca, 0, MEDIA_LNK_FL_ENABLED);
+
+	/* Create indirect interface links for DVR and tuner */
+
+	list_for_each_entry(intf, &mdev->interfaces, list) {
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

