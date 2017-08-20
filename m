Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:60466 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752890AbdHTLxZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Aug 2017 07:53:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/4] cec: replace pin->cur_value by adap->cec_pin_is_high
Date: Sun, 20 Aug 2017 13:53:16 +0200
Message-Id: <20170820115319.26244-2-hverkuil@xs4all.nl>
In-Reply-To: <20170820115319.26244-1-hverkuil@xs4all.nl>
References: <20170820115319.26244-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The current CEC pin value (0 or 1) was part of the cec_pin struct,
but that assumes that CEC pin monitoring can only be used with
a driver that uses the low-level CEC pin framework.

But hardware that has both a high-level API and can monitor the
CEC pin at low-level at the same time does not need to depend on
the cec pin framework.

To support such devices remove the cur_value field from struct cec_pin
and add a cec_pin_is_high field to cec_adapter. This also makes it
possible to drop the '#ifdef CONFIG_CEC_PIN' in cec-api.c.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/cec/cec-api.c  | 6 ++----
 drivers/media/cec/cec-core.c | 1 +
 drivers/media/cec/cec-pin.c  | 5 ++---
 include/media/cec-pin.h      | 1 -
 include/media/cec.h          | 1 +
 5 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/media/cec/cec-api.c b/drivers/media/cec/cec-api.c
index 00d43d74020f..d1393a950c0d 100644
--- a/drivers/media/cec/cec-api.c
+++ b/drivers/media/cec/cec-api.c
@@ -444,15 +444,13 @@ static long cec_s_mode(struct cec_adapter *adap, struct cec_fh *fh,
 	if (mode_follower == CEC_MODE_FOLLOWER)
 		adap->follower_cnt++;
 	if (mode_follower == CEC_MODE_MONITOR_PIN) {
-#ifdef CONFIG_CEC_PIN
 		struct cec_event ev = {
 			.flags = CEC_EVENT_FL_INITIAL_STATE,
 		};
 
-		ev.event = adap->pin->cur_value ? CEC_EVENT_PIN_HIGH :
-						  CEC_EVENT_PIN_LOW;
+		ev.event = adap->cec_pin_is_high ? CEC_EVENT_PIN_HIGH :
+						   CEC_EVENT_PIN_LOW;
 		cec_queue_event_fh(fh, &ev, 0);
-#endif
 		adap->monitor_pin_cnt++;
 	}
 	if (mode_follower == CEC_MODE_EXCL_FOLLOWER ||
diff --git a/drivers/media/cec/cec-core.c b/drivers/media/cec/cec-core.c
index 52f085ba104a..f344a2ddef7f 100644
--- a/drivers/media/cec/cec-core.c
+++ b/drivers/media/cec/cec-core.c
@@ -227,6 +227,7 @@ struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
 		return ERR_PTR(-ENOMEM);
 	strlcpy(adap->name, name, sizeof(adap->name));
 	adap->phys_addr = CEC_PHYS_ADDR_INVALID;
+	adap->cec_pin_is_high = true;
 	adap->log_addrs.cec_version = CEC_OP_CEC_VERSION_2_0;
 	adap->log_addrs.vendor_id = CEC_VENDOR_ID_NONE;
 	adap->capabilities = caps;
diff --git a/drivers/media/cec/cec-pin.c b/drivers/media/cec/cec-pin.c
index 03f800e5ec1f..589d4a640e8c 100644
--- a/drivers/media/cec/cec-pin.c
+++ b/drivers/media/cec/cec-pin.c
@@ -88,10 +88,10 @@ static const struct cec_state states[CEC_PIN_STATES] = {
 
 static void cec_pin_update(struct cec_pin *pin, bool v, bool force)
 {
-	if (!force && v == pin->cur_value)
+	if (!force && v == pin->adap->cec_pin_is_high)
 		return;
 
-	pin->cur_value = v;
+	pin->adap->cec_pin_is_high = v;
 	if (atomic_read(&pin->work_pin_events) < CEC_NUM_PIN_EVENTS) {
 		pin->work_pin_is_high[pin->work_pin_events_wr] = v;
 		pin->work_pin_ts[pin->work_pin_events_wr] = ktime_get();
@@ -772,7 +772,6 @@ struct cec_adapter *cec_pin_allocate_adapter(const struct cec_pin_ops *pin_ops,
 	if (pin == NULL)
 		return ERR_PTR(-ENOMEM);
 	pin->ops = pin_ops;
-	pin->cur_value = true;
 	hrtimer_init(&pin->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	pin->timer.function = cec_pin_timer;
 	init_waitqueue_head(&pin->kthread_waitq);
diff --git a/include/media/cec-pin.h b/include/media/cec-pin.h
index 44b82d29d480..a60975d960ca 100644
--- a/include/media/cec-pin.h
+++ b/include/media/cec-pin.h
@@ -124,7 +124,6 @@ struct cec_pin {
 	u16				la_mask;
 	bool				enabled;
 	bool				monitor_all;
-	bool				cur_value;
 	bool				rx_eom;
 	bool				enable_irq_failed;
 	enum cec_pin_state		state;
diff --git a/include/media/cec.h b/include/media/cec.h
index 1bec7bde4792..63a2b8544f53 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -180,6 +180,7 @@ struct cec_adapter {
 	bool needs_hpd;
 	bool is_configuring;
 	bool is_configured;
+	bool cec_pin_is_high;
 	u32 monitor_all_cnt;
 	u32 monitor_pin_cnt;
 	u32 follower_cnt;
-- 
2.14.1
