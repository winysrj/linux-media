Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46723 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080AbaGWP3n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jul 2014 11:29:43 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 2/8] [media] coda: move defines, enums, and structs into shared header
Date: Wed, 23 Jul 2014 17:28:39 +0200
Message-Id: <1406129325-10771-3-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1406129325-10771-1-git-send-email-p.zabel@pengutronix.de>
References: <1406129325-10771-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These will have to be shared between multiple code files.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 193 +-------------------------
 drivers/media/platform/coda/coda.h        | 216 ++++++++++++++++++++++++++++++
 2 files changed, 219 insertions(+), 190 deletions(-)
 create mode 100644 drivers/media/platform/coda/coda.h

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 1f68201..4649395 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -38,6 +38,7 @@
 #include <media/videobuf2-core.h>
 #include <media/videobuf2-dma-contig.h>
 
+#include "coda.h"
 #include "coda_regs.h"
 
 #define CODA_NAME		"coda"
@@ -50,10 +51,6 @@
 #define CODA7_PS_BUF_SIZE	0x28000
 #define CODA9_PS_SAVE_SIZE	(512 * 1024)
 
-#define CODA_MAX_FRAMEBUFFERS	8
-
-#define CODA_MAX_FRAME_SIZE	0x100000
-#define FMO_SLICE_SAVE_BUF_SIZE         (32)
 #define CODA_DEFAULT_GAMMA		4096
 #define CODA9_DEFAULT_GAMMA		24576	/* 0.75 * 32768 */
 
@@ -70,207 +67,23 @@ static int coda_debug;
 module_param(coda_debug, int, 0644);
 MODULE_PARM_DESC(coda_debug, "Debug level (0-1)");
 
-enum {
-	V4L2_M2M_SRC = 0,
-	V4L2_M2M_DST = 1,
-};
-
-enum coda_inst_type {
-	CODA_INST_ENCODER,
-	CODA_INST_DECODER,
-};
-
-enum coda_product {
-	CODA_DX6 = 0xf001,
-	CODA_7541 = 0xf012,
-	CODA_960 = 0xf020,
-};
-
 struct coda_fmt {
 	char *name;
 	u32 fourcc;
 };
 
