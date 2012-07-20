Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:63834 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab2GTP2O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jul 2012 11:28:14 -0400
Received: from epcpsbgm2.samsung.com (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M7G00J1ETN10XG0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Sat, 21 Jul 2012 00:28:13 +0900 (KST)
Received: from localhost.localdomain ([106.116.147.39])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M7G00JMBTMU3P30@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Sat, 21 Jul 2012 00:28:13 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com,
	kyungmin.park@samsung.com, jtp.park@samsung.com,
	Kamil Debski <k.debski@samsung.com>
Subject: [PATCH 1/2] s5p-mfc: Fix second memory bank alignment
Date: Fri, 20 Jul 2012 17:28:03 +0200
Message-id: <1342798084-2934-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
index 08a5cfe..fd62402 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
@@ -78,7 +78,7 @@ int s5p_mfc_alloc_and_load_firmware(struct s5p_mfc_dev *dev)
 	}
 	dev->bank1 = s5p_mfc_bitproc_phys;
 	b_base = vb2_dma_contig_memops.alloc(
-		dev->alloc_ctx[MFC_BANK2_ALLOC_CTX], 1 << MFC_BANK2_ALIGN_ORDER);
+		dev->alloc_ctx[MFC_BANK2_ALLOC_CTX], 1 << MFC_BASE_ALIGN_ORDER);
 	if (IS_ERR(b_base)) {
 		vb2_dma_contig_memops.put(s5p_mfc_bitproc_buf);
 		s5p_mfc_bitproc_phys = 0;
-- 
1.7.0.4

