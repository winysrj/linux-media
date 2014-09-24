Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60676 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaIXXY5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 19:24:57 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Jeongtae Park <jtp.park@samsung.com>,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCHv2 1/2] [media] s5p_mfc_opr: Fix warnings
Date: Wed, 24 Sep 2014 20:24:28 -0300
Message-Id: <fe8cf45259509ecd981732901b4b74579c1ccc19.1411601060.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  CC      drivers/media//platform/s5p-mfc/s5p_mfc_opr.o
drivers/media//platform/s5p-mfc/s5p_mfc_opr.c: In function ‘s5p_mfc_alloc_priv_buf’:
drivers/media//platform/s5p-mfc/s5p_mfc_opr.c:44:2: warning: format ‘%d’ expects argument of type ‘int’, but argument 4 has type ‘size_t’ [-Wformat=]
  mfc_debug(3, "Allocating priv: %d\n", b->size);
  ^
drivers/media//platform/s5p-mfc/s5p_mfc_opr.c:53:2: warning: format ‘%x’ expects argument of type ‘unsigned int’, but argument 5 has type ‘dma_addr_t’ [-Wformat=]
  mfc_debug(3, "Allocated addr %p %08x\n", b->virt, b->dma);
  ^

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
index c9a227428e6a..00a1d8b2a8c2 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
@@ -41,7 +41,7 @@ int s5p_mfc_alloc_priv_buf(struct device *dev,
 					struct s5p_mfc_priv_buf *b)
 {
 
-	mfc_debug(3, "Allocating priv: %d\n", b->size);
+	mfc_debug(3, "Allocating priv: %zu\n", b->size);
 
 	b->virt = dma_alloc_coherent(dev, b->size, &b->dma, GFP_KERNEL);
 
@@ -50,7 +50,7 @@ int s5p_mfc_alloc_priv_buf(struct device *dev,
 		return -ENOMEM;
 	}
 
-	mfc_debug(3, "Allocated addr %p %08x\n", b->virt, b->dma);
+	mfc_debug(3, "Allocated addr %p %pad\n", b->virt, &b->dma);
 	return 0;
 }
 
-- 
1.9.3

