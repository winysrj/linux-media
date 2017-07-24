Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:58841 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751940AbdGXFDy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Jul 2017 01:03:54 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20170724050352epoutp02f1ac6531e49c2a5b2d6ef40ffdb623b4~UK7UlcriZ2818328183epoutp02Z
        for <linux-media@vger.kernel.org>; Mon, 24 Jul 2017 05:03:52 +0000 (GMT)
Subject: Re: [Patch v5 11/12] [media] s5p-mfc: Add support for HEVC encoder
From: Smitha T Murthy <smitha.t@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        kamil@wypas.org, jtp.park@samsung.com, a.hajda@samsung.com,
        mchehab@kernel.org, pankaj.dubey@samsung.com, krzk@kernel.org,
        m.szyprowski@samsung.com, s.nawrocki@samsung.com
In-Reply-To: <fe086e70-1190-5ce8-0c16-38442d95874b@xs4all.nl>
Date: Mon, 24 Jul 2017 10:10:29 +0530
Message-ID: <1500871229.16819.1830.camel@smitha-fedora>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
References: <1497849055-26583-1-git-send-email-smitha.t@samsung.com>
        <CGME20170619052519epcas5p3bacba6c01bf2f135e5cd628226f8d24b@epcas5p3.samsung.com>
        <1497849055-26583-12-git-send-email-smitha.t@samsung.com>
        <fe086e70-1190-5ce8-0c16-38442d95874b@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2017-07-20 at 15:32 +0200, Hans Verkuil wrote:
