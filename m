Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36784 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389511AbeKGC7Q (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Nov 2018 21:59:16 -0500
Date: Tue, 6 Nov 2018 23:06:29 +0530
From: Souptick Joarder <jrdr.linux@gmail.com>
To: akpm@linux-foundation.org
Cc: kraxel@redhat.com, sumit.semwal@linaro.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org
Subject: [PATCH] udmabuf: Convert to use vm_fault_t
Message-ID: <20181106173628.GA12989@jordon-HP-15-Notebook-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use new return type vm_fault_t for fault handler.

Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
---
 drivers/dma-buf/udmabuf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
index 5b44ef2..699b6b7 100644
--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -20,7 +20,7 @@ struct udmabuf {
 	struct page **pages;
 };
 
-static int udmabuf_vm_fault(struct vm_fault *vmf)
+static vm_fault_t udmabuf_vm_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct udmabuf *ubuf = vma->vm_private_data;
-- 
1.9.1
