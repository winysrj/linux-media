Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:40315 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754019AbaDCXd3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Apr 2014 19:33:29 -0400
Subject: [PATCH 26/49] rc-core: add an ioctl for getting IR TX settings
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Date: Fri, 04 Apr 2014 01:33:27 +0200
Message-ID: <20140403233327.27099.21460.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
References: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This ioctl follows the same rationale and structure as the ioctl for
getting IR RX settings (RCIOCGIRRX) but it works on TX settings instead.

As with the RX ioctl, it would be nice if people could check struct
rc_ir_tx carefully to make sure that their favourite parameter
hasn't been left out.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/rc-main.c |   12 ++++++++++++
 include/media/rc-core.h    |   38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 3ad565f..611d24d 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1675,6 +1675,7 @@ static long rc_do_ioctl(struct rc_dev *dev, unsigned int cmd, unsigned long arg)
 	void __user *p = (void __user *)arg;
 	unsigned int __user *ip = (unsigned int __user *)p;
 	struct rc_ir_rx rx;
+	struct rc_ir_tx tx;
 	int error;
 
 	switch (cmd) {
@@ -1712,6 +1713,17 @@ static long rc_do_ioctl(struct rc_dev *dev, unsigned int cmd, unsigned long arg)
 			return -EFAULT;
 
 		return 0;
+
+	case RCIOCGIRTX:
+		memset(&tx, 0, sizeof(tx));
+
+		if (dev->get_ir_tx)
+			dev->get_ir_tx(dev, &tx);
+
+		if (copy_to_user(p, &tx, sizeof(tx)))
+			return -EFAULT;
+
+		return 0;
 	}
 
 	return -EINVAL;
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 09bf8b5..566ae7d 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -113,6 +113,42 @@ struct rc_ir_rx {
 	__u32 reserved[9];
 } __packed;
 
+/* get ir tx parameters */
+#define RCIOCGIRTX	_IOC(_IOC_READ, RC_IOC_MAGIC, 0x05, sizeof(struct rc_ir_tx))
+
+/**
+ * struct rc_ir_tx - used to get all IR TX parameters in one go
+ * @flags: device specific flags
+ * @tx_supported: bitmask of supported transmitters
+ * @tx_enabled: bitmask of enabled transmitters
+ * @tx_connected: bitmask of connected transmitters
+ * @freq: current carrier frequency
+ * @freq_min: min carrier frequency
+ * @freq_max: max carrier frequency
+ * @duty: current duty cycle
+ * @duty_min: min duty cycle
+ * @duty_max: max duty cycle
+ * @resolution: current resolution
+ * @resolution_min: min resolution
+ * @resolution_max: max resolution
+ * @reserved: for future use, set to zero
+ */
+struct rc_ir_tx {
+	__u32 flags;
+	__u32 tx_supported;
+	__u32 tx_enabled;
+	__u32 tx_connected;
+	__u32 freq;
+	__u32 freq_min;
+	__u32 freq_max;
+	__u32 duty;
+	__u32 duty_min;
+	__u32 duty_max;
+	__u32 resolution;
+	__u32 resolution_min;
+	__u32 resolution_max;
+	__u32 reserved[9];
+} __packed;
 
 
 enum rc_driver_type {
@@ -270,6 +306,7 @@ enum rc_filter_type {
  * @s_wakeup_filter: set the wakeup scancode filter
  * @get_ir_rx: allow driver to provide rx settings
  * @set_ir_rx: allow driver to change rx settings
+ * @get_ir_tx: allow driver to provide tx settings
  */
 struct rc_dev {
 	struct device			dev;
@@ -333,6 +370,7 @@ struct rc_dev {
 							   struct rc_scancode_filter *filter);
 	void				(*get_ir_rx)(struct rc_dev *dev, struct rc_ir_rx *rx);
 	int				(*set_ir_rx)(struct rc_dev *dev, struct rc_ir_rx *rx);
+	void				(*get_ir_tx)(struct rc_dev *dev, struct rc_ir_tx *tx);
 };
 
 #define to_rc_dev(d) container_of(d, struct rc_dev, dev)

