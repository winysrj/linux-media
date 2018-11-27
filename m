Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:55103 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729254AbeK0TSg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Nov 2018 14:18:36 -0500
Date: Tue, 27 Nov 2018 09:21:19 +0100
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-arm-kernel@lists.infradead.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-sunxi@googlegroups.com, Randy Li <ayaka@soulik.info>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH v2 2/2] media: cedrus: Add HEVC/H.265 decoding support
Message-ID: <20181127082119.xdemdwgclai7kj3r@flea>
References: <20181123130209.11696-1-paul.kocialkowski@bootlin.com>
 <20181123130209.11696-3-paul.kocialkowski@bootlin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="gq2wygf7bjzac7jz"
Content-Disposition: inline
In-Reply-To: <20181123130209.11696-3-paul.kocialkowski@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--gq2wygf7bjzac7jz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

On Fri, Nov 23, 2018 at 02:02:09PM +0100, Paul Kocialkowski wrote:
> This introduces support for HEVC/H.265 to the Cedrus VPU driver, with
> both uni-directional and bi-directional prediction modes supported.
>=20
> Field-coded (interlaced) pictures, custom quantization matrices and
> 10-bit output are not supported at this point.
>=20
> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

Output from checkpatch:
total: 0 errors, 68 warnings, 14 checks, 999 lines checked

> +/*
> + * Note: Neighbor info buffer size is apparently doubled for H6, which m=
ay be
> + * related to 10 bit H265 support.
> + */
> +#define CEDRUS_H265_NEIGHBOR_INFO_BUF_SIZE	(397 * SZ_1K)
> +#define CEDRUS_H265_ENTRY_POINTS_BUF_SIZE	(4 * SZ_1K)
> +#define CEDRUS_H265_MV_COL_BUF_UNIT_CTB_SIZE	160

Having some information on where this is coming from would be useful.

