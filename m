Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:44610 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750703AbcDOOC3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Apr 2016 10:02:29 -0400
Subject: Re: [PATCH v6 5/8] [Media] vcodec: mediatek: Add Mediatek V4L2 Video
 Encoder Driver
To: Tiffany Lin <tiffany.lin@mediatek.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	daniel.thompson@linaro.org, Rob Herring <robh+dt@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>
References: <1459251130-53774-1-git-send-email-tiffany.lin@mediatek.com>
 <1459251130-53774-2-git-send-email-tiffany.lin@mediatek.com>
 <1459251130-53774-3-git-send-email-tiffany.lin@mediatek.com>
 <1459251130-53774-4-git-send-email-tiffany.lin@mediatek.com>
 <1459251130-53774-5-git-send-email-tiffany.lin@mediatek.com>
 <1459251130-53774-6-git-send-email-tiffany.lin@mediatek.com>
Cc: Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-mediatek@lists.infradead.org, PoChun.Lin@mediatek.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5710F46A.60304@xs4all.nl>
Date: Fri, 15 Apr 2016 16:02:18 +0200
MIME-Version: 1.0
In-Reply-To: <1459251130-53774-6-git-send-email-tiffany.lin@mediatek.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tiffany,

Some more comments, most are trivial but I realized that you were basing this
patch on an older kernel and not the latest media_tree master branch.

That's a bit of a killer because otherwise I am very close to merging this.

> +static int vidioc_venc_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct mtk_vcodec_ctx *ctx = ctrl_to_ctx(ctrl);
> +	struct mtk_enc_params *p = &ctx->enc_params;
> +	int ret = 0;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_MPEG_VIDEO_BITRATE:
> +		mtk_v4l2_debug(2, "V4L2_CID_MPEG_VIDEO_BITRATE val = %d",
> +			ctrl->val);
> +		p->bitrate = ctrl->val;
> +		ctx->param_change |= MTK_ENCODE_PARAM_BITRATE;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_B_FRAMES:
> +		mtk_v4l2_debug(2, "V4L2_CID_MPEG_VIDEO_B_FRAMES val = %d",
> +			ctrl->val);
> +		p->num_b_frame = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_FRAME_RC_ENABLE:
> +		mtk_v4l2_debug(2, "V4L2_CID_MPEG_VIDEO_FRAME_RC_ENABLE val = %d",
> +			ctrl->val);
> +		p->rc_frame = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_H264_MAX_QP:
> +		mtk_v4l2_debug(2, "V4L2_CID_MPEG_VIDEO_H264_MAX_QP val = %d",
> +			ctrl->val);
> +		p->h264_max_qp = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_HEADER_MODE:
> +		mtk_v4l2_debug(2, "V4L2_CID_MPEG_VIDEO_HEADER_MODE val = %d",
> +			ctrl->val);
> +		p->seq_hdr_mode = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_MB_RC_ENABLE:
> +		mtk_v4l2_debug(2, "V4L2_CID_MPEG_VIDEO_MB_RC_ENABLE val = %d",
> +			ctrl->val);
> +		p->rc_mb = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_H264_PROFILE:
> +		mtk_v4l2_debug(2, "V4L2_CID_MPEG_VIDEO_H264_PROFILE val = %d",
> +			ctrl->val);
> +		p->h264_profile = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_H264_LEVEL:
> +		mtk_v4l2_debug(2, "V4L2_CID_MPEG_VIDEO_H264_LEVEL val = %d",
> +			ctrl->val);
> +		p->h264_level = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_H264_I_PERIOD:
> +		mtk_v4l2_debug(2, "V4L2_CID_MPEG_VIDEO_H264_I_PERIOD val = %d",
> +			       ctrl->val);
> +		p->intra_period = ctrl->val;
> +		ctx->param_change |= MTK_ENCODE_PARAM_INTRA_PERIOD;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
> +		mtk_v4l2_debug(2, "V4L2_CID_MPEG_VIDEO_GOP_SIZE val = %d",
> +			       ctrl->val);
> +		p->gop_size = ctrl->val;
> +		ctx->param_change |= MTK_ENCODE_PARAM_GOP_SIZE;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME:
> +		mtk_v4l2_debug(2, "V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME");
> +		p->force_intra = 1;
> +		ctx->param_change |= MTK_ENCODE_PARAM_FORCE_INTRA;
> +		break;
> +	default:
> +		mtk_v4l2_err("Unspport CID %d", ctrl->id);

Unspport -> Unsupported

But either remove this or make it a debug message.

I would just remove it.

