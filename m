Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-4.cisco.com ([173.38.203.54]:22077 "EHLO
	aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084AbcGLOKp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 10:10:45 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/2] cec: split the timestamp into an rx and tx timestamp
Date: Tue, 12 Jul 2016 16:10:42 +0200
Message-Id: <1468332642-24915-3-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <1468332642-24915-1-git-send-email-hans.verkuil@cisco.com>
References: <1468332642-24915-1-git-send-email-hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When transmitting a message and waiting for a reply it would be good
to know the time between when the message was transmitted and when
the reply arrived. With only one timestamp field it was set to when
the reply arrived and the original transmit time was overwritten.

Just taking the timestamp in userspace right before CEC_TRANSMIT is
called is not reliable, since the actual transmit can be delayed if the CEC bus
is busy. Only the driver can fill this in accurately.

So split up the ts field into an rx_ts and a tx_ts. Also move the
status fields to after the 'reply' field: they were placed in a
strange position and make much more sense when grouped with the
other status-related fields.

This patch also makes sure that the timestamp is taken as soon as
possible.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/cec/cec-adap.c | 24 ++++++++++++------------
 include/linux/cec.h                  | 18 ++++++++++--------
 2 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/media/cec/cec-adap.c b/drivers/staging/media/cec/cec-adap.c
index 936df93..154aadb 100644
--- a/drivers/staging/media/cec/cec-adap.c
+++ b/drivers/staging/media/cec/cec-adap.c
@@ -280,7 +280,7 @@ static void cec_data_cancel(struct cec_data *data)
 		list_del_init(&data->list);
 
 	/* Mark it as an error */
-	data->msg.ts = ktime_get_ns();
+	data->msg.tx_ts = ktime_get_ns();
 	data->msg.tx_status = CEC_TX_STATUS_ERROR |
 			      CEC_TX_STATUS_MAX_RETRIES;
 	data->attempts = 0;
