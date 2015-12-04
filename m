Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:54910 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659AbbLDXCA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Dec 2015 18:02:00 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] vivid: Add support for the dma-contig memory allocator
Date: Sat, 05 Dec 2015 01:02:11 +0200
Message-ID: <1755984.kluJNdl6XT@avalon>
In-Reply-To: <6E4D785C-6536-400C-8665-DC42B97E9265@xs4all.nl>
References: <1449266748-22317-1-git-send-email-laurent.pinchart@ideasonboard.com> <6E4D785C-6536-400C-8665-DC42B97E9265@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Friday 04 December 2015 23:50:31 Hans Verkuil wrote:
> On December 4, 2015 11:05:48 PM GMT+01:00, Laurent Pinchart wrote:
> > To test buffer sharing with devices that require contiguous memory
> > buffers the dma-contig allocator is required. Support it and make the
> > allocator selectable through a module parameter. Support for the two
> > memory allocators can also be individually selected at compile-time to
> > avoid bloating the kernel with an unneeded allocator.
> >
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >---
> >
> > drivers/media/platform/vivid/Kconfig         | 21 ++++++++++++-
> > drivers/media/platform/vivid/vivid-core.c    | 44 ++++++++++++++++++++----
> > drivers/media/platform/vivid/vivid-core.h    |  1 +
> > drivers/media/platform/vivid/vivid-sdr-cap.c |  3 ++
> > drivers/media/platform/vivid/vivid-vbi-cap.c |  2 ++
> > drivers/media/platform/vivid/vivid-vbi-out.c |  1 +
> > drivers/media/platform/vivid/vivid-vid-cap.c |  9 ++----
> > drivers/media/platform/vivid/vivid-vid-out.c |  9 ++----
> > 8 files changed, 72 insertions(+), 18 deletions(-)

[snip]

> Apologies for top posting, I'm sending this from my Android phone.

No need to, your message was at the bottom :-)

> Laurent, did you test this on a regular pc? I've tried this before, but
> failed since I couldn't make it work on a pc. I didn't spend a huge amount
> of time on it, though.
> 
> Just want to make sure that this case is covered.

I haven't tested that, no. Let's see who from you or me will find free time 
first (hint: it might be you :-)).

-- 
Regards,

Laurent Pinchart

