Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:57444 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301Ab1F0QJr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2011 12:09:47 -0400
Received: from eu_spt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LNG00E78I8AAA@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 27 Jun 2011 17:09:46 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LNG009KBI889M@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 27 Jun 2011 17:09:45 +0100 (BST)
Date: Mon, 27 Jun 2011 18:09:41 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [RFC] vb2: Push buffer allocation and freeing into drivers
In-reply-to: <20110624141927.1c89a033@bike.lwn.net>
To: 'Jonathan Corbet' <corbet@lwn.net>,
	'Pawel Osciak' <pawel@osciak.com>,
	'Hans Verkuil' <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	'Mauro Carvalho Chehab' <mchehab@infradead.org>,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	g.liakhovetski@gmx.de, Sylwester Nawrocki <s.nawrocki@samsung.com>,
	'Kamil Debski' <k.debski@samsung.com>
Message-id: <001901cc34e4$9f348970$dd9d9c50$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <20110624141927.1c89a033@bike.lwn.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On Friday, June 24, 2011 10:19 PM Jonathan Corbet wrote:

> Here's a little something I decided to hack on rather than addressing all
> the real work I have to do.
> 
> Videobuf2 currently manages buffer allocation for drivers, even though
> drivers typically encapsulate the vb2_buffer instance in a larger
> structure; that requires vb2 to know the driver's structure size and
> imposes a fragile "the vb2_buffer field must be first" requirement.
> 
> This patch pushes buffer allocation and freeing down into the drivers,
> which is where the real knowledge of the structure layout exists.  To that
> end, buffer_init() has been renamed buffer_alloc(), and it is called at
> the beginning of the process.  As it happens, no in-tree driver depends on
> any kind of central initialization in its buffer_init() function, so this
> move causes no problems.
> 
> The patch deletes almost as much code as it adds; in particular, error
> handling gets simpler.  It's compile-tested on everything I could, and run
> tested with vivi and mmp-camera.  The patch is against linuxtv/for_v3.1,
> so it doesn't include the mmp-camera hunks (since videobuf2 support for
> that driver isn't upstream yet.)

Thanks for your work! I really appreciate your effort for making the kernel
code better. :) However I would like to get some more comments before making
the final decision.

The main difference between buffer_init() and buffer_alloc() is the fact
that buffer_init() is called when the buffer has all internal data filled in
(like for example index) and, what is more important, memory buffers for all
planes are already allocated. This feature is used by the s5p-mfc driver 
(video codec driver for IP found on Samsung S5PC110 and Exynos4 SoC series,
not yet merged to mainline) to gather all information for the dma engine. 
The dma engine contains some kind of array for fixed number of buffer 
addresses, which can be programmed only once before starting to process 
encoding or decoding.

I considered similar solution during videobuf2 development, but decided
that having access to all information about buffer internals (index, plane
addresses) is something that might be really useful for device drivers.

Creating additional buffer_alloc() and buffer_free() callbacks (and keeping
buffer_init and buffer_cleanup) just to make the code nicer was already 
pointed to be just an over-engineering.
 
Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



