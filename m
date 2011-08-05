Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:45012 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623Ab1HEQPS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Aug 2011 12:15:18 -0400
Received: by qyk34 with SMTP id 34so480768qyk.19
        for <linux-media@vger.kernel.org>; Fri, 05 Aug 2011 09:15:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMm-=zBQePQpaFZ2t7sfu8_u2V0BxLXgCZrQZt8dK8jHePSoow@mail.gmail.com>
References: <201108051055.08641.laurent.pinchart@ideasonboard.com> <CAMm-=zBQePQpaFZ2t7sfu8_u2V0BxLXgCZrQZt8dK8jHePSoow@mail.gmail.com>
From: Pawel Osciak <pawel@osciak.com>
Date: Fri, 5 Aug 2011 09:14:57 -0700
Message-ID: <CAMm-=zAm_u5AtZmrkhFA8dEcq0oYut5tMRQ_y0vTL6Lsn5Pusg@mail.gmail.com>
Subject: Re: Possible issue in videobuf2 with buffer length check at QBUF time
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry, just realized I mixed up callback names a bit in my previous
response. Let me rephrase:

Drivers may allow changing formats after buffers have been
initialized. This means that it's possible to s_fmt, reqbufs,
streamon, streamoff and s_fmt again without changing buffers. buf_init
will still be called for USERPTR though, even if the same buffers are
used after resume. So enforcing buf_init will always work.

If buf_init were not to be required for USERPTR, we'd need the drivers
to report change of minimum buffer (planes) size asynchronously to vb2
from the driver. And get them on alloc from the driver on queue_setup.
So the two options I described in my first response are still
standing, although I made a typo there, saying I'd prefer the second
solution, I obviously meant the first one, i.e. enforcing buf_init().
Sorry.

One additional detail to the second proposal below: if we were to have
the new callback, it could only be allowed when not streaming.
Otherwise we'd have to forcibly dequeue buffers if they became too
small and this would be confusing for applications.

Pawel


On Fri, Aug 5, 2011 at 08:01, Pawel Osciak <pawel@osciak.com> wrote:
> Hi Laurent,
>
> On Fri, Aug 5, 2011 at 01:55, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
>> Hi Marek and Pawel,
>>
>> While reviewing an OMAP3 ISP patch, I noticed that videobuf2 doesn't verify
>> the buffer length field value when a new USERPTR buffer is queued.
>>
>
> That's a good catch. We should definitely do something about it.
>
>> The length given by userspace is copied to the internal buffer length field.
>> It seems to be up to drivers to verify that the value is equal to or higher
>> than the minimum required to store the image, but that's not clearly
>> documented. Should the buf_init operation be made mandatory for drivers that
>> support USERPTR, and documented as required to implement a length check ?
>>
>
> Technically, drivers can do the length checks on buf_prepare if they
> don't allow format changes after REQBUFS. On the other hand though, if
> a driver supports USERPTR, the buffers queued from userspace have to
> be verified on qbuf and the only place to do that would be buf_init.
> So every driver that supports USERPTR would have to implement
> buf_init, as you said.
>
>> Alternatively the check could be performed in videobuf2-core, which would
>> probably make sense as the check is required. videobuf2 doesn't store the
>> minimum size for USERPTR buffers though (but that can of course be changed).
>>
>
> Let's say we make vb2 save minimum buffer size. This would have to be
> done on queue_setup I imagine. We could add a new field to vb2_buffer
> for that. One problem is that if the driver actually supports changing
> format after REQBUFS, we would need a new function in vb2 to change
> minimum buffer size. Actually, this has to be minimum plane sizes. So
> the alternatives are:
>
> 1. Make buf_init required for drivers that support USERPTR; or
> 2. Add minimum plane sizes to vb2_buffer,add a new return array
> argument to queue_setup to return minimum plane sizes that would be
> stored in vb2. Make vb2 verify sizes on qbuf of USERPTR. Add a new vb2
> function for drivers to call when minimum sizes have to be changed.
>
> The first solution is way simpler for drivers that require this. The
> second solution is maybe a bit simpler for drivers that do not, as
> they would only have to return the sizes in queue_setup, but
> implementing buf_init instead wouldn't be a big of a difference I
> think. So I'm leaning towards the second solution.
> Any comments, did I miss something?
