Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1836 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab2JOIUM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Oct 2012 04:20:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [RFC] Processing context in the V4L2 subdev and V4L2 controls API ?
Date: Mon, 15 Oct 2012 10:20:00 +0200
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans de Goede <hdegoede@redhat.com>,
	"Seung-Woo Kim" <sw0312.kim@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
References: <50588E0E.9000307@samsung.com> <201209211426.17235.hverkuil@xs4all.nl> <5079CA3D.2030906@gmail.com>
In-Reply-To: <5079CA3D.2030906@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210151020.00790.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat October 13 2012 22:08:29 Sylwester Nawrocki wrote:
> Hi Hans,
> 
> On 09/21/2012 02:26 PM, Hans Verkuil wrote:
> > On Tue September 18 2012 17:06:54 Sylwester Nawrocki wrote:
> >> Hi All,
> >>
> >> I'm trying to fulfil following requirements with V4L2 API that are specific
> >> to most of Samsung camera sensors with embedded SoC ISP and also for local
> >> SoC camera ISPs:
> >>
> >>   - separate pixel format and pixel resolution needs to be configured
> >>     in a device for camera preview and capture;
> >>
> >>   - there is a need to set capture or preview mode in a device explicitly
> >>     as it makes various adjustments (in firmware) in each operation mode
> >>     and controls external devices accordingly (e.g. camera Flash);
> >>
> >>   - some devices have more than two use case specific contexts that a user
> >>     needs to choose from, e.g. video preview, video capture, still preview,
> >>     still capture; for each of these modes there are separate settings,
> >>     especially pixel resolution and others corresponding to existing v4l2
> >>     controls;
> >>
> >>   - some devices can have two processing contexts enabled simultaneously,
> >>     e.g. a sensor emitting YUYV and JPEG streams simultaneously (please see
> >>     discussion [1]).
> >>
> >> This makes me considering making the v4l2 subdev (and maybe v4l2 controls)
> >> API processing (capture) context aware.
> >>
> >> If I remember correctly introducing processing context, as the per file
> >> handle device contexts in case of mem-to-mem devices was considered bad
> >> idea in past discussions.
> > 
> > I don't remember this. Controls can already be per-filehandle for m2m devices,
> > so for m2m devices I see no problem. For other devices it is a different matter,
> > though. The current V4L2 API does not allow per-filehandle contexts there.
> 
> OK, if nothing else the per file handle contexts are painful in case of DMABUF
> sharing between multiple processes. I remember Laurent mentioning some
> inconveniences with omap3isp which uses per-file-handle contexts at the capture
> interface and a need to use VIDIOC_PREPARE_BUF/VIDIOC_CREATE_BUFS there instead.
> 
> >> But this was more about v4ll2 video nodes.
> >>
> >> And I was considering adding context only to v4l2 subdev API, and possibly
> >> to the (extended) control API. The idea is to extend the subdev (and
> >> controls ?) ioctls so it is possible to preconfigure sets of parameters
> >> on subdevs, while V4L2 video node parameters would be switched "manually"
> >> by applications to match a selected subdevs contest. There would also be
> >> needed an API to select specific context (e.g. a control), or maybe
> >> multiple contexts like in case of a sensor from discussion [1].
> > 
> > We discussed the context idea before. The problem is how to implement it
> > in a way that still keeps things from becoming overly complex.
> > 
> > What I do not want to see is an API with large structs that contain the whole
> > context. That's a nightmare to maintain in the long run. So you want to be
> > able to use the existing API as much as possible and build up the context
> > bit by bit.
> > 
> > I don't think using a control to select contexts is a good idea. I think this
> > warrants one or more new ioctls.
> 
> OK, it probably needs to be looked at from a wider perspective.
> 
> > What contexts would you need? What context operations do you need?
> 
> In our case these are mainly multiple set of parameters configuring a camera 
> ISP. So basically all subdev ioctls are involved here - format, selection, 
> frame interval. In simplest form the context could contain only image format 
> and a specific name tag assigned to it. The problem is mainly an ISP which 
> involves capture "scenarios" coded in firmware. It might sound rather bad, 
> but it is similar to the integrated sensor and ISPs, where you can set e.g. 
> different resolution for camera preview and still capture and switch between 
> them through some register setting.
> 
> So when there are multiple subdevs in the pipeline some of them could be just 
> reconfigured as usual, but the ISP subdev needs to have it's context configured 
> and switched explicitly. I can imagine one would want a context spanning among
> multiple subdevs.

Interesting question: should contexts reflect the hardware capabilities, or
should we make this generic, e.g. they can also be used if the hardware doesn't
support this by just setting all the parameters associated with a context manually
when switching context?

> > I would probably define a default or baseline context that all drivers have,
> > then create a CLONE_CONTEXT ioctl (cloning an existing context into a new one)
> > and an EDIT_CONTEXT ioctl (to edit an existing context) and any subsequent
> > ioctls will apply to that context. After the FINISH_CONTEXT ioctl the context
> > is finalized and any subsequent ioctls will apply again to the baseline context.
> > With APPLY_CONTEXT you apply a context to the baseline context and activate it.
> > 
> > Whether this context information is stored in the file handle (making it fh
> > specific) or globally is an interesting question to which I don't have an
> > answer.
> > 
> > This is just a quick brainstorm, but I think something like this might be
> > feasible.
> 
> It sounds like it _might_ work. I'm only concerned about using something
> like this with pipelines containing multiple subdevs. Let's say 4..5 subdevs
> where each one needs to have proper context activated in order for the whole
> pipeline to have consistent configuration.

Wouldn't that knowledge be encoded in a libv4l2 plugin for that specific hardware?

> For /dev/video your approach makes 
> a lot of sense.
> 
> I don't think storing the context in file handle would be sensible. These
> would be device contexts, would be cached in device's firmware or memory area
> shared between the device and a host CPU. So this isn't something that one
> can clone freely, for instance one context would have different set of (v4l2) 
> controls than the other. We would need to enumerate existing contexts and 
> be able to edit one when the other is e.g. in the streaming state.
> 
> APPLY_CONTEXT would need to take a parameter saying which context is to be
> applied/selected. Similar with EDIT_CONTEXT. Or was your idea completely
> different ?

No, that was my idea.

One problem will be how to tell the user what sort of data is stored in the
context, and what remains global. For controls one could imagine a 'context'
flag, which if set indicates that that control is specific to the current
context. But I'm not sure what to do about ioctls, other than using one or
more capability fields. Hmm, actually that might be sufficient. There are
not all that many ioctls that are relevant for controls.

> >> I've seen various hacks in some v4l2 drivers trying to fulfil above
> >> requirements, e.g. abusing struct v4l2_mbus_framefmt::colorspace field
> >> to select between capture/preview in a device or using 32-bit integer
> >> control where upper 16-bits are used for pixel width and lower 16 for
> >> pixel height.
> > 
> > Where is that? And what do you mean with pixel width and height? It this
> > used to define a pixel aspect ratio? Is this really related to context?
> 
> Sorry for my bad wording, I should have said "image width and image height
> in pixels". The above examples can be found in various drivers in Android
> kernels [1]. One example is function s5c73m3_s_fmt() at [2] (a copy of
> Samsung Galaxy S III GT-I9300 source code available at [3]).
>  
> [1] https://android.googlesource.com/
> [2] https://github.com/snawrocki/linux_galaxy/blob/master/drivers/media/video/s5c73m3.c
> [3] http://opensource.samsung.com

Ah, thanks. Now I understand.

Regards,

	Hans
