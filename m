Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:58410 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751861AbeAZIKM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 Jan 2018 03:10:12 -0500
Date: Fri, 26 Jan 2018 09:10:00 +0100
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
Subject: Re: [PATCH v6 2/2] media: V3s: Add support for Allwinner CSI.
Message-ID: <20180126081000.hy7g57zp5dv6ug2g@flea.lan>
References: <1516695531-23349-1-git-send-email-yong.deng@magewell.com>
 <201801260759.RyNhDZz4%fengguang.wu@intel.com>
 <20180126094658.aa70ed3f890464f6051e21e4@magewell.com>
 <20180126110041.f89848325b9ecfb07df387ca@magewell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="pcpp5ezbpwxtdyok"
Content-Disposition: inline
In-Reply-To: <20180126110041.f89848325b9ecfb07df387ca@magewell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--pcpp5ezbpwxtdyok
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 26, 2018 at 11:00:41AM +0800, Yong wrote:
> Hi Maxime,
>=20
> On Fri, 26 Jan 2018 09:46:58 +0800
> Yong <yong.deng@magewell.com> wrote:
>=20
> > Hi Maxime,
> >=20
> > Do you have any experience in solving this problem?
> > It seems the PHYS_OFFSET maybe undeclared when the ARCH is not arm.
>=20
> Got it.
> Should I add 'depends on ARM' in Kconfig?

Yes, or even better a depends on MACH_SUNXI :)

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--pcpp5ezbpwxtdyok
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlpq4lcACgkQ0rTAlCFN
r3QGmRAAhe2KBCEElFXdDNTvfXHIKAFj9SzsVR+pZziHsYVHDEycLIMEwBtclWtP
YE7rzQUVyZJ0Jq4Z1blR7tSHkuhKeKdR6CbuuZNhA0GRyQSPkbxz4c0K4z8zOzJi
roFdOLJ9AfZF4jTZ0pEof0AIIxJiMlxRjySilsHVJZ7lMYY7ztjfzKK7vQ64jCmR
o6aBGZ7xC1/F8GaihZMk4d2Uoil8HCVuN8UoJlNITo5W64krM81KuhPUoj8AiF4P
DcVIQ0KMVC4sz8PhNFMo+kfJA8DQ2VQpeV4pMc8mJef9vaIigg1rT8ZuY2FCs2IU
P3Tx02jxR7SZKPbS4heX17LeXyYvVKlBHSX256oo6CKQ3bQGNlZ30E2LnJb5XeCm
hsVg8F34DSvUpZPwwJbB5Jv/rDRnrQqxtHDF5PoMRDEkMLJoOUmFfBEOh4l6x2w4
uq0FHKFo2rlGeBCPCZPxWzZXkoiB/kgpzRpDneBTDPkY5Ml7m0ro6XLKkHXdDOrc
TS7tdRczD/Iu/mNuNPe+km5NhXedje8+CiRSpid1RoTdoh9i7HLqtYWveAeVHwvS
lNumk5v3F4/q5DAf8wxzNlNeHZAJVZ0oZIGpfeJHKfP0z8r5MMMMGIuNtyHi4JNh
Er2zgxzFRbTibE9xpbiRUqmcGq12w43CdjsLruUsySx3KjgsHzw=
=yjb1
-----END PGP SIGNATURE-----

--pcpp5ezbpwxtdyok--
