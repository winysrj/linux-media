Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:53743 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727225AbeJDQB0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 Oct 2018 12:01:26 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/5] cec: add new tx/rx status bits to detect aborts/timeouts
Date: Thu,  4 Oct 2018 11:08:56 +0200
Message-Id: <20181004090900.32915-2-hverkuil@xs4all.nl>
In-Reply-To: <20181004090900.32915-1-hverkuil@xs4all.nl>
References: <20181004090900.32915-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

If the HDMI cable is disconnected or the CEC adapter is manually
unconfigured, then all pending transmits and wait-for-replies are
aborted. Signal this with new status bits (CEC_RX/TX_STATUS_ABORTED).

If due to (usually) a driver bug a transmit never ends (i.e. the
transmit_done was never called by the driver), then when this times
out the message is marked with CEC_TX_STATUS_TIMEOUT.

This should not happen and is an indication of a driver bug.

Without a separate status bit for this it was impossible to detect
this from userspace.

The 'transmit timed out' kernel message is now a warning, so this
should be more prominent in the kernel log as well.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../media/uapi/cec/cec-ioc-receive.rst        | 25 ++++++-
 drivers/media/cec/cec-adap.c                  | 66 +++++--------------
 include/uapi/linux/cec.h                      |  3 +
 3 files changed, 44 insertions(+), 50 deletions(-)

diff --git a/Documentation/media/uapi/cec/cec-ioc-receive.rst b/Documentation/media/uapi/cec/cec-ioc-receive.rst
index e964074cd15b..b25e48afaa08 100644
--- a/Documentation/media/uapi/cec/cec-ioc-receive.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-receive.rst
@@ -16,10 +16,10 @@ CEC_RECEIVE, CEC_TRANSMIT - Receive or transmit a CEC message
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, CEC_RECEIVE, struct cec_msg *argp )
+.. c:function:: int ioctl( int fd, CEC_RECEIVE, struct cec_msg \*argp )
     :name: CEC_RECEIVE
 
-.. c:function:: int ioctl( int fd, CEC_TRANSMIT, struct cec_msg *argp )
+.. c:function:: int ioctl( int fd, CEC_TRANSMIT, struct cec_msg \*argp )
     :name: CEC_TRANSMIT
 
 Arguments
@@ -272,6 +272,19 @@ View On' messages from initiator 0xf ('Unregistered') to destination 0 ('TV').
       - The transmit failed after one or more retries. This status bit is
 	mutually exclusive with :ref:`CEC_TX_STATUS_OK <CEC-TX-STATUS-OK>`.
 	Other bits can still be set to explain which failures were seen.
+    * .. _`CEC-TX-STATUS-ABORTED`:
+
+      - ``CEC_TX_STATUS_ABORTED``
+      - 0x40
+      - The transmit was aborted due to an HDMI disconnect, or the adapter
+        was unconfigured, or a transmit was interrupted, or the driver
+	returned an error when attempting to start a transmit.
+    * .. _`CEC-TX-STATUS-TIMEOUT`:
+
+      - ``CEC_TX_STATUS_TIMEOUT``
+      - 0x80
+      - The transmit timed out. This should not normally happen and this
+	indicates a driver problem.
 
 
 .. tabularcolumns:: |p{5.6cm}|p{0.9cm}|p{11.0cm}|
@@ -300,6 +313,14 @@ View On' messages from initiator 0xf ('Unregistered') to destination 0 ('TV').
       - The message was received successfully but the reply was
 	``CEC_MSG_FEATURE_ABORT``. This status is only set if this message
 	was the reply to an earlier transmitted message.
+    * .. _`CEC-RX-STATUS-ABORTED`:
+
+      - ``CEC_RX_STATUS_ABORTED``
+      - 0x08
+      - The wait for a reply to an earlier transmitted message was aborted
+        because the HDMI cable was disconnected, the adapter was unconfigured
+	or the :ref:`CEC_TRANSMIT <CEC_RECEIVE>` that waited for a
+	reply was interrupted.
 
 
 
diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index 030b2602faf0..2ebb53fd4800 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -341,7 +341,7 @@ static void cec_data_completed(struct cec_data *data)
  *
  * This function is called with adap->lock held.
  */
