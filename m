Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:32693 "EHLO
        epoutp01.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752295AbdCaI6B (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Mar 2017 04:58:01 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by epoutp01.samsung.com (KnoxPortal) with ESMTP id 20170331085759epoutp0118f6acaa0e5954c5097c568d8cc810f0~w675DQGub0588305883epoutp01O
        for <linux-media@vger.kernel.org>; Fri, 31 Mar 2017 08:57:59 +0000 (GMT)
Subject: Re: [Patch v2 10/11] s5p-mfc: Add support for HEVC encoder
From: Smitha T Murthy <smitha.t@samsung.com>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        kamil@wypas.org, jtp.park@samsung.com, mchehab@kernel.org,
        pankaj.dubey@samsung.com, krzk@kernel.org,
        m.szyprowski@samsung.com, s.nawrocki@samsung.com
In-Reply-To: <1490676344.12183.32.camel@smitha-fedora>
Date: Fri, 31 Mar 2017 14:30:15 +0530
Message-ID: <1490950815.24095.14.camel@smitha-fedora>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
References: <1488532036-13044-1-git-send-email-smitha.t@samsung.com>
        <CGME20170303090513epcas1p261f4564fd9e093d8f8b03269a154a933@epcas1p2.samsung.com>
        <1488532036-13044-11-git-send-email-smitha.t@samsung.com>
        <83c45c74-7000-3787-f041-69a4b108c864@samsung.com>
        <1489491682.27807.143.camel@smitha-fedora>
        <6e3c1cd7-f528-bdc7-35c7-ee355e4b8a3b@samsung.com>
        <1490676344.12183.32.camel@smitha-fedora>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2017-03-28 at 10:15 +0530, Smitha T Murthy wrote:
> On Mon, 2017-03-27 at 14:09 +0200, Andrzej Hajda wrote:
> > Hi Smitha,
> > 
> > Sorry for late reply, it seems I have missed this email.
> > 
> > 
> > On 14.03.2017 12:41, Smitha T Murthy wrote:
> > > On Tue, 2017-03-07 at 12:33 +0100, Andrzej Hajda wrote: 
> > >> On 03.03.2017 10:07, Smitha T Murthy wrote:
> > >>> Add HEVC encoder support and necessary registers, V4L2 CIDs,
> > >>> and hevc encoder parameters
> > >>>
> > >>> Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
> > >>> ---
> > >>>  drivers/media/platform/s5p-mfc/regs-mfc-v10.h   |   28 +-
> > >>>  drivers/media/platform/s5p-mfc/s5p_mfc.c        |    1 +
> > >>>  drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c |    3 +
> > >>>  drivers/media/platform/s5p-mfc/s5p_mfc_common.h |   55 ++-
> > >>>  drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |  595 +++++++++++++++++++++++
> > >>>  drivers/media/platform/s5p-mfc/s5p_mfc_opr.h    |    8 +
> > >>>  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |  200 ++++++++
> > >>>  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h |    8 +
> > >>>  8 files changed, 896 insertions(+), 2 deletions(-)
> > >>>
> > >>> diff --git a/drivers/media/platform/s5p-mfc/regs-mfc-v10.h b/drivers/media/platform/s5p-mfc/regs-mfc-v10.h
> > >>> index 846dcf5..caf02ff 100644
> > >>> --- a/drivers/media/platform/s5p-mfc/regs-mfc-v10.h
> > >>> +++ b/drivers/media/platform/s5p-mfc/regs-mfc-v10.h
> > >>> @@ -20,13 +20,35 @@
> > >>>  #define S5P_FIMV_MFC_STATE_V10				0x7124
> > >>>  #define S5P_FIMV_D_STATIC_BUFFER_ADDR_V10		0xF570
> > >>>  #define S5P_FIMV_D_STATIC_BUFFER_SIZE_V10		0xF574
> > >>> +#define S5P_FIMV_E_NUM_T_LAYER_V10			0xFBAC
> > >>> +#define S5P_FIMV_E_HIERARCHICAL_QP_LAYER0_V10		0xFBB0
> > >>> +#define S5P_FIMV_E_HIERARCHICAL_QP_LAYER1_V10		0xFBB4
> > >>> +#define S5P_FIMV_E_HIERARCHICAL_QP_LAYER2_V10		0xFBB8
> > >>> +#define S5P_FIMV_E_HIERARCHICAL_QP_LAYER3_V10		0xFBBC
> > >>> +#define S5P_FIMV_E_HIERARCHICAL_QP_LAYER4_V10		0xFBC0
> > >>> +#define S5P_FIMV_E_HIERARCHICAL_QP_LAYER5_V10		0xFBC4
> > >>> +#define S5P_FIMV_E_HIERARCHICAL_QP_LAYER6_V10		0xFBC8
> > >>> +#define S5P_FIMV_E_HIERARCHICAL_BIT_RATE_LAYER0_V10	0xFD18
> > >>> +#define S5P_FIMV_E_HIERARCHICAL_BIT_RATE_LAYER1_V10	0xFD1C
> > >>> +#define S5P_FIMV_E_HIERARCHICAL_BIT_RATE_LAYER2_V10	0xFD20
> > >>> +#define S5P_FIMV_E_HIERARCHICAL_BIT_RATE_LAYER3_V10	0xFD24
> > >>> +#define S5P_FIMV_E_HIERARCHICAL_BIT_RATE_LAYER4_V10	0xFD28
> > >>> +#define S5P_FIMV_E_HIERARCHICAL_BIT_RATE_LAYER5_V10	0xFD2C
> > >>> +#define S5P_FIMV_E_HIERARCHICAL_BIT_RATE_LAYER6_V10	0xFD30
> > >>> +#define S5P_FIMV_E_HEVC_OPTIONS_V10			0xFDD4
> > >>> +#define S5P_FIMV_E_HEVC_REFRESH_PERIOD_V10		0xFDD8
> > >>> +#define S5P_FIMV_E_HEVC_CHROMA_QP_OFFSET_V10		0xFDDC
> > >>> +#define S5P_FIMV_E_HEVC_LF_BETA_OFFSET_DIV2_V10		0xFDE0
> > >>> +#define S5P_FIMV_E_HEVC_LF_TC_OFFSET_DIV2_V10		0xFDE4
> > >>> +#define S5P_FIMV_E_HEVC_NAL_CONTROL_V10			0xFDE8
> > >>>  
> > >>>  /* MFCv10 Context buffer sizes */
> > >>>  #define MFC_CTX_BUF_SIZE_V10		(30 * SZ_1K)	/* 30KB */
> > >>>  #define MFC_H264_DEC_CTX_BUF_SIZE_V10	(2 * SZ_1M)	/* 2MB */
> > >>>  #define MFC_OTHER_DEC_CTX_BUF_SIZE_V10	(20 * SZ_1K)	/* 20KB */
> > >>>  #define MFC_H264_ENC_CTX_BUF_SIZE_V10	(100 * SZ_1K)	/* 100KB */
> > >>> -#define MFC_OTHER_ENC_CTX_BUF_SIZE_V10	(15 * SZ_1K)	/* 15KB */
> > >>> +#define MFC_HEVC_ENC_CTX_BUF_SIZE_V10	(30 * SZ_1K)	/* 30KB */
> > >>> +#define MFC_OTHER_ENC_CTX_BUF_SIZE_V10  (15 * SZ_1K)	/* 15KB */
> > >>>  
> > >>>  /* MFCv10 variant defines */
> > >>>  #define MAX_FW_SIZE_V10		(SZ_1M)		/* 1MB */
> > >>> @@ -58,5 +80,9 @@
> > >>>  #define ENC_V100_VP8_ME_SIZE(x, y) \
> > >>>  	ENC_V100_BASE_SIZE(x, y)
> > >>>  
> > >>> +#define ENC_V100_HEVC_ME_SIZE(x, y)	\
> > >>> +	(((x + 3) * (y + 3) * 32)	\
> > >>> +	 + ((y * 128) + 1280) * DIV_ROUND_UP(x, 4))
> > >>> +
> > >>>  #endif /*_REGS_MFC_V10_H*/
> > >>>  
> > >>> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> > >>> index b014038..b01c556 100644
> > >>> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> > >>> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> > >>> @@ -1549,6 +1549,7 @@ static int s5p_mfc_resume(struct device *dev)
> > >>>  	.h264_dec_ctx   = MFC_H264_DEC_CTX_BUF_SIZE_V10,
> > >>>  	.other_dec_ctx  = MFC_OTHER_DEC_CTX_BUF_SIZE_V10,
> > >>>  	.h264_enc_ctx   = MFC_H264_ENC_CTX_BUF_SIZE_V10,
> > >>> +	.hevc_enc_ctx   = MFC_HEVC_ENC_CTX_BUF_SIZE_V10,
> > >>>  	.other_enc_ctx  = MFC_OTHER_ENC_CTX_BUF_SIZE_V10,
> > >>>  };
> > >>>  
> > >>> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c
> > >>> index 102b47e..7521fce 100644
> > >>> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c
> > >>> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c
> > >>> @@ -122,6 +122,9 @@ static int s5p_mfc_open_inst_cmd_v6(struct s5p_mfc_ctx *ctx)
> > >>>  	case S5P_MFC_CODEC_VP8_ENC:
> > >>>  		codec_type = S5P_FIMV_CODEC_VP8_ENC_V7;
> > >>>  		break;
> > >>> +	case S5P_MFC_CODEC_HEVC_ENC:
> > >>> +		codec_type = S5P_FIMV_CODEC_HEVC_ENC;
> > >>> +		break;
> > >>>  	default:
> > >>>  		codec_type = S5P_FIMV_CODEC_NONE_V6;
> > >>>  	}
> > >>> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> > >>> index e720ce6..c55fa6c 100644
> > >>> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> > >>> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> > >>> @@ -68,7 +68,7 @@ static inline dma_addr_t s5p_mfc_mem_cookie(void *a, void *b)
> > >>>  #define MFC_ENC_CAP_PLANE_COUNT	1
> > >>>  #define MFC_ENC_OUT_PLANE_COUNT	2
> > >>>  #define STUFF_BYTE		4
> > >>> -#define MFC_MAX_CTRLS		77
> > >>> +#define MFC_MAX_CTRLS		128
> > >>>  
> > >>>  #define S5P_MFC_CODEC_NONE		-1
> > >>>  #define S5P_MFC_CODEC_H264_DEC		0
> > >>> @@ -87,6 +87,7 @@ static inline dma_addr_t s5p_mfc_mem_cookie(void *a, void *b)
> > >>>  #define S5P_MFC_CODEC_MPEG4_ENC		22
> > >>>  #define S5P_MFC_CODEC_H263_ENC		23
> > >>>  #define S5P_MFC_CODEC_VP8_ENC		24
> > >>> +#define S5P_MFC_CODEC_HEVC_ENC		26
> > >>>  
> > >>>  #define S5P_MFC_R2H_CMD_EMPTY			0
> > >>>  #define S5P_MFC_R2H_CMD_SYS_INIT_RET		1
> > >>> @@ -222,6 +223,7 @@ struct s5p_mfc_buf_size_v6 {
> > >>>  	unsigned int h264_dec_ctx;
> > >>>  	unsigned int other_dec_ctx;
> > >>>  	unsigned int h264_enc_ctx;
> > >>> +	unsigned int hevc_enc_ctx;
> > >>>  	unsigned int other_enc_ctx;
> > >>>  };
> > >>>  
> > >>> @@ -440,6 +442,56 @@ struct s5p_mfc_vp8_enc_params {
> > >>>  	u8 profile;
> > >>>  };
> > >>>  
> > >>> +struct s5p_mfc_hevc_enc_params {
> > >>> +	u8 level;
> > >>> +	u8 tier_flag;
> > >>> +	/* HEVC Only */
> > >>> +	u32 rc_framerate;
> > >>> +	u8 rc_min_qp;
> > >>> +	u8 rc_max_qp;
> > >>> +	u8 rc_lcu_dark;
> > >>> +	u8 rc_lcu_smooth;
> > >>> +	u8 rc_lcu_static;
> > >>> +	u8 rc_lcu_activity;
> > >>> +	u8 rc_frame_qp;
> > >>> +	u8 rc_p_frame_qp;
> > >>> +	u8 rc_b_frame_qp;
> > >>> +	u8 max_partition_depth;
> > >>> +	u8 num_refs_for_p;
> > >>> +	u8 refreshtype;
> > >>> +	u16 refreshperiod;
> > >>> +	s32 lf_beta_offset_div2;
> > >>> +	s32 lf_tc_offset_div2;
> > >>> +	u8 loopfilter_disable;
> > >>> +	u8 loopfilter_across;
> > >>> +	u8 nal_control_length_filed;
> > >>> +	u8 nal_control_user_ref;
> > >>> +	u8 nal_control_store_ref;
> > >>> +	u8 const_intra_period_enable;
> > >>> +	u8 lossless_cu_enable;
> > >>> +	u8 wavefront_enable;
> > >>> +	u8 enable_ltr;
> > >>> +	u8 hier_qp_enable;
> > >>> +	enum v4l2_mpeg_video_hevc_hier_coding_type hier_qp_type;
> > >>> +	u8 hier_ref_type;
> > >>> +	u8 num_hier_layer;
> > >>> +	u8 hier_qp_layer[7];
> > >>> +	u32 hier_bit_layer[7];
> > >>> +	u8 sign_data_hiding;
> > >>> +	u8 general_pb_enable;
> > >>> +	u8 temporal_id_enable;
> > >>> +	u8 strong_intra_smooth;
> > >>> +	u8 intra_pu_split_disable;
> > >>> +	u8 tmv_prediction_disable;
> > >>> +	u8 max_num_merge_mv;
> > >>> +	u8 eco_mode_enable;
> > >>> +	u8 encoding_nostartcode_enable;
> > >>> +	u8 size_of_length_field;
> > >>> +	u8 use_ref;
> > >>> +	u8 store_ref;
> > >>> +	u8 prepend_sps_pps_to_idr;
> > >>> +};
> > >>> +
> > >>>  /**
> > >>>   * struct s5p_mfc_enc_params - general encoding parameters
> > >>>   */
> > >>> @@ -477,6 +529,7 @@ struct s5p_mfc_enc_params {
> > >>>  		struct s5p_mfc_h264_enc_params h264;
> > >>>  		struct s5p_mfc_mpeg4_enc_params mpeg4;
> > >>>  		struct s5p_mfc_vp8_enc_params vp8;
> > >>> +		struct s5p_mfc_hevc_enc_params hevc;
> > >>>  	} codec;
> > >>>  
> > >>>  };
> > >>> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> > >>> index 6623f79..4a6fbee3 100644
> > >>> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> > >>> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> > >>> @@ -104,6 +104,14 @@
> > >>>  		.num_planes	= 1,
> > >>>  		.versions	= MFC_V7_BIT | MFC_V8_BIT | MFC_V10_BIT,
> > >>>  	},
> > >>> +	{
> > >>> +		.name		= "HEVC Encoded Stream",
> > >>> +		.fourcc		= V4L2_PIX_FMT_HEVC,
> > >>> +		.codec_mode	= S5P_FIMV_CODEC_HEVC_ENC,
> > >>> +		.type		= MFC_FMT_ENC,
> > >>> +		.num_planes	= 1,
> > >>> +		.versions	= MFC_V10_BIT,
> > >>> +	},
> > >>>  };
> > >>>  
> > >>>  #define NUM_FORMATS ARRAY_SIZE(formats)
> > >>> @@ -698,6 +706,447 @@
> > >>>  		.default_value = 0,
> > >>>  	},
> > >>>  	{
> > >>> +		.id = V4L2_CID_MPEG_VIDEO_HEVC_I_FRAME_QP,
> > >>> +		.type = V4L2_CTRL_TYPE_INTEGER,
> > >>> +		.name = "HEVC Frame QP value",
> > >>> +		.minimum = 0,
> > >>> +		.maximum = 51,
> > >>> +		.step = 1,
> > >>> +		.default_value = 0,
> > >>> +	},
> > >>> +	{
> > >>> +		.id = V4L2_CID_MPEG_VIDEO_HEVC_P_FRAME_QP,
> > >>> +		.type = V4L2_CTRL_TYPE_INTEGER,
> > >>> +		.name = "HEVC P frame QP value",
> > >>> +		.minimum = 0,
> > >>> +		.maximum = 51,
> > >>> +		.step = 1,
> > >>> +		.default_value = 0,
> > >>> +	},
> > >>> +	{
> > >>> +		.id = V4L2_CID_MPEG_VIDEO_HEVC_B_FRAME_QP,
> > >>> +		.type = V4L2_CTRL_TYPE_INTEGER,
> > >>> +		.name = "HEVC B frame QP value",
> > >>> +		.minimum = 0,
> > >>> +		.maximum = 51,
> > >>> +		.step = 1,
> > >>> +		.default_value = 0,
> > >>> +	},
> > >>> +	{
> > >>> +		.id = V4L2_CID_MPEG_VIDEO_HEVC_MIN_QP,
> > >>> +		.type = V4L2_CTRL_TYPE_INTEGER,
> > >>> +		.name = "HEVC Minimum QP value",
> > >>> +		.minimum = 0,
> > >>> +		.maximum = 51,
> > >>> +		.step = 1,
> > >>> +		.default_value = 0,
> > >>> +	},
> > >>> +	{
> > >>> +		.id = V4L2_CID_MPEG_VIDEO_HEVC_MAX_QP,
> > >>> +		.type = V4L2_CTRL_TYPE_INTEGER,
> > >>> +		.name = "HEVC Maximum QP value",
> > >>> +		.minimum = 0,
> > >>> +		.maximum = 51,
> > >>> +		.step = 1,
> > >>> +		.default_value = 0,
> > >>> +	},
> > >>> +	{
> > >>> +		.id = V4L2_CID_MPEG_VIDEO_HEVC_ADAPTIVE_RC_DARK,
> > >>> +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> > >>> +		.name = "HEVC dark region adaptive",
> > >>> +		.minimum = 0,
> > >>> +		.maximum = 1,
> > >>> +		.step = 1,
> > >>> +		.default_value = 0,
> > >>> +	},
> > >>> +	{
> > >>> +		.id = V4L2_CID_MPEG_VIDEO_HEVC_ADAPTIVE_RC_SMOOTH,
> > >>> +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> > >>> +		.name = "HEVC smooth region adaptive",
> > >>> +		.minimum = 0,
> > >>> +		.maximum = 1,
> > >>> +		.step = 1,
> > >>> +		.default_value = 0,
> > >>> +	},
> > >>> +	{
> > >>> +		.id = V4L2_CID_MPEG_VIDEO_HEVC_ADAPTIVE_RC_STATIC,
> > >>> +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> > >>> +		.name = "HEVC static region adaptive",
> > >>> +		.minimum = 0,
> > >>> +		.maximum = 1,
> > >>> +		.step = 1,
> > >>> +		.default_value = 0,
> > >>> +	},
> > >>> +	{
> > >>> +		.id = V4L2_CID_MPEG_VIDEO_HEVC_ADAPTIVE_RC_ACTIVITY,
> > >>> +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> > >>> +		.name = "HEVC activity adaptive",
> > >>> +		.minimum = 0,
> > >>> +		.maximum = 1,
> > >>> +		.step = 1,
> > >>> +		.default_value = 0,
> > >>> +	},
> > >>> +	{
> > >>> +		.id = V4L2_CID_MPEG_VIDEO_HEVC_PROFILE,
> > >>> +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> > >>> +		.name = "HEVC Profile",
> > >>> +		.minimum = 0,
> > >>> +		.maximum = 0,
> > >> Why bool? There should be multiple profiles I suppose.
> > > Yes it has support for 2 profiles: 0 Main Profile and 1 Main still
> > > picture profile. I will change the type and correct the values. 
> > >>> +		.step = 1,
> > >>> +		.default_value = 0,
> > >>> +	},
> > >>> +	{
> > >>> +		.id = V4L2_CID_MPEG_VIDEO_HEVC_LEVEL,
> > >>> +		.type = V4L2_CTRL_TYPE_INTEGER,
> > >>> +		.name = "HEVC level",
> > >>> +		.minimum = 10,
> > >>> +		.maximum = 62,
> > >>> +		.step = 1,
> > >>> +		.default_value = 10,
> > >> I think it should be done rather as menu, as in case of mpeg_h264_level,
> > >> mpeg_mpeg4_level, etc, also look at h264_profile and similar [1].
> > >>
> > >> [1]:
> > >> http://lxr.free-electrons.com/source/drivers/media/v4l2-core/v4l2-ctrls.c#L323
> > >>
> > > Ok I will make the level CID as a menu. 
> > >>> +	},
> > >>> +	{
> > >>> +		.id = V4L2_CID_MPEG_VIDEO_HEVC_TIER_FLAG,
> > >>> +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> > >>> +		.name = "HEVC tier_flag default is Main",
> > >>> +		.minimum = 0,
> > >>> +		.maximum = 1,
> > >>> +		.step = 1,
> > >>> +		.default_value = 0,
> > >>> +	},
> > >>> +	{
> > >>> +		.id = V4L2_CID_MPEG_VIDEO_HEVC_RC_FRAME_RATE,
> > >>> +		.type = V4L2_CTRL_TYPE_INTEGER,
> > >>> +		.name = "HEVC Frame rate",
> > >>> +		.minimum = 1,
> > >>> +		.maximum = (1 << 16) - 1,
> > >> Hmm, wikipedia says "The maximum frame rate supported by HEVC is 300
> > >> frames per second (fps)", does the HW supports more, I suppose for
> > >> non-runtime encoder it does not matter, anyway it looks odd :)
> > > Basically RC Frame rate indicates the Frame Rate Resolution which
> > > specifies the number of evenly spaced subintervals, called ticks, within
> > > one modulo time. One modulo time represents the fixed interval of one
> > > second. This is a 16bit unsigned integer and has a maximum value upto
> > > 0xffff. 
> > 
> > OK, so it should be named accordingly, macro should also have better
> > name. Now both suggests something different. Btw the definition you have
> > provided fits exactly to vop_time_increment_resolution
> > field of h264 timestamp[1].
> > 
> > [1]:
> > https://android.googlesource.com/platform/external/libavc/+/master/encoder/ih264e_time_stamp.h#90
> > 
> > 
> Yes vop_time_increment_resolution has the same meaning as this CID. I
> followed the same naming as given in the MFC user manual, will change
> the name as V4L2_CID_MPEG_VIDEO_HEVC_FRAME_RATE_RESOLUTION
> > >>> +		.step = 1,
> > >>> +		.default_value = 1,
> > >>> +	},
> > >>> +	{
> > >>> +		.id = V4L2_CID_MPEG_VIDEO_HEVC_MAX_PARTITION_DEPTH,
> > >>> +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> > >>> +		.name = "HEVC Maximum coding unit depth",
> > >>> +		.minimum = 0,
> > >>> +		.maximum = 1,
> > >>> +		.step = 1,
> > >> Max depth should not be bool.
> > >>
> > > Yes I will correct it.
> > >
> > >>> +		.default_value = 0,
> > >>> +	},
> > >>> +	{
> > >>> +		.id = V4L2_CID_MPEG_VIDEO_HEVC_REF_NUMBER_FOR_PFRAMES,
> > >>> +		.type = V4L2_CTRL_TYPE_INTEGER,
> > >>> +		.name = "HEVC Number of reference picture",
> > >>> +		.minimum = 1,
> > >>> +		.maximum = 2,
> > >>> +		.step = 1,
> > >>> +		.default_value = 1,
> > >>> +	},
> > >>> +	{
> > >>> +		.id = V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_TYPE,
> > >>> +		.type = V4L2_CTRL_TYPE_INTEGER,
> > >>> +		.name = "HEVC Number of reference picture",
> > >> Incorrect name. ID suggest it should be menu and enums.
> > > I will correct this CID. 
> > >>> +		.minimum = 0,
> > >>> +		.maximum = 2,
> > >>> +		.step = 1,
> > >>> +		.default_value = 0,
> > >>> +	},
> > >>> +	{
> > >>> +		.id = V4L2_CID_MPEG_VIDEO_HEVC_CONST_INTRA_PRED_ENABLE,
> > >>> +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> > >>> +		.name = "HEVC refresh type",
> > >>> +		.minimum = 0,
> > >>> +		.maximum = 1,
> > >>> +		.step = 1,
> > >>> +		.default_value = 0,
> > >>> +	},
> > >>> +	{
> > >>> +		.id = V4L2_CID_MPEG_VIDEO_HEVC_LOSSLESS_CU_ENABLE,
> > >>> +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> > >>> +		.name = "HEVC lossless encoding select",
> > >>> +		.minimum = 0,
> > >>> +		.maximum = 1,
> > >>> +		.step = 1,
> > >>> +		.default_value = 0,
> > >>> +	},
> > >>> +	{
> > >>> +		.id = V4L2_CID_MPEG_VIDEO_HEVC_WAVEFRONT_ENABLE,
> > >>> +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> > >>> +		.name = "HEVC Wavefront enable",
> > >>> +		.minimum = 0,
> > >>> +		.maximum = 1,
> > >>> +		.step = 1,
> > >>> +		.default_value = 0,
> > >>> +	},
> > >>> +	{
> > >>> +		.id = V4L2_CID_MPEG_VIDEO_HEVC_LF_DISABLE,
> > >>> +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> > >>> +		.name = "HEVC Filter disable",
> > >>> +		.minimum = 0,
> > >>> +		.maximum = 1,
> > >>> +		.step = 1,
> > >>> +		.default_value = 0,
> > >> Maybe instead of "disable" in name you should change default value to
> > >> true and set name to just "HEVC Filter".
> > >>
> > > ok I will change as per your suggestion.
> > >>> +	},
> > >>> +	{
> > >>> +		.id = V4L2_CID_MPEG_VIDEO_HEVC_LF_SLICE_BOUNDARY,
> > >>> +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> > >>> +		.name = "across or not slice boundary",
> > >> Name not fixed.
> > >>
> > > I will change the name.
> > >
> > >>> +		.minimum = 0,
> > >>> +		.maximum = 1,
> > >>> +		.step = 1,
> > >>> +		.default_value = 0,
> > >>> +	},
> > >>> +	{
> > >>> +		.id = V4L2_CID_MPEG_VIDEO_HEVC_LTR_ENABLE,
> > >>> +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> > >>> +		.name = "long term reference enable",
> > >>> +		.minimum = 0,
> > >>> +		.maximum = 1,
> > >>> +		.step = 1,
> > >>> +		.default_value = 0,
> > >>> +	},
> > >>> +	{
> > >>> +		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_QP_ENABLE,
> > >>> +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> > >>> +		.name = "QP values for temporal layer",
> > >>> +		.minimum = 0,
> > >>> +		.maximum = 1,
> > >>> +		.step = 1,
> > >>> +		.default_value = 0,
> > >>> +	},
> > >>> +	{
> > >>> +		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_TYPE,
> > >>> +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> > >>> +		.name = "Hierarchical Coding Type",
> > >>> +		.minimum = V4L2_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_B,
> > >>> +		.maximum = V4L2_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_P,
> > >> For type, enums and menu should be rather used, not bool.
> > > I will change the type for this. 
> > >>> +		.step = 1,
> > >>> +		.default_value = 0,
> > >>> +	},
> > >>> +	{
> > >>> +		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER,
> > >>> +		.type = V4L2_CTRL_TYPE_INTEGER,
> > >>> +		.name = "Hierarchical Coding Layer",
> > >>> +		.minimum = 0,
> > >>> +		.maximum = 7,
> > >> Shouldn't it be 6?
> > > Yes it should be 6. 
> > >>> +		.step = 1,
> > >>> +		.default_value = 0,
> > >> There are enums V4L2_MPEG_VIDEO_HEVC_HIERARCHIAL_CODING_LAYER[0-6]
> > >> defined in other patches. You should decide what is better: either pure
> > >> numbers 0-6, either enums and menu.
> > >> I cannot help because I do not know what it is.
> > >> Are you sure this control should be described as above? From what I have
> > >> found from quick googling I would expect rather something as maximal
> > >> number of layers in hierarchical coding.
> > >> Could you explain in few words what these layers are?
> > >>
> > > I prefer using the pure numbers as in the MFC User Manual. These layers 
> > > are basically used for scalability. Layer 0 will be given the highest 
> > > priority and layer 6 the lowest priority. So having them in layers helps us
> > > to encode selectively few layers without artifacts.Suppose we have a 30fps stream
> > > and we can encode only at 15fps, so if we skip layer 6 we can achieve 15fps
> > > meeting the conformance requirement. Even there is scalability with respect
> > > to bit rate. Highest bit rate will be assigned to layer0, so quality will be
> > > better for layer 0.
> > 
> > It looks like H264 has control
> > V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER
> > and it is a number of HC layers. I guess this control should have
> > similar meaning.
> > 
> Yes correct, it has same meaning as
> V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER.
> > >>> +	},
> > >>> +	{
> > >>> +		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_QP,
> > >>> +		.type = V4L2_CTRL_TYPE_INTEGER,
> > >>> +		.name = "Hierarchical Coding Layer QP",
> > >>> +		.minimum = INT_MIN,
> > >>> +		.maximum = INT_MAX,
> > >>> +		.step = 1,
> > >>> +		.default_value = 0,
> > >>> +	},
> > >>> +	{
> > >>> +		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_BIT0,
> > >>> +		.type = V4L2_CTRL_TYPE_INTEGER,
> > >>> +		.name = "Hierarchical Coding Layer BIT0",
> > >>> +		.minimum = INT_MIN,
> > >>> +		.maximum = INT_MAX,
> > >>> +		.step = 1,
> > >>> +		.default_value = 0,
> > >>> +	},
> > >>> +	{
> > >>> +		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_BIT1,
> > >>> +		.type = V4L2_CTRL_TYPE_INTEGER,
> > >>> +		.name = "Hierarchical Coding Layer BIT1",
> > >>> +		.minimum = INT_MIN,
> > >>> +		.maximum = INT_MAX,
> > >>> +		.step = 1,
> > >>> +		.default_value = 0,
> > >>> +	},
> > >>> +	{
> > >>> +		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_BIT2,
> > >>> +		.type = V4L2_CTRL_TYPE_INTEGER,
> > >>> +		.name = "Hierarchical Coding Layer BIT2",
> > >>> +		.minimum = INT_MIN,
> > >>> +		.maximum = INT_MAX,
> > >>> +		.step = 1,
> > >>> +		.default_value = 0,
> > >>> +	},
> > >>> +	{
> > >>> +		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_BIT3,
> > >>> +		.type = V4L2_CTRL_TYPE_INTEGER,
> > >>> +		.name = "Hierarchical Coding Layer BIT3",
> > >>> +		.minimum = INT_MIN,
> > >>> +		.maximum = INT_MAX,
> > >>> +		.step = 1,
> > >>> +		.default_value = 0,
> > >>> +	},
> > >>> +	{
> > >>> +		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_BIT4,
> > >>> +		.type = V4L2_CTRL_TYPE_INTEGER,
> > >>> +		.name = "Hierarchical Coding Layer BIT4",
> > >>> +		.minimum = INT_MIN,
> > >>> +		.maximum = INT_MAX,
> > >>> +		.step = 1,
> > >>> +		.default_value = 0,
> > >>> +	},
> > >>> +	{
> > >>> +		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_BIT5,
> > >>> +		.type = V4L2_CTRL_TYPE_INTEGER,
> > >>> +		.name = "Hierarchical Coding Layer BIT5",
> > >>> +		.minimum = INT_MIN,
> > >>> +		.maximum = INT_MAX,
> > >>> +		.step = 1,
> > >>> +		.default_value = 0,
> > >>> +	},
> > >>> +	{
> > >>> +		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_BIT6,
> > >>> +		.type = V4L2_CTRL_TYPE_INTEGER,
> > >>> +		.name = "Hierarchical Coding Layer BIT6",
> > >>> +		.minimum = INT_MIN,
> > >>> +		.maximum = INT_MAX,
> > >>> +		.step = 1,
> > >>> +		.default_value = 0,
> > >> What BIT stands for?
> > >> I see BIT0 to BIT6, is it somehow connected with value of
> > >> V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER ?
> > > It is used to control the bit rate for the corresponding coding layer.
> > > I will change the name to a meaningful one in the next patch version 
> > >>> +	},
> > >>> +	{
> > >>> +		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_CH,
> > >>> +		.type = V4L2_CTRL_TYPE_INTEGER,
> > >>> +		.name = "Hierarchical Coding Layer Change",
> > >>> +		.minimum = INT_MIN,
> > >>> +		.maximum = INT_MAX,
> > >>> +		.step = 1,
> > >>> +		.default_value = 0,
> > >>> +	},
> > >>> +	{
> > >>> +		.id = V4L2_CID_MPEG_VIDEO_HEVC_SIGN_DATA_HIDING,
> > >>> +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> > >>> +		.name = "HEVC Sign data hiding",
> > >>> +		.minimum = 0,
> > >>> +		.maximum = 1,
> > >>> +		.step = 1,
> > >>> +		.default_value = 0,
> > >>> +	},
> > >>> +	{
> > >>> +		.id = V4L2_CID_MPEG_VIDEO_HEVC_GENERAL_PB_ENABLE,
> > >>> +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> > >>> +		.name = "HEVC General pb enable",
> > >>> +		.minimum = 0,
> > >>> +		.maximum = 1,
> > >>> +		.step = 1,
> > >>> +		.default_value = 0,
> > >>> +	},
> > >>> +	{
> > >>> +		.id = V4L2_CID_MPEG_VIDEO_HEVC_TEMPORAL_ID_ENABLE,
> > >>> +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> > >>> +		.name = "HEVC Temporal id enable",
> > >>> +		.minimum = 0,
> > >>> +		.maximum = 1,
> > >>> +		.step = 1,
> > >>> +		.default_value = 0,
> > >>> +	},
> > >>> +	{
> > >>> +		.id = V4L2_CID_MPEG_VIDEO_HEVC_STRONG_SMOTHING_FLAG,
> > >>> +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> > >>> +		.name = "HEVC Strong intra smoothing flag",
> > >> flag word can be removed, as well as "... enable" in other bool controls.
> > > I will correct it. 
> > >>> +		.minimum = 0,
> > >>> +		.maximum = 1,
> > >>> +		.step = 1,
> > >>> +		.default_value = 0,
> > >>> +	},
> > >>> +	{
> > >>> +		.id = V4L2_CID_MPEG_VIDEO_HEVC_DISABLE_INTRA_PU_SPLIT,
> > >>> +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> > >>> +		.name = "HEVC disable intra pu split",
> > >>> +		.minimum = 0,
> > >>> +		.maximum = 1,
> > >>> +		.step = 1,
> > >>> +		.default_value = 0,
> > >> Again you can reverse the flag and set default value to 1, here and below.
> > > Ok I will correct it. 

I will remove the disable, enable and flag from the names, but keep the
default value as 0 only and have given in the documentation the meaning
of each values set for these control IDs. The user can set the control
IDs as per their requirement.

> > >>> +	},
> > >>> +	{
> > >>> +		.id = V4L2_CID_MPEG_VIDEO_HEVC_DISABLE_TMV_PREDICTION,
> > >>> +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> > >>> +		.name = "HEVC disable tmv prediction",
> > >>> +		.minimum = 0,
> > >>> +		.maximum = 1,
> > >>> +		.step = 1,
> > >>> +		.default_value = 0,
> > >>> +	},
> > >>> +	{
> > >>> +		.id = V4L2_CID_MPEG_VIDEO_HEVC_MAX_NUM_MERGE_MV_MINUS1,
> > >>> +		.type = V4L2_CTRL_TYPE_INTEGER,
> > >>> +		.name = "max number of candidate MVs",
> > >>> +		.minimum = 0,
> > >>> +		.maximum = 4,
> > >>> +		.step = 1,
> > >>> +		.default_value = 0,
> > >>> +	},
> > >>> +	{
> > >>> +		.id = V4L2_CID_MPEG_VIDEO_HEVC_WITHOUT_STARTCODE_ENABLE,
> > >>> +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> > >>> +		.name = "ENC without startcode enable",
> > >>> +		.minimum = 0,
> > >>> +		.maximum = 1,
> > >>> +		.step = 1,
> > >>> +		.default_value = 0,
> > >>> +	},
> > >>> +	{
> > >>> +		.id = V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_PERIOD,
> > >>> +		.type = V4L2_CTRL_TYPE_INTEGER,
> > >>> +		.name = "HEVC Number of reference picture",
> > >> Id and type does not match. I suppose it is intentionally (after looking
> > >> at documentation from next patch), but it is still unclear. As I
> > >> understand it is a number of I-frames between two consecutive
> > >> IDR-frames, am I right? Maybe "HEVC IDR/I frame rate", I hope you will
> > >> find better name :)
> > > Yes refresh period specifies number of I frames between 2 IDR frames.
> > > I will change the name to a more meaningful one.
> > >
> > >>> +		.minimum = 0,
> > >>> +		.maximum = (1 << 16) - 1,
> > >>> +		.step = 1,
> > >>> +		.default_value = 0,
> > >>> +	},
> > >>> +	{
> > >>> +		.id = V4L2_CID_MPEG_VIDEO_HEVC_LF_BETA_OFFSET_DIV2,
> > >>> +		.type = V4L2_CTRL_TYPE_INTEGER,
> > >>> +		.name = "HEVC loop filter beta offset",
> > >>> +		.minimum = -6,
> > >>> +		.maximum = 6,
> > >>> +		.step = 1,
> > >>> +		.default_value = 0,
> > >>> +	},
> > >>> +	{
> > >>> +		.id = V4L2_CID_MPEG_VIDEO_HEVC_LF_TC_OFFSET_DIV2,
> > >>> +		.type = V4L2_CTRL_TYPE_INTEGER,
> > >>> +		.name = "HEVC loop filter tc offset",
> > >>> +		.minimum = -6,
> > >>> +		.maximum = 6,
> > >>> +		.step = 1,
> > >>> +		.default_value = 0,
> > >>> +	},
> > >>> +	{
> > >>> +		.id = V4L2_CID_MPEG_VIDEO_HEVC_SIZE_OF_LENGTH_FIELD,
> > >>> +		.type = V4L2_CTRL_TYPE_INTEGER,
> > >>> +		.name = "HEVC size of length field",
> > >>> +		.minimum = 0,
> > >>> +		.maximum = 3,
> > >>> +		.step = 1,
> > >>> +		.default_value = 0,
> > >>> +	},
> > >>> +	{
> > >>> +		.id = V4L2_CID_MPEG_VIDEO_HEVC_USE_REF,
> > >>> +		.type = V4L2_CTRL_TYPE_INTEGER,
> > >>> +		.name = "user long term reference frame",
> > >> s/user/use/
> > > I will change it. 
> > >>> +		.minimum = 0,
> > >>> +		.maximum = 1,
> > >> Documentation says about values 0, 1, 2, 3.
> > > Yes I will correct it to 3. 
> > >>> +		.step = 1,
> > >>> +		.default_value = 0,
> > >>> +	},
> > >>> +	{
> > >>> +		.id = V4L2_CID_MPEG_VIDEO_HEVC_STORE_REF,
> > >>> +		.type = V4L2_CTRL_TYPE_INTEGER,
> > >>> +		.name = "store long term reference frame",
> > >>> +		.minimum = 0,
> > >>> +		.maximum = 2,
> > >>> +		.step = 1,
> > >>> +		.default_value = 0,
> > >>> +	},
> > >> Two above controls are set per-frame/buffer. V4L2 currently does not
> > >> support controls per frame, so I suppose you should drop them.
> > > Ok I will remove them from the list. 
> > >>> +	{
> > >>> +		.id = V4L2_CID_MPEG_VIDEO_HEVC_PREPEND_SPSPPS_TO_IDR,
> > >>> +		.type = V4L2_CTRL_TYPE_INTEGER,
> > >>> +		.name = "Prepend SPS/PPS to every IDR",
> > >>> +		.minimum = 0,
> > >>> +		.maximum = 1,
> > >>> +		.step = 1,
> > >>> +		.default_value = 0,
> > >>> +	},
> > >>> +	{
> > >>>  		.id = V4L2_CID_MIN_BUFFERS_FOR_OUTPUT,
> > >>>  		.type = V4L2_CTRL_TYPE_INTEGER,
> > >>>  		.name = "Minimum number of output bufs",
> > >>> @@ -1640,6 +2089,152 @@ static int s5p_mfc_enc_s_ctrl(struct v4l2_ctrl *ctrl)
> > >>>  	case V4L2_CID_MPEG_VIDEO_VPX_PROFILE:
> > >>>  		p->codec.vp8.profile = ctrl->val;
> > >>>  		break;
> > >>> +	case V4L2_CID_MPEG_VIDEO_HEVC_I_FRAME_QP:
> > >>> +		p->codec.hevc.rc_frame_qp = ctrl->val;
> > >>> +		break;
> > >>> +	case V4L2_CID_MPEG_VIDEO_HEVC_P_FRAME_QP:
> > >>> +		p->codec.hevc.rc_p_frame_qp = ctrl->val;
> > >>> +		break;
> > >>> +	case V4L2_CID_MPEG_VIDEO_HEVC_B_FRAME_QP:
> > >>> +		p->codec.hevc.rc_b_frame_qp = ctrl->val;
> > >>> +		break;
> > >>> +	case V4L2_CID_MPEG_VIDEO_HEVC_RC_FRAME_RATE:
> > >>> +		p->codec.hevc.rc_framerate = ctrl->val;
> > >>> +		break;
> > >>> +	case V4L2_CID_MPEG_VIDEO_HEVC_MIN_QP:
> > >>> +		p->codec.hevc.rc_min_qp = ctrl->val;
> > >>> +		break;
> > >>> +	case V4L2_CID_MPEG_VIDEO_HEVC_MAX_QP:
> > >>> +		p->codec.hevc.rc_max_qp = ctrl->val;
> > >>> +		break;
> > >>> +	case V4L2_CID_MPEG_VIDEO_HEVC_LEVEL:
> > >>> +		p->codec.hevc.level = ctrl->val;
> > >>> +		break;
> > >>> +	case V4L2_CID_MPEG_VIDEO_HEVC_PROFILE:
> > >>> +		break;
> > >> Whats wrong with profile? Why it is not interpreted?
> > >>
> > >> The rest looks OK.
> > > Sorry I missed it. I will correct the same. 
> > >> Regards
> > >> Andrzej
> > >>
> > > Thank you for the review.
> > >
> > > Regards,
> > > Smitha T Murthy
> > >
> > >>> +	case V4L2_CID_MPEG_VIDEO_HEVC_ADAPTIVE_RC_DARK:
> > >>> +		p->codec.hevc.rc_lcu_dark = ctrl->val;
> > >>> +		break;
> > >>> +	case V4L2_CID_MPEG_VIDEO_HEVC_ADAPTIVE_RC_SMOOTH:
> > >>> +		p->codec.hevc.rc_lcu_smooth = ctrl->val;
> > >>> +		break;
> > >>> +	case V4L2_CID_MPEG_VIDEO_HEVC_ADAPTIVE_RC_STATIC:
> > >>> +		p->codec.hevc.rc_lcu_static = ctrl->val;
> > >>> +		break;
> > >>> +	case V4L2_CID_MPEG_VIDEO_HEVC_ADAPTIVE_RC_ACTIVITY:
> > >>> +		p->codec.hevc.rc_lcu_activity = ctrl->val;
> > >>> +		break;
> > >>> +	case V4L2_CID_MPEG_VIDEO_HEVC_TIER_FLAG:
> > >>> +		p->codec.hevc.tier_flag = ctrl->val;
> > >>> +		break;
> > >>> +	case V4L2_CID_MPEG_VIDEO_HEVC_MAX_PARTITION_DEPTH:
> > >>> +		p->codec.hevc.max_partition_depth = ctrl->val;
> > >>> +		break;
> > >>> +	case V4L2_CID_MPEG_VIDEO_HEVC_REF_NUMBER_FOR_PFRAMES:
> > >>> +		p->codec.hevc.num_refs_for_p = ctrl->val;
> > >>> +		break;
> > >>> +	case V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_TYPE:
> > >>> +		p->codec.hevc.refreshtype = ctrl->val;
> > >>> +		break;
> > >>> +	case V4L2_CID_MPEG_VIDEO_HEVC_CONST_INTRA_PRED_ENABLE:
> > >>> +		p->codec.hevc.const_intra_period_enable = ctrl->val;
> > >>> +		break;
> > >>> +	case V4L2_CID_MPEG_VIDEO_HEVC_LOSSLESS_CU_ENABLE:
> > >>> +		p->codec.hevc.lossless_cu_enable = ctrl->val;
> > >>> +		break;
> > >>> +	case V4L2_CID_MPEG_VIDEO_HEVC_WAVEFRONT_ENABLE:
> > >>> +		p->codec.hevc.wavefront_enable = ctrl->val;
> > >>> +		break;
> > >>> +	case V4L2_CID_MPEG_VIDEO_HEVC_LF_DISABLE:
> > >>> +		p->codec.hevc.loopfilter_disable = ctrl->val;
> > >>> +		break;
> > >>> +	case V4L2_CID_MPEG_VIDEO_HEVC_LF_SLICE_BOUNDARY:
> > >>> +		p->codec.hevc.loopfilter_across = ctrl->val;
> > >>> +		break;
> > >>> +	case V4L2_CID_MPEG_VIDEO_HEVC_LTR_ENABLE:
> > >>> +		p->codec.hevc.enable_ltr = ctrl->val;
> > >>> +		break;
> > >>> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_QP_ENABLE:
> > >>> +		p->codec.hevc.hier_qp_enable = ctrl->val;
> > >>> +		break;
> > >>> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_TYPE:
> > >>> +		p->codec.hevc.hier_qp_type =
> > >>> +			(enum v4l2_mpeg_video_hevc_hier_coding_type)(ctrl->val);
> > >>> +		break;
> > >>> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER:
> > >>> +		p->codec.hevc.num_hier_layer = ctrl->val & 0x7;
> > >>> +		p->codec.hevc.hier_ref_type = (ctrl->val >> 16) & 0x1;
> > 
> > According to control definition ctrl->val should have value in range
> > 0..6, so masking with 0x7 is redundant and hier_ref_type will be always
> > 0 - something wrong here.
> > 
> I will check this again and correct it accordingly.
> 
ctrl->val & 0x7 is done to take care of cases sending layer values
beyond 6. When the ctrl->val is >=7 it will be reset to 0.

> > >>> +		break;
> > >>> +	case V4L2_CID_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_LAYER_QP:
> > >>> +		p->codec.hevc.hier_qp_layer[(ctrl->val >> 16) & 0x7]
> > >>> +					= ctrl->val & 0xFF;
> > 
> > Here is also some strange magic - not reflected in definitions of
> > control, please fix it.
> > 
> > 
> Yes I will correct it.
> 
For HEVC, QP can have a value of 0-51. Hence in the control value passed
the LSB 16 bits will indicate the quantization parameter. The MSB 16 bit
will pass the layer(0-6) it is meant for. Since we need the layer
information also for which this QP is set, in the same control ID both
layer number and QP values will be passed. I have explained the same in
the documentation too.

> > It would be good to get these patches before end of merge window, but to
> > do it we must hurry up. Is it possible to send next version of patches
> > before end of next week? I hope non-HEVC part is almost ready. If there
> > will be still issues with HEVC part we can try to get at least non-HEVC
> > part for now (patches 1-8).
> > 
> > Regards
> > Andrzej
> > 
> Thank you so much for the review. Yes I will try to finish up these
> patches and ensure it will be pushed by this weekend. I was caught up
> with some other priority work and hence the delay. I will try to make
> HEVC part also complete with the next version.
> 
> Regards,
> Smitha

I will be submit the next version of patches today with all the
suggested changes taken in.

Thank you,
Smitha 
