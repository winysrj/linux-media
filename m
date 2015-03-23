Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:33896 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbbCWQ0y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Mar 2015 12:26:54 -0400
From: Silvan Jegen <s.jegen@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Cc: Silvan Jegen <s.jegen@gmail.com>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH V3] [media] mantis: fix error handling
Date: Mon, 23 Mar 2015 17:25:53 +0100
Message-Id: <1427127953-24716-1-git-send-email-s.jegen@gmail.com>
In-Reply-To: <20150322224831.GF16501@mwanda>
References: <20150322224831.GF16501@mwanda>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove dead code, make goto label names more expressive and add a label
in order to call mantis_dvb_exit if mantis_uart_init fails.

Also make sure that mantis_pci_exit is called if we fail the
mantis_stream_control call and that we call mantis_i2c_exit if
mantis_get_mac fails.

Signed-off-by: Silvan Jegen <s.jegen@gmail.com>
---
V3 Changes (due to Dan Carpenter's and Walter Harms' reviews):
	- return -ENOMEM/0 directly
  - remove dprintk calls in the error handling part

V2 Changes (due to Dan Carpenter's review):
	- Remove dead code, do not activate it
	- Make goto labels more expressive
	- Add a call to mantis_dvb_exit

 drivers/media/pci/mantis/mantis_cards.c | 39 ++++++++++++++-------------------
 1 file changed, 16 insertions(+), 23 deletions(-)

diff --git a/drivers/media/pci/mantis/mantis_cards.c b/drivers/media/pci/mantis/mantis_cards.c
index 801fc55..9861a8c 100644
--- a/drivers/media/pci/mantis/mantis_cards.c
+++ b/drivers/media/pci/mantis/mantis_cards.c
@@ -169,8 +169,7 @@ static int mantis_pci_probe(struct pci_dev *pdev,
 	mantis = kzalloc(sizeof(struct mantis_pci), GFP_KERNEL);
 	if (mantis == NULL) {
 		printk(KERN_ERR "%s ERROR: Out of memory\n", __func__);
-		err = -ENOMEM;
-		goto fail0;
+		return -ENOMEM;
 	}
 
 	mantis->num		= devs;
@@ -183,70 +182,64 @@ static int mantis_pci_probe(struct pci_dev *pdev,
 	err = mantis_pci_init(mantis);
 	if (err) {
 		dprintk(MANTIS_ERROR, 1, "ERROR: Mantis PCI initialization failed <%d>", err);
-		goto fail1;
+		goto err_free_mantis;
 	}
 
 	err = mantis_stream_control(mantis, STREAM_TO_HIF);
 	if (err < 0) {
 		dprintk(MANTIS_ERROR, 1, "ERROR: Mantis stream control failed <%d>", err);
-		goto fail1;
+		goto err_pci_exit;
 	}
 
 	err = mantis_i2c_init(mantis);
 	if (err < 0) {
 		dprintk(MANTIS_ERROR, 1, "ERROR: Mantis I2C initialization failed <%d>", err);
-		goto fail2;
+		goto err_pci_exit;
 	}
 
 	err = mantis_get_mac(mantis);
 	if (err < 0) {
 		dprintk(MANTIS_ERROR, 1, "ERROR: Mantis MAC address read failed <%d>", err);
-		goto fail2;
+		goto err_i2c_exit;
 	}
 
 	err = mantis_dma_init(mantis);
 	if (err < 0) {
 		dprintk(MANTIS_ERROR, 1, "ERROR: Mantis DMA initialization failed <%d>", err);
-		goto fail3;
+		goto err_i2c_exit;
 	}
 
 	err = mantis_dvb_init(mantis);
 	if (err < 0) {
 		dprintk(MANTIS_ERROR, 1, "ERROR: Mantis DVB initialization failed <%d>", err);
-		goto fail4;
+		goto err_dma_exit;
 	}
+
 	err = mantis_uart_init(mantis);
 	if (err < 0) {
 		dprintk(MANTIS_ERROR, 1, "ERROR: Mantis UART initialization failed <%d>", err);
-		goto fail6;
+		goto err_dvb_exit;
 	}
 
 	devs++;
 
-	return err;
-
+	return 0;
 
-	dprintk(MANTIS_ERROR, 1, "ERROR: Mantis UART exit! <%d>", err);
-	mantis_uart_exit(mantis);
+err_dvb_exit:
+	mantis_dvb_exit(mantis);
 
-fail6:
-fail4:
-	dprintk(MANTIS_ERROR, 1, "ERROR: Mantis DMA exit! <%d>", err);
+err_dma_exit:
 	mantis_dma_exit(mantis);
 
-fail3:
-	dprintk(MANTIS_ERROR, 1, "ERROR: Mantis I2C exit! <%d>", err);
+err_i2c_exit:
 	mantis_i2c_exit(mantis);
 
-fail2:
-	dprintk(MANTIS_ERROR, 1, "ERROR: Mantis PCI exit! <%d>", err);
+err_pci_exit:
 	mantis_pci_exit(mantis);
 
-fail1:
-	dprintk(MANTIS_ERROR, 1, "ERROR: Mantis free! <%d>", err);
+err_free_mantis:
 	kfree(mantis);
 
-fail0:
 	return err;
 }
 
-- 
2.3.3

