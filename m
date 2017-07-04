Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:22583 "EHLO
        mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750798AbdGDFW5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Jul 2017 01:22:57 -0400
Subject: Re: [PATCH] media: vb2 dma-contig: Constify dma_buf_ops structures.
To: Arvind Yadav <arvind.yadav.cs@gmail.com>, pawel@osciak.com,
        kyungmin.park@samsung.com, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <9a4bfebf-ae9a-1e61-dca5-8b75709bca0e@samsung.com>
Date: Tue, 04 Jul 2017 07:22:51 +0200
MIME-version: 1.0
In-reply-to: <f1403ce121c467e3c6fb33ead41ff665985a431f.1498908191.git.arvind.yadav.cs@gmail.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
Content-language: en-US
References: <CGME20170701112725epcas2p2cc872b30a61c564bf88a3da063811c9a@epcas2p2.samsung.com>
 <f1403ce121c467e3c6fb33ead41ff665985a431f.1498908191.git.arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arvind,

On 2017-07-01 13:27, Arvind Yadav wrote:
> dma_buf_ops are not supposed to change at runtime. All functions
> working with dma_buf_ops provided by <linux/dma-buf.h> work with
> const dma_buf_ops. So mark the non-const structs as const.
>
> File size before:
>     text	   data	    bss	    dec	    hex	filename
>     6035	    272	      0	   6307	   18a3 drivers/media/v4l2-core/videobuf2-dma-contig.o
>
> File size After adding 'const':
>     text	   data	    bss	    dec	    hex	filename
>     6155	    160	      0	   6315	   18ab drivers/media/v4l2-core/videobuf2-dma-contig.o
>
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>

Thanks!
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>   drivers/media/v4l2-core/videobuf2-dma-contig.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> index 4f246d1..5b90a66 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> @@ -352,7 +352,7 @@ static int vb2_dc_dmabuf_ops_mmap(struct dma_buf *dbuf,
>   	return vb2_dc_mmap(dbuf->priv, vma);
>   }
>   
> -static struct dma_buf_ops vb2_dc_dmabuf_ops = {
> +static const struct dma_buf_ops vb2_dc_dmabuf_ops = {
>   	.attach = vb2_dc_dmabuf_ops_attach,
>   	.detach = vb2_dc_dmabuf_ops_detach,
>   	.map_dma_buf = vb2_dc_dmabuf_ops_map,

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland
