Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:45229 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751455AbcDCSk0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Apr 2016 14:40:26 -0400
Subject: Re: [PATCHv3] [media] rcar-vin: add Renesas R-Car VIN driver
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>, mchehab@osg.samsung.com,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hans.verkuil@cisco.com, ulrich.hecht@gmail.com
References: <1459619526-17198-1-git-send-email-niklas.soderlund+renesas@ragnatech.se>
Cc: linux-renesas-soc@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <57016390.8020305@xs4all.nl>
Date: Sun, 3 Apr 2016 11:40:16 -0700
MIME-Version: 1.0
In-Reply-To: <1459619526-17198-1-git-send-email-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Some quick review comments...

On 04/02/2016 10:52 AM, Niklas Söderlund wrote:
> A V4L2 driver for Renesas R-Car VIN driver that do not depend on
> soc_camera. The driver is heavily based on its predecessor and aims to
> replace it.
>
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>
> The driver is tested on Koelsch and can do streaming using qv4l2 and
> grab frames using yavta. It passes a v4l2-compliance (git master) run
> without any failures, see bellow for output. Some issues I know about
> but will have to wait for future work in other patches.
>   - One can not bind/unbind the subdevice and continue using the driver.
>   - Do not support FIELD_ALTERNATE.
>   - Suggested compat string "renesas,rcar-gen2-vin" is not included. Will
>     address this in a separate patch together with gen3.
>
> The goal is to replace the soc_camera driver completely to prepare for
> Gen3 enablement. I have therefor chosen to inherit the
> CONFIG_VIDEO_RCAR_VIN name for this new driver and renamed the
> soc_camera driver CONFIG_VIDEO_RCAR_VIN_OLD.
>
> * Changes since v2
> - Fix review comments from Hans Verkuil, thanks!
>      - Update description in Kconfig
>      - Drop V4L2_SEL_TGT_COMPOSE_PADDED
>      - Wrong size for NV16 image
>      - Copy ycbcr_enc and xfer_func when keeping old format.
>      - Add vidioc_cropcap
>      - Return -ENOBUFS in start_streaming to signal more buffers are
>        needed instead of sleeping in a critical section...
>      - Move all v4l2 ioctls and file ops to rcar-v4l2.c (and as a follow
>        up moved all HW functions to rcar-dma.c to increase readability).
> - Fixed RGB formats 's/V4L2_PIX_FMT_RGB555X/V4L2_PIX_FMT_XRGB555' and
>    's/V4L2_PIX_FMT_RGB32/V4L2_PIX_FMT_XBGR32'. This was an error carried
>    over from soc-camera dirver, whit this fix I get correct colors in
>    qv4l2.
> - Rework how media bus type and flags are handled. Instead of defining
>    own values and a unsigned int use struct v4l2_mbus_config to store the
>    configuration parsed from DT.
> - Remove duplicated code from the v4l2_file_operations release code
>    path. There is no need to try and stop the streaming from here. If
>    start_streaming have been called stop_streaming will be called by the
>    framework stopping the streaming.
> - Remove all special checks for the chip RCAR_E1. There are no compat
>    string that will select this chip model. Neither for this driver or
>    its predecessor in soc-camera.
> - Force an width alignment of 32 if the NV16 format is used due to HW
>    limitation.
>
> * Changes since RFC/PATCH
> - Fixed review comments from Hans Verkuil, thanks for reviewing.
> - Added vidioc_[gs]_selection crop and composition is supported. Thanks
>    Laurent for taking the time and explaining to me how to do
>    composition.
> - Reworked the DMA flow to better support single and continues frame
>    grabbing mode.
> - Dropped a lot of the formats that was ported from soc_camera, once I
>    looked at it in a working driver it was obvious that the rcar_vin
>    soc_camera driver did not support them.
> - Added better comments for the core structs
> - Fixed copyright in file headers
> - A lot more testing.
>
> I have made a few small additions to the adv7180.c driver while doing
> this driver but are posted in a separate patch. For completeness I
> included the output of v4l2-compliance both with and with out the
> adv7180 enhancements. The adv7180 additions enables the std and tvnorms
> code paths so it tests a bit more of this driver.
>
> There is a failure reported here but it's a false positive and is
> addressed in Hans Verkuil series '[PATCHv2 0/2] v4l2-ioctl: cropcap
> improvement'. If I apply that series to my tree the failure goes away.
>

<snip>

> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
> new file mode 100644
> index 0000000..85a1be7
> --- /dev/null
> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c

<snip>

> +static bool rvin_fill_hw(struct rvin_dev *vin)
> +{
> +	int slot, limit;
> +
> +	limit = vin->continuous ? HW_BUFFER_NUM : 1;
> +
> +	for (slot = 0; slot < limit; slot++)
> +		if (!rvin_fill_hw_slot(vin, slot))
> +			return false;
> +	return true;
> +}
> +
> +static irqreturn_t rvin_irq(int irq, void *data)
> +{
> +	struct rvin_dev *vin = data;
> +	u32 int_status;
> +	int slot;
> +	unsigned int sequence, handled = 0;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&vin->qlock, flags);
> +
> +	int_status = rvin_get_interrupt_status(vin);
> +	if (!int_status)
> +		goto done;
> +
> +	rvin_ack_interrupt(vin);
> +	handled = 1;
> +
> +	/* Nothing to do if capture status is 'STOPPED' */
> +	if (vin->state == STOPPED) {
> +		vin_dbg(vin, "IRQ state stopped\n");
> +		goto done;
> +	}
> +
> +	/* Wait for HW to shutdown */
> +	if (vin->state == STOPPING) {
> +		if (!rvin_capture_active(vin)) {
> +			vin_dbg(vin, "IRQ hw stopped and we are stopping\n");
> +			complete(&vin->capture_stop);
> +		}
> +		goto done;
> +	}
> +
> +	/* Prepare for capture and update state */
> +	slot = rvin_get_active_slot(vin);
> +	sequence = vin->sequence++;
> +
> +	vin_dbg(vin, "IRQ %02d: %d\tbuf0: %c buf1: %c buf2: %c\tmore: %d\n",
> +		sequence, slot,
> +		slot == 0 ? 'x' : vin->queue_buf[0] != NULL ? '1' : '0',
> +		slot == 1 ? 'x' : vin->queue_buf[1] != NULL ? '1' : '0',
> +		slot == 2 ? 'x' : vin->queue_buf[2] != NULL ? '1' : '0',
> +		!list_empty(&vin->buf_list));
> +
> +	/* HW have written to a slot that is not prepared we are in trouble */
> +	if (WARN_ON((vin->queue_buf[slot] == NULL)))
> +		goto done;
> +
> +	/* Capture frame */
> +	vin->queue_buf[slot]->field = vin->format.field;
> +	vin->queue_buf[slot]->sequence = sequence;
> +	vin->queue_buf[slot]->vb2_buf.timestamp = ktime_get_ns();
> +	vb2_buffer_done(&vin->queue_buf[slot]->vb2_buf, VB2_BUF_STATE_DONE);
> +	vin->queue_buf[slot] = NULL;
> +
> +	/* Prepare for next frame */
> +	if (!rvin_fill_hw(vin)) {
> +
> +		/*
> +		 * Can't supply HW with new buffers fast enough. Halt
> +		 * capture until more buffers are available.
> +		 */
> +		vin->state = STALLED;
> +
> +		/*
> +		 * The continuous capturing requires an explicit stop
> +		 * operation when there is no buffer to be set into
> +		 * the VnMBm registers.
> +		 */
> +		if (vin->continuous) {
> +			rvin_capture_off(vin);
> +			vin_dbg(vin, "IRQ %02d: hw not ready stop\n", sequence);
> +		}
> +	} else {
> +		/*
> +		 * The single capturing requires an explicit capture
> +		 * operation to fetch the next frame.
> +		 */
> +		if (!vin->continuous)
> +			rvin_capture_on(vin);
> +	}
> +done:
> +	spin_unlock_irqrestore(&vin->qlock, flags);
> +
> +	return IRQ_RETVAL(handled);
> +}
> +
> +/* Need to hold qlock before calling */
> +static void return_all_buffers(struct rvin_dev *vin,
> +			       enum vb2_buffer_state state)
> +{
> +	struct rvin_buffer *buf, *node;
> +
> +	list_for_each_entry_safe(buf, node, &vin->buf_list, list) {
> +		vb2_buffer_done(&buf->vb.vb2_buf, state);
> +		list_del(&buf->list);
> +	}
> +}
> +
> +static int rvin_queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
> +			    unsigned int *nplanes, unsigned int sizes[],
> +			    void *alloc_ctxs[])
> +
> +{
> +	struct rvin_dev *vin = vb2_get_drv_priv(vq);
> +
> +	alloc_ctxs[0] = vin->alloc_ctx;
> +	/* Make sure the image size is large enough. */
> +	if (*nplanes)
> +		return sizes[0] < vin->format.sizeimage ? -EINVAL : 0;
> +
> +	*nplanes = 1;
> +	sizes[0] = vin->format.sizeimage;
> +
> +	return 0;
> +};
> +
> +static int rvin_buffer_prepare(struct vb2_buffer *vb)
> +{
> +	struct rvin_dev *vin = vb2_get_drv_priv(vb->vb2_queue);
> +	unsigned long size = vin->format.sizeimage;
> +
> +	if (vb2_plane_size(vb, 0) < size) {
> +		vin_err(vin, "buffer too small (%lu < %lu)\n",
> +			vb2_plane_size(vb, 0), size);
> +		return -EINVAL;
> +	}
> +
> +	vb2_set_plane_payload(vb, 0, size);
> +
> +	return 0;
> +}
> +
> +static void rvin_buffer_queue(struct vb2_buffer *vb)
> +{
> +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> +	struct rvin_dev *vin = vb2_get_drv_priv(vb->vb2_queue);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&vin->qlock, flags);
> +
> +	list_add_tail(to_buf_list(vbuf), &vin->buf_list);
> +
> +	/*
> +	 * If capture is stalled add buffer to HW and restart
> +	 * capturing if HW is ready to continue.
> +	 */
> +	if (vin->state == STALLED)
> +		if (rvin_fill_hw(vin))
> +			rvin_capture_on(vin);
> +
> +	spin_unlock_irqrestore(&vin->qlock, flags);
> +}
> +
> +static int rvin_start_streaming(struct vb2_queue *vq, unsigned int count)
> +{
> +	struct rvin_dev *vin = vb2_get_drv_priv(vq);
> +	struct v4l2_subdev *sd;
> +	unsigned long flags;
> +	int ret;
> +
> +	sd = vin_to_sd(vin);
> +	v4l2_subdev_call(sd, video, s_stream, 1);
> +
> +	spin_lock_irqsave(&vin->qlock, flags);
> +
> +	vin->state = RUNNING;
> +	vin->sequence = 0;
> +	init_completion(&vin->capture_stop);
> +
> +	/* Continuous capture requires more buffers then there is HW slots */
> +	vin->continuous = count > HW_BUFFER_NUM;
> +
> +	/*
> +	 * Wait for more buffers if HW is not ready to start capturing. By
> +	 * returning -ENOBUFS the vb2 framework will call start_streaming
> +	 * again once one more buffer is queued.
> +	 */
> +	if (!rvin_fill_hw(vin)) {
> +		vin_dbg(vin, "HW not ready to start, wait for more buffers\n");
> +		ret = -ENOBUFS;

Normally setting the min_buffers_needed field is enough to ensure this (i.e. start_streaming
won't be called until 'min_buffers_needed' buffers have been queued).

So why isn't that enough in this case? This should probably be in a comment here, since
it is not obvious (at least not to me).

I am not actually sure returning ENOBUFS works at all. Looking at the vb2_core_qbuf()
code I see that it does seem to queue the buffer, but if start_streaming returns an
error it will pass that on, so VIDIOC_QBUF returns an error, but it still queued the buffer,
which is unexpected from a userspace perspective. I wonder if this isn't a vb2 bug.

I do know that userspace wouldn't know what to do with a -ENOBUFS error.

If support for -ENOBUFS is needed, then some vb2 work would be needed to make this
work (vb2_core_qbuf should check for -ENOBUFS and just return 0 to userspace in that
case).

> +		goto out;
> +	}
> +
> +	ret = rvin_capture_start(vin);
> +out:
> +	spin_unlock_irqrestore(&vin->qlock, flags);
> +

If case of failure start_streaming should return all buffers with state
VB2_BUF_STATE_QUEUED to ensure proper operation.

> +	return ret;
> +}

<snip>

> +static int __rvin_dma_try_format(struct rvin_dev *vin,
> +				 u32 which,
> +				 struct v4l2_pix_format *pix,
> +				 struct rvin_sensor *sensor)
> +{
> +	const struct rvin_video_format *info;
> +	u32 rwidth, rheight, walign;
> +
> +	/* Requested */
> +	rwidth = pix->width;
> +	rheight = pix->height;
> +
> +	/*
> +	 * Retrieve format information and select the current format if the
> +	 * requested format isn't supported.
> +	 */
> +	info = rvin_format_from_pixel(pix->pixelformat);
> +	if (!info) {
> +		vin_dbg(vin, "Format %x not found, keeping %x\n",
> +			pix->pixelformat, vin->format.pixelformat);
> +		pix->pixelformat = vin->format.pixelformat;
> +		pix->colorspace = vin->format.colorspace;
> +		pix->field = vin->format.field;
> +		pix->ycbcr_enc = vin->format.ycbcr_enc;
> +		pix->xfer_func = vin->format.xfer_func;
> +		pix->quantization = vin->format.quantization;

Isn't it easier to do:

		pix = vin->format;
		pix->width = rwidth;
		pix->height = rheight;

It's more robust when new fields are added to the pix_format struct.

> +	}
> +
> +	/* Always recalculate */
> +	pix->bytesperline = 0;
> +	pix->sizeimage = 0;
> +
> +	/* Limit to sensor capabilities */
> +	__rvin_dma_try_format_sensor(vin, which, pix, sensor);
> +
> +	/* If sensor can't match format try if VIN can scale */
> +	if (sensor->width != rwidth || sensor->height != rheight)
> +		rvin_scale_try(vin, pix, rwidth, rheight);
> +
> +	/* HW limit width to a multiple of 32 (2^5) for NV16 else 2 (2^1) */
> +	walign = vin->format.pixelformat == V4L2_PIX_FMT_NV16 ? 5 : 1;
> +
> +	/* Limit to VIN capabilities */
> +	v4l_bound_align_image(&pix->width, 2, RVIN_MAX_WIDTH, walign,
> +			      &pix->height, 4, RVIN_MAX_HEIGHT, 2, 0);
> +
> +	switch (pix->field) {
> +	case V4L2_FIELD_NONE:
> +	case V4L2_FIELD_TOP:
> +	case V4L2_FIELD_BOTTOM:
> +	case V4L2_FIELD_INTERLACED_TB:
> +	case V4L2_FIELD_INTERLACED_BT:
> +	case V4L2_FIELD_INTERLACED:
> +		break;
> +	default:
> +		pix->field = V4L2_FIELD_NONE;
> +		break;
> +	}
> +
> +	pix->bytesperline = max_t(u32, pix->bytesperline,
> +				  rvin_format_bytesperline(pix));
> +	pix->sizeimage = max_t(u32, pix->sizeimage,
> +			       rvin_format_sizeimage(pix));
> +
> +	vin_dbg(vin, "Requested %ux%u Got %ux%u bpl: %d size: %d\n",
> +		rwidth, rheight, pix->width, pix->height,
> +		pix->bytesperline, pix->sizeimage);
> +
> +	return 0;
> +}
> +
> +static int rvin_querycap(struct file *file, void *priv,
> +			 struct v4l2_capability *cap)
> +{
> +	struct rvin_dev *vin = video_drvdata(file);
> +
> +	strlcpy(cap->driver, KBUILD_MODNAME, sizeof(cap->driver));
> +	strlcpy(cap->card, "R_Car_VIN", sizeof(cap->card));
> +	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
> +		 dev_name(vin->dev));
> +	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
> +		V4L2_CAP_READWRITE;
> +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> +	return 0;
> +}
> +
> +static int rvin_try_fmt_vid_cap(struct file *file, void *priv,
> +				struct v4l2_format *f)
> +{
> +	struct rvin_dev *vin = video_drvdata(file);
> +	struct rvin_sensor sensor;
> +
> +	return __rvin_dma_try_format(vin, V4L2_SUBDEV_FORMAT_TRY, &f->fmt.pix,
> +				     &sensor);
> +}
> +
> +static int rvin_s_fmt_vid_cap(struct file *file, void *priv,
> +			      struct v4l2_format *f)
> +{
> +	struct rvin_dev *vin = video_drvdata(file);
> +	struct rvin_sensor sensor;
> +	int ret;
> +
> +	if (vb2_is_busy(&vin->queue))
> +		return -EBUSY;
> +
> +	ret = __rvin_dma_try_format(vin, V4L2_SUBDEV_FORMAT_ACTIVE, &f->fmt.pix,
> +				    &sensor);
> +	if (ret)
> +		return ret;
> +
> +	vin->sensor.width = sensor.width;
> +	vin->sensor.height = sensor.height;
> +
> +	vin->format = f->fmt.pix;
> +
> +	return 0;
> +}
> +
> +static int rvin_g_fmt_vid_cap(struct file *file, void *priv,
> +			      struct v4l2_format *f)
> +{
> +	struct rvin_dev *vin = video_drvdata(file);
> +
> +	f->fmt.pix = vin->format;
> +
> +	return 0;
> +}
> +
> +static int rvin_enum_fmt_vid_cap(struct file *file, void *priv,
> +				 struct v4l2_fmtdesc *f)
> +{
> +	if (f->index >= ARRAY_SIZE(rvin_formats))
> +		return -EINVAL;
> +
> +	f->pixelformat = rvin_formats[f->index].fourcc;
> +
> +	return 0;
> +}
> +
> +static int rvin_g_selection(struct file *file, void *fh,
> +			    struct v4l2_selection *s)
> +{
> +	struct rvin_dev *vin = video_drvdata(file);
> +
> +	switch (s->target) {
> +	case V4L2_SEL_TGT_CROP_BOUNDS:
> +	case V4L2_SEL_TGT_CROP_DEFAULT:
> +		s->r.left = s->r.top = 0;
> +		s->r.width = vin->sensor.width;
> +		s->r.height = vin->sensor.height;
> +		break;
> +	case V4L2_SEL_TGT_CROP:
> +		s->r = vin->crop;
> +		break;
> +	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
> +	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
> +		s->r.left = s->r.top = 0;
> +		s->r.width = vin->format.width;
> +		s->r.height = vin->format.height;
> +		break;
> +	case V4L2_SEL_TGT_COMPOSE:
> +		s->r = vin->compose;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static void rect_set_min_size(struct v4l2_rect *r,
> +			      const struct v4l2_rect *min_size)
> +{
> +	if (r->width < min_size->width)
> +		r->width = min_size->width;
> +	if (r->height < min_size->height)
> +		r->height = min_size->height;
> +}
> +
> +static void rect_set_max_size(struct v4l2_rect *r,
> +			      const struct v4l2_rect *max_size)
> +{
> +	if (r->width > max_size->width)
> +		r->width = max_size->width;
> +	if (r->height > max_size->height)
> +		r->height = max_size->height;
> +}
> +
> +static void rect_map_inside(struct v4l2_rect *r,
> +			    const struct v4l2_rect *boundary)
> +{
> +	rect_set_max_size(r, boundary);
> +
> +	if (r->left < boundary->left)
> +		r->left = boundary->left;
> +	if (r->top < boundary->top)
> +		r->top = boundary->top;
> +	if (r->left + r->width > boundary->width)
> +		r->left = boundary->width - r->width;
> +	if (r->top + r->height > boundary->height)
> +		r->top = boundary->height - r->height;
> +}

I think it is time we turn this into common code. I'll post a patch for that.

Regards,

	Hans
