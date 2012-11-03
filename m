Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:53050 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab2KCJUv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Nov 2012 05:20:51 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so6068561iea.19
        for <linux-media@vger.kernel.org>; Sat, 03 Nov 2012 02:20:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1351088137-11472-4-git-send-email-k.debski@samsung.com>
References: <1351088137-11472-1-git-send-email-k.debski@samsung.com>
	<1351088137-11472-4-git-send-email-k.debski@samsung.com>
Date: Sat, 3 Nov 2012 14:50:51 +0530
Message-ID: <CALt3h7_2k0W6ZutaPFn=L0pQVALD9OtrS1m=Bjw-Zn0Q3q05Ww@mail.gmail.com>
Subject: Re: [PATCH 4/4] s5p-mfc: Change internal buffer allocation from vb2
 ops to dma_alloc_coherent
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-media@vger.kernel.org, jtp.park@samsung.com,
	arun.kk@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>,
	sunil joshi <joshi@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

I found an issue while testing this patch on Exynos4.


On Wed, Oct 24, 2012 at 7:45 PM, Kamil Debski <k.debski@samsung.com> wrote:
> Change internal buffer allocation from vb2 memory ops call to direct
> calls of dma_alloc_coherent. This change shortens the code and makes it
> much more readable.
>
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc_common.h |   20 +--
>  drivers/media/platform/s5p-mfc/s5p_mfc_opr.c    |   30 ++++
>  drivers/media/platform/s5p-mfc/s5p_mfc_opr.h    |    5 +
>  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c |  198 ++++++++---------------
>  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |  121 +++++---------
>  5 files changed, 144 insertions(+), 230 deletions(-)
>

[snip]

>  /* Allocate memory for instance data buffer */
> @@ -233,58 +204,38 @@ int s5p_mfc_alloc_instance_buffer_v5(struct s5p_mfc_ctx *ctx)
>  {
>         struct s5p_mfc_dev *dev = ctx->dev;
>         struct s5p_mfc_buf_size_v5 *buf_size = dev->variant->buf_size->priv;
> +       int ret;
>
>         if (ctx->codec_mode == S5P_MFC_CODEC_H264_DEC ||
>                 ctx->codec_mode == S5P_MFC_CODEC_H264_ENC)
>                 ctx->ctx.size = buf_size->h264_ctx;
>         else
>                 ctx->ctx.size = buf_size->non_h264_ctx;
> -       ctx->ctx.alloc = vb2_dma_contig_memops.alloc(
> -               dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->ctx.size);
> -       if (IS_ERR(ctx->ctx.alloc)) {
> -               mfc_err("Allocating context buffer failed\n");
> -               ctx->ctx.alloc = NULL;
> -               return -ENOMEM;
> -       }
> -       ctx->ctx.dma = s5p_mfc_mem_cookie(
> -               dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->ctx.alloc);
> -       BUG_ON(ctx->ctx.dma & ((1 << MFC_BANK1_ALIGN_ORDER) - 1));
> -       ctx->ctx.ofs = OFFSETA(ctx->ctx.dma);
> -       ctx->ctx.virt = vb2_dma_contig_memops.vaddr(ctx->ctx.alloc);
> -       if (!ctx->ctx.virt) {
> -               mfc_err("Remapping instance buffer failed\n");
> -               vb2_dma_contig_memops.put(ctx->ctx.alloc);
> -               ctx->ctx.alloc = NULL;
> -               ctx->ctx.ofs = 0;
> -               ctx->ctx.dma = 0;
> -               return -ENOMEM;
> +
> +       ret = s5p_mfc_alloc_priv_buf(dev->mem_dev_l, &ctx->ctx);
> +       if (ret) {
> +               mfc_err("Failed to allocate instance buffer\n");
> +               return ret;
>         }
> +       ctx->ctx.ofs = ctx->ctx.dma - dev->bank1;
> +

Here the original code does  ctx->ctx.ofs = OFFSETA(ctx->ctx.dma);
The macro OFFSETA also does a right shift of MFC_OFFSET_SHIFT.
Without this change, the decoding is not working on Exynos4.


>         /* Zero content of the allocated memory */
>         memset(ctx->ctx.virt, 0, ctx->ctx.size);
>         wmb();
>


All these patches are working well on Exynos5.

Regards
Arun
