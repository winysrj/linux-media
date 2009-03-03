Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:31511 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906AbZCCKHU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Mar 2009 05:07:20 -0500
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org, saaguirre@ti.com,
	tuukka.o.toivonen@nokia.com, dongsoo.kim@gmail.com
Subject: [PATCH 1/9] omap3isp: Add ISP main driver and register definitions
Date: Tue,  3 Mar 2009 12:06:48 +0200
Message-Id: <1236074816-30018-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <49AD0128.5090503@maxwell.research.nokia.com>
References: <49AD0128.5090503@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

TODO:

- Release resoures in isp_probe() if something fails.

- Implement a sensible generic interface so that the ISP can offer a
  v4l2_subdev (like the v4l2-int-device slaves) interface towards the
  camera driver.

- Handle CSI1 and CSI2 error cases (currently unhandled?).

- Fix H3A / HIST interrupt enabling / disabling.

- Clean up the private ioctls.

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 drivers/media/video/Makefile     |    2 +
 drivers/media/video/isp/Makefile |   12 +
 drivers/media/video/isp/isp.c    | 2418 ++++++++++++++++++++++++++++++++++++++
 drivers/media/video/isp/isp.h    |  318 +++++
 drivers/media/video/isp/ispreg.h | 1673 ++++++++++++++++++++++++++
 5 files changed, 4423 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/isp/Makefile
 create mode 100644 drivers/media/video/isp/isp.c
 create mode 100644 drivers/media/video/isp/isp.h
 create mode 100644 drivers/media/video/isp/ispreg.h

diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 72f6d03..e654270 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -106,6 +106,8 @@ obj-$(CONFIG_VIDEO_CX2341X) += cx2341x.o
 obj-$(CONFIG_VIDEO_CAFE_CCIC) += cafe_ccic.o
 obj-$(CONFIG_VIDEO_OV7670) 	+= ov7670.o
 
+obj-y				+= isp/
+
 obj-$(CONFIG_VIDEO_TCM825X) += tcm825x.o
 
 obj-$(CONFIG_USB_DABUSB)        += dabusb.o
