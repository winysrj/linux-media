Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:40311 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803AbaDCXdS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Apr 2014 19:33:18 -0400
Subject: [PATCH 24/49] rc-core: add an ioctl for setting IR RX settings
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Date: Fri, 04 Apr 2014 01:33:17 +0200
Message-ID: <20140403233317.27099.56676.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
References: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds a complementary ioctl to allow IR RX settings to be
changed.

Userspace is expected to first call RCIOCGIRRX, change the relevant parameters
in struct rc_ir_rx and then call RCIOCSIRRX.

The struct will be updated to reflect what the driver actually set the
parameters to (as all values may not be possible and some might have
to be approximated, e.g. because the hardware only supports some fixed
values) so that userspace knows the end result.

The LIRC driver is also changed to use the new RCIOCGIRRX and RCIOCSIRRX
methods as an alternative to the old functionality. This allows several
operations in struct rc_dev to be deprecated.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/ir-lirc-codec.c |   53 +++++++++++++++++++++++++++++---------
 drivers/media/rc/rc-core-priv.h  |    3 ++
 drivers/media/rc/rc-main.c       |   53 +++++++++++++++++++++++++++++---------
 include/media/rc-core.h          |    9 +++++-
 4 files changed, 90 insertions(+), 28 deletions(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 7d58eea..6e31c83 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -188,6 +188,7 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 	u32 __user *argp = (u32 __user *)(arg);
 	int ret = 0;
 	__u32 val = 0, tmp;
+	struct rc_ir_rx rx;
 
 	lirc = lirc_get_pdata(filep);
 	if (!lirc)
@@ -239,15 +240,23 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 
 	/* RX settings */
 	case LIRC_SET_REC_CARRIER:
-		if (!dev->s_rx_carrier_range)
-			return -ENOSYS;
-
-		if (val <= 0)
+		if (val <= 0 || val < dev->raw->lirc.carrier_low)
 			return -EINVAL;
 
-		return dev->s_rx_carrier_range(dev,
-					       dev->raw->lirc.carrier_low,
-					       val);
+		if (dev->s_rx_carrier_range)
+			return dev->s_rx_carrier_range(dev,
+						       dev->raw->lirc.carrier_low,
+						       val);
+
+		if (dev->get_ir_rx && dev->set_ir_rx) {
+			rc_init_ir_rx(dev, &rx);
+			dev->get_ir_rx(dev, &rx);
+			rx.freq_min = dev->raw->lirc.carrier_low;
+			rx.freq_max = val;
+			return dev->set_ir_rx(dev, &rx);
+		}
+
+		return -ENOSYS;
 
 	case LIRC_SET_REC_CARRIER_RANGE:
 		if (val <= 0)
@@ -261,16 +270,34 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 		break;
 
 	case LIRC_SET_WIDEBAND_RECEIVER:
-		if (!dev->s_learning_mode)
-			return -ENOSYS;
+		if (dev->s_learning_mode)
+			return dev->s_learning_mode(dev, !!val);
+
+		if (dev->get_ir_rx && dev->set_ir_rx) {
+			rc_init_ir_rx(dev, &rx);
+			dev->get_ir_rx(dev, &rx);
+			rx.rx_enabled = (!!val) ? rx.rx_learning : ~rx.rx_learning;
+			rx.rx_enabled &= rx.rx_supported;
+			return dev->set_ir_rx(dev, &rx);
+		}
 
-		return dev->s_learning_mode(dev, !!val);
+		return -ENOSYS;
 
 	case LIRC_SET_MEASURE_CARRIER_MODE:
-		if (!dev->s_carrier_report)
-			return -ENOSYS;
+		if (dev->s_carrier_report)
+			return dev->s_carrier_report(dev, !!val);
+
+		if (dev->get_ir_rx && dev->set_ir_rx) {
+			rc_init_ir_rx(dev, &rx);
+			dev->get_ir_rx(dev, &rx);
+			if (!!val)
+				rx.flags |= RC_IR_RX_MEASURE_CARRIER;
+			else
+				rx.flags &= ~RC_IR_RX_MEASURE_CARRIER;
+			return dev->set_ir_rx(dev, &rx);
+		}
 
-		return dev->s_carrier_report(dev, !!val);
+		return -ENOSYS;
 
 	/* Generic timeout support */
 	case LIRC_GET_MIN_TIMEOUT:
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index dea7aff..aacc192 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -155,6 +155,9 @@ int ir_raw_handler_register(struct ir_raw_handler *ir_raw_handler);
 void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler);
 void ir_raw_init(void);
 
