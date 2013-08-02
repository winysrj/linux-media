Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:57554 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab3HBOFK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Aug 2013 10:05:10 -0400
From: Archit Taneja <archit@ti.com>
To: <linux-media@vger.kernel.org>
CC: <linux-omap@vger.kernel.org>, <dagriego@biglakesoftware.com>,
	<dale@farnsworth.org>, <pawel@osciak.com>,
	<m.szyprowski@samsung.com>, <hverkuil@xs4all.nl>,
	<laurent.pinchart@ideasonboard.com>, <tomi.valkeinen@ti.com>,
	Archit Taneja <archit@ti.com>
Subject: [PATCH 4/6] v4l: ti-vpe: Add de-interlacer support in VPE
Date: Fri, 2 Aug 2013 19:33:41 +0530
Message-ID: <1375452223-30524-5-git-send-email-archit@ti.com>
In-Reply-To: <1375452223-30524-1-git-send-email-archit@ti.com>
References: <1375452223-30524-1-git-send-email-archit@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for the de-interlacer block in VPE.

For de-interlacer to work, we need to enable 2 more sets of VPE input ports
which fetch data from the 'last' and 'last to last' fields of the interlaced
video. Apart from that, we need to enable the Motion vector output and input
ports, and also allocate DMA buffers for them.

We need to make sure that two most recent fields in the source queue are
available and in the 'READY' state. Once a mem2mem context gets access to the
VPE HW(in device_run), it extracts the addresses of the 3 buffers, and provides
it to the data descriptors for the 3 sets of input ports((LUMA1, CHROMA1),
(LUMA2, CHROMA2), and (LUMA3, CHROMA3)) respectively for the 3 consecutive
fields. The motion vector and output port descriptors are configured and the
list is submitted to VPDMA.

Once the transaction is done, the v4l2 buffer corresponding to the oldest
field(the 3rd one) is changed to the state 'DONE', and the buffers corresponding
to 1st and 2nd fields become the 2nd and 3rd field for the next de-interlace
operation. This way, for each deinterlace operation, we have the 3 most recent
fields. After each transaction, we also swap the motion vector buffers, the new
input motion vector buffer contains the resultant motion information of all the
previous frames, and the new output motion vector buffer will be used to hold
the updated motion vector to capture the motion changes in the next field.

The de-interlacer is removed from bypass mode, it requires some extra default
configurations which are now added. The chrominance upsampler coefficients are
added for interlaced frames. Some VPDMA parameters like frame start event and
line mode are configured for the 2 extra sets of input ports.

Signed-off-by: Archit Taneja <archit@ti.com>
---
 drivers/media/platform/ti-vpe/vpe.c | 372 ++++++++++++++++++++++++++++++++----
 1 file changed, 337 insertions(+), 35 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 14a292b..5b1410c 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -69,6 +69,8 @@
 #define VPE_CHROMA	1
 
 /* per m2m context info */
+#define VPE_MAX_SRC_BUFS	3	/* need 3 src fields to de-interlace */
+
 #define VPE_DEF_BUFS_PER_JOB	1	/* default one buffer per batch job */
 
 /*
@@ -104,12 +106,44 @@ struct vpe_us_coeffs {
 /*
  * Default upsampler coefficients
  */
