Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57799 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965026Ab2JWUhB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Oct 2012 16:37:01 -0400
Date: Tue, 23 Oct 2012 23:36:57 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans de Goede <hdegoede@redhat.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [RFC] Processing context in the V4L2 subdev and V4L2 controls
 API ?
Message-ID: <20121023203656.GF23685@valkosipuli.retiisi.org.uk>
References: <50588E0E.9000307@samsung.com>
 <5079CA3D.2030906@gmail.com>
 <201210151020.00790.hverkuil@xs4all.nl>
 <2086489.54JozWPpFs@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2086489.54JozWPpFs@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent and others,

On Wed, Oct 17, 2012 at 01:55:10AM +0200, Laurent Pinchart wrote:
> On Monday 15 October 2012 10:20:00 Hans Verkuil wrote:
> > On Sat October 13 2012 22:08:29 Sylwester Nawrocki wrote:
> > > On 09/21/2012 02:26 PM, Hans Verkuil wrote:
> > > > On Tue September 18 2012 17:06:54 Sylwester Nawrocki wrote:
> > > >> Hi All,
> > > >> 
> > > >> I'm trying to fulfil following requirements with V4L2 API that are
> > > >> specific to most of Samsung camera sensors with embedded SoC ISP and
> > > >> also for local SoC camera ISPs:
> > > >>   - separate pixel format and pixel resolution needs to be configured
> > > >>     in a device for camera preview and capture;
> > > >>   
> > > >>   - there is a need to set capture or preview mode in a device
> > > >>     explicitly as it makes various adjustments (in firmware) in each
> > > >>     operation mode and controls external devices accordingly (e.g.
> > > >>     camera Flash);
> > > >>   
> > > >>   - some devices have more than two use case specific contexts that a
> > > >>     user needs to choose from, e.g. video preview, video capture, still
> > > >>     preview, still capture; for each of these modes there are separate
> > > >>     settings, especially pixel resolution and others corresponding to
> > > >>     existing v4l2 controls;
> > > >>   
> > > >>   - some devices can have two processing contexts enabled
> > > >>     simultaneously, e.g. a sensor emitting YUYV and JPEG streams
> > > >>     simultaneously (please see discussion [1]).
> > > >> 
> > > >> This makes me considering making the v4l2 subdev (and maybe v4l2
> > > >> controls) API processing (capture) context aware.
> 
> I think we have several distinct issues here that should be discussed 
> separately (but of course considered together), otherwise we'll just create a 
> horrible mess (or just fail to create it).
> 
> I see contexts as hardware-provided parameters storage. Depending on the 
> hardware, contexts can
> 
> - Store a small subset of, a large subset of or all parameters (the later 
> being quite unlikely).
> 
> - Be associated with hardware operation modes (a "snapshot" context in a 
> sensor could be hardwired to snapshot mode for instance) but don't need to, 
> I'm aware of sensors that have multiple contexts that are not in any way 
> associated with a particular operation mode.
> 
> - Support cloning a different context.
> 
> As such, contexts are containers that need to support operations such as 
> cloning and selection of the active context. As long as those contexts are 
> local to a subdev I pretty much agree with Hans, we should reuse our existing 
> APIs and add ioctls to handle context-specific operations.
> 
> I'm not convinced we should support pure software contexts for devices that 
> don't support hardware contexts, but I believe the API should allow to do so.
> 
> This won't be straightforward.
> 
> However this won't be enough. I'm pretty sure that we will soon need (if we 
> don't already) cross-subdev contexts, for instance to support hardware 
> contexts local to a sensor that creates several subdevs. Modifying parameters 
> of a context shouldn't be a huge issue in that case, but selecting the active 
> context would be more problematic as it would involve cross-subdev operations 
> that can't be expressed through the V4L2 subdev API.
> 
> We also need to consider that contexts can store parameters that directly 
> influence media bus formats on connected links. I have no clear use case at 
> the moment, but link configuration might also be part of the context. This 
> would call for handling contexts on the media controller device node. That's 
> opening Pandora's box, but I feel that we will need to at some point anyway to 
> support atomic pipeline reconfiguration.
> 
> This won't be straightforward. I know I'm repeating myself :-)

Contexts (or cross-subdev contexts) might not be that difficult after all.
We have a standard API but the device that provides the API could be made
the means of selecting the context. Logical subdevs. E.g. for contexts 0 and
1 (for a single driver):


pixel array 0		pixel array 1
|			|
|			|
binner 0		binner 1
 \		       /
   \		     /
     \	c0	   / c1
       \	 /
         \     /
	  output
	    |
	    |


This approach cannot address limitations on the context, i.e. whether it's
just a few parameters or more. But it'd allow the user space to configure
the device whenver with the implicit knowledge of the contexts. Links c0 and
c1 would be enabled or disabled to choose the context.

This wouldn't scale to cases where the number of contexts supported is
variable or large.

I agree with Laurent that high level controls are in general difficult to
standardise, and probably so because there tends to be more assumptions
taken than when it comes to low level controls.

