Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:47359 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751454AbdB0OYy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Feb 2017 09:24:54 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/9] cec: allow specific messages even when unconfigured
Date: Mon, 27 Feb 2017 15:20:36 +0100
Message-Id: <20170227142042.37085-4-hverkuil@xs4all.nl>
In-Reply-To: <20170227142042.37085-1-hverkuil@xs4all.nl>
References: <20170227142042.37085-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The CEC specifications explicitly allows you to send poll messages and
Image/Text View On messages to a TV, even when unconfigured (i.e. there is
no hotplug signal detected). Some TVs will pull the HPD low when switching
to another input, or when going into standby, but CEC should still be
allowed to wake up such a display.

Add support for sending messages with initiator 0xf (Unregistered) and
destination 0 (TV) when no physical address is present.

This also required another change: the CEC adapter has to stay enabled as
long as 1) the CEC device is configured or 2) at least one filehandle is open
for the CEC device.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/cec/cec-adap.c | 27 ++++++++++++++++++++-------
 drivers/media/cec/cec-api.c  | 19 +++++++++++++++++--
 2 files changed, 37 insertions(+), 9 deletions(-)

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index 421472b492ee..78a85c44d96e 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -367,7 +367,6 @@ int cec_thread_func(void *_adap)
 			 */
 			err = wait_event_interruptible_timeout(adap->kthread_waitq,
 				kthread_should_stop() ||
-				(!adap->is_configured && !adap->is_configuring) ||
 				(!adap->transmitting &&
 				 !list_empty(&adap->transmit_queue)),
 				msecs_to_jiffies(CEC_XFER_TIMEOUT_MS));
@@ -382,8 +381,7 @@ int cec_thread_func(void *_adap)
 
 		mutex_lock(&adap->lock);
 
-		if ((!adap->is_configured && !adap->is_configuring) ||
-		    kthread_should_stop()) {
+		if (kthread_should_stop()) {
 			cec_flush(adap);
 			goto unlock;
 		}
@@ -414,6 +412,7 @@ int cec_thread_func(void *_adap)
 					struct cec_data, list);
 		list_del_init(&data->list);
 		adap->transmit_queue_sz--;
+
 		/* Make this the current transmitting message */
 		adap->transmitting = data;
 
@@ -647,7 +646,8 @@ int cec_transmit_msg_fh(struct cec_adapter *adap, struct cec_msg *msg,
 			cec_msg_initiator(msg));
 		return -EINVAL;
 	}
-	if (!adap->is_configured && !adap->is_configuring)
+	if (!adap->is_configured && !adap->is_configuring &&
+	    (msg->msg[0] != 0xf0 || msg->reply))
 		return -ENONET;
 
 	if (adap->transmit_queue_sz >= CEC_MAX_MSG_TX_QUEUE_SZ)
@@ -696,6 +696,7 @@ int cec_transmit_msg_fh(struct cec_adapter *adap, struct cec_msg *msg,
 
 	if (fh)
 		list_add_tail(&data->xfer_list, &fh->xfer_list);
+
 	list_add_tail(&data->list, &adap->transmit_queue);
 	adap->transmit_queue_sz++;
 	if (!adap->transmitting)
@@ -1121,6 +1122,7 @@ static void cec_adap_unconfigure(struct cec_adapter *adap)
 	adap->is_configuring = false;
 	adap->is_configured = false;
 	memset(adap->phys_addrs, 0xff, sizeof(adap->phys_addrs));
+	cec_flush(adap);
 	wake_up_interruptible(&adap->kthread_waitq);
 	cec_post_state_event(adap);
 }
@@ -1352,19 +1354,30 @@ void __cec_s_phys_addr(struct cec_adapter *adap, u16 phys_addr, bool block)
 		/* Disabling monitor all mode should always succeed */
 		if (adap->monitor_all_cnt)
 			WARN_ON(call_op(adap, adap_monitor_all_enable, false));
-		WARN_ON(adap->ops->adap_enable(adap, false));
+		mutex_lock(&adap->devnode.lock);
+		if (list_empty(&adap->devnode.fhs))
+			WARN_ON(adap->ops->adap_enable(adap, false));
+		mutex_unlock(&adap->devnode.lock);
 		if (phys_addr == CEC_PHYS_ADDR_INVALID)
 			return;
 	}
 
-	if (adap->ops->adap_enable(adap, true))
+	mutex_lock(&adap->devnode.lock);
+	if (list_empty(&adap->devnode.fhs) &&
+	    adap->ops->adap_enable(adap, true)) {
+		mutex_unlock(&adap->devnode.lock);
 		return;
+	}
 
 	if (adap->monitor_all_cnt &&
 	    call_op(adap, adap_monitor_all_enable, true)) {
-		WARN_ON(adap->ops->adap_enable(adap, false));
+		if (list_empty(&adap->devnode.fhs))
+			WARN_ON(adap->ops->adap_enable(adap, false));
+		mutex_unlock(&adap->devnode.lock);
 		return;
 	}
+	mutex_unlock(&adap->devnode.lock);
+
 	adap->phys_addr = phys_addr;
 	cec_post_state_event(adap);
 	if (adap->log_addrs.num_log_addrs)
diff --git a/drivers/media/cec/cec-api.c b/drivers/media/cec/cec-api.c
index 8950b6c9d6a9..627cdf7b12d1 100644
--- a/drivers/media/cec/cec-api.c
+++ b/drivers/media/cec/cec-api.c
@@ -198,7 +198,9 @@ static long cec_transmit(struct cec_adapter *adap, struct cec_fh *fh,
 		return -EINVAL;
 
 	mutex_lock(&adap->lock);
-	if (!adap->is_configured)
+	if (adap->is_configuring)
+		err = -ENONET;
+	else if (!adap->is_configured && (msg.msg[0] != 0xf0 || msg.reply))
 		err = -ENONET;
 	else if (cec_is_busy(adap, fh))
 		err = -EBUSY;
@@ -515,9 +517,18 @@ static int cec_open(struct inode *inode, struct file *filp)
 		return err;
 	}
 
+	mutex_lock(&devnode->lock);
+	if (list_empty(&devnode->fhs) &&
+	    adap->phys_addr == CEC_PHYS_ADDR_INVALID) {
+		err = adap->ops->adap_enable(adap, true);
+		if (err) {
+			mutex_unlock(&devnode->lock);
+			kfree(fh);
+			return err;
+		}
+	}
 	filp->private_data = fh;
 
-	mutex_lock(&devnode->lock);
 	/* Queue up initial state events */
 	ev_state.state_change.phys_addr = adap->phys_addr;
 	ev_state.state_change.log_addr_mask = adap->log_addrs.log_addr_mask;
@@ -551,6 +562,10 @@ static int cec_release(struct inode *inode, struct file *filp)
 
 	mutex_lock(&devnode->lock);
 	list_del(&fh->list);
+	if (list_empty(&devnode->fhs) &&
+	    adap->phys_addr == CEC_PHYS_ADDR_INVALID) {
+		WARN_ON(adap->ops->adap_enable(adap, false));
+	}
 	mutex_unlock(&devnode->lock);
 
 	/* Unhook pending transmits from this filehandle. */
-- 
2.11.0
