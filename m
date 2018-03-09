Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:50439 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751205AbeCIKUL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 05:20:11 -0500
Message-ID: <1520590736.15946.1.camel@bootlin.com>
Subject: Re: [PATCH 0/9] Sunxi-Cedrus driver for the Allwinner Video Engine,
 using the V4L2 request API
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Cc: Icenowy Zheng <icenowy@aosc.xyz>,
        Florent Revest <revestflo@gmail.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Thomas van Kleef <thomas@vitsch.nl>,
        "Signed-off-by : Bob Ham" <rah@settrans.net>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>
Date: Fri, 09 Mar 2018 11:18:56 +0100
In-Reply-To: <20180309100933.15922-1-paul.kocialkowski@bootlin.com>
References: <20180309100933.15922-1-paul.kocialkowski@bootlin.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-HlJ2Wc3XAxVn/wzc1ex8"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-HlJ2Wc3XAxVn/wzc1ex8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2018-03-09 at 11:09 +0100, Paul Kocialkowski wrote:
> This presents a newer version of the Sunxi-Cedrus driver, that
> supports
> the Video Engine found in most Allwinner SoCs, starting with the A10.

I had to send this series in two parts (and tried to keep them under the
original thread) after the mail server rejected one of the emails mid-
series, causing git-send-email to stop. Sorry for the mess.

> The first version of this driver[0] was originally written and
> submitted
> by Florent Revest using a previous version of the request API, that is
> necessary to provide coherency between controls and the buffers they
> apply
> to. The driver was since adapted to use the latest version of the
> request
> API[1], as submitted by Alexandre Courbot. It is a hard requirement
> for
> this driver.
>=20
> This series also contains fixes for issues encountered with the
> current
> version of the request API. If accepted, these should eventually be
> squashed into the request API series.
>=20
> The driver itself currently only supports MPEG2 and more codecs will
> be
> added to the driver eventually. The output frames provided by the
> Video Engine are in a multi-planar 32x32-tiled YUV format, with a
> plane
> for luminance (Y) and a plane for chrominance (UV). A specific format
> is
> introduced in the V4L2 API to describe it.
>=20
> This implementation is based on the significant work that was
> conducted
> by various members of the linux-sunxi community for understanding and
> documenting the Video Engine's innards.
>=20
> [0]: https://lkml.org/lkml/2016/8/25/246
> [1]: https://lkml.org/lkml/2018/2/19/872
>=20
> Florent Revest (5):
>   v4l: Add sunxi Video Engine pixel format
>   v4l: Add MPEG2 low-level decoder API control
>   media: platform: Add Sunxi Cedrus decoder driver
>   sunxi-cedrus: Add device tree binding document
>   ARM: dts: sun5i: Use video-engine node
>=20
> Icenowy Zheng (1):
>   ARM: dts: sun8i: add video engine support for A33
>=20
> Paul Kocialkowski (2):
>   media: vim2m: Try to schedule a m2m device run on request submission
>   media: videobuf2-v4l2: Copy planes when needed in request qbuf
>=20
> Thomas van Kleef (1):
>   ARM: dts: sun7i: Add video engine support for the A20
>=20
>  .../devicetree/bindings/media/sunxi-cedrus.txt     |  44 ++
>  arch/arm/boot/dts/sun5i-a13.dtsi                   |  30 ++
>  arch/arm/boot/dts/sun7i-a20.dtsi                   |  47 ++
>  arch/arm/boot/dts/sun8i-a33.dtsi                   |  39 ++
>  drivers/media/common/videobuf2/videobuf2-v4l2.c    |  19 +
>  drivers/media/platform/Kconfig                     |  14 +
>  drivers/media/platform/Makefile                    |   1 +
>  drivers/media/platform/sunxi-cedrus/Makefile       |   4 +
>  drivers/media/platform/sunxi-cedrus/sunxi_cedrus.c | 313 ++++++++++++
>  .../platform/sunxi-cedrus/sunxi_cedrus_common.h    | 106 ++++
>  .../media/platform/sunxi-cedrus/sunxi_cedrus_dec.c | 568
> +++++++++++++++++++++
>  .../media/platform/sunxi-cedrus/sunxi_cedrus_dec.h |  33 ++
>  .../media/platform/sunxi-cedrus/sunxi_cedrus_hw.c  | 185 +++++++
>  .../media/platform/sunxi-cedrus/sunxi_cedrus_hw.h  |  36 ++
>  .../platform/sunxi-cedrus/sunxi_cedrus_mpeg2.c     | 152 ++++++
>  .../platform/sunxi-cedrus/sunxi_cedrus_regs.h      | 170 ++++++
>  drivers/media/platform/vim2m.c                     |  13 +-
>  drivers/media/v4l2-core/v4l2-ctrls.c               |  15 +
>  drivers/media/v4l2-core/v4l2-ioctl.c               |   1 +
>  include/uapi/linux/v4l2-controls.h                 |  26 +
>  include/uapi/linux/videodev2.h                     |   6 +
>  21 files changed, 1821 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/devicetree/bindings/media/sunxi-
> cedrus.txt
>  create mode 100644 drivers/media/platform/sunxi-cedrus/Makefile
>  create mode 100644 drivers/media/platform/sunxi-cedrus/sunxi_cedrus.c
>  create mode 100644 drivers/media/platform/sunxi-
> cedrus/sunxi_cedrus_common.h
>  create mode 100644 drivers/media/platform/sunxi-
> cedrus/sunxi_cedrus_dec.c
>  create mode 100644 drivers/media/platform/sunxi-
> cedrus/sunxi_cedrus_dec.h
>  create mode 100644 drivers/media/platform/sunxi-
> cedrus/sunxi_cedrus_hw.c
>  create mode 100644 drivers/media/platform/sunxi-
> cedrus/sunxi_cedrus_hw.h
>  create mode 100644 drivers/media/platform/sunxi-
> cedrus/sunxi_cedrus_mpeg2.c
>  create mode 100644 drivers/media/platform/sunxi-
> cedrus/sunxi_cedrus_regs.h
>=20
--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com
--=-HlJ2Wc3XAxVn/wzc1ex8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlqiX5EACgkQ3cLmz3+f
v9HHBAf9EI6TZ+OLHWQBSByQgV454Ur83C4+xkcYnjQ8ulQEKZyoTdXi7dOTudX8
HGF/milN7+lRoVuvgCzwzxdSZsZ+QJdKXIBNFeeuIi4lDHMdMhJQwZA/VVWboNRw
gHVVOfYiorWtzGaueevgPmwTowOYc6CSrHyEt33XCOdR9dEhFT9ByeIbB4yKAT6K
k1eujOOLT0vDvTm+8lxJ1YQ3TJuwn1ep89MLnclUeB9+P4ugTRrmMdPgYyzU1v2G
92gt2pwiXGRQX4tM8xVczHxv5gN1jSLv0tjiuyDFJ+1QdSBEKfegWcWsF2LFpklt
YrYYYVidGr2n6Sn0t+Pc8IrviVKC9A==
=JvGE
-----END PGP SIGNATURE-----

--=-HlJ2Wc3XAxVn/wzc1ex8--
