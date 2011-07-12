Return-path: <mchehab@localhost>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:33074 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab1GLFV7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2011 01:21:59 -0400
Received: by vxb39 with SMTP id 39so3191764vxb.19
        for <linux-media@vger.kernel.org>; Mon, 11 Jul 2011 22:21:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTimHtpaScRYe2kuFNW9Ja9x343aOTQ@mail.gmail.com>
References: <BANLkTimHtpaScRYe2kuFNW9Ja9x343aOTQ@mail.gmail.com>
Date: Tue, 12 Jul 2011 13:21:58 +0800
Message-ID: <CAGA24MJe9xBwm1J-cVH4Qi3b=7Ze+1PXEWzFh7dS8eHrBZoHWw@mail.gmail.com>
Subject: Re: [PATCH] [media] videobuf2-dma-contig: return NULL if alloc fails
From: Jun Nie <niej0001@gmail.com>
To: Pawel Osciak <pawel@osciak.com>, Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

2011/6/23 Jun Nie <niej0001@gmail.com>:
> return NULL if alloc fails to avoid taking error code as
> buffer pointer
>
> Signed-off-by: Jun Nie <njun@marvell.com>
> ---
>  drivers/media/video/videobuf2-dma-contig.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/video/videobuf2-dma-contig.c
> b/drivers/media/video/videobuf2-dma-contig.c
> index a790a5f..8e8c7aa 100644
> --- a/drivers/media/video/videobuf2-dma-contig.c
> +++ b/drivers/media/video/videobuf2-dma-contig.c
> @@ -40,7 +40,7 @@ static void *vb2_dma_contig_alloc(void *alloc_ctx,
> unsigned long size)
>
>        buf = kzalloc(sizeof *buf, GFP_KERNEL);
>        if (!buf)
> -               return ERR_PTR(-ENOMEM);
> +               return NULL;
>
>        buf->vaddr = dma_alloc_coherent(conf->dev, size, &buf->paddr,
>                                        GFP_KERNEL);
> @@ -48,7 +48,7 @@ static void *vb2_dma_contig_alloc(void *alloc_ctx,
> unsigned long size)
>                dev_err(conf->dev, "dma_alloc_coherent of size %ld failed\n",
>                        size);
>                kfree(buf);
> -               return ERR_PTR(-ENOMEM);
> +               return NULL;
>        }
>
>        buf->conf = conf;
> --
> 1.7.0.4
>

How do you think about this fix?
Thanks!

Jun
