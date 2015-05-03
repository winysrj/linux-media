Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40871 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbbEDHoX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 May 2015 03:44:23 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
Cc: hverkuil@xs4all.nl, horms@verge.net.au, magnus.damm@gmail.com,
	sergei.shtylyov@cogentembedded.com, linux-media@vger.kernel.org,
	linux-sh@vger.kernel.org
Subject: Re: [PATCH v3 1/1] V4L2: platform: Renesas R-Car JPEG codec driver
Date: Mon, 04 May 2015 02:32:05 +0300
Message-ID: <5004544.CpPfGJfHMn@avalon>
In-Reply-To: <1430344409-11928-1-git-send-email-mikhail.ulyanov@cogentembedded.com>
References: <1430344409-11928-1-git-send-email-mikhail.ulyanov@cogentembedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mikhail,

Thank you for the patch. Please see below for a (partial) review.

On Thursday 30 April 2015 00:53:29 Mikhail Ulyanov wrote:
> Here's the the driver for the Renesas R-Car JPEG processing unit driver.
> 
> The driver is implemented within the V4L2 framework as a mem-to-mem device. 
> It presents two video nodes to userspace, one for the encoding part, and
> one for the decoding part.
> 
> It was found that the only working mode for encoding is no markers output,
> so we generate it with software. In current version of driver we also use
> software JPEG header parsing because with hardware parsing performance is
> lower then desired.

Just out of curiosity, what is the performance impact of hardware parsing ?

