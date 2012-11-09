Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:63736 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab2KIMeP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Nov 2012 07:34:15 -0500
Received: by mail-oa0-f46.google.com with SMTP id h16so3961140oag.19
        for <linux-media@vger.kernel.org>; Fri, 09 Nov 2012 04:34:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPgLHd-ivjzSDre+DMVK+mHNpNynoLWJXK36zGW5GRnU0Z4d3g@mail.gmail.com>
References: <CAPgLHd-ivjzSDre+DMVK+mHNpNynoLWJXK36zGW5GRnU0Z4d3g@mail.gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 9 Nov 2012 18:03:54 +0530
Message-ID: <CA+V-a8vDjbmY-+c-aaaEcJ4JXv7Dm_ytUzGPD0eDDe_utB7kxQ@mail.gmail.com>
Subject: Re: [PATCH] [media] vpif_display: fix return value check in vpif_reqbufs()
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: mchehab@infradead.org, yongjun_wei@trendmicro.com.cn,
	linux-media@vger.kernel.org,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Wei,

Thanks for the patch.

On Wed, Oct 24, 2012 at 4:59 PM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
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
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
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

Right check would be IS_ERR_OR_NULL(). Can you merge this
patch 'vpif_capture: fix return value check in vpif_reqbufs()' with
this one  and post a v2 with above changes ?

Regards,
--Prabhakar Lad

>                 vpif_err("Failed to get the context\n");
> -               return -EINVAL;
> +               return PTR_ERR(common->alloc_ctx);
>         }
>         q = &common->buffer_queue;
>         q->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
