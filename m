Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:24155 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932252AbdCFOZ5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Mar 2017 09:25:57 -0500
From: Elena Reshetova <elena.reshetova@intel.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        netdev@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-media@vger.kernel.org, devel@linuxdriverproject.org,
        linux-pci@vger.kernel.org, linux-s390@vger.kernel.org,
        fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com, devel@driverdev.osuosl.org,
        target-devel@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-usb@vger.kernel.org, peterz@infradead.org,
        Elena Reshetova <elena.reshetova@intel.com>,
        Hans Liljestrand <ishkamiel@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        David Windsor <dwindsor@gmail.com>
Subject: [PATCH 11/29] drivers, media: convert cx88_core.refcount from atomic_t to refcount_t
Date: Mon,  6 Mar 2017 16:20:58 +0200
Message-Id: <1488810076-3754-12-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1488810076-3754-1-git-send-email-elena.reshetova@intel.com>
References: <1488810076-3754-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

refcount_t type and corresponding API should be
used instead of atomic_t when the variable is used as
a reference counter. This allows to avoid accidental
refcounter overflows that might lead to use-after-free
situations.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David Windsor <dwindsor@gmail.com>
---
 drivers/media/pci/cx88/cx88-cards.c | 2 +-
 drivers/media/pci/cx88/cx88-core.c  | 4 ++--
 drivers/media/pci/cx88/cx88.h       | 3 ++-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88-cards.c b/drivers/media/pci/cx88/cx88-cards.c
index cdfbde2..7fc5f5f 100644
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
index 115414c..16c1313 100644
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
+	refcount_t                   refcount;
 
 	/* board name */
 	int                        nr;
-- 
2.7.4
