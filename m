Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:41705 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755234AbdGKGav (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Jul 2017 02:30:51 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 08/11] cec: add core support for low-level CEC pin monitoring
Date: Tue, 11 Jul 2017 08:30:41 +0200
Message-Id: <20170711063044.29849-9-hverkuil@xs4all.nl>
In-Reply-To: <20170711063044.29849-1-hverkuil@xs4all.nl>
References: <20170711063044.29849-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add support for the new MONITOR_PIN mode.

Add the cec_pin_event function that the CEC pin code will call to queue pin
change events.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/cec/cec-adap.c | 16 ++++++++++++++++
 drivers/media/cec/cec-api.c  | 15 +++++++++++++--
 include/media/cec.h          | 11 +++++++++++
 3 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index 67ec66c7c4ff..cbde6b015ff5 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -153,6 +153,22 @@ static void cec_queue_event(struct cec_adapter *adap,
 	mutex_unlock(&adap->devnode.lock);
 }
 
+/* Notify userspace that the CEC pin changed state at the given time. */
+void cec_queue_pin_event(struct cec_adapter *adap, bool is_high, ktime_t ts)
+{
+	struct cec_event ev = {
+		.event = is_high ? CEC_EVENT_PIN_HIGH : CEC_EVENT_PIN_LOW,
+	};
+	struct cec_fh *fh;
+
+	mutex_lock(&adap->devnode.lock);
+	list_for_each_entry(fh, &adap->devnode.fhs, list)
+		if (fh->mode_follower == CEC_MODE_MONITOR_PIN)
+			cec_queue_event_fh(fh, &ev, ktime_to_ns(ts));
+	mutex_unlock(&adap->devnode.lock);
+}
+EXPORT_SYMBOL_GPL(cec_queue_pin_event);
+
 /*
  * Queue a new message for this filehandle.
  *
diff --git a/drivers/media/cec/cec-api.c b/drivers/media/cec/cec-api.c
index 48bef1c718ad..14279958dca1 100644
--- a/drivers/media/cec/cec-api.c
+++ b/drivers/media/cec/cec-api.c
@@ -370,6 +370,10 @@ static long cec_s_mode(struct cec_adapter *adap, struct cec_fh *fh,
 	    !(adap->capabilities & CEC_CAP_MONITOR_ALL))
 		return -EINVAL;
 
+	if (mode_follower == CEC_MODE_MONITOR_PIN &&
+	    !(adap->capabilities & CEC_CAP_MONITOR_PIN))
+		return -EINVAL;
+
 	/* Follower modes should always be able to send CEC messages */
 	if ((mode_initiator == CEC_MODE_NO_INITIATOR ||
 	     !(adap->capabilities & CEC_CAP_TRANSMIT)) &&
@@ -378,11 +382,11 @@ static long cec_s_mode(struct cec_adapter *adap, struct cec_fh *fh,
 		return -EINVAL;
 
 	/* Monitor modes require CEC_MODE_NO_INITIATOR */
-	if (mode_initiator && mode_follower >= CEC_MODE_MONITOR)
+	if (mode_initiator && mode_follower >= CEC_MODE_MONITOR_PIN)
 		return -EINVAL;
 
 	/* Monitor modes require CAP_NET_ADMIN */
-	if (mode_follower >= CEC_MODE_MONITOR && !capable(CAP_NET_ADMIN))
+	if (mode_follower >= CEC_MODE_MONITOR_PIN && !capable(CAP_NET_ADMIN))
 		return -EPERM;
 
 	mutex_lock(&adap->lock);
@@ -421,8 +425,13 @@ static long cec_s_mode(struct cec_adapter *adap, struct cec_fh *fh,
 
 	if (fh->mode_follower == CEC_MODE_FOLLOWER)
 		adap->follower_cnt--;
+	if (fh->mode_follower == CEC_MODE_MONITOR_PIN)
+		adap->monitor_pin_cnt--;
 	if (mode_follower == CEC_MODE_FOLLOWER)
 		adap->follower_cnt++;
+	if (mode_follower == CEC_MODE_MONITOR_PIN) {
+		adap->monitor_pin_cnt++;
+	}
 	if (mode_follower == CEC_MODE_EXCL_FOLLOWER ||
 	    mode_follower == CEC_MODE_EXCL_FOLLOWER_PASSTHRU) {
 		adap->passthrough =
@@ -566,6 +575,8 @@ static int cec_release(struct inode *inode, struct file *filp)
 	}
 	if (fh->mode_follower == CEC_MODE_FOLLOWER)
 		adap->follower_cnt--;
+	if (fh->mode_follower == CEC_MODE_MONITOR_PIN)
+		adap->monitor_pin_cnt--;
 	if (fh->mode_follower == CEC_MODE_MONITOR_ALL)
 		cec_monitor_all_cnt_dec(adap);
 	mutex_unlock(&adap->lock);
diff --git a/include/media/cec.h b/include/media/cec.h
index 6cc862af74e5..d983960b37ad 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -177,6 +177,7 @@ struct cec_adapter {
 	bool is_configuring;
 	bool is_configured;
 	u32 monitor_all_cnt;
+	u32 monitor_pin_cnt;
 	u32 follower_cnt;
 	struct cec_fh *cec_follower;
 	struct cec_fh *cec_initiator;
@@ -272,6 +273,16 @@ static inline void cec_received_msg(struct cec_adapter *adap,
 }
 
 /**
+ * cec_queue_pin_event() - queue a pin event with a given timestamp.
+ *
+ * @adap:	pointer to the cec adapter
+ * @is_high:	when true the pin is high, otherwise it is low
+ * @ts:		the timestamp for this event
+ *
+ */
+void cec_queue_pin_event(struct cec_adapter *adap, bool is_high, ktime_t ts);
+
+/**
  * cec_get_edid_phys_addr() - find and return the physical address
  *
  * @edid:	pointer to the EDID data
-- 
2.11.0
