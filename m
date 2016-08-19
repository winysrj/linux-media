Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:1383 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750806AbcHSGA3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 02:00:29 -0400
Message-ID: <1471586051.1540.11.camel@mtksdaap41>
Subject: Re: [PATCH v3 3/4] media: Add Mediatek MDP Driver
From: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
        <daniel.thompson@linaro.org>, "Rob Herring" <robh+dt@kernel.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Pawel Osciak <posciak@chromium.org>,
        <srv_heupstream@mediatek.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-media@vger.kernel.org>, <linux-mediatek@lists.infradead.org>
Date: Fri, 19 Aug 2016 13:54:11 +0800
In-Reply-To: <861e5c51-1333-fdc7-2793-d4741a48c72f@xs4all.nl>
References: <1470751137-12403-1-git-send-email-minghsiu.tsai@mediatek.com>
         <1470751137-12403-4-git-send-email-minghsiu.tsai@mediatek.com>
         <861e5c51-1333-fdc7-2793-d4741a48c72f@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2016-08-15 at 14:55 +0200, Hans Verkuil wrote:
> On 08/09/2016 03:58 PM, Minghsiu Tsai wrote:
> > Add MDP driver for MT8173
> > 
> > Signed-off-by: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
> > ---
> >  drivers/media/platform/Kconfig                |   16 +
> >  drivers/media/platform/Makefile               |    2 +
> >  drivers/media/platform/mtk-mdp/Makefile       |    9 +
> >  drivers/media/platform/mtk-mdp/mtk_mdp_comp.c |  159 ++++
> >  drivers/media/platform/mtk-mdp/mtk_mdp_comp.h |   72 ++
> >  drivers/media/platform/mtk-mdp/mtk_mdp_core.c |  294 ++++++
> >  drivers/media/platform/mtk-mdp/mtk_mdp_core.h |  240 +++++
> >  drivers/media/platform/mtk-mdp/mtk_mdp_ipi.h  |  126 +++
> >  drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c  | 1263 +++++++++++++++++++++++++
> >  drivers/media/platform/mtk-mdp/mtk_mdp_m2m.h  |   22 +
> >  drivers/media/platform/mtk-mdp/mtk_mdp_regs.c |  153 +++
> >  drivers/media/platform/mtk-mdp/mtk_mdp_regs.h |   31 +
> >  drivers/media/platform/mtk-mdp/mtk_mdp_vpu.c  |  145 +++
> >  drivers/media/platform/mtk-mdp/mtk_mdp_vpu.h  |   41 +
> >  14 files changed, 2573 insertions(+)
> >  create mode 100644 drivers/media/platform/mtk-mdp/Makefile
> >  create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_comp.c
> >  create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_comp.h
> >  create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_core.c
> >  create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_core.h
> >  create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_ipi.h
> >  create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
> >  create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.h
> >  create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_regs.c
> >  create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_regs.h
> >  create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_vpu.c
> >  create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_vpu.h
> > 
> > diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> > index f25344b..4bb874b 100644
> > --- a/drivers/media/platform/Kconfig
> > +++ b/drivers/media/platform/Kconfig
> > @@ -166,6 +166,22 @@ config VIDEO_MEDIATEK_VPU
> >  	    To compile this driver as a module, choose M here: the
> >  	    module will be called mtk-vpu.
> >  
> > +config VIDEO_MEDIATEK_MDP
> > +	tristate "Mediatek MDP driver"
> > +	depends on MTK_IOMMU || COMPILE_TEST
> > +	depends on VIDEO_DEV && VIDEO_V4L2
> > +	depends on ARCH_MEDIATEK || COMPILE_TEST
> 
> This needs a 'depends on HAS_DMA' as well.
> 

Will add it.