-struct coda_codec {
-	u32 mode;
-	u32 src_fourcc;
-	u32 dst_fourcc;
-	u32 max_w;
-	u32 max_h;
-};
-
-struct coda_devtype {
-	char			*firmware;
-	enum coda_product	product;
-	const struct coda_codec	*codecs;
-	unsigned int		num_codecs;
-	size_t			workbuf_size;
-	size_t			tempbuf_size;
-	size_t			iram_size;
-};
-
-/* Per-queue, driver-specific private data */
-struct coda_q_data {
-	unsigned int		width;
-	unsigned int		height;
-	unsigned int		bytesperline;
-	unsigned int		sizeimage;
-	unsigned int		fourcc;
-	struct v4l2_rect	rect;
-};
-
-struct coda_aux_buf {
-	void			*vaddr;
-	dma_addr_t		paddr;
-	u32			size;
-	struct debugfs_blob_wrapper blob;
-	struct dentry		*dentry;
-};
-
-struct coda_dev {
-	struct v4l2_device	v4l2_dev;
-	struct video_device	vfd[2];
-	struct platform_device	*plat_dev;
-	const struct coda_devtype *devtype;
-
-	void __iomem		*regs_base;
-	struct clk		*clk_per;
-	struct clk		*clk_ahb;
-	struct reset_control	*rstc;
-
-	struct coda_aux_buf	codebuf;
-	struct coda_aux_buf	tempbuf;
-	struct coda_aux_buf	workbuf;
-	struct gen_pool		*iram_pool;
-	struct coda_aux_buf	iram;
-
-	spinlock_t		irqlock;
-	struct mutex		dev_mutex;
-	struct mutex		coda_mutex;
-	struct workqueue_struct	*workqueue;
-	struct v4l2_m2m_dev	*m2m_dev;
-	struct vb2_alloc_ctx	*alloc_ctx;
-	struct list_head	instances;
-	unsigned long		instance_mask;
-	struct dentry		*debugfs_root;
-};
-
-struct coda_params {
-	u8			rot_mode;
-	u8			h264_intra_qp;
-	u8			h264_inter_qp;
-	u8			h264_min_qp;
-	u8			h264_max_qp;
-	u8			h264_deblk_enabled;
-	u8			h264_deblk_alpha;
-	u8			h264_deblk_beta;
-	u8			mpeg4_intra_qp;
-	u8			mpeg4_inter_qp;
-	u8			gop_size;
-	int			intra_refresh;
-	int			codec_mode;
-	int			codec_mode_aux;
-	enum v4l2_mpeg_video_multi_slice_mode slice_mode;
-	u32			framerate;
-	u16			bitrate;
-	u32			slice_max_bits;
-	u32			slice_max_mb;
-};
-
-struct coda_iram_info {
-	u32		axi_sram_use;
-	phys_addr_t	buf_bit_use;
-	phys_addr_t	buf_ip_ac_dc_use;
-	phys_addr_t	buf_dbk_y_use;
-	phys_addr_t	buf_dbk_c_use;
-	phys_addr_t	buf_ovl_use;
-	phys_addr_t	buf_btp_use;
-	phys_addr_t	search_ram_paddr;
-	int		search_ram_size;
-	int		remaining;
-	phys_addr_t	next_paddr;
-};
-
-struct gdi_tiled_map {
-	int xy2ca_map[16];
-	int xy2ba_map[16];
-	int xy2ra_map[16];
-	int rbc2axi_map[32];
-	int xy2rbc_config;
-	int map_type;
-#define GDI_LINEAR_FRAME_MAP 0
-};
-
-struct coda_timestamp {
-	struct list_head	list;
-	u32			sequence;
-	struct v4l2_timecode	timecode;
-	struct timeval		timestamp;
-};
-
-struct coda_ctx {
-	struct coda_dev			*dev;
-	struct mutex			buffer_mutex;
-	struct list_head		list;
-	struct work_struct		pic_run_work;
-	struct work_struct		seq_end_work;
-	struct completion		completion;
-	int				aborting;
-	int				initialized;
-	int				streamon_out;
-	int				streamon_cap;
-	u32				isequence;
-	u32				qsequence;
-	u32				osequence;
-	u32				sequence_offset;
-	struct coda_q_data		q_data[2];
-	enum coda_inst_type		inst_type;
-	const struct coda_codec		*codec;
-	enum v4l2_colorspace		colorspace;
-	struct coda_params		params;
-	struct v4l2_ctrl_handler	ctrls;
-	struct v4l2_fh			fh;
-	int				gopcounter;
-	int				runcounter;
-	char				vpu_header[3][64];
-	int				vpu_header_size[3];
-	struct kfifo			bitstream_fifo;
-	struct mutex			bitstream_mutex;
-	struct coda_aux_buf		bitstream;
-	bool				hold;
-	struct coda_aux_buf		parabuf;
-	struct coda_aux_buf		psbuf;
-	struct coda_aux_buf		slicebuf;
-	struct coda_aux_buf		internal_frames[CODA_MAX_FRAMEBUFFERS];
-	u32				frame_types[CODA_MAX_FRAMEBUFFERS];
-	struct coda_timestamp		frame_timestamps[CODA_MAX_FRAMEBUFFERS];
-	u32				frame_errors[CODA_MAX_FRAMEBUFFERS];
-	struct list_head		timestamp_list;
-	struct coda_aux_buf		workbuf;
-	int				num_internal_frames;
-	int				idx;
-	int				reg_idx;
-	struct coda_iram_info		iram_info;
-	struct gdi_tiled_map		tiled_map;
-	u32				bit_stream_param;
-	u32				frm_dis_flg;
-	u32				frame_mem_ctrl;
-	int				display_idx;
-	struct dentry			*debugfs_entry;
-};
-
 static const u8 coda_filler_nal[14] = { 0x00, 0x00, 0x00, 0x01, 0x0c, 0xff,
 			0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x80 };
 static const u8 coda_filler_size[8] = { 0, 7, 14, 13, 12, 11, 10, 9 };
 
