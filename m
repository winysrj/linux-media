Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:55636 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750867AbdEEKyQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 May 2017 06:54:16 -0400
Subject: Re: [PATCH v4 2/8] [media] stm32-dcmi: STM32 DCMI camera interface
 driver
To: Hugues Fruchet <hugues.fruchet@st.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1492704445-22186-1-git-send-email-hugues.fruchet@st.com>
 <1492704445-22186-3-git-send-email-hugues.fruchet@st.com>
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <6d5963af-747e-8cda-4ce2-2f10fe367cf0@xs4all.nl>
Date: Fri, 5 May 2017 12:54:02 +0200
MIME-Version: 1.0
In-Reply-To: <1492704445-22186-3-git-send-email-hugues.fruchet@st.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hugues,

I found a few small things that should be fixed first. It should all be
easy and quick to fix.

On 04/20/17 18:07, Hugues Fruchet wrote:
> This V4L2 subdev driver enables Digital Camera Memory Interface (DCMI)
> of STMicroelectronics STM32 SoC series.
> 
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> Signed-off-by: Yannick Fertre <yannick.fertre@st.com>
> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> ---
>  drivers/media/platform/Kconfig            |   12 +
>  drivers/media/platform/Makefile           |    2 +
>  drivers/media/platform/stm32/Makefile     |    1 +
>  drivers/media/platform/stm32/stm32-dcmi.c | 1419 +++++++++++++++++++++++++++++
>  4 files changed, 1434 insertions(+)
>  create mode 100644 drivers/media/platform/stm32/Makefile
>  create mode 100644 drivers/media/platform/stm32/stm32-dcmi.c
> 

> diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
> new file mode 100644
> index 0000000..0ed3bd9
> --- /dev/null
> +++ b/drivers/media/platform/stm32/stm32-dcmi.c
> @@ -0,0 +1,1419 @@

...

