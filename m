Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:49754 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752796AbcJKV0J (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Oct 2016 17:26:09 -0400
Date: Tue, 11 Oct 2016 22:24:23 +0100
From: Brian Starkey <brian.starkey@arm.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Liviu Dudau <liviu.dudau@arm.com>,
        "Clark, Rob" <robdclark@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Eric Anholt <eric@anholt.net>,
        "Syrjala, Ville" <ville.syrjala@linux.intel.com>
Subject: Re: [RFC PATCH 00/11] Introduce writeback connectors
Message-ID: <20161011212423.GA10077@e106950-lin.cambridge.arm.com>
References: <1476197648-24918-1-git-send-email-brian.starkey@arm.com>
 <20161011154359.GD20761@phenom.ffwll.local>
 <20161011164305.GA14337@e106950-lin.cambridge.arm.com>
 <CAKMK7uFqiLCCcCz154SU-ZG5rygSBz2_P7M29EkFh8pGMfXvOw@mail.gmail.com>
 <20161011194422.GC14337@e106950-lin.cambridge.arm.com>
 <CAKMK7uEQsiBLQGghdDvmPicc_F6+3Ra_sd7keSKTPAgsNKbdog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAKMK7uEQsiBLQGghdDvmPicc_F6+3Ra_sd7keSKTPAgsNKbdog@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 11, 2016 at 10:02:43PM +0200, Daniel Vetter wrote:
>On Tue, Oct 11, 2016 at 9:44 PM, Brian Starkey <brian.starkey@arm.com> wrote:
>> Hi,
>>
>>
>> On Tue, Oct 11, 2016 at 07:01:33PM +0200, Daniel Vetter wrote:
>>>
>>> On Tue, Oct 11, 2016 at 6:43 PM, Brian Starkey <brian.starkey@arm.com>
>>> wrote:
>>>>
>>>> Hi Daniel,
>>>>
>>>> Firstly thanks very much for having a look.
>>>>
>>>>
>>>> On Tue, Oct 11, 2016 at 05:43:59PM +0200, Daniel Vetter wrote:
>>>>>
>>>>>
>>>>> On Tue, Oct 11, 2016 at 03:53:57PM +0100, Brian Starkey wrote:
>>>>>>
>>>>>>
>>>>>> Hi,
>>>>>>
>>>>>> This RFC series introduces a new connector type:
>>>>>>  DRM_MODE_CONNECTOR_WRITEBACK
>>>>>> It is a follow-on from a previous discussion: [1]
>>>>>>
>>>>>> Writeback connectors are used to expose the memory writeback engines
>>>>>> found in some display controllers, which can write a CRTC's
>>>>>> composition result to a memory buffer.
>>>>>> This is useful e.g. for testing, screen-recording, screenshots,
>>>>>> wireless display, display cloning, memory-to-memory composition.
>>>>>>
>>>>>> Patches 1-7 include the core framework changes required, and patches
>>>>>> 8-11 implement a writeback connector for the Mali-DP writeback engine.
>>>>>> The Mali-DP patches depend on this other series: [2].
>>>>>>
>>>>>> The connector is given the FB_ID property for the output framebuffer,
>>>>>> and two new read-only properties: PIXEL_FORMATS and
>>>>>> PIXEL_FORMATS_SIZE, which expose the supported framebuffer pixel
>>>>>> formats of the engine.
>>>>>>
>>>>>> The EDID property is not exposed for writeback connectors.
>>>>>>
>>>>>> Writeback connector usage:
>>>>>> --------------------------
>>>>>> Due to connector routing changes being treated as "full modeset"
>>>>>> operations, any client which wishes to use a writeback connector
>>>>>> should include the connector in every modeset. The writeback will not
>>>>>> actually become active until a framebuffer is attached.
>>>>>
>>>>>
>>>>>
>>>>> Erhm, this is just the default, drivers can override this. And we could
>>>>> change the atomic helpers to not mark a modeset as a modeset if the
>>>>> connector that changed is a writeback one.
>>>>>
>>>>
>>>> Hmm, maybe. I don't think it's ideal - the driver would need to
>>>> re-implement drm_atomic_helper_check_modeset, which is quite a chunk
>>>> of code (along with exposing update_connector_routing, mode_fixup,
>>>> maybe others), and even after that it would have to lie and set
>>>> crtc_state->connectors_changed to false so that
>>>> drm_crtc_needs_modeset returns false to drm_atomic_check_only.
>>>
>>>
>>> You only need to update the property in your encoders's ->atomic_check
>>> function. No need for more, and I think being consistent with
>>> computing when you need a modeset is really a crucial part of the
>>> atomic ioctl that we should imo try to implement correctly as much as
>>> possible.
>>>
>>
>> Sorry I really don't follow. Which property? CRTC_ID?
>>
>> Userspace changing CRTC_ID will change connector_state->crtc (before
>> we even get to a driver callback).
>>
>> After that, drm_atomic_helper_check_modeset derives connectors_changed
>> based on the ->crtc pointers.
>>
>> After that, my encoder ->atomic_check *could* clear
>> connectors_changed (or I could achieve the same thing by wrapping
>> drm_atomic_helper_check), but it seems wrong to do so, considering
>> that the connector routing *has* changed.
>>
>> If you think changing CRTC_ID shouldn't require a full modeset, I'd
>> rather give drivers a ->needs_modeset callback to override the default
>> drm_atomic_crtc_needs_modeset behaviour, instead of "tricking" it into
>> returning false.
>
>The problem with just that is that there's lots of different things
>that can feed into the overall needs_modeset variable. That's why we
>split it up into multiple booleans.
>
>So yes you're supposed to clear connectors_changed if there is some
>change that you can handle without a full modeset. If you want, think
>of connectors_changed as
>needs_modeset_due_to_change_in_connnector_state, but that's cumbersome
>to type and too long ;-)
>

