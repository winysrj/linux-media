Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45750 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728Ab2BQSqg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Feb 2012 13:46:36 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-fbdev@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Pawel Osciak <pawel@osciak.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	Marcus Lorentzon <marcus.lorentzon@linaro.org>,
	dri-devel@lists.freedesktop.org,
	Alexander Deucher <alexander.deucher@amd.com>,
	Rob Clark <rob@ti.com>, linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: Kernel Display and Video API Consolidation mini-summit at ELC 2012 - Notes
Date: Fri, 17 Feb 2012 19:46:18 +0100
Message-ID: <2168398.Pv8ir5xFGf@avalon>
In-Reply-To: <20120217095554.GA5511@phenom.ffwll.local>
References: <201201171126.42675.laurent.pinchart@ideasonboard.com> <1775349.d0yvHiVdjB@avalon> <20120217095554.GA5511@phenom.ffwll.local>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Daniel,

On Friday 17 February 2012 10:55:54 Daniel Vetter wrote:
> On Fri, Feb 17, 2012 at 12:25:51AM +0100, Laurent Pinchart wrote:
> > Hello everybody,
> > 
> > First of all, I would like to thank all the attendees for their
> > participation in the mini-summit that helped make the meeting a success.
> > 
> > Here are my consolidated notes that cover both the Linaro Connect meeting
> > and the ELC meeting. They're also available at
> > http://www.ideasonboard.org/media/meetings/.
> 
> Looks like you've been all really busy ;-)

I like to think so :-)

> A few quick comments below.

Thanks for your feedback.
 
> > Kernel Display and Video API Consolidation mini-summit at ELC 2012
> > ------------------------------------------------------------------
> 
> [snip]
> 
> > ***  Common video mode data structure and EDID parser ***
> > 
> >   Goal: Sharing an EDID parser between DRM/KMS, FBDEV and V4L2.
> >   
> >   The DRM EDID parser is currently the most advanced implementation and
> >   will
> >   be taken as a starting point.
> >   
> >   Different subsystems use different data structures to describe video
> >   mode/timing information:
> >   
> >   - struct drm_mode_modeinfo in DRM/KMS
> >   - struct fb_videomode in FBDEV
> >   - struct v4l2_bt_timings in V4L2
> >   
> >   A new common video mode/timing data structure (struct
> >   media_video_mode_info, exact name is to be defined), not tied to any
> >   specific subsystem, is required to share the EDID parser. That
> >   structure won't be exported to userspace.
> >   
> >   Helper functions will be implemented in the subsystems to convert
> >   between
> >   that generic structure and the various subsystem-specific structures.
> >   
> >   The mode list is stored in the DRM connector in the EDID parser. A new
> >   mode
> >   list data structure can be added, or a callback function can be used by
> >   the
> >   parser to give modes one at a time to the caller.
> >   
> >   3D needs to be taken into account (this is similar to interlacing).
> >   
> >   Action points:
> >   - Laurent to work on a proposal. The DRM/KMS EDID parser will be reused.
> 
> I think we should include kernel cmdline video mode parsing here, afaik
> kms and fbdev are rather similar (won't work if they're too different,
> obviously).

Good point. I'll add that to the notes and will look into it.

> [snip]
> 
> > ***  Central 4CC Documentation ***
> > 
> >   Goal: Define and document 4CCs in a central location to make sure 4CCs
> >   won't overlap or have different meanings for different subsystems.
> >   
> >   DRM and V4L2 define their own 4CCs:
> >   
> >   - include/drm/drm-fourccs.h
> >   - include/linux/videodev2.h
> >   
> >   A new header file will centralize the definitions, with a new
> >   cross-subsystem prefix. DRM and V4L2 4CCs will be redefined as aliases
> >   for
> >   the new centralized 4CCs.
> >   
> >   Colorspace (including both color matrix and Y/U/V ranges) should be
> >   shared as well. VDPAU (and VAAPI ?) pass the color matrix to userspace.
> >   The kernel API should not be more restrictive, but we just need a couple
> >   of presets in most cases. We can define a list of common presets, with a
> >   way to upload a custom matrix.
> >   
> >   Action points:
> >   - Start with the V4L2 documentation, create a shared header file. Sakari
> >   to work on a proposal.
> 
> I'm looking forward to the bikeshed discussion here ;-)
> </snide-remark>

I'm certainly going to NACK if we try to paint 4CCs in the wrong colorspace 
;-)
 
