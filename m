Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:39237 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750725AbdKEMgl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 5 Nov 2017 07:36:41 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec: add the adap_monitor_pin_enable op
Message-ID: <b3b358ca-df79-a363-69b9-0e5e0b718447@xs4all.nl>
Date: Sun, 5 Nov 2017 13:36:36 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some devices can monitor the CEC pin using an interrupt, but you
only want to enable the interrupt if you actually switch to pin
monitoring mode.

So add a new op that is called when pin monitoring needs to be
switched on or off.

Also fix a small bug where the initial CEC pin event was sent
again when calling S_MODE twice with the same CEC_MODE_MONITOR_PIN
mode.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
---
 drivers/media/cec/cec-adap.c | 23 +++++++++++++++++++++++
 drivers/media/cec/cec-api.c  | 21 ++++++++++++++++-----
 drivers/media/cec/cec-priv.h |  2 ++
 include/media/cec.h          |  1 +
 4 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index 98f88c43f62c..9219dc96d575 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -2053,6 +2053,29 @@ void cec_monitor_all_cnt_dec(struct cec_adapter *adap)
 		WARN_ON(call_op(adap, adap_monitor_all_enable, 0));
 }

+/*
+ * Helper functions to keep track of the 'monitor pin' use count.
+ *
+ * These functions are called with adap->lock held.
+ */
+int cec_monitor_pin_cnt_inc(struct cec_adapter *adap)
+{
+	int ret = 0;
+
+	if (adap->monitor_pin_cnt == 0)
+		ret = call_op(adap, adap_monitor_pin_enable, 1);
+	if (ret == 0)
+		adap->monitor_pin_cnt++;
+	return ret;
+}
+
+void cec_monitor_pin_cnt_dec(struct cec_adapter *adap)
+{
+	adap->monitor_pin_cnt--;
+	if (adap->monitor_pin_cnt == 0)
+		WARN_ON(call_op(adap, adap_monitor_pin_enable, 0));
+}
+
 #ifdef CONFIG_DEBUG_FS
 /*
  * Log the current state of the CEC adapter.
diff --git a/drivers/media/cec/cec-api.c b/drivers/media/cec/cec-api.c
index 3dba3aa34a43..3eb4a069cde8 100644
--- a/drivers/media/cec/cec-api.c
+++ b/drivers/media/cec/cec-api.c
@@ -354,6 +354,7 @@ static long cec_s_mode(struct cec_adapter *adap, struct cec_fh *fh,
 	u32 mode;
 	u8 mode_initiator;
 	u8 mode_follower;
+	bool send_pin_event = false;
 	long err = 0;

 	if (copy_from_user(&mode, parg, sizeof(mode)))
@@ -433,6 +434,19 @@ static long cec_s_mode(struct cec_adapter *adap, struct cec_fh *fh,
 		}
 	}

+	if (!err) {
+		bool old_mon_pin = fh->mode_follower == CEC_MODE_MONITOR_PIN;
+		bool new_mon_pin = mode_follower == CEC_MODE_MONITOR_PIN;
+
+		if (old_mon_pin != new_mon_pin) {
+			send_pin_event = new_mon_pin;
+			if (new_mon_pin)
+				err = cec_monitor_pin_cnt_inc(adap);
+			else
+				cec_monitor_pin_cnt_dec(adap);
+		}
+	}
+
 	if (err) {
 		mutex_unlock(&adap->lock);
 		return err;
@@ -440,11 +454,9 @@ static long cec_s_mode(struct cec_adapter *adap, struct cec_fh *fh,

 	if (fh->mode_follower == CEC_MODE_FOLLOWER)
 		adap->follower_cnt--;
-	if (fh->mode_follower == CEC_MODE_MONITOR_PIN)
-		adap->monitor_pin_cnt--;
 	if (mode_follower == CEC_MODE_FOLLOWER)
 		adap->follower_cnt++;
-	if (mode_follower == CEC_MODE_MONITOR_PIN) {
+	if (send_pin_event) {
 		struct cec_event ev = {
 			.flags = CEC_EVENT_FL_INITIAL_STATE,
 		};
@@ -452,7 +464,6 @@ static long cec_s_mode(struct cec_adapter *adap, struct cec_fh *fh,
 		ev.event = adap->cec_pin_is_high ? CEC_EVENT_PIN_CEC_HIGH :
 						   CEC_EVENT_PIN_CEC_LOW;
 		cec_queue_event_fh(fh, &ev, 0);
-		adap->monitor_pin_cnt++;
 	}
 	if (mode_follower == CEC_MODE_EXCL_FOLLOWER ||
 	    mode_follower == CEC_MODE_EXCL_FOLLOWER_PASSTHRU) {
@@ -608,7 +619,7 @@ static int cec_release(struct inode *inode, struct file *filp)
 	if (fh->mode_follower == CEC_MODE_FOLLOWER)
 		adap->follower_cnt--;
 	if (fh->mode_follower == CEC_MODE_MONITOR_PIN)
-		adap->monitor_pin_cnt--;
+		cec_monitor_pin_cnt_dec(adap);
 	if (fh->mode_follower == CEC_MODE_MONITOR_ALL)
 		cec_monitor_all_cnt_dec(adap);
 	mutex_unlock(&adap->lock);
diff --git a/drivers/media/cec/cec-priv.h b/drivers/media/cec/cec-priv.h
index 70767a7900f2..daf597643af8 100644
--- a/drivers/media/cec/cec-priv.h
+++ b/drivers/media/cec/cec-priv.h
@@ -40,6 +40,8 @@ void cec_put_device(struct cec_devnode *devnode);
 /* cec-adap.c */
 int cec_monitor_all_cnt_inc(struct cec_adapter *adap);
 void cec_monitor_all_cnt_dec(struct cec_adapter *adap);
+int cec_monitor_pin_cnt_inc(struct cec_adapter *adap);
+void cec_monitor_pin_cnt_dec(struct cec_adapter *adap);
 int cec_adap_status(struct seq_file *file, void *priv);
 int cec_thread_func(void *_adap);
 void __cec_s_phys_addr(struct cec_adapter *adap, u16 phys_addr, bool block);
diff --git a/include/media/cec.h b/include/media/cec.h
index 16341210d3ba..dd781e928b72 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -122,6 +122,7 @@ struct cec_adap_ops {
 	/* Low-level callbacks */
 	int (*adap_enable)(struct cec_adapter *adap, bool enable);
 	int (*adap_monitor_all_enable)(struct cec_adapter *adap, bool enable);
+	int (*adap_monitor_pin_enable)(struct cec_adapter *adap, bool enable);
 	int (*adap_log_addr)(struct cec_adapter *adap, u8 logical_addr);
 	int (*adap_transmit)(struct cec_adapter *adap, u8 attempts,
 			     u32 signal_free_time, struct cec_msg *msg);
-- 
2.14.1
