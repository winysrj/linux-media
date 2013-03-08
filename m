Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:61138 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933734Ab3CHMGg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2013 07:06:36 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MJC007T7CAXJ990@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 08 Mar 2013 12:06:34 +0000 (GMT)
Received: from [127.0.0.1] ([106.116.147.30])
 by eusync3.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0MJC000CRCAWTP20@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Fri, 08 Mar 2013 12:06:33 +0000 (GMT)
Message-id: <5139D448.5030007@samsung.com>
Date: Fri, 08 Mar 2013 13:06:32 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Federico Vaga <federico.vaga@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEW PATCH 2/2] vb2-dma-sg: add debug module option.
References: <1362734517-9420-1-git-send-email-hverkuil@xs4all.nl>
 <552bc620da0483a6bd5a41604759c7f86abfd058.1362734097.git.hans.verkuil@cisco.com>
In-reply-to: <552bc620da0483a6bd5a41604759c7f86abfd058.1362734097.git.hans.verkuil@cisco.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 3/8/2013 10:21 AM, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> This prevents the kernel log from being spammed with these messages.
> By turning on the debug option you will see them again.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>   drivers/media/v4l2-core/videobuf2-dma-sg.c |   17 +++++++++++++----
>   1 file changed, 13 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
> index 952776f..59522b2 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
> @@ -21,6 +21,15 @@
>   #include <media/videobuf2-memops.h>
>   #include <media/videobuf2-dma-sg.h>
>   
> +static int debug;
> +module_param(debug, int, 0644);
> +
> +#define dprintk(level, fmt, arg...)					\
> +	do {								\
> +		if (debug >= level)					\
> +			printk(KERN_DEBUG "vb2-dma-sg: " fmt, ## arg);	\
> +	} while (0)
> +
>   struct vb2_dma_sg_buf {
>   	void				*vaddr;
>   	struct page			**pages;
> @@ -74,7 +83,7 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size, gfp_t gfp_fla
>   
>   	atomic_inc(&buf->refcount);
>   
> -	printk(KERN_DEBUG "%s: Allocated buffer of %d pages\n",
> +	dprintk(1, "%s: Allocated buffer of %d pages\n",
>   		__func__, buf->sg_desc.num_pages);
>   	return buf;
>   
> @@ -97,7 +106,7 @@ static void vb2_dma_sg_put(void *buf_priv)
>   	int i = buf->sg_desc.num_pages;
>   
>   	if (atomic_dec_and_test(&buf->refcount)) {
> -		printk(KERN_DEBUG "%s: Freeing buffer of %d pages\n", __func__,
> +		dprintk(1, "%s: Freeing buffer of %d pages\n", __func__,
>   			buf->sg_desc.num_pages);
>   		if (buf->vaddr)
>   			vm_unmap_ram(buf->vaddr, buf->sg_desc.num_pages);
> @@ -163,7 +172,7 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
>   	return buf;
>   
>   userptr_fail_get_user_pages:
> -	printk(KERN_DEBUG "get_user_pages requested/got: %d/%d]\n",
> +	dprintk(1, "get_user_pages requested/got: %d/%d]\n",
>   	       num_pages_from_user, buf->sg_desc.num_pages);
>   	while (--num_pages_from_user >= 0)
>   		put_page(buf->pages[num_pages_from_user]);
> @@ -186,7 +195,7 @@ static void vb2_dma_sg_put_userptr(void *buf_priv)
>   	struct vb2_dma_sg_buf *buf = buf_priv;
>   	int i = buf->sg_desc.num_pages;
>   
> -	printk(KERN_DEBUG "%s: Releasing userspace buffer of %d pages\n",
> +	dprintk(1, "%s: Releasing userspace buffer of %d pages\n",
>   	       __func__, buf->sg_desc.num_pages);
>   	if (buf->vaddr)
>   		vm_unmap_ram(buf->vaddr, buf->sg_desc.num_pages);

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


