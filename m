Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.48]:59762 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131Ab1ASRTg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jan 2011 12:19:36 -0500
Message-ID: <4D371D25.40404@maxwell.research.nokia.com>
Date: Wed, 19 Jan 2011 19:19:33 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: [RFC] Cropping and scaling with subdev pad-level operations
References: <201101061633.30029.laurent.pinchart@ideasonboard.com> <4D2CE84E.8020700@gmail.com> <201101121006.45099.laurent.pinchart@ideasonboard.com> <201101141702.17308.hverkuil@xs4all.nl>
In-Reply-To: <201101141702.17308.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans, others,

Hans Verkuil wrote:
> Hi Laurent,
> 
> My apologies that this reply is so late, but I knew I had to sit down and think
> carefully about this and I didn't have time for that until today.
> 
> I've decided not to quote your post but instead restate the problem in my own
> words.
> 
> Seen abstractly you have an entity with inputs, outputs and a processing pipeline
> that transforms the input(s) to the output(s) somehow. And each stage of that
> pipeline has its own configuration.
> 
> You want to provide the developer that sets up such an entity with a systematic
> and well-defined procedure while at the same time you want to keep the entity's
> code as simple as possible.
> 
> Part of this procedure is already decided: you always start with defining the
> inputs. The confusion begins with how to setup the configuration and the outputs.
> 
> I think the only reasonably way is to configure the pipeline stages in strict order
> from the input to the output.
> 
> So you start with defining the inputs. For a scaler the next thing to set is the
> crop rectangle. And then finally the output.
> 
> At each stage the entity will only check if the configuration parameters can work
> with the input. It may make the rest of the pipeline invalid, but that's OK for
> now.

This would mean that there would have to be a strict order in which
parameters would be set since as a result of changes a set of other
settings would be rendered invalid.

Virtually every block in the OMAP 3 ISP, for example, is able to do
cropping. Scaling is only possible with the resizer, though. I would
expect that this holds true for almost all similar pieces of hardware as
the cropping can be implemented using different first line start
addresses, offsets and lengts.

> The final step comes when the output is defined. If that returns OK, then you
> know the whole pipeline is valid.
> 
> So what to do when you have an input and an output configured and someone suddenly
> changes the crop configuration to a value that doesn't work with that input/output
> combinations?
> 
> The two options I've seen are:
> 
> 1) modify the crop configuration to fit the output
> 2) modify the output configuration to fit the crop
> 
> But there is a third option which I think works much better:
> 
> 3) accept the crop configuration if it fits the input, but report back to the caller
>    that it invalidates the output.
>
> What the entity does with this crop configuration is purely up to the
entity: it can
> just store it in a shadow configuration and wait with applying it to the hardware
> until it receives a consistent output format, or it can modify the output format to
> fit the crop configuration. In any case, if changes are made, then they should be
> made 'upstream'. This makes the behavior consistent. As long as you work your way
> from input to output, you know that any configuration you've set for earlier stages
> stay put and won't change unexpectedly.

It should be also possible to change both crop and source format at the
same time since the former may necessitate a change to the latter as
well, but it is a must to apply both for the same frame. Even if the
in-between configuration is valid, it is unwanted.

So I think there would have to be a flag to tell only apply the crop
change when the source format is changed. Also, the formats should be
changeable on different pads in a single operation.

I have to say that I like this in the sense that it does not explicitly
restrict the ioctls that can be used to change settings related to crop
/ scaling, but OTOH I don't see a need for further ioctls. Also single
ioctls have well defined and quite generic functionality.

On the other hand, this would necessitate the driver to cache the user
originating parameters without applying them. If the user uses g_fmt()
before the parameters have been applied, which format should be
returned, the deferred one or the current one?

What do you think about a more generic, explicit defer/commit flag in
the format and crop ioctls? The crop and format settings could be
deferred until another one is given w/o defer flag set. The
functionality would stay essentially the same.

The user space must behave itself but that's expected anyway...

> And if you decide to change a 'mid-pipeline' configuration, then you will get a
> status back that tells you whether or not you broke the upstream configuration.
> 
> The advantage is that at any stage the driver code just has to check whether the
> new configuration is valid given the input (in which case the call will succeed)
> and whether the new configuration is valid for the current output and report that
> in a status field.
> 
> Note that 'input' and 'output' do not necessarily refer to pads, it may also refer
> to stages of a pipeline. And the same principle should hold for both the subdev
> API and for the 'main' V4L API (more about that later).
> 
> A suggested alternative was to do the configuration atomically. I do not think
> that is a good idea because it is so very hard to do things atomically. It is
> hard to use and it is hard to implement. The extended controls API for example has
> been defined years ago and there are very few drivers that implement it (let alone
> implement it correctly). It took the creation of the control framework (almost 2000
> lines of code) to make it possible to implement it easily in drivers and I've just
> started out converting all drivers to this framework. And this is just for simple
> controls...

I beg to differ a little regarding the extended controls. There are use
cases where you want to apply a set of settings on a sensor (for
example!) atomically. Such settings include digital and analog gain and
exposure.

Failure to apply the settings atomically will lead to bad images, either
too dark or too bright. The sensors typically contain commit
functionality so that the settings may be applied simultaneously at
device level after the sensor driver has processed all.

This can be implemented either using extended controls where the driver
will handle the whole set, or a separate commit ioctl would be needed.

This is somewhat analogous to atomic crop / format setting which Laurent
proposed, except that these settings have harder dependencies. Bad
combinations are impossible instead of just unwanted.

> So this sounds simple, but in practice I think it will be a disaster. I like to
> cut things up in small pieces, and working your way through a pipeline as proposed
> makes each part much easier.

I don't think this would be a problem inside a single entity. All the
parameters and their dependencies are well known for the driver.

The ioctl could be an array of configurations for format and crop. They
could be applied in the order they are placed in the array.

Simplified example:

#define V4L2_SUBDEV_FMTCROP_FMT		1
#define V4L2_SUBDEV_FMTCROP_CROP	2

struct v4l2_subdev_fmtcrop {
	__u32 type;
	union {
		struct v4l2_subdev_format fmt;
		struct v4l2_subdev_crop crop;
		__u8 __headroom[124];
	} u;
};

struct v4l2_subdev_fmtcrops {
	__u32 count;
	struct v4l2_subdev_fmtcrop *fmtcrop;
};

#define VIDIOC_SUBDEV_S_FMTCROP _IOWR('V', x, struct v4l2_subdev_fmtcrops)

I don't think this is really different than your proposal except that
the information is passed to the driver in a single ioctl instead of many.

I think this would also be less confusing and easier to use from the
user space. The user space always has the freedom to set only either
crop or format if it sees that best.

Also, the driver wouldn't need to cache the crop (or format) settings.

Cheers,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
