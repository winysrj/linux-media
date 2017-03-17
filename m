Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:54632 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751208AbdCQOYK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Mar 2017 10:24:10 -0400
Subject: Re: [PATCH v5] media: platform: Renesas IMR driver
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org
References: <20170309200818.786255823@cogentembedded.com>
Cc: linux-renesas-soc@vger.kernel.org,
        Konstantin Kozhevnikov
        <Konstantin.Kozhevnikov@cogentembedded.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <63d45493-5038-7eda-7941-553357ee757b@xs4all.nl>
Date: Fri, 17 Mar 2017 15:24:01 +0100
MIME-Version: 1.0
In-Reply-To: <20170309200818.786255823@cogentembedded.com>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergei,

Sorry for the long wait before I got around to reviewing this, but here
are (finally!) my review comments.

On 03/09/17 21:08, Sergei Shtylyov wrote:
> From: Konstantin Kozhevnikov <Konstantin.Kozhevnikov@cogentembedded.com>
> 
> The image renderer, or the distortion correction engine, is a drawing
> processor with a simple instruction system capable of referencing video
> capture data or data in an external memory as the 2D texture data and
> performing texture mapping and drawing with respect to any shape that is
> split into triangular objects.
> 
> This V4L2 memory-to-memory device driver only supports image renderer light
> extended 4 (IMR-LX4) found in the R-Car gen3 SoCs; the R-Car gen2 support
> can be added later...
> 
> [Sergei: merged 2 original patches, added the patch description, removed
> unrelated parts,  added the binding document, ported the driver to the
> modern kernel, renamed the UAPI header file and the  guard macros to match
> the driver name, extended the copyrights, fixed up Kconfig prompt/depends/
> help, made use of the BIT/GENMASK() macros, sorted #include's, removed
> leading  dots and fixed grammar in the comments, fixed up indentation to
> use tabs where possible, renamed DLSR, CMRCR.DY1{0|2}, and ICR bits to
> match the manual, changed the prefixes of the CMRCR[2]/TRI{M|C}R bits/
> fields to match the manual, removed non-existent TRIMR.D{Y|U}D{X|V}M bits,
> added/used the IMR/{UV|CP}DPOR/SUSR bits/fields/shifts, separated the
> register offset/bit #define's, sorted the instruction macros by opcode,
> removed unsupported LINE instruction, masked the register address in
> WTL[2]/WTS instruction macros, moved the display list #define's after
> the register #define's, removing the redundant comment, avoided setting
> reserved bits when writing CMRCCR[2]/TRIMCR, used the SR bits instead of
> a bare number, used ALIGN() macro in imr_ioctl_map(), removed *inline*
> from .c file, fixed lines over 80 columns, removed useless spaces,
> comments, parens, operators, casts, braces, variables, #include's,
> statements, and even 1 function, uppercased the abbreviations, made
> comment wording more consistent/correct, fixed the comment typos,
> reformatted some multiline comments, inserted empty line after declaration,
> removed extra empty lines, reordered some local variable desclarations,
> removed calls to 4l2_err() on kmalloc() failure, replaced '*' with 'x'
> in some format strings for v4l2_dbg(), fixed the error returned by
> imr_default(), avoided code duplication in the IRQ handler, used
> '__packed' for the UAPI structures, enclosed the macro parameters in
> parens, exchanged the values of IMR_MAP_AUTO{S|D}G macros.]
> 
> Signed-off-by: Konstantin Kozhevnikov <Konstantin.Kozhevnikov@cogentembedded.com>
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> 
> ---
> This patch is against the 'media_tree.git' repo's 'master' branch.
> 
> Changes in version 5:
> - used ALIGN() macro in imr_ioctl_map();
> - moved the display list #define's after the register #define's, removing the
>   redundant comment;
> - uppercased the "tbd" abbreviation in the comments;
> - made the TRI instruction types A/B/C named consistently;
> - avoided quotes around the coordinate's names;
> - avoided some  hyphens in the comments;
> - removed spaces around / and before ? in the comments;
> - reworded some comments;
> - reformatted some multiline comments;
> - fixed typos in the comments.
> 
> Changes in version 4:
> - added/used the SUSR fields/shifts.
> 
> Changes in version 3:
> - added/used the {UV|CP}DPOR fields/shifts;
> - removed unsupported LINE instruction;
> - replaced '*' with 'x' in the string passed to v4l2_dbg() in
>   imr_dl_program_setup();
> - switched to prepending the SoC model to "imr-lx4" in the "compatible" prop
>   strings.
> 
> Changes in version 2:
> - renamed the ICR bits to match the manual;
> - added/used  the IMR bits;
> - changed the prefixes of the CMRCR[2]/TRI{M|C}R bits/fields to match the
>   manual;
> - renamed the CMRCR.DY1{0|2} bits to match the manual;
> - removed non-existent TRIMR.D{Y|U}D{X|V}M bits;
> - used the SR bits instead of a bare number;
> - sorted the instruction macros by opcode, removing redundant parens;
> - masked the register address in WTL[2]/WTS instruction macros;
> - avoided setting reserved bits when writing to CMRCCR[2]/TRIMCR;
> - mentioned the video capture data as a texture source in the binding and the
>   patch description;
> - documented the SoC specific "compatible" values;
> - clarified the "interrupts" and "clocks" property text;
> - updated the patch description.
> 
>  Documentation/devicetree/bindings/media/rcar_imr.txt |   27 
>  drivers/media/platform/Kconfig                       |   13 
>  drivers/media/platform/Makefile                      |    1 
>  drivers/media/platform/rcar_imr.c                    | 1943 +++++++++++++++++++
>  include/uapi/linux/rcar_imr.h                        |   94 
>  5 files changed, 2078 insertions(+)
> 
> Index: media_tree/Documentation/devicetree/bindings/media/rcar_imr.txt
> ===================================================================
> --- /dev/null
> +++ media_tree/Documentation/devicetree/bindings/media/rcar_imr.txt
> @@ -0,0 +1,27 @@
> +Renesas R-Car Image Renderer (Distortion Correction Engine)
> +-----------------------------------------------------------
> +
> +The image renderer, or the distortion correction engine, is a drawing processor
> +with a simple instruction system capable of referencing video capture data or
> +data in an external memory as 2D texture data and performing texture mapping
> +and drawing with respect to any shape that is split into triangular objects.
> +
> +Required properties:
> +
> +- compatible: "renesas,<soctype>-imr-lx4", "renesas,imr-lx4" as a fallback for
> +  the image renderer light extended 4 (IMR-LX4) found in the R-Car gen3 SoCs,
> +  where the examples with <soctype> are:
> +  - "renesas,r8a7795-imr-lx4" for R-Car H3,
> +  - "renesas,r8a7796-imr-lx4" for R-Car M3-W.
> +- reg: offset and length of the register block;
> +- interrupts: single interrupt specifier;
> +- clocks: single clock phandle/specifier pair.
> +
> +Example:
> +
> +	imr-lx4@fe860000 {
> +		compatible = "renesas,r8a7795-imr-lx4", "renesas,imr-lx4";
> +		reg = <0 0xfe860000 0 0x2000>;
> +		interrupts = <GIC_SPI 192 IRQ_TYPE_LEVEL_HIGH>;
> +		clocks = <&cpg CPG_MOD 823>;
> +	};
> Index: media_tree/drivers/media/platform/Kconfig
> ===================================================================
> --- media_tree.orig/drivers/media/platform/Kconfig
> +++ media_tree/drivers/media/platform/Kconfig
> @@ -414,6 +414,19 @@ config VIDEO_RENESAS_FCP
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called rcar-fcp.
>  
> +config VIDEO_RENESAS_IMR
> +	tristate "Renesas Image Renderer (Distortion Correction Engine)"
> +	depends on VIDEO_DEV && VIDEO_V4L2
> +	depends on ARCH_RENESAS || COMPILE_TEST
> +	select VIDEOBUF2_DMA_CONTIG
> +	select V4L2_MEM2MEM_DEV
> +	---help---
> +	  This is a V4L2 driver for the Renesas Image Renderer Light Extended 4
> +	  (IMR-LX4).
> +
> +	  To compile this driver as a module, choose M here: the module
> +	  will be called rcar_imr.
> +
>  config VIDEO_RENESAS_VSP1
>  	tristate "Renesas VSP1 Video Processing Engine"
>  	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && HAS_DMA
> Index: media_tree/drivers/media/platform/Makefile
> ===================================================================
> --- media_tree.orig/drivers/media/platform/Makefile
> +++ media_tree/drivers/media/platform/Makefile
> @@ -52,6 +52,7 @@ obj-$(CONFIG_SOC_CAMERA)		+= soc_camera/
>  obj-$(CONFIG_VIDEO_RENESAS_FCP) 	+= rcar-fcp.o
>  obj-$(CONFIG_VIDEO_RENESAS_FDP1)	+= rcar_fdp1.o
>  obj-$(CONFIG_VIDEO_RENESAS_JPU) 	+= rcar_jpu.o
> +obj-$(CONFIG_VIDEO_RENESAS_IMR) 	+= rcar_imr.o
>  obj-$(CONFIG_VIDEO_RENESAS_VSP1)	+= vsp1/
>  
>  obj-y	+= omap/
> Index: media_tree/drivers/media/platform/rcar_imr.c
> ===================================================================
> --- /dev/null
> +++ media_tree/drivers/media/platform/rcar_imr.c
> @@ -0,0 +1,1943 @@
> +/*
> + * rcar_imr.c -- R-Car IMR-LX4 Driver
> + *
> + * Copyright (C) 2015-2017 Cogent Embedded, Inc. <source@cogentembedded.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include <linux/bitops.h>
> +#include <linux/clk.h>
> +#include <linux/interrupt.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/rcar_imr.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-fh.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/v4l2-mem2mem.h>
> +#include <media/videobuf2-dma-contig.h>
> +
> +#define DRV_NAME		"rcar_imr"
> +
> +/*******************************************************************************
> + * Module parameters
> + ******************************************************************************/
> +
> +static int debug;
> +module_param(debug, int, 0644);
> +MODULE_PARM_DESC(debug, "Debug level (0-4)");
> +
> +/*******************************************************************************
> + * Local type definitions
> + ******************************************************************************/
> +
> +/* configuration data */
> +struct imr_cfg {
> +	/* display-list main program data */
> +	void			*dl_vaddr;
> +	dma_addr_t		dl_dma_addr;
> +	u32			dl_size;
> +	u32			dl_start_offset;
> +
> +	/* pointers to the source/destination planes */
> +	u32			*src_pa_ptr[2];
> +	u32			*dst_pa_ptr[2];
> +
> +	/* subpixel destination coordinates space */
> +	int			dst_subpixel;
> +
> +	/* reference counter */
> +	u32			refcount;
> +
> +	/* identifier (for debug output) */
> +	u32			id;
> +};
> +
> +struct imr_buffer {
> +	/* standard M2M buffer descriptor */
> +	struct v4l2_m2m_buffer	buf;
> +
> +	/* pointer to mesh configuration for processing */
> +	struct imr_cfg		*cfg;
> +};
> +
> +struct imr_q_data {
> +	/* latched pixel format */
> +	struct v4l2_pix_format	fmt;
> +
> +	/* current format flags */
> +	u32			flags;
> +};
> +
> +struct imr_format_info {
> +	char			*name;
> +	u32			fourcc;
> +	u32			flags;
> +};
> +
> +/* per-device data */
> +struct imr_device {
> +	struct device		*dev;
> +	struct clk		*clock;
> +	void __iomem		*mmio;
> +	int			irq;
> +	struct mutex		mutex;
> +	spinlock_t		lock;
> +
> +	struct v4l2_device	v4l2_dev;
> +	struct video_device	video_dev;
> +	struct v4l2_m2m_dev	*m2m_dev;
> +	void			*alloc_ctx;
> +
> +	/*
> +	 * do we need that counter really?
> +	 * framework counts fh structures for us - TBD
> +	 */
> +	int			refcount;
> +
> +	/* should we include media-dev? likely, no - TBD */
> +};
> +
> +/* per file-handle context */
> +struct imr_ctx {
> +	struct v4l2_fh		fh;
> +	struct imr_device	*imr;
> +	struct v4l2_m2m_ctx	*m2m_ctx;
> +	struct imr_q_data	queue[2];
> +
> +	/* current job configuration */
> +	struct imr_cfg		*cfg;
> +
> +	/* frame sequence counter */
> +	u32			sequence;
> +
> +	/* cropping parameters (in pixels) */
> +	u16			crop[4];
> +
> +	/* number of active configurations (debugging) */
> +	u32			cfg_num;
> +};
> +
> +/*******************************************************************************
> + * IMR registers
> + ******************************************************************************/
> +
> +#define IMR_CR			0x08
> +#define IMR_SR			0x0C
> +#define IMR_SRCR		0x10
> +#define IMR_ICR			0x14
> +#define IMR_IMR			0x18
> +#define IMR_DLSP		0x1C
> +#define IMR_DLPR		0x20
> +#define IMR_DLSAR		0x30
> +#define IMR_DSAR		0x34
> +#define IMR_SSAR		0x38
> +#define IMR_DSTR		0x3C
> +#define IMR_SSTR		0x40
> +#define IMR_DSOR		0x50
> +#define IMR_CMRCR		0x54
> +#define IMR_CMRCSR		0x58
> +#define IMR_CMRCCR		0x5C
> +#define IMR_TRIMR		0x60
> +#define IMR_TRIMSR		0x64
> +#define IMR_TRIMCR		0x68
> +#define IMR_TRICR		0x6C
> +#define IMR_UVDPOR		0x70
> +#define IMR_SUSR		0x74
> +#define IMR_SVSR		0x78
> +#define IMR_XMINR		0x80
> +#define IMR_YMINR		0x84
> +#define IMR_XMAXR		0x88
> +#define IMR_YMAXR		0x8C
> +#define IMR_AMXSR		0x90
> +#define IMR_AMYSR		0x94
> +#define IMR_AMXOR		0x98
> +#define IMR_AMYOR		0x9C
> +#define IMR_CPDPOR		0xD0
> +#define IMR_CMRCR2		0xE4
> +#define IMR_CMRCSR2		0xE8
> +#define IMR_CMRCCR2		0xEC
> +
> +#define IMR_CR_RS		BIT(0)
> +#define IMR_CR_SWRST		BIT(15)
> +
> +#define IMR_SR_TRA		BIT(0)
> +#define IMR_SR_IER		BIT(1)
> +#define IMR_SR_INT		BIT(2)
> +#define IMR_SR_REN		BIT(5)
> +
> +#define IMR_ICR_TRAENB		BIT(0)
> +#define IMR_ICR_IERENB		BIT(1)
> +#define IMR_ICR_INTENB		BIT(2)
> +
> +#define IMR_IMR_TRAM		BIT(0)
> +#define IMR_IMR_IEM		BIT(1)
> +#define IMR_IMR_INM		BIT(2)
> +
> +#define IMR_CMRCR_LUCE		BIT(1)
> +#define IMR_CMRCR_CLCE		BIT(2)
> +#define IMR_CMRCR_DUV_SHIFT	3
> +#define IMR_CMRCR_DUV		GENMASK(4, 3)
> +#define IMR_CMRCR_SUV_SHIFT	5
> +#define IMR_CMRCR_SUV		GENMASK(6, 5)
> +#define IMR_CMRCR_YISM		BIT(7)
> +#define IMR_CMRCR_Y10		BIT(8)
> +#define IMR_CMRCR_Y12		BIT(9)
> +#define IMR_CMRCR_SY10		BIT(11)
> +#define IMR_CMRCR_SY12		BIT(12)
> +#define IMR_CMRCR_YCM		BIT(14)
> +#define IMR_CMRCR_CP16E		BIT(15)
> +
> +#define IMR_TRIMR_TME		BIT(0)
> +#define IMR_TRIMR_BFE		BIT(1)
> +#define IMR_TRIMR_AUTODG	BIT(2)
> +#define IMR_TRIMR_AUTOSG	BIT(3)
> +#define IMR_TRIMR_TCM		BIT(6)
> +
> +#define IMR_TRICR_YCFORM	BIT(31)
> +
> +#define IMR_UVDPOR_UVDPO_SHIFT	0
> +#define IMR_UVDPOR_UVDPO	GENMASK(2, 0)
> +#define IMR_UVDPOR_DDP		BIT(8)
> +
> +#define IMR_SUSR_SVW_SHIFT	0
> +#define IMR_SUSR_SVW		GENMASK(10, 0)
> +#define IMR_SUSR_SUW_SHIFT	16
> +#define IMR_SUSR_SUW		GENMASK(26, 16)
> +
> +#define IMR_CPDPOR_VRDPO_SHIFT	0
> +#define IMR_CPDPOR_VRDPO	GENMASK(2, 0)
> +#define IMR_CPDPOR_UBDPO_SHIFT	4
> +#define IMR_CPDPOR_UBDPO	GENMASK(6, 4)
> +#define IMR_CPDPOR_YLDPO_SHIFT	8
> +#define IMR_CPDPOR_YLDPO	GENMASK(10, 8)
> +
> +#define IMR_CMRCR2_LUTE		BIT(0)
> +#define IMR_CMRCR2_YUV422E	BIT(2)
> +#define IMR_CMRCR2_YUV422FORM	BIT(5)
> +#define IMR_CMRCR2_UVFORM	BIT(6)
> +#define IMR_CMRCR2_TCTE		BIT(12)
> +#define IMR_CMRCR2_DCTE		BIT(15)
> +
> +/*******************************************************************************
> + * Display list commands
> + ******************************************************************************/
> +
> +#define IMR_OP_NOP(n)		((0x80 << 24) | ((n) & 0xFFFF))
> +#define IMR_OP_WTL(add, n)	((0x81 << 24) | ((((add) & 0x3FC) / 4) << 16) \
> +				 | ((n) & 0xFFFF))
> +#define IMR_OP_WTS(add, data)	((0x82 << 24) | ((((add) & 0x3FC) / 4) << 16) \
> +				 | ((data) & 0xFFFF))
> +#define IMR_OP_WTL2(add, n)	((0x83 << 24) | ((((add) & 0xFFFC) / 4) << 10) \
> +				 | ((n) & 0x3FF))
> +#define IMR_OP_SYNCM		 (0x86 << 24)
> +#define IMR_OP_INT		 (0x88 << 24)
> +#define IMR_OP_TRI(n)		((0x8A << 24) | ((n) & 0xFFFF))
> +#define IMR_OP_GOSUB		 (0x8C << 24)
> +#define IMR_OP_RET		 (0x8D << 24)
> +#define IMR_OP_TRAP		 (0x8F << 24)
> +
> +/*******************************************************************************
> + * Auxiliary helpers
> + ******************************************************************************/
> +
> +static struct imr_ctx *fh_to_ctx(struct v4l2_fh *fh)
> +{
> +	return container_of(fh, struct imr_ctx, fh);
> +}
> +
> +static struct imr_buffer *to_imr_buffer(struct vb2_v4l2_buffer *vbuf)
> +{
> +	struct v4l2_m2m_buffer *b = container_of(vbuf, struct v4l2_m2m_buffer,
> +						 vb);
> +
> +	return container_of(b, struct imr_buffer, buf);
> +}
> +
> +/*******************************************************************************
> + * Local constant definition
> + ******************************************************************************/
> +
> +#define IMR_F_Y8		BIT(0)
> +#define IMR_F_Y10		BIT(1)
> +#define IMR_F_Y12		BIT(2)
> +#define IMR_F_UV8		BIT(3)
> +#define IMR_F_UV10		BIT(4)
> +#define IMR_F_UV12		BIT(5)
> +#define IMR_F_PLANAR		BIT(6)
> +#define IMR_F_INTERLEAVED	BIT(7)
> +#define IMR_F_PLANES_MASK	(BIT(8) - 1)
> +#define IMR_F_UV_SWAP		BIT(8)
> +#define IMR_F_YUV_SWAP		BIT(9)
> +
> +/* get common planes bits */
> +static u32 __imr_flags_common(u32 iflags, u32 oflags)
> +{
> +	return iflags & oflags & IMR_F_PLANES_MASK;
> +}
> +
> +static const struct imr_format_info imr_lx4_formats[] = {
> +	{
> +		.name	= "YUV 4:2:2 semiplanar (NV16)",

Drop the names. These are set in v4l2-ioctl.c. That ensures consistent
naming.

> +		.fourcc	= V4L2_PIX_FMT_NV16,
> +		.flags	= IMR_F_Y8 | IMR_F_UV8 | IMR_F_PLANAR,
> +	},
> +	{
> +		.name	= "YVU 4:2:2 semiplanar (NV61)",
> +		.fourcc	= V4L2_PIX_FMT_NV61,
> +		.flags	= IMR_F_Y8 | IMR_F_UV8 | IMR_F_PLANAR | IMR_F_UV_SWAP,
> +	},
> +	{
> +		.name	= "YUV 4:2:2 interleaved (YUYV)",
> +		.fourcc	= V4L2_PIX_FMT_YUYV,
> +		.flags	= IMR_F_Y8 | IMR_F_UV8,
> +	},
> +	{
> +		.name	= "YUV 4:2:2 interleaved (UYVY)",
> +		.fourcc	= V4L2_PIX_FMT_UYVY,
> +		.flags	= IMR_F_Y8 | IMR_F_UV8 | IMR_F_YUV_SWAP,
> +	},
> +	{
> +		.name	= "YUV 4:2:2 interleaved (YVYU)",
> +		.fourcc	= V4L2_PIX_FMT_YVYU,
> +		.flags	= IMR_F_Y8 | IMR_F_UV8 | IMR_F_UV_SWAP,
> +	},
> +	{
> +		.name	= "YUV 4:2:2 interleaved (UYVY)",
> +		.fourcc	= V4L2_PIX_FMT_VYUY,
> +		.flags	= IMR_F_Y8 | IMR_F_UV8 | IMR_F_UV_SWAP | IMR_F_YUV_SWAP,
> +	},
> +	{
> +		.name	= "Greyscale 8-bit",
> +		.fourcc	= V4L2_PIX_FMT_GREY,
> +		.flags	= IMR_F_Y8 | IMR_F_PLANAR,
> +	},
> +	{
> +		.name	= "Greyscale 10-bit",
> +		.fourcc	= V4L2_PIX_FMT_Y10,
> +		.flags	= IMR_F_Y8 | IMR_F_Y10 | IMR_F_PLANAR,
> +	},
> +	{
> +		.name	= "Greyscale 12-bit",
> +		.fourcc	= V4L2_PIX_FMT_Y12,
> +		.flags	= IMR_F_Y8 | IMR_F_Y10 | IMR_F_Y12 | IMR_F_PLANAR,
> +	},
> +	{
> +		.name	= "Chrominance UV 8-bit",
> +		.fourcc	= V4L2_PIX_FMT_UV8,
> +		.flags	= IMR_F_UV8 | IMR_F_PLANAR,
> +	},
> +};
> +
> +/* mesh configuration constructor */
> +static struct imr_cfg *imr_cfg_create(struct imr_ctx *ctx,
> +				      u32 dl_size, u32 dl_start)
> +{
> +	struct imr_device	*imr = ctx->imr;
> +	struct imr_cfg		*cfg;
> +
> +	/* allocate configuration descriptor */
> +	cfg = kmalloc(sizeof(*cfg), GFP_KERNEL);
> +	if (!cfg)
> +		return ERR_PTR(-ENOMEM);
> +
> +	/* allocate contiguous memory for a display list */
> +	cfg->dl_vaddr = dma_alloc_writecombine(imr->dev, dl_size,
> +					       &cfg->dl_dma_addr, GFP_KERNEL);
> +	if (!cfg->dl_vaddr) {
> +		v4l2_err(&imr->v4l2_dev,
> +			 "failed to allocate %u bytes for a DL\n", dl_size);
> +		kfree(cfg);
> +		return ERR_PTR(-ENOMEM);
> +	}
> +
> +	cfg->dl_size = dl_size;
> +	cfg->dl_start_offset = dl_start;
> +	cfg->refcount = 1;
> +	cfg->id = ctx->sequence;
> +
> +	/* for debugging purposes, advance number of active configurations */
> +	ctx->cfg_num++;
> +
> +	return cfg;
> +}
> +
> +/* add reference to the current configuration */
> +static inline struct imr_cfg *imr_cfg_ref(struct imr_ctx *ctx)
> +{
> +	struct imr_cfg *cfg = ctx->cfg;
> +
> +	BUG_ON(!cfg);
> +	cfg->refcount++;
> +	return cfg;
> +}
> +
> +/* mesh configuration destructor */
> +static void imr_cfg_unref(struct imr_ctx *ctx, struct imr_cfg *cfg)
> +{
> +	struct imr_device *imr = ctx->imr;
> +
> +	/* no atomicity is required as operation is locked with device mutex */
> +	if (!cfg || --cfg->refcount)
> +		return;
> +
> +	/* release memory allocated for a display list */
> +	if (cfg->dl_vaddr)
> +		dma_free_writecombine(imr->dev, cfg->dl_size, cfg->dl_vaddr,
> +				      cfg->dl_dma_addr);
> +
> +	/* destroy the configuration structure */
> +	kfree(cfg);
> +
> +	/* decrement number of active configurations (debugging) */
> +	WARN_ON(!ctx->cfg_num--);
> +}
> +
> +/*******************************************************************************
> + * Context processing queue
> + ******************************************************************************/
> +
> +static int imr_queue_setup(struct vb2_queue *vq,
> +			   unsigned int *nbuffers, unsigned int *nplanes,
> +			   unsigned int sizes[], struct device *alloc_ctxs[])
> +{
> +	struct imr_ctx		*ctx = vb2_get_drv_priv(vq);
> +	struct imr_q_data	*q_data = &ctx->queue
> +					[V4L2_TYPE_IS_OUTPUT(vq->type) ? 0 : 1];
> +	int			w = q_data->fmt.width;
> +	int			h = q_data->fmt.height;
> +
> +	/* we use only single-plane formats */
> +	*nplanes = 1;
> +
> +	/* specify plane size */
> +	switch (q_data->fmt.pixelformat) {
> +	case V4L2_PIX_FMT_UYVY:
> +	case V4L2_PIX_FMT_YUYV:
> +	case V4L2_PIX_FMT_VYUY:
> +	case V4L2_PIX_FMT_YVYU:
> +	case V4L2_PIX_FMT_NV16:
> +	case V4L2_PIX_FMT_Y10:
> +	case V4L2_PIX_FMT_Y16:
> +		sizes[0] = w * h * 2;
> +		break;
> +
> +	case V4L2_PIX_FMT_UV8:
> +	case V4L2_PIX_FMT_GREY:
> +		sizes[0] = w * h;

This isn't right. You calculate the minimum size for the current format,
then you check if the passed-in size is >= the minimum size.

> +		break;
> +
> +	default:
> +		return -EINVAL;
> +	}

The right code here would be:

        if (*nplanes)
                return sizes[0] < size ? -EINVAL : 0;
        *nplanes = 1;
        sizes[0] = size;

See the documentation of queue_setup in videobuf2-core.h for more details.

> +
> +	/* specify default allocator */
> +	alloc_ctxs[0] = ctx->imr->alloc_ctx;

???

ctx->imr->alloc_ctx is never initialized AFAICT.

You would not modify alloc_ctxs[0] here anyway, instead you fill in the
dev field of struct vb2_queue with the device pointer.

alloc_ctxs is rarely set, only for weird HW setups (only exynos today).

> +
> +	return 0;
> +}
> +
> +static int imr_buf_prepare(struct vb2_buffer *vb)
> +{
> +	/*
> +	 * unclear yet if we want to prepare a buffer somehow
> +	 * (cache invalidation? - TBD)
> +	 */
> +	return 0;
> +}

