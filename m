Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:35006 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750836AbaK0TUE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Nov 2014 14:20:04 -0500
Date: Thu, 27 Nov 2014 20:15:52 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Boris Brezillon <boris@free-electrons.com>,
	Mike Turquette <mturquette@linaro.org>,
	Chen-Yu Tsai <wens@csie.org>,
	Emilio Lopez <emilio@elopez.com.ar>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com
Subject: Re: [PATCH 3/9] clk: sunxi: Add prcm mod0 clock driver
Message-ID: <20141127191552.GS25249@lukather>
References: <54743DE1.7020704@redhat.com>
 <20141126211318.GN25249@lukather>
 <20141127174056.6697cde3@bbrezillon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="b2ktwntdbf0dPnbx"
Content-Disposition: inline
In-Reply-To: <20141127174056.6697cde3@bbrezillon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--b2ktwntdbf0dPnbx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 27, 2014 at 05:40:56PM +0100, Boris Brezillon wrote:
> Hi,
>=20
> On Wed, 26 Nov 2014 22:13:18 +0100
> Maxime Ripard <maxime.ripard@free-electrons.com> wrote:
>=20
> [...]
>=20
> >=20
> > I remember someone (Chen-Yu? Boris?) saying that the 1wire clock was
> > not really a mod0 clk. From what I could gather from the source code,
> > it seems to have a wider m divider, so we could argue that it should
> > need a new compatible.
>=20
> Wasn't me :-).
>=20
> Regarding the rest of the discussion I miss some context, but here's
> what I remember decided us to choose the MFD approach for the PRCM
> block:
>=20
> 1) it's embedding several unrelated functional blocks (reset, clk, and
> some other things I don't remember).
> 2) none of the functionalities provided by the PRCM were required in
> the early boot stage
> 3) We wanted to represent the HW blocks as they are really described in
> the memory mapping instead of splitting small register chunks over the
> DT.
>=20
> Can someone sum-up the current issue you're trying to solve ?

There's (at least) one module0 clock exposed in the PRCM block. We
have a disagreement on whether all module0 clocks should be platform
drivers to support probing that one clock or just to introduce a new
compatible for that one clock in the PRCM alone.

> IMHO, if you really want to split those functionalities over the DT
> (some nodes under clks and other under reset controller), then I
> suggest to use..............
> (Maxime, please stop smiling :P)
> ..............
>=20
> SYSCON

We don't really need to share anything, these components are isolated
in separate registers, so syscon doesn't really bring anything here.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--b2ktwntdbf0dPnbx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUd3hnAAoJEBx+YmzsjxAguroP/RApsrVYou2n37ozlE0Tvo9y
UP93n+pt6qozgUPIAYQs0BcYYXMQenYrz+URCBS/7+Wrzbv0rsalMzcCIrW5KnMO
62Kj1i14Mf7bE+U8hWvR/n08bhxbN9i7KLvelAA865ca12wYIaSmGwQBX8bsE8KD
ZrQ80mgOimkH1s9LdBCWEnlOee+mVu5uHI2GjoH4kNDrRMZu2NXgaoberTClaBvj
UU7Z4WR2oTDX4ADnrvxpF3VdkKbtetE34SW1zfKxRtYhuyoVEDnB/94Yw9gm/Ypf
f/KCOqSXg+xjj6qzCePDR5yvbcDTFS/lD+9vmW5iLeP7mwi9htUgIx0uX0/r6YHx
SMdazF0ZjWhNmXCtg7GPpoLb54OM8maKUL/VDifKAaqyBgW37xa4otF1MdiYUYm0
PKgtck/kXtoNB7kd3f4WiOL/17sVGJTPB/DFUWLqa6CuqZlUL5DzikS2h4u+nQAh
mhYwUNtKO6venM3jGp3Al5hBWJnLSBaXfV2GiccQq2v6rynECiicYF477x5Kzb6t
I9JPO7aAYBm31O5OtKypItkUhtG23gUXqyZSBS5b1XnQU80+1mm3fpt9AHYO0Mbo
yS66YR9c/ulyDfXvr9NbFBdiRdNA1FWVT37rdCINBGKtEW8H3vjsjbFlMcFdOcOj
QXZvu/COmfAenKUiX5Jj
=FX/1
-----END PGP SIGNATURE-----

--b2ktwntdbf0dPnbx--
