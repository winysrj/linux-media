Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:31019 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752977AbcJNMuY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 08:50:24 -0400
Date: Fri, 14 Oct 2016 15:50:18 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: Brian Starkey <brian.starkey@arm.com>
Cc: Archit Taneja <architt@codeaurora.org>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, liviu.dudau@arm.com,
        robdclark@gmail.com, hverkuil@xs4all.nl, eric@anholt.net,
        daniel@ffwll.ch
Subject: Re: [RFC PATCH 00/11] Introduce writeback connectors
Message-ID: <20161014125018.GD4329@intel.com>
References: <1476197648-24918-1-git-send-email-brian.starkey@arm.com>
 <6e794da8-49de-0440-ea70-272bfe47332b@codeaurora.org>
 <20161014123914.GA10745@e106950-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20161014123914.GA10745@e106950-lin.cambridge.arm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 14, 2016 at 01:39:15PM +0100, Brian Starkey wrote:
> Hi Archit,
> 
> On Fri, Oct 14, 2016 at 04:20:14PM +0530, Archit Taneja wrote:
> >Hi Brian,
> >
> >On 10/11/2016 08:23 PM, Brian Starkey wrote:
> >>Hi,
> >>
> >>This RFC series introduces a new connector type:
> >> DRM_MODE_CONNECTOR_WRITEBACK
> >>It is a follow-on from a previous discussion: [1]
> >>
> >>Writeback connectors are used to expose the memory writeback engines
> >>found in some display controllers, which can write a CRTC's
> >>composition result to a memory buffer.
> >>This is useful e.g. for testing, screen-recording, screenshots,
> >>wireless display, display cloning, memory-to-memory composition.
> >>
> >>Patches 1-7 include the core framework changes required, and patches
> >>8-11 implement a writeback connector for the Mali-DP writeback engine.
> >>The Mali-DP patches depend on this other series: [2].
> >>
> >>The connector is given the FB_ID property for the output framebuffer,
> >>and two new read-only properties: PIXEL_FORMATS and
> >>PIXEL_FORMATS_SIZE, which expose the supported framebuffer pixel
> >>formats of the engine.
> >>
> >>The EDID property is not exposed for writeback connectors.
> >>
> >>Writeback connector usage:
> >>--------------------------
> >>Due to connector routing changes being treated as "full modeset"
> >>operations, any client which wishes to use a writeback connector
> >>should include the connector in every modeset. The writeback will not
> >>actually become active until a framebuffer is attached.
> >>
> >>The writeback itself is enabled by attaching a framebuffer to the
> >>FB_ID property of the connector. The driver must then ensure that the
> >>CRTC content of that atomic commit is written into the framebuffer.
> >>
> >>The writeback works in a one-shot mode with each atomic commit. This
> >>prevents the same content from being written multiple times.
> >>In some cases (front-buffer rendering) there might be a desire for
> >>continuous operation - I think a property could be added later for
> >>this kind of control.
> >>
> >>Writeback can be disabled by setting FB_ID to zero.
> >>
> >>Known issues:
> >>-------------
> >> * I'm not sure what "DPMS" should mean for writeback connectors.
> >>   It could be used to disable writeback (even when a framebuffer is
> >>   attached), or it could be hidden entirely (which would break the
> >>   legacy DPMS call for writeback connectors).
> >> * With Daniel's recent re-iteration of the userspace API rules, I
> >>   fully expect to provide some userspace code to support this. The
> >>   question is what, and where? We want to use writeback for testing,
> >>   so perhaps some tests in igt is suitable.
> >> * Documentation. Probably some portion of this cover letter needs to
> >>   make it into Documentation/
> >> * Synchronisation. Our hardware will finish the writeback by the next
> >>   vsync. I've not implemented fence support here, but it would be an
> >>   obvious addition.
> >>
> >>See Also:
> >>---------
> >>[1] https://lists.freedesktop.org/archives/dri-devel/2016-July/113197.html
> >>[2] https://lists.freedesktop.org/archives/dri-devel/2016-October/120486.html
> >>
> >>I welcome any comments, especially if this approach does/doesn't fit
> >>well with anyone else's hardware.
> >
> >Thanks for working on this! Some points below.
> >
> >- Writeback hardware generally allows us to specify the region within
> >the framebuffer we want to write to. It's analogous to the SRC_X/Y/W/H
> >plane properties. We could have similar props for the writeback
> >connectors, and maybe set them to the FB_ID dimensions if they aren't
> >configured by userspace.
> >
> >- Besides the above property, writeback hardware can have provisions
> >for scaling, color space conversion and rotation. This would mean that
> >we'd eventually add more writeback specific props/params in
> >drm_connector/drm_connector_state. Would we be okay adding more such
> >props for connectors?
> 
> I've wondered the same thing about bloating non-writeback connectors
> with writeback-specific stuff. If it does become significant, maybe
> we should subclass drm_connector and add a drm_writeback_state pointer
> to drm_connector_state.
> 
> Ville touched on scaling support previously, suggesting adding a
> fixed_mode property (for all types of connectors) - on writeback this
> would represent scaling the framebuffer, and on normal connectors it
> could control output scaling (like panel-fitting).

