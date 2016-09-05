Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:59292 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932560AbcIEKSj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Sep 2016 06:18:39 -0400
Subject: Re: [PATCH v5 3/5] media: Add Mediatek MDP Driver
To: Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        daniel.thompson@linaro.org, Rob Herring <robh+dt@kernel.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Pawel Osciak <posciak@chromium.org>
References: <1472559944-55114-1-git-send-email-minghsiu.tsai@mediatek.com>
 <1472559944-55114-4-git-send-email-minghsiu.tsai@mediatek.com>
Cc: srv_heupstream@mediatek.com,
        Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-mediatek@lists.infradead.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <cb59f743-66b9-15cd-0281-54510d7f93ca@xs4all.nl>
Date: Mon, 5 Sep 2016 12:17:14 +0200
MIME-Version: 1.0
In-Reply-To: <1472559944-55114-4-git-send-email-minghsiu.tsai@mediatek.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/30/2016 02:25 PM, Minghsiu Tsai wrote:
> Add MDP driver for MT8173
> 
> Signed-off-by: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
> ---
>  drivers/media/platform/Kconfig                |   17 +
>  drivers/media/platform/Makefile               |    2 +
>  drivers/media/platform/mtk-mdp/Makefile       |    9 +
>  drivers/media/platform/mtk-mdp/mtk_mdp_comp.c |  159 ++++
>  drivers/media/platform/mtk-mdp/mtk_mdp_comp.h |   72 ++
>  drivers/media/platform/mtk-mdp/mtk_mdp_core.c |  294 ++++++
>  drivers/media/platform/mtk-mdp/mtk_mdp_core.h |  260 +++++
>  drivers/media/platform/mtk-mdp/mtk_mdp_ipi.h  |  126 +++
>  drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c  | 1270 +++++++++++++++++++++++++
>  drivers/media/platform/mtk-mdp/mtk_mdp_m2m.h  |   22 +
>  drivers/media/platform/mtk-mdp/mtk_mdp_regs.c |  152 +++
>  drivers/media/platform/mtk-mdp/mtk_mdp_regs.h |   31 +
>  drivers/media/platform/mtk-mdp/mtk_mdp_vpu.c  |  145 +++
>  drivers/media/platform/mtk-mdp/mtk_mdp_vpu.h  |   41 +
>  14 files changed, 2600 insertions(+)
>  create mode 100644 drivers/media/platform/mtk-mdp/Makefile
>  create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_comp.c
>  create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_comp.h
>  create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_core.c
>  create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_core.h
>  create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_ipi.h
>  create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
>  create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.h
>  create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_regs.c
>  create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_regs.h
>  create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_vpu.c
>  create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_vpu.h
> 

<snip>

