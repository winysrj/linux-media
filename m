Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36648 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732074AbeGaSna (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jul 2018 14:43:30 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH RFC 4/4] media: dvb: use signals to discover pads
Date: Tue, 31 Jul 2018 14:02:13 -0300
Message-Id: <012ee8bc9d1832843ee2c410f05bfb29560f1e42.1533055990.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1533055990.git.mchehab+samsung@kernel.org>
References: <cover.1533055990.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1533055990.git.mchehab+samsung@kernel.org>
References: <cover.1533055990.git.mchehab+samsung@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On tuner pads, multiple signals are present. Be sure to get
the right PAD by using them.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/dvb-core/dvbdev.c | 37 +++++++++++++++++++++++++++++----
 1 file changed, 33 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 787fe06df217..5c39bd328835 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -607,6 +607,28 @@ static int dvb_create_io_intf_links(struct dvb_adapter *adap,
 	return 0;
 }
 
+static int get_pad_index(struct media_entity *entity, bool is_sink,
+			 enum media_pad_signal_type sig_type)
+{
+	int i;
+	bool pad_is_sink;
+
+	for (i = 0; i < entity->num_pads; i++) {
+		if (entity->pads[i].flags == MEDIA_PAD_FL_SINK)
+			pad_is_sink = true;
+		else if (entity->pads[i].flags == MEDIA_PAD_FL_SOURCE)
+			pad_is_sink = false;
+		else
+			continue;	/* This is an error! */
+
+		if (pad_is_sink != is_sink)
+			continue;
+		if (entity->pads[i].sig_type == sig_type)
+			return i;
+	}
+	return -EINVAL;
+}
+
 int dvb_create_media_graph(struct dvb_adapter *adap,
 			   bool create_rf_connector)
 {
@@ -618,7 +640,7 @@ int dvb_create_media_graph(struct dvb_adapter *adap,
 	unsigned demux_pad = 0;
 	unsigned dvr_pad = 0;
 	unsigned ntuner = 0, ndemod = 0;
-	int ret;
+	int ret, pad_source, pad_sink;
 	static const char *connector_name = "Television";
 
 	if (!mdev)
@@ -678,7 +700,7 @@ int dvb_create_media_graph(struct dvb_adapter *adap,
 		if (ret)
 			return ret;
 
-		if (!ntuner)
+		if (!ntuner) {
 			ret = media_create_pad_links(mdev,
 						     MEDIA_ENT_F_CONN_RF,
 						     conn, 0,
@@ -686,19 +708,26 @@ int dvb_create_media_graph(struct dvb_adapter *adap,
 						     demod, 0,
 						     MEDIA_LNK_FL_ENABLED,
 						     false);
-		else
+		} else {
+			pad_sink = get_pad_index(tuner, true, PAD_SIGNAL_RF);
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
+		pad_source = get_pad_index(tuner, true, PAD_SIGNAL_RF);
+		if (pad_source)
+			return -EINVAL;
 		ret = media_create_pad_links(mdev,
 					     MEDIA_ENT_F_TUNER,
 					     tuner, TUNER_PAD_OUTPUT,
-- 
2.17.1
