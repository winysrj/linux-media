Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:44097 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755433Ab3CQVDq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Mar 2013 17:03:46 -0400
Message-ID: <51462FAA.1060400@gmail.com>
Date: Sun, 17 Mar 2013 22:03:38 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	myungjoo.ham@samsung.com, dh09.lee@samsung.com,
	shaik.samsung@gmail.com, arun.kk@samsung.com, a.hajda@samsung.com,
	linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 5/8] s5p-fimc: Add ISP video capture driver stubs
References: <1363031092-29950-1-git-send-email-s.nawrocki@samsung.com> <1363031092-29950-6-git-send-email-s.nawrocki@samsung.com> <201303121544.45438.hverkuil@xs4all.nl>
In-Reply-To: <201303121544.45438.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/12/2013 03:44 PM, Hans Verkuil wrote:
> On Mon 11 March 2013 20:44:49 Sylwester Nawrocki wrote:
[...]
>> +static int isp_video_capture_open(struct file *file)
>> +{
>> +	struct fimc_isp *isp = video_drvdata(file);
>> +	int ret = 0;
>> +
>> +	if (mutex_lock_interruptible(&isp->video_lock))
>> +		return -ERESTARTSYS;
>> +
>> +	/* ret = pm_runtime_get_sync(&isp->pdev->dev); */
>> +	if (ret<  0)
>> +		goto done;
>> +
>> +	ret = v4l2_fh_open(file);
>> +	if (ret<  0)
>> +		goto done;
>> +
>> +	/* TODO: prepare video pipeline */
>> +done:
>> +	mutex_unlock(&isp->video_lock);
>> +	return ret;
>> +}
>> +
>> +static int isp_video_capture_close(struct file *file)
>> +{
>> +	struct fimc_isp *isp = video_drvdata(file);
>> +	int ret = 0;
>> +
>> +	mutex_lock(&isp->video_lock);
>> +
>> +	if (isp->out_path == FIMC_IO_DMA) {
>> +		/* TODO: stop capture, cleanup */
>> +	}
>> +
>> +	/* pm_runtime_put(&isp->pdev->dev); */
>> +
>> +	if (isp->ref_count == 0)
>> +		vb2_queue_release(&isp->capture_vb_queue);
>> +
>> +	ret = v4l2_fh_release(file);
>> +
>> +	mutex_unlock(&isp->video_lock);
>> +	return ret;
>> +}
>> +
>> +static unsigned int isp_video_capture_poll(struct file *file,
>> +				   struct poll_table_struct *wait)
>> +{
>> +	struct fimc_isp *isp = video_drvdata(file);
>> +	int ret;
>> +
>> +	mutex_lock(&isp->video_lock);
>> +	ret = vb2_poll(&isp->capture_vb_queue, file, wait);
>> +	mutex_unlock(&isp->video_lock);
>> +	return ret;
>> +}
>> +
>> +static int isp_video_capture_mmap(struct file *file, struct vm_area_struct *vma)
>> +{
>> +	struct fimc_isp *isp = video_drvdata(file);
>> +	int ret;
>> +
>> +	if (mutex_lock_interruptible(&isp->video_lock))
>> +		return -ERESTARTSYS;
>> +
>> +	ret = vb2_mmap(&isp->capture_vb_queue, vma);
>> +	mutex_unlock(&isp->video_lock);
>> +
>> +	return ret;
>> +}
>> +
>> +static const struct v4l2_file_operations isp_video_capture_fops = {
>> +	.owner		= THIS_MODULE,
>> +	.open		= isp_video_capture_open,
>> +	.release	= isp_video_capture_close,
>> +	.poll		= isp_video_capture_poll,
>> +	.unlocked_ioctl	= video_ioctl2,
>> +	.mmap		= isp_video_capture_mmap,
>
> Can't you use the helper functions vb2_fop_open/release/poll/mmap here?

It seems vb2_fop_mmap/poll can be used directly, open(), release() are
a bit more complicated as some media pipeline operations need to
additionally be done within these callbacks. There is no vb2_fop_open(),
and AFAICS v4l2_fh_open() is sufficient and intended as open() helper.
For the next iteration I have used vb2_fop_release(), called indirectly,
as it nicely simplifies things a bit.

BTW, shouldn't vb2_fop_release() also be taking the lock ? Actually it is
more useful for me in current form, but the drivers that directly assign
it to struct v4l2_file_operations::open might be in trouble, unless I'm
missing something.

>> +};
>> +
>> +/*
>> + * Video node ioctl operations
>> + */
[...]
>> +static int fimc_isp_capture_streamon(struct file *file, void *priv,
>> +				     enum v4l2_buf_type type)
>> +{
>> +	struct fimc_isp *isp = video_drvdata(file);
>> +	struct v4l2_subdev *sensor = isp->pipeline.subdevs[IDX_SENSOR];
>> +	struct fimc_pipeline *p =&isp->pipeline;
>> +	int ret;
>> +
>> +	/* TODO: check if the OTF interface is not running */
>> +
>> +	ret = media_entity_pipeline_start(&sensor->entity, p->m_pipeline);
>> +	if (ret<  0)
>> +		return ret;
>> +
>> +	ret = fimc_isp_pipeline_validate(isp);
>> +	if (ret) {
>> +		media_entity_pipeline_stop(&sensor->entity);
>> +		return ret;
>> +	}
>> +
>> +	return vb2_streamon(&isp->capture_vb_queue, type);
>> +}
>> +
>> +static int fimc_isp_capture_streamoff(struct file *file, void *priv,
>> +				      enum v4l2_buf_type type)
>> +{
>> +	struct fimc_isp *isp = video_drvdata(file);
>> +	struct v4l2_subdev *sd = isp->pipeline.subdevs[IDX_SENSOR];
>> +	int ret;
>> +
>> +	ret = vb2_streamoff(&isp->capture_vb_queue, type);
>> +	if (ret == 0)
>> +		media_entity_pipeline_stop(&sd->entity);
>> +	return ret;
>> +}
>> +
>> +static int fimc_isp_capture_reqbufs(struct file *file, void *priv,
>> +				    struct v4l2_requestbuffers *reqbufs)
>> +{
>> +	struct fimc_isp *isp = video_drvdata(file);
>> +	int ret;
>> +
>> +	reqbufs->count = max_t(u32, FIMC_IS_REQ_BUFS_MIN, reqbufs->count);
>> +	ret = vb2_reqbufs(&isp->capture_vb_queue, reqbufs);
>
> You probably want to call vb2_ioctl_reqbufs here since that does additional
> ownership checks that vb2_reqbufs doesn't.

Yes, thanks for the suggestion. That was actually helpful, previously
it wasn't immediately clear to me one can still take advantage of those
vb2_ioctl_* helpers, mainly have the ownership handling in the core,
and have some handlers assigned directly to v4l2_ioctl_ops an some called
indirectly from the driver's own callbacks, should they need something
else that is done in the helpers.

I found those helpers really useful, especially in drivers that need to
support several video nodes. Lots of boilerplate can be eliminated. And
also vb2_ops_wait_prepare/finish are a simple and nice improvement.

> The same is true for vb2_ioctl_streamon/off, BTW.

Indeed. I have already applied all possible helpers for the next iteration.

I need to yet resolve an issue with locking order, as I previously missed
that media_entity_pipeline_start/stop() also takes the graph mutex.

And currently the driver is supposed to take the graph mutex first and
then the video mutex. Since the link_notify callback of the media device
is called with the graph mutex already held.

The only solution I came up so far is to provide unlocked versions of
media_entity_pipeline_start/stop().

Ideally using video mutex in link_notify() callback should not be needed,
but there are things done there needed for backward video device
compatibility.

--

Regards,
Sylwester
