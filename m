Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:42165 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755558AbeCSOf5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Mar 2018 10:35:57 -0400
Subject: Re: [PATCH] s5p-mfc: Ensure HEVC QP controls range is properly
 updated
To: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-media@vger.kernel.org
Cc: smitha.t@samsung.com, a.hajda@samsung.com,
        linux-samsung-soc@vger.kernel.org
References: <CGME20180319142931epcas2p38fdca1ec6e4a5e5dd654d3ca3ed3577e@epcas2p3.samsung.com>
 <20180319142916.21489-1-s.nawrocki@samsung.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b37c28d0-4899-352a-a494-75d3195cd305@xs4all.nl>
Date: Mon, 19 Mar 2018 15:35:52 +0100
MIME-Version: 1.0
In-Reply-To: <20180319142916.21489-1-s.nawrocki@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/19/2018 03:29 PM, Sylwester Nawrocki wrote:
> When value of V4L2_CID_MPEG_VIDEO_HEVC_MIN_QP or V4L2_CID_MPEG_VIDEO_HEVC_MAX_QP
> controls is changed we should update range of a set of HEVC quantization
> parameter v4l2 controls as specified in the HEVC controls documentation.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans

> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc_enc.c | 40 ++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> index 6c80ebc5dbcc..810dabe2f1b9 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> @@ -1773,6 +1773,42 @@ static inline int vui_sar_idc(enum v4l2_mpeg_video_h264_vui_sar_idc sar)
>  	return t[sar];
>  }
>  
> +/*
> + * Update range of all HEVC quantization parameter controls that depend on the
> + * V4L2_CID_MPEG_VIDEO_HEVC_MIN_QP, V4L2_CID_MPEG_VIDEO_HEVC_MAX_QP controls.
> + */
> +static void __enc_update_hevc_qp_ctrls_range(struct s5p_mfc_ctx *ctx,
> +					     int min, int max)
> +{
> +	static const int __hevc_qp_ctrls[] = {
> +		V4L2_CID_MPEG_VIDEO_HEVC_I_FRAME_QP,
> +		V4L2_CID_MPEG_VIDEO_HEVC_P_FRAME_QP,
> +		V4L2_CID_MPEG_VIDEO_HEVC_B_FRAME_QP,
> +		V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L0_QP,
> +		V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L1_QP,
> +		V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L2_QP,
> +		V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L3_QP,
> +		V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L4_QP,
> +		V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L5_QP,
> +		V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L6_QP,
> +	};
> +	struct v4l2_ctrl *ctrl = NULL;
> +	int i, j;
> +
> +	for (i = 0; i < ARRAY_SIZE(__hevc_qp_ctrls); i++) {
> +		for (j = 0; j < ARRAY_SIZE(ctx->ctrls); j++) {
> +			if (ctx->ctrls[j]->id == __hevc_qp_ctrls[i]) {
> +				ctrl = ctx->ctrls[j];
> +				break;
> +			}
> +		}
> +		if (WARN_ON(!ctrl))
> +			break;
> +
> +		__v4l2_ctrl_modify_range(ctrl, min, max, ctrl->step, min);
> +	}
> +}
> +
>  static int s5p_mfc_enc_s_ctrl(struct v4l2_ctrl *ctrl)
>  {
>  	struct s5p_mfc_ctx *ctx = ctrl_to_ctx(ctrl);
> @@ -2038,9 +2074,13 @@ static int s5p_mfc_enc_s_ctrl(struct v4l2_ctrl *ctrl)
>  		break;
>  	case V4L2_CID_MPEG_VIDEO_HEVC_MIN_QP:
>  		p->codec.hevc.rc_min_qp = ctrl->val;
> +		__enc_update_hevc_qp_ctrls_range(ctx, ctrl->val,
> +						 p->codec.hevc.rc_max_qp);
>  		break;
>  	case V4L2_CID_MPEG_VIDEO_HEVC_MAX_QP:
>  		p->codec.hevc.rc_max_qp = ctrl->val;
> +		__enc_update_hevc_qp_ctrls_range(ctx, p->codec.hevc.rc_min_qp,
> +						 ctrl->val);
>  		break;
>  	case V4L2_CID_MPEG_VIDEO_HEVC_LEVEL:
>  		p->codec.hevc.level_v4l2 = ctrl->val;
> 
