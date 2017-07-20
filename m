Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:37112 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753631AbdGTNNZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 09:13:25 -0400
Subject: Re: [Patch v5 10/12] [media] v4l2: Add v4l2 control IDs for HEVC
 encoder
To: Smitha T Murthy <smitha.t@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1497849055-26583-1-git-send-email-smitha.t@samsung.com>
 <CGME20170619052516epcas5p349b080cc6c242444d2db1f3c0e1c6f68@epcas5p3.samsung.com>
 <1497849055-26583-11-git-send-email-smitha.t@samsung.com>
Cc: kyungmin.park@samsung.com, kamil@wypas.org, jtp.park@samsung.com,
        a.hajda@samsung.com, mchehab@kernel.org, pankaj.dubey@samsung.com,
        krzk@kernel.org, m.szyprowski@samsung.com, s.nawrocki@samsung.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <3ed971c4-8fd9-a66e-5b88-4f51ffd17cae@xs4all.nl>
Date: Thu, 20 Jul 2017 15:13:19 +0200
MIME-Version: 1.0
In-Reply-To: <1497849055-26583-11-git-send-email-smitha.t@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 19/06/17 07:10, Smitha T Murthy wrote:
> Add v4l2 controls for HEVC encoder
> 
> Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
> Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
> ---
>  drivers/media/v4l2-core/v4l2-ctrls.c | 103 +++++++++++++++++++++++++++++++++++
>  include/uapi/linux/v4l2-controls.h   |  84 ++++++++++++++++++++++++++++
>  2 files changed, 187 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index ec42872..6a7e732 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -479,6 +479,51 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>  		NULL,
>  	};
>  
> +	static const char * const hevc_profile[] = {
> +		"Main",
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
> +
>  
>  	switch (id) {
>  	case V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ:
> @@ -574,6 +619,18 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
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
> +		return hevc_tier_flag;
>  
>  	default:
>  		return NULL;
> @@ -775,6 +832,46 @@ const char *v4l2_ctrl_get_name(u32 id)
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
> +	case V4L2_CID_MPEG_VIDEO_HEVC_TIER_FLAG:		return "HEVC Tier_flag";

"HEVC Tier Flag"

> +	case V4L2_CID_MPEG_VIDEO_HEVC_FRAME_RATE_RESOLUTION:	return "HEVC Frame Rate Resolution";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_MAX_PARTITION_DEPTH:	return "HEVC Maximum Coding Unit Depth";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_TYPE:		return "HEVC Refresh Type";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_CONST_INTRA_PRED:		return "HEVC Constant Intra Prediction";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_LOSSLESS_CU:		return "HEVC Lossless Encoding";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_WAVEFRONT:		return "HEVC Wavefront";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_LF:			return "HEVC Loop Filter";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_LF_SLICE_BOUNDARY:	return "HEVC LF Across Slice Boundary";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_QP:			return "HEVC QP Values";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_TYPE:		return "HEVC Hierarchical Coding Type";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER:	return "HEVC Hierarchical Coding Layer";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER_QP:	return "HEVC Hierarchical Layer QP";
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
> +	case V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_PERIOD:		return "HEVC Num of I Frame b/w 2 IDR";

s/I Frame/I-Frame/

> +	case V4L2_CID_MPEG_VIDEO_HEVC_LF_BETA_OFFSET_DIV2:	return "HEVC Loop Filter Beta Offset";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_LF_TC_OFFSET_DIV2:	return "HEVC Loop Filter TC Offset";
> +	case V4L2_CID_MPEG_VIDEO_HEVC_SIZE_OF_LENGTH_FIELD:	return "HEVC Size of Length Field";
> +

It is my understanding that all these V4L2_CID_MPEG_VIDEO_HEVC_ controls represent HEVC
parameters as defined by the HEVC standard, right? And not specific to your codec.

I'm pretty sure that's the case, I'm just double-checking.

Regards,

	Hans

>  	/* CAMERA controls */
>  	/* Keep the order of the 'case's the same as in v4l2-controls.h! */
>  	case V4L2_CID_CAMERA_CLASS:		return "Camera Controls";
> @@ -1067,6 +1164,12 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
>  	case V4L2_CID_TUNE_DEEMPHASIS:
>  	case V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_SEL:
>  	case V4L2_CID_DETECT_MD_MODE:
> +	case V4L2_CID_MPEG_VIDEO_HEVC_PROFILE:
> +	case V4L2_CID_MPEG_VIDEO_HEVC_LEVEL:
> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_TYPE:
> +	case V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_TYPE:
> +	case V4L2_CID_MPEG_VIDEO_HEVC_SIZE_OF_LENGTH_FIELD:
> +	case V4L2_CID_MPEG_VIDEO_HEVC_TIER_FLAG:
>  		*type = V4L2_CTRL_TYPE_MENU;
>  		break;
>  	case V4L2_CID_LINK_FREQ:
> diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> index 0d2e1e0..9c32a55 100644
> --- a/include/uapi/linux/v4l2-controls.h
> +++ b/include/uapi/linux/v4l2-controls.h
> @@ -579,6 +579,85 @@ enum v4l2_vp8_golden_frame_sel {
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
> +#define V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER_QP	(V4L2_CID_MPEG_BASE + 520)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_PROFILE	(V4L2_CID_MPEG_BASE + 521)
> +enum v4l2_mpeg_video_hevc_profile {
> +	V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN = 0,
> +	V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN_STILL_PICTURE = 1,
> +};
> +#define V4L2_CID_MPEG_VIDEO_HEVC_LEVEL		(V4L2_CID_MPEG_BASE + 522)
> +enum v4l2_mpeg_video_hevc_level {
> +	V4L2_MPEG_VIDEO_HEVC_LEVEL_1	= 0,
> +	V4L2_MPEG_VIDEO_HEVC_LEVEL_2	= 1,
> +	V4L2_MPEG_VIDEO_HEVC_LEVEL_2_1	= 2,
> +	V4L2_MPEG_VIDEO_HEVC_LEVEL_3	= 3,
> +	V4L2_MPEG_VIDEO_HEVC_LEVEL_3_1	= 4,
> +	V4L2_MPEG_VIDEO_HEVC_LEVEL_4	= 5,
> +	V4L2_MPEG_VIDEO_HEVC_LEVEL_4_1	= 6,
> +	V4L2_MPEG_VIDEO_HEVC_LEVEL_5	= 7,
> +	V4L2_MPEG_VIDEO_HEVC_LEVEL_5_1	= 8,
> +	V4L2_MPEG_VIDEO_HEVC_LEVEL_5_2	= 9,
> +	V4L2_MPEG_VIDEO_HEVC_LEVEL_6	= 10,
> +	V4L2_MPEG_VIDEO_HEVC_LEVEL_6_1	= 11,
> +	V4L2_MPEG_VIDEO_HEVC_LEVEL_6_2	= 12,
> +};
> +#define V4L2_CID_MPEG_VIDEO_HEVC_FRAME_RATE_RESOLUTION	(V4L2_CID_MPEG_BASE + 523)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_TIER_FLAG		(V4L2_CID_MPEG_BASE + 524)
> +enum v4l2_mpeg_video_hevc_tier_flag {
> +	V4L2_MPEG_VIDEO_HEVC_TIER_MAIN = 0,
> +	V4L2_MPEG_VIDEO_HEVC_TIER_HIGH = 1,
> +};
> +#define V4L2_CID_MPEG_VIDEO_HEVC_MAX_PARTITION_DEPTH	(V4L2_CID_MPEG_BASE + 525)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_LF			(V4L2_CID_MPEG_BASE + 526)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_LF_SLICE_BOUNDARY	(V4L2_CID_MPEG_BASE + 527)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_LF_BETA_OFFSET_DIV2	(V4L2_CID_MPEG_BASE + 528)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_LF_TC_OFFSET_DIV2	(V4L2_CID_MPEG_BASE + 529)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_TYPE		(V4L2_CID_MPEG_BASE + 530)
> +enum v4l2_cid_mpeg_video_hevc_refresh_type {
> +	V4L2_MPEG_VIDEO_HEVC_REFRESH_NONE		= 0,
> +	V4L2_MPEG_VIDEO_HEVC_REFRESH_CRA		= 1,
> +	V4L2_MPEG_VIDEO_HEVC_REFRESH_IDR		= 2,
> +};
> +#define V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_PERIOD		(V4L2_CID_MPEG_BASE + 531)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_LOSSLESS_CU		(V4L2_CID_MPEG_BASE + 532)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_CONST_INTRA_PRED	(V4L2_CID_MPEG_BASE + 533)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_WAVEFRONT		(V4L2_CID_MPEG_BASE + 534)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_GENERAL_PB		(V4L2_CID_MPEG_BASE + 535)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_TEMPORAL_ID		(V4L2_CID_MPEG_BASE + 536)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_STRONG_SMOOTHING	(V4L2_CID_MPEG_BASE + 537)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_MAX_NUM_MERGE_MV_MINUS1	(V4L2_CID_MPEG_BASE + 538)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_INTRA_PU_SPLIT		(V4L2_CID_MPEG_BASE + 539)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_TMV_PREDICTION		(V4L2_CID_MPEG_BASE + 540)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_WITHOUT_STARTCODE	(V4L2_CID_MPEG_BASE + 541)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_SIZE_OF_LENGTH_FIELD	(V4L2_CID_MPEG_BASE + 542)
> +enum v4l2_cid_mpeg_video_hevc_size_of_length_field {
> +	V4L2_MPEG_VIDEO_HEVC_SIZE_0		= 0,
> +	V4L2_MPEG_VIDEO_HEVC_SIZE_1		= 1,
> +	V4L2_MPEG_VIDEO_HEVC_SIZE_2		= 2,
> +	V4L2_MPEG_VIDEO_HEVC_SIZE_4		= 3,
> +};
> +#define V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L0_BR	(V4L2_CID_MPEG_BASE + 543)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L1_BR	(V4L2_CID_MPEG_BASE + 544)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L2_BR	(V4L2_CID_MPEG_BASE + 545)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L3_BR	(V4L2_CID_MPEG_BASE + 546)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L4_BR	(V4L2_CID_MPEG_BASE + 547)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L5_BR	(V4L2_CID_MPEG_BASE + 548)
> +#define V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L6_BR	(V4L2_CID_MPEG_BASE + 549)
> +
>  /*  MPEG-class control IDs specific to the CX2341x driver as defined by V4L2 */
>  #define V4L2_CID_MPEG_CX2341X_BASE 				(V4L2_CTRL_CLASS_MPEG | 0x1000)
>  #define V4L2_CID_MPEG_CX2341X_VIDEO_SPATIAL_FILTER_MODE 	(V4L2_CID_MPEG_CX2341X_BASE+0)
> @@ -647,6 +726,11 @@ enum v4l2_mpeg_mfc51_video_force_frame_type {
>  #define V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_STATIC		(V4L2_CID_MPEG_MFC51_BASE+53)
>  #define V4L2_CID_MPEG_MFC51_VIDEO_H264_NUM_REF_PIC_FOR_P		(V4L2_CID_MPEG_MFC51_BASE+54)
>  
> +/*  MPEG-class control IDs specific to the Samsung MFC 10.10 driver as defined by V4L2 */
> +#define V4L2_CID_MPEG_MFC10_BASE				(V4L2_CTRL_CLASS_MPEG | 0x1200)
> +
> +#define V4L2_CID_MPEG_MFC10_VIDEO_HEVC_REF_NUMBER_FOR_PFRAMES		(V4L2_CID_MPEG_MFC10_BASE+0)
> +#define V4L2_CID_MPEG_MFC10_VIDEO_HEVC_PREPEND_SPSPPS_TO_IDR		(V4L2_CID_MPEG_MFC10_BASE+1)
>  
>  /*  Camera class control IDs */
>  
> 
