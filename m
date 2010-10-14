Return-path: <mchehab@pedra>
Received: from mailout1.samsung.com ([203.254.224.24]:26521 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626Ab0JNM4W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Oct 2010 08:56:22 -0400
Date: Thu, 14 Oct 2010 14:56:10 +0200
From: Kamil Debski <k.debski@samsung.com>
Subject: RE: [PATCH 3/4] MFC: Add MFC 5.1 V4L2 driver
In-reply-to: <004b01cb6b68$9d45a8b0$d7d0fa10$%oh@samsung.com>
To: jaeryul.oh@samsung.com, linux-media@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com,
	kyungmin.park@samsung.com, kgene.kim@samsung.com
Message-id: <005b01cb6b9f$304dd390$90e97ab0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: en-us
Content-transfer-encoding: 7BIT
References: <1286968160-10629-1-git-send-email-k.debski@samsung.com>
 <1286968160-10629-4-git-send-email-k.debski@samsung.com>
 <004b01cb6b68$9d45a8b0$d7d0fa10$%oh@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi, Peter.

> I have some first comments about this code.
> and Generally, Making patch set separately will be more helpful to
> everyone.

Thank you for your comments.
 
> k.debski@samsung.com wrote:
> > Multi Format Codec 5.1 is a module available on S5PC110 and S5PC210
> > Samsung SoCs. Hardware is capable of handling a range of video codecs
> > and this driver provides V4L2 interface for video decoding.
> >
> > Signed-off-by: Kamil Debski <k.debski@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

[...]

> >
> > diff --git a/drivers/media/video/Kconfig
> b/drivers/media/video/Kconfig
> > index 6d0bd36..1d0b91e 100644
> > --- a/drivers/media/video/Kconfig
> > +++ b/drivers/media/video/Kconfig
> > @@ -1047,4 +1047,12 @@ config  VIDEO_SAMSUNG_S5P_FIMC
> >  	  This is a v4l2 driver for the S5P camera interface
> >  	  (video postprocessor)
> >
> > +config VIDEO_SAMSUNG_S5P_MFC
> > +	tristate "Samsung S5P MFC 5.0 Video Codec"
> > +	depends on VIDEO_V4L2 && CMA
> > +	select VIDEOBUF2_CMA
> > +	default n
> > +	help
> > +	    MFC 5.0 driver for V4L2.
> > +
> >  endif # V4L_MEM2MEM_DRIVERS
> 
> What about unifying MFC version as a MFC 5.1, because we are using MFC
> HW
> ver.(MFC 5.1.x)
> in the C110/C210 chip.

Right, will fix this.

[...]

> > diff --git a/drivers/media/video/s5p-mfc/regs-mfc5.h
> > b/drivers/media/video/s5p-mfc/regs-mfc5.h
> > new file mode 100644
> > index 0000000..8c628ad
> > --- /dev/null
> > +++ b/drivers/media/video/s5p-mfc/regs-mfc5.h
> > @@ -0,0 +1,305 @@
> > +/*
> > + *
> > + * Register definition file for Samsung MFC V4.0 & V5.0 Interface
> (FIMV)
> > driver
> > + *
> > + * Kamil Debski, Copyright (c) 2010 Samsung Electronics
> > + * http://www.samsung.com/
> > + *
> > + * This program is free software; you can redistribute it and/or
> modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > +*/
> 
> Incorrect comment in the header, MFC V4.0 is not included
> 

Right again. 

> > +
> > +#ifndef _REGS_FIMV_H
> > +#define _REGS_FIMV_H
> > +
> > +#define S5P_FIMV_REG_SIZE	(S5P_FIMV_END_ADDR - S5P_FIMV_START_ADDR)
> > +#define S5P_FIMV_REG_COUNT	((S5P_FIMV_END_ADDR -
> > S5P_FIMV_START_ADDR) / 4)
> > +
> > +#define S5P_FIMV_START_ADDR	0x0000
> > +#define S5P_FIMV_END_ADDR	0xe008
> > +
> > +#define S5P_FIMV_SW_RESET	0x0000
> > +#define S5P_FIMV_RISC_HOST_INT	0x0008
> > +/* Command from HOST to RISC */
> > +#define S5P_FIMV_HOST2RISC_CMD	0x0030
> > +#define S5P_FIMV_HOST2RISC_ARG1	0x0034
> > +#define S5P_FIMV_HOST2RISC_ARG2	0x0038
> > +#define S5P_FIMV_HOST2RISC_ARG3	0x003c
> > +#define S5P_FIMV_HOST2RISC_ARG4	0x0040
> > +/* Command from RISC to HOST */
> > +#define S5P_FIMV_RISC2HOST_CMD	0x0044
> > +#define S5P_FIMV_RISC2HOST_ARG1	0x0048
> > +#define S5P_FIMV_RISC2HOST_ARG2	0x004c
> > +#define S5P_FIMV_RISC2HOST_ARG3	0x0050
> > +#define S5P_FIMV_RISC2HOST_ARG4	0x0054
> > +
> > +#define S5P_FIMV_FW_VERSION	0x0058
> > +#define S5P_FIMV_SYS_MEM_SZ	0x005c
> > +#define S5P_FIMV_FW_STATUS	0x0080
> > +/* Memory controller register */
> > +#define S5P_FIMV_MC_DRAMBASE_ADR_A	0x0508
> > +#define S5P_FIMV_MC_DRAMBASE_ADR_B	0x050c
> > +#define S5P_FIMV_MC_STATUS	0x0510
> > +
> > +/***** In case of 2 master *****/
> 
> This comment(In case of 2 master) is meaningless. it was used at the
> beginning
> step of development.

