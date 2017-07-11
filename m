Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:57934 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755146AbdGKGas (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Jul 2017 02:30:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 02/11] cec: add *_ts variants for transmit_done/received_msg
Date: Tue, 11 Jul 2017 08:30:35 +0200
Message-Id: <20170711063044.29849-3-hverkuil@xs4all.nl>
In-Reply-To: <20170711063044.29849-1-hverkuil@xs4all.nl>
References: <20170711063044.29849-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Currently the transmit_(attempt_)done and received_msg functions set
the timestamp themselves. For the upcoming low-level pin API we need
to pass this as an argument instead. So make _ts variants that allow
the caller to specify the timestamp.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/cec/cec-adap.c | 35 +++++++++++++++++++----------------
 include/media/cec.h          | 32 ++++++++++++++++++++++++++++----
 2 files changed, 47 insertions(+), 20 deletions(-)

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index 644ce82ea2ed..b3163716d95f 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -471,12 +471,12 @@ int cec_thread_func(void *_adap)
 /*
  * Called by the CEC adapter if a transmit finished.
  */
-void cec_transmit_done(struct cec_adapter *adap, u8 status, u8 arb_lost_cnt,
-		       u8 nack_cnt, u8 low_drive_cnt, u8 error_cnt)
+void cec_transmit_done_ts(struct cec_adapter *adap, u8 status,
+			  u8 arb_lost_cnt, u8 nack_cnt, u8 low_drive_cnt,
+			  u8 error_cnt, ktime_t ts)
 {
 	struct cec_data *data;
 	struct cec_msg *msg;
-	u64 ts = ktime_get_ns();
 
 	dprintk(2, "%s: status %02x\n", __func__, status);
 	mutex_lock(&adap->lock);
@@ -496,7 +496,7 @@ void cec_transmit_done(struct cec_adapter *adap, u8 status, u8 arb_lost_cnt,
 
 	/* Drivers must fill in the status! */
 	WARN_ON(status == 0);
-	msg->tx_ts = ts;
+	msg->tx_ts = ktime_to_ns(ts);
 	msg->tx_status |= status;
 	msg->tx_arb_lost_cnt += arb_lost_cnt;
 	msg->tx_nack_cnt += nack_cnt;
@@ -559,25 +559,26 @@ void cec_transmit_done(struct cec_adapter *adap, u8 status, u8 arb_lost_cnt,
 unlock:
 	mutex_unlock(&adap->lock);
 }
-EXPORT_SYMBOL_GPL(cec_transmit_done);
+EXPORT_SYMBOL_GPL(cec_transmit_done_ts);
 
-void cec_transmit_attempt_done(struct cec_adapter *adap, u8 status)
+void cec_transmit_attempt_done_ts(struct cec_adapter *adap,
+				  u8 status, ktime_t ts)
 {
 	switch (status) {
 	case CEC_TX_STATUS_OK:
-		cec_transmit_done(adap, status, 0, 0, 0, 0);
+		cec_transmit_done_ts(adap, status, 0, 0, 0, 0, ts);
 		return;
 	case CEC_TX_STATUS_ARB_LOST:
-		cec_transmit_done(adap, status, 1, 0, 0, 0);
+		cec_transmit_done_ts(adap, status, 1, 0, 0, 0, ts);
 		return;
 	case CEC_TX_STATUS_NACK:
-		cec_transmit_done(adap, status, 0, 1, 0, 0);
+		cec_transmit_done_ts(adap, status, 0, 1, 0, 0, ts);
 		return;
 	case CEC_TX_STATUS_LOW_DRIVE:
-		cec_transmit_done(adap, status, 0, 0, 1, 0);
+		cec_transmit_done_ts(adap, status, 0, 0, 1, 0, ts);
 		return;
 	case CEC_TX_STATUS_ERROR:
-		cec_transmit_done(adap, status, 0, 0, 0, 1);
+		cec_transmit_done_ts(adap, status, 0, 0, 0, 1, ts);
 		return;
 	default:
 		/* Should never happen */
@@ -585,7 +586,7 @@ void cec_transmit_attempt_done(struct cec_adapter *adap, u8 status)
 		return;
 	}
 }
-EXPORT_SYMBOL_GPL(cec_transmit_attempt_done);
+EXPORT_SYMBOL_GPL(cec_transmit_attempt_done_ts);
 
 /*
  * Called when waiting for a reply times out.
@@ -716,7 +717,8 @@ int cec_transmit_msg_fh(struct cec_adapter *adap, struct cec_msg *msg,
 
 	if (msg->timeout)
 		dprintk(2, "%s: %*ph (wait for 0x%02x%s)\n",
-			__func__, msg->len, msg->msg, msg->reply, !block ? ", nb" : "");
+			__func__, msg->len, msg->msg, msg->reply,
+			!block ? ", nb" : "");
 	else
 		dprintk(2, "%s: %*ph%s\n",
 			__func__, msg->len, msg->msg, !block ? " (nb)" : "");
@@ -913,7 +915,8 @@ static const u8 cec_msg_size[256] = {
 };
 
 /* Called by the CEC adapter if a message is received */
-void cec_received_msg(struct cec_adapter *adap, struct cec_msg *msg)
+void cec_received_msg_ts(struct cec_adapter *adap,
+			 struct cec_msg *msg, ktime_t ts)
 {
 	struct cec_data *data;
 	u8 msg_init = cec_msg_initiator(msg);
@@ -941,7 +944,7 @@ void cec_received_msg(struct cec_adapter *adap, struct cec_msg *msg)
 	    cec_has_log_addr(adap, msg_init))
 		return;
 
-	msg->rx_ts = ktime_get_ns();
+	msg->rx_ts = ktime_to_ns(ts);
 	msg->rx_status = CEC_RX_STATUS_OK;
 	msg->sequence = msg->reply = msg->timeout = 0;
 	msg->tx_status = 0;
@@ -1106,7 +1109,7 @@ void cec_received_msg(struct cec_adapter *adap, struct cec_msg *msg)
 	 */
 	cec_receive_notify(adap, msg, is_reply);
 }
-EXPORT_SYMBOL_GPL(cec_received_msg);
+EXPORT_SYMBOL_GPL(cec_received_msg_ts);
 
 /* Logical Address Handling */
 
diff --git a/include/media/cec.h b/include/media/cec.h
index e32b0e1a81a4..e1e60dbb66c3 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -228,15 +228,39 @@ int cec_transmit_msg(struct cec_adapter *adap, struct cec_msg *msg,
 		     bool block);
 
 /* Called by the adapter */
-void cec_transmit_done(struct cec_adapter *adap, u8 status, u8 arb_lost_cnt,
-		       u8 nack_cnt, u8 low_drive_cnt, u8 error_cnt);
+void cec_transmit_done_ts(struct cec_adapter *adap, u8 status,
+			  u8 arb_lost_cnt, u8 nack_cnt, u8 low_drive_cnt,
+			  u8 error_cnt, ktime_t ts);
+
+static inline void cec_transmit_done(struct cec_adapter *adap, u8 status,
+				     u8 arb_lost_cnt, u8 nack_cnt,
+				     u8 low_drive_cnt, u8 error_cnt)
+{
+	cec_transmit_done_ts(adap, status, arb_lost_cnt, nack_cnt,
+			     low_drive_cnt, error_cnt, ktime_get());
+}
 /*
  * Simplified version of cec_transmit_done for hardware that doesn't retry
  * failed transmits. So this is always just one attempt in which case
  * the status is sufficient.
  */
-void cec_transmit_attempt_done(struct cec_adapter *adap, u8 status);
-void cec_received_msg(struct cec_adapter *adap, struct cec_msg *msg);
+void cec_transmit_attempt_done_ts(struct cec_adapter *adap,
+				  u8 status, ktime_t ts);
+
+static inline void cec_transmit_attempt_done(struct cec_adapter *adap,
+					     u8 status)
+{
+	cec_transmit_attempt_done_ts(adap, status, ktime_get());
+}
+
+void cec_received_msg_ts(struct cec_adapter *adap,
+			 struct cec_msg *msg, ktime_t ts);
+
+static inline void cec_received_msg(struct cec_adapter *adap,
+				    struct cec_msg *msg)
+{
+	cec_received_msg_ts(adap, msg, ktime_get());
+}
 
 /**
  * cec_get_edid_phys_addr() - find and return the physical address
-- 
2.11.0
