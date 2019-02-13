Return-Path: <SRS0=D6oO=QU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5D8DC282CA
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 14:02:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B721222B2
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 14:02:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UaWlJOzz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728604AbfBMOCT (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Feb 2019 09:02:19 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37697 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728131AbfBMOCT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Feb 2019 09:02:19 -0500
Received: by mail-pf1-f194.google.com with SMTP id s22so1188630pfh.4;
        Wed, 13 Feb 2019 06:02:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=36ygGGspzW8ypHYiojY4a19UR4qM+LFcK/AqwiiUnW8=;
        b=UaWlJOzz2ackVhNOEvTqRw+g7Q14CaWnQ5phD4+k34kKDiE9XAWdWrP6lxAcqDMcvH
         p1OYorR9lI0kR7DF/nsC4Iva2MUsOFIMPpxB0Xsv+IASFBtbVveFkKFfs7sbkLKaL5wK
         nB+jiIWQqNj3h9M3nWz1Yrk9TsksXTTt4BFP0yi7/VdcRwMLi+bsr6AvqWhlkUCJW2Qs
         U5cF/pkP+EGIQa3j2lsEqx13cbFeaztLJVcs9Vw+lksumAaSB4eyHICi3e+WfVP1lFoE
         hCtHOhFv/ivO6OJE2oR8V7hYcI0/IBQ7sxv0LS9gg/dUVb493geb6vxkVWhZWRVdgHL1
         Lprg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=36ygGGspzW8ypHYiojY4a19UR4qM+LFcK/AqwiiUnW8=;
        b=hIZYBhtEyrWvjWU8co/aCWkc+pPFRMsD+PnbpJxbXMDFbfZCi9TlgBfMBkm8qKUyCs
         2TpTNLvsRlIvF+Segez89LdoLBpD7Sa8NrYY+7BduTv1NSSwZclw/9YvvVe+cj7beZ3a
         jfPblVQAD+ALZsyb4ZOD/l+0AxW83k+7/QwcbPYdCvNlta+MbHIYxMcu4o93FNuG8nbi
         dZogYxydNzrGjjp6DboHGO47E8b2CX5izP4jW/oo4ghLnISrTDnE3qXCifXwugT7jsR7
         utMQBg3YQxItJnyuAEreIb912wXuRxaicYvQH7qt/gPIB/mpNm8zniy7SYxdaceY2w70
         74tQ==
X-Gm-Message-State: AHQUAuZGVPhx4v2EQNoSq4lY5b1s7ARitd5gVkSo49sQhNZYDSXCdjQU
        BA2+0tAO7JTfuLSkakqB/7o=
X-Google-Smtp-Source: AHgI3IaDwdflVtW11v/6xsFyC3jOYAurJGKejMHEvecGO/fqsTZc6/RKWjSSgAV0oISInFX0STjC5A==
X-Received: by 2002:a63:2705:: with SMTP id n5mr583961pgn.429.1550066538516;
        Wed, 13 Feb 2019 06:02:18 -0800 (PST)
Received: from jordon-HP-15-Notebook-PC ([49.207.48.54])
        by smtp.gmail.com with ESMTPSA id 145sm26360429pfa.160.2019.02.13.06.02.16
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 13 Feb 2019 06:02:17 -0800 (PST)
Date:   Wed, 13 Feb 2019 19:36:36 +0530
From:   Souptick Joarder <jrdr.linux@gmail.com>
To:     akpm@linux-foundation.org, willy@infradead.org, mhocko@suse.com,
        pawel@osciak.com, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, mchehab@kernel.org,
        linux@armlinux.org.uk, robin.murphy@arm.com
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH v3 7/9] videobuf2/videobuf2-dma-sg.c: Convert to use
 vm_map_pages()
Message-ID: <20190213140636.GA22063@jordon-HP-15-Notebook-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Convert to use vm_map_pages() to map range of kernel memory
to user vma.

vm_pgoff is treated in V4L2 API as a 'cookie' to select a buffer,
not as a in-buffer offset by design and it always want to mmap a
whole buffer from its beginning.

Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
Suggested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/common/videobuf2/videobuf2-core.c    |  7 +++++++
 .../media/common/videobuf2/videobuf2-dma-contig.c  |  6 ------
 drivers/media/common/videobuf2/videobuf2-dma-sg.c  | 22 ++++++----------------
 3 files changed, 13 insertions(+), 22 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index 70e8c33..ca4577a 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -2175,6 +2175,13 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
 		goto unlock;
 	}
 
+	/*
+	 * vm_pgoff is treated in V4L2 API as a 'cookie' to select a buffer,
+	 * not as a in-buffer offset. We always want to mmap a whole buffer
+	 * from its beginning.
+	 */
+	vma->vm_pgoff = 0;
+
 	ret = call_memop(vb, mmap, vb->planes[plane].mem_priv, vma);
 
 unlock:
diff --git a/drivers/media/common/videobuf2/videobuf2-dma-contig.c b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
index aff0ab7..46245c5 100644
--- a/drivers/media/common/videobuf2/videobuf2-dma-contig.c
+++ b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
@@ -186,12 +186,6 @@ static int vb2_dc_mmap(void *buf_priv, struct vm_area_struct *vma)
 		return -EINVAL;
 	}
 
-	/*
-	 * dma_mmap_* uses vm_pgoff as in-buffer offset, but we want to
-	 * map whole buffer
-	 */
-	vma->vm_pgoff = 0;
-
 	ret = dma_mmap_attrs(buf->dev, vma, buf->cookie,
 		buf->dma_addr, buf->size, buf->attrs);
 
diff --git a/drivers/media/common/videobuf2/videobuf2-dma-sg.c b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
index 015e737..d6b8eca 100644
--- a/drivers/media/common/videobuf2/videobuf2-dma-sg.c
+++ b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
@@ -328,28 +328,18 @@ static unsigned int vb2_dma_sg_num_users(void *buf_priv)
 static int vb2_dma_sg_mmap(void *buf_priv, struct vm_area_struct *vma)
 {
 	struct vb2_dma_sg_buf *buf = buf_priv;
-	unsigned long uaddr = vma->vm_start;
-	unsigned long usize = vma->vm_end - vma->vm_start;
-	int i = 0;
+	int err;
 
 	if (!buf) {
 		printk(KERN_ERR "No memory to map\n");
 		return -EINVAL;
 	}
 
-	do {
-		int ret;
-
-		ret = vm_insert_page(vma, uaddr, buf->pages[i++]);
-		if (ret) {
-			printk(KERN_ERR "Remapping memory, error: %d\n", ret);
-			return ret;
-		}
-
-		uaddr += PAGE_SIZE;
-		usize -= PAGE_SIZE;
-	} while (usize > 0);
-
+	err = vm_map_pages(vma, buf->pages, buf->num_pages);
+	if (err) {
+		printk(KERN_ERR "Remapping memory, error: %d\n", err);
+		return err;
+	}
 
 	/*
 	 * Use common vm_area operations to track buffer refcount.
-- 
1.9.1

