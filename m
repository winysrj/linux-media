Return-path: <linux-media-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:24099 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755947AbbDJGkq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Apr 2015 02:40:46 -0400
From: Brendan McGrath <redmcg@redmandi.dyndns.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Linux-Media <linux-media@vger.kernel.org>,
	Linux-Kernal <linux-kernel@vger.kernel.org>
Cc: Brendan McGrath <redmcg@redmandi.dyndns.org>
Subject: [PATCHv5] [media] saa7164: use an MSI interrupt when available
Date: Fri, 10 Apr 2015 16:39:22 +1000
Message-Id: <1428647962-9553-1-git-send-email-redmcg@redmandi.dyndns.org>
In-Reply-To: <20150408174312.317c7823@recife.lan>
References: <20150408174312.317c7823@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enhances driver to use an MSI interrupt when available.

Adds the module option 'enable_msi' (type bool) which by default is
enabled. Can be set to 'N' to disable.

Fixes (or can reduce the occurrence of) a crash which is most commonly
reported when both digital tuners of the saa7164 chip is in use. A
reported example can be found here:
http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/83948

Reviewed-by: Steven Toth <stoth@kernellabs.com>
Signed-off-by: Brendan McGrath <redmcg@redmandi.dyndns.org>
---
Changes since v4:
  - improved readability by taking on suggestions made by Mauro
  - the msi variable in the saa7164_dev structure is now a bool

Thanks Mauro - good suggestions and I think I've taken on board all of them.

 drivers/media/pci/saa7164/saa7164-core.c | 66 ++++++++++++++++++++++++++++----
 drivers/media/pci/saa7164/saa7164.h      |  1 +
 2 files changed, 60 insertions(+), 7 deletions(-)

diff --git a/drivers/media/pci/saa7164/saa7164-core.c b/drivers/media/pci/saa7164/saa7164-core.c
index 9cf3c6c..5e4a9f0 100644
--- a/drivers/media/pci/saa7164/saa7164-core.c
+++ b/drivers/media/pci/saa7164/saa7164-core.c
@@ -85,6 +85,11 @@ module_param(guard_checking, int, 0644);
 MODULE_PARM_DESC(guard_checking,
 	"enable dma sanity checking for buffer overruns");
 
+static bool enable_msi = true;
+module_param(enable_msi, bool, 0444);
+MODULE_PARM_DESC(enable_msi,
+		"enable the use of an msi interrupt if available");
+
 static unsigned int saa7164_devcount;
 
 static DEFINE_MUTEX(devlist);
@@ -1184,6 +1189,39 @@ static int saa7164_thread_function(void *data)
 	return 0;
 }
 
+static bool saa7164_enable_msi(struct pci_dev *pci_dev, struct saa7164_dev *dev)
+{
+	int err;
+
+	if (!enable_msi) {
+		printk(KERN_WARNING "%s() MSI disabled by module parameter 'enable_msi'"
+		       , __func__);
+		return false;
+	}
+
+	err = pci_enable_msi(pci_dev);
+
+	if (err) {
+		printk(KERN_ERR "%s() Failed to enable MSI interrupt."
+			" Falling back to a shared IRQ\n", __func__);
+		return false;
+	}
+
+	/* no error - so request an msi interrupt */
+	err = request_irq(pci_dev->irq, saa7164_irq, 0,
+						dev->name, dev);
+
+	if (err) {
+		/* fall back to legacy interrupt */
+		printk(KERN_ERR "%s() Failed to get an MSI interrupt."
+		       " Falling back to a shared IRQ\n", __func__);
+		pci_disable_msi(pci_dev);
+		return false;
+	}
+
+	return true;
+}
+
 static int saa7164_initdev(struct pci_dev *pci_dev,
 			   const struct pci_device_id *pci_id)
 {
@@ -1230,13 +1268,22 @@ static int saa7164_initdev(struct pci_dev *pci_dev,
 		goto fail_irq;
 	}
 
-	err = request_irq(pci_dev->irq, saa7164_irq,
-		IRQF_SHARED, dev->name, dev);
-	if (err < 0) {
-		printk(KERN_ERR "%s: can't get IRQ %d\n", dev->name,
-			pci_dev->irq);
-		err = -EIO;
-		goto fail_irq;
+	/* irq bit */
+	if (saa7164_enable_msi(pci_dev, dev)) {
+		dev->msi = true;
+	} else {
+		/* if we have an error (i.e. we don't have an interrupt)
+			 or msi is not enabled - fallback to shared interrupt */
+
+		err = request_irq(pci_dev->irq, saa7164_irq,
+				IRQF_SHARED, dev->name, dev);
+
+		if (err < 0) {
+			printk(KERN_ERR "%s: can't get IRQ %d\n", dev->name,
+			       pci_dev->irq);
+			err = -EIO;
+			goto fail_irq;
+		}
 	}
 
 	pci_set_drvdata(pci_dev, dev);
@@ -1439,6 +1486,11 @@ static void saa7164_finidev(struct pci_dev *pci_dev)
 	/* unregister stuff */
 	free_irq(pci_dev->irq, dev);
 
+	if (dev->msi) {
+		pci_disable_msi(pci_dev);
+		dev->msi = false;
+	}
+
 	pci_disable_device(pci_dev);
 
 	mutex_lock(&devlist);
diff --git a/drivers/media/pci/saa7164/saa7164.h b/drivers/media/pci/saa7164/saa7164.h
index cd1a07c..75a3f51 100644
--- a/drivers/media/pci/saa7164/saa7164.h
+++ b/drivers/media/pci/saa7164/saa7164.h
@@ -459,6 +459,7 @@ struct saa7164_dev {
 	/* Interrupt status and ack registers */
 	u32 int_status;
 	u32 int_ack;
+	bool msi;
 
 	struct cmd			cmds[SAA_CMD_MAX_MSG_UNITS];
 	struct mutex			lock;
-- 
1.9.1

