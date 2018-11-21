Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:44837 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728220AbeKUS1q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Nov 2018 13:27:46 -0500
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20181121075417euoutp02300e59d42b4cc032bdacd33d6f9c8507~pFHkO2npq1080410804euoutp02I
        for <linux-media@vger.kernel.org>; Wed, 21 Nov 2018 07:54:17 +0000 (GMT)
Subject: Re: [PATCH 7/9] videobuf2/videobuf2-dma-sg.c: Convert to use
 vm_insert_range
To: Souptick Joarder <jrdr.linux@gmail.com>, akpm@linux-foundation.org,
        willy@infradead.org, mhocko@suse.com, pawel@osciak.com,
        kyungmin.park@samsung.com, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <1c228982-e1c6-a9d5-87ef-1a3206a426f3@samsung.com>
Date: Wed, 21 Nov 2018 08:54:14 +0100
MIME-Version: 1.0
In-Reply-To: <20181115155037.GA28004@jordon-HP-15-Notebook-PC>
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
References: <CGME20181115154713epcas4p1818fa71d5e67c9a73dc75ceda1704ea3@epcas4p1.samsung.com>
        <20181115155037.GA28004@jordon-HP-15-Notebook-PC>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Souptick,

On 2018-11-15 16:50, Souptick Joarder wrote:
> Convert to use vm_insert_range to map range of kernel memory
> to user vma.
>
> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
> Reviewed-by: Matthew Wilcox <willy@infradead.org>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

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

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland
