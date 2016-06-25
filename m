Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:44413 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751216AbcFYMjs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jun 2016 08:39:48 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 47165180241
	for <linux-media@vger.kernel.org>; Sat, 25 Jun 2016 14:39:43 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] Diffs between the upcoming v19 series and the cec-topic
 branch
Message-ID: <bf8a35a2-6450-1874-c0c2-6adc7854832c@xs4all.nl>
Date: Sat, 25 Jun 2016 14:39:43 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This patch is the diff between the cec-topic branch and the upcoming v19 patch series,
but without the split up of cec.c since that's not a functional change (and that would
make this diff impossible to review).

Besides fixing your comments about cec.c and cec-edid.c, it also makes some documentation
improvements and a few additional fixes:

- new messages were queued at the beginning of the message queue instead of at the end.
  I hadn't noticed before because normally there is at most only one message queued up.
- adap->timeout wasn't zeroed in cec_transmit_done if the transmit failed or the adapter
  is no longer configured. This caused the result of such a transmit to be unnecessarily
  delayed by 'timeout' ms.
- adap->rc->driver_name wasn't set, which caused a (null) driver name when running ir-keymap.

I also double-checked with the USB CEC dongle that unplugging the usb device while /dev/cec0
was still open works correctly and that the cec_adapter struct is freed only when the last
open file handle is closed.

Regards,

	Hans

diff --git a/Documentation/DocBook/media/v4l/cec-ioc-dqevent.xml b/Documentation/DocBook/media/v4l/cec-ioc-dqevent.xml
index 87d4f29..697dde5 100644
--- a/Documentation/DocBook/media/v4l/cec-ioc-dqevent.xml
+++ b/Documentation/DocBook/media/v4l/cec-ioc-dqevent.xml
@@ -61,7 +61,7 @@
     <para>The internal event queues are per-filehandle and per-event type. If there is
     no more room in a queue then the last event is overwritten with the new one. This
     means that intermediate results can be thrown away but that the latest event is always
-    available. This also mean that is it possible to read two successive events that have
+    available. This also means that is it possible to read two successive events that have
     the same value (e.g. two CEC_EVENT_STATE_CHANGE events with the same state). In that
     case the intermediate state changes were lost but it is guaranteed that the state
     did change in between the two events.</para>
@@ -95,7 +95,14 @@
 	    <entry><structfield>lost_msgs</structfield></entry>
 	    <entry>Set to the number of lost messages since the filehandle
 	    was opened or since the last time this event was dequeued for
-	    this filehandle.</entry>
+	    this filehandle. The messages lost are the oldest messages. So
+	    when a new message arrives and there is no more room, then the
+	    oldest message is discarded to make room for the new one. The
+	    internal size of the message queue guarantees that all messages
+	    received in the last two seconds will be stored. Since messages
+	    should be replied to within a second according to the CEC
+	    specification, this is more than enough.
+	    </entry>
 	  </row>
 	</tbody>
       </tgroup>
diff --git a/Documentation/DocBook/media/v4l/cec-ioc-receive.xml b/Documentation/DocBook/media/v4l/cec-ioc-receive.xml
index 4da7239..fde9f86 100644
--- a/Documentation/DocBook/media/v4l/cec-ioc-receive.xml
+++ b/Documentation/DocBook/media/v4l/cec-ioc-receive.xml
@@ -96,9 +96,12 @@
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>timeout</structfield></entry>
-	    <entry>The timeout in milliseconds. This is the time we wait for a message to
-	    be received. If it is set to 0, then we wait indefinitely.
-	    It is ignored by <constant>CEC_TRANSMIT</constant>.</entry>
+	    <entry>The timeout in milliseconds. This is the time the device will wait for a message to
+	    be received before timing out. If it is set to 0, then it will wait indefinitely when it
+	    is called by <constant>CEC_RECEIVE</constant>. If it is 0 and it is called by
+	    <constant>CEC_TRANSMIT</constant>, then it will be replaced by 1000 if the
+	    <structfield>reply</structfield> is non-zero or ignored if <structfield>reply</structfield>
+	    is 0.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
@@ -143,10 +146,16 @@
 	    <entry>__u8</entry>
 	    <entry><structfield>reply</structfield></entry>
 	    <entry>Wait until this message is replied. If <structfield>reply</structfield>
-	    is 0, then don't wait for a reply but return after transmitting the
-	    message. If there was an error as indicated by a non-zero <structfield>status</structfield>
-	    field, then <structfield>reply</structfield> is set to 0 by the driver.
-	    Ignored by <constant>CEC_RECEIVE</constant>.</entry>
+	    is 0 and the <structfield>timeout</structfield> is 0, then don't wait for a reply but
+	    return after transmitting the message. If there was an error as indicated by a non-zero
+	    <structfield>tx_status</structfield> field, then <structfield>reply</structfield> and
+	    <structfield>timeout</structfield> are both set to 0 by the driver. Ignored by
+	    <constant>CEC_RECEIVE</constant>. The case where <structfield>reply</structfield> is 0
+	    (this is the opcode for the Feature Abort message) and <structfield>timeout</structfield>
+	    is non-zero is specifically allowed to send a message and wait up to <structfield>timeout</structfield>
+	    milliseconds for a Feature Abort reply. In this case <structfield>rx_status</structfield>
+	    will either be set to <constant>CEC_RX_STATUS_TIMEOUT</constant> or
+	    <constant>CEC_RX_STATUS_FEATURE_ABORT</constant>.</entry>
 	  </row>
 	  <row>
 	    <entry>__u8</entry>
diff --git a/drivers/media/cec-edid.c b/drivers/media/cec-edid.c
index ce3b915..7001824 100644
--- a/drivers/media/cec-edid.c
+++ b/drivers/media/cec-edid.c
@@ -22,30 +22,59 @@
 #include <linux/types.h>
 #include <media/cec-edid.h>