> On 19/06/17 07:10, Smitha T Murthy wrote:
> > Add HEVC encoder support and necessary registers, V4L2 CIDs,
> > and hevc encoder parameters
> > 
> > Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
> > ---
> >  drivers/media/platform/s5p-mfc/regs-mfc-v10.h   |  28 +-
> >  drivers/media/platform/s5p-mfc/s5p_mfc.c        |   1 +
> >  drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c |   3 +
> >  drivers/media/platform/s5p-mfc/s5p_mfc_common.h |  53 ++-
> >  drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    | 521 ++++++++++++++++++++++++
> >  drivers/media/platform/s5p-mfc/s5p_mfc_opr.h    |   8 +
> >  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c | 168 ++++++++
> >  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h |   8 +
> >  8 files changed, 788 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/media/platform/s5p-mfc/regs-mfc-v10.h b/drivers/media/platform/s5p-mfc/regs-mfc-v10.h
> > index 6754477..7065b9d 100644
> > --- a/drivers/media/platform/s5p-mfc/regs-mfc-v10.h
> > +++ b/drivers/media/platform/s5p-mfc/regs-mfc-v10.h
> > @@ -20,13 +20,35 @@
> >  #define S5P_FIMV_MFC_STATE_V10				0x7124
> >  #define S5P_FIMV_D_STATIC_BUFFER_ADDR_V10		0xF570
> >  #define S5P_FIMV_D_STATIC_BUFFER_SIZE_V10		0xF574
> > +#define S5P_FIMV_E_NUM_T_LAYER_V10			0xFBAC
> > +#define S5P_FIMV_E_HIERARCHICAL_QP_LAYER0_V10		0xFBB0
> > +#define S5P_FIMV_E_HIERARCHICAL_QP_LAYER1_V10		0xFBB4
> > +#define S5P_FIMV_E_HIERARCHICAL_QP_LAYER2_V10		0xFBB8
> > +#define S5P_FIMV_E_HIERARCHICAL_QP_LAYER3_V10		0xFBBC
> > +#define S5P_FIMV_E_HIERARCHICAL_QP_LAYER4_V10		0xFBC0
> > +#define S5P_FIMV_E_HIERARCHICAL_QP_LAYER5_V10		0xFBC4
> > +#define S5P_FIMV_E_HIERARCHICAL_QP_LAYER6_V10		0xFBC8
> > +#define S5P_FIMV_E_HIERARCHICAL_BIT_RATE_LAYER0_V10	0xFD18
> > +#define S5P_FIMV_E_HIERARCHICAL_BIT_RATE_LAYER1_V10	0xFD1C
> > +#define S5P_FIMV_E_HIERARCHICAL_BIT_RATE_LAYER2_V10	0xFD20
> > +#define S5P_FIMV_E_HIERARCHICAL_BIT_RATE_LAYER3_V10	0xFD24
> > +#define S5P_FIMV_E_HIERARCHICAL_BIT_RATE_LAYER4_V10	0xFD28
> > +#define S5P_FIMV_E_HIERARCHICAL_BIT_RATE_LAYER5_V10	0xFD2C
> > +#define S5P_FIMV_E_HIERARCHICAL_BIT_RATE_LAYER6_V10	0xFD30
> > +#define S5P_FIMV_E_HEVC_OPTIONS_V10			0xFDD4
> > +#define S5P_FIMV_E_HEVC_REFRESH_PERIOD_V10		0xFDD8
> > +#define S5P_FIMV_E_HEVC_CHROMA_QP_OFFSET_V10		0xFDDC
> > +#define S5P_FIMV_E_HEVC_LF_BETA_OFFSET_DIV2_V10		0xFDE0
> > +#define S5P_FIMV_E_HEVC_LF_TC_OFFSET_DIV2_V10		0xFDE4
> > +#define S5P_FIMV_E_HEVC_NAL_CONTROL_V10			0xFDE8
> >  
> >  /* MFCv10 Context buffer sizes */
> >  #define MFC_CTX_BUF_SIZE_V10		(30 * SZ_1K)
> >  #define MFC_H264_DEC_CTX_BUF_SIZE_V10	(2 * SZ_1M)
> >  #define MFC_OTHER_DEC_CTX_BUF_SIZE_V10	(20 * SZ_1K)
> >  #define MFC_H264_ENC_CTX_BUF_SIZE_V10	(100 * SZ_1K)
> > -#define MFC_OTHER_ENC_CTX_BUF_SIZE_V10	(15 * SZ_1K)
> > +#define MFC_HEVC_ENC_CTX_BUF_SIZE_V10	(30 * SZ_1K)
> > +#define MFC_OTHER_ENC_CTX_BUF_SIZE_V10  (15 * SZ_1K)
> >  
> >  /* MFCv10 variant defines */
> >  #define MAX_FW_SIZE_V10		(SZ_1M)
> > @@ -58,5 +80,9 @@
> >  #define ENC_V100_VP8_ME_SIZE(x, y) \
> >  	ENC_V100_BASE_SIZE(x, y)
> >  
> > +#define ENC_V100_HEVC_ME_SIZE(x, y)	\
> > +	(((x + 3) * (y + 3) * 32)	\
> > +	 + ((y * 128) + 1280) * DIV_ROUND_UP(x, 4))
> > +
> >  #endif /*_REGS_MFC_V10_H*/
> >  
> > diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> > index efc36b0..742c2b7 100644
> > --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> > +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> > @@ -1621,6 +1621,7 @@ static struct s5p_mfc_buf_size_v6 mfc_buf_size_v10 = {
> >  	.h264_dec_ctx   = MFC_H264_DEC_CTX_BUF_SIZE_V10,
> >  	.other_dec_ctx  = MFC_OTHER_DEC_CTX_BUF_SIZE_V10,
> >  	.h264_enc_ctx   = MFC_H264_ENC_CTX_BUF_SIZE_V10,
> > +	.hevc_enc_ctx   = MFC_HEVC_ENC_CTX_BUF_SIZE_V10,
> >  	.other_enc_ctx  = MFC_OTHER_ENC_CTX_BUF_SIZE_V10,
> >  };
> >  
> > diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c
> > index 102b47e..7521fce 100644
> > --- a/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c
> > +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c
> > @@ -122,6 +122,9 @@ static int s5p_mfc_open_inst_cmd_v6(struct s5p_mfc_ctx *ctx)
> >  	case S5P_MFC_CODEC_VP8_ENC:
> >  		codec_type = S5P_FIMV_CODEC_VP8_ENC_V7;
> >  		break;
> > +	case S5P_MFC_CODEC_HEVC_ENC:
> > +		codec_type = S5P_FIMV_CODEC_HEVC_ENC;
> > +		break;
> >  	default:
> >  		codec_type = S5P_FIMV_CODEC_NONE_V6;
> >  	}
> > diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> > index b49f220..c1ae4f4 100644
> > --- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> > +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> > @@ -61,7 +61,7 @@
> >  #define MFC_ENC_CAP_PLANE_COUNT	1
> >  #define MFC_ENC_OUT_PLANE_COUNT	2
> >  #define STUFF_BYTE		4
> > -#define MFC_MAX_CTRLS		77
> > +#define MFC_MAX_CTRLS		128
> >  
> >  #define S5P_MFC_CODEC_NONE		-1
> >  #define S5P_MFC_CODEC_H264_DEC		0
> > @@ -80,6 +80,7 @@
> >  #define S5P_MFC_CODEC_MPEG4_ENC		22
> >  #define S5P_MFC_CODEC_H263_ENC		23
> >  #define S5P_MFC_CODEC_VP8_ENC		24
> > +#define S5P_MFC_CODEC_HEVC_ENC		26
> >  
> >  #define S5P_MFC_R2H_CMD_EMPTY			0
> >  #define S5P_MFC_R2H_CMD_SYS_INIT_RET		1
> > @@ -215,6 +216,7 @@ struct s5p_mfc_buf_size_v6 {
> >  	unsigned int h264_dec_ctx;
> >  	unsigned int other_dec_ctx;
> >  	unsigned int h264_enc_ctx;
> > +	unsigned int hevc_enc_ctx;
> >  	unsigned int other_enc_ctx;
> >  };
> >  
> > @@ -429,6 +431,54 @@ struct s5p_mfc_vp8_enc_params {
> >  	u8 profile;
> >  };
> >  
> > +struct s5p_mfc_hevc_enc_params {
> > +	enum v4l2_mpeg_video_hevc_profile profile;
> > +	int level;
> > +	enum v4l2_mpeg_video_h264_level level_v4l2;
> > +	u8 tier_flag;
> > +	u32 rc_framerate;
> > +	u8 rc_min_qp;
> > +	u8 rc_max_qp;
> > +	u8 rc_lcu_dark;
> > +	u8 rc_lcu_smooth;
> > +	u8 rc_lcu_static;
> > +	u8 rc_lcu_activity;
> > +	u8 rc_frame_qp;
> > +	u8 rc_p_frame_qp;
> > +	u8 rc_b_frame_qp;
> > +	u8 max_partition_depth;
> > +	u8 num_refs_for_p;
> > +	u8 refreshtype;
> > +	u16 refreshperiod;
> > +	s32 lf_beta_offset_div2;
> > +	s32 lf_tc_offset_div2;
> > +	u8 loopfilter_disable;
> > +	u8 loopfilter_across;
> > +	u8 nal_control_length_filed;
> > +	u8 nal_control_user_ref;
> > +	u8 nal_control_store_ref;
> > +	u8 const_intra_period_enable;
> > +	u8 lossless_cu_enable;
> > +	u8 wavefront_enable;
> > +	u8 enable_ltr;
> > +	u8 hier_qp_enable;
> > +	enum v4l2_mpeg_video_hevc_hier_coding_type hier_qp_type;
> > +	u8 num_hier_layer;
> > +	u8 hier_qp_layer[7];
> > +	u32 hier_bit_layer[7];
> > +	u8 sign_data_hiding;
> > +	u8 general_pb_enable;
> > +	u8 temporal_id_enable;
> > +	u8 strong_intra_smooth;
> > +	u8 intra_pu_split_disable;
> > +	u8 tmv_prediction_disable;
> > +	u8 max_num_merge_mv;
> > +	u8 eco_mode_enable;
> > +	u8 encoding_nostartcode_enable;
> > +	u8 size_of_length_field;
> > +	u8 prepend_sps_pps_to_idr;
> > +};
> > +
> >  /**
> >   * struct s5p_mfc_enc_params - general encoding parameters
> >   */
> > @@ -466,6 +516,7 @@ struct s5p_mfc_enc_params {
> >  		struct s5p_mfc_h264_enc_params h264;
> >  		struct s5p_mfc_mpeg4_enc_params mpeg4;
> >  		struct s5p_mfc_vp8_enc_params vp8;
> > +		struct s5p_mfc_hevc_enc_params hevc;
> >  	} codec;
> >  
> >  };
> > diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> > index eb5352a..9e5b05a 100644
> > --- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> > +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> > @@ -99,6 +99,14 @@ static struct s5p_mfc_fmt formats[] = {
> >  		.num_planes	= 1,
> >  		.versions	= MFC_V7PLUS_BITS,
> >  	},
> > +	{
> > +		.name		= "HEVC Encoded Stream",
> 
> Drop the names! They are filled in by the v4l2 core.
> 
> It's a good idea to have an earlier patch that just removes these names
> from the existing formats.
> 
Ok I will remove the names in the next patch version.

> > +		.fourcc		= V4L2_PIX_FMT_HEVC,
> > +		.codec_mode	= S5P_FIMV_CODEC_HEVC_ENC,
> > +		.type		= MFC_FMT_ENC,
> > +		.num_planes	= 1,
> > +		.versions	= MFC_V10_BIT,
> > +	},
> >  };
> >  
> >  #define NUM_FORMATS ARRAY_SIZE(formats)
> > @@ -693,6 +701,366 @@ static struct mfc_control controls[] = {
> >  		.default_value = 0,
> >  	},
> >  	{
> > +		.id = V4L2_CID_MPEG_VIDEO_HEVC_I_FRAME_QP,
> > +		.type = V4L2_CTRL_TYPE_INTEGER,
> > +		.name = "HEVC I Frame QP Value",
> 
> Don't set the name! Again, it's filled in by v4l2-ctrls.c.
> 
> I am not keen on arrays like this. First of all they duplicate struct v4l2_ctrl_config.
> And secondly, I prefer it if you just call the v4l2_ctrl_new_std* functions to create
> new controls.
> 
I adopted the method as used by other codecs to define the controls.
I would like to take this up in separate patch series to use
v4l2_ctrl_new_std* for HEVC and other codecs.

> > +		.minimum = 0,
> > +		.maximum = 51,
> > +		.step = 1,
> > +		.default_value = 0,
> > +	},
> > +	{
> > +		.id = V4L2_CID_MPEG_VIDEO_HEVC_P_FRAME_QP,
> > +		.type = V4L2_CTRL_TYPE_INTEGER,
> > +		.name = "HEVC P Frame QP Value",
> > +		.minimum = 0,
> > +		.maximum = 51,
> > +		.step = 1,
> > +		.default_value = 0,
> > +	},
> > +	{
> > +		.id = V4L2_CID_MPEG_VIDEO_HEVC_B_FRAME_QP,
> > +		.type = V4L2_CTRL_TYPE_INTEGER,
> > +		.name = "HEVC B Frame QP Value",
> > +		.minimum = 0,
> > +		.maximum = 51,
> > +		.step = 1,
> > +		.default_value = 0,
> > +	},
> > +	{
> > +		.id = V4L2_CID_MPEG_VIDEO_HEVC_MIN_QP,
> > +		.type = V4L2_CTRL_TYPE_INTEGER,
> > +		.name = "HEVC Minimum QP Value",
> > +		.minimum = 0,
> > +		.maximum = 51,
> > +		.step = 1,
> > +		.default_value = 0,
> > +	},
> > +	{
> > +		.id = V4L2_CID_MPEG_VIDEO_HEVC_MAX_QP,
> > +		.type = V4L2_CTRL_TYPE_INTEGER,
> > +		.name = "HEVC Maximum QP Value",
> > +		.minimum = 0,
> > +		.maximum = 51,
> > +		.step = 1,
> > +		.default_value = 0,
> > +	},
> > +	{
> > +		.id = V4L2_CID_MPEG_VIDEO_HEVC_PROFILE,
> > +		.type = V4L2_CTRL_TYPE_MENU,
> > +		.name = "HEVC Profile",
> > +		.minimum = V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN,
> > +		.maximum = V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN_STILL_PICTURE,
> > +		.step = 1,
> > +		.default_value = V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN,
> > +	},
> > +	{
> > +		.id = V4L2_CID_MPEG_VIDEO_HEVC_LEVEL,
> > +		.type = V4L2_CTRL_TYPE_MENU,
> > +		.name = "HEVC Level",
> > +		.minimum = V4L2_MPEG_VIDEO_HEVC_LEVEL_1,
> > +		.maximum = V4L2_MPEG_VIDEO_HEVC_LEVEL_6_2,
> > +		.step = 1,
> > +		.default_value = V4L2_MPEG_VIDEO_HEVC_LEVEL_1,
> > +	},
> > +	{
> > +		.id = V4L2_CID_MPEG_VIDEO_HEVC_TIER_FLAG,
> > +		.type = V4L2_CTRL_TYPE_MENU,
> > +		.name = "HEVC Tier_flag",
> > +		.minimum = V4L2_MPEG_VIDEO_HEVC_TIER_MAIN,
> > +		.maximum = V4L2_MPEG_VIDEO_HEVC_TIER_HIGH,
> > +		.step = 1,
> > +		.default_value = V4L2_MPEG_VIDEO_HEVC_TIER_MAIN,
> > +	},
> > +	{
> > +		.id = V4L2_CID_MPEG_VIDEO_HEVC_FRAME_RATE_RESOLUTION,
> > +		.type = V4L2_CTRL_TYPE_INTEGER,
> > +		.name = "HEVC Frame Rate Resolution",
> > +		.minimum = 1,
> > +		.maximum = (1 << 16) - 1,
> > +		.step = 1,
> > +		.default_value = 1,
> > +	},
> > +	{
> > +		.id = V4L2_CID_MPEG_VIDEO_HEVC_MAX_PARTITION_DEPTH,
> > +		.type = V4L2_CTRL_TYPE_INTEGER,
> > +		.name = "HEVC Maximum Coding Unit Depth",
> > +		.minimum = 0,
> > +		.maximum = 1,
> > +		.step = 1,
> > +		.default_value = 0,
> > +	},
> > +	{
> > +		.id = V4L2_CID_MPEG_MFC10_VIDEO_HEVC_REF_NUMBER_FOR_PFRAMES,
> > +		.type = V4L2_CTRL_TYPE_INTEGER,
> > +		.name = "HEVC Num of Reference Pictures",
> > +		.minimum = 1,
> > +		.maximum = 2,
> > +		.step = 1,
> > +		.default_value = 1,
> > +	},
> > +	{
> > +		.id = V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_TYPE,
> > +		.type = V4L2_CTRL_TYPE_MENU,
> > +		.name = "HEVC Refresh Type",
> > +		.minimum = V4L2_MPEG_VIDEO_HEVC_REFRESH_NONE,
> > +		.maximum = V4L2_MPEG_VIDEO_HEVC_REFRESH_IDR,
> > +		.step = 1,
> > +		.default_value = V4L2_MPEG_VIDEO_HEVC_REFRESH_NONE,
> > +	},
> > +	{
> > +		.id = V4L2_CID_MPEG_VIDEO_HEVC_CONST_INTRA_PRED,
> > +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> > +		.name = "HEVC Constant Intra Prediction",
> > +		.minimum = 0,
> > +		.maximum = 1,
> > +		.step = 1,
> > +		.default_value = 0,
> > +	},
> > +	{
> > +		.id = V4L2_CID_MPEG_VIDEO_HEVC_LOSSLESS_CU,
> > +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> > +		.name = "HEVC Lossless Encoding",
> > +		.minimum = 0,
> > +		.maximum = 1,
> > +		.step = 1,
> > +		.default_value = 0,
> > +	},
> > +	{
> > +		.id = V4L2_CID_MPEG_VIDEO_HEVC_WAVEFRONT,
> > +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> > +		.name = "HEVC Wavefront",
> > +		.minimum = 0,
> > +		.maximum = 1,
> > +		.step = 1,
> > +		.default_value = 0,
> > +	},
> > +	{
> > +		.id = V4L2_CID_MPEG_VIDEO_HEVC_LF,
> > +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> > +		.name = "HEVC Loop Filter",
> > +		.minimum = 0,
> > +		.maximum = 1,
> > +		.step = 1,
> > +		.default_value = 0,
> > +	},
> > +	{
> > +		.id = V4L2_CID_MPEG_VIDEO_HEVC_LF_SLICE_BOUNDARY,
> > +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> > +		.name = "HEVC LF Across Slice Boundary",
> > +		.minimum = 0,
> > +		.maximum = 1,
> > +		.step = 1,
> > +		.default_value = 0,
> > +	},
> > +	{
> > +		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIER_QP,
> > +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> > +		.name = "HEVC QP Values",
> > +		.minimum = 0,
> > +		.maximum = 1,
> > +		.step = 1,
> > +		.default_value = 0,
> > +	},
> > +	{
> > +		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_TYPE,
> > +		.type = V4L2_CTRL_TYPE_MENU,
> > +		.name = "HEVC Hierarchical Coding Type",
> > +		.minimum = V4L2_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_B,
> > +		.maximum = V4L2_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_P,
> > +		.step = 1,
> > +		.default_value = V4L2_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_B,
> > +	},
> > +	{
> > +		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER,
> > +		.type = V4L2_CTRL_TYPE_INTEGER,
> > +		.name = "HEVC Hierarchical Coding Layer",
> > +		.minimum = 0,
> > +		.maximum = 6,
> > +		.step = 1,
> > +		.default_value = 0,
> > +	},
> > +	{
> > +		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER_QP,
> > +		.type = V4L2_CTRL_TYPE_INTEGER,
> > +		.name = "HEVC Hierarchical Layer QP",
> > +		.minimum = INT_MIN,
> > +		.maximum = INT_MAX,
> > +		.step = 1,
> > +		.default_value = 0,
> > +	},
> > +	{
> > +		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L0_BR,
> > +		.type = V4L2_CTRL_TYPE_INTEGER,
> > +		.name = "HEVC Hierarchical Lay 0 Bit Rate",
> > +		.minimum = INT_MIN,
> > +		.maximum = INT_MAX,
> > +		.step = 1,
> > +		.default_value = 0,
> > +	},
> > +	{
> > +		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L1_BR,
> > +		.type = V4L2_CTRL_TYPE_INTEGER,
> > +		.name = "HEVC Hierarchical Lay 1 Bit Rate",
> > +		.minimum = INT_MIN,
> > +		.maximum = INT_MAX,
> > +		.step = 1,
> > +		.default_value = 0,
> > +	},
> > +	{
> > +		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L2_BR,
> > +		.type = V4L2_CTRL_TYPE_INTEGER,
> > +		.name = "HEVC Hierarchical Lay 2 Bit Rate",
> > +		.minimum = INT_MIN,
> > +		.maximum = INT_MAX,
> > +		.step = 1,
> > +		.default_value = 0,
> > +	},
> > +	{
> > +		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L3_BR,
> > +		.type = V4L2_CTRL_TYPE_INTEGER,
> > +		.name = "HEVC Hierarchical Lay 3 Bit Rate",
> > +		.minimum = INT_MIN,
> > +		.maximum = INT_MAX,
> > +		.step = 1,
> > +		.default_value = 0,
> > +	},
> > +	{
> > +		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L4_BR,
> > +		.type = V4L2_CTRL_TYPE_INTEGER,
> > +		.name = "HEVC Hierarchical Lay 4 Bit Rate",
> > +		.minimum = INT_MIN,
> > +		.maximum = INT_MAX,
> > +		.step = 1,
> > +		.default_value = 0,
> > +	},
> > +	{
> > +		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L5_BR,
> > +		.type = V4L2_CTRL_TYPE_INTEGER,
> > +		.name = "HEVC Hierarchical Lay 5 Bit Rate",
> > +		.minimum = INT_MIN,
> > +		.maximum = INT_MAX,
> > +		.step = 1,
> > +		.default_value = 0,
> > +	},
> > +	{
> > +		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L6_BR,
> > +		.type = V4L2_CTRL_TYPE_INTEGER,
> > +		.name = "HEVC Hierarchical Lay 6 Bit Rate",
> > +		.minimum = INT_MIN,
> > +		.maximum = INT_MAX,
> > +		.step = 1,
> > +		.default_value = 0,
> > +	},
> > +	{
> > +		.id = V4L2_CID_MPEG_VIDEO_HEVC_GENERAL_PB,
> > +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> > +		.name = "HEVC General PB",
> > +		.minimum = 0,
> > +		.maximum = 1,
> > +		.step = 1,
> > +		.default_value = 0,
> > +	},
> > +	{
> > +		.id = V4L2_CID_MPEG_VIDEO_HEVC_TEMPORAL_ID,
> > +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> > +		.name = "HEVC Temporal ID",
> > +		.minimum = 0,
> > +		.maximum = 1,
> > +		.step = 1,
> > +		.default_value = 0,
> > +	},
> > +	{
> > +		.id = V4L2_CID_MPEG_VIDEO_HEVC_STRONG_SMOOTHING,
> > +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> > +		.name = "HEVC Strong Intra Smoothing",
> > +		.minimum = 0,
> > +		.maximum = 1,
> > +		.step = 1,
> > +		.default_value = 0,
> > +	},
> > +	{
> > +		.id = V4L2_CID_MPEG_VIDEO_HEVC_INTRA_PU_SPLIT,
> > +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> > +		.name = "HEVC Intra PU Split",
> > +		.minimum = 0,
> > +		.maximum = 1,
> > +		.step = 1,
> > +		.default_value = 0,
> > +	},
> > +	{
> > +		.id = V4L2_CID_MPEG_VIDEO_HEVC_TMV_PREDICTION,
> > +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> > +		.name = "HEVC TMV Prediction",
> > +		.minimum = 0,
> > +		.maximum = 1,
> > +		.step = 1,
> > +		.default_value = 0,
> > +	},
> > +	{
> > +		.id = V4L2_CID_MPEG_VIDEO_HEVC_MAX_NUM_MERGE_MV_MINUS1,
> > +		.type = V4L2_CTRL_TYPE_INTEGER,
> > +		.name = "HEVC Max Number of Candidate MVs",
> > +		.minimum = 0,
> > +		.maximum = 4,
> > +		.step = 1,
> > +		.default_value = 0,
> > +	},
> > +	{
> > +		.id = V4L2_CID_MPEG_VIDEO_HEVC_WITHOUT_STARTCODE,
> > +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> > +		.name = "HEVC ENC Without Startcode",
> > +		.minimum = 0,
> > +		.maximum = 1,
> > +		.step = 1,
> > +		.default_value = 0,
> > +	},
> > +	{
> > +		.id = V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_PERIOD,
> > +		.type = V4L2_CTRL_TYPE_INTEGER,
> > +		.name = "HEVC Num of I Frames b/w 2 IDR",
> > +		.minimum = 0,
> > +		.maximum = (1 << 16) - 1,
> > +		.step = 1,
> > +		.default_value = 0,
> > +	},
> > +	{
> > +		.id = V4L2_CID_MPEG_VIDEO_HEVC_LF_BETA_OFFSET_DIV2,
> > +		.type = V4L2_CTRL_TYPE_INTEGER,
> > +		.name = "HEVC Loop Filter Beta Offset",
> > +		.minimum = -6,
> > +		.maximum = 6,
> > +		.step = 1,
> > +		.default_value = 0,
> > +	},
> > +	{
> > +		.id = V4L2_CID_MPEG_VIDEO_HEVC_LF_TC_OFFSET_DIV2,
> > +		.type = V4L2_CTRL_TYPE_INTEGER,
> > +		.name = "HEVC Loop Filter TC Offset",
> > +		.minimum = -6,
> > +		.maximum = 6,
> > +		.step = 1,
> > +		.default_value = 0,
> > +	},
> > +	{
> > +		.id = V4L2_CID_MPEG_VIDEO_HEVC_SIZE_OF_LENGTH_FIELD,
> > +		.type = V4L2_CTRL_TYPE_MENU,
> > +		.name = "HEVC Size of Length Field",
> > +		.minimum = V4L2_MPEG_VIDEO_HEVC_SIZE_0,
> > +		.maximum = V4L2_MPEG_VIDEO_HEVC_SIZE_4,
> > +		.step = 1,
> > +		.default_value = V4L2_MPEG_VIDEO_HEVC_SIZE_0,
> > +	},
> > +	{
> > +		.id = V4L2_CID_MPEG_MFC10_VIDEO_HEVC_PREPEND_SPSPPS_TO_IDR,
> > +		.type = V4L2_CTRL_TYPE_INTEGER,
> > +		.name = "Prepend SPS/PPS to IDR",
> > +		.minimum = 0,
> > +		.maximum = 1,
> > +		.step = 1,
> > +		.default_value = 0,
> > +	},
> > +	{
> >  		.id = V4L2_CID_MIN_BUFFERS_FOR_OUTPUT,
> >  		.type = V4L2_CTRL_TYPE_INTEGER,
> >  		.name = "Minimum number of output bufs",
> > @@ -1359,6 +1727,26 @@ static inline int mpeg4_level(enum v4l2_mpeg_video_mpeg4_level lvl)
> >  	return t[lvl];
> >  }
> >  
> > +static inline int hevc_level(enum v4l2_mpeg_video_hevc_level lvl)
> > +{
> > +	static unsigned int t[] = {
> > +		/* V4L2_MPEG_VIDEO_HEVC_LEVEL_1    */ 10,
> > +		/* V4L2_MPEG_VIDEO_HEVC_LEVEL_2    */ 20,
> > +		/* V4L2_MPEG_VIDEO_HEVC_LEVEL_2_1  */ 21,
> > +		/* V4L2_MPEG_VIDEO_HEVC_LEVEL_3    */ 30,
> > +		/* V4L2_MPEG_VIDEO_HEVC_LEVEL_3_1  */ 31,
> > +		/* V4L2_MPEG_VIDEO_HEVC_LEVEL_4    */ 40,
> > +		/* V4L2_MPEG_VIDEO_HEVC_LEVEL_4_1  */ 41,
> > +		/* V4L2_MPEG_VIDEO_HEVC_LEVEL_5    */ 50,
> > +		/* V4L2_MPEG_VIDEO_HEVC_LEVEL_5_1  */ 51,
> > +		/* V4L2_MPEG_VIDEO_HEVC_LEVEL_5_2  */ 52,
> > +		/* V4L2_MPEG_VIDEO_HEVC_LEVEL_6    */ 60,
> > +		/* V4L2_MPEG_VIDEO_HEVC_LEVEL_6_1  */ 61,
> > +		/* V4L2_MPEG_VIDEO_HEVC_LEVEL_6_2  */ 62,
> > +	};
> > +	return t[lvl];
> > +}
> > +
> >  static inline int vui_sar_idc(enum v4l2_mpeg_video_h264_vui_sar_idc sar)
> >  {
> >  	static unsigned int t[V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_EXTENDED + 1] = {
> > @@ -1635,6 +2023,139 @@ static int s5p_mfc_enc_s_ctrl(struct v4l2_ctrl *ctrl)
> >  	case V4L2_CID_MPEG_VIDEO_VPX_PROFILE:
> >  		p->codec.vp8.profile = ctrl->val;
> >  		break;
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_I_FRAME_QP:
> > +		p->codec.hevc.rc_frame_qp = ctrl->val;
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_P_FRAME_QP:
> > +		p->codec.hevc.rc_p_frame_qp = ctrl->val;
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_B_FRAME_QP:
> > +		p->codec.hevc.rc_b_frame_qp = ctrl->val;
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_FRAME_RATE_RESOLUTION:
> > +		p->codec.hevc.rc_framerate = ctrl->val;
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_MIN_QP:
> > +		p->codec.hevc.rc_min_qp = ctrl->val;
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_MAX_QP:
> > +		p->codec.hevc.rc_max_qp = ctrl->val;
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_LEVEL:
> > +		p->codec.hevc.level_v4l2 = ctrl->val;
> > +		p->codec.hevc.level = hevc_level(ctrl->val);
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_PROFILE:
> > +		switch (ctrl->val) {
> > +		case V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN:
> > +			p->codec.hevc.profile =
> > +				V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN;
> > +			break;
> > +		case V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN_STILL_PICTURE:
> > +			p->codec.hevc.profile =
> > +			V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN_STILL_PICTURE;
> > +			break;
> > +		default:
> > +			ret = -EINVAL;
> > +		}
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_TIER_FLAG:
> > +		p->codec.hevc.tier_flag = ctrl->val;
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_MAX_PARTITION_DEPTH:
> > +		p->codec.hevc.max_partition_depth = ctrl->val;
> > +		break;
> > +	case V4L2_CID_MPEG_MFC10_VIDEO_HEVC_REF_NUMBER_FOR_PFRAMES:
> > +		p->codec.hevc.num_refs_for_p = ctrl->val;
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_TYPE:
> > +		p->codec.hevc.refreshtype = ctrl->val;
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_CONST_INTRA_PRED:
> > +		p->codec.hevc.const_intra_period_enable = ctrl->val;
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_LOSSLESS_CU:
> > +		p->codec.hevc.lossless_cu_enable = ctrl->val;
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_WAVEFRONT:
> > +		p->codec.hevc.wavefront_enable = ctrl->val;
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_LF:
> > +		p->codec.hevc.loopfilter_disable = (ctrl->val ^ 1);
> 
> Yuck. Just do !ctrl->val. Ditto below.
> 
I will correct it.

> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_LF_SLICE_BOUNDARY:
> > +		p->codec.hevc.loopfilter_across = ctrl->val;
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_QP:
> > +		p->codec.hevc.hier_qp_enable = ctrl->val;
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_TYPE:
> > +		p->codec.hevc.hier_qp_type = ctrl->val;
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER:
> > +		p->codec.hevc.num_hier_layer = ctrl->val;
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER_QP:
> > +		p->codec.hevc.hier_qp_layer[(ctrl->val >> 16) & 0x7]
> > +					= ctrl->val & 0xFF;
> 
> Yuck. I'll discuss this in the documentation patch.
> 
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L0_BR:
> > +		p->codec.hevc.hier_bit_layer[0] = ctrl->val;
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L1_BR:
> > +		p->codec.hevc.hier_bit_layer[1] = ctrl->val;
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L2_BR:
> > +		p->codec.hevc.hier_bit_layer[2] = ctrl->val;
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L3_BR:
> > +		p->codec.hevc.hier_bit_layer[3] = ctrl->val;
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L4_BR:
> > +		p->codec.hevc.hier_bit_layer[4] = ctrl->val;
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L5_BR:
> > +		p->codec.hevc.hier_bit_layer[5] = ctrl->val;
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L6_BR:
> > +		p->codec.hevc.hier_bit_layer[6] = ctrl->val;
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_GENERAL_PB:
> > +		p->codec.hevc.general_pb_enable = ctrl->val;
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_TEMPORAL_ID:
> > +		p->codec.hevc.temporal_id_enable = ctrl->val;
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_STRONG_SMOOTHING:
> > +		p->codec.hevc.strong_intra_smooth = ctrl->val;
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_INTRA_PU_SPLIT:
> > +		p->codec.hevc.intra_pu_split_disable = ctrl->val;
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_TMV_PREDICTION:
> > +		p->codec.hevc.tmv_prediction_disable = (ctrl->val ^ 1);
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_MAX_NUM_MERGE_MV_MINUS1:
> > +		p->codec.hevc.max_num_merge_mv = ctrl->val;
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_WITHOUT_STARTCODE:
> > +		p->codec.hevc.encoding_nostartcode_enable = ctrl->val;
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_PERIOD:
> > +		p->codec.hevc.refreshperiod = ctrl->val;
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_LF_BETA_OFFSET_DIV2:
> > +		p->codec.hevc.lf_beta_offset_div2 = ctrl->val;
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_LF_TC_OFFSET_DIV2:
> > +		p->codec.hevc.lf_tc_offset_div2 = ctrl->val;
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_SIZE_OF_LENGTH_FIELD:
> > +		p->codec.hevc.size_of_length_field = ctrl->val;
> > +		break;
> > +	case V4L2_CID_MPEG_MFC10_VIDEO_HEVC_PREPEND_SPSPPS_TO_IDR:
> > +		p->codec.hevc.prepend_sps_pps_to_idr = ctrl->val;
> > +		break;
> >  	default:
> >  		v4l2_err(&dev->v4l2_dev, "Invalid control, id=%d, val=%d\n",
> >  							ctrl->id, ctrl->val);
> 
> Regards,
> 
> 	Hans
> 
> 
Thank you for the review.
Regards,
Smitha
> 