> > ***  Split KMS and GPU Drivers ***
> > 
> >   Goal: Split KMS and GPU drivers with in kernel API inbetween.
> >   
> >   In most (all ?) SoCs, the GPU and the display controller are separate
> >   devices. Splitting them into separate drivers would allow reusing the
> >   GPU driver with different devices (e.g. using a single common PowerVR
> >   kernel module with different display controller drivers). The same
> >   approach can be used on the desktop for the multi-GPU case and the USB
> >   display case.
> >   
> >   - OMAP already separates the GPU and DSS drivers, but the GPU driver is
> >   some kind of DSS plugin. This isn't a long-term approach.
> >   - Exynos also separates the GPU and FIMD drivers. It's hard to merge GPU
> >   into  display subsystem since UMP, GPU has own memory management codes.
> >   
> >   One of the biggest challenges would be to get GPU vendors to use this
> >   new model. ARM could help here, by making the Mali kernel driver split
> >   from the display controller drivers. Once one vendor jumps onboard,
> >   others could have a bigger incentive to follow.
> >   
> >   Action points:
> >   - Rob planning to work on a reference implementation, as part of the
> >   sync object case. This is a pretty long term plan.
> >   
> >   - Jesse will handle the coordination with ARM for Mali.
> 
> Imo splitting up SoC drm drivers into separate drivers for the different
> blocks makes tons of sense. The one controlling the display subsystem
> would then also support kms, all the others would just support gem and
> share buffers with dma_buf (and maybe synchronize with some new-fangled
> sync objects). Otoh it doesn't make much sense to push this if we don't
> have at least one of the SoC ip block verndors on board. We can dream ...

That's the conclusion we came up to. ARM might be able to help here with Mali, 
and we could then try to sell the idea to other vendors when a reference 
implementation will be complete (or at least usable enough).

> [snip]
> 
> > ***  Sync objects ***
> > 
> >   Goal: Implement in-kernel support for buffer swapping, dependency
> >   system, sync objects, queue/dequeue userspace API (think EGLstream &
> >   EGLsync)
> >   
> >   This can be implemented in kernel-space (with direct communication
> >   between drivers to schedule buffers around), user-space (with ioctls to
> >   queue/dequeue buffers), or a mix of both. SoCs with direct sync object
> >   support at the hardware level between different IP blocks can be
> >   foreseen in the (near ?) future. A kernel-space API would then be
> >   needed.
> >   
> >   Sharing sync objects between subsystems could result in the creation of
> >   a cross-subsystem queue/dequeue API. Integration with dma_buf would make
> >   sense, a dma_buf_pool object would then likely be needed.
> >   
> >   If the SoC supports direct signaling between IP blocks, this could be
> >   considered (and implemented) as a pipeline configurable through the
> >   Media Controller API. However, applications will then need to be link-
> >   aware. Using sync/stream objects would offer a single API to userspace,
> >   regardless of whether the synchronization is handled by the CPU in
> >   kernel space or by the IP blocks directly.
> >   
> >   Sync objects are not always tied to buffers, they need to be implemented
> >   as stand-alone objects on the kernel side. However, when exposing the
> >   sync object to userspace in order to share it between devices, all
> >   current use cases involve dma-buf. The first implementation will thus not
> >   expose the sync objects explicitly to userspace, but associate them with
> >   a dma-buf. If sync objects with no associated dma-buf are later needed,
> >   an explicit userspace API can be added.
> >   
> >   eventfd is a possible candidate for sync object implementation.
> >   
> >   http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob;f=in
> >   clude/linux/eventfd.h
> >   http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob;f=D
> >   ocumentation/cgroups/cgroups.txt
> >   http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob;f=D
> >   ocumentation/cgroups/memory.txt
> >   http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob;f=D
> >   ocumentation/virtual/kvm/api.txt
> >   
> >   Action points:
> >   - TBD, will be on the agenda for the Graphics Summit @ELC2012.
> 
> I've already started discussing this a bit with Rob. I'm not sure whether
> implicitly associating a sync object with a dma_buf makes sense, afaik
> sync objects can be used rather independently from buffers. But this is a
> long-term feature, so we still have plenty of time to discuss this.

I think we need to work on this one step at a time. Associating a sync object 
with a dma_buf is probably not going to solve all our problems in the long 
term, but it might provide us with a first solution that doesn't require 
exposing the sync object API to userspace. I'm not saying we need to do this, 
but it could be a reasonable first step that would buy us some time while we 
sort out the sync object userspace API.

> [snip]
> 
> > *** 2D Kernel APIs ***
> > 
> >   Goal: Expose a 2D acceleration API to userspace for devices that support
> >   hardware-accelerated 2D rendering.
> >   
> >   If the hardware is based on a command stream, a userspace library is
> >   needed anyway to build the command stream. A 2D kernel API would then
> >   not be very useful. This could be split to a DRM device without a KMS
> >   interface.
> 
> Imo we should ditch this - fb accel doesn't belong into the kernel. Even
> on hw that still has a blitter for easy 2d accel without a complete 3d
> state setup necessary, it's not worth it. Chris Wilson from our team once
> played around with implementing fb accel in the kernel (i915 hw still has
> a blitter engine in the latest generations). He quickly noticed that to
> have decent speed, competitive with s/w rendering by the cpu he needs the
> entire batch and buffer management stuff from userspace. And to really
> beat the cpu, you need even more magic.
> 
> If you want fast 2d accel, use something like cairo.

Our conclusion on this is that we should not expose an explicit 2D 
acceleration API at the kernel level. If really needed, hardware 2D 
acceleration could be implemented as a DRM device to handle memory management, 
commands ring setup, synchronization, ... but I'm not even sure if that's 
worth it. I might not have conveyed it well in my notes.

-- 
Regards,

Laurent Pinchart
