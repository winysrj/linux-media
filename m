Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:34151 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755243AbdGKGav (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Jul 2017 02:30:51 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 06/11] cec: rework the cec event handling
Date: Tue, 11 Jul 2017 08:30:39 +0200
Message-Id: <20170711063044.29849-7-hverkuil@xs4all.nl>
In-Reply-To: <20170711063044.29849-1-hverkuil@xs4all.nl>
References: <20170711063044.29849-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Event handling was always fairly simplistic since there were only
two events. With the addition of pin events this needed to be redesigned.

The state_change and lost_msgs events are now core events with the
guarantee that the last state is always available. The new pin events
are a queue of events (up to 64 for each event) and the oldest event
will be dropped if the application cannot keep up. Lost events are
marked with a new event flag.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/cec/cec-adap.c | 128 +++++++++++++++++++++++++------------------
 drivers/media/cec/cec-api.c  |  48 +++++++++++-----
 include/media/cec.h          |  14 ++++-
 include/uapi/linux/cec.h     |   3 +-
 4 files changed, 124 insertions(+), 69 deletions(-)

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index b3163716d95f..67ec66c7c4ff 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -78,42 +78,62 @@ static unsigned int cec_log_addr2dev(const struct cec_adapter *adap, u8 log_addr
  * Queue a new event for this filehandle. If ts == 0, then set it
  * to the current time.
  *
- * The two events that are currently defined do not need to keep track
- * of intermediate events, so no actual queue of events is needed,
- * instead just store the latest state and the total number of lost
- * messages.
- *
- * Should new events be added in the future that require intermediate
- * results to be queued as well, then a proper queue data structure is
- * required. But until then, just keep it simple.
+ * We keep a queue of at most max_event events where max_event differs
+ * per event. If the queue becomes full, then drop the oldest event and
+ * keep track of how many events we've dropped.
  */
 void cec_queue_event_fh(struct cec_fh *fh,
 			const struct cec_event *new_ev, u64 ts)
 {
-	struct cec_event *ev = &fh->events[new_ev->event - 1];
+	static const u8 max_events[CEC_NUM_EVENTS] = {
+		1, 1, 64, 64,
+	};
+	struct cec_event_entry *entry;
+	unsigned int ev_idx = new_ev->event - 1;
+
+	if (WARN_ON(ev_idx >= ARRAY_SIZE(fh->events)))
+		return;
 
 	if (ts == 0)
 		ts = ktime_get_ns();
 
 	mutex_lock(&fh->lock);
-	if (new_ev->event == CEC_EVENT_LOST_MSGS &&
-	    fh->pending_events & (1 << new_ev->event)) {
-		/*
-		 * If there is already a lost_msgs event, then just
-		 * update the lost_msgs count. This effectively
-		 * merges the old and new events into one.
-		 */
-		ev->lost_msgs.lost_msgs += new_ev->lost_msgs.lost_msgs;
-		goto unlock;
-	}
+	if (ev_idx < CEC_NUM_CORE_EVENTS)
+		entry = &fh->core_events[ev_idx];
+	else
+		entry = kmalloc(sizeof(*entry), GFP_KERNEL);
+	if (entry) {
+		if (new_ev->event == CEC_EVENT_LOST_MSGS &&
+		    fh->queued_events[ev_idx]) {
+			entry->ev.lost_msgs.lost_msgs +=
+				new_ev->lost_msgs.lost_msgs;
+			goto unlock;
+		}
+		entry->ev = *new_ev;
+		entry->ev.ts = ts;
+
+		if (fh->queued_events[ev_idx] < max_events[ev_idx]) {
+			/* Add new msg at the end of the queue */
+			list_add_tail(&entry->list, &fh->events[ev_idx]);
+			fh->queued_events[ev_idx]++;
+			fh->total_queued_events++;
+			goto unlock;
+		}
 
-	/*
-	 * Intermediate states are not interesting, so just
-	 * overwrite any older event.
-	 */
-	*ev = *new_ev;
-	ev->ts = ts;
-	fh->pending_events |= 1 << new_ev->event;
+		if (ev_idx >= CEC_NUM_CORE_EVENTS) {
+			list_add_tail(&entry->list, &fh->events[ev_idx]);
+			/* drop the oldest event */
+			entry = list_first_entry(&fh->events[ev_idx],
+						 struct cec_event_entry, list);
+			list_del(&entry->list);
+			kfree(entry);
+		}
+	}
+	/* Mark that events were lost */
+	entry = list_first_entry_or_null(&fh->events[ev_idx],
+					 struct cec_event_entry, list);
+	if (entry)
+		entry->ev.flags |= CEC_EVENT_FL_DROPPED_EVENTS;
 
 unlock:
 	mutex_unlock(&fh->lock);
@@ -134,46 +154,50 @@ static void cec_queue_event(struct cec_adapter *adap,
 }
 
 /*
- * Queue a new message for this filehandle. If there is no more room
- * in the queue, then send the LOST_MSGS event instead.
+ * Queue a new message for this filehandle.
+ *
+ * We keep a queue of at most CEC_MAX_MSG_RX_QUEUE_SZ messages. If the
+ * queue becomes full, then drop the oldest message and keep track
+ * of how many messages we've dropped.
  */
 static void cec_queue_msg_fh(struct cec_fh *fh, const struct cec_msg *msg)
 {
-	static const struct cec_event ev_lost_msg = {
-		.ts = 0,
+	static const struct cec_event ev_lost_msgs = {
 		.event = CEC_EVENT_LOST_MSGS,
-		.flags = 0,
-		{
-			.lost_msgs.lost_msgs = 1,
-		},
+		.lost_msgs.lost_msgs = 1,
 	};
 	struct cec_msg_entry *entry;
 
 	mutex_lock(&fh->lock);
 	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
-	if (!entry)
-		goto lost_msgs;
-
-	entry->msg = *msg;
-	/* Add new msg at the end of the queue */
-	list_add_tail(&entry->list, &fh->msgs);
+	if (entry) {
+		entry->msg = *msg;
+		/* Add new msg at the end of the queue */
+		list_add_tail(&entry->list, &fh->msgs);
+
+		if (fh->queued_msgs < CEC_MAX_MSG_RX_QUEUE_SZ) {
+			/* All is fine if there is enough room */
+			fh->queued_msgs++;
+			mutex_unlock(&fh->lock);
+			wake_up_interruptible(&fh->wait);
+			return;
+		}
 
-	/*
-	 * if the queue now has more than CEC_MAX_MSG_RX_QUEUE_SZ
-	 * messages, drop the oldest one and send a lost message event.
-	 */
-	if (fh->queued_msgs == CEC_MAX_MSG_RX_QUEUE_SZ) {
+		/*
+		 * if the message queue is full, then drop the oldest one and
+		 * send a lost message event.
+		 */
+		entry = list_first_entry(&fh->msgs, struct cec_msg_entry, list);
 		list_del(&entry->list);
-		goto lost_msgs;
+		kfree(entry);
 	}
-	fh->queued_msgs++;
 	mutex_unlock(&fh->lock);
-	wake_up_interruptible(&fh->wait);
-	return;
 
-lost_msgs:
-	mutex_unlock(&fh->lock);
-	cec_queue_event_fh(fh, &ev_lost_msg, 0);
+	/*
+	 * We lost a message, either because kmalloc failed or the queue
+	 * was full.
+	 */
+	cec_queue_event_fh(fh, &ev_lost_msgs, ktime_get_ns());
 }
 
 /*
diff --git a/drivers/media/cec/cec-api.c b/drivers/media/cec/cec-api.c
index f7eb4c54a354..48bef1c718ad 100644
--- a/drivers/media/cec/cec-api.c
+++ b/drivers/media/cec/cec-api.c
@@ -57,7 +57,7 @@ static unsigned int cec_poll(struct file *filp,
 		res |= POLLOUT | POLLWRNORM;
 	if (fh->queued_msgs)
 		res |= POLLIN | POLLRDNORM;
-	if (fh->pending_events)
+	if (fh->total_queued_events)
 		res |= POLLPRI;
 	poll_wait(filp, &fh->wait, poll);
 	mutex_unlock(&adap->lock);
@@ -289,15 +289,17 @@ static long cec_receive(struct cec_adapter *adap, struct cec_fh *fh,
 static long cec_dqevent(struct cec_adapter *adap, struct cec_fh *fh,
 			bool block, struct cec_event __user *parg)
 {
-	struct cec_event *ev = NULL;
+	struct cec_event_entry *ev = NULL;
 	u64 ts = ~0ULL;
 	unsigned int i;
+	unsigned int ev_idx;
 	long err = 0;
 
 	mutex_lock(&fh->lock);
-	while (!fh->pending_events && block) {
+	while (!fh->total_queued_events && block) {
 		mutex_unlock(&fh->lock);
-		err = wait_event_interruptible(fh->wait, fh->pending_events);
+		err = wait_event_interruptible(fh->wait,
+					       fh->total_queued_events);
 		if (err)
 			return err;
 		mutex_lock(&fh->lock);
@@ -305,23 +307,29 @@ static long cec_dqevent(struct cec_adapter *adap, struct cec_fh *fh,
 
 	/* Find the oldest event */
 	for (i = 0; i < CEC_NUM_EVENTS; i++) {
-		if (fh->pending_events & (1 << (i + 1)) &&
-		    fh->events[i].ts <= ts) {
-			ev = &fh->events[i];
-			ts = ev->ts;
+		struct cec_event_entry *entry =
+			list_first_entry_or_null(&fh->events[i],
+						 struct cec_event_entry, list);
+
+		if (entry && entry->ev.ts <= ts) {
+			ev = entry;
+			ev_idx = i;
+			ts = ev->ev.ts;
 		}
 	}
+
 	if (!ev) {
 		err = -EAGAIN;
 		goto unlock;
 	}
+	list_del(&ev->list);
 
-	if (copy_to_user(parg, ev, sizeof(*ev))) {
+	if (copy_to_user(parg, &ev->ev, sizeof(ev->ev)))
 		err = -EFAULT;
-		goto unlock;
-	}
-
-	fh->pending_events &= ~(1 << ev->event);
+	if (ev_idx >= CEC_NUM_CORE_EVENTS)
+		kfree(ev);
+	fh->queued_events[ev_idx]--;
+	fh->total_queued_events--;
 
 unlock:
 	mutex_unlock(&fh->lock);
@@ -495,6 +503,7 @@ static int cec_open(struct inode *inode, struct file *filp)
 		.event = CEC_EVENT_STATE_CHANGE,
 		.flags = CEC_EVENT_FL_INITIAL_STATE,
 	};
+	unsigned int i;
 	int err;
 
 	if (!fh)
@@ -502,6 +511,8 @@ static int cec_open(struct inode *inode, struct file *filp)
 
 	INIT_LIST_HEAD(&fh->msgs);
 	INIT_LIST_HEAD(&fh->xfer_list);
+	for (i = 0; i < CEC_NUM_EVENTS; i++)
+		INIT_LIST_HEAD(&fh->events[i]);
 	mutex_init(&fh->lock);
 	init_waitqueue_head(&fh->wait);
 
@@ -544,6 +555,7 @@ static int cec_release(struct inode *inode, struct file *filp)
 	struct cec_devnode *devnode = cec_devnode_data(filp);
 	struct cec_adapter *adap = to_cec_adapter(devnode);
 	struct cec_fh *fh = filp->private_data;
+	unsigned int i;
 
 	mutex_lock(&adap->lock);
 	if (adap->cec_initiator == fh)
@@ -585,6 +597,16 @@ static int cec_release(struct inode *inode, struct file *filp)
 		list_del(&entry->list);
 		kfree(entry);
 	}
+	for (i = CEC_NUM_CORE_EVENTS; i < CEC_NUM_EVENTS; i++) {
+		while (!list_empty(&fh->events[i])) {
+			struct cec_event_entry *entry =
+				list_first_entry(&fh->events[i],
+						 struct cec_event_entry, list);
+
+			list_del(&entry->list);
+			kfree(entry);
+		}
+	}
 	kfree(fh);
 
 	cec_put_device(devnode);
diff --git a/include/media/cec.h b/include/media/cec.h
index 37768203572d..6cc862af74e5 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -81,7 +81,13 @@ struct cec_msg_entry {
 	struct cec_msg		msg;
 };
 
-#define CEC_NUM_EVENTS		CEC_EVENT_LOST_MSGS
+struct cec_event_entry {
+	struct list_head	list;
+	struct cec_event	ev;
+};
+
+#define CEC_NUM_CORE_EVENTS 2
+#define CEC_NUM_EVENTS CEC_EVENT_PIN_HIGH
 
 struct cec_fh {
 	struct list_head	list;
@@ -92,9 +98,11 @@ struct cec_fh {
 
 	/* Events */
 	wait_queue_head_t	wait;
-	unsigned int		pending_events;
-	struct cec_event	events[CEC_NUM_EVENTS];
 	struct mutex		lock;
+	struct list_head	events[CEC_NUM_EVENTS]; /* queued events */
+	u8			queued_events[CEC_NUM_EVENTS];
+	unsigned int		total_queued_events;
+	struct cec_event_entry	core_events[CEC_NUM_CORE_EVENTS];
 	struct list_head	msgs; /* queued messages */
 	unsigned int		queued_msgs;
 };
diff --git a/include/uapi/linux/cec.h b/include/uapi/linux/cec.h
index bba73f33c8aa..d87a67b0bb06 100644
--- a/include/uapi/linux/cec.h
+++ b/include/uapi/linux/cec.h
@@ -412,6 +412,7 @@ struct cec_log_addrs {
 #define CEC_EVENT_PIN_HIGH		4
 
 #define CEC_EVENT_FL_INITIAL_STATE	(1 << 0)
+#define CEC_EVENT_FL_DROPPED_EVENTS	(1 << 1)
 
 /**
  * struct cec_event_state_change - used when the CEC adapter changes state.
@@ -424,7 +425,7 @@ struct cec_event_state_change {
 };
 
 /**
- * struct cec_event_lost_msgs - tells you how many messages were lost due.
+ * struct cec_event_lost_msgs - tells you how many messages were lost.
  * @lost_msgs: how many messages were lost.
  */
 struct cec_event_lost_msgs {
-- 
2.11.0
