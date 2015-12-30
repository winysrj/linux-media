Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52495 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846AbbL3Ntj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Dec 2015 08:49:39 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 5/6] [media] dvbdev: create links on devices with multiple frontends
Date: Wed, 30 Dec 2015 11:48:55 -0200
Message-Id: <9608c4003b8d9d275a205395202fa8e62f6f82b2.1451482760.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1451482760.git.mchehab@osg.samsung.com>
References: <cover.1451482760.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1451482760.git.mchehab@osg.samsung.com>
References: <cover.1451482760.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devices like mxl111sf-based WinTV Aero-m have multiple
frontends, all linked on the same demod. Currently, the
dvb_create_graph() function is not smart enough to create
multiple links. Fix it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/dvb-core/dvbdev.c | 57 +++++++++++++++++++++++++++++++----------
 drivers/media/dvb-core/dvbdev.h |  7 +++++
 2 files changed, 51 insertions(+), 13 deletions(-)

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 28e340583ede..560450a0b32a 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -576,6 +576,7 @@ int dvb_create_media_graph(struct dvb_adapter *adap,
 	struct media_interface *intf;
 	unsigned demux_pad = 0;
 	unsigned dvr_pad = 0;
+	unsigned ntuner = 0, ndemod = 0;
 	int ret;
 	static const char *connector_name = "Television";
 
@@ -586,9 +587,11 @@ int dvb_create_media_graph(struct dvb_adapter *adap,
 		switch (entity->function) {
 		case MEDIA_ENT_F_TUNER:
 			tuner = entity;
+			ntuner++;
 			break;
 		case MEDIA_ENT_F_DTV_DEMOD:
 			demod = entity;
+			ndemod++;
 			break;
 		case MEDIA_ENT_F_TS_DEMUX:
 			demux = entity;
@@ -599,6 +602,18 @@ int dvb_create_media_graph(struct dvb_adapter *adap,
 		}
 	}
 
+	/*
+	 * Prepare to signalize to media_create_pad_links() that multiple
+	 * entities of the same type exists and a 1:n or n:1 links need to be
+	 * created.
+	 * NOTE: if both tuner and demod have multiple instances, it is up
+	 * to the caller driver to create such links.
+	 */
+	if (ntuner > 1)
+		tuner = NULL;
+	if (ndemod > 1)
+		demod = NULL;
+
 	if (create_rf_connector) {
 		conn = kzalloc(sizeof(*conn), GFP_KERNEL);
 		if (!conn)
@@ -623,28 +638,44 @@ int dvb_create_media_graph(struct dvb_adapter *adap,
 		if (ret)
 			return ret;
 
-		if (!tuner)
-			ret = media_create_pad_link(conn, 0,
-						    demod, 0,
-						    MEDIA_LNK_FL_ENABLED);
+		if (!ntuner)
+			ret = media_create_pad_links(mdev,
+						     MEDIA_ENT_F_CONN_RF,
+						     conn, 0,
+						     MEDIA_ENT_F_DTV_DEMOD,
+						     demod, 0,
+						     MEDIA_LNK_FL_ENABLED,
+						     false);
 		else
-			ret = media_create_pad_link(conn, 0,
-						    tuner, TUNER_PAD_RF_INPUT,
-						    MEDIA_LNK_FL_ENABLED);
+			ret = media_create_pad_links(mdev,
+						     MEDIA_ENT_F_CONN_RF,
+						     conn, 0,
+						     MEDIA_ENT_F_TUNER,
+						     tuner, TUNER_PAD_RF_INPUT,
+						     MEDIA_LNK_FL_ENABLED,
+						     false);
 		if (ret)
 			return ret;
 	}
 
-	if (tuner && demod) {
-		ret = media_create_pad_link(tuner, TUNER_PAD_IF_OUTPUT,
-					    demod, 0, MEDIA_LNK_FL_ENABLED);
+	if (ntuner && ndemod) {
+		ret = media_create_pad_links(mdev,
+					     MEDIA_ENT_F_TUNER,
+					     tuner, TUNER_PAD_IF_OUTPUT,
+					     MEDIA_ENT_F_DTV_DEMOD,
+					     demod, 0, MEDIA_LNK_FL_ENABLED,
+					     false);
 		if (ret)
 			return ret;
 	}
 
-	if (demod && demux) {
-		ret = media_create_pad_link(demod, 1, demux,
-					    0, MEDIA_LNK_FL_ENABLED);
+	if (ndemod && demux) {
+		ret = media_create_pad_links(mdev,
+					     MEDIA_ENT_F_DTV_DEMOD,
+					     demod, 1,
+					     MEDIA_ENT_F_TS_DEMUX,
+					     demux, 0, MEDIA_LNK_FL_ENABLED,
+					     false);
 		if (ret)
 			return -ENOMEM;
 	}
diff --git a/drivers/media/dvb-core/dvbdev.h b/drivers/media/dvb-core/dvbdev.h
index b622d6a3b95e..d7c67baa885e 100644
--- a/drivers/media/dvb-core/dvbdev.h
+++ b/drivers/media/dvb-core/dvbdev.h
@@ -225,6 +225,13 @@ void dvb_unregister_device(struct dvb_device *dvbdev);
  *
  * @adap:			pointer to struct dvb_adapter
  * @create_rf_connector:	if true, it creates the RF connector too
+ *
+ * This function checks all DVB-related functions at the media controller
+ * entities and creates the needed links for the media graph. It is
+ * capable of working with multiple tuners or multiple frontends, but it
+ * won't create links if the device has multiple tuners and multiple frontends
+ * or if the device has multiple muxes. In such case, the caller driver should
+ * manually create the remaining links.
  */
 __must_check int dvb_create_media_graph(struct dvb_adapter *adap,
 					bool create_rf_connector);
-- 
2.5.0


