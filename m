Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:49912
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751283AbdITSWh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 14:22:37 -0400
Date: Wed, 20 Sep 2017 15:22:20 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>,
        linux-i2c@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [RFC PATCH v4 3/6] i2c: add docs to clarify DMA handling
Message-ID: <20170920152220.74bd43c3@recife.lan>
In-Reply-To: <20170920171840.nrzyiasezxisvg5m@ninjato>
References: <20170817141449.23958-1-wsa+renesas@sang-engineering.com>
        <20170817141449.23958-4-wsa+renesas@sang-engineering.com>
        <20170827083748.248e2430@vento.lan>
        <20170920171840.nrzyiasezxisvg5m@ninjato>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/pOBv1e7Rx6bBc5uaBC2oVJl"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/pOBv1e7Rx6bBc5uaBC2oVJl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Em Wed, 20 Sep 2017 19:18:40 +0200
Wolfram Sang <wsa@the-dreams.de> escreveu:

> Hi Mauro,
>=20
> > > +Linux I2C and DMA
> > > +----------------- =20
> >=20
> > I would use, instead:
> >=20
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > Linux I2C and DMA
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >=20
> > As this is the way we're starting document titles, after converted to
> > ReST. So, better to have it already using the right format, as one day =
=20
>=20
> I did this.
>=20
> > There are also a couple of things here that Sphinx would complain. =20
>=20
> The only complaint I got was
>=20
> 	WARNING: document isn't included in any toctree
>=20
> which makes sense because I renamed it only temporarily to *.rst

Yeah, that is expected.

> > So, it could be worth to rename it to *.rst, while you're writing
> > it, and see what:
> > 	make htmldocs
> > will complain and how it will look in html. =20
>=20
> So, no complaints from Sphinx and the HTML output looks good IMO. Was
> there anything specific you had in mind when saying that Sphinx would
> complain?

Perhaps my comments weren't clear enough. Sorry! I didn't actually=20
tried to parse it with Sphinx. Just wanted to hint you about that,
as testing the docs with Sphinx could be useful when writing
documentation.=20

Usually, things like function declarations produce warnings if they
contain pointers, e. g. something like:

	foo(void *bar);

as asterisks mean italics. It would complain about the lack of
an end asterisk.

In order to avoid that, and to place them into a box using monotonic fonts,
I usually add "::" at the preceding line, e. g.:

	::

		foo(void *bar);

or:

	some description::

		foo(void *bar)

on all functions (even the ones that don't use asterisks, as the
html output looks nicer.

I double-checked this patch: it doesn't contain anything that would
cause warnings or parse errors. Still, I would prefer to use
**not** instead of *not*, and would add the "::", but that's my
personal taste.

Thanks,
Mauro

--Sig_/pOBv1e7Rx6bBc5uaBC2oVJl
Content-Type: application/pgp-signature
Content-Description: Assinatura digital OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+QmuaPwR3wnBdVwACF8+vY7k4RUFAlnCsdwACgkQCF8+vY7k
4RXVfg/9HoQdB8G9uvYeRVJKHyQurXleRUdtMgXMSbbCjAkcdnAvcygkRyNHArYL
B7lx6hi9yk4+bHmHTtqfuZo02381L1l8fcFBpGWyAsnW9C4L14SwogqpcJIHDLNf
KOvMpfQtfZCXRzl05yNXnNCLTX82LiHbBk1f/VAmx9/RD6HY/nN3xNMQtA+aASRu
6Q+EY+znWc4VuW2XxF5eq9bU7/YaOwRs0TplIObNcfGeEWlZdM1inyKzH45MhtCn
Gb5UTCTyrsSAFkc5KdWrsxcTWR9V9pzaxsr7WIu7qfMyikenVrboMAouIEOfOEqx
2HA/aXj0vm8SyxmH/KMReUAWjKHLHHRGsvwbde6edwRGTZ4v7R4L41Lw/Ne+3RSk
KSYg/6Ww/AscugZ8rOg5WwmF5V4BymRM68PzIYzBsoAVmCfL5uvj2XCxHbIifFbH
aorIASFsE8PX+Qi2ZtV41CMOhej9h7WbuxUwLqVyYeyJUIggOlE6YTX3U7+tuogo
ByERwLharq5VAnK55kQFqHLy08ti/hKvyOvN83BOsHpPFzusY/WPLqFibToz9mKn
joB/kDCxwYEwf1+yg8/csUYOFDWr4d/ldB6X9hPZP86Pu3qJ6Yoej03zrShfzMYp
6CZYeMzTzllJCYigHcAtUH5ssbu3vECRrxnbmLB9dTBWmEc3hZM=
=yepP
-----END PGP SIGNATURE-----

--Sig_/pOBv1e7Rx6bBc5uaBC2oVJl--
