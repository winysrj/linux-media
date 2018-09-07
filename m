Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:44068 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728701AbeIGTGv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Sep 2018 15:06:51 -0400
Date: Fri, 7 Sep 2018 16:25:28 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Paul Kocialkowski <contact@paulk.fr>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devel@driverdev.osuosl.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-sunxi@googlegroups.com, Randy Li <ayaka@soulik.info>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v9 5/9] media: platform: Add Cedrus VPU decoder driver
Message-ID: <20180907142528.4daxlsd6jwnkw74h@flea>
References: <20180906222442.14825-1-contact@paulk.fr>
 <20180906222442.14825-6-contact@paulk.fr>
 <4b30c0bf-e525-1868-f625-569d4a104aa0@xs4all.nl>
 <20180907132620.lmsvlwpa3rzioj2h@flea>
 <2c9689b2-c5a6-58b7-b467-fc53208ecd2d@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="2uukceuibjsjma7f"
Content-Disposition: inline
In-Reply-To: <2c9689b2-c5a6-58b7-b467-fc53208ecd2d@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--2uukceuibjsjma7f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 07, 2018 at 03:52:00PM +0200, Hans Verkuil wrote:
> On 09/07/2018 03:26 PM, Maxime Ripard wrote:
> > Hi Hans,
> >=20
> > On Fri, Sep 07, 2018 at 03:13:19PM +0200, Hans Verkuil wrote:
> >> On 09/07/2018 12:24 AM, Paul Kocialkowski wrote:
> >>> From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> >>>
> >>> This introduces the Cedrus VPU driver that supports the VPU found in
> >>> Allwinner SoCs, also known as Video Engine. It is implemented through
> >>> a V4L2 M2M decoder device and a media device (used for media requests=
).
> >>> So far, it only supports MPEG-2 decoding.
> >>>
> >>> Since this VPU is stateless, synchronization with media requests is
> >>> required in order to ensure consistency between frame headers that
> >>> contain metadata about the frame to process and the raw slice data th=
at
> >>> is used to generate the frame.
> >>>
> >>> This driver was made possible thanks to the long-standing effort
> >>> carried out by the linux-sunxi community in the interest of reverse
> >>> engineering, documenting and implementing support for the Allwinner V=
PU.
> >>>
> >>> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> >>> Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>
> >>
> >> One high-level comment:
> >>
> >> Can you add a TODO file for this staging driver? This can be done in
> >> a follow-up patch.
> >>
> >> It should contain what needs to be done to get this out of staging:
> >>
> >> - Request API needs to stabilize
> >> - Userspace support for stateless codecs must be created
> >=20
> > On that particular note, as part of the effort to develop the driver,
> > we've also developped two userspace components:
> >=20
> >   - v4l2-request-test, that has a bunch of sample frames for various
> >     codecs and will rely solely on the kernel request api (and DRM for
> >     the display part) to test and bringup a particular driver
> >     https://github.com/bootlin/v4l2-request-test
> >=20
> >   - libva-v4l2-request, that is a libva implementation using the
> >     request API
> >     https://github.com/bootlin/libva-v4l2-request
> >=20
> > Did you have something else in mind?
>=20
> Reviewing this will be the next step. I haven't looked at the userspace c=
omponents
> at all yet, so I don't know yet whether it is what we expect/want/need.

We meant this as a debug tool and a stop-gap measure, respectively, so
it might not be what you're expecting, and I'm kind of expecting to
have the libva fade away with media frameworks getting native support.

> I think this might be a very good topic for the media summit in October i=
f we
> can get all the stakeholders together.

I'll be there, so we can definitely discuss this.

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--2uukceuibjsjma7f
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAluSilcACgkQ0rTAlCFN
r3QE0w//beU2LXIo5m6cI3dstclD7/NHmpsmhK/SLZkGaYrHfB/UseAhQQuzqoa5
r1eRcbIm3+a/B2Ad9COXbN1pBnQyh0E5onW+4zHTvdX9Y/BbEoiXx7k7Mnx4H93j
ah7iotnaR+lDq3zPhfSYUNYRhqacAZNFHLs8pYCzjYIyFz3vcNS3pnKkq5cEG6Z4
tkRkM/uIrj4WNNb9TBBjEL3XoPqQedeBzB65II7x8Pr4fJeJGSKVLgTjkY9mv4Rz
42nScz13pDPvWNlhdJNxEgDj4SHmqcN2nbPrIKp2XOjzV1jOHbjNuka2Lf0hJk1w
zEl9HcPMq4jnxf+/o1C3abv9Bmf4XPwPp/pbXXGXjGFxrPb6H9RlZ8bSj4NL5Dkh
pS+i/sqgHRiiu2juFJK2VyXI8guVtR1SHRH9TtOUja9n4SDMapj6JM546LRvnZdE
wqOnG0W+5nvX+qxXHUWg8zCx1hZU9UBt9ZKPDGl+QHRX6YHrt+92ZU5IrA/d7UE+
ZTWE7EkDf6wQY9641F4cOuZ255JEU5ASp+V92hFydebdZNw+/+vmG2Q0zgaUnWBu
m/4PEzWPTaKY4VmKPx+WBLX8DgFT3xhKtqIyolqTLskIPPE/ZSDenvkrzPOIlmYi
JSh+ZSp44IsgdOSniQX4dW2kNsuOlDXZIca8lTq8R797q8K+gYY=
=NH6A
-----END PGP SIGNATURE-----

--2uukceuibjsjma7f--
