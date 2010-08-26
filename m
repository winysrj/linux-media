Return-path: <mchehab@pedra>
Received: from bombadil.infradead.org ([18.85.46.34]:44366 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab0HZIRj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Aug 2010 04:17:39 -0400
Subject: Re: [PATCH/RFCv4 0/6] The Contiguous Memory Allocator framework
From: Peter Zijlstra <peterz@infradead.org>
To: =?UTF-8?Q?Micha=C5=82?= Nazarewicz <m.nazarewicz@samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Daniel Walker <dwalker@codeaurora.org>,
	Russell King <linux@arm.linux.org.uk>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Mel Gorman <mel@csn.ul.ie>,
	Pawel Osciak <p.osciak@samsung.com>,
	Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
	linux-mm@kvack.org, Kyungmin Park <kyungmin.park@samsung.com>,
	Zach Pfeffer <zpfeffer@codeaurora.org>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <op.vh0ud3rg7p4s8u@localhost>
References: <cover.1282286941.git.m.nazarewicz@samsung.com>
	 <1282310110.2605.976.camel@laptop>  <op.vh0ud3rg7p4s8u@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 26 Aug 2010 10:17:07 +0200
Message-ID: <1282810627.1975.237.camel@laptop>
Mime-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Thu, 2010-08-26 at 03:28 +0200, Michał Nazarewicz wrote:
> On Fri, 20 Aug 2010 15:15:10 +0200, Peter Zijlstra <peterz@infradead.org> wrote:
> > So the idea is to grab a large chunk of memory at boot time and then
> > later allow some device to use it?
> >
> > I'd much rather we'd improve the regular page allocator to be smarter
> > about this. We recently added a lot of smarts to it like memory
> > compaction, which allows large gobs of contiguous memory to be freed for
> > things like huge pages.
> >
> > If you want guarantees you can free stuff, why not add constraints to
> > the page allocation type and only allow MIGRATE_MOVABLE pages inside a
> > certain region, those pages are easily freed/moved aside to satisfy
> > large contiguous allocations.
> 
> I'm aware that grabbing a large chunk at boot time is a bit of waste of
> space and because of it I'm hoping to came up with a way of reusing the
> space when it's not used by CMA-aware devices.  My current idea was to
> use it for easily discardable data (page cache?). 

Right, so to me that looks like going at the problem backwards. That
will complicate the page-cache instead of your bad hardware drivers
(really, hardware should use IOMMUs already).

So why not work on the page allocator to improve its contiguous
allocation behaviour. If you look at the thing you'll find pageblocks
and migration types. If you change it so that you pin the migration type
of one or a number of contiguous pageblocks to say MIGRATE_MOVABLE, so
that they cannot be used for anything but movable pages you're pretty
much there.


