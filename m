Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:39761 "EHLO
        mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752342AbdBNHwX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Feb 2017 02:52:23 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: [PATCH 09/15] media: s5p-mfc: Allocate firmware with internal private
 buffer alloc function
Date: Tue, 14 Feb 2017 08:52:02 +0100
Message-id: <1487058728-16501-10-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1487058728-16501-1-git-send-email-m.szyprowski@samsung.com>
References: <1487058728-16501-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20170214075218eucas1p188d8d26aa2a6c9157587e1c979008817@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Once firmware buffer has been converted to use s5p_mfc_priv_buf structure,
it is possible to allocate it with existing s5p_mfc_alloc_priv_buf()
function. This change will help to reduce code variants in the next
patches.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
index b0cf3970117a..a1811ee538bd 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
@@ -27,6 +27,7 @@
 int s5p_mfc_alloc_firmware(struct s5p_mfc_dev *dev)
 {
 	struct s5p_mfc_priv_buf *fw_buf = &dev->fw_buf;
+	int err;
 
 	fw_buf->size = dev->variant->buf_size->fw;
 
@@ -35,11 +36,10 @@ int s5p_mfc_alloc_firmware(struct s5p_mfc_dev *dev)
 		return -ENOMEM;
 	}
 
-	fw_buf->virt = dma_alloc_coherent(dev->mem_dev[BANK1_CTX], fw_buf->size,
-					 &fw_buf->dma, GFP_KERNEL);
-	if (!fw_buf->virt) {
+	err = s5p_mfc_alloc_priv_buf(dev, BANK1_CTX, &dev->fw_buf);
+	if (err) {
 		mfc_err("Allocating bitprocessor buffer failed\n");
-		return -ENOMEM;
+		return err;
 	}
 
 	return 0;
@@ -92,11 +92,7 @@ int s5p_mfc_release_firmware(struct s5p_mfc_dev *dev)
 {
 	/* Before calling this function one has to make sure
 	 * that MFC is no longer processing */
-	if (!dev->fw_buf.virt)
-		return -EINVAL;
-	dma_free_coherent(dev->mem_dev[BANK1_CTX], dev->fw_buf.size,
-			  dev->fw_buf.virt, dev->fw_buf.dma);
-	dev->fw_buf.virt = NULL;
+	s5p_mfc_release_priv_buf(dev, &dev->fw_buf);
 	return 0;
 }
 
-- 
1.9.1
