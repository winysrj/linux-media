Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:40918 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964841Ab2CEN7g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Mar 2012 08:59:36 -0500
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M0F00BQS077PQ@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 05 Mar 2012 13:59:32 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M0F000YE0790Y@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 05 Mar 2012 13:59:33 +0000 (GMT)
Date: Mon, 05 Mar 2012 14:59:30 +0100
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Subject: RE: [PATCH] media: jpeg: add driver for a version 2.x of jpeg H/W
In-reply-to: <002e01ccf805$8a5c2000$9f146000$%song@samsung.com>
To: =?ks_c_5601-1987?B?J7zbv7W48Sc=?= <ym.song@samsung.com>,
	linux-media@vger.kernel.org
Cc: mchehab@infradead.org
Message-id: <000601ccfad8$2f5bff60$8e13fe20$%p@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-language: pl
Content-transfer-encoding: 8BIT
References: <002e01ccf805$8a5c2000$9f146000$%song@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello价康格,


In general I think the v2x support should be designed to require
as little code changes as possible, and they should be related
to pure hardware differences only. Please see comments inline.

The tables (quantization, Huffman) logically contain mostly the
same data both in v3 and v2x and are defined by respective
standards. Only the arrangement of data is slightly different
(bytes vs 4-byte words). Please see comments inline.

On, March 02, 2012 12:47 AM 价康格 wrote:

<...>

> diff --git a/drivers/media/video/s5p-jpeg/jpeg-core.c
> b/drivers/media/video/s5p-jpeg/jpeg-core.c
> index 1105a87..cf917cd 100644
> --- a/drivers/media/video/s5p-jpeg/jpeg-core.c
> +++ b/drivers/media/video/s5p-jpeg/jpeg-core.c

<...>
> diff --git a/drivers/media/video/s5p-jpeg/jpeg-hw-v2x.h
<...>
> @@ -0,0 +1,387 @@
<...>
> +
> +#define S5P_JPEG_MIN_WIDTH		32
> +#define S5P_JPEG_MIN_HEIGHT		32
> +#define S5P_JPEG_MAX_WIDTH		8192
> +#define S5P_JPEG_MAX_HEIGHT		8192
> +#define S5P_JPEG_ENCODE			0
> +#define S5P_JPEG_DECODE			1
> +#define S5P_JPEG_RAW_IN_565		0
> +#define S5P_JPEG_RAW_IN_422		1
> +#define S5P_JPEG_SUBSAMPLING_422	0
> +#define S5P_JPEG_SUBSAMPLING_420	1
> +#define S5P_JPEG_RAW_OUT_422		0
> +#define S5P_JPEG_RAW_OUT_420		1

This is a verbatim copy of what is defined in jpeg-hw-common.h
and should not be repeated here. Use jpeg-hw-common.h.

> +/* Q-table for JPEG */
> +/*  ITU standard Q-table */
> +static unsigned int ITU_Q_tbl[4][16] = {
> +	{
> +	0x01010101, 0x01020303, 0x01010101, 0x01030303, /* Y */
> +	0x01010101, 0x02030303, 0x01010101, 0x03040403,
> +	0x01010203, 0x03050504, 0x01020303, 0x04050605,
> +	0x02030404, 0x05060605, 0x04050505, 0x06050505
> +	} , {
> +	0x01010102, 0x05050505, 0x01010103, 0x05050505, /* CbCr */
> +	0x01010503, 0x05050505, 0x02030505, 0x05050505,
> +	0x05050505, 0x05050505, 0x05050505, 0x05050505,
> +	0x05050505, 0x05050505, 0x05050505, 0x05050505
> +	} , {
> +	0x05020205, 0x0a161e25, 0x02020307, 0x0c232521, /* Y */
> +	0x0302050a, 0x16222b22, 0x0305090e, 0x1e393326,
> +	0x06091422, 0x2a384431, 0x0a122118, 0x34454b3c,
> +	0x1d283238, 0x44525142, 0x2d3c3e40, 0x4a424441
> +	} , {
> +	0x05020205, 0x251e160a, 0x07030202, 0x2125230c, /* CbCr */
> +	0x0a050203, 0x222b2216, 0x0e090503, 0x2633391e,
> +	0x22140906, 0x3144382a, 0x1821120a, 0x3c4b4534,
> +	0x3832281d, 0x42515244, 0x403e3c2d, 0x4144424a
> +	}
> +};

