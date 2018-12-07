Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	T_DKIMWL_WL_HIGH,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40CD3C64EB1
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 14:49:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08B6920882
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 14:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544194149;
	bh=K12MMPcMWeYbG7HVT5IgafZhSJGPYUd03VAfkWhEFmY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=JUHw6N66gI9rw+zk9x7ICpF5pidQ0cTF+cLy6MrWSsMcazVdaUKZlu0EV7i/yfnWZ
	 cq1DQJGYt7tqz9y2/lh4yhF4Fv1O/YKjUVc7qp9gFYzT9PyN1MQcjDTpNgOFZJyBzB
	 /w5/RGKcgXLnI98HnIbF9sbzNIyWszF7MqeqqiHA=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 08B6920882
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbeLGOtD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 09:49:03 -0500
Received: from casper.infradead.org ([85.118.1.10]:36596 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725998AbeLGOtD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 09:49:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=AkB0bsiH0OvOq6MNya7nH1YWvCNDfiGzj5SyoEeldGQ=; b=tIeIdANyloOtPQhMGwbkZjnk4o
        yiwuxXqJljA5vEXK9Ao4obGg3E8W4tKWnpRTW6F5dHsR0LgJRVJ/ntAT1bvSshkvHvOZF11l8mTFo
        Pjw0WyyPc51uayUcbxLZiUDXyEW6ATkYEkc5tiHo3lRiwlojBxCQtIcR7ePMNzxxv6i2ieTSwUdeP
        1I+7uw3uw6msN98Vx2d5aoMu2JIdecaIhlKTWsDhMgQz37oeSpHOAW1ugqcV0fh3qly57zUcjj1qa
        MRg2QzypqZz/mxnolaJCWKCIcjzID+2nT35B5dQfouNmvSmL2i0QaBSWT5ELbqaQsd0U54Lvev+ic
        sqY0W4Cg==;
Received: from [179.95.33.236] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gVHR2-0005dK-Oj; Fri, 07 Dec 2018 14:48:57 +0000
Date:   Fri, 7 Dec 2018 12:48:51 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Souptick Joarder <jrdr.linux@gmail.com>
Cc:     akpm@linux-foundation.org, willy@infradead.org, mhocko@suse.com,
        pawel@osciak.com, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 7/9] videobuf2/videobuf2-dma-sg.c: Convert to use
 vm_insert_range
Message-ID: <20181207124851.3eef28a0@coco.lan>
In-Reply-To: <20181206184438.GA31370@jordon-HP-15-Notebook-PC>
References: <20181206184438.GA31370@jordon-HP-15-Notebook-PC>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Fri, 7 Dec 2018 00:14:38 +0530
Souptick Joarder <jrdr.linux@gmail.com> escreveu:

> Convert to use vm_insert_range to map range of kernel memory
> to user vma.
> 
> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
> Reviewed-by: Matthew Wilcox <willy@infradead.org>
> Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

It probably makes sense to apply it via mm tree, together with
patch 1. So:

Acked-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

> ---
>  drivers/media/common/videobuf2/videobuf2-dma-sg.c | 23 +++++++----------------
>  1 file changed, 7 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/media/common/videobuf2/videobuf2-dma-sg.c b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
> index 015e737..898adef 100644
> --- a/drivers/media/common/videobuf2/videobuf2-dma-sg.c
> +++ b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
> @@ -328,28 +328,19 @@ static unsigned int vb2_dma_sg_num_users(void *buf_priv)
>  static int vb2_dma_sg_mmap(void *buf_priv, struct vm_area_struct *vma)
>  {
>  	struct vb2_dma_sg_buf *buf = buf_priv;
> -	unsigned long uaddr = vma->vm_start;
> -	unsigned long usize = vma->vm_end - vma->vm_start;
> -	int i = 0;
> +	unsigned long page_count = vma_pages(vma);
> +	int err;
>  
>  	if (!buf) {
>  		printk(KERN_ERR "No memory to map\n");
>  		return -EINVAL;
>  	}
>  
> -	do {
> -		int ret;
> -
> -		ret = vm_insert_page(vma, uaddr, buf->pages[i++]);
> -		if (ret) {
> -			printk(KERN_ERR "Remapping memory, error: %d\n", ret);
> -			return ret;
> -		}
> -
> -		uaddr += PAGE_SIZE;
> -		usize -= PAGE_SIZE;
> -	} while (usize > 0);
> -
> +	err = vm_insert_range(vma, vma->vm_start, buf->pages, page_count);
> +	if (err) {
> +		printk(KERN_ERR "Remapping memory, error: %d\n", err);
> +		return err;
> +	}
>  
>  	/*
>  	 * Use common vm_area operations to track buffer refcount.



Thanks,
Mauro
