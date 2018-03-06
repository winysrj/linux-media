Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:45608 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753504AbeCFVfS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Mar 2018 16:35:18 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec: improve CEC pin event handling
Message-ID: <ae5fab30-b3e7-d384-317c-ca7f549f668b@xs4all.nl>
Date: Tue, 6 Mar 2018 22:35:15 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It turns out that the struct cec_fh event buffer size of 64 events
(64 for CEC_EVENT_PIN_CEC_LOW and 64 for _HIGH) is too small. It's
about 160 ms worth of events and if the Raspberry Pi is busy, then it
might take too long for the application to be scheduled so that it can
drain the pending events. Increase these buffers to 800 events which
is at least 2 seconds worth of events.

There is also a FIFO in between the interrupt and the cec-pin thread.
The thread passes the events on to the CEC core. It is important that
should this FIFO fill up the cec core will be informed that events
have been lost so this can be communicated to the user by setting
CEC_EVENT_FL_DROPPED_EVENTS.

It is very hard to debug CEC problems if events were lost without
informing the user of that fact.

If events were dropped due to the FIFO filling up, then the debugfs
status file will let you know how many events were dropped.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
Note: this patch sits on top of my earlier "[PATCHv2 0/7] cec: add error
injection support" patch series
---
 drivers/media/cec/cec-adap.c             |  8 +++++---
 drivers/media/cec/cec-pin-priv.h         | 10 +++++++---
 drivers/media/cec/cec-pin.c              | 30 ++++++++++++++++++++++--------
 drivers/media/platform/vivid/vivid-cec.c |  8 ++++----
 include/media/cec.h                      |  7 ++++---
 5 files changed, 42 insertions(+), 21 deletions(-)

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index cf6dc3f3a17e..002ed4c90371 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -73,8 +73,8 @@ static unsigned int cec_log_addr2dev(const struct cec_adapter *adap, u8 log_addr
 void cec_queue_event_fh(struct cec_fh *fh,
 			const struct cec_event *new_ev, u64 ts)
 {
-	static const u8 max_events[CEC_NUM_EVENTS] = {
-		1, 1, 64, 64, 8, 8,
+	static const u16 max_events[CEC_NUM_EVENTS] = {
+		1, 1, 800, 800, 8, 8,
 	};
 	struct cec_event_entry *entry;
 	unsigned int ev_idx = new_ev->event - 1;
@@ -142,11 +142,13 @@ static void cec_queue_event(struct cec_adapter *adap,
 }

 /* Notify userspace that the CEC pin changed state at the given time. */
-void cec_queue_pin_cec_event(struct cec_adapter *adap, bool is_high, ktime_t ts)
+void cec_queue_pin_cec_event(struct cec_adapter *adap, bool is_high,
+			     bool dropped_events, ktime_t ts)
 {
 	struct cec_event ev = {
 		.event = is_high ? CEC_EVENT_PIN_CEC_HIGH :
 				   CEC_EVENT_PIN_CEC_LOW,
+		.flags = dropped_events ? CEC_EVENT_FL_DROPPED_EVENTS : 0,
 	};
 	struct cec_fh *fh;

diff --git a/drivers/media/cec/cec-pin-priv.h b/drivers/media/cec/cec-pin-priv.h
index dae8ba6f1037..f423db8855d9 100644
--- a/drivers/media/cec/cec-pin-priv.h
+++ b/drivers/media/cec/cec-pin-priv.h
@@ -153,7 +153,9 @@ enum cec_pin_state {
 /* The default for the low/high time of the custom pulse */
 #define CEC_TIM_CUSTOM_DEFAULT				1000

-#define CEC_NUM_PIN_EVENTS 128
+#define CEC_NUM_PIN_EVENTS				128
+#define CEC_PIN_EVENT_FL_IS_HIGH			(1 << 0)
+#define CEC_PIN_EVENT_FL_DROPPED			(1 << 1)

 #define CEC_PIN_IRQ_UNCHANGED	0
 #define CEC_PIN_IRQ_DISABLE	1
@@ -198,11 +200,13 @@ struct cec_pin {
 	u8				work_tx_status;
 	ktime_t				work_tx_ts;
 	atomic_t			work_irq_change;
-	atomic_t			work_pin_events;
+	atomic_t			work_pin_num_events;
 	unsigned int			work_pin_events_wr;
 	unsigned int			work_pin_events_rd;
 	ktime_t				work_pin_ts[CEC_NUM_PIN_EVENTS];
-	bool				work_pin_is_high[CEC_NUM_PIN_EVENTS];
+	u8				work_pin_events[CEC_NUM_PIN_EVENTS];
+	bool				work_pin_events_dropped;
+	u32				work_pin_events_dropped_cnt;
 	ktime_t				timer_ts;
 	u32				timer_cnt;
 	u32				timer_100ms_overruns;
diff --git a/drivers/media/cec/cec-pin.c b/drivers/media/cec/cec-pin.c
index b509df154ca1..64e17f1b6fd3 100644
--- a/drivers/media/cec/cec-pin.c
+++ b/drivers/media/cec/cec-pin.c
@@ -114,12 +114,21 @@ static void cec_pin_update(struct cec_pin *pin, bool v, bool force)
 		return;

 	pin->adap->cec_pin_is_high = v;
-	if (atomic_read(&pin->work_pin_events) < CEC_NUM_PIN_EVENTS) {
-		pin->work_pin_is_high[pin->work_pin_events_wr] = v;
+	if (atomic_read(&pin->work_pin_num_events) < CEC_NUM_PIN_EVENTS) {
+		u8 ev = v;
+
+		if (pin->work_pin_events_dropped) {
+			pin->work_pin_events_dropped = false;
+			v |= CEC_PIN_EVENT_FL_DROPPED;
+		}
+		pin->work_pin_events[pin->work_pin_events_wr] = ev;
 		pin->work_pin_ts[pin->work_pin_events_wr] = ktime_get();
 		pin->work_pin_events_wr =
 			(pin->work_pin_events_wr + 1) % CEC_NUM_PIN_EVENTS;
-		atomic_inc(&pin->work_pin_events);
+		atomic_inc(&pin->work_pin_num_events);
+	} else {
+		pin->work_pin_events_dropped = true;
+		pin->work_pin_events_dropped_cnt++;
 	}
 	wake_up_interruptible(&pin->kthread_waitq);
 }
@@ -1013,7 +1022,7 @@ static int cec_pin_thread_func(void *_adap)
 			pin->work_rx_msg.len ||
 			pin->work_tx_status ||
 			atomic_read(&pin->work_irq_change) ||
-			atomic_read(&pin->work_pin_events));
+			atomic_read(&pin->work_pin_num_events));

 		if (pin->work_rx_msg.len) {
 			struct cec_msg *msg = &pin->work_rx_msg;
@@ -1041,14 +1050,16 @@ static int cec_pin_thread_func(void *_adap)
 						     pin->work_tx_ts);
 		}

-		while (atomic_read(&pin->work_pin_events)) {
+		while (atomic_read(&pin->work_pin_num_events)) {
 			unsigned int idx = pin->work_pin_events_rd;
+			u8 v = pin->work_pin_events[idx];

 			cec_queue_pin_cec_event(adap,
-						pin->work_pin_is_high[idx],
+						v & CEC_PIN_EVENT_FL_IS_HIGH,
+						v & CEC_PIN_EVENT_FL_DROPPED,
 						pin->work_pin_ts[idx]);
 			pin->work_pin_events_rd = (idx + 1) % CEC_NUM_PIN_EVENTS;
-			atomic_dec(&pin->work_pin_events);
+			atomic_dec(&pin->work_pin_num_events);
 		}

 		switch (atomic_xchg(&pin->work_irq_change,
@@ -1084,8 +1095,9 @@ static int cec_pin_adap_enable(struct cec_adapter *adap, bool enable)

 	pin->enabled = enable;
 	if (enable) {
-		atomic_set(&pin->work_pin_events, 0);
+		atomic_set(&pin->work_pin_num_events, 0);
 		pin->work_pin_events_rd = pin->work_pin_events_wr = 0;
+		pin->work_pin_events_dropped = false;
 		cec_pin_read(pin);
 		cec_pin_to_idle(pin);
 		pin->tx_msg.len = 0;
@@ -1165,6 +1177,7 @@ static void cec_pin_adap_status(struct cec_adapter *adap,
 	seq_printf(file, "tx_bit: %d\n", pin->tx_bit);
 	seq_printf(file, "rx_bit: %d\n", pin->rx_bit);
 	seq_printf(file, "cec pin: %d\n", pin->ops->read(adap));
+	seq_printf(file, "cec pin events dropped: %u\n", pin->work_pin_events_dropped_cnt);
 	seq_printf(file, "irq failed: %d\n", pin->enable_irq_failed);
 	if (pin->timer_100ms_overruns) {
 		seq_printf(file, "timer overruns > 100ms: %u of %u\n",
@@ -1202,6 +1215,7 @@ static void cec_pin_adap_status(struct cec_adapter *adap,
 			   pin->rx_data_bit_too_long_cnt);
 	seq_printf(file, "rx initiated low drive: %u\n", pin->rx_low_drive_cnt);
 	seq_printf(file, "tx detected low drive: %u\n", pin->tx_low_drive_cnt);
+	pin->work_pin_events_dropped_cnt = 0;
 	pin->timer_cnt = 0;
 	pin->timer_100ms_overruns = 0;
 	pin->timer_300ms_overruns = 0;
diff --git a/drivers/media/platform/vivid/vivid-cec.c b/drivers/media/platform/vivid/vivid-cec.c
index c2c889d6dcf5..71105fa4c5f9 100644
--- a/drivers/media/platform/vivid/vivid-cec.c
+++ b/drivers/media/platform/vivid/vivid-cec.c
@@ -79,9 +79,9 @@ static void vivid_cec_pin_adap_events(struct cec_adapter *adap, ktime_t ts,
 	 */
 	ts = ktime_sub_us(ts, CEC_TIM_START_BIT_TOTAL +
 			       10ULL * len * CEC_TIM_DATA_BIT_TOTAL);
-	cec_queue_pin_cec_event(adap, false, ts);
+	cec_queue_pin_cec_event(adap, false, false, ts);
 	ts = ktime_add_us(ts, CEC_TIM_START_BIT_LOW);
-	cec_queue_pin_cec_event(adap, true, ts);
+	cec_queue_pin_cec_event(adap, true, false, ts);
 	ts = ktime_add_us(ts, CEC_TIM_START_BIT_HIGH);

 	for (i = 0; i < 10 * len; i++) {
@@ -96,12 +96,12 @@ static void vivid_cec_pin_adap_events(struct cec_adapter *adap, ktime_t ts,
 			bit = cec_msg_is_broadcast(msg) ^ nacked;
 			break;
 		}
-		cec_queue_pin_cec_event(adap, false, ts);
+		cec_queue_pin_cec_event(adap, false, false, ts);
 		if (bit)
 			ts = ktime_add_us(ts, CEC_TIM_DATA_BIT_1_LOW);
 		else
 			ts = ktime_add_us(ts, CEC_TIM_DATA_BIT_0_LOW);
-		cec_queue_pin_cec_event(adap, true, ts);
+		cec_queue_pin_cec_event(adap, true, false, ts);
 		if (bit)
 			ts = ktime_add_us(ts, CEC_TIM_DATA_BIT_1_HIGH);
 		else
diff --git a/include/media/cec.h b/include/media/cec.h
index 41df048efc55..580ab1042898 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -92,7 +92,7 @@ struct cec_fh {
 	wait_queue_head_t	wait;
 	struct mutex		lock;
 	struct list_head	events[CEC_NUM_EVENTS]; /* queued events */
-	u8			queued_events[CEC_NUM_EVENTS];
+	u16			queued_events[CEC_NUM_EVENTS];
 	unsigned int		total_queued_events;
 	struct cec_event_entry	core_events[CEC_NUM_CORE_EVENTS];
 	struct list_head	msgs; /* queued messages */
@@ -291,11 +291,12 @@ static inline void cec_received_msg(struct cec_adapter *adap,
  *
  * @adap:	pointer to the cec adapter
  * @is_high:	when true the CEC pin is high, otherwise it is low
+ * @dropped_events: when true some events were dropped
  * @ts:		the timestamp for this event
  *
  */
-void cec_queue_pin_cec_event(struct cec_adapter *adap,
-			     bool is_high, ktime_t ts);
+void cec_queue_pin_cec_event(struct cec_adapter *adap, bool is_high,
+			     bool dropped_events, ktime_t ts);

 /**
  * cec_queue_pin_hpd_event() - queue a pin event with a given timestamp.
-- 
2.16.1
