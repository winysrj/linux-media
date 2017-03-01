Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:44056 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750734AbdCAOpg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Mar 2017 09:45:36 -0500
Message-ID: <1488378936.14858.1.camel@collabora.com>
Subject: Re: [PATCH v6 2/2] [media] s5p-mfc: Handle 'v4l2_pix_format:field'
 in try_fmt and g_fmt
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: Andrzej Hajda <a.hajda@samsung.com>,
        Thibault Saunier <thibault.saunier@osg.samsung.com>,
        linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Andi Shyti <andi.shyti@samsung.com>,
        linux-media@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Jeongtae Park <jtp.park@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kamil Debski <kamil@wypas.org>
Date: Wed, 01 Mar 2017 09:35:36 -0500
In-Reply-To: <33dbd3fa-04b2-3d94-5163-0a10589ff1c7@samsung.com>
References: <20170301115108.14187-1-thibault.saunier@osg.samsung.com>
         <CGME20170301115141epcas2p37801b1fbe0951cc37a4e01bf2bcae3da@epcas2p3.samsung.com>
         <20170301115108.14187-3-thibault.saunier@osg.samsung.com>
         <33dbd3fa-04b2-3d94-5163-0a10589ff1c7@samsung.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-0t0Xmz0xd65eafScJp8w"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-0t0Xmz0xd65eafScJp8w
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mercredi 01 mars 2017 =C3=A0 14:12 +0100, Andrzej Hajda a =C3=A9crit=C2=
=A0:
> On 01.03.2017 12:51, Thibault Saunier wrote:
> > It is required by the standard that the field order is set by the
> > driver, default to NONE in case any is provided, but we can
> > basically
> > accept any value provided by the userspace as we will anyway not
> > be able to do any deinterlacing.
> >=20
> > In this patch we also make sure to pass the interlacing mode
> > provided
> > by userspace from the output to the capture side of the device so
> > that the information is given back to userspace. This way it can
> > handle it and potentially deinterlace afterward.
>=20
> As I wrote previously:
> - on output side you have encoded bytestream - you cannot say about
> interlacing in such case, so the only valid value is NONE,

Userspace may know. It's important for the driver not to reset it back
to NONE, it would tell the userspace that this encoded format is not
supported when interlaced.

Obviously, when userspace don't know (ANY), it does not matter, it will
fail when we try to set the CAPTURE format. Though, it's quite late in
the process for the userspace, which makes implementing software
fallback difficult.

> - on capture side you have decoded frames, and in this case it
> depends
> on the device and driver capabilities, if the driver/device does not
> support (de-)interlacing (I suppose this is MFC case), interlace type
> field should be filled according to decoded bytestream header (on
> output
> side), but no direct copying from output side!!!

That is exact.

>=20
> Regards
> Andrzej
>=20
> >=20
> > Signed-off-by: Thibault Saunier <thibault.saunier@osg.samsung.com>
> >=20
> > ---
> >=20
> > Changes in v6:
> > - Pass user output field value to the capture as the device is not
> > =C2=A0 doing any deinterlacing and thus decoded content will still be
> > =C2=A0 interlaced on the output.
> >=20
> > Changes in v5:
> > - Just adapt the field and never error out.
> >=20
> > Changes in v4: None
> > Changes in v3:
> > - Do not check values in the g_fmt functions as Andrzej explained
> > in previous review
> >=20
> > Changes in v2:
> > - Fix a silly build error that slipped in while rebasing the
> > patches
> >=20
> > =C2=A0drivers/media/platform/s5p-mfc/s5p_mfc_common.h | 2 ++
> > =C2=A0drivers/media/platform/s5p-mfc/s5p_mfc_dec.c=C2=A0=C2=A0=C2=A0=C2=
=A0| 6 +++++-
> > =C2=A02 files changed, 7 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> > b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> > index ab23236aa942..3816a37de4bc 100644
> > --- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> > +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> > @@ -652,6 +652,8 @@ struct s5p_mfc_ctx {
> > =C2=A0	size_t me_buffer_size;
> > =C2=A0	size_t tmv_buffer_size;
> > =C2=A0
> > +	enum v4l2_field field;
> > +
> > =C2=A0	enum v4l2_mpeg_mfc51_video_force_frame_type
> > force_frame_type;
> > =C2=A0
> > =C2=A0	struct list_head ref_queue;
> > diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> > b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> > index 367ef8e8dbf0..6e5ca86fb331 100644
> > --- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> > +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> > @@ -345,7 +345,7 @@ static int vidioc_g_fmt(struct file *file, void
> > *priv, struct v4l2_format *f)
> > =C2=A0		=C2=A0=C2=A0=C2=A0rectangle. */
> > =C2=A0		pix_mp->width =3D ctx->buf_width;
> > =C2=A0		pix_mp->height =3D ctx->buf_height;
> > -		pix_mp->field =3D V4L2_FIELD_NONE;
> > +		pix_mp->field =3D ctx->field;
> > =C2=A0		pix_mp->num_planes =3D 2;
> > =C2=A0		/* Set pixelformat to the format in which MFC
> > =C2=A0		=C2=A0=C2=A0=C2=A0outputs the decoded frame */
> > @@ -380,6 +380,9 @@ static int vidioc_try_fmt(struct file *file,
> > void *priv, struct v4l2_format *f)
> > =C2=A0	struct s5p_mfc_dev *dev =3D video_drvdata(file);
> > =C2=A0	struct s5p_mfc_fmt *fmt;
> > =C2=A0
> > +	if (f->fmt.pix.field =3D=3D V4L2_FIELD_ANY)
> > +		f->fmt.pix.field =3D V4L2_FIELD_NONE;
> > +
> > =C2=A0	mfc_debug(2, "Type is %d\n", f->type);
> > =C2=A0	if (f->type =3D=3D V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> > =C2=A0		fmt =3D find_format(f, MFC_FMT_DEC);
> > @@ -436,6 +439,7 @@ static int vidioc_s_fmt(struct file *file, void
> > *priv, struct v4l2_format *f)
> > =C2=A0		goto out;
> > =C2=A0	} else if (f->type =3D=3D V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> > =C2=A0		/* src_fmt is validated by call to vidioc_try_fmt
> > */
> > +		ctx->field =3D f->fmt.pix.field;
> > =C2=A0		ctx->src_fmt =3D find_format(f, MFC_FMT_DEC);
> > =C2=A0		ctx->codec_mode =3D ctx->src_fmt->codec_mode;
> > =C2=A0		mfc_debug(2, "The codec number is: %d\n", ctx-
> > >codec_mode);
>=20
>=20
--=-0t0Xmz0xd65eafScJp8w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAli23DgACgkQcVMCLawGqBxDjQCdGQYKG+5PC1phQPy6DGLX4H6O
kQ4AnR7HeXAhb4oppq2PnIh/7UwLR36v
=GzeV
-----END PGP SIGNATURE-----

--=-0t0Xmz0xd65eafScJp8w--
