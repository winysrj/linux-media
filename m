Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:56199 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753369AbeCFJeu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Mar 2018 04:34:50 -0500
Date: Tue, 6 Mar 2018 10:34:37 +0100
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Yong <yong.deng@magewell.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>
Subject: Re: [PATCH 0/7] media: sun6i: Various fixes and improvements
Message-ID: <20180306093437.5etrtg63bvzey3ue@flea.lan>
References: <1519697113-32202-1-git-send-email-yong.deng@magewell.com>
 <20180305093535.11801-1-maxime.ripard@bootlin.com>
 <20180305183535.b75ec79199efc3cacefc49c2@magewell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="waw4nwtslzohd7j3"
Content-Disposition: inline
In-Reply-To: <20180305183535.b75ec79199efc3cacefc49c2@magewell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--waw4nwtslzohd7j3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 05, 2018 at 06:35:35PM +0800, Yong wrote:
> > Hi Yong,
> >=20
> > Here are a bunch of patches I came up with after testing your last
> > (v8) version of the CSI patches.
> >=20
> > There's some improvements (patches 1 and 7) and fixes for
> > regressions found in the v8 compared to the v7 (patches 2, 3, 4 and
> > 5), and one fix that we discussed for the signals polarity for the
> > parallel interface (patch 6).
> >=20
> > Feel free to squash them in your serie for the v9.
>=20
> OK. Thank you!
>=20
> I notice that your responses have not been listed in google group
> since February.

Yeah, I know, apparently I can't change my email address in google
groups, or unsubscribe, so I'm not subscribed with my new mail, which
means I can't post either.

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--waw4nwtslzohd7j3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlqeYK0ACgkQ0rTAlCFN
r3RN0w//bKTwQ/jvd5lYlhMbqAZmQmpN/CG5qExy9rb/wbZHbp91tmUqQxs3EtjR
0x/6horQrf19m2kijtiv6D4SLcnj0V1gceup0qAxhQKgSb9qts4ZiGsqXVcQhsxI
lwl7IzV7d+fPRE2YZW7d00lC5of3cVB+1DJfGSaOcuqWo4WnLHusoRKk1oGkj0sK
0HLVXE+72ddCJMSMoXNCT/3T0ZLMx68rJrUGb98DM4509o2oIOj5y5w4L2SltTRp
jLID6pCvmUn8s0NSjORA9EGD5x6/xZSKWcDZMGofoeXmkpMdCg8Wj8tf6xKWAEm2
fM0zvohzIccoeykE9ohFQKXbp9YVxXeRYq2ADD98BCP6eXxhfz2sREXegRLt8RPu
30astpQ3bq3LcUBJrb5qX7KmjO4vgOZScjSwECXt1CTue6huHMT2awqOujiTi5E0
1LoEZ2WlEyZvT95D/KcEGD3etQQ8kILIxnEHnyzHD8g+y/H5F7KjCYm16JM3I1Fp
lKupNcg1F6AONqQPn4pJSsYMbagnt+TzOp47seDsKPl8vvh1sqm8wOXF+FbpGI7U
O0rJCdWCQliI1LFyJS9W+o1IL/dDo/wBCwdAfqMVcV6fcwfbQx7TvcjDrCfsTbu2
4dKZUTOpzlYmFK8XIIoVD1I+qDLdeDk/gYlXYlnRoFX59UQzcqM=
=cNMI
-----END PGP SIGNATURE-----

--waw4nwtslzohd7j3--
