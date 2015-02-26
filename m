Return-path: <linux-media-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:53226 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752953AbbBZDVE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Feb 2015 22:21:04 -0500
Message-ID: <54EE90BF.2030602@redmandi.dyndns.org>
Date: Thu, 26 Feb 2015 14:19:27 +1100
From: Brendan McGrath <redmcg@redmandi.dyndns.org>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
CC: Brendan McGrath <redmcg@redmandi.dyndns.org>
Subject: [PATCH] [media] saa7164: use an MSI interrupt when available
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Brendan McGrath <redmcg@redmandi.dyndns.org>

[media] saa7164: use an MSI interrupt when available

Fixes a known crash which most commonly occurs when multiple saa7164 
chips are in use.

Signed-off-by: Brendan McGrath <redmcg@redmandi.dyndns.org>
---
  drivers/media/pci/saa7164/saa7164-core.c | 34 
++++++++++++++++++++++++++++++--
  drivers/media/pci/saa7164/saa7164.h      |  1 +
  2 files changed, 33 insertions(+), 2 deletions(-)


This patch falls back to the original code - a 'shared' interrupt - when 
MSI is not available (or encounters an error).

Many of today's cards that use the saa7164 chip operate on a PCI-E bus 
(thus MSI should be available). Examples: the Hauppage HVR-2200 and HVR-2250

This enhancement also fixes an issue that was causing the driver to crash:
http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/83948

I believe the root cause of the crash is due to a DMA/IRQ race 
condition. It most commonly occurs when the saa7164 driver is dealing 
with more than one saa7164 chip (the HVR-2200 and HVR-2250 for example 
have two - one for each tuner). Given MSI avoids DMA/IRQ race conditions 
- this would explain why the patch works as a fix.




diff --git a/drivers/media/pci/saa7164/saa7164-core.c 
b/drivers/media/pci/saa7164/saa7164-core.c
index 4b0bec3..083bea4 100644
--- a/drivers/media/pci/saa7164/saa7164-core.c
+++ b/drivers/media/pci/saa7164/saa7164-core.c
@@ -1230,8 +1230,33 @@ static int saa7164_initdev(struct pci_dev *pci_dev,
          goto fail_irq;
      }

-    err = request_irq(pci_dev->irq, saa7164_irq,
-        IRQF_SHARED, dev->name, dev);
+    /* irq bit */
+    err = pci_enable_msi(pci_dev);
+
+    if (!err) {
+        /* no error - so request an msi interrupt */
+        err = request_irq(pci_dev->irq, saa7164_irq, 0,
+                  dev->name, dev);
+
+        if (err) {
+            /* fall back to legacy interrupt */
+            printk(KERN_ERR "%s() Failed to get an MSI interrupt."
+                " Falling back to a shared IRQ\n", __func__);
+            pci_disable_msi(pci_dev);
+        } else {
+            dev->msi = true;
+        }
+    }
+
+    if (err) {
+        dev->msi = false;
+        /* if we have an error (i.e. we don't have an interrupt)
+             - fallback to legacy interrupt */
+
+        err = request_irq(pci_dev->irq, saa7164_irq,
+                    IRQF_SHARED, dev->name, dev);
+    }
+
      if (err < 0) {
          printk(KERN_ERR "%s: can't get IRQ %d\n", dev->name,
              pci_dev->irq);
@@ -1441,6 +1466,11 @@ static void saa7164_finidev(struct pci_dev *pci_dev)
      /* unregister stuff */
      free_irq(pci_dev->irq, dev);

+    if (dev->msi) {
+        pci_disable_msi(pci_dev);
+        dev->msi = false;
+    }
+
      mutex_lock(&devlist);
      list_del(&dev->devlist);
      mutex_unlock(&devlist);
diff --git a/drivers/media/pci/saa7164/saa7164.h 
b/drivers/media/pci/saa7164/saa7164.h
index cd1a07c..6df4b252 100644
--- a/drivers/media/pci/saa7164/saa7164.h
+++ b/drivers/media/pci/saa7164/saa7164.h
@@ -459,6 +459,7 @@ struct saa7164_dev {
      /* Interrupt status and ack registers */
      u32 int_status;
      u32 int_ack;
+    u32 msi;

      struct cmd            cmds[SAA_CMD_MAX_MSG_UNITS];
      struct mutex            lock;
-- 
1.9.1