This array is static so this makes all users of this header file
allocate it. Why not put it into jpeg-v2x.c? (however, see
below for considerations about duplication)
This comment applies to all array definitions of this kind
in this file.

> +
> +/* ITU Luminace Huffman Table */
> +static unsigned int ITU_H_tbl_len_DC_luminance[4] = {
> +	0x01050100, 0x01010101, 0x00000001, 0x00000000
> +};

This is in fact the same thing as hdctbl0[16] in jpeg v3,
only arranged in 4-byte words. It would be nice if
the same definitions were used in both versions. This applies
to all tables defined here.

> +static unsigned int ITU_H_tbl_val_DC_luminance[3] = {
> +	0x03020100, 0x07060504, 0x0b0a0908
> +};

The same thing as hdctblg0[12] in jpeg v3.

<...>

> +static unsigned int ITU_H_tbl_val_DC_chrominance[3] = {
> +	0x03020100, 0x07060504, 0x0b0a0908
> +};

The same thing as as hdctblg0[12] in jpeg v3 and
ITU_H_tbl_val_DC_luminance[3] in your code.

> +
> +static unsigned int ITU_H_tbl_len_AC_luminance[4] = {
> +	0x03010200, 0x03040203, 0x04040505, 0x7d010000
> +};
> +

The same thing as hactbl0[16] in jpeg v3.

> +static unsigned int ITU_H_tbl_val_AC_luminance[41] = {
> +	0x00030201, 0x12051104, 0x06413121, 0x07615113,
> +	0x32147122, 0x08a19181, 0xc1b14223, 0xf0d15215,
> +	0x72623324, 0x160a0982, 0x1a191817, 0x28272625,
> +	0x35342a29, 0x39383736, 0x4544433a, 0x49484746,
> +	0x5554534a, 0x59585756, 0x6564635a, 0x69686766,
> +	0x7574736a, 0x79787776, 0x8584837a, 0x89888786,
> +	0x9493928a, 0x98979695, 0xa3a29a99, 0xa7a6a5a4,
> +	0xb2aaa9a8, 0xb6b5b4b3, 0xbab9b8b7, 0xc5c4c3c2,
> +	0xc9c8c7c6, 0xd4d3d2ca, 0xd8d7d6d5, 0xe2e1dad9,
> +	0xe6e5e4e3, 0xeae9e8e7, 0xf4f3f2f1, 0xf8f7f6f5,
> +	0x0000faf9
> +};
> +

The same thing as hactblg0[162] in jpeg v3.

<...>

