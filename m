Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:56752 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab3H2N2i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Aug 2013 09:28:38 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Archit Taneja <archit@ti.com>
Subject: Re: [PATCH v3 3/6] v4l: ti-vpe: Add VPE mem to mem driver
Date: Thu, 29 Aug 2013 15:28:21 +0200
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	tomi.valkeinen@ti.com, linux-omap@vger.kernel.org
References: <1376996457-17275-1-git-send-email-archit@ti.com> <1377779572-22624-1-git-send-email-archit@ti.com> <1377779572-22624-4-git-send-email-archit@ti.com>
In-Reply-To: <1377779572-22624-4-git-send-email-archit@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201308291528.21281.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu 29 August 2013 14:32:49 Archit Taneja wrote:
> VPE is a block which consists of a single memory to memory path which can
> perform chrominance up/down sampling, de-interlacing, scaling, and color space
> conversion of raster or tiled YUV420 coplanar, YUV422 coplanar or YUV422
> interleaved video formats.
> 
> We create a mem2mem driver based primarily on the mem2mem-testdev example.
> The de-interlacer, scaler and color space converter are all bypassed for now
> to keep the driver simple. Chroma up/down sampler blocks are implemented, so
> conversion beteen different YUV formats is possible.
> 
> Each mem2mem context allocates a buffer for VPE MMR values which it will use
> when it gets access to the VPE HW via the mem2mem queue, it also allocates
> a VPDMA descriptor list to which configuration and data descriptors are added.
> 
> Based on the information received via v4l2 ioctls for the source and
> destination queues, the driver configures the values for the MMRs, and stores
> them in the buffer. There are also some VPDMA parameters like frame start and
> line mode which needs to be configured, these are configured by direct register
> writes via the VPDMA helper functions.
> 
> The driver's device_run() mem2mem op will add each descriptor based on how the
> source and destination queues are set up for the given ctx, once the list is
> prepared, it's submitted to VPDMA, these descriptors when parsed by VPDMA will
> upload MMR registers, start DMA of video buffers on the various input and output
> clients/ports.
> 
> When the list is parsed completely(and the DMAs on all the output ports done),
> an interrupt is generated which we use to notify that the source and destination
> buffers are done.
> 
> The rest of the driver is quite similar to other mem2mem drivers, we use the
> multiplane v4l2 ioctls as the HW support coplanar formats.
> 
> Signed-off-by: Archit Taneja <archit@ti.com>

Thanks for the patch. Just a few small comments below...

> ---
>  drivers/media/platform/Kconfig           |   16 +
>  drivers/media/platform/Makefile          |    2 +
>  drivers/media/platform/ti-vpe/Makefile   |    5 +
>  drivers/media/platform/ti-vpe/vpe.c      | 1740 ++++++++++++++++++++++++++++++
>  drivers/media/platform/ti-vpe/vpe_regs.h |  496 +++++++++
>  5 files changed, 2259 insertions(+)
>  create mode 100644 drivers/media/platform/ti-vpe/Makefile
>  create mode 100644 drivers/media/platform/ti-vpe/vpe.c
>  create mode 100644 drivers/media/platform/ti-vpe/vpe_regs.h
> 
> diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
> new file mode 100644
> index 0000000..85b0880
> --- /dev/null
> +++ b/drivers/media/platform/ti-vpe/vpe.c

<snip>

