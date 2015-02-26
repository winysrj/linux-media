Return-path: <linux-media-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:45083 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753685AbbBZXhr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Feb 2015 18:37:47 -0500
Message-ID: <54EFAC4B.6080002@redmandi.dyndns.org>
Date: Fri, 27 Feb 2015 10:29:15 +1100
From: Brendan McGrath <redmcg@redmandi.dyndns.org>
MIME-Version: 1.0
To: Steven Toth <stoth@kernellabs.com>
CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux-Media <linux-media@vger.kernel.org>
Subject: [PATCHv2] [media] saa7164: use an MSI interrupt when available
References: <54EE90BF.2030602@redmandi.dyndns.org> <CALzAhNX=KCnLmcv3iNtCwH2OLSTErytvK1kZpGCbAyQtmt6How@mail.gmail.com>
In-Reply-To: <CALzAhNX=KCnLmcv3iNtCwH2OLSTErytvK1kZpGCbAyQtmt6How@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Brendan McGrath <redmcg@redmandi.dyndns.org>
[media] saa7164: use an MSI interrupt when available

Enhances driver to use an MSI interrupt when available.

Adds the module option 'enable_msi' (type bool) which by default is 
enabled. Can be set to 'N' to disable.

Fixes (or can reduce the occurrence of) a crash which is most commonly 
reported when multiple saa7164 chips are in use.

Signed-off-by: Brendan McGrath <redmcg@redmandi.dyndns.org>
---

Thanks for the feedback Steven (and thanks for all your hard work on 
this driver!).

And thank-you Kyle for taking the time to test this patch. Much appreciated.


  drivers/media/pci/saa7164/saa7164-core.c | 40 
++++++++++++++++++++++++++++++--
  drivers/media/pci/saa7164/saa7164.h      |  1 +
  2 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/saa7164/saa7164-core.c 
b/drivers/media/pci/saa7164/saa7164-core.c
index 4b0bec3..1aff2ee 100644
--- a/drivers/media/pci/saa7164/saa7164-core.c
+++ b/drivers/media/pci/saa7164/saa7164-core.c
@@ -85,6 +85,11 @@ module_param(guard_checking, int, 0644);
  MODULE_PARM_DESC(guard_checking,
     "enable dma sanity checking for buffer overruns");

+static bool enable_msi = true;
+module_param(enable_msi, bool, 0444);
+MODULE_PARM_DESC(enable_msi,
+     "enable the use of an msi interrupt if available");
+
  static unsigned int saa7164_devcount;

  static DEFINE_MUTEX(devlist);
@@ -1230,8 +1235,34 @@ static int saa7164_initdev(struct pci_dev *pci_dev,
         goto fail_irq;
     }

-    err = request_irq(pci_dev->irq, saa7164_irq,
-        IRQF_SHARED, dev->name, dev);
+    /* irq bit */
+    if (enable_msi)
+        err = pci_enable_msi(pci_dev);
+
+    if (!err && enable_msi) {
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
+    if ((!enable_msi) || err) {
+        dev->msi = false;
+        /* if we have an error (i.e. we don't have an interrupt)
+             or msi is not enabled - fallback to shared interrupt */
+
+        err = request_irq(pci_dev->irq, saa7164_irq,
+                    IRQF_SHARED, dev->name, dev);
+    }
+
     if (err < 0) {
         printk(KERN_ERR "%s: can't get IRQ %d\n", dev->name,
             pci_dev->irq);
@@ -1441,6 +1472,11 @@ static void saa7164_finidev(struct pci_dev *pci_dev)
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



On 27/02/15 02:12, Steven Toth wrote:
>> I believe the root cause of the crash is due to a DMA/IRQ race condition. It
>> most commonly occurs when the saa7164 driver is dealing with more than one
>> saa7164 chip (the HVR-2200 and HVR-2250 for example have two - one for each
>> tuner). Given MSI avoids DMA/IRQ race conditions - this would explain why
>> the patch works as a fix.
> Brendan, thanks.
>
> With MSI I've had some people report complete success, others still
> have the issues.
>
> In my experience this does help with i2c timeout issues but not
> completely in every case. I've also seen it with single card instances
> so you descripton above is close - but not quiet accurate in all
> cases.
>
> While I'm generally OK with changing the driver behaviour to enable
> MSI by default, please add a module option to allow the behaviour to
> be disabled, reverting the driver back to existing behaviour.
>
> Once this is done, I'll be happy to Ack it.
>
> Thanks again.
>
> - Steve
>