+/*
+ * This EDID is expected to be a CEA-861 compliant, which means that there are
+ * at least two blocks and one or more of the extensions blocks are CEA-861
+ * blocks.
+ *
+ * The returned location is guaranteed to be < size - 1.
+ */
 static unsigned int cec_get_edid_spa_location(const u8 *edid, unsigned int size)
 {
+	unsigned int blocks = size / 128;
+	unsigned int block;
 	u8 d;

-	if (size < 256)
-		return 0;
-
-	if (edid[0x7e] != 1 || edid[0x80] != 0x02 || edid[0x81] != 0x03)
+	/* Sanity check: at least 2 blocks and a multiple of the block size */
+	if (blocks < 2 || size % 128)
 		return 0;

-	/* search Vendor Specific Data Block (tag 3) */
-	d = edid[0x82] & 0x7f;
-	if (d > 4) {
-		int i = 0x84;
-		int end = 0x80 + d;
-
-		do {
-			u8 tag = edid[i] >> 5;
-			u8 len = edid[i] & 0x1f;
-
-			if (tag == 3 && len >= 5)
-				return i + 4;
-			i += len + 1;
-		} while (i < end);
+	/*
+	 * If there are fewer extension blocks than the size, then update
+	 * 'blocks'. It is allowed to have more extension blocks than the size,
+	 * since some hardware can only read e.g. 256 bytes of the EDID, even
+	 * though more blocks are present. The first CEA-861 extension block
+	 * should normally be in block 1 anyway.
+	 */
+	if (edid[0x7e] + 1 < blocks)
+		blocks = edid[0x7e] + 1;
+
+	for (block = 1; block < blocks; block++) {
+		unsigned int offset = block * 128;
+
+		/* Skip any non-CEA-861 extension blocks */
+		if (edid[offset] != 0x02 || edid[offset + 1] != 0x03)
+			continue;
+
+		/* search Vendor Specific Data Block (tag 3) */
+		d = edid[offset + 2] & 0x7f;
+		/* Check if there are Data Blocks */
+		if (d <= 4)
+			continue;
+		if (d > 4) {
+			unsigned int i = offset + 4;
+			unsigned int end = offset + d;
+
+			/* Note: 'end' is always < 'size' */
+			do {
+				u8 tag = edid[i] >> 5;
+				u8 len = edid[i] & 0x1f;
+
+				if (tag == 3 && len >= 5 && i + len <= end)
+					return i + 4;
+				i += len + 1;
+			} while (i < end);
+		}
 	}
 	return 0;
 }
diff --git a/drivers/staging/media/cec/Kconfig b/drivers/staging/media/cec/Kconfig
index 3297a54..8a7acee 100644
--- a/drivers/staging/media/cec/Kconfig
+++ b/drivers/staging/media/cec/Kconfig
@@ -6,3 +6,9 @@ config MEDIA_CEC

 	  To compile this driver as a module, choose M here: the
 	  module will be called cec.
+
+config MEDIA_CEC_DEBUG
+	bool "CEC debugfs interface (EXPERIMENTAL)"
+	depends on MEDIA_CEC && DEBUG_FS
+	---help---
+	  Turns on the DebugFS interface for CEC devices.
diff --git a/drivers/staging/media/cec/TODO b/drivers/staging/media/cec/TODO
index e3c384a..a8f4b7d 100644
--- a/drivers/staging/media/cec/TODO
+++ b/drivers/staging/media/cec/TODO
@@ -19,5 +19,9 @@ Other TODOs:
   is only sent to the filehandle that transmitted the original message
   and not to any followers. Should this behavior change or perhaps
   controlled through a cec_msg flag?
+- Should CEC_LOG_ADDR_TYPE_SPECIFIC be replaced by TYPE_2ND_TV and TYPE_PROCESSOR?
+  And also TYPE_SWITCH and TYPE_CDC_ONLY in addition to the TYPE_UNREGISTERED?
+  This should give the framework more information about the device type
+  since SPECIFIC and UNREGISTERED give no useful information.

 Hans Verkuil <hans.verkuil@cisco.com>
diff --git a/drivers/staging/media/cec/cec.c b/drivers/staging/media/cec/cec.c
index 8634773..4eb087e 100644
--- a/drivers/staging/media/cec/cec.c
+++ b/drivers/staging/media/cec/cec.c
@@ -104,64 +104,48 @@ static unsigned int cec_log_addr2dev(const struct cec_adapter *adap, u8 log_addr
 	return adap->log_addrs.primary_device_type[i < 0 ? 0 : i];
 }

-/* Initialize the event queues for the filehandle. */
-static int cec_queue_event_init(struct cec_fh *fh)
-{
-	/* This has the size of the event queue for each event type. */
-	static const unsigned int queue_sizes[CEC_NUM_EVENTS] = {
-		2,	/* CEC_EVENT_STATE_CHANGE */
-		1,	/* CEC_EVENT_LOST_MSGS */
-	};
-	unsigned int i;
-
-	for (i = 0; i < CEC_NUM_EVENTS; i++) {
-		fh->evqueue[i].events = kcalloc(queue_sizes[i],
-				sizeof(struct cec_event), GFP_KERNEL);
-		if (!fh->evqueue[i].events) {
-			while (i--) {
-				kfree(fh->evqueue[i].events);
-				fh->evqueue[i].events = NULL;
-				fh->evqueue[i].elems = 0;
-			}
-			return -ENOMEM;
-		}
-		fh->evqueue[i].elems = queue_sizes[i];
-	}
-	return 0;
-}
-
-static void cec_queue_event_free(struct cec_fh *fh)
-{
-	unsigned int i;
-
-	for (i = 0; i < CEC_NUM_EVENTS; i++)
-		kfree(fh->evqueue[i].events);
-}
-
 /*
  * Queue a new event for this filehandle. If ts == 0, then set it
  * to the current time.
+ *
+ * The two events that are currently defined do not need to keep track
+ * of intermediate events, so no actual queue of events is needed,
+ * instead just store the latest state and the total number of lost
+ * messages.
+ *
+ * Should new events be added in the future that require intermediate
+ * results to be queued as well, then a proper queue data structure is
+ * required. But until then, just keep it simple.
  */
 static void cec_queue_event_fh(struct cec_fh *fh,
 			       const struct cec_event *new_ev, u64 ts)
 {
-	struct cec_event_queue *evq = &fh->evqueue[new_ev->event - 1];
-	struct cec_event *ev;
+	struct cec_event *ev = &fh->events[new_ev->event - 1];

 	if (ts == 0)
 		ts = ktime_get_ns();

 	mutex_lock(&fh->lock);
-	ev = evq->events + evq->num_events;
-	/* Overwrite the last event if there is no more room for the new event */
-	if (evq->num_events == evq->elems) {
-		ev--;
-	} else {
-		evq->num_events++;
-		fh->events++;
+	if (new_ev->event == CEC_EVENT_LOST_MSGS &&
+	    fh->pending_events & (1 << new_ev->event)) {
+		/*
+		 * If there is already a lost_msgs event, then just
+		 * update the lost_msgs count. This effectively
+		 * merges the old and new events into one.
+		 */
+		ev->lost_msgs.lost_msgs += new_ev->lost_msgs.lost_msgs;
+		goto unlock;
 	}
+
+	/*
+	 * Intermediate states are not interesting, so just
+	 * overwrite any older event.
+	 */
 	*ev = *new_ev;
 	ev->ts = ts;
+	fh->pending_events |= 1 << new_ev->event;
+
+unlock:
 	mutex_unlock(&fh->lock);
 	wake_up_interruptible(&fh->wait);
 }
@@ -185,27 +169,35 @@ static void cec_queue_event(struct cec_adapter *adap,
  */
 static void cec_queue_msg_fh(struct cec_fh *fh, const struct cec_msg *msg)
 {
-	struct cec_event ev_lost_msg = {
+	static const struct cec_event ev_lost_msg = {
 		.event = CEC_EVENT_LOST_MSGS,
+		.lost_msgs.lost_msgs = 1,
 	};
 	struct cec_msg_entry *entry;

 	mutex_lock(&fh->lock);
-	if (fh->queued_msgs == CEC_MAX_MSG_QUEUE_SZ)
-		goto lost_msgs;
 	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
 	if (!entry)
 		goto lost_msgs;

 	entry->msg = *msg;
-	list_add(&entry->list, &fh->msgs);
+	/* Add new msg at the end of the queue */
+	list_add_tail(&entry->list, &fh->msgs);
+
+	/*
+	 * if the queue now has more than CEC_MAX_MSG_QUEUE_SZ
+	 * messages, drop the oldest one and send a lost message event.
+	 */
+	if (fh->queued_msgs == CEC_MAX_MSG_QUEUE_SZ) {
+		list_del(&entry->list);
+		goto lost_msgs;
+	}
 	fh->queued_msgs++;
 	mutex_unlock(&fh->lock);
 	wake_up_interruptible(&fh->wait);
 	return;

 lost_msgs:
-	ev_lost_msg.lost_msgs.lost_msgs = ++fh->lost_msgs;
 	mutex_unlock(&fh->lock);
 	cec_queue_event_fh(fh, &ev_lost_msg, 0);
 }
@@ -548,12 +540,13 @@ void cec_transmit_done(struct cec_adapter *adap, u8 status, u8 arb_lost_cnt,
 	cec_queue_msg_monitor(adap, msg, 1);

 	/*
-	 * Clear reply on error of if the adapter is no longer
-	 * configured. It makes no sense to wait for a reply in
-	 * this case.
+	 * Clear reply and timeout on error or if the adapter is no longer
+	 * configured. It makes no sense to wait for a reply in that case.
 	 */
-	if (!(status & CEC_TX_STATUS_OK) || !adap->is_configured)
+	if (!(status & CEC_TX_STATUS_OK) || !adap->is_configured) {
 		msg->reply = 0;
+		msg->timeout = 0;
+	}

 	if (msg->timeout) {
 		/*
@@ -908,7 +901,7 @@ static int cec_report_features(struct cec_adapter *adap, unsigned int la_idx)
 	msg.msg[3] = las->all_device_types[la_idx];

 	/* Write RC Profiles first, then Device Features */
-	for (idx = 0; idx < sizeof(las->features[0]); idx++) {
+	for (idx = 0; idx < ARRAY_SIZE(las->features[0]); idx++) {
 		msg.msg[msg.len++] = features[idx];
 		if ((features[idx] & CEC_OP_FEAT_EXT) == 0) {
 			if (op_is_dev_features)
@@ -1543,14 +1536,15 @@ static int __cec_s_log_addrs(struct cec_adapter *adap,
 		if (log_addrs->cec_version < CEC_OP_CEC_VERSION_2_0)
 			continue;

-		for (i = 0; i < sizeof(log_addrs->features[0]); i++) {
+		for (i = 0; i < ARRAY_SIZE(log_addrs->features[0]); i++) {
 			if ((features[i] & 0x80) == 0) {
 				if (op_is_dev_features)
 					break;
 				op_is_dev_features = true;
 			}
 		}
-		if (!op_is_dev_features || i == sizeof(log_addrs->features[0])) {
+		if (!op_is_dev_features ||
+		    i == ARRAY_SIZE(log_addrs->features[0])) {
 			dprintk(1, "malformed features\n");
 			return -EINVAL;
 		}
@@ -1596,6 +1590,7 @@ int cec_s_log_addrs(struct cec_adapter *adap,
 }
 EXPORT_SYMBOL_GPL(cec_s_log_addrs);

+#ifdef CONFIG_MEDIA_CEC_DEBUG
 /*
  * Log the current state of the CEC adapter.
  * Very useful for debugging.
@@ -1637,6 +1632,7 @@ static int cec_status(struct seq_file *file, void *priv)
 	mutex_unlock(&adap->lock);
 	return 0;
 }
+#endif

 /* CEC file operations */

@@ -1655,7 +1651,7 @@ static unsigned int cec_poll(struct file *filp,
 		res |= POLLOUT | POLLWRNORM;
 	if (fh->queued_msgs)
 		res |= POLLIN | POLLRDNORM;
-	if (fh->events)
+	if (fh->pending_events)
 		res |= POLLPRI;
 	poll_wait(filp, &fh->wait, poll);
 	mutex_unlock(&adap->lock);
@@ -1685,6 +1681,149 @@ static void cec_monitor_all_cnt_dec(struct cec_adapter *adap)
 		WARN_ON(call_op(adap, adap_monitor_all_enable, 0));
 }

+static bool cec_is_busy(const struct cec_adapter *adap,
+			const struct cec_fh *fh)
+{
+	bool valid_initiator = adap->cec_initiator && adap->cec_initiator == fh;
+	bool valid_follower = adap->cec_follower && adap->cec_follower == fh;
+
+	/*
+	 * Exclusive initiators and followers can always access the CEC adapter
+	 */
+	if (valid_initiator || valid_follower)
+		return false;
+	/*
+	 * All others can only access the CEC adapter if there is no
+	 * exclusive initiator and they are in INITIATOR mode.
+	 */
+	return adap->cec_initiator ||
+	       fh->mode_initiator == CEC_MODE_NO_INITIATOR;
+}
+
+static long cec_adap_g_caps(struct cec_adapter *adap,
+			    struct cec_caps __user *parg)
+{
+	struct cec_caps caps = {};
+
+	strlcpy(caps.driver, adap->devnode.parent->driver->name,
+		sizeof(caps.driver));
+	strlcpy(caps.name, adap->name, sizeof(caps.name));
+	caps.available_log_addrs = adap->available_log_addrs;
+	caps.capabilities = adap->capabilities;
+	caps.version = LINUX_VERSION_CODE;
+	if (copy_to_user(parg, &caps, sizeof(caps)))
+		return -EFAULT;
+	return 0;
+}
+
+static long cec_adap_g_phys_addr(struct cec_adapter *adap,
+				 __u16 __user *parg)
+{
+	u16 phys_addr;
+
+	mutex_lock(&adap->lock);
+	phys_addr = adap->phys_addr;
+	mutex_unlock(&adap->lock);
+	if (copy_to_user(parg, &phys_addr, sizeof(phys_addr)))
+		return -EFAULT;
+	return 0;
+}
+
+static long cec_adap_s_phys_addr(struct cec_adapter *adap, struct cec_fh *fh,
+				 bool block, __u16 __user *parg)
+{
+	u16 phys_addr;
+	long err;
+
+	if (!(adap->capabilities & CEC_CAP_PHYS_ADDR))
+		return -ENOTTY;
+	if (copy_from_user(&phys_addr, parg, sizeof(phys_addr)))
+		return -EFAULT;
+
+	err = cec_phys_addr_validate(phys_addr, NULL, NULL);
+	if (err)
+		return err;
+	mutex_lock(&adap->lock);
+	if (cec_is_busy(adap, fh))
+		err = -EBUSY;
+	else
+		__cec_s_phys_addr(adap, phys_addr, block);
+	mutex_unlock(&adap->lock);
+	return err;
+}
+
+static long cec_adap_g_log_addrs(struct cec_adapter *adap,
+				 struct cec_log_addrs __user *parg)
+{
+	struct cec_log_addrs log_addrs;
+
+	mutex_lock(&adap->lock);
+	log_addrs = adap->log_addrs;
+	if (!adap->is_configured)
+		memset(log_addrs.log_addr, CEC_LOG_ADDR_INVALID,
+		       sizeof(log_addrs.log_addr));
+	mutex_unlock(&adap->lock);
+
+	if (copy_to_user(parg, &log_addrs, sizeof(log_addrs)))
+		return -EFAULT;
+	return 0;
+}
+
+static long cec_adap_s_log_addrs(struct cec_adapter *adap, struct cec_fh *fh,
+				 bool block, struct cec_log_addrs __user *parg)
+{
+	struct cec_log_addrs log_addrs;
+	long err = -EBUSY;
+
+	if (!(adap->capabilities & CEC_CAP_LOG_ADDRS))
+		return -ENOTTY;
+	if (copy_from_user(&log_addrs, parg, sizeof(log_addrs)))
+		return -EFAULT;
+	log_addrs.flags = 0;
+	mutex_lock(&adap->lock);
+	if (!adap->is_configuring &&
+	    (!log_addrs.num_log_addrs || !adap->is_configured) &&
+	    !cec_is_busy(adap, fh)) {
+		err = __cec_s_log_addrs(adap, &log_addrs, block);
+		if (!err)
+			log_addrs = adap->log_addrs;
+	}
+	mutex_unlock(&adap->lock);
+	if (err)
+		return err;
+	if (copy_to_user(parg, &log_addrs, sizeof(log_addrs)))
+		return -EFAULT;
+	return 0;
+}
+
+static long cec_transmit(struct cec_adapter *adap, struct cec_fh *fh,
+			 bool block, struct cec_msg __user *parg)
+{
+	struct cec_msg msg = {};
+	long err = 0;
+
+	if (!(adap->capabilities & CEC_CAP_TRANSMIT))
+		return -ENOTTY;
+	if (copy_from_user(&msg, parg, sizeof(msg)))
+		return -EFAULT;
+	mutex_lock(&adap->lock);
+	if (!adap->is_configured) {
+		err = -ENONET;
+	} else if (cec_is_busy(adap, fh)) {
+		err = -EBUSY;
+	} else {
+		if (!block || !msg.reply)
+			fh = NULL;
+		err = cec_transmit_msg_fh(adap, &msg, fh, block);
+	}
+	mutex_unlock(&adap->lock);
+	if (err)
+		return err;
+	if (copy_to_user(parg, &msg, sizeof(msg)))
+		return -EFAULT;
+	return 0;
+}
+
 /* Called by CEC_RECEIVE: wait for a message to arrive */
 static int cec_receive_msg(struct cec_fh *fh, struct cec_msg *msg, bool block)
 {
@@ -1703,15 +1842,16 @@ static int cec_receive_msg(struct cec_fh *fh, struct cec_msg *msg, bool block)
 			*msg = entry->msg;
 			kfree(entry);
 			fh->queued_msgs--;
-			res = 0;
-		} else {
-			/* No, return EAGAIN in non-blocking mode or wait */
-			res = -EAGAIN;
+			mutex_unlock(&fh->lock);
+			return 0;
 		}
+
+		/* No, return EAGAIN in non-blocking mode or wait */
 		mutex_unlock(&fh->lock);
-		/* Return when in non-blocking mode or if we have a message */
-		if (!block || !res)
-			break;
+
+		/* Return when in non-blocking mode */
+		if (!block)
+			return -EAGAIN;

 		if (msg->timeout) {
 			/* The user specified a timeout */
@@ -1732,322 +1872,222 @@ static int cec_receive_msg(struct cec_fh *fh, struct cec_msg *msg, bool block)
 	return res;
 }

-static bool cec_is_busy(const struct cec_adapter *adap,
-			const struct cec_fh *fh)
+static long cec_receive(struct cec_adapter *adap, struct cec_fh *fh,
+			bool block, struct cec_msg __user *parg)
 {
-	bool valid_initiator = adap->cec_initiator && adap->cec_initiator == fh;
-	bool valid_follower = adap->cec_follower && adap->cec_follower == fh;
+	struct cec_msg msg = {};
+	long err = 0;

-	/*
-	 * Exclusive initiators and followers can always access the CEC adapter
-	 */
-	if (valid_initiator || valid_follower)
-		return false;
-	/*
-	 * All others can only access the CEC adapter if there is no
-	 * exclusive initiator and they are in INITIATOR mode.
-	 */
-	return adap->cec_initiator ||
-	       fh->mode_initiator == CEC_MODE_NO_INITIATOR;
+	if (copy_from_user(&msg, parg, sizeof(msg)))
+		return -EFAULT;
+	mutex_lock(&adap->lock);
+	if (!adap->is_configured)
+		err = -ENONET;
+	mutex_unlock(&adap->lock);
+	if (err)
+		return err;
+
+	err = cec_receive_msg(fh, &msg, block);
+	if (err)
+		return err;
+	if (copy_to_user(parg, &msg, sizeof(msg)))
+		return -EFAULT;
+	return 0;
 }

-static long cec_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+static long cec_dqevent(struct cec_adapter *adap, struct cec_fh *fh,
+			bool block, struct cec_event __user *parg)
 {
-	struct cec_devnode *devnode = cec_devnode_data(filp);
-	struct cec_fh *fh = filp->private_data;
-	struct cec_adapter *adap = fh->adap;
-	bool block = !(filp->f_flags & O_NONBLOCK);
-	void __user *parg = (void __user *)arg;
-	int err = 0;
-
-	if (!devnode->registered)
-		return -EIO;
+	struct cec_event *ev = NULL;
+	u64 ts = ~0ULL;
+	unsigned int i;
+	long err = 0;

-	switch (cmd) {
-	case CEC_ADAP_G_CAPS: {
-		struct cec_caps caps = {};
-
-		strlcpy(caps.driver, adap->devnode.parent->driver->name,
-			sizeof(caps.driver));
-		strlcpy(caps.name, adap->name, sizeof(caps.name));
-		caps.available_log_addrs = adap->available_log_addrs;
-		caps.capabilities = adap->capabilities;
-		caps.version = LINUX_VERSION_CODE;
-		if (copy_to_user(parg, &caps, sizeof(caps)))
-			return -EFAULT;
-		break;
+	mutex_lock(&fh->lock);
+	while (!fh->pending_events && block) {
+		mutex_unlock(&fh->lock);
+		err = wait_event_interruptible(fh->wait, fh->pending_events);
+		if (err)
+			return err;
+		mutex_lock(&fh->lock);
 	}

-	case CEC_TRANSMIT: {
-		struct cec_msg msg = {};
-
-		if (!(adap->capabilities & CEC_CAP_TRANSMIT))
-			return -ENOTTY;
-		if (copy_from_user(&msg, parg, sizeof(msg)))
-			return -EFAULT;
-		mutex_lock(&adap->lock);
-		if (!adap->is_configured) {
-			err = -ENONET;
-		} else if (cec_is_busy(adap, fh)) {
-			err = -EBUSY;
-		} else {
-			if (!block || !msg.reply)
-				fh = NULL;
-			err = cec_transmit_msg_fh(adap, &msg, fh, block);
+	/* Find the oldest event */
+	for (i = 0; i < CEC_NUM_EVENTS; i++) {
+		if (fh->pending_events & (1 << (i + 1)) &&
+		    fh->events[i].ts <= ts) {
+			ev = &fh->events[i];
+			ts = ev->ts;
 		}
-		mutex_unlock(&adap->lock);
-		if (err)
-			return err;
-		if (copy_to_user(parg, &msg, sizeof(msg)))
-			return -EFAULT;
-		break;
+	}
+	if (!ev) {
+		err = -EAGAIN;
+		goto unlock;
 	}

-	case CEC_RECEIVE: {
-		struct cec_msg msg = {};
+	if (copy_to_user(parg, ev, sizeof(*ev))) {
+		err = -EFAULT;
+		goto unlock;
+	}

-		if (copy_from_user(&msg, parg, sizeof(msg)))
-			return -EFAULT;
-		mutex_lock(&adap->lock);
-		if (!adap->is_configured)
-			err = -ENONET;
-		mutex_unlock(&adap->lock);
-		if (err)
-			return err;
+	fh->pending_events &= ~(1 << ev->event);

-		err = cec_receive_msg(fh, &msg, block);
-		if (err)
-			return err;
-		if (copy_to_user(parg, &msg, sizeof(msg)))
-			return -EFAULT;
-		break;
-	}
+unlock:
+	mutex_unlock(&fh->lock);
+	return err;
+}

-	case CEC_DQEVENT: {
-		struct cec_event_queue *evq = NULL;
-		struct cec_event *ev = NULL;
-		u64 ts = ~0ULL;
-		unsigned int i;
+static long cec_g_mode(struct cec_adapter *adap, struct cec_fh *fh,
+		       u32 __user *parg)
+{
+	u32 mode = fh->mode_initiator | fh->mode_follower;

-		mutex_lock(&fh->lock);
-		while (!fh->events && block) {
-			mutex_unlock(&fh->lock);
-			err = wait_event_interruptible(fh->wait, fh->events);
-			if (err)
-				return err;
-			mutex_lock(&fh->lock);
-		}
+	if (copy_to_user(parg, &mode, sizeof(mode)))
+		return -EFAULT;
+	return 0;
+}

-		/* Find the oldest event */
-		for (i = 0; i < CEC_NUM_EVENTS; i++) {
-			struct cec_event_queue *q = fh->evqueue + i;
+static long cec_s_mode(struct cec_adapter *adap, struct cec_fh *fh,
+		       u32 __user *parg)
+{
+	u32 mode;
+	u8 mode_initiator;
+	u8 mode_follower;
+	long err = 0;
+
+	if (copy_from_user(&mode, parg, sizeof(mode)))
+		return -EFAULT;
+	if (mode & ~(CEC_MODE_INITIATOR_MSK | CEC_MODE_FOLLOWER_MSK))
+		return -EINVAL;

-			if (q->num_events && q->events->ts <= ts) {
-				evq = q;
-				ev = q->events;
-				ts = ev->ts;
-			}
-		}
-		err = -EAGAIN;
-		if (ev) {
-			if (copy_to_user(parg, ev, sizeof(*ev))) {
-				err = -EFAULT;
-			} else {
-				unsigned int j;
-
-				evq->num_events--;
-				fh->events--;
-				/*
-				 * Reset lost message counter after returning
-				 * this event.
-				 */
-				if (ev->event == CEC_EVENT_LOST_MSGS)
-					fh->lost_msgs = 0;
-				for (j = 0; j < evq->num_events; j++)
-					evq->events[j] = evq->events[j + 1];
-				err = 0;
-			}
-		}
-		mutex_unlock(&fh->lock);
-		return err;
-	}
+	mode_initiator = mode & CEC_MODE_INITIATOR_MSK;
+	mode_follower = mode & CEC_MODE_FOLLOWER_MSK;

-	case CEC_ADAP_G_PHYS_ADDR: {
-		u16 phys_addr;
+	if (mode_initiator > CEC_MODE_EXCL_INITIATOR ||
+	    mode_follower > CEC_MODE_MONITOR_ALL)
+		return -EINVAL;

-		mutex_lock(&adap->lock);
-		phys_addr = adap->phys_addr;
-		if (copy_to_user(parg, &phys_addr, sizeof(adap->phys_addr)))
-			err = -EFAULT;
-		mutex_unlock(&adap->lock);
-		break;
-	}
+	if (mode_follower == CEC_MODE_MONITOR_ALL &&
+	    !(adap->capabilities & CEC_CAP_MONITOR_ALL))
+		return -EINVAL;

-	case CEC_ADAP_S_PHYS_ADDR: {
-		u16 phys_addr;
+	/* Follower modes should always be able to send CEC messages */
+	if ((mode_initiator == CEC_MODE_NO_INITIATOR ||
+	     !(adap->capabilities & CEC_CAP_TRANSMIT)) &&
+	    mode_follower >= CEC_MODE_FOLLOWER &&
+	    mode_follower <= CEC_MODE_EXCL_FOLLOWER_PASSTHRU)
+		return -EINVAL;

-		if (!(adap->capabilities & CEC_CAP_PHYS_ADDR))
-			return -ENOTTY;
-		if (copy_from_user(&phys_addr, parg, sizeof(phys_addr)))
-			return -EFAULT;
+	/* Monitor modes require CEC_MODE_NO_INITIATOR */
+	if (mode_initiator && mode_follower >= CEC_MODE_MONITOR)
+		return -EINVAL;

-		err = cec_phys_addr_validate(phys_addr, NULL, NULL);
-		if (err)
-			return err;
-		mutex_lock(&adap->lock);
-		if (cec_is_busy(adap, fh))
-			err = -EBUSY;
-		else
-			__cec_s_phys_addr(adap, phys_addr, block);
-		mutex_unlock(&adap->lock);
-		break;
-	}
+	/* Monitor modes require CAP_NET_ADMIN */
+	if (mode_follower >= CEC_MODE_MONITOR && !capable(CAP_NET_ADMIN))
+		return -EPERM;

-	case CEC_ADAP_G_LOG_ADDRS: {
-		struct cec_log_addrs log_addrs;
+	mutex_lock(&adap->lock);
+	/*
+	 * You can't become exclusive follower if someone else already
+	 * has that job.
+	 */
+	if ((mode_follower == CEC_MODE_EXCL_FOLLOWER ||
+	     mode_follower == CEC_MODE_EXCL_FOLLOWER_PASSTHRU) &&
+	    adap->cec_follower && adap->cec_follower != fh)
+		err = -EBUSY;
+	/*
+	 * You can't become exclusive initiator if someone else already
+	 * has that job.
+	 */
+	if (mode_initiator == CEC_MODE_EXCL_INITIATOR &&
+	    adap->cec_initiator && adap->cec_initiator != fh)
+		err = -EBUSY;

-		mutex_lock(&adap->lock);
-		log_addrs = adap->log_addrs;
-		if (!adap->is_configured)
-			memset(log_addrs.log_addr, CEC_LOG_ADDR_INVALID,
-			       sizeof(log_addrs.log_addr));
-		mutex_unlock(&adap->lock);
+	if (!err) {
+		bool old_mon_all = fh->mode_follower == CEC_MODE_MONITOR_ALL;
+		bool new_mon_all = mode_follower == CEC_MODE_MONITOR_ALL;

-		if (copy_to_user(parg, &log_addrs, sizeof(log_addrs)))
-			return -EFAULT;
-		break;
+		if (old_mon_all != new_mon_all) {
+			if (new_mon_all)
+				err = cec_monitor_all_cnt_inc(adap);
+			else
+				cec_monitor_all_cnt_dec(adap);
+		}
 	}

-	case CEC_ADAP_S_LOG_ADDRS: {
-		struct cec_log_addrs log_addrs;
-
-		if (!(adap->capabilities & CEC_CAP_LOG_ADDRS))
-			return -ENOTTY;
-		if (copy_from_user(&log_addrs, parg, sizeof(log_addrs)))
-			return -EFAULT;
-		log_addrs.flags = 0;
-		mutex_lock(&adap->lock);
-		if (adap->is_configuring)
-			err = -EBUSY;
-		else if (log_addrs.num_log_addrs && adap->is_configured)
-			err = -EBUSY;
-		else if (cec_is_busy(adap, fh))
-			err = -EBUSY;
-		else
-			err = __cec_s_log_addrs(adap, &log_addrs, block);
-		if (!err)
-			log_addrs = adap->log_addrs;
+	if (err) {
 		mutex_unlock(&adap->lock);
-		if (!err && copy_to_user(parg, &log_addrs, sizeof(log_addrs)))
-			return -EFAULT;
-		break;
+		return err;
 	}

-	case CEC_G_MODE: {
-		u32 mode = fh->mode_initiator | fh->mode_follower;
-
-		if (copy_to_user(parg, &mode, sizeof(mode)))
-			return -EFAULT;
-		break;
+	if (fh->mode_follower == CEC_MODE_FOLLOWER)
+		adap->follower_cnt--;
+	if (mode_follower == CEC_MODE_FOLLOWER)
+		adap->follower_cnt++;
+	if (mode_follower == CEC_MODE_EXCL_FOLLOWER ||
+	    mode_follower == CEC_MODE_EXCL_FOLLOWER_PASSTHRU) {
+		adap->passthrough =
+			mode_follower == CEC_MODE_EXCL_FOLLOWER_PASSTHRU;
+		adap->cec_follower = fh;
+	} else if (adap->cec_follower == fh) {
+		adap->passthrough = false;
+		adap->cec_follower = NULL;
 	}
+	if (mode_initiator == CEC_MODE_EXCL_INITIATOR)
+		adap->cec_initiator = fh;
+	else if (adap->cec_initiator == fh)
+		adap->cec_initiator = NULL;
+	fh->mode_initiator = mode_initiator;
+	fh->mode_follower = mode_follower;
+	mutex_unlock(&adap->lock);
+	return 0;
+}

-	case CEC_S_MODE: {
-		u32 mode;
-		u8 mode_initiator;
-		u8 mode_follower;
+static long cec_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	struct cec_devnode *devnode = cec_devnode_data(filp);
+	struct cec_fh *fh = filp->private_data;
+	struct cec_adapter *adap = fh->adap;
+	bool block = !(filp->f_flags & O_NONBLOCK);
+	void __user *parg = (void __user *)arg;

-		if (copy_from_user(&mode, parg, sizeof(mode)))
-			return -EFAULT;
-		if (mode & ~(CEC_MODE_INITIATOR_MSK | CEC_MODE_FOLLOWER_MSK))
-			return -EINVAL;
+	if (!devnode->registered)
+		return -EIO;

-		mode_initiator = mode & CEC_MODE_INITIATOR_MSK;
-		mode_follower = mode & CEC_MODE_FOLLOWER_MSK;
+	switch (cmd) {
+	case CEC_ADAP_G_CAPS:
+		return cec_adap_g_caps(adap, parg);

-		if (mode_initiator > CEC_MODE_EXCL_INITIATOR ||
-		    mode_follower > CEC_MODE_MONITOR_ALL)
-			return -EINVAL;
+	case CEC_ADAP_G_PHYS_ADDR:
+		return cec_adap_g_phys_addr(adap, parg);

-		if (mode_follower == CEC_MODE_MONITOR_ALL &&
-		    !(adap->capabilities & CEC_CAP_MONITOR_ALL))
-			return -EINVAL;
+	case CEC_ADAP_S_PHYS_ADDR:
+		return cec_adap_s_phys_addr(adap, fh, block, parg);

-		/* Follower modes should always be able to send CEC messages */
-		if ((mode_initiator == CEC_MODE_NO_INITIATOR ||
-		     !(adap->capabilities & CEC_CAP_TRANSMIT)) &&
-		    mode_follower >= CEC_MODE_FOLLOWER &&
-		    mode_follower <= CEC_MODE_EXCL_FOLLOWER_PASSTHRU)
-			return -EINVAL;
+	case CEC_ADAP_G_LOG_ADDRS:
+		return cec_adap_g_log_addrs(adap, parg);

-		/* Monitor modes require CEC_MODE_NO_INITIATOR */
-		if (mode_initiator && mode_follower >= CEC_MODE_MONITOR)
-			return -EINVAL;
+	case CEC_ADAP_S_LOG_ADDRS:
+		return cec_adap_s_log_addrs(adap, fh, block, parg);

-		/* Monitor modes require CAP_NET_ADMIN */
-		if (mode_follower >= CEC_MODE_MONITOR && !capable(CAP_NET_ADMIN))
-			return -EPERM;
+	case CEC_TRANSMIT:
+		return cec_transmit(adap, fh, block, parg);

-		mutex_lock(&adap->lock);
-		/*
-		 * You can't become exclusive follower if someone else already
-		 * has that job.
-		 */
-		if ((mode_follower == CEC_MODE_EXCL_FOLLOWER ||
-		     mode_follower == CEC_MODE_EXCL_FOLLOWER_PASSTHRU) &&
-		    adap->cec_follower && adap->cec_follower != fh)
-			err = -EBUSY;
-		/*
-		 * You can't become exclusive initiator if someone else already
-		 * has that job.
-		 */
-		if (mode_initiator == CEC_MODE_EXCL_INITIATOR &&
-		    adap->cec_initiator && adap->cec_initiator != fh)
-			err = -EBUSY;
-
-		if (!err) {
-			bool old_mon_all = fh->mode_follower == CEC_MODE_MONITOR_ALL;
-			bool new_mon_all = mode_follower == CEC_MODE_MONITOR_ALL;
-
-			if (old_mon_all != new_mon_all) {
-				if (new_mon_all)
-					err = cec_monitor_all_cnt_inc(adap);
-				else
-					cec_monitor_all_cnt_dec(adap);
-			}
-		}
+	case CEC_RECEIVE:
+		return cec_receive(adap, fh, block, parg);

-		if (err) {
-			mutex_unlock(&adap->lock);
-			break;
-		}
+	case CEC_DQEVENT:
+		return cec_dqevent(adap, fh, block, parg);

-		if (fh->mode_follower == CEC_MODE_FOLLOWER)
-			adap->follower_cnt--;
-		if (mode_follower == CEC_MODE_FOLLOWER)
-			adap->follower_cnt++;
-		if (mode_follower == CEC_MODE_EXCL_FOLLOWER ||
-		    mode_follower == CEC_MODE_EXCL_FOLLOWER_PASSTHRU) {
-			adap->passthrough =
-				mode_follower == CEC_MODE_EXCL_FOLLOWER_PASSTHRU;
-			adap->cec_follower = fh;
-		} else if (adap->cec_follower == fh) {
-			adap->passthrough = false;
-			adap->cec_follower = NULL;
-		}
-		if (mode_initiator == CEC_MODE_EXCL_INITIATOR)
-			adap->cec_initiator = fh;
-		else if (adap->cec_initiator == fh)
-			adap->cec_initiator = NULL;
-		fh->mode_initiator = mode_initiator;
-		fh->mode_follower = mode_follower;
-		mutex_unlock(&adap->lock);
-		break;
-	}
+	case CEC_G_MODE:
+		return cec_g_mode(adap, fh, parg);
+
+	case CEC_S_MODE:
+		return cec_s_mode(adap, fh, parg);

 	default:
 		return -ENOTTY;
 	}
-	return err;
 }

 static int cec_open(struct inode *inode, struct file *filp)
@@ -2064,18 +2104,10 @@ static int cec_open(struct inode *inode, struct file *filp)
 		.event = CEC_EVENT_STATE_CHANGE,
 		.flags = CEC_EVENT_FL_INITIAL_STATE,
 	};
-	int ret;

 	if (!fh)
 		return -ENOMEM;

-	ret = cec_queue_event_init(fh);
-
-	if (ret) {
-		kfree(fh);
-		return ret;
-	}
-
 	INIT_LIST_HEAD(&fh->msgs);
 	INIT_LIST_HEAD(&fh->xfer_list);
 	mutex_init(&fh->lock);
@@ -2098,7 +2130,6 @@ static int cec_open(struct inode *inode, struct file *filp)
 	 */
 	if (!devnode->registered) {
 		mutex_unlock(&cec_devnode_lock);
-		cec_queue_event_free(fh);
 		kfree(fh);
 		return -ENXIO;
 	}
@@ -2162,7 +2193,6 @@ static int cec_release(struct inode *inode, struct file *filp)
 		list_del(&entry->list);
 		kfree(entry);
 	}
-	cec_queue_event_free(fh);
 	kfree(fh);

 	/*
@@ -2201,9 +2231,8 @@ static struct bus_type cec_bus_type = {
 	.name = CEC_NAME,
 };

-/**
- * cec_devnode_register - register a cec device node
- * @devnode: cec device node structure we want to register
+/*
+ * Register a cec device node
  *
  * The registration code assigns minor numbers and registers the new device node
  * with the kernel. An error is returned if no free minor number can be found,
@@ -2267,13 +2296,11 @@ cdev_del:
 	cdev_del(&devnode->cdev);
 clr_bit:
 	clear_bit(devnode->minor, cec_devnode_nums);
-	put_device(&devnode->dev);
 	return ret;
 }

-/**
- * cec_devnode_unregister - unregister a cec device node
- * @devnode: the device node to unregister
+/*
+ * Unregister a cec device node
  *
  * This unregisters the passed device. Future open calls will be met with
  * errors.
@@ -2371,6 +2398,7 @@ struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
 	adap->rc->input_id.version = 1;
 	adap->rc->dev.parent = parent;
 	adap->rc->driver_type = RC_DRIVER_SCANCODE;
+	adap->rc->driver_name = CEC_NAME;
 	adap->rc->allowed_protocols = RC_BIT_CEC;
 	adap->rc->priv = adap;
 	adap->rc->map_name = RC_MAP_CEC;
@@ -2404,16 +2432,17 @@ int cec_register_adapter(struct cec_adapter *adap)
 #endif

 	res = cec_devnode_register(&adap->devnode, adap->owner);
-#if IS_ENABLED(CONFIG_RC_CORE)
 	if (res) {
+#if IS_ENABLED(CONFIG_RC_CORE)
 		/* Note: rc_unregister also calls rc_free */
 		rc_unregister_device(adap->rc);
 		adap->rc = NULL;
+#endif
 		return res;
 	}
-#endif

 	dev_set_drvdata(&adap->devnode.dev, adap);
+#ifdef CONFIG_MEDIA_CEC_DEBUG
 	if (!top_cec_dir)
 		return 0;

@@ -2429,6 +2458,7 @@ int cec_register_adapter(struct cec_adapter *adap)
 		debugfs_remove_recursive(adap->cec_dir);
 		adap->cec_dir = NULL;
 	}
+#endif
 	return 0;
 }
 EXPORT_SYMBOL_GPL(cec_register_adapter);
@@ -2481,11 +2511,13 @@ static int __init cec_devnode_init(void)
 		return ret;
 	}

+#ifdef CONFIG_MEDIA_CEC_DEBUG
 	top_cec_dir = debugfs_create_dir("cec", NULL);
 	if (IS_ERR_OR_NULL(top_cec_dir)) {
 		pr_warn("cec: Failed to create debugfs cec dir\n");
 		top_cec_dir = NULL;
 	}
+#endif

 	ret = bus_register(&cec_bus_type);
 	if (ret < 0) {
diff --git a/include/linux/cec-funcs.h b/include/linux/cec-funcs.h
index 155f6b9..8ee1029 100644
--- a/include/linux/cec-funcs.h
+++ b/include/linux/cec-funcs.h
@@ -17,6 +17,12 @@
  * SOFTWARE.
  */

+/*
+ * Note: this framework is still in staging and it is likely the API
+ * will change before it goes out of staging.
+ *
+ * Once it is moved out of staging this header will move to uapi.
+ */
 #ifndef _CEC_UAPI_FUNCS_H
 #define _CEC_UAPI_FUNCS_H

diff --git a/include/linux/cec.h b/include/linux/cec.h
index 0fd0e31..40924e7 100644
--- a/include/linux/cec.h
+++ b/include/linux/cec.h
@@ -17,6 +17,12 @@
  * SOFTWARE.
  */

+/*
+ * Note: this framework is still in staging and it is likely the API
+ * will change before it goes out of staging.
+ *
+ * Once it is moved out of staging this header will move to uapi.
+ */
 #ifndef _CEC_UAPI_H
 #define _CEC_UAPI_H

diff --git a/include/media/cec.h b/include/media/cec.h
index 25d89b1..9a791c0 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -85,12 +85,6 @@ struct cec_msg_entry {

 #define CEC_NUM_EVENTS		CEC_EVENT_LOST_MSGS

-struct cec_event_queue {
-	unsigned int		elems;
-	unsigned int		num_events;
-	struct cec_event	*events;
-};
-
 struct cec_fh {
 	struct list_head	list;
 	struct list_head	xfer_list;
@@ -100,12 +94,11 @@ struct cec_fh {

 	/* Events */
 	wait_queue_head_t	wait;
-	unsigned int		events;
-	struct cec_event_queue	evqueue[CEC_NUM_EVENTS];
+	unsigned int		pending_events;
+	struct cec_event	events[CEC_NUM_EVENTS];
 	struct mutex		lock;
 	struct list_head	msgs; /* queued messages */
 	unsigned int		queued_msgs;
-	unsigned int		lost_msgs;
 };

 #define CEC_SIGNAL_FREE_TIME_RETRY		3
@@ -133,9 +126,12 @@ struct cec_adap_ops {
  * With a transfer rate of at most 36 bytes per second this makes 18 messages
  * per second worst case.
  *
- * We queue at most 10 seconds worth of messages.
+ * We queue at most 3 seconds worth of messages. The CEC specification requires
+ * that messages are replied to within a second, so 3 seconds should give more
+ * than enough margin. Since most messages are actually more than 2 bytes, this
+ * is in practice a lot more than 3 seconds.
  */
-#define CEC_MAX_MSG_QUEUE_SZ		(18 * 10)
+#define CEC_MAX_MSG_QUEUE_SZ		(18 * 3)

 struct cec_adapter {
 	struct module *owner;
