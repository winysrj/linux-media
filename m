Return-path: <linux-media-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:45418 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750849AbbCND2D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2015 23:28:03 -0400
From: Brendan McGrath <redmcg@redmandi.dyndns.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Linux-Media <linux-media@vger.kernel.org>,
	Linux-Kernal <linux-kernel@vger.kernel.org>
Cc: Brendan McGrath <redmcg@redmandi.dyndns.org>
Subject: [PATCHv4] [media] saa7164: use an MSI interrupt when available
Date: Sat, 14 Mar 2015 14:27:39 +1100
Message-Id: <1426303659-4937-1-git-send-email-redmcg@redmandi.dyndns.org>
In-Reply-To: <1425168893-5251-1-git-send-email-redmcg@redmandi.dyndns.org>
References: <1425168893-5251-1-git-send-email-redmcg@redmandi.dyndns.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enhances driver to use an MSI interrupt when available.

Adds the module option 'enable_msi' (type bool) which by default is
enabled. Can be set to 'N' to disable.

Fixes (or can reduce the occurrence of) a crash which is most commonly
reported when both digital tuners of the saa7164 chip is in use. A reported example can
be found here:
http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/83948

Reviewed-by: Steven Toth <stoth@kernellabs.com>
Signed-off-by: Brendan McGrath <redmcg@redmandi.dyndns.org>
---
Changes since v3:
  - fixes a conflict with a commit (3f845f3c4cf4) made to the media_tree after v3 was created (only the unified context has been changed)
  - corrected comments to reflect that the reported incident occured more commonly when multiple tuners were in use (not multiple saa7164 chips as previously stated)


 drivers/media/pci/saa7164/saa7164-core.c | 40 ++++++++++++++++++++++++++++++--
 drivers/media/pci/saa7164/saa7164.h      |  1 +
 2 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/saa7164/saa7164-core.c b/drivers/media/pci/saa7164/saa7164-core.c
index 9cf3c6c..7635598 100644
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
@@ -1230,8 +1235,34 @@ static int saa7164_initdev(struct pci_dev *pci_dev,
 		goto fail_irq;
 	}
 
-	err = request_irq(pci_dev->irq, saa7164_irq,
-		IRQF_SHARED, dev->name, dev);
+	/* irq bit */
+	if (enable_msi)
+		err = pci_enable_msi(pci_dev);
+
+	if (!err && enable_msi) {
+		/* no error - so request an msi interrupt */
+		err = request_irq(pci_dev->irq, saa7164_irq, 0,
+				  dev->name, dev);
+
+		if (err) {
+			/* fall back to legacy interrupt */
+			printk(KERN_ERR "%s() Failed to get an MSI interrupt."
+			       " Falling back to a shared IRQ\n", __func__);
+			pci_disable_msi(pci_dev);
+		} else {
+			dev->msi = true;
+		}
+	}
+
+	if ((!enable_msi) || err) {
+		dev->msi = false;
+		/* if we have an error (i.e. we don't have an interrupt)
+			 or msi is not enabled - fallback to shared interrupt */
+
+		err = request_irq(pci_dev->irq, saa7164_irq,
+				  IRQF_SHARED, dev->name, dev);
+	}
+
 	if (err < 0) {
 		printk(KERN_ERR "%s: can't get IRQ %d\n", dev->name,
 			pci_dev->irq);
@@ -1439,6 +1470,11 @@ static void saa7164_finidev(struct pci_dev *pci_dev)
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
index cd1a07c..6df4b252 100644
--- a/drivers/media/pci/saa7164/saa7164.h
+++ b/drivers/media/pci/saa7164/saa7164.h
@@ -459,6 +459,7 @@ struct saa7164_dev {
 	/* Interrupt status and ack registers */
 	u32 int_status;
 	u32 int_ack;
+	u32 msi;
 
 	struct cmd			cmds[SAA_CMD_MAX_MSG_UNITS];
 	struct mutex			lock;
-- 
1.9.1