Just drop this empty function. Cache invalidation is handled elsewhere.

> +
> +static void imr_buf_queue(struct vb2_buffer *vb)
> +{
> +	struct vb2_v4l2_buffer	*vbuf = to_vb2_v4l2_buffer(vb);
> +	struct vb2_queue	*q = vb->vb2_queue;
> +	struct imr_ctx		*ctx = vb2_get_drv_priv(q);
> +
> +	WARN_ON_ONCE(!mutex_is_locked(&ctx->imr->mutex));
> +
> +	v4l2_dbg(3, debug, &ctx->imr->v4l2_dev,
> +		 "%sput buffer <0x%08llx> submitted\n",
> +		 q->is_output ? "in" : "out",
> +		 (u64)vb2_dma_contig_plane_dma_addr(vb, 0));
> +
> +	/*
> +	 * for input buffer, put current configuration pointer
> +	 * (add reference)
> +	 */
> +	if (q->is_output)
> +		to_imr_buffer(vbuf)->cfg = imr_cfg_ref(ctx);

Shouldn't this happen in buf_prepare? Since the cleanup is in finish?
This feels like this is the wrong place.

> +
> +	v4l2_m2m_buf_queue(ctx->m2m_ctx, vbuf);
> +}
> +
> +static void imr_buf_finish(struct vb2_buffer *vb)
> +{
> +	struct vb2_v4l2_buffer	*vbuf = to_vb2_v4l2_buffer(vb);
> +	struct vb2_queue	*q = vb->vb2_queue;
> +	struct imr_ctx		*ctx = vb2_get_drv_priv(q);
> +
> +	WARN_ON(!mutex_is_locked(&ctx->imr->mutex));
> +
> +	/* any special processing of completed buffer? - TBD */
> +	v4l2_dbg(3, debug, &ctx->imr->v4l2_dev,
> +		 "%sput buffer <0x%08llx> done\n", q->is_output ? "in" : "out",
> +		 (u64)vb2_dma_contig_plane_dma_addr(vb, 0));
> +
> +	/* unref configuration pointer as needed */
> +	if (q->is_output)
> +		imr_cfg_unref(ctx, to_imr_buffer(vbuf)->cfg);
> +}
> +
> +static int imr_start_streaming(struct vb2_queue *vq, unsigned int count)
> +{
> +	struct imr_ctx *ctx = vb2_get_drv_priv(vq);
> +
> +	v4l2_dbg(1, debug, &ctx->imr->v4l2_dev, "%s streaming started\n",
> +		 V4L2_TYPE_IS_OUTPUT(vq->type) ? "output" : "capture");
> +	return 0;
> +}

