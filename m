Return-path: <linux-media-owner@vger.kernel.org>
Received: from leonov.paulk.fr ([185.233.101.22]:47206 "EHLO leonov.paulk.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726335AbeIEUUl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Sep 2018 16:20:41 -0400
Message-ID: <383bf546272ac7edca5a5f502fce4cafa88a3321.camel@paulk.fr>
Subject: Re: [PATCH v8 4/8] media: platform: Add Cedrus VPU decoder driver
From: Paul Kocialkowski <contact@paulk.fr>
To: Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devel@driverdev.osuosl.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Randy Li <ayaka@soulik.info>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-sunxi@googlegroups.com
Date: Wed, 05 Sep 2018 17:49:31 +0200
In-Reply-To: <f15e355ece0b250a252347ec22f1433dd786bb5b.camel@collabora.com>
References: <20180828073424.30247-1-paul.kocialkowski@bootlin.com>
         <20180828073424.30247-5-paul.kocialkowski@bootlin.com>
         <f15e355ece0b250a252347ec22f1433dd786bb5b.camel@collabora.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-KFmJeFVy/fWfX39GUA0U"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-KFmJeFVy/fWfX39GUA0U
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Le mardi 28 ao=C3=BBt 2018 =C3=A0 22:08 -0300, Ezequiel Garcia a =C3=A9crit=
 :
> On Tue, 2018-08-28 at 09:34 +0200, Paul Kocialkowski wrote:
> > +static const struct v4l2_m2m_ops cedrus_m2m_ops =3D {
> > +	.device_run	=3D cedrus_device_run,
> > +	.job_abort	=3D cedrus_job_abort,
> > +};
> > +
>=20
> I think you can get rid of this .job_abort. It should
> simplify your .device_run quite a bit.
>=20
> .job_abort is optional now since
> 5525b8314389a0c558d15464e86f438974b94e32.

Alright, I will probably do that for the next revision, since it seems
that there is no particular downside to removing it.

Thanks,

Paul

> Regards,
> Ezequiel

--=20
Developer of free digital technology and hardware support.

Website: https://www.paulk.fr/
Coding blog: https://code.paulk.fr/
Git repositories: https://git.paulk.fr/ https://git.code.paulk.fr/

--=-KFmJeFVy/fWfX39GUA0U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEAbcMXZQMtj1fphLChP3B6o/ulQwFAluP+wsACgkQhP3B6o/u
lQwr5RAAhwkjVt4DncAUciQMMQNfX7Fl3XQ0nmjsszYqQCr1FVFtXRwMuU8+hkPF
WlMFw1yVWTz3dfh/KZfP+5V568FO4L+NkDvPvCp6hkhh3RbjRnuGrzzOFcpcdNYT
VsJzUJyPOXeQnh4bpHy1PVRiw1b2jHXF9q4kLn1p1fpGABvn6aJZ7lKRtsGnyFwx
2Q4TGfFcenNrTdV9ftdw4CZg7wxThOvS5gUz8FNud4BccX6vDqns8guITvRHFHTR
6vi+8FtvB4Sq/yYnv3Mw8Q700uD5GNgjDSjfp3KzvCOfipYdZmQTcI4cNfSifZbi
R0RdwThMZmmKikZ8k1H5OJ1mOfzvA1YB21siQireV4yFTWf1R/S90yRz0Wpf9OaR
SAG1NSGpj7pQp5daZcQpGCN3SfjXG/sOlie5GptOx3g7QilEWXMyLQUdrej50oG9
7weQUjQOJsUb9aXiOA2wg4VXR3kqGlR6sVcZLaa1uat57JcedA9e3CgTdMaNaPCD
VLHPOa7vCfuvsCw8hzgNIshIfdJni6t0KoiTcy3z4FFBsVqt3zobEtNx50qulMt8
0p+TzGI50OtvrFibLWJjYG+D8Ujkg3AI7SzDk20KQhj28MLQ2/gAtDu8acK32b5e
QMqyCzfkSsGyhCS2EBMg1lxXiV1cYhAPfw3jIpH7rCEa9Ud11Q8=
=wYAK
-----END PGP SIGNATURE-----

--=-KFmJeFVy/fWfX39GUA0U--
