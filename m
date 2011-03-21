Return-path: <mchehab@pedra>
Received: from canardo.mork.no ([148.122.252.1]:55935 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753469Ab1CUOwX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2011 10:52:23 -0400
From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
	Auke Kok <auke-jan.h.kok@intel.com>
Subject: [PATCH] [media] use pci_dev->revision
Date: Mon, 21 Mar 2011 15:35:56 +0100
Message-Id: <1300718156-25395-1-git-send-email-bjorn@mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

pci_setup_device() has saved the PCI revision in the pci_dev
struct since Linux 2.6.23.  Use it.

Cc: Auke Kok <auke-jan.h.kok@intel.com>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
---
I assume some of these drivers could have the revision
removed from their driver specific structures as well, but 
I haven't done that to avoid unnecessary ABI changes.

 drivers/media/common/saa7146_core.c        |    7 +------
 drivers/media/dvb/b2c2/flexcop-pci.c       |    4 +---
 drivers/media/dvb/bt8xx/bt878.c            |    2 +-
 drivers/media/dvb/mantis/mantis_pci.c      |    5 ++---
 drivers/media/video/bt8xx/bttv-driver.c    |    2 +-
 drivers/media/video/cx18/cx18-driver.c     |    2 +-
 drivers/media/video/cx23885/cx23885-core.c |    2 +-
 drivers/media/video/cx88/cx88-mpeg.c       |    2 +-
 drivers/media/video/cx88/cx88-video.c      |    2 +-
 drivers/media/video/ivtv/ivtv-driver.c     |    4 +---
 drivers/media/video/saa7134/saa7134-core.c |    2 +-
 drivers/media/video/saa7164/saa7164-core.c |    2 +-
 drivers/media/video/zoran/zoran_card.c     |    2 +-
 13 files changed, 14 insertions(+), 24 deletions(-)

diff --git a/drivers/media/common/saa7146_core.c b/drivers/media/common/saa7146_core.c
index 9f47e38..9af2140 100644
--- a/drivers/media/common/saa7146_core.c
+++ b/drivers/media/common/saa7146_core.c
@@ -378,12 +378,7 @@ static int saa7146_init_one(struct pci_dev *pci, const struct pci_device_id *ent
 	dev->pci = pci;
 
 	/* get chip-revision; this is needed to enable bug-fixes */
-	err = pci_read_config_dword(pci, PCI_CLASS_REVISION, &dev->revision);
-	if (err < 0) {
-		ERR(("pci_read_config_dword() failed.\n"));
-		goto err_disable;
-	}
-	dev->revision &= 0xf;
+	dev->revision = pci->revision;
 
 	/* remap the memory from virtual to physical address */
 
diff --git a/drivers/media/dvb/b2c2/flexcop-pci.c b/drivers/media/dvb/b2c2/flexcop-pci.c
index 227c020..326d2e8 100644
--- a/drivers/media/dvb/b2c2/flexcop-pci.c
+++ b/drivers/media/dvb/b2c2/flexcop-pci.c
@@ -290,10 +290,8 @@ static void flexcop_pci_dma_exit(struct flexcop_pci *fc_pci)
 static int flexcop_pci_init(struct flexcop_pci *fc_pci)
 {
 	int ret;
-	u8 card_rev;
 
-	pci_read_config_byte(fc_pci->pdev, PCI_CLASS_REVISION, &card_rev);
-	info("card revision %x", card_rev);
+	info("card revision %x", fc_pci->pdev->revision);
 
 	if ((ret = pci_enable_device(fc_pci->pdev)) != 0)
 		return ret;
diff --git a/drivers/media/dvb/bt8xx/bt878.c b/drivers/media/dvb/bt8xx/bt878.c
index 99d6209..b34fa95 100644
--- a/drivers/media/dvb/bt8xx/bt878.c
+++ b/drivers/media/dvb/bt8xx/bt878.c
@@ -460,7 +460,7 @@ static int __devinit bt878_probe(struct pci_dev *dev,
 		goto fail0;
 	}
 
-	pci_read_config_byte(dev, PCI_CLASS_REVISION, &bt->revision);
+	bt->revision = dev->revision;
 	pci_read_config_byte(dev, PCI_LATENCY_TIMER, &lat);
 
 
diff --git a/drivers/media/dvb/mantis/mantis_pci.c b/drivers/media/dvb/mantis/mantis_pci.c
index 10a432a..371558a 100644
--- a/drivers/media/dvb/mantis/mantis_pci.c
+++ b/drivers/media/dvb/mantis/mantis_pci.c
@@ -48,7 +48,7 @@
 
 int __devinit mantis_pci_init(struct mantis_pci *mantis)
 {
-	u8 revision, latency;
+	u8 latency;
 	struct mantis_hwconfig *config	= mantis->hwconfig;
 	struct pci_dev *pdev		= mantis->pdev;
 	int err, ret = 0;
@@ -95,9 +95,8 @@ int __devinit mantis_pci_init(struct mantis_pci *mantis)
 	}
 
 	pci_read_config_byte(pdev, PCI_LATENCY_TIMER, &latency);
-	pci_read_config_byte(pdev, PCI_CLASS_REVISION, &revision);
 	mantis->latency = latency;
-	mantis->revision = revision;
+	mantis->revision = pdev->revision;
 
 	dprintk(MANTIS_ERROR, 0, "    Mantis Rev %d [%04x:%04x], ",
 		mantis->revision,
diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
index 91399c9..a97cf27 100644
--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -4303,7 +4303,7 @@ static int __devinit bttv_probe(struct pci_dev *dev,
 		goto fail0;
 	}
 
-	pci_read_config_byte(dev, PCI_CLASS_REVISION, &btv->revision);
+	btv->revision = dev->revision;
 	pci_read_config_byte(dev, PCI_LATENCY_TIMER, &lat);
 	printk(KERN_INFO "bttv%d: Bt%d (rev %d) at %s, ",
 	       bttv_num,btv->id, btv->revision, pci_name(dev));
diff --git a/drivers/media/video/cx18/cx18-driver.c b/drivers/media/video/cx18/cx18-driver.c
index b1c3cbd..9d7f8f2 100644
--- a/drivers/media/video/cx18/cx18-driver.c
+++ b/drivers/media/video/cx18/cx18-driver.c
@@ -810,7 +810,7 @@ static int cx18_setup_pci(struct cx18 *cx, struct pci_dev *pci_dev,
 	cmd |= PCI_COMMAND_MEMORY | PCI_COMMAND_MASTER;
 	pci_write_config_word(pci_dev, PCI_COMMAND, cmd);
 
-	pci_read_config_byte(pci_dev, PCI_CLASS_REVISION, &cx->card_rev);
+	cx->card_rev = pci_dev->revision;
 	pci_read_config_byte(pci_dev, PCI_LATENCY_TIMER, &pci_latency);
 
 	if (pci_latency < 64 && cx18_pci_latency) {
diff --git a/drivers/media/video/cx23885/cx23885-core.c b/drivers/media/video/cx23885/cx23885-core.c
index 3598824..3f3ddba 100644
--- a/drivers/media/video/cx23885/cx23885-core.c
+++ b/drivers/media/video/cx23885/cx23885-core.c
@@ -2035,7 +2035,7 @@ static int __devinit cx23885_initdev(struct pci_dev *pci_dev,
 	}
 
 	/* print pci info */
-	pci_read_config_byte(pci_dev, PCI_CLASS_REVISION, &dev->pci_rev);
+	dev->pci_rev = pci_dev->revision;
 	pci_read_config_byte(pci_dev, PCI_LATENCY_TIMER,  &dev->pci_lat);
 	printk(KERN_INFO "%s/0: found at %s, rev: %d, irq: %d, "
 	       "latency: %d, mmio: 0x%llx\n", dev->name,
diff --git a/drivers/media/video/cx88/cx88-mpeg.c b/drivers/media/video/cx88/cx88-mpeg.c
index addf954..9b500e6 100644
--- a/drivers/media/video/cx88/cx88-mpeg.c
+++ b/drivers/media/video/cx88/cx88-mpeg.c
@@ -474,7 +474,7 @@ static int cx8802_init_common(struct cx8802_dev *dev)
 		return -EIO;
 	}
 
-	pci_read_config_byte(dev->pci, PCI_CLASS_REVISION, &dev->pci_rev);
+	dev->pci_rev = dev->pci->revision;
 	pci_read_config_byte(dev->pci, PCI_LATENCY_TIMER,  &dev->pci_lat);
 	printk(KERN_INFO "%s/2: found at %s, rev: %d, irq: %d, "
 	       "latency: %d, mmio: 0x%llx\n", dev->core->name,
diff --git a/drivers/media/video/cx88/cx88-video.c b/drivers/media/video/cx88/cx88-video.c
index 508dabb..69c0f37 100644
--- a/drivers/media/video/cx88/cx88-video.c
+++ b/drivers/media/video/cx88/cx88-video.c
@@ -1803,7 +1803,7 @@ static int __devinit cx8800_initdev(struct pci_dev *pci_dev,
 	dev->core = core;
 
 	/* print pci info */
-	pci_read_config_byte(pci_dev, PCI_CLASS_REVISION, &dev->pci_rev);
+	dev->pci_rev = pci_dev->revision;
 	pci_read_config_byte(pci_dev, PCI_LATENCY_TIMER,  &dev->pci_lat);
 	printk(KERN_INFO "%s/0: found at %s, rev: %d, irq: %d, "
 	       "latency: %d, mmio: 0x%llx\n", core->name,
diff --git a/drivers/media/video/ivtv/ivtv-driver.c b/drivers/media/video/ivtv/ivtv-driver.c
index 3994642..a4e4dfd 100644
--- a/drivers/media/video/ivtv/ivtv-driver.c
+++ b/drivers/media/video/ivtv/ivtv-driver.c
@@ -810,7 +810,6 @@ static int ivtv_setup_pci(struct ivtv *itv, struct pci_dev *pdev,
 			  const struct pci_device_id *pci_id)
 {
 	u16 cmd;
-	u8 card_rev;
 	unsigned char pci_latency;
 
 	IVTV_DEBUG_INFO("Enabling pci device\n");
@@ -857,7 +856,6 @@ static int ivtv_setup_pci(struct ivtv *itv, struct pci_dev *pdev,
 	}
 	IVTV_DEBUG_INFO("Bus Mastering Enabled.\n");
 
-	pci_read_config_byte(pdev, PCI_CLASS_REVISION, &card_rev);
 	pci_read_config_byte(pdev, PCI_LATENCY_TIMER, &pci_latency);
 
 	if (pci_latency < 64 && ivtv_pci_latency) {
@@ -874,7 +872,7 @@ static int ivtv_setup_pci(struct ivtv *itv, struct pci_dev *pdev,
 
 	IVTV_DEBUG_INFO("%d (rev %d) at %02x:%02x.%x, "
 		   "irq: %d, latency: %d, memory: 0x%lx\n",
-		   pdev->device, card_rev, pdev->bus->number,
+		   pdev->device, pdev->revision, pdev->bus->number,
 		   PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn),
 		   pdev->irq, pci_latency, (unsigned long)itv->base_addr);
 
diff --git a/drivers/media/video/saa7134/saa7134-core.c b/drivers/media/video/saa7134/saa7134-core.c
index 6abeecf..8f4f2ef 100644
--- a/drivers/media/video/saa7134/saa7134-core.c
+++ b/drivers/media/video/saa7134/saa7134-core.c
@@ -918,7 +918,7 @@ static int __devinit saa7134_initdev(struct pci_dev *pci_dev,
 	}
 
 	/* print pci info */
-	pci_read_config_byte(pci_dev, PCI_CLASS_REVISION, &dev->pci_rev);
+	dev->pci_rev = pci_dev->revision;
 	pci_read_config_byte(pci_dev, PCI_LATENCY_TIMER,  &dev->pci_lat);
 	printk(KERN_INFO "%s: found at %s, rev: %d, irq: %d, "
 	       "latency: %d, mmio: 0x%llx\n", dev->name,
diff --git a/drivers/media/video/saa7164/saa7164-core.c b/drivers/media/video/saa7164/saa7164-core.c
index 58af67f..360547a 100644
--- a/drivers/media/video/saa7164/saa7164-core.c
+++ b/drivers/media/video/saa7164/saa7164-core.c
@@ -1247,7 +1247,7 @@ static int __devinit saa7164_initdev(struct pci_dev *pci_dev,
 	}
 
 	/* print pci info */
-	pci_read_config_byte(pci_dev, PCI_CLASS_REVISION, &dev->pci_rev);
+	dev->pci_rev = pci_dev->revision;
 	pci_read_config_byte(pci_dev, PCI_LATENCY_TIMER,  &dev->pci_lat);
 	printk(KERN_INFO "%s/0: found at %s, rev: %d, irq: %d, "
 	       "latency: %d, mmio: 0x%llx\n", dev->name,
diff --git a/drivers/media/video/zoran/zoran_card.c b/drivers/media/video/zoran/zoran_card.c
index 9f2bac5..ba6878b 100644
--- a/drivers/media/video/zoran/zoran_card.c
+++ b/drivers/media/video/zoran/zoran_card.c
@@ -1230,7 +1230,7 @@ static int __devinit zoran_probe(struct pci_dev *pdev,
 	mutex_init(&zr->other_lock);
 	if (pci_enable_device(pdev))
 		goto zr_unreg;
-	pci_read_config_byte(zr->pci_dev, PCI_CLASS_REVISION, &zr->revision);
+	zr->revision = zr->pci_dev->revision;
 
 	dprintk(1,
 		KERN_INFO
-- 
1.7.2.5

