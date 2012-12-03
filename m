Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:36717 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab2LCGDN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Dec 2012 01:03:13 -0500
Received: by mail-oa0-f46.google.com with SMTP id h16so2308902oag.19
        for <linux-media@vger.kernel.org>; Sun, 02 Dec 2012 22:03:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPgLHd-T7M8uuKd3cP31PHM-DfYcPXF_sV3uTQTENqctK6qzfg@mail.gmail.com>
References: <CAPgLHd-T7M8uuKd3cP31PHM-DfYcPXF_sV3uTQTENqctK6qzfg@mail.gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 3 Dec 2012 11:32:52 +0530
Message-ID: <CA+V-a8uG_v6fo6jUw7dq5kH=aNhN0ds1G7rPCfAyBrsGB_RjjQ@mail.gmail.com>
Subject: Re: [PATCH -next] [media] media: davinci: vpbe: fix return value
 check in vpbe_display_reqbufs()
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: manjunath.hadli@ti.com, prabhakar.lad@ti.com, mchehab@redhat.com,
	yongjun_wei@trendmicro.com.cn,
	davinci-linux-open-source@linux.davincidsp.com,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Sun, Dec 2, 2012 at 3:48 PM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> In case of error, the function vb2_dma_contig_init_ctx() returns
> ERR_PTR() and never returns NULL. The NULL test in the return value
> check should be replaced with IS_ERR().
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Prabhakar Lad <prabhakar.lad@ti.com>

Regards,
--Prabhakar

> ---
>  drivers/media/platform/davinci/vpbe_display.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
> index 2bfde79..e181a52 100644
> --- a/drivers/media/platform/davinci/vpbe_display.c
> +++ b/drivers/media/platform/davinci/vpbe_display.c
> @@ -1393,9 +1393,9 @@ static int vpbe_display_reqbufs(struct file *file, void *priv,
>         }
>         /* Initialize videobuf queue as per the buffer type */
>         layer->alloc_ctx = vb2_dma_contig_init_ctx(vpbe_dev->pdev);
> -       if (!layer->alloc_ctx) {
> +       if (IS_ERR(layer->alloc_ctx)) {
>                 v4l2_err(&vpbe_dev->v4l2_dev, "Failed to get the context\n");
> -               return -EINVAL;
> +               return PTR_ERR(layer->alloc_ctx);
>         }
>         q = &layer->buffer_queue;
>         memset(q, 0, sizeof(*q));
>
> _______________________________________________
> Davinci-linux-open-source mailing list
> Davinci-linux-open-source@linux.davincidsp.com
> http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
