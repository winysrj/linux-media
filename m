Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:51220 "EHLO
        mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751533AbdBFOyz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Feb 2017 09:54:55 -0500
Subject: Re: [PATCH 10/11] [media] v4l2: Add v4l2 control IDs for HEVC encoder
To: Smitha T Murthy <smitha.t@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, kamil@wypas.org, jtp.park@samsung.com,
        mchehab@kernel.org, pankaj.dubey@samsung.com, krzk@kernel.org,
        m.szyprowski@samsung.com, s.nawrocki@samsung.com,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Wu-Cheng Li <wuchengli@chromium.org>,
        Kieran Bingham <kieran@ksquared.org.uk>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
From: Andrzej Hajda <a.hajda@samsung.com>
Message-id: <dcc96d3e-6835-190e-7997-8d71f617caee@samsung.com>
Date: Mon, 06 Feb 2017 15:54:48 +0100
MIME-version: 1.0
In-reply-to: <1484733729-25371-11-git-send-email-smitha.t@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
References: <1484733729-25371-1-git-send-email-smitha.t@samsung.com>
 <CGME20170118100818epcas5p1c7153a6fe9d93f96269008f42f736b90@epcas5p1.samsung.com>
 <1484733729-25371-11-git-send-email-smitha.t@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Smitha,

I have no big experience with HEVC, so it is hard to review it
appropriately but I will try do my best.
As these control names goes to user space you should be very careful
about it.
I guess it could be good to compare these controls with other HEVC
encoders including software ones (ffmpeg, intel, ...) to find some
similarities, common naming convention.


On 18.01.2017 11:02, Smitha T Murthy wrote:
> Add v4l2 controls for HEVC encoder
>
> CC: Hans Verkuil <hans.verkuil@cisco.com>
> CC: Wu-Cheng Li <wuchengli@chromium.org>
> CC: Kieran Bingham <kieran@bingham.xyz>
> CC: Vladimir Zapolskiy <vz@mleia.com>
> CC: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
> ---
>  drivers/media/v4l2-core/v4l2-ctrls.c |   51 ++++++++++++++++
>  include/uapi/linux/v4l2-controls.h   |  109 ++++++++++++++++++++++++++++++++++
>  2 files changed, 160 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index 47001e2..387439d 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -775,6 +775,57 @@ static bool is_new_manual(const struct v4l2_ctrl *master)
>  	case V4L2_CID_MPEG_VIDEO_VPX_P_FRAME_QP:		return "VPX P-Frame QP Value";
>  	case V4L2_CID_MPEG_VIDEO_VPX_PROFILE:			return "VPX Profile";
>  
> +	/* HEVC controls */
> +	case V4L2_CID_MPEG_VIDEO_HEVC_I_FRAME_QP:		return "HEVC Frame QP value";

Should be "HEVC I-Frame", it looks like the convention is to upper-case
first letter of all words,
and the convention is I-Frame, B-Frame, P-Frame, here and in the next
controls.
I would drop also the word "value", but it is already used in other
controls so I do not know :)

> +	case V4L2_CID_MPEG_VIDEO_HEVC_P_FRAME_QP:		return "HEVC P frame QP value";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_B_FRAME_QP:		return "HEVC B frame QP value";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_MIN_QP:			return "HEVC Minimum QP value";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_MAX_QP:			return "HEVC Maximum QP value";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_ADAPTIVE_RC_DARK:		return "HEVC dark region adaptive";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_ADAPTIVE_RC_SMOOTH:	return "HEVC smooth region adaptive";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_ADAPTIVE_RC_STATIC:	return "HEVC static region adaptive";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_ADAPTIVE_RC_ACTIVITY:	return "HEVC activity adaptive";

Shouldn't it be "... Region Adaptive RC", or "... Region Adaptive Rate
Control" ?

> +	case V4L2_CID_MPEG_VIDEO_HEVC_PROFILE:			return "HEVC Profile";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_LEVEL:			return "HEVC level";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_TIER_FLAG:		return "HEVC tier_flag default is Main";

I guess 0 - means main tier, 1 means high tier, am I right? In such case
it should be named "HEVC high tier" or sth similar.

> +	case V4L2_CID_MPEG_VIDEO_HEVC_RC_FRAME_RATE:		return "HEVC Frame rate";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_MAX_PARTITION_DEPTH:	return "HEVC Maximum coding unit depth";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_REF_NUMBER_FOR_PFRAMES:	return "HEVC Number of reference picture";

What is purpose of this control? Macro name suggest sth different than
string.

> +	case V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_TYPE:		return "HEVC refresh type";

Could you enumerate these refresh types, in patch 9 and documentation,
maybe it would be worth to make it menu.