-static struct vpe_us_coeffs us_coeffs[] = {
+static struct vpe_us_coeffs us_coeffs[2] = {
 	{
 		/* Coefficients for progressive input */
 		0x00C8, 0x0348, 0x0018, 0x3FD8, 0x3FB8, 0x0378, 0x00E8, 0x3FE8,
 		0x00C8, 0x0348, 0x0018, 0x3FD8, 0x3FB8, 0x0378, 0x00E8, 0x3FE8,
 	},
+	{
+		/* Coefficients for Top Field Interlaced input */
+		0x0051, 0x03D5, 0x3FE3, 0x3FF7, 0x3FB5, 0x02E9, 0x018F, 0x3FD3,
+		/* Coefficients for Bottom Field Interlaced input */
+		0x016B, 0x0247, 0x00B1, 0x3F9D, 0x3FCF, 0x03DB, 0x005D, 0x3FF9,
+	},
+};
+
+/*
+ * the following registers are for configuring some of the parameters of the
+ * motion and edge detection blocks inside DEI, these generally remain the same,
+ * these could be passed later via userspace if some one needs to tweak these.
+ */
+struct vpe_dei_regs {
+	unsigned long mdt_spacial_freq_thr_reg;		/* VPE_DEI_REG2 */
+	unsigned long edi_config_reg;			/* VPE_DEI_REG3 */
+	unsigned long edi_lut_reg0;			/* VPE_DEI_REG4 */
+	unsigned long edi_lut_reg1;			/* VPE_DEI_REG5 */
+	unsigned long edi_lut_reg2;			/* VPE_DEI_REG6 */
+	unsigned long edi_lut_reg3;			/* VPE_DEI_REG7 */
+};
+
+/*
+ * default expert DEI register values, unlikely to be modified.
+ */
+static struct vpe_dei_regs dei_regs = {
+	0x020C0804u,
+	0x0118100Fu,
+	0x08040200u,
+	0x1010100Cu,
+	0x10101010u,
+	0x10101010u,
 };
 
 /*
@@ -117,6 +151,7 @@ static struct vpe_us_coeffs us_coeffs[] = {
  */
 struct vpe_port_data {
 	enum vpdma_channel channel;	/* VPDMA channel */
+	u8	vb_index;		/* input frame f, f-1, f-2 index */
 	u8	vb_part;		/* plane index for co-panar formats */
 };
 
@@ -125,6 +160,12 @@ struct vpe_port_data {
  */
 #define VPE_PORT_LUMA1_IN	0
 #define VPE_PORT_CHROMA1_IN	1
+#define VPE_PORT_LUMA2_IN	2
+#define VPE_PORT_CHROMA2_IN	3
+#define VPE_PORT_LUMA3_IN	4
+#define VPE_PORT_CHROMA3_IN	5
+#define VPE_PORT_MV_IN		6
+#define VPE_PORT_MV_OUT		7
 #define VPE_PORT_LUMA_OUT	8
 #define VPE_PORT_CHROMA_OUT	9
 #define VPE_PORT_RGB_OUT	10
@@ -132,12 +173,40 @@ struct vpe_port_data {
 static struct vpe_port_data port_data[11] = {
 	[VPE_PORT_LUMA1_IN] = {
 		.channel	= VPE_CHAN_LUMA1_IN,
+		.vb_index	= 0,
 		.vb_part	= VPE_LUMA,
 	},
 	[VPE_PORT_CHROMA1_IN] = {
 		.channel	= VPE_CHAN_CHROMA1_IN,
+		.vb_index	= 0,
+		.vb_part	= VPE_CHROMA,
+	},
+	[VPE_PORT_LUMA2_IN] = {
+		.channel	= VPE_CHAN_LUMA2_IN,
+		.vb_index	= 1,
+		.vb_part	= VPE_LUMA,
+	},
+	[VPE_PORT_CHROMA2_IN] = {
+		.channel	= VPE_CHAN_CHROMA2_IN,
+		.vb_index	= 1,
 		.vb_part	= VPE_CHROMA,
 	},
+	[VPE_PORT_LUMA3_IN] = {
+		.channel	= VPE_CHAN_LUMA3_IN,
+		.vb_index	= 2,
+		.vb_part	= VPE_LUMA,
+	},
+	[VPE_PORT_CHROMA3_IN] = {
+		.channel	= VPE_CHAN_CHROMA3_IN,
+		.vb_index	= 2,
+		.vb_part	= VPE_CHROMA,
+	},
+	[VPE_PORT_MV_IN] = {
+		.channel	= VPE_CHAN_MV_IN,
+	},
+	[VPE_PORT_MV_OUT] = {
+		.channel	= VPE_CHAN_MV_OUT,
+	},
 	[VPE_PORT_LUMA_OUT] = {
 		.channel	= VPE_CHAN_LUMA_OUT,
 		.vb_part	= VPE_LUMA,
@@ -209,6 +278,7 @@ struct vpe_q_data {
 	unsigned int		height;				/* frame height */
 	unsigned int		bytesperline[VPE_MAX_PLANES];	/* bytes per line in memory */
 	enum v4l2_colorspace	colorspace;
+	enum v4l2_field		field;				/* supported field value */
 	unsigned int		flags;
 	unsigned int		sizeimage[VPE_MAX_PLANES];	/* image size in memory */
 	struct v4l2_rect	c_rect;				/* crop/compose rectangle */
@@ -218,6 +288,7 @@ struct vpe_q_data {
 /* vpe_q_data flag bits */
 #define	Q_DATA_FRAME_1D		(1 << 0)
 #define	Q_DATA_MODE_TILED	(1 << 1)
+#define	Q_DATA_INTERLACED	(1 << 2)
 
 enum {
 	Q_DATA_SRC = 0,
@@ -269,6 +340,7 @@ struct vpe_ctx {
 	struct v4l2_m2m_ctx	*m2m_ctx;
 	struct v4l2_ctrl_handler hdl;
 
+	unsigned int		field;			/* current field */
 	unsigned int		sequence;		/* current frame/field seq */
 	unsigned int		aborting;		/* abort after next irq */
 
@@ -276,13 +348,17 @@ struct vpe_ctx {
 	unsigned int		bufs_completed;		/* bufs done in this batch */
 
 	struct vpe_q_data	q_data[2];		/* src & dst queue data */
-	struct vb2_buffer	*src_vb;
+	struct vb2_buffer	*src_vbs[VPE_MAX_SRC_BUFS];
 	struct vb2_buffer	*dst_vb;
 
+	struct vpdma_buf	mv_buf[2];		/* motion vector in/out bufs */
 	struct vpdma_buf	mmr_adb;		/* shadow reg addr/data block */
 	struct vpdma_desc_list	desc_list;		/* DMA descriptor list */
 
+	bool			deinterlacing;		/* using de-interlacer */
 	bool			load_mmrs;		/* have new shadow reg values */
+
+	unsigned int		src_mv_buf_selector;
 };
 
 
@@ -358,8 +434,7 @@ struct vpe_mmr_adb {
 	struct vpdma_adb_hdr	us3_hdr;
 	u32			us3_regs[8];
 	struct vpdma_adb_hdr	dei_hdr;
-	u32			dei_regs[1];
-	u32			dei_pad[3];
+	u32			dei_regs[8];
 	struct vpdma_adb_hdr	sc_hdr;
 	u32			sc_regs[1];
 	u32			sc_pad[3];
@@ -385,6 +460,74 @@ static void init_adb_hdrs(struct vpe_ctx *ctx)
 };
 
 /*
+ * Allocate or re-allocate the motion vector DMA buffers
+ * There are two buffers, one for input and one for output.
+ * However, the roles are reversed after each field is processed.
+ * In other words, after each field is processed, the previous
+ * output (dst) MV buffer becomes the new input (src) MV buffer.
+ */
+static int realloc_mv_buffers(struct vpe_ctx *ctx, size_t size)
+{
+	struct vpdma_data *vpdma = ctx->dev->vpdma;
+	int ret;
+
+	if (ctx->mv_buf[0].mapped) {
+		vpdma_buf_unmap(vpdma, &ctx->mv_buf[0]);
+		vpdma_buf_free(&ctx->mv_buf[0]);
+	}
+
+	if (ctx->mv_buf[1].mapped) {
+		vpdma_buf_unmap(vpdma, &ctx->mv_buf[1]);
+		vpdma_buf_free(&ctx->mv_buf[1]);
+	}
+
+	if (size == 0)
+		return 0;
+
+	ret = vpdma_buf_alloc(&ctx->mv_buf[0], size);
+	if (ret)
+		return ret;
+	ret = vpdma_buf_alloc(&ctx->mv_buf[1], size);
+	if (ret) {
+		vpdma_buf_free(&ctx->mv_buf[0]);
+		return ret;
+	}
+
+	vpdma_buf_map(vpdma, &ctx->mv_buf[0]);
+	vpdma_buf_map(vpdma, &ctx->mv_buf[1]);
+
+	ctx->src_mv_buf_selector = 0;
+
+	return 0;
+}
+
+static void free_mv_buffers(struct vpe_ctx *ctx)
+{
+	realloc_mv_buffers(ctx, 0);
+}
+
+/*
+ * While de-interlacing, we keep the two most recent input buffers
+ * around.  This function frees those two buffers when we have
+ * finished processing the current stream.
+ */
+static void free_vbs(struct vpe_ctx *ctx)
+{
+	struct vpe_dev *dev = ctx->dev;
+	unsigned long flags;
+
+	if (ctx->src_vbs[2] == NULL)
+		return;
+
+	spin_lock_irqsave(&dev->lock, flags);
+	if (ctx->src_vbs[2]) {
+		v4l2_m2m_buf_done(ctx->src_vbs[2], VB2_BUF_STATE_DONE);
+		v4l2_m2m_buf_done(ctx->src_vbs[1], VB2_BUF_STATE_DONE);
+	}
+	spin_unlock_irqrestore(&dev->lock, flags);
+}
+
+/*
  * Enable or disable the VPE clocks
  */
 static void vpe_set_clock_enable(struct vpe_dev *dev, bool on)
@@ -425,6 +568,7 @@ static void vpe_top_vpdma_reset(struct vpe_dev *dev)
 static void set_us_coefficients(struct vpe_ctx *ctx)
 {
 	struct vpe_mmr_adb *mmr_adb = ctx->mmr_adb.addr;
+	struct vpe_q_data *s_q_data = &ctx->q_data[Q_DATA_SRC];
 	u32 *us1_reg = &mmr_adb->us1_regs[0];
 	u32 *us2_reg = &mmr_adb->us2_regs[0];
 	u32 *us3_reg = &mmr_adb->us3_regs[0];
@@ -432,6 +576,9 @@ static void set_us_coefficients(struct vpe_ctx *ctx)
 
 	cp = &us_coeffs[0].anchor_fid0_c0;
 
+	if (s_q_data->flags & Q_DATA_INTERLACED)	/* interlaced */
+		cp += sizeof(us_coeffs[0]) / sizeof(*cp);
+
 	end_cp = cp + sizeof(us_coeffs[0]) / sizeof(*cp);
 
 	while (cp < end_cp) {
@@ -472,14 +619,28 @@ static void set_cfg_and_line_modes(struct vpe_ctx *ctx)
 
 	/* regs for now */
 	vpdma_set_line_mode(ctx->dev->vpdma, line_mode, VPE_CHAN_CHROMA1_IN);
+	vpdma_set_line_mode(ctx->dev->vpdma, line_mode, VPE_CHAN_CHROMA2_IN);
+	vpdma_set_line_mode(ctx->dev->vpdma, line_mode, VPE_CHAN_CHROMA3_IN);
 
 	/* frame start for input luma */
 	vpdma_set_frame_start_event(ctx->dev->vpdma, VPDMA_FSEVENT_CHANNEL_ACTIVE,
 		VPE_CHAN_LUMA1_IN);
+	vpdma_set_frame_start_event(ctx->dev->vpdma, VPDMA_FSEVENT_CHANNEL_ACTIVE,
+		VPE_CHAN_LUMA2_IN);
+	vpdma_set_frame_start_event(ctx->dev->vpdma, VPDMA_FSEVENT_CHANNEL_ACTIVE,
+		VPE_CHAN_LUMA3_IN);
 
 	/* frame start for input chroma */
 	vpdma_set_frame_start_event(ctx->dev->vpdma, VPDMA_FSEVENT_CHANNEL_ACTIVE,
 		VPE_CHAN_CHROMA1_IN);
+	vpdma_set_frame_start_event(ctx->dev->vpdma, VPDMA_FSEVENT_CHANNEL_ACTIVE,
+		VPE_CHAN_CHROMA2_IN);
+	vpdma_set_frame_start_event(ctx->dev->vpdma, VPDMA_FSEVENT_CHANNEL_ACTIVE,
+		VPE_CHAN_CHROMA3_IN);
+
+	/* frame start for MV in client */
+	vpdma_set_frame_start_event(ctx->dev->vpdma, VPDMA_FSEVENT_CHANNEL_ACTIVE,
+		VPE_CHAN_MV_IN);
 
 	ctx->load_mmrs = true;
 }
@@ -523,13 +684,14 @@ static void set_dst_registers(struct vpe_ctx *ctx)
 /*
  * Set the de-interlacer shadow register values
  */
-static void set_dei_regs_bypass(struct vpe_ctx *ctx)
+static void set_dei_regs(struct vpe_ctx *ctx)
 {
 	struct vpe_mmr_adb *mmr_adb = ctx->mmr_adb.addr;
 	struct vpe_q_data *s_q_data = &ctx->q_data[Q_DATA_SRC];
 	unsigned int src_h = s_q_data->c_rect.height;
 	unsigned int src_w = s_q_data->c_rect.width;
 	u32 *dei_mmr0 = &mmr_adb->dei_regs[0];
+	bool deinterlace = true;
 	u32 val = 0;
 
 	/*
@@ -538,7 +700,13 @@ static void set_dei_regs_bypass(struct vpe_ctx *ctx)
 	 * for both progressive and interlace content in interlace bypass mode.
 	 * It has been recommended not to use progressive bypass mode.
 	 */
-	val = VPE_DEI_INTERLACE_BYPASS;
+	if ((!ctx->deinterlacing && (s_q_data->flags & Q_DATA_INTERLACED)) ||
+			!(s_q_data->flags & Q_DATA_INTERLACED)) {
+		deinterlace = false;
+		val = VPE_DEI_INTERLACE_BYPASS;
+	}
+
+	src_h = deinterlace ? src_h * 2 : src_h;
 
 	val |= (src_h << VPE_DEI_HEIGHT_SHIFT) |
 		(src_w << VPE_DEI_WIDTH_SHIFT) |
@@ -577,10 +745,35 @@ static void set_sc_regs_bypass(struct vpe_ctx *ctx)
  */
 static int set_srcdst_params(struct vpe_ctx *ctx)
 {
+	struct vpe_q_data *s_q_data =  &ctx->q_data[Q_DATA_SRC];
+	struct vpe_q_data *d_q_data =  &ctx->q_data[Q_DATA_DST];
+	size_t mv_buf_size;
+	int ret;
+
 	ctx->sequence = 0;
+	ctx->field = V4L2_FIELD_TOP;
+
+	if ((s_q_data->flags & Q_DATA_INTERLACED) &&
+			!(d_q_data->flags & Q_DATA_INTERLACED)) {
+		struct vpdma_data_format *mv =
+			&vpdma_misc_fmts[VPDMA_DATA_FMT_MV];
+
+		ctx->deinterlacing = 1;
+		mv_buf_size =
+			(s_q_data->width * s_q_data->height * mv->depth) >> 3;
+	} else {
+		ctx->deinterlacing = 0;
+		mv_buf_size = 0;
+	}
+
+	free_vbs(ctx);
+
+	ret = realloc_mv_buffers(ctx, mv_buf_size);
+	if (ret)
+		return ret;
 
 	set_cfg_and_line_modes(ctx);
-	set_dei_regs_bypass(ctx);
+	set_dei_regs(ctx);
 	set_csc_coeff_bypass(ctx);
 	set_sc_regs_bypass(ctx);
 
@@ -607,6 +800,9 @@ static int job_ready(void *priv)
 	struct vpe_ctx *ctx = priv;
 	int needed = ctx->bufs_per_job;
 
+	if (ctx->deinterlacing && ctx->src_vbs[2] == NULL)
+		needed += 2;	/* need additional two most recent fields */
+
 	if (v4l2_m2m_num_src_bufs_ready(ctx->m2m_ctx) < needed)
 		return 0;
 
@@ -734,17 +930,25 @@ static void add_out_dtd(struct vpe_ctx *ctx, int port)
 	struct v4l2_rect *c_rect = &q_data->c_rect;
 	struct vpe_fmt *fmt = q_data->fmt;
 	struct vpdma_data_format *vpdma_fmt;
-	int plane = fmt->coplanar ? p_data->vb_part : 0;
+	int mv_buf_selector = !ctx->src_mv_buf_selector;
 	dma_addr_t dma_addr;
 	u32 flags = 0;
 
-	vpdma_fmt = fmt->vpdma_fmt[plane];
-	dma_addr = vb2_dma_contig_plane_dma_addr(vb, plane);
-	if (!dma_addr) {
-		vpe_err(ctx->dev,
-			"acquiring output buffer(%d) dma_addr failed\n",
-			port);
-		return;
+	if (port == VPE_PORT_MV_OUT) {
+		vpdma_fmt = &vpdma_misc_fmts[VPDMA_DATA_FMT_MV];
+		dma_addr = ctx->mv_buf[mv_buf_selector].dma_addr;
+	} else {
+		/* to incorporate interleaved formats */
+		int plane = fmt->coplanar ? p_data->vb_part : 0;
+
+		vpdma_fmt = fmt->vpdma_fmt[plane];
+		dma_addr = vb2_dma_contig_plane_dma_addr(vb, plane);
+		if (!dma_addr) {
+			vpe_err(ctx->dev,
+				"acquiring output buffer(%d) dma_addr failed\n",
+				port);
+			return;
+		}
 	}
 
 	if (q_data->flags & Q_DATA_FRAME_1D)
@@ -760,23 +964,31 @@ static void add_in_dtd(struct vpe_ctx *ctx, int port)
 {
 	struct vpe_q_data *q_data = &ctx->q_data[Q_DATA_SRC];
 	struct vpe_port_data *p_data = &port_data[port];
-	struct vb2_buffer *vb = ctx->src_vb;
+	struct vb2_buffer *vb = ctx->src_vbs[p_data->vb_index];
 	struct v4l2_rect *c_rect = &q_data->c_rect;
 	struct vpe_fmt *fmt = q_data->fmt;
 	struct vpdma_data_format *vpdma_fmt;
-	int plane = fmt->coplanar ? p_data->vb_part : 0;
-	int field = 0;
+	int mv_buf_selector = ctx->src_mv_buf_selector;
+	int field = vb->v4l2_buf.field == V4L2_FIELD_BOTTOM;
 	dma_addr_t dma_addr;
 	u32 flags = 0;
 
-	vpdma_fmt = fmt->vpdma_fmt[plane];
+	if (port == VPE_PORT_MV_IN) {
+		vpdma_fmt = &vpdma_misc_fmts[VPDMA_DATA_FMT_MV];
+		dma_addr = ctx->mv_buf[mv_buf_selector].dma_addr;
+	} else {
+		/* to incorporate interleaved formats */
+		int plane = fmt->coplanar ? p_data->vb_part : 0;
 
-	dma_addr = vb2_dma_contig_plane_dma_addr(vb, plane);
-	if (!dma_addr) {
-		vpe_err(ctx->dev,
-			"acquiring input buffer(%d) dma_addr failed\n",
-			port);
-		return;
+		vpdma_fmt = fmt->vpdma_fmt[plane];
+
+		dma_addr = vb2_dma_contig_plane_dma_addr(vb, plane);
+		if (!dma_addr) {
+			vpe_err(ctx->dev,
+				"acquiring input buffer(%d) dma_addr failed\n",
+				port);
+			return;
+		}
 	}
 
 	if (q_data->flags & Q_DATA_FRAME_1D)
@@ -794,7 +1006,8 @@ static void add_in_dtd(struct vpe_ctx *ctx, int port)
 static void enable_irqs(struct vpe_ctx *ctx)
 {
 	write_reg(ctx->dev, VPE_INT0_ENABLE0_SET, VPE_INT0_LIST0_COMPLETE);
-	write_reg(ctx->dev, VPE_INT0_ENABLE1_SET, VPE_DS1_UV_ERROR_INT);
+	write_reg(ctx->dev, VPE_INT0_ENABLE1_SET, VPE_DEI_ERROR_INT |
+				VPE_DS1_UV_ERROR_INT);
 
 	vpdma_enable_list_complete_irq(ctx->dev->vpdma, 0, true);
 }
@@ -817,8 +1030,15 @@ static void device_run(void *priv)
 	struct vpe_ctx *ctx = priv;
 	struct vpe_q_data *d_q_data = &ctx->q_data[Q_DATA_DST];
 
-	ctx->src_vb = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
-	WARN_ON(ctx->src_vb == NULL);
+	if (ctx->deinterlacing && ctx->src_vbs[2] == NULL) {
+		ctx->src_vbs[2] = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
+		WARN_ON(ctx->src_vbs[2] == NULL);
+		ctx->src_vbs[1] = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
+		WARN_ON(ctx->src_vbs[1] == NULL);
+	}
+
+	ctx->src_vbs[0] = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
+	WARN_ON(ctx->src_vbs[0] == NULL);
 	ctx->dst_vb = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
 	WARN_ON(ctx->dst_vb == NULL);
 
@@ -830,24 +1050,49 @@ static void device_run(void *priv)
 		ctx->load_mmrs = false;
 	}
 
+	/* output data descriptors */
+	if (ctx->deinterlacing)
+		add_out_dtd(ctx, VPE_PORT_MV_OUT);
+
 	add_out_dtd(ctx, VPE_PORT_LUMA_OUT);
 	if (d_q_data->fmt->coplanar)
 		add_out_dtd(ctx, VPE_PORT_CHROMA_OUT);
 
+	/* input data descriptors */
+	if (ctx->deinterlacing) {
+		add_in_dtd(ctx, VPE_PORT_LUMA3_IN);
+		add_in_dtd(ctx, VPE_PORT_CHROMA3_IN);
+
+		add_in_dtd(ctx, VPE_PORT_LUMA2_IN);
+		add_in_dtd(ctx, VPE_PORT_CHROMA2_IN);
+	}
+
 	add_in_dtd(ctx, VPE_PORT_LUMA1_IN);
 	add_in_dtd(ctx, VPE_PORT_CHROMA1_IN);
 
+	if (ctx->deinterlacing)
+		add_in_dtd(ctx, VPE_PORT_MV_IN);
+
 	/* sync on channel control descriptors for output ports */
 	vpdma_add_sync_on_channel_ctd(&ctx->desc_list, VPE_CHAN_LUMA_OUT);
 	if (d_q_data->fmt->coplanar)
 		vpdma_add_sync_on_channel_ctd(&ctx->desc_list, VPE_CHAN_CHROMA_OUT);
 
+	if (ctx->deinterlacing)
+		vpdma_add_sync_on_channel_ctd(&ctx->desc_list, VPE_CHAN_MV_OUT);
+
 	enable_irqs(ctx);
 
 	vpdma_buf_map(ctx->dev->vpdma, &ctx->desc_list.buf);
 	vpdma_submit_descs(ctx->dev->vpdma, &ctx->desc_list);
 }
 
+static void dei_error(struct vpe_ctx *ctx)
+{
+	dev_warn(ctx->dev->v4l2_dev.dev,
+		"received DEI error interrupt\n");
+}
+
 static void ds1_uv_error(struct vpe_ctx *ctx)
 {
 	dev_warn(ctx->dev->v4l2_dev.dev,
@@ -858,6 +1103,7 @@ static irqreturn_t vpe_irq(int irq_vpe, void *data)
 {
 	struct vpe_dev *dev = (struct vpe_dev *)data;
 	struct vpe_ctx *ctx;
+	struct vpe_q_data *d_q_data;
 	struct vb2_buffer *s_vb, *d_vb;
 	struct v4l2_buffer *s_buf, *d_buf;
 	unsigned long flags;
@@ -881,9 +1127,15 @@ static irqreturn_t vpe_irq(int irq_vpe, void *data)
 		goto handled;
 	}
 
-	if (irqst1 & VPE_DS1_UV_ERROR_INT) {
-		irqst1 &= ~VPE_DS1_UV_ERROR_INT;
-		ds1_uv_error(ctx);
+	if (irqst1) {
+		if (irqst1 & VPE_DEI_ERROR_INT) {
+			irqst1 &= ~VPE_DEI_ERROR_INT;
+			dei_error(ctx);
+		}
+		if (irqst1 & VPE_DS1_UV_ERROR_INT) {
+			irqst1 &= ~VPE_DS1_UV_ERROR_INT;
+			ds1_uv_error(ctx);
+		}
 	}
 
 	if (irqst0) {
@@ -906,10 +1158,13 @@ static irqreturn_t vpe_irq(int irq_vpe, void *data)
 
 	vpdma_reset_desc_list(&ctx->desc_list);
 
+	 /* the previous dst mv buffer becomes the next src mv buffer */
+	ctx->src_mv_buf_selector = !ctx->src_mv_buf_selector;
+
 	if (ctx->aborting)
 		goto finished;
 
-	s_vb = ctx->src_vb;
+	s_vb = ctx->src_vbs[0];
 	d_vb = ctx->dst_vb;
 	s_buf = &s_vb->v4l2_buf;
 	d_buf = &d_vb->v4l2_buf;
@@ -919,16 +1174,35 @@ static irqreturn_t vpe_irq(int irq_vpe, void *data)
 		d_buf->flags |= V4L2_BUF_FLAG_TIMECODE;
 		d_buf->timecode = s_buf->timecode;
 	}
-
 	d_buf->sequence = ctx->sequence;
+	d_buf->field = ctx->field;
+
+	d_q_data = &ctx->q_data[Q_DATA_DST];
+	if (d_q_data->flags & Q_DATA_INTERLACED) {
+		if (ctx->field == V4L2_FIELD_BOTTOM) {
+			ctx->sequence++;
+			ctx->field = V4L2_FIELD_TOP;
+		} else {
+			WARN_ON(ctx->field != V4L2_FIELD_TOP);
+			ctx->field = V4L2_FIELD_BOTTOM;
+		}
+	} else {
+		ctx->sequence++;
+	}
 
-	ctx->sequence++;
+	if (ctx->deinterlacing)
+		s_vb = ctx->src_vbs[2];
 
 	spin_lock_irqsave(&dev->lock, flags);
 	v4l2_m2m_buf_done(s_vb, VB2_BUF_STATE_DONE);
 	v4l2_m2m_buf_done(d_vb, VB2_BUF_STATE_DONE);
 	spin_unlock_irqrestore(&dev->lock, flags);
 
+	if (ctx->deinterlacing) {
+		ctx->src_vbs[2] = ctx->src_vbs[1];
+		ctx->src_vbs[1] = ctx->src_vbs[0];
+	}
+
 	ctx->bufs_completed++;
 	if (ctx->bufs_completed < ctx->bufs_per_job) {
 		device_run(ctx);
@@ -1009,6 +1283,7 @@ static int vpe_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
 	pix->width = q_data->width;
 	pix->height = q_data->height;
 	pix->pixelformat = q_data->fmt->fourcc;
+	pix->field = q_data->field;
 	pix->colorspace = q_data->colorspace;
 	pix->num_planes = q_data->fmt->coplanar ? 2 : 1;
 
@@ -1035,7 +1310,8 @@ static int __vpe_try_fmt(struct vpe_ctx *ctx, struct v4l2_format *f,
 
 	if (pix->field == V4L2_FIELD_ANY)
 		pix->field = V4L2_FIELD_NONE;
-	else if (V4L2_FIELD_NONE != pix->field)
+	else if (V4L2_FIELD_NONE != pix->field &&
+			V4L2_FIELD_ALTERNATE != pix->field)
 		return -EINVAL;
 
 	v4l_bound_align_image(&pix->width, MIN_W, MAX_W, W_ALIGN,
@@ -1104,6 +1380,7 @@ static int __vpe_s_fmt(struct vpe_ctx *ctx, struct v4l2_format *f)
 	q_data->width		= pix->width;
 	q_data->height		= pix->height;
 	q_data->colorspace	= pix->colorspace;
+	q_data->field		= pix->field;
 
 	for (i = 0; i < pix->num_planes; i++) {
 		plane_fmt = &pix->plane_fmt[i];
@@ -1117,6 +1394,11 @@ static int __vpe_s_fmt(struct vpe_ctx *ctx, struct v4l2_format *f)
 	q_data->c_rect.width	= q_data->width;
 	q_data->c_rect.height	= q_data->height;
 
+	if (q_data->field == V4L2_FIELD_ALTERNATE)
+		q_data->flags |= Q_DATA_INTERLACED;
+	else
+		q_data->flags &= ~Q_DATA_INTERLACED;
+
 	vpe_dbg(ctx->dev, "Setting format for type %d, wxh: %dx%d, fmt: %d bpl_y %d",
 		f->type, q_data->width, q_data->height, q_data->fmt->fourcc,
 		q_data->bytesperline[VPE_LUMA]);
@@ -1194,6 +1476,22 @@ static int vpe_streamoff(struct file *file, void *priv, enum v4l2_buf_type type)
 	return v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
 }
 
+static void set_dei_shadow_registers(struct vpe_ctx *ctx)
+{
+	struct vpe_mmr_adb *mmr_adb = ctx->mmr_adb.addr;
+	u32 *dei_mmr = &mmr_adb->dei_regs[0];
+	struct vpe_dei_regs *cur = &dei_regs;
+
+	dei_mmr[2]  = cur->mdt_spacial_freq_thr_reg;
+	dei_mmr[3]  = cur->edi_config_reg;
+	dei_mmr[4]  = cur->edi_lut_reg0;
+	dei_mmr[5]  = cur->edi_lut_reg1;
+	dei_mmr[6]  = cur->edi_lut_reg2;
+	dei_mmr[7]  = cur->edi_lut_reg3;
+
+	ctx->load_mmrs = true;
+}
+
 #define V4L2_CID_TRANS_NUM_BUFS		(V4L2_CID_USER_BASE)
 
 static int vpe_s_ctrl(struct v4l2_ctrl *ctrl)
@@ -1425,6 +1723,7 @@ static int vpe_open(struct file *file)
 	s_q_data->sizeimage[VPE_LUMA] = (s_q_data->width * s_q_data->height *
 			s_q_data->fmt->vpdma_fmt[VPE_LUMA]->depth) >> 3;
 	s_q_data->colorspace = V4L2_COLORSPACE_SMPTE240M;
+	s_q_data->field = V4L2_FIELD_NONE;
 	s_q_data->c_rect.left = 0;
 	s_q_data->c_rect.top = 0;
 	s_q_data->c_rect.width = s_q_data->width;
@@ -1433,6 +1732,7 @@ static int vpe_open(struct file *file)
 
 	ctx->q_data[Q_DATA_DST] = *s_q_data;
 
+	set_dei_shadow_registers(ctx);
 	set_src_registers(ctx);
 	set_dst_registers(ctx);
 	ret = set_srcdst_params(ctx);
@@ -1487,6 +1787,8 @@ static int vpe_release(struct file *file)
 	vpe_dbg(dev, "releasing instance %p\n", ctx);
 
 	mutex_lock(&dev->dev_mutex);
+	free_vbs(ctx);
+	free_mv_buffers(ctx);
 	vpdma_free_desc_list(&ctx->desc_list);
 	vpdma_buf_free(&ctx->mmr_adb);
 
-- 
1.8.1.2

