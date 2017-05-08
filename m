Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:60424 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751373AbdEHJMj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 May 2017 05:12:39 -0400
Subject: [PATCH 2/4] dma-buf: Improve a size determination in dma_buf_attach()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-media@vger.kernel.org, Gustavo Padovan <gustavo@padovan.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <3d972fa2-787a-d1f2-ff86-5c05494e00d3@users.sourceforge.net>
Message-ID: <cff83dc6-4391-d9b1-6ac2-791d5a3e2eb4@users.sourceforge.net>
Date: Mon, 8 May 2017 11:12:31 +0200
MIME-Version: 1.0
In-Reply-To: <3d972fa2-787a-d1f2-ff86-5c05494e00d3@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 8 May 2017 10:50:09 +0200

Replace the specification of a data structure by a pointer dereference
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/dma-buf/dma-buf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 53257c166f4d..9887d72cf804 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -558,7 +558,7 @@ struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
 	if (WARN_ON(!dmabuf || !dev))
 		return ERR_PTR(-EINVAL);
 
-	attach = kzalloc(sizeof(struct dma_buf_attachment), GFP_KERNEL);
+	attach = kzalloc(sizeof(*attach), GFP_KERNEL);
 	if (attach == NULL)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.12.2
