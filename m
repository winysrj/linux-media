Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:39515 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934183AbeCENvo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Mar 2018 08:51:44 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 7/7] cec-pin: improve status log
Date: Mon,  5 Mar 2018 14:51:39 +0100
Message-Id: <20180305135139.95652-8-hverkuil@xs4all.nl>
In-Reply-To: <20180305135139.95652-1-hverkuil@xs4all.nl>
References: <20180305135139.95652-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Keep track of the number of short or long start bits, the number
of short or long data bits and the number of initiated or detected
low drive conditions.

Show this information in the status debugfs log.

Helpful when debugging, particularly when doing error injection
as well.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/cec/cec-pin-priv.h | 13 +++++++++
 drivers/media/cec/cec-pin.c      | 58 +++++++++++++++++++++++++++++++++++++---
 2 files changed, 68 insertions(+), 3 deletions(-)

diff --git a/drivers/media/cec/cec-pin-priv.h b/drivers/media/cec/cec-pin-priv.h
index c9349f68e554..dae8ba6f1037 100644
--- a/drivers/media/cec/cec-pin-priv.h
+++ b/drivers/media/cec/cec-pin-priv.h
@@ -181,6 +181,18 @@ struct cec_pin {
 	struct cec_msg			rx_msg;
 	u32				rx_bit;
 	bool				rx_toggle;
+	u32				rx_start_bit_low_too_short_cnt;
+	u64				rx_start_bit_low_too_short_ts;
+	u32				rx_start_bit_low_too_short_delta;
+	u32				rx_start_bit_too_short_cnt;
+	u64				rx_start_bit_too_short_ts;
+	u32				rx_start_bit_too_short_delta;
+	u32				rx_start_bit_too_long_cnt;
+	u32				rx_data_bit_too_short_cnt;
+	u64				rx_data_bit_too_short_ts;
+	u32				rx_data_bit_too_short_delta;
+	u32				rx_data_bit_too_long_cnt;
+	u32				rx_low_drive_cnt;
 
 	struct cec_msg			work_rx_msg;
 	u8				work_tx_status;
@@ -205,6 +217,7 @@ struct cec_pin {
 	bool				tx_generated_poll;
 	bool				tx_post_eom;
 	u8				tx_extra_bytes;
+	u32				tx_low_drive_cnt;
 #ifdef CONFIG_CEC_PIN_ERROR_INJ
 	u64				error_inj[CEC_ERROR_INJ_OP_ANY + 1];
 	u8				error_inj_args[CEC_ERROR_INJ_OP_ANY + 1][CEC_ERROR_INJ_NUM_ARGS];
diff --git a/drivers/media/cec/cec-pin.c b/drivers/media/cec/cec-pin.c
index 430a23392299..b509df154ca1 100644
--- a/drivers/media/cec/cec-pin.c
+++ b/drivers/media/cec/cec-pin.c
@@ -429,6 +429,7 @@ static void cec_pin_tx_states(struct cec_pin *pin, ktime_t ts)
 			pin->state = CEC_ST_TX_WAIT_FOR_HIGH;
 			pin->work_tx_ts = ts;
 			pin->work_tx_status = CEC_TX_STATUS_LOW_DRIVE;
+			pin->tx_low_drive_cnt++;
 			wake_up_interruptible(&pin->kthread_waitq);
 			break;
 		}
@@ -460,6 +461,7 @@ static void cec_pin_tx_states(struct cec_pin *pin, ktime_t ts)
 				break;
 			pin->work_tx_ts = ts;
 			pin->work_tx_status = CEC_TX_STATUS_LOW_DRIVE;
+			pin->tx_low_drive_cnt++;
 			wake_up_interruptible(&pin->kthread_waitq);
 			break;
 		}
@@ -650,6 +652,10 @@ static void cec_pin_rx_states(struct cec_pin *pin, ktime_t ts)
 		delta = ktime_us_delta(ts, pin->ts);
 		/* Start bit low is too short, go back to idle */
 		if (delta < CEC_TIM_START_BIT_LOW_MIN - CEC_TIM_IDLE_SAMPLE) {
+			if (!pin->rx_start_bit_low_too_short_cnt++) {
+				pin->rx_start_bit_low_too_short_ts = pin->ts;
+				pin->rx_start_bit_low_too_short_delta = delta;
+			}
 			cec_pin_to_idle(pin);
 			break;
 		}
@@ -670,6 +676,7 @@ static void cec_pin_rx_states(struct cec_pin *pin, ktime_t ts)
 		 * and go to idle. We just pick TOTAL_LONG.
 		 */
 		if (v && delta > CEC_TIM_START_BIT_TOTAL_LONG) {
+			pin->rx_start_bit_too_long_cnt++;
 			cec_pin_to_idle(pin);
 			break;
 		}
@@ -677,6 +684,10 @@ static void cec_pin_rx_states(struct cec_pin *pin, ktime_t ts)
 			break;
 		/* Start bit is too short, go back to idle */
 		if (delta < CEC_TIM_START_BIT_TOTAL_MIN - CEC_TIM_IDLE_SAMPLE) {
+			if (!pin->rx_start_bit_too_short_cnt++) {
+				pin->rx_start_bit_too_short_ts = pin->ts;
+				pin->rx_start_bit_too_short_delta = delta;
+			}
 			cec_pin_to_idle(pin);
 			break;
 		}
