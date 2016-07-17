Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:41967 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750959AbcGQPCp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 11:02:45 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/7] cec: clear all status fields before transmit and always fill in sequence
Date: Sun, 17 Jul 2016 17:02:29 +0200
Message-Id: <1468767754-48542-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1468767754-48542-1-git-send-email-hverkuil@xs4all.nl>
References: <1468767754-48542-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Before transmitting a message clear all status fields and always fill
in the sequence number. Make sure the sequence number is never 0.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/cec/cec-adap.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/media/cec/cec-adap.c b/drivers/staging/media/cec/cec-adap.c
index 4d86a6c..2b34c0f 100644
--- a/drivers/staging/media/cec/cec-adap.c
+++ b/drivers/staging/media/cec/cec-adap.c
@@ -574,6 +574,19 @@ int cec_transmit_msg_fh(struct cec_adapter *adap, struct cec_msg *msg,
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
+	msg->flags = 0;
+	msg->sequence = ++adap->sequence;
+	if (!msg->sequence)
+		msg->sequence = ++adap->sequence;
+
 	if (msg->reply && msg->timeout == 0) {
 		/* Make sure the timeout isn't 0. */
 		msg->timeout = 1000;
@@ -640,14 +653,6 @@ int cec_transmit_msg_fh(struct cec_adapter *adap, struct cec_msg *msg,
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
 	data->msg = *msg;
 	data->fh = fh;
 	data->adap = adap;
@@ -673,7 +678,6 @@ int cec_transmit_msg_fh(struct cec_adapter *adap, struct cec_msg *msg,
 	init_completion(&data->c);
 	INIT_DELAYED_WORK(&data->work, cec_wait_timeout);
 
-	data->msg.sequence = adap->sequence++;
 	if (fh)
 		list_add_tail(&data->xfer_list, &fh->xfer_list);
 	list_add_tail(&data->list, &adap->transmit_queue);
-- 
2.8.1

