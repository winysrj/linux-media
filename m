Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:25357 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab2KLPvU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Nov 2012 10:51:20 -0500
Received: from eusync4.samsung.com (mailout4.w1.samsung.com [210.118.77.14])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MDD00EDWTEDB720@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 12 Nov 2012 15:51:49 +0000 (GMT)
Received: from AMDN910 ([106.116.147.102])
 by eusync4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MDD006BATDB2Z20@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 12 Nov 2012 15:51:17 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'Arun Kumar K' <arunkk.samsung@gmail.com>
Cc: linux-media@vger.kernel.org, jtp.park@samsung.com,
	arun.kk@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'sunil joshi' <joshi@samsung.com>
References: <1351088137-11472-1-git-send-email-k.debski@samsung.com>
 <1351088137-11472-4-git-send-email-k.debski@samsung.com>
 <CALt3h7_2k0W6ZutaPFn=L0pQVALD9OtrS1m=Bjw-Zn0Q3q05Ww@mail.gmail.com>
In-reply-to: <CALt3h7_2k0W6ZutaPFn=L0pQVALD9OtrS1m=Bjw-Zn0Q3q05Ww@mail.gmail.com>
Subject: RE: [PATCH 4/4] s5p-mfc: Change internal buffer allocation from vb2
 ops to dma_alloc_coherent
Date: Mon, 12 Nov 2012 16:51:11 +0100
Message-id: <000001cdc0ed$8b727a50$a2576ef0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun, 

Thank you very much for this bug report. This is indeed a mistake on my
side. I will prepare a patch to fix it.

Best wishes,
-- 
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center

> From: Arun Kumar K [mailto:arunkk.samsung@gmail.com]
> Sent: Saturday, November 03, 2012 10:21 AM
> 
> Hi Kamil,
> 
> I found an issue while testing this patch on Exynos4.
> 
> 
> On Wed, Oct 24, 2012 at 7:45 PM, Kamil Debski <k.debski@samsung.com>
> wrote:
> > Change internal buffer allocation from vb2 memory ops call to direct
> > calls of dma_alloc_coherent. This change shortens the code and makes
> > it much more readable.
> >
> > Signed-off-by: Kamil Debski <k.debski@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  drivers/media/platform/s5p-mfc/s5p_mfc_common.h |   20 +--
> >  drivers/media/platform/s5p-mfc/s5p_mfc_opr.c    |   30 ++++
> >  drivers/media/platform/s5p-mfc/s5p_mfc_opr.h    |    5 +
> >  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c |  198
> > ++++++++---------------
> > drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |  121 +++++---------
> >  5 files changed, 144 insertions(+), 230 deletions(-)
> >
> 
> [snip]
> 
> >  /* Allocate memory for instance data buffer */ @@ -233,58 +204,38 @@
> > int s5p_mfc_alloc_instance_buffer_v5(struct s5p_mfc_ctx *ctx)  {
> >         struct s5p_mfc_dev *dev = ctx->dev;
> >         struct s5p_mfc_buf_size_v5 *buf_size =
> > dev->variant->buf_size->priv;
> > +       int ret;
> >
> >         if (ctx->codec_mode == S5P_MFC_CODEC_H264_DEC ||
> >                 ctx->codec_mode == S5P_MFC_CODEC_H264_ENC)
> >                 ctx->ctx.size = buf_size->h264_ctx;
> >         else
> >                 ctx->ctx.size = buf_size->non_h264_ctx;
> > -       ctx->ctx.alloc = vb2_dma_contig_memops.alloc(
> > -               dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->ctx.size);
> > -       if (IS_ERR(ctx->ctx.alloc)) {
> > -               mfc_err("Allocating context buffer failed\n");
> > -               ctx->ctx.alloc = NULL;
> > -               return -ENOMEM;
> > -       }
> > -       ctx->ctx.dma = s5p_mfc_mem_cookie(
> > -               dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->ctx.alloc);
> > -       BUG_ON(ctx->ctx.dma & ((1 << MFC_BANK1_ALIGN_ORDER) - 1));
> > -       ctx->ctx.ofs = OFFSETA(ctx->ctx.dma);
> > -       ctx->ctx.virt = vb2_dma_contig_memops.vaddr(ctx->ctx.alloc);
> > -       if (!ctx->ctx.virt) {
> > -               mfc_err("Remapping instance buffer failed\n");
> > -               vb2_dma_contig_memops.put(ctx->ctx.alloc);
> > -               ctx->ctx.alloc = NULL;
> > -               ctx->ctx.ofs = 0;
> > -               ctx->ctx.dma = 0;
> > -               return -ENOMEM;
> > +
> > +       ret = s5p_mfc_alloc_priv_buf(dev->mem_dev_l, &ctx->ctx);
> > +       if (ret) {
> > +               mfc_err("Failed to allocate instance buffer\n");
> > +               return ret;
> >         }
> > +       ctx->ctx.ofs = ctx->ctx.dma - dev->bank1;
> > +
> 
> Here the original code does  ctx->ctx.ofs = OFFSETA(ctx->ctx.dma); The
> macro OFFSETA also does a right shift of MFC_OFFSET_SHIFT.
> Without this change, the decoding is not working on Exynos4.
> 
> 
> >         /* Zero content of the allocated memory */
> >         memset(ctx->ctx.virt, 0, ctx->ctx.size);
> >         wmb();
> >
> 
> 
> All these patches are working well on Exynos5.
> 
> Regards
> Arun


