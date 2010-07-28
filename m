Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38643 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291Ab0G1XlJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jul 2010 19:41:09 -0400
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: lirc-list@lists.sourceforge.net
Cc: Jarod Wilson <jarod@wilsonet.com>, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 5/9] IR: extend interfaces to support more device settings
Date: Thu, 29 Jul 2010 02:40:48 +0300
Message-Id: <1280360452-8852-6-git-send-email-maximlevitsky@gmail.com>
In-Reply-To: <1280360452-8852-1-git-send-email-maximlevitsky@gmail.com>
References: <1280360452-8852-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Also reuse LIRC_SET_MEASURE_CARRIER_MODE as LIRC_SET_LEARN_MODE
(LIRC_SET_LEARN_MODE will start carrier reports if possible, and
tune receiver to wide band mode)

This IOCTL isn't yet used by lirc, so this won't break userspace.

Note that drivers currently can't report carrier,
because raw event doesn't have space to indicate that.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/media/IR/ir-core-priv.h  |    2 +
 drivers/media/IR/ir-lirc-codec.c |  119 +++++++++++++++++++++++++++++++-------
 drivers/media/IR/ir-raw-event.c  |   13 ++---
 include/media/ir-core.h          |   11 ++++
 include/media/lirc.h             |    4 +-
 5 files changed, 117 insertions(+), 32 deletions(-)

diff --git a/drivers/media/IR/ir-core-priv.h b/drivers/media/IR/ir-core-priv.h
index d6ec4fe..9c594af 100644
--- a/drivers/media/IR/ir-core-priv.h
+++ b/drivers/media/IR/ir-core-priv.h
@@ -77,6 +77,8 @@ struct ir_raw_event_ctrl {
 	struct lirc_codec {
 		struct ir_input_dev *ir_dev;
 		struct lirc_driver *drv;
+		int timeout_report;
+		int carrier_low;
 	} lirc;
 };
 
diff --git a/drivers/media/IR/ir-lirc-codec.c b/drivers/media/IR/ir-lirc-codec.c
index 8ca01fd..70c299f 100644
--- a/drivers/media/IR/ir-lirc-codec.c
+++ b/drivers/media/IR/ir-lirc-codec.c
@@ -40,16 +40,24 @@ static int ir_lirc_decode(struct input_dev *input_dev, struct ir_raw_event ev)
 	if (!ir_dev->raw->lirc.drv || !ir_dev->raw->lirc.drv->rbuf)
 		return -EINVAL;
 
-	if (IS_RESET(ev))
-		return 0;
+	if (IS_RESET(ev)) {
+
+		if (ir_dev->raw->lirc.timeout_report)
+			sample = LIRC_TIMEOUT(0);
+		else
+			return 0;
 
-	IR_dprintk(2, "LIRC data transfer started (%uus %s)\n",
-		   TO_US(ev.duration), TO_STR(ev.pulse));
+		IR_dprintk(2, "LIRC: Sending timeout packet\n");
 
+	} else {
+		sample = ev.duration / 1000;
+		if (ev.pulse)
+			sample |= PULSE_BIT;
+
+		IR_dprintk(2, "LIRC data transfer started (%uus %s)\n",
+			TO_US(ev.duration), TO_STR(ev.pulse));
+	}
 
-	sample = ev.duration / 1000;
-	if (ev.pulse)
-		sample |= PULSE_BIT;
 
 	lirc_buffer_write(ir_dev->raw->lirc.drv->rbuf,
 			  (unsigned char *) &sample);
@@ -96,13 +104,13 @@ out:
 	return ret;
 }
 