> From a userspace point of view the encoding process is typical (S_FMT,
> REQBUF, optionally QUERYBUF, QBUF, STREAMON, DQBUF) for both the source and
> destination queues. The decoding process requires that the source queue
> performs S_FMT, REQBUF, (QUERYBUF), QBUF and STREAMON. After STREAMON on
> the source queue, it is possible to perform G_FMT on the destination queue
> to find out the processed image width and height in order to be able to
> allocate an appropriate buffer - it is assumed that the user does not pass
> the compressed image width and height but instead this information is
> parsed from the JPEG input. This is done in kernel. Then REQBUF, QBUF and
> STREAMON on the destination queue complete the decoding and it is possible
> to DQBUF from both queues and finish the operation.
> 
> During encoding the available formats are: V4L2_PIX_FMT_NV12M and
> V4L2_PIX_FMT_NV16M for source and V4L2_PIX_FMT_JPEG for destination.
> 
> During decoding the available formats are: V4L2_PIX_FMT_JPEG for source and
> V4L2_PIX_FMT_NV12M and V4L2_PIX_FMT_NV16M for destination.
> 
> Performance of current version:
> 1280x800 NV12 image encoding/decoding
> 	decoding ~121 FPS
> 	encoding ~190 FPS
> 
> Signed-off-by: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
> ---
> Changes since v2:
>     - Kconfig entry reordered
>     - unnecessary clk_disable_unprepare(jpu->clk) removed
>     - ref_count fixed in jpu_resume
>     - enable DMABUF in src_vq->io_modes
>     - remove jpu_s_priority jpu_g_priority
>     - jpu_g_selection fixed
>     - timeout in jpu_reset added and hardware reset reworked
>     - remove unused macros
>     - JPEG header parsing now is software because of performance issues
>       based on s5p-jpu code
>     - JPEG header generation redesigned:
>       JPEG header(s) pre-generated and memcpy'ed on encoding
>       we only fill the necessary fields
>       more "transparent" header format description
>     - S_FMT, G_FMT and TRY_FMT hooks redesigned
>       partially inspired by VSP1 driver code
>     - some code was reformatted
>     - image formats handling redesigned
>     - multi-planar V4L2 API now in use
>     - now passes v4l2-compliance tool check
> 
> Cnanges since v1:
>     - s/g_fmt function simplified
>     - default format for queues added
>     - dumb vidioc functions added to be in compliance with standard api:
>         jpu_s_priority, jpu_g_priority
>     - standard v4l2_ctrl_subscribe_event and v4l2_event_unsubscribe
>       now in use by the same reason
> 
>  drivers/media/platform/Kconfig  |   11 +
>  drivers/media/platform/Makefile |    1 +
>  drivers/media/platform/jpu.c    | 1724 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 1736 insertions(+)
>  create mode 100644 drivers/media/platform/jpu.c
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 765bffb..33a457c 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -220,6 +220,17 @@ config VIDEO_SH_VEU
>  	    Support for the Video Engine Unit (VEU) on SuperH and
>  	    SH-Mobile SoCs.
> 
> +config VIDEO_RENESAS_JPU
> +	tristate "Renesas JPEG Processing Unit"
> +	depends on VIDEO_DEV && VIDEO_V4L2
> +	select VIDEOBUF2_DMA_CONTIG
> +	select V4L2_MEM2MEM_DEV
> +	---help---
> +	  This is a V4L2 driver for the Renesas JPEG Processing Unit.
> +
> +	  To compile this driver as a module, choose M here: the module
> +	  will be called jpu.
> +
>  config VIDEO_RENESAS_VSP1
>  	tristate "Renesas VSP1 Video Processing Engine"
>  	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && HAS_DMA
> diff --git a/drivers/media/platform/Makefile
> b/drivers/media/platform/Makefile index a49936b..1399c0d 100644
> --- a/drivers/media/platform/Makefile
> +++ b/drivers/media/platform/Makefile
> @@ -42,6 +42,7 @@ obj-$(CONFIG_VIDEO_SH_VOU)		+= sh_vou.o
> 
>  obj-$(CONFIG_SOC_CAMERA)		+= soc_camera/
> 
> +obj-$(CONFIG_VIDEO_RENESAS_JPU) 	+= jpu.o
>  obj-$(CONFIG_VIDEO_RENESAS_VSP1)	+= vsp1/
> 
>  obj-y	+= omap/
> diff --git a/drivers/media/platform/jpu.c b/drivers/media/platform/jpu.c
> new file mode 100644
> index 0000000..6c658cc
> --- /dev/null
> +++ b/drivers/media/platform/jpu.c
> @@ -0,0 +1,1724 @@
> +/*
> + * Author: Mikhail Ulyanov
> + * Copyright (C) 2014-2015 Cogent Embedded, Inc. 
> <source@cogentembedded.com>
> + * Copyright (C) 2014-2015 Renesas Electronics Corporation
> + *
> + * This is based on the drivers/media/platform/s5p-jpeg driver by
> + * Andrzej Pietrasiewicz and Jacek Anaszewski.
> + * Some portions of code inspired by VSP1 driver by Laurent Pinchart.
> + *
> + * TODO in order of priority:
> + *      1) Multiple buffers support
> + *      2) NV21* and NV61* formats support
> + *      3) Semiplanar formats support
> + *      4) Rotation support
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/err.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/spinlock.h>
> +#include <linux/string.h>
> +#include <linux/videodev2.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-event.h>
> +#include <media/v4l2-fh.h>
> +#include <media/v4l2-mem2mem.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/videobuf2-core.h>
> +#include <media/videobuf2-dma-contig.h>
> +
> +
> +#define JPU_M2M_NAME "jpu"
> +
> +/*
> + * Little more than described (8.25) in
> + * http://en.wikipedia.org/wiki/JPEG#Sample_photographs
> + */
> +#define JPU_JPEG_MAX_BITS_PER_PIXEL	9
> +#define JPU_JPEG_HDR_SIZE		0x258
> +#define JPU_JPEG_QTBL_SIZE		0x40
> +#define JPU_JPEG_HDCTBL_SIZE		0x1c
> +#define JPU_JPEG_HACTBL_SIZE		0xb2
> +#define JPU_JPEG_HEIGHT_OFFSET		0x91
> +#define JPU_JPEG_WIDTH_OFFSET		0x93
> +#define JPU_JPEG_SUBS_OFFSET		0x97
> +#define JPU_JPEG_QTBL_LUM_OFFSET	0x07
> +#define JPU_JPEG_QTBL_CHR_OFFSET	0x4c
> +#define JPU_JPEG_HDCTBL_LUM_OFFSET	0xa4
> +#define JPU_JPEG_HACTBL_LUM_OFFSET	0xc5
> +#define JPU_JPEG_HDCTBL_CHR_OFFSET	0x17c
> +#define JPU_JPEG_HACTBL_CHR_OFFSET	0x19d
> +#define JPU_JPEG_LUM 0x00
> +#define JPU_JPEG_CHR 0x01
> +#define JPU_JPEG_DC  0x00
> +#define JPU_JPEG_AC  0x10
> +
> +#define JPU_JPEG_422 0x21
> +#define JPU_JPEG_420 0x22
> +
> +/* JPEG markers */
> +#define TEM	0x01
> +#define SOF0	0xc0
> +#define RST	0xd0
> +#define SOI	0xd8
> +#define EOI	0xd9
> +#define DHP	0xde
> +#define DHT	0xc4
> +#define COM	0xfe
> +#define DQT	0xdb
> +
> +#define JPU_RESET_TIMEOUT	100 /* ms */
> +#define JPU_MAX_QUALITY		4
> +#define JPU_WIDTH_MIN		16
> +#define JPU_HEIGHT_MIN		16
> +#define JPU_WIDTH_MAX		4096
> +#define JPU_HEIGHT_MAX		4096
> +#define JPU_MEMALIGN		0x8
> +
> +/* Flags that indicate a format can be used for capture/output */
> +#define JPU_FMT_TYPE_OUTPUT	0
> +#define JPU_FMT_TYPE_CAPTURE	1
> +#define JPU_ENC_CAPTURE		(1 << 0)
> +#define JPU_ENC_OUTPUT		(1 << 1)
> +#define JPU_DEC_CAPTURE		(1 << 2)
> +#define JPU_DEC_OUTPUT		(1 << 3)
> +
> +/*
> + * JPEG registers and bits
> + */
> +
> +/* JPEG code mode register */
> +#define JCMOD	0x00
> +#define JCMOD_PCTR		(1 << 7)
> +#define JCMOD_MSKIP_ENABLE	(1 << 5)
> +#define JCMOD_DSP_ENC		(0 << 3)
> +#define JCMOD_DSP_DEC		(1 << 3)
> +#define JCMOD_REDU		(7 << 0)
> +#define JCMOD_REDU_422		(1 << 0)
> +#define JCMOD_REDU_420		(2 << 0)
> +
> +/* JPEG code command register */
> +#define JCCMD	0x04
> +#define JCCMD_SRST	(1 << 12)
> +#define JCCMD_JEND	(1 << 2)
> +#define JCCMD_JSRT	(1 << 0)
> +
> +/* JPEG code quantanization table number register */
> +#define JCQTN	0x0c
> +#define JCQTN_SHIFT(t)		(((t) - 1) << 1)
> +
> +/* JPEG code Huffman table number register */
> +#define JCHTN	0x10
> +#define JCHTN_AC_SHIFT(t)	(((t) << 1) - 1)
> +#define JCHTN_DC_SHIFT(t)	(((t) - 1) << 1)
> +
> +#define JCVSZU	0x1c /* JPEG code vertical size upper register */
> +#define JCVSZD	0x20 /* JPEG code vertical size lower register */
> +#define JCHSZU	0x24 /* JPEG code horizontal size upper register */
> +#define JCHSZD	0x28 /* JPEG code horizontal size lower register */
> +#define JCSZ_MASK 0xff /* JPEG code h/v size register contains only 1
> byte*/ +
> +#define JCDTCU	0x2c /* JPEG code data count upper register */
> +#define JCDTCM	0x30 /* JPEG code data count middle register */
> +#define JCDTCD	0x34 /* JPEG code data count lower register */
> +
> +/* JPEG interrupt enable register */
> +#define JINTE	0x38
> +#define JINTE_HDR_PARSED	(1 << 3)
> +#define JINTE_ERR		(0x7 << 5) /* INT5 + INT6 + INT7 */
> +#define JINTE_TRANSF_COMPL	(1 << 10)
> +
> +/* JPEG interrupt status register */
> +#define JINTS	0x3c
> +#define JINTS_MASK	0x7c68
> +#define JINTS_HDR_PARSED	(1 << 3)
> +#define JINTS_ERR		(1 << 5)
> +#define JINTS_PROCESS_COMPL	(1 << 6)
> +#define JINTS_TRANSF_COMPL	(1 << 10)
> +
> +#define JCDERR	0x40 /* JPEG code decode error register */
> +
> +/* JPEG interface encoding */
> +#define JIFECNT	0x70
> +#define JIFECNT_INFT_422	0
> +#define JIFECNT_INFT_420	1
> +#define JIFECNT_SWAP_WB		(0x3 << 4)
> +
> +#define JIFESYA1	0x74	/* encode source Y address register 1 */
> +#define JIFESCA1	0x78	/* encode source C address register 1 */
> +#define JIFESYA2	0x7c	/* encode source Y address register 2 */
> +#define JIFESCA2	0x80	/* encode source C address register 2 */
> +#define JIFESMW		0x84	/* encode source memory width register */
> +#define JIFESVSZ	0x88	/* encode source vertical size register */
> +#define JIFESHSZ	0x8c	/* encode source horizontal size register */
> +#define JIFEDA1		0x90	/* encode destination address register 1 */
> +#define JIFEDA2		0x94	/* encode destination address register 2 */
> +
> +/* JPEG decoding control register */
> +#define JIFDCNT	0xa0
> +#define JIFDCNT_SWAP		(3 << 1)
> +#define JIFDCNT_SWAP_WB		(3 << 1)
> +
> +#define JIFDSA1		0xa4	/* decode source address register 1 */
> +#define JIFDDMW		0xb0	/* decode destination  memory width register */
> +#define JIFDDVSZ	0xb4	/* decode destination  vert. size register */
> +#define JIFDDHSZ	0xb8	/* decode destination  horiz. size register */
> +#define JIFDDYA1	0xbc	/* decode destination  Y address register 1 */
> +#define JIFDDCA1	0xc0	/* decode destination  C address register 1 */
> +
> +#define JCQTBL(n)	(0x10000 + (n) * 0x40)	/* quantization tables regs */
> +#define JCHTBD(n)	(0x10100 + (n) * 0x100)	/* Huffman table DC regs */
> +#define JCHTBA(n)	(0x10120 + (n) * 0x100)	/* Huffman table AC regs */
> +
> +/**
> + * struct jpu - JPEG IP abstraction
> + * @mutex: the mutex protecting this structure
> + * @lock: spinlock protecting the device contexts
> + * @v4l2_dev: v4l2 device for mem2mem mode
> + * @vfd_encoder: video device node for encoder mem2mem mode
> + * @vfd_decoder: video device node for decoder mem2mem mode
> + * @m2m_dev: v4l2 mem2mem device data
> + * @regs: JPEG IP registers mapping
> + * @irq: JPEG IP irq
> + * @clk: JPEG IP clock
> + * @dev: JPEG IP struct device
> + * @alloc_ctx: videobuf2 memory allocator's context
> + * @ref_counter: reference counter
> + */
> +struct jpu {
> +	struct mutex	mutex;
> +	spinlock_t	lock;
> +	struct v4l2_device	v4l2_dev;
> +	struct video_device	*vfd_encoder;
> +	struct video_device	*vfd_decoder;
> +	struct v4l2_m2m_dev	*m2m_dev;
> +
> +	void __iomem		*regs;
> +	unsigned int		irq;
> +	struct clk		*clk;
> +	struct device		*dev;
> +	void			*alloc_ctx;
> +	int			ref_count;
> +};
> +
> +/**
> + * struct jpu_fmt - driver's internal format data
> + * @name: format description
> + * @fourcc: the fourcc code, 0 if not applicable
> + * @colorspace: the colorspace specifier
> + * @bpp: number of bits per pixel per plane
> + * @h_align: horizontal alignment order (align to 2^h_align)
> + * @v_align: vertical alignment order (align to 2^v_align)
> + * @subsampling: (horizontal:4 | vertical:4) subsampling factor
> + * @num_planes: number of planes
> + * @types: types of queue this format is applicable to
> + */
> +struct jpu_fmt {
> +	char *name;
> +	u32 fourcc;
> +	u32 colorspace;
> +	u8 bpp[2];
> +	u8 h_align;
> +	u8 v_align;
> +	u8 subsampling;
> +	u8 num_planes;
> +	u16 types;
> +};
> +
> +/**
> + * jpu_q_data - parameters of one queue
> + * @fmtinfo: driver-specific format of this queue
> + * @format: multiplanar format of this queue
> + */
> +struct jpu_q_data {
> +	struct jpu_fmt *fmtinfo;
> +	struct v4l2_pix_format_mplane format;
> +};
> +
> +/**
> + * jpu_ctx - the device context data
> + * @jpu: JPEG IP device for this context
> + * @encoder: compression (encode) operation or decompression (decode)
> + * @hdr_parsed: set if header has been parsed during decompression
> + * @compr_quality: destination image quality in compression (encode) mode
> + * @out_q: source (output) queue information
> + * @cap_q: destination (capture) queue information
> + * @fh: file handler
> + * @ctrl_handler: controls handler
> + */
> +struct jpu_ctx {
> +	struct jpu		*jpu;
> +	bool			encoder;
> +	bool			hdr_parsed;
> +	unsigned short		compr_quality;
> +	struct jpu_q_data	out_q;
> +	struct jpu_q_data	cap_q;
> +	struct v4l2_fh		fh;
> +	struct v4l2_ctrl_handler ctrl_handler;
> +};
> +
> +/**
> + * jpeg_buffer - description of memory containing input JPEG data
> + * @size: buffer size
> + * @curr: current position in the buffer
> + * @data: pointer to the data
> + */
> +struct jpeg_buffer {
> +	unsigned long size;
> +	unsigned long curr;
> +	unsigned long data;

What's wrong with a void * for a data pointer ?

> +};

