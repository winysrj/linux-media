Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:55561 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728582AbeJEUgi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 Oct 2018 16:36:38 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 6/6] cec-gpio: select correct Signal Free Time
Date: Fri,  5 Oct 2018 15:37:45 +0200
Message-Id: <20181005133745.8593-7-hverkuil@xs4all.nl>
In-Reply-To: <20181005133745.8593-1-hverkuil@xs4all.nl>
References: <20181005133745.8593-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

If a receive is in progress or starts before the transmit has
a chance, then lower the Signal Free Time of the upcoming transmit
to no more than CEC_SIGNAL_FREE_TIME_NEW_INITIATOR.

This is per the specification requirements.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/cec/cec-pin.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/media/cec/cec-pin.c b/drivers/media/cec/cec-pin.c
index 6e311424f0dc..635db8e70ead 100644
--- a/drivers/media/cec/cec-pin.c
+++ b/drivers/media/cec/cec-pin.c
@@ -935,6 +935,17 @@ static enum hrtimer_restart cec_pin_timer(struct hrtimer *timer)
 			/* Start bit, switch to receive state */
 			pin->ts = ts;
 			pin->state = CEC_ST_RX_START_BIT_LOW;
+			/*
+			 * If a transmit is pending, then that transmit should
+			 * use a signal free time of no more than
+			 * CEC_SIGNAL_FREE_TIME_NEW_INITIATOR since it will
+			 * have a new initiator due to the receive that is now
+			 * starting.
+			 */
+			if (pin->tx_msg.len && pin->tx_signal_free_time >
+			    CEC_SIGNAL_FREE_TIME_NEW_INITIATOR)
+				pin->tx_signal_free_time =
+					CEC_SIGNAL_FREE_TIME_NEW_INITIATOR;
 			break;
 		}
 		if (ktime_to_ns(pin->ts) == 0)
@@ -1157,6 +1168,15 @@ static int cec_pin_adap_transmit(struct cec_adapter *adap, u8 attempts,
 {
 	struct cec_pin *pin = adap->pin;
 
+	/*
+	 * If a receive is in progress, then this transmit should use
+	 * a signal free time of max CEC_SIGNAL_FREE_TIME_NEW_INITIATOR
+	 * since when it starts transmitting it will have a new initiator.
+	 */
+	if (pin->state != CEC_ST_IDLE &&
+	    signal_free_time > CEC_SIGNAL_FREE_TIME_NEW_INITIATOR)
+		signal_free_time = CEC_SIGNAL_FREE_TIME_NEW_INITIATOR;
+
 	pin->tx_signal_free_time = signal_free_time;
 	pin->tx_extra_bytes = 0;
 	pin->tx_msg = *msg;
-- 
2.18.0
