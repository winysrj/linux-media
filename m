Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:40317 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754019AbaDCXdd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Apr 2014 19:33:33 -0400
Subject: [PATCH 27/49] rc-loopback: add RCIOCGIRTX ioctl support
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Date: Fri, 04 Apr 2014 01:33:32 +0200
Message-ID: <20140403233332.27099.49957.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
References: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As an example, this patch adds support for the new RCIOCGIRRX ioctl
to rc-loopback.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/rc-loopback.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/media/rc/rc-loopback.c b/drivers/media/rc/rc-loopback.c
index 2ae1b5a..ba36fbe 100644
--- a/drivers/media/rc/rc-loopback.c
+++ b/drivers/media/rc/rc-loopback.c
@@ -204,6 +204,31 @@ static int loop_set_ir_rx(struct rc_dev *dev, struct rc_ir_rx *rx)
 	return 0;
 }
 
+/**
+ * loop_get_ir_tx() - returns the current TX settings
+ * @dev: the &struct rc_dev to get the settings for
+ * @tx: the &struct rc_ir_tx to fill in with the current settings
+ *
+ * This function is used to return the current TX settings.
+ */
+static void loop_get_ir_tx(struct rc_dev *dev, struct rc_ir_tx *tx)
+{
+	struct loopback_dev *lodev = dev->priv;
+
+	tx->tx_supported = RXMASK_REGULAR | RXMASK_LEARNING;
+	tx->tx_connected = RXMASK_REGULAR | RXMASK_LEARNING;
+	tx->tx_enabled = lodev->txmask;
+	tx->freq = lodev->txcarrier;
+	tx->freq_min = 1;
+	tx->freq_max = UINT_MAX;
+	tx->duty = lodev->txduty;
+	tx->duty_min = 1;
+	tx->duty_max = 99;
+	tx->resolution = 1;
+	tx->resolution_min = 1;
+	tx->resolution_max = 1;
+}
+
 static int __init loop_init(void)
 {
 	struct rc_dev *rc;
@@ -236,6 +261,7 @@ static int __init loop_init(void)
 	rc->s_idle		= loop_set_idle;
 	rc->get_ir_rx		= loop_get_ir_rx;
 	rc->set_ir_rx		= loop_set_ir_rx;
+	rc->get_ir_tx		= loop_get_ir_tx;
 
 	loopdev.txmask		= RXMASK_REGULAR;
 	loopdev.txcarrier	= 36000;

