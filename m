Return-path: <mchehab@pedra>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3137 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab1FVIul (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2011 04:50:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Kamil Debski <k.debski@samsung.com>
Subject: Re: [PATCH 4/4 v9] MFC: Add MFC 5.1 V4L2 driver
Date: Wed, 22 Jun 2011 10:50:27 +0200
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, jaeryul.oh@samsung.com,
	laurent.pinchart@ideasonboard.com, jtp.park@samsung.com
References: <1308069416-24723-1-git-send-email-k.debski@samsung.com> <1308069416-24723-5-git-send-email-k.debski@samsung.com>
In-Reply-To: <1308069416-24723-5-git-send-email-k.debski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106221050.27847.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday, June 14, 2011 18:36:56 Kamil Debski wrote:
> Multi Format Codec 5.1 is a hardware video coding acceleration
> module found in the S5PV210 and Exynos4 Samsung SoCs. It is
> capable of handling a range of video codecs and this driver
> provides a V4L2 interface for video decoding and encoding.
> 
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Jeongtae Park <jtp.park@samsung.com>
> ---
>  drivers/media/video/Kconfig                  |    8 +
>  drivers/media/video/Makefile                 |    1 +
>  drivers/media/video/s5p-mfc/Makefile         |    5 +
>  drivers/media/video/s5p-mfc/regs-mfc.h       |  385 +++++
>  drivers/media/video/s5p-mfc/s5p_mfc.c        | 1359 +++++++++++++++++
>  drivers/media/video/s5p-mfc/s5p_mfc_cmd.c    |  143 ++
>  drivers/media/video/s5p-mfc/s5p_mfc_cmd.h    |   28 +
>  drivers/media/video/s5p-mfc/s5p_mfc_common.h |  472 ++++++
>  drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c   |  393 +++++
>  drivers/media/video/s5p-mfc/s5p_mfc_ctrl.h   |   27 +
>  drivers/media/video/s5p-mfc/s5p_mfc_debug.h  |   48 +
>  drivers/media/video/s5p-mfc/s5p_mfc_dec.c    | 1106 ++++++++++++++
>  drivers/media/video/s5p-mfc/s5p_mfc_dec.h    |   23 +
>  drivers/media/video/s5p-mfc/s5p_mfc_enc.c    | 2021 ++++++++++++++++++++++++++
>  drivers/media/video/s5p-mfc/s5p_mfc_enc.h    |   23 +
>  drivers/media/video/s5p-mfc/s5p_mfc_inst.c   |   52 +
>  drivers/media/video/s5p-mfc/s5p_mfc_inst.h   |   19 +
>  drivers/media/video/s5p-mfc/s5p_mfc_intr.c   |   94 ++
>  drivers/media/video/s5p-mfc/s5p_mfc_intr.h   |   26 +
>  drivers/media/video/s5p-mfc/s5p_mfc_mem.h    |   55 +
>  drivers/media/video/s5p-mfc/s5p_mfc_opr.c    | 1588 ++++++++++++++++++++
>  drivers/media/video/s5p-mfc/s5p_mfc_opr.h    |   88 ++
>  drivers/media/video/s5p-mfc/s5p_mfc_pm.c     |  131 ++
>  drivers/media/video/s5p-mfc/s5p_mfc_pm.h     |   24 +
>  drivers/media/video/s5p-mfc/s5p_mfc_reg.c    |   30 +
>  drivers/media/video/s5p-mfc/s5p_mfc_reg.h    |  126 ++
>  drivers/media/video/s5p-mfc/s5p_mfc_shm.c    |   55 +
>  drivers/media/video/s5p-mfc/s5p_mfc_shm.h    |   86 ++
>  28 files changed, 8416 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/s5p-mfc/Makefile
>  create mode 100644 drivers/media/video/s5p-mfc/regs-mfc.h
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc.c
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_cmd.c
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_cmd.h
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_common.h
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_ctrl.h
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_debug.h
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_dec.c
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_dec.h
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_enc.c
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_enc.h
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_inst.c
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_inst.h
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_intr.c
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_intr.h
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_mem.h
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr.c
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr.h
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_pm.c
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_pm.h
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_reg.c
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_reg.h
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_shm.c
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_shm.h
> 

...

> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
> new file mode 100644
> index 0000000..a3d7378
> --- /dev/null
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c

...

> +static int s5p_mfc_dec_g_v_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct s5p_mfc_ctx *ctx = ctrl_to_ctx(ctrl);
> +	struct s5p_mfc_dev *dev = ctx->dev;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_MIN_BUFFERS_FOR_CAPTURE:
> +		if (ctx->state >= MFCINST_HEAD_PARSED &&
> +		    ctx->state < MFCINST_ABORT) {
> +			ctrl->cur.val = ctx->dpb_count;
> +			break;
> +		} else if (ctx->state != MFCINST_INIT) {
> +			v4l2_err(&dev->v4l2_dev, "Decoding not initialised.\n");
> +			return -EINVAL;
> +		}
> +
> +		/* Should wait for the header to be parsed */
> +		s5p_mfc_clean_ctx_int_flags(ctx);
> +		s5p_mfc_wait_for_done_ctx(ctx,
> +				S5P_FIMV_R2H_CMD_SEQ_DONE_RET, 0);
> +		if (ctx->state >= MFCINST_HEAD_PARSED &&
> +		    ctx->state < MFCINST_ABORT) {
> +			ctrl->cur.val = ctx->dpb_count;
> +		} else {
> +			v4l2_err(&dev->v4l2_dev,
> +					 "Decoding not initialised.\n");
> +			return -EINVAL;
> +		}
> +		break;
> +	}
> +
> +	return 0;
> +}