All right, got it :-). This intention wasn't clear to me from the
comments in the code.

>> I can imagine some hardware will need a full modeset to changed the
>> writeback CRTC binding anyway.
>
>Yup, and then they can upgrade this again. With all these flow-control
>booleans the idea is very much that helpers give a default that works
>for 90% of all cases, and driver callbacks can then change it for the
>other 10%.
>
>>>> I tried to keep special-casing of writeback connectors in the 
>>>> core to
>>>> a bare minimum, because I think it will quickly get messy and fragile
>>>> otherwise.
>>>
>>>
>>> Please always make the disdinction between core and shared drm
>>> helpers. Special cases in core == probably not good. Special cases in
>>> helpers == perfectly fine imo.
>>>
>>>> Honestly, I don't see modesetting the writeback connectors at
>>>> start-of-day as a big problem.
>>>
>>>
>>> It's inconsistent. Claiming it needs a modeset when it doesn't isn't
>>> great. Making that more discoverable to userspace is the entire point
>>> of atomic. And there might be hw where reconfiguring for writeback
>>> might need a full modeset.
>>>
>>
>> I'm a little confused - what bit exactly is inconsistent?
>
>Not being truthful for when you need a modeset and when not.
>
>> My implementation here is consistent with other connectors.
>> Updating the writeback connector CRTC_ID property requires a full
>> modeset, the same as other connectors.
>
>It's not about consistency with other implementations, it's about
>consistency with what your hw can do. E.g. i915 clears
>crtc_state->mode_changed when we can do a mode change without a full
>modeset. The goal of atomic is to expose the full features of each hw
>(including all quirks), not reduce it all to a least common set of
>shared features.
>

Understood, I will make sure that we don't require a modeset unless
absolutely necessary.

>> Changing the FB_ID does *not* require a full modeset, because our
>> hardware has no such restriction. This is analogous to updating the
>> FB_ID on our planes, and is consistent with the other instances of the
>> FB_ID property.
>
>Well that's inconsistent with connector properties, because in general
>they all do require a full modeset to change ;-) I.e. consistency with
>other drivers really isn't a good argument.
>
>> If there is hardware which does have a restriction on changing FB_ID, I
>> think that driver must be responsible for handling it in the same
>> way as drivers which can't handle plane updates without a full
>> modeset.
>>
>> Are you saying that because setting CRTC_ID on Mali-DP is a no-op, it
>> shouldn't require a full modeset? I'd rather somehow hard-code the
>> CRTC_ID for our writeback connector to have it always attached to
>> the CRTC in that case.
>
>Yup, I think if changing the CRTC_ID of the writeback connector
>doesn't require a modeset, then your driver better not require a full
>modeset to do that change. Maybe there's only one writeback port, and
>userspace wants to move it around. And if the hw supports that without
>a full modeset, then I think we should allow that. I also think that
>most hw will get away with changing the writeback routing without
>doing a full modeset. I might be mistaken about that though. And if
>it's not clear-cut we could add a new writeback_changed boolean to
>track this.
>
>And from a user experience pov I really think we should avoid modesets
>like the plague. Plugging in a chromecast stick and then watching how
>your panel flickers is just not nice.
>

Yup, makes sense. I think my mindset is still a bit stuck in SETCRTC-
land.

