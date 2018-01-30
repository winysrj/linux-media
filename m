Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway23.websitewelcome.com ([192.185.49.184]:11270 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752280AbeA3A4z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Jan 2018 19:56:55 -0500
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id 2D4CFED03
        for <linux-media@vger.kernel.org>; Mon, 29 Jan 2018 18:33:03 -0600 (CST)
Date: Mon, 29 Jan 2018 18:33:01 -0600
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH 7/8] platform: sh_veu: fix potential integer overflow in
 sh_veu_colour_offset
Message-ID: <81bc1c8fa08d1643fa9b7b6630fdd42baed7d225.1517268668.git.gustavo@embeddedor.com>
References: <cover.1517268667.git.gustavo@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1517268667.git.gustavo@embeddedor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cast left and top to dma_addr_t in order to avoid a potential integer
overflow. This variable is being used in a context that expects an
expression of type dma_addr_t (u64).

Addresses-Coverity-ID: 1056807 ("Unintentional integer overflow")
Addresses-Coverity-ID: 1056808 ("Unintentional integer overflow")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/media/platform/sh_veu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/sh_veu.c b/drivers/media/platform/sh_veu.c
index 976ea0b..e2795d0 100644
--- a/drivers/media/platform/sh_veu.c
+++ b/drivers/media/platform/sh_veu.c
@@ -520,8 +520,8 @@ static void sh_veu_colour_offset(struct sh_veu_dev *veu, struct sh_veu_vfmt *vfm
 	/* dst_left and dst_top validity will be verified in CROP / COMPOSE */
 	unsigned int left = vfmt->frame.left & ~0x03;
 	unsigned int top = vfmt->frame.top;
-	dma_addr_t offset = ((left * veu->vfmt_out.fmt->depth) >> 3) +
-		top * veu->vfmt_out.bytesperline;
+	dma_addr_t offset = (((dma_addr_t)left * veu->vfmt_out.fmt->depth) >> 3) +
+			    (dma_addr_t)top * veu->vfmt_out.bytesperline;
 	unsigned int y_line;
 
 	vfmt->offset_y = offset;
-- 
2.7.4
