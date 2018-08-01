Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56456 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389691AbeHARln (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2018 13:41:43 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Max Kellermann <max.kellermann@gmail.com>
Subject: [PATCH 04/13] media: dvb: use signals to discover pads
Date: Wed,  1 Aug 2018 12:55:06 -0300
Message-Id: <e4f9e8e16246f20226dc95d94ac2993b9e9e9beb.1533138685.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1533138685.git.mchehab+samsung@kernel.org>
References: <cover.1533138685.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1533138685.git.mchehab+samsung@kernel.org>
References: <cover.1533138685.git.mchehab+samsung@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On tuner pads, multiple signals are present. Be sure to get
the right PAD by using them.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/dvb-core/dvbdev.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 3c8778570331..50f174248eef 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -621,7 +621,7 @@ int dvb_create_media_graph(struct dvb_adapter *adap,
 	unsigned demux_pad = 0;
 	unsigned dvr_pad = 0;
 	unsigned ntuner = 0, ndemod = 0;
-	int ret;
+	int ret, pad_source, pad_sink;
 	static const char *connector_name = "Television";
 
 	if (!mdev)
@@ -681,7 +681,7 @@ int dvb_create_media_graph(struct dvb_adapter *adap,
 		if (ret)
 			return ret;
 
-		if (!ntuner)
+		if (!ntuner) {
 			ret = media_create_pad_links(mdev,
 						     MEDIA_ENT_F_CONN_RF,
 						     conn, 0,
@@ -689,22 +689,31 @@ int dvb_create_media_graph(struct dvb_adapter *adap,
 						     demod, 0,
 						     MEDIA_LNK_FL_ENABLED,
 						     false);
-		else
+		} else {
+			pad_sink = media_get_pad_index(tuner, true,
+						       PAD_SIGNAL_ANALOG);
+			if (pad_sink < 0)
+				return -EINVAL;
 			ret = media_create_pad_links(mdev,
 						     MEDIA_ENT_F_CONN_RF,
 						     conn, 0,
 						     MEDIA_ENT_F_TUNER,
-						     tuner, TUNER_PAD_RF_INPUT,
+						     tuner, pad_sink,
 						     MEDIA_LNK_FL_ENABLED,
 						     false);
+		}
 		if (ret)
 			return ret;
 	}
 
 	if (ntuner && ndemod) {
+		pad_source = media_get_pad_index(tuner, true,
+						 PAD_SIGNAL_ANALOG);
+		if (pad_source)
+			return -EINVAL;
 		ret = media_create_pad_links(mdev,
 					     MEDIA_ENT_F_TUNER,
-					     tuner, TUNER_PAD_OUTPUT,
+					     tuner, pad_source,
 					     MEDIA_ENT_F_DTV_DEMOD,
 					     demod, 0, MEDIA_LNK_FL_ENABLED,
 					     false);
-- 
2.17.1
