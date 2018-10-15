Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot1-f65.google.com ([209.85.210.65]:37402 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbeJOQ5a (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 Oct 2018 12:57:30 -0400
Received: by mail-ot1-f65.google.com with SMTP id o14so18219909oth.4
        for <linux-media@vger.kernel.org>; Mon, 15 Oct 2018 02:13:06 -0700 (PDT)
MIME-Version: 1.0
References: <20181013151707.32210-1-hch@lst.de> <20181013151707.32210-8-hch@lst.de>
In-Reply-To: <20181013151707.32210-8-hch@lst.de>
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Date: Mon, 15 Oct 2018 11:12:55 +0200
Message-ID: <CA+M3ks5KO-Yr_PEczaENhTfirthFz2gW1uv4bwZe5mjy3-jZyg@mail.gmail.com>
Subject: Re: [PATCH 7/8] media: sti/bdisp: don't pass GFP_DMA32 to dma_alloc_attrs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-pm@vger.kernel.org, linux-tegra@vger.kernel.org,
        ML dri-devel <dri-devel@lists.freedesktop.org>,
        linux-media@vger.kernel.org, linux-spi@vger.kernel.org,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        alsa-devel@alsa-project.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le sam. 13 oct. 2018 =C3=A0 17:18, Christoph Hellwig <hch@lst.de> a =C3=A9c=
rit :
>
> The DMA API does its own zone decisions based on the coherent_dma_mask.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>

> ---
>  drivers/media/platform/sti/bdisp/bdisp-hw.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/platform/sti/bdisp/bdisp-hw.c b/drivers/media/=
platform/sti/bdisp/bdisp-hw.c
> index 26d9fa7aeb5f..4372abbb5950 100644
> --- a/drivers/media/platform/sti/bdisp/bdisp-hw.c
> +++ b/drivers/media/platform/sti/bdisp/bdisp-hw.c
> @@ -510,7 +510,7 @@ int bdisp_hw_alloc_filters(struct device *dev)
>
>         /* Allocate all the filters within a single memory page */
>         size =3D (BDISP_HF_NB * NB_H_FILTER) + (BDISP_VF_NB * NB_V_FILTER=
);
> -       base =3D dma_alloc_attrs(dev, size, &paddr, GFP_KERNEL | GFP_DMA,
> +       base =3D dma_alloc_attrs(dev, size, &paddr, GFP_KERNEL,
>                                DMA_ATTR_WRITE_COMBINE);
>         if (!base)
>                 return -ENOMEM;
> --
> 2.19.1
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel



--=20
Benjamin Gaignard

Graphic Study Group

Linaro.org =E2=94=82 Open source software for ARM SoCs

Follow Linaro: Facebook | Twitter | Blog
