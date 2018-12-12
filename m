Return-Path: <SRS0=2Dg0=OV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,T_MIXED_ES,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99A29C04EB8
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 12:51:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 593E620849
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 12:51:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 593E620849
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=bootlin.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727520AbeLLMvs (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 12 Dec 2018 07:51:48 -0500
Received: from mail.bootlin.com ([62.4.15.54]:35097 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727476AbeLLMvq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Dec 2018 07:51:46 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id 4662520726; Wed, 12 Dec 2018 13:51:43 +0100 (CET)
Received: from aptenodytes (aaubervilliers-681-1-89-7.w90-88.abo.wanadoo.fr [90.88.30.7])
        by mail.bootlin.com (Postfix) with ESMTPSA id DB1A32039F;
        Wed, 12 Dec 2018 13:51:42 +0100 (CET)
Message-ID: <ffe9c81db34b599f675ca5bbf02de360bf0a1608.camel@bootlin.com>
Subject: Re: [linux-sunxi] [PATCH v2 1/2] media: v4l: Add definitions for
 the HEVC slice format and controls
From:   Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To:     Jernej =?UTF-8?Q?=C5=A0krabec?= <jernej.skrabec@gmail.com>,
        linux-sunxi@googlegroups.com
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-arm-kernel@lists.infradead.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Randy Li <ayaka@soulik.info>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Date:   Wed, 12 Dec 2018 13:51:43 +0100
In-Reply-To: <5515174.7lFZcYkk85@jernej-laptop>
References: <20181123130209.11696-1-paul.kocialkowski@bootlin.com>
         <20181123130209.11696-2-paul.kocialkowski@bootlin.com>
         <5515174.7lFZcYkk85@jernej-laptop>
Organization: Bootlin
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

On Wed, 2018-12-05 at 21:59 +0100, Jernej Škrabec wrote:
> Hi!
> 
> Dne petek, 23. november 2018 ob 14:02:08 CET je Paul Kocialkowski napisal(a):
> > This introduces the required definitions for HEVC decoding support with
> > stateless VPUs. The controls associated to the HEVC slice format provide
> > the required meta-data for decoding slices extracted from the bitstream.
> > 
> > This interface comes with the following limitations:
> > * No custom quantization matrices (scaling lists);
> > * Support for a single temporal layer only;
> > * No slice entry point offsets support;
> > * No conformance window support;
> > * No VUI parameters support;
> > * No support for SPS extensions: range, multilayer, 3d, scc, 4 bits;
> > * No support for PPS extensions: range, multilayer, 3d, scc, 4 bits.
> > 
> > Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> > ---
> 
> <snip>
> 
> > diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c
> > b/drivers/media/v4l2-core/v4l2-ctrls.c index e96c453208e8..9af17815ecc3
> > 100644
> > --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> > +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> > @@ -913,6 +913,9 @@ const char *v4l2_ctrl_get_name(u32 id)
> >  	case V4L2_CID_MPEG_VIDEO_HEVC_SIZE_OF_LENGTH_FIELD:	return "HEVC Size of
> > Length Field"; case V4L2_CID_MPEG_VIDEO_REF_NUMBER_FOR_PFRAMES:	return
> > "Reference Frames for a P-Frame"; case
> > V4L2_CID_MPEG_VIDEO_PREPEND_SPSPPS_TO_IDR:		return "Prepend SPS and PPS 
> to
> > IDR"; +	case V4L2_CID_MPEG_VIDEO_HEVC_SPS:			return "HEVC Sequence
> > Parameter Set"; +	case V4L2_CID_MPEG_VIDEO_HEVC_PPS:			return "HEVC 
> Picture
> > Parameter Set"; +	case V4L2_CID_MPEG_VIDEO_HEVC_SLICE_PARAMS:		return 
> "HEVC
> > Slice Parameters";
> > 
> >  	/* CAMERA controls */
> >  	/* Keep the order of the 'case's the same as in v4l2-controls.h! */
> > @@ -1320,6 +1323,15 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum
> > v4l2_ctrl_type *type, case V4L2_CID_MPEG_VIDEO_H264_DECODE_PARAMS:
> >  		*type = V4L2_CTRL_TYPE_H264_DECODE_PARAMS;
> >  		break;
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_SPS:
> > +		*type = V4L2_CTRL_TYPE_HEVC_SPS;
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_PPS:
> > +		*type = V4L2_CTRL_TYPE_HEVC_PPS;
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_HEVC_SLICE_PARAMS:
> > +		*type = V4L2_CTRL_TYPE_HEVC_SLICE_PARAMS;
> > +		break;
> >  	default:
> >  		*type = V4L2_CTRL_TYPE_INTEGER;
> >  		break;
> > @@ -1692,6 +1704,11 @@ static int std_validate(const struct v4l2_ctrl *ctrl,
> > u32 idx, case V4L2_CTRL_TYPE_H264_DECODE_PARAMS:
> >  		return 0;
> > 
> > +	case V4L2_CTRL_TYPE_HEVC_SPS:
> > +	case V4L2_CTRL_TYPE_HEVC_PPS:
> > +	case V4L2_CTRL_TYPE_HEVC_SLICE_PARAMS:
> > +		return 0;
> > +
> >  	default:
> >  		return -EINVAL;
> >  	}
> > @@ -2287,6 +2304,15 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct
> > v4l2_ctrl_handler *hdl, case V4L2_CTRL_TYPE_H264_DECODE_PARAMS:
> >  		elem_size = sizeof(struct v4l2_ctrl_h264_decode_param);
> >  		break;
> > +	case V4L2_CTRL_TYPE_HEVC_SPS:
> > +		elem_size = sizeof(struct v4l2_ctrl_hevc_sps);
> > +		break;
> > +	case V4L2_CTRL_TYPE_HEVC_PPS:
> > +		elem_size = sizeof(struct v4l2_ctrl_hevc_pps);
> > +		break;
> > +	case V4L2_CTRL_TYPE_HEVC_SLICE_PARAMS:
> > +		elem_size = sizeof(struct v4l2_ctrl_hevc_slice_params);
> > +		break;
> >  	default:
> >  		if (type < V4L2_CTRL_COMPOUND_TYPES)
> >  			elem_size = sizeof(s32);
> > diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c
> > b/drivers/media/v4l2-core/v4l2-ioctl.c index aa63f1794272..7bec91c6effe
> > 100644
> > --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> > +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> > @@ -1321,6 +1321,7 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
> > case V4L2_PIX_FMT_VP8:		descr = "VP8"; break;
> >  		case V4L2_PIX_FMT_VP9:		descr = "VP9"; break;
> >  		case V4L2_PIX_FMT_HEVC:		descr = "HEVC"; break; /* aka H.265 */
> > +		case V4L2_PIX_FMT_HEVC_SLICE:	descr = "HEVC Parsed Slice Data"; break;
> >  		case V4L2_PIX_FMT_FWHT:		descr = "FWHT"; break; /* used in vicodec */
> >  		case V4L2_PIX_FMT_CPIA1:	descr = "GSPCA CPiA YUV"; break;
> >  		case V4L2_PIX_FMT_WNVA:		descr = "WNVA"; break;
> > diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
> > index b4ca95710d2d..11664c5c3706 100644
> > --- a/include/media/v4l2-ctrls.h
> > +++ b/include/media/v4l2-ctrls.h
> > @@ -48,6 +48,9 @@ struct poll_table_struct;
> >   * @p_h264_scal_mtrx:		Pointer to a struct 
> v4l2_ctrl_h264_scaling_matrix.
> >   * @p_h264_slice_param:		Pointer to a struct v4l2_ctrl_h264_slice_param.
> >   * @p_h264_decode_param:	Pointer to a struct v4l2_ctrl_h264_decode_param.
> > + * @p_hevc_sps:			Pointer to an HEVC sequence parameter set structure.
> > + * @p_hevc_pps:			Pointer to an HEVC picture parameter set structure.
> > + * @p_hevc_slice_params		Pointer to an HEVC slice parameters structure.
> >   * @p:				Pointer to a compound value.
> >   */
> >  union v4l2_ctrl_ptr {
> > @@ -64,6 +67,9 @@ union v4l2_ctrl_ptr {
> >  	struct v4l2_ctrl_h264_scaling_matrix *p_h264_scal_mtrx;
> >  	struct v4l2_ctrl_h264_slice_param *p_h264_slice_param;
> >  	struct v4l2_ctrl_h264_decode_param *p_h264_decode_param;
> > +	struct v4l2_ctrl_hevc_sps *p_hevc_sps;
> > +	struct v4l2_ctrl_hevc_pps *p_hevc_pps;
> > +	struct v4l2_ctrl_hevc_slice_params *p_hevc_slice_params;
> >  	void *p;
> >  };
> > 
> > diff --git a/include/uapi/linux/v4l2-controls.h
> > b/include/uapi/linux/v4l2-controls.h index 628c0cdb51d9..5bbf63b2dad1
> > 100644
> > --- a/include/uapi/linux/v4l2-controls.h
> > +++ b/include/uapi/linux/v4l2-controls.h
> > @@ -709,6 +709,9 @@ enum v4l2_cid_mpeg_video_hevc_size_of_length_field {
> >  #define V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L6_BR	(V4L2_CID_MPEG_BASE +
> > 642) #define V4L2_CID_MPEG_VIDEO_REF_NUMBER_FOR_PFRAMES	(V4L2_CID_MPEG_BASE
> > + 643) #define
> > V4L2_CID_MPEG_VIDEO_PREPEND_SPSPPS_TO_IDR	(V4L2_CID_MPEG_BASE + 644)
> > +#define V4L2_CID_MPEG_VIDEO_HEVC_SPS			(V4L2_CID_MPEG_BASE + 645) 
> +#define
> > V4L2_CID_MPEG_VIDEO_HEVC_PPS			(V4L2_CID_MPEG_BASE + 646) +#define
> > V4L2_CID_MPEG_VIDEO_HEVC_SLICE_PARAMS		(V4L2_CID_MPEG_BASE + 647)
> > 
> >  /*  MPEG-class control IDs specific to the CX2341x driver as defined by
> > V4L2 */ #define V4L2_CID_MPEG_CX2341X_BASE				(V4L2_CTRL_CLASS_MPEG |
> > 0x1000) @@ -1324,4 +1327,156 @@ struct v4l2_ctrl_h264_decode_param {
> >  	struct v4l2_h264_dpb_entry dpb[16];
> >  };
> > 
> > +#define V4L2_HEVC_SLICE_TYPE_B	0
> > +#define V4L2_HEVC_SLICE_TYPE_P	1
> > +#define V4L2_HEVC_SLICE_TYPE_I	2
> > +
> > +struct v4l2_ctrl_hevc_sps {
> > +	/* ISO/IEC 23008-2, ITU-T Rec. H.265: Sequence parameter set */
> > +	__u8	chroma_format_idc;
> > +	__u8	separate_colour_plane_flag;
> > +	__u16	pic_width_in_luma_samples;
> > +	__u16	pic_height_in_luma_samples;
> > +	__u8	bit_depth_luma_minus8;
> > +	__u8	bit_depth_chroma_minus8;
> > +	__u8	log2_max_pic_order_cnt_lsb_minus4;
> > +	__u8	sps_max_dec_pic_buffering_minus1;
> > +	__u8	sps_max_num_reorder_pics;
> > +	__u8	sps_max_latency_increase_plus1;
> > +	__u8	log2_min_luma_coding_block_size_minus3;
> > +	__u8	log2_diff_max_min_luma_coding_block_size;
> > +	__u8	log2_min_luma_transform_block_size_minus2;
> > +	__u8	log2_diff_max_min_luma_transform_block_size;
> > +	__u8	max_transform_hierarchy_depth_inter;
> > +	__u8	max_transform_hierarchy_depth_intra;
> > +	__u8	scaling_list_enabled_flag;
> > +	__u8	amp_enabled_flag;
> > +	__u8	sample_adaptive_offset_enabled_flag;
> > +	__u8	pcm_enabled_flag;
> > +	__u8	pcm_sample_bit_depth_luma_minus1;
> > +	__u8	pcm_sample_bit_depth_chroma_minus1;
> > +	__u8	log2_min_pcm_luma_coding_block_size_minus3;
> > +	__u8	log2_diff_max_min_pcm_luma_coding_block_size;
> > +	__u8	pcm_loop_filter_disabled_flag;
> > +	__u8	num_short_term_ref_pic_sets;
> > +	__u8	long_term_ref_pics_present_flag;
> > +	__u8	num_long_term_ref_pics_sps;
> > +	__u8	sps_temporal_mvp_enabled_flag;
> > +	__u8	strong_intra_smoothing_enabled_flag;
> > +};
> > +
> > +struct v4l2_ctrl_hevc_pps {
> > +	/* ISO/IEC 23008-2, ITU-T Rec. H.265: Picture parameter set */
> > +	__u8	dependent_slice_segment_flag;
> > +	__u8	output_flag_present_flag;
> > +	__u8	num_extra_slice_header_bits;
> > +	__u8	sign_data_hiding_enabled_flag;
> > +	__u8	cabac_init_present_flag;
> > +	__s8	init_qp_minus26;
> > +	__u8	constrained_intra_pred_flag;
> > +	__u8	transform_skip_enabled_flag;
> > +	__u8	cu_qp_delta_enabled_flag;
> > +	__u8	diff_cu_qp_delta_depth;
> > +	__s8	pps_cb_qp_offset;
> > +	__s8	pps_cr_qp_offset;
> > +	__u8	pps_slice_chroma_qp_offsets_present_flag;
> > +	__u8	weighted_pred_flag;
> > +	__u8	weighted_bipred_flag;
> > +	__u8	transquant_bypass_enabled_flag;
> > +	__u8	tiles_enabled_flag;
> > +	__u8	entropy_coding_sync_enabled_flag;
> > +	__u8	num_tile_columns_minus1;
> > +	__u8	num_tile_rows_minus1;
> > +	__u8	column_width_minus1[20];
> > +	__u8	row_height_minus1[22];
> > +	__u8	loop_filter_across_tiles_enabled_flag;
> > +	__u8	pps_loop_filter_across_slices_enabled_flag;
> > +	__u8	deblocking_filter_override_enabled_flag;
> > +	__u8	pps_disable_deblocking_filter_flag;
> > +	__s8	pps_beta_offset_div2;
> > +	__s8	pps_tc_offset_div2;
> > +	__u8	lists_modification_present_flag;
> > +	__u8	log2_parallel_merge_level_minus2;
> > +	__u8	slice_segment_header_extension_present_flag;
> > +};
> 
> Although scaling lists are not supported yet, I still think you should include 
> "scaling_list_data_present_flag" here for the sake of completeness and you 
> already included "scaling_list_enable_flag" in SPS.
> 
> I didn't do any thorough review though, just noticed this bit.

Thanks for suggestion! I decided to discard these
"scaling_list_data_present_flag" fields because I think it's best to
have a dedicated control for the scaling list (like in the current
H.264 proposal). With a dedicated control, scaling lists are no longer
attached to either the PPS or SPS so I don't think it makes sense to
have "scaling_list_data_present_flag" fields in these structures.

Drivers can just infer whether custom scaling lists are used or not
with the presence of the optional control and they don't need to know
if it was originally extracted from the PPS or SPS.

Does that make sense to you?

Cheers,

Paul

> Best regards,
> Jernej
> 
> > +
> > +#define V4L2_HEVC_DPB_ENTRY_RPS_ST_CURR_BEFORE	0x01
> > +#define V4L2_HEVC_DPB_ENTRY_RPS_ST_CURR_AFTER	0x02
> > +#define V4L2_HEVC_DPB_ENTRY_RPS_LT_CURR		0x03
> > +
> > +#define V4L2_HEVC_DPB_ENTRIES_NUM_MAX		16
> > +
> > +struct v4l2_hevc_dpb_entry {
> > +	__u32	buffer_tag;
> > +	__u8	rps;
> > +	__u8	field_pic;
> > +	__u16	pic_order_cnt[2];
> > +};
> > +
> > +struct v4l2_hevc_pred_weight_table {
> > +	__u8	luma_log2_weight_denom;
> > +	__s8	delta_chroma_log2_weight_denom;
> > +
> > +	__s8	delta_luma_weight_l0[V4L2_HEVC_DPB_ENTRIES_NUM_MAX];
> > +	__s8	luma_offset_l0[V4L2_HEVC_DPB_ENTRIES_NUM_MAX];
> > +	__s8	delta_chroma_weight_l0[V4L2_HEVC_DPB_ENTRIES_NUM_MAX][2];
> > +	__s8	chroma_offset_l0[V4L2_HEVC_DPB_ENTRIES_NUM_MAX][2];
> > +
> > +	__s8	delta_luma_weight_l1[V4L2_HEVC_DPB_ENTRIES_NUM_MAX];
> > +	__s8	luma_offset_l1[V4L2_HEVC_DPB_ENTRIES_NUM_MAX];
> > +	__s8	delta_chroma_weight_l1[V4L2_HEVC_DPB_ENTRIES_NUM_MAX][2];
> > +	__s8	chroma_offset_l1[V4L2_HEVC_DPB_ENTRIES_NUM_MAX][2];
> > +};
> > +
> > +struct v4l2_ctrl_hevc_slice_params {
> > +	__u32	bit_size;
> > +	__u32	data_bit_offset;
> > +
> > +	/* ISO/IEC 23008-2, ITU-T Rec. H.265: NAL unit header */
> > +	__u8	nal_unit_type;
> > +	__u8	nuh_temporal_id_plus1;
> > +
> > +	/* ISO/IEC 23008-2, ITU-T Rec. H.265: General slice segment header */
> > +	__u8	slice_type;
> > +	__u8	colour_plane_id;
> > +	__u16	slice_pic_order_cnt;
> > +	__u8	slice_sao_luma_flag;
> > +	__u8	slice_sao_chroma_flag;
> > +	__u8	slice_temporal_mvp_enabled_flag;
> > +	__u8	num_ref_idx_l0_active_minus1;
> > +	__u8	num_ref_idx_l1_active_minus1;
> > +	__u8	mvd_l1_zero_flag;
> > +	__u8	cabac_init_flag;
> > +	__u8	collocated_from_l0_flag;
> > +	__u8	collocated_ref_idx;
> > +	__u8	five_minus_max_num_merge_cand;
> > +	__u8	use_integer_mv_flag;
> > +	__s8	slice_qp_delta;
> > +	__s8	slice_cb_qp_offset;
> > +	__s8	slice_cr_qp_offset;
> > +	__s8	slice_act_y_qp_offset;
> > +	__s8	slice_act_cb_qp_offset;
> > +	__s8	slice_act_cr_qp_offset;
> > +	__u8	slice_deblocking_filter_disabled_flag;
> > +	__s8	slice_beta_offset_div2;
> > +	__s8	slice_tc_offset_div2;
> > +	__u8	slice_loop_filter_across_slices_enabled_flag;
> > +
> > +	/* ISO/IEC 23008-2, ITU-T Rec. H.265: Picture timing SEI message */
> > +	__u8	pic_struct;
> > +
> > +	/* ISO/IEC 23008-2, ITU-T Rec. H.265: General slice segment header */
> > +	struct v4l2_hevc_dpb_entry dpb[V4L2_HEVC_DPB_ENTRIES_NUM_MAX];
> > +	__u8	num_active_dpb_entries;
> > +	__u8	ref_idx_l0[V4L2_HEVC_DPB_ENTRIES_NUM_MAX];
> > +	__u8	ref_idx_l1[V4L2_HEVC_DPB_ENTRIES_NUM_MAX];
> > +
> > +	__u8	num_rps_poc_st_curr_before;
> > +	__u8	num_rps_poc_st_curr_after;
> > +	__u8	num_rps_poc_lt_curr;
> > +
> > +	/* ISO/IEC 23008-2, ITU-T Rec. H.265: Weighted prediction parameter */
> > +	struct v4l2_hevc_pred_weight_table pred_weight_table;
> > +};
> > +
> >  #endif
> 
> 
-- 
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com

