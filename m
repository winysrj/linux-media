Return-Path: <SRS0=gTyh=QH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BA69C282D7
	for <linux-media@archiver.kernel.org>; Thu, 31 Jan 2019 03:08:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0053218AF
	for <linux-media@archiver.kernel.org>; Thu, 31 Jan 2019 03:08:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SG69jAFW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbfAaDI6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 30 Jan 2019 22:08:58 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42240 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfAaDI6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Jan 2019 22:08:58 -0500
Received: by mail-pf1-f194.google.com with SMTP id 64so796340pfr.9;
        Wed, 30 Jan 2019 19:08:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=Tzx3LuiHGu0SmZBCm6CzEP8w3yWGAsFNft5HC8mJptk=;
        b=SG69jAFWv9k676t5Utk2gi92q1MDmHsVmo9rCodROneHhYXHplReVP4hK21q9ZSSdJ
         RGncSYRSEs/W1L1/StjwpPDMTybrv+LaScrb0dgFli86JHAb+ZvmK7Q9Iwh/ssL7z5Nv
         X4uy7Yx8WOhMaeQ77IARCYOHnfQH8M6zkiwP/Q6CDQPO6tcY6kmBCcVTpzkicbex69th
         RrY0lKFiIHCLHP688fJAUf1WYbeRrGewAMPqEJw97RtPW92QJbenm+0lXapHvHz2vUPv
         rUJvWxMIx2HP9Vce5UBolKP99JgNaPXftPkSjO4xHvv5B5ZVZh66H+/2aGfQn2pReoki
         Mhfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=Tzx3LuiHGu0SmZBCm6CzEP8w3yWGAsFNft5HC8mJptk=;
        b=aLYhvbgnP565cTBHCMXJG8diS62zK68VXpsxPVVHSlBo7jyQX4NEsQm3yIE8yQin93
         rL7FSx2IoKfkrPmsdzv9OaO7aFlZj3mk/G355J5zVndTXKGGlFjMHe/uN+EkpxfToGa2
         IqbQkwy01ArGhI1P97xY8vPmxmKoCRgiwLd/Lv5gHMrLpVobMznjyt0RzmdcZuKcIYbQ
         t3mN/2HatwIPYPmDNa1leoAemw8XOaZurTIHhMTvn/25ojU8B3xnnyPxIgnL7b/WseN8
         7IPUVWg2ey0QIPFZyGvk4zRa79UK9igT6RWHg4zhZp3I0gNbJ3wminNGDVhy+H05XcWu
         HRUQ==
X-Gm-Message-State: AJcUukd7cypKHp3MYKfN/cDtBTxeRl6ZAu9qH/W6DeOcDUuWdl79YXlU
        8THVpDzGxYn+rfBooyClS1Ksz648
X-Google-Smtp-Source: ALg8bN7wb56H8hJb2G48KSsDY4hb0Py0IT0EIwedsatXj+1qF8yXTAAiJvDNvKT576zum6yE4XESSQ==
X-Received: by 2002:a62:8096:: with SMTP id j144mr33611222pfd.140.1548904137581;
        Wed, 30 Jan 2019 19:08:57 -0800 (PST)
Received: from jordon-HP-15-Notebook-PC ([106.51.20.103])
        by smtp.gmail.com with ESMTPSA id o189sm5265306pfg.117.2019.01.30.19.08.56
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 30 Jan 2019 19:08:56 -0800 (PST)
Date:   Thu, 31 Jan 2019 08:43:10 +0530
From:   Souptick Joarder <jrdr.linux@gmail.com>
To:     akpm@linux-foundation.org, willy@infradead.org, mhocko@suse.com,
        pawel@osciak.com, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, mchehab@kernel.org,
        linux@armlinux.org.uk, robin.murphy@arm.com
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCHv2 7/9] videobuf2/videobuf2-dma-sg.c: Convert to use
 vm_insert_range
Message-ID: <20190131031310.GA2372@jordon-HP-15-Notebook-PC>
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

vm_pgoff is treated in V4L2 API as a 'cookie' to select a buffer,
not as a in-buffer offset by design and it always want to mmap a
whole buffer from its beginning.

Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
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
index 015e737..a800200 100644
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
+	err = vm_insert_range(vma, buf->pages, buf->num_pages);
+	if (err) {
+		printk(KERN_ERR "Remapping memory, error: %d\n", err);
+		return err;
+	}
 
 	/*
 	 * Use common vm_area operations to track buffer refcount.
-- 
1.9.1