Will fix this too.
 
> > +/* Common register */
> > +#define S5P_FIMV_SYS_MEM_ADR	0x0600 /* firmware buffer */
> > +#define S5P_FIMV_CPB_BUF_ADR	0x0604 /* stream buffer */
> > +#define S5P_FIMV_DESC_BUF_ADR	0x0608 /* descriptor buffer */
> > +/* H264 decoding */
> > +#define S5P_FIMV_VERT_NB_MV_ADR	0x068c /* vertical neighbor motion
> > vector */
> > +#define S5P_FIMV_VERT_NB_IP_ADR	0x0690 /* neighbor pixels for intra

[...]

> displayed pic
> > */
> > +#define S5P_FIMV_SI_DISPLAY_C_ADR 0x2014 /* chroma address of
> displayed
> > pic */
> > +#define S5P_FIMV_SI_DEC_FRM_SIZE 0x2018 /* the number of frames
> decoded
> > */
 
> S5P_FIMV_SI_DEC_FRM_SIZE does actually means
> "consumed number of bytes to decode a frame"

Ok, I've changed the name of the define to reflect the purpose of the
register.

> > +#define S5P_FIMV_SI_DISPLAY_STATUS 0x201c /* status of decoded
> picture */
> > +#define S5P_FIMV_SI_FRAME_TYPE	0x2020 /* frame type such as
> skip/I/P/B
> > */
> > +
> > +#define S5P_FIMV_SI_CH0_SB_ST_ADR	0x2044 /* start addr of
> stream buf
> > */
> > +#define S5P_FIMV_SI_CH0_SB_FRM_SIZE	0x2048 /* size of stream buf
> */
> > +#define S5P_FIMV_SI_CH0_DESC_ADR	0x204c /* addr of descriptor buf
> > */
> > +/* Encoder for MPEG4 */
> > +#define S5P_FIMV_ENC_MPEG4_QUART_PXL	0xe008 /* qpel interpolation
> ctrl
> > */
> > +
> > +/* Additional */
> > +#define S5P_FIMV_SI_CH0_DPB_CONF_CTRL   0x2068 /* DPB Config Control
> > Register */
> > +#define S5P_FIMV_SI_CH0_RELEASE_BUF     0x2060 /* DPB release buffer
> > register */
> > +#define S5P_FIMV_SI_CH0_HOST_WR_ADR	0x2064
> 
> S5P_FIMV_SI_CH0_HOST_WR_ADR means 'address of shared memory'
> if comments is needed

Added the comment.
 
[...]

> > diff --git a/drivers/media/video/s5p-mfc/s5p_mfc.c
> > b/drivers/media/video/s5p-mfc/s5p_mfc.c
> > new file mode 100644
> > index 0000000..f549ab6
> > --- /dev/null
> > +++ b/drivers/media/video/s5p-mfc/s5p_mfc.c

[...]

