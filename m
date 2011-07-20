Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:46023 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726Ab1GTEQp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2011 00:16:45 -0400
Received: by qyk9 with SMTP id 9so2793676qyk.19
        for <linux-media@vger.kernel.org>; Tue, 19 Jul 2011 21:16:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110627103944.504bd2a9@bike.lwn.net>
References: <20110624141927.1c89a033@bike.lwn.net> <001901cc34e4$9f348970$dd9d9c50$%szyprowski@samsung.com>
 <20110627103944.504bd2a9@bike.lwn.net>
From: Pawel Osciak <pawel@osciak.com>
Date: Tue, 19 Jul 2011 21:16:24 -0700
Message-ID: <CAMm-=zCqyBwGMuNk-m5m=6px6j9q7_noGKPAz+bU36mJEuZEuQ@mail.gmail.com>
Subject: Re: [RFC] vb2: Push buffer allocation and freeing into drivers
To: Jonathan Corbet <corbet@lwn.net>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	g.liakhovetski@gmx.de, Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jon,
Thanks for your patch. I agree I'm not particularly proud of how
allocation looks like right now and of the "first structure field"
requirement. I had similar design dilemmas, but have to agree with
Marek here though. Please see my explanation below.

On Mon, Jun 27, 2011 at 09:39, Jonathan Corbet <corbet@lwn.net> wrote:
> On Mon, 27 Jun 2011 18:09:41 +0200
> Marek Szyprowski <m.szyprowski@samsung.com> wrote:
>
>> Thanks for your work! I really appreciate your effort for making the kernel
>> code better. :) However I would like to get some more comments before making
>> the final decision.
>
> That's fine - it *was* an RFC, after all...:)
>
>> The main difference between buffer_init() and buffer_alloc() is the fact
>> that buffer_init() is called when the buffer has all internal data filled in
>> (like for example index) and, what is more important, memory buffers for all
>> planes are already allocated.
>
> I had thought that might be the case, but none of the in-tree drivers
> needed that information.  Obviously, I don't want to break other stuff
> which is coming (that driver *is* headed for mainline, right? :), so the
> idea of simply repurposing buf_init() won't quite work.  Too bad, moving
> it took out a lot of error-handling code.
>

One thing that I think wasn't mentioned was that you did remove
buf_init call from __qbuf_userptr(), which removes some functionality
and symmetry. In USERPTR case we still want to call buf_init(), as
it's used to perform operations that are to be done once per buffer,
after it is ready. There is no allocation in USERPTR's case though. So
it's not as much a feature for particular drivers, but to accommodate
USERPTR. For MMAP, we could do those things in buf_alloc().

> Could this more involved initialization code move to buf_prepare(),
> perhaps with a flag in the buffer for stuff that only has to happen once?
> Or maybe there could be a highly optional buf_map() (or some such) for
> this kind of special-case driver?
>

buf_prepare() is called once per frame, so checking for this flag
every frame would add some unpleasant overhead.

>> I considered similar solution during videobuf2 development, but decided
>> that having access to all information about buffer internals (index, plane
>> addresses) is something that might be really useful for device drivers.
>
> I guess the question is: is it sufficiently useful to enough drivers to
> create a separate callback for?  I'm not convinced...but I could certainly
> be wrong about that.
>

You mean buf_init(), right? Well, I aimed for this nice symmetry:
buf_init() - buf_cleanup()
buf_prepare() - buf_finish()

I agree many drivers might not need such fine-grained design, but as
we could find sensible use cases for all of them, all of them were
kept.

>> Creating additional buffer_alloc() and buffer_free() callbacks (and keeping
>> buffer_init and buffer_cleanup) just to make the code nicer was already
>> pointed to be just an over-engineering.
>
> I don't think there's a need for a buf_free(), given that buf_cleanup() is
> already there.  But I really dislike the "vb2_buffer must be the first
> structure field" requirement; it's fragile in the long term.  The kernel
> has usually gone out of its way to avoid adding that kind of hidden
> constraint.
>

As with buf_init() and allocation, you don't always free the memory
when you buf_cleanup(), which happens in USERPTR case.

> Oh, well.  I'd like to see the change merged, I think it makes things a
> little better.  But I've said my piece now and don't intend to argue it
> further - I'll keep using vb2 either way :)
>
> Thanks,
>
> jon
>


-- 
Best regards,
Pawel Osciak
