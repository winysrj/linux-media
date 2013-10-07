Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2417 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab3JGHzx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Oct 2013 03:55:53 -0400
Message-ID: <525268F9.90409@xs4all.nl>
Date: Mon, 07 Oct 2013 09:55:37 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Archit Taneja <archit@ti.com>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	linux-omap@vger.kernel.org, tomi.valkeinen@ti.com
Subject: Re: [PATCH v4 3/4] v4l: ti-vpe: Add VPE mem to mem driver
References: <1376996457-17275-1-git-send-email-archit@ti.com> <1378462346-10880-1-git-send-email-archit@ti.com> <1378462346-10880-4-git-send-email-archit@ti.com>
In-Reply-To: <1378462346-10880-4-git-send-email-archit@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Archit,

I've got a few comments below...

On 09/06/2013 12:12 PM, Archit Taneja wrote:
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
> ---
>  drivers/media/platform/Kconfig           |   16 +
>  drivers/media/platform/Makefile          |    2 +
>  drivers/media/platform/ti-vpe/Makefile   |    5 +
>  drivers/media/platform/ti-vpe/vpe.c      | 1750 ++++++++++++++++++++++++++++++
>  drivers/media/platform/ti-vpe/vpe_regs.h |  496 +++++++++
>  include/uapi/linux/v4l2-controls.h       |    4 +
>  6 files changed, 2273 insertions(+)
>  create mode 100644 drivers/media/platform/ti-vpe/Makefile
>  create mode 100644 drivers/media/platform/ti-vpe/vpe.c
>  create mode 100644 drivers/media/platform/ti-vpe/vpe_regs.h
> 

<snip>

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

You do this only for capture. Output sets the colorspace, so try_fmt should
leave the colorspace field untouched for the output direction.

> +			V4L2_COLORSPACE_SRGB : V4L2_COLORSPACE_SMPTE170M;

Zero pix->priv as well:

	pix->priv = 0;

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

Does this make sense for output devices? See comment in try_fmt.

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
> +#define V4L2_CID_VPE_BUFS_PER_JOB		(V4L2_CID_USER_TI_VPE_BASE + 0)

Please comment here what this control does. If applications are supposed to explicitly
set this control, then you need to put it in a public driver-specific header, otherwise
they can never get hold of the control.

