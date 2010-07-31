Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39082 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756190Ab0GaO7z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Jul 2010 10:59:55 -0400
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: lirc-list@lists.sourceforge.net
Cc: Jarod Wilson <jarod@wilsonet.com>, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 10/13] IR: extend interfaces to support more device settings
Date: Sat, 31 Jul 2010 17:59:23 +0300
Message-Id: <1280588366-26101-11-git-send-email-maximlevitsky@gmail.com>
In-Reply-To: <1280588366-26101-1-git-send-email-maximlevitsky@gmail.com>
References: <1280588366-26101-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

LIRC: add new IOCTL that enables learning mode (wide band receiver)
Still missing features: carrier report & timeout reports.
Will need to pack these into ir_raw_event


Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 .../DocBook/v4l/lirc_device_interface.xml          |   16 +++
 drivers/media/IR/ir-core-priv.h                    |    1 +
 drivers/media/IR/ir-lirc-codec.c                   |  112 ++++++++++++++++----
 include/media/ir-core.h                            |   12 ++-
 include/media/lirc.h                               |    5 +-
 5 files changed, 125 insertions(+), 21 deletions(-)

diff --git a/Documentation/DocBook/v4l/lirc_device_interface.xml b/Documentation/DocBook/v4l/lirc_device_interface.xml
index 0413234..68134c0 100644
--- a/Documentation/DocBook/v4l/lirc_device_interface.xml
+++ b/Documentation/DocBook/v4l/lirc_device_interface.xml
@@ -229,6 +229,22 @@ on working with the default settings initially.</para>
       and LIRC_SETUP_END. Drivers can also choose to ignore these ioctls.</para>
     </listitem>
   </varlistentry>
+  <varlistentry>
+    <term>LIRC_SET_WIDEBAND_RECEIVER</term>
+    <listitem>
+      <para>Some receivers are equipped with special wide band receiver which is intended
+      to be used to learn output of existing remote.
+      Calling that ioctl with (1) will enable it, and with (0) disable it.
+      This might be useful of receivers that have otherwise narrow band receiver
+      that prevents them to be used with some remotes.
+      Wide band receiver might also be more precise
+      On the other hand its disadvantage it usually reduced range of reception.
+      Note: wide band receiver might be implictly enabled if you enable
+      carrier reports. In that case it will be disabled as soon as you disable
+      carrier reports. Trying to disable wide band receiver while carrier
+      reports are active will do nothing.</para>
+    </listitem>
+  </varlistentry>
 </variablelist>
 
 </section>
diff --git a/drivers/media/IR/ir-core-priv.h b/drivers/media/IR/ir-core-priv.h
index 8053e3b..a85a8c7 100644
--- a/drivers/media/IR/ir-core-priv.h
+++ b/drivers/media/IR/ir-core-priv.h
@@ -79,6 +79,7 @@ struct ir_raw_event_ctrl {
 	struct lirc_codec {
 		struct ir_input_dev *ir_dev;
 		struct lirc_driver *drv;
+		int carrier_low;
 	} lirc;
 };
 
diff --git a/drivers/media/IR/ir-lirc-codec.c b/drivers/media/IR/ir-lirc-codec.c
index 8ca01fd..77b5946 100644
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
+		features |= LIRC_CAN_USE_WIDEBAND_RECEIVER;
+
+	if (ir_dev->props->max_timeout)
+		features |= LIRC_CAN_SET_REC_TIMEOUT;
+
+
 	snprintf(drv->name, sizeof(drv->name), "ir-lirc-codec (%s)",
 		 ir_dev->driver_name);
 	drv->minor = -1;
diff --git a/include/media/ir-core.h b/include/media/ir-core.h
index a781045..eb7fddf 100644
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
- *	device doesn't interrupt host untill it sees IR data
+	device doesn't interrupt host until it sees IR pulses
+ * @s_learning_mode: enable wide band receiver used for learning
  */
 struct ir_dev_props {
 	enum rc_driver_type	driver_type;
@@ -65,6 +70,8 @@ struct ir_dev_props {
 	u32			min_timeout;
 	u32			max_timeout;
 
+	u32			rx_resolution;
+	u32			tx_resolution;
 
 	void			*priv;
 	int			(*change_protocol)(void *priv, u64 ir_type);
@@ -72,8 +79,11 @@ struct ir_dev_props {
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
index 42c467c..6678a16 100644
--- a/include/media/lirc.h
+++ b/include/media/lirc.h
@@ -77,6 +77,7 @@
 #define LIRC_CAN_SET_REC_FILTER           0x08000000
 
 #define LIRC_CAN_MEASURE_CARRIER          0x02000000
+#define LIRC_CAN_USE_WIDEBAND_RECEIVER    0x04000000
 
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

