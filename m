Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:38679 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750895AbdHaLB7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 07:01:59 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv4 1/5] cec: add CEC_EVENT_PIN_HPD_LOW/HIGH events
Date: Thu, 31 Aug 2017 13:01:52 +0200
Message-Id: <20170831110156.11018-2-hverkuil@xs4all.nl>
In-Reply-To: <20170831110156.11018-1-hverkuil@xs4all.nl>
References: <20170831110156.11018-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add support for two new low-level events: PIN_HPD_LOW and PIN_HPD_HIGH.

This is specifically meant for use with the upcoming cec-gpio driver
and makes it possible to trace when the HPD pin changes. Some HDMI
sinks do strange things with the HPD and this makes it easy to debug
this.

Note that this also moves the initialization of a devnode mutex and
list to the allocate_adapter function: if the HPD is high, then as
soon as the HPD interrupt is created an interrupt occurs and
cec_queue_pin_hpd_event() is called which requires that the devnode
mutex and list are initialized.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/cec/cec-adap.c | 18 +++++++++++++++++-
 drivers/media/cec/cec-api.c  | 18 ++++++++++++++----
 drivers/media/cec/cec-core.c |  8 ++++----
 include/media/cec-pin.h      |  4 ++++
 include/media/cec.h          | 12 +++++++++++-
 include/uapi/linux/cec.h     |  2 ++
 6 files changed, 52 insertions(+), 10 deletions(-)

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index dd769e40416f..eb904a71609a 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -86,7 +86,7 @@ void cec_queue_event_fh(struct cec_fh *fh,
 			const struct cec_event *new_ev, u64 ts)
 {
 	static const u8 max_events[CEC_NUM_EVENTS] = {
-		1, 1, 64, 64,
+		1, 1, 64, 64, 8, 8,
 	};
 	struct cec_event_entry *entry;
 	unsigned int ev_idx = new_ev->event - 1;
@@ -170,6 +170,22 @@ void cec_queue_pin_cec_event(struct cec_adapter *adap, bool is_high, ktime_t ts)
 }
 EXPORT_SYMBOL_GPL(cec_queue_pin_cec_event);
 
+/* Notify userspace that the HPD pin changed state at the given time. */
+void cec_queue_pin_hpd_event(struct cec_adapter *adap, bool is_high, ktime_t ts)
+{
+	struct cec_event ev = {
+		.event = is_high ? CEC_EVENT_PIN_HPD_HIGH :
+				   CEC_EVENT_PIN_HPD_LOW,
+	};
+	struct cec_fh *fh;
+
+	mutex_lock(&adap->devnode.lock);
+	list_for_each_entry(fh, &adap->devnode.fhs, list)
+		cec_queue_event_fh(fh, &ev, ktime_to_ns(ts));
+	mutex_unlock(&adap->devnode.lock);
+}
+EXPORT_SYMBOL_GPL(cec_queue_pin_hpd_event);
+
 /*
  * Queue a new message for this filehandle.
  *
diff --git a/drivers/media/cec/cec-api.c b/drivers/media/cec/cec-api.c
index a079f7fe018c..465bb3ec21f6 100644
--- a/drivers/media/cec/cec-api.c
+++ b/drivers/media/cec/cec-api.c
@@ -529,7 +529,7 @@ static int cec_open(struct inode *inode, struct file *filp)
 	 * Initial events that are automatically sent when the cec device is
 	 * opened.
 	 */