Drop this function. Doesn't do anything.

> +
> +static void imr_stop_streaming(struct vb2_queue *vq)
> +{
> +	struct imr_ctx		*ctx = vb2_get_drv_priv(vq);
> +	unsigned long		flags;
> +	struct vb2_v4l2_buffer	*vb;
> +
> +	spin_lock_irqsave(&ctx->imr->lock, flags);
> +
> +	/* purge all buffers from a queue */
> +	if (V4L2_TYPE_IS_OUTPUT(vq->type)) {
> +		while ((vb = v4l2_m2m_src_buf_remove(ctx->m2m_ctx)) != NULL)
> +			v4l2_m2m_buf_done(vb, VB2_BUF_STATE_ERROR);
> +	} else {
> +		while ((vb = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx)) != NULL)
> +			v4l2_m2m_buf_done(vb, VB2_BUF_STATE_ERROR);
> +	}
> +
> +	spin_unlock_irqrestore(&ctx->imr->lock, flags);
> +
> +	v4l2_dbg(1, debug, &ctx->imr->v4l2_dev, "%s streaming stopped\n",
> +		 V4L2_TYPE_IS_OUTPUT(vq->type) ? "output" : "capture");
> +}
> +
> +/* buffer queue operations */
> +static struct vb2_ops imr_qops = {
> +	.queue_setup	= imr_queue_setup,
> +	.buf_prepare	= imr_buf_prepare,
> +	.buf_queue	= imr_buf_queue,
> +	.buf_finish	= imr_buf_finish,
> +	.start_streaming    = imr_start_streaming,
> +	.stop_streaming	= imr_stop_streaming,
> +	.wait_prepare	= vb2_ops_wait_prepare,
> +	.wait_finish	= vb2_ops_wait_finish,
> +};
> +
> +/* M2M device processing queue initialization */
> +static int imr_queue_init(void *priv, struct vb2_queue *src_vq,
> +			  struct vb2_queue *dst_vq)
> +{
> +	struct imr_ctx	*ctx = priv;
> +	int		ret;
> +
> +	memset(src_vq, 0, sizeof(*src_vq));
> +	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
> +	src_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
> +	src_vq->drv_priv = ctx;
> +	src_vq->buf_struct_size = sizeof(struct imr_buffer);
> +	src_vq->ops = &imr_qops;
> +	src_vq->mem_ops = &vb2_dma_contig_memops;
> +	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	src_vq->lock = &ctx->imr->mutex;

src_vq->dev should be set.

> +	ret = vb2_queue_init(src_vq);
> +	if (ret)
> +		return ret;
> +
> +	memset(dst_vq, 0, sizeof(*dst_vq));
> +	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	dst_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;

Drop VB2_USERPTR here and above. Not recommended to use this with dma-contig.

> +	dst_vq->drv_priv = ctx;
> +	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
> +	dst_vq->ops = &imr_qops;
> +	dst_vq->mem_ops = &vb2_dma_contig_memops;
> +	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	dst_vq->lock = &ctx->imr->mutex;

dst_vq->dev should be set.

> +	return vb2_queue_init(dst_vq);
> +}
> +
> +/*******************************************************************************
> + * Operation type decoding helpers
> + ******************************************************************************/
> +
> +static u16 __imr_auto_sg_dg_tcm(u32 type)
> +{
> +	return	(type & IMR_MAP_AUTOSG ? IMR_TRIMR_AUTOSG :
> +		(type & IMR_MAP_AUTODG ? IMR_TRIMR_AUTODG : 0)) |
> +		(type & IMR_MAP_TCM ? IMR_TRIMR_TCM : 0);
> +}
> +
> +static u16 __imr_uvdp(u32 type)
> +{
> +	return (__IMR_MAP_UVDPOR(type) << IMR_UVDPOR_UVDPO_SHIFT) |
> +	       (type & IMR_MAP_DDP ? IMR_UVDPOR_DDP : 0);
> +}
> +
> +static inline u16 __imr_cpdp(u32 type)
> +{
> +	return (__IMR_MAP_YLDPO(type) << IMR_CPDPOR_YLDPO_SHIFT) |
> +	       (__IMR_MAP_UBDPO(type) << IMR_CPDPOR_UBDPO_SHIFT) |
> +	       (__IMR_MAP_VRDPO(type) << IMR_CPDPOR_VRDPO_SHIFT);
> +}
> +
> +static u16 __imr_luce(u32 type)
> +{
> +	return type & IMR_MAP_LUCE ? IMR_CMRCR_LUCE : 0;
> +}
> +
> +static u16 __imr_clce(u32 type)
> +{
> +	return type & IMR_MAP_CLCE ? IMR_CMRCR_CLCE : 0;
> +}
> +
> +/*******************************************************************************
> + * Type A (absolute coordinates of source/destination) mapping
> + ******************************************************************************/
> +
> +/* return size of the subroutine for type A mapping */
> +static u32 imr_tri_type_a_get_length(struct imr_mesh *mesh, int item_size)
> +{
> +	return ((mesh->columns * (item_size / 2) + 1) * (mesh->rows - 1) + 1) *
> +		sizeof(u32);
> +}
> +
> +/* set a mesh rows * columns using absolute coordinates */
> +static u32 *imr_tri_set_type_a(u32 *dl, void *map, struct imr_mesh *mesh,
> +			       int item_size)
> +{
> +	int rows = mesh->rows;
> +	int columns = mesh->columns;
> +	u32 stride = item_size * columns;
> +	int i, j;
> +
> +	/* convert lattice into set of stripes */
> +	for (i = 0; i < rows - 1; i++) {
> +		*dl++ = IMR_OP_TRI(columns * 2);
> +		for (j = 0; j < columns; j++) {
> +			memcpy((void *)dl, map, item_size);
> +			memcpy((void *)dl + item_size, map + stride, item_size);
> +			dl += item_size / 2;
> +			map += item_size;
> +		}
> +	}
> +
> +	*dl++ = IMR_OP_RET;
> +	return dl;
> +}
> +
> +/*******************************************************************************
> + * Type B mapping (automatically generated source or destination coordinates)
> + ******************************************************************************/
> +
> +/* calculate length of a type B mapping */
> +static u32 imr_tri_type_b_get_length(struct imr_mesh *mesh, int item_size)
> +{
> +	return ((mesh->columns * (item_size / 2) + 2) * (mesh->rows - 1) + 4) *
> +		sizeof(u32);
> +}
> +
> +/* set an auto-generated mesh n * m for a source/destination */
> +static u32 *imr_tri_set_type_b(u32 *dl, void *map, struct imr_mesh *mesh,
> +			       int item_size)
> +{
> +	int rows = mesh->rows;
> +	int columns = mesh->columns;
> +	int stride = item_size * columns;
> +	int x0 = mesh->x0;
> +	int y0 = mesh->y0;
> +	int dx = mesh->dx;
> +	int dy = mesh->dy;
> +	int i, j;
> +
> +	/* set mesh configuration */
> +	*dl++ = IMR_OP_WTS(IMR_AMXSR, dx);
> +	*dl++ = IMR_OP_WTS(IMR_AMYSR, dy);
> +
> +	/* origin by X coordinate is the same across all rows */
> +	*dl++ = IMR_OP_WTS(IMR_AMXOR, x0);
> +
> +	/* convert lattice into set of stripes */
> +	for (i = 0; i < rows - 1; i++, y0 += dy) {
> +		/* set origin by Y coordinate for a current row */
> +		*dl++ = IMR_OP_WTS(IMR_AMYOR, y0);
> +		*dl++ = IMR_OP_TRI(2 * columns);
> +
> +		/* fill single row */
> +		for (j = 0; j < columns; j++) {
> +			memcpy((void *)dl, map, item_size);
> +			memcpy((void *)dl + item_size, map + stride, item_size);
> +			dl += item_size / 2;
> +			map += item_size;
> +		}
> +	}
> +
> +	*dl++ = IMR_OP_RET;
> +	return dl;
> +}
> +
> +/*******************************************************************************
> + * Type C mapping (vertex-buffer-object)
> + ******************************************************************************/
> +
> +/* calculate length of a type C mapping */
> +static u32 imr_tri_type_c_get_length(struct imr_vbo *vbo, int item_size)
> +{
> +	return ((4 + 3 * item_size) * vbo->num + 4);
> +}
> +
> +/* set a VBO mapping using absolute coordinates */
> +static u32 *imr_tri_set_type_c(u32 *dl, void *map, struct imr_vbo *vbo,
> +			       int item_size)
> +{
> +	int num = vbo->num;
> +	int i;
> +
> +	/* prepare list of triangles to draw */
> +	for (i = 0; i < num; i++) {
> +		*dl++ = IMR_OP_TRI(3);
> +		memcpy((void *)dl, map, 3 * item_size);
> +		dl += 3 * item_size / 4;
> +		map += 3 * item_size;
> +	}
> +
> +	*dl++ = IMR_OP_RET;
> +	return dl;
> +}
> +
> +/*******************************************************************************
> + * DL program creation
> + ******************************************************************************/
> +
> +/* return length of a DL main program */
> +static u32 imr_dl_program_length(struct imr_ctx *ctx)
> +{
> +	u32 iflags = ctx->queue[0].flags;
> +	u32 oflags = ctx->queue[1].flags;
> +	u32 cflags = __imr_flags_common(iflags, oflags);
> +
> +	/* check if formats are compatible */
> +	if (((iflags & IMR_F_PLANAR) && !(oflags & IMR_F_PLANAR)) || !cflags) {
> +		v4l2_err(&ctx->imr->v4l2_dev,
> +			 "formats are incompatible: if=%x, of=%x, cf=%x\n",
> +			 iflags, oflags, cflags);
> +		return 0;
> +	}
> +
> +	/*
> +	 * maximal possible length of the program is 27 32-bits words;
> +	 * round up to 32
> +	 */
> +	return 32 << 2;
> +}
> +
> +/* setup DL for Y/YUV planar/interleaved processing */
> +static void imr_dl_program_setup(struct imr_ctx *ctx, struct imr_cfg *cfg,
> +				 u32 type, u32 *dl, u32 subaddr)
> +{
> +	u32 iflags = ctx->queue[0].flags;
> +	u32 oflags = ctx->queue[1].flags;
> +	u32 cflags = __imr_flags_common(iflags, oflags);
> +	u16 src_y_fmt = (iflags & IMR_F_Y12 ? IMR_CMRCR_SY12 :
> +			 (iflags & IMR_F_Y10 ? IMR_CMRCR_SY10 : 0));
> +	u16 src_uv_fmt = (iflags & IMR_F_UV12 ? 2 :
> +			  (iflags & IMR_F_UV10 ? 1 : 0)) << IMR_CMRCR_SUV_SHIFT;
> +	u16 dst_y_fmt = (cflags & IMR_F_Y12 ? IMR_CMRCR_Y12 :
> +			 (cflags & IMR_F_Y10 ? IMR_CMRCR_Y10 : 0));
> +	u16 dst_uv_fmt = (cflags & IMR_F_UV12 ? 2 :
> +			  (cflags & IMR_F_UV10 ? 1 : 0)) << IMR_CMRCR_DUV_SHIFT;
> +	int w = ctx->queue[0].fmt.width;
> +	int h = ctx->queue[0].fmt.height;
> +	int W = ctx->queue[1].fmt.width;
> +	int H = ctx->queue[1].fmt.height;
> +
> +	v4l2_dbg(2, debug, &ctx->imr->v4l2_dev,
> +		 "setup %ux%u -> %ux%u mapping (type=%x)\n", w, h, W, H, type);
> +
> +	/* set triangle mode register from user-supplied descriptor */
> +	*dl++ = IMR_OP_WTS(IMR_TRIMCR, 0x004F);
> +
> +	/* set automatic source/destination coordinates generation flags */
> +	*dl++ = IMR_OP_WTS(IMR_TRIMSR, __imr_auto_sg_dg_tcm(type) |
> +			   IMR_TRIMR_BFE | IMR_TRIMR_TME);
> +
> +	/* set source/destination coordinate precision */
> +	*dl++ = IMR_OP_WTS(IMR_UVDPOR, __imr_uvdp(type));
> +
> +	/* set luminance/chromacity correction parameters precision */
> +	*dl++ = IMR_OP_WTS(IMR_CPDPOR, __imr_cpdp(type));
> +
> +	/* reset rendering mode registers */
> +	*dl++ = IMR_OP_WTS(IMR_CMRCCR,  0xDBFE);
> +	*dl++ = IMR_OP_WTS(IMR_CMRCCR2, 0x9065);
> +
> +	/* set source/destination addresses of Y/UV plane */
> +	*dl++ = IMR_OP_WTL(IMR_DSAR, 2);
> +	cfg->dst_pa_ptr[0] = dl++;
> +	cfg->src_pa_ptr[0] = dl++;
> +
> +	/* select planar/interleaved mode basing on input format */
> +	if (iflags & IMR_F_PLANAR) {
> +		/* planar input means planar output; set Y plane precision */
> +		if (cflags & IMR_F_Y8) {
> +			/*
> +			 * setup Y plane processing: YCM=0, SY/DY=xx,
> +			 * SUV/DUV=0
> +			 */
> +			*dl++ = IMR_OP_WTS(IMR_CMRCSR, src_y_fmt | src_uv_fmt |
> +					   dst_y_fmt | dst_uv_fmt |
> +					   __imr_luce(type));
> +
> +			/*
> +			 * set source/destination strides basing on Y plane
> +			 * precision
> +			 */
> +			*dl++ = IMR_OP_WTS(IMR_DSTR,
> +					   W << (cflags & IMR_F_Y10 ? 1 : 0));
> +			*dl++ = IMR_OP_WTS(IMR_SSTR,
> +					   w << (iflags & IMR_F_Y10 ? 1 : 0));
> +		} else {
> +			/* setup UV plane processing only */
> +			*dl++ = IMR_OP_WTS(IMR_CMRCSR, IMR_CMRCR_YCM |
> +					   src_uv_fmt | dst_uv_fmt |
> +					   __imr_clce(type));
> +
> +			/*
> +			 * set source/destination strides basing on UV plane
> +			 * precision
> +			 */
> +			*dl++ = IMR_OP_WTS(IMR_DSTR,
> +					   W << (cflags & IMR_F_UV10 ? 1 : 0));
> +			*dl++ = IMR_OP_WTS(IMR_SSTR,
> +					   w << (iflags & IMR_F_UV10 ? 1 : 0));
> +		}
> +	} else {
> +		u16 src_fmt = (iflags & IMR_F_UV_SWAP ? IMR_CMRCR2_UVFORM : 0) |
> +			      (iflags & IMR_F_YUV_SWAP ?
> +			       IMR_CMRCR2_YUV422FORM : 0);
> +		u32 dst_fmt = (oflags & IMR_F_YUV_SWAP ? IMR_TRICR_YCFORM : 0);
> +
> +		/* interleaved input; output is either interleaved or planar */
> +		*dl++ = IMR_OP_WTS(IMR_CMRCSR2, IMR_CMRCR2_YUV422E | src_fmt);
> +
> +		/* destination is always YUYV or UYVY */
> +		*dl++ = IMR_OP_WTL(IMR_TRICR, 1);
> +		*dl++ = dst_fmt;
> +
> +		/* set precision of Y/UV planes and required correction */
> +		*dl++ = IMR_OP_WTS(IMR_CMRCSR, src_y_fmt | src_uv_fmt |
> +				   dst_y_fmt | dst_uv_fmt | __imr_clce(type) |
> +				   __imr_luce(type));
> +
> +		/* set source stride basing on precision (2 or 4 bytes/pixel) */
> +		*dl++ = IMR_OP_WTS(IMR_SSTR, w << (iflags & IMR_F_Y10 ? 2 : 1));
> +
> +		/* if output is planar, put the offset value */
> +		if (oflags & IMR_F_PLANAR) {
> +			/* specify offset of a destination UV plane */
> +			*dl++ = IMR_OP_WTL(IMR_DSOR, 1);
> +			*dl++ = W * H;
> +
> +			/*
> +			 * destination stride is 1 or 2 bytes/pixel
> +			 * (same for both Y and UV planes)
> +			 */
> +			*dl++ = IMR_OP_WTS(IMR_DSTR,
> +					   W << (cflags & IMR_F_Y10 ? 1 : 0));
> +		} else {
> +			/*
> +			 * destination stride if 2 or 4 bytes/pixel
> +			 * (Y and UV planes interleaved)
> +			 */
> +			*dl++ = IMR_OP_WTS(IMR_DSTR,
> +					   W << (cflags & IMR_F_Y10 ? 2 : 1));
> +		}
> +	}
> +
> +	/*
> +	 * set source width/height of Y/UV plane
> +	 * (for Y plane upper part of SUSR is ignored)
> +	 */
> +	*dl++ = IMR_OP_WTL(IMR_SUSR, 2);
> +	*dl++ = ((w - 2) << IMR_SUSR_SUW_SHIFT) |
> +		((w - 1) << IMR_SUSR_SVW_SHIFT);
> +	*dl++ = h - 1;
> +
> +	/* invoke subroutine for drawing triangles */
> +	*dl++ = IMR_OP_GOSUB;
> +	*dl++ = subaddr;
> +
> +	/* if we have a planar output with both Y and UV planes available */
> +	if ((cflags & (IMR_F_PLANAR | IMR_F_Y8 | IMR_F_UV8)) ==
> +	    (IMR_F_PLANAR | IMR_F_Y8 | IMR_F_UV8)) {
> +		/* select UV plane processing mode; put sync before switching */
> +		*dl++ = IMR_OP_SYNCM;
> +
> +		/* setup UV-plane source/destination addresses */
> +		*dl++ = IMR_OP_WTL(IMR_DSAR, 2);
> +		cfg->dst_pa_ptr[1] = dl++;
> +		cfg->src_pa_ptr[1] = dl++;
> +
> +		/* select correction mode */
> +		*dl++ = IMR_OP_WTS(IMR_CMRCSR, IMR_CMRCR_YCM |
> +				   __imr_clce(type));
> +
> +		/* luminance correction bit must be cleared (if it was set) */
> +		*dl++ = IMR_OP_WTS(IMR_CMRCCR, IMR_CMRCR_LUCE);
> +
> +		/* draw triangles */
> +		*dl++ = IMR_OP_GOSUB;
> +		*dl++ = subaddr;
> +	} else {
> +		/*
> +		 * clear pointers to the source/destination UV-planes addresses
> +		 */
> +		cfg->src_pa_ptr[1] = cfg->dst_pa_ptr[1] = NULL;
> +	}
> +
> +	/* signal completion of the operation */
> +	*dl++ = IMR_OP_SYNCM;
> +	*dl++ = IMR_OP_TRAP;
> +}
> +
> +/*******************************************************************************
> + * Mapping specification processing
> + ******************************************************************************/
> +
> +/* set mapping data (function called with video device lock held) */
> +static int imr_ioctl_map(struct imr_ctx *ctx, struct imr_map_desc *desc)
> +{
> +	struct imr_device	*imr = ctx->imr;
> +	struct imr_mesh		*mesh;
> +	struct imr_vbo		*vbo;
> +	struct imr_cfg		*cfg;
> +	void			*buf, *map;
> +	u32                     type;
> +	u32			length, item_size;
> +	u32			tri_length;
> +	void			*dl_vaddr;
> +	u32			dl_size;
> +	u32			dl_start_offset;
> +	dma_addr_t		dl_dma_addr;
> +	int			ret = 0;
> +
> +	/* read remainder of data into temporary buffer */
> +	length = desc->size;
> +	buf = kmalloc(length, GFP_KERNEL);
> +	if (!buf)
> +		return -ENOMEM;
> +
> +	/* copy mesh data */
> +	if (copy_from_user(buf, (void __user *)desc->data, length)) {
> +		v4l2_err(&imr->v4l2_dev,
> +			 "failed to read %u bytes of mapping specification\n",
> +			 length);
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +	type = desc->type;
> +
> +	/* mesh item size calculation */
> +	item_size = (type & IMR_MAP_LUCE ? 4 : 0) +
> +		    (type & IMR_MAP_CLCE ? 4 : 0);
> +
> +	/* calculate the length of a display list */
> +	if (type & IMR_MAP_MESH) {
> +		/* assure we have proper mesh descriptor */
> +		if (length < sizeof(struct imr_mesh)) {
> +			v4l2_err(&imr->v4l2_dev,
> +				 "invalid mesh specification size: %u\n",
> +				 length);
> +			ret = -EINVAL;
> +			goto out;
> +		}
> +
> +		mesh = (struct imr_mesh *)buf;
> +		length -= sizeof(struct imr_mesh);
> +		map = buf + sizeof(struct imr_mesh);
> +
> +		if (type & (IMR_MAP_AUTODG | IMR_MAP_AUTOSG)) {
> +			/* source/destination vertex size is 4 bytes */
> +			item_size += 4;
> +
> +			/*
> +			 * mapping is given using automatic generation pattern;
> +			 * check size
> +			 */
> +			if (mesh->rows * mesh->columns * item_size != length) {
> +				v4l2_err(&imr->v4l2_dev,
> +					 "invalid mesh size: %u*%u*%u != %u\n",
> +					 mesh->rows, mesh->columns, item_size,
> +					 length);
> +				ret = -EINVAL;
> +				goto out;
> +			}
> +
> +			/* calculate size of triangles drawing subroutine */
> +			tri_length = imr_tri_type_b_get_length(mesh, item_size);
> +		} else {
> +			/* source/destination vertex size is 8 bytes */
> +			item_size += 8;
> +
> +			/* mapping is done with absolute coordinates */
> +			if (mesh->rows * mesh->columns * item_size != length) {
> +				v4l2_err(&imr->v4l2_dev,
> +					 "invalid mesh size: %u*%u*%u != %u\n",
> +					 mesh->rows, mesh->columns, item_size,
> +					 length);
> +				ret = -EINVAL;
> +				goto out;
> +			}
> +
> +			/* calculate size of triangles drawing subroutine */
> +			tri_length = imr_tri_type_a_get_length(mesh, item_size);
> +		}
> +	} else {
> +		/* assure we have proper VBO descriptor */
> +		if (length < sizeof(struct imr_vbo)) {
> +			v4l2_err(&imr->v4l2_dev,
> +				 "invalid vbo specification size: %u\n",
> +				 length);
> +			ret = -EINVAL;
> +			goto out;
> +		}
> +
> +		/* make sure there is no automatically generation flags */
> +		if (type & (IMR_MAP_AUTODG | IMR_MAP_AUTOSG)) {
> +			v4l2_err(&imr->v4l2_dev,
> +				 "invalid auto-dg/sg flags: 0x%x\n", type);
> +			ret = -EINVAL;
> +			goto out;
> +		}
> +
> +		vbo = (struct imr_vbo *)buf;
> +		length -= sizeof(struct imr_vbo);
> +		map = buf + sizeof(struct imr_vbo);
> +
> +		/* vertex is given with absolute coordinates */
> +		item_size += 8;
> +
> +		/* check that the length is sane */
> +		if (length != vbo->num * 3 * item_size) {
> +			v4l2_err(&imr->v4l2_dev,
> +				 "invalid vbo size: %u*%u*3 != %u\n", vbo->num,
> +				 item_size, length);
> +			ret = -EINVAL;
> +			goto out;
> +		}
> +
> +		/* calculate size of triangles drawing subroutine */
> +		tri_length = imr_tri_type_c_get_length(vbo, item_size);
> +	}
> +
> +	/* DL main program shall start on 8-byte aligned address */
> +	dl_start_offset = ALIGN(tri_length, 8);
> +
> +	/* calculate main routine length */
> +	dl_size = imr_dl_program_length(ctx);
> +	if (!dl_size) {
> +		v4l2_err(&imr->v4l2_dev, "format configuration error\n");
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	/* we use a single display list, with TRI subroutine prepending MAIN */
> +	dl_size += dl_start_offset;
> +
> +	/* unref current configuration (will not be used by subsequent jobs) */
> +	imr_cfg_unref(ctx, ctx->cfg);
> +
> +	/* create new configuration */
> +	ctx->cfg = cfg = imr_cfg_create(ctx, dl_size, dl_start_offset);
> +	if (IS_ERR(cfg)) {
> +		ret = PTR_ERR(cfg);
> +		v4l2_err(&imr->v4l2_dev,
> +			 "failed to create configuration: %d\n", ret);
> +		goto out;
> +	}
> +
> +	/* get pointer to the new display list */
> +	dl_vaddr = cfg->dl_vaddr;
> +	dl_dma_addr = cfg->dl_dma_addr;
> +
> +	/* prepare a triangles drawing subroutine */
> +	if (type & IMR_MAP_MESH) {
> +		if (type & (IMR_MAP_AUTOSG | IMR_MAP_AUTODG))
> +			imr_tri_set_type_b(dl_vaddr, map, mesh, item_size);
> +		else
> +			imr_tri_set_type_a(dl_vaddr, map, mesh, item_size);
> +	} else {
> +		imr_tri_set_type_c(dl_vaddr, map, vbo, item_size);
> +	}
> +
> +	/* prepare main DL program */
> +	imr_dl_program_setup(ctx, cfg, type, dl_vaddr + dl_start_offset,
> +			     (u32)dl_dma_addr);
> +
> +	/* update cropping parameters */
> +	cfg->dst_subpixel = (type & IMR_MAP_DDP ? 2 : 0);
> +
> +	/* display list updated successfully */
> +	v4l2_dbg(2, debug, &ctx->imr->v4l2_dev,
> +		 "display-list created: #%u[%08X]:%u[%u]\n",
> +		 cfg->id, (u32)dl_dma_addr, dl_size, dl_start_offset);
> +
> +	if (debug >= 4)
> +		print_hex_dump_bytes("DL-", DUMP_PREFIX_OFFSET,
> +				     dl_vaddr + dl_start_offset,
> +				     dl_size  - dl_start_offset);
> +
> +out:
> +	/* release interim buffer */
> +	kfree(buf);
> +
> +	return ret;
> +}
> +
> +/*******************************************************************************
> + * V4L2 I/O controls
> + ******************************************************************************/
> +
> +/* test if a format is supported */
> +static int __imr_try_fmt(struct imr_ctx *ctx, struct v4l2_format *f)
> +{
> +	struct v4l2_pix_format	*pix = &f->fmt.pix;
> +	u32			fourcc = pix->pixelformat;
> +	int			i;
> +
> +	/*
> +	 * both output and capture interface have the same set of
> +	 * supported formats
> +	 */
> +	for (i = 0; i < ARRAY_SIZE(imr_lx4_formats); i++) {
> +		if (fourcc == imr_lx4_formats[i].fourcc) {
> +			/* fix up format specification as needed */
> +			pix->field = V4L2_FIELD_NONE;
> +
> +			v4l2_dbg(1, debug, &ctx->imr->v4l2_dev,
> +				 "format request: '%c%c%c%c', %dx%d\n",
> +				 (fourcc >> 0)	& 0xff,	(fourcc >> 8)  & 0xff,
> +				 (fourcc >> 16) & 0xff, (fourcc >> 24) & 0xff,
> +				 pix->width, pix->height);
> +
> +			/* verify source/destination image dimensions */
> +			if (V4L2_TYPE_IS_OUTPUT(f->type))
> +				v4l_bound_align_image(&pix->width, 128, 2048, 7,
> +						      &pix->height, 16, 2048, 1,
> +						      0);
> +			else
> +				v4l_bound_align_image(&pix->width,  64, 2048, 6,
> +						      &pix->height, 16, 2048, 1,
> +						      0);
> +
> +			return i;
> +		}
> +	}
> +
> +	v4l2_err(&ctx->imr->v4l2_dev,
> +		 "unsupported format request: '%c%c%c%c'\n",
> +		 (fourcc >> 0)  & 0xff, (fourcc >> 8)  & 0xff,
> +		 (fourcc >> 16) & 0xff, (fourcc >> 24) & 0xff);
> +
> +	return -EINVAL;
> +}
> +
> +/* capabilities query */
> +static int imr_querycap(struct file *file, void *priv,
> +			struct v4l2_capability *cap)
> +{
> +	strlcpy(cap->driver, DRV_NAME, sizeof(cap->driver));
> +	strlcpy(cap->card, DRV_NAME, sizeof(cap->card));
> +	strlcpy(cap->bus_info, DRV_NAME, sizeof(cap->bus_info));
> +
> +	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT |
> +		V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING;
> +
> +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;

Set device_caps in struct video_device, and you can drop these last two
assignments. Setting them here is deprecated.

> +
> +	return 0;
> +}
> +
> +/* enumerate supported formats */
> +static int imr_enum_fmt(struct file *file, void *priv, struct v4l2_fmtdesc *f)
> +{
> +	/* no distinction between output/capture formats */
> +	if (f->index < ARRAY_SIZE(imr_lx4_formats)) {
> +		const struct imr_format_info *fmt = &imr_lx4_formats[f->index];
> +
> +		strlcpy(f->description, fmt->name, sizeof(f->description));

Don't fill this in. It's done for you in v4l2-ioctl.c.

> +		f->pixelformat = fmt->fourcc;
> +		return 0;
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +/* retrieve current queue format; operation is locked? */
> +static int imr_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
> +{
> +	struct imr_ctx		*ctx = fh_to_ctx(priv);
> +	struct imr_q_data	*q_data;
> +	struct vb2_queue	*vq;
> +
> +	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
> +	if (!vq)
> +		return -EINVAL;
> +
> +	q_data = &ctx->queue[V4L2_TYPE_IS_OUTPUT(f->type) ? 0 : 1];
> +
> +	/* processing is locked? TBD */
> +	f->fmt.pix = q_data->fmt;
> +
> +	return 0;
> +}
> +
> +/* test particular format; operation is not locked */
> +static int imr_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
> +{
> +	struct imr_ctx		*ctx = fh_to_ctx(priv);
> +	struct vb2_queue	*vq;
> +
> +	/* make sure we have a queue of particular type */
> +	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
> +	if (!vq)
> +		return -EINVAL;
> +
> +	/* test if format is supported (adjust as appropriate) */
> +	return __imr_try_fmt(ctx, f) >= 0 ? 0 : -EINVAL;
> +}
> +
> +/* apply queue format; operation is locked? */
> +static int imr_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
> +{
> +	struct imr_ctx		*ctx = fh_to_ctx(priv);
> +	struct imr_q_data	*q_data;
> +	struct vb2_queue	*vq;
> +	int			i;
> +
> +	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
> +	if (!vq)
> +		return -EINVAL;
> +
> +	/* check if queue is busy */
> +	if (vb2_is_busy(vq))
> +		return -EBUSY;
> +
> +	/* test if format is supported (adjust as appropriate) */
> +	i = __imr_try_fmt(ctx, f);
> +	if (i < 0)
> +		return -EINVAL;
> +
> +	/* format is supported; save current format in a queue-specific data */
> +	q_data = &ctx->queue[V4L2_TYPE_IS_OUTPUT(f->type) ? 0 : 1];
> +
> +	/* processing is locked? TBD */
> +	q_data->fmt = f->fmt.pix;
> +	q_data->flags = imr_lx4_formats[i].flags;
> +
> +	/* set default crop factors */
> +	if (!V4L2_TYPE_IS_OUTPUT(f->type)) {
> +		ctx->crop[0] = 0;
> +		ctx->crop[1] = f->fmt.pix.width - 1;
> +		ctx->crop[2] = 0;
> +		ctx->crop[3] = f->fmt.pix.height - 1;
> +	}

I'm pretty sure v4l2-compliance will complain about missing colorspace fields.
drivers/media/platform/vim2m.c gives a good idea how to handle this for m2m
devices.

> +
> +	return 0;
> +}
> +
> +static int imr_reqbufs(struct file *file, void *priv,
> +		       struct v4l2_requestbuffers *reqbufs)
> +{
> +	struct imr_ctx *ctx = fh_to_ctx(priv);
> +
> +	return v4l2_m2m_reqbufs(file, ctx->m2m_ctx, reqbufs);
> +}
> +
> +static int imr_querybuf(struct file *file, void *priv, struct v4l2_buffer *buf)
> +{
> +	struct imr_ctx *ctx = fh_to_ctx(priv);
> +
> +	return v4l2_m2m_querybuf(file, ctx->m2m_ctx, buf);
> +}

There are helper functions defined in v4l2-mem2mem.c that take care of this.
I recommend that you use those instead.

> +
> +static int imr_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
> +{
> +	struct imr_ctx *ctx = fh_to_ctx(priv);
> +
> +	/* operation is protected with a queue lock */
> +	WARN_ON(!mutex_is_locked(&ctx->imr->mutex));
> +
> +	/* verify the configuration is complete */
> +	if (!V4L2_TYPE_IS_OUTPUT(buf->type) && !ctx->cfg) {
> +		v4l2_err(&ctx->imr->v4l2_dev,
> +			 "stream configuration is not complete\n");
> +		return -EINVAL;
> +	}
> +
> +	return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
> +}
> +
> +static int imr_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
> +{
> +	struct imr_ctx *ctx = fh_to_ctx(priv);
> +
> +	return v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
> +}
> +
> +static int imr_expbuf(struct file *file, void *priv,
> +		      struct v4l2_exportbuffer *eb)
> +{
> +	struct imr_ctx *ctx = fh_to_ctx(priv);
> +
> +	return v4l2_m2m_expbuf(file, ctx->m2m_ctx, eb);
> +}
> +
> +static int imr_streamon(struct file *file, void *priv, enum v4l2_buf_type type)
> +{
> +	struct imr_ctx *ctx = fh_to_ctx(priv);
> +
> +	/* context is prepared for a streaming */
> +	return v4l2_m2m_streamon(file, ctx->m2m_ctx, type);
> +}
> +
> +static int imr_streamoff(struct file *file, void *priv, enum v4l2_buf_type type)
> +{
> +	struct imr_ctx *ctx = fh_to_ctx(priv);
> +
> +	return v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
> +}
> +
> +static int imr_g_crop(struct file *file, void *priv, struct v4l2_crop *cr)
> +{
> +	struct imr_ctx  *ctx = fh_to_ctx(priv);
> +
> +	/* subpixel resolution of output buffer is not counted here */
> +	cr->c.left = ctx->crop[0];
> +	cr->c.top  = ctx->crop[2];
> +	cr->c.width  = ctx->crop[1] - ctx->crop[0];
> +	cr->c.height = ctx->crop[3] - ctx->crop[2];
> +
> +	return 0;
> +}
> +
> +static int imr_s_crop(struct file *file, void *priv, const struct v4l2_crop *cr)
> +{
> +	struct imr_ctx	*ctx = fh_to_ctx(priv);
> +	int		x0 = cr->c.left;
> +	int		y0 = cr->c.top;
> +	int		x1 = x0 + cr->c.width;
> +	int		y1 = y0 + cr->c.height;
> +
> +	if (x0 < 0 || x1 >= 2048 || y0 < 0 || y1 >= 2048) {
> +		v4l2_err(&ctx->imr->v4l2_dev, "invalid cropping: %d/%d/%d/%d\n",
> +			 x0, x1, y0, y1);
> +		return -EINVAL;
> +	}
> +
> +	/* subpixel resolution of output buffer is not counted here */
> +	ctx->crop[0] = x0;
> +	ctx->crop[1] = x1;
> +	ctx->crop[2] = y0;
> +	ctx->crop[3] = y1;
> +
> +	return 0;
> +}
> +
> +/* customized I/O control processing */
> +static long imr_default(struct file *file, void *fh, bool valid_prio,
> +			unsigned int cmd,  void *arg)
> +{
> +	struct imr_ctx *ctx = fh_to_ctx(fh);
> +
> +	switch (cmd) {
> +	case VIDIOC_IMR_MESH:
> +		/* set mesh data */
> +		return imr_ioctl_map(ctx, arg);
> +
> +	default:
> +		return -ENOTTY;
> +	}
> +}
> +
> +static const struct v4l2_ioctl_ops imr_ioctl_ops = {
> +	.vidioc_querycap		= imr_querycap,
> +
> +	.vidioc_enum_fmt_vid_cap	= imr_enum_fmt,
> +	.vidioc_enum_fmt_vid_out	= imr_enum_fmt,
> +	.vidioc_g_fmt_vid_cap		= imr_g_fmt,
> +	.vidioc_g_fmt_vid_out		= imr_g_fmt,
> +	.vidioc_try_fmt_vid_cap		= imr_try_fmt,
> +	.vidioc_try_fmt_vid_out		= imr_try_fmt,
> +	.vidioc_s_fmt_vid_cap		= imr_s_fmt,
> +	.vidioc_s_fmt_vid_out		= imr_s_fmt,
> +
> +	.vidioc_reqbufs			= imr_reqbufs,
> +	.vidioc_querybuf		= imr_querybuf,
> +	.vidioc_qbuf			= imr_qbuf,
> +	.vidioc_dqbuf			= imr_dqbuf,
> +	.vidioc_expbuf			= imr_expbuf,
> +	.vidioc_streamon		= imr_streamon,
> +	.vidioc_streamoff		= imr_streamoff,

I recommend adding vidioc_createbufs as well. Easiest is to just use the helper
function (v4l2_m2m_ioctl_create_bufs). Ditto for vidioc_prepare_buf.

> +
> +	.vidioc_g_crop			= imr_g_crop,
> +	.vidioc_s_crop			= imr_s_crop,

Don't use this. Use g/s_selection instead. g/s_crop is not allowed anymore in
new drivers. The selection API is a lot more flexible.

> +
> +	.vidioc_default			= imr_default,
> +};
> +
> +/*******************************************************************************
> + * Generic device file operations
> + ******************************************************************************/
> +
> +static int imr_open(struct file *file)
> +{
> +	struct imr_device	*imr = video_drvdata(file);
> +	struct video_device	*vfd = video_devdata(file);
> +	struct imr_ctx		*ctx;
> +	int			ret;
> +
> +	/* allocate processing context associated with given instance */
> +	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
> +	if (!ctx)
> +		return -ENOMEM;
> +
> +	/* initialize per-file-handle structure */
> +	v4l2_fh_init(&ctx->fh, vfd);
> +	file->private_data = &ctx->fh;
> +	v4l2_fh_add(&ctx->fh);
> +
> +	/* set default source/destination formats - need that? */
> +	ctx->imr = imr;
> +	ctx->queue[0].fmt.pixelformat = 0;
> +	ctx->queue[1].fmt.pixelformat = 0;

This doesn't look right. You always have to start with an initial default
pixelformat. You can't return a pixelformat of 0 in VIDIOC_G_FMT.

> +
> +	/* set default cropping parameters */
> +	ctx->crop[1] = ctx->crop[3] = 0x3FF;
> +
> +	/* initialize M2M processing context */
> +	ctx->m2m_ctx = v4l2_m2m_ctx_init(imr->m2m_dev, ctx, imr_queue_init);
> +	if (IS_ERR(ctx->m2m_ctx)) {
> +		ret = PTR_ERR(ctx->m2m_ctx);
> +		goto v4l_prepare_rollback;
> +	}
> +
> +	/* lock access to global device data */
> +	if (mutex_lock_interruptible(&imr->mutex)) {
> +		ret = -ERESTARTSYS;
> +		goto v4l_prepare_rollback;
> +	}
> +
> +	/* bring up device as needed */
> +	if (imr->refcount == 0) {
> +		ret = clk_prepare_enable(imr->clock);
> +		if (ret < 0)
> +			goto device_prepare_rollback;
> +	}
> +
> +	imr->refcount++;
> +
> +	mutex_unlock(&imr->mutex);
> +
> +	v4l2_dbg(1, debug, &imr->v4l2_dev, "IMR device opened (refcount=%u)\n",
> +		 imr->refcount);
> +
> +	return 0;
> +
> +device_prepare_rollback:
> +	/* unlock global device data */
> +	mutex_unlock(&imr->mutex);
> +
> +v4l_prepare_rollback:
> +	/* destroy context */
> +	v4l2_fh_del(&ctx->fh);
> +	v4l2_fh_exit(&ctx->fh);
> +	kfree(ctx);
> +
> +	return ret;
> +}
> +
> +static int imr_release(struct file *file)
> +{
> +	struct imr_ctx		*ctx = fh_to_ctx(file->private_data);
> +	struct imr_device	*imr = video_drvdata(file);
> +
> +	/* I don't need to get a device scope lock here really - TBD */
> +	mutex_lock(&imr->mutex);
> +
> +	/* destroy M2M device processing context */
> +	v4l2_m2m_ctx_release(ctx->m2m_ctx);
> +	v4l2_fh_del(&ctx->fh);
> +	v4l2_fh_exit(&ctx->fh);
> +
> +	/* drop active configuration as needed */
> +	imr_cfg_unref(ctx, ctx->cfg);
> +
> +	/* make sure there are no more active configs */
> +	WARN_ON(ctx->cfg_num);
> +
> +	/* destroy context data */
> +	kfree(ctx);
> +
> +	/* disable hardware operation */
> +	if (--imr->refcount == 0)
> +		clk_disable_unprepare(imr->clock);
> +
> +	mutex_unlock(&imr->mutex);
> +
> +	v4l2_dbg(1, debug, &imr->v4l2_dev, "closed device instance\n");
> +
> +	return 0;
> +}
> +
> +static unsigned int imr_poll(struct file *file, struct poll_table_struct *wait)
> +{
> +	struct imr_ctx		*ctx = fh_to_ctx(file->private_data);
> +	struct imr_device	*imr = video_drvdata(file);
> +	unsigned int		res;
> +
> +	if (mutex_lock_interruptible(&imr->mutex))
> +		return -ERESTARTSYS;
> +
> +	res = v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
> +	mutex_unlock(&imr->mutex);
> +
> +	return res;
> +}
> +
> +static int imr_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	struct imr_device	*imr = video_drvdata(file);
> +	struct imr_ctx		*ctx = fh_to_ctx(file->private_data);
> +	int			ret;
> +
> +	/* should we protect all M2M operations with mutex? - TBD */
> +	if (mutex_lock_interruptible(&imr->mutex))
> +		return -ERESTARTSYS;
> +
> +	ret = v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
> +
> +	mutex_unlock(&imr->mutex);
> +
> +	return ret;
> +}
> +
> +static const struct v4l2_file_operations imr_fops = {
> +	.owner		= THIS_MODULE,
> +	.open		= imr_open,
> +	.release	= imr_release,
> +	.poll		= imr_poll,
> +	.mmap		= imr_mmap,
> +	.unlocked_ioctl	= video_ioctl2,
> +};
> +
> +/*******************************************************************************
> + * M2M device interface
> + ******************************************************************************/
> +
> +/* job execution function */
> +static void imr_device_run(void *priv)
> +{
> +	struct imr_ctx		*ctx = priv;
> +	struct imr_device	*imr = ctx->imr;
> +	struct vb2_buffer	*src_buf, *dst_buf;
> +	u32			src_addr,  dst_addr;
> +	unsigned long		flags;
> +	struct imr_cfg		*cfg;
> +
> +	v4l2_dbg(3, debug, &imr->v4l2_dev, "run next job...\n");
> +
> +	/* protect access to internal device state */
> +	spin_lock_irqsave(&imr->lock, flags);
> +
> +	/* retrieve input/output buffers */
> +	src_buf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
> +	dst_buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
> +
> +	/* take configuration pointer associated with input buffer */
> +	cfg = to_imr_buffer(to_vb2_v4l2_buffer(src_buf))->cfg;
> +
> +	/* cancel software reset state as needed */
> +	iowrite32(0, imr->mmio + IMR_CR);
> +
> +	/* set cropping data with respect to destination subpixel mode */
> +	iowrite32(ctx->crop[0] << cfg->dst_subpixel, imr->mmio + IMR_XMINR);
> +	iowrite32(ctx->crop[1] << cfg->dst_subpixel, imr->mmio + IMR_XMAXR);
> +	iowrite32(ctx->crop[2] << cfg->dst_subpixel, imr->mmio + IMR_YMINR);
> +	iowrite32(ctx->crop[3] << cfg->dst_subpixel, imr->mmio + IMR_YMAXR);
> +
> +	/*
> +	 * adjust source/destination parameters of the program
> +	 * (interleaved/semiplanar)
> +	 */
> +	*cfg->src_pa_ptr[0] = src_addr =
> +		(u32)vb2_dma_contig_plane_dma_addr(src_buf, 0);
> +	*cfg->dst_pa_ptr[0] = dst_addr =
> +		(u32)vb2_dma_contig_plane_dma_addr(dst_buf, 0);
> +
> +	/* adjust source/destination parameters of the UV plane as needed */
> +	if (cfg->src_pa_ptr[1] && cfg->dst_pa_ptr[1]) {
> +		*cfg->src_pa_ptr[1] = src_addr +
> +			ctx->queue[0].fmt.width * ctx->queue[0].fmt.height;
> +		*cfg->dst_pa_ptr[1] = dst_addr +
> +			ctx->queue[1].fmt.width * ctx->queue[1].fmt.height;
> +	}
> +
> +	v4l2_dbg(3, debug, &imr->v4l2_dev,
> +		 "process buffer-pair 0x%08x:0x%08x\n",
> +		 *cfg->src_pa_ptr[0], *cfg->dst_pa_ptr[0]);
> +
> +	/* force clearing of the status register bits */
> +	iowrite32(IMR_SR_TRA | IMR_SR_IER | IMR_SR_INT, imr->mmio + IMR_SRCR);
> +
> +	/* unmask/enable interrupts */
> +	iowrite32(ioread32(imr->mmio + IMR_ICR) |
> +		  (IMR_ICR_TRAENB | IMR_ICR_IERENB | IMR_ICR_INTENB),
> +		  imr->mmio + IMR_ICR);
> +	iowrite32(ioread32(imr->mmio + IMR_IMR) &
> +		  ~(IMR_IMR_TRAM | IMR_IMR_IEM | IMR_IMR_INM),
> +		  imr->mmio + IMR_IMR);
> +
> +	/* set display list address */
> +	iowrite32(cfg->dl_dma_addr + cfg->dl_start_offset,
> +		  imr->mmio + IMR_DLSAR);
> +
> +	/*
> +	 * explicitly flush any pending write operations
> +	 * (don't need that, I guess)
> +	 */
> +	wmb();
> +
> +	/* start rendering operation */
> +	iowrite32(IMR_CR_RS, imr->mmio + IMR_CR);
> +
> +	/* timestamp input buffer */
> +	src_buf->timestamp = ktime_get_ns();
> +
> +	/* unlock device access */
> +	spin_unlock_irqrestore(&imr->lock, flags);
> +
> +	v4l2_dbg(1, debug, &imr->v4l2_dev,
> +		 "rendering started: status=%x, DLSAR=0x%08x, DLPR=0x%08x\n",
> +		 ioread32(imr->mmio + IMR_SR), ioread32(imr->mmio + IMR_DLSAR),
> +		 ioread32(imr->mmio + IMR_DLPR));
> +}
> +
> +/* check whether a job is ready for execution */
> +static int imr_job_ready(void *priv)
> +{
> +	/* no specific requirements on the job readiness */
> +	return 1;
> +}
> +
> +/* abort currently processed job */
> +static void imr_job_abort(void *priv)
> +{
> +	struct imr_ctx		*ctx = priv;
> +	struct imr_device	*imr = ctx->imr;
> +	unsigned long		flags;
> +
> +	/* protect access to internal device state */
> +	spin_lock_irqsave(&imr->lock, flags);
> +
> +	/*
> +	 * make sure current job is still current
> +	 * (may get finished by interrupt already)
> +	 */
> +	if (v4l2_m2m_get_curr_priv(imr->m2m_dev) == ctx) {
> +		v4l2_dbg(1, debug, &imr->v4l2_dev,
> +			 "abort job: status=%x, DLSAR=0x%08x, DLPR=0x%08x\n",
> +			 ioread32(imr->mmio + IMR_SR),
> +			 ioread32(imr->mmio + IMR_DLSAR),
> +			 ioread32(imr->mmio + IMR_DLPR));
> +
> +		/*
> +		 * resetting the module while operation is active may lead to
> +		 * h/w stall
> +		 */
> +		spin_unlock_irqrestore(&imr->lock, flags);
> +	} else {
> +		spin_unlock_irqrestore(&imr->lock, flags);
> +		v4l2_dbg(1, debug, &imr->v4l2_dev,
> +			 "job has completed already\n");
> +	}
> +}
> +
> +/* M2M interface definition */
> +static struct v4l2_m2m_ops imr_m2m_ops = {
> +	.device_run	= imr_device_run,
> +	.job_ready	= imr_job_ready,
> +	.job_abort	= imr_job_abort,
> +};
> +
> +/*******************************************************************************
> + * Interrupt handling
> + ******************************************************************************/
> +
> +static irqreturn_t imr_irq_handler(int irq, void *data)
> +{
> +	struct imr_device	*imr = data;
> +	struct vb2_v4l2_buffer	*src_buf, *dst_buf;
> +	bool			finish = false;
> +	u32			status;
> +	struct imr_ctx		*ctx;
> +
> +	/* check and ack interrupt status */
> +	status = ioread32(imr->mmio + IMR_SR);
> +	iowrite32(status, imr->mmio + IMR_SRCR);
> +	if (!(status & (IMR_SR_INT | IMR_SR_IER | IMR_SR_TRA))) {
> +		v4l2_err(&imr->v4l2_dev, "spurious interrupt: %x\n", status);
> +		return IRQ_NONE;
> +	}
> +
> +	/* protect access to current context */
> +	spin_lock(&imr->lock);
> +
> +	/* get current job context (may have been cancelled already) */
> +	ctx = v4l2_m2m_get_curr_priv(imr->m2m_dev);
> +	if (!ctx) {
> +		v4l2_dbg(3, debug, &imr->v4l2_dev, "no active job\n");
> +		goto handled;
> +	}
> +
> +	/* remove buffers (may have been removed already?) */
> +	src_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
> +	dst_buf = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
> +	if (!src_buf || !dst_buf) {
> +		v4l2_dbg(3, debug, &imr->v4l2_dev,
> +			 "no buffers associated with current context\n");
> +		goto handled;
> +	}
> +
> +	finish = true;
> +
> +	/* check for a TRAP interrupt indicating completion of current DL */
> +	if (status & IMR_SR_TRA) {
> +		/* operation completed normally; timestamp output buffer */
> +		dst_buf->vb2_buf.timestamp = ktime_get_ns();
> +		if (src_buf->flags & V4L2_BUF_FLAG_TIMECODE)
> +			dst_buf->timecode = src_buf->timecode;
> +		dst_buf->flags = src_buf->flags &
> +			(V4L2_BUF_FLAG_TIMECODE | V4L2_BUF_FLAG_KEYFRAME |
> +			 V4L2_BUF_FLAG_PFRAME | V4L2_BUF_FLAG_BFRAME |
> +			 V4L2_BUF_FLAG_TSTAMP_SRC_MASK);
> +		dst_buf->sequence = src_buf->sequence = ctx->sequence++;
> +		v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_DONE);
> +		v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_DONE);
> +
> +		v4l2_dbg(3, debug, &imr->v4l2_dev,
> +			 "buffers <0x%08x,0x%08x> done\n",
> +			(u32)vb2_dma_contig_plane_dma_addr
> +				(&src_buf->vb2_buf, 0),
> +			(u32)vb2_dma_contig_plane_dma_addr
> +				(&dst_buf->vb2_buf, 0));
> +	} else {
> +		/*
> +		 * operation completed in error; no way to understand
> +		 * what exactly went wrong
> +		 */
> +		v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_ERROR);
> +		v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_ERROR);
> +
> +		v4l2_dbg(3, debug, &imr->v4l2_dev,
> +			 "buffers <0x%08x,0x%08x> done in error\n",
> +			 (u32)vb2_dma_contig_plane_dma_addr
> +				(&src_buf->vb2_buf, 0),
> +			 (u32)vb2_dma_contig_plane_dma_addr
> +				(&dst_buf->vb2_buf, 0));
> +	}
> +
> +handled:
> +	spin_unlock(&imr->lock);
> +
> +	/* finish current job (and start any pending) */
> +	if (finish)
> +		v4l2_m2m_job_finish(imr->m2m_dev, ctx->m2m_ctx);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +/*******************************************************************************
> + * Device probing/removal interface
> + ******************************************************************************/
> +
> +static int imr_probe(struct platform_device *pdev)
> +{
> +	struct imr_device	*imr;
> +	struct resource		*res;
> +	int			ret;
> +
> +	imr = devm_kzalloc(&pdev->dev, sizeof(*imr), GFP_KERNEL);
> +	if (!imr)
> +		return -ENOMEM;
> +
> +	mutex_init(&imr->mutex);
> +	spin_lock_init(&imr->lock);
> +	imr->dev = &pdev->dev;
> +
> +	/* memory-mapped registers */
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	imr->mmio = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(imr->mmio))
> +		return PTR_ERR(imr->mmio);
> +
> +	/* interrupt service routine registration */
> +	imr->irq = ret = platform_get_irq(pdev, 0);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "cannot find IRQ\n");
> +		return ret;
> +	}
> +
> +	ret = devm_request_irq(&pdev->dev, imr->irq, imr_irq_handler, 0,
> +			       dev_name(&pdev->dev), imr);
> +	if (ret) {
> +		dev_err(&pdev->dev, "cannot claim IRQ %d\n", imr->irq);
> +		return ret;
> +	}
> +
> +	imr->clock = devm_clk_get(&pdev->dev, NULL);
> +	if (IS_ERR(imr->clock)) {
> +		dev_err(&pdev->dev, "cannot get clock\n");
> +		return PTR_ERR(imr->clock);
> +	}
> +
> +	/* create v4l2 device */
> +	ret = v4l2_device_register(&pdev->dev, &imr->v4l2_dev);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Failed to register v4l2 device\n");
> +		return ret;
> +	}
> +
> +	/* create mem2mem device handle */
> +	imr->m2m_dev = v4l2_m2m_init(&imr_m2m_ops);
> +	if (IS_ERR(imr->m2m_dev)) {
> +		v4l2_err(&imr->v4l2_dev, "Failed to init mem2mem device\n");
> +		ret = PTR_ERR(imr->m2m_dev);
> +		goto device_register_rollback;
> +	}
> +
> +	strlcpy(imr->video_dev.name, dev_name(&pdev->dev),
> +		sizeof(imr->video_dev.name));
> +	imr->video_dev.fops         = &imr_fops;
> +	imr->video_dev.ioctl_ops    = &imr_ioctl_ops;
> +	imr->video_dev.minor        = -1;
> +	imr->video_dev.release      = video_device_release_empty;
> +	imr->video_dev.lock         = &imr->mutex;
> +	imr->video_dev.v4l2_dev     = &imr->v4l2_dev;
> +	imr->video_dev.vfl_dir      = VFL_DIR_M2M;

