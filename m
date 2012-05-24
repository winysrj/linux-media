Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:22905 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757328Ab2EXP5D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 May 2012 11:57:03 -0400
Date: Thu, 24 May 2012 18:56:41 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
	Federico Vaga <federico.vaga@gmail.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] videobuf-dma-contig: use gfp_t for GFP flags
Message-ID: <20120524155641.GA11037@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sparse complains if about using unsigned long.
videobuf-dma-contig.c:47:67: warning: restricted gfp_t degrades to integer
videobuf-dma-contig.c:47:65: warning: incorrect type in argument 2 (different base types)
videobuf-dma-contig.c:47:65:    expected restricted gfp_t [usertype] gfp_mask
videobuf-dma-contig.c:47:65:    got unsigned long

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/video/videobuf-dma-contig.c b/drivers/media/video/videobuf-dma-contig.c
index b6b5cc1..9b9a06f 100644
--- a/drivers/media/video/videobuf-dma-contig.c
+++ b/drivers/media/video/videobuf-dma-contig.c
@@ -40,7 +40,7 @@ struct videobuf_dma_contig_memory {
 
 static int __videobuf_dc_alloc(struct device *dev,
 			       struct videobuf_dma_contig_memory *mem,
-			       unsigned long size, unsigned long flags)
+			       unsigned long size, gfp_t flags)
 {
 	mem->size = size;
 	if (mem->cached) {