> +static inline bool mtk_mdp_is_target_compose(u32 target)
> +{
> +	if (target == V4L2_SEL_TGT_COMPOSE_DEFAULT
> +	    || target == V4L2_SEL_TGT_COMPOSE_BOUNDS
> +	    || target == V4L2_SEL_TGT_COMPOSE)
> +		return true;
> +	return false;
> +}
> +
> +static inline bool mtk_mdp_is_target_crop(u32 target)
> +{
> +	if (target == V4L2_SEL_TGT_CROP_DEFAULT
> +	    || target == V4L2_SEL_TGT_CROP_BOUNDS
> +	    || target == V4L2_SEL_TGT_CROP)
> +		return true;
> +	return false;
> +}
> +
> +static int mtk_mdp_m2m_g_selection(struct file *file, void *fh,
> +				       struct v4l2_selection *s)
> +{
> +	struct mtk_mdp_frame *frame;
> +	struct mtk_mdp_ctx *ctx = fh_to_ctx(fh);
> +	bool valid = false;
> +
> +	if (s->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> +		if (mtk_mdp_is_target_compose(s->target))
> +			valid = true;
> +	} else if (s->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> +		if (mtk_mdp_is_target_crop(s->target))
> +			valid = true;
> +	}
> +	if (!valid) {
> +		mtk_mdp_dbg(1, "[%d] invalid type:%d,%u", ctx->id, s->type,
> +			    s->target);
> +		return -EINVAL;
> +	}
> +
> +	frame = mtk_mdp_ctx_get_frame(ctx, s->type);
> +
> +	switch (s->target) {
> +	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
> +	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
> +	case V4L2_SEL_TGT_CROP_BOUNDS:
> +	case V4L2_SEL_TGT_CROP_DEFAULT:
> +		s->r.left = 0;
> +		s->r.top = 0;
> +		s->r.width = frame->width;
> +		s->r.height = frame->height;
> +		return 0;
> +
> +	case V4L2_SEL_TGT_COMPOSE:
> +	case V4L2_SEL_TGT_CROP:
> +		s->r.left = frame->crop.left;
> +		s->r.top = frame->crop.top;
> +		s->r.width = frame->crop.width;
> +		s->r.height = frame->crop.height;
> +		return 0;
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +static int mtk_mdp_check_scaler_ratio(struct mtk_mdp_variant *var, int src_w,
> +				      int src_h, int dst_w, int dst_h, int rot)
> +{
> +	int tmp_w, tmp_h;
> +
> +	if (rot == 90 || rot == 270) {
> +		tmp_w = dst_h;
> +		tmp_h = dst_w;
> +	} else {
> +		tmp_w = dst_w;
> +		tmp_h = dst_h;
> +	}
> +
> +	if ((src_w / tmp_w) > var->h_scale_down_max ||
> +	    (src_h / tmp_h) > var->v_scale_down_max ||
> +	    (tmp_w / src_w) > var->h_scale_up_max ||
> +	    (tmp_h / src_h) > var->v_scale_up_max)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static int mtk_mdp_m2m_s_selection(struct file *file, void *fh,
> +				   struct v4l2_selection *s)
> +{
> +	struct mtk_mdp_frame *frame;
> +	struct mtk_mdp_ctx *ctx = fh_to_ctx(fh);
> +	struct v4l2_rect new_r;
> +	struct mtk_mdp_variant *variant = ctx->mdp_dev->variant;
> +	int ret;
> +	bool valid = false;
> +
> +	if (s->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> +		if (mtk_mdp_is_target_compose(s->target))
> +			valid = true;
> +	} else if (s->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> +		if (mtk_mdp_is_target_crop(s->target))
> +			valid = true;
> +	}

These tests are wrong: you can't set the _DEFAULT and _BOUNDS targets.
Those are read-only. It's easiest to just explicitly check for _CROP or
_COMPOSE here.

I've added a check to v4l2-compliance to test for this.

> +	if (!valid) {
> +		mtk_mdp_dbg(1, "[%d] invalid type:%d,%u", ctx->id, s->type,
> +			    s->target);
> +		return -EINVAL;
> +	}
> +
> +	new_r = s->r;
> +	ret = mtk_mdp_try_crop(ctx, s->type, &new_r);
> +	if (ret)
> +		return ret;
> +
> +	if (mtk_mdp_is_target_crop(s->target))
> +		frame = &ctx->s_frame;
> +	else
> +		frame = &ctx->d_frame;
> +
> +	/* Check to see if scaling ratio is within supported range */
> +	if (mtk_mdp_ctx_state_is_set(ctx, MTK_MDP_DST_FMT | MTK_MDP_SRC_FMT)) {
> +		if (V4L2_TYPE_IS_OUTPUT(s->type)) {
> +			ret = mtk_mdp_check_scaler_ratio(variant, new_r.width,
> +				new_r.height, ctx->d_frame.crop.width,
> +				ctx->d_frame.crop.height,
> +				ctx->ctrls.rotate->val);
> +		} else {
> +			ret = mtk_mdp_check_scaler_ratio(variant,
> +				ctx->s_frame.crop.width,
> +				ctx->s_frame.crop.height, new_r.width,
> +				new_r.height, ctx->ctrls.rotate->val);
> +		}
> +
> +		if (ret) {
> +			dev_info(&ctx->mdp_dev->pdev->dev,
> +				"Out of scaler range");
> +			return -EINVAL;
> +		}
> +	}
> +
> +	s->r = new_r;
> +	frame->crop = new_r;
> +
> +	return 0;
> +}


Regards,

	Hans
