Return-Path: <SRS0=E4aF=O2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36BD5C43387
	for <linux-media@archiver.kernel.org>; Mon, 17 Dec 2018 20:21:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04AFD214D8
	for <linux-media@archiver.kernel.org>; Mon, 17 Dec 2018 20:21:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fS++sl+t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733054AbeLQUVl (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 17 Dec 2018 15:21:41 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:42903 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727631AbeLQUVl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Dec 2018 15:21:41 -0500
Received: by mail-pl1-f196.google.com with SMTP id y1so6643004plp.9;
        Mon, 17 Dec 2018 12:21:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=7Lxrxd/hSsekQvS5TNwgf4HJhjrgrc3uztzkOk3jJZI=;
        b=fS++sl+twua6rKfaqnifxpd414nSQn99YleFwG5ROoUgd4fYh8Gmfgnu5BfX+RGaXQ
         W9G3f2kmTXon3rFlZopX1f9SUhlISoKyouj9dqGZXzclbN7QgFLO8yz0spFId1MRH3O5
         dGA4VWecIWUpsE/4lHE5tobsIZ8xLbEqIhVGe/tL0rrjK2CyWS7ZWFSx+xa8g7xLlthx
         wZs43S1vMMZKIXGIlh0lDrppYZtrUiPm7z4IHL71pM/rBdWYIVldpxLF2JHDfKcVKJO5
         wQsiKO1oXc2bh3EO8jiOZ2RjNYhyAoO4biwb3t7UFifUoPLKwKkPvbQjI/EIHMCS7gST
         uHEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=7Lxrxd/hSsekQvS5TNwgf4HJhjrgrc3uztzkOk3jJZI=;
        b=V5byIZAxQNLRXW3nfyO/bFoWUcg5F8z+KuogW48bsqIA58TSxapOtDcGQaZ5LUd4t6
         Z6PBcFnt65+bYr1PElzPWGbYdLA8TKNmJm1uis/FNp08CE8yGxJ8K7Yo4J3PDBXYai74
         wsVIPi1wMXZHBuuvtlzy+Q2axqgWPTPNo2SIMcsnu4rGrHwO5VW8CXxT7EhAWdvLwtTj
         UPTenO0fhSveP1zmKgyaCFy5jNXRDwpVO/Z/XmD5yKqHvJItnAPqSY7zjLpsH2iZt6F6
         hygrlCY5UqL9DUFaiDv3LJZVpkaM52uko9vbUfJp46AEXfr2JtqrAxpjTQ+3ovG9lmV+
         PFug==
X-Gm-Message-State: AA+aEWbL57/37HZekJI2/Xk3my9GdYghDtHwclcp7piLMiwdW5n1/Pot
        Nmgcx9ffNJ8P9PxBjyTmkFk=
X-Google-Smtp-Source: AFSGD/V108bv8qZyoC/yKMg096p+d0DPNRePsdoNXHX5jjToTByi5PogOU3Xk9s+Qh/1UrG/nUuFKA==
X-Received: by 2002:a17:902:d202:: with SMTP id t2mr14094133ply.193.1545078100797;
        Mon, 17 Dec 2018 12:21:40 -0800 (PST)
Received: from jordon-HP-15-Notebook-PC ([103.227.98.208])
        by smtp.gmail.com with ESMTPSA id i62sm14879081pge.44.2018.12.17.12.21.39
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 17 Dec 2018 12:21:40 -0800 (PST)
Date:   Tue, 18 Dec 2018 01:55:33 +0530
From:   Souptick Joarder <jrdr.linux@gmail.com>
To:     akpm@linux-foundation.org, willy@infradead.org, mhocko@suse.com,
        pawel@osciak.com, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, mchehab@kernel.org
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH v4 7/9] videobuf2/videobuf2-dma-sg.c: Convert to use
 vm_insert_range
Message-ID: <20181217202533.GA16294@jordon-HP-15-Notebook-PC>
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
Acked-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
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

