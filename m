Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:44275 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933046Ab2EWJyv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 05:54:51 -0400
Subject: [PATCH 21/43] rc-loopback: add RCIOCGIRTX ioctl support
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: mchehab@redhat.com, jarod@redhat.com
Date: Wed, 23 May 2012 11:43:50 +0200
Message-ID: <20120523094350.14474.271.stgit@felix.hardeman.nu>
In-Reply-To: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
References: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
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
index 6d0e9fb..a04b39b 100644
--- a/drivers/media/rc/rc-loopback.c
+++ b/drivers/media/rc/rc-loopback.c
@@ -196,6 +196,31 @@ static int loop_set_ir_rx(struct rc_dev *dev, struct rc_ir_rx *rx)
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
@@ -228,6 +253,7 @@ static int __init loop_init(void)
 	rc->s_idle		= loop_set_idle;
 	rc->get_ir_rx		= loop_get_ir_rx;
 	rc->set_ir_rx		= loop_set_ir_rx;
+	rc->get_ir_tx		= loop_get_ir_tx;
 
 	loopdev.txmask		= RXMASK_REGULAR;
 	loopdev.txcarrier	= 36000;