Also switching contexts while streaming might be out of question, but I
wonder if that's really so important. The hardware has developed into a
direction (as well as the V4L2 framework with VB2) where streamoff /
streamon is increasingly light operations, and essentially offer a safe time
to reconfigure the device for a different kind of use case.

> One possible solution to simplify the problem would be to implement an API 
> limited to our current use cases, ignoring more complex topics like atomic 
> pipeline reconfiguration, and keeping Pandora's box closed for a bit longer. I 
> can't tell how long we will be able to keep it closed though, now might be a 
> good time to think about our future plans even if we delay the implementation.
> 
> The second issue we need to solve is high-level operation modes support, such 
> as the viewfinder/snapshot modes. This is required to support "smart" sensors 
> and ISPs that offer high-level controls only (although I often consider those 
> dumb instead of smart, as control of the image capture process is handled by 
> the device firmware, and thus not accessible by the host software). Those 
> high-level controls are more difficult to standardize as low-level controls as 
> they can vary widely between vendors and/or devices.
> 
> Even though operation modes are associated to context for the Samsung devices 
> considered in this mail thread, a sensor or ISP could implement those modes 
> without hardware contexts. The context and mode APIs should thus be 
> independently usable, but must of course work well together. I have no real 
> advice to give here yet, I believe we should first gather use cases (with as 
> much details as possible) to find out whether patterns emerge.

Sounds like a good approach to me.

I have to admit I'm not a huge fan of contexts; they're a software concept
implemented by the sensor firmware. They may give you a marginal speed-up in
an important moment (the I2C is slow), but at the cost of added complexity
and require exact knowledge of the hardware.

There may be use cases where they can be useful, but I haven't _personally_
encountered those yet.

> > > >> If I remember correctly introducing processing context, as the per file
> > > >> handle device contexts in case of mem-to-mem devices was considered bad
> > > >> idea in past discussions.
> > > > 
> > > > I don't remember this. Controls can already be per-filehandle for m2m
> > > > devices, so for m2m devices I see no problem. For other devices it is a
> > > > different matter, though. The current V4L2 API does not allow
> > > > per-filehandle contexts there.
> > >
> > > OK, if nothing else the per file handle contexts are painful in case of
> > > DMABUF sharing between multiple processes. I remember Laurent mentioning
> > > some inconveniences with omap3isp which uses per-file-handle contexts at
> > > the capture interface and a need to use
> > > VIDIOC_PREPARE_BUF/VIDIOC_CREATE_BUFS there instead.
> > >
> > > >> But this was more about v4ll2 video nodes.
> > > >> 
> > > >> And I was considering adding context only to v4l2 subdev API, and
> > > >> possibly to the (extended) control API. The idea is to extend the
> > > >> subdev (and controls ?) ioctls so it is possible to preconfigure sets
> > > >> of parameters on subdevs, while V4L2 video node parameters would be
> > > >> switched "manually" by applications to match a selected subdevs
> > > >> contest. There would also be needed an API to select specific context
> > > >> (e.g. a control), or maybe multiple contexts like in case of a sensor
> > > >> from discussion [1].
> > > > 
> > > > We discussed the context idea before. The problem is how to implement it
> > > > in a way that still keeps things from becoming overly complex.
> > > > 
> > > > What I do not want to see is an API with large structs that contain the
> > > > whole context. That's a nightmare to maintain in the long run. So you
> > > > want to be able to use the existing API as much as possible and build
> > > > up the context bit by bit.
> > > > 
> > > > I don't think using a control to select contexts is a good idea. I think
> > > > this warrants one or more new ioctls.
> > > 
> > > OK, it probably needs to be looked at from a wider perspective.
> > > 
> > > > What contexts would you need? What context operations do you need?
> > > 
> > > In our case these are mainly multiple set of parameters configuring a
> > > camera ISP. So basically all subdev ioctls are involved here - format,
> > > selection, frame interval. In simplest form the context could contain
> > > only image format and a specific name tag assigned to it. The problem is
> > > mainly an ISP which involves capture "scenarios" coded in firmware. It
> > > might sound rather bad, but it is similar to the integrated sensor and
> > > ISPs, where you can set e.g. different resolution for camera preview and
> > > still capture and switch between them through some register setting.
> > > 
> > > So when there are multiple subdevs in the pipeline some of them could be
> > > just reconfigured as usual, but the ISP subdev needs to have it's context
> > > configured and switched explicitly. I can imagine one would want a
> > > context spanning among multiple subdevs.
> > 
> > Interesting question: should contexts reflect the hardware capabilities, or
> > should we make this generic, e.g. they can also be used if the hardware
> > doesn't support this by just setting all the parameters associated with a
> > context manually when switching context?

I think we should limit to what the hardware supoprts. If the configuration
was given from the user space instead of the kernel, there's hardly no
difference in terms of speed. But it still comes with the added complexity.
For I2C I can still somehow understand it. :-)

We came into a similar conclusion on a lesser matter of bracketing support
for sensors: if there's no hardware support it should (rightly) be done from
the user space.

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
