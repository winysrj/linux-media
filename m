Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46425 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111Ab2HMXyC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Aug 2012 19:54:02 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: workshop-2011@linuxtv.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [Workshop-2011] RFC: V4L2 API ambiguities
Date: Tue, 14 Aug 2012 01:54:16 +0200
Message-ID: <2697809.QgTso8NvEE@avalon>
In-Reply-To: <201208131427.56961.hverkuil@xs4all.nl>
References: <201208131427.56961.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday 13 August 2012 14:27:56 Hans Verkuil wrote:
> Hi all!
> 
> As part of the 2012 Kernel Summit V4L2 workshop I will be discussing a bunch
> of V4L2 ambiguities/improvements.
> 
> I've made a list of all the V4L2 issues and put them in two categories:
> issues that I think are easy to resolve (within a few minutes at most), and
> those that are harder.
> 
> If you think I put something in the easy category that you believe is
> actually hard, then please let me know.
> 
> If you attend the workshop, then please read through this and think about it
> a bit, particularly for the second category.
> 
> If something is unclear, or you think another topic should be added, then
> let me know as well.
> 
> Easy:

[snip]

> 4) What should a driver return in TRY_FMT/S_FMT if the requested format is
> not supported (possible behaviours include returning the currently selected
> format or a default format).
> 
>    The spec says this: "Drivers should not return an error code unless the
> input is ambiguous", but it does not explain what constitutes an ambiguous
> input. Frankly, I can't think of any and in my opinion TRY/S_FMT should
> never return an error other than EINVAL (if the buffer type is unsupported)
> or EBUSY (for S_FMT if streaming is in progress).
> 
>    Returning an error for any other reason doesn't help the application
> since the app will have no way of knowing what to do next.

That wasn't my point. Drivers should obviously not return an error. Let's 
consider the case of a driver supporting YUYV and MJPEG. If the user calls 
TRY_FMT or S_FMT with the pixel format set to RGB565, should the driver return 
a hardcoded default format (one of YUYV or MJPEG), or the currently selected 
format ? In other words, should the pixel format returned by TRY_FMT or S_FMT 
when the requested pixel format is not valid be a fixed default pixel format, 
or should it depend on the currently selected pixel format ?

[snip]

> 11) What should video output drivers do with the sequence and timestamp
>     fields when they return a v4l2_buffer from VIDIOC_DQBUF?
> 
>     I think the spec is clear with respect to the timestamp:
> 
>     "The driver stores the time at which the first data byte was actually
>      sent out in the timestamp field."

The complete text says

"For input streams this is the system time (as returned by the gettimeofday() 
function) when the first data byte was captured. For output streams the data 
will not be displayed before this time, secondary to the nominal frame rate 
determined by the current video standard in enqueued order. Applications can 
for example zero this field to display frames as soon as possible. The driver 
stores the time at which the first data byte was actually sent out in the 
timestamp field. This permits applications to monitor the drift between the 
video and system clock."

Splitting it into two paragraphs after the first sentence would in my opinion 
be clearer.

>     For sequence the spec just says:
> 
>     "Set by the driver, counting the frames in the sequence."
> 
>     So I think that output drivers should indeed set both sequence and
>     timestemp.

I'm fine with that, I would then just like to clarify the spec.

[snip]

> Hard(er):
> 
> 1) What is the right/best way to set the timestamp? The spec says
> gettimeofday, but is it my understanding that ktime_get_ts is much more
> efficient.
> 
>    Some drivers are already using ktime_get_ts.
> 
>    Options:
> 
>    a) all drivers must comply to the spec and use gettimeofday
>    b) we change the spec and all drivers must use the more efficient
> ktime_get_ts
>    c) we add a buffer flag V4L2_BUF_FLAG_MONOTONIC to tell userspace that a
> monotonic clock like ktime_get_ts is used and all drivers that use
> ktime_get_ts should set that flag.
> 
>    If we go for c, then we should add a recommendation to use one or the
> other as the preferred timestamp for new drivers.

I'd like to take this opportunity to introduce a proposed extension to the 
V4L2 API.

UVC devices send a device timestamp for each frame in device clock units. I 
expect other devices to have similar capabilities.

That device timestamp can be converted to a host timestamp by a clock recovery 
algorithm that uses clocks correlation information provided by the device. The 
uvcvideo driver currently converts the device timestamp to a host timestamp in 
kernelspace and fills the v4l2_buffer timestamp field with the computed value 
(which is BTW something that I would like the spec to allow, we should specify 
which clock the timestamp field must refer to, but should not mandate the use 
of a specific kernel function to retrieve the value).

A userspace implementation of the clock recovery algorithm would produce 
better results. For this to be possible, applications (or 
libraries/middlewares) must retrieve the clock correlation information (a 
driver-specific ioctl makes sense here, as the information is device-
specific), and receive the device timestamp corresponding to each frame in 
v4l2_buffer. To avoid using one of the v4l2_buffer reserved fields to pass the 
device timestamp, I was thinking of adding a new ioctl or a flag in an 
existing ioctl to "switch" to device timestamp mode.

[snip]

> 4) Pixel aspect: currently this is only available through VIDIOC_CROPCAP. It
> never really belonged to VIDIOC_CROPCAP IMHO. It's just not a property of
> cropping/composing. It really belongs to the input/output timings (STD or
> DV_TIMINGS). That's where the pixel aspect ratio is determined.
> 
>    While it is possible to add it to the dv_timings struct, I see no way of
>    cleanly adding it to struct v4l2_standard (mostly because VIDIOC_ENUMSTD
>    is now handled inside the V4L2 core and doesn't call the drivers
> anymore).
> 
>    An alternative is to add it to struct v4l2_input/output, but I don't know
> if it is possible to defined a pixelaspect for inputs that are not the
> current input.
> 
>    What I am thinking of is just to add a new ioctl for this
> VIDIOC_G_PIXELASPECT. The argument is then:
> 
> 	struct v4l2_pixelaspect {
> 		__u32 type;
> 		struct v4l2_fract pixelaspect;
> 		__u32 reserved[5];
> 	};
> 
>    This combines well with the selection API.

We might want to report more "format"-related information in the future than 
just the pixel ratio, a more generic name for the ioctl might make sense.

Do we also need a corresponding subdev pad operation and subdev ioctl ?

-- 
Regards,

Laurent Pinchart

