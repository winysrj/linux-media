Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wj0-f182.google.com ([209.85.210.182]:34843 "EHLO
        mail-wj0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754701AbdAJLYn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jan 2017 06:24:43 -0500
Received: by mail-wj0-f182.google.com with SMTP id i20so80541546wjn.2
        for <linux-media@vger.kernel.org>; Tue, 10 Jan 2017 03:24:42 -0800 (PST)
From: Todor Tomov <todor.tomov@linaro.org>
Subject: Re: [PATCH 08/10] media: camss: Add files which handle the video
 device nodes
To: Hans Verkuil <hverkuil@xs4all.nl>
References: <1480085841-28276-1-git-send-email-todor.tomov@linaro.org>
 <1480085841-28276-7-git-send-email-todor.tomov@linaro.org>
 <9b1cffbc-62a9-c699-5813-189d5f160343@xs4all.nl>
Cc: mchehab@kernel.org, laurent.pinchart+renesas@ideasonboard.com,
        hans.verkuil@cisco.com, javier@osg.samsung.com,
        s.nawrocki@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, bjorn.andersson@linaro.org,
        srinivas.kandagatla@linaro.org
Message-ID: <5874C476.1090204@linaro.org>
Date: Tue, 10 Jan 2017 13:24:38 +0200
MIME-Version: 1.0
In-Reply-To: <9b1cffbc-62a9-c699-5813-189d5f160343@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the extensive review.

On 12/05/2016 03:44 PM, Hans Verkuil wrote:
> A few comments below:
> 
> On 11/25/2016 03:57 PM, Todor Tomov wrote:
>> These files handle the video device nodes of the camss driver.
>>
>> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
>> ---
>>  drivers/media/platform/qcom/camss-8x16/video.c | 597 +++++++++++++++++++++++++
>>  drivers/media/platform/qcom/camss-8x16/video.h |  67 +++
>>  2 files changed, 664 insertions(+)
>>  create mode 100644 drivers/media/platform/qcom/camss-8x16/video.c
>>  create mode 100644 drivers/media/platform/qcom/camss-8x16/video.h
>>
>> diff --git a/drivers/media/platform/qcom/camss-8x16/video.c b/drivers/media/platform/qcom/camss-8x16/video.c
>> new file mode 100644
>> index 0000000..0bf8ea9
>> --- /dev/null
>> +++ b/drivers/media/platform/qcom/camss-8x16/video.c
>> @@ -0,0 +1,597 @@
> 
> <snip>
> 
>> +static int video_start_streaming(struct vb2_queue *q, unsigned int count)
>> +{
>> +	struct camss_video *video = vb2_get_drv_priv(q);
>> +	struct video_device *vdev = video->vdev;
>> +	struct media_entity *entity;
>> +	struct media_pad *pad;
>> +	struct v4l2_subdev *subdev;
>> +	int ret;
>> +
>> +	ret = media_entity_pipeline_start(&vdev->entity, &video->pipe);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	ret = video_check_format(video);
>> +	if (ret < 0)
>> +		goto error;
>> +
>> +	entity = &vdev->entity;
>> +	while (1) {
>> +		pad = &entity->pads[0];
>> +		if (!(pad->flags & MEDIA_PAD_FL_SINK))
>> +			break;
>> +
>> +		pad = media_entity_remote_pad(pad);
>> +		if (!pad || !is_media_entity_v4l2_subdev(pad->entity))
>> +			break;
>> +
>> +		entity = pad->entity;
>> +		subdev = media_entity_to_v4l2_subdev(entity);
>> +
>> +		ret = v4l2_subdev_call(subdev, video, s_stream, 1);
>> +		if (ret < 0 && ret != -ENOIOCTLCMD)
>> +			goto error;
>> +	}
>> +
>> +	return 0;
>> +
>> +error:
>> +	media_entity_pipeline_stop(&vdev->entity);
>> +
> 
> On error all queued buffers must be returned with state VB2_STATE_QUEUED.
> 
> Basically the same as 'camss_video_call(video, flush_buffers);', just with
> a different state.

Ok, I'll add this.

> 
>> +	return ret;
>> +}
> 
> <snip>
> 
>> +static int video_querycap(struct file *file, void *fh,
>> +			  struct v4l2_capability *cap)
>> +{
>> +	strlcpy(cap->driver, "qcom-camss", sizeof(cap->driver));
>> +	strlcpy(cap->card, "Qualcomm Camera Subsystem", sizeof(cap->card));
>> +	strlcpy(cap->bus_info, "platform:qcom-camss", sizeof(cap->bus_info));
>> +	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
>> +							V4L2_CAP_DEVICE_CAPS;
>> +	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
> 
> Don't set capabilities and device_caps here. Instead fill in the struct video_device
> device_caps field and the v4l2 core will take care of cap->capabilities and
> cap->device_caps.

Ok.

> 
>> +
>> +	return 0;
>> +}
>> +
>> +static int video_enum_fmt(struct file *file, void *fh, struct v4l2_fmtdesc *f)
>> +{
>> +	struct camss_video *video = video_drvdata(file);
>> +	struct v4l2_format format;
>> +	int ret;
>> +
>> +	if (f->type != video->type)
>> +		return -EINVAL;
>> +
>> +	if (f->index)
>> +		return -EINVAL;
>> +
>> +	ret = video_get_subdev_format(video, &format);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	f->pixelformat = format.fmt.pix.pixelformat;
>> +
>> +	return 0;
>> +}
>> +
>> +static int video_g_fmt(struct file *file, void *fh, struct v4l2_format *f)
>> +{
>> +	struct camss_video *video = video_drvdata(file);
>> +
>> +	if (f->type != video->type)
>> +		return -EINVAL;
>> +
>> +	*f = video->active_fmt;
>> +
>> +	return 0;
>> +}
>> +
>> +static int video_s_fmt(struct file *file, void *fh, struct v4l2_format *f)
>> +{
>> +	struct camss_video *video = video_drvdata(file);
>> +	int ret;
>> +
>> +	if (f->type != video->type)
>> +		return -EINVAL;
>> +
>> +	ret = video_get_subdev_format(video, f);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	video->active_fmt = *f;
>> +
>> +	return 0;
>> +}
>> +
>> +static int video_try_fmt(struct file *file, void *fh, struct v4l2_format *f)
>> +{
>> +	struct camss_video *video = video_drvdata(file);
>> +
>> +	if (f->type != video->type)
>> +		return -EINVAL;
>> +
>> +	return video_get_subdev_format(video, f);
>> +}
>> +
>> +static int video_enum_input(struct file *file, void *fh,
>> +			    struct v4l2_input *input)
>> +{
>> +	if (input->index > 0)
>> +		return -EINVAL;
>> +
>> +	strlcpy(input->name, "camera", sizeof(input->name));
>> +	input->type = V4L2_INPUT_TYPE_CAMERA;
>> +
>> +	return 0;
>> +}
>> +
>> +static int video_g_input(struct file *file, void *fh, unsigned int *input)
>> +{
>> +	*input = 0;
>> +
>> +	return 0;
>> +}
>> +
>> +static int video_s_input(struct file *file, void *fh, unsigned int input)
>> +{
>> +	return input == 0 ? 0 : -EINVAL;
>> +}
>> +
>> +static const struct v4l2_ioctl_ops msm_vid_ioctl_ops = {
>> +	.vidioc_querycap          = video_querycap,
>> +	.vidioc_enum_fmt_vid_cap  = video_enum_fmt,
>> +	.vidioc_g_fmt_vid_cap     = video_g_fmt,
>> +	.vidioc_s_fmt_vid_cap     = video_s_fmt,
>> +	.vidioc_try_fmt_vid_cap   = video_try_fmt,
>> +	.vidioc_reqbufs           = vb2_ioctl_reqbufs,
>> +	.vidioc_querybuf          = vb2_ioctl_querybuf,
>> +	.vidioc_qbuf              = vb2_ioctl_qbuf,
>> +	.vidioc_dqbuf             = vb2_ioctl_dqbuf,
>> +	.vidioc_create_bufs       = vb2_ioctl_create_bufs,
>> +	.vidioc_streamon          = vb2_ioctl_streamon,
>> +	.vidioc_streamoff         = vb2_ioctl_streamoff,
>> +	.vidioc_enum_input        = video_enum_input,
>> +	.vidioc_g_input           = video_g_input,
>> +	.vidioc_s_input           = video_s_input,
>> +};
>> +
>> +/* -----------------------------------------------------------------------------
>> + * V4L2 file operations
>> + */
>> +
>> +/*
>> + * video_init_format - Helper function to initialize format
>> + *
>> + * Initialize all pad formats with default values.
>> + */
>> +static int video_init_format(struct file *file, void *fh)
>> +{
>> +	struct v4l2_format format;
>> +
>> +	memset(&format, 0, sizeof(format));
>> +	format.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> +
>> +	return video_s_fmt(file, fh, &format);
>> +}
>> +
>> +static int video_open(struct file *file)
>> +{
>> +	struct video_device *vdev = video_devdata(file);
>> +	struct camss_video *video = video_drvdata(file);
>> +	struct camss_video_fh *handle;
>> +	int ret;
>> +
>> +	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
>> +	if (handle == NULL)
>> +		return -ENOMEM;
>> +
>> +	v4l2_fh_init(&handle->vfh, video->vdev);
>> +	v4l2_fh_add(&handle->vfh);
>> +
>> +	handle->video = video;
>> +	file->private_data = &handle->vfh;
>> +
>> +	ret = v4l2_pipeline_pm_use(&vdev->entity, 1);
>> +	if (ret < 0) {
>> +		dev_err(video->camss->dev, "Failed to power up pipeline\n");
>> +		goto error_pm_use;
>> +	}
>> +
>> +	ret = video_init_format(file, &handle->vfh);
>> +	if (ret < 0) {
>> +		dev_err(video->camss->dev, "Failed to init format\n");
>> +		goto error_init_format;
>> +	}
>> +
>> +	return 0;
>> +
>> +error_init_format:
>> +	v4l2_pipeline_pm_use(&vdev->entity, 0);
>> +
>> +error_pm_use:
>> +	v4l2_fh_del(&handle->vfh);
> 
> You're missing a call to v4l2_fh_exit().
> 
>> +	kfree(handle);
> 
> But I would recommend replacing v4l2_fh_del, v4l2_fh_exit and kfree by a single
> call to v4l2_fh_release().

Ok, I'll switch to v4l2_fh_release().

> 
>> +
>> +	return ret;
>> +}
>> +
>> +static int video_release(struct file *file)
>> +{
>> +	struct video_device *vdev = video_devdata(file);
>> +	struct camss_video *video = video_drvdata(file);
>> +	struct v4l2_fh *vfh = file->private_data;
>> +	struct camss_video_fh *handle = container_of(vfh, struct camss_video_fh,
>> +						     vfh);
>> +
>> +	vb2_ioctl_streamoff(file, vfh, video->type);
> 
> Don't call this function, instead call vb2_fop_release().

Ok.

> 
>> +
>> +	v4l2_pipeline_pm_use(&vdev->entity, 0);
>> +
>> +	v4l2_fh_del(vfh);
>> +	kfree(handle);
> 
> These two lines can be dropped as well when you use vb2_fop_release.

Ok.

> 
>> +	file->private_data = NULL;
>> +
>> +	return 0;
>> +}
>> +
>> +static unsigned int video_poll(struct file *file,
>> +				   struct poll_table_struct *wait)
>> +{
>> +	struct camss_video *video = video_drvdata(file);
>> +
>> +	return vb2_poll(&video->vb2_q, file, wait);
>> +}
>> +
>> +static int video_mmap(struct file *file, struct vm_area_struct *vma)
>> +{
>> +	struct camss_video *video = video_drvdata(file);
>> +
>> +	return vb2_mmap(&video->vb2_q, vma);
>> +}
>> +
>> +static const struct v4l2_file_operations msm_vid_fops = {
>> +	.owner          = THIS_MODULE,
>> +	.unlocked_ioctl = video_ioctl2,
>> +	.open           = video_open,
>> +	.release        = video_release,
>> +	.poll           = video_poll,
>> +	.mmap		= video_mmap,
> 
> You should be able to use vb2_fop_poll/mmap here instead of rolling your own.
> I recommend adding vb2_fop_read as well.

Ok. Trying to use vb2_fop_poll makes me realize that I probably have to initialize
video_device->lock before video_register_device() and maybe vb2_queue->lock too.
I'll try with these.

<snip>


-- 
Best regards,
Todor Tomov
