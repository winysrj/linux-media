Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:40313 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803AbaDCXdX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Apr 2014 19:33:23 -0400
Subject: [PATCH 25/49] rc-loopback: add RCIOCSIRRX ioctl support
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Date: Fri, 04 Apr 2014 01:33:22 +0200
Message-ID: <20140403233322.27099.32196.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
References: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As an example, this patch adds support for the new RCIOCSIRRX ioctl
to rc-loopback and removes deprecated functions without a loss in
functionality (as LIRC will automatically use the new functions).

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/rc-loopback.c |   84 ++++++++++++++++++++--------------------
 1 file changed, 42 insertions(+), 42 deletions(-)

diff --git a/drivers/media/rc/rc-loopback.c b/drivers/media/rc/rc-loopback.c
index 565318c..2ae1b5a 100644
--- a/drivers/media/rc/rc-loopback.c
+++ b/drivers/media/rc/rc-loopback.c
@@ -86,21 +86,6 @@ static int loop_set_tx_duty_cycle(struct rc_dev *dev, u32 duty_cycle)
 	return 0;
 }
 
-static int loop_set_rx_carrier_range(struct rc_dev *dev, u32 min, u32 max)
-{
-	struct loopback_dev *lodev = dev->priv;
-
-	if (min < 1 || min > max) {
-		dprintk("invalid rx carrier range %u to %u\n", min, max);
-		return -EINVAL;
-	}
-
-	dprintk("setting rx carrier range %u to %u\n", min, max);
-	lodev->rxcarriermin = min;
-	lodev->rxcarriermax = max;
-	return 0;
-}
-
 static int loop_tx_ir(struct rc_dev *dev, unsigned count)
 {
 	struct loopback_dev *lodev = dev->priv;
@@ -157,30 +142,6 @@ static void loop_set_idle(struct rc_dev *dev, bool enable)
 	}
 }
 
-static int loop_set_learning_mode(struct rc_dev *dev, int enable)
-{
-	struct loopback_dev *lodev = dev->priv;
-
-	if (lodev->learning != enable) {
-		dprintk("%sing learning mode\n", enable ? "enter" : "exit");
-		lodev->learning = !!enable;
-	}
-
-	return 0;
-}
-
-static int loop_set_carrier_report(struct rc_dev *dev, int enable)
-{
-	struct loopback_dev *lodev = dev->priv;
-
-	if (lodev->carrierreport != enable) {
-		dprintk("%sabling carrier reports\n", enable ? "en" : "dis");
-		lodev->carrierreport = !!enable;
-	}
-
-	return 0;
-}
-
 /**
  * loop_get_ir_rx() - returns the current RX settings
  * @dev: the &struct rc_dev to get the settings for
@@ -202,6 +163,47 @@ static void loop_get_ir_rx(struct rc_dev *dev, struct rc_ir_rx *rx)
 	rx->duty_max = 99;
 }
 
+/**
+ * loop_set_ir_rx() - changes and returns the current RX settings
+ * @dev: the &struct rc_dev to change the settings for
+ * @rx: the &struct rc_ir_rx with the new settings
+ *
+ * This function is used to change and return the current RX settings.
+ */
+static int loop_set_ir_rx(struct rc_dev *dev, struct rc_ir_rx *rx)
+{
+	struct loopback_dev *lodev = dev->priv;
+
+	dprintk("%s called\n", __func__);
+	if (lodev->rxcarriermin != rx->freq_min) {
+		dprintk("changing rx carrier min to %u\n", rx->freq_min);
+		lodev->rxcarriermin = rx->freq_min;
+	}
+
+	if (lodev->rxcarriermax != rx->freq_max) {
+		dprintk("changing rx carrier max to %u\n", rx->freq_max);
+		lodev->rxcarriermax = rx->freq_max;
+	}
+
+	if (lodev->carrierreport == !(rx->flags & RC_IR_RX_MEASURE_CARRIER)) {
+		lodev->carrierreport = !!(rx->flags & RC_IR_RX_MEASURE_CARRIER);
+		dprintk("%sabling carrier reports\n",
+			lodev->carrierreport ? "en" : "dis");
+	}
+
+	if ((rx->rx_enabled == RXMASK_LEARNING) && !lodev->learning) {
+		dprintk("enabling learning mode\n");
+		lodev->learning = true;
+	} else if ((rx->rx_enabled == RXMASK_REGULAR) && lodev->learning) {
+		dprintk("disabling learning mode\n");
+		lodev->learning = false;
+	}
+
+	/* Fill in the correct values after the changes */
+	loop_get_ir_rx(dev, rx);
+	return 0;
+}
+
 static int __init loop_init(void)
 {
 	struct rc_dev *rc;
@@ -230,12 +232,10 @@ static int __init loop_init(void)
 	rc->s_tx_mask		= loop_set_tx_mask;
 	rc->s_tx_carrier	= loop_set_tx_carrier;
 	rc->s_tx_duty_cycle	= loop_set_tx_duty_cycle;
-	rc->s_rx_carrier_range	= loop_set_rx_carrier_range;
 	rc->tx_ir		= loop_tx_ir;
 	rc->s_idle		= loop_set_idle;
-	rc->s_learning_mode	= loop_set_learning_mode;
-	rc->s_carrier_report	= loop_set_carrier_report;
 	rc->get_ir_rx		= loop_get_ir_rx;
+	rc->set_ir_rx		= loop_set_ir_rx;
 
 	loopdev.txmask		= RXMASK_REGULAR;
 	loopdev.txcarrier	= 36000;

