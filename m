Return-path: <mchehab@pedra>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:64869 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817Ab1AKPbv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jan 2011 10:31:51 -0500
Received: by pva4 with SMTP id 4so3594543pva.19
        for <linux-media@vger.kernel.org>; Tue, 11 Jan 2011 07:31:50 -0800 (PST)
Message-ID: <4D2CE84E.8020700@gmail.com>
Date: Wed, 12 Jan 2011 00:31:26 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [RFC] Cropping and scaling with subdev pad-level operations
References: <201101061633.30029.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201101061633.30029.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Hi Laurent,

On 01/06/2011 04:33 PM, Laurent Pinchart wrote:
> Hi everybody,
> 
> I ran into an issue when implementing cropping and scaling on the OMAP3 ISP
> resizer sub-device using the pad-level operations. As nobody seems to be happy
> with the V4L2 crop ioctls, I thought I would ask for comments about the subdev
> pad-level API to avoid repeating the same mistakes.
> 
> A little background information first. The OMAP3 ISP resizer has an input and
> an output pad. It receives images on its input pad, performs cropping to a
> user-configurable rectange and then scales that rectangle up or down to a
> user-configurable output size. The resulting image is output on the output
> pad.
> 
> The hardware sets various restrictions on the crop rectangle and on the output
> size, or more precisely on the relationship between them. Horizontal and
> vertical scaling ratios are independent (at least independent enough for the
> purpose of this discussion), so I'll will not comment on one of them in
> particular.
> 
> The minimum and maximum scaling ratios are roughly 1/4 and x4. A complex
> equation describes the relationship between the ratio, the cropped size and
> the output size. It involves integer arithmetics and must be fullfilled
> exactly, so not all combination of crop rectangle and output size can be
> achieved.
> 
> The driver expects the user to set the input size first. It propagates the
> input format to the output pad, resetting the crop rectangle. That behaviour
> is common to all the OMAP3 ISP modules, and I don't think much discussion is
> needed there.
> 
> The user can then configure the crop rectangle and the output size
> independently. As not all combinations are possible, configuring one of them
> can modify the other one as a side effect. This is where problems come from.
> 
> Let's assume that the input size, the crop rectangle and the output size are
> all set to 4000x4000. The user then wants to crop a 500x500 rectangle and
> scale it up to 750x750.
> 
> If the user first sets the crop rectangle to 500x500,  the 4000x4000 output
> size would result in a x8 scaling factor, not supported by the resizer. The
> driver must then either modify the requested crop rectangle or the output size
> to fullfill the hardware requirements.
> 
> If the user first sets the output size to 750x750 we end up with a similar
> problem, and the driver needs to modify one of crop rectangle or output size
> as well.
> 
> When the stream is on, the output size can't be modified as it would change
> the captured frame size. The crop rectangle and scaling ratios, on the other
> hand, can be modified to implement digital zoom. For that reason, the resizer
> driver doesn't modify the output size when the crop rectangle is set while a
> stream is running, but restricts the crop rectangle size. With the above
> example as a starting point, requesting a 500x500 crop rectangle, which would
> result in an unsupported x8 zoom, will return a 1000x1000 crop rectangle.
> 
> When the stream is off, we have two options:
> 
> - Handle crop rectangle modifications the same way as when the stream is on.
> This is cleaner, but bring one drawback. The user can't set the crop rectangle
> to 500x500 and output size to 750x750 directly. No matter whether the crop
> rectangle or output size is set first, the intermediate 500x5000/4000x4000 or
> 4000x4000/750x750 combination are invalid. An extra step will be needed: the
> crop rectangle will first be set to 1000x1000, the output size will then be
> set to 750x750, and the crop rectangle will finally be set to 500x500. That
> won't make life easy for userspace applications.
> 
> - Modify the output size when the crop rectangle is set. With this option, the
> output size is automatically set to the crop rectangle size when the crop
> rectangle is changed. With the above example, setting the crop rectangle to
> 500x500 will automatically set the output size to 500x500, and the user will
> then just have to set the output size to 750x750.

IMO, with the second option at some point it might get difficult to determine
in the application which parameters in the driver may change when the application
tries to change some parameter. I would expect the side effects to be as local
as possible so the application could possibly get notified about them without
additional steps.

> 
> The second option has a major drawback as well, as there's no way for
> applications to query the minimum/maximum zoom factor. With the first option
> an application can set the desired output size, and then set a very small crop
> rectangle to retrieve the minimum allowed crop rectangle (and thus the maximum
> zoom factor). With the second option the output size will be changed when the
> crop rectangle is set, so this isn't possible anymore.
> 
> Retrieving the maximum zoom factor in the stream off state is an application
> requirement to be able to display the zoom level on a GUI (with a slider for
> instance).

In the Samsung S5P FIMC driver minimum and maximum scaling ratios are 1/64 
and 64. So the scaling limits bite a bit less than in your case in typical
applications, the problem remains still same though.
The driver uses the v4l2 mem-to-mem framework so it may be considered much
as your resizer example with an input and output pad. The FIMC H/W supports 
cropping at the scaler input and also an effective output rectangle can be
positioned within the output buffer. The latter allows e.g. placing the video
window at the arbitrary position on a framebuffer.

Currently, with the mem-to-mem driver the application is required to set
the format at the device input and output first (V4L2_BUF_TYPE_OUTPUT and 
*_CAPTURE stream respectively). The relation between both image formats, 
i.e. scaling ratio was not being checked in s_fmt because it also depended 
on whether the rotator was enabled or not. So the check was postponed to 
actual transaction setup/start. This seems wrong to me and I want to change
it so the scaler limits are checked in try/set_fmt, try/set_crop
and s_control(ROTATION).

Then when the crop rectangle is set it is being checked for the scaling
ratio limit against current crop/full window size at the opposite side 
of the scaler.  When a scaling ratio is not within the supported range an error
is returned. The crop  window is adjusted in s_crop only when the device's
alignment requirements would not have been fulfilled. But I am going to change
that so the crop rectangle is adjusted according to the resizer limits as well,
without changing the effective image size at the opposite side of the scaler. 

> 
> The OMAP3 ISP resizer currently implements the second option, and I'll modify
> it to implement the first option. The drawback is that some crop/output
> combinations will require an extra step to be achieved. I'd like your opinion
> on this issue. Is the behaviour described in option one acceptable ? Should
> the API be extended/modified to make it simpler for applications to configure
> the various sizes in the image pipeline ? Are we all doomed and will we have

Not sure if it is a good idea, but with the introduction of the pad operations
maybe it is worth to introduce some flags to vidioc_try/s_crop selecting the 
exact behavior? However current struct v4l2_crop is rather resistant to any 
backward compatible extensions.

Just my $0.2.

Regards,
Sylwester
