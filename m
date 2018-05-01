Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:48430 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754970AbeEAMxP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 1 May 2018 08:53:15 -0400
Subject: Re: [PATCH 3/3] v4l: rcar_fdp1: Fix indentation oddities
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
References: <20180422102849.2481-1-laurent.pinchart+renesas@ideasonboard.com>
 <20180422102849.2481-4-laurent.pinchart+renesas@ideasonboard.com>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <dbafee8a-755b-15b8-35ce-59dc7e5d17c9@ideasonboard.com>
Date: Tue, 1 May 2018 13:53:10 +0100
MIME-Version: 1.0
In-Reply-To: <20180422102849.2481-4-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="A705WWkLwUZuQ0SercASarM39cW8rYG7R"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--A705WWkLwUZuQ0SercASarM39cW8rYG7R
Content-Type: multipart/mixed; boundary="9k9GPmVHuDuEtLc4YP9nkeODjMetWaNjM";
 protected-headers="v1"
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
 linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
 Geert Uytterhoeven <geert+renesas@glider.be>
Message-ID: <dbafee8a-755b-15b8-35ce-59dc7e5d17c9@ideasonboard.com>
Subject: Re: [PATCH 3/3] v4l: rcar_fdp1: Fix indentation oddities
References: <20180422102849.2481-1-laurent.pinchart+renesas@ideasonboard.com>
 <20180422102849.2481-4-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20180422102849.2481-4-laurent.pinchart+renesas@ideasonboard.com>

--9k9GPmVHuDuEtLc4YP9nkeODjMetWaNjM
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

Hi Laurent,

Thanks for the fixes.

On 22/04/18 11:28, Laurent Pinchart wrote:
> Indentation is odd in several places, especially when printing messages=

> to the kernel log. Fix it to match the usual coding style.
>=20
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.=
com>

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
>  drivers/media/platform/rcar_fdp1.c | 28 ++++++++++++++--------------
>  1 file changed, 14 insertions(+), 14 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar_fdp1.c b/drivers/media/platfor=
m/rcar_fdp1.c
> index b13dec3081e5..81e8a761b924 100644
> --- a/drivers/media/platform/rcar_fdp1.c
> +++ b/drivers/media/platform/rcar_fdp1.c
> @@ -949,7 +949,7 @@ static void fdp1_configure_wpf(struct fdp1_ctx *ctx=
,
>  	u32 rndctl;
> =20
>  	pstride =3D q_data->format.plane_fmt[0].bytesperline
> -			<< FD1_WPF_PSTRIDE_Y_SHIFT;
> +		<< FD1_WPF_PSTRIDE_Y_SHIFT;
> =20
>  	if (q_data->format.num_planes > 1)
>  		pstride |=3D q_data->format.plane_fmt[1].bytesperline
> @@ -1143,8 +1143,8 @@ static int fdp1_m2m_job_ready(void *priv)
>  	int dstbufs =3D 1;
> =20
>  	dprintk(ctx->fdp1, "+ Src: %d : Dst: %d\n",
> -			v4l2_m2m_num_src_bufs_ready(ctx->fh.m2m_ctx),
> -			v4l2_m2m_num_dst_bufs_ready(ctx->fh.m2m_ctx));
> +		v4l2_m2m_num_src_bufs_ready(ctx->fh.m2m_ctx),
> +		v4l2_m2m_num_dst_bufs_ready(ctx->fh.m2m_ctx));
> =20
>  	/* One output buffer is required for each field */
>  	if (V4L2_FIELD_HAS_BOTH(src_q_data->format.field))
> @@ -1282,7 +1282,7 @@ static void fdp1_m2m_device_run(void *priv)
> =20
>  		fdp1_queue_field(ctx, fbuf);
>  		dprintk(fdp1, "Queued Buffer [%d] last_field:%d\n",
> -				i, fbuf->last_field);
> +			i, fbuf->last_field);
>  	}
> =20
>  	/* Queue as many jobs as our data provides for */
> @@ -1341,7 +1341,7 @@ static void device_frame_end(struct fdp1_dev *fdp=
1,
>  	fdp1_job_free(fdp1, job);
> =20
>  	dprintk(fdp1, "curr_ctx->num_processed %d curr_ctx->translen %d\n",
> -			ctx->num_processed, ctx->translen);
> +		ctx->num_processed, ctx->translen);
> =20
>  	if (ctx->num_processed =3D=3D ctx->translen ||
>  			ctx->aborting) {
> @@ -1366,7 +1366,7 @@ static int fdp1_vidioc_querycap(struct file *file=
, void *priv,
>  	strlcpy(cap->driver, DRIVER_NAME, sizeof(cap->driver));
>  	strlcpy(cap->card, DRIVER_NAME, sizeof(cap->card));
>  	snprintf(cap->bus_info, sizeof(cap->bus_info),
> -			"platform:%s", DRIVER_NAME);
> +		 "platform:%s", DRIVER_NAME);
>  	return 0;
>  }
> =20
> @@ -1997,13 +1997,13 @@ static void fdp1_stop_streaming(struct vb2_queu=
e *q)
>  		/* Free smsk_data */
>  		if (ctx->smsk_cpu) {
>  			dma_free_coherent(ctx->fdp1->dev, ctx->smsk_size,
> -					ctx->smsk_cpu, ctx->smsk_addr[0]);
> +					  ctx->smsk_cpu, ctx->smsk_addr[0]);
>  			ctx->smsk_addr[0] =3D ctx->smsk_addr[1] =3D 0;
>  			ctx->smsk_cpu =3D NULL;
>  		}
> =20
>  		WARN(!list_empty(&ctx->fields_queue),
> -				"Buffer queue not empty");
> +		     "Buffer queue not empty");
>  	} else {
>  		/* Empty Capture queues (Jobs) */
>  		struct fdp1_job *job;
> @@ -2025,10 +2025,10 @@ static void fdp1_stop_streaming(struct vb2_queu=
e *q)
>  		fdp1_field_complete(ctx, ctx->previous);
> =20
>  		WARN(!list_empty(&ctx->fdp1->queued_job_list),
> -				"Queued Job List not empty");
> +		     "Queued Job List not empty");
> =20
>  		WARN(!list_empty(&ctx->fdp1->hw_job_list),
> -				"HW Job list not empty");
> +		     "HW Job list not empty");
>  	}
>  }
> =20
> @@ -2114,7 +2114,7 @@ static int fdp1_open(struct file *file)
>  				     fdp1_ctrl_deint_menu);
> =20
>  	ctrl =3D v4l2_ctrl_new_std(&ctx->hdl, &fdp1_ctrl_ops,
> -			V4L2_CID_MIN_BUFFERS_FOR_CAPTURE, 1, 2, 1, 1);
> +				 V4L2_CID_MIN_BUFFERS_FOR_CAPTURE, 1, 2, 1, 1);
>  	if (ctrl)
>  		ctrl->flags |=3D V4L2_CTRL_FLAG_VOLATILE;
> =20
> @@ -2351,8 +2351,8 @@ static int fdp1_probe(struct platform_device *pde=
v)
>  		goto release_m2m;
>  	}
> =20
> -	v4l2_info(&fdp1->v4l2_dev,
> -			"Device registered as /dev/video%d\n", vfd->num);
> +	v4l2_info(&fdp1->v4l2_dev, "Device registered as /dev/video%d\n",
> +		  vfd->num);
> =20
>  	/* Power up the cells to read HW */
>  	pm_runtime_enable(&pdev->dev);
> @@ -2371,7 +2371,7 @@ static int fdp1_probe(struct platform_device *pde=
v)
>  		break;
>  	default:
>  		dev_err(fdp1->dev, "FDP1 Unidentifiable (0x%08x)\n",
> -				hw_version);
> +			hw_version);
>  	}
> =20
>  	/* Allow the hw to sleep until an open call puts it to use */
>=20


