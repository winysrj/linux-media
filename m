Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:39505 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752944AbeCYA3w (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Mar 2018 20:29:52 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, jasmin@anw.at
Subject: [PATCH] media: cec-pin: Fixed ktime_t to ns conversion
Date: Sun, 25 Mar 2018 01:29:46 +0100
Message-Id: <1521937786-28152-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Older Kernels use a struct for ktime_t, which requires the conversion
function ktime_to_ns to be used on some places. With this patch it will
compile now also for older Kernel versions.

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/media/cec/cec-pin.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/cec/cec-pin.c b/drivers/media/cec/cec-pin.c
index fafe1eb..2a5df99 100644
--- a/drivers/media/cec/cec-pin.c
+++ b/drivers/media/cec/cec-pin.c
@@ -668,7 +668,7 @@ static void cec_pin_rx_states(struct cec_pin *pin, ktime_t ts)
 		/* Start bit low is too short, go back to idle */
 		if (delta < CEC_TIM_START_BIT_LOW_MIN - CEC_TIM_IDLE_SAMPLE) {
 			if (!pin->rx_start_bit_low_too_short_cnt++) {
-				pin->rx_start_bit_low_too_short_ts = pin->ts;
+				pin->rx_start_bit_low_too_short_ts = ktime_to_ns(pin->ts);
 				pin->rx_start_bit_low_too_short_delta = delta;
 			}
 			cec_pin_to_idle(pin);
@@ -700,7 +700,7 @@ static void cec_pin_rx_states(struct cec_pin *pin, ktime_t ts)
 		/* Start bit is too short, go back to idle */
 		if (delta < CEC_TIM_START_BIT_TOTAL_MIN - CEC_TIM_IDLE_SAMPLE) {
 			if (!pin->rx_start_bit_too_short_cnt++) {
-				pin->rx_start_bit_too_short_ts = pin->ts;
+				pin->rx_start_bit_too_short_ts = ktime_to_ns(pin->ts);
 				pin->rx_start_bit_too_short_delta = delta;
 			}
 			cec_pin_to_idle(pin);
@@ -770,7 +770,7 @@ static void cec_pin_rx_states(struct cec_pin *pin, ktime_t ts)
 		 */
 		if (delta < CEC_TIM_DATA_BIT_TOTAL_MIN) {
 			if (!pin->rx_data_bit_too_short_cnt++) {
-				pin->rx_data_bit_too_short_ts = pin->ts;
+				pin->rx_data_bit_too_short_ts = ktime_to_ns(pin->ts);
 				pin->rx_data_bit_too_short_delta = delta;
 			}
 			cec_pin_low(pin);
-- 
2.7.4
