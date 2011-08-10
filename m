Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:51663 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab1HJJIX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Aug 2011 05:08:23 -0400
Received: from eu_spt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LPP00A04G1Y7B@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 10 Aug 2011 10:08:22 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LPP007HSG1XNK@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 10 Aug 2011 10:08:21 +0100 (BST)
Date: Wed, 10 Aug 2011 11:08:20 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH] media: vb2: add a check if queued userptr buffer is large
 enough
In-reply-to: <201108101045.36681.hansverk@cisco.com>
To: 'Hans Verkuil' <hansverk@cisco.com>
Cc: linux-media@vger.kernel.org,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Pawel Osciak' <pawel@osciak.com>,
	'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	'Marek Szyprowski' <m.szyprowski@samsung.com>
Message-id: <028201cc573d$0cdc5690$269503b0$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <1312964488-2924-1-git-send-email-m.szyprowski@samsung.com>
 <201108101045.36681.hansverk@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Wednesday, August 10, 2011 10:46 AM Hans Verkuil wrote:

> Just one comment:
> 
> On Wednesday, August 10, 2011 10:21:28 Marek Szyprowski wrote:
> > Videobuf2 accepted any userptr buffer without verifying if its size is
> > large enough to store the video data from the driver. The driver reports
> > the minimal size of video data once in queue_setup and expects that
> > videobuf2 provides buffers that match these requirements. This patch
> > adds the required check.
> >
> > Reported-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > CC: Pawel Osciak <pawel@osciak.com>
> > ---
> >  drivers/media/video/videobuf2-core.c |   41
> +++++++++++++++++++--------------
> >  include/media/videobuf2-core.h       |    1 +
> >  2 files changed, 25 insertions(+), 17 deletions(-)
> >
> 
> <snip>
> 
> > diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> > index f87472a..496d6e5 100644
> > --- a/include/media/videobuf2-core.h
> > +++ b/include/media/videobuf2-core.h
> > @@ -276,6 +276,7 @@ struct vb2_queue {
> >  	wait_queue_head_t		done_wq;
> >
> >  	void				*alloc_ctx[VIDEO_MAX_PLANES];
> > +	unsigned long			plane_sizes[VIDEO_MAX_PLANES];
> 
> Why unsigned long when it is a u32 in struct v4l2_plane_pix_format?
> 
> unsigned long is 64 bit on a 64-bit OS, so that seems wasteful to me.

u32 type should be used in places where the exact size really matters,
like strictly defined io structures passed to userspace or structures that
are used for accessing hardware registers directly. For all other cases,
like temporary storage of some values, the cpu native types should be used.
Looks at the whole vb2 code - u32 type is not used in any single place.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center

