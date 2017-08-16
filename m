Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:35968 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751224AbdHPHNG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Aug 2017 03:13:06 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec-pin: fix irq handling
Message-ID: <bcb633ee-4149-0903-ed47-76a88ff61a51@xs4all.nl>
Date: Wed, 16 Aug 2017 09:13:02 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The free_irq() function could be called from interrupt context,
which is invalid. Move this to the thread.

In the interrupt handler we just request that the thread disables
the irq. This is done through an atomic so we don't need to add
any spinlocks.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/cec/cec-pin.c | 34 +++++++++++++++++++++-------------
 include/media/cec-pin.h     |  6 +++++-
 2 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/drivers/media/cec/cec-pin.c b/drivers/media/cec/cec-pin.c
index 03f800e5ec1f..c2454495d562 100644
--- a/drivers/media/cec/cec-pin.c
+++ b/drivers/media/cec/cec-pin.c
@@ -557,7 +557,7 @@ static enum hrtimer_restart cec_pin_timer(struct hrtimer *timer)
 		    adap->is_configured || adap->monitor_all_cnt)
 			break;
 		/* Switch to interrupt mode */
-		pin->work_enable_irq = true;
+		atomic_set(&pin->work_irq_change, CEC_PIN_IRQ_ENABLE);
 		pin->state = CEC_ST_RX_IRQ;
 		wake_up_interruptible(&pin->kthread_waitq);
 		return HRTIMER_NORESTART;
@@ -591,7 +591,7 @@ static int cec_pin_thread_func(void *_adap)
 			kthread_should_stop() ||
 			pin->work_rx_msg.len ||
 			pin->work_tx_status ||
-			pin->work_enable_irq ||
+			atomic_read(&pin->work_irq_change) ||
 			atomic_read(&pin->work_pin_events));

 		if (pin->work_rx_msg.len) {
@@ -606,6 +606,7 @@ static int cec_pin_thread_func(void *_adap)
 			cec_transmit_attempt_done_ts(adap, tx_status,
 						     pin->work_tx_ts);
 		}
+
 		while (atomic_read(&pin->work_pin_events)) {
 			unsigned int idx = pin->work_pin_events_rd;

@@ -614,14 +615,26 @@ static int cec_pin_thread_func(void *_adap)
 			pin->work_pin_events_rd = (idx + 1) % CEC_NUM_PIN_EVENTS;
 			atomic_dec(&pin->work_pin_events);
 		}
-		if (pin->work_enable_irq) {
-			pin->work_enable_irq = false;
+
+		switch (atomic_xchg(&pin->work_irq_change,
+				    CEC_PIN_IRQ_UNCHANGED)) {
+		case CEC_PIN_IRQ_DISABLE:
+			pin->ops->disable_irq(adap);
+			cec_pin_high(pin);
+			cec_pin_to_idle(pin);
+			hrtimer_start(&pin->timer, 0, HRTIMER_MODE_REL);
+			break;
+		case CEC_PIN_IRQ_ENABLE:
 			pin->enable_irq_failed = !pin->ops->enable_irq(adap);
 			if (pin->enable_irq_failed) {
 				cec_pin_to_idle(pin);
 				hrtimer_start(&pin->timer, 0, HRTIMER_MODE_REL);
 			}
+			break;
+		default:
+			break;
 		}
+
 		if (kthread_should_stop())
 			break;
 	}
@@ -640,7 +653,7 @@ static int cec_pin_adap_enable(struct cec_adapter *adap, bool enable)
 		cec_pin_to_idle(pin);
 		pin->tx_msg.len = 0;
 		pin->timer_ts = 0;
-		pin->work_enable_irq = false;
+		atomic_set(&pin->work_irq_change, CEC_PIN_IRQ_UNCHANGED);
 		pin->kthread = kthread_run(cec_pin_thread_func, adap,
 					   "cec-pin");
 		if (IS_ERR(pin->kthread)) {
@@ -681,7 +694,7 @@ static int cec_pin_adap_transmit(struct cec_adapter *adap, u8 attempts,
 	pin->work_tx_status = 0;
 	pin->tx_bit = 0;
 	if (pin->state == CEC_ST_RX_IRQ) {
-		pin->work_enable_irq = false;
+		atomic_set(&pin->work_irq_change, CEC_PIN_IRQ_UNCHANGED);
 		pin->ops->disable_irq(adap);
 		cec_pin_high(pin);
 		cec_pin_to_idle(pin);
@@ -744,13 +757,8 @@ void cec_pin_changed(struct cec_adapter *adap, bool value)

 	cec_pin_update(pin, value, false);
 	if (!value && (adap->is_configuring || adap->is_configured ||
-		       adap->monitor_all_cnt)) {
-		pin->work_enable_irq = false;
-		pin->ops->disable_irq(adap);
-		cec_pin_high(pin);
-		cec_pin_to_idle(pin);
-		hrtimer_start(&pin->timer, 0, HRTIMER_MODE_REL);
-	}
+		       adap->monitor_all_cnt))
+		atomic_set(&pin->work_irq_change, CEC_PIN_IRQ_DISABLE);
 }
 EXPORT_SYMBOL_GPL(cec_pin_changed);

diff --git a/include/media/cec-pin.h b/include/media/cec-pin.h
index 44b82d29d480..d28d07fa312e 100644
--- a/include/media/cec-pin.h
+++ b/include/media/cec-pin.h
@@ -113,6 +113,10 @@ struct cec_pin_ops {

 #define CEC_NUM_PIN_EVENTS 128

+#define CEC_PIN_IRQ_UNCHANGED	0
+#define CEC_PIN_IRQ_DISABLE	1
+#define CEC_PIN_IRQ_ENABLE	2
+
 struct cec_pin {
 	struct cec_adapter		*adap;
 	const struct cec_pin_ops	*ops;
@@ -137,8 +141,8 @@ struct cec_pin {

 	struct cec_msg			work_rx_msg;
 	u8				work_tx_status;
-	bool				work_enable_irq;
 	ktime_t				work_tx_ts;
+	atomic_t			work_irq_change;
 	atomic_t			work_pin_events;
 	unsigned int			work_pin_events_wr;
 	unsigned int			work_pin_events_rd;
-- 
2.13.2
