Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:38702 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751490AbdGQOpP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Jul 2017 10:45:15 -0400
Received: by mail-it0-f54.google.com with SMTP id h199so18821600ith.1
        for <linux-media@vger.kernel.org>; Mon, 17 Jul 2017 07:45:15 -0700 (PDT)
Message-ID: <1500302710.21957.1.camel@ndufresne.ca>
Subject: Re: [PATCH v2 2/6] [media] rockchip/rga: v4l2 m2m support
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Jacob Chen <jacob-chen@iotwrt.com>,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        heiko@sntech.de, robh+dt@kernel.org, mchehab@kernel.org,
        linux-media@vger.kernel.org, hans.verkuil@cisco.com,
        s.nawrocki@samsung.com, tfiga@chromium.org
Date: Mon, 17 Jul 2017 10:45:10 -0400
In-Reply-To: <11368407.z8bSoa2YAE@avalon>
References: <1500101920-24039-1-git-send-email-jacob-chen@iotwrt.com>
         <2363665.x6z9MR1vqI@avalon> <1500137353.2353.1.camel@ndufresne.ca>
         <11368407.z8bSoa2YAE@avalon>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-MLq+ZlnsOw6a2s5K040R"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-MLq+ZlnsOw6a2s5K040R
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le lundi 17 juillet 2017 =C3=A0 05:37 +0300, Laurent Pinchart a =C3=A9crit =
:
> Hi Nicolas,
>=20
> On Saturday 15 Jul 2017 12:49:13 Personnel wrote:
>=20
> You might want to fix your mailer to use your name :-)
>=20
> > Le samedi 15 juillet 2017 =C3=A0 12:42 +0300, Laurent Pinchart a =C3=A9=
crit :
> > > On Saturday 15 Jul 2017 14:58:36 Jacob Chen wrote:
> > > > Rockchip RGA is a separate 2D raster graphic acceleration unit. It
> > > > accelerates 2D graphics operations, such as point/line drawing, ima=
ge
> > > > scaling, rotation, BitBLT, alpha blending and image blur/sharpness.
> > > >=20
> > > > The drvier is mostly based on s5p-g2d v4l2 m2m driver.
> > > > And supports various operations from the rendering pipeline.
> > > >=20
> > > >  - copy
> > > >  - fast solid color fill
> > > >  - rotation
> > > >  - flip
> > > >  - alpha blending
> > >=20
> > > I notice that you don't support the drawing operations. How do you pl=
an to
> > > support them later through the V4L2 M2M API ? I hate stating the obvi=
ous,
> > > but wouldn't the DRM API be better fit for a graphic accelerator ?
> >=20
> > It could fit, maybe, but it really lacks some framework. Also, DRM is
> > not really meant for M2M operation, and it's also not great for multi-
> > process.
>=20
> GPUs on embedded devices are mem-to-mem, and they're definitely shared be=
tween=20
> multiple processes :-)
>=20
> > Until recently, there was competing drivers for Exynos, both
> > implemented in V4L2 and DRM, for similar rational, all DRM ones are
> > being deprecated/removed.
> >=20
> > I think 2D blitters in V4L2 are fine, but they terribly lack something
> > to differentiate them from converters/scalers when looking up the HW
> > list. Could be as simple as a capability flag, if I can suggest. For
> > the reference, the 2D blitter on IMX6 has been used to implement a live
> > video mixer in GStreamer.
> >=20
> > https://bugzilla.gnome.org/show_bug.cgi?id=3D772766
>=20
> If we decide that 2D blitters should be supported by V4L2 (and I'm open t=
o get=20
> convinced about that), we really need to define a proper API before mergi=
ng a=20
> bunch of drivers that will implement things in slightly different ways,=
=20
> otherwise the future will be very painful.

Arguably, Jacob is not proposing anything new, as at least one other
driver has been merged.

>=20
> Among the issues that need to be solved are
>=20
> - stateful vs. stateless operation (as mentioned by Jacob in this mail=
=20
> thread), a.k.a. the request API

Would it be possible to extend your thought. To me, Request API could
enable more use cases but is not strictly required.

>=20
> - exposing capabilities to userspace (a single capability flag would be e=
nough=20
> only if all blitters expose the same API, which I'm not sure we can assum=
e)