> +static void cedrus_h265_sram_write_data(struct cedrus_dev *dev, u32 *dat=
a,

Since the data pointer is pretty much an opaque structure, you should
have a void pointer here, that would avoid the type casting you're
doing when calling that function.

> +					unsigned int count)
> +{
> +	while (count--)
> +		cedrus_write(dev, VE_DEC_H265_SRAM_DATA, *data++);
> +}
> +
> +static inline dma_addr_t cedrus_h265_frame_info_mv_col_buf_addr(
> +	struct cedrus_ctx *ctx, unsigned int index, unsigned int field)
> +{
> +	return ctx->codec.h265.mv_col_buf_addr + index *
> +	       ctx->codec.h265.mv_col_buf_unit_size +
> +	       field * ctx->codec.h265.mv_col_buf_unit_size / 2;
> +}
> +
> +static void cedrus_h265_frame_info_write_single(struct cedrus_dev *dev,
> +						unsigned int index,
> +						bool field_pic,
> +						u32 pic_order_cnt[],
> +						dma_addr_t mv_col_buf_addr[],
> +						dma_addr_t dst_luma_addr,
> +						dma_addr_t dst_chroma_addr)
> +{
> +	u32 offset =3D VE_DEC_H265_SRAM_OFFSET_FRAME_INFO +
> +		     VE_DEC_H265_SRAM_OFFSET_FRAME_INFO_UNIT * index;
> +	struct cedrus_h265_sram_frame_info frame_info =3D {
> +		.top_pic_order_cnt =3D pic_order_cnt[0],
> +		.bottom_pic_order_cnt =3D field_pic ? pic_order_cnt[1] :
> +					pic_order_cnt[0],
> +		.top_mv_col_buf_addr =3D
> +			VE_DEC_H265_SRAM_DATA_ADDR_BASE(mv_col_buf_addr[0]),
> +		.bottom_mv_col_buf_addr =3D field_pic ?
> +			VE_DEC_H265_SRAM_DATA_ADDR_BASE(mv_col_buf_addr[1]) :
> +			VE_DEC_H265_SRAM_DATA_ADDR_BASE(mv_col_buf_addr[0]),
> +		.luma_addr =3D VE_DEC_H265_SRAM_DATA_ADDR_BASE(dst_luma_addr),
> +		.chroma_addr =3D VE_DEC_H265_SRAM_DATA_ADDR_BASE(dst_chroma_addr),
> +	};
> +	unsigned int count =3D sizeof(frame_info) / sizeof(u32);
> +
> +	cedrus_h265_sram_write_offset(dev, offset);
> +	cedrus_h265_sram_write_data(dev, (u32 *)&frame_info, count);

Usually, any generic write function will have its size passed in bytes.

> +}
> +
> +static void cedrus_h265_frame_info_write_dpb(struct cedrus_ctx *ctx,
> +					     const struct v4l2_hevc_dpb_entry *dpb,
> +					     u8 num_active_dpb_entries)
> +{
> +	struct cedrus_dev *dev =3D ctx->dev;
> +	struct vb2_queue *cap_q =3D &ctx->fh.m2m_ctx->cap_q_ctx.q;
> +	unsigned int i;
> +
> +	for (i =3D 0; i < num_active_dpb_entries; i++) {
> +		dma_addr_t dst_luma_addr, dst_chroma_addr;
> +		dma_addr_t mv_col_buf_addr[2];
> +		u32 pic_order_cnt[2];
> +		int buffer_index =3D vb2_find_tag(cap_q, dpb[i].buffer_tag, 0);
> +
> +		dst_luma_addr =3D cedrus_dst_buf_addr(ctx, buffer_index, 0) -
> +						    PHYS_OFFSET;
> +		dst_chroma_addr =3D cedrus_dst_buf_addr(ctx, buffer_index, 1) -
> +						      PHYS_OFFSET;
> +		mv_col_buf_addr[0] =3D cedrus_h265_frame_info_mv_col_buf_addr(ctx,
> +			buffer_index, 0) - PHYS_OFFSET;

The PHYS_OFFSET part should be part of
cedrus_h265_frame_info_mv_col_buf_addr.

> +		pic_order_cnt[0] =3D dpb[i].pic_order_cnt[0];
> +
> +		if (dpb[i].field_pic) {
> +			mv_col_buf_addr[1] =3D
> +				cedrus_h265_frame_info_mv_col_buf_addr(ctx,
> +				buffer_index, 1) - PHYS_OFFSET;
> +			pic_order_cnt[1] =3D dpb[i].pic_order_cnt[1];
> +		}
> +
> +		cedrus_h265_frame_info_write_single(dev, i, dpb[i].field_pic,
> +						    pic_order_cnt,
> +						    mv_col_buf_addr,
> +						    dst_luma_addr,
> +						    dst_chroma_addr);
> +	}
> +}
> +
> +static void cedrus_h265_ref_pic_list_write(struct cedrus_dev *dev,
> +					   const u8 list[],
> +					   u8 num_ref_idx_active,
> +					   const struct v4l2_hevc_dpb_entry *dpb,
> +					   u8 num_active_dpb_entries,
> +					   u32 sram_offset)
> +{
> +	unsigned int i;
> +	u32 reg =3D 0;
> +
> +	cedrus_h265_sram_write_offset(dev, sram_offset);
> +
> +	for (i =3D 0; i < num_ref_idx_active; i++) {
> +		unsigned int shift =3D (i % 4) * 8;
> +		unsigned int index =3D list[i];
> +		u8 value =3D list[i];
> +
> +		if (dpb[index].rps =3D=3D V4L2_HEVC_DPB_ENTRY_RPS_LT_CURR)
> +			value |=3D VE_DEC_H265_SRAM_REF_PIC_LIST_LT_REF;
> +
> +		reg |=3D value << shift;
> +
> +		if ((i % 4) =3D=3D 3 || i =3D=3D (num_ref_idx_active - 1)) {
> +			cedrus_h265_sram_write_data(dev, &reg, 1);
> +			reg =3D 0;
> +		}

A comment here explaining what you're doing with reg would be nice.

> +	}
> +}
> +
> +static void cedrus_h265_pred_weight_write(struct cedrus_dev *dev,
> +					  const s8 delta_luma_weight[],
> +					  const s8 luma_offset[],
> +					  const s8 delta_chroma_weight[][2],
> +					  const s8 chroma_offset[][2],
> +					  u8 num_ref_idx_active,
> +					  u32 sram_luma_offset,
> +					  u32 sram_chroma_offset)
> +{
> +	struct cedrus_h265_sram_pred_weight pred_weight[2] =3D { 0 };
> +	unsigned int i, j;
> +
> +	cedrus_h265_sram_write_offset(dev, sram_luma_offset);
> +
> +	for (i =3D 0; i < num_ref_idx_active; i++) {
> +		unsigned int index =3D i % 2;
> +
> +		pred_weight[index].delta_weight =3D delta_luma_weight[i];
> +		pred_weight[index].offset =3D luma_offset[i];
> +
> +		if (index =3D=3D 1 || i =3D=3D (num_ref_idx_active - 1))
> +			cedrus_h265_sram_write_data(dev, (u32 *)&pred_weight,
> +						    1);
> +	}
> +
> +	cedrus_h265_sram_write_offset(dev, sram_chroma_offset);
> +
> +	for (i =3D 0; i < num_ref_idx_active; i++) {
> +		for (j =3D 0; j < 2; j++) {
> +			pred_weight[j].delta_weight =3D delta_chroma_weight[i][j];
> +			pred_weight[j].offset =3D chroma_offset[i][j];
> +		}
> +
> +		cedrus_h265_sram_write_data(dev, (u32 *)&pred_weight, 1);
> +	}
> +}
> +
> +static void cedrus_h265_setup(struct cedrus_ctx *ctx,
> +			      struct cedrus_run *run)
> +{
> +	struct cedrus_dev *dev =3D ctx->dev;
> +	const struct v4l2_ctrl_hevc_sps *sps;
> +	const struct v4l2_ctrl_hevc_pps *pps;
> +	const struct v4l2_ctrl_hevc_slice_params *slice_params;
> +	const struct v4l2_hevc_pred_weight_table *pred_weight_table;
> +	dma_addr_t src_buf_addr;
> +	dma_addr_t src_buf_end_addr;
> +	dma_addr_t dst_luma_addr, dst_chroma_addr;
> +	dma_addr_t mv_col_buf_addr[2];
> +	u32 chroma_log2_weight_denom;
> +	u32 output_pic_list_index;
> +	u32 pic_order_cnt[2];
> +	u32 reg;
> +
> +	sps =3D run->h265.sps;
> +	pps =3D run->h265.pps;
> +	slice_params =3D run->h265.slice_params;
> +	pred_weight_table =3D &slice_params->pred_weight_table;
> +
> +	/* MV column buffer size and allocation. */
> +	if (!ctx->codec.h265.mv_col_buf_size) {
> +		unsigned int num_buffers =3D
> +			run->dst->vb2_buf.vb2_queue->num_buffers;
> +		unsigned int log2_max_luma_coding_block_size =3D
> +			sps->log2_min_luma_coding_block_size_minus3 + 3 +
> +			sps->log2_diff_max_min_luma_coding_block_size;
> +		unsigned int ctb_size_luma =3D
> +			1 << log2_max_luma_coding_block_size;
> +
> +		/*
> +		 * Each CTB requires a MV col buffer with a specific unit size.
> +		 * Since the address is given with missing lsb bits, 1 KiB is
> +		 * added to each buffer to ensure proper alignment.
> +		 */
> +		ctx->codec.h265.mv_col_buf_unit_size =3D
> +			DIV_ROUND_UP(ctx->src_fmt.width, ctb_size_luma) *
> +			DIV_ROUND_UP(ctx->src_fmt.height, ctb_size_luma) *
> +			CEDRUS_H265_MV_COL_BUF_UNIT_CTB_SIZE + SZ_1K;
> +
> +		ctx->codec.h265.mv_col_buf_size =3D num_buffers *
> +			ctx->codec.h265.mv_col_buf_unit_size;
> +
> +		ctx->codec.h265.mv_col_buf =3D
> +			dma_alloc_coherent(dev->dev,
> +					   ctx->codec.h265.mv_col_buf_size,
> +					   &ctx->codec.h265.mv_col_buf_addr,
> +					   GFP_KERNEL);
> +		if (!ctx->codec.h265.mv_col_buf) {
> +			ctx->codec.h265.mv_col_buf_size =3D 0;
> +			// TODO: Abort the process here.
> +			return;
> +		}
> +	}
> +
> +	/* Activate H265 engine. */
> +	cedrus_engine_enable(dev, CEDRUS_CODEC_H265);
> +
> +	/* Source offset and length in bits. */
> +
> +	reg =3D slice_params->data_bit_offset;
> +	cedrus_write(dev, VE_DEC_H265_BITS_OFFSET, reg);
> +
> +	reg =3D slice_params->bit_size - slice_params->data_bit_offset;
> +	cedrus_write(dev, VE_DEC_H265_BITS_LEN, reg);
> +
> +	/* Source beginning and end addresses. */
> +
> +	src_buf_addr =3D vb2_dma_contig_plane_dma_addr(&run->src->vb2_buf, 0) -
> +		       PHYS_OFFSET;
> +
> +	reg =3D VE_DEC_H265_BITS_ADDR_BASE(src_buf_addr);
> +	reg |=3D VE_DEC_H265_BITS_ADDR_VALID_SLICE_DATA;
> +	reg |=3D VE_DEC_H265_BITS_ADDR_LAST_SLICE_DATA;
> +	reg |=3D VE_DEC_H265_BITS_ADDR_FIRST_SLICE_DATA;
> +
> +	cedrus_write(dev, VE_DEC_H265_BITS_ADDR, reg);
> +
> +	src_buf_end_addr =3D src_buf_addr +
> +			   DIV_ROUND_UP(slice_params->bit_size, 8);
> +
> +	reg =3D VE_DEC_H265_BITS_END_ADDR_BASE(src_buf_end_addr);
> +	cedrus_write(dev, VE_DEC_H265_BITS_END_ADDR, reg);
> +
> +	/* Coding tree block address: start at the beginning. */
> +	reg =3D VE_DEC_H265_DEC_CTB_ADDR_X(0) | VE_DEC_H265_DEC_CTB_ADDR_Y(0);
> +	cedrus_write(dev, VE_DEC_H265_DEC_CTB_ADDR, reg);
> +
> +	cedrus_write(dev, VE_DEC_H265_TILE_START_CTB, 0);
> +	cedrus_write(dev, VE_DEC_H265_TILE_END_CTB, 0);
> +
> +	/* Clear the number of correctly-decoded coding tree blocks. */
> +	cedrus_write(dev, VE_DEC_H265_DEC_CTB_NUM, 0);
> +
> +	/* Initialize bitstream access. */
> +	cedrus_write(dev, VE_DEC_H265_TRIGGER, VE_DEC_H265_TRIGGER_INIT_SWDEC);
> +
> +	/* Bitstream parameters. */
> +
> +	reg =3D VE_DEC_H265_DEC_NAL_HDR_NAL_UNIT_TYPE(slice_params->nal_unit_ty=
pe) |
> +	      VE_DEC_H265_DEC_NAL_HDR_NUH_TEMPORAL_ID_PLUS1(slice_params->nuh_t=
emporal_id_plus1);
> +
> +	cedrus_write(dev, VE_DEC_H265_DEC_NAL_HDR, reg);
> +
> +	reg =3D VE_DEC_H265_DEC_SPS_HDR_STRONG_INTRA_SMOOTHING_ENABLE_FLAG(sps-=
>strong_intra_smoothing_enabled_flag) |
> +	      VE_DEC_H265_DEC_SPS_HDR_SPS_TEMPORAL_MVP_ENABLED_FLAG(sps->sps_te=
mporal_mvp_enabled_flag) |
> +	      VE_DEC_H265_DEC_SPS_HDR_SAMPLE_ADAPTIVE_OFFSET_ENABLED_FLAG(sps->=
sample_adaptive_offset_enabled_flag) |
> +	      VE_DEC_H265_DEC_SPS_HDR_AMP_ENABLED_FLAG(sps->amp_enabled_flag) |
> +	      VE_DEC_H265_DEC_SPS_HDR_MAX_TRANSFORM_HIERARCHY_DEPTH_INTRA(sps->=
max_transform_hierarchy_depth_intra) |
> +	      VE_DEC_H265_DEC_SPS_HDR_MAX_TRANSFORM_HIERARCHY_DEPTH_INTER(sps->=
max_transform_hierarchy_depth_inter) |
> +	      VE_DEC_H265_DEC_SPS_HDR_LOG2_DIFF_MAX_MIN_TRANSFORM_BLOCK_SIZE(sp=
s->log2_diff_max_min_luma_transform_block_size) |
> +	      VE_DEC_H265_DEC_SPS_HDR_LOG2_MIN_TRANSFORM_BLOCK_SIZE_MINUS2(sps-=
>log2_min_luma_transform_block_size_minus2) |
> +	      VE_DEC_H265_DEC_SPS_HDR_LOG2_DIFF_MAX_MIN_LUMA_CODING_BLOCK_SIZE(=
sps->log2_diff_max_min_luma_coding_block_size) |
> +	      VE_DEC_H265_DEC_SPS_HDR_LOG2_MIN_LUMA_CODING_BLOCK_SIZE_MINUS3(sp=
s->log2_min_luma_coding_block_size_minus3) |
> +	      VE_DEC_H265_DEC_SPS_HDR_BIT_DEPTH_CHROMA_MINUS8(sps->bit_depth_ch=
roma_minus8) |
> +	      VE_DEC_H265_DEC_SPS_HDR_SEPARATE_COLOUR_PLANE_FLAG(sps->separate_=
colour_plane_flag) |
> +	      VE_DEC_H265_DEC_SPS_HDR_CHROMA_FORMAT_IDC(sps->chroma_format_idc);
> +
> +	cedrus_write(dev, VE_DEC_H265_DEC_SPS_HDR, reg);
> +
> +	reg =3D VE_DEC_H265_DEC_PCM_CTRL_PCM_ENABLED_FLAG(sps->pcm_enabled_flag=
) |
> +	      VE_DEC_H265_DEC_PCM_CTRL_PCM_LOOP_FILTER_DISABLED_FLAG(sps->pcm_l=
oop_filter_disabled_flag) |
> +	      VE_DEC_H265_DEC_PCM_CTRL_LOG2_DIFF_MAX_MIN_PCM_LUMA_CODING_BLOCK_=
SIZE(sps->log2_diff_max_min_pcm_luma_coding_block_size) |
> +	      VE_DEC_H265_DEC_PCM_CTRL_LOG2_MIN_PCM_LUMA_CODING_BLOCK_SIZE_MINU=
S3(sps->log2_min_pcm_luma_coding_block_size_minus3) |
> +	      VE_DEC_H265_DEC_PCM_CTRL_PCM_SAMPLE_BIT_DEPTH_CHROMA_MINUS1(sps->=
pcm_sample_bit_depth_chroma_minus1) |
> +	      VE_DEC_H265_DEC_PCM_CTRL_PCM_SAMPLE_BIT_DEPTH_LUMA_MINUS1(sps->pc=
m_sample_bit_depth_luma_minus1);
> +
> +	cedrus_write(dev, VE_DEC_H265_DEC_PCM_CTRL, reg);
> +
> +	reg =3D VE_DEC_H265_DEC_PPS_CTRL0_PPS_CR_QP_OFFSET(pps->pps_cr_qp_offse=
t) |
> +	      VE_DEC_H265_DEC_PPS_CTRL0_PPS_CB_QP_OFFSET(pps->pps_cb_qp_offset)=
 |
> +	      VE_DEC_H265_DEC_PPS_CTRL0_INIT_QP_MINUS26(pps->init_qp_minus26) |
> +	      VE_DEC_H265_DEC_PPS_CTRL0_DIFF_CU_QP_DELTA_DEPTH(pps->diff_cu_qp_=
delta_depth) |
> +	      VE_DEC_H265_DEC_PPS_CTRL0_CU_QP_DELTA_ENABLED_FLAG(pps->cu_qp_del=
ta_enabled_flag) |
> +	      VE_DEC_H265_DEC_PPS_CTRL0_TRANSFORM_SKIP_ENABLED_FLAG(pps->transf=
orm_skip_enabled_flag) |
> +	      VE_DEC_H265_DEC_PPS_CTRL0_CONSTRAINED_INTRA_PRED_FLAG(pps->constr=
ained_intra_pred_flag) |
> +	      VE_DEC_H265_DEC_PPS_CTRL0_SIGN_DATA_HIDING_FLAG(pps->sign_data_hi=
ding_enabled_flag);
> +
> +	cedrus_write(dev, VE_DEC_H265_DEC_PPS_CTRL0, reg);
> +
> +	reg =3D VE_DEC_H265_DEC_PPS_CTRL1_LOG2_PARALLEL_MERGE_LEVEL_MINUS2(pps-=
>log2_parallel_merge_level_minus2) |
> +	      VE_DEC_H265_DEC_PPS_CTRL1_PPS_LOOP_FILTER_ACROSS_SLICES_ENABLED_F=
LAG(pps->pps_loop_filter_across_slices_enabled_flag) |
> +	      VE_DEC_H265_DEC_PPS_CTRL1_LOOP_FILTER_ACROSS_TILES_ENABLED_FLAG(p=
ps->loop_filter_across_tiles_enabled_flag) |
> +	      VE_DEC_H265_DEC_PPS_CTRL1_ENTROPY_CODING_SYNC_ENABLED_FLAG(pps->e=
ntropy_coding_sync_enabled_flag) |
> +	      VE_DEC_H265_DEC_PPS_CTRL1_TILES_ENABLED_FLAG(0) |
> +	      VE_DEC_H265_DEC_PPS_CTRL1_TRANSQUANT_BYPASS_ENABLE_FLAG(pps->tran=
squant_bypass_enabled_flag) |
> +	      VE_DEC_H265_DEC_PPS_CTRL1_WEIGHTED_BIPRED_FLAG(pps->weighted_bipr=
ed_flag) |
> +	      VE_DEC_H265_DEC_PPS_CTRL1_WEIGHTED_PRED_FLAG(pps->weighted_pred_f=
lag);
> +
> +	cedrus_write(dev, VE_DEC_H265_DEC_PPS_CTRL1, reg);
> +
> +	reg =3D VE_DEC_H265_DEC_SLICE_HDR_INFO0_PICTURE_TYPE(slice_params->pic_=
struct) |
> +	      VE_DEC_H265_DEC_SLICE_HDR_INFO0_FIVE_MINUS_MAX_NUM_MERGE_CAND(sli=
ce_params->five_minus_max_num_merge_cand) |
> +	      VE_DEC_H265_DEC_SLICE_HDR_INFO0_NUM_REF_IDX_L1_ACTIVE_MINUS1(slic=
e_params->num_ref_idx_l1_active_minus1) |
> +	      VE_DEC_H265_DEC_SLICE_HDR_INFO0_NUM_REF_IDX_L0_ACTIVE_MINUS1(slic=
e_params->num_ref_idx_l0_active_minus1) |
> +	      VE_DEC_H265_DEC_SLICE_HDR_INFO0_COLLOCATED_REF_IDX(slice_params->=
collocated_ref_idx) |
> +	      VE_DEC_H265_DEC_SLICE_HDR_INFO0_COLLOCATED_FROM_L0_FLAG(slice_par=
ams->collocated_from_l0_flag) |
> +	      VE_DEC_H265_DEC_SLICE_HDR_INFO0_CABAC_INIT_FLAG(slice_params->cab=
ac_init_flag) |
> +	      VE_DEC_H265_DEC_SLICE_HDR_INFO0_MVD_L1_ZERO_FLAG(slice_params->mv=
d_l1_zero_flag) |
> +	      VE_DEC_H265_DEC_SLICE_HDR_INFO0_SLICE_SAO_CHROMA_FLAG(slice_param=
s->slice_sao_chroma_flag) |
> +	      VE_DEC_H265_DEC_SLICE_HDR_INFO0_SLICE_SAO_LUMA_FLAG(slice_params-=
>slice_sao_luma_flag) |
> +	      VE_DEC_H265_DEC_SLICE_HDR_INFO0_SLICE_TEMPORAL_MVP_ENABLE_FLAG(sl=
ice_params->slice_temporal_mvp_enabled_flag) |
> +	      VE_DEC_H265_DEC_SLICE_HDR_INFO0_COLOUR_PLANE_ID(slice_params->col=
our_plane_id) |
> +	      VE_DEC_H265_DEC_SLICE_HDR_INFO0_SLICE_TYPE(slice_params->slice_ty=
pe) |
> +	      VE_DEC_H265_DEC_SLICE_HDR_INFO0_DEPENDENT_SLICE_SEGMENT_FLAG(pps-=
>dependent_slice_segment_flag) |
> +	      VE_DEC_H265_DEC_SLICE_HDR_INFO0_FIRST_SLICE_SEGMENT_IN_PIC_FLAG(1=
);
> +
> +	cedrus_write(dev, VE_DEC_H265_DEC_SLICE_HDR_INFO0, reg);
> +
> +	reg =3D VE_DEC_H265_DEC_SLICE_HDR_INFO1_SLICE_TC_OFFSET_DIV2(slice_para=
ms->slice_tc_offset_div2) |
> +	      VE_DEC_H265_DEC_SLICE_HDR_INFO1_SLICE_BETA_OFFSET_DIV2(slice_para=
ms->slice_beta_offset_div2) |
> +	      VE_DEC_H265_DEC_SLICE_HDR_INFO1_SLICE_DEBLOCKING_FILTER_DISABLED_=
FLAG(slice_params->slice_deblocking_filter_disabled_flag) |
> +	      VE_DEC_H265_DEC_SLICE_HDR_INFO1_SLICE_LOOP_FILTER_ACROSS_SLICES_E=
NABLED_FLAG(slice_params->slice_loop_filter_across_slices_enabled_flag) |
> +	      VE_DEC_H265_DEC_SLICE_HDR_INFO1_SLICE_POC_BIGEST_IN_RPS_ST(slice_=
params->num_rps_poc_st_curr_after =3D=3D 0) |
> +	      VE_DEC_H265_DEC_SLICE_HDR_INFO1_SLICE_CR_QP_OFFSET(slice_params->=
slice_cr_qp_offset) |
> +	      VE_DEC_H265_DEC_SLICE_HDR_INFO1_SLICE_CB_QP_OFFSET(slice_params->=
slice_cb_qp_offset) |
> +	      VE_DEC_H265_DEC_SLICE_HDR_INFO1_SLICE_QP_DELTA(slice_params->slic=
e_qp_delta);
> +
> +	cedrus_write(dev, VE_DEC_H265_DEC_SLICE_HDR_INFO1, reg);
> +
> +	chroma_log2_weight_denom =3D pred_weight_table->luma_log2_weight_denom +
> +				   pred_weight_table->delta_chroma_log2_weight_denom;
> +	reg =3D VE_DEC_H265_DEC_SLICE_HDR_INFO2_NUM_ENTRY_POINT_OFFSETS(0) |
> +	      VE_DEC_H265_DEC_SLICE_HDR_INFO2_CHROMA_LOG2_WEIGHT_DENOM(chroma_l=
og2_weight_denom) |
> +	      VE_DEC_H265_DEC_SLICE_HDR_INFO2_LUMA_LOG2_WEIGHT_DENOM(pred_weigh=
t_table->luma_log2_weight_denom);
> +
> +	cedrus_write(dev, VE_DEC_H265_DEC_SLICE_HDR_INFO2, reg);
> +
> +	/* Decoded picture size. */
> +
> +	reg =3D VE_DEC_H265_DEC_PIC_SIZE_WIDTH(ctx->src_fmt.width) |
> +	      VE_DEC_H265_DEC_PIC_SIZE_HEIGHT(ctx->src_fmt.height);
> +
> +	cedrus_write(dev, VE_DEC_H265_DEC_PIC_SIZE, reg);
> +
> +	/* Scaling list */
> +
> +	reg =3D VE_DEC_H265_SCALING_LIST_CTRL0_DEFAULT;
> +	cedrus_write(dev, VE_DEC_H265_SCALING_LIST_CTRL0, reg);
> +
> +	/* Neightbor information address. */
> +	reg =3D VE_DEC_H265_NEIGHBOR_INFO_ADDR_BASE(ctx->codec.h265.neighbor_in=
fo_buf_addr);
> +	cedrus_write(dev, VE_DEC_H265_NEIGHBOR_INFO_ADDR, reg);
> +
> +	/* Write decoded picture buffer in pic list. */
> +	cedrus_h265_frame_info_write_dpb(ctx, slice_params->dpb,
> +					 slice_params->num_active_dpb_entries);
> +
> +	/* Output frame. */
> +
> +	output_pic_list_index =3D V4L2_HEVC_DPB_ENTRIES_NUM_MAX;
> +	pic_order_cnt[0] =3D pic_order_cnt[1] =3D slice_params->slice_pic_order=
_cnt;
> +	mv_col_buf_addr[0] =3D cedrus_h265_frame_info_mv_col_buf_addr(ctx,
> +		run->dst->vb2_buf.index, 0) - PHYS_OFFSET;
> +	mv_col_buf_addr[1] =3D cedrus_h265_frame_info_mv_col_buf_addr(ctx,
> +		run->dst->vb2_buf.index, 1) - PHYS_OFFSET;
> +	dst_luma_addr =3D cedrus_dst_buf_addr(ctx, run->dst->vb2_buf.index, 0) -
> +			PHYS_OFFSET;
> +	dst_chroma_addr =3D cedrus_dst_buf_addr(ctx, run->dst->vb2_buf.index, 1=
) -
> +			PHYS_OFFSET;
> +
> +	cedrus_h265_frame_info_write_single(dev, output_pic_list_index,
> +					    slice_params->pic_struct !=3D 0,
> +					    pic_order_cnt, mv_col_buf_addr,
> +					    dst_luma_addr, dst_chroma_addr);

You can only pass the run and slice_params pointers to that function.

> +
> +	cedrus_write(dev, VE_DEC_H265_OUTPUT_FRAME_IDX, output_pic_list_index);
> +
> +	/* Reference picture list 0 (for P/B frames). */
> +	if (slice_params->slice_type !=3D V4L2_HEVC_SLICE_TYPE_I) {
> +		cedrus_h265_ref_pic_list_write(dev, slice_params->ref_idx_l0,
> +			slice_params->num_ref_idx_l0_active_minus1 + 1,
> +			slice_params->dpb, slice_params->num_active_dpb_entries,
> +			VE_DEC_H265_SRAM_OFFSET_REF_PIC_LIST0);
> +

slice_params is enough.

> +		if (pps->weighted_pred_flag || pps->weighted_bipred_flag)
> +			cedrus_h265_pred_weight_write(dev,
> +				pred_weight_table->delta_luma_weight_l0,
> +				pred_weight_table->luma_offset_l0,
> +				pred_weight_table->delta_chroma_weight_l0,
> +				pred_weight_table->chroma_offset_l0,
> +				slice_params->num_ref_idx_l0_active_minus1 + 1,
> +				VE_DEC_H265_SRAM_OFFSET_PRED_WEIGHT_LUMA_L0,
> +				VE_DEC_H265_SRAM_OFFSET_PRED_WEIGHT_CHROMA_L0);

Ditto, that function should only take the pred_weight_table and
slice_params pointers

> +	}
> +
> +	/* Reference picture list 1 (for B frames). */
> +	if (slice_params->slice_type =3D=3D V4L2_HEVC_SLICE_TYPE_B) {
> +		cedrus_h265_ref_pic_list_write(dev, slice_params->ref_idx_l1,
> +			slice_params->num_ref_idx_l1_active_minus1 + 1,
> +			slice_params->dpb,
> +			slice_params->num_active_dpb_entries,
> +			VE_DEC_H265_SRAM_OFFSET_REF_PIC_LIST1);
> +
> +		if (pps->weighted_bipred_flag)
> +			cedrus_h265_pred_weight_write(dev,
> +				pred_weight_table->delta_luma_weight_l1,
> +				pred_weight_table->luma_offset_l1,
> +				pred_weight_table->delta_chroma_weight_l1,
> +				pred_weight_table->chroma_offset_l1,
> +				slice_params->num_ref_idx_l1_active_minus1 + 1,
> +				VE_DEC_H265_SRAM_OFFSET_PRED_WEIGHT_LUMA_L1,
> +				VE_DEC_H265_SRAM_OFFSET_PRED_WEIGHT_CHROMA_L1);
> +	}

Ditto

Looks good otherwise, thanks!
Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--gq2wygf7bjzac7jz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCW/z+fwAKCRDj7w1vZxhR
xcuxAP4yFxzcqiVRp4JgLGxq74N8Wm1FGyYKC72T4m/VIVgW3gEAvT/x/kJdQC1X
TUJdCT/Ofpfl3TfEFNMS+/KJEfFQJgI=
=iGSr
-----END PGP SIGNATURE-----

--gq2wygf7bjzac7jz--
