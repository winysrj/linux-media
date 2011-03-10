Return-path: <mchehab@pedra>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40991 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab1CJOm4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2011 09:42:56 -0500
Date: Thu, 10 Mar 2011 14:42:38 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: 'Hans Verkuil' <hverkuil@xs4all.nl>, linaro-dev@lists.linaro.org,
	linux-media@vger.kernel.org,
	'Jonghun Han' <jonghun.han@samsung.com>,
	kyungmin.park@samsung.com
Subject: Re: Yet another memory provider: can linaro organize a meeting?
Message-ID: <20110310144238.GF11273@n2100.arm.linux.org.uk>
References: <201103080913.59231.hverkuil@xs4all.nl> <000001cbdf2d$7070bcb0$51523610$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001cbdf2d$7070bcb0$51523610$%szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Mar 10, 2011 at 03:14:11PM +0100, Marek Szyprowski wrote:
> Hello,
> 
> On Tuesday, March 08, 2011 9:14 AM Hans Verkuil wrote:
> 
> > We had a discussion yesterday regarding ways in which linaro can assist
> > V4L2 development. One topic was that of sorting out memory providers like
> > GEM and HWMEM.
> > 
> > Today I learned of yet another one: UMP from ARM.
> > 
> > http://blogs.arm.com/multimedia/249-making-the-mali-gpu-device-driver-open-
> > source/page__cid__133__show__newcomment/
> 
> I really wonder what's the opinion of ARM Linux maintainer on this memory
> allocator. Russell - could you comment on it?

First I've heard about it.  I'll have to do some reading first, but I'm
rather busy at the present time.

As far as DMA memory allocation goes, I do have that patch laying around
which preallocates the DMA coherent and writecombine memory, but inspite
of sending it to the mailing list, there was very little in the way of
feedback.

Someone was going to go through the various platforms and work out which
could be reduced down to 1MB coherent/1MB writecombine, but I never saw
any follow-up to that.

I've been debating about just throwing it in the kernel for this coming
merge window anyway - I suspect most people just don't care how DMA
memory is provided, so long as it works and works reliably.
