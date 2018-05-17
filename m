Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:49807 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750938AbeEQLWJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 07:22:09 -0400
Date: Thu, 17 May 2018 13:22:07 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Daniel Mack <daniel@zonque.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Samuel Bobrowicz <sam@elite-embedded.com>,
        Steve Longerbeam <slongerbeam@gmail.com>
Subject: Re: [PATCH v3 00/12] media: ov5640: Misc cleanup and improvements
Message-ID: <20180517112207.lrcif2qwpkbiy2zs@flea>
References: <20180517085405.10104-1-maxime.ripard@bootlin.com>
 <645869ce-3cad-29e9-72ed-297a9e787c48@zonque.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="2wr63to2idfjy2jv"
Content-Disposition: inline
In-Reply-To: <645869ce-3cad-29e9-72ed-297a9e787c48@zonque.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--2wr63to2idfjy2jv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, May 17, 2018 at 11:24:04AM +0200, Daniel Mack wrote:
> Hi,
>=20
> On Thursday, May 17, 2018 10:53 AM, Maxime Ripard wrote:
> > Here is a "small" series that mostly cleans up the ov5640 driver code,
> > slowly getting rid of the big data array for more understandable code
> > (hopefully).
> >=20
> > The biggest addition would be the clock rate computation at runtime,
> > instead of relying on those arrays to setup the clock tree
> > properly. As a side effect, it fixes the framerate that was off by
> > around 10% on the smaller resolutions, and we now support 60fps.
> >=20
> > This also introduces a bunch of new features.
>=20
> I'd like to give this a try. What tree should this patch set be applied o=
n?
> I had no luck with media_tree/for-4.18-6.

Maybe it wasn't the latest after all, sorry. It's based on Sakari's
for-4.18-3 PR (67f76c65e94f).

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--2wr63to2idfjy2jv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlr9ZckACgkQ0rTAlCFN
r3TXmg/+PzTti2yeeEZA0raWV9DTklzMQU8srjomIPljJGYLKkLgA/FOamEa1x64
/Yv6duH+EmcDWbIj5KC3YHuSa+8zT/iecHuZ8/7gIxEZ4h8PR/zIOCX7JwxKkkp9
QJgVd/B8v9v0hN+Uw/JA9sjOj6TCt+hWc2XkDwP6M+5sXigwp0x7PoOB45snxl1L
MiT4U60W8138LMBGsboQN9Z3QlvxhkLqpUskdcRTLt7FpSMEMsbxCyuUflGR17YH
+eZh0EIcsCvYJPZZyoAAlN+/atcsEof/4K9EeJK6gEB0D6wkfOyj44HYxqNm3SVq
7hLibKTYqmJEZUMb3+IWJ1WhNLdjfmVutqhZKa0/B5/db+QA9G5V2tgMva6IcPN0
e7nAzmSDN4fZ/yRJ08Id5MbUIc/ckbpWZggPa1lKEIhhA8k4iE1WKFVeYFspmUek
1Ox4ftZKZ55CVqe5wWb6YRETRlg91r9SkVikbE6bLq1aaEHdjv16rTxMIzsK18k/
W3CsxBr2ZmIRx6jONO6tmFyq1v2D3i77NxaUAOF3mWo0KDub1QaBTYGQFP/xvWXx
Vv11LY62FOUPbmdxOhsRM7X1ekpDczJElVZhJlxV/sAL/FO/jvuLNX+bqRyb9PKO
jy1x8Ln7TCNsU8QIafOU/hUyvMhN3wXLn7kVu80pTRsMHULFoNI=
=l0PT
-----END PGP SIGNATURE-----

--2wr63to2idfjy2jv--
