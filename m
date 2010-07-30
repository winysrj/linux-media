Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53717 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758402Ab0G3CRz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jul 2010 22:17:55 -0400
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: lirc-list@lists.sourceforge.net
Cc: Jarod Wilson <jarod@wilsonet.com>, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 09/13] IR: add helper function for hardware with small o/b buffer.
Date: Fri, 30 Jul 2010 05:17:11 +0300
Message-Id: <1280456235-2024-10-git-send-email-maximlevitsky@gmail.com>
In-Reply-To: <1280456235-2024-1-git-send-email-maximlevitsky@gmail.com>
References: <1280456235-2024-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some ir input devices have small buffer, and interrupt the host
each time it is full (or half full)

Add a helper that automaticly handles timeouts, and also
automaticly merges samples of same time (space-space)
Such samples might be placed by hardware because size of
sample in the buffer is small (a byte for example).

Also remove constness from ir_dev_props, because it now contains timeout
settings that driver might want to change

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/media/IR/ir-core-priv.h |    1 +
 drivers/media/IR/ir-keytable.c  |    2 +-
 drivers/media/IR/ir-raw-event.c |   84 +++++++++++++++++++++++++++++++++++++++
 include/media/ir-core.h         |   23 +++++++++-
 4 files changed, 106 insertions(+), 4 deletions(-)

