Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45485 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758525Ab0G3LjZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jul 2010 07:39:25 -0400
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: lirc-list@lists.sourceforge.net
Cc: Jarod Wilson <jarod@wilsonet.com>, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 10/13] IR: extend interfaces to support more device settings LIRC: add new IOCTL that enables learning mode (wide band receiver)
Date: Fri, 30 Jul 2010 14:38:50 +0300
Message-Id: <1280489933-20865-11-git-send-email-maximlevitsky@gmail.com>
In-Reply-To: <1280489933-20865-1-git-send-email-maximlevitsky@gmail.com>
References: <1280489933-20865-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Still missing features: carrier report & timeout reports.
Will need to pack these into ir_raw_event


Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/media/IR/ir-core-priv.h  |    1 +
 drivers/media/IR/ir-lirc-codec.c |  112 +++++++++++++++++++++++++++++++-------
 include/media/ir-core.h          |   14 +++++
 include/media/lirc.h             |    5 ++-
 4 files changed, 112 insertions(+), 20 deletions(-)

diff --git a/drivers/media/IR/ir-core-priv.h b/drivers/media/IR/ir-core-priv.h
index 30ff52c..52253b4 100644
--- a/drivers/media/IR/ir-core-priv.h
+++ b/drivers/media/IR/ir-core-priv.h
@@ -78,6 +78,7 @@ struct ir_raw_event_ctrl {
 	struct lirc_codec {
 		struct ir_input_dev *ir_dev;
 		struct lirc_driver *drv;
+		int carrier_low;
 	} lirc;
 };
 
diff --git a/drivers/media/IR/ir-lirc-codec.c b/drivers/media/IR/ir-lirc-codec.c
index 8ca01fd..5d5150f 100644
--- a/drivers/media/IR/ir-lirc-codec.c
+++ b/drivers/media/IR/ir-lirc-codec.c
@@ -46,7 +46,6 @@ static int ir_lirc_decode(struct input_dev *input_dev, struct ir_raw_event ev)
 	IR_dprintk(2, "LIRC data transfer started (%uus %s)\n",
 		   TO_US(ev.duration), TO_STR(ev.pulse));
 
-
 	sample = ev.duration / 1000;
 	if (ev.pulse)
 		sample |= PULSE_BIT;
@@ -96,13 +95,14 @@ out:
 	return ret;
 }
 
