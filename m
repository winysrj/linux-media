Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:42874 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727118AbeINWrT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Sep 2018 18:47:19 -0400
Subject: Re: [PATCH v2 2/2] media: platform: Add Aspeed Video Engine driver
To: Eddie James <eajames@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org,
        linux-aspeed@lists.ozlabs.org, andrew@aj.id.au,
        openbmc@lists.ozlabs.org, robh+dt@kernel.org, mchehab@kernel.org,
        linux-media@vger.kernel.org
References: <1536866964-71593-1-git-send-email-eajames@linux.vnet.ibm.com>
 <1536866964-71593-3-git-send-email-eajames@linux.vnet.ibm.com>
 <d1d58122-976b-b1dd-e4b4-bcc475219925@xs4all.nl>
 <cf333297-cc02-51c7-14a0-4d35bc1f8f07@linux.vnet.ibm.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <66a5fbcf-2b41-ffd5-ad32-f26af47f3cea@xs4all.nl>
Date: Fri, 14 Sep 2018 19:31:44 +0200
MIME-Version: 1.0
In-Reply-To: <cf333297-cc02-51c7-14a0-4d35bc1f8f07@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/14/2018 05:22 PM, Eddie James wrote:
>>> +static int aspeed_video_allocate_cma(struct aspeed_video *video)
>>> +{
>>> +	video->srcs[0].virt = dma_alloc_coherent(video->dev,
>>> +						 VE_SRC_BUFFER_SIZE,
>>> +						 &video->srcs[0].dma,
>>> +						 GFP_KERNEL);
>>> +	if (!video->srcs[0].virt) {
>>> +		dev_err(video->dev,
>>> +			"Failed to allocate source buffer 0, size[%x]\n",
>>> +			VE_SRC_BUFFER_SIZE);
>>> +		goto err;
>>> +	}
>>> +
>>> +	video->srcs[1].virt = dma_alloc_coherent(video->dev,
>>> +						 VE_SRC_BUFFER_SIZE,
>>> +						 &video->srcs[1].dma,
>>> +						 GFP_KERNEL);
>>> +	if (!video->srcs[1].virt) {
>>> +		dev_err(video->dev,
>>> +			"Failed to allocate source buffer 1, size[%x]\n",
>>> +			VE_SRC_BUFFER_SIZE);
>>> +		goto free_src0;
>>> +	}
>>> +
>>> +	video->comp[0].virt = dma_alloc_coherent(video->dev,
>>> +						 VE_COMP_BUFFER_SIZE,
>>> +						 &video->comp[0].dma,
>>> +						 GFP_KERNEL);
>>> +	if (!video->comp[0].virt) {
>>> +		dev_err(video->dev,
>>> +			"Failed to allocate compression buffer 0, size[%x]\n",
>>> +			VE_COMP_BUFFER_SIZE);
>>> +		goto free_src1;
>>> +	}
>>> +
>>> +	video->comp[1].virt = dma_alloc_coherent(video->dev,
>>> +						 VE_COMP_BUFFER_SIZE,
>>> +						 &video->comp[1].dma,
>>> +						 GFP_KERNEL);
>>> +	if (!video->comp[0].virt) {

Should be comp[1]!

>>> +		dev_err(video->dev,
>>> +			"Failed to allocate compression buffer 1, size[%x]\n",
>>> +			VE_COMP_BUFFER_SIZE);
>>> +		goto free_comp0;
>>> +	}
>>> +
>>> +	video->jpeg.virt = dma_alloc_coherent(video->dev, VE_JPEG_BUFFER_SIZE,
>>> +					      &video->jpeg.dma, GFP_KERNEL);
>>> +	if (!video->jpeg.virt) {
>>> +		dev_err(video->dev,
>>> +			"Failed to allocate JPEG buffer, size[%x]\n",
>>> +			VE_JPEG_BUFFER_SIZE);
>>> +		goto free_comp1;
>>> +	}
>> It looks like the buffers are allocated for a worst-case scenario (1080p I think).
>> So for smaller resolutions this wastes memory, but on the other hand you don't
>> need to reallocate buffers when the resolution changes.
>>
>> Am I right?
> 
> That's correct. The other issue is that the buffers must be large enough 
> to capture the frame when detecting the resolution. So at the beginning, 
> they must be maximum size. I suppose once resolution is detected they 
> can be freed and re-allocated for the correct size.

So looking at the code above we have two buffers of size VE_SRC_BUFFER_SIZE,
but what are the other 'comp' buffers and 'jpeg' buffer for?

It looks like this is a two-step process: first capture in the source buffers,
then compress into the 'comp' buffer, and that's then used by read().

I think that the jpeg buffer is for the jpeg header?

When implementing stream I/O you only need to allocate the compressed buffers.
The raw buffers can still be allocated as you do here.

The question with compressed formats is always what a good sizeimage value is,
since it has to be large enough for a worst-case scenario, and that's not
always easy to deduce.

> 
>>
>>> +
>>> +	aspeed_video_init_jpeg_table(video->jpeg.virt, video->yuv420);
>>> +
>>> +	/*
>>> +	 * Calculate the memory restrictions. Don't consider the JPEG header
>>> +	 * buffer since HW doesn't need to write to it.
>>> +	 */
>>> +	video->max = max(video->srcs[0].dma + VE_SRC_BUFFER_SIZE,
>>> +			 video->srcs[1].dma + VE_SRC_BUFFER_SIZE);
>>> +	video->max = max(video->max, video->comp[0].dma + VE_COMP_BUFFER_SIZE);
>>> +	video->max = max(video->max, video->comp[1].dma + VE_COMP_BUFFER_SIZE);
>>> +
>>> +	video->min = min(video->srcs[0].dma, video->srcs[1].dma);
>>> +	video->min = min(video->min, video->comp[0].dma);
>>> +	video->min = min(video->min, video->comp[1].dma);
>>> +
>>> +	return 0;
>>> +
>>> +free_comp1:
>>> +	dma_free_coherent(video->dev, VE_COMP_BUFFER_SIZE, video->comp[1].virt,
>>> +			  video->comp[1].dma);
>>> +	video->comp[1].dma = 0ULL;
>>> +	video->comp[1].virt = NULL;
>>> +
>>> +free_comp0:
>>> +	dma_free_coherent(video->dev, VE_COMP_BUFFER_SIZE, video->comp[0].virt,
>>> +			  video->comp[0].dma);
>>> +	video->comp[0].dma = 0ULL;
>>> +	video->comp[0].virt = NULL;
>>> +
>>> +free_src1:
>>> +	dma_free_coherent(video->dev, VE_SRC_BUFFER_SIZE, video->srcs[1].virt,
>>> +			  video->srcs[1].dma);
>>> +	video->srcs[1].dma = 0ULL;
>>> +	video->srcs[1].virt = NULL;
>>> +
>>> +free_src0:
>>> +	dma_free_coherent(video->dev, VE_SRC_BUFFER_SIZE, video->srcs[0].virt,
>>> +			  video->srcs[0].dma);
>>> +	video->srcs[0].dma = 0ULL;
>>> +	video->srcs[0].virt = NULL;
>>> +err:
>>> +	return -ENOMEM;
>>> +}
>>> +
>>> +static void aspeed_video_free_cma(struct aspeed_video *video)
>>> +{
>>> +	dma_free_coherent(video->dev, VE_JPEG_BUFFER_SIZE, video->jpeg.virt,
>>> +			  video->jpeg.dma);
>>> +	dma_free_coherent(video->dev, VE_COMP_BUFFER_SIZE, video->comp[1].virt,
>>> +			  video->comp[1].dma);
>>> +	dma_free_coherent(video->dev, VE_COMP_BUFFER_SIZE, video->comp[0].virt,
>>> +			  video->comp[0].dma);
>>> +	dma_free_coherent(video->dev, VE_SRC_BUFFER_SIZE, video->srcs[1].virt,
>>> +			  video->srcs[1].dma);
>>> +	dma_free_coherent(video->dev, VE_SRC_BUFFER_SIZE, video->srcs[0].virt,
>>> +			  video->srcs[0].dma);
>>> +
>>> +	video->srcs[0].dma = 0ULL;
>>> +	video->srcs[0].virt = NULL;
>>> +	video->srcs[1].dma = 0ULL;
>>> +	video->srcs[1].virt = NULL;
>>> +	video->comp[0].dma = 0ULL;
>>> +	video->comp[0].virt = NULL;
>>> +	video->comp[1].dma = 0ULL;
>>> +	video->comp[1].virt = NULL;
>>> +	video->jpeg.dma = 0ULL;
>>> +	video->jpeg.virt = NULL;
>>> +}
>>> +
>>> +static int aspeed_video_start(struct aspeed_video *video)
>>> +{
>>> +	int rc = aspeed_video_allocate_cma(video);
>>> +
>>> +	if (rc)
>>> +		return rc;
>>> +
>>> +	aspeed_video_on(video);
>>> +
>>> +	aspeed_video_init_regs(video);
>>> +
>>> +	rc = aspeed_video_get_resolution(video);
>>> +	if (rc)
>>> +		aspeed_video_free_cma(video);
>>> +
>>> +	video->v4l2_fmt.fmt.pix.width = video->width;
>>> +	video->v4l2_fmt.fmt.pix.height = video->height;
>>> +	video->v4l2_fmt.fmt.pix.sizeimage = video->width * video->height * 4;
>> If you use JPEG compression, why is sizeimage set to the raw image size?
>> That's for an extreme case where JPEG can't compress the image at all?
>> But would this be too small in that situation since it doesn't have room
>> for the JPEG header?
> 
> The size of the JPEG frame changes every frame, so this has to be set to 
> the worst-case. I'm not sure if there is any data that JPEG cannot 
> compress at all, but if that was the case then yes, the size would be 
> too small. As the driver currently sits though, it would be larger than 
> the "compressed frame" buffer long before that point though, so you'd 
> just end up with an incomplete JPEG.
>>
>>> +
>>> +	clear_bit(VIDEO_FRAME_TRIGGERED, &video->flags);
>>> +
>>> +	return rc;
>>> +}
>>> +
>>> +static void aspeed_video_stop(struct aspeed_video *video)
>>> +{
>>> +	cancel_delayed_work_sync(&video->res_work);
>>> +
>>> +	aspeed_video_off(video);
>>> +
>>> +	aspeed_video_free_cma(video);
>>> +
>>> +	clear_bit(VIDEO_FRAME_AVAILABLE, &video->flags);
>>> +}
>>> +
>>> +static int aspeed_video_querycap(struct file *file, void *fh,
>>> +				 struct v4l2_capability *cap)
>>> +{
>>> +	strlcpy(cap->driver, DEVICE_NAME, sizeof(cap->driver));
>>> +	strlcpy(cap->card, "Aspeed Video Engine", sizeof(cap->card));
>> Use strscpy instead of strlcpy (just rename).
>>
>> The plan is that strscpy will replace all strcpy, strncpy and strlcpy usages
>> in the kernel.
> 
> Ah, must be a recent change, as you recommended strlcpy last week :)

