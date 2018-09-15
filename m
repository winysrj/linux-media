Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:43464 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727872AbeIPBev (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Sep 2018 21:34:51 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Max Kellermann <max.kellermann@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH v2 05/14] media: dvb: use signals to discover pads
Date: Sat, 15 Sep 2018 17:14:20 -0300
Message-Id: <2ec0cbc2a5d5d4a32beff776118dceea6611215e.1537042262.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1537042262.git.mchehab+samsung@kernel.org>
References: <cover.1537042262.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1537042262.git.mchehab+samsung@kernel.org>
References: <cover.1537042262.git.mchehab+samsung@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On tuner pads, multiple signals are present. Be sure to get
the right PAD by using them.

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/dvb-core/dvbdev.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 9a5eed3f6cf6..b7171bf094fb 100644
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
