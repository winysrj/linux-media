Return-path: <linux-media-owner@vger.kernel.org>
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34170 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751498Ab3DVKDY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Apr 2013 06:03:24 -0400
Date: Mon, 22 Apr 2013 11:03:20 +0100
From: Mark Brown <broonie@kernel.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, Mike Turquette <mturquette@linaro.org>
Subject: Re: [GIT PULL FOR v3.10] Camera sensors patches
Message-ID: <20130422100320.GC30351@opensource.wolfsonmicro.com>
References: <3775187.HOcoQVPfEE@avalon>
 <20130417135503.GL13687@opensource.wolfsonmicro.com>
 <20130417113639.1c98f574@redhat.com>
 <1905734.rpqfOCmvCu@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yVhtmJPUSI46BTXb"
Content-Disposition: inline
In-Reply-To: <1905734.rpqfOCmvCu@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--yVhtmJPUSI46BTXb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 22, 2013 at 01:14:07AM +0200, Laurent Pinchart wrote:

> I think that Mark's point was that the regulators should be provided by=
=20
> platform code (in the generic sense, it could be DT on ARM, board code, o=
r a=20
> USB bridge driver for a webcam that uses the mt9p031 sensor) and used by =
the=20
> sensor driver. That's exactly what my mt9p031 patch does.

Yes, you understood me perfectly - to a good approximation the matching
up should be done by whatever the chip is soldered down to.

--yVhtmJPUSI46BTXb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRdQrTAAoJELSic+t+oim9UFQP/1gXeX/8D4K9s+K6b6/BAGK6
oq4y28M5kF3q93Mm9idy+TnQXJfAOArlb3pBbnwzzLhezOmC4RLPRAfwRTfOYk1l
CyZBg6mY4kOFernhQOTBYwMZKAEQ266g0+f1U4tRKGoyQy4chq+dRekNuecf3chr
m5VGMJ/0he3V/4zzLgDO/94p55O6zZ12PWfNA+J+DdXhbs4NJox3CLZf7RaT2DaS
Jl+bp6InE0OXGjcVc8zZaklNdZQOESIn2TBdQSB0E7SdaTXOidhQC0r2Cs7Q31qV
8LG+6l1gGb+oIQz3Zy/t7rEO/lKVks+RAwo9xWr6k8yzxGQO29wZ7K7pRC2TAEB/
xLAKFK+Thr4i/OUs8t5W8ZpPrcupjU5uxNppT/CwIWaknttI2z3QOmtOxparY6KT
05AHEh5ErA/PitNaLCjcyfWoC+HYPUQZyX3Mq9o2uXrrYHGjbHQ+/iiHJlbzMa/E
X/W8SFG8AXumd9VplYLR/2AGiCJD0ecFpjTP9zIyCu+MYwEaXFr1fo9YONptumSf
okUHCKE3hb1u2buw9j8f9arHwQHaPjTbqRIc5CWwDgx0URvq8uyo7GCJICLSSDdB
+QJ1ha6k6INELgeCx8noN4zF15CfcC/94WIBQQncyZrcdIhpwk9aMAjcWR4aanyH
aUMYuNdWXkR2I5FClymY
=s1jO
-----END PGP SIGNATURE-----

--yVhtmJPUSI46BTXb--
