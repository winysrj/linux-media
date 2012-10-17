Return-path: <linux-media-owner@vger.kernel.org>
Received: from zose-mta-11.w4a.fr ([178.33.204.86]:50266 "EHLO
	zose-mta11.web4all.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755981Ab2JQMnC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Oct 2012 08:43:02 -0400
Date: Wed, 17 Oct 2012 14:41:24 +0200 (CEST)
From: =?utf-8?Q?Beno=C3=AEt_Th=C3=A9baudeau?=
	<benoit.thebaudeau@advansee.com>
To: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	Christoph Fritz <chf.fritz@googlemail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Alex Gershgorin <alexg@meprolight.com>,
	Liu Ying <Ying.Liu@freescale.com>
Message-ID: <1556117578.7042626.1350477684664.JavaMail.root@advansee.com>
In-Reply-To: <1138630204.7042194.1350477369863.JavaMail.root@advansee.com>
Subject: [RFC] media: mx3: Add support for missing video formats
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This is an RFC for a patch completing full video capture support on i.MX3x.

It adds missing video formats and automatic format associations according to the
underlying sensor capabilities.

It also fixes a spurious IPU interrupt issue that I have encountered on i.MX31
with earlier kernel versions. This might already have been fixed by some of the
changes that occurred in the IPU driver since then, but I still have to test if
my fix is still useful or not. Anyway, this should of course be split away to a
separate patch.

This patch has been successfully tested with i.MX35 and MT9M131, as well as some
not yet mainline OmniVision sensor drivers, using all sensor-and-SoC-supported
formats.

This patch still has to be rebased against the latest kernel and refactored in
the following way:
 1. Media formats.
 2. IPU formats.
 3. IPU spurious interrupt fix (if still required).
 4. mx3_camera formats.

Comments are welcome, especially regarding possible conflicts with other IPU
users.

Best regards,
Benoît

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: <linux-media@vger.kernel.org>
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: <linux-arm-kernel@lists.infradead.org>
Signed-off-by: Benoît Thébaudeau <benoit.thebaudeau@advansee.com>
---
 .../arch/arm/plat-mxc/include/mach/ipu.h           |   16 +-
 .../drivers/dma/ipu/ipu_idmac.c                    |  241 ++++++++++++++---
 .../drivers/media/video/mx3_camera.c               |  264 +++++++++++++------
 .../drivers/media/video/soc_mediabus.c             |  276 ++++++++++++++------
 .../include/linux/v4l2-mediabus.h                  |   11 +-
 .../include/media/soc_mediabus.h                   |   30 ++-
 6 files changed, 626 insertions(+), 212 deletions(-)

diff --git linux-3.4.5.orig/arch/arm/plat-mxc/include/mach/ipu.h linux-3.4.5/arch/arm/plat-mxc/include/mach/ipu.h
index a9221f1..f786af2 100644
--- linux-3.4.5.orig/arch/arm/plat-mxc/include/mach/ipu.h
+++ linux-3.4.5/arch/arm/plat-mxc/include/mach/ipu.h
@@ -68,25 +68,27 @@ enum pixel_fmt {
 	IPU_PIX_FMT_GENERIC,
 	IPU_PIX_FMT_RGB332,
 	IPU_PIX_FMT_YUV420P,
+	IPU_PIX_FMT_YVU420P,
 	IPU_PIX_FMT_YUV422P,
-	IPU_PIX_FMT_YUV420P2,
 	IPU_PIX_FMT_YVU422P,
 	/* 2 bytes */
+	IPU_PIX_FMT_GENERIC_16,
+	IPU_PIX_FMT_RGB444,
+	IPU_PIX_FMT_RGB555,
 	IPU_PIX_FMT_RGB565,
-	IPU_PIX_FMT_RGB666,
-	IPU_PIX_FMT_BGR666,
-	IPU_PIX_FMT_YUYV,
 	IPU_PIX_FMT_UYVY,
 	/* 3 bytes */
-	IPU_PIX_FMT_RGB24,
+	IPU_PIX_FMT_BGR666,
+	IPU_PIX_FMT_RGB666,
 	IPU_PIX_FMT_BGR24,
+	IPU_PIX_FMT_RGB24,
 	/* 4 bytes */
 	IPU_PIX_FMT_GENERIC_32,
-	IPU_PIX_FMT_RGB32,
 	IPU_PIX_FMT_BGR32,
-	IPU_PIX_FMT_ABGR32,
+	IPU_PIX_FMT_RGB32,
 	IPU_PIX_FMT_BGRA32,
 	IPU_PIX_FMT_RGBA32,
+	IPU_PIX_FMT_ABGR32,
 };
 
 enum ipu_color_space {
diff --git linux-3.4.5.orig/drivers/dma/ipu/ipu_idmac.c linux-3.4.5/drivers/dma/ipu/ipu_idmac.c
index 62e3f8e..e1c97d6 100644
--- linux-3.4.5.orig/drivers/dma/ipu/ipu_idmac.c
+++ linux-3.4.5/drivers/dma/ipu/ipu_idmac.c
@@ -95,11 +95,15 @@ static uint32_t bytes_per_pixel(enum pixel_fmt fmt)
 	case IPU_PIX_FMT_GENERIC:	/* generic data */
 	case IPU_PIX_FMT_RGB332:
 	case IPU_PIX_FMT_YUV420P:
+	case IPU_PIX_FMT_YVU420P:
 	case IPU_PIX_FMT_YUV422P:
+	case IPU_PIX_FMT_YVU422P:
 	default:
 		return 1;
+	case IPU_PIX_FMT_GENERIC_16:	/* generic data */
+	case IPU_PIX_FMT_RGB444:
+	case IPU_PIX_FMT_RGB555:
 	case IPU_PIX_FMT_RGB565:
-	case IPU_PIX_FMT_YUYV:
 	case IPU_PIX_FMT_UYVY:
 		return 2;
 	case IPU_PIX_FMT_BGR24:
@@ -108,6 +112,8 @@ static uint32_t bytes_per_pixel(enum pixel_fmt fmt)
 	case IPU_PIX_FMT_GENERIC_32:	/* generic data */
 	case IPU_PIX_FMT_BGR32:
 	case IPU_PIX_FMT_RGB32:
+	case IPU_PIX_FMT_BGRA32:
+	case IPU_PIX_FMT_RGBA32:
 	case IPU_PIX_FMT_ABGR32:
 		return 4;
 	}
@@ -297,18 +303,64 @@ static void ipu_ch_param_set_size(union chan_param_mem *params,
 
 	switch (pixel_fmt) {
 	case IPU_PIX_FMT_GENERIC:
-		/*Represents 8-bit Generic data */
-		params->pp.bpp	= 3;
-		params->pp.pfs	= 7;
-		params->pp.npb	= 31;
-		params->pp.sat	= 2;		/* SAT = use 32-bit access */
+		/* Represents 8-bit Generic data */
+		params->ip.bpp	= 3;
+		params->ip.pfs	= 7;
+		params->ip.npb	= 31;
+		params->ip.sat	= 2;		/* SAT = use 32-bit access */
+		break;
+	case IPU_PIX_FMT_GENERIC_16:
+		/* Represents 16-bit Generic data */
+		params->ip.bpp	= 2;
+		params->ip.pfs	= 7;
+		params->ip.npb	= 15;
+		params->ip.sat	= 2;		/* SAT = use 32-bit access */
 		break;
 	case IPU_PIX_FMT_GENERIC_32:
-		/*Represents 32-bit Generic data */
-		params->pp.bpp	= 0;
-		params->pp.pfs	= 7;
-		params->pp.npb	= 7;
-		params->pp.sat	= 2;		/* SAT = use 32-bit access */
+		/* Represents 32-bit Generic data */
+		params->ip.bpp	= 0;
+		params->ip.pfs	= 7;
+		params->ip.npb	= 7;
+		params->ip.sat	= 2;		/* SAT = use 32-bit access */
+		break;
+	case IPU_PIX_FMT_RGB332:
+		params->ip.bpp	= 3;
+		params->ip.pfs	= 4;
+		params->ip.npb	= 31;
+		params->ip.sat	= 2;		/* SAT = 32-bit access */
+		params->ip.ofs0	= 0;		/* Red bit offset */
+		params->ip.ofs1	= 3;		/* Green bit offset */
+		params->ip.ofs2	= 6;		/* Blue bit offset */
+		params->ip.ofs3	= 8;		/* Alpha bit offset */
+		params->ip.wid0	= 2;		/* Red bit width - 1 */
+		params->ip.wid1	= 2;		/* Green bit width - 1 */
+		params->ip.wid2	= 1;		/* Blue bit width - 1 */
+		break;
+	case IPU_PIX_FMT_RGB444:
+		params->ip.bpp	= 2;
+		params->ip.pfs	= 4;
+		params->ip.npb	= 15;
+		params->ip.sat	= 2;		/* SAT = 32-bit access */
+		params->ip.ofs0	= 4;		/* Red bit offset */
+		params->ip.ofs1	= 8;		/* Green bit offset */
+		params->ip.ofs2	= 12;		/* Blue bit offset */
+		params->ip.ofs3	= 16;		/* Alpha bit offset */
+		params->ip.wid0	= 3;		/* Red bit width - 1 */
+		params->ip.wid1	= 3;		/* Green bit width - 1 */
+		params->ip.wid2	= 3;		/* Blue bit width - 1 */
+		break;
+	case IPU_PIX_FMT_RGB555:
+		params->ip.bpp	= 2;
+		params->ip.pfs	= 4;
+		params->ip.npb	= 15;
+		params->ip.sat	= 2;		/* SAT = 32-bit access */
+		params->ip.ofs0	= 1;		/* Red bit offset */
+		params->ip.ofs1	= 6;		/* Green bit offset */
+		params->ip.ofs2	= 11;		/* Blue bit offset */
+		params->ip.ofs3	= 16;		/* Alpha bit offset */
+		params->ip.wid0	= 4;		/* Red bit width - 1 */
+		params->ip.wid1	= 4;		/* Green bit width - 1 */
+		params->ip.wid2	= 4;		/* Blue bit width - 1 */
 		break;
 	case IPU_PIX_FMT_RGB565:
 		params->ip.bpp	= 2;
@@ -326,7 +378,7 @@ static void ipu_ch_param_set_size(union chan_param_mem *params,
 	case IPU_PIX_FMT_BGR24:
 		params->ip.bpp	= 1;		/* 24 BPP & RGB PFS */
 		params->ip.pfs	= 4;
-		params->ip.npb	= 7;
+		params->ip.npb	= 9;
 		params->ip.sat	= 2;		/* SAT = 32-bit access */
 		params->ip.ofs0	= 0;		/* Red bit offset */
 		params->ip.ofs1	= 8;		/* Green bit offset */
@@ -339,7 +391,7 @@ static void ipu_ch_param_set_size(union chan_param_mem *params,
 	case IPU_PIX_FMT_RGB24:
 		params->ip.bpp	= 1;		/* 24 BPP & RGB PFS */
 		params->ip.pfs	= 4;
-		params->ip.npb	= 7;
+		params->ip.npb	= 9;
 		params->ip.sat	= 2;		/* SAT = 32-bit access */
 		params->ip.ofs0	= 16;		/* Red bit offset */
 		params->ip.ofs1	= 8;		/* Green bit offset */
@@ -383,37 +435,45 @@ static void ipu_ch_param_set_size(union chan_param_mem *params,
 	case IPU_PIX_FMT_UYVY:
 		params->ip.bpp	= 2;
 		params->ip.pfs	= 6;
-		params->ip.npb	= 7;
+		params->ip.npb	= 15;
 		params->ip.sat	= 2;		/* SAT = 32-bit access */
 		break;
-	case IPU_PIX_FMT_YUV420P2:
 	case IPU_PIX_FMT_YUV420P:
-		params->ip.bpp	= 3;
-		params->ip.pfs	= 3;
-		params->ip.npb	= 7;
-		params->ip.sat	= 2;		/* SAT = 32-bit access */
+		params->pp.bpp	= 3;
+		params->pp.pfs	= 3;
+		params->pp.npb	= 15;
+		params->pp.sat	= 2;		/* SAT = 32-bit access */
 		u_offset = stride * height;
 		v_offset = u_offset + u_offset / 4;
 		ipu_ch_param_set_plane_offset(params, u_offset, v_offset);
 		break;
-	case IPU_PIX_FMT_YVU422P:
-		params->ip.bpp	= 3;
-		params->ip.pfs	= 2;
-		params->ip.npb	= 7;
-		params->ip.sat	= 2;		/* SAT = 32-bit access */
+	case IPU_PIX_FMT_YVU420P:
+		params->pp.bpp	= 3;
+		params->pp.pfs	= 3;
+		params->pp.npb	= 15;
+		params->pp.sat	= 2;		/* SAT = 32-bit access */
 		v_offset = stride * height;
-		u_offset = v_offset + v_offset / 2;
+		u_offset = v_offset + v_offset / 4;
 		ipu_ch_param_set_plane_offset(params, u_offset, v_offset);
 		break;
 	case IPU_PIX_FMT_YUV422P:
-		params->ip.bpp	= 3;
-		params->ip.pfs	= 2;
-		params->ip.npb	= 7;
-		params->ip.sat	= 2;		/* SAT = 32-bit access */
+		params->pp.bpp	= 3;
+		params->pp.pfs	= 2;
+		params->pp.npb	= 15;
+		params->pp.sat	= 2;		/* SAT = 32-bit access */
 		u_offset = stride * height;
 		v_offset = u_offset + u_offset / 2;
 		ipu_ch_param_set_plane_offset(params, u_offset, v_offset);
 		break;
+	case IPU_PIX_FMT_YVU422P:
+		params->pp.bpp	= 3;
+		params->pp.pfs	= 2;
+		params->pp.npb	= 15;
+		params->pp.sat	= 2;		/* SAT = 32-bit access */
+		v_offset = stride * height;
+		u_offset = v_offset + v_offset / 2;
+		ipu_ch_param_set_plane_offset(params, u_offset, v_offset);
+		break;
 	default:
 		dev_err(ipu_data.dev,
 			"mx3 ipu: unimplemented pixel format %d\n", pixel_fmt);
@@ -423,6 +483,17 @@ static void ipu_ch_param_set_size(union chan_param_mem *params,
 	params->pp.nsb = 1;
 }
 
+static uint16_t ipu_ch_param_get_burst_size(const union chan_param_mem *params)
+{
+	return params->pp.npb + 1;
+}
+
+static void ipu_ch_param_set_burst_size(union chan_param_mem *params,
+					uint16_t burst_pixels)
+{
+	params->pp.npb = burst_pixels - 1;
+}
+
 static void ipu_ch_param_set_buffer(union chan_param_mem *params,
 				    dma_addr_t buf0, dma_addr_t buf1)
 {
@@ -498,6 +569,9 @@ static int calc_resize_coeffs(uint32_t in_size, uint32_t out_size,
 static enum ipu_color_space format_to_colorspace(enum pixel_fmt fmt)
 {
 	switch (fmt) {
+	case IPU_PIX_FMT_RGB332:
+	case IPU_PIX_FMT_RGB444:
+	case IPU_PIX_FMT_RGB555:
 	case IPU_PIX_FMT_RGB565:
 	case IPU_PIX_FMT_BGR24:
 	case IPU_PIX_FMT_RGB24:
@@ -665,6 +739,7 @@ static int ipu_init_channel_buffer(struct idmac_channel *ichan,
 	unsigned long flags;
 	uint32_t reg;
 	uint32_t stride_bytes;
+	uint16_t burst_pixels;
 
 	stride_bytes = stride * bytes_per_pixel(pixel_fmt);
 
@@ -685,6 +760,29 @@ static int ipu_init_channel_buffer(struct idmac_channel *ichan,
 	ipu_ch_param_set_size(&params, pixel_fmt, width, height, stride_bytes);
 	ipu_ch_param_set_buffer(&params, phyaddr_0, phyaddr_1);
 	ipu_ch_param_set_rotation(&params, rot_mode);
+	/*
+	 * ipu_ch_param_set_size() above has set the optimal burst size for each
+	 * format, which also helps avoiding hanging channels:
+	 *  - 16 pixels for planar formats,
+	 *  - 8, 10, 16, 32 or 64 pixels for interleaved formats.
+	 */
+	burst_pixels = ipu_ch_param_get_burst_size(&params);
+	/* Some channels (rotation) have restriction on burst length */
+	switch (channel) {
+	case IDMAC_IC_0:
+	case IDMAC_IC_7:
+	default:
+		/* There is no restriction for these channels. */
+		break;
+	case IDMAC_SDC_0:
+	case IDMAC_SDC_1:
+		if (burst_pixels >= 16)
+			burst_pixels = 16;
+		else
+			burst_pixels = 8;
+		break;
+	}
+	ipu_ch_param_set_burst_size(&params, burst_pixels);
 
 	spin_lock_irqsave(&ipu->lock, flags);
 
@@ -1081,7 +1179,18 @@ static int ipu_disable_channel(struct idmac *idmac, struct idmac_channel *ichan,
 
 	if (wait_for_stop && channel != IDMAC_SDC_1 && channel != IDMAC_SDC_0) {
 		timeout = 40;
-		/* This waiting always fails. Related to spurious irq problem */
+		/*
+		 * This waiting sometimes fails because the channel has hung.
+		 * This can happen if the input stream is stopped for an active
+		 * IDMAC channel.
+		 * E.g., soc_camera_streamoff() induces a call to
+		 * mx3_videobuf_release(), which does not (and does not have to)
+		 * wait for the completion of DMA transfers before releasing the
+		 * corresponding buffers, then soc_camera_streamoff() invokes
+		 * sd->video->s_stream(), which may hence stop the input stream
+		 * for an active IDMAC channel. The current code is called only
+		 * afterwards.
+		 */
 		while ((idmac_read_icreg(ipu, IDMAC_CHA_BUSY) & chan_mask) ||
 		       (ipu_channel_status(ipu, channel) == TASK_STAT_ACTIVE)) {
 			timeout--;
@@ -1164,7 +1273,7 @@ static irqreturn_t idmac_interrupt(int irq, void *dev_id)
 	dma_async_tx_callback callback;
 	void *callback_param;
 	bool done = false;
-	u32 ready0, ready1, curbuf, err;
+	u32 ready0, ready1, curbuf, err, busy;
 	unsigned long flags;
 
 	/* IDMAC has cleared the respective BUFx_RDY bit, we manage the buffer */
@@ -1177,7 +1286,15 @@ static irqreturn_t idmac_interrupt(int irq, void *dev_id)
 	ready1	= idmac_read_ipureg(&ipu_data, IPU_CHA_BUF1_RDY);
 	curbuf	= idmac_read_ipureg(&ipu_data, IPU_CHA_CUR_BUF);
 	err	= idmac_read_ipureg(&ipu_data, IPU_INT_STAT_4);
+	busy	= idmac_read_icreg(&ipu_data, IDMAC_CHA_BUSY);
 
+	/*
+	 * If the buffer transfer is too slow compared to the frame rate, an
+	 * NF will occur before the expected channel EOF, triggering an
+	 * NFB4EOF_ERR.
+	 * This error interrupt has not been requested, so the code is handling
+	 * the first channel EOF interrupt following this error.
+	 */
 	if (err & (1 << chan_id)) {
 		idmac_write_ipureg(&ipu_data, 1 << chan_id, IPU_INT_STAT_4);
 		spin_unlock_irqrestore(&ipu_data.lock, flags);
@@ -1187,6 +1304,19 @@ static irqreturn_t idmac_interrupt(int irq, void *dev_id)
 		 * you can force channel re-enable on the next tx_submit(), but
 		 * this is dirty - think about descriptors with multiple
 		 * sg elements.
+		 * Passing back the incomplete buffer to the submitter would
+		 * also be dirty.
+		 * Reusing the incomplete buffer after the next one would imply
+		 * changing the callback call order, which may affect the
+		 * submitter.
+		 * The cleanest thing to do here would be to tell the submitter
+		 * that its buffer has been dropped and to handle the completion
+		 * of the next buffer (i.e. the current interrupt).
+		 * Unfortunately, there does not seem to be any means of doing
+		 * that.
+		 * If this error is not properly handled, the channel will hang
+		 * since this will let the channel consume its two buffers
+		 * without submitting new buffers.
 		 */
 		dev_warn(dev, "NFB4EOF on channel %d, ready %x, %x, cur %x\n",
 			 chan_id, ready0, ready1, curbuf);
@@ -1196,6 +1326,51 @@ static irqreturn_t idmac_interrupt(int irq, void *dev_id)
 
 	/* Other interrupts do not interfere with this channel */
 	spin_lock(&ichan->lock);
+	/*
+	 * The busy status has to be checked here in order to avoid considering
+	 * a legitimate interrupt as a spurious interrupt.
+	 * Actually, when double-buffering is used, the normal sequence for
+	 * DMAIC_7 is:
+	 *  - Initialization of the channel with DBMS = 1 and two buffers:
+	 *	BUF0_RDY = 1, BUF1_RDY = 1, CUR_BUF = 1, BUSY = 0
+	 *  - First CSI_NF: The channel starts handling buffer 0:
+	 *	BUF0_RDY = 0, BUF1_RDY = 1, CUR_BUF = 0, BUSY = 1
+	 *  - CSI_EOF: The channel stops handling buffer 0:
+	 *	BUF0_RDY = 0, BUF1_RDY = 1, CUR_BUF = 0, BUSY = 0
+	 *  - EOF: The channel signals buffer 0 completion:
+	 *	BUF0_RDY = 0, BUF1_RDY = 1, CUR_BUF = 0, BUSY = 0
+	 *  - The interrupt handler prepares buffer 0 with the next element:
+	 *	BUF0_RDY = 1, BUF1_RDY = 1, CUR_BUF = 0, BUSY = 0
+	 *  - CSI_NF: The channel starts handling buffer 1:
+	 *	BUF0_RDY = 1, BUF1_RDY = 0, CUR_BUF = 1, BUSY = 1
+	 *  - CSI_EOF: The channel stops handling buffer 1:
+	 *	BUF0_RDY = 1, BUF1_RDY = 0, CUR_BUF = 1, BUSY = 0
+	 *  - EOF: The channel signals buffer 1 completion:
+	 *	BUF0_RDY = 1, BUF1_RDY = 0, CUR_BUF = 1, BUSY = 0
+	 *  - The interrupt handler prepares buffer 1 with the next element:
+	 *	BUF0_RDY = 1, BUF1_RDY = 1, CUR_BUF = 1, BUSY = 0
+	 *  - CSI_NF: The channel starts handling buffer 0:
+	 *	BUF0_RDY = 0, BUF1_RDY = 1, CUR_BUF = 0, BUSY = 1
+	 *  - ...
+	 * Hence, a DMAIC_7_EOF interrupt can be received with CUR_BUF being the
+	 * active buffer if there is enough time between two consecutive CSI
+	 * frames. This is normal if the channel is not busy. This interrupt
+	 * must be used to prepare the channel for a new buffer.
+	 * If the channel is busy however, this is either a shared interrupt
+	 * that is not for this channel, or a legitimate interrupt that has been
+	 * delayed beyond the allowed update time window.
+	 */
+	if (unlikely(chan_id != IDMAC_SDC_0 && chan_id != IDMAC_SDC_1 &&
+		     (busy >> chan_id) & 1 &&
+		     ((curbuf >> chan_id) & 1) == ichan->active_buffer)) {
+		spin_unlock(&ichan->lock);
+		dev_dbg(dev,
+			"IRQ on active buffer on channel %x, active "
+			"%d, ready %x, %x, current %x!\n", chan_id,
+			ichan->active_buffer, ready0, ready1, curbuf);
+		return IRQ_NONE;
+	}
+
 	if (unlikely((ichan->active_buffer && (ready1 >> chan_id) & 1) ||
 		     (!ichan->active_buffer && (ready0 >> chan_id) & 1)
 		     )) {
@@ -1219,8 +1394,8 @@ static irqreturn_t idmac_interrupt(int irq, void *dev_id)
 
 	/*
 	 * active_buffer is a software flag, it shows which buffer we are
-	 * currently expecting back from the hardware, IDMAC should be
-	 * processing the other buffer already
+	 * currently expecting back from the hardware, IDMAC should have
+	 * finished processing this buffer already
 	 */
 	sg = &ichan->sg[ichan->active_buffer];
 	sgnext = ichan->sg[!ichan->active_buffer];
diff --git linux-3.4.5.orig/drivers/media/video/mx3_camera.c linux-3.4.5/drivers/media/video/mx3_camera.c
index 93c35ef..50c53bf 100644
--- linux-3.4.5.orig/drivers/media/video/mx3_camera.c
+++ linux-3.4.5/drivers/media/video/mx3_camera.c
@@ -243,17 +243,66 @@ static int mx3_videobuf_setup(struct vb2_queue *vq,
 	return 0;
 }
 
-static enum pixel_fmt fourcc_to_ipu_pix(__u32 fourcc)
+static u32 pixelcode_to_csi_fmt(enum v4l2_mbus_pixelcode code)
 {
-	/* Add more formats as need arises and test possibilities appear... */
-	switch (fourcc) {
-	case V4L2_PIX_FMT_RGB24:
-		return IPU_PIX_FMT_RGB24;
-	case V4L2_PIX_FMT_UYVY:
-	case V4L2_PIX_FMT_RGB565:
+	switch (code) {
+	/* CSI input formats (i.e. sensor output formats) */
+	case V4L2_MBUS_FMT_RGB24_3X8_BE:
+		return CSI_SENS_CONF_DATA_FMT_RGB_YUV444;
+	case V4L2_MBUS_FMT_UYVY8_2X8:
+		return CSI_SENS_CONF_DATA_FMT_YUV422;
+	default:
+		return CSI_SENS_CONF_DATA_FMT_BAYER;
+	}
+}
+
+static enum pixel_fmt to_ipu_pix(enum v4l2_mbus_pixelcode code, __u32 fourcc)
+{
+	const struct soc_mbus_pixelfmt *fmt = soc_mbus_get_fmtdesc(code);
+
+	if (!fmt)
+		return -EINVAL;
+
+	switch (code) {
+	/* CSI input formats (i.e. sensor output formats) */
+	case V4L2_MBUS_FMT_RGB24_3X8_BE:
+		switch (fourcc) {
+		/* IDMAC output formats */
+		case V4L2_PIX_FMT_RGB332:
+			return IPU_PIX_FMT_RGB332;
+		case V4L2_PIX_FMT_RGB444:
+			return IPU_PIX_FMT_RGB444;
+		case V4L2_PIX_FMT_RGB555:
+			return IPU_PIX_FMT_RGB555;
+		case V4L2_PIX_FMT_RGB565:
+			return IPU_PIX_FMT_RGB565;
+		case V4L2_PIX_FMT_BGR24:
+			return IPU_PIX_FMT_BGR24;
+		case V4L2_PIX_FMT_RGB24:
+			return IPU_PIX_FMT_RGB24;
+		}
+		break;
+	case V4L2_MBUS_FMT_UYVY8_2X8:
+		switch (fourcc) {
+		/* IDMAC output formats */
+		case V4L2_PIX_FMT_YVU420:
+			return IPU_PIX_FMT_YVU420P;
+		case V4L2_PIX_FMT_UYVY:
+			return IPU_PIX_FMT_UYVY;
+		case V4L2_PIX_FMT_YUV422P:
+			return IPU_PIX_FMT_YUV422P;
+		case V4L2_PIX_FMT_YUV420:
+			return IPU_PIX_FMT_YUV420P;
+		}
+		break;
 	default:
-		return IPU_PIX_FMT_GENERIC;
+		if (fmt->bits_per_sample <= 8)
+			return IPU_PIX_FMT_GENERIC;
+		else if (fmt->bits_per_sample <= 16)
+			return IPU_PIX_FMT_GENERIC_16;
+		break;
 	}
+	return -EINVAL;
 }
 
 static void mx3_videobuf_queue(struct vb2_buffer *vb)
@@ -268,6 +317,7 @@ static void mx3_videobuf_queue(struct vb2_buffer *vb)
 	struct idmac_video_param *video = &ichan->params.video;
 	const struct soc_mbus_pixelfmt *host_fmt = icd->current_fmt->host_fmt;
 	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width, host_fmt);
+	s32 width = icd->user_width;
 	unsigned long flags;
 	dma_cookie_t cookie;
 	size_t new_size;
@@ -304,29 +354,30 @@ static void mx3_videobuf_queue(struct vb2_buffer *vb)
 	vb2_set_plane_payload(vb, 0, new_size);
 
 	/* This is the configuration of one sg-element */
-	video->out_pixel_fmt = fourcc_to_ipu_pix(host_fmt->fourcc);
+	video->out_pixel_fmt = to_ipu_pix(icd->current_fmt->code,
+					  host_fmt->fourcc);
+	BUG_ON(video->out_pixel_fmt < 0);
 
-	if (video->out_pixel_fmt == IPU_PIX_FMT_GENERIC) {
+	if (video->out_pixel_fmt == IPU_PIX_FMT_GENERIC ||
+	    video->out_pixel_fmt == IPU_PIX_FMT_GENERIC_16) {
 		/*
 		 * If the IPU DMA channel is configured to transfer generic
-		 * 8-bit data, we have to set up the geometry parameters
-		 * correctly, according to the current pixel format. The DMA
-		 * horizontal parameters in this case are expressed in bytes,
-		 * not in pixels.
+		 * data, we have to set up the geometry parameters correctly,
+		 * according to the current pixel format. The DMA horizontal
+		 * parameters in this case are expressed in samples, not in
+		 * pixels.
 		 */
-		video->out_width	= bytes_per_line;
-		video->out_height	= icd->user_height;
-		video->out_stride	= bytes_per_line;
-	} else {
-		/*
-		 * For IPU known formats the pixel unit will be managed
-		 * successfully by the IPU code
-		 */
-		video->out_width	= icd->user_width;
-		video->out_height	= icd->user_height;
-		video->out_stride	= icd->user_width;
+		unsigned int num, den;
+		int ret = soc_mbus_samples_per_pixel(icd->current_fmt->host_fmt,
+						     &num, &den);
+		BUG_ON(ret < 0);
+		width = width * num / den;
 	}
 
+	video->out_width	= width;
+	video->out_height	= icd->user_height;
+	video->out_stride	= width;
+
 #ifdef DEBUG
 	/* helps to see what DMA actually has written */
 	if (vb2_plane_vaddr(vb, 0))
@@ -452,7 +503,7 @@ static struct vb2_ops mx3_videobuf_ops = {
 };
 
 static int mx3_camera_init_videobuf(struct vb2_queue *q,
-				     struct soc_camera_device *icd)
+				    struct soc_camera_device *icd)
 {
 	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	q->io_modes = VB2_MMAP | VB2_USERPTR;
@@ -562,7 +613,7 @@ static int test_platform_param(struct mx3_camera_dev *mx3_cam,
 {
 	/*
 	 * If requested data width is supported by the platform, use it or any
-	 * possible lower value - i.MX31 is smart enough to shift bits
+	 * possible lower value - i.MX3x is smart enough to shift bits
 	 */
 	if (buswidth > fls(mx3_cam->width_flags))
 		return -EINVAL;
@@ -587,16 +638,16 @@ static int test_platform_param(struct mx3_camera_dev *mx3_cam,
 }
 
 static int mx3_camera_try_bus_param(struct soc_camera_device *icd,
-				    const unsigned int depth)
+				    unsigned int buswidth)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
 	struct v4l2_mbus_config cfg = {.type = V4L2_MBUS_PARALLEL,};
 	unsigned long bus_flags, common_flags;
-	int ret = test_platform_param(mx3_cam, depth, &bus_flags);
+	int ret = test_platform_param(mx3_cam, buswidth, &bus_flags);
 
-	dev_dbg(icd->parent, "request bus width %d bit: %d\n", depth, ret);
+	dev_dbg(icd->parent, "requested bus width %d bit: %d\n", buswidth, ret);
 
 	if (ret < 0)
 		return ret;
@@ -635,30 +686,77 @@ static bool chan_filter(struct dma_chan *chan, void *arg)
 		pdata->dma_dev == chan->device->dev;
 }
 
-static const struct soc_mbus_pixelfmt mx3_camera_formats[] = {
+static const struct soc_mbus_pixelfmt mx3_camera_formats_rgb[] = {
 	{
-		.fourcc			= V4L2_PIX_FMT_SBGGR8,
-		.name			= "Bayer BGGR (sRGB) 8 bit",
+		.fourcc			= V4L2_PIX_FMT_RGB332,
+		.name			= "Packed RGB332",
 		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_1X8_PADHI,
+		.order			= SOC_MBUS_ORDER_LE,
+	}, {
+		.fourcc			= V4L2_PIX_FMT_RGB444,
+		.name			= "Packed RGB444",
+		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
+		.order			= SOC_MBUS_ORDER_LE,
+	}, {
+		.fourcc			= V4L2_PIX_FMT_RGB555,
+		.name			= "Packed RGB555",
+		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
+		.order			= SOC_MBUS_ORDER_LE,
+	}, {
+		.fourcc			= V4L2_PIX_FMT_RGB565,
+		.name			= "Packed RGB565",
+		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
+		.order			= SOC_MBUS_ORDER_LE,
+	}, {
+		.fourcc			= V4L2_PIX_FMT_BGR24,
+		.name			= "BGR24",
+		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_3X8_PADHI,
+		.order			= SOC_MBUS_ORDER_LE,
+	}, {
+		.fourcc			= V4L2_PIX_FMT_RGB24,
+		.name			= "RGB24",
+		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_3X8_PADHI,
+		.order			= SOC_MBUS_ORDER_LE,
+	},
+};
+
+static const struct soc_mbus_pixelfmt mx3_camera_formats_yuv[] = {
+	{
+		.fourcc			= V4L2_PIX_FMT_YVU420,
+		.name			= "Planar YVU 4:2:0 12 bit",
+		.bits_per_sample	= 12,
 		.packing		= SOC_MBUS_PACKING_NONE,
 		.order			= SOC_MBUS_ORDER_LE,
 	}, {
-		.fourcc			= V4L2_PIX_FMT_GREY,
-		.name			= "Monochrome 8 bit",
+		.fourcc			= V4L2_PIX_FMT_UYVY,
+		.name			= "Interleaved YUV 4:2:2 (UYVY) 16 bit",
 		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
+		.order			= SOC_MBUS_ORDER_LE,
+	}, {
+		.fourcc			= V4L2_PIX_FMT_YUV422P,
+		.name			= "Planar YUV 4:2:2 16 bit",
+		.bits_per_sample	= 16,
+		.packing		= SOC_MBUS_PACKING_NONE,
+		.order			= SOC_MBUS_ORDER_LE,
+	}, {
+		.fourcc			= V4L2_PIX_FMT_YUV420,
+		.name			= "Planar YUV 4:2:0 12 bit",
+		.bits_per_sample	= 12,
 		.packing		= SOC_MBUS_PACKING_NONE,
 		.order			= SOC_MBUS_ORDER_LE,
 	},
 };
 
-/* This will be corrected as we get more formats */
-static bool mx3_camera_packing_supported(const struct soc_mbus_pixelfmt *fmt)
+static bool mx3_camera_passthrough_supported(const struct soc_mbus_pixelfmt *fmt)
 {
-	return	fmt->packing == SOC_MBUS_PACKING_NONE ||
-		(fmt->bits_per_sample == 8 &&
-		 fmt->packing == SOC_MBUS_PACKING_2X8_PADHI) ||
-		(fmt->bits_per_sample > 8 &&
-		 fmt->packing == SOC_MBUS_PACKING_EXTEND16);
+	return fmt->bits_per_sample == 8 && fmt->order == SOC_MBUS_ORDER_LE;
 }
 
 static int mx3_camera_get_formats(struct soc_camera_device *icd, unsigned int idx,
@@ -666,9 +764,9 @@ static int mx3_camera_get_formats(struct soc_camera_device *icd, unsigned int id
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct device *dev = icd->parent;
-	int formats = 0, ret;
+	int formats = 0, k, n = 0, ret;
 	enum v4l2_mbus_pixelcode code;
-	const struct soc_mbus_pixelfmt *fmt;
+	const struct soc_mbus_pixelfmt *fmt, *mx3_camera_formats;
 
 	ret = v4l2_subdev_call(sd, video, enum_mbus_fmt, idx, &code);
 	if (ret < 0)
@@ -688,41 +786,42 @@ static int mx3_camera_get_formats(struct soc_camera_device *icd, unsigned int id
 		return 0;
 
 	switch (code) {
-	case V4L2_MBUS_FMT_SBGGR10_1X10:
-		formats++;
-		if (xlate) {
-			xlate->host_fmt	= &mx3_camera_formats[0];
-			xlate->code	= code;
-			xlate++;
-			dev_dbg(dev, "Providing format %s using code %d\n",
-				mx3_camera_formats[0].name, code);
-		}
+	/* CSI input formats (i.e. sensor output formats) */
+	case V4L2_MBUS_FMT_RGB24_3X8_BE:
+		mx3_camera_formats = mx3_camera_formats_rgb;
+		n = ARRAY_SIZE(mx3_camera_formats_rgb);
+		break;
+	case V4L2_MBUS_FMT_UYVY8_2X8:
+		mx3_camera_formats = mx3_camera_formats_yuv;
+		n = ARRAY_SIZE(mx3_camera_formats_yuv);
 		break;
 	case V4L2_MBUS_FMT_Y10_1X10:
-		formats++;
-		if (xlate) {
-			xlate->host_fmt	= &mx3_camera_formats[1];
-			xlate->code	= code;
-			xlate++;
-			dev_dbg(dev, "Providing format %s using code %d\n",
-				mx3_camera_formats[1].name, code);
-		}
+		mx3_camera_formats = soc_mbus_get_fmtdesc(V4L2_MBUS_FMT_Y16_1X16);
+		n = 1;
+		break;
+	case V4L2_MBUS_FMT_SBGGR10_1X10:
+		mx3_camera_formats = soc_mbus_get_fmtdesc(V4L2_MBUS_FMT_SBGGR16_1X16);
+		n = 1;
 		break;
 	default:
-		if (!mx3_camera_packing_supported(fmt))
-			return 0;
+		if (mx3_camera_passthrough_supported(fmt)) {
+			mx3_camera_formats = fmt;
+			n = 1;
+		}
+		break;
 	}
 
-	/* Generic pass-through */
-	formats++;
-	if (xlate) {
-		xlate->host_fmt	= fmt;
+	formats += n;
+	for (k = 0; xlate && k < n; k++) {
+		BUG_ON(!mx3_camera_formats);
+		xlate->host_fmt	= &mx3_camera_formats[k];
 		xlate->code	= code;
-		dev_dbg(dev, "Providing format %c%c%c%c in pass-through mode\n",
-			(fmt->fourcc >> (0*8)) & 0xFF,
-			(fmt->fourcc >> (1*8)) & 0xFF,
-			(fmt->fourcc >> (2*8)) & 0xFF,
-			(fmt->fourcc >> (3*8)) & 0xFF);
+		dev_dbg(dev, "Providing format %c%c%c%c from media bus data format %d\n",
+			(xlate->host_fmt->fourcc >> (0*8)) & 0xFF,
+			(xlate->host_fmt->fourcc >> (1*8)) & 0xFF,
+			(xlate->host_fmt->fourcc >> (2*8)) & 0xFF,
+			(xlate->host_fmt->fourcc >> (3*8)) & 0xFF,
+			code);
 		xlate++;
 	}
 
@@ -731,11 +830,15 @@ static int mx3_camera_get_formats(struct soc_camera_device *icd, unsigned int id
 
 static void configure_geometry(struct mx3_camera_dev *mx3_cam,
 			       unsigned int width, unsigned int height,
-			       const struct soc_mbus_pixelfmt *fmt)
+			       enum v4l2_mbus_pixelcode code)
 {
 	u32 ctrl, width_field, height_field;
+	const struct soc_mbus_pixelfmt *fmt;
 
-	if (fourcc_to_ipu_pix(fmt->fourcc) == IPU_PIX_FMT_GENERIC) {
+	fmt = soc_mbus_get_fmtdesc(code);
+	BUG_ON(!fmt);
+
+	if (pixelcode_to_csi_fmt(code) == CSI_SENS_CONF_DATA_FMT_BAYER) {
 		/*
 		 * As the CSI will be configured to output BAYER, here
 		 * the width parameter count the number of samples to
@@ -835,8 +938,7 @@ static int mx3_camera_set_crop(struct soc_camera_device *icd,
 	}
 
 	if (mf.width != icd->user_width || mf.height != icd->user_height)
-		configure_geometry(mx3_cam, mf.width, mf.height,
-				   icd->current_fmt->host_fmt);
+		configure_geometry(mx3_cam, mf.width, mf.height, mf.code);
 
 	dev_dbg(icd->parent, "Sensor cropped %dx%d\n",
 		mf.width, mf.height);
@@ -874,7 +976,7 @@ static int mx3_camera_set_fmt(struct soc_camera_device *icd,
 	 * mxc_v4l2_s_fmt()
 	 */
 
-	configure_geometry(mx3_cam, pix->width, pix->height, xlate->host_fmt);
+	configure_geometry(mx3_cam, pix->width, pix->height, xlate->code);
 
 	mf.width	= pix->width;
 	mf.height	= pix->height;
@@ -1089,10 +1191,8 @@ static int mx3_camera_set_bus_param(struct soc_camera_device *icd)
 		  (3 << CSI_SENS_CONF_DATA_FMT_SHIFT) |
 		  (3 << CSI_SENS_CONF_DATA_WIDTH_SHIFT));
 
-	/* TODO: Support RGB and YUV formats */
-
-	/* This has been set in mx3_camera_activate(), but we clear it above */
-	sens_conf |= CSI_SENS_CONF_DATA_FMT_BAYER;
+	/* Set data format */
+	sens_conf |= pixelcode_to_csi_fmt(icd->current_fmt->code);
 
 	if (common_flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
 		sens_conf |= 1 << CSI_SENS_CONF_PIX_CLK_POL_SHIFT;
@@ -1104,7 +1204,7 @@ static int mx3_camera_set_bus_param(struct soc_camera_device *icd)
 		sens_conf |= 1 << CSI_SENS_CONF_DATA_POL_SHIFT;
 
 	/* Just do what we're asked to do */
-	switch (xlate->host_fmt->bits_per_sample) {
+	switch (buswidth) {
 	case 4:
 		dw = 0 << CSI_SENS_CONF_DATA_WIDTH_SHIFT;
 		break;
diff --git linux-3.4.5.orig/drivers/media/video/soc_mediabus.c linux-3.4.5/drivers/media/video/soc_mediabus.c
index cf7f219..c9a2cce 100644
--- linux-3.4.5.orig/drivers/media/video/soc_mediabus.c
+++ linux-3.4.5/drivers/media/video/soc_mediabus.c
@@ -17,37 +17,37 @@
 
 static const struct soc_mbus_lookup mbus_fmt[] = {
 {
-	.code = V4L2_MBUS_FMT_YUYV8_2X8,
+	.code = V4L2_MBUS_FMT_RGB332_1X8,
 	.fmt = {
-		.fourcc			= V4L2_PIX_FMT_YUYV,
-		.name			= "YUYV",
+		.fourcc			= V4L2_PIX_FMT_RGB332,
+		.name			= "RGB332",
 		.bits_per_sample	= 8,
-		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
+		.packing		= SOC_MBUS_PACKING_1X8_PADHI,
 		.order			= SOC_MBUS_ORDER_LE,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_YVYU8_2X8,
+	.code = V4L2_MBUS_FMT_RGB444_2X8_PADHI_BE,
 	.fmt = {
-		.fourcc			= V4L2_PIX_FMT_YVYU,
-		.name			= "YVYU",
+		.fourcc			= V4L2_PIX_FMT_RGB444,
+		.name			= "RGB444",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
-		.order			= SOC_MBUS_ORDER_LE,
+		.order			= SOC_MBUS_ORDER_BE,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_UYVY8_2X8,
+	.code = V4L2_MBUS_FMT_RGB444_2X8_PADHI_LE,
 	.fmt = {
-		.fourcc			= V4L2_PIX_FMT_UYVY,
-		.name			= "UYVY",
+		.fourcc			= V4L2_PIX_FMT_RGB444,
+		.name			= "RGB444",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_LE,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_VYUY8_2X8,
+	.code = V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE,
 	.fmt = {
-		.fourcc			= V4L2_PIX_FMT_VYUY,
-		.name			= "VYUY",
+		.fourcc			= V4L2_PIX_FMT_RGB555X,
+		.name			= "RGB555X",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_LE,
@@ -62,10 +62,10 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.order			= SOC_MBUS_ORDER_LE,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE,
+	.code = V4L2_MBUS_FMT_RGB565_2X8_BE,
 	.fmt = {
-		.fourcc			= V4L2_PIX_FMT_RGB555X,
-		.name			= "RGB555X",
+		.fourcc			= V4L2_PIX_FMT_RGB565X,
+		.name			= "RGB565X",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_LE,
@@ -80,30 +80,21 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.order			= SOC_MBUS_ORDER_LE,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_RGB565_2X8_BE,
+	.code = V4L2_MBUS_FMT_RGB24_3X8_BE,
 	.fmt = {
-		.fourcc			= V4L2_PIX_FMT_RGB565X,
-		.name			= "RGB565X",
+		.fourcc			= V4L2_PIX_FMT_RGB24,
+		.name			= "RGB24",
 		.bits_per_sample	= 8,
-		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
+		.packing		= SOC_MBUS_PACKING_3X8_PADHI,
 		.order			= SOC_MBUS_ORDER_LE,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_SBGGR8_1X8,
+	.code = V4L2_MBUS_FMT_RGB24_3X8_LE,
 	.fmt = {
-		.fourcc			= V4L2_PIX_FMT_SBGGR8,
-		.name			= "Bayer 8 BGGR",
+		.fourcc			= V4L2_PIX_FMT_BGR24,
+		.name			= "BGR24",
 		.bits_per_sample	= 8,
-		.packing		= SOC_MBUS_PACKING_NONE,
-		.order			= SOC_MBUS_ORDER_LE,
-	},
-}, {
-	.code = V4L2_MBUS_FMT_SBGGR10_1X10,
-	.fmt = {
-		.fourcc			= V4L2_PIX_FMT_SBGGR10,
-		.name			= "Bayer 10 BGGR",
-		.bits_per_sample	= 10,
-		.packing		= SOC_MBUS_PACKING_EXTEND16,
+		.packing		= SOC_MBUS_PACKING_3X8_PADHI,
 		.order			= SOC_MBUS_ORDER_LE,
 	},
 }, {
@@ -116,84 +107,75 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.order			= SOC_MBUS_ORDER_LE,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_Y10_1X10,
+	.code = V4L2_MBUS_FMT_YUYV8_1_5X8,
 	.fmt = {
-		.fourcc			= V4L2_PIX_FMT_Y10,
-		.name			= "Grey 10bit",
-		.bits_per_sample	= 10,
-		.packing		= SOC_MBUS_PACKING_EXTEND16,
+		.fourcc			= V4L2_PIX_FMT_YUV420,
+		.name			= "YUYV 4:2:0",
+		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_1_5X8,
 		.order			= SOC_MBUS_ORDER_LE,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE,
+	.code = V4L2_MBUS_FMT_YVYU8_1_5X8,
 	.fmt = {
-		.fourcc			= V4L2_PIX_FMT_SBGGR10,
-		.name			= "Bayer 10 BGGR",
+		.fourcc			= V4L2_PIX_FMT_YVU420,
+		.name			= "YVYU 4:2:0",
 		.bits_per_sample	= 8,
-		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
+		.packing		= SOC_MBUS_PACKING_1_5X8,
 		.order			= SOC_MBUS_ORDER_LE,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_LE,
+	.code = V4L2_MBUS_FMT_UYVY8_2X8,
 	.fmt = {
-		.fourcc			= V4L2_PIX_FMT_SBGGR10,
-		.name			= "Bayer 10 BGGR",
+		.fourcc			= V4L2_PIX_FMT_UYVY,
+		.name			= "UYVY",
 		.bits_per_sample	= 8,
-		.packing		= SOC_MBUS_PACKING_2X8_PADLO,
+		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_LE,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE,
+	.code = V4L2_MBUS_FMT_VYUY8_2X8,
 	.fmt = {
-		.fourcc			= V4L2_PIX_FMT_SBGGR10,
-		.name			= "Bayer 10 BGGR",
+		.fourcc			= V4L2_PIX_FMT_VYUY,
+		.name			= "VYUY",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
-		.order			= SOC_MBUS_ORDER_BE,
+		.order			= SOC_MBUS_ORDER_LE,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE,
+	.code = V4L2_MBUS_FMT_YUYV8_2X8,
 	.fmt = {
-		.fourcc			= V4L2_PIX_FMT_SBGGR10,
-		.name			= "Bayer 10 BGGR",
+		.fourcc			= V4L2_PIX_FMT_YUYV,
+		.name			= "YUYV",
 		.bits_per_sample	= 8,
-		.packing		= SOC_MBUS_PACKING_2X8_PADLO,
-		.order			= SOC_MBUS_ORDER_BE,
-	},
-}, {
-	.code = V4L2_MBUS_FMT_JPEG_1X8,
-	.fmt = {
-		.fourcc                 = V4L2_PIX_FMT_JPEG,
-		.name                   = "JPEG",
-		.bits_per_sample        = 8,
-		.packing                = SOC_MBUS_PACKING_VARIABLE,
-		.order                  = SOC_MBUS_ORDER_LE,
+		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
+		.order			= SOC_MBUS_ORDER_LE,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_RGB444_2X8_PADHI_BE,
+	.code = V4L2_MBUS_FMT_YVYU8_2X8,
 	.fmt = {
-		.fourcc			= V4L2_PIX_FMT_RGB444,
-		.name			= "RGB444",
+		.fourcc			= V4L2_PIX_FMT_YVYU,
+		.name			= "YVYU",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
-		.order			= SOC_MBUS_ORDER_BE,
+		.order			= SOC_MBUS_ORDER_LE,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_YUYV8_1_5X8,
+	.code = V4L2_MBUS_FMT_Y10_1X10,
 	.fmt = {
-		.fourcc			= V4L2_PIX_FMT_YUV420,
-		.name			= "YUYV 4:2:0",
-		.bits_per_sample	= 8,
-		.packing		= SOC_MBUS_PACKING_1_5X8,
+		.fourcc			= V4L2_PIX_FMT_Y10,
+		.name			= "Grey 10bit",
+		.bits_per_sample	= 10,
+		.packing		= SOC_MBUS_PACKING_EXTEND16,
 		.order			= SOC_MBUS_ORDER_LE,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_YVYU8_1_5X8,
+	.code = V4L2_MBUS_FMT_Y12_1X12,
 	.fmt = {
-		.fourcc			= V4L2_PIX_FMT_YVU420,
-		.name			= "YVYU 4:2:0",
-		.bits_per_sample	= 8,
-		.packing		= SOC_MBUS_PACKING_1_5X8,
+		.fourcc			= V4L2_PIX_FMT_Y12,
+		.name			= "Grey 12bit",
+		.bits_per_sample	= 12,
+		.packing		= SOC_MBUS_PACKING_EXTEND16,
 		.order			= SOC_MBUS_ORDER_LE,
 	},
 }, {
@@ -233,6 +215,33 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.order			= SOC_MBUS_ORDER_LE,
 	},
 }, {
+	.code = V4L2_MBUS_FMT_Y16_1X16,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_Y16,
+		.name			= "Grey 16bit",
+		.bits_per_sample	= 16,
+		.packing		= SOC_MBUS_PACKING_NONE,
+		.order			= SOC_MBUS_ORDER_LE,
+	},
+}, {
+	.code = V4L2_MBUS_FMT_SBGGR8_1X8,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_SBGGR8,
+		.name			= "Bayer 8 BGGR",
+		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_NONE,
+		.order			= SOC_MBUS_ORDER_LE,
+	},
+}, {
+	.code = V4L2_MBUS_FMT_SGBRG8_1X8,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_SGBRG8,
+		.name			= "Bayer 8 GBRG",
+		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_NONE,
+		.order			= SOC_MBUS_ORDER_LE,
+	},
+}, {
 	.code = V4L2_MBUS_FMT_SGRBG8_1X8,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_SGRBG8,
@@ -242,15 +251,69 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.order			= SOC_MBUS_ORDER_LE,
 	},
 }, {
+	.code = V4L2_MBUS_FMT_SRGGB8_1X8,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_SRGGB8,
+		.name			= "Bayer 8 RGGB",
+		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_NONE,
+		.order			= SOC_MBUS_ORDER_LE,
+	},
+}, {
 	.code = V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_SGRBG10DPCM8,
-		.name			= "Bayer 10 BGGR DPCM 8",
+		.name			= "Bayer 10 GRBG DPCM 8",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_NONE,
 		.order			= SOC_MBUS_ORDER_LE,
 	},
 }, {
+	.code = V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_SBGGR10,
+		.name			= "Bayer 10 BGGR",
+		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
+		.order			= SOC_MBUS_ORDER_BE,
+	},
+}, {
+	.code = V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_SBGGR10,
+		.name			= "Bayer 10 BGGR",
+		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
+		.order			= SOC_MBUS_ORDER_LE,
+	},
+}, {
+	.code = V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_SBGGR10,
+		.name			= "Bayer 10 BGGR",
+		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_2X8_PADLO,
+		.order			= SOC_MBUS_ORDER_BE,
+	},
+}, {
+	.code = V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_LE,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_SBGGR10,
+		.name			= "Bayer 10 BGGR",
+		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_2X8_PADLO,
+		.order			= SOC_MBUS_ORDER_LE,
+	},
+}, {
+	.code = V4L2_MBUS_FMT_SBGGR10_1X10,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_SBGGR10,
+		.name			= "Bayer 10 BGGR",
+		.bits_per_sample	= 10,
+		.packing		= SOC_MBUS_PACKING_EXTEND16,
+		.order			= SOC_MBUS_ORDER_LE,
+	},
+}, {
 	.code = V4L2_MBUS_FMT_SGBRG10_1X10,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_SGBRG10,
@@ -313,6 +376,24 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.packing		= SOC_MBUS_PACKING_EXTEND16,
 		.order			= SOC_MBUS_ORDER_LE,
 	},
+}, {
+	.code = V4L2_MBUS_FMT_SBGGR16_1X16,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_SBGGR16,
+		.name			= "Bayer 16 BGGR",
+		.bits_per_sample	= 16,
+		.packing		= SOC_MBUS_PACKING_NONE,
+		.order			= SOC_MBUS_ORDER_LE,
+	},
+}, {
+	.code = V4L2_MBUS_FMT_JPEG_1X8,
+	.fmt = {
+		.fourcc                 = V4L2_PIX_FMT_JPEG,
+		.name                   = "JPEG",
+		.bits_per_sample        = 8,
+		.packing                = SOC_MBUS_PACKING_VARIABLE,
+		.order                  = SOC_MBUS_ORDER_LE,
+	},
 },
 };
 
@@ -321,18 +402,33 @@ int soc_mbus_samples_per_pixel(const struct soc_mbus_pixelfmt *mf,
 {
 	switch (mf->packing) {
 	case SOC_MBUS_PACKING_NONE:
+	case SOC_MBUS_PACKING_1X8_PADHI:
+	case SOC_MBUS_PACKING_1X8_PADLO:
+	case SOC_MBUS_PACKING_EXTEND8:
 	case SOC_MBUS_PACKING_EXTEND16:
+	case SOC_MBUS_PACKING_EXTEND24:
+	case SOC_MBUS_PACKING_EXTEND32:
 		*numerator = 1;
 		*denominator = 1;
 		return 0;
+	case SOC_MBUS_PACKING_1_5X8:
+		*numerator = 3;
+		*denominator = 2;
+		return 0;
 	case SOC_MBUS_PACKING_2X8_PADHI:
 	case SOC_MBUS_PACKING_2X8_PADLO:
 		*numerator = 2;
 		*denominator = 1;
 		return 0;
-	case SOC_MBUS_PACKING_1_5X8:
+	case SOC_MBUS_PACKING_3X8_PADHI:
+	case SOC_MBUS_PACKING_3X8_PADLO:
 		*numerator = 3;
-		*denominator = 2;
+		*denominator = 1;
+		return 0;
+	case SOC_MBUS_PACKING_4X8_PADHI:
+	case SOC_MBUS_PACKING_4X8_PADLO:
+		*numerator = 4;
+		*denominator = 1;
 		return 0;
 	case SOC_MBUS_PACKING_VARIABLE:
 		*numerator = 0;
@@ -348,12 +444,24 @@ s32 soc_mbus_bytes_per_line(u32 width, const struct soc_mbus_pixelfmt *mf)
 	switch (mf->packing) {
 	case SOC_MBUS_PACKING_NONE:
 		return width * mf->bits_per_sample / 8;
+	case SOC_MBUS_PACKING_1X8_PADHI:
+	case SOC_MBUS_PACKING_1X8_PADLO:
+	case SOC_MBUS_PACKING_EXTEND8:
+		return width * 1;
+	case SOC_MBUS_PACKING_1_5X8:
+		return width * 3 / 2;
 	case SOC_MBUS_PACKING_2X8_PADHI:
 	case SOC_MBUS_PACKING_2X8_PADLO:
 	case SOC_MBUS_PACKING_EXTEND16:
 		return width * 2;
-	case SOC_MBUS_PACKING_1_5X8:
-		return width * 3 / 2;
+	case SOC_MBUS_PACKING_3X8_PADHI:
+	case SOC_MBUS_PACKING_3X8_PADLO:
+	case SOC_MBUS_PACKING_EXTEND24:
+		return width * 3;
+	case SOC_MBUS_PACKING_4X8_PADHI:
+	case SOC_MBUS_PACKING_4X8_PADLO:
+	case SOC_MBUS_PACKING_EXTEND32:
+		return width * 4;
 	case SOC_MBUS_PACKING_VARIABLE:
 		return 0;
 	}
diff --git linux-3.4.5.orig/include/linux/v4l2-mediabus.h linux-3.4.5/include/linux/v4l2-mediabus.h
index 5ea7f75..57a9fc9 100644
--- linux-3.4.5.orig/include/linux/v4l2-mediabus.h
+++ linux-3.4.5/include/linux/v4l2-mediabus.h
@@ -37,7 +37,8 @@
 enum v4l2_mbus_pixelcode {
 	V4L2_MBUS_FMT_FIXED = 0x0001,
 
-	/* RGB - next is 0x1009 */
+	/* RGB - next is 0x100c */
+	V4L2_MBUS_FMT_RGB332_1X8 = 0x1009,
 	V4L2_MBUS_FMT_RGB444_2X8_PADHI_BE = 0x1001,
 	V4L2_MBUS_FMT_RGB444_2X8_PADHI_LE = 0x1002,
 	V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE = 0x1003,
@@ -46,8 +47,10 @@ enum v4l2_mbus_pixelcode {
 	V4L2_MBUS_FMT_BGR565_2X8_LE = 0x1006,
 	V4L2_MBUS_FMT_RGB565_2X8_BE = 0x1007,
 	V4L2_MBUS_FMT_RGB565_2X8_LE = 0x1008,
+	V4L2_MBUS_FMT_RGB24_3X8_BE = 0x100a,
+	V4L2_MBUS_FMT_RGB24_3X8_LE = 0x100b,
 
-	/* YUV (including grey) - next is 0x2014 */
+	/* YUV (including grey) - next is 0x2015 */
 	V4L2_MBUS_FMT_Y8_1X8 = 0x2001,
 	V4L2_MBUS_FMT_UYVY8_1_5X8 = 0x2002,
 	V4L2_MBUS_FMT_VYUY8_1_5X8 = 0x2003,
@@ -65,10 +68,11 @@ enum v4l2_mbus_pixelcode {
 	V4L2_MBUS_FMT_VYUY8_1X16 = 0x2010,
 	V4L2_MBUS_FMT_YUYV8_1X16 = 0x2011,
 	V4L2_MBUS_FMT_YVYU8_1X16 = 0x2012,
+	V4L2_MBUS_FMT_Y16_1X16 = 0x2014,
 	V4L2_MBUS_FMT_YUYV10_1X20 = 0x200d,
 	V4L2_MBUS_FMT_YVYU10_1X20 = 0x200e,
 
-	/* Bayer - next is 0x3015 */
+	/* Bayer - next is 0x3016 */
 	V4L2_MBUS_FMT_SBGGR8_1X8 = 0x3001,
 	V4L2_MBUS_FMT_SGBRG8_1X8 = 0x3013,
 	V4L2_MBUS_FMT_SGRBG8_1X8 = 0x3002,
@@ -89,6 +93,7 @@ enum v4l2_mbus_pixelcode {
 	V4L2_MBUS_FMT_SGBRG12_1X12 = 0x3010,
 	V4L2_MBUS_FMT_SGRBG12_1X12 = 0x3011,
 	V4L2_MBUS_FMT_SRGGB12_1X12 = 0x3012,
+	V4L2_MBUS_FMT_SBGGR16_1X16 = 0x3015,
 
 	/* JPEG compressed formats - next is 0x4002 */
 	V4L2_MBUS_FMT_JPEG_1X8 = 0x4001,
diff --git linux-3.4.5.orig/include/media/soc_mediabus.h linux-3.4.5/include/media/soc_mediabus.h
index 73f1e7e..90a2140 100644
--- linux-3.4.5.orig/include/media/soc_mediabus.h
+++ linux-3.4.5/include/media/soc_mediabus.h
@@ -18,22 +18,46 @@
  * enum soc_mbus_packing - data packing types on the media-bus
  * @SOC_MBUS_PACKING_NONE:	no packing, bit-for-bit transfer to RAM, one
  *				sample represents one pixel
+ * @SOC_MBUS_PACKING_1X8_PADHI:	8 bits transferred in 1 8-bit sample, in the
+ *				possibly incomplete byte high bits are padding
+ * @SOC_MBUS_PACKING_1X8_PADLO:	as above, but low bits are padding
+ * @SOC_MBUS_PACKING_EXTEND8:	sample width (e.g., 4 bits) has to be extended
+ *				to 8 bits
+ * @SOC_MBUS_PACKING_1_5X8:	used for packed YUV 4:2:0 formats, where 4
+ *				pixels occupy 6 bytes in RAM
  * @SOC_MBUS_PACKING_2X8_PADHI:	16 bits transferred in 2 8-bit samples, in the
  *				possibly incomplete byte high bits are padding
  * @SOC_MBUS_PACKING_2X8_PADLO:	as above, but low bits are padding
  * @SOC_MBUS_PACKING_EXTEND16:	sample width (e.g., 10 bits) has to be extended
  *				to 16 bits
+ * @SOC_MBUS_PACKING_3X8_PADHI:	24 bits transferred in 3 8-bit samples, in the
+ *				possibly incomplete byte high bits are padding
+ * @SOC_MBUS_PACKING_3X8_PADLO:	as above, but low bits are padding
+ * @SOC_MBUS_PACKING_EXTEND24:	sample width (e.g., 10 bits) has to be extended
+ *				to 24 bits
+ * @SOC_MBUS_PACKING_4X8_PADHI:	32 bits transferred in 4 8-bit samples, in the
+ *				possibly incomplete byte high bits are padding
+ * @SOC_MBUS_PACKING_4X8_PADLO:	as above, but low bits are padding
+ * @SOC_MBUS_PACKING_EXTEND32:	sample width (e.g., 10 bits) has to be extended
+ *				to 32 bits
  * @SOC_MBUS_PACKING_VARIABLE:	compressed formats with variable packing
- * @SOC_MBUS_PACKING_1_5X8:	used for packed YUV 4:2:0 formats, where 4
- *				pixels occupy 6 bytes in RAM
  */
 enum soc_mbus_packing {
 	SOC_MBUS_PACKING_NONE,
+	SOC_MBUS_PACKING_1X8_PADHI,
+	SOC_MBUS_PACKING_1X8_PADLO,
+	SOC_MBUS_PACKING_EXTEND8,
+	SOC_MBUS_PACKING_1_5X8,
 	SOC_MBUS_PACKING_2X8_PADHI,
 	SOC_MBUS_PACKING_2X8_PADLO,
 	SOC_MBUS_PACKING_EXTEND16,
+	SOC_MBUS_PACKING_3X8_PADHI,
+	SOC_MBUS_PACKING_3X8_PADLO,
+	SOC_MBUS_PACKING_EXTEND24,
+	SOC_MBUS_PACKING_4X8_PADHI,
+	SOC_MBUS_PACKING_4X8_PADLO,
+	SOC_MBUS_PACKING_EXTEND32,
 	SOC_MBUS_PACKING_VARIABLE,
-	SOC_MBUS_PACKING_1_5X8,
 };
 
 /**
