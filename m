Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:44283 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933295Ab2EWJyy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 05:54:54 -0400
Subject: [PATCH 22/43] rc-core: add an ioctl for setting IR TX settings
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: mchehab@redhat.com, jarod@redhat.com
Date: Wed, 23 May 2012 11:43:56 +0200
Message-ID: <20120523094356.14474.8152.stgit@felix.hardeman.nu>
In-Reply-To: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
References: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds a complementary ioctl to allow IR TX settings to be
changed.

Much like the RCIOCSIRRX functionality, userspace is expected to call
RCIOCGIRTX, change values and then call RCIOCSIRTX and finally inspect
the struct rc_ir_tx to see the results.

Also, LIRC is changed to use the new functionality as an alternative to the
old one and another bunch of operations in struct rc_dev are now deprecated.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/ir-lirc-codec.c |   42 +++++++++++++++++++++++++++++---------
 drivers/media/rc/rc-main.c       |   13 ++++++++++++
 include/media/rc-core.h          |   13 ++++++++----
 3 files changed, 54 insertions(+), 14 deletions(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 767fd06..6811db9 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -161,6 +161,7 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 	int ret = 0;
 	__u32 val = 0, tmp;
 	struct rc_ir_rx rx;
+	struct rc_ir_tx tx;
 
 	lirc = lirc_get_pdata(filep);
 	if (!lirc)
@@ -190,25 +191,46 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 
 	/* TX settings */
 	case LIRC_SET_TRANSMITTER_MASK:
-		if (!dev->s_tx_mask)
-			return -EINVAL;
+		if (dev->s_tx_mask)
+			return dev->s_tx_mask(dev, val);
 
-		return dev->s_tx_mask(dev, val);
+		if (dev->get_ir_tx && dev->set_ir_tx) {
+			memset(&tx, 0, sizeof(tx));
+			dev->get_ir_tx(dev, &tx);
+			tx.tx_enabled = val;
+			return dev->set_ir_tx(dev, &tx);
+		}
+
+		return -EINVAL;
 
 	case LIRC_SET_SEND_CARRIER:
-		if (!dev->s_tx_carrier)
-			return -EINVAL;
+		if (dev->s_tx_carrier)
+			return dev->s_tx_carrier(dev, val);
 
-		return dev->s_tx_carrier(dev, val);
+		if (dev->get_ir_tx && dev->set_ir_tx) {
+			memset(&tx, 0, sizeof(tx));
+			dev->get_ir_tx(dev, &tx);
+			tx.freq = val;
+			return dev->set_ir_tx(dev, &tx);
+		}
 
-	case LIRC_SET_SEND_DUTY_CYCLE:
-		if (!dev->s_tx_duty_cycle)
-			return -ENOSYS;
+		return -EINVAL;
 
+	case LIRC_SET_SEND_DUTY_CYCLE:
 		if (val <= 0 || val >= 100)
 			return -EINVAL;
 
-		return dev->s_tx_duty_cycle(dev, val);
+		if (dev->s_tx_duty_cycle)
+			return dev->s_tx_duty_cycle(dev, val);
+
+		if (dev->get_ir_tx && dev->set_ir_tx) {
+			memset(&tx, 0, sizeof(tx));
+			dev->get_ir_tx(dev, &tx);
+			tx.duty = val;
+			return dev->set_ir_tx(dev, &tx);
+		}
+
+		return -ENOSYS;
 
 	/* RX settings */
 	case LIRC_SET_REC_CARRIER:
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index e2b2e8c..f8a63e2 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1742,6 +1742,19 @@ static long rc_do_ioctl(struct rc_dev *dev, unsigned int cmd, unsigned long arg)
 
 		return 0;
 
+	case RCIOCSIRTX:
+		if (!dev->set_ir_tx)
+			return -ENOSYS;
+
+		if (copy_from_user(&tx, p, sizeof(tx)))
+			return -EFAULT;
+
+		error = dev->set_ir_tx(dev, &tx);
+		if (error)
+			return error;
+
+		/* Fall through */
+
 	case RCIOCGIRTX:
 		memset(&tx, 0, sizeof(tx));
 
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 9f3645b..843f363 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -115,8 +115,11 @@ struct rc_ir_rx {
 /* get ir tx parameters */
 #define RCIOCGIRTX	_IOC(_IOC_READ, RC_IOC_MAGIC, 0x05, sizeof(struct rc_ir_tx))
 
+/* set ir tx parameters */
+#define RCIOCSIRTX	_IOC(_IOC_WRITE, RC_IOC_MAGIC, 0x05, sizeof(struct rc_ir_tx))
+
 /**
- * struct rc_ir_tx - used to get all IR TX parameters in one go
+ * struct rc_ir_tx - used to get/set all IR TX parameters in one go
  * @flags: device specific flags
  * @tx_supported: bitmask of supported transmitters
  * @tx_enabled: bitmask of enabled transmitters
@@ -238,9 +241,9 @@ struct ir_raw_event {
  *	is opened.
  * @close: callback to allow drivers to disable polling/irq when IR input device
  *	is opened.
- * @s_tx_mask: set transmitter mask (for devices with multiple tx outputs)
- * @s_tx_carrier: set transmit carrier frequency
- * @s_tx_duty_cycle: set transmit duty cycle (0% - 100%)
+ * @s_tx_mask: set transmitter mask (for devices with multiple tx outputs, deprecated)
+ * @s_tx_carrier: set transmit carrier frequency (deprecated)
+ * @s_tx_duty_cycle: set transmit duty cycle (0% - 100%, deprecated)
  * @s_rx_carrier: inform driver about expected carrier (deprecated)
  * @tx_ir: transmit IR
  * @s_idle: enable/disable hardware idle mode, upon which,
@@ -250,6 +253,7 @@ struct ir_raw_event {
  * @get_ir_rx: allow driver to provide rx settings
  * @set_ir_rx: allow driver to change rx settings
  * @get_ir_tx: allow driver to provide tx settings
+ * @set_ir_tx: allow driver to change tx settings
  */
 struct rc_dev {
 	struct device			dev;
@@ -303,6 +307,7 @@ struct rc_dev {
 	void				(*get_ir_rx)(struct rc_dev *dev, struct rc_ir_rx *rx);
 	int				(*set_ir_rx)(struct rc_dev *dev, struct rc_ir_rx *rx);
 	void				(*get_ir_tx)(struct rc_dev *dev, struct rc_ir_tx *tx);
+	int				(*set_ir_tx)(struct rc_dev *dev, struct rc_ir_tx *tx);
 };
 
 #define to_rc_dev(d) container_of(d, struct rc_dev, dev)