> +		ret = -EINVAL;
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
> +static const struct v4l2_ctrl_ops mtk_vcodec_enc_ctrl_ops = {
> +	.s_ctrl = vidioc_venc_s_ctrl,
> +};
> +
> +static int vidioc_enum_fmt(struct v4l2_fmtdesc *f, bool output_queue)
> +{
> +	struct mtk_video_fmt *fmt;
> +	int i, j = 0;
> +
> +	for (i = 0; i < NUM_FORMATS; ++i) {
> +		if (output_queue && mtk_video_formats[i].type != MTK_FMT_FRAME)
> +			continue;
> +		if (!output_queue && mtk_video_formats[i].type != MTK_FMT_ENC)
> +			continue;
> +
> +		if (j == f->index) {
> +			fmt = &mtk_video_formats[i];
> +			f->pixelformat = fmt->fourcc;
> +			memset(f->reserved, 0, sizeof(f->reserved));
> +			return 0;
> +		}
> +		++j;
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +static int vidioc_enum_framesizes(struct file *file, void *fh,
> +				  struct v4l2_frmsizeenum *fsize)
> +{
> +	int i = 0;
> +
> +	if (fsize->index != 0)
> +		return -EINVAL;
> +
> +	for (i = 0; i < NUM_SUPPORTED_FRAMESIZE; ++i) {
> +		if (fsize->pixel_format != mtk_venc_framesizes[i].fourcc)
> +			continue;
> +
> +		fsize->type = V4L2_FRMSIZE_TYPE_STEPWISE;
> +		fsize->stepwise = mtk_venc_framesizes[i].stepwise;
> +		return 0;
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +static int vidioc_enum_fmt_vid_cap_mplane(struct file *file, void *pirv,
> +					  struct v4l2_fmtdesc *f)
> +{
> +	return vidioc_enum_fmt(f, false);
> +}
> +
> +static int vidioc_enum_fmt_vid_out_mplane(struct file *file, void *prov,
> +					  struct v4l2_fmtdesc *f)
> +{
> +	return vidioc_enum_fmt(f, true);
> +}
> +
> +static int vidioc_venc_querycap(struct file *file, void *priv,
> +				struct v4l2_capability *cap)
> +{
> +	strlcpy(cap->driver, MTK_VCODEC_ENC_NAME, sizeof(cap->driver));
> +	strlcpy(cap->bus_info, MTK_PLATFORM_STR, sizeof(cap->bus_info));
> +	strlcpy(cap->card, MTK_PLATFORM_STR, sizeof(cap->card));
> +
> +	cap->device_caps  = V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING;
> +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;

This week a commit was added that adds a device_caps field to struct video_device.
Please set the device caps there and the v4l2 core will take care of setting
device_caps and capabilities here. So these two lines can then be removed.

The advantage going forward is that the v4l2 core now knows the capabilities
of each video device.

> +
> +	return 0;
> +}
> +
> +static int vidioc_venc_s_parm(struct file *file, void *priv,
> +			      struct v4l2_streamparm *a)
> +{
> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> +
> +	if (a->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> +		return -EINVAL;
> +
> +	ctx->enc_params.framerate_num =
> +			a->parm.output.timeperframe.denominator;
> +	ctx->enc_params.framerate_denom =
> +			a->parm.output.timeperframe.numerator;
> +	ctx->param_change |= MTK_ENCODE_PARAM_FRAMERATE;
> +
> +	return 0;
> +}
> +
> +static int vidioc_venc_g_parm(struct file *file, void *priv,
> +			      struct v4l2_streamparm *a)
> +{
> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> +
> +	if (a->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> +		return -EINVAL;
> +
> +	a->parm.output.timeperframe.denominator =
> +			ctx->enc_params.framerate_num;
> +	a->parm.output.timeperframe.numerator =
> +			ctx->enc_params.framerate_denom;
> +
> +	return 0;
> +}
> +
> +static struct mtk_q_data *mtk_venc_get_q_data(struct mtk_vcodec_ctx *ctx,
> +					      enum v4l2_buf_type type)
> +{
> +	if (V4L2_TYPE_IS_OUTPUT(type))
> +		return &ctx->q_data[MTK_Q_DATA_SRC];
> +
> +	return &ctx->q_data[MTK_Q_DATA_DST];
> +}
> +
> +static struct mtk_video_fmt *mtk_venc_find_format(struct v4l2_format *f)
> +{
> +	struct mtk_video_fmt *fmt;
> +	unsigned int k;
> +
> +	for (k = 0; k < NUM_FORMATS; k++) {
> +		fmt = &mtk_video_formats[k];
> +		if (fmt->fourcc == f->fmt.pix.pixelformat)
> +			return fmt;
> +	}
> +
> +	return NULL;
> +}
> +
> +/* V4L2 specification suggests the driver corrects the format struct if any of
> +  * the dimensions is unsupported
> +  */
> +static int vidioc_try_fmt(struct v4l2_format *f, struct mtk_video_fmt *fmt)
> +{
> +	struct v4l2_pix_format_mplane *pix_fmt_mp = &f->fmt.pix_mp;
> +
> +	pix_fmt_mp->field = V4L2_FIELD_NONE;
> +
> +	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> +		pix_fmt_mp->num_planes = 1;
> +		pix_fmt_mp->plane_fmt[0].bytesperline = 0;
> +		memset(&(pix_fmt_mp->plane_fmt[0].reserved[0]), 0x0,
> +		       sizeof(pix_fmt_mp->plane_fmt[0].reserved));

Drop the memset here and instead...

> +	} else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> +		int i;
> +		int tmp_w, tmp_h;
> +
> +		pix_fmt_mp->height = clamp(pix_fmt_mp->height,
> +								MTK_VENC_MIN_H,
> +								MTK_VENC_MAX_H);
> +		pix_fmt_mp->width = clamp(pix_fmt_mp->width,
> +								MTK_VENC_MIN_W,
> +								MTK_VENC_MAX_W);
> +
> +		/* find next closer width align 16, heign align 32, size align
> +		  * 64 rectangle
> +		  */
> +		tmp_w = pix_fmt_mp->width;
> +		tmp_h = pix_fmt_mp->height;
> +		v4l_bound_align_image(&pix_fmt_mp->width,
> +							MTK_VENC_MIN_W,
> +							MTK_VENC_MAX_W, 4,
> +							&pix_fmt_mp->height,
> +							MTK_VENC_MIN_H,
> +							MTK_VENC_MAX_H, 5, 6);
> +
> +		if (pix_fmt_mp->width < tmp_w &&
> +			(pix_fmt_mp->width + 16) <= MTK_VENC_MAX_W)
> +			pix_fmt_mp->width += 16;
> +		if (pix_fmt_mp->height < tmp_h &&
> +			(pix_fmt_mp->height + 32) <= MTK_VENC_MAX_H)
> +			pix_fmt_mp->height += 32;
> +
> +		mtk_v4l2_debug(0,
> +			"before resize width=%d, height=%d, after resize width=%d, height=%d, sizeimage=%d",
> +			tmp_w, tmp_h, pix_fmt_mp->width,
> +			pix_fmt_mp->height,
> +			pix_fmt_mp->width * pix_fmt_mp->height);
> +
> +		pix_fmt_mp->num_planes = fmt->num_planes;
> +		pix_fmt_mp->plane_fmt[0].sizeimage =
> +					pix_fmt_mp->width * pix_fmt_mp->height;
> +		pix_fmt_mp->plane_fmt[0].bytesperline = pix_fmt_mp->width;
> +
> +		if (pix_fmt_mp->num_planes == 2) {
> +			pix_fmt_mp->plane_fmt[1].sizeimage =
> +					pix_fmt_mp->width *
> +					pix_fmt_mp->height / 2;
> +			pix_fmt_mp->plane_fmt[2].sizeimage = 0;
> +			pix_fmt_mp->plane_fmt[1].bytesperline =
> +							pix_fmt_mp->width;
> +			pix_fmt_mp->plane_fmt[2].bytesperline = 0;
> +		} else if (pix_fmt_mp->num_planes == 3) {
> +			pix_fmt_mp->plane_fmt[1].sizeimage =
> +			pix_fmt_mp->plane_fmt[2].sizeimage =
> +				pix_fmt_mp->width * pix_fmt_mp->height / 4;
> +			pix_fmt_mp->plane_fmt[1].bytesperline =
> +				pix_fmt_mp->plane_fmt[2].bytesperline =
> +				pix_fmt_mp->width / 2;
> +		}
> +
> +		for (i = 0; i < pix_fmt_mp->num_planes; i++)
> +			memset(&(pix_fmt_mp->plane_fmt[i].reserved[0]), 0x0,
> +			       sizeof(pix_fmt_mp->plane_fmt[0].reserved));

... move this out of the 'else' since this is common for both capture and output.

> +
> +	}
> +
> +	memset(&pix_fmt_mp->flags, 0, sizeof(*pix_fmt_mp) -
> +			offsetof(struct v4l2_pix_format_mplane, flags));

This is a bit dubious. I would just set flags and 'reserved' to 0. You want
to handle ycbcr_enc, quantization and xfer_func just like you handle the
colorspace field.

> +
> +	return 0;
> +}
> +
> +static void mtk_venc_set_param(struct mtk_vcodec_ctx *ctx,
> +					struct venc_enc_prm *param)
> +{
> +	struct mtk_q_data *q_data_src = &ctx->q_data[MTK_Q_DATA_SRC];
> +	struct mtk_enc_params *enc_params = &ctx->enc_params;
> +
> +
> +	switch (q_data_src->fmt->fourcc) {
> +	case V4L2_PIX_FMT_YUV420:
> +	case V4L2_PIX_FMT_YUV420M:
> +		param->input_fourcc = VENC_YUV_FORMAT_420;
> +		break;
> +	case V4L2_PIX_FMT_YVU420:
> +	case V4L2_PIX_FMT_YVU420M:
> +		param->input_fourcc = VENC_YUV_FORMAT_YV12;
> +		break;
> +	case V4L2_PIX_FMT_NV12:
> +	case V4L2_PIX_FMT_NV12M:
> +		param->input_fourcc = VENC_YUV_FORMAT_NV12;
> +		break;
> +	case V4L2_PIX_FMT_NV21:
> +	case V4L2_PIX_FMT_NV21M:
> +		param->input_fourcc = VENC_YUV_FORMAT_NV21;
> +		break;
> +	default:
> +		mtk_v4l2_err("Unsupport fourcc =%d", q_data_src->fmt->fourcc);
> +		break;
> +	}
> +	param->h264_profile = enc_params->h264_profile;
> +	param->h264_level = enc_params->h264_level;
> +
> +	/* Config visible resolution */
> +	param->width = q_data_src->visible_width;
> +	param->height = q_data_src->visible_height;
> +	/* Config coded resolution */
> +	param->buf_width = q_data_src->coded_width;
> +	param->buf_height = q_data_src->coded_height;
> +	param->frm_rate = enc_params->framerate_num /
> +					enc_params->framerate_denom;
> +	param->intra_period = enc_params->intra_period;
> +	param->gop_size = enc_params->gop_size;
> +	param->bitrate = enc_params->bitrate;
> +
> +	mtk_v4l2_debug(0,
> +				"fmt 0x%x, P/L %d/%d, w/h %d/%d, buf %d/%d, fps/bps %d/%d, gop %d, i_period %d",
> +				param->input_fourcc, param->h264_profile,
> +				param->h264_level, param->width, param->height,
> +				param->buf_width, param->buf_height,
> +				param->frm_rate, param->bitrate,
> +				param->gop_size, param->intra_period);

Ugly indentation. Looks like there is a tab too many.

> +}
> +
> +static int vidioc_venc_s_fmt_cap(struct file *file, void *priv,
> +			     struct v4l2_format *f)
> +{
> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> +	struct vb2_queue *vq;
> +	struct mtk_q_data *q_data;
> +	int i, ret;
> +	struct mtk_video_fmt *fmt;
> +
> +	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
> +	if (!vq) {
> +		mtk_v4l2_err("fail to get vq");
> +		return -EINVAL;
> +	}
> +
> +	if (vb2_is_busy(vq)) {
> +		mtk_v4l2_err("queue busy");
> +		return -EBUSY;
> +	}
> +
> +	q_data = mtk_venc_get_q_data(ctx, f->type);
> +	if (!q_data) {
> +		mtk_v4l2_err("fail to get q data");
> +		return -EINVAL;
> +	}
> +
> +	fmt = mtk_venc_find_format(f);
> +	if (!fmt) {
> +		f->fmt.pix.pixelformat = mtk_video_formats[CAP_FMT_IDX].fourcc;
> +		fmt = mtk_venc_find_format(f);
> +	}
> +
> +	q_data->fmt = fmt;
> +	ret = vidioc_try_fmt(f, q_data->fmt);
> +	if (ret)
> +		return ret;
> +
> +	q_data->coded_width = f->fmt.pix_mp.width;
> +	q_data->coded_height = f->fmt.pix_mp.height;
> +	q_data->field = f->fmt.pix_mp.field;
> +
> +	for (i = 0; i < f->fmt.pix_mp.num_planes; i++) {
> +		struct v4l2_plane_pix_format	*plane_fmt;
> +
> +		plane_fmt = &f->fmt.pix_mp.plane_fmt[i];
> +		q_data->bytesperline[i]	= plane_fmt->bytesperline;
> +		q_data->sizeimage[i]	= plane_fmt->sizeimage;
> +	}
> +
> +	if (ctx->state == MTK_STATE_FREE) {
> +		ret = venc_if_init(ctx, q_data->fmt->fourcc);
> +		if (ret) {
> +			mtk_v4l2_err("venc_if_init failed=%d, codec type=%x",
> +						ret, q_data->fmt->fourcc);
> +			return -EBUSY;
> +		}
> +
> +		ctx->state = MTK_STATE_INIT;
> +	}
> +
> +	return 0;
> +
> +}
> +
> +static int vidioc_venc_s_fmt_out(struct file *file, void *priv,
> +			     struct v4l2_format *f)
> +{
> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> +	struct vb2_queue *vq;
> +	struct mtk_q_data *q_data;
> +	int ret, i;
> +	struct mtk_video_fmt *fmt;
> +	unsigned int pitch_w_div16;
> +	struct v4l2_pix_format_mplane *pix_fmt_mp = &f->fmt.pix_mp;
> +
> +	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
> +	if (!vq) {
> +		mtk_v4l2_err("fail to get vq");
> +		return -EINVAL;
> +	}
> +
> +	if (vb2_is_busy(vq)) {
> +		mtk_v4l2_err("queue busy");
> +		return -EBUSY;
> +	}
> +
> +	q_data = mtk_venc_get_q_data(ctx, f->type);
> +	if (!q_data) {
> +		mtk_v4l2_err("fail to get q data");
> +		return -EINVAL;
> +	}
> +
> +	fmt = mtk_venc_find_format(f);
> +	if (!fmt) {
> +		f->fmt.pix.pixelformat = mtk_video_formats[OUT_FMT_IDX].fourcc;
> +		fmt = mtk_venc_find_format(f);
> +	}
> +
> +	pix_fmt_mp->height = clamp(pix_fmt_mp->height,
> +							MTK_VENC_MIN_H,
> +							MTK_VENC_MAX_H);
> +	pix_fmt_mp->width = clamp(pix_fmt_mp->width,
> +							MTK_VENC_MIN_W,
> +							MTK_VENC_MAX_W);
> +
> +	q_data->visible_width = f->fmt.pix_mp.width;
> +	q_data->visible_height = f->fmt.pix_mp.height;
> +	q_data->fmt = fmt;
> +	ret = vidioc_try_fmt(f, q_data->fmt);
> +	if (ret)
> +		return ret;
> +
> +	q_data->coded_width = f->fmt.pix_mp.width;
> +	q_data->coded_height = f->fmt.pix_mp.height;
> +
> +	pitch_w_div16 = DIV_ROUND_UP(q_data->visible_width, 16);
> +	if (pitch_w_div16 % 8 != 0) {
> +		/* Adjut returned width/heignt, so application could correctly

Adjut -> Adjust
heignt -> height

> +		  * allocate hw required memory
> +		  */
> +		q_data->visible_height += 32;
> +		vidioc_try_fmt(f, q_data->fmt);
> +	}
> +
> +	q_data->field = f->fmt.pix_mp.field;
> +	q_data->colorspace = f->fmt.pix_mp.colorspace;

Copy ycbcr_enc, quantization and xfer_func as well to q_data.

> +
> +	for (i = 0; i < f->fmt.pix_mp.num_planes; i++) {
> +		struct v4l2_plane_pix_format	*plane_fmt;
> +
> +		plane_fmt = &f->fmt.pix_mp.plane_fmt[i];
> +		q_data->bytesperline[i] = plane_fmt->bytesperline;
> +		q_data->sizeimage[i] = plane_fmt->sizeimage;
> +	}
> +
> +	return 0;
> +}
> +
> +static int vidioc_venc_g_fmt(struct file *file, void *priv,
> +			     struct v4l2_format *f)
> +{
> +	struct v4l2_pix_format_mplane *pix = &f->fmt.pix_mp;
> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> +	struct vb2_queue *vq;
> +	struct mtk_q_data *q_data;
> +	int i;
> +
> +	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
> +	if (!vq)
> +		return -EINVAL;
> +
> +	q_data = mtk_venc_get_q_data(ctx, f->type);
> +
> +	pix->width = q_data->coded_width;
> +	pix->height = q_data->coded_height;
> +	pix->pixelformat = q_data->fmt->fourcc;
> +	pix->field = q_data->field;
> +	pix->colorspace = q_data->colorspace;

Ditto

> +	pix->num_planes = q_data->fmt->num_planes;
> +	for (i = 0; i < pix->num_planes; i++) {
> +		pix->plane_fmt[i].bytesperline = q_data->bytesperline[i];
> +		pix->plane_fmt[i].sizeimage = q_data->sizeimage[i];
> +		memset(&(pix->plane_fmt[i].reserved[0]), 0x0,
> +		       sizeof(pix->plane_fmt[i].reserved));
> +	}
> +
> +	memset(&pix->flags, 0, sizeof(pix) -
> +			offsetof(struct v4l2_pix_format_mplane, flags));

And don't zero those fields here.

> +
> +	return 0;
> +}
> +
> +static int vidioc_try_fmt_vid_cap_mplane(struct file *file, void *priv,
> +				struct v4l2_format *f)
> +{
> +	struct mtk_video_fmt *fmt;
> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> +
> +	fmt = mtk_venc_find_format(f);
> +	if (!fmt) {
> +		f->fmt.pix.pixelformat = mtk_video_formats[CAP_FMT_IDX].fourcc;
> +		fmt = mtk_venc_find_format(f);
> +	}
> +	f->fmt.pix_mp.colorspace = ctx->q_data[MTK_Q_DATA_SRC].colorspace;

You should do the same for ycbcr_enc, quantization and xfer_func fields.

> +
> +	return vidioc_try_fmt(f, fmt);
> +}
> +
> +static int vidioc_try_fmt_vid_out_mplane(struct file *file, void *priv,
> +				struct v4l2_format *f)
> +{
> +	struct mtk_video_fmt *fmt;
> +
> +	fmt = mtk_venc_find_format(f);
> +	if (!fmt) {
> +		f->fmt.pix.pixelformat = mtk_video_formats[OUT_FMT_IDX].fourcc;
> +		fmt = mtk_venc_find_format(f);
> +	}
> +	if (!f->fmt.pix_mp.colorspace)
> +		f->fmt.pix_mp.colorspace = V4L2_COLORSPACE_REC709;
> +
> +	return vidioc_try_fmt(f, fmt);
> +}
> +
> +static int vidioc_venc_qbuf(struct file *file, void *priv,
> +			    struct v4l2_buffer *buf)
> +{
> +
> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> +
> +	if (ctx->state == MTK_STATE_ABORT) {
> +		mtk_v4l2_err("[%d] Call on QBUF after unrecoverable error",
> +					 ctx->idx);
> +		return -EIO;
> +	}
> +
> +	return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
> +}
> +
> +static int vidioc_venc_dqbuf(struct file *file, void *priv,
> +			     struct v4l2_buffer *buf)
> +{
> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> +
> +	if (ctx->state == MTK_STATE_ABORT) {
> +		mtk_v4l2_err("[%d] Call on QBUF after unrecoverable error",
> +					 ctx->idx);
> +		return -EIO;
> +	}
> +
> +	return v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
> +}
> +
> +const struct v4l2_ioctl_ops mtk_venc_ioctl_ops = {
> +	.vidioc_streamon	= v4l2_m2m_ioctl_streamon,
> +	.vidioc_streamoff	= v4l2_m2m_ioctl_streamoff,
> +
> +	.vidioc_reqbufs	= v4l2_m2m_ioctl_reqbufs,
> +	.vidioc_querybuf	= v4l2_m2m_ioctl_querybuf,
> +	.vidioc_qbuf	= vidioc_venc_qbuf,
> +	.vidioc_dqbuf	= vidioc_venc_dqbuf,
> +
> +	.vidioc_querycap	= vidioc_venc_querycap,
> +	.vidioc_enum_fmt_vid_cap_mplane = vidioc_enum_fmt_vid_cap_mplane,
> +	.vidioc_enum_fmt_vid_out_mplane = vidioc_enum_fmt_vid_out_mplane,
> +	.vidioc_enum_framesizes	= vidioc_enum_framesizes,
> +
> +	.vidioc_try_fmt_vid_cap_mplane	= vidioc_try_fmt_vid_cap_mplane,
> +	.vidioc_try_fmt_vid_out_mplane	= vidioc_try_fmt_vid_out_mplane,
> +	.vidioc_expbuf	= v4l2_m2m_ioctl_expbuf,
> +	.vidioc_subscribe_event	= v4l2_ctrl_subscribe_event,
> +	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
> +
> +	.vidioc_s_parm	= vidioc_venc_s_parm,
> +	.vidioc_g_parm	= vidioc_venc_g_parm,
> +	.vidioc_s_fmt_vid_cap_mplane	= vidioc_venc_s_fmt_cap,
> +	.vidioc_s_fmt_vid_out_mplane	= vidioc_venc_s_fmt_out,
> +
> +	.vidioc_g_fmt_vid_cap_mplane	= vidioc_venc_g_fmt,
> +	.vidioc_g_fmt_vid_out_mplane	= vidioc_venc_g_fmt,
> +
> +	.vidioc_create_bufs   = v4l2_m2m_ioctl_create_bufs,
> +	.vidioc_prepare_buf   = v4l2_m2m_ioctl_prepare_buf,
> +};
> +
> +static int vb2ops_venc_queue_setup(struct vb2_queue *vq,
> +				   const void *parg,
> +				   unsigned int *nbuffers,
> +				   unsigned int *nplanes,
> +				   unsigned int sizes[], void *alloc_ctxs[])

This is against an old kernel! const void *parg has been removed.

Read the queue_setup documentation in videobuf2-core.h for how this is done today.

Please rebase against the master branch of git://linuxtv.org/media_tree.git.

> +{
> +	struct mtk_vcodec_ctx *ctx = vb2_get_drv_priv(vq);
> +	struct mtk_q_data *q_data;
> +	unsigned int i;
> +	struct v4l2_format *fmt = (struct v4l2_format *)parg;
> +
> +	q_data = mtk_venc_get_q_data(ctx, vq->type);
> +
> +	if (q_data == NULL)
> +		return -EINVAL;
> +
> +	if (fmt) {
> +		struct mtk_video_fmt *mtkfmt;
> +
> +		/* When called from VIDIOC_CREATE_BUFS, fmt != NULL and it
> +		  * describes the target frame format (if the format isn't valid
> +		  * the callback must return -EINVAL). In this case *num_buffers
> +		  * are being allocated additionally to q->num_buffers
> +		  */
> +		mtkfmt = mtk_venc_find_format(fmt);
> +		if (!mtkfmt) {
> +			mtk_v4l2_err("unsupported format %d",
> +				fmt->fmt.pix.pixelformat);
> +			return -EINVAL;
> +		}
> +
> +		*nplanes = mtkfmt->num_planes;
> +		if (*nplanes > VIDEO_MAX_PLANES) {
> +			mtk_v4l2_err("nplanes(%d) > VIDEO_MAX_PLANE(%d)",
> +						*nplanes,
> +						VIDEO_MAX_PLANES);
> +			return -EINVAL;
> +		}
> +
> +		for (i = 0; i < *nplanes; i++)
> +			alloc_ctxs[i] = ctx->dev->alloc_ctx;
> +
> +	} else {
> +		/* When called from VIDIOC_REQBUFS, fmt == NULL, the driver
> +		  * has to use the currently configured format and *num_buffers
> +		  * is the total number of buffers, that are being allocated
> +		  */
> +		*nplanes = q_data->fmt->num_planes;
> +		for (i = 0; i < *nplanes; i++)
> +			sizes[i] = q_data->sizeimage[i];
> +	}
> +
> +	for (i = 0; i < *nplanes; i++) {
> +		sizes[i] = q_data->sizeimage[i];
> +		alloc_ctxs[i] = ctx->dev->alloc_ctx;
> +	}
> +
> +	return 0;
> +}
> +
> +static int vb2ops_venc_buf_prepare(struct vb2_buffer *vb)
> +{
> +	struct mtk_vcodec_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
> +	struct mtk_q_data *q_data;
> +	int i;
> +
> +	q_data = mtk_venc_get_q_data(ctx, vb->vb2_queue->type);
> +
> +	for (i = 0; i < q_data->fmt->num_planes; i++) {
> +		if (vb2_plane_size(vb, i) < q_data->sizeimage[i]) {
> +			mtk_v4l2_err("data will not fit into plane %d (%lu < %d)",
> +				       i, vb2_plane_size(vb, i),
> +				       q_data->sizeimage[i]);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static void vb2ops_venc_buf_queue(struct vb2_buffer *vb)
> +{
> +	struct mtk_vcodec_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
> +	struct vb2_v4l2_buffer *vb2_v4l2 =
> +			container_of(vb, struct vb2_v4l2_buffer, vb2_buf);
> +
> +	struct mtk_video_enc_buf *mtk_buf =
> +			container_of(vb2_v4l2, struct mtk_video_enc_buf, vb);
> +
> +	if ((vb->vb2_queue->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) &&
> +	    (ctx->param_change != MTK_ENCODE_PARAM_NONE)) {
> +		mtk_v4l2_debug(1, "[%d] Before id=%d encode parameter change %x",
> +			       ctx->idx,
> +			       mtk_buf->vb.vb2_buf.index,
> +			       ctx->param_change);
> +		mtk_buf->param_change = ctx->param_change;
> +		mtk_buf->enc_params = ctx->enc_params;
> +		ctx->param_change = MTK_ENCODE_PARAM_NONE;
> +	}
> +
> +	v4l2_m2m_buf_queue(ctx->m2m_ctx, to_vb2_v4l2_buffer(vb));
> +

Spurious newline.

> +}
> +
> +static int vb2ops_venc_start_streaming(struct vb2_queue *q, unsigned int count)
> +{
> +	struct mtk_vcodec_ctx *ctx = vb2_get_drv_priv(q);
> +	struct venc_enc_prm param;
> +	int ret;
> +	int i;
> +
> +	/* Once state turn into MTK_STATE_ABORT, we need stop_streaming
> +	  * to clear it
> +	  */
> +	if ((ctx->state == MTK_STATE_ABORT) || (ctx->state == MTK_STATE_FREE))
> +		goto err_set_param;
> +
> +	/* Do the initialization when both start_streaming have been called */
> +	if (V4L2_TYPE_IS_OUTPUT(q->type)) {
> +		if (!vb2_start_streaming_called(&ctx->m2m_ctx->cap_q_ctx.q))
> +			return 0;
> +	} else {
> +		if (!vb2_start_streaming_called(&ctx->m2m_ctx->out_q_ctx.q))
> +			return 0;
> +	}
> +
> +	mtk_venc_set_param(ctx, &param);
> +	ret = venc_if_set_param(ctx, VENC_SET_PARAM_ENC, &param);
> +	if (ret) {
> +		mtk_v4l2_err("venc_if_set_param failed=%d", ret);
> +		ctx->state = MTK_STATE_ABORT;
> +		goto err_set_param;
> +	}
> +	ctx->param_change = MTK_ENCODE_PARAM_NONE;
> +
> +	if ((ctx->q_data[MTK_Q_DATA_DST].fmt->fourcc == V4L2_PIX_FMT_H264) &&
> +	    (ctx->enc_params.seq_hdr_mode !=
> +				V4L2_MPEG_VIDEO_HEADER_MODE_SEPARATE)) {
> +		ret = venc_if_set_param(ctx,
> +					VENC_SET_PARAM_PREPEND_HEADER,
> +					0);
> +		if (ret) {
> +			mtk_v4l2_err("venc_if_set_param failed=%d", ret);
> +			ctx->state = MTK_STATE_ABORT;
> +			goto err_set_param;
> +		}
> +	}
> +
> +	return 0;
> +
> +err_set_param:
> +	for (i = 0; i < q->num_buffers; ++i) {
> +		if (q->bufs[i]->state == VB2_BUF_STATE_ACTIVE) {
> +			mtk_v4l2_debug(0, "[%d] idx=%d, type=%d, %d -> VB2_BUF_STATE_QUEUED",
> +					ctx->idx, i, q->type,
> +					(int)q->bufs[i]->state);
> +			v4l2_m2m_buf_done(to_vb2_v4l2_buffer(q->bufs[i]),
> +							  VB2_BUF_STATE_QUEUED);
> +		}
> +	}
> +
> +	return ret;
> +}
> +
> +static void vb2ops_venc_stop_streaming(struct vb2_queue *q)
> +{
> +	struct mtk_vcodec_ctx *ctx = vb2_get_drv_priv(q);
> +	struct vb2_buffer *src_buf, *dst_buf;
> +	int ret;
> +
> +	mtk_v4l2_debug(2, "[%d]-> type=%d", ctx->idx, q->type);
> +
> +	if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> +		while ((dst_buf = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx))) {
> +			dst_buf->planes[0].bytesused = 0;
> +			v4l2_m2m_buf_done(to_vb2_v4l2_buffer(dst_buf),
> +						VB2_BUF_STATE_ERROR);
> +		}
> +	} else {
> +		while ((src_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx)))
> +			v4l2_m2m_buf_done(to_vb2_v4l2_buffer(src_buf),
> +						VB2_BUF_STATE_ERROR);
> +	}
> +
> +	if ((q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE &&
> +	     vb2_is_streaming(&ctx->m2m_ctx->out_q_ctx.q)) ||
> +	    (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE &&
> +	     vb2_is_streaming(&ctx->m2m_ctx->cap_q_ctx.q))) {
> +		mtk_v4l2_debug(1, "[%d]-> q type %d out=%d cap=%d",
> +			       ctx->idx, q->type,
> +			       vb2_is_streaming(&ctx->m2m_ctx->out_q_ctx.q),
> +			       vb2_is_streaming(&ctx->m2m_ctx->cap_q_ctx.q));
> +		return;
> +	}
> +
> +	/* Release the encoder if both streams are stopped. */
> +	ret = venc_if_deinit(ctx);
> +	if (ret)
> +		mtk_v4l2_err("venc_if_deinit failed=%d", ret);
> +
> +	ctx->state = MTK_STATE_FREE;
> +}
> +
> +static struct vb2_ops mtk_venc_vb2_ops = {
> +	.queue_setup	= vb2ops_venc_queue_setup,
> +	.buf_prepare	= vb2ops_venc_buf_prepare,
> +	.buf_queue	= vb2ops_venc_buf_queue,
> +	.wait_prepare	= vb2_ops_wait_prepare,
> +	.wait_finish	= vb2_ops_wait_finish,
> +	.start_streaming	= vb2ops_venc_start_streaming,
> +	.stop_streaming	= vb2ops_venc_stop_streaming,
> +};
> +
> +static int mtk_venc_encode_header(void *priv)
> +{
> +	struct mtk_vcodec_ctx *ctx = priv;
> +	int ret;
> +	struct vb2_buffer *dst_buf;
> +	struct mtk_vcodec_mem bs_buf;
> +	struct venc_done_result enc_result;
> +
> +	dst_buf = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
> +	if (!dst_buf) {
> +		mtk_v4l2_debug(1, "No dst buffer");
> +		return -EINVAL;
> +	}
> +
> +	bs_buf.va = vb2_plane_vaddr(dst_buf, 0);
> +	bs_buf.dma_addr = vb2_dma_contig_plane_dma_addr(dst_buf, 0);
> +	bs_buf.size = (size_t)dst_buf->planes[0].length;
> +
> +	mtk_v4l2_debug(1,
> +			"[%d] buf idx=%d va=0x%p dma_addr=0x%llx size=0x%lx",
> +			ctx->idx,
> +			dst_buf->index, bs_buf.va,
> +			(u64)bs_buf.dma_addr,
> +			bs_buf.size);
> +
> +	ret = venc_if_encode(ctx,
> +			VENC_START_OPT_ENCODE_SEQUENCE_HEADER,
> +			0, &bs_buf, &enc_result);
> +
> +	if (ret) {
> +		dst_buf->planes[0].bytesused = 0;
> +		ctx->state = MTK_STATE_ABORT;
> +		v4l2_m2m_buf_done(to_vb2_v4l2_buffer(dst_buf),
> +						  VB2_BUF_STATE_ERROR);
> +		mtk_v4l2_err("venc_if_encode failed=%d", ret);
> +		return -EINVAL;
> +	}
> +
> +	ctx->state = MTK_STATE_HEADER;
> +	dst_buf->planes[0].bytesused = enc_result.bs_size;
> +	v4l2_m2m_buf_done(to_vb2_v4l2_buffer(dst_buf), VB2_BUF_STATE_DONE);
> +
> +#if defined(DEBUG)
> +{
> +	int i;
> +
> +	mtk_v4l2_debug(1, "[%d] venc_if_encode header len=%d",
> +					ctx->idx,
> +					enc_result.bs_size);
> +	for (i = 0; i < enc_result.bs_size; i++) {
> +		unsigned char *p = (unsigned char *)bs_buf.va;
> +
> +		mtk_v4l2_debug(1, "[%d] buf[%d]=0x%2x", ctx->idx, i, p[i]);
> +	}
> +}
> +#endif
> +	return 0;
> +}
> +
> +static int mtk_venc_param_change(struct mtk_vcodec_ctx *ctx)
> +{
> +	struct venc_enc_prm enc_prm;
> +	struct vb2_buffer *vb = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
> +	struct vb2_v4l2_buffer *vb2_v4l2 =
> +			container_of(vb, struct vb2_v4l2_buffer, vb2_buf);
> +	struct mtk_video_enc_buf *mtk_buf =
> +			container_of(vb2_v4l2, struct mtk_video_enc_buf, vb);
> +
> +	int ret = 0;
> +
> +	memset(&enc_prm, 0, sizeof(enc_prm));
> +	if (mtk_buf->param_change == MTK_ENCODE_PARAM_NONE)
> +		return 0;
> +
> +	if (mtk_buf->param_change & MTK_ENCODE_PARAM_BITRATE) {
> +		enc_prm.bitrate = mtk_buf->enc_params.bitrate;
> +		mtk_v4l2_debug(1, "[%d] idx=%d, change param br=%d",
> +				ctx->idx,
> +				mtk_buf->vb.vb2_buf.index,
> +				enc_prm.bitrate);
> +		ret |= venc_if_set_param(ctx,
> +					 VENC_SET_PARAM_ADJUST_BITRATE,
> +					 &enc_prm);
> +	}
> +	if (!ret && mtk_buf->param_change & MTK_ENCODE_PARAM_FRAMERATE) {
> +		enc_prm.frm_rate = mtk_buf->enc_params.framerate_num /
> +				   mtk_buf->enc_params.framerate_denom;
> +		mtk_v4l2_debug(1, "[%d] idx=%d, change param fr=%d",
> +			       ctx->idx,
> +			       mtk_buf->vb.vb2_buf.index,
> +			       enc_prm.frm_rate);
> +		ret |= venc_if_set_param(ctx,
> +					 VENC_SET_PARAM_ADJUST_FRAMERATE,
> +					 &enc_prm);
> +	}
> +	if (!ret && mtk_buf->param_change & MTK_ENCODE_PARAM_GOP_SIZE) {
> +		enc_prm.gop_size = mtk_buf->enc_params.gop_size;
> +		mtk_v4l2_debug(1, "change param intra period=%d",
> +			       enc_prm.gop_size);
> +		ret |= venc_if_set_param(ctx,
> +					 VENC_SET_PARAM_GOP_SIZE,
> +					 &enc_prm);
> +	}
> +	if (!ret && mtk_buf->param_change & MTK_ENCODE_PARAM_FORCE_INTRA) {
> +		mtk_v4l2_debug(1, "[%d] idx=%d, change param force I=%d",
> +				ctx->idx,
> +				mtk_buf->vb.vb2_buf.index,
> +				mtk_buf->enc_params.force_intra);
> +		if (mtk_buf->enc_params.force_intra)
> +			ret |= venc_if_set_param(ctx,
> +						 VENC_SET_PARAM_FORCE_INTRA,
> +						 0);
> +	}
> +
> +	mtk_buf->param_change = MTK_ENCODE_PARAM_NONE;
> +
> +	if (ret) {
> +		ctx->state = MTK_STATE_ABORT;
> +		mtk_v4l2_err("venc_if_set_param %d failed=%d",
> +						mtk_buf->param_change, ret);
> +		return -1;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * v4l2_m2m_streamoff() holds dev_mutex and waits mtk_venc_worker()
> + * to call v4l2_m2m_job_finish().
> + * If mtk_venc_worker() tries to acquire dev_mutex, it will deadlock.
> + * So this function must not try to acquire dev->dev_mutex.
> + * This means v4l2 ioctls and mtk_venc_worker() can run at the same time.
> + * mtk_venc_worker() should be carefully implemented to avoid bugs.
> + */
> +static void mtk_venc_worker(struct work_struct *work)
> +{
> +	struct mtk_vcodec_ctx *ctx = container_of(work, struct mtk_vcodec_ctx,
> +				    encode_work);
> +	struct vb2_buffer *src_buf, *dst_buf;
> +	struct venc_frm_buf frm_buf;
> +	struct mtk_vcodec_mem bs_buf;
> +	struct venc_done_result enc_result;
> +	int ret, i;
> +	struct vb2_v4l2_buffer *vb2_v4l2;
> +
> +	/* check dst_buf, dst_buf may be removed in device_run
> +	  * to stored encdoe header so we need check dst_buf and
> +	  * call job_finish here to prevent recursion
> +	  */
> +	dst_buf = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
> +	if (!dst_buf) {
> +		v4l2_m2m_job_finish(ctx->dev->m2m_dev_enc, ctx->m2m_ctx);
> +		return;
> +	}
> +
> +	src_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
> +	memset(&frm_buf, 0, sizeof(frm_buf));
> +	for (i = 0; i < src_buf->num_planes ; i++) {
> +		frm_buf.fb_addr[i].va = vb2_plane_vaddr(src_buf, i);
> +		frm_buf.fb_addr[i].dma_addr =
> +				vb2_dma_contig_plane_dma_addr(src_buf, i);
> +		frm_buf.fb_addr[i].size =
> +				(size_t)src_buf->planes[i].length;
> +	}
> +	bs_buf.va = vb2_plane_vaddr(dst_buf, 0);
> +	bs_buf.dma_addr = vb2_dma_contig_plane_dma_addr(dst_buf, 0);
> +	bs_buf.size = (size_t)dst_buf->planes[0].length;
> +
> +	mtk_v4l2_debug(2,
> +			"Framebuf VA=%p PA=%llx Size=0x%lx;VA=%p PA=0x%llx Size=0x%lx;VA=%p PA=0x%llx Size=0x%lx",
> +			frm_buf.fb_addr[0].va,
> +			(u64)frm_buf.fb_addr[0].dma_addr,
> +			frm_buf.fb_addr[0].size,
> +			frm_buf.fb_addr[1].va,
> +			(u64)frm_buf.fb_addr[1].dma_addr,
> +			frm_buf.fb_addr[1].size,
> +			frm_buf.fb_addr[2].va,
> +			(u64)frm_buf.fb_addr[2].dma_addr,
> +			frm_buf.fb_addr[2].size);
> +
> +	ret = venc_if_encode(ctx, VENC_START_OPT_ENCODE_FRAME,
> +			     &frm_buf, &bs_buf, &enc_result);
> +
> +	vb2_v4l2 = container_of(dst_buf, struct vb2_v4l2_buffer, vb2_buf);
> +	if (enc_result.is_key_frm)
> +		vb2_v4l2->flags |= V4L2_BUF_FLAG_KEYFRAME;
> +
> +	if (ret) {
> +		v4l2_m2m_buf_done(to_vb2_v4l2_buffer(src_buf),
> +						  VB2_BUF_STATE_ERROR);
> +		dst_buf->planes[0].bytesused = 0;
> +		v4l2_m2m_buf_done(to_vb2_v4l2_buffer(dst_buf),
> +						  VB2_BUF_STATE_ERROR);
> +		mtk_v4l2_err("venc_if_encode failed=%d", ret);
> +	} else {
> +		v4l2_m2m_buf_done(to_vb2_v4l2_buffer(src_buf),
> +						  VB2_BUF_STATE_DONE);
> +		dst_buf->planes[0].bytesused = enc_result.bs_size;
> +		v4l2_m2m_buf_done(to_vb2_v4l2_buffer(dst_buf),
> +						  VB2_BUF_STATE_DONE);
> +		mtk_v4l2_debug(2, "venc_if_encode bs size=%d",
> +				 enc_result.bs_size);
> +	}
> +
> +	v4l2_m2m_job_finish(ctx->dev->m2m_dev_enc, ctx->m2m_ctx);
> +
> +	mtk_v4l2_debug(1, "<=== src_buf[%d] dst_buf[%d] venc_if_encode ret=%d Size=%u===>",
> +			src_buf->index, dst_buf->index, ret,
> +			enc_result.bs_size);
> +}
> +
> +static void m2mops_venc_device_run(void *priv)
> +{
> +	struct mtk_vcodec_ctx *ctx = priv;
> +
> +	if ((ctx->q_data[MTK_Q_DATA_DST].fmt->fourcc == V4L2_PIX_FMT_H264) &&
> +	    (ctx->state != MTK_STATE_HEADER)) {
> +		/* encode h264 sps/pps header */
> +		mtk_venc_encode_header(ctx);
> +		queue_work(ctx->dev->encode_workqueue, &ctx->encode_work);
> +		return;
> +	}
> +
> +	mtk_venc_param_change(ctx);
> +	queue_work(ctx->dev->encode_workqueue, &ctx->encode_work);
> +}
> +
> +static int m2mops_venc_job_ready(void *m2m_priv)
> +{
> +	struct mtk_vcodec_ctx *ctx = m2m_priv;
> +
> +	if (ctx->state == MTK_STATE_ABORT || ctx->state == MTK_STATE_FREE) {
> +		mtk_v4l2_debug(3, "[%d]Not ready: state=0x%x.",
> +			       ctx->idx, ctx->state);
> +		return 0;
> +	}
> +
> +	return 1;
> +}
> +
> +static void m2mops_venc_job_abort(void *priv)
> +{
> +	struct mtk_vcodec_ctx *ctx = priv;
> +
> +	ctx->state = MTK_STATE_ABORT;
> +}
> +
> +static void m2mops_venc_lock(void *m2m_priv)
> +{
> +	struct mtk_vcodec_ctx *ctx = m2m_priv;
> +
> +	mutex_lock(&ctx->dev->dev_mutex);
> +}
> +
> +static void m2mops_venc_unlock(void *m2m_priv)
> +{
> +	struct mtk_vcodec_ctx *ctx = m2m_priv;
> +
> +	mutex_unlock(&ctx->dev->dev_mutex);
> +}
> +
> +const struct v4l2_m2m_ops mtk_venc_m2m_ops = {
> +	.device_run			= m2mops_venc_device_run,
> +	.job_ready			= m2mops_venc_job_ready,
> +	.job_abort			= m2mops_venc_job_abort,
> +	.lock				= m2mops_venc_lock,
> +	.unlock				= m2mops_venc_unlock,
> +};
> +
> +void mtk_vcodec_enc_ctx_params_setup(struct mtk_vcodec_ctx *ctx)
> +{
> +	struct mtk_q_data *q_data;
> +
> +	ctx->m2m_ctx->q_lock = &ctx->dev->dev_mutex;
> +	ctx->fh.m2m_ctx = ctx->m2m_ctx;
> +	ctx->fh.ctrl_handler = &ctx->ctrl_hdl;
> +	INIT_WORK(&ctx->encode_work, mtk_venc_worker);
> +
> +	q_data = &ctx->q_data[MTK_Q_DATA_SRC];
> +	memset(q_data, 0, sizeof(struct mtk_q_data));
> +	q_data->visible_width = DFT_CFG_WIDTH;
> +	q_data->visible_height = DFT_CFG_HEIGHT;
> +	q_data->coded_width = DFT_CFG_WIDTH;
> +	q_data->coded_height = DFT_CFG_HEIGHT;
> +	q_data->colorspace = V4L2_COLORSPACE_REC709;
> +	q_data->field = V4L2_FIELD_NONE;
> +
> +	q_data->fmt = &mtk_video_formats[OUT_FMT_IDX];
> +
> +	v4l_bound_align_image(&q_data->coded_width,
> +						MTK_VENC_MIN_W,
> +						MTK_VENC_MAX_W, 4,
> +						&q_data->coded_height,
> +						MTK_VENC_MIN_H,
> +						MTK_VENC_MAX_H, 5, 6);
> +
> +	if (q_data->coded_width < DFT_CFG_WIDTH &&
> +		(q_data->coded_width + 16) <= MTK_VENC_MAX_W)
> +		q_data->coded_width += 16;
> +	if (q_data->coded_height < DFT_CFG_HEIGHT &&
> +		(q_data->coded_height + 32) <= MTK_VENC_MAX_H)
> +		q_data->coded_height += 32;
> +
> +	q_data->sizeimage[0] = q_data->coded_width * q_data->coded_height;
> +	q_data->bytesperline[0] = q_data->coded_width;
> +	q_data->sizeimage[1] = q_data->sizeimage[0] / 2;
> +	q_data->bytesperline[1] = q_data->coded_width;
> +
> +	q_data = &ctx->q_data[MTK_Q_DATA_DST];
> +	memset(q_data, 0, sizeof(struct mtk_q_data));
> +	q_data->coded_width = DFT_CFG_WIDTH;
> +	q_data->coded_height = DFT_CFG_HEIGHT;
> +	q_data->fmt = &mtk_video_formats[CAP_FMT_IDX];
> +	q_data->colorspace = V4L2_COLORSPACE_REC709;
> +	q_data->field = V4L2_FIELD_NONE;
> +	ctx->q_data[MTK_Q_DATA_DST].sizeimage[0] =
> +		DFT_CFG_WIDTH * DFT_CFG_HEIGHT;
> +	ctx->q_data[MTK_Q_DATA_DST].bytesperline[0] = 0;
> +
> +}
> +
> +int mtk_vcodec_enc_ctrls_setup(struct mtk_vcodec_ctx *ctx)
> +{
> +	const struct v4l2_ctrl_ops *ops = &mtk_vcodec_enc_ctrl_ops;
> +	struct v4l2_ctrl_handler *handler = &ctx->ctrl_hdl;
> +
> +	v4l2_ctrl_handler_init(handler, MTK_MAX_CTRLS_HINT);
> +
> +	v4l2_ctrl_new_std(handler, ops, V4L2_CID_MPEG_VIDEO_BITRATE,
> +					1, 4000000, 1, 4000000);
> +	v4l2_ctrl_new_std(handler, ops, V4L2_CID_MPEG_VIDEO_B_FRAMES,
> +					0, 2, 1, 0);
> +	v4l2_ctrl_new_std(handler, ops, V4L2_CID_MPEG_VIDEO_FRAME_RC_ENABLE,
> +					0, 1, 1, 1);
> +	v4l2_ctrl_new_std(handler, ops, V4L2_CID_MPEG_VIDEO_H264_MAX_QP,
> +					0, 51, 1, 51);
> +	v4l2_ctrl_new_std(handler, ops, V4L2_CID_MPEG_VIDEO_H264_I_PERIOD,
> +					0, 65535, 1, 0);
> +	v4l2_ctrl_new_std(handler, ops, V4L2_CID_MPEG_VIDEO_GOP_SIZE,
> +					0, 65535, 1, 0);
> +	v4l2_ctrl_new_std(handler, ops, V4L2_CID_MPEG_VIDEO_MB_RC_ENABLE,
> +					0, 1, 1, 0);
> +	v4l2_ctrl_new_std(handler, ops, V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME,
> +					0, 0, 0, 0);
> +	v4l2_ctrl_new_std_menu(handler, ops,
> +			V4L2_CID_MPEG_VIDEO_HEADER_MODE,
> +			V4L2_MPEG_VIDEO_HEADER_MODE_JOINED_WITH_1ST_FRAME,
> +			0, V4L2_MPEG_VIDEO_HEADER_MODE_SEPARATE);
> +	v4l2_ctrl_new_std_menu(handler, ops, V4L2_CID_MPEG_VIDEO_H264_PROFILE,
> +					V4L2_MPEG_VIDEO_H264_PROFILE_HIGH,
> +					0, V4L2_MPEG_VIDEO_H264_PROFILE_MAIN);
> +	v4l2_ctrl_new_std_menu(handler, ops, V4L2_CID_MPEG_VIDEO_H264_LEVEL,
> +					V4L2_MPEG_VIDEO_H264_LEVEL_4_2,
> +					0, V4L2_MPEG_VIDEO_H264_LEVEL_4_0);
> +	if (handler->error) {
> +		mtk_v4l2_err("Init control handler fail %d",
> +				handler->error);
> +		return handler->error;
> +	}
> +
> +	v4l2_ctrl_handler_setup(&ctx->ctrl_hdl);
> +
> +	return 0;
> +}
> +
> +int mtk_vcodec_enc_queue_init(void *priv, struct vb2_queue *src_vq,
> +			   struct vb2_queue *dst_vq)
> +{
> +	struct mtk_vcodec_ctx *ctx = priv;
> +	int ret;
> +
> +	/* Note: VB2_USERPTR works with dma-contig because mt8173
> +	 * support iommu
> +	 * https://patchwork.kernel.org/patch/8335461/
> +	 * https://patchwork.kernel.org/patch/7596181/
> +	 */
> +	src_vq->type		= V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> +	src_vq->io_modes	= VB2_DMABUF | VB2_MMAP | VB2_USERPTR;
> +	src_vq->drv_priv	= ctx;
> +	src_vq->buf_struct_size = sizeof(struct mtk_video_enc_buf);
> +	src_vq->ops		= &mtk_venc_vb2_ops;
> +	src_vq->mem_ops		= &vb2_dma_contig_memops;
> +	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	src_vq->lock = &ctx->dev->dev_mutex;
> +
> +	ret = vb2_queue_init(src_vq);
> +	if (ret)
> +		return ret;
> +
> +	dst_vq->type		= V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> +	dst_vq->io_modes	= VB2_DMABUF | VB2_MMAP | VB2_USERPTR;
> +	dst_vq->drv_priv	= ctx;
> +	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
> +	dst_vq->ops		= &mtk_venc_vb2_ops;
> +	dst_vq->mem_ops		= &vb2_dma_contig_memops;
> +	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	dst_vq->lock = &ctx->dev->dev_mutex;
> +
> +	return vb2_queue_init(dst_vq);
> +}
> +
> +int mtk_venc_unlock(struct mtk_vcodec_ctx *ctx)
> +{
> +	struct mtk_vcodec_dev *dev = ctx->dev;
> +
> +	mutex_unlock(&dev->enc_mutex);
> +	return 0;
> +}
> +
> +int mtk_venc_lock(struct mtk_vcodec_ctx *ctx)
> +{
> +	struct mtk_vcodec_dev *dev = ctx->dev;
> +
> +	mutex_lock(&dev->enc_mutex);
> +	return 0;
> +}
> +
> +void mtk_vcodec_enc_release(struct mtk_vcodec_ctx *ctx)
> +{
> +	venc_if_deinit(ctx);
> +}
> diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.h b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.h
> new file mode 100644
> index 0000000..5a88644
> --- /dev/null
> +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.h
> @@ -0,0 +1,59 @@
> +/*
> +* Copyright (c) 2016 MediaTek Inc.
> +* Author: PC Chen <pc.chen@mediatek.com>
> +*		Tiffany Lin <tiffany.lin@mediatek.com>
> +*
> +* This program is free software; you can redistribute it and/or modify
> +* it under the terms of the GNU General Public License version 2 as
> +* published by the Free Software Foundation.
> +*
> +* This program is distributed in the hope that it will be useful,
> +* but WITHOUT ANY WARRANTY; without even the implied warranty of
> +* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +* GNU General Public License for more details.
> +*/
> +
> +#ifndef _MTK_VCODEC_ENC_H_
> +#define _MTK_VCODEC_ENC_H_
> +
> +#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
> +
> +#define MTK_VENC_IRQ_STATUS_SPS	0x1
> +#define MTK_VENC_IRQ_STATUS_PPS	0x2
> +#define MTK_VENC_IRQ_STATUS_FRM	0x4
> +#define MTK_VENC_IRQ_STATUS_DRAM	0x8
> +#define MTK_VENC_IRQ_STATUS_PAUSE	0x10
> +#define MTK_VENC_IRQ_STATUS_SWITCH	0x20
> +
> +#define MTK_VENC_IRQ_STATUS_OFFSET	0x05C
> +#define MTK_VENC_IRQ_ACK_OFFSET	0x060
> +
> +/**
> + * struct mtk_video_enc_buf - Private data related to each VB2 buffer
> + * @vb:	Pointer to related VB2 buffer
> + * @list:	list that buffer link to
> + * @param_change:	Types of encode parameter change before encode this
> + *					buffer
> + * @enc_params:	Encode parameters changed before encode this buffer
> + */
> +struct mtk_video_enc_buf {
> +	struct vb2_v4l2_buffer	vb;
> +	struct list_head	list;
> +
> +	u32	param_change;
> +	struct mtk_enc_params	enc_params;
> +};
> +
> +extern const struct v4l2_ioctl_ops mtk_venc_ioctl_ops;
> +extern const struct v4l2_m2m_ops mtk_venc_m2m_ops;
> +
> +int mtk_venc_unlock(struct mtk_vcodec_ctx *ctx);
> +int mtk_venc_lock(struct mtk_vcodec_ctx *ctx);
> +int mtk_vcodec_enc_queue_init(void *priv, struct vb2_queue *src_vq,
> +					struct vb2_queue *dst_vq);
> +void mtk_vcodec_enc_release(struct mtk_vcodec_ctx *ctx);
> +int mtk_vcodec_enc_ctrls_setup(struct mtk_vcodec_ctx *ctx);
> +void mtk_vcodec_enc_ctx_params_setup(struct mtk_vcodec_ctx *ctx);
> +
> +#endif /* _MTK_VCODEC_ENC_H_ */
> diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
> new file mode 100644
> index 0000000..bd58db7
> --- /dev/null
> +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
> @@ -0,0 +1,465 @@
> +/*
> +* Copyright (c) 2016 MediaTek Inc.
> +* Author: PC Chen <pc.chen@mediatek.com>
> +*		Tiffany Lin <tiffany.lin@mediatek.com>
> +*
> +* This program is free software; you can redistribute it and/or modify
> +* it under the terms of the GNU General Public License version 2 as
> +* published by the Free Software Foundation.
> +*
> +* This program is distributed in the hope that it will be useful,
> +* but WITHOUT ANY WARRANTY; without even the implied warranty of
> +* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +* GNU General Public License for more details.
> +*/
> +
> +#include <linux/interrupt.h>
> +#include <linux/irq.h>
> +#include <linux/module.h>
> +#include <linux/of_device.h>
> +#include <linux/of.h>
> +#include <media/v4l2-event.h>
> +#include <media/v4l2-mem2mem.h>
> +#include <media/videobuf2-dma-contig.h>
> +#include <linux/pm_runtime.h>
> +
> +#include "mtk_vcodec_drv.h"
> +#include "mtk_vcodec_enc.h"
> +#include "mtk_vcodec_enc_pm.h"
> +#include "mtk_vcodec_intr.h"
> +#include "mtk_vcodec_util.h"
> +#include "mtk_vpu.h"
> +
> +
> +module_param(mtk_v4l2_dbg_level, int, S_IRUGO | S_IWUSR);
> +module_param(mtk_vcodec_dbg, bool, S_IRUGO | S_IWUSR);
> +
> +
> +/* Wake up context wait_queue */
> +static void wake_up_ctx(struct mtk_vcodec_ctx *ctx, unsigned int reason)
> +{
> +	ctx->int_cond = 1;
> +	ctx->int_type = reason;
> +	wake_up_interruptible(&ctx->queue);
> +}
> +
> +static void clean_irq_status(unsigned int irq_status, void __iomem *addr)
> +{
> +	if (irq_status & MTK_VENC_IRQ_STATUS_PAUSE)
> +		writel(MTK_VENC_IRQ_STATUS_PAUSE, addr);
> +
> +	if (irq_status & MTK_VENC_IRQ_STATUS_SWITCH)
> +		writel(MTK_VENC_IRQ_STATUS_SWITCH, addr);
> +
> +	if (irq_status & MTK_VENC_IRQ_STATUS_DRAM)
> +		writel(MTK_VENC_IRQ_STATUS_DRAM, addr);
> +
> +	if (irq_status & MTK_VENC_IRQ_STATUS_SPS)
> +		writel(MTK_VENC_IRQ_STATUS_SPS, addr);
> +
> +	if (irq_status & MTK_VENC_IRQ_STATUS_PPS)
> +		writel(MTK_VENC_IRQ_STATUS_PPS, addr);
> +
> +	if (irq_status & MTK_VENC_IRQ_STATUS_FRM)
> +		writel(MTK_VENC_IRQ_STATUS_FRM, addr);
> +
> +}
> +static irqreturn_t mtk_vcodec_enc_irq_handler(int irq, void *priv)
> +{
> +	struct mtk_vcodec_dev *dev = priv;
> +	struct mtk_vcodec_ctx *ctx;
> +	unsigned long flags;
> +	void __iomem *addr;
> +
> +	spin_lock_irqsave(&dev->irqlock, flags);
> +	ctx = dev->curr_ctx;
> +	spin_unlock_irqrestore(&dev->irqlock, flags);
> +
> +	mtk_v4l2_debug(1, "idx=%d", ctx->idx);
> +	addr = dev->reg_base[VENC_SYS] + MTK_VENC_IRQ_ACK_OFFSET;
> +
> +	ctx->irq_status = readl(dev->reg_base[VENC_SYS] +
> +				(MTK_VENC_IRQ_STATUS_OFFSET));
> +
> +	clean_irq_status(ctx->irq_status, addr);
> +
> +	wake_up_ctx(ctx, MTK_INST_IRQ_RECEIVED);
> +	return IRQ_HANDLED;
> +}
> +
> +static irqreturn_t mtk_vcodec_enc_lt_irq_handler(int irq, void *priv)
> +{
> +	struct mtk_vcodec_dev *dev = priv;
> +	struct mtk_vcodec_ctx *ctx;
> +	unsigned long flags;
> +	void __iomem *addr;
> +
> +	spin_lock_irqsave(&dev->irqlock, flags);
> +	ctx = dev->curr_ctx;
> +	spin_unlock_irqrestore(&dev->irqlock, flags);
> +
> +	mtk_v4l2_debug(1, "idx=%d", ctx->idx);
> +	ctx->irq_status = readl(dev->reg_base[VENC_LT_SYS] +
> +				(MTK_VENC_IRQ_STATUS_OFFSET));
> +
> +	addr = dev->reg_base[VENC_LT_SYS] + MTK_VENC_IRQ_ACK_OFFSET;
> +
> +	clean_irq_status(ctx->irq_status, addr);
> +
> +	wake_up_ctx(ctx, MTK_INST_IRQ_RECEIVED);
> +	return IRQ_HANDLED;
> +
> +}
> +
> +static void mtk_vcodec_enc_reset_handler(void *priv)
> +{
> +	struct mtk_vcodec_dev *dev = priv;
> +	struct mtk_vcodec_ctx *ctx;
> +
> +	mtk_v4l2_debug(0, "Watchdog timeout!!");
> +
> +	mutex_lock(&dev->dev_mutex);
> +	list_for_each_entry(ctx, &dev->ctx_list, list) {
> +		ctx->state = MTK_STATE_ABORT;
> +		mtk_v4l2_debug(0, "[%d] Change to state MTK_STATE_ABORT",
> +					   ctx->idx);
> +	}
> +	mutex_unlock(&dev->dev_mutex);
> +}
> +
> +static int fops_vcodec_open(struct file *file)
> +{
> +	struct video_device *vfd = video_devdata(file);
> +	struct mtk_vcodec_dev *dev = video_drvdata(file);
> +	struct mtk_vcodec_ctx *ctx = NULL;
> +	int ret = 0;
> +
> +	mutex_lock(&dev->dev_mutex);
> +
> +	if (dev->instance_mask == ~0UL) {
> +		/* ffz Undefined if no zero exists, err handling here */
> +		mtk_v4l2_err("Too many open contexts");
> +		ret = -EBUSY;
> +		goto err_alloc;
> +	}
> +
> +	ctx = devm_kzalloc(&dev->plat_dev->dev, sizeof(*ctx), GFP_KERNEL);
> +	if (!ctx) {
> +		ret = -ENOMEM;
> +		goto err_alloc;
> +	}
> +
> +	ctx->idx = ffz(dev->instance_mask);
> +	v4l2_fh_init(&ctx->fh, video_devdata(file));
> +	file->private_data = &ctx->fh;
> +	v4l2_fh_add(&ctx->fh);
> +	INIT_LIST_HEAD(&ctx->list);
> +	ctx->dev = dev;
> +	init_waitqueue_head(&ctx->queue);
> +
> +	if (vfd == dev->vfd_enc) {
> +		ctx->type = MTK_INST_ENCODER;
> +		ret = mtk_vcodec_enc_ctrls_setup(ctx);
> +		if (ret) {
> +			mtk_v4l2_err("Failed to setup controls() (%d)",
> +				       ret);
> +			goto err_ctrls_setup;
> +		}
> +		ctx->m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev_enc, ctx,
> +						 &mtk_vcodec_enc_queue_init);
> +		if (IS_ERR(ctx->m2m_ctx)) {
> +			ret = PTR_ERR(ctx->m2m_ctx);
> +			mtk_v4l2_err("Failed to v4l2_m2m_ctx_init() (%d)",
> +				       ret);
> +			goto err_m2m_ctx_init;
> +		}
> +		mtk_vcodec_enc_ctx_params_setup(ctx);
> +	} else {
> +		mtk_v4l2_err("Invalid vfd !");
> +		ret = -ENOENT;
> +		goto err_m2m_ctx_init;
> +	}
> +
> +	if (v4l2_fh_is_singular(&ctx->fh)) {
> +		ret = vpu_load_firmware(dev->vpu_plat_dev);
> +		if (ret < 0) {
> +			/*
> +			  * Return 0 if downloading firmware successfully,
> +			  * otherwise it is failed
> +			  */
> +			mtk_v4l2_err("vpu_load_firmware failed!");
> +			goto err_load_fw;
> +		}
> +
> +		dev->enc_capability =
> +			vpu_get_venc_hw_capa(dev->vpu_plat_dev);
> +		mtk_v4l2_debug(0, "encoder capability %x", dev->enc_capability);
> +	}
> +
> +	mtk_v4l2_debug(2, "Create instance [%d]@%p m2m_ctx=%p ",
> +			 ctx->idx, ctx, ctx->m2m_ctx);
> +	set_bit(ctx->idx, &dev->instance_mask);
> +	dev->num_instances++;
> +	list_add(&ctx->list, &dev->ctx_list);
> +
> +	mutex_unlock(&dev->dev_mutex);
> +	mtk_v4l2_debug(0, "%s encoder [%d]", dev_name(&dev->plat_dev->dev),
> +				   ctx->idx);
> +	return ret;
> +
> +	/* Deinit when failure occurred */
> +err_load_fw:
> +	v4l2_m2m_ctx_release(ctx->m2m_ctx);
> +err_m2m_ctx_init:
> +	v4l2_ctrl_handler_free(&ctx->ctrl_hdl);
> +err_ctrls_setup:
> +	v4l2_fh_del(&ctx->fh);
> +	v4l2_fh_exit(&ctx->fh);
> +	devm_kfree(&dev->plat_dev->dev, ctx);
> +err_alloc:
> +	mutex_unlock(&dev->dev_mutex);
> +
> +	return ret;
> +}
> +
> +static int fops_vcodec_release(struct file *file)
> +{
> +	struct mtk_vcodec_dev *dev = video_drvdata(file);
> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(file->private_data);
> +
> +	mtk_v4l2_debug(1, "[%d] encoder", ctx->idx);
> +	mutex_lock(&dev->dev_mutex);
> +
> +	mtk_vcodec_enc_release(ctx);
> +	v4l2_fh_del(&ctx->fh);
> +	v4l2_fh_exit(&ctx->fh);
> +	v4l2_ctrl_handler_free(&ctx->ctrl_hdl);
> +	v4l2_m2m_ctx_release(ctx->m2m_ctx);
> +
> +	list_del_init(&ctx->list);
> +	dev->num_instances--;
> +	clear_bit(ctx->idx, &dev->instance_mask);
> +	devm_kfree(&dev->plat_dev->dev, ctx);
> +	mutex_unlock(&dev->dev_mutex);
> +	return 0;
> +}
> +
> +static const struct v4l2_file_operations mtk_vcodec_fops = {
> +	.owner				= THIS_MODULE,
> +	.open				= fops_vcodec_open,
> +	.release			= fops_vcodec_release,
> +	.poll				= v4l2_m2m_fop_poll,
> +	.unlocked_ioctl			= video_ioctl2,
> +	.mmap				= v4l2_m2m_fop_mmap,
> +};
> +
> +static int mtk_vcodec_probe(struct platform_device *pdev)
> +{
> +	struct mtk_vcodec_dev *dev;
> +	struct video_device *vfd_enc;
> +	struct resource *res;
> +	int i, j, ret;
> +	DEFINE_DMA_ATTRS(attrs);
> +
> +	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
> +	if (!dev)
> +		return -ENOMEM;
> +
> +	INIT_LIST_HEAD(&dev->ctx_list);
> +	dev->plat_dev = pdev;
> +
> +	dev->vpu_plat_dev = vpu_get_plat_device(dev->plat_dev);
> +	if (dev->vpu_plat_dev == NULL) {
> +		mtk_v4l2_err("[VPU] vpu device in not ready");
> +		return -EPROBE_DEFER;
> +	}
> +
> +	vpu_wdt_reg_handler(dev->vpu_plat_dev, mtk_vcodec_enc_reset_handler,
> +						dev, VPU_RST_ENC);
> +
> +	ret = mtk_vcodec_init_enc_pm(dev);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "Failed to get mt vcodec clock source!");
> +		return ret;
> +	}
> +
> +	for (i = VENC_SYS, j = 0; i < NUM_MAX_VCODEC_REG_BASE; i++, j++) {
> +		res = platform_get_resource(pdev, IORESOURCE_MEM, j);
> +		if (res == NULL) {
> +			dev_err(&pdev->dev, "get memory resource failed.");
> +			ret = -ENXIO;
> +			goto err_res;
> +		}
> +		dev->reg_base[i] = devm_ioremap_resource(&pdev->dev, res);
> +		if (IS_ERR(dev->reg_base[i])) {
> +			dev_err(&pdev->dev,
> +				"devm_ioremap_resource %d failed.", i);
> +			ret = PTR_ERR(dev->reg_base[i]);
> +			goto err_res;
> +		}
> +		mtk_v4l2_debug(2, "reg[%d] base=0x%p", i, dev->reg_base[i]);
> +	}
> +
> +	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> +	if (res == NULL) {
> +		dev_err(&pdev->dev, "failed to get irq resource");
> +		ret = -ENOENT;
> +		goto err_res;
> +	}
> +
> +	dev->enc_irq = platform_get_irq(pdev, 0);
> +	ret = devm_request_irq(&pdev->dev, dev->enc_irq,
> +			       mtk_vcodec_enc_irq_handler,
> +			       0, pdev->name, dev);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Failed to install dev->enc_irq %d (%d)",
> +			dev->enc_irq,
> +			ret);
> +		ret = -EINVAL;
> +		goto err_res;
> +	}
> +
> +	dev->enc_lt_irq = platform_get_irq(pdev, 1);
> +	ret = devm_request_irq(&pdev->dev,
> +			       dev->enc_lt_irq, mtk_vcodec_enc_lt_irq_handler,
> +			       0, pdev->name, dev);
> +	if (ret) {
> +		dev_err(&pdev->dev,
> +			"Failed to install dev->enc_lt_irq %d (%d)",
> +			dev->enc_lt_irq, ret);
> +		ret = -EINVAL;
> +		goto err_res;
> +	}
> +
> +	disable_irq(dev->enc_irq);
> +	disable_irq(dev->enc_lt_irq); /* VENC_LT */
> +	mutex_init(&dev->enc_mutex);
> +	mutex_init(&dev->dev_mutex);
> +	spin_lock_init(&dev->irqlock);
> +
> +	snprintf(dev->v4l2_dev.name, sizeof(dev->v4l2_dev.name), "%s",
> +		 "[MTK_V4L2_VENC]");
> +
> +	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
> +	if (ret) {
> +		mtk_v4l2_err("v4l2_device_register err=%d", ret);
> +		goto err_res;
> +	}
> +
> +	init_waitqueue_head(&dev->queue);
> +
> +	/* allocate video device for encoder and register it */
> +	vfd_enc = video_device_alloc();
> +	if (!vfd_enc) {
> +		mtk_v4l2_err("Failed to allocate video device");
> +		ret = -ENOMEM;
> +		goto err_enc_alloc;
> +	}
> +	vfd_enc->fops           = &mtk_vcodec_fops;
> +	vfd_enc->ioctl_ops      = &mtk_venc_ioctl_ops;
> +	vfd_enc->release        = video_device_release;
> +	vfd_enc->lock           = &dev->dev_mutex;
> +	vfd_enc->v4l2_dev       = &dev->v4l2_dev;
> +	vfd_enc->vfl_dir        = VFL_DIR_M2M;
> +
> +	snprintf(vfd_enc->name, sizeof(vfd_enc->name), "%s",
> +		 MTK_VCODEC_ENC_NAME);
> +	video_set_drvdata(vfd_enc, dev);
> +	dev->vfd_enc = vfd_enc;
> +	platform_set_drvdata(pdev, dev);
> +
> +	dev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
> +	if (IS_ERR(dev->alloc_ctx)) {
> +		dev->alloc_ctx = NULL;
> +		mtk_v4l2_err("Failed to alloc vb2 dma context 0");
> +		ret = PTR_ERR(dev->alloc_ctx);
> +		goto err_vb2_ctx_init;
> +	}
> +
> +	dev->m2m_dev_enc = v4l2_m2m_init(&mtk_venc_m2m_ops);
> +	if (IS_ERR(dev->m2m_dev_enc)) {
> +		mtk_v4l2_err("Failed to init mem2mem enc device");
> +		ret = PTR_ERR(dev->m2m_dev_enc);
> +		goto err_enc_mem_init;
> +	}
> +
> +	dev->encode_workqueue =
> +			alloc_ordered_workqueue(MTK_VCODEC_ENC_NAME,
> +								WQ_MEM_RECLAIM |
> +								WQ_FREEZABLE);
> +	if (!dev->encode_workqueue) {
> +		mtk_v4l2_err("Failed to create encode workqueue");
> +		ret = -EINVAL;
> +		goto err_event_workq;
> +	}
> +
> +	ret = video_register_device(vfd_enc, VFL_TYPE_GRABBER, 1);
> +	if (ret) {
> +		mtk_v4l2_err("Failed to register video device");
> +		goto err_enc_reg;
> +	}
> +
> +	/* Avoid the iommu eat big hunks */
> +	dma_set_attr(DMA_ATTR_ALLOC_SINGLE_PAGES, &attrs);
> +
> +	mtk_v4l2_debug(0, "encoder registered as /dev/video%d",
> +			 vfd_enc->num);
> +
> +	return 0;
> +
> +err_enc_reg:
> +	destroy_workqueue(dev->encode_workqueue);
> +err_event_workq:
> +	v4l2_m2m_release(dev->m2m_dev_enc);
> +err_enc_mem_init:
> +	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
> +err_vb2_ctx_init:
> +	video_unregister_device(vfd_enc);
> +err_enc_alloc:
> +	v4l2_device_unregister(&dev->v4l2_dev);
> +err_res:
> +	mtk_vcodec_release_enc_pm(dev);
> +	return ret;
> +}
> +
> +static const struct of_device_id mtk_vcodec_enc_match[] = {
> +	{.compatible = "mediatek,mt8173-vcodec-enc",},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, mtk_vcodec_enc_match);
> +
> +static int mtk_vcodec_enc_remove(struct platform_device *pdev)
> +{
> +	struct mtk_vcodec_dev *dev = platform_get_drvdata(pdev);
> +
> +	mtk_v4l2_debug_enter();
> +	flush_workqueue(dev->encode_workqueue);
> +	destroy_workqueue(dev->encode_workqueue);
> +	if (dev->m2m_dev_enc)
> +		v4l2_m2m_release(dev->m2m_dev_enc);
> +	if (dev->alloc_ctx)
> +		vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
> +
> +	if (dev->vfd_enc)
> +		video_unregister_device(dev->vfd_enc);
> +
> +	v4l2_device_unregister(&dev->v4l2_dev);
> +	mtk_vcodec_release_enc_pm(dev);
> +	return 0;
> +}
> +
> +static struct platform_driver mtk_vcodec_enc_driver = {
> +	.probe	= mtk_vcodec_probe,
> +	.remove	= mtk_vcodec_enc_remove,
> +	.driver	= {
> +		.name	= MTK_VCODEC_ENC_NAME,
> +		.owner	= THIS_MODULE,
> +		.of_match_table = mtk_vcodec_enc_match,
> +	},
> +};
> +
> +module_platform_driver(mtk_vcodec_enc_driver);
> +
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_DESCRIPTION("Mediatek video codec V4L2 encoder driver");

Regards,

	Hans

