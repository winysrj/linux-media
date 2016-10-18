Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-07v.sys.comcast.net ([96.114.154.166]:46625 "EHLO
        resqmta-po-07v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933532AbcJRX22 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 19:28:28 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: kyungmin.park@samsung.com, kamil@wypas.org, jtp.park@samsung.com,
        a.hajda@samsung.com, mchehab@kernel.org
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: s5p-mfc collapse two error message into one
Date: Tue, 18 Oct 2016 17:28:22 -0600
Message-Id: <20161018232822.17423-1-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

s5p_mfc_alloc_priv_buf() prints two message to report invalid memory
configuration error. Collapse them into a single message.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
index eee16a1..44d2325 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
@@ -49,8 +49,7 @@ int s5p_mfc_alloc_priv_buf(struct device *dev, dma_addr_t base,
 	}
 
 	if (b->dma < base) {
-		mfc_err("Invaling memory configuration!\n");
-		mfc_err("Allocated buffer (%pad) is lower than memory base address (%pad)\n",
+		mfc_err("Invalid memory configuration - buffer (%pad) is below base memory address(%pad)\n",
 			&b->dma, &base);
 		dma_free_coherent(dev, b->size, b->virt, b->dma);
 		return -ENOMEM;
-- 
2.7.4