> +
> +static inline void jpeg_reset(void __iomem *regs)
> +{
> +	unsigned long reg;
> +
> +	reg = readl(regs + S5P_JPEG_CNTL_REG);
> +	writel(reg & ~S5P_JPEG_SOFT_RESET_HI,
> +			regs + S5P_JPEG_CNTL_REG);
> +
> +	ndelay(100000);

Why not use usleep_range?

<...>

> +static inline void jpeg_proc_mode(void __iomem *regs, unsigned long mode)
> +{
> +	unsigned int reg, m;
> +
> +	m = S5P_JPEG_DEC_MODE;
> +	if (mode == S5P_JPEG_ENCODE)
> +		m = S5P_JPEG_ENC_MODE;
> +	else
> +		m = S5P_JPEG_DEC_MODE;
> +
> +	reg = readl(regs + S5P_JPEG_CNTL_REG);
> +	reg &= S5P_JPEG_ENC_DEC_MODE_MASK;
> +	reg |= m;
> +
> +	writel(reg, regs + S5P_JPEG_CNTL_REG);
> +}
> +

This function is in fact an exact copy of its counterpart in v3.
The difference is in the name of the constant which names the
register (S5P_JPEG_CNTL_REG vs S5P_JPEGMOD), however,
the value of this constant is 0x00 in both cases. The
numeric values of ENC/COMPR and DEC/DECOMPR constants are different,
but I believe this could be mitigated some other way.
What is important is that the 2 functions serve the same purpose
and so should be factored out to some common code.

<...>

> +static inline void jpeg_subsampling_mode(void __iomem *regs, unsigned
long
> mode)
> +{
> +	unsigned long reg, m;
> +
> +	m = S5P_JPEG_ENC_FMT_YUV_422;
> +	if (mode == S5P_JPEG_SUBSAMPLING_422)
> +		m = S5P_JPEG_ENC_FMT_YUV_422;
> +	else if (mode == S5P_JPEG_SUBSAMPLING_420)
> +		m = S5P_JPEG_ENC_FMT_YUV_420;
> +
> +	reg = readl(regs + S5P_JPEG_IMG_FMT_REG);
> +	reg &= ~S5P_JPEG_ENC_FMT_MASK;
> +	reg |= m;
> +
> +	writel(reg, regs + S5P_JPEG_IMG_FMT_REG);
> +}
> +

The same here.

<...>

> +
> +static inline void jpeg_jpgadr(void __iomem *regs, unsigned long addr)
> +{
> +	writel(addr, regs + S5P_JPEG_OUT_MEM_BASE_REG);
> +}
> +

The same here.

<...>

> +static inline void jpeg_enc_imgadr(void __iomem *regs, unsigned long
addr)
> +{
> +	writel(addr, regs + S5P_JPEG_IMG_BA_PLANE_1_REG);
> +}
> +

This looks like jpeg_imgadr() from v3.


<...>

> diff --git a/drivers/media/video/s5p-jpeg/jpeg-regs-v2x.h
> b/drivers/media/video/s5p-jpeg/jpeg-regs-v2x.h
> new file mode 100644
> index 0000000..8305475
> --- /dev/null
> +++ b/drivers/media/video/s5p-jpeg/jpeg-regs-v2x.h
> @@ -0,0 +1,150 @@
> +/* linux/drivers/media/video/s5p-jpeg/jpeg-regs-v2x.h
> + *
> + * Register definition file for Samsung JPEG codec driver
> + *
> + * Copyright (c) 2012 Samsung Electronics Co., Ltd.
> + *		http:www.samsung.com
> + *
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef JPEG_REGS_H_
> +#define JPEG_REGS_H_
> +
> +/* JPEG Codec Control Registers */
> +#define S5P_JPEG_CNTL_REG		0x00
> +#define S5P_JPEG_INT_EN_REG		0x04
> +#define S5P_JPEG_INT_STATUS_REG		0x0c
> +#define S5P_JPEG_OUT_MEM_BASE_REG		0x10
> +#define S5P_JPEG_IMG_SIZE_REG		0x14
> +#define S5P_JPEG_IMG_BA_PLANE_1_REG		0x18
> +#define S5P_JPEG_IMG_BA_PLANE_2_REG		0x24
> +#define S5P_JPEG_IMG_BA_PLANE_3_REG		0x30
> +
> +#define S5P_JPEG_TBL_SEL_REG		0x3c
> +
> +#define S5P_JPEG_IMG_FMT_REG		0x40
> +
> +#define S5P_JPEG_BITSTREAM_SIZE_REG		0x44
> +#define S5P_JPEG_HUFF_CNT_REG		0x4c
> +
> +#define S5P_JPEG_QUAN_TBL_ENTRY_REG		0x100
> +#define S5P_JPEG_HUFF_TBL_ENTRY_REG		0x200
> +
> +
> +/****************************************************************/
> +/* Bit definition part
> 			*/
> +/****************************************************************/
> +
> +/* JPEG CNTL Register bit */
> +#define S5P_JPEG_ENC_DEC_MODE_MASK			(0xfffffffc << 0)
> +#define S5P_JPEG_DEC_MODE			(1 << 0)
> +#define S5P_JPEG_ENC_MODE			(1 << 1)
> +#define S5P_JPEG_HUF_TBL_EN			(1 << 19)
> +#define S5P_JPEG_HOR_SCALING_SHIFT		20
> +#define S5P_JPEG_HOR_SCALING_MASK		\
> +			(3 << S5P_JPEG_HOR_SCALING_SHIFT)
> +#define S5P_JPEG_HOR_SCALING(x)			\
> +			(((x) & 0x3) << S5P_JPEG_HOR_SCALING_SHIFT)
> +#define S5P_JPEG_VER_SCALING_SHIFT		22
> +#define S5P_JPEG_VER_SCALING_MASK		\
> +			(3 << S5P_JPEG_VER_SCALING_SHIFT)
> +#define S5P_JPEG_VER_SCALING(x)			\
> +			(((x) & 0x3) << S5P_JPEG_VER_SCALING_SHIFT)
> +#define S5P_JPEG_SOFT_RESET_HI			(1 << 29)
> +
> +/* JPEG INT Register bit */
> +#define S5P_JPEG_INT_EN_MASK			(0x1f << 0)
> +#define S5P_JPEG_INT_EN_ALL			(0x1f << 0)
> +
> +/* JPEG IMAGE SIZE Register bit */
> +#define S5P_JPEG_X_SIZE_SHIFT		0
> +#define S5P_JPEG_X_SIZE_MASK		(0xffff << S5P_JPEG_X_SIZE_SHIFT)
> +#define S5P_JPEG_X_SIZE(x)			\
> +			(((x) & 0xffff) << S5P_JPEG_X_SIZE_SHIFT)
> +#define S5P_JPEG_Y_SIZE_SHIFT		16
> +#define S5P_JPEG_Y_SIZE_MASK		(0xffff << S5P_JPEG_Y_SIZE_SHIFT)
> +#define S5P_JPEG_Y_SIZE(x)			\
> +			(((x) & 0xffff) << S5P_JPEG_Y_SIZE_SHIFT)
> +
> +/* JPEG IMAGE FORMAT Register bit */
> +#define S5P_JPEG_ENC_IN_FMT_MASK		0xffff0000
> +#define S5P_JPEG_ENC_RGB_IMG		(1 << 0)

This is used only in one place in jpeg_input_raw_mode together with

<...>

this:
> +#define S5P_JPEG_RGB_IP_RGB_16BIT_IMG		(4 <<
S5P_JPEG_RGB_IP_SHIFT)