Just so you know: I have a long patch series pending that changes the way
drivers handle volatile controls. The change is that instead of setting
ctrl->cur.val the g_volatile_ctrl function will set ctrl->val.

So once my patches are merged this code needs to be changed as well.

> +
> +
> +static const struct v4l2_ctrl_ops s5p_mfc_dec_ctrl_ops = {
> +	.s_ctrl = s5p_mfc_dec_s_ctrl,
> +	.g_volatile_ctrl = s5p_mfc_dec_g_v_ctrl,
> +};
> +

> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
> new file mode 100644
> index 0000000..0da189f
> --- /dev/null
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c

...

> +static int s5p_mfc_enc_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct s5p_mfc_ctx *ctx = ctrl_to_ctx(ctrl);
> +	struct s5p_mfc_dev *dev = ctx->dev;
> +	struct s5p_mfc_enc_params *p = &ctx->enc_params;
> +	int ret = 0;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
> +		p->gop_size = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE:
> +		p->slice_mode = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_MB:
> +		p->slice_mb = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_BYTES:
> +		p->slice_bit = ctrl->val * 8;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_CYCLIC_INTRA_REFRESH_MB:
> +		p->intra_refresh_mb = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_MFC51_VIDEO_PADDING:
> +		p->pad = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_MFC51_VIDEO_PADDING_YUV:
> +		p->pad_luma = (ctrl->val >> 16) & 0xff;
> +		p->pad_cb = (ctrl->val >> 8) & 0xff;
> +		p->pad_cr = (ctrl->val >> 0) & 0xff;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_FRAME_RC_ENABLE:
> +		p->rc_frame = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_BITRATE:
> +		p->rc_bitrate = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_MFC51_VIDEO_RC_REACTION_COEFF:
> +		p->rc_reaction_coeff = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE:
> +		ctx->force_frame_type = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_VBV_SIZE:
> +		p->vbv_size = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_H264_CPB_SIZE:
> +		p->codec.h264.cpb_size = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_HEADER_MODE:
> +		p->seq_hdr_mode = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE:
> +		p->frame_skip_mode = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_MFC51_VIDEO_RC_FIXED_TARGET_BIT:
> +		p->fixed_target_bit = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_B_FRAMES:
> +		p->num_b_frame = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_H264_PROFILE:
> +		switch (ctrl->val) {
> +			case V4L2_MPEG_VIDEO_H264_PROFILE_MAIN:
> +				p->codec.h264.profile =
> +						S5P_FIMV_ENC_PROFILE_H264_MAIN;
> +				break;
> +			case V4L2_MPEG_VIDEO_H264_PROFILE_HIGH:
> +				p->codec.h264.profile =
> +						S5P_FIMV_ENC_PROFILE_H264_HIGH;
> +				break;
> +			case V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE:
> +				p->codec.h264.profile =
> +					S5P_FIMV_ENC_PROFILE_H264_BASELINE;
> +				break;

Note: when you create the menu control with v4l2_ctrl_new_std_menu you
can pass a mask telling the control framework which menu items are
not supported by the hardware. I strongly recommend setting that mask
according to the hardware's capabilities.

> +			default:
> +				ret = -EINVAL;
> +		}
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_H264_LEVEL:
> +		p->codec.h264.level_v4l2 = ctrl->val;
> +		p->codec.h264.level = h264_level(ctrl->val);
> +		if (p->codec.h264.level < 0) {
> +			mfc_err("Level number is wrong.\n");
> +			ret = p->codec.h264.level;
> +		}
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL:
> +		p->codec.mpeg4.level_v4l2 = ctrl->val;
> +		p->codec.mpeg4.level = mpeg4_level(ctrl->val);
> +		if (p->codec.mpeg4.level < 0) {
> +			mfc_err("Level number is wrong.\n");
> +			ret = p->codec.mpeg4.level;
> +		}
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_MODE:
> +		p->codec.h264.loop_filter_mode = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_ALPHA:
> +		p->codec.h264.loop_filter_alpha = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_BETA:
> +		p->codec.h264.loop_filter_beta = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_H264_ENTROPY_MODE:
> +		p->codec.h264.entropy_mode = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_MFC51_VIDEO_H264_NUM_REF_PIC_FOR_P:
> +		p->codec.h264.num_ref_pic_4p = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_H264_8X8_TRANSFORM:
> +		p->codec.h264._8x8_transform = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_MB_RC_ENABLE:
> +		p->codec.h264.rc_mb = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_H264_I_FRAME_QP:
> +		p->codec.h264.rc_frame_qp = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_H264_MIN_QP:
> +		p->codec.h264.rc_min_qp = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_H264_MAX_QP:
> +		p->codec.h264.rc_max_qp = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_H264_P_FRAME_QP:
> +		p->codec.h264.rc_p_frame_qp = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_H264_B_FRAME_QP:
> +		p->codec.h264.rc_b_frame_qp = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP:
> +	case V4L2_CID_MPEG_VIDEO_H263_I_FRAME_QP:
> +		p->codec.mpeg4.rc_frame_qp = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_MPEG4_MIN_QP:
> +	case V4L2_CID_MPEG_VIDEO_H263_MIN_QP:
> +		p->codec.mpeg4.rc_min_qp = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_MPEG4_MAX_QP:
> +	case V4L2_CID_MPEG_VIDEO_H263_MAX_QP:
> +		p->codec.mpeg4.rc_max_qp = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP:
> +	case V4L2_CID_MPEG_VIDEO_H263_P_FRAME_QP:
> +		p->codec.mpeg4.rc_p_frame_qp = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_MPEG4_B_FRAME_QP:
> +	case V4L2_CID_MPEG_VIDEO_H263_B_FRAME_QP:
> +		p->codec.mpeg4.rc_b_frame_qp = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_DARK:
> +		p->codec.h264.rc_mb_dark = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_SMOOTH:
> +		p->codec.h264.rc_mb_smooth = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_STATIC:
> +		p->codec.h264.rc_mb_static = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_ACTIVITY:
> +		p->codec.h264.rc_mb_activity = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_ENABLE:
> +		p->codec.h264.vui_sar = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_IDC:
> +		p->codec.h264.vui_sar_idc = vui_sar_idc(ctrl->val);
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_H264_VUI_EXT_SAR_WIDTH:
> +		p->codec.h264.vui_ext_sar_width = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_H264_VUI_EXT_SAR_HEIGHT:
> +		p->codec.h264.vui_ext_sar_height = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_GOP_CLOSURE:
> +		p->codec.h264.open_gop = !ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_H264_I_PERIOD:
> +		p->codec.h264.open_gop_size = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE:
> +		switch (ctrl->val) {
> +			case V4L2_MPEG_VIDEO_MPEG4_PROFILE_SIMPLE:
> +				p->codec.mpeg4.profile =
> +					S5P_FIMV_ENC_PROFILE_MPEG4_SIMPLE;
> +				break;
> +			case V4L2_MPEG_VIDEO_MPEG4_PROFILE_ADVANCED_SIMPLE:
> +				p->codec.mpeg4.profile =
> +				S5P_FIMV_ENC_PROFILE_MPEG4_ADVANCED_SIMPLE;
> +				break;
> +			default:
> +				ret = -EINVAL;
> +		}
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_MPEG4_QPEL:
> +		p->codec.mpeg4.quarter_pixel = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_MPEG4_VOP_TIME_RES:
> +		p->codec.mpeg4.vop_time_res = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_MPEG4_VOP_TIME_INC:
> +		p->codec.mpeg4.vop_frm_delta = ctrl->val;
> +		break;
> +	default:
> +		v4l2_err(&dev->v4l2_dev, "Invalid control, id=%d, val=%d\n", ctrl->id, ctrl->val);
> +		ret = -EINVAL;
> +	}
> +
> +	return ret;
> +}

Regards,

	Hans
