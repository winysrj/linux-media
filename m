Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:35906 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728473AbeJEUgi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 Oct 2018 16:36:38 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 5/6] cec: fix the Signal Free Time calculation
Date: Fri,  5 Oct 2018 15:37:44 +0200
Message-Id: <20181005133745.8593-6-hverkuil@xs4all.nl>
In-Reply-To: <20181005133745.8593-1-hverkuil@xs4all.nl>
References: <20181005133745.8593-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The calculation of the Signal Free Time in the framework was not
correct. If a message was received, then the next transmit should be
considered a New Initiator and use a shorter SFT value.

This was not done with the result that if both sides where continually
sending messages, they both could use the same SFT value and one side
could deny the other side access to the bus.

Note that this fix does not take the corner case into account where
a receive is in progress when you call adap_transmit.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/cec/cec-adap.c | 26 +++++++-------------------
 include/media/cec.h          |  2 +-
 2 files changed, 8 insertions(+), 20 deletions(-)

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index e6e82b504e56..0c0d9107383e 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -526,9 +526,11 @@ int cec_thread_func(void *_adap)
 		if (data->attempts) {
 			/* should be >= 3 data bit periods for a retry */
 			signal_free_time = CEC_SIGNAL_FREE_TIME_RETRY;
-		} else if (data->new_initiator) {
+		} else if (adap->last_initiator !=
+			   cec_msg_initiator(&data->msg)) {
 			/* should be >= 5 data bit periods for new initiator */
 			signal_free_time = CEC_SIGNAL_FREE_TIME_NEW_INITIATOR;
+			adap->last_initiator = cec_msg_initiator(&data->msg);
 		} else {
 			/*
 			 * should be >= 7 data bit periods for sending another
@@ -713,7 +715,6 @@ int cec_transmit_msg_fh(struct cec_adapter *adap, struct cec_msg *msg,
 			struct cec_fh *fh, bool block)
 {
 	struct cec_data *data;
-	u8 last_initiator = 0xff;
 
 	msg->rx_ts = 0;
 	msg->tx_ts = 0;
@@ -823,23 +824,6 @@ int cec_transmit_msg_fh(struct cec_adapter *adap, struct cec_msg *msg,
 	data->adap = adap;
 	data->blocking = block;
 
-	/*
-	 * Determine if this message follows a message from the same
-	 * initiator. Needed to determine the free signal time later on.
-	 */
-	if (msg->len > 1) {
-		if (!(list_empty(&adap->transmit_queue))) {
-			const struct cec_data *last;
-
-			last = list_last_entry(&adap->transmit_queue,
-					       const struct cec_data, list);
-			last_initiator = cec_msg_initiator(&last->msg);
-		} else if (adap->transmitting) {
-			last_initiator =
-				cec_msg_initiator(&adap->transmitting->msg);
-		}
-	}
-	data->new_initiator = last_initiator != cec_msg_initiator(msg);
 	init_completion(&data->c);
 	INIT_DELAYED_WORK(&data->work, cec_wait_timeout);
 
@@ -1027,6 +1011,8 @@ void cec_received_msg_ts(struct cec_adapter *adap,
 	mutex_lock(&adap->lock);
 	dprintk(2, "%s: %*ph\n", __func__, msg->len, msg->msg);
 
+	adap->last_initiator = 0xff;
+
 	/* Check if this message was for us (directed or broadcast). */
 	if (!cec_msg_is_broadcast(msg))
 		valid_la = cec_has_log_addr(adap, msg_dest);
@@ -1489,6 +1475,8 @@ void __cec_s_phys_addr(struct cec_adapter *adap, u16 phys_addr, bool block)
 	}
 
 	mutex_lock(&adap->devnode.lock);
+	adap->last_initiator = 0xff;
+
 	if ((adap->needs_hpd || list_empty(&adap->devnode.fhs)) &&
 	    adap->ops->adap_enable(adap, true)) {
 		mutex_unlock(&adap->devnode.lock);
diff --git a/include/media/cec.h b/include/media/cec.h
index 9f382f0c2970..254a610b9aa5 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -63,7 +63,6 @@ struct cec_data {
 	struct delayed_work work;
 	struct completion c;
 	u8 attempts;
-	bool new_initiator;
 	bool blocking;
 	bool completed;
 };
@@ -174,6 +173,7 @@ struct cec_adapter {
 	bool is_configuring;
 	bool is_configured;
 	bool cec_pin_is_high;
+	u8 last_initiator;
 	u32 monitor_all_cnt;
 	u32 monitor_pin_cnt;
 	u32 follower_cnt;
-- 
2.18.0