> > +
> > +void s5p_mfc_error_cleanup_queue(struct list_head *lh, \
> > +						struct vb2_queue *vq)
> > +{
> > +	struct vb2_buffer *b;
> > +	int i;
> > +	spin_lock(&dev->irqlock);
> > +	while (!list_empty(lh)) {
> > +		b = list_entry(lh->next, struct vb2_buffer, drv_entry);
> > +		for (i = 0; i < b->num_planes; i++)
> > +			vb2_set_plane_payload(b, i, 0);
> > +		spin_unlock(&dev->irqlock);
> > +		vb2_buffer_done(b, VB2_BUF_STATE_ERROR);
> > +		spin_lock(&dev->irqlock);
> > +		list_del(&b->drv_entry);
> > +	}
> > +	spin_unlock(&dev->irqlock);
> > +}
> 
> How about adding new line b/w local var defintions & running code thru
> whole function for readability.

Ok, can do that.

> 
> > +
> > +void s5p_mfc_watchdog(unsigned long arg)
> > +{
> > +	if (test_bit(0, &dev->hw_lock))
> > +		atomic_inc(&dev->watchdog_cnt);
> > +	if (atomic_read(&dev->watchdog_cnt) >= MFC_WATCHDOG_CNT) {
> > +		/* This means that hw is busy and no interrupts were
> > +		 * generated by hw for the Nth time of running this
> > +		 * watchdog timer. This usually means a serious hw
> > +		 * error. Now it is time to kill all instances and
> > +		 * reset the MFC. */
> > +		mfc_err("Time out during waiting for HW.\n");
> > +		queue_work(dev->watchdog_workqueue, &dev->watchdog_work);
> > +	}
> > +	dev->watchdog_timer.expires +=
> > msecs_to_jiffies(MFC_WATCHDOG_INTERVAL);
> > +	add_timer(&dev->watchdog_timer);
> > +}
> > +

[...]

> > +			if (mutex_locked)
> > +				mutex_unlock(dev->mfc_mutex);
> > +			return;
> > +		}
> > +	}
> > +	if (mutex_locked)
> > +		mutex_unlock(dev->mfc_mutex);
> > +}
> 
> Does MFC_NUM_CONTEXTS means max num of contexts ? what about
> MFC_MAX_CONTEXT_NUM ?
> and this number is absolutely dependent on what max size used,
> what kinds of codec used, etc so, you had better use configuration
> param.
> for example>
>    #ifdef CONFIG_VIDEO_MFC_MAX_INSTANCE
>    #define MFC_MAX_CONTEXT_NUM (CONFIG_VIDEO_MFC_MAX_INSTANCE)
>    #endif

I don't know if this is necessary. MFC_NUM_CONTEXTS can be fixed at
the maximum number allowed by MFC hw: 16. I highly doubt someone
will open that many contexts. Increasing this number will not
significantly increase storage space used by MFC if no contexts are
used. It will only change size of one pointer array
( struct s5p_mfc_ctx *ctx[MFC_NUM_CONTEXTS]; ).

> 
> > +
> > +/* Check whether a context should be run on hardware */
> > +int s5p_mfc_ctx_ready(struct s5p_mfc_ctx *ctx)
> > +{
> > +	mfc_debug("s5p_mfc_ctx_ready: src=%d, dst=%d, state=%d\n",
> > +		  ctx->src_queue_cnt, ctx->dst_queue_cnt, ctx->state);
> > +	/* Context is to parse header */
> > +	if (ctx->src_queue_cnt >= 1 && ctx->state ==
> MFCINST_DEC_GOT_INST)
> > +		return 1;
> > +	/* Context is to decode a frame */
> > +	if (ctx->src_queue_cnt >= 1 && ctx->state == MFCINST_DEC_RUNNING
> &&
> > +					ctx->dst_queue_cnt >= ctx-
> >dpb_count)
> > +		return 1;
> > +	/* Context is to return last frame */
> > +	if (ctx->state == MFCINST_DEC_FINISHING &&
> > +	    ctx->dst_queue_cnt >= ctx->dpb_count)
> > +		return 1;
> > +	/* Context is to set buffers */
> > +	if (ctx->src_queue_cnt >= 1 &&
> > +	    ctx->state == MFCINST_DEC_HEAD_PARSED &&
> > +	    ctx->capture_state == QUEUE_BUFS_MMAPED)
> > +		return 1;
> > +	mfc_debug("s5p_mfc_ctx_ready: ctx is not ready.\n");
> > +	return 0;
> > +}
> > +

[...]

