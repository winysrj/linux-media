Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f172.google.com ([209.85.216.172]:44851 "EHLO
        mail-qt0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932287AbdJJPkO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Oct 2017 11:40:14 -0400
Received: by mail-qt0-f172.google.com with SMTP id 8so6764419qtv.1
        for <linux-media@vger.kernel.org>; Tue, 10 Oct 2017 08:40:14 -0700 (PDT)
Message-ID: <1507650010.2784.11.camel@ndufresne.ca>
Subject: Re: [PATCH] media: vb2: unify calling of set_page_dirty_lock
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 10 Oct 2017 11:40:10 -0400
In-Reply-To: <20170829112603.32732-1-stanimir.varbanov@linaro.org>
References: <20170829112603.32732-1-stanimir.varbanov@linaro.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-kaSLAR9OMwDtkRdrLSMx"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-kaSLAR9OMwDtkRdrLSMx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mardi 29 ao=C3=BBt 2017 =C3=A0 14:26 +0300, Stanimir Varbanov a =C3=A9cr=
it :
> Currently videobuf2-dma-sg checks for dma direction for
> every single page and videobuf2-dc lacks any dma direction
> checks and calls set_page_dirty_lock unconditionally.
>=20
> Thus unify and align the invocations of set_page_dirty_lock
> for videobuf2-dc, videobuf2-sg  memory allocators with
> videobuf2-vmalloc, i.e. the pattern used in vmalloc has been
> copied to dc and dma-sg.

Just before we go too far in "doing like vmalloc", I would like to
share this small video that display coherency issues when rendering
vmalloc backed DMABuf over various KMS/DRM driver. I can reproduce this
easily with Intel and MSM display drivers using UVC or Vivid as source.

The following is an HDMI capture of the following GStreamer pipeline
running on Dragonboard 410c.

    gst-launch-1.0 -v v4l2src device=3D/dev/video2 ! video/x-raw,format=3DN=
V16,width=3D1280,height=3D720 ! kmssink
    https://people.collabora.com/~nicolas/vmalloc-issue.mov

Feedback on this issue would be more then welcome. It's not clear to me
who's bug is this (v4l2, drm or iommu). The software is unlikely to be
blamed as this same pipeline works fine with non-vmalloc based sources.

regards,
Nicolas

>=20
> Suggested-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> ---
>  drivers/media/v4l2-core/videobuf2-dma-contig.c | 6 ++++--
>  drivers/media/v4l2-core/videobuf2-dma-sg.c     | 7 +++----
>  2 files changed, 7 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/med=
ia/v4l2-core/videobuf2-dma-contig.c
> index 9f389f36566d..696e24f9128d 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> @@ -434,8 +434,10 @@ static void vb2_dc_put_userptr(void *buf_priv)
>  		pages =3D frame_vector_pages(buf->vec);
>  		/* sgt should exist only if vector contains pages... */
>  		BUG_ON(IS_ERR(pages));
> -		for (i =3D 0; i < frame_vector_count(buf->vec); i++)
> -			set_page_dirty_lock(pages[i]);
> +		if (buf->dma_dir =3D=3D DMA_FROM_DEVICE ||
> +		    buf->dma_dir =3D=3D DMA_BIDIRECTIONAL)
> +			for (i =3D 0; i < frame_vector_count(buf->vec); i++)
> +				set_page_dirty_lock(pages[i]);
>  		sg_free_table(sgt);
>  		kfree(sgt);
>  	}
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v=
4l2-core/videobuf2-dma-sg.c
> index 6808231a6bdc..753ed3138dcc 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
> @@ -292,11 +292,10 @@ static void vb2_dma_sg_put_userptr(void *buf_priv)
>  	if (buf->vaddr)
>  		vm_unmap_ram(buf->vaddr, buf->num_pages);
>  	sg_free_table(buf->dma_sgt);
> -	while (--i >=3D 0) {
> -		if (buf->dma_dir =3D=3D DMA_FROM_DEVICE ||
> -		    buf->dma_dir =3D=3D DMA_BIDIRECTIONAL)
> +	if (buf->dma_dir =3D=3D DMA_FROM_DEVICE ||
> +	    buf->dma_dir =3D=3D DMA_BIDIRECTIONAL)
> +		while (--i >=3D 0)
>  			set_page_dirty_lock(buf->pages[i]);
> -	}
>  	vb2_destroy_framevec(buf->vec);
>  	kfree(buf);
>  }
--=-kaSLAR9OMwDtkRdrLSMx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCWdzp2gAKCRBxUwItrAao
HI35AJ9ZYTNNK9iks0sExSZZ8uETQRIOiwCg0mwVO7kS6meYDNV4lbBh7v4kKvc=
=6Vpt
-----END PGP SIGNATURE-----

--=-kaSLAR9OMwDtkRdrLSMx--
