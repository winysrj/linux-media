Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f178.google.com ([209.85.128.178]:33709 "EHLO
        mail-wr0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751002AbdLISss (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 9 Dec 2017 13:48:48 -0500
Received: by mail-wr0-f178.google.com with SMTP id v22so13725653wrb.0
        for <linux-media@vger.kernel.org>; Sat, 09 Dec 2017 10:48:47 -0800 (PST)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: Re: [Patch v6 10/12] [media] v4l2: Add v4l2 control IDs for HEVC
 encoder
To: Smitha T Murthy <smitha.t@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, kamil@wypas.org, jtp.park@samsung.com,
        a.hajda@samsung.com, mchehab@kernel.org, pankaj.dubey@samsung.com,
        krzk@kernel.org, m.szyprowski@samsung.com, s.nawrocki@samsung.com
References: <1512724105-1778-1-git-send-email-smitha.t@samsung.com>
 <CGME20171208093702epcas2p32a30a9f624e06fb543f7dd757c805077@epcas2p3.samsung.com>
 <1512724105-1778-11-git-send-email-smitha.t@samsung.com>
Message-ID: <5b96b332-71a9-083a-2242-8bdf5554f010@linaro.org>
Date: Sat, 9 Dec 2017 20:48:44 +0200
MIME-Version: 1.0
In-Reply-To: <1512724105-1778-11-git-send-email-smitha.t@samsung.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Smitha,

Thanks for the patches!

On 12/08/2017 11:08 AM, Smitha T Murthy wrote:
> Add v4l2 controls for HEVC encoder
> 
> Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
> Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
> ---
>  drivers/media/v4l2-core/v4l2-ctrls.c | 118 +++++++++++++++++++++++++++++++++++
>  include/uapi/linux/v4l2-controls.h   |  92 ++++++++++++++++++++++++++-
>  2 files changed, 209 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index 4e53a86..3f98318 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -480,6 +480,56 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>  		NULL,
>  	};
>  
> +	static const char * const hevc_profile[] = {
> +		"Main",

You forgot "Main 10" profile.

> +		"Main Still Picture",
> +		NULL,
> +	};
> +	static const char * const hevc_level[] = {
> +		"1",
> +		"2",
> +		"2.1",
> +		"3",
> +		"3.1",
> +		"4",
> +		"4.1",
> +		"5",
> +		"5.1",
> +		"5.2",
> +		"6",
> +		"6.1",
> +		"6.2",
> +		NULL,
> +	};
> +	static const char * const hevc_hierarchial_coding_type[] = {
> +		"B",
> +		"P",
> +		NULL,
> +	};
> +	static const char * const hevc_refresh_type[] = {
> +		"None",
> +		"CRA",
> +		"IDR",
> +		NULL,
> +	};
> +	static const char * const hevc_size_of_length_field[] = {
> +		"0",
> +		"1",
> +		"2",
> +		"4",
> +		NULL,
> +	};
> +	static const char * const hevc_tier_flag[] = {
> +		"Main",
> +		"High",
> +		NULL,
> +	};
> +	static const char * const hevc_loop_filter_mode[] = {
> +		"Disabled",
> +		"Enabled",
> +		"Disabled at slice boundary",
> +		"NULL",
> +	};
>  
>  	switch (id) {
>  	case V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ:
> @@ -575,6 +625,20 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>  		return dv_it_content_type;
>  	case V4L2_CID_DETECT_MD_MODE:
>  		return detect_md_mode;
> +	case V4L2_CID_MPEG_VIDEO_HEVC_PROFILE:
> +		return hevc_profile;
> +	case V4L2_CID_MPEG_VIDEO_HEVC_LEVEL:
> +		return hevc_level;
> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_TYPE:
> +		return hevc_hierarchial_coding_type;
> +	case V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_TYPE:
> +		return hevc_refresh_type;
> +	case V4L2_CID_MPEG_VIDEO_HEVC_SIZE_OF_LENGTH_FIELD:
> +		return hevc_size_of_length_field;
> +	case V4L2_CID_MPEG_VIDEO_HEVC_TIER_FLAG:

Could you drop _FLAG suffix? Looking (briefly) into the spec they not
specify `tier flag` but just `tier`.

> +		return hevc_tier_flag;
> +	case V4L2_CID_MPEG_VIDEO_HEVC_LOOP_FILTER_MODE:
> +		return hevc_loop_filter_mode;
>  
>  	default:
>  		return NULL;
> @@ -776,6 +840,53 @@ const char *v4l2_ctrl_get_name(u32 id)
>  	case V4L2_CID_MPEG_VIDEO_VPX_P_FRAME_QP:		return "VPX P-Frame QP Value";
>  	case V4L2_CID_MPEG_VIDEO_VPX_PROFILE:			return "VPX Profile";
>  
> +	/* HEVC controls */
> +	case V4L2_CID_MPEG_VIDEO_HEVC_I_FRAME_QP:		return "HEVC I-Frame QP Value";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_P_FRAME_QP:		return "HEVC P-Frame QP Value";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_B_FRAME_QP:		return "HEVC B-Frame QP Value";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_MIN_QP:			return "HEVC Minimum QP Value";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_MAX_QP:			return "HEVC Maximum QP Value";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_PROFILE:			return "HEVC Profile";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_LEVEL:			return "HEVC Level";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_TIER_FLAG:		return "HEVC Tier Flag";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_FRAME_RATE_RESOLUTION:	return "HEVC Frame Rate Resolution";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_MAX_PARTITION_DEPTH:	return "HEVC Maximum Coding Unit Depth";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_TYPE:		return "HEVC Refresh Type";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_CONST_INTRA_PRED:		return "HEVC Constant Intra Prediction";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_LOSSLESS_CU:		return "HEVC Lossless Encoding";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_WAVEFRONT:		return "HEVC Wavefront";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_LOOP_FILTER_MODE:		return "HEVC Loop Filter";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_QP:			return "HEVC QP Values";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_TYPE:		return "HEVC Hierarchical Coding Type";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER:	return "HEVC Hierarchical Coding Layer";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L0_QP:	return "HEVC Hierarchical Lay 0 QP";

s/Lay/Layer here and below

> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L1_QP:	return "HEVC Hierarchical Lay 1 QP";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L2_QP:	return "HEVC Hierarchical Lay 2 QP";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L3_QP:	return "HEVC Hierarchical Lay 3 QP";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L4_QP:	return "HEVC Hierarchical Lay 4 QP";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L5_QP:	return "HEVC Hierarchical Lay 5 QP";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L6_QP:	return "HEVC Hierarchical Lay 6 QP";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L0_BR:	return "HEVC Hierarchical Lay 0 Bit Rate";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L1_BR:	return "HEVC Hierarchical Lay 1 Bit Rate";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L2_BR:	return "HEVC Hierarchical Lay 2 Bit Rate";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L3_BR:	return "HEVC Hierarchical Lay 3 Bit Rate";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L4_BR:	return "HEVC Hierarchical Lay 4 Bit Rate";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L5_BR:	return "HEVC Hierarchical Lay 5 Bit Rate";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L6_BR:	return "HEVC Hierarchical Lay 6 Bit Rate";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_GENERAL_PB:		return "HEVC General PB";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_TEMPORAL_ID:		return "HEVC Temporal ID";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_STRONG_SMOOTHING:		return "HEVC Strong Intra Smoothing";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_INTRA_PU_SPLIT:		return "HEVC Intra PU Split";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_TMV_PREDICTION:		return "HEVC TMV Prediction";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_MAX_NUM_MERGE_MV_MINUS1:	return "HEVC Max Number of Candidate MVs";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_WITHOUT_STARTCODE:	return "HEVC ENC Without Startcode";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_PERIOD:		return "HEVC Num of I-Frame b/w 2 IDR";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_LF_BETA_OFFSET_DIV2:	return "HEVC Loop Filter Beta Offset";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_LF_TC_OFFSET_DIV2:	return "HEVC Loop Filter TC Offset";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_SIZE_OF_LENGTH_FIELD:	return "HEVC Size of Length Field";
> +	case V4L2_CID_MPEG_VIDEO_REF_NUMBER_FOR_PFRAMES:	return "Reference Frames for a P-Frame";
> +	case V4L2_CID_MPEG_VIDEO_PREPEND_SPSPPS_TO_IDR:		return "Prepend SPS and PPS to IDR";
> +
>  	/* CAMERA controls */
>  	/* Keep the order of the 'case's the same as in v4l2-controls.h! */
>  	case V4L2_CID_CAMERA_CLASS:		return "Camera Controls";
> @@ -1069,6 +1180,13 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
>  	case V4L2_CID_TUNE_DEEMPHASIS:
>  	case V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_SEL:
>  	case V4L2_CID_DETECT_MD_MODE:
> +	case V4L2_CID_MPEG_VIDEO_HEVC_PROFILE:
> +	case V4L2_CID_MPEG_VIDEO_HEVC_LEVEL:
> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_TYPE:
> +	case V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_TYPE:
> +	case V4L2_CID_MPEG_VIDEO_HEVC_SIZE_OF_LENGTH_FIELD:
> +	case V4L2_CID_MPEG_VIDEO_HEVC_TIER_FLAG:
> +	case V4L2_CID_MPEG_VIDEO_HEVC_LOOP_FILTER_MODE:
>  		*type = V4L2_CTRL_TYPE_MENU;
>  		break;
>  	case V4L2_CID_LINK_FREQ:
> diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> index 31bfc68..a4b8489 100644
> --- a/include/uapi/linux/v4l2-controls.h
> +++ b/include/uapi/linux/v4l2-controls.h
> @@ -588,6 +588,97 @@ enum v4l2_vp8_golden_frame_sel {
>  #define V4L2_CID_MPEG_VIDEO_VPX_P_FRAME_QP		(V4L2_CID_MPEG_BASE+510)
>  #define V4L2_CID_MPEG_VIDEO_VPX_PROFILE			(V4L2_CID_MPEG_BASE+511)
>  
> +/* CIDs for HEVC encoding. Number gaps are for compatibility */
> +
> +#define V4L2_CID_MPEG_VIDEO_HEVC_MIN_QP		(V4L2_CID_MPEG_BASE + 512)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_MAX_QP		(V4L2_CID_MPEG_BASE + 513)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_I_FRAME_QP	(V4L2_CID_MPEG_BASE + 514)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_P_FRAME_QP	(V4L2_CID_MPEG_BASE + 515)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_B_FRAME_QP	(V4L2_CID_MPEG_BASE + 516)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_HIER_QP	(V4L2_CID_MPEG_BASE + 517)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_TYPE (V4L2_CID_MPEG_BASE + 518)
> +enum v4l2_mpeg_video_hevc_hier_coding_type {
> +	V4L2_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_B	= 0,
> +	V4L2_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_P	= 1,
> +};
> +#define V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER	(V4L2_CID_MPEG_BASE + 519)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L0_QP	(V4L2_CID_MPEG_BASE + 520)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L1_QP	(V4L2_CID_MPEG_BASE + 521)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L2_QP	(V4L2_CID_MPEG_BASE + 522)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L3_QP	(V4L2_CID_MPEG_BASE + 523)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L4_QP	(V4L2_CID_MPEG_BASE + 524)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L5_QP	(V4L2_CID_MPEG_BASE + 525)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L6_QP	(V4L2_CID_MPEG_BASE + 526)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_PROFILE	(V4L2_CID_MPEG_BASE + 527)
> +enum v4l2_mpeg_video_hevc_profile {
> +	V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN = 0,

you forgot V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN10 profile.

> +	V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN_STILL_PICTURE = 1,
> +};

<snip>

-- 
regards,
Stan
