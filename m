Return-Path: <SRS0=3Wpa=PB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5C85C43612
	for <linux-media@archiver.kernel.org>; Mon, 24 Dec 2018 13:23:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92C3C21850
	for <linux-media@archiver.kernel.org>; Mon, 24 Dec 2018 13:23:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OUe2UBaI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725616AbeLXNXI (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 24 Dec 2018 08:23:08 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:46481 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbeLXNXH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Dec 2018 08:23:07 -0500
Received: by mail-pl1-f195.google.com with SMTP id t13so5582885ply.13;
        Mon, 24 Dec 2018 05:23:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=7Lxrxd/hSsekQvS5TNwgf4HJhjrgrc3uztzkOk3jJZI=;
        b=OUe2UBaIajVgiHJLICEiDaRmhg9kLK9hiO8qJEaN4rrxoH7k50qgnl6Wl+XySZ6A83
         K1F8jaG9lYHSpu0zG42YwEpn+3YVl83fnNiLu4sAHKartC0Io7zN3jOBUYys/J2s1DAZ
         b0PemUtLvUPsZJ5WxS7a2Km1y+FbdYwd8Vqu1nOnq7zc0AYFm2cvML/bPUIVJE6z7kYI
         AarkWAB0WEA5VKCBss7dFq5ZPZq2mCmrnovbMMEXL5zRYsntVdEdUqvwab2ix4w5+GaZ
         lufgucxKqEtCZUxR5YLGIYS/gi5CtHr7q3PFICiRvdOSX2NGp352oE4H40jHM582Ec4m
         GYGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=7Lxrxd/hSsekQvS5TNwgf4HJhjrgrc3uztzkOk3jJZI=;
        b=PCucv21HikOWUUaRvnY/vdeZrPYEEbOwhYn3gPGq17Dp56cmLiMoCDt6VcpW//9YTB
         pxyGlTp7FcvjmmvsbPP/68SF/nG2Hb4AGGky3UE6cCL2zGywwCTU7iXRBq8mNcfN1wLW
         8WRWQw1bjXyTx/QAsASDiY4JsnMe4GDRQV7Ir0nmaCMz30f6Mq9s2KwUOr/+562g9ZEK
         FpF+AKTCR9yWVsZ+Otz2LIATEHmaB6Lm5M5KwV0EMgkQb6dT+joUhYFUZ2nhzWAb5g1c
         YHLlmrWPRtJunO3/tCBDPQaMXxRHtHTsIEwQ0UBawpN+bybYGoM65HS8J+/94HgN8AAc
         CG1g==
X-Gm-Message-State: AJcUukdr4lEFqaAN14kxDwrbIFf+sxXF9Xlqs1G9N6Z9ymTESXP16Bfk
        AFf4gM2z8b/SUYO/VaMOgN0=
X-Google-Smtp-Source: ALg8bN5kc/0nicwedA6pXaMV79OMWDwnVCptGPVVG8nZTTXxzJdQVTtTwoK88u8a5GB5BsbXczYDpg==
X-Received: by 2002:a17:902:4401:: with SMTP id k1mr13003110pld.307.1545657786489;
        Mon, 24 Dec 2018 05:23:06 -0800 (PST)
Received: from jordon-HP-15-Notebook-PC ([106.51.18.181])
        by smtp.gmail.com with ESMTPSA id x3sm101409071pgt.45.2018.12.24.05.23.05
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 24 Dec 2018 05:23:05 -0800 (PST)
Date:   Mon, 24 Dec 2018 18:56:58 +0530
From:   Souptick Joarder <jrdr.linux@gmail.com>
To:     akpm@linux-foundation.org, willy@infradead.org, mhocko@suse.com,
        pawel@osciak.com, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, mchehab@kernel.org,
        linux@armlinux.org.uk, robin.murphy@arm.com
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH v5 7/9] videobuf2/videobuf2-dma-sg.c: Convert to use
 vm_insert_range
Message-ID: <20181224132658.GA22166@jordon-HP-15-Notebook-PC>
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