[snip]

> +/*
> + * ========================================================================
> + * video ioctl operations
> + * ========================================================================
> + */
> +static void put_qtbl(u8 *p, const unsigned int *qtbl)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(zigzag); i++)
> +		*(p + i) = *((const u8 *)qtbl + zigzag[i]);
> +}
> +
> +static void put_htbl(u8 *p, const u8 *htbl, unsigned int len)
> +{
> +	unsigned int i, j;
> +
> +	for (i = 0; i < len; i += 4)
> +		for (j = 0; j < 4 && (i + j) < len; ++j)
> +			p[i + j] = htbl[i + 3 - j];

Instead of converting the tables to big endian for every frame, how about 
generating them in big endian directly and then using a simple memcpy() ?

> +}
> +
> +static void jpu_generate_hdr(unsigned short quality, unsigned char *p)
> +{
> +	put_qtbl(p + JPU_JPEG_QTBL_LUM_OFFSET, qtbl_lum[quality]);
> +	put_qtbl(p + JPU_JPEG_QTBL_CHR_OFFSET, qtbl_chr[quality]);
> +
> +	put_htbl(p + JPU_JPEG_HDCTBL_LUM_OFFSET, (const u8 *)hdctbl_lum,
> +						JPU_JPEG_HDCTBL_SIZE);
> +	put_htbl(p + JPU_JPEG_HACTBL_LUM_OFFSET, (const u8 *)hactbl_lum,
> +						JPU_JPEG_HACTBL_SIZE);
> +
> +	put_htbl(p + JPU_JPEG_HDCTBL_CHR_OFFSET, (const u8 *)hdctbl_chr,
> +						JPU_JPEG_HDCTBL_SIZE);
> +	put_htbl(p + JPU_JPEG_HACTBL_CHR_OFFSET, (const u8 *)hactbl_chr,
> +						JPU_JPEG_HACTBL_SIZE);
> +}
> +
> +static int get_byte(struct jpeg_buffer *buf)
> +{
> +	if (buf->curr >= buf->size)
> +		return -1;
> +
> +	return ((unsigned char *)buf->data)[buf->curr++];
> +}
> +
> +static int get_word_be(struct jpeg_buffer *buf, unsigned int *word)
> +{
> +	unsigned int temp;
> +	int byte;
> +
> +	byte = get_byte(buf);
> +	if (byte == -1)
> +		return -1;
> +	temp = byte << 8;
> +	byte = get_byte(buf);
> +	if (byte == -1)
> +		return -1;
> +	*word = (unsigned int)byte | temp;
> +	return 0;

How about

	if (buf->size - buf->curr < 2)
		return -1;

	*word = get_unaligned_be16(&buf->data[buf->curr]);
	buf->curr += 2;

	return 0;

> +}
> +
> +static void skip(struct jpeg_buffer *buf, long len)
> +{
> +	if (len <= 0)
> +		return;

Is there a use case for a negative length ? If not I'd make it an unsigned 
int.

> +
> +	while (len--)
> +		get_byte(buf);

You can easily optimize that:

	buf->curr += min(buf->size - buf->curr, len);

> +}
> +
> +static bool jpu_parse_hdr(unsigned long buffer, unsigned long size,
> +			  unsigned int *width, unsigned int *height,
> +			  unsigned int *pixelformat)
> +{
> +	struct jpeg_buffer jpeg_buffer;
> +	int components = 0;
> +	bool found = false;
> +	unsigned int word, subsampling = 0;
> +	long length;
> +
> +	jpeg_buffer.size = size;
> +	jpeg_buffer.data = buffer;
> +	jpeg_buffer.curr = 0;
> +
> +	while (!found) {
> +		int c = get_byte(&jpeg_buffer);
> +
> +		if (c == -1)
> +			return false;
> +		if (c != 0xff)
> +			continue;
> +		do
> +			c = get_byte(&jpeg_buffer);
> +		while (c == 0xff);
> +		if (c == -1)
> +			return false;
> +		if (c == 0)
> +			continue;
> +		length = 0;
> +		switch (c) {
> +		/* SOF0: baseline JPEG */
> +		case SOF0:
> +			if (get_word_be(&jpeg_buffer, &word))
> +				break;
> +			if (get_byte(&jpeg_buffer) == -1)
> +				break;
> +			if (get_word_be(&jpeg_buffer, height))
> +				break;
> +			if (get_word_be(&jpeg_buffer, width))
> +				break;
> +			components = get_byte(&jpeg_buffer);
> +			if (components == -1)
> +				break;
> +			found = true;
> +
> +			if (components == 1) {
> +				subsampling = 0x33;
> +			} else {
> +				skip(&jpeg_buffer, 1);
> +				subsampling = get_byte(&jpeg_buffer);
> +				skip(&jpeg_buffer, 1);
> +			}
> +
> +			skip(&jpeg_buffer, components * 2);
> +			break;
> +
> +		/* skip payload-less markers */
> +		case RST ... RST + 7:
> +		case SOI:
> +		case EOI:
> +		case TEM:
> +			break;
> +
> +		/* skip uninteresting payload markers */
> +		default:
> +			if (get_word_be(&jpeg_buffer, &word))
> +				break;
> +			length = (long)word - 2;
> +			skip(&jpeg_buffer, length);
> +			break;
> +		}
> +	}
> +
> +	/* subsampling -> pixelformat */
> +	switch (subsampling) {
> +	case JPU_JPEG_422: /* 422 */
> +		*pixelformat = V4L2_PIX_FMT_NV16M;
> +		break;
> +	case JPU_JPEG_420:
> +		*pixelformat = V4L2_PIX_FMT_NV12M;
> +		break;
> +	case 0x11: /* 444 */
> +	case 0x33: /* GRAY */
> +	default:
> +		return false;
> +	}
> +
> +	return found;
> +}

