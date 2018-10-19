Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:40915 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726340AbeJSQAg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Oct 2018 12:00:36 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec: keep track of outstanding transmits
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <c8715653-6298-212d-a99c-a267b1ea09d5@xs4all.nl>
Date: Fri, 19 Oct 2018 09:55:34 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I noticed that repeatedly running 'cec-ctl --playback' would occasionally
select 'Playback Device 2' instead of 'Playback Device 1', even though there
were no other Playback devices in the HDMI topology. This happened both with
'real' hardware and with the vivid CEC emulation, suggesting that this was an
issue in the core code that claims a logical address.

What 'cec-ctl --playback' does is to first clear all existing logical addresses,
and immediately after that configure the new desired device type.

The core code will poll the logical addresses trying to find a free address.
When found it will issue a few standard messages as per the CEC spec and return.
Those messages are queued up and will be transmitted asynchronously.

What happens is that if you run two 'cec-ctl --playback' commands in quick
succession, there is still a message of the first cec-ctl command being transmitted
when you reconfigure the adapter again in the second cec-ctl command.

When the logical addresses are cleared, then all information about outstanding
transmits inside the CEC core is also cleared, and the core is no longer aware
that there is still a transmit in flight.

When the hardware finishes the transmit it calls transmit_done and the CEC core
thinks it is actually in response of a POLL messages that is trying to find a
free logical address. The result of all this is that the core thinks that the
logical address for Playback Device 1 is in use, when it is really an earlier
transmit that ended.

The main transmit thread looks at adap->transmitting to check if a transmit
is in progress, but that is set to NULL when the adapter is unconfigured.
adap->transmitting represents the view of userspace, not that of the hardware.
So when unconfiguring the adapter the message is marked aborted from the point
of view of userspace, but seen from the PoV of the hardware it is still ongoing.

So introduce a new bool transmit_in_progress that represents the hardware state
and use that instead of adap->transmitting. Now the CEC core waits until the
hardware finishes the transmit before starting a new transmit.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
This too should go to the stable 4.18 branch.
---
diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index 31d1f4ab915e..fadc1a54ae5a 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -455,7 +455,7 @@ int cec_thread_func(void *_adap)
 				(adap->needs_hpd &&
 				 (!adap->is_configured && !adap->is_configuring)) ||
 				kthread_should_stop() ||
-				(!adap->transmitting &&
+				(!adap->transmit_in_progress &&
 				 !list_empty(&adap->transmit_queue)),
 				msecs_to_jiffies(CEC_XFER_TIMEOUT_MS));
 			timeout = err == 0;
@@ -463,7 +463,7 @@ int cec_thread_func(void *_adap)
 			/* Otherwise we just wait for something to happen. */
 			wait_event_interruptible(adap->kthread_waitq,
 				kthread_should_stop() ||
-				(!adap->transmitting &&
+				(!adap->transmit_in_progress &&
 				 !list_empty(&adap->transmit_queue)));
 		}

@@ -488,6 +488,7 @@ int cec_thread_func(void *_adap)
 			pr_warn("cec-%s: message %*ph timed out\n", adap->name,
 				adap->transmitting->msg.len,
 				adap->transmitting->msg.msg);
+			adap->transmit_in_progress = false;
 			adap->tx_timeouts++;
 			/* Just give up on this. */
 			cec_data_cancel(adap->transmitting,
@@ -499,7 +500,7 @@ int cec_thread_func(void *_adap)
 		 * If we are still transmitting, or there is nothing new to
 		 * transmit, then just continue waiting.
 		 */
-		if (adap->transmitting || list_empty(&adap->transmit_queue))
+		if (adap->transmit_in_progress || list_empty(&adap->transmit_queue))
 			goto unlock;

 		/* Get a new message to transmit */
@@ -545,6 +546,8 @@ int cec_thread_func(void *_adap)
 		if (adap->ops->adap_transmit(adap, data->attempts,
 					     signal_free_time, &data->msg))
 			cec_data_cancel(data, CEC_TX_STATUS_ABORTED);
+		else
+			adap->transmit_in_progress = true;

 unlock:
 		mutex_unlock(&adap->lock);
@@ -575,14 +578,17 @@ void cec_transmit_done_ts(struct cec_adapter *adap, u8 status,
 	data = adap->transmitting;
 	if (!data) {
 		/*
-		 * This can happen if a transmit was issued and the cable is
+		 * This might happen if a transmit was issued and the cable is
 		 * unplugged while the transmit is ongoing. Ignore this
 		 * transmit in that case.
 		 */
-		dprintk(1, "%s was called without an ongoing transmit!\n",
-			__func__);
-		goto unlock;
+		if (!adap->transmit_in_progress)
+			dprintk(1, "%s was called without an ongoing transmit!\n",
+				__func__);
+		adap->transmit_in_progress = false;
+		goto wake_thread;
 	}
+	adap->transmit_in_progress = false;

 	msg = &data->msg;

@@ -648,7 +654,6 @@ void cec_transmit_done_ts(struct cec_adapter *adap, u8 status,
 	 * for transmitting or to retry the current message.
 	 */
 	wake_up_interruptible(&adap->kthread_waitq);
-unlock:
 	mutex_unlock(&adap->lock);
 }
 EXPORT_SYMBOL_GPL(cec_transmit_done_ts);
@@ -1469,8 +1474,11 @@ void __cec_s_phys_addr(struct cec_adapter *adap, u16 phys_addr, bool block)
 		if (adap->monitor_all_cnt)
 			WARN_ON(call_op(adap, adap_monitor_all_enable, false));
 		mutex_lock(&adap->devnode.lock);
-		if (adap->needs_hpd || list_empty(&adap->devnode.fhs))
+		if (adap->needs_hpd || list_empty(&adap->devnode.fhs)) {
 			WARN_ON(adap->ops->adap_enable(adap, false));
+			adap->transmit_in_progress = false;
+			wake_up_interruptible(&adap->kthread_waitq);
+		}
 		mutex_unlock(&adap->devnode.lock);
 		if (phys_addr == CEC_PHYS_ADDR_INVALID)
 			return;
@@ -1478,6 +1486,7 @@ void __cec_s_phys_addr(struct cec_adapter *adap, u16 phys_addr, bool block)

 	mutex_lock(&adap->devnode.lock);
 	adap->last_initiator = 0xff;
+	adap->transmit_in_progress = false;

 	if ((adap->needs_hpd || list_empty(&adap->devnode.fhs)) &&
 	    adap->ops->adap_enable(adap, true)) {
diff --git a/include/media/cec.h b/include/media/cec.h
index 3fe5e5d2bb7e..707411ef8ba2 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -155,6 +155,7 @@ struct cec_adapter {
 	unsigned int transmit_queue_sz;
 	struct list_head wait_queue;
 	struct cec_data *transmitting;
+	bool transmit_in_progress;

 	struct task_struct *kthread_config;
 	struct completion config_completion;
