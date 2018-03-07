Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:36452 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751151AbeCGORw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Mar 2018 09:17:52 -0500
Subject: [PATCHv2.1 5/7] cec-pin: add error injection support
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <20180305135139.95652-1-hverkuil@xs4all.nl>
 <20180305135139.95652-6-hverkuil@xs4all.nl>
 <526d0a58-b032-2b8b-1c47-8168918b4330@xs4all.nl>
Message-ID: <71cce5d9-8610-0fe7-0382-3f3859cf8df4@xs4all.nl>
Date: Wed, 7 Mar 2018 15:17:49 +0100
MIME-Version: 1.0
In-Reply-To: <526d0a58-b032-2b8b-1c47-8168918b4330@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement all the error injection commands.

The state machine gets new states for the various error situations,
helper functions are added to detect whether an error injection is
active and the actual error injections are implemented.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
Changes since v2:
- Fix wrong arg_idx condition (must be >= 0)
- Fix tx_no_eom and tx_early_eom: don't call this for every byte, only
  for the byte it applies to. Otherwise command will be cleared in the 'once'
  mode.
---
 drivers/media/cec/cec-pin-priv.h |  38 ++-
 drivers/media/cec/cec-pin.c      | 545 +++++++++++++++++++++++++++++++++++----
 2 files changed, 524 insertions(+), 59 deletions(-)

