Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:47506 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751920AbcGMHeI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2016 03:34:08 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 98F36180C37
	for <linux-media@vger.kernel.org>; Wed, 13 Jul 2016 09:33:58 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec: don't zero reply and timeout on error
Message-ID: <61f9764b-3189-81ab-38fe-e7c87f583491@xs4all.nl>
Date: Wed, 13 Jul 2016 09:33:58 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is really no reason to zero the reply and timeout fields if an
error occurs. This is a left-over from earlier versions where that
was used to signal errors, but this is now handled by the rx/tx_status
fields.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/cec/cec-adap.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/media/cec/cec-adap.c b/drivers/staging/media/cec/cec-adap.c
index ca34339..07147a1 100644
--- a/drivers/staging/media/cec/cec-adap.c
+++ b/drivers/staging/media/cec/cec-adap.c
@@ -289,7 +289,6 @@ static void cec_data_cancel(struct cec_data *data)
 			      CEC_TX_STATUS_MAX_RETRIES;
 	data->attempts = 0;
 	data->msg.tx_error_cnt = 1;
-	data->msg.reply = 0;
 	/* Queue transmitted message for monitoring purposes */
 	cec_queue_msg_monitor(data->adap, &data->msg, 1);

@@ -511,16 +510,8 @@ void cec_transmit_done(struct cec_adapter *adap, u8 status, u8 arb_lost_cnt,
 	/* Queue transmitted message for monitoring purposes */
 	cec_queue_msg_monitor(adap, msg, 1);

-	/*
-	 * Clear reply and timeout on error or if the adapter is no longer
-	 * configured. It makes no sense to wait for a reply in that case.
-	 */
-	if (!(status & CEC_TX_STATUS_OK) || !adap->is_configured) {
-		msg->reply = 0;
-		msg->timeout = 0;
-	}
-
-	if (msg->timeout) {
+	if ((status & CEC_TX_STATUS_OK) && adap->is_configured &&
+	    msg->timeout) {
 		/*
 		 * Queue the message into the wait queue if we want to wait
 		 * for a reply.
@@ -648,6 +639,8 @@ int cec_transmit_msg_fh(struct cec_adapter *adap, struct cec_msg *msg,
 		dprintk(2, "cec_transmit_msg: %*ph%s\n",
 			msg->len, msg->msg, !block ? " (nb)" : "");

+	msg->rx_ts = 0;
+	msg->tx_ts = 0;
 	msg->rx_status = 0;
 	msg->tx_status = 0;
 	msg->tx_arb_lost_cnt = 0;
@@ -812,10 +805,8 @@ void cec_received_msg(struct cec_adapter *adap, struct cec_msg *msg)
 			dst->len = msg->len;
 			dst->rx_ts = msg->rx_ts;
 			dst->rx_status = msg->rx_status;
-			if (abort) {
-				dst->reply = 0;
+			if (abort)
 				dst->rx_status |= CEC_RX_STATUS_FEATURE_ABORT;
-			}
 			/* Remove it from the wait_queue */
 			list_del_init(&data->list);

-- 
2.8.1

