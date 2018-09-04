Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway20.websitewelcome.com ([192.185.50.28]:34374 "EHLO
        gateway20.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726437AbeIDX64 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 4 Sep 2018 19:58:56 -0400
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway20.websitewelcome.com (Postfix) with ESMTP id 3C38C400C7A01
        for <linux-media@vger.kernel.org>; Tue,  4 Sep 2018 14:07:51 -0500 (CDT)
Date: Tue, 4 Sep 2018 14:07:49 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Gerd Hoffmann <kraxel@redhat.com>,
        Sumit Semwal <sumit.semwal@linaro.org>
Cc: linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] dma-buf/udmabuf: Fix NULL pointer dereference in
 udmabuf_create
Message-ID: <20180904190749.GA9308@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is a potential execution path in which pointer memfd is NULL when
passed as argument to fput(), hence there is a NULL pointer dereference
in fput().

Fix this by null checking *memfd* before calling fput().

Addresses-Coverity-ID: 1473174 ("Explicit null dereferenced")
Fixes: fbb0de795078 ("Add udmabuf misc device")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/dma-buf/udmabuf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
index 8e24204..2e85022 100644
--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -194,7 +194,8 @@ static long udmabuf_create(struct udmabuf_create_list *head,
 	while (pgbuf > 0)
 		put_page(ubuf->pages[--pgbuf]);
 err_free_ubuf:
-	fput(memfd);
+	if (memfd)
+		fput(memfd);
 	kfree(ubuf->pages);
 	kfree(ubuf);
 	return ret;
-- 
2.7.4
