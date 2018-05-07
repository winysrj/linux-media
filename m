Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:55841 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750732AbeEGOvc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 May 2018 10:51:32 -0400
Message-ID: <611315f6d89ef7a85d56dd4b976c1207a4806dda.camel@bootlin.com>
Subject: Re: [PATCH v3 00/14] Sunxi-Cedrus driver for the Allwinner Video
 Engine, using media requests
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Florent Revest <florent.revest@free-electrons.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Smitha T Murthy <smitha.t@samsung.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Randy Li <ayaka@soulik.info>
Date: Mon, 07 May 2018 16:50:08 +0200
In-Reply-To: <20180507124500.20434-1-paul.kocialkowski@bootlin.com>
References: <20180507124500.20434-1-paul.kocialkowski@bootlin.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-GLnQEMAVvrJnfLPQ/EJ1"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-GLnQEMAVvrJnfLPQ/EJ1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

[...]

On Mon, 2018-05-07 at 14:44 +0200, Paul Kocialkowski wrote:
> Remaining tasks:
> * cleaning up registers description and documenting the fields used;
> * removing the assigned-clocks property and setting the clock rate
>   in the driver directly;
> * checking the series with checkpatch and fixing warnings;
> * documenting the MB32 NV12 format and adding it to v4l_fill_fmtdesc;
> * reworking and documenting the MPEG2 header, then adding it to
>   v4l_fill_fmtdesc;
> * checking and fixing the error paths;
> * testing on more platforms.

Another item for the tasks list that is not yet in this revision:
* changing the id for V4L2_CTRL_TYPE_MPEG2_FRAME_HDR=0F;

Paul

> Cheers!
>=20
> [0]: https://patchwork.kernel.org/patch/9299073/
> [1]: https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=3Dreqv13
>=20
> Florent Revest (1):
>   media: v4l: Add definitions for MPEG2 frame format and header metadata
>=20
> Maxime Ripard (4):
>   drivers: soc: sunxi: Add support for the C1 SRAM region
>   ARM: sun5i: Add support for the C1 SRAM region with the SRAM
>     controller
>   ARM: sun7i-a20: Add support for the C1 SRAM region with the SRAM
>     controller
>   ARM: sun8i-a33: Add SRAM controller node and C1 SRAM region
>=20
> Paul Kocialkowski (9):
>   drivers: soc: sunxi: Add dedicated compatibles for the A13, A20 and
>     A33
>   ARM: dts: sun5i: Use dedicated SRAM controller compatible
>   ARM: dts: sun7i-a20: Use dedicated SRAM controller compatible
>   media: v4l: Add definition for Allwinner's MB32-tiled NV12 format
>   dt-bindings: media: Document bindings for the Sunxi-Cedrus VPU driver
>   media: platform: Add Sunxi-Cedrus VPU decoder driver
>   ARM: dts: sun5i: Add Video Engine and reserved memory nodes
>   ARM: dts: sun7i-a20: Add Video Engine and reserved memory nodes
>   ARM: dts: sun8i-a33: Add Video Engine and reserved memory nodes
>=20
>  .../devicetree/bindings/media/sunxi-cedrus.txt     |  58 +++
>  MAINTAINERS                                        |   7 +
>  arch/arm/boot/dts/sun5i.dtsi                       |  47 +-
>  arch/arm/boot/dts/sun7i-a20.dtsi                   |  47 +-
>  arch/arm/boot/dts/sun8i-a33.dtsi                   |  54 +++
>  drivers/media/platform/Kconfig                     |  15 +
>  drivers/media/platform/Makefile                    |   1 +
>  drivers/media/platform/sunxi/cedrus/Makefile       |   4 +
>  drivers/media/platform/sunxi/cedrus/sunxi_cedrus.c | 333 ++++++++++++++
>  .../platform/sunxi/cedrus/sunxi_cedrus_common.h    | 128 ++++++
>  .../media/platform/sunxi/cedrus/sunxi_cedrus_dec.c | 188 ++++++++
>  .../media/platform/sunxi/cedrus/sunxi_cedrus_dec.h |  35 ++
>  .../media/platform/sunxi/cedrus/sunxi_cedrus_hw.c  | 240 ++++++++++
>  .../media/platform/sunxi/cedrus/sunxi_cedrus_hw.h  |  37 ++
>  .../platform/sunxi/cedrus/sunxi_cedrus_mpeg2.c     | 160 +++++++
>  .../platform/sunxi/cedrus/sunxi_cedrus_mpeg2.h     |  33 ++
>  .../platform/sunxi/cedrus/sunxi_cedrus_regs.h      | 175 +++++++
>  .../platform/sunxi/cedrus/sunxi_cedrus_video.c     | 505 +++++++++++++++=
++++++
>  .../platform/sunxi/cedrus/sunxi_cedrus_video.h     |  31 ++
>  drivers/media/v4l2-core/v4l2-ctrls.c               |  10 +
>  drivers/media/v4l2-core/v4l2-ioctl.c               |   1 +
>  drivers/soc/sunxi/sunxi_sram.c                     |  13 +
>  include/uapi/linux/v4l2-controls.h                 |  26 ++
>  include/uapi/linux/videodev2.h                     |   4 +
>  24 files changed, 2150 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/sunxi-cedrus.=
txt
>  create mode 100644 drivers/media/platform/sunxi/cedrus/Makefile
>  create mode 100644 drivers/media/platform/sunxi/cedrus/sunxi_cedrus.c
>  create mode 100644 drivers/media/platform/sunxi/cedrus/sunxi_cedrus_comm=
on.h
>  create mode 100644 drivers/media/platform/sunxi/cedrus/sunxi_cedrus_dec.=
c
>  create mode 100644 drivers/media/platform/sunxi/cedrus/sunxi_cedrus_dec.=
h
>  create mode 100644 drivers/media/platform/sunxi/cedrus/sunxi_cedrus_hw.c
>  create mode 100644 drivers/media/platform/sunxi/cedrus/sunxi_cedrus_hw.h
>  create mode 100644 drivers/media/platform/sunxi/cedrus/sunxi_cedrus_mpeg=
2.c
>  create mode 100644 drivers/media/platform/sunxi/cedrus/sunxi_cedrus_mpeg=
2.h
>  create mode 100644 drivers/media/platform/sunxi/cedrus/sunxi_cedrus_regs=
.h
>  create mode 100644 drivers/media/platform/sunxi/cedrus/sunxi_cedrus_vide=
o.c
>  create mode 100644 drivers/media/platform/sunxi/cedrus/sunxi_cedrus_vide=
o.h
>=20
--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com
--=-GLnQEMAVvrJnfLPQ/EJ1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlrwZ6AACgkQ3cLmz3+f
v9Hzjgf/fUlUbHuTPjXkZdWutpBxX5BC8KKEoWFYxc0MqvHPNJz7w1UAe91T4o6e
GySZvJKwQYjpLyAS3rNDjs+7qGGku6mAuQVWSq6RV70+xkSygR1+dj46HcdeiJXh
Ux3ObkAgw/GqWmMj+68uWaJg0QSRVNCg0fEp8CPy3CVy/palWK5tB0AyJpuYNY3w
s1RbwxLD9OufTbLurkKAsiDkyk8peRud9GzJff51GA3+RF023/XSlOx11BCij+X5
Yl6RDZhQXc26HMjQB78tbC7QjbjYVv0yBzDmbkJZpxH5RwbB4jdTFME6zfriTQT2
cbufAr8qfZeoN+C/ilGnU0i3DmdUmw==
=mUBt
-----END PGP SIGNATURE-----

--=-GLnQEMAVvrJnfLPQ/EJ1--