To form one constant, while 


> +#define S5P_JPEG_YUV_422_IP_YUV_422_1P_IMG		\
> +			(4 << S5P_JPEG_YUV_422_IP_SHIFT)

is only used in two places to form another constant.

If the constants were defined not combined from parts then
jpeg_input_raw_mode is effectively the same as in v3.
And a good candidate to factor out to some common code.

> +
> +#define S5P_JPEG_YUV_420_IP_SHIFT		15
> +#define S5P_JPEG_YUV_420_IP_MASK		(7 <<
S5P_JPEG_YUV_420_IP_SHIFT)
> +#define S5P_JPEG_YUV_420_IP_YUV_420_3P_IMG		\
> +			(5 << S5P_JPEG_YUV_420_IP_SHIFT)
> +
> +#define S5P_JPEG_ENC_FMT_SHIFT		24
> +#define S5P_JPEG_ENC_FMT_MASK		(3 <<
S5P_JPEG_ENC_FMT_SHIFT)
> +#define S5P_JPEG_ENC_FMT_YUV_444		(1 <<
S5P_JPEG_ENC_FMT_SHIFT)
> +#define S5P_JPEG_ENC_FMT_YUV_422		(2 <<
S5P_JPEG_ENC_FMT_SHIFT)
> +#define S5P_JPEG_ENC_FMT_YUV_420		(3 <<
S5P_JPEG_ENC_FMT_SHIFT)
> +
> +/* JPEG TBL SEL Register bit */
> +#define S5P_JPEG_Q_TBL_COMP1_SHIFT	0
> +#define S5P_JPEG_Q_TBL_COMP1_0		(0 <<
S5P_JPEG_Q_TBL_COMP1_SHIFT)
> +#define S5P_JPEG_Q_TBL_COMP1_1		(1 <<
S5P_JPEG_Q_TBL_COMP1_SHIFT)
> +#define S5P_JPEG_Q_TBL_COMP1_2		(2 <<
S5P_JPEG_Q_TBL_COMP1_SHIFT)
> +#define S5P_JPEG_Q_TBL_COMP1_3		(3 <<
S5P_JPEG_Q_TBL_COMP1_SHIFT)
> +
> +#define S5P_JPEG_Q_TBL_COMP2_SHIFT	2
> +#define S5P_JPEG_Q_TBL_COMP2_0		(0 <<
S5P_JPEG_Q_TBL_COMP2_SHIFT)
> +#define S5P_JPEG_Q_TBL_COMP2_1		(1 <<
S5P_JPEG_Q_TBL_COMP2_SHIFT)
> +#define S5P_JPEG_Q_TBL_COMP2_2		(2 <<
S5P_JPEG_Q_TBL_COMP2_SHIFT)
> +#define S5P_JPEG_Q_TBL_COMP2_3		(3 <<
S5P_JPEG_Q_TBL_COMP2_SHIFT)
> +
> +#define S5P_JPEG_Q_TBL_COMP3_SHIFT	4
> +#define S5P_JPEG_Q_TBL_COMP3_0		(0 <<
S5P_JPEG_Q_TBL_COMP3_SHIFT)
> +#define S5P_JPEG_Q_TBL_COMP3_1		(1 <<
S5P_JPEG_Q_TBL_COMP2_SHIFT)
> +#define S5P_JPEG_Q_TBL_COMP3_2		(2 <<
S5P_JPEG_Q_TBL_COMP2_SHIFT)
> +#define S5P_JPEG_Q_TBL_COMP3_3		(3 <<
S5P_JPEG_Q_TBL_COMP2_SHIFT)
> +
> +#define S5P_JPEG_HUFF_TBL_COMP1_SHIFT			6
> +#define S5P_JPEG_HUFF_TBL_COMP1_AC_0_DC_0		\
> +			(0 << S5P_JPEG_HUFF_TBL_COMP1_SHIFT)
> +#define S5P_JPEG_HUFF_TBL_COMP1_AC_0_DC_1		\
> +			(1 << S5P_JPEG_HUFF_TBL_COMP1_SHIFT)
> +#define S5P_JPEG_HUFF_TBL_COMP1_AC_1_DC_0		\
> +			(2 << S5P_JPEG_HUFF_TBL_COMP1_SHIFT)
> +#define S5P_JPEG_HUFF_TBL_COMP1_AC_1_DC_1		\
> +			(3 << S5P_JPEG_HUFF_TBL_COMP1_SHIFT)
> +
> +#define S5P_JPEG_HUFF_TBL_COMP2_SHIFT			8
> +#define S5P_JPEG_HUFF_TBL_COMP2_AC_0_DC_0		\
> +			(0 << S5P_JPEG_HUFF_TBL_COMP2_SHIFT)
> +#define S5P_JPEG_HUFF_TBL_COMP2_AC_0_DC_1		\
> +			(1 << S5P_JPEG_HUFF_TBL_COMP2_SHIFT)
> +#define S5P_JPEG_HUFF_TBL_COMP2_AC_1_DC_0		\
> +			(2 << S5P_JPEG_HUFF_TBL_COMP2_SHIFT)
> +#define S5P_JPEG_HUFF_TBL_COMP2_AC_1_DC_1		\
> +			(3 << S5P_JPEG_HUFF_TBL_COMP2_SHIFT)
> +
> +#define S5P_JPEG_HUFF_TBL_COMP3_SHIFT			10
> +#define S5P_JPEG_HUFF_TBL_COMP3_AC_0_DC_0		\
> +			(0 << S5P_JPEG_HUFF_TBL_COMP3_SHIFT)
> +#define S5P_JPEG_HUFF_TBL_COMP3_AC_0_DC_1		\
> +			(1 << S5P_JPEG_HUFF_TBL_COMP3_SHIFT)
> +#define S5P_JPEG_HUFF_TBL_COMP3_AC_1_DC_0		\
> +			(2 << S5P_JPEG_HUFF_TBL_COMP3_SHIFT)
> +#define S5P_JPEG_HUFF_TBL_COMP3_AC_1_DC_1		\
> +			(3 << S5P_JPEG_HUFF_TBL_COMP3_SHIFT)
> +

