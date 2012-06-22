Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:32866 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761702Ab2FVIuP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jun 2012 04:50:15 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	linux-media@vger.kernel.org,
	Federico Vaga <federico.vaga@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: Recent patch for videobuf causing a crash to my driver
Date: Fri, 22 Jun 2012 10:50:23 +0200
Message-ID: <2147318.3kAzv4eQOG@avalon>
In-Reply-To: <4FE423D4.9010609@xs4all.nl>
References: <CA+V-a8uDgmiy52wEs0rR5B08aAmSk=Wyf+e3mMzazeGykdMA4w@mail.gmail.com> <4FE423D4.9010609@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Friday 22 June 2012 09:50:44 Hans Verkuil wrote:
> On 22/06/12 05:39, Prabhakar Lad wrote:
> > Hi Federico,
> > 
> > Recent patch from you (commit id a8f3c203e19b702fa5e8e83a9b6fb3c5a6d1cce4)
> > which added cached buffer support to videobuf dma contig, is causing my
> > driver to crash.
> > Has this patch being tested for 'uncached' buffers ? If I replace this
> > mapping logic with remap_pfn_range() my driver works without any crash.
> > 
> > Or is that I am missing somewhere ?
> 
> No, I had the same problem this week with vpif_capture. Since I was running
> an unusual setup (a 3.0 kernel with the media subsystem patched to 3.5-rc1)
> I didn't know whether it was caused by a mismatch between 3.0 and a 3.5
> media subsystem.
> 
> I intended to investigate this next week, but now it is clear that it is
> this patch that is causing the problem.

Time to port the driver to videobuf2 ? ;-)

-- 
Regards,

Laurent Pinchart

