Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0254.hostedemail.com ([216.40.44.254]:47303 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751356AbcCEHwg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Mar 2016 02:52:36 -0500
From: Joe Perches <joe@perches.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
	Vinod Koul <vinod.koul@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Benoit Parrot <bparrot@ti.com>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	Jiri Kosina <trivial@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matt Porter <mporter@kernel.crashing.org>,
	Alexandre Bounine <alexandre.bounine@idt.com>,
	linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	linux-nvdimm@lists.01.org
Subject: [TRIVIAL PATCH] treewide: Remove unnecessary 0x prefixes before %pa extension uses
Date: Fri,  4 Mar 2016 23:46:32 -0800
Message-Id: <dcdebc08a17023fac93595312281cb8e91185668.1457162650.git.joe@perches.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since commit 3cab1e711297 ("lib/vsprintf: refactor duplicate code
to special_hex_number()") %pa uses have been ouput with a 0x prefix.

These 0x prefixes in the formats are unnecessary.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/dma/at_hdmac_regs.h              | 2 +-
 drivers/media/platform/ti-vpe/cal.c      | 2 +-
 drivers/nvdimm/pmem.c                    | 2 +-
 drivers/rapidio/devices/rio_mport_cdev.c | 4 ++--
 drivers/rapidio/devices/tsi721.c         | 8 ++++----
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/dma/at_hdmac_regs.h b/drivers/dma/at_hdmac_regs.h
index 7f58f06..0474e4a 100644
--- a/drivers/dma/at_hdmac_regs.h
+++ b/drivers/dma/at_hdmac_regs.h
@@ -385,7 +385,7 @@ static void vdbg_dump_regs(struct at_dma_chan *atchan) {}
 static void atc_dump_lli(struct at_dma_chan *atchan, struct at_lli *lli)
 {
 	dev_crit(chan2dev(&atchan->chan_common),
-		 "  desc: s%pad d%pad ctrl0x%x:0x%x l0x%pad\n",
+		 "  desc: s%pad d%pad ctrl0x%x:0x%x l%pad\n",
 		 &lli->saddr, &lli->daddr,
 		 lli->ctrla, lli->ctrlb, &lli->dscr);
 }
diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
index 82001e6..7dce489 100644
--- a/drivers/media/platform/ti-vpe/cal.c
+++ b/drivers/media/platform/ti-vpe/cal.c
@@ -498,7 +498,7 @@ static inline void cal_runtime_put(struct cal_dev *dev)
 
 static void cal_quickdump_regs(struct cal_dev *dev)
 {
-	cal_info(dev, "CAL Registers @ 0x%pa:\n", &dev->res->start);
+	cal_info(dev, "CAL Registers @ %pa:\n", &dev->res->start);
 	print_hex_dump(KERN_INFO, "", DUMP_PREFIX_OFFSET, 16, 4,
 		       (__force const void *)dev->base,
 		       resource_size(dev->res), false);
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 8d0b546..eb619d1 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -172,7 +172,7 @@ static struct pmem_device *pmem_alloc(struct device *dev,
 
 	if (!devm_request_mem_region(dev, pmem->phys_addr, pmem->size,
 			dev_name(dev))) {
-		dev_warn(dev, "could not reserve region [0x%pa:0x%zx]\n",
+		dev_warn(dev, "could not reserve region [%pa:0x%zx]\n",
 				&pmem->phys_addr, pmem->size);
 		return ERR_PTR(-EBUSY);
 	}
diff --git a/drivers/rapidio/devices/rio_mport_cdev.c b/drivers/rapidio/devices/rio_mport_cdev.c
index a3369d1..211a67d 100644
--- a/drivers/rapidio/devices/rio_mport_cdev.c
+++ b/drivers/rapidio/devices/rio_mport_cdev.c
@@ -2223,7 +2223,7 @@ static void mport_mm_open(struct vm_area_struct *vma)
 {
 	struct rio_mport_mapping *map = vma->vm_private_data;
 
-rmcd_debug(MMAP, "0x%pad", &map->phys_addr);
+	rmcd_debug(MMAP, "%pad", &map->phys_addr);
 	kref_get(&map->ref);
 }
 
@@ -2231,7 +2231,7 @@ static void mport_mm_close(struct vm_area_struct *vma)
 {
 	struct rio_mport_mapping *map = vma->vm_private_data;
 
-rmcd_debug(MMAP, "0x%pad", &map->phys_addr);
+	rmcd_debug(MMAP, "%pad", &map->phys_addr);
 	mutex_lock(&map->md->buf_mutex);
 	kref_put(&map->ref, mport_release_mapping);
 	mutex_unlock(&map->md->buf_mutex);
diff --git a/drivers/rapidio/devices/tsi721.c b/drivers/rapidio/devices/tsi721.c
index b5b4556..4c20e99 100644
--- a/drivers/rapidio/devices/tsi721.c
+++ b/drivers/rapidio/devices/tsi721.c
@@ -1101,7 +1101,7 @@ static int tsi721_rio_map_inb_mem(struct rio_mport *mport, dma_addr_t lstart,
 		ibw_start = lstart & ~(ibw_size - 1);
 
 		tsi_debug(IBW, &priv->pdev->dev,
-			"Direct (RIO_0x%llx -> PCIe_0x%pad), size=0x%x, ibw_start = 0x%llx",
+			"Direct (RIO_0x%llx -> PCIe_%pad), size=0x%x, ibw_start = 0x%llx",
 			rstart, &lstart, size, ibw_start);
 
 		while ((lstart + size) > (ibw_start + ibw_size)) {
@@ -1120,7 +1120,7 @@ static int tsi721_rio_map_inb_mem(struct rio_mport *mport, dma_addr_t lstart,
 
 	} else {
 		tsi_debug(IBW, &priv->pdev->dev,
-			"Translated (RIO_0x%llx -> PCIe_0x%pad), size=0x%x",
+			"Translated (RIO_0x%llx -> PCIe_%pad), size=0x%x",
 			rstart, &lstart, size);
 
 		if (!is_power_of_2(size) || size < 0x1000 ||
@@ -1215,7 +1215,7 @@ static int tsi721_rio_map_inb_mem(struct rio_mport *mport, dma_addr_t lstart,
 	priv->ibwin_cnt--;
 
 	tsi_debug(IBW, &priv->pdev->dev,
-		"Configured IBWIN%d (RIO_0x%llx -> PCIe_0x%pad), size=0x%llx",
+		"Configured IBWIN%d (RIO_0x%llx -> PCIe_%pad), size=0x%llx",
 		i, ibw_start, &loc_start, ibw_size);
 
 	return 0;
@@ -1237,7 +1237,7 @@ static void tsi721_rio_unmap_inb_mem(struct rio_mport *mport,
 	int i;
 
 	tsi_debug(IBW, &priv->pdev->dev,
-		"Unmap IBW mapped to PCIe_0x%pad", &lstart);
+		"Unmap IBW mapped to PCIe_%pad", &lstart);
 
 	/* Search for matching active inbound translation window */
 	for (i = 0; i < TSI721_IBWIN_NUM; i++) {
-- 
2.6.3.368.gf34be46

