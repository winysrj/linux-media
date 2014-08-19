Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3459 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbaHSNiR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Aug 2014 09:38:17 -0400
Message-ID: <53F3531C.4080105@xs4all.nl>
Date: Tue, 19 Aug 2014 13:37:32 +0000
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	m.chehab@samsung.com, horms@verge.net.au, magnus.damm@gmail.com,
	robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com
CC: laurent.pinchart@ideasonboard.com, linux-sh@vger.kernel.org,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 1/6] V4L2: Add Renesas R-Car JPEG codec driver.
References: <1408452653-14067-1-git-send-email-mikhail.ulyanov@cogentembedded.com> <1408452653-14067-2-git-send-email-mikhail.ulyanov@cogentembedded.com>
In-Reply-To: <1408452653-14067-2-git-send-email-mikhail.ulyanov@cogentembedded.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mikhail,

I did a quick scan over the source code and I noticed a few things that aren't
right. The easiest for you is probably to run the v4l2-compliance tool over
your driver and it should tell you what needs to be fixed. The things I
noticed are: querycap doesn't fill in bus_info (should be 'platform:<foo>')
and device_caps, the vid_cap try_fmt fails on a wrong field setting, instead
it should just set it.

I also have some doubts about g_selection, but I need to look at that again
when I have more time next week. It does look like it is not properly
separating the capture and output streams. I would expect g_selection to
return different things for capture and output. Note that v4l2-compliance
doesn't yet check the selection API, so it won't help you there.

Regards,

	Hans

