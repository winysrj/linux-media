Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33809 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614Ab2BPX0D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Feb 2012 18:26:03 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Sumit Semwal <sumit.semwal@ti.com>,
	Jesse Barker <jesse.barker@linaro.org>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Rob Clark <rob@ti.com>, Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	Marcus Lorentzon <marcus.lorentzon@linaro.org>,
	Alexander Deucher <alexander.deucher@amd.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-fbdev@vger.kernel.org
Subject: Kernel Display and Video API Consolidation mini-summit at ELC 2012 - Notes
Date: Fri, 17 Feb 2012 00:25:51 +0100
Message-ID: <1775349.d0yvHiVdjB@avalon>
In-Reply-To: <1654816.MX2JJ87BEo@avalon>
References: <201201171126.42675.laurent.pinchart@ideasonboard.com> <1654816.MX2JJ87BEo@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everybody,

First of all, I would like to thank all the attendees for their participation 
in the mini-summit that helped make the meeting a success.

Here are my consolidated notes that cover both the Linaro Connect meeting and 
the ELC meeting. They're also available at 
http://www.ideasonboard.org/media/meetings/.


Kernel Display and Video API Consolidation mini-summit at ELC 2012
------------------------------------------------------------------

***  Video Transmitter Drivers ***

  Goal: Sharing video transmitter drivers (i2c or 'IP block') between V4L and
  DRM.

  This is mostly useful for embedded systems. Transmitters can be used by both
  GPUs and direct video outputs. Having a single driver for external (or even
  internal) HDMI transmitters is desired to avoid code duplication between
  subsystems.

  - DRM/KMS implements support for transmitters as DRM encoders. Code is
    embedded in the main DRM/KMS driver.
  - V4L2 implements transmitter drivers as generic kernel objects called
    v4l2_subdev that implement a set of abstract operations.

  v4l2_subdev already solves (most of ?) the problem, but is specific to V4L2.
  The proposed approach is to create a media_video_entity (exact name to be
  defined) object similar to v4l2_subdev.

  Using that API should not be mandatory, especially on hardware where the
  transmitter and the display controller are deeply cross-dependent.

  How to instantiate the transmitter device and how to handle probe order
  needs to be solved, especially when DT binding come into play. The problem
  already exists to some extend in V4L2.

  The subdev API takes mbus formats as arguments, which is not handled by
  DRM/KMS. V4L2 media bus codes will then need to be shared.

  Action points:
  - Initially, mostly FBDEV (HDMI-on-DSI, Renesas) and V4L2 (TI hardware,
    Cisco). Hans + Laurent to work on a proposal.

