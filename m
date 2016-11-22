Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55705 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932164AbcKVLJ3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Nov 2016 06:09:29 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Benoit Parrot <bparrot@ti.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH] [media] ti-vpe: get rid of some smatch warnings
Date: Tue, 22 Nov 2016 09:09:03 -0200
Message-Id: <af93189d4ebc7851eb387145d0ea8db52698308e.1479812941.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When compiled on i386, it produces several warnings:

	./arch/x86/include/asm/bitops.h:457:22: warning: asm output is not an lvalue
	./arch/x86/include/asm/bitops.h:457:22: warning: asm output is not an lvalue
	./arch/x86/include/asm/bitops.h:457:22: warning: asm output is not an lvalue
	./arch/x86/include/asm/bitops.h:457:22: warning: asm output is not an lvalue
	./arch/x86/include/asm/bitops.h:457:22: warning: asm output is not an lvalue
	./arch/x86/include/asm/bitops.h:457:22: warning: asm output is not an lvalue

I suspect that some gcc optimization could be causing the asm code to be
incorrectly generated. Splitting it into two macro calls fix the issues
and gets us rid of 6 smatch warnings, with is a good thing. As it should
not cause any troubles, as we're basically doing the same thing, let's
apply such change to vpe.c.

Cc: Benoit Parrot <bparrot@ti.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/ti-vpe/vpe.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 0626593a8b22..f0156b7759e9 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -1615,20 +1615,32 @@ static int __vpe_try_fmt(struct vpe_ctx *ctx, struct v4l2_format *f,
 	 */
 	depth_bytes = depth >> 3;
 
-	if (depth_bytes == 3)
+	if (depth_bytes == 3) {
 		/*
 		 * if bpp is 3(as in some RGB formats), the pixel width doesn't
 		 * really help in ensuring line stride is 16 byte aligned
 		 */
 		w_align = 4;
-	else
+	} else {
 		/*
 		 * for the remainder bpp(4, 2 and 1), the pixel width alignment
 		 * can ensure a line stride alignment of 16 bytes. For example,
 		 * if bpp is 2, then the line stride can be 16 byte aligned if
 		 * the width is 8 byte aligned
 		 */
-		w_align = order_base_2(VPDMA_DESC_ALIGN / depth_bytes);
+
+		/*
+		 * HACK: using order_base_2() here causes lots of asm output
+		 * errors with smatch, on i386:
+		 * ./arch/x86/include/asm/bitops.h:457:22:
+		 *		 warning: asm output is not an lvalue
+		 * Perhaps some gcc optimization is doing the wrong thing
+		 * there.
+		 * Let's get rid of them by doing the calculus on two steps
+		 */
+		w_align = roundup_pow_of_two(VPDMA_DESC_ALIGN / depth_bytes);
+		w_align = ilog2(w_align);
+	}
 
 	v4l_bound_align_image(&pix->width, MIN_W, MAX_W, w_align,
 			      &pix->height, MIN_H, MAX_H, H_ALIGN,
-- 
2.9.3

