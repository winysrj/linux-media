Return-path: <mchehab@pedra>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:48029 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab1CPSDH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2011 14:03:07 -0400
Received: by qyg14 with SMTP id 14so1798615qyg.19
        for <linux-media@vger.kernel.org>; Wed, 16 Mar 2011 11:03:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201103161849.35496.laurent.pinchart@ideasonboard.com>
References: <201103080913.59231.hverkuil@xs4all.nl>
	<AANLkTi=+2-K9-nt_Sahhrr4K9yg1bzotVexq_YnUTJYi@mail.gmail.com>
	<AANLkTimX1-2COQEZKMLq_EMWfGv=CGd6EWhfVnQDJ-SS@mail.gmail.com>
	<201103161849.35496.laurent.pinchart@ideasonboard.com>
Date: Wed, 16 Mar 2011 14:03:06 -0400
Message-ID: <AANLkTi=wNmpGw74rZ_GRkXGMrSOV-z7ER1=-xCpjmZd4@mail.gmail.com>
Subject: Re: Yet another memory provider: can linaro organize a meeting?
From: Alex Deucher <alexdeucher@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Li Li <eggonlea@gmail.com>,
	Robert Fekete <robert.fekete@linaro.org>,
	Jonghun Han <jonghun.han@samsung.com>,
	Andy Walls <awalls@md.metrocast.net>,
	linaro-dev@lists.linaro.org, Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Mar 16, 2011 at 1:49 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Alex,
>
> On Wednesday 16 March 2011 17:09:45 Alex Deucher wrote:
>> On Wed, Mar 16, 2011 at 3:37 AM, Li Li <eggonlea@gmail.com> wrote:
>> > Sorry but I feel the discussion is a bit off the point. We're not
>> > going to compare the pros and cons of current code (GEM/TTM, HWMEM,
>> > UMP, CMA, VCM, CMEM, PMEM, etc.)
>> >
>> > The real problem is to find a suitable unified memory management
>> > module for various kinds of HW components (including CPU, VPU, GPU,
>> > camera, FB/OVL, etc.), especially for ARM based SOC. Some HW requires
>> > physical continuous big chunk of memory (e.g. some VPU & OVL); while
>> > others could live with DMA chain (e.g. some powerful GPU has built-in
>> > MMU).
>> >
>> > So, what's current situation?
>> >
>> > 1) As Hans mentioned, there're GEM & TTM in upstream kernel, under the
>> > DRM framework (w/ KMS, etc.). This works fine on conventional (mostly
>> > Xorg-based) Linux distribution.
>> >
>> > 2) But DRM (or GEM/TTM) is still too heavy and complex to some
>> > embedded OS, which only want a cheaper memory management module. So...
>> >
>> > 2.1) Google uses PMEM in Android - However PMEM was removed from
>> > upstream kernel for well-known reasons;
>> >
>> > 2.2) Qualcomm writes a hybrid KGSL based DRM+PMEM solution - However
>> > KGSL was shamed in dri-devel list because their close user space
>> > binary.
>> >
>> > 2.3) ARM starts UMP/MaliDRM for both of Android and X11/DRI2 - This
>> > makes things even more complicated. (Therefore I personally think this
>> > is actually a shame for ARM to create another private SW. As a leader
>> > of Linaro, ARM should think more and coordinate with partners better
>> > to come up a unified solution to make our life easier.)
>> >
>> > 2.4) Other companies also have their own private solutions because
>> > nobody can get a STANDARD interface from upstream, including Marvell,
>> > TI, Freescale.
>> >
>> >
>> >
>> > In general, it would be highly appreciated if Linaro guys could sit
>> > down together around a table, co-work with silicon vendors and
>> > upstream Linux kernel maintainers to make a unified (and cheaper than
>> > GEM/TTM/DRM) memory management module. This module should be reviewed
>> > carefully and strong enough to replace any other private memory
>> > manager mentioned above. It should replace PMEM for Android (with
>> > respect to Gralloc). And it could even be leveraged in DRM framework
>> > (as a primitive memory allocation provider under GEM).
>> >
>> > Anyway, such a module is necessary, because user space application
>> > cannot exchange enough information by a single virtual address (among
>> > different per-process virtual address space). Gstreamer, V4L and any
>> > other middleware could remain using a single virtual address in the
>> > same process. But a global handler/ID is also necessary for sharing
>> > buffers between processes.
>> >
>> > Furthermore, besides those well-known basic features, some advanced
>> > APIs should be provided for application to map the same physical
>> > memory region into another process, with 1) manageable fine
>> > CACHEable/BUFFERable attributes and cache flush mechanism (for
>> > performance); 2) lock/unlock synchronization; 3) swap/migration
>> > ability (optional in current stage, as those buffer are often expected
>> > to stay in RAM for better performance).
>> >
>> > Finally, and the most important, THIS MODULE SHOULD BE PUSHED TO
>> > UPSTREAM (sorry, please ignore all the nonsense I wrote above if we
>> > can achieve this) so that everyone treat it as a de facto well
>> > supported memory management module. Thus all companies could transit
>> > from current private design to this public one. And, let's cheer for
>> > the end of this damn chaos!
>>
>> FWIW, I don't know if a common memory management API is possible.  On
>> the GPU side we tried, but there ended up being too many weird
>> hardware quirks from vendor to vendor (types of memory addressable,
>> strange tiling formats, etc.).  You might be able to come up with some
>> kind of basic framework like TTM, but by the time you add the
>> necessary quirks for various hw, it may be bigger than you want.
>> That's why we have GEM and TTM and driver specific memory management
>> ioctls in the drm.
>
> I agree that we might not be able to use the same memory buffers for all
> devices, as they all have more or less complex requirements regarding the
> memory properties (type, alignment, ...). However, having a common API to pass
> buffers around between drivers and applications using a common ID would be
> highly interesting. I'm not sure how complex that would be, I might not have
> all the nasty small details in mind.

On the userspace side, we pass buffers around using the DRI protocol.
Buffers are passed as handles, and the protocol is generic, however
all of the relevant clients are GPU specific at this point.  That may
change as we work on support for sharing buffers between drivers for
supporting things like hybrid laptops and multi-gpu rendering.

Alex

>
> --
> Regards,
>
> Laurent Pinchart
>
