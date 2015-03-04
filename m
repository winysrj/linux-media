Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:52636 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751690AbbCDJbA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Mar 2015 04:31:00 -0500
Message-ID: <54F6D0C0.3030309@xs4all.nl>
Date: Wed, 04 Mar 2015 10:30:40 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org,
	Michal Simek <michal.simek@xilinx.com>,
	Chris Kohn <christian.kohn@xilinx.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH v5 6/8] v4l: xilinx: Add Xilinx Video IP core
References: <1425260925-12064-1-git-send-email-laurent.pinchart@ideasonboard.com> <1425260925-12064-7-git-send-email-laurent.pinchart@ideasonboard.com> <54F59AD8.6080903@xs4all.nl> <6955407.oAVS26tV3L@avalon>
In-Reply-To: <6955407.oAVS26tV3L@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/03/15 23:15, Laurent Pinchart wrote:
> Hi Hans,
> 
> Thank you for the review.
> 
> On Tuesday 03 March 2015 12:28:24 Hans Verkuil wrote:
>> Hi Laurent,
>>
>> Thanks for this patch. I do have a few comments, see below. Note that I am
>> OK with the new DT format description.
>>
>> On 03/02/2015 02:48 AM, Laurent Pinchart wrote:
>>> Xilinx platforms have no hardwired video capture or video processing
>>> interface. Users create capture and memory to memory processing
>>> pipelines in the FPGA fabric to suit their particular needs, by
>>> instantiating video IP cores from a large library.
>>>
>>> The Xilinx Video IP core is a framework that models a video pipeline
>>> described in the device tree and expose the pipeline to userspace
>>> through the media controller and V4L2 APIs.
>>>
>>> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>> Signed-off-by: Hyun Kwon <hyun.kwon@xilinx.com>
>>> Signed-off-by: Radhey Shyam Pandey <radheys@xilinx.com>
>>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
>>>
>>> ---
>>
>> <snip>
>>
>>> diff --git a/drivers/media/platform/xilinx/xilinx-dma.c
>>> b/drivers/media/platform/xilinx/xilinx-dma.c new file mode 100644
>>> index 0000000..afed6c3
>>> --- /dev/null
>>> +++ b/drivers/media/platform/xilinx/xilinx-dma.c
>>> @@ -0,0 +1,753 @@
> 
> [snip]
> 
>>> +static void xvip_dma_complete(void *param)
>>> +{
>>> +	struct xvip_dma_buffer *buf = param;
>>> +	struct xvip_dma *dma = buf->dma;
>>> +
>>> +	spin_lock(&dma->queued_lock);
>>> +	list_del(&buf->queue);
>>> +	spin_unlock(&dma->queued_lock);
>>> +
>>> +	buf->buf.v4l2_buf.sequence = dma->sequence++;
>>
>> buf->buf.v4l2_buf.field isn't set. I think you only support progressive
>> formats at the moment, so this should be set to V4L2_FIELD_NONE.
> 
> Agreed, that was an oversight. I'll fix it.
> 
>>> +	v4l2_get_timestamp(&buf->buf.v4l2_buf.timestamp);
>>> +	vb2_set_plane_payload(&buf->buf, 0, dma->format.sizeimage);
>>> +	vb2_buffer_done(&buf->buf, VB2_BUF_STATE_DONE);
>>> +}
>>> +
>>> +static int
>>> +xvip_dma_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
>>> +		     unsigned int *nbuffers, unsigned int *nplanes,
>>> +		     unsigned int sizes[], void *alloc_ctxs[])
>>> +{
>>> +	struct xvip_dma *dma = vb2_get_drv_priv(vq);
>>> +
>>> +	*nplanes = 1;
>>> +
>>> +	sizes[0] = dma->format.sizeimage;
>>
>> I would suggest that you add support for vb2_ioctl_create_bufs by changing
>> this code to:
>>
>> 	if (fmt && fmt->fmt.pix.sizeimage < dma->format.sizeimage)
>>                 return -EINVAL;
>> 	sizes[0] = fmt ? fmt->fmt.pix.sizeimage : dma->format.sizeimage;
> 
> Looks good, I'll fix that.
> 
>>> +	alloc_ctxs[0] = dma->alloc_ctx;
>>> +
>>> +	return 0;
>>> +}
> 
> [snip]
> 
>>> +static int xvip_dma_start_streaming(struct vb2_queue *vq, unsigned int
>>> count) +{
>>> +	struct xvip_dma *dma = vb2_get_drv_priv(vq);
>>> +	struct xvip_dma_buffer *buf, *nbuf;
>>> +	struct xvip_pipeline *pipe;
>>> +	int ret;
>>> +
>>> +	dma->sequence = 0;
>>> +
>>> +	/*
>>> +	 * Start streaming on the pipeline. No link touching an entity in the
>>> +	 * pipeline can be activated or deactivated once streaming is 
> started.
>>> +	 *
>>> +	 * Use the pipeline object embedded in the first DMA object that 
> starts
>>> +	 * streaming.
>>> +	 */
>>> +	pipe = dma->video.entity.pipe
>>> +	     ? to_xvip_pipeline(&dma->video.entity) : &dma->pipe;
>>> +
>>> +	ret = media_entity_pipeline_start(&dma->video.entity, &pipe->pipe);
>>> +	if (ret < 0)
>>> +		goto error;
>>> +
>>> +	/* Verify that the configured format matches the output of the
>>> +	 * connected subdev.
>>> +	 */
>>> +	ret = xvip_dma_verify_format(dma);
>>> +	if (ret < 0)
>>> +		goto error_stop;
>>> +
>>> +	ret = xvip_pipeline_prepare(pipe, dma);
>>> +	if (ret < 0)
>>> +		goto error_stop;
>>> +
>>> +	/* Start the DMA engine. This must be done before starting the blocks
>>> +	 * in the pipeline to avoid DMA synchronization issues.
>>> +	 */
>>> +	dma_async_issue_pending(dma->dma);
>>
>> Question: can the DMA engine be started without any buffers queued?
> 
> Yes. In that case the dma_async_issue_pending() call will be a no-op, as there 
> will be no pending DMA transfer queued.
> 
>> The vb2_queue struct has a min_buffers_needed field that can be set to a
>> non-zero value. In that case start_streaming won't be called until at least
>> that many buffers have been queued. Many DMA engines need that so this was
>> added to the vb2 core to avoid having to hack around this in the driver.
> 
> I don't see a need for that here. I actually think the min_buffers_needed 
> field shouldn't be set, even if it could be set to 1, to avoid reporting 
> VIDIOC_STREAMON errors at VIDIOC_QBUF time. The alternative would be to move 
> the validation code to a custom .video_streamon handler, but that seems 
> pointless to me.

Would it make sense to add a validate_streamon op to vb2? For devices like
this that need to validate the pipeline it makes sense that the validation
happens on VIDIOC_STREAMON. The actual DMA engine start stays with the
start_streaming op.

It would be easy to add to vb2.

> 
>>> +
>>> +	/* Start the pipeline. */
>>> +	xvip_pipeline_set_stream(pipe, true);
>>> +
>>> +	return 0;
>>> +
>>> +error_stop:
>>> +	media_entity_pipeline_stop(&dma->video.entity);
>>> +
>>> +error:
>>> +	/* Give back all queued buffers to videobuf2. */
>>> +	spin_lock_irq(&dma->queued_lock);
>>> +	list_for_each_entry_safe(buf, nbuf, &dma->queued_bufs, queue) {
>>> +		vb2_buffer_done(&buf->buf, VB2_BUF_STATE_QUEUED);
>>> +		list_del(&buf->queue);
>>> +	}
>>> +	spin_unlock_irq(&dma->queued_lock);
>>> +
>>> +	return ret;
>>> +}
> 
> [snip]
> 
>>> +/* ----------------------------------------------------------------------
>>> + * V4L2 file operations
>>> + */
>>> +
>>> +static const struct v4l2_file_operations xvip_dma_fops = {
>>> +	.owner		= THIS_MODULE,
>>> +	.unlocked_ioctl	= video_ioctl2,
>>> +	.open		= v4l2_fh_open,
>>> +	.release	= vb2_fop_release,
>>> +	.poll		= vb2_fop_poll,
>>> +	.mmap		= vb2_fop_mmap,
>>
>> I would also add:
>>
>> 	.read = vb2_fop_read,
>> 	.write = vb2_fop_write,
>>
>> and add VB2_READ or VB2_WRITE to dma->queue.io_modes.
>>
>> You get it for free, it doesn't take any additional resources, so why not?
> 
> My usual comment : because I'd rather not have users using the read() API with 
> this driver :-) The usual argument of "but then it would be easy to just cat 
> /dev/video? to check whether the device works" doesn't apply here as the 
> pipeline needs to be configured from userspace through V4L2 subdev pad ops 
> anyway, so users can as well use a proper V4L2 command line test tool.

Good point. But perhaps it is a good idea to add a comment why VB2_READ/WRITE
isn't supported, if only to prevent me from asking this again in the future :-)

> 
>> However, to make that work correctly you need this patch:
>>
>> https://patchwork.linuxtv.org/patch/28478/
>>
>> It would make sense if you just add that patch to your xilinx tree.

I'll take this patch. It's still useful, but not for this driver.

Regards,

	Hans