It is, actually. Just 5 days ago :-)

>>> +static int aspeed_video_set_parm(struct file *file, void *fh,
>>> +				 struct v4l2_streamparm *a)
>>> +{
>>> +	int frame_rate;
>> unsigned int.
>>
>>> +	struct aspeed_video *video = video_drvdata(file);
>>> +
>>> +	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
>>> +		return -EINVAL;
>> Same here: just drop the check, it's not needed.
>>
>>> +
>>> +	a->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
>>> +
>>> +	if (a->parm.capture.timeperframe.numerator) {
>>> +		frame_rate = a->parm.capture.timeperframe.denominator /
>>> +			a->parm.capture.timeperframe.numerator;
>> frame_rate can be 0 if denominator is 0,
>>
>>> +	} else {
>>> +		frame_rate = 0;
>>> +		a->parm.capture.timeperframe.numerator = 1;
>> and then this isn't set to 1.
>>
>> v4l2-compliance was missing a test for this. I've added one, so I think it
>> should now fail when run against this driver. Could you test that?
> 
> Well I had to do this to pass compliance actually, as it failed the test 
> if either denominator or numerator is 0...
> 
>>
>>> +	}
>>> +
>>> +	if (frame_rate < 0 || frame_rate > MAX_FRAME_RATE)
>>> +		frame_rate = 0;
>>> +
>>> +	if (!frame_rate)
>>> +		a->parm.capture.timeperframe.denominator = MAX_FRAME_RATE + 1;
>> Why MAX_FRAME_RATE + 1 and not MAX_FRAME_RATE?
> 
> To get around compliance requiring non-zero and still preserving the 
> frame rate info; if it's greater than frame rate, it gets set to 0.
> 
> We need to be able to set a frame rate of 0, as that tells the engine, 
> "as fast as possible".

Why not set frame_rate <= 0 and frame_rate > MAX_FRAME_RATE to MAX_FRAME_RATE?
And also if both num and demon are 0, then set frame_rate to MAX_FRAME_RATE
as well.

That should work just fine. If v4l2-compliance still complains, let me know
what it says.

> 
>>
>>> +
>>> +	if (video->frame_rate != frame_rate) {
>>> +		video->frame_rate = frame_rate;
>>> +		aspeed_video_update(video, VE_CTRL, ~VE_CTRL_FRC,
>>> +				    FIELD_PREP(VE_CTRL_FRC, frame_rate));
>> So the frame rate is set by userspace and is not related to the actual
>> host graphics framerate?
> 
> Correct.
> 
>>
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int aspeed_video_enum_framesizes(struct file *file, void *fh,
>>> +					struct v4l2_frmsizeenum *fsize)
>>> +{
>>> +	struct aspeed_video *video = video_drvdata(file);
>>> +
>>> +	if (fsize->pixel_format != V4L2_PIX_FMT_JPEG)
>>> +		return -EINVAL;
>>> +
>>> +	switch (fsize->index) {
>>> +	case 0:
>>> +		fsize->discrete.width = video->v4l2_fmt.fmt.pix.width;
>>> +		fsize->discrete.height = video->v4l2_fmt.fmt.pix.height;
>>> +		break;
>>> +	case 1:
>>> +		if (video->width == video->v4l2_fmt.fmt.pix.width &&
>>> +		    video->height == video->v4l2_fmt.fmt.pix.height)
>>> +			return -EINVAL;
>>> +
>>> +		fsize->discrete.width = video->width;
>>> +		fsize->discrete.height = video->height;
>>> +		break;
>>> +	default:
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int aspeed_video_enum_frameintervals(struct file *file, void *fh,
>>> +					    struct v4l2_frmivalenum *fival)
>>> +{
>>> +	struct aspeed_video *video = video_drvdata(file);
>>> +
>>> +	if (fival->index)
>>> +		return -EINVAL;
>>> +
>>> +	if (fival->width != video->width || fival->height != video->height)
>>> +		return -EINVAL;
>>> +
>>> +	if (fival->pixel_format != V4L2_PIX_FMT_JPEG)
>>> +		return -EINVAL;
>>> +
>>> +	fival->type = V4L2_FRMIVAL_TYPE_CONTINUOUS;
>>> +
>>> +	fival->stepwise.min.denominator = MAX_FRAME_RATE;
>>> +	fival->stepwise.min.numerator = 1;
>>> +	fival->stepwise.max.denominator = 1;
>>> +	fival->stepwise.max.numerator = 1;
>>> +	fival->stepwise.step = fival->stepwise.max;
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static const struct v4l2_ioctl_ops aspeed_video_ioctl_ops = {
>>> +	.vidioc_querycap = aspeed_video_querycap,
>>> +	.vidioc_enum_fmt_vid_cap = aspeed_video_enum_format,
>>> +	.vidioc_g_fmt_vid_cap = aspeed_video_get_format,
>>> +	.vidioc_s_fmt_vid_cap = aspeed_video_set_format,
>>> +	.vidioc_try_fmt_vid_cap = aspeed_video_try_format,
>>> +	.vidioc_enum_input = aspeed_video_enum_input,
>>> +	.vidioc_g_input = aspeed_video_get_input,
>>> +	.vidioc_s_input = aspeed_video_set_input,
>>> +	.vidioc_g_parm = aspeed_video_get_parm,
>>> +	.vidioc_s_parm = aspeed_video_set_parm,
>>> +	.vidioc_enum_framesizes = aspeed_video_enum_framesizes,
>>> +	.vidioc_enum_frameintervals = aspeed_video_enum_frameintervals,
>>> +	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
>>> +	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
>>> +};
>>> +
>>> +static void aspeed_video_update_jpeg_quality(struct aspeed_video *video)
>>> +{
>>> +	u32 comp_ctrl = FIELD_PREP(VE_COMP_CTRL_DCT_LUM, video->jpeg_quality) |
>>> +		FIELD_PREP(VE_COMP_CTRL_DCT_CHR, video->jpeg_quality | 0x10);
>>> +
>>> +	aspeed_video_update(video, VE_COMP_CTRL,
>>> +			    ~(VE_COMP_CTRL_DCT_LUM | VE_COMP_CTRL_DCT_CHR),
>>> +			    comp_ctrl);
>>> +}
>>> +
>>> +static void aspeed_video_update_subsampling(struct aspeed_video *video)
>>> +{
>>> +	if (video->jpeg.virt)
>>> +		aspeed_video_init_jpeg_table(video->jpeg.virt, video->yuv420);
>>> +
>>> +	if (video->yuv420)
>>> +		aspeed_video_update(video, VE_SEQ_CTRL, 0xFFFFFFFF,
>>> +				    VE_SEQ_CTRL_YUV420);
>>> +	else
>>> +		aspeed_video_update(video, VE_SEQ_CTRL, ~VE_SEQ_CTRL_YUV420,
>>> +				    0);
>>> +}
>>> +
>>> +static int aspeed_video_set_ctrl(struct v4l2_ctrl *ctrl)
>>> +{
>>> +	struct aspeed_video *video = container_of(ctrl->handler,
>>> +						  struct aspeed_video,
>>> +						  v4l2_ctrl);
>>> +
>>> +	switch (ctrl->id) {
>>> +	case V4L2_CID_JPEG_COMPRESSION_QUALITY:
>>> +		if (video->jpeg_quality != ctrl->val) {
>> No need to check if the value is different: this is only called if the value is
>> indeed different.
>>
>>> +			video->jpeg_quality = ctrl->val;
>>> +			aspeed_video_update_jpeg_quality(video);
>>> +		}
>>> +		break;
>>> +	case V4L2_CID_JPEG_CHROMA_SUBSAMPLING:
>>> +		if (ctrl->val == V4L2_JPEG_CHROMA_SUBSAMPLING_420) {
>>> +			if (!video->yuv420) {
>> Ditto.
>>
>>> +				video->yuv420 = true;
>>> +				aspeed_video_update_subsampling(video);
>>> +			}
>>> +		} else {
>>> +			if (video->yuv420) {
>>> +				video->yuv420 = false;
>>> +				aspeed_video_update_subsampling(video);
>>> +			}
>>> +		}
>>> +		break;
>>> +	default:
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static const struct v4l2_ctrl_ops aspeed_video_ctrl_ops = {
>>> +	.s_ctrl = aspeed_video_set_ctrl,
>>> +};
>>> +
>>> +static void aspeed_video_resolution_work(struct work_struct *work)
>>> +{
>>> +	int rc;
>>> +	struct delayed_work *dwork = to_delayed_work(work);
>>> +	struct aspeed_video *video = container_of(dwork, struct aspeed_video,
>>> +						  res_work);
>>> +
>>> +	/* No clients remaining after delay */
>>> +	if (atomic_read(&video->clients) == 0)
>>> +		goto done;
>>> +
>>> +	aspeed_video_on(video);
>>> +
>>> +	aspeed_video_init_regs(video);
>>> +
>>> +	rc = aspeed_video_get_resolution(video);
>>> +	if (rc) {
>>> +		dev_err(video->dev,
>>> +			"resolution changed; couldn't get new resolution\n");
>>> +	} else {
>>> +		video->frame_idx = 0;
>>> +		clear_bit(VIDEO_FRAME_TRIGGERED, &video->flags);
>>> +	}
>>> +
>>> +done:
>>> +	clear_bit(VIDEO_RES_CHANGE, &video->flags);
>>> +	wake_up_interruptible_all(&video->wait);
>>> +}
>>> +
>>> +static bool aspeed_video_frame_available(struct aspeed_video *video)
>>> +{
>>> +	if (!test_and_clear_bit(VIDEO_FRAME_AVAILABLE, &video->flags)) {
>>> +		if (!test_bit(VIDEO_FRAME_TRIGGERED, &video->flags))
>>> +			aspeed_video_start_frame(video);
>>> +
>>> +		return false;
>>> +	}
>>> +
>>> +	return true;
>>> +}
>>> +
>>> +static ssize_t aspeed_video_file_read(struct file *file, char __user *buf,
>>> +				      size_t count, loff_t *ppos)
>>> +{
>>> +	int rc;
>>> +	int fidx;
>>> +	size_t size;
>>> +	struct aspeed_video *video = video_drvdata(file);
>>> +
>>> +	if (mutex_lock_interruptible(&video->video_lock))
>>> +		return -EINTR;
>>> +
>>> +	if (file->f_flags & O_NONBLOCK) {
>>> +		if (!aspeed_video_frame_available(video)) {
>>> +			rc = -EAGAIN;
>>> +			goto unlock;
>>> +		} else {
>>> +			goto ready;
>>> +		}
>>> +	}
>>> +
>>> +	rc = wait_event_interruptible(video->wait,
>>> +				      aspeed_video_frame_available(video));
>>> +	if (rc) {
>>> +		rc = -EINTR;
>>> +		goto unlock;
>>> +	}
>>> +
>>> +ready:
>>> +	fidx = video->frame_idx;
>>> +	size = min_t(size_t, video->frame_size, count);
>>> +	aspeed_video_start_frame(video);
>>> +
>>> +	if (copy_to_user(buf, video->comp[fidx].virt, size)) {
>>> +		rc = -EFAULT;
>>> +		goto unlock;
>>> +	}
>>> +
>>> +	rc = size;
>>> +
>>> +unlock:
>>> +	mutex_unlock(&video->video_lock);
>>> +	return rc;
>>> +}
>>> +
>>> +static int aspeed_video_open(struct file *file)
>>> +{
>>> +	int rc;
>>> +	struct aspeed_video *video = video_drvdata(file);
>>> +
>>> +	if (atomic_inc_return(&video->clients) == 1) {
>>> +		rc = aspeed_video_start(video);
>>> +		if (rc) {
>>> +			dev_err(video->dev, "Failed to start video engine\n");
>>> +			atomic_dec(&video->clients);
>>> +			return rc;
>>> +		}
>>> +	}
>>> +
>>> +	return v4l2_fh_open(file);
>>> +}
>>> +
>>> +static int aspeed_video_release(struct file *file)
>>> +{
>>> +	int rc;
>>> +	struct aspeed_video *video = video_drvdata(file);
>>> +
>>> +	rc = v4l2_fh_release(file);
>>> +
>>> +	if (atomic_dec_return(&video->clients) == 0)
>>> +		aspeed_video_stop(video);
>>> +
>>> +	return rc;
>>> +}
>>> +
>>> +static const struct v4l2_file_operations aspeed_video_v4l2_fops = {
>>> +	.owner = THIS_MODULE,
>>> +	.read = aspeed_video_file_read,
>>> +	.poll = v4l2_ctrl_poll,
>>> +	.unlocked_ioctl = video_ioctl2,
>>> +	.open = aspeed_video_open,
>>> +	.release = aspeed_video_release,
>>> +};
>>> +
>>> +static void aspeed_video_device_release(struct video_device *vdev)
>>> +{
>>> +}
>>> +
>>> +static int aspeed_video_setup_video(struct aspeed_video *video)
>>> +{
>>> +	int rc;
>>> +	u64 mask = ~(BIT(V4L2_JPEG_CHROMA_SUBSAMPLING_444) |
>>> +		     BIT(V4L2_JPEG_CHROMA_SUBSAMPLING_420));
>>> +	struct v4l2_device *v4l2_dev = &video->v4l2_dev;
>>> +	struct video_device *vdev = &video->vdev;
>>> +
>>> +	rc = v4l2_device_register(video->dev, v4l2_dev);
>>> +	if (rc) {
>>> +		dev_err(video->dev, "Failed to register v4l2 device\n");
>>> +		return rc;
>>> +	}
>>> +
>>> +	vdev->fops = &aspeed_video_v4l2_fops;
>>> +	vdev->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE;
>>> +	vdev->v4l2_dev = v4l2_dev;
>>> +	strncpy(vdev->name, DEVICE_NAME, sizeof(vdev->name));
>> strscpy
>>
>>> +	vdev->vfl_type = VFL_TYPE_GRABBER;
>>> +	vdev->vfl_dir = VFL_DIR_RX;
>>> +	vdev->release = aspeed_video_device_release;
>> Use the video_device_release_empty helper instead. Now you can drop aspeed_video_device_release.
>>
>>> +	vdev->ioctl_ops = &aspeed_video_ioctl_ops;
>>> +	vdev->lock = &video->video_lock;
>>> +
>>> +	video_set_drvdata(vdev, video);
>>> +	rc = video_register_device(vdev, VFL_TYPE_GRABBER, 0);
>> This should be done last in probe(). After this call the video node appears and
>> can be used by userspace, so everything must be fully initialized and that's
>> not the case.
> 
> OK, gotcha.
> 
>>
>>> +	if (rc) {
>>> +		v4l2_device_unregister(v4l2_dev);
>>> +		dev_err(video->dev, "Failed to register video device\n");
>>> +		return rc;
>>> +	}
>>> +
>>> +	video->v4l2_fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>>> +	video->v4l2_fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_JPEG;
>>> +	video->v4l2_fmt.fmt.pix.field = V4L2_FIELD_NONE;
>>> +	video->v4l2_fmt.fmt.pix.colorspace = V4L2_COLORSPACE_JPEG;
>> COLORSPACE_JPEG is deprecated. Use V4L2_COLORSPACE_SRGB for pix.colorspace
>> and set pix.quantization to V4L2_QUANTIZATION_FULL_RANGE.
>>
>>> +
>>> +	/* Don't fail the probe if controls init fails */
>>> +	v4l2_ctrl_handler_init(&video->v4l2_ctrl, 2);
>>> +
>>> +	v4l2_ctrl_new_std(&video->v4l2_ctrl, &aspeed_video_ctrl_ops,
>>> +			  V4L2_CID_JPEG_COMPRESSION_QUALITY, 0,
>>> +			  ASPEED_VIDEO_JPEG_NUM_QUALITIES - 1, 1, 0);
>>> +
>>> +	v4l2_ctrl_new_std_menu(&video->v4l2_ctrl, &aspeed_video_ctrl_ops,
>>> +			       V4L2_CID_JPEG_CHROMA_SUBSAMPLING,
>>> +			       V4L2_JPEG_CHROMA_SUBSAMPLING_420, mask,
>>> +			       V4L2_JPEG_CHROMA_SUBSAMPLING_444);
>>> +
>>> +	if (video->v4l2_ctrl.error) {
>>> +		dev_info(video->dev, "Failed to init controls: %d\n",
>>> +			 video->v4l2_ctrl.error);
>>> +		v4l2_ctrl_handler_free(&video->v4l2_ctrl);
>> You really need to return an error here, you shouldn't continue.
> 
> Well, the JPEG controls aren't strictly necessary right? The driver will 
> operate fine with the default settings.

If this fails, then you are so close to an out-of-memory situation that
things will fail very quickly anyway.

In addition, if you later add new controls and something is wrong in the
control definition, then you wouldn't see that either.

There is no need to be fancy here, an error should be returned.

> 
>>
>>> +	} else {
>>> +		v4l2_dev->ctrl_handler = &video->v4l2_ctrl;
>>> +		vdev->ctrl_handler = &video->v4l2_ctrl;
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int aspeed_video_init(struct aspeed_video *video)
>>> +{
>>> +	int irq;
>>> +	int rc;
>>> +	struct device *dev = video->dev;
>>> +
>>> +	irq = irq_of_parse_and_map(dev->of_node, 0);
>>> +	if (!irq) {
>>> +		dev_err(dev, "Unable to find IRQ\n");
>>> +		return -ENODEV;
>>> +	}
>>> +
>>> +	rc = devm_request_irq(dev, irq, aspeed_video_irq, IRQF_SHARED,
>>> +			      DEVICE_NAME, video);
>>> +	if (rc < 0) {
>>> +		dev_err(dev, "Unable to request IRQ %d\n", irq);
>>> +		return rc;
>>> +	}
>>> +
>>> +	video->eclk = devm_clk_get(dev, "eclk");
>>> +	if (IS_ERR(video->eclk)) {
>>> +		dev_err(dev, "Unable to get ECLK\n");
>>> +		return PTR_ERR(video->eclk);
>>> +	}
>>> +
>>> +	video->vclk = devm_clk_get(dev, "vclk");
>>> +	if (IS_ERR(video->vclk)) {
>>> +		dev_err(dev, "Unable to get VCLK\n");
>>> +		return PTR_ERR(video->vclk);
>>> +	}
>>> +
>>> +	video->rst = devm_reset_control_get_exclusive(dev, NULL);
>>> +	if (IS_ERR(video->rst)) {
>>> +		dev_err(dev, "Unable to get VE reset\n");
>>> +		return PTR_ERR(video->rst);
>>> +	}
>>> +
>>> +	rc = of_reserved_mem_device_init(dev);
>>> +	if (rc) {
>>> +		dev_err(dev, "Unable to reserve memory\n");
>>> +		return rc;
>>> +	}
>>> +
>>> +	rc = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
>>> +	if (rc) {
>>> +		dev_err(dev, "Failed to set DMA mask\n");
>>> +		of_reserved_mem_device_release(dev);
>>> +		return rc;
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int aspeed_video_probe(struct platform_device *pdev)
>>> +{
>>> +	int rc;
>>> +	struct resource *res;
>>> +	struct aspeed_video *video = kzalloc(sizeof(*video), GFP_KERNEL);
>>> +
>>> +	if (!video)
>>> +		return -ENOMEM;
>>> +
>>> +	video->frame_rate = 30;
>>> +	video->dev = &pdev->dev;
>>> +	mutex_init(&video->video_lock);
>>> +	init_waitqueue_head(&video->wait);
>>> +	INIT_DELAYED_WORK(&video->res_work, aspeed_video_resolution_work);
>>> +
>>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>> +
>>> +	video->base = devm_ioremap_resource(video->dev, res);
>>> +
>>> +	if (IS_ERR(video->base))
>>> +		return PTR_ERR(video->base);
>>> +
>>> +	rc = aspeed_video_init(video);
>>> +	if (rc)
>>> +		return rc;
>>> +
>>> +	rc = aspeed_video_setup_video(video);
>>> +	if (rc)
>>> +		return rc;
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int aspeed_video_remove(struct platform_device *pdev)
>>> +{
>>> +	struct device *dev = &pdev->dev;
>>> +	struct v4l2_device *v4l2_dev = dev_get_drvdata(dev);
>>> +	struct aspeed_video *video = to_aspeed_video(v4l2_dev);
>>> +
>>> +	if (video->vdev.ctrl_handler)
>>> +		v4l2_ctrl_handler_free(&video->v4l2_ctrl);
>>> +
>>> +	video_unregister_device(&video->vdev);
>>> +
>>> +	v4l2_device_unregister(v4l2_dev);
>>> +
>>> +	of_reserved_mem_device_release(dev);
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static const struct of_device_id aspeed_video_of_match[] = {
>>> +	{ .compatible = "aspeed,ast2400-video-engine" },
>>> +	{ .compatible = "aspeed,ast2500-video-engine" },
>>> +	{}
>>> +};
>>> +MODULE_DEVICE_TABLE(of, aspeed_video_of_match);
>>> +
>>> +static struct platform_driver aspeed_video_driver = {
>>> +	.driver = {
>>> +		.name = DEVICE_NAME,
>>> +		.of_match_table = aspeed_video_of_match,
>>> +	},
>>> +	.probe = aspeed_video_probe,
>>> +	.remove = aspeed_video_remove,
>>> +};
>>> +
>>> +module_platform_driver(aspeed_video_driver);
>>> +
>>> +MODULE_DESCRIPTION("ASPEED Video Engine Driver");
>>> +MODULE_AUTHOR("Eddie James");
>>> +MODULE_LICENSE("GPL v2");
>>>
>> I don't like the read() API here. It is not a real read() either since it assumes
>> userspace reads full frames at a time. But if you read e.g. one byte at a time,
>> then each byte is just the first byte of a different frame.
> 
> Yea...
> 
>>
>> I think we need to figure out how to make the stream I/O version just as fast
>> if not faster as the read() API.
> 
> OK, I'll see what I can do.
> 
> Thanks for the review!
> Eddie
> 
>>
>> Regards,
>>
>> 	Hans
>>
> 

Regards,

	Hans