@@ -684,6 +695,7 @@ static void cec_pin_rx_states(struct cec_pin *pin, ktime_t ts)
 			/* Error injection: go to low drive */
 			cec_pin_low(pin);
 			pin->state = CEC_ST_RX_LOW_DRIVE;
+			pin->rx_low_drive_cnt++;
 			break;
 		}
 		pin->state = CEC_ST_RX_DATA_SAMPLE;
@@ -722,6 +734,7 @@ static void cec_pin_rx_states(struct cec_pin *pin, ktime_t ts)
 		 * and go to idle. We just pick TOTAL_LONG.
 		 */
 		if (v && delta > CEC_TIM_DATA_BIT_TOTAL_LONG) {
+			pin->rx_data_bit_too_long_cnt++;
 			cec_pin_to_idle(pin);
 			break;
 		}
@@ -732,6 +745,7 @@ static void cec_pin_rx_states(struct cec_pin *pin, ktime_t ts)
 			/* Error injection: go to low drive */
 			cec_pin_low(pin);
 			pin->state = CEC_ST_RX_LOW_DRIVE;
+			pin->rx_low_drive_cnt++;
 			break;
 		}
 
@@ -740,8 +754,13 @@ static void cec_pin_rx_states(struct cec_pin *pin, ktime_t ts)
 		 * too short.
 		 */
 		if (delta < CEC_TIM_DATA_BIT_TOTAL_MIN) {
+			if (!pin->rx_data_bit_too_short_cnt++) {
+				pin->rx_data_bit_too_short_ts = pin->ts;
+				pin->rx_data_bit_too_short_delta = delta;
+			}
 			cec_pin_low(pin);
 			pin->state = CEC_ST_RX_LOW_DRIVE;
+			pin->rx_low_drive_cnt++;
 			break;
 		}
 		pin->ts = ts;
@@ -1142,9 +1161,9 @@ static void cec_pin_adap_status(struct cec_adapter *adap,
 {
 	struct cec_pin *pin = adap->pin;
 
-	seq_printf(file, "state:   %s\n", states[pin->state].name);
-	seq_printf(file, "tx_bit:  %d\n", pin->tx_bit);
-	seq_printf(file, "rx_bit:  %d\n", pin->rx_bit);
+	seq_printf(file, "state: %s\n", states[pin->state].name);
+	seq_printf(file, "tx_bit: %d\n", pin->tx_bit);
+	seq_printf(file, "rx_bit: %d\n", pin->rx_bit);
 	seq_printf(file, "cec pin: %d\n", pin->ops->read(adap));
 	seq_printf(file, "irq failed: %d\n", pin->enable_irq_failed);
 	if (pin->timer_100ms_overruns) {
@@ -1157,11 +1176,44 @@ static void cec_pin_adap_status(struct cec_adapter *adap,
 		seq_printf(file, "avg timer overrun: %u usecs\n",
 			   pin->timer_sum_overrun / pin->timer_100ms_overruns);
 	}
+	if (pin->rx_start_bit_low_too_short_cnt)
+		seq_printf(file,
+			   "rx start bit low too short: %u (delta %u, ts %llu)\n",
+			   pin->rx_start_bit_low_too_short_cnt,
+			   pin->rx_start_bit_low_too_short_delta,
+			   pin->rx_start_bit_low_too_short_ts);
+	if (pin->rx_start_bit_too_short_cnt)
+		seq_printf(file,
+			   "rx start bit too short: %u (delta %u, ts %llu)\n",
+			   pin->rx_start_bit_too_short_cnt,
+			   pin->rx_start_bit_too_short_delta,
+			   pin->rx_start_bit_too_short_ts);
+	if (pin->rx_start_bit_too_long_cnt)
+		seq_printf(file, "rx start bit too long: %u\n",
+			   pin->rx_start_bit_too_long_cnt);
+	if (pin->rx_data_bit_too_short_cnt)
+		seq_printf(file,
+			   "rx data bit too short: %u (delta %u, ts %llu)\n",
+			   pin->rx_data_bit_too_short_cnt,
+			   pin->rx_data_bit_too_short_delta,
+			   pin->rx_data_bit_too_short_ts);
+	if (pin->rx_data_bit_too_long_cnt)
+		seq_printf(file, "rx data bit too long: %u\n",
+			   pin->rx_data_bit_too_long_cnt);
+	seq_printf(file, "rx initiated low drive: %u\n", pin->rx_low_drive_cnt);
+	seq_printf(file, "tx detected low drive: %u\n", pin->tx_low_drive_cnt);
 	pin->timer_cnt = 0;
 	pin->timer_100ms_overruns = 0;
 	pin->timer_300ms_overruns = 0;
 	pin->timer_max_overrun = 0;
 	pin->timer_sum_overrun = 0;
+	pin->rx_start_bit_low_too_short_cnt = 0;
+	pin->rx_start_bit_too_short_cnt = 0;
+	pin->rx_start_bit_too_long_cnt = 0;
+	pin->rx_data_bit_too_short_cnt = 0;
+	pin->rx_data_bit_too_long_cnt = 0;
+	pin->rx_low_drive_cnt = 0;
+	pin->tx_low_drive_cnt = 0;
 	if (pin->ops->status)
 		pin->ops->status(adap, file);
 }
-- 
2.16.1
