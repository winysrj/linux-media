Return-path: <mchehab@pedra>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:48240 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778Ab1ANHYS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jan 2011 02:24:18 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Date: Fri, 14 Jan 2011 16:24:09 +0900
From: Kamil Debski <k.debski@samsung.com>
Subject: RE: [RFC/PATCH v6 3/4] MFC: Add MFC 5.1 V4L2 driver
In-reply-to: <008001cbb307$6f8cea00$4ea6be00$%han@samsung.com>
To: 'Jonghun Han' <jonghun.han@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, pawel@osciak.com,
	kyungmin.park@samsung.com, jaeryul.oh@samsung.com,
	kgene.kim@samsung.com
Message-id: <001d01cbb3bc$0be39980$23aacc80$%debski@samsung.com>
Content-language: en-gb
References: <1294417534-3856-1-git-send-email-k.debski@samsung.com>
 <1294417534-3856-4-git-send-email-k.debski@samsung.com>
 <008001cbb307$6f8cea00$4ea6be00$%han@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

> -----Original Message-----
> From: Jonghun Han [mailto:jonghun.han@samsung.com]
> 
> Hi,
> 
> Kamil Debski wrote:
> 
> <snip>
> 
> > +/* Reqeust buffers */
> > +static int vidioc_reqbufs(struct file *file, void *priv,
> > +					  struct v4l2_requestbuffers
> *reqbufs)
> > +{
> > +	struct s5p_mfc_dev *dev = video_drvdata(file);
> > +	struct s5p_mfc_ctx *ctx = priv;
> > +	int ret = 0;
> > +	unsigned long flags;
> > +
> > +	mfc_debug_enter();
> > +	mfc_debug("Memory type: %d\n", reqbufs->memory);
> > +	if (reqbufs->memory != V4L2_MEMORY_MMAP) {
> > +		mfc_err("Only V4L2_MEMORY_MAP is supported.\n");
> > +		return -EINVAL;
> > +	}
> > +	if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> > +		/* Can only request buffers after an instance has been
> opened.*/
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
> > +	} else if (reqbufs->type ==
> > V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> > +		if (ctx->capture_state != QUEUE_FREE) {
> > +			mfc_err("Bufs have already been requested.\n");
> > +			return -EINVAL;
> > +		}
> > +		ctx->capture_state = QUEUE_BUFS_REQUESTED;
> > +		ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
> > +		if (ret) {
> > +			mfc_err("vb2_reqbufs on capture failed.\n");
> > +			return ret;
> > +		}
> > +		if (reqbufs->count < ctx->dpb_count) {
> > +			mfc_err("Not enough buffers allocated.\n");
> > +			reqbufs->count = 0;
> > +			ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
> > +			return -ENOMEM;
> > +		}
> > +		ctx->total_dpb_count = reqbufs->count;
> > +		ret = s5p_mfc_alloc_dec_buffers(ctx);
> > +		if (ret) {
> > +			mfc_err("Failed to allocate decoding buffers.\n");
> > +			reqbufs->count = 0;
> > +			ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
> > +			return -ENOMEM;
> > +		}
> > +		if (ctx->dst_bufs_cnt == ctx->total_dpb_count) {
> > +			ctx->capture_state = QUEUE_BUFS_MMAPED;
> > +		} else {
> > +			mfc_err("Not all buffers passed to buf_init.\n");
> > +			reqbufs->count = 0;
> > +			ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
> > +			s5p_mfc_release_dec_buffers(ctx);
> > +			return -ENOMEM;
> > +		}
> > +		if (s5p_mfc_ctx_ready(ctx)) {
> > +			spin_lock_irqsave(&dev->condlock, flags);
> > +			set_bit(ctx->num, &dev->ctx_work_bits);
> > +			spin_unlock_irqrestore(&dev->condlock, flags);
> > +		}
> > +		s5p_mfc_try_run(dev);
> > +		s5p_mfc_wait_for_done_ctx(ctx,
> > +
> > S5P_FIMV_R2H_CMD_INIT_BUFFERS_RET, 1);
> > +	}
> > +	mfc_debug_leave();
> > +	return ret;
> > +}
> 
> I don't know how to handle the followings.
> 
> So I suggest that in reqbufs->type == V4L2_BUF_TYPE_VIDEO_OUTPUT case,
> how about return -EINVAL if reqbufs->count is bigger than 1.
> 
> Because if reqbufs->count is bigger than 1, it is hard to handle the
> encoded
> input stream.
> 
> For example: Dynamic resolution change
> Dynamic resolution change means that resolution can be changed at any
> I-frame with header on the fly during streaming.
> 
> MFC H/W can detect it after getting decoding command from the driver.
> If the dynamic resolution change is detected by MFC H/W,
> driver should let application know the fact to do the following
> Sequence 1
> by application.
> 
> Sequence 1:
> streamoff -> munmap -> reqbufs(0) -> S_FMT(changed resolution) ->
> querybuf
> -> mmap -> re-QBUF with the I-frame -> STREAMON -> ...
> 
> Why it is hard to handle the encoded input stream in multiple input
> stream
> case is the following Sequence 2.
> 
> Sequence 2:
> QBUF(0) -> QBUF(1: resolution changed I-frame) -> QBUF(2: already
> changed)
> -> QBUF(3: already changed) -> DQBUF(0) -> DQBUF(1): return fail -> ...
> 
> Application cannot know the resolution change in the QBUF ioctl.
> Driver will return 0 at the QBUF because all parameters are fine.
> But after sending the decode command to MFC H/W, driver can know that
> the
> I-frame needs to change resolution.
> In that case driver can return error at the DQBUF of the buffer.
> 
> In the sequence 2, application can know the resolution change in the
> DQBUF(1).
> So the application should re-QBUF the buffer 2, 3 after Sequence 1.
> It is hard to re-control the buffers which are already queued in the
> point
> of application.
> Because in the reqbufs(0) buffers will be freed.
> So application has to copy them to the temporary buffer to re-QBUF
> after
> Sequence 1.
> 
> How can we solve this case ?

