Return-path: <linux-media-owner@vger.kernel.org>
Received: from anholt.net ([50.246.234.109]:33171 "EHLO anholt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754942AbcJMRcY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Oct 2016 13:32:24 -0400
From: Eric Anholt <eric@anholt.net>
To: Brian Starkey <brian.starkey@arm.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, liviu.dudau@arm.com,
        robdclark@gmail.com, hverkuil@xs4all.nl,
        ville.syrjala@linux.intel.com, daniel@ffwll.ch
Subject: Re: [RFC PATCH 00/11] Introduce writeback connectors
In-Reply-To: <20161012072643.GA17390@localhost>
References: <1476197648-24918-1-git-send-email-brian.starkey@arm.com> <87d1j6emmd.fsf@eliezer.anholt.net> <20161012072643.GA17390@localhost>
Date: Thu, 13 Oct 2016 10:32:22 -0700
Message-ID: <87k2dc9mu1.fsf@eliezer.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--=-=-=
Content-Type: text/plain

Brian Starkey <brian.starkey@arm.com> writes:

> Hi Eric,
>
> On Tue, Oct 11, 2016 at 12:01:14PM -0700, Eric Anholt wrote:
>>Brian Starkey <brian.starkey@arm.com> writes:
>>
>>> Hi,
>>>
>>> This RFC series introduces a new connector type:
>>>  DRM_MODE_CONNECTOR_WRITEBACK
>>> It is a follow-on from a previous discussion: [1]
>>>
>>> Writeback connectors are used to expose the memory writeback engines
>>> found in some display controllers, which can write a CRTC's
>>> composition result to a memory buffer.
>>> This is useful e.g. for testing, screen-recording, screenshots,
>>> wireless display, display cloning, memory-to-memory composition.
>>>
>>> Patches 1-7 include the core framework changes required, and patches
>>> 8-11 implement a writeback connector for the Mali-DP writeback engine.
>>> The Mali-DP patches depend on this other series: [2].
>>>
>>> The connector is given the FB_ID property for the output framebuffer,
>>> and two new read-only properties: PIXEL_FORMATS and
>>> PIXEL_FORMATS_SIZE, which expose the supported framebuffer pixel
>>> formats of the engine.
>>>
>>> The EDID property is not exposed for writeback connectors.
>>>
>>> Writeback connector usage:
>>> --------------------------
>>> Due to connector routing changes being treated as "full modeset"
>>> operations, any client which wishes to use a writeback connector
>>> should include the connector in every modeset. The writeback will not
>>> actually become active until a framebuffer is attached.
>>>
>>> The writeback itself is enabled by attaching a framebuffer to the
>>> FB_ID property of the connector. The driver must then ensure that the
>>> CRTC content of that atomic commit is written into the framebuffer.
>>>
>>> The writeback works in a one-shot mode with each atomic commit. This
>>> prevents the same content from being written multiple times.
>>> In some cases (front-buffer rendering) there might be a desire for
>>> continuous operation - I think a property could be added later for
>>> this kind of control.
>>>
>>> Writeback can be disabled by setting FB_ID to zero.
>>
>>I think this sounds great, and the interface is just right IMO.
>>
>
> Thanks, glad you like it! Hopefully you're equally agreeable with the
> changes Daniel has been suggesting.

Haven't seen anything objectionable there.

>>> Known issues:
>>> -------------
>>>  * I'm not sure what "DPMS" should mean for writeback connectors.
>>>    It could be used to disable writeback (even when a framebuffer is
>>>    attached), or it could be hidden entirely (which would break the
>>>    legacy DPMS call for writeback connectors).
>>>  * With Daniel's recent re-iteration of the userspace API rules, I
>>>    fully expect to provide some userspace code to support this. The
>>>    question is what, and where? We want to use writeback for testing,
>>>    so perhaps some tests in igt is suitable.
>>>  * Documentation. Probably some portion of this cover letter needs to
>>>    make it into Documentation/
>>>  * Synchronisation. Our hardware will finish the writeback by the next
>>>    vsync. I've not implemented fence support here, but it would be an
>>>    obvious addition.
>>
>>My hardware won't necessarily finish by the next vsync -- it trickles
>>out at whatever rate it can find memory bandwidth to get the job done,
>>and fires an interrupt when it's finished.
>>
>
> Is it bounded? You presumably have to finish the write-out before you
> can change any input buffers?

Yeah, I'm not sure what it would mean to try to swap my display list
while write-out was happening.  Each CRTC (each of which can only
support one encoder at a time) has its own display list, though, so it
could avoid blocking other modesets.

>>So I would like some definition for how syncing works.  One answer would
>>be that these flips don't trigger their pageflip events until the
>>writeback is done (so I need to collect both the vsync irq and the
>>writeback irq before sending).  Another would be that manage an
>>independent fence for the writeback fb, so that you still immediately
>>know when framebuffers from the previous scanout-only frame are idle.
>>
>
> I much prefer the sound of the explicit fence approach.
>
> Hopefully we can agree that a new atomic commit can't be completed
> whilst there's a writeback ongoing, otherwise managing the fence and
> framebuffer lifetime sounds really tricky - they'd need to be decoupled
> from the atomic_state and outlive the commit that spawned them.

Oh, good point.

I'm fine with that, but then my anticipated usecases for writeback are
testing (don't care about performance) and fallback plane-squashing when
a complicated modeset exceeds limits (in which case you have no simpler
plane config to modeset to until the writeback is completed, anyway).

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJX/8UmAAoJELXWKTbR/J7oLL0QALttl7goSK1yNzv/4Bdg1GNn
dc43F1mVSazwgOTvmb4xr6tg2QHLNrAUPxmHqXZ2CToktI8tCE0msqMOgLeP+8N6
pUKt2E44CwVN5MdPBKjrKezO/TVE2dHTmObTF6zxM/XfxRL6/ngcuJow7w+Fvsjr
wPHPKHm1a9R60wJivWENPA1NtDRWP4oKja0cxo28oSpCXEVx8WA3gLUCpWcR4Bv2
KK//CVKzA9tahKnVeup9+tPBv62V7Bg4nSaH9o7+aPfBnUNuxGHLlZ8OhKawcnhA
bPU85E41T+JmkbQOEEK8Ktw0oOHw9LIL+27z7S069VTTviElayGApEa2fRTy/vPf
WnhX5DIZaiJo011xtPgQmU18wzYFrDHAo2neeo5YhKzv/mYcJFSmm5PcS3SjbtVq
ywk75VpFNOr62WNrxMF3z1qKHButKdF3VYW57oDFTycAKVy+gzbZlE2VyZKAIViP
5OzxhAX7pMaF6oB4zgAGrcHW+VT42MYrculpb+lzOT2ZECkKP9l6THfom3NeurJ9
xr8gkpsVDCi9ziCV3nIRuV9noYrICAPeSrVNaI843EJuEV+0dLY4XK/ZXBJQuO/i
g84S9YIS8f4+l5m6pfHGnDJE1TLsFucQVuOcoAQl5ZJZi/QWD8oi/vVSQkPVnZwi
Ki9JJir4v0pnclXferoS
=4oVk
-----END PGP SIGNATURE-----
--=-=-=--