>>>>>> The writeback itself is enabled by attaching a framebuffer to the
>>>>>> FB_ID property of the connector. The driver must then ensure that the
>>>>>> CRTC content of that atomic commit is written into the framebuffer.
>>>>>>
>>>>>> The writeback works in a one-shot mode with each atomic commit. This
>>>>>> prevents the same content from being written multiple times.
>>>>>> In some cases (front-buffer rendering) there might be a desire for
>>>>>> continuous operation - I think a property could be added later for
>>>>>> this kind of control.
>>>>>>
>>>>>> Writeback can be disabled by setting FB_ID to zero.
>>>>>
>>>>>
>>>>>
>>>>> This seems to contradict itself: If it's one-shot, there's no need to
>>>>> disable it - it will auto-disable.
>>>>
>>>>
>>>>
>>>> I should have explained one-shot more clearly. What I mean is, one
>>>> drmModeAtomicCommit == one write to memory. This is as opposed to
>>>> writing the same thing to memory every vsync until it is stopped
>>>> (which our HW is capable of doing).
>>>>
>>>> A subsequent drmModeAtomicCommit which doesn't touch the writeback FB_ID
>>>> will write (again - but with whatever scene updates) to the same
>>>> framebuffer.
>>>>
>>>> This continues for every drmModeAtomicCommit until FB_ID is set to
>>>> zero - to disable writing - or changed to a different framebuffer, in
>>>> which case we write to the new one.
>>>>
>>>> IMO this behaviour makes sense in the context of the rest of Atomic,
>>>> and as the FB_ID is indeed persistent across atomic commits, I think
>>>> it should be read-able.
>>>
>>>
>>> tbh I don't like that, I think it'd be better to make this truly
>>> one-shot. Otherwise we'll have real fun problems with hw where the
>>> writeback can take longer than a vblank (it happens ...). So one-shot,
>>> with auto-clearing to NULL/0 is imo the right approach.
>>>
>>
>> That's an interesting point about hardware which won't finish within
>> one frame; but I don't see how "true one-shot" helps.
>>
>> What's the expected behaviour if userspace makes a new atomic commit
>> with a writeback framebuffer whilst a previous writeback is ongoing?
>>
>> In both cases, you either need to block or fail the commit - whether
>> the framebuffer gets removed when it's done is immaterial.
>
>See Eric's question. We need to define that, and I think the simplest
>approach is a completion fence/sync_file. It's destaged now in 4.9, we
>can use them. I think the simplest uabi would be a pointer property
>(u64) where we write the fd of the fence we'll signal when write-out
>completes.
>

That tells userspace that the previous writeback is finished, I agree 
that's needed. It doesn't define any behaviour in case userspace asks 
for another writeback before that fence fires though.

>>>>> In other cases where we write a property as a one-shot thing (fences for
>>>>> android). In that case when you read that property it's always 0 (well,
>>>>> -1
>>>>> for fences since file descriptor). That also avoids the issues when
>>>>> userspace unconditionally saves/restores all properties (this is needed
>>>>> for generic compositor switching).
>>>>>
>>>>> I think a better behaviour would be to do the same trick, with FB_ID on
>>>>> the connector always returning 0 as the current value. That encodes the
>>>>> one-shot behaviour directly.
>>>>>

I had more of a think about this. I think you're right that
one-shot-write-only makes sense for the framebuffer - at least I can't
think of a decent use case needing the persistent behaviour which
couldn't easily be achieved using the one-shot style.

Thanks!
-Brian

>>>>> For one-shot vs continuous: Maybe we want to simply have a separate
>>>>> writeback property for continues, e.g. FB_WRITEBACK_ONE_SHOT_ID and
>>>>> FB_WRITEBACK_CONTINUOUS_ID.
>>>>>
>>>>>> Known issues:
>>>>>> -------------
>>>>>>  * I'm not sure what "DPMS" should mean for writeback connectors.
>>>>>>    It could be used to disable writeback (even when a framebuffer is
>>>>>>    attached), or it could be hidden entirely (which would break the
>>>>>>    legacy DPMS call for writeback connectors).
>>>>>
>>>>>
>>>>>
>>>>> dpms is legacy, in atomic land the only thing you have is "ACTIVE" on
>>>>> the
>>>>> crtc. it disables everything, i.e. also writeback.
>>>>>
>>>>
>>>> So removing the DPMS property is a viable option for writeback connectors
>>>> in
>>>> your opinion?
>>>
>>>
>>> Nah, that's part of the abi now. But atomic internally remaps it to
>>> "ACTIVE", in short you don't need to care (as long as you fill out the
>>> dpms hook with the provided helper. drm_writeback_connector_init
>>> should probably do that).
>>>
>>
>> A connector can still be DPMS-ed individually, so a CRTC can be
>> "ACTIVE", attached to an "OFF" writeback connector, and the writeback
>> connector would still be able to actively write to memory.
>
>Yes, but atomic drivers ignore that. You should too. I won't take
>patches which create special behaviour for dpms on the writeback
>connector. If you want to change the writeback separately, then we can
>change the CRTC_ID of the writeback connector. And the driver should
>report correctly whether that needs a modeset or not.
>
>> I'm OK with that, and it's what I already implemented, but I thought
>> that userspace might reasonably expect a writeback connector with DPMS
>> set to "OFF" to be completely inert.
>
>Nope, DPMS turned out to be a mistake in kms (no one supports the
>intermediate stages, they don't make sense) and we nerfed it in
>atomic. Please don't resurrect zombies ;-)
>-Daniel
>-- 
>Daniel Vetter
>Software Engineer, Intel Corporation
>+41 (0) 79 365 57 48 - http://blog.ffwll.ch
>
