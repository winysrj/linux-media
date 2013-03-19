Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932935Ab3CSQuQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 12:50:16 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doron Cohen <doronc@siano-ms.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 34/46] [media] siano: fix PER/BER report on DVBv5
Date: Tue, 19 Mar 2013 13:49:23 -0300
Message-Id: <1363711775-2120-35-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
References: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The check for lock logic is broken. Due to that, no PER/BER
stats will ever be showed, and the DVBV3 events will be wrong.

Also, the per-layer PER/BER stats for ISDB-T are filled with
the wrong index.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/smsdvb-main.c | 46 ++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 17 deletions(-)

diff --git a/drivers/media/common/siano/smsdvb-main.c b/drivers/media/common/siano/smsdvb-main.c
index 90f6e89..632a250 100644
--- a/drivers/media/common/siano/smsdvb-main.c
+++ b/drivers/media/common/siano/smsdvb-main.c
@@ -382,8 +382,12 @@ static void smsdvb_update_isdbt_stats(struct smsdvb_client_t *client,
 	/* Clears global counters, as the code below will sum it again */
 	c->block_error.stat[0].uvalue = 0;
 	c->block_count.stat[0].uvalue = 0;
+	c->block_error.stat[0].scale = FE_SCALE_COUNTER;
+	c->block_count.stat[0].scale = FE_SCALE_COUNTER;
 	c->post_bit_error.stat[0].uvalue = 0;
 	c->post_bit_count.stat[0].uvalue = 0;
+	c->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
+	c->post_bit_count.stat[0].scale = FE_SCALE_COUNTER;
 
 	for (i = 0; i < n_layers; i++) {
 		lr = &p->LayerInfo[i];
@@ -398,20 +402,20 @@ static void smsdvb_update_isdbt_stats(struct smsdvb_client_t *client,
 		c->layer[i].modulation = sms_to_modulation(lr->Constellation);
 
 		/* TS PER */
-		c->block_error.stat[i].scale = FE_SCALE_COUNTER;
-		c->block_count.stat[i].scale = FE_SCALE_COUNTER;
-		c->block_error.stat[i].uvalue += lr->ErrorTSPackets;
-		c->block_count.stat[i].uvalue += lr->TotalTSPackets;
+		c->block_error.stat[i + 1].scale = FE_SCALE_COUNTER;
+		c->block_count.stat[i + 1].scale = FE_SCALE_COUNTER;
+		c->block_error.stat[i + 1].uvalue += lr->ErrorTSPackets;
+		c->block_count.stat[i + 1].uvalue += lr->TotalTSPackets;
 
 		/* Update global PER counter */
 		c->block_error.stat[0].uvalue += lr->ErrorTSPackets;
 		c->block_count.stat[0].uvalue += lr->TotalTSPackets;
 
 		/* BER */
-		c->post_bit_error.stat[i].scale = FE_SCALE_COUNTER;
-		c->post_bit_count.stat[i].scale = FE_SCALE_COUNTER;
-		c->post_bit_error.stat[i].uvalue += lr->BERErrorCount;
-		c->post_bit_count.stat[i].uvalue += lr->BERBitCount;
+		c->post_bit_error.stat[i + 1].scale = FE_SCALE_COUNTER;
+		c->post_bit_count.stat[i + 1].scale = FE_SCALE_COUNTER;
+		c->post_bit_error.stat[i + 1].uvalue += lr->BERErrorCount;
+		c->post_bit_count.stat[i + 1].uvalue += lr->BERBitCount;
 
 		/* Update global BER counter */
 		c->post_bit_error.stat[0].uvalue += lr->BERErrorCount;
@@ -462,9 +466,17 @@ static void smsdvb_update_isdbt_stats_ex(struct smsdvb_client_t *client,
 	/* Clears global counters, as the code below will sum it again */
 	c->block_error.stat[0].uvalue = 0;
 	c->block_count.stat[0].uvalue = 0;
+	c->block_error.stat[0].scale = FE_SCALE_COUNTER;
+	c->block_count.stat[0].scale = FE_SCALE_COUNTER;
 	c->post_bit_error.stat[0].uvalue = 0;
 	c->post_bit_count.stat[0].uvalue = 0;
+	c->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
+	c->post_bit_count.stat[0].scale = FE_SCALE_COUNTER;
 
+	c->post_bit_error.len = n_layers + 1;
+	c->post_bit_count.len = n_layers + 1;
+	c->block_error.len = n_layers + 1;
+	c->block_count.len = n_layers + 1;
 	for (i = 0; i < n_layers; i++) {
 		lr = &p->LayerInfo[i];
 
@@ -478,20 +490,20 @@ static void smsdvb_update_isdbt_stats_ex(struct smsdvb_client_t *client,
 		c->layer[i].modulation = sms_to_modulation(lr->Constellation);
 
 		/* TS PER */
-		c->block_error.stat[i].scale = FE_SCALE_COUNTER;
-		c->block_count.stat[i].scale = FE_SCALE_COUNTER;
-		c->block_error.stat[i].uvalue += lr->ErrorTSPackets;
-		c->block_count.stat[i].uvalue += lr->TotalTSPackets;
+		c->block_error.stat[i + 1].scale = FE_SCALE_COUNTER;
+		c->block_count.stat[i + 1].scale = FE_SCALE_COUNTER;
+		c->block_error.stat[i + 1].uvalue += lr->ErrorTSPackets;
+		c->block_count.stat[i + 1].uvalue += lr->TotalTSPackets;
 
 		/* Update global PER counter */
 		c->block_error.stat[0].uvalue += lr->ErrorTSPackets;
 		c->block_count.stat[0].uvalue += lr->TotalTSPackets;
 
 		/* BER */
-		c->post_bit_error.stat[i].scale = FE_SCALE_COUNTER;
-		c->post_bit_count.stat[i].scale = FE_SCALE_COUNTER;
-		c->post_bit_error.stat[i].uvalue += lr->BERErrorCount;
-		c->post_bit_count.stat[i].uvalue += lr->BERBitCount;
+		c->post_bit_error.stat[i + 1].scale = FE_SCALE_COUNTER;
+		c->post_bit_count.stat[i + 1].scale = FE_SCALE_COUNTER;
+		c->post_bit_error.stat[i + 1].uvalue += lr->BERErrorCount;
+		c->post_bit_count.stat[i + 1].uvalue += lr->BERBitCount;
 
 		/* Update global BER counter */
 		c->post_bit_error.stat[0].uvalue += lr->BERErrorCount;
@@ -572,7 +584,7 @@ static int smsdvb_onresponse(void *context, struct smscore_buffer_t *cb)
 	smscore_putbuffer(client->coredev, cb);
 
 	if (is_status_update) {
-		if (client->fe_status == FE_HAS_LOCK) {
+		if (client->fe_status & FE_HAS_LOCK) {
 			sms_board_dvb3_event(client, DVB3_EVENT_FE_LOCK);
 			if (client->last_per == c->block_error.stat[0].uvalue)
 				sms_board_dvb3_event(client, DVB3_EVENT_UNC_OK);
-- 
1.8.1.4

