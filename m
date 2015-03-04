Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59383 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265AbbCDLZA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2015 06:25:00 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Michal Simek <michal.simek@xilinx.com>,
	Chris Kohn <christian.kohn@xilinx.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH v5 6/8] v4l: xilinx: Add Xilinx Video IP core
Date: Wed, 04 Mar 2015 13:25:02 +0200
Message-ID: <1490150.jLrV3BijOF@avalon>
In-Reply-To: <54F6D0C0.3030309@xs4all.nl>
References: <1425260925-12064-1-git-send-email-laurent.pinchart@ideasonboard.com> <6955407.oAVS26tV3L@avalon> <54F6D0C0.3030309@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wednesday 04 March 2015 10:30:40 Hans Verkuil wrote:
> On 03/03/15 23:15, Laurent Pinchart wrote:
> > On Tuesday 03 March 2015 12:28:24 Hans Verkuil wrote:
> >> On 03/02/2015 02:48 AM, Laurent Pinchart wrote:
> >>> Xilinx platforms have no hardwired video capture or video processing
> >>> interface. Users create capture and memory to memory processing
> >>> pipelines in the FPGA fabric to suit their particular needs, by
> >>> instantiating video IP cores from a large library.
> >>> 
> >>> The Xilinx Video IP core is a framework that models a video pipeline
> >>> described in the device tree and expose the pipeline to userspace
> >>> through the media controller and V4L2 APIs.
> >>> 
> >>> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >>> Signed-off-by: Hyun Kwon <hyun.kwon@xilinx.com>
> >>> Signed-off-by: Radhey Shyam Pandey <radheys@xilinx.com>
> >>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> >>> 
> >>> ---
> >> 
> >> <snip>
> >> 
> >>> diff --git a/drivers/media/platform/xilinx/xilinx-dma.c
> >>> b/drivers/media/platform/xilinx/xilinx-dma.c new file mode 100644
> >>> index 0000000..afed6c3
> >>> --- /dev/null
> >>> +++ b/drivers/media/platform/xilinx/xilinx-dma.c
> >>> @@ -0,0 +1,753 @@

[snip]

> >>> +static int xvip_dma_start_streaming(struct vb2_queue *vq, unsigned int
> >>> count)
> >>> +{
> >>> +	struct xvip_dma *dma = vb2_get_drv_priv(vq);
> >>> +	struct xvip_dma_buffer *buf, *nbuf;
> >>> +	struct xvip_pipeline *pipe;
> >>> +	int ret;
> >>> +
> >>> +	dma->sequence = 0;
> >>> +
> >>> +	/*
> >>> +	 * Start streaming on the pipeline. No link touching an entity in the
> >>> +	 * pipeline can be activated or deactivated once streaming is
> >>> started.
> >>> +	 *
> >>> +	 * Use the pipeline object embedded in the first DMA object that
> >>> starts
> >>> +	 * streaming.
> >>> +	 */
> >>> +	pipe = dma->video.entity.pipe
> >>> +	     ? to_xvip_pipeline(&dma->video.entity) : &dma->pipe;
> >>> +
> >>> +	ret = media_entity_pipeline_start(&dma->video.entity, &pipe->pipe);
> >>> +	if (ret < 0)
> >>> +		goto error;
> >>> +
> >>> +	/* Verify that the configured format matches the output of the
> >>> +	 * connected subdev.
> >>> +	 */
> >>> +	ret = xvip_dma_verify_format(dma);
> >>> +	if (ret < 0)
> >>> +		goto error_stop;
> >>> +
> >>> +	ret = xvip_pipeline_prepare(pipe, dma);
> >>> +	if (ret < 0)
> >>> +		goto error_stop;
> >>> +
> >>> +	/* Start the DMA engine. This must be done before starting the blocks
> >>> +	 * in the pipeline to avoid DMA synchronization issues.
> >>> +	 */
> >>> +	dma_async_issue_pending(dma->dma);
> >> 
> >> Question: can the DMA engine be started without any buffers queued?
> > 
> > Yes. In that case the dma_async_issue_pending() call will be a no-op, as
> > there will be no pending DMA transfer queued.
> > 
> >> The vb2_queue struct has a min_buffers_needed field that can be set to a
> >> non-zero value. In that case start_streaming won't be called until at
> >> least that many buffers have been queued. Many DMA engines need that so
> >> this was added to the vb2 core to avoid having to hack around this in the
> >> driver.
> > 
> > I don't see a need for that here. I actually think the min_buffers_needed
> > field shouldn't be set, even if it could be set to 1, to avoid reporting
> > VIDIOC_STREAMON errors at VIDIOC_QBUF time. The alternative would be to
> > move the validation code to a custom .video_streamon handler, but that
> > seems pointless to me.
> 
> Would it make sense to add a validate_streamon op to vb2? For devices like
> this that need to validate the pipeline it makes sense that the validation
> happens on VIDIOC_STREAMON. The actual DMA engine start stays with the
> start_streaming op.

It might be useful, but maybe we should wait until we get a couple more 
drivers with similar requirements before implementing it.

For this particular driver I don't see what it would bring though, I don't 
think there's any particular hack to work around the problem on the driver 
side.

> It would be easy to add to vb2.
> 
> >>> +
> >>> +	/* Start the pipeline. */
> >>> +	xvip_pipeline_set_stream(pipe, true);
> >>> +
> >>> +	return 0;
> >>> +
> >>> +error_stop:
> >>> +	media_entity_pipeline_stop(&dma->video.entity);
> >>> +
> >>> +error:
> >>> +	/* Give back all queued buffers to videobuf2. */
> >>> +	spin_lock_irq(&dma->queued_lock);
> >>> +	list_for_each_entry_safe(buf, nbuf, &dma->queued_bufs, queue) {
> >>> +		vb2_buffer_done(&buf->buf, VB2_BUF_STATE_QUEUED);
> >>> +		list_del(&buf->queue);
> >>> +	}
> >>> +	spin_unlock_irq(&dma->queued_lock);
> >>> +
> >>> +	return ret;
> >>> +}
> > 
> > [snip]
> > 
> >>> +/*
> >>> ----------------------------------------------------------------------
> >>> + * V4L2 file operations
> >>> + */
> >>> +
> >>> +static const struct v4l2_file_operations xvip_dma_fops = {
> >>> +	.owner		= THIS_MODULE,
> >>> +	.unlocked_ioctl	= video_ioctl2,
> >>> +	.open		= v4l2_fh_open,
> >>> +	.release	= vb2_fop_release,
> >>> +	.poll		= vb2_fop_poll,
> >>> +	.mmap		= vb2_fop_mmap,
> >> 
> >> I would also add:
> >> 	.read = vb2_fop_read,
> >> 	.write = vb2_fop_write,
> >> 
> >> and add VB2_READ or VB2_WRITE to dma->queue.io_modes.
> >> 
> >> You get it for free, it doesn't take any additional resources, so why
> >> not?
> > 
> > My usual comment : because I'd rather not have users using the read() API
> > with this driver :-) The usual argument of "but then it would be easy to
> > just cat /dev/video? to check whether the device works" doesn't apply
> > here as the pipeline needs to be configured from userspace through V4L2
> > subdev pad ops anyway, so users can as well use a proper V4L2 command
> > line test tool.
>
> Good point. But perhaps it is a good idea to add a comment why
> VB2_READ/WRITE isn't supported, if only to prevent me from asking this
> again in the future :-)

Will do.

-- 
Regards,

Laurent Pinchart