-static long ir_lirc_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
+static long ir_lirc_ioctl(struct file *filep, unsigned int cmd, unsigned long __user arg)
 {
 	struct lirc_codec *lirc;
 	struct ir_input_dev *ir_dev;
 	int ret = 0;
 	void *drv_data;
-	unsigned long val;
+	unsigned long val = 0;
 
 	lirc = lirc_get_pdata(filep);
 	if (!lirc)
@@ -114,24 +122,22 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd, unsigned long ar
 
 	drv_data = ir_dev->props->priv;
 
-	switch (cmd) {
-	case LIRC_SET_TRANSMITTER_MASK:
+	if (_IOC_DIR(cmd) & _IOC_WRITE) {
 		ret = get_user(val, (unsigned long *)arg);
 		if (ret)
 			return ret;
+	}
 
-		if (ir_dev->props && ir_dev->props->s_tx_mask)
+	switch (cmd) {
+	case LIRC_SET_TRANSMITTER_MASK:
+		if (ir_dev->props->s_tx_mask)
 			ret = ir_dev->props->s_tx_mask(drv_data, (u32)val);
 		else
 			return -EINVAL;
 		break;
 
 	case LIRC_SET_SEND_CARRIER:
-		ret = get_user(val, (unsigned long *)arg);
-		if (ret)
-			return ret;
-
-		if (ir_dev->props && ir_dev->props->s_tx_carrier)
+		if (ir_dev->props->s_tx_carrier)
 			ir_dev->props->s_tx_carrier(drv_data, (u32)val);
 		else
 			return -EINVAL;
@@ -139,22 +145,79 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd, unsigned long ar
 
 	case LIRC_GET_SEND_MODE:
 		val = LIRC_CAN_SEND_PULSE & LIRC_CAN_SEND_MASK;
-		ret = put_user(val, (unsigned long *)arg);
 		break;
 
 	case LIRC_SET_SEND_MODE:
-		ret = get_user(val, (unsigned long *)arg);
-		if (ret)
-			return ret;
-
 		if (val != (LIRC_MODE_PULSE & LIRC_CAN_SEND_MASK))
 			return -EINVAL;
 		break;
 
+	case LIRC_GET_REC_RESOLUTION:
+		val = ir_dev->props->rx_resolution;
+		break;
+
+	case LIRC_SET_REC_TIMEOUT:
+		if (val < ir_dev->props->min_timeout ||
+			val > ir_dev->props->max_timeout)
+			return -EINVAL;
+		ir_dev->props->timeout = val;
+		break;
+
+	case LIRC_SET_REC_TIMEOUT_REPORTS:
+		ir_dev->raw->lirc.timeout_report = !!val;
+		return 0;
+
+	case LIRC_GET_MIN_TIMEOUT:
+		if (!ir_dev->props->max_timeout)
+			return -ENOSYS;
+		val = ir_dev->props->min_timeout;
+		break;
+	case LIRC_GET_MAX_TIMEOUT:
+		if (!ir_dev->props->max_timeout)
+			return -ENOSYS;
+		val = ir_dev->props->max_timeout;
+		break;
+
+	case LIRC_SET_LEARN_MODE:
+		if (ir_dev->props->s_learning_mode)
+			return ir_dev->props->s_learning_mode(
+				ir_dev->props->priv, !!val);
+		else
+			return -ENOSYS;
+
+	case LIRC_SET_REC_CARRIER:
+		if (ir_dev->props->s_rx_carrier_range)
+			ret =  ir_dev->props->s_rx_carrier_range(
+				ir_dev->props->priv,
+					ir_dev->raw->lirc.carrier_low, val);
+		else
+			return -ENOSYS;
+
+		if (!ret)
+			ir_dev->raw->lirc.carrier_low = 0;
+		break;
+
+	case LIRC_SET_REC_CARRIER_RANGE:
+		if (val >= 0)
+			ir_dev->raw->lirc.carrier_low = val;
+		break;
+
+	case LIRC_SET_SEND_DUTY_CYCLE:
+		if (!ir_dev->props->s_tx_duty_cycle)
+			return -ENOSYS;
+
+		if (val <= 0 || val >= 100)
+			return -EINVAL;
+
+		ir_dev->props->s_tx_duty_cycle(ir_dev->props->priv, val);
+		break;
+
 	default:
 		return lirc_dev_fop_ioctl(filep, cmd, arg);
 	}
 
+	if (_IOC_DIR(cmd) & _IOC_READ)
+		ret = put_user(val, (unsigned long *)arg);
 	return ret;
 }
 
@@ -200,13 +263,25 @@ static int ir_lirc_register(struct input_dev *input_dev)
 
 	features = LIRC_CAN_REC_MODE2;
 	if (ir_dev->props->tx_ir) {
+
 		features |= LIRC_CAN_SEND_PULSE;
 		if (ir_dev->props->s_tx_mask)
 			features |= LIRC_CAN_SET_TRANSMITTER_MASK;
 		if (ir_dev->props->s_tx_carrier)
 			features |= LIRC_CAN_SET_SEND_CARRIER;
+
+		if (ir_dev->props->s_tx_duty_cycle)
+			features |= LIRC_CAN_SET_REC_DUTY_CYCLE;
 	}
 
+	if (ir_dev->props->s_rx_carrier_range)
+		features |= LIRC_CAN_SET_REC_CARRIER |
+			LIRC_CAN_SET_REC_CARRIER_RANGE;
+
+	if (ir_dev->props->s_learning_mode)
+		features |= LIRC_CAN_LEARN_MODE;
+
+
 	snprintf(drv->name, sizeof(drv->name), "ir-lirc-codec (%s)",
 		 ir_dev->driver_name);
 	drv->minor = -1;
diff --git a/drivers/media/IR/ir-raw-event.c b/drivers/media/IR/ir-raw-event.c
index bdf2ed8..2a5b824 100644
--- a/drivers/media/IR/ir-raw-event.c
+++ b/drivers/media/IR/ir-raw-event.c
@@ -187,6 +187,9 @@ void ir_raw_event_set_idle(struct input_dev *input_dev, int idle)
 
 	if (idle) {
 		IR_dprintk(2, "enter idle mode\n");
+		ir_raw_event_store(input_dev, &raw->current_sample);
+		ir_raw_event_reset(input_dev);
+		raw->current_sample.duration = 0;
 		raw->last_event = ktime_get();
 	} else {
 		IR_dprintk(2, "exit idle mode\n");
@@ -194,17 +197,11 @@ void ir_raw_event_set_idle(struct input_dev *input_dev, int idle)
 		now = ktime_get();
 		delta = ktime_to_ns(ktime_sub(now, ir->raw->last_event));
 
-		WARN_ON(raw->current_sample.pulse);
-
-		raw->current_sample.duration =
-			min(raw->current_sample.duration + delta,
+		raw->current_sample.duration = min(delta,
 						(u64)IR_MAX_DURATION);
+		raw->current_sample.pulse = false;
 
 		ir_raw_event_store(input_dev, &raw->current_sample);
-
-		if (raw->current_sample.duration == IR_MAX_DURATION)
-			ir_raw_event_reset(input_dev);
-
 		raw->current_sample.duration = 0;
 	}
 out:
diff --git a/include/media/ir-core.h b/include/media/ir-core.h
index e895054..7299e7a 100644
--- a/include/media/ir-core.h
+++ b/include/media/ir-core.h
@@ -44,6 +44,8 @@ enum rc_driver_type {
  * @timeout: optional time after which device stops sending data
  * @min_timeout: minimum timeout supported by device
  * @max_timeout: maximum timeout supported by device
+ * @rx_resolution : resolution (in ns) of input sampler
+ * @tx_resolution: resolution (in ns) of output sampler
  * @priv: driver-specific data, to be used on the callbacks
  * @change_protocol: allow changing the protocol used on hardware decoders
  * @open: callback to allow drivers to enable polling/irq when IR input device
@@ -52,9 +54,12 @@ enum rc_driver_type {
  *	is opened.
  * @s_tx_mask: set transmitter mask (for devices with multiple tx outputs)
  * @s_tx_carrier: set transmit carrier frequency
+ * @s_tx_duty_cycle: set transmit duty cycle (0% - 100%)
+ * @s_rx_carrier: inform driver about carrier it is expected to handle
  * @tx_ir: transmit IR
  * @s_idle: optional: enable/disable hardware idle mode, upon which,
 	device doesn't interrupt host untill it sees IR data
+ * @s_learning_mode: enable learning mode
  */
 struct ir_dev_props {
 	enum rc_driver_type	driver_type;
@@ -65,6 +70,8 @@ struct ir_dev_props {
 	u64			min_timeout;
 	u64			max_timeout;
 
+	u32			rx_resolution;
+	u32			tx_resolution;
 
 	void			*priv;
 	int			(*change_protocol)(void *priv, u64 ir_type);
@@ -72,8 +79,12 @@ struct ir_dev_props {
 	void			(*close)(void *priv);
 	int			(*s_tx_mask)(void *priv, u32 mask);
 	int			(*s_tx_carrier)(void *priv, u32 carrier);
+	int			(*s_tx_duty_cycle) (void *priv, u32 duty_cycle);
+	int			(*s_rx_carrier_range) (void *priv, u32 min, u32 max);
 	int			(*tx_ir)(void *priv, int *txbuf, u32 n);
 	void			(*s_idle) (void *priv, int enable);
+	int			(*s_learning_mode) (void *priv, int enable);
+
 };
 
 struct ir_input_dev {
diff --git a/include/media/lirc.h b/include/media/lirc.h
index 42c467c..caf172b 100644
--- a/include/media/lirc.h
+++ b/include/media/lirc.h
@@ -76,7 +76,7 @@
 #define LIRC_CAN_SET_REC_TIMEOUT          0x10000000
 #define LIRC_CAN_SET_REC_FILTER           0x08000000
 
-#define LIRC_CAN_MEASURE_CARRIER          0x02000000
+#define LIRC_CAN_LEARN_MODE               0x02000000
 
 #define LIRC_CAN_SEND(x) ((x)&LIRC_CAN_SEND_MASK)
 #define LIRC_CAN_REC(x) ((x)&LIRC_CAN_REC_MASK)
@@ -145,7 +145,7 @@
  * if enabled from the next key press on the driver will send
  * LIRC_MODE2_FREQUENCY packets
  */
-#define LIRC_SET_MEASURE_CARRIER_MODE  _IOW('i', 0x0000001d, __u32)
+#define LIRC_SET_LEARN_MODE		_IOW('i', 0x0000001d, __u32)
 
 /*
  * to set a range use
-- 
1.7.0.4

