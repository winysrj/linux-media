Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.emlix.com ([193.175.82.87]:49741 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757392AbZCZOgJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Mar 2009 10:36:09 -0400
From: =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Chris Zankel <chris@zankel.net>, linux-media@vger.kernel.org,
	Oskar Schirmer <os@emlix.com>, Fabian Godehardt <fg@emlix.com>,
	Johannes Weiner <jw@emlix.com>,
	=?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
Subject: [patch 1/5] s6000 data port driver
Date: Thu, 26 Mar 2009 15:36:55 +0100
Message-Id: <1238078219-25904-1-git-send-email-dg@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Oskar Schirmer <os@emlix.com>

Support for the s6000 on-chip video input/output engine.
Depending on external wiring it supports up to four video devices.

Signed-off-by: Fabian Godehardt <fg@emlix.com>
Signed-off-by: Oskar Schirmer <os@emlix.com>
Signed-off-by: Johannes Weiner <jw@emlix.com>
Signed-off-by: Daniel Glöckner <dg@emlix.com>
---
 drivers/media/video/Kconfig       |    2 +
 drivers/media/video/Makefile      |    2 +
 drivers/media/video/s6dp/Kconfig  |    6 +
 drivers/media/video/s6dp/Makefile |    1 +
 drivers/media/video/s6dp/s6dp.c   | 1664 +++++++++++++++++++++++++++++++++++++
 drivers/media/video/s6dp/s6dp.h   |  121 +++
 include/media/s6dp-link.h         |   63 ++
 7 files changed, 1859 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/s6dp/Kconfig
 create mode 100644 drivers/media/video/s6dp/Makefile
 create mode 100644 drivers/media/video/s6dp/s6dp.c
 create mode 100644 drivers/media/video/s6dp/s6dp.h
 create mode 100644 include/media/s6dp-link.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 19cf3b8..a94c20f 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -683,6 +683,8 @@ source "drivers/media/video/ivtv/Kconfig"
 
 source "drivers/media/video/cx18/Kconfig"
 
+source "drivers/media/video/s6dp/Kconfig"
+
 config VIDEO_M32R_AR
 	tristate "AR devices"
 	depends on M32R && VIDEO_V4L1
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 72f6d03..7109cfe 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -134,6 +134,8 @@ obj-$(CONFIG_VIDEO_CX18) += cx18/
 obj-$(CONFIG_VIDEO_VIVI) += vivi.o
 obj-$(CONFIG_VIDEO_CX23885) += cx23885/
 
+obj-$(CONFIG_VIDEO_S6000) += s6dp/
+
 obj-$(CONFIG_VIDEO_PXA27x)	+= pxa_camera.o
 obj-$(CONFIG_VIDEO_SH_MOBILE_CEU)	+= sh_mobile_ceu_camera.o
 obj-$(CONFIG_VIDEO_OMAP2)		+= omap2cam.o
diff --git a/drivers/media/video/s6dp/Kconfig b/drivers/media/video/s6dp/Kconfig
new file mode 100644
index 0000000..11cc91d
--- /dev/null
+++ b/drivers/media/video/s6dp/Kconfig
@@ -0,0 +1,6 @@
+config VIDEO_S6000
+	tristate "S6000 video"
+	depends on VIDEO_V4L2
+	default n
+	help
+	  Enables the s6000 video driver.
diff --git a/drivers/media/video/s6dp/Makefile b/drivers/media/video/s6dp/Makefile
new file mode 100644
index 0000000..c503d5b
--- /dev/null
+++ b/drivers/media/video/s6dp/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_VIDEO_S6000) += s6dp.o
diff --git a/drivers/media/video/s6dp/s6dp.c b/drivers/media/video/s6dp/s6dp.c
new file mode 100644
index 0000000..434cec5
--- /dev/null
+++ b/drivers/media/video/s6dp/s6dp.c
@@ -0,0 +1,1664 @@
+/*
+ * Video driver for S6105 on chip data port device
+ * (c)2007 Stretch, Inc.
+ * (c)2009 emlix GmbH
+ * Authors:	Fabian Godehardt <fg@emlix.com>
+ *		Oskar Schirmer <os@emlix.com>
+ *		Johannes Weiner <jw@emlix.com>
+ *		Daniel Gloeckner <dg@emlix.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/version.h>
+#include <linux/videodev2.h>
+#include <linux/time.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/list.h>
+#include <linux/delay.h>
+#include <linux/platform_device.h>
+#include <linux/spinlock.h>
+#include <linux/wait.h>
+#include <linux/dma-mapping.h>
+#include <media/v4l2-dev.h>
+#include <media/v4l2-ioctl.h>
+#include <media/s6dp-link.h>
+#include <linux/io.h>
+#include <variant/dmac.h>
+#include <variant/hardware.h>
+#include "s6dp.h"
+
+#define DRV_NAME "s6dp"
+#define DRIVER_VERSION_NUM KERNEL_VERSION(0, 0, 1)
+#define DRV_ERR KERN_ERR DRV_NAME ": "
+#define DRV_INFO KERN_INFO DRV_NAME ": "
+
+#define DP_NB_PORTS	(S6_DPDMA_NB / S6_DP_CHAN_PER_PORT)
+
+/* device not opened */
+#define DP_STATE_UNUSED	0
+/* after open */
+#define DP_STATE_IDLE	1
+/* after reqbufs */
+#define DP_STATE_READY	2
+/* after streamon */
+#define DP_STATE_ACTIVE	3
+
+#define DP_CB_OFFSET	0
+#define DP_Y_OFFSET	1
+#define DP_CR_OFFSET	2
+#define DP_K_OFFSET	3
+
+#define CURRENT_BUF_TYPE(pd) ((pd)->ext.egress ? V4L2_BUF_TYPE_VIDEO_OUTPUT \
+					       : V4L2_BUF_TYPE_VIDEO_CAPTURE)
+
+struct s6dp_frame {
+	void *data;
+	dma_addr_t dma_handle;
+	struct timeval timestamp;
+	struct list_head list;
+	u32 sequence;
+	u32 flags;
+};
+
+struct s6dp {
+	u8 port;
+	u16 irq;
+	void __iomem *dp;
+	u32 dataram;
+	u32 dmac;
+	struct s6dp_link *link;
+	struct list_head idleq;
+	struct list_head busyq;
+	struct list_head fullq;
+	spinlock_t lock;
+	wait_queue_head_t wait;
+	u32 outstanding;
+	struct {
+		u8 state;
+		u8 aligned:1;
+		u8 framerepeat:1;
+		u8 progressive:1;
+
+		u16 width;
+		u16 height;
+		u8 portsperstream;
+		u8 greyperchroma;
+		u16 pixel_total;
+		u8 pixel_offset;
+		u8 pixel_padding;
+		u16 line_total;
+		u16 line_odd_total;
+		u16 line_odd_offset;
+		u16 line_even_offset;
+		u16 odd_vsync_len;
+		u16 odd_vsync_offset;
+		u16 even_vsync_len;
+		u16 even_vsync_offset;
+		u8 odd_hsync_len;
+		u8 odd_hsync_offset;
+		u8 even_hsync_len;
+		u8 even_hsync_offset;
+
+		u32 fourcc;
+		u32 bufsize;
+		u32 chanoff[S6_DP_CHAN_PER_PORT];
+		u32 chansiz[S6_DP_CHAN_PER_PORT];
+		u32 sequence;
+		enum v4l2_field vfield;
+		enum v4l2_colorspace colorspace;
+		v4l2_std_id std_id;
+	} cur;
+	struct s6dp_frame *frames;
+	unsigned nrframes;
+	unsigned nrmapped;
+	struct {
+		u8 is_10bit:1;
+		u8 micron:1;
+		u8 egress:1;
+		u8 use_1120_line_and_crc:1;
+		u8 ext_framing:1;
+		u8 vsync_pol:1;
+		u8 hsync_pol:1;
+		u8 blank_pol:1;
+		u8 field_ctrl:1;
+		u8 blank_ctrl:1;
+		u8 relaxed_framing_mode:1;
+		u32 desc_size;
+	} ext;
+	unsigned int num_io;
+};
+
+static int s6v4l_enumstd(struct s6dp *, struct v4l2_standard *);
+static int s6v4l_s_output(struct file *, void *,  unsigned int);
+static int s6v4l_s_input(struct file *, void *,  unsigned int);
+static int s6v4l_streamoff(struct file *, void *, enum v4l2_buf_type);
+
+#define DP_REG_R(pd, n) readl((pd)->dp + (n))
+#define DP_REG_W(pd, n, v) writel((v), (pd)->dp + (n))
+#define DP_PREG_R(pd, n) readl((pd)->dp + S6_DP_CFG_BASE((pd)->port) + (n))
+#define DP_PREG_W(pd, n, v) writel((v), \
+				   (pd)->dp + S6_DP_CFG_BASE((pd)->port) + (n))
+
+static void s6dp_try_fill_dma(struct s6dp *pd)
+{
+	struct list_head *inq;
+	if (pd->cur.state != DP_STATE_ACTIVE)
+		return;
+	inq = &pd->idleq;
+	while (!list_empty(inq)) {
+		unsigned chan = pd->port * S6_DP_CHAN_PER_PORT;
+		int i;
+		struct s6dp_frame *f;
+		for (i = 0; i < S6_DP_CHAN_PER_PORT; i++)
+			if (pd->cur.chansiz[i]
+			     && s6dmac_fifo_full(pd->dmac, chan + i))
+				return;
+		f = list_first_entry(inq, struct s6dp_frame, list);
+		list_del(&f->list);
+		list_add_tail(&f->list, &pd->busyq);
+		do if (pd->cur.chansiz[--i]) {
+			u32 h, b, s, d;
+				b = (u32)f->dma_handle;
+			b += pd->cur.chanoff[i];
+			h = pd->dataram + S6_DP_CHAN_OFFSET(i);
+			if (pd->ext.egress) {
+				s = b;
+				d = h;
+			} else {
+				s = h;
+				d = b;
+			}
+			s6dmac_put_fifo(pd->dmac, chan + i, s, d,
+				pd->cur.chansiz[i]);
+		} while (i > 0); /* chan #0 must be last to push */
+		pd->outstanding++;
+	}
+}
+
+static void s6dp_err_interrupt(struct s6dp *pd)
+{
+	u32 m, r = DP_REG_R(pd, S6_DP_INT_UNMAP_RAW1);
+	m = 1 << S6_DP_INT_UNDEROVERRUN(pd->port);
+	if (r & m) {
+		printk(DRV_ERR "got overrun/underrun on lane %d\n", pd->port);
+		/* mask this interrupt source */
+		DP_REG_W(pd, S6_DP_INT_ENABLE, DP_REG_R(pd, S6_DP_INT_ENABLE)
+					       & ~m);
+	}
+	m = 1;
+	switch (pd->port) {
+	case 0:
+		m <<= S6_DP_INT_UNMAP_RAW1_DP0_BT1120ERR
+			- S6_DP_INT_UNMAP_RAW1_DP2_BT1120ERR;
+	case 2:
+		m <<= S6_DP_INT_UNMAP_RAW1_DP2_BT1120ERR;
+		if (r & m)
+			printk(DRV_ERR "BT-1120 error bad CRC or line number"
+				" on lane %d\n", pd->port);
+	}
+	m = 1 << S6_DP_INT_WRONGPIXEL(pd->port);
+	if (r & m) {
+		printk(DRV_ERR "bad pixels in lines\n");
+		DP_REG_W(pd, S6_DP_INT_CLEAR, m);
+	}
+	m = 1 << S6_DP_INT_WRONGLINES(pd->port);
+	if (r & m) {
+		printk(DRV_ERR "bad lines in frame\n");
+		DP_REG_W(pd, S6_DP_INT_CLEAR, m);
+	}
+	DP_REG_W(pd, S6_DP_INT_CLEAR, 1 << S6_DP_INT_ERR_INT);
+}
+
+static void s6dp_tc_interrupt(struct s6dp *pd)
+{
+	unsigned c = S6_DP_CHAN_PER_PORT * (pd->port + 1);
+	unsigned i = S6_DP_CHAN_PER_PORT;
+	u8 event[S6_DP_CHAN_PER_PORT];
+	do {
+		c -= 1;
+		s6dmac_lowwmark_irq(pd->dmac, c);
+		s6dmac_pendcnt_irq(pd->dmac, c);
+		event[--i] = s6dmac_termcnt_irq(pd->dmac, c);
+	} while (i > 0);
+	while (!pd->cur.chansiz[i]) {
+		if (++i >= S6_DP_CHAN_PER_PORT)
+			return;
+		c += 1;
+	}
+	if (event[i]) {
+		struct timeval now;
+		u32 newfc, pending, global;
+		struct list_head *outq = &pd->fullq;
+
+		do_gettimeofday(&now);
+		global = readl(S6_REG_GREG1 + S6_GREG1_GLOBAL_TIMER);
+		DP_REG_W(pd, S6_DP_INT_CLEAR, 1 << S6_DP_INT_TERMCNT(pd->port));
+		newfc = DP_PREG_R(pd, S6_DP_FRAME_COUNT);
+		pending = s6dmac_pending_count(pd->dmac, c);
+		if (unlikely(!pending) && pd->cur.framerepeat)
+			pending = 1;
+		while (pd->outstanding > pending) {
+			struct s6dp_frame *f;
+			u32 delta;
+			delta = global - s6dmac_timestamp(pd->dmac, c);
+			if (unlikely(list_empty(&pd->busyq))) {
+				/* shouldn't happen */
+				printk(DRV_ERR "no buffers in interrupt\n");
+				break;
+			}
+			f = list_first_entry(&pd->busyq, struct s6dp_frame,
+					     list);
+			f->sequence = pd->cur.sequence++;
+			f->flags &= ~V4L2_BUF_FLAG_QUEUED;
+			f->flags |= V4L2_BUF_FLAG_DONE;
+			f->timestamp = now;
+			f->timestamp.tv_usec -= delta * 10;
+			while (f->timestamp.tv_usec < 0) {
+				f->timestamp.tv_sec -= 1;
+				f->timestamp.tv_usec += 1000000;
+			}
+
+			list_del(&f->list);
+			list_add_tail(&f->list, outq);
+			pd->outstanding--;
+		}
+		pd->cur.sequence = newfc;
+		if (unlikely(list_empty(&pd->busyq)) && pending)
+			printk(DRV_ERR "no repeating frame?\n");
+		s6dp_try_fill_dma(pd);
+		if (!list_empty(&pd->fullq))
+			wake_up_interruptible(&pd->wait);
+	}
+}
+
+static irqreturn_t s6dp_interrupt(int irq, void *dev_id)
+{
+	struct video_device **devs = dev_id;
+	irqreturn_t ret = IRQ_NONE;
+	int i;
+	for (i = 0; i < DP_NB_PORTS; i++) {
+		struct video_device *dev = devs[i];
+		if (dev) {
+			struct s6dp *pd = video_get_drvdata(dev);
+			u32 s;
+			spin_lock(&pd->lock);
+			s = DP_REG_R(pd, S6_DP_INT_STATUS);
+			if (unlikely(s & (1 << S6_DP_INT_ERR_INT))) {
+				s6dp_err_interrupt(pd);
+				ret = IRQ_HANDLED;
+			}
+			if (s & (1 << S6_DP_INT_TERMCNT(pd->port))) {
+				s6dp_tc_interrupt(pd);
+				ret = IRQ_HANDLED;
+			}
+			spin_unlock(&pd->lock);
+		}
+	}
+	return ret;
+}
+
+static int s6dp_dma_init(struct video_device *dev)
+{
+	struct s6dp *pd = video_get_drvdata(dev);
+	unsigned i, n, burstsize;
+
+	n = DP_PREG_R(pd, S6_DP_CBCR_DMA_CONVERT) |
+	    DP_PREG_R(pd, S6_DP_Y_DMA_CONVERT) |
+	    DP_PREG_R(pd, S6_DP_ANC_DMA_CONVERT);
+	burstsize = 7;
+	for (i = (1 << (burstsize - 4)) - 1; n & i; i >>= 1)
+		burstsize--;
+
+	n = 3;
+	i = 0;
+	do {
+		int ret;
+		ret = s6dmac_request_chan(pd->dmac,
+			pd->port * S6_DP_CHAN_PER_PORT + i, /* channel */
+			0,				    /* prio */
+			0,				    /* pxfer */
+			pd->ext.egress,			    /* srcinc */
+			!pd->ext.egress,		    /* dstinc */
+			0,				    /* sc./ga. */
+			0,				    /* srcskip */
+			0,				    /* dstskip */
+			burstsize,			    /* burstsize */
+			-1,				    /* bwconsv */
+			pd->ext.egress ? 4 : 2,		    /* lowwmark */
+			1,				    /* timestamp */
+			0);				    /* enable */
+		if (ret < 0) {
+			printk(DRV_ERR
+				"error - can not request DMA channel %d\n",
+				pd->port * S6_DP_CHAN_PER_PORT + i);
+			goto errdma;
+		}
+	} while (++i < n);
+
+	pd->cur.framerepeat = 1;
+	s6dmac_dp_setup_group(pd->dmac, pd->port, n, 1);
+
+	DP_REG_W(pd, S6_DP_VIDEO_DMA_CFG, (DP_REG_R(pd, S6_DP_VIDEO_DMA_CFG)
+		& ~(7 << S6_DP_VIDEO_DMA_CFG_BURST_BITS(pd->port)))
+		| (burstsize << S6_DP_VIDEO_DMA_CFG_BURST_BITS(pd->port)));
+
+	return 0;
+errdma:
+	while (i > 0) {
+		i -= 1;
+		s6dmac_release_chan(pd->dmac,
+				    pd->port * S6_DP_CHAN_PER_PORT + i);
+	}
+	return -EIO;
+}
+
+static void s6dp_dma_free(struct video_device *dev)
+{
+	struct s6dp *pd = video_get_drvdata(dev);
+	unsigned i, n;
+
+	if (pd->cur.state < DP_STATE_ACTIVE)
+		return;
+
+	n = 3;
+	i = 0;
+	do {
+		s6dmac_release_chan(pd->dmac,
+				    pd->port * S6_DP_CHAN_PER_PORT + i);
+	} while (++i < n);
+}
+
+static int s6dp_setup_stream(struct video_device *dev)
+{
+	struct s6dp *pd = video_get_drvdata(dev);
+	unsigned i, n, y;
+	unsigned long flags;
+
+	i = pd->cur.portsperstream;
+	if (i != 1) {
+		printk(DRV_ERR "multi port mode not implemented\n");
+		/* needs cross device checking for free channels */
+		return -EINVAL;
+	}
+	pd->cur.portsperstream = i; /* FIXME -> set_current */
+	/* write port configuration (24 regs. minus ANC stuff, see below) */
+	DP_PREG_W(pd, S6_DP_PIXEL_TOTAL, pd->cur.pixel_total);
+	DP_PREG_W(pd, S6_DP_PIXEL_ACTIVE,
+		  pd->cur.width / pd->cur.greyperchroma);
+	DP_PREG_W(pd, S6_DP_PIXEL_OFFSET, pd->cur.pixel_offset);
+	DP_PREG_W(pd, S6_DP_PIXEL_PADDING, pd->cur.pixel_padding);
+	DP_PREG_W(pd, S6_DP_LINE_TOTAL, pd->cur.line_total);
+	DP_PREG_W(pd, S6_DP_LINE_ODD_TOTAL, pd->cur.line_odd_total);
+	i = pd->cur.progressive ? 0 : pd->cur.height/2;
+	DP_PREG_W(pd, S6_DP_LINE_ODD_ACTIVE, pd->cur.height - i);
+	DP_PREG_W(pd, S6_DP_LINE_ODD_OFFSET, pd->cur.line_odd_offset);
+	DP_PREG_W(pd, S6_DP_LINE_EVEN_ACTIVE, i);
+	DP_PREG_W(pd, S6_DP_LINE_EVEN_OFFSET, pd->cur.line_even_offset);
+	DP_PREG_W(pd, S6_DP_ODD_VSYNC_LENGTH, pd->cur.odd_vsync_len);
+	DP_PREG_W(pd, S6_DP_ODD_VSYNC_OFFSET, pd->cur.odd_vsync_offset);
+	DP_PREG_W(pd, S6_DP_EVEN_VSYNC_LENGTH, pd->cur.even_vsync_len);
+	DP_PREG_W(pd, S6_DP_EVEN_VSYNC_OFFSET, pd->cur.even_vsync_offset);
+	DP_PREG_W(pd, S6_DP_ODD_HSYNC_LENGTH, pd->cur.odd_hsync_len);
+	DP_PREG_W(pd, S6_DP_ODD_HSYNC_OFFSET, pd->cur.odd_hsync_offset);
+	DP_PREG_W(pd, S6_DP_EVEN_HSYNC_LENGTH, pd->cur.even_hsync_len);
+	DP_PREG_W(pd, S6_DP_EVEN_HSYNC_OFFSET, pd->cur.even_hsync_offset);
+
+	DP_PREG_W(pd, S6_DP_ANC_PIXEL_ACTIVE, 0);
+	DP_PREG_W(pd, S6_DP_ANC_PIXEL_OFFSET, 0);
+	DP_PREG_W(pd, S6_DP_LINE_ODD_ANC_ACTIVE, 0);
+	DP_PREG_W(pd, S6_DP_LINE_ODD_ANC_OFFSET, 0);
+	DP_PREG_W(pd, S6_DP_LINE_EVEN_ANC_ACTIVE, 0);
+	DP_PREG_W(pd, S6_DP_LINE_EVEN_ANC_OFFSET, 0);
+
+	/*
+	 * Program the _dma_convert registers.  These values calculate for the
+	 * hardware the number of bursts a frame will require (in video mode).
+	 * In streaming mode, cbcr_dma_convert indicates the number of 16b
+	 * lines to do before issuing the last transfer.
+	 */
+	n = pd->cur.width / pd->cur.greyperchroma;
+	y = pd->cur.height;
+	i = pd->ext.is_10bit ? 12 : 16;
+	DP_PREG_W(pd, S6_DP_CBCR_DMA_CONVERT, ((n + i - 1) / i) * y);
+	i /= pd->cur.greyperchroma;
+	DP_PREG_W(pd, S6_DP_Y_DMA_CONVERT, ((n + i - 1) / i) * y);
+	DP_PREG_W(pd, S6_DP_ANC_DMA_CONVERT, 0);
+
+	/* Program dp_config. Function of mode and optional configs */
+	/* Video configuration */
+	i = (pd->cur.greyperchroma == 1 ? S6_DP_VIDEO_CFG_MODE_444_SERIAL
+					: S6_DP_VIDEO_CFG_MODE_422_SERIAL)
+						<< S6_DP_VIDEO_CFG_MODE;
+	i |= pd->ext.use_1120_line_and_crc << S6_DP_VIDEO_CFG_1120_VIDEO_MODE;
+	/* Progressive / interlaced */
+	/* Micron mode: Must be progressive (regardless of what mode says) */
+	i |= pd->ext.micron << S6_DP_VIDEO_CFG_MICRON_MODE;
+	i |= (pd->ext.micron | pd->cur.progressive)
+			<< S6_DP_VIDEO_CFG_INTERL_OR_PROGR;
+	/* External framing */
+	if (pd->ext.ext_framing) {
+		i |= 1 << S6_DP_VIDEO_CFG_FRAMING;
+		i |= pd->ext.vsync_pol << S6_DP_VIDEO_CFG_VSYNC_POL;
+		i |= pd->ext.hsync_pol << S6_DP_VIDEO_CFG_HSYNC_POL;
+		i |= pd->ext.blank_pol << S6_DP_VIDEO_CFG_BLANK_POL;
+		i |= pd->ext.field_ctrl << S6_DP_VIDEO_CFG_FIELD_CTRL;
+		i |= pd->ext.blank_ctrl << S6_DP_VIDEO_CFG_BLANK_CTRL;
+	} else {
+		/* Embedded framing */
+		i |= pd->ext.relaxed_framing_mode << S6_DP_VIDEO_CFG_RELAX_MODE;
+	}
+	i |= pd->ext.is_10bit << S6_DP_VIDEO_CFG_8_OR_10;
+	i |= pd->ext.egress << S6_DP_VIDEO_CFG_IN_OR_OUT;
+	DP_REG_W(pd, S6_DP_VIDEO_CFG(pd->port), i);
+
+	spin_lock_irqsave(&pd->lock, flags);
+	/*
+	 * Program the clk_mux in DP_CLK_SETTING.
+	 * NOTE: all ports share this register, so this would need to be
+	 * atomic if this function were re-entrant (which it is not).
+	 */
+	i = DP_REG_R(pd, S6_DP_DP_CLK_SETTING)
+		& ~(S6_DP_DP_CLK_SETTING_CLK_MUX_MASK <<
+			S6_DP_DP_CLK_SETTING_CLK_MUX(pd->port));
+	i |= (pd->ext.egress ? 0 : 1) <<
+		S6_DP_DP_CLK_SETTING_CLK_MUX(pd->port);
+	DP_REG_W(pd, S6_DP_DP_CLK_SETTING, i);
+
+	/* Initialize DP DMA registers for this stream */
+	i = s6dp_dma_init(dev);
+	spin_unlock_irqrestore(&pd->lock, flags);
+	return i;
+}
+
+static void _s6dp_reset_port(struct s6dp *pd)
+{
+	unsigned i, m;
+	unsigned long flags;
+	struct list_head *queue[3] = {
+		&pd->idleq, &pd->busyq, &pd->fullq
+	};
+
+	spin_lock_irqsave(&pd->lock, flags);
+	DP_REG_W(pd, S6_DP_INT_ENABLE, DP_REG_R(pd, S6_DP_INT_ENABLE)
+		& ~((1 << S6_DP_INT_UNDEROVERRUN(pd->port))
+		  | (1 << S6_DP_INT_WRONGPIXEL(pd->port))
+		  | (1 << S6_DP_INT_WRONGLINES(pd->port))));
+
+	/* Clear the enable bit for the entire DMA group */
+	s6dmac_dp_switch_group(pd->dmac, pd->port, 0);
+	pd->outstanding = 0;
+	spin_unlock_irqrestore(&pd->lock, flags);
+	/* wait for first channel's DMA to become disabled */
+	i = 0;
+	do if (pd->cur.chansiz[i]) {
+		while (s6dmac_channel_enabled(pd->dmac,
+				i + pd->port * S6_DP_CHAN_PER_PORT))
+			;
+		break;
+	} while (++i < S6_DP_CHAN_PER_PORT);
+
+	spin_lock_irqsave(&pd->lock, flags);
+	DP_REG_W(pd, S6_DP_VIDEO_ENABLE, DP_REG_R(pd, S6_DP_VIDEO_ENABLE)
+				 & ~(1 << S6_DP_VIDEO_ENABLE_ENABLE(pd->port)));
+
+	/* FIXME, sort out true channel list: */
+	s6dmac_disable_error_irqs(pd->dmac,
+		15 << (pd->port * S6_DP_CHAN_PER_PORT));
+
+	DP_REG_W(pd, S6_DP_INT_CLEAR,
+		(1 << S6_DP_INT_LOWWMARK(pd->port)) |
+		(1 << S6_DP_INT_PENDGCNT(pd->port)) |
+		(1 << S6_DP_INT_TERMCNT(pd->port)));
+	for (i = 0; i < 3; i++) {
+		struct s6dp_frame *f, *next;
+		list_for_each_entry_safe(f, next, queue[i], list) {
+			list_del_init(&f->list);
+			f->flags &= ~(V4L2_BUF_FLAG_QUEUED |
+				      V4L2_BUF_FLAG_DONE);
+		}
+	}
+	m = 1 << S6_DP_INT_DMAERR;
+	for (i = 0; i < S6_DP_CHAN_PER_PORT; i++)
+		if (pd->cur.chansiz[i])
+			m |= (1 << (i + S6_DP_CHAN_PER_PORT * pd->port));
+	DP_REG_W(pd, S6_DP_INT_ENABLE, DP_REG_R(pd, S6_DP_INT_ENABLE) & ~m);
+	spin_unlock_irqrestore(&pd->lock, flags);
+}
+
+static void s6dp_reset_port(struct video_device *dev)
+{
+	struct s6dp *pd = video_get_drvdata(dev);
+	unsigned i;
+	unsigned long flags;
+
+	_s6dp_reset_port(pd);
+	spin_lock_irqsave(&pd->lock, flags);
+	s6dp_dma_free(dev);
+	DP_REG_W(pd, S6_DP_DP_CLK_SETTING, DP_REG_R(pd, S6_DP_DP_CLK_SETTING)
+		& ~(S6_DP_DP_CLK_SETTING_CLK_MUX_MASK
+			<< S6_DP_DP_CLK_SETTING_CLK_MUX(pd->port)));
+	spin_unlock_irqrestore(&pd->lock, flags);
+	DP_REG_W(pd, S6_DP_VIDEO_CFG(pd->port), 0);
+	for (i = 0; i < 24; i++)
+		DP_PREG_W(pd, i*4, 0);
+}
+
+static int s6dp_video_open(struct file *file)
+{
+	struct video_device *dev = video_devdata(file);
+	struct s6dp *pd = video_get_drvdata(dev);
+	unsigned long flags;
+
+	file->private_data = dev;
+	spin_lock_irqsave(&pd->lock, flags);
+	if (pd->cur.state != DP_STATE_UNUSED) {
+		spin_unlock_irqrestore(&pd->lock, flags);
+		return -EBUSY; /* TODO: v4l2 allows multiple opens */
+	}
+	pd->cur.state = DP_STATE_IDLE;
+	spin_unlock_irqrestore(&pd->lock, flags);
+
+	/* deferred initialization to avoid problems with the probing order */
+	if (!pd->cur.height) {
+		struct v4l2_cropcap cap;
+		struct v4l2_format vf;
+		v4l2_std_id first = 0;
+		int i;
+
+		if (pd->ext.egress)
+			s6v4l_s_output(file, file->private_data, 0);
+		else
+			s6v4l_s_input(file, file->private_data, 0);
+
+		for (i = 0; ; i++) {
+			struct v4l2_standard std;
+			std.index = i;
+			if (s6v4l_enumstd(pd, &std) < 0)
+				break;
+			if (!first)
+				first = std.id;
+			dev->tvnorms |= std.id;
+		}
+		if (dev->ioctl_ops->vidioc_s_std)
+			if (!dev->ioctl_ops->vidioc_s_std(file,
+							  file->private_data,
+							  &first))
+				dev->current_norm = first;
+		cap.type = CURRENT_BUF_TYPE(pd);
+		if (!dev->ioctl_ops->vidioc_cropcap(file, file->private_data,
+						    &cap)) {
+			struct v4l2_crop vc;
+			vc.type = CURRENT_BUF_TYPE(pd);
+			vc.c = cap.defrect;
+			dev->ioctl_ops->vidioc_s_crop(file, file->private_data,
+						      &vc);
+		}
+		vf.fmt.pix.pixelformat = V4L2_PIX_FMT_YUV422P;
+		vf.fmt.pix.field = V4L2_FIELD_ANY;
+		vf.fmt.pix.width = 704;
+		vf.fmt.pix.height = 480;
+		vf.fmt.pix.bytesperline = 0;
+		vf.fmt.pix.priv = 0;
+		if (pd->ext.egress)
+			dev->ioctl_ops->vidioc_s_fmt_vid_out(file,
+							     file->private_data,
+							     &vf);
+		else
+			dev->ioctl_ops->vidioc_s_fmt_vid_cap(file,
+							     file->private_data,
+							     &vf);
+	}
+	return 0;
+}
+
+static void s6dp_relbufs(struct video_device *dev)
+{
+	struct s6dp *pd = video_get_drvdata(dev);
+	int i;
+	unsigned long flags;
+
+	if (!pd->nrframes)
+		return;
+	spin_lock_irqsave(&pd->lock, flags);
+	INIT_LIST_HEAD(&pd->idleq);
+	INIT_LIST_HEAD(&pd->busyq);
+	INIT_LIST_HEAD(&pd->fullq);
+	spin_unlock_irqrestore(&pd->lock, flags);
+	for (i = 0; i < pd->nrframes; i++)
+		dma_free_coherent(dev->parent, pd->cur.bufsize,
+				  pd->frames[i].data, pd->frames[i].dma_handle);
+	kfree(pd->frames);
+	pd->nrframes = 0;
+}
+
+static int s6dp_video_close(struct file *file)
+{
+	struct video_device *dev = file->private_data;
+	struct s6dp *pd = video_get_drvdata(dev);
+
+	/* reset port and free dma channels */
+	s6dp_reset_port(dev);
+
+	/* free buffer(s) */
+	s6dp_relbufs(dev);
+	pd->cur.state = DP_STATE_UNUSED;
+	return 0;
+}
+
+static void s6dp_video_vm_close(struct vm_area_struct *area)
+{
+	struct video_device *dev = area->vm_file->private_data;
+	struct s6dp *pd = video_get_drvdata(dev);
+	struct s6dp_frame *f = area->vm_private_data;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pd->lock, flags);
+	f->flags &= ~V4L2_BUF_FLAG_MAPPED;
+	pd->nrmapped--;
+	spin_unlock_irqrestore(&pd->lock, flags);
+}
+
+static struct vm_operations_struct s6dp_vm_ops = {
+	.close = s6dp_video_vm_close,
+};
+
+static int s6dp_video_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct video_device *dev = file->private_data;
+	struct s6dp *pd = video_get_drvdata(dev);
+	unsigned long flags;
+	u32 buf;
+	int index;
+
+	/* we use the vma_pgoff to distinguish between the buffers */
+#define MAX_FRAMES 256
+	index = vma->vm_pgoff & 0xFF;
+	if (pd->cur.state < DP_STATE_READY || index >= pd->nrframes)
+		return -ENOMEM;
+	buf = (u32)pd->frames[index].data;
+	BUG_ON(buf & ~PAGE_MASK);
+
+	vma->vm_pgoff = buf >> PAGE_SHIFT;
+	if (remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
+			PAGE_ALIGN(pd->cur.bufsize), vma->vm_page_prot)) {
+		printk(DRV_ERR "error - mapping frame #%d\n", index);
+		return -EAGAIN;
+	}
+	vma->vm_flags &= ~VM_IO;	/* not I/O memory */
+	vma->vm_flags |= VM_MAYSHARE | VM_RESERVED;	/* avoid to swap out */
+	vma->vm_ops = &s6dp_vm_ops;
+	vma->vm_private_data = pd->frames + index;
+
+	spin_lock_irqsave(&pd->lock, flags);
+	pd->nrmapped++;
+	pd->frames[index].flags |= V4L2_BUF_FLAG_MAPPED;
+	spin_unlock_irqrestore(&pd->lock, flags);
+	return 0;
+}
+
+static unsigned long s6dp_video_get_unmapped_area(struct file *file,
+				unsigned long addr, unsigned long len,
+				unsigned long pgoff, unsigned long flags)
+{
+	struct video_device *dev = file->private_data;
+	struct s6dp *pd = video_get_drvdata(dev);
+	int index;
+
+	index = pgoff & 0xFF;
+	if (pd->cur.state < DP_STATE_READY || index >= pd->nrframes)
+		return -ENOMEM;
+	return (unsigned long)pd->frames[index].data;
+}
+
+static unsigned int s6dp_video_poll(struct file *file, poll_table *wait)
+{
+	struct video_device *dev = file->private_data;
+	struct s6dp *pd = video_get_drvdata(dev);
+	poll_wait(file, &pd->wait, wait);
+	if (pd->cur.state < DP_STATE_ACTIVE)
+		return POLLERR;
+	if (list_empty(&pd->fullq))
+		return 0;
+	return pd->ext.egress ? (POLLOUT | POLLWRNORM) : (POLLIN | POLLRDNORM);
+}
+
+static long s6dp_video_ioctl(struct file *file, unsigned int cmd,
+			    unsigned long arg)
+{
+	struct video_device *dev = file->private_data;
+	struct s6dp *pd = video_get_drvdata(dev);
+	if (cmd == VIDIOC_ENUMSTD) {
+		struct v4l2_standard std;
+		int ret;
+		if (copy_from_user(&std, (void __user *)arg, sizeof(std)))
+			return -EFAULT;
+		ret = s6v4l_enumstd(pd, &std);
+		if (copy_to_user((void __user *)arg, &std, sizeof(std)))
+			return -EFAULT;
+		return ret;
+	}
+	return video_ioctl2(file, cmd, arg);
+}
+
+static inline u32 s6dp_byteperline(struct s6dp *pd, int divide)
+{
+	u32 n = pd->cur.width;
+	if (divide)
+		n /= pd->cur.greyperchroma;
+	if (pd->ext.is_10bit) /* pack 3 samples into 4 bytes: */
+		n = ((n * 4) + 2) / 3;
+	return n;
+}
+
+static inline u32 s6dp_bytealigned(u32 unaligned)
+{
+	return (unaligned + 15) & ~15;
+}
+
+static inline u32 s6dp_byteperframe(struct s6dp *pd, int divide, u32 perline)
+{
+	u32 n = pd->cur.height;
+	if (divide)
+		n /= 2;
+	return n * perline;
+}
+
+static inline unsigned s6dp_set_hw2buf(struct s6dp *pd, int chan,
+			unsigned offset, unsigned asize)
+{
+	pd->cur.chanoff[chan] = offset;
+	pd->cur.chansiz[chan] = asize;
+	return 1 << chan;
+}
+
+static int s6dp_set_current(struct video_device *dev, u32 fourcc, int aligned)
+{
+	struct s6dp *pd = video_get_drvdata(dev);
+	u32 uyl, ayl, uyf, ayf, ucl, acl, acf;
+	pd->cur.fourcc = fourcc;
+	pd->cur.aligned = aligned;
+	pd->cur.chansiz[DP_K_OFFSET] = 0;
+	uyl = s6dp_byteperline(pd, 0);
+	ayl = s6dp_bytealigned(uyl);
+	ucl = s6dp_byteperline(pd, 1);
+	acl = s6dp_bytealigned(ucl);
+	uyf = s6dp_byteperframe(pd, 0, uyl);
+	ayf = s6dp_byteperframe(pd, 0, ayl);
+	if (!aligned && ayl != pd->cur.greyperchroma * acl)
+		return -EINVAL;
+	acf = s6dp_byteperframe(pd, 0, acl);
+	switch (fourcc) {
+	case V4L2_PIX_FMT_YUV444P:
+		if (aligned || uyl == ayl) {
+			s6dp_set_hw2buf(pd, DP_Y_OFFSET, 0, ayf);
+			s6dp_set_hw2buf(pd, DP_CB_OFFSET, ayf, acf);
+			s6dp_set_hw2buf(pd, DP_CR_OFFSET, ayf + acf, acf);
+			pd->cur.bufsize = ayf + 2 * acf;
+		}
+		break;
+	case V4L2_PIX_FMT_YUV422P:
+		if (aligned || ucl == acl) {
+			s6dp_set_hw2buf(pd, DP_Y_OFFSET, 0, ayf);
+			s6dp_set_hw2buf(pd, DP_CB_OFFSET, ayf, acf);
+			s6dp_set_hw2buf(pd, DP_CR_OFFSET, ayf + acf, acf);
+			pd->cur.bufsize = ayf + 2 * acf;
+		}
+		break;
+	default:
+		BUG();
+	}
+	BUG_ON(pd->cur.bufsize >= (1 << 24));
+	return 0;
+}
+
+static int s6v4l_update(struct s6dp *pd, int r)
+{
+	struct s6dp_mode mode;
+	int divi, sub;
+
+	if (r < 0)
+		return r;
+	if (!pd->link || !pd->link->g_mode)
+		return -EINVAL; /* no driver, no V4L */
+	pd->link->g_mode(pd->link->context, &mode);
+
+	pd->cur.width = mode.pixel_active;
+	pd->cur.height = mode.odd_active + mode.even_active;
+	pd->cur.progressive = mode.progressive;
+	switch (mode.type) {
+	case S6_DP_VIDEO_CFG_MODE_422_SERIAL:
+		pd->cur.portsperstream = 1;
+		divi = 2;
+		sub = 2;
+		break;
+	case S6_DP_VIDEO_CFG_MODE_444_SERIAL:
+		pd->cur.portsperstream = 1;
+		divi = 1;
+		sub = 3;
+		break;
+	case S6_DP_VIDEO_CFG_MODE_422_PARALLEL:
+		pd->cur.portsperstream = 2;
+		divi = 2;
+		sub = 4;
+		break;
+	case S6_DP_VIDEO_CFG_MODE_444_PARALLEL:
+		pd->cur.portsperstream = 3;
+		divi = 1;
+		sub = 8;
+		break;
+	default:
+		divi = 1;
+		sub = 0;
+	}
+	pd->cur.greyperchroma = divi;
+	pd->cur.pixel_total = mode.pixel_total / divi - sub;
+	pd->cur.pixel_offset = mode.pixel_offset / divi;
+	pd->cur.pixel_padding = mode.pixel_padding / divi;
+	pd->cur.line_total = mode.framelines;
+	pd->cur.line_odd_total = mode.odd_total;
+	pd->cur.line_odd_offset = mode.odd_first;
+	pd->cur.line_even_offset = mode.even_first;
+	pd->cur.odd_vsync_len = mode.odd_vsync_len;
+	pd->cur.odd_vsync_offset = mode.odd_vsync_offset;
+	pd->cur.even_vsync_len = mode.even_vsync_len;
+	pd->cur.even_vsync_offset = mode.even_vsync_offset;
+	pd->cur.odd_hsync_len = mode.hsync_len / divi;
+	pd->cur.odd_hsync_offset = mode.hsync_offset / divi;
+	pd->cur.even_hsync_len = mode.hsync_len / divi;
+	pd->cur.even_hsync_offset = mode.hsync_offset / divi;
+	pd->ext.ext_framing = !mode.embedded_sync;
+	pd->ext.micron = mode.micron_mode;
+	pd->ext.vsync_pol = mode.vsync_pol;
+	pd->ext.hsync_pol = mode.hsync_pol;
+	pd->ext.blank_pol = mode.blank_pol;
+	pd->ext.field_ctrl = mode.field_ctrl;
+	pd->ext.blank_ctrl = mode.blank_ctrl;
+	pd->ext.relaxed_framing_mode = mode.relaxed_framing;
+	pd->ext.is_10bit = mode.ten_bit;
+	pd->ext.use_1120_line_and_crc = mode.line_and_crc;
+	return 0;
+}
+
+
+static int s6v4l_enumstd(struct s6dp *pd, struct v4l2_standard *std)
+{
+	int ret = -EINVAL;
+	if (pd->link && pd->link->e_std)
+		ret = pd->link->e_std(pd->link->context, std);
+	return ret;
+}
+
+static int s6v4l_s_std(struct file *file, void *priv, v4l2_std_id *std)
+{
+	struct video_device *dev = file->private_data;
+	struct s6dp *pd = video_get_drvdata(dev);
+	int ret = -EINVAL;
+	if (pd->link && pd->link->s_std)
+		ret = pd->link->s_std(pd->link->context, std,
+				      pd->cur.state >= DP_STATE_READY);
+	return s6v4l_update(pd, ret);
+}
+
+static int s6v4l_qbuf(struct file *file, void *priv, struct v4l2_buffer *p)
+{
+	struct video_device *dev = file->private_data;
+	struct s6dp *pd = video_get_drvdata(dev);
+	u32 i;
+	struct s6dp_frame *f;
+	unsigned long flags;
+
+	if (pd->cur.state < DP_STATE_READY)
+		return -EINVAL;
+	if (p->memory != V4L2_MEMORY_MMAP)
+		return -EINVAL;
+	if (p->type != CURRENT_BUF_TYPE(pd))
+		return -EINVAL;
+	i = p->index;
+	if (i >= pd->nrframes) {
+		printk(DRV_ERR "buffer index range error (%u/%u)\n",
+			i, pd->nrframes);
+		return -EINVAL;
+	}
+	f = &pd->frames[i];
+	if (!list_empty(&f->list)) {
+		printk(DRV_ERR "error - frame %d already queued\n", i);
+		return -EINVAL;
+	}
+	f->timestamp.tv_sec = 0;
+	f->timestamp.tv_usec = 0;
+	f->flags |= V4L2_BUF_FLAG_QUEUED;
+	p->flags = f->flags;
+	spin_lock_irqsave(&pd->lock, flags);
+	list_add_tail(&f->list, &pd->idleq);
+	s6dp_try_fill_dma(pd);
+	spin_unlock_irqrestore(&pd->lock, flags);
+	return 0;
+}
+
+static int s6v4l_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
+{
+	struct video_device *dev = file->private_data;
+	struct s6dp *pd = video_get_drvdata(dev);
+	struct s6dp_frame *f;
+	unsigned long flags;
+
+	if (pd->cur.state < DP_STATE_READY)
+		return -EINVAL;
+retry:
+	if (!(file->f_flags & O_NONBLOCK) &&
+	    wait_event_interruptible(pd->wait, !list_empty(&pd->fullq)))
+		return -ERESTARTSYS;
+	spin_lock_irqsave(&pd->lock, flags);
+	if (list_empty(&pd->fullq)) {
+		spin_unlock_irqrestore(&pd->lock, flags);
+		if (file->f_flags & O_NONBLOCK)
+			return -EAGAIN;
+		goto retry;
+	}
+	f = list_first_entry(&pd->fullq, struct s6dp_frame, list);
+	list_del_init(&f->list);
+	f->flags &= ~V4L2_BUF_FLAG_DONE;
+	spin_unlock_irqrestore(&pd->lock, flags);
+
+	p->index = f - &pd->frames[0];
+	p->timestamp = f->timestamp;
+	p->sequence = f->sequence;
+	p->memory = V4L2_MEMORY_MMAP;
+	p->flags = f->flags;
+	p->field = pd->cur.vfield;
+	p->length =  pd->cur.bufsize;
+	if (!pd->ext.egress)
+		p->bytesused = pd->cur.bufsize;
+	return 0;
+}
+
+static int s6v4l_reqbufs(struct file *file, void *priv,
+			 struct v4l2_requestbuffers *req)
+{
+	struct video_device *dev = file->private_data;
+	struct s6dp *pd = video_get_drvdata(dev);
+	int i;
+
+	if (req->memory != V4L2_MEMORY_MMAP)
+		return -EINVAL;
+	if (req->type != CURRENT_BUF_TYPE(pd))
+		return -EINVAL;
+	if (pd->nrmapped)
+		return -EBUSY;
+	if (pd->cur.state > DP_STATE_READY) {
+		if (req->count)
+			return -EBUSY;
+		i = s6v4l_streamoff(file, priv, req->type);
+		if (i < 0)
+			return i;
+	}
+	if (req->count > MAX_FRAMES)
+		req->count = MAX_FRAMES;
+
+	s6dp_relbufs(dev);
+	if (req->count == 0) {
+		pd->cur.state = DP_STATE_IDLE;
+		return 0;
+	}
+
+	pd->frames =
+		kmalloc(req->count * sizeof(struct s6dp_frame), GFP_KERNEL);
+	if (!pd->frames)
+		return -ENOMEM;
+	for (i = 0; i < req->count; i++) {
+		struct s6dp_frame *f;
+		f = &pd->frames[i];
+		f->data = dma_alloc_coherent(dev->parent, pd->cur.bufsize,
+					     &f->dma_handle, GFP_KERNEL);
+		if (!f->data) {
+			req->count = i;
+			break;
+		}
+		INIT_LIST_HEAD(&f->list);
+		f->flags = 0;
+	}
+	if (!i) {
+		kfree(pd->frames);
+		return -ENOMEM;
+	}
+	pd->nrframes = i;
+	pd->cur.state = DP_STATE_READY;
+	return 0;
+}
+
+static int s6v4l_querybuf(struct file *file, void *priv, struct v4l2_buffer *p)
+{
+	struct video_device *dev = file->private_data;
+	struct s6dp *pd = video_get_drvdata(dev);
+
+	if (p->type != CURRENT_BUF_TYPE(pd))
+		return -EINVAL;
+	if (pd->cur.state < DP_STATE_READY)
+		return -EINVAL;
+	if (p->index >= pd->nrframes)
+		return -EINVAL;
+
+	p->memory = V4L2_MEMORY_MMAP;
+	p->m.offset = p->index << PAGE_SHIFT;	/*
+						 * a "magic cookie" that the
+						 * appl. can pass to mmap to
+						 * specifiy which buffer is
+						 * being mapped
+						 */
+
+	p->length = pd->cur.bufsize;
+	p->flags = pd->frames[p->index].flags;
+	p->field = pd->cur.vfield;
+	return 0;
+}
+
+static int s6v4l_streamon(struct file *file, void *priv,
+			enum v4l2_buf_type vtype)
+{
+	struct video_device *dev = file->private_data;
+	struct s6dp *pd = video_get_drvdata(dev);
+	unsigned i, m;
+	unsigned long flags;
+
+	if (pd->cur.state != DP_STATE_READY) {
+		printk(DRV_ERR "device not ready\n");
+		return -EINVAL;
+	}
+
+	if (list_empty(&pd->idleq)) {
+		printk(DRV_ERR "no buffers queued\n");
+		return -EINVAL;
+	}
+
+	i = s6dp_setup_stream(dev);
+	if (i) {
+		printk(DRV_ERR "error - video setup failed\n");
+		return i;
+	}
+	pd->cur.sequence = 0;
+	pd->cur.state = DP_STATE_ACTIVE;
+
+	/* Set the enable bit for the entire DMA group */
+	s6dmac_dp_switch_group(pd->dmac, pd->port, 1);
+
+	m = (1 << S6_DP_INT_DMAERR)
+		| (1 << S6_DP_INT_UNDEROVERRUN(pd->port))
+		| (1 << S6_DP_INT_WRONGPIXEL(pd->port))
+		| (1 << S6_DP_INT_WRONGLINES(pd->port));
+	for (i = 0; i < S6_DP_CHAN_PER_PORT; i++)
+		if (pd->cur.chansiz[i])
+			m |= (1 << (i + S6_DP_CHAN_PER_PORT * pd->port));
+	spin_lock_irqsave(&pd->lock, flags);
+	DP_REG_W(pd, S6_DP_INT_ENABLE, DP_REG_R(pd, S6_DP_INT_ENABLE) | m);
+	DP_REG_W(pd, S6_DP_VIDEO_ENABLE, DP_REG_R(pd, S6_DP_VIDEO_ENABLE)
+		| (1 << S6_DP_VIDEO_ENABLE_ENABLE(pd->port)));
+	s6dp_try_fill_dma(pd);
+	spin_unlock_irqrestore(&pd->lock, flags);
+	return 0;
+}
+
+
+static int s6v4l_streamoff(struct file *file, void *priv,
+			enum v4l2_buf_type type)
+{
+	struct video_device *dev = file->private_data;
+	struct s6dp *pd = video_get_drvdata(dev);
+
+	if (pd->cur.state != DP_STATE_ACTIVE)
+		return -EINVAL;
+	s6dp_reset_port(dev);
+	pd->cur.state = DP_STATE_READY;
+	return 0;
+}
+
+const static struct {
+	u32 pixelformat;
+	u8 *description;
+} s6dp_enum_fmt[] = {
+	{	V4L2_PIX_FMT_YUV444P,
+		"YUV 4:4:4 planar",
+	},
+	{	V4L2_PIX_FMT_YUV422P,
+		"YUV 4:2:2 planar",
+	},
+};
+
+static int s6v4l_enum_fmt_cap(struct file *file, void *priv,
+			struct v4l2_fmtdesc *f)
+{
+	u32 i = f->index;
+	if (i >= ARRAY_SIZE(s6dp_enum_fmt))
+		return -EINVAL;
+	f->pixelformat = s6dp_enum_fmt[i].pixelformat;
+	strlcpy(f->description, s6dp_enum_fmt[i].description,
+		sizeof(f->description));
+	f->flags = 0;
+	return 0;
+}
+
+static int s6v4l_enum_fmt_out(struct file *file, void *priv,
+			struct v4l2_fmtdesc *f)
+{
+	u32 i = f->index;
+	if (i > 0)
+		return -EINVAL;
+	/* Only 422 for now */
+	f->pixelformat = s6dp_enum_fmt[1].pixelformat;
+	strlcpy(f->description, s6dp_enum_fmt[1].description,
+		sizeof(f->description));
+	f->flags = 0;
+	return 0;
+}
+
+static int s6v4l_cropcap(struct file *file, void *priv, struct v4l2_cropcap *c)
+{
+	struct video_device *dev = file->private_data;
+	struct s6dp *pd = video_get_drvdata(dev);
+
+	if (c->type != CURRENT_BUF_TYPE(pd))
+		return -EINVAL;
+
+	if (!pd->link || !pd->link->cropcap)
+		return -EINVAL;
+
+	return pd->link->cropcap(pd->link->context, c);
+}
+
+static int s6v4l_s_crop(struct file *file, void *priv, struct v4l2_crop *c)
+{
+	struct video_device *dev = file->private_data;
+	struct s6dp *pd = video_get_drvdata(dev);
+	int ret;
+
+	if (c->type != CURRENT_BUF_TYPE(pd))
+		return -EINVAL;
+
+	if (!pd->link || !pd->link->s_crop)
+		return -EINVAL;
+
+	ret = pd->link->s_crop(pd->link->context, c,
+			       pd->cur.state >= DP_STATE_READY);
+
+	return s6v4l_update(pd, ret);
+}
+
+static int s6v4l_g_crop(struct file *file, void *priv, struct v4l2_crop *c)
+{
+	struct video_device *dev = file->private_data;
+	struct s6dp *pd = video_get_drvdata(dev);
+
+	if (c->type != CURRENT_BUF_TYPE(pd))
+		return -EINVAL;
+
+	if (!pd->link || !pd->link->g_crop)
+		return -EINVAL;
+
+	return pd->link->g_crop(pd->link->context, c);
+}
+
+static int s6v4l_try_fmt(struct file *file, void *priv,
+			struct v4l2_format *f)
+{
+	struct video_device *dev = file->private_data;
+	struct s6dp *pd = video_get_drvdata(dev);
+	int cwidth, cheight, cbytesperline, aligned = 1;
+	if (!pd->link || !pd->link->s_fmt || !pd->link->g_mode)
+		return 0;
+
+	pd->link->s_fmt(pd->link->context, 1, &f->fmt.pix, 1);
+
+	switch (f->fmt.pix.pixelformat) {
+	case V4L2_PIX_FMT_UYVY:
+	case V4L2_PIX_FMT_VYUY:
+	case V4L2_PIX_FMT_NV16:
+	case V4L2_PIX_FMT_NV61:
+		f->fmt.pix.pixelformat = V4L2_PIX_FMT_YUV422P;
+		f->fmt.pix.width &= ~1;
+		break;
+	default:
+		f->fmt.pix.pixelformat = V4L2_PIX_FMT_YUV444P;
+	}
+	if (f->fmt.pix.field == V4L2_FIELD_ALTERNATE)
+		f->fmt.pix.field = V4L2_FIELD_SEQ_TB;
+	cheight = f->fmt.pix.height;
+	switch (f->fmt.pix.pixelformat) {
+	case V4L2_PIX_FMT_YUV444P:
+		cwidth = f->fmt.pix.width;
+		break;
+	case V4L2_PIX_FMT_YUV420:
+		cheight = f->fmt.pix.height / 2;
+	case V4L2_PIX_FMT_YUV422P:
+		cwidth = f->fmt.pix.width / 2;
+		break;
+	default:
+		cwidth = 0;
+	}
+	if (aligned) {
+		f->fmt.pix.bytesperline = s6dp_bytealigned(f->fmt.pix.width);
+		cbytesperline = s6dp_bytealigned(cwidth);
+	} else {
+		f->fmt.pix.bytesperline = f->fmt.pix.width;
+		cbytesperline = cwidth;
+	}
+	f->fmt.pix.sizeimage = f->fmt.pix.bytesperline * f->fmt.pix.height
+			       + cbytesperline * cheight * 2;
+	return 0;
+}
+
+static int s6v4l_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
+{
+	struct video_device *dev = file->private_data;
+	struct s6dp *pd = video_get_drvdata(dev);
+	unsigned i;
+
+	memset(&f->fmt.pix, 0, sizeof(struct v4l2_pix_format));
+	if (pd->link && pd->link->g_fmt) {
+		i = pd->link->g_fmt(pd->link->context, &f->fmt.pix);
+		if (i < 0)
+			return i;
+	} else {
+		f->fmt.pix.colorspace = V4L2_COLORSPACE_SRGB;
+	}
+	f->fmt.pix.field = pd->cur.vfield;
+	if (f->fmt.pix.field == V4L2_FIELD_ALTERNATE)
+		f->fmt.pix.field = V4L2_FIELD_SEQ_TB;
+	f->fmt.pix.width = pd->cur.width;
+	f->fmt.pix.height = pd->cur.height;
+	f->fmt.pix.pixelformat = pd->cur.fourcc;
+	f->fmt.pix.bytesperline = s6dp_bytealigned(f->fmt.pix.width);
+	f->fmt.pix.priv = pd->cur.aligned;
+	f->fmt.pix.sizeimage = pd->cur.bufsize;
+	return 0;
+}
+
+static int s6v4l_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
+{
+	struct video_device *dev = file->private_data;
+	struct s6dp *pd = video_get_drvdata(dev);
+	struct v4l2_pix_format pfmt;
+	int r, align;
+	if (pd->cur.state != DP_STATE_IDLE)
+		return -EBUSY;
+	r = s6v4l_try_fmt(file, dev, f);
+	if (r < 0)
+		return r;
+	if (pd->link && pd->link->s_fmt) {
+		pfmt = f->fmt.pix;
+		r = pd->link->s_fmt(pd->link->context, 0, &pfmt, 0);
+	}
+	r = s6v4l_update(pd, r);
+	if (r < 0)
+		return r;
+
+	align = f->fmt.pix.priv & 1;
+	pd->cur.vfield = f->fmt.pix.field;
+	pd->cur.colorspace = f->fmt.pix.colorspace;
+	r = s6dp_set_current(dev, f->fmt.pix.pixelformat, align);
+	return r;
+}
+
+static int s6v4l_enum_input(struct file *file, void *fh, struct v4l2_input *inp)
+{
+	struct video_device *dev = video_devdata(file);
+	struct s6dp *pd = video_get_drvdata(dev);
+
+	if (!pd->link || !pd->link->dir.ingress.e_inp)
+		return -EINVAL;
+
+	return pd->link->dir.ingress.e_inp(pd->link->context, inp);
+}
+
+static int s6v4l_enum_output(struct file *file, void *fh,
+			     struct v4l2_output *outp)
+{
+	struct video_device *dev = video_devdata(file);
+	struct s6dp *pd = video_get_drvdata(dev);
+
+	if (!pd->link || !pd->link->dir.egress.e_outp)
+		return -EINVAL;
+
+	return pd->link->dir.egress.e_outp(pd->link->context, outp);
+}
+
+static int s6v4l_g_input(struct file *file, void *fh,  unsigned int *i)
+{
+	struct video_device *dev = video_devdata(file);
+	struct s6dp *pd = video_get_drvdata(dev);
+
+	if (!pd->link || !pd->link->dir.ingress.s_inp)
+		return -EINVAL;
+
+	*i = pd->num_io;
+	return 0;
+}
+
+static int s6v4l_g_output(struct file *file, void *fh,  unsigned int *i)
+{
+	struct video_device *dev = video_devdata(file);
+	struct s6dp *pd = video_get_drvdata(dev);
+
+	if (!pd->link || !pd->link->dir.egress.s_outp)
+		return -EINVAL;
+
+	*i = pd->num_io;
+	return 0;
+}
+
+static int s6v4l_s_input(struct file *file, void *fh,  unsigned int i)
+{
+	struct video_device *dev = video_devdata(file);
+	struct s6dp *pd = video_get_drvdata(dev);
+	int ret = -EINVAL;
+
+	if (pd->link && pd->link->dir.ingress.s_inp) {
+		ret = pd->link->dir.ingress.s_inp(pd->link->context, i,
+						  pd->cur.state
+							>= DP_STATE_READY);
+		if (ret >= 0)
+			pd->num_io = i;
+	}
+
+	return s6v4l_update(pd, ret);
+}
+
+static int s6v4l_s_output(struct file *file, void *fh,  unsigned int i)
+{
+	struct video_device *dev = video_devdata(file);
+	struct s6dp *pd = video_get_drvdata(dev);
+	int ret = -EINVAL;
+
+	if (pd->link && pd->link->dir.egress.s_outp) {
+		ret = pd->link->dir.egress.s_outp(pd->link->context, i,
+					       pd->cur.state >= DP_STATE_READY);
+		if (ret >= 0)
+			pd->num_io = i;
+	}
+
+	return s6v4l_update(pd, ret);
+}
+
+static int s6v4l_querycap(struct file *file, void *fh,
+			  struct v4l2_capability *cap)
+{
+	struct video_device *dev = video_devdata(file);
+	struct s6dp *pd = video_get_drvdata(dev);
+
+	strcpy(cap->driver, "s6dp");
+	strcpy(cap->card, "Stretch data port");
+	sprintf(cap->bus_info, "Data port %i", pd->port);
+	cap->version = DRIVER_VERSION_NUM;
+	if (pd->ext.egress)
+		cap->capabilities = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_OUTPUT;
+	else
+		cap->capabilities = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_CAPTURE;
+	return 0;
+}
+
+static const struct v4l2_file_operations s6v4l_video_fops = {
+	.owner			= THIS_MODULE,
+	.open			= s6dp_video_open,
+	.release		= s6dp_video_close,
+	.get_unmapped_area	= s6dp_video_get_unmapped_area,
+	.mmap			= s6dp_video_mmap,
+	.poll			= s6dp_video_poll,
+	.ioctl			= s6dp_video_ioctl,
+};
+
+static const struct v4l2_ioctl_ops capture_v4l_ioctl_ops = {
+	.vidioc_querycap = s6v4l_querycap,
+	.vidioc_enum_fmt_vid_cap = s6v4l_enum_fmt_cap,
+	.vidioc_g_fmt_vid_cap = s6v4l_g_fmt,
+	.vidioc_s_fmt_vid_cap = s6v4l_s_fmt,
+	.vidioc_try_fmt_vid_cap = s6v4l_try_fmt,
+	.vidioc_reqbufs = s6v4l_reqbufs,
+	.vidioc_querybuf = s6v4l_querybuf,
+	.vidioc_qbuf = s6v4l_qbuf,
+	.vidioc_dqbuf = s6v4l_dqbuf,
+	.vidioc_streamon = s6v4l_streamon,
+	.vidioc_streamoff = s6v4l_streamoff,
+	.vidioc_s_std = s6v4l_s_std,
+	.vidioc_enum_input = s6v4l_enum_input,
+	.vidioc_g_input = s6v4l_g_input,
+	.vidioc_s_input = s6v4l_s_input,
+	.vidioc_cropcap = s6v4l_cropcap,
+	.vidioc_g_crop = s6v4l_g_crop,
+	.vidioc_s_crop = s6v4l_s_crop,
+};
+
+static const struct v4l2_ioctl_ops output_v4l_ioctl_ops = {
+	.vidioc_querycap = s6v4l_querycap,
+	.vidioc_enum_fmt_vid_out = s6v4l_enum_fmt_out,
+	.vidioc_g_fmt_vid_out = s6v4l_g_fmt,
+	.vidioc_s_fmt_vid_out = s6v4l_s_fmt,
+	.vidioc_try_fmt_vid_out = s6v4l_try_fmt,
+	.vidioc_reqbufs = s6v4l_reqbufs,
+	.vidioc_querybuf = s6v4l_querybuf,
+	.vidioc_qbuf = s6v4l_qbuf,
+	.vidioc_dqbuf = s6v4l_dqbuf,
+	.vidioc_streamon = s6v4l_streamon,
+	.vidioc_streamoff = s6v4l_streamoff,
+	.vidioc_s_std = s6v4l_s_std,
+	.vidioc_enum_output = s6v4l_enum_output,
+	.vidioc_g_output = s6v4l_g_output,
+	.vidioc_s_output = s6v4l_s_output,
+	.vidioc_cropcap = s6v4l_cropcap,
+	.vidioc_g_crop = s6v4l_g_crop,
+	.vidioc_s_crop = s6v4l_s_crop,
+};
+
+
+static int probe_one(struct platform_device *pdev, int irq,
+		     struct video_device **devs, struct s6dp_link *link,
+		     void __iomem *dpbase, void __iomem *dmac, u32 physbase)
+{
+	struct video_device *dev;
+	struct s6dp *pd;
+	int index, res = -ENOMEM;
+
+	dev = video_device_alloc();
+	if (!dev) {
+		printk(DRV_ERR "video device alloc failed.\n");
+		goto err_allocd;
+	}
+	pd = kzalloc(sizeof(*pd), GFP_KERNEL);
+	if (!pd) {
+		printk(DRV_ERR "video device alloc failed.\n");
+		goto err_allocp;
+	}
+	pd->ext.egress = link->is_egress;
+	strlcpy(dev->name, pdev->name, sizeof(dev->name));
+	dev->fops = &s6v4l_video_fops;
+	dev->release = video_device_release;
+	dev->tvnorms = 0;
+	dev->parent = &pdev->dev;
+	if (pd->ext.egress)
+		dev->ioctl_ops = &output_v4l_ioctl_ops;
+	else
+		dev->ioctl_ops = &capture_v4l_ioctl_ops;
+	video_set_drvdata(dev, pd);
+	pd->irq = irq;
+	pd->dp = dpbase;
+	pd->dmac = (u32)dmac;
+	for (index = 0; !(link->port_mask & (1 << index)); index++)
+		;
+	if (link->port_mask != (1 << index)) {
+		printk(DRV_ERR "multi port mode not implemented\n");
+		goto err_videor;
+	}
+	pd->port = index;
+	pd->dataram = physbase + S6_DP_DATARAM(index);
+	pd->cur.state = DP_STATE_UNUSED;
+	pd->frames = NULL;
+	pd->nrframes = 0;
+	pd->link = link;
+	INIT_LIST_HEAD(&pd->idleq);
+	INIT_LIST_HEAD(&pd->busyq);
+	INIT_LIST_HEAD(&pd->fullq);
+	init_waitqueue_head(&pd->wait);
+	spin_lock_init(&pd->lock);
+	if (video_register_device_index(dev, VFL_TYPE_GRABBER, link->minor,
+					index)) {
+		printk(DRV_ERR "video_register_device failed!\n");
+		res = -ENODEV;
+		goto err_videor;
+	}
+	s6dp_reset_port(dev);
+	*devs = dev;
+	return 0;
+
+err_videor:
+	kfree(pd);
+err_allocp:
+	video_device_release(dev);
+err_allocd:
+	return res;
+}
+
+static int __devinit s6dp_probe(struct platform_device *pdev)
+{
+	int i, ret, irq;
+	unsigned in_use;
+	struct video_device **devs;
+	struct s6dp_link *links;
+	void __iomem *dpbase, *dmacbase;
+	struct resource *res, *regs, *dmac;
+	if (!pdev->dev.platform_data) {
+		printk(DRV_ERR "no platform data given\n");
+		return -EINVAL;
+	}
+	devs = kzalloc(DP_NB_PORTS * sizeof(*devs), GFP_KERNEL);
+	if (!devs) {
+		printk(DRV_ERR "video device alloc failed.\n");
+		return -ENOMEM;
+	}
+	irq = platform_get_irq(pdev, 0);
+	ret = request_irq(irq, &s6dp_interrupt, 0, DRV_NAME, devs);
+	if (ret) {
+		printk(DRV_ERR "irq request failed: %d\n", irq);
+		goto err_free_mem;
+	}
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		ret = -EINVAL;
+		goto err_free_irq;
+	}
+	regs = request_mem_region(res->start, res->end - res->start + 1,
+				  pdev->name);
+	if (!res) {
+		ret = -EBUSY;
+		goto err_free_irq;
+	}
+	dpbase = ioremap_nocache(regs->start, regs->end - regs->start + 1);
+	if (!dpbase) {
+		ret = -ENOMEM;
+		goto err_free_regs;
+	}
+	res = platform_get_resource(pdev, IORESOURCE_DMA, 0);
+	if (!res) {
+		ret = -EINVAL;
+		goto err_unmap_regs;
+	}
+	dmac = request_mem_region(res->start, res->end - res->start + 1,
+				  pdev->name);
+	if (!dmac) {
+		ret = -EBUSY;
+		goto err_unmap_regs;
+	}
+	dmacbase = ioremap_nocache(dmac->start, dmac->end - dmac->start + 1);
+	if (!dmacbase) {
+		ret = -ENOMEM;
+		goto err_free_dmac;
+	}
+	i = 0;
+	in_use = 0;
+	for (links = pdev->dev.platform_data; links->port_mask; links++) {
+		if (in_use & links->port_mask) {
+			printk(DRV_ERR "port already in use - skipping\n");
+			continue;
+		}
+		ret = probe_one(pdev, irq, &devs[i], links, dpbase, dmacbase,
+				regs->start);
+		if (ret)
+			goto err_free_devs;
+		in_use |= links->port_mask;
+		i++;
+	}
+	platform_set_drvdata(pdev, devs);
+	return 0;
+
+err_free_devs:
+	while (i--) {
+		if (devs[i]) {
+			struct s6dp *pd = video_get_drvdata(devs[i]);
+			video_unregister_device(devs[i]);
+			kfree(pd);
+			video_device_release(devs[i]);
+		}
+	}
+	iounmap(dmacbase);
+err_free_dmac:
+	release_mem_region(dmac->start, dmac->end - dmac->start + 1);
+err_unmap_regs:
+	iounmap(dpbase);
+err_free_regs:
+	release_mem_region(regs->start, regs->end - regs->start + 1);
+err_free_irq:
+	free_irq(irq, devs);
+err_free_mem:
+	kfree(devs);
+	return ret;
+}
+
+static int __devexit s6dp_remove(struct platform_device *pdev)
+{
+	struct video_device **devs = platform_get_drvdata(pdev);
+	int i;
+	platform_set_drvdata(pdev, NULL);
+	for (i = 0; i < DP_NB_PORTS; i++) {
+		struct video_device *dev = devs[i];
+		if (dev) {
+			struct s6dp *pd = video_get_drvdata(dev);
+			video_unregister_device(dev);
+			kfree(pd);
+			video_device_release(dev);
+		}
+	}
+	i = platform_get_irq(pdev, 0);
+	free_irq(i, devs);
+	kfree(devs);
+	return 0;
+}
+
+static struct platform_driver s6dp_driver = {
+	.probe = s6dp_probe,
+	.remove = __devexit_p(s6dp_remove),
+	.driver = {
+		.name = DRV_NAME,
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init s6dp_init(void)
+{
+	printk(DRV_INFO "S6 video driver <info@emlix.com>\n");
+	return platform_driver_register(&s6dp_driver);
+}
+
+static void __exit s6dp_exit(void)
+{
+	platform_driver_unregister(&s6dp_driver);
+}
+
+module_init(s6dp_init);
+module_exit(s6dp_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("S6105 on chip video driver");
+MODULE_AUTHOR("Fabian Godehardt, Hannes Weiner, "
+	"Oskar Schirmer, Daniel Gloeckner");
diff --git a/drivers/media/video/s6dp/s6dp.h b/drivers/media/video/s6dp/s6dp.h
new file mode 100644
index 0000000..4f299b7
--- /dev/null
+++ b/drivers/media/video/s6dp/s6dp.h
@@ -0,0 +1,121 @@
+/*
+ * drivers/media/video/s6dp/s6dp.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2008 emlix GmbH <info@emlix.com>
+ * Authors:	Fabian Godehardt <fg@emlix.com>
+ *		Oskar Schirmer <os@emlix.com>
+ */
+
+#ifndef __ASM_XTENSA_S6105_DP_H
+#define __ASM_XTENSA_S6105_DP_H
+
+#define S6_DP_CHAN_PER_PORT	4
+
+/* global data port setup */
+#define S6_DP_INT_STATUS		0x00
+#define S6_DP_INT_LOWWMARK(p)			(p)
+#define S6_DP_INT_PENDGCNT(p)			((p) + 4)
+#define S6_DP_INT_TERMCNT(p)			((p) + 8)
+#define S6_DP_INT_ERR_INT			12
+#define S6_DP_INT_ENABLE		0x04
+#define S6_DP_INT_DMAERR			16
+#define S6_DP_INT_UNDEROVERRUN(p)		((p) + 20)
+#define S6_DP_INT_WRONGPIXEL(p)			((p) * 2 + 24)
+#define S6_DP_INT_WRONGLINES(p)			((p) * 2 + 25)
+#define S6_DP_INT_RAW			0x08
+#define S6_DP_INT_CLEAR			0x0c
+#define S6_DP_INT_SET			0x10
+#define S6_DP_INT_UNMAP_RAW0		0x14
+#define S6_DP_INT_UNMAP_RAW1		0x18
+#define S6_DP_INT_UNMAP_RAW1_DP2_BT1120ERR	18
+#define S6_DP_INT_UNMAP_RAW1_DP0_BT1120ERR	19
+#define S6_DP_DP_CLK_SETTING		0x40
+#define S6_DP_DP_CLK_SETTING_CLK_MUX(p)		((p) * 4)
+#define S6_DP_DP_CLK_SETTING_CLK_MUX_MASK		3
+#define S6_DP_VIDEO_OUT_DLL_SEL		0x50
+#define S6_DP_VIDEO_REF_DLL_SEL		0x54
+#define S6_DP_VIDEO_FBK_DLL_SEL		0x58
+#define S6_DP_VIDEO_ENABLE		0x80
+#define S6_DP_VIDEO_ENABLE_ENABLE(p)		((p) * 8)
+#define S6_DP_VIDEO_DMA_CFG		0x84
+#define S6_DP_VIDEO_DMA_CFG_BURST_BITS(p)	((p) * 8)
+#define S6_DP_VIDEO_CFG(p)		((p) * 0x4 + 0x90)
+#define S6_DP_VIDEO_CFG_8_OR_10			0
+#define S6_DP_VIDEO_CFG_IN_OR_OUT		1
+#define S6_DP_VIDEO_CFG_FRAMING			2
+#define S6_DP_VIDEO_CFG_MODE			3
+#define S6_DP_VIDEO_CFG_MODE_422_SERIAL			0
+#define S6_DP_VIDEO_CFG_MODE_444_SERIAL			1
+#define S6_DP_VIDEO_CFG_MODE_422_PARALLEL		2
+#define S6_DP_VIDEO_CFG_MODE_444_PARALLEL		3
+#define S6_DP_VIDEO_CFG_MODE_422_SERIAL_CASCADE		4
+#define S6_DP_VIDEO_CFG_MODE_444_SERIAL_CASCADE		5
+#define S6_DP_VIDEO_CFG_MODE_422_PARALLEL_CASCADE	6
+#define S6_DP_VIDEO_CFG_MODE_RAW			7
+#define S6_DP_VIDEO_CFG_MODE_FIFO8			8
+#define S6_DP_VIDEO_CFG_MODE_FIFO16			9
+#define S6_DP_VIDEO_CFG_MODE_FIFO32			10
+#define S6_DP_VIDEO_CFG_MODE_STREAM8			11
+#define S6_DP_VIDEO_CFG_MODE_STREAM16			12
+#define S6_DP_VIDEO_CFG_MODE_STREAM32			13
+#define S6_DP_VIDEO_CFG_MODE_STREAM8_CASCADE		14
+#define S6_DP_VIDEO_CFG_MODE_STREAM16_CASCADE		15
+#define S6_DP_VIDEO_CFG_INTERL_OR_PROGR		8
+#define S6_DP_VIDEO_CFG_1120_VIDEO_MODE		9
+#define S6_DP_VIDEO_CFG_ANCILLARY_DATA		10
+#define S6_DP_VIDEO_CFG_VSYNC_POL		12
+#define S6_DP_VIDEO_CFG_HSYNC_POL		13
+#define S6_DP_VIDEO_CFG_BLANK_POL		14
+#define S6_DP_VIDEO_CFG_FIELD_CTRL		15
+#define S6_DP_VIDEO_CFG_BLANK_CTRL		16
+#define S6_DP_VIDEO_CFG_RELAX_MODE		21
+#define S6_DP_VIDEO_CFG_MICRON_MODE		22
+#define S6_DP_VIDEO_BLANK(p)		((p) * 0x4 + 0xa0)
+#define S6_DP_VIDEO_BAD_FRAME_NUM(p)	((p) * 0x4 + 0xc0)
+#define S6_DP_VIDEO_BAD_PIXEL_CNT(p)	((p) * 0x8 + 0xd0)
+#define S6_DP_VIDEO_BAD_LINE_CNT(p)	((p) * 0x8 + 0xd4)
+
+/* per port configuration registers */
+#define S6_DP_PIXEL_TOTAL		0x00
+#define S6_DP_PIXEL_ACTIVE		0x04
+#define S6_DP_PIXEL_OFFSET		0x08
+#define S6_DP_PIXEL_PADDING		0x0c
+#define S6_DP_ANC_PIXEL_ACTIVE		0x10
+#define S6_DP_ANC_PIXEL_OFFSET		0x14
+#define S6_DP_LINE_TOTAL		0x18
+#define S6_DP_LINE_ODD_TOTAL		0x1c
+#define S6_DP_LINE_ODD_ACTIVE		0x20
+#define S6_DP_LINE_ODD_OFFSET		0x24
+#define S6_DP_LINE_EVEN_ACTIVE		0x28
+#define S6_DP_LINE_EVEN_OFFSET		0x2c
+#define S6_DP_LINE_ODD_ANC_ACTIVE	0x30
+#define S6_DP_LINE_ODD_ANC_OFFSET	0x34
+#define S6_DP_LINE_EVEN_ANC_ACTIVE	0x38
+#define S6_DP_LINE_EVEN_ANC_OFFSET	0x3c
+#define S6_DP_ODD_VSYNC_LENGTH		0x40
+#define S6_DP_ODD_VSYNC_OFFSET		0x44
+#define S6_DP_EVEN_VSYNC_LENGTH		0x48
+#define S6_DP_EVEN_VSYNC_OFFSET		0x4c
+#define S6_DP_ODD_HSYNC_LENGTH		0x50
+#define S6_DP_ODD_HSYNC_OFFSET		0x54
+#define S6_DP_EVEN_HSYNC_LENGTH		0x58
+#define S6_DP_EVEN_HSYNC_OFFSET		0x5c
+
+#define S6_DP_FRAME_COUNT		0x60
+#define S6_DP_TSI_TIMESTAMP_UPDATE	0x64
+#define S6_DP_TSI_TIMESTAMP_HI		0x68
+#define S6_DP_TSI_TIMESTAMP_LO		0x6c
+#define S6_DP_CBCR_DMA_CONVERT		0x70
+#define S6_DP_Y_DMA_CONVERT		0x74
+#define S6_DP_ANC_DMA_CONVERT		0x78
+
+#define S6_DP_CFG_BASE(n)		((n) * 0x80 + 0x100)
+#define S6_DP_CHAN_OFFSET(n)		((n) * 0x100)
+#define S6_DP_DATARAM(port)		((port) * S6_DP_CHAN_PER_PORT * 0x100 \
+						+ 0x1000)
+
+#endif /* __ASM_XTENSA_S6105_DP_H */
diff --git a/include/media/s6dp-link.h b/include/media/s6dp-link.h
new file mode 100644
index 0000000..d1197da
--- /dev/null
+++ b/include/media/s6dp-link.h
@@ -0,0 +1,63 @@
+#ifndef __S6DP_LINK_H__
+#define __S6DP_LINK_H__
+
+#include <linux/videodev2.h>
+
+struct s6dp_mode {
+	unsigned int type:4;
+	unsigned int progressive:1;
+	unsigned int embedded_sync:1;
+	unsigned int micron_mode:1;
+	unsigned int vsync_pol:1;
+	unsigned int hsync_pol:1;
+	unsigned int blank_pol:1;
+	unsigned int field_ctrl:1;
+	unsigned int blank_ctrl:1;
+	unsigned int relaxed_framing:1;
+	unsigned int ten_bit:1;
+	unsigned int line_and_crc:1;
+	u16 pixel_total;
+	u16 pixel_offset;
+	u16 pixel_active;
+	u16 pixel_padding;
+	u16 hsync_offset;
+	u16 hsync_len;
+	u16 framelines;
+	u16 odd_vsync_offset;
+	u16 odd_vsync_len;
+	u16 odd_first;
+	u16 odd_active;
+	u16 odd_total;
+	u16 even_vsync_offset;
+	u16 even_vsync_len;
+	u16 even_first;
+	u16 even_active;
+};
+
+struct s6dp_link {
+	void *context;
+	unsigned port_mask:4;
+	unsigned is_egress:1;
+	int minor;
+	void (*g_mode)(void *ctx, struct s6dp_mode *mode);
+	int (*cropcap)(void *ctx, struct v4l2_cropcap *cap);
+	int (*s_crop)(void *ctx, struct v4l2_crop *crop, int busy);
+	int (*g_crop)(void *ctx, struct v4l2_crop *crop);
+	int (*e_std)(void *ctx, struct v4l2_standard *std);
+	int (*s_std)(void *ctx, v4l2_std_id *mask, int busy);
+	int (*s_fmt)(void *ctx, int try_fmt, struct v4l2_pix_format *fmt,
+		     int busy);
+	int (*g_fmt)(void *ctx, struct v4l2_pix_format *fmt);
+	union {
+		struct {
+			int (*e_inp)(void *ctx, struct v4l2_input *inp);
+			int (*s_inp)(void *ctx, unsigned int nr, int busy);
+		} ingress;
+		struct {
+			int (*e_outp)(void *ctx, struct v4l2_output *outp);
+			int (*s_outp)(void *ctx, unsigned int nr, int busy);
+		} egress;
+	} dir;
+};
+
+#endif
-- 
1.6.2.107.ge47ee

