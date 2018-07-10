Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:55783 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751342AbeGJIVW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jul 2018 04:21:22 -0400
Message-ID: <c5e337620887838c2de702888bbed755f2c1d868.camel@bootlin.com>
Subject: Re: [PATCH v5 02/22] fixup! v4l2-ctrls: add
 v4l2_ctrl_request_hdl_find/put/ctrl_find functions
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, marco.franchi@nxp.com,
        icenowy@aosc.io, keiichiw@chromium.org,
        Jonathan Corbet <corbet@lwn.net>, smitha.t@samsung.com,
        tom.saeger@oracle.com, Andrzej Hajda <a.hajda@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        jacob-chen@iotwrt.com, Neil Armstrong <narmstrong@baylibre.com>,
        Benoit Parrot <bparrot@ti.com>,
        Todor Tomov <todor.tomov@linaro.org>, acourbot@chromium.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        posciak@chromium.org,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>, samitolvanen@google.com,
        Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        hugues.fruchet@st.com, ayaka@soulik.info
Date: Tue, 10 Jul 2018 10:21:09 +0200
In-Reply-To: <eb5fb671-4589-e0cf-5385-84a5cc912905@xs4all.nl>
References: <20180710080114.31469-1-paul.kocialkowski@bootlin.com>
         <20180710080114.31469-3-paul.kocialkowski@bootlin.com>
         <CAMuHMdVgJuK5G0+szV0BAWDBybxWV0iDWE5kZKuTdgNiGjpnEg@mail.gmail.com>
         <5adf8a6aa70fd6f7f4326ccb068b66d6221d8d8b.camel@bootlin.com>
         <eb5fb671-4589-e0cf-5385-84a5cc912905@xs4all.nl>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-tr9K18b3srFCX1uet9wE"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-tr9K18b3srFCX1uet9wE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, 2018-07-10 at 10:17 +0200, Hans Verkuil wrote:
> On 10/07/18 10:13, Paul Kocialkowski wrote:
> > Hi,
> >=20
> > On Tue, 2018-07-10 at 10:07 +0200, Geert Uytterhoeven wrote:
> > > On Tue, Jul 10, 2018 at 10:02 AM Paul Kocialkowski
> > > <paul.kocialkowski@bootlin.com> wrote:
> > > > [PATCH v5 02/22] fixup! v4l2-ctrls: add v4l2_ctrl_request_hdl_find/=
put/ctrl_find functions
> > >=20
> > > git rebase -i ;-)
> >=20
> > Although I should have mentionned it (and did not), this is totally
> > intentional! The first patch (from Hans Verkuil) requires said fixup to
> > work properly. I didn't want to squash that change into the commit to
> > make the diff obvious.
>=20
> Just squash the two for the next version you post.

That works for me! I must admit I was rather unsure this was a sensible
way to do things.

> > Ultimately, this framework patch is not really part of the series but i=
s
> > one of its underlying requirements, that should be merged separately (a=
s
> > part of the requests API series).
>=20
> There is a good chance that this patch will go in via your series anyway
> since it is not needed by vivid or vim2m.

Alright, I will keep it around then.

Cheers,

Paul

> Regards,
>=20
> 	Hans
>=20
> >=20
> > I hope this clears up some of the confusion about this patch :)
> >=20
> > Cheers!
> >=20
> > > Gr{oetje,eeting}s,
> > >=20
> > >                         Geert
> > >=20
>=20
>=20
--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com
--=-tr9K18b3srFCX1uet9wE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAltEbHUACgkQ3cLmz3+f
v9Eipwf/W1kQNCdenaBs9GeAg5yXznUB4XGqOMqYmwjMexOjVt1hcZo8y6cZdW03
uPHWYvQalQw6rRSQ97LA1REO4wcbG9K9Wp9vE57TjtrkRn8zmmZ5fx6tI1lceW31
5oilZ0EAgiBqqfWbFg8729eoEZcazTcRrzXdQJ1DFsYE40zu5LhJY1nHPz+buQOi
L4Hkcxl/aPjxNvpvYhC85AZ/WAt3IiLAMHqcvcZ9p3tRp/WQmxsVETsXBwR4r/1i
T5s9ciulK3qCriS0tj7zY8kVAYJ+2zWaL/QrAJ8idIFmWxVRTEhF/NcaRbT78lfM
/D3zjTuYJCF8rIjqR96/9wwkJobIQw==
=SyDX
-----END PGP SIGNATURE-----

--=-tr9K18b3srFCX1uet9wE--
