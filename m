Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49961 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755113AbcLOXrF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 18:47:05 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        pawel@osciak.com, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, sumit.semwal@linaro.org,
        robdclark@gmail.com, daniel.vetter@ffwll.ch, labbott@redhat.com
Subject: Re: [RFC RESEND 03/11] vb2: Move cache synchronisation from buffer done to dqbuf handler
Date: Fri, 16 Dec 2016 01:47:20 +0200
Message-ID: <1504308.JR7t8vfKWF@avalon>
In-Reply-To: <55F7CDEE.8050802@linux.intel.com>
References: <1441972234-8643-1-git-send-email-sakari.ailus@linux.intel.com> <55F30085.504@xs4all.nl> <55F7CDEE.8050802@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Tuesday 15 Sep 2015 10:51:10 Sakari Ailus wrote:
> Hans Verkuil wrote:
> > On 09/11/2015 01:50 PM, Sakari Ailus wrote:
> >> The cache synchronisation may be a time consuming operation and thus not
> >> best performed in an interrupt which is a typical context for
> >> vb2_buffer_done() calls. This may consume up to tens of ms on some
> >> machines, depending on the buffer size.
> >> 
> >> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> >> ---
> >> 
> >>  drivers/media/v4l2-core/videobuf2-core.c | 20 ++++++++++----------
> >>  1 file changed, 10 insertions(+), 10 deletions(-)
> >> 
> >> diff --git a/drivers/media/v4l2-core/videobuf2-core.c
> >> b/drivers/media/v4l2-core/videobuf2-core.c index 64fce4d..c5c0707a
> >> 100644
> >> --- a/drivers/media/v4l2-core/videobuf2-core.c
> >> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> >> @@ -1177,7 +1177,6 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum
> >> vb2_buffer_state state)
> >>  {
> >>  	struct vb2_queue *q = vb->vb2_queue;
> >>  	unsigned long flags;
> >> -	unsigned int plane;
> >> 
> >>  	if (WARN_ON(vb->state != VB2_BUF_STATE_ACTIVE))
> >>  		return;
> >> @@ -1197,10 +1196,6 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum
> >> vb2_buffer_state state)
> >>  	dprintk(4, "done processing on buffer %d, state: %d\n",
> >>  			vb->v4l2_buf.index, state);
> >> 
> >> -	/* sync buffers */
> >> -	for (plane = 0; plane < vb->num_planes; ++plane)
> >> -		call_void_memop(vb, finish, vb->planes[plane].mem_priv);
> >> -
> > 
> > Ah, OK, so it is removed here,
> 
> I can merge the two patches for the next version if you prefer that.

I think that would be a good idea. They're both pretty small, and they're 
related. Merging them will make review easier.

> >>  	/* Add the buffer to the done buffers list */
> >>  	spin_lock_irqsave(&q->done_lock, flags);
> >>  	vb->state = state;
> >> 
> >> @@ -2086,7 +2081,7 @@ EXPORT_SYMBOL_GPL(vb2_wait_for_all_buffers);
> >>  static void __vb2_dqbuf(struct vb2_buffer *vb)
> >>  {
> >>  	struct vb2_queue *q = vb->vb2_queue;
> >> -	unsigned int i;
> >> +	unsigned int plane;
> >> 
> >>  	/* nothing to do if the buffer is already dequeued */
> >>  	if (vb->state == VB2_BUF_STATE_DEQUEUED)
> >> @@ -2094,13 +2089,18 @@ static void __vb2_dqbuf(struct vb2_buffer *vb)
> >> 
> >>  	vb->state = VB2_BUF_STATE_DEQUEUED;
> >> 
> >> +	/* sync buffers */
> >> +	for (plane = 0; plane < vb->num_planes; plane++)
> >> +		call_void_memop(vb, finish, vb->planes[plane].mem_priv);
> >> +
> > 
> > to here.
> > 
> > I'm not sure if this is correct... So __vb2_dqbuf is called from
> > __vb2_queue_cancel(), but now the buf_finish() callback is called
> > *before* the memop finish() callback, where this was the other way around
> > in __vb2_queue_cancel(). I don't think that is right since buf_finish()
> > expects that the buffer is synced for the cpu.
>
> I don't mind reordering them.

The .buf_finish() driver callback could touch the contents of the buffer using 
the CPU, so I agree with Hans that we need to reorder the calls.

> The vb->state will be different as __vb2_dqbuf() has already been called,
> there's at least one buffer state check in a driver. However, __vb2_dqbuf()
> unconditionally sets the buffer state to DEQUEUED, overriding e.g. ERROR
> which a driver would be interested in.
> 
> I think the cache sync needs to be moved out of __vb2_dqbuf() to the
> same level where it's called so proper ordering can be maintained while
> still flushing cache before buf_finish() is called.

I think that would be the easiest option. It's a bit of a shame to duplicate 
the call, but I don't see any other easy way. A comment that states that cache 
sync needs to occur before .buf_finish() would probably be useful.

> > Was this tested with CONFIG_VIDEO_ADV_DEBUG set and with 'v4l2-compliance
> > -s'? Not that that would help if things are done in the wrong order...
> 
> I'll do that the next time.

-- 
Regards,

Laurent Pinchart