> +static int vpe_enum_fmt(struct file *file, void *priv,
> +				struct v4l2_fmtdesc *f)
> +{
> +	if (V4L2_TYPE_IS_OUTPUT(f->type))
> +		return __enum_fmt(f, VPE_FMT_TYPE_OUTPUT);
> +	else

The line above isn't necessary.

> +		return __enum_fmt(f, VPE_FMT_TYPE_CAPTURE);
> +}
> +
> +static int vpe_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
> +{
> +	struct v4l2_pix_format_mplane *pix = &f->fmt.pix_mp;
> +	struct vpe_ctx *ctx = file2ctx(file);
> +	struct vb2_queue *vq;
> +	struct vpe_q_data *q_data;
> +	int i;
> +
> +	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
> +	if (!vq)
> +		return -EINVAL;
> +
> +	q_data = get_q_data(ctx, f->type);
> +
> +	pix->width = q_data->width;
> +	pix->height = q_data->height;
> +	pix->pixelformat = q_data->fmt->fourcc;
> +	pix->colorspace = q_data->colorspace;
> +	pix->num_planes = q_data->fmt->coplanar ? 2 : 1;
> +
> +	for (i = 0; i < pix->num_planes; i++) {
> +		pix->plane_fmt[i].bytesperline = q_data->bytesperline[i];
> +		pix->plane_fmt[i].sizeimage = q_data->sizeimage[i];
> +	}
> +
> +	return 0;
> +}
> +
> +static int __vpe_try_fmt(struct vpe_ctx *ctx, struct v4l2_format *f,
> +		       struct vpe_fmt *fmt, int type)
> +{
> +	struct v4l2_pix_format_mplane *pix = &f->fmt.pix_mp;
> +	struct v4l2_plane_pix_format *plane_fmt;
> +	int i;
> +
> +	if (!fmt || !(fmt->types & type)) {
> +		vpe_err(ctx->dev, "Fourcc format (0x%08x) invalid.\n",
> +			pix->pixelformat);
> +		return -EINVAL;
> +	}
> +
> +	pix->field = V4L2_FIELD_NONE;
> +
> +	v4l_bound_align_image(&pix->width, MIN_W, MAX_W, W_ALIGN,
> +			      &pix->height, MIN_H, MAX_H, H_ALIGN,
> +			      S_ALIGN);
> +
> +	pix->num_planes = fmt->coplanar ? 2 : 1;
> +	pix->pixelformat = fmt->fourcc;
> +	pix->colorspace = fmt->fourcc == V4L2_PIX_FMT_RGB24 ?
> +			V4L2_COLORSPACE_SRGB : V4L2_COLORSPACE_SMPTE170M;

pix->priv should be set to NULL as well.

> +
> +
> +	for (i = 0; i < pix->num_planes; i++) {
> +		int depth;
> +
> +		plane_fmt = &pix->plane_fmt[i];
> +		depth = fmt->vpdma_fmt[i]->depth;
> +
> +		if (i == VPE_LUMA)
> +			plane_fmt->bytesperline =
> +					round_up((pix->width * depth) >> 3,
> +						1 << L_ALIGN);
> +		else
> +			plane_fmt->bytesperline = pix->width;
> +
> +		plane_fmt->sizeimage =
> +				(pix->height * pix->width * depth) >> 3;
> +	}
> +
> +	return 0;
> +}
> +
> +static int vpe_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
> +{
> +	struct vpe_ctx *ctx = file2ctx(file);
> +	struct vpe_fmt *fmt = find_format(f);
> +
> +	if (V4L2_TYPE_IS_OUTPUT(f->type))
> +		return __vpe_try_fmt(ctx, f, fmt, VPE_FMT_TYPE_OUTPUT);
> +	else
> +		return __vpe_try_fmt(ctx, f, fmt, VPE_FMT_TYPE_CAPTURE);
> +}
> +
> +static int __vpe_s_fmt(struct vpe_ctx *ctx, struct v4l2_format *f)
> +{
> +	struct v4l2_pix_format_mplane *pix = &f->fmt.pix_mp;
> +	struct v4l2_plane_pix_format *plane_fmt;
> +	struct vpe_q_data *q_data;
> +	struct vb2_queue *vq;
> +	int i;
> +
> +	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
> +	if (!vq)
> +		return -EINVAL;
> +
> +	if (vb2_is_busy(vq)) {
> +		vpe_err(ctx->dev, "queue busy\n");
> +		return -EBUSY;
> +	}
> +
> +	q_data = get_q_data(ctx, f->type);
> +	if (!q_data)
> +		return -EINVAL;
> +
> +	q_data->fmt		= find_format(f);
> +	q_data->width		= pix->width;
> +	q_data->height		= pix->height;
> +	q_data->colorspace	= pix->colorspace;
> +
> +	for (i = 0; i < pix->num_planes; i++) {
> +		plane_fmt = &pix->plane_fmt[i];
> +
> +		q_data->bytesperline[i]	= plane_fmt->bytesperline;
> +		q_data->sizeimage[i]	= plane_fmt->sizeimage;
> +	}
> +
> +	q_data->c_rect.left	= 0;
> +	q_data->c_rect.top	= 0;
> +	q_data->c_rect.width	= q_data->width;
> +	q_data->c_rect.height	= q_data->height;
> +
> +	vpe_dbg(ctx->dev, "Setting format for type %d, wxh: %dx%d, fmt: %d bpl_y %d",
> +		f->type, q_data->width, q_data->height, q_data->fmt->fourcc,
> +		q_data->bytesperline[VPE_LUMA]);
> +	if (q_data->fmt->coplanar)
> +		vpe_dbg(ctx->dev, " bpl_uv %d\n",
> +			q_data->bytesperline[VPE_CHROMA]);
> +
> +	return 0;
> +}
> +
> +static int vpe_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
> +{
> +	int ret;
> +	struct vpe_ctx *ctx = file2ctx(file);
> +
> +	ret = vpe_try_fmt(file, priv, f);
> +	if (ret)
> +		return ret;
> +
> +	ret = __vpe_s_fmt(ctx, f);
> +	if (ret)
> +		return ret;
> +
> +	if (V4L2_TYPE_IS_OUTPUT(f->type))
> +		set_src_registers(ctx);
> +	else
> +		set_dst_registers(ctx);
> +
> +	return set_srcdst_params(ctx);
> +}
> +
> +static int vpe_reqbufs(struct file *file, void *priv,
> +		       struct v4l2_requestbuffers *reqbufs)
> +{
> +	struct vpe_ctx *ctx = file2ctx(file);
> +
> +	return v4l2_m2m_reqbufs(file, ctx->m2m_ctx, reqbufs);
> +}
> +
> +static int vpe_querybuf(struct file *file, void *priv, struct v4l2_buffer *buf)
> +{
> +	struct vpe_ctx *ctx = file2ctx(file);
> +
> +	return v4l2_m2m_querybuf(file, ctx->m2m_ctx, buf);
> +}
> +
> +static int vpe_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
> +{
> +	struct vpe_ctx *ctx = file2ctx(file);
> +
> +	return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
> +}
> +
> +static int vpe_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
> +{
> +	struct vpe_ctx *ctx = file2ctx(file);
> +
> +	return v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
> +}
> +
> +static int vpe_streamon(struct file *file, void *priv, enum v4l2_buf_type type)
> +{
> +	struct vpe_ctx *ctx = file2ctx(file);
> +
> +	return v4l2_m2m_streamon(file, ctx->m2m_ctx, type);
> +}
> +
> +static int vpe_streamoff(struct file *file, void *priv, enum v4l2_buf_type type)
> +{
> +	struct vpe_ctx *ctx = file2ctx(file);
> +
> +	vpe_dump_regs(ctx->dev);
> +	vpdma_dump_regs(ctx->dev->vpdma);
> +
> +	return v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
> +}
> +
> +#define V4L2_CID_TRANS_NUM_BUFS		(V4L2_CID_USER_BASE + 0x1000)

