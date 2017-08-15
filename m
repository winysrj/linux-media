Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:45381 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751160AbdHORSk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Aug 2017 13:18:40 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec: rename pin events/function
Message-ID: <2bb37727-f2de-9aab-b782-6027db3aab9a@xs4all.nl>
Date: Tue, 15 Aug 2017 19:18:35 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The CEC_EVENT_PIN_LOW/HIGH defines and the cec_queue_pin_event() function
did not specify that these were about CEC pin events.

Since in the future there will also be HPD pin events it is wise to rename
the event defines and function to CEC_EVENT_PIN_CEC_LOW/HIGH and
cec_queue_pin_cec_event() now before these become part of the ABI.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
index 0a7aa21f24f4..6c1f6efb822e 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
@@ -127,7 +127,7 @@ returns the information to the application. The ioctl never fails.
       - 0x00000080
       - The CEC hardware can monitor CEC pin changes from low to high voltage
         and vice versa. When in pin monitoring mode the application will
-	receive ``CEC_EVENT_PIN_LOW`` and ``CEC_EVENT_PIN_HIGH`` events.
+	receive ``CEC_EVENT_PIN_CEC_LOW`` and ``CEC_EVENT_PIN_CEC_HIGH`` events.



diff --git a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
index 766d8b0ce431..a4a107dc4822 100644
--- a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
@@ -148,14 +148,14 @@ it is guaranteed that the state did change in between the two events.
 	application didn't dequeue CEC messages fast enough.
     * .. _`CEC-EVENT-PIN-LOW`:

-      - ``CEC_EVENT_PIN_LOW``
+      - ``CEC_EVENT_PIN_CEC_LOW``
       - 3
       - Generated if the CEC pin goes from a high voltage to a low voltage.
         Only applies to adapters that have the ``CEC_CAP_MONITOR_PIN``
 	capability set.
     * .. _`CEC-EVENT-PIN-HIGH`:

-      - ``CEC_EVENT_PIN_HIGH``
+      - ``CEC_EVENT_PIN_CEC_HIGH``
       - 4
       - Generated if the CEC pin goes from a low voltage to a high voltage.
         Only applies to adapters that have the ``CEC_CAP_MONITOR_PIN``
diff --git a/Documentation/media/uapi/cec/cec-ioc-g-mode.rst b/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
index 494154e9d449..4d8e0647e832 100644
--- a/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
@@ -159,7 +159,7 @@ Available follower modes are:
 	This mode requires that the :ref:`CEC_CAP_MONITOR_PIN <CEC-CAP-MONITOR-PIN>`
 	capability is set, otherwise the ``EINVAL`` error code is returned.
 	While in pin monitoring mode this file descriptor can receive the
-	``CEC_EVENT_PIN_LOW`` and ``CEC_EVENT_PIN_HIGH`` events to see the
+	``CEC_EVENT_PIN_CEC_LOW`` and ``CEC_EVENT_PIN_CEC_HIGH`` events to see the
 	low-level CEC pin transitions. This is very useful for debugging.
 	This mode is only allowed if the process has the ``CAP_NET_ADMIN``
 	capability. If that is not set, then the ``EPERM`` error code is returned.
diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index 8ac39ddf892c..d9adeb505c09 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -154,10 +154,11 @@ static void cec_queue_event(struct cec_adapter *adap,
 }

 /* Notify userspace that the CEC pin changed state at the given time. */
-void cec_queue_pin_event(struct cec_adapter *adap, bool is_high, ktime_t ts)
+void cec_queue_pin_cec_event(struct cec_adapter *adap, bool is_high, ktime_t ts)
 {
 	struct cec_event ev = {
-		.event = is_high ? CEC_EVENT_PIN_HIGH : CEC_EVENT_PIN_LOW,
+		.event = is_high ? CEC_EVENT_PIN_CEC_HIGH :
+				   CEC_EVENT_PIN_CEC_LOW,
 	};
 	struct cec_fh *fh;

@@ -167,7 +168,7 @@ void cec_queue_pin_event(struct cec_adapter *adap, bool is_high, ktime_t ts)
 			cec_queue_event_fh(fh, &ev, ktime_to_ns(ts));
 	mutex_unlock(&adap->devnode.lock);
 }
