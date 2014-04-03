Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:40321 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753899AbaDCXdo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Apr 2014 19:33:44 -0400
Subject: [PATCH 29/49] rc-loopback: add RCIOCSIRTX ioctl support
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Date: Fri, 04 Apr 2014 01:33:42 +0200
Message-ID: <20140403233342.27099.31020.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
References: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As an example, this patch adds support for the new RCIOCSIRTX ioctl
to rc-loopback and removes deprecated functions without a loss in
functionality (as LIRC will automatically use the new functions).

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/rc-loopback.c |   59 +++++++++++++---------------------------
 1 file changed, 19 insertions(+), 40 deletions(-)

diff --git a/drivers/media/rc/rc-loopback.c b/drivers/media/rc/rc-loopback.c
index ba36fbe..628e834 100644
--- a/drivers/media/rc/rc-loopback.c
+++ b/drivers/media/rc/rc-loopback.c
@@ -49,43 +49,6 @@ struct loopback_dev {
 
 static struct loopback_dev loopdev;
 
-static int loop_set_tx_mask(struct rc_dev *dev, u32 mask)
-{
-	struct loopback_dev *lodev = dev->priv;
-
-	if ((mask & (RXMASK_REGULAR | RXMASK_LEARNING)) != mask) {
-		dprintk("invalid tx mask: %u\n", mask);
-		return -EINVAL;
-	}
-
-	dprintk("setting tx mask: %u\n", mask);
-	lodev->txmask = mask;
-	return 0;
-}
-
-static int loop_set_tx_carrier(struct rc_dev *dev, u32 carrier)
-{
-	struct loopback_dev *lodev = dev->priv;
-
-	dprintk("setting tx carrier: %u\n", carrier);
-	lodev->txcarrier = carrier;
-	return 0;
-}
-
-static int loop_set_tx_duty_cycle(struct rc_dev *dev, u32 duty_cycle)
-{
-	struct loopback_dev *lodev = dev->priv;
-
-	if (duty_cycle < 1 || duty_cycle > 99) {
-		dprintk("invalid duty cycle: %u\n", duty_cycle);
-		return -EINVAL;
-	}
-
-	dprintk("setting duty cycle: %u\n", duty_cycle);
-	lodev->txduty = duty_cycle;
-	return 0;
-}
-
 static int loop_tx_ir(struct rc_dev *dev, unsigned count)
 {
 	struct loopback_dev *lodev = dev->priv;
@@ -229,6 +192,24 @@ static void loop_get_ir_tx(struct rc_dev *dev, struct rc_ir_tx *tx)
 	tx->resolution_max = 1;
 }
 
+/**
+ * loop_set_ir_tx() - changes and returns the current TX settings
+ * @dev: the &struct rc_dev to change the settings for
+ * @tx: the &struct rc_ir_tx with the new settings
+ *
+ * This function is used to change and return the current TX settings.
+ */
+static int loop_set_ir_tx(struct rc_dev *dev, struct rc_ir_tx *tx)
+{
+	struct loopback_dev *lodev = dev->priv;
+
+	lodev->txmask = tx->tx_enabled & (RXMASK_REGULAR | RXMASK_LEARNING);
+	lodev->txcarrier = tx->freq;
+	lodev->txduty = tx->duty;
+
+	return 0;
+}
+
 static int __init loop_init(void)
 {
 	struct rc_dev *rc;
@@ -254,14 +235,12 @@ static int __init loop_init(void)
 	rc->max_timeout		= UINT_MAX;
 	rc->rx_resolution	= 1000;
 	rc->tx_resolution	= 1000;
-	rc->s_tx_mask		= loop_set_tx_mask;
-	rc->s_tx_carrier	= loop_set_tx_carrier;
-	rc->s_tx_duty_cycle	= loop_set_tx_duty_cycle;
 	rc->tx_ir		= loop_tx_ir;
 	rc->s_idle		= loop_set_idle;
 	rc->get_ir_rx		= loop_get_ir_rx;
 	rc->set_ir_rx		= loop_set_ir_rx;
 	rc->get_ir_tx		= loop_get_ir_tx;
+	rc->set_ir_tx		= loop_set_ir_tx;
 
 	loopdev.txmask		= RXMASK_REGULAR;
 	loopdev.txcarrier	= 36000;

