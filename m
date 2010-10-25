Return-path: <mchehab@pedra>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:46644 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab0JYIdL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Oct 2010 04:33:11 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8
Date: Mon, 25 Oct 2010 10:33:06 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: RE: [PATCH 5/6 v5] V4L/DVB: s5p-fimc: Add camera capture support
In-reply-to: <001a01cb70f8$ea978530$bfc68f90$%park@samsung.com>
To: 'Sewoon Park' <seuni.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	kyungmin.park@samsung.com, linux-media@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <000801cb741f$3f680160$be380420$%nawrocki@samsung.com>
Content-language: en-us
References: <1286817993-21558-1-git-send-email-s.nawrocki@samsung.com>
 <1286817993-21558-6-git-send-email-s.nawrocki@samsung.com>
 <001a01cb70f8$ea978530$bfc68f90$%park@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sewoon,

thanks you for your further review!

> -----Original Message-----
> From: Sewoon Park [mailto:seuni.park@samsung.com]
> Sent: Thursday, October 21, 2010 10:21 AM
> To: 'Sylwester Nawrocki'; linux-media@vger.kernel.org; linux-samsung-
> soc@vger.kernel.org
> Cc: m.szyprowski@samsung.com; kyungmin.park@samsung.com
> Subject: RE: [PATCH 5/6 v5] V4L/DVB: s5p-fimc: Add camera capture
> support
> 
> Latest your reply is easy to understand.
> And I send you another parts review comments.
> 
> Tuesday, October 12, 2010 2:27, Sylwester Nawrocki wrote :
> >
> > Add a video device driver per each FIMC entity to support
> > the camera capture input mode. Video capture node is registered
> > only if CCD sensor data is provided through driver's platfrom data
> > and board setup code.
> >
> > Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > ---
> >  drivers/media/video/s5p-fimc/Makefile       |    2 +-
> >  drivers/media/video/s5p-fimc/fimc-capture.c |  819
> > +++++++++++++++++++++++++++
> >  drivers/media/video/s5p-fimc/fimc-core.c    |  563 +++++++++++++----
> --
> >  drivers/media/video/s5p-fimc/fimc-core.h    |  205 +++++++-
> >  drivers/media/video/s5p-fimc/fimc-reg.c     |  173 +++++-
> >  include/media/s3c_fimc.h                    |   60 ++
> >  6 files changed, 1630 insertions(+), 192 deletions(-)
> >  create mode 100644 drivers/media/video/s5p-fimc/fimc-capture.c
> >  create mode 100644 include/media/s3c_fimc.h
> >
> > diff --git a/drivers/media/video/s5p-fimc/Makefile
> > b/drivers/media/video/s5p-fimc/Makefile
> > index 0d9d541..7ea1b14 100644
> > --- a/drivers/media/video/s5p-fimc/Makefile
> > +++ b/drivers/media/video/s5p-fimc/Makefile
> > @@ -1,3 +1,3 @@
> >
> >  obj-$(CONFIG_VIDEO_SAMSUNG_S5P_FIMC) := s5p-fimc.o
> > -s5p-fimc-y := fimc-core.o fimc-reg.o
> > +s5p-fimc-y := fimc-core.o fimc-reg.o fimc-capture.o
> > diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c
> > b/drivers/media/video/s5p-fimc/fimc-capture.c
> > new file mode 100644
> > index 0000000..e8f13d3
> > --- /dev/null
> > +++ b/drivers/media/video/s5p-fimc/fimc-capture.c
> > @@ -0,0 +1,819 @@
> > +/*
[snip]
> > +
> > +	vid_cap->input_index = -1;
> > +}
> 
> (snip)
> 
> > +static int fimc_cap_s_fmt(struct file *file, void *priv,
> > +			     struct v4l2_format *f)
> > +{
> > +	struct fimc_ctx *ctx = priv;
> > +	struct fimc_dev *fimc = ctx->fimc_dev;
> > +	struct fimc_frame *frame;
> > +	struct v4l2_pix_format *pix;
> > +	int ret;
> > +
> > +	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> > +		return -EINVAL;
> > +
> > +	ret = fimc_vidioc_try_fmt(file, priv, f);
> > +	if (ret)
> > +		return ret;
> > +
> > +	if (mutex_lock_interruptible(&fimc->lock))
> > +		return -ERESTARTSYS;
> > +
> > +	if (fimc_capture_active(fimc)) {
> > +		ret = -EBUSY;
> > +		goto sf_unlock;
> > +	}
> 
> I suggest to use vb_lock on here.
> You already use vb_lock "fimc_m2m_s_fmt" function in fimc-core.c code
> 
> -- sample --
> struct fimc_capture_device *cap = &ctx->fimc_dev->vid_cap;
> mutex_lock(&cap->vbq->vb->lock);
> 

I don't really think it is needed since the output frame parameters
are used only in fimc_cap_streamon() to setup the device and fimc->lock
is also used there for serialization. Can you point to any specific
use case where it is needed?

> > +
> > +	frame = &ctx->d_frame;
> > +
> > +	pix = &f->fmt.pix;
> > +	frame->fmt = find_format(f, FMT_FLAGS_M2M | FMT_FLAGS_CAM);
> > +	if (!frame->fmt) {
> > +		err("fimc target format not found\n");
> > +		ret = -EINVAL;
> > +		goto sf_unlock;
> > +	}
> > +
> > +	/* Output DMA frame pixel size and offsets. */
> > +	frame->f_width	= pix->bytesperline * 8 / frame->fmt->depth;
> > +	frame->f_height = pix->height;
> > +	frame->width	= pix->width;
> > +	frame->height	= pix->height;
> > +	frame->o_width	= pix->width;
> > +	frame->o_height = pix->height;
> > +	frame->size	= (pix->width * pix->height * frame->fmt->depth) >>
> 3;
> > +	frame->offs_h	= 0;
> > +	frame->offs_v	= 0;
> > +
> > +	ret = sync_capture_fmt(ctx);
> > +
> > +	ctx->state |= (FIMC_PARAMS | FIMC_DST_FMT);
> > +
> > +sf_unlock:
> > +	mutex_unlock(&fimc->lock);
> > +	return ret;
> > +}
> 
> (snip)
> 
> > -static int fimc_prepare_config(struct fimc_ctx *ctx, u32 flags)
> > +int fimc_prepare_config(struct fimc_ctx *ctx, u32 flags)
> >  {
> >  	struct fimc_frame *s_frame, *d_frame;
> >  	struct fimc_vid_buffer *buf = NULL;
> > @@ -513,9 +585,9 @@ static void fimc_dma_run(void *priv)
> >  	if (ctx->state & FIMC_PARAMS)
> >  		fimc_hw_set_out_dma(ctx);
> >
> > -	ctx->state = 0;
> >  	fimc_activate_capture(ctx);
> >
> > +	ctx->state &= (FIMC_CTX_M2M | FIMC_CTX_CAP);
> >  	fimc_hw_activate_input_dma(fimc, true);
> >
> >  dma_unlock:
> > @@ -598,10 +670,31 @@ static void fimc_buf_queue(struct
> videobuf_queue *vq,
> >  				  struct videobuf_buffer *vb)
> >  {
> >  	struct fimc_ctx *ctx = vq->priv_data;
> > -	v4l2_m2m_buf_queue(ctx->m2m_ctx, vq, vb);
> > +	struct fimc_dev *fimc = ctx->fimc_dev;
> > +	struct fimc_vid_cap *cap = &fimc->vid_cap;
> > +	unsigned long flags;
> > +
> > +	dbg("ctx: %p, ctx->state: 0x%x", ctx, ctx->state);
> > +
> > +	if ((ctx->state & FIMC_CTX_M2M) && ctx->m2m_ctx) {
> > +		v4l2_m2m_buf_queue(ctx->m2m_ctx, vq, vb);
> > +	} else if (ctx->state & FIMC_CTX_CAP) {
> > +		spin_lock_irqsave(&fimc->slock, flags);
> > +		fimc_vid_cap_buf_queue(fimc, (struct fimc_vid_buffer *)vb);
> > +
> > +		dbg("fimc->cap.active_buf_cnt: %d",
> > +		    fimc->vid_cap.active_buf_cnt);
> > +
> > +		if (cap->active_buf_cnt >= cap->reqbufs_count ||
> > +		   cap->active_buf_cnt >= FIMC_MAX_OUT_BUFS) {
> 
> 1. purpose of queues
> In my understand through your code,
> The qbuf() which call before streamon() is pushed done_list in videobuf
> framework to use dqbuf().
I'm not sure what you mean here exactly.

> During streamon(), Number of FIMC h/w output DMA allocated buffers have
> pushed
> in active_queue(normally 4) and rest allocated buffers have pushed to
> pending_queue.
> 
> It means that, active_queue is connection to FIMC h/w for output DMA.
> (maximum 4 in s5pc110, 32 in s5pc210)
> pending_queue is available buffer list or returned buffer list from
> user.
> 
> Please let me know if I have misunderstanding.

It's all correct, except that on s5pc210 the maximum is also 4 
in the driver.

The buffers are queued to the driver only after user call to QBUF
and STREAMON. Then for each buffer fimc_buf_queue is called which in turn 
calls fimc_vid_cap_buf_queue() if we are in video capture context.
First buffers right after STREAMON are passed directly to the DMA engine.
It is done until we reach buffer count of FIMC_MAX_OUT_BUFS 
or reqbufs.count, whichever is less. Such buffers are put on the 
active_buf_q queue. Then after those initial buffers were scheduled
in the output DMA engine the hardware operation is started. 
All subsequent buffers coming from user while streaming is enabled are
put on pending_buf_q from then on.   
They will be scheduled for processing in the interrupt routine and moved
to active_buf_q.

> 
> 2. Which case of condition, active_buf_cnt greater than reqbufs_count?

In normal conditions this will never happen, the >= condition is a bit
paranoic there.

> In preview mode normally, reqbufs_count are 4 or more.

reqbufs.count >= 1 is allowed in the driver.

> Likewise, which case of condition, active_buf_cnt greater than
> FIMC_MAX_OUT_BUFS(4)?

During normal operation active_buf_cnt will never be greater than
FIMC_MAX_OUT_BUFS. 
> 
> > +			if (!test_and_set_bit(ST_CAPT_STREAM, &fimc->state))
> > +				fimc_activate_capture(ctx);
> > +		}
> 
> Condition which fimc_deactivate_capture() function run is
> "cap->active_buf_cnt <= 1".
> Then I think condition which fimc_activate_capture() function run is
> "cap->active_buf_cnt >= 2".
> But, your code wait 4 or more.

I assume you are referring to this:

	if (cap->active_buf_cnt >= cap->reqbufs_count ||
	   cap->active_buf_cnt >= FIMC_MAX_OUT_BUFS) {
		if (!test_and_set_bit(ST_CAPT_STREAM, &fimc->state))
			fimc_activate_capture(ctx);
	}

The driver waits for reqbufs.count or FIMC_MAX_OUT_BUFS (4), whichever
is less as I mentioned above.
When reqbufs.count == 1 condition "cap->active_buf_cnt >= 2" is
never true and hardware would have never been re-enabled.
I have tested the driver with delayed DQBUF and it worked fine with
reqbufs.count = 1.
However I observed some problems in synchronizing video buffers setup
with the DMA engine when DQBUF is delayed, since the hw doesn't
start writing at the beginning from buffer 0 as expected but from
index 2. I will address that soon after I get back from ELC-E.  


Thank you,
Sylwester


