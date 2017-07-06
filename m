Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:59662 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751965AbdGFOKA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Jul 2017 10:10:00 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec: only increase the seqnr if CEC_TRANSMIT would return 0
Message-ID: <ab0887fb-e197-a065-339d-29955a08322a@xs4all.nl>
Date: Thu, 6 Jul 2017 16:09:52 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The transmit code would increase the sequence number first thing, even though
CEC_TRANSMIT would return an error due to a malformatted cec_msg struct later
on.

While valid behavior, this had the disadvantage of producing holes in the
sequence list that made debugging harder.

Only increase the sequence number when the whole message is validated.
When debugging (i.e. with cec-ctl -M) the sequence numbering is now nicely
increasing by 1 per message.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index bf45977b2823..66cd18d1de9e 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -630,9 +630,7 @@ int cec_transmit_msg_fh(struct cec_adapter *adap, struct cec_msg *msg,
 	msg->tx_nack_cnt = 0;
 	msg->tx_low_drive_cnt = 0;
 	msg->tx_error_cnt = 0;
-	msg->sequence = ++adap->sequence;
-	if (!msg->sequence)
-		msg->sequence = ++adap->sequence;
+	msg->sequence = 0;

 	if (msg->reply && msg->timeout == 0) {
 		/* Make sure the timeout isn't 0. */
@@ -671,6 +669,9 @@ int cec_transmit_msg_fh(struct cec_adapter *adap, struct cec_msg *msg,
 			msg->tx_status = CEC_TX_STATUS_NACK |
 					 CEC_TX_STATUS_MAX_RETRIES;
 			msg->tx_nack_cnt = 1;
+			msg->sequence = ++adap->sequence;
+			if (!msg->sequence)
+				msg->sequence = ++adap->sequence;
 			return 0;
 		}
 	}
@@ -705,6 +706,10 @@ int cec_transmit_msg_fh(struct cec_adapter *adap, struct cec_msg *msg,
 	if (!data)
 		return -ENOMEM;

+	msg->sequence = ++adap->sequence;
+	if (!msg->sequence)
+		msg->sequence = ++adap->sequence;
+
 	if (msg->len > 1 && msg->msg[1] == CEC_MSG_CDC_MESSAGE) {
 		msg->msg[2] = adap->phys_addr >> 8;
 		msg->msg[3] = adap->phys_addr & 0xff;