> +	case V4L2_CID_MPEG_VIDEO_HEVC_CONST_INTRA_PRED_ENABLE:	return "HEVC constant intra prediction enabled";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_LOSSLESS_CU_ENABLE:	return "HEVC lossless encoding select";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_WAVEFRONT_ENABLE:		return "HEVC Wavefront enable";

I see: enable, enabled, select. Let it be consistent.

> +	case V4L2_CID_MPEG_VIDEO_HEVC_LF_DISABLE:		return "HEVC Filter disable";

There is LF in macro name.

> +	case V4L2_CID_MPEG_VIDEO_HEVC_LF_SLICE_BOUNDARY:	return "across or not slice boundary";

What does it mean?

> +	case V4L2_CID_MPEG_VIDEO_HEVC_LTR_ENABLE:		return "long term reference enable";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_QP_ENABLE:	return "QP values for temporal layer";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_TYPE:	return "Hierarchical Coding Type";

Please enumerate types.

> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER:return "Hierarchical Coding Layer";

Please enumerate layers.

> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_QP:return "Hierarchical Coding Layer QP";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_BIT0:return "Hierarchical Coding Layer BIT0";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_BIT1:return "Hierarchical Coding Layer BIT1";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_BIT2:return "Hierarchical Coding Layer BIT2";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_BIT3:return "Hierarchical Coding Layer BIT3";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_BIT4:return "Hierarchical Coding Layer BIT4";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_BIT5:return "Hierarchical Coding Layer BIT5";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_BIT6:return "Hierarchical Coding Layer BIT6";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_CH:return "Hierarchical Coding Layer Change";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_SIGN_DATA_HIDING:		return "HEVC Sign data hiding";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_GENERAL_PB_ENABLE:	return "HEVC General pb enable";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_TEMPORAL_ID_ENABLE:	return "HEVC Temporal id enable";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_STRONG_SMOTHING_FLAG:	return "HEVC Strong intra smoothing flag";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_DISABLE_INTRA_PU_SPLIT:	return "HEVC disable intra pu split";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_DISABLE_TMV_PREDICTION:	return "HEVC disable tmv prediction";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_MAX_NUM_MERGE_MV_MINUS1:	return "max number of candidate MVs";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_WITHOUT_STARTCODE_ENABLE:	return "ENC without startcode enable";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_PERIOD:		return "HEVC Number of reference picture";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_LF_BETA_OFFSET_DIV2:	return "HEVC loop filter beta offset";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_LF_TC_OFFSET_DIV2:	return "HEVC loop filter tc offset";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_SIZE_OF_LENGTH_FIELD:	return "HEVC size of length field";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_USER_REF:			return "user long term reference frame";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_STORE_REF:		return "store long term reference frame";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_PREPEND_SPSPPS_TO_IDR:	return "Prepend SPS/PPS to every IDR";

You sometimes add HEVC prefix sometimes not, why?

Could you describe more these controls in documentation (patch 9), it is
hard to guess what they do.

Regards
Andrzej