-static void cec_data_cancel(struct cec_data *data)
+static void cec_data_cancel(struct cec_data *data, u8 tx_status)
 {
 	/*
 	 * It's either the current transmit, or it is a pending
@@ -356,13 +356,11 @@ static void cec_data_cancel(struct cec_data *data)
 	}
 
 	if (data->msg.tx_status & CEC_TX_STATUS_OK) {
-		/* Mark the canceled RX as a timeout */
 		data->msg.rx_ts = ktime_get_ns();
-		data->msg.rx_status = CEC_RX_STATUS_TIMEOUT;
+		data->msg.rx_status = CEC_RX_STATUS_ABORTED;
 	} else {
-		/* Mark the canceled TX as an error */
 		data->msg.tx_ts = ktime_get_ns();
-		data->msg.tx_status |= CEC_TX_STATUS_ERROR |
+		data->msg.tx_status |= tx_status |
 				       CEC_TX_STATUS_MAX_RETRIES;
 		data->msg.tx_error_cnt++;
 		data->attempts = 0;
@@ -390,15 +388,15 @@ static void cec_flush(struct cec_adapter *adap)
 	while (!list_empty(&adap->transmit_queue)) {
 		data = list_first_entry(&adap->transmit_queue,
 					struct cec_data, list);
-		cec_data_cancel(data);
+		cec_data_cancel(data, CEC_TX_STATUS_ABORTED);
 	}
 	if (adap->transmitting)
-		cec_data_cancel(adap->transmitting);
+		cec_data_cancel(adap->transmitting, CEC_TX_STATUS_ABORTED);
 
 	/* Cancel the pending timeout work. */
 	list_for_each_entry_safe(data, n, &adap->wait_queue, list) {
 		if (cancel_delayed_work(&data->work))
-			cec_data_cancel(data);
+			cec_data_cancel(data, CEC_TX_STATUS_OK);
 		/*
 		 * If cancel_delayed_work returned false, then
 		 * the cec_wait_timeout function is running,
@@ -474,12 +472,13 @@ int cec_thread_func(void *_adap)
 			 * so much traffic on the bus that the adapter was
 			 * unable to transmit for CEC_XFER_TIMEOUT_MS (2.1s).
 			 */
-			dprintk(1, "%s: message %*ph timed out\n", __func__,
+			pr_warn("cec-%s: message %*ph timed out\n", adap->name,
 				adap->transmitting->msg.len,
 				adap->transmitting->msg.msg);
 			adap->tx_timeouts++;
 			/* Just give up on this. */
-			cec_data_cancel(adap->transmitting);
+			cec_data_cancel(adap->transmitting,
+					CEC_TX_STATUS_TIMEOUT);
 			goto unlock;
 		}
 
@@ -530,7 +529,7 @@ int cec_thread_func(void *_adap)
 		/* Tell the adapter to transmit, cancel on error */
 		if (adap->ops->adap_transmit(adap, data->attempts,
 					     signal_free_time, &data->msg))
-			cec_data_cancel(data);
+			cec_data_cancel(data, CEC_TX_STATUS_ABORTED);
 
 unlock:
 		mutex_unlock(&adap->lock);
@@ -702,8 +701,6 @@ int cec_transmit_msg_fh(struct cec_adapter *adap, struct cec_msg *msg,
 {
 	struct cec_data *data;
 	u8 last_initiator = 0xff;
-	unsigned int timeout;
-	int res = 0;
 
 	msg->rx_ts = 0;
 	msg->tx_ts = 0;
@@ -845,48 +842,21 @@ int cec_transmit_msg_fh(struct cec_adapter *adap, struct cec_msg *msg,
 	if (!block)
 		return 0;
 
-	/*
-	 * If we don't get a completion before this time something is really
-	 * wrong and we time out.
-	 */
-	timeout = CEC_XFER_TIMEOUT_MS;
-	/* Add the requested timeout if we have to wait for a reply as well */
-	if (msg->timeout)
-		timeout += msg->timeout;
-
 	/*
 	 * Release the lock and wait, retake the lock afterwards.
 	 */
 	mutex_unlock(&adap->lock);
-	res = wait_for_completion_killable_timeout(&data->c,
-						   msecs_to_jiffies(timeout));
+	wait_for_completion_killable(&data->c);
 	mutex_lock(&adap->lock);
 
-	if (data->completed) {
-		/* The transmit completed (possibly with an error) */
-		*msg = data->msg;
-		kfree(data);
-		return 0;
-	}
-	/*
-	 * The wait for completion timed out or was interrupted, so mark this
-	 * as non-blocking and disconnect from the filehandle since it is
-	 * still 'in flight'. When it finally completes it will just drop the
-	 * result silently.
-	 */
-	data->blocking = false;
-	if (data->fh)
-		list_del(&data->xfer_list);
-	data->fh = NULL;
+	/* Cancel the transmit if it was interrupted */
+	if (!data->completed)
+		cec_data_cancel(data, CEC_TX_STATUS_ABORTED);
 
-	if (res == 0) { /* timed out */
-		/* Check if the reply or the transmit failed */
-		if (msg->timeout && (msg->tx_status & CEC_TX_STATUS_OK))
-			msg->rx_status = CEC_RX_STATUS_TIMEOUT;
-		else
-			msg->tx_status = CEC_TX_STATUS_MAX_RETRIES;
-	}
-	return res > 0 ? 0 : res;
+	/* The transmit completed (possibly with an error) */
+	*msg = data->msg;
+	kfree(data);
+	return 0;
 }
 
 /* Helper function to be used by drivers and this framework. */
diff --git a/include/uapi/linux/cec.h b/include/uapi/linux/cec.h
index 097fcd812471..3094af68b6e7 100644
--- a/include/uapi/linux/cec.h
+++ b/include/uapi/linux/cec.h
@@ -152,10 +152,13 @@ static inline void cec_msg_set_reply_to(struct cec_msg *msg,
 #define CEC_TX_STATUS_LOW_DRIVE		(1 << 3)
 #define CEC_TX_STATUS_ERROR		(1 << 4)
 #define CEC_TX_STATUS_MAX_RETRIES	(1 << 5)
+#define CEC_TX_STATUS_ABORTED		(1 << 6)
+#define CEC_TX_STATUS_TIMEOUT		(1 << 7)
 
 #define CEC_RX_STATUS_OK		(1 << 0)
 #define CEC_RX_STATUS_TIMEOUT		(1 << 1)
 #define CEC_RX_STATUS_FEATURE_ABORT	(1 << 2)
+#define CEC_RX_STATUS_ABORTED		(1 << 3)
 
 static inline int cec_msg_status_is_ok(const struct cec_msg *msg)
 {
-- 
2.18.0
