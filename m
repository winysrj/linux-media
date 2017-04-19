Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:39380 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1762713AbdDSMuV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Apr 2017 08:50:21 -0400
Date: Wed, 19 Apr 2017 13:50:17 +0100
From: Brian Starkey <brian.starkey@arm.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        liviu.dudau@arm.com, laurent.pinchart@ideasonboard.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 1/6] drm: Add writeback connector type
Message-ID: <20170419125017.GB6314@e106950-lin.cambridge.arm.com>
References: <1480092544-1725-1-git-send-email-brian.starkey@arm.com>
 <1480092544-1725-2-git-send-email-brian.starkey@arm.com>
 <20170414120823.2cafc748@bbrezillon>
 <20170418173443.GA325@e106950-lin.cambridge.arm.com>
 <20170418215717.4381dd6e@bbrezillon>
 <20170419095122.GA6314@e106950-lin.cambridge.arm.com>
 <20170419133434.229593a1@bbrezillon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20170419133434.229593a1@bbrezillon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 19, 2017 at 01:34:34PM +0200, Boris Brezillon wrote:
>On Wed, 19 Apr 2017 10:51:23 +0100
>Brian Starkey <brian.starkey@arm.com> wrote:

[snip]

>> Could you expand a bit on how you think planes fit better?
>
>Just had the impression that the writeback feature was conceptually
>closer to a plane object (which is attached buffers and expose ways to
>specify which portion of the buffer should be used, provides way to
>atomically switch 2 buffers, ...).

Yeah sort-of, except that SRC_X/Y/W/H doesn't mean the same for an
"output" plane as an "input" plane (and CRTC_X/Y/W/H similarly,
probably other properties too).

In atomic land, the swapping of buffers is really just the swapping of
object IDs via properties - I don't think planes actually have
anything special in terms of buffer handling, except for all the
legacy state handling cruft.

>
>> It is
>> something we've previously talked about internally, but so far I'm not
>> convinced :-)
>
>Okay, as I said, I don't know all the history, hence my questions ;-).
>

I think that history was here in our office rather than on the list
anyway.

>>
>> >By doing that, we would also get rid of these fake connector/encoder
>> >objects as well as the fake modes we are returning in
>> >connector->get_modes().
>>
>> What makes the connector/encoder fake? They represent a real piece of
>> hardware just the same as a drm_plane would.
>
>Well, that's probably subject to interpretation, but I don't consider
>these writeback encoders/connectors as real encoders/connectors. They
>are definitely real HW blocks, but not what we usually consider as an
>encoder/connector.
>

This is true

>>
>> I don't mind dropping the mode list and letting userspace just make
>> up whatever timing it wants - it'd need to do the same if writeback
>> was a plane - but in some respects giving it a list of modes the same
>> way we normally do seems nicer for userspace.
>>
>> >
>> >As far as I can tell, the VC4 and Atmel HLCDC IP should fit pretty well
>> >in this model, not sure about the mali-dp though.
>> >
>> >Brian, did you consider this approach, and if you did, can you detail
>> >why you decided to expose this feature as a connector?
>> >
>> >Daniel (or anyone else), please step in if you think this is a stupid
>> >idea :-).
>>
>> Ville originally suggested using a connector, which Eric followed up
>> by saying that's what he was thinking of for VC4 writeback too[1].
>
>Thanks for the pointer.
>
>> That was my initial reason for focussing on a connector-based
>> approach.
>>
>> I prefer connector over plane conceptually because it keeps with the
>> established data flow: planes are sources, connectors are sinks.
>
>Okay, it's a valid point.
>
>>
>> In some respects the plane _object_ looks like it would fit - it has a
>> pixel format list and an FB_ID. But everything else would be acting
>> the exact opposite to a normal plane, and I think there's a bunch of
>> baked-in assumptions in the kernel and userspace around CRTCs always
>> having at least one connector.
>
>Yep, but writeback connectors are already different enough to not be
>considered as regular connectors, so userspace programs will have to
>handle them differently anyway (pass a framebuffer and pixel format to
>it before adding them to the display pipeline).
>
>Anyway, I see this approach has already been suggested in [1], and you
>all agreed that the writeback feature should be exposed as a connector,
>so I'll just stop here :-).
>
>Thanks for taking the time to explain the rationale behind this
>decision.
>

No problem, now is the right time to be discussing the decision before
we merge something wrong.

Are you happy enough with the connector approach then? Any concerns
with going ahead with it?

Cheers,
-Brian
