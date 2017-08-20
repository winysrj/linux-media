Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:34830 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752844AbdHTLxZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Aug 2017 07:53:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/4] vivid: add CEC pin monitoring emulation
Date: Sun, 20 Aug 2017 13:53:17 +0200
Message-Id: <20170820115319.26244-3-hverkuil@xs4all.nl>
In-Reply-To: <20170820115319.26244-1-hverkuil@xs4all.nl>
References: <20170820115319.26244-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add support to emulate CEC pin monitoring. There are few hardware devices
that support this, so being able to emulate it here helps developing
software for this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-cec.c | 65 +++++++++++++++++++++++++++++++-
 1 file changed, 64 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vivid/vivid-cec.c b/drivers/media/platform/vivid/vivid-cec.c
index 43992fa92a88..643eeba79912 100644
--- a/drivers/media/platform/vivid/vivid-cec.c
+++ b/drivers/media/platform/vivid/vivid-cec.c
@@ -22,6 +22,15 @@
 #include "vivid-core.h"
 #include "vivid-cec.h"
 
+#define CEC_TIM_START_BIT_TOTAL		4500
+#define CEC_TIM_START_BIT_LOW		3700
+#define CEC_TIM_START_BIT_HIGH		800
+#define CEC_TIM_DATA_BIT_TOTAL		2400
+#define CEC_TIM_DATA_BIT_0_LOW		1500
+#define CEC_TIM_DATA_BIT_0_HIGH		900
+#define CEC_TIM_DATA_BIT_1_LOW		600
+#define CEC_TIM_DATA_BIT_1_HIGH		1800
+
 void vivid_cec_bus_free_work(struct vivid_dev *dev)
 {
 	spin_lock(&dev->cec_slock);
@@ -64,6 +73,58 @@ static bool vivid_cec_find_dest_adap(struct vivid_dev *dev,
 	return false;
 }
 
+static void vivid_cec_pin_adap_events(struct cec_adapter *adap, ktime_t ts,
+				      const struct cec_msg *msg, bool nacked)
+{
+	unsigned int len = nacked ? 1 : msg->len;
+	unsigned int i;
+	bool bit;
+
+	if (adap == NULL)
+		return;
+	ts = ktime_sub_us(ts, (CEC_TIM_START_BIT_TOTAL +
+			       len * 10 * CEC_TIM_DATA_BIT_TOTAL));
+	cec_queue_pin_event(adap, false, ts);
+	ts = ktime_add_us(ts, CEC_TIM_START_BIT_LOW);
+	cec_queue_pin_event(adap, true, ts);
+	ts = ktime_add_us(ts, CEC_TIM_START_BIT_HIGH);
+
+	for (i = 0; i < 10 * len; i++) {
+		switch (i % 10) {
+		case 0 ... 7:
+			bit = msg->msg[i / 10] & (0x80 >> (i % 10));
+			break;
+		case 8: /* EOM */
+			bit = i / 10 == msg->len - 1;
+			break;
+		case 9: /* ACK */
+			bit = cec_msg_is_broadcast(msg) ^ nacked;
+			break;
+		}
+		cec_queue_pin_event(adap, false, ts);
+		if (bit)
+			ts = ktime_add_us(ts, CEC_TIM_DATA_BIT_1_LOW);
+		else
+			ts = ktime_add_us(ts, CEC_TIM_DATA_BIT_0_LOW);
+		cec_queue_pin_event(adap, true, ts);
+		if (bit)
+			ts = ktime_add_us(ts, CEC_TIM_DATA_BIT_1_HIGH);
+		else
+			ts = ktime_add_us(ts, CEC_TIM_DATA_BIT_0_HIGH);
+	}
+}
+
+static void vivid_cec_pin_events(struct vivid_dev *dev,
+				 const struct cec_msg *msg, bool nacked)
+{
+	ktime_t ts = ktime_get();
+	unsigned int i;
+
+	vivid_cec_pin_adap_events(dev->cec_rx_adap, ts, msg, nacked);
+	for (i = 0; i < MAX_OUTPUTS; i++)
+		vivid_cec_pin_adap_events(dev->cec_tx_adap[i], ts, msg, nacked);
+}
+
 static void vivid_cec_xfer_done_worker(struct work_struct *work)
 {
 	struct vivid_cec_work *cw =
@@ -84,6 +145,7 @@ static void vivid_cec_xfer_done_worker(struct work_struct *work)
 	dev->cec_xfer_start_jiffies = 0;
 	list_del(&cw->list);
 	spin_unlock(&dev->cec_slock);
+	vivid_cec_pin_events(dev, &cw->msg, !valid_dest);
 	cec_transmit_attempt_done(cw->adap, cw->tx_status);
 
 	/* Broadcast message */
@@ -118,6 +180,7 @@ static void vivid_cec_xfer_try_worker(struct work_struct *work)
 
 static int vivid_cec_adap_enable(struct cec_adapter *adap, bool enable)
 {
+	adap->cec_pin_is_high = true;
 	return 0;
 }
 
@@ -219,7 +282,7 @@ struct cec_adapter *vivid_cec_alloc_adap(struct vivid_dev *dev,
 					 bool is_source)
 {
 	char name[sizeof(dev->vid_out_dev.name) + 2];
-	u32 caps = CEC_CAP_DEFAULTS | CEC_CAP_MONITOR_ALL;
+	u32 caps = CEC_CAP_DEFAULTS | CEC_CAP_MONITOR_ALL | CEC_CAP_MONITOR_PIN;
 
 	snprintf(name, sizeof(name), "%s%d",
 		 is_source ? dev->vid_out_dev.name : dev->vid_cap_dev.name,
-- 
2.14.1
