Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway31.websitewelcome.com ([192.185.144.29]:27862 "EHLO
        gateway31.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751448AbeA3Axl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Jan 2018 19:53:41 -0500
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway31.websitewelcome.com (Postfix) with ESMTP id AF8E62F978
        for <linux-media@vger.kernel.org>; Mon, 29 Jan 2018 18:32:49 -0600 (CST)
Date: Mon, 29 Jan 2018 18:32:47 -0600
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Jacob chen <jacob2.chen@rock-chips.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>
Cc: linux-media@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH 6/8] rockchip/rga: fix potential integer overflow in
 rga_buf_map
Message-ID: <715937d1ae955d5e5d531ef93d503177865f4083.1517268668.git.gustavo@embeddedor.com>
References: <cover.1517268667.git.gustavo@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1517268667.git.gustavo@embeddedor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cast p to dma_addr_t in order to avoid a potential integer overflow.
This variable is being used in a context that expects an expression
of type dma_addr_t (u64).

Addresses-Coverity-ID: 1458347 ("Unintentional integer overflow")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/media/platform/rockchip/rga/rga-buf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/rockchip/rga/rga-buf.c b/drivers/media/platform/rockchip/rga/rga-buf.c
index 49cacc7..3dd29b2 100644
--- a/drivers/media/platform/rockchip/rga/rga-buf.c
+++ b/drivers/media/platform/rockchip/rga/rga-buf.c
@@ -140,7 +140,7 @@ void rga_buf_map(struct vb2_buffer *vb)
 		address = sg_phys(sgl);
 
 		for (p = 0; p < len; p++) {
-			dma_addr_t phys = address + (p << PAGE_SHIFT);
+			dma_addr_t phys = address + ((dma_addr_t)p << PAGE_SHIFT);
 
 			pages[mapped_size + p] = phys;
 		}
-- 
2.7.4