[snip]

> +static int __jpu_try_fmt(struct jpu_ctx *ctx,
> +			 struct v4l2_pix_format_mplane *pix,
> +			 enum v4l2_buf_type type, struct jpu_fmt **fmtinfo)
> +{
> +	struct jpu_fmt *fmt;
> +	unsigned int f_type, w, h;
> +
> +	f_type = V4L2_TYPE_IS_OUTPUT(type) ? JPU_FMT_TYPE_OUTPUT :
> +						JPU_FMT_TYPE_CAPTURE;
> +
> +	fmt = jpu_find_format(ctx->encoder, pix->pixelformat, f_type);
> +	if (!fmt) {
> +		unsigned int pixelformat;
> +
> +		pr_debug("unknown format; set default format\n");

dev_dbg() would be more appropriate. Same comment for all the pr_* calls 
below.

> +		if (ctx->encoder)
> +			pixelformat = (f_type == JPU_FMT_TYPE_OUTPUT) ?
> +				V4L2_PIX_FMT_NV16M : V4L2_PIX_FMT_JPEG;
> +		else
> +			pixelformat = (f_type == JPU_FMT_TYPE_CAPTURE) ?
> +				V4L2_PIX_FMT_NV16M : V4L2_PIX_FMT_JPEG;
> +		fmt = jpu_find_format(ctx->encoder, pixelformat, f_type);
> +	}
> +
> +	pix->pixelformat = fmt->fourcc;
> +	pix->colorspace = fmt->colorspace;
> +	pix->field = V4L2_FIELD_NONE;
> +	pix->num_planes = fmt->num_planes;
> +	memset(pix->reserved, 0, sizeof(pix->reserved));
> +
> +	jpu_bound_align_image(&pix->width, JPU_WIDTH_MIN, JPU_WIDTH_MAX,
> +			      fmt->h_align, &pix->height, JPU_HEIGHT_MIN,
> +			      JPU_HEIGHT_MAX, fmt->v_align);
> +
> +	w = pix->width;
> +	h = pix->height;
> +
> +	if (fmt->fourcc == V4L2_PIX_FMT_JPEG) {
> +		if (pix->plane_fmt[0].sizeimage <= 0)
> +			pix->plane_fmt[0].sizeimage = JPU_JPEG_HDR_SIZE +
> +					(JPU_JPEG_MAX_BITS_PER_PIXEL * w * h);
> +		pix->plane_fmt[0].bytesperline = 0;
> +		memset(pix->plane_fmt[0].reserved, 0,
> +		       sizeof(pix->plane_fmt[0].reserved));
> +	} else {
> +		unsigned int i;
> +
> +		for (i = 0; i < pix->num_planes; ++i) {
> +			unsigned int bpl;
> +			unsigned int hsub = i > 0 ? fmt->subsampling >> 4 : 1;
> +			unsigned int vsub = i > 0 ? fmt->subsampling & 0xf : 1;
> +
> +			bpl = clamp_t(unsigned int,
> +				      pix->plane_fmt[i].bytesperline,
> +				      w / hsub * fmt->bpp[i] / 8,
> +				      JPU_WIDTH_MAX);
> +
> +			pix->plane_fmt[i].bytesperline =
> +					round_up(bpl, JPU_MEMALIGN);
> +			pix->plane_fmt[i].sizeimage =
> +				pix->plane_fmt[i].bytesperline * h / vsub;
> +			memset(pix->plane_fmt[i].reserved, 0,
> +			       sizeof(pix->plane_fmt[i].reserved));
> +		}
> +	}
> +
> +	if (fmtinfo)
> +		*fmtinfo = fmt;
> +
> +	return 0;
> +}

[snip]

