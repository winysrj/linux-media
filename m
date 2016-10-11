Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:39768 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752505AbcJKQpg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Oct 2016 12:45:36 -0400
Date: Tue, 11 Oct 2016 17:43:06 +0100
From: Brian Starkey <brian.starkey@arm.com>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, liviu.dudau@arm.com,
        robdclark@gmail.com, hverkuil@xs4all.nl, eric@anholt.net,
        ville.syrjala@linux.intel.com
Subject: Re: [RFC PATCH 00/11] Introduce writeback connectors
Message-ID: <20161011164305.GA14337@e106950-lin.cambridge.arm.com>
References: <1476197648-24918-1-git-send-email-brian.starkey@arm.com>
 <20161011154359.GD20761@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20161011154359.GD20761@phenom.ffwll.local>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Daniel,

Firstly thanks very much for having a look.

On Tue, Oct 11, 2016 at 05:43:59PM +0200, Daniel Vetter wrote:
>On Tue, Oct 11, 2016 at 03:53:57PM +0100, Brian Starkey wrote:
>> Hi,
>>
>> This RFC series introduces a new connector type:
>>  DRM_MODE_CONNECTOR_WRITEBACK
>> It is a follow-on from a previous discussion: [1]
>>
>> Writeback connectors are used to expose the memory writeback engines
>> found in some display controllers, which can write a CRTC's
>> composition result to a memory buffer.
>> This is useful e.g. for testing, screen-recording, screenshots,
>> wireless display, display cloning, memory-to-memory composition.
>>
>> Patches 1-7 include the core framework changes required, and patches
>> 8-11 implement a writeback connector for the Mali-DP writeback engine.
>> The Mali-DP patches depend on this other series: [2].
>>
>> The connector is given the FB_ID property for the output framebuffer,
>> and two new read-only properties: PIXEL_FORMATS and
>> PIXEL_FORMATS_SIZE, which expose the supported framebuffer pixel
>> formats of the engine.
>>
>> The EDID property is not exposed for writeback connectors.
>>
>> Writeback connector usage:
>> --------------------------
>> Due to connector routing changes being treated as "full modeset"
>> operations, any client which wishes to use a writeback connector
>> should include the connector in every modeset. The writeback will not
>> actually become active until a framebuffer is attached.
>
>Erhm, this is just the default, drivers can override this. And we could
>change the atomic helpers to not mark a modeset as a modeset if the
>connector that changed is a writeback one.
>

Hmm, maybe. I don't think it's ideal - the driver would need to
re-implement drm_atomic_helper_check_modeset, which is quite a chunk
of code (along with exposing update_connector_routing, mode_fixup,
maybe others), and even after that it would have to lie and set
crtc_state->connectors_changed to false so that
drm_crtc_needs_modeset returns false to drm_atomic_check_only.

I tried to keep special-casing of writeback connectors in the core to
a bare minimum, because I think it will quickly get messy and fragile
otherwise.

Honestly, I don't see modesetting the writeback connectors at
start-of-day as a big problem.

>> The writeback itself is enabled by attaching a framebuffer to the
>> FB_ID property of the connector. The driver must then ensure that the
>> CRTC content of that atomic commit is written into the framebuffer.
>>
>> The writeback works in a one-shot mode with each atomic commit. This
>> prevents the same content from being written multiple times.
>> In some cases (front-buffer rendering) there might be a desire for
>> continuous operation - I think a property could be added later for
>> this kind of control.
>>
>> Writeback can be disabled by setting FB_ID to zero.
>
>This seems to contradict itself: If it's one-shot, there's no need to
>disable it - it will auto-disable.

I should have explained one-shot more clearly. What I mean is, one
drmModeAtomicCommit == one write to memory. This is as opposed to
writing the same thing to memory every vsync until it is stopped
(which our HW is capable of doing).

A subsequent drmModeAtomicCommit which doesn't touch the writeback 
FB_ID will write (again - but with whatever scene updates) to the same
framebuffer.

This continues for every drmModeAtomicCommit until FB_ID is set to
zero - to disable writing - or changed to a different framebuffer, in
which case we write to the new one.

IMO this behaviour makes sense in the context of the rest of Atomic,
and as the FB_ID is indeed persistent across atomic commits, I think
it should be read-able.

>
>In other cases where we write a property as a one-shot thing (fences for
>android). In that case when you read that property it's always 0 (well, -1
>for fences since file descriptor). That also avoids the issues when
>userspace unconditionally saves/restores all properties (this is needed
>for generic compositor switching).
>
>I think a better behaviour would be to do the same trick, with FB_ID on
>the connector always returning 0 as the current value. That encodes the
>one-shot behaviour directly.
>
>For one-shot vs continuous: Maybe we want to simply have a separate
>writeback property for continues, e.g. FB_WRITEBACK_ONE_SHOT_ID and
>FB_WRITEBACK_CONTINUOUS_ID.
>
>> Known issues:
>> -------------
>>  * I'm not sure what "DPMS" should mean for writeback connectors.
>>    It could be used to disable writeback (even when a framebuffer is
>>    attached), or it could be hidden entirely (which would break the
>>    legacy DPMS call for writeback connectors).
>
>dpms is legacy, in atomic land the only thing you have is "ACTIVE" on the
>crtc. it disables everything, i.e. also writeback.
>

