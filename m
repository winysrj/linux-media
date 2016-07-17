Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:60319 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750959AbcGQPCs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 11:02:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 5/7] cec: limit the size of the transmit queue
Date: Sun, 17 Jul 2016 17:02:32 +0200
Message-Id: <1468767754-48542-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1468767754-48542-1-git-send-email-hverkuil@xs4all.nl>
References: <1468767754-48542-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The size of the transmit queue was unlimited, which meant that
in non-blocking mode you could flood the CEC adapter with messages
to be transmitted.

Limit this to 18 messages.

Also print the number of pending transmits and the timeout value
in the status debugfs file.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/cec/cec-adap.c | 33 +++++++++++++++++++++++----------
 include/media/cec.h                  | 19 ++++++++++++++-----
 2 files changed, 37 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/media/cec/cec-adap.c b/drivers/staging/media/cec/cec-adap.c
index cd39a9a..159a893 100644
--- a/drivers/staging/media/cec/cec-adap.c
+++ b/drivers/staging/media/cec/cec-adap.c
@@ -156,10 +156,10 @@ static void cec_queue_msg_fh(struct cec_fh *fh, const struct cec_msg *msg)
 	list_add_tail(&entry->list, &fh->msgs);
 
 	/*
-	 * if the queue now has more than CEC_MAX_MSG_QUEUE_SZ
+	 * if the queue now has more than CEC_MAX_MSG_RX_QUEUE_SZ
 	 * messages, drop the oldest one and send a lost message event.
 	 */
-	if (fh->queued_msgs == CEC_MAX_MSG_QUEUE_SZ) {
+	if (fh->queued_msgs == CEC_MAX_MSG_RX_QUEUE_SZ) {
 		list_del(&entry->list);
 		goto lost_msgs;
 	}
@@ -278,10 +278,13 @@ static void cec_data_cancel(struct cec_data *data)
 	 * It's either the current transmit, or it is a pending
 	 * transmit. Take the appropriate action to clear it.
 	 */
-	if (data->adap->transmitting == data)
+	if (data->adap->transmitting == data) {
 		data->adap->transmitting = NULL;
-	else
+	} else {
 		list_del_init(&data->list);
+		if (!(data->msg.tx_status & CEC_TX_STATUS_OK))
+			data->adap->transmit_queue_sz--;
+	}
 
 	/* Mark it as an error */
 	data->msg.tx_ts = ktime_get_ns();
@@ -405,6 +408,7 @@ int cec_thread_func(void *_adap)
 		data = list_first_entry(&adap->transmit_queue,
 					struct cec_data, list);
 		list_del_init(&data->list);
+		adap->transmit_queue_sz--;
 		/* Make this the current transmitting message */
 		adap->transmitting = data;
 
@@ -498,6 +502,7 @@ void cec_transmit_done(struct cec_adapter *adap, u8 status, u8 arb_lost_cnt,
 		data->attempts--;
 		/* Add the message in front of the transmit queue */
 		list_add(&data->list, &adap->transmit_queue);
+		adap->transmit_queue_sz++;
 		goto wake_thread;
 	}
 
@@ -638,6 +643,9 @@ int cec_transmit_msg_fh(struct cec_adapter *adap, struct cec_msg *msg,
 	if (!adap->is_configured && !adap->is_configuring)
 		return -ENONET;
 
+	if (adap->transmit_queue_sz >= CEC_MAX_MSG_TX_QUEUE_SZ)
+		return -EBUSY;
+
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
@@ -682,6 +690,7 @@ int cec_transmit_msg_fh(struct cec_adapter *adap, struct cec_msg *msg,
 	if (fh)
 		list_add_tail(&data->xfer_list, &fh->xfer_list);
 	list_add_tail(&data->list, &adap->transmit_queue);
+	adap->transmit_queue_sz++;
 	if (!adap->transmitting)
 		wake_up_interruptible(&adap->kthread_waitq);
 
@@ -1621,15 +1630,19 @@ int cec_adap_status(struct seq_file *file, void *priv)
 			   adap->monitor_all_cnt);
 	data = adap->transmitting;
 	if (data)
-		seq_printf(file, "transmitting message: %*ph (reply: %02x)\n",
-			   data->msg.len, data->msg.msg, data->msg.reply);
+		seq_printf(file, "transmitting message: %*ph (reply: %02x, timeout: %ums)\n",
+			   data->msg.len, data->msg.msg, data->msg.reply,
+			   data->msg.timeout);
+	seq_printf(file, "pending transmits: %u\n", adap->transmit_queue_sz);
 	list_for_each_entry(data, &adap->transmit_queue, list) {
-		seq_printf(file, "queued tx message: %*ph (reply: %02x)\n",
-			   data->msg.len, data->msg.msg, data->msg.reply);
+		seq_printf(file, "queued tx message: %*ph (reply: %02x, timeout: %ums)\n",
+			   data->msg.len, data->msg.msg, data->msg.reply,
+			   data->msg.timeout);
 	}
 	list_for_each_entry(data, &adap->wait_queue, list) {
-		seq_printf(file, "message waiting for reply: %*ph (reply: %02x)\n",
-			   data->msg.len, data->msg.msg, data->msg.reply);
+		seq_printf(file, "message waiting for reply: %*ph (reply: %02x, timeout: %ums)\n",
+			   data->msg.len, data->msg.msg, data->msg.reply,
+			   data->msg.timeout);
 	}
 
 	call_void_op(adap, adap_status, file);
diff --git a/include/media/cec.h b/include/media/cec.h
index 9a791c0..dc7854b 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -126,12 +126,20 @@ struct cec_adap_ops {
  * With a transfer rate of at most 36 bytes per second this makes 18 messages
  * per second worst case.
  *
- * We queue at most 3 seconds worth of messages. The CEC specification requires
- * that messages are replied to within a second, so 3 seconds should give more
- * than enough margin. Since most messages are actually more than 2 bytes, this
- * is in practice a lot more than 3 seconds.
+ * We queue at most 3 seconds worth of received messages. The CEC specification
+ * requires that messages are replied to within a second, so 3 seconds should
+ * give more than enough margin. Since most messages are actually more than 2
+ * bytes, this is in practice a lot more than 3 seconds.
  */
-#define CEC_MAX_MSG_QUEUE_SZ		(18 * 3)
+#define CEC_MAX_MSG_RX_QUEUE_SZ		(18 * 3)
+
+/*
+ * The transmit queue is limited to 1 second worth of messages (worst case).
+ * Messages can be transmitted by userspace and kernel space. But for both it
+ * makes no sense to have a lot of messages queued up. One second seems
+ * reasonable.
+ */
+#define CEC_MAX_MSG_TX_QUEUE_SZ		(18 * 1)
 
 struct cec_adapter {
 	struct module *owner;
@@ -141,6 +149,7 @@ struct cec_adapter {
 	struct rc_dev *rc;
 
 	struct list_head transmit_queue;
+	unsigned int transmit_queue_sz;
 	struct list_head wait_queue;
 	struct cec_data *transmitting;
 
-- 
2.8.1

