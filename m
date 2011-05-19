Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49143 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756945Ab1ESNpI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 May 2011 09:45:08 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hansverk@cisco.com>
Subject: Re: [PATCH 0/2] V4L: Extended crop/compose API
Date: Thu, 19 May 2011 15:45:05 +0200
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sakari.ailus@maxwell.research.nokia.com
References: <1304588396-7557-1-git-send-email-t.stanislaws@samsung.com> <4DD3B63D.1060105@samsung.com> <201105181431.59580.hansverk@cisco.com>
In-Reply-To: <201105181431.59580.hansverk@cisco.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105191545.06341.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

On Wednesday 18 May 2011 14:31:59 Hans Verkuil wrote:
> On Wednesday, May 18, 2011 14:06:21 Sylwester Nawrocki wrote:
> > On 05/16/2011 09:21 AM, Laurent Pinchart wrote:
> > > On Saturday 14 May 2011 12:50:32 Hans Verkuil wrote:
> > >> On Friday, May 13, 2011 14:43:08 Laurent Pinchart wrote:
> > >>> On Saturday 07 May 2011 13:52:25 Hans Verkuil wrote:
> > >>>> On Thursday, May 05, 2011 11:39:54 Tomasz Stanislawski wrote:
> > > [snip]
> > 
> > ...
> > 
> > >>>>>   * resolution of an image combined with support for
> > >>>>>   VIDIOC_S_MULTISELECTION
> > >>>>>   
> > >>>>>     allows to pass a triple format/crop/compose sizes in a single
> > >>>>>     ioctl
> > >>>> 
> > >>>> I don't believe S_MULTISELECTION will solve anything. Specific
> > >>>> use-cases perhaps, but not the general problem of setting up a
> > >>>> pipeline. I feel another brainstorm session coming to solve that. We
> > >>>> never came to a solution for it in Warsaw.
> > >>> 
> > >>> Pipelines are configured on subdev nodes, not on video nodes, so I'm
> > >>> also unsure whether multiselection support would really be useful.
> > >>> 
> > >>> If we decide to implement multiselection support, we might as well
> > >>> use that only. We would need a multiselection target bitmask, so
> > >>> selection targets should all be < 32.
> > >>> 
> > >>> Thinking some more about it, does it make sense to set both crop and
> > >>> compose on a single video device node (not talking about mem-to-mem,
> > >>> where you use the type to multiplex input/output devices on the same
> > >>> node) ? If so, what would the use cases be ?
> > 
> > I can't think of any, one either use crop or compose.
> 
> I can: you crop in the video receiver and compose it into a larger buffer.
> Actually quite a desirable feature.

Composing into a buffer can be achieved by 

> > >>> Should all devices support the selection API, or only the simple ones
> > >>> that don't expose a user-configurable pipeline to userspace through
> > >>> the MC API ? The proposed API looks good to me, but before acking it
> > >>> I'd like to clarify how (if at all) this will interact with subdev
> > >>> pad-level
> > >>> 
> > >>> configuration on devices that support that. My current feeling is
> > >>> that video device nodes for such devices should only be used for
> > >>> video streaming. All parameters should be configured directly on the
> > >>> subdevs. Application might still need to call S_FMT in order to be
> > >>> able to allocate buffers though.
> > 
> > I'm not sure whether moving all configuration to subdev API for medium
> > complexity devices which well might have exposed core functionality
> > through standard V4L2 device node API and still use MC API for pipeline
> > reconfiguration (in terms of linking entities with each other) is the way
> > to go.

One thing we haven't defined is what a "medium complexity device" is. I 
believe it should be defined in terms of the hardware pipeline, or in terms of 
a virtual pipeline that the hardware can map to. When that will be done it 
shouldn't be too difficult to unambiguously define how the V4L2 ioctls map to 
actions on that pipeline.

> > In order to support existing applications SoC-specific libraries would
> > have to be used in addition to a MC driver ?
> > Leaving ourselves without support for default configuration that would
> > work with "old" V4L2 device node API (in connection with common libv4l
> > library) ?
> > 
> > I thought that weren't the prerequisites when designing the MC API.
> > I'm afraid we'll end up with two distinct APIs in Video4Linux and thus
> > two sets of drivers and applications that will not work with one another.
> 
> Indeed. The original requirement was (and is!) that the default video node
> must be usable by standard apps, either through the driver or through
> libv4l.

And I'm still happy with that requirement :-) The OMAP3 ISP libv4l plugin is 
not finished yet, but we're working on it.

> It is a missing piece in the MC how to mark default nodes. We also need to
> clearly define which ioctls are optional for non-default nodes.

-- 
Regards,

Laurent Pinchart