diff --git a/drivers/media/video/isp/Makefile b/drivers/media/video/isp/Makefile
new file mode 100644
index 0000000..f14d617
--- /dev/null
+++ b/drivers/media/video/isp/Makefile
@@ -0,0 +1,12 @@
+# Makefile for OMAP3 ISP driver
+
+ifdef CONFIG_ARCH_OMAP3410
+isp-mod-objs += \
+	isp.o ispccdc.o
+else
+isp-mod-objs += \
+	isp.o ispccdc.o ispmmu.o \
+	isppreview.o ispresizer.o isph3a.o isphist.o isp_af.o ispcsi2.o
+endif
+
+obj-$(CONFIG_VIDEO_OMAP3) += isp-mod.o
diff --git a/drivers/media/video/isp/isp.c b/drivers/media/video/isp/isp.c
new file mode 100644
index 0000000..12a545c
--- /dev/null
+++ b/drivers/media/video/isp/isp.c
@@ -0,0 +1,2418 @@
+/*
+ * isp.c
+ *
+ * Driver Library for ISP Control module in TI's OMAP3 Camera ISP
+ * ISP interface and IRQ related APIs are defined here.
+ *
+ * Copyright (C) 2009 Texas Instruments.
+ * Copyright (C) 2009 Nokia.
+ *
+ * Contributors:
+ * 	Sameer Venkatraman <sameerv@ti.com>
+ * 	Mohit Jalori <mjalori@ti.com>
+ * 	Sergio Aguirre <saaguirre@ti.com>
+ * 	Sakari Ailus <sakari.ailus@nokia.com>
+ * 	Tuukka Toivonen <tuukka.o.toivonen@nokia.com>
+ *	Toni Leinonen <toni.leinonen@nokia.com>
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ */
+
+#include <asm/cacheflush.h>
+
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/clk.h>
+#include <linux/dma-mapping.h>
+#include <linux/vmalloc.h>
+#include <linux/platform_device.h>
+
+#include "isp.h"
+#include "ispmmu.h"
+#include "ispreg.h"
+#include "ispccdc.h"
+#include "isph3a.h"
+#include "isphist.h"
+#include "isp_af.h"
+#include "isppreview.h"
+#include "ispresizer.h"
+#include "ispcsi2.h"
+
+static struct isp_device *omap3isp;
+
+static int isp_try_size(struct v4l2_pix_format *pix_input,
+					struct v4l2_pix_format *pix_output);
+
+static void isp_save_ctx(void);
+
+static void isp_restore_ctx(void);
+
+static void isp_buf_init(void);
+
+/* List of image formats supported via OMAP ISP */
+const static struct v4l2_fmtdesc isp_formats[] = {
+	{
+		.description = "UYVY, packed",
+		.pixelformat = V4L2_PIX_FMT_UYVY,
+	},
+	{
+		.description = "YUYV (YUV 4:2:2), packed",
+		.pixelformat = V4L2_PIX_FMT_YUYV,
+	},
+	{
+		.description = "Bayer10 (GrR/BGb)",
+		.pixelformat = V4L2_PIX_FMT_SGRBG10,
+	},
+};
+
+/* ISP Crop capabilities */
+static struct v4l2_rect ispcroprect;
+static struct v4l2_rect cur_rect;
+
+/**
+ * struct vcontrol - Video control structure.
+ * @qc: V4L2 Query control structure.
+ * @current_value: Current value of the control.
+ */
+static struct vcontrol {
+	struct v4l2_queryctrl qc;
+	int current_value;
+} video_control[] = {
+	{
+		{
+			.id = V4L2_CID_BRIGHTNESS,
+			.type = V4L2_CTRL_TYPE_INTEGER,
+			.name = "Brightness",
+			.minimum = ISPPRV_BRIGHT_LOW,
+			.maximum = ISPPRV_BRIGHT_HIGH,
+			.step = ISPPRV_BRIGHT_STEP,
+			.default_value = ISPPRV_BRIGHT_DEF,
+		},
+		.current_value = ISPPRV_BRIGHT_DEF,
+	},
+	{
+		{
+			.id = V4L2_CID_CONTRAST,
+			.type = V4L2_CTRL_TYPE_INTEGER,
+			.name = "Contrast",
+			.minimum = ISPPRV_CONTRAST_LOW,
+			.maximum = ISPPRV_CONTRAST_HIGH,
+			.step = ISPPRV_CONTRAST_STEP,
+			.default_value = ISPPRV_CONTRAST_DEF,
+		},
+		.current_value = ISPPRV_CONTRAST_DEF,
+	},
+	{
+		{
+			.id = V4L2_CID_COLORFX,
+			.type = V4L2_CTRL_TYPE_MENU,
+			.name = "Color Effects",
+			.minimum = V4L2_COLORFX_NONE,
+			.maximum = V4L2_COLORFX_SEPIA,
+			.step = 1,
+			.default_value = V4L2_COLORFX_NONE,
+		},
+		.current_value = V4L2_COLORFX_NONE,
+	}
+};
+
+static struct v4l2_querymenu video_menu[] = {
+	{
+		.id = V4L2_CID_COLORFX,
+		.index = 0,
+		.name = "None",
+	},
+	{
+		.id = V4L2_CID_COLORFX,
+		.index = 1,
+		.name = "B&W",
+	},
+	{
+		.id = V4L2_CID_COLORFX,
+		.index = 2,
+		.name = "Sepia",
+	},
+};
+
+struct isp_buf {
+	dma_addr_t isp_addr;
+	void (*complete)(struct videobuf_buffer *vb, void *priv);
+	struct videobuf_buffer *vb;
+	void *priv;
+	u32 vb_state;
+};
+
+#define ISP_BUFS_IS_FULL(bufs) \
+	(((bufs)->queue + 1) % NUM_BUFS == (bufs)->done)
+#define ISP_BUFS_IS_EMPTY(bufs)		((bufs)->queue == (bufs)->done)
+#define ISP_BUFS_IS_LAST(bufs) \
+	((bufs)->queue == ((bufs)->done + 1) % NUM_BUFS)
+#define ISP_BUFS_QUEUED(bufs) \
+	((((bufs)->done - (bufs)->queue + NUM_BUFS)) % NUM_BUFS)
+#define ISP_BUF_DONE(bufs)		((bufs)->buf + (bufs)->done)
+#define ISP_BUF_NEXT_DONE(bufs)	\
+	((bufs)->buf + ((bufs)->done + 1) % NUM_BUFS)
+#define ISP_BUF_QUEUE(bufs)		((bufs)->buf + (bufs)->queue)
+#define ISP_BUF_MARK_DONE(bufs) \
+	(bufs)->done = ((bufs)->done + 1) % NUM_BUFS;
+#define ISP_BUF_MARK_QUEUED(bufs) \
+	(bufs)->queue = ((bufs)->queue + 1) % NUM_BUFS;
+
+struct isp_bufs {
+	dma_addr_t isp_addr_capture[VIDEO_MAX_FRAME];
+	spinlock_t lock;	/* For handling current buffer */
+	/* queue full: (ispsg.queue + 1) % NUM_BUFS == ispsg.done
+	   queue empty: ispsg.queue == ispsg.done */
+	struct isp_buf buf[NUM_BUFS];
+	/* Next slot to queue a buffer. */
+	int queue;
+	/* Buffer that is being processed. */
+	int done;
+	/* Wait for this many hs_vs before anything else. */
+	int wait_hs_vs;
+};
+
+/**
+ * struct ispirq - Structure for containing callbacks to be called in ISP ISR.
+ * @isp_callbk: Array which stores callback functions, indexed by the type of
+ *              callback (8 possible types).
+ * @isp_callbk_arg1: Pointer to array containing pointers to the first argument
+ *                   to be passed to the requested callback function.
+ * @isp_callbk_arg2: Pointer to array containing pointers to the second
+ *                   argument to be passed to the requested callback function.
+ *
+ * This structure is used to contain all the callback functions related for
+ * each callback type (CBK_CCDC_VD0, CBK_CCDC_VD1, CBK_PREV_DONE,
+ * CBK_RESZ_DONE, CBK_MMU_ERR, CBK_H3A_AWB_DONE, CBK_HIST_DONE, CBK_HS_VS,
+ * CBK_LSC_ISR).
+ */
+struct isp_irq {
+	isp_callback_t isp_callbk[CBK_END];
+	isp_vbq_callback_ptr isp_callbk_arg1[CBK_END];
+	void *isp_callbk_arg2[CBK_END];
+};
+
+/**
+ * struct ispmodule - Structure for storing ISP sub-module information.
+ * @isp_pipeline: Bit mask for submodules enabled within the ISP.
+ * @applyCrop: Flag to do a crop operation when video buffer queue ISR is done
+ * @pix: Structure containing the format and layout of the output image.
+ * @ccdc_input_width: ISP CCDC module input image width.
+ * @ccdc_input_height: ISP CCDC module input image height.
+ * @ccdc_output_width: ISP CCDC module output image width.
+ * @ccdc_output_height: ISP CCDC module output image height.
+ * @preview_input_width: ISP Preview module input image width.
+ * @preview_input_height: ISP Preview module input image height.
+ * @preview_output_width: ISP Preview module output image width.
+ * @preview_output_height: ISP Preview module output image height.
+ * @resizer_input_width: ISP Resizer module input image width.
+ * @resizer_input_height: ISP Resizer module input image height.
+ * @resizer_output_width: ISP Resizer module output image width.
+ * @resizer_output_height: ISP Resizer module output image height.
+ */
+struct isp_module {
+	unsigned int isp_pipeline;
+	int applyCrop;
+	struct v4l2_pix_format pix;
+	unsigned int ccdc_input_width;
+	unsigned int ccdc_input_height;
+	unsigned int ccdc_output_width;
+	unsigned int ccdc_output_height;
+	unsigned int preview_input_width;
+	unsigned int preview_input_height;
+	unsigned int preview_output_width;
+	unsigned int preview_output_height;
+	unsigned int resizer_input_width;
+	unsigned int resizer_input_height;
+	unsigned int resizer_output_width;
+	unsigned int resizer_output_height;
+};
+
+#define RAW_CAPTURE(isp) \
+	(!((isp)->module.isp_pipeline & OMAP_ISP_PREVIEW))
+
+/**
+ * struct isp - Structure for storing ISP Control module information
+ * @lock: Spinlock to sync between isr and processes.
+ * @isp_mutex: Semaphore used to get access to the ISP.
+ * @ref_count: Reference counter.
+ * @cam_ick: Pointer to ISP Interface clock.
+ * @cam_fck: Pointer to ISP Functional clock.
+ *
+ * This structure is used to store the OMAP ISP Control Information.
+ */
+static struct isp {
+	spinlock_t lock;	/* For handling registered ISP callbacks */
+	struct mutex isp_mutex;	/* For handling ref_count field */
+	int ref_count;
+	struct clk *cam_ick;
+	struct clk *cam_mclk;
+	struct clk *csi2_fck;
+	struct isp_interface_config *config;
+	dma_addr_t tmp_buf;
+	size_t tmp_buf_size;
+	unsigned long tmp_buf_offset;
+	 struct isp_bufs bufs;
+	 struct isp_irq irq;
+	 struct isp_module module;
+} isp_obj;
+
+/* Structure for saving/restoring ISP module registers */
+static struct isp_reg isp_reg_list[] = {
+	{OMAP3_ISP_IOMEM_MAIN, ISP_SYSCONFIG, 0},
+	{OMAP3_ISP_IOMEM_MAIN, ISP_TCTRL_GRESET_LENGTH, 0},
+	{OMAP3_ISP_IOMEM_MAIN, ISP_TCTRL_PSTRB_REPLAY, 0},
+	{OMAP3_ISP_IOMEM_MAIN, ISP_CTRL, 0},
+	{OMAP3_ISP_IOMEM_MAIN, ISP_TCTRL_CTRL, 0},
+	{OMAP3_ISP_IOMEM_MAIN, ISP_TCTRL_FRAME, 0},
+	{OMAP3_ISP_IOMEM_MAIN, ISP_TCTRL_PSTRB_DELAY, 0},
+	{OMAP3_ISP_IOMEM_MAIN, ISP_TCTRL_STRB_DELAY, 0},
+	{OMAP3_ISP_IOMEM_MAIN, ISP_TCTRL_SHUT_DELAY, 0},
+	{OMAP3_ISP_IOMEM_MAIN, ISP_TCTRL_PSTRB_LENGTH, 0},
+	{OMAP3_ISP_IOMEM_MAIN, ISP_TCTRL_STRB_LENGTH, 0},
+	{OMAP3_ISP_IOMEM_MAIN, ISP_TCTRL_SHUT_LENGTH, 0},
+	{OMAP3_ISP_IOMEM_CBUFF, ISP_CBUFF_SYSCONFIG, 0},
+	{OMAP3_ISP_IOMEM_CBUFF, ISP_CBUFF_IRQENABLE, 0},
+	{OMAP3_ISP_IOMEM_CBUFF, ISP_CBUFF0_CTRL, 0},
+	{OMAP3_ISP_IOMEM_CBUFF, ISP_CBUFF1_CTRL, 0},
+	{OMAP3_ISP_IOMEM_CBUFF, ISP_CBUFF0_START, 0},
+	{OMAP3_ISP_IOMEM_CBUFF, ISP_CBUFF1_START, 0},
+	{OMAP3_ISP_IOMEM_CBUFF, ISP_CBUFF0_END, 0},
+	{OMAP3_ISP_IOMEM_CBUFF, ISP_CBUFF1_END, 0},
+	{OMAP3_ISP_IOMEM_CBUFF, ISP_CBUFF0_WINDOWSIZE, 0},
+	{OMAP3_ISP_IOMEM_CBUFF, ISP_CBUFF1_WINDOWSIZE, 0},
+	{OMAP3_ISP_IOMEM_CBUFF, ISP_CBUFF0_THRESHOLD, 0},
+	{OMAP3_ISP_IOMEM_CBUFF, ISP_CBUFF1_THRESHOLD, 0},
+	{0, ISP_TOK_TERM, 0}
+};
+
+u32 isp_reg_readl(enum isp_mem_resources isp_mmio_range, u32 reg_offset)
+{
+	return __raw_readl(omap3isp->mmio_base[isp_mmio_range] + reg_offset);
+}
+EXPORT_SYMBOL(isp_reg_readl);
+
+void isp_reg_writel(u32 reg_value, enum isp_mem_resources isp_mmio_range,
+								u32 reg_offset)
+{
+	__raw_writel(reg_value,
+			omap3isp->mmio_base[isp_mmio_range] + reg_offset);
+}
+EXPORT_SYMBOL(isp_reg_writel);
+
+/*
+ *
+ * V4L2 Handling
+ *
+ */
+
+/**
+ * find_vctrl - Returns the index of the ctrl array of the requested ctrl ID.
+ * @id: Requested control ID.
+ *
+ * Returns 0 if successful, -EINVAL if not found, or -EDOM if its out of
+ * domain.
+ **/
+static int find_vctrl(int id)
+{
+	int i;
+
+	if (id < V4L2_CID_BASE)
+		return -EDOM;
+
+	for (i = (ARRAY_SIZE(video_control) - 1); i >= 0; i--)
+		if (video_control[i].qc.id == id)
+			break;
+
+	if (i < 0)
+		i = -EINVAL;
+
+	return i;
+}
+
+static int find_next_vctrl(int id)
+{
+	int i;
+	u32 best = (u32)-1;
+
+	for (i = 0; i < ARRAY_SIZE(video_control); i++) {
+		if (video_control[i].qc.id > id &&
+						(best == (u32)-1 ||
+						video_control[i].qc.id <
+						video_control[best].qc.id)) {
+			best = i;
+		}
+	}
+
+	if (best == (u32)-1)
+		return -EINVAL;
+
+	return best;
+}
+
+/**
+ * find_vmenu - Returns index of the menu array of the requested ctrl option.
+ * @id: Requested control ID.
+ * @index: Requested menu option index.
+ *
+ * Returns 0 if successful, -EINVAL if not found, or -EDOM if its out of
+ * domain.
+ **/
+static int find_vmenu(int id, int index)
+{
+	int i;
+
+	if (id < V4L2_CID_BASE)
+		return -EDOM;
+
+	for (i = (ARRAY_SIZE(video_menu) - 1); i >= 0; i--) {
+		if ((video_menu[i].id != id) || (video_menu[i].index != index))
+			continue;
+		return i;
+	}
+
+	return -EINVAL;
+}
+
+/**
+ * isp_release_resources - Free ISP submodules
+ **/
+static void isp_release_resources(void)
+{
+	if (isp_obj.module.isp_pipeline & OMAP_ISP_CCDC)
+		ispccdc_free();
+
+	if (isp_obj.module.isp_pipeline & OMAP_ISP_PREVIEW)
+		isppreview_free();
+
+	if (isp_obj.module.isp_pipeline & OMAP_ISP_RESIZER)
+		ispresizer_free();
+	return;
+}
+
+static int isp_wait(int (*busy)(void), int wait_for_busy, int max_wait)
+{
+	int wait = 0;
+
+	if (max_wait == 0)
+		max_wait = 10000; /* 10 ms */
+
+	while ((wait_for_busy && !busy())
+	       || (!wait_for_busy && busy())) {
+		rmb();
+		udelay(1);
+		wait++;
+		if (wait > max_wait) {
+			printk(KERN_ALERT "%s: wait is too much\n", __func__);
+			return -EBUSY;
+		}
+	}
+	DPRINTK_ISPCTRL(KERN_ALERT "%s: wait %d\n", __func__, wait);
+
+	return 0;
+}
+
+static int ispccdc_sbl_wait_idle(int max_wait)
+{
+	return isp_wait(ispccdc_sbl_busy, 0, max_wait);
+}
+
+static void isp_enable_interrupts(int is_raw)
+{
+	isp_reg_writel(-1, OMAP3_ISP_IOMEM_MAIN, ISP_IRQ0STATUS);
+	isp_reg_or(OMAP3_ISP_IOMEM_MAIN, ISP_IRQ0ENABLE,
+		    IRQ0ENABLE_CCDC_LSC_PREF_ERR_IRQ |
+		    IRQ0ENABLE_HS_VS_IRQ |
+		    IRQ0ENABLE_CCDC_VD0_IRQ |
+		    IRQ0ENABLE_CCDC_VD1_IRQ);
+
+	if (is_raw)
+		return;
+
+	isp_reg_or(OMAP3_ISP_IOMEM_MAIN, ISP_IRQ0ENABLE,
+		    IRQ0ENABLE_PRV_DONE_IRQ |
+		    IRQ0ENABLE_RSZ_DONE_IRQ);
+
+	return;
+}
+
+static void isp_disable_interrupts(void)
+{
+	isp_reg_and(OMAP3_ISP_IOMEM_MAIN, ISP_IRQ0ENABLE,
+		    ~(IRQ0ENABLE_CCDC_LSC_PREF_ERR_IRQ |
+			IRQ0ENABLE_HS_VS_IRQ |
+			IRQ0ENABLE_CCDC_VD0_IRQ |
+			IRQ0ENABLE_CCDC_VD1_IRQ |
+			IRQ0ENABLE_PRV_DONE_IRQ |
+			IRQ0ENABLE_RSZ_DONE_IRQ));
+}
+
+/**
+ * isp_set_callback - Sets the callback for the ISP module done events.
+ * @type: Type of the event for which callback is requested.
+ * @callback: Method to be called as callback in the ISR context.
+ * @arg1: First argument to be passed when callback is called in ISR.
+ * @arg2: Second argument to be passed when callback is called in ISR.
+ *
+ * This function sets a callback function for a done event in the ISP
+ * module, and enables the corresponding interrupt.
+ **/
+int isp_set_callback(enum isp_callback_type type, isp_callback_t callback,
+						isp_vbq_callback_ptr arg1,
+						void *arg2)
+{
+	unsigned long irqflags = 0;
+
+	if (callback == NULL) {
+		DPRINTK_ISPCTRL("ISP_ERR : Null Callback\n");
+		return -EINVAL;
+	}
+
+	spin_lock_irqsave(&isp_obj.lock, irqflags);
+	isp_obj.irq.isp_callbk[type] = callback;
+	isp_obj.irq.isp_callbk_arg1[type] = arg1;
+	isp_obj.irq.isp_callbk_arg2[type] = arg2;
+	spin_unlock_irqrestore(&isp_obj.lock, irqflags);
+
+	switch (type) {
+	case CBK_H3A_AWB_DONE:
+		isp_reg_writel(IRQ0ENABLE_H3A_AWB_DONE_IRQ,
+					OMAP3_ISP_IOMEM_MAIN, ISP_IRQ0STATUS);
+		isp_reg_or(OMAP3_ISP_IOMEM_MAIN, ISP_IRQ0ENABLE,
+						IRQ0ENABLE_H3A_AWB_DONE_IRQ);
+		break;
+	case CBK_H3A_AF_DONE:
+		isp_reg_writel(IRQ0ENABLE_H3A_AF_DONE_IRQ,
+					OMAP3_ISP_IOMEM_MAIN, ISP_IRQ0STATUS);
+		isp_reg_or(OMAP3_ISP_IOMEM_MAIN, ISP_IRQ0ENABLE,
+						IRQ0ENABLE_H3A_AF_DONE_IRQ);
+		break;
+	case CBK_HIST_DONE:
+		isp_reg_writel(IRQ0ENABLE_HIST_DONE_IRQ,
+					OMAP3_ISP_IOMEM_MAIN, ISP_IRQ0STATUS);
+		isp_reg_or(OMAP3_ISP_IOMEM_MAIN, ISP_IRQ0ENABLE,
+						IRQ0ENABLE_HIST_DONE_IRQ);
+		break;
+	case CBK_PREV_DONE:
+		isp_reg_writel(IRQ0ENABLE_PRV_DONE_IRQ,
+					OMAP3_ISP_IOMEM_MAIN, ISP_IRQ0STATUS);
+		isp_reg_or(OMAP3_ISP_IOMEM_MAIN, ISP_IRQ0ENABLE,
+						IRQ0ENABLE_PRV_DONE_IRQ);
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(isp_set_callback);
+
+/**
+ * isp_unset_callback - Clears the callback for the ISP module done events.
+ * @type: Type of the event for which callback to be cleared.
+ *
+ * This function clears a callback function for a done event in the ISP
+ * module, and disables the corresponding interrupt.
+ **/
+int isp_unset_callback(enum isp_callback_type type)
+{
+	unsigned long irqflags = 0;
+
+	spin_lock_irqsave(&isp_obj.lock, irqflags);
+	isp_obj.irq.isp_callbk[type] = NULL;
+	isp_obj.irq.isp_callbk_arg1[type] = NULL;
+	isp_obj.irq.isp_callbk_arg2[type] = NULL;
+	spin_unlock_irqrestore(&isp_obj.lock, irqflags);
+
+	switch (type) {
+	case CBK_H3A_AWB_DONE:
+		isp_reg_and(OMAP3_ISP_IOMEM_MAIN, ISP_IRQ0ENABLE,
+						~IRQ0ENABLE_H3A_AWB_DONE_IRQ);
+		break;
+	case CBK_H3A_AF_DONE:
+		isp_reg_and(OMAP3_ISP_IOMEM_MAIN, ISP_IRQ0ENABLE,
+						~IRQ0ENABLE_H3A_AF_DONE_IRQ);
+		break;
+	case CBK_HIST_DONE:
+		isp_reg_and(OMAP3_ISP_IOMEM_MAIN, ISP_IRQ0ENABLE,
+						~IRQ0ENABLE_HIST_DONE_IRQ);
+		break;
+	case CBK_CSIA:
+		isp_csi2_irq_set(0);
+		break;
+	case CBK_CSIB:
+		isp_reg_writel(IRQ0ENABLE_CSIB_IRQ, OMAP3_ISP_IOMEM_MAIN,
+							ISP_IRQ0STATUS);
+		isp_reg_or(OMAP3_ISP_IOMEM_MAIN, ISP_IRQ0ENABLE,
+						IRQ0ENABLE_CSIB_IRQ);
+		break;
+	case CBK_PREV_DONE:
+		isp_reg_and(OMAP3_ISP_IOMEM_MAIN, ISP_IRQ0ENABLE,
+						~IRQ0ENABLE_PRV_DONE_IRQ);
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(isp_unset_callback);
+
+/**
+ * isp_set_xclk - Configures the specified cam_xclk to the desired frequency.
+ * @xclk: Desired frequency of the clock in Hz.
+ * @xclksel: XCLK to configure (0 = A, 1 = B).
+ *
+ * Configures the specified MCLK divisor in the ISP timing control register
+ * (TCTRL_CTRL) to generate the desired xclk clock value.
+ *
+ * Divisor = CM_CAM_MCLK_HZ / xclk
+ *
+ * Returns the final frequency that is actually being generated
+ **/
+u32 isp_set_xclk(u32 xclk, u8 xclksel)
+{
+	u32 divisor;
+	u32 currentxclk;
+
+	if (xclk >= CM_CAM_MCLK_HZ) {
+		divisor = ISPTCTRL_CTRL_DIV_BYPASS;
+		currentxclk = CM_CAM_MCLK_HZ;
+	} else if (xclk >= 2) {
+		divisor = CM_CAM_MCLK_HZ / xclk;
+		if (divisor >= ISPTCTRL_CTRL_DIV_BYPASS)
+			divisor = ISPTCTRL_CTRL_DIV_BYPASS - 1;
+		currentxclk = CM_CAM_MCLK_HZ / divisor;
+	} else {
+		divisor = xclk;
+		currentxclk = 0;
+	}
+
+	switch (xclksel) {
+	case 0:
+		isp_reg_and_or(OMAP3_ISP_IOMEM_MAIN, ISP_TCTRL_CTRL,
+					~ISPTCTRL_CTRL_DIVA_MASK,
+					divisor << ISPTCTRL_CTRL_DIVA_SHIFT);
+		DPRINTK_ISPCTRL("isp_set_xclk(): cam_xclka set to %d Hz\n",
+								currentxclk);
+		break;
+	case 1:
+		isp_reg_and_or(OMAP3_ISP_IOMEM_MAIN, ISP_TCTRL_CTRL,
+					~ISPTCTRL_CTRL_DIVB_MASK,
+					divisor << ISPTCTRL_CTRL_DIVB_SHIFT);
+		DPRINTK_ISPCTRL("isp_set_xclk(): cam_xclkb set to %d Hz\n",
+								currentxclk);
+		break;
+	default:
+		DPRINTK_ISPCTRL("ISP_ERR: isp_set_xclk(): Invalid requested "
+						"xclk. Must be 0 (A) or 1 (B)."
+						"\n");
+		return -EINVAL;
+	}
+
+	return currentxclk;
+}
+EXPORT_SYMBOL(isp_set_xclk);
+
+/**
+ * isp_power_settings - Sysconfig settings, for Power Management.
+ * @isp_sysconfig: Structure containing the power settings for ISP to configure
+ *
+ * Sets the power settings for the ISP, and SBL bus.
+ **/
+static void isp_power_settings(int idle)
+{
+	if (idle) {
+		isp_reg_writel(ISP_SYSCONFIG_AUTOIDLE |
+				(ISP_SYSCONFIG_MIDLEMODE_SMARTSTANDBY <<
+				ISP_SYSCONFIG_MIDLEMODE_SHIFT),
+				OMAP3_ISP_IOMEM_MAIN,
+				ISP_SYSCONFIG);
+		if (omap_rev() == OMAP3430_REV_ES1_0) {
+			isp_reg_writel(ISPCSI1_AUTOIDLE |
+					(ISPCSI1_MIDLEMODE_SMARTSTANDBY <<
+					ISPCSI1_MIDLEMODE_SHIFT),
+					OMAP3_ISP_IOMEM_CSI2A,
+					ISP_CSIA_SYSCONFIG);
+			isp_reg_writel(ISPCSI1_AUTOIDLE |
+					(ISPCSI1_MIDLEMODE_SMARTSTANDBY <<
+					ISPCSI1_MIDLEMODE_SHIFT),
+					OMAP3_ISP_IOMEM_CCP2,
+					ISP_CSIB_SYSCONFIG);
+		}
+		isp_reg_writel(ISPCTRL_SBL_AUTOIDLE, OMAP3_ISP_IOMEM_MAIN,
+								ISP_CTRL);
+
+	} else {
+		isp_reg_writel(ISP_SYSCONFIG_AUTOIDLE |
+				(ISP_SYSCONFIG_MIDLEMODE_FORCESTANDBY <<
+				ISP_SYSCONFIG_MIDLEMODE_SHIFT),
+				OMAP3_ISP_IOMEM_MAIN,
+				ISP_SYSCONFIG);
+		if (omap_rev() == OMAP3430_REV_ES1_0) {
+			isp_reg_writel(ISPCSI1_AUTOIDLE |
+					(ISPCSI1_MIDLEMODE_FORCESTANDBY <<
+					ISPCSI1_MIDLEMODE_SHIFT),
+					OMAP3_ISP_IOMEM_CSI2A,
+					ISP_CSIA_SYSCONFIG);
+
+			isp_reg_writel(ISPCSI1_AUTOIDLE |
+					(ISPCSI1_MIDLEMODE_FORCESTANDBY <<
+					ISPCSI1_MIDLEMODE_SHIFT),
+					OMAP3_ISP_IOMEM_CCP2,
+					ISP_CSIB_SYSCONFIG);
+		}
+
+		isp_reg_writel(ISPCTRL_SBL_AUTOIDLE, OMAP3_ISP_IOMEM_MAIN,
+								ISP_CTRL);
+	}
+}
+
+#define BIT_SET(var, shift, mask, val)		\
+	do {					\
+		var = (var & ~(mask << shift))	\
+			| (val << shift);	\
+	} while (0)
+
+static int isp_init_csi(struct isp_interface_config *config)
+{
+	u32 i = 0, val, reg;
+	int format;
+
+	switch (config->u.csi.format) {
+	case V4L2_PIX_FMT_SGRBG10:
+		format = 0x16;		/* RAW10+VP */
+		break;
+	case V4L2_PIX_FMT_SGRBG10DPCM8:
+		format = 0x12;		/* RAW8+DPCM10+VP */
+		break;
+	default:
+		printk(KERN_ERR "isp_init_csi: bad csi format\n");
+		return -EINVAL;
+	}
+
+	/* Reset the CSI and wait for reset to complete */
+	isp_reg_writel(isp_reg_readl(OMAP3_ISP_IOMEM_CCP2, ISPCSI1_SYSCONFIG) |
+							BIT(1),
+							OMAP3_ISP_IOMEM_CCP2,
+							ISPCSI1_SYSCONFIG);
+	while (!(isp_reg_readl(OMAP3_ISP_IOMEM_CCP2, ISPCSI1_SYSSTATUS) &
+								BIT(0))) {
+		udelay(10);
+		if (i++ > 10)
+			break;
+	}
+	if (!(isp_reg_readl(OMAP3_ISP_IOMEM_CCP2, ISPCSI1_SYSSTATUS) &
+								BIT(0))) {
+		printk(KERN_WARNING
+			"omap3_isp: timeout waiting for csi reset\n");
+	}
+
+	/* ISPCSI1_CTRL */
+	val = isp_reg_readl(OMAP3_ISP_IOMEM_CCP2, ISPCSI1_CTRL);
+	val &= ~BIT(11);	/* Enable VP only off ->
+				extract embedded data to interconnect */
+	BIT_SET(val, 8, 0x3, config->u.csi.vpclk);	/* Video port clock */
+/*	val |= BIT(3);	*/	/* Wait for FEC before disabling interface */
+	val |= BIT(2);		/* I/O cell output is parallel
+				(no effect, but errata says should be enabled
+				for class 1/2) */
+	val |= BIT(12);		/* VP clock polarity to falling edge
+				(needed or bad picture!) */
+
+	/* Data/strobe physical layer */
+	BIT_SET(val, 1, 1, config->u.csi.signalling);
+	BIT_SET(val, 10, 1, config->u.csi.strobe_clock_inv);
+	val |= BIT(4);		/* Magic bit to enable CSI1 and strobe mode */
+	isp_reg_writel(val, OMAP3_ISP_IOMEM_CCP2, ISPCSI1_CTRL);
+
+	/* ISPCSI1_LCx_CTRL logical channel #0 */
+	reg = ISPCSI1_LCx_CTRL(0);	/* reg = ISPCSI1_CTRL1; */
+	val = isp_reg_readl(OMAP3_ISP_IOMEM_CCP2, reg);
+	/* Format = RAW10+VP or RAW8+DPCM10+VP*/
+	BIT_SET(val, 3, 0x1f, format);
+	/* Enable setting of frame regions of interest */
+	BIT_SET(val, 1, 1, 1);
+	BIT_SET(val, 2, 1, config->u.csi.crc);
+	isp_reg_writel(val, OMAP3_ISP_IOMEM_CCP2, reg);
+
+	/* ISPCSI1_DAT_START for logical channel #0 */
+	reg = ISPCSI1_LCx_DAT_START(0);		/* reg = ISPCSI1_DAT_START; */
+	val = isp_reg_readl(OMAP3_ISP_IOMEM_CCP2, reg);
+	BIT_SET(val, 16, 0xfff, config->u.csi.data_start);
+	isp_reg_writel(val, OMAP3_ISP_IOMEM_CCP2, reg);
+
+	/* ISPCSI1_DAT_SIZE for logical channel #0 */
+	reg = ISPCSI1_LCx_DAT_SIZE(0);		/* reg = ISPCSI1_DAT_SIZE; */
+	val = isp_reg_readl(OMAP3_ISP_IOMEM_CCP2, reg);
+	BIT_SET(val, 16, 0xfff, config->u.csi.data_size);
+	isp_reg_writel(val, OMAP3_ISP_IOMEM_CCP2, reg);
+
+	/* Clear status bits for logical channel #0 */
+	isp_reg_writel(0xFFF & ~BIT(6), OMAP3_ISP_IOMEM_CCP2,
+						ISPCSI1_LC01_IRQSTATUS);
+
+	/* Enable CSI1 */
+	val = isp_reg_readl(OMAP3_ISP_IOMEM_CCP2, ISPCSI1_CTRL);
+	val |=  BIT(0) | BIT(4);
+	isp_reg_writel(val, OMAP3_ISP_IOMEM_CCP2, ISPCSI1_CTRL);
+
+	if (!(isp_reg_readl(OMAP3_ISP_IOMEM_CCP2, ISPCSI1_CTRL) & BIT(4))) {
+		printk(KERN_WARNING "OMAP3 CSI1 bus not available\n");
+		if (config->u.csi.signalling)	/* Strobe mode requires CSI1 */
+			return -EIO;
+	}
+
+	return 0;
+}
+
+/**
+ * isp_configure_interface - Configures ISP Control I/F related parameters.
+ * @config: Pointer to structure containing the desired configuration for the
+ * 	ISP.
+ *
+ * Configures ISP control register (ISP_CTRL) with the values specified inside
+ * the config structure. Controls:
+ * - Selection of parallel or serial input to the preview hardware.
+ * - Data lane shifter.
+ * - Pixel clock polarity.
+ * - 8 to 16-bit bridge at the input of CCDC module.
+ * - HS or VS synchronization signal detection
+ **/
+int isp_configure_interface(struct isp_interface_config *config)
+{
+	u32 ispctrl_val = isp_reg_readl(OMAP3_ISP_IOMEM_MAIN, ISP_CTRL);
+	int r;
+
+	isp_obj.config = config;
+
+	ispctrl_val &= ISPCTRL_SHIFT_MASK;
+	ispctrl_val |= (config->dataline_shift << ISPCTRL_SHIFT_SHIFT);
+	ispctrl_val &= ~ISPCTRL_PAR_CLK_POL_INV;
+
+	ispctrl_val &= (ISPCTRL_PAR_SER_CLK_SEL_MASK);
+
+	isp_buf_init();
+
+	switch (config->ccdc_par_ser) {
+	case ISP_PARLL:
+		ispctrl_val |= ISPCTRL_PAR_SER_CLK_SEL_PARALLEL;
+		ispctrl_val |= (config->u.par.par_clk_pol
+						<< ISPCTRL_PAR_CLK_POL_SHIFT);
+		ispctrl_val &= ~ISPCTRL_PAR_BRIDGE_BENDIAN;
+		ispctrl_val |= (config->u.par.par_bridge
+						<< ISPCTRL_PAR_BRIDGE_SHIFT);
+		break;
+	case ISP_CSIA:
+		ispctrl_val |= ISPCTRL_PAR_SER_CLK_SEL_CSIA;
+		ispctrl_val &= ~ISPCTRL_PAR_BRIDGE_BENDIAN;
+
+		isp_csi2_ctx_config_format(0, config->u.csi.format);
+		isp_csi2_ctx_update(0, false);
+
+		if (config->u.csi.crc)
+			isp_csi2_ctrl_config_ecc_enable(true);
+
+		isp_csi2_ctrl_config_vp_out_ctrl(config->u.csi.vpclk);
+		isp_csi2_ctrl_config_vp_only_enable(true);
+		isp_csi2_ctrl_config_vp_clk_enable(true);
+		isp_csi2_ctrl_update(false);
+
+		isp_csi2_irq_complexio1_set(1);
+		isp_csi2_irq_status_set(1);
+		isp_csi2_irq_set(1);
+
+		isp_csi2_enable(1);
+		mdelay(3);
+		break;
+	case ISP_CSIB:
+		ispctrl_val |= ISPCTRL_PAR_SER_CLK_SEL_CSIB;
+		r = isp_init_csi(config);
+		if (r)
+			return r;
+		break;
+	case ISP_NONE:
+		return 0;
+	default:
+		return -EINVAL;
+	}
+
+	ispctrl_val &= ~(ISPCTRL_SYNC_DETECT_VSRISE);
+	ispctrl_val |= (config->hsvs_syncdetect);
+
+	isp_reg_writel(ispctrl_val, OMAP3_ISP_IOMEM_MAIN, ISP_CTRL);
+
+	/* Set sensor specific fields in CCDC and Previewer module.*/
+	isppreview_set_skip(config->prev_sph, config->prev_slv);
+	ispccdc_set_wenlog(config->wenlog);
+
+	return 0;
+}
+EXPORT_SYMBOL(isp_configure_interface);
+
+static int isp_buf_process(struct isp_bufs *bufs);
+
+/**
+ * omap34xx_isp_isr - Interrupt Service Routine for Camera ISP module.
+ * @irq: Not used currently.
+ * @ispirq_disp: Pointer to the object that is passed while request_irq is
+ *               called. This is the isp_obj.irq object containing info on the
+ *               callback.
+ *
+ * Handles the corresponding callback if plugged in.
+ *
+ * Returns IRQ_HANDLED when IRQ was correctly handled, or IRQ_NONE when the
+ * IRQ wasn't handled.
+ **/
+static irqreturn_t omap34xx_isp_isr(int irq, void *_isp)
+{
+	struct isp *isp = _isp;
+	struct isp_irq *irqdis = &isp->irq;
+	struct isp_bufs *bufs = &isp->bufs;
+	unsigned long flags;
+	u32 irqstatus = 0;
+	unsigned long irqflags = 0;
+	int wait_hs_vs = 0;
+
+	irqstatus = isp_reg_readl(OMAP3_ISP_IOMEM_MAIN, ISP_IRQ0STATUS);
+	isp_reg_writel(irqstatus, OMAP3_ISP_IOMEM_MAIN, ISP_IRQ0STATUS);
+
+	spin_lock_irqsave(&bufs->lock, flags);
+	wait_hs_vs = bufs->wait_hs_vs;
+	if (irqstatus & HS_VS && bufs->wait_hs_vs)
+		bufs->wait_hs_vs--;
+	spin_unlock_irqrestore(&bufs->lock, flags);
+
+	spin_lock_irqsave(&isp_obj.lock, irqflags);
+	/*
+	 * We need to wait for the first HS_VS interrupt from CCDC.
+	 * Otherwise our frame (and everything else) might be bad.
+	 */
+	if (wait_hs_vs)
+		goto out_ignore_buff;
+
+	if ((irqstatus & CCDC_VD0) == CCDC_VD0) {
+		if (RAW_CAPTURE(&isp_obj))
+			isp_buf_process(bufs);
+	}
+
+	if ((irqstatus & PREV_DONE) == PREV_DONE) {
+		if (irqdis->isp_callbk[CBK_PREV_DONE])
+			irqdis->isp_callbk[CBK_PREV_DONE](PREV_DONE,
+				irqdis->isp_callbk_arg1[CBK_PREV_DONE],
+				irqdis->isp_callbk_arg2[CBK_PREV_DONE]);
+		else if (!RAW_CAPTURE(&isp_obj) && !ispresizer_busy()) {
+			if (isp_obj.module.applyCrop) {
+				ispresizer_applycrop();
+				if (!ispresizer_busy())
+					isp_obj.module.applyCrop = 0;
+			}
+			if (!isppreview_busy()) {
+				ispresizer_enable(1);
+				if (isppreview_busy()) {
+					/* FIXME: locking! */
+					ISP_BUF_DONE(bufs)->vb_state =
+						VIDEOBUF_ERROR;
+					printk(KERN_ERR "%s: can't stop"
+					       " preview\n", __func__);
+				}
+			}
+			if (!isppreview_busy())
+				isppreview_config_shadow_registers();
+			if (!isppreview_busy())
+				isph3a_update_wb();
+		}
+	}
+
+	if ((irqstatus & RESZ_DONE) == RESZ_DONE) {
+		if (!RAW_CAPTURE(&isp_obj)) {
+			if (!ispresizer_busy())
+				ispresizer_config_shadow_registers();
+			isp_buf_process(bufs);
+		}
+	}
+
+	if ((irqstatus & H3A_AWB_DONE) == H3A_AWB_DONE) {
+		if (irqdis->isp_callbk[CBK_H3A_AWB_DONE])
+			irqdis->isp_callbk[CBK_H3A_AWB_DONE](H3A_AWB_DONE,
+				irqdis->isp_callbk_arg1[CBK_H3A_AWB_DONE],
+				irqdis->isp_callbk_arg2[CBK_H3A_AWB_DONE]);
+	}
+
+	if ((irqstatus & HIST_DONE) == HIST_DONE) {
+		if (irqdis->isp_callbk[CBK_HIST_DONE])
+			irqdis->isp_callbk[CBK_HIST_DONE](HIST_DONE,
+				irqdis->isp_callbk_arg1[CBK_HIST_DONE],
+				irqdis->isp_callbk_arg2[CBK_HIST_DONE]);
+	}
+
+	if ((irqstatus & H3A_AF_DONE) == H3A_AF_DONE) {
+		if (irqdis->isp_callbk[CBK_H3A_AF_DONE])
+			irqdis->isp_callbk[CBK_H3A_AF_DONE](H3A_AF_DONE,
+				irqdis->isp_callbk_arg1[CBK_H3A_AF_DONE],
+				irqdis->isp_callbk_arg2[CBK_H3A_AF_DONE]);
+	}
+
+
+out_ignore_buff:
+	if (irqstatus & LSC_PRE_ERR) {
+		struct isp_buf *buf = ISP_BUF_DONE(bufs);
+		ispccdc_enable_lsc(0);
+		ispccdc_enable_lsc(1);
+		/* Mark buffer faulty. */
+		buf->vb_state = VIDEOBUF_ERROR;
+		printk(KERN_ERR "%s: lsc prefetch error\n", __func__);
+	}
+
+	if ((irqstatus & CSIA) == CSIA) {
+		struct isp_buf *buf = ISP_BUF_DONE(bufs);
+		isp_csi2_isr();
+		buf->vb_state = VIDEOBUF_ERROR;
+	}
+
+	if (irqstatus & IRQ0STATUS_CSIB_IRQ) {
+		u32 ispcsi1_irqstatus;
+
+		ispcsi1_irqstatus = isp_reg_readl(OMAP3_ISP_IOMEM_CCP2,
+						ISPCSI1_LC01_IRQSTATUS);
+		DPRINTK_ISPCTRL("%x\n", ispcsi1_irqstatus);
+	}
+
+	if (irqdis->isp_callbk[CBK_CATCHALL]) {
+		irqdis->isp_callbk[CBK_CATCHALL](irqstatus,
+			irqdis->isp_callbk_arg1[CBK_CATCHALL],
+			irqdis->isp_callbk_arg2[CBK_CATCHALL]);
+	}
+
+	spin_unlock_irqrestore(&isp_obj.lock, irqflags);
+
+#if 1
+	{
+		static const struct {
+			int num;
+			char *name;
+		} bits[] = {
+			{ 31, "HS_VS_IRQ" },
+			{ 30, "SEC_ERR_IRQ" },
+			{ 29, "OCP_ERR_IRQ" },
+			{ 28, "MMU_ERR_IRQ" },
+			{ 27, "res27" },
+			{ 26, "res26" },
+			{ 25, "OVF_IRQ" },
+			{ 24, "RSZ_DONE_IRQ" },
+			{ 23, "res23" },
+			{ 22, "res22" },
+			{ 21, "CBUFF_IRQ" },
+			{ 20, "PRV_DONE_IRQ" },
+			{ 19, "CCDC_LSC_PREFETCH_ERROR" },
+			{ 18, "CCDC_LSC_PREFETCH_COMPLETED" },
+			{ 17, "CCDC_LSC_DONE" },
+			{ 16, "HIST_DONE_IRQ" },
+			{ 15, "res15" },
+			{ 14, "res14" },
+			{ 13, "H3A_AWB_DONE_IRQ" },
+			{ 12, "H3A_AF_DONE_IRQ" },
+			{ 11, "CCDC_ERR_IRQ" },
+			{ 10, "CCDC_VD2_IRQ" },
+			{  9, "CCDC_VD1_IRQ" },
+			{  8, "CCDC_VD0_IRQ" },
+			{  7, "res7" },
+			{  6, "res6" },
+			{  5, "res5" },
+			{  4, "CSIB_IRQ" },
+			{  3, "CSIB_LCM_IRQ" },
+			{  2, "res2" },
+			{  1, "res1" },
+			{  0, "CSIA_IRQ" },
+		};
+		int i;
+		for (i = 0; i < ARRAY_SIZE(bits); i++) {
+			if ((1 << bits[i].num) & irqstatus)
+				DPRINTK_ISPCTRL("%s ", bits[i].name);
+		}
+		DPRINTK_ISPCTRL("\n");
+	}
+#endif
+
+	return IRQ_HANDLED;
+}
+
+/* Device name, needed for resource tracking layer */
+struct device_driver camera_drv = {
+	.name = "camera"
+};
+
+struct device camera_dev = {
+	.driver = &camera_drv,
+};
+
+/**
+ *  isp_tmp_buf_free - To free allocated 10MB memory
+ *
+ **/
+static void isp_tmp_buf_free(void)
+{
+	if (isp_obj.tmp_buf) {
+		ispmmu_vfree(isp_obj.tmp_buf);
+		isp_obj.tmp_buf = 0;
+		isp_obj.tmp_buf_size = 0;
+	}
+}
+
+/**
+ *  isp_tmp_buf_alloc - To allocate a 10MB memory
+ *
+ **/
+static u32 isp_tmp_buf_alloc(size_t size)
+{
+	isp_tmp_buf_free();
+
+	printk(KERN_INFO "%s: allocating %d bytes\n", __func__, size);
+
+	isp_obj.tmp_buf = ispmmu_vmalloc(size);
+	if (IS_ERR((void *)isp_obj.tmp_buf)) {
+		printk(KERN_ERR "ispmmu_vmap mapping failed ");
+		return -ENOMEM;
+	}
+	isp_obj.tmp_buf_size = size;
+
+	isppreview_set_outaddr(isp_obj.tmp_buf);
+	ispresizer_set_inaddr(isp_obj.tmp_buf);
+
+	return 0;
+}
+
+/**
+ * isp_start - Starts ISP submodule
+ *
+ * Start the needed isp components assuming these components
+ * are configured correctly.
+ **/
+void isp_start(void)
+{
+	if ((isp_obj.module.isp_pipeline & OMAP_ISP_PREVIEW) &&
+						is_isppreview_enabled())
+		isppreview_enable(1);
+
+	return;
+}
+EXPORT_SYMBOL(isp_start);
+
+#define ISP_STATISTICS_BUSY				\
+	()
+#define ISP_STOP_TIMEOUT	msecs_to_jiffies(1000)
+/**
+ * isp_stop - Stops isp submodules
+ **/
+void isp_stop()
+{
+	unsigned long timeout = jiffies + ISP_STOP_TIMEOUT;
+	int reset = 0;
+
+	isp_disable_interrupts();
+
+	/*
+	 * We need to stop all the modules after CCDC first or they'll
+	 * never stop since they may not get a full frame from CCDC.
+	 */
+	isp_af_enable(0);
+	isph3a_aewb_enable(0);
+	isp_hist_enable(0);
+	isppreview_enable(0);
+	ispresizer_enable(0);
+
+	timeout = jiffies + ISP_STOP_TIMEOUT;
+	while (isp_af_busy()
+	       || isph3a_aewb_busy()
+	       || isp_hist_busy()
+	       || isppreview_busy()
+	       || ispresizer_busy()) {
+		if (time_after(jiffies, timeout)) {
+			printk(KERN_ERR "%s: can't stop non-ccdc modules\n",
+			       __func__);
+			reset = 1;
+			break;
+		}
+		msleep(1);
+	}
+
+	/* Let's stop CCDC now. */
+	ispccdc_enable_lsc(0);
+	ispccdc_enable(0);
+
+	timeout = jiffies + ISP_STOP_TIMEOUT;
+	while (ispccdc_busy()) {
+		if (time_after(jiffies, timeout)) {
+			printk(KERN_ERR "%s: can't stop ccdc\n", __func__);
+			reset = 1;
+			break;
+		}
+		msleep(1);
+	}
+
+	isp_buf_init();
+
+	if (!reset)
+		return;
+
+	isp_save_ctx();
+	isp_reg_writel(isp_reg_readl(OMAP3_ISP_IOMEM_MAIN, ISP_SYSCONFIG)
+		       | ISP_SYSCONFIG_SOFTRESET,
+		       OMAP3_ISP_IOMEM_MAIN, ISP_SYSCONFIG);
+	timeout = 0;
+	while (!(isp_reg_readl(OMAP3_ISP_IOMEM_MAIN, ISP_SYSSTATUS) & 0x1)) {
+		if (timeout++ > 10000) {
+			printk(KERN_ALERT "%s: cannot reset ISP\n", __func__);
+			break;
+		}
+		udelay(1);
+	}
+	isp_restore_ctx();
+}
+EXPORT_SYMBOL(isp_stop);
+
+static void isp_set_buf(struct isp_buf *buf)
+{
+	if ((isp_obj.module.isp_pipeline & OMAP_ISP_RESIZER) &&
+						is_ispresizer_enabled())
+		ispresizer_set_outaddr(buf->isp_addr);
+	else if (isp_obj.module.isp_pipeline & OMAP_ISP_CCDC)
+		ispccdc_set_outaddr(buf->isp_addr);
+
+}
+
+/**
+ * isp_calc_pipeline - Sets pipeline depending of input and output pixel format
+ * @pix_input: Pointer to V4L2 pixel format structure for input image.
+ * @pix_output: Pointer to V4L2 pixel format structure for output image.
+ **/
+static u32 isp_calc_pipeline(struct v4l2_pix_format *pix_input,
+			     struct v4l2_pix_format *pix_output)
+{
+	isp_release_resources();
+	if ((pix_input->pixelformat == V4L2_PIX_FMT_SGRBG10
+	     || pix_input->pixelformat == V4L2_PIX_FMT_SGRBG10DPCM8)
+	    && pix_output->pixelformat != V4L2_PIX_FMT_SGRBG10) {
+		isp_obj.module.isp_pipeline = OMAP_ISP_CCDC | OMAP_ISP_PREVIEW |
+							OMAP_ISP_RESIZER;
+		ispccdc_request();
+		isppreview_request();
+		ispresizer_request();
+		ispccdc_config_datapath(CCDC_RAW, CCDC_OTHERS_VP);
+		isppreview_config_datapath(PRV_RAW_CCDC, PREVIEW_MEM);
+		ispresizer_config_datapath(RSZ_MEM_YUV);
+	} else {
+		isp_obj.module.isp_pipeline = OMAP_ISP_CCDC;
+		ispccdc_request();
+		if (pix_input->pixelformat == V4L2_PIX_FMT_SGRBG10
+		    || pix_input->pixelformat == V4L2_PIX_FMT_SGRBG10DPCM8)
+			ispccdc_config_datapath(CCDC_RAW, CCDC_OTHERS_VP_MEM);
+		else
+			ispccdc_config_datapath(CCDC_YUV_SYNC,
+							CCDC_OTHERS_MEM);
+	}
+	return 0;
+}
+
+/**
+ * isp_config_pipeline - Configures the image size and ycpos for ISP submodules
+ * @pix_input: Pointer to V4L2 pixel format structure for input image.
+ * @pix_output: Pointer to V4L2 pixel format structure for output image.
+ *
+ * The configuration of ycpos depends on the output pixel format for both the
+ * Preview and Resizer submodules.
+ **/
+static void isp_config_pipeline(struct v4l2_pix_format *pix_input,
+				struct v4l2_pix_format *pix_output)
+{
+	ispccdc_config_size(isp_obj.module.ccdc_input_width,
+			isp_obj.module.ccdc_input_height,
+			isp_obj.module.ccdc_output_width,
+			isp_obj.module.ccdc_output_height);
+
+	if (isp_obj.module.isp_pipeline & OMAP_ISP_PREVIEW) {
+		isppreview_config_size(isp_obj.module.preview_input_width,
+			isp_obj.module.preview_input_height,
+			isp_obj.module.preview_output_width,
+			isp_obj.module.preview_output_height);
+	}
+
+	if (isp_obj.module.isp_pipeline & OMAP_ISP_RESIZER) {
+		ispresizer_config_size(isp_obj.module.resizer_input_width,
+					isp_obj.module.resizer_input_height,
+					isp_obj.module.resizer_output_width,
+					isp_obj.module.resizer_output_height);
+	}
+
+	if (pix_output->pixelformat == V4L2_PIX_FMT_UYVY) {
+		isppreview_config_ycpos(YCPOS_YCrYCb);
+		if (is_ispresizer_enabled())
+			ispresizer_config_ycpos(0);
+	} else {
+		isppreview_config_ycpos(YCPOS_CrYCbY);
+		if (is_ispresizer_enabled())
+			ispresizer_config_ycpos(1);
+	}
+
+	return;
+}
+
+static void isp_buf_init(void)
+{
+	struct isp_bufs *bufs = &isp_obj.bufs;
+	int sg;
+
+	bufs->queue = 0;
+	bufs->done = 0;
+	bufs->wait_hs_vs = isp_obj.config->wait_hs_vs;
+	for (sg = 0; sg < NUM_BUFS; sg++) {
+		bufs->buf[sg].complete = NULL;
+		bufs->buf[sg].vb = NULL;
+		bufs->buf[sg].priv = NULL;
+	}
+}
+
+/**
+ * isp_vbq_sync - Walks the pages table and flushes the cache for
+ *                each page.
+ **/
+static int isp_vbq_sync(struct videobuf_buffer *vb, int when)
+{
+	flush_cache_all();
+
+	return 0;
+}
+
+static int isp_buf_process(struct isp_bufs *bufs)
+{
+	struct isp_buf *buf = NULL;
+	unsigned long flags;
+	int last;
+
+	spin_lock_irqsave(&bufs->lock, flags);
+
+	if (ISP_BUFS_IS_EMPTY(bufs))
+		goto out;
+
+	if (RAW_CAPTURE(&isp_obj) && ispccdc_sbl_wait_idle(1000)) {
+		printk(KERN_ERR "ccdc %d won't become idle!\n",
+		       RAW_CAPTURE(&isp_obj));
+		goto out;
+	}
+
+	/* We had at least one buffer in queue. */
+	buf = ISP_BUF_DONE(bufs);
+	last = ISP_BUFS_IS_LAST(bufs);
+
+	if (!last) {
+		/* Set new buffer address. */
+		isp_set_buf(ISP_BUF_NEXT_DONE(bufs));
+	} else {
+		/* Tell ISP not to write any of our buffers. */
+		isp_disable_interrupts();
+		if (RAW_CAPTURE(&isp_obj))
+			ispccdc_enable(0);
+		else
+			ispresizer_enable(0);
+		/*
+		 * We must wait for the HS_VS since before that the
+		 * CCDC may trigger interrupts even if it's not
+		 * receiving a frame.
+		 */
+		bufs->wait_hs_vs = isp_obj.config->wait_hs_vs;
+	}
+	if ((RAW_CAPTURE(&isp_obj) && ispccdc_busy())
+	    || (!RAW_CAPTURE(&isp_obj) && ispresizer_busy())) {
+		/*
+		 * Next buffer available: for the transfer to succeed, the
+		 * CCDC (RAW capture) or resizer (YUV capture) must be idle
+		 * for the duration of transfer setup. Bad things happen
+		 * otherwise!
+		 *
+		 * Next buffer not available: if we fail to stop the
+		 * ISP the buffer is probably going to be bad.
+		 */
+		/* Mark this buffer faulty. */
+		buf->vb_state = VIDEOBUF_ERROR;
+		/* Mark next faulty, too, in case we have one. */
+		if (!last) {
+			ISP_BUF_NEXT_DONE(bufs)->vb_state =
+				VIDEOBUF_ERROR;
+			printk(KERN_ALERT "OUCH!!!\n");
+		} else {
+			printk(KERN_ALERT "Ouch!\n");
+		}
+	}
+
+	/* Mark the current buffer as done. */
+	ISP_BUF_MARK_DONE(bufs);
+
+	DPRINTK_ISPCTRL(KERN_ALERT "%s: finish %d mmu %p\n", __func__,
+	       (bufs->done - 1 + NUM_BUFS) % NUM_BUFS,
+	       (bufs->buf+((bufs->done - 1 + NUM_BUFS) % NUM_BUFS))->isp_addr);
+
+out:
+	spin_unlock_irqrestore(&bufs->lock, flags);
+
+	if (buf != NULL) {
+		/*
+		 * We want to dequeue a buffer from the video buffer
+		 * queue. Let's do it!
+		 */
+		isp_vbq_sync(buf->vb, DMA_FROM_DEVICE);
+		buf->vb->state = buf->vb_state;
+		buf->complete(buf->vb, buf->priv);
+	}
+
+	return 0;
+}
+
+int isp_buf_queue(struct videobuf_buffer *vb,
+		  void (*complete)(struct videobuf_buffer *vb, void *priv),
+		  void *priv)
+{
+	unsigned long flags;
+	struct isp_buf *buf;
+	struct videobuf_dmabuf *dma = videobuf_to_dma(vb);
+	const struct scatterlist *sglist = dma->sglist;
+	struct isp_bufs *bufs = &isp_obj.bufs;
+	int sglen = dma->sglen;
+
+	BUG_ON(sglen < 0 || !sglist);
+
+	isp_vbq_sync(vb, DMA_TO_DEVICE);
+
+	spin_lock_irqsave(&bufs->lock, flags);
+
+	BUG_ON(ISP_BUFS_IS_FULL(bufs));
+
+	buf = ISP_BUF_QUEUE(bufs);
+
+	buf->isp_addr = bufs->isp_addr_capture[vb->i];
+	buf->complete = complete;
+	buf->vb = vb;
+	buf->priv = priv;
+	buf->vb_state = VIDEOBUF_DONE;
+
+	if (ISP_BUFS_IS_EMPTY(bufs)) {
+		isp_enable_interrupts(RAW_CAPTURE(&isp_obj));
+		isp_set_buf(buf);
+		ispccdc_enable(1);
+		isp_start();
+	}
+
+	ISP_BUF_MARK_QUEUED(bufs);
+
+	spin_unlock_irqrestore(&bufs->lock, flags);
+
+	DPRINTK_ISPCTRL(KERN_ALERT "%s: queue %d vb %d, mmu %p\n", __func__,
+	       (bufs->queue - 1 + NUM_BUFS) % NUM_BUFS, vb->i,
+	       buf->isp_addr);
+
+	return 0;
+}
+EXPORT_SYMBOL(isp_buf_queue);
+
+int isp_vbq_setup(struct videobuf_queue *vbq, unsigned int *cnt,
+		  unsigned int *size)
+{
+	int rval = 0;
+	size_t tmp_size = PAGE_ALIGN(isp_obj.module.preview_output_width
+				     * isp_obj.module.preview_output_height
+				     * ISP_BYTES_PER_PIXEL);
+
+	if (isp_obj.module.isp_pipeline & OMAP_ISP_PREVIEW
+	    && isp_obj.tmp_buf_size < tmp_size)
+		rval = isp_tmp_buf_alloc(tmp_size);
+
+	return rval;
+}
+EXPORT_SYMBOL(isp_vbq_setup);
+
+/**
+ * isp_vbq_prepare - Videobuffer queue prepare.
+ * @vbq: Pointer to videobuf_queue structure.
+ * @vb: Pointer to videobuf_buffer structure.
+ * @field: Requested Field order for the videobuffer.
+ *
+ * Returns 0 if successful, or -EIO if the ispmmu was unable to map a
+ * scatter-gather linked list data space.
+ **/
+int isp_vbq_prepare(struct videobuf_queue *vbq, struct videobuf_buffer *vb,
+							enum v4l2_field field)
+{
+	unsigned int isp_addr;
+	struct videobuf_dmabuf *vdma;
+	struct isp_bufs *bufs = &isp_obj.bufs;
+
+	int err = 0;
+
+	vdma = videobuf_to_dma(vb);
+
+	isp_addr = ispmmu_vmap(vdma->sglist, vdma->sglen);
+
+	if (IS_ERR_VALUE(isp_addr))
+		err = -EIO;
+	else
+		bufs->isp_addr_capture[vb->i] = isp_addr;
+
+	return err;
+}
+EXPORT_SYMBOL(isp_vbq_prepare);
+
+/**
+ * isp_vbq_release - Videobuffer queue release.
+ * @vbq: Pointer to videobuf_queue structure.
+ * @vb: Pointer to videobuf_buffer structure.
+ **/
+void isp_vbq_release(struct videobuf_queue *vbq, struct videobuf_buffer *vb)
+{
+	struct isp_bufs *bufs = &isp_obj.bufs;
+
+	ispmmu_vunmap(bufs->isp_addr_capture[vb->i]);
+	bufs->isp_addr_capture[vb->i] = (dma_addr_t)NULL;
+	return;
+}
+EXPORT_SYMBOL(isp_vbq_release);
+
+/**
+ * isp_queryctrl - Query V4L2 control from existing controls in ISP.
+ * @a: Pointer to v4l2_queryctrl structure. It only needs the id field filled.
+ *
+ * Returns 0 if successful, or -EINVAL if not found in ISP.
+ **/
+int isp_queryctrl(struct v4l2_queryctrl *a)
+{
+	int i;
+
+	if (a->id & V4L2_CTRL_FLAG_NEXT_CTRL) {
+		a->id &= ~V4L2_CTRL_FLAG_NEXT_CTRL;
+		i = find_next_vctrl(a->id);
+	} else {
+		i = find_vctrl(a->id);
+	}
+
+	if (i < 0)
+		return -EINVAL;
+
+	*a = video_control[i].qc;
+	return 0;
+}
+EXPORT_SYMBOL(isp_queryctrl);
+
+/**
+ * isp_queryctrl - Query V4L2 control from existing controls in ISP.
+ * @a: Pointer to v4l2_queryctrl structure. It only needs the id field filled.
+ *
+ * Returns 0 if successful, or -EINVAL if not found in ISP.
+ **/
+int isp_querymenu(struct v4l2_querymenu *a)
+{
+	int i;
+
+	i = find_vmenu(a->id, a->index);
+
+	if (i < 0)
+		return -EINVAL;
+
+	*a = video_menu[i];
+	return 0;
+}
+EXPORT_SYMBOL(isp_querymenu);
+
+/**
+ * isp_g_ctrl - Gets value of the desired V4L2 control.
+ * @a: V4L2 control to read actual value from.
+ *
+ * Return 0 if successful, or -EINVAL if chosen control is not found.
+ **/
+int isp_g_ctrl(struct v4l2_control *a)
+{
+	u8 current_value;
+	int rval = 0;
+
+	if (!isp_obj.ref_count)
+		return -EINVAL;
+
+	switch (a->id) {
+	case V4L2_CID_BRIGHTNESS:
+		isppreview_query_brightness(&current_value);
+		a->value = current_value / ISPPRV_BRIGHT_UNITS;
+		break;
+	case V4L2_CID_CONTRAST:
+		isppreview_query_contrast(&current_value);
+		a->value = current_value / ISPPRV_CONTRAST_UNITS;
+		break;
+	case V4L2_CID_COLORFX:
+		isppreview_get_color(&current_value);
+		a->value = current_value;
+		break;
+	default:
+		rval = -EINVAL;
+		break;
+	}
+
+	return rval;
+}
+EXPORT_SYMBOL(isp_g_ctrl);
+
+/**
+ * isp_s_ctrl - Sets value of the desired V4L2 control.
+ * @a: V4L2 control to read actual value from.
+ *
+ * Return 0 if successful, -EINVAL if chosen control is not found or value
+ * is out of bounds, -EFAULT if copy_from_user or copy_to_user operation fails
+ * from camera abstraction layer related controls or the transfered user space
+ * pointer via the value field is not set properly.
+ **/
+int isp_s_ctrl(struct v4l2_control *a)
+{
+	int rval = 0;
+	u8 new_value = a->value;
+
+	if (!isp_obj.ref_count)
+		return -EINVAL;
+
+	switch (a->id) {
+	case V4L2_CID_BRIGHTNESS:
+		if (new_value > ISPPRV_BRIGHT_HIGH)
+			rval = -EINVAL;
+		else
+			isppreview_update_brightness(&new_value);
+		break;
+	case V4L2_CID_CONTRAST:
+		if (new_value > ISPPRV_CONTRAST_HIGH)
+			rval = -EINVAL;
+		else
+			isppreview_update_contrast(&new_value);
+		break;
+	case V4L2_CID_COLORFX:
+		if (new_value > V4L2_COLORFX_SEPIA)
+			rval = -EINVAL;
+		else
+			isppreview_set_color(&new_value);
+		break;
+	default:
+		rval = -EINVAL;
+		break;
+	}
+
+	return rval;
+}
+EXPORT_SYMBOL(isp_s_ctrl);
+
+/**
+ * isp_handle_private - Handle all private ioctls for isp module.
+ * @cmd: ioctl cmd value
+ * @arg: ioctl arg value
+ *
+ * Return 0 if successful, -EINVAL if chosen cmd value is not handled or value
+ * is out of bounds, -EFAULT if ioctl arg value is not valid.
+ * Function simply routes the input ioctl cmd id to the appropriate handler in
+ * the isp module.
+ **/
+int isp_handle_private(int cmd, void *arg)
+{
+	int rval = 0;
+
+	if (!isp_obj.ref_count)
+		return -EINVAL;
+
+	switch (cmd) {
+	case VIDIOC_PRIVATE_ISP_CCDC_CFG:
+		rval = omap34xx_isp_ccdc_config(arg);
+		break;
+	case VIDIOC_PRIVATE_ISP_PRV_CFG:
+		rval = omap34xx_isp_preview_config(arg);
+		break;
+	case VIDIOC_PRIVATE_ISP_AEWB_CFG: {
+		struct isph3a_aewb_config *params;
+		params = (struct isph3a_aewb_config *)arg;
+		rval = isph3a_aewb_configure(params);
+		}
+		break;
+	case VIDIOC_PRIVATE_ISP_AEWB_REQ: {
+		struct isph3a_aewb_data *data;
+		data = (struct isph3a_aewb_data *)arg;
+		rval = isph3a_aewb_request_statistics(data);
+		}
+		break;
+	case VIDIOC_PRIVATE_ISP_HIST_CFG: {
+		struct isp_hist_config *params;
+		params = (struct isp_hist_config *)arg;
+		rval = isp_hist_configure(params);
+		}
+		break;
+	case VIDIOC_PRIVATE_ISP_HIST_REQ: {
+		struct isp_hist_data *data;
+		data = (struct isp_hist_data *)arg;
+		rval = isp_hist_request_statistics(data);
+		}
+		break;
+	case VIDIOC_PRIVATE_ISP_AF_CFG: {
+		struct af_configuration *params;
+		params = (struct af_configuration *)arg;
+		rval = isp_af_configure(params);
+		}
+		break;
+	case VIDIOC_PRIVATE_ISP_AF_REQ: {
+		struct isp_af_data *data;
+		data = (struct isp_af_data *)arg;
+		rval = isp_af_request_statistics(data);
+		}
+		break;
+	default:
+		rval = -EINVAL;
+		break;
+	}
+	return rval;
+}
+EXPORT_SYMBOL(isp_handle_private);
+
+/**
+ * isp_enum_fmt_cap - Gets more information of chosen format index and type
+ * @f: Pointer to structure containing index and type of format to read from.
+ *
+ * Returns 0 if successful, or -EINVAL if format index or format type is
+ * invalid.
+ **/
+int isp_enum_fmt_cap(struct v4l2_fmtdesc *f)
+{
+	int index = f->index;
+	enum v4l2_buf_type type = f->type;
+	int rval = -EINVAL;
+
+	if (index >= NUM_ISP_CAPTURE_FORMATS)
+		goto err;
+
+	memset(f, 0, sizeof(*f));
+	f->index = index;
+	f->type = type;
+
+	switch (f->type) {
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+		rval = 0;
+		break;
+	default:
+		goto err;
+	}
+
+	f->flags = isp_formats[index].flags;
+	strncpy(f->description, isp_formats[index].description,
+						sizeof(f->description));
+	f->pixelformat = isp_formats[index].pixelformat;
+err:
+	return rval;
+}
+EXPORT_SYMBOL(isp_enum_fmt_cap);
+
+/**
+ * isp_g_fmt_cap - Gets current output image format.
+ * @f: Pointer to V4L2 format structure to be filled with current output format
+ **/
+void isp_g_fmt_cap(struct v4l2_pix_format *pix)
+{
+	*pix = isp_obj.module.pix;
+	return;
+}
+EXPORT_SYMBOL(isp_g_fmt_cap);
+
+/**
+ * isp_s_fmt_cap - Sets I/O formats and crop and configures pipeline in ISP
+ * @f: Pointer to V4L2 format structure to be filled with current output format
+ *
+ * Returns 0 if successful, or return value of either isp_try_size or
+ * isp_try_fmt if there is an error.
+ **/
+int isp_s_fmt_cap(struct v4l2_pix_format *pix_input,
+					struct v4l2_pix_format *pix_output)
+{
+	int crop_scaling_w = 0, crop_scaling_h = 0;
+	int rval = 0;
+
+	if (!isp_obj.ref_count)
+		return -EINVAL;
+
+	rval = isp_calc_pipeline(pix_input, pix_output);
+	if (rval)
+		goto out;
+
+	rval = isp_try_size(pix_input, pix_output);
+	if (rval)
+		goto out;
+
+	rval = isp_try_fmt(pix_input, pix_output);
+	if (rval)
+		goto out;
+
+	if (ispcroprect.width != pix_output->width) {
+		crop_scaling_w = 1;
+		ispcroprect.left = 0;
+		ispcroprect.width = pix_output->width;
+	}
+
+	if (ispcroprect.height != pix_output->height) {
+		crop_scaling_h = 1;
+		ispcroprect.top = 0;
+		ispcroprect.height = pix_output->height;
+	}
+
+	isp_config_pipeline(pix_input, pix_output);
+
+	if ((isp_obj.module.isp_pipeline & OMAP_ISP_RESIZER) &&
+	    (crop_scaling_h || crop_scaling_w))
+		isp_config_crop(pix_output);
+
+out:
+	return rval;
+}
+EXPORT_SYMBOL(isp_s_fmt_cap);
+
+/**
+ * isp_config_crop - Configures crop parameters in isp resizer.
+ * @croppix: Pointer to V4L2 pixel format structure containing crop parameters
+ **/
+void isp_config_crop(struct v4l2_pix_format *croppix)
+{
+	u8 crop_scaling_w;
+	u8 crop_scaling_h;
+	unsigned long org_left, num_pix, new_top;
+
+	struct v4l2_pix_format *pix = croppix;
+
+	crop_scaling_w = (isp_obj.module.preview_output_width * 10) /
+								pix->width;
+	crop_scaling_h = (isp_obj.module.preview_output_height * 10) /
+								pix->height;
+
+	cur_rect.left = (ispcroprect.left * crop_scaling_w) / 10;
+	cur_rect.top = (ispcroprect.top * crop_scaling_h) / 10;
+	cur_rect.width = (ispcroprect.width * crop_scaling_w) / 10;
+	cur_rect.height = (ispcroprect.height * crop_scaling_h) / 10;
+
+	org_left = cur_rect.left;
+	while (((int)cur_rect.left & 0xFFFFFFF0) != (int)cur_rect.left)
+		(int)cur_rect.left--;
+
+	num_pix = org_left - cur_rect.left;
+	new_top = (int)(num_pix * 3) / 4;
+	cur_rect.top = cur_rect.top - new_top;
+	cur_rect.height = (2 * new_top) + cur_rect.height;
+
+	cur_rect.width = cur_rect.width + (2 * num_pix);
+	while (((int)cur_rect.width & 0xFFFFFFF0) != (int)cur_rect.width)
+		(int)cur_rect.width--;
+
+	isp_obj.tmp_buf_offset = ((cur_rect.left * 2) +
+		((isp_obj.module.preview_output_width) * 2 * cur_rect.top));
+
+	ispresizer_trycrop(cur_rect.left, cur_rect.top, cur_rect.width,
+					cur_rect.height,
+					isp_obj.module.resizer_output_width,
+					isp_obj.module.resizer_output_height);
+
+	return;
+}
+EXPORT_SYMBOL(isp_config_crop);
+
+/**
+ * isp_g_crop - Gets crop rectangle size and position.
+ * @a: Pointer to V4L2 crop structure to be filled.
+ *
+ * Always returns 0.
+ **/
+int isp_g_crop(struct v4l2_crop *a)
+{
+	struct v4l2_crop *crop = a;
+
+	crop->c = ispcroprect;
+	return 0;
+}
+EXPORT_SYMBOL(isp_g_crop);
+
+/**
+ * isp_s_crop - Sets crop rectangle size and position and queues crop operation
+ * @a: Pointer to V4L2 crop structure with desired parameters.
+ * @pix: Pointer to V4L2 pixel format structure with desired parameters.
+ *
+ * Returns 0 if successful, or -EINVAL if crop parameters are out of bounds.
+ **/
+int isp_s_crop(struct v4l2_crop *a, struct v4l2_pix_format *pix)
+{
+	struct v4l2_crop *crop = a;
+	int rval = 0;
+
+	if (!isp_obj.ref_count)
+		return -EINVAL;
+
+	if (crop->c.left < 0)
+		crop->c.left = 0;
+	if (crop->c.width < 0)
+		crop->c.width = 0;
+	if (crop->c.top < 0)
+		crop->c.top = 0;
+	if (crop->c.height < 0)
+		crop->c.height = 0;
+
+	if (crop->c.left >= pix->width)
+		crop->c.left = pix->width - 1;
+	if (crop->c.top >= pix->height)
+		crop->c.top = pix->height - 1;
+
+	if (crop->c.left + crop->c.width > pix->width)
+		crop->c.width = pix->width - crop->c.left;
+	if (crop->c.top + crop->c.height > pix->height)
+		crop->c.height = pix->height - crop->c.top;
+
+	ispcroprect.left = crop->c.left;
+	ispcroprect.top = crop->c.top;
+	ispcroprect.width = crop->c.width;
+	ispcroprect.height = crop->c.height;
+
+	isp_config_crop(pix);
+
+	isp_obj.module.applyCrop = 1;
+
+	return rval;
+}
+EXPORT_SYMBOL(isp_s_crop);
+
+/**
+ * isp_try_fmt_cap - Tries desired input/output image formats
+ * @pix_input: Pointer to V4L2 pixel format structure for input image.
+ * @pix_output: Pointer to V4L2 pixel format structure for output image.
+ *
+ * Returns 0 if successful, or return value of either isp_try_size or
+ * isp_try_fmt if there is an error.
+ **/
+int isp_try_fmt_cap(struct v4l2_pix_format *pix_input,
+					struct v4l2_pix_format *pix_output)
+{
+	int rval = 0;
+
+	rval = isp_calc_pipeline(pix_input, pix_output);
+	if (rval)
+		goto out;
+
+	rval = isp_try_size(pix_input, pix_output);
+	if (rval)
+		goto out;
+
+	rval = isp_try_fmt(pix_input, pix_output);
+	if (rval)
+		goto out;
+
+out:
+	return rval;
+}
+EXPORT_SYMBOL(isp_try_fmt_cap);
+
+/**
+ * isp_try_size - Tries size configuration for I/O images of each ISP submodule
+ * @pix_input: Pointer to V4L2 pixel format structure for input image.
+ * @pix_output: Pointer to V4L2 pixel format structure for output image.
+ *
+ * Returns 0 if successful, or return value of ispccdc_try_size,
+ * isppreview_try_size, or ispresizer_try_size (depending on the pipeline
+ * configuration) if there is an error.
+ **/
+static int isp_try_size(struct v4l2_pix_format *pix_input,
+			struct v4l2_pix_format *pix_output)
+{
+	int rval = 0;
+
+	if ((pix_output->width <= ISPRSZ_MIN_OUTPUT) ||
+				(pix_output->height <= ISPRSZ_MIN_OUTPUT))
+		return -EINVAL;
+
+	if ((pix_output->width >= ISPRSZ_MAX_OUTPUT) ||
+				(pix_output->height > ISPRSZ_MAX_OUTPUT))
+		return -EINVAL;
+
+	isp_obj.module.ccdc_input_width = pix_input->width;
+	isp_obj.module.ccdc_input_height = pix_input->height;
+	isp_obj.module.resizer_output_width = pix_output->width;
+	isp_obj.module.resizer_output_height = pix_output->height;
+
+	if (isp_obj.module.isp_pipeline & OMAP_ISP_CCDC) {
+		rval = ispccdc_try_size(isp_obj.module.ccdc_input_width,
+					isp_obj.module.ccdc_input_height,
+					&isp_obj.module.ccdc_output_width,
+					&isp_obj.module.ccdc_output_height);
+		if (rval) {
+			printk(KERN_ERR "ISP_ERR: The dimensions %dx%d are not"
+					" supported\n", pix_input->width,
+					pix_input->height);
+			return rval;
+		}
+		pix_output->width = isp_obj.module.ccdc_output_width;
+		pix_output->height = isp_obj.module.ccdc_output_height;
+	}
+
+	if (isp_obj.module.isp_pipeline & OMAP_ISP_PREVIEW) {
+		isp_obj.module.preview_input_width =
+					isp_obj.module.ccdc_output_width;
+		isp_obj.module.preview_input_height =
+					isp_obj.module.ccdc_output_height;
+		rval = isppreview_try_size(isp_obj.module.preview_input_width,
+					isp_obj.module.preview_input_height,
+					&isp_obj.module.preview_output_width,
+					&isp_obj.module.preview_output_height);
+		if (rval) {
+			printk(KERN_ERR "ISP_ERR: The dimensions %dx%d are not"
+					" supported\n", pix_input->width,
+					pix_input->height);
+			return rval;
+		}
+		pix_output->width = isp_obj.module.preview_output_width;
+		pix_output->height = isp_obj.module.preview_output_height;
+	}
+
+	if (isp_obj.module.isp_pipeline & OMAP_ISP_RESIZER) {
+		isp_obj.module.resizer_input_width =
+					isp_obj.module.preview_output_width;
+		isp_obj.module.resizer_input_height =
+					isp_obj.module.preview_output_height;
+		rval = ispresizer_try_size(&isp_obj.module.resizer_input_width,
+					&isp_obj.module.resizer_input_height,
+					&isp_obj.module.resizer_output_width,
+					&isp_obj.module.resizer_output_height);
+		if (rval) {
+			printk(KERN_ERR "ISP_ERR: The dimensions %dx%d are not"
+					" supported\n", pix_input->width,
+					pix_input->height);
+			return rval;
+		}
+		pix_output->width = isp_obj.module.resizer_output_width;
+		pix_output->height = isp_obj.module.resizer_output_height;
+	}
+
+	return rval;
+}
+
+/**
+ * isp_try_fmt - Validates input/output format parameters.
+ * @pix_input: Pointer to V4L2 pixel format structure for input image.
+ * @pix_output: Pointer to V4L2 pixel format structure for output image.
+ *
+ * Always returns 0.
+ **/
+int isp_try_fmt(struct v4l2_pix_format *pix_input,
+					struct v4l2_pix_format *pix_output)
+{
+	int ifmt;
+
+	for (ifmt = 0; ifmt < NUM_ISP_CAPTURE_FORMATS; ifmt++) {
+		if (pix_output->pixelformat == isp_formats[ifmt].pixelformat)
+			break;
+	}
+	if (ifmt == NUM_ISP_CAPTURE_FORMATS)
+		ifmt = 1;
+	pix_output->pixelformat = isp_formats[ifmt].pixelformat;
+	pix_output->field = V4L2_FIELD_NONE;
+	pix_output->bytesperline = pix_output->width * ISP_BYTES_PER_PIXEL;
+	pix_output->sizeimage =
+		PAGE_ALIGN(pix_output->bytesperline * pix_output->height);
+	pix_output->priv = 0;
+	switch (pix_output->pixelformat) {
+	case V4L2_PIX_FMT_YUYV:
+	case V4L2_PIX_FMT_UYVY:
+		pix_output->colorspace = V4L2_COLORSPACE_JPEG;
+		break;
+	default:
+		pix_output->colorspace = V4L2_COLORSPACE_SRGB;
+	}
+
+	isp_obj.module.pix.pixelformat = pix_output->pixelformat;
+	isp_obj.module.pix.width = pix_output->width;
+	isp_obj.module.pix.height = pix_output->height;
+	isp_obj.module.pix.field = pix_output->field;
+	isp_obj.module.pix.bytesperline = pix_output->bytesperline;
+	isp_obj.module.pix.sizeimage = pix_output->sizeimage;
+	isp_obj.module.pix.priv = pix_output->priv;
+	isp_obj.module.pix.colorspace = pix_output->colorspace;
+
+	return 0;
+}
+EXPORT_SYMBOL(isp_try_fmt);
+
+/**
+ * isp_save_ctx - Saves ISP, CCDC, HIST, H3A, PREV, RESZ & MMU context.
+ *
+ * Routine for saving the context of each module in the ISP.
+ * CCDC, HIST, H3A, PREV, RESZ and MMU.
+ **/
+static void isp_save_ctx(void)
+{
+	isp_save_context(isp_reg_list);
+	ispccdc_save_context();
+	ispmmu_save_context();
+	isphist_save_context();
+	isph3a_save_context();
+	isppreview_save_context();
+	ispresizer_save_context();
+}
+
+/**
+ * isp_restore_ctx - Restores ISP, CCDC, HIST, H3A, PREV, RESZ & MMU context.
+ *
+ * Routine for restoring the context of each module in the ISP.
+ * CCDC, HIST, H3A, PREV, RESZ and MMU.
+ **/
+static void isp_restore_ctx(void)
+{
+	isp_restore_context(isp_reg_list);
+	ispccdc_restore_context();
+	ispmmu_restore_context();
+	isphist_restore_context();
+	isph3a_restore_context();
+	isppreview_restore_context();
+	ispresizer_restore_context();
+}
+
+/**
+ * isp_get - Adquires the ISP resource.
+ *
+ * Initializes the clocks for the first acquire.
+ **/
+int isp_get(void)
+{
+	static int has_context = 0;
+	int ret_err = 0;
+
+	if (omap3isp == NULL)
+		return -EBUSY;
+
+	DPRINTK_ISPCTRL("isp_get: old %d\n", isp_obj.ref_count);
+	mutex_lock(&(isp_obj.isp_mutex));
+	if (isp_obj.ref_count == 0) {
+		ret_err = clk_enable(isp_obj.cam_ick);
+		if (ret_err) {
+			DPRINTK_ISPCTRL("ISP_ERR: clk_en for ick failed\n");
+			goto out_clk_enable_ick;
+		}
+		ret_err = clk_enable(isp_obj.cam_mclk);
+		if (ret_err) {
+			DPRINTK_ISPCTRL("ISP_ERR: clk_en for mclk failed\n");
+			goto out_clk_enable_mclk;
+		}
+		ret_err = clk_enable(isp_obj.csi2_fck);
+		if (ret_err) {
+			DPRINTK_ISPCTRL("ISP_ERR: clk_en for csi2_fclk"
+								" failed\n");
+			goto out_clk_enable_csi2_fclk;
+		}
+
+		/* We don't want to restore context before saving it! */
+		if (has_context)
+			isp_restore_ctx();
+		else
+			has_context = 1;
+	} else {
+		mutex_unlock(&isp_obj.isp_mutex);
+		return -EBUSY;
+	}
+	isp_obj.ref_count++;
+
+	mutex_unlock(&(isp_obj.isp_mutex));
+
+	DPRINTK_ISPCTRL("isp_get: new %d\n", isp_obj.ref_count);
+	return isp_obj.ref_count;
+
+out_clk_enable_csi2_fclk:
+	clk_disable(isp_obj.cam_mclk);
+out_clk_enable_mclk:
+	clk_disable(isp_obj.cam_ick);
+out_clk_enable_ick:
+
+	mutex_unlock(&(isp_obj.isp_mutex));
+
+	return ret_err;
+}
+EXPORT_SYMBOL(isp_get);
+
+/**
+ * isp_put - Releases the ISP resource.
+ *
+ * Releases the clocks also for the last release.
+ **/
+int isp_put(void)
+{
+	if (omap3isp == NULL)
+		return -EBUSY;
+
+	DPRINTK_ISPCTRL("isp_put: old %d\n", isp_obj.ref_count);
+	mutex_lock(&(isp_obj.isp_mutex));
+	if (isp_obj.ref_count) {
+		if (--isp_obj.ref_count == 0) {
+			isp_save_ctx();
+			isp_tmp_buf_free();
+			isp_release_resources();
+			isp_obj.module.isp_pipeline = 0;
+			clk_disable(isp_obj.cam_ick);
+			clk_disable(isp_obj.cam_mclk);
+			clk_disable(isp_obj.csi2_fck);
+			memset(&ispcroprect, 0, sizeof(ispcroprect));
+			memset(&cur_rect, 0, sizeof(cur_rect));
+		}
+	}
+	mutex_unlock(&(isp_obj.isp_mutex));
+	DPRINTK_ISPCTRL("isp_put: new %d\n", isp_obj.ref_count);
+	return isp_obj.ref_count;
+}
+EXPORT_SYMBOL(isp_put);
+
+/**
+ * isp_save_context - Saves the values of the ISP module registers.
+ * @reg_list: Structure containing pairs of register address and value to
+ *            modify on OMAP.
+ **/
+void isp_save_context(struct isp_reg *reg_list)
+{
+	struct isp_reg *next = reg_list;
+
+	for (; next->reg != ISP_TOK_TERM; next++)
+		next->val = isp_reg_readl(next->mmio_range, next->reg);
+}
+EXPORT_SYMBOL(isp_save_context);
+
+/**
+ * isp_restore_context - Restores the values of the ISP module registers.
+ * @reg_list: Structure containing pairs of register address and value to
+ *            modify on OMAP.
+ **/
+void isp_restore_context(struct isp_reg *reg_list)
+{
+	struct isp_reg *next = reg_list;
+
+	for (; next->reg != ISP_TOK_TERM; next++)
+		isp_reg_writel(next->val, next->mmio_range, next->reg);
+}
+EXPORT_SYMBOL(isp_restore_context);
+
+static int isp_remove(struct platform_device *pdev)
+{
+	struct isp_device *isp = platform_get_drvdata(pdev);
+	int i;
+
+	isp_csi2_cleanup();
+	isp_af_exit();
+	isp_resizer_cleanup();
+	isp_preview_cleanup();
+	ispmmu_cleanup();
+	isph3a_aewb_cleanup();
+	isp_hist_cleanup();
+	isp_ccdc_cleanup();
+
+	if (!isp)
+		return 0;
+
+	clk_put(isp_obj.cam_ick);
+	clk_put(isp_obj.cam_mclk);
+	clk_put(isp_obj.csi2_fck);
+
+	free_irq(isp->irq, &isp_obj);
+
+	for (i = 0; i <= OMAP3_ISP_IOMEM_CSI2PHY; i++) {
+		if (isp->mmio_base[i]) {
+			iounmap((void *)isp->mmio_base[i]);
+			isp->mmio_base[i] = 0;
+		}
+
+		if (isp->mmio_base_phys[i]) {
+			release_mem_region(isp->mmio_base_phys[i],
+						isp->mmio_size[i]);
+			isp->mmio_base_phys[i] = 0;
+		}
+	}
+
+	omap3isp = NULL;
+
+	kfree(isp);
+
+	return 0;
+}
+
+static int isp_probe(struct platform_device *pdev)
+{
+	struct isp_device *isp;
+	int ret_err = 0;
+	int i;
+
+	isp = kzalloc(sizeof(*isp), GFP_KERNEL);
+	if (!isp) {
+		dev_err(&pdev->dev, "could not allocate memory\n");
+		return -ENODEV;
+	}
+
+	platform_set_drvdata(pdev, isp);
+
+	isp->dev = &pdev->dev;
+
+	for (i = 0; i <= OMAP3_ISP_IOMEM_CSI2PHY; i++) {
+		struct resource *mem;
+		/* request the mem region for the camera registers */
+		mem = platform_get_resource(pdev, IORESOURCE_MEM, i);
+		if (!mem) {
+			dev_err(isp->dev, "no mem resource?\n");
+			return -ENODEV;
+		}
+
+		if (!request_mem_region(mem->start, (mem->end - mem->start) + 1,
+					pdev->name)) {
+			dev_err(isp->dev,
+				"cannot reserve camera register I/O region\n");
+			return -ENODEV;
+
+		}
+		isp->mmio_base_phys[i] = mem->start;
+		isp->mmio_size[i] = (mem->end - mem->start) + 1;
+
+		/* map the region */
+		isp->mmio_base[i] = (unsigned long)
+				ioremap_nocache(isp->mmio_base_phys[i],
+				isp->mmio_size[i]);
+		if (!isp->mmio_base[i]) {
+			dev_err(isp->dev,
+				"cannot map camera register I/O region\n");
+			return -ENODEV;
+		}
+	}
+
+	isp->irq = platform_get_irq(pdev, 0);
+	if (isp->irq <= 0) {
+		dev_err(isp->dev, "no irq for camera?\n");
+		return -ENODEV;
+	}
+
+	isp_obj.cam_ick = clk_get(&camera_dev, "cam_ick");
+	if (IS_ERR(isp_obj.cam_ick)) {
+		DPRINTK_ISPCTRL("ISP_ERR: clk_get for "
+				"cam_ick failed\n");
+		return PTR_ERR(isp_obj.cam_ick);
+	}
+	isp_obj.cam_mclk = clk_get(&camera_dev, "cam_mclk");
+	if (IS_ERR(isp_obj.cam_mclk)) {
+		DPRINTK_ISPCTRL("ISP_ERR: clk_get for "
+				"cam_mclk failed\n");
+		ret_err = PTR_ERR(isp_obj.cam_mclk);
+		goto out_clk_get_mclk;
+	}
+	isp_obj.csi2_fck = clk_get(&camera_dev, "csi2_96m_fck");
+	if (IS_ERR(isp_obj.csi2_fck)) {
+		DPRINTK_ISPCTRL("ISP_ERR: clk_get for csi2_fclk"
+				" failed\n");
+		ret_err = PTR_ERR(isp_obj.csi2_fck);
+		goto out_clk_get_csi2_fclk;
+	}
+
+	if (request_irq(isp->irq, omap34xx_isp_isr, IRQF_SHARED,
+				"Omap 3 Camera ISP", &isp_obj)) {
+		DPRINTK_ISPCTRL("Could not install ISR\n");
+		ret_err = -EINVAL;
+		goto out_request_irq;
+	}
+
+	isp_obj.ref_count = 0;
+
+	mutex_init(&(isp_obj.isp_mutex));
+	spin_lock_init(&isp_obj.lock);
+	spin_lock_init(&isp_obj.bufs.lock);
+
+	omap3isp = isp;
+
+	ret_err = ispmmu_init();
+	if (ret_err)
+		goto out_ispmmu_init;
+
+	isp_ccdc_init();
+	isp_hist_init();
+	isph3a_aewb_init();
+	isp_preview_init();
+	isp_resizer_init();
+	isp_af_init();
+	isp_csi2_init();
+
+	isp_get();
+	isp_power_settings(1);
+	isp_put();
+
+	isph3a_notify(1);
+	isp_af_notify(1);
+
+	return 0;
+
+out_ispmmu_init:
+	omap3isp = NULL;
+	free_irq(isp->irq, &isp_obj);
+out_request_irq:
+	clk_put(isp_obj.csi2_fck);
+out_clk_get_csi2_fclk:
+	clk_put(isp_obj.cam_mclk);
+out_clk_get_mclk:
+	clk_put(isp_obj.cam_ick);
+
+	return ret_err;
+}
+
+static struct platform_driver omap3isp_driver = {
+	.probe = isp_probe,
+	.remove = isp_remove,
+	.driver = {
+		   .name = "omap3isp",
+		   },
+};
+
+/**
+ * isp_init - ISP module initialization.
+ **/
+static int __init isp_init(void)
+{
+	return platform_driver_register(&omap3isp_driver);
+}
+
+/**
+ * isp_cleanup - ISP module cleanup.
+ **/
+static void __exit isp_cleanup(void)
+{
+	platform_driver_unregister(&omap3isp_driver);
+}
+
+/**
+ * isp_print_status - Prints the values of the ISP Control Module registers
+ *
+ * Also prints other debug information stored in the ISP module structure.
+ **/
+void isp_print_status(void)
+{
+	if (!is_ispctrl_debug_enabled())
+		return;
+
+	DPRINTK_ISPCTRL("###ISP_CTRL=0x%x\n",
+			isp_reg_readl(OMAP3_ISP_IOMEM_MAIN, ISP_CTRL));
+	DPRINTK_ISPCTRL("###ISP_TCTRL_CTRL=0x%x\n",
+			isp_reg_readl(OMAP3_ISP_IOMEM_MAIN, ISP_TCTRL_CTRL));
+	DPRINTK_ISPCTRL("###ISP_SYSCONFIG=0x%x\n",
+			isp_reg_readl(OMAP3_ISP_IOMEM_MAIN, ISP_SYSCONFIG));
+	DPRINTK_ISPCTRL("###ISP_SYSSTATUS=0x%x\n",
+			isp_reg_readl(OMAP3_ISP_IOMEM_MAIN, ISP_SYSSTATUS));
+	DPRINTK_ISPCTRL("###ISP_IRQ0ENABLE=0x%x\n",
+			isp_reg_readl(OMAP3_ISP_IOMEM_MAIN, ISP_IRQ0ENABLE));
+	DPRINTK_ISPCTRL("###ISP_IRQ0STATUS=0x%x\n",
+			isp_reg_readl(OMAP3_ISP_IOMEM_MAIN, ISP_IRQ0STATUS));
+}
+EXPORT_SYMBOL(isp_print_status);
+
+module_init(isp_init);
+module_exit(isp_cleanup);
+
+MODULE_AUTHOR("Texas Instruments");
+MODULE_DESCRIPTION("ISP Control Module Library");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/video/isp/isp.h b/drivers/media/video/isp/isp.h
new file mode 100644
index 0000000..bfbbc5f
--- /dev/null
+++ b/drivers/media/video/isp/isp.h
@@ -0,0 +1,318 @@
+/*
+ * isp.h
+ *
+ * Top level public header file for ISP Control module in
+ * TI's OMAP3 Camera ISP
+ *
+ * Copyright (C) 2009 Texas Instruments.
+ * Copyright (C) 2009 Nokia.
+ *
+ * Contributors:
+ * 	Sameer Venkatraman <sameerv@ti.com>
+ * 	Mohit Jalori <mjalori@ti.com>
+ * 	Sergio Aguirre <saaguirre@ti.com>
+ * 	Sakari Ailus <sakari.ailus@nokia.com>
+ * 	Tuukka Toivonen <tuukka.o.toivonen@nokia.com>
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ */
+
+#ifndef OMAP_ISP_TOP_H
+#define OMAP_ISP_TOP_H
+#include <mach/cpu.h>
+#include <media/videobuf-dma-sg.h>
+#include <linux/videodev2.h>
+#define OMAP_ISP_CCDC		(1 << 0)
+#define OMAP_ISP_PREVIEW	(1 << 1)
+#define OMAP_ISP_RESIZER	(1 << 2)
+#define OMAP_ISP_AEWB		(1 << 3)
+#define OMAP_ISP_AF		(1 << 4)
+#define OMAP_ISP_HIST		(1 << 5)
+
+#define ISP_TOK_TERM		0xFFFFFFFF	/*
+						 * terminating token for ISP
+						 * modules reg list
+						 */
+#define NUM_BUFS		VIDEO_MAX_FRAME
+
+#ifndef CONFIG_ARCH_OMAP3410
+#define USE_ISP_PREVIEW
+#define USE_ISP_RESZ
+#define is_isppreview_enabled()		1
+#define is_ispresizer_enabled()		1
+#else
+#define is_isppreview_enabled()		0
+#define is_ispresizer_enabled()		0
+#endif
+
+#define ISP_BYTES_PER_PIXEL		2
+#define NUM_ISP_CAPTURE_FORMATS 	(sizeof(isp_formats) /\
+							sizeof(isp_formats[0]))
+typedef int (*isp_vbq_callback_ptr) (struct videobuf_buffer *vb);
+typedef void (*isp_callback_t) (unsigned long status,
+					isp_vbq_callback_ptr arg1, void *arg2);
+
+enum isp_mem_resources {
+	OMAP3_ISP_IOMEM_MAIN,
+	OMAP3_ISP_IOMEM_CBUFF,
+	OMAP3_ISP_IOMEM_CCP2,
+	OMAP3_ISP_IOMEM_CCDC,
+	OMAP3_ISP_IOMEM_HIST,
+	OMAP3_ISP_IOMEM_H3A,
+	OMAP3_ISP_IOMEM_PREV,
+	OMAP3_ISP_IOMEM_RESZ,
+	OMAP3_ISP_IOMEM_SBL,
+	OMAP3_ISP_IOMEM_CSI2A,
+	OMAP3_ISP_IOMEM_CSI2PHY
+};
+
+struct isp_device {
+	struct device *dev;
+
+	/*** platform HW resources ***/
+	unsigned int irq;
+
+#define mmio_base_main mmio_base[OMAP3_ISP_IOMEM_MAIN]
+#define mmio_cbuff_main mmio_base[OMAP3_ISP_IOMEM_CBUFF]
+#define mmio_ccp2_main mmio_base[OMAP3_ISP_IOMEM_CCP2]
+#define mmio_ccdc_main mmio_base[OMAP3_ISP_IOMEM_CCDC]
+#define mmio_hist_main mmio_base[OMAP3_ISP_IOMEM_HIST]
+#define mmio_h3a_main mmio_base[OMAP3_ISP_IOMEM_H3A]
+#define mmio_prev_main mmio_base[OMAP3_ISP_IOMEM_PREV]
+#define mmio_resz_main mmio_base[OMAP3_ISP_IOMEM_RESZ]
+#define mmio_sbl_main mmio_base[OMAP3_ISP_IOMEM_SBL]
+#define mmio_csi2_main mmio_base[OMAP3_ISP_IOMEM_CSI2A]
+#define mmio_csi2phy_main mmio_base[OMAP3_ISP_IOMEM_CSI2PHY]
+	unsigned long mmio_base[OMAP3_ISP_IOMEM_CSI2PHY + 1];
+	unsigned long mmio_base_phys[OMAP3_ISP_IOMEM_CSI2PHY + 1];
+	unsigned long mmio_size[OMAP3_ISP_IOMEM_CSI2PHY + 1];
+};
+
+enum isp_interface_type {
+	ISP_PARLL = 1,
+	ISP_CSIA = 2,
+	ISP_CSIB = 4,
+	ISP_NONE = 8 /* memory input to preview / resizer */
+};
+
+enum isp_irqevents {
+	CSIA = 0x01,
+	CSIB = 0x10,
+	CCDC_VD0 = 0x100,
+	CCDC_VD1 = 0x200,
+	CCDC_VD2 = 0x400,
+	CCDC_ERR = 0x800,
+	H3A_AWB_DONE = 0x2000,
+	H3A_AF_DONE = 0x1000,
+	HIST_DONE = 0x10000,
+	PREV_DONE = 0x100000,
+	LSC_DONE = 0x20000,
+	LSC_PRE_COMP = 0x40000,
+	LSC_PRE_ERR = 0x80000,
+	RESZ_DONE = 0x1000000,
+	SBL_OVF = 0x2000000,
+	MMU_ERR = 0x10000000,
+	OCP_ERR = 0x20000000,
+	HS_VS = 0x80000000
+};
+
+enum isp_callback_type {
+	CBK_CCDC_VD0,
+	CBK_CCDC_VD1,
+	CBK_PREV_DONE,
+	CBK_RESZ_DONE,
+	CBK_MMU_ERR,
+	CBK_H3A_AWB_DONE,
+	CBK_HIST_DONE,
+	CBK_HS_VS,
+	CBK_LSC_ISR,
+	CBK_H3A_AF_DONE,
+	CBK_CATCHALL,
+	CBK_CSIA,
+	CBK_CSIB,
+	CBK_END,
+};
+
+/**
+ * struct isp_reg - Structure for ISP register values.
+ * @reg: 32-bit Register address.
+ * @val: 32-bit Register value.
+ */
+struct isp_reg {
+	enum isp_mem_resources mmio_range;
+	u32 reg;
+	u32 val;
+};
+
+/**
+ * struct isp_interface_config - ISP interface configuration.
+ * @ccdc_par_ser: ISP interface type. 0 - Parallel, 1 - CSIA, 2 - CSIB to CCDC.
+ * @par_bridge: CCDC Bridge input control. Parallel interface.
+ *                  0 - Disable, 1 - Enable, first byte->cam_d(bits 7 to 0)
+ *                  2 - Enable, first byte -> cam_d(bits 15 to 8)
+ * @par_clk_pol: Pixel clock polarity on the parallel interface.
+ *                    0 - Non Inverted, 1 - Inverted
+ * @dataline_shift: Data lane shifter.
+ *                      0 - No Shift, 1 - CAMEXT[13 to 2]->CAM[11 to 0]
+ *                      2 - CAMEXT[13 to 4]->CAM[9 to 0]
+ *                      3 - CAMEXT[13 to 6]->CAM[7 to 0]
+ * @hsvs_syncdetect: HS or VS synchronization signal detection.
+ *                       0 - HS Falling, 1 - HS rising
+ *                       2 - VS falling, 3 - VS rising
+ * @strobe: Strobe related parameter.
+ * @prestrobe: PreStrobe related parameter.
+ * @shutter: Shutter related parameter.
+ * @hskip: Horizontal Start Pixel performed in Preview module.
+ * @vskip: Vertical Start Line performed in Preview module.
+ * @wenlog: Store the value for the sensor specific wenlog field.
+ * @wait_hs_vs: Wait for this many hs_vs before anything else in the beginning.
+ */
+struct isp_interface_config {
+	enum isp_interface_type ccdc_par_ser;
+	u8 dataline_shift;
+	u32 hsvs_syncdetect;
+	int strobe;
+	int prestrobe;
+	int shutter;
+	u32 prev_sph;
+	u32 prev_slv;
+	u32 wenlog;
+	int wait_hs_vs;
+	union {
+		struct par {
+			unsigned par_bridge:2;
+			unsigned par_clk_pol:1;
+		} par;
+		struct csi {
+			unsigned crc:1;
+			unsigned mode:1;
+			unsigned edge:1;
+			unsigned signalling:1;
+			unsigned strobe_clock_inv:1;
+			unsigned vs_edge:1;
+			unsigned channel:3;
+			unsigned vpclk:2;	/* Video port output clock */
+			unsigned int data_start;
+			unsigned int data_size;
+			u32 format;		/* V4L2_PIX_FMT_* */
+		} csi;
+	} u;
+};
+
+u32 isp_reg_readl(enum isp_mem_resources isp_mmio_range, u32 reg_offset);
+
+void isp_reg_writel(u32 reg_value, enum isp_mem_resources isp_mmio_range,
+						u32 reg_offset);
+
+static inline void isp_reg_and(enum isp_mem_resources mmio_range, u32 reg,
+						u32 and_bits)
+{
+	u32 v = isp_reg_readl(mmio_range, reg);
+
+	isp_reg_writel(v & and_bits, mmio_range, reg);
+}
+
+static inline void isp_reg_or(enum isp_mem_resources mmio_range, u32 reg,
+						u32 or_bits)
+{
+	u32 v = isp_reg_readl(mmio_range, reg);
+
+	isp_reg_writel(v | or_bits, mmio_range, reg);
+}
+
+static inline void isp_reg_and_or(enum isp_mem_resources mmio_range, u32 reg,
+						u32 and_bits, u32 or_bits)
+{
+	u32 v = isp_reg_readl(mmio_range, reg);
+
+	isp_reg_writel((v & and_bits) | or_bits, mmio_range, reg);
+}
+
+void isp_start(void);
+
+void isp_stop(void);
+
+int isp_buf_queue(struct videobuf_buffer *vb,
+		  void (*complete)(struct videobuf_buffer *vb, void *priv),
+		  void *priv);
+
+int isp_vbq_setup(struct videobuf_queue *vbq, unsigned int *cnt,
+		  unsigned int *size);
+
+int isp_vbq_prepare(struct videobuf_queue *vbq, struct videobuf_buffer *vb,
+							enum v4l2_field field);
+
+void isp_vbq_release(struct videobuf_queue *vbq, struct videobuf_buffer *vb);
+
+int isp_set_callback(enum isp_callback_type type, isp_callback_t callback,
+					isp_vbq_callback_ptr arg1, void *arg2);
+
+int isp_unset_callback(enum isp_callback_type type);
+
+u32 isp_set_xclk(u32 xclk, u8 xclksel);
+
+int isp_configure_interface(struct isp_interface_config *config);
+
+int isp_get(void);
+
+int isp_put(void);
+
+int isp_queryctrl(struct v4l2_queryctrl *a);
+
+int isp_querymenu(struct v4l2_querymenu *a);
+
+int isp_g_ctrl(struct v4l2_control *a);
+
+int isp_s_ctrl(struct v4l2_control *a);
+
+int isp_enum_fmt_cap(struct v4l2_fmtdesc *f);
+
+int isp_try_fmt_cap(struct v4l2_pix_format *pix_input,
+					struct v4l2_pix_format *pix_output);
+
+void isp_g_fmt_cap(struct v4l2_pix_format *pix);
+
+int isp_s_fmt_cap(struct v4l2_pix_format *pix_input,
+					struct v4l2_pix_format *pix_output);
+
+int isp_g_crop(struct v4l2_crop *a);
+
+int isp_s_crop(struct v4l2_crop *a, struct v4l2_pix_format *pix);
+
+void isp_config_crop(struct v4l2_pix_format *pix);
+
+int isp_try_fmt(struct v4l2_pix_format *pix_input,
+					struct v4l2_pix_format *pix_output);
+
+int isp_handle_private(int cmd, void *arg);
+
+void isp_save_context(struct isp_reg *);
+
+void isp_restore_context(struct isp_reg *);
+
+void isp_print_status(void);
+
+int __init isp_ccdc_init(void);
+int __init isp_hist_init(void);
+int __init isph3a_aewb_init(void);
+int __init isp_preview_init(void);
+int __init isp_resizer_init(void);
+int __init isp_af_init(void);
+int __init isp_csi2_init(void);
+
+void isp_ccdc_cleanup(void);
+void isp_hist_cleanup(void);
+void isph3a_aewb_cleanup(void);
+void isp_preview_cleanup(void);
+void isp_hist_cleanup(void);
+void isp_resizer_cleanup(void);
+void isp_af_exit(void);
+void isp_csi2_cleanup(void);
+
+#endif	/* OMAP_ISP_TOP_H */
diff --git a/drivers/media/video/isp/ispreg.h b/drivers/media/video/isp/ispreg.h
new file mode 100644
index 0000000..e6ef8c4
--- /dev/null
+++ b/drivers/media/video/isp/ispreg.h
@@ -0,0 +1,1673 @@
+/*
+ * ispreg.h
+ *
+ * Header file for all the ISP module in TI's OMAP3 Camera ISP.
+ * It has the OMAP HW register definitions.
+ *
+ * Copyright (C) 2009 Texas Instruments.
+ * Copyright (C) 2009 Nokia.
+ *
+ * Contributors:
+ * 	Tuukka Toivonen <tuukka.o.toivonen@nokia.com>
+ *	Thara Gopinath <thara@ti.com>
+ *	Sergio Aguirre <saaguirre@ti.com>
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ */
+
+#ifndef __ISPREG_H__
+#define __ISPREG_H__
+
+#include <mach/omap34xx.h>
+
+/* Note: Uncomment below defines as needed for enabling module specific debug
+ * messages
+ */
+
+/*
+#define OMAP_ISPCTRL_DEBUG
+#define OMAP_ISPCCDC_DEBUG
+#define OMAP_ISPPREV_DEBUG
+#define OMAP_ISPRESZ_DEBUG
+#define OMAP_ISPMMU_DEBUG
+#define OMAP_ISPH3A_DEBUG
+#define OMAP_ISP_AF_DEBUG
+#define OMAP_ISPHIST_DEBUG
+*/
+
+#ifdef OMAP_ISPCTRL_DEBUG
+#define DPRINTK_ISPCTRL(format, ...)\
+	printk(KERN_INFO "ISPCTRL: " format, ## __VA_ARGS__)
+#define is_ispctrl_debug_enabled()		1
+#else
+#define DPRINTK_ISPCTRL(format, ...)
+#define is_ispctrl_debug_enabled()		0
+#endif
+
+#ifdef OMAP_ISPCCDC_DEBUG
+#define DPRINTK_ISPCCDC(format, ...)\
+	printk(KERN_INFO "ISPCCDC: " format, ## __VA_ARGS__)
+#define is_ispccdc_debug_enabled()		1
+#else
+#define DPRINTK_ISPCCDC(format, ...)
+#define is_ispccdc_debug_enabled()		0
+#endif
+
+#ifdef OMAP_ISPPREV_DEBUG
+#define DPRINTK_ISPPREV(format, ...)\
+	printk(KERN_INFO "ISPPREV: " format, ## __VA_ARGS__)
+#define is_ispprev_debug_enabled()		1
+#else
+#define DPRINTK_ISPPREV(format, ...)
+#define is_ispprev_debug_enabled()		0
+#endif
+
+#ifdef OMAP_ISPRESZ_DEBUG
+#define DPRINTK_ISPRESZ(format, ...)\
+	printk(KERN_INFO "ISPRESZ: " format, ## __VA_ARGS__)
+#define is_ispresz_debug_enabled()		1
+#else
+#define DPRINTK_ISPRESZ(format, ...)
+#define is_ispresz_debug_enabled()		0
+#endif
+
+#ifdef OMAP_ISPMMU_DEBUG
+#define DPRINTK_ISPMMU(format, ...)\
+	printk(KERN_INFO "ISPMMU: " format, ## __VA_ARGS__)
+#define is_ispmmu_debug_enabled()		1
+#else
+#define DPRINTK_ISPMMU(format, ...)
+#define is_ispmmu_debug_enabled()		0
+#endif
+
+#ifdef OMAP_ISPH3A_DEBUG
+#define DPRINTK_ISPH3A(format, ...)\
+	printk(KERN_INFO "ISPH3A: " format, ## __VA_ARGS__)
+#define is_isph3a_debug_enabled()		1
+#else
+#define DPRINTK_ISPH3A(format, ...)
+#define is_isph3a_debug_enabled()		0
+#endif
+
+#ifdef OMAP_ISP_AF_DEBUG
+#define DPRINTK_ISP_AF(format, ...)\
+	printk(KERN_INFO "ISP_AF: " format, ## __VA_ARGS__)
+#define is_isp_af_debug_enabled()		1
+#else
+#define DPRINTK_ISP_AF(format, ...)
+#define is_isp_af_debug_enabled()		0
+#endif
+
+#ifdef OMAP_ISPHIST_DEBUG
+#define DPRINTK_ISPHIST(format, ...)\
+	printk(KERN_INFO "ISPHIST: " format, ## __VA_ARGS__)
+#define is_isphist_debug_enabled()		1
+#else
+#define DPRINTK_ISPHIST(format, ...)
+#define is_isphist_debug_enabled()		0
+#endif
+
+#define ISP_32B_BOUNDARY_BUF		0xFFFFFFE0
+#define ISP_32B_BOUNDARY_OFFSET		0x0000FFE0
+
+#define CM_CAM_MCLK_HZ			216000000
+
+/* ISP Submodules offset */
+
+#define OMAP3ISP_REG_BASE		OMAP3430_ISP_BASE
+#define OMAP3ISP_REG(offset)		(OMAP3ISP_REG_BASE + (offset))
+
+#define OMAP3ISP_CBUFF_REG_OFFSET	0x0100
+#define OMAP3ISP_CBUFF_REG_BASE		(OMAP3ISP_REG_BASE + \
+						OMAP3ISP_CBUFF_REG_OFFSET)
+#define OMAP3ISP_CBUFF_REG(offset)	(OMAP3ISP_CBUFF_REG_BASE + (offset))
+
+#define OMAP3ISP_CCP2_REG_OFFSET	0x0400
+#define OMAP3ISP_CCP2_REG_BASE		(OMAP3ISP_REG_BASE + \
+						OMAP3ISP_CCP2_REG_OFFSET)
+#define OMAP3ISP_CCP2_REG(offset)	(OMAP3ISP_CCP2_REG_BASE + (offset))
+
+#define OMAP3ISP_CCDC_REG_OFFSET	0x0600
+#define OMAP3ISP_CCDC_REG_BASE		(OMAP3ISP_REG_BASE + \
+						OMAP3ISP_CCDC_REG_OFFSET)
+#define OMAP3ISP_CCDC_REG(offset)	(OMAP3ISP_CCDC_REG_BASE + (offset))
+
+#define OMAP3ISP_HIST_REG_OFFSET	0x0A00
+#define OMAP3ISP_HIST_REG_BASE		(OMAP3ISP_REG_BASE + \
+						OMAP3ISP_HIST_REG_OFFSET)
+#define OMAP3ISP_HIST_REG(offset)	(OMAP3ISP_HIST_REG_BASE + (offset))
+
+#define OMAP3ISP_H3A_REG_OFFSET		0x0C00
+#define OMAP3ISP_H3A_REG_BASE		(OMAP3ISP_REG_BASE + \
+						OMAP3ISP_H3A_REG_OFFSET)
+#define OMAP3ISP_H3A_REG(offset)	(OMAP3ISP_H3A_REG_BASE + (offset))
+
+#define OMAP3ISP_PREV_REG_OFFSET	0x0E00
+#define OMAP3ISP_PREV_REG_BASE		(OMAP3ISP_REG_BASE + \
+						OMAP3ISP_PREV_REG_OFFSET)
+#define OMAP3ISP_PREV_REG(offset)	(OMAP3ISP_PREV_REG_BASE + (offset))
+
+#define OMAP3ISP_RESZ_REG_OFFSET	0x1000
+#define OMAP3ISP_RESZ_REG_BASE		(OMAP3ISP_REG_BASE + \
+						OMAP3ISP_RESZ_REG_OFFSET)
+#define OMAP3ISP_RESZ_REG(offset)	(OMAP3ISP_RESZ_REG_BASE + (offset))
+
+#define OMAP3ISP_SBL_REG_OFFSET		0x1200
+#define OMAP3ISP_SBL_REG_BASE		(OMAP3ISP_REG_BASE + \
+						OMAP3ISP_SBL_REG_OFFSET)
+#define OMAP3ISP_SBL_REG(offset)	(OMAP3ISP_SBL_REG_BASE + (offset))
+
+#define OMAP3ISP_MMU_REG_OFFSET		0x1400
+#define OMAP3ISP_MMU_REG_BASE		(OMAP3ISP_REG_BASE + \
+						OMAP3ISP_MMU_REG_OFFSET)
+#define OMAP3ISP_MMU_REG(offset)	(OMAP3ISP_MMU_REG_BASE + (offset))
+
+#define OMAP3ISP_CSI2A_REG_OFFSET	0x1800
+#define OMAP3ISP_CSI2A_REG_BASE		(OMAP3ISP_REG_BASE + \
+						OMAP3ISP_CSI2A_REG_OFFSET)
+#define OMAP3ISP_CSI2A_REG(offset)	(OMAP3ISP_CSI2A_REG_BASE + (offset))
+
+#define OMAP3ISP_CSI2PHY_REG_OFFSET	0x1970
+#define OMAP3ISP_CSI2PHY_REG_BASE	(OMAP3ISP_REG_BASE + \
+						OMAP3ISP_CSI2PHY_REG_OFFSET)
+#define OMAP3ISP_CSI2PHY_REG(offset)	(OMAP3ISP_CSI2PHY_REG_BASE + (offset))
+
+/* ISP module register offset */
+
+#define ISP_REVISION			(0x000)
+#define ISP_SYSCONFIG			(0x004)
+#define ISP_SYSSTATUS			(0x008)
+#define ISP_IRQ0ENABLE			(0x00C)
+#define ISP_IRQ0STATUS			(0x010)
+#define ISP_IRQ1ENABLE			(0x014)
+#define ISP_IRQ1STATUS			(0x018)
+#define ISP_TCTRL_GRESET_LENGTH		(0x030)
+#define ISP_TCTRL_PSTRB_REPLAY		(0x034)
+#define ISP_CTRL			(0x040)
+#define ISP_SECURE			(0x044)
+#define ISP_TCTRL_CTRL			(0x050)
+#define ISP_TCTRL_FRAME			(0x054)
+#define ISP_TCTRL_PSTRB_DELAY		(0x058)
+#define ISP_TCTRL_STRB_DELAY		(0x05C)
+#define ISP_TCTRL_SHUT_DELAY		(0x060)
+#define ISP_TCTRL_PSTRB_LENGTH		(0x064)
+#define ISP_TCTRL_STRB_LENGTH		(0x068)
+#define ISP_TCTRL_SHUT_LENGTH		(0x06C)
+#define ISP_PING_PONG_ADDR		(0x070)
+#define ISP_PING_PONG_MEM_RANGE		(0x074)
+#define ISP_PING_PONG_BUF_SIZE		(0x078)
+
+/* CSI1 receiver registers (ES2.0) */
+#define ISPCSI1_REVISION		(0x000)
+#define ISPCSI1_SYSCONFIG		(0x004)
+#define ISPCSI1_SYSSTATUS		(0x008)
+#define ISPCSI1_LC01_IRQENABLE		(0x00C)
+#define ISPCSI1_LC01_IRQSTATUS		(0x010)
+#define ISPCSI1_LC23_IRQENABLE		(0x014)
+#define ISPCSI1_LC23_IRQSTATUS		(0x018)
+#define ISPCSI1_LCM_IRQENABLE		(0x02C)
+#define ISPCSI1_LCM_IRQSTATUS		(0x030)
+#define ISPCSI1_CTRL			(0x040)
+#define ISPCSI1_DBG			(0x044)
+#define ISPCSI1_GNQ			(0x048)
+#define ISPCSI1_LCx_CTRL(x)		((0x050)+0x30*(x))
+#define ISPCSI1_LCx_CODE(x)		((0x054)+0x30*(x))
+#define ISPCSI1_LCx_STAT_START(x)	((0x058)+0x30*(x))
+#define ISPCSI1_LCx_STAT_SIZE(x)	((0x05C)+0x30*(x))
+#define ISPCSI1_LCx_SOF_ADDR(x)		((0x060)+0x30*(x))
+#define ISPCSI1_LCx_EOF_ADDR(x)		((0x064)+0x30*(x))
+#define ISPCSI1_LCx_DAT_START(x)	((0x068)+0x30*(x))
+#define ISPCSI1_LCx_DAT_SIZE(x)		((0x06C)+0x30*(x))
+#define ISPCSI1_LCx_DAT_PING_ADDR(x)	((0x070)+0x30*(x))
+#define ISPCSI1_LCx_DAT_PONG_ADDR(x)	((0x074)+0x30*(x))
+#define ISPCSI1_LCx_DAT_OFST(x)		((0x078)+0x30*(x))
+#define ISPCSI1_LCM_CTRL		(0x1D0)
+#define ISPCSI1_LCM_VSIZE		(0x1D4)
+#define ISPCSI1_LCM_HSIZE		(0x1D8)
+#define ISPCSI1_LCM_PREFETCH		(0x1DC)
+#define ISPCSI1_LCM_SRC_ADDR		(0x1E0)
+#define ISPCSI1_LCM_SRC_OFST		(0x1E4)
+#define ISPCSI1_LCM_DST_ADDR		(0x1E8)
+#define ISPCSI1_LCM_DST_OFST		(0x1EC)
+#define ISP_CSIB_SYSCONFIG		ISPCSI1_SYSCONFIG
+#define ISP_CSIA_SYSCONFIG		ISPCSI2_SYSCONFIG
+
+/* ISP_CBUFF Registers */
+
+#define ISP_CBUFF_SYSCONFIG		(0x010)
+#define ISP_CBUFF_IRQENABLE		(0x01C)
+
+#define ISP_CBUFF0_CTRL			(0x020)
+#define ISP_CBUFF1_CTRL			(0x024)
+
+#define ISP_CBUFF0_START		(0x040)
+#define ISP_CBUFF1_START		(0x044)
+
+#define ISP_CBUFF0_END			(0x050)
+#define ISP_CBUFF1_END			(0x054)
+
+#define ISP_CBUFF0_WINDOWSIZE		(0x060)
+#define ISP_CBUFF1_WINDOWSIZE		(0x064)
+
+#define ISP_CBUFF0_THRESHOLD		(0x070)
+#define ISP_CBUFF1_THRESHOLD		(0x074)
+
+/* CCDC module register offset */
+
+#define ISPCCDC_PID			(0x000)
+#define ISPCCDC_PCR			(0x004)
+#define ISPCCDC_SYN_MODE		(0x008)
+#define ISPCCDC_HD_VD_WID		(0x00C)
+#define ISPCCDC_PIX_LINES		(0x010)
+#define ISPCCDC_HORZ_INFO		(0x014)
+#define ISPCCDC_VERT_START		(0x018)
+#define ISPCCDC_VERT_LINES		(0x01C)
+#define ISPCCDC_CULLING			(0x020)
+#define ISPCCDC_HSIZE_OFF		(0x024)
+#define ISPCCDC_SDOFST			(0x028)
+#define ISPCCDC_SDR_ADDR		(0x02C)
+#define ISPCCDC_CLAMP			(0x030)
+#define ISPCCDC_DCSUB			(0x034)
+#define ISPCCDC_COLPTN			(0x038)
+#define ISPCCDC_BLKCMP			(0x03C)
+#define ISPCCDC_FPC			(0x040)
+#define ISPCCDC_FPC_ADDR		(0x044)
+#define ISPCCDC_VDINT			(0x048)
+#define ISPCCDC_ALAW			(0x04C)
+#define ISPCCDC_REC656IF		(0x050)
+#define ISPCCDC_CFG			(0x054)
+#define ISPCCDC_FMTCFG			(0x058)
+#define ISPCCDC_FMT_HORZ		(0x05C)
+#define ISPCCDC_FMT_VERT		(0x060)
+#define ISPCCDC_FMT_ADDR0		(0x064)
+#define ISPCCDC_FMT_ADDR1		(0x068)
+#define ISPCCDC_FMT_ADDR2		(0x06C)
+#define ISPCCDC_FMT_ADDR3		(0x070)
+#define ISPCCDC_FMT_ADDR4		(0x074)
+#define ISPCCDC_FMT_ADDR5		(0x078)
+#define ISPCCDC_FMT_ADDR6		(0x07C)
+#define ISPCCDC_FMT_ADDR7		(0x080)
+#define ISPCCDC_PRGEVEN0		(0x084)
+#define ISPCCDC_PRGEVEN1		(0x088)
+#define ISPCCDC_PRGODD0			(0x08C)
+#define ISPCCDC_PRGODD1			(0x090)
+#define ISPCCDC_VP_OUT			(0x094)
+
+#define ISPCCDC_LSC_CONFIG		(0x098)
+#define ISPCCDC_LSC_INITIAL		(0x09C)
+#define ISPCCDC_LSC_TABLE_BASE		(0x0A0)
+#define ISPCCDC_LSC_TABLE_OFFSET	(0x0A4)
+
+/* SBL */
+#define ISPSBL_CCDC_WR_0		(0x028)
+#define ISPSBL_CCDC_WR_0_DATA_READY	(1 << 21)
+#define ISPSBL_CCDC_WR_1		(0x02C)
+#define ISPSBL_CCDC_WR_2		(0x030)
+#define ISPSBL_CCDC_WR_3		(0x034)
+
+/* Histogram registers */
+#define ISPHIST_PID			(0x000)
+#define ISPHIST_PCR			(0x004)
+#define ISPHIST_CNT			(0x008)
+#define ISPHIST_WB_GAIN			(0x00C)
+#define ISPHIST_R0_HORZ			(0x010)
+#define ISPHIST_R0_VERT			(0x014)
+#define ISPHIST_R1_HORZ			(0x018)
+#define ISPHIST_R1_VERT			(0x01C)
+#define ISPHIST_R2_HORZ			(0x020)
+#define ISPHIST_R2_VERT			(0x024)
+#define ISPHIST_R3_HORZ			(0x028)
+#define ISPHIST_R3_VERT			(0x02C)
+#define ISPHIST_ADDR			(0x030)
+#define ISPHIST_DATA			(0x034)
+#define ISPHIST_RADD			(0x038)
+#define ISPHIST_RADD_OFF		(0x03C)
+#define ISPHIST_H_V_INFO		(0x040)
+
+/* H3A module registers */
+#define ISPH3A_PID			(0x000)
+#define ISPH3A_PCR			(0x004)
+#define ISPH3A_AEWWIN1			(0x04C)
+#define ISPH3A_AEWINSTART		(0x050)
+#define ISPH3A_AEWINBLK			(0x054)
+#define ISPH3A_AEWSUBWIN		(0x058)
+#define ISPH3A_AEWBUFST			(0x05C)
+#define ISPH3A_AFPAX1			(0x008)
+#define ISPH3A_AFPAX2			(0x00C)
+#define ISPH3A_AFPAXSTART		(0x010)
+#define ISPH3A_AFIIRSH			(0x014)
+#define ISPH3A_AFBUFST			(0x018)
+#define ISPH3A_AFCOEF010		(0x01C)
+#define ISPH3A_AFCOEF032		(0x020)
+#define ISPH3A_AFCOEF054		(0x024)
+#define ISPH3A_AFCOEF076		(0x028)
+#define ISPH3A_AFCOEF098		(0x02C)
+#define ISPH3A_AFCOEF0010		(0x030)
+#define ISPH3A_AFCOEF110		(0x034)
+#define ISPH3A_AFCOEF132		(0x038)
+#define ISPH3A_AFCOEF154		(0x03C)
+#define ISPH3A_AFCOEF176		(0x040)
+#define ISPH3A_AFCOEF198		(0x044)
+#define ISPH3A_AFCOEF1010		(0x048)
+
+#define ISPPRV_PCR			(0x004)
+#define ISPPRV_HORZ_INFO		(0x008)
+#define ISPPRV_VERT_INFO		(0x00C)
+#define ISPPRV_RSDR_ADDR		(0x010)
+#define ISPPRV_RADR_OFFSET		(0x014)
+#define ISPPRV_DSDR_ADDR		(0x018)
+#define ISPPRV_DRKF_OFFSET		(0x01C)
+#define ISPPRV_WSDR_ADDR		(0x020)
+#define ISPPRV_WADD_OFFSET		(0x024)
+#define ISPPRV_AVE			(0x028)
+#define ISPPRV_HMED			(0x02C)
+#define ISPPRV_NF			(0x030)
+#define ISPPRV_WB_DGAIN			(0x034)
+#define ISPPRV_WBGAIN			(0x038)
+#define ISPPRV_WBSEL			(0x03C)
+#define ISPPRV_CFA			(0x040)
+#define ISPPRV_BLKADJOFF		(0x044)
+#define ISPPRV_RGB_MAT1			(0x048)
+#define ISPPRV_RGB_MAT2			(0x04C)
+#define ISPPRV_RGB_MAT3			(0x050)
+#define ISPPRV_RGB_MAT4			(0x054)
+#define ISPPRV_RGB_MAT5			(0x058)
+#define ISPPRV_RGB_OFF1			(0x05C)
+#define ISPPRV_RGB_OFF2			(0x060)
+#define ISPPRV_CSC0			(0x064)
+#define ISPPRV_CSC1			(0x068)
+#define ISPPRV_CSC2			(0x06C)
+#define ISPPRV_CSC_OFFSET		(0x070)
+#define ISPPRV_CNT_BRT			(0x074)
+#define ISPPRV_CSUP			(0x078)
+#define ISPPRV_SETUP_YC			(0x07C)
+#define ISPPRV_SET_TBL_ADDR		(0x080)
+#define ISPPRV_SET_TBL_DATA		(0x084)
+#define ISPPRV_CDC_THR0			(0x090)
+#define ISPPRV_CDC_THR1			(ISPPRV_CDC_THR0 + (0x4))
+#define ISPPRV_CDC_THR2			(ISPPRV_CDC_THR0 + (0x4) * 2)
+#define ISPPRV_CDC_THR3			(ISPPRV_CDC_THR0 + (0x4) * 3)
+
+#define ISPPRV_REDGAMMA_TABLE_ADDR	0x0000
+#define ISPPRV_GREENGAMMA_TABLE_ADDR	0x0400
+#define ISPPRV_BLUEGAMMA_TABLE_ADDR	0x0800
+#define ISPPRV_NF_TABLE_ADDR		0x0C00
+#define ISPPRV_YENH_TABLE_ADDR		0x1000
+#define ISPPRV_CFA_TABLE_ADDR		0x1400
+
+#define ISPPRV_MAXOUTPUT_WIDTH		1280
+#define ISPPRV_MAXOUTPUT_WIDTH_ES2	3300
+#define ISPRSZ_MIN_OUTPUT		64
+#define ISPRSZ_MAX_OUTPUT		3312
+
+/* Resizer module register offset */
+#define ISPRSZ_PID			(0x000)
+#define ISPRSZ_PCR			(0x004)
+#define ISPRSZ_CNT			(0x008)
+#define ISPRSZ_OUT_SIZE			(0x00C)
+#define ISPRSZ_IN_START			(0x010)
+#define ISPRSZ_IN_SIZE			(0x014)
+#define ISPRSZ_SDR_INADD		(0x018)
+#define ISPRSZ_SDR_INOFF		(0x01C)
+#define ISPRSZ_SDR_OUTADD		(0x020)
+#define ISPRSZ_SDR_OUTOFF		(0x024)
+#define ISPRSZ_HFILT10			(0x028)
+#define ISPRSZ_HFILT32			(0x02C)
+#define ISPRSZ_HFILT54			(0x030)
+#define ISPRSZ_HFILT76			(0x034)
+#define ISPRSZ_HFILT98			(0x038)
+#define ISPRSZ_HFILT1110		(0x03C)
+#define ISPRSZ_HFILT1312		(0x040)
+#define ISPRSZ_HFILT1514		(0x044)
+#define ISPRSZ_HFILT1716		(0x048)
+#define ISPRSZ_HFILT1918		(0x04C)
+#define ISPRSZ_HFILT2120		(0x050)
+#define ISPRSZ_HFILT2322		(0x054)
+#define ISPRSZ_HFILT2524		(0x058)
+#define ISPRSZ_HFILT2726		(0x05C)
+#define ISPRSZ_HFILT2928		(0x060)
+#define ISPRSZ_HFILT3130		(0x064)
+#define ISPRSZ_VFILT10			(0x068)
+#define ISPRSZ_VFILT32			(0x06C)
+#define ISPRSZ_VFILT54			(0x070)
+#define ISPRSZ_VFILT76			(0x074)
+#define ISPRSZ_VFILT98			(0x078)
+#define ISPRSZ_VFILT1110		(0x07C)
+#define ISPRSZ_VFILT1312		(0x080)
+#define ISPRSZ_VFILT1514		(0x084)
+#define ISPRSZ_VFILT1716		(0x088)
+#define ISPRSZ_VFILT1918		(0x08C)
+#define ISPRSZ_VFILT2120		(0x090)
+#define ISPRSZ_VFILT2322		(0x094)
+#define ISPRSZ_VFILT2524		(0x098)
+#define ISPRSZ_VFILT2726		(0x09C)
+#define ISPRSZ_VFILT2928		(0x0A0)
+#define ISPRSZ_VFILT3130		(0x0A4)
+#define ISPRSZ_YENH			(0x0A8)
+
+/* MMU module registers */
+#define ISPMMU_REVISION			(0x000)
+#define ISPMMU_SYSCONFIG		(0x010)
+#define ISPMMU_SYSSTATUS		(0x014)
+#define ISPMMU_IRQSTATUS		(0x018)
+#define ISPMMU_IRQENABLE		(0x01C)
+#define ISPMMU_WALKING_ST		(0x040)
+#define ISPMMU_CNTL			(0x044)
+#define ISPMMU_FAULT_AD			(0x048)
+#define ISPMMU_TTB			(0x04C)
+#define ISPMMU_LOCK			(0x050)
+#define ISPMMU_LD_TLB			(0x054)
+#define ISPMMU_CAM			(0x058)
+#define ISPMMU_RAM			(0x05C)
+#define ISPMMU_GFLUSH			(0x060)
+#define ISPMMU_FLUSH_ENTRY		(0x064)
+#define ISPMMU_READ_CAM			(0x068)
+#define ISPMMU_READ_RAM			(0x06c)
+#define ISPMMU_EMU_FAULT_AD		(0x070)
+
+#define ISP_INT_CLR			0xFF113F11
+#define ISPPRV_PCR_EN			1
+#define ISPPRV_PCR_BUSY			(1 << 1)
+#define ISPPRV_PCR_SOURCE		(1 << 2)
+#define ISPPRV_PCR_ONESHOT		(1 << 3)
+#define ISPPRV_PCR_WIDTH		(1 << 4)
+#define ISPPRV_PCR_INVALAW		(1 << 5)
+#define ISPPRV_PCR_DRKFEN		(1 << 6)
+#define ISPPRV_PCR_DRKFCAP		(1 << 7)
+#define ISPPRV_PCR_HMEDEN		(1 << 8)
+#define ISPPRV_PCR_NFEN			(1 << 9)
+#define ISPPRV_PCR_CFAEN		(1 << 10)
+#define ISPPRV_PCR_CFAFMT_SHIFT		11
+#define ISPPRV_PCR_CFAFMT_MASK		0x7800
+#define ISPPRV_PCR_CFAFMT_BAYER		(0 << 11)
+#define ISPPRV_PCR_CFAFMT_SONYVGA	(1 << 11)
+#define ISPPRV_PCR_CFAFMT_RGBFOVEON	(2 << 11)
+#define ISPPRV_PCR_CFAFMT_DNSPL		(3 << 11)
+#define ISPPRV_PCR_CFAFMT_HONEYCOMB	(4 << 11)
+#define ISPPRV_PCR_CFAFMT_RRGGBBFOVEON	(5 << 11)
+#define ISPPRV_PCR_YNENHEN		(1 << 15)
+#define ISPPRV_PCR_SUPEN		(1 << 16)
+#define ISPPRV_PCR_YCPOS_SHIFT		17
+#define ISPPRV_PCR_YCPOS_YCrYCb		(0 << 17)
+#define ISPPRV_PCR_YCPOS_YCbYCr		(1 << 17)
+#define ISPPRV_PCR_YCPOS_CbYCrY		(2 << 17)
+#define ISPPRV_PCR_YCPOS_CrYCbY		(3 << 17)
+#define ISPPRV_PCR_RSZPORT		(1 << 19)
+#define ISPPRV_PCR_SDRPORT		(1 << 20)
+#define ISPPRV_PCR_SCOMP_EN		(1 << 21)
+#define ISPPRV_PCR_SCOMP_SFT_SHIFT	(22)
+#define ISPPRV_PCR_SCOMP_SFT_MASK	(~(7 << 22))
+#define ISPPRV_PCR_GAMMA_BYPASS		(1 << 26)
+#define ISPPRV_PCR_DCOREN		(1 << 27)
+#define ISPPRV_PCR_DCCOUP		(1 << 28)
+#define ISPPRV_PCR_DRK_FAIL		(1 << 31)
+
+#define ISPPRV_HORZ_INFO_EPH_SHIFT	0
+#define ISPPRV_HORZ_INFO_EPH_MASK	0x3fff
+#define ISPPRV_HORZ_INFO_SPH_SHIFT	16
+#define ISPPRV_HORZ_INFO_SPH_MASK	0x3fff0
+
+#define ISPPRV_VERT_INFO_ELV_SHIFT	0
+#define ISPPRV_VERT_INFO_ELV_MASK	0x3fff
+#define ISPPRV_VERT_INFO_SLV_SHIFT	16
+#define ISPPRV_VERT_INFO_SLV_MASK	0x3fff0
+
+#define ISPPRV_AVE_EVENDIST_SHIFT	2
+#define ISPPRV_AVE_EVENDIST_1		0x0
+#define ISPPRV_AVE_EVENDIST_2		0x1
+#define ISPPRV_AVE_EVENDIST_3		0x2
+#define ISPPRV_AVE_EVENDIST_4		0x3
+#define ISPPRV_AVE_ODDDIST_SHIFT	4
+#define ISPPRV_AVE_ODDDIST_1		0x0
+#define ISPPRV_AVE_ODDDIST_2		0x1
+#define ISPPRV_AVE_ODDDIST_3		0x2
+#define ISPPRV_AVE_ODDDIST_4		0x3
+
+#define ISPPRV_HMED_THRESHOLD_SHIFT	0
+#define ISPPRV_HMED_EVENDIST		(1 << 8)
+#define ISPPRV_HMED_ODDDIST		(1 << 9)
+
+#define ISPPRV_WBGAIN_COEF0_SHIFT	0
+#define ISPPRV_WBGAIN_COEF1_SHIFT	8
+#define ISPPRV_WBGAIN_COEF2_SHIFT	16
+#define ISPPRV_WBGAIN_COEF3_SHIFT	24
+
+#define ISPPRV_WBSEL_COEF0		0x0
+#define ISPPRV_WBSEL_COEF1		0x1
+#define ISPPRV_WBSEL_COEF2		0x2
+#define ISPPRV_WBSEL_COEF3		0x3
+
+#define ISPPRV_WBSEL_N0_0_SHIFT		0
+#define ISPPRV_WBSEL_N0_1_SHIFT		2
+#define ISPPRV_WBSEL_N0_2_SHIFT		4
+#define ISPPRV_WBSEL_N0_3_SHIFT		6
+#define ISPPRV_WBSEL_N1_0_SHIFT		8
+#define ISPPRV_WBSEL_N1_1_SHIFT		10
+#define ISPPRV_WBSEL_N1_2_SHIFT		12
+#define ISPPRV_WBSEL_N1_3_SHIFT		14
+#define ISPPRV_WBSEL_N2_0_SHIFT		16
+#define ISPPRV_WBSEL_N2_1_SHIFT		18
+#define ISPPRV_WBSEL_N2_2_SHIFT		20
+#define ISPPRV_WBSEL_N2_3_SHIFT		22
+#define ISPPRV_WBSEL_N3_0_SHIFT		24
+#define ISPPRV_WBSEL_N3_1_SHIFT		26
+#define ISPPRV_WBSEL_N3_2_SHIFT		28
+#define ISPPRV_WBSEL_N3_3_SHIFT		30
+
+#define ISPPRV_CFA_GRADTH_HOR_SHIFT	0
+#define ISPPRV_CFA_GRADTH_VER_SHIFT	8
+
+#define ISPPRV_BLKADJOFF_B_SHIFT	0
+#define ISPPRV_BLKADJOFF_G_SHIFT	8
+#define ISPPRV_BLKADJOFF_R_SHIFT	16
+
+#define ISPPRV_RGB_MAT1_MTX_RR_SHIFT	0
+#define ISPPRV_RGB_MAT1_MTX_GR_SHIFT	16
+
+#define ISPPRV_RGB_MAT2_MTX_BR_SHIFT	0
+#define ISPPRV_RGB_MAT2_MTX_RG_SHIFT	16
+
+#define ISPPRV_RGB_MAT3_MTX_GG_SHIFT	0
+#define ISPPRV_RGB_MAT3_MTX_BG_SHIFT	16
+
+#define ISPPRV_RGB_MAT4_MTX_RB_SHIFT	0
+#define ISPPRV_RGB_MAT4_MTX_GB_SHIFT	16
+
+#define ISPPRV_RGB_MAT5_MTX_BB_SHIFT	0
+
+#define ISPPRV_RGB_OFF1_MTX_OFFG_SHIFT	0
+#define ISPPRV_RGB_OFF1_MTX_OFFR_SHIFT	16
+
+#define ISPPRV_RGB_OFF2_MTX_OFFB_SHIFT	0
+
+#define ISPPRV_CSC0_RY_SHIFT		0
+#define ISPPRV_CSC0_GY_SHIFT		10
+#define ISPPRV_CSC0_BY_SHIFT		20
+
+#define ISPPRV_CSC1_RCB_SHIFT		0
+#define ISPPRV_CSC1_GCB_SHIFT		10
+#define ISPPRV_CSC1_BCB_SHIFT		20
+
+#define ISPPRV_CSC2_RCR_SHIFT		0
+#define ISPPRV_CSC2_GCR_SHIFT		10
+#define ISPPRV_CSC2_BCR_SHIFT		20
+
+#define ISPPRV_CSC_OFFSET_CR_SHIFT	0
+#define ISPPRV_CSC_OFFSET_CB_SHIFT	8
+#define ISPPRV_CSC_OFFSET_Y_SHIFT	16
+
+#define ISPPRV_CNT_BRT_BRT_SHIFT	0
+#define ISPPRV_CNT_BRT_CNT_SHIFT	8
+
+#define ISPPRV_CONTRAST_MAX		0x10
+#define ISPPRV_CONTRAST_MIN		0xFF
+#define ISPPRV_BRIGHT_MIN		0x00
+#define ISPPRV_BRIGHT_MAX		0xFF
+
+#define ISPPRV_CSUP_CSUPG_SHIFT		0
+#define ISPPRV_CSUP_THRES_SHIFT		8
+#define ISPPRV_CSUP_HPYF_SHIFT		16
+
+#define ISPPRV_SETUP_YC_MINC_SHIFT	0
+#define ISPPRV_SETUP_YC_MAXC_SHIFT	8
+#define ISPPRV_SETUP_YC_MINY_SHIFT	16
+#define ISPPRV_SETUP_YC_MAXY_SHIFT	24
+#define ISPPRV_YC_MAX			0xFF
+#define ISPPRV_YC_MIN			0x0
+
+/* Define bit fields within selected registers */
+#define ISP_REVISION_SHIFT			0
+
+#define ISP_SYSCONFIG_AUTOIDLE			0
+#define ISP_SYSCONFIG_SOFTRESET			(1 << 1)
+#define ISP_SYSCONFIG_MIDLEMODE_SHIFT		12
+#define ISP_SYSCONFIG_MIDLEMODE_FORCESTANDBY	0x0
+#define ISP_SYSCONFIG_MIDLEMODE_NOSTANBY	0x1
+#define ISP_SYSCONFIG_MIDLEMODE_SMARTSTANDBY	0x2
+
+#define ISP_SYSSTATUS_RESETDONE			0
+
+#define IRQ0ENABLE_CSIA_IRQ			1
+#define IRQ0ENABLE_CSIA_LC1_IRQ			(1 << 1)
+#define IRQ0ENABLE_CSIA_LC2_IRQ			(1 << 2)
+#define IRQ0ENABLE_CSIA_LC3_IRQ			(1 << 3)
+#define IRQ0ENABLE_CSIB_IRQ			(1 << 4)
+#define IRQ0ENABLE_CSIB_LC1_IRQ			(1 << 5)
+#define IRQ0ENABLE_CSIB_LC2_IRQ			(1 << 6)
+#define IRQ0ENABLE_CSIB_LC3_IRQ			(1 << 7)
+#define IRQ0ENABLE_CCDC_VD0_IRQ			(1 << 8)
+#define IRQ0ENABLE_CCDC_VD1_IRQ			(1 << 9)
+#define IRQ0ENABLE_CCDC_VD2_IRQ			(1 << 10)
+#define IRQ0ENABLE_CCDC_ERR_IRQ			(1 << 11)
+#define IRQ0ENABLE_H3A_AF_DONE_IRQ		(1 << 12)
+#define IRQ0ENABLE_H3A_AWB_DONE_IRQ		(1 << 13)
+#define IRQ0ENABLE_HIST_DONE_IRQ		(1 << 16)
+#define IRQ0ENABLE_CCDC_LSC_DONE_IRQ		(1 << 17)
+#define IRQ0ENABLE_CCDC_LSC_PREF_COMP_IRQ	(1 << 18)
+#define IRQ0ENABLE_CCDC_LSC_PREF_ERR_IRQ	(1 << 19)
+#define IRQ0ENABLE_PRV_DONE_IRQ			(1 << 20)
+#define IRQ0ENABLE_RSZ_DONE_IRQ			(1 << 24)
+#define IRQ0ENABLE_OVF_IRQ			(1 << 25)
+#define IRQ0ENABLE_PING_IRQ			(1 << 26)
+#define IRQ0ENABLE_PONG_IRQ			(1 << 27)
+#define IRQ0ENABLE_MMU_ERR_IRQ			(1 << 28)
+#define IRQ0ENABLE_OCP_ERR_IRQ			(1 << 29)
+#define IRQ0ENABLE_SEC_ERR_IRQ			(1 << 30)
+#define IRQ0ENABLE_HS_VS_IRQ			(1 << 31)
+
+#define IRQ0STATUS_CSIA_IRQ			1
+#define IRQ0STATUS_CSIA_LC1_IRQ			(1 << 1)
+#define IRQ0STATUS_CSIA_LC2_IRQ			(1 << 2)
+#define IRQ0STATUS_CSIA_LC3_IRQ			(1 << 3)
+#define IRQ0STATUS_CSIB_IRQ			(1 << 4)
+#define IRQ0STATUS_CSIB_LC1_IRQ			(1 << 5)
+#define IRQ0STATUS_CSIB_LC2_IRQ			(1 << 6)
+#define IRQ0STATUS_CSIB_LC3_IRQ			(1 << 7)
+#define IRQ0STATUS_CCDC_VD0_IRQ			(1 << 8)
+#define IRQ0STATUS_CCDC_VD1_IRQ			(1 << 9)
+#define IRQ0STATUS_CCDC_VD2_IRQ			(1 << 10)
+#define IRQ0STATUS_CCDC_ERR_IRQ			(1 << 11)
+#define IRQ0STATUS_H3A_AF_DONE_IRQ		(1 << 12)
+#define IRQ0STATUS_H3A_AWB_DONE_IRQ		(1 << 13)
+#define IRQ0STATUS_HIST_DONE_IRQ		(1 << 16)
+#define IRQ0STATUS_PRV_DONE_IRQ			(1 << 20)
+#define IRQ0STATUS_RSZ_DONE_IRQ			(1 << 24)
+#define IRQ0STATUS_OVF_IRQ			(1 << 25)
+#define IRQ0STATUS_PING_IRQ			(1 << 26)
+#define IRQ0STATUS_PONG_IRQ			(1 << 27)
+#define IRQ0STATUS_MMU_ERR_IRQ			(1 << 28)
+#define IRQ0STATUS_OCP_ERR_IRQ			(1 << 29)
+#define IRQ0STATUS_SEC_ERR_IRQ			(1 << 30)
+#define IRQ0STATUS_HS_VS_IRQ			(1 << 31)
+
+#define TCTRL_GRESET_LEN			0
+
+#define TCTRL_PSTRB_REPLAY_DELAY		0
+#define TCTRL_PSTRB_REPLAY_COUNTER_SHIFT	25
+
+#define ISPCTRL_PAR_SER_CLK_SEL_PARALLEL	0x0
+#define ISPCTRL_PAR_SER_CLK_SEL_CSIA		0x1
+#define ISPCTRL_PAR_SER_CLK_SEL_CSIB		0x2
+#define ISPCTRL_PAR_SER_CLK_SEL_MASK		0xFFFFFFFC
+
+#define ISPCTRL_PAR_BRIDGE_SHIFT		2
+#define ISPCTRL_PAR_BRIDGE_DISABLE		(0x0 << 2)
+#define ISPCTRL_PAR_BRIDGE_LENDIAN		(0x2 << 2)
+#define ISPCTRL_PAR_BRIDGE_BENDIAN		(0x3 << 2)
+
+#define ISPCTRL_PAR_CLK_POL_SHIFT		4
+#define ISPCTRL_PAR_CLK_POL_INV			(1 << 4)
+#define ISPCTRL_PING_PONG_EN			(1 << 5)
+#define ISPCTRL_SHIFT_SHIFT			6
+#define ISPCTRL_SHIFT_0				(0x0 << 6)
+#define ISPCTRL_SHIFT_2				(0x1 << 6)
+#define ISPCTRL_SHIFT_4				(0x2 << 6)
+#define ISPCTRL_SHIFT_MASK			(~(0x3 << 6))
+
+#define ISPCTRL_CCDC_CLK_EN			(1 << 8)
+#define ISPCTRL_SCMP_CLK_EN			(1 << 9)
+#define ISPCTRL_H3A_CLK_EN			(1 << 10)
+#define ISPCTRL_HIST_CLK_EN			(1 << 11)
+#define ISPCTRL_PREV_CLK_EN			(1 << 12)
+#define ISPCTRL_RSZ_CLK_EN			(1 << 13)
+#define ISPCTRL_SYNC_DETECT_SHIFT		14
+#define ISPCTRL_SYNC_DETECT_HSFALL	(0x0 << ISPCTRL_SYNC_DETECT_SHIFT)
+#define ISPCTRL_SYNC_DETECT_HSRISE	(0x1 << ISPCTRL_SYNC_DETECT_SHIFT)
+#define ISPCTRL_SYNC_DETECT_VSFALL	(0x2 << ISPCTRL_SYNC_DETECT_SHIFT)
+#define ISPCTRL_SYNC_DETECT_VSRISE	(0x3 << ISPCTRL_SYNC_DETECT_SHIFT)
+#define ISPCTRL_SYNC_DETECT_MASK	(0x3 << ISPCTRL_SYNC_DETECT_SHIFT)
+
+#define ISPCTRL_CCDC_RAM_EN		(1 << 16)
+#define ISPCTRL_PREV_RAM_EN		(1 << 17)
+#define ISPCTRL_SBL_RD_RAM_EN		(1 << 18)
+#define ISPCTRL_SBL_WR1_RAM_EN		(1 << 19)
+#define ISPCTRL_SBL_WR0_RAM_EN		(1 << 20)
+#define ISPCTRL_SBL_AUTOIDLE		(1 << 21)
+#define ISPCTRL_SBL_SHARED_RPORTB	(1 << 28)
+#define ISPCTRL_JPEG_FLUSH		(1 << 30)
+#define ISPCTRL_CCDC_FLUSH		(1 << 31)
+
+#define ISPSECURE_SECUREMODE		0
+
+#define ISPTCTRL_CTRL_DIV_LOW		0x0
+#define ISPTCTRL_CTRL_DIV_HIGH		0x1
+#define ISPTCTRL_CTRL_DIV_BYPASS	0x1F
+
+#define ISPTCTRL_CTRL_DIVA_SHIFT	0
+#define ISPTCTRL_CTRL_DIVA_MASK		(0x1F << ISPTCTRL_CTRL_DIVA_SHIFT)
+
+#define ISPTCTRL_CTRL_DIVB_SHIFT	5
+#define ISPTCTRL_CTRL_DIVB_MASK		(0x1F << ISPTCTRL_CTRL_DIVB_SHIFT)
+
+#define ISPTCTRL_CTRL_DIVC_SHIFT	10
+#define ISPTCTRL_CTRL_DIVC_NOCLOCK	(0x0 << 10)
+
+#define ISPTCTRL_CTRL_SHUTEN		(1 << 21)
+#define ISPTCTRL_CTRL_PSTRBEN		(1 << 22)
+#define ISPTCTRL_CTRL_STRBEN		(1 << 23)
+#define ISPTCTRL_CTRL_SHUTPOL		(1 << 24)
+#define ISPTCTRL_CTRL_STRBPSTRBPOL	(1 << 26)
+
+#define ISPTCTRL_CTRL_INSEL_SHIFT	27
+#define ISPTCTRL_CTRL_INSEL_PARALLEL	(0x0 << 27)
+#define ISPTCTRL_CTRL_INSEL_CSIA	(0x1 << 27)
+#define ISPTCTRL_CTRL_INSEL_CSIB	(0x2 << 27)
+
+#define ISPTCTRL_CTRL_GRESETEn		(1 << 29)
+#define ISPTCTRL_CTRL_GRESETPOL		(1 << 30)
+#define ISPTCTRL_CTRL_GRESETDIR		(1 << 31)
+
+#define ISPTCTRL_FRAME_SHUT_SHIFT		0
+#define ISPTCTRL_FRAME_PSTRB_SHIFT		6
+#define ISPTCTRL_FRAME_STRB_SHIFT		12
+
+#define ISPCCDC_PID_PREV_SHIFT			0
+#define ISPCCDC_PID_CID_SHIFT			8
+#define ISPCCDC_PID_TID_SHIFT			16
+
+#define ISPCCDC_PCR_EN				1
+#define ISPCCDC_PCR_BUSY			(1 << 1)
+
+#define ISPCCDC_SYN_MODE_VDHDOUT		0x1
+#define ISPCCDC_SYN_MODE_FLDOUT			(1 << 1)
+#define ISPCCDC_SYN_MODE_VDPOL			(1 << 2)
+#define ISPCCDC_SYN_MODE_HDPOL			(1 << 3)
+#define ISPCCDC_SYN_MODE_FLDPOL			(1 << 4)
+#define ISPCCDC_SYN_MODE_EXWEN			(1 << 5)
+#define ISPCCDC_SYN_MODE_DATAPOL		(1 << 6)
+#define ISPCCDC_SYN_MODE_FLDMODE		(1 << 7)
+#define ISPCCDC_SYN_MODE_DATSIZ_MASK		0xFFFFF8FF
+#define ISPCCDC_SYN_MODE_DATSIZ_8_16		(0x0 << 8)
+#define ISPCCDC_SYN_MODE_DATSIZ_12		(0x4 << 8)
+#define ISPCCDC_SYN_MODE_DATSIZ_11		(0x5 << 8)
+#define ISPCCDC_SYN_MODE_DATSIZ_10		(0x6 << 8)
+#define ISPCCDC_SYN_MODE_DATSIZ_8		(0x7 << 8)
+#define ISPCCDC_SYN_MODE_PACK8			(1 << 11)
+#define ISPCCDC_SYN_MODE_INPMOD_MASK		0xFFFFCFFF
+#define ISPCCDC_SYN_MODE_INPMOD_RAW		(0 << 12)
+#define ISPCCDC_SYN_MODE_INPMOD_YCBCR16		(1 << 12)
+#define ISPCCDC_SYN_MODE_INPMOD_YCBCR8		(2 << 12)
+#define ISPCCDC_SYN_MODE_LPF			(1 << 14)
+#define ISPCCDC_SYN_MODE_FLDSTAT		(1 << 15)
+#define ISPCCDC_SYN_MODE_VDHDEN			(1 << 16)
+#define ISPCCDC_SYN_MODE_WEN			(1 << 17)
+#define ISPCCDC_SYN_MODE_VP2SDR			(1 << 18)
+#define ISPCCDC_SYN_MODE_SDR2RSZ		(1 << 19)
+
+#define ISPCCDC_HD_VD_WID_VDW_SHIFT		0
+#define ISPCCDC_HD_VD_WID_HDW_SHIFT		16
+
+#define ISPCCDC_PIX_LINES_HLPRF_SHIFT		0
+#define ISPCCDC_PIX_LINES_PPLN_SHIFT		16
+
+#define ISPCCDC_HORZ_INFO_NPH_SHIFT		0
+#define ISPCCDC_HORZ_INFO_NPH_MASK		0xFFFF8000
+#define ISPCCDC_HORZ_INFO_SPH_MASK		0x1000FFFF
+#define ISPCCDC_HORZ_INFO_SPH_SHIFT		16
+
+#define ISPCCDC_VERT_START_SLV0_SHIFT		16
+#define ISPCCDC_VERT_START_SLV0_MASK		0x1000FFFF
+#define ISPCCDC_VERT_START_SLV1_SHIFT		0
+
+#define ISPCCDC_VERT_LINES_NLV_MASK		0xFFFF8000
+#define ISPCCDC_VERT_LINES_NLV_SHIFT		0
+
+#define ISPCCDC_CULLING_CULV_SHIFT		0
+#define ISPCCDC_CULLING_CULHODD_SHIFT		16
+#define ISPCCDC_CULLING_CULHEVN_SHIFT		24
+
+#define ISPCCDC_HSIZE_OFF_SHIFT			0
+
+#define ISPCCDC_SDOFST_FINV			(1 << 14)
+#define ISPCCDC_SDOFST_FOFST_1L			0
+#define ISPCCDC_SDOFST_FOFST_4L			(3 << 12)
+#define ISPCCDC_SDOFST_LOFST3_SHIFT		0
+#define ISPCCDC_SDOFST_LOFST2_SHIFT		3
+#define ISPCCDC_SDOFST_LOFST1_SHIFT		6
+#define ISPCCDC_SDOFST_LOFST0_SHIFT		9
+#define EVENEVEN				1
+#define ODDEVEN					2
+#define EVENODD					3
+#define ODDODD					4
+
+#define ISPCCDC_CLAMP_OBGAIN_SHIFT		0
+#define ISPCCDC_CLAMP_OBST_SHIFT		10
+#define ISPCCDC_CLAMP_OBSLN_SHIFT		25
+#define ISPCCDC_CLAMP_OBSLEN_SHIFT		28
+#define ISPCCDC_CLAMP_CLAMPEN			(1 << 31)
+
+#define ISPCCDC_COLPTN_R_Ye			0x0
+#define ISPCCDC_COLPTN_Gr_Cy			0x1
+#define ISPCCDC_COLPTN_Gb_G			0x2
+#define ISPCCDC_COLPTN_B_Mg			0x3
+#define ISPCCDC_COLPTN_CP0PLC0_SHIFT		0
+#define ISPCCDC_COLPTN_CP0PLC1_SHIFT		2
+#define ISPCCDC_COLPTN_CP0PLC2_SHIFT		4
+#define ISPCCDC_COLPTN_CP0PLC3_SHIFT		6
+#define ISPCCDC_COLPTN_CP1PLC0_SHIFT		8
+#define ISPCCDC_COLPTN_CP1PLC1_SHIFT		10
+#define ISPCCDC_COLPTN_CP1PLC2_SHIFT		12
+#define ISPCCDC_COLPTN_CP1PLC3_SHIFT		14
+#define ISPCCDC_COLPTN_CP2PLC0_SHIFT		16
+#define ISPCCDC_COLPTN_CP2PLC1_SHIFT		18
+#define ISPCCDC_COLPTN_CP2PLC2_SHIFT		20
+#define ISPCCDC_COLPTN_CP2PLC3_SHIFT		22
+#define ISPCCDC_COLPTN_CP3PLC0_SHIFT		24
+#define ISPCCDC_COLPTN_CP3PLC1_SHIFT		26
+#define ISPCCDC_COLPTN_CP3PLC2_SHIFT		28
+#define ISPCCDC_COLPTN_CP3PLC3_SHIFT		30
+
+#define ISPCCDC_BLKCMP_B_MG_SHIFT		0
+#define ISPCCDC_BLKCMP_GB_G_SHIFT		8
+#define ISPCCDC_BLKCMP_GR_CY_SHIFT		16
+#define ISPCCDC_BLKCMP_R_YE_SHIFT		24
+
+#define ISPCCDC_FPC_FPNUM_SHIFT			0
+#define ISPCCDC_FPC_FPCEN			(1 << 15)
+#define ISPCCDC_FPC_FPERR			(1 << 16)
+
+#define ISPCCDC_VDINT_1_SHIFT			0
+#define ISPCCDC_VDINT_0_SHIFT			16
+#define ISPCCDC_VDINT_0_MASK			0x7FFF
+#define ISPCCDC_VDINT_1_MASK			0x7FFF
+
+#define ISPCCDC_ALAW_GWDI_SHIFT			0
+#define ISPCCDC_ALAW_CCDTBL			(1 << 3)
+
+#define ISPCCDC_REC656IF_R656ON			1
+#define ISPCCDC_REC656IF_ECCFVH			(1 << 1)
+
+#define ISPCCDC_CFG_BW656			(1 << 5)
+#define ISPCCDC_CFG_FIDMD_SHIFT			6
+#define ISPCCDC_CFG_WENLOG			(1 << 8)
+#define ISPCCDC_CFG_WENLOG_AND			(0 << 8)
+#define ISPCCDC_CFG_WENLOG_OR		(1 << 8)
+#define ISPCCDC_CFG_Y8POS			(1 << 11)
+#define ISPCCDC_CFG_BSWD			(1 << 12)
+#define ISPCCDC_CFG_MSBINVI			(1 << 13)
+#define ISPCCDC_CFG_VDLC			(1 << 15)
+
+#define ISPCCDC_FMTCFG_FMTEN			0x1
+#define ISPCCDC_FMTCFG_LNALT			(1 << 1)
+#define ISPCCDC_FMTCFG_LNUM_SHIFT		2
+#define ISPCCDC_FMTCFG_PLEN_ODD_SHIFT		4
+#define ISPCCDC_FMTCFG_PLEN_EVEN_SHIFT		8
+#define ISPCCDC_FMTCFG_VPIN_MASK		0xFFFF8000
+#define ISPCCDC_FMTCFG_VPIN_12_3		(0x3 << 12)
+#define ISPCCDC_FMTCFG_VPIN_11_2		(0x4 << 12)
+#define ISPCCDC_FMTCFG_VPIN_10_1		(0x5 << 12)
+#define ISPCCDC_FMTCFG_VPIN_9_0			(0x6 << 12)
+#define ISPCCDC_FMTCFG_VPEN			(1 << 15)
+
+#define ISPCCDC_FMTCF_VPIF_FRQ_MASK		0xFFF8FFFF
+#define ISPCCDC_FMTCF_VPIF_FRQ_BY2		(0x0 << 16)
+#define ISPCCDC_FMTCF_VPIF_FRQ_BY3		(0x1 << 16)
+#define ISPCCDC_FMTCF_VPIF_FRQ_BY4		(0x2 << 16)
+#define ISPCCDC_FMTCF_VPIF_FRQ_BY5		(0x3 << 16)
+#define ISPCCDC_FMTCF_VPIF_FRQ_BY6		(0x4 << 16)
+
+#define ISPCCDC_FMT_HORZ_FMTLNH_SHIFT		0
+#define ISPCCDC_FMT_HORZ_FMTSPH_SHIFT		16
+
+#define ISPCCDC_FMT_VERT_FMTLNV_SHIFT		0
+#define ISPCCDC_FMT_VERT_FMTSLV_SHIFT		16
+
+#define ISPCCDC_FMT_HORZ_FMTSPH_MASK		0x1FFF0000
+#define ISPCCDC_FMT_HORZ_FMTLNH_MASK		0x1FFF
+
+#define ISPCCDC_FMT_VERT_FMTSLV_MASK		0x1FFF0000
+#define ISPCCDC_FMT_VERT_FMTLNV_MASK		0x1FFF
+
+#define ISPCCDC_VP_OUT_HORZ_ST_SHIFT		0
+#define ISPCCDC_VP_OUT_HORZ_NUM_SHIFT		4
+#define ISPCCDC_VP_OUT_VERT_NUM_SHIFT		17
+
+#define ISPRSZ_PID_PREV_SHIFT			0
+#define ISPRSZ_PID_CID_SHIFT			8
+#define ISPRSZ_PID_TID_SHIFT			16
+
+#define ISPRSZ_PCR_ENABLE			0x5
+#define ISPRSZ_PCR_BUSY				(1 << 1)
+
+#define ISPRSZ_CNT_HRSZ_SHIFT			0
+#define ISPRSZ_CNT_HRSZ_MASK			0x3FF
+#define ISPRSZ_CNT_VRSZ_SHIFT			10
+#define ISPRSZ_CNT_VRSZ_MASK			0xFFC00
+#define ISPRSZ_CNT_HSTPH_SHIFT			20
+#define ISPRSZ_CNT_HSTPH_MASK			0x700000
+#define ISPRSZ_CNT_VSTPH_SHIFT			23
+#define	ISPRSZ_CNT_VSTPH_MASK			0x3800000
+#define	ISPRSZ_CNT_CBILIN_MASK			0x20000000
+#define	ISPRSZ_CNT_INPTYP_MASK			0x08000000
+#define	ISPRSZ_CNT_PIXFMT_MASK			0x04000000
+#define ISPRSZ_CNT_YCPOS			(1 << 26)
+#define ISPRSZ_CNT_INPTYP			(1 << 27)
+#define ISPRSZ_CNT_INPSRC			(1 << 28)
+#define ISPRSZ_CNT_CBILIN			(1 << 29)
+
+#define ISPRSZ_OUT_SIZE_HORZ_SHIFT		0
+#define ISPRSZ_OUT_SIZE_HORZ_MASK		0x7FF
+#define ISPRSZ_OUT_SIZE_VERT_SHIFT		16
+#define ISPRSZ_OUT_SIZE_VERT_MASK		0x7FF0000
+
+
+#define ISPRSZ_IN_START_HORZ_ST_SHIFT		0
+#define ISPRSZ_IN_START_HORZ_ST_MASK		0x1FFF
+#define ISPRSZ_IN_START_VERT_ST_SHIFT		16
+#define ISPRSZ_IN_START_VERT_ST_MASK		0x1FFF0000
+
+
+#define ISPRSZ_IN_SIZE_HORZ_SHIFT		0
+#define ISPRSZ_IN_SIZE_HORZ_MASK		0x1FFF
+#define ISPRSZ_IN_SIZE_VERT_SHIFT		16
+#define ISPRSZ_IN_SIZE_VERT_MASK		0x1FFF0000
+
+#define ISPRSZ_SDR_INADD_ADDR_SHIFT		0
+#define ISPRSZ_SDR_INADD_ADDR_MASK		0xFFFFFFFF
+
+#define ISPRSZ_SDR_INOFF_OFFSET_SHIFT		0
+#define ISPRSZ_SDR_INOFF_OFFSET_MASK		0xFFFF
+
+#define ISPRSZ_SDR_OUTADD_ADDR_SHIFT		0
+#define ISPRSZ_SDR_OUTADD_ADDR_MASK		0xFFFFFFFF
+
+
+#define ISPRSZ_SDR_OUTOFF_OFFSET_SHIFT		0
+#define ISPRSZ_SDR_OUTOFF_OFFSET_MASK		0xFFFF
+
+#define ISPRSZ_HFILT10_COEF0_SHIFT		0
+#define ISPRSZ_HFILT10_COEF0_MASK		0x3FF
+#define ISPRSZ_HFILT10_COEF1_SHIFT		16
+#define ISPRSZ_HFILT10_COEF1_MASK		0x3FF0000
+
+#define ISPRSZ_HFILT32_COEF2_SHIFT		0
+#define ISPRSZ_HFILT32_COEF2_MASK		0x3FF
+#define ISPRSZ_HFILT32_COEF3_SHIFT		16
+#define ISPRSZ_HFILT32_COEF3_MASK		0x3FF0000
+
+#define ISPRSZ_HFILT54_COEF4_SHIFT		0
+#define ISPRSZ_HFILT54_COEF4_MASK		0x3FF
+#define ISPRSZ_HFILT54_COEF5_SHIFT		16
+#define ISPRSZ_HFILT54_COEF5_MASK		0x3FF0000
+
+#define ISPRSZ_HFILT76_COEFF6_SHIFT		0
+#define ISPRSZ_HFILT76_COEFF6_MASK		0x3FF
+#define ISPRSZ_HFILT76_COEFF7_SHIFT		16
+#define ISPRSZ_HFILT76_COEFF7_MASK		0x3FF0000
+
+#define ISPRSZ_HFILT98_COEFF8_SHIFT		0
+#define ISPRSZ_HFILT98_COEFF8_MASK		0x3FF
+#define ISPRSZ_HFILT98_COEFF9_SHIFT		16
+#define ISPRSZ_HFILT98_COEFF9_MASK		0x3FF0000
+
+#define ISPRSZ_HFILT1110_COEF10_SHIFT		0
+#define ISPRSZ_HFILT1110_COEF10_MASK		0x3FF
+#define ISPRSZ_HFILT1110_COEF11_SHIFT		16
+#define ISPRSZ_HFILT1110_COEF11_MASK		0x3FF0000
+
+#define ISPRSZ_HFILT1312_COEFF12_SHIFT		0
+#define ISPRSZ_HFILT1312_COEFF12_MASK		0x3FF
+#define ISPRSZ_HFILT1312_COEFF13_SHIFT		16
+#define ISPRSZ_HFILT1312_COEFF13_MASK		0x3FF0000
+
+#define ISPRSZ_HFILT1514_COEFF14_SHIFT		0
+#define ISPRSZ_HFILT1514_COEFF14_MASK		0x3FF
+#define ISPRSZ_HFILT1514_COEFF15_SHIFT		16
+#define ISPRSZ_HFILT1514_COEFF15_MASK		0x3FF0000
+
+#define ISPRSZ_HFILT1716_COEF16_SHIFT		0
+#define ISPRSZ_HFILT1716_COEF16_MASK		0x3FF
+#define ISPRSZ_HFILT1716_COEF17_SHIFT		16
+#define ISPRSZ_HFILT1716_COEF17_MASK		0x3FF0000
+
+#define ISPRSZ_HFILT1918_COEF18_SHIFT		0
+#define ISPRSZ_HFILT1918_COEF18_MASK		0x3FF
+#define ISPRSZ_HFILT1918_COEF19_SHIFT		16
+#define ISPRSZ_HFILT1918_COEF19_MASK		0x3FF0000
+
+#define ISPRSZ_HFILT2120_COEF20_SHIFT		0
+#define ISPRSZ_HFILT2120_COEF20_MASK		0x3FF
+#define ISPRSZ_HFILT2120_COEF21_SHIFT		16
+#define ISPRSZ_HFILT2120_COEF21_MASK		0x3FF0000
+
+#define ISPRSZ_HFILT2322_COEF22_SHIFT		0
+#define ISPRSZ_HFILT2322_COEF22_MASK		0x3FF
+#define ISPRSZ_HFILT2322_COEF23_SHIFT		16
+#define ISPRSZ_HFILT2322_COEF23_MASK		0x3FF0000
+
+#define ISPRSZ_HFILT2524_COEF24_SHIFT		0
+#define ISPRSZ_HFILT2524_COEF24_MASK		0x3FF
+#define ISPRSZ_HFILT2524_COEF25_SHIFT		16
+#define ISPRSZ_HFILT2524_COEF25_MASK		0x3FF0000
+
+#define ISPRSZ_HFILT2726_COEF26_SHIFT		0
+#define ISPRSZ_HFILT2726_COEF26_MASK		0x3FF
+#define ISPRSZ_HFILT2726_COEF27_SHIFT		16
+#define ISPRSZ_HFILT2726_COEF27_MASK		0x3FF0000
+
+#define ISPRSZ_HFILT2928_COEF28_SHIFT		0
+#define ISPRSZ_HFILT2928_COEF28_MASK		0x3FF
+#define ISPRSZ_HFILT2928_COEF29_SHIFT		16
+#define ISPRSZ_HFILT2928_COEF29_MASK		0x3FF0000
+
+#define ISPRSZ_HFILT3130_COEF30_SHIFT		0
+#define ISPRSZ_HFILT3130_COEF30_MASK		0x3FF
+#define ISPRSZ_HFILT3130_COEF31_SHIFT		16
+#define ISPRSZ_HFILT3130_COEF31_MASK		0x3FF0000
+
+#define ISPRSZ_VFILT10_COEF0_SHIFT		0
+#define ISPRSZ_VFILT10_COEF0_MASK		0x3FF
+#define ISPRSZ_VFILT10_COEF1_SHIFT		16
+#define ISPRSZ_VFILT10_COEF1_MASK		0x3FF0000
+
+#define ISPRSZ_VFILT32_COEF2_SHIFT		0
+#define ISPRSZ_VFILT32_COEF2_MASK		0x3FF
+#define ISPRSZ_VFILT32_COEF3_SHIFT		16
+#define ISPRSZ_VFILT32_COEF3_MASK		0x3FF0000
+
+#define ISPRSZ_VFILT54_COEF4_SHIFT		0
+#define ISPRSZ_VFILT54_COEF4_MASK		0x3FF
+#define ISPRSZ_VFILT54_COEF5_SHIFT		16
+#define ISPRSZ_VFILT54_COEF5_MASK		0x3FF0000
+
+#define ISPRSZ_VFILT76_COEFF6_SHIFT		0
+#define ISPRSZ_VFILT76_COEFF6_MASK		0x3FF
+#define ISPRSZ_VFILT76_COEFF7_SHIFT		16
+#define ISPRSZ_VFILT76_COEFF7_MASK		0x3FF0000
+
+#define ISPRSZ_VFILT98_COEFF8_SHIFT		0
+#define ISPRSZ_VFILT98_COEFF8_MASK		0x3FF
+#define ISPRSZ_VFILT98_COEFF9_SHIFT		16
+#define ISPRSZ_VFILT98_COEFF9_MASK		0x3FF0000
+
+#define ISPRSZ_VFILT1110_COEF10_SHIFT		0
+#define ISPRSZ_VFILT1110_COEF10_MASK		0x3FF
+#define ISPRSZ_VFILT1110_COEF11_SHIFT		16
+#define ISPRSZ_VFILT1110_COEF11_MASK		0x3FF0000
+
+#define ISPRSZ_VFILT1312_COEFF12_SHIFT		0
+#define ISPRSZ_VFILT1312_COEFF12_MASK		0x3FF
+#define ISPRSZ_VFILT1312_COEFF13_SHIFT		16
+#define ISPRSZ_VFILT1312_COEFF13_MASK		0x3FF0000
+
+#define ISPRSZ_VFILT1514_COEFF14_SHIFT		0
+#define ISPRSZ_VFILT1514_COEFF14_MASK		0x3FF
+#define ISPRSZ_VFILT1514_COEFF15_SHIFT		16
+#define ISPRSZ_VFILT1514_COEFF15_MASK		0x3FF0000
+
+#define ISPRSZ_VFILT1716_COEF16_SHIFT		0
+#define ISPRSZ_VFILT1716_COEF16_MASK		0x3FF
+#define ISPRSZ_VFILT1716_COEF17_SHIFT		16
+#define ISPRSZ_VFILT1716_COEF17_MASK		0x3FF0000
+
+#define ISPRSZ_VFILT1918_COEF18_SHIFT		0
+#define ISPRSZ_VFILT1918_COEF18_MASK		0x3FF
+#define ISPRSZ_VFILT1918_COEF19_SHIFT		16
+#define ISPRSZ_VFILT1918_COEF19_MASK		0x3FF0000
+
+#define ISPRSZ_VFILT2120_COEF20_SHIFT		0
+#define ISPRSZ_VFILT2120_COEF20_MASK		0x3FF
+#define ISPRSZ_VFILT2120_COEF21_SHIFT		16
+#define ISPRSZ_VFILT2120_COEF21_MASK		0x3FF0000
+
+#define ISPRSZ_VFILT2322_COEF22_SHIFT		0
+#define ISPRSZ_VFILT2322_COEF22_MASK		0x3FF
+#define ISPRSZ_VFILT2322_COEF23_SHIFT		16
+#define ISPRSZ_VFILT2322_COEF23_MASK		0x3FF0000
+
+#define ISPRSZ_VFILT2524_COEF24_SHIFT		0
+#define ISPRSZ_VFILT2524_COEF24_MASK		0x3FF
+#define ISPRSZ_VFILT2524_COEF25_SHIFT		16
+#define ISPRSZ_VFILT2524_COEF25_MASK		0x3FF0000
+
+#define ISPRSZ_VFILT2726_COEF26_SHIFT		0
+#define ISPRSZ_VFILT2726_COEF26_MASK		0x3FF
+#define ISPRSZ_VFILT2726_COEF27_SHIFT		16
+#define ISPRSZ_VFILT2726_COEF27_MASK		0x3FF0000
+
+#define ISPRSZ_VFILT2928_COEF28_SHIFT		0
+#define ISPRSZ_VFILT2928_COEF28_MASK		0x3FF
+#define ISPRSZ_VFILT2928_COEF29_SHIFT		16
+#define ISPRSZ_VFILT2928_COEF29_MASK		0x3FF0000
+
+#define ISPRSZ_VFILT3130_COEF30_SHIFT		0
+#define ISPRSZ_VFILT3130_COEF30_MASK		0x3FF
+#define ISPRSZ_VFILT3130_COEF31_SHIFT		16
+#define ISPRSZ_VFILT3130_COEF31_MASK		0x3FF0000
+
+#define ISPRSZ_YENH_CORE_SHIFT			0
+#define ISPRSZ_YENH_CORE_MASK			0xFF
+#define ISPRSZ_YENH_SLOP_SHIFT			8
+#define ISPRSZ_YENH_SLOP_MASK			0xF00
+#define ISPRSZ_YENH_GAIN_SHIFT			12
+#define ISPRSZ_YENH_GAIN_MASK			0xF000
+#define ISPRSZ_YENH_ALGO_SHIFT			16
+#define ISPRSZ_YENH_ALGO_MASK			0x30000
+
+#define ISPH3A_PCR_AEW_ALAW_EN_SHIFT		1
+#define ISPH3A_PCR_AF_MED_TH_SHIFT		3
+#define ISPH3A_PCR_AF_RGBPOS_SHIFT		11
+#define ISPH3A_PCR_AEW_AVE2LMT_SHIFT		22
+#define ISPH3A_PCR_AEW_AVE2LMT_MASK		0xFFC00000
+#define ISPH3A_PCR_BUSYAF			(1 << 15)
+#define ISPH3A_PCR_BUSYAEAWB			(1 << 18)
+
+#define ISPH3A_AEWWIN1_WINHC_SHIFT		0
+#define ISPH3A_AEWWIN1_WINHC_MASK		0x3F
+#define ISPH3A_AEWWIN1_WINVC_SHIFT		6
+#define ISPH3A_AEWWIN1_WINVC_MASK		0x1FC0
+#define ISPH3A_AEWWIN1_WINW_SHIFT		13
+#define ISPH3A_AEWWIN1_WINW_MASK		0xFE000
+#define ISPH3A_AEWWIN1_WINH_SHIFT		24
+#define ISPH3A_AEWWIN1_WINH_MASK		0x7F000000
+
+#define ISPH3A_AEWINSTART_WINSH_SHIFT		0
+#define ISPH3A_AEWINSTART_WINSH_MASK		0x0FFF
+#define ISPH3A_AEWINSTART_WINSV_SHIFT		16
+#define ISPH3A_AEWINSTART_WINSV_MASK		0x0FFF0000
+
+#define ISPH3A_AEWINBLK_WINH_SHIFT		0
+#define ISPH3A_AEWINBLK_WINH_MASK		0x7F
+#define ISPH3A_AEWINBLK_WINSV_SHIFT		16
+#define ISPH3A_AEWINBLK_WINSV_MASK		0x0FFF0000
+
+#define ISPH3A_AEWSUBWIN_AEWINCH_SHIFT		0
+#define ISPH3A_AEWSUBWIN_AEWINCH_MASK		0x0F
+#define ISPH3A_AEWSUBWIN_AEWINCV_SHIFT		8
+#define ISPH3A_AEWSUBWIN_AEWINCV_MASK		0x0F00
+
+#define ISPHIST_PCR_ENABLE_SHIFT	0
+#define ISPHIST_PCR_ENABLE_MASK		0x01
+#define ISPHIST_PCR_BUSY		0x02
+
+#define ISPHIST_CNT_DATASIZE_SHIFT	8
+#define ISPHIST_CNT_DATASIZE_MASK	0x0100
+#define ISPHIST_CNT_CLEAR_SHIFT		7
+#define ISPHIST_CNT_CLEAR_MASK		0x080
+#define ISPHIST_CNT_CFA_SHIFT		6
+#define ISPHIST_CNT_CFA_MASK		0x040
+#define ISPHIST_CNT_BINS_SHIFT		4
+#define ISPHIST_CNT_BINS_MASK		0x030
+#define ISPHIST_CNT_SOURCE_SHIFT	3
+#define ISPHIST_CNT_SOURCE_MASK		0x08
+#define ISPHIST_CNT_SHIFT_SHIFT		0
+#define ISPHIST_CNT_SHIFT_MASK		0x07
+
+#define ISPHIST_WB_GAIN_WG00_SHIFT	24
+#define ISPHIST_WB_GAIN_WG00_MASK	0xFF000000
+#define ISPHIST_WB_GAIN_WG01_SHIFT	16
+#define ISPHIST_WB_GAIN_WG01_MASK	0xFF0000
+#define ISPHIST_WB_GAIN_WG02_SHIFT	8
+#define ISPHIST_WB_GAIN_WG02_MASK	0xFF00
+#define ISPHIST_WB_GAIN_WG03_SHIFT	0
+#define ISPHIST_WB_GAIN_WG03_MASK	0xFF
+
+#define ISPHIST_REGHORIZ_HSTART_SHIFT		16	/*
+							* REGION 0 to 3 HORZ
+							* and VERT
+							*/
+#define ISPHIST_REGHORIZ_HSTART_MASK		0x3FFF0000
+#define ISPHIST_REGHORIZ_HEND_SHIFT		0
+#define ISPHIST_REGHORIZ_HEND_MASK		0x3FFF
+#define ISPHIST_REGVERT_VSTART_SHIFT		16
+#define ISPHIST_REGVERT_VSTART_MASK		0x3FFF0000
+#define ISPHIST_REGVERT_VEND_SHIFT		0
+#define ISPHIST_REGVERT_VEND_MASK		0x3FFF
+
+#define ISPHIST_REGHORIZ_MASK			0x3FFF3FFF
+#define ISPHIST_REGVERT_MASK			0x3FFF3FFF
+
+#define ISPHIST_ADDR_SHIFT			0
+#define ISPHIST_ADDR_MASK			0x3FF
+
+#define ISPHIST_DATA_SHIFT			0
+#define ISPHIST_DATA_MASK			0xFFFFF
+
+#define ISPHIST_RADD_SHIFT			0
+#define ISPHIST_RADD_MASK			0xFFFFFFFF
+
+#define ISPHIST_RADD_OFF_SHIFT			0
+#define ISPHIST_RADD_OFF_MASK			0xFFFF
+
+#define ISPHIST_HV_INFO_HSIZE_SHIFT		16
+#define ISPHIST_HV_INFO_HSIZE_MASK		0x3FFF0000
+#define ISPHIST_HV_INFO_VSIZE_SHIFT		0
+#define ISPHIST_HV_INFO_VSIZE_MASK		0x3FFF
+
+#define ISPHIST_HV_INFO_MASK			0x3FFF3FFF
+
+#define ISPCCDC_LSC_GAIN_MODE_N_MASK		0x700
+#define ISPCCDC_LSC_GAIN_MODE_N_SHIFT		8
+#define ISPCCDC_LSC_GAIN_MODE_M_MASK		0x3800
+#define ISPCCDC_LSC_GAIN_MODE_M_SHIFT		12
+#define ISPCCDC_LSC_GAIN_FORMAT_MASK		0xE
+#define ISPCCDC_LSC_GAIN_FORMAT_SHIFT		1
+#define ISPCCDC_LSC_AFTER_REFORMATTER_MASK	(1<<6)
+
+#define ISPCCDC_LSC_INITIAL_X_MASK		0x3F
+#define ISPCCDC_LSC_INITIAL_X_SHIFT		0
+#define ISPCCDC_LSC_INITIAL_Y_MASK		0x3F0000
+#define ISPCCDC_LSC_INITIAL_Y_SHIFT		16
+
+#define ISPMMU_REVISION_REV_MINOR_MASK		0xF
+#define ISPMMU_REVISION_REV_MAJOR_SHIFT		0x4
+
+#define IRQENABLE_MULTIHITFAULT			(1<<4)
+#define IRQENABLE_TWFAULT			(1<<3)
+#define IRQENABLE_EMUMISS			(1<<2)
+#define IRQENABLE_TRANSLNFAULT			(1<<1)
+#define IRQENABLE_TLBMISS			(1)
+
+#define ISPMMU_MMUCNTL_MMU_EN			(1<<1)
+#define ISPMMU_MMUCNTL_TWL_EN			(1<<2)
+#define ISPMMU_MMUCNTL_EMUTLBUPDATE		(1<<3)
+#define ISPMMU_AUTOIDLE				0x1
+#define ISPMMU_SIDLEMODE_FORCEIDLE		0
+#define ISPMMU_SIDLEMODE_NOIDLE			1
+#define ISPMMU_SIDLEMODE_SMARTIDLE		2
+#define ISPMMU_SIDLEMODE_SHIFT			3
+
+#define ISPCSI1_AUTOIDLE			0x1
+#define ISPCSI1_MIDLEMODE_SHIFT			12
+#define ISPCSI1_MIDLEMODE_FORCESTANDBY		0x0
+#define ISPCSI1_MIDLEMODE_NOSTANDBY		0x1
+#define ISPCSI1_MIDLEMODE_SMARTSTANDBY		0x2
+
+/* CSI2 receiver registers (ES2.0) */
+#define ISPCSI2_REVISION			(0x000)
+#define ISPCSI2_SYSCONFIG			(0x010)
+#define ISPCSI2_SYSCONFIG_MSTANDBY_MODE_SHIFT	12
+#define ISPCSI2_SYSCONFIG_MSTANDBY_MODE_MASK \
+				(0x3 << ISPCSI2_SYSCONFIG_MSTANDBY_MODE_SHIFT)
+#define ISPCSI2_SYSCONFIG_MSTANDBY_MODE_FORCE \
+				(0x0 << ISPCSI2_SYSCONFIG_MSTANDBY_MODE_SHIFT)
+#define ISPCSI2_SYSCONFIG_MSTANDBY_MODE_NO \
+				(0x1 << ISPCSI2_SYSCONFIG_MSTANDBY_MODE_SHIFT)
+#define ISPCSI2_SYSCONFIG_MSTANDBY_MODE_SMART \
+				(0x2 << ISPCSI2_SYSCONFIG_MSTANDBY_MODE_SHIFT)
+#define ISPCSI2_SYSCONFIG_SOFT_RESET_SHIFT	1
+#define ISPCSI2_SYSCONFIG_SOFT_RESET_MASK \
+				(0x1 << ISPCSI2_SYSCONFIG_SOFT_RESET_SHIFT)
+#define ISPCSI2_SYSCONFIG_SOFT_RESET_NORMAL \
+				(0x0 << ISPCSI2_SYSCONFIG_SOFT_RESET_SHIFT)
+#define ISPCSI2_SYSCONFIG_SOFT_RESET_RESET \
+				(0x1 << ISPCSI2_SYSCONFIG_SOFT_RESET_SHIFT)
+#define ISPCSI2_SYSCONFIG_AUTO_IDLE_SHIFT	0
+#define ISPCSI2_SYSCONFIG_AUTO_IDLE_MASK \
+				(0x1 << ISPCSI2_SYSCONFIG_AUTO_IDLE_SHIFT)
+#define ISPCSI2_SYSCONFIG_AUTO_IDLE_FREE \
+				(0x0 << ISPCSI2_SYSCONFIG_AUTO_IDLE_SHIFT)
+#define ISPCSI2_SYSCONFIG_AUTO_IDLE_AUTO \
+				(0x1 << ISPCSI2_SYSCONFIG_AUTO_IDLE_SHIFT)
+#define ISPCSI2_SYSSTATUS			(0x014)
+#define ISPCSI2_SYSSTATUS_RESET_DONE_SHIFT	0
+#define ISPCSI2_SYSSTATUS_RESET_DONE_MASK \
+				(0x1 << ISPCSI2_SYSSTATUS_RESET_DONE_SHIFT)
+#define ISPCSI2_SYSSTATUS_RESET_DONE_ONGOING \
+				(0x0 << ISPCSI2_SYSSTATUS_RESET_DONE_SHIFT)
+#define ISPCSI2_SYSSTATUS_RESET_DONE_DONE \
+				(0x1 << ISPCSI2_SYSSTATUS_RESET_DONE_SHIFT)
+#define ISPCSI2_IRQSTATUS				(0x018)
+#define ISPCSI2_IRQSTATUS_OCP_ERR_IRQ			(1 << 14)
+#define ISPCSI2_IRQSTATUS_SHORT_PACKET_IRQ		(1 << 13)
+#define ISPCSI2_IRQSTATUS_ECC_CORRECTION_IRQ		(1 << 12)
+#define ISPCSI2_IRQSTATUS_ECC_NO_CORRECTION_IRQ		(1 << 11)
+#define ISPCSI2_IRQSTATUS_COMPLEXIO2_ERR_IRQ		(1 << 10)
+#define ISPCSI2_IRQSTATUS_COMPLEXIO1_ERR_IRQ		(1 << 9)
+#define ISPCSI2_IRQSTATUS_FIFO_OVF_IRQ			(1 << 8)
+#define ISPCSI2_IRQSTATUS_CONTEXT(n)			(1 << (n))
+
+#define ISPCSI2_IRQENABLE			(0x01C)
+#define ISPCSI2_CTRL				(0x040)
+#define ISPCSI2_CTRL_VP_CLK_EN_SHIFT	15
+#define ISPCSI2_CTRL_VP_CLK_EN_MASK	(0x1 << ISPCSI2_CTRL_VP_CLK_EN_SHIFT)
+#define ISPCSI2_CTRL_VP_CLK_EN_DISABLE	(0x0 << ISPCSI2_CTRL_VP_CLK_EN_SHIFT)
+#define ISPCSI2_CTRL_VP_CLK_EN_ENABLE	(0x1 << ISPCSI2_CTRL_VP_CLK_EN_SHIFT)
+
+#define ISPCSI2_CTRL_VP_ONLY_EN_SHIFT	11
+#define ISPCSI2_CTRL_VP_ONLY_EN_MASK	(0x1 << ISPCSI2_CTRL_VP_ONLY_EN_SHIFT)
+#define ISPCSI2_CTRL_VP_ONLY_EN_DISABLE	(0x0 << ISPCSI2_CTRL_VP_ONLY_EN_SHIFT)
+#define ISPCSI2_CTRL_VP_ONLY_EN_ENABLE	(0x1 << ISPCSI2_CTRL_VP_ONLY_EN_SHIFT)
+
+#define ISPCSI2_CTRL_VP_OUT_CTRL_SHIFT		8
+#define ISPCSI2_CTRL_VP_OUT_CTRL_MASK		(0x3 << \
+						ISPCSI2_CTRL_VP_OUT_CTRL_SHIFT)
+#define ISPCSI2_CTRL_VP_OUT_CTRL_DISABLE	(0x0 << \
+						ISPCSI2_CTRL_VP_OUT_CTRL_SHIFT)
+#define ISPCSI2_CTRL_VP_OUT_CTRL_DIV2		(0x1 << \
+						ISPCSI2_CTRL_VP_OUT_CTRL_SHIFT)
+#define ISPCSI2_CTRL_VP_OUT_CTRL_DIV3		(0x2 << \
+						ISPCSI2_CTRL_VP_OUT_CTRL_SHIFT)
+#define ISPCSI2_CTRL_VP_OUT_CTRL_DIV4		(0x3 << \
+						ISPCSI2_CTRL_VP_OUT_CTRL_SHIFT)
+
+#define ISPCSI2_CTRL_DBG_EN_SHIFT	7
+#define ISPCSI2_CTRL_DBG_EN_MASK	(0x1 << ISPCSI2_CTRL_DBG_EN_SHIFT)
+#define ISPCSI2_CTRL_DBG_EN_DISABLE	(0x0 << ISPCSI2_CTRL_DBG_EN_SHIFT)
+#define ISPCSI2_CTRL_DBG_EN_ENABLE	(0x1 << ISPCSI2_CTRL_DBG_EN_SHIFT)
+
+#define ISPCSI2_CTRL_BURST_SIZE_SHIFT		5
+#define ISPCSI2_CTRL_BURST_SIZE_MASK		(0x3 << \
+						ISPCSI2_CTRL_BURST_SIZE_SHIFT)
+#define ISPCSI2_CTRL_BURST_SIZE_MYSTERY_VAL		(0x2 << \
+						ISPCSI2_CTRL_BURST_SIZE_SHIFT)
+
+#define ISPCSI2_CTRL_FRAME_SHIFT	3
+#define ISPCSI2_CTRL_FRAME_MASK		(0x1 << ISPCSI2_CTRL_FRAME_SHIFT)
+#define ISPCSI2_CTRL_FRAME_DISABLE_IMM	(0x0 << ISPCSI2_CTRL_FRAME_SHIFT)
+#define ISPCSI2_CTRL_FRAME_DISABLE_FEC	(0x1 << ISPCSI2_CTRL_FRAME_SHIFT)
+
+#define ISPCSI2_CTRL_ECC_EN_SHIFT	2
+#define ISPCSI2_CTRL_ECC_EN_MASK	(0x1 << ISPCSI2_CTRL_ECC_EN_SHIFT)
+#define ISPCSI2_CTRL_ECC_EN_DISABLE	(0x0 << ISPCSI2_CTRL_ECC_EN_SHIFT)
+#define ISPCSI2_CTRL_ECC_EN_ENABLE	(0x1 << ISPCSI2_CTRL_ECC_EN_SHIFT)
+
+#define ISPCSI2_CTRL_SECURE_SHIFT	1
+#define ISPCSI2_CTRL_SECURE_MASK	(0x1 << ISPCSI2_CTRL_SECURE_SHIFT)
+#define ISPCSI2_CTRL_SECURE_DISABLE	(0x0 << ISPCSI2_CTRL_SECURE_SHIFT)
+#define ISPCSI2_CTRL_SECURE_ENABLE	(0x1 << ISPCSI2_CTRL_SECURE_SHIFT)
+
+#define ISPCSI2_CTRL_IF_EN_SHIFT	0
+#define ISPCSI2_CTRL_IF_EN_MASK		(0x1 << ISPCSI2_CTRL_IF_EN_SHIFT)
+#define ISPCSI2_CTRL_IF_EN_DISABLE	(0x0 << ISPCSI2_CTRL_IF_EN_SHIFT)
+#define ISPCSI2_CTRL_IF_EN_ENABLE	(0x1 << ISPCSI2_CTRL_IF_EN_SHIFT)
+
+#define ISPCSI2_DBG_H				(0x044)
+#define ISPCSI2_GNQ				(0x048)
+#define ISPCSI2_COMPLEXIO_CFG1			(0x050)
+#define ISPCSI2_COMPLEXIO_CFG1_RESET_DONE_SHIFT		29
+#define ISPCSI2_COMPLEXIO_CFG1_RESET_DONE_MASK \
+			(0x1 << ISPCSI2_COMPLEXIO_CFG1_RESET_DONE_SHIFT)
+#define ISPCSI2_COMPLEXIO_CFG1_RESET_DONE_ONGOING \
+			(0x0 << ISPCSI2_COMPLEXIO_CFG1_RESET_DONE_SHIFT)
+#define ISPCSI2_COMPLEXIO_CFG1_RESET_DONE_DONE \
+			(0x1 << ISPCSI2_COMPLEXIO_CFG1_RESET_DONE_SHIFT)
+#define ISPCSI2_COMPLEXIO_CFG1_PWR_CMD_SHIFT		27
+#define ISPCSI2_COMPLEXIO_CFG1_PWR_CMD_MASK \
+			(0x3 << ISPCSI2_COMPLEXIO_CFG1_PWR_CMD_SHIFT)
+#define ISPCSI2_COMPLEXIO_CFG1_PWR_CMD_OFF \
+			(0x0 << ISPCSI2_COMPLEXIO_CFG1_PWR_CMD_SHIFT)
+#define ISPCSI2_COMPLEXIO_CFG1_PWR_CMD_ON \
+			(0x1 << ISPCSI2_COMPLEXIO_CFG1_PWR_CMD_SHIFT)
+#define ISPCSI2_COMPLEXIO_CFG1_PWR_CMD_ULPW \
+			(0x2 << ISPCSI2_COMPLEXIO_CFG1_PWR_CMD_SHIFT)
+#define ISPCSI2_COMPLEXIO_CFG1_PWR_STATUS_SHIFT		25
+#define ISPCSI2_COMPLEXIO_CFG1_PWR_STATUS_MASK \
+			(0x3 << ISPCSI2_COMPLEXIO_CFG1_PWR_STATUS_SHIFT)
+#define ISPCSI2_COMPLEXIO_CFG1_PWR_STATUS_OFF \
+			(0x0 << ISPCSI2_COMPLEXIO_CFG1_PWR_STATUS_SHIFT)
+#define ISPCSI2_COMPLEXIO_CFG1_PWR_STATUS_ON \
+			(0x1 << ISPCSI2_COMPLEXIO_CFG1_PWR_STATUS_SHIFT)
+#define ISPCSI2_COMPLEXIO_CFG1_PWR_STATUS_ULPW \
+			(0x2 << ISPCSI2_COMPLEXIO_CFG1_PWR_STATUS_SHIFT)
+#define ISPCSI2_COMPLEXIO_CFG1_PWR_AUTO_SHIFT		24
+#define ISPCSI2_COMPLEXIO_CFG1_PWR_AUTO_MASK \
+			(0x1 << ISPCSI2_COMPLEXIO_CFG1_PWR_AUTO_SHIFT)
+#define ISPCSI2_COMPLEXIO_CFG1_PWR_AUTO_DISABLE \
+			(0x0 << ISPCSI2_COMPLEXIO_CFG1_PWR_AUTO_SHIFT)
+#define ISPCSI2_COMPLEXIO_CFG1_PWR_AUTO_ENABLE \
+			(0x1 << ISPCSI2_COMPLEXIO_CFG1_PWR_AUTO_SHIFT)
+
+#define ISPCSI2_COMPLEXIO_CFG1_DATA_POL_SHIFT(n) 	(3 + ((n) * 4))
+#define ISPCSI2_COMPLEXIO_CFG1_DATA_POL_MASK(n) (0x1 << \
+				ISPCSI2_COMPLEXIO_CFG1_DATA_POL_SHIFT(n))
+#define ISPCSI2_COMPLEXIO_CFG1_DATA_POL_PN(n) (0x0 << \
+				ISPCSI2_COMPLEXIO_CFG1_DATA_POL_SHIFT(n))
+#define ISPCSI2_COMPLEXIO_CFG1_DATA_POL_NP(n) (0x1 << \
+				ISPCSI2_COMPLEXIO_CFG1_DATA_POL_SHIFT(n))
+
+#define ISPCSI2_COMPLEXIO_CFG1_DATA_POSITION_SHIFT(n)	((n) * 4)
+#define ISPCSI2_COMPLEXIO_CFG1_DATA_POSITION_MASK(n)	(0x7 << \
+				ISPCSI2_COMPLEXIO_CFG1_DATA_POSITION_SHIFT(n))
+#define ISPCSI2_COMPLEXIO_CFG1_DATA_POSITION_NC(n)	(0x0 << \
+				ISPCSI2_COMPLEXIO_CFG1_DATA_POSITION_SHIFT(n))
+#define ISPCSI2_COMPLEXIO_CFG1_DATA_POSITION_1(n)	(0x1 << \
+				ISPCSI2_COMPLEXIO_CFG1_DATA_POSITION_SHIFT(n))
+#define ISPCSI2_COMPLEXIO_CFG1_DATA_POSITION_2(n)	(0x2 << \
+				ISPCSI2_COMPLEXIO_CFG1_DATA_POSITION_SHIFT(n))
+#define ISPCSI2_COMPLEXIO_CFG1_DATA_POSITION_3(n)	(0x3 << \
+				ISPCSI2_COMPLEXIO_CFG1_DATA_POSITION_SHIFT(n))
+#define ISPCSI2_COMPLEXIO_CFG1_DATA_POSITION_4(n)	(0x4 << \
+				ISPCSI2_COMPLEXIO_CFG1_DATA_POSITION_SHIFT(n))
+#define ISPCSI2_COMPLEXIO_CFG1_DATA_POSITION_5(n)	(0x5 << \
+				ISPCSI2_COMPLEXIO_CFG1_DATA_POSITION_SHIFT(n))
+
+#define ISPCSI2_COMPLEXIO_CFG1_CLOCK_POL_SHIFT		3
+#define ISPCSI2_COMPLEXIO_CFG1_CLOCK_POL_MASK \
+			(0x1 << ISPCSI2_COMPLEXIO_CFG1_CLOCK_POL_SHIFT)
+#define ISPCSI2_COMPLEXIO_CFG1_CLOCK_POL_PN \
+			(0x0 << ISPCSI2_COMPLEXIO_CFG1_CLOCK_POL_SHIFT)
+#define ISPCSI2_COMPLEXIO_CFG1_CLOCK_POL_NP \
+			(0x1 << ISPCSI2_COMPLEXIO_CFG1_CLOCK_POL_SHIFT)
+
+#define ISPCSI2_COMPLEXIO_CFG1_CLOCK_POSITION_SHIFT		0
+#define ISPCSI2_COMPLEXIO_CFG1_CLOCK_POSITION_MASK \
+			(0x7 << ISPCSI2_COMPLEXIO_CFG1_CLOCK_POSITION_SHIFT)
+#define ISPCSI2_COMPLEXIO_CFG1_CLOCK_POSITION_1 \
+			(0x1 << ISPCSI2_COMPLEXIO_CFG1_CLOCK_POSITION_SHIFT)
+#define ISPCSI2_COMPLEXIO_CFG1_CLOCK_POSITION_2 \
+			(0x2 << ISPCSI2_COMPLEXIO_CFG1_CLOCK_POSITION_SHIFT)
+#define ISPCSI2_COMPLEXIO_CFG1_CLOCK_POSITION_3 \
+			(0x3 << ISPCSI2_COMPLEXIO_CFG1_CLOCK_POSITION_SHIFT)
+#define ISPCSI2_COMPLEXIO_CFG1_CLOCK_POSITION_4 \
+			(0x4 << ISPCSI2_COMPLEXIO_CFG1_CLOCK_POSITION_SHIFT)
+#define ISPCSI2_COMPLEXIO_CFG1_CLOCK_POSITION_5 \
+			(0x5 << ISPCSI2_COMPLEXIO_CFG1_CLOCK_POSITION_SHIFT)
+
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS			(0x054)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_STATEALLULPMEXIT	(1 << 26)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_STATEALLULPMENTER	(1 << 25)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_STATEULPM5		(1 << 24)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_STATEULPM4		(1 << 23)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_STATEULPM3		(1 << 22)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_STATEULPM2		(1 << 21)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_STATEULPM1		(1 << 20)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_ERRCONTROL5	(1 << 19)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_ERRCONTROL4	(1 << 18)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_ERRCONTROL3	(1 << 17)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_ERRCONTROL2	(1 << 16)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_ERRCONTROL1	(1 << 15)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_ERRESC5		(1 << 14)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_ERRESC4		(1 << 13)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_ERRESC3		(1 << 12)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_ERRESC2		(1 << 11)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_ERRESC1		(1 << 10)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_ERRSOTSYNCHS5	(1 << 9)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_ERRSOTSYNCHS4	(1 << 8)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_ERRSOTSYNCHS3	(1 << 7)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_ERRSOTSYNCHS2	(1 << 6)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_ERRSOTSYNCHS1	(1 << 5)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_ERRSOTHS5		(1 << 4)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_ERRSOTHS4		(1 << 3)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_ERRSOTHS3		(1 << 2)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_ERRSOTHS2		(1 << 1)
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS_ERRSOTHS1		1
+
+#define ISPCSI2_SHORT_PACKET		(0x05C)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE			(0x060)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_STATEALLULPMEXIT	(1 << 26)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_STATEALLULPMENTER	(1 << 25)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_STATEULPM5		(1 << 24)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_STATEULPM4		(1 << 23)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_STATEULPM3		(1 << 22)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_STATEULPM2		(1 << 21)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_STATEULPM1		(1 << 20)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_ERRCONTROL5	(1 << 19)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_ERRCONTROL4	(1 << 18)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_ERRCONTROL3	(1 << 17)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_ERRCONTROL2	(1 << 16)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_ERRCONTROL1	(1 << 15)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_ERRESC5		(1 << 14)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_ERRESC4		(1 << 13)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_ERRESC3		(1 << 12)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_ERRESC2		(1 << 11)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_ERRESC1		(1 << 10)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_ERRSOTSYNCHS5	(1 << 9)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_ERRSOTSYNCHS4	(1 << 8)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_ERRSOTSYNCHS3	(1 << 7)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_ERRSOTSYNCHS2	(1 << 6)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_ERRSOTSYNCHS1	(1 << 5)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_ERRSOTHS5		(1 << 4)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_ERRSOTHS4		(1 << 3)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_ERRSOTHS3		(1 << 2)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_ERRSOTHS2		(1 << 1)
+#define ISPCSI2_COMPLEXIO1_IRQENABLE_ERRSOTHS1		1
+#define ISPCSI2_DBG_P			(0x068)
+#define ISPCSI2_TIMING			(0x06C)
+
+
+#define ISPCSI2_TIMING_FORCE_RX_MODE_IO_SHIFT(n)	((16 * ((n) - 1)) + 15)
+#define ISPCSI2_TIMING_FORCE_RX_MODE_IO_MASK(n)	(0x1 << \
+				ISPCSI2_TIMING_FORCE_RX_MODE_IO_SHIFT(n))
+#define ISPCSI2_TIMING_FORCE_RX_MODE_IO_DISABLE(n)	(0x0 << \
+				ISPCSI2_TIMING_FORCE_RX_MODE_IO_SHIFT(n))
+#define ISPCSI2_TIMING_FORCE_RX_MODE_IO_ENABLE(n)	(0x1 << \
+				ISPCSI2_TIMING_FORCE_RX_MODE_IO_SHIFT(n))
+#define ISPCSI2_TIMING_STOP_STATE_X16_IO_SHIFT(n)	((16 * ((n) - 1)) + 14)
+#define ISPCSI2_TIMING_STOP_STATE_X16_IO_MASK(n)	(0x1 << \
+				ISPCSI2_TIMING_STOP_STATE_X16_IO_SHIFT(n))
+#define ISPCSI2_TIMING_STOP_STATE_X16_IO_DISABLE(n)	(0x0 << \
+				ISPCSI2_TIMING_STOP_STATE_X16_IO_SHIFT(n))
+#define ISPCSI2_TIMING_STOP_STATE_X16_IO_ENABLE(n)	(0x1 << \
+				ISPCSI2_TIMING_STOP_STATE_X16_IO_SHIFT(n))
+#define ISPCSI2_TIMING_STOP_STATE_X4_IO_SHIFT(n)	((16 * ((n) - 1)) + 13)
+#define ISPCSI2_TIMING_STOP_STATE_X4_IO_MASK(n)		(0x1 << \
+				ISPCSI2_TIMING_STOP_STATE_X4_IO_SHIFT(n))
+#define ISPCSI2_TIMING_STOP_STATE_X4_IO_DISABLE(n)	(0x0 << \
+				ISPCSI2_TIMING_STOP_STATE_X4_IO_SHIFT(n))
+#define ISPCSI2_TIMING_STOP_STATE_X4_IO_ENABLE(n)		(0x1 << \
+				ISPCSI2_TIMING_STOP_STATE_X4_IO_SHIFT(n))
+#define ISPCSI2_TIMING_STOP_STATE_COUNTER_IO_SHIFT(n)	(16 * ((n) - 1))
+#define ISPCSI2_TIMING_STOP_STATE_COUNTER_IO_MASK(n)	(0x1FFF << \
+				ISPCSI2_TIMING_STOP_STATE_COUNTER_IO_SHIFT(n))
+
+#define ISPCSI2_CTX_CTRL1(n)		((0x070) + 0x20 * (n))
+#define ISPCSI2_CTX_CTRL1_COUNT_SHIFT		8
+#define ISPCSI2_CTX_CTRL1_COUNT_MASK		(0xFF << \
+						ISPCSI2_CTX_CTRL1_COUNT_SHIFT)
+#define ISPCSI2_CTX_CTRL1_EOF_EN_SHIFT		7
+#define ISPCSI2_CTX_CTRL1_EOF_EN_MASK		(0x1 << \
+						ISPCSI2_CTX_CTRL1_EOF_EN_SHIFT)
+#define ISPCSI2_CTX_CTRL1_EOF_EN_DISABLE	(0x0 << \
+						ISPCSI2_CTX_CTRL1_EOF_EN_SHIFT)
+#define ISPCSI2_CTX_CTRL1_EOF_EN_ENABLE		(0x1 << \
+						ISPCSI2_CTX_CTRL1_EOF_EN_SHIFT)
+#define ISPCSI2_CTX_CTRL1_EOL_EN_SHIFT		6
+#define ISPCSI2_CTX_CTRL1_EOL_EN_MASK		(0x1 << \
+						ISPCSI2_CTX_CTRL1_EOL_EN_SHIFT)
+#define ISPCSI2_CTX_CTRL1_EOL_EN_DISABLE	(0x0 << \
+						ISPCSI2_CTX_CTRL1_EOL_EN_SHIFT)
+#define ISPCSI2_CTX_CTRL1_EOL_EN_ENABLE		(0x1 << \
+						ISPCSI2_CTX_CTRL1_EOL_EN_SHIFT)
+#define ISPCSI2_CTX_CTRL1_CS_EN_SHIFT		5
+#define ISPCSI2_CTX_CTRL1_CS_EN_MASK		(0x1 << \
+						ISPCSI2_CTX_CTRL1_CS_EN_SHIFT)
+#define ISPCSI2_CTX_CTRL1_CS_EN_DISABLE		(0x0 << \
+						ISPCSI2_CTX_CTRL1_CS_EN_SHIFT)
+#define ISPCSI2_CTX_CTRL1_CS_EN_ENABLE		(0x1 << \
+						ISPCSI2_CTX_CTRL1_CS_EN_SHIFT)
+#define ISPCSI2_CTX_CTRL1_COUNT_UNLOCK_EN_SHIFT		4
+#define ISPCSI2_CTX_CTRL1_COUNT_UNLOCK_EN_MASK		(0x1 << \
+					ISPCSI2_CTX_CTRL1_COUNT_UNLOCK_EN_SHIFT)
+#define ISPCSI2_CTX_CTRL1_COUNT_UNLOCK_EN_DISABLE	(0x0 << \
+					ISPCSI2_CTX_CTRL1_COUNT_UNLOCK_EN_SHIFT)
+#define ISPCSI2_CTX_CTRL1_COUNT_UNLOCK_EN_ENABLE	(0x1 << \
+					ISPCSI2_CTX_CTRL1_COUNT_UNLOCK_EN_SHIFT)
+#define ISPCSI2_CTX_CTRL1_PING_PONG_SHIFT	3
+#define ISPCSI2_CTX_CTRL1_PING_PONG_MASK	(0x1 << \
+					ISPCSI2_CTX_CTRL1_PING_PONG_SHIFT)
+#define ISPCSI2_CTX_CTRL1_CTX_EN_SHIFT		0
+#define ISPCSI2_CTX_CTRL1_CTX_EN_MASK		(0x1 << \
+						ISPCSI2_CTX_CTRL1_CTX_EN_SHIFT)
+#define ISPCSI2_CTX_CTRL1_CTX_EN_DISABLE	(0x0 << \
+						ISPCSI2_CTX_CTRL1_CTX_EN_SHIFT)
+#define ISPCSI2_CTX_CTRL1_CTX_EN_ENABLE		(0x1 << \
+						ISPCSI2_CTX_CTRL1_CTX_EN_SHIFT)
+
+#define ISPCSI2_CTX_CTRL2(n)		((0x074) + 0x20 * (n))
+#define ISPCSI2_CTX_CTRL2_VIRTUAL_ID_SHIFT	11
+#define ISPCSI2_CTX_CTRL2_VIRTUAL_ID_MASK	(0x3 << \
+					ISPCSI2_CTX_CTRL2_VIRTUAL_ID_SHIFT)
+#define ISPCSI2_CTX_CTRL2_FORMAT_SHIFT	0
+#define ISPCSI2_CTX_CTRL2_FORMAT_MASK	(0x3FF << \
+					ISPCSI2_CTX_CTRL2_FORMAT_SHIFT)
+
+#define ISPCSI2_CTX_DAT_OFST(n)		((0x078) + 0x20 * (n))
+#define ISPCSI2_CTX_DAT_OFST_OFST_SHIFT	5
+#define ISPCSI2_CTX_DAT_OFST_OFST_MASK	(0x7FF << \
+						ISPCSI2_CTX_DAT_OFST_OFST_SHIFT)
+
+#define ISPCSI2_CTX_DAT_PING_ADDR(n)	((0x07C) + 0x20 * (n))
+#define ISPCSI2_CTX_DAT_PONG_ADDR(n)	((0x080) + 0x20 * (n))
+#define ISPCSI2_CTX_IRQENABLE(n)	((0x084) + 0x20 * (n))
+#define ISPCSI2_CTX_IRQENABLE_ECC_CORRECTION_IRQ		(1 << 8)
+#define ISPCSI2_CTX_IRQENABLE_LINE_NUMBER_IRQ		(1 << 7)
+#define ISPCSI2_CTX_IRQENABLE_FRAME_NUMBER_IRQ		(1 << 6)
+#define ISPCSI2_CTX_IRQENABLE_CS_IRQ			(1 << 5)
+#define ISPCSI2_CTX_IRQENABLE_LE_IRQ			(1 << 3)
+#define ISPCSI2_CTX_IRQENABLE_LS_IRQ			(1 << 2)
+#define ISPCSI2_CTX_IRQENABLE_FE_IRQ			(1 << 1)
+#define ISPCSI2_CTX_IRQENABLE_FS_IRQ			1
+#define ISPCSI2_CTX_IRQSTATUS(n)	((0x088) + 0x20 * (n))
+#define ISPCSI2_CTX_IRQSTATUS_ECC_CORRECTION_IRQ		(1 << 8)
+#define ISPCSI2_CTX_IRQSTATUS_LINE_NUMBER_IRQ		(1 << 7)
+#define ISPCSI2_CTX_IRQSTATUS_FRAME_NUMBER_IRQ		(1 << 6)
+#define ISPCSI2_CTX_IRQSTATUS_CS_IRQ			(1 << 5)
+#define ISPCSI2_CTX_IRQSTATUS_LE_IRQ			(1 << 3)
+#define ISPCSI2_CTX_IRQSTATUS_LS_IRQ			(1 << 2)
+#define ISPCSI2_CTX_IRQSTATUS_FE_IRQ			(1 << 1)
+#define ISPCSI2_CTX_IRQSTATUS_FS_IRQ			1
+
+#define ISPCSI2_CTX_CTRL3(n)		((0x08C) + 0x20 * (n))
+#define ISPCSI2_CTX_CTRL3_ALPHA_SHIFT	5
+#define ISPCSI2_CTX_CTRL3_ALPHA_MASK	(0x3FFF << \
+						ISPCSI2_CTX_CTRL3_ALPHA_SHIFT)
+
+#define ISPCSI2PHY_CFG0				(0x000)
+#define ISPCSI2PHY_CFG0_THS_TERM_SHIFT		8
+#define ISPCSI2PHY_CFG0_THS_TERM_MASK \
+				(0xFF << ISPCSI2PHY_CFG0_THS_TERM_SHIFT)
+#define ISPCSI2PHY_CFG0_THS_TERM_RESETVAL \
+				(0x04 << ISPCSI2PHY_CFG0_THS_TERM_SHIFT)
+#define ISPCSI2PHY_CFG0_THS_SETTLE_SHIFT		0
+#define ISPCSI2PHY_CFG0_THS_SETTLE_MASK \
+				(0xFF << ISPCSI2PHY_CFG0_THS_SETTLE_SHIFT)
+#define ISPCSI2PHY_CFG0_THS_SETTLE_RESETVAL \
+				(0x27 << ISPCSI2PHY_CFG0_THS_SETTLE_SHIFT)
+#define ISPCSI2PHY_CFG1				(0x004)
+#define ISPCSI2PHY_CFG1_TCLK_TERM_SHIFT		18
+#define ISPCSI2PHY_CFG1_TCLK_TERM_MASK \
+				(0x7F << ISPCSI2PHY_CFG1_TCLK_TERM_SHIFT)
+#define ISPCSI2PHY_CFG1_TCLK_TERM__RESETVAL \
+				(0x00 << ISPCSI2PHY_CFG1_TCLK_TERM_SHIFT)
+#define ISPCSI2PHY_CFG1_RESERVED1_SHIFT		10
+#define ISPCSI2PHY_CFG1_RESERVED1_MASK \
+				(0xFF << ISPCSI2PHY_CFG1_RESERVED1_SHIFT)
+#define ISPCSI2PHY_CFG1_RESERVED1__RESETVAL \
+				(0xB8 << ISPCSI2PHY_CFG1_RESERVED1_SHIFT)
+#define ISPCSI2PHY_CFG1_TCLK_MISS_SHIFT		8
+#define ISPCSI2PHY_CFG1_TCLK_MISS_MASK \
+				(0x3 << ISPCSI2PHY_CFG1_TCLK_MISS_SHIFT)
+#define ISPCSI2PHY_CFG1_TCLK_MISS__RESETVAL \
+				(0x1 << ISPCSI2PHY_CFG1_TCLK_MISS_SHIFT)
+#define ISPCSI2PHY_CFG1_TCLK_SETTLE_SHIFT		0
+#define ISPCSI2PHY_CFG1_TCLK_SETTLE_MASK \
+				(0xFF << ISPCSI2PHY_CFG1_TCLK_TERM_SHIFT)
+#define ISPCSI2PHY_CFG1_TCLK_SETTLE__RESETVAL \
+				(0x0E << ISPCSI2PHY_CFG1_TCLK_TERM_SHIFT)
+#define ISPCSI2PHY_CFG1__RESETVAL	(ISPCSI2PHY_CFG1_TCLK_TERM__RESETVAL | \
+					ISPCSI2PHY_CFG1_RESERVED1__RESETVAL | \
+					ISPCSI2PHY_CFG1_TCLK_MISS__RESETVAL | \
+					ISPCSI2PHY_CFG1_TCLK_SETTLE__RESETVAL)
+#define ISPCSI2PHY_CFG1__EDITABLE_MASK	(ISPCSI2PHY_CFG1_TCLK_TERM_MASK | \
+					ISPCSI2PHY_CFG1_RESERVED1_MASK | \
+					ISPCSI2PHY_CFG1_TCLK_MISS_MASK | \
+					ISPCSI2PHY_CFG1_TCLK_SETTLE_MASK)
+
+#endif	/* __ISPREG_H__ */
-- 
1.5.6.5

