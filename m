Return-path: <linux-media-owner@vger.kernel.org>
Received: from plaes.org ([188.166.43.21]:36326 "EHLO plaes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726586AbeIGM1E (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Sep 2018 08:27:04 -0400
Date: Fri, 7 Sep 2018 07:33:46 +0000
From: Priit Laes <plaes@plaes.org>
To: Paul Kocialkowski <contact@paulk.fr>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devel@driverdev.osuosl.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-sunxi@googlegroups.com, Randy Li <ayaka@soulik.info>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [linux-sunxi] [PATCH v9 5/9] media: platform: Add Cedrus VPU
 decoder driver
Message-ID: <20180907073346.jd2c2pcxpwngq6tv@plaes.org>
References: <20180906222442.14825-1-contact@paulk.fr>
 <20180906222442.14825-6-contact@paulk.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180906222442.14825-6-contact@paulk.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 07, 2018 at 12:24:38AM +0200, Paul Kocialkowski wrote:
> From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> 
> This introduces the Cedrus VPU driver that supports the VPU found in
> Allwinner SoCs, also known as Video Engine. It is implemented through
> a V4L2 M2M decoder device and a media device (used for media requests).
> So far, it only supports MPEG-2 decoding.
> 
> Since this VPU is stateless, synchronization with media requests is
> required in order to ensure consistency between frame headers that
> contain metadata about the frame to process and the raw slice data that
> is used to generate the frame.
> 
> This driver was made possible thanks to the long-standing effort
> carried out by the linux-sunxi community in the interest of reverse
> engineering, documenting and implementing support for the Allwinner VPU.
> 
> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---

[...]
 diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c b/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c
> new file mode 100644
> index 000000000000..029eb1626bf4
> --- /dev/null
> +++ b/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c
> @@ -0,0 +1,237 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Cedrus VPU driver
> + *
> + * Copyright (C) 2016 Florent Revest <florent.revest@free-electrons.com>
> + * Copyright (C) 2018 Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> + * Copyright (C) 2018 Bootlin
> + */
> +
> +#include <media/videobuf2-dma-contig.h>
> +
> +#include "cedrus.h"
> +#include "cedrus_hw.h"
> +#include "cedrus_regs.h"
> +
> +/* Default MPEG-2 quantization coefficients, from the specification. */
> +
> +static const u8 intra_quantization_matrix_default[64] = {
> +	8,  16, 16, 19, 16, 19, 22, 22,
> +	22, 22, 22, 22, 26, 24, 26, 27,
> +	27, 27, 26, 26, 26, 26, 27, 27,
> +	27, 29, 29, 29, 34, 34, 34, 29,
> +	29, 29, 27, 27, 29, 29, 32, 32,
> +	34, 34, 37, 38, 37, 35, 35, 34,
> +	35, 38, 38, 40, 40, 40, 48, 48,
> +	46, 46, 56, 56, 58, 69, 69, 83
> +};

I think it should also mention that the table above is the DC
prediction table, already in the zig-zag order.

	8,  16, 19, 22, 26, 27, 29, 34,
	16, 16, 22, 24, 27, 29, 34, 37,
	19, 22, 26, 27, 29, 34, 34, 38,
	22, 22, 26, 27, 29, 34, 37, 40,
	22, 26, 27, 29, 32, 35, 40, 48,
	26, 27, 29, 32, 35, 40, 48, 58,
	26, 27, 29, 34, 38, 46, 56, 69,
	27, 29, 35, 38, 46, 56, 69, 83

See slides no 466 and 486 in following pdf:
http://iphome.hhi.de/schwarz/assets/pdfs/08_ImageCoding.pdf
> +
> +static const u8 non_intra_quantization_matrix_default[64] = {
> +	16, 16, 16, 16, 16, 16, 16, 16,
> +	16, 16, 16, 16, 16, 16, 16, 16,
> +	16, 16, 16, 16, 16, 16, 16, 16,
> +	16, 16, 16, 16, 16, 16, 16, 16,
> +	16, 16, 16, 16, 16, 16, 16, 16,
> +	16, 16, 16, 16, 16, 16, 16, 16,
> +	16, 16, 16, 16, 16, 16, 16, 16,
> +	16, 16, 16, 16, 16, 16, 16, 16
> +};
> +
> +static enum cedrus_irq_status cedrus_mpeg2_irq_status(struct cedrus_ctx *ctx)
> +{
> +	struct cedrus_dev *dev = ctx->dev;
> +	u32 reg;
> +
> +	reg = cedrus_read(dev, VE_DEC_MPEG_STATUS);
> +	reg &= VE_DEC_MPEG_STATUS_CHECK_MASK;
> +
> +	if (!reg)
> +		return CEDRUS_IRQ_NONE;
> +
> +	if (reg & VE_DEC_MPEG_STATUS_CHECK_ERROR ||
> +	    !(reg & VE_DEC_MPEG_STATUS_SUCCESS))
> +		return CEDRUS_IRQ_ERROR;
> +
> +	return CEDRUS_IRQ_OK;
> +}
> +
> +static void cedrus_mpeg2_irq_clear(struct cedrus_ctx *ctx)
> +{
> +	struct cedrus_dev *dev = ctx->dev;
> +
> +	cedrus_write(dev, VE_DEC_MPEG_STATUS, VE_DEC_MPEG_STATUS_CHECK_MASK);
> +}
> +
> +static void cedrus_mpeg2_irq_disable(struct cedrus_ctx *ctx)
> +{
> +	struct cedrus_dev *dev = ctx->dev;
> +	u32 reg = cedrus_read(dev, VE_DEC_MPEG_CTRL);
> +
> +	reg &= ~VE_DEC_MPEG_CTRL_IRQ_MASK;
> +
> +	cedrus_write(dev, VE_DEC_MPEG_CTRL, reg);
> +}
> +
> +static void cedrus_mpeg2_setup(struct cedrus_ctx *ctx, struct cedrus_run *run)
> +{
> +	const struct v4l2_ctrl_mpeg2_slice_params *slice_params;
> +	const struct v4l2_mpeg2_sequence *sequence;
> +	const struct v4l2_mpeg2_picture *picture;
> +	const struct v4l2_ctrl_mpeg2_quantization *quantization;
> +	dma_addr_t src_buf_addr, dst_luma_addr, dst_chroma_addr;
> +	dma_addr_t fwd_luma_addr, fwd_chroma_addr;
> +	dma_addr_t bwd_luma_addr, bwd_chroma_addr;
> +	struct cedrus_dev *dev = ctx->dev;
> +	const u8 *matrix;
> +	unsigned int i;
> +	u32 reg;
> +
> +	slice_params = run->mpeg2.slice_params;
> +	sequence = &slice_params->sequence;
> +	picture = &slice_params->picture;
> +
> +	quantization = run->mpeg2.quantization;
> +
> +	/* Activate MPEG engine. */
> +	cedrus_engine_enable(dev, CEDRUS_CODEC_MPEG2);
> +
> +	/* Set intra quantization matrix. */
> +
> +	if (quantization && quantization->load_intra_quantiser_matrix)
> +		matrix = quantization->intra_quantiser_matrix;
> +	else
> +		matrix = intra_quantization_matrix_default;
> +
> +	for (i = 0; i < 64; i++) {
> +		reg = VE_DEC_MPEG_IQMINPUT_WEIGHT(i, matrix[i]);
> +		reg |= VE_DEC_MPEG_IQMINPUT_FLAG_INTRA;
> +
> +		cedrus_write(dev, VE_DEC_MPEG_IQMINPUT, reg);
> +	}
> +
> +	/* Set non-intra quantization matrix. */
> +
> +	if (quantization && quantization->load_non_intra_quantiser_matrix)
> +		matrix = quantization->non_intra_quantiser_matrix;
> +	else
> +		matrix = non_intra_quantization_matrix_default;
> +
> +	for (i = 0; i < 64; i++) {
> +		reg = VE_DEC_MPEG_IQMINPUT_WEIGHT(i, matrix[i]);
> +		reg |= VE_DEC_MPEG_IQMINPUT_FLAG_NON_INTRA;
> +
> +		cedrus_write(dev, VE_DEC_MPEG_IQMINPUT, reg);
> +	}
> +
> +	/* Set MPEG picture header. */
> +
> +	reg = VE_DEC_MPEG_MP12HDR_SLICE_TYPE(picture->picture_coding_type);
> +	reg |= VE_DEC_MPEG_MP12HDR_F_CODE(0, 0, picture->f_code[0][0]);
> +	reg |= VE_DEC_MPEG_MP12HDR_F_CODE(0, 1, picture->f_code[0][1]);
> +	reg |= VE_DEC_MPEG_MP12HDR_F_CODE(1, 0, picture->f_code[1][0]);
> +	reg |= VE_DEC_MPEG_MP12HDR_F_CODE(1, 1, picture->f_code[1][1]);
> +	reg |= VE_DEC_MPEG_MP12HDR_INTRA_DC_PRECISION(picture->intra_dc_precision);
> +	reg |= VE_DEC_MPEG_MP12HDR_INTRA_PICTURE_STRUCTURE(picture->picture_structure);
> +	reg |= VE_DEC_MPEG_MP12HDR_TOP_FIELD_FIRST(picture->top_field_first);
> +	reg |= VE_DEC_MPEG_MP12HDR_FRAME_PRED_FRAME_DCT(picture->frame_pred_frame_dct);
> +	reg |= VE_DEC_MPEG_MP12HDR_CONCEALMENT_MOTION_VECTORS(picture->concealment_motion_vectors);
> +	reg |= VE_DEC_MPEG_MP12HDR_Q_SCALE_TYPE(picture->q_scale_type);
> +	reg |= VE_DEC_MPEG_MP12HDR_INTRA_VLC_FORMAT(picture->intra_vlc_format);
> +	reg |= VE_DEC_MPEG_MP12HDR_ALTERNATE_SCAN(picture->alternate_scan);
> +	reg |= VE_DEC_MPEG_MP12HDR_FULL_PEL_FORWARD_VECTOR(0);
> +	reg |= VE_DEC_MPEG_MP12HDR_FULL_PEL_BACKWARD_VECTOR(0);
> +
> +	cedrus_write(dev, VE_DEC_MPEG_MP12HDR, reg);
> +
> +	/* Set frame dimensions. */
> +
> +	reg = VE_DEC_MPEG_PICCODEDSIZE_WIDTH(sequence->horizontal_size);
> +	reg |= VE_DEC_MPEG_PICCODEDSIZE_HEIGHT(sequence->vertical_size);
> +
> +	cedrus_write(dev, VE_DEC_MPEG_PICCODEDSIZE, reg);
> +
> +	reg = VE_DEC_MPEG_PICBOUNDSIZE_WIDTH(ctx->src_fmt.width);
> +	reg |= VE_DEC_MPEG_PICBOUNDSIZE_HEIGHT(ctx->src_fmt.height);
> +
> +	cedrus_write(dev, VE_DEC_MPEG_PICBOUNDSIZE, reg);
> +
> +	/* Forward and backward prediction reference buffers. */
> +
> +	fwd_luma_addr = cedrus_dst_buf_addr(ctx, slice_params->forward_ref_index, 0);
> +	fwd_chroma_addr = cedrus_dst_buf_addr(ctx, slice_params->forward_ref_index, 1);
> +
> +	cedrus_write(dev, VE_DEC_MPEG_FWD_REF_LUMA_ADDR, fwd_luma_addr);
> +	cedrus_write(dev, VE_DEC_MPEG_FWD_REF_CHROMA_ADDR, fwd_chroma_addr);
> +
> +	bwd_luma_addr = cedrus_dst_buf_addr(ctx, slice_params->backward_ref_index, 0);
> +	bwd_chroma_addr = cedrus_dst_buf_addr(ctx, slice_params->backward_ref_index, 1);
> +
> +	cedrus_write(dev, VE_DEC_MPEG_BWD_REF_LUMA_ADDR, bwd_luma_addr);
> +	cedrus_write(dev, VE_DEC_MPEG_BWD_REF_CHROMA_ADDR, bwd_chroma_addr);
> +
> +	/* Destination luma and chroma buffers. */
> +
> +	dst_luma_addr = cedrus_dst_buf_addr(ctx, run->dst->vb2_buf.index, 0);
> +	dst_chroma_addr = cedrus_dst_buf_addr(ctx, run->dst->vb2_buf.index, 1);
> +
> +	cedrus_write(dev, VE_DEC_MPEG_REC_LUMA, dst_luma_addr);
> +	cedrus_write(dev, VE_DEC_MPEG_REC_CHROMA, dst_chroma_addr);
> +
> +	/* Source offset and length in bits. */
> +
> +	cedrus_write(dev, VE_DEC_MPEG_VLD_OFFSET, slice_params->data_bit_offset);
> +
> +	reg = slice_params->bit_size - slice_params->data_bit_offset;
> +	cedrus_write(dev, VE_DEC_MPEG_VLD_LEN, reg);
> +
> +	/* Source beginning and end addresses. */
> +
> +	src_buf_addr = vb2_dma_contig_plane_dma_addr(&run->src->vb2_buf, 0);
> +
> +	reg = VE_DEC_MPEG_VLD_ADDR_BASE(src_buf_addr);
> +	reg |= VE_DEC_MPEG_VLD_ADDR_VALID_PIC_DATA;
> +	reg |= VE_DEC_MPEG_VLD_ADDR_LAST_PIC_DATA;
> +	reg |= VE_DEC_MPEG_VLD_ADDR_FIRST_PIC_DATA;
> +
> +	cedrus_write(dev, VE_DEC_MPEG_VLD_ADDR, reg);
> +
> +	reg = src_buf_addr + DIV_ROUND_UP(slice_params->bit_size, 8);
> +	cedrus_write(dev, VE_DEC_MPEG_VLD_END_ADDR, reg);
> +
> +	/* Macroblock address: start at the beginning. */
> +	reg = VE_DEC_MPEG_MBADDR_Y(0) | VE_DEC_MPEG_MBADDR_X(0);
> +	cedrus_write(dev, VE_DEC_MPEG_MBADDR, reg);
> +
> +	/* Clear previous errors. */
> +	cedrus_write(dev, VE_DEC_MPEG_ERROR, 0);
> +
> +	/* Clear correct macroblocks register. */
> +	cedrus_write(dev, VE_DEC_MPEG_CRTMBADDR, 0);
> +
> +	/* Enable appropriate interruptions and components. */
> +
> +	reg = VE_DEC_MPEG_CTRL_IRQ_MASK | VE_DEC_MPEG_CTRL_MC_NO_WRITEBACK |
> +	      VE_DEC_MPEG_CTRL_MC_CACHE_EN;
> +
> +	cedrus_write(dev, VE_DEC_MPEG_CTRL, reg);
> +}
> +
> +static void cedrus_mpeg2_trigger(struct cedrus_ctx *ctx)
> +{
> +	struct cedrus_dev *dev = ctx->dev;
> +	u32 reg;
> +
> +	/* Trigger MPEG engine. */
> +	reg = VE_DEC_MPEG_TRIGGER_HW_MPEG_VLD | VE_DEC_MPEG_TRIGGER_MPEG2 |
> +	      VE_DEC_MPEG_TRIGGER_MB_BOUNDARY;
> +
> +	cedrus_write(dev, VE_DEC_MPEG_TRIGGER, reg);
> +}
> +
> +struct cedrus_dec_ops cedrus_dec_ops_mpeg2 = {
> +	.irq_clear	= cedrus_mpeg2_irq_clear,
> +	.irq_disable	= cedrus_mpeg2_irq_disable,
> +	.irq_status	= cedrus_mpeg2_irq_status,
> +	.setup		= cedrus_mpeg2_setup,
> +	.trigger	= cedrus_mpeg2_trigger,
> +};
> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_regs.h b/drivers/staging/media/sunxi/cedrus/cedrus_regs.h
> new file mode 100644
> index 000000000000..9b14d1fb94a0
> --- /dev/null
> +++ b/drivers/staging/media/sunxi/cedrus/cedrus_regs.h
> @@ -0,0 +1,233 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Cedrus VPU driver
> + *
> + * Copyright (c) 2013-2016 Jens Kuske <jenskuske@gmail.com>
> + * Copyright (C) 2016 Florent Revest <florent.revest@free-electrons.com>
> + * Copyright (C) 2018 Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> + */
> +
> +#ifndef _CEDRUS_REGS_H_
> +#define _CEDRUS_REGS_H_
> +
> +/*
> + * Common acronyms and contractions used in register descriptions:
> + * * VLD : Variable-Length Decoder
> + * * IQ: Inverse Quantization
> + * * IDCT: Inverse Discrete Cosine Transform
> + * * MC: Motion Compensation
> + * * STCD: Start Code Detect
> + * * SDRT: Scale Down and Rotate
> + */
> +
> +#define VE_ENGINE_DEC_MPEG			0x100
> +#define VE_ENGINE_DEC_H264			0x200
> +
> +#define VE_MODE					0x00
> +
> +#define VE_MODE_REC_WR_MODE_2MB			(0x01 << 20)
> +#define VE_MODE_REC_WR_MODE_1MB			(0x00 << 20)
> +#define VE_MODE_DDR_MODE_BW_128			(0x03 << 16)
> +#define VE_MODE_DDR_MODE_BW_256			(0x02 << 16)
> +#define VE_MODE_DISABLED			(0x07 << 0)
> +#define VE_MODE_DEC_H265			(0x04 << 0)
> +#define VE_MODE_DEC_H264			(0x01 << 0)
> +#define VE_MODE_DEC_MPEG			(0x00 << 0)
> +
> +#define VE_PRIMARY_CHROMA_BUF_LEN		0xc4
> +#define VE_PRIMARY_FB_LINE_STRIDE		0xc8
> +
> +#define VE_PRIMARY_FB_LINE_STRIDE_CHROMA(s)	(((s) << 16) & GENMASK(31, 16))
> +#define VE_PRIMARY_FB_LINE_STRIDE_LUMA(s)	(((s) << 0) & GENMASK(15, 0))
> +
> +#define VE_CHROMA_BUF_LEN			0xe8
> +
> +#define VE_SECONDARY_OUT_FMT_TILED_32_NV12	(0x00 << 30)
> +#define VE_SECONDARY_OUT_FMT_EXT		(0x01 << 30)
> +#define VE_SECONDARY_OUT_FMT_YU12		(0x02 << 30)
> +#define VE_SECONDARY_OUT_FMT_YV12		(0x03 << 30)
> +#define VE_CHROMA_BUF_LEN_SDRT(l)		((l) & GENMASK(27, 0))
> +
> +#define VE_PRIMARY_OUT_FMT			0xec
> +
> +#define VE_PRIMARY_OUT_FMT_TILED_32_NV12	(0x00 << 4)
> +#define VE_PRIMARY_OUT_FMT_TILED_128_NV12	(0x01 << 4)
> +#define VE_PRIMARY_OUT_FMT_YU12			(0x02 << 4)
> +#define VE_PRIMARY_OUT_FMT_YV12			(0x03 << 4)
> +#define VE_PRIMARY_OUT_FMT_NV12			(0x04 << 4)
> +#define VE_PRIMARY_OUT_FMT_NV21			(0x05 << 4)
> +#define VE_SECONDARY_OUT_FMT_EXT_TILED_32_NV12	(0x00 << 0)
> +#define VE_SECONDARY_OUT_FMT_EXT_TILED_128_NV12	(0x01 << 0)
> +#define VE_SECONDARY_OUT_FMT_EXT_YU12		(0x02 << 0)
> +#define VE_SECONDARY_OUT_FMT_EXT_YV12		(0x03 << 0)
> +#define VE_SECONDARY_OUT_FMT_EXT_NV12		(0x04 << 0)
> +#define VE_SECONDARY_OUT_FMT_EXT_NV21		(0x05 << 0)
> +
> +#define VE_VERSION				0xf0
> +
> +#define VE_VERSION_SHIFT			16
> +
> +#define VE_DEC_MPEG_MP12HDR			(VE_ENGINE_DEC_MPEG + 0x00)
> +
> +#define VE_DEC_MPEG_MP12HDR_SLICE_TYPE(t)	(((t) << 28) & GENMASK(30, 28))
> +#define VE_DEC_MPEG_MP12HDR_F_CODE_SHIFT(x, y)	(24 - 4 * (y) - 8 * (x))
> +#define VE_DEC_MPEG_MP12HDR_F_CODE_MASK(x, y) \
> +	GENMASK(VE_DEC_MPEG_MP12HDR_F_CODE_SHIFT(x, y) + 3, \
> +		VE_DEC_MPEG_MP12HDR_F_CODE_SHIFT(x, y))
> +#define VE_DEC_MPEG_MP12HDR_F_CODE(x, y, v) \
> +	(((v) << VE_DEC_MPEG_MP12HDR_F_CODE_SHIFT(x, y)) & \
> +	 VE_DEC_MPEG_MP12HDR_F_CODE_MASK(x, y))
> +#define VE_DEC_MPEG_MP12HDR_INTRA_DC_PRECISION(p) \
> +	(((p) << 10) & GENMASK(11, 10))
> +#define VE_DEC_MPEG_MP12HDR_INTRA_PICTURE_STRUCTURE(s) \
> +	(((s) << 8) & GENMASK(9, 8))
> +#define VE_DEC_MPEG_MP12HDR_TOP_FIELD_FIRST(v) \
> +	((v) ? BIT(7) : 0)
> +#define VE_DEC_MPEG_MP12HDR_FRAME_PRED_FRAME_DCT(v) \
> +	((v) ? BIT(6) : 0)
> +#define VE_DEC_MPEG_MP12HDR_CONCEALMENT_MOTION_VECTORS(v) \
> +	((v) ? BIT(5) : 0)
> +#define VE_DEC_MPEG_MP12HDR_Q_SCALE_TYPE(v) \
> +	((v) ? BIT(4) : 0)
> +#define VE_DEC_MPEG_MP12HDR_INTRA_VLC_FORMAT(v) \
> +	((v) ? BIT(3) : 0)
> +#define VE_DEC_MPEG_MP12HDR_ALTERNATE_SCAN(v) \
> +	((v) ? BIT(2) : 0)
> +#define VE_DEC_MPEG_MP12HDR_FULL_PEL_FORWARD_VECTOR(v) \
> +	((v) ? BIT(1) : 0)
> +#define VE_DEC_MPEG_MP12HDR_FULL_PEL_BACKWARD_VECTOR(v) \
> +	((v) ? BIT(0) : 0)
> +
> +#define VE_DEC_MPEG_PICCODEDSIZE		(VE_ENGINE_DEC_MPEG + 0x08)
> +
> +#define VE_DEC_MPEG_PICCODEDSIZE_WIDTH(w) \
> +	((DIV_ROUND_UP((w), 16) << 8) & GENMASK(15, 8))
> +#define VE_DEC_MPEG_PICCODEDSIZE_HEIGHT(h) \
> +	((DIV_ROUND_UP((h), 16) << 0) & GENMASK(7, 0))
> +
> +#define VE_DEC_MPEG_PICBOUNDSIZE		(VE_ENGINE_DEC_MPEG + 0x0c)
> +
> +#define VE_DEC_MPEG_PICBOUNDSIZE_WIDTH(w)	(((w) << 16) & GENMASK(27, 16))
> +#define VE_DEC_MPEG_PICBOUNDSIZE_HEIGHT(h)	(((h) << 0) & GENMASK(11, 0))
> +
> +#define VE_DEC_MPEG_MBADDR			(VE_ENGINE_DEC_MPEG + 0x10)
> +
> +#define VE_DEC_MPEG_MBADDR_X(w)			(((w) << 8) & GENMASK(15, 8))
> +#define VE_DEC_MPEG_MBADDR_Y(h)			(((h) << 0) & GENMASK(0, 7))
> +
> +#define VE_DEC_MPEG_CTRL			(VE_ENGINE_DEC_MPEG + 0x14)
> +
> +#define VE_DEC_MPEG_CTRL_MC_CACHE_EN		BIT(31)
> +#define VE_DEC_MPEG_CTRL_SW_VLD			BIT(27)
> +#define VE_DEC_MPEG_CTRL_SW_IQ_IS		BIT(17)
> +#define VE_DEC_MPEG_CTRL_QP_AC_DC_OUT_EN	BIT(14)
> +#define VE_DEC_MPEG_CTRL_ROTATE_SCALE_OUT_EN	BIT(8)
> +#define VE_DEC_MPEG_CTRL_MC_NO_WRITEBACK	BIT(7)
> +#define VE_DEC_MPEG_CTRL_ROTATE_IRQ_EN		BIT(6)
> +#define VE_DEC_MPEG_CTRL_VLD_DATA_REQ_IRQ_EN	BIT(5)
> +#define VE_DEC_MPEG_CTRL_ERROR_IRQ_EN		BIT(4)
> +#define VE_DEC_MPEG_CTRL_FINISH_IRQ_EN		BIT(3)
> +#define VE_DEC_MPEG_CTRL_IRQ_MASK \
> +	(VE_DEC_MPEG_CTRL_FINISH_IRQ_EN | VE_DEC_MPEG_CTRL_ERROR_IRQ_EN | \
> +	 VE_DEC_MPEG_CTRL_VLD_DATA_REQ_IRQ_EN)
> +
> +#define VE_DEC_MPEG_TRIGGER			(VE_ENGINE_DEC_MPEG + 0x18)
> +
> +#define VE_DEC_MPEG_TRIGGER_MB_BOUNDARY		BIT(31)
> +
> +#define VE_DEC_MPEG_TRIGGER_CHROMA_FMT_420	(0x00 << 27)
> +#define VE_DEC_MPEG_TRIGGER_CHROMA_FMT_411	(0x01 << 27)
> +#define VE_DEC_MPEG_TRIGGER_CHROMA_FMT_422	(0x02 << 27)
> +#define VE_DEC_MPEG_TRIGGER_CHROMA_FMT_444	(0x03 << 27)
> +#define VE_DEC_MPEG_TRIGGER_CHROMA_FMT_422T	(0x04 << 27)
> +
> +#define VE_DEC_MPEG_TRIGGER_MPEG1		(0x01 << 24)
> +#define VE_DEC_MPEG_TRIGGER_MPEG2		(0x02 << 24)
> +#define VE_DEC_MPEG_TRIGGER_JPEG		(0x03 << 24)
> +#define VE_DEC_MPEG_TRIGGER_MPEG4		(0x04 << 24)
> +#define VE_DEC_MPEG_TRIGGER_VP62		(0x05 << 24)
> +
> +#define VE_DEC_MPEG_TRIGGER_VP62_AC_GET_BITS	BIT(7)
> +
> +#define VE_DEC_MPEG_TRIGGER_STCD_VC1		(0x02 << 4)
> +#define VE_DEC_MPEG_TRIGGER_STCD_MPEG2		(0x01 << 4)
> +#define VE_DEC_MPEG_TRIGGER_STCD_AVC		(0x00 << 4)
> +
> +#define VE_DEC_MPEG_TRIGGER_HW_MPEG_VLD		(0x0f << 0)
> +#define VE_DEC_MPEG_TRIGGER_HW_JPEG_VLD		(0x0e << 0)
> +#define VE_DEC_MPEG_TRIGGER_HW_MB		(0x0d << 0)
> +#define VE_DEC_MPEG_TRIGGER_HW_ROTATE		(0x0c << 0)
> +#define VE_DEC_MPEG_TRIGGER_HW_VP6_VLD		(0x0b << 0)
> +#define VE_DEC_MPEG_TRIGGER_HW_MAF		(0x0a << 0)
> +#define VE_DEC_MPEG_TRIGGER_HW_STCD_END		(0x09 << 0)
> +#define VE_DEC_MPEG_TRIGGER_HW_STCD_BEGIN	(0x08 << 0)
> +#define VE_DEC_MPEG_TRIGGER_SW_MC		(0x07 << 0)
> +#define VE_DEC_MPEG_TRIGGER_SW_IQ		(0x06 << 0)
> +#define VE_DEC_MPEG_TRIGGER_SW_IDCT		(0x05 << 0)
> +#define VE_DEC_MPEG_TRIGGER_SW_SCALE		(0x04 << 0)
> +#define VE_DEC_MPEG_TRIGGER_SW_VP6		(0x03 << 0)
> +#define VE_DEC_MPEG_TRIGGER_SW_VP62_AC_GET_BITS	(0x02 << 0)
> +
> +#define VE_DEC_MPEG_STATUS			(VE_ENGINE_DEC_MPEG + 0x1c)
> +
> +#define VE_DEC_MPEG_STATUS_START_DETECT_BUSY	BIT(27)
> +#define VE_DEC_MPEG_STATUS_VP6_BIT		BIT(26)
> +#define VE_DEC_MPEG_STATUS_VP6_BIT_BUSY		BIT(25)
> +#define VE_DEC_MPEG_STATUS_MAF_BUSY		BIT(23)
> +#define VE_DEC_MPEG_STATUS_VP6_MVP_BUSY		BIT(22)
> +#define VE_DEC_MPEG_STATUS_JPEG_BIT_END		BIT(21)
> +#define VE_DEC_MPEG_STATUS_JPEG_RESTART_ERROR	BIT(20)
> +#define VE_DEC_MPEG_STATUS_JPEG_MARKER		BIT(19)
> +#define VE_DEC_MPEG_STATUS_ROTATE_BUSY		BIT(18)
> +#define VE_DEC_MPEG_STATUS_DEBLOCKING_BUSY	BIT(17)
> +#define VE_DEC_MPEG_STATUS_SCALE_DOWN_BUSY	BIT(16)
> +#define VE_DEC_MPEG_STATUS_IQIS_BUF_EMPTY	BIT(15)
> +#define VE_DEC_MPEG_STATUS_IDCT_BUF_EMPTY	BIT(14)
> +#define VE_DEC_MPEG_STATUS_VE_BUSY		BIT(13)
> +#define VE_DEC_MPEG_STATUS_MC_BUSY		BIT(12)
> +#define VE_DEC_MPEG_STATUS_IDCT_BUSY		BIT(11)
> +#define VE_DEC_MPEG_STATUS_IQIS_BUSY		BIT(10)
> +#define VE_DEC_MPEG_STATUS_DCAC_BUSY		BIT(9)
> +#define VE_DEC_MPEG_STATUS_VLD_BUSY		BIT(8)
> +#define VE_DEC_MPEG_STATUS_ROTATE_SUCCESS	BIT(3)
> +#define VE_DEC_MPEG_STATUS_VLD_DATA_REQ		BIT(2)
> +#define VE_DEC_MPEG_STATUS_ERROR		BIT(1)
> +#define VE_DEC_MPEG_STATUS_SUCCESS		BIT(0)
> +#define VE_DEC_MPEG_STATUS_CHECK_MASK \
> +	(VE_DEC_MPEG_STATUS_SUCCESS | VE_DEC_MPEG_STATUS_ERROR | \
> +	 VE_DEC_MPEG_STATUS_VLD_DATA_REQ)
> +#define VE_DEC_MPEG_STATUS_CHECK_ERROR \
> +	(VE_DEC_MPEG_STATUS_ERROR | VE_DEC_MPEG_STATUS_VLD_DATA_REQ)
> +
> +#define VE_DEC_MPEG_VLD_ADDR			(VE_ENGINE_DEC_MPEG + 0x28)
> +
> +#define VE_DEC_MPEG_VLD_ADDR_FIRST_PIC_DATA	BIT(30)
> +#define VE_DEC_MPEG_VLD_ADDR_LAST_PIC_DATA	BIT(29)
> +#define VE_DEC_MPEG_VLD_ADDR_VALID_PIC_DATA	BIT(28)
> +#define VE_DEC_MPEG_VLD_ADDR_BASE(a) \
> +	(((a) & GENMASK(27, 4)) | (((a) >> 28) & GENMASK(3, 0)))
> +
> +#define VE_DEC_MPEG_VLD_OFFSET			(VE_ENGINE_DEC_MPEG + 0x2c)
> +#define VE_DEC_MPEG_VLD_LEN			(VE_ENGINE_DEC_MPEG + 0x30)
> +#define VE_DEC_MPEG_VLD_END_ADDR		(VE_ENGINE_DEC_MPEG + 0x34)
> +
> +#define VE_DEC_MPEG_REC_LUMA			(VE_ENGINE_DEC_MPEG + 0x48)
> +#define VE_DEC_MPEG_REC_CHROMA			(VE_ENGINE_DEC_MPEG + 0x4c)
> +#define VE_DEC_MPEG_FWD_REF_LUMA_ADDR		(VE_ENGINE_DEC_MPEG + 0x50)
> +#define VE_DEC_MPEG_FWD_REF_CHROMA_ADDR		(VE_ENGINE_DEC_MPEG + 0x54)
> +#define VE_DEC_MPEG_BWD_REF_LUMA_ADDR		(VE_ENGINE_DEC_MPEG + 0x58)
> +#define VE_DEC_MPEG_BWD_REF_CHROMA_ADDR		(VE_ENGINE_DEC_MPEG + 0x5c)
> +
> +#define VE_DEC_MPEG_IQMINPUT			(VE_ENGINE_DEC_MPEG + 0x80)
> +
> +#define VE_DEC_MPEG_IQMINPUT_FLAG_INTRA		(0x01 << 14)
> +#define VE_DEC_MPEG_IQMINPUT_FLAG_NON_INTRA	(0x00 << 14)
> +#define VE_DEC_MPEG_IQMINPUT_WEIGHT(i, v) \
> +	(((v) & GENMASK(7, 0)) | (((i) << 8) & GENMASK(13, 8)))
> +
> +#define VE_DEC_MPEG_ERROR			(VE_ENGINE_DEC_MPEG + 0xc4)
> +#define VE_DEC_MPEG_CRTMBADDR			(VE_ENGINE_DEC_MPEG + 0xc8)
> +#define VE_DEC_MPEG_ROT_LUMA			(VE_ENGINE_DEC_MPEG + 0xcc)
> +#define VE_DEC_MPEG_ROT_CHROMA			(VE_ENGINE_DEC_MPEG + 0xd0)
> +
> +#endif
> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_video.c b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
> new file mode 100644
> index 000000000000..bd119d2c4e1f
> --- /dev/null
> +++ b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
> @@ -0,0 +1,544 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Cedrus VPU driver
> + *
> + * Copyright (C) 2016 Florent Revest <florent.revest@free-electrons.com>
> + * Copyright (C) 2018 Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> + * Copyright (C) 2018 Bootlin
> + *
> + * Based on the vim2m driver, that is:
> + *
> + * Copyright (c) 2009-2010 Samsung Electronics Co., Ltd.
> + * Pawel Osciak, <pawel@osciak.com>
> + * Marek Szyprowski, <m.szyprowski@samsung.com>
> + */
> +
> +#include <media/videobuf2-dma-contig.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/v4l2-event.h>
> +#include <media/v4l2-mem2mem.h>
> +
> +#include "cedrus.h"
> +#include "cedrus_video.h"
> +#include "cedrus_dec.h"
> +#include "cedrus_hw.h"
> +
> +#define CEDRUS_DECODE_SRC	BIT(0)
> +#define CEDRUS_DECODE_DST	BIT(1)
> +
> +#define CEDRUS_MIN_WIDTH	16U
> +#define CEDRUS_MIN_HEIGHT	16U
> +#define CEDRUS_MAX_WIDTH	3840U
> +#define CEDRUS_MAX_HEIGHT	2160U
> +
> +static struct cedrus_format cedrus_formats[] = {
> +	{
> +		.pixelformat	= V4L2_PIX_FMT_MPEG2_SLICE,
> +		.directions	= CEDRUS_DECODE_SRC,
> +	},
> +	{
> +		.pixelformat	= V4L2_PIX_FMT_SUNXI_TILED_NV12,
> +		.directions	= CEDRUS_DECODE_DST,
> +	},
> +	{
> +		.pixelformat	= V4L2_PIX_FMT_NV12,
> +		.directions	= CEDRUS_DECODE_DST,
> +		.capabilities	= CEDRUS_CAPABILITY_UNTILED,
> +	},
> +};
> +
> +#define CEDRUS_FORMATS_COUNT	ARRAY_SIZE(cedrus_formats)
> +
> +static inline struct cedrus_ctx *cedrus_file2ctx(struct file *file)
> +{
> +	return container_of(file->private_data, struct cedrus_ctx, fh);
> +}
> +
> +static struct cedrus_format *cedrus_find_format(u32 pixelformat, u32 directions,
> +						unsigned int capabilities)
> +{
> +	struct cedrus_format *fmt;
> +	unsigned int i;
> +
> +	for (i = 0; i < CEDRUS_FORMATS_COUNT; i++) {
> +		fmt = &cedrus_formats[i];
> +
> +		if (fmt->capabilities && (fmt->capabilities & capabilities) !=
> +		    fmt->capabilities)
> +			continue;
> +
> +		if (fmt->pixelformat == pixelformat &&
> +		    (fmt->directions & directions) != 0)
> +			break;
> +	}
> +
> +	if (i == CEDRUS_FORMATS_COUNT)
> +		return NULL;
> +
> +	return &cedrus_formats[i];
> +}
> +
> +static bool cedrus_check_format(u32 pixelformat, u32 directions,
> +				unsigned int capabilities)
> +{
> +	struct cedrus_format *fmt = cedrus_find_format(pixelformat, directions,
> +						       capabilities);
> +
> +	return fmt != NULL;
> +}
> +
> +static void cedrus_prepare_format(struct v4l2_pix_format *pix_fmt)
> +{
> +	unsigned int width = pix_fmt->width;
> +	unsigned int height = pix_fmt->height;
> +	unsigned int sizeimage = pix_fmt->sizeimage;
> +	unsigned int bytesperline = pix_fmt->bytesperline;
> +
> +	pix_fmt->field = V4L2_FIELD_NONE;
> +
> +	/* Limit to hardware min/max. */
> +	width = clamp(width, CEDRUS_MIN_WIDTH, CEDRUS_MAX_WIDTH);
> +	height = clamp(height, CEDRUS_MIN_HEIGHT, CEDRUS_MAX_HEIGHT);
> +
> +	switch (pix_fmt->pixelformat) {
> +	case V4L2_PIX_FMT_MPEG2_SLICE:
> +		/* Zero bytes per line for encoded source. */
> +		bytesperline = 0;
> +
> +		break;
> +
> +	case V4L2_PIX_FMT_SUNXI_TILED_NV12:
> +		/* 32-aligned stride. */
> +		bytesperline = ALIGN(width, 32);
> +
> +		/* 32-aligned height. */
> +		height = ALIGN(height, 32);
> +
> +		/* Luma plane size. */
> +		sizeimage = bytesperline * height;
> +
> +		/* Chroma plane size. */
> +		sizeimage += bytesperline * height / 2;
> +
> +		break;
> +
> +	case V4L2_PIX_FMT_NV12:
> +		/* 16-aligned stride. */
> +		bytesperline = ALIGN(width, 16);
> +
> +		/* 16-aligned height. */
> +		height = ALIGN(height, 16);
> +
> +		/* Luma plane size. */
> +		sizeimage = bytesperline * height;
> +
> +		/* Chroma plane size. */
> +		sizeimage += bytesperline * height / 2;
> +
> +		break;
> +	}
> +
> +	pix_fmt->width = width;
> +	pix_fmt->height = height;
> +
> +	pix_fmt->bytesperline = bytesperline;
> +	pix_fmt->sizeimage = sizeimage;
> +}
> +
> +static int cedrus_querycap(struct file *file, void *priv,
> +			   struct v4l2_capability *cap)
> +{
> +	strlcpy(cap->driver, CEDRUS_NAME, sizeof(cap->driver));
> +	strlcpy(cap->card, CEDRUS_NAME, sizeof(cap->card));
> +	snprintf(cap->bus_info, sizeof(cap->bus_info),
> +		 "platform:%s", CEDRUS_NAME);
> +
> +	return 0;
> +}
> +
> +static int cedrus_enum_fmt(struct file *file, struct v4l2_fmtdesc *f,
> +			   u32 direction)
> +{
> +	struct cedrus_ctx *ctx = cedrus_file2ctx(file);
> +	struct cedrus_dev *dev = ctx->dev;
> +	unsigned int capabilities = dev->capabilities;
> +	struct cedrus_format *fmt;
> +	unsigned int i, index;
> +
> +	/* Index among formats that match the requested direction. */
> +	index = 0;
> +
> +	for (i = 0; i < CEDRUS_FORMATS_COUNT; i++) {
> +		fmt = &cedrus_formats[i];
> +
> +		if (fmt->capabilities && (fmt->capabilities & capabilities) !=
> +		    fmt->capabilities)
> +			continue;
> +
> +		if (!(cedrus_formats[i].directions & direction))
> +			continue;
> +
> +		if (index == f->index)
> +			break;
> +
> +		index++;
> +	}
> +
> +	/* Matched format. */
> +	if (i < CEDRUS_FORMATS_COUNT) {
> +		f->pixelformat = cedrus_formats[i].pixelformat;
> +
> +		return 0;
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +static int cedrus_enum_fmt_vid_cap(struct file *file, void *priv,
> +				   struct v4l2_fmtdesc *f)
> +{
> +	return cedrus_enum_fmt(file, f, CEDRUS_DECODE_DST);
> +}
> +
> +static int cedrus_enum_fmt_vid_out(struct file *file, void *priv,
> +				   struct v4l2_fmtdesc *f)
> +{
> +	return cedrus_enum_fmt(file, f, CEDRUS_DECODE_SRC);
> +}
> +
> +static int cedrus_g_fmt_vid_cap(struct file *file, void *priv,
> +				struct v4l2_format *f)
> +{
> +	struct cedrus_ctx *ctx = cedrus_file2ctx(file);
> +
> +	/* Fall back to dummy default by lack of hardware configuration. */
> +	if (!ctx->dst_fmt.width || !ctx->dst_fmt.height) {
> +		f->fmt.pix.pixelformat = V4L2_PIX_FMT_SUNXI_TILED_NV12;
> +		cedrus_prepare_format(&f->fmt.pix);
> +
> +		return 0;
> +	}
> +
> +	f->fmt.pix = ctx->dst_fmt;
> +
> +	return 0;
> +}
> +
> +static int cedrus_g_fmt_vid_out(struct file *file, void *priv,
> +				struct v4l2_format *f)
> +{
> +	struct cedrus_ctx *ctx = cedrus_file2ctx(file);
> +
> +	/* Fall back to dummy default by lack of hardware configuration. */
> +	if (!ctx->dst_fmt.width || !ctx->dst_fmt.height) {
> +		f->fmt.pix.pixelformat = V4L2_PIX_FMT_MPEG2_SLICE;
> +		f->fmt.pix.sizeimage = SZ_1K;
> +		cedrus_prepare_format(&f->fmt.pix);
> +
> +		return 0;
> +	}
> +
> +	f->fmt.pix = ctx->src_fmt;
> +
> +	return 0;
> +}
> +
> +static int cedrus_try_fmt_vid_cap(struct file *file, void *priv,
> +				  struct v4l2_format *f)
> +{
> +	struct cedrus_ctx *ctx = cedrus_file2ctx(file);
> +	struct cedrus_dev *dev = ctx->dev;
> +	struct v4l2_pix_format *pix_fmt = &f->fmt.pix;
> +
> +	if (!cedrus_check_format(pix_fmt->pixelformat, CEDRUS_DECODE_DST,
> +				 dev->capabilities))
> +		return -EINVAL;
> +
> +	cedrus_prepare_format(pix_fmt);
> +
> +	return 0;
> +}
> +
> +static int cedrus_try_fmt_vid_out(struct file *file, void *priv,
> +				  struct v4l2_format *f)
> +{
> +	struct cedrus_ctx *ctx = cedrus_file2ctx(file);
> +	struct cedrus_dev *dev = ctx->dev;
> +	struct v4l2_pix_format *pix_fmt = &f->fmt.pix;
> +
> +	if (!cedrus_check_format(pix_fmt->pixelformat, CEDRUS_DECODE_SRC,
> +				 dev->capabilities))
> +		return -EINVAL;
> +
> +	/* Source image size has to be provided by userspace. */
> +	if (pix_fmt->sizeimage == 0)
> +		return -EINVAL;
> +
> +	cedrus_prepare_format(pix_fmt);
> +
> +	return 0;
> +}
> +
> +static int cedrus_s_fmt_vid_cap(struct file *file, void *priv,
> +				struct v4l2_format *f)
> +{
> +	struct cedrus_ctx *ctx = cedrus_file2ctx(file);
> +	struct cedrus_dev *dev = ctx->dev;
> +	int ret;
> +
> +	ret = cedrus_try_fmt_vid_cap(file, priv, f);
> +	if (ret)
> +		return ret;
> +
> +	ctx->dst_fmt = f->fmt.pix;
> +
> +	cedrus_dst_format_set(dev, &ctx->dst_fmt);
> +
> +	return 0;
> +}
> +
> +static int cedrus_s_fmt_vid_out(struct file *file, void *priv,
> +				struct v4l2_format *f)
> +{
> +	struct cedrus_ctx *ctx = cedrus_file2ctx(file);
> +	int ret;
> +
> +	ret = cedrus_try_fmt_vid_out(file, priv, f);
> +	if (ret)
> +		return ret;
> +
> +	ctx->src_fmt = f->fmt.pix;
> +
> +	/* Propagate colorspace information to capture. */
> +	ctx->dst_fmt.colorspace = f->fmt.pix.colorspace;
> +	ctx->dst_fmt.xfer_func = f->fmt.pix.xfer_func;
> +	ctx->dst_fmt.ycbcr_enc = f->fmt.pix.ycbcr_enc;
> +	ctx->dst_fmt.quantization = f->fmt.pix.quantization;
> +
> +	return 0;
> +}
> +
> +const struct v4l2_ioctl_ops cedrus_ioctl_ops = {
> +	.vidioc_querycap		= cedrus_querycap,
> +
> +	.vidioc_enum_fmt_vid_cap	= cedrus_enum_fmt_vid_cap,
> +	.vidioc_g_fmt_vid_cap		= cedrus_g_fmt_vid_cap,
> +	.vidioc_try_fmt_vid_cap		= cedrus_try_fmt_vid_cap,
> +	.vidioc_s_fmt_vid_cap		= cedrus_s_fmt_vid_cap,
> +
> +	.vidioc_enum_fmt_vid_out	= cedrus_enum_fmt_vid_out,
> +	.vidioc_g_fmt_vid_out		= cedrus_g_fmt_vid_out,
> +	.vidioc_try_fmt_vid_out		= cedrus_try_fmt_vid_out,
> +	.vidioc_s_fmt_vid_out		= cedrus_s_fmt_vid_out,
> +
> +	.vidioc_reqbufs			= v4l2_m2m_ioctl_reqbufs,
> +	.vidioc_querybuf		= v4l2_m2m_ioctl_querybuf,
> +	.vidioc_qbuf			= v4l2_m2m_ioctl_qbuf,
> +	.vidioc_dqbuf			= v4l2_m2m_ioctl_dqbuf,
> +	.vidioc_prepare_buf		= v4l2_m2m_ioctl_prepare_buf,
> +	.vidioc_create_bufs		= v4l2_m2m_ioctl_create_bufs,
> +	.vidioc_expbuf			= v4l2_m2m_ioctl_expbuf,
> +
> +	.vidioc_streamon		= v4l2_m2m_ioctl_streamon,
> +	.vidioc_streamoff		= v4l2_m2m_ioctl_streamoff,
> +
> +	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
> +	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
> +};
> +
> +static int cedrus_queue_setup(struct vb2_queue *vq, unsigned int *nbufs,
> +			      unsigned int *nplanes, unsigned int sizes[],
> +			      struct device *alloc_devs[])
> +{
> +	struct cedrus_ctx *ctx = vb2_get_drv_priv(vq);
> +	struct cedrus_dev *dev = ctx->dev;
> +	struct v4l2_pix_format *pix_fmt;
> +	u32 directions;
> +
> +	if (V4L2_TYPE_IS_OUTPUT(vq->type)) {
> +		directions = CEDRUS_DECODE_SRC;
> +		pix_fmt = &ctx->src_fmt;
> +	} else {
> +		directions = CEDRUS_DECODE_DST;
> +		pix_fmt = &ctx->dst_fmt;
> +	}
> +
> +	if (!cedrus_check_format(pix_fmt->pixelformat, directions,
> +				 dev->capabilities))
> +		return -EINVAL;
> +
> +	if (*nplanes) {
> +		if (sizes[0] < pix_fmt->sizeimage)
> +			return -EINVAL;
> +	} else {
> +		sizes[0] = pix_fmt->sizeimage;
> +		*nplanes = 1;
> +	}
> +
> +	return 0;
> +}
> +
> +static void cedrus_queue_cleanup(struct vb2_queue *vq, u32 state)
> +{
> +	struct cedrus_ctx *ctx = vb2_get_drv_priv(vq);
> +	struct vb2_v4l2_buffer *vbuf;
> +	unsigned long flags;
> +
> +	for (;;) {
> +		spin_lock_irqsave(&ctx->dev->irq_lock, flags);
> +
> +		if (V4L2_TYPE_IS_OUTPUT(vq->type))
> +			vbuf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
> +		else
> +			vbuf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
> +
> +		spin_unlock_irqrestore(&ctx->dev->irq_lock, flags);
> +
> +		if (!vbuf)
> +			return;
> +
> +		v4l2_ctrl_request_complete(vbuf->vb2_buf.req_obj.req,
> +					   &ctx->hdl);
> +		v4l2_m2m_buf_done(vbuf, state);
> +	}
> +}
> +
> +static int cedrus_buf_init(struct vb2_buffer *vb)
> +{
> +	struct vb2_queue *vq = vb->vb2_queue;
> +	struct cedrus_ctx *ctx = vb2_get_drv_priv(vq);
> +
> +	if (!V4L2_TYPE_IS_OUTPUT(vq->type))
> +		ctx->dst_bufs[vb->index] = vb;
> +
> +	return 0;
> +}
> +
> +static void cedrus_buf_cleanup(struct vb2_buffer *vb)
> +{
> +	struct vb2_queue *vq = vb->vb2_queue;
> +	struct cedrus_ctx *ctx = vb2_get_drv_priv(vq);
> +
> +	if (!V4L2_TYPE_IS_OUTPUT(vq->type))
> +		ctx->dst_bufs[vb->index] = NULL;
> +}
> +
> +static int cedrus_buf_prepare(struct vb2_buffer *vb)
> +{
> +	struct vb2_queue *vq = vb->vb2_queue;
> +	struct cedrus_ctx *ctx = vb2_get_drv_priv(vq);
> +	struct v4l2_pix_format *pix_fmt;
> +
> +	if (V4L2_TYPE_IS_OUTPUT(vq->type))
> +		pix_fmt = &ctx->src_fmt;
> +	else
> +		pix_fmt = &ctx->dst_fmt;
> +
> +	if (vb2_plane_size(vb, 0) < pix_fmt->sizeimage)
> +		return -EINVAL;
> +
> +	vb2_set_plane_payload(vb, 0, pix_fmt->sizeimage);
> +
> +	return 0;
> +}
> +
> +static int cedrus_start_streaming(struct vb2_queue *vq, unsigned int count)
> +{
> +	struct cedrus_ctx *ctx = vb2_get_drv_priv(vq);
> +	struct cedrus_dev *dev = ctx->dev;
> +	int ret = 0;
> +
> +	switch (ctx->src_fmt.pixelformat) {
> +	case V4L2_PIX_FMT_MPEG2_SLICE:
> +		ctx->current_codec = CEDRUS_CODEC_MPEG2;
> +		break;
> +
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	if (V4L2_TYPE_IS_OUTPUT(vq->type) &&
> +	    dev->dec_ops[ctx->current_codec]->start)
> +		ret = dev->dec_ops[ctx->current_codec]->start(ctx);
> +
> +	if (ret)
> +		cedrus_queue_cleanup(vq, VB2_BUF_STATE_QUEUED);
> +
> +	return ret;
> +}
> +
> +static void cedrus_stop_streaming(struct vb2_queue *vq)
> +{
> +	struct cedrus_ctx *ctx = vb2_get_drv_priv(vq);
> +	struct cedrus_dev *dev = ctx->dev;
> +
> +	if (V4L2_TYPE_IS_OUTPUT(vq->type) &&
> +	    dev->dec_ops[ctx->current_codec]->stop)
> +		dev->dec_ops[ctx->current_codec]->stop(ctx);
> +
> +	cedrus_queue_cleanup(vq, VB2_BUF_STATE_ERROR);
> +}
> +
> +static void cedrus_buf_queue(struct vb2_buffer *vb)
> +{
> +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> +	struct cedrus_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
> +
> +	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
> +}
> +
> +static void cedrus_buf_request_complete(struct vb2_buffer *vb)
> +{
> +	struct cedrus_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
> +
> +	v4l2_ctrl_request_complete(vb->req_obj.req, &ctx->hdl);
> +}
> +static struct vb2_ops cedrus_qops = {
> +	.queue_setup		= cedrus_queue_setup,
> +	.buf_prepare		= cedrus_buf_prepare,
> +	.buf_init		= cedrus_buf_init,
> +	.buf_cleanup		= cedrus_buf_cleanup,
> +	.buf_queue		= cedrus_buf_queue,
> +	.buf_request_complete	= cedrus_buf_request_complete,
> +	.start_streaming	= cedrus_start_streaming,
> +	.stop_streaming		= cedrus_stop_streaming,
> +	.wait_prepare		= vb2_ops_wait_prepare,
> +	.wait_finish		= vb2_ops_wait_finish,
> +};
> +
> +int cedrus_queue_init(void *priv, struct vb2_queue *src_vq,
> +		      struct vb2_queue *dst_vq)
> +{
> +	struct cedrus_ctx *ctx = priv;
> +	int ret;
> +
> +	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
> +	src_vq->io_modes = VB2_MMAP | VB2_DMABUF;
> +	src_vq->drv_priv = ctx;
> +	src_vq->buf_struct_size = sizeof(struct cedrus_buffer);
> +	src_vq->min_buffers_needed = 1;
> +	src_vq->ops = &cedrus_qops;
> +	src_vq->mem_ops = &vb2_dma_contig_memops;
> +	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	src_vq->lock = &ctx->dev->dev_mutex;
> +	src_vq->dev = ctx->dev->dev;
> +	src_vq->supports_requests = true;
> +
> +	ret = vb2_queue_init(src_vq);
> +	if (ret)
> +		return ret;
> +
> +	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	dst_vq->io_modes = VB2_MMAP | VB2_DMABUF;
> +	dst_vq->drv_priv = ctx;
> +	dst_vq->buf_struct_size = sizeof(struct cedrus_buffer);
> +	dst_vq->min_buffers_needed = 1;
> +	dst_vq->ops = &cedrus_qops;
> +	dst_vq->mem_ops = &vb2_dma_contig_memops;
> +	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	dst_vq->lock = &ctx->dev->dev_mutex;
> +	dst_vq->dev = ctx->dev->dev;
> +
> +	return vb2_queue_init(dst_vq);
> +}
> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_video.h b/drivers/staging/media/sunxi/cedrus/cedrus_video.h
> new file mode 100644
> index 000000000000..0e4f7a8cccf2
> --- /dev/null
> +++ b/drivers/staging/media/sunxi/cedrus/cedrus_video.h
> @@ -0,0 +1,30 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Cedrus VPU driver
> + *
> + * Copyright (C) 2016 Florent Revest <florent.revest@free-electrons.com>
> + * Copyright (C) 2018 Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> + * Copyright (C) 2018 Bootlin
> + *
> + * Based on the vim2m driver, that is:
> + *
> + * Copyright (c) 2009-2010 Samsung Electronics Co., Ltd.
> + * Pawel Osciak, <pawel@osciak.com>
> + * Marek Szyprowski, <m.szyprowski@samsung.com>
> + */
> +
> +#ifndef _CEDRUS_VIDEO_H_
> +#define _CEDRUS_VIDEO_H_
> +
> +struct cedrus_format {
> +	u32		pixelformat;
> +	u32		directions;
> +	unsigned int	capabilities;
> +};
> +
> +extern const struct v4l2_ioctl_ops cedrus_ioctl_ops;
> +
> +int cedrus_queue_init(void *priv, struct vb2_queue *src_vq,
> +		      struct vb2_queue *dst_vq);
> +
> +#endif
> -- 
> 2.18.0
> 
> -- 
> You received this message because you are subscribed to the Google Groups "linux-sunxi" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to linux-sunxi+unsubscribe@googlegroups.com.
> For more options, visit https://groups.google.com/d/optout.
