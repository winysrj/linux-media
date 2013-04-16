Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42110 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935596Ab3DPKU7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Apr 2013 06:20:59 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Seung-Woo Kim <sw0312.kim@samsung.com>,
	linux-media@vger.kernel.org, mchehab@redhat.com, pawel@osciak.com,
	kyungmin.park@samsung.com
Subject: Re: [PATCH] media: vb2: add length check for mmap
Date: Tue, 16 Apr 2013 12:21:03 +0200
Message-ID: <2026241.unRvqS1xV0@avalon>
In-Reply-To: <5167A3A3.5090200@samsung.com>
References: <1365739077-8740-1-git-send-email-sw0312.kim@samsung.com> <5167A3A3.5090200@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 12 April 2013 08:03:15 Marek Szyprowski wrote:
> On 4/12/2013 5:57 AM, Seung-Woo Kim wrote:
> > The length of mmap() can be bigger than length of vb2 buffer, so
> > it should be checked.
> > 
> > Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
> 
> Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

This should be pushed to the stable kernels, as it's a potential security 
issue.

> > ---
> > 
> >   drivers/media/v4l2-core/videobuf2-core.c |    5 +++++
> >   1 files changed, 5 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/media/v4l2-core/videobuf2-core.c
> > b/drivers/media/v4l2-core/videobuf2-core.c index db1235d..2c6ff2d 100644
> > --- a/drivers/media/v4l2-core/videobuf2-core.c
> > +++ b/drivers/media/v4l2-core/videobuf2-core.c
> > @@ -1886,6 +1886,11 @@ int vb2_mmap(struct vb2_queue *q, struct
> > vm_area_struct *vma)> 
> >   	vb = q->bufs[buffer];
> > 
> > +	if (vb->v4l2_planes[plane].length < (vma->vm_end - vma->vm_start)) {
> > +		dprintk(1, "Invalid length\n");
> > +		return -EINVAL;
> > +	}
> > +
> > 
> >   	ret = call_memop(q, mmap, vb->planes[plane].mem_priv, vma);
> >   	if (ret)
> >   	
> >   		return ret;

-- 
Regards,

Laurent Pinchart