-static long ir_lirc_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
+static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
+			unsigned long __user arg)
 {
 	struct lirc_codec *lirc;
 	struct ir_input_dev *ir_dev;
 	int ret = 0;
 	void *drv_data;
-	unsigned long val;
+	unsigned long val = 0;
 
 	lirc = lirc_get_pdata(filep);
 	if (!lirc)
@@ -114,47 +114,106 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd, unsigned long ar
 
 	drv_data = ir_dev->props->priv;
 
-	switch (cmd) {
-	case LIRC_SET_TRANSMITTER_MASK:
+	if (_IOC_DIR(cmd) & _IOC_WRITE) {
 		ret = get_user(val, (unsigned long *)arg);
 		if (ret)
 			return ret;
+	}
+
+	switch (cmd) {
+
+	/* legacy support */
+	case LIRC_GET_SEND_MODE:
+		val = LIRC_CAN_SEND_PULSE & LIRC_CAN_SEND_MASK;
+		break;
+
+	case LIRC_SET_SEND_MODE:
+		if (val != (LIRC_MODE_PULSE & LIRC_CAN_SEND_MASK))
+			return -EINVAL;
+		break;
 
-		if (ir_dev->props && ir_dev->props->s_tx_mask)
+	/* TX settings */
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
 		break;
 
-	case LIRC_GET_SEND_MODE:
-		val = LIRC_CAN_SEND_PULSE & LIRC_CAN_SEND_MASK;
-		ret = put_user(val, (unsigned long *)arg);
+	case LIRC_SET_SEND_DUTY_CYCLE:
+		if (!ir_dev->props->s_tx_duty_cycle)
+			return -ENOSYS;
+
+		if (val <= 0 || val >= 100)
+			return -EINVAL;
+
+		ir_dev->props->s_tx_duty_cycle(ir_dev->props->priv, val);
 		break;
 
-	case LIRC_SET_SEND_MODE:
-		ret = get_user(val, (unsigned long *)arg);
-		if (ret)
-			return ret;
+	/* RX settings */
+	case LIRC_SET_REC_CARRIER:
+		if (ir_dev->props->s_rx_carrier_range)
+			ret = ir_dev->props->s_rx_carrier_range(
+				ir_dev->props->priv,
+				ir_dev->raw->lirc.carrier_low, val);
+		else
+			return -ENOSYS;
 
-		if (val != (LIRC_MODE_PULSE & LIRC_CAN_SEND_MASK))
+		if (!ret)
+			ir_dev->raw->lirc.carrier_low = 0;
+		break;
+
+	case LIRC_SET_REC_CARRIER_RANGE:
+		if (val >= 0)
+			ir_dev->raw->lirc.carrier_low = val;
+		break;
+
+
+	case LIRC_GET_REC_RESOLUTION:
+		val = ir_dev->props->rx_resolution;
+		break;
+
+	case LIRC_SET_WIDEBAND_RECEIVER:
+		if (ir_dev->props->s_learning_mode)
+			return ir_dev->props->s_learning_mode(
+				ir_dev->props->priv, !!val);
+		else
+			return -ENOSYS;
+
+	/* Generic timeout support */
+	case LIRC_GET_MIN_TIMEOUT:
+		if (!ir_dev->props->max_timeout)
+			return -ENOSYS;
+		val = ir_dev->props->min_timeout / 1000;
+		break;
+
+	case LIRC_GET_MAX_TIMEOUT:
+		if (!ir_dev->props->max_timeout)
+			return -ENOSYS;
+		val = ir_dev->props->max_timeout / 1000;
+		break;
+
+	case LIRC_SET_REC_TIMEOUT:
+		if (val < ir_dev->props->min_timeout ||
+		    val > ir_dev->props->max_timeout)
 			return -EINVAL;
+		ir_dev->props->timeout = val * 1000;
 		break;
 
 	default:
 		return lirc_dev_fop_ioctl(filep, cmd, arg);
 	}
 
+	if (_IOC_DIR(cmd) & _IOC_READ)
+		ret = put_user(val, (unsigned long *)arg);
+
 	return ret;
 }
 
@@ -200,13 +259,28 @@ static int ir_lirc_register(struct input_dev *input_dev)
 
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
+		features |= LIRC_CAN_HAVE_WIDEBAND_RECEIVER;
+
+	if (ir_dev->props->max_timeout)
+		features |= LIRC_CAN_SET_REC_TIMEOUT;
+
+
 	snprintf(drv->name, sizeof(drv->name), "ir-lirc-codec (%s)",
 		 ir_dev->driver_name);
 	drv->minor = -1;
diff --git a/include/media/ir-core.h b/include/media/ir-core.h
index 7ad39fe..ed9c1cb 100644
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
@@ -52,9 +54,16 @@ enum rc_driver_type {
  *	is opened.
  * @s_tx_mask: set transmitter mask (for devices with multiple tx outputs)
  * @s_tx_carrier: set transmit carrier frequency
+ * @s_tx_duty_cycle: set transmit duty cycle (0% - 100%)
+ * @s_rx_carrier: inform driver about carrier it is expected to handle
  * @tx_ir: transmit IR
  * @s_idle: optional: enable/disable hardware idle mode, upon which,
+<<<<<<< current
  *	device doesn't interrupt host untill it sees IR data
+=======
+	device doesn't interrupt host untill it sees IR data
+ * @s_learning_mode: enable wide band receiver used for learning
+>>>>>>> patched
  */
 struct ir_dev_props {
 	enum rc_driver_type	driver_type;
@@ -65,6 +74,8 @@ struct ir_dev_props {
 	u64			min_timeout;
 	u64			max_timeout;
 
+	u32			rx_resolution;
+	u32			tx_resolution;
 
 	void			*priv;
 	int			(*change_protocol)(void *priv, u64 ir_type);
@@ -72,8 +83,11 @@ struct ir_dev_props {
 	void			(*close)(void *priv);
 	int			(*s_tx_mask)(void *priv, u32 mask);
 	int			(*s_tx_carrier)(void *priv, u32 carrier);
+	int			(*s_tx_duty_cycle)(void *priv, u32 duty_cycle);
+	int			(*s_rx_carrier_range)(void *priv, u32 min, u32 max);
 	int			(*tx_ir)(void *priv, int *txbuf, u32 n);
 	void			(*s_idle)(void *priv, int enable);
+	int			(*s_learning_mode)(void *priv, int enable);
 };
 
 struct ir_input_dev {
diff --git a/include/media/lirc.h b/include/media/lirc.h
index 42c467c..bda3d03 100644
--- a/include/media/lirc.h
+++ b/include/media/lirc.h
@@ -77,6 +77,7 @@
 #define LIRC_CAN_SET_REC_FILTER           0x08000000
 
 #define LIRC_CAN_MEASURE_CARRIER          0x02000000
+#define LIRC_CAN_HAVE_WIDEBAND_RECEIVER   0x04000000
 
 #define LIRC_CAN_SEND(x) ((x)&LIRC_CAN_SEND_MASK)
 #define LIRC_CAN_REC(x) ((x)&LIRC_CAN_REC_MASK)
@@ -145,7 +146,7 @@
  * if enabled from the next key press on the driver will send
  * LIRC_MODE2_FREQUENCY packets
  */
-#define LIRC_SET_MEASURE_CARRIER_MODE  _IOW('i', 0x0000001d, __u32)
+#define LIRC_SET_MEASURE_CARRIER_MODE	_IOW('i', 0x0000001d, __u32)
 
 /*
  * to set a range use
@@ -162,4 +163,6 @@
 #define LIRC_SETUP_START               _IO('i', 0x00000021)
 #define LIRC_SETUP_END                 _IO('i', 0x00000022)
 
+#define LIRC_SET_WIDEBAND_RECEIVER     _IOW('i', 0x00000023, __u32)
+
 #endif
-- 
1.7.0.4

