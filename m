Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:50384 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754555AbcARRqC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2016 12:46:02 -0500
Subject: Re: dma start/stop & vb2 APIs
To: Ran Shalit <ranshalit@gmail.com>, linux-media@vger.kernel.org
References: <CAJ2oMhL=aaN+O0F+_Bo8mjnSEOSCkN3vGk9WB1GeC+1t1tDw5w@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <569D24D4.3040705@xs4all.nl>
Date: Mon, 18 Jan 2016 18:45:56 +0100
MIME-Version: 1.0
In-Reply-To: <CAJ2oMhL=aaN+O0F+_Bo8mjnSEOSCkN3vGk9WB1GeC+1t1tDw5w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/18/2016 05:26 PM, Ran Shalit wrote:
> Hello,
> 
> I am trying to understand how to implement dma transfer correctly
> using videobuf2 APIs.
> 
> Normally, application will do semthing like this (video test API):
> 
>                 xioctl(fd, VIDIOC_DQBUF, &buf)
>                 process_image(buffers[buf.index].start, buf.bytesused);
>                 xioctl(fd, VIDIOC_QBUF, &buf)
> 
> Therefore, in the driver below I will assume that:
> 1. VIDIOC_DQBUF -  trigger dma to start

No. DMA typically starts when VIDIOC_STREAMON is called, although depending
on the hardware the start of the DMA may be delayed if insufficient buffers
have been queued. When the start_streaming op is called you know that STREAMON
has been called and that at least min_buffers_needed buffers have been queued.

> 2. interrupt handler in driver - stop dma

??? No, this just passes the buffer that has been filled by the DMA engine
to vb2 via vb2_buffer_done. The DMA will continue filling the next queued buffer.

> 3. VIDIOC_QBUF - do nothing with dma.
> 
> But, on code review of the following two drivers, I see other things,
> much more complex, and I don't understand it yet.
> 
> These are the two drivers I reviewed:
> - STA2X11
> - dt3511
> 
> In STA2X11 I see:
> 
> 1. start_streaming - also triggers dma to start, why ?

See above, that's what start_streaming typically does.

> 2. buf_queue - add buffer to list & if No active buffer, active the
> first one , and trigger dma. why do we trigger dma with buf_queue

This is old code: if start_streaming is called when there are insufficient
buffers, then start_streaming won't call start_dma and this is postponed
until buf_queue is called and the minimum number of buffers is reached.

These days you'd set the min_buffers_needed field (like in dt3155), and
always start the dma engine in start_streaming. This feature didn't exist
when this driver was written.

> (I
> would assume triggering is done with  VIDIOC_DQBUF -> buffer_finish) ?
> 3. buf_finish - remove buffer from list, but also get the next buffer
> in list and trigger dma, why  do we need to trigger a next buffer ?
> Isn't buffer_finish is called as a result of VIDIOC_QBUF ?

I don't think this in done in the right place. I really wouldn't use sta2x11
as a template. It's poorly maintained.

> 
> 
> In dt3511 I see something else as following:
> buf_queue()
> {...
> if (pd->curr_buf)
> list_add_tail(&vb->done_entry, &pd->dmaq);
> else {
> pd->curr_buf = vb;
> elbit_start_acq(pd);
> }
> ...}
> 
> 1. Again, why dma triggering is done as part of  buf_queue instead buf_finish

?? It doesn't. This is the code from the latest kernel:

static void dt3155_buf_queue(struct vb2_buffer *vb)
{
        struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
        struct dt3155_priv *pd = vb2_get_drv_priv(vb->vb2_queue);

        /*  pd->vidq.streaming = 1 when dt3155_buf_queue() is invoked  */
        spin_lock_irq(&pd->lock);
        if (pd->curr_buf)
                list_add_tail(&vb->done_entry, &pd->dmaq);
        else
                pd->curr_buf = vbuf;
        spin_unlock_irq(&pd->lock);
}

Are you looking at the dt3155 driver from some old kernel? I've no idea
where you get that code from. BTW, it's dt3155, not dt3511.

> 2. what's the meaning of the condition in this code, it is as if only
> the first buffer in buf_queue i striggered, what about the next
> ones,why do they only get into list without triggering dma ?
> 3. In this driver there is no buf_finish.

What each vb2_op does is documented in the comment before struct vb2_ops in
videobuf2-core.h. This includes which ops are optional and which aren't
(e.g. buf_finish is optional: if there is nothing to be done there you can
leave it out).

Since there are so many different DMA engines, each with its own peculiarities,
what happens in which op can differ.

Regards,

	Hans

> 
> Thank you for any comments,
> Ran
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

