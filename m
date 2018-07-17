Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:56533 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731529AbeGQOBw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Jul 2018 10:01:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 4/5] cec: add support for 5V signal testing
Date: Tue, 17 Jul 2018 15:29:08 +0200
Message-Id: <20180717132909.92158-5-hverkuil@xs4all.nl>
In-Reply-To: <20180717132909.92158-1-hverkuil@xs4all.nl>
References: <20180717132909.92158-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add support for the new 5V CEC events

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/cec/cec-adap.c | 18 +++++++++++++++++-
 drivers/media/cec/cec-api.c  |  8 ++++++++
 include/media/cec-pin.h      |  4 ++++
 include/media/cec.h          | 12 +++++++++++-
 4 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index b7fad0ec5710..030b2602faf0 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -74,7 +74,7 @@ void cec_queue_event_fh(struct cec_fh *fh,
 			const struct cec_event *new_ev, u64 ts)
 {
 	static const u16 max_events[CEC_NUM_EVENTS] = {
-		1, 1, 800, 800, 8, 8,
+		1, 1, 800, 800, 8, 8, 8, 8
 	};
 	struct cec_event_entry *entry;
 	unsigned int ev_idx = new_ev->event - 1;
@@ -176,6 +176,22 @@ void cec_queue_pin_hpd_event(struct cec_adapter *adap, bool is_high, ktime_t ts)
 }
 EXPORT_SYMBOL_GPL(cec_queue_pin_hpd_event);
 
+/* Notify userspace that the 5V pin changed state at the given time. */
+void cec_queue_pin_5v_event(struct cec_adapter *adap, bool is_high, ktime_t ts)
+{
+	struct cec_event ev = {
+		.event = is_high ? CEC_EVENT_PIN_5V_HIGH :
+				   CEC_EVENT_PIN_5V_LOW,
+	};
+	struct cec_fh *fh;
+
+	mutex_lock(&adap->devnode.lock);
+	list_for_each_entry(fh, &adap->devnode.fhs, list)
+		cec_queue_event_fh(fh, &ev, ktime_to_ns(ts));
+	mutex_unlock(&adap->devnode.lock);
+}
+EXPORT_SYMBOL_GPL(cec_queue_pin_5v_event);
+
 /*
  * Queue a new message for this filehandle.
  *
diff --git a/drivers/media/cec/cec-api.c b/drivers/media/cec/cec-api.c
index 10b67fc40318..b6536bbad530 100644
--- a/drivers/media/cec/cec-api.c
+++ b/drivers/media/cec/cec-api.c
@@ -579,6 +579,14 @@ static int cec_open(struct inode *inode, struct file *filp)
 			cec_queue_event_fh(fh, &ev, 0);
 		}
 	}
+	if (adap->pin && adap->pin->ops->read_5v) {
+		err = adap->pin->ops->read_5v(adap);
+		if (err >= 0) {
+			ev.event = err ? CEC_EVENT_PIN_5V_HIGH :
+					 CEC_EVENT_PIN_5V_LOW;
+			cec_queue_event_fh(fh, &ev, 0);
+		}
+	}
 #endif
 
 	list_add(&fh->list, &devnode->fhs);
diff --git a/include/media/cec-pin.h b/include/media/cec-pin.h
index ed16c6dde0ba..604e79cb6cbf 100644
--- a/include/media/cec-pin.h
+++ b/include/media/cec-pin.h
@@ -25,6 +25,9 @@
  * @read_hpd:	read the HPD pin. Return true if high, false if low or
  *		an error if negative. If NULL or -ENOTTY is returned,
  *		then this is not supported.
+ * @read_5v:	read the 5V pin. Return true if high, false if low or
+ *		an error if negative. If NULL or -ENOTTY is returned,
+ *		then this is not supported.
  *
  * These operations are used by the cec pin framework to manipulate
  * the CEC pin.
@@ -38,6 +41,7 @@ struct cec_pin_ops {
 	void (*free)(struct cec_adapter *adap);
 	void (*status)(struct cec_adapter *adap, struct seq_file *file);
 	int  (*read_hpd)(struct cec_adapter *adap);
+	int  (*read_5v)(struct cec_adapter *adap);
 };
 
 /**
diff --git a/include/media/cec.h b/include/media/cec.h
index 580ab1042898..ff9847f7f99d 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -79,7 +79,7 @@ struct cec_event_entry {
 };
 
 #define CEC_NUM_CORE_EVENTS 2
-#define CEC_NUM_EVENTS CEC_EVENT_PIN_HPD_HIGH
+#define CEC_NUM_EVENTS CEC_EVENT_PIN_5V_HIGH
 
 struct cec_fh {
 	struct list_head	list;
@@ -308,6 +308,16 @@ void cec_queue_pin_cec_event(struct cec_adapter *adap, bool is_high,
  */
 void cec_queue_pin_hpd_event(struct cec_adapter *adap, bool is_high, ktime_t ts);
 
+/**
+ * cec_queue_pin_5v_event() - queue a pin event with a given timestamp.
+ *
+ * @adap:	pointer to the cec adapter
+ * @is_high:	when true the 5V pin is high, otherwise it is low
+ * @ts:		the timestamp for this event
+ *
+ */
+void cec_queue_pin_5v_event(struct cec_adapter *adap, bool is_high, ktime_t ts);
+
 /**
  * cec_get_edid_phys_addr() - find and return the physical address
  *
-- 
2.18.0
