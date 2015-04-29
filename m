Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:35835 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbbD2Vyn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Apr 2015 17:54:43 -0400
Received: by labbd9 with SMTP id bd9so30607461lab.2
        for <linux-media@vger.kernel.org>; Wed, 29 Apr 2015 14:54:41 -0700 (PDT)
From: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
To: hverkuil@xs4all.nl, horms@verge.net.au, magnus.damm@gmail.com
Cc: laurent.pinchart@ideasonboard.com,
	sergei.shtylyov@cogentembedded.com, linux-media@vger.kernel.org,
	linux-sh@vger.kernel.org,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
Subject: [PATCH v3 1/1] V4L2: platform: Renesas R-Car JPEG codec driver
Date: Thu, 30 Apr 2015 00:53:29 +0300
Message-Id: <1430344409-11928-1-git-send-email-mikhail.ulyanov@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Here's the the driver for the Renesas R-Car JPEG processing unit driver.

The driver is implemented within the V4L2 framework as a mem-to-mem device.  It
presents two video nodes to userspace, one for the encoding part, and one for
the decoding part.

It was found that the only working mode for encoding is no markers output, so we
generate it with software. In current version of driver we also use software
JPEG header parsing because with hardware parsing performance is lower then
desired.

>From a userspace point of view the encoding process is typical (S_FMT, REQBUF,
optionally QUERYBUF, QBUF, STREAMON, DQBUF) for both the source and destination
queues. The decoding process requires that the source queue performs S_FMT,
REQBUF, (QUERYBUF), QBUF and STREAMON. After STREAMON on the source queue, it is
possible to perform G_FMT on the destination queue to find out the processed
image width and height in order to be able to allocate an appropriate buffer -
it is assumed that the user does not pass the compressed image width and height
but instead this information is parsed from the JPEG input. This is done in
kernel. Then REQBUF, QBUF and STREAMON on the destination queue complete the
decoding and it is possible to DQBUF from both queues and finish the operation.

During encoding the available formats are: V4L2_PIX_FMT_NV12M and
V4L2_PIX_FMT_NV16M for source and V4L2_PIX_FMT_JPEG for destination.

During decoding the available formats are: V4L2_PIX_FMT_JPEG for source and
V4L2_PIX_FMT_NV12M and V4L2_PIX_FMT_NV16M for destination.

Performance of current version:
1280x800 NV12 image encoding/decoding
	decoding ~121 FPS
	encoding ~190 FPS

Signed-off-by: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
---
Changes since v2:
    - Kconfig entry reordered
    - unnecessary clk_disable_unprepare(jpu->clk) removed
    - ref_count fixed in jpu_resume
    - enable DMABUF in src_vq->io_modes
    - remove jpu_s_priority jpu_g_priority
    - jpu_g_selection fixed
    - timeout in jpu_reset added and hardware reset reworked
    - remove unused macros
    - JPEG header parsing now is software because of performance issues
      based on s5p-jpu code
    - JPEG header generation redesigned:
      JPEG header(s) pre-generated and memcpy'ed on encoding
      we only fill the necessary fields
      more "transparent" header format description
    - S_FMT, G_FMT and TRY_FMT hooks redesigned
      partially inspired by VSP1 driver code
    - some code was reformatted
    - image formats handling redesigned
    - multi-planar V4L2 API now in use
    - now passes v4l2-compliance tool check

Cnanges since v1:
    - s/g_fmt function simplified
    - default format for queues added
    - dumb vidioc functions added to be in compliance with standard api:
        jpu_s_priority, jpu_g_priority
    - standard v4l2_ctrl_subscribe_event and v4l2_event_unsubscribe
      now in use by the same reason

 drivers/media/platform/Kconfig  |   11 +
 drivers/media/platform/Makefile |    1 +
 drivers/media/platform/jpu.c    | 1724 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 1736 insertions(+)
 create mode 100644 drivers/media/platform/jpu.c

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 765bffb..33a457c 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -220,6 +220,17 @@ config VIDEO_SH_VEU
 	    Support for the Video Engine Unit (VEU) on SuperH and
 	    SH-Mobile SoCs.

+config VIDEO_RENESAS_JPU
+	tristate "Renesas JPEG Processing Unit"
+	depends on VIDEO_DEV && VIDEO_V4L2
+	select VIDEOBUF2_DMA_CONTIG
+	select V4L2_MEM2MEM_DEV
+	---help---
+	  This is a V4L2 driver for the Renesas JPEG Processing Unit.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called jpu.
+
 config VIDEO_RENESAS_VSP1
 	tristate "Renesas VSP1 Video Processing Engine"
 	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && HAS_DMA
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index a49936b..1399c0d 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -42,6 +42,7 @@ obj-$(CONFIG_VIDEO_SH_VOU)		+= sh_vou.o

 obj-$(CONFIG_SOC_CAMERA)		+= soc_camera/

+obj-$(CONFIG_VIDEO_RENESAS_JPU) 	+= jpu.o
 obj-$(CONFIG_VIDEO_RENESAS_VSP1)	+= vsp1/

 obj-y	+= omap/
