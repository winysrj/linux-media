Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:47026 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751430AbcGPK1u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jul 2016 06:27:50 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 9B5DB18372C
	for <linux-media@vger.kernel.org>; Sat, 16 Jul 2016 12:27:45 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec: clear fields before transmit and set sequence only if
 timeout !=0
Message-ID: <b65e2709-df56-e26d-0964-2efa18b8f4d8@xs4all.nl>
Date: Sat, 16 Jul 2016 12:27:45 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Clear all status-related fields before transmitting the message.

Also set the sequence counter only for messages with a non-zero timeout (== they wait for
a reply) and make sure the sequence counter is never 0.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/staging/media/cec/cec-adap.c b/drivers/staging/media/cec/cec-adap.c
index 4d86a6c..fc752de 100644
--- a/drivers/staging/media/cec/cec-adap.c
+++ b/drivers/staging/media/cec/cec-adap.c
@@ -574,6 +574,17 @@ int cec_transmit_msg_fh(struct cec_adapter *adap, struct cec_msg *msg,
 	unsigned int timeout;
 	int res = 0;

+	msg->rx_ts = 0;
+	msg->tx_ts = 0;
+	msg->rx_status = 0;
+	msg->tx_status = 0;
+	msg->tx_arb_lost_cnt = 0;
+	msg->tx_nack_cnt = 0;
+	msg->tx_low_drive_cnt = 0;
+	msg->tx_error_cnt = 0;
+	msg->sequence = 0;
+	msg->flags = 0;
+
 	if (msg->reply && msg->timeout == 0) {
 		/* Make sure the timeout isn't 0. */
 		msg->timeout = 1000;
@@ -640,14 +651,12 @@ int cec_transmit_msg_fh(struct cec_adapter *adap, struct cec_msg *msg,
 		dprintk(2, "cec_transmit_msg: %*ph%s\n",
 			msg->len, msg->msg, !block ? " (nb)" : "");

-	msg->rx_ts = 0;
-	msg->tx_ts = 0;
-	msg->rx_status = 0;
-	msg->tx_status = 0;
-	msg->tx_arb_lost_cnt = 0;
-	msg->tx_nack_cnt = 0;
-	msg->tx_low_drive_cnt = 0;
-	msg->tx_error_cnt = 0;
+	if (msg->timeout) {
+		msg->sequence = ++adap->sequence;
+		if (!msg->sequence)
+			msg->sequence = ++adap->sequence;
+	}
+
 	data->msg = *msg;
 	data->fh = fh;
 	data->adap = adap;
@@ -673,7 +682,6 @@ int cec_transmit_msg_fh(struct cec_adapter *adap, struct cec_msg *msg,
 	init_completion(&data->c);
 	INIT_DELAYED_WORK(&data->work, cec_wait_timeout);

-	data->msg.sequence = adap->sequence++;
 	if (fh)
 		list_add_tail(&data->xfer_list, &fh->xfer_list);
 	list_add_tail(&data->list, &adap->transmit_queue);
