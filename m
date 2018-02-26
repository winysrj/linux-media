Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:38666 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751697AbeBZI5M (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Feb 2018 03:57:12 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, dri-devel@lists.freedesktop.org,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/6] cec-pin: create cec_pin_start_timer() function
Date: Mon, 26 Feb 2018 09:57:03 +0100
Message-Id: <20180226085706.41526-4-hverkuil@xs4all.nl>
In-Reply-To: <20180226085706.41526-1-hverkuil@xs4all.nl>
References: <20180226085706.41526-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This function will be needed for injecting a custom pulse.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/cec/cec-pin-priv.h |  2 ++
 drivers/media/cec/cec-pin.c      | 21 +++++++++++++--------
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/media/cec/cec-pin-priv.h b/drivers/media/cec/cec-pin-priv.h
index cf41c4236efd..4571a0001a9d 100644
--- a/drivers/media/cec/cec-pin-priv.h
+++ b/drivers/media/cec/cec-pin-priv.h
@@ -118,4 +118,6 @@ struct cec_pin {
 	u32				timer_sum_overrun;
 };
 
+void cec_pin_start_timer(struct cec_pin *pin);
+
 #endif
diff --git a/drivers/media/cec/cec-pin.c b/drivers/media/cec/cec-pin.c
index 8e834b9f72c6..67d6ea9f56b6 100644
--- a/drivers/media/cec/cec-pin.c
+++ b/drivers/media/cec/cec-pin.c
@@ -680,6 +680,18 @@ static int cec_pin_adap_log_addr(struct cec_adapter *adap, u8 log_addr)
 	return 0;
 }
 
+void cec_pin_start_timer(struct cec_pin *pin)
+{
+	if (pin->state != CEC_ST_RX_IRQ)
+		return;
+
+	atomic_set(&pin->work_irq_change, CEC_PIN_IRQ_UNCHANGED);
+	pin->ops->disable_irq(pin->adap);
+	cec_pin_high(pin);
+	cec_pin_to_idle(pin);
+	hrtimer_start(&pin->timer, ns_to_ktime(0), HRTIMER_MODE_REL);
+}
+
 static int cec_pin_adap_transmit(struct cec_adapter *adap, u8 attempts,
 				      u32 signal_free_time, struct cec_msg *msg)
 {
@@ -689,14 +701,7 @@ static int cec_pin_adap_transmit(struct cec_adapter *adap, u8 attempts,
 	pin->tx_msg = *msg;
 	pin->work_tx_status = 0;
 	pin->tx_bit = 0;
-	if (pin->state == CEC_ST_RX_IRQ) {
-		atomic_set(&pin->work_irq_change, CEC_PIN_IRQ_UNCHANGED);
-		pin->ops->disable_irq(adap);
-		cec_pin_high(pin);
-		cec_pin_to_idle(pin);
-		hrtimer_start(&pin->timer, ns_to_ktime(0),
-			      HRTIMER_MODE_REL);
-	}
+	cec_pin_start_timer(pin);
 	return 0;
 }
 
-- 
2.15.1
