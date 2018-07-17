Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:45647 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729741AbeGQNkL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Jul 2018 09:40:11 -0400
Date: Tue, 17 Jul 2018 15:07:30 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v6 0/10] rcar-vin: Add support for parallel input on Gen3
Message-ID: <20180717130730.GQ8180@w540>
References: <1528796612-7387-1-git-send-email-jacopo+renesas@jmondi.org>
 <20180702181104.GZ5237@bigcity.dyn.berto.se>
 <20180703180210.GB5611@w540>
 <e941e6c9-9509-2128-c2ea-8a78cee515bd@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="r7tUYVWcdYzDJoZW"
Content-Disposition: inline
In-Reply-To: <e941e6c9-9509-2128-c2ea-8a78cee515bd@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--r7tUYVWcdYzDJoZW
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

HI Hans,

On Tue, Jul 17, 2018 at 03:00:20PM +0200, Hans Verkuil wrote:
> On 03/07/18 20:02, jacopo mondi wrote:
> > Hi Hans,
> >    As the VIN driver went through your tree, could you please pick
> > this series up now that all patches have been acked-by/reviewed-by and
> > tested on several platforms?
> >
> > Thank you...
>
> This got merged about 2 weeks ago. You were CC-ed on my pull request...

In facts, my original email was from 3rd of July :D

>
> Regards,
>
> 	Hans
>
> >
> > On Mon, Jul 02, 2018 at 08:11:04PM +0200, Niklas S=C3=B6derlund wrote:
> >> Hi Jacopo,
> >>
> >> Nice work, I'm happy with the work you have done thanks!
> >>
> >> I have tested this series on M3-N to make sure it don't break anything
> >> on existing Gen3. Tested on V3M to make sure you can switch between
> >> CSI-2 and parallel input at runtime. And last I tested it on Koelsch to
> >> make sure Gen2 still works. All tests looks good.
> >>
> >> Thanks for your effort!
> >
> > Thanks for doing this Niklas...
> >
> > With your recent testing this series has been tested on:
> >
> > D3: parallel input
> > M3W: parallel and CSI-2
> > M3N: CSI-2
> > V3M: parallel and CSI-2
> > Gen2 Koelsch: parallel
> >
> > I guess is then good to go.
> >
> > Thanks
> >    j
> >
> >
> >>
> >> On 2018-06-12 11:43:22 +0200, Jacopo Mondi wrote:
> >>> Hello,
> >>>    this series adds support for parallel video input to the Gen3 vers=
ion of
> >>> rcar-vin driver.
> >>>
> >>> Few changes compared to v5, closing a few comments from Kieran and Ni=
klas,
> >>> and fixed the label names I forgot to change in previous version.
> >>>
> >>> Changlog in the individual patches when relevant.
> >>>
> >>> A few patches have not yet been acked-by, but things look smooth and =
we
> >>> should be close to have this finalized.
> >>>
> >>> Thanks
> >>>    j
> >>>
> >>> Jacopo Mondi (10):
> >>>   media: rcar-vin: Rename 'digital' to 'parallel'
> >>>   media: rcar-vin: Remove two empty lines
> >>>   media: rcar-vin: Create a group notifier
> >>>   media: rcar-vin: Cleanup notifier in error path
> >>>   media: rcar-vin: Cache the mbus configuration flags
> >>>   media: rcar-vin: Parse parallel input on Gen3
> >>>   media: rcar-vin: Link parallel input media entities
> >>>   media: rcar-vin: Handle parallel subdev in link_notify
> >>>   media: rcar-vin: Rename _rcar_info to rcar_info
> >>>   media: rcar-vin: Add support for R-Car R8A77995 SoC
> >>>
> >>>  drivers/media/platform/rcar-vin/rcar-core.c | 265 ++++++++++++++++++=
----------
> >>>  drivers/media/platform/rcar-vin/rcar-dma.c  |  36 ++--
> >>>  drivers/media/platform/rcar-vin/rcar-v4l2.c |  12 +-
> >>>  drivers/media/platform/rcar-vin/rcar-vin.h  |  29 +--
> >>>  4 files changed, 223 insertions(+), 119 deletions(-)
> >>>
> >>> --
> >>> 2.7.4
> >>>
> >>
> >> --
> >> Regards,
> >> Niklas S=C3=B6derlund
>

--r7tUYVWcdYzDJoZW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbTeoSAAoJEHI0Bo8WoVY8pvgP/1ENkTRYVzAjGWtihOlZQO6z
9USTOZLiT1KVnLmb5yMjllQWLt1AnEhxt0zKyejSA5CgwfeQu8d0DKq5Ux9mZjE8
8hlkHaaFeGmzNuqreTwbZ//0aBbDtZtN0L9bC34YZSTstapbIaRhn/8Rj0SP3N23
hd7TCyLP4xA6gB9aIkmE/QGuvaf6ZHy9MFO0SJORhLsyiObp6qPZhWn9UxR6Bz+S
0hG2sGQuNz86/LWmmkxD0K8Rjx/5xDG3W6jdoATj1UicVKmUyFOP9aKfG/tUvyXl
pi17B+lJxP/rr0yxlmK96mHRC7xQI8Ow9GutGcndfCoq7J/4oiTv1+EPFP2ZlNIx
+o20DI+TlxLrXEwZ1FgvJvroJM/ffTjNQASGScP+q/kb0UAB0IWf/s7PVtFWRjaJ
pr7gujmPm1zuq99pvyfEfcpqVreb+RtkfMKxM7GGziywyorLXQxRnRPXGb43iFDv
Gu1hcK4wZLJvw8D/vYBpLc+/ki6k1cYnjB1ygh52YA/KvMUDzhCRQvG0zG3ZRmnE
ma2LybbEzo1Kq/RmvDrau1rDLnCJA9K+wSbJa7gq+dd12FIMUJr+c/6KP+UpDFo+
61+IMNbMHS2bi5l1nSjtObnWfg3GuNXiodv8PI5lbe0RaonErflmADeBzdeCF5cH
YQ6n3hQWMF8nc+n8+XZN
=IRk+
-----END PGP SIGNATURE-----

--r7tUYVWcdYzDJoZW--
