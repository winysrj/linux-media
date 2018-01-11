Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:52488 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933867AbeAKN25 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 Jan 2018 08:28:57 -0500
Date: Thu, 11 Jan 2018 14:28:44 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Yong Deng <yong.deng@magewell.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
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
Subject: Re: [PATCH v5 2/2] media: V3s: Add support for Allwinner CSI.
Message-ID: <20180111132844.mok7upqjycpx3bqm@flea.lan>
References: <1515639966-35902-1-git-send-email-yong.deng@magewell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qi6zmi32vlsocdks"
Content-Disposition: inline
In-Reply-To: <1515639966-35902-1-git-send-email-yong.deng@magewell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--qi6zmi32vlsocdks
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Yong,

On Thu, Jan 11, 2018 at 11:06:06AM +0800, Yong Deng wrote:
> Allwinner V3s SoC features two CSI module. CSI0 is used for MIPI CSI-2
> interface and CSI1 is used for parallel interface. This is not
> documented in datasheet but by test and guess.
>=20
> This patch implement a v4l2 framework driver for it.
>=20
> Currently, the driver only support the parallel interface. MIPI-CSI2,
> ISP's support are not included in this patch.
>=20
> Signed-off-by: Yong Deng <yong.deng@magewell.com>

I've needed this patch in order to fix a NULL pointer dereference:
http://code.bulix.org/oz6gmb-257359?raw

This is needed because while it's ok to have a NULL pointer to
v4l2_subdev_pad_config when you call the subdev set_fmt with
V4L2_SUBDEV_FORMAT_ACTIVE, it's not with V4L2_SUBDEV_FORMAT_TRY, and
sensors will assume taht it's a valid pointer.

Otherwise,
Tested-by: Maxime Ripard <maxime.ripard@free-electrons.com>

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--qi6zmi32vlsocdks
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlpXZowACgkQ0rTAlCFN
r3RBZg//USq7b6GchJHfDFGqzld1WbkRYNVFWUjcVSB3Hfohd2Ed2fY8f0KXc+ae
QUWQcMqPG1Nt6kyo9ozvUY6RyqFJ52IpxwZNjU94bh303oOabaNndxJn/FZyAerf
kp0Yc1wyjXXeHp4BegCOJNmMlJaOtcox2SlSQn5f2+OwOjOXz7FgtIGAlVsjNqrj
pFYqCfc3sKMHp/44srpTlA78HTdKksfoKKDyr9DabSMyt9AGYOHXODxFoqo0JZAM
rpd0VVBRYpZ62ATLA3S1ht9oK4h7CtYN26kTO2bM4EIFpZu2gLJO2D+Ttt/3VRjy
AUoOtKigIcos9JQmbyX9URA9B//v+nMtgQMd3LQCcL9TLpFMqg9bqbMIv6p/DQ3w
XKxGEU4kn3wvEQ4IShQR6G6gSPbfSLBjVv+m42rIg4RK787DdEbRDiegPaRZxuwt
yNNJI6JxE5VO7GQRGEyiY7lXWdDLOuuD5SP4iXPtZF/vl4bc2P+X3Xs29odhAot5
bc++bP48pYRcsylkQ4zbAWcrOyTVJuSHMiICxXbPclMsjZft0VNGGrK087woH6tO
uEJrur62Gsx4gxB7I62NwXBfbL/N2mk8xOt0YM/tDQzeYMnUkJj0vj2M35sABfUX
dWG8l+/4M8OTxm0MK5/nIvuHliAn1m9iZV7TciZUOo+ATdHQvWw=
=vmr5
-----END PGP SIGNATURE-----

--qi6zmi32vlsocdks--
