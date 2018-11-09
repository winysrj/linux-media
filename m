Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59196 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728287AbeKJIzd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Nov 2018 03:55:33 -0500
Message-ID: <cc85eba9b0c59a12729115d11aa18598127edabb.camel@decadent.org.uk>
Subject: Re: [PATCH v3.16 0/2] V4L2 event subscription fixes
From: Ben Hutchings <ben@decadent.org.uk>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Dave Stevenson <dave.stevenson@raspberrypi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, mchehab@kernel.org,
        linux-media@vger.kernel.org
Date: Fri, 09 Nov 2018 23:12:37 +0000
In-Reply-To: <20181108120350.17266-1-sakari.ailus@linux.intel.com>
References: <20181108120350.17266-1-sakari.ailus@linux.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-MXIiHkCNeXALG+O4goKT"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-MXIiHkCNeXALG+O4goKT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2018-11-08 at 14:03 +0200, Sakari Ailus wrote:
> Hi Ben,
>=20
> The two patches fix a use-after-free issue in V4L2 event handling. The
> first patch that fixes that issue is already in the other stable trees (a=
s
> well as Linus's tree) whereas the second that fixes a bug in the first
> one, is in the media tree only as of yet.

Thanks.  I'll apply the first now and hold the second until the
corresponding commit gets into Linus's tree.

Ben.

> <URL:https://git.linuxtv.org/media_tree.git/commit/?id=3D92539d3eda2c090b=
382699bbb896d4b54e9bdece>
>=20
> Sakari Ailus (2):
>   v4l: event: Prevent freeing event subscriptions while accessed
>   v4l: event: Add subscription to list before calling "add" operation
>=20
>  drivers/media/v4l2-core/v4l2-event.c | 63 ++++++++++++++++++++----------=
------
>  drivers/media/v4l2-core/v4l2-fh.c    |  2 ++
>  include/media/v4l2-fh.h              |  1 +
>  3 files changed, 38 insertions(+), 28 deletions(-)
>=20
--=20
Ben Hutchings
Knowledge is power.  France is bacon.



--=-MXIiHkCNeXALG+O4goKT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAlvmFGUACgkQ57/I7JWG
EQmSohAAuOiNz6oJLl1L3odsxJtVN9ZmkzvQnHFHf7cP4EypHitCOLpyYmr2naEM
KOgdn5vut7s79P7PxvhKp/kw2pgTmHsKWBW9bCpJtBnG0d0Scg1vd8t6Gxe6ETPL
/RExAgUid93840rhzxzGauPRKDwqqXjLFG9OG/fMOUpCDroxrMml66kCei+ZnfLH
N08Rnd/IMvQRoyaCfWt867V/8Qq6lS2oUzKRIO25+cSYSgVrNRJRApfiCjqKbrZN
zV3C+w4R95jdC7uhRRIw3QlFxsc/yPuPofDc44Xpo+cqG1IdNx6tJvMqlXEpe729
CEXmp3Ut7A+IQ8A0EvDRrVGP6ubrV4sJdhlbY24ZoDRZG7P2BEv0boJy0TSYsuOS
0MX6MQMTc/Wg6AG7sm3/8IlI17nP5avDR++wo6Dp593VaaJfxQXDNP7I7HQ0cSn+
+poMYAidwJilVHtRZiF1iS3LVsWZdBpexJUoS4gAaokXFXK92TNBKMdpxlVErysD
dJloBqqgUWDwphv7de27ZurK5xetKCdU6YtucY+PT8VzpPMG1Dis3G18R+efcv8v
05L4LYYQ6bSPZ38ZZ/1u1l40Y40P3r/88zj7tEcCHnDI5hxgnoizvP3F/IsDApt9
Y8ethKL2ZA+kXC5W/UjogeKR6bLyf1T4ocPtwSubKwveA1cp2us=
=t5Pi
-----END PGP SIGNATURE-----

--=-MXIiHkCNeXALG+O4goKT--