On 08/19/2014 12:50 PM, Mikhail Ulyanov wrote:
> Signed-off-by: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
> ---
>  drivers/media/platform/Kconfig  |   11 +
>  drivers/media/platform/Makefile |    2 +
>  drivers/media/platform/jpu.c    | 1630 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 1646 insertions(+)
>  create mode 100644 drivers/media/platform/jpu.c
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 6d86646..1b8c846 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -220,6 +220,17 @@ config VIDEO_RENESAS_VSP1
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called vsp1.
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
>  config VIDEO_TI_VPE
>  	tristate "TI VPE (Video Processing Engine) driver"
>  	depends on VIDEO_DEV && VIDEO_V4L2 && SOC_DRA7XX
> diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
> index e5269da..e438534 100644
> --- a/drivers/media/platform/Makefile
> +++ b/drivers/media/platform/Makefile
> @@ -47,6 +47,8 @@ obj-$(CONFIG_SOC_CAMERA)		+= soc_camera/
>  
>  obj-$(CONFIG_VIDEO_RENESAS_VSP1)	+= vsp1/
>  
> +obj-$(CONFIG_VIDEO_RENESAS_JPU)	+= jpu.o
> +
>  obj-y	+= davinci/
>  
>  obj-$(CONFIG_ARCH_OMAP)	+= omap/
> diff --git a/drivers/media/platform/jpu.c b/drivers/media/platform/jpu.c
> new file mode 100644
> index 0000000..8630baf
> --- /dev/null
> +++ b/drivers/media/platform/jpu.c
> @@ -0,0 +1,1630 @@
> +/*
> + * Author: Mikhail Ulyanov  <source@cogentembedded.com>
> + * Copyright (C) 2014 Cogent Embedded, Inc.
> + * Copyright (C) 2014 Renesas Electronics Corporation
> + *
> + * This is based on the drivers/media/platform/s5p-jpu driver by
> + * Andrzej Pietrasiewicz and Jacek Anaszewski.
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
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/spinlock.h>
> +#include <linux/string.h>
> +#include <linux/videodev2.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-fh.h>
> +#include <media/v4l2-mem2mem.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/videobuf2-core.h>
> +#include <media/videobuf2-dma-contig.h>
> +
> +
> +#define JPU_M2M_NAME "jpu"
> +
> +#define JPU_WIDTH_MIN	16
> +#define JPU_HEIGHT_MIN	16
> +#define JPU_WIDTH_MAX	4096
> +#define JPU_HEIGHT_MAX	4096
> +
> +#define JPU_ENCODE		0
> +#define JPU_DECODE		1
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
> +#define JCMOD_SOI_DISABLE	(1 << 8)
> +#define JCMOD_SOI_ENABLE	(0 << 8)
> +#define JCMOD_PCTR		(1 << 7)
> +#define JCMOD_MSKIP_DISABLE	(0 << 5)
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
> +#define JCCMD_BRST	(1 << 7)
> +#define JCCMD_JEND	(1 << 2)
> +#define JCCMD_JSRT	(1 << 0)
> +
> +/* JPEG code quantanization table number register */
> +#define JCQTN	0x0C
> +#define JCQTN_SHIFT(t)		(((t) - 1) << 1)
> +
> +/* JPEG code Huffman table number register */
> +#define JCHTN	0x10
> +#define JCHTN_AC_SHIFT(t)	(((t) << 1) - 1)
> +#define JCHTN_DC_SHIFT(t)	(((t) - 1) << 1)
> +
> +#define JCDRIU	0x14 /* JPEG code DRI upper register */
> +#define JCDRIL	0x18 /* JPEG code DRI lower register */
> +#define JCVSZU	0x1C /* JPEG code vertical size upper register */
> +#define JCVSZD	0x20 /* JPEG code vertical size lower register */
> +#define JCHSZU	0x24 /* JPEG code horizontal size upper register */
> +#define JCHSZD	0x28 /* JPEG code horizontal size lower register */
> +#define JCSZ_MASK 0xff /* JPEG code h/v size register contains only 1 byte*/
> +
> +#define JCDTCU	0x2C /* JPEG code data count upper register */
> +#define JCDTCM	0x30 /* JPEG code data count middle register */
> +#define JCDTCD	0x34 /* JPEG code data count lower register */
> +
> +/* JPEG interrupt enable register */
> +#define JINTE	0x38
> +
> +/* JPEG interrupt status register */
> +#define JINTS	0x3C
> +#define JINTS_MASK	0x7c68
> +
> +#define INT(n)	(1 << n)
> +
> +#define JCDERR	0x40 /* JPEG code decode error register */
> +
> +/* JPEG interface encoding */
> +#define JIFECNT	0x70
> +#define JIFECNT_INFT_422	0
> +#define JIFECNT_INFT_420	1
> +#define JIFECNT_SWAP_WB		(0x3 << 4)
> +
> +/* JPEG interface encode source Y address register 1 */
> +#define JIFESYA1	0x74
> +/* JPEG interface encode source C address register 1 */
> +#define JIFESCA1	0x78
> +/* JPEG interface encode source Y address register 2 */
> +#define JIFESYA2	0x7C
> +/* JPEG interface encode source C address register 2 */
> +#define JIFESCA2	0x80
> +/* JPEG interface encode source memory width register */
> +#define JIFESMW		0x84
> +/* JPEG interface encode source vertical size register */
> +#define JIFESVSZ	0x88
> +/* JPEG interface encode source horizontal size register */
> +#define JIFESHSZ	0x8C
> +/* JPEG interface encode destination address register 1 */
> +#define JIFEDA1		0x90
> +/* JPEG interface encode destination address register 2 */
> +#define JIFEDA2		0x94
> +
> +/* JPEG decoding control register */
> +#define JIFDCNT	0xA0
> +#define JIFDCNT_SWAP	(3 << 1)
> +#define JIFDCNT_SWAP_NO		(0 << 1)
> +#define JIFDCNT_SWAP_BYTE	(1 << 1)
> +#define JIFDCNT_SWAP_WORD	(2 << 1)
> +#define JIFDCNT_SWAP_WB		(3 << 1)
> +
> +/* JPEG decode source address register 1 */
> +#define JIFDSA1		0xA4
> +/* JPEG decode source address register 2 */
> +#define JIFDSA2		0xA8
> +/* JPEG decode data reload size register */
> +#define JIFDDRSZ	0xAC
> +/* JPEG decode data destination  memory width register */
> +#define JIFDDMW		0xB0
> +/* JPEG decode data destination  vertical size register */
> +#define JIFDDVSZ	0xB4
> +/* JPEG decode data destination  horizontal size register */
> +#define JIFDDHSZ	0xB8
> +/* JPEG decode data destination  Y address register 1 */
> +#define JIFDDYA1	0xBC
> +/* JPEG decode data destination  C address register 1 */
> +#define JIFDDCA1	0xC0
> +/* JPEG decode data destination  Y address register 2 */
> +#define JIFDDYA2	0xC4
> +/* JPEG decode data destination  C address register 2 */
> +#define JIFDDCA2	0xC8
> +
> +/* JPEG code quantization tables registers */
> +#define JCQTBL(n)	(0x10000 + (n) * 0x40)
> +
> +/* JPEG code Huffman table DC registers */
> +#define JCHTBD(n)	(0x10100 + (n) * 0x100)
> +
> +/* JPEG code Huffman table AC registers */
> +#define JCHTBA(n)	(0x10120 + (n) * 0x100)
> +
> +#define JPU_JPEG_HDR_SIZE		0x250
> +
> +enum jpu_status {
> +	JPU_OK,
> +	JPU_BUSY,
> +	JPU_ERR
> +};
> +
> +/**
> + * struct jpu - JPEG IP abstraction
> + * @mutex: the mutex protecting this structure
> + * @slock: spinlock protecting the device contexts
> + * @v4l2_dev: v4l2 device for mem2mem mode
> + * @vfd_encoder: video device node for encoder mem2mem mode
> + * @vfd_decoder: video device node for decoder mem2mem mode
> + * @m2m_dev: v4l2 mem2mem device data
> + * @regs: JPEG IP registers mapping
> + * @irq: JPEG IP irq
> + * @clk: JPEG IP clock
> + * @dev: JPEG IP struct device
> + * @alloc_ctx: videobuf2 memory allocator's context
> + * @bounds: platform specific IP limitations
> + * @wq: waitqueue for header parsing handling
> + * @statatus: current driver state variable
> + * @ref_counter: reference counter
> + */
> +struct jpu {
> +	struct mutex	mutex;
> +	spinlock_t	slock;
> +
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
> +	struct jpu_bounds	*bounds;
> +	wait_queue_head_t	wq;
> +	enum jpu_status		status;
> +	int			ref_count;
> +};
> +
> +/**
> + * struct jpu_fmt - driver's internal format data
> + * @name: format descritpion
> + * @fourcc: the fourcc code, 0 if not applicable
> + * @depth: number of bits per pixel
> + * @h_align: horizontal alignment order (align to 2^h_align)
> + * @v_align: vertical alignment order (align to 2^v_align)
> + * @types: types of queue this format is applicable to
> + */
> +struct jpu_fmt {
> +	char *name;
> +	u32 fourcc;
> +	int depth;
> +	int h_align;
> +	int v_align;
> +	u32 types;
> +};
> +
> +/**
> + * jpu_q_data - parameters of one queue
> + * @fmt: driver-specific format of this queue
> + * @w: image width
> + * @h: image height
> + * @size: image buffer size in bytes
> + */
> +struct jpu_q_data {
> +	struct jpu_fmt *fmt;
> +	u32 w;
> +	u32 h;
> +	u32 size;
> +};
> +
> +/**
> + * jpu_ctx - the device context data
> + * @jpu: JPEG IP device for this context
> + * @mode: compression (encode) operation or decompression (decode)
> + * @compr_quality: destination image quality in compression (encode) mode
> + * @out_q: source (output) queue information
> + * @fh: file handler;
> + * @hdr_parsed: set if header has been parsed during decompression
> + * @ctrl_handler: controls handler
> + */
> +struct jpu_ctx {
> +	struct jpu		*jpu;
> +	unsigned int		mode;
> +	unsigned short		compr_quality;
> +	struct jpu_q_data	out_q;
> +	struct jpu_q_data	cap_q;
> +	struct v4l2_fh		fh;
> +	bool			hdr_parsed;
> +	struct v4l2_ctrl_handler ctrl_handler;
> +};
> +
> +static struct jpu_fmt jpu_formats[] = {
> +	{
> +		.name		= "JPEG JFIF",
> +		.fourcc		= V4L2_PIX_FMT_JPEG,
> +		.types		= JPU_ENC_CAPTURE | JPU_DEC_OUTPUT,
> +	},
> +	{
> +		.name		= "YUV 4:2:2 semiplanar, YCbCr",
> +		.fourcc		= V4L2_PIX_FMT_NV16,
> +		.depth		= 16,
> +		.h_align	= 3,
> +		.v_align	= 3,
> +		.types		= JPU_ENC_OUTPUT,
> +	},
> +	{
> +		.name		= "YUV 4:2:0 semiplanar, YCbCr",
> +		.fourcc		= V4L2_PIX_FMT_NV12,
> +		.depth		= 12,
> +		.h_align	= 3,
> +		.v_align	= 3,
> +		.types		= JPU_ENC_OUTPUT,
> +	},
> +	{
> +		.name		= "YUV 4:2:2 semiplanar, YCbCr",
> +		.fourcc		= V4L2_PIX_FMT_NV16,
> +		.depth		= 16,
> +		.h_align	= 2,
> +		.v_align	= 2,
> +		.types		= JPU_DEC_CAPTURE,
> +	},
> +	{
> +		.name		= "YUV 4:2:0 semiplanar, YCbCr",
> +		.fourcc		= V4L2_PIX_FMT_NV12,
> +		.depth		= 12,
> +		.h_align	= 2,
> +		.v_align	= 2,
> +		.types		= JPU_DEC_CAPTURE,
> +	},
> +};
> +
> +static const u8 zigzag[] = {
> +	0x03, 0x02, 0x0b, 0x13, 0x0a, 0x01, 0x00, 0x09,
> +	0x12, 0x1b, 0x23, 0x1a, 0x11, 0x08, 0x07, 0x06,
> +	0x0f, 0x10, 0x19, 0x22, 0x2b, 0x33, 0x2a, 0x21,
> +	0x18, 0x17, 0x0e, 0x05, 0x04, 0x0d, 0x16, 0x1f,
> +	0x20, 0x29, 0x32, 0x3b, 0x3a, 0x31, 0x28, 0x27,
> +	0x1e, 0x15, 0x0e, 0x14, 0x10, 0x26, 0x2f, 0x30,
> +	0x39, 0x38, 0x37, 0x2e, 0x25, 0x1c, 0x24, 0x2b,
> +	0x36, 0x3f, 0x3e, 0x35, 0x2c, 0x34, 0x3d, 0x3c
> +};
> +
> +static unsigned char hdr_blob0[] = {
> +	0xff, 0xd8, 0xff, 0xfe, 0x00, 0x0e, 0x00, 0x00,
> +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +	0x00, 0x00, 0x00, 0xff, 0xdb, 0x00, 0x84
> +};
> +
> +static unsigned char hdr_blob1[] = {
> +	0xff, 0xc0, 0x00, 0x11, 0x08
> +};
> +
> +static unsigned char hdr_blob2[] = {
> +	0x00, 0x02, 0x11, 0x01, 0x03, 0x11, 0x01, 0xff,
> +	0xc4, 0x01, 0xa2
> +};
> +
> +static const unsigned int qtbl_lum[2][16] = {
> +	{
> +		0x14401927, 0x322e3e44, 0x10121726, 0x26354144,
> +		0x19171f26, 0x35414444, 0x27262635, 0x41444444,
> +		0x32263541, 0x44444444, 0x2e354144, 0x44444444,
> +		0x3e414444, 0x44444444, 0x44444444, 0x44444444
> +	},
> +	{
> +		0x08060608, 0x0c0e1011, 0x06060608, 0x0a0d0c0f,
> +		0x06060708, 0x0d0e1218, 0x0808080e, 0x0d131823,
> +		0x0c0a0d0d, 0x141a2227, 0x0e0d0e13, 0x1a222727,
> +		0x100c1318, 0x22272727, 0x110f1823, 0x27272727
> +	}
> +};
> +
> +static const unsigned int qtbl_chr[2][16] = {
> +	{
> +		0x15192026, 0x36444444, 0x191c1826, 0x36444444,
> +		0x2018202b, 0x42444444, 0x26262b35, 0x44444444,
> +		0x36424444, 0x44444444, 0x44444444, 0x44444444,
> +		0x44444444, 0x44444444, 0x44444444, 0x44444444
> +	},
> +	{
> +		0x0908090b, 0x0e111318, 0x080a090b, 0x0e0d1116,
> +		0x09090d0e, 0x0d0f171a, 0x0b0b0e0e, 0x0f141a21,
> +		0x0e0e0d0f, 0x14182127, 0x110d0f14, 0x18202727,
> +		0x1311171a, 0x21272727, 0x18161a21, 0x27272727
> +	}
> +};
> +
> +static const unsigned int hdctbl_lum[7] = {
> +	0x00010501, 0x01010101, 0x01000000, 0x00000000,
> +	0x00010203, 0x04050607, 0x08090a0b
> +};
> +
> +static const unsigned int hdctbl_chr[7] = {
> +	0x00030101, 0x01010101, 0x01010100, 0x00000000,
> +	0x00010203, 0x04050607, 0x08090a0b
> +};
> +
> +static const unsigned int hactbl_lum[45] = {
> +	0x00020103, 0x03020403, 0x05050404, 0x0000017d,
> +	0x01020300, 0x04110512, 0x21314106, 0x13516107,
> +	0x22711432, 0x8191a108, 0x2342b1c1, 0x1552d1f0,
> +	0x24336272, 0x82090a16, 0x1718191a, 0x25262728,
> +	0x292a3435, 0x36373839, 0x3a434445, 0x46474849,
> +	0x4a535455, 0x56575859, 0x5a636465, 0x66676869,
> +	0x6a737475, 0x76777879, 0x7a838485, 0x86878889,
> +	0x8a929394, 0x95969798, 0x999aa2a3, 0xa4a5a6a7,
> +	0xa8a9aab2, 0xb3b4b5b6, 0xb7b8b9ba, 0xc2c3c4c5,
> +	0xc6c7c8c9, 0xcad2d3d4, 0xd5d6d7d8, 0xd9dae1e2,
> +	0xe3e4e5e6, 0xe7e8e9ea, 0xf1f2f3f4, 0xf5f6f7f8,
> +	0xf9fa0000
> +};
> +
> +static const unsigned int hactbl_chr[45] = {
> +	0x00020102, 0x04040304, 0x07050404, 0x00010277,
> +	0x00010203, 0x11040521, 0x31061241, 0x51076171,
> +	0x13223281, 0x08144291, 0xa1b1c109, 0x233352f0,
> +	0x156372d1, 0x0a162434, 0xe125f117, 0x18191a26,
> +	0x2728292a, 0x35363738, 0x393a4344, 0x45464748,
> +	0x494a5354, 0x55565758, 0x595a6364, 0x65666768,
> +	0x696a7374, 0x75767778, 0x797a8283, 0x84858687,
> +	0x88898a92, 0x93949596, 0x9798999a, 0xa2a3a4a5,
> +	0xa6a7a8a9, 0xaab2b3b4, 0xb5b6b7b8, 0xb9bac2c3,
> +	0xc4c5c6c7, 0xc8c9cad2, 0xd3d4d5d6, 0xd7d8d9da,
> +	0xe2e3e4e5, 0xe6e7e8e9, 0xeaf2f3f4, 0xf5f6f7f8,
> +	0xf9fa0000
> +};
> +
> +static struct jpu_ctx *ctrl_to_ctx(struct v4l2_ctrl *c)
> +{
> +	return container_of(c->handler, struct jpu_ctx, ctrl_handler);
> +}
> +
> +static struct jpu_ctx *fh_to_ctx(struct v4l2_fh *fh)
> +{
> +	return container_of(fh, struct jpu_ctx, fh);
> +}
> +
> +static void jpu_set_tbl(void __iomem *regs, const unsigned int *tbl,
> +			int len) {
> +	unsigned int i;
> +
> +	for (i = 0; i < len; i++)
> +		iowrite32(tbl[i], regs + (i << 2));
> +}
> +
> +static void jpu_set_qtbl(void __iomem *regs, int quality)
> +{
> +	jpu_set_tbl(regs + JCQTBL(0), qtbl_lum[quality],
> +		    ARRAY_SIZE(qtbl_lum[quality]));
> +	jpu_set_tbl(regs + JCQTBL(1), qtbl_chr[quality],
> +		    ARRAY_SIZE(qtbl_chr[quality]));
> +}
> +
> +static void jpu_set_htbl(void __iomem *regs)
> +{
> +	jpu_set_tbl(regs + JCHTBD(0), hdctbl_lum, ARRAY_SIZE(hdctbl_lum));
> +	jpu_set_tbl(regs + JCHTBD(1), hdctbl_chr, ARRAY_SIZE(hdctbl_chr));
> +	jpu_set_tbl(regs + JCHTBA(0), hactbl_lum, ARRAY_SIZE(hactbl_lum));
> +	jpu_set_tbl(regs + JCHTBA(1), hactbl_chr, ARRAY_SIZE(hactbl_chr));
> +}
> +
> +static void jpu_int_clear(void __iomem *regs, unsigned int int_status)
> +{
> +	iowrite32(~int_status & JINTS_MASK, regs + JINTS);
> +
> +	if (int_status & (INT(6) | INT(5) | INT(3)))
> +		iowrite32(JCCMD_JEND, regs + JCCMD);
> +}
> +
> +static void jpu_reset(void __iomem *regs)
> +{
> +	iowrite32(JCCMD_SRST, regs + JCCMD);
> +	while ((ioread32(regs + JCCMD) & JCCMD_SRST) != 0)
> +		cpu_relax();
> +}
> +
> +/*
> + * ============================================================================
> + * video ioctl operations
> + * ============================================================================
> + */
> +static void put_byte(unsigned long *p, u8 v)
> +{
> +	u8 *addr = (u8 *)*p;
> +
> +	*addr = v;
> +	(*p)++;
> +}
> +
> +static void put_short_be(unsigned long *p, u16 v)
> +{
> +	u16 *addr = (u16 *)*p;
> +
> +	*addr = cpu_to_be16(v);
> +	*p += 2;
> +}
> +
> +static void put_word_be(unsigned long *p, u32 v)
> +{
> +	u32 *addr = (u32 *)*p;
> +
> +	*addr = cpu_to_be32(v);
> +	*p += 4;
> +}
> +
> +static void put_blob_byte(unsigned long *p, const unsigned char *blob,
> +			  unsigned int len)
> +{
> +	int i;
> +
> +	for (i = 0; i < len; i++)
> +		put_byte(p, blob[i]);
> +}
> +
> +static void put_qtbl(unsigned long *p, unsigned char id,
> +		     const unsigned int *qtbl)
> +{
> +	int i;
> +
> +	put_byte(p, id);
> +	for (i = 0; i < ARRAY_SIZE(zigzag); i++)
> +		put_byte(p, *((u8 *)qtbl + zigzag[i]));
> +}
> +
> +static void put_htbl(unsigned long *p, unsigned char tc,
> +		     const unsigned int *htbl, unsigned int len)
> +{
> +	int i;
> +
> +	put_byte(p, tc);
> +	for (i = 0; i < len; i++)
> +		put_word_be(p, htbl[i]);
> +}
> +
> +static void jpu_generate_hdr(struct jpu_q_data *q, int quality, void *buffer)
> +{
> +	/* SOI(2) - DQT(134 / 2 tables) - SOF0(19) - DHT(420 / 2 tables) */
> +	unsigned long p = (unsigned long)buffer;
> +
> +	put_blob_byte(&p, hdr_blob0, ARRAY_SIZE(hdr_blob0));
> +
> +	put_qtbl(&p, 0x00, qtbl_lum[quality]);
> +	put_qtbl(&p, 0x01, qtbl_chr[quality]);
> +
> +	put_blob_byte(&p, hdr_blob1, ARRAY_SIZE(hdr_blob1));
> +
> +	put_short_be(&p, q->h);
> +	put_short_be(&p, q->w);
> +
> +	put_byte(&p, 0x03);
> +	put_byte(&p, 0x01);
> +
> +	if (q->fmt->fourcc ==  V4L2_PIX_FMT_NV16)
> +		put_byte(&p, 0x21);
> +	else
> +		put_byte(&p, 0x22);
> +
> +	put_blob_byte(&p, hdr_blob2, ARRAY_SIZE(hdr_blob2));
> +
> +	put_htbl(&p, 0x00, hdctbl_lum, ARRAY_SIZE(hdctbl_lum));
> +	put_htbl(&p, 0x10, hactbl_lum, ARRAY_SIZE(hactbl_lum));
> +	p -= 2;
> +
> +	put_htbl(&p, 0x01, hdctbl_chr, ARRAY_SIZE(hdctbl_chr));
> +	put_htbl(&p, 0x11, hactbl_chr, ARRAY_SIZE(hactbl_chr));
> +}
> +
> +static int jpu_querycap(struct file *file, void *priv,
> +			struct v4l2_capability *cap)
> +{
> +	struct jpu_ctx *ctx = fh_to_ctx(priv);
> +
> +	if (ctx->mode == JPU_ENCODE) {
> +		strlcpy(cap->driver, JPU_M2M_NAME " encoder",
> +			sizeof(cap->driver));
> +		strlcpy(cap->card, JPU_M2M_NAME " encoder",
> +			sizeof(cap->card));
> +	} else {
> +		strlcpy(cap->driver, JPU_M2M_NAME " decoder",
> +			sizeof(cap->driver));
> +		strlcpy(cap->card, JPU_M2M_NAME " decoder",
> +			sizeof(cap->card));
> +	}
> +	cap->bus_info[0] = 0;
> +	cap->capabilities = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M |
> +			    V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT;
> +	return 0;
> +}
> +
> +static struct jpu_fmt *jpu_find_format(unsigned int mode, u32 pixelformat,
> +				       unsigned int fmt_type)
> +{
> +	unsigned int k, fmt_flag;
> +
> +	if (mode == JPU_ENCODE)
> +		fmt_flag = (fmt_type == JPU_FMT_TYPE_OUTPUT) ? JPU_ENC_OUTPUT :
> +							       JPU_ENC_CAPTURE;
> +	else
> +		fmt_flag = (fmt_type == JPU_FMT_TYPE_OUTPUT) ? JPU_DEC_OUTPUT :
> +							       JPU_DEC_CAPTURE;
> +
> +	for (k = 0; k < ARRAY_SIZE(jpu_formats); k++) {
> +		struct jpu_fmt *fmt = &jpu_formats[k];
> +
> +		if (fmt->fourcc == pixelformat &&
> +			fmt->types & fmt_flag) {
> +			return fmt;
> +		}
> +	}
> +
> +	return NULL;
> +}
> +
> +static int jpu_enum_fmt(struct v4l2_fmtdesc *f, u32 type)
> +{
> +	int i, num = 0;
> +
> +	for (i = 0; i < ARRAY_SIZE(jpu_formats); ++i) {
> +		if (jpu_formats[i].types & type) {
> +			/* index-th format of type type found ? */
> +			if (num == f->index)
> +				break;
> +			/*
> +			 * Correct type but haven't reached our index yet,
> +			 * just increment per-type index
> +			 */
> +			++num;
> +		}
> +	}
> +
> +	/* Format not found */
> +	if (i >= ARRAY_SIZE(jpu_formats))
> +		return -EINVAL;
> +
> +	strlcpy(f->description, jpu_formats[i].name, sizeof(f->description));
> +	f->pixelformat = jpu_formats[i].fourcc;
> +
> +	return 0;
> +}
> +
> +static int jpu_enum_fmt_vid_cap(struct file *file, void *priv,
> +				struct v4l2_fmtdesc *f)
> +{
> +	struct jpu_ctx *ctx = fh_to_ctx(priv);
> +
> +	if (ctx->mode == JPU_ENCODE)
> +		return jpu_enum_fmt(f, JPU_ENC_CAPTURE);
> +
> +	return jpu_enum_fmt(f, JPU_DEC_CAPTURE);
> +}
> +
> +static int jpu_enum_fmt_vid_out(struct file *file, void *priv,
> +				struct v4l2_fmtdesc *f)
> +{
> +	struct jpu_ctx *ctx = fh_to_ctx(priv);
> +
> +	if (ctx->mode == JPU_ENCODE)
> +		return jpu_enum_fmt(f, JPU_ENC_OUTPUT);
> +
> +	return jpu_enum_fmt(f, JPU_DEC_OUTPUT);
> +}
> +
> +static struct jpu_q_data *jpu_get_q_data(struct jpu_ctx *ctx,
> +					 enum v4l2_buf_type type)
> +{
> +	switch (type) {
> +	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> +		return &ctx->out_q;
> +	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
> +		return &ctx->cap_q;
> +	default:
> +		BUG();
> +	}
> +}
> +
> +static int jpu_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
> +{
> +	struct vb2_queue *vq;
> +	struct jpu_q_data *q_data;
> +	struct v4l2_pix_format *pix = &f->fmt.pix;
> +	struct jpu_ctx *ctx = fh_to_ctx(priv);
> +
> +	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
> +	if (!vq)
> +		return -EINVAL;
> +
> +	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE &&
> +		ctx->mode == JPU_DECODE && !ctx->hdr_parsed)
> +		return -EINVAL;
> +
> +	q_data = jpu_get_q_data(ctx, f->type);
> +
> +	pix->width = q_data->w;
> +	pix->height = q_data->h;
> +	pix->field = V4L2_FIELD_NONE;
> +	pix->pixelformat = q_data->fmt->fourcc;
> +	pix->bytesperline = 0;
> +	if (pix->pixelformat != V4L2_PIX_FMT_JPEG)
> +		pix->bytesperline = q_data->w;
> +	pix->sizeimage = q_data->size;
> +
> +	return 0;
> +}
> +
> +
> +static void jpu_bound_align_image(u32 *w, unsigned int wmin, unsigned int wmax,
> +				  unsigned int walign, u32 *h,
> +				  unsigned int hmin, unsigned int hmax,
> +				  unsigned int halign)
> +{
> +	int width, height, w_step, h_step;
> +
> +	width = *w;
> +	height = *h;
> +
> +	w_step = 1 << walign;
> +	h_step = 1 << halign;
> +	v4l_bound_align_image(w, wmin, wmax, walign, h, hmin, hmax, halign, 3);
> +
> +	if (*w < width && *w + w_step < wmax)
> +		*w += w_step;
> +	if (*h < height && *h + h_step < hmax)
> +		*h += h_step;
> +}
> +
> +static int jpu_vidioc_try_fmt(struct v4l2_format *f, struct jpu_fmt *fmt,
> +			      struct jpu_ctx *ctx)
> +{
> +	struct v4l2_pix_format *pix = &f->fmt.pix;
> +
> +	if (pix->field == V4L2_FIELD_ANY)
> +		pix->field = V4L2_FIELD_NONE;
> +	else if (pix->field != V4L2_FIELD_NONE)
> +		return -EINVAL;
> +
> +	/*
> +	 * V4L2 specification suggests the driver corrects the format struct
> +	 * if any of the dimensions is unsupported
> +	 */
> +	jpu_bound_align_image(&pix->width, JPU_WIDTH_MIN, JPU_WIDTH_MAX,
> +			      fmt->h_align, &pix->height, JPU_HEIGHT_MIN,
> +			      JPU_HEIGHT_MAX, fmt->v_align);
> +
> +	if (fmt->fourcc == V4L2_PIX_FMT_JPEG) {
> +		if (pix->sizeimage <= 0)
> +			pix->sizeimage = PAGE_SIZE;
> +		pix->bytesperline = 0;
> +	} else {
> +		u32 bpl = pix->bytesperline;
> +
> +		if (bpl < pix->width)
> +			bpl = pix->width;
> +
> +		pix->bytesperline = bpl;
> +		pix->sizeimage = (pix->width * pix->height * fmt->depth) >> 3;
> +	}
> +
> +	return 0;
> +}
> +
> +static int jpu_try_fmt_vid_cap(struct file *file, void *priv,
> +			       struct v4l2_format *f)
> +{
> +	struct jpu_ctx *ctx = fh_to_ctx(priv);
> +	struct jpu_fmt *fmt;
> +
> +	fmt = jpu_find_format(ctx->mode, f->fmt.pix.pixelformat,
> +			      JPU_FMT_TYPE_CAPTURE);
> +	if (!fmt) {
> +		v4l2_err(&ctx->jpu->v4l2_dev,
> +			 "Fourcc format (0x%08x) invalid.\n",
> +			 f->fmt.pix.pixelformat);
> +		return -EINVAL;
> +	}
> +
> +	return jpu_vidioc_try_fmt(f, fmt, ctx);
> +}
> +
> +static int jpu_try_fmt_vid_out(struct file *file, void *priv,
> +			       struct v4l2_format *f)
> +{
> +	struct jpu_ctx *ctx = fh_to_ctx(priv);
> +	struct jpu_fmt *fmt;
> +
> +	fmt = jpu_find_format(ctx->mode, f->fmt.pix.pixelformat,
> +			      JPU_FMT_TYPE_OUTPUT);
> +	if (!fmt) {
> +		v4l2_err(&ctx->jpu->v4l2_dev,
> +			 "Fourcc format (0x%08x) invalid.\n",
> +			 f->fmt.pix.pixelformat);
> +		return -EINVAL;
> +	}
> +
> +	return jpu_vidioc_try_fmt(f, fmt, ctx);
> +}
> +
> +static int jpu_s_fmt(struct jpu_ctx *ctx, struct v4l2_format *f)
> +{
> +	struct vb2_queue *vq;
> +	struct jpu_q_data *q_data;
> +	struct v4l2_pix_format *pix = &f->fmt.pix;
> +	unsigned int f_type;
> +
> +	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
> +	if (!vq)
> +		return -EINVAL;
> +
> +	q_data = jpu_get_q_data(ctx, f->type);
> +
> +	if (vb2_is_busy(vq)) {
> +		v4l2_err(&ctx->jpu->v4l2_dev, "%s queue busy\n", __func__);
> +		return -EBUSY;
> +	}
> +
> +	f_type = V4L2_TYPE_IS_OUTPUT(f->type) ? JPU_FMT_TYPE_OUTPUT :
> +						JPU_FMT_TYPE_CAPTURE;
> +
> +	q_data->fmt = jpu_find_format(ctx->mode, pix->pixelformat, f_type);
> +	q_data->w = pix->width;
> +	q_data->h = pix->height;
> +	if (q_data->fmt->fourcc != V4L2_PIX_FMT_JPEG)
> +		q_data->size = q_data->w * q_data->h * q_data->fmt->depth >> 3;
> +	else
> +		q_data->size = pix->sizeimage;
> +
> +	return 0;
> +}
> +
> +static int jpu_s_fmt_vid_cap(struct file *file, void *priv,
> +			     struct v4l2_format *f)
> +{
> +	int ret;
> +
> +	ret = jpu_try_fmt_vid_cap(file, priv, f);
> +	if (ret)
> +		return ret;
> +
> +	return jpu_s_fmt(fh_to_ctx(priv), f);
> +}
> +
> +static int jpu_s_fmt_vid_out(struct file *file, void *priv,
> +			     struct v4l2_format *f)
> +{
> +	int ret;
> +
> +	ret = jpu_try_fmt_vid_out(file, priv, f);
> +	if (ret)
> +		return ret;
> +
> +	return jpu_s_fmt(fh_to_ctx(priv), f);
> +}
> +
> +
> +static int jpu_g_selection(struct file *file, void *priv,
> +			   struct v4l2_selection *s)
> +{
> +	struct jpu_ctx *ctx = fh_to_ctx(priv);
> +
> +	if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT &&
> +		s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		return -EINVAL;
> +
> +	/* For JPEG blob active == default == bounds */
> +	switch (s->target) {
> +	case V4L2_SEL_TGT_CROP:
> +	case V4L2_SEL_TGT_CROP_BOUNDS:
> +	case V4L2_SEL_TGT_CROP_DEFAULT:
> +	case V4L2_SEL_TGT_COMPOSE:
> +	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
> +		s->r.width = ctx->out_q.w;
> +		s->r.height = ctx->out_q.h;
> +		break;
> +	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
> +	case V4L2_SEL_TGT_COMPOSE_PADDED:
> +		s->r.width = ctx->cap_q.w;
> +		s->r.height = ctx->cap_q.h;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	s->r.left = 0;
> +	s->r.top = 0;
> +	return 0;
> +}
> +
> +/*
> + * V4L2 controls
> + */
> +static int jpu_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct jpu_ctx *ctx = ctrl_to_ctx(ctrl);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&ctx->jpu->slock, flags);
> +
> +	if (ctrl->id == V4L2_CID_JPEG_COMPRESSION_QUALITY)
> +		ctx->compr_quality = ctrl->val;
> +
> +	spin_unlock_irqrestore(&ctx->jpu->slock, flags);
> +	return 0;
> +}
> +
> +static const struct v4l2_ctrl_ops jpu_ctrl_ops = {
> +	.s_ctrl		= jpu_s_ctrl,
> +};
> +
> +
> +static const struct v4l2_ioctl_ops jpu_ioctl_ops = {
> +	.vidioc_querycap		= jpu_querycap,
> +
> +	.vidioc_enum_fmt_vid_cap	= jpu_enum_fmt_vid_cap,
> +	.vidioc_enum_fmt_vid_out	= jpu_enum_fmt_vid_out,
> +
> +	.vidioc_g_fmt_vid_cap		= jpu_g_fmt,
> +	.vidioc_g_fmt_vid_out		= jpu_g_fmt,
> +
> +	.vidioc_try_fmt_vid_cap		= jpu_try_fmt_vid_cap,
> +	.vidioc_try_fmt_vid_out		= jpu_try_fmt_vid_out,
> +
> +	.vidioc_s_fmt_vid_cap		= jpu_s_fmt_vid_cap,
> +	.vidioc_s_fmt_vid_out		= jpu_s_fmt_vid_out,
> +
> +	.vidioc_reqbufs			= v4l2_m2m_ioctl_reqbufs,
> +	.vidioc_querybuf		= v4l2_m2m_ioctl_querybuf,
> +	.vidioc_qbuf			= v4l2_m2m_ioctl_qbuf,
> +	.vidioc_dqbuf			= v4l2_m2m_ioctl_dqbuf,
> +	.vidioc_streamon		= v4l2_m2m_ioctl_streamon,
> +	.vidioc_streamoff		= v4l2_m2m_ioctl_streamoff,
> +
> +	.vidioc_g_selection		= jpu_g_selection,
> +};
> +
> +static int jpu_controls_create(struct jpu_ctx *ctx)
> +{
> +	struct v4l2_ctrl *ctrl;
> +
> +	v4l2_ctrl_handler_init(&ctx->ctrl_handler, 3);
> +
> +	if (ctx->mode == JPU_ENCODE) {
> +		v4l2_ctrl_new_std(&ctx->ctrl_handler, &jpu_ctrl_ops,
> +				  V4L2_CID_JPEG_COMPRESSION_QUALITY,
> +				  0, 1, 1, 1);
> +	}
> +
> +	if (ctx->ctrl_handler.error)
> +		return ctx->ctrl_handler.error;
> +
> +	if (ctx->mode == JPU_DECODE)
> +		ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE |
> +			       V4L2_CTRL_FLAG_READ_ONLY;
> +
> +	return 0;
> +}
> +
> +/*
> + * ============================================================================
> + * Queue operations
> + * ============================================================================
> + */
> +static int jpu_queue_setup(struct vb2_queue *vq,
> +			   const struct v4l2_format *fmt,
> +			   unsigned int *nbuffers, unsigned int *nplanes,
> +			   unsigned int sizes[], void *alloc_ctxs[])
> +{
> +	struct jpu_ctx *ctx = vb2_get_drv_priv(vq);
> +	struct jpu_q_data *q_data;
> +	unsigned int size, count = *nbuffers;
> +
> +	q_data = jpu_get_q_data(ctx, vq->type);
> +
> +	size = q_data->size;
> +
> +	/*
> +	 * Header is parsed during decoding and parsed information stored
> +	 * in the context so we do not allow another buffer to overwrite it
> +	 */
> +	if (ctx->mode == JPU_DECODE)
> +		count = 1;
> +
> +	*nbuffers = count;
> +	*nplanes = 1;
> +	sizes[0] = size;
> +	alloc_ctxs[0] = ctx->jpu->alloc_ctx;
> +
> +	return 0;
> +}
> +
> +static int jpu_buf_prepare(struct vb2_buffer *vb)
> +{
> +	struct jpu_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
> +	struct jpu_q_data *q_data;
> +
> +	q_data = jpu_get_q_data(ctx, vb->vb2_queue->type);
> +
> +	if (vb2_plane_size(vb, 0) < q_data->size) {
> +		pr_err("%s: data will not fit into plane (%lu < %lu)\n",
> +			__func__, vb2_plane_size(vb, 0), (long)q_data->size);
> +		return -EINVAL;
> +	}
> +
> +	vb2_set_plane_payload(vb, 0, q_data->size);
> +
> +	return 0;
> +}
> +
> +static void jpu_buf_queue(struct vb2_buffer *vb)
> +{
> +	struct jpu_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
> +
> +	if (ctx->mode == JPU_DECODE &&
> +		vb->vb2_queue->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> +		struct jpu_q_data *q_data;
> +		struct jpu *jpu = ctx->jpu;
> +		unsigned int subsampling, w_out, h_out, w_cap, h_cap;
> +		unsigned long src_addr, flags;
> +
> +		src_addr = vb2_dma_contig_plane_dma_addr(vb, 0);
> +
> +		jpu_reset(jpu->regs);
> +
> +		iowrite32(JCMOD_DSP_DEC | JCMOD_PCTR, jpu->regs + JCMOD);
> +		iowrite32(JIFECNT_SWAP_WB, jpu->regs + JIFECNT);
> +		iowrite32(JIFDCNT_SWAP_WB, jpu->regs + JIFDCNT);
> +
> +		spin_lock_irqsave(&jpu->slock, flags);
> +		jpu->status = JPU_BUSY;
> +		spin_unlock_irqrestore(&ctx->jpu->slock, flags);
> +
> +		iowrite32(INT(3), jpu->regs + JINTE);
> +		iowrite32(src_addr, jpu->regs + JIFDSA1);
> +		iowrite32(JCCMD_JSRT, jpu->regs + JCCMD);
> +
> +		if (wait_event_interruptible_timeout(jpu->wq,
> +						     jpu->status != JPU_BUSY,
> +						     msecs_to_jiffies(100)) > 0
> +						     && jpu->status == JPU_OK)
> +			ctx->hdr_parsed = true;
> +
> +		w_out = ioread32(jpu->regs + JCHSZU) << 8 |
> +				ioread32(jpu->regs + JCHSZD);
> +
> +		h_out = ioread32(jpu->regs + JCVSZU) << 8 |
> +				ioread32(jpu->regs + JCVSZD);
> +
> +		w_cap = ioread32(jpu->regs + JIFDDHSZ);
> +		h_cap = ioread32(jpu->regs + JIFDDVSZ);
> +
> +		switch (ioread32(jpu->regs + JCMOD) & JCMOD_REDU) {
> +		case JCMOD_REDU_422:
> +			subsampling = V4L2_PIX_FMT_NV16;
> +			break;
> +		case JCMOD_REDU_420:
> +			subsampling = V4L2_PIX_FMT_NV12;
> +			break;
> +		default:
> +			subsampling = 0;
> +		}
> +
> +		if (!ctx->hdr_parsed || !subsampling || w_out > JPU_WIDTH_MAX ||
> +		    w_out < JPU_WIDTH_MIN || h_out > JPU_HEIGHT_MAX ||
> +		    h_out < JPU_HEIGHT_MIN) {
> +			pr_err("incompatible or corrupted JPEG data\n");
> +			vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
> +			return;
> +		}
> +
> +		q_data = &ctx->out_q;
> +		q_data->w = w_out;
> +		q_data->h = h_out;
> +
> +		q_data = &ctx->cap_q;
> +		q_data->w = w_cap;
> +		q_data->h = h_cap;
> +
> +		q_data->fmt = jpu_find_format(JPU_DECODE, subsampling,
> +					      JPU_FMT_TYPE_CAPTURE);
> +
> +		q_data->size =
> +			(q_data->w * q_data->h * q_data->fmt->depth) >> 3;
> +	}
> +
> +	if (ctx->fh.m2m_ctx)
> +		v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vb);
> +}
> +
> +static int jpu_start_streaming(struct vb2_queue *q, unsigned int count)
> +{
> +	return 0;
> +}
> +
> +static void jpu_stop_streaming(struct vb2_queue *q)
> +{
> +}
> +
> +static struct vb2_ops jpu_qops = {
> +	.queue_setup		= jpu_queue_setup,
> +	.buf_prepare		= jpu_buf_prepare,
> +	.buf_queue			= jpu_buf_queue,
> +	.wait_prepare		= vb2_ops_wait_prepare,
> +	.wait_finish		= vb2_ops_wait_finish,
> +	.start_streaming	= jpu_start_streaming,
> +	.stop_streaming		= jpu_stop_streaming,
> +};
> +
> +static int jpu_queue_init(void *priv, struct vb2_queue *src_vq,
> +			  struct vb2_queue *dst_vq)
> +{
> +	struct jpu_ctx *ctx = priv;
> +	int ret;
> +
> +	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
> +	src_vq->io_modes = VB2_MMAP | VB2_USERPTR;
> +	src_vq->drv_priv = ctx;
> +	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
> +	src_vq->ops = &jpu_qops;
> +	src_vq->mem_ops = &vb2_dma_contig_memops;
> +	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	src_vq->lock = &ctx->jpu->mutex;
> +
> +	ret = vb2_queue_init(src_vq);
> +	if (ret)
> +		return ret;
> +
> +	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	dst_vq->io_modes = VB2_MMAP | VB2_USERPTR;
> +	dst_vq->drv_priv = ctx;
> +	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
> +	dst_vq->ops = &jpu_qops;
> +	dst_vq->mem_ops = &vb2_dma_contig_memops;
> +	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	dst_vq->lock = &ctx->jpu->mutex;
> +
> +	return vb2_queue_init(dst_vq);
> +}
> +
> +/*
> + * ============================================================================
> + * Device file operations
> + * ============================================================================
> + */
> +static int jpu_open(struct file *file)
> +{
> +	struct jpu *jpu = video_drvdata(file);
> +	struct video_device *vfd = video_devdata(file);
> +	struct jpu_ctx *ctx;
> +	struct jpu_fmt *out_fmt, *cap_fmt;
> +	int ret = 0;
> +
> +	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
> +	if (!ctx)
> +		return -ENOMEM;
> +
> +	if (mutex_lock_interruptible(&jpu->mutex)) {
> +		ret = -ERESTARTSYS;
> +		goto free;
> +	}
> +
> +	v4l2_fh_init(&ctx->fh, vfd);
> +	ctx->fh.ctrl_handler = &ctx->ctrl_handler;
> +	file->private_data = &ctx->fh;
> +	v4l2_fh_add(&ctx->fh);
> +
> +	ctx->jpu = jpu;
> +	if (vfd == jpu->vfd_encoder) {
> +		ctx->mode = JPU_ENCODE;
> +		out_fmt = jpu_find_format(ctx->mode, V4L2_PIX_FMT_NV16,
> +					  JPU_FMT_TYPE_OUTPUT);
> +		cap_fmt = jpu_find_format(ctx->mode, V4L2_PIX_FMT_JPEG,
> +					  JPU_FMT_TYPE_CAPTURE);
> +
> +	} else {
> +		ctx->mode = JPU_DECODE;
> +		out_fmt = jpu_find_format(ctx->mode, V4L2_PIX_FMT_JPEG,
> +					  JPU_FMT_TYPE_OUTPUT);
> +		cap_fmt = jpu_find_format(ctx->mode, V4L2_PIX_FMT_NV16,
> +					  JPU_FMT_TYPE_CAPTURE);
> +	}
> +
> +	ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(jpu->m2m_dev, ctx, jpu_queue_init);
> +	if (IS_ERR(ctx->fh.m2m_ctx)) {
> +		ret = PTR_ERR(ctx->fh.m2m_ctx);
> +		goto error;
> +	}
> +
> +	ctx->out_q.fmt = out_fmt;
> +	ctx->cap_q.fmt = cap_fmt;
> +
> +	ret = jpu_controls_create(ctx);
> +	if (ret < 0)
> +		goto error;
> +
> +	if (jpu->ref_count == 0) {
> +		ret = clk_prepare_enable(jpu->clk);
> +		if (ret < 0)
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
> + * ============================================================================
> + * mem2mem callbacks
> + * ============================================================================
> + */
> +static void jpu_device_run(void *priv)
> +{
> +	struct jpu_ctx *ctx = priv;
> +	struct jpu *jpu = ctx->jpu;
> +	struct vb2_buffer *src_buf, *dst_buf;
> +	unsigned long src_addr, dst_addr, flags;
> +	void *dst_vaddr;
> +	unsigned int w, h;
> +
> +	spin_lock_irqsave(&ctx->jpu->slock, flags);
> +
> +	src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
> +	dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
> +	src_addr = vb2_dma_contig_plane_dma_addr(src_buf, 0);
> +	dst_addr = vb2_dma_contig_plane_dma_addr(dst_buf, 0);
> +	dst_vaddr = vb2_plane_vaddr(dst_buf, 0);
> +
> +	jpu_reset(jpu->regs);
> +
> +	if (ctx->mode == JPU_ENCODE) {
> +		unsigned int redu, inft;
> +
> +		w = ctx->out_q.w;
> +		h = ctx->out_q.h;
> +
> +		jpu_generate_hdr(&ctx->out_q, ctx->compr_quality, dst_vaddr);
> +
> +		if (ctx->out_q.fmt->fourcc == V4L2_PIX_FMT_NV12) {
> +			redu = JCMOD_REDU_420;
> +			inft = JIFECNT_INFT_420;
> +		} else {
> +			redu = JCMOD_REDU_422;
> +			inft = JIFECNT_INFT_422;
> +		}
> +
> +		/* the only no marker mode works for encoding */
> +		iowrite32(JCMOD_DSP_ENC | JCMOD_PCTR | redu | JCMOD_SOI_ENABLE |
> +			  JCMOD_MSKIP_ENABLE, jpu->regs + JCMOD);
> +
> +		iowrite32(JIFECNT_SWAP_WB | inft, jpu->regs + JIFECNT);
> +		iowrite32(JIFDCNT_SWAP_WB, jpu->regs + JIFDCNT);
> +		iowrite32(INT(10), jpu->regs + JINTE);
> +
> +		/* Y and C components source addresses */
> +		iowrite32(src_addr, jpu->regs + JIFESYA1);
> +		iowrite32(src_addr + w * h, jpu->regs + JIFESCA1);
> +
> +		/* memory width */
> +		iowrite32(w, jpu->regs + JIFESMW);
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
> +		w = ctx->cap_q.w;
> +		h = ctx->cap_q.h;
> +
> +		iowrite32(JCMOD_DSP_DEC | JCMOD_PCTR, jpu->regs + JCMOD);
> +		iowrite32(JIFECNT_SWAP_WB, jpu->regs + JIFECNT);
> +		iowrite32(JIFDCNT_SWAP_WB, jpu->regs + JIFDCNT);
> +		iowrite32(INT(10) | INT(7) | INT(6) | INT(5),
> +			  jpu->regs + JINTE);
> +		iowrite32(src_addr, jpu->regs + JIFDSA1);
> +		iowrite32(w, jpu->regs + JIFDDMW);
> +		iowrite32(dst_addr, jpu->regs + JIFDDYA1);
> +		iowrite32(dst_addr + w * h, jpu->regs + JIFDDCA1);
> +	}
> +
> +	iowrite32(JCCMD_JSRT, jpu->regs + JCCMD);
> +	spin_unlock_irqrestore(&ctx->jpu->slock, flags);
> +}
> +
> +static int jpu_job_ready(void *priv)
> +{
> +	struct jpu_ctx *ctx = priv;
> +
> +	if (ctx->mode == JPU_DECODE)
> +		return ctx->hdr_parsed;
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
> + * ============================================================================
> + * IRQ handler
> + * ============================================================================
> + */
> +static irqreturn_t jpu_irq_handler(int irq, void *dev_id)
> +{
> +	struct jpu *jpu = dev_id;
> +	struct jpu_ctx *curr_ctx;
> +	struct vb2_buffer *src_buf, *dst_buf;
> +	unsigned long payload_size = 0;
> +	unsigned int int_status;
> +	unsigned int error;
> +
> +	spin_lock(&jpu->slock);
> +
> +	int_status = ioread32(jpu->regs + JINTS);
> +	jpu_int_clear(jpu->regs, int_status);
> +
> +	/*
> +	 * In any mode (decoding/encoding) we can additionaly get
> +	 * error status (5th bit)
> +	 * jpu operation complete status (6th bit)
> +	 */
> +	if (!((ioread32(jpu->regs + JINTE) | INT(5) | INT(6)) & int_status)) {
> +		spin_unlock(&jpu->slock);
> +		return IRQ_NONE;
> +	}
> +
> +	if (jpu->status == JPU_BUSY) {
> +		if (int_status & INT(3))
> +			jpu->status = JPU_OK;
> +		if (int_status & INT(5))
> +			jpu->status = JPU_ERR;
> +		wake_up_interruptible(&jpu->wq);
> +		goto handled;
> +	}
> +
> +	if ((int_status & INT(6)) && !(int_status & INT(10)))
> +		goto handled;
> +
> +	curr_ctx = v4l2_m2m_get_curr_priv(jpu->m2m_dev);
> +
> +	src_buf = v4l2_m2m_src_buf_remove(curr_ctx->fh.m2m_ctx);
> +	dst_buf = v4l2_m2m_dst_buf_remove(curr_ctx->fh.m2m_ctx);
> +
> +	if (int_status & INT(10)) {
> +		if (curr_ctx->mode == JPU_ENCODE) {
> +			payload_size = ioread32(jpu->regs + JCDTCU) << 16 |
> +				       ioread32(jpu->regs + JCDTCM) << 8  |
> +				       ioread32(jpu->regs + JCDTCD);
> +			vb2_set_plane_payload(dst_buf, 0,
> +				payload_size + JPU_JPEG_HDR_SIZE);
> +		}
> +		v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_DONE);
> +		v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_DONE);
> +	} else if (int_status & INT(5)) {
> +		error = ioread32(jpu->regs + JCDERR);
> +		dev_err(jpu->dev, "error 0x%2X\n", error);
> +		v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_ERROR);
> +		v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_ERROR);
> +	}
> +
> +	v4l2_m2m_job_finish(jpu->m2m_dev, curr_ctx->fh.m2m_ctx);
> +
> +handled:
> +	spin_unlock(&jpu->slock);
> +	return IRQ_HANDLED;
> +}
> +
> +/*
> + * ============================================================================
> + * Driver basic infrastructure
> + * ============================================================================
> + */
> +static const struct of_device_id jpu_dt_ids[] = {
> +	{ .compatible = "renesas,jpu-r8a7790" },
> +	{ .compatible = "renesas,jpu-r8a7791" },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, jpu_dt_ids);
> +
> +static int jpu_probe(struct platform_device *pdev)
> +{
> +	struct jpu *jpu;
> +	struct resource *res;
> +	int ret;
> +
> +	/* JPEG IP abstraction struct */
> +	jpu = devm_kzalloc(&pdev->dev, sizeof(struct jpu), GFP_KERNEL);
> +	if (!jpu)
> +		return -ENOMEM;
> +
> +	mutex_init(&jpu->mutex);
> +	spin_lock_init(&jpu->slock);
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
> +		ret = PTR_ERR(jpu->clk);
> +		return ret;
> +	}
> +
> +	/* v4l2 device */
> +	ret = v4l2_device_register(&pdev->dev, &jpu->v4l2_dev);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Failed to register v4l2 device\n");
> +		goto clk_get_rollback;
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
> +			sizeof(jpu->vfd_encoder->name));
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
> +
> +	/* final statements & power management */
> +	platform_set_drvdata(pdev, jpu);
> +
> +	init_waitqueue_head(&jpu->wq);
> +
> +	v4l2_info(&jpu->v4l2_dev, "Renesas JPEG codec\n");
> +
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
> +clk_get_rollback:
> +	clk_disable_unprepare(jpu->clk);
> +
> +	return ret;
> +}
> +
> +static int jpu_remove(struct platform_device *pdev)
> +{
> +	struct jpu *jpu = platform_get_drvdata(pdev);
> +
> +	video_unregister_device(jpu->vfd_decoder);
> +	video_device_release(jpu->vfd_decoder);
> +	video_unregister_device(jpu->vfd_encoder);
> +	video_device_release(jpu->vfd_encoder);
> +	vb2_dma_contig_cleanup_ctx(jpu->alloc_ctx);
> +	v4l2_m2m_release(jpu->m2m_dev);
> +	v4l2_device_unregister(&jpu->v4l2_dev);
> +	clk_disable_unprepare(jpu->clk);
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM_SLEEP
> +static int jpu_suspend(struct device *dev)
> +{
> +	struct jpu *jpu = dev_get_drvdata(dev);
> +
> +	if (jpu->ref_count == 0)
> +		return 0;
> +
> +	clk_disable_unprepare(jpu->clk);
> +
> +	return 0;
> +}
> +
> +static int jpu_resume(struct device *dev)
> +{
> +	struct jpu *jpu = dev_get_drvdata(dev);
> +
> +	if (jpu->ref_count)
> +		return 0;
> +
> +	clk_prepare_enable(jpu->clk);
> +
> +	return 0;
> +}
> +#endif
> +
> +static const struct dev_pm_ops jpu_pm_ops = {
> +	SET_SYSTEM_SLEEP_PM_OPS(jpu_suspend, jpu_resume)
> +};
> +
> +static struct platform_driver jpu_driver = {
> +	.probe = jpu_probe,
> +	.remove = jpu_remove,
> +	.driver = {
> +		.of_match_table = jpu_dt_ids,
> +		.owner = THIS_MODULE,
> +		.name = JPU_M2M_NAME,
> +		.pm = &jpu_pm_ops,
> +	},
> +};
> +
> +module_platform_driver(jpu_driver);
> +
> +MODULE_ALIAS("jpu");
> +MODULE_AUTHOR("Mikhail Ulianov <mikhail.ulyanov@cogentembedded.com>");
> +MODULE_DESCRIPTION("Renesas JPEG codec driver");
> +MODULE_LICENSE("GPL v2");
> 

