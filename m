Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26482 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933169Ab3CSQuZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 12:50:25 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doron Cohen <doronc@siano-ms.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 33/46] [media] siano: fix signal strength and CNR stats measurements
Date: Tue, 19 Mar 2013 13:49:22 -0300
Message-Id: <1363711775-2120-34-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
References: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are a number of small issues with the stats refactoring:
	- InBandPwr better represents the signal strength;
	- Don't zero signal strength /cnr if no lock;
	- Fix signal strength/cnr scale;
	- Don't need to fill PER/BER if not locked, as the
	  code will disable those stats anyway.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/smsdvb-main.c | 57 ++++++++++++++++++++------------
 1 file changed, 35 insertions(+), 22 deletions(-)

diff --git a/drivers/media/common/siano/smsdvb-main.c b/drivers/media/common/siano/smsdvb-main.c
index 4242005..90f6e89 100644
--- a/drivers/media/common/siano/smsdvb-main.c
+++ b/drivers/media/common/siano/smsdvb-main.c
@@ -155,11 +155,11 @@ static void smsdvb_stats_not_ready(struct dvb_frontend *fe)
 		n_layers = 1;
 	}
 
-	/* Fill the length of each status counter */
-
-	/* Only global stats */
+	/* Global stats */
 	c->strength.len = 1;
 	c->cnr.len = 1;
+	c->strength.stat[0].scale = FE_SCALE_DECIBEL;
+	c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
 
 	/* Per-layer stats */
 	c->post_bit_error.len = n_layers;
@@ -167,13 +167,11 @@ static void smsdvb_stats_not_ready(struct dvb_frontend *fe)
 	c->block_error.len = n_layers;
 	c->block_count.len = n_layers;
 
-	/* Signal is always available */
-	c->strength.stat[0].scale = FE_SCALE_RELATIVE;
-	c->strength.stat[0].uvalue = 0;
-
-	/* Put all of them at FE_SCALE_NOT_AVAILABLE */
+	/*
+	 * Put all of them at FE_SCALE_NOT_AVAILABLE. They're dynamically
+	 * changed when the stats become available.
+	 */
 	for (i = 0; i < n_layers; i++) {
-		c->cnr.stat[i].scale = FE_SCALE_NOT_AVAILABLE;
 		c->post_bit_error.stat[i].scale = FE_SCALE_NOT_AVAILABLE;
 		c->post_bit_count.stat[i].scale = FE_SCALE_NOT_AVAILABLE;
 		c->block_error.stat[i].scale = FE_SCALE_NOT_AVAILABLE;
@@ -261,6 +259,16 @@ static void smsdvb_update_per_slices(struct smsdvb_client_t *client,
 	client->fe_status = sms_to_status(p->IsDemodLocked, p->IsRfLocked);
 	c->modulation = sms_to_modulation(p->constellation);
 
+	/* Signal Strength, in DBm */
+	c->strength.stat[0].uvalue = p->inBandPower * 1000;
+
+	/* Carrier to Noise ratio, in DB */
+	c->cnr.stat[0].svalue = p->snr * 1000;
+
+	/* PER/BER requires demod lock */
+	if (!p->IsDemodLocked)
+		return;
+
 	/* TS PER */
 	client->last_per = c->block_error.stat[0].uvalue;
 	c->block_error.stat[0].scale = FE_SCALE_COUNTER;
@@ -277,13 +285,6 @@ static void smsdvb_update_per_slices(struct smsdvb_client_t *client,
 	/* Legacy PER/BER */
 	client->legacy_per = (p->etsPackets * 65535) /
 			     (p->tsPackets + p->etsPackets);
-
-	/* Signal Strength, in DBm */
-	c->strength.stat[0].uvalue = p->RSSI * 1000;
-
-	/* Carrier to Noise ratio, in DB */
-	c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
-	c->cnr.stat[0].svalue = p->snr * 1000;
 }
 
 static void smsdvb_update_dvb_stats(struct smsdvb_client_t *client,
@@ -312,11 +313,14 @@ static void smsdvb_update_dvb_stats(struct smsdvb_client_t *client,
 	c->lna = p->IsExternalLNAOn ? 1 : 0;
 
 	/* Carrier to Noise ratio, in DB */
-	c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
 	c->cnr.stat[0].svalue = p->SNR * 1000;
 
 	/* Signal Strength, in DBm */
-	c->strength.stat[0].uvalue = p->RSSI * 1000;
+	c->strength.stat[0].uvalue = p->InBandPwr * 1000;
+
+	/* PER/BER requires demod lock */
+	if (!p->IsDemodLocked)
+		return;
 
 	/* TS PER */
 	client->last_per = c->block_error.stat[0].uvalue;
@@ -364,11 +368,14 @@ static void smsdvb_update_isdbt_stats(struct smsdvb_client_t *client,
 	c->lna = p->IsExternalLNAOn ? 1 : 0;
 
 	/* Carrier to Noise ratio, in DB */
-	c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
 	c->cnr.stat[0].svalue = p->SNR * 1000;
 
 	/* Signal Strength, in DBm */
-	c->strength.stat[0].uvalue = p->RSSI * 1000;
+	c->strength.stat[0].uvalue = p->InBandPwr * 1000;
+
+	/* PER/BER and per-layer stats require demod lock */
+	if (!p->IsDemodLocked)
+		return;
 
 	client->last_per = c->block_error.stat[0].uvalue;
 
@@ -441,11 +448,14 @@ static void smsdvb_update_isdbt_stats_ex(struct smsdvb_client_t *client,
 	c->lna = p->IsExternalLNAOn ? 1 : 0;
 
 	/* Carrier to Noise ratio, in DB */
-	c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
 	c->cnr.stat[0].svalue = p->SNR * 1000;
 
 	/* Signal Strength, in DBm */
-	c->strength.stat[0].uvalue = p->RSSI * 1000;
+	c->strength.stat[0].uvalue = p->InBandPwr * 1000;
+
+	/* PER/BER and per-layer stats require demod lock */
+	if (!p->IsDemodLocked)
+		return;
 
 	client->last_per = c->block_error.stat[0].uvalue;
 
@@ -943,11 +953,14 @@ static int smsdvb_isdbt_set_frontend(struct dvb_frontend *fe)
 
 static int smsdvb_set_frontend(struct dvb_frontend *fe)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct smsdvb_client_t *client =
 		container_of(fe, struct smsdvb_client_t, frontend);
 	struct smscore_device_t *coredev = client->coredev;
 
 	smsdvb_stats_not_ready(fe);
+	c->strength.stat[0].uvalue = 0;
+	c->cnr.stat[0].uvalue = 0;
 
 	switch (smscore_get_device_mode(coredev)) {
 	case DEVICE_MODE_DVBT:
-- 
1.8.1.4