You need to fill in video_dev.device_caps here (see comment for querycap).

> +
> +	ret = video_register_device(&imr->video_dev, VFL_TYPE_GRABBER, -1);
> +	if (ret) {
> +		v4l2_err(&imr->v4l2_dev, "Failed to register video device\n");
> +		goto m2m_init_rollback;
> +	}
> +
> +	video_set_drvdata(&imr->video_dev, imr);
> +	platform_set_drvdata(pdev, imr);
> +
> +	v4l2_info(&imr->v4l2_dev,
> +		  "IMR device (pdev: %d) registered as /dev/video%d\n",
> +		  pdev->id, imr->video_dev.num);
> +
> +	return 0;
> +
> +m2m_init_rollback:
> +	v4l2_m2m_release(imr->m2m_dev);
> +
> +device_register_rollback:
> +	v4l2_device_unregister(&imr->v4l2_dev);
> +
> +	return ret;
> +}
> +
> +static int imr_remove(struct platform_device *pdev)
> +{
> +	struct imr_device *imr = platform_get_drvdata(pdev);
> +
> +	video_unregister_device(&imr->video_dev);
> +	v4l2_m2m_release(imr->m2m_dev);
> +	v4l2_device_unregister(&imr->v4l2_dev);
> +
> +	return 0;
> +}
> +
> +/*******************************************************************************
> + * Power management
> + ******************************************************************************/
> +
> +#ifdef CONFIG_PM_SLEEP
> +
> +/* device suspend hook; clock control only - TBD */
> +static int imr_pm_suspend(struct device *dev)
> +{
> +	struct imr_device *imr = dev_get_drvdata(dev);
> +
> +	WARN_ON(mutex_is_locked(&imr->mutex));
> +
> +	if (imr->refcount == 0)
> +		return 0;
> +
> +	clk_disable_unprepare(imr->clock);
> +
> +	return 0;
> +}
> +
> +/* device resume hook; clock control only */
> +static int imr_pm_resume(struct device *dev)
> +{
> +	struct imr_device *imr = dev_get_drvdata(dev);
> +
> +	WARN_ON(mutex_is_locked(&imr->mutex));
> +
> +	if (imr->refcount == 0)
> +		return 0;
> +
> +	clk_prepare_enable(imr->clock);
> +
> +	return 0;
> +}
> +
> +#endif  /* CONFIG_PM_SLEEP */
> +
> +/* power management callbacks */
> +static const struct dev_pm_ops imr_pm_ops = {
> +	SET_SYSTEM_SLEEP_PM_OPS(imr_pm_suspend, imr_pm_resume)
> +};
> +
> +/* device table */
> +static const struct of_device_id imr_of_match[] = {
> +	{ .compatible = "renesas,imr-lx4" },
> +	{ },
> +};
> +
> +/* platform driver interface */
> +static struct platform_driver imr_platform_driver = {
> +	.probe		= imr_probe,
> +	.remove		= imr_remove,
> +	.driver		= {
> +		.owner		= THIS_MODULE,
> +		.name		= "imr",
> +		.pm		= &imr_pm_ops,
> +		.of_match_table = imr_of_match,
> +	},
> +};
> +
> +module_platform_driver(imr_platform_driver);
> +
> +MODULE_ALIAS("imr");
> +MODULE_AUTHOR("Cogent Embedded Inc. <sources@cogentembedded.com>");
> +MODULE_DESCRIPTION("Renesas IMR-LX4 Driver");
> +MODULE_LICENSE("GPL");
> Index: media_tree/include/uapi/linux/rcar_imr.h
> ===================================================================
> --- /dev/null
> +++ media_tree/include/uapi/linux/rcar_imr.h
> @@ -0,0 +1,94 @@
> +/*
> + * rcar_imr.h -- R-Car IMR-LX4 Driver UAPI
> + *
> + * Copyright (C) 2016-2017 Cogent Embedded, Inc. <source@cogentembedded.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#ifndef __RCAR_IMR_H
> +#define __RCAR_IMR_H
> +
> +#include <linux/videodev2.h>
> +
> +/*******************************************************************************
> + * Mapping specification descriptor
> + ******************************************************************************/
> +
> +struct imr_map_desc {
> +	/* mapping types */
> +	u32			type;
> +
> +	/* total size of the mesh structure */
> +	u32			size;
> +
> +	/* map-specific user-pointer */
> +	void			*data;

Note that this void pointer would require compat32 support if this IP block
can be used on a 64-bit arm.

> +} __packed;
> +
> +/* regular mesh specification */
> +#define IMR_MAP_MESH		(1 << 0)
> +
> +/* auto-generated source coordinates */
> +#define IMR_MAP_AUTOSG		(1 << 1)
> +
> +/* auto-generated destination coordinates */
> +#define IMR_MAP_AUTODG		(1 << 2)
> +
> +/* luminance correction flag */
> +#define IMR_MAP_LUCE		(1 << 3)
> +
> +/* chromacity correction flag */
> +#define IMR_MAP_CLCE		(1 << 4)
> +
> +/* vertex clockwise-mode order */
> +#define IMR_MAP_TCM		(1 << 5)
> +
> +/* source coordinate decimal point position bit index */
> +#define __IMR_MAP_UVDPOR_SHIFT	8
> +#define __IMR_MAP_UVDPOR(v)	(((v) >> __IMR_MAP_UVDPOR_SHIFT) & 0x7)
> +#define IMR_MAP_UVDPOR(n)	(((n) & 0x7) << __IMR_MAP_UVDPOR_SHIFT)
> +
> +/* destination coordinate sub-pixel mode */
> +#define IMR_MAP_DDP		(1 << 11)
> +
> +/* luminance correction offset decimal point position */
> +#define __IMR_MAP_YLDPO_SHIFT	12
> +#define __IMR_MAP_YLDPO(v)	(((v) >> __IMR_MAP_YLDPO_SHIFT) & 0x7)
> +#define IMR_MAP_YLDPO(n)	(((n) & 0x7) << __IMR_MAP_YLDPO_SHIFT)
> +
> +/* chromacity (U) correction offset decimal point position */
> +#define __IMR_MAP_UBDPO_SHIFT	15
> +#define __IMR_MAP_UBDPO(v)	(((v) >> __IMR_MAP_UBDPO_SHIFT) & 0x7)
> +#define IMR_MAP_UBDPO(n)	(((n) & 0x7) << __IMR_MAP_UBDPO_SHIFT)
> +
> +/* chromacity (V) correction offset decimal point position */
> +#define __IMR_MAP_VRDPO_SHIFT	18
> +#define __IMR_MAP_VRDPO(v)	(((v) >> __IMR_MAP_VRDPO_SHIFT) & 0x7)
> +#define IMR_MAP_VRDPO(n)	(((n) & 0x7) << __IMR_MAP_VRDPO_SHIFT)
> +
> +/* regular mesh specification */
> +struct imr_mesh {
> +	/* rectangular mesh size */
> +	u16			rows, columns;
> +
> +	/* mesh parameters */
> +	u16			x0, y0, dx, dy;
> +} __packed;
> +
> +/* VBO descriptor */
> +struct imr_vbo {
> +	/* number of triangles */
> +	u16			num;
> +} __packed;

Is this part of the public API? Not clear at all.

> +
> +/*******************************************************************************
> + * Private IOCTL codes
> + ******************************************************************************/
> +
> +#define VIDIOC_IMR_MESH _IOW('V', BASE_VIDIOC_PRIVATE + 0, struct imr_map_desc)

This needs to be documented. It's not clear at all how this should be used.
A new file in Documentation/media/v4l-drivers/ is a good place to do that.

I'm not sure how much of the HW documentation is public. If it is, then you can
refer to that and you just have to explain how to use this ioctl.

Regards,

	Hans

> +
> +#endif /* __RCAR_IMR_H */
> 
