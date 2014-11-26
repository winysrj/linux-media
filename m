Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:55083 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752089AbaKZUkE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Nov 2014 15:40:04 -0500
Date: Wed, 26 Nov 2014 21:40:00 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Emilio Lopez <emilio@elopez.com.ar>,
	Mike Turquette <mturquette@linaro.org>,
	Lee Jones <lee.jones@linaro.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 1/9] clk: sunxi: Give sunxi_factors_register a
 registers parameter
Message-ID: <20141126204000.GM25249@lukather>
References: <1416749895-25013-1-git-send-email-hdegoede@redhat.com>
 <1416749895-25013-2-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bPrm2PuLP7ysUh6c"
Content-Disposition: inline
In-Reply-To: <1416749895-25013-2-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--bPrm2PuLP7ysUh6c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 23, 2014 at 02:38:07PM +0100, Hans de Goede wrote:
> Before this commit sunxi_factors_register uses of_iomap(node, 0) to get
> the clk registers. The sun6i prcm has factor clocks, for which we want to
> use sunxi_factors_register, but of_iomap(node, 0) does not work for the p=
rcm
> factor clocks, because the prcm uses the mfd framework, so the registers
> are not part of the dt-node, instead they are added to the platform_devic=
e,
> as platform_device resources.
>=20
> This commit makes getting the registers the callers duty, so that
> sunxi_factors_register can be used with mfd instantiated platform device =
too.
>=20
> While at it also add error checking to the of_iomap calls.
>=20
> This commit also drops the __init function from sunxi_factors_register si=
nce
> platform driver probe functions are not __init.
>=20
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Queued for 3.20, thanks!

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--bPrm2PuLP7ysUh6c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUdjqgAAoJEBx+YmzsjxAgw90P/24BUMHMvlZmonZnnOnkV3Xb
lfeg/Vxljbz5q1BvoTYdxyF7USkcs4eOPXNm5tVi6FTxTKalGwk2k9xPN7WF3DAa
qj8uGr6h4pWNLL+LFSKbxjBSDlSxmqux9drlSXGdWm340vBPDIQ0QSERdKG6SMY1
qSX8jg7P32PuFduxm8i63oEPgtuPJAXA4eTxNEkynoCk/p1JR863z2BYtbAyMOxV
ridtBUXXRx5FS36ZQgIvyZkpZVHHovvyyLm7PkqKp/4ZGUt7CDyBp4AXFG/USoyX
VnyKb2/3t49ZuTQHTvGbKetmGS01VPYvCu+i3kIjrDJuMlgqrIhZWsdtOwlo5mI2
uNDvAthko7oLgQ0xmHXYRgiVxxPgRIiiS/WQ+qwF+hPACbIrqs17ZyICOddfndT+
XooFFC22aZcXnNooIwlSJtUgoGqEmj/kSNuSXAdUi3zl+6a9uulYpTxhQCKwsnZe
nIadL4i1YrreJXxIdC1rliNb/7jiBCPgA6WOnIGegF8b6aNSAvBJu8/GhGFdlmDt
Foaa9qAGq5O0Zviiy01dYk7kTZtCL94PoifsYNUEdjoz07iSAx0fAm4UEJlqJ+ch
nnCYL36D3zmytyGHtexcVdGMAC9CEY4eIcGjMlRWTUSOFKfbnrLnzYfFsUVoEtRu
HjvKdo4PODhN1e1DLJ+I
=ijip
-----END PGP SIGNATURE-----

--bPrm2PuLP7ysUh6c--