> +static int dcmi_start_streaming(struct vb2_queue *vq, unsigned int count)
> +{
> +	struct stm32_dcmi *dcmi = vb2_get_drv_priv(vq);
> +	struct dcmi_buf *buf, *node;
> +	u32 val;
> +	int ret;
> +
> +	/* Enable stream on the sub device */
> +	ret = v4l2_subdev_call(dcmi->entity.subdev, video, s_stream, 1);
> +	if (ret && ret != -ENOIOCTLCMD) {
> +		dev_err(dcmi->dev, "%s: Failed to start streaming, subdev streamon error",
> +			__func__);
> +		goto err_release_buffers;
> +	}
> +
> +	if (clk_enable(dcmi->mclk)) {
> +		dev_err(dcmi->dev, "%s: Failed to start streaming, cannot enable clock",
> +			__func__);
> +		goto err_subdev_streamoff;
> +	}

It feels more natural to me to first enable the clock, then call s_stream.

It seems what stop_streaming expects as well, since that disables the clock last,
so here you would expect to see the opposite: the clock is enabled first.

> +
> +	spin_lock_irq(&dcmi->irqlock);
> +
> +	val = reg_read(dcmi->regs, DCMI_CR);
> +
> +	val &= ~(CR_PCKPOL | CR_HSPOL | CR_VSPOL |
> +		 CR_EDM_0 | CR_EDM_1 | CR_FCRC_0 |
> +		 CR_FCRC_1 | CR_JPEG | CR_ESS);
> +
> +	/* Set bus width */
> +	switch (dcmi->bus.bus_width) {
> +	case 14:
> +		val &= CR_EDM_0 + CR_EDM_1;
> +		break;
> +	case 12:
> +		val &= CR_EDM_1;
> +		break;
> +	case 10:
> +		val &= CR_EDM_0;
> +		break;
> +	default:
> +		/* Set bus width to 8 bits by default */
> +		break;
> +	}
> +
> +	/* Set vertical synchronization polarity */
> +	if (dcmi->bus.flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH)
> +		val |= CR_VSPOL;
> +
> +	/* Set horizontal synchronization polarity */
> +	if (dcmi->bus.flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH)
> +		val |= CR_HSPOL;
> +
> +	/* Set pixel clock polarity */
> +	if (dcmi->bus.flags & V4L2_MBUS_PCLK_SAMPLE_RISING)
> +		val |= CR_PCKPOL;
> +
> +	reg_write(dcmi->regs, DCMI_CR, val);
> +
> +	/* Enable dcmi */
> +	reg_set(dcmi->regs, DCMI_CR, CR_ENABLE);
> +
> +	dcmi->state = RUNNING;
> +
> +	dcmi->sequence = 0;
> +	dcmi->errors_count = 0;
> +	dcmi->buffers_count = 0;
> +	dcmi->active = NULL;
> +
> +	/*
> +	 * Start transfer if at least one buffer has been queued,
> +	 * otherwise transfer is defered at buffer queueing

typo: defered -> deferred

> +	 */
> +	if (list_empty(&dcmi->buffers)) {
> +		dev_dbg(dcmi->dev, "Start streaming is defered to next buffer queueing\n");

ditto (do a search & replace)

> +		spin_unlock_irq(&dcmi->irqlock);
> +		return 0;
> +	}
> +
> +	dcmi->active = list_entry(dcmi->buffers.next, struct dcmi_buf, list);
> +	list_del_init(&dcmi->active->list);
> +
> +	dev_dbg(dcmi->dev, "Start streaming, starting capture\n");
> +
> +	ret = dcmi_start_capture(dcmi);
> +	if (ret) {
> +		dev_err(dcmi->dev, "%s: Start streaming failed, cannot start capture",
> +			__func__);
> +
> +		spin_unlock_irq(&dcmi->irqlock);

The clock isn't disabled in this error path.

> +		goto err_subdev_streamoff;
> +	}
> +
> +	/* Enable interruptions */
> +	reg_set(dcmi->regs, DCMI_IER, IT_FRAME | IT_OVR | IT_ERR);
> +
> +	spin_unlock_irq(&dcmi->irqlock);
> +
> +	return 0;
> +
> +err_subdev_streamoff:
> +	v4l2_subdev_call(dcmi->entity.subdev, video, s_stream, 0);
> +
> +err_release_buffers:
> +	spin_lock_irq(&dcmi->irqlock);
> +	/*
> +	 * Return all buffers to vb2 in QUEUED state.
> +	 * This will give ownership back to userspace
> +	 */
> +	if (dcmi->active) {
> +		buf = dcmi->active;
> +		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_QUEUED);
> +		dcmi->active = NULL;
> +	}
> +	list_for_each_entry_safe(buf, node, &dcmi->buffers, list) {
> +		list_del_init(&buf->list);
> +		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_QUEUED);
> +	}
> +	spin_unlock_irq(&dcmi->irqlock);
> +
> +	return ret;
> +}
> +
> +static void dcmi_stop_streaming(struct vb2_queue *vq)
> +{
> +	struct stm32_dcmi *dcmi = vb2_get_drv_priv(vq);
> +	struct dcmi_buf *buf, *node;
> +	unsigned long time_ms = msecs_to_jiffies(TIMEOUT_MS);
> +	long timeout;
> +	int ret;
> +
> +	/* Disable stream on the sub device */
> +	ret = v4l2_subdev_call(dcmi->entity.subdev, video, s_stream, 0);
> +	if (ret && ret != -ENOIOCTLCMD)
> +		dev_err(dcmi->dev, "stream off failed in subdev\n");
> +
> +	dcmi->state = STOPPING;
> +
> +	timeout = wait_for_completion_interruptible_timeout(&dcmi->complete,
> +							    time_ms);
> +
> +	spin_lock_irq(&dcmi->irqlock);
> +
> +	/* Disable interruptions */
> +	reg_clear(dcmi->regs, DCMI_IER, IT_FRAME | IT_OVR | IT_ERR);
> +
> +	/* Disable DCMI */
> +	reg_clear(dcmi->regs, DCMI_CR, CR_ENABLE);
> +
> +	if (!timeout) {
> +		dev_err(dcmi->dev, "Timeout during stop streaming\n");
> +		dcmi->state = STOPPED;
> +	}
> +
> +	/* Return all queued buffers to vb2 in ERROR state */
> +	if (dcmi->active) {
> +		buf = dcmi->active;
> +		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
> +		dcmi->active = NULL;
> +	}
> +	list_for_each_entry_safe(buf, node, &dcmi->buffers, list) {
> +		list_del_init(&buf->list);
> +		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
> +	}
> +
> +	spin_unlock_irq(&dcmi->irqlock);
> +
> +	/* Stop all pending DMA operations */
> +	dmaengine_terminate_all(dcmi->dma_chan);
> +
> +	clk_disable(dcmi->mclk);
> +
> +	dev_dbg(dcmi->dev, "Stop streaming, errors=%d buffers=%d\n",
> +		dcmi->errors_count, dcmi->buffers_count);
> +}
> +
> +static struct vb2_ops dcmi_video_qops = {
> +	.queue_setup		= dcmi_queue_setup,
> +	.buf_init		= dcmi_buf_init,
> +	.buf_prepare		= dcmi_buf_prepare,
> +	.buf_queue		= dcmi_buf_queue,
> +	.start_streaming	= dcmi_start_streaming,
> +	.stop_streaming		= dcmi_stop_streaming,
> +	.wait_prepare		= vb2_ops_wait_prepare,
> +	.wait_finish		= vb2_ops_wait_finish,
> +};
> +
> +static int dcmi_g_fmt_vid_cap(struct file *file, void *priv,
> +			      struct v4l2_format *fmt)
> +{
> +	struct stm32_dcmi *dcmi = video_drvdata(file);
> +
> +	*fmt = dcmi->fmt;
> +
> +	return 0;
> +}
> +
> +static const struct dcmi_format *find_format_by_fourcc(struct stm32_dcmi *dcmi,
> +						       unsigned int fourcc)
> +{
> +	unsigned int num_formats = dcmi->num_user_formats;
> +	const struct dcmi_format *fmt;
> +	unsigned int i;
> +
> +	for (i = 0; i < num_formats; i++) {
> +		fmt = dcmi->user_formats[i];
> +		if (fmt->fourcc == fourcc)
> +			return fmt;
> +	}
> +
> +	return NULL;
> +}
> +
> +static int dcmi_try_fmt(struct stm32_dcmi *dcmi, struct v4l2_format *f,
> +			const struct dcmi_format **current_fmt)
> +{
> +	const struct dcmi_format *dcmi_fmt;
> +	struct v4l2_pix_format *pixfmt = &f->fmt.pix;
> +	struct v4l2_subdev_pad_config pad_cfg;
> +	struct v4l2_subdev_format format = {
> +		.which = V4L2_SUBDEV_FORMAT_TRY,
> +	};
> +	int ret;
> +
> +	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		return -EINVAL;

This test is not needed, the v4l2 core tests for this already.

> +
> +	dcmi_fmt = find_format_by_fourcc(dcmi, pixfmt->pixelformat);
> +	if (!dcmi_fmt) {
> +		dcmi_fmt = dcmi->user_formats[dcmi->num_user_formats - 1];
> +		pixfmt->pixelformat = dcmi_fmt->fourcc;
> +	}
> +
> +	/* Limit to hardware capabilities */
> +	if (pixfmt->width > MAX_SUPPORT_WIDTH)
> +		pixfmt->width = MAX_SUPPORT_WIDTH;
> +	if (pixfmt->height > MAX_SUPPORT_HEIGHT)
> +		pixfmt->height = MAX_SUPPORT_HEIGHT;
> +	if (pixfmt->width < MIN_SUPPORT_WIDTH)
> +		pixfmt->width = MIN_SUPPORT_WIDTH;
> +	if (pixfmt->height < MIN_SUPPORT_HEIGHT)
> +		pixfmt->height = MIN_SUPPORT_HEIGHT;

I suggest using the clamp macro here.

> +
> +	v4l2_fill_mbus_format(&format.format, pixfmt, dcmi_fmt->mbus_code);
> +	ret = v4l2_subdev_call(dcmi->entity.subdev, pad, set_fmt,
> +			       &pad_cfg, &format);
> +	if (ret < 0)
> +		return ret;
> +
> +	v4l2_fill_pix_format(pixfmt, &format.format);
> +
> +	pixfmt->field = V4L2_FIELD_NONE;
> +	pixfmt->bytesperline = pixfmt->width * dcmi_fmt->bpp;
> +	pixfmt->sizeimage = pixfmt->bytesperline * pixfmt->height;
> +
> +	if (current_fmt)
> +		*current_fmt = dcmi_fmt;
> +
> +	return 0;
> +}
> +
> +static int dcmi_set_fmt(struct stm32_dcmi *dcmi, struct v4l2_format *f)
> +{
> +	struct v4l2_subdev_format format = {
> +		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> +	};
> +	const struct dcmi_format *current_fmt;
> +	int ret;
> +
> +	ret = dcmi_try_fmt(dcmi, f, &current_fmt);
> +	if (ret)
> +		return ret;
> +
> +	v4l2_fill_mbus_format(&format.format, &f->fmt.pix,
> +			      current_fmt->mbus_code);
> +	ret = v4l2_subdev_call(dcmi->entity.subdev, pad,
> +			       set_fmt, NULL, &format);
> +	if (ret < 0)
> +		return ret;
> +
> +	dcmi->fmt = *f;
> +	dcmi->current_fmt = current_fmt;
> +
> +	return 0;
> +}
> +
> +static int dcmi_s_fmt_vid_cap(struct file *file, void *priv,
> +			      struct v4l2_format *f)
> +{
> +	struct stm32_dcmi *dcmi = video_drvdata(file);
> +
> +	if (vb2_is_streaming(&dcmi->queue))
> +		return -EBUSY;
> +
> +	return dcmi_set_fmt(dcmi, f);
> +}
> +
> +static int dcmi_try_fmt_vid_cap(struct file *file, void *priv,
> +				struct v4l2_format *f)
> +{
> +	struct stm32_dcmi *dcmi = video_drvdata(file);
> +
> +	return dcmi_try_fmt(dcmi, f, NULL);
> +}
> +
> +static int dcmi_enum_fmt_vid_cap(struct file *file, void  *priv,
> +				 struct v4l2_fmtdesc *f)
> +{
> +	struct stm32_dcmi *dcmi = video_drvdata(file);
> +
> +	if (f->index >= dcmi->num_user_formats)
> +		return -EINVAL;
> +
> +	f->pixelformat = dcmi->user_formats[f->index]->fourcc;
> +	return 0;
> +}
> +
> +static int dcmi_querycap(struct file *file, void *priv,
> +			 struct v4l2_capability *cap)
> +{
> +	strlcpy(cap->driver, DRV_NAME, sizeof(cap->driver));
> +	strlcpy(cap->card, "STM32 Digital Camera Memory Interface",
> +		sizeof(cap->card));

I don't think this fits in cap->card.

> +	strlcpy(cap->bus_info, "platform:dcmi", sizeof(cap->bus_info));
> +	return 0;
> +}
> +
> +static int dcmi_enum_input(struct file *file, void *priv,
> +			   struct v4l2_input *i)
> +{
> +	if (i->index != 0)
> +		return -EINVAL;
> +
> +	i->type = V4L2_INPUT_TYPE_CAMERA;
> +	strlcpy(i->name, "Camera", sizeof(i->name));
> +	return 0;
> +}
> +
> +static int dcmi_g_input(struct file *file, void *priv, unsigned int *i)
> +{
> +	*i = 0;
> +	return 0;
> +}
> +
> +static int dcmi_s_input(struct file *file, void *priv, unsigned int i)
> +{
> +	if (i > 0)
> +		return -EINVAL;
> +	return 0;
> +}
> +
> +static int dcmi_enum_framesizes(struct file *file, void *fh,
> +				struct v4l2_frmsizeenum *fsize)
> +{
> +	struct stm32_dcmi *dcmi = video_drvdata(file);
> +	const struct dcmi_format *dcmi_fmt;
> +	struct v4l2_subdev_frame_size_enum fse = {
> +		.index = fsize->index,
> +		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> +	};
> +	int ret;
> +
> +	dcmi_fmt = find_format_by_fourcc(dcmi, fsize->pixel_format);
> +	if (!dcmi_fmt)
> +		return -EINVAL;
> +
> +	fse.code = dcmi_fmt->mbus_code;
> +
> +	ret = v4l2_subdev_call(dcmi->entity.subdev, pad, enum_frame_size,
> +			       NULL, &fse);
> +	if (ret)
> +		return ret;
> +
> +	fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
> +	fsize->discrete.width = fse.max_width;
> +	fsize->discrete.height = fse.max_height;
> +
> +	return 0;
> +}
> +
> +static int dcmi_enum_frameintervals(struct file *file, void *fh,
> +				    struct v4l2_frmivalenum *fival)
> +{
> +	struct stm32_dcmi *dcmi = video_drvdata(file);
> +	const struct dcmi_format *dcmi_fmt;
> +	struct v4l2_subdev_frame_interval_enum fie = {
> +		.index = fival->index,
> +		.width = fival->width,
> +		.height = fival->height,
> +		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> +	};
> +	int ret;
> +
> +	dcmi_fmt = find_format_by_fourcc(dcmi, fival->pixel_format);
> +	if (!dcmi_fmt)
> +		return -EINVAL;
> +
> +	fie.code = dcmi_fmt->mbus_code;
> +
> +	ret = v4l2_subdev_call(dcmi->entity.subdev, pad,
> +			       enum_frame_interval, NULL, &fie);
> +	if (ret)
> +		return ret;
> +
> +	fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
> +	fival->discrete = fie.interval;
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id stm32_dcmi_of_match[] = {
> +	{ .compatible = "st,stm32-dcmi"},
> +	{ /* end node */ },
> +};
> +MODULE_DEVICE_TABLE(of, stm32_dcmi_of_match);
> +
> +static int dcmi_open(struct file *file)
> +{
> +	struct stm32_dcmi *dcmi = video_drvdata(file);
> +	struct v4l2_subdev *sd = dcmi->entity.subdev;
> +	int ret;
> +
> +	if (mutex_lock_interruptible(&dcmi->lock))
> +		return -ERESTARTSYS;
> +
> +	ret = v4l2_fh_open(file);
> +	if (ret < 0)
> +		goto unlock;
> +
> +	if (!v4l2_fh_is_singular_file(file))
> +		goto fh_rel;
> +
> +	ret = v4l2_subdev_call(sd, core, s_power, 1);
> +	if (ret < 0 && ret != -ENOIOCTLCMD)
> +		goto fh_rel;
> +
> +	ret = dcmi_set_fmt(dcmi, &dcmi->fmt);
> +	if (ret)
> +		v4l2_subdev_call(sd, core, s_power, 0);
> +fh_rel:
> +	if (ret)
> +		v4l2_fh_release(file);
> +unlock:
> +	mutex_unlock(&dcmi->lock);
> +	return ret;
> +}
> +
> +static int dcmi_release(struct file *file)
> +{
> +	struct stm32_dcmi *dcmi = video_drvdata(file);
> +	struct v4l2_subdev *sd = dcmi->entity.subdev;
> +	bool fh_singular;
> +	int ret;
> +
> +	mutex_lock(&dcmi->lock);
> +
> +	fh_singular = v4l2_fh_is_singular_file(file);
> +
> +	ret = _vb2_fop_release(file, NULL);
> +
> +	if (fh_singular)
> +		v4l2_subdev_call(sd, core, s_power, 0);
> +
> +	mutex_unlock(&dcmi->lock);
> +
> +	return ret;
> +}
> +
> +static const struct v4l2_ioctl_ops dcmi_ioctl_ops = {
> +	.vidioc_querycap		= dcmi_querycap,
> +
> +	.vidioc_try_fmt_vid_cap		= dcmi_try_fmt_vid_cap,
> +	.vidioc_g_fmt_vid_cap		= dcmi_g_fmt_vid_cap,
> +	.vidioc_s_fmt_vid_cap		= dcmi_s_fmt_vid_cap,
> +	.vidioc_enum_fmt_vid_cap	= dcmi_enum_fmt_vid_cap,
> +
> +	.vidioc_enum_input		= dcmi_enum_input,
> +	.vidioc_g_input			= dcmi_g_input,
> +	.vidioc_s_input			= dcmi_s_input,
> +
> +	.vidioc_enum_framesizes		= dcmi_enum_framesizes,
> +	.vidioc_enum_frameintervals	= dcmi_enum_frameintervals,
> +
> +	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
> +	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
> +	.vidioc_querybuf		= vb2_ioctl_querybuf,
> +	.vidioc_qbuf			= vb2_ioctl_qbuf,
> +	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
> +	.vidioc_expbuf			= vb2_ioctl_expbuf,
> +	.vidioc_prepare_buf		= vb2_ioctl_prepare_buf,
> +	.vidioc_streamon		= vb2_ioctl_streamon,
> +	.vidioc_streamoff		= vb2_ioctl_streamoff,
> +
> +	.vidioc_log_status		= v4l2_ctrl_log_status,
> +	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
> +	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
> +};
> +
> +static const struct v4l2_file_operations dcmi_fops = {
> +	.owner		= THIS_MODULE,
> +	.unlocked_ioctl	= video_ioctl2,
> +	.open		= dcmi_open,
> +	.release	= dcmi_release,
> +	.poll		= vb2_fop_poll,
> +	.mmap		= vb2_fop_mmap,
> +#ifndef CONFIG_MMU
> +	.get_unmapped_area = vb2_fop_get_unmapped_area,
> +#endif
> +	.read		= vb2_fop_read,
> +};
> +
> +static int dcmi_set_default_fmt(struct stm32_dcmi *dcmi)
> +{
> +	struct v4l2_format f = {
> +		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
> +		.fmt.pix = {
> +			.width		= CIF_WIDTH,
> +			.height		= CIF_HEIGHT,
> +			.field		= V4L2_FIELD_NONE,
> +			.pixelformat	= dcmi->user_formats[0]->fourcc,
> +		},
> +	};
> +	int ret;
> +
> +	ret = dcmi_try_fmt(dcmi, &f, NULL);
> +	if (ret)
> +		return ret;
> +	dcmi->current_fmt = dcmi->user_formats[0];
> +	dcmi->fmt = f;
> +	return 0;
> +}
> +
> +static const struct dcmi_format dcmi_formats[] = {
> +	{
> +		.fourcc = V4L2_PIX_FMT_RGB565,
> +		.mbus_code = MEDIA_BUS_FMT_RGB565_2X8_LE,
> +		.bpp = 2,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_YUYV,
> +		.mbus_code = MEDIA_BUS_FMT_YUYV8_2X8,
> +		.bpp = 2,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_UYVY,
> +		.mbus_code = MEDIA_BUS_FMT_UYVY8_2X8,
> +		.bpp = 2,
> +	},
> +};
> +
> +static int dcmi_formats_init(struct stm32_dcmi *dcmi)
> +{
> +	const struct dcmi_format *dcmi_fmts[ARRAY_SIZE(dcmi_formats)];
> +	unsigned int num_fmts = 0, i, j;
> +	struct v4l2_subdev *subdev = dcmi->entity.subdev;
> +	struct v4l2_subdev_mbus_code_enum mbus_code = {
> +		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> +	};
> +
> +	while (!v4l2_subdev_call(subdev, pad, enum_mbus_code,
> +				 NULL, &mbus_code)) {
> +		for (i = 0; i < ARRAY_SIZE(dcmi_formats); i++) {
> +			if (dcmi_formats[i].mbus_code != mbus_code.code)
> +				continue;
> +
> +			/* Code supported, have we got this fourcc yet? */
> +			for (j = 0; j < num_fmts; j++)
> +				if (dcmi_fmts[j]->fourcc ==
> +						dcmi_formats[i].fourcc)
> +					/* Already available */
> +					break;
> +			if (j == num_fmts)
> +				/* New */
> +				dcmi_fmts[num_fmts++] = dcmi_formats + i;
> +		}
> +		mbus_code.index++;
> +	}
> +
> +	if (!num_fmts)
> +		return -ENXIO;
> +
> +	dcmi->num_user_formats = num_fmts;
> +	dcmi->user_formats = devm_kcalloc(dcmi->dev,
> +					 num_fmts, sizeof(struct dcmi_format *),
> +					 GFP_KERNEL);
> +	if (!dcmi->user_formats) {
> +		dev_err(dcmi->dev, "could not allocate memory\n");
> +		return -ENOMEM;
> +	}
> +
> +	memcpy(dcmi->user_formats, dcmi_fmts,
> +	       num_fmts * sizeof(struct dcmi_format *));
> +	dcmi->current_fmt = dcmi->user_formats[0];
> +
> +	return 0;
> +}
> +
> +static int dcmi_graph_notify_complete(struct v4l2_async_notifier *notifier)
> +{
> +	struct stm32_dcmi *dcmi = notifier_to_dcmi(notifier);
> +	int ret;
> +
> +	dcmi->vdev->ctrl_handler	= dcmi->entity.subdev->ctrl_handler;

Replace the tab before the '=' by a simple space.

> +	ret = dcmi_formats_init(dcmi);
> +	if (ret) {
> +		dev_err(dcmi->dev, "No supported mediabus format found\n");
> +		return ret;
> +	}
> +
> +	ret = dcmi_set_default_fmt(dcmi);
> +	if (ret) {
> +		dev_err(dcmi->dev, "Could not set default format\n");
> +		return ret;
> +	}
> +
> +	ret = video_register_device(dcmi->vdev, VFL_TYPE_GRABBER, -1);
> +	if (ret) {
> +		dev_err(dcmi->dev, "Failed to register video device\n");
> +		return ret;
> +	}
> +
> +	dev_dbg(dcmi->dev, "Device registered as %s\n",
> +		video_device_node_name(dcmi->vdev));
> +	return 0;
> +}
> +
> +static void dcmi_graph_notify_unbind(struct v4l2_async_notifier *notifier,
> +				     struct v4l2_subdev *sd,
> +				     struct v4l2_async_subdev *asd)
> +{
> +	struct stm32_dcmi *dcmi = notifier_to_dcmi(notifier);
> +
> +	dev_dbg(dcmi->dev, "Removing %s\n", video_device_node_name(dcmi->vdev));
> +
> +	/* Checks internaly if vdev has been init or not */
> +	video_unregister_device(dcmi->vdev);
> +}
> +
> +static int dcmi_graph_notify_bound(struct v4l2_async_notifier *notifier,
> +				   struct v4l2_subdev *subdev,
> +				   struct v4l2_async_subdev *asd)
> +{
> +	struct stm32_dcmi *dcmi = notifier_to_dcmi(notifier);
> +
> +	dev_dbg(dcmi->dev, "Subdev %s bound\n", subdev->name);
> +
> +	dcmi->entity.subdev = subdev;
> +
> +	return 0;
> +}
> +
> +static int dcmi_graph_parse(struct stm32_dcmi *dcmi, struct device_node *node)
> +{
> +	struct device_node *ep = NULL;
> +	struct device_node *remote;
> +
> +	while (1) {
> +		ep = of_graph_get_next_endpoint(node, ep);
> +		if (!ep)
> +			return -EINVAL;
> +
> +		remote = of_graph_get_remote_port_parent(ep);
> +		if (!remote) {
> +			of_node_put(ep);
> +			return -EINVAL;
> +		}
> +
> +		/* Remote node to connect */
> +		dcmi->entity.node = remote;
> +		dcmi->entity.asd.match_type = V4L2_ASYNC_MATCH_OF;
> +		dcmi->entity.asd.match.of.node = remote;
> +		return 0;
> +	}
> +}
> +
> +static int dcmi_graph_init(struct stm32_dcmi *dcmi)
> +{
> +	struct v4l2_async_subdev **subdevs = NULL;
> +	int ret;
> +
> +	/* Parse the graph to extract a list of subdevice DT nodes. */
> +	ret = dcmi_graph_parse(dcmi, dcmi->dev->of_node);
> +	if (ret < 0) {
> +		dev_err(dcmi->dev, "Graph parsing failed\n");
> +		return ret;
> +	}
> +
> +	/* Register the subdevices notifier. */
> +	subdevs = devm_kzalloc(dcmi->dev, sizeof(*subdevs), GFP_KERNEL);
> +	if (!subdevs) {
> +		of_node_put(dcmi->entity.node);
> +		return -ENOMEM;
> +	}
> +
> +	subdevs[0] = &dcmi->entity.asd;
> +
> +	dcmi->notifier.subdevs = subdevs;
> +	dcmi->notifier.num_subdevs = 1;
> +	dcmi->notifier.bound = dcmi_graph_notify_bound;
> +	dcmi->notifier.unbind = dcmi_graph_notify_unbind;
> +	dcmi->notifier.complete = dcmi_graph_notify_complete;
> +
> +	ret = v4l2_async_notifier_register(&dcmi->v4l2_dev, &dcmi->notifier);
> +	if (ret < 0) {
> +		dev_err(dcmi->dev, "Notifier registration failed\n");
> +		of_node_put(dcmi->entity.node);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int dcmi_probe(struct platform_device *pdev)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	const struct of_device_id *match = NULL;
> +	struct v4l2_of_endpoint ep;
> +	struct stm32_dcmi *dcmi;
> +	struct vb2_queue *q;
> +	struct dma_chan *chan;
> +	struct clk *mclk;
> +	int irq;
> +	int ret = 0;
> +
> +	match = of_match_device(of_match_ptr(stm32_dcmi_of_match), &pdev->dev);
> +	if (!match) {
> +		dev_err(&pdev->dev, "Could not find a match in devicetree\n");
> +		return -ENODEV;
> +	}
> +
> +	dcmi = devm_kzalloc(&pdev->dev, sizeof(struct stm32_dcmi), GFP_KERNEL);
> +	if (!dcmi)
> +		return -ENOMEM;
> +
> +	dcmi->rstc = of_reset_control_get(np, NULL);
> +	if (IS_ERR(dcmi->rstc)) {
> +		dev_err(&pdev->dev, "Could not get reset control\n");
> +		return -ENODEV;
> +	}
> +
> +	/* Get bus characteristics from devicetree */
> +	np = of_graph_get_next_endpoint(np, NULL);
> +	if (!np) {
> +		dev_err(&pdev->dev, "Could not find the endpoint\n");
> +		of_node_put(np);
> +		goto err_reset_control_put;
> +	}
> +
> +	ret = v4l2_of_parse_endpoint(np, &ep);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Could not parse the endpoint\n");
> +		of_node_put(np);
> +		goto err_reset_control_put;
> +	}
> +
> +	if (ep.bus_type == V4L2_MBUS_CSI2) {
> +		dev_err(&pdev->dev, "CSI bus not supported\n");
> +		of_node_put(np);
> +		goto err_reset_control_put;
> +	}
> +	dcmi->bus.flags = ep.bus.parallel.flags;
> +	dcmi->bus.bus_width = ep.bus.parallel.bus_width;
> +	dcmi->bus.data_shift = ep.bus.parallel.data_shift;
> +
> +	of_node_put(np);
> +
> +	irq = platform_get_irq(pdev, 0);
> +	if (irq <= 0) {
> +		dev_err(&pdev->dev, "Could not get irq\n");
> +		return -ENODEV;
> +	}
> +
> +	dcmi->res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!dcmi->res) {
> +		dev_err(&pdev->dev, "Could not get resource\n");
> +		return -ENODEV;
> +	}
> +
> +	dcmi->regs = devm_ioremap_resource(&pdev->dev, dcmi->res);
> +	if (IS_ERR(dcmi->regs)) {
> +		dev_err(&pdev->dev, "Could not map registers\n");
> +		return PTR_ERR(dcmi->regs);
> +	}
> +
> +	ret = devm_request_threaded_irq(&pdev->dev, irq, dcmi_irq_callback,
> +					dcmi_irq_thread, IRQF_ONESHOT,
> +					dev_name(&pdev->dev), dcmi);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Unable to request irq %d\n", irq);
> +		return -ENODEV;
> +	}
> +
> +	mclk = devm_clk_get(&pdev->dev, "mclk");
> +	if (IS_ERR(mclk)) {
> +		dev_err(&pdev->dev, "Unable to get mclk\n");
> +		return PTR_ERR(mclk);
> +	}
> +
> +	chan = dma_request_slave_channel(&pdev->dev, "tx");
> +	if (!chan) {
> +		dev_info(&pdev->dev, "Unable to request DMA channel, defer probing\n");
> +		return -EPROBE_DEFER;
> +	}
> +
> +	ret = clk_prepare(mclk);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Unable to prepare mclk %p\n", mclk);
> +		goto err_dma_release;
> +	}
> +
> +	spin_lock_init(&dcmi->irqlock);
> +	mutex_init(&dcmi->lock);
> +	init_completion(&dcmi->complete);
> +	INIT_LIST_HEAD(&dcmi->buffers);
> +
> +	dcmi->dev = &pdev->dev;
> +	dcmi->mclk = mclk;
> +	dcmi->state = STOPPED;
> +	dcmi->dma_chan = chan;
> +
> +	q = &dcmi->queue;
> +
> +	/* Initialize the top-level structure */
> +	ret = v4l2_device_register(&pdev->dev, &dcmi->v4l2_dev);
> +	if (ret)
> +		goto err_clk_unprepare;
> +
> +	dcmi->vdev = video_device_alloc();
> +	if (!dcmi->vdev) {
> +		ret = -ENOMEM;
> +		goto err_device_unregister;
> +	}
> +
> +	/* Video node */
> +	dcmi->vdev->fops = &dcmi_fops;
> +	dcmi->vdev->v4l2_dev = &dcmi->v4l2_dev;
> +	dcmi->vdev->queue = &dcmi->queue;
> +	strlcpy(dcmi->vdev->name, KBUILD_MODNAME, sizeof(dcmi->vdev->name));
> +	dcmi->vdev->release = video_device_release;
> +	dcmi->vdev->ioctl_ops = &dcmi_ioctl_ops;
> +	dcmi->vdev->lock = &dcmi->lock;
> +	dcmi->vdev->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
> +				  V4L2_CAP_READWRITE;
> +	video_set_drvdata(dcmi->vdev, dcmi);
> +
> +	/* Buffer queue */
> +	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	q->io_modes = VB2_MMAP | VB2_READ | VB2_DMABUF;
> +	q->lock = &dcmi->lock;
> +	q->drv_priv = dcmi;
> +	q->buf_struct_size = sizeof(struct dcmi_buf);
> +	q->ops = &dcmi_video_qops;
> +	q->mem_ops = &vb2_dma_contig_memops;
> +	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	q->min_buffers_needed = 2;
> +	q->dev = &pdev->dev;
> +
> +	ret = vb2_queue_init(q);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "Failed to initialize vb2 queue\n");
> +		goto err_device_release;
> +	}
> +
> +	ret = dcmi_graph_init(dcmi);
> +	if (ret < 0)
> +		goto err_device_release;
> +
> +	/* Reset device */
> +	ret = reset_control_assert(dcmi->rstc);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Failed to assert the reset line\n");
> +		goto err_device_release;
> +	}
> +
> +	usleep_range(3000, 5000);
> +
> +	ret = reset_control_deassert(dcmi->rstc);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Failed to deassert the reset line\n");
> +		goto err_device_release;
> +	}
> +
> +	dev_info(&pdev->dev, "Probe done\n");
> +
> +	platform_set_drvdata(pdev, dcmi);
> +	return 0;
> +
> +err_reset_control_put:
> +	reset_control_put(dcmi->rstc);
> +err_device_release:
> +	video_device_release(dcmi->vdev);
> +err_device_unregister:
> +	v4l2_device_unregister(&dcmi->v4l2_dev);
> +err_clk_unprepare:
> +	clk_unprepare(dcmi->mclk);
> +err_dma_release:
> +	dma_release_channel(dcmi->dma_chan);
> +
> +	return ret;
> +}
> +
> +static int dcmi_remove(struct platform_device *pdev)
> +{
> +	struct stm32_dcmi *dcmi = platform_get_drvdata(pdev);
> +
> +	v4l2_async_notifier_unregister(&dcmi->notifier);
> +	v4l2_device_unregister(&dcmi->v4l2_dev);
> +	clk_unprepare(dcmi->mclk);
> +	dma_release_channel(dcmi->dma_chan);
> +	reset_control_put(dcmi->rstc);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver stm32_dcmi_driver = {
> +	.probe		= dcmi_probe,
> +	.remove		= dcmi_remove,
> +	.driver		= {
> +		.name = DRV_NAME,
> +		.of_match_table = of_match_ptr(stm32_dcmi_of_match),
> +	},
> +};
> +
> +module_platform_driver(stm32_dcmi_driver);
> +
> +MODULE_AUTHOR("Yannick Fertre <yannick.fertre@st.com>");
> +MODULE_AUTHOR("Hugues Fruchet <hugues.fruchet@st.com>");
> +MODULE_DESCRIPTION("STMicroelectronics STM32 Digital Camera Memory Interface driver");
> +MODULE_LICENSE("GPL");
> +MODULE_SUPPORTED_DEVICE("video");
> 

Regards,

	Hans
