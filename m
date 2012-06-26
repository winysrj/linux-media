Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36369 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928Ab2FZJLK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jun 2012 05:11:10 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: Dima Zavin <dmitriyz@google.com>, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, airlied@redhat.com,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	sumit.semwal@ti.com, daeinki@gmail.com, daniel.vetter@ffwll.ch,
	robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	remi@remlab.net, subashrp@gmail.com, mchehab@redhat.com,
	g.liakhovetski@gmx.de, Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [PATCHv7 03/15] v4l: vb2: add support for shared buffer (dma_buf)
Date: Tue, 26 Jun 2012 11:11:06 +0200
Message-ID: <3296650.k6kvMQSQ7k@avalon>
In-Reply-To: <4FE9758C.7030008@samsung.com>
References: <1339681069-8483-1-git-send-email-t.stanislaws@samsung.com> <20120620061216.GA19245@google.com> <4FE9758C.7030008@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dima and Tomasz,

Sorry for the late reply.

On Tuesday 26 June 2012 10:40:44 Tomasz Stanislawski wrote:
> Hi Dima Zavin,
> Thank you for the patch and for a ping remainder :).
> 
> You are right. The unmap is missing in __vb2_queue_cancel.
> I will apply your fix into next version of V4L2 support for dmabuf.
> 
> Please refer to some comments below.
> 
> On 06/20/2012 08:12 AM, Dima Zavin wrote:
> > Tomasz,
> > 
> > I've encountered an issue with this patch when userspace does several
> > stream_on/stream_off cycles. When the user tries to qbuf a buffer
> > after doing stream_off, we trigger the "dmabuf already pinned" warning
> > since we didn't unmap the buffer as dqbuf was never called.
> > 
> > The below patch adds calls to unmap in queue_cancel, but my feeling is
> > that we probably should be calling detach too (i.e. put_dmabuf).

According to the V4L2 specification, the "VIDIOC_STREAMOFF ioctl, apart of 
aborting or finishing any DMA in progress, unlocks any user pointer buffers 
locked in physical memory, and it removes all buffers from the incoming and 
outgoing queues".

Detaching the buffer is thus not strictly required. At first thought I agreed 
with you, as not deatching the buffer might keep resources allocated for much 
longer than needed. For instance, an application that stops the stream and 
expects to resume it later will usually not free the buffers (with 
VIDIOC_REQBUFS(0)) between VIDIOC_STREAMOFF and VIDIOC_STREAMON. Buffer will 
thus be referenced for longer than needed.

However, to reuse the same buffer after restarting the stream, the application 
will need to keep the dmabuf fds around in order to queue them. Detaching the 
buffer will thus bring little benefit in terms of resource usage, as the open 
file handles will keep the buffer around anyway. If an application cares about 
that and closes all dmabuf fds after stopping the stream, I expect it to free 
the buffers as well.

I don't have a very strong opinion about this, if you would rather detach the 
buffer at stream-off time I'm fine with that.

> > Thoughts?
> > 
> > --Dima
> > 
> > Subject: [PATCH] v4l: vb2: unmap dmabufs on STREAM_OFF event
> > 
> > Currently, if the user issues a STREAM_OFF request and then
> > tries to re-enqueue buffers, it will trigger a warning in
> > the vb2 allocators as the buffer would still be mapped
> > from before STREAM_OFF was called. The current expectation
> > is that buffers will be unmapped in dqbuf, but that will never
> > be called on the mapped buffers after a STREAM_OFF event.
> > 
> > Cc: Sumit Semwal <sumit.semwal@ti.com>
> > Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>
> > Signed-off-by: Dima Zavin <dima@android.com>
> > ---
> > 
> >  drivers/media/video/videobuf2-core.c |   22 ++++++++++++++++++++--
> >  1 files changed, 20 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/media/video/videobuf2-core.c
> > b/drivers/media/video/videobuf2-core.c index b431dc6..e2a8f12 100644
> > --- a/drivers/media/video/videobuf2-core.c
> > +++ b/drivers/media/video/videobuf2-core.c
> > @@ -1592,8 +1592,26 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
> > 
> >  	/*
> >  	 * Reinitialize all buffers for next use.
> >  	 */
> > 
> > -	for (i = 0; i < q->num_buffers; ++i)
> > -		q->bufs[i]->state = VB2_BUF_STATE_DEQUEUED;
> > +	for (i = 0; i < q->num_buffers; ++i) {
> > +		struct vb2_buffer *vb = q->bufs[i];
> > +		int plane;
> > +
> > +		vb->state = VB2_BUF_STATE_DEQUEUED;
> > +
> > +		if (q->memory != V4L2_MEMORY_DMABUF)
> > +			continue;

Don't we need to do something similat for USERPTR buffers as well ? They don't 
seem to get unpinned (put_userptr) at stream-off time.

If we decide to detach the buffer as well as unmapping it, we could just call 
__vb2_buf_put and __vb2_buf_userptr put here. If we don't, the code might 
still be simplified by adding an argument to __vb2_buf_dmabuf_put to select 
whether to unmap and detach the buffer, or just unmap it.

> > +		for (plane = 0; plane < vb->num_planes; ++plane) {
> > +			struct vb2_plane *p = &vb->planes[plane];
> > +
> > +			if (!p->mem_priv)
> > +				continue;
> 
> is the check above really needed? No check like this is done in
> vb2_dqbuf.

I think the check comes from __vb2_plane_dmabuf_put. If the buffer is not 
queued mem_priv will be NULL. However, that might be redundant with the next 
check

> > +			if (p->dbuf_mapped) {
> 
> If a buffer is queued then it is also mapped, so dbuf_mapped
> should be always be true here (at least in theory).

The buffer might never have been queued.

> > +				call_memop(q, unmap_dmabuf, p->mem_priv);
> > +				p->dbuf_mapped = 0;
> > +			}
> > +		}
> > +	}
> > 
> >  }
> >  
> >  /**

-- 
Regards,

Laurent Pinchart

