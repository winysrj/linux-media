Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:49481 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666Ab1F0Qjq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2011 12:39:46 -0400
Date: Mon, 27 Jun 2011 10:39:44 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: 'Pawel Osciak' <pawel@osciak.com>,
	'Hans Verkuil' <hverkuil@xs4all.nl>,
	linux-media@vger.kernel.org,
	'Mauro Carvalho Chehab' <mchehab@infradead.org>,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	g.liakhovetski@gmx.de, Sylwester Nawrocki <s.nawrocki@samsung.com>,
	'Kamil Debski' <k.debski@samsung.com>
Subject: Re: [RFC] vb2: Push buffer allocation and freeing into drivers
Message-ID: <20110627103944.504bd2a9@bike.lwn.net>
In-Reply-To: <001901cc34e4$9f348970$dd9d9c50$%szyprowski@samsung.com>
References: <20110624141927.1c89a033@bike.lwn.net>
	<001901cc34e4$9f348970$dd9d9c50$%szyprowski@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 27 Jun 2011 18:09:41 +0200
Marek Szyprowski <m.szyprowski@samsung.com> wrote:

> Thanks for your work! I really appreciate your effort for making the kernel
> code better. :) However I would like to get some more comments before making
> the final decision.

That's fine - it *was* an RFC, after all...:)

> The main difference between buffer_init() and buffer_alloc() is the fact
> that buffer_init() is called when the buffer has all internal data filled in
> (like for example index) and, what is more important, memory buffers for all
> planes are already allocated.

I had thought that might be the case, but none of the in-tree drivers
needed that information.  Obviously, I don't want to break other stuff
which is coming (that driver *is* headed for mainline, right? :), so the
idea of simply repurposing buf_init() won't quite work.  Too bad, moving
it took out a lot of error-handling code.

Could this more involved initialization code move to buf_prepare(),
perhaps with a flag in the buffer for stuff that only has to happen once?
Or maybe there could be a highly optional buf_map() (or some such) for
this kind of special-case driver?  

> I considered similar solution during videobuf2 development, but decided
> that having access to all information about buffer internals (index, plane
> addresses) is something that might be really useful for device drivers.

I guess the question is: is it sufficiently useful to enough drivers to
create a separate callback for?  I'm not convinced...but I could certainly
be wrong about that.

> Creating additional buffer_alloc() and buffer_free() callbacks (and keeping
> buffer_init and buffer_cleanup) just to make the code nicer was already 
> pointed to be just an over-engineering.

I don't think there's a need for a buf_free(), given that buf_cleanup() is
already there.  But I really dislike the "vb2_buffer must be the first
structure field" requirement; it's fragile in the long term.  The kernel
has usually gone out of its way to avoid adding that kind of hidden
constraint.

Oh, well.  I'd like to see the change merged, I think it makes things a
little better.  But I've said my piece now and don't intend to argue it
further - I'll keep using vb2 either way :)

Thanks,

jon
