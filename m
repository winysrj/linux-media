Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:41227 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1046182AbdDWVlK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Apr 2017 17:41:10 -0400
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: pawel@osciak.com, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 2/2] [media] vb2: Fix error handling in '__vb2_buf_mem_alloc'
Date: Sun, 23 Apr 2017 23:40:30 +0200
Message-Id: <20170423214030.14854-1-christophe.jaillet@wanadoo.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

'call_ptr_memop' can return NULL, so we must test its return value with
'IS_ERR_OR_NULL'. Otherwise, the test 'if (mem_priv)' is meaningless.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Note that error checking after 'call_ptr_memop' calls is not consistent
in this file. I guess that 'IS_ERR_OR_NULL' should be used everywhere
and that the corresponding error handling code should be tweaked just as
the code in this function.
---
 drivers/media/v4l2-core/videobuf2-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index c0175ea7e7ad..d1d3f5dd57b9 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -210,7 +210,7 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
 		mem_priv = call_ptr_memop(vb, alloc,
 				q->alloc_devs[plane] ? : q->dev,
 				q->dma_attrs, size, dma_dir, q->gfp_flags);
-		if (IS_ERR(mem_priv)) {
+		if (IS_ERR_OR_NULL(mem_priv)) {
 			if (mem_priv)
 				ret = PTR_ERR(mem_priv);
 			goto free;
-- 
2.11.0
