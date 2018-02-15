Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48298 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030843AbeBONGL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Feb 2018 08:06:11 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2] videodev2.h: add helper to validate colorspace
Date: Thu, 15 Feb 2018 15:06:45 +0200
Message-ID: <379706702.poEXdVxToB@avalon>
In-Reply-To: <258fbbf3-9f2b-79e8-8a28-b177ea3d05ad@xs4all.nl>
References: <20180214103643.8245-1-niklas.soderlund+renesas@ragnatech.se> <37073075.RbtH2Do48G@avalon> <258fbbf3-9f2b-79e8-8a28-b177ea3d05ad@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thursday, 15 February 2018 14:32:55 EET Hans Verkuil wrote:
> On 15/02/18 13:06, Laurent Pinchart wrote:
> > On Thursday, 15 February 2018 13:56:44 EET Hans Verkuil wrote:
> >> On 15/02/18 12:08, Laurent Pinchart wrote:
> >>> On Thursday, 15 February 2018 12:57:44 EET Hans Verkuil wrote:
> >>>> On 14/02/18 16:16, Laurent Pinchart wrote:
> >>>>> On Wednesday, 14 February 2018 12:36:43 EET Niklas S=F6derlund wrot=
e:
> >>>>>> There is no way for drivers to validate a colorspace value, which
> >>>>>> could be provided by user-space by VIDIOC_S_FMT for example. Add a
> >>>>>> helper to validate that the colorspace value is part of enum
> >>>>>> v4l2_colorspace.
> >>>>>>=20
> >>>>>> Signed-off-by: Niklas S=F6derlund
> >>>>>> <niklas.soderlund+renesas@ragnatech.se>
> >>>>>> ---
> >>>>>>=20
> >>>>>>  include/uapi/linux/videodev2.h | 4 ++++
> >>>>>>  1 file changed, 4 insertions(+)
> >>>>>>=20
> >>>>>> Hi,
> >>>>>>=20
> >>>>>> I hope this is the correct header to add this helper to. I think i=
t's
> >>>>>> since if it's in uapi not only can v4l2 drivers use it but tools l=
ike
> >>>>>> v4l-compliance gets access to it and can be updated to use this
> >>>>>> instead of the hard-coded check of just < 0xff as it was last time=
 I
