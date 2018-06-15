Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:57732 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S936181AbeFOIvx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 04:51:53 -0400
Subject: Re: [PATCH v3 1/3] media: v4l2-ctrl: Change control for VP8 profile
 to menu control
To: Keiichi Watanabe <keiichiw@chromium.org>,
        linux-arm-kernel@lists.infradead.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tiffany Lin <tiffany.lin@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kamil Debski <kamil@wypas.org>,
        Jeongtae Park <jtp.park@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Smitha T Murthy <smitha.t@samsung.com>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        s.nawrocki@samsung.com
References: <20180614074652.162796-1-keiichiw@chromium.org>
 <20180614074652.162796-2-keiichiw@chromium.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c165d7d1-4d3b-0f19-40e4-c4022b4f5706@xs4all.nl>
Date: Fri, 15 Jun 2018 10:51:44 +0200
MIME-Version: 1.0
In-Reply-To: <20180614074652.162796-2-keiichiw@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 14/06/18 09:46, Keiichi Watanabe wrote:
> Add a menu control V4L2_CID_MPEG_VIDEO_VP8_PROFILE for VP8 profile and
> make V4L2_CID_MPEG_VIDEO_VPX_PROFILE an alias of it. This new control
> is used to select a desired profile for VP8 encoder, and query for
> supported profiles by VP8 encoder/decoder.
> 
> Though we have originally a control V4L2_CID_MPEG_VIDEO_VPX_PROFILE and its name
> contains 'VPX', it works only for VP8 because supported profiles usually differ
> between VP8 and VP9. In addition, this contorol cannot be used for querying

typo: contorol -> control

> since it is not a menu control but an integer control, which cannot return an
> arbitrary set of supported profiles.
> 
> The new control V4L2_CID_MPEG_VIDEO_VP8_PROFILE is a menu control as with
> controls for other codec profiles. (e.g. H264)
> 
> In addition, this patch also fixes the use of
> V4L2_CID_MPEG_VIDEO_VPX_PROFILE in drivers of Qualcomm's venus and
> Samsung's s5p-mfc.
> 
> Signed-off-by: Keiichi Watanabe <keiichiw@chromium.org>
> ---
>  .../media/uapi/v4l/extended-controls.rst      | 27 ++++++++++++++++---
>  drivers/media/platform/qcom/venus/core.h      |  2 +-
>  .../media/platform/qcom/venus/hfi_helper.h    | 12 ++++-----
>  .../media/platform/qcom/venus/vdec_ctrls.c    | 10 ++++---
>  drivers/media/platform/qcom/venus/venc.c      | 14 +++++-----
>  .../media/platform/qcom/venus/venc_ctrls.c    | 12 +++++----
>  drivers/media/platform/s5p-mfc/s5p_mfc_enc.c  | 15 +++++------
>  drivers/media/v4l2-core/v4l2-ctrls.c          | 12 ++++++++-
>  include/uapi/linux/v4l2-controls.h            | 11 +++++++-
>  9 files changed, 79 insertions(+), 36 deletions(-)
> 
> diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
> index 03931f9b1285..de99eafb0872 100644
> --- a/Documentation/media/uapi/v4l/extended-controls.rst
> +++ b/Documentation/media/uapi/v4l/extended-controls.rst
> @@ -1955,9 +1955,30 @@ enum v4l2_vp8_golden_frame_sel -
>  ``V4L2_CID_MPEG_VIDEO_VPX_P_FRAME_QP (integer)``
>      Quantization parameter for a P frame for VP8.
> 
> -``V4L2_CID_MPEG_VIDEO_VPX_PROFILE (integer)``
> -    Select the desired profile for VPx encoder. Acceptable values are 0,
> -    1, 2 and 3 corresponding to encoder profiles 0, 1, 2 and 3.
> +.. _v4l2-mpeg-video-vp8-profile:
> +
> +``V4L2_CID_MPEG_VIDEO_VP8_PROFILE``
> +    (enum)
> +
> +enum v4l2_mpeg_video_vp8_profile -
> +    This control allows to select the profile for VP8 encoder.
> +    This is also used to enumerate supported profiles by VP8 encoder or decoder.
> +    Possible values are:
> +
> +
> +

