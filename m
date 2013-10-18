Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:9126 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709Ab3JRJH7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Oct 2013 05:07:59 -0400
Message-id: <5260FA6A.3000303@samsung.com>
Date: Fri, 18 Oct 2013 11:07:54 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Shaik Ameer Basha <shaik.ameer@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	'Arun Kumar K' <arun.kk@samsung.com>
Cc: posciak@google.com, inki.dae@samsung.com, hverkuil@xs4all.nl
Subject: Re: [PATCH v4 2/4] [media] exynos-scaler: Add core functionality for
 the SCALER driver
References: <1380889594-10448-1-git-send-email-shaik.ameer@samsung.com>
 <1380889594-10448-3-git-send-email-shaik.ameer@samsung.com>
In-reply-to: <1380889594-10448-3-git-send-email-shaik.ameer@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/10/13 14:26, Shaik Ameer Basha wrote:
> This patch adds the core functionality for the SCALER driver.
> 
> Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

Just couple minor comment below...

> ---
>  drivers/media/platform/exynos-scaler/scaler.c | 1238 +++++++++++++++++++++++++
>  drivers/media/platform/exynos-scaler/scaler.h |  375 ++++++++
>  2 files changed, 1613 insertions(+)
>  create mode 100644 drivers/media/platform/exynos-scaler/scaler.c
>  create mode 100644 drivers/media/platform/exynos-scaler/scaler.h
 [...]
