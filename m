Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:5086 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752812AbdLSVIr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 16:08:47 -0500
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Kristian Beilke <beilke@posteo.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 07/10] staging: atomisp: Remove redundant PCI code
Date: Tue, 19 Dec 2017 22:59:54 +0200
Message-Id: <20171219205957.10933-7-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20171219205957.10933-1-andriy.shevchenko@linux.intel.com>
References: <20171219205957.10933-1-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no need to keep a reference to PCI root bridge.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_internal.h | 1 -
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c     | 8 --------
 2 files changed, 9 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_internal.h b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_internal.h
index 52a6f8002048..dc476a3dd271 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_internal.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_internal.h
@@ -227,7 +227,6 @@ struct atomisp_device {
 	struct media_device media_dev;
 	struct atomisp_platform_data *pdata;
 	void *mmu_l1_base;
-	struct pci_dev *pci_root;
 	const struct firmware *firmware;
 
 	struct pm_qos_request pm_qos;
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
index 7a9efc6847ca..548e00e7d67b 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
@@ -1210,11 +1210,6 @@ static int atomisp_pci_probe(struct pci_dev *dev,
 	isp->pdev = dev;
 	isp->dev = &dev->dev;
 	isp->sw_contex.power_state = ATOM_ISP_POWER_UP;
-	isp->pci_root = pci_get_bus_and_slot(0, 0);
-	if (!isp->pci_root) {
-		dev_err(&dev->dev, "Unable to find PCI host\n");
-		return -ENODEV;
-	}
 	isp->saved_regs.ispmmadr = start;
 
 	rt_mutex_init(&isp->mutex);
@@ -1494,7 +1489,6 @@ static int atomisp_pci_probe(struct pci_dev *dev,
 	/* Address later when we worry about the ...field chips */
 	if (IS_ENABLED(CONFIG_PM) && atomisp_mrfld_power_down(isp))
 		dev_err(&dev->dev, "Failed to switch off ISP\n");
-	pci_dev_put(isp->pci_root);
 	return err;
 }
 
@@ -1515,8 +1509,6 @@ static void atomisp_pci_remove(struct pci_dev *dev)
 	pm_qos_remove_request(&isp->pm_qos);
 
 	atomisp_msi_irq_uninit(isp, dev);
-	pci_dev_put(isp->pci_root);
-
 	atomisp_unregister_entities(isp);
 
 	destroy_workqueue(isp->wdt_work_queue);
-- 
2.15.1
