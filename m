Return-Path: <SRS0=DvKj=RW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C037C43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 02:24:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6BD5720700
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 02:24:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jwzR1+M3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727510AbfCSCYo (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Mar 2019 22:24:44 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35477 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726884AbfCSCYo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Mar 2019 22:24:44 -0400
Received: by mail-pf1-f195.google.com with SMTP id j5so12620385pfa.2;
        Mon, 18 Mar 2019 19:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=36ygGGspzW8ypHYiojY4a19UR4qM+LFcK/AqwiiUnW8=;
        b=jwzR1+M3eF/sRpwxsvcpjrltIEFZIy10zkgdsp0+V18FdtMnCPXQkqPMMawEIrufNp
         18bJG1e9/OwLZhIb5iJMPIsrmwKJqo1crkkdqjtD6R2eRIFXVI66sm411hENaUMx8LNk
         N6il2ILt3PeGOwRzbIPSObPKkYWxPUYj1O9Uyl/p+KGYWxpshx9BztRDVhbLRCTKsmaA
         vW8v/9hl/wep1ehA16EntcBER+jkIhD/rHGGrnepaMVz2O7xuk0euKIyhiXHhOrD8XW1
         fUG0LeL/VbNCfs1m6XDXgjWGiruq1wYIMOTKxbEZwiVXbxRERdDgEgnkkFuB7EO8b4VF
         RePg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=36ygGGspzW8ypHYiojY4a19UR4qM+LFcK/AqwiiUnW8=;
        b=R70uwQtD+T08wYNpQTrcdHifCmvpmYmrsbzXiPwwWfRF3P3Q53KQYeoh8ZYqd4rSZ8
         fIRK8EVx8jjDBQnnzZO4SrInjfypohzVOqzl630agIKuz0/wDKB9XLwSENxPdewD2xwY
         FTJjxjIertYxHMZOkBatI46nzsrgrwO/Qqiu3SuOViTewxhMvc9ZQZeqPwM50HiF86qs
         2e3DcpUyGv7IjBiX6QBhUo0Mkw5aT/IuOUE9DHoGsKtY6QfhbbmiElWmXICVp5hFaiHS
         rJaMi1luzZ4FGDdj8XjfVWJztCfcbUfF6/bMhOw4EQ8LzcyH77Um3WtGF5zRORa6cai5
         7aYw==
X-Gm-Message-State: APjAAAXZwh8WxInD5JHE+0m6r9VETm/KVvuX88eYTRf/URUqwHHIh+Er
        23UI0WgWdyrIJRezj2ZcqhQ=
X-Google-Smtp-Source: APXvYqxMdZ7HkxSFcd/qIJAARczAQkXpoQb865jAawnv3hwoKx/+hD/Cbw4bfxmUBGHIu3bO1uxxLQ==
X-Received: by 2002:a17:902:f20e:: with SMTP id gn14mr22842207plb.334.1552962283122;
        Mon, 18 Mar 2019 19:24:43 -0700 (PDT)
Received: from jordon-HP-15-Notebook-PC ([106.51.22.39])
        by smtp.gmail.com with ESMTPSA id a7sm1159088pfc.45.2019.03.18.19.24.41
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 18 Mar 2019 19:24:42 -0700 (PDT)
Date:   Tue, 19 Mar 2019 07:59:17 +0530
From:   Souptick Joarder <jrdr.linux@gmail.com>
To:     akpm@linux-foundation.org, willy@infradead.org, mhocko@suse.com,
        pawel@osciak.com, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, mchehab@kernel.org,
        linux@armlinux.org.uk, robin.murphy@arm.com
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [RESEND PATCH v4 7/9] videobuf2/videobuf2-dma-sg.c: Convert to use
 vm_map_pages()
Message-ID: <a953fe6b3056de1cc6eab654effdd4a22f125375.1552921225.git.jrdr.linux@gmail.com>
References: <cover.1552921225.git.jrdr.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1552921225.git.jrdr.linux@gmail.com>
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

