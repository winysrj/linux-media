Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1511 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab3CRMxO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 08:53:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [RFC PATCH 5/8] s5p-fimc: Add ISP video capture driver stubs
Date: Mon, 18 Mar 2013 13:51:31 +0100
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	myungjoo.ham@samsung.com, dh09.lee@samsung.com,
	shaik.samsung@gmail.com, arun.kk@samsung.com, a.hajda@samsung.com,
	linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org,
	linux-arm-kernel@lists.infradead.org
References: <1363031092-29950-1-git-send-email-s.nawrocki@samsung.com> <201303121544.45438.hverkuil@xs4all.nl> <51462FAA.1060400@gmail.com>
In-Reply-To: <51462FAA.1060400@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201303181351.31384.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun March 17 2013 22:03:38 Sylwester Nawrocki wrote:
> On 03/12/2013 03:44 PM, Hans Verkuil wrote:
> > On Mon 11 March 2013 20:44:49 Sylwester Nawrocki wrote:
> [...]
> >> +static int isp_video_capture_open(struct file *file)
> >> +{
> >> +	struct fimc_isp *isp = video_drvdata(file);
> >> +	int ret = 0;
> >> +
> >> +	if (mutex_lock_interruptible(&isp->video_lock))
> >> +		return -ERESTARTSYS;
> >> +
> >> +	/* ret = pm_runtime_get_sync(&isp->pdev->dev); */
> >> +	if (ret<  0)
> >> +		goto done;
> >> +
> >> +	ret = v4l2_fh_open(file);
> >> +	if (ret<  0)
> >> +		goto done;
> >> +
> >> +	/* TODO: prepare video pipeline */
> >> +done:
> >> +	mutex_unlock(&isp->video_lock);
> >> +	return ret;
> >> +}
> >> +
> >> +static int isp_video_capture_close(struct file *file)
> >> +{
> >> +	struct fimc_isp *isp = video_drvdata(file);
> >> +	int ret = 0;
> >> +
> >> +	mutex_lock(&isp->video_lock);
> >> +
> >> +	if (isp->out_path == FIMC_IO_DMA) {
> >> +		/* TODO: stop capture, cleanup */
> >> +	}
> >> +
> >> +	/* pm_runtime_put(&isp->pdev->dev); */
> >> +
> >> +	if (isp->ref_count == 0)
> >> +		vb2_queue_release(&isp->capture_vb_queue);
> >> +
> >> +	ret = v4l2_fh_release(file);
> >> +
> >> +	mutex_unlock(&isp->video_lock);
> >> +	return ret;
> >> +}
> >> +
> >> +static unsigned int isp_video_capture_poll(struct file *file,
> >> +				   struct poll_table_struct *wait)
> >> +{
> >> +	struct fimc_isp *isp = video_drvdata(file);
> >> +	int ret;
> >> +
> >> +	mutex_lock(&isp->video_lock);
> >> +	ret = vb2_poll(&isp->capture_vb_queue, file, wait);
> >> +	mutex_unlock(&isp->video_lock);
> >> +	return ret;
> >> +}
> >> +
> >> +static int isp_video_capture_mmap(struct file *file, struct vm_area_struct *vma)
> >> +{
> >> +	struct fimc_isp *isp = video_drvdata(file);
> >> +	int ret;
> >> +
> >> +	if (mutex_lock_interruptible(&isp->video_lock))
> >> +		return -ERESTARTSYS;
> >> +
> >> +	ret = vb2_mmap(&isp->capture_vb_queue, vma);
> >> +	mutex_unlock(&isp->video_lock);
> >> +
> >> +	return ret;
> >> +}
> >> +
> >> +static const struct v4l2_file_operations isp_video_capture_fops = {
> >> +	.owner		= THIS_MODULE,
> >> +	.open		= isp_video_capture_open,
> >> +	.release	= isp_video_capture_close,
> >> +	.poll		= isp_video_capture_poll,
> >> +	.unlocked_ioctl	= video_ioctl2,
> >> +	.mmap		= isp_video_capture_mmap,
> >
> > Can't you use the helper functions vb2_fop_open/release/poll/mmap here?
> 
> It seems vb2_fop_mmap/poll can be used directly, open(), release() are
> a bit more complicated as some media pipeline operations need to
> additionally be done within these callbacks. There is no vb2_fop_open(),
> and AFAICS v4l2_fh_open() is sufficient and intended as open() helper.

That's correct. Sorry for the misinformation about the non-existant
vb2_fop_open.

> For the next iteration I have used vb2_fop_release(), called indirectly,
> as it nicely simplifies things a bit.
> 
> BTW, shouldn't vb2_fop_release() also be taking the lock ? Actually it is
> more useful for me in current form, but the drivers that directly assign
> it to struct v4l2_file_operations::open might be in trouble, unless I'm
> missing something.

I don't see where a lock would be needed. I don't see any concurrency here.
Nobody else can mess with the queue as long as they are not the owner.

> 
> >> +};
> >> +
> >> +/*
> >> + * Video node ioctl operations
> >> + */
> [...]
> >> +static int fimc_isp_capture_streamon(struct file *file, void *priv,
> >> +				     enum v4l2_buf_type type)
> >> +{
> >> +	struct fimc_isp *isp = video_drvdata(file);
> >> +	struct v4l2_subdev *sensor = isp->pipeline.subdevs[IDX_SENSOR];
> >> +	struct fimc_pipeline *p =&isp->pipeline;
> >> +	int ret;
> >> +
> >> +	/* TODO: check if the OTF interface is not running */
> >> +
> >> +	ret = media_entity_pipeline_start(&sensor->entity, p->m_pipeline);
> >> +	if (ret<  0)
> >> +		return ret;
> >> +
> >> +	ret = fimc_isp_pipeline_validate(isp);
> >> +	if (ret) {
> >> +		media_entity_pipeline_stop(&sensor->entity);
> >> +		return ret;
> >> +	}
> >> +
> >> +	return vb2_streamon(&isp->capture_vb_queue, type);
> >> +}
> >> +
> >> +static int fimc_isp_capture_streamoff(struct file *file, void *priv,
> >> +				      enum v4l2_buf_type type)
> >> +{
> >> +	struct fimc_isp *isp = video_drvdata(file);
> >> +	struct v4l2_subdev *sd = isp->pipeline.subdevs[IDX_SENSOR];
> >> +	int ret;
> >> +
> >> +	ret = vb2_streamoff(&isp->capture_vb_queue, type);
> >> +	if (ret == 0)
> >> +		media_entity_pipeline_stop(&sd->entity);
> >> +	return ret;
> >> +}
> >> +
> >> +static int fimc_isp_capture_reqbufs(struct file *file, void *priv,
> >> +				    struct v4l2_requestbuffers *reqbufs)
> >> +{
> >> +	struct fimc_isp *isp = video_drvdata(file);
> >> +	int ret;
> >> +
> >> +	reqbufs->count = max_t(u32, FIMC_IS_REQ_BUFS_MIN, reqbufs->count);
> >> +	ret = vb2_reqbufs(&isp->capture_vb_queue, reqbufs);
> >
> > You probably want to call vb2_ioctl_reqbufs here since that does additional
> > ownership checks that vb2_reqbufs doesn't.
> 
> Yes, thanks for the suggestion. That was actually helpful, previously
> it wasn't immediately clear to me one can still take advantage of those
> vb2_ioctl_* helpers, mainly have the ownership handling in the core,
> and have some handlers assigned directly to v4l2_ioctl_ops an some called
> indirectly from the driver's own callbacks, should they need something
> else that is done in the helpers.
> 
> I found those helpers really useful, especially in drivers that need to
> support several video nodes. Lots of boilerplate can be eliminated. And
> also vb2_ops_wait_prepare/finish are a simple and nice improvement.

Glad to hear!

I still think there are some more improvements that could be made with some
helper functions and perhaps some more fields: most (all?) drivers need a
list for their active buffers, so I really think adding a struct list to
vb2_buffer and a list for active buffers + a spinlock to vb2_queue would
help.

Helper functions could then be added to handle that queue and also to set
the timestamp and sequence fields. I would need to think more about the
details, but after using vb2 for a while I see a lot of shared code between
the various drivers.

Regards,

	Hans

> > The same is true for vb2_ioctl_streamon/off, BTW.
> 
> Indeed. I have already applied all possible helpers for the next iteration.
> 
> I need to yet resolve an issue with locking order, as I previously missed
> that media_entity_pipeline_start/stop() also takes the graph mutex.
> 
> And currently the driver is supposed to take the graph mutex first and
> then the video mutex. Since the link_notify callback of the media device
> is called with the graph mutex already held.
> 
> The only solution I came up so far is to provide unlocked versions of
> media_entity_pipeline_start/stop().
> 
> Ideally using video mutex in link_notify() callback should not be needed,
> but there are things done there needed for backward video device
> compatibility.
> 
> --
> 
> Regards,
> Sylwester
> 
