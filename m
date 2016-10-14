Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46543 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753607AbcJNKuX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 06:50:23 -0400
Subject: Re: [RFC PATCH 00/11] Introduce writeback connectors
To: Brian Starkey <brian.starkey@arm.com>,
        dri-devel@lists.freedesktop.org
References: <1476197648-24918-1-git-send-email-brian.starkey@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        liviu.dudau@arm.com, robdclark@gmail.com, hverkuil@xs4all.nl,
        eric@anholt.net, ville.syrjala@linux.intel.com, daniel@ffwll.ch
From: Archit Taneja <architt@codeaurora.org>
Message-ID: <6e794da8-49de-0440-ea70-272bfe47332b@codeaurora.org>
Date: Fri, 14 Oct 2016 16:20:14 +0530
MIME-Version: 1.0
In-Reply-To: <1476197648-24918-1-git-send-email-brian.starkey@arm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Brian,

On 10/11/2016 08:23 PM, Brian Starkey wrote:
> Hi,
>
> This RFC series introduces a new connector type:
>  DRM_MODE_CONNECTOR_WRITEBACK
> It is a follow-on from a previous discussion: [1]
>
> Writeback connectors are used to expose the memory writeback engines
> found in some display controllers, which can write a CRTC's
> composition result to a memory buffer.
> This is useful e.g. for testing, screen-recording, screenshots,
> wireless display, display cloning, memory-to-memory composition.
>
> Patches 1-7 include the core framework changes required, and patches
> 8-11 implement a writeback connector for the Mali-DP writeback engine.
> The Mali-DP patches depend on this other series: [2].
>
> The connector is given the FB_ID property for the output framebuffer,
> and two new read-only properties: PIXEL_FORMATS and
> PIXEL_FORMATS_SIZE, which expose the supported framebuffer pixel
> formats of the engine.
>
> The EDID property is not exposed for writeback connectors.
>
> Writeback connector usage:
> --------------------------
> Due to connector routing changes being treated as "full modeset"
> operations, any client which wishes to use a writeback connector
> should include the connector in every modeset. The writeback will not
> actually become active until a framebuffer is attached.
>
> The writeback itself is enabled by attaching a framebuffer to the
> FB_ID property of the connector. The driver must then ensure that the
> CRTC content of that atomic commit is written into the framebuffer.
>
> The writeback works in a one-shot mode with each atomic commit. This
> prevents the same content from being written multiple times.
> In some cases (front-buffer rendering) there might be a desire for
> continuous operation - I think a property could be added later for
> this kind of control.
>
> Writeback can be disabled by setting FB_ID to zero.
>
> Known issues:
> -------------
>  * I'm not sure what "DPMS" should mean for writeback connectors.
>    It could be used to disable writeback (even when a framebuffer is
>    attached), or it could be hidden entirely (which would break the
>    legacy DPMS call for writeback connectors).
>  * With Daniel's recent re-iteration of the userspace API rules, I
>    fully expect to provide some userspace code to support this. The
>    question is what, and where? We want to use writeback for testing,
>    so perhaps some tests in igt is suitable.
>  * Documentation. Probably some portion of this cover letter needs to
>    make it into Documentation/
>  * Synchronisation. Our hardware will finish the writeback by the next
>    vsync. I've not implemented fence support here, but it would be an
>    obvious addition.
>
> See Also:
> ---------
> [1] https://lists.freedesktop.org/archives/dri-devel/2016-July/113197.html
> [2] https://lists.freedesktop.org/archives/dri-devel/2016-October/120486.html
>
> I welcome any comments, especially if this approach does/doesn't fit
> well with anyone else's hardware.

Thanks for working on this! Some points below.

- Writeback hardware generally allows us to specify the region within
the framebuffer we want to write to. It's analogous to the SRC_X/Y/W/H
plane properties. We could have similar props for the writeback
connectors, and maybe set them to the FB_ID dimensions if they aren't
configured by userspace.

- Besides the above property, writeback hardware can have provisions
for scaling, color space conversion and rotation. This would mean that
we'd eventually add more writeback specific props/params in
drm_connector/drm_connector_state. Would we be okay adding more such
props for connectors?

Thanks,
Archit

>
> Thanks,
>
> -Brian
>
> ---
>
> Brian Starkey (10):
>   drm: add writeback connector type
>   drm/fb-helper: skip writeback connectors
>   drm: extract CRTC/plane disable from drm_framebuffer_remove
>   drm: add __drm_framebuffer_remove_atomic
>   drm: add fb to connector state
>   drm: expose fb_id property for writeback connectors
>   drm: add writeback-connector pixel format properties
>   drm: mali-dp: rename malidp_input_format
>   drm: mali-dp: add RGB writeback formats for DP550/DP650
>   drm: mali-dp: add writeback connector
>
> Liviu Dudau (1):
>   drm: mali-dp: Add support for writeback on DP550/DP650
>
>  drivers/gpu/drm/arm/Makefile        |    1 +
>  drivers/gpu/drm/arm/malidp_crtc.c   |   10 ++
>  drivers/gpu/drm/arm/malidp_drv.c    |   25 +++-
>  drivers/gpu/drm/arm/malidp_drv.h    |    5 +
>  drivers/gpu/drm/arm/malidp_hw.c     |  104 ++++++++++----
>  drivers/gpu/drm/arm/malidp_hw.h     |   27 +++-
>  drivers/gpu/drm/arm/malidp_mw.c     |  268 +++++++++++++++++++++++++++++++++++
>  drivers/gpu/drm/arm/malidp_planes.c |    8 +-
>  drivers/gpu/drm/arm/malidp_regs.h   |   15 ++
>  drivers/gpu/drm/drm_atomic.c        |   40 ++++++
>  drivers/gpu/drm/drm_atomic_helper.c |    4 +
>  drivers/gpu/drm/drm_connector.c     |   79 ++++++++++-
>  drivers/gpu/drm/drm_crtc.c          |   14 +-
>  drivers/gpu/drm/drm_fb_helper.c     |    4 +
>  drivers/gpu/drm/drm_framebuffer.c   |  249 ++++++++++++++++++++++++++++----
>  drivers/gpu/drm/drm_ioctl.c         |    7 +
>  include/drm/drmP.h                  |    2 +
>  include/drm/drm_atomic.h            |    3 +
>  include/drm/drm_connector.h         |   15 ++
>  include/drm/drm_crtc.h              |   12 ++
>  include/uapi/drm/drm.h              |   10 ++
>  include/uapi/drm/drm_mode.h         |    1 +
>  22 files changed, 830 insertions(+), 73 deletions(-)
>  create mode 100644 drivers/gpu/drm/arm/malidp_mw.c
>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
