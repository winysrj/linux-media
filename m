Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:61464 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755158AbdKIWYN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 9 Nov 2017 17:24:13 -0500
From: Yong Zhi <yong.zhi@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: jian.xu.zheng@intel.com, tfiga@chromium.org,
        rajmohan.mani@intel.com, tuukka.toivonen@intel.com,
        hyungwoo.yang@intel.com, chiranjeevi.rapolu@intel.com,
        jerry.w.hu@intel.com, Yong Zhi <yong.zhi@intel.com>
Subject: Re: [PATCH v8 3/4] intel-ipu3: cio2: add new MIPI-CSI2 driver
Date: Thu,  9 Nov 2017 14:25:26 -0800
Message-Id: <1510266326-15516-1-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Sakari,

Fixed warnings about memset of pointer array and unsigned int used for 0 comparison
reported by static code analysis tool, please squash this to the driver, thanks!!

Signed-off-by: Yong Zhi <yong.zhi@intel.com>
---
 drivers/media/pci/intel/ipu3/ipu3-cio2.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
index 39d89ee..4295bdb 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
@@ -842,7 +842,7 @@ static int cio2_vb2_buf_init(struct vb2_buffer *vb)
 	unsigned int lops = DIV_ROUND_UP(pages + 1, entries_per_page);
 	struct sg_table *sg;
 	struct sg_page_iter sg_iter;
-	unsigned int i, j;
+	int i, j;
 
 	if (lops <= 0 || lops > CIO2_MAX_LOPS) {
 		dev_err(dev, "%s: bad buffer size (%i)\n", __func__,
@@ -850,7 +850,7 @@ static int cio2_vb2_buf_init(struct vb2_buffer *vb)
 		return -ENOSPC;		/* Should never happen */
 	}
 
-	memset(b->lop, 0, sizeof(*b->lop));
+	memset(b->lop, 0, sizeof(b->lop));
 	/* Allocate LOP table */
 	for (i = 0; i < lops; i++) {
 		b->lop[i] = dma_alloc_coherent(dev, CIO2_PAGE_SIZE,
@@ -880,7 +880,7 @@ static int cio2_vb2_buf_init(struct vb2_buffer *vb)
 	b->lop[i][j] = cio2->dummy_page_bus_addr >> PAGE_SHIFT;
 	return 0;
 fail:
-	for (; i >= 0; i--)
+	for (i--; i >= 0; i--)
 		dma_free_coherent(dev, CIO2_PAGE_SIZE,
 				  b->lop[i], b->lop_bus_addr[i]);
 	return -ENOMEM;
-- 
1.9.1
