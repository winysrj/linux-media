Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:58354 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751940AbeADC5r (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 3 Jan 2018 21:57:47 -0500
From: Yong Zhi <yong.zhi@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: tfiga@chromium.org, rajmohan.mani@intel.com,
        Yong Zhi <yong.zhi@intel.com>,
        Cao Bing Bu <bingbu.cao@intel.com>
Subject: [PATCH 1/2] media: intel-ipu3: cio2: fix a crash with out-of-bounds access
Date: Wed,  3 Jan 2018 20:57:16 -0600
Message-Id: <1515034637-3517-1-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When dmabuf is used for BLOB type frame, the frame
buffers allocated by gralloc will hold more pages
than the valid frame data due to height alignment.

In this case, the page numbers in sg list could exceed the
FBPT upper limit value - max_lops(8)*1024 to cause crash.

Limit the LOP access to the valid data length
to avoid FBPT sub-entries overflow.

Signed-off-by: Yong Zhi <yong.zhi@intel.com>
Signed-off-by: Cao Bing Bu <bingbu.cao@intel.com>
---
 drivers/media/pci/intel/ipu3/ipu3-cio2.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
index 941caa987dab..949f43d206ad 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
@@ -838,8 +838,9 @@ static int cio2_vb2_buf_init(struct vb2_buffer *vb)
 		container_of(vb, struct cio2_buffer, vbb.vb2_buf);
 	static const unsigned int entries_per_page =
 		CIO2_PAGE_SIZE / sizeof(u32);
-	unsigned int pages = DIV_ROUND_UP(vb->planes[0].length, CIO2_PAGE_SIZE);
-	unsigned int lops = DIV_ROUND_UP(pages + 1, entries_per_page);
+	unsigned int pages = DIV_ROUND_UP(vb->planes[0].length,
+					  CIO2_PAGE_SIZE) + 1;
+	unsigned int lops = DIV_ROUND_UP(pages, entries_per_page);
 	struct sg_table *sg;
 	struct sg_page_iter sg_iter;
 	int i, j;
@@ -869,6 +870,8 @@ static int cio2_vb2_buf_init(struct vb2_buffer *vb)
 
 	i = j = 0;
 	for_each_sg_page(sg->sgl, &sg_iter, sg->nents, 0) {
+		if (!pages--)
+			break;
 		b->lop[i][j] = sg_page_iter_dma_address(&sg_iter) >> PAGE_SHIFT;
 		j++;
 		if (j == entries_per_page) {
-- 
2.7.4
