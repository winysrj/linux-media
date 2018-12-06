Return-Path: <SRS0=eh97=OP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2343C04EB8
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 18:40:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6953E2064D
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 18:40:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bG1t/h0G"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6953E2064D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725927AbeLFSkw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 6 Dec 2018 13:40:52 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39020 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725908AbeLFSkw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Dec 2018 13:40:52 -0500
Received: by mail-pg1-f195.google.com with SMTP id w6so521995pgl.6;
        Thu, 06 Dec 2018 10:40:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=HbjeRliO+vM5aLRxbYChK+9NDy/qsrTu+jTUTd4ZwgM=;
        b=bG1t/h0G7HsmA8R+Dyhl/GxN0xwqpb0yRUvCY5ZAei4St/imeZmfW5xzHWeExs79G7
         3ipntKMO3eRjL4zxGs7HpMj+sgWx8f7Gkhdo19zA8gGWXe9Xe+RQ9hP5SVTQLc8v6R1R
         2eiOfvElsrx4gWkx12UCqMOmn3x3x3c1FdSh0sJm+U9096poTqhv72EonZtd1mNXGjBc
         7Xawu+wvgf48R9y35/7UxQRHCqNgJbERrTZJrK5N+bL5DJP0YxfYek6wFkK+PV1wVxjf
         2Zc2+79sZCqXcDhJGRPyZCa08FJ3rUFPZE1tU+sKxD+Pzfaek2tNq5FLPuk6ZjWdENPM
         dq3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=HbjeRliO+vM5aLRxbYChK+9NDy/qsrTu+jTUTd4ZwgM=;
        b=ZGIAz2DkNekUu/b/uN2BS1EHz5xNbXV+gmKY8ah6NcgsRThkiDSVZVIhwHgnNAyNFe
         BDs0uhdu7gbjUq9qIbSX7s+jUUSzSuGGnyoYoTcWWVT1ATNxCGIfifLvyt/bgZrcI8np
         aQZudjoE1OpOb35agGH/KfdHMj2EuYaoEtoIk06oWhhFFrVXM9S42U6jESOUuHoyR10Y
         7ezzzFL23PDBicoFvgUQvuuYFRnoIdAVnL8zi/BD5VyIPToTVkljdxQF2Gq44UY+mNMH
         CvOpeY8Pat5BqMppDEjkh3Ul28VKTw1POGURMUbRkDIMW9ZVS9rsvbZHuc2CTD/iEEuH
         HOgg==
X-Gm-Message-State: AA+aEWZrEpCJTo1ohUrTID+pDQzEbTpM2udXCcq+087H80+nViG+j2fD
        xeSjrNzQPGBaGr5TgMDLpxY=
X-Google-Smtp-Source: AFSGD/WLGphCOCPH36gfYZkaZrYNW1GtPiXDD9WUqhjHZb9vQUpQfm9+hBvkksnAYbZQwgNgM6d5hw==
X-Received: by 2002:a65:6491:: with SMTP id e17mr24801379pgv.418.1544121651571;
        Thu, 06 Dec 2018 10:40:51 -0800 (PST)
Received: from jordon-HP-15-Notebook-PC ([103.227.99.39])
        by smtp.gmail.com with ESMTPSA id y6sm1602250pfd.104.2018.12.06.10.40.50
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 06 Dec 2018 10:40:50 -0800 (PST)
Date:   Fri, 7 Dec 2018 00:14:38 +0530
From:   Souptick Joarder <jrdr.linux@gmail.com>
To:     akpm@linux-foundation.org, willy@infradead.org, mhocko@suse.com,
        pawel@osciak.com, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, mchehab@kernel.org
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH v3 7/9] videobuf2/videobuf2-dma-sg.c: Convert to use
 vm_insert_range
Message-ID: <20181206184438.GA31370@jordon-HP-15-Notebook-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Convert to use vm_insert_range to map range of kernel memory
to user vma.

Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
Reviewed-by: Matthew Wilcox <willy@infradead.org>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/common/videobuf2/videobuf2-dma-sg.c | 23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-dma-sg.c b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
index 015e737..898adef 100644
--- a/drivers/media/common/videobuf2/videobuf2-dma-sg.c
+++ b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
@@ -328,28 +328,19 @@ static unsigned int vb2_dma_sg_num_users(void *buf_priv)
 static int vb2_dma_sg_mmap(void *buf_priv, struct vm_area_struct *vma)
 {
 	struct vb2_dma_sg_buf *buf = buf_priv;
-	unsigned long uaddr = vma->vm_start;
-	unsigned long usize = vma->vm_end - vma->vm_start;
-	int i = 0;
+	unsigned long page_count = vma_pages(vma);
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
+	err = vm_insert_range(vma, vma->vm_start, buf->pages, page_count);
+	if (err) {
+		printk(KERN_ERR "Remapping memory, error: %d\n", err);
+		return err;
+	}
 
 	/*
 	 * Use common vm_area operations to track buffer refcount.
-- 
1.9.1

