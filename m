Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:34314 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751734AbdGDFXj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Jul 2017 01:23:39 -0400
Subject: Re: [PATCH] media: vb2 dma-sg: Constify dma_buf_ops structures.
To: Arvind Yadav <arvind.yadav.cs@gmail.com>, pawel@osciak.com,
        kyungmin.park@samsung.com, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <4d31db73-824e-6ddd-ac01-eaa1be8b327f@samsung.com>
Date: Tue, 04 Jul 2017 07:23:30 +0200
MIME-version: 1.0
In-reply-to: <568fa73b15a4fead5ee803b9c38b47c374c91314.1498909383.git.arvind.yadav.cs@gmail.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
Content-language: en-US
References: <CGME20170701121836epcas4p10697c89a407bd22152d3e31a967b5b90@epcas4p1.samsung.com>
 <568fa73b15a4fead5ee803b9c38b47c374c91314.1498909383.git.arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arvind,

On 2017-07-01 14:18, Arvind Yadav wrote:
> dma_buf_ops are not supposed to change at runtime. All functions
> working with dma_buf_ops provided by <linux/dma-buf.h> work with
> const dma_buf_ops. So mark the non-const structs as const.
>
> File size before:
>     text	   data	    bss	    dec	    hex	filename
>     5238	    112	      4	   5354	   14ea drivers/media/v4l2-core/videobuf2-dma-sg.o
>
> File size After adding 'const':
>     text	   data	    bss	    dec	    hex	filename
>     5358	      0	      4	   5362	   14f2 drivers/media/v4l2-core/videobuf2-dma-sg.o
>
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>   drivers/media/v4l2-core/videobuf2-dma-sg.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
> index 8e8798a..f8b4643 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
> @@ -500,7 +500,7 @@ static int vb2_dma_sg_dmabuf_ops_mmap(struct dma_buf *dbuf,
>   	return vb2_dma_sg_mmap(dbuf->priv, vma);
>   }
>   
> -static struct dma_buf_ops vb2_dma_sg_dmabuf_ops = {
> +static const struct dma_buf_ops vb2_dma_sg_dmabuf_ops = {
>   	.attach = vb2_dma_sg_dmabuf_ops_attach,
>   	.detach = vb2_dma_sg_dmabuf_ops_detach,
>   	.map_dma_buf = vb2_dma_sg_dmabuf_ops_map,

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland
