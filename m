Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:50402 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933048AbeCEJqP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Mar 2018 04:46:15 -0500
Date: Mon, 5 Mar 2018 10:46:04 +0100
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Yong Deng <yong.deng@magewell.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>
Subject: Re: [PATCH 8/8] media: sun6i: Add g_parm/s_parm ioctl support
Message-ID: <20180305094604.ggbj6qhw73mkwn75@flea.lan>
References: <1519697113-32202-1-git-send-email-yong.deng@magewell.com>
 <20180305093535.11801-1-maxime.ripard@bootlin.com>
 <20180305093535.11801-9-maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="cmdx6xcdgkykjmm7"
Content-Disposition: inline
In-Reply-To: <20180305093535.11801-9-maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--cmdx6xcdgkykjmm7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 05, 2018 at 10:35:35AM +0100, Maxime Ripard wrote:
> Add a g_parm and s_parm callback in order to be able to control the sensor
> framerate of the sensor.
>=20
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>

Hmmm, that patch shouldn't have been there. This is an outdated
version based on Hans g_parm/s_parm rework that will not need this
anymore.

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--cmdx6xcdgkykjmm7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlqdEdsACgkQ0rTAlCFN
r3TuhA/+Pjr8NZpHMLm4u87KaugQ1YnLIDCn9vOKoQtLgAnTHUe5rnJodMgZfu3j
1wQS6w5I8uFsPl3ILqAnWIQXj5Fmu4+S8jZGK+qOvVjQyFr11HgP8+9bK37wv8sz
YYuSuz2DFfTdd/AVIv6sYLtnnQel8Fdut6ejTemhMwQvJvzjpHMB+DS/A8NkzXKz
RyURcULUHTj3QKxICvmB9fnGzTRxfR4Su2xuURtKIT22UA/WYw87iFtsdMkrNixg
vw5HkrFVy6gbOD1B2OFZUEoLvJwJdR/eRhGw+RLaRS3Tp7sEP00m2gGGZy/aVIQs
mW9rZ1Z+jfATeMCaxtLOFKfp5x6/w7i7wLPGRx8WqUuAvUP3KWisG2MlRFpygd1m
tk8XCXulaiOEYJmBKy4MbfmguOWz2ncFUI9C3U1jg4j4FtvJka+0fQPO020ftfWl
s0a2nrjKHAUtZhedH1+hSubwoXUngDQ9p/yBQwQ0kqd8jaf3IXm+IWM3mdqQeSa3
Ws+Dxm0J5bgXJH1XJGstCq4ipz3OBY790KTF8EVl5sSwwWArzB1/krbGiQ8SIyqk
iAedMQuEOaKo2eLs9g8/fT4lzcC8aOWaqOYncUrhyAXTjnEZuiwe6QflpR/K8nnO
UlCynqswi75pbKNA2VLlGNTAIOEBNMvlKPZOegdLEmioJbAo9AA=
=dQaQ
-----END PGP SIGNATURE-----

--cmdx6xcdgkykjmm7--
