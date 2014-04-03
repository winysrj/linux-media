Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:40319 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754019AbaDCXdj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Apr 2014 19:33:39 -0400
Subject: [PATCH 28/49] rc-core: add an ioctl for setting IR TX settings
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Date: Fri, 04 Apr 2014 01:33:37 +0200
Message-ID: <20140403233337.27099.52201.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
References: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
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
index 6e31c83..7b56f21 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -189,6 +189,7 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 	int ret = 0;
 	__u32 val = 0, tmp;
 	struct rc_ir_rx rx;
+	struct rc_ir_tx tx;
 
 	lirc = lirc_get_pdata(filep);
 	if (!lirc)
@@ -218,25 +219,46 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 
 	/* TX settings */
 	case LIRC_SET_TRANSMITTER_MASK:
-		if (!dev->s_tx_mask)
-			return -ENOSYS;
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
+		return -ENOSYS;
 
 	case LIRC_SET_SEND_CARRIER:
-		if (!dev->s_tx_carrier)
-			return -ENOSYS;
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
+		return -ENOSYS;
 
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
index 611d24d..cc2f713 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1714,6 +1714,19 @@ static long rc_do_ioctl(struct rc_dev *dev, unsigned int cmd, unsigned long arg)
 
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
index 566ae7d..eacb735 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -116,8 +116,11 @@ struct rc_ir_rx {
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
@@ -293,9 +296,9 @@ enum rc_filter_type {
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
@@ -307,6 +310,7 @@ enum rc_filter_type {
  * @get_ir_rx: allow driver to provide rx settings
  * @set_ir_rx: allow driver to change rx settings
  * @get_ir_tx: allow driver to provide tx settings
+ * @set_ir_tx: allow driver to change tx settings
  */
 struct rc_dev {
 	struct device			dev;
@@ -371,6 +375,7 @@ struct rc_dev {
 	void				(*get_ir_rx)(struct rc_dev *dev, struct rc_ir_rx *rx);
 	int				(*set_ir_rx)(struct rc_dev *dev, struct rc_ir_rx *rx);
 	void				(*get_ir_tx)(struct rc_dev *dev, struct rc_ir_tx *tx);
+	int				(*set_ir_tx)(struct rc_dev *dev, struct rc_ir_tx *tx);
 };
 
 #define to_rc_dev(d) container_of(d, struct rc_dev, dev)

