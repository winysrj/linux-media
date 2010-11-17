Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:45911 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934970Ab0KQTTa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Nov 2010 14:19:30 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oAHJJTcP004458
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 17 Nov 2010 14:19:29 -0500
Received: from pedra (vpn-230-120.phx2.redhat.com [10.3.230.120])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id oAHJC5xN007699
	for <linux-media@vger.kernel.org>; Wed, 17 Nov 2010 14:19:19 -0500
Date: Wed, 17 Nov 2010 17:08:32 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 10/10] [media] rc: Rename IR raw interface to ir-raw.c
Message-ID: <20101117170832.2ce96164@pedra>
In-Reply-To: <cover.1290020731.git.mchehab@redhat.com>
References: <cover.1290020731.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 create mode 100644 drivers/media/rc/ir-raw.c
 delete mode 100644 drivers/media/rc/rc-raw.c

diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
index 21251ba..78ac8c5 100644
--- a/drivers/media/rc/Makefile
+++ b/drivers/media/rc/Makefile
@@ -1,4 +1,4 @@
-rc-core-objs	:= rc-main.o rc-raw.o
+rc-core-objs	:= rc-main.o ir-raw.o
 
 obj-y += keymaps/
 
diff --git a/drivers/media/rc/ir-raw.c b/drivers/media/rc/ir-raw.c
new file mode 100644
index 0000000..165412f
--- /dev/null
+++ b/drivers/media/rc/ir-raw.c
@@ -0,0 +1,371 @@
+/* ir-raw-event.c - handle IR Pulse/Space event
+ *
+ * Copyright (C) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ */
+
+#include <linux/kthread.h>
+#include <linux/mutex.h>
+#include <linux/sched.h>
+#include <linux/freezer.h>
+#include "rc-core-priv.h"
+
+/* Define the max number of pulse/space transitions to buffer */
+#define MAX_IR_EVENT_SIZE      512
+
+/* Used to keep track of IR raw clients, protected by ir_raw_handler_lock */
+static LIST_HEAD(ir_raw_client_list);
+
+/* Used to handle IR raw handler extensions */
+static DEFINE_MUTEX(ir_raw_handler_lock);
+static LIST_HEAD(ir_raw_handler_list);
+static u64 available_protocols;
+
+#ifdef MODULE
+/* Used to load the decoders */
+static struct work_struct wq_load;
+#endif
+
+static int ir_raw_event_thread(void *data)
+{
+	struct ir_raw_event ev;
+	struct ir_raw_handler *handler;
+	struct ir_raw_event_ctrl *raw = (struct ir_raw_event_ctrl *)data;
+	int retval;
+
+	while (!kthread_should_stop()) {
+
+		spin_lock_irq(&raw->lock);
+		retval = kfifo_out(&raw->kfifo, &ev, sizeof(ev));
+
+		if (!retval) {
+			set_current_state(TASK_INTERRUPTIBLE);
+
+			if (kthread_should_stop())
+				set_current_state(TASK_RUNNING);
+
+			spin_unlock_irq(&raw->lock);
+			schedule();
+			continue;
+		}
+
+		spin_unlock_irq(&raw->lock);
+
+
+		BUG_ON(retval != sizeof(ev));
+
+		mutex_lock(&ir_raw_handler_lock);
+		list_for_each_entry(handler, &ir_raw_handler_list, list)
+			handler->decode(raw->dev, ev);
+		raw->prev_ev = ev;
+		mutex_unlock(&ir_raw_handler_lock);
+	}
+
+	return 0;
+}
+
+/**
+ * ir_raw_event_store() - pass a pulse/space duration to the raw ir decoders
+ * @dev:	the struct rc_dev device descriptor
+ * @ev:		the struct ir_raw_event descriptor of the pulse/space
+ *
+ * This routine (which may be called from an interrupt context) stores a
+ * pulse/space duration for the raw ir decoding state machines. Pulses are
+ * signalled as positive values and spaces as negative values. A zero value
+ * will reset the decoding state machines.
+ */
+int ir_raw_event_store(struct rc_dev *dev, struct ir_raw_event *ev)
+{
+	if (!dev->raw)
+		return -EINVAL;
+
+	IR_dprintk(2, "sample: (%05dus %s)\n",
+		   TO_US(ev->duration), TO_STR(ev->pulse));
+
+	if (kfifo_in(&dev->raw->kfifo, ev, sizeof(*ev)) != sizeof(*ev))
+		return -ENOMEM;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ir_raw_event_store);
+
+/**
+ * ir_raw_event_store_edge() - notify raw ir decoders of the start of a pulse/space
+ * @dev:	the struct rc_dev device descriptor
+ * @type:	the type of the event that has occurred
+ *
+ * This routine (which may be called from an interrupt context) is used to
+ * store the beginning of an ir pulse or space (or the start/end of ir
+ * reception) for the raw ir decoding state machines. This is used by
+ * hardware which does not provide durations directly but only interrupts
+ * (or similar events) on state change.
+ */
+int ir_raw_event_store_edge(struct rc_dev *dev, enum raw_event_type type)
+{
+	ktime_t			now;
+	s64			delta; /* ns */
+	struct ir_raw_event	ev;
+	int			rc = 0;
+
+	if (!dev->raw)
+		return -EINVAL;
+
+	now = ktime_get();
+	delta = ktime_to_ns(ktime_sub(now, dev->raw->last_event));
+
+	/* Check for a long duration since last event or if we're
+	 * being called for the first time, note that delta can't
+	 * possibly be negative.
+	 */
+	ev.duration = 0;
+	if (delta > IR_MAX_DURATION || !dev->raw->last_type)
+		type |= IR_START_EVENT;
+	else
+		ev.duration = delta;
+
+	if (type & IR_START_EVENT)
+		ir_raw_event_reset(dev);
+	else if (dev->raw->last_type & IR_SPACE) {
+		ev.pulse = false;
+		rc = ir_raw_event_store(dev, &ev);
+	} else if (dev->raw->last_type & IR_PULSE) {
+		ev.pulse = true;
+		rc = ir_raw_event_store(dev, &ev);
+	} else
+		return 0;
+
+	dev->raw->last_event = now;
+	dev->raw->last_type = type;
+	return rc;
+}
+EXPORT_SYMBOL_GPL(ir_raw_event_store_edge);
+
+/**
+ * ir_raw_event_store_with_filter() - pass next pulse/space to decoders with some processing
+ * @dev:	the struct rc_dev device descriptor
+ * @type:	the type of the event that has occurred
+ *
+ * This routine (which may be called from an interrupt context) works
+ * in similiar manner to ir_raw_event_store_edge.
+ * This routine is intended for devices with limited internal buffer
+ * It automerges samples of same type, and handles timeouts
+ */
+int ir_raw_event_store_with_filter(struct rc_dev *dev, struct ir_raw_event *ev)
+{
+	if (!dev->raw)
+		return -EINVAL;
+
+	/* Ignore spaces in idle mode */
+	if (dev->idle && !ev->pulse)
+		return 0;
+	else if (dev->idle)
+		ir_raw_event_set_idle(dev, false);
+
+	if (!dev->raw->this_ev.duration)
+		dev->raw->this_ev = *ev;
+	else if (ev->pulse == dev->raw->this_ev.pulse)
+		dev->raw->this_ev.duration += ev->duration;
+	else {
+		ir_raw_event_store(dev, &dev->raw->this_ev);
+		dev->raw->this_ev = *ev;
+	}
+
+	/* Enter idle mode if nessesary */
+	if (!ev->pulse && dev->timeout &&
+	    dev->raw->this_ev.duration >= dev->timeout)
+		ir_raw_event_set_idle(dev, true);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ir_raw_event_store_with_filter);
+
+/**
+ * ir_raw_event_set_idle() - provide hint to rc-core when the device is idle or not
+ * @dev:	the struct rc_dev device descriptor
+ * @idle:	whether the device is idle or not
+ */
+void ir_raw_event_set_idle(struct rc_dev *dev, bool idle)
+{
+	if (!dev->raw)
+		return;
+
+	IR_dprintk(2, "%s idle mode\n", idle ? "enter" : "leave");
+
+	if (idle) {
+		dev->raw->this_ev.timeout = true;
+		ir_raw_event_store(dev, &dev->raw->this_ev);
+		init_ir_raw_event(&dev->raw->this_ev);
+	}
+
+	if (dev->s_idle)
+		dev->s_idle(dev, idle);
+
+	dev->idle = idle;
+}
+EXPORT_SYMBOL_GPL(ir_raw_event_set_idle);
+
+/**
+ * ir_raw_event_handle() - schedules the decoding of stored ir data
+ * @dev:	the struct rc_dev device descriptor
+ *
+ * This routine will tell rc-core to start decoding stored ir data.
+ */
+void ir_raw_event_handle(struct rc_dev *dev)
+{
+	unsigned long flags;
+
+	if (!dev->raw)
+		return;
+
+	spin_lock_irqsave(&dev->raw->lock, flags);
+	wake_up_process(dev->raw->thread);
+	spin_unlock_irqrestore(&dev->raw->lock, flags);
+}
+EXPORT_SYMBOL_GPL(ir_raw_event_handle);
+
+/* used internally by the sysfs interface */
+u64
+ir_raw_get_allowed_protocols()
+{
+	u64 protocols;
+	mutex_lock(&ir_raw_handler_lock);
+	protocols = available_protocols;
+	mutex_unlock(&ir_raw_handler_lock);
+	return protocols;
+}
+
+/*
+ * Used to (un)register raw event clients
+ */
+int ir_raw_event_register(struct rc_dev *dev)
+{
+	int rc;
+	struct ir_raw_handler *handler;
+
+	if (!dev)
+		return -EINVAL;
+
+	dev->raw = kzalloc(sizeof(*dev->raw), GFP_KERNEL);
+	if (!dev->raw)
+		return -ENOMEM;
+
+	dev->raw->dev = dev;
+	dev->raw->enabled_protocols = ~0;
+	rc = kfifo_alloc(&dev->raw->kfifo,
+			 sizeof(struct ir_raw_event) * MAX_IR_EVENT_SIZE,
+			 GFP_KERNEL);
+	if (rc < 0)
+		goto out;
+
+	spin_lock_init(&dev->raw->lock);
+	dev->raw->thread = kthread_run(ir_raw_event_thread, dev->raw,
+				       "rc%ld", dev->devno);
+
+	if (IS_ERR(dev->raw->thread)) {
+		rc = PTR_ERR(dev->raw->thread);
+		goto out;
+	}
+
+	mutex_lock(&ir_raw_handler_lock);
+	list_add_tail(&dev->raw->list, &ir_raw_client_list);
+	list_for_each_entry(handler, &ir_raw_handler_list, list)
+		if (handler->raw_register)
+			handler->raw_register(dev);
+	mutex_unlock(&ir_raw_handler_lock);
+
+	return 0;
+
+out:
+	kfree(dev->raw);
+	dev->raw = NULL;
+	return rc;
+}
+
+void ir_raw_event_unregister(struct rc_dev *dev)
+{
+	struct ir_raw_handler *handler;
+
+	if (!dev || !dev->raw)
+		return;
+
+	kthread_stop(dev->raw->thread);
+
+	mutex_lock(&ir_raw_handler_lock);
+	list_del(&dev->raw->list);
+	list_for_each_entry(handler, &ir_raw_handler_list, list)
+		if (handler->raw_unregister)
+			handler->raw_unregister(dev);
+	mutex_unlock(&ir_raw_handler_lock);
+
+	kfifo_free(&dev->raw->kfifo);
+	kfree(dev->raw);
+	dev->raw = NULL;
+}
+
+/*
+ * Extension interface - used to register the IR decoders
+ */
+
+int ir_raw_handler_register(struct ir_raw_handler *ir_raw_handler)
+{
+	struct ir_raw_event_ctrl *raw;
+
+	mutex_lock(&ir_raw_handler_lock);
+	list_add_tail(&ir_raw_handler->list, &ir_raw_handler_list);
+	if (ir_raw_handler->raw_register)
+		list_for_each_entry(raw, &ir_raw_client_list, list)
+			ir_raw_handler->raw_register(raw->dev);
+	available_protocols |= ir_raw_handler->protocols;
+	mutex_unlock(&ir_raw_handler_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL(ir_raw_handler_register);
+
+void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler)
+{
+	struct ir_raw_event_ctrl *raw;
+
+	mutex_lock(&ir_raw_handler_lock);
+	list_del(&ir_raw_handler->list);
+	if (ir_raw_handler->raw_unregister)
+		list_for_each_entry(raw, &ir_raw_client_list, list)
+			ir_raw_handler->raw_unregister(raw->dev);
+	available_protocols &= ~ir_raw_handler->protocols;
+	mutex_unlock(&ir_raw_handler_lock);
+}
+EXPORT_SYMBOL(ir_raw_handler_unregister);
+
+#ifdef MODULE
+static void init_decoders(struct work_struct *work)
+{
+	/* Load the decoder modules */
+
+	load_nec_decode();
+	load_rc5_decode();
+	load_rc6_decode();
+	load_jvc_decode();
+	load_sony_decode();
+	load_lirc_codec();
+
+	/* If needed, we may later add some init code. In this case,
+	   it is needed to change the CONFIG_MODULE test at rc-core.h
+	 */
+}
+#endif
+
+void ir_raw_init(void)
+{
+#ifdef MODULE
+	INIT_WORK(&wq_load, init_decoders);
+	schedule_work(&wq_load);
+#endif
+}
diff --git a/drivers/media/rc/rc-raw.c b/drivers/media/rc/rc-raw.c
deleted file mode 100644
index 165412f..0000000
--- a/drivers/media/rc/rc-raw.c
+++ /dev/null
@@ -1,371 +0,0 @@
-/* ir-raw-event.c - handle IR Pulse/Space event
- *
- * Copyright (C) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
- *
- * This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation version 2 of the License.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- */
-
-#include <linux/kthread.h>
-#include <linux/mutex.h>
-#include <linux/sched.h>
-#include <linux/freezer.h>
-#include "rc-core-priv.h"
-
-/* Define the max number of pulse/space transitions to buffer */
-#define MAX_IR_EVENT_SIZE      512
-
-/* Used to keep track of IR raw clients, protected by ir_raw_handler_lock */
-static LIST_HEAD(ir_raw_client_list);
-
-/* Used to handle IR raw handler extensions */
-static DEFINE_MUTEX(ir_raw_handler_lock);
-static LIST_HEAD(ir_raw_handler_list);
-static u64 available_protocols;
-
-#ifdef MODULE
-/* Used to load the decoders */
-static struct work_struct wq_load;
-#endif
-
-static int ir_raw_event_thread(void *data)
-{
-	struct ir_raw_event ev;
-	struct ir_raw_handler *handler;
-	struct ir_raw_event_ctrl *raw = (struct ir_raw_event_ctrl *)data;
-	int retval;
-
-	while (!kthread_should_stop()) {
-
-		spin_lock_irq(&raw->lock);
-		retval = kfifo_out(&raw->kfifo, &ev, sizeof(ev));
-
-		if (!retval) {
-			set_current_state(TASK_INTERRUPTIBLE);
-
-			if (kthread_should_stop())
-				set_current_state(TASK_RUNNING);
-
-			spin_unlock_irq(&raw->lock);
-			schedule();
-			continue;
-		}
-
-		spin_unlock_irq(&raw->lock);
-
-
-		BUG_ON(retval != sizeof(ev));
-
-		mutex_lock(&ir_raw_handler_lock);
-		list_for_each_entry(handler, &ir_raw_handler_list, list)
-			handler->decode(raw->dev, ev);
-		raw->prev_ev = ev;
-		mutex_unlock(&ir_raw_handler_lock);
-	}
-
-	return 0;
-}
-
-/**
- * ir_raw_event_store() - pass a pulse/space duration to the raw ir decoders
- * @dev:	the struct rc_dev device descriptor
- * @ev:		the struct ir_raw_event descriptor of the pulse/space
- *
- * This routine (which may be called from an interrupt context) stores a
- * pulse/space duration for the raw ir decoding state machines. Pulses are
- * signalled as positive values and spaces as negative values. A zero value
- * will reset the decoding state machines.
- */
-int ir_raw_event_store(struct rc_dev *dev, struct ir_raw_event *ev)
-{
-	if (!dev->raw)
-		return -EINVAL;
-
-	IR_dprintk(2, "sample: (%05dus %s)\n",
-		   TO_US(ev->duration), TO_STR(ev->pulse));
-
-	if (kfifo_in(&dev->raw->kfifo, ev, sizeof(*ev)) != sizeof(*ev))
-		return -ENOMEM;
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(ir_raw_event_store);
-
-/**
- * ir_raw_event_store_edge() - notify raw ir decoders of the start of a pulse/space
- * @dev:	the struct rc_dev device descriptor
- * @type:	the type of the event that has occurred
- *
- * This routine (which may be called from an interrupt context) is used to
- * store the beginning of an ir pulse or space (or the start/end of ir
- * reception) for the raw ir decoding state machines. This is used by
- * hardware which does not provide durations directly but only interrupts
- * (or similar events) on state change.
- */
-int ir_raw_event_store_edge(struct rc_dev *dev, enum raw_event_type type)
-{
-	ktime_t			now;
-	s64			delta; /* ns */
-	struct ir_raw_event	ev;
-	int			rc = 0;
-
-	if (!dev->raw)
-		return -EINVAL;
-
-	now = ktime_get();
-	delta = ktime_to_ns(ktime_sub(now, dev->raw->last_event));
-
-	/* Check for a long duration since last event or if we're
-	 * being called for the first time, note that delta can't
-	 * possibly be negative.
-	 */
-	ev.duration = 0;
-	if (delta > IR_MAX_DURATION || !dev->raw->last_type)
-		type |= IR_START_EVENT;
-	else
-		ev.duration = delta;
-
-	if (type & IR_START_EVENT)
-		ir_raw_event_reset(dev);
-	else if (dev->raw->last_type & IR_SPACE) {
-		ev.pulse = false;
-		rc = ir_raw_event_store(dev, &ev);
-	} else if (dev->raw->last_type & IR_PULSE) {
-		ev.pulse = true;
-		rc = ir_raw_event_store(dev, &ev);
-	} else
-		return 0;
-
-	dev->raw->last_event = now;
-	dev->raw->last_type = type;
-	return rc;
-}
-EXPORT_SYMBOL_GPL(ir_raw_event_store_edge);
-
-/**
- * ir_raw_event_store_with_filter() - pass next pulse/space to decoders with some processing
- * @dev:	the struct rc_dev device descriptor
- * @type:	the type of the event that has occurred
- *
- * This routine (which may be called from an interrupt context) works
- * in similiar manner to ir_raw_event_store_edge.
- * This routine is intended for devices with limited internal buffer
- * It automerges samples of same type, and handles timeouts
- */
-int ir_raw_event_store_with_filter(struct rc_dev *dev, struct ir_raw_event *ev)
-{
-	if (!dev->raw)
-		return -EINVAL;
-
-	/* Ignore spaces in idle mode */
-	if (dev->idle && !ev->pulse)
-		return 0;
-	else if (dev->idle)
-		ir_raw_event_set_idle(dev, false);
-
-	if (!dev->raw->this_ev.duration)
-		dev->raw->this_ev = *ev;
-	else if (ev->pulse == dev->raw->this_ev.pulse)
-		dev->raw->this_ev.duration += ev->duration;
-	else {
-		ir_raw_event_store(dev, &dev->raw->this_ev);
-		dev->raw->this_ev = *ev;
-	}
-
-	/* Enter idle mode if nessesary */
-	if (!ev->pulse && dev->timeout &&
-	    dev->raw->this_ev.duration >= dev->timeout)
-		ir_raw_event_set_idle(dev, true);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(ir_raw_event_store_with_filter);
-
-/**
- * ir_raw_event_set_idle() - provide hint to rc-core when the device is idle or not
- * @dev:	the struct rc_dev device descriptor
- * @idle:	whether the device is idle or not
- */
-void ir_raw_event_set_idle(struct rc_dev *dev, bool idle)
-{
-	if (!dev->raw)
-		return;
-
-	IR_dprintk(2, "%s idle mode\n", idle ? "enter" : "leave");
-
-	if (idle) {
-		dev->raw->this_ev.timeout = true;
-		ir_raw_event_store(dev, &dev->raw->this_ev);
-		init_ir_raw_event(&dev->raw->this_ev);
-	}
-
-	if (dev->s_idle)
-		dev->s_idle(dev, idle);
-
-	dev->idle = idle;
-}
-EXPORT_SYMBOL_GPL(ir_raw_event_set_idle);
-
-/**
- * ir_raw_event_handle() - schedules the decoding of stored ir data
- * @dev:	the struct rc_dev device descriptor
- *
- * This routine will tell rc-core to start decoding stored ir data.
- */
-void ir_raw_event_handle(struct rc_dev *dev)
-{
-	unsigned long flags;
-
-	if (!dev->raw)
-		return;
-
-	spin_lock_irqsave(&dev->raw->lock, flags);
-	wake_up_process(dev->raw->thread);
-	spin_unlock_irqrestore(&dev->raw->lock, flags);
-}
-EXPORT_SYMBOL_GPL(ir_raw_event_handle);
-
-/* used internally by the sysfs interface */
-u64
-ir_raw_get_allowed_protocols()
-{
-	u64 protocols;
-	mutex_lock(&ir_raw_handler_lock);
-	protocols = available_protocols;
-	mutex_unlock(&ir_raw_handler_lock);
-	return protocols;
-}
-
-/*
- * Used to (un)register raw event clients
- */
-int ir_raw_event_register(struct rc_dev *dev)
-{
-	int rc;
-	struct ir_raw_handler *handler;
-
-	if (!dev)
-		return -EINVAL;
-
-	dev->raw = kzalloc(sizeof(*dev->raw), GFP_KERNEL);
-	if (!dev->raw)
-		return -ENOMEM;
-
-	dev->raw->dev = dev;
-	dev->raw->enabled_protocols = ~0;
-	rc = kfifo_alloc(&dev->raw->kfifo,
-			 sizeof(struct ir_raw_event) * MAX_IR_EVENT_SIZE,
-			 GFP_KERNEL);
-	if (rc < 0)
-		goto out;
-
-	spin_lock_init(&dev->raw->lock);
-	dev->raw->thread = kthread_run(ir_raw_event_thread, dev->raw,
-				       "rc%ld", dev->devno);
-
-	if (IS_ERR(dev->raw->thread)) {
-		rc = PTR_ERR(dev->raw->thread);
-		goto out;
-	}
-
-	mutex_lock(&ir_raw_handler_lock);
-	list_add_tail(&dev->raw->list, &ir_raw_client_list);
-	list_for_each_entry(handler, &ir_raw_handler_list, list)
-		if (handler->raw_register)
-			handler->raw_register(dev);
-	mutex_unlock(&ir_raw_handler_lock);
-
-	return 0;
-
-out:
-	kfree(dev->raw);
-	dev->raw = NULL;
-	return rc;
-}
-
-void ir_raw_event_unregister(struct rc_dev *dev)
-{
-	struct ir_raw_handler *handler;
-
-	if (!dev || !dev->raw)
-		return;
-
-	kthread_stop(dev->raw->thread);
-
-	mutex_lock(&ir_raw_handler_lock);
-	list_del(&dev->raw->list);
-	list_for_each_entry(handler, &ir_raw_handler_list, list)
-		if (handler->raw_unregister)
-			handler->raw_unregister(dev);
-	mutex_unlock(&ir_raw_handler_lock);
-
-	kfifo_free(&dev->raw->kfifo);
-	kfree(dev->raw);
-	dev->raw = NULL;
-}
-
-/*
- * Extension interface - used to register the IR decoders
- */
-
-int ir_raw_handler_register(struct ir_raw_handler *ir_raw_handler)
-{
-	struct ir_raw_event_ctrl *raw;
-
-	mutex_lock(&ir_raw_handler_lock);
-	list_add_tail(&ir_raw_handler->list, &ir_raw_handler_list);
-	if (ir_raw_handler->raw_register)
-		list_for_each_entry(raw, &ir_raw_client_list, list)
-			ir_raw_handler->raw_register(raw->dev);
-	available_protocols |= ir_raw_handler->protocols;
-	mutex_unlock(&ir_raw_handler_lock);
-
-	return 0;
-}
-EXPORT_SYMBOL(ir_raw_handler_register);
-
-void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler)
-{
-	struct ir_raw_event_ctrl *raw;
-
-	mutex_lock(&ir_raw_handler_lock);
-	list_del(&ir_raw_handler->list);
-	if (ir_raw_handler->raw_unregister)
-		list_for_each_entry(raw, &ir_raw_client_list, list)
-			ir_raw_handler->raw_unregister(raw->dev);
-	available_protocols &= ~ir_raw_handler->protocols;
-	mutex_unlock(&ir_raw_handler_lock);
-}
-EXPORT_SYMBOL(ir_raw_handler_unregister);
-
-#ifdef MODULE
-static void init_decoders(struct work_struct *work)
-{
-	/* Load the decoder modules */
-
-	load_nec_decode();
-	load_rc5_decode();
-	load_rc6_decode();
-	load_jvc_decode();
-	load_sony_decode();
-	load_lirc_codec();
-
-	/* If needed, we may later add some init code. In this case,
-	   it is needed to change the CONFIG_MODULE test at rc-core.h
-	 */
-}
-#endif
-
-void ir_raw_init(void)
-{
-#ifdef MODULE
-	INIT_WORK(&wq_load, init_decoders);
-	schedule_work(&wq_load);
-#endif
-}
-- 
1.7.1

