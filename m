Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:36458 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752331AbaLIIzF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Dec 2014 03:55:05 -0500
Date: Tue, 9 Dec 2014 09:51:37 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Chen-Yu Tsai <wens@csie.org>,
	Boris Brezillon <boris@free-electrons.com>,
	Mike Turquette <mturquette@linaro.org>,
	Emilio Lopez <emilio@elopez.com.ar>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi <linux-sunxi@googlegroups.com>
Subject: Re: [PATCH 3/9] clk: sunxi: Add prcm mod0 clock driver
Message-ID: <20141209085137.GQ8739@lukather>
References: <20141126211318.GN25249@lukather>
 <5476E3A5.4000708@redhat.com>
 <CAGb2v652m0bCdPWFF4LWwjcrCJZvnLibFPw8xXJ3Q-Ge+_-p7g@mail.gmail.com>
 <5476F8AB.2000601@redhat.com>
 <20141127190509.GR25249@lukather>
 <54787A8A.6040209@redhat.com>
 <20141202154524.GD30256@lukather>
 <547EDCA0.4040805@redhat.com>
 <20141207180808.GO12434@lukather>
 <54855EF6.1000900@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6tPipYVl+OcoAvSh"
Content-Disposition: inline
In-Reply-To: <54855EF6.1000900@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--6tPipYVl+OcoAvSh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 08, 2014 at 09:19:02AM +0100, Hans de Goede wrote:
> Hi,
>=20
> On 07-12-14 19:08, Maxime Ripard wrote:
> >On Wed, Dec 03, 2014 at 10:49:20AM +0100, Hans de Goede wrote:
>=20
> <snip>
>=20
> >>So it should not have a simple-bus compatible either, and as such we ca=
nnot
> >>simply change the mod0 driver from of_clk_define to a platform driver b=
ecause
> >>then we need to instantiate platform devs for the mod0 clock nodes, whi=
ch
> >>means making the clock node a simple-bus.
> >
> >I guess we can do that as a temporary measure until we get things
> >right on that front. I'm totally open to doing that work, so I'm not
> >asking you to do it.
> >
> >>I can see your logic in wanting the ir_clk prcm sub-node to use the
> >>mod0 compatible string, so how about we make the mod0 driver both
> >>register through of_declare and as a platform driver. Note this means
> >>that it will try to bind twice to the ir_clk node, since of_clk_declare
> >>will cause it to try and bind there too AFAIK.
> >
> >Hmmm, I could live with that for a while too. That shouldn't even
> >require too much work, since the first thing we check in the mod0 code
> >is that we actually have something in reg, which will not be the case
> >in the OF_CLK_DECLARE case.
> >
> >>The of_clk_declare bind will fail though because there is no regs
> >>property, so this double bind is not an issue as long as we do not
> >>log errors on the first bind failure.
> >
> >Yep, exactly.
> >
> >>Note that the ir_clk node will still need an "ir-clk" compatible as
> >>well for the MFD to find it and assign the proper resources to it.
> >
> >No, it really doesn't. At least for now, we have a single mod0 clock
> >under the PRCM MFD. If (and only if) one day, we find ourselves in a
> >position where we have two mod0 clocks under the PRCM, then we'll fix
> >the MFD code to deal with that, because it really should deal with it.
>=20
> Ok, using only the mod0 compat string works for me. I'll respin my
> patch-set (minus the one patch you've already merged) to make the modo
> clk driver use both of_clk_declare and make it a platfrom driver, and
> use the mod0 compat string for the ir-clk node.
>=20
> Not sure when I'll get this done exactly though, but we still have
> a while before 3.20 :)

Indeed :)

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--6tPipYVl+OcoAvSh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUhrgZAAoJEBx+YmzsjxAgfxgP/Ai+4MRv3LfYb51Or8KwhtP8
D7y4sgMAIT+NoAq1iphaegBQ8F+A51nqcJL1KV86FTTHCNFv3AJVz71nrz4U0lOK
Eth+MiBfP626r7yhlzAAkMire9glwbBJCD4/S1OnDMo6Y1tN0u62Szl74GczFGUn
Vwvgs1bqpbB/M+4Ilb2itNofB2khH0VpkTKF5yI+CytWGkXwRTQldmGOaI3JaQqY
7waOMdZ/5gNuV2ZBvBZZ7dMcm27x7pa9uMtrmKWmR6AFsOb/oTruNKOZ+9wlNkQl
oXyY7c9olebjx1Xyb9q2v/Ny4fiUdK0weJvmJkOdNa+oeSqAG2DdCtCu/VAHWLXs
IYZ4p0yGw4KRmO/9BPT8jmMtubLgI22jciw0ZoeWHwQcJLAYEw/7EflSBQvv0uSV
RaKRyNZ4didaXHBc/W4e2ixS3PdgNXT6SXxfNPc5+er+wFNGlTNF+A9nNLmgHi1f
JVVkH7dFhnJ4CZqrSoBA07569FsY6KosygkO8pxDV3oHQ/VsO+SmyyYXkILV35Kt
5E04QwdB48BtWFFJLIck5aMiTQJ2iFPt5FiJNDC0eYLPn9i0zcj3L3EYPZtpNQfn
PL69YwSYgMCKqeD/u+nu9+/snL7E/jLFYdgOBJLVV5YH04ZuSfg7PEGhheKRiv00
QGfHDltIEd6J2wKF2ufv
=NJgj
-----END PGP SIGNATURE-----

--6tPipYVl+OcoAvSh--
