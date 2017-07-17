Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52827 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751245AbdGQChg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 16 Jul 2017 22:37:36 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Personnel <nicolas@ndufresne.ca>
Cc: Jacob Chen <jacob-chen@iotwrt.com>,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        heiko@sntech.de, robh+dt@kernel.org, mchehab@kernel.org,
        linux-media@vger.kernel.org, hans.verkuil@cisco.com,
        s.nawrocki@samsung.com, tfiga@chromium.org
Subject: Re: [PATCH v2 2/6] [media] rockchip/rga: v4l2 m2m support
Date: Mon, 17 Jul 2017 05:37:42 +0300
Message-ID: <11368407.z8bSoa2YAE@avalon>
In-Reply-To: <1500137353.2353.1.camel@ndufresne.ca>
References: <1500101920-24039-1-git-send-email-jacob-chen@iotwrt.com> <2363665.x6z9MR1vqI@avalon> <1500137353.2353.1.camel@ndufresne.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nicolas,

On Saturday 15 Jul 2017 12:49:13 Personnel wrote:

You might want to fix your mailer to use your name :-)

> Le samedi 15 juillet 2017 =E0 12:42 +0300, Laurent Pinchart a =E9crit=
 :
> > On Saturday 15 Jul 2017 14:58:36 Jacob Chen wrote:
> >> Rockchip RGA is a separate 2D raster graphic acceleration unit. It=

> >> accelerates 2D graphics operations, such as point/line drawing, im=
age
> >> scaling, rotation, BitBLT, alpha blending and image blur/sharpness=
.
> >>=20
> >> The drvier is mostly based on s5p-g2d v4l2 m2m driver.
> >> And supports various operations from the rendering pipeline.
> >>=20
> >>  - copy
> >>  - fast solid color fill
> >>  - rotation
> >>  - flip
> >>  - alpha blending
> >
> > I notice that you don't support the drawing operations. How do you =
plan to
> > support them later through the V4L2 M2M API ? I hate stating the ob=
vious,
> > but wouldn't the DRM API be better fit for a graphic accelerator ?
>=20
> It could fit, maybe, but it really lacks some framework. Also, DRM is=

> not really meant for M2M operation, and it's also not great for multi=
-
> process.

GPUs on embedded devices are mem-to-mem, and they're definitely shared =
between=20
multiple processes :-)

> Until recently, there was competing drivers for Exynos, both
> implemented in V4L2 and DRM, for similar rational, all DRM ones are
> being deprecated/removed.
>=20
> I think 2D blitters in V4L2 are fine, but they terribly lack somethin=
g
> to differentiate them from converters/scalers when looking up the HW
> list. Could be as simple as a capability flag, if I can suggest. For
> the reference, the 2D blitter on IMX6 has been used to implement a li=
ve
> video mixer in GStreamer.
>=20
> https://bugzilla.gnome.org/show_bug.cgi?id=3D772766

If we decide that 2D blitters should be supported by V4L2 (and I'm open=
 to get=20
convinced about that), we really need to define a proper API before mer=
ging a=20
bunch of drivers that will implement things in slightly different ways,=
=20
otherwise the future will be very painful.

Among the issues that need to be solved are

- stateful vs. stateless operation (as mentioned by Jacob in this mail=20=

thread), a.k.a. the request API

- exposing capabilities to userspace (a single capability flag would be=
 enough=20
only if all blitters expose the same API, which I'm not sure we can ass=
ume)

- single input (a.k.a. in-place blitters as you mentioned below) vs. mu=
ltiple=20
inputs

- API for 2D-accelerated operations other than blitting (filling, point=
 and=20
line drawing, ...)

> > Additionally, V4L2 M2M has one source and one destination. How do y=
ou
> > implement alpha blending in that case, which by definition requires=
 at
> > least two sources ?
>=20
> This type of HW only do in-place blits. When using such a node, the
> buffer queued on the V4L2_CAPTURE contains the destination image, and=

> the buffer queued on the V4L2_OUTPUT is the source image.
>=20
> >> The code in rga-hw.c is used to configure regs accroding to operat=
ions.
> >>=20
> >> The code in rga-buf.c is used to create private mmu table for RGA.=

> >> The tables is stored in a list, and be removed when buffer is clea=
nup.
> >=20
> > Looking at the implementation it seems to be a scatter-gather list,=
 not an
> > MMU. Is that right ? Does the hardware documentation refer to it as=
 an MMU
> > ?
> >
> >> Signed-off-by: Jacob Chen <jacob-chen@iotwrt.com>
> >> ---
> >>=20
> >>  drivers/media/platform/Kconfig                |  11 +
> >>  drivers/media/platform/Makefile               |   2 +
> >>  drivers/media/platform/rockchip-rga/Makefile  |   3 +
> >>  drivers/media/platform/rockchip-rga/rga-buf.c | 122 ++++
> >>  drivers/media/platform/rockchip-rga/rga-hw.c  | 652 +++++++++++++=
+++++
> >>  drivers/media/platform/rockchip-rga/rga-hw.h  | 437 ++++++++++++
> >>  drivers/media/platform/rockchip-rga/rga.c     | 958 +++++++++++++=
++++++
> >>  drivers/media/platform/rockchip-rga/rga.h     | 111 +++
> >>  8 files changed, 2296 insertions(+)
> >>  create mode 100644 drivers/media/platform/rockchip-rga/Makefile
> >>  create mode 100644 drivers/media/platform/rockchip-rga/rga-buf.c
> >>  create mode 100644 drivers/media/platform/rockchip-rga/rga-hw.c
> >>  create mode 100644 drivers/media/platform/rockchip-rga/rga-hw.h
> >>  create mode 100644 drivers/media/platform/rockchip-rga/rga.c
> >>  create mode 100644 drivers/media/platform/rockchip-rga/rga.h

--=20
Regards,

Laurent Pinchart