> +/*
> + * ========================================================================
> + * Queue operations
> + * --======================================================================
> + */
> +static int jpu_queue_setup(struct vb2_queue *vq,
> +			   const struct v4l2_format *fmt,
> +			   unsigned int *nbuffers, unsigned int *nplanes,
> +			   unsigned int sizes[], void *alloc_ctxs[])
> +{
> +	struct jpu_ctx *ctx = vb2_get_drv_priv(vq);
> +	struct jpu_q_data *q_data;
> +	unsigned int count = *nbuffers;
> +	unsigned int i;
> +
> +	q_data = jpu_get_q_data(ctx, vq->type);
> +
> +	*nplanes = q_data->format.num_planes;
> +
> +	/*
> +	 * Header is parsed during decoding and parsed information stored
> +	 * in the context so we do not allow another buffer to overwrite it.
> +	 * For now it works this way, but planned for alternation.

It shouldn't be difficult to create a jpu_buffer structure that inherits from 
vb2_buffer and store the information there instead of in the context.

> +	 */
> +	if (!ctx->encoder)
> +		count = 1;
> +
> +	*nbuffers = count;
> +
> +	for (i = 0; i < *nplanes; i++) {
> +		sizes[i] = q_data->format.plane_fmt[i].sizeimage;
> +		alloc_ctxs[i] = ctx->jpu->alloc_ctx;
> +	}
> +
> +	return 0;
> +}
> +
> +static int jpu_buf_prepare(struct vb2_buffer *vb)
> +{
> +	struct jpu_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
> +	struct jpu_q_data *q_data;
> +	unsigned int i;
> +
> +	q_data = jpu_get_q_data(ctx, vb->vb2_queue->type);
> +
> +	for (i = 0; i < q_data->format.num_planes; i++) {
> +		unsigned long size = q_data->format.plane_fmt[i].sizeimage;
> +
> +		if (vb2_plane_size(vb, i) < size) {
> +			pr_err("%s: data will not fit into plane (%lu < %lu)\n",
> +			       __func__, vb2_plane_size(vb, i), size);
> +			return -EINVAL;
> +		}
> +		vb2_set_plane_payload(vb, i, size);

That's only applicable to the decoded buffers. It probably doesn't hurt 
though, as the payload value will be overwritten later.

> +	}
> +
> +	return 0;
> +}
> +
> +static void jpu_buf_queue(struct vb2_buffer *vb)
> +{
> +	struct jpu_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
> +
> +	if (!ctx->encoder && V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type)) {
> +		struct jpu_q_data *q_data;
> +		void *buffer = vb2_plane_vaddr(vb, 0);
> +		unsigned long buf_size = vb2_get_plane_payload(vb, 0);
> +		unsigned int w, h, pixelformat;
> +
> +		ctx->hdr_parsed = jpu_parse_hdr((unsigned long)buffer,
> +						buf_size, &w, &h, &pixelformat);
> +
> +		if (!ctx->hdr_parsed || w > JPU_WIDTH_MAX ||
> +					w < JPU_WIDTH_MIN ||
> +					h > JPU_HEIGHT_MAX ||
> +					h < JPU_HEIGHT_MIN) {
> +			pr_err("incompatible or corrupted JPEG data\n");
> +			vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
> +			return;
> +		}
> +
> +		q_data = &ctx->out_q;
> +		q_data->format.width = w;
> +		q_data->format.height = h;
> +
> +		q_data = &ctx->cap_q;
> +		q_data->format.width = w;
> +		q_data->format.height = h;
> +
> +		q_data->format.pixelformat = pixelformat;
> +		__jpu_try_fmt(ctx, &q_data->format,
> +			      V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE,
> +			      &q_data->fmtinfo);
> +	}
> +
> +	if (ctx->fh.m2m_ctx)
> +		v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vb);
> +}

[snip]

> +/*
> + * ========================================================================
> + * Device file operations
> + * ========================================================================
> + */
> +static int jpu_open(struct file *file)
> +{
> +	struct jpu *jpu = video_drvdata(file);
> +	struct video_device *vfd = video_devdata(file);
> +	struct jpu_ctx *ctx;
> +	int ret;
> +
> +	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
> +	if (!ctx)
> +		return -ENOMEM;
> +
> +	if (mutex_lock_interruptible(&jpu->mutex)) {
> +		ret = -ERESTARTSYS;
> +		goto free;
> +	}

Does all the code below reallly need to be protected by the mutex ?

> +	v4l2_fh_init(&ctx->fh, vfd);
> +	ctx->fh.ctrl_handler = &ctx->ctrl_handler;
> +	file->private_data = &ctx->fh;
> +	v4l2_fh_add(&ctx->fh);
> +
> +	ctx->jpu = jpu;
> +	ctx->encoder = (vfd == jpu->vfd_encoder);
> +
> +	__jpu_try_fmt(ctx, &ctx->out_q.format,
> +		      V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE, &ctx->out_q.fmtinfo);
> +	__jpu_try_fmt(ctx, &ctx->cap_q.format,
> +		      V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE, &ctx->cap_q.fmtinfo);
> +
> +	ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(jpu->m2m_dev, ctx, jpu_queue_init);
> +	if (IS_ERR(ctx->fh.m2m_ctx)) {
> +		ret = PTR_ERR(ctx->fh.m2m_ctx);
> +		goto error;
> +	}
> +
> +	ret = jpu_controls_create(ctx);
> +	if (ret < 0)
> +		goto error;
> +
> +	if (jpu->ref_count == 0) {
> +		ret = clk_prepare_enable(jpu->clk);
> +		if (ret < 0)
> +			goto error;
> +		/* ...issue software reset */
> +		ret = jpu_reset(jpu);
> +		if (ret)
> +			goto error;
> +	}
> +
> +	jpu->ref_count++;
> +
> +	mutex_unlock(&jpu->mutex);
> +	return 0;
> +
> +error:
> +	v4l2_fh_del(&ctx->fh);
> +	v4l2_fh_exit(&ctx->fh);
> +	mutex_unlock(&jpu->mutex);
> +free:
> +	kfree(ctx);
> +	return ret;
> +}
> +
> +static int jpu_release(struct file *file)
> +{
> +	struct jpu *jpu = video_drvdata(file);
> +	struct jpu_ctx *ctx = fh_to_ctx(file->private_data);
> +
> +	mutex_lock(&jpu->mutex);
> +	if (--jpu->ref_count == 0)
> +		clk_disable_unprepare(jpu->clk);
> +	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
> +	v4l2_ctrl_handler_free(&ctx->ctrl_handler);
> +	v4l2_fh_del(&ctx->fh);
> +	v4l2_fh_exit(&ctx->fh);
> +	kfree(ctx);
> +	mutex_unlock(&jpu->mutex);

Do you need to protect all that with the mutex, or would it be enough to just 
protect the clock disabling code ?

> +
> +	return 0;
> +}
> +
> +static const struct v4l2_file_operations jpu_fops = {
> +	.owner		= THIS_MODULE,
> +	.open		= jpu_open,
> +	.release	= jpu_release,
> +	.unlocked_ioctl	= video_ioctl2,
> +	.poll		= v4l2_m2m_fop_poll,
> +	.mmap		= v4l2_m2m_fop_mmap,
> +};
> +
> +/*
> + * ========================================================================
> + * mem2mem callbacks
> + * ========================================================================
> + */
> +static void jpu_cleanup(struct jpu_ctx *ctx)
> +{
> +	/* remove current buffers and finish job */
> +	struct vb2_buffer *src_buf, *dst_buf;
> +
> +	src_buf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
> +	dst_buf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
> +
> +	v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_ERROR);
> +	v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_ERROR);
> +
> +	v4l2_m2m_job_finish(ctx->jpu->m2m_dev, ctx->fh.m2m_ctx);
> +
> +	/* ...and give it a chance on next run */
> +	iowrite32(JCCMD_SRST, ctx->jpu->regs + JCCMD);

