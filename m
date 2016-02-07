Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33366 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121AbcBGUOW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Feb 2016 15:14:22 -0500
Received: by mail-wm0-f66.google.com with SMTP id r129so12481356wmr.0
        for <linux-media@vger.kernel.org>; Sun, 07 Feb 2016 12:14:21 -0800 (PST)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 1/3] media: rc: add core functionality to store the most
 recent raw data
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <56B7A57C.1070506@gmail.com>
Date: Sun, 7 Feb 2016 21:13:48 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add functionality to the core to store the most recent raw packet.
It's used to expose this data via sysfs.

To use this functionality a driver has to set enable_sysfs_lrp
in struct rc_dev and add a call to ir_raw_store_sysfs_lrp
for storing a raw byte into the buffer.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/rc-core-priv.h |  6 ++++++
 drivers/media/rc/rc-ir-raw.c    | 34 ++++++++++++++++++++++++++++++++++
 include/media/rc-core.h         |  3 +++
 3 files changed, 43 insertions(+)

diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 585d5e5..6193883 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -19,6 +19,8 @@
 /* Define the max number of pulse/space transitions to buffer */
 #define	MAX_IR_EVENT_SIZE	512
 
+#define	BUF_SYSFS_LRP_SZ	128
+
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <media/rc-core.h>
@@ -43,6 +45,10 @@ struct ir_raw_event_ctrl {
 	ktime_t				last_event;	/* when last event occurred */
 	enum raw_event_type		last_type;	/* last event type */
 	struct rc_dev			*dev;		/* pointer to the parent rc_dev */
+	/* used for exposing the last raw packets via sysfs */
+	u8				buf_sysfs_lrp[BUF_SYSFS_LRP_SZ];
+	unsigned			buf_sysfs_lrp_cnt;
+	ktime_t				buf_sysfs_lrp_last;
 
 	/* raw decoder state follows */
 	struct ir_raw_event prev_ev;
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index 144304c..6bf2b56 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -20,6 +20,8 @@
 #include <linux/freezer.h>
 #include "rc-core-priv.h"
 
+#define	RESTART_SYSFS_LRP_MS	1000
+
 /* Used to keep track of IR raw clients, protected by ir_raw_handler_lock */
 static LIST_HEAD(ir_raw_client_list);
 
@@ -66,6 +68,38 @@ static int ir_raw_event_thread(void *data)
 }
 
 /**
+ * ir_raw_store_sysfs_lrp() - pass a raw byte to sysfs buffer
+ * @dev:	the struct rc_dev device descriptor
+ * @val:	the raw value to store
+ *
+ * This routine (which may be called from interrupt context) stores a
+ * raw byte in the sysfs buffer. It only needs to be called if the most
+ * recent series of raw bytes should be available via sysfs.
+ */
+void ir_raw_store_sysfs_lrp(struct rc_dev *dev, u8 val)
+{
+	ktime_t now;
+	struct ir_raw_event_ctrl *raw = dev->raw;
+
+	if (!raw || !dev->enable_sysfs_lrp)
+		return;
+
+	now = ktime_get();
+	spin_lock(&raw->lock);
+
+	if (ktime_ms_delta(now, raw->buf_sysfs_lrp_last) >
+	    RESTART_SYSFS_LRP_MS)
+		raw->buf_sysfs_lrp_cnt = 0;
+	raw->buf_sysfs_lrp_last = now;
+
+	if (raw->buf_sysfs_lrp_cnt < BUF_SYSFS_LRP_SZ)
+		raw->buf_sysfs_lrp[raw->buf_sysfs_lrp_cnt++] = val;
+
+	spin_unlock(&raw->lock);
+}
+EXPORT_SYMBOL_GPL(ir_raw_store_sysfs_lrp);
+
+/**
  * ir_raw_event_store() - pass a pulse/space duration to the raw ir decoders
  * @dev:	the struct rc_dev device descriptor
  * @ev:		the struct ir_raw_event descriptor of the pulse/space
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index f649470..9542891 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -71,6 +71,7 @@ enum rc_filter_type {
  *	anyone can call show_protocols or store_protocols
  * @minor: unique minor remote control device number
  * @raw: additional data for raw pulse/space devices
+ * @enable_sysfs_lrp: expose last raw packets via sysfs
  * @input_dev: the input child device used to communicate events to userspace
  * @driver_type: specifies if protocol decoding is done in hardware or software
  * @idle: used to keep track of RX state
@@ -131,6 +132,7 @@ struct rc_dev {
 	struct mutex			lock;
 	unsigned int			minor;
 	struct ir_raw_event_ctrl	*raw;
+	bool				enable_sysfs_lrp;
 	struct input_dev		*input_dev;
 	enum rc_driver_type		driver_type;
 	bool				idle;
@@ -246,6 +248,7 @@ static inline void init_ir_raw_event(struct ir_raw_event *ev)
 #define MS_TO_NS(msec)		((msec) * 1000 * 1000)
 
 void ir_raw_event_handle(struct rc_dev *dev);
+void ir_raw_store_sysfs_lrp(struct rc_dev *dev, u8 val);
 int ir_raw_event_store(struct rc_dev *dev, struct ir_raw_event *ev);
 int ir_raw_event_store_edge(struct rc_dev *dev, enum raw_event_type type);
 int ir_raw_event_store_with_filter(struct rc_dev *dev,
-- 
2.7.0

