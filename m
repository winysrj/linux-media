Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47832 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755336AbeBOLHr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Feb 2018 06:07:47 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2] videodev2.h: add helper to validate colorspace
Date: Thu, 15 Feb 2018 13:08:20 +0200
Message-ID: <2053928.E9OymEAqzL@avalon>
In-Reply-To: <ecea7e97-de20-6d11-3ad4-680bab4628f0@xs4all.nl>
References: <20180214103643.8245-1-niklas.soderlund+renesas@ragnatech.se> <3434065.V6QgqqWRc5@avalon> <ecea7e97-de20-6d11-3ad4-680bab4628f0@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thursday, 15 February 2018 12:57:44 EET Hans Verkuil wrote:
> On 14/02/18 16:16, Laurent Pinchart wrote:
> > On Wednesday, 14 February 2018 12:36:43 EET Niklas S=F6derlund wrote:
> >> There is no way for drivers to validate a colorspace value, which could
> >> be provided by user-space by VIDIOC_S_FMT for example. Add a helper to
> >> validate that the colorspace value is part of enum v4l2_colorspace.
> >>=20
> >> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.=
se>
> >> ---
> >>=20
> >>  include/uapi/linux/videodev2.h | 4 ++++
> >>  1 file changed, 4 insertions(+)
> >>=20
> >> Hi,
> >>=20
> >> I hope this is the correct header to add this helper to. I think it's
> >> since if it's in uapi not only can v4l2 drivers use it but tools like
> >> v4l-compliance gets access to it and can be updated to use this instead
> >> of the hard-coded check of just < 0xff as it was last time I checked.
> >>=20
> >> * Changes since v1
> >> - Cast colorspace to u32 as suggested by Sakari and only check the upp=
er
> >>=20
> >>   boundary to address a potential issue brought up by Laurent if the
> >>  =20
> >>   data type tested is u32 which is not uncommon:
> >>     enum.c:30:16: warning: comparison of unsigned expression >=3D 0 is
> >>     always
> >>=20
> >> true [-Wtype-limits]
> >>=20
> >>       return V4L2_COLORSPACE_IS_VALID(colorspace);
> >>=20
> >> diff --git a/include/uapi/linux/videodev2.h
> >> b/include/uapi/linux/videodev2.h index
> >> 9827189651801e12..1f27c0f4187cbded 100644
> >> --- a/include/uapi/linux/videodev2.h
> >> +++ b/include/uapi/linux/videodev2.h
> >> @@ -238,6 +238,10 @@ enum v4l2_colorspace {
> >>=20
> >>  	V4L2_COLORSPACE_DCI_P3        =3D 12,
> >> =20
> >>  };
> >>=20
> >> +/* Determine if a colorspace is defined in enum v4l2_colorspace */
> >> +#define V4L2_COLORSPACE_IS_VALID(colorspace)		\
> >> +	((u32)(colorspace) <=3D V4L2_COLORSPACE_DCI_P3)
>=20
> Sorry, this won't work. Use __u32. u32 is only available in the kernel, n=
ot
> in userspace and this is a public header.

Indeed, that I should have caught.

> I am not convinced about the usefulness of this check either. Drivers will
> typically only support a subset of the available colorspaces, so they need
> a switch to test for that.

Most MC drivers won't, as they don't care about colorspaces in most subdevs=
=2E=20
It's important for the colorspace to be propagated within subdevs, and=20
validated across the pipeline, but in most case, apart from the image sourc=
e=20
subdev, other subdevs won't care. They should accept any valid colorspace=20
given to them and propagate it to their source pads unchanged (except of=20
course for subdevs that can change the colorspace, but that's the exception=
,=20
not the rule).

> There is nothing wrong with userspace giving them an unknown colorspace:
> either they will map anything they don't support to something that they DO
> support, or they will return -EINVAL.

The former, not the latter. S_FMT should not return -EINVAL for unsupported=
=20
colorspace, the same way it doesn't return -EINVAL for unsupported pixel=20
formats.

> If memory serves the spec requires the first option, so anything unknown
> will just be replaced.
>=20
> And anyway, this raises the question of why you do this for the colorspace
> but not for all the other enums in the V4L2 API.

Because v4l2-compliance tries to set a colorspace > 0xff and expects that t=
o=20
be replaced by a colorspace <=3D 0xff. That seems like a bogus check to me,=
 0xff=20
is as random as it can get.

> It all seems rather pointless to me.
>=20
> I won't accept this unless I see it being used in a driver in a useful wa=
y.
>=20
> So for now:
>=20
> Nacked-by: Hans Verkuil <hans.verkuil@cisco.com>

Can you then fix v4l2-compliance to stop testing colorspace against 0xff ?

> >> +
> >=20
> > Casting to u32 has the added benefit that the colorspace expression is
> > evaluated once only, I like that.
> >=20
> > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >=20
> >>  /*
> >>   * Determine how COLORSPACE_DEFAULT should map to a proper colorspace.
> >>   * This depends on whether this is a SDTV image (use SMPTE 170M), an

=2D-=20
Regards,

Laurent Pinchart
