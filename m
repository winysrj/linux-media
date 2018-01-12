Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:43111 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754273AbeALIhv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Jan 2018 03:37:51 -0500
Date: Fri, 12 Jan 2018 09:37:49 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Yong <yong.deng@magewell.com>
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
Subject: Re: [linux-sunxi] Re: [PATCH v5 2/2] media: V3s: Add support for
 Allwinner CSI.
Message-ID: <20180112083749.syxtwiigxafxw4zq@flea.lan>
References: <1515639966-35902-1-git-send-email-yong.deng@magewell.com>
 <20180111132844.mok7upqjycpx3bqm@flea.lan>
 <20180112095114.b2414fe44cff7bf7cf6f8822@magewell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mzjxflidhun7f3lz"
Content-Disposition: inline
In-Reply-To: <20180112095114.b2414fe44cff7bf7cf6f8822@magewell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--mzjxflidhun7f3lz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 12, 2018 at 09:51:14AM +0800, Yong wrote:
> Hi Maxime,
>=20
> On Thu, 11 Jan 2018 14:28:44 +0100
> Maxime Ripard <maxime.ripard@free-electrons.com> wrote:
>=20
> > Hi Yong,
> >=20
> > On Thu, Jan 11, 2018 at 11:06:06AM +0800, Yong Deng wrote:
> > > Allwinner V3s SoC features two CSI module. CSI0 is used for MIPI CSI-2
> > > interface and CSI1 is used for parallel interface. This is not
> > > documented in datasheet but by test and guess.
> > >=20
> > > This patch implement a v4l2 framework driver for it.
> > >=20
> > > Currently, the driver only support the parallel interface. MIPI-CSI2,
> > > ISP's support are not included in this patch.
> > >=20
> > > Signed-off-by: Yong Deng <yong.deng@magewell.com>
> >=20
> > I've needed this patch in order to fix a NULL pointer dereference:
> > http://code.bulix.org/oz6gmb-257359?raw
> >=20
> > This is needed because while it's ok to have a NULL pointer to
> > v4l2_subdev_pad_config when you call the subdev set_fmt with
> > V4L2_SUBDEV_FORMAT_ACTIVE, it's not with V4L2_SUBDEV_FORMAT_TRY, and
> > sensors will assume taht it's a valid pointer.
> >=20
> > Otherwise,
> > Tested-by: Maxime Ripard <maxime.ripard@free-electrons.com>
>=20
> I revisit some code of subdevs and you are right.
>=20
> Squash your patch into my driver patch and add your Tested-by in
> commit. Is it right?

Yep, that's perfect :)

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--mzjxflidhun7f3lz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlpYc90ACgkQ0rTAlCFN
r3T7pA//bfFwhPIWs/oOKJEc1kYHo4L7E14tSVm6nBiaCgEgn9kTTp+EHb8NaEmh
9lKPHYKc0PDTJiLyD3+TvHqZSVBaTc7/ZMFyC7IiKJn9W64sGQYVALrQSm8K3hfN
/Gocqb0rmLQ6qOOG3qWbpOMhmOXF7ohkggrkjCmRmvJK9OU3pPhf60z/1HzQa3EM
4zZmUsuJsg0Q8MVmfAIR54QTnt/PWvzTldL5mkW949Lgvo/Nzc7B+VnA4473V6So
xpRXLIhLGjoANf2Yw6bfkYxpc+bKllpCcde+xY5d2Wyq2QvOGmoYrpPidPxHMrL/
gqHkyHO8xO/tE9btkMzHnB83oBDl5eJZApWxEYYQYp4EME6JT9/9zNOhr5tYO6ib
RbZn+A+M0vIWHJCs9xlboLvy5/U0PqilJnKoDCptSFI3VuKD3rLvfPkycKtVSodR
K6BAkv+EJYJ6UxL/HrZ5AZQcKVRO4IUnLMR52wv3ErCrYeGrqmJ14vBTnAOtd1YJ
mBv9SxEJDKQSXlca9kM6E2u7SvklzD42CpVCHE5qWCXWcR1G0CUombO0k7alCV9w
Amn7dJeG+WO0/mbv8aNVeZPg7rpwQ8SFXf0LEstcmEV+07KC7KpEVA8KYYYxVPsY
CvDwK5WMIksqT8exWCZaDPnhwmqDUE3gjsHHnZex63aFK3bnM48=
=w89n
-----END PGP SIGNATURE-----

--mzjxflidhun7f3lz--
