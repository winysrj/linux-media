Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway33.websitewelcome.com ([192.185.146.78]:39034 "EHLO
        gateway33.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751617AbeBEUuN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Feb 2018 15:50:13 -0500
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway33.websitewelcome.com (Postfix) with ESMTP id 256A61674C
        for <linux-media@vger.kernel.org>; Mon,  5 Feb 2018 14:27:38 -0600 (CST)
Date: Mon, 5 Feb 2018 14:27:37 -0600
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Jacob chen <jacob2.chen@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH v2 6/8] rockchip/rga: use 64-bit arithmetic instead of 32-bit
Message-ID: <94fd0993cde02e18ee5d7f54707f8ce0d0341a0c.1517856716.git.gustavo@embeddedor.com>
References: <cover.1517856716.git.gustavo@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1517856716.git.gustavo@embeddedor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cast p to dma_addr_t in order to avoid a potential integer overflow.
This variable is being used in a context that expects an expression
of type dma_addr_t (u64).

The expression p << PAGE_SHIFT is currently being evaluated
using 32-bit arithmetic.

Addresses-Coverity-ID: 1458347
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
Changes in v2:
 - Update subject and changelog to better reflect the proposed code change.

 drivers/media/platform/rockchip/rga/rga-buf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/rockchip/rga/rga-buf.c b/drivers/media/platform/rockchip/rga/rga-buf.c
index 49cacc7..a43b57a 100644
--- a/drivers/media/platform/rockchip/rga/rga-buf.c
+++ b/drivers/media/platform/rockchip/rga/rga-buf.c
@@ -140,7 +140,8 @@ void rga_buf_map(struct vb2_buffer *vb)
 		address = sg_phys(sgl);
 
 		for (p = 0; p < len; p++) {
-			dma_addr_t phys = address + (p << PAGE_SHIFT);
+			dma_addr_t phys = address +
+					  ((dma_addr_t)p << PAGE_SHIFT);
 
 			pages[mapped_size + p] = phys;
 		}
-- 
2.7.4
