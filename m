Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:47772 "EHLO
        lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751409AbdB0OYy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Feb 2017 09:24:54 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/9] cec: improve flushing queue
Date: Mon, 27 Feb 2017 15:20:35 +0100
Message-Id: <20170227142042.37085-3-hverkuil@xs4all.nl>
In-Reply-To: <20170227142042.37085-1-hverkuil@xs4all.nl>
References: <20170227142042.37085-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

When the adapter is unloaded or unconfigured, then all transmits and
pending waits should be flushed.

Move this code into its own function and improve the code that cancels
delayed work to avoid having to unlock adap->lock.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/cec/cec-adap.c | 66 +++++++++++++++++++++++---------------------
 1 file changed, 35 insertions(+), 31 deletions(-)

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index ccda41c2c9e4..421472b492ee 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -300,6 +300,40 @@ static void cec_data_cancel(struct cec_data *data)
 }
 
 /*
+ * Flush all pending transmits and cancel any pending timeout work.
+ *
+ * This function is called with adap->lock held.
+ */
+static void cec_flush(struct cec_adapter *adap)
+{
+	struct cec_data *data, *n;
+
+	/*
+	 * If the adapter is disabled, or we're asked to stop,
+	 * then cancel any pending transmits.
+	 */
+	while (!list_empty(&adap->transmit_queue)) {
+		data = list_first_entry(&adap->transmit_queue,
+					struct cec_data, list);
+		cec_data_cancel(data);
+	}
+	if (adap->transmitting)
+		cec_data_cancel(adap->transmitting);
+
+	/* Cancel the pending timeout work. */
+	list_for_each_entry_safe(data, n, &adap->wait_queue, list) {
+		if (cancel_delayed_work(&data->work))
+			cec_data_cancel(data);
+		/*
+		 * If cancel_delayed_work returned false, then
+		 * the cec_wait_timeout function is running,
+		 * which will call cec_data_completed. So no
+		 * need to do anything special in that case.
+		 */
+	}
+}
+
+/*
  * Main CEC state machine
  *
  * Wait until the thread should be stopped, or we are not transmitting and
@@ -350,37 +384,7 @@ int cec_thread_func(void *_adap)
 
 		if ((!adap->is_configured && !adap->is_configuring) ||
 		    kthread_should_stop()) {
-			/*
-			 * If the adapter is disabled, or we're asked to stop,
-			 * then cancel any pending transmits.
-			 */
-			while (!list_empty(&adap->transmit_queue)) {
-				data = list_first_entry(&adap->transmit_queue,
-							struct cec_data, list);
-				cec_data_cancel(data);
-			}
-			if (adap->transmitting)
-				cec_data_cancel(adap->transmitting);
-
-			/*
-			 * Cancel the pending timeout work. We have to unlock
-			 * the mutex when flushing the work since
-			 * cec_wait_timeout() will take it. This is OK since
-			 * no new entries can be added to wait_queue as long
-			 * as adap->transmitting is NULL, which it is due to
-			 * the cec_data_cancel() above.
-			 */
-			while (!list_empty(&adap->wait_queue)) {
-				data = list_first_entry(&adap->wait_queue,
-							struct cec_data, list);
-
-				if (!cancel_delayed_work(&data->work)) {
-					mutex_unlock(&adap->lock);
-					flush_scheduled_work();
-					mutex_lock(&adap->lock);
-				}
-				cec_data_cancel(data);
-			}
+			cec_flush(adap);
 			goto unlock;
 		}
 
-- 
2.11.0
