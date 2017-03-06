Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:3818 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932479AbdCFOgO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Mar 2017 09:36:14 -0500
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
Subject: [PATCH 17/29] drivers, pci: convert hv_pci_dev.refs from atomic_t to refcount_t
Date: Mon,  6 Mar 2017 16:21:04 +0200
Message-Id: <1488810076-3754-18-git-send-email-elena.reshetova@intel.com>
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
 drivers/pci/host/pci-hyperv.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/host/pci-hyperv.c b/drivers/pci/host/pci-hyperv.c
index cd114c6..870deed 100644
--- a/drivers/pci/host/pci-hyperv.c
+++ b/drivers/pci/host/pci-hyperv.c
@@ -56,6 +56,7 @@
 #include <asm/apic.h>
 #include <linux/msi.h>
 #include <linux/hyperv.h>
+#include <linux/refcount.h>
 #include <asm/mshyperv.h>
 
 /*
@@ -421,7 +422,7 @@ enum hv_pcidev_ref_reason {
 struct hv_pci_dev {
 	/* List protected by pci_rescan_remove_lock */
 	struct list_head list_entry;
-	atomic_t refs;
+	refcount_t refs;
 	enum hv_pcichild_state state;
 	struct pci_function_description desc;
 	bool reported_missing;
@@ -1254,13 +1255,13 @@ static void q_resource_requirements(void *context, struct pci_response *resp,
 static void get_pcichild(struct hv_pci_dev *hpdev,
 			    enum hv_pcidev_ref_reason reason)
 {
-	atomic_inc(&hpdev->refs);
+	refcount_inc(&hpdev->refs);
 }
 
 static void put_pcichild(struct hv_pci_dev *hpdev,
 			    enum hv_pcidev_ref_reason reason)
 {
-	if (atomic_dec_and_test(&hpdev->refs))
+	if (refcount_dec_and_test(&hpdev->refs))
 		kfree(hpdev);
 }
 
@@ -1314,7 +1315,7 @@ static struct hv_pci_dev *new_pcichild_device(struct hv_pcibus_device *hbus,
 	wait_for_completion(&comp_pkt.host_event);
 
 	hpdev->desc = *desc;
-	get_pcichild(hpdev, hv_pcidev_ref_initial);
+	refcount_set(&hpdev->refs, 1);
 	get_pcichild(hpdev, hv_pcidev_ref_childlist);
 	spin_lock_irqsave(&hbus->device_list_lock, flags);
 	list_add_tail(&hpdev->list_entry, &hbus->children);
-- 
2.7.4
