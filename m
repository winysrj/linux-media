Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:56974 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753045AbdCMN2g (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Mar 2017 09:28:36 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: elena.reshetova@intel.com
Subject: [PATCH 1/2] cx88: convert struct cx88_core.refcount from atomic_t to refcount_t
Date: Mon, 13 Mar 2017 15:24:55 +0200
Message-Id: <1489411496-31240-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1489411496-31240-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1489411496-31240-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Elena Reshetova <elena.reshetova@intel.com>

refcount_t is better suitable for counting references than atomic_t.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David Windsor <dwindsor@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/pci/cx88/cx88-cards.c | 2 +-
 drivers/media/pci/cx88/cx88-core.c  | 4 ++--
 drivers/media/pci/cx88/cx88.h       | 3 ++-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88-cards.c b/drivers/media/pci/cx88/cx88-cards.c
index 61e1803..73cc7a6 100644
--- a/drivers/media/pci/cx88/cx88-cards.c
+++ b/drivers/media/pci/cx88/cx88-cards.c
@@ -3670,7 +3670,7 @@ struct cx88_core *cx88_core_create(struct pci_dev *pci, int nr)
 	if (!core)
 		return NULL;
 
-	atomic_inc(&core->refcount);
+	refcount_set(&core->refcount, 1);
 	core->pci_bus  = pci->bus->number;
 	core->pci_slot = PCI_SLOT(pci->devfn);
 	core->pci_irqmask = PCI_INT_RISC_RD_BERRINT | PCI_INT_RISC_WR_BERRINT |
diff --git a/drivers/media/pci/cx88/cx88-core.c b/drivers/media/pci/cx88/cx88-core.c
index 973a9cd4..8bfa5b7 100644
--- a/drivers/media/pci/cx88/cx88-core.c
+++ b/drivers/media/pci/cx88/cx88-core.c
@@ -1052,7 +1052,7 @@ struct cx88_core *cx88_core_get(struct pci_dev *pci)
 			mutex_unlock(&devlist);
 			return NULL;
 		}
-		atomic_inc(&core->refcount);
+		refcount_inc(&core->refcount);
 		mutex_unlock(&devlist);
 		return core;
 	}
@@ -1073,7 +1073,7 @@ void cx88_core_put(struct cx88_core *core, struct pci_dev *pci)
 	release_mem_region(pci_resource_start(pci, 0),
 			   pci_resource_len(pci, 0));
 
-	if (!atomic_dec_and_test(&core->refcount))
+	if (!refcount_dec_and_test(&core->refcount))
 		return;
 
 	mutex_lock(&devlist);
diff --git a/drivers/media/pci/cx88/cx88.h b/drivers/media/pci/cx88/cx88.h
index 115414c..6777926 100644
--- a/drivers/media/pci/cx88/cx88.h
+++ b/drivers/media/pci/cx88/cx88.h
@@ -24,6 +24,7 @@
 #include <linux/i2c-algo-bit.h>
 #include <linux/videodev2.h>
 #include <linux/kdev_t.h>
+#include <linux/refcount.h>
 
 #include <media/v4l2-device.h>
 #include <media/v4l2-fh.h>
@@ -339,7 +340,7 @@ struct cx8802_dev;
 
 struct cx88_core {
 	struct list_head           devlist;
-	atomic_t                   refcount;
+	refcount_t		   refcount;
 
 	/* board name */
 	int                        nr;
-- 
2.7.4
