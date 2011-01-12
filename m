Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42022 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab1ALJFv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Jan 2011 04:05:51 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <snjw23@gmail.com>
Subject: Re: [RFC] Cropping and scaling with subdev pad-level operations
Date: Wed, 12 Jan 2011 10:06:44 +0100
Cc: linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
References: <201101061633.30029.laurent.pinchart@ideasonboard.com> <4D2CE84E.8020700@gmail.com>
In-Reply-To: <4D2CE84E.8020700@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101121006.45099.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sylwester,

On Wednesday 12 January 2011 00:31:26 Sylwester Nawrocki wrote:
> On 01/06/2011 04:33 PM, Laurent Pinchart wrote:

[snip]

> > When the stream is off, we have two options:
> > 
> > - Handle crop rectangle modifications the same way as when the stream is
> > on. This is cleaner, but bring one drawback. The user can't set the crop
> > rectangle to 500x500 and output size to 750x750 directly. No matter
> > whether the crop rectangle or output size is set first, the intermediate
> > 500x5000/4000x4000 or 4000x4000/750x750 combination are invalid. An
> > extra step will be needed: the crop rectangle will first be set to
> > 1000x1000, the output size will then be set to 750x750, and the crop
> > rectangle will finally be set to 500x500. That won't make life easy for
> > userspace applications.
> > 
> > - Modify the output size when the crop rectangle is set. With this
> > option, the output size is automatically set to the crop rectangle size
> > when the crop rectangle is changed. With the above example, setting the
> > crop rectangle to 500x500 will automatically set the output size to
> > 500x500, and the user will then just have to set the output size to
> > 750x750.
> 
> IMO, with the second option at some point it might get difficult to
> determine in the application which parameters in the driver may change
> when the application tries to change some parameter. I would expect the
> side effects to be as local as possible so the application could possibly
> get notified about them without additional steps.

I quite agree with that. Otherwise applications will need to guess what the 
side effects are, and they will end up hardcoding behaviours depending on the 
device model. That's bad.

> > The second option has a major drawback as well, as there's no way for
> > applications to query the minimum/maximum zoom factor. With the first
> > option an application can set the desired output size, and then set a
> > very small crop rectangle to retrieve the minimum allowed crop rectangle
> > (and thus the maximum zoom factor). With the second option the output
> > size will be changed when the crop rectangle is set, so this isn't
> > possible anymore.
> > 
> > Retrieving the maximum zoom factor in the stream off state is an
> > application requirement to be able to display the zoom level on a GUI
> > (with a slider for instance).
> 
> In the Samsung S5P FIMC driver minimum and maximum scaling ratios are 1/64
> and 64. So the scaling limits bite a bit less than in your case in typical
> applications, the problem remains still same though.
> The driver uses the v4l2 mem-to-mem framework so it may be considered much
> as your resizer example with an input and output pad. The FIMC H/W supports
> cropping at the scaler input and also an effective output rectangle can be
> positioned within the output buffer. The latter allows e.g. placing the
> video window at the arbitrary position on a framebuffer.
> 
> Currently, with the mem-to-mem driver the application is required to set
> the format at the device input and output first (V4L2_BUF_TYPE_OUTPUT and
> *_CAPTURE stream respectively). The relation between both image formats,
> i.e. scaling ratio was not being checked in s_fmt because it also depended
> on whether the rotator was enabled or not. So the check was postponed to
> actual transaction setup/start. This seems wrong to me and I want to change
> it so the scaler limits are checked in try/set_fmt, try/set_crop
> and s_control(ROTATION).
> 
> Then when the crop rectangle is set it is being checked for the scaling
> ratio limit against current crop/full window size at the opposite side
> of the scaler.  When a scaling ratio is not within the supported range an
> error is returned. The crop  window is adjusted in s_crop only when the
> device's alignment requirements would not have been fulfilled. But I am
> going to change that so the crop rectangle is adjusted according to the
> resizer limits as well, without changing the effective image size at the
> opposite side of the scaler.

So that's option number 1. I think it's the best one (unless we can find a 
better option 3, such as setting formats and crop rectangles on multiple pads 
atomically).

> > The OMAP3 ISP resizer currently implements the second option, and I'll
> > modify it to implement the first option. The drawback is that some
> > crop/output combinations will require an extra step to be achieved. I'd
> > like your opinion on this issue. Is the behaviour described in option
> > one acceptable ? Should the API be extended/modified to make it simpler
> > for applications to configure the various sizes in the image pipeline ?
> > Are we all doomed and will we have
> 
> Not sure if it is a good idea, but with the introduction of the pad
> operations maybe it is worth to introduce some flags to vidioc_try/s_crop
> selecting the exact behavior? However current struct v4l2_crop is rather
> resistant to any backward compatible extensions.

I'm using

struct v4l2_subdev_crop {
        __u32 which;
        __u32 pad;
        struct v4l2_rect rect;
        __u32 reserved[10];
};

to set crop rectangles on subdevs, so it shouldn't be an issue. I'm not sure 
if it's a good idea though, as it would make both drivers and applications 
more complex. I think I like the idea of setting multiple formats and crop 
rectangles atomically, but I have to think more about it.

-- 
Regards,

Laurent Pinchart
