Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:56350 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbeINMJm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Sep 2018 08:09:42 -0400
Date: Fri, 14 Sep 2018 09:56:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] udmabuf: fix error code in map_udmabuf()
Message-ID: <20180914065615.GA12043@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We accidentally forgot to set "ret" on this error path so it means we
return NULL instead of an error pointer.  The caller checks for NULL and
changes it to an error pointer so it doesn't cause an issue at run time.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
index 9edabce0b8ab..5b44ef226904 100644
--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -61,8 +61,10 @@ static struct sg_table *map_udmabuf(struct dma_buf_attachment *at,
 					GFP_KERNEL);
 	if (ret < 0)
 		goto err;
-	if (!dma_map_sg(at->dev, sg->sgl, sg->nents, direction))
+	if (!dma_map_sg(at->dev, sg->sgl, sg->nents, direction)) {
+		ret = -EINVAL;
 		goto err;
+	}
 	return sg;
 
 err:
