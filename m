Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:39396 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751434AbcFRMYj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jun 2016 08:24:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Kamil Debski <kamil@wypas.org>
Subject: [PATCHv17 09/16] cec: add HDMI CEC framework
Date: Sat, 18 Jun 2016 14:24:11 +0200
Message-Id: <1466252658-39819-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1466252658-39819-1-git-send-email-hverkuil@xs4all.nl>
References: <1466252658-39819-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The added HDMI CEC framework provides a generic kernel interface for
HDMI CEC devices.

Note that the CEC framework is added to staging/media and that the
cec.h and cec-funcs.h headers are not exported yet. While the kABI
is mature, I would prefer to allow the uABI some more time before
it is mainlined in case it needs more tweaks.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
[k.debski@samsung.com: Merged CEC Updates commit by Hans Verkuil]
[k.debski@samsung.com: Merged Update author commit by Hans Verkuil]
[k.debski@samsung.com: change kthread handling when setting logical
address]
[k.debski@samsung.com: code cleanup and fixes]
[k.debski@samsung.com: add missing CEC commands to match spec]
[k.debski@samsung.com: add RC framework support]
[k.debski@samsung.com: move and edit documentation]
[k.debski@samsung.com: add vendor id reporting]
[k.debski@samsung.com: add possibility to clear assigned logical
addresses]
[k.debski@samsung.com: documentation fixes, clenaup and expansion]
[k.debski@samsung.com: reorder of API structs and add reserved fields]
[k.debski@samsung.com: fix handling of events and fix 32/64bit timespec
problem]
[k.debski@samsung.com: add sequence number handling]
[k.debski@samsung.com: add passthrough mode]
[k.debski@samsung.com: fix CEC defines, add missing CEC 2.0 commands]
minor additions]
Signed-off-by: Kamil Debski <kamil@wypas.org>
---
 MAINTAINERS                        |   16 +
 drivers/staging/media/cec/Kconfig  |    8 +
 drivers/staging/media/cec/Makefile |    1 +
 drivers/staging/media/cec/cec.c    | 2512 ++++++++++++++++++++++++++++++++++++
 include/media/cec.h                |  236 ++++
 5 files changed, 2773 insertions(+)
 create mode 100644 drivers/staging/media/cec/Kconfig
 create mode 100644 drivers/staging/media/cec/Makefile
 create mode 100644 drivers/staging/media/cec/cec.c
 create mode 100644 include/media/cec.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 02299fd..c424596 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2847,6 +2847,22 @@ F:	drivers/net/ieee802154/cc2520.c
 F:	include/linux/spi/cc2520.h
 F:	Documentation/devicetree/bindings/net/ieee802154/cc2520.txt
 
+CEC DRIVER
+M:	Hans Verkuil <hans.verkuil@cisco.com>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+W:	http://linuxtv.org
+S:	Supported
+F:	Documentation/cec.txt
+F:	Documentation/DocBook/media/v4l/cec*
+F:	drivers/staging/media/cec/cec.c
+F:	drivers/media/cec-edid.c
+F:	drivers/media/rc/keymaps/rc-cec.c
+F:	include/media/cec.h
+F:	include/media/cec-edid.h
+F:	include/linux/cec.h
+F:	include/linux/cec-funcs.h
+
 CELL BROADBAND ENGINE ARCHITECTURE
 M:	Arnd Bergmann <arnd@arndb.de>
 L:	linuxppc-dev@lists.ozlabs.org
