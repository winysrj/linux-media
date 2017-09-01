Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:55199 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751425AbdIAIh5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Sep 2017 04:37:57 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec-pin.c: use proper ktime accessor functions
Message-ID: <ff7319d9-871e-7ef9-5fb7-fa0d7ee6209b@xs4all.nl>
Date: Fri, 1 Sep 2017 10:37:54 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use ktime_to_ns/ns_to_ktime. This makes it possible to work with older kernels
and the media_build compatibility system.

For the mainline kernel these functions are NOPs.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/cec/cec-pin.c | 37 ++++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 15 deletions(-)

diff --git a/drivers/media/cec/cec-pin.c b/drivers/media/cec/cec-pin.c
index c003b8eac617..e2aa5d6e619d 100644
--- a/drivers/media/cec/cec-pin.c
+++ b/drivers/media/cec/cec-pin.c
@@ -132,7 +132,7 @@ static void cec_pin_to_idle(struct cec_pin *pin)
 	pin->rx_msg.len = 0;
 	memset(pin->rx_msg.msg, 0, sizeof(pin->rx_msg.msg));
 	pin->state = CEC_ST_IDLE;
-	pin->ts = 0;
+	pin->ts = ns_to_ktime(0);
 }

 /*
@@ -426,7 +426,7 @@ static void cec_pin_rx_states(struct cec_pin *pin, ktime_t ts)
 		v = cec_pin_read(pin);
 		if (v && pin->rx_eom) {
 			pin->work_rx_msg = pin->rx_msg;
-			pin->work_rx_msg.rx_ts = ts;
+			pin->work_rx_msg.rx_ts = ktime_to_ns(ts);
 			wake_up_interruptible(&pin->kthread_waitq);
 			pin->ts = ts;
 			pin->state = CEC_ST_RX_ACK_FINISH;
@@ -457,7 +457,7 @@ static enum hrtimer_restart cec_pin_timer(struct hrtimer *timer)
 	s32 delta;

 	ts = ktime_get();
-	if (pin->timer_ts) {
+	if (ktime_to_ns(pin->timer_ts)) {
 		delta = ktime_us_delta(ts, pin->timer_ts);
 		pin->timer_cnt++;
 		if (delta > 100 && pin->state != CEC_ST_IDLE) {
@@ -481,17 +481,19 @@ static enum hrtimer_restart cec_pin_timer(struct hrtimer *timer)
 		if (pin->wait_usecs > 150) {
 			pin->wait_usecs -= 100;
 			pin->timer_ts = ktime_add_us(ts, 100);
-			hrtimer_forward_now(timer, 100000);
+			hrtimer_forward_now(timer, ns_to_ktime(100000));
 			return HRTIMER_RESTART;
 		}
 		if (pin->wait_usecs > 100) {
 			pin->wait_usecs /= 2;
 			pin->timer_ts = ktime_add_us(ts, pin->wait_usecs);
-			hrtimer_forward_now(timer, pin->wait_usecs * 1000);
+			hrtimer_forward_now(timer,
+					ns_to_ktime(pin->wait_usecs * 1000));
 			return HRTIMER_RESTART;
 		}
 		pin->timer_ts = ktime_add_us(ts, pin->wait_usecs);
-		hrtimer_forward_now(timer, pin->wait_usecs * 1000);
+		hrtimer_forward_now(timer,
+				    ns_to_ktime(pin->wait_usecs * 1000));
 		pin->wait_usecs = 0;
 		return HRTIMER_RESTART;
 	}
@@ -531,7 +533,7 @@ static enum hrtimer_restart cec_pin_timer(struct hrtimer *timer)
 			pin->state = CEC_ST_RX_START_BIT_LOW;
 			break;
 		}
-		if (pin->ts == 0)
+		if (ktime_to_ns(pin->ts) == 0)
 			pin->ts = ts;
 		if (pin->tx_msg.len) {
 			/*
@@ -572,12 +574,13 @@ static enum hrtimer_restart cec_pin_timer(struct hrtimer *timer)
 	if (!adap->monitor_pin_cnt || states[pin->state].usecs <= 150) {
 		pin->wait_usecs = 0;
 		pin->timer_ts = ktime_add_us(ts, states[pin->state].usecs);
-		hrtimer_forward_now(timer, states[pin->state].usecs * 1000);
+		hrtimer_forward_now(timer,
+				ns_to_ktime(states[pin->state].usecs * 1000));
 		return HRTIMER_RESTART;
 	}
 	pin->wait_usecs = states[pin->state].usecs - 100;
 	pin->timer_ts = ktime_add_us(ts, 100);
-	hrtimer_forward_now(timer, 100000);
+	hrtimer_forward_now(timer, ns_to_ktime(100000));
 	return HRTIMER_RESTART;
 }

@@ -596,7 +599,7 @@ static int cec_pin_thread_func(void *_adap)

 		if (pin->work_rx_msg.len) {
 			cec_received_msg_ts(adap, &pin->work_rx_msg,
-					    pin->work_rx_msg.rx_ts);
+				ns_to_ktime(pin->work_rx_msg.rx_ts));
 			pin->work_rx_msg.len = 0;
 		}
 		if (pin->work_tx_status) {
@@ -623,13 +626,15 @@ static int cec_pin_thread_func(void *_adap)
 			pin->ops->disable_irq(adap);
 			cec_pin_high(pin);
 			cec_pin_to_idle(pin);
-			hrtimer_start(&pin->timer, 0, HRTIMER_MODE_REL);
+			hrtimer_start(&pin->timer, ns_to_ktime(0),
+				      HRTIMER_MODE_REL);
 			break;
 		case CEC_PIN_IRQ_ENABLE:
 			pin->enable_irq_failed = !pin->ops->enable_irq(adap);
 			if (pin->enable_irq_failed) {
 				cec_pin_to_idle(pin);
-				hrtimer_start(&pin->timer, 0, HRTIMER_MODE_REL);
+				hrtimer_start(&pin->timer, ns_to_ktime(0),
+					      HRTIMER_MODE_REL);
 			}
 			break;
 		default:
@@ -653,7 +658,7 @@ static int cec_pin_adap_enable(struct cec_adapter *adap, bool enable)
 		cec_pin_read(pin);
 		cec_pin_to_idle(pin);
 		pin->tx_msg.len = 0;
-		pin->timer_ts = 0;
+		pin->timer_ts = ns_to_ktime(0);
 		atomic_set(&pin->work_irq_change, CEC_PIN_IRQ_UNCHANGED);
 		pin->kthread = kthread_run(cec_pin_thread_func, adap,
 					   "cec-pin");
@@ -661,7 +666,8 @@ static int cec_pin_adap_enable(struct cec_adapter *adap, bool enable)
 			pr_err("cec-pin: kernel_thread() failed\n");
 			return PTR_ERR(pin->kthread);
 		}
-		hrtimer_start(&pin->timer, 0, HRTIMER_MODE_REL);
+		hrtimer_start(&pin->timer, ns_to_ktime(0),
+			      HRTIMER_MODE_REL);
 	} else {
 		if (pin->ops->disable_irq)
 			pin->ops->disable_irq(adap);
@@ -699,7 +705,8 @@ static int cec_pin_adap_transmit(struct cec_adapter *adap, u8 attempts,
 		pin->ops->disable_irq(adap);
 		cec_pin_high(pin);
 		cec_pin_to_idle(pin);
-		hrtimer_start(&pin->timer, 0, HRTIMER_MODE_REL);
+		hrtimer_start(&pin->timer, ns_to_ktime(0),
+			      HRTIMER_MODE_REL);
 	}
 	return 0;
 }
-- 
2.14.1
