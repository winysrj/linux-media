Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:44288 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933320Ab2EWJy4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 05:54:56 -0400
Subject: [PATCH 17/43] rc-loopback: add RCIOCGIRRX ioctl support
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: mchehab@redhat.com, jarod@redhat.com
Date: Wed, 23 May 2012 11:43:30 +0200
Message-ID: <20120523094329.14474.41418.stgit@felix.hardeman.nu>
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
 drivers/media/rc/rc-loopback.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/media/rc/rc-loopback.c b/drivers/media/rc/rc-loopback.c
index b6a2e58..7977b75 100644
--- a/drivers/media/rc/rc-loopback.c
+++ b/drivers/media/rc/rc-loopback.c
@@ -173,6 +173,27 @@ static int loop_set_carrier_report(struct rc_dev *dev, int enable)
 	return 0;
 }
 
+/**
+ * loop_get_ir_rx() - returns the current RX settings
+ * @dev: the &struct rc_dev to get the settings for
+ * @rx: the &struct rc_ir_rx to fill in with the current settings
+ *
+ * This function is used to return the current RX settings.
+ */
+static void loop_get_ir_rx(struct rc_dev *dev, struct rc_ir_rx *rx)
+{
+	struct loopback_dev *lodev = dev->priv;
+
+	rx->rx_supported = RXMASK_REGULAR | RXMASK_LEARNING;
+	rx->rx_connected = RXMASK_REGULAR | RXMASK_LEARNING;
+	rx->rx_enabled = lodev->learning ? RXMASK_LEARNING : RXMASK_REGULAR;
+	rx->rx_learning = RXMASK_LEARNING;
+	rx->freq_min = lodev->rxcarriermin;
+	rx->freq_max = lodev->rxcarriermax;
+	rx->duty_min = 1;
+	rx->duty_max = 99;
+}
+
 static int __init loop_init(void)
 {
 	struct rc_dev *rc;
@@ -206,6 +227,7 @@ static int __init loop_init(void)
 	rc->s_idle		= loop_set_idle;
 	rc->s_learning_mode	= loop_set_learning_mode;
 	rc->s_carrier_report	= loop_set_carrier_report;
+	rc->get_ir_rx		= loop_get_ir_rx;
 
 	loopdev.txmask		= RXMASK_REGULAR;
 	loopdev.txcarrier	= 36000;

