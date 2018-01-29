Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:55546 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751256AbeA2IQX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Jan 2018 03:16:23 -0500
Date: Mon, 29 Jan 2018 09:16:21 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Yong <yong.deng@magewell.com>
Cc: kbuild test robot <lkp@intel.com>, kbuild-all@01.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Rick Chang <rick.chang@mediatek.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, megous@megous.com
Subject: Re: [linux-sunxi] Re: [PATCH v6 2/2] media: V3s: Add support for
 Allwinner CSI.
Message-ID: <20180129081621.ya2myroesthnwfjt@flea.lan>
References: <1516695531-23349-1-git-send-email-yong.deng@magewell.com>
 <201801260759.RyNhDZz4%fengguang.wu@intel.com>
 <20180126094658.aa70ed3f890464f6051e21e4@magewell.com>
 <20180126110041.f89848325b9ecfb07df387ca@magewell.com>
 <20180126081000.hy7g57zp5dv6ug2g@flea.lan>
 <20180128101903.fbaec083c787bda30aeb05ef@magewell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="iw4dp6rim5avyb7q"
Content-Disposition: inline
In-Reply-To: <20180128101903.fbaec083c787bda30aeb05ef@magewell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--iw4dp6rim5avyb7q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Jan 28, 2018 at 10:19:03AM +0800, Yong wrote:
> Hi Maxime,
>=20
> On Fri, 26 Jan 2018 09:10:00 +0100
> Maxime Ripard <maxime.ripard@free-electrons.com> wrote:
>=20
> > On Fri, Jan 26, 2018 at 11:00:41AM +0800, Yong wrote:
> > > Hi Maxime,
> > >=20
> > > On Fri, 26 Jan 2018 09:46:58 +0800
> > > Yong <yong.deng@magewell.com> wrote:
> > >=20
> > > > Hi Maxime,
> > > >=20
> > > > Do you have any experience in solving this problem?
> > > > It seems the PHYS_OFFSET maybe undeclared when the ARCH is not arm.
> > >=20
> > > Got it.
> > > Should I add 'depends on ARM' in Kconfig?
> >=20
> > Yes, or even better a depends on MACH_SUNXI :)
>=20
> Do you mean ARCH_SUNXI?

Yeah, sorry :)

> ARCH_SUNXI is alreay there. In the early version, my Kconfig is like this:
>=20
> 	depends on ARCH_SUNXI
>=20
> But Hans suggest me to change this to:
>=20
> 	depends on ARCH_SUNXI || COMPILE_TEST
>=20
> to allow this driver to be compiled on e.g. Intel for compile testing.
>=20
> Should we get rid of COMPILE_TEST?

Yes, it cannot be compiled as is on anything but ARM and a few
architectures. Or maybe something like || (COMPILE_TEST && ARM) if
that makes sense?

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--iw4dp6rim5avyb7q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlpu2FQACgkQ0rTAlCFN
r3RZHg//cy7CfvX7XFyXynIWEUHTD9P1X69zNJEq00kf5/uWN0XYT8p/1RibRpaC
61zZNKIVRJ8shOVE2iSn9p4BSly8o1Cbz3j+ITNZYRdN92oDHv6W2E2+0y9Yj91s
/B9y1sUFFwjrFzJC5zfnHTJLqbyY/gACrkdV4K94KLQbvP0e+3bzTQOnC6qW2q8p
OJuBOPh4BUpK11dYCmKTXNkrOuyCHMXAb1K76315Y5Wqau4ec2Rx3KvW6EnwxJmw
yMxIZC26ZV0DE3u3jB+ftxF1WyNrCMy1t3AH3c/3UzuC3simhgomRUnk/piVxkuO
EeerUVStUuwmpk1JdngNvevqp7xsY2QR2z8M83df1iPWHgrWtXambGUEo0foNgx5
bCNUH6ucA+ucpiL6wNM6x7QC9pXCfMJJU2gLwhCnBzlOXJwN9YD6DT7mewV9wwaL
4v23KSoq6KM4AGNMz+uiZxsBqzyntCFvCFFU+ejZHZO6rhXNUxZtOmSoOnUeQXiq
4CppzyMcDtN5uYSFi/D0+XXL6c1OBeHGwGF3AvMxHr2SwhNQIUcT5a67b6TWcZhJ
3xQ4vz7ViHZw173NQekDnUZrXYHvzcojYdGk8nZF09J57X7fdOdHl3rGYoS60wAK
lc651ShdnOYdYp22TiMnbP9do8/x7edmg9duhSsOaWJa7A+PRRA=
=1tpd
-----END PGP SIGNATURE-----

--iw4dp6rim5avyb7q--