-	struct cec_event ev_state = {
+	struct cec_event ev = {
 		.event = CEC_EVENT_STATE_CHANGE,
 		.flags = CEC_EVENT_FL_INITIAL_STATE,
 	};
@@ -569,9 +569,19 @@ static int cec_open(struct inode *inode, struct file *filp)
 	filp->private_data = fh;
 
 	/* Queue up initial state events */
-	ev_state.state_change.phys_addr = adap->phys_addr;
-	ev_state.state_change.log_addr_mask = adap->log_addrs.log_addr_mask;
-	cec_queue_event_fh(fh, &ev_state, 0);
+	ev.state_change.phys_addr = adap->phys_addr;
+	ev.state_change.log_addr_mask = adap->log_addrs.log_addr_mask;
+	cec_queue_event_fh(fh, &ev, 0);
+#ifdef CONFIG_CEC_PIN
+	if (adap->pin && adap->pin->ops->read_hpd) {
+		err = adap->pin->ops->read_hpd(adap);
+		if (err >= 0) {
+			ev.event = err ? CEC_EVENT_PIN_HPD_HIGH :
+					 CEC_EVENT_PIN_HPD_LOW;
+			cec_queue_event_fh(fh, &ev, 0);
+		}
+	}
+#endif
 
 	list_add(&fh->list, &devnode->fhs);
 	mutex_unlock(&devnode->lock);
diff --git a/drivers/media/cec/cec-core.c b/drivers/media/cec/cec-core.c
index 648136e552d5..e3a1fb6d6690 100644
--- a/drivers/media/cec/cec-core.c
+++ b/drivers/media/cec/cec-core.c
@@ -112,10 +112,6 @@ static int __must_check cec_devnode_register(struct cec_devnode *devnode,
 	int minor;
 	int ret;
 
-	/* Initialization */
-	INIT_LIST_HEAD(&devnode->fhs);
-	mutex_init(&devnode->lock);
-
 	/* Part 1: Find a free minor number */
 	mutex_lock(&cec_devnode_lock);
 	minor = find_next_zero_bit(cec_devnode_nums, CEC_NUM_DEVICES, 0);
@@ -242,6 +238,10 @@ struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
 	INIT_LIST_HEAD(&adap->wait_queue);
 	init_waitqueue_head(&adap->kthread_waitq);
 
+	/* adap->devnode initialization */
+	INIT_LIST_HEAD(&adap->devnode.fhs);
+	mutex_init(&adap->devnode.lock);
+
 	adap->kthread = kthread_run(cec_thread_func, adap, "cec-%s", name);
 	if (IS_ERR(adap->kthread)) {
 		pr_err("cec-%s: kernel_thread() failed\n", name);
diff --git a/include/media/cec-pin.h b/include/media/cec-pin.h
index f09cc9579d53..ea84b9c9e0c3 100644
--- a/include/media/cec-pin.h
+++ b/include/media/cec-pin.h
@@ -97,6 +97,9 @@ enum cec_pin_state {
  * @free:	optional. Free any allocated resources. Called when the
  *		adapter is deleted.
  * @status:	optional, log status information.
+ * @read_hpd:	read the HPD pin. Return true if high, false if low or
+ *		an error if negative. If NULL or -ENOTTY is returned,
+ *		then this is not supported.
  *
  * These operations are used by the cec pin framework to manipulate
  * the CEC pin.
@@ -109,6 +112,7 @@ struct cec_pin_ops {
 	void (*disable_irq)(struct cec_adapter *adap);
 	void (*free)(struct cec_adapter *adap);
 	void (*status)(struct cec_adapter *adap, struct seq_file *file);
+	int  (*read_hpd)(struct cec_adapter *adap);
 };
 
 #define CEC_NUM_PIN_EVENTS 128
diff --git a/include/media/cec.h b/include/media/cec.h
index df6b3bd31284..9d0f983faea9 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -91,7 +91,7 @@ struct cec_event_entry {
 };
 
 #define CEC_NUM_CORE_EVENTS 2
-#define CEC_NUM_EVENTS CEC_EVENT_PIN_CEC_HIGH
+#define CEC_NUM_EVENTS CEC_EVENT_PIN_HPD_HIGH
 
 struct cec_fh {
 	struct list_head	list;
@@ -296,6 +296,16 @@ static inline void cec_received_msg(struct cec_adapter *adap,
 void cec_queue_pin_cec_event(struct cec_adapter *adap,
 			     bool is_high, ktime_t ts);
 
+/**
+ * cec_queue_pin_hpd_event() - queue a pin event with a given timestamp.
+ *
+ * @adap:	pointer to the cec adapter
+ * @is_high:	when true the HPD pin is high, otherwise it is low
+ * @ts:		the timestamp for this event
+ *
+ */
+void cec_queue_pin_hpd_event(struct cec_adapter *adap, bool is_high, ktime_t ts);
+
 /**
  * cec_get_edid_phys_addr() - find and return the physical address
  *
diff --git a/include/uapi/linux/cec.h b/include/uapi/linux/cec.h
index 4351c3481aea..b9f8df3a0477 100644
--- a/include/uapi/linux/cec.h
+++ b/include/uapi/linux/cec.h
@@ -410,6 +410,8 @@ struct cec_log_addrs {
 #define CEC_EVENT_LOST_MSGS		2
 #define CEC_EVENT_PIN_CEC_LOW		3
 #define CEC_EVENT_PIN_CEC_HIGH		4
+#define CEC_EVENT_PIN_HPD_LOW		5
+#define CEC_EVENT_PIN_HPD_HIGH		6
 
 #define CEC_EVENT_FL_INITIAL_STATE	(1 << 0)
 #define CEC_EVENT_FL_DROPPED_EVENTS	(1 << 1)
-- 
2.14.1
