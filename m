Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:57214 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753896AbeFTPmR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 11:42:17 -0400
Message-ID: <a2f7b1841410b4a9cd8ac9b5dd323ab2b060acef.camel@bootlin.com>
Subject: Re: [PATCH v4 15/19] dt-bindings: media: Document bindings for the
 Sunxi-Cedrus VPU driver
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Rob Herring <robh@kernel.org>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Marco Franchi <marco.franchi@nxp.com>,
        Icenowy Zheng <icenowy@aosc.io>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tom Saeger <tom.saeger@oracle.com>,
        Smitha T Murthy <smitha.t@samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "David S . Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-sunxi@googlegroups.com,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Randy Li <ayaka@soulik.info>
Date: Wed, 20 Jun 2018 17:42:13 +0200
In-Reply-To: <20180620154009.GA26099@rob-hp-laptop>
References: <20180618145843.14631-1-paul.kocialkowski@bootlin.com>
         <20180618145843.14631-16-paul.kocialkowski@bootlin.com>
         <20180620154009.GA26099@rob-hp-laptop>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-07SQVeov04rWTSqQRGWT"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-07SQVeov04rWTSqQRGWT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, 2018-06-20 at 09:40 -0600, Rob Herring wrote:
> On Mon, Jun 18, 2018 at 04:58:39PM +0200, Paul Kocialkowski wrote:
> > This adds a device-tree binding document that specifies the properties
> > used by the Sunxi-Cedurs VPU driver, as well as examples.
> >=20
> > Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> >=20
> >  create mode 100644 Documentation/devicetree/bindings/media/sunxi-cedru=
s.txt
>=20
> You are missing a '---' line so this is going to end up in the commit=20
> msg.

Yes, I can't really explain how this happened. It seems related to
exporting patches with --summary.

> Please add acked/reviewed bys when posting new versions.

Oh, sorry for forgetting that. The bindings are indeed exactly the same
as the ones your reviewed and acked already.

Cheers,

Paul

--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com
--=-07SQVeov04rWTSqQRGWT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlsqddYACgkQ3cLmz3+f
v9GP9AgAgwc/pWCk+5Kbx5Pc3oTy8nPTKNE9lSRIdvLKSA4XuXcUZpTgION7rPIP
XctR6IMQn10FcwnbtceKHWJuZdgAYbahRniHpQV9emQbH09MuHchT6PLcbLmjPhc
WJ0a4wbH59SYUnpz+2UEEbh+goWHg/FYMS4usEo7+pjIJRm3Gtmh5SuV4SQ2KT8/
dQMItv9l4Zydl0IWfRDSyDe/LBDu25cdNvkrBHmx6sqA/9YwsWI6UxuFPmH0+4Ms
y996KQa6I3vDkzfxi+Hoztg27n8tMOCjuTrQ3maxCukgOxjPoBGOLAqSgRBHis5r
uMafDTisyTmzF0SMtAsEToaFz31NOg==
=H3vo
-----END PGP SIGNATURE-----

--=-07SQVeov04rWTSqQRGWT--
