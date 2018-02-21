Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52748 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751203AbeBUUPn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Feb 2018 15:15:43 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2] videodev2.h: add helper to validate colorspace
Date: Wed, 21 Feb 2018 22:16:25 +0200
Message-ID: <2556801.UsItpXbr2P@avalon>
In-Reply-To: <94142433-a72d-ddd4-22bc-b36380f4efbc@xs4all.nl>
References: <20180214103643.8245-1-niklas.soderlund+renesas@ragnatech.se> <20180219222804.GD8442@bigcity.dyn.berto.se> <94142433-a72d-ddd4-22bc-b36380f4efbc@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tuesday, 20 February 2018 10:37:22 EET Hans Verkuil wrote:
> On 02/19/2018 11:28 PM, Niklas S=F6derlund wrote:
> > Hi Hans,
> >=20
> > Thanks for your feedback.
> >=20
> > [snip]
> >=20
> >>>>>> Can you then fix v4l2-compliance to stop testing colorspace
> >>>>>> against 0xff
> >>>>>> ?
> >>>>>=20
> >>>>> For now I can simply relax this test for subdevs with sources and
> >>>>> sinks.
> >>>>=20
> >>>> You also need to relax it for video nodes with MC drivers, as the DMA
> >>>> engines don't care about colorspaces.
> >>>=20
> >>> Yes, they do. Many DMA engines can at least do RGB <-> YUV conversion=
s,
> >>> so they should get the colorspace info from their source and pass it =
on
> >>> to userspace (after correcting for any conversions done by the DMA
> >>> engine).
> >>=20
> >> Not in the MC case. Video nodes there only model the DMA engine, and a=
re
> >> thus not aware of colorspaces. What MC drivers do is check at stream on
> >> time when validating the pipeline that the colorspace set by userspace
> >> on the video node corresponds to the colorspace on the source pad of t=
he
> >> connected subdev, but that's only to ensure that userspace gets a
> >> coherent view of colorspace across the pipeline, not to program the
> >> hardware. There could be exceptions, but in the general case, the video
> >> node implementation of an MC driver will accept any colorspace and only
> >> validate it at stream on time, similarly to how it does for the frame
> >> size format instance (and in the frame size case it will usually enfor=
ce
> >> min/max limits when the DMA engine limits the frame size).>=20
> > I'm afraid the issue described above by Laurent is what sparked me to
> > write this commit to begin with. In my never ending VIN Gen3 patch-set I
> > currency need to carry a patch [1] to implement a hack to make sure
> > v4l2-compliance do not fail for the VIN Gen3 MC-centric use-case. This
> > patch was an attempt to be able to validate the colorspace using the
> > magic value 0xff.
>=20
> This is NOT a magic value. The test that's done here is to memset the
> format structure with 0xff, then call the ioctl. Afterwards it checks
> if there are any remaining 0xff bytes left in the struct since it expects
> the driver to have overwritten it by something else. That's where the 0xff
> comes from.

It's no less or more magic than using 0xdeadbeef or any fixed value :-) I=20
think we all agree that it isn't a value that is meant to be handled=20
specifically by drivers, so it's not magic in that sense.

> > I don't feel strongly for this patch in particular and I'm happy to drop
> > it.  But I would like to receive some guidance on how to then properly
> > be able to handle this problem for the MC-centric VIN driver use-case.
> > One option is as you suggested to relax the test in v4l-compliance to
> > not check colorspace, but commit [2] is not enough to resolve the issue
> > for my MC use-case.
> >=20
> > As Laurent stated above, the use-case is that the video device shall
> > accept any colorspace set from user-space. This colorspace is then only
> > used as stream on time to validate the MC pipeline. The VIN driver do
> > not care about colorspace, but I care about not breaking v4l2-compliance
> > as I find it's a very useful tool :-)
>=20
> I think part of my confusion here is that there are two places where you
> deal with colorspaces in a DMA engine: first there is a input pad of the
> DMA engine entity, secondly there is the v4l2_pix_format for the memory
> description.
>=20
> The second is set by the driver based on what userspace specified for the
> input pad, together with any changes due to additional conversions such
> as quantization range and RGB <-> YUV by the DMA engine.

No, I'm sorry, for MC-based drivers this isn't correct. The media entity th=
at=20
symbolizes the DMA engine indeed has a sink pad, but it's a video node, not=
 a=20