diff --git a/drivers/staging/media/cec/Kconfig b/drivers/staging/media/cec/Kconfig
new file mode 100644
index 0000000..3297a54
--- /dev/null
+++ b/drivers/staging/media/cec/Kconfig
@@ -0,0 +1,8 @@
+config MEDIA_CEC
+	tristate "CEC API (EXPERIMENTAL)"
+	select MEDIA_CEC_EDID
+	---help---
+	  Enable the CEC API.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called cec.
diff --git a/drivers/staging/media/cec/Makefile b/drivers/staging/media/cec/Makefile
new file mode 100644
index 0000000..7a7532e
--- /dev/null
+++ b/drivers/staging/media/cec/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_MEDIA_CEC) += cec.o
diff --git a/drivers/staging/media/cec/cec.c b/drivers/staging/media/cec/cec.c
new file mode 100644
index 0000000..8634773
--- /dev/null
+++ b/drivers/staging/media/cec/cec.c
@@ -0,0 +1,2512 @@
+/*
+ * cec - HDMI Consumer Electronics Control framework
+ *
+ * Copyright 2016 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/kmod.h>
+#include <linux/ktime.h>
+#include <linux/slab.h>
+#include <linux/mm.h>
+#include <linux/string.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
+#include <linux/version.h>
+#include <media/cec-edid.h>
+#include <media/cec.h>
+
+#define CEC_NUM_DEVICES	256
+#define CEC_NAME	"cec"
+
+static int debug;
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "debug level (0-2)");
+
+/*
+ * 400 ms is the time it takes for one 16 byte message to be
+ * transferred and 5 is the maximum number of retries. Add
+ * another 100 ms as a margin. So if the transmit doesn't
+ * finish before that time something is really wrong and we
+ * have to time out.
+ *
+ * This is a sign that something it really wrong and a warning
+ * will be issued.
+ */
+#define CEC_XFER_TIMEOUT_MS (5 * 400 + 100)
+
+#define dprintk(lvl, fmt, arg...)					\
+	do {								\
+		if (lvl <= debug)					\
+			pr_info("cec-%s: " fmt, adap->name, ## arg);	\
+	} while (0)
+
+#define call_op(adap, op, arg...) \
+	(adap->ops->op ? adap->ops->op(adap, ## arg) : 0)
+
+#define call_void_op(adap, op, arg...)			\
+	do {						\
+		if (adap->ops->op)			\
+			adap->ops->op(adap, ## arg);	\
+	} while (0)
+
+static dev_t cec_dev_t;
+
+/* Active devices */
+static DEFINE_MUTEX(cec_devnode_lock);
+static DECLARE_BITMAP(cec_devnode_nums, CEC_NUM_DEVICES);
+
+static struct dentry *top_cec_dir;
+
+/* dev to cec_devnode */
+#define to_cec_devnode(cd) container_of(cd, struct cec_devnode, dev)
+
+/* devnode to cec_adapter */
+#define to_cec_adapter(node) container_of(node, struct cec_adapter, devnode)
+
+static inline struct cec_devnode *cec_devnode_data(struct file *filp)
+{
+	struct cec_fh *fh = filp->private_data;
+
+	return &fh->adap->devnode;
+}
+
+static int cec_log_addr2idx(const struct cec_adapter *adap, u8 log_addr)
+{
+	int i;
+
+	for (i = 0; i < adap->log_addrs.num_log_addrs; i++)
+		if (adap->log_addrs.log_addr[i] == log_addr)
+			return i;
+	return -1;
+}
+
+static unsigned int cec_log_addr2dev(const struct cec_adapter *adap, u8 log_addr)
+{
+	int i = cec_log_addr2idx(adap, log_addr);
+
+	return adap->log_addrs.primary_device_type[i < 0 ? 0 : i];
+}
+
+/* Initialize the event queues for the filehandle. */
+static int cec_queue_event_init(struct cec_fh *fh)
+{
+	/* This has the size of the event queue for each event type. */
+	static const unsigned int queue_sizes[CEC_NUM_EVENTS] = {
+		2,	/* CEC_EVENT_STATE_CHANGE */
+		1,	/* CEC_EVENT_LOST_MSGS */
+	};
+	unsigned int i;
+
+	for (i = 0; i < CEC_NUM_EVENTS; i++) {
+		fh->evqueue[i].events = kcalloc(queue_sizes[i],
+				sizeof(struct cec_event), GFP_KERNEL);
+		if (!fh->evqueue[i].events) {
+			while (i--) {
+				kfree(fh->evqueue[i].events);
+				fh->evqueue[i].events = NULL;
+				fh->evqueue[i].elems = 0;
+			}
+			return -ENOMEM;
+		}
+		fh->evqueue[i].elems = queue_sizes[i];
+	}
+	return 0;
+}
+
+static void cec_queue_event_free(struct cec_fh *fh)
+{
+	unsigned int i;
+
+	for (i = 0; i < CEC_NUM_EVENTS; i++)
+		kfree(fh->evqueue[i].events);
+}
+
+/*
+ * Queue a new event for this filehandle. If ts == 0, then set it
+ * to the current time.
+ */
+static void cec_queue_event_fh(struct cec_fh *fh,
+			       const struct cec_event *new_ev, u64 ts)
+{
+	struct cec_event_queue *evq = &fh->evqueue[new_ev->event - 1];
+	struct cec_event *ev;
+
+	if (ts == 0)
+		ts = ktime_get_ns();
+
+	mutex_lock(&fh->lock);
+	ev = evq->events + evq->num_events;
+	/* Overwrite the last event if there is no more room for the new event */
+	if (evq->num_events == evq->elems) {
+		ev--;
+	} else {
+		evq->num_events++;
+		fh->events++;
+	}
+	*ev = *new_ev;
+	ev->ts = ts;
+	mutex_unlock(&fh->lock);
+	wake_up_interruptible(&fh->wait);
+}
+
+/* Queue a new event for all open filehandles. */
+static void cec_queue_event(struct cec_adapter *adap,
+			    const struct cec_event *ev)
+{
+	u64 ts = ktime_get_ns();
+	struct cec_fh *fh;
+
+	mutex_lock(&adap->devnode.fhs_lock);
+	list_for_each_entry(fh, &adap->devnode.fhs, list)
+		cec_queue_event_fh(fh, ev, ts);
+	mutex_unlock(&adap->devnode.fhs_lock);
+}
+
+/*
+ * Queue a new message for this filehandle. If there is no more room
+ * in the queue, then send the LOST_MSGS event instead.
+ */
+static void cec_queue_msg_fh(struct cec_fh *fh, const struct cec_msg *msg)
+{
+	struct cec_event ev_lost_msg = {
+		.event = CEC_EVENT_LOST_MSGS,
+	};
+	struct cec_msg_entry *entry;
+
+	mutex_lock(&fh->lock);
+	if (fh->queued_msgs == CEC_MAX_MSG_QUEUE_SZ)
+		goto lost_msgs;
+	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		goto lost_msgs;
+
+	entry->msg = *msg;
+	list_add(&entry->list, &fh->msgs);
+	fh->queued_msgs++;
+	mutex_unlock(&fh->lock);
+	wake_up_interruptible(&fh->wait);
+	return;
+
+lost_msgs:
+	ev_lost_msg.lost_msgs.lost_msgs = ++fh->lost_msgs;
+	mutex_unlock(&fh->lock);
+	cec_queue_event_fh(fh, &ev_lost_msg, 0);
+}
+
+/*
+ * Queue the message for those filehandles that are in monitor mode.
+ * If valid_la is true (this message is for us or was sent by us),
+ * then pass it on to any monitoring filehandle. If this message
+ * isn't for us or from us, then only give it to filehandles that
+ * are in MONITOR_ALL mode.
+ *
+ * This can only happen if the CEC_CAP_MONITOR_ALL capability is
+ * set and the CEC adapter was placed in 'monitor all' mode.
+ */
+static void cec_queue_msg_monitor(struct cec_adapter *adap,
+				  const struct cec_msg *msg,
+				  bool valid_la)
+{
+	struct cec_fh *fh;
+	u32 monitor_mode = valid_la ? CEC_MODE_MONITOR :
+				      CEC_MODE_MONITOR_ALL;
+
+	mutex_lock(&adap->devnode.fhs_lock);
+	list_for_each_entry(fh, &adap->devnode.fhs, list) {
+		if (fh->mode_follower >= monitor_mode)
+			cec_queue_msg_fh(fh, msg);
+	}
+	mutex_unlock(&adap->devnode.fhs_lock);
+}
+
+/*
+ * Queue the message for follower filehandles.
+ */
+static void cec_queue_msg_followers(struct cec_adapter *adap,
+				    const struct cec_msg *msg)
+{
+	struct cec_fh *fh;
+
+	mutex_lock(&adap->devnode.fhs_lock);
+	list_for_each_entry(fh, &adap->devnode.fhs, list) {
+		if (fh->mode_follower == CEC_MODE_FOLLOWER)
+			cec_queue_msg_fh(fh, msg);
+	}
+	mutex_unlock(&adap->devnode.fhs_lock);
+}
+
+/* Notify userspace of an adapter state change. */
+static void cec_post_state_event(struct cec_adapter *adap)
+{
+	struct cec_event ev = {
+		.event = CEC_EVENT_STATE_CHANGE,
+	};
+
+	ev.state_change.phys_addr = adap->phys_addr;
+	ev.state_change.log_addr_mask = adap->log_addrs.log_addr_mask;
+	cec_queue_event(adap, &ev);
+}
+
+/*
+ * A CEC transmit (and a possible wait for reply) completed.
+ * If this was in blocking mode, then complete it, otherwise
+ * queue the message for userspace to dequeue later.
+ *
+ * This function is called with adap->lock held.
+ */
+static void cec_data_completed(struct cec_data *data)
+{
+	/*
+	 * Delete this transmit from the filehandle's xfer_list since
+	 * we're done with it.
+	 *
+	 * Note that if the filehandle is closed before this transmit
+	 * finished, then the release() function will set data->fh to NULL.
+	 * Without that we would be referring to a closed filehandle.
+	 */
+	if (data->fh)
+		list_del(&data->xfer_list);
+
+	if (data->blocking) {
+		/*
+		 * Someone is blocking so mark the message as completed
+		 * and call complete.
+		 */
+		data->completed = true;
+		complete(&data->c);
+	} else {
+		/*
+		 * No blocking, so just queue the message if needed and
+		 * free the memory.
+		 */
+		if (data->fh)
+			cec_queue_msg_fh(data->fh, &data->msg);
+		kfree(data);
+	}
+}
+
+/*
+ * A pending CEC transmit needs to be cancelled, either because the CEC
+ * adapter is disabled or the transmit takes an impossibly long time to
+ * finish.
+ *
+ * This function is called with adap->lock held.
+ */
+static void cec_data_cancel(struct cec_data *data)
+{
+	/*
+	 * It's either the current transmit, or it is a pending
+	 * transmit. Take the appropriate action to clear it.
+	 */
+	if (data->adap->transmitting == data)
+		data->adap->transmitting = NULL;
+	else
+		list_del_init(&data->list);
+
+	/* Mark it as an error */
+	data->msg.ts = ktime_get_ns();
+	data->msg.tx_status = CEC_TX_STATUS_ERROR |
+			      CEC_TX_STATUS_MAX_RETRIES;
+	data->attempts = 0;
+	data->msg.tx_error_cnt = 1;
+	data->msg.reply = 0;
+	/* Queue transmitted message for monitoring purposes */
+	cec_queue_msg_monitor(data->adap, &data->msg, 1);
+
+	cec_data_completed(data);
+}
+
+/*
+ * Main CEC state machine
+ *
+ * Wait until the thread should be stopped, or we are not transmitting and
+ * a new transmit message is queued up, in which case we start transmitting
+ * that message. When the adapter finished transmitting the message it will
+ * call cec_transmit_done().
+ *
+ * If the adapter is disabled, then remove all queued messages instead.
+ *
+ * If the current transmit times out, then cancel that transmit.
+ */
+static int cec_thread_func(void *_adap)
+{
+	struct cec_adapter *adap = _adap;
+
+	for (;;) {
+		unsigned int signal_free_time;
+		struct cec_data *data;
+		bool timeout = false;
+		u8 attempts;
+
+		if (adap->transmitting) {
+			int err;
+
+			/*
+			 * We are transmitting a message, so add a timeout
+			 * to prevent the state machine to get stuck waiting
+			 * for this message to finalize and add a check to
+			 * see if the adapter is disabled in which case the
+			 * transmit should be canceled.
+			 */
+			err = wait_event_interruptible_timeout(adap->kthread_waitq,
+				kthread_should_stop() ||
+				adap->phys_addr == CEC_PHYS_ADDR_INVALID ||
+				(!adap->transmitting &&
+				 !list_empty(&adap->transmit_queue)),
+				msecs_to_jiffies(CEC_XFER_TIMEOUT_MS));
+			timeout = err == 0;
+		} else {
+			/* Otherwise we just wait for something to happen. */
+			wait_event_interruptible(adap->kthread_waitq,
+				kthread_should_stop() ||
+				(!adap->transmitting &&
+				 !list_empty(&adap->transmit_queue)));
+		}
+
+		mutex_lock(&adap->lock);
+
+		if (adap->phys_addr == CEC_PHYS_ADDR_INVALID ||
+		    kthread_should_stop()) {
+			/*
+			 * If the adapter is disabled, or we're asked to stop,
+			 * then cancel any pending transmits.
+			 */
+			while (!list_empty(&adap->transmit_queue)) {
+				data = list_first_entry(&adap->transmit_queue,
+							struct cec_data, list);
+				cec_data_cancel(data);
+			}
+			if (adap->transmitting)
+				cec_data_cancel(adap->transmitting);
+
+			/*
+			 * Cancel the pending timeout work. We have to unlock
+			 * the mutex when flushing the work since
+			 * cec_wait_timeout() will take it. This is OK since
+			 * no new entries can be added to wait_queue as long
+			 * as adap->transmitting is NULL, which it is due to
+			 * the cec_data_cancel() above.
+			 */
+			while (!list_empty(&adap->wait_queue)) {
+				data = list_first_entry(&adap->wait_queue,
+							struct cec_data, list);
+
+				if (!cancel_delayed_work(&data->work)) {
+					mutex_unlock(&adap->lock);
+					flush_scheduled_work();
+					mutex_lock(&adap->lock);
+				}
+				cec_data_cancel(data);
+			}
+			goto unlock;
+		}
+
+		if (adap->transmitting && timeout) {
+			/*
+			 * If we timeout, then log that. This really shouldn't
+			 * happen and is an indication of a faulty CEC adapter
+			 * driver, or the CEC bus is in some weird state.
+			 */
+			dprintk(0, "message %*ph timed out!\n",
+				adap->transmitting->msg.len,
+				adap->transmitting->msg.msg);
+			/* Just give up on this. */
+			cec_data_cancel(adap->transmitting);
+			goto unlock;
+		}
+
+		/*
+		 * If we are still transmitting, or there is nothing new to
+		 * transmit, then just continue waiting.
+		 */
+		if (adap->transmitting || list_empty(&adap->transmit_queue))
+			goto unlock;
+
+		/* Get a new message to transmit */
+		data = list_first_entry(&adap->transmit_queue,
+					struct cec_data, list);
+		list_del_init(&data->list);
+		/* Make this the current transmitting message */
+		adap->transmitting = data;
+
+		/*
+		 * Suggested number of attempts as per the CEC 2.0 spec:
+		 * 4 attempts is the default, except for 'secondary poll
+		 * messages', i.e. poll messages not sent during the adapter
+		 * configuration phase when it allocates logical addresses.
+		 */
+		if (data->msg.len == 1 && adap->is_configured)
+			attempts = 2;
+		else
+			attempts = 4;
+
+		/* Set the suggested signal free time */
+		if (data->attempts) {
+			/* should be >= 3 data bit periods for a retry */
+			signal_free_time = CEC_SIGNAL_FREE_TIME_RETRY;
+		} else if (data->new_initiator) {
+			/* should be >= 5 data bit periods for new initiator */
+			signal_free_time = CEC_SIGNAL_FREE_TIME_NEW_INITIATOR;
+		} else {
+			/*
+			 * should be >= 7 data bit periods for sending another
+			 * frame immediately after another.
+			 */
+			signal_free_time = CEC_SIGNAL_FREE_TIME_NEXT_XFER;
+		}
+		if (data->attempts == 0)
+			data->attempts = attempts;
+
+		/* Tell the adapter to transmit, cancel on error */
+		if (adap->ops->adap_transmit(adap, data->attempts,
+					     signal_free_time, &data->msg))
+			cec_data_cancel(data);
+
+unlock:
+		mutex_unlock(&adap->lock);
+
+		if (kthread_should_stop())
+			break;
+	}
+	return 0;
+}
+
+/*
+ * Called by the CEC adapter if a transmit finished.
+ */
+void cec_transmit_done(struct cec_adapter *adap, u8 status, u8 arb_lost_cnt,
+		       u8 nack_cnt, u8 low_drive_cnt, u8 error_cnt)
+{
+	struct cec_data *data;
+	struct cec_msg *msg;
+
+	dprintk(2, "cec_transmit_done %02x\n", status);
+	mutex_lock(&adap->lock);
+	data = adap->transmitting;
+	if (!data) {
+		/*
+		 * This can happen if a transmit was issued and the cable is
+		 * unplugged while the transmit is ongoing. Ignore this
+		 * transmit in that case.
+		 */
+		dprintk(1, "cec_transmit_done without an ongoing transmit!\n");
+		goto unlock;
+	}
+
+	msg = &data->msg;
+
+	/* Drivers must fill in the status! */
+	WARN_ON(status == 0);
+	msg->ts = ktime_get_ns();
+	msg->tx_status |= status;
+	msg->tx_arb_lost_cnt += arb_lost_cnt;
+	msg->tx_nack_cnt += nack_cnt;
+	msg->tx_low_drive_cnt += low_drive_cnt;
+	msg->tx_error_cnt += error_cnt;
+
+	/* Mark that we're done with this transmit */
+	adap->transmitting = NULL;
+
+	/*
+	 * If there are still retry attempts left and there was an error and
+	 * the hardware didn't signal that it retried itself (by setting
+	 * CEC_TX_STATUS_MAX_RETRIES), then we will retry ourselves.
+	 */
+	if (data->attempts > 1 &&
+	    !(status & (CEC_TX_STATUS_MAX_RETRIES | CEC_TX_STATUS_OK))) {
+		/* Retry this message */
+		data->attempts--;
+		/* Add the message in front of the transmit queue */
+		list_add(&data->list, &adap->transmit_queue);
+		goto wake_thread;
+	}
+
+	data->attempts = 0;
+
+	/* Always set CEC_TX_STATUS_MAX_RETRIES on error */
+	if (!(status & CEC_TX_STATUS_OK))
+		msg->tx_status |= CEC_TX_STATUS_MAX_RETRIES;
+
+	/* Queue transmitted message for monitoring purposes */
+	cec_queue_msg_monitor(adap, msg, 1);
+
+	/*
+	 * Clear reply on error of if the adapter is no longer
+	 * configured. It makes no sense to wait for a reply in
+	 * this case.
+	 */
+	if (!(status & CEC_TX_STATUS_OK) || !adap->is_configured)
+		msg->reply = 0;
+
+	if (msg->timeout) {
+		/*
+		 * Queue the message into the wait queue if we want to wait
+		 * for a reply.
+		 */
+		list_add_tail(&data->list, &adap->wait_queue);
+		schedule_delayed_work(&data->work,
+				      msecs_to_jiffies(msg->timeout));
+	} else {
+		/* Otherwise we're done */
+		cec_data_completed(data);
+	}
+
+wake_thread:
+	/*
+	 * Wake up the main thread to see if another message is ready
+	 * for transmitting or to retry the current message.
+	 */
+	wake_up_interruptible(&adap->kthread_waitq);
+unlock:
+	mutex_unlock(&adap->lock);
+}
+EXPORT_SYMBOL_GPL(cec_transmit_done);
+
+/*
+ * Called when waiting for a reply times out.
+ */
+static void cec_wait_timeout(struct work_struct *work)
+{
+	struct cec_data *data = container_of(work, struct cec_data, work.work);
+	struct cec_adapter *adap = data->adap;
+
+	mutex_lock(&adap->lock);
+	/*
+	 * Sanity check in case the timeout and the arrival of the message
+	 * happened at the same time.
+	 */
+	if (list_empty(&data->list))
+		goto unlock;
+
+	/* Mark the message as timed out */
+	list_del_init(&data->list);
+	data->msg.ts = ktime_get_ns();
+	data->msg.rx_status = CEC_RX_STATUS_TIMEOUT;
+	cec_data_completed(data);
+unlock:
+	mutex_unlock(&adap->lock);
+}
+
+/*
+ * Transmit a message. The fh argument may be NULL if the transmit is not
+ * associated with a specific filehandle.
+ *
+ * This function is called with adap->lock held.
+ */
+static int cec_transmit_msg_fh(struct cec_adapter *adap, struct cec_msg *msg,
+			       struct cec_fh *fh, bool block)
+{
+	struct cec_data *data;
+	u8 last_initiator = 0xff;
+	unsigned int timeout;
+	int res = 0;
+
+	if (msg->reply && msg->timeout == 0) {
+		/* Make sure the timeout isn't 0. */
+		msg->timeout = 1000;
+	}
+
+	/* Sanity checks */
+	if (msg->len == 0 || msg->len > CEC_MAX_MSG_SIZE) {
+		dprintk(1, "cec_transmit_msg: invalid length %d\n", msg->len);
+		return -EINVAL;
+	}
+	if (msg->timeout && msg->len == 1) {
+		dprintk(1, "cec_transmit_msg: can't reply for poll msg\n");
+		return -EINVAL;
+	}
+	if (msg->len == 1) {
+		if (cec_msg_initiator(msg) != 0xf ||
+		    cec_msg_destination(msg) == 0xf) {
+			dprintk(1, "cec_transmit_msg: invalid poll message\n");
+			return -EINVAL;
+		}
+		if (cec_has_log_addr(adap, cec_msg_destination(msg))) {
+			/*
+			 * If the destination is a logical address our adapter
+			 * has already claimed, then just NACK this.
+			 * It depends on the hardware what it will do with a
+			 * POLL to itself (some OK this), so it is just as
+			 * easy to handle it here so the behavior will be
+			 * consistent.
+			 */
+			msg->tx_status = CEC_TX_STATUS_NACK |
+					 CEC_TX_STATUS_MAX_RETRIES;
+			msg->tx_nack_cnt = 1;
+			return 0;
+		}
+	}
+	if (msg->len > 1 && !cec_msg_is_broadcast(msg) &&
+	    cec_has_log_addr(adap, cec_msg_destination(msg))) {
+		dprintk(1, "cec_transmit_msg: destination is the adapter itself\n");
+		return -EINVAL;
+	}
+	if (cec_msg_initiator(msg) != 0xf &&
+	    !cec_has_log_addr(adap, cec_msg_initiator(msg))) {
+		dprintk(1, "cec_transmit_msg: initiator has unknown logical address %d\n",
+			cec_msg_initiator(msg));
+		return -EINVAL;
+	}
+	if (!adap->is_configured && !adap->is_configuring)
+		return -ENONET;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	if (msg->len > 1 && msg->msg[1] == CEC_MSG_CDC_MESSAGE) {
+		msg->msg[2] = adap->phys_addr >> 8;
+		msg->msg[3] = adap->phys_addr & 0xff;
+	}
+
+	if (msg->timeout)
+		dprintk(2, "cec_transmit_msg: %*ph (wait for 0x%02x%s)\n",
+			msg->len, msg->msg, msg->reply, !block ? ", nb" : "");
+	else
+		dprintk(2, "cec_transmit_msg: %*ph%s\n",
+			msg->len, msg->msg, !block ? " (nb)" : "");
+
+	msg->rx_status = 0;
+	msg->tx_status = 0;
+	msg->tx_arb_lost_cnt = 0;
+	msg->tx_nack_cnt = 0;
+	msg->tx_low_drive_cnt = 0;
+	msg->tx_error_cnt = 0;
+	data->msg = *msg;
+	data->fh = fh;
+	data->adap = adap;
+	data->blocking = block;
+
+	/*
+	 * Determine if this message follows a message from the same
+	 * initiator. Needed to determine the free signal time later on.
+	 */
+	if (msg->len > 1) {
+		if (!(list_empty(&adap->transmit_queue))) {
+			const struct cec_data *last;
+
+			last = list_last_entry(&adap->transmit_queue,
+					       const struct cec_data, list);
+			last_initiator = cec_msg_initiator(&last->msg);
+		} else if (adap->transmitting) {
+			last_initiator =
+				cec_msg_initiator(&adap->transmitting->msg);
+		}
+	}
+	data->new_initiator = last_initiator != cec_msg_initiator(msg);
+	init_completion(&data->c);
+	INIT_DELAYED_WORK(&data->work, cec_wait_timeout);
+
+	data->msg.sequence = adap->sequence++;
+	if (fh)
+		list_add_tail(&data->xfer_list, &fh->xfer_list);
+	list_add_tail(&data->list, &adap->transmit_queue);
+	if (!adap->transmitting)
+		wake_up_interruptible(&adap->kthread_waitq);
+
+	/* All done if we don't need to block waiting for completion */
+	if (!block)
+		return 0;
+
+	/*
+	 * If we don't get a completion before this time something is really
+	 * wrong and we time out.
+	 */
+	timeout = CEC_XFER_TIMEOUT_MS;
+	/* Add the requested timeout if we have to wait for a reply as well */
+	if (msg->timeout)
+		timeout += msg->timeout;
+
+	/*
+	 * Release the lock and wait, retake the lock afterwards.
+	 */
+	mutex_unlock(&adap->lock);
+	res = wait_for_completion_killable_timeout(&data->c,
+						   msecs_to_jiffies(timeout));
+	mutex_lock(&adap->lock);
+
+	if (data->completed) {
+		/* The transmit completed (possibly with an error) */
+		*msg = data->msg;
+		kfree(data);
+		return 0;
+	}
+	/*
+	 * The wait for completion timed out or was interrupted, so mark this
+	 * as non-blocking and disconnect from the filehandle since it is
+	 * still 'in flight'. When it finally completes it will just drop the
+	 * result silently.
+	 */
+	data->blocking = false;
+	if (data->fh)
+		list_del(&data->xfer_list);
+	data->fh = NULL;
+
+	if (res == 0) { /* timed out */
+		/* Check if the reply or the transmit failed */
+		if (msg->timeout && (msg->tx_status & CEC_TX_STATUS_OK))
+			msg->rx_status = CEC_RX_STATUS_TIMEOUT;
+		else
+			msg->tx_status = CEC_TX_STATUS_MAX_RETRIES;
+	}
+	return res > 0 ? 0 : res;
+}
+
+/* Helper function to be used by drivers and this framework. */
+int cec_transmit_msg(struct cec_adapter *adap, struct cec_msg *msg,
+		     bool block)
+{
+	int ret;
+
+	mutex_lock(&adap->lock);
+	ret = cec_transmit_msg_fh(adap, msg, NULL, block);
+	mutex_unlock(&adap->lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(cec_transmit_msg);
+
+/*
+ * I don't like forward references but without this the low-level
+ * cec_received_msg() function would come after a bunch of high-level
+ * CEC protocol handling functions. That was very confusing.
+ */
+static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,
+			      bool is_reply);
+
+/* Called by the CEC adapter if a message is received */
+void cec_received_msg(struct cec_adapter *adap, struct cec_msg *msg)
+{
+	struct cec_data *data;
+	u8 msg_init = cec_msg_initiator(msg);
+	u8 msg_dest = cec_msg_destination(msg);
+	bool is_reply = false;
+	bool valid_la = true;
+
+	mutex_lock(&adap->lock);
+	msg->ts = ktime_get_ns();
+	msg->rx_status = CEC_RX_STATUS_OK;
+	msg->tx_status = 0;
+	msg->sequence = msg->reply = msg->timeout = 0;
+	msg->flags = 0;
+
+	dprintk(2, "cec_received_msg: %*ph\n", msg->len, msg->msg);
+
+	/* Check if this message was for us (directed or broadcast). */
+	if (!cec_msg_is_broadcast(msg))
+		valid_la = cec_has_log_addr(adap, msg_dest);
+
+	/* It's a valid message and not a poll or CDC message */
+	if (valid_la && msg->len > 1 && msg->msg[1] != CEC_MSG_CDC_MESSAGE) {
+		u8 cmd = msg->msg[1];
+		bool abort = cmd == CEC_MSG_FEATURE_ABORT;
+
+		/* The aborted command is in msg[2] */
+		if (abort)
+			cmd = msg->msg[2];
+
+		/*
+		 * Walk over all transmitted messages that are waiting for a
+		 * reply.
+		 */
+		list_for_each_entry(data, &adap->wait_queue, list) {
+			struct cec_msg *dst = &data->msg;
+			u8 dst_reply;
+
+			/* Does the command match? */
+			if ((abort && cmd != dst->msg[1]) ||
+			    (!abort && cmd != dst->reply))
+				continue;
+
+			/* Does the addressing match? */
+			if (msg_init != cec_msg_destination(dst) &&
+			    !cec_msg_is_broadcast(dst))
+				continue;
+
+			/* We got a reply */
+			msg->sequence = dst->sequence;
+			dst_reply = dst->reply;
+			*dst = *msg;
+			dst->reply = dst_reply;
+			if (abort) {
+				dst->reply = 0;
+				dst->rx_status |= CEC_RX_STATUS_FEATURE_ABORT;
+			}
+			/* Remove it from the wait_queue */
+			list_del_init(&data->list);
+
+			/* Cancel the pending timeout work */
+			if (!cancel_delayed_work(&data->work)) {
+				mutex_unlock(&adap->lock);
+				flush_scheduled_work();
+				mutex_lock(&adap->lock);
+			}
+			/*
+			 * Mark this as a reply, provided someone is still
+			 * waiting for the answer.
+			 */
+			if (data->fh)
+				is_reply = true;
+			cec_data_completed(data);
+			break;
+		}
+	}
+	mutex_unlock(&adap->lock);
+
+	/* Pass the message on to any monitoring filehandles */
+	cec_queue_msg_monitor(adap, msg, valid_la);
+
+	/* We're done if it is not for us or a poll message */
+	if (!valid_la || msg->len <= 1)
+		return;
+
+	/*
+	 * Process the message on the protocol level. If is_reply is true,
+	 * then cec_receive_notify() won't pass on the reply to the listener(s)
+	 * since that was already done by cec_data_completed() above.
+	 */
+	cec_receive_notify(adap, msg, is_reply);
+}
+EXPORT_SYMBOL_GPL(cec_received_msg);
+
+/* High-level core CEC message handling */
+
+/* Transmit the Report Features message */
+static int cec_report_features(struct cec_adapter *adap, unsigned int la_idx)
+{
+	struct cec_msg msg = { };
+	const struct cec_log_addrs *las = &adap->log_addrs;
+	const u8 *features = las->features[la_idx];
+	bool op_is_dev_features = false;
+	unsigned int idx;
+
+	/* This is 2.0 and up only */
+	if (adap->log_addrs.cec_version < CEC_OP_CEC_VERSION_2_0)
+		return 0;
+
+	/* Report Features */
+	msg.msg[0] = (las->log_addr[la_idx] << 4) | 0x0f;
+	msg.len = 4;
+	msg.msg[1] = CEC_MSG_REPORT_FEATURES;
+	msg.msg[2] = adap->log_addrs.cec_version;
+	msg.msg[3] = las->all_device_types[la_idx];
+
+	/* Write RC Profiles first, then Device Features */
+	for (idx = 0; idx < sizeof(las->features[0]); idx++) {
+		msg.msg[msg.len++] = features[idx];
+		if ((features[idx] & CEC_OP_FEAT_EXT) == 0) {
+			if (op_is_dev_features)
+				break;
+			op_is_dev_features = true;
+		}
+	}
+	return cec_transmit_msg(adap, &msg, false);
+}
+
+/* Transmit the Report Physical Address message */
+static int cec_report_phys_addr(struct cec_adapter *adap, unsigned int la_idx)
+{
+	const struct cec_log_addrs *las = &adap->log_addrs;
+	struct cec_msg msg = { };
+
+	/* Report Physical Address */
+	msg.msg[0] = (las->log_addr[la_idx] << 4) | 0x0f;
+	cec_msg_report_physical_addr(&msg, adap->phys_addr,
+				     las->primary_device_type[la_idx]);
+	dprintk(2, "config: la %d pa %x.%x.%x.%x\n",
+		las->log_addr[la_idx],
+			cec_phys_addr_exp(adap->phys_addr));
+	return cec_transmit_msg(adap, &msg, false);
+}
+
+/* Transmit the Feature Abort message */
+static int cec_feature_abort_reason(struct cec_adapter *adap,
+				    struct cec_msg *msg, u8 reason)
+{
+	struct cec_msg tx_msg = { };
+
+	/*
+	 * Don't reply with CEC_MSG_FEATURE_ABORT to a CEC_MSG_FEATURE_ABORT
+	 * message!
+	 */
+	if (msg->msg[1] == CEC_MSG_FEATURE_ABORT)
+		return 0;
+	cec_msg_set_reply_to(&tx_msg, msg);
+	cec_msg_feature_abort(&tx_msg, msg->msg[1], reason);
+	return cec_transmit_msg(adap, &tx_msg, false);
+}
+
+static int cec_feature_abort(struct cec_adapter *adap, struct cec_msg *msg)
+{
+	return cec_feature_abort_reason(adap, msg,
+					CEC_OP_ABORT_UNRECOGNIZED_OP);
+}
+
+static int cec_feature_refused(struct cec_adapter *adap, struct cec_msg *msg)
+{
+	return cec_feature_abort_reason(adap, msg,
+					CEC_OP_ABORT_REFUSED);
+}
+
+/*
+ * Called when a CEC message is received. This function will do any
+ * necessary core processing. The is_reply bool is true if this message
+ * is a reply to an earlier transmit.
+ *
+ * The message is either a broadcast message or a valid directed message.
+ */
+static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,
+			      bool is_reply)
+{
+	bool is_broadcast = cec_msg_is_broadcast(msg);
+	u8 dest_laddr = cec_msg_destination(msg);
+	u8 init_laddr = cec_msg_initiator(msg);
+	u8 devtype = cec_log_addr2dev(adap, dest_laddr);
+	int la_idx = cec_log_addr2idx(adap, dest_laddr);
+	bool is_directed = la_idx >= 0;
+	bool from_unregistered = init_laddr == 0xf;
+	struct cec_msg tx_cec_msg = { };
+
+	dprintk(1, "cec_receive_notify: %*ph\n", msg->len, msg->msg);
+
+	if (adap->ops->received) {
+		/* Allow drivers to process the message first */
+		if (adap->ops->received(adap, msg) != -ENOMSG)
+			return 0;
+	}
+
+	/*
+	 * REPORT_PHYSICAL_ADDR, CEC_MSG_USER_CONTROL_PRESSED and
+	 * CEC_MSG_USER_CONTROL_RELEASED messages always have to be
+	 * handled by the CEC core, even if the passthrough mode is on.
+	 * The others are just ignored if passthrough mode is on.
+	 */
+	switch (msg->msg[1]) {
+	case CEC_MSG_GET_CEC_VERSION:
+	case CEC_MSG_GIVE_DEVICE_VENDOR_ID:
+	case CEC_MSG_ABORT:
+	case CEC_MSG_GIVE_DEVICE_POWER_STATUS:
+	case CEC_MSG_GIVE_PHYSICAL_ADDR:
+	case CEC_MSG_GIVE_OSD_NAME:
+	case CEC_MSG_GIVE_FEATURES:
+		/*
+		 * Skip processing these messages if the passthrough mode
+		 * is on.
+		 */
+		if (adap->passthrough)
+			goto skip_processing;
+		/* Ignore if addressing is wrong */
+		if (is_broadcast || from_unregistered)
+			return 0;
+		break;
+
+	case CEC_MSG_USER_CONTROL_PRESSED:
+	case CEC_MSG_USER_CONTROL_RELEASED:
+		/* Wrong addressing mode: don't process */
+		if (is_broadcast || from_unregistered)
+			goto skip_processing;
+		break;
+
+	case CEC_MSG_REPORT_PHYSICAL_ADDR:
+		/*
+		 * This message is always processed, regardless of the
+		 * passthrough setting.
+		 *
+		 * Exception: don't process if wrong addressing mode.
+		 */
+		if (!is_broadcast)
+			goto skip_processing;
+		break;
+
+	default:
+		break;
+	}
+
+	cec_msg_set_reply_to(&tx_cec_msg, msg);
+
+	switch (msg->msg[1]) {
+	/* The following messages are processed but still passed through */
+	case CEC_MSG_REPORT_PHYSICAL_ADDR:
+		adap->phys_addrs[init_laddr] =
+			(msg->msg[2] << 8) | msg->msg[3];
+		dprintk(1, "Reported physical address %04x for logical address %d\n",
+			adap->phys_addrs[init_laddr], init_laddr);
+		break;
+
+	case CEC_MSG_USER_CONTROL_PRESSED:
+		if (!(adap->capabilities & CEC_CAP_RC))
+			break;
+
+#if IS_ENABLED(CONFIG_RC_CORE)
+		switch (msg->msg[2]) {
+		/*
+		 * Play function, this message can have variable length
+		 * depending on the specific play function that is used.
+		 */
+		case 0x60:
+			if (msg->len == 2)
+				rc_keydown(adap->rc, RC_TYPE_CEC,
+					   msg->msg[2], 0);
+			else
+				rc_keydown(adap->rc, RC_TYPE_CEC,
+					   msg->msg[2] << 8 | msg->msg[3], 0);
+			break;
+		/*
+		 * Other function messages that are not handled.
+		 * Currently the RC framework does not allow to supply an
+		 * additional parameter to a keypress. These "keys" contain
+		 * other information such as channel number, an input number
+		 * etc.
+		 * For the time being these messages are not processed by the
+		 * framework and are simply forwarded to the user space.
+		 */
+		case 0x56: case 0x57:
+		case 0x67: case 0x68: case 0x69: case 0x6a:
+			break;
+		default:
+			rc_keydown(adap->rc, RC_TYPE_CEC, msg->msg[2], 0);
+			break;
+		}
+#endif
+		break;
+
+	case CEC_MSG_USER_CONTROL_RELEASED:
+		if (!(adap->capabilities & CEC_CAP_RC))
+			break;
+#if IS_ENABLED(CONFIG_RC_CORE)
+		rc_keyup(adap->rc);
+#endif
+		break;
+
+	/*
+	 * The remaining messages are only processed if the passthrough mode
+	 * is off.
+	 */
+	case CEC_MSG_GET_CEC_VERSION:
+		cec_msg_cec_version(&tx_cec_msg, adap->log_addrs.cec_version);
+		return cec_transmit_msg(adap, &tx_cec_msg, false);
+
+	case CEC_MSG_GIVE_PHYSICAL_ADDR:
+		/* Do nothing for CEC switches using addr 15 */
+		if (devtype == CEC_OP_PRIM_DEVTYPE_SWITCH && dest_laddr == 15)
+			return 0;
+		cec_msg_report_physical_addr(&tx_cec_msg, adap->phys_addr, devtype);
+		return cec_transmit_msg(adap, &tx_cec_msg, false);
+
+	case CEC_MSG_GIVE_DEVICE_VENDOR_ID:
+		if (adap->log_addrs.vendor_id == CEC_VENDOR_ID_NONE)
+			return cec_feature_abort(adap, msg);
+		cec_msg_device_vendor_id(&tx_cec_msg, adap->log_addrs.vendor_id);
+		return cec_transmit_msg(adap, &tx_cec_msg, false);
+
+	case CEC_MSG_ABORT:
+		/* Do nothing for CEC switches */
+		if (devtype == CEC_OP_PRIM_DEVTYPE_SWITCH)
+			return 0;
+		return cec_feature_refused(adap, msg);
+
+	case CEC_MSG_GIVE_OSD_NAME: {
+		if (adap->log_addrs.osd_name[0] == 0)
+			return cec_feature_abort(adap, msg);
+		cec_msg_set_osd_name(&tx_cec_msg, adap->log_addrs.osd_name);
+		return cec_transmit_msg(adap, &tx_cec_msg, false);
+	}
+
+	case CEC_MSG_GIVE_FEATURES:
+		if (adap->log_addrs.cec_version >= CEC_OP_CEC_VERSION_2_0)
+			return cec_report_features(adap, la_idx);
+		return 0;
+
+	default:
+		/*
+		 * Unprocessed messages are aborted if userspace isn't doing
+		 * any processing either.
+		 */
+		if (is_directed && !is_reply && !adap->follower_cnt &&
+		    !adap->cec_follower && msg->msg[1] != CEC_MSG_FEATURE_ABORT)
+			return cec_feature_abort(adap, msg);
+		break;
+	}
+
+skip_processing:
+	/* If this was a reply, then we're done */
+	if (is_reply)
+		return 0;
+
+	/*
+	 * Send to the exclusive follower if there is one, otherwise send
+	 * to all followers.
+	 */
+	if (adap->cec_follower)
+		cec_queue_msg_fh(adap->cec_follower, msg);
+	else
+		cec_queue_msg_followers(adap, msg);
+	return 0;
+}
+
+/*
+ * Attempt to claim a specific logical address.
+ *
+ * This function is called with adap->lock held.
+ */
+static int cec_config_log_addr(struct cec_adapter *adap,
+			       unsigned int idx,
+			       unsigned int log_addr)
+{
+	struct cec_log_addrs *las = &adap->log_addrs;
+	struct cec_msg msg = { };
+	int err;
+
+	if (cec_has_log_addr(adap, log_addr))
+		return 0;
+
+	/* Send poll message */
+	msg.len = 1;
+	msg.msg[0] = 0xf0 | log_addr;
+	err = cec_transmit_msg_fh(adap, &msg, NULL, true);
+
+	/*
+	 * While trying to poll the physical address was reset
+	 * and the adapter was unconfigured, so bail out.
+	 */
+	if (!adap->is_configuring)
+		return -EINTR;
+
+	if (err)
+		return err;
+
+	if (msg.tx_status & CEC_TX_STATUS_OK)
+		return 0;
+
+	/*
+	 * Message not acknowledged, so this logical
+	 * address is free to use.
+	 */
+	err = adap->ops->adap_log_addr(adap, log_addr);
+	if (err)
+		return err;
+
+	las->log_addr[idx] = log_addr;
+	las->log_addr_mask |= 1 << log_addr;
+	adap->phys_addrs[log_addr] = adap->phys_addr;
+
+	dprintk(2, "claimed addr %d (%d)\n", log_addr,
+		las->primary_device_type[idx]);
+	return 1;
+}
+
+/*
+ * Unconfigure the adapter: clear all logical addresses and send
+ * the state changed event.
+ *
+ * This function is called with adap->lock held.
+ */
+static void cec_adap_unconfigure(struct cec_adapter *adap)
+{
+	WARN_ON(adap->ops->adap_log_addr(adap, CEC_LOG_ADDR_INVALID));
+	adap->log_addrs.log_addr_mask = 0;
+	adap->is_configuring = false;
+	adap->is_configured = false;
+	memset(adap->phys_addrs, 0xff, sizeof(adap->phys_addrs));
+	wake_up_interruptible(&adap->kthread_waitq);
+	cec_post_state_event(adap);
+}
+
+/*
+ * Attempt to claim the required logical addresses.
+ */
+static int cec_config_thread_func(void *arg)
+{
+	/* The various LAs for each type of device */
+	static const u8 tv_log_addrs[] = {
+		CEC_LOG_ADDR_TV, CEC_LOG_ADDR_SPECIFIC,
+		CEC_LOG_ADDR_INVALID
+	};
+	static const u8 record_log_addrs[] = {
+		CEC_LOG_ADDR_RECORD_1, CEC_LOG_ADDR_RECORD_2,
+		CEC_LOG_ADDR_RECORD_3,
+		CEC_LOG_ADDR_BACKUP_1, CEC_LOG_ADDR_BACKUP_2,
+		CEC_LOG_ADDR_INVALID
+	};
+	static const u8 tuner_log_addrs[] = {
+		CEC_LOG_ADDR_TUNER_1, CEC_LOG_ADDR_TUNER_2,
+		CEC_LOG_ADDR_TUNER_3, CEC_LOG_ADDR_TUNER_4,
+		CEC_LOG_ADDR_BACKUP_1, CEC_LOG_ADDR_BACKUP_2,
+		CEC_LOG_ADDR_INVALID
+	};
+	static const u8 playback_log_addrs[] = {
+		CEC_LOG_ADDR_PLAYBACK_1, CEC_LOG_ADDR_PLAYBACK_2,
+		CEC_LOG_ADDR_PLAYBACK_3,
+		CEC_LOG_ADDR_BACKUP_1, CEC_LOG_ADDR_BACKUP_2,
+		CEC_LOG_ADDR_INVALID
+	};
+	static const u8 audiosystem_log_addrs[] = {
+		CEC_LOG_ADDR_AUDIOSYSTEM,
+		CEC_LOG_ADDR_INVALID
+	};
+	static const u8 specific_use_log_addrs[] = {
+		CEC_LOG_ADDR_SPECIFIC,
+		CEC_LOG_ADDR_BACKUP_1, CEC_LOG_ADDR_BACKUP_2,
+		CEC_LOG_ADDR_INVALID
+	};
+	static const u8 *type2addrs[6] = {
+		[CEC_LOG_ADDR_TYPE_TV] = tv_log_addrs,
+		[CEC_LOG_ADDR_TYPE_RECORD] = record_log_addrs,
+		[CEC_LOG_ADDR_TYPE_TUNER] = tuner_log_addrs,
+		[CEC_LOG_ADDR_TYPE_PLAYBACK] = playback_log_addrs,
+		[CEC_LOG_ADDR_TYPE_AUDIOSYSTEM] = audiosystem_log_addrs,
+		[CEC_LOG_ADDR_TYPE_SPECIFIC] = specific_use_log_addrs,
+	};
+	static const u16 type2mask[] = {
+		[CEC_LOG_ADDR_TYPE_TV] = CEC_LOG_ADDR_MASK_TV,
+		[CEC_LOG_ADDR_TYPE_RECORD] = CEC_LOG_ADDR_MASK_RECORD,
+		[CEC_LOG_ADDR_TYPE_TUNER] = CEC_LOG_ADDR_MASK_TUNER,
+		[CEC_LOG_ADDR_TYPE_PLAYBACK] = CEC_LOG_ADDR_MASK_PLAYBACK,
+		[CEC_LOG_ADDR_TYPE_AUDIOSYSTEM] = CEC_LOG_ADDR_MASK_AUDIOSYSTEM,
+		[CEC_LOG_ADDR_TYPE_SPECIFIC] = CEC_LOG_ADDR_MASK_SPECIFIC,
+	};
+	struct cec_adapter *adap = arg;
+	struct cec_log_addrs *las = &adap->log_addrs;
+	int err;
+	int i, j;
+
+	mutex_lock(&adap->lock);
+	dprintk(1, "physical address: %x.%x.%x.%x, claim %d logical addresses\n",
+		cec_phys_addr_exp(adap->phys_addr), las->num_log_addrs);
+	las->log_addr_mask = 0;
+
+	if (las->log_addr_type[0] == CEC_LOG_ADDR_TYPE_UNREGISTERED)
+		goto configured;
+
+	for (i = 0; i < las->num_log_addrs; i++) {
+		unsigned int type = las->log_addr_type[i];
+		const u8 *la_list;
+		u8 last_la;
+
+		/*
+		 * The TV functionality can only map to physical address 0.
+		 * For any other address, try the Specific functionality
+		 * instead as per the spec.
+		 */
+		if (adap->phys_addr && type == CEC_LOG_ADDR_TYPE_TV)
+			type = CEC_LOG_ADDR_TYPE_SPECIFIC;
+
+		la_list = type2addrs[type];
+		last_la = las->log_addr[i];
+		las->log_addr[i] = CEC_LOG_ADDR_INVALID;
+		if (last_la == CEC_LOG_ADDR_INVALID ||
+		    last_la == CEC_LOG_ADDR_UNREGISTERED ||
+		    !(last_la & type2mask[type]))
+			last_la = la_list[0];
+
+		err = cec_config_log_addr(adap, i, last_la);
+		if (err > 0) /* Reused last LA */
+			continue;
+
+		if (err < 0)
+			goto unconfigure;
+
+		for (j = 0; la_list[j] != CEC_LOG_ADDR_INVALID; j++) {
+			/* Tried this one already, skip it */
+			if (la_list[j] == last_la)
+				continue;
+			/* The backup addresses are CEC 2.0 specific */
+			if ((la_list[j] == CEC_LOG_ADDR_BACKUP_1 ||
+			     la_list[j] == CEC_LOG_ADDR_BACKUP_2) &&
+			    las->cec_version < CEC_OP_CEC_VERSION_2_0)
+				continue;
+
+			err = cec_config_log_addr(adap, i, la_list[j]);
+			if (err == 0) /* LA is in use */
+				continue;
+			if (err < 0)
+				goto unconfigure;
+			/* Done, claimed an LA */
+			break;
+		}
+
+		if (la_list[j] == CEC_LOG_ADDR_INVALID)
+			dprintk(1, "could not claim LA %d\n", i);
+	}
+
+configured:
+	if (adap->log_addrs.log_addr_mask == 0) {
+		/* Fall back to unregistered */
+		las->log_addr[0] = CEC_LOG_ADDR_UNREGISTERED;
+		las->log_addr_mask = 1 << las->log_addr[0];
+	}
+	adap->is_configured = true;
+	adap->is_configuring = false;
+	cec_post_state_event(adap);
+	mutex_unlock(&adap->lock);
+
+	for (i = 0; i < las->num_log_addrs; i++) {
+		if (las->log_addr[i] == CEC_LOG_ADDR_INVALID)
+			continue;
+
+		/*
+		 * Report Features must come first according
+		 * to CEC 2.0
+		 */
+		if (las->log_addr[i] != CEC_LOG_ADDR_UNREGISTERED)
+			cec_report_features(adap, i);
+		cec_report_phys_addr(adap, i);
+	}
+	mutex_lock(&adap->lock);
+	adap->kthread_config = NULL;
+	mutex_unlock(&adap->lock);
+	complete(&adap->config_completion);
+	return 0;
+
+unconfigure:
+	for (i = 0; i < las->num_log_addrs; i++)
+		las->log_addr[i] = CEC_LOG_ADDR_INVALID;
+	cec_adap_unconfigure(adap);
+	adap->kthread_config = NULL;
+	mutex_unlock(&adap->lock);
+	complete(&adap->config_completion);
+	return 0;
+}
+
+/*
+ * Called from either __cec_s_phys_addr or __cec_s_log_addrs to claim the
+ * logical addresses.
+ *
+ * This function is called with adap->lock held.
+ */
+static void cec_claim_log_addrs(struct cec_adapter *adap, bool block)
+{
+	if (WARN_ON(adap->is_configuring || adap->is_configured))
+		return;
+
+	init_completion(&adap->config_completion);
+
+	/* Ready to kick off the thread */
+	adap->is_configuring = true;
+	adap->kthread_config = kthread_run(cec_config_thread_func, adap,
+					   "ceccfg-%s", adap->name);
+	if (IS_ERR(adap->kthread_config)) {
+		adap->kthread_config = NULL;
+	} else if (block) {
+		mutex_unlock(&adap->lock);
+		wait_for_completion(&adap->config_completion);
+		mutex_lock(&adap->lock);
+	}
+}
+
+/* Set a new physical address and send an event notifying userspace of this.
+ *
+ * This function is called with adap->lock held.
+ */
+static void __cec_s_phys_addr(struct cec_adapter *adap, u16 phys_addr, bool block)
+{
+	if (phys_addr == adap->phys_addr)
+		return;
+
+	if (phys_addr == CEC_PHYS_ADDR_INVALID ||
+	    adap->phys_addr != CEC_PHYS_ADDR_INVALID) {
+		adap->phys_addr = CEC_PHYS_ADDR_INVALID;
+		cec_post_state_event(adap);
+		cec_adap_unconfigure(adap);
+		/* Disabling monitor all mode should always succeed */
+		if (adap->monitor_all_cnt)
+			WARN_ON(call_op(adap, adap_monitor_all_enable, false));
+		WARN_ON(adap->ops->adap_enable(adap, false));
+		if (phys_addr == CEC_PHYS_ADDR_INVALID)
+			return;
+	}
+
+	if (adap->ops->adap_enable(adap, true))
+		return;
+
+	if (adap->monitor_all_cnt &&
+	    call_op(adap, adap_monitor_all_enable, true)) {
+		WARN_ON(adap->ops->adap_enable(adap, false));
+		return;
+	}
+	adap->phys_addr = phys_addr;
+	cec_post_state_event(adap);
+	if (adap->log_addrs.num_log_addrs)
+		cec_claim_log_addrs(adap, block);
+}
+
+void cec_s_phys_addr(struct cec_adapter *adap, u16 phys_addr, bool block)
+{
+	if (IS_ERR_OR_NULL(adap))
+		return;
+
+	if (WARN_ON(adap->capabilities & CEC_CAP_PHYS_ADDR))
+		return;
+	mutex_lock(&adap->lock);
+	__cec_s_phys_addr(adap, phys_addr, block);
+	mutex_unlock(&adap->lock);
+}
+EXPORT_SYMBOL_GPL(cec_s_phys_addr);
+
+/*
+ * Called from either the ioctl or a driver to set the logical addresses.
+ *
+ * This function is called with adap->lock held.
+ */
+static int __cec_s_log_addrs(struct cec_adapter *adap,
+			     struct cec_log_addrs *log_addrs, bool block)
+{
+	u16 type_mask = 0;
+	int i;
+
+	if (!log_addrs || log_addrs->num_log_addrs == 0) {
+		adap->log_addrs.num_log_addrs = 0;
+		cec_adap_unconfigure(adap);
+		return 0;
+	}
+
+	/* Ensure the osd name is 0-terminated */
+	log_addrs->osd_name[sizeof(log_addrs->osd_name) - 1] = '\0';
+
+	/* Sanity checks */
+	if (log_addrs->num_log_addrs > adap->available_log_addrs) {
+		dprintk(1, "num_log_addrs > %d\n", adap->available_log_addrs);
+		return -EINVAL;
+	}
+
+	/*
+	 * Vendor ID is a 24 bit number, so check if the value is
+	 * within the correct range.
+	 */
+	if (log_addrs->vendor_id != CEC_VENDOR_ID_NONE &&
+	    (log_addrs->vendor_id & 0xff000000) != 0)
+		return -EINVAL;
+
+	if (log_addrs->cec_version != CEC_OP_CEC_VERSION_1_4 &&
+	    log_addrs->cec_version != CEC_OP_CEC_VERSION_2_0)
+		return -EINVAL;
+
+	if (log_addrs->num_log_addrs > 1)
+		for (i = 0; i < log_addrs->num_log_addrs; i++)
+			if (log_addrs->log_addr_type[i] ==
+					CEC_LOG_ADDR_TYPE_UNREGISTERED) {
+				dprintk(1, "num_log_addrs > 1 can't be combined with unregistered LA\n");
+				return -EINVAL;
+			}
+
+	if (log_addrs->cec_version < CEC_OP_CEC_VERSION_2_0) {
+		memset(log_addrs->all_device_types, 0,
+		       sizeof(log_addrs->all_device_types));
+		memset(log_addrs->features, 0, sizeof(log_addrs->features));
+	}
+
+	for (i = 0; i < log_addrs->num_log_addrs; i++) {
+		u8 *features = log_addrs->features[i];
+		bool op_is_dev_features = false;
+
+		log_addrs->log_addr[i] = CEC_LOG_ADDR_INVALID;
+		if (type_mask & (1 << log_addrs->log_addr_type[i])) {
+			dprintk(1, "duplicate logical address type\n");
+			return -EINVAL;
+		}
+		type_mask |= 1 << log_addrs->log_addr_type[i];
+		if ((type_mask & (1 << CEC_LOG_ADDR_TYPE_RECORD)) &&
+		    (type_mask & (1 << CEC_LOG_ADDR_TYPE_PLAYBACK))) {
+			/* Record already contains the playback functionality */
+			dprintk(1, "invalid record + playback combination\n");
+			return -EINVAL;
+		}
+		if (log_addrs->primary_device_type[i] >
+					CEC_OP_PRIM_DEVTYPE_PROCESSOR) {
+			dprintk(1, "unknown primary device type\n");
+			return -EINVAL;
+		}
+		if (log_addrs->primary_device_type[i] == 2) {
+			dprintk(1, "invalid primary device type\n");
+			return -EINVAL;
+		}
+		if (log_addrs->log_addr_type[i] > CEC_LOG_ADDR_TYPE_UNREGISTERED) {
+			dprintk(1, "unknown logical address type\n");
+			return -EINVAL;
+		}
+		if (log_addrs->cec_version < CEC_OP_CEC_VERSION_2_0)
+			continue;
+
+		for (i = 0; i < sizeof(log_addrs->features[0]); i++) {
+			if ((features[i] & 0x80) == 0) {
+				if (op_is_dev_features)
+					break;
+				op_is_dev_features = true;
+			}
+		}
+		if (!op_is_dev_features || i == sizeof(log_addrs->features[0])) {
+			dprintk(1, "malformed features\n");
+			return -EINVAL;
+		}
+	}
+
+	if (log_addrs->cec_version >= CEC_OP_CEC_VERSION_2_0) {
+		if (log_addrs->num_log_addrs > 2) {
+			dprintk(1, "CEC 2.0 allows no more than 2 logical addresses\n");
+			return -EINVAL;
+		}
+		if (log_addrs->num_log_addrs == 2) {
+			if (!(type_mask & ((1 << CEC_LOG_ADDR_TYPE_AUDIOSYSTEM) |
+					   (1 << CEC_LOG_ADDR_TYPE_TV)))) {
+				dprintk(1, "Two LAs is only allowed for audiosystem and TV\n");
+				return -EINVAL;
+			}
+			if (!(type_mask & ((1 << CEC_LOG_ADDR_TYPE_PLAYBACK) |
+					   (1 << CEC_LOG_ADDR_TYPE_RECORD)))) {
+				dprintk(1, "An audiosystem/TV can only be combined with record or playback\n");
+				return -EINVAL;
+			}
+		}
+	}
+
+	log_addrs->log_addr_mask = adap->log_addrs.log_addr_mask;
+	adap->log_addrs = *log_addrs;
+	if (adap->phys_addr != CEC_PHYS_ADDR_INVALID)
+		cec_claim_log_addrs(adap, block);
+	return 0;
+}
+
+int cec_s_log_addrs(struct cec_adapter *adap,
+		    struct cec_log_addrs *log_addrs, bool block)
+{
+	int err;
+
+	if (WARN_ON(adap->capabilities & CEC_CAP_LOG_ADDRS))
+		return -EINVAL;
+	mutex_lock(&adap->lock);
+	err = __cec_s_log_addrs(adap, log_addrs, block);
+	mutex_unlock(&adap->lock);
+	return err;
+}
+EXPORT_SYMBOL_GPL(cec_s_log_addrs);
+
+/*
+ * Log the current state of the CEC adapter.
+ * Very useful for debugging.
+ */
+static int cec_status(struct seq_file *file, void *priv)
+{
+	struct cec_adapter *adap = dev_get_drvdata(file->private);
+	struct cec_data *data;
+
+	mutex_lock(&adap->lock);
+	seq_printf(file, "configured: %d\n", adap->is_configured);
+	seq_printf(file, "configuring: %d\n", adap->is_configuring);
+	seq_printf(file, "phys_addr: %x.%x.%x.%x\n",
+		   cec_phys_addr_exp(adap->phys_addr));
+	seq_printf(file, "number of LAs: %d\n", adap->log_addrs.num_log_addrs);
+	seq_printf(file, "LA mask: 0x%04x\n", adap->log_addrs.log_addr_mask);
+	if (adap->cec_follower)
+		seq_printf(file, "has CEC follower%s\n",
+			   adap->passthrough ? " (in passthrough mode)" : "");
+	if (adap->cec_initiator)
+		seq_puts(file, "has CEC initiator\n");
+	if (adap->monitor_all_cnt)
+		seq_printf(file, "file handles in Monitor All mode: %u\n",
+			   adap->monitor_all_cnt);
+	data = adap->transmitting;
+	if (data)
+		seq_printf(file, "transmitting message: %*ph (reply: %02x)\n",
+			   data->msg.len, data->msg.msg, data->msg.reply);
+	list_for_each_entry(data, &adap->transmit_queue, list) {
+		seq_printf(file, "queued tx message: %*ph (reply: %02x)\n",
+			   data->msg.len, data->msg.msg, data->msg.reply);
+	}
+	list_for_each_entry(data, &adap->wait_queue, list) {
+		seq_printf(file, "message waiting for reply: %*ph (reply: %02x)\n",
+			   data->msg.len, data->msg.msg, data->msg.reply);
+	}
+
+	call_void_op(adap, adap_status, file);
+	mutex_unlock(&adap->lock);
+	return 0;
+}
+
+/* CEC file operations */
+
+static unsigned int cec_poll(struct file *filp,
+			     struct poll_table_struct *poll)
+{
+	struct cec_devnode *devnode = cec_devnode_data(filp);
+	struct cec_fh *fh = filp->private_data;
+	struct cec_adapter *adap = fh->adap;
+	unsigned int res = 0;
+
+	if (!devnode->registered)
+		return POLLERR | POLLHUP;
+	mutex_lock(&adap->lock);
+	if (adap->is_configured)
+		res |= POLLOUT | POLLWRNORM;
+	if (fh->queued_msgs)
+		res |= POLLIN | POLLRDNORM;
+	if (fh->events)
+		res |= POLLPRI;
+	poll_wait(filp, &fh->wait, poll);
+	mutex_unlock(&adap->lock);
+	return res;
+}
+
+/*
+ * Helper functions to keep track of the 'monitor all' use count.
+ *
+ * These functions are called with adap->lock held.
+ */
+static int cec_monitor_all_cnt_inc(struct cec_adapter *adap)
+{
+	int ret = 0;
+
+	if (adap->monitor_all_cnt == 0)
+		ret = call_op(adap, adap_monitor_all_enable, 1);
+	if (ret == 0)
+		adap->monitor_all_cnt++;
+	return ret;
+}
+
+static void cec_monitor_all_cnt_dec(struct cec_adapter *adap)
+{
+	adap->monitor_all_cnt--;
+	if (adap->monitor_all_cnt == 0)
+		WARN_ON(call_op(adap, adap_monitor_all_enable, 0));
+}
+
+/* Called by CEC_RECEIVE: wait for a message to arrive */
+static int cec_receive_msg(struct cec_fh *fh, struct cec_msg *msg, bool block)
+{
+	int res;
+
+	do {
+		mutex_lock(&fh->lock);
+		/* Are there received messages queued up? */
+		if (fh->queued_msgs) {
+			/* Yes, return the first one */
+			struct cec_msg_entry *entry =
+				list_first_entry(&fh->msgs,
+						 struct cec_msg_entry, list);
+
+			list_del(&entry->list);
+			*msg = entry->msg;
+			kfree(entry);
+			fh->queued_msgs--;
+			res = 0;
+		} else {
+			/* No, return EAGAIN in non-blocking mode or wait */
+			res = -EAGAIN;
+		}
+		mutex_unlock(&fh->lock);
+		/* Return when in non-blocking mode or if we have a message */
+		if (!block || !res)
+			break;
+
+		if (msg->timeout) {
+			/* The user specified a timeout */
+			res = wait_event_interruptible_timeout(fh->wait,
+							       fh->queued_msgs,
+				msecs_to_jiffies(msg->timeout));
+			if (res == 0)
+				res = -ETIMEDOUT;
+			else if (res > 0)
+				res = 0;
+		} else {
+			/* Wait indefinitely */
+			res = wait_event_interruptible(fh->wait,
+						       fh->queued_msgs);
+		}
+		/* Exit on error, otherwise loop to get the new message */
+	} while (!res);
+	return res;
+}
+
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
+static long cec_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	struct cec_devnode *devnode = cec_devnode_data(filp);
+	struct cec_fh *fh = filp->private_data;
+	struct cec_adapter *adap = fh->adap;
+	bool block = !(filp->f_flags & O_NONBLOCK);
+	void __user *parg = (void __user *)arg;
+	int err = 0;
+
+	if (!devnode->registered)
+		return -EIO;
+
+	switch (cmd) {
+	case CEC_ADAP_G_CAPS: {
+		struct cec_caps caps = {};
+
+		strlcpy(caps.driver, adap->devnode.parent->driver->name,
+			sizeof(caps.driver));
+		strlcpy(caps.name, adap->name, sizeof(caps.name));
+		caps.available_log_addrs = adap->available_log_addrs;
+		caps.capabilities = adap->capabilities;
+		caps.version = LINUX_VERSION_CODE;
+		if (copy_to_user(parg, &caps, sizeof(caps)))
+			return -EFAULT;
+		break;
+	}
+
+	case CEC_TRANSMIT: {
+		struct cec_msg msg = {};
+
+		if (!(adap->capabilities & CEC_CAP_TRANSMIT))
+			return -ENOTTY;
+		if (copy_from_user(&msg, parg, sizeof(msg)))
+			return -EFAULT;
+		mutex_lock(&adap->lock);
+		if (!adap->is_configured) {
+			err = -ENONET;
+		} else if (cec_is_busy(adap, fh)) {
+			err = -EBUSY;
+		} else {
+			if (!block || !msg.reply)
+				fh = NULL;
+			err = cec_transmit_msg_fh(adap, &msg, fh, block);
+		}
+		mutex_unlock(&adap->lock);
+		if (err)
+			return err;
+		if (copy_to_user(parg, &msg, sizeof(msg)))
+			return -EFAULT;
+		break;
+	}
+
+	case CEC_RECEIVE: {
+		struct cec_msg msg = {};
+
+		if (copy_from_user(&msg, parg, sizeof(msg)))
+			return -EFAULT;
+		mutex_lock(&adap->lock);
+		if (!adap->is_configured)
+			err = -ENONET;
+		mutex_unlock(&adap->lock);
+		if (err)
+			return err;
+
+		err = cec_receive_msg(fh, &msg, block);
+		if (err)
+			return err;
+		if (copy_to_user(parg, &msg, sizeof(msg)))
+			return -EFAULT;
+		break;
+	}
+
+	case CEC_DQEVENT: {
+		struct cec_event_queue *evq = NULL;
+		struct cec_event *ev = NULL;
+		u64 ts = ~0ULL;
+		unsigned int i;
+
+		mutex_lock(&fh->lock);
+		while (!fh->events && block) {
+			mutex_unlock(&fh->lock);
+			err = wait_event_interruptible(fh->wait, fh->events);
+			if (err)
+				return err;
+			mutex_lock(&fh->lock);
+		}
+
+		/* Find the oldest event */
+		for (i = 0; i < CEC_NUM_EVENTS; i++) {
+			struct cec_event_queue *q = fh->evqueue + i;
+
+			if (q->num_events && q->events->ts <= ts) {
+				evq = q;
+				ev = q->events;
+				ts = ev->ts;
+			}
+		}
+		err = -EAGAIN;
+		if (ev) {
+			if (copy_to_user(parg, ev, sizeof(*ev))) {
+				err = -EFAULT;
+			} else {
+				unsigned int j;
+
+				evq->num_events--;
+				fh->events--;
+				/*
+				 * Reset lost message counter after returning
+				 * this event.
+				 */
+				if (ev->event == CEC_EVENT_LOST_MSGS)
+					fh->lost_msgs = 0;
+				for (j = 0; j < evq->num_events; j++)
+					evq->events[j] = evq->events[j + 1];
+				err = 0;
+			}
+		}
+		mutex_unlock(&fh->lock);
+		return err;
+	}
+
+	case CEC_ADAP_G_PHYS_ADDR: {
+		u16 phys_addr;
+
+		mutex_lock(&adap->lock);
+		phys_addr = adap->phys_addr;
+		if (copy_to_user(parg, &phys_addr, sizeof(adap->phys_addr)))
+			err = -EFAULT;
+		mutex_unlock(&adap->lock);
+		break;
+	}
+
+	case CEC_ADAP_S_PHYS_ADDR: {
+		u16 phys_addr;
+
+		if (!(adap->capabilities & CEC_CAP_PHYS_ADDR))
+			return -ENOTTY;
+		if (copy_from_user(&phys_addr, parg, sizeof(phys_addr)))
+			return -EFAULT;
+
+		err = cec_phys_addr_validate(phys_addr, NULL, NULL);
+		if (err)
+			return err;
+		mutex_lock(&adap->lock);
+		if (cec_is_busy(adap, fh))
+			err = -EBUSY;
+		else
+			__cec_s_phys_addr(adap, phys_addr, block);
+		mutex_unlock(&adap->lock);
+		break;
+	}
+
+	case CEC_ADAP_G_LOG_ADDRS: {
+		struct cec_log_addrs log_addrs;
+
+		mutex_lock(&adap->lock);
+		log_addrs = adap->log_addrs;
+		if (!adap->is_configured)
+			memset(log_addrs.log_addr, CEC_LOG_ADDR_INVALID,
+			       sizeof(log_addrs.log_addr));
+		mutex_unlock(&adap->lock);
+
+		if (copy_to_user(parg, &log_addrs, sizeof(log_addrs)))
+			return -EFAULT;
+		break;
+	}
+
+	case CEC_ADAP_S_LOG_ADDRS: {
+		struct cec_log_addrs log_addrs;
+
+		if (!(adap->capabilities & CEC_CAP_LOG_ADDRS))
+			return -ENOTTY;
+		if (copy_from_user(&log_addrs, parg, sizeof(log_addrs)))
+			return -EFAULT;
+		log_addrs.flags = 0;
+		mutex_lock(&adap->lock);
+		if (adap->is_configuring)
+			err = -EBUSY;
+		else if (log_addrs.num_log_addrs && adap->is_configured)
+			err = -EBUSY;
+		else if (cec_is_busy(adap, fh))
+			err = -EBUSY;
+		else
+			err = __cec_s_log_addrs(adap, &log_addrs, block);
+		if (!err)
+			log_addrs = adap->log_addrs;
+		mutex_unlock(&adap->lock);
+		if (!err && copy_to_user(parg, &log_addrs, sizeof(log_addrs)))
+			return -EFAULT;
+		break;
+	}
+
+	case CEC_G_MODE: {
+		u32 mode = fh->mode_initiator | fh->mode_follower;
+
+		if (copy_to_user(parg, &mode, sizeof(mode)))
+			return -EFAULT;
+		break;
+	}
+
+	case CEC_S_MODE: {
+		u32 mode;
+		u8 mode_initiator;
+		u8 mode_follower;
+
+		if (copy_from_user(&mode, parg, sizeof(mode)))
+			return -EFAULT;
+		if (mode & ~(CEC_MODE_INITIATOR_MSK | CEC_MODE_FOLLOWER_MSK))
+			return -EINVAL;
+
+		mode_initiator = mode & CEC_MODE_INITIATOR_MSK;
+		mode_follower = mode & CEC_MODE_FOLLOWER_MSK;
+
+		if (mode_initiator > CEC_MODE_EXCL_INITIATOR ||
+		    mode_follower > CEC_MODE_MONITOR_ALL)
+			return -EINVAL;
+
+		if (mode_follower == CEC_MODE_MONITOR_ALL &&
+		    !(adap->capabilities & CEC_CAP_MONITOR_ALL))
+			return -EINVAL;
+
+		/* Follower modes should always be able to send CEC messages */
+		if ((mode_initiator == CEC_MODE_NO_INITIATOR ||
+		     !(adap->capabilities & CEC_CAP_TRANSMIT)) &&
+		    mode_follower >= CEC_MODE_FOLLOWER &&
+		    mode_follower <= CEC_MODE_EXCL_FOLLOWER_PASSTHRU)
+			return -EINVAL;
+
+		/* Monitor modes require CEC_MODE_NO_INITIATOR */
+		if (mode_initiator && mode_follower >= CEC_MODE_MONITOR)
+			return -EINVAL;
+
+		/* Monitor modes require CAP_NET_ADMIN */
+		if (mode_follower >= CEC_MODE_MONITOR && !capable(CAP_NET_ADMIN))
+			return -EPERM;
+
+		mutex_lock(&adap->lock);
+		/*
+		 * You can't become exclusive follower if someone else already
+		 * has that job.
+		 */
+		if ((mode_follower == CEC_MODE_EXCL_FOLLOWER ||
+		     mode_follower == CEC_MODE_EXCL_FOLLOWER_PASSTHRU) &&
+		    adap->cec_follower && adap->cec_follower != fh)
+			err = -EBUSY;
+		/*
+		 * You can't become exclusive initiator if someone else already
+		 * has that job.
+		 */
+		if (mode_initiator == CEC_MODE_EXCL_INITIATOR &&
+		    adap->cec_initiator && adap->cec_initiator != fh)
+			err = -EBUSY;
+
+		if (!err) {
+			bool old_mon_all = fh->mode_follower == CEC_MODE_MONITOR_ALL;
+			bool new_mon_all = mode_follower == CEC_MODE_MONITOR_ALL;
+
+			if (old_mon_all != new_mon_all) {
+				if (new_mon_all)
+					err = cec_monitor_all_cnt_inc(adap);
+				else
+					cec_monitor_all_cnt_dec(adap);
+			}
+		}
+
+		if (err) {
+			mutex_unlock(&adap->lock);
+			break;
+		}
+
+		if (fh->mode_follower == CEC_MODE_FOLLOWER)
+			adap->follower_cnt--;
+		if (mode_follower == CEC_MODE_FOLLOWER)
+			adap->follower_cnt++;
+		if (mode_follower == CEC_MODE_EXCL_FOLLOWER ||
+		    mode_follower == CEC_MODE_EXCL_FOLLOWER_PASSTHRU) {
+			adap->passthrough =
+				mode_follower == CEC_MODE_EXCL_FOLLOWER_PASSTHRU;
+			adap->cec_follower = fh;
+		} else if (adap->cec_follower == fh) {
+			adap->passthrough = false;
+			adap->cec_follower = NULL;
+		}
+		if (mode_initiator == CEC_MODE_EXCL_INITIATOR)
+			adap->cec_initiator = fh;
+		else if (adap->cec_initiator == fh)
+			adap->cec_initiator = NULL;
+		fh->mode_initiator = mode_initiator;
+		fh->mode_follower = mode_follower;
+		mutex_unlock(&adap->lock);
+		break;
+	}
+
+	default:
+		return -ENOTTY;
+	}
+	return err;
+}
+
+static int cec_open(struct inode *inode, struct file *filp)
+{
+	struct cec_devnode *devnode =
+		container_of(inode->i_cdev, struct cec_devnode, cdev);
+	struct cec_adapter *adap = to_cec_adapter(devnode);
+	struct cec_fh *fh = kzalloc(sizeof(*fh), GFP_KERNEL);
+	/*
+	 * Initial events that are automatically sent when the cec device is
+	 * opened.
+	 */
+	struct cec_event ev_state = {
+		.event = CEC_EVENT_STATE_CHANGE,
+		.flags = CEC_EVENT_FL_INITIAL_STATE,
+	};
+	int ret;
+
+	if (!fh)
+		return -ENOMEM;
+
+	ret = cec_queue_event_init(fh);
+
+	if (ret) {
+		kfree(fh);
+		return ret;
+	}
+
+	INIT_LIST_HEAD(&fh->msgs);
+	INIT_LIST_HEAD(&fh->xfer_list);
+	mutex_init(&fh->lock);
+	init_waitqueue_head(&fh->wait);
+
+	fh->mode_initiator = CEC_MODE_INITIATOR;
+	fh->adap = adap;
+
+	/*
+	 * Check if the cec device is available. This needs to be done with
+	 * the cec_devnode_lock held to prevent an open/unregister race:
+	 * without the lock, the device could be unregistered and freed between
+	 * the devnode->registered check and get_device() calls, leading to
+	 * a crash.
+	 */
+	mutex_lock(&cec_devnode_lock);
+	/*
+	 * return ENXIO if the cec device has been removed
+	 * already or if it is not registered anymore.
+	 */
+	if (!devnode->registered) {
+		mutex_unlock(&cec_devnode_lock);
+		cec_queue_event_free(fh);
+		kfree(fh);
+		return -ENXIO;
+	}
+	/* and increase the device refcount */
+	get_device(&devnode->dev);
+	mutex_unlock(&cec_devnode_lock);
+
+	filp->private_data = fh;
+
+	mutex_lock(&devnode->fhs_lock);
+	/* Queue up initial state events */
+	ev_state.state_change.phys_addr = adap->phys_addr;
+	ev_state.state_change.log_addr_mask = adap->log_addrs.log_addr_mask;
+	cec_queue_event_fh(fh, &ev_state, 0);
+
+	list_add(&fh->list, &devnode->fhs);
+	mutex_unlock(&devnode->fhs_lock);
+
+	return 0;
+}
+
+/* Override for the release function */
+static int cec_release(struct inode *inode, struct file *filp)
+{
+	struct cec_devnode *devnode = cec_devnode_data(filp);
+	struct cec_adapter *adap = to_cec_adapter(devnode);
+	struct cec_fh *fh = filp->private_data;
+
+	mutex_lock(&adap->lock);
+	if (adap->cec_initiator == fh)
+		adap->cec_initiator = NULL;
+	if (adap->cec_follower == fh) {
+		adap->cec_follower = NULL;
+		adap->passthrough = false;
+	}
+	if (fh->mode_follower == CEC_MODE_FOLLOWER)
+		adap->follower_cnt--;
+	if (fh->mode_follower == CEC_MODE_MONITOR_ALL)
+		cec_monitor_all_cnt_dec(adap);
+	mutex_unlock(&adap->lock);
+
+	mutex_lock(&devnode->fhs_lock);
+	list_del(&fh->list);
+	mutex_unlock(&devnode->fhs_lock);
+
+	/* Unhook pending transmits from this filehandle. */
+	mutex_lock(&adap->lock);
+	while (!list_empty(&fh->xfer_list)) {
+		struct cec_data *data =
+			list_first_entry(&fh->xfer_list, struct cec_data, xfer_list);
+
+		data->blocking = false;
+		data->fh = NULL;
+		list_del(&data->xfer_list);
+	}
+	mutex_unlock(&adap->lock);
+	while (!list_empty(&fh->msgs)) {
+		struct cec_msg_entry *entry =
+			list_first_entry(&fh->msgs, struct cec_msg_entry, list);
+
+		list_del(&entry->list);
+		kfree(entry);
+	}
+	cec_queue_event_free(fh);
+	kfree(fh);
+
+	/*
+	 * decrease the refcount unconditionally since the release()
+	 * return value is ignored.
+	 */
+	put_device(&devnode->dev);
+	filp->private_data = NULL;
+	return 0;
+}
+
+static const struct file_operations cec_devnode_fops = {
+	.owner = THIS_MODULE,
+	.open = cec_open,
+	.unlocked_ioctl = cec_ioctl,
+	.release = cec_release,
+	.poll = cec_poll,
+	.llseek = no_llseek,
+};
+
+/* Called when the last user of the cec device exits. */
+static void cec_devnode_release(struct device *cd)
+{
+	struct cec_devnode *devnode = to_cec_devnode(cd);
+
+	mutex_lock(&cec_devnode_lock);
+
+	/* Mark device node number as free */
+	clear_bit(devnode->minor, cec_devnode_nums);
+
+	mutex_unlock(&cec_devnode_lock);
+	cec_delete_adapter(to_cec_adapter(devnode));
+}
+
+static struct bus_type cec_bus_type = {
+	.name = CEC_NAME,
+};
+
+/**
+ * cec_devnode_register - register a cec device node
+ * @devnode: cec device node structure we want to register
+ *
+ * The registration code assigns minor numbers and registers the new device node
+ * with the kernel. An error is returned if no free minor number can be found,
+ * or if the registration of the device node fails.
+ *
+ * Zero is returned on success.
+ *
+ * Note that if the cec_devnode_register call fails, the release() callback of
+ * the cec_devnode structure is *not* called, so the caller is responsible for
+ * freeing any data.
+ */
+static int __must_check cec_devnode_register(struct cec_devnode *devnode,
+					     struct module *owner)
+{
+	int minor;
+	int ret;
+
+	/* Initialization */
+	INIT_LIST_HEAD(&devnode->fhs);
+	mutex_init(&devnode->fhs_lock);
+
+	/* Part 1: Find a free minor number */
+	mutex_lock(&cec_devnode_lock);
+	minor = find_next_zero_bit(cec_devnode_nums, CEC_NUM_DEVICES, 0);
+	if (minor == CEC_NUM_DEVICES) {
+		mutex_unlock(&cec_devnode_lock);
+		pr_err("could not get a free minor\n");
+		return -ENFILE;
+	}
+
+	set_bit(minor, cec_devnode_nums);
+	mutex_unlock(&cec_devnode_lock);
+
+	devnode->minor = minor;
+	devnode->dev.bus = &cec_bus_type;
+	devnode->dev.devt = MKDEV(MAJOR(cec_dev_t), minor);
+	devnode->dev.release = cec_devnode_release;
+	devnode->dev.parent = devnode->parent;
+	dev_set_name(&devnode->dev, "cec%d", devnode->minor);
+	device_initialize(&devnode->dev);
+
+	/* Part 2: Initialize and register the character device */
+	cdev_init(&devnode->cdev, &cec_devnode_fops);
+	devnode->cdev.kobj.parent = &devnode->dev.kobj;
+	devnode->cdev.owner = owner;
+
+	ret = cdev_add(&devnode->cdev, devnode->dev.devt, 1);
+	if (ret < 0) {
+		pr_err("%s: cdev_add failed\n", __func__);
+		goto clr_bit;
+	}
+
+	ret = device_add(&devnode->dev);
+	if (ret)
+		goto cdev_del;
+
+	devnode->registered = true;
+	return 0;
+
+cdev_del:
+	cdev_del(&devnode->cdev);
+clr_bit:
+	clear_bit(devnode->minor, cec_devnode_nums);
+	put_device(&devnode->dev);
+	return ret;
+}
+
+/**
+ * cec_devnode_unregister - unregister a cec device node
+ * @devnode: the device node to unregister
+ *
+ * This unregisters the passed device. Future open calls will be met with
+ * errors.
+ *
+ * This function can safely be called if the device node has never been
+ * registered or has already been unregistered.
+ */
+static void cec_devnode_unregister(struct cec_devnode *devnode)
+{
+	struct cec_fh *fh;
+
+	/* Check if devnode was never registered or already unregistered */
+	if (!devnode->registered || devnode->unregistered)
+		return;
+
+	mutex_lock(&devnode->fhs_lock);
+	list_for_each_entry(fh, &devnode->fhs, list)
+		wake_up_interruptible(&fh->wait);
+	mutex_unlock(&devnode->fhs_lock);
+
+	devnode->registered = false;
+	devnode->unregistered = true;
+	device_del(&devnode->dev);
+	cdev_del(&devnode->cdev);
+	put_device(&devnode->dev);
+}
+
+struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
+					 void *priv, const char *name, u32 caps,
+					 u8 available_las, struct device *parent)
+{
+	struct cec_adapter *adap;
+	int res;
+
+	if (WARN_ON(!parent))
+		return ERR_PTR(-EINVAL);
+	if (WARN_ON(!caps))
+		return ERR_PTR(-EINVAL);
+	if (WARN_ON(!ops))
+		return ERR_PTR(-EINVAL);
+	if (WARN_ON(!available_las || available_las > CEC_MAX_LOG_ADDRS))
+		return ERR_PTR(-EINVAL);
+	adap = kzalloc(sizeof(*adap), GFP_KERNEL);
+	if (!adap)
+		return ERR_PTR(-ENOMEM);
+	adap->owner = parent->driver->owner;
+	adap->devnode.parent = parent;
+	strlcpy(adap->name, name, sizeof(adap->name));
+	adap->phys_addr = CEC_PHYS_ADDR_INVALID;
+	adap->log_addrs.cec_version = CEC_OP_CEC_VERSION_2_0;
+	adap->log_addrs.vendor_id = CEC_VENDOR_ID_NONE;
+	adap->capabilities = caps;
+	adap->available_log_addrs = available_las;
+	adap->sequence = 0;
+	adap->ops = ops;
+	adap->priv = priv;
+	memset(adap->phys_addrs, 0xff, sizeof(adap->phys_addrs));
+	mutex_init(&adap->lock);
+	INIT_LIST_HEAD(&adap->transmit_queue);
+	INIT_LIST_HEAD(&adap->wait_queue);
+	init_waitqueue_head(&adap->kthread_waitq);
+
+	adap->kthread = kthread_run(cec_thread_func, adap, "cec-%s", name);
+	if (IS_ERR(adap->kthread)) {
+		pr_err("cec-%s: kernel_thread() failed\n", name);
+		res = PTR_ERR(adap->kthread);
+		kfree(adap);
+		return ERR_PTR(res);
+	}
+
+	if (!(caps & CEC_CAP_RC))
+		return adap;
+
+#if IS_ENABLED(CONFIG_RC_CORE)
+	/* Prepare the RC input device */
+	adap->rc = rc_allocate_device();
+	if (!adap->rc) {
+		pr_err("cec-%s: failed to allocate memory for rc_dev\n",
+		       name);
+		kthread_stop(adap->kthread);
+		kfree(adap);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	snprintf(adap->input_name, sizeof(adap->input_name),
+		 "RC for %s", name);
+	snprintf(adap->input_phys, sizeof(adap->input_phys),
+		 "%s/input0", name);
+
+	adap->rc->input_name = adap->input_name;
+	adap->rc->input_phys = adap->input_phys;
+	adap->rc->input_id.bustype = BUS_CEC;
+	adap->rc->input_id.vendor = 0;
+	adap->rc->input_id.product = 0;
+	adap->rc->input_id.version = 1;
+	adap->rc->dev.parent = parent;
+	adap->rc->driver_type = RC_DRIVER_SCANCODE;
+	adap->rc->allowed_protocols = RC_BIT_CEC;
+	adap->rc->priv = adap;
+	adap->rc->map_name = RC_MAP_CEC;
+	adap->rc->timeout = MS_TO_NS(100);
+#else
+	adap->capabilities &= ~CEC_CAP_RC;
+#endif
+	return adap;
+}
+EXPORT_SYMBOL_GPL(cec_allocate_adapter);
+
+int cec_register_adapter(struct cec_adapter *adap)
+{
+	int res;
+
+	if (IS_ERR_OR_NULL(adap))
+		return 0;
+
+#if IS_ENABLED(CONFIG_RC_CORE)
+	if (adap->capabilities & CEC_CAP_RC) {
+		res = rc_register_device(adap->rc);
+
+		if (res) {
+			pr_err("cec-%s: failed to prepare input device\n",
+			       adap->name);
+			rc_free_device(adap->rc);
+			adap->rc = NULL;
+			return res;
+		}
+	}
+#endif
+
+	res = cec_devnode_register(&adap->devnode, adap->owner);
+#if IS_ENABLED(CONFIG_RC_CORE)
+	if (res) {
+		/* Note: rc_unregister also calls rc_free */
+		rc_unregister_device(adap->rc);
+		adap->rc = NULL;
+		return res;
+	}
+#endif
+
+	dev_set_drvdata(&adap->devnode.dev, adap);
+	if (!top_cec_dir)
+		return 0;
+
+	adap->cec_dir = debugfs_create_dir(dev_name(&adap->devnode.dev), top_cec_dir);
+	if (IS_ERR_OR_NULL(adap->cec_dir)) {
+		pr_warn("cec-%s: Failed to create debugfs dir\n", adap->name);
+		return 0;
+	}
+	adap->status_file = debugfs_create_devm_seqfile(&adap->devnode.dev,
+		"status", adap->cec_dir, cec_status);
+	if (IS_ERR_OR_NULL(adap->status_file)) {
+		pr_warn("cec-%s: Failed to create status file\n", adap->name);
+		debugfs_remove_recursive(adap->cec_dir);
+		adap->cec_dir = NULL;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cec_register_adapter);
+
+void cec_unregister_adapter(struct cec_adapter *adap)
+{
+	if (IS_ERR_OR_NULL(adap))
+		return;
+
+#if IS_ENABLED(CONFIG_RC_CORE)
+	/* Note: rc_unregister also calls rc_free */
+	rc_unregister_device(adap->rc);
+	adap->rc = NULL;
+#endif
+	debugfs_remove_recursive(adap->cec_dir);
+	cec_devnode_unregister(&adap->devnode);
+}
+EXPORT_SYMBOL_GPL(cec_unregister_adapter);
+
+void cec_delete_adapter(struct cec_adapter *adap)
+{
+	if (IS_ERR_OR_NULL(adap))
+		return;
+	mutex_lock(&adap->lock);
+	__cec_s_phys_addr(adap, CEC_PHYS_ADDR_INVALID, false);
+	mutex_unlock(&adap->lock);
+	kthread_stop(adap->kthread);
+	if (adap->kthread_config)
+		kthread_stop(adap->kthread_config);
+#if IS_ENABLED(CONFIG_RC_CORE)
+	if (adap->rc)
+		rc_free_device(adap->rc);
+#endif
+	kfree(adap);
+}
+EXPORT_SYMBOL_GPL(cec_delete_adapter);
+
+/*
+ *	Initialise cec for linux
+ */
+static int __init cec_devnode_init(void)
+{
+	int ret;
+
+	pr_info("Linux cec interface: v0.10\n");
+	ret = alloc_chrdev_region(&cec_dev_t, 0, CEC_NUM_DEVICES,
+				  CEC_NAME);
+	if (ret < 0) {
+		pr_warn("cec: unable to allocate major\n");
+		return ret;
+	}
+
+	top_cec_dir = debugfs_create_dir("cec", NULL);
+	if (IS_ERR_OR_NULL(top_cec_dir)) {
+		pr_warn("cec: Failed to create debugfs cec dir\n");
+		top_cec_dir = NULL;
+	}
+
+	ret = bus_register(&cec_bus_type);
+	if (ret < 0) {
+		unregister_chrdev_region(cec_dev_t, CEC_NUM_DEVICES);
+		pr_warn("cec: bus_register failed\n");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static void __exit cec_devnode_exit(void)
+{
+	debugfs_remove_recursive(top_cec_dir);
+	bus_unregister(&cec_bus_type);
+	unregister_chrdev_region(cec_dev_t, CEC_NUM_DEVICES);
+}
+
+subsys_initcall(cec_devnode_init);
+module_exit(cec_devnode_exit)
+
+MODULE_AUTHOR("Hans Verkuil <hans.verkuil@cisco.com>");
+MODULE_DESCRIPTION("Device node registration for cec drivers");
+MODULE_LICENSE("GPL");
diff --git a/include/media/cec.h b/include/media/cec.h
new file mode 100644
index 0000000..25d89b1
--- /dev/null
+++ b/include/media/cec.h
@@ -0,0 +1,236 @@
+/*
+ * cec - HDMI Consumer Electronics Control support header
+ *
+ * Copyright 2016 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#ifndef _MEDIA_CEC_H
+#define _MEDIA_CEC_H
+
+#include <linux/poll.h>
+#include <linux/fs.h>
+#include <linux/debugfs.h>
+#include <linux/device.h>
+#include <linux/cdev.h>
+#include <linux/kthread.h>
+#include <linux/timer.h>
+#include <linux/cec-funcs.h>
+#include <media/rc-core.h>
+#include <media/cec-edid.h>
+
+/**
+ * struct cec_devnode - cec device node
+ * @dev:	cec device
+ * @cdev:	cec character device
+ * @parent:	parent device
+ * @minor:	device node minor number
+ * @registered:	the device was correctly registered
+ * @unregistered: the device was unregistered
+ * @fhs_lock:	lock to control access to the filehandle list
+ * @fhs:	the list of open filehandles (cec_fh)
+ *
+ * This structure represents a cec-related device node.
+ *
+ * The @parent is a physical device. It must be set by core or device drivers
+ * before registering the node.
+ */
+struct cec_devnode {
+	/* sysfs */
+	struct device dev;
+	struct cdev cdev;
+	struct device *parent;
+
+	/* device info */
+	int minor;
+	bool registered;
+	bool unregistered;
+	struct mutex fhs_lock;
+	struct list_head fhs;
+};
+
+struct cec_adapter;
+struct cec_data;
+
+struct cec_data {
+	struct list_head list;
+	struct list_head xfer_list;
+	struct cec_adapter *adap;
+	struct cec_msg msg;
+	struct cec_fh *fh;
+	struct delayed_work work;
+	struct completion c;
+	u8 attempts;
+	bool new_initiator;
+	bool blocking;
+	bool completed;
+};
+
+struct cec_msg_entry {
+	struct list_head	list;
+	struct cec_msg		msg;
+};
+
+#define CEC_NUM_EVENTS		CEC_EVENT_LOST_MSGS
+
+struct cec_event_queue {
+	unsigned int		elems;
+	unsigned int		num_events;
+	struct cec_event	*events;
+};
+
+struct cec_fh {
+	struct list_head	list;
+	struct list_head	xfer_list;
+	struct cec_adapter	*adap;
+	u8			mode_initiator;
+	u8			mode_follower;
+
+	/* Events */
+	wait_queue_head_t	wait;
+	unsigned int		events;
+	struct cec_event_queue	evqueue[CEC_NUM_EVENTS];
+	struct mutex		lock;
+	struct list_head	msgs; /* queued messages */
+	unsigned int		queued_msgs;
+	unsigned int		lost_msgs;
+};
+
+#define CEC_SIGNAL_FREE_TIME_RETRY		3
+#define CEC_SIGNAL_FREE_TIME_NEW_INITIATOR	5
+#define CEC_SIGNAL_FREE_TIME_NEXT_XFER		7
+
+/* The nominal data bit period is 2.4 ms */
+#define CEC_FREE_TIME_TO_USEC(ft)		((ft) * 2400)
+
+struct cec_adap_ops {
+	/* Low-level callbacks */
+	int (*adap_enable)(struct cec_adapter *adap, bool enable);
+	int (*adap_monitor_all_enable)(struct cec_adapter *adap, bool enable);
+	int (*adap_log_addr)(struct cec_adapter *adap, u8 logical_addr);
+	int (*adap_transmit)(struct cec_adapter *adap, u8 attempts,
+			     u32 signal_free_time, struct cec_msg *msg);
+	void (*adap_status)(struct cec_adapter *adap, struct seq_file *file);
+
+	/* High-level CEC message callback */
+	int (*received)(struct cec_adapter *adap, struct cec_msg *msg);
+};
+
+/*
+ * The minimum message length you can receive (excepting poll messages) is 2.
+ * With a transfer rate of at most 36 bytes per second this makes 18 messages
+ * per second worst case.
+ *
+ * We queue at most 10 seconds worth of messages.
+ */
+#define CEC_MAX_MSG_QUEUE_SZ		(18 * 10)
+
+struct cec_adapter {
+	struct module *owner;
+	char name[32];
+	struct cec_devnode devnode;
+	struct mutex lock;
+	struct rc_dev *rc;
+
+	struct list_head transmit_queue;
+	struct list_head wait_queue;
+	struct cec_data *transmitting;
+
+	struct task_struct *kthread_config;
+	struct completion config_completion;
+
+	struct task_struct *kthread;
+	wait_queue_head_t kthread_waitq;
+	wait_queue_head_t waitq;
+
+	const struct cec_adap_ops *ops;
+	void *priv;
+	u32 capabilities;
+	u8 available_log_addrs;
+
+	u16 phys_addr;
+	bool is_configuring;
+	bool is_configured;
+	u32 monitor_all_cnt;
+	u32 follower_cnt;
+	struct cec_fh *cec_follower;
+	struct cec_fh *cec_initiator;
+	bool passthrough;
+	struct cec_log_addrs log_addrs;
+
+	struct dentry *cec_dir;
+	struct dentry *status_file;
+
+	u16 phys_addrs[15];
+	u32 sequence;
+
+	char input_name[32];
+	char input_phys[32];
+	char input_drv[32];
+};
+
+static inline bool cec_has_log_addr(const struct cec_adapter *adap, u8 log_addr)
+{
+	return adap->log_addrs.log_addr_mask & (1 << log_addr);
+}
+
+static inline bool cec_is_sink(const struct cec_adapter *adap)
+{
+	return adap->phys_addr == 0;
+}
+
+#if IS_ENABLED(CONFIG_MEDIA_CEC)
+struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
+		void *priv, const char *name, u32 caps, u8 available_las,
+		struct device *parent);
+int cec_register_adapter(struct cec_adapter *adap);
+void cec_unregister_adapter(struct cec_adapter *adap);
+void cec_delete_adapter(struct cec_adapter *adap);
+
+int cec_s_log_addrs(struct cec_adapter *adap, struct cec_log_addrs *log_addrs,
+		    bool block);
+void cec_s_phys_addr(struct cec_adapter *adap, u16 phys_addr,
+		     bool block);
+int cec_transmit_msg(struct cec_adapter *adap, struct cec_msg *msg,
+		     bool block);
+
+/* Called by the adapter */
+void cec_transmit_done(struct cec_adapter *adap, u8 status, u8 arb_lost_cnt,
+		       u8 nack_cnt, u8 low_drive_cnt, u8 error_cnt);
+void cec_received_msg(struct cec_adapter *adap, struct cec_msg *msg);
+
+#else
+
+static inline int cec_register_adapter(struct cec_adapter *adap)
+{
+	return 0;
+}
+
+static inline void cec_unregister_adapter(struct cec_adapter *adap)
+{
+}
+
+static inline void cec_delete_adapter(struct cec_adapter *adap)
+{
+}
+
+static inline void cec_s_phys_addr(struct cec_adapter *adap, u16 phys_addr,
+				   bool block)
+{
+}
+
+#endif
+
+#endif /* _MEDIA_CEC_H */
-- 
2.8.1

