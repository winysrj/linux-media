Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:34647 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752185AbcJKPou (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Oct 2016 11:44:50 -0400
Received: by mail-lf0-f67.google.com with SMTP id p80so4431006lfp.1
        for <linux-media@vger.kernel.org>; Tue, 11 Oct 2016 08:44:04 -0700 (PDT)
Date: Tue, 11 Oct 2016 17:43:59 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Brian Starkey <brian.starkey@arm.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, liviu.dudau@arm.com,
        robdclark@gmail.com, hverkuil@xs4all.nl, eric@anholt.net,
        ville.syrjala@linux.intel.com, daniel@ffwll.ch
Subject: Re: [RFC PATCH 00/11] Introduce writeback connectors
Message-ID: <20161011154359.GD20761@phenom.ffwll.local>
References: <1476197648-24918-1-git-send-email-brian.starkey@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476197648-24918-1-git-send-email-brian.starkey@arm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 11, 2016 at 03:53:57PM +0100, Brian Starkey wrote:
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

Erhm, this is just the default, drivers can override this. And we could
change the atomic helpers to not mark a modeset as a modeset if the
connector that changed is a writeback one.

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

This seems to contradict itself: If it's one-shot, there's no need to
disable it - it will auto-disable.

In other cases where we write a property as a one-shot thing (fences for
android). In that case when you read that property it's always 0 (well, -1
for fences since file descriptor). That also avoids the issues when
userspace unconditionally saves/restores all properties (this is needed
for generic compositor switching).

I think a better behaviour would be to do the same trick, with FB_ID on
the connector always returning 0 as the current value. That encodes the
one-shot behaviour directly.

For one-shot vs continuous: Maybe we want to simply have a separate
writeback property for continues, e.g. FB_WRITEBACK_ONE_SHOT_ID and
FB_WRITEBACK_CONTINUOUS_ID.

> Known issues:
> -------------
>  * I'm not sure what "DPMS" should mean for writeback connectors.
>    It could be used to disable writeback (even when a framebuffer is
>    attached), or it could be hidden entirely (which would break the
>    legacy DPMS call for writeback connectors).

dpms is legacy, in atomic land the only thing you have is "ACTIVE" on the
crtc. it disables everything, i.e. also writeback.

>  * With Daniel's recent re-iteration of the userspace API rules, I
>    fully expect to provide some userspace code to support this. The
>    question is what, and where? We want to use writeback for testing,
>    so perhaps some tests in igt is suitable.

Hm, testing would be better as a debugfs interface, but I understand the
appeal of doing this with atomic (since semantics fit so well). Another
use-case of this is compositing, but if the main goal is igt and testing,
I think integration into igt crc based testcases is a perfectly fine
userspace.

>  * Documentation. Probably some portion of this cover letter needs to
>    make it into Documentation/

Yeah, an overview DOC: section in a separate source file (with all the the
infrastructure work) would be great - aka needed from my pov ;-)

>  * Synchronisation. Our hardware will finish the writeback by the next
>    vsync. I've not implemented fence support here, but it would be an
>    obvious addition.

Probably just want an additional WRITEBACK_FENCE_ID property to signal
completion. Some hw definitely will take longer to write back than just a
vblank. But we can delay that until it's needed.
-Daniel

> 
> See Also:
> ---------
> [1] https://lists.freedesktop.org/archives/dri-devel/2016-July/113197.html
> [2] https://lists.freedesktop.org/archives/dri-devel/2016-October/120486.html
> 
> I welcome any comments, especially if this approach does/doesn't fit
> well with anyone else's hardware.
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
> -- 
> 1.7.9.5
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