> +
>  	/* CAMERA controls */
>  	/* Keep the order of the 'case's the same as in v4l2-controls.h! */
>  	case V4L2_CID_CAMERA_CLASS:		return "Camera Controls";
> diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> index 0d2e1e0..a2a1c5d 100644
> --- a/include/uapi/linux/v4l2-controls.h
> +++ b/include/uapi/linux/v4l2-controls.h
> @@ -579,6 +579,115 @@ enum v4l2_vp8_golden_frame_sel {
>  #define V4L2_CID_MPEG_VIDEO_VPX_P_FRAME_QP		(V4L2_CID_MPEG_BASE+510)
>  #define V4L2_CID_MPEG_VIDEO_VPX_PROFILE			(V4L2_CID_MPEG_BASE+511)
>  
> +/* CIDs for HEVC encoding. Number gaps are for compatibility */
> +
> +#define V4L2_CID_MPEG_VIDEO_HEVC_MIN_QP                         \
> +					(V4L2_CID_MPEG_BASE + 512)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_MAX_QP                         \
> +					(V4L2_CID_MPEG_BASE + 513)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_I_FRAME_QP                     \
> +					(V4L2_CID_MPEG_BASE + 514)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_P_FRAME_QP                     \
> +					(V4L2_CID_MPEG_BASE + 515)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_B_FRAME_QP                     \
> +					(V4L2_CID_MPEG_BASE + 516)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_QP_ENABLE \
> +					(V4L2_CID_MPEG_BASE + 517)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_TYPE       \
> +					(V4L2_CID_MPEG_BASE + 518)
> +enum v4l2_mpeg_video_hevc_hier_coding_type {
> +	V4L2_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_B	= 0,
> +	V4L2_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_P	= 1,
> +};
> +#define V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER      \
> +					(V4L2_CID_MPEG_BASE + 519)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_QP   \
> +					(V4L2_CID_MPEG_BASE + 520)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_PROFILE                        \
> +					(V4L2_CID_MPEG_BASE + 521)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_LEVEL                          \
> +					(V4L2_CID_MPEG_BASE + 522)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_RC_FRAME_RATE            \
> +					(V4L2_CID_MPEG_BASE + 523)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_TIER_FLAG                \
> +					(V4L2_CID_MPEG_BASE + 524)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_MAX_PARTITION_DEPTH      \
> +					(V4L2_CID_MPEG_BASE + 525)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_REF_NUMBER_FOR_PFRAMES   \
> +					(V4L2_CID_MPEG_BASE + 526)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_LF_DISABLE               \
> +					(V4L2_CID_MPEG_BASE + 527)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_LF_SLICE_BOUNDARY        \
> +					(V4L2_CID_MPEG_BASE + 528)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_LF_BETA_OFFSET_DIV2      \
> +					(V4L2_CID_MPEG_BASE + 529)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_LF_TC_OFFSET_DIV2        \
> +					(V4L2_CID_MPEG_BASE + 530)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_TYPE             \
> +					(V4L2_CID_MPEG_BASE + 531)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_PERIOD           \
> +					(V4L2_CID_MPEG_BASE + 532)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_LOSSLESS_CU_ENABLE       \
> +					(V4L2_CID_MPEG_BASE + 533)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_CONST_INTRA_PRED_ENABLE  \
> +					(V4L2_CID_MPEG_BASE + 534)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_WAVEFRONT_ENABLE         \
> +					(V4L2_CID_MPEG_BASE + 535)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_LTR_ENABLE               \
> +					(V4L2_CID_MPEG_BASE + 536)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_USER_REF                 \
> +					(V4L2_CID_MPEG_BASE + 537)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_STORE_REF                \
> +					(V4L2_CID_MPEG_BASE + 538)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_SIGN_DATA_HIDING         \
> +					(V4L2_CID_MPEG_BASE + 539)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_GENERAL_PB_ENABLE        \
> +					(V4L2_CID_MPEG_BASE + 540)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_TEMPORAL_ID_ENABLE       \
> +					(V4L2_CID_MPEG_BASE + 541)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_STRONG_SMOTHING_FLAG     \
> +					(V4L2_CID_MPEG_BASE + 542)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_MAX_NUM_MERGE_MV_MINUS1  \
> +					(V4L2_CID_MPEG_BASE + 543)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_ADAPTIVE_RC_DARK         \
> +					(V4L2_CID_MPEG_BASE + 544)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_ADAPTIVE_RC_SMOOTH       \
> +					(V4L2_CID_MPEG_BASE + 545)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_ADAPTIVE_RC_STATIC       \
> +					(V4L2_CID_MPEG_BASE + 546)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_ADAPTIVE_RC_ACTIVITY     \
> +					(V4L2_CID_MPEG_BASE + 547)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_DISABLE_INTRA_PU_SPLIT   \
> +					(V4L2_CID_MPEG_BASE + 548)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_DISABLE_TMV_PREDICTION   \
> +					(V4L2_CID_MPEG_BASE + 549)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_WITHOUT_STARTCODE_ENABLE \
> +					(V4L2_CID_MPEG_BASE + 550)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_QP_INDEX_CR              \
> +					(V4L2_CID_MPEG_BASE + 551)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_QP_INDEX_CB              \
> +					(V4L2_CID_MPEG_BASE + 552)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_SIZE_OF_LENGTH_FIELD     \
> +					(V4L2_CID_MPEG_BASE + 553)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_PREPEND_SPSPPS_TO_IDR          \
> +					(V4L2_CID_MPEG_BASE + 554)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_CH   \
> +					(V4L2_CID_MPEG_BASE + 555)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_BIT0 \
> +					(V4L2_CID_MPEG_BASE + 556)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_BIT1 \
> +					(V4L2_CID_MPEG_BASE + 557)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_BIT2 \
> +					(V4L2_CID_MPEG_BASE + 558)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_BIT3 \
> +					(V4L2_CID_MPEG_BASE + 559)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_BIT4 \
> +					(V4L2_CID_MPEG_BASE + 560)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_BIT5 \
> +					(V4L2_CID_MPEG_BASE + 561)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_BIT6 \
> +					(V4L2_CID_MPEG_BASE + 562)
> +
>  /*  MPEG-class control IDs specific to the CX2341x driver as defined by V4L2 */
>  #define V4L2_CID_MPEG_CX2341X_BASE 				(V4L2_CTRL_CLASS_MPEG | 0x1000)
>  #define V4L2_CID_MPEG_CX2341X_VIDEO_SPATIAL_FILTER_MODE 	(V4L2_CID_MPEG_CX2341X_BASE+0)