+/* Only to be used by rc-core and ir-lirc-codec */
+void rc_init_ir_rx(struct rc_dev *dev, struct rc_ir_rx *rx);
+
 /*
  * Decoder initialization code
  *
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index c391518..3ad565f 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1636,6 +1636,31 @@ static int rc_fasync(int fd, struct file *file, int on)
 }
 
 /**
+ * rc_init_ir_rx() - initializes a &struct rc_ir_rx to sane defaults
+ * @dev:	the &struct rc_dev to take initial settings from
+ * @rx:		the &struct rx_ir_rx to fill in with default values
+ *
+ * This function should only to be used by rc-core and ir-lirc-codec.
+ */
+void rc_init_ir_rx(struct rc_dev *dev, struct rc_ir_rx *rx)
+{
+	memset(rx, 0, sizeof(*rx));
+	rx->rx_supported = 0x1;
+	rx->rx_enabled = 0x1;
+	rx->rx_connected = 0x1;
+	rx->protocols_enabled[0] = dev->enabled_protocols;
+	if (dev->driver_type == RC_DRIVER_SCANCODE)
+		rx->protocols_supported[0] = dev->allowed_protocols;
+	else
+		rx->protocols_supported[0] = ir_raw_get_allowed_protocols();
+	rx->timeout = dev->timeout;
+	rx->timeout_min = dev->min_timeout;
+	rx->timeout_max = dev->max_timeout;
+	rx->resolution = dev->rx_resolution;
+}
+EXPORT_SYMBOL_GPL(rc_init_ir_rx);
+
+/**
  * rc_do_ioctl() - internal implementation of ioctl handling
  * @dev:	the &struct rc_dev to perform the command on
  * @cmd:	the ioctl command to perform
@@ -1650,6 +1675,7 @@ static long rc_do_ioctl(struct rc_dev *dev, unsigned int cmd, unsigned long arg)
 	void __user *p = (void __user *)arg;
 	unsigned int __user *ip = (unsigned int __user *)p;
 	struct rc_ir_rx rx;
+	int error;
 
 	switch (cmd) {
 
@@ -1662,20 +1688,21 @@ static long rc_do_ioctl(struct rc_dev *dev, unsigned int cmd, unsigned long arg)
 	case RCIOCGIRPSIZE:
 		return put_user(ARRAY_SIZE(rx.protocols_supported), ip);
 
+	case RCIOCSIRRX:
+		if (!dev->set_ir_rx)
+			return -ENOSYS;
+
+		if (copy_from_user(&rx, p, sizeof(rx)))
+			return -EFAULT;
+
+		error = dev->set_ir_rx(dev, &rx);
+		if (error)
+			return error;
+
+		/* Fall through */
+
 	case RCIOCGIRRX:
-		memset(&rx, 0, sizeof(rx));
-		rx.rx_supported = 0x1;
-		rx.rx_enabled = 0x1;
-		rx.rx_connected = 0x1;
-		rx.protocols_enabled[0] = dev->enabled_protocols;
-		if (dev->driver_type == RC_DRIVER_SCANCODE)
-			rx.protocols_supported[0] = dev->allowed_protocols;
-		else
-			rx.protocols_supported[0] = ir_raw_get_allowed_protocols();
-		rx.timeout = dev->timeout;
-		rx.timeout_min = dev->min_timeout;
-		rx.timeout_max = dev->max_timeout;
-		rx.resolution = dev->rx_resolution;
+		rc_init_ir_rx(dev, &rx);
 
 		/* See if the driver wishes to override anything */
 		if (dev->get_ir_rx)
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 7392258..09bf8b5 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -54,8 +54,11 @@ do {								\
 /* get ir rx parameters */
 #define RCIOCGIRRX	_IOC(_IOC_READ, RC_IOC_MAGIC, 0x04, sizeof(struct rc_ir_rx))
 
+/* set ir rx parameters */
+#define RCIOCSIRRX	_IOC(_IOC_WRITE, RC_IOC_MAGIC, 0x04, sizeof(struct rc_ir_rx))
+
 /**
- * struct rc_ir_rx - used to get all IR RX parameters in one go
+ * struct rc_ir_rx - used to get/set all IR RX parameters in one go
  * @flags: device specific flags (only %RC_IR_RX_MEASURE_CARRIER is
  *	currently defined)
  * @rx_supported: bitmask of supported (i.e. possible) receivers
@@ -257,7 +260,7 @@ enum rc_filter_type {
  * @s_tx_mask: set transmitter mask (for devices with multiple tx outputs)
  * @s_tx_carrier: set transmit carrier frequency
  * @s_tx_duty_cycle: set transmit duty cycle (0% - 100%)
- * @s_rx_carrier: inform driver about carrier it is expected to handle
+ * @s_rx_carrier: inform driver about expected carrier (deprecated)
  * @tx_ir: transmit IR
  * @s_idle: enable/disable hardware idle mode, upon which,
  *	device doesn't interrupt host until it sees IR pulses
@@ -266,6 +269,7 @@ enum rc_filter_type {
  * @s_filter: set the scancode filter 
  * @s_wakeup_filter: set the wakeup scancode filter
  * @get_ir_rx: allow driver to provide rx settings
+ * @set_ir_rx: allow driver to change rx settings
  */
 struct rc_dev {
 	struct device			dev;
@@ -328,6 +332,7 @@ struct rc_dev {
 	int				(*s_wakeup_filter)(struct rc_dev *dev,
 							   struct rc_scancode_filter *filter);
 	void				(*get_ir_rx)(struct rc_dev *dev, struct rc_ir_rx *rx);
+	int				(*set_ir_rx)(struct rc_dev *dev, struct rc_ir_rx *rx);
 };
 
 #define to_rc_dev(d) container_of(d, struct rc_dev, dev)

