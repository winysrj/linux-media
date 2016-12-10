Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:55588 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751639AbcLJJoR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Dec 2016 04:44:17 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH for v4.10 6/6] cec: fix race between configuring and unconfiguring
Date: Sat, 10 Dec 2016 10:44:13 +0100
Message-Id: <20161210094413.8832-7-hverkuil@xs4all.nl>
In-Reply-To: <20161210094413.8832-1-hverkuil@xs4all.nl>
References: <20161210094413.8832-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

This race was discovered by running cec-compliance -A with the cec module debug
parameter set to 2: suddenly the test would fail.

It turns out that this happens when the test configures the adapter in
non-blocking mode, then it waits for the CEC_EVENT_STATE_CHANGE event and once
the event is received it unconfigures the adapter.

What happened was that the unconfigure was executed while the configure was
still transmitting the Report Features and Report Physical Address messages.
This messed up the internal state of the cec_adapter.

The fix is to transmit those messages with the adap->lock mutex held (this will
just queue them up in the internal transmit queue, and not actually transmit
anything yet). Only unlock the mutex once everything is done. The main thread
will dequeue the messages from the internal transmit queue and transmit them
one by one, unless an unconfigure was done, and in that case any messages are
just dropped.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/cec/cec-adap.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index f3d4956..ebb5e391 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -1256,8 +1256,17 @@ static int cec_config_thread_func(void *arg)
 	adap->is_configured = true;
 	adap->is_configuring = false;
 	cec_post_state_event(adap);
-	mutex_unlock(&adap->lock);
 
+	/*
+	 * Now post the Report Features and Report Physical Address broadcast
+	 * messages. Note that these are non-blocking transmits, meaning that
+	 * they are just queued up and once adap->lock is unlocked the main
+	 * thread will kick in and start transmitting these.
+	 *
+	 * If after this function is done (but before one or more of these
+	 * messages are actually transmitted) the CEC adapter is unconfigured,
+	 * then any remaining messages will be dropped by the main thread.
+	 */
 	for (i = 0; i < las->num_log_addrs; i++) {
 		struct cec_msg msg = {};
 
@@ -1271,7 +1280,7 @@ static int cec_config_thread_func(void *arg)
 		if (las->log_addr[i] != CEC_LOG_ADDR_UNREGISTERED &&
 		    adap->log_addrs.cec_version >= CEC_OP_CEC_VERSION_2_0) {
 			cec_fill_msg_report_features(adap, &msg, i);
-			cec_transmit_msg(adap, &msg, false);
+			cec_transmit_msg_fh(adap, &msg, NULL, false);
 		}
 
 		/* Report Physical Address */
@@ -1280,12 +1289,11 @@ static int cec_config_thread_func(void *arg)
 		dprintk(2, "config: la %d pa %x.%x.%x.%x\n",
 			las->log_addr[i],
 			cec_phys_addr_exp(adap->phys_addr));
-		cec_transmit_msg(adap, &msg, false);
+		cec_transmit_msg_fh(adap, &msg, NULL, false);
 	}
-	mutex_lock(&adap->lock);
 	adap->kthread_config = NULL;
-	mutex_unlock(&adap->lock);
 	complete(&adap->config_completion);
+	mutex_unlock(&adap->lock);
 	return 0;
 
 unconfigure:
-- 
2.10.2