> +static int __scaler_try_ctrl(struct scaler_ctx *ctx, struct v4l2_ctrl *ctrl)
> +{
> +	struct scaler_dev *scaler = ctx->scaler_dev;
> +	struct scaler_variant *variant = scaler->variant;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_ROTATE:
> +		return scaler_check_scaler_ratio(variant,
> +			ctx->s_frame.selection.width,
> +			ctx->s_frame.selection.height,
> +			ctx->d_frame.selection.width,
> +			ctx->d_frame.selection.height,
> +			ctx->ctrls_scaler.rotate->val);
> +	}
> +
> +	return 0;
> +}
> +
> +static int scaler_try_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct scaler_ctx *ctx = ctrl_to_ctx(ctrl);
> +	unsigned long flags;
> +	int ret;
> +
> +	spin_lock_irqsave(&ctx->scaler_dev->slock, flags);
> +	ret = __scaler_try_ctrl(ctx, ctrl);
> +	spin_unlock_irqrestore(&ctx->scaler_dev->slock, flags);
> +
> +	return ret;
> +}
> +
> +static int __scaler_s_ctrl(struct scaler_ctx *ctx, struct v4l2_ctrl *ctrl)
> +{
> +	struct scaler_dev *scaler = ctx->scaler_dev;
> +	struct scaler_variant *variant = scaler->variant;
> +	int ret = 0;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_HFLIP:
> +		ctx->hflip = ctrl->val;
> +		break;
> +
> +	case V4L2_CID_VFLIP:
> +		ctx->vflip = ctrl->val;
> +		break;
> +
> +	case V4L2_CID_ROTATE:
> +		ret = scaler_check_scaler_ratio(variant,
> +			ctx->s_frame.selection.width,
> +			ctx->s_frame.selection.height,
> +			ctx->d_frame.selection.width,
> +			ctx->d_frame.selection.height,
> +			ctx->ctrls_scaler.rotate->val);

I think this check is not needed, since it is already done in
__scaler_try_ctrl() ?

> +		if (ret < 0)
> +			return -EINVAL;
> +
> +		ctx->rotation = ctrl->val;
> +		break;
> +
> +	case V4L2_CID_ALPHA_COMPONENT:
> +		ctx->d_frame.alpha = ctrl->val;
> +		break;
> +	}
> +
> +	ctx->state |= SCALER_PARAMS;
> +	return 0;
> +}
> +
> +static int scaler_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct scaler_ctx *ctx = ctrl_to_ctx(ctrl);
> +	unsigned long flags;
> +	int ret;
> +
> +	spin_lock_irqsave(&ctx->scaler_dev->slock, flags);
> +	ret = __scaler_s_ctrl(ctx, ctrl);
> +	spin_unlock_irqrestore(&ctx->scaler_dev->slock, flags);
> +
> +	return ret;
> +}
> +
> +static const struct v4l2_ctrl_ops scaler_ctrl_ops = {
> +	.try_ctrl = scaler_try_ctrl,
> +	.s_ctrl = scaler_s_ctrl,
> +};
> +
> +int scaler_ctrls_create(struct scaler_ctx *ctx)
> +{
> +	if (ctx->ctrls_rdy) {
> +		scaler_dbg(ctx->scaler_dev,
> +			"Control handler of this ctx was created already");
> +		return 0;
> +	}
> +
> +	v4l2_ctrl_handler_init(&ctx->ctrl_handler, SCALER_MAX_CTRL_NUM);
> +
> +	ctx->ctrls_scaler.rotate = v4l2_ctrl_new_std(&ctx->ctrl_handler,
> +		&scaler_ctrl_ops, V4L2_CID_ROTATE, 0, 270, 90, 0);
> +	ctx->ctrls_scaler.hflip = v4l2_ctrl_new_std(&ctx->ctrl_handler,
> +		&scaler_ctrl_ops, V4L2_CID_HFLIP, 0, 1, 1, 0);
> +	ctx->ctrls_scaler.vflip = v4l2_ctrl_new_std(&ctx->ctrl_handler,
> +		&scaler_ctrl_ops, V4L2_CID_VFLIP, 0, 1, 1, 0);
> +	ctx->ctrls_scaler.global_alpha = v4l2_ctrl_new_std(&ctx->ctrl_handler,
> +		&scaler_ctrl_ops, V4L2_CID_ALPHA_COMPONENT, 0, 255, 1, 0);
> +
> +	ctx->ctrls_rdy = ctx->ctrl_handler.error == 0;
> +
> +	if (ctx->ctrl_handler.error) {
> +		int err = ctx->ctrl_handler.error;
> +		v4l2_ctrl_handler_free(&ctx->ctrl_handler);
> +		scaler_dbg(ctx->scaler_dev,

This should probably be dev_err().

> +			"Failed to create SCALER control handlers");
> +		return err;
> +	}
> +
> +	return 0;
> +}
> +
> +void scaler_ctrls_delete(struct scaler_ctx *ctx)
> +{
> +	if (ctx->ctrls_rdy) {
> +		v4l2_ctrl_handler_free(&ctx->ctrl_handler);
> +		ctx->ctrls_rdy = false;
> +	}
> +}
> +
> +/* The color format (num_comp, num_planes) must be already configured. */
> +int scaler_prepare_addr(struct scaler_ctx *ctx, struct vb2_buffer *vb,
> +			struct scaler_frame *frame, struct scaler_addr *addr)
> +{
> +	int ret = 0;
> +	u32 pix_size;
> +	const struct scaler_fmt *fmt;
> +
> +	if (vb == NULL || frame == NULL)
> +		return -EINVAL;
> +
> +	pix_size = frame->f_width * frame->f_height;
> +	fmt = frame->fmt;
> +
> +	scaler_dbg(ctx->scaler_dev,
> +			"planes= %d, comp= %d, pix_size= %d, fmt = %d\n",
> +			fmt->num_planes, fmt->num_comp,
> +			pix_size, fmt->scaler_color);

Alignment seems wrong here.

> +	addr->y = vb2_dma_contig_plane_dma_addr(vb, 0);
> +
> +	if (fmt->num_planes == 1) {
> +		switch (fmt->num_comp) {
> +		case 1:
> +			addr->cb = 0;
> +			addr->cr = 0;
> +			break;
> +		case 2:
> +			/* Decompose Y into Y/Cb */
> +			addr->cb = (dma_addr_t)(addr->y + pix_size);
> +			addr->cr = 0;
> +			break;
> +		case 3:
> +			/* Decompose Y into Y/Cb/Cr */
> +			addr->cb = (dma_addr_t)(addr->y + pix_size);
> +			if (SCALER_YUV420 == fmt->color)
> +				addr->cr = (dma_addr_t)(addr->cb
> +						+ (pix_size >> 2));
> +			else if (SCALER_YUV422 == fmt->color)
> +				addr->cr = (dma_addr_t)(addr->cb
> +						+ (pix_size >> 1));
> +			else /* 444 */
> +				addr->cr = (dma_addr_t)(addr->cb + pix_size);
> +			break;
> +		default:
> +			scaler_dbg(ctx->scaler_dev,
> +				"Invalid number of color planes\n");
> +			return -EINVAL;
> +		}
> +	} else {
> +		if (fmt->num_planes >= 2)
> +			addr->cb = vb2_dma_contig_plane_dma_addr(vb, 1);
> +
> +		if (fmt->num_planes == 3)
> +			addr->cr = vb2_dma_contig_plane_dma_addr(vb, 2);
> +	}
> +
> +	if ((fmt->color_order == SCALER_CRCB) && (fmt->num_planes == 3))
> +		swap(addr->cb, addr->cr);
> +
> +	if (V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type))
> +		scaler_dbg(ctx->scaler_dev,
> +			 "\nIN:ADDR: y= 0x%X  cb= 0x%X cr= 0x%X ret= %d\n",
> +			 addr->y, addr->cb, addr->cr, ret);
> +	else
> +		scaler_dbg(ctx->scaler_dev,
> +			 "\nOUT:ADDR: y= 0x%X  cb= 0x%X cr= 0x%X ret= %d\n",
> +			 addr->y, addr->cb, addr->cr, ret);
> +
> +	return ret;
> +}
> +
> +static void scaler_sw_reset(struct scaler_dev *scaler)
> +{
> +	scaler_hw_set_sw_reset(scaler);
> +	scaler_wait_reset(scaler);
> +
> +	scaler->coeff_type = SCALER_CSC_COEFF_NONE;
> +}
> +
> +static void scaler_check_for_illegal_status(struct device *dev,
> +					  unsigned int irq_status)
> +{
> +	int i;
> +
> +	for (i = 0; i < SCALER_NUM_ERRORS; i++)
> +		if ((1 << scaler_errors[i].irq_num) & irq_status)
> +			dev_err(dev, "ERROR:: %s\n", scaler_errors[i].name);
> +}
> +
> +static irqreturn_t scaler_irq_handler(int irq, void *priv)
> +{
> +	struct scaler_dev *scaler = priv;
> +	struct scaler_ctx *ctx;
> +	unsigned int scaler_irq;
> +	struct device *dev = &scaler->pdev->dev;
> +
> +	scaler_irq = scaler_hw_get_irq_status(scaler);
> +	scaler_dbg(scaler, "irq_status: 0x%x\n", scaler_irq);
> +	scaler_hw_clear_irq(scaler, scaler_irq);
> +
> +	if (scaler_irq & SCALER_INT_STATUS_ERROR)
> +		scaler_check_for_illegal_status(dev, scaler_irq);
> +
> +	if (!(scaler_irq & (1 << SCALER_INT_FRAME_END)))
> +		return IRQ_HANDLED;
> +
> +	spin_lock(&scaler->slock);
> +
> +	if (test_and_clear_bit(ST_M2M_PEND, &scaler->state)) {
> +
> +		scaler_hw_enable_control(scaler, false);
> +
> +		if (test_and_clear_bit(ST_M2M_SUSPENDING, &scaler->state)) {
> +			set_bit(ST_M2M_SUSPENDED, &scaler->state);
> +			wake_up(&scaler->irq_queue);
> +			goto isr_unlock;
> +		}
> +		ctx = v4l2_m2m_get_curr_priv(scaler->m2m.m2m_dev);
> +
> +		if (!ctx || !ctx->m2m_ctx)
> +			goto isr_unlock;
> +
> +		spin_unlock(&scaler->slock);
> +		scaler_m2m_job_finish(ctx, VB2_BUF_STATE_DONE);
> +
> +		/* wake_up job_abort, stop_streaming */
> +		if (ctx->state & SCALER_CTX_STOP_REQ) {
> +			ctx->state &= ~SCALER_CTX_STOP_REQ;
> +			wake_up(&scaler->irq_queue);
> +		}
> +		return IRQ_HANDLED;
> +	}
> +
> +isr_unlock:
> +	spin_unlock(&scaler->slock);
> +	return IRQ_HANDLED;
> +}
> +
> +static struct scaler_frm_limit scaler_frm_limit_5410 = {
> +	.min_w = 4,
> +	.min_h = 4,
> +	.max_w = 4096,
> +	.max_h = 4096,
> +};
> +
> +static struct scaler_frm_limit scaler_inp_frm_limit_5420 = {
> +	.min_w = 16,
> +	.min_h = 16,
> +	.max_w = 8192,
> +	.max_h = 8192,
> +};
> +
> +static struct scaler_frm_limit scaler_out_frm_limit_5420 = {
> +	.min_w = 4,
> +	.min_h = 4,
> +	.max_w = 8192,
> +	.max_h = 8192,
> +};
> +
> +static struct scaler_pix_align scaler_align_info = {
> +	.src_w_420 = 2,
> +	.src_w_422 = 2,
> +	.src_h_420 = 2,
> +	.dst_w_420 = 2,
> +	.dst_w_422 = 2,
> +	.dst_h_420 = 2,
> +};
> +
> +
> +static struct scaler_variant scaler_variant_info_5410 = {
> +	.pix_in		= &scaler_frm_limit_5410,
> +	.pix_out	= &scaler_frm_limit_5410,
> +	.pix_align	= &scaler_align_info,
> +	.scl_up_max	= 16,
> +	.scl_down_max	= 4,
> +	.in_buf_cnt	= 32,
> +	.out_buf_cnt	= 32,
> +};
> +
> +static struct scaler_variant scaler_variant_info_5420 = {
> +	.pix_in		= &scaler_inp_frm_limit_5420,
> +	.pix_out	= &scaler_out_frm_limit_5420,
> +	.pix_align	= &scaler_align_info,
> +	.scl_up_max	= 16,
> +	.scl_down_max	= 4,
> +	.in_buf_cnt	= 32,
> +	.out_buf_cnt	= 32,
> +};
> +
> +static const struct of_device_id exynos_scaler_match[] = {
> +	{
> +		.compatible = "samsung,exynos5410-scaler",
> +		.data = &scaler_variant_info_5410,
> +	},
> +	{
> +		.compatible = "samsung,exynos5420-scaler",
> +		.data = &scaler_variant_info_5420,
> +	},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, exynos_scaler_match);
> +
> +static void *scaler_get_variant_data(struct platform_device *pdev)
> +{
> +	if (pdev->dev.of_node) {
> +		const struct of_device_id *match;
> +		match = of_match_node(exynos_scaler_match, pdev->dev.of_node);
> +		if (match)
> +			return (void *)match->data;
> +	}
> +
> +	return NULL;
> +}
> +
> +static void scaler_clk_put(struct scaler_dev *scaler)
> +{
> +	if (!IS_ERR(scaler->clock))
> +		clk_unprepare(scaler->clock);
> +}
> +
> +static int scaler_clk_get(struct scaler_dev *scaler)
> +{
> +	int ret;
> +
> +	scaler_dbg(scaler, "scaler_clk_get Called\n");
> +
> +	scaler->clock = devm_clk_get(&scaler->pdev->dev,
> +					SCALER_CLOCK_GATE_NAME);
> +	if (IS_ERR(scaler->clock)) {
> +		dev_err(&scaler->pdev->dev, "failed to get clock~~~: %s\n",
> +			SCALER_CLOCK_GATE_NAME);

Perhaps remove "~~~" ?

> +		return PTR_ERR(scaler->clock);
> +	}
> +
> +	ret = clk_prepare(scaler->clock);
> +	if (ret < 0) {
> +		dev_err(&scaler->pdev->dev,
> +			"clock prepare fail for clock: %s\n",
> +			SCALER_CLOCK_GATE_NAME);
> +		scaler->clock = ERR_PTR(-EINVAL);
> +		return ret;
> +	}
> +
> +	return 0;
> +}

Thanks,
Sylwester