Perhaps you could use some smarter macros, e.g. with parameters?


> +#endif /* JPEG_REGS_H_ */
> diff --git a/drivers/media/video/s5p-jpeg/jpeg-v2x.c
> b/drivers/media/video/s5p-jpeg/jpeg-v2x.c
> new file mode 100644
> index 0000000..71bd38b
> --- /dev/null
> +++ b/drivers/media/video/s5p-jpeg/jpeg-v2x.c
> @@ -0,0 +1,129 @@
> +/* linux/drivers/media/video/s5p-jpeg/jpeg-v2x.c
> + *
> + * Copyright (c) 2012 Samsung Electronics Co., Ltd.
> + *		http://www.samsung.com
> + *
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/err.h>
> +#include <linux/gfp.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/slab.h>
> +#include <linux/spinlock.h>
> +#include <linux/string.h>
> +#include <media/v4l2-mem2mem.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/videobuf2-core.h>
> +#include <media/videobuf2-dma-contig.h>
> +
> +#include "jpeg-core.h"
> +#include "jpeg-hw-v2x.h"
> +
> +/*
> + *
>
============================================================================
> + * mem2mem callbacks
> + *
>
============================================================================
> + */
> +
> +void s5p_jpeg_irq_execute(void *dev_id)
> +{
> +	struct s5p_jpeg *jpeg = dev_id;
> +	struct s5p_jpeg_ctx *curr_ctx;
> +	struct vb2_buffer *src_buf, *dst_buf;
> +	unsigned long payload_size = 0;
> +	enum vb2_buffer_state state = VB2_BUF_STATE_DONE;
> +
> +	unsigned int int_status;
> +
> +	curr_ctx = v4l2_m2m_get_curr_priv(jpeg->m2m_dev);
> +
> +	src_buf = v4l2_m2m_src_buf_remove(curr_ctx->m2m_ctx);
> +	dst_buf = v4l2_m2m_dst_buf_remove(curr_ctx->m2m_ctx);
> +
> +	int_status = jpeg_get_int_status(jpeg->regs);
> +
> +	if (int_status != 0x2)
> +		state = VB2_BUF_STATE_ERROR;
> +
> +	v4l2_m2m_buf_done(src_buf, state);
> +	if (curr_ctx->mode == S5P_JPEG_ENCODE && int_status == 0x2) {
> +		payload_size = jpeg_compressed_size(jpeg->regs);
> +		vb2_set_plane_payload(dst_buf, 0, payload_size);
> +	}
> +	v4l2_m2m_buf_done(dst_buf, state);
> +	v4l2_m2m_job_finish(jpeg->m2m_dev, curr_ctx->m2m_ctx);
> +}
> +

