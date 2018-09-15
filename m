Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:43372 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727691AbeIPBer (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Sep 2018 21:34:47 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH v2 13/14] media: mxl111sf: declare its own pads
Date: Sat, 15 Sep 2018 17:14:28 -0300
Message-Id: <0410808322e1f6bbfdaebba5a53aa481a15a36c8.1537042262.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1537042262.git.mchehab+samsung@kernel.org>
References: <cover.1537042262.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1537042262.git.mchehab+samsung@kernel.org>
References: <cover.1537042262.git.mchehab+samsung@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As we don't need anymore to share pad numbers with similar
drivers, use its own pad definition instead of a global
model.

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/usb/dvb-usb-v2/mxl111sf.c | 10 +++++-----
 drivers/media/usb/dvb-usb-v2/mxl111sf.h |  8 +++++++-
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf.c b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
index ecd758388745..85cdf593a9ad 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
@@ -892,13 +892,13 @@ static int mxl111sf_attach_tuner(struct dvb_usb_adapter *adap)
 #ifdef CONFIG_MEDIA_CONTROLLER_DVB
 	state->tuner.function = MEDIA_ENT_F_TUNER;
 	state->tuner.name = "mxl111sf tuner";
-	state->tuner_pads[TUNER_PAD_RF_INPUT].flags = MEDIA_PAD_FL_SINK;
-	state->tuner_pads[TUNER_PAD_RF_INPUT].sig_type = PAD_SIGNAL_ANALOG;
-	state->tuner_pads[TUNER_PAD_OUTPUT].flags = MEDIA_PAD_FL_SOURCE;
-	state->tuner_pads[TUNER_PAD_OUTPUT].sig_type = PAD_SIGNAL_ANALOG;
+	state->tuner_pads[MXL111SF_PAD_RF_INPUT].flags = MEDIA_PAD_FL_SINK;
+	state->tuner_pads[MXL111SF_PAD_RF_INPUT].sig_type = PAD_SIGNAL_ANALOG;
+	state->tuner_pads[MXL111SF_PAD_OUTPUT].flags = MEDIA_PAD_FL_SOURCE;
+	state->tuner_pads[MXL111SF_PAD_OUTPUT].sig_type = PAD_SIGNAL_ANALOG;
 
 	ret = media_entity_pads_init(&state->tuner,
-				     TUNER_NUM_PADS, state->tuner_pads);
+				     MXL111SF_NUM_PADS, state->tuner_pads);
 	if (ret)
 		return ret;
 
diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf.h b/drivers/media/usb/dvb-usb-v2/mxl111sf.h
index 22253d4908eb..ed98654ba7fd 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf.h
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf.h
@@ -52,6 +52,12 @@ struct mxl111sf_adap_state {
 	int (*fe_sleep)(struct dvb_frontend *);
 };
 
+enum mxl111sf_pads {
+	MXL111SF_PAD_RF_INPUT,
+	MXL111SF_PAD_OUTPUT,
+	MXL111SF_NUM_PADS
+};
+
 struct mxl111sf_state {
 	struct dvb_usb_device *d;
 
@@ -94,7 +100,7 @@ struct mxl111sf_state {
 	struct mutex msg_lock;
 #ifdef CONFIG_MEDIA_CONTROLLER_DVB
 	struct media_entity tuner;
-	struct media_pad tuner_pads[2];
+	struct media_pad tuner_pads[MXL111SF_NUM_PADS];
 #endif
 };
 
-- 
2.17.1
