Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:34051 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934187AbeGCSCR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Jul 2018 14:02:17 -0400
Date: Tue, 3 Jul 2018 20:02:10 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v6 0/10] rcar-vin: Add support for parallel input on Gen3
Message-ID: <20180703180210.GB5611@w540>
References: <1528796612-7387-1-git-send-email-jacopo+renesas@jmondi.org>
 <20180702181104.GZ5237@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="8GpibOaaTibBMecb"
Content-Disposition: inline
In-Reply-To: <20180702181104.GZ5237@bigcity.dyn.berto.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--8GpibOaaTibBMecb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Hans,
   As the VIN driver went through your tree, could you please pick
this series up now that all patches have been acked-by/reviewed-by and
tested on several platforms?

Thank you...

On Mon, Jul 02, 2018 at 08:11:04PM +0200, Niklas S=C3=B6derlund wrote:
> Hi Jacopo,
>
> Nice work, I'm happy with the work you have done thanks!
>
> I have tested this series on M3-N to make sure it don't break anything
> on existing Gen3. Tested on V3M to make sure you can switch between
> CSI-2 and parallel input at runtime. And last I tested it on Koelsch to
> make sure Gen2 still works. All tests looks good.
>
> Thanks for your effort!

Thanks for doing this Niklas...

With your recent testing this series has been tested on:

D3: parallel input
M3W: parallel and CSI-2
M3N: CSI-2
V3M: parallel and CSI-2
Gen2 Koelsch: parallel

I guess is then good to go.

Thanks
   j


>
> On 2018-06-12 11:43:22 +0200, Jacopo Mondi wrote:
> > Hello,
> >    this series adds support for parallel video input to the Gen3 versio=
n of
> > rcar-vin driver.
> >
> > Few changes compared to v5, closing a few comments from Kieran and Nikl=
as,
> > and fixed the label names I forgot to change in previous version.
> >
> > Changlog in the individual patches when relevant.
> >
> > A few patches have not yet been acked-by, but things look smooth and we
> > should be close to have this finalized.
> >
> > Thanks
> >    j
> >
> > Jacopo Mondi (10):
> >   media: rcar-vin: Rename 'digital' to 'parallel'
> >   media: rcar-vin: Remove two empty lines
> >   media: rcar-vin: Create a group notifier
> >   media: rcar-vin: Cleanup notifier in error path
> >   media: rcar-vin: Cache the mbus configuration flags
> >   media: rcar-vin: Parse parallel input on Gen3
> >   media: rcar-vin: Link parallel input media entities
> >   media: rcar-vin: Handle parallel subdev in link_notify
> >   media: rcar-vin: Rename _rcar_info to rcar_info
> >   media: rcar-vin: Add support for R-Car R8A77995 SoC
> >
> >  drivers/media/platform/rcar-vin/rcar-core.c | 265 ++++++++++++++++++--=
--------
> >  drivers/media/platform/rcar-vin/rcar-dma.c  |  36 ++--
> >  drivers/media/platform/rcar-vin/rcar-v4l2.c |  12 +-
> >  drivers/media/platform/rcar-vin/rcar-vin.h  |  29 +--
> >  4 files changed, 223 insertions(+), 119 deletions(-)
> >
> > --
> > 2.7.4
> >
>
> --
> Regards,
> Niklas S=C3=B6derlund

--8GpibOaaTibBMecb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbO7oiAAoJEHI0Bo8WoVY8/YsP/0Zjj02WLBGhUbAgDDP18Fxl
ucUZbjOgI+RziexbEwJYKkR1UiYtk+KjMUqLQp24N9erGuiz8LGA7VtFQeNZvSDB
vA5I+8Hmikgf8OWIVTP9KBubMdAqCA25u9e9WYW7eMGKqNBj3T8AjJnNFoS9gJZ2
IBwNJGP1LNtgDg9d2c1TmRfoUUjYQy5oG2ncvvzf6hUIHbUj/fN5sPX9J2qx0QoY
l1lhBXf/RDK8g9UwkF1HHSm0bSZ6B1u85QbBpVFYzVOgfd1HyK7GbCfwmD5wsRal
RXYDG93BRXcEOE9O7ZIEHZJIrZkbyNVekUKzMOIBEANTi3NTbURXtHrptSGwrQfu
eWbbp9mHq9TvnlGk+pGN1rQnoNqkql8INemJjPdQalGgnOt4YpJK+4wJQgtJR2cZ
2NjZ193FycWArjLqbXpzEWnYuuA3A+zBe7Ec028Zauiza77KVN2IP+IwJRL9Uo1K
2QUOAlFe+Q8q+RKEnz6BQ4qLuaNUU4TzikM4gjvwNxd7CH6Hf50iUUGRwXCy5fTM
js50mNooaztJLoTnbnON10kxxNMYdl0EgJvIT9PYFVaPdRfLBeutkYRKcLZhJu45
o4iUV77xf92npAlrVE0drNvZkq92mzVajotWT9S7NtapdmOI4UQVDyD4t9xLFRpN
OQOi0E8jicY6ahswTBS6
=cB2w
-----END PGP SIGNATURE-----

--8GpibOaaTibBMecb--