subdev. It thus has no media bus format configured for its sink pad. The=20
closest pad in the pipeline that has a media bus format is the source pad o=
f=20
the subdev connected to the video node.

There's no communication within the kernel at G/S_FMT time between the vide=
o=20
node and its connected subdev. The only time we look at the pipeline as a=20
whole is when starting the stream to validate that the pipeline is correctl=
y=20
configured. We thus have to implement G/S_FMT on the video node without any=
=20
knowledge about the connected subdev, and thus accept any colorspace.

> So any colorspace validation is done for the input pad. The question is
> what that validation should be. It's never been defined.

No format is set on the video node's entity sink pad for the reason above, =
so=20
no validation occurs when setting the colorspace on the sink pad as that ne=
ver=20
happens.

> Also the handling of COLORSPACE_DEFAULT for pad formats needs to be defin=
ed.
>=20
> This is not the first time this cropped up, see e.g. this RFC patch:
>=20
> https://patchwork.linuxtv.org/patch/41734/
>=20
> > I'm basing the following on the latest v4l-utils master
> > (4665ab1fbab1ddaa)  which contains commit [2]. The core issue is that if
> > I do not have a patch like [1] the v4l2-compliance run fails for format
> > ioctls:
> >=20
> > Format ioctls (Input 0):
> > 	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
> > 	test VIDIOC_G/S_PARM: OK (Not Supported)
> > 	test VIDIOC_G_FBUF: OK (Not Supported)
> > =09
> > 		fail: v4l2-test-formats.cpp(330): !colorspace
> > 		fail: v4l2-test-formats.cpp(439): testColorspace(pix.pixelformat,
> > 		pix.colorspace, pix.ycbcr_enc, pix.quantization)> =09
> > 	test VIDIOC_G_FMT: FAIL
> > 	test VIDIOC_TRY_FMT: OK (Not Supported)
> > 	test VIDIOC_S_FMT: OK (Not Supported)
> > 	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
> > 	test Cropping: OK (Not Supported)
> > 	test Composing: OK (Not Supported)
> > 	test Scaling: OK
> >=20
> > Well that is OK as that fails when colorspace is V4L2_COLORSPACE_DEFAULT
> > and that is not valid. If I instead of reverting [1] only test for
> > V4L2_COLORSPACE_DEFAULT which would not require this patch to implement:
> >=20
> > -       if (!pix->colorspace || pix->colorspace >=3D 0xff)
> > +       if (pix->colorspace =3D=3D V4L2_COLORSPACE_DEFAULT)
> >=20
> > I still fail for the format ioctls:
> >=20
> > Format ioctls (Input 0):
> > 	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
> > 	test VIDIOC_G/S_PARM: OK (Not Supported)
> > 	test VIDIOC_G_FBUF: OK (Not Supported)
> > 	test VIDIOC_G_FMT: OK
> > =09
> > 		fail: v4l2-test-formats.cpp(336): colorspace >=3D 0xff
> > 		fail: v4l2-test-formats.cpp(439): testColorspace(pix.pixelformat,
> > 		pix.colorspace, pix.ycbcr_enc, pix.quantization) fail:
> > 		v4l2-test-formats.cpp(753): Video Capture is valid, but TRY_FMT
> > 		failed to return a format
> > 	test VIDIOC_TRY_FMT: FAIL
> > =09
> > 		fail: v4l2-test-formats.cpp(336): colorspace >=3D 0xff
> > 		fail: v4l2-test-formats.cpp(439): testColorspace(pix.pixelformat,
> > 		pix.colorspace, pix.ycbcr_enc, pix.quantization) fail:
> > 		v4l2-test-formats.cpp(1018): Video Capture is valid, but no S_FMT
> > 		was implemented
> > 	test VIDIOC_S_FMT: FAIL
> > 	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
> > 	test Cropping: OK (Not Supported)
> > 	test Composing: OK (Not Supported)
> > 	test Scaling: OK
> >=20
> > But now I fail on that colorspace >=3D 0xff which was what the patch in=
 my
