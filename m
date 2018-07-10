Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:55281 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751217AbeGJIOi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jul 2018 04:14:38 -0400
Message-ID: <5adf8a6aa70fd6f7f4326ccb068b66d6221d8d8b.camel@bootlin.com>
Subject: Re: [PATCH v5 02/22] fixup! v4l2-ctrls: add
 v4l2_ctrl_request_hdl_find/put/ctrl_find functions
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
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
        icenowy@aosc.io, Hans Verkuil <hverkuil@xs4all.nl>,
        keiichiw@chromium.org, Jonathan Corbet <corbet@lwn.net>,
        smitha.t@samsung.com, tom.saeger@oracle.com,
        Andrzej Hajda <a.hajda@samsung.com>,
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
Date: Tue, 10 Jul 2018 10:13:48 +0200
In-Reply-To: <CAMuHMdVgJuK5G0+szV0BAWDBybxWV0iDWE5kZKuTdgNiGjpnEg@mail.gmail.com>
References: <20180710080114.31469-1-paul.kocialkowski@bootlin.com>
         <20180710080114.31469-3-paul.kocialkowski@bootlin.com>
         <CAMuHMdVgJuK5G0+szV0BAWDBybxWV0iDWE5kZKuTdgNiGjpnEg@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-heIn3Rp8HIJ7p2FH40+U"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-heIn3Rp8HIJ7p2FH40+U
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, 2018-07-10 at 10:07 +0200, Geert Uytterhoeven wrote:
> On Tue, Jul 10, 2018 at 10:02 AM Paul Kocialkowski
> <paul.kocialkowski@bootlin.com> wrote:
> > [PATCH v5 02/22] fixup! v4l2-ctrls: add v4l2_ctrl_request_hdl_find/put/=
ctrl_find functions
>=20
> git rebase -i ;-)

Although I should have mentionned it (and did not), this is totally
intentional! The first patch (from Hans Verkuil) requires said fixup to
work properly. I didn't want to squash that change into the commit to
make the diff obvious.

Ultimately, this framework patch is not really part of the series but is
one of its underlying requirements, that should be merged separately (as
part of the requests API series).

I hope this clears up some of the confusion about this patch :)

Cheers!

> Gr{oetje,eeting}s,
>=20
>                         Geert
>=20
--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com
--=-heIn3Rp8HIJ7p2FH40+U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAltEarwACgkQ3cLmz3+f
v9Hcdwf/WEcgOv58WAWhU0lKQfgOeFzn5VbaqXdfP66RGjvHcGjuCOmEv/JmKmrt
EdheaInYZ0X3dyrzJl+Ho103yY296+wU4QOJk2bsvccAWINk0Kz5FNwNqb9BA2pr
G9nr00lRxIzeC7R3Ok7MpRaP6AEO55nI8ivj2hEOlUgPA6io58xVWIY7xgJYQn0c
mmHC00PMFyij8hu2hFnPYy/0a442xAXcqO4rRN31nkAwI5hF4s66O0Wjjq0FH7lz
RBf9QXRZUACz1z7xX2zD9rD+oiIsvEOtck9XOpHj6p5vFg8EaTLHs9Ilvpy3yvwt
WCa/vfNFMw6bxQ2ISHvHKpnlpHpj7A==
=Sx0a
-----END PGP SIGNATURE-----

--=-heIn3Rp8HIJ7p2FH40+U--