I am just rethinking this. With this patch series, Jacob is trying to
generalize the Blit Operation controls (still need a name, blend mode
does not work). We can easily make a recommendation to set the default
operation to a copy operation (drivers always support that). This way,
the node will behave like a converter (scaler, colorspace converter,
rotator and/or etc.) Checking the presence of that control, we can
clearly and quickly figure-out what this node is about. The capability
remains a nice idea, but probably optional.

I totally agree we should document the behaviours and rationals for
picking a certain default. The control should maybe become a "menu"
too, so each driver can cherry-pick the blit operations they support
(using int with min/max requires userspace trial and error, we already
did that mistake for encoders profiles and level).

>=20
> - single input (a.k.a. in-place blitters as you mentioned below) vs. mult=
iple=20
> inputs

I do think the second is something you can build on top of the first by
cascading (what we do in the refereed GStreamer element). So far this
is applicable to Exynos, IMX6 and now Rockchip (probably more). The
"optimal" form for the second case seems like something that will be
implemented using much lower level kernel interface, like a GPU
programming interface (aka proprietary Adreno C2D API), or through
multiple nodes (multiple inputs and outputs). It's seems like the cut
between high-end and low-end.

>=20
> - API for 2D-accelerated operations other than blitting (filling, point a=
nd=20
> line drawing, ...)

I doubt such hardware exist in a form that is not bound to the GPU. I'm
not ignoring your point, there is a clear overlap between how we
integrated GPUs and having this into V4L2.

>=20
> > > Additionally, V4L2 M2M has one source and one destination. How do you
> > > implement alpha blending in that case, which by definition requires a=
t
> > > least two sources ?
> >=20
> > This type of HW only do in-place blits. When using such a node, the
> > buffer queued on the V4L2_CAPTURE contains the destination image, and
> > the buffer queued on the V4L2_OUTPUT is the source image.
> >=20
> > > > The code in rga-hw.c is used to configure regs accroding to operati=
ons.
> > > >=20
> > > > The code in rga-buf.c is used to create private mmu table for RGA.
> > > > The tables is stored in a list, and be removed when buffer is clean=
up.
> > >=20
> > > Looking at the implementation it seems to be a scatter-gather list, n=
ot an
> > > MMU. Is that right ? Does the hardware documentation refer to it as a=
n MMU
> > > ?
> > >=20
> > > > Signed-off-by: Jacob Chen <jacob-chen@iotwrt.com>
> > > > ---
> > > >=20
> > > >  drivers/media/platform/Kconfig                |  11 +
> > > >  drivers/media/platform/Makefile               |   2 +
> > > >  drivers/media/platform/rockchip-rga/Makefile  |   3 +
> > > >  drivers/media/platform/rockchip-rga/rga-buf.c | 122 ++++
> > > >  drivers/media/platform/rockchip-rga/rga-hw.c  | 652 ++++++++++++++=
++++
> > > >  drivers/media/platform/rockchip-rga/rga-hw.h  | 437 ++++++++++++
> > > >  drivers/media/platform/rockchip-rga/rga.c     | 958 ++++++++++++++=
+++++
> > > >  drivers/media/platform/rockchip-rga/rga.h     | 111 +++
> > > >  8 files changed, 2296 insertions(+)
> > > >  create mode 100644 drivers/media/platform/rockchip-rga/Makefile
> > > >  create mode 100644 drivers/media/platform/rockchip-rga/rga-buf.c
> > > >  create mode 100644 drivers/media/platform/rockchip-rga/rga-hw.c
> > > >  create mode 100644 drivers/media/platform/rockchip-rga/rga-hw.h
> > > >  create mode 100644 drivers/media/platform/rockchip-rga/rga.c
> > > >  create mode 100644 drivers/media/platform/rockchip-rga/rga.h
>=20
>=20
--=-MLq+ZlnsOw6a2s5K040R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCWWzNdgAKCRBxUwItrAao
HBcTAKCQZR4RihMZanSVmDgHXTrn3pqoPwCgoQzkGpxf4AaOudcCqju7PDaLWRQ=
=yj2i
-----END PGP SIGNATURE-----

--=-MLq+ZlnsOw6a2s5K040R--
