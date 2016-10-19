Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43481 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941157AbcJSOvr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Oct 2016 10:51:47 -0400
Date: Wed, 19 Oct 2016 13:15:07 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        mark.rutland@arm.com, mchehab@kernel.org, davem@davemloft.net,
        geert@linux-m68k.org, akpm@linux-foundation.org,
        kvalo@codeaurora.org, linux@roeck-us.net, hverkuil@xs4all.nl,
        lars@metafoo.de, robert.jarzmik@free.fr, slongerbeam@gmail.com,
        dheitmueller@kernellabs.com, pali.rohar@gmail.com,
        CARLOS.PALMINHA@synopsys.com
Subject: Re: [PATCH v3 2/2] Add support for Omnivision OV5647
Message-ID: <20161019111507.GJ1461@amd>
References: <cover.1476286687.git.roliveir@synopsys.com>
 <17092ffede9eb8aff0d6a7f54ca771e81712b18e.1476286687.git.roliveir@synopsys.com>
 <20161018183133.GA26548@amd>
 <375952b7-7993-b23a-10e8-85cba64b2679@synopsys.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="DesjdUuHQDwS2t4N"
Content-Disposition: inline
In-Reply-To: <375952b7-7993-b23a-10e8-85cba64b2679@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--DesjdUuHQDwS2t4N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> >> +struct regval_list {
> >> +	uint16_t addr;
> >> +	uint8_t data;
> >> +};
> > u8/u16?
>=20
> This sensor uses 16 bits for addresses and 8 for data, so I think it make=
s sense
> to keep it this way.

Yes, you can do it. But please use u8/u16 types (also elsewhere in the
driver), they are more common in ther kernel.

> Thanks for the feedback. I agree with most of your suggestions, and I com=
mented
> with the one I didn't agree.

You are welcome,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--DesjdUuHQDwS2t4N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlgHVbsACgkQMOfwapXb+vIqRACaAq+7Hp9YvGuFu/wr/xv5tELL
fXkAoJMjYem/ivW8JHsoikGWAnou1KZU
=NJ5J
-----END PGP SIGNATURE-----

--DesjdUuHQDwS2t4N--
