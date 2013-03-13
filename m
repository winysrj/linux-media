Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:19751 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932656Ab3CMPyV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Mar 2013 11:54:21 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MJL00M7HW5S50D0@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 13 Mar 2013 15:54:18 +0000 (GMT)
Received: from [127.0.0.1] ([106.116.147.30])
 by eusync2.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0MJL00F8MW6HU670@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 13 Mar 2013 15:54:18 +0000 (GMT)
Message-id: <5140A129.2080500@samsung.com>
Date: Wed, 13 Mar 2013 16:54:17 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Scott Jiang <scott.jiang.linux@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] dma-mapping: enable no mmu support in
 dma_common_mmap
References: <1362526811-15768-1-git-send-email-scott.jiang.linux@gmail.com>
In-reply-to: <1362526811-15768-1-git-send-email-scott.jiang.linux@gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 3/6/2013 12:40 AM, Scott Jiang wrote:
> No MMU systems also make use of this function to do mmap.
>
> Signed-off-by: Scott Jiang <scott.jiang.linux@gmail.com>
> ---
>   drivers/base/dma-mapping.c |    2 --
>   1 files changed, 0 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/base/dma-mapping.c b/drivers/base/dma-mapping.c
> index 0ce39a3..ae655b2 100644
> --- a/drivers/base/dma-mapping.c
> +++ b/drivers/base/dma-mapping.c
> @@ -245,7 +245,6 @@ int dma_common_mmap(struct device *dev, struct vm_area_struct *vma,
>   		    void *cpu_addr, dma_addr_t dma_addr, size_t size)
>   {
>   	int ret = -ENXIO;
> -#ifdef CONFIG_MMU
>   	unsigned long user_count = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
>   	unsigned long count = PAGE_ALIGN(size) >> PAGE_SHIFT;
>   	unsigned long pfn = page_to_pfn(virt_to_page(cpu_addr));
> @@ -262,7 +261,6 @@ int dma_common_mmap(struct device *dev, struct vm_area_struct *vma,
>   				      user_count << PAGE_SHIFT,
>   				      vma->vm_page_prot);
>   	}
> -#endif	/* CONFIG_MMU */
>   
>   	return ret;
>   }

I really have no experience with NO-MMU kernels, could you explain a bit 
more how this
is useful for handling mmap on such systems? How remap_pfn_range() is 
handled on no-mmu
systems?

I've thought that mmap on no-mmu systems is silently replaced by a call to
get_unmapped_area(), but it looks that there is still a call to mmap 
function.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