There are two buffer queues - the OUTPUT is the queue for the compressed
source. I don't see the need to do anything with this queue when resolution
is changed.

There could be 3 src buffers queued for example. Let's say the first is an
I-frame
with changed resolution. This does not affect the following source buffers.
I
agree with you that it will have impact on the destination (CAPTURE)
buffers.
The problem is how to notify the application that the resolution has been
changed.

After the application is notified by the driver that resolution has been
changed it has to do the following:
1. DQBUF all the remaining destination CAPTURE buffers (with old resolution)
2. Do stream off on CAPUTRE
3. unmap all the CAPTURE buffers
4. REQBUFS(0) on CAPTURE
5. G_FMT on CAPTURE to get the new resolution
6. REQBUFS(n) on CAPTURE
7. mmap the CAPTURE buffers
8. QBUF all the new CAPTURE buffers
9. Do stream on on CAPTURE

As you can see, the OUTPUT queue has not been modified. All the 3 source
buffers
are still queued until after step 9 when the processing restarts.

>From the driver perspective it looks like this:
a) After it has received DISP_STATUS [5:4] != 0 it sends the
FRAME_START_REALLOC
command. Then it behave the same as if the stream was finished - running
FRAME_START
and returning the remaining buffers. This is the step 1 for application
described above.
b) When no more buffers are left (DISP_STATUS[2:0]= 3) it has to notify the
application
that the resolution have changed. I will discuss how to do it below.
c) The application was notified and completed steps 2-4, at this time the
driver has to
reinitialize the stream. Here it will use the source buffer that had
resolution change
again with command INIT_CODEC.
d) The instance is reinitialized, and new resolution is read from MFC. The
application now
completes steps 5-9.
e) As destination (CAPTURE) buffers are now queued the driver continues
decoding.
FRAME_START command is issued for the source buffer that had resolution
change and it is
decoded. This is the place when this source buffer is marked as done and it
can be dequeued
by the application.

As you can see - there was no need to reinitialize the OUTPUT queue. Only
CAPTURE, so there
is no need to restrict number of source (OUTPUT) buffers to 1.

The question is how to notify the application. I think I could be done same
as end of stream
notification - by returning a buffer with size equal to 0.
If the application knows that source stream has ended, and queued a source
buffer of size 0
to notify the driver - then a destination buffer of size 0 means that
decoding is finished. 
In case of resolution change the application still has source buffers queued
and it receives
a destination buffer with size=0. Knowing this the application can do the
resolution change
procedure.

I welcome your comments.

Best regards,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center

