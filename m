Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:44904 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751562AbeAEO7Z (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Jan 2018 09:59:25 -0500
Date: Fri, 5 Jan 2018 15:59:13 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Sean Young <sean@mess.org>
Cc: Philipp Rossak <embed3d@gmail.com>, mchehab@kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, wens@csie.org,
        linux@armlinux.org.uk, p.zabel@pengutronix.de,
        andi.shyti@samsung.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH v3 0/6] arm: sunxi: IR support for A83T
Message-ID: <20180105145913.ddb5l5dyt7yn3kwc@flea.lan>
References: <20171219080747.4507-1-embed3d@gmail.com>
 <20180105120253.zvwaz25scuk76bnt@gofer.mess.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="etu2d3krdpaqtjtv"
Content-Disposition: inline
In-Reply-To: <20180105120253.zvwaz25scuk76bnt@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--etu2d3krdpaqtjtv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jan 05, 2018 at 12:02:53PM +0000, Sean Young wrote:
> On Tue, Dec 19, 2017 at 09:07:41AM +0100, Philipp Rossak wrote:
> > This patch series adds support for the sunxi A83T ir module and enhance=
s=20
> > the sunxi-ir driver. Right now the base clock frequency for the ir driv=
er
> > is a hard coded define and is set to 8 MHz.
> > This works for the most common ir receivers. On the Sinovoip Bananapi M=
3=20
> > the ir receiver needs, a 3 MHz base clock frequency to work without
> > problems with this driver.
> >=20
> > This patch series adds support for an optinal property that makes it ab=
le
> > to override the default base clock frequency and enables the ir interfa=
ce=20
> > on the a83t and the Bananapi M3.
> >=20
> > changes since v2:
> > * reorder cir pin (alphabetical)
> > * fix typo in documentation
> >=20
> > changes since v1:
> > * fix typos, reword Documentation
> > * initialize 'b_clk_freq' to 'SUNXI_IR_BASE_CLK' & remove if statement
> > * change dev_info() to dev_dbg()
> > * change naming to cir* in dts/dtsi
> > * Added acked Ackedi-by to related patch
> > * use whole memory block instead of registers needed + fix for h3/h5
> >=20
> > changes since rfc:
> > * The property is now optinal. If the property is not available in=20
> >   the dtb the driver uses the default base clock frequency.
> > * the driver prints out the the selected base clock frequency.
> > * changed devicetree property from base-clk-frequency to clock-frequency
> >=20
> > Regards,
> > Philipp
> >=20
> >=20
> > Philipp Rossak (6):
> >   media: rc: update sunxi-ir driver to get base clock frequency from
> >     devicetree
> >   media: dt: bindings: Update binding documentation for sunxi IR
> >     controller
> >   arm: dts: sun8i: a83t: Add the cir pin for the A83T
> >   arm: dts: sun8i: a83t: Add support for the cir interface
> >   arm: dts: sun8i: a83t: bananapi-m3: Enable IR controller
> >   arm: dts: sun8i: h3-h8: ir register size should be the whole memory
> >     block
>=20
> I can take this series (through rc-core, i.e. linux-media), but I need an
> maintainer Acked-by: for the sun[x8]i dts changes (all four patches).

We'll merge them through our tree. We usually have a rather big number
of patches around, so we'd be better off avoiding conflicts :)

Philipp, can you resubmit the DTs as soon as -rc1 is out?

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--etu2d3krdpaqtjtv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlpPksAACgkQ0rTAlCFN
r3RDrg/+KxD34oD4gQYvZBYBCEEidx2XtW4AMRiBK9EOpCtHJfYuPU5oHb42whx8
55rZK8GS65FcQQ2LbS92shz4kvWSDr3KSeBH9lcOEacyoK9c7rdZnlzy2gzgOue8
kiJza6nXTn6Cqzih1ry5vghf3lPfsIJBuJXxdSYbKngINEQlUunxBxWzkEIQ1qW1
GyYJnJ31gxrtcxvAljsEQmnwVFzWqCRUZeI6KxS01QkOyE3vW2O+DlNamlentd62
sn3/CGGK+u/Zwzjwtzoa1TnQN+0feT4FRgJh8uYQYHJsYAidYJf4Aebe3RHvWabi
kPt++WNu5Sw5ew28QwrZeBfE2NPyJrmsKErTih6gsQyoUOSBmeWUA8cB1Smig/Jd
edoxFc1J5w56bfKXa10gpxBUpAR6tbRa6ATjeucAMam3sXbRK4ctA9ucnA9X68ej
029W2ZtXA62fV+iHIqYu58mPQViGAaeS7ky/in3zufbePyhWSc0Ctxgo0kouaInY
c6ufx1sfhUlAjI0xIEsdQ4n7dPiE+gWuvtjKWgyMjiKwwKBkdBblMRCLXJq4ithp
gJD7+Zq9R3wKd6Ws2fht4tT5Qbu4YrPk/UkPEEHuYwjilZYKuj+ihnB+n21Rv2UK
xZ7HOOBpiJ4LagbHF0gwL3WqWRVNlHtBhFjpiP1+whHufYtfG8M=
=L07m
-----END PGP SIGNATURE-----

--etu2d3krdpaqtjtv--
