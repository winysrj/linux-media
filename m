Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f180.google.com ([209.85.215.180]:55930 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab3GHAXJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Jul 2013 20:23:09 -0400
Received: by mail-ea0-f180.google.com with SMTP id k10so2581676eaj.39
        for <linux-media@vger.kernel.org>; Sun, 07 Jul 2013 17:23:08 -0700 (PDT)
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-media@vger.kernel.org
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 2/3] ene_ir: disable the device if wake is disabled It doesn't hurt and on my notebook despite clearing the wake flag the remote still wakes up the system. This way it doesn't
Date: Mon,  8 Jul 2013 03:22:46 +0300
Message-Id: <1373242968-16055-3-git-send-email-maximlevitsky@gmail.com>
In-Reply-To: <1373242968-16055-1-git-send-email-maximlevitsky@gmail.com>
References: <1373242968-16055-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/media/rc/ene_ir.c |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index a9cf3a4..61865ba 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -476,7 +476,7 @@ select_timeout:
 }
 
 /* Enable the device for receive */
-static void ene_rx_enable(struct ene_device *dev)
+static void ene_rx_enable_hw(struct ene_device *dev)
 {
 	u8 reg_value;
 
@@ -504,11 +504,17 @@ static void ene_rx_enable(struct ene_device *dev)
 
 	/* enter idle mode */
 	ir_raw_event_set_idle(dev->rdev, true);
+}
+
+/* Enable the device for receive - wrapper to track the state*/
+static void ene_rx_enable(struct ene_device *dev)
+{
+	ene_rx_enable_hw(dev);
 	dev->rx_enabled = true;
 }
 
 /* Disable the device receiver */
-static void ene_rx_disable(struct ene_device *dev)
+static void ene_rx_disable_hw(struct ene_device *dev)
 {
 	/* disable inputs */
 	ene_rx_enable_cir_engine(dev, false);
@@ -516,8 +522,13 @@ static void ene_rx_disable(struct ene_device *dev)
 
 	/* disable hardware IRQ and firmware flag */
 	ene_clear_reg_mask(dev, ENE_FW1, ENE_FW1_ENABLE | ENE_FW1_IRQ);
-
 	ir_raw_event_set_idle(dev->rdev, true);
+}
+
+/* Disable the device receiver - wrapper to track the state */
+static void ene_rx_disable(struct ene_device *dev)
+{
+	ene_rx_disable_hw(dev);
 	dev->rx_enabled = false;
 }
 
@@ -1123,9 +1134,8 @@ static void ene_remove(struct pnp_dev *pnp_dev)
 }
 
 /* enable wake on IR (wakes on specific button on original remote) */
-static void ene_enable_wake(struct ene_device *dev, int enable)
+static void ene_enable_wake(struct ene_device *dev, bool enable)
 {
-	enable = enable && device_may_wakeup(&dev->pnp_dev->dev);
 	dbg("wake on IR %s", enable ? "enabled" : "disabled");
 	ene_set_clear_reg_mask(dev, ENE_FW1, ENE_FW1_WAKE, enable);
 }
@@ -1134,9 +1144,12 @@ static void ene_enable_wake(struct ene_device *dev, int enable)
 static int ene_suspend(struct pnp_dev *pnp_dev, pm_message_t state)
 {
 	struct ene_device *dev = pnp_get_drvdata(pnp_dev);
-	ene_enable_wake(dev, true);
+	bool wake = device_may_wakeup(&dev->pnp_dev->dev);
+
+	if (!wake && dev->rx_enabled)
+		ene_rx_disable_hw(dev);
 
-	/* TODO: add support for wake pattern */
+	ene_enable_wake(dev, wake);
 	return 0;
 }
 
-- 
1.7.9.5