So removing the DPMS property is a viable option for writeback 
connectors in your opinion?

>>  * With Daniel's recent re-iteration of the userspace API rules, I
>>    fully expect to provide some userspace code to support this. The
>>    question is what, and where? We want to use writeback for testing,
>>    so perhaps some tests in igt is suitable.
>
>Hm, testing would be better as a debugfs interface, but I understand the
>appeal of doing this with atomic (since semantics fit so well). Another
>use-case of this is compositing, but if the main goal is igt and testing,
>I think integration into igt crc based testcases is a perfectly fine
>userspace.
>
>>  * Documentation. Probably some portion of this cover letter needs 
>>  to
>>    make it into Documentation/
>
>Yeah, an overview DOC: section in a separate source file (with all the the
>infrastructure work) would be great - aka needed from my pov ;-)
>

Sure, I'll a look at splitting into a drm_writeback.c

>>  * Synchronisation. Our hardware will finish the writeback by the next
>>    vsync. I've not implemented fence support here, but it would be an
>>    obvious addition.
>
>Probably just want an additional WRITEBACK_FENCE_ID property to signal
>completion. Some hw definitely will take longer to write back than just a
>vblank. But we can delay that until it's needed.
>-Daniel
>
>>
>> See Also:
>> ---------
>> [1] https://lists.freedesktop.org/archives/dri-devel/2016-July/113197.html
>> [2] https://lists.freedesktop.org/archives/dri-devel/2016-October/120486.html
>>
>> I welcome any comments, especially if this approach does/doesn't fit
>> well with anyone else's hardware.
>>
>> Thanks,
>>
>> -Brian
>>
>> ---
>>
>> Brian Starkey (10):
>>   drm: add writeback connector type
>>   drm/fb-helper: skip writeback connectors
>>   drm: extract CRTC/plane disable from drm_framebuffer_remove
>>   drm: add __drm_framebuffer_remove_atomic
>>   drm: add fb to connector state
>>   drm: expose fb_id property for writeback connectors
>>   drm: add writeback-connector pixel format properties
>>   drm: mali-dp: rename malidp_input_format
>>   drm: mali-dp: add RGB writeback formats for DP550/DP650
>>   drm: mali-dp: add writeback connector
>>
>> Liviu Dudau (1):
>>   drm: mali-dp: Add support for writeback on DP550/DP650
>>
>>  drivers/gpu/drm/arm/Makefile        |    1 +
>>  drivers/gpu/drm/arm/malidp_crtc.c   |   10 ++
>>  drivers/gpu/drm/arm/malidp_drv.c    |   25 +++-
>>  drivers/gpu/drm/arm/malidp_drv.h    |    5 +
>>  drivers/gpu/drm/arm/malidp_hw.c     |  104 ++++++++++----
>>  drivers/gpu/drm/arm/malidp_hw.h     |   27 +++-
>>  drivers/gpu/drm/arm/malidp_mw.c     |  268 +++++++++++++++++++++++++++++++++++
>>  drivers/gpu/drm/arm/malidp_planes.c |    8 +-
>>  drivers/gpu/drm/arm/malidp_regs.h   |   15 ++
>>  drivers/gpu/drm/drm_atomic.c        |   40 ++++++
>>  drivers/gpu/drm/drm_atomic_helper.c |    4 +
>>  drivers/gpu/drm/drm_connector.c     |   79 ++++++++++-
>>  drivers/gpu/drm/drm_crtc.c          |   14 +-
>>  drivers/gpu/drm/drm_fb_helper.c     |    4 +
>>  drivers/gpu/drm/drm_framebuffer.c   |  249 ++++++++++++++++++++++++++++----
>>  drivers/gpu/drm/drm_ioctl.c         |    7 +
>>  include/drm/drmP.h                  |    2 +
>>  include/drm/drm_atomic.h            |    3 +
>>  include/drm/drm_connector.h         |   15 ++
>>  include/drm/drm_crtc.h              |   12 ++
>>  include/uapi/drm/drm.h              |   10 ++
>>  include/uapi/drm/drm_mode.h         |    1 +
>>  22 files changed, 830 insertions(+), 73 deletions(-)
>>  create mode 100644 drivers/gpu/drm/arm/malidp_mw.c
>>
>> --
>> 1.7.9.5
>>
>
>-- 
>Daniel Vetter
>Software Engineer, Intel Corporation
>http://blog.ffwll.ch
>
