Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:58315 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759699AbeD1Ny2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Apr 2018 09:54:28 -0400
Date: Sat, 28 Apr 2018 15:54:16 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v14 2/2] rcar-csi2: add Renesas R-Car MIPI CSI-2 receiver
 driver
Message-ID: <20180428135142.GA27261@w540>
References: <20180426202121.27243-1-niklas.soderlund+renesas@ragnatech.se>
 <20180426202121.27243-3-niklas.soderlund+renesas@ragnatech.se>
 <20180428112827.GF18201@w540>
 <20180428133114.GE14242@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="uZ3hkaAS1mZxFaxD"
Content-Disposition: inline
In-Reply-To: <20180428133114.GE14242@bigcity.dyn.berto.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--uZ3hkaAS1mZxFaxD
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Niklas,

On Sat, Apr 28, 2018 at 03:31:14PM +0200, Niklas S=C3=B6derlund wrote:
> Hi Jacopo,
>
> Thanks for your feedback.
>
> On 2018-04-28 13:28:27 +0200, Jacopo Mondi wrote:
> > Hi Niklas,
> >    apart from a small comment, as my comments on v13 have been
> >    clarified
> >
> > Reviewed-by: Jacopo Mondi <jacopo@jmondi.org>
>
> Thanks!
>
> [snip]
>
> > > diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c
> > > b/drivers/media/platform/rcar-vin/rcar-csi2.c
> > > new file mode 100644
> > > index 0000000000000000..49b29d5680f9d80b
> > > --- /dev/null
> > > +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> > > @@ -0,0 +1,883 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +/*
> > > + * Driver for Renesas R-Car MIPI CSI-2 Receiver
> > > + *
> > > + * Copyright (C) 2018 Renesas Electronics Corp.
> > > + */
>
> [snip]
>
> > > +MODULE_AUTHOR("Niklas S=C3=B6derlund <niklas.soderlund@ragnatech.se>=
");
> > > +MODULE_DESCRIPTION("Renesas R-Car MIPI CSI-2 receiver");
> > > +MODULE_LICENSE("GPL");
> >
> > This doesn't match the SPDX header that reports GPL-2.0
>
> I'm now officially more confused then normal :-) I really tried to get
> this right and the combination I use here
>
>     // SPDX-License-Identifier: GPL-2.0
>     MODULE_LICENSE("GPL");
>
> Seems to be used all over the kernel, did some digging on the master
> branch of the media tree from a few days ago and found 265 files with
> this combination using this script:
>
>     count=3D0
>     for f in $(git grep -l "SPDX-License-Identifier: GPL-2.0$"); do
> 	    if grep -q 'MODULE_LICENSE("GPL")' $f; then
>                 echo $f
>                 grep SPDX-License-Identifier $f
>                 grep MODULE_LICENSE $f;
>                 count=3D$(($count + 1))
> 	    fi
>     done
>     echo "Count: $count"
>
> I'm happy to post a new version of this series to make this right but
> I'm afraid that I at this point know what right is. My intention is to
> replace a licence text found in an old Renesas BSP which this work is
> loosely based on:
>
>     * This program is free software; you can redistribute it and/or modify
>     * it under the terms of the GNU General Public License version 2 as
>     * published by the Free Software Foundation.
>
> So it's quiet clear it's GPL-2.0 and not GPL-2.0+ and AFIK what I have do=
ne
> here is correct, please tell me why I'm wrong and how I can correct it :-)
>

I was just expecting to see "GPL v2" if the SPDX identifier reports
GPL-2.0

Maybe that's not even a thing, anyway, do not waste any time on this,
it a very minor nit.

Thank you
  j

> --
> Regards,
> Niklas S=C3=B6derlund

--uZ3hkaAS1mZxFaxD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJa5H0IAAoJEHI0Bo8WoVY84m4P/3Lt0hi0TgVsVuGDuXrEkgkq
8d3T/I6R68q+X2rnAmH/JhptQok6aF9dorpfzUvwrfPxQREb/5ni5tmK5OBEAKh2
isoJC2WVs0j8oHugbTBG65SrcV85PMV3dJZFPhnTvB0MmCnfupI96l6wQ1TEVV0X
Yns4VpPYCRhGgahR/tJKMPH2uxVtq+Y8KHfqtZzZSHhd+0BdXSvMvUFwUmG+nRaI
1TMvJayFtWS82TY0OqajQf1PwxjsyVVVT91m4Nah72NeYR9xIkhSqSFDVhxMh2KF
Zsvy2PSR7PREhIZ2YBJ1hWpK6709XWe4NI3aHOehSpHvhvIhAS1vq7jJhzp+Bebz
zvBljF+iXwknjEZsP5tqVEdbm2+JvFm8pQGXDLnDie8/Q3E/B9RtlRNm1B6vrNO/
/NvShy+vQOZsNdCHe0hdE7kMx3UxrUOS1MmycW5r4ojLepg6rR4V4PAuynAY1bvJ
Q6BVyZBYL9n9rvheZl/mrmqu0vvCbp2NJwquWhyYLNLWWNcnZGKrG2F2sEEYoPgI
rc31DW4E9nlXT7afX50TslJKR2U6JjrRqOIbP/p31+sB9N+Cf3oXN8QAGecobIII
naHB6d2GG7wCDJ2CfNtamLHM2lutTARCq5K1trhJHcnb5AwPu8OD6ZQWm7XYkBXf
pbCfuH+xZh/6VaZ8nra9
=AIao
-----END PGP SIGNATURE-----

--uZ3hkaAS1mZxFaxD--