diff --git a/drivers/media/platform/jpu.c b/drivers/media/platform/jpu.c
new file mode 100644
index 0000000..6c658cc
--- /dev/null
+++ b/drivers/media/platform/jpu.c
@@ -0,0 +1,1724 @@
+/*
+ * Author: Mikhail Ulyanov
+ * Copyright (C) 2014-2015 Cogent Embedded, Inc.  <source@cogentembedded.com>
+ * Copyright (C) 2014-2015 Renesas Electronics Corporation
+ *
+ * This is based on the drivers/media/platform/s5p-jpeg driver by
+ * Andrzej Pietrasiewicz and Jacek Anaszewski.
+ * Some portions of code inspired by VSP1 driver by Laurent Pinchart.
+ *
+ * TODO in order of priority:
+ *      1) Multiple buffers support
+ *      2) NV21* and NV61* formats support
+ *      3) Semiplanar formats support
+ *      4) Rotation support
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/string.h>
+#include <linux/videodev2.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-fh.h>
+#include <media/v4l2-mem2mem.h>
+#include <media/v4l2-ioctl.h>
+#include <media/videobuf2-core.h>
+#include <media/videobuf2-dma-contig.h>
+
+
+#define JPU_M2M_NAME "jpu"
+
+/*
+ * Little more than described (8.25) in
+ * http://en.wikipedia.org/wiki/JPEG#Sample_photographs
+ */
+#define JPU_JPEG_MAX_BITS_PER_PIXEL	9
+#define JPU_JPEG_HDR_SIZE		0x258
+#define JPU_JPEG_QTBL_SIZE		0x40
+#define JPU_JPEG_HDCTBL_SIZE		0x1c
+#define JPU_JPEG_HACTBL_SIZE		0xb2
+#define JPU_JPEG_HEIGHT_OFFSET		0x91
+#define JPU_JPEG_WIDTH_OFFSET		0x93
+#define JPU_JPEG_SUBS_OFFSET		0x97
+#define JPU_JPEG_QTBL_LUM_OFFSET	0x07
+#define JPU_JPEG_QTBL_CHR_OFFSET	0x4c
+#define JPU_JPEG_HDCTBL_LUM_OFFSET	0xa4
+#define JPU_JPEG_HACTBL_LUM_OFFSET	0xc5
+#define JPU_JPEG_HDCTBL_CHR_OFFSET	0x17c
+#define JPU_JPEG_HACTBL_CHR_OFFSET	0x19d
+#define JPU_JPEG_LUM 0x00
+#define JPU_JPEG_CHR 0x01
+#define JPU_JPEG_DC  0x00
+#define JPU_JPEG_AC  0x10
+
+#define JPU_JPEG_422 0x21
+#define JPU_JPEG_420 0x22
+
+/* JPEG markers */
+#define TEM	0x01
+#define SOF0	0xc0
+#define RST	0xd0
+#define SOI	0xd8
+#define EOI	0xd9
+#define DHP	0xde
+#define DHT	0xc4
+#define COM	0xfe
+#define DQT	0xdb
+
+#define JPU_RESET_TIMEOUT	100 /* ms */
+#define JPU_MAX_QUALITY		4
+#define JPU_WIDTH_MIN		16
+#define JPU_HEIGHT_MIN		16
+#define JPU_WIDTH_MAX		4096
+#define JPU_HEIGHT_MAX		4096
+#define JPU_MEMALIGN		0x8
+
+/* Flags that indicate a format can be used for capture/output */
+#define JPU_FMT_TYPE_OUTPUT	0
+#define JPU_FMT_TYPE_CAPTURE	1
+#define JPU_ENC_CAPTURE		(1 << 0)
+#define JPU_ENC_OUTPUT		(1 << 1)
+#define JPU_DEC_CAPTURE		(1 << 2)
+#define JPU_DEC_OUTPUT		(1 << 3)
+
+/*
+ * JPEG registers and bits
+ */
+
+/* JPEG code mode register */
+#define JCMOD	0x00
+#define JCMOD_PCTR		(1 << 7)
+#define JCMOD_MSKIP_ENABLE	(1 << 5)
+#define JCMOD_DSP_ENC		(0 << 3)
+#define JCMOD_DSP_DEC		(1 << 3)
+#define JCMOD_REDU		(7 << 0)
+#define JCMOD_REDU_422		(1 << 0)
+#define JCMOD_REDU_420		(2 << 0)
+
+/* JPEG code command register */
+#define JCCMD	0x04
+#define JCCMD_SRST	(1 << 12)
+#define JCCMD_JEND	(1 << 2)
+#define JCCMD_JSRT	(1 << 0)
+
+/* JPEG code quantanization table number register */
+#define JCQTN	0x0c
+#define JCQTN_SHIFT(t)		(((t) - 1) << 1)
+
+/* JPEG code Huffman table number register */
+#define JCHTN	0x10
+#define JCHTN_AC_SHIFT(t)	(((t) << 1) - 1)
+#define JCHTN_DC_SHIFT(t)	(((t) - 1) << 1)
+
+#define JCVSZU	0x1c /* JPEG code vertical size upper register */
+#define JCVSZD	0x20 /* JPEG code vertical size lower register */
+#define JCHSZU	0x24 /* JPEG code horizontal size upper register */
+#define JCHSZD	0x28 /* JPEG code horizontal size lower register */
+#define JCSZ_MASK 0xff /* JPEG code h/v size register contains only 1 byte*/
+
+#define JCDTCU	0x2c /* JPEG code data count upper register */
+#define JCDTCM	0x30 /* JPEG code data count middle register */
+#define JCDTCD	0x34 /* JPEG code data count lower register */
+
+/* JPEG interrupt enable register */
+#define JINTE	0x38
+#define JINTE_HDR_PARSED	(1 << 3)
+#define JINTE_ERR		(0x7 << 5) /* INT5 + INT6 + INT7 */
+#define JINTE_TRANSF_COMPL	(1 << 10)
+
+/* JPEG interrupt status register */
+#define JINTS	0x3c
+#define JINTS_MASK	0x7c68
+#define JINTS_HDR_PARSED	(1 << 3)
+#define JINTS_ERR		(1 << 5)
+#define JINTS_PROCESS_COMPL	(1 << 6)
+#define JINTS_TRANSF_COMPL	(1 << 10)
+
+#define JCDERR	0x40 /* JPEG code decode error register */
+
+/* JPEG interface encoding */
+#define JIFECNT	0x70
+#define JIFECNT_INFT_422	0
+#define JIFECNT_INFT_420	1
+#define JIFECNT_SWAP_WB		(0x3 << 4)
+
+#define JIFESYA1	0x74	/* encode source Y address register 1 */
+#define JIFESCA1	0x78	/* encode source C address register 1 */
+#define JIFESYA2	0x7c	/* encode source Y address register 2 */
+#define JIFESCA2	0x80	/* encode source C address register 2 */
+#define JIFESMW		0x84	/* encode source memory width register */
+#define JIFESVSZ	0x88	/* encode source vertical size register */
+#define JIFESHSZ	0x8c	/* encode source horizontal size register */
+#define JIFEDA1		0x90	/* encode destination address register 1 */
+#define JIFEDA2		0x94	/* encode destination address register 2 */
+
+/* JPEG decoding control register */
+#define JIFDCNT	0xa0
+#define JIFDCNT_SWAP		(3 << 1)
+#define JIFDCNT_SWAP_WB		(3 << 1)
+
+#define JIFDSA1		0xa4	/* decode source address register 1 */
+#define JIFDDMW		0xb0	/* decode destination  memory width register */
+#define JIFDDVSZ	0xb4	/* decode destination  vert. size register */
+#define JIFDDHSZ	0xb8	/* decode destination  horiz. size register */
+#define JIFDDYA1	0xbc	/* decode destination  Y address register 1 */
+#define JIFDDCA1	0xc0	/* decode destination  C address register 1 */
+
+#define JCQTBL(n)	(0x10000 + (n) * 0x40)	/* quantization tables regs */
+#define JCHTBD(n)	(0x10100 + (n) * 0x100)	/* Huffman table DC regs */
+#define JCHTBA(n)	(0x10120 + (n) * 0x100)	/* Huffman table AC regs */
+
+/**
+ * struct jpu - JPEG IP abstraction
+ * @mutex: the mutex protecting this structure
+ * @lock: spinlock protecting the device contexts
+ * @v4l2_dev: v4l2 device for mem2mem mode
+ * @vfd_encoder: video device node for encoder mem2mem mode
+ * @vfd_decoder: video device node for decoder mem2mem mode
+ * @m2m_dev: v4l2 mem2mem device data
+ * @regs: JPEG IP registers mapping
+ * @irq: JPEG IP irq
+ * @clk: JPEG IP clock
+ * @dev: JPEG IP struct device
+ * @alloc_ctx: videobuf2 memory allocator's context
+ * @ref_counter: reference counter
+ */
+struct jpu {
+	struct mutex	mutex;
+	spinlock_t	lock;
+	struct v4l2_device	v4l2_dev;
+	struct video_device	*vfd_encoder;
+	struct video_device	*vfd_decoder;
+	struct v4l2_m2m_dev	*m2m_dev;
+
+	void __iomem		*regs;
+	unsigned int		irq;
+	struct clk		*clk;
+	struct device		*dev;
+	void			*alloc_ctx;
+	int			ref_count;
+};
+
+/**
+ * struct jpu_fmt - driver's internal format data
+ * @name: format description
+ * @fourcc: the fourcc code, 0 if not applicable
+ * @colorspace: the colorspace specifier
+ * @bpp: number of bits per pixel per plane
+ * @h_align: horizontal alignment order (align to 2^h_align)
+ * @v_align: vertical alignment order (align to 2^v_align)
+ * @subsampling: (horizontal:4 | vertical:4) subsampling factor
+ * @num_planes: number of planes
+ * @types: types of queue this format is applicable to
+ */
+struct jpu_fmt {
+	char *name;
+	u32 fourcc;
+	u32 colorspace;
+	u8 bpp[2];
+	u8 h_align;
+	u8 v_align;
+	u8 subsampling;
+	u8 num_planes;
+	u16 types;
+};
+
+/**
+ * jpu_q_data - parameters of one queue
+ * @fmtinfo: driver-specific format of this queue
+ * @format: multiplanar format of this queue
+ */
+struct jpu_q_data {
+	struct jpu_fmt *fmtinfo;
+	struct v4l2_pix_format_mplane format;
+};
+
+/**
+ * jpu_ctx - the device context data
+ * @jpu: JPEG IP device for this context
+ * @encoder: compression (encode) operation or decompression (decode)
+ * @hdr_parsed: set if header has been parsed during decompression
+ * @compr_quality: destination image quality in compression (encode) mode
+ * @out_q: source (output) queue information
+ * @cap_q: destination (capture) queue information
+ * @fh: file handler
+ * @ctrl_handler: controls handler
+ */
+struct jpu_ctx {
+	struct jpu		*jpu;
+	bool			encoder;
+	bool			hdr_parsed;
+	unsigned short		compr_quality;
+	struct jpu_q_data	out_q;
+	struct jpu_q_data	cap_q;
+	struct v4l2_fh		fh;
+	struct v4l2_ctrl_handler ctrl_handler;
+};
+
+/**
+ * jpeg_buffer - description of memory containing input JPEG data
+ * @size: buffer size
+ * @curr: current position in the buffer
+ * @data: pointer to the data
+ */
+struct jpeg_buffer {
+	unsigned long size;
+	unsigned long curr;
+	unsigned long data;
+};
+
+static struct jpu_fmt jpu_formats[] = {
+	{ "JPEG JFIF", V4L2_PIX_FMT_JPEG, V4L2_COLORSPACE_JPEG,
+	  {0, 0}, 0, 0, 0, 1, JPU_ENC_CAPTURE | JPU_DEC_OUTPUT },
+	{ "YUV 4:2:2 planar, Y/CbCr", V4L2_PIX_FMT_NV16M, V4L2_COLORSPACE_SRGB,
+	  {8, 16}, 2, 2, JPU_JPEG_422, 2, JPU_ENC_OUTPUT | JPU_DEC_CAPTURE },
+	{ "YUV 4:2:0 planar, Y/CbCr", V4L2_PIX_FMT_NV12M, V4L2_COLORSPACE_SRGB,
+	  {8, 16}, 2, 2, JPU_JPEG_420, 2, JPU_ENC_OUTPUT | JPU_DEC_CAPTURE }
+};
+
+static const u8 zigzag[] = {
+	0x03, 0x02, 0x0b, 0x13, 0x0a, 0x01, 0x00, 0x09,
+	0x12, 0x1b, 0x23, 0x1a, 0x11, 0x08, 0x07, 0x06,
+	0x0f, 0x10, 0x19, 0x22, 0x2b, 0x33, 0x2a, 0x21,
+	0x18, 0x17, 0x0e, 0x05, 0x04, 0x0d, 0x16, 0x1f,
+	0x20, 0x29, 0x32, 0x3b, 0x3a, 0x31, 0x28, 0x27,
+	0x1e, 0x15, 0x0e, 0x14, 0x10, 0x26, 0x2f, 0x30,
+	0x39, 0x38, 0x37, 0x2e, 0x25, 0x1c, 0x24, 0x2b,
+	0x36, 0x3f, 0x3e, 0x35, 0x2c, 0x34, 0x3d, 0x3c
+};
+
+#define QTBL_SIZE (ALIGN(JPU_JPEG_QTBL_SIZE, \
+			  sizeof(unsigned int)) / sizeof(unsigned int))
+#define HDCTBL_SIZE (ALIGN(JPU_JPEG_HDCTBL_SIZE, \
+			  sizeof(unsigned int)) / sizeof(unsigned int))
+#define HACTBL_SIZE (ALIGN(JPU_JPEG_HACTBL_SIZE, \
+			  sizeof(unsigned int)) / sizeof(unsigned int))
+/*
+ * Start of image; Quantization tables
+ * SOF0 is Baseline DCT - Sample precision, height, width,
+ * Number of image components, (Ci:8 - Hi:4 - Vi:4 - Tq:8) * 3 - Y,Cb,Cr;
+ * Huffman tables; Padding with empty comment (33.3.27 R01UH0501EJ0100 Rev.1.00)
+ */
+#define JPU_JPEG_HDR_BLOB {                                                    \
+	0xff, SOI, 0xff, DQT, 0x00, JPU_JPEG_QTBL_SIZE + 0x3, JPU_JPEG_LUM,    \
+	[JPU_JPEG_QTBL_LUM_OFFSET ...                                          \
+		JPU_JPEG_QTBL_LUM_OFFSET + JPU_JPEG_QTBL_SIZE - 1] = 0x00,     \
+	0xff, DQT, 0x00, JPU_JPEG_QTBL_SIZE + 0x3, JPU_JPEG_CHR,               \
+	[JPU_JPEG_QTBL_CHR_OFFSET ... JPU_JPEG_QTBL_CHR_OFFSET +               \
+		JPU_JPEG_QTBL_SIZE - 1] = 0x00, 0xff, SOF0, 0x00, 0x11, 0x08,  \
+	[JPU_JPEG_HEIGHT_OFFSET ... JPU_JPEG_HEIGHT_OFFSET + 1] = 0x00,        \
+	[JPU_JPEG_WIDTH_OFFSET ... JPU_JPEG_WIDTH_OFFSET + 1] = 0x00,          \
+	0x03, 0x01, [JPU_JPEG_SUBS_OFFSET] = 0x00, JPU_JPEG_LUM,               \
+	0x02, 0x11, JPU_JPEG_CHR, 0x03, 0x11, JPU_JPEG_CHR,                    \
+	0xff, DHT, 0x00, JPU_JPEG_HDCTBL_SIZE + 0x3, JPU_JPEG_LUM|JPU_JPEG_DC, \
+	[JPU_JPEG_HDCTBL_LUM_OFFSET ...                                        \
+		JPU_JPEG_HDCTBL_LUM_OFFSET + JPU_JPEG_HDCTBL_SIZE - 1] = 0x00, \
+	0xff, DHT, 0x00, JPU_JPEG_HACTBL_SIZE + 0x3, JPU_JPEG_LUM|JPU_JPEG_AC, \
+	[JPU_JPEG_HACTBL_LUM_OFFSET ...                                        \
+		JPU_JPEG_HACTBL_LUM_OFFSET + JPU_JPEG_HACTBL_SIZE - 1] = 0x00, \
+	0xff, DHT, 0x00, JPU_JPEG_HDCTBL_SIZE + 0x3, JPU_JPEG_CHR|JPU_JPEG_DC, \
+	[JPU_JPEG_HDCTBL_CHR_OFFSET ...                                        \
+		JPU_JPEG_HDCTBL_CHR_OFFSET + JPU_JPEG_HDCTBL_SIZE - 1] = 0x00, \
+	0xff, DHT, 0x00, JPU_JPEG_HACTBL_SIZE + 0x3, JPU_JPEG_CHR|JPU_JPEG_AC, \
+	[JPU_JPEG_HACTBL_CHR_OFFSET ...                                        \
+		JPU_JPEG_HACTBL_CHR_OFFSET + JPU_JPEG_HACTBL_SIZE - 1] = 0x00, \
+	0xff, COM, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00                    \
+}
+
+static unsigned char jpeg_hdrs[JPU_MAX_QUALITY][JPU_JPEG_HDR_SIZE] = {
+	[0 ... JPU_MAX_QUALITY - 1] = JPU_JPEG_HDR_BLOB
+};
+
+static const unsigned int qtbl_lum[JPU_MAX_QUALITY][QTBL_SIZE] = {
+	{
+		0x14101927, 0x322e3e44, 0x10121726, 0x26354144,
+		0x19171f26, 0x35414444, 0x27262635, 0x41444444,
+		0x32263541, 0x44444444, 0x2e354144, 0x44444444,
+		0x3e414444, 0x44444444, 0x44444444, 0x44444444
+	},
+	{
+		0x100b0b10, 0x171b1f1e, 0x0b0c0c0f, 0x1417171e,
+		0x0b0c0d10, 0x171a232f, 0x100f1017, 0x1a252f40,
+		0x1714171a, 0x27334040, 0x1b171a25, 0x33404040,
+		0x1f17232f, 0x40404040, 0x1e1e2f40, 0x40404040
+	},
+	{
+		0x0c08080c, 0x11151817, 0x0809090b, 0x0f131217,
+		0x08090a0c, 0x13141b24, 0x0c0b0c15, 0x141c2435,
+		0x110f1314, 0x1e27333b, 0x1513141c, 0x27333b3b,
+		0x18121b24, 0x333b3b3b, 0x17172435, 0x3b3b3b3b
+	},
+	{
+		0x08060608, 0x0c0e1011, 0x06060608, 0x0a0d0c0f,
+		0x06060708, 0x0d0e1218, 0x0808080e, 0x0d131823,
+		0x0c0a0d0d, 0x141a2227, 0x0e0d0e13, 0x1a222727,
+		0x100c1318, 0x22272727, 0x110f1823, 0x27272727
+	}
+};
+
+static const unsigned int qtbl_chr[JPU_MAX_QUALITY][QTBL_SIZE] = {
+	{
+		0x15192026, 0x36444444, 0x191c1826, 0x36444444,
+		0x2018202b, 0x42444444, 0x26262b35, 0x44444444,
+		0x36424444, 0x44444444, 0x44444444, 0x44444444,
+		0x44444444, 0x44444444, 0x44444444, 0x44444444
+	},
+	{
+		0x110f1115, 0x141a2630, 0x0f131211, 0x141a232b,
+		0x11121416, 0x1a1e2e35, 0x1511161c, 0x1e273540,
+		0x14141a1e, 0x27304040, 0x1a1a1e27, 0x303f4040,
+		0x26232e35, 0x40404040, 0x302b3540, 0x40404040
+	},
+	{
+		0x0d0b0d10, 0x14141d25, 0x0b0e0e0e, 0x10141a20,
+		0x0d0e0f11, 0x14172328, 0x100e1115, 0x171e2832,
+		0x14101417, 0x1e25323b, 0x1414171e, 0x25303b3b,
+		0x1d1a2328, 0x323b3b3b, 0x25202832, 0x3b3b3b3b
+	},
+	{
+		0x0908090b, 0x0e111318, 0x080a090b, 0x0e0d1116,
+		0x09090d0e, 0x0d0f171a, 0x0b0b0e0e, 0x0f141a21,
+		0x0e0e0d0f, 0x14182127, 0x110d0f14, 0x18202727,
+		0x1311171a, 0x21272727, 0x18161a21, 0x27272727
+	}
+};
+
+static const unsigned int hdctbl_lum[HDCTBL_SIZE] = {
+	0x00010501, 0x01010101, 0x01000000, 0x00000000,
+	0x00010203, 0x04050607, 0x08090a0b
+};
+
+static const unsigned int hdctbl_chr[HDCTBL_SIZE] = {
+	0x00010501, 0x01010101, 0x01000000, 0x00000000,
+	0x00010203, 0x04050607, 0x08090a0b
+};
+
+static const unsigned int hactbl_lum[HACTBL_SIZE] = {
+	0x00020103, 0x03020403, 0x05050404, 0x0000017d, 0x01020300, 0x04110512,
+	0x21314106, 0x13516107,	0x22711432, 0x8191a108, 0x2342b1c1, 0x1552d1f0,
+	0x24336272, 0x82090a16, 0x1718191a, 0x25262728, 0x292a3435, 0x36373839,
+	0x3a434445, 0x46474849, 0x4a535455, 0x56575859, 0x5a636465, 0x66676869,
+	0x6a737475, 0x76777879, 0x7a838485, 0x86878889, 0x8a929394, 0x95969798,
+	0x999aa2a3, 0xa4a5a6a7, 0xa8a9aab2, 0xb3b4b5b6, 0xb7b8b9ba, 0xc2c3c4c5,
+	0xc6c7c8c9, 0xcad2d3d4, 0xd5d6d7d8, 0xd9dae1e2, 0xe3e4e5e6, 0xe7e8e9ea,
+	0xf1f2f3f4, 0xf5f6f7f8, 0xf9fa0000
+};
+
+static const unsigned int hactbl_chr[HACTBL_SIZE] = {
+	0x00020103, 0x03020403, 0x05050404, 0x0000017d, 0x01020300, 0x04110512,
+	0x21314106, 0x13516107,	0x22711432, 0x8191a108, 0x2342b1c1, 0x1552d1f0,
+	0x24336272, 0x82090a16, 0x1718191a, 0x25262728, 0x292a3435, 0x36373839,
+	0x3a434445, 0x46474849, 0x4a535455, 0x56575859, 0x5a636465, 0x66676869,
+	0x6a737475, 0x76777879, 0x7a838485, 0x86878889, 0x8a929394, 0x95969798,
+	0x999aa2a3, 0xa4a5a6a7, 0xa8a9aab2, 0xb3b4b5b6, 0xb7b8b9ba, 0xc2c3c4c5,
+	0xc6c7c8c9, 0xcad2d3d4, 0xd5d6d7d8, 0xd9dae1e2, 0xe3e4e5e6, 0xe7e8e9ea,
+	0xf1f2f3f4, 0xf5f6f7f8, 0xf9fa0000
+};
+
+static struct jpu_ctx *ctrl_to_ctx(struct v4l2_ctrl *c)
+{
+	return container_of(c->handler, struct jpu_ctx, ctrl_handler);
+}
+
+static struct jpu_ctx *fh_to_ctx(struct v4l2_fh *fh)
+{
+	return container_of(fh, struct jpu_ctx, fh);
+}
+
+static void jpu_set_tbl(void __iomem *regs, const unsigned int *tbl,
+			unsigned int len) {
+	unsigned int i;
+
+	for (i = 0; i < len; i++)
+		iowrite32(tbl[i], regs + (i << 2));
+}
+
+static void jpu_set_qtbl(void __iomem *regs, unsigned short quality)
+{
+	jpu_set_tbl(regs + JCQTBL(0), qtbl_lum[quality], QTBL_SIZE);
+	jpu_set_tbl(regs + JCQTBL(1), qtbl_chr[quality], QTBL_SIZE);
+}
+
+static void jpu_set_htbl(void __iomem *regs)
+{
+	jpu_set_tbl(regs + JCHTBD(0), hdctbl_lum, HDCTBL_SIZE);
+	jpu_set_tbl(regs + JCHTBA(0), hactbl_lum, HACTBL_SIZE);
+	jpu_set_tbl(regs + JCHTBD(1), hdctbl_chr, HDCTBL_SIZE);
+	jpu_set_tbl(regs + JCHTBA(1), hactbl_chr, HACTBL_SIZE);
+}
+
+static void jpu_int_clear(void __iomem *regs, unsigned int int_status)
+{
+	iowrite32(~(int_status & JINTS_MASK), regs + JINTS);
+	if (int_status & (JINTS_HDR_PARSED | JINTS_ERR | JINTS_PROCESS_COMPL))
+		iowrite32(JCCMD_JEND, regs + JCCMD);
+}
+
+static int jpu_wait_reset(struct jpu *jpu)
+{
+	unsigned long timeout;
+
+	timeout = jiffies + msecs_to_jiffies(JPU_RESET_TIMEOUT);
+	while ((ioread32(jpu->regs + JCCMD) & JCCMD_SRST) != 0) {
+		if (time_after(jiffies, timeout)) {
+			dev_err(jpu->dev, "timed out in reset\n");
+			return -ETIMEDOUT;
+		}
+		schedule();
+	}
+
+	return 0;
+}
+
+static int jpu_reset(struct jpu *jpu)
+{
+	iowrite32(JCCMD_SRST, jpu->regs + JCCMD);
+	return jpu_wait_reset(jpu);
+}
+
+/*
+ * ============================================================================
+ * video ioctl operations
+ * ============================================================================
+ */
+static void put_qtbl(u8 *p, const unsigned int *qtbl)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(zigzag); i++)
+		*(p + i) = *((const u8 *)qtbl + zigzag[i]);
+}
+
+static void put_htbl(u8 *p, const u8 *htbl, unsigned int len)
+{
+	unsigned int i, j;
+
+	for (i = 0; i < len; i += 4)
+		for (j = 0; j < 4 && (i + j) < len; ++j)
+			p[i + j] = htbl[i + 3 - j];
+}
+
+static void jpu_generate_hdr(unsigned short quality, unsigned char *p)
+{
+	put_qtbl(p + JPU_JPEG_QTBL_LUM_OFFSET, qtbl_lum[quality]);
+	put_qtbl(p + JPU_JPEG_QTBL_CHR_OFFSET, qtbl_chr[quality]);
+
+	put_htbl(p + JPU_JPEG_HDCTBL_LUM_OFFSET, (const u8 *)hdctbl_lum,
+						JPU_JPEG_HDCTBL_SIZE);
+	put_htbl(p + JPU_JPEG_HACTBL_LUM_OFFSET, (const u8 *)hactbl_lum,
+						JPU_JPEG_HACTBL_SIZE);
+
+	put_htbl(p + JPU_JPEG_HDCTBL_CHR_OFFSET, (const u8 *)hdctbl_chr,
+						JPU_JPEG_HDCTBL_SIZE);
+	put_htbl(p + JPU_JPEG_HACTBL_CHR_OFFSET, (const u8 *)hactbl_chr,
+						JPU_JPEG_HACTBL_SIZE);
+}
+
+static int get_byte(struct jpeg_buffer *buf)
+{
+	if (buf->curr >= buf->size)
+		return -1;
+
+	return ((unsigned char *)buf->data)[buf->curr++];
+}
+
+static int get_word_be(struct jpeg_buffer *buf, unsigned int *word)
+{
+	unsigned int temp;
+	int byte;
+
+	byte = get_byte(buf);
+	if (byte == -1)
+		return -1;
+	temp = byte << 8;
+	byte = get_byte(buf);
+	if (byte == -1)
+		return -1;
+	*word = (unsigned int)byte | temp;
+	return 0;
+}
+
+static void skip(struct jpeg_buffer *buf, long len)
+{
+	if (len <= 0)
+		return;
+
+	while (len--)
+		get_byte(buf);
+}
+
+static bool jpu_parse_hdr(unsigned long buffer, unsigned long size,
+			  unsigned int *width, unsigned int *height,
+			  unsigned int *pixelformat)
+{
+	struct jpeg_buffer jpeg_buffer;
+	int components = 0;
+	bool found = false;
+	unsigned int word, subsampling = 0;
+	long length;
+
+	jpeg_buffer.size = size;
+	jpeg_buffer.data = buffer;
+	jpeg_buffer.curr = 0;
+
+	while (!found) {
+		int c = get_byte(&jpeg_buffer);
+
+		if (c == -1)
+			return false;
+		if (c != 0xff)
+			continue;
+		do
+			c = get_byte(&jpeg_buffer);
+		while (c == 0xff);
+		if (c == -1)
+			return false;
+		if (c == 0)
+			continue;
+		length = 0;
+		switch (c) {
+		/* SOF0: baseline JPEG */
+		case SOF0:
+			if (get_word_be(&jpeg_buffer, &word))
+				break;
+			if (get_byte(&jpeg_buffer) == -1)
+				break;
+			if (get_word_be(&jpeg_buffer, height))
+				break;
+			if (get_word_be(&jpeg_buffer, width))
+				break;
+			components = get_byte(&jpeg_buffer);
+			if (components == -1)
+				break;
+			found = true;
+
+			if (components == 1) {
+				subsampling = 0x33;
+			} else {
+				skip(&jpeg_buffer, 1);
+				subsampling = get_byte(&jpeg_buffer);
+				skip(&jpeg_buffer, 1);
+			}
+
+			skip(&jpeg_buffer, components * 2);
+			break;
+
+		/* skip payload-less markers */
+		case RST ... RST + 7:
+		case SOI:
+		case EOI:
+		case TEM:
+			break;
+
+		/* skip uninteresting payload markers */
+		default:
+			if (get_word_be(&jpeg_buffer, &word))
+				break;
+			length = (long)word - 2;
+			skip(&jpeg_buffer, length);
+			break;
+		}
+	}
+
+	/* subsampling -> pixelformat */
+	switch (subsampling) {
+	case JPU_JPEG_422: /* 422 */
+		*pixelformat = V4L2_PIX_FMT_NV16M;
+		break;
+	case JPU_JPEG_420:
+		*pixelformat = V4L2_PIX_FMT_NV12M;
+		break;
+	case 0x11: /* 444 */
+	case 0x33: /* GRAY */
+	default:
+		return false;
+	}
+
+	return found;
+}
+
+static int jpu_querycap(struct file *file, void *priv,
+			struct v4l2_capability *cap)
+{
+	struct jpu_ctx *ctx = fh_to_ctx(priv);
+
+	if (ctx->encoder)
+		strlcpy(cap->card, JPU_M2M_NAME " encoder",
+			sizeof(cap->card));
+	else
+		strlcpy(cap->card, JPU_M2M_NAME " decoder",
+			sizeof(cap->card));
+
+	strlcpy(cap->driver, JPU_M2M_NAME, sizeof(cap->driver));
+	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
+		 dev_name(ctx->jpu->dev));
+	cap->device_caps |= V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M_MPLANE;
+	cap->capabilities = V4L2_CAP_DEVICE_CAPS | cap->device_caps;
+	memset(cap->reserved, 0, sizeof(cap->reserved));
+
+	return 0;
+}
+
+static struct jpu_fmt *jpu_find_format(bool encoder, u32 pixelformat,
+				       unsigned int fmt_type)
+{
+	unsigned int i, fmt_flag;
+
+	if (encoder)
+		fmt_flag = (fmt_type == JPU_FMT_TYPE_OUTPUT) ? JPU_ENC_OUTPUT :
+							       JPU_ENC_CAPTURE;
+	else
+		fmt_flag = (fmt_type == JPU_FMT_TYPE_OUTPUT) ? JPU_DEC_OUTPUT :
+							       JPU_DEC_CAPTURE;
+
+	for (i = 0; i < ARRAY_SIZE(jpu_formats); i++) {
+		struct jpu_fmt *fmt = &jpu_formats[i];
+
+		if (fmt->fourcc == pixelformat && fmt->types & fmt_flag)
+			return fmt;
+	}
+
+	return NULL;
+}
+
+static int jpu_enum_fmt(struct v4l2_fmtdesc *f, u32 type)
+{
+	unsigned int i, num = 0;
+
+	for (i = 0; i < ARRAY_SIZE(jpu_formats); ++i) {
+		if (jpu_formats[i].types & type) {
+			if (num == f->index)
+				break;
+			++num;
+		}
+	}
+
+	if (i >= ARRAY_SIZE(jpu_formats))
+		return -EINVAL;
+
+	strlcpy(f->description, jpu_formats[i].name, sizeof(f->description));
+	f->pixelformat = jpu_formats[i].fourcc;
+
+	return 0;
+}
+
+static int jpu_enum_fmt_cap(struct file *file, void *priv,
+			    struct v4l2_fmtdesc *f)
+{
+	struct jpu_ctx *ctx = fh_to_ctx(priv);
+
+	return jpu_enum_fmt(f, (ctx->encoder ? JPU_ENC_CAPTURE :
+					       JPU_DEC_CAPTURE));
+}
+
+static int jpu_enum_fmt_out(struct file *file, void *priv,
+			    struct v4l2_fmtdesc *f)
+{
+	struct jpu_ctx *ctx = fh_to_ctx(priv);
+
+	return jpu_enum_fmt(f, (ctx->encoder ? JPU_ENC_OUTPUT :
+					       JPU_DEC_OUTPUT));
+}
+
+static struct jpu_q_data *jpu_get_q_data(struct jpu_ctx *ctx,
+					 enum v4l2_buf_type type)
+{
+	if (V4L2_TYPE_IS_OUTPUT(type))
+		return &ctx->out_q;
+	else
+		return &ctx->cap_q;
+}
+
+static void jpu_bound_align_image(u32 *w, unsigned int wmin, unsigned int wmax,
+				  unsigned int walign, u32 *h,
+				  unsigned int hmin, unsigned int hmax,
+				  unsigned int halign)
+{
+	unsigned int width, height, w_step, h_step;
+
+	width = *w;
+	height = *h;
+
+	w_step = 1U << walign;
+	h_step = 1U << halign;
+	v4l_bound_align_image(w, wmin, wmax, walign, h, hmin, hmax, halign, 3);
+
+	if (*w < width && *w + w_step < wmax)
+		*w += w_step;
+	if (*h < height && *h + h_step < hmax)
+		*h += h_step;
+}
+
+static int __jpu_try_fmt(struct jpu_ctx *ctx,
+			 struct v4l2_pix_format_mplane *pix,
+			 enum v4l2_buf_type type, struct jpu_fmt **fmtinfo)
+{
+	struct jpu_fmt *fmt;
+	unsigned int f_type, w, h;
+
+	f_type = V4L2_TYPE_IS_OUTPUT(type) ? JPU_FMT_TYPE_OUTPUT :
+						JPU_FMT_TYPE_CAPTURE;
+
+	fmt = jpu_find_format(ctx->encoder, pix->pixelformat, f_type);
+	if (!fmt) {
+		unsigned int pixelformat;
+
+		pr_debug("unknown format; set default format\n");
+		if (ctx->encoder)
+			pixelformat = (f_type == JPU_FMT_TYPE_OUTPUT) ?
+				V4L2_PIX_FMT_NV16M : V4L2_PIX_FMT_JPEG;
+		else
+			pixelformat = (f_type == JPU_FMT_TYPE_CAPTURE) ?
+				V4L2_PIX_FMT_NV16M : V4L2_PIX_FMT_JPEG;
+		fmt = jpu_find_format(ctx->encoder, pixelformat, f_type);
+	}
+
+	pix->pixelformat = fmt->fourcc;
+	pix->colorspace = fmt->colorspace;
+	pix->field = V4L2_FIELD_NONE;
+	pix->num_planes = fmt->num_planes;
+	memset(pix->reserved, 0, sizeof(pix->reserved));
+
+	jpu_bound_align_image(&pix->width, JPU_WIDTH_MIN, JPU_WIDTH_MAX,
+			      fmt->h_align, &pix->height, JPU_HEIGHT_MIN,
+			      JPU_HEIGHT_MAX, fmt->v_align);
+
+	w = pix->width;
+	h = pix->height;
+
+	if (fmt->fourcc == V4L2_PIX_FMT_JPEG) {
+		if (pix->plane_fmt[0].sizeimage <= 0)
+			pix->plane_fmt[0].sizeimage = JPU_JPEG_HDR_SIZE +
+					(JPU_JPEG_MAX_BITS_PER_PIXEL * w * h);
+		pix->plane_fmt[0].bytesperline = 0;
+		memset(pix->plane_fmt[0].reserved, 0,
+		       sizeof(pix->plane_fmt[0].reserved));
+	} else {
+		unsigned int i;
+
+		for (i = 0; i < pix->num_planes; ++i) {
+			unsigned int bpl;
+			unsigned int hsub = i > 0 ? fmt->subsampling >> 4 : 1;
+			unsigned int vsub = i > 0 ? fmt->subsampling & 0xf : 1;
+
+			bpl = clamp_t(unsigned int,
+				      pix->plane_fmt[i].bytesperline,
+				      w / hsub * fmt->bpp[i] / 8,
+				      JPU_WIDTH_MAX);
+
+			pix->plane_fmt[i].bytesperline =
+					round_up(bpl, JPU_MEMALIGN);
+			pix->plane_fmt[i].sizeimage =
+				pix->plane_fmt[i].bytesperline * h / vsub;
+			memset(pix->plane_fmt[i].reserved, 0,
+			       sizeof(pix->plane_fmt[i].reserved));
+		}
+	}
+
+	if (fmtinfo)
+		*fmtinfo = fmt;
+
+	return 0;
+}
+
+static int jpu_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
+{
+	struct jpu_ctx *ctx = fh_to_ctx(priv);
+
+	if (!v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type))
+		return -EINVAL;
+
+	return __jpu_try_fmt(ctx, &f->fmt.pix_mp, f->type, NULL);
+}
+
+static int jpu_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
+{
+	struct vb2_queue *vq;
+	struct jpu_ctx *ctx = fh_to_ctx(priv);
+	struct jpu_fmt *fmtinfo;
+	struct jpu_q_data *q_data;
+	int ret;
+
+	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
+	if (!vq)
+		return -EINVAL;
+
+	if (vb2_is_busy(vq)) {
+		v4l2_err(&ctx->jpu->v4l2_dev, "%s queue busy\n", __func__);
+		return -EBUSY;
+	}
+
+	ret = __jpu_try_fmt(ctx, &f->fmt.pix_mp, f->type, &fmtinfo);
+	if (ret < 0)
+		return ret;
+
+	q_data = jpu_get_q_data(ctx, f->type);
+
+	q_data->format = f->fmt.pix_mp;
+	q_data->fmtinfo = fmtinfo;
+
+	return 0;
+}
+
+static int jpu_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
+{
+	struct jpu_q_data *q_data;
+	struct jpu_ctx *ctx = fh_to_ctx(priv);
+
+	if (!v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type))
+		return -EINVAL;
+
+	if (!V4L2_TYPE_IS_OUTPUT(f->type) && !ctx->encoder && !ctx->hdr_parsed)
+		return -EINVAL;
+
+	q_data = jpu_get_q_data(ctx, f->type);
+	f->fmt.pix_mp = q_data->format;
+
+	return 0;
+}
+
+static int jpu_g_selection(struct file *file, void *priv,
+			   struct v4l2_selection *s)
+{
+	struct jpu_ctx *ctx = fh_to_ctx(priv);
+
+	switch (s->target) {
+	case V4L2_SEL_TGT_CROP:
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+	case V4L2_SEL_TGT_COMPOSE:
+	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
+		s->r.width = ctx->out_q.format.width;
+		s->r.height = ctx->out_q.format.height;
+		break;
+	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
+	case V4L2_SEL_TGT_COMPOSE_PADDED:
+		s->r.width = ctx->cap_q.format.width;
+		s->r.height = ctx->cap_q.format.height;
+		break;
+	default:
+		return -EINVAL;
+	}
+	s->r.left = 0;
+	s->r.top = 0;
+	return 0;
+}
+
+/*
+ * V4L2 controls
+ */
+static int jpu_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct jpu_ctx *ctx = ctrl_to_ctx(ctrl);
+	unsigned long flags;
+
+	spin_lock_irqsave(&ctx->jpu->lock, flags);
+
+	if (ctrl->id == V4L2_CID_JPEG_COMPRESSION_QUALITY)
+		ctx->compr_quality = ctrl->val;
+
+	spin_unlock_irqrestore(&ctx->jpu->lock, flags);
+	return 0;
+}
+
+static const struct v4l2_ctrl_ops jpu_ctrl_ops = {
+	.s_ctrl		= jpu_s_ctrl,
+};
+
+static const struct v4l2_ioctl_ops jpu_ioctl_ops = {
+	.vidioc_querycap		= jpu_querycap,
+
+	.vidioc_enum_fmt_vid_cap_mplane = jpu_enum_fmt_cap,
+	.vidioc_enum_fmt_vid_out_mplane = jpu_enum_fmt_out,
+	.vidioc_g_fmt_vid_cap_mplane	= jpu_g_fmt,
+	.vidioc_g_fmt_vid_out_mplane	= jpu_g_fmt,
+	.vidioc_try_fmt_vid_cap_mplane	= jpu_try_fmt,
+	.vidioc_try_fmt_vid_out_mplane	= jpu_try_fmt,
+	.vidioc_s_fmt_vid_cap_mplane	= jpu_s_fmt,
+	.vidioc_s_fmt_vid_out_mplane	= jpu_s_fmt,
+
+	.vidioc_reqbufs			= v4l2_m2m_ioctl_reqbufs,
+	.vidioc_querybuf		= v4l2_m2m_ioctl_querybuf,
+	.vidioc_qbuf			= v4l2_m2m_ioctl_qbuf,
+	.vidioc_dqbuf			= v4l2_m2m_ioctl_dqbuf,
+	.vidioc_streamon		= v4l2_m2m_ioctl_streamon,
+	.vidioc_streamoff		= v4l2_m2m_ioctl_streamoff,
+
+	.vidioc_g_selection		= jpu_g_selection,
+	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe
+};
+
+static int jpu_controls_create(struct jpu_ctx *ctx)
+{
+	struct v4l2_ctrl *ctrl;
+	int ret;
+
+	v4l2_ctrl_handler_init(&ctx->ctrl_handler, 1);
+
+	ctrl = v4l2_ctrl_new_std(&ctx->ctrl_handler, &jpu_ctrl_ops,
+				 V4L2_CID_JPEG_COMPRESSION_QUALITY,
+				 0, JPU_MAX_QUALITY - 1, 1, 0);
+
+	if (ctx->ctrl_handler.error) {
+		ret = ctx->ctrl_handler.error;
+		goto error_free;
+	}
+
+	if (!ctx->encoder)
+		ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE
+			     | V4L2_CTRL_FLAG_READ_ONLY;
+
+	ret = v4l2_ctrl_handler_setup(&ctx->ctrl_handler);
+	if (ret < 0)
+		goto error_free;
+
+	return 0;
+
+error_free:
+	v4l2_ctrl_handler_free(&ctx->ctrl_handler);
+	return ret;
+}
+
+/*
+ * ============================================================================
+ * Queue operations
+ * ============================================================================
+ */
+static int jpu_queue_setup(struct vb2_queue *vq,
+			   const struct v4l2_format *fmt,
+			   unsigned int *nbuffers, unsigned int *nplanes,
+			   unsigned int sizes[], void *alloc_ctxs[])
+{
+	struct jpu_ctx *ctx = vb2_get_drv_priv(vq);
+	struct jpu_q_data *q_data;
+	unsigned int count = *nbuffers;
+	unsigned int i;
+
+	q_data = jpu_get_q_data(ctx, vq->type);
+
+	*nplanes = q_data->format.num_planes;
+
+	/*
+	 * Header is parsed during decoding and parsed information stored
+	 * in the context so we do not allow another buffer to overwrite it.
+	 * For now it works this way, but planned for alternation.
+	 */
+	if (!ctx->encoder)
+		count = 1;
+
+	*nbuffers = count;
+
+	for (i = 0; i < *nplanes; i++) {
+		sizes[i] = q_data->format.plane_fmt[i].sizeimage;
+		alloc_ctxs[i] = ctx->jpu->alloc_ctx;
+	}
+
+	return 0;
+}
+
+static int jpu_buf_prepare(struct vb2_buffer *vb)
+{
+	struct jpu_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct jpu_q_data *q_data;
+	unsigned int i;
+
+	q_data = jpu_get_q_data(ctx, vb->vb2_queue->type);
+
+	for (i = 0; i < q_data->format.num_planes; i++) {
+		unsigned long size = q_data->format.plane_fmt[i].sizeimage;
+
+		if (vb2_plane_size(vb, i) < size) {
+			pr_err("%s: data will not fit into plane (%lu < %lu)\n",
+			       __func__, vb2_plane_size(vb, i), size);
+			return -EINVAL;
+		}
+		vb2_set_plane_payload(vb, i, size);
+	}
+
+	return 0;
+}
+
+static void jpu_buf_queue(struct vb2_buffer *vb)
+{
+	struct jpu_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+
+	if (!ctx->encoder && V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type)) {
+		struct jpu_q_data *q_data;
+		void *buffer = vb2_plane_vaddr(vb, 0);
+		unsigned long buf_size = vb2_get_plane_payload(vb, 0);
+		unsigned int w, h, pixelformat;
+
+		ctx->hdr_parsed = jpu_parse_hdr((unsigned long)buffer,
+						buf_size, &w, &h, &pixelformat);
+
+		if (!ctx->hdr_parsed || w > JPU_WIDTH_MAX ||
+					w < JPU_WIDTH_MIN ||
+					h > JPU_HEIGHT_MAX ||
+					h < JPU_HEIGHT_MIN) {
+			pr_err("incompatible or corrupted JPEG data\n");
+			vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
+			return;
+		}
+
+		q_data = &ctx->out_q;
+		q_data->format.width = w;
+		q_data->format.height = h;
+
+		q_data = &ctx->cap_q;
+		q_data->format.width = w;
+		q_data->format.height = h;
+
+		q_data->format.pixelformat = pixelformat;
+		__jpu_try_fmt(ctx, &q_data->format,
+			      V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE,
+			      &q_data->fmtinfo);
+	}
+
+	if (ctx->fh.m2m_ctx)
+		v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vb);
+}
+
+static int jpu_start_streaming(struct vb2_queue *q, unsigned int count)
+{
+	return 0;
+}
+
+static void jpu_stop_streaming(struct vb2_queue *q)
+{
+}
+
+static struct vb2_ops jpu_qops = {
+	.queue_setup		= jpu_queue_setup,
+	.buf_prepare		= jpu_buf_prepare,
+	.buf_queue		= jpu_buf_queue,
+	.wait_prepare		= vb2_ops_wait_prepare,
+	.wait_finish		= vb2_ops_wait_finish,
+	.start_streaming	= jpu_start_streaming,
+	.stop_streaming		= jpu_stop_streaming,
+};
+
+static int jpu_queue_init(void *priv, struct vb2_queue *src_vq,
+			  struct vb2_queue *dst_vq)
+{
+	struct jpu_ctx *ctx = priv;
+	int ret;
+
+	memset(src_vq, 0, sizeof(*src_vq));
+	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
+	src_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
+	src_vq->drv_priv = ctx;
+	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+	src_vq->ops = &jpu_qops;
+	src_vq->mem_ops = &vb2_dma_contig_memops;
+	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	src_vq->lock = &ctx->jpu->mutex;
+
+	ret = vb2_queue_init(src_vq);
+	if (ret)
+		return ret;
+
+	memset(dst_vq, 0, sizeof(*dst_vq));
+	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+	dst_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
+	dst_vq->drv_priv = ctx;
+	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+	dst_vq->ops = &jpu_qops;
+	dst_vq->mem_ops = &vb2_dma_contig_memops;
+	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	dst_vq->lock = &ctx->jpu->mutex;
+
+	return vb2_queue_init(dst_vq);
+}
+
+/*
+ * ============================================================================
+ * Device file operations
+ * ============================================================================
+ */
+static int jpu_open(struct file *file)
+{
+	struct jpu *jpu = video_drvdata(file);
+	struct video_device *vfd = video_devdata(file);
+	struct jpu_ctx *ctx;
+	int ret;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	if (mutex_lock_interruptible(&jpu->mutex)) {
+		ret = -ERESTARTSYS;
+		goto free;
+	}
+
+	v4l2_fh_init(&ctx->fh, vfd);
+	ctx->fh.ctrl_handler = &ctx->ctrl_handler;
+	file->private_data = &ctx->fh;
+	v4l2_fh_add(&ctx->fh);
+
+	ctx->jpu = jpu;
+	ctx->encoder = (vfd == jpu->vfd_encoder);
+
+	__jpu_try_fmt(ctx, &ctx->out_q.format,
+		      V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE, &ctx->out_q.fmtinfo);
+	__jpu_try_fmt(ctx, &ctx->cap_q.format,
+		      V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE, &ctx->cap_q.fmtinfo);
+
+	ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(jpu->m2m_dev, ctx, jpu_queue_init);
+	if (IS_ERR(ctx->fh.m2m_ctx)) {
+		ret = PTR_ERR(ctx->fh.m2m_ctx);
+		goto error;
+	}
+
+	ret = jpu_controls_create(ctx);
+	if (ret < 0)
+		goto error;
+
+	if (jpu->ref_count == 0) {
+		ret = clk_prepare_enable(jpu->clk);
+		if (ret < 0)
+			goto error;
+		/* ...issue software reset */
+		ret = jpu_reset(jpu);
+		if (ret)
+			goto error;
+	}
+
+	jpu->ref_count++;
+
+	mutex_unlock(&jpu->mutex);
+	return 0;
+
+error:
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+	mutex_unlock(&jpu->mutex);
+free:
+	kfree(ctx);
+	return ret;
+}
+
+static int jpu_release(struct file *file)
+{
+	struct jpu *jpu = video_drvdata(file);
+	struct jpu_ctx *ctx = fh_to_ctx(file->private_data);
+
+	mutex_lock(&jpu->mutex);
+	if (--jpu->ref_count == 0)
+		clk_disable_unprepare(jpu->clk);
+	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
+	v4l2_ctrl_handler_free(&ctx->ctrl_handler);
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+	kfree(ctx);
+	mutex_unlock(&jpu->mutex);
+
+	return 0;
+}
+
+static const struct v4l2_file_operations jpu_fops = {
+	.owner		= THIS_MODULE,
+	.open		= jpu_open,
+	.release	= jpu_release,
+	.unlocked_ioctl	= video_ioctl2,
+	.poll		= v4l2_m2m_fop_poll,
+	.mmap		= v4l2_m2m_fop_mmap,
+};
+
+/*
+ * ============================================================================
+ * mem2mem callbacks
+ * ============================================================================
+ */
+static void jpu_cleanup(struct jpu_ctx *ctx)
+{
+	/* remove current buffers and finish job */
+	struct vb2_buffer *src_buf, *dst_buf;
+
+	src_buf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
+	dst_buf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
+
+	v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_ERROR);
+	v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_ERROR);
+
+	v4l2_m2m_job_finish(ctx->jpu->m2m_dev, ctx->fh.m2m_ctx);
+
+	/* ...and give it a chance on next run */
+	iowrite32(JCCMD_SRST, ctx->jpu->regs + JCCMD);
+}
+
+static void jpu_device_run(void *priv)
+{
+	struct jpu_ctx *ctx = priv;
+	struct jpu *jpu = ctx->jpu;
+	struct vb2_buffer *src_buf, *dst_buf;
+	unsigned int bpl;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ctx->jpu->lock, flags);
+
+	src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
+	dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
+
+	if (ctx->encoder) {
+		unsigned long src_1_addr, src_2_addr, dst_addr;
+		unsigned int redu, inft, w, h;
+		u8 *dst_vaddr;
+		struct jpu_q_data *q_data = &ctx->out_q;
+		unsigned char subsampling = q_data->fmtinfo->subsampling;
+
+		src_1_addr = vb2_dma_contig_plane_dma_addr(src_buf, 0);
+		src_2_addr = vb2_dma_contig_plane_dma_addr(src_buf, 1);
+
+		dst_addr = vb2_dma_contig_plane_dma_addr(dst_buf, 0);
+		dst_vaddr = vb2_plane_vaddr(dst_buf, 0);
+
+		w = q_data->format.width;
+		h = q_data->format.height;
+		bpl = q_data->format.plane_fmt[0].bytesperline;
+
+		memcpy(dst_vaddr, jpeg_hdrs[ctx->compr_quality],
+			JPU_JPEG_HDR_SIZE);
+		*(u16 *)(dst_vaddr + JPU_JPEG_HEIGHT_OFFSET) = cpu_to_be16(h);
+		*(u16 *)(dst_vaddr + JPU_JPEG_WIDTH_OFFSET) = cpu_to_be16(w);
+		*(dst_vaddr + JPU_JPEG_SUBS_OFFSET) = subsampling;
+
+		if (subsampling == JPU_JPEG_420) {
+			redu = JCMOD_REDU_420;
+			inft = JIFECNT_INFT_420;
+		} else {
+			redu = JCMOD_REDU_422;
+			inft = JIFECNT_INFT_422;
+		}
+
+		/* ...wait until module reset completes */
+		if (jpu_wait_reset(jpu)) {
+			jpu_cleanup(ctx);
+			goto error;
+		}
+
+		/* the only no marker mode works for encoding */
+		iowrite32(JCMOD_DSP_ENC | JCMOD_PCTR | redu |
+			  JCMOD_MSKIP_ENABLE, jpu->regs + JCMOD);
+
+		iowrite32(JIFECNT_SWAP_WB | inft, jpu->regs + JIFECNT);
+		iowrite32(JIFDCNT_SWAP_WB, jpu->regs + JIFDCNT);
+		iowrite32(JINTE_TRANSF_COMPL, jpu->regs + JINTE);
+
+		/* Y and C components source addresses */
+		iowrite32(src_1_addr, jpu->regs + JIFESYA1);
+		iowrite32(src_2_addr, jpu->regs + JIFESCA1);
+
+		/* memory width */
+		iowrite32(bpl, jpu->regs + JIFESMW);
+
+		iowrite32((w >> 8) & JCSZ_MASK, jpu->regs + JCHSZU);
+		iowrite32(w & JCSZ_MASK, jpu->regs + JCHSZD);
+
+		iowrite32((h >> 8) & JCSZ_MASK, jpu->regs + JCVSZU);
+		iowrite32(h & JCSZ_MASK, jpu->regs + JCVSZD);
+
+		iowrite32(w, jpu->regs + JIFESHSZ);
+		iowrite32(h, jpu->regs + JIFESVSZ);
+
+		iowrite32(dst_addr + JPU_JPEG_HDR_SIZE, jpu->regs + JIFEDA1);
+
+		iowrite32(0 << JCQTN_SHIFT(1) | 1 << JCQTN_SHIFT(2) |
+			  1 << JCQTN_SHIFT(3), jpu->regs + JCQTN);
+
+		iowrite32(0 << JCHTN_AC_SHIFT(1) | 0 << JCHTN_DC_SHIFT(1) |
+			  1 << JCHTN_AC_SHIFT(2) | 1 << JCHTN_DC_SHIFT(2) |
+			  1 << JCHTN_AC_SHIFT(3) | 1 << JCHTN_DC_SHIFT(3),
+			  jpu->regs + JCHTN);
+
+		jpu_set_qtbl(jpu->regs, ctx->compr_quality);
+		jpu_set_htbl(jpu->regs);
+	} else {
+		unsigned long src_addr, dst_1_addr, dst_2_addr;
+
+		bpl = ctx->cap_q.format.plane_fmt[0].bytesperline;
+
+		src_addr = vb2_dma_contig_plane_dma_addr(src_buf, 0);
+		dst_1_addr = vb2_dma_contig_plane_dma_addr(dst_buf, 0);
+		dst_2_addr = vb2_dma_contig_plane_dma_addr(dst_buf, 1);
+
+		/* ...wait until module reset completes */
+		if (jpu_wait_reset(jpu)) {
+			jpu_cleanup(ctx);
+			goto error;
+		}
+
+		/* ...set up decoder operation */
+		iowrite32(JCMOD_DSP_DEC | JCMOD_PCTR, jpu->regs + JCMOD);
+		iowrite32(JIFECNT_SWAP_WB, jpu->regs + JIFECNT);
+		iowrite32(JIFDCNT_SWAP_WB, jpu->regs + JIFDCNT);
+
+		/* ...enable interrupts on transfer completion and d-g error */
+		iowrite32(JINTE_TRANSF_COMPL | JINTE_ERR, jpu->regs + JINTE);
+
+		/* ...set source/destination addresses of encoded data */
+		iowrite32(src_addr, jpu->regs + JIFDSA1);
+		iowrite32(dst_1_addr, jpu->regs + JIFDDYA1);
+		iowrite32(dst_2_addr, jpu->regs + JIFDDCA1);
+
+		/* iowrite32(w, jpu->regs + JIFDDMW); */
+		iowrite32(bpl, jpu->regs + JIFDDMW);
+	}
+
+	/* ...start encoder/decoder operation */
+	iowrite32(JCCMD_JSRT, jpu->regs + JCCMD);
+
+error:
+	spin_unlock_irqrestore(&ctx->jpu->lock, flags);
+}
+
+static int jpu_job_ready(void *priv)
+{
+	struct jpu_ctx *ctx = priv;
+
+	if (!ctx->encoder)
+		return ctx->hdr_parsed;
+
+	return 1;
+}
+
+static void jpu_job_abort(void *priv)
+{
+}
+
+static struct v4l2_m2m_ops jpu_m2m_ops = {
+	.device_run	= jpu_device_run,
+	.job_ready	= jpu_job_ready,
+	.job_abort	= jpu_job_abort,
+};
+
+/*
+ * ============================================================================
+ * IRQ handler
+ * ============================================================================
+ */
+static irqreturn_t jpu_irq_handler(int irq, void *dev_id)
+{
+	struct jpu *jpu = dev_id;
+	struct jpu_ctx *curr_ctx;
+	struct vb2_buffer *src_buf, *dst_buf;
+	unsigned long payload_size = 0;
+	unsigned int int_status, expected_ints;
+	unsigned int error;
+
+	spin_lock(&jpu->lock);
+
+	int_status = ioread32(jpu->regs + JINTS);
+	if (!int_status) {
+		pr_err("spurious interrupt\n");
+		spin_unlock(&jpu->lock);
+		return IRQ_NONE;
+	}
+
+	jpu_int_clear(jpu->regs, int_status);
+
+	/*
+	 * In any mode (decoding/encoding) we can additionally get
+	 * error status (5th bit)
+	 * jpu operation complete status (6th bit)
+	 */
+	expected_ints = ioread32(jpu->regs + JINTE) | JINTS_ERR
+						    | JINTS_PROCESS_COMPL;
+	if (!(expected_ints & int_status)) {
+		pr_err("spurious interrupt: %#X vs %#X (expected)\n",
+			int_status, expected_ints);
+		spin_unlock(&jpu->lock);
+		return IRQ_NONE;
+	}
+
+	if ((int_status & JINTS_PROCESS_COMPL) &&
+	   !(int_status & JINTS_TRANSF_COMPL))
+		goto handled;
+
+	curr_ctx = v4l2_m2m_get_curr_priv(jpu->m2m_dev);
+	if (!curr_ctx) {
+		/* ...instance is not running */
+		pr_err("no active context for m2m\n");
+		goto handled;
+	}
+
+	src_buf = v4l2_m2m_src_buf_remove(curr_ctx->fh.m2m_ctx);
+	dst_buf = v4l2_m2m_dst_buf_remove(curr_ctx->fh.m2m_ctx);
+
+	if (int_status & JINTS_TRANSF_COMPL) {
+		if (curr_ctx->encoder) {
+			payload_size = ioread32(jpu->regs + JCDTCU) << 16 |
+				       ioread32(jpu->regs + JCDTCM) << 8  |
+				       ioread32(jpu->regs + JCDTCD);
+			vb2_set_plane_payload(dst_buf, 0,
+				payload_size + JPU_JPEG_HDR_SIZE);
+		}
+
+		dst_buf->v4l2_buf.timecode = src_buf->v4l2_buf.timecode;
+		dst_buf->v4l2_buf.timestamp = src_buf->v4l2_buf.timestamp;
+		dst_buf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+		dst_buf->v4l2_buf.flags |=
+		    src_buf->v4l2_buf.flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+
+		v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_DONE);
+		v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_DONE);
+
+	} else if (int_status & JINTS_ERR) {
+			error = ioread32(jpu->regs + JCDERR);
+
+			pr_debug("processing error: %#X\n", error);
+
+			v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_ERROR);
+			v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_ERROR);
+	}
+
+	/* ...reset JPU after completion */
+	iowrite32(JCCMD_SRST, jpu->regs + JCCMD);
+	v4l2_m2m_job_finish(jpu->m2m_dev, curr_ctx->fh.m2m_ctx);
+
+handled:
+	spin_unlock(&jpu->lock);
+	return IRQ_HANDLED;
+}
+
+/*
+ * ============================================================================
+ * Driver basic infrastructure
+ * ============================================================================
+ */
+static const struct of_device_id jpu_dt_ids[] = {
+	{ .compatible = "renesas,jpu-r8a7790" }, /* H2 */
+	{ .compatible = "renesas,jpu-r8a7791" }, /* M2-W */
+	{ .compatible = "renesas,jpu-r8a7792" }, /* V2H */
+	{ .compatible = "renesas,jpu-r8a7793" }, /* M2-N */
+	{ },
+};
+MODULE_DEVICE_TABLE(of, jpu_dt_ids);
+
+static int jpu_probe(struct platform_device *pdev)
+{
+	struct jpu *jpu;
+	struct resource *res;
+	int ret;
+	unsigned short i;
+
+	jpu = devm_kzalloc(&pdev->dev, sizeof(struct jpu), GFP_KERNEL);
+	if (!jpu)
+		return -ENOMEM;
+
+	mutex_init(&jpu->mutex);
+	spin_lock_init(&jpu->lock);
+	jpu->dev = &pdev->dev;
+
+	/* memory-mapped registers */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	jpu->regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(jpu->regs))
+		return PTR_ERR(jpu->regs);
+
+	/* interrupt service routine registration */
+	jpu->irq = ret = platform_get_irq(pdev, 0);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "cannot find IRQ\n");
+		return ret;
+	}
+
+	ret = devm_request_irq(&pdev->dev, jpu->irq, jpu_irq_handler, 0,
+			       dev_name(&pdev->dev), jpu);
+	if (ret) {
+		dev_err(&pdev->dev, "cannot claim IRQ %d\n", jpu->irq);
+		return ret;
+	}
+
+	/* clocks */
+	jpu->clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(jpu->clk)) {
+		dev_err(&pdev->dev, "cannot get clock\n");
+		return PTR_ERR(jpu->clk);
+	}
+
+	/* v4l2 device */
+	ret = v4l2_device_register(&pdev->dev, &jpu->v4l2_dev);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to register v4l2 device\n");
+		return ret;
+	}
+
+	/* mem2mem device */
+	jpu->m2m_dev = v4l2_m2m_init(&jpu_m2m_ops);
+	if (IS_ERR(jpu->m2m_dev)) {
+		v4l2_err(&jpu->v4l2_dev, "Failed to init mem2mem device\n");
+		ret = PTR_ERR(jpu->m2m_dev);
+		goto device_register_rollback;
+	}
+
+	jpu->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
+	if (IS_ERR(jpu->alloc_ctx)) {
+		v4l2_err(&jpu->v4l2_dev, "Failed to init memory allocator\n");
+		ret = PTR_ERR(jpu->alloc_ctx);
+		goto m2m_init_rollback;
+	}
+
+	/* JPEG encoder /dev/videoX node */
+	jpu->vfd_encoder = video_device_alloc();
+	if (!jpu->vfd_encoder) {
+		v4l2_err(&jpu->v4l2_dev, "Failed to allocate video device\n");
+		ret = -ENOMEM;
+		goto vb2_allocator_rollback;
+	}
+	strlcpy(jpu->vfd_encoder->name, JPU_M2M_NAME,
+		sizeof(jpu->vfd_encoder->name));
+	jpu->vfd_encoder->fops		= &jpu_fops;
+	jpu->vfd_encoder->ioctl_ops	= &jpu_ioctl_ops;
+	jpu->vfd_encoder->minor		= -1;
+	jpu->vfd_encoder->release	= video_device_release;
+	jpu->vfd_encoder->lock		= &jpu->mutex;
+	jpu->vfd_encoder->v4l2_dev	= &jpu->v4l2_dev;
+	jpu->vfd_encoder->vfl_dir	= VFL_DIR_M2M;
+
+	ret = video_register_device(jpu->vfd_encoder, VFL_TYPE_GRABBER, -1);
+	if (ret) {
+		v4l2_err(&jpu->v4l2_dev, "Failed to register video device\n");
+		goto enc_vdev_alloc_rollback;
+	}
+
+	video_set_drvdata(jpu->vfd_encoder, jpu);
+	v4l2_info(&jpu->v4l2_dev, "encoder device registered as /dev/video%d\n",
+		  jpu->vfd_encoder->num);
+
+	/* JPEG decoder /dev/videoX node */
+	jpu->vfd_decoder = video_device_alloc();
+	if (!jpu->vfd_decoder) {
+		v4l2_err(&jpu->v4l2_dev, "Failed to allocate video device\n");
+		ret = -ENOMEM;
+		goto enc_vdev_register_rollback;
+	}
+	strlcpy(jpu->vfd_decoder->name, JPU_M2M_NAME,
+		sizeof(jpu->vfd_decoder->name));
+	jpu->vfd_decoder->fops		= &jpu_fops;
+	jpu->vfd_decoder->ioctl_ops	= &jpu_ioctl_ops;
+	jpu->vfd_decoder->minor		= -1;
+	jpu->vfd_decoder->release	= video_device_release;
+	jpu->vfd_decoder->lock		= &jpu->mutex;
+	jpu->vfd_decoder->v4l2_dev	= &jpu->v4l2_dev;
+	jpu->vfd_decoder->vfl_dir	= VFL_DIR_M2M;
+
+	ret = video_register_device(jpu->vfd_decoder, VFL_TYPE_GRABBER, -1);
+	if (ret) {
+		v4l2_err(&jpu->v4l2_dev, "Failed to register video device\n");
+		goto dec_vdev_alloc_rollback;
+	}
+
+	video_set_drvdata(jpu->vfd_decoder, jpu);
+	v4l2_info(&jpu->v4l2_dev, "decoder device registered as /dev/video%d\n",
+			  jpu->vfd_decoder->num);
+
+	/* final statements & power management */
+	platform_set_drvdata(pdev, jpu);
+
+	/* fill in qantization and huffman tables */
+	for (i = 0; i < JPU_MAX_QUALITY; i++)
+		jpu_generate_hdr(i, (unsigned char *)jpeg_hdrs[i]);
+
+	v4l2_info(&jpu->v4l2_dev, "Renesas JPEG codec\n");
+
+	return 0;
+
+dec_vdev_alloc_rollback:
+	video_device_release(jpu->vfd_decoder);
+
+enc_vdev_register_rollback:
+	video_unregister_device(jpu->vfd_encoder);
+
+enc_vdev_alloc_rollback:
+	video_device_release(jpu->vfd_encoder);
+
+vb2_allocator_rollback:
+	vb2_dma_contig_cleanup_ctx(jpu->alloc_ctx);
+
+m2m_init_rollback:
+	v4l2_m2m_release(jpu->m2m_dev);
+
+device_register_rollback:
+	v4l2_device_unregister(&jpu->v4l2_dev);
+
+	return ret;
+}
+
+static int jpu_remove(struct platform_device *pdev)
+{
+	struct jpu *jpu = platform_get_drvdata(pdev);
+
+	video_unregister_device(jpu->vfd_decoder);
+	video_device_release(jpu->vfd_decoder);
+	video_unregister_device(jpu->vfd_encoder);
+	video_device_release(jpu->vfd_encoder);
+	vb2_dma_contig_cleanup_ctx(jpu->alloc_ctx);
+	v4l2_m2m_release(jpu->m2m_dev);
+	v4l2_device_unregister(&jpu->v4l2_dev);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int jpu_suspend(struct device *dev)
+{
+	struct jpu *jpu = dev_get_drvdata(dev);
+
+	if (jpu->ref_count == 0)
+		return 0;
+
+	clk_disable_unprepare(jpu->clk);
+
+	return 0;
+}
+
+static int jpu_resume(struct device *dev)
+{
+	struct jpu *jpu = dev_get_drvdata(dev);
+
+	if (jpu->ref_count == 0)
+		return 0;
+
+	clk_prepare_enable(jpu->clk);
+
+	return 0;
+}
+#endif
+
+static const struct dev_pm_ops jpu_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(jpu_suspend, jpu_resume)
+};
+
+static struct platform_driver jpu_driver = {
+	.probe = jpu_probe,
+	.remove = jpu_remove,
+	.driver = {
+		.of_match_table = jpu_dt_ids,
+		.name = JPU_M2M_NAME,
+		.pm = &jpu_pm_ops,
+	},
+};
+
+module_platform_driver(jpu_driver);
+
+MODULE_ALIAS("jpu");
+MODULE_AUTHOR("Mikhail Ulianov <mikhail.ulyanov@cogentembedded.com>");
+MODULE_DESCRIPTION("Renesas JPEG codec driver");
+MODULE_LICENSE("GPL v2");
--
2.1.4

