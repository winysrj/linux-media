Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:11086 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932168AbdLOPom (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 10:44:42 -0500
From: Yong Zhi <yong.zhi@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: mchehab@s-opensource.com, rajmohan.mani@intel.com,
        Yong Zhi <yong.zhi@intel.com>
Subject: [PATCH v8] intel-ipu3: cio2: fix two warnings in the code
Date: Fri, 15 Dec 2017 09:44:21 -0600
Message-Id: <1513352661-15520-1-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix two warnings reported by static analysis tool:

ipu3-cio2.c:1899:16: warning: Variable length array is used.

In function 'cio2_pci_probe':
ipu3-cio2.c:1726:14: warning: variable 'phys' set
but not used [-Wunused-but-set-variable]

Signed-off-by: Yong Zhi <yong.zhi@intel.com>
---
Hi, Mauro, thanks for catching the warnings.

Hi, Sakari, can you squash the patch to your tree? Thanks!!

 drivers/media/pci/intel/ipu3/ipu3-cio2.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
index 4295bdb8b192..941caa987dab 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
@@ -1723,7 +1723,6 @@ static int cio2_pci_probe(struct pci_dev *pci_dev,
 			  const struct pci_device_id *id)
 {
 	struct cio2_device *cio2;
-	phys_addr_t phys;
 	void __iomem *const *iomap;
 	int r;
 
@@ -1741,8 +1740,6 @@ static int cio2_pci_probe(struct pci_dev *pci_dev,
 	dev_info(&pci_dev->dev, "device 0x%x (rev: 0x%x)\n",
 		 pci_dev->device, pci_dev->revision);
 
-	phys = pci_resource_start(pci_dev, CIO2_PCI_BAR);
-
 	r = pcim_iomap_regions(pci_dev, 1 << CIO2_PCI_BAR, pci_name(pci_dev));
 	if (r) {
 		dev_err(&pci_dev->dev, "failed to remap I/O memory (%d)\n", r);
@@ -1896,7 +1893,6 @@ static void arrange(void *ptr, size_t elem_size, size_t elems, size_t start)
 		{ 0, start - 1 },
 		{ start, elems - 1 },
 	};
-	u8 tmp[elem_size];
 
 #define arr_size(a) ((a)->end - (a)->begin + 1)
 
@@ -1915,12 +1911,12 @@ static void arrange(void *ptr, size_t elem_size, size_t elems, size_t start)
 
 		/* Swap the entries in two parts of the array. */
 		for (i = 0; i < size0; i++) {
-			memcpy(tmp, ptr + elem_size * (arr[1].begin + i),
-			       elem_size);
-			memcpy(ptr + elem_size * (arr[1].begin + i),
-			       ptr + elem_size * (arr[0].begin + i), elem_size);
-			memcpy(ptr + elem_size * (arr[0].begin + i), tmp,
-			       elem_size);
+			u8 *d = ptr + elem_size * (arr[1].begin + i);
+			u8 *s = ptr + elem_size * (arr[0].begin + i);
+			size_t j;
+
+			for (j = 0; j < elem_size; j++)
+				swap(d[j], s[j]);
 		}
 
 		if (arr_size(&arr[0]) > arr_size(&arr[1])) {
-- 
2.7.4
