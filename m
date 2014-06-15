Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:53305 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbaFOWer (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jun 2014 18:34:47 -0400
Message-ID: <539E1F81.9040700@mentor.com>
Date: Sun, 15 Jun 2014 15:34:41 -0700
From: Steve Longerbeam <steve_longerbeam@mentor.com>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: Steve Longerbeam <slongerbeam@gmail.com>,
	<linux-media@vger.kernel.org>,
	Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH 00/43] i.MX6 Video capture
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>		 <1402485696.4107.107.camel@paszta.hi.pengutronix.de>		 <5398FC95.1070504@mentor.com>	 <1402591841.3444.136.camel@paszta.hi.pengutronix.de>	 <539A1627.5010602@mentor.com> <1402673843.3507.123.camel@paszta.hi.pengutronix.de>
In-Reply-To: <1402673843.3507.123.camel@paszta.hi.pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/13/2014 08:37 AM, Philipp Zabel wrote:
> Am Donnerstag, den 12.06.2014, 14:05 -0700 schrieb Steve Longerbeam:
>> Ok. Yes, we definitely need preview and MIPI CSI-2, and adding IC to the
>> capture path is nice too, since it allows userland to select arbitrary user
>> resolutions, pixel format color space, and also rotation controls.
> 
> No question about that. It's just that mostly everyone around here seems
> to want to capture at least 1080p, or 10-bit grayscale. I hope Freescale
> drops the 1024-pixel output limitation in their next SoC ...

yeah that would be nice.

> 
>> The
>> capture driver decides whether to include the IC in the capture pipeline
>> based on user format and rotation control. I.e. if user colorspace is
>> different from what the sensor can output, IC CSC is required. If user
>> resolution is different from the selected capture cropping rectangle,
>> IC resizer is required, and finally if user requests rotation, the IC
>> rotation unit is required. If none of those are true, the capture driver
>> decides to exclude the IC from the pipeline and send raw sensor frames
>> (well, after cropping anyway) directly to memory via the SMFC.
> 
> That is too much magic for my taste. Especially since whether or not you
> can use the IC not only depends on the current video format, but also on
> whether the other CSI or the MEM_VDIC_MEM path are using the IC at the
> moment.

Right. Our current capture driver just returns -EBUSY if the IC PRPENC task
is currently in use by the other CSI.

But I have come around, I agree with you now that, if we are to make the
capture driver a media device that is controlling an IC entity, that the
links to/from the IC need to be controlled by media controller API. I guess
I've been thinking too much in terms of "classical" V4L2.


> Since this can change dynamically, it throws a wrench into GStreamer's
> static capability negotiation, for example. I'd rather have userspace
> select which CSI should be routed through the IC with media-ctl and then
> reflect the possible conversions in the respective video_dev's
> capabilities.

yes, the capabilities will change dynamically depending on the current video
pipeline that has been setup.

> 
>> So in our driver, the decision to link the IC in a pipeline is made
>> internally by the driver and is not a decision exported to userland.
> 
> This is exactly the point I am worried about. You lose flexibility and
> need all sorts of clever conditional code in the driver. It'd be much
> cleaner to just let userspace control the mux.

the conditionals weren't actually that clever. But like I said, I was
thinking in terms of classic V4L2 where internal video blocks are used or
not depending on user requested format. I agree now that IC usage should
be part of media control.

> 
>> My plan was to add media device framework support, but only after basic
>> video capture is in place. Our driver is full featured in terms of basic
>> capture support, and it works on all three reference platforms. But I
>> agree it needs to convert subdev's to media entities and allow some of
>> them to be linked via the media controller API.
> 
> Alright, so we agree that using the media controller API internally is a
> good idea ...
> 
>> But only some linkages make sense to me. As I explain above, if the IC were
>> to be made a media entity, I think it's linkage should be made internally
>> by the capture driver, and this should not be controllable by userspace.
> 
> ... but we disagree on whether to export the control to userspace. For
> more complicated pipelines in front of the CSIs we'll need media-ctl
> anyway, so using that same API for the internal components, makes sense.
> It also allows userspace to get a clear and stable picture of the
> available features for any given multiplexer setting.
> 
>> Heh, we have a mem2mem driver as well, and it also uses IC post-processor
>> task. It uses banding and striping to support resized output frames larger
>> than 1024x1024. It also makes use of IC rotation and CSC.
> 
> Of course :)
> 
>> But again this is not converted to a media entity. And again, if IC were to
>> be made a standalone media entity, then the mem2mem device would _always_
>> require the IC post-processor be linked to it, since the essential feature
>> of mem2mem is to make use of IC post-processor task for CSC, resize, and
>> rotation operations.
> 
> Since the three IC tasks are transparently time-multiplexed, the IC
> media entity representation could have input and output pads for each of
> them.
> The preprocessing (encoding, viewfinder) tasks share an input pad that
> would be connected to either CSI0, CSI1, or VDI output pad. These links
> should control the IC mux. The encoding task output pad would represent
> IDMAC channel 20/CB0 or channel 48/CB8, depending on whether the rotator
> is active. Since rotation requires tight integration between IC and
> IDMAC, I don't think the IRT should be represented as a separate media
> entity.
> The viewfinder task output pad would correspond to channel 21/CB1 or
> channel 49/CB9, and maybe in the future control whether to send that
> data off to the DMFC or to memory.