> > VIN Gen3 series tries to address but as Laurent points out and I agree
> > is not a good idea as the 0xff is a magic number and this patch tried to
> > add a remedy too. The root of this in v4l2-compliance is
> > createInvalidFmt() which quiet effectively creates an invalid format
> > with the colorspace set to 0xff but there are no way for drivers to
> > verify that a colorspace value from user-space is valid :-(
> >=20
> > If this patch is to be dropped, and I'm fine with that I would like your
> > opinion on how I can still keep the VIN driver compatible with the
> > compliance tool. The option's I see are:
> >=20
> > 1. Keep the patch [1] and accept that there is a need for a 0xff magic
> >    value. This 'works' but I don't think it's the correct solution.
> >=20
> > 2. Move the check this patch tries to add a helper for directly to the
> >    VIN driver. This works but will require the driver to be updated if a
> >    new colorspace is added.
> >=20
> > 3. Update createInvalidFmt() v4l2-compliance to not set the colorspace
> >    to 0xff but instead set it to V4L2_COLORSPACE_DEFAULT. A similar
> >    thing is already done for the filed in this function.
> > =09
> > 	memset(&fmt, 0xff, sizeof(fmt));
> > 	fmt.type =3D type;
> > 	fmt.fmt.pix.field =3D V4L2_FIELD_ANY;
> > 	...
> > =09
> >    I'm not sure if this is the best solution as it would not test
> >    drivers for what happens if they are presented with an invalid
> >    colorspace. But with such a change the driver can be written to still
> >    pass the test.
> >=20
> > 4. Always forcing a specific colorspace (V4L2_COLORSPACE_SRGB) in the
> >    VIN format functions and ignoring what was requested by the user.
> >   =20
> >    I don't think this is good at all as it would be possible that
> >    pipeline validation fails due to a colorspace mismatch. This can be
> >    worked around by dropping the colorspace check from the VIN stream on
> >    function.
> >=20
> > I'm sure there are other options open which I can't think of, in fact I
> > hope there are. I'm not over excited about any of the options above as
> > they all in one way or another just works around the problem of being
> > able to validate input from user-space. But I'm even less excited about
> > breaking v4l2-compliance compatibility so any path I can take here to
> > keep the user being able to specify the colorspace and v4l2-compliance
> > being happy would be a better solution for me :-)
> >=20
> > 1. https://patchwork.linuxtv.org/patch/46717/
> > 2. 432d9ebfcea65337 ("v4l2-compliance: ignore colorspace tests for pass=
thu
> > subdevs")
>=20
> I do not want to relax the test for colorspace for the v4l2_pix_format in
> the compliance test. That test is good and should remain.
>=20
> For the input pad format there are two issues:

There's no input pad format :-)

> 1) Setting the initial colorspace information. If you open the v4l-subdev
> device then the initial colorspace data is likely all 0. That's wrong for
> the colorspace since 0 is not allowed. So init_cfg should set it to
> something non-0 (I'd expect either SRGB or RAW). Or perhaps this should be
> done in the core as a standard initialization in the absence of the
> init_cfg op (or before it is called).
>=20
> An alternative is to allow a 0 (DEFAULT) value here, but then what do you
> use in v4l2_pix_format? That definitely can't be 0. I think I prefer to
> always have something explicit here.
>=20
> 2) Validation of the colorspace fields when setting the format on the inp=
ut
> pad. After thinking about this some more I believe that the only reasonab=
le
> thing you can do here is to indeed validate it based on the current range
> of known colorspaces (or more strict of course if the hardware has
> limitations).
>=20
> But rather than adding validate defines I would just add something like t=
his
> to the colorspace enum:
>=20
> 	/* Update when a new colorspace is added */
> 	V4L2_COLORSPACE_LAST        =3D V4L2_COLORSPACE_DCI_P3
>=20
> and do the same for the other colorspace-related enums.
>=20
> In v4l2-subdev.c you can then check and validate this. Anything out-of-ra=
nge
> would map to COLORSPACE_SRGB/RAW or 0 (DEFAULT) for the other fields.
>=20
> I think SRGB is best here since it is the most widely used and understood
> colorspace.
>=20
> Another issue is pipeline validation. See the link to the RFC patch above.
> The biggest issue here is that filling in these fields has been hit-and-m=
iss
> and you don't want things to suddenly fail.
>=20
> If the core validates/initializes these fields, then at least we always s=
ee
> something valid here (i.e. never 0 or > V4L2_COLORSPACE_LAST for the
> colorspace). I'd have to think about it some more.
>=20
> This whole mess once again shows the importance of good compliance tests,
> especially for complex APIs like this. It forces you to think about how
> this should be handled instead of doing some vague hand-waving.

=2D-=20
Regards,

Laurent Pinchart
