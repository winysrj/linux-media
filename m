Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933079Ab3CSQuR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 12:50:17 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doron Cohen <doronc@siano-ms.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 19/46] [media] siano: add support for LNA on ISDB-T
Date: Tue, 19 Mar 2013 13:49:08 -0300
Message-Id: <1363711775-2120-20-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
References: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The very same code also exists for DVB-T. Add it for ISDB-T.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/smsdvb.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/media/common/siano/smsdvb.c b/drivers/media/common/siano/smsdvb.c
index 4900aa9..864f53e 100644
--- a/drivers/media/common/siano/smsdvb.c
+++ b/drivers/media/common/siano/smsdvb.c
@@ -655,7 +655,7 @@ static int smsdvb_isdbt_set_frontend(struct dvb_frontend *fe)
 	int board_id = smscore_get_board_id(client->coredev);
 	struct sms_board *board = sms_get_board(board_id);
 	enum sms_device_type_st type = board->type;
-
+	int ret;
 	struct {
 		struct SmsMsgHdr_ST	Msg;
 		u32		Data[4];
@@ -695,6 +695,23 @@ static int smsdvb_isdbt_set_frontend(struct dvb_frontend *fe)
 		 c->frequency, c->isdbt_sb_segment_count,
 		 c->isdbt_sb_segment_idx);
 
+	/* Disable LNA, if any. An error is returned if no LNA is present */
+	ret = sms_board_lna_control(client->coredev, 0);
+	if (ret == 0) {
+		fe_status_t status;
+
+		/* tune with LNA off at first */
+		ret = smsdvb_sendrequest_and_wait(client, &Msg, sizeof(Msg),
+						  &client->tune_done);
+
+		smsdvb_read_status(fe, &status);
+
+		if (status & FE_HAS_LOCK)
+			return ret;
+
+		/* previous tune didn't lock - enable LNA and tune again */
+		sms_board_lna_control(client->coredev, 1);
+	}
 	return smsdvb_sendrequest_and_wait(client, &Msg, sizeof(Msg),
 					   &client->tune_done);
 }
-- 
1.8.1.4