> +
> +static int vpe_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct vpe_ctx *ctx =
> +		container_of(ctrl->handler, struct vpe_ctx, hdl);
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_VPE_BUFS_PER_JOB:
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
> +	src_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
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
> +	dst_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +
> +	return vb2_queue_init(dst_vq);
> +}
> +
> +static const struct v4l2_ctrl_config vpe_bufs_per_job = {
> +	.ops = &vpe_ctrl_ops,
> +	.id = V4L2_CID_VPE_BUFS_PER_JOB,
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
> +	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "vpe_top");
> +	/*
> +	 * HACK: we get resource info from device tree in the form of a list of
> +	 * VPE sub blocks, the driver currently uses only the base of vpe_top
> +	 * for register access, the driver should be changed later to access
> +	 * registers based on the sub block base addresses
> +	 */
> +	dev->base = devm_ioremap(&pdev->dev, res->start, SZ_32K);
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
> diff --git a/drivers/media/platform/ti-vpe/vpe_regs.h b/drivers/media/platform/ti-vpe/vpe_regs.h
> new file mode 100644
> index 0000000..ed214e8
> --- /dev/null
> +++ b/drivers/media/platform/ti-vpe/vpe_regs.h
> @@ -0,0 +1,496 @@
> +/*
> + * Copyright (c) 2013 Texas Instruments Inc.
> + *
> + * David Griego, <dagriego@biglakesoftware.com>
> + * Dale Farnsworth, <dale@farnsworth.org>
> + * Archit Taneja, <archit@ti.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + */
> +
> +#ifndef __TI_VPE_REGS_H
> +#define __TI_VPE_REGS_H
> +
> +/* VPE register offsets and field selectors */
> +
> +/* VPE top level regs */
> +#define VPE_PID				0x0000
> +#define VPE_PID_MINOR_MASK		0x3f
> +#define VPE_PID_MINOR_SHIFT		0
> +#define VPE_PID_CUSTOM_MASK		0x03
> +#define VPE_PID_CUSTOM_SHIFT		6
> +#define VPE_PID_MAJOR_MASK		0x07
> +#define VPE_PID_MAJOR_SHIFT		8
> +#define VPE_PID_RTL_MASK		0x1f
> +#define VPE_PID_RTL_SHIFT		11
> +#define VPE_PID_FUNC_MASK		0xfff
> +#define VPE_PID_FUNC_SHIFT		16
> +#define VPE_PID_SCHEME_MASK		0x03
> +#define VPE_PID_SCHEME_SHIFT		30
> +
> +#define VPE_SYSCONFIG			0x0010
> +#define VPE_SYSCONFIG_IDLE_MASK		0x03
> +#define VPE_SYSCONFIG_IDLE_SHIFT	2
> +#define VPE_SYSCONFIG_STANDBY_MASK	0x03
> +#define VPE_SYSCONFIG_STANDBY_SHIFT	4
> +#define VPE_FORCE_IDLE_MODE		0
> +#define VPE_NO_IDLE_MODE		1
> +#define VPE_SMART_IDLE_MODE		2
> +#define VPE_SMART_IDLE_WAKEUP_MODE	3
> +#define VPE_FORCE_STANDBY_MODE		0
> +#define VPE_NO_STANDBY_MODE		1
> +#define VPE_SMART_STANDBY_MODE		2
> +#define VPE_SMART_STANDBY_WAKEUP_MODE	3
> +
> +#define VPE_INT0_STATUS0_RAW_SET	0x0020
> +#define VPE_INT0_STATUS0_RAW		VPE_INT0_STATUS0_RAW_SET
> +#define VPE_INT0_STATUS0_CLR		0x0028
> +#define VPE_INT0_STATUS0		VPE_INT0_STATUS0_CLR
> +#define VPE_INT0_ENABLE0_SET		0x0030
> +#define VPE_INT0_ENABLE0		VPE_INT0_ENABLE0_SET
> +#define VPE_INT0_ENABLE0_CLR		0x0038
> +#define VPE_INT0_LIST0_COMPLETE		(1 << 0)
> +#define VPE_INT0_LIST0_NOTIFY		(1 << 1)
> +#define VPE_INT0_LIST1_COMPLETE		(1 << 2)
> +#define VPE_INT0_LIST1_NOTIFY		(1 << 3)
> +#define VPE_INT0_LIST2_COMPLETE		(1 << 4)
> +#define VPE_INT0_LIST2_NOTIFY		(1 << 5)
> +#define VPE_INT0_LIST3_COMPLETE		(1 << 6)
> +#define VPE_INT0_LIST3_NOTIFY		(1 << 7)
> +#define VPE_INT0_LIST4_COMPLETE		(1 << 8)
> +#define VPE_INT0_LIST4_NOTIFY		(1 << 9)
> +#define VPE_INT0_LIST5_COMPLETE		(1 << 10)
> +#define VPE_INT0_LIST5_NOTIFY		(1 << 11)
> +#define VPE_INT0_LIST6_COMPLETE		(1 << 12)
> +#define VPE_INT0_LIST6_NOTIFY		(1 << 13)
> +#define VPE_INT0_LIST7_COMPLETE		(1 << 14)
> +#define VPE_INT0_LIST7_NOTIFY		(1 << 15)
> +#define VPE_INT0_DESCRIPTOR		(1 << 16)
> +#define VPE_DEI_FMD_INT			(1 << 18)
> +
> +#define VPE_INT0_STATUS1_RAW_SET	0x0024
> +#define VPE_INT0_STATUS1_RAW		VPE_INT0_STATUS1_RAW_SET
> +#define VPE_INT0_STATUS1_CLR		0x002c
> +#define VPE_INT0_STATUS1		VPE_INT0_STATUS1_CLR
> +#define VPE_INT0_ENABLE1_SET		0x0034
> +#define VPE_INT0_ENABLE1		VPE_INT0_ENABLE1_SET
> +#define VPE_INT0_ENABLE1_CLR		0x003c
> +#define VPE_INT0_CHANNEL_GROUP0		(1 << 0)
> +#define VPE_INT0_CHANNEL_GROUP1		(1 << 1)
> +#define VPE_INT0_CHANNEL_GROUP2		(1 << 2)
> +#define VPE_INT0_CHANNEL_GROUP3		(1 << 3)
> +#define VPE_INT0_CHANNEL_GROUP4		(1 << 4)
> +#define VPE_INT0_CHANNEL_GROUP5		(1 << 5)
> +#define VPE_INT0_CLIENT			(1 << 7)
> +#define VPE_DEI_ERROR_INT		(1 << 16)
> +#define VPE_DS1_UV_ERROR_INT		(1 << 22)
> +
> +#define VPE_INTC_EOI			0x00a0
> +
> +#define VPE_CLK_ENABLE			0x0100
> +#define VPE_VPEDMA_CLK_ENABLE		(1 << 0)
> +#define VPE_DATA_PATH_CLK_ENABLE	(1 << 1)
> +
> +#define VPE_CLK_RESET			0x0104
> +#define VPE_VPDMA_CLK_RESET_MASK	0x1
> +#define VPE_VPDMA_CLK_RESET_SHIFT	0
> +#define VPE_DATA_PATH_CLK_RESET_MASK	0x1
> +#define VPE_DATA_PATH_CLK_RESET_SHIFT	1
> +#define VPE_MAIN_RESET_MASK		0x1
> +#define VPE_MAIN_RESET_SHIFT		31
> +
> +#define VPE_CLK_FORMAT_SELECT		0x010c
> +#define VPE_CSC_SRC_SELECT_MASK		0x03
> +#define VPE_CSC_SRC_SELECT_SHIFT	0
> +#define VPE_RGB_OUT_SELECT		(1 << 8)
> +#define VPE_DS_SRC_SELECT_MASK		0x07
> +#define VPE_DS_SRC_SELECT_SHIFT		9
> +#define VPE_DS_BYPASS			(1 << 16)
> +#define VPE_COLOR_SEPARATE_422		(1 << 18)
> +
> +#define VPE_DS_SRC_DEI_SCALER		(5 << VPE_DS_SRC_SELECT_SHIFT)
> +#define VPE_CSC_SRC_DEI_SCALER		(3 << VPE_CSC_SRC_SELECT_SHIFT)
> +
> +#define VPE_CLK_RANGE_MAP		0x011c
> +#define VPE_RANGE_RANGE_MAP_Y_MASK	0x07
> +#define VPE_RANGE_RANGE_MAP_Y_SHIFT	0
> +#define VPE_RANGE_RANGE_MAP_UV_MASK	0x07
> +#define VPE_RANGE_RANGE_MAP_UV_SHIFT	3
> +#define VPE_RANGE_MAP_ON		(1 << 6)
> +#define VPE_RANGE_REDUCTION_ON		(1 << 28)
> +
> +/* VPE chrominance upsampler regs */
> +#define VPE_US1_R0			0x0304
> +#define VPE_US2_R0			0x0404
> +#define VPE_US3_R0			0x0504
> +#define VPE_US_C1_MASK			0x3fff
> +#define VPE_US_C1_SHIFT			2
> +#define VPE_US_C0_MASK			0x3fff
> +#define VPE_US_C0_SHIFT			18
> +#define VPE_US_MODE_MASK		0x03
> +#define VPE_US_MODE_SHIFT		16
> +#define VPE_ANCHOR_FID0_C1_MASK		0x3fff
> +#define VPE_ANCHOR_FID0_C1_SHIFT	2
> +#define VPE_ANCHOR_FID0_C0_MASK		0x3fff
> +#define VPE_ANCHOR_FID0_C0_SHIFT	18
> +
> +#define VPE_US1_R1			0x0308
> +#define VPE_US2_R1			0x0408
> +#define VPE_US3_R1			0x0508
> +#define VPE_ANCHOR_FID0_C3_MASK		0x3fff
> +#define VPE_ANCHOR_FID0_C3_SHIFT	2
> +#define VPE_ANCHOR_FID0_C2_MASK		0x3fff
> +#define VPE_ANCHOR_FID0_C2_SHIFT	18
> +
> +#define VPE_US1_R2			0x030c
> +#define VPE_US2_R2			0x040c
> +#define VPE_US3_R2			0x050c
> +#define VPE_INTERP_FID0_C1_MASK		0x3fff
> +#define VPE_INTERP_FID0_C1_SHIFT	2
> +#define VPE_INTERP_FID0_C0_MASK		0x3fff
> +#define VPE_INTERP_FID0_C0_SHIFT	18
> +
> +#define VPE_US1_R3			0x0310
> +#define VPE_US2_R3			0x0410
> +#define VPE_US3_R3			0x0510
> +#define VPE_INTERP_FID0_C3_MASK		0x3fff
> +#define VPE_INTERP_FID0_C3_SHIFT	2
> +#define VPE_INTERP_FID0_C2_MASK		0x3fff
> +#define VPE_INTERP_FID0_C2_SHIFT	18
> +
> +#define VPE_US1_R4			0x0314
> +#define VPE_US2_R4			0x0414
> +#define VPE_US3_R4			0x0514
> +#define VPE_ANCHOR_FID1_C1_MASK		0x3fff
> +#define VPE_ANCHOR_FID1_C1_SHIFT	2
> +#define VPE_ANCHOR_FID1_C0_MASK		0x3fff
> +#define VPE_ANCHOR_FID1_C0_SHIFT	18
> +
> +#define VPE_US1_R5			0x0318
> +#define VPE_US2_R5			0x0418
> +#define VPE_US3_R5			0x0518
> +#define VPE_ANCHOR_FID1_C3_MASK		0x3fff
> +#define VPE_ANCHOR_FID1_C3_SHIFT	2
> +#define VPE_ANCHOR_FID1_C2_MASK		0x3fff
> +#define VPE_ANCHOR_FID1_C2_SHIFT	18
> +
> +#define VPE_US1_R6			0x031c
> +#define VPE_US2_R6			0x041c
> +#define VPE_US3_R6			0x051c
> +#define VPE_INTERP_FID1_C1_MASK		0x3fff
> +#define VPE_INTERP_FID1_C1_SHIFT	2
> +#define VPE_INTERP_FID1_C0_MASK		0x3fff
> +#define VPE_INTERP_FID1_C0_SHIFT	18
> +
> +#define VPE_US1_R7			0x0320
> +#define VPE_US2_R7			0x0420
> +#define VPE_US3_R7			0x0520
> +#define VPE_INTERP_FID0_C3_MASK		0x3fff
> +#define VPE_INTERP_FID0_C3_SHIFT	2
> +#define VPE_INTERP_FID0_C2_MASK		0x3fff
> +#define VPE_INTERP_FID0_C2_SHIFT	18
> +
> +/* VPE de-interlacer regs */
> +#define VPE_DEI_FRAME_SIZE		0x0600
> +#define VPE_DEI_WIDTH_MASK		0x07ff
> +#define VPE_DEI_WIDTH_SHIFT		0
> +#define VPE_DEI_HEIGHT_MASK		0x07ff
> +#define VPE_DEI_HEIGHT_SHIFT		16
> +#define VPE_DEI_INTERLACE_BYPASS	(1 << 29)
> +#define VPE_DEI_FIELD_FLUSH		(1 << 30)
> +#define VPE_DEI_PROGRESSIVE		(1 << 31)
> +
> +#define VPE_MDT_BYPASS			0x0604
> +#define VPE_MDT_TEMPMAX_BYPASS		(1 << 0)
> +#define VPE_MDT_SPATMAX_BYPASS		(1 << 1)
> +
> +#define VPE_MDT_SF_THRESHOLD		0x0608
> +#define VPE_MDT_SF_SC_THR1_MASK		0xff
> +#define VPE_MDT_SF_SC_THR1_SHIFT	0
> +#define VPE_MDT_SF_SC_THR2_MASK		0xff
> +#define VPE_MDT_SF_SC_THR2_SHIFT	0
> +#define VPE_MDT_SF_SC_THR3_MASK		0xff
> +#define VPE_MDT_SF_SC_THR3_SHIFT	0
> +
> +#define VPE_EDI_CONFIG			0x060c
> +#define VPE_EDI_INP_MODE_MASK		0x03
> +#define VPE_EDI_INP_MODE_SHIFT		0
> +#define VPE_EDI_ENABLE_3D		(1 << 2)
> +#define VPE_EDI_ENABLE_CHROMA_3D	(1 << 3)
> +#define VPE_EDI_CHROMA3D_COR_THR_MASK	0xff
> +#define VPE_EDI_CHROMA3D_COR_THR_SHIFT	8
> +#define VPE_EDI_DIR_COR_LOWER_THR_MASK	0xff
> +#define VPE_EDI_DIR_COR_LOWER_THR_SHIFT	16
> +#define VPE_EDI_COR_SCALE_FACTOR_MASK	0xff
> +#define VPE_EDI_COR_SCALE_FACTOR_SHIFT	23
> +
> +#define VPE_DEI_EDI_LUT_R0		0x0610
> +#define VPE_EDI_LUT0_MASK		0x1f
> +#define VPE_EDI_LUT0_SHIFT		0
> +#define VPE_EDI_LUT1_MASK		0x1f
> +#define VPE_EDI_LUT1_SHIFT		8
> +#define VPE_EDI_LUT2_MASK		0x1f
> +#define VPE_EDI_LUT2_SHIFT		16
> +#define VPE_EDI_LUT3_MASK		0x1f
> +#define VPE_EDI_LUT3_SHIFT		24
> +
> +#define VPE_DEI_EDI_LUT_R1		0x0614
> +#define VPE_EDI_LUT0_MASK		0x1f
> +#define VPE_EDI_LUT0_SHIFT		0
> +#define VPE_EDI_LUT1_MASK		0x1f
> +#define VPE_EDI_LUT1_SHIFT		8
> +#define VPE_EDI_LUT2_MASK		0x1f
> +#define VPE_EDI_LUT2_SHIFT		16
> +#define VPE_EDI_LUT3_MASK		0x1f
> +#define VPE_EDI_LUT3_SHIFT		24
> +
> +#define VPE_DEI_EDI_LUT_R2		0x0618
> +#define VPE_EDI_LUT4_MASK		0x1f
> +#define VPE_EDI_LUT4_SHIFT		0
> +#define VPE_EDI_LUT5_MASK		0x1f
> +#define VPE_EDI_LUT5_SHIFT		8
> +#define VPE_EDI_LUT6_MASK		0x1f
> +#define VPE_EDI_LUT6_SHIFT		16
> +#define VPE_EDI_LUT7_MASK		0x1f
> +#define VPE_EDI_LUT7_SHIFT		24
> +
> +#define VPE_DEI_EDI_LUT_R3		0x061c
> +#define VPE_EDI_LUT8_MASK		0x1f
> +#define VPE_EDI_LUT8_SHIFT		0
> +#define VPE_EDI_LUT9_MASK		0x1f
> +#define VPE_EDI_LUT9_SHIFT		8
> +#define VPE_EDI_LUT10_MASK		0x1f
> +#define VPE_EDI_LUT10_SHIFT		16
> +#define VPE_EDI_LUT11_MASK		0x1f
> +#define VPE_EDI_LUT11_SHIFT		24
> +
> +#define VPE_DEI_FMD_WINDOW_R0		0x0620
> +#define VPE_FMD_WINDOW_MINX_MASK	0x07ff
> +#define VPE_FMD_WINDOW_MINX_SHIFT	0
> +#define VPE_FMD_WINDOW_MAXX_MASK	0x07ff
> +#define VPE_FMD_WINDOW_MAXX_SHIFT	16
> +#define VPE_FMD_WINDOW_ENABLE		(1 << 31)
> +
> +#define VPE_DEI_FMD_WINDOW_R1		0x0624
> +#define VPE_FMD_WINDOW_MINY_MASK	0x07ff
> +#define VPE_FMD_WINDOW_MINY_SHIFT	0
> +#define VPE_FMD_WINDOW_MAXY_MASK	0x07ff
> +#define VPE_FMD_WINDOW_MAXY_SHIFT	16
> +
> +#define VPE_DEI_FMD_CONTROL_R0		0x0628
> +#define VPE_FMD_ENABLE			(1 << 0)
> +#define VPE_FMD_LOCK			(1 << 1)
> +#define VPE_FMD_JAM_DIR			(1 << 2)
> +#define VPE_FMD_BED_ENABLE		(1 << 3)
> +#define VPE_FMD_CAF_FIELD_THR_MASK	0xff
> +#define VPE_FMD_CAF_FIELD_THR_SHIFT	16
> +#define VPE_FMD_CAF_LINE_THR_MASK	0xff
> +#define VPE_FMD_CAF_LINE_THR_SHIFT	24
> +
> +#define VPE_DEI_FMD_CONTROL_R1		0x062c
> +#define VPE_FMD_CAF_THR_MASK		0x000fffff
> +#define VPE_FMD_CAF_THR_SHIFT		0
> +
> +#define VPE_DEI_FMD_STATUS_R0		0x0630
> +#define VPE_FMD_CAF_MASK		0x000fffff
> +#define VPE_FMD_CAF_SHIFT		0
> +#define VPE_FMD_RESET			(1 << 24)
> +
> +#define VPE_DEI_FMD_STATUS_R1		0x0634
> +#define VPE_FMD_FIELD_DIFF_MASK		0x0fffffff
> +#define VPE_FMD_FIELD_DIFF_SHIFT	0
> +
> +#define VPE_DEI_FMD_STATUS_R2		0x0638
> +#define VPE_FMD_FRAME_DIFF_MASK		0x000fffff
> +#define VPE_FMD_FRAME_DIFF_SHIFT	0
> +
> +/* VPE scaler regs */
> +#define VPE_SC_MP_SC0			0x0700
> +#define VPE_INTERLACE_O			(1 << 0)
> +#define VPE_LINEAR			(1 << 1)
> +#define VPE_SC_BYPASS			(1 << 2)
> +#define VPE_INVT_FID			(1 << 3)
> +#define VPE_USE_RAV			(1 << 4)
> +#define VPE_ENABLE_EV			(1 << 5)
> +#define VPE_AUTO_HS			(1 << 6)
> +#define VPE_DCM_2X			(1 << 7)
> +#define VPE_DCM_4X			(1 << 8)
> +#define VPE_HP_BYPASS			(1 << 9)
> +#define VPE_INTERLACE_I			(1 << 10)
> +#define VPE_ENABLE_SIN2_VER_INTP	(1 << 11)
> +#define VPE_Y_PK_EN			(1 << 14)
> +#define VPE_TRIM			(1 << 15)
> +#define VPE_SELFGEN_FID			(1 << 16)
> +
> +#define VPE_SC_MP_SC1			0x0704
> +#define VPE_ROW_ACC_INC_MASK		0x07ffffff
> +#define VPE_ROW_ACC_INC_SHIFT		0
> +
> +#define VPE_SC_MP_SC2			0x0708
> +#define VPE_ROW_ACC_OFFSET_MASK		0x0fffffff
> +#define VPE_ROW_ACC_OFFSET_SHIFT	0
> +
> +#define VPE_SC_MP_SC3			0x070c
> +#define VPE_ROW_ACC_OFFSET_B_MASK	0x0fffffff
> +#define VPE_ROW_ACC_OFFSET_B_SHIFT	0
> +
> +#define VPE_SC_MP_SC4			0x0710
> +#define VPE_TAR_H_MASK			0x07ff
> +#define VPE_TAR_H_SHIFT			0
> +#define VPE_TAR_W_MASK			0x07ff
> +#define VPE_TAR_W_SHIFT			12
> +#define VPE_LIN_ACC_INC_U_MASK		0x07
> +#define VPE_LIN_ACC_INC_U_SHIFT		24
> +#define VPE_NLIN_ACC_INIT_U_MASK	0x07
> +#define VPE_NLIN_ACC_INIT_U_SHIFT	28
> +
> +#define VPE_SC_MP_SC5			0x0714
> +#define VPE_SRC_H_MASK			0x07ff
> +#define VPE_SRC_H_SHIFT			0
> +#define VPE_SRC_W_MASK			0x07ff
> +#define VPE_SRC_W_SHIFT			12
> +#define VPE_NLIN_ACC_INC_U_MASK		0x07
> +#define VPE_NLIN_ACC_INC_U_SHIFT	24
> +
> +#define VPE_SC_MP_SC6			0x0718
> +#define VPE_ROW_ACC_INIT_RAV_MASK	0x03ff
> +#define VPE_ROW_ACC_INIT_RAV_SHIFT	0
> +#define VPE_ROW_ACC_INIT_RAV_B_MASK	0x03ff
> +#define VPE_ROW_ACC_INIT_RAV_B_SHIFT	10
> +
> +#define VPE_SC_MP_SC8			0x0720
> +#define VPE_NLIN_LEFT_MASK		0x07ff
> +#define VPE_NLIN_LEFT_SHIFT		0
> +#define VPE_NLIN_RIGHT_MASK		0x07ff
> +#define VPE_NLIN_RIGHT_SHIFT		12
> +
> +#define VPE_SC_MP_SC9			0x0724
> +#define VPE_LIN_ACC_INC			VPE_SC_MP_SC9
> +
> +#define VPE_SC_MP_SC10			0x0728
> +#define VPE_NLIN_ACC_INIT		VPE_SC_MP_SC10
> +
> +#define VPE_SC_MP_SC11			0x072c
> +#define VPE_NLIN_ACC_INC		VPE_SC_MP_SC11
> +
> +#define VPE_SC_MP_SC12			0x0730
> +#define VPE_COL_ACC_OFFSET_MASK		0x01ffffff
> +#define VPE_COL_ACC_OFFSET_SHIFT	0
> +
> +#define VPE_SC_MP_SC13			0x0734
> +#define VPE_SC_FACTOR_RAV_MASK		0x03ff
> +#define VPE_SC_FACTOR_RAV_SHIFT		0
> +#define VPE_CHROMA_INTP_THR_MASK	0x03ff
> +#define VPE_CHROMA_INTP_THR_SHIFT	12
> +#define VPE_DELTA_CHROMA_THR_MASK	0x0f
> +#define VPE_DELTA_CHROMA_THR_SHIFT	24
> +
> +#define VPE_SC_MP_SC17			0x0744
> +#define VPE_EV_THR_MASK			0x03ff
> +#define VPE_EV_THR_SHIFT		12
> +#define VPE_DELTA_LUMA_THR_MASK		0x0f
> +#define VPE_DELTA_LUMA_THR_SHIFT	24
> +#define VPE_DELTA_EV_THR_MASK		0x0f
> +#define VPE_DELTA_EV_THR_SHIFT		28
> +
> +#define VPE_SC_MP_SC18			0x0748
> +#define VPE_HS_FACTOR_MASK		0x03ff
> +#define VPE_HS_FACTOR_SHIFT		0
> +#define VPE_CONF_DEFAULT_MASK		0x01ff
> +#define VPE_CONF_DEFAULT_SHIFT		16
> +
> +#define VPE_SC_MP_SC19			0x074c
> +#define VPE_HPF_COEFF0_MASK		0xff
> +#define VPE_HPF_COEFF0_SHIFT		0
> +#define VPE_HPF_COEFF1_MASK		0xff
> +#define VPE_HPF_COEFF1_SHIFT		8
> +#define VPE_HPF_COEFF2_MASK		0xff
> +#define VPE_HPF_COEFF2_SHIFT		16
> +#define VPE_HPF_COEFF3_MASK		0xff
> +#define VPE_HPF_COEFF3_SHIFT		23
> +
> +#define VPE_SC_MP_SC20			0x0750
> +#define VPE_HPF_COEFF4_MASK		0xff
> +#define VPE_HPF_COEFF4_SHIFT		0
> +#define VPE_HPF_COEFF5_MASK		0xff
> +#define VPE_HPF_COEFF5_SHIFT		8
> +#define VPE_HPF_NORM_SHIFT_MASK		0x07
> +#define VPE_HPF_NORM_SHIFT_SHIFT	16
> +#define VPE_NL_LIMIT_MASK		0x1ff
> +#define VPE_NL_LIMIT_SHIFT		20
> +
> +#define VPE_SC_MP_SC21			0x0754
> +#define VPE_NL_LO_THR_MASK		0x01ff
> +#define VPE_NL_LO_THR_SHIFT		0
> +#define VPE_NL_LO_SLOPE_MASK		0xff
> +#define VPE_NL_LO_SLOPE_SHIFT		16
> +
> +#define VPE_SC_MP_SC22			0x0758
> +#define VPE_NL_HI_THR_MASK		0x01ff
> +#define VPE_NL_HI_THR_SHIFT		0
> +#define VPE_NL_HI_SLOPE_SH_MASK		0x07
> +#define VPE_NL_HI_SLOPE_SH_SHIFT	16
> +
> +#define VPE_SC_MP_SC23			0x075c
> +#define VPE_GRADIENT_THR_MASK		0x07ff
> +#define VPE_GRADIENT_THR_SHIFT		0
> +#define VPE_GRADIENT_THR_RANGE_MASK	0x0f
> +#define VPE_GRADIENT_THR_RANGE_SHIFT	12
> +#define VPE_MIN_GY_THR_MASK		0xff
> +#define VPE_MIN_GY_THR_SHIFT		16
> +#define VPE_MIN_GY_THR_RANGE_MASK	0x0f
> +#define VPE_MIN_GY_THR_RANGE_SHIFT	28
> +
> +#define VPE_SC_MP_SC24			0x0760
> +#define VPE_ORG_H_MASK			0x07ff
> +#define VPE_ORG_H_SHIFT			0
> +#define VPE_ORG_W_MASK			0x07ff
> +#define VPE_ORG_W_SHIFT			16
> +
> +#define VPE_SC_MP_SC25			0x0764
> +#define VPE_OFF_H_MASK			0x07ff
> +#define VPE_OFF_H_SHIFT			0
> +#define VPE_OFF_W_MASK			0x07ff
> +#define VPE_OFF_W_SHIFT			16
> +
> +/* VPE color space converter regs */
> +#define VPE_CSC_CSC00			0x5700
> +#define VPE_CSC_A0_MASK			0x1fff
> +#define VPE_CSC_A0_SHIFT		0
> +#define VPE_CSC_B0_MASK			0x1fff
> +#define VPE_CSC_B0_SHIFT		16
> +
> +#define VPE_CSC_CSC01			0x5704
> +#define VPE_CSC_C0_MASK			0x1fff
> +#define VPE_CSC_C0_SHIFT		0
> +#define VPE_CSC_A1_MASK			0x1fff
> +#define VPE_CSC_A1_SHIFT		16
> +
> +#define VPE_CSC_CSC02			0x5708
> +#define VPE_CSC_B1_MASK			0x1fff
> +#define VPE_CSC_B1_SHIFT		0
> +#define VPE_CSC_C1_MASK			0x1fff
> +#define VPE_CSC_C1_SHIFT		16
> +
> +#define VPE_CSC_CSC03			0x570c
> +#define VPE_CSC_A2_MASK			0x1fff
> +#define VPE_CSC_A2_SHIFT		0
> +#define VPE_CSC_B2_MASK			0x1fff
> +#define VPE_CSC_B2_SHIFT		16
> +
> +#define VPE_CSC_CSC04			0x5710
> +#define VPE_CSC_C2_MASK			0x1fff
> +#define VPE_CSC_C2_SHIFT		0
> +#define VPE_CSC_D0_MASK			0x0fff
> +#define VPE_CSC_D0_SHIFT		16
> +
> +#define VPE_CSC_CSC05			0x5714
> +#define VPE_CSC_D1_MASK			0x0fff
> +#define VPE_CSC_D1_SHIFT		0
> +#define VPE_CSC_D2_MASK			0x0fff
> +#define VPE_CSC_D2_SHIFT		16
> +#define VPE_CSC_BYPASS			(1 << 28)
> +
> +#endif
> diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> index 083bb5a..1666aab 100644
> --- a/include/uapi/linux/v4l2-controls.h
> +++ b/include/uapi/linux/v4l2-controls.h
> @@ -160,6 +160,10 @@ enum v4l2_colorfx {
>   * of controls. Total of 16 controls is reserved for this driver */
>  #define V4L2_CID_USER_SI476X_BASE		(V4L2_CID_USER_BASE + 0x1040)
>  
> +/* The base for the TI VPE driver controls. Total of 16 controls is reserved for
> + * this driver */
> +#define V4L2_CID_USER_TI_VPE_BASE		(V4L2_CID_USER_BASE + 0x1050)
> +
>  /* MPEG-class control IDs */
>  /* The MPEG controls are applicable to all codec controls
>   * and the 'MPEG' part of the define is historical */
> 

Regards,

	Hans
