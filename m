Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:39241 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbbCMJfM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2015 05:35:12 -0400
Date: Fri, 13 Mar 2015 10:34:53 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	pali.rohar@gmail.com
Subject: Re: [RFC 14/18] dt: bindings: Add bindings for omap3isp
Message-ID: <20150313093453.GA4980@earth>
References: <1425764475-27691-1-git-send-email-sakari.ailus@iki.fi>
 <1425764475-27691-15-git-send-email-sakari.ailus@iki.fi>
 <1429813.xCjhlUaUXi@avalon>
 <20150312230320.GO11954@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
In-Reply-To: <20150312230320.GO11954@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Mar 13, 2015 at 01:03:21AM +0200, Sakari Ailus wrote:
> [...]
>
> > > +Required properties
> > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > +
> > > +compatible	: "ti,omap3-isp"
> >=20
> > I would rephrase that using the usual wording as "compatible: Must cont=
ain=20
> > "ti,omap3-isp".
>
> [...]
>
> > > +ti,phy-type	: 0 -- 3430; 1 -- 3630
> >=20
> > Would it make sense to add #define's for this ?
>=20
> I'll use OMAP3ISP_PHY_TYPE_COMPLEX_IO and OMAP3ISP_PHY_TYPE_CSIPHY as
> discussed.
>=20
> > It could also make sense to document/name them "Complex I/O" and "CSIPH=
Y" to=20
> > avoid referring to the SoC that implements them, as the ISP is also fou=
nd in=20
> > SoCs other than 3430 and 3630.
> >=20
> > Could the PHY type be derived from the ES revision that we query at run=
time ?
>=20
> I think this would work on 3430 and 3630 but I'm not certain about others.
>=20
> > We should also take into account the fact that the DM3730 has officiall=
y no=20
> > CSIPHY, but still seems to implement them in practice.
>=20
> The DT sources are for 36xx, but I'd guess it works on 37xx as well, does=
n't
> it?

In other drivers this kind of information is often extracted from the
compatible string. For example:

{ .compatible =3D "ti,omap34xx-isp", .data =3D OMAP3ISP_PHY_TYPE_COMPLEX_IO=
, },
{ .compatible =3D "ti,omap36xx-isp", .data =3D OMAP3ISP_PHY_TYPE_CSIPHY, },
=2E..

> [...]
>
> > > +Example
> > > +=3D=3D=3D=3D=3D=3D=3D
> > > +
> > > +		omap3_isp: omap3_isp@480bc000 {
> >=20
> > DT node names traditionally use - as a separator. Furthermore the phand=
le=20
> > isn't needed. This should thus probably be
> >=20
> > 	omap3-isp@480bc000 {
>=20
> Fixed.

According to ePAPR this should be a generic name (page 19); For
example the i2c node name should be "i2c@address" instead of
"omap3-i2c@address". There is no recommended generic term for an
image signal processor, "isp" looks ok to me and seems to be
already used in NVIDIA Tegra's device tree files. So maybe:

isp@480bc000 {

> [...]

-- Sebastian

--Nq2Wo0NMKNjxTN9z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJVAq86AAoJENju1/PIO/qa5agP/2nQ6V8OcyeP9n7Aic/ILTda
9d3poBwBh813CWgw7YXiczBtncAVMSl0Pm2Jwj3/jzsn3N/UkQofzirqLjbS1haM
TZCexT9THz4r5w0/afcVzn97vHd5jx6V1YuCeWos+L8fTS8jwt34MiXDU2KYZJWn
m9LPmyMfrMEgKLsnWWrq4AMFrGulhz3qOFgrPJBEpb1CzmtlFJ1f2akyKO9ZqtYK
Hb2wK5uqvAY78Zfd42zfXOmKCQKpiNZqZFRZqefMoxkSnYQZB4FzWGpjMoF3uucX
LiRTh60Ha7PaG4+931nt196WInXBNWJP8Pjjv74ebM5WuP95EcCwjMMLty5vs+3W
8ghM7Nh+Fvm/DzhvtNreJPEqqkqgzps/7M5U2WOKgTZ47rpSlRABg43yt9mbvUDQ
rsup5K2EoP/y9q+be069djXK1X/LwfKT1mnzcOlc94a+i7tALOgNcwyCt+sNKWBJ
ITr2qNw1aAh/fVt/TA3DmHahOyTsWsL2NWzY+E7jzvdKDxZnqI8HhVfEyzqPp5Rn
19Vt0sL8SZsCyquJ4NNGFSN0llYkdxYMBT4OqVZyldTuelEbRxmTMUJxq+Rcs60s
ZKyo/mQcg2FMq2mSUDB3Stnp9iowscwDooWRlhNEe5UjZFlANfdJd8j9s/HgIcOT
Azwsl0GTbA4JrKmLZ7ki
=PWvs
-----END PGP SIGNATURE-----

--Nq2Wo0NMKNjxTN9z--