diff --git a/drivers/media/cec/cec-pin-priv.h b/drivers/media/cec/cec-pin-priv.h
index 779384f18689..c9349f68e554 100644
--- a/drivers/media/cec/cec-pin-priv.h
+++ b/drivers/media/cec/cec-pin-priv.h
@@ -28,14 +28,30 @@ enum cec_pin_state {
 	CEC_ST_TX_START_BIT_LOW,
 	/* Drive CEC high for the start bit */
 	CEC_ST_TX_START_BIT_HIGH,
+	/* Generate a start bit period that is too short */
+	CEC_ST_TX_START_BIT_HIGH_SHORT,
+	/* Generate a start bit period that is too long */
+	CEC_ST_TX_START_BIT_HIGH_LONG,
+	/* Drive CEC low for the start bit using the custom timing */
+	CEC_ST_TX_START_BIT_LOW_CUSTOM,
+	/* Drive CEC high for the start bit using the custom timing */
+	CEC_ST_TX_START_BIT_HIGH_CUSTOM,
 	/* Drive CEC low for the 0 bit */
 	CEC_ST_TX_DATA_BIT_0_LOW,
 	/* Drive CEC high for the 0 bit */
 	CEC_ST_TX_DATA_BIT_0_HIGH,
+	/* Generate a bit period that is too short */
+	CEC_ST_TX_DATA_BIT_0_HIGH_SHORT,
+	/* Generate a bit period that is too long */
+	CEC_ST_TX_DATA_BIT_0_HIGH_LONG,
 	/* Drive CEC low for the 1 bit */
 	CEC_ST_TX_DATA_BIT_1_LOW,
 	/* Drive CEC high for the 1 bit */
 	CEC_ST_TX_DATA_BIT_1_HIGH,
+	/* Generate a bit period that is too short */
+	CEC_ST_TX_DATA_BIT_1_HIGH_SHORT,
+	/* Generate a bit period that is too long */
+	CEC_ST_TX_DATA_BIT_1_HIGH_LONG,
 	/*
 	 * Wait for start of sample time to check for Ack bit or first
 	 * four initiator bits to check for Arbitration Lost.
@@ -43,6 +59,20 @@ enum cec_pin_state {
 	CEC_ST_TX_DATA_BIT_1_HIGH_PRE_SAMPLE,
 	/* Wait for end of bit period after sampling */
 	CEC_ST_TX_DATA_BIT_1_HIGH_POST_SAMPLE,
+	/* Generate a bit period that is too short */
+	CEC_ST_TX_DATA_BIT_1_HIGH_POST_SAMPLE_SHORT,
+	/* Generate a bit period that is too long */
+	CEC_ST_TX_DATA_BIT_1_HIGH_POST_SAMPLE_LONG,
+	/* Drive CEC low for a data bit using the custom timing */
+	CEC_ST_TX_DATA_BIT_LOW_CUSTOM,
+	/* Drive CEC high for a data bit using the custom timing */
+	CEC_ST_TX_DATA_BIT_HIGH_CUSTOM,
+	/* Drive CEC low for a standalone pulse using the custom timing */
+	CEC_ST_TX_PULSE_LOW_CUSTOM,
+	/* Drive CEC high for a standalone pulse using the custom timing */
+	CEC_ST_TX_PULSE_HIGH_CUSTOM,
+	/* Start low drive */
+	CEC_ST_TX_LOW_DRIVE,

 	/* Rx states */

@@ -54,8 +84,8 @@ enum cec_pin_state {
 	CEC_ST_RX_DATA_SAMPLE,
 	/* Wait for earliest end of bit period after sampling */
 	CEC_ST_RX_DATA_POST_SAMPLE,
-	/* Wait for CEC to go high (i.e. end of bit period */
-	CEC_ST_RX_DATA_HIGH,
+	/* Wait for CEC to go low (i.e. end of bit period) */
+	CEC_ST_RX_DATA_WAIT_FOR_LOW,
 	/* Drive CEC low to send 0 Ack bit */
 	CEC_ST_RX_ACK_LOW,
 	/* End of 0 Ack time, wait for earliest end of bit period */
@@ -64,9 +94,9 @@ enum cec_pin_state {
 	CEC_ST_RX_ACK_HIGH_POST,
 	/* Wait for earliest end of bit period and end of message */
 	CEC_ST_RX_ACK_FINISH,
-
 	/* Start low drive */
-	CEC_ST_LOW_DRIVE,
+	CEC_ST_RX_LOW_DRIVE,
+
 	/* Monitor pin using interrupts */
 	CEC_ST_RX_IRQ,

diff --git a/drivers/media/cec/cec-pin.c b/drivers/media/cec/cec-pin.c
index 7920ea1c940b..c450145ef67a 100644
--- a/drivers/media/cec/cec-pin.c
+++ b/drivers/media/cec/cec-pin.c
@@ -39,11 +39,29 @@
 #define CEC_TIM_IDLE_SAMPLE		1000
 /* when processing the start bit, sample twice per millisecond */
 #define CEC_TIM_START_BIT_SAMPLE	500
-/* when polling for a state change, sample once every 50 micoseconds */
+/* when polling for a state change, sample once every 50 microseconds */
 #define CEC_TIM_SAMPLE			50

 #define CEC_TIM_LOW_DRIVE_ERROR		(1.5 * CEC_TIM_DATA_BIT_TOTAL)

+/*
+ * Total data bit time that is too short/long for a valid bit,
+ * used for error injection.
+ */
+#define CEC_TIM_DATA_BIT_TOTAL_SHORT	1800
+#define CEC_TIM_DATA_BIT_TOTAL_LONG	2900
+
+/*
+ * Total start bit time that is too short/long for a valid bit,
+ * used for error injection.
+ */
+#define CEC_TIM_START_BIT_TOTAL_SHORT	4100
+#define CEC_TIM_START_BIT_TOTAL_LONG	5000
+
+/* Data bits are 0-7, EOM is bit 8 and ACK is bit 9 */
+#define EOM_BIT				8
+#define ACK_BIT				9
+
 struct cec_state {
 	const char * const name;
 	unsigned int usecs;
@@ -56,17 +74,32 @@ static const struct cec_state states[CEC_PIN_STATES] = {
 	{ "Tx Wait for High",	   CEC_TIM_IDLE_SAMPLE },
 	{ "Tx Start Bit Low",	   CEC_TIM_START_BIT_LOW },
 	{ "Tx Start Bit High",	   CEC_TIM_START_BIT_TOTAL - CEC_TIM_START_BIT_LOW },
+	{ "Tx Start Bit High Short", CEC_TIM_START_BIT_TOTAL_SHORT - CEC_TIM_START_BIT_LOW },
+	{ "Tx Start Bit High Long", CEC_TIM_START_BIT_TOTAL_LONG - CEC_TIM_START_BIT_LOW },
+	{ "Tx Start Bit Low Custom", 0 },
+	{ "Tx Start Bit High Custom", 0 },
 	{ "Tx Data 0 Low",	   CEC_TIM_DATA_BIT_0_LOW },
 	{ "Tx Data 0 High",	   CEC_TIM_DATA_BIT_TOTAL - CEC_TIM_DATA_BIT_0_LOW },
+	{ "Tx Data 0 High Short",  CEC_TIM_DATA_BIT_TOTAL_SHORT - CEC_TIM_DATA_BIT_0_LOW },
+	{ "Tx Data 0 High Long",   CEC_TIM_DATA_BIT_TOTAL_LONG - CEC_TIM_DATA_BIT_0_LOW },
 	{ "Tx Data 1 Low",	   CEC_TIM_DATA_BIT_1_LOW },
 	{ "Tx Data 1 High",	   CEC_TIM_DATA_BIT_TOTAL - CEC_TIM_DATA_BIT_1_LOW },
-	{ "Tx Data 1 Pre Sample",  CEC_TIM_DATA_BIT_SAMPLE - CEC_TIM_DATA_BIT_1_LOW },
-	{ "Tx Data 1 Post Sample", CEC_TIM_DATA_BIT_TOTAL - CEC_TIM_DATA_BIT_SAMPLE },
+	{ "Tx Data 1 High Short",  CEC_TIM_DATA_BIT_TOTAL_SHORT - CEC_TIM_DATA_BIT_1_LOW },
+	{ "Tx Data 1 High Long",   CEC_TIM_DATA_BIT_TOTAL_LONG - CEC_TIM_DATA_BIT_1_LOW },
+	{ "Tx Data 1 High Pre Sample", CEC_TIM_DATA_BIT_SAMPLE - CEC_TIM_DATA_BIT_1_LOW },
+	{ "Tx Data 1 High Post Sample", CEC_TIM_DATA_BIT_TOTAL - CEC_TIM_DATA_BIT_SAMPLE },
+	{ "Tx Data 1 High Post Sample Short", CEC_TIM_DATA_BIT_TOTAL_SHORT - CEC_TIM_DATA_BIT_SAMPLE },
+	{ "Tx Data 1 High Post Sample Long", CEC_TIM_DATA_BIT_TOTAL_LONG - CEC_TIM_DATA_BIT_SAMPLE },
+	{ "Tx Data Bit Low Custom", 0 },
+	{ "Tx Data Bit High Custom", 0 },
+	{ "Tx Pulse Low Custom",   0 },
+	{ "Tx Pulse High Custom",  0 },
+	{ "Tx Low Drive",	   CEC_TIM_LOW_DRIVE_ERROR },
 	{ "Rx Start Bit Low",	   CEC_TIM_SAMPLE },
 	{ "Rx Start Bit High",	   CEC_TIM_SAMPLE },
 	{ "Rx Data Sample",	   CEC_TIM_DATA_BIT_SAMPLE },
 	{ "Rx Data Post Sample",   CEC_TIM_DATA_BIT_HIGH - CEC_TIM_DATA_BIT_SAMPLE },
-	{ "Rx Data High",	   CEC_TIM_SAMPLE },
+	{ "Rx Data Wait for Low",  CEC_TIM_SAMPLE },
 	{ "Rx Ack Low",		   CEC_TIM_DATA_BIT_0_LOW },
 	{ "Rx Ack Low Post",	   CEC_TIM_DATA_BIT_HIGH - CEC_TIM_DATA_BIT_0_LOW },
 	{ "Rx Ack High Post",	   CEC_TIM_DATA_BIT_HIGH },
@@ -111,6 +144,170 @@ static bool cec_pin_high(struct cec_pin *pin)
 	return cec_pin_read(pin);
 }

+static bool rx_error_inj(struct cec_pin *pin, unsigned int mode_offset,
+			 int arg_idx, u8 *arg)
+{
+#ifdef CONFIG_CEC_PIN_ERROR_INJ
+	u16 cmd = cec_pin_rx_error_inj(pin);
+	u64 e = pin->error_inj[cmd];
+	unsigned int mode = (e >> mode_offset) & CEC_ERROR_INJ_MODE_MASK;
+
+	if (arg_idx >= 0) {
+		u8 pos = pin->error_inj_args[cmd][arg_idx];
+
+		if (arg)
+			*arg = pos;
+		else if (pos != pin->rx_bit)
+			return false;
+	}
+
+	switch (mode) {
+	case CEC_ERROR_INJ_MODE_ONCE:
+		pin->error_inj[cmd] &= ~(CEC_ERROR_INJ_MODE_MASK << mode_offset);
+		return true;
+	case CEC_ERROR_INJ_MODE_ALWAYS:
+		return true;
+	case CEC_ERROR_INJ_MODE_TOGGLE:
+		return pin->rx_toggle;
+	default:
+		return false;
+	}
+#else
+	return false;
+#endif
+}
+
+static bool rx_nack(struct cec_pin *pin)
+{
+	return rx_error_inj(pin, CEC_ERROR_INJ_RX_NACK_OFFSET, -1, NULL);
+}
+
+static bool rx_low_drive(struct cec_pin *pin)
+{
+	return rx_error_inj(pin, CEC_ERROR_INJ_RX_LOW_DRIVE_OFFSET,
+			    CEC_ERROR_INJ_RX_LOW_DRIVE_ARG_IDX, NULL);
+}
+
+static bool rx_add_byte(struct cec_pin *pin)
+{
+	return rx_error_inj(pin, CEC_ERROR_INJ_RX_ADD_BYTE_OFFSET, -1, NULL);
+}
+
+static bool rx_remove_byte(struct cec_pin *pin)
+{
+	return rx_error_inj(pin, CEC_ERROR_INJ_RX_REMOVE_BYTE_OFFSET, -1, NULL);
+}
+
+static bool rx_arb_lost(struct cec_pin *pin, u8 *poll)
+{
+	return pin->tx_msg.len == 0 &&
+		rx_error_inj(pin, CEC_ERROR_INJ_RX_ARB_LOST_OFFSET,
+			     CEC_ERROR_INJ_RX_ARB_LOST_ARG_IDX, poll);
+}
+
+static bool tx_error_inj(struct cec_pin *pin, unsigned int mode_offset,
+			 int arg_idx, u8 *arg)
+{
+#ifdef CONFIG_CEC_PIN_ERROR_INJ
+	u16 cmd = cec_pin_tx_error_inj(pin);
+	u64 e = pin->error_inj[cmd];
+	unsigned int mode = (e >> mode_offset) & CEC_ERROR_INJ_MODE_MASK;
+
+	if (arg_idx >= 0) {
+		u8 pos = pin->error_inj_args[cmd][arg_idx];
+
+		if (arg)
+			*arg = pos;
+		else if (pos != pin->tx_bit)
+			return false;
+	}
+
+	switch (mode) {
+	case CEC_ERROR_INJ_MODE_ONCE:
+		pin->error_inj[cmd] &= ~(CEC_ERROR_INJ_MODE_MASK << mode_offset);
+		return true;
+	case CEC_ERROR_INJ_MODE_ALWAYS:
+		return true;
+	case CEC_ERROR_INJ_MODE_TOGGLE:
+		return pin->tx_toggle;
+	default:
+		return false;
+	}
+#else
+	return false;
+#endif
+}
+
+static bool tx_no_eom(struct cec_pin *pin)
+{
+	return tx_error_inj(pin, CEC_ERROR_INJ_TX_NO_EOM_OFFSET, -1, NULL);
+}
+
+static bool tx_early_eom(struct cec_pin *pin)
+{
+	return tx_error_inj(pin, CEC_ERROR_INJ_TX_EARLY_EOM_OFFSET, -1, NULL);
+}
+
+static bool tx_short_bit(struct cec_pin *pin)
+{
+	return tx_error_inj(pin, CEC_ERROR_INJ_TX_SHORT_BIT_OFFSET,
+			    CEC_ERROR_INJ_TX_SHORT_BIT_ARG_IDX, NULL);
+}
+
+static bool tx_long_bit(struct cec_pin *pin)
+{
+	return tx_error_inj(pin, CEC_ERROR_INJ_TX_LONG_BIT_OFFSET,
+			    CEC_ERROR_INJ_TX_LONG_BIT_ARG_IDX, NULL);
+}
+
+static bool tx_custom_bit(struct cec_pin *pin)
+{
+	return tx_error_inj(pin, CEC_ERROR_INJ_TX_CUSTOM_BIT_OFFSET,
+			    CEC_ERROR_INJ_TX_CUSTOM_BIT_ARG_IDX, NULL);
+}
+
+static bool tx_short_start(struct cec_pin *pin)
+{
+	return tx_error_inj(pin, CEC_ERROR_INJ_TX_SHORT_START_OFFSET, -1, NULL);
+}
+
+static bool tx_long_start(struct cec_pin *pin)
+{
+	return tx_error_inj(pin, CEC_ERROR_INJ_TX_LONG_START_OFFSET, -1, NULL);
+}
+
+static bool tx_custom_start(struct cec_pin *pin)
+{
+	return tx_error_inj(pin, CEC_ERROR_INJ_TX_CUSTOM_START_OFFSET, -1, NULL);
+}
+
+static bool tx_last_bit(struct cec_pin *pin)
+{
+	return tx_error_inj(pin, CEC_ERROR_INJ_TX_LAST_BIT_OFFSET,
+			    CEC_ERROR_INJ_TX_LAST_BIT_ARG_IDX, NULL);
+}
+
+static u8 tx_add_bytes(struct cec_pin *pin)
+{
+	u8 bytes;
+
+	if (tx_error_inj(pin, CEC_ERROR_INJ_TX_ADD_BYTES_OFFSET,
+			 CEC_ERROR_INJ_TX_ADD_BYTES_ARG_IDX, &bytes))
+		return bytes;
+	return 0;
+}
+
+static bool tx_remove_byte(struct cec_pin *pin)
+{
+	return tx_error_inj(pin, CEC_ERROR_INJ_TX_REMOVE_BYTE_OFFSET, -1, NULL);
+}
+
+static bool tx_low_drive(struct cec_pin *pin)
+{
+	return tx_error_inj(pin, CEC_ERROR_INJ_TX_LOW_DRIVE_OFFSET,
+			    CEC_ERROR_INJ_TX_LOW_DRIVE_ARG_IDX, NULL);
+}
+
 static void cec_pin_to_idle(struct cec_pin *pin)
 {
 	/*
@@ -120,8 +317,16 @@ static void cec_pin_to_idle(struct cec_pin *pin)
 	pin->rx_bit = pin->tx_bit = 0;
 	pin->rx_msg.len = 0;
 	memset(pin->rx_msg.msg, 0, sizeof(pin->rx_msg.msg));
-	pin->state = CEC_ST_IDLE;
 	pin->ts = ns_to_ktime(0);
+	pin->tx_generated_poll = false;
+	pin->tx_post_eom = false;
+	if (pin->state >= CEC_ST_TX_WAIT &&
+	    pin->state <= CEC_ST_TX_LOW_DRIVE)
+		pin->tx_toggle ^= 1;
+	if (pin->state >= CEC_ST_RX_START_BIT_LOW &&
+	    pin->state <= CEC_ST_RX_LOW_DRIVE)
+		pin->rx_toggle ^= 1;
+	pin->state = CEC_ST_IDLE;
 }

 /*
@@ -162,42 +367,107 @@ static void cec_pin_tx_states(struct cec_pin *pin, ktime_t ts)
 		break;

 	case CEC_ST_TX_START_BIT_LOW:
-		pin->state = CEC_ST_TX_START_BIT_HIGH;
+		if (tx_short_start(pin)) {
+			/*
+			 * Error Injection: send an invalid (too short)
+			 * start pulse.
+			 */
+			pin->state = CEC_ST_TX_START_BIT_HIGH_SHORT;
+		} else if (tx_long_start(pin)) {
+			/*
+			 * Error Injection: send an invalid (too long)
+			 * start pulse.
+			 */
+			pin->state = CEC_ST_TX_START_BIT_HIGH_LONG;
+		} else {
+			pin->state = CEC_ST_TX_START_BIT_HIGH;
+		}
+		/* Generate start bit */
+		cec_pin_high(pin);
+		break;
+
+	case CEC_ST_TX_START_BIT_LOW_CUSTOM:
+		pin->state = CEC_ST_TX_START_BIT_HIGH_CUSTOM;
 		/* Generate start bit */
 		cec_pin_high(pin);
 		break;

 	case CEC_ST_TX_DATA_BIT_1_HIGH_POST_SAMPLE:
-		/* If the read value is 1, then all is OK */
-		if (!cec_pin_read(pin)) {
+	case CEC_ST_TX_DATA_BIT_1_HIGH_POST_SAMPLE_SHORT:
+	case CEC_ST_TX_DATA_BIT_1_HIGH_POST_SAMPLE_LONG:
+		if (pin->tx_nacked) {
+			cec_pin_to_idle(pin);
+			pin->tx_msg.len = 0;
+			if (pin->tx_generated_poll)
+				break;
+			pin->work_tx_ts = ts;
+			pin->work_tx_status = CEC_TX_STATUS_NACK;
+			wake_up_interruptible(&pin->kthread_waitq);
+			break;
+		}
+		/* fall through */
+	case CEC_ST_TX_DATA_BIT_0_HIGH:
+	case CEC_ST_TX_DATA_BIT_0_HIGH_SHORT:
+	case CEC_ST_TX_DATA_BIT_0_HIGH_LONG:
+	case CEC_ST_TX_DATA_BIT_1_HIGH:
+	case CEC_ST_TX_DATA_BIT_1_HIGH_SHORT:
+	case CEC_ST_TX_DATA_BIT_1_HIGH_LONG:
+		/*
+		 * If the read value is 1, then all is OK, otherwise we have a
+		 * low drive condition.
+		 *
+		 * Special case: when we generate a poll message due to an
+		 * Arbitration Lost error injection, then ignore this since
+		 * the pin can actually be low in that case.
+		 */
+		if (!cec_pin_read(pin) && !pin->tx_generated_poll) {
 			/*
 			 * It's 0, so someone detected an error and pulled the
 			 * line low for 1.5 times the nominal bit period.
 			 */
 			pin->tx_msg.len = 0;
+			pin->state = CEC_ST_TX_WAIT_FOR_HIGH;
 			pin->work_tx_ts = ts;
 			pin->work_tx_status = CEC_TX_STATUS_LOW_DRIVE;
-			pin->state = CEC_ST_TX_WAIT_FOR_HIGH;
 			wake_up_interruptible(&pin->kthread_waitq);
 			break;
 		}
-		if (pin->tx_nacked) {
+		/* fall through */
+	case CEC_ST_TX_DATA_BIT_HIGH_CUSTOM:
+		if (tx_last_bit(pin)) {
+			/* Error Injection: just stop sending after this bit */
 			cec_pin_to_idle(pin);
 			pin->tx_msg.len = 0;
+			if (pin->tx_generated_poll)
+				break;
 			pin->work_tx_ts = ts;
-			pin->work_tx_status = CEC_TX_STATUS_NACK;
+			pin->work_tx_status = CEC_TX_STATUS_OK;
 			wake_up_interruptible(&pin->kthread_waitq);
 			break;
 		}
-		/* fall through */
-	case CEC_ST_TX_DATA_BIT_0_HIGH:
-	case CEC_ST_TX_DATA_BIT_1_HIGH:
 		pin->tx_bit++;
 		/* fall through */
 	case CEC_ST_TX_START_BIT_HIGH:
-		if (pin->tx_bit / 10 >= pin->tx_msg.len) {
+	case CEC_ST_TX_START_BIT_HIGH_SHORT:
+	case CEC_ST_TX_START_BIT_HIGH_LONG:
+	case CEC_ST_TX_START_BIT_HIGH_CUSTOM:
+		if (tx_low_drive(pin)) {
+			/* Error injection: go to low drive */
+			cec_pin_low(pin);
+			pin->state = CEC_ST_TX_LOW_DRIVE;
+			pin->tx_msg.len = 0;
+			if (pin->tx_generated_poll)
+				break;
+			pin->work_tx_ts = ts;
+			pin->work_tx_status = CEC_TX_STATUS_LOW_DRIVE;
+			wake_up_interruptible(&pin->kthread_waitq);
+			break;
+		}
+		if (pin->tx_bit / 10 >= pin->tx_msg.len + pin->tx_extra_bytes) {
 			cec_pin_to_idle(pin);
 			pin->tx_msg.len = 0;
+			if (pin->tx_generated_poll)
+				break;
 			pin->work_tx_ts = ts;
 			pin->work_tx_status = CEC_TX_STATUS_OK;
 			wake_up_interruptible(&pin->kthread_waitq);
@@ -205,39 +475,82 @@ static void cec_pin_tx_states(struct cec_pin *pin, ktime_t ts)
 		}

 		switch (pin->tx_bit % 10) {
-		default:
-			v = pin->tx_msg.msg[pin->tx_bit / 10] &
-				(1 << (7 - (pin->tx_bit % 10)));
+		default: {
+			/*
+			 * In the CEC_ERROR_INJ_TX_ADD_BYTES case we transmit
+			 * extra bytes, so pin->tx_bit / 10 can become >= 16.
+			 * Generate bit values for those extra bytes instead
+			 * of reading them from the transmit buffer.
+			 */
+			unsigned int idx = (pin->tx_bit / 10);
+			u8 val = idx;
+
+			if (idx < pin->tx_msg.len)
+				val = pin->tx_msg.msg[idx];
+			v = val & (1 << (7 - (pin->tx_bit % 10)));
+
 			pin->state = v ? CEC_ST_TX_DATA_BIT_1_LOW :
-				CEC_ST_TX_DATA_BIT_0_LOW;
+					 CEC_ST_TX_DATA_BIT_0_LOW;
 			break;
-		case 8:
-			v = pin->tx_bit / 10 == pin->tx_msg.len - 1;
+		}
+		case EOM_BIT: {
+			unsigned int tot_len = pin->tx_msg.len +
+					       pin->tx_extra_bytes;
+			unsigned int tx_byte_idx = pin->tx_bit / 10;
+
+			v = !pin->tx_post_eom && tx_byte_idx == tot_len - 1;
+			if (tot_len > 1 && tx_byte_idx == tot_len - 2 &&
+			    tx_early_eom(pin)) {
+				/* Error injection: set EOM one byte early */
+				v = true;
+				pin->tx_post_eom = true;
+			} else if (v && tx_no_eom(pin)) {
+				/* Error injection: no EOM */
+				v = false;
+			}
 			pin->state = v ? CEC_ST_TX_DATA_BIT_1_LOW :
-				CEC_ST_TX_DATA_BIT_0_LOW;
+					 CEC_ST_TX_DATA_BIT_0_LOW;
 			break;
-		case 9:
+		}
+		case ACK_BIT:
 			pin->state = CEC_ST_TX_DATA_BIT_1_LOW;
 			break;
 		}
+		if (tx_custom_bit(pin))
+			pin->state = CEC_ST_TX_DATA_BIT_LOW_CUSTOM;
 		cec_pin_low(pin);
 		break;

 	case CEC_ST_TX_DATA_BIT_0_LOW:
 	case CEC_ST_TX_DATA_BIT_1_LOW:
 		v = pin->state == CEC_ST_TX_DATA_BIT_1_LOW;
-		pin->state = v ? CEC_ST_TX_DATA_BIT_1_HIGH :
-			CEC_ST_TX_DATA_BIT_0_HIGH;
-		is_ack_bit = pin->tx_bit % 10 == 9;
-		if (v && (pin->tx_bit < 4 || is_ack_bit))
+		is_ack_bit = pin->tx_bit % 10 == ACK_BIT;
+		if (v && (pin->tx_bit < 4 || is_ack_bit)) {
 			pin->state = CEC_ST_TX_DATA_BIT_1_HIGH_PRE_SAMPLE;
+		} else if (!is_ack_bit && tx_short_bit(pin)) {
+			/* Error Injection: send an invalid (too short) bit */
+			pin->state = v ? CEC_ST_TX_DATA_BIT_1_HIGH_SHORT :
+					 CEC_ST_TX_DATA_BIT_0_HIGH_SHORT;
+		} else if (!is_ack_bit && tx_long_bit(pin)) {
+			/* Error Injection: send an invalid (too long) bit */
+			pin->state = v ? CEC_ST_TX_DATA_BIT_1_HIGH_LONG :
+					 CEC_ST_TX_DATA_BIT_0_HIGH_LONG;
+		} else {
+			pin->state = v ? CEC_ST_TX_DATA_BIT_1_HIGH :
+					 CEC_ST_TX_DATA_BIT_0_HIGH;
+		}
+		cec_pin_high(pin);
+		break;
+
+	case CEC_ST_TX_DATA_BIT_LOW_CUSTOM:
+		pin->state = CEC_ST_TX_DATA_BIT_HIGH_CUSTOM;
 		cec_pin_high(pin);
 		break;

 	case CEC_ST_TX_DATA_BIT_1_HIGH_PRE_SAMPLE:
 		/* Read the CEC value at the sample time */
 		v = cec_pin_read(pin);
-		is_ack_bit = pin->tx_bit % 10 == 9;
+		is_ack_bit = pin->tx_bit % 10 == ACK_BIT;
 		/*
 		 * If v == 0 and we're within the first 4 bits
 		 * of the initiator, then someone else started
@@ -246,7 +559,7 @@ static void cec_pin_tx_states(struct cec_pin *pin, ktime_t ts)
 		 * transmitter has more leading 0 bits in the
 		 * initiator).
 		 */
-		if (!v && !is_ack_bit) {
+		if (!v && !is_ack_bit && !pin->tx_generated_poll) {
 			pin->tx_msg.len = 0;
 			pin->work_tx_ts = ts;
 			pin->work_tx_status = CEC_TX_STATUS_ARB_LOST;
@@ -255,18 +568,27 @@ static void cec_pin_tx_states(struct cec_pin *pin, ktime_t ts)
 			pin->tx_bit = 0;
 			memset(pin->rx_msg.msg, 0, sizeof(pin->rx_msg.msg));
 			pin->rx_msg.msg[0] = pin->tx_msg.msg[0];
-			pin->rx_msg.msg[0] &= ~(1 << (7 - pin->rx_bit));
+			pin->rx_msg.msg[0] &= (0xff << (8 - pin->rx_bit));
 			pin->rx_msg.len = 0;
+			pin->ts = ktime_sub_us(ts, CEC_TIM_DATA_BIT_SAMPLE);
 			pin->state = CEC_ST_RX_DATA_POST_SAMPLE;
 			pin->rx_bit++;
 			break;
 		}
 		pin->state = CEC_ST_TX_DATA_BIT_1_HIGH_POST_SAMPLE;
+		if (!is_ack_bit && tx_short_bit(pin)) {
+			/* Error Injection: send an invalid (too short) bit */
+			pin->state = CEC_ST_TX_DATA_BIT_1_HIGH_POST_SAMPLE_SHORT;
+		} else if (!is_ack_bit && tx_long_bit(pin)) {
+			/* Error Injection: send an invalid (too long) bit */
+			pin->state = CEC_ST_TX_DATA_BIT_1_HIGH_POST_SAMPLE_LONG;
+		}
 		if (!is_ack_bit)
 			break;
 		/* Was the message ACKed? */
 		ack = cec_msg_is_broadcast(&pin->tx_msg) ? v : !v;
-		if (!ack) {
+		if (!ack && !pin->tx_ignore_nack_until_eom &&
+		    pin->tx_bit / 10 < pin->tx_msg.len && !pin->tx_post_eom) {
 			/*
 			 * Note: the CEC spec is ambiguous regarding
 			 * what action to take when a NACK appears
@@ -283,6 +605,15 @@ static void cec_pin_tx_states(struct cec_pin *pin, ktime_t ts)
 		}
 		break;

+	case CEC_ST_TX_PULSE_LOW_CUSTOM:
+		cec_pin_high(pin);
+		pin->state = CEC_ST_TX_PULSE_HIGH_CUSTOM;
+		break;
+
+	case CEC_ST_TX_PULSE_HIGH_CUSTOM:
+		cec_pin_to_idle(pin);
+		break;
+
 	default:
 		break;
 	}
@@ -310,6 +641,7 @@ static void cec_pin_rx_states(struct cec_pin *pin, ktime_t ts)
 	bool ack;
 	bool bcast, for_us;
 	u8 dest;
+	u8 poll;

 	switch (pin->state) {
 	/* Receive states */
@@ -319,24 +651,44 @@ static void cec_pin_rx_states(struct cec_pin *pin, ktime_t ts)
 			break;
 		pin->state = CEC_ST_RX_START_BIT_HIGH;
 		delta = ktime_us_delta(ts, pin->ts);
-		pin->ts = ts;
 		/* Start bit low is too short, go back to idle */
-		if (delta < CEC_TIM_START_BIT_LOW_MIN -
-			    CEC_TIM_IDLE_SAMPLE) {
+		if (delta < CEC_TIM_START_BIT_LOW_MIN - CEC_TIM_IDLE_SAMPLE) {
 			cec_pin_to_idle(pin);
+			break;
+		}
+		if (rx_arb_lost(pin, &poll)) {
+			cec_msg_init(&pin->tx_msg, poll >> 4, poll & 0xf);
+			pin->tx_generated_poll = true;
+			pin->tx_extra_bytes = 0;
+			pin->state = CEC_ST_TX_START_BIT_HIGH;
+			pin->ts = ts;
 		}
 		break;

 	case CEC_ST_RX_START_BIT_HIGH:
 		v = cec_pin_read(pin);
 		delta = ktime_us_delta(ts, pin->ts);
-		if (v && delta > CEC_TIM_START_BIT_TOTAL_MAX -
-				 CEC_TIM_START_BIT_LOW_MIN) {
+		/*
+		 * Unfortunately the spec does not specify when to give up
+		 * and go to idle. We just pick TOTAL_LONG.
+		 */
+		if (v && delta > CEC_TIM_START_BIT_TOTAL_LONG) {
 			cec_pin_to_idle(pin);
 			break;
 		}
 		if (v)
 			break;
+		/* Start bit is too short, go back to idle */
+		if (delta < CEC_TIM_START_BIT_TOTAL_MIN - CEC_TIM_IDLE_SAMPLE) {
+			cec_pin_to_idle(pin);
+			break;
+		}
+		if (rx_low_drive(pin)) {
+			/* Error injection: go to low drive */
+			cec_pin_low(pin);
+			pin->state = CEC_ST_RX_LOW_DRIVE;
+			break;
+		}
 		pin->state = CEC_ST_RX_DATA_SAMPLE;
 		pin->ts = ts;
 		pin->rx_eom = false;
@@ -351,36 +703,48 @@ static void cec_pin_rx_states(struct cec_pin *pin, ktime_t ts)
 				pin->rx_msg.msg[pin->rx_bit / 10] |=
 					v << (7 - (pin->rx_bit % 10));
 			break;
-		case 8:
+		case EOM_BIT:
 			pin->rx_eom = v;
 			pin->rx_msg.len = pin->rx_bit / 10 + 1;
 			break;
-		case 9:
+		case ACK_BIT:
 			break;
 		}
 		pin->rx_bit++;
 		break;

 	case CEC_ST_RX_DATA_POST_SAMPLE:
-		pin->state = CEC_ST_RX_DATA_HIGH;
+		pin->state = CEC_ST_RX_DATA_WAIT_FOR_LOW;
 		break;

-	case CEC_ST_RX_DATA_HIGH:
+	case CEC_ST_RX_DATA_WAIT_FOR_LOW:
 		v = cec_pin_read(pin);
 		delta = ktime_us_delta(ts, pin->ts);
-		if (v && delta > CEC_TIM_DATA_BIT_TOTAL_MAX) {
+		/*
+		 * Unfortunately the spec does not specify when to give up
+		 * and go to idle. We just pick TOTAL_LONG.
+		 */
+		if (v && delta > CEC_TIM_DATA_BIT_TOTAL_LONG) {
 			cec_pin_to_idle(pin);
 			break;
 		}
 		if (v)
 			break;
+
+		if (rx_low_drive(pin)) {
+			/* Error injection: go to low drive */
+			cec_pin_low(pin);
+			pin->state = CEC_ST_RX_LOW_DRIVE;
+			break;
+		}
+
 		/*
 		 * Go to low drive state when the total bit time is
 		 * too short.
 		 */
 		if (delta < CEC_TIM_DATA_BIT_TOTAL_MIN) {
 			cec_pin_low(pin);
-			pin->state = CEC_ST_LOW_DRIVE;
+			pin->state = CEC_ST_RX_LOW_DRIVE;
 			break;
 		}
 		pin->ts = ts;
@@ -396,6 +760,11 @@ static void cec_pin_rx_states(struct cec_pin *pin, ktime_t ts)
 		/* ACK bit value */
 		ack = bcast ? 1 : !for_us;

+		if (for_us && rx_nack(pin)) {
+			/* Error injection: toggle the ACK bit */
+			ack = !ack;
+		}
+
 		if (ack) {
 			/* No need to write to the bus, just wait */
 			pin->state = CEC_ST_RX_ACK_HIGH_POST;
@@ -422,7 +791,7 @@ static void cec_pin_rx_states(struct cec_pin *pin, ktime_t ts)
 			break;
 		}
 		pin->rx_bit++;
-		pin->state = CEC_ST_RX_DATA_HIGH;
+		pin->state = CEC_ST_RX_DATA_WAIT_FOR_LOW;
 		break;

 	case CEC_ST_RX_ACK_FINISH:
@@ -444,6 +813,7 @@ static enum hrtimer_restart cec_pin_timer(struct hrtimer *timer)
 	struct cec_adapter *adap = pin->adap;
 	ktime_t ts;
 	s32 delta;
+	u32 usecs;

 	ts = ktime_get();
 	if (ktime_to_ns(pin->timer_ts)) {
@@ -491,13 +861,27 @@ static enum hrtimer_restart cec_pin_timer(struct hrtimer *timer)
 	/* Transmit states */
 	case CEC_ST_TX_WAIT_FOR_HIGH:
 	case CEC_ST_TX_START_BIT_LOW:
-	case CEC_ST_TX_DATA_BIT_1_HIGH_POST_SAMPLE:
-	case CEC_ST_TX_DATA_BIT_0_HIGH:
-	case CEC_ST_TX_DATA_BIT_1_HIGH:
 	case CEC_ST_TX_START_BIT_HIGH:
+	case CEC_ST_TX_START_BIT_HIGH_SHORT:
+	case CEC_ST_TX_START_BIT_HIGH_LONG:
+	case CEC_ST_TX_START_BIT_LOW_CUSTOM:
+	case CEC_ST_TX_START_BIT_HIGH_CUSTOM:
 	case CEC_ST_TX_DATA_BIT_0_LOW:
+	case CEC_ST_TX_DATA_BIT_0_HIGH:
+	case CEC_ST_TX_DATA_BIT_0_HIGH_SHORT:
+	case CEC_ST_TX_DATA_BIT_0_HIGH_LONG:
 	case CEC_ST_TX_DATA_BIT_1_LOW:
+	case CEC_ST_TX_DATA_BIT_1_HIGH:
+	case CEC_ST_TX_DATA_BIT_1_HIGH_SHORT:
+	case CEC_ST_TX_DATA_BIT_1_HIGH_LONG:
 	case CEC_ST_TX_DATA_BIT_1_HIGH_PRE_SAMPLE:
+	case CEC_ST_TX_DATA_BIT_1_HIGH_POST_SAMPLE:
+	case CEC_ST_TX_DATA_BIT_1_HIGH_POST_SAMPLE_SHORT:
+	case CEC_ST_TX_DATA_BIT_1_HIGH_POST_SAMPLE_LONG:
+	case CEC_ST_TX_DATA_BIT_LOW_CUSTOM:
+	case CEC_ST_TX_DATA_BIT_HIGH_CUSTOM:
+	case CEC_ST_TX_PULSE_LOW_CUSTOM:
+	case CEC_ST_TX_PULSE_HIGH_CUSTOM:
 		cec_pin_tx_states(pin, ts);
 		break;

@@ -506,7 +890,7 @@ static enum hrtimer_restart cec_pin_timer(struct hrtimer *timer)
 	case CEC_ST_RX_START_BIT_HIGH:
 	case CEC_ST_RX_DATA_SAMPLE:
 	case CEC_ST_RX_DATA_POST_SAMPLE:
-	case CEC_ST_RX_DATA_HIGH:
+	case CEC_ST_RX_DATA_WAIT_FOR_LOW:
 	case CEC_ST_RX_ACK_LOW:
 	case CEC_ST_RX_ACK_LOW_POST:
 	case CEC_ST_RX_ACK_HIGH_POST:
@@ -533,7 +917,10 @@ static enum hrtimer_restart cec_pin_timer(struct hrtimer *timer)
 			if (delta / CEC_TIM_DATA_BIT_TOTAL >
 			    pin->tx_signal_free_time) {
 				pin->tx_nacked = false;
-				pin->state = CEC_ST_TX_START_BIT_LOW;
+				if (tx_custom_start(pin))
+					pin->state = CEC_ST_TX_START_BIT_LOW_CUSTOM;
+				else
+					pin->state = CEC_ST_TX_START_BIT_LOW;
 				/* Generate start bit */
 				cec_pin_low(pin);
 				break;
@@ -543,6 +930,13 @@ static enum hrtimer_restart cec_pin_timer(struct hrtimer *timer)
 				pin->state = CEC_ST_TX_WAIT;
 			break;
 		}
+		if (pin->tx_custom_pulse && pin->state == CEC_ST_IDLE) {
+			pin->tx_custom_pulse = false;
+			/* Generate custom pulse */
+			cec_pin_low(pin);
+			pin->state = CEC_ST_TX_PULSE_LOW_CUSTOM;
+			break;
+		}
 		if (pin->state != CEC_ST_IDLE || pin->ops->enable_irq == NULL ||
 		    pin->enable_irq_failed || adap->is_configuring ||
 		    adap->is_configured || adap->monitor_all_cnt)
@@ -553,21 +947,40 @@ static enum hrtimer_restart cec_pin_timer(struct hrtimer *timer)
 		wake_up_interruptible(&pin->kthread_waitq);
 		return HRTIMER_NORESTART;

-	case CEC_ST_LOW_DRIVE:
+	case CEC_ST_TX_LOW_DRIVE:
+	case CEC_ST_RX_LOW_DRIVE:
+		cec_pin_high(pin);
 		cec_pin_to_idle(pin);
 		break;

 	default:
 		break;
 	}
-	if (!adap->monitor_pin_cnt || states[pin->state].usecs <= 150) {
+
+	switch (pin->state) {
+	case CEC_ST_TX_START_BIT_LOW_CUSTOM:
+	case CEC_ST_TX_DATA_BIT_LOW_CUSTOM:
+	case CEC_ST_TX_PULSE_LOW_CUSTOM:
+		usecs = pin->tx_custom_low_usecs;
+		break;
+	case CEC_ST_TX_START_BIT_HIGH_CUSTOM:
+	case CEC_ST_TX_DATA_BIT_HIGH_CUSTOM:
+	case CEC_ST_TX_PULSE_HIGH_CUSTOM:
+		usecs = pin->tx_custom_high_usecs;
+		break;
+	default:
+		usecs = states[pin->state].usecs;
+		break;
+	}
+
+	if (!adap->monitor_pin_cnt || usecs <= 150) {
 		pin->wait_usecs = 0;
-		pin->timer_ts = ktime_add_us(ts, states[pin->state].usecs);
+		pin->timer_ts = ktime_add_us(ts, usecs);
 		hrtimer_forward_now(timer,
-				ns_to_ktime(states[pin->state].usecs * 1000));
+				ns_to_ktime(usecs * 1000));
 		return HRTIMER_RESTART;
 	}
-	pin->wait_usecs = states[pin->state].usecs - 100;
+	pin->wait_usecs = usecs - 100;
 	pin->timer_ts = ktime_add_us(ts, 100);
 	hrtimer_forward_now(timer, ns_to_ktime(100000));
 	return HRTIMER_RESTART;
@@ -587,9 +1000,22 @@ static int cec_pin_thread_func(void *_adap)
 			atomic_read(&pin->work_pin_events));

 		if (pin->work_rx_msg.len) {
-			cec_received_msg_ts(adap, &pin->work_rx_msg,
+			struct cec_msg *msg = &pin->work_rx_msg;
+
+			if (msg->len > 1 && msg->len < CEC_MAX_MSG_SIZE &&
+			    rx_add_byte(pin)) {
+				/* Error injection: add byte to the message */
+				msg->msg[msg->len++] = 0x55;
+			}
+			if (msg->len > 2 && rx_remove_byte(pin)) {
+				/* Error injection: remove byte from message */
+				msg->len--;
+			}
+			if (msg->len > CEC_MAX_MSG_SIZE)
+				msg->len = CEC_MAX_MSG_SIZE;
+			cec_received_msg_ts(adap, msg,
 				ns_to_ktime(pin->work_rx_msg.rx_ts));
-			pin->work_rx_msg.len = 0;
+			msg->len = 0;
 		}
 		if (pin->work_tx_status) {
 			unsigned int tx_status = pin->work_tx_status;
@@ -698,7 +1124,16 @@ static int cec_pin_adap_transmit(struct cec_adapter *adap, u8 attempts,
 	struct cec_pin *pin = adap->pin;

 	pin->tx_signal_free_time = signal_free_time;
+	pin->tx_extra_bytes = 0;
 	pin->tx_msg = *msg;
+	if (msg->len > 1) {
+		/* Error injection: add byte to the message */
+		pin->tx_extra_bytes = tx_add_bytes(pin);
+	}
+	if (msg->len > 2 && tx_remove_byte(pin)) {
+		/* Error injection: remove byte from the message */
+		pin->tx_msg.len--;
+	}
 	pin->work_tx_status = 0;
 	pin->tx_bit = 0;
 	cec_pin_start_timer(pin);
-- 
2.16.1
