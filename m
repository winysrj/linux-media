Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:52067 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751491AbeDKOHd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Apr 2018 10:07:33 -0400
Message-ID: <ed6b6652337239c97125ac96b203dddd517e0427.camel@bootlin.com>
Subject: Re: [RFCv11 PATCH 26/29] vim2m: use workqueue
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Date: Wed, 11 Apr 2018 16:06:11 +0200
In-Reply-To: <20180409142026.19369-27-hverkuil@xs4all.nl>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
         <20180409142026.19369-27-hverkuil@xs4all.nl>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-1fl1rVEQDQ9sBFsEv4Y2"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-1fl1rVEQDQ9sBFsEv4Y2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, 2018-04-09 at 16:20 +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>=20
> v4l2_ctrl uses mutexes, so we can't setup a ctrl_handler in
> interrupt context. Switch to a workqueue instead.

See one comment below.

> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/platform/vim2m.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/media/platform/vim2m.c
> b/drivers/media/platform/vim2m.c
> index ef970434af13..9b18b32c255d 100644
> --- a/drivers/media/platform/vim2m.c
> +++ b/drivers/media/platform/vim2m.c
> @@ -150,6 +150,7 @@ struct vim2m_dev {
>  	spinlock_t		irqlock;
> =20
>  	struct timer_list	timer;
> +	struct work_struct	work_run;

Wouldn't it make more sense to move this to vim2m_ctx instead (since
this is heavily m2m-specific)?

>  	struct v4l2_m2m_dev	*m2m_dev;
>  };
> @@ -392,9 +393,10 @@ static void device_run(void *priv)
>  	schedule_irq(dev, ctx->transtime);
>  }
> =20
> -static void device_isr(struct timer_list *t)
> +static void device_work(struct work_struct *w)
>  {
> -	struct vim2m_dev *vim2m_dev =3D from_timer(vim2m_dev, t,
> timer);
> +	struct vim2m_dev *vim2m_dev =3D
> +		container_of(w, struct vim2m_dev, work_run);
>  	struct vim2m_ctx *curr_ctx;
>  	struct vb2_v4l2_buffer *src_vb, *dst_vb;
>  	unsigned long flags;
> @@ -426,6 +428,13 @@ static void device_isr(struct timer_list *t)
>  	}
>  }
> =20
> +static void device_isr(struct timer_list *t)
> +{
> +	struct vim2m_dev *vim2m_dev =3D from_timer(vim2m_dev, t,
> timer);
> +
> +	schedule_work(&vim2m_dev->work_run);
> +}
> +
>  /*
>   * video ioctls
>   */
> @@ -806,6 +815,7 @@ static void vim2m_stop_streaming(struct vb2_queue
> *q)
>  	struct vb2_v4l2_buffer *vbuf;
>  	unsigned long flags;
> =20
> +	flush_scheduled_work();
>  	for (;;) {
>  		if (V4L2_TYPE_IS_OUTPUT(q->type))
>  			vbuf =3D v4l2_m2m_src_buf_remove(ctx-
> >fh.m2m_ctx);
> @@ -1011,6 +1021,7 @@ static int vim2m_probe(struct platform_device
> *pdev)
>  	vfd =3D &dev->vfd;
>  	vfd->lock =3D &dev->dev_mutex;
>  	vfd->v4l2_dev =3D &dev->v4l2_dev;
> +	INIT_WORK(&dev->work_run, device_work);
> =20
>  #ifdef CONFIG_MEDIA_CONTROLLER
>  	dev->mdev.dev =3D &pdev->dev;
--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com
--=-1fl1rVEQDQ9sBFsEv4Y2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlrOFlMACgkQ3cLmz3+f
v9F7nAgAjLMZIxu1vTBPGZLZMiuu5D5P4h2bjwtX6b4wbQ5yLuwVZUBiYG5ofzQR
ksCNLFVbriFmp/vvTt/RRRBwBBg+jgvu/7edJUcwjHMr6nBftqIfLI53AKzJuhVO
RS/Go63f5My8mhSED1yFo9JPAGCKZaVMu/uNpYjzqoy28de8d0IGFwR2TRwCZ5r6
J1AylJV855q0fGW22s303mbR9GaDJW0Sbk0LnrNAgGbMWx+gbjpx2QaQRFMx5JeU
EMB2z9tQoj/2n+/xFXSQw8l+BHjvm8uB9rHVvqF1q1uESkz5Nq5FwPVgp/DQ8X1N
hBBgdCMZPJmnpy8l2AGVI6X+x22KLg==
=mP/7
-----END PGP SIGNATURE-----

--=-1fl1rVEQDQ9sBFsEv4Y2--
