Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:53725 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754668AbdBVUDU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Feb 2017 15:03:20 -0500
Message-ID: <1487793793.5907.25.camel@collabora.com>
Subject: Re: [PATCH v5 1/3] [media] exynos-gsc: Use user configured
 colorspace if provided
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: Thibault Saunier <thibault.saunier@osg.samsung.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Andi Shyti <andi.shyti@samsung.com>,
        linux-media@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Date: Wed, 22 Feb 2017 15:03:13 -0500
In-Reply-To: <4fc7b224-b167-51f0-e60b-c4dff35a8986@osg.samsung.com>
References: <20170221192059.29745-1-thibault.saunier@osg.samsung.com>
         <20170221192059.29745-2-thibault.saunier@osg.samsung.com>
         <329a892b-eb57-26a5-d048-cfe4efc331b6@xs4all.nl>
         <58ee4eb5-981d-175f-52a9-445bbc265af0@osg.samsung.com>
         <02a38e14-052b-faf2-a7a1-ef2f968f6d35@xs4all.nl>
         <4fc7b224-b167-51f0-e60b-c4dff35a8986@osg.samsung.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-OxDXoUHTC/EG1BXiZN6i"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-OxDXoUHTC/EG1BXiZN6i
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mercredi 22 f=C3=A9vrier 2017 =C3=A0 15:57 -0300, Thibault Saunier a =C3=
=A9crit=C2=A0:
> On 02/22/2017 03:06 PM, Hans Verkuil wrote:
> >=20
> > On 02/22/2017 05:05 AM, Thibault Saunier wrote:
> > > Hello,
> > >=20
> > >=20
> > > On 02/21/2017 11:19 PM, Hans Verkuil wrote:
> > > > On 02/21/2017 11:20 AM, Thibault Saunier wrote:
> > > > > Use colorspace provided by the user as we are only doing
> > > > > scaling and
> > > > > color encoding conversion, we won't be able to transform the
> > > > > colorspace
> > > > > itself and the colorspace won't mater in that operation.
> > > > >=20
> > > > > Also always use output colorspace on the capture side.
> > > > >=20
> > > > > Start using 576p as a threashold to compute the colorspace.
> > > > > The media documentation says that the
> > > > > V4L2_COLORSPACE_SMPTE170M colorspace
> > > > > should be used for SDTV and V4L2_COLORSPACE_REC709 for HDTV.
> > > > > But drivers
> > > > > don't agree on the display resolution that should be used as
> > > > > a threshold.
> > > > >=20
> > > > > =C2=A0 From EIA CEA 861B about colorimetry for various
> > > > > resolutions:
> > > > >=20
> > > > > =C2=A0=C2=A0=C2=A0=C2=A0- 5.1 480p, 480i, 576p, 576i, 240p, and 2=
88p
> > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0The color space used by the 4=
80-line, 576-line, 240-
> > > > > line, and 288-line
> > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0formats will likely be based =
on SMPTE 170M [1].
> > > > > =C2=A0=C2=A0=C2=A0=C2=A0- 5.2 1080i, 1080p, and 720p
> > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0The color space used by the h=
igh definition formats
> > > > > will likely be
> > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0based on ITU-R BT.709-4
> > > > >=20
> > > > > This indicates that in the case that userspace does not
> > > > > specify what
> > > > > colorspace should be used, we should use 576p=C2=A0=C2=A0as a thr=
eshold
> > > > > to set
> > > > > V4L2_COLORSPACE_REC709 instead of V4L2_COLORSPACE_SMPTE170M.
> > > > > Even if it is
> > > > > only 'likely' and not a requirement it is the best guess we
> > > > > can make.
> > > > >=20
> > > > > The stream should have been encoded with the information and
> > > > > userspace
> > > > > has to pass it to the driver if it is not the case, otherwise
> > > > > we won't be
> > > > > able to handle it properly anyhow.
> > > > >=20
> > > > > Also, check for the resolution in G_FMT instead
> > > > > unconditionally setting
> > > > > the V4L2_COLORSPACE_REC709 colorspace.
> > > > >=20
> > > > > Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.c
> > > > > om>
> > > > > Signed-off-by: Thibault Saunier <thibault.saunier@osg.samsung
> > > > > .com>
> > > > > Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
> > > > >=20
> > > > > ---
> > > > >=20
> > > > > Changes in v5:
> > > > > - Squash commit to always use output colorspace on the
> > > > > capture side
> > > > > =C2=A0=C2=A0=C2=A0=C2=A0inside this one
> > > > > - Fix typo in commit message
> > > > >=20
> > > > > Changes in v4:
> > > > > - Reword commit message to better back our assumptions on
> > > > > specifications
> > > > >=20
> > > > > Changes in v3:
> > > > > - Do not check values in the g_fmt functions as Andrzej
> > > > > explained in previous review
> > > > > - Added 'Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>'
> > > > >=20
> > > > > Changes in v2: None
> > > > >=20
> > > > > =C2=A0=C2=A0=C2=A0drivers/media/platform/exynos-gsc/gsc-core.c | =
20
> > > > > +++++++++++++++-----
> > > > > =C2=A0=C2=A0=C2=A0drivers/media/platform/exynos-gsc/gsc-core.h |=
=C2=A0=C2=A01 +
> > > > > =C2=A0=C2=A0=C2=A02 files changed, 16 insertions(+), 5 deletions(=
-)
> > > > >=20
> > > > > diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c
> > > > > b/drivers/media/platform/exynos-gsc/gsc-core.c
> > > > > index 59a634201830..772599de8c13 100644
> > > > > --- a/drivers/media/platform/exynos-gsc/gsc-core.c
> > > > > +++ b/drivers/media/platform/exynos-gsc/gsc-core.c
> > > > > @@ -454,6 +454,7 @@ int gsc_try_fmt_mplane(struct gsc_ctx
> > > > > *ctx, struct v4l2_format *f)
> > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0} else {
> > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0min_w =3D variant->pix_min->target_rot_dis_w;
> > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0min_h =3D variant->pix_min->target_rot_dis_h;
> > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0pix_mp->colorspa=
ce =3D ctx->out_colorspace;
> > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0pr_debug("m=
od_x: %d, mod_y: %d, max_w: %d, max_h =3D
> > > > > %d",
> > > > > @@ -472,10 +473,15 @@ int gsc_try_fmt_mplane(struct gsc_ctx
> > > > > *ctx, struct v4l2_format *f)
> > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0pix_mp->num=
_planes =3D fmt->num_planes;
> > > > > =C2=A0=C2=A0=C2=A0-=C2=A0=C2=A0=C2=A0=C2=A0if (pix_mp->width >=3D=
 1280) /* HD */
> > > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0pix_mp->colorspa=
ce =3D V4L2_COLORSPACE_REC709;
> > > > > -=C2=A0=C2=A0=C2=A0=C2=A0else /* SD */
> > > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0pix_mp->colorspa=
ce =3D V4L2_COLORSPACE_SMPTE170M;
> > > > > +=C2=A0=C2=A0=C2=A0=C2=A0if (pix_mp->colorspace =3D=3D V4L2_COLOR=
SPACE_DEFAULT) {
> > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (pix_mp->widt=
h > 720 && pix_mp->height > 576) /*
> > > > > HD */
> > > >=20
> > > > I'd use || instead of && here. Ditto for the next patch.
> > > >=20
> > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0pix_mp->colorspace =3D V4L2_COLORSPACE_REC709;
> > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0else /* SD */
> > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0pix_mp->colorspace =3D V4L2_COLORSPACE_SMPTE170M;
> > > > > +=C2=A0=C2=A0=C2=A0=C2=A0}
> > > >=20
> > > > Are you sure this is in fact how it is used? If the source of
> > > > the video
> > > > is the sensor (camera), then the colorspace is typically SRGB.
> > > > I'm not
> > > > really sure you should guess here. All a mem2mem driver should
> > > > do is to
> > > > pass the colorspace etc. information from the output to the
> > > > capture side,
> > > > and not invent things. That simply makes no sense.
> > >=20
> > > This is not a camera device but a colorspace conversion device,
> > > in many
> >=20
> > Not really, this is a color encoding conversion device. I.e. it
> > only affects
> > the Y'CbCr encoding and quantization range. The colorspace (aka
> > chromaticities)
> > and transfer function remain unchanged.
>=20
> Well, right, sorry I am talking in GStreamer terminlogy where what
> you call
> colorspace is called colorimetry, and colorspace is what I am
> talking=C2=A0
> about here.
>=20
> > In fact, I suspect (correct me if I am wrong) that it only converts
> > between
> > RGB, Y'CbCr 601 and Y'CbCr 709 encodings, where RGB is full range
> > and the Y'CbCr
> > formats are limited range.
>=20
> That sounds correct.
>=20
> > If you pass in limited range RGB it will probably do the wrong
> > thing as I don't
> > seen any quantization checks in the code.
> >=20
> > So the colorspace and xfer_func fields remain unchanged by this
> > driver.
> >=20
> > If you want to do this really correctly, then you need to do more.
> > I don't have
> > time right now to go into this in-depth, but I will try to get back
> > to this on
> > Monday. I am thinking of documenting this as part of the V4L2
> > colorspace
> > documentation. This stuff is complex and if you don't know the
> > rules then it
> > can be hard to implement correctly.
>=20
> Here I am just making sure that we set the colorspace (v4l2
> terminology)
> if the case the user is passing DEFAULT (meaning he does not know
> what
> it should be and lets the driver set it, this will happen in the
> case=C2=A0
> where the
> information was not contain in the source, which means the value has
> to be
> guessed, and here I am simply doing an educated guess relying on what
> the
> previously named standard suggests.
>=20
> I would be happy to read more information about that subject and will
> try to fix remaining suggested points once I have a better
> understanding
> of the whole concepts and problems in that driver, but I still think=C2=
=A0
> that this
> patch is correct for what it is aiming at fixing.
>=20
> Regards,
>=20
> Thibault Saunier
>=20
> > > cases the info will not be passed by the userspace, basically
> > > because the info
> > > is not encoded in the media stream (this often happens). I am not
> > > inventing here,
> > > just making sure we use the most likely value in case none was
> > > provided (and if none
> > > was provided it should always be correct given that the encoded
> > > stream was not broken).
> > >=20
> > > In the case the source is a camera and then we use the colorspace
> > > converter then the info
> > > should copied from the camera to the transcoding node (by
> > > userspace) so there should be
> > > no problem.
> > >=20
> > > What I am doing here is what is done in other drivers.
> >=20
> > Most (all?) other mem2mem drivers do not do color encoding
> > conversion, they just copy
> > all the colorspace info from output to capture.
> >=20
> > If there are other m2m drivers that do this, then I doubt they do
> > the right thing.
> > They are probably right for most cases, but not all.
> >=20
> > Regards,
> >=20
> > 	Hans

I think Hans is right about the colorspace here. Unlike the field for
interlace modes, there it is no mandatory requirement in the spec for
the driver to change DEFAULT into something else. If you don't know the
input colorspace, then you don't known the output. Even in GStreamer,
this would be best, since the only guessing will happen at the display,
or in some conversion to RGB. Though, if you don't support a specific
value, then the driver should change it.

Where I don't agree though, is that an m2m color converter will always
copy blindly that colorspace. Even though the support is limited,
sometime it may change, this need to be sorted case by case. I have
rarely seen such a driver keep the limited range when turning buffers
into RGB data.

But changing the colorspace is complicated, since it's slightly vague
concept. It will in fact imply a specific set of v4l2_xfer_func,
v4l2_ycbcr_encoding and v4l2_quantization (ignoring hsv, as it does not
apply). If you have a limited driver, that only target one of these 3
items, you will likely keep the colorspace as-is, and override the
specific functions.
--=-OxDXoUHTC/EG1BXiZN6i
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlit7oEACgkQcVMCLawGqBzzWgCfaNQ5E5PNv7NE+AMPS1TwHjRZ
GGUAoMXBLEvrEUFdLSKBwaUbjsMtIHuZ
=vKpv
-----END PGP SIGNATURE-----

--=-OxDXoUHTC/EG1BXiZN6i--