@@ -455,6 +455,7 @@ void cec_transmit_done(struct cec_adapter *adap, u8 status, u8 arb_lost_cnt,
 {
 	struct cec_data *data;
 	struct cec_msg *msg;
+	u64 ts = ktime_get_ns();
 
 	dprintk(2, "cec_transmit_done %02x\n", status);
 	mutex_lock(&adap->lock);
@@ -473,7 +474,7 @@ void cec_transmit_done(struct cec_adapter *adap, u8 status, u8 arb_lost_cnt,
 
 	/* Drivers must fill in the status! */
 	WARN_ON(status == 0);
-	msg->ts = ktime_get_ns();
+	msg->tx_ts = ts;
 	msg->tx_status |= status;
 	msg->tx_arb_lost_cnt += arb_lost_cnt;
 	msg->tx_nack_cnt += nack_cnt;
@@ -557,7 +558,7 @@ static void cec_wait_timeout(struct work_struct *work)
 
 	/* Mark the message as timed out */
 	list_del_init(&data->list);
-	data->msg.ts = ktime_get_ns();
+	data->msg.rx_ts = ktime_get_ns();
 	data->msg.rx_status = CEC_RX_STATUS_TIMEOUT;
 	cec_data_completed(data);
 unlock:
@@ -762,13 +763,14 @@ void cec_received_msg(struct cec_adapter *adap, struct cec_msg *msg)
 	if (WARN_ON(!msg->len || msg->len > CEC_MAX_MSG_SIZE))
 		return;
 
-	mutex_lock(&adap->lock);
-	msg->ts = ktime_get_ns();
+	msg->rx_ts = ktime_get_ns();
 	msg->rx_status = CEC_RX_STATUS_OK;
-	msg->tx_status = 0;
 	msg->sequence = msg->reply = msg->timeout = 0;
+	msg->tx_status = 0;
+	msg->tx_ts = 0;
 	msg->flags = 0;
 
+	mutex_lock(&adap->lock);
 	dprintk(2, "cec_received_msg: %*ph\n", msg->len, msg->msg);
 
 	/* Check if this message was for us (directed or broadcast). */
@@ -790,7 +792,6 @@ void cec_received_msg(struct cec_adapter *adap, struct cec_msg *msg)
 		 */
 		list_for_each_entry(data, &adap->wait_queue, list) {
 			struct cec_msg *dst = &data->msg;
-			u8 dst_reply;
 
 			/* Does the command match? */
 			if ((abort && cmd != dst->msg[1]) ||
@@ -803,11 +804,10 @@ void cec_received_msg(struct cec_adapter *adap, struct cec_msg *msg)
 				continue;
 
 			/* We got a reply */
-			msg->sequence = dst->sequence;
-			msg->tx_status = dst->tx_status;
-			dst_reply = dst->reply;
-			*dst = *msg;
-			dst->reply = dst_reply;
+			memcpy(dst->msg, msg->msg, msg->len);
+			dst->len = msg->len;
+			dst->rx_ts = msg->rx_ts;
+			dst->rx_status = msg->rx_status;
 			if (abort) {
 				dst->reply = 0;
 				dst->rx_status |= CEC_RX_STATUS_FEATURE_ABORT;
diff --git a/include/linux/cec.h b/include/linux/cec.h
index 6678afe..b3e2289 100644
--- a/include/linux/cec.h
+++ b/include/linux/cec.h
@@ -48,9 +48,10 @@
 
 /**
  * struct cec_msg - CEC message structure.
- * @ts:		Timestamp in nanoseconds using CLOCK_MONOTONIC. Set by the
- *		driver. It is set when the message transmission has finished
- *		and it is set when a message was received.
+ * @tx_ts:	Timestamp in nanoseconds using CLOCK_MONOTONIC. Set by the
+ *		driver when the message transmission has finished.
+ * @rx_ts:	Timestamp in nanoseconds using CLOCK_MONOTONIC. Set by the
+ *		driver when the message was received.
  * @len:	Length in bytes of the message.
  * @timeout:	The timeout (in ms) that is used to timeout CEC_RECEIVE.
  *		Set to 0 if you want to wait forever. This timeout can also be
@@ -61,8 +62,6 @@
  *		sent. This can be used to track replies to previously sent
  *		messages.
  * @flags:	Set to 0.
- * @rx_status:	The message receive status bits. Set by the driver.
- * @tx_status:	The message transmit status bits. Set by the driver.
  * @msg:	The message payload.
  * @reply:	This field is ignored with CEC_RECEIVE and is only used by
  *		CEC_TRANSMIT. If non-zero, then wait for a reply with this
@@ -80,6 +79,8 @@
  *		broadcast, then -EINVAL is returned.
  *		if reply is non-zero, then timeout is set to 1000 (the required
  *		maximum response time).
+ * @rx_status:	The message receive status bits. Set by the driver.
+ * @tx_status:	The message transmit status bits. Set by the driver.
  * @tx_arb_lost_cnt: The number of 'Arbitration Lost' events. Set by the driver.
  * @tx_nack_cnt: The number of 'Not Acknowledged' events. Set by the driver.
  * @tx_low_drive_cnt: The number of 'Low Drive Detected' events. Set by the
@@ -87,15 +88,16 @@
  * @tx_error_cnt: The number of 'Error' events. Set by the driver.
  */
 struct cec_msg {
-	__u64 ts;
+	__u64 tx_ts;
+	__u64 rx_ts;
 	__u32 len;
 	__u32 timeout;
 	__u32 sequence;
 	__u32 flags;
-	__u8 rx_status;
-	__u8 tx_status;
 	__u8 msg[CEC_MAX_MSG_SIZE];
 	__u8 reply;
+	__u8 rx_status;
+	__u8 tx_status;
 	__u8 tx_arb_lost_cnt;
 	__u8 tx_nack_cnt;
 	__u8 tx_low_drive_cnt;
-- 
2.7.0