We got some patches [1] posted for i915 recently that added a bunch of new
properties to control post-blending scaling, but I'm not sure I like the
approach since it seems harder to reconcile with the current way we deal
with scaling for eDP/LVDS/DSI/etc. So I'm still somewhat partial to the
fixed mode idea. Just FYI.

[1] https://lists.freedesktop.org/archives/intel-gfx/2016-August/105557.html

> 
> Certainly destination coords, color-space converstion etc. are things
> that are worth adding, but IMO I'd rather keep this initial
> implementation small so we can enable the basic case right away. For
> the most part, the additional things are "just properties" which
> should be easily added later without impacting the overall interface.
> 
> Cheers,
> Brian
> >
> >Thanks,
> >Archit
> >
> >>
> >>Thanks,
> >>
> >>-Brian
> >>
> >>---
> >>
> >>Brian Starkey (10):
> >>  drm: add writeback connector type
> >>  drm/fb-helper: skip writeback connectors
> >>  drm: extract CRTC/plane disable from drm_framebuffer_remove
> >>  drm: add __drm_framebuffer_remove_atomic
> >>  drm: add fb to connector state
> >>  drm: expose fb_id property for writeback connectors
> >>  drm: add writeback-connector pixel format properties
> >>  drm: mali-dp: rename malidp_input_format
> >>  drm: mali-dp: add RGB writeback formats for DP550/DP650
> >>  drm: mali-dp: add writeback connector
> >>
> >>Liviu Dudau (1):
> >>  drm: mali-dp: Add support for writeback on DP550/DP650
> >>
> >> drivers/gpu/drm/arm/Makefile        |    1 +
> >> drivers/gpu/drm/arm/malidp_crtc.c   |   10 ++
> >> drivers/gpu/drm/arm/malidp_drv.c    |   25 +++-
> >> drivers/gpu/drm/arm/malidp_drv.h    |    5 +
> >> drivers/gpu/drm/arm/malidp_hw.c     |  104 ++++++++++----
> >> drivers/gpu/drm/arm/malidp_hw.h     |   27 +++-
> >> drivers/gpu/drm/arm/malidp_mw.c     |  268 +++++++++++++++++++++++++++++++++++
> >> drivers/gpu/drm/arm/malidp_planes.c |    8 +-
> >> drivers/gpu/drm/arm/malidp_regs.h   |   15 ++
> >> drivers/gpu/drm/drm_atomic.c        |   40 ++++++
> >> drivers/gpu/drm/drm_atomic_helper.c |    4 +
> >> drivers/gpu/drm/drm_connector.c     |   79 ++++++++++-
> >> drivers/gpu/drm/drm_crtc.c          |   14 +-
> >> drivers/gpu/drm/drm_fb_helper.c     |    4 +
> >> drivers/gpu/drm/drm_framebuffer.c   |  249 ++++++++++++++++++++++++++++----
> >> drivers/gpu/drm/drm_ioctl.c         |    7 +
> >> include/drm/drmP.h                  |    2 +
> >> include/drm/drm_atomic.h            |    3 +
> >> include/drm/drm_connector.h         |   15 ++
> >> include/drm/drm_crtc.h              |   12 ++
> >> include/uapi/drm/drm.h              |   10 ++
> >> include/uapi/drm/drm_mode.h         |    1 +
> >> 22 files changed, 830 insertions(+), 73 deletions(-)
> >> create mode 100644 drivers/gpu/drm/arm/malidp_mw.c
> >>
> >
> >-- 
> >Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> >a Linux Foundation Collaborative Project
> >--
> >To unsubscribe from this list: send the line "unsubscribe linux-media" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >

-- 
Ville Syrjälä
Intel OTC
