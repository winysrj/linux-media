Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40153 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252AbbDMQPU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Apr 2015 12:15:20 -0400
Message-ID: <1428941715.3192.133.camel@pengutronix.de>
Subject: Re: [PATCH v4 2/4] [media] videobuf2: return -EPIPE from DQBUF
 after the last buffer
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Pawel Osciak <pawel@osciak.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Kamil Debski <k.debski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	kernel@pengutronix.de
Date: Mon, 13 Apr 2015 18:15:15 +0200
In-Reply-To: <CAMm-=zAwQJ-_jp5B7cRiQEi523a57BaijUwnqCwLUPScCL7_kQ@mail.gmail.com>
References: <1427219214-5368-1-git-send-email-p.zabel@pengutronix.de>
	 <1427219214-5368-3-git-send-email-p.zabel@pengutronix.de>
	 <CAMm-=zAwQJ-_jp5B7cRiQEi523a57BaijUwnqCwLUPScCL7_kQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pawel,

thanks for the review!

Am Montag, den 13.04.2015, 15:30 +0900 schrieb Pawel Osciak:
> Hi,
> 
> On Wed, Mar 25, 2015 at 2:46 AM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> > If the last buffer was dequeued from a capture queue, let poll return
> > immediately and let DQBUF return -EPIPE to signal there will no more
> > buffers to dequeue until STREAMOFF.
> > The driver signals the last buffer by setting the V4L2_BUF_FLAG_LAST.
> > To reenable dequeuing on the capture queue, the driver must explicitly
> > call vb2_clear_last_buffer_queued. The last buffer queued flag is
> > cleared automatically during STREAMOFF.
> >
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> > Changes since v3:
> >  - Added DocBook update mentioning DQBUF returning -EPIPE in the encoder/decoder
> >    stop command documentation.
> > ---
> >  Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml |  4 +++-
> >  Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml |  4 +++-
> >  Documentation/DocBook/media/v4l/vidioc-qbuf.xml        |  8 ++++++++
> >  drivers/media/v4l2-core/v4l2-mem2mem.c                 | 10 +++++++++-
> >  drivers/media/v4l2-core/videobuf2-core.c               | 18 +++++++++++++++++-
> >  include/media/videobuf2-core.h                         | 10 ++++++++++
> >  6 files changed, 50 insertions(+), 4 deletions(-)
> >
> > diff --git a/Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml b/Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml
> 
> Would it make sense to perhaps split this patch into docbook and vb2
> changes please?

Alright, I'll split DocBook from vb2 changes, with the documentation
patches first.

> > diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
> > index 80c588f..1b5b432 100644
> > --- a/drivers/media/v4l2-core/v4l2-mem2mem.c
> > +++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
> > @@ -564,8 +564,16 @@ unsigned int v4l2_m2m_poll(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
> >
> >         if (list_empty(&src_q->done_list))
> >                 poll_wait(file, &src_q->done_wq, wait);
> > -       if (list_empty(&dst_q->done_list))
> > +       if (list_empty(&dst_q->done_list)) {
> > +               /*
> > +                * If the last buffer was dequeued from the capture queue,
> > +                * return immediately. DQBUF will return -EPIPE.
> > +                */
> > +               if (dst_q->last_buffer_dequeued)
> > +                       return rc | POLLIN | POLLRDNORM;
> 
> These indicate there is data to be read. Is there something else we
> could return? Maybe POLLHUP?

This is a good point, but I'm not sure. POLLHUP seems to mean a similar
thing, yet not quite the same. The documentation explicitly mentions
disconnected devices or FIFOs without writers, neither of which applies.
Also a FIFO signals POLLHUP when the last writer leaves, so we would
probably have to signal POLLHUP|POLLIN after the last buffer was decoded
for consistency, and keep that until the last buffer is dequeued. Then
we could signal POLLHUP alone here.

I didn't want to risk redefining/misinterpreting any poll(2) behavior,
so my interpretation was that POLLIN signals userspace to try a DQBUF,
as usual.

> > +
> >                 poll_wait(file, &dst_q->done_wq, wait);
> > +       }
> >
> >         if (m2m_ctx->m2m_dev->m2m_ops->lock)
> >                 m2m_ctx->m2m_dev->m2m_ops->lock(m2m_ctx->priv);
> > diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> > index bc08a82..a0b9946 100644
> > --- a/drivers/media/v4l2-core/videobuf2-core.c
> > +++ b/drivers/media/v4l2-core/videobuf2-core.c
> > @@ -2046,6 +2046,10 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool n
> >         struct vb2_buffer *vb = NULL;
> >         int ret;
> >
> > +       if (q->last_buffer_dequeued) {
> > +               dprintk(3, "last buffer dequeued already\n");
> > +               return -EPIPE;
> > +       }
> 
> This should go after the check for queue type at least. However, best
> probably to __vb2_wait_for_done_vb(), where we already have the checks
> for q->streaming and q->error.

Yes, that'll be better.

> >         if (b->type != q->type) {
> >                 dprintk(1, "invalid buffer type\n");
> >                 return -EINVAL;
[...]
> > @@ -2628,8 +2636,16 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
> >         if (V4L2_TYPE_IS_OUTPUT(q->type) && q->queued_count < q->num_buffers)
> >                 return res | POLLOUT | POLLWRNORM;
> >
> > -       if (list_empty(&q->done_list))
> > +       if (list_empty(&q->done_list)) {
> > +               /*
> > +                * If the last buffer was dequeued from a capture queue,
> > +                * return immediately. DQBUF will return -EPIPE.
> > +                */
> > +               if (!V4L2_TYPE_IS_OUTPUT(q->type) && q->last_buffer_dequeued)
> 
> Do we need to check !V4L2_TYPE_IS_OUTPUT(q->type) here? We wouldn't
> have set last_buffer_dequeued to true if it wasn't, so we could drop
> this check?

Indeed we don't. I'll drop the check.

> > +                       return res | POLLIN | POLLRDNORM;
> 
> Same comment as above.

Same concern as above.

> > +
> >                 poll_wait(file, &q->done_wq, wait);
> > +       }
> >
> >         /*
> >          * Take first buffer available for dequeuing.
> > diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> > index bd2cec2..863a8bb 100644
> > --- a/include/media/videobuf2-core.h
> > +++ b/include/media/videobuf2-core.h
> > @@ -429,6 +429,7 @@ struct vb2_queue {
> >         unsigned int                    start_streaming_called:1;
> >         unsigned int                    error:1;
> >         unsigned int                    waiting_for_buffers:1;
> > +       unsigned int                    last_buffer_dequeued:1;
> 
> Please add documentation above.

Will do.

> >
> >         struct vb2_fileio_data          *fileio;
> >         struct vb2_threadio_data        *threadio;
> > @@ -609,6 +610,15 @@ static inline bool vb2_start_streaming_called(struct vb2_queue *q)
> >         return q->start_streaming_called;
> >  }
> >
> > +/**
> > + * vb2_clear_last_buffer_dequeued() - clear last buffer dequeued flag of queue
> > + * @q:         videobuf queue
> > + */
> > +static inline void vb2_clear_last_buffer_dequeued(struct vb2_queue *q)
> > +{
> > +       q->last_buffer_dequeued = false;
> > +}
> > +
> 
> There are some timing issues here to consider. How does the driver
> know when it's ok to call this function, i.e. that the userspace has
> already dequeued all the buffers, so that it doesn't call this too
> early?

This flag is only set when userspace dequeues the last buffer. I'd
expect the driver to clear the flag after restarting the machinery that
can actually produce decoded frames.

> But, in general, in what kind of scenario would the driver want to
> call this function, as opposed to vb2 clearing this flag by itself on
> STREAMOFF?

There is VIDIOC_DECODER_CMD / V4L2_DEC_CMD_START.
I'd expect this timeline for decoder draining and restart:

- userspace calls VIDIOC_DECODER_CMD, cmd=V4L2_DEC_CMD_STOP
  after queueing the last output buffer to be decoded
- the driver processes remaining output buffers into capture buffers
  and sets the V4L2_BUF_FLAG_LAST set on the last capture buffer
- when the last capture buffer is put on the queue, the driver
  sends V4L2_EVENT_EOS
- userspace dequeues remaining buffers (either in reaction to the
  V4L2_EVENT_EOS signal or because it knows it just sent CMD_STOP)
  until the returned buffer has V4L2_BUF_FLAG_LAST set, or until the
  driver sets the last_buffer_dequeued flag and VIDIOC_DQBUF returns
  -EPIPE

- userspace calls VIDIOC_DECODER_CMD, cmd=V4L2_DEC_CMD_START
  after queueing new output buffers to be decoded
- the driver restarts the decoding process and clears the
  last_buffer_dequeued flag before returning from VIDIOC_DECODER_CMD
- userspace can poll on the capture queue again

regards
Philipp

