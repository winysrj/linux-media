Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50901 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab2KTGTU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Nov 2012 01:19:20 -0500
Received: by mail-ob0-f174.google.com with SMTP id wc20so5625049obb.19
        for <linux-media@vger.kernel.org>; Mon, 19 Nov 2012 22:19:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPgLHd9016BFtTFPP7doHpF=eRewCSedj_DTqPHuVpzaxLP=VQ@mail.gmail.com>
References: <CAPgLHd9016BFtTFPP7doHpF=eRewCSedj_DTqPHuVpzaxLP=VQ@mail.gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 20 Nov 2012 11:48:57 +0530
Message-ID: <CA+V-a8uXJ+OOBcD1YP0B=Zj9Zg8=pJ2Bw+3OVSUNoLzQdAAvbQ@mail.gmail.com>
Subject: Re: [PATCH v2] [media] vpif_capture: fix return value check
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: mchehab@infradead.org, yongjun_wei@trendmicro.com.cn,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Wei,

On Thu, Nov 15, 2012 at 6:48 PM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> In case of error, the function vb2_dma_contig_init_ctx() returns
> ERR_PTR() and never returns NULL. The NULL test in the return value
> check should be replaced with IS_ERR().
>
> dpatch engine is used to auto generate this patch.
> (https://github.com/weiyj/dpatch)
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/media/platform/davinci/vpif_display.c | 4 ++--
>  drivers/media/platform/davinci/vpif_capture.c | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
Applied to my tree with following change in commit header,
'davinci: vpif: fix return value check for vb2_dma_contig_init_ctx()'

Regards,
--Prabhakar Lad

> diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
> index b716fbd..5453bbb 100644
> --- a/drivers/media/platform/davinci/vpif_display.c
> +++ b/drivers/media/platform/davinci/vpif_display.c
> @@ -972,9 +972,9 @@ static int vpif_reqbufs(struct file *file, void *priv,
>         }
>         /* Initialize videobuf2 queue as per the buffer type */
>         common->alloc_ctx = vb2_dma_contig_init_ctx(vpif_dev);
> -       if (!common->alloc_ctx) {
> +       if (IS_ERR(common->alloc_ctx)) {
>                 vpif_err("Failed to get the context\n");
> -               return -EINVAL;
> +               return PTR_ERR(common->alloc_ctx);
>         }
>         q = &common->buffer_queue;
>         q->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
>
> diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
> index fcabc02..9746324 100644
> --- a/drivers/media/platform/davinci/vpif_capture.c
> +++ b/drivers/media/platform/davinci/vpif_capture.c
> @@ -1004,9 +1004,9 @@ static int vpif_reqbufs(struct file *file, void *priv,
>
>         /* Initialize videobuf2 queue as per the buffer type */
>         common->alloc_ctx = vb2_dma_contig_init_ctx(vpif_dev);
> -       if (!common->alloc_ctx) {
> +       if (IS_ERR(common->alloc_ctx)) {
>                 vpif_err("Failed to get the context\n");
> -               return -EINVAL;
> +               return PTR_ERR(common->alloc_ctx);
>         }
>         q = &common->buffer_queue;
>         q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>
>