> >>>>>> checked.
> >>>>>>=20
> >>>>>> * Changes since v1
> >>>>>> - Cast colorspace to u32 as suggested by Sakari and only check the
> >>>>>>   upper boundary to address a potential issue brought up by Laurent
> >>>>>>   if the data type tested is u32 which is not uncommon:
> >>>>>>     enum.c:30:16: warning: comparison of unsigned expression >=3D =
0 is
> >>>>>>     always true [-Wtype-limits]
> >>>>>>    =20
> >>>>>>       return V4L2_COLORSPACE_IS_VALID(colorspace);
> >>>>>>=20
> >>>>>> diff --git a/include/uapi/linux/videodev2.h
> >>>>>> b/include/uapi/linux/videodev2.h index
> >>>>>> 9827189651801e12..1f27c0f4187cbded 100644
> >>>>>> --- a/include/uapi/linux/videodev2.h
> >>>>>> +++ b/include/uapi/linux/videodev2.h
> >>>>>> @@ -238,6 +238,10 @@ enum v4l2_colorspace {
> >>>>>>  	V4L2_COLORSPACE_DCI_P3        =3D 12,
> >>>>>>  };
> >>>>>>=20
> >>>>>> +/* Determine if a colorspace is defined in enum v4l2_colorspace */
> >>>>>> +#define V4L2_COLORSPACE_IS_VALID(colorspace)		\
> >>>>>> +	((u32)(colorspace) <=3D V4L2_COLORSPACE_DCI_P3)
> >>>>=20
> >>>> Sorry, this won't work. Use __u32. u32 is only available in the kern=
el,
> >>>> not in userspace and this is a public header.
> >>>=20
> >>> Indeed, that I should have caught.
> >>>=20
> >>>> I am not convinced about the usefulness of this check either. Drivers
> >>>> will typically only support a subset of the available colorspaces, so
> >>>> they need a switch to test for that.
> >>>=20
> >>> Most MC drivers won't, as they don't care about colorspaces in most
> >>> subdevs. It's important for the colorspace to be propagated within
> >>> subdevs, and validated across the pipeline, but in most case, apart f=
rom
> >>> the image source subdev, other subdevs won't care. They should accept
> >>> any valid colorspace given to them and propagate it to their source p=
ads
> >>> unchanged (except of course for subdevs that can change the colorspac=
e,
> >>> but that's the exception, not the rule).
> >>=20
> >> Right. So 'passthrough' subdevs should just copy this information from
> >> source to sink, and only pure source or pure sink subdevs should valid=
ate
> >> these fields. That makes sense.
> >>=20
> >>>> There is nothing wrong with userspace giving them an unknown
> >>>> colorspace: either they will map anything they don't support to
> >>>> something that they DO support, or they will return -EINVAL.
> >>>=20
> >>> The former, not the latter. S_FMT should not return -EINVAL for
> >>> unsupported colorspace, the same way it doesn't return -EINVAL for
> >>> unsupported pixel formats.
> >>>=20
> >>>> If memory serves the spec requires the first option, so anything
> >>>> unknown will just be replaced.
> >>>>=20
> >>>> And anyway, this raises the question of why you do this for the
> >>>> colorspace but not for all the other enums in the V4L2 API.
> >>>=20
> >>> Because v4l2-compliance tries to set a colorspace > 0xff and expects
> >>> that to be replaced by a colorspace <=3D 0xff. That seems like a bogus
> >>> check to me, 0xff is as random as it can get.
> >>=20
> >> v4l2-compliance fills all fields with 0xff, then it checks after calli=
ng
> >> the ioctl if all fields have been set to valid values.
> >>=20
> >> But in this case it should ignore the colorspace-related fields for
> >> passthrough subdevs. The only passthrough devices that should set
> >> colorspace are colorspace converter devices. I'm not sure if we can
> >> reliably detect that.
> >>=20
> >>>> It all seems rather pointless to me.
> >>>>=20
> >>>> I won't accept this unless I see it being used in a driver in a usefu
> >>>> way.
> >>>>=20
> >>>> So for now:
> >>>>=20
> >>>> Nacked-by: Hans Verkuil <hans.verkuil@cisco.com>
> >>>=20
> >>> Can you then fix v4l2-compliance to stop testing colorspace against 0=
xff
> >>> ?
> >>=20
> >> For now I can simply relax this test for subdevs with sources and sink=
s.
> >=20
> > You also need to relax it for video nodes with MC drivers, as the DMA
> > engines don't care about colorspaces.
>=20
> Yes, they do. Many DMA engines can at least do RGB <-> YUV conversions, so
> they should get the colorspace info from their source and pass it on to
> userspace (after correcting for any conversions done by the DMA engine).

Not in the MC case. Video nodes there only model the DMA engine, and are th=
us=20
not aware of colorspaces. What MC drivers do is check at stream on time whe=
n=20
validating the pipeline that the colorspace set by userspace on the video n=
ode=20
corresponds to the colorspace on the source pad of the connected subdev, bu=
t=20
that's only to ensure that userspace gets a coherent view of colorspace acr=
oss=20
the pipeline, not to program the hardware. There could be exceptions, but i=
n=20
the general case, the video node implementation of an MC driver will accept=
=20
any colorspace and only validate it at stream on time, similarly to how it=
=20
does for the frame size format instance (and in the frame size case it will=
=20
usually enforce min/max limits when the DMA engine limits the frame size).

=2D-=20
Regards,

Laurent Pinchart