> > +	select VIDEOBUF2_DMA_CONTIG
> > +	select V4L2_MEM2MEM_DEV
> > +	select VIDEO_MEDIATEK_VPU
> > +	default n
> > +	---help---
> > +	    It is a v4l2 driver and present in Mediatek MT8173 SoCs.
> > +	    The driver supports for scaling and color space conversion.
> > +
> > +	    To compile this driver as a module, choose M here: the
> > +	    module will be called mtk-mdp.
> > +
> >  config VIDEO_MEDIATEK_VCODEC
> >  	tristate "Mediatek Video Codec driver"
> >  	depends on MTK_IOMMU || COMPILE_TEST
> 
> <snip>
> 
> > +
> > +/*
> > + * Return true if rectangle a is enclosed in rectangle b, or false otherwise.
> > + */
> > +static bool mtk_mdp_m2m_is_rectangle_enclosed(struct v4l2_rect *a,
> > +					     struct v4l2_rect *b)
> > +{
> > +	if (a->left < b->left || a->top < b->top)
> > +		return false;
> > +
> > +	if (a->left + a->width > b->left + b->width)
> > +		return false;
> > +
> > +	if (a->top + a->height > b->top + b->height)
> > +		return false;
> > +
> > +	return true;
> > +}
> > +
> > +static int mtk_mdp_m2m_g_selection(struct file *file, void *fh,
> > +				   struct v4l2_selection *s)
> > +{
> > +	struct mtk_mdp_frame *frame;
> > +	struct mtk_mdp_ctx *ctx = fh_to_ctx(fh);
> > +
> > +	if ((s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
> > +	    (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)) {
> > +		mtk_mdp_dbg(1, "[%d] invalid type:%d", ctx->id, s->type);
> > +		return -EINVAL;
> > +	}
> > +
> > +	frame = mtk_mdp_ctx_get_frame(ctx, s->type);
> > +
> > +	switch (s->target) {
> > +	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
> > +	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
> > +	case V4L2_SEL_TGT_CROP_BOUNDS:
> > +	case V4L2_SEL_TGT_CROP_DEFAULT:
> > +		s->r.left = 0;
> > +		s->r.top = 0;
> > +		s->r.width = frame->width;
> > +		s->r.height = frame->height;
> > +		return 0;
> > +
> > +	case V4L2_SEL_TGT_COMPOSE:
> > +	case V4L2_SEL_TGT_CROP:
> > +		s->r.left = frame->crop.left;
> > +		s->r.top = frame->crop.top;
> > +		s->r.width = frame->crop.width;
> > +		s->r.height = frame->crop.height;
> > +		return 0;
> > +	}
> 
> This isn't right. For VIDEO_CAPTURE you support the COMPOSE targets, and for
> the VIDEO_OUTPUT you support the CROP targets. Right now I can use e.g. TGT_CROP
> with VIDEO_CAPTURE, which isn't correct.
> 
> s_selection has the same problem.
> 

So my understanding is
VIDEO_OUTPUT -> only allow to use target XXX_CROP_XXX
VIDEO_CAPTURE -> only allow to use target XXX_COMPOSE_XXX

Am I right?


> > +
> > +	return -EINVAL;
> > +}
> > +
> > +static int mtk_mdp_check_scaler_ratio(struct mtk_mdp_variant *var, int src_w,
> > +				      int src_h, int dst_w, int dst_h, int rot)
> > +{
> > +	int tmp_w, tmp_h;
> > +
> > +	if (rot == 90 || rot == 270) {
> > +		tmp_w = dst_h;
> > +		tmp_h = dst_w;
> > +	} else {
> > +		tmp_w = dst_w;
> > +		tmp_h = dst_h;
> > +	}
> > +
> > +	if ((src_w / tmp_w) > var->h_scale_down_max ||
> > +	    (src_h / tmp_h) > var->v_scale_down_max ||
> > +	    (tmp_w / src_w) > var->h_scale_up_max ||
> > +	    (tmp_h / src_h) > var->v_scale_up_max)
> > +		return -EINVAL;
> > +
> > +	return 0;
> > +}
> > +
> > +static int mtk_mdp_m2m_s_selection(struct file *file, void *fh,
> > +				   struct v4l2_selection *s)
> > +{
> > +	struct mtk_mdp_frame *frame;
> > +	struct mtk_mdp_ctx *ctx = fh_to_ctx(fh);
> > +	struct v4l2_crop cr;
> > +	struct mtk_mdp_variant *variant = ctx->mdp_dev->variant;
> > +	int ret;
> > +
> > +	cr.type = s->type;
> > +	cr.c = s->r;
> > +
> > +	if ((s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
> > +	    (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)) {
> > +		mtk_mdp_dbg(1, "[%d] invalid type:%d", ctx->id, s->type);
> > +		return -EINVAL;
> > +	}
> > +
> > +	ret = mtk_mdp_try_crop(ctx, &cr);
> 
> Please don't copy to a v4l2_crop. Just stick to v4l2_selection.
> I would prefer not to see struct v4l2_crop in drivers.
> 

I will replace v4l2_crop with u32 and struct v4l2_rect in next version.


> > +	if (ret)
> > +		return ret;
> > +
> > +	if (s->flags & V4L2_SEL_FLAG_LE &&
> > +	    !mtk_mdp_m2m_is_rectangle_enclosed(&cr.c, &s->r))
> > +		return -ERANGE;
> > +
> > +	if (s->flags & V4L2_SEL_FLAG_GE &&
> > +	    !mtk_mdp_m2m_is_rectangle_enclosed(&s->r, &cr.c))
> > +		return -ERANGE;
> 
> As has been discussed for the encoder driver: just adjust the rectangle and
> don't return ERANGE. Consider the flags as hints.

Already adjust rectangle in mtk_mdp_try_crop() before that, so I will
remove the two condition check in next version.



> The V4L2 documentation is confusing, this will be addressed soon.
> 
> > +
> > +	s->r = cr.c;
> > +
> > +	switch (s->target) {
> > +	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
> > +	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
> > +	case V4L2_SEL_TGT_COMPOSE:
> > +		frame = &ctx->s_frame;
> > +		break;
> > +
> > +	case V4L2_SEL_TGT_CROP_BOUNDS:
> > +	case V4L2_SEL_TGT_CROP:
> > +	case V4L2_SEL_TGT_CROP_DEFAULT:
> > +		frame = &ctx->d_frame;
> > +		break;
> > +
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +
> > +	/* Check to see if scaling ratio is within supported range */
> > +	if (mtk_mdp_ctx_state_is_set(ctx, MTK_MDP_DST_FMT | MTK_MDP_SRC_FMT)) {
> > +		if (V4L2_TYPE_IS_OUTPUT(s->type)) {
> > +			ret = mtk_mdp_check_scaler_ratio(variant, cr.c.width,
> > +				cr.c.height, ctx->d_frame.crop.width,
> > +				ctx->d_frame.crop.height,
> > +				ctx->ctrls.rotate->val);
> > +		} else {
> > +			ret = mtk_mdp_check_scaler_ratio(variant,
> > +				ctx->s_frame.crop.width,
> > +				ctx->s_frame.crop.height, cr.c.width,
> > +				cr.c.height, ctx->ctrls.rotate->val);
> > +		}
> > +
> > +		if (ret) {
> > +			dev_info(&ctx->mdp_dev->pdev->dev,
> > +				"Out of scaler range");
> > +			return -EINVAL;
> > +		}
> > +	}
> > +
> > +	frame->crop = cr.c;
> > +
> > +	return 0;
> > +}
> > +
> > +static const struct v4l2_ioctl_ops mtk_mdp_m2m_ioctl_ops = {
> > +	.vidioc_querycap		= mtk_mdp_m2m_querycap,
> > +	.vidioc_enum_fmt_vid_cap_mplane	= mtk_mdp_m2m_enum_fmt_mplane_vid_cap,
> > +	.vidioc_enum_fmt_vid_out_mplane	= mtk_mdp_m2m_enum_fmt_mplane_vid_out,
> > +	.vidioc_g_fmt_vid_cap_mplane	= mtk_mdp_m2m_g_fmt_mplane,
> > +	.vidioc_g_fmt_vid_out_mplane	= mtk_mdp_m2m_g_fmt_mplane,
> > +	.vidioc_try_fmt_vid_cap_mplane	= mtk_mdp_m2m_try_fmt_mplane,
> > +	.vidioc_try_fmt_vid_out_mplane	= mtk_mdp_m2m_try_fmt_mplane,
> > +	.vidioc_s_fmt_vid_cap_mplane	= mtk_mdp_m2m_s_fmt_mplane,
> > +	.vidioc_s_fmt_vid_out_mplane	= mtk_mdp_m2m_s_fmt_mplane,
> > +	.vidioc_reqbufs			= mtk_mdp_m2m_reqbufs,
> > +	.vidioc_create_bufs		= v4l2_m2m_ioctl_create_bufs,
> > +	.vidioc_expbuf			= v4l2_m2m_ioctl_expbuf,
> > +	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
> > +	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
> > +	.vidioc_querybuf		= v4l2_m2m_ioctl_querybuf,
> > +	.vidioc_qbuf			= v4l2_m2m_ioctl_qbuf,
> > +	.vidioc_dqbuf			= v4l2_m2m_ioctl_dqbuf,
> > +	.vidioc_streamon		= mtk_mdp_m2m_streamon,
> > +	.vidioc_streamoff		= v4l2_m2m_ioctl_streamoff,
> > +	.vidioc_g_selection		= mtk_mdp_m2m_g_selection,
> > +	.vidioc_s_selection		= mtk_mdp_m2m_s_selection
> > +};
> > +
> > +static int mtk_mdp_m2m_queue_init(void *priv, struct vb2_queue *src_vq,
> > +				  struct vb2_queue *dst_vq)
> > +{
> > +	struct mtk_mdp_ctx *ctx = priv;
> > +	int ret;
> > +
> > +	memset(src_vq, 0, sizeof(*src_vq));
> > +	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> > +	src_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
> > +	src_vq->drv_priv = ctx;
> > +	src_vq->ops = &mtk_mdp_m2m_qops;
> > +	src_vq->mem_ops = &vb2_dma_contig_memops;
> > +	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
> > +	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> > +	src_vq->dev = &ctx->mdp_dev->pdev->dev;
> > +
> > +	ret = vb2_queue_init(src_vq);
> > +	if (ret)
> > +		return ret;
> > +
> > +	memset(dst_vq, 0, sizeof(*dst_vq));
> > +	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> > +	dst_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
> 
> I wouldn't recommend setting VB2_USERPTR in combination with dma_contig.
> 
> That only works if the userptr points to physically contiguous memory,
> unless there is an iommu that can fix things up.
> 

I will remove VB2_USERPTR.Thanks.

> > +	dst_vq->drv_priv = ctx;
> > +	dst_vq->ops = &mtk_mdp_m2m_qops;
> > +	dst_vq->mem_ops = &vb2_dma_contig_memops;
> > +	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
> > +	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> > +	dst_vq->dev = &ctx->mdp_dev->pdev->dev;
> > +
> > +	return vb2_queue_init(dst_vq);
> > +}
> > +
> > +static int mtk_mdp_s_ctrl(struct v4l2_ctrl *ctrl)
> > +{
> > +	struct mtk_mdp_ctx *ctx = ctrl_to_ctx(ctrl);
> > +	struct mtk_mdp_dev *mdp = ctx->mdp_dev;
> > +	struct mtk_mdp_variant *variant = mdp->variant;
> > +	u32 state = MTK_MDP_DST_FMT | MTK_MDP_SRC_FMT;
> > +	int ret = 0;
> > +
> > +	if (ctrl->flags & V4L2_CTRL_FLAG_INACTIVE)
> > +		return 0;
> > +
> > +	switch (ctrl->id) {
> > +	case V4L2_CID_HFLIP:
> > +		ctx->hflip = ctrl->val;
> > +		break;
> > +	case V4L2_CID_VFLIP:
> > +		ctx->vflip = ctrl->val;
> > +		break;
> > +	case V4L2_CID_ROTATE:
> > +		if (mtk_mdp_ctx_state_is_set(ctx, state)) {
> > +			ret = mtk_mdp_check_scaler_ratio(variant,
> > +					ctx->s_frame.crop.width,
> > +					ctx->s_frame.crop.height,
> > +					ctx->d_frame.crop.width,
> > +					ctx->d_frame.crop.height,
> > +					ctx->ctrls.rotate->val);
> > +
> > +			if (ret)
> > +				return -EINVAL;
> > +		}
> > +
> > +		ctx->rotation = ctrl->val;
> > +		break;
> > +	case V4L2_CID_ALPHA_COMPONENT:
> > +		ctx->d_frame.alpha = ctrl->val;
> > +		break;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static const struct v4l2_ctrl_ops mtk_mdp_ctrl_ops = {
> > +	.s_ctrl = mtk_mdp_s_ctrl,
> > +};
> > +
> > +static int mtk_mdp_ctrls_create(struct mtk_mdp_ctx *ctx)
> > +{
> > +	v4l2_ctrl_handler_init(&ctx->ctrl_handler, MTK_MDP_MAX_CTRL_NUM);
> > +
> > +	ctx->ctrls.rotate = v4l2_ctrl_new_std(&ctx->ctrl_handler,
> > +			&mtk_mdp_ctrl_ops, V4L2_CID_ROTATE, 0, 270, 90, 0);
> > +	ctx->ctrls.hflip = v4l2_ctrl_new_std(&ctx->ctrl_handler,
> > +					     &mtk_mdp_ctrl_ops,
> > +					     V4L2_CID_HFLIP,
> > +					     0, 1, 1, 0);
> > +	ctx->ctrls.vflip = v4l2_ctrl_new_std(&ctx->ctrl_handler,
> > +					     &mtk_mdp_ctrl_ops,
> > +					     V4L2_CID_VFLIP,
> > +					     0, 1, 1, 0);
> > +	ctx->ctrls.global_alpha = v4l2_ctrl_new_std(&ctx->ctrl_handler,
> > +						    &mtk_mdp_ctrl_ops,
> > +						    V4L2_CID_ALPHA_COMPONENT,
> > +						    0, 255, 1, 0);
> > +	ctx->ctrls_rdy = ctx->ctrl_handler.error == 0;
> > +
> > +	if (ctx->ctrl_handler.error) {
> > +		int err = ctx->ctrl_handler.error;
> > +
> > +		v4l2_ctrl_handler_free(&ctx->ctrl_handler);
> > +		dev_err(&ctx->mdp_dev->pdev->dev,
> > +			"Failed to create control handlers\n");
> > +		return err;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static void mtk_mdp_set_default_params(struct mtk_mdp_ctx *ctx)
> > +{
> > +	struct mtk_mdp_dev *mdp = ctx->mdp_dev;
> > +	struct mtk_mdp_frame *frame;
> > +
> > +	frame = mtk_mdp_ctx_get_frame(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE);
> > +	frame->fmt = mtk_mdp_find_fmt_by_index(0,
> > +					V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE);
> > +	frame->width = mdp->variant->pix_min->org_w;
> > +	frame->height = mdp->variant->pix_min->org_h;
> > +	frame->payload[0] = frame->width * frame->height;
> > +	frame->payload[1] = frame->payload[0] / 2;
> > +
> > +	frame = mtk_mdp_ctx_get_frame(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE);
> > +	frame->fmt = mtk_mdp_find_fmt_by_index(0,
> > +					V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE);
> > +	frame->width = mdp->variant->pix_min->target_rot_dis_w;
> > +	frame->height = mdp->variant->pix_min->target_rot_dis_h;
> > +	frame->payload[0] = frame->width * frame->height;
> > +	frame->payload[1] = frame->payload[0] / 2;
> > +
> > +}
> > +
> > +static int mtk_mdp_m2m_open(struct file *file)
> > +{
> > +	struct mtk_mdp_dev *mdp = video_drvdata(file);
> > +	struct video_device *vfd = video_devdata(file);
> > +	struct mtk_mdp_ctx *ctx = NULL;
> > +	int ret;
> > +
> > +	if (mutex_lock_interruptible(&mdp->lock))
> > +		return -ERESTARTSYS;
> 
> This lock is taken very early. Move it down to where you really need the lock,
> it can certainly be moved to after the kzalloc.
> 

I will move mutex_loc after kzalloc. Thanks for your suggestions.

> > +
> > +	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
> > +	if (!ctx) {
> > +		ret = -ENOMEM;
> > +		goto err_ctx_alloc;
> > +	}
> > +
> > +	mutex_init(&ctx->slock);
> > +	ctx->id = mdp->id_counter++;
> > +	v4l2_fh_init(&ctx->fh, vfd);
> > +	file->private_data = &ctx->fh;
> > +	ret = mtk_mdp_ctrls_create(ctx);
> > +	if (ret)
> > +		goto error_ctrls;
> > +
> > +	/* Use separate control handler per file handle */
> > +	ctx->fh.ctrl_handler = &ctx->ctrl_handler;
> > +	v4l2_fh_add(&ctx->fh);
> > +	INIT_LIST_HEAD(&ctx->list);
> > +
> > +	ctx->mdp_dev = mdp;
> > +	mtk_mdp_set_default_params(ctx);
> > +
> > +	INIT_WORK(&ctx->work, mtk_mdp_m2m_worker);
> > +	ctx->m2m_ctx = v4l2_m2m_ctx_init(mdp->m2m_dev, ctx,
> > +					 mtk_mdp_m2m_queue_init);
> > +	if (IS_ERR(ctx->m2m_ctx)) {
> > +		dev_err(&mdp->pdev->dev, "Failed to initialize m2m context");
> > +		ret = PTR_ERR(ctx->m2m_ctx);
> > +		goto error_m2m_ctx;
> > +	}
> > +	ctx->fh.m2m_ctx = ctx->m2m_ctx;
> > +	if (mdp->ctx_num++ == 0) {
> > +		ret = vpu_load_firmware(mdp->vpu_dev);
> > +		if (ret < 0) {
> > +			dev_err(&mdp->pdev->dev,
> > +				"vpu_load_firmware failed %d\n", ret);
> > +			goto err_load_vpu;
> > +		}
> > +
> > +		ret = mtk_mdp_vpu_register(mdp->pdev);
> > +		if (ret < 0) {
> > +			dev_err(&mdp->pdev->dev,
> > +				"mdp_vpu register failed %d\n", ret);
> > +			goto err_load_vpu;
> > +		}
> > +	}
> > +
> > +	list_add(&ctx->list, &mdp->ctx_list);
> > +	mutex_unlock(&mdp->lock);
> > +
> > +	mtk_mdp_dbg(0, "%s [%d]", dev_name(&mdp->pdev->dev), ctx->id);
> > +
> > +	return 0;
> > +
> > +err_load_vpu:
> > +	mdp->ctx_num--;
> > +	v4l2_m2m_ctx_release(ctx->m2m_ctx);
> > +error_m2m_ctx:
> > +	v4l2_ctrl_handler_free(&ctx->ctrl_handler);
> > +error_ctrls:
> > +	v4l2_fh_del(&ctx->fh);
> > +	v4l2_fh_exit(&ctx->fh);
> > +err_ctx_alloc:
> > +	kfree(ctx);
> > +	mutex_unlock(&mdp->lock);
> > +
> > +	return ret;
> > +}
> 
> <snip>


