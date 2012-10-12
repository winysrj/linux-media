Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53702 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756526Ab2JLJbT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Oct 2012 05:31:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	remi@remlab.net, subashrp@gmail.com, mchehab@redhat.com,
	zhangfei.gao@gmail.com, s.nawrocki@samsung.com,
	k.debski@samsung.com
Subject: Re: [PATCHv10 21/26] v4l: vb2-dma-contig: add reference counting for a device from allocator context
Date: Fri, 12 Oct 2012 11:32:02 +0200
Message-ID: <1950799.srnd2WXPED@avalon>
In-Reply-To: <5077B887.4080702@samsung.com>
References: <1349880405-26049-1-git-send-email-t.stanislaws@samsung.com> <1557711.XL0Wq5VHNW@avalon> <5077B887.4080702@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On Friday 12 October 2012 08:28:23 Tomasz Stanislawski wrote:
> On 10/11/2012 11:49 PM, Laurent Pinchart wrote:
> > On Wednesday 10 October 2012 16:46:40 Tomasz Stanislawski wrote:
> >> This patch adds taking reference to the device for MMAP buffers.
> >> 
> >> Such buffers, may be exported using DMABUF mechanism. If the driver that
> >> created a queue is unloaded then the queue is released, the device might
> >> be
> >> released too.  However, buffers cannot be released if they are referenced
> >> by DMABUF descriptor(s). The device pointer kept in a buffer must be
> >> valid for the whole buffer's lifetime. Therefore MMAP buffers should
> >> take a reference to the device to avoid risk of dangling pointers.
> >> 
> >> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> >> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > 
> > But two small comments below.
> > 
> >> ---
> >> 
> >>  drivers/media/v4l2-core/videobuf2-dma-contig.c |    4 ++++
> >>  1 file changed, 4 insertions(+)
> >> 
> >> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> >> b/drivers/media/v4l2-core/videobuf2-dma-contig.c index b138b5c..2d661fd
> >> 100644
> >> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> >> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> >> @@ -148,6 +148,7 @@ static void vb2_dc_put(void *buf_priv)
> >>  		kfree(buf->sgt_base);
> >>  	}
> >>  	dma_free_coherent(buf->dev, buf->size, buf->vaddr, buf->dma_addr);
> >> +	put_device(buf->dev);
> >>  	kfree(buf);
> >>  }
> >> 
> >> @@ -168,6 +169,9 @@ static void *vb2_dc_alloc(void *alloc_ctx, unsigned
> >> long size)
> >>  		return ERR_PTR(-ENOMEM);
> >>  	}
> >> 
> >> +	/* prevent the device from release while the buffer is exported */
> > 
> > s/prevent/Prevent/ ?
> 
> s/release/being released/ ?

Oops. Of course :-)

> >> +	get_device(dev);
> >> +
> >>  	buf->dev = dev;
> > 
> > What about just
> > 
> > 	buf->dev = get_device(dev);
> 
> Right, sorry I missed that from your previous review :).

-- 
Regards,

Laurent Pinchart

