Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:57823 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab3GHAXH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Jul 2013 20:23:07 -0400
Received: by mail-ea0-f174.google.com with SMTP id o10so2560627eaj.33
        for <linux-media@vger.kernel.org>; Sun, 07 Jul 2013 17:23:05 -0700 (PDT)
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-media@vger.kernel.org
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 1/3] ene_ir: Fix interrupt line passthrough to hardware
Date: Mon,  8 Jul 2013 03:22:45 +0300
Message-Id: <1373242968-16055-2-git-send-email-maximlevitsky@gmail.com>
In-Reply-To: <1373242968-16055-1-git-send-email-maximlevitsky@gmail.com>
References: <1373242968-16055-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While we can delay IRQ intialization, we need the interrupt number
right away because unusually hardware have programable interrupt number,
and thus we give it the number that was allocated by BIOS

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/media/rc/ene_ir.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index ee6c984..a9cf3a4 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -1022,6 +1022,8 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 	spin_lock_init(&dev->hw_lock);
 
 	dev->hw_io = pnp_port_start(pnp_dev, 0);
+	dev->irq = pnp_irq(pnp_dev, 0);
+
 
 	pnp_set_drvdata(pnp_dev, dev);
 	dev->pnp_dev = pnp_dev;
@@ -1085,7 +1087,6 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 		goto exit_unregister_device;
 	}
 
-	dev->irq = pnp_irq(pnp_dev, 0);
 	if (request_irq(dev->irq, ene_isr,
 			IRQF_SHARED, ENE_DRIVER_NAME, (void *)dev)) {
 		goto exit_release_hw_io;
-- 
1.7.9.5

