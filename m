Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36855 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755402Ab2KHMSr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Nov 2012 07:18:47 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org, Pawel Osciak <pawel@osciak.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 27/26] v4l: vb2: Set data_offset to 0 for single-plane buffers
Date: Thu, 08 Nov 2012 13:19:40 +0100
Message-ID: <5434150.xFoZpmKjxA@avalon>
In-Reply-To: <509BA1FE.9010301@samsung.com>
References: <1349880405-26049-1-git-send-email-t.stanislaws@samsung.com> <1352376336-5404-1-git-send-email-laurent.pinchart@ideasonboard.com> <509BA1FE.9010301@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Thursday 08 November 2012 13:13:50 Marek Szyprowski wrote:
> On 11/8/2012 1:05 PM, Laurent Pinchart wrote:
> > Single-planar V4L2 buffers are converted to multi-planar vb2 buffers
> > with a single plane when queued. The plane data_offset field is not
> > available in the single-planar API and must be set to 0 for dmabuf
> > buffers and all output buffers.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

Thank you.

Tomasz, could you please take this in your dma-buf branch ? Sorry for 
forgetting to CC you on the patch.

> > ---
> > 
> >   drivers/media/v4l2-core/videobuf2-core.c |    2 ++
> >   1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/media/v4l2-core/videobuf2-core.c
> > b/drivers/media/v4l2-core/videobuf2-core.c index b0402f2..3eae3d8 100644
> > --- a/drivers/media/v4l2-core/videobuf2-core.c
> > +++ b/drivers/media/v4l2-core/videobuf2-core.c
> > @@ -931,6 +931,7 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb,
> > const struct v4l2_buffer *b,> 
> >   		 */
> >   		
> >   		if (V4L2_TYPE_IS_OUTPUT(b->type))
> >   		
> >   			v4l2_planes[0].bytesused = b->bytesused;
> > 
> > +			v4l2_planes[0].data_offset = 0;
> > 
> >   		if (b->memory == V4L2_MEMORY_USERPTR) {
> >   		
> >   			v4l2_planes[0].m.userptr = b->m.userptr;
> > 
> > @@ -940,6 +941,7 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb,
> > const struct v4l2_buffer *b,> 
> >   		if (b->memory == V4L2_MEMORY_DMABUF) {
> >   		
> >   			v4l2_planes[0].m.fd = b->m.fd;
> >   			v4l2_planes[0].length = b->length;
> > 
> > +			v4l2_planes[0].data_offset = 0;
> > 
> >   		}
> >   	
> >   	}

-- 
Regards,

Laurent Pinchart

