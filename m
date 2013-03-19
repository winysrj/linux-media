Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933113Ab3CSQuR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 12:50:17 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doron Cohen <doronc@siano-ms.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 18/46] [media] siano: add support for ISDB-T full-seg
Date: Tue, 19 Mar 2013 13:49:07 -0300
Message-Id: <1363711775-2120-19-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
References: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the DVBv5 API handling for ISDB-T and add support
for 13 segments.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/smsdvb.c | 46 ++++++++++++++-----------------------
 1 file changed, 17 insertions(+), 29 deletions(-)

diff --git a/drivers/media/common/siano/smsdvb.c b/drivers/media/common/siano/smsdvb.c
index f4fd670..4900aa9 100644
--- a/drivers/media/common/siano/smsdvb.c
+++ b/drivers/media/common/siano/smsdvb.c
@@ -652,6 +652,9 @@ static int smsdvb_isdbt_set_frontend(struct dvb_frontend *fe)
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct smsdvb_client_t *client =
 		container_of(fe, struct smsdvb_client_t, frontend);
+	int board_id = smscore_get_board_id(client->coredev);
+	struct sms_board *board = sms_get_board(board_id);
+	enum sms_device_type_st type = board->type;
 
 	struct {
 		struct SmsMsgHdr_ST	Msg;
@@ -669,40 +672,25 @@ static int smsdvb_isdbt_set_frontend(struct dvb_frontend *fe)
 	if (c->isdbt_sb_segment_idx == -1)
 		c->isdbt_sb_segment_idx = 0;
 
-	switch (c->isdbt_sb_segment_count) {
-	case 3:
-		Msg.Data[1] = BW_ISDBT_3SEG;
-		break;
-	case 1:
-		Msg.Data[1] = BW_ISDBT_1SEG;
-		break;
-	case 0:	/* AUTO */
-		switch (c->bandwidth_hz / 1000000) {
-		case 8:
-		case 7:
-			c->isdbt_sb_segment_count = 3;
-			Msg.Data[1] = BW_ISDBT_3SEG;
-			break;
-		case 6:
-			c->isdbt_sb_segment_count = 1;
-			Msg.Data[1] = BW_ISDBT_1SEG;
-			break;
-		default: /* Assumes 6 MHZ bw */
-			c->isdbt_sb_segment_count = 1;
-			c->bandwidth_hz = 6000;
-			Msg.Data[1] = BW_ISDBT_1SEG;
-			break;
-		}
-		break;
-	default:
-		sms_info("Segment count %d not supported", c->isdbt_sb_segment_count);
-		return -EINVAL;
-	}
+	if (!c->isdbt_layer_enabled)
+		c->isdbt_layer_enabled = 7;
 
 	Msg.Data[0] = c->frequency;
+	Msg.Data[1] = BW_ISDBT_1SEG;
 	Msg.Data[2] = 12000000;
 	Msg.Data[3] = c->isdbt_sb_segment_idx;
 
+	if (c->isdbt_partial_reception) {
+		if ((type == SMS_PELE || type == SMS_RIO) &&
+		    c->isdbt_sb_segment_count > 3)
+			Msg.Data[1] = BW_ISDBT_13SEG;
+		else if (c->isdbt_sb_segment_count > 1)
+			Msg.Data[1] = BW_ISDBT_3SEG;
+	} else if (type == SMS_PELE || type == SMS_RIO)
+		Msg.Data[1] = BW_ISDBT_13SEG;
+
+	c->bandwidth_hz = 6000000;
+
 	sms_info("%s: freq %d segwidth %d segindex %d\n", __func__,
 		 c->frequency, c->isdbt_sb_segment_count,
 		 c->isdbt_sb_segment_idx);
-- 
1.8.1.4