--9k9GPmVHuDuEtLc4YP9nkeODjMetWaNjM--

--A705WWkLwUZuQ0SercASarM39cW8rYG7R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEkC3XmD+9KP3jctR6oR5GchCkYf0FAlroYzYACgkQoR5GchCk
Yf2gYhAAlLxJxBIvteka0LGWINcMzSvobBu3vwdTxFJ7g0Gs7MvN3JPBgrrgDDOW
hCrX74vaUumNY8imKgcb62a1dmh3oaw5T6aSjkTejwj5Mf30ShWNCJucsh1PpZow
hqAGkiRdjM1/H2yaJIAqcfI4kqCnCWrn0ZKeNhez0lP5QI2ydq/VSLcR00DkBzKy
S6fxIbzyPRzlPAS1peWVM0Ajho/3mKYTwptZY1AudeYfG6WEGMsm/bQQQn5r0Kr7
7OwApRfqU2To9tBweNKXtiqLgdG7nXCezvGZbX3WO/zjTerPP0jFDNxs6bVpm7eo
ROw2tpqr2PAton/rv4tAxdyWBPXFZrEeG7Mw+9AN7tj1j3QxDNwgTfexo+bZsx0p
RAv/cZG3Gl/W/sNrSoQ4Jn2nqjsS2LAr4JhKXSl2GNcln4Qd3DISjgYAK9CaojU+
XV1gnJ2yOyFqwmFtA3gko0uGVQJZzPbOcB7+Yi+JHSX/B1U5qh+iFQq00YQuEK3Y
pgKfumLN7aeexheErizUYb3SoMxTdlsW+jQ2JoXP0SVLsZ7GTgrTlAdtuU3cyU2h
1VPVTgip+kvtDotWsxo2ko4RjONM38sKZVXLfjy2zRJpUtbFuAqgf1g9hcHLrdaN
VpK7sLOhZdee7Ei8IhMM8DXM88E4FYR1LUOR1YsZmlTrlnQtHko=
=Or+0
-----END PGP SIGNATURE-----

--A705WWkLwUZuQ0SercASarM39cW8rYG7R--