-EXPORT_SYMBOL_GPL(cec_queue_pin_event);
+EXPORT_SYMBOL_GPL(cec_queue_pin_cec_event);

 /*
  * Queue a new message for this filehandle.
diff --git a/drivers/media/cec/cec-api.c b/drivers/media/cec/cec-api.c
index 00d43d74020f..87649b0c6381 100644
--- a/drivers/media/cec/cec-api.c
+++ b/drivers/media/cec/cec-api.c
@@ -449,8 +449,8 @@ static long cec_s_mode(struct cec_adapter *adap, struct cec_fh *fh,
 			.flags = CEC_EVENT_FL_INITIAL_STATE,
 		};

-		ev.event = adap->pin->cur_value ? CEC_EVENT_PIN_HIGH :
-						  CEC_EVENT_PIN_LOW;
+		ev.event = adap->pin->cur_value ? CEC_EVENT_PIN_CEC_HIGH :
+						  CEC_EVENT_PIN_CEC_LOW;
 		cec_queue_event_fh(fh, &ev, 0);
 #endif
 		adap->monitor_pin_cnt++;
diff --git a/drivers/media/cec/cec-pin.c b/drivers/media/cec/cec-pin.c
index 03f800e5ec1f..31a26d3b8bd8 100644
--- a/drivers/media/cec/cec-pin.c
+++ b/drivers/media/cec/cec-pin.c
@@ -609,8 +609,9 @@ static int cec_pin_thread_func(void *_adap)
 		while (atomic_read(&pin->work_pin_events)) {
 			unsigned int idx = pin->work_pin_events_rd;

-			cec_queue_pin_event(adap, pin->work_pin_is_high[idx],
-					    pin->work_pin_ts[idx]);
+			cec_queue_pin_cec_event(adap,
+						pin->work_pin_is_high[idx],
+						pin->work_pin_ts[idx]);
 			pin->work_pin_events_rd = (idx + 1) % CEC_NUM_PIN_EVENTS;
 			atomic_dec(&pin->work_pin_events);
 		}
diff --git a/include/media/cec.h b/include/media/cec.h
index 1bec7bde4792..224359c9941a 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -91,7 +91,7 @@ struct cec_event_entry {
 };

 #define CEC_NUM_CORE_EVENTS 2
-#define CEC_NUM_EVENTS CEC_EVENT_PIN_HIGH
+#define CEC_NUM_EVENTS CEC_EVENT_PIN_CEC_HIGH

 struct cec_fh {
 	struct list_head	list;
@@ -280,14 +280,15 @@ static inline void cec_received_msg(struct cec_adapter *adap,
 }

 /**
- * cec_queue_pin_event() - queue a pin event with a given timestamp.
+ * cec_queue_pin_cec_event() - queue a CEC pin event with a given timestamp.
  *
  * @adap:	pointer to the cec adapter
- * @is_high:	when true the pin is high, otherwise it is low
+ * @is_high:	when true the CEC pin is high, otherwise it is low
  * @ts:		the timestamp for this event
  *
  */
-void cec_queue_pin_event(struct cec_adapter *adap, bool is_high, ktime_t ts);
+void cec_queue_pin_cec_event(struct cec_adapter *adap,
+			     bool is_high, ktime_t ts);

 /**
  * cec_get_edid_phys_addr() - find and return the physical address
diff --git a/include/uapi/linux/cec.h b/include/uapi/linux/cec.h
index d87a67b0bb06..4351c3481aea 100644
--- a/include/uapi/linux/cec.h
+++ b/include/uapi/linux/cec.h
@@ -408,8 +408,8 @@ struct cec_log_addrs {
  * didn't empty the message queue in time
  */
 #define CEC_EVENT_LOST_MSGS		2
-#define CEC_EVENT_PIN_LOW		3
-#define CEC_EVENT_PIN_HIGH		4
+#define CEC_EVENT_PIN_CEC_LOW		3
+#define CEC_EVENT_PIN_CEC_HIGH		4

 #define CEC_EVENT_FL_INITIAL_STATE	(1 << 0)
 #define CEC_EVENT_FL_DROPPED_EVENTS	(1 << 1)
