Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:58603 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab1KXMBY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 07:01:24 -0500
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LV5006ARYQAVJ@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 Nov 2011 12:01:22 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LV500B0WYQAUF@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 Nov 2011 12:01:22 +0000 (GMT)
Date: Thu, 24 Nov 2011 13:00:10 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH] media: vb2: fix queueing of userptr buffers with null
 buffer pointer
In-reply-to: <201111241226.31762.laurent.pinchart@ideasonboard.com>
To: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Pawel Osciak' <pawel@osciak.com>
Message-id: <023401ccaaa0$9e1ece10$da5c6a30$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <1321471348-11567-1-git-send-email-m.szyprowski@samsung.com>
 <201111241226.31762.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Thursday, November 24, 2011 12:27 PM Laurent Pinchart wrote:

> On Wednesday 16 November 2011 20:22:28 Marek Szyprowski wrote:
> > Heuristic that checks if the memory pointer has been changed lacked a check
> > if the pointer was actually provided by the userspace, what allowed one to
> > queue a NULL pointer which was accepted without further checking.
> 
> Is that an issue ? If the pointer is NULL get_user_pages() will fail, won't it
> ?

get_user_pages() fails correctly on NULL pointer, but this patch about something
else. VB2 heuristically checks if the user ptr has been changed compared to previous
call to QBUF - if so, it releases old buffer and tries to grab a new one with new
user ptr value.

This heuristic failed if user queued NULL user ptr as a first buffer. All the buffer
internal structures are zeroed on init, so the comparison of NULL pointer with 
initial zero value was true. VB2 incorrectly assumed that it can reuse the pointer
from the previous QBUF call what caused a kernel ops a few lines later.

> 
> > This patch fixes this issue.
> >
> > Reported-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > CC: Pawel Osciak <pawel@osciak.com>
> > ---
> >  drivers/media/video/videobuf2-core.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/media/video/videobuf2-core.c
> > b/drivers/media/video/videobuf2-core.c index ec49fed..24f11ae 100644
> > --- a/drivers/media/video/videobuf2-core.c
> > +++ b/drivers/media/video/videobuf2-core.c
> > @@ -765,7 +765,8 @@ static int __qbuf_userptr(struct vb2_buffer *vb, struct
> > v4l2_buffer *b)
> >
> >  	for (plane = 0; plane < vb->num_planes; ++plane) {
> >  		/* Skip the plane if already verified */
> > -		if (vb->v4l2_planes[plane].m.userptr == planes[plane].m.userptr
> > +		if (vb->v4l2_planes[plane].m.userptr &&
> > +		    vb->v4l2_planes[plane].m.userptr == planes[plane].m.userptr
> >  		    && vb->v4l2_planes[plane].length == planes[plane].length)
> >  			continue;
> 
> --
> Regards,
> 
> Laurent Pinchart


Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