This function is almost the same as its counterpart in jpeg v3.
The difference is only in reading the interrupt cause, while
mem2mem operations are exacty the same. This makes maintenance
more difficult: whenever mem2mem usage changes, it needs to be
updated in 2 places. I think that wherever mem2mem operations are
the same in v2 and v3, they should be factored out to some common
code.

> +void s5p_jpeg_execute(void *priv)
> +{
> +	struct s5p_jpeg_ctx *ctx = priv;
> +	struct s5p_jpeg *jpeg = ctx->jpeg;
> +	struct vb2_buffer *src_buf, *dst_buf;
> +	unsigned long src_addr, dst_addr;
> +
> +	src_buf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
> +	dst_buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
> +
> +	src_addr = vb2_dma_contig_plane_dma_addr(src_buf, 0);
> +	dst_addr = vb2_dma_contig_plane_dma_addr(dst_buf, 0);
> +
> +	jpeg_reset(jpeg->regs);
> +	jpeg_set_interrupt(jpeg->regs);
> +
> +	if (ctx->mode == S5P_JPEG_ENCODE) {
> +		jpeg_set_huf_table_enable(jpeg->regs, 1);
> +		jpeg_qtbl(jpeg->regs);
> +		jpeg_htbl_ac(jpeg->regs);
> +		jpeg_htbl_dc(jpeg->regs);
> +		jpeg_set_encode_tbl_select(jpeg->regs, ctx->compr_quality);
> +		jpeg_x_y(jpeg->regs, ctx->out_q.w, ctx->out_q.h);
> +
> +		if (ctx->out_q.fmt->fourcc == V4L2_PIX_FMT_RGB565)
> +			jpeg_input_raw_mode(jpeg->regs,
S5P_JPEG_RAW_IN_565);
> +		else
> +			jpeg_input_raw_mode(jpeg->regs,
S5P_JPEG_RAW_IN_422);
> +		if (ctx->cap_q.fmt->fourcc == V4L2_PIX_FMT_YUYV)
> +			jpeg_subsampling_mode(jpeg->regs,
> +					      S5P_JPEG_SUBSAMPLING_422);
> +		else
> +			jpeg_subsampling_mode(jpeg->regs,
> +					      S5P_JPEG_SUBSAMPLING_420);
> +
> +		jpeg_enc_imgadr(jpeg->regs, src_addr);
> +		jpeg_jpgadr(jpeg->regs, dst_addr);
> +		jpeg_set_encode_hoff_cnt(jpeg->regs);

This part is almost a verbatim copy of its counterpart from v3,
only the sequence of operations is different and some calls are
grouped into separate functions (e.g. jpeg_htbl_ac, jpeg_htbl_dc,
jpeg_qtbl). Why not factor out into some common piece of code?

> +	} else {
> +		jpeg_set_encode_tbl_select(jpeg->regs, 0);
> +		jpeg_set_dec_scaling(jpeg->regs, 0, 0);
> +		jpeg_jpgadr(jpeg->regs, src_addr);
> +		if (ctx->cap_q.fmt->fourcc == V4L2_PIX_FMT_YUYV) {
> +			jpeg_dec_imgadr(jpeg->regs, dst_addr,
> +						S5P_JPEG_RAW_OUT_422,
> +						ctx->out_q.w, ctx->out_q.h);
> +			jpeg_outform_raw(jpeg->regs, S5P_JPEG_RAW_OUT_422);
> +		} else {
> +			jpeg_dec_imgadr(jpeg->regs, dst_addr,
> +						S5P_JPEG_RAW_OUT_420,
> +						ctx->out_q.w, ctx->out_q.h);
> +			jpeg_outform_raw(jpeg->regs, S5P_JPEG_RAW_OUT_420);
> +		}

This looks like this patch: http://patchwork.linuxtv.org/patch/10004/
If you applied it to version 2x, it would be nice if you applied it
to version 3, too.


> +		jpeg_set_dec_bitstream_size(jpeg->regs,
> +						ctx->out_q.size / 32 + 1);
> +	}
> +	jpeg_proc_mode(jpeg->regs, ctx->mode);
> +}
> +
> +void s5p_jpeg_runtime_resume_execute(struct device *dev)
> +{
> +
> +}

<...>




