Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f50.google.com ([209.85.215.50]:43999 "EHLO
        mail-lf0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932163AbeBSW2I (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 17:28:08 -0500
Received: by mail-lf0-f50.google.com with SMTP id q69so1512830lfi.10
        for <linux-media@vger.kernel.org>; Mon, 19 Feb 2018 14:28:07 -0800 (PST)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Mon, 19 Feb 2018 23:28:04 +0100
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2] videodev2.h: add helper to validate colorspace
Message-ID: <20180219222804.GD8442@bigcity.dyn.berto.se>
References: <20180214103643.8245-1-niklas.soderlund+renesas@ragnatech.se>
 <37073075.RbtH2Do48G@avalon>
 <258fbbf3-9f2b-79e8-8a28-b177ea3d05ad@xs4all.nl>
 <379706702.poEXdVxToB@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <379706702.poEXdVxToB@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for your feedback.

[snip]

> > >>> Can you then fix v4l2-compliance to stop testing colorspace 
> > >>> against 0xff
> > >>> ?
> > >> 
> > >> For now I can simply relax this test for subdevs with sources and sinks.
> > > 
> > > You also need to relax it for video nodes with MC drivers, as the DMA
> > > engines don't care about colorspaces.
> > 
> > Yes, they do. Many DMA engines can at least do RGB <-> YUV conversions, so
> > they should get the colorspace info from their source and pass it on to
> > userspace (after correcting for any conversions done by the DMA engine).
> 
> Not in the MC case. Video nodes there only model the DMA engine, and are thus 
> not aware of colorspaces. What MC drivers do is check at stream on time when 
> validating the pipeline that the colorspace set by userspace on the video node 
> corresponds to the colorspace on the source pad of the connected subdev, but 
> that's only to ensure that userspace gets a coherent view of colorspace across 
> the pipeline, not to program the hardware. There could be exceptions, but in 
> the general case, the video node implementation of an MC driver will accept 
> any colorspace and only validate it at stream on time, similarly to how it 
> does for the frame size format instance (and in the frame size case it will 
> usually enforce min/max limits when the DMA engine limits the frame size).

I'm afraid the issue described above by Laurent is what sparked me to 
write this commit to begin with. In my never ending VIN Gen3 patch-set I 
currency need to carry a patch [1] to implement a hack to make sure 
v4l2-compliance do not fail for the VIN Gen3 MC-centric use-case. This 
patch was an attempt to be able to validate the colorspace using the 
magic value 0xff.

I don't feel strongly for this patch in particular and I'm happy to drop 
it.  But I would like to receive some guidance on how to then properly 
be able to handle this problem for the MC-centric VIN driver use-case.  
One option is as you suggested to relax the test in v4l-compliance to 
not check colorspace, but commit [2] is not enough to resolve the issue 
for my MC use-case.

As Laurent stated above, the use-case is that the video device shall 
accept any colorspace set from user-space. This colorspace is then only 
used as stream on time to validate the MC pipeline. The VIN driver do 
not care about colorspace, but I care about not breaking v4l2-compliance 
as I find it's a very useful tool :-)

I'm basing the following on the latest v4l-utils master 
(4665ab1fbab1ddaa)  which contains commit [2]. The core issue is that if 
I do not have a patch like [1] the v4l2-compliance run fails for format 
ioctls:

Format ioctls (Input 0):
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
	test VIDIOC_G/S_PARM: OK (Not Supported)
	test VIDIOC_G_FBUF: OK (Not Supported)
		fail: v4l2-test-formats.cpp(330): !colorspace
		fail: v4l2-test-formats.cpp(439): testColorspace(pix.pixelformat, pix.colorspace, pix.ycbcr_enc, pix.quantization)
	test VIDIOC_G_FMT: FAIL
	test VIDIOC_TRY_FMT: OK (Not Supported)
	test VIDIOC_S_FMT: OK (Not Supported)
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
	test Cropping: OK (Not Supported)
	test Composing: OK (Not Supported)
	test Scaling: OK

Well that is OK as that fails when colorspace is V4L2_COLORSPACE_DEFAULT 
and that is not valid. If I instead of reverting [1] only test for 
V4L2_COLORSPACE_DEFAULT which would not require this patch to implement:

-       if (!pix->colorspace || pix->colorspace >= 0xff)
+       if (pix->colorspace == V4L2_COLORSPACE_DEFAULT)

I still fail for the format ioctls:

Format ioctls (Input 0):
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
	test VIDIOC_G/S_PARM: OK (Not Supported)
	test VIDIOC_G_FBUF: OK (Not Supported)
	test VIDIOC_G_FMT: OK
		fail: v4l2-test-formats.cpp(336): colorspace >= 0xff
		fail: v4l2-test-formats.cpp(439): testColorspace(pix.pixelformat, pix.colorspace, pix.ycbcr_enc, pix.quantization)
		fail: v4l2-test-formats.cpp(753): Video Capture is valid, but TRY_FMT failed to return a format
	test VIDIOC_TRY_FMT: FAIL
		fail: v4l2-test-formats.cpp(336): colorspace >= 0xff
		fail: v4l2-test-formats.cpp(439): testColorspace(pix.pixelformat, pix.colorspace, pix.ycbcr_enc, pix.quantization)
		fail: v4l2-test-formats.cpp(1018): Video Capture is valid, but no S_FMT was implemented
	test VIDIOC_S_FMT: FAIL
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
	test Cropping: OK (Not Supported)
	test Composing: OK (Not Supported)
	test Scaling: OK

But now I fail on that colorspace >= 0xff which was what the patch in my 
VIN Gen3 series tries to address but as Laurent points out and I agree 
is not a good idea as the 0xff is a magic number and this patch tried to 
add a remedy too. The root of this in v4l2-compliance is 
createInvalidFmt() which quiet effectively creates an invalid format 
with the colorspace set to 0xff but there are no way for drivers to 
verify that a colorspace value from user-space is valid :-(

If this patch is to be dropped, and I'm fine with that I would like your 
opinion on how I can still keep the VIN driver compatible with the 
compliance tool. The option's I see are:

1. Keep the patch [1] and accept that there is a need for a 0xff magic 
   value. This 'works' but I don't think it's the correct solution.

2. Move the check this patch tries to add a helper for directly to the 
   VIN driver. This works but will require the driver to be updated if a 
   new colorspace is added.

3. Update createInvalidFmt() v4l2-compliance to not set the colorspace 
   to 0xff but instead set it to V4L2_COLORSPACE_DEFAULT. A similar 
   thing is already done for the filed in this function.

	memset(&fmt, 0xff, sizeof(fmt));
	fmt.type = type;
	fmt.fmt.pix.field = V4L2_FIELD_ANY;
	...

   I'm not sure if this is the best solution as it would not test 
   drivers for what happens if they are presented with an invalid 
   colorspace. But with such a change the driver can be written to still 
   pass the test.

4. Always forcing a specific colorspace (V4L2_COLORSPACE_SRGB) in the 
   VIN format functions and ignoring what was requested by the user.

   I don't think this is good at all as it would be possible that 
   pipeline validation fails due to a colorspace mismatch. This can be 
   worked around by dropping the colorspace check from the VIN stream on 
   function.


I'm sure there are other options open which I can't think of, in fact I 
hope there are. I'm not over excited about any of the options above as 
they all in one way or another just works around the problem of being 
able to validate input from user-space. But I'm even less excited about 
breaking v4l2-compliance compatibility so any path I can take here to 
keep the user being able to specify the colorspace and v4l2-compliance 
being happy would be a better solution for me :-)

1. https://patchwork.linuxtv.org/patch/46717/
2. 432d9ebfcea65337 ("v4l2-compliance: ignore colorspace tests for passthu subdevs")

-- 
Regards,
Niklas Söderlund
