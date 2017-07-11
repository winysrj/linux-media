Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:34151 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754956AbdGKGas (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Jul 2017 02:30:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 01/11] cec: improve transmit timeout logging
Date: Tue, 11 Jul 2017 08:30:34 +0200
Message-Id: <20170711063044.29849-2-hverkuil@xs4all.nl>
In-Reply-To: <20170711063044.29849-1-hverkuil@xs4all.nl>
References: <20170711063044.29849-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Kernel logging messes up the upcoming low-level CEC monitoring support
which is very time-sensitive. So change the debug level of this message
but keep a counter that is shown in the debugfs status log.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/cec/cec-adap.c | 17 +++++++++++++----
 include/media/cec.h          |  2 ++
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index bf45977b2823..644ce82ea2ed 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -394,13 +394,17 @@ int cec_thread_func(void *_adap)
 
 		if (adap->transmitting && timeout) {
 			/*
-			 * If we timeout, then log that. This really shouldn't
-			 * happen and is an indication of a faulty CEC adapter
-			 * driver, or the CEC bus is in some weird state.
+			 * If we timeout, then log that. Normally this does
+			 * not happen and it is an indication of a faulty CEC
+			 * adapter driver, or the CEC bus is in some weird
+			 * state. On rare occasions it can happen if there is
+			 * so much traffic on the bus that the adapter was
+			 * unable to transmit for CEC_XFER_TIMEOUT_MS (2.1s).
 			 */
-			dprintk(0, "%s: message %*ph timed out!\n", __func__,
+			dprintk(1, "%s: message %*ph timed out\n", __func__,
 				adap->transmitting->msg.len,
 				adap->transmitting->msg.msg);
+			adap->tx_timeouts++;
 			/* Just give up on this. */
 			cec_data_cancel(adap->transmitting);
 			goto unlock;
@@ -1941,6 +1945,11 @@ int cec_adap_status(struct seq_file *file, void *priv)
 	if (adap->monitor_all_cnt)
 		seq_printf(file, "file handles in Monitor All mode: %u\n",
 			   adap->monitor_all_cnt);
+	if (adap->tx_timeouts) {
+		seq_printf(file, "transmit timeouts: %u\n",
+			   adap->tx_timeouts);
+		adap->tx_timeouts = 0;
+	}
 	data = adap->transmitting;
 	if (data)
 		seq_printf(file, "transmitting message: %*ph (reply: %02x, timeout: %ums)\n",
diff --git a/include/media/cec.h b/include/media/cec.h
index 56643b27e4b8..e32b0e1a81a4 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -174,6 +174,8 @@ struct cec_adapter {
 	bool passthrough;
 	struct cec_log_addrs log_addrs;
 
+	u32 tx_timeouts;
+
 #ifdef CONFIG_CEC_NOTIFIER
 	struct cec_notifier *notifier;
 #endif
-- 
2.11.0