right. Currently we don't attempt to use the direct IC-PRPVF --> DMFC
path. Viewfinder code looks much like PRPENC (like you or Sascha pointed out
earlier), it just transfers scaled/CSC/rotated frames to a framebuffer addr
in memory provided by s_fbuf.

> The postprocessing input and output pads would go straight to memory and
> are not configurable, so I see no need to describe IC-PP as media
> entity.

er, now I'm being your own best advocate! :) If IC-PP I/O is going to be
described by pads, then I think IC-PP would have to be described as a media
entity.

For mem2mem device, the sink and source links to IC-PP would have to marked
as immutable (always enabled).


> 
> I'm not quite sure about the VDIC, but I guess that also should be
> configurable from userspace as one input to IC. For the deinterlacer to
> work, IC_INPUT needs to be set, so while this is active there is no way
> to route CSI0/1 through the IC directly.
>

sounds right. But there's too much to think about already.

Btw we have tried to implement direct CSI --> VDIC --> IC path without
success. Freescale's BSP does not use the VDIC in this way, but rather as
mem --> VDIC --> mem, i.e. a kind of post-processing after capture. I'm a
bit vague about this since I haven't looked at VDIC yet in much detail.


> [...]
>>> No conflict here, there are different multiplexers to talk about.
>>>
>>> First, there are two external multiplexers controlled by IOMUXC (on
>>> i.MX6, these don't exist on i.MX5): MIPI_IPU1/2_MUX on i.MX6Q and
>>> IPU_CSI0/1_MUX. They are not part of the IPU.
> [...]
>> right, this is one place where subdev linking makes sense to me. I.e.
>> linking sensors to CSI ports.
>>
>> But you don't mean to allow userspace to make this link arbitrarily,
>> correct? You mean the driver uses the mediactrl framework to implement
>> the links defined in the device tree. Maybe that's where I was confused.
> 
> No, this is exactly what I mean. In my opinion, using media-ctl to throw
> the switches is much better than letting the driver decide depending on
> the old S_INPUT API. Especially since this gives userspace a unified API
> when there are input multiplexers (or any other subdevices configurable
> on the pad level) external to the SoC.
> Also, pad format configuration of the CSI subdev exported to userspace
> may be useful to control the compander in the CSI.
> 
> [...]
>>> From an organizational standpoint, with all the other register access
>>> code in gpu/ipu-v3, having the ipu-csi code in there too looks nice and
>>> as expected.
>>> On the other hand, this should really be only used by one
>>> v4l2_subdev driver. When I look at it this way, I see a driver that is
>>> split in two parts, wasting exported symbol space for no very good
>>> reason.
>>
>> I agree about making CSI a subdev, but I also think we can keep all of the
>> register access in IPU core as well. The CSI subdev would be a wrapper
>> around the ipu-csi APIs. I agree it's more use of symbol space, but we
>> might be able to simplify the ipu-csi API.
> 
> So be it. In any case, this decision could be changed later with little
> effort and without any externally visible changes, if deemed necessary,
> as long as the CSI v4l2_subdev driver is the only consumer of this API.
> 
>>> The IC I'd like to describe as a v4l2_subdev. But I'd also like to use
>>> the IC from the DRM driver. So the IC core code has to stay in
>>> gpu/ipu-v3. I'd just like to pool all V4L2 code that uses this into a IC
>>> v4l2_subdev driver if possible. The only use we have for the IC
>>> currently is
>>
>> is mem2mem? And you would like to see an IC pads linked with mem2mem
>> pads. Well, something like this:
>>
>> input frame from userspace ---> m2m ---> IC-PP ---> m2m ---> to userspace
> 
> As long as there is no internal video bus switch somewhere, the
> usefulness of this is debatable. You see we also implemented this by
> directly calling the IPU IC API, and I'm fine with this.

well, as I said above I think if we are going to make the IC a media entity
we might as well make mem2mem a media device and include IC-PP as an entity
with immutable links to it.

Steve

> 
> [...]
>> Ok, in summary I'm aligned with everything you said. Only that I am still
>> pondering about which media entity links make sense, and who should be
>> allowed to make those links.
> 
> At least the decision whether to route the CSI0/1 into the IC
> preprocessing input should be handled by userspace, as this changes the
> capabilities of the corresponding video_dev.
> 
>> So how should we proceed? I would argue to use our capture driver as a base,
>> since it is fully functional and fairly full-featured. It's just missing the
>> media framework.
> 
> Initially, I don't care as much about a full featureset as I do about
> getting the userspace API and device tree bindings right, since those
> won't be easy to change later.
> Pending rework into CSI/IC subdevices and agreement on the userspace
> facing API, I think your patchset can be a good base.
> 
> regards
> Philipp
> 