> > +/* Reqeust buffers */
> > +static int vidioc_reqbufs(struct file *file, void *priv,
> > +					  struct v4l2_requestbuffers
> *reqbufs)
> > +{
> > +	struct s5p_mfc_ctx *ctx = priv;
> > +	int ret = 0;
> > +	mfc_debug("vidioc_reqbufs++\n");
> > +	mfc_debug("Memory type: %d\n", reqbufs->memory);
> > +	if (reqbufs->memory != V4L2_MEMORY_MMAP) {
> > +		mfc_err("Only V4L2_MEMORY_MAP is supported.\n");
> > +		return -EINVAL;
> > +	}
> > +	if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> > +		/* Can only request buffers after an instance has been
> > opened.*/
> > +		if (ctx->state == MFCINST_DEC_GOT_INST) {
> > +			/* Decoding */
> > +			if (ctx->output_state != QUEUE_FREE) {
> > +				mfc_err("Bufs have already been
> requested.\n");
> > +				return -EINVAL;
> > +			}
> > +			ret = vb2_reqbufs(&ctx->vq_src, reqbufs);
> > +			if (ret) {
> > +				mfc_err("vb2_reqbufs on output failed.\n");
> > +				return ret;
> > +			}
> > +			mfc_debug("vb2_reqbufs: %d\n", ret);
> > +			ctx->output_state = QUEUE_BUFS_REQUESTED;
> > +		}
> > +	}
> > +	if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> > +		if (ctx->capture_state != QUEUE_FREE) {
> > +			mfc_err("Bufs have already been requested.\n");
> > +			return -EINVAL;
> > +		}
> > +		ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
> > +		if (ret) {
> > +			mfc_err("vb2_reqbufs on output failed.\n");
> 
> error message should be mfc_err("vb2_reqbufs on capture failed.\n");

Right.

> 
> > +			return ret;
> > +		}
> > +		if (reqbufs->count < ctx->dpb_count) {
> > +			mfc_err("Not enough buffers allocated.\n");
> > +			reqbufs->count = 0;
> > +			ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
> > +			return -ENOMEM;
> > +		}
> > +		ctx->total_dpb_count = reqbufs->count;
> 
> if 'ctx->total_dpb_count = reqbufs->count;' is here in code, Hmm....
> let's suppose that reqbufs->count = 16 & ctx->dpb_count = 10,
> in that case, ctx->total_dpb_count is 16,
> but *buf_count(in the s5p_mfc_buf_negotiate()) is 15
> so, it is not matched & it affect __vb2_queue_alloc(xx, num_buffers,
> xx)
> i think, is is due to location of 'the ctx->total_dpb_count = reqbufs-
> >count;'
> and No warning message for exceeding MFC_MAX_EXTRA_DPB
> what do you think about that ?

The number of buffers requested by the user is stored in reqbufs->count.
Then vb2_reqbufs() is called, which calls the s5p_mfc_buf_negotiate()
callback function. It may change the number of buffers to allocate.
Then vb2_reqbufs() tries to allocate the number of buffers returned in
*buf_count, but it may allocate less if it runs out of memory. If so it
will adjust reqbufs->count accordingly.

Now the driver has to check if reqbufs->count is less than the minimum 
number of buffers required by MFC. If so it has to free the allocated 
buffers and fail with -ENOMEM, as further processing is impossible.
The number of allocated buffers can be smaller than *buf_count set in 
s5p_mfc_buf_negotiate() yet still enough for MFC to work. So I think
this place to set ctx->total_dpb_count is good.

In the scenario you have given as an example the s5p_mfc_buf_negotiate()
would change the value given by the user application from 16 to 15 and 
this would be the number that vb2_reqbufs tries to allocate. If there 
is little memory then it could allocate only 14 buffers, 15 if there is
enough memory. Then ctx->total_dpb_count would be set to reqbufs->count
after call to vb2_reqbufs (which is 14 or 15 depending on the available
memory).

> > +		ret = s5p_mfc_alloc_dec_buffers(ctx);
> > +		if (ret) {
> > +			mfc_err("Failed to allocate decoding buffers.\n");
> > +			reqbufs->count = 0;
> > +			ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
> > +			return -ENOMEM;
> > +		}
> > +		ctx->capture_state = QUEUE_BUFS_REQUESTED;
> > +	}
> > +	mfc_debug("vidioc_reqbufs--\n");
> > +	return ret;
> > +}
> > +

[...]