diff --git a/drivers/media/IR/ir-core-priv.h b/drivers/media/IR/ir-core-priv.h
index fe84374..841b76c 100644
--- a/drivers/media/IR/ir-core-priv.h
+++ b/drivers/media/IR/ir-core-priv.h
@@ -41,6 +41,7 @@ struct ir_raw_event_ctrl {
 
 	/* raw decoder state follows */
 	struct ir_raw_event prev_ev;
+	struct ir_raw_event this_ev;
 	struct nec_dec {
 		int state;
 		unsigned count;
diff --git a/drivers/media/IR/ir-keytable.c b/drivers/media/IR/ir-keytable.c
index 94a8577..34b9c07 100644
--- a/drivers/media/IR/ir-keytable.c
+++ b/drivers/media/IR/ir-keytable.c
@@ -428,7 +428,7 @@ static void ir_close(struct input_dev *input_dev)
  */
 int __ir_input_register(struct input_dev *input_dev,
 		      const struct ir_scancode_table *rc_tab,
-		      const struct ir_dev_props *props,
+		      struct ir_dev_props *props,
 		      const char *driver_name)
 {
 	struct ir_input_dev *ir_dev;
diff --git a/drivers/media/IR/ir-raw-event.c b/drivers/media/IR/ir-raw-event.c
index 4098748..5a6f8ce 100644
--- a/drivers/media/IR/ir-raw-event.c
+++ b/drivers/media/IR/ir-raw-event.c
@@ -132,6 +132,90 @@ int ir_raw_event_store_edge(struct input_dev *input_dev, enum raw_event_type typ
 EXPORT_SYMBOL_GPL(ir_raw_event_store_edge);
 
 /**
+ * ir_raw_event_store_with_filter() - pass next pulse/space to decoders with some processing
+ * @input_dev:	the struct input_dev device descriptor
+ * @type:	the type of the event that has occurred
+ *
+ * This routine (which may be called from an interrupt context) works
+ * in similiar manner to ir_raw_event_store_edge.
+ * This routine is intended for devices with limited internal buffer
+ * It automerges samples of same type, and handles timeouts
+ */
+int ir_raw_event_store_with_filter(struct input_dev *input_dev,
+						struct ir_raw_event *ev)
+{
+	struct ir_input_dev *ir = input_get_drvdata(input_dev);
+	struct ir_raw_event_ctrl *raw = ir->raw;
+
+	if (!raw || !ir->props)
+		return -EINVAL;
+
+	/* Ignore spaces in idle mode */
+	if (ir->idle && !ev->pulse)
+		return 0;
+	else if (ir->idle)
+		ir_raw_event_set_idle(input_dev, 0);
+
+	if (!raw->this_ev.duration) {
+		raw->this_ev = *ev;
+	} else if (ev->pulse == raw->this_ev.pulse) {
+		raw->this_ev.duration += ev->duration;
+	} else {
+		ir_raw_event_store(input_dev, &raw->this_ev);
+		raw->this_ev = *ev;
+	}
+
+	/* Enter idle mode if nessesary */
+	if (!ev->pulse && ir->props->timeout &&
+		raw->this_ev.duration >= ir->props->timeout)
+		ir_raw_event_set_idle(input_dev, 1);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ir_raw_event_store_with_filter);
+
+void ir_raw_event_set_idle(struct input_dev *input_dev, int idle)
+{
+	struct ir_input_dev *ir = input_get_drvdata(input_dev);
+	struct ir_raw_event_ctrl *raw = ir->raw;
+	ktime_t now;
+	u64 delta;
+
+	if (!ir->props)
+		return;
+
+	if (!ir->raw)
+		goto out;
+
+	if (idle) {
+		IR_dprintk(2, "enter idle mode\n");
+		raw->last_event = ktime_get();
+	} else {
+		IR_dprintk(2, "exit idle mode\n");
+
+		now = ktime_get();
+		delta = ktime_to_ns(ktime_sub(now, ir->raw->last_event));
+
+		WARN_ON(raw->this_ev.pulse);
+
+		raw->this_ev.duration =
+			min(raw->this_ev.duration + delta,
+						(u64)IR_MAX_DURATION);
+
+		ir_raw_event_store(input_dev, &raw->this_ev);
+
+		if (raw->this_ev.duration == IR_MAX_DURATION)
+			ir_raw_event_reset(input_dev);
+
+		raw->this_ev.duration = 0;
+	}
+out:
+	if (ir->props->s_idle)
+		ir->props->s_idle(ir->props->priv, idle);
+	ir->idle = idle;
+}
+EXPORT_SYMBOL_GPL(ir_raw_event_set_idle);
+
+/**
  * ir_raw_event_handle() - schedules the decoding of stored ir data
  * @input_dev:	the struct input_dev device descriptor
  *
diff --git a/include/media/ir-core.h b/include/media/ir-core.h
index 197d05a..7ad39fe 100644
--- a/include/media/ir-core.h
+++ b/include/media/ir-core.h
@@ -41,6 +41,9 @@ enum rc_driver_type {
  *	anything with it. Yet, as the same keycode table can be used with other
  *	devices, a mask is provided to allow its usage. Drivers should generally
  *	leave this field in blank
+ * @timeout: optional time after which device stops sending data
+ * @min_timeout: minimum timeout supported by device
+ * @max_timeout: maximum timeout supported by device
  * @priv: driver-specific data, to be used on the callbacks
  * @change_protocol: allow changing the protocol used on hardware decoders
  * @open: callback to allow drivers to enable polling/irq when IR input device
@@ -50,11 +53,19 @@ enum rc_driver_type {
  * @s_tx_mask: set transmitter mask (for devices with multiple tx outputs)
  * @s_tx_carrier: set transmit carrier frequency
  * @tx_ir: transmit IR
+ * @s_idle: optional: enable/disable hardware idle mode, upon which,
+ *	device doesn't interrupt host untill it sees IR data
  */
 struct ir_dev_props {
 	enum rc_driver_type	driver_type;
 	unsigned long		allowed_protos;
 	u32			scanmask;
+
+	u64			timeout;
+	u64			min_timeout;
+	u64			max_timeout;
+
+
 	void			*priv;
 	int			(*change_protocol)(void *priv, u64 ir_type);
 	int			(*open)(void *priv);
@@ -62,6 +73,7 @@ struct ir_dev_props {
 	int			(*s_tx_mask)(void *priv, u32 mask);
 	int			(*s_tx_carrier)(void *priv, u32 carrier);
 	int			(*tx_ir)(void *priv, int *txbuf, u32 n);
+	void			(*s_idle)(void *priv, int enable);
 };
 
 struct ir_input_dev {
@@ -69,9 +81,10 @@ struct ir_input_dev {
 	char				*driver_name;	/* Name of the driver module */
 	struct ir_scancode_table	rc_tab;		/* scan/key table */
 	unsigned long			devno;		/* device number */
-	const struct ir_dev_props	*props;		/* Device properties */
+	struct ir_dev_props		*props;		/* Device properties */
 	struct ir_raw_event_ctrl	*raw;		/* for raw pulse/space events */
 	struct input_dev		*input_dev;	/* the input device associated with this device */
+	bool				idle;
 
 	/* key info - needed by IR keycode handlers */
 	spinlock_t			keylock;	/* protects the below members */
@@ -95,12 +108,12 @@ enum raw_event_type {
 /* From ir-keytable.c */
 int __ir_input_register(struct input_dev *dev,
 		      const struct ir_scancode_table *ir_codes,
-		      const struct ir_dev_props *props,
+		      struct ir_dev_props *props,
 		      const char *driver_name);
 
 static inline int ir_input_register(struct input_dev *dev,
 		      const char *map_name,
-		      const struct ir_dev_props *props,
+		      struct ir_dev_props *props,
 		      const char *driver_name) {
 	struct ir_scancode_table *ir_codes;
 	struct ir_input_dev *ir_dev;
@@ -148,6 +161,10 @@ struct ir_raw_event {
 void ir_raw_event_handle(struct input_dev *input_dev);
 int ir_raw_event_store(struct input_dev *input_dev, struct ir_raw_event *ev);
 int ir_raw_event_store_edge(struct input_dev *input_dev, enum raw_event_type type);
+int ir_raw_event_store_with_filter(struct input_dev *input_dev,
+				struct ir_raw_event *ev);
+void ir_raw_event_set_idle(struct input_dev *input_dev, int idle);
+
 static inline void ir_raw_event_reset(struct input_dev *input_dev)
 {
 	struct ir_raw_event ev = { .pulse = false, .duration = 0 };
-- 
1.7.0.4