I would create read and write wrappers

static inline u32 jpu_read(struct jpu *jpu, unsigned int reg)
{
	return ioread32(jpu->regs + reg);
}

static inline void jpu_write(struct jpu *jpu, unsigned int reg, u32 val)
{
	iowrite32(val, jpu->regs + reg);
}

I think this would improve readability, and it would also make debugging 
easier if we need to trace register reads and writes.

> +}
> +
> +static void jpu_device_run(void *priv)
> +{
> +	struct jpu_ctx *ctx = priv;
> +	struct jpu *jpu = ctx->jpu;
> +	struct vb2_buffer *src_buf, *dst_buf;
> +	unsigned int bpl;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&ctx->jpu->lock, flags);

That's lots of code running with a spinlock held, especially if we consider 
the 100ms jpu_wait_reset() timeout. I think this should be restructured, most 
of the operations only require mutex protection.

> +	src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
> +	dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
> +
> +	if (ctx->encoder) {
> +		unsigned long src_1_addr, src_2_addr, dst_addr;
> +		unsigned int redu, inft, w, h;
> +		u8 *dst_vaddr;
> +		struct jpu_q_data *q_data = &ctx->out_q;
> +		unsigned char subsampling = q_data->fmtinfo->subsampling;
> +
> +		src_1_addr = vb2_dma_contig_plane_dma_addr(src_buf, 0);
> +		src_2_addr = vb2_dma_contig_plane_dma_addr(src_buf, 1);
> +
> +		dst_addr = vb2_dma_contig_plane_dma_addr(dst_buf, 0);
> +		dst_vaddr = vb2_plane_vaddr(dst_buf, 0);
> +
> +		w = q_data->format.width;
> +		h = q_data->format.height;
> +		bpl = q_data->format.plane_fmt[0].bytesperline;
> +
> +		memcpy(dst_vaddr, jpeg_hdrs[ctx->compr_quality],
> +			JPU_JPEG_HDR_SIZE);
> +		*(u16 *)(dst_vaddr + JPU_JPEG_HEIGHT_OFFSET) = cpu_to_be16(h);
> +		*(u16 *)(dst_vaddr + JPU_JPEG_WIDTH_OFFSET) = cpu_to_be16(w);
> +		*(dst_vaddr + JPU_JPEG_SUBS_OFFSET) = subsampling;

At this point I think the buffer belongs to the device. Have you considered 
possible caching issues ? Would it make sense to write the header when the 
buffer is prepared ?

> +		if (subsampling == JPU_JPEG_420) {
> +			redu = JCMOD_REDU_420;
> +			inft = JIFECNT_INFT_420;
> +		} else {
> +			redu = JCMOD_REDU_422;
> +			inft = JIFECNT_INFT_422;
> +		}
> +
> +		/* ...wait until module reset completes */
> +		if (jpu_wait_reset(jpu)) {
> +			jpu_cleanup(ctx);
> +			goto error;
> +		}
> +
> +		/* the only no marker mode works for encoding */
> +		iowrite32(JCMOD_DSP_ENC | JCMOD_PCTR | redu |
> +			  JCMOD_MSKIP_ENABLE, jpu->regs + JCMOD);
> +
> +		iowrite32(JIFECNT_SWAP_WB | inft, jpu->regs + JIFECNT);
> +		iowrite32(JIFDCNT_SWAP_WB, jpu->regs + JIFDCNT);
> +		iowrite32(JINTE_TRANSF_COMPL, jpu->regs + JINTE);
> +
> +		/* Y and C components source addresses */
> +		iowrite32(src_1_addr, jpu->regs + JIFESYA1);
> +		iowrite32(src_2_addr, jpu->regs + JIFESCA1);
> +
> +		/* memory width */
> +		iowrite32(bpl, jpu->regs + JIFESMW);
> +
> +		iowrite32((w >> 8) & JCSZ_MASK, jpu->regs + JCHSZU);
> +		iowrite32(w & JCSZ_MASK, jpu->regs + JCHSZD);
> +
> +		iowrite32((h >> 8) & JCSZ_MASK, jpu->regs + JCVSZU);
> +		iowrite32(h & JCSZ_MASK, jpu->regs + JCVSZD);
> +
> +		iowrite32(w, jpu->regs + JIFESHSZ);
> +		iowrite32(h, jpu->regs + JIFESVSZ);
> +
> +		iowrite32(dst_addr + JPU_JPEG_HDR_SIZE, jpu->regs + JIFEDA1);
> +
> +		iowrite32(0 << JCQTN_SHIFT(1) | 1 << JCQTN_SHIFT(2) |
> +			  1 << JCQTN_SHIFT(3), jpu->regs + JCQTN);
> +
> +		iowrite32(0 << JCHTN_AC_SHIFT(1) | 0 << JCHTN_DC_SHIFT(1) |
> +			  1 << JCHTN_AC_SHIFT(2) | 1 << JCHTN_DC_SHIFT(2) |
> +			  1 << JCHTN_AC_SHIFT(3) | 1 << JCHTN_DC_SHIFT(3),
> +			  jpu->regs + JCHTN);
> +
> +		jpu_set_qtbl(jpu->regs, ctx->compr_quality);
> +		jpu_set_htbl(jpu->regs);
> +	} else {
> +		unsigned long src_addr, dst_1_addr, dst_2_addr;
> +
> +		bpl = ctx->cap_q.format.plane_fmt[0].bytesperline;
> +
> +		src_addr = vb2_dma_contig_plane_dma_addr(src_buf, 0);
> +		dst_1_addr = vb2_dma_contig_plane_dma_addr(dst_buf, 0);
> +		dst_2_addr = vb2_dma_contig_plane_dma_addr(dst_buf, 1);
> +
> +		/* ...wait until module reset completes */
> +		if (jpu_wait_reset(jpu)) {
> +			jpu_cleanup(ctx);
> +			goto error;
> +		}
> +
> +		/* ...set up decoder operation */
> +		iowrite32(JCMOD_DSP_DEC | JCMOD_PCTR, jpu->regs + JCMOD);
> +		iowrite32(JIFECNT_SWAP_WB, jpu->regs + JIFECNT);
> +		iowrite32(JIFDCNT_SWAP_WB, jpu->regs + JIFDCNT);
> +
> +		/* ...enable interrupts on transfer completion and d-g error */
> +		iowrite32(JINTE_TRANSF_COMPL | JINTE_ERR, jpu->regs + JINTE);
> +
> +		/* ...set source/destination addresses of encoded data */
> +		iowrite32(src_addr, jpu->regs + JIFDSA1);
> +		iowrite32(dst_1_addr, jpu->regs + JIFDDYA1);
> +		iowrite32(dst_2_addr, jpu->regs + JIFDDCA1);
> +
> +		/* iowrite32(w, jpu->regs + JIFDDMW); */
> +		iowrite32(bpl, jpu->regs + JIFDDMW);
> +	}
> +
> +	/* ...start encoder/decoder operation */
> +	iowrite32(JCCMD_JSRT, jpu->regs + JCCMD);
> +
> +error:
> +	spin_unlock_irqrestore(&ctx->jpu->lock, flags);
> +}
> +
> +static int jpu_job_ready(void *priv)
> +{
> +	struct jpu_ctx *ctx = priv;
> +
> +	if (!ctx->encoder)
> +		return ctx->hdr_parsed;
> +
> +	return 1;
> +}
> +
> +static void jpu_job_abort(void *priv)
> +{
> +}
> +
> +static struct v4l2_m2m_ops jpu_m2m_ops = {
> +	.device_run	= jpu_device_run,
> +	.job_ready	= jpu_job_ready,
> +	.job_abort	= jpu_job_abort,
> +};
> +
> +/*
> + * ========================================================================
> + * IRQ handler
> + * ========================================================================
> + */
> +static irqreturn_t jpu_irq_handler(int irq, void *dev_id)
> +{
> +	struct jpu *jpu = dev_id;
> +	struct jpu_ctx *curr_ctx;
> +	struct vb2_buffer *src_buf, *dst_buf;
> +	unsigned long payload_size = 0;
> +	unsigned int int_status, expected_ints;
> +	unsigned int error;
> +
> +	spin_lock(&jpu->lock);

You don't need to lock access to the JINTS register as the IRQ handler isn't 
reentrant. You can move the spin_lock call after clearing JINTS.

> +
> +	int_status = ioread32(jpu->regs + JINTS);
> +	if (!int_status) {
> +		pr_err("spurious interrupt\n");

The JPU IRQ could be shared with other devices, even if it isn't in the chips 
you have currently tested. I would thus remove the error message.

> +		spin_unlock(&jpu->lock);
> +		return IRQ_NONE;
> +	}
> +
> +	jpu_int_clear(jpu->regs, int_status);

I would inline the function here, especially given that it does more than 
clearing the interrupt status register and thus has a bit of a misleading 
name.

> +	/*
> +	 * In any mode (decoding/encoding) we can additionally get
> +	 * error status (5th bit)
> +	 * jpu operation complete status (6th bit)
> +	 */
> +	expected_ints = ioread32(jpu->regs + JINTE) | JINTS_ERR
> +						    | JINTS_PROCESS_COMPL;

Should that be | JINTE_ERR | JINTE_PROCESS_COMPL ?


JINTE is set to either JINTE_TRANSF_COMPL or JINTE_TRANSF_COMPL | JINTE_ERR. I 
thus believe that the expected_ints value will always be the same, you don't 
need to read it from the register.

> +	if (!(expected_ints & int_status)) {
> +		pr_err("spurious interrupt: %#X vs %#X (expected)\n",
> +			int_status, expected_ints);

Same comment here, I wouldn't print a message as the IRQ could be shared.

The two spurious interrupt checks cover the same cases, I would merge them 
into a single check.

> +		spin_unlock(&jpu->lock);
> +		return IRQ_NONE;
> +	}
> +
> +	if ((int_status & JINTS_PROCESS_COMPL) &&
> +	   !(int_status & JINTS_TRANSF_COMPL))
> +		goto handled;
> +
> +	curr_ctx = v4l2_m2m_get_curr_priv(jpu->m2m_dev);
> +	if (!curr_ctx) {
> +		/* ...instance is not running */
> +		pr_err("no active context for m2m\n");
> +		goto handled;
> +	}
> +
> +	src_buf = v4l2_m2m_src_buf_remove(curr_ctx->fh.m2m_ctx);
> +	dst_buf = v4l2_m2m_dst_buf_remove(curr_ctx->fh.m2m_ctx);
> +
> +	if (int_status & JINTS_TRANSF_COMPL) {
> +		if (curr_ctx->encoder) {
> +			payload_size = ioread32(jpu->regs + JCDTCU) << 16 |
> +				       ioread32(jpu->regs + JCDTCM) << 8  |
> +				       ioread32(jpu->regs + JCDTCD);

That's a strange hardware design :-)

> +			vb2_set_plane_payload(dst_buf, 0,
> +				payload_size + JPU_JPEG_HDR_SIZE);
> +		}
> +
> +		dst_buf->v4l2_buf.timecode = src_buf->v4l2_buf.timecode;
> +		dst_buf->v4l2_buf.timestamp = src_buf->v4l2_buf.timestamp;
> +		dst_buf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
> +		dst_buf->v4l2_buf.flags |=
> +		    src_buf->v4l2_buf.flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
> +
> +		v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_DONE);
> +		v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_DONE);
> +
> +	} else if (int_status & JINTS_ERR) {
> +			error = ioread32(jpu->regs + JCDERR);
> +
> +			pr_debug("processing error: %#X\n", error);
> +
> +			v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_ERROR);
> +			v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_ERROR);
> +	}
> +
> +	/* ...reset JPU after completion */
> +	iowrite32(JCCMD_SRST, jpu->regs + JCCMD);
> +	v4l2_m2m_job_finish(jpu->m2m_dev, curr_ctx->fh.m2m_ctx);
> +
> +handled:
> +	spin_unlock(&jpu->lock);
> +	return IRQ_HANDLED;
> +}
> +
> +/*
> + * ========================================================================
> + * Driver basic infrastructure
> + * ========================================================================
> + */
> +static const struct of_device_id jpu_dt_ids[] = {
> +	{ .compatible = "renesas,jpu-r8a7790" }, /* H2 */
> +	{ .compatible = "renesas,jpu-r8a7791" }, /* M2-W */
> +	{ .compatible = "renesas,jpu-r8a7792" }, /* V2H */
> +	{ .compatible = "renesas,jpu-r8a7793" }, /* M2-N */

I'd like to say that "renesas,jpu-rcar-gen2" would be nice but I have pretty 
much given up on that :-)

> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, jpu_dt_ids);
> +
> +static int jpu_probe(struct platform_device *pdev)
> +{
> +	struct jpu *jpu;
> +	struct resource *res;
> +	int ret;
> +	unsigned short i;

You can use unsigned int, the compiler will reserve two bytes after a short 
anyway.

> +
> +	jpu = devm_kzalloc(&pdev->dev, sizeof(struct jpu), GFP_KERNEL);

The kernel coding style favours sizeof(*var) over sizeof(type).

> +	if (!jpu)
> +		return -ENOMEM;
> +
> +	mutex_init(&jpu->mutex);
> +	spin_lock_init(&jpu->lock);
> +	jpu->dev = &pdev->dev;
> +
> +	/* memory-mapped registers */
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	jpu->regs = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(jpu->regs))
> +		return PTR_ERR(jpu->regs);
> +
> +	/* interrupt service routine registration */
> +	jpu->irq = ret = platform_get_irq(pdev, 0);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "cannot find IRQ\n");
> +		return ret;
> +	}
> +
> +	ret = devm_request_irq(&pdev->dev, jpu->irq, jpu_irq_handler, 0,
> +			       dev_name(&pdev->dev), jpu);
> +	if (ret) {
> +		dev_err(&pdev->dev, "cannot claim IRQ %d\n", jpu->irq);
> +		return ret;
> +	}
> +
> +	/* clocks */
> +	jpu->clk = devm_clk_get(&pdev->dev, NULL);
> +	if (IS_ERR(jpu->clk)) {
> +		dev_err(&pdev->dev, "cannot get clock\n");
> +		return PTR_ERR(jpu->clk);
> +	}
> +
> +	/* v4l2 device */
> +	ret = v4l2_device_register(&pdev->dev, &jpu->v4l2_dev);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Failed to register v4l2 device\n");
> +		return ret;
> +	}
> +
> +	/* mem2mem device */
> +	jpu->m2m_dev = v4l2_m2m_init(&jpu_m2m_ops);
> +	if (IS_ERR(jpu->m2m_dev)) {
> +		v4l2_err(&jpu->v4l2_dev, "Failed to init mem2mem device\n");
> +		ret = PTR_ERR(jpu->m2m_dev);
> +		goto device_register_rollback;
> +	}
> +
> +	jpu->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
> +	if (IS_ERR(jpu->alloc_ctx)) {
> +		v4l2_err(&jpu->v4l2_dev, "Failed to init memory allocator\n");
> +		ret = PTR_ERR(jpu->alloc_ctx);
> +		goto m2m_init_rollback;
> +	}
> +
> +	/* JPEG encoder /dev/videoX node */
> +	jpu->vfd_encoder = video_device_alloc();
> +	if (!jpu->vfd_encoder) {
> +		v4l2_err(&jpu->v4l2_dev, "Failed to allocate video device\n");
> +		ret = -ENOMEM;
> +		goto vb2_allocator_rollback;
> +	}
> +	strlcpy(jpu->vfd_encoder->name, JPU_M2M_NAME,
> +		sizeof(jpu->vfd_encoder->name));
> +	jpu->vfd_encoder->fops		= &jpu_fops;
> +	jpu->vfd_encoder->ioctl_ops	= &jpu_ioctl_ops;
> +	jpu->vfd_encoder->minor		= -1;
> +	jpu->vfd_encoder->release	= video_device_release;
> +	jpu->vfd_encoder->lock		= &jpu->mutex;
> +	jpu->vfd_encoder->v4l2_dev	= &jpu->v4l2_dev;
> +	jpu->vfd_encoder->vfl_dir	= VFL_DIR_M2M;
> +
> +	ret = video_register_device(jpu->vfd_encoder, VFL_TYPE_GRABBER, -1);
> +	if (ret) {
> +		v4l2_err(&jpu->v4l2_dev, "Failed to register video device\n");
> +		goto enc_vdev_alloc_rollback;
> +	}
> +
> +	video_set_drvdata(jpu->vfd_encoder, jpu);
> +	v4l2_info(&jpu->v4l2_dev, "encoder device registered as /dev/video%d\n",
> +		  jpu->vfd_encoder->num);
> +
> +	/* JPEG decoder /dev/videoX node */
> +	jpu->vfd_decoder = video_device_alloc();
> +	if (!jpu->vfd_decoder) {
> +		v4l2_err(&jpu->v4l2_dev, "Failed to allocate video device\n");
> +		ret = -ENOMEM;
> +		goto enc_vdev_register_rollback;
> +	}
> +	strlcpy(jpu->vfd_decoder->name, JPU_M2M_NAME,
> +		sizeof(jpu->vfd_decoder->name));
> +	jpu->vfd_decoder->fops		= &jpu_fops;
> +	jpu->vfd_decoder->ioctl_ops	= &jpu_ioctl_ops;
> +	jpu->vfd_decoder->minor		= -1;
> +	jpu->vfd_decoder->release	= video_device_release;
> +	jpu->vfd_decoder->lock		= &jpu->mutex;
> +	jpu->vfd_decoder->v4l2_dev	= &jpu->v4l2_dev;
> +	jpu->vfd_decoder->vfl_dir	= VFL_DIR_M2M;
> +
> +	ret = video_register_device(jpu->vfd_decoder, VFL_TYPE_GRABBER, -1);
> +	if (ret) {
> +		v4l2_err(&jpu->v4l2_dev, "Failed to register video device\n");
> +		goto dec_vdev_alloc_rollback;
> +	}
> +
> +	video_set_drvdata(jpu->vfd_decoder, jpu);
> +	v4l2_info(&jpu->v4l2_dev, "decoder device registered as /dev/video%d\n",
> +			  jpu->vfd_decoder->num);
>> +
> +	/* final statements & power management */
> +	platform_set_drvdata(pdev, jpu);
> +
> +	/* fill in qantization and huffman tables */
> +	for (i = 0; i < JPU_MAX_QUALITY; i++)
> +		jpu_generate_hdr(i, (unsigned char *)jpeg_hdrs[i]);