Reserve a control range for this driver in include/uapi/linux/v4l2-controls.h.
Similar to the ones already defined there.

That will ensure that controls for this driver have unique IDs.

> +
> +static int vpe_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct vpe_ctx *ctx =
> +		container_of(ctrl->handler, struct vpe_ctx, hdl);
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_TRANS_NUM_BUFS:
> +		ctx->bufs_per_job = ctrl->val;
> +		break;
> +
> +	default:
> +		vpe_err(ctx->dev, "Invalid control\n");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_ctrl_ops vpe_ctrl_ops = {
> +	.s_ctrl = vpe_s_ctrl,
> +};
> +
> +static const struct v4l2_ioctl_ops vpe_ioctl_ops = {
> +	.vidioc_querycap	= vpe_querycap,
> +
> +	.vidioc_enum_fmt_vid_cap_mplane = vpe_enum_fmt,
> +	.vidioc_g_fmt_vid_cap_mplane	= vpe_g_fmt,
> +	.vidioc_try_fmt_vid_cap_mplane	= vpe_try_fmt,
> +	.vidioc_s_fmt_vid_cap_mplane	= vpe_s_fmt,
> +
> +	.vidioc_enum_fmt_vid_out_mplane = vpe_enum_fmt,
> +	.vidioc_g_fmt_vid_out_mplane	= vpe_g_fmt,
> +	.vidioc_try_fmt_vid_out_mplane	= vpe_try_fmt,
> +	.vidioc_s_fmt_vid_out_mplane	= vpe_s_fmt,
> +
> +	.vidioc_reqbufs		= vpe_reqbufs,
> +	.vidioc_querybuf	= vpe_querybuf,
> +
> +	.vidioc_qbuf		= vpe_qbuf,
> +	.vidioc_dqbuf		= vpe_dqbuf,
> +
> +	.vidioc_streamon	= vpe_streamon,
> +	.vidioc_streamoff	= vpe_streamoff,
> +	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
> +	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
> +};
> +
> +/*
> + * Queue operations
> + */
> +static int vpe_queue_setup(struct vb2_queue *vq,
> +			   const struct v4l2_format *fmt,
> +			   unsigned int *nbuffers, unsigned int *nplanes,
> +			   unsigned int sizes[], void *alloc_ctxs[])
> +{
> +	int i;
> +	struct vpe_ctx *ctx = vb2_get_drv_priv(vq);
> +	struct vpe_q_data *q_data;
> +
> +	q_data = get_q_data(ctx, vq->type);
> +
> +	*nplanes = q_data->fmt->coplanar ? 2 : 1;
> +
> +	for (i = 0; i < *nplanes; i++) {
> +		sizes[i] = q_data->sizeimage[i];
> +		alloc_ctxs[i] = ctx->dev->alloc_ctx;
> +	}
> +
> +	vpe_dbg(ctx->dev, "get %d buffer(s) of size %d", *nbuffers,
> +		sizes[VPE_LUMA]);
> +	if (q_data->fmt->coplanar)
> +		vpe_dbg(ctx->dev, " and %d\n", sizes[VPE_CHROMA]);
> +
> +	return 0;
> +}
> +
> +static int vpe_buf_prepare(struct vb2_buffer *vb)
> +{
> +	struct vpe_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
> +	struct vpe_q_data *q_data;
> +	int i, num_planes;
> +
> +	vpe_dbg(ctx->dev, "type: %d\n", vb->vb2_queue->type);
> +
> +	q_data = get_q_data(ctx, vb->vb2_queue->type);
> +	num_planes = q_data->fmt->coplanar ? 2 : 1;
> +
> +	for (i = 0; i < num_planes; i++) {
> +		if (vb2_plane_size(vb, i) < q_data->sizeimage[i]) {
> +			vpe_err(ctx->dev,
> +				"data will not fit into plane (%lu < %lu)\n",
> +				vb2_plane_size(vb, i),
> +				(long) q_data->sizeimage[i]);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	for (i = 0; i < num_planes; i++)
> +		vb2_set_plane_payload(vb, i, q_data->sizeimage[i]);
> +
> +	return 0;
> +}
> +
> +static void vpe_buf_queue(struct vb2_buffer *vb)
> +{
> +	struct vpe_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
> +	v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
> +}
> +
> +static void vpe_wait_prepare(struct vb2_queue *q)
> +{
> +	struct vpe_ctx *ctx = vb2_get_drv_priv(q);
> +	vpe_unlock(ctx);
> +}
> +
> +static void vpe_wait_finish(struct vb2_queue *q)
> +{
> +	struct vpe_ctx *ctx = vb2_get_drv_priv(q);
> +	vpe_lock(ctx);
> +}
> +
> +static struct vb2_ops vpe_qops = {
> +	.queue_setup	 = vpe_queue_setup,
> +	.buf_prepare	 = vpe_buf_prepare,
> +	.buf_queue	 = vpe_buf_queue,
> +	.wait_prepare	 = vpe_wait_prepare,
> +	.wait_finish	 = vpe_wait_finish,
> +};
> +
> +static int queue_init(void *priv, struct vb2_queue *src_vq,
> +		      struct vb2_queue *dst_vq)
> +{
> +	struct vpe_ctx *ctx = priv;
> +	int ret;
> +
> +	memset(src_vq, 0, sizeof(*src_vq));
> +	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> +	src_vq->io_modes = VB2_MMAP;
> +	src_vq->drv_priv = ctx;
> +	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
> +	src_vq->ops = &vpe_qops;
> +	src_vq->mem_ops = &vb2_dma_contig_memops;
> +	src_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;

Shouldn't this be TIMESTAMP_COPY?

> +
> +	ret = vb2_queue_init(src_vq);
> +	if (ret)
> +		return ret;
> +
> +	memset(dst_vq, 0, sizeof(*dst_vq));
> +	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> +	dst_vq->io_modes = VB2_MMAP;
> +	dst_vq->drv_priv = ctx;
> +	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
> +	dst_vq->ops = &vpe_qops;
> +	dst_vq->mem_ops = &vb2_dma_contig_memops;
> +	dst_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;

Ditto.

> +
> +	return vb2_queue_init(dst_vq);
> +}
> +
> +static const struct v4l2_ctrl_config vpe_bufs_per_job = {
> +	.ops = &vpe_ctrl_ops,
> +	.id = V4L2_CID_TRANS_NUM_BUFS,
> +	.name = "Buffers Per Transaction",
> +	.type = V4L2_CTRL_TYPE_INTEGER,
> +	.def = VPE_DEF_BUFS_PER_JOB,
> +	.min = 1,
> +	.max = VIDEO_MAX_FRAME,
> +	.step = 1,
> +};
> +
> +/*
> + * File operations
> + */
> +static int vpe_open(struct file *file)
> +{
> +	struct vpe_dev *dev = video_drvdata(file);
> +	struct vpe_ctx *ctx = NULL;
> +	struct vpe_q_data *s_q_data;
> +	struct v4l2_ctrl_handler *hdl;
> +	int ret;
> +
> +	vpe_dbg(dev, "vpe_open\n");
> +
> +	if (!dev->vpdma->ready) {
> +		vpe_err(dev, "vpdma firmware not loaded\n");
> +		return -ENODEV;
> +	}
> +
> +	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
> +	if (!ctx)
> +		return -ENOMEM;
> +
> +	ctx->dev = dev;
> +
> +	if (mutex_lock_interruptible(&dev->dev_mutex)) {
> +		ret = -ERESTARTSYS;
> +		goto free_ctx;
> +	}
> +
> +	ret = vpdma_create_desc_list(&ctx->desc_list, VPE_DESC_LIST_SIZE,
> +			VPDMA_LIST_TYPE_NORMAL);
> +	if (ret != 0)
> +		goto unlock;
> +
> +	ret = vpdma_alloc_desc_buf(&ctx->mmr_adb, sizeof(struct vpe_mmr_adb));
> +	if (ret != 0)
> +		goto free_desc_list;
> +
> +	init_adb_hdrs(ctx);
> +
> +	v4l2_fh_init(&ctx->fh, video_devdata(file));
> +	file->private_data = &ctx->fh;
> +
> +	hdl = &ctx->hdl;
> +	v4l2_ctrl_handler_init(hdl, 1);
> +	v4l2_ctrl_new_custom(hdl, &vpe_bufs_per_job, NULL);
> +	if (hdl->error) {
> +		ret = hdl->error;
> +		goto exit_fh;
> +	}
> +	ctx->fh.ctrl_handler = hdl;
> +	v4l2_ctrl_handler_setup(hdl);
> +
> +	s_q_data = &ctx->q_data[Q_DATA_SRC];
> +	s_q_data->fmt = &vpe_formats[2];
> +	s_q_data->width = 1920;
> +	s_q_data->height = 1080;
> +	s_q_data->sizeimage[VPE_LUMA] = (s_q_data->width * s_q_data->height *
> +			s_q_data->fmt->vpdma_fmt[VPE_LUMA]->depth) >> 3;
> +	s_q_data->colorspace = V4L2_COLORSPACE_SMPTE240M;
> +	s_q_data->c_rect.left = 0;
> +	s_q_data->c_rect.top = 0;
> +	s_q_data->c_rect.width = s_q_data->width;
> +	s_q_data->c_rect.height = s_q_data->height;
> +	s_q_data->flags = 0;
> +
> +	ctx->q_data[Q_DATA_DST] = *s_q_data;
> +
> +	set_src_registers(ctx);
> +	set_dst_registers(ctx);
> +	ret = set_srcdst_params(ctx);
> +	if (ret)
> +		goto exit_fh;
> +
> +	ctx->m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev, ctx, &queue_init);
> +
> +	if (IS_ERR(ctx->m2m_ctx)) {
> +		ret = PTR_ERR(ctx->m2m_ctx);
> +		goto exit_fh;
> +	}
> +
> +	v4l2_fh_add(&ctx->fh);
> +
> +	/*
> +	 * for now, just report the creation of the first instance, we can later
> +	 * optimize the driver to enable or disable clocks when the first
> +	 * instance is created or the last instance released
> +	 */
> +	if (atomic_inc_return(&dev->num_instances) == 1)
> +		vpe_dbg(dev, "first instance created\n");
> +
> +	ctx->bufs_per_job = VPE_DEF_BUFS_PER_JOB;
> +
> +	ctx->load_mmrs = true;
> +
> +	vpe_dbg(dev, "created instance %p, m2m_ctx: %p\n",
> +		ctx, ctx->m2m_ctx);
> +
> +	mutex_unlock(&dev->dev_mutex);
> +
> +	return 0;
> +exit_fh:
> +	v4l2_ctrl_handler_free(hdl);
> +	v4l2_fh_exit(&ctx->fh);
> +	vpdma_free_desc_buf(&ctx->mmr_adb);
> +free_desc_list:
> +	vpdma_free_desc_list(&ctx->desc_list);
> +unlock:
> +	mutex_unlock(&dev->dev_mutex);
> +free_ctx:
> +	kfree(ctx);
> +	return ret;
> +}
> +
> +static int vpe_release(struct file *file)
> +{
> +	struct vpe_dev *dev = video_drvdata(file);
> +	struct vpe_ctx *ctx = file2ctx(file);
> +
> +	vpe_dbg(dev, "releasing instance %p\n", ctx);
> +
> +	mutex_lock(&dev->dev_mutex);
> +	vpdma_free_desc_list(&ctx->desc_list);
> +	vpdma_free_desc_buf(&ctx->mmr_adb);
> +
> +	v4l2_fh_del(&ctx->fh);
> +	v4l2_fh_exit(&ctx->fh);
> +	v4l2_ctrl_handler_free(&ctx->hdl);
> +	v4l2_m2m_ctx_release(ctx->m2m_ctx);
> +
> +	kfree(ctx);
> +
> +	/*
> +	 * for now, just report the release of the last instance, we can later
> +	 * optimize the driver to enable or disable clocks when the first
> +	 * instance is created or the last instance released
> +	 */
> +	if (atomic_dec_return(&dev->num_instances) == 0)
> +		vpe_dbg(dev, "last instance released\n");
> +
> +	mutex_unlock(&dev->dev_mutex);
> +
> +	return 0;
> +}
> +
> +static unsigned int vpe_poll(struct file *file,
> +			     struct poll_table_struct *wait)
> +{
> +	struct vpe_ctx *ctx = file2ctx(file);
> +	struct vpe_dev *dev = ctx->dev;
> +	int ret;
> +
> +	mutex_lock(&dev->dev_mutex);
> +	ret = v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
> +	mutex_unlock(&dev->dev_mutex);
> +	return ret;
> +}
> +
> +static int vpe_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	struct vpe_ctx *ctx = file2ctx(file);
> +	struct vpe_dev *dev = ctx->dev;
> +	int ret;
> +
> +	if (mutex_lock_interruptible(&dev->dev_mutex))
> +		return -ERESTARTSYS;
> +	ret = v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
> +	mutex_unlock(&dev->dev_mutex);
> +	return ret;
> +}
> +
> +static const struct v4l2_file_operations vpe_fops = {
> +	.owner		= THIS_MODULE,
> +	.open		= vpe_open,
> +	.release	= vpe_release,
> +	.poll		= vpe_poll,
> +	.unlocked_ioctl	= video_ioctl2,
> +	.mmap		= vpe_mmap,
> +};
> +
> +static struct video_device vpe_videodev = {
> +	.name		= VPE_MODULE_NAME,
> +	.fops		= &vpe_fops,
> +	.ioctl_ops	= &vpe_ioctl_ops,
> +	.minor		= -1,
> +	.release	= video_device_release,
> +	.vfl_dir	= VFL_DIR_M2M,
> +};
> +
> +static struct v4l2_m2m_ops m2m_ops = {
> +	.device_run	= device_run,
> +	.job_ready	= job_ready,
> +	.job_abort	= job_abort,
> +	.lock		= vpe_lock,
> +	.unlock		= vpe_unlock,
> +};
> +
> +static int vpe_runtime_get(struct platform_device *pdev)
> +{
> +	int r;
> +
> +	dev_dbg(&pdev->dev, "vpe_runtime_get\n");
> +
> +	r = pm_runtime_get_sync(&pdev->dev);
> +	WARN_ON(r < 0);
> +	return r < 0 ? r : 0;
> +}
> +
> +static void vpe_runtime_put(struct platform_device *pdev)
> +{
> +
> +	int r;
> +
> +	dev_dbg(&pdev->dev, "vpe_runtime_put\n");
> +
> +	r = pm_runtime_put_sync(&pdev->dev);
> +	WARN_ON(r < 0 && r != -ENOSYS);
> +}
> +
> +static int vpe_probe(struct platform_device *pdev)
> +{
> +	struct vpe_dev *dev;
> +	struct video_device *vfd;
> +	struct resource *res;
> +	int ret, irq, func;
> +
> +	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
> +	if (IS_ERR(dev))
> +		return PTR_ERR(dev);
> +
> +	spin_lock_init(&dev->lock);
> +
> +	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
> +	if (ret)
> +		return ret;
> +
> +	atomic_set(&dev->num_instances, 0);
> +	mutex_init(&dev->dev_mutex);
> +
> +	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "vpe");
> +	dev->base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(dev->base)) {
> +		ret = PTR_ERR(dev->base);
> +		goto v4l2_dev_unreg;
> +	}
> +
> +	irq = platform_get_irq(pdev, 0);
> +	ret = devm_request_irq(&pdev->dev, irq, vpe_irq, 0, VPE_MODULE_NAME,
> +			dev);
> +	if (ret)
> +		goto v4l2_dev_unreg;
> +
> +	platform_set_drvdata(pdev, dev);
> +
> +	dev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
> +	if (IS_ERR(dev->alloc_ctx)) {
> +		vpe_err(dev, "Failed to alloc vb2 context\n");
> +		ret = PTR_ERR(dev->alloc_ctx);
> +		goto v4l2_dev_unreg;
> +	}
> +
> +	dev->m2m_dev = v4l2_m2m_init(&m2m_ops);
> +	if (IS_ERR(dev->m2m_dev)) {
> +		vpe_err(dev, "Failed to init mem2mem device\n");
> +		ret = PTR_ERR(dev->m2m_dev);
> +		goto rel_ctx;
> +	}
> +
> +	pm_runtime_enable(&pdev->dev);
> +
> +	ret = vpe_runtime_get(pdev);
> +	if (ret)
> +		goto rel_m2m;
> +
> +	/* Perform clk enable followed by reset */
> +	vpe_set_clock_enable(dev, 1);
> +
> +	vpe_top_reset(dev);
> +
> +	func = read_field_reg(dev, VPE_PID, VPE_PID_FUNC_MASK,
> +		VPE_PID_FUNC_SHIFT);
> +	vpe_dbg(dev, "VPE PID function %x\n", func);
> +
> +	vpe_top_vpdma_reset(dev);
> +
> +	dev->vpdma = vpdma_create(pdev);
> +	if (IS_ERR(dev->vpdma))
> +		goto runtime_put;
> +
> +	vfd = &dev->vfd;
> +	*vfd = vpe_videodev;
> +	vfd->lock = &dev->dev_mutex;
> +	vfd->v4l2_dev = &dev->v4l2_dev;
> +
> +	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
> +	if (ret) {
> +		vpe_err(dev, "Failed to register video device\n");
> +		goto runtime_put;
> +	}
> +
> +	video_set_drvdata(vfd, dev);
> +	snprintf(vfd->name, sizeof(vfd->name), "%s", vpe_videodev.name);
> +	dev_info(dev->v4l2_dev.dev, "Device registered as /dev/video%d\n",
> +		vfd->num);
> +
> +	return 0;
> +
> +runtime_put:
> +	vpe_runtime_put(pdev);
> +rel_m2m:
> +	pm_runtime_disable(&pdev->dev);
> +	v4l2_m2m_release(dev->m2m_dev);
> +rel_ctx:
> +	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
> +v4l2_dev_unreg:
> +	v4l2_device_unregister(&dev->v4l2_dev);
> +
> +	return ret;
> +}
> +
> +static int vpe_remove(struct platform_device *pdev)
> +{
> +	struct vpe_dev *dev =
> +		(struct vpe_dev *) platform_get_drvdata(pdev);
> +
> +	v4l2_info(&dev->v4l2_dev, "Removing " VPE_MODULE_NAME);
> +
> +	v4l2_m2m_release(dev->m2m_dev);
> +	video_unregister_device(&dev->vfd);
> +	v4l2_device_unregister(&dev->v4l2_dev);
> +	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
> +
> +	vpe_set_clock_enable(dev, 0);
> +	vpe_runtime_put(pdev);
> +	pm_runtime_disable(&pdev->dev);
> +
> +	return 0;
> +}
> +
> +#if defined(CONFIG_OF)
> +static const struct of_device_id vpe_of_match[] = {
> +	{
> +		.compatible = "ti,vpe",
> +	},
> +	{},
> +};
> +#else
> +#define vpe_of_match NULL
> +#endif
> +
> +static struct platform_driver vpe_pdrv = {
> +	.probe		= vpe_probe,
> +	.remove		= vpe_remove,
> +	.driver		= {
> +		.name	= VPE_MODULE_NAME,
> +		.owner	= THIS_MODULE,
> +		.of_match_table = vpe_of_match,
> +	},
> +};
> +
> +static void __exit vpe_exit(void)
> +{
> +	platform_driver_unregister(&vpe_pdrv);
> +}
> +
> +static int __init vpe_init(void)
> +{
> +	return platform_driver_register(&vpe_pdrv);
> +}
> +
> +module_init(vpe_init);
> +module_exit(vpe_exit);
> +
> +MODULE_DESCRIPTION("TI VPE driver");
> +MODULE_AUTHOR("Dale Farnsworth, <dale@farnsworth.org>");
> +MODULE_LICENSE("GPL");

Regards,

	Hans
