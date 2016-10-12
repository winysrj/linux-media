Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:54054 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754073AbcJLHlk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Oct 2016 03:41:40 -0400
Date: Wed, 12 Oct 2016 08:30:37 +0100
From: Brian Starkey <brian.starkey@arm.com>
To: Eric Anholt <eric@anholt.net>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, liviu.dudau@arm.com,
        robdclark@gmail.com, hverkuil@xs4all.nl,
        ville.syrjala@linux.intel.com, daniel@ffwll.ch
Subject: Re: [RFC PATCH 00/11] Introduce writeback connectors
Message-ID: <20161012072643.GA17390@localhost>
References: <1476197648-24918-1-git-send-email-brian.starkey@arm.com>
 <87d1j6emmd.fsf@eliezer.anholt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <87d1j6emmd.fsf@eliezer.anholt.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Eric,

On Tue, Oct 11, 2016 at 12:01:14PM -0700, Eric Anholt wrote:
>Brian Starkey <brian.starkey@arm.com> writes:
>
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
>>
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
>I think this sounds great, and the interface is just right IMO.
>

Thanks, glad you like it! Hopefully you're equally agreeable with the
changes Daniel has been suggesting.

>I don't really see a use for continuous mode -- a sequence of one-shots
>makes a lot more sense because then you can know what data has changed,
>which anyone trying to use the writeback buffer would need to know.
>

Agreed - we've never found a use for it.

>> Known issues:
>> -------------
>>  * I'm not sure what "DPMS" should mean for writeback connectors.
>>    It could be used to disable writeback (even when a framebuffer is
>>    attached), or it could be hidden entirely (which would break the
>>    legacy DPMS call for writeback connectors).
>>  * With Daniel's recent re-iteration of the userspace API rules, I
>>    fully expect to provide some userspace code to support this. The
>>    question is what, and where? We want to use writeback for testing,
>>    so perhaps some tests in igt is suitable.
>>  * Documentation. Probably some portion of this cover letter needs to
>>    make it into Documentation/
>>  * Synchronisation. Our hardware will finish the writeback by the next
>>    vsync. I've not implemented fence support here, but it would be an
>>    obvious addition.
>
>My hardware won't necessarily finish by the next vsync -- it trickles
>out at whatever rate it can find memory bandwidth to get the job done,
>and fires an interrupt when it's finished.
>

Is it bounded? You presumably have to finish the write-out before you
can change any input buffers?

>So I would like some definition for how syncing works.  One answer would
>be that these flips don't trigger their pageflip events until the
>writeback is done (so I need to collect both the vsync irq and the
>writeback irq before sending).  Another would be that manage an
>independent fence for the writeback fb, so that you still immediately
>know when framebuffers from the previous scanout-only frame are idle.
>

I much prefer the sound of the explicit fence approach.

Hopefully we can agree that a new atomic commit can't be completed
whilst there's a writeback ongoing, otherwise managing the fence and
framebuffer lifetime sounds really tricky - they'd need to be decoupled
from the atomic_state and outlive the commit that spawned them.

Cheers,
-Brian

>Also, tests for this in igt, please.  Writeback in igt will give us so
>much more ability to cover KMS functionality on non-Intel hardware.
