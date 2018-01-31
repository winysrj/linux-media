Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:35442 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752910AbeAaHm3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Jan 2018 02:42:29 -0500
Date: Wed, 31 Jan 2018 08:42:12 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Liviu Dudau <liviu@dudau.co.uk>
Cc: Yong <yong.deng@magewell.com>, kbuild test robot <lkp@intel.com>,
        kbuild-all@01.org, Mauro Carvalho Chehab <mchehab@kernel.org>,
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
Message-ID: <20180131074212.7hvb3nqkt22h2chg@flea.lan>
References: <1516695531-23349-1-git-send-email-yong.deng@magewell.com>
 <201801260759.RyNhDZz4%fengguang.wu@intel.com>
 <20180126094658.aa70ed3f890464f6051e21e4@magewell.com>
 <20180126110041.f89848325b9ecfb07df387ca@magewell.com>
 <20180131030807.GA19945@bart.dudau.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="x2ob3palwahja4lz"
Content-Disposition: inline
In-Reply-To: <20180131030807.GA19945@bart.dudau.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--x2ob3palwahja4lz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Liviu,

On Wed, Jan 31, 2018 at 03:08:08AM +0000, Liviu Dudau wrote:
> On Fri, Jan 26, 2018 at 11:00:41AM +0800, Yong wrote:
> > Hi Maxime,
> >=20
> > On Fri, 26 Jan 2018 09:46:58 +0800
> > Yong <yong.deng@magewell.com> wrote:
> >=20
> > > Hi Maxime,
> > >=20
> > > Do you have any experience in solving this problem?
> > > It seems the PHYS_OFFSET maybe undeclared when the ARCH is not arm.
> >=20
> > Got it.
> > Should I add 'depends on ARM' in Kconfig?
>=20
> No, I don't think you should do that, you should fix the code.
>=20
> The dma_addr_t addr that you've got is ideally coming from dma_alloc_cohe=
rent(),
> in which case the addr is already "suitable" for use by the device (becau=
se the
> bus where the device is attached to does all the address translations).

Like we're discussing in that other part of the thread with Thierry
and Arnd, things are slightly more complicated than that :)

In our case, the bus where the device is attached will not do the
address translations, and shouldn't.

> If you apply PHYS_OFFSET forcefully to it you might get unexpected
> results.

Out of curiosity, what would be these unexpected results?

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--x2ob3palwahja4lz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlpxc1MACgkQ0rTAlCFN
r3R/Lw//ZA3imZaVQtgX/SzMgCsYQ8fcq/wOXFqNPVp8Du/Ce8QRO1Wu/rl6FU5q
LfeYJtMMz+/0rEN7HjX76gjJZ7t3w1aPL1rFIL5bwWeFmYjSVEup0BSCOmbO4NSu
Q1nPxal3Af/6JMp5upBb8oU0CDv+V8fQ1ca3BaTmX1doab87bgFtRE5qTCeXk/uF
PFtSGL3xbtdnwmCi4HCGk93VSxxF8dfzwmJ1CyBZCJEHF0wxAU/VkGpz7ngZR3x4
9WgPk7Rf9kXrSHdhluihy8aJd/A+91iE9ObzjzmYrsZ5dGjbDzPXQ6N2YsMtOxsL
RD9hwmG06X44jDzL28ArnBDKTZn4VgC6k258cDymK0vxmxmz+maAXpqT+AK2ckH9
3rzOK2EHE8bYVGSIWV9Jd/rCIGa4V6sR58YrAjaI9vlYdQtogKgd/S65a6Tr2oah
fzc3AHy4OJFhYWECCBAB4uUIMvuUYbnLHsBfPBFoecCUUdup+x2YCeEhv7Q82VKq
Cr7iYX9Q8Hy8ThOoCi6MXyhiy3RfL5zUMExNQfLfObGc57op0frLbXYfJ3C56jdu
ZW+YfV/h/5OpMUkpIF5QpOGw1aqIxMUi5MJUUkCIJa/u+q3CwHfnC1Sgq8lmrjjK
z0Enny5NG2Ni0DN5D1mLWnUQUZ2/2EcjSg8GcUWWm7dNLT/NSB4=
=4Z7h
-----END PGP SIGNATURE-----

--x2ob3palwahja4lz--
