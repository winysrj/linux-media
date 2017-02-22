Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:52932 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932726AbdBVOmd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Feb 2017 09:42:33 -0500
Message-ID: <1487774545.5907.17.camel@collabora.com>
Subject: Re: [PATCH v5 3/3] [media] s5p-mfc: Check and set
 'v4l2_pix_format:field' field in try_fmt
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: Thibault Saunier <thibault.saunier@osg.samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
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
Date: Wed, 22 Feb 2017 09:42:25 -0500
In-Reply-To: <ed287d5a-687b-b344-3f20-10154071852c@osg.samsung.com>
References: <20170221192059.29745-1-thibault.saunier@osg.samsung.com>
         <CGME20170221192135epcas4p1811fa9ce35481d42144bdab368c9243a@epcas4p1.samsung.com>
         <20170221192059.29745-4-thibault.saunier@osg.samsung.com>
         <78444dcd-169f-0c16-0e09-6b71d1a502b2@samsung.com>
         <ed287d5a-687b-b344-3f20-10154071852c@osg.samsung.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-GwKi2XUD95pgM4vA7Cka"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-GwKi2XUD95pgM4vA7Cka
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mercredi 22 f=C3=A9vrier 2017 =C3=A0 10:10 -0300, Thibault Saunier a =C3=
=A9crit=C2=A0:
> Hello,
>=20
> On 02/22/2017 06:29 AM, Andrzej Hajda wrote:
> > On 21.02.2017 20:20, Thibault Saunier wrote:
> > > It is required by the standard that the field order is set by the
> > > driver.
> > >=20
> > > Signed-off-by: Thibault Saunier <thibault.saunier@osg.samsung.com
> > > >
> > >=20
> > > ---
> > >=20
> > > Changes in v5:
> > > - Just adapt the field and never error out.
> > >=20
> > > Changes in v4: None
> > > Changes in v3:
> > > - Do not check values in the g_fmt functions as Andrzej explained
> > > in previous review
> > >=20
> > > Changes in v2:
> > > - Fix a silly build error that slipped in while rebasing the
> > > patches
> > >=20
> > > =C2=A0 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c | 3 +++
> > > =C2=A0 1 file changed, 3 insertions(+)
> > >=20
> > > diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> > > b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> > > index 0976c3e0a5ce..44ed2afe0780 100644
> > > --- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> > > +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> > > @@ -386,6 +386,9 @@ static int vidioc_try_fmt(struct file *file,
> > > void *priv, struct v4l2_format *f)
> > > =C2=A0=C2=A0	struct v4l2_pix_format_mplane *pix_mp =3D &f->fmt.pix_mp=
;
> > > =C2=A0=C2=A0	struct s5p_mfc_fmt *fmt;
> > > =C2=A0=C2=A0
> > > +	if (f->fmt.pix.field =3D=3D V4L2_FIELD_ANY)
> > > +		f->fmt.pix.field =3D V4L2_FIELD_NONE;
> > > +
> >=20
> > In previous version the only supported field type was NONE, here
> > you
> > support everything.
> > If the only supported format is none you should set 'field'
> > unconditionally to NONE, nothing more.
>=20
> Afaict we=C2=A0=C2=A0support 2 things:
>=20
> =C2=A0=C2=A0=C2=A01. NONE
> =C2=A0=C2=A0=C2=A02. INTERLACE
>=20
> Until now we were not checking what was supported or not and
> basically=C2=A0
> ignoring that info, this patch
> keeps the old behaviour making sure to be compliant.
>=20
> I had a doubt and was pondering doing:
>=20
> ``` diff
>=20
> +	if (f->fmt.pix.field !=3D V4L2_FIELD_INTERLACED)
> +		f->fmt.pix.field =3D V4L2_FIELD_NONE;
> +
>=20

This looks better to me.

> ```
>=20
> instead, it is probably more correct, do you think it is what should
> be=C2=A0
> done here?
>=20
> Regards,
>=20
> Thibault
>=20
> >=20
> > Regards
> > Andrzej
> >=20
> > > =C2=A0=C2=A0	mfc_debug(2, "Type is %d\n", f->type);
> > > =C2=A0=C2=A0	if (f->type =3D=3D V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> > > =C2=A0=C2=A0		fmt =3D find_format(f, MFC_FMT_DEC);
>=20
>=20
--=-GwKi2XUD95pgM4vA7Cka
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlito1EACgkQcVMCLawGqBy+tgCeN4UKQCQlZflnDAgybPdmgx0y
uksAoNNQBZGPedHd6Du/W5ySrwWGBc3B
=9TtN
-----END PGP SIGNATURE-----

--=-GwKi2XUD95pgM4vA7Cka--
