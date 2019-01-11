Return-Path: <SRS0=SCQz=PT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 239D4C43387
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 15:08:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7DCD2084C
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 15:08:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ukuye4IL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391965AbfAKPHz (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 11 Jan 2019 10:07:55 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:43077 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730013AbfAKPHy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Jan 2019 10:07:54 -0500
Received: by mail-pg1-f193.google.com with SMTP id v28so6415498pgk.10;
        Fri, 11 Jan 2019 07:07:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=xmLU2VoxBI1AblI7e4+GVmT5PEuDGrr9Ez3gDZemTlo=;
        b=ukuye4ILBghvl/ea98/Ja45KGMhw2LJ9JaPBDDpqgt2y9VBAhCkwXx/XCC1BJBLszm
         j/RFMHQI1vnQZm2S/durahGZ3fABpMUNvQNZKd2mWCd1b0seaQ1HdjW0BjizObBP/e+S
         7mMLpf4vsXaJ9HXyxFoviwshTVxHZpfMU6FgoF1sktEarBm8ClO7PCkxUkcJ/BwNxnZL
         yBl4z8N8OTasKmGS9Usrz+JXD5rBahLAWvbEMuQYtCd2+Q9qOk9vKmSlfa499/WHZ/oa
         C9rO4vYI+xLVeQMZgqOYNUmpDt6leBfFn8bwAdgRC1xdcK18dvi1UirqW/G0uJ8Y+Kpe
         4A1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=xmLU2VoxBI1AblI7e4+GVmT5PEuDGrr9Ez3gDZemTlo=;
        b=TFAP3oRa2FPyVVN8gthZa/yQchM3o/blWpILdGZGnicvrIsnlAbwZDDPRqDDdvHd9m
         J4ApUIkAe6S94NJz6IhBs1EhLqmbltzrXZhLAcFzbX0efc31+8ZROEufI2CO1NvDw+hS
         n8ORIfSAQSx/7Yrd5QMrsFUSu2Hdsr+HgCTShLB9TXYEcHNY8cvpepCLx/KBH8x2sIwN
         hIhM1f9I33bzGwhS6DGv/rw8BCmsQN6+/CVskdBrLlt8+SenvEIhzctR4fbjBaX73PGp
         qwK5skGhAaDQy/yMZxXgP1TfYk7mQ09x66ec1wBTAMR+hjTmYBhVwss+FBcOEzjcPHzT
         egCQ==
X-Gm-Message-State: AJcUukdPW2a979VDfrwkbHRDoUEN14D57Drl/edKL1KNd2oYCyC3iukc
        +XnRKv+sCgNzvB1TZ0FWF8k=
X-Google-Smtp-Source: ALg8bN78QYDL7o7tAWys1x+bFJlndFbFXr9PHUkCoW3OrmZHFdsg9IHHrJ+vfOFuzdNqNQM2dbbwhg==
X-Received: by 2002:a62:5486:: with SMTP id i128mr14545894pfb.215.1547219273447;
        Fri, 11 Jan 2019 07:07:53 -0800 (PST)
Received: from jordon-HP-15-Notebook-PC ([49.207.52.190])
        by smtp.gmail.com with ESMTPSA id m3sm137912153pff.173.2019.01.11.07.07.51
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 11 Jan 2019 07:07:52 -0800 (PST)
Date:   Fri, 11 Jan 2019 20:41:54 +0530
From:   Souptick Joarder <jrdr.linux@gmail.com>
To:     akpm@linux-foundation.org, willy@infradead.org, mhocko@suse.com,
        pawel@osciak.com, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, mchehab@kernel.org,
        linux@armlinux.org.uk, robin.murphy@arm.com
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 7/9] videobuf2/videobuf2-dma-sg.c: Convert to use
 vm_insert_range_buggy
Message-ID: <20190111151154.GA2819@jordon-HP-15-Notebook-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Convert to use vm_insert_range_buggy to map range of kernel memory
to user vma.

This driver has ignored vm_pgoff. We could later "fix" these drivers
to behave according to the normal vm_pgoff offsetting simply by
removing the _buggy suffix on the function name and if that causes
regressions, it gives us an easy way to revert.

There is an existing bug inside gem_mmap_obj(), where user passed
length is not checked against buf->num_pages. For any value of
length > buf->num_pages it will end up overrun buf->pages[i],
which could lead to a potential bug.

This has been addressed by passing buf->num_pages as input to
vm_insert_range_buggy() and inside this API error condition is
checked which will avoid overrun the page boundary.

Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
---
 drivers/media/common/videobuf2/videobuf2-dma-sg.c | 22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-dma-sg.c b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
index 015e737..ef046b4 100644
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
+	err = vm_insert_range_buggy(vma, buf->pages, buf->num_pages);
+	if (err) {
+		printk(KERN_ERR "Remapping memory, error: %d\n", err);
+		return err;
+	}
 
 	/*
 	 * Use common vm_area operations to track buffer refcount.
-- 
1.9.1