-static inline void coda_write(struct coda_dev *dev, u32 data, u32 reg)
+void coda_write(struct coda_dev *dev, u32 data, u32 reg)
 {
 	v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
 		 "%s: data=0x%x, reg=0x%x\n", __func__, data, reg);
 	writel(data, dev->regs_base + reg);
 }
 
-static inline unsigned int coda_read(struct coda_dev *dev, u32 reg)
+unsigned int coda_read(struct coda_dev *dev, u32 reg)
 {
 	u32 data;
 	data = readl(dev->regs_base + reg);
diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
new file mode 100644
index 0000000..aafd186
--- /dev/null
+++ b/drivers/media/platform/coda/coda.h
@@ -0,0 +1,216 @@
+/*
+ * Coda multi-standard codec IP
+ *
+ * Copyright (C) 2012 Vista Silicon S.L.
+ *    Javier Martin, <javier.martin@vista-silicon.com>
+ *    Xavier Duret
+ * Copyright (C) 2012-2014 Philipp Zabel, Pengutronix
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/debugfs.h>
+#include <linux/irqreturn.h>
+#include <linux/mutex.h>
+#include <linux/kfifo.h>
+#include <linux/videodev2.h>
+
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-fh.h>
+#include <media/videobuf2-core.h>
+
+#include "coda_regs.h"
+
+#define CODA_MAX_FRAMEBUFFERS	8
+#define CODA_MAX_FRAME_SIZE	0x100000
+#define FMO_SLICE_SAVE_BUF_SIZE	(32)
+
+enum {
+	V4L2_M2M_SRC = 0,
+	V4L2_M2M_DST = 1,
+};
+
+enum coda_inst_type {
+	CODA_INST_ENCODER,
+	CODA_INST_DECODER,
+};
+
+enum coda_product {
+	CODA_DX6 = 0xf001,
+	CODA_7541 = 0xf012,
+	CODA_960 = 0xf020,
+};
+
+struct coda_devtype {
+	char			*firmware;
+	enum coda_product	product;
+	const struct coda_codec	*codecs;
+	unsigned int		num_codecs;
+	size_t			workbuf_size;
+	size_t			tempbuf_size;
+	size_t			iram_size;
+};
+
+struct coda_aux_buf {
+	void			*vaddr;
+	dma_addr_t		paddr;
+	u32			size;
+	struct debugfs_blob_wrapper blob;
+	struct dentry		*dentry;
+};
+
+struct coda_dev {
+	struct v4l2_device	v4l2_dev;
+	struct video_device	vfd[2];
+	struct platform_device	*plat_dev;
+	const struct coda_devtype *devtype;
+
+	void __iomem		*regs_base;
+	struct clk		*clk_per;
+	struct clk		*clk_ahb;
+	struct reset_control	*rstc;
+
+	struct coda_aux_buf	codebuf;
+	struct coda_aux_buf	tempbuf;
+	struct coda_aux_buf	workbuf;
+	struct gen_pool		*iram_pool;
+	struct coda_aux_buf	iram;
+
+	spinlock_t		irqlock;
+	struct mutex		dev_mutex;
+	struct mutex		coda_mutex;
+	struct workqueue_struct	*workqueue;
+	struct v4l2_m2m_dev	*m2m_dev;
+	struct vb2_alloc_ctx	*alloc_ctx;
+	struct list_head	instances;
+	unsigned long		instance_mask;
+	struct dentry		*debugfs_root;
+};
+
+struct coda_codec {
+	u32 mode;
+	u32 src_fourcc;
+	u32 dst_fourcc;
+	u32 max_w;
+	u32 max_h;
+};
+
+struct coda_huff_tab;
+
+struct coda_params {
+	u8			rot_mode;
+	u8			h264_intra_qp;
+	u8			h264_inter_qp;
+	u8			h264_min_qp;
+	u8			h264_max_qp;
+	u8			h264_deblk_enabled;
+	u8			h264_deblk_alpha;
+	u8			h264_deblk_beta;
+	u8			mpeg4_intra_qp;
+	u8			mpeg4_inter_qp;
+	u8			gop_size;
+	int			intra_refresh;
+	int			codec_mode;
+	int			codec_mode_aux;
+	enum v4l2_mpeg_video_multi_slice_mode slice_mode;
+	u32			framerate;
+	u16			bitrate;
+	u32			slice_max_bits;
+	u32			slice_max_mb;
+};
+
+struct coda_timestamp {
+	struct list_head	list;
+	u32			sequence;
+	struct v4l2_timecode	timecode;
+	struct timeval		timestamp;
+};
+
+/* Per-queue, driver-specific private data */
+struct coda_q_data {
+	unsigned int		width;
+	unsigned int		height;
+	unsigned int		bytesperline;
+	unsigned int		sizeimage;
+	unsigned int		fourcc;
+	struct v4l2_rect	rect;
+};
+
+struct coda_iram_info {
+	u32		axi_sram_use;
+	phys_addr_t	buf_bit_use;
+	phys_addr_t	buf_ip_ac_dc_use;
+	phys_addr_t	buf_dbk_y_use;
+	phys_addr_t	buf_dbk_c_use;
+	phys_addr_t	buf_ovl_use;
+	phys_addr_t	buf_btp_use;
+	phys_addr_t	search_ram_paddr;
+	int		search_ram_size;
+	int		remaining;
+	phys_addr_t	next_paddr;
+};
+
+struct gdi_tiled_map {
+	int xy2ca_map[16];
+	int xy2ba_map[16];
+	int xy2ra_map[16];
+	int rbc2axi_map[32];
+	int xy2rbc_config;
+	int map_type;
+#define GDI_LINEAR_FRAME_MAP 0
+};
+
+struct coda_ctx {
+	struct coda_dev			*dev;
+	struct mutex			buffer_mutex;
+	struct list_head		list;
+	struct work_struct		pic_run_work;
+	struct work_struct		seq_end_work;
+	struct completion		completion;
+	int				aborting;
+	int				initialized;
+	int				streamon_out;
+	int				streamon_cap;
+	u32				isequence;
+	u32				qsequence;
+	u32				osequence;
+	u32				sequence_offset;
+	struct coda_q_data		q_data[2];
+	enum coda_inst_type		inst_type;
+	const struct coda_codec		*codec;
+	enum v4l2_colorspace		colorspace;
+	struct coda_params		params;
+	struct v4l2_ctrl_handler	ctrls;
+	struct v4l2_fh			fh;
+	int				gopcounter;
+	int				runcounter;
+	char				vpu_header[3][64];
+	int				vpu_header_size[3];
+	struct kfifo			bitstream_fifo;
+	struct mutex			bitstream_mutex;
+	struct coda_aux_buf		bitstream;
+	bool				hold;
+	struct coda_aux_buf		parabuf;
+	struct coda_aux_buf		psbuf;
+	struct coda_aux_buf		slicebuf;
+	struct coda_aux_buf		internal_frames[CODA_MAX_FRAMEBUFFERS];
+	u32				frame_types[CODA_MAX_FRAMEBUFFERS];
+	struct coda_timestamp		frame_timestamps[CODA_MAX_FRAMEBUFFERS];
+	u32				frame_errors[CODA_MAX_FRAMEBUFFERS];
+	struct list_head		timestamp_list;
+	struct coda_aux_buf		workbuf;
+	int				num_internal_frames;
+	int				idx;
+	int				reg_idx;
+	struct coda_iram_info		iram_info;
+	struct gdi_tiled_map		tiled_map;
+	u32				bit_stream_param;
+	u32				frm_dis_flg;
+	u32				frame_mem_ctrl;
+	int				display_idx;
+	struct dentry			*debugfs_entry;
+};
-- 
2.0.1