You should move this before registering the video nodes, as the devices can be 
opened and used as soon as they're registered.

> +	v4l2_info(&jpu->v4l2_dev, "Renesas JPEG codec\n");

I'd merge the three messages into one, as the encoder registration message 
would be a bit confusing if the probe function then fails.

> +	return 0;
> +
> +dec_vdev_alloc_rollback:
> +	video_device_release(jpu->vfd_decoder);
> +
> +enc_vdev_register_rollback:
> +	video_unregister_device(jpu->vfd_encoder);
> +
> +enc_vdev_alloc_rollback:
> +	video_device_release(jpu->vfd_encoder);
> +
> +vb2_allocator_rollback:
> +	vb2_dma_contig_cleanup_ctx(jpu->alloc_ctx);
> +
> +m2m_init_rollback:
> +	v4l2_m2m_release(jpu->m2m_dev);
> +
> +device_register_rollback:
> +	v4l2_device_unregister(&jpu->v4l2_dev);
> +
> +	return ret;
> +}

[snip]

> +#ifdef CONFIG_PM_SLEEP
> +static int jpu_suspend(struct device *dev)
> +{
> +	struct jpu *jpu = dev_get_drvdata(dev);
> +
> +	if (jpu->ref_count == 0)
> +		return 0;
> +
> +	clk_disable_unprepare(jpu->clk);

Have you tested system suspend and resume ? I've recently received a patch for 
the VSP1 driver that stops and restarts the device in the suspend and resume 
operations, as just disabling and enabling the clock wasn't enough. I'm 
wondering whether the same would apply to the JPU.

> +
> +	return 0;
> +}
> +
> +static int jpu_resume(struct device *dev)
> +{
> +	struct jpu *jpu = dev_get_drvdata(dev);
> +
> +	if (jpu->ref_count == 0)
> +		return 0;
> +
> +	clk_prepare_enable(jpu->clk);
> +
> +	return 0;
> +}
> +#endif

[snip]

-- 
Regards,

Laurent Pinchart

