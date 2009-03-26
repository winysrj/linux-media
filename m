Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.emlix.com ([193.175.82.87]:38246 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756977AbZCZOgI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Mar 2009 10:36:08 -0400
From: =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Chris Zankel <chris@zankel.net>, linux-media@vger.kernel.org,
	=?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>,
	Oskar Schirmer <os@emlix.com>
Subject: [patch 2/5] s6000 data port: custom video mode support
Date: Thu, 26 Mar 2009 15:36:56 +0100
Message-Id: <1238078219-25904-2-git-send-email-dg@emlix.com>
In-Reply-To: <1238078219-25904-1-git-send-email-dg@emlix.com>
References: <1238078219-25904-1-git-send-email-dg@emlix.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Extend s6dp driver to support direct MPEG2 and data streaming modes.
Provide ioctl access to select specific modes.

Signed-off-by: Oskar Schirmer <os@emlix.com>
---
 .../platforms/s6105/include/platform/ioctl.h       |   59 +++
 drivers/media/video/s6dp/s6dp.c                    |  393 +++++++++++++++++--
 2 files changed, 410 insertions(+), 42 deletions(-)

diff --git a/arch/xtensa/platforms/s6105/include/platform/ioctl.h b/arch/xtensa/platforms/s6105/include/platform/ioctl.h
index 0fc6e2c..da88b4c 100644
--- a/arch/xtensa/platforms/s6105/include/platform/ioctl.h
+++ b/arch/xtensa/platforms/s6105/include/platform/ioctl.h
@@ -14,4 +14,63 @@
 #define S6IOCTL_ISEF_PRELOAD		_IO(56, 1)
 #define S6IOCTL_ISEF_INVALIDATE		_IO(56, 2)
 
+#define MODE_CUSTOM_VIDEO	28
+#define ITU_H222_TRANS		29	/* MPEG2 TS, 188 bytes */
+#define ITU_H222_TRANS_RS	30	/* MPEG2 TS, valid RS, 204 bytes */
+#define ITU_H222_TRANS_RS_DUMMY	31	/* MPEG2 TS, invalid RS, 204 bytes */
+#define STREAM8			32
+#define STREAM16		33
+#define STREAM32		34
+
+#define NUM_MODES		35
+#define MODE_LAST_VIDEO		MODE_CUSTOM_VIDEO
+
+struct s6dp_ioctl_config {
+	unsigned char mode;
+	unsigned char lane;
+	unsigned char is_10bit;
+	unsigned char micron_mode;
+	unsigned char use_1120_line_and_crc;
+	unsigned char ext_framing;
+	unsigned char vsync_pol;
+	unsigned char hsync_pol;
+	unsigned char blank_pol;
+	unsigned char field_ctrl;
+	unsigned char blank_ctrl;
+	unsigned char relaxed_framing_mode;
+	unsigned int desc_size;
+	struct {
+		unsigned int width;
+		unsigned int height;
+		unsigned char portsperstream;
+		unsigned char greyperchroma;
+		unsigned char progressive;
+		struct {
+			unsigned int pixel_total;
+			unsigned int pixel_offset;
+			unsigned int pixel_padding;
+			unsigned int line_total;
+			unsigned int line_odd_total;
+			unsigned int line_odd_offset;
+			unsigned int line_even_offset;
+			unsigned int odd_vsync_len;
+			unsigned int odd_vsync_offset;
+			unsigned int even_vsync_len;
+			unsigned int even_vsync_offset;
+			unsigned int odd_hsync_len;
+			unsigned int odd_hsync_offset;
+			unsigned int even_hsync_len;
+			unsigned int even_hsync_offset;
+		} reg;
+	} custom;
+	struct {
+		int pix_start;
+		unsigned int line_start;
+		unsigned int line_width;
+		unsigned int num_lines;
+	} anc_placement[2];
+};
+
+#define S6IOCTL_DP_CONFIG	_IOW(56, 9, struct s6dp_ioctl_config)
+
 #endif /* __XTENSA_S6105_IOCTL_H */
diff --git a/drivers/media/video/s6dp/s6dp.c b/drivers/media/video/s6dp/s6dp.c
index 434cec5..9f349be 100644
--- a/drivers/media/video/s6dp/s6dp.c
+++ b/drivers/media/video/s6dp/s6dp.c
@@ -31,6 +31,7 @@
 #include <linux/io.h>
 #include <variant/dmac.h>
 #include <variant/hardware.h>
+#include <platform/ioctl.h>
 #include "s6dp.h"
 
 #define DRV_NAME "s6dp"
@@ -40,6 +41,8 @@
 
 #define DP_NB_PORTS	(S6_DPDMA_NB / S6_DP_CHAN_PER_PORT)
 
+#define REPEAT_IN_STREAM_MODE	1
+
 /* device not opened */
 #define DP_STATE_UNUSED	0
 /* after open */
@@ -80,8 +83,10 @@ struct s6dp {
 	wait_queue_head_t wait;
 	u32 outstanding;
 	struct {
+		u8 modenr; /* -- FIXME */
 		u8 state;
 		u8 aligned:1;
+		u8 custom:1;
 		u8 framerepeat:1;
 		u8 progressive:1;
 
@@ -121,6 +126,7 @@ struct s6dp {
 		u8 is_10bit:1;
 		u8 micron:1;
 		u8 egress:1;
+		u8 cascade:1;
 		u8 use_1120_line_and_crc:1;
 		u8 ext_framing:1;
 		u8 vsync_pol:1;
@@ -130,6 +136,14 @@ struct s6dp {
 		u8 blank_ctrl:1;
 		u8 relaxed_framing_mode:1;
 		u32 desc_size;
+		struct anc_placement {
+			struct anc_placement_bbox {
+				s32 pix_start;
+				u32 line_start;
+				u32 line_width;
+				u32 num_lines;
+			} field[2];
+		} anc_placement;
 	} ext;
 	unsigned int num_io;
 };
@@ -303,6 +317,34 @@ static irqreturn_t s6dp_interrupt(int irq, void *dev_id)
 	return ret;
 }
 
+static inline int s6dp_is_anc_data_on(struct s6dp *pd)
+{
+	/*
+	 * if any of the fields in the bounding box are zero, ancillary data
+	 * is not turned on
+	 * the lane specifier can also affect if ancillary data is on
+	 * lane==0 is always off.
+	 * In SD modes, lane==2 or 3 also turns off ancillary data
+	 * In HD 4:2:2, lane==3 turns off ancillary data
+	 */
+	return pd->port != 0 &&
+		pd->ext.anc_placement.field[0].pix_start  != 0 &&
+		pd->ext.anc_placement.field[0].line_start != 0 &&
+		pd->ext.anc_placement.field[0].line_width != 0 &&
+		pd->ext.anc_placement.field[0].num_lines  != 0 &&
+		pd->ext.anc_placement.field[1].pix_start  != 0 &&
+		pd->ext.anc_placement.field[1].line_start != 0 &&
+		pd->ext.anc_placement.field[1].line_width != 0 &&
+		pd->ext.anc_placement.field[1].num_lines  != 0;
+}
+
+static unsigned s6dp_get_k_size(struct s6dp *pd)
+{
+	if (!s6dp_is_anc_data_on(pd))
+		return 0;
+	BUG(); /* FIXME */
+}
+
 static int s6dp_dma_init(struct video_device *dev)
 {
 	struct s6dp *pd = video_get_drvdata(dev);
@@ -315,7 +357,7 @@ static int s6dp_dma_init(struct video_device *dev)
 	for (i = (1 << (burstsize - 4)) - 1; n & i; i >>= 1)
 		burstsize--;
 
-	n = 3;
+	n = s6dp_is_anc_data_on(pd) ? 4 : 3;
 	i = 0;
 	do {
 		int ret;
@@ -341,8 +383,13 @@ static int s6dp_dma_init(struct video_device *dev)
 		}
 	} while (++i < n);
 
-	pd->cur.framerepeat = 1;
-	s6dmac_dp_setup_group(pd->dmac, pd->port, n, 1);
+	pd->cur.framerepeat = 0;
+	if (pd->cur.modenr <= MODE_LAST_VIDEO || REPEAT_IN_STREAM_MODE) {
+		pd->cur.framerepeat = 1;
+		if (pd->cur.modenr > MODE_LAST_VIDEO)
+			n = 1;
+		s6dmac_dp_setup_group(pd->dmac, pd->port, n, 1);
+	}
 
 	DP_REG_W(pd, S6_DP_VIDEO_DMA_CFG, (DP_REG_R(pd, S6_DP_VIDEO_DMA_CFG)
 		& ~(7 << S6_DP_VIDEO_DMA_CFG_BURST_BITS(pd->port)))
@@ -366,7 +413,7 @@ static void s6dp_dma_free(struct video_device *dev)
 	if (pd->cur.state < DP_STATE_ACTIVE)
 		return;
 
-	n = 3;
+	n = s6dp_is_anc_data_on(pd) ? 4 : 3;
 	i = 0;
 	do {
 		s6dmac_release_chan(pd->dmac,
@@ -377,16 +424,46 @@ static void s6dp_dma_free(struct video_device *dev)
 static int s6dp_setup_stream(struct video_device *dev)
 {
 	struct s6dp *pd = video_get_drvdata(dev);
-	unsigned i, n, y;
+	unsigned i, m, k_div;
 	unsigned long flags;
 
-	i = pd->cur.portsperstream;
+	i = 0;
+	m = pd->cur.modenr;
+	if (m < NUM_MODES) {
+		if (m <= MODE_LAST_VIDEO)
+			i = pd->cur.portsperstream;
+		else if (m == STREAM8)
+			i = 1;
+		else if (m == STREAM16)
+			i = 2;
+		else if (m == STREAM32)
+			i = 4;
+	}
 	if (i != 1) {
 		printk(DRV_ERR "multi port mode not implemented\n");
 		/* needs cross device checking for free channels */
 		return -EINVAL;
 	}
+	if ((i == 0) || (i > 3) || (pd->port % i)) {
+		printk(DRV_ERR "invalid mode (%u, port %u, ports %u)\n",
+			m, pd->port, i);
+		return -EINVAL;
+	}
+	if ((i > 2 || (i == 2 && pd->cur.greyperchroma == 1))
+	 && pd->ext.cascade) {
+		printk(DRV_ERR "cascade mode not available (ports %u)\n", i);
+		return -EINVAL;
+	}
 	pd->cur.portsperstream = i; /* FIXME -> set_current */
+	if ((pd->ext.anc_placement.field[0].pix_start &&
+			(pd->ext.anc_placement.field[0].pix_start !=
+			pd->ext.anc_placement.field[1].pix_start))
+		|| (pd->ext.anc_placement.field[0].line_start &&
+			(pd->ext.anc_placement.field[0].line_start !=
+			pd->ext.anc_placement.field[1].line_start))) {
+		printk(DRV_ERR "error - check bounding boxes\n");
+		return -EINVAL;
+	}
 	/* write port configuration (24 regs. minus ANC stuff, see below) */
 	DP_PREG_W(pd, S6_DP_PIXEL_TOTAL, pd->cur.pixel_total);
 	DP_PREG_W(pd, S6_DP_PIXEL_ACTIVE,
@@ -409,12 +486,59 @@ static int s6dp_setup_stream(struct video_device *dev)
 	DP_PREG_W(pd, S6_DP_EVEN_HSYNC_LENGTH, pd->cur.even_hsync_len);
 	DP_PREG_W(pd, S6_DP_EVEN_HSYNC_OFFSET, pd->cur.even_hsync_offset);
 
-	DP_PREG_W(pd, S6_DP_ANC_PIXEL_ACTIVE, 0);
-	DP_PREG_W(pd, S6_DP_ANC_PIXEL_OFFSET, 0);
-	DP_PREG_W(pd, S6_DP_LINE_ODD_ANC_ACTIVE, 0);
-	DP_PREG_W(pd, S6_DP_LINE_ODD_ANC_OFFSET, 0);
-	DP_PREG_W(pd, S6_DP_LINE_EVEN_ANC_ACTIVE, 0);
-	DP_PREG_W(pd, S6_DP_LINE_EVEN_ANC_OFFSET, 0);
+	/* Program ancilliary data config, if required */
+	if (s6dp_is_anc_data_on(pd)) {
+		/*
+		 * k_div is:
+		 *	4 for SD 4:2:2,
+		 *	3 for SD 4:4:4,
+		 *	2 for HD 4:2:2,
+		 *	1 for HD 4:4:4
+		 */
+		if (m <= MODE_LAST_VIDEO) {
+			k_div = (pd->cur.portsperstream == 1) ? 4 : 2;
+			if (pd->cur.greyperchroma == 1)
+				k_div -= 1;
+		} else {
+			k_div = 1;
+		}
+		/* adjust for the fact that not all lanes are used in HD mode */
+		k_div *= pd->cur.portsperstream;
+		DP_PREG_W(pd, S6_DP_ANC_PIXEL_ACTIVE,
+			  pd->ext.anc_placement.field[0].line_width / k_div);
+		DP_PREG_W(pd, S6_DP_ANC_PIXEL_OFFSET,
+			  pd->ext.anc_placement.field[0].pix_start - 1);
+		DP_PREG_W(pd, S6_DP_LINE_ODD_ANC_ACTIVE,
+			  pd->ext.anc_placement.field[0].num_lines);
+		DP_PREG_W(pd, S6_DP_LINE_ODD_ANC_OFFSET,
+			  pd->ext.anc_placement.field[0].line_start - 1);
+		if ((m <= MODE_LAST_VIDEO) &&
+		    (pd->cur.progressive)) {
+			DP_PREG_W(pd, S6_DP_LINE_EVEN_ANC_ACTIVE, 0);
+			DP_PREG_W(pd, S6_DP_LINE_EVEN_ANC_OFFSET, 0);
+		} else {
+			/* NB:
+			 *  anc_placement.field[1].line_width ==
+			 *  anc_placement.field[0].line_width
+			 * and
+			 *  anc_placement.field[1].pix_start ==
+			 *  anc_placement.field[0].pix_start
+			 */
+			DP_PREG_W(pd, S6_DP_LINE_EVEN_ANC_ACTIVE,
+				  pd->ext.anc_placement.field[1].num_lines);
+			DP_PREG_W(pd, S6_DP_LINE_EVEN_ANC_OFFSET,
+				  pd->ext.anc_placement.field[1].line_start
+				   - 1);
+		}
+	} else {
+		k_div = 1;
+		DP_PREG_W(pd, S6_DP_ANC_PIXEL_ACTIVE, 0);
+		DP_PREG_W(pd, S6_DP_ANC_PIXEL_OFFSET, 0);
+		DP_PREG_W(pd, S6_DP_LINE_ODD_ANC_ACTIVE, 0);
+		DP_PREG_W(pd, S6_DP_LINE_ODD_ANC_OFFSET, 0);
+		DP_PREG_W(pd, S6_DP_LINE_EVEN_ANC_ACTIVE, 0);
+		DP_PREG_W(pd, S6_DP_LINE_EVEN_ANC_OFFSET, 0);
+	}
 
 	/*
 	 * Program the _dma_convert registers.  These values calculate for the
@@ -422,25 +546,80 @@ static int s6dp_setup_stream(struct video_device *dev)
 	 * In streaming mode, cbcr_dma_convert indicates the number of 16b
 	 * lines to do before issuing the last transfer.
 	 */
-	n = pd->cur.width / pd->cur.greyperchroma;
-	y = pd->cur.height;
-	i = pd->ext.is_10bit ? 12 : 16;
-	DP_PREG_W(pd, S6_DP_CBCR_DMA_CONVERT, ((n + i - 1) / i) * y);
-	i /= pd->cur.greyperchroma;
-	DP_PREG_W(pd, S6_DP_Y_DMA_CONVERT, ((n + i - 1) / i) * y);
-	DP_PREG_W(pd, S6_DP_ANC_DMA_CONVERT, 0);
+	if (m <= MODE_LAST_VIDEO) {
+		u32 n, y;
+		n = pd->cur.width / pd->cur.greyperchroma;
+		y = pd->cur.height;
+		i = pd->ext.is_10bit ? 12 : 16;
+		DP_PREG_W(pd, S6_DP_CBCR_DMA_CONVERT, ((n + i - 1) / i) * y);
+		i /= pd->cur.greyperchroma;
+		DP_PREG_W(pd, S6_DP_Y_DMA_CONVERT, ((n + i - 1) / i) * y);
+		n = s6dp_get_k_size(pd);
+		if (n) {
+			/* n /= num_anc_lines; */ /* FIXME */
+			n = (n + k_div - 1) / k_div;
+			/* n *= num_anc_lines; */ /* FIXME */
+		}
+		DP_PREG_W(pd, S6_DP_ANC_DMA_CONVERT, n);
+	} else {
+		/* Streaming modes */
+		/* TODO: Where did Kaiming come up with this stuff? */
+		if ((m == ITU_H222_TRANS) ||
+		    (m == ITU_H222_TRANS_RS_DUMMY))
+			i = 188;
+		else if (m == ITU_H222_TRANS_RS)
+			i = 204;
+		else
+			BUG();
+		DP_PREG_W(pd, S6_DP_CBCR_DMA_CONVERT, (i + 15) / 16);
+		DP_PREG_W(pd, S6_DP_ANC_DMA_CONVERT, 10); /* FIXME?!? */
+	}
 
 	/* Program dp_config. Function of mode and optional configs */
 	/* Video configuration */
-	i = (pd->cur.greyperchroma == 1 ? S6_DP_VIDEO_CFG_MODE_444_SERIAL
-					: S6_DP_VIDEO_CFG_MODE_422_SERIAL)
-						<< S6_DP_VIDEO_CFG_MODE;
-	i |= pd->ext.use_1120_line_and_crc << S6_DP_VIDEO_CFG_1120_VIDEO_MODE;
+	if (m <= MODE_LAST_VIDEO) {
+		const static u8 video_cfg_mode[2][2][2] = {
+			{ {	S6_DP_VIDEO_CFG_MODE_444_SERIAL,
+				S6_DP_VIDEO_CFG_MODE_444_SERIAL_CASCADE
+			  }, {	S6_DP_VIDEO_CFG_MODE_444_PARALLEL,
+				S6_DP_VIDEO_CFG_MODE_444_PARALLEL
+			  }
+			}, {
+			  {	S6_DP_VIDEO_CFG_MODE_422_SERIAL,
+				S6_DP_VIDEO_CFG_MODE_422_SERIAL_CASCADE
+			  }, {	S6_DP_VIDEO_CFG_MODE_422_PARALLEL,
+				S6_DP_VIDEO_CFG_MODE_422_PARALLEL_CASCADE
+			} }
+		};
+		i = video_cfg_mode[pd->cur.greyperchroma - 1]
+				[pd->cur.portsperstream > 1]
+				[pd->ext.cascade] << S6_DP_VIDEO_CFG_MODE;
+		i |= pd->ext.use_1120_line_and_crc
+				<< S6_DP_VIDEO_CFG_1120_VIDEO_MODE;
+	} else if (m >= STREAM8) {
+		const static u8 stream_cfg_mode[3][2] = {
+			{	S6_DP_VIDEO_CFG_MODE_STREAM8,
+				S6_DP_VIDEO_CFG_MODE_STREAM8_CASCADE
+			}, {	S6_DP_VIDEO_CFG_MODE_STREAM16,
+				S6_DP_VIDEO_CFG_MODE_STREAM16_CASCADE
+			}, {	S6_DP_VIDEO_CFG_MODE_STREAM32,
+				S6_DP_VIDEO_CFG_MODE_STREAM32
+			}
+		};
+		i = stream_cfg_mode[m - STREAM8]
+				[pd->ext.cascade] << S6_DP_VIDEO_CFG_MODE;
+	} else {
+		printk(DRV_ERR "unhandled mode: %d\n", m);
+		return -EINVAL;
+	}
 	/* Progressive / interlaced */
 	/* Micron mode: Must be progressive (regardless of what mode says) */
 	i |= pd->ext.micron << S6_DP_VIDEO_CFG_MICRON_MODE;
 	i |= (pd->ext.micron | pd->cur.progressive)
 			<< S6_DP_VIDEO_CFG_INTERL_OR_PROGR;
+	/* Ancillary data enabled  FIXME ?! */
+	if (s6dp_is_anc_data_on(pd))
+		i |= (pd->port & 0x3) << S6_DP_VIDEO_CFG_ANCILLARY_DATA;
 	/* External framing */
 	if (pd->ext.ext_framing) {
 		i |= 1 << S6_DP_VIDEO_CFG_FRAMING;
@@ -466,8 +645,52 @@ static int s6dp_setup_stream(struct video_device *dev)
 	i = DP_REG_R(pd, S6_DP_DP_CLK_SETTING)
 		& ~(S6_DP_DP_CLK_SETTING_CLK_MUX_MASK <<
 			S6_DP_DP_CLK_SETTING_CLK_MUX(pd->port));
-	i |= (pd->ext.egress ? 0 : 1) <<
-		S6_DP_DP_CLK_SETTING_CLK_MUX(pd->port);
+	if ((m <= MODE_LAST_VIDEO && pd->cur.portsperstream == 1)
+	    || m == STREAM8) {
+		/* SD and 8 bit streaming modes */
+		i |= (pd->ext.egress ? 0 : 1) <<
+			S6_DP_DP_CLK_SETTING_CLK_MUX(pd->port);
+		if (pd->ext.cascade && !pd->ext.egress)
+			i |= 3 << S6_DP_DP_CLK_SETTING_CLK_MUX(pd->port + 2);
+	} else if ((m <= MODE_LAST_VIDEO) &&
+			(pd->cur.portsperstream == 2)) {
+		/* HD 4:2:2 modes */
+		i &= ~(S6_DP_DP_CLK_SETTING_CLK_MUX_MASK <<
+			S6_DP_DP_CLK_SETTING_CLK_MUX(pd->port + 1));
+		i |= (pd->ext.egress ? 0 : 1) <<
+			S6_DP_DP_CLK_SETTING_CLK_MUX(pd->port);
+		i |= 2 << S6_DP_DP_CLK_SETTING_CLK_MUX(pd->port + 1);
+		if (pd->ext.cascade && !pd->ext.egress) {
+			i |= 3 << S6_DP_DP_CLK_SETTING_CLK_MUX(pd->port + 2);
+			i |= 3 << S6_DP_DP_CLK_SETTING_CLK_MUX(pd->port + 3);
+		}
+	} else if ((m <= MODE_LAST_VIDEO) &&
+			(pd->cur.portsperstream == 3)) {
+		/* HD 4:4:4 modes.  lane should be 0 */
+		i &= ~(S6_DP_DP_CLK_SETTING_CLK_MUX_MASK <<
+			S6_DP_DP_CLK_SETTING_CLK_MUX(pd->port + 1));
+		i &= ~(S6_DP_DP_CLK_SETTING_CLK_MUX_MASK <<
+			S6_DP_DP_CLK_SETTING_CLK_MUX(pd->port + 2));
+		i &= ~(S6_DP_DP_CLK_SETTING_CLK_MUX_MASK <<
+			S6_DP_DP_CLK_SETTING_CLK_MUX(pd->port + 3));
+		i |= (pd->ext.egress ? 0 : 1) <<
+			S6_DP_DP_CLK_SETTING_CLK_MUX(pd->port);
+		i |= 2 << S6_DP_DP_CLK_SETTING_CLK_MUX(pd->port + 1);
+		i |= 2 << S6_DP_DP_CLK_SETTING_CLK_MUX(pd->port + 2);
+	} else if (m == STREAM16) {
+		i &= ~(S6_DP_DP_CLK_SETTING_CLK_MUX_MASK <<
+			S6_DP_DP_CLK_SETTING_CLK_MUX(pd->port + 1));
+		i |= (pd->ext.egress ? 0 : 1) <<
+			S6_DP_DP_CLK_SETTING_CLK_MUX(pd->port);
+		i |= (pd->ext.egress ? 0 : 2) <<
+			S6_DP_DP_CLK_SETTING_CLK_MUX(pd->port + 2);
+		if (pd->ext.cascade && !pd->ext.egress) {
+			i |= 3 << S6_DP_DP_CLK_SETTING_CLK_MUX(pd->port + 1);
+			i |= 3 << S6_DP_DP_CLK_SETTING_CLK_MUX(pd->port + 2);
+		}
+	}
+	/* double check STREAM32 */
+	/*else if (m == DP_STREAM32) */
 	DP_REG_W(pd, S6_DP_DP_CLK_SETTING, i);
 
 	/* Initialize DP DMA registers for this stream */
@@ -491,7 +714,10 @@ static void _s6dp_reset_port(struct s6dp *pd)
 		  | (1 << S6_DP_INT_WRONGLINES(pd->port))));
 
 	/* Clear the enable bit for the entire DMA group */
-	s6dmac_dp_switch_group(pd->dmac, pd->port, 0);
+	if (pd->cur.modenr <= MODE_LAST_VIDEO || REPEAT_IN_STREAM_MODE)
+		s6dmac_dp_switch_group(pd->dmac, pd->port, 0);
+	else /* one channel streaming */
+		s6dmac_disable_chan(pd->dmac, pd->port * S6_DP_CHAN_PER_PORT);
 	pd->outstanding = 0;
 	spin_unlock_irqrestore(&pd->lock, flags);
 	/* wait for first channel's DMA to become disabled */
@@ -648,6 +874,7 @@ static int s6dp_video_close(struct file *file)
 	/* free buffer(s) */
 	s6dp_relbufs(dev);
 	pd->cur.state = DP_STATE_UNUSED;
+	pd->cur.custom = 0;
 	return 0;
 }
 
@@ -733,7 +960,71 @@ static long s6dp_video_ioctl(struct file *file, unsigned int cmd,
 {
 	struct video_device *dev = file->private_data;
 	struct s6dp *pd = video_get_drvdata(dev);
-	if (cmd == VIDIOC_ENUMSTD) {
+	struct s6dp_ioctl_config cfg;
+	if (cmd == S6IOCTL_DP_CONFIG) {
+		copy_from_user(&cfg, (void *)arg, sizeof(cfg));
+		pd->cur.modenr = cfg.mode;
+		pd->port = cfg.lane;
+		pd->ext.is_10bit = !!cfg.is_10bit;
+		if ((cfg.micron_mode != (unsigned char)-1)
+		 && (pd->ext.micron != cfg.micron_mode))
+			return -EFAULT;
+		pd->ext.use_1120_line_and_crc = !!cfg.use_1120_line_and_crc;
+		pd->ext.ext_framing = !!cfg.ext_framing;
+		pd->ext.vsync_pol = !!cfg.vsync_pol;
+		pd->ext.hsync_pol = !!cfg.hsync_pol;
+		pd->ext.blank_pol = !!cfg.blank_pol;
+		pd->ext.field_ctrl = !!cfg.field_ctrl;
+		pd->ext.blank_ctrl = !!cfg.blank_ctrl;
+		pd->ext.relaxed_framing_mode = !!cfg.relaxed_framing_mode;
+		pd->ext.desc_size = cfg.desc_size;
+		pd->ext.anc_placement.field[0].pix_start =
+					cfg.anc_placement[0].pix_start;
+		pd->ext.anc_placement.field[0].line_start =
+					cfg.anc_placement[0].line_start;
+		pd->ext.anc_placement.field[0].line_width =
+					cfg.anc_placement[0].line_width;
+		pd->ext.anc_placement.field[0].num_lines =
+					cfg.anc_placement[0].num_lines;
+		pd->ext.anc_placement.field[1].pix_start =
+					cfg.anc_placement[1].pix_start;
+		pd->ext.anc_placement.field[1].line_start =
+					cfg.anc_placement[1].line_start;
+		pd->ext.anc_placement.field[1].line_width =
+					cfg.anc_placement[1].line_width;
+		pd->ext.anc_placement.field[1].num_lines =
+					cfg.anc_placement[1].num_lines;
+		if (cfg.mode == MODE_CUSTOM_VIDEO) {
+			pd->cur.width = cfg.custom.width;
+			pd->cur.height = cfg.custom.height;
+			pd->cur.portsperstream = cfg.custom.portsperstream;
+			pd->cur.greyperchroma = cfg.custom.greyperchroma;
+			pd->cur.progressive = !!cfg.custom.progressive;
+			pd->cur.pixel_total = cfg.custom.reg.pixel_total;
+			pd->cur.pixel_offset = cfg.custom.reg.pixel_offset;
+			pd->cur.pixel_padding = cfg.custom.reg.pixel_padding;
+			pd->cur.line_total = cfg.custom.reg.line_total;
+			pd->cur.line_odd_total = cfg.custom.reg.line_odd_total;
+			pd->cur.line_odd_offset =
+				cfg.custom.reg.line_odd_offset;
+			pd->cur.line_even_offset =
+				cfg.custom.reg.line_even_offset;
+			pd->cur.odd_vsync_len = cfg.custom.reg.odd_vsync_len;
+			pd->cur.odd_vsync_offset =
+				cfg.custom.reg.odd_vsync_offset;
+			pd->cur.even_vsync_len = cfg.custom.reg.even_vsync_len;
+			pd->cur.even_vsync_offset =
+				cfg.custom.reg.even_vsync_offset;
+			pd->cur.odd_hsync_len = cfg.custom.reg.odd_hsync_len;
+			pd->cur.odd_hsync_offset =
+				cfg.custom.reg.odd_hsync_offset;
+			pd->cur.even_hsync_len = cfg.custom.reg.even_hsync_len;
+			pd->cur.even_hsync_offset =
+				cfg.custom.reg.even_hsync_offset;
+			pd->cur.custom = 1;
+		}
+		return 0;
+	} else if (cmd == VIDIOC_ENUMSTD) {
 		struct v4l2_standard std;
 		int ret;
 		if (copy_from_user(&std, (void __user *)arg, sizeof(std)))
@@ -777,23 +1068,34 @@ static inline unsigned s6dp_set_hw2buf(struct s6dp *pd, int chan,
 	return 1 << chan;
 }
 
-static int s6dp_set_current(struct video_device *dev, u32 fourcc, int aligned)
+static int s6dp_set_current(struct video_device *dev, u32 fourcc, u32 modenr,
+			int aligned)
 {
 	struct s6dp *pd = video_get_drvdata(dev);
 	u32 uyl, ayl, uyf, ayf, ucl, acl, acf;
 	pd->cur.fourcc = fourcc;
+	pd->cur.modenr = modenr;
 	pd->cur.aligned = aligned;
-	pd->cur.chansiz[DP_K_OFFSET] = 0;
-	uyl = s6dp_byteperline(pd, 0);
-	ayl = s6dp_bytealigned(uyl);
-	ucl = s6dp_byteperline(pd, 1);
-	acl = s6dp_bytealigned(ucl);
-	uyf = s6dp_byteperframe(pd, 0, uyl);
-	ayf = s6dp_byteperframe(pd, 0, ayl);
-	if (!aligned && ayl != pd->cur.greyperchroma * acl)
-		return -EINVAL;
-	acf = s6dp_byteperframe(pd, 0, acl);
-	switch (fourcc) {
+	if (pd->cur.modenr > MODE_LAST_VIDEO) {
+		u32 s = pd->ext.desc_size;
+		pd->cur.chansiz[DP_Y_OFFSET] = 0;
+		pd->cur.chanoff[DP_CB_OFFSET] = 0;
+		pd->cur.chansiz[DP_CB_OFFSET] = s;
+		pd->cur.chansiz[DP_CR_OFFSET] = 0;
+		pd->cur.chansiz[DP_K_OFFSET] = 0;
+		pd->cur.bufsize = s;
+	} else {
+		pd->cur.chansiz[DP_K_OFFSET] = 0;
+		uyl = s6dp_byteperline(pd, 0);
+		ayl = s6dp_bytealigned(uyl);
+		ucl = s6dp_byteperline(pd, 1);
+		acl = s6dp_bytealigned(ucl);
+		uyf = s6dp_byteperframe(pd, 0, uyl);
+		ayf = s6dp_byteperframe(pd, 0, ayl);
+		if (!aligned && ayl != pd->cur.greyperchroma * acl)
+			return -EINVAL;
+		acf = s6dp_byteperframe(pd, 0, acl);
+		switch (fourcc) {
 	case V4L2_PIX_FMT_YUV444P:
 		if (aligned || uyl == ayl) {
 			s6dp_set_hw2buf(pd, DP_Y_OFFSET, 0, ayf);
@@ -812,6 +1114,7 @@ static int s6dp_set_current(struct video_device *dev, u32 fourcc, int aligned)
 		break;
 	default:
 		BUG();
+		}
 	}
 	BUG_ON(pd->cur.bufsize >= (1 << 24));
 	return 0;
@@ -824,6 +1127,8 @@ static int s6v4l_update(struct s6dp *pd, int r)
 
 	if (r < 0)
 		return r;
+	if (pd->cur.custom)
+		return 0;
 	if (!pd->link || !pd->link->g_mode)
 		return -EINVAL; /* no driver, no V4L */
 	pd->link->g_mode(pd->link->context, &mode);
@@ -872,6 +1177,7 @@ static int s6v4l_update(struct s6dp *pd, int r)
 	pd->cur.odd_hsync_offset = mode.hsync_offset / divi;
 	pd->cur.even_hsync_len = mode.hsync_len / divi;
 	pd->cur.even_hsync_offset = mode.hsync_offset / divi;
+	pd->cur.modenr = MODE_LAST_VIDEO;
 	pd->ext.ext_framing = !mode.embedded_sync;
 	pd->ext.micron = mode.micron_mode;
 	pd->ext.vsync_pol = mode.vsync_pol;
@@ -1085,7 +1391,8 @@ static int s6v4l_streamon(struct file *file, void *priv,
 	pd->cur.state = DP_STATE_ACTIVE;
 
 	/* Set the enable bit for the entire DMA group */
-	s6dmac_dp_switch_group(pd->dmac, pd->port, 1);
+	if (pd->cur.modenr <= MODE_LAST_VIDEO || REPEAT_IN_STREAM_MODE)
+		s6dmac_dp_switch_group(pd->dmac, pd->port, 1);
 
 	m = (1 << S6_DP_INT_DMAERR)
 		| (1 << S6_DP_INT_UNDEROVERRUN(pd->port))
@@ -1292,14 +1599,16 @@ static int s6v4l_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 		pfmt = f->fmt.pix;
 		r = pd->link->s_fmt(pd->link->context, 0, &pfmt, 0);
 	}
-	r = s6v4l_update(pd, r);
+	if (!pd->cur.custom)
+		r = s6v4l_update(pd, r);
 	if (r < 0)
 		return r;
 
 	align = f->fmt.pix.priv & 1;
 	pd->cur.vfield = f->fmt.pix.field;
 	pd->cur.colorspace = f->fmt.pix.colorspace;
-	r = s6dp_set_current(dev, f->fmt.pix.pixelformat, align);
+	r = s6dp_set_current(dev, f->fmt.pix.pixelformat, pd->cur.modenr,
+			     align);
 	return r;
 }
 
-- 
1.6.2.107.ge47ee