> > +/* Handle frame decoding interrupt */
> > +static void s5p_mfc_handle_frame_int(struct s5p_mfc_ctx *ctx, \
> > +					unsigned int reason, unsigned int
> err)
> > +{

[...]

> > +	/* A frame has been decoded and is in the buffer  */
> > +	if (dst_frame_status == S5P_FIMV_DEC_STATUS_DISPLAY_ONLY ||
> > +	    dst_frame_status == S5P_FIMV_DEC_STATUS_DECODING_DISPLAY) {
> > +		ctx->sequence++;
> > +		/* If frame is same as previous then skip and do not
> dequeue
> > */
> > +		if (dec_frame_type !=  S5P_FIMV_DECODE_FRAME_SKIPPED) {
> > +		/* The MFC returns address of the buffer, now we have to
> > +		 * check which videobuf does it correspond to */
> > +		list_for_each_entry(dst_buf, &ctx->dst_queue, drv_entry) {
> > +			mfc_debug("Listing: %d\n", dst_buf->v4l2_buf.index);
> > +			/* This is the buffer we're looking for */
> > +			mfc_debug("paddr: %p mfc: %p\n",
> > +					(void *)vb2_plane_paddr(dst_buf, 1),
> > +							(void
> *)dst_ret_addr);
> 
> what is the purpose of this debug message ?
> mfc_debug("paddr: %p mfc: %p\n",(void *)vb2_plane_paddr(dst_buf, 1),
>                                                                 (void
> *)dst_ret_addr);
> do you want to compare Y address?
> it should be like this, vb2_plane_paddr(dst_buf, 0) with dst_ret_addr.
> and dst_y_ret_addr is better than dst_ret_addr,
> making debug msg clear is important 'cause codec debugging is not easy.

You're right that this debug is unclear and displays the wrong value.
Changing dst_ret_addr name to dst_ret_addr_y seems very reasonable to
make the code more clear. I should remove many debug messages before
posting the final version. They were very useful during development,
but they may clutter the code too much.
 
> > +			if (vb2_plane_paddr(dst_buf, 0) == dst_ret_addr) {
> > +				list_del(&dst_buf->drv_entry);
> > +				ctx->dst_queue_cnt--;
> > +				mfc_debug("Flag before: %lx (%d)\n",
> > +							ctx->dec_dst_flag,
> > +						dst_buf->v4l2_buf.index);
> > +				dst_buf->v4l2_buf.sequence = ctx->sequence;


[...]

> > +/* Interrupt processing */
> > +static irqreturn_t s5p_mfc_irq(int irq, void *priv)
> > +{
> > +	struct vb2_buffer *src_buf;
> > +	struct s5p_mfc_ctx *ctx;
> > +	unsigned int reason;
> > +	unsigned int err;
> > +	mfc_debug("s5p_mfc_irq++\n");
> > +	/* Reset the timeout watchdog */
> > +	atomic_set(&dev->watchdog_cnt, 0);
> > +	ctx = dev->ctx[dev->curr_ctx];
> > +	/* Get the reason of interrupt and the error code */
> > +	reason = s5p_mfc_get_int_reason();
> > +	err = s5p_mfc_get_int_err();
> > +	mfc_debug("Int reason: %d (error: %08x)\n", reason, err);
> > +	switch (reason) {
> > +	case S5P_FIMV_R2H_CMD_DECODE_ERR_RET:
> > +		/* An error has occured */
> > +		if (ctx->state == MFCINST_DEC_RUNNING && err >= 145)
> 
> What about using MACRO instead of using 145(no)

Yes, will definitely change this.

[...]

> > +/* MFC probe function */
> > +static int s5p_mfc_probe(struct platform_device *pdev)
> > +{
> > +	struct video_device *vfd;
> > +	struct resource *res;
> > +	int ret = -ENOENT;
> > +	size_t size;
> > +	mfc_debug("s5p_mfc_probe++\n");
> > +	dev = kzalloc(sizeof *dev, GFP_KERNEL);
> > +	if (!dev) {
> > +		dev_err(&pdev->dev, "Not enough memoty for MFC device.\n");
> 
> incorrect spelling (memoty)

Yes, thanks.

[...]

> > diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_logmsg.h
> > b/drivers/media/video/s5p-mfc/s5p_mfc_logmsg.h
> > new file mode 100644
> > index 0000000..90fa84c
> > --- /dev/null
> > +++ b/drivers/media/video/s5p-mfc/s5p_mfc_logmsg.h

[...]

> > +/* Uncomment the line below do enable debug messages */
> > +/* #define CONFIG_VIDEO_MFC50_DEBUG */
> 
> why don't you make configuration(CONFIG_VIDEO_MFC51_DEBUG)
> in the Kconfig.

I am planning to do this as a module parameter, so it could
be set when loading the module.

Best regards,
Kamil Debski
 

