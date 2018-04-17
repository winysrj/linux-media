Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:37005 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753695AbeDQQBY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Apr 2018 12:01:24 -0400
Date: Tue, 17 Apr 2018 18:01:22 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Samuel Bobrowicz <sam@elite-embedded.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hugues Fruchet <hugues.fruchet@st.com>
Subject: Re: [PATCH v2 00/12] media: ov5640: Misc cleanup and improvements
Message-ID: <20180417160122.rfdlbdafmivgi5cd@flea>
References: <20180416123701.15901-1-maxime.ripard@bootlin.com>
 <CAFwsNOF6t-AAXr8gEBLnCx2OF-PjAWALhsJRVYHSdnaP9hswWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="nvduvdu2mhoyi34d"
Content-Disposition: inline
In-Reply-To: <CAFwsNOF6t-AAXr8gEBLnCx2OF-PjAWALhsJRVYHSdnaP9hswWA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nvduvdu2mhoyi34d
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 16, 2018 at 04:22:39PM -0700, Samuel Bobrowicz wrote:
> I've been digging around the ov5640.c code for a few weeks now, these
> look like some solid improvements. I'll give them a shot and let you
> know how they work.

Great, thanks!

> On that note, I'm bringing up a module that uses dual lane MIPI with a
> 12MHz fixed oscillator for xclk (Digilent's Pcam 5c). The mainline
> version of the driver seems to only support xclk of 22MHz (or maybe
> 24MHz), despite allowing xclk values from 6-24MHz. Will any of these
> patches add support for a 12MHz xclk while in MIPI mode?

My setup has a 24MHz crystal, and work with a parallel bus so I
haven't been able to test yours. However, yeah, I guess my patches
will improve your situation a lot.

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--nvduvdu2mhoyi34d
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlrWGlEACgkQ0rTAlCFN
r3Qapg//QmxLVwelJnlnpxqagmS11IN5GYQH84f8j2+GFVhz7qefYF+BN2v+y3nl
tA6wivM9b4fIHnxHTxJr+FoQzg3T4y+anBcZ/4OBT6HSH2IdFkMKTmZ0jWJhV2b8
eH05rB3wJldB3mQLgR+xf+8c3nyhisfqRhAyIKAiF3w2GYjqAdQu7rPZRj/ccvPU
B1nn7Myl3VSvfd0UKw+gzi6QEyb/FyTSQbjZltu37rri8GrXhY0H+izYXfLtl8bL
2qixdCJEwIm5C92K+fnze5I8r1Ix3kZNw119zTEJVSAEwJA0iXkQ7Taouc9LxaMp
8CScmrAaBdAfVVKZ4zbHv89Cq2S2XcDaHI8Ry/gDNyojd8t611bpXoI6LAPwIn2/
38GpezU4LqhJxWGD9qrMl2Maiv7dzW3qijiNGQYUyxJPT+VYAWiG8vPYjaf06IF6
OHjdqVCrxfGAkHtirdgI/RYe0uPluqF+C4JPaimJUbGmL2DSATgwW6eyJjop+Ik5
XHHRQM76XbHGUqCd91w7/BTRusq0/wqrWI2FMV7L8TAX0utIH0HuH/Qe0jxXiATV
eRwJYpgZBJxR/hTiyDC+XePnOr8XaUngxwL1u0bdsFygmU15ZYtwU+6qVsXOy4sH
Poy9D5co4n6IbVjFFPCbCzH2dDmb5XZIV3gksOSrphsJCv1PnDk=
=gata
-----END PGP SIGNATURE-----

--nvduvdu2mhoyi34d--