***  Display Panel Drivers ***

  Goal: Sharing display panel drivers between display controllers from
  different vendors.

  Panels are connected to the display controller through a standard bus with a
  control channel (DSI and eDP are two major such buses). Various vendors have
  created proprietary interfaces for panel drivers:

  - TI on OMAP (drivers/video/omap2/displays).
  - Samsung on Exynos (drivers/video/exynos).
  - ST-Ericsson on MCDE (http://www.igloocommunity.org/gitweb/?p=kernel/igloo-
kernel.git;a=tree;f=drivers/video/mcde)
  - Renesas is working on a similar interface for SH Mobile.

  HDMI-on-DSI transmitters, while not panels per-se, can be supported through
  the same API.

  A Low level Linux Display Framework (https://lkml.org/lkml/2011/9/15/107)
  has been proposed and overlaps with this topic.

  For DSI, a possible abstraction level would be a DCS (Display Command Set)
  bus. Panels and/or HDMI-on-DSI transmitter drivers would be implemented as
  DCS drivers.

  Action points:
  - Marcus to work on a proposal for DCS-based panels (with Tomi Valkeinen and
    Morimoto-san).

***  Common video mode data structure and EDID parser ***

  Goal: Sharing an EDID parser between DRM/KMS, FBDEV and V4L2.

  The DRM EDID parser is currently the most advanced implementation and will
  be taken as a starting point.

  Different subsystems use different data structures to describe video
  mode/timing information:

  - struct drm_mode_modeinfo in DRM/KMS
  - struct fb_videomode in FBDEV
  - struct v4l2_bt_timings in V4L2

  A new common video mode/timing data structure (struct media_video_mode_info,
  exact name is to be defined), not tied to any specific subsystem, is
  required to share the EDID parser. That structure won't be exported to
  userspace.

  Helper functions will be implemented in the subsystems to convert between
  that generic structure and the various subsystem-specific structures.

  The mode list is stored in the DRM connector in the EDID parser. A new mode
  list data structure can be added, or a callback function can be used by the
  parser to give modes one at a time to the caller.

  3D needs to be taken into account (this is similar to interlacing).

  Action points:
  - Laurent to work on a proposal. The DRM/KMS EDID parser will be reused.
  
***  Shared in-kernel image/framebuffer object type ***

  Goal: Describe dma-buf content in a generic cross-subsystem way.

  Most formats can be described by 4CC, width, height and pitch. Strange
  hardware-specific formats might not be possible to describes completely
  generically.

  However, format negotiation goes through userspace anyway, so there should
  be no need for passing format information directly between drivers.

  Action points:
  - None, this task will not be worked on.

***  Central 4CC Documentation ***

  Goal: Define and document 4CCs in a central location to make sure 4CCs won't
  overlap or have different meanings for different subsystems.

  DRM and V4L2 define their own 4CCs:

  - include/drm/drm-fourccs.h
  - include/linux/videodev2.h

  A new header file will centralize the definitions, with a new
  cross-subsystem prefix. DRM and V4L2 4CCs will be redefined as aliases for
  the new centralized 4CCs.

  Colorspace (including both color matrix and Y/U/V ranges) should be shared
  as well. VDPAU (and VAAPI ?) pass the color matrix to userspace. The kernel
  API should not be more restrictive, but we just need a couple of presets in
  most cases. We can define a list of common presets, with a way to upload a
  custom matrix.

  Action points:
  - Start with the V4L2 documentation, create a shared header file. Sakari to
    work on a proposal.

***  Split KMS and GPU Drivers ***

  Goal: Split KMS and GPU drivers with in kernel API inbetween.
 
  In most (all ?) SoCs, the GPU and the display controller are separate
  devices. Splitting them into separate drivers would allow reusing the GPU
  driver with different devices (e.g. using a single common PowerVR kernel
  module with different display controller drivers). The same approach can be
  used on the desktop for the multi-GPU case and the USB display case.

  - OMAP already separates the GPU and DSS drivers, but the GPU driver is some
  kind of DSS plugin. This isn't a long-term approach.
  - Exynos also separates the GPU and FIMD drivers. It's hard to merge GPU
  into  display subsystem since UMP, GPU has own memory management codes.

  One of the biggest challenges would be to get GPU vendors to use this new
  model. ARM could help here, by making the Mali kernel driver split from the
  display controller drivers. Once one vendor jumps onboard, others could have
  a bigger incentive to follow.

  Action points:
  - Rob planning to work on a reference implementation, as part of the sync
    object case. This is a pretty long term plan. 
  - Jesse will handle the coordination with ARM for Mali.
  
***  HDMI CEC Support ***

  Goal: Support HDMI CEC and offer a userspace API for applications.

  A new kernel API is needed and must be usable by KMS, V4L2 and possibly
  LIRC. There's ongoing effort from Cisco to implement HDMI CEC support. Given
  their background, V4L2 is their initial target. A proposal is available at
  http://www.mail-archive.com/linux-media@vger.kernel.org/msg29241.html with a
  sample implementation at
  http://git.linuxtv.org/hverkuil/cisco.git/shortlog/refs/heads/cobalt-
mainline
  (drivers/media/video/adv7604.c and ad9389b.c.

  In order to avoid API duplication, a new CEC subsystem is probably needed.
  CEC could be modeled as a bus, or as a network device. With the network
  device approach, we could have both kernel and userspace protocol handlers.

  CEC devices need to be associated with HDMI connectors. The Media Controller
  API is a good candidate.

  Action points:
  - Hans is planning to push CEC support to mainline this year. Marcus can
    provide contact information for Per Persson (ST Ericsson).

***  Hardware Pipeline Configuration ***

  Goal: Create a central shared API to configure hardware pipelines on any
  display- or video-related device.

  Hardware pipeline configuration includes both link and format configuration.
  To handle complex pipelines, V4L2 created a userspace V4L2 subdev API that
  works in cooperation with the Media Controller API. Such an approach could
  be generalized to support DRM/KMS, FB and V4L2 devices with a single
  pipeline configuration API.

  However, DRM/KMS can configure a complete display pipeline directly, without
  any need for userspace to access formats on specific pads directly. There is
  thus no direct need (at least for today's hardware) to expose low-level
  pipeline configuration to userspace.

  For display devices, DRM/KMS is going to support configuration of multiple
  overlays/planes. fbdev support will be available "for free" on top of
  DRM/KMS for legacy applications and for fbcon. fbdev should probably not be
  extended to support multiple overlays/planes explicitly. Drivers and
  applications should implement and use KMS instead, and no new FB or V4L2
  frontend should be implemented in new display drivers.

  Implementing the Media Controller API in DRM/KMS is still useful to
  associate connectors with HDMI audio/CEC devices. More than that would
  probably be overkill.

  Action points:
  - Laurent to check the DRM/KMS API to make sure it fulfills all the V4L2
    needs. dma-buf importer role in DRM/KMS is one of the required features to
    implement use cases currently supported by V4L2 USERPTR.
  - Implement a proof-of-concept media controller API in DRM to expose the 
    pipeline topology to userspace. Sumit is working on dma-buf, could maybe
    help on this. Laurent will coordinate the effort.

***  Synchronous pipeline changes ***

  Goal: Create an API to apply complex changes to a video pipeline atomically.

  Needed for complex camera use cases. On the DRM/KMS side, the approach is to
  use one big ioctl to configure the whole pipeline.

  One solution is a commit ioctl, through the media controller device, that
  would be dispatched to entities internally with a prepare step and a commit
  step.

  Parameters to be committed need to be stored in a context. We can either use
  one cross-device context, or per-device contexts that would then need to be
  associated with the commit operation.

  Action points:
  - Sakari will provide a proof-of-concept and/or proposal if needed.

***  Sync objects ***

  Goal: Implement in-kernel support for buffer swapping, dependency system,
  sync objects, queue/dequeue userspace API (think EGLstream & EGLsync)

  This can be implemented in kernel-space (with direct communication between
  drivers to schedule buffers around), user-space (with ioctls to
  queue/dequeue buffers), or a mix of both. SoCs with direct sync object
  support at the hardware level between different IP blocks can be foreseen in
  the (near ?) future. A kernel-space API would then be needed.

  Sharing sync objects between subsystems could result in the creation of a
  cross-subsystem queue/dequeue API. Integration with dma_buf would make
  sense, a dma_buf_pool object would then likely be needed.

  If the SoC supports direct signaling between IP blocks, this could be
  considered (and implemented) as a pipeline configurable through the Media
  Controller API. However, applications will then need to be link-aware. Using
  sync/stream objects would offer a single API to userspace, regardless of
  whether the synchronization is handled by the CPU in kernel space or by the
  IP blocks directly.

  Sync objects are not always tied to buffers, they need to be implemented as
  stand-alone objects on the kernel side. However, when exposing the sync
  object to userspace in order to share it between devices, all current use
  cases involve dma-buf. The first implementation will thus not expose the
  sync objects explicitly to userspace, but associate them with a dma-buf. If
  sync objects with no associated dma-buf are later needed, an explicit
  userspace API can be added.

  eventfd is a possible candidate for sync object implementation.

  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob;f=include/linux/eventfd.h
  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob;f=Documentation/cgroups/cgroups.txt
  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob;f=Documentation/cgroups/memory.txt
  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob;f=Documentation/virtual/kvm/api.txt

  Action points:
  - TBD, will be on the agenda for the Graphics Summit @ELC2012.

***  dma-buf Implementation in V4L2 ***

  Goal: Implement the dma-buf API in V4L2.

  Sumit Semwal has submitted patches to implement the dma-buf importer role in
  videobuf2. Tomasz Stanislawski has then submitted incremental patches to add
  exporter role support.

  Action points:
  - Create a git branch to host all the latest patches. Sumit will provide
    that.



Other points that have been briefly discussed
---------------------------------------------

***  Device Tree Aware 'Subdevice' Instantiation ***

  Goal: Design standard device tree bindings to instantiate "subdevices"
  (including the generic subdev-like video transmitters).

  U-Boot developers are working on automatic configuration using the device
  tree and want to support LCDs. Proposed patches are available at
  http://thread.gmane.org/gmane.comp.boot-loaders.u-boot/122864/focus=122881

  On a related note, kernel PWM proposed DT binding patches for backlight
  control are available at
  http://www.spinics.net/lists/linux-tegra/msg03988.html.

*** HDMI audio output ***

  Goal: Give applications a way to associate an HDMI connector with an ALSA
  HDMI audio device.

  This should be implemented with the Media Controller API.
 
*** 2D Kernel APIs ***

  Goal: Expose a 2D acceleration API to userspace for devices that support
  hardware-accelerated 2D rendering.

  If the hardware is based on a command stream, a userspace library is needed
  anyway to build the command stream. A 2D kernel API would then not be very
  useful. This could be split to a DRM device without a KMS interface.

-- 
Regards,

Laurent Pinchart

