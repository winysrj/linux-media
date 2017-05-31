Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:41530 "EHLO
        aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751015AbdEaKAk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 May 2017 06:00:40 -0400
Received: from [10.47.79.81] ([10.47.79.81])
        (authenticated bits=0)
        by aer-core-2.cisco.com (8.14.5/8.14.5) with ESMTP id v4V9oQGZ016503
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
        for <linux-media@vger.kernel.org>; Wed, 31 May 2017 09:50:27 GMT
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH] cec: improve debug messages
Message-ID: <6e3b5b64-ab7b-afac-882d-144c49d8ac82@cisco.com>
Date: Wed, 31 May 2017 11:50:26 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- use __func__ instead of writing the full function name
- drop debug message in cec_config_log_addr since the same information
  will be reported later
- use debug level 1 for errors and infrequent events, use level 2 for
  debugging CEC message traffic
- log when a transmit is retried, very useful to know when debugging
- debug messages now all start with lower case

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/cec/cec-adap.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index f5fe01c9da8a..f85eae710043 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -392,7 +392,7 @@ int cec_thread_func(void *_adap)
 			 * happen and is an indication of a faulty CEC adapter
 			 * driver, or the CEC bus is in some weird state.
 			 */
-			dprintk(0, "message %*ph timed out!\n",
+			dprintk(0, "%s: message %*ph timed out!\n", __func__,
 				adap->transmitting->msg.len,
 				adap->transmitting->msg.msg);
 			/* Just give up on this. */
@@ -468,7 +468,7 @@ void cec_transmit_done(struct cec_adapter *adap, u8 status, u8 arb_lost_cnt,
 	struct cec_msg *msg;
 	u64 ts = ktime_get_ns();

-	dprintk(2, "cec_transmit_done %02x\n", status);
+	dprintk(2, "%s: status %02x\n", __func__, status);
 	mutex_lock(&adap->lock);
 	data = adap->transmitting;
 	if (!data) {
@@ -477,7 +477,8 @@ void cec_transmit_done(struct cec_adapter *adap, u8 status, u8 arb_lost_cnt,
 		 * unplugged while the transmit is ongoing. Ignore this
 		 * transmit in that case.
 		 */
-		dprintk(1, "cec_transmit_done without an ongoing transmit!\n");
+		dprintk(1, "%s was called without an ongoing transmit!\n",
+			__func__);
 		goto unlock;
 	}

@@ -504,6 +505,12 @@ void cec_transmit_done(struct cec_adapter *adap, u8 status, u8 arb_lost_cnt,
 	    !(status & (CEC_TX_STATUS_MAX_RETRIES | CEC_TX_STATUS_OK))) {
 		/* Retry this message */
 		data->attempts--;
+		if (msg->timeout)
+			dprintk(2, "retransmit: %*ph (attempts: %d, wait for 0x%02x)\n",
+				msg->len, msg->msg, data->attempts, msg->reply);
+		else
+			dprintk(2, "retransmit: %*ph (attempts: %d)\n",
+				msg->len, msg->msg, data->attempts);
 		/* Add the message in front of the transmit queue */
 		list_add(&data->list, &adap->transmit_queue);
 		adap->transmit_queue_sz++;
@@ -911,7 +918,7 @@ void cec_received_msg(struct cec_adapter *adap, struct cec_msg *msg)
 	memset(msg->msg + msg->len, 0, sizeof(msg->msg) - msg->len);

 	mutex_lock(&adap->lock);
-	dprintk(2, "cec_received_msg: %*ph\n", msg->len, msg->msg);
+	dprintk(2, "%s: %*ph\n", __func__, msg->len, msg->msg);

 	/* Check if this message was for us (directed or broadcast). */
 	if (!cec_msg_is_broadcast(msg))
@@ -1112,9 +1119,6 @@ static int cec_config_log_addr(struct cec_adapter *adap,
 	las->log_addr[idx] = log_addr;
 	las->log_addr_mask |= 1 << log_addr;
 	adap->phys_addrs[log_addr] = adap->phys_addr;
-
-	dprintk(2, "claimed addr %d (%d)\n", log_addr,
-		las->primary_device_type[idx]);
 	return 1;
 }

@@ -1300,7 +1304,7 @@ static int cec_config_thread_func(void *arg)
 		/* Report Physical Address */
 		cec_msg_report_physical_addr(&msg, adap->phys_addr,
 					     las->primary_device_type[i]);
-		dprintk(2, "config: la %d pa %x.%x.%x.%x\n",
+		dprintk(1, "config: la %d pa %x.%x.%x.%x\n",
 			las->log_addr[i],
 			cec_phys_addr_exp(adap->phys_addr));
 		cec_transmit_msg_fh(adap, &msg, NULL, false);
@@ -1534,12 +1538,12 @@ int __cec_s_log_addrs(struct cec_adapter *adap,
 		if (log_addrs->num_log_addrs == 2) {
 			if (!(type_mask & ((1 << CEC_LOG_ADDR_TYPE_AUDIOSYSTEM) |
 					   (1 << CEC_LOG_ADDR_TYPE_TV)))) {
-				dprintk(1, "Two LAs is only allowed for audiosystem and TV\n");
+				dprintk(1, "two LAs is only allowed for audiosystem and TV\n");
 				return -EINVAL;
 			}
 			if (!(type_mask & ((1 << CEC_LOG_ADDR_TYPE_PLAYBACK) |
 					   (1 << CEC_LOG_ADDR_TYPE_RECORD)))) {
-				dprintk(1, "An audiosystem/TV can only be combined with record or playback\n");
+				dprintk(1, "an audiosystem/TV can only be combined with record or playback\n");
 				return -EINVAL;
 			}
 		}
@@ -1653,7 +1657,7 @@ static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,
 	bool from_unregistered = init_laddr == 0xf;
 	struct cec_msg tx_cec_msg = { };

-	dprintk(1, "cec_receive_notify: %*ph\n", msg->len, msg->msg);
+	dprintk(2, "%s: %*ph\n", __func__, msg->len, msg->msg);

 	/* If this is a CDC-Only device, then ignore any non-CDC messages */
 	if (cec_is_cdc_only(&adap->log_addrs) &&
@@ -1722,7 +1726,7 @@ static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,

 		if (!from_unregistered)
 			adap->phys_addrs[init_laddr] = pa;
-		dprintk(1, "Reported physical address %x.%x.%x.%x for logical address %d\n",
+		dprintk(1, "reported physical address %x.%x.%x.%x for logical address %d\n",
 			cec_phys_addr_exp(pa), init_laddr);
 		break;
 	}
-- 
2.11.0
