Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:15949 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751986AbdGDFXP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Jul 2017 01:23:15 -0400
Subject: Re: [PATCH] media: vb2 vmalloc: Constify dma_buf_ops structures.
To: Arvind Yadav <arvind.yadav.cs@gmail.com>, pawel@osciak.com,
        kyungmin.park@samsung.com, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <5208880e-b283-d9d0-ee6b-cd4b3dcef504@samsung.com>
Date: Tue, 04 Jul 2017 07:23:09 +0200
MIME-version: 1.0
In-reply-to: <bb06167b83b6241201c2adc12b2b18b212078762.1498908989.git.arvind.yadav.cs@gmail.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
Content-language: en-US
References: <CGME20170701113746epcas3p3f76bbf5988c9d31e3a781c6b0efd8e08@epcas3p3.samsung.com>
 <bb06167b83b6241201c2adc12b2b18b212078762.1498908989.git.arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arvind,

On 2017-07-01 13:37, Arvind Yadav wrote:
> dma_buf_ops are not supposed to change at runtime. All functions
> working with dma_buf_ops provided by <linux/dma-buf.h> work with
> const dma_buf_ops. So mark the non-const structs as const.
>
> File size before:
>     text	   data	    bss	    dec	    hex	filename
>     3171	    192	      0	   3363	    d23 drivers/media/v4l2-core/videobuf2-vmalloc.o
>
> File size After adding 'const':
>     text	   data	    bss	    dec	    hex	filename
>     3291	     80	      0	   3371	    d2b drivers/media/v4l2-core/videobuf2-vmalloc.o
>
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>   drivers/media/v4l2-core/videobuf2-vmalloc.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
> index b337d78..6bc130f 100644
> --- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
> +++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
> @@ -338,7 +338,7 @@ static int vb2_vmalloc_dmabuf_ops_mmap(struct dma_buf *dbuf,
>   	return vb2_vmalloc_mmap(dbuf->priv, vma);
>   }
>   
> -static struct dma_buf_ops vb2_vmalloc_dmabuf_ops = {
> +static const struct dma_buf_ops vb2_vmalloc_dmabuf_ops = {
>   	.attach = vb2_vmalloc_dmabuf_ops_attach,
>   	.detach = vb2_vmalloc_dmabuf_ops_detach,
>   	.map_dma_buf = vb2_vmalloc_dmabuf_ops_map,

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland
