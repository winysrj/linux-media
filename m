Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:42193 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966065AbcA1JSI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jan 2016 04:18:08 -0500
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: [PATCH 3/12] TW686x: Switch to devm_*()
References: <m337tif6om.fsf@t19.piap.pl>
Date: Thu, 28 Jan 2016 10:18:03 +0100
In-Reply-To: <m337tif6om.fsf@t19.piap.pl> ("Krzysztof \=\?utf-8\?Q\?Ha\=C5\=82as\?\=
 \=\?utf-8\?Q\?a\=22's\?\= message of
	"Thu, 28 Jan 2016 09:29:29 +0100")
Message-ID: <m34mdycbas.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>

diff --git a/drivers/media/pci/tw686x/tw686x-core.c b/drivers/media/pci/tw686x/tw686x-core.c
index f22f485..e2dec02 100644
--- a/drivers/media/pci/tw686x/tw686x-core.c
+++ b/drivers/media/pci/tw686x/tw686x-core.c
@@ -42,8 +42,9 @@ static int tw686x_probe(struct pci_dev *pci_dev,
 	struct tw686x_dev *dev;
 	int err;
 
-	dev = kzalloc(sizeof(*dev) + (pci_id->driver_data & TYPE_MAX_CHANNELS) *
-		      sizeof(dev->video_channels[0]), GFP_KERNEL);
+	dev = devm_kzalloc(&pci_dev->dev,
+			   sizeof(*dev) + (pci_id->driver_data & TYPE_MAX_CHANNELS) *
+			   sizeof(dev->video_channels[0]), GFP_KERNEL);
 	if (!dev)
 		return -ENOMEM;
 
@@ -55,30 +56,26 @@ static int tw686x_probe(struct pci_dev *pci_dev,
 		(unsigned long)pci_resource_start(pci_dev, 0));
 
 	dev->pci_dev = pci_dev;
-	if (pci_enable_device(pci_dev)) {
-		err = -EIO;
-		goto free_dev;
-	}
+	if (pcim_enable_device(pci_dev))
+		return -EIO;
 
 	pci_set_master(pci_dev);
 
 	if (!pci_dma_supported(pci_dev, DMA_BIT_MASK(32))) {
 		pr_err("%s: 32-bit PCI DMA not supported\n", dev->name);
-		err = -EIO;
-		goto disable;
+		return -EIO;
 	}
 
 	err = pci_request_regions(pci_dev, dev->name);
 	if (err < 0) {
 		pr_err("%s: Unable to get MMIO region\n", dev->name);
-		goto disable;
+		return err;
 	}
 
 	dev->mmio = pci_ioremap_bar(pci_dev, 0);
 	if (!dev->mmio) {
 		pr_err("%s: Unable to remap MMIO region\n", dev->name);
-		err = -EIO;
-		goto free_region;
+		return -EIO;
 	}
 
 	reg_write(dev, SYS_SOFT_RST, 0x0F); /* Reset all subsystems */
@@ -95,32 +92,19 @@ static int tw686x_probe(struct pci_dev *pci_dev,
 
 	spin_lock_init(&dev->irq_lock);
 
-	err = request_irq(pci_dev->irq, tw686x_irq, IRQF_SHARED, dev->name,
-			  dev);
+	err = devm_request_irq(&pci_dev->dev, pci_dev->irq, tw686x_irq,
+			       IRQF_SHARED, dev->name, dev);
 	if (err < 0) {
 		pr_err("%s: Unable to get IRQ\n", dev->name);
-		goto iounmap;
+		return err;
 	}
 
 	err = tw686x_video_init(dev);
 	if (err)
-		goto free_irq;
+		return err;
 
 	pci_set_drvdata(pci_dev, dev);
 	return 0;
-
-free_irq:
-	free_irq(pci_dev->irq, dev);
-iounmap:
-	iounmap(dev->mmio);
-free_region:
-	release_mem_region(pci_resource_start(pci_dev, 0),
-			   pci_resource_len(pci_dev, 0));
-disable:
-	pci_disable_device(pci_dev);
-free_dev:
-	kfree(dev);
-	return err;
 }
 
 static void tw686x_remove(struct pci_dev *pci_dev)
@@ -128,13 +112,6 @@ static void tw686x_remove(struct pci_dev *pci_dev)
 	struct tw686x_dev *dev = pci_get_drvdata(pci_dev);
 
 	tw686x_video_free(dev);
-
-	free_irq(pci_dev->irq, dev);
-	iounmap(dev->mmio);
-	release_mem_region(pci_resource_start(pci_dev, 0),
-			   pci_resource_len(pci_dev, 0));
-	pci_disable_device(pci_dev);
-	kfree(dev);
 }
 
 /* driver_data is number of A/V channels */