One empty line is enough.

> +.. flat-table::
> +    :header-rows:  0
> +    :stub-columns: 0
> +
> +    * - ``V4L2_MPEG_VIDEO_VP8_PROFILE_0``
> +      - Profile 0
> +    * - ``V4L2_MPEG_VIDEO_VP8_PROFILE_1``
> +      - Profile 1
> +    * - ``V4L2_MPEG_VIDEO_VP8_PROFILE_2``
> +      - Profile 2
> +    * - ``V4L2_MPEG_VIDEO_VP8_PROFILE_3``
> +      - Profile 3
> 
> 
>  High Efficiency Video Coding (HEVC/H.265) Control Reference
> diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
> index 0360d295f4c8..f242e7f9f6a2 100644
> --- a/drivers/media/platform/qcom/venus/core.h
> +++ b/drivers/media/platform/qcom/venus/core.h
> @@ -159,7 +159,7 @@ struct venc_controls {
>  	struct {
>  		u32 mpeg4;
>  		u32 h264;
> -		u32 vpx;
> +		u32 vp8;
>  	} profile;
>  	struct {
>  		u32 mpeg4;
> diff --git a/drivers/media/platform/qcom/venus/hfi_helper.h b/drivers/media/platform/qcom/venus/hfi_helper.h
> index 55d8eb21403a..07bf49dd2ec6 100644
> --- a/drivers/media/platform/qcom/venus/hfi_helper.h
> +++ b/drivers/media/platform/qcom/venus/hfi_helper.h
> @@ -333,12 +333,12 @@
>  #define HFI_VC1_LEVEL_3				0x00000040
>  #define HFI_VC1_LEVEL_4				0x00000080
> 
> -#define HFI_VPX_PROFILE_SIMPLE			0x00000001
> -#define HFI_VPX_PROFILE_ADVANCED		0x00000002
> -#define HFI_VPX_PROFILE_VERSION_0		0x00000004
> -#define HFI_VPX_PROFILE_VERSION_1		0x00000008
> -#define HFI_VPX_PROFILE_VERSION_2		0x00000010
> -#define HFI_VPX_PROFILE_VERSION_3		0x00000020
> +#define HFI_VP8_PROFILE_SIMPLE			0x00000001
> +#define HFI_VP8_PROFILE_ADVANCED		0x00000002
> +#define HFI_VP8_PROFILE_VERSION_0		0x00000004
> +#define HFI_VP8_PROFILE_VERSION_1		0x00000008
> +#define HFI_VP8_PROFILE_VERSION_2		0x00000010
> +#define HFI_VP8_PROFILE_VERSION_3		0x00000020
> 
>  #define HFI_DIVX_FORMAT_4			0x1
>  #define HFI_DIVX_FORMAT_5			0x2
> diff --git a/drivers/media/platform/qcom/venus/vdec_ctrls.c b/drivers/media/platform/qcom/venus/vdec_ctrls.c
> index 032839bbc967..f4604b0cd57e 100644
> --- a/drivers/media/platform/qcom/venus/vdec_ctrls.c
> +++ b/drivers/media/platform/qcom/venus/vdec_ctrls.c
> @@ -29,7 +29,7 @@ static int vdec_op_s_ctrl(struct v4l2_ctrl *ctrl)
>  		break;
>  	case V4L2_CID_MPEG_VIDEO_H264_PROFILE:
>  	case V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE:
> -	case V4L2_CID_MPEG_VIDEO_VPX_PROFILE:
> +	case V4L2_CID_MPEG_VIDEO_VP8_PROFILE:
>  		ctr->profile = ctrl->val;
>  		break;
>  	case V4L2_CID_MPEG_VIDEO_H264_LEVEL:
> @@ -54,7 +54,7 @@ static int vdec_op_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
>  	switch (ctrl->id) {
>  	case V4L2_CID_MPEG_VIDEO_H264_PROFILE:
>  	case V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE:
> -	case V4L2_CID_MPEG_VIDEO_VPX_PROFILE:
> +	case V4L2_CID_MPEG_VIDEO_VP8_PROFILE:
>  		ret = hfi_session_get_property(inst, ptype, &hprop);
>  		if (!ret)
>  			ctr->profile = hprop.profile_level.profile;
> @@ -130,8 +130,10 @@ int vdec_ctrl_init(struct venus_inst *inst)
>  	if (ctrl)
>  		ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
> 
> -	ctrl = v4l2_ctrl_new_std(&inst->ctrl_handler, &vdec_ctrl_ops,
> -				 V4L2_CID_MPEG_VIDEO_VPX_PROFILE, 0, 3, 1, 0);
> +	ctrl = v4l2_ctrl_new_std_menu(&inst->ctrl_handler, &vdec_ctrl_ops,
> +				      V4L2_CID_MPEG_VIDEO_VP8_PROFILE,
> +				      V4L2_MPEG_VIDEO_VP8_PROFILE_3,
> +				      0, V4L2_MPEG_VIDEO_VP8_PROFILE_0);
>  	if (ctrl)
>  		ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
> 
> diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
> index 6b2ce479584e..aa54dd005c3e 100644
> --- a/drivers/media/platform/qcom/venus/venc.c
> +++ b/drivers/media/platform/qcom/venus/venc.c
> @@ -223,17 +223,17 @@ static int venc_v4l2_to_hfi(int id, int value)
>  		case V4L2_MPEG_VIDEO_H264_ENTROPY_MODE_CABAC:
>  			return HFI_H264_ENTROPY_CABAC;
>  		}
> -	case V4L2_CID_MPEG_VIDEO_VPX_PROFILE:
> +	case V4L2_CID_MPEG_VIDEO_VP8_PROFILE:
>  		switch (value) {
>  		case 0:
>  		default:
> -			return HFI_VPX_PROFILE_VERSION_0;
> +			return HFI_VP8_PROFILE_VERSION_0;
>  		case 1:
> -			return HFI_VPX_PROFILE_VERSION_1;
> +			return HFI_VP8_PROFILE_VERSION_1;
>  		case 2:
> -			return HFI_VPX_PROFILE_VERSION_2;
> +			return HFI_VP8_PROFILE_VERSION_2;
>  		case 3:
> -			return HFI_VPX_PROFILE_VERSION_3;
> +			return HFI_VP8_PROFILE_VERSION_3;
>  		}
>  	case V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_MODE:
>  		switch (value) {
> @@ -756,8 +756,8 @@ static int venc_set_properties(struct venus_inst *inst)
>  		level = venc_v4l2_to_hfi(V4L2_CID_MPEG_VIDEO_H264_LEVEL,
>  					 ctr->level.h264);
>  	} else if (inst->fmt_cap->pixfmt == V4L2_PIX_FMT_VP8) {
> -		profile = venc_v4l2_to_hfi(V4L2_CID_MPEG_VIDEO_VPX_PROFILE,
> -					   ctr->profile.vpx);
> +		profile = venc_v4l2_to_hfi(V4L2_CID_MPEG_VIDEO_VP8_PROFILE,
> +					   ctr->profile.vp8);
>  		level = 0;
>  	} else if (inst->fmt_cap->pixfmt == V4L2_PIX_FMT_MPEG4) {
>  		profile = venc_v4l2_to_hfi(V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE,
> diff --git a/drivers/media/platform/qcom/venus/venc_ctrls.c b/drivers/media/platform/qcom/venus/venc_ctrls.c
> index 21e938a28662..e5162b78609d 100644
> --- a/drivers/media/platform/qcom/venus/venc_ctrls.c
> +++ b/drivers/media/platform/qcom/venus/venc_ctrls.c
> @@ -101,8 +101,8 @@ static int venc_op_s_ctrl(struct v4l2_ctrl *ctrl)
>  	case V4L2_CID_MPEG_VIDEO_H264_PROFILE:
>  		ctr->profile.h264 = ctrl->val;
>  		break;
> -	case V4L2_CID_MPEG_VIDEO_VPX_PROFILE:
> -		ctr->profile.vpx = ctrl->val;
> +	case V4L2_CID_MPEG_VIDEO_VP8_PROFILE:
> +		ctr->profile.vp8 = ctrl->val;
>  		break;
>  	case V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL:
>  		ctr->level.mpeg4 = ctrl->val;
> @@ -248,6 +248,11 @@ int venc_ctrl_init(struct venus_inst *inst)
>  		V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_BYTES,
>  		0, V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_SINGLE);
> 
> +	v4l2_ctrl_new_std_menu(&inst->ctrl_handler, &venc_ctrl_ops,
> +		V4L2_CID_MPEG_VIDEO_VP8_PROFILE,
> +		V4L2_MPEG_VIDEO_VP8_PROFILE_3,
> +		0, V4L2_MPEG_VIDEO_VP8_PROFILE_0);
> +
>  	v4l2_ctrl_new_std(&inst->ctrl_handler, &venc_ctrl_ops,
>  		V4L2_CID_MPEG_VIDEO_BITRATE, BITRATE_MIN, BITRATE_MAX,
>  		BITRATE_STEP, BITRATE_DEFAULT);
> @@ -256,9 +261,6 @@ int venc_ctrl_init(struct venus_inst *inst)
>  		V4L2_CID_MPEG_VIDEO_BITRATE_PEAK, BITRATE_MIN, BITRATE_MAX,
>  		BITRATE_STEP, BITRATE_DEFAULT_PEAK);
> 
> -	v4l2_ctrl_new_std(&inst->ctrl_handler, &venc_ctrl_ops,
> -		V4L2_CID_MPEG_VIDEO_VPX_PROFILE, 0, 3, 1, 0);
> -
>  	v4l2_ctrl_new_std(&inst->ctrl_handler, &venc_ctrl_ops,
>  		V4L2_CID_MPEG_VIDEO_H264_I_FRAME_QP, 1, 51, 1, 26);
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> index 570f391f2cfd..3ad4f5073002 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> @@ -692,12 +692,12 @@ static struct mfc_control controls[] = {
>  		.default_value = 10,
>  	},
>  	{
> -		.id = V4L2_CID_MPEG_VIDEO_VPX_PROFILE,
> -		.type = V4L2_CTRL_TYPE_INTEGER,
> -		.minimum = 0,
> -		.maximum = 3,
> -		.step = 1,
> -		.default_value = 0,
> +		.id = V4L2_CID_MPEG_VIDEO_VP8_PROFILE,
> +		.type = V4L2_CTRL_TYPE_MENU,
> +		.minimum = V4L2_MPEG_VIDEO_VP8_PROFILE_0,
> +		.maximum = V4L2_MPEG_VIDEO_VP8_PROFILE_3,
> +		.default_value = V4L2_MPEG_VIDEO_VP8_PROFILE_0,
> +		.menu_skip_mask = 0,
>  	},
>  	{
>  		.id = V4L2_CID_MPEG_VIDEO_HEVC_I_FRAME_QP,
> @@ -2057,7 +2057,7 @@ static int s5p_mfc_enc_s_ctrl(struct v4l2_ctrl *ctrl)
>  	case V4L2_CID_MPEG_VIDEO_VPX_P_FRAME_QP:
>  		p->codec.vp8.rc_p_frame_qp = ctrl->val;
>  		break;
> -	case V4L2_CID_MPEG_VIDEO_VPX_PROFILE:
> +	case V4L2_CID_MPEG_VIDEO_VP8_PROFILE:
>  		p->codec.vp8.profile = ctrl->val;
>  		break;
>  	case V4L2_CID_MPEG_VIDEO_HEVC_I_FRAME_QP:
> @@ -2711,4 +2711,3 @@ void s5p_mfc_enc_init(struct s5p_mfc_ctx *ctx)
>  	f.fmt.pix_mp.pixelformat = DEF_DST_FMT_ENC;
>  	ctx->dst_fmt = find_format(&f, MFC_FMT_ENC);
>  }
> -
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index d29e45516eb7..e7e6340b395e 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -431,6 +431,13 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>  		"Use Previous Specific Frame",
>  		NULL,
>  	};
> +	static const char * const vp8_profile[] = {
> +		"0",
> +		"1",
> +		"2",
> +		"3",
> +		NULL,
> +	};
> 
>  	static const char * const flash_led_mode[] = {
>  		"Off",
> @@ -614,6 +621,8 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>  		return mpeg4_profile;
>  	case V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_SEL:
>  		return vpx_golden_frame_sel;
> +	case V4L2_CID_MPEG_VIDEO_VP8_PROFILE:
> +		return vp8_profile;
>  	case V4L2_CID_JPEG_CHROMA_SUBSAMPLING:
>  		return jpeg_chroma_subsampling;
>  	case V4L2_CID_DV_TX_MODE:
> @@ -839,7 +848,7 @@ const char *v4l2_ctrl_get_name(u32 id)
>  	case V4L2_CID_MPEG_VIDEO_VPX_MAX_QP:			return "VPX Maximum QP Value";
>  	case V4L2_CID_MPEG_VIDEO_VPX_I_FRAME_QP:		return "VPX I-Frame QP Value";
>  	case V4L2_CID_MPEG_VIDEO_VPX_P_FRAME_QP:		return "VPX P-Frame QP Value";
> -	case V4L2_CID_MPEG_VIDEO_VPX_PROFILE:			return "VPX Profile";
> +	case V4L2_CID_MPEG_VIDEO_VP8_PROFILE:			return "VP8 Profile";
> 
>  	/* HEVC controls */
>  	case V4L2_CID_MPEG_VIDEO_HEVC_I_FRAME_QP:		return "HEVC I-Frame QP Value";
> @@ -1180,6 +1189,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
>  	case V4L2_CID_DEINTERLACING_MODE:
>  	case V4L2_CID_TUNE_DEEMPHASIS:
>  	case V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_SEL:
> +	case V4L2_CID_MPEG_VIDEO_VP8_PROFILE:
>  	case V4L2_CID_DETECT_MD_MODE:
>  	case V4L2_CID_MPEG_VIDEO_HEVC_PROFILE:
>  	case V4L2_CID_MPEG_VIDEO_HEVC_LEVEL:
> diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> index 8d473c979b61..2001823c3072 100644
> --- a/include/uapi/linux/v4l2-controls.h
> +++ b/include/uapi/linux/v4l2-controls.h
> @@ -587,7 +587,16 @@ enum v4l2_vp8_golden_frame_sel {
>  #define V4L2_CID_MPEG_VIDEO_VPX_MAX_QP			(V4L2_CID_MPEG_BASE+508)
>  #define V4L2_CID_MPEG_VIDEO_VPX_I_FRAME_QP		(V4L2_CID_MPEG_BASE+509)
>  #define V4L2_CID_MPEG_VIDEO_VPX_P_FRAME_QP		(V4L2_CID_MPEG_BASE+510)
> -#define V4L2_CID_MPEG_VIDEO_VPX_PROFILE			(V4L2_CID_MPEG_BASE+511)
> +
> +#define V4L2_CID_MPEG_VIDEO_VP8_PROFILE			(V4L2_CID_MPEG_BASE+511)
> +enum v4l2_mpeg_video_vp8_profile {
> +	V4L2_MPEG_VIDEO_VP8_PROFILE_0				= 0,
> +	V4L2_MPEG_VIDEO_VP8_PROFILE_1				= 1,
> +	V4L2_MPEG_VIDEO_VP8_PROFILE_2				= 2,
> +	V4L2_MPEG_VIDEO_VP8_PROFILE_3				= 3,
> +};
> +/* Deprecated alias for compatibility reasons. */
> +#define V4L2_CID_MPEG_VIDEO_VPX_PROFILE	V4L2_CID_MPEG_VIDEO_VP8_PROFILE
> 
>  /* CIDs for HEVC encoding. */
> 
> --
> 2.18.0.rc1.242.g61856ae69a-goog
> 

Regards,

	Hans
