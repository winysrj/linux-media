Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBBKe56k014390
	for <video4linux-list@redhat.com>; Thu, 11 Dec 2008 15:40:06 -0500
Received: from comal.ext.ti.com (comal.ext.ti.com [198.47.26.152])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBBKcN3j020810
	for <video4linux-list@redhat.com>; Thu, 11 Dec 2008 15:38:23 -0500
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>
Date: Thu, 11 Dec 2008 14:38:12 -0600
Message-ID: <A24693684029E5489D1D202277BE894415E6E19E@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: Sakari Ailus <sakari.ailus@nokia.com>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>, "Nagalla,
	Hari" <hnagalla@ti.com>
Subject: [REVIEW PATCH 08/14] OMAP: CAM: Add ISP Core
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

>From e10dc23eb3774da4da86a3be4f96cfbe16dde4bc Mon Sep 17 00:00:00 2001
From: Sergio Aguirre <saaguirre@ti.com>
Date: Thu, 11 Dec 2008 13:35:48 -0600
Subject: [PATCH] OMAP: CAM: Add ISP Core

This adds the OMAP ISP Core modules to the kernel. Includes:
* ISP Core Driver
* ISP MMU Driver

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 drivers/media/video/isp/Makefile |   12 +
 drivers/media/video/isp/isp.c    | 2476 ++++++++++++++++++++++++++++++++++++++
 drivers/media/video/isp/isp.h    |  341 ++++++
 drivers/media/video/isp/ispmmu.c |  746 ++++++++++++
 drivers/media/video/isp/ispmmu.h |  119 ++
 5 files changed, 3694 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/isp/Makefile
 create mode 100644 drivers/media/video/isp/isp.c
 create mode 100644 drivers/media/video/isp/isp.h
 create mode 100644 drivers/media/video/isp/ispmmu.c
 create mode 100644 drivers/media/video/isp/ispmmu.h

diff --git a/drivers/media/video/isp/Makefile b/drivers/media/video/isp/Makefile
new file mode 100644
index 0000000..f2f831c
--- /dev/null
+++ b/drivers/media/video/isp/Makefile
@@ -0,0 +1,12 @@
+# Makefile for OMAP3 ISP driver
+
+ifdef CONFIG_ARCH_OMAP3410
+isp-mod-objs += \
+       isp.o ispccdc.o ispmmu.o
+else
+isp-mod-objs += \
+       isp.o ispccdc.o ispmmu.o \
+       isppreview.o ispresizer.o isph3a.o isphist.o isp_af.o ispcsi2.o
+endif
+
+obj-$(CONFIG_VIDEO_OMAP3) += isp-mod.o
diff --git a/drivers/media/video/isp/isp.c b/drivers/media/video/isp/isp.c
new file mode 100644
index 0000000..92a415c
--- /dev/null
+++ b/drivers/media/video/isp/isp.c
@@ -0,0 +1,2476 @@
+/*
+ * drivers/media/video/isp/isp.c
+ *
+ * Driver Library for ISP Control module in TI's OMAP3 Camera ISP
+ * ISP interface and IRQ related APIs are defined here.
+ *
+ * Copyright (C) 2008 Texas Instruments.
+ * Copyright (C) 2008 Nokia.
+ *
+ * Contributors:
+ *     Sameer Venkatraman <sameerv@ti.com>
+ *     Mohit Jalori <mjalori@ti.com>
+ *     Sakari Ailus <sakari.ailus@nokia.com>
+ *     Tuukka Toivonen <tuukka.o.toivonen@nokia.com>
+ *     Toni Leinonen <toni.leinonen@nokia.com>
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
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/sched.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/interrupt.h>
+#include <linux/clk.h>
+#include <linux/dma-mapping.h>
+#include <asm/irq.h>
+#include <linux/bitops.h>
+#include <linux/scatterlist.h>
+#include <asm/mach-types.h>
+#include <linux/device.h>
+#include <linux/videodev2.h>
+#include <linux/vmalloc.h>
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
+#if ISP_WORKAROUND
+void *buff_addr;
+dma_addr_t buff_addr_mapped;
+struct scatterlist *sglist_alloc;
+static int alloc_done, num_sc;
+unsigned long offset_value;
+#endif
+
+/* List of image formats supported via OMAP ISP */
+const static struct v4l2_fmtdesc isp_formats[] = {
+       {
+               .description = "UYVY, packed",
+               .pixelformat = V4L2_PIX_FMT_UYVY,
+       },
+       {
+               .description = "YUYV (YUV 4:2:2), packed",
+               .pixelformat = V4L2_PIX_FMT_YUYV,
+       },
+       {
+               .description = "Bayer10 (GrR/BGb)",
+               .pixelformat = V4L2_PIX_FMT_SGRBG10,
+       },
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
+       struct v4l2_queryctrl qc;
+       int current_value;
+} video_control[] = {
+       {
+               {
+                       .id = V4L2_CID_BRIGHTNESS,
+                       .type = V4L2_CTRL_TYPE_INTEGER,
+                       .name = "Brightness",
+                       .minimum = ISPPRV_BRIGHT_LOW,
+                       .maximum = ISPPRV_BRIGHT_HIGH,
+                       .step = ISPPRV_BRIGHT_STEP,
+                       .default_value = ISPPRV_BRIGHT_DEF,
+               },
+               .current_value = ISPPRV_BRIGHT_DEF,
+       },
+       {
+               {
+                       .id = V4L2_CID_CONTRAST,
+                       .type = V4L2_CTRL_TYPE_INTEGER,
+                       .name = "Contrast",
+                       .minimum = ISPPRV_CONTRAST_LOW,
+                       .maximum = ISPPRV_CONTRAST_HIGH,
+                       .step = ISPPRV_CONTRAST_STEP,
+                       .default_value = ISPPRV_CONTRAST_DEF,
+               },
+               .current_value = ISPPRV_CONTRAST_DEF,
+       },
+       {
+               {
+                       .id = V4L2_CID_PRIVATE_ISP_COLOR_FX,
+                       .type = V4L2_CTRL_TYPE_INTEGER,
+                       .name = "Color Effects",
+                       .minimum = PREV_DEFAULT_COLOR,
+                       .maximum = PREV_BW_COLOR,
+                       .step = 1,
+                       .default_value = PREV_DEFAULT_COLOR,
+               },
+               .current_value = PREV_DEFAULT_COLOR,
+       }
+};
+
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
+static struct ispirq {
+       isp_callback_t isp_callbk[CBK_END];
+       isp_vbq_callback_ptr isp_callbk_arg1[CBK_END];
+       void *isp_callbk_arg2[CBK_END];
+} ispirq_obj;
+
+/**
+ * struct isp - Structure for storing ISP Control module information
+ * @lock: Spinlock to sync between isr and processes.
+ * @isp_temp_buf_lock: Temporary spinlock for buffer control.
+ * @isp_mutex: Semaphore used to get access to the ISP.
+ * @if_status: Type of interface used in ISP.
+ * @interfacetype: (Not used).
+ * @ref_count: Reference counter.
+ * @cam_ick: Pointer to ISP Interface clock.
+ * @cam_fck: Pointer to ISP Functional clock.
+ *
+ * This structure is used to store the OMAP ISP Control Information.
+ */
+static struct isp {
+       spinlock_t lock;        /* For handling registered ISP callbacks */
+       spinlock_t isp_temp_buf_lock;   /* For handling isp buffers state */
+       struct mutex isp_mutex; /* For handling ref_count field */
+       u8 if_status;
+       u8 interfacetype;
+       int ref_count;
+       struct clk *cam_ick;
+       struct clk *cam_mclk;
+       struct clk *csi2_fck;
+} isp_obj;
+
+struct isp_sgdma ispsg;
+
+/**
+ * struct ispmodule - Structure for storing ISP sub-module information.
+ * @isp_pipeline: Bit mask for submodules enabled within the ISP.
+ * @isp_temp_state: State of current buffers.
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
+struct ispmodule {
+       unsigned int isp_pipeline;
+       int isp_temp_state;
+       int applyCrop;
+       struct v4l2_pix_format pix;
+       unsigned int ccdc_input_width;
+       unsigned int ccdc_input_height;
+       unsigned int ccdc_output_width;
+       unsigned int ccdc_output_height;
+       unsigned int preview_input_width;
+       unsigned int preview_input_height;
+       unsigned int preview_output_width;
+       unsigned int preview_output_height;
+       unsigned int resizer_input_width;
+       unsigned int resizer_input_height;
+       unsigned int resizer_output_width;
+       unsigned int resizer_output_height;
+};
+
+static struct ispmodule ispmodule_obj = {
+       .isp_pipeline = OMAP_ISP_CCDC,
+       .isp_temp_state = ISP_BUF_INIT,
+       .applyCrop = 0,
+       .pix = {
+               .width = ISP_OUTPUT_WIDTH_DEFAULT,
+               .height = ISP_OUTPUT_HEIGHT_DEFAULT,
+               .pixelformat = V4L2_PIX_FMT_UYVY,
+               .field = V4L2_FIELD_NONE,
+               .bytesperline = ISP_OUTPUT_WIDTH_DEFAULT * ISP_BYTES_PER_PIXEL,
+               .colorspace = V4L2_COLORSPACE_JPEG,
+               .priv = 0,
+       },
+};
+
+/* Structure for saving/restoring ISP module registers */
+static struct isp_reg isp_reg_list[] = {
+       {ISP_SYSCONFIG, 0},
+       {ISP_TCTRL_GRESET_LENGTH, 0},
+       {ISP_TCTRL_PSTRB_REPLAY, 0},
+       {ISP_CTRL, 0},
+       {ISP_TCTRL_CTRL, 0},
+       {ISP_TCTRL_FRAME, 0},
+       {ISP_TCTRL_PSTRB_DELAY, 0},
+       {ISP_TCTRL_STRB_DELAY, 0},
+       {ISP_TCTRL_SHUT_DELAY, 0},
+       {ISP_TCTRL_PSTRB_LENGTH, 0},
+       {ISP_TCTRL_STRB_LENGTH, 0},
+       {ISP_TCTRL_SHUT_LENGTH, 0},
+       {ISP_CBUFF_SYSCONFIG, 0},
+       {ISP_CBUFF_IRQENABLE, 0},
+       {ISP_CBUFF0_CTRL, 0},
+       {ISP_CBUFF1_CTRL, 0},
+       {ISP_CBUFF0_START, 0},
+       {ISP_CBUFF1_START, 0},
+       {ISP_CBUFF0_END, 0},
+       {ISP_CBUFF1_END, 0},
+       {ISP_CBUFF0_WINDOWSIZE, 0},
+       {ISP_CBUFF1_WINDOWSIZE, 0},
+       {ISP_CBUFF0_THRESHOLD, 0},
+       {ISP_CBUFF1_THRESHOLD, 0},
+       {ISP_TOK_TERM, 0}
+};
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
+       int i;
+
+       if (id < V4L2_CID_BASE)
+               return -EDOM;
+
+       for (i = (ARRAY_SIZE(video_control) - 1); i >= 0; i--)
+               if (video_control[i].qc.id == id)
+                       break;
+
+       if (i < 0)
+               i = -EINVAL;
+
+       return i;
+}
+
+static int find_next_vctrl(int id)
+{
+       int i;
+       u32 best = (u32)-1;
+
+       for (i = 0; i < ARRAY_SIZE(video_control); i++) {
+               if (video_control[i].qc.id > id &&
+                                               (best == (u32)-1 ||
+                                               video_control[i].qc.id <
+                                               video_control[best].qc.id)) {
+                       best = i;
+               }
+       }
+
+       if (best == (u32)-1)
+               return -EINVAL;
+
+       return best;
+}
+
+/**
+ * isp_release_resources - Free ISP submodules
+ **/
+void isp_release_resources(void)
+{
+       if (ispmodule_obj.isp_pipeline & OMAP_ISP_CCDC)
+               ispccdc_free();
+
+       if (ispmodule_obj.isp_pipeline & OMAP_ISP_PREVIEW)
+               isppreview_free();
+
+       if (ispmodule_obj.isp_pipeline & OMAP_ISP_RESIZER)
+               ispresizer_free();
+       return;
+}
+EXPORT_SYMBOL(omapisp_unset_callback);
+
+/* Flag to check first time of isp_get */
+static int off_mode;
+
+/**
+ * isp_set_sgdma_callback - Set Scatter-Gather DMA Callback.
+ * @sgdma_state: Pointer to structure with the SGDMA state for each videobuffer
+ * @func_ptr: Callback function pointer for SG-DMA management
+ **/
+static int isp_set_sgdma_callback(struct isp_sgdma_state *sgdma_state,
+                                               isp_vbq_callback_ptr func_ptr)
+{
+       if ((ispmodule_obj.isp_pipeline & OMAP_ISP_RESIZER) &&
+                                               is_ispresizer_enabled()) {
+               isp_set_callback(CBK_RESZ_DONE, sgdma_state->callback,
+                                               func_ptr, sgdma_state->arg);
+       }
+
+       if ((ispmodule_obj.isp_pipeline & OMAP_ISP_PREVIEW) &&
+                                               is_isppreview_enabled()) {
+               isp_set_callback(CBK_PREV_DONE, sgdma_state->callback,
+                                               func_ptr, sgdma_state->arg);
+       }
+
+       if (ispmodule_obj.isp_pipeline & OMAP_ISP_CCDC) {
+               isp_set_callback(CBK_CCDC_VD0, sgdma_state->callback, func_ptr,
+                                                       sgdma_state->arg);
+               isp_set_callback(CBK_CCDC_VD1, sgdma_state->callback, func_ptr,
+                                                       sgdma_state->arg);
+               isp_set_callback(CBK_LSC_ISR, NULL, NULL, NULL);
+       }
+
+       isp_set_callback(CBK_HS_VS, sgdma_state->callback, func_ptr,
+                                                       sgdma_state->arg);
+       return 0;
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
+                                               isp_vbq_callback_ptr arg1,
+                                               void *arg2)
+{
+       unsigned long irqflags = 0;
+
+       if (callback == NULL) {
+               DPRINTK_ISPCTRL("ISP_ERR : Null Callback\n");
+               return -EINVAL;
+       }
+
+       spin_lock_irqsave(&isp_obj.lock, irqflags);
+       ispirq_obj.isp_callbk[type] = callback;
+       ispirq_obj.isp_callbk_arg1[type] = arg1;
+       ispirq_obj.isp_callbk_arg2[type] = arg2;
+       spin_unlock_irqrestore(&isp_obj.lock, irqflags);
+
+       switch (type) {
+       case CBK_HS_VS:
+               omap_writel(IRQ0ENABLE_HS_VS_IRQ, ISP_IRQ0STATUS);
+               omap_writel(omap_readl(ISP_IRQ0ENABLE) | IRQ0ENABLE_HS_VS_IRQ,
+                                                       ISP_IRQ0ENABLE);
+               break;
+       case CBK_PREV_DONE:
+               omap_writel(IRQ0ENABLE_PRV_DONE_IRQ, ISP_IRQ0STATUS);
+               omap_writel(omap_readl(ISP_IRQ0ENABLE) |
+                                       IRQ0ENABLE_PRV_DONE_IRQ,
+                                       ISP_IRQ0ENABLE);
+               break;
+       case CBK_RESZ_DONE:
+               omap_writel(IRQ0ENABLE_RSZ_DONE_IRQ, ISP_IRQ0STATUS);
+               omap_writel(omap_readl(ISP_IRQ0ENABLE) |
+                                       IRQ0ENABLE_RSZ_DONE_IRQ,
+                                       ISP_IRQ0ENABLE);
+               break;
+       case CBK_MMU_ERR:
+               omap_writel(omap_readl(ISP_IRQ0ENABLE) |
+                                       IRQ0ENABLE_MMU_ERR_IRQ,
+                                       ISP_IRQ0ENABLE);
+
+               omap_writel(omap_readl(ISPMMU_IRQENABLE) |
+                                       IRQENABLE_MULTIHITFAULT |
+                                       IRQENABLE_TWFAULT |
+                                       IRQENABLE_EMUMISS |
+                                       IRQENABLE_TRANSLNFAULT |
+                                       IRQENABLE_TLBMISS,
+                                       ISPMMU_IRQENABLE);
+               break;
+       case CBK_H3A_AWB_DONE:
+               omap_writel(IRQ0ENABLE_H3A_AWB_DONE_IRQ, ISP_IRQ0STATUS);
+               omap_writel(omap_readl(ISP_IRQ0ENABLE) |
+                                       IRQ0ENABLE_H3A_AWB_DONE_IRQ,
+                                       ISP_IRQ0ENABLE);
+               break;
+       case CBK_H3A_AF_DONE:
+               omap_writel(IRQ0ENABLE_H3A_AF_DONE_IRQ, ISP_IRQ0STATUS);
+               omap_writel(omap_readl(ISP_IRQ0ENABLE)|
+                               IRQ0ENABLE_H3A_AF_DONE_IRQ,
+                               ISP_IRQ0ENABLE);
+               break;
+       case CBK_HIST_DONE:
+               omap_writel(IRQ0ENABLE_HIST_DONE_IRQ, ISP_IRQ0STATUS);
+               omap_writel(omap_readl(ISP_IRQ0ENABLE) |
+                                       IRQ0ENABLE_HIST_DONE_IRQ,
+                                       ISP_IRQ0ENABLE);
+               break;
+       case CBK_LSC_ISR:
+               omap_writel(IRQ0ENABLE_CCDC_LSC_DONE_IRQ |
+                                       IRQ0ENABLE_CCDC_LSC_PREF_COMP_IRQ |
+                                       IRQ0ENABLE_CCDC_LSC_PREF_ERR_IRQ,
+                                       ISP_IRQ0STATUS);
+               omap_writel(omap_readl(ISP_IRQ0ENABLE) |
+                                       IRQ0ENABLE_CCDC_LSC_DONE_IRQ |
+                                       IRQ0ENABLE_CCDC_LSC_PREF_COMP_IRQ |
+                                       IRQ0ENABLE_CCDC_LSC_PREF_ERR_IRQ,
+                                       ISP_IRQ0ENABLE);
+               break;
+       default:
+               break;
+       }
+
+       return 0;
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
+       unsigned long irqflags = 0;
+
+       spin_lock_irqsave(&isp_obj.lock, irqflags);
+       ispirq_obj.isp_callbk[type] = NULL;
+       ispirq_obj.isp_callbk_arg1[type] = NULL;
+       ispirq_obj.isp_callbk_arg2[type] = NULL;
+       spin_unlock_irqrestore(&isp_obj.lock, irqflags);
+
+       switch (type) {
+       case CBK_CCDC_VD0:
+               omap_writel((omap_readl(ISP_IRQ0ENABLE)) &
+                                               ~IRQ0ENABLE_CCDC_VD0_IRQ,
+                                               ISP_IRQ0ENABLE);
+               break;
+       case CBK_CCDC_VD1:
+               omap_writel((omap_readl(ISP_IRQ0ENABLE)) &
+                                               ~IRQ0ENABLE_CCDC_VD1_IRQ,
+                                               ISP_IRQ0ENABLE);
+               break;
+       case CBK_PREV_DONE:
+               omap_writel((omap_readl(ISP_IRQ0ENABLE)) &
+                                               ~IRQ0ENABLE_PRV_DONE_IRQ,
+                                               ISP_IRQ0ENABLE);
+               break;
+       case CBK_RESZ_DONE:
+               omap_writel((omap_readl(ISP_IRQ0ENABLE)) &
+                                               ~IRQ0ENABLE_RSZ_DONE_IRQ,
+                                               ISP_IRQ0ENABLE);
+               break;
+       case CBK_MMU_ERR:
+               omap_writel(omap_readl(ISPMMU_IRQENABLE) &
+                                               ~(IRQENABLE_MULTIHITFAULT |
+                                               IRQENABLE_TWFAULT |
+                                               IRQENABLE_EMUMISS |
+                                               IRQENABLE_TRANSLNFAULT |
+                                               IRQENABLE_TLBMISS),
+                                               ISPMMU_IRQENABLE);
+               break;
+       case CBK_H3A_AWB_DONE:
+               omap_writel((omap_readl(ISP_IRQ0ENABLE)) &
+                                               ~IRQ0ENABLE_H3A_AWB_DONE_IRQ,
+                                               ISP_IRQ0ENABLE);
+               break;
+       case CBK_H3A_AF_DONE:
+               omap_writel((omap_readl(ISP_IRQ0ENABLE))&
+                               (~IRQ0ENABLE_H3A_AF_DONE_IRQ), ISP_IRQ0ENABLE);
+               break;
+       case CBK_HIST_DONE:
+               omap_writel((omap_readl(ISP_IRQ0ENABLE)) &
+                                               ~IRQ0ENABLE_HIST_DONE_IRQ,
+                                               ISP_IRQ0ENABLE);
+               break;
+       case CBK_HS_VS:
+               omap_writel((omap_readl(ISP_IRQ0ENABLE)) &
+                                               ~IRQ0ENABLE_HS_VS_IRQ,
+                                               ISP_IRQ0ENABLE);
+               break;
+       case CBK_LSC_ISR:
+               omap_writel(omap_readl(ISP_IRQ0ENABLE) &
+                                       ~(IRQ0ENABLE_CCDC_LSC_DONE_IRQ |
+                                       IRQ0ENABLE_CCDC_LSC_PREF_COMP_IRQ |
+                                       IRQ0ENABLE_CCDC_LSC_PREF_ERR_IRQ),
+                                       ISP_IRQ0ENABLE);
+               break;
+       case CBK_CSIA:
+               isp_csi2_irq_set(0);
+               break;
+       case CBK_CSIB:
+               omap_writel(IRQ0ENABLE_CSIB_IRQ, ISP_IRQ0STATUS);
+               omap_writel(omap_readl(ISP_IRQ0ENABLE)|IRQ0ENABLE_CSIB_IRQ,
+                                       ISP_IRQ0ENABLE);
+               break;
+       default:
+               break;
+       }
+
+       return 0;
+}
+EXPORT_SYMBOL(isp_unset_callback);
+
+/**
+ * isp_request_interface - Requests an ISP interface type (parallel or serial).
+ * @if_t: Type of requested ISP interface (parallel or serial).
+ *
+ * This function requests for allocation of an ISP interface type.
+ **/
+int isp_request_interface(enum isp_interface_type if_t)
+{
+       if (isp_obj.if_status & if_t) {
+               DPRINTK_ISPCTRL("ISP_ERR : Requested Interface already \
+                       allocated\n");
+               return -EBUSY;
+       }
+       if ((isp_obj.if_status == (ISP_PARLL | ISP_CSIA))
+                       || isp_obj.if_status == (ISP_CSIA | ISP_CSIB)) {
+               DPRINTK_ISPCTRL("ISP_ERR : No Free interface now\n");
+               return -EBUSY;
+       }
+
+       if (((isp_obj.if_status == ISP_PARLL) && (if_t == ISP_CSIA)) ||
+                               ((isp_obj.if_status == ISP_CSIA) &&
+                               (if_t == ISP_PARLL)) ||
+                               ((isp_obj.if_status == ISP_CSIA) &&
+                               (if_t == ISP_CSIB)) ||
+                               ((isp_obj.if_status == ISP_CSIB) &&
+                               (if_t == ISP_CSIA)) ||
+                               (isp_obj.if_status == 0)) {
+               isp_obj.if_status |= if_t;
+               return 0;
+       } else {
+               DPRINTK_ISPCTRL("ISP_ERR : Invalid Combination Serial- \
+                       Parallel interface\n");
+               return -EINVAL;
+       }
+}
+EXPORT_SYMBOL(isp_request_interface);
+
+/**
+ * isp_free_interface - Frees an ISP interface type (parallel or serial).
+ * @if_t: Type of ISP interface to be freed (parallel or serial).
+ *
+ * This function frees the allocation of an ISP interface type.
+ **/
+int isp_free_interface(enum isp_interface_type if_t)
+{
+       isp_obj.if_status &= ~if_t;
+       return 0;
+}
+EXPORT_SYMBOL(isp_free_interface);
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
+       u32 divisor;
+       u32 currentxclk;
+
+       if (xclk >= CM_CAM_MCLK_HZ) {
+               divisor = ISPTCTRL_CTRL_DIV_BYPASS;
+               currentxclk = CM_CAM_MCLK_HZ;
+       } else if (xclk >= 2) {
+               divisor = CM_CAM_MCLK_HZ / xclk;
+               if (divisor >= ISPTCTRL_CTRL_DIV_BYPASS)
+                       divisor = ISPTCTRL_CTRL_DIV_BYPASS - 1;
+               currentxclk = CM_CAM_MCLK_HZ / divisor;
+       } else {
+               divisor = xclk;
+               currentxclk = 0;
+       }
+
+       switch (xclksel) {
+       case 0:
+               omap_writel((omap_readl(ISP_TCTRL_CTRL) &
+                               ~ISPTCTRL_CTRL_DIVA_MASK) |
+                               (divisor << ISPTCTRL_CTRL_DIVA_SHIFT),
+                               ISP_TCTRL_CTRL);
+               DPRINTK_ISPCTRL("isp_set_xclk(): cam_xclka set to %d Hz\n",
+                                                               currentxclk);
+               break;
+       case 1:
+               omap_writel((omap_readl(ISP_TCTRL_CTRL) &
+                               ~ISPTCTRL_CTRL_DIVB_MASK) |
+                               (divisor << ISPTCTRL_CTRL_DIVB_SHIFT),
+                               ISP_TCTRL_CTRL);
+               DPRINTK_ISPCTRL("isp_set_xclk(): cam_xclkb set to %d Hz\n",
+                                                               currentxclk);
+               break;
+       default:
+               DPRINTK_ISPCTRL("ISP_ERR: isp_set_xclk(): Invalid requested "
+                                               "xclk. Must be 0 (A) or 1 (B)."
+                                               "\n");
+               return -EINVAL;
+       }
+
+       return currentxclk;
+}
+EXPORT_SYMBOL(isp_set_xclk);
+
+/**
+ * isp_get_xclk - Returns the frequency in Hz of the desired cam_xclk.
+ * @xclksel: XCLK to retrieve (0 = A, 1 = B).
+ *
+ * This function returns the External Clock (XCLKA or XCLKB) value generated
+ * by the ISP.
+ **/
+u32 isp_get_xclk(u8 xclksel)
+{
+       u32 xclkdiv;
+       u32 xclk;
+
+       switch (xclksel) {
+       case 0:
+               xclkdiv = omap_readl(ISP_TCTRL_CTRL) & ISPTCTRL_CTRL_DIVA_MASK;
+               xclkdiv = xclkdiv >> ISPTCTRL_CTRL_DIVA_SHIFT;
+               break;
+       case 1:
+               xclkdiv = omap_readl(ISP_TCTRL_CTRL) & ISPTCTRL_CTRL_DIVB_MASK;
+               xclkdiv = xclkdiv >> ISPTCTRL_CTRL_DIVB_SHIFT;
+               break;
+       default:
+               DPRINTK_ISPCTRL("ISP_ERR: isp_get_xclk(): Invalid requested "
+                                               "xclk. Must be 0 (A) or 1 (B)."
+                                               "\n");
+               return -EINVAL;
+       }
+
+       switch (xclkdiv) {
+       case 0:
+       case 1:
+               xclk = 0;
+               break;
+       case 0x1f:
+               xclk = CM_CAM_MCLK_HZ;
+               break;
+       default:
+               xclk = CM_CAM_MCLK_HZ / xclkdiv;
+               break;
+       }
+
+       return xclk;
+}
+EXPORT_SYMBOL(isp_get_xclk);
+
+/**
+ * isp_power_settings - Sysconfig settings, for Power Management.
+ * @isp_sysconfig: Structure containing the power settings for ISP to configure
+ *
+ * Sets the power settings for the ISP, and SBL bus.
+ **/
+void isp_power_settings(struct isp_sysc isp_sysconfig)
+{
+       if (isp_sysconfig.idle_mode) {
+               omap_writel(ISP_SYSCONFIG_AUTOIDLE |
+                               (ISP_SYSCONFIG_MIDLEMODE_SMARTSTANDBY <<
+                               ISP_SYSCONFIG_MIDLEMODE_SHIFT),
+                               ISP_SYSCONFIG);
+
+               omap_writel(ISPMMU_AUTOIDLE | (ISPMMU_SIDLEMODE_SMARTIDLE <<
+                                               ISPMMU_SIDLEMODE_SHIFT),
+                                               ISPMMU_SYSCONFIG);
+               if (omap_rev() == OMAP3430_REV_ES1_0) {
+                       omap_writel(ISPCSI1_AUTOIDLE |
+                                       (ISPCSI1_MIDLEMODE_SMARTSTANDBY <<
+                                       ISPCSI1_MIDLEMODE_SHIFT),
+                                       ISP_CSIA_SYSCONFIG);
+                       omap_writel(ISPCSI1_AUTOIDLE |
+                                       (ISPCSI1_MIDLEMODE_SMARTSTANDBY <<
+                                       ISPCSI1_MIDLEMODE_SHIFT),
+                                       ISP_CSIB_SYSCONFIG);
+               }
+               omap_writel(ISPCTRL_SBL_AUTOIDLE, ISP_CTRL);
+
+       } else {
+               omap_writel(ISP_SYSCONFIG_AUTOIDLE |
+                               (ISP_SYSCONFIG_MIDLEMODE_FORCESTANDBY <<
+                               ISP_SYSCONFIG_MIDLEMODE_SHIFT),
+                               ISP_SYSCONFIG);
+
+               omap_writel(ISPMMU_AUTOIDLE | (ISPMMU_SIDLEMODE_NOIDLE <<
+                                                       ISPMMU_SIDLEMODE_SHIFT),
+                                                       ISPMMU_SYSCONFIG);
+               if (omap_rev() == OMAP3430_REV_ES1_0) {
+                       omap_writel(ISPCSI1_AUTOIDLE |
+                                       (ISPCSI1_MIDLEMODE_FORCESTANDBY <<
+                                       ISPCSI1_MIDLEMODE_SHIFT),
+                                       ISP_CSIA_SYSCONFIG);
+
+                       omap_writel(ISPCSI1_AUTOIDLE |
+                                       (ISPCSI1_MIDLEMODE_FORCESTANDBY <<
+                                       ISPCSI1_MIDLEMODE_SHIFT),
+                                       ISP_CSIB_SYSCONFIG);
+               }
+
+               omap_writel(ISPCTRL_SBL_AUTOIDLE, ISP_CTRL);
+       }
+}
+EXPORT_SYMBOL(isp_power_settings);
+
+#define BIT_SET(var, shift, mask, val)         \
+       do {                                    \
+               var = (var & ~(mask << shift))  \
+                       | (val << shift);       \
+       } while (0)
+
+static int isp_init_csi(struct isp_interface_config *config)
+{
+       u32 i = 0, val, reg;
+       int format;
+
+       switch (config->u.csi.format) {
+       case V4L2_PIX_FMT_SGRBG10:
+               format = 0x16;          /* RAW10+VP */
+               break;
+       case V4L2_PIX_FMT_SGRBG10DPCM8:
+               format = 0x12;          /* RAW8+DPCM10+VP */
+               break;
+       default:
+               printk(KERN_ERR "isp_init_csi: bad csi format\n");
+               return -EINVAL;
+       }
+
+       /* Reset the CSI and wait for reset to complete */
+       omap_writel(omap_readl(ISPCSI1_SYSCONFIG) | BIT(1), ISPCSI1_SYSCONFIG);
+       while (!(omap_readl(ISPCSI1_SYSSTATUS) & BIT(0))) {
+               udelay(10);
+               if (i++ > 10)
+                       break;
+       }
+       if (!(omap_readl(ISPCSI1_SYSSTATUS) & BIT(0))) {
+               printk(KERN_WARNING
+                       "omap3_isp: timeout waiting for csi reset\n");
+       }
+
+       /* CONTROL_CSIRXFE */
+       omap_writel(
+               /* CSIb receiver data/clock or data/strobe mode */
+               (config->u.csi.signalling << 10)
+               | BIT(12)       /* Enable differential transceiver */
+               | BIT(13)       /* Disable reset */
+#ifdef TERM_RESISTOR
+               | BIT(8)        /* Enable internal CSIb resistor (no effect) */
+#endif
+/*             | BIT(7) */     /* Strobe/clock inversion (no effect) */
+       , CONTROL_CSIRXFE);
+
+#ifdef TERM_RESISTOR
+       /* Set CONTROL_CSI */
+       val = omap_readl(CONTROL_CSI);
+       val &= ~(0x1F<<16);
+       val |= BIT(31) | (TERM_RESISTOR<<16);
+       omap_writel(val, CONTROL_CSI);
+#endif
+
+       /* ISPCSI1_CTRL */
+       val = omap_readl(ISPCSI1_CTRL);
+       val &= ~BIT(11);        /* Enable VP only off ->
+                               extract embedded data to interconnect */
+       BIT_SET(val, 8, 0x3, config->u.csi.vpclk);      /* Video port clock */
+/*     val |= BIT(3);  */      /* Wait for FEC before disabling interface */
+       val |= BIT(2);          /* I/O cell output is parallel
+                               (no effect, but errata says should be enabled
+                               for class 1/2) */
+       val |= BIT(12);         /* VP clock polarity to falling edge
+                               (needed or bad picture!) */
+
+       /* Data/strobe physical layer */
+       BIT_SET(val, 1, 1, config->u.csi.signalling);
+       BIT_SET(val, 10, 1, config->u.csi.strobe_clock_inv);
+       val |= BIT(4);          /* Magic bit to enable CSI1 and strobe mode */
+       omap_writel(val, ISPCSI1_CTRL);
+
+       /* ISPCSI1_LCx_CTRL logical channel #0 */
+       reg = ISPCSI1_LCx_CTRL(0);      /* reg = ISPCSI1_CTRL1; */
+       val = omap_readl(reg);
+       /* Format = RAW10+VP or RAW8+DPCM10+VP*/
+       BIT_SET(val, 3, 0x1f, format);
+       /* Enable setting of frame regions of interest */
+       BIT_SET(val, 1, 1, 1);
+       BIT_SET(val, 2, 1, config->u.csi.crc);
+       omap_writel(val, reg);
+
+       /* ISPCSI1_DAT_START for logical channel #0 */
+       reg = ISPCSI1_LCx_DAT_START(0);         /* reg = ISPCSI1_DAT_START; */
+       val = omap_readl(reg);
+       BIT_SET(val, 16, 0xfff, config->u.csi.data_start);
+       omap_writel(val, reg);
+
+       /* ISPCSI1_DAT_SIZE for logical channel #0 */
+       reg = ISPCSI1_LCx_DAT_SIZE(0);          /* reg = ISPCSI1_DAT_SIZE; */
+       val = omap_readl(reg);
+       BIT_SET(val, 16, 0xfff, config->u.csi.data_size);
+       omap_writel(val, reg);
+
+       /* Clear status bits for logical channel #0 */
+       omap_writel(0xFFF & ~BIT(6), ISPCSI1_LC01_IRQSTATUS);
+
+       /* Enable CSI1 */
+       val = omap_readl(ISPCSI1_CTRL);
+       val |=  BIT(0) | BIT(4);
+       omap_writel(val, ISPCSI1_CTRL);
+
+       if (!(omap_readl(ISPCSI1_CTRL) & BIT(4))) {
+               printk(KERN_WARNING "OMAP3 CSI1 bus not available\n");
+               if (config->u.csi.signalling)   /* Strobe mode requires CSI1 */
+                       return -EIO;
+       }
+
+       return 0;
+}
+
+/**
+ * isp_configure_interface - Configures ISP Control I/F related parameters.
+ * @config: Pointer to structure containing the desired configuration for the
+ *     ISP.
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
+       u32 ispctrl_val = omap_readl(ISP_CTRL);
+       u32 ispccdc_vdint_val;
+       int r;
+
+       ispctrl_val &= ISPCTRL_SHIFT_MASK;
+       ispctrl_val |= (config->dataline_shift << ISPCTRL_SHIFT_SHIFT);
+       ispctrl_val &= ~ISPCTRL_PAR_CLK_POL_INV;
+
+       ispctrl_val &= (ISPCTRL_PAR_SER_CLK_SEL_MASK);
+       switch (config->ccdc_par_ser) {
+       case ISP_PARLL:
+               ispctrl_val |= ISPCTRL_PAR_SER_CLK_SEL_PARALLEL;
+               ispctrl_val |= (config->u.par.par_clk_pol
+                                               << ISPCTRL_PAR_CLK_POL_SHIFT);
+               ispctrl_val &= ~ISPCTRL_PAR_BRIDGE_BENDIAN;
+               ispctrl_val |= (config->u.par.par_bridge
+                                               << ISPCTRL_PAR_BRIDGE_SHIFT);
+               break;
+       case ISP_CSIA:
+               ispctrl_val |= ISPCTRL_PAR_SER_CLK_SEL_CSIA;
+               ispctrl_val &= ~ISPCTRL_PAR_BRIDGE_BENDIAN;
+               ispctrl_val |= (0x03 << ISPCTRL_PAR_BRIDGE_SHIFT);
+
+               isp_csi2_ctx_config_format(0, config->u.csi.format);
+               isp_csi2_ctx_update(0, false);
+
+               if (config->u.csi.crc)
+                       isp_csi2_ctrl_config_ecc_enable(true);
+
+               isp_csi2_ctrl_config_vp_out_ctrl(config->u.csi.vpclk);
+               isp_csi2_ctrl_config_vp_only_enable(true);
+               isp_csi2_ctrl_config_vp_clk_enable(true);
+               isp_csi2_ctrl_update(false);
+
+               isp_csi2_irq_complexio1_set(1);
+               isp_csi2_irq_status_set(1);
+               isp_csi2_irq_set(1);
+
+               isp_csi2_enable(1);
+               mdelay(3);
+               break;
+       case ISP_CSIB:
+               ispctrl_val |= ISPCTRL_PAR_SER_CLK_SEL_CSIB;
+               r = isp_init_csi(config);
+               if (r)
+                       return r;
+               break;
+       default:
+               return -EINVAL;
+       }
+
+       ispctrl_val &= ~(ISPCTRL_SYNC_DETECT_VSRISE);
+       ispctrl_val |= (config->hsvs_syncdetect);
+
+       omap_writel(ispctrl_val, ISP_CTRL);
+
+       ispccdc_vdint_val = omap_readl(ISPCCDC_VDINT);
+       ispccdc_vdint_val &= ~(ISPCCDC_VDINT_0_MASK << ISPCCDC_VDINT_0_SHIFT);
+       ispccdc_vdint_val &= ~(ISPCCDC_VDINT_1_MASK << ISPCCDC_VDINT_1_SHIFT);
+       omap_writel((config->vdint0_timing << ISPCCDC_VDINT_0_SHIFT) |
+                                               (config->vdint1_timing <<
+                                               ISPCCDC_VDINT_1_SHIFT),
+                                               ISPCCDC_VDINT);
+
+       /* Set sensor specific fields in CCDC and Previewer module.*/
+       isppreview_set_skip(config->prev_sph, config->prev_slv);
+       ispccdc_set_wenlog(config->wenlog);
+
+       return 0;
+}
+EXPORT_SYMBOL(isp_configure_interface);
+
+/**
+ * isp_configure_interface_bridge - Configure CCDC i/f bridge.
+ *
+ * Sets the bit field that controls the 8 to 16-bit bridge at
+ * the input to CCDC.
+ **/
+int isp_configure_interface_bridge(u32 par_bridge)
+{
+       u32 ispctrl_val = omap_readl(ISP_CTRL);
+
+       ispctrl_val &= ~ISPCTRL_PAR_BRIDGE_BENDIAN;
+       ispctrl_val |= (par_bridge << ISPCTRL_PAR_BRIDGE_SHIFT);
+       omap_writel(ispctrl_val, ISP_CTRL);
+       return 0;
+}
+EXPORT_SYMBOL(isp_configure_interface_bridge);
+
+/**
+ * isp_CCDC_VD01_enable - Enables VD0 and VD1 IRQs.
+ *
+ * Sets VD0 and VD1 bits in IRQ0STATUS to reset the flag, and sets them in
+ * IRQ0ENABLE to enable the corresponding IRQs.
+ **/
+void isp_CCDC_VD01_enable(void)
+{
+       omap_writel(IRQ0STATUS_CCDC_VD0_IRQ | IRQ0STATUS_CCDC_VD1_IRQ,
+                                                       ISP_IRQ0STATUS);
+       omap_writel(omap_readl(ISP_IRQ0ENABLE) | IRQ0ENABLE_CCDC_VD0_IRQ |
+                                               IRQ0ENABLE_CCDC_VD1_IRQ,
+                                               ISP_IRQ0ENABLE);
+}
+
+/**
+ * isp_CCDC_VD01_disable - Disables VD0 and VD1 IRQs.
+ *
+ * Clears VD0 and VD1 bits in IRQ0ENABLE register.
+ **/
+void isp_CCDC_VD01_disable(void)
+{
+       omap_writel(omap_readl(ISP_IRQ0ENABLE) & ~(IRQ0ENABLE_CCDC_VD0_IRQ |
+                                               IRQ0ENABLE_CCDC_VD1_IRQ),
+                                               ISP_IRQ0ENABLE);
+}
+
+/**
+ * omap34xx_isp_isr - Interrupt Service Routine for Camera ISP module.
+ * @irq: Not used currently.
+ * @ispirq_disp: Pointer to the object that is passed while request_irq is
+ *               called. This is the ispirq_obj object containing info on the
+ *               callback.
+ *
+ * Handles the corresponding callback if plugged in.
+ *
+ * Returns IRQ_HANDLED when IRQ was correctly handled, or IRQ_NONE when the
+ * IRQ wasn't handled.
+ **/
+static irqreturn_t omap34xx_isp_isr(int irq, void *ispirq_disp)
+{
+       struct ispirq *irqdis = (struct ispirq *)ispirq_disp;
+       u32 irqstatus = 0;
+       unsigned long irqflags = 0;
+       u8 is_irqhandled = 0;
+
+       irqstatus = omap_readl(ISP_IRQ0STATUS);
+
+       spin_lock_irqsave(&isp_obj.lock, irqflags);
+
+       if (irqdis->isp_callbk[CBK_CATCHALL]) {
+               irqdis->isp_callbk[CBK_CATCHALL](irqstatus,
+                               irqdis->isp_callbk_arg1[CBK_CATCHALL],
+                               irqdis->isp_callbk_arg2[CBK_CATCHALL]);
+               is_irqhandled = 1;
+       }
+
+       if ((irqstatus & MMU_ERR) == MMU_ERR) {
+               if (irqdis->isp_callbk[CBK_MMU_ERR])
+                       irqdis->isp_callbk[CBK_MMU_ERR](irqstatus,
+                               irqdis->isp_callbk_arg1[CBK_MMU_ERR],
+                               irqdis->isp_callbk_arg2[CBK_MMU_ERR]);
+               is_irqhandled = 1;
+               printk(KERN_ALERT "%s: MMU error!!! Ouch!\n", __func__);
+               goto out;
+       }
+
+       if ((irqstatus & CCDC_VD1) == CCDC_VD1) {
+               if (irqdis->isp_callbk[CBK_CCDC_VD1])
+                               irqdis->isp_callbk[CBK_CCDC_VD1](CCDC_VD1,
+                               irqdis->isp_callbk_arg1[CBK_CCDC_VD1],
+                               irqdis->isp_callbk_arg2[CBK_CCDC_VD1]);
+               is_irqhandled = 1;
+       }
+
+       if ((irqstatus & CCDC_VD0) == CCDC_VD0) {
+               if (irqdis->isp_callbk[CBK_CCDC_VD0])
+                       irqdis->isp_callbk[CBK_CCDC_VD0](CCDC_VD0,
+                               irqdis->isp_callbk_arg1[CBK_CCDC_VD0],
+                               irqdis->isp_callbk_arg2[CBK_CCDC_VD0]);
+               is_irqhandled = 1;
+       }
+
+       if ((irqstatus & PREV_DONE) == PREV_DONE) {
+               if (irqdis->isp_callbk[CBK_PREV_DONE])
+                       irqdis->isp_callbk[CBK_PREV_DONE](PREV_DONE,
+                               irqdis->isp_callbk_arg1[CBK_PREV_DONE],
+                               irqdis->isp_callbk_arg2[CBK_PREV_DONE]);
+               is_irqhandled = 1;
+       }
+
+       if ((irqstatus & RESZ_DONE) == RESZ_DONE) {
+               if (irqdis->isp_callbk[CBK_RESZ_DONE])
+                       irqdis->isp_callbk[CBK_RESZ_DONE](RESZ_DONE,
+                               irqdis->isp_callbk_arg1[CBK_RESZ_DONE],
+                               irqdis->isp_callbk_arg2[CBK_RESZ_DONE]);
+               is_irqhandled = 1;
+       }
+
+       if ((irqstatus & H3A_AWB_DONE) == H3A_AWB_DONE) {
+               if (irqdis->isp_callbk[CBK_H3A_AWB_DONE])
+                       irqdis->isp_callbk[CBK_H3A_AWB_DONE](H3A_AWB_DONE,
+                               irqdis->isp_callbk_arg1[CBK_H3A_AWB_DONE],
+                               irqdis->isp_callbk_arg2[CBK_H3A_AWB_DONE]);
+               is_irqhandled = 1;
+       }
+
+       if ((irqstatus & HIST_DONE) == HIST_DONE) {
+               if (irqdis->isp_callbk[CBK_HIST_DONE])
+                       irqdis->isp_callbk[CBK_HIST_DONE](HIST_DONE,
+                               irqdis->isp_callbk_arg1[CBK_HIST_DONE],
+                               irqdis->isp_callbk_arg2[CBK_HIST_DONE]);
+               is_irqhandled = 1;
+       }
+
+       if ((irqstatus & HS_VS) == HS_VS) {
+               if (irqdis->isp_callbk[CBK_HS_VS])
+                       irqdis->isp_callbk[CBK_HS_VS](HS_VS,
+                               irqdis->isp_callbk_arg1[CBK_HS_VS],
+                               irqdis->isp_callbk_arg2[CBK_HS_VS]);
+               is_irqhandled = 1;
+       }
+
+       if ((irqstatus & H3A_AF_DONE) == H3A_AF_DONE) {
+               if (irqdis->isp_callbk[CBK_H3A_AF_DONE])
+                       irqdis->isp_callbk[CBK_H3A_AF_DONE](H3A_AF_DONE,
+                               irqdis->isp_callbk_arg1[CBK_H3A_AF_DONE],
+                               irqdis->isp_callbk_arg2[CBK_H3A_AF_DONE]);
+               is_irqhandled = 1;
+       }
+
+       if ((irqstatus & CSIA) == CSIA) {
+               isp_csi2_isr();
+               is_irqhandled = 1;
+       }
+
+       if (irqstatus & LSC_PRE_ERR) {
+               printk(KERN_ERR "isp_sr: LSC_PRE_ERR \n");
+               omap_writel(irqstatus, ISP_IRQ0STATUS);
+               ispccdc_enable_lsc(0);
+               ispccdc_enable_lsc(1);
+               spin_unlock_irqrestore(&isp_obj.lock, irqflags);
+               return IRQ_HANDLED;
+       }
+
+       if (irqstatus & IRQ0STATUS_CSIB_IRQ) {
+               u32 ispcsi1_irqstatus;
+
+               ispcsi1_irqstatus = omap_readl(ISPCSI1_LC01_IRQSTATUS);
+               DPRINTK_ISPCTRL("%x\n", ispcsi1_irqstatus);
+       }
+
+out:
+       omap_writel(irqstatus, ISP_IRQ0STATUS);
+       spin_unlock_irqrestore(&isp_obj.lock, irqflags);
+
+       if (is_irqhandled)
+               return IRQ_HANDLED;
+       else
+               return IRQ_NONE;
+}
+
+/* Device name, needed for resource tracking layer */
+struct device_driver camera_drv = {
+       .name = "camera"
+};
+
+struct device camera_dev = {
+       .driver = &camera_drv,
+};
+
+/**
+ * omapisp_unset_callback - Unsets all the callbacks associated with ISP module
+ **/
+void omapisp_unset_callback()
+{
+       isp_unset_callback(CBK_HS_VS);
+
+       if ((ispmodule_obj.isp_pipeline & OMAP_ISP_RESIZER) &&
+                                               is_ispresizer_enabled())
+               isp_unset_callback(CBK_RESZ_DONE);
+
+       if ((ispmodule_obj.isp_pipeline & OMAP_ISP_PREVIEW) &&
+                                               is_isppreview_enabled())
+               isp_unset_callback(CBK_PREV_DONE);
+
+       if (ispmodule_obj.isp_pipeline & OMAP_ISP_CCDC) {
+               isp_unset_callback(CBK_CCDC_VD0);
+               isp_unset_callback(CBK_CCDC_VD1);
+               isp_unset_callback(CBK_LSC_ISR);
+       }
+       omap_writel(omap_readl(ISP_IRQ0STATUS) | ISP_INT_CLR, ISP_IRQ0STATUS);
+}
+
+#if ISP_WORKAROUND
+/**
+ *  isp_buf_allocation - To allocate a 10MB memory
+ *
+ **/
+u32 isp_buf_allocation(void)
+{
+       buff_addr = (void *)vmalloc(buffer_size);
+
+       if (!buff_addr) {
+               printk(KERN_ERR "Cannot allocate memory ");
+               return -ENOMEM;
+       }
+
+       sglist_alloc = videobuf_vmalloc_to_sg(buff_addr, no_of_pages);
+       if (!sglist_alloc) {
+               printk(KERN_ERR "videobuf_vmalloc_to_sg error");
+               return -ENOMEM;
+       }
+       num_sc = dma_map_sg(NULL, sglist_alloc, no_of_pages, 1);
+       buff_addr_mapped = ispmmu_map_sg(sglist_alloc, no_of_pages);
+       if (!buff_addr_mapped) {
+               printk(KERN_ERR "ispmmu_map_sg mapping failed ");
+               return -ENOMEM;
+       }
+       isppreview_set_outaddr(buff_addr_mapped);
+       alloc_done = 1;
+       return 0;
+}
+
+/**
+ *  isp_buf_get - Get the buffer pointer address
+ **/
+dma_addr_t isp_buf_get(void)
+{
+       dma_addr_t retaddr;
+
+       if (alloc_done == 1)
+               retaddr = buff_addr_mapped + offset_value;
+       else
+               retaddr = 0;
+       return retaddr;
+}
+
+/**
+ *  isp_buf_free - To free allocated 10MB memory
+ *
+ **/
+void isp_buf_free(void)
+{
+       if (alloc_done == 1) {
+               ispmmu_unmap(buff_addr_mapped);
+               dma_unmap_sg(NULL, sglist_alloc, no_of_pages, 1);
+               kfree(sglist_alloc);
+               vfree(buff_addr);
+               alloc_done = 0;
+       }
+}
+#endif
+
+/**
+ * isp_start - Starts ISP submodule
+ *
+ * Start the needed isp components assuming these components
+ * are configured correctly.
+ **/
+void isp_start(void)
+{
+       if ((ispmodule_obj.isp_pipeline & OMAP_ISP_PREVIEW) &&
+                                               is_isppreview_enabled())
+               isppreview_enable(1);
+
+       return;
+}
+EXPORT_SYMBOL(isp_start);
+
+#define ISP_STOP_TIMEOUT       1000
+/**
+ * isp_stop - Stops isp submodules
+ **/
+void isp_stop()
+{
+       unsigned long timeout = jiffies + ISP_STOP_TIMEOUT;
+
+       spin_lock(&isp_obj.isp_temp_buf_lock);
+       ispmodule_obj.isp_temp_state = ISP_FREE_RUNNING;
+       spin_unlock(&isp_obj.isp_temp_buf_lock);
+
+       omapisp_unset_callback();
+
+       ispccdc_enable_lsc(0);
+       ispccdc_enable(0);
+       while (ispccdc_busy() && !time_after(jiffies, timeout))
+               msleep(1);
+
+       if (ispccdc_busy())
+               printk(KERN_ERR "%s: ccdc doesn't stop\n", __func__);
+
+       timeout = jiffies + ISP_STOP_TIMEOUT;
+       isppreview_enable(0);
+       while (isppreview_busy() && !time_after(jiffies, timeout))
+               msleep(1);
+
+       if (isppreview_busy())
+               printk(KERN_ERR "%s: preview doesn't stop\n", __func__);
+
+       timeout = jiffies + ISP_STOP_TIMEOUT;
+       ispresizer_enable(0);
+       while (ispresizer_busy() && !time_after(jiffies, timeout))
+               msleep(1);
+
+       if (ispresizer_busy())
+               printk(KERN_ERR "%s: resizer doesn't stop\n", __func__);
+
+       timeout = jiffies + ISP_STOP_TIMEOUT;
+       isp_save_ctx();
+       omap_writel(omap_readl(ISP_SYSCONFIG) | ISP_SYSCONFIG_SOFTRESET,
+                                                               ISP_SYSCONFIG);
+       while (!(omap_readl(ISP_SYSSTATUS) & 0x1)) {
+               if (time_after(jiffies, timeout)) {
+                       printk(KERN_ALERT "isp.c: cannot reset ISP\n");
+                       return;
+               }
+               msleep(1);
+       }
+       isp_restore_ctx();
+}
+
+/**
+ * isp_set_buf - Sets output address for submodules.
+ * @sgdma_state: Pointer to structure with the SGDMA state for each videobuffer
+ **/
+void isp_set_buf(struct isp_sgdma_state *sgdma_state)
+{
+       if ((ispmodule_obj.isp_pipeline & OMAP_ISP_RESIZER) &&
+                                               is_ispresizer_enabled())
+               ispresizer_set_outaddr(sgdma_state->isp_addr);
+#if (ISP_WORKAROUND == 0)
+       else if ((ispmodule_obj.isp_pipeline & OMAP_ISP_PREVIEW) &&
+                                               is_isppreview_enabled())
+               isppreview_set_outaddr(sgdma_state->isp_addr);
+#endif
+       else if (ispmodule_obj.isp_pipeline & OMAP_ISP_CCDC)
+               ispccdc_set_outaddr(sgdma_state->isp_addr);
+
+}
+
+/**
+ * isp_calc_pipeline - Sets pipeline depending of input and output pixel format
+ * @pix_input: Pointer to V4L2 pixel format structure for input image.
+ * @pix_output: Pointer to V4L2 pixel format structure for output image.
+ **/
+u32 isp_calc_pipeline(struct v4l2_pix_format *pix_input,
+                                       struct v4l2_pix_format *pix_output)
+{
+#if ISP_WORKAROUND
+       int rval;
+#endif
+
+       isp_release_resources();
+       if ((pix_input->pixelformat == V4L2_PIX_FMT_SGRBG10) &&
+                       (pix_output->pixelformat != V4L2_PIX_FMT_SGRBG10)) {
+               ispmodule_obj.isp_pipeline = OMAP_ISP_CCDC | OMAP_ISP_PREVIEW |
+                                                       OMAP_ISP_RESIZER;
+               ispccdc_request();
+               isppreview_request();
+               ispresizer_request();
+               ispccdc_config_datapath(CCDC_RAW, CCDC_OTHERS_VP);
+#if ISP_WORKAROUND
+               isppreview_config_datapath(PRV_RAW_CCDC, PREVIEW_MEM);
+               ispresizer_config_datapath(RSZ_MEM_YUV);
+               if (alloc_done == 0) {
+                       rval = isp_buf_allocation();
+                       if (rval)
+                               return -EINVAL;
+               }
+#else
+               isppreview_config_datapath(PRV_RAW_CCDC, PREVIEW_RSZ);
+               ispresizer_config_datapath(RSZ_OTFLY_YUV);
+#endif
+       } else {
+               ispmodule_obj.isp_pipeline = OMAP_ISP_CCDC;
+               ispccdc_request();
+               if (pix_input->pixelformat == V4L2_PIX_FMT_SGRBG10)
+                       ispccdc_config_datapath(CCDC_RAW, CCDC_OTHERS_VP_MEM);
+               else
+                       ispccdc_config_datapath(CCDC_YUV_SYNC,
+                                                       CCDC_OTHERS_MEM);
+       }
+       return 0;
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
+void isp_config_pipeline(struct v4l2_pix_format *pix_input,
+                                       struct v4l2_pix_format *pix_output)
+{
+       ispccdc_config_size(ispmodule_obj.ccdc_input_width,
+                       ispmodule_obj.ccdc_input_height,
+                       ispmodule_obj.ccdc_output_width,
+                       ispmodule_obj.ccdc_output_height);
+
+       if (ispmodule_obj.isp_pipeline & OMAP_ISP_PREVIEW) {
+               isppreview_config_size(ispmodule_obj.preview_input_width,
+                       ispmodule_obj.preview_input_height,
+                       ispmodule_obj.preview_output_width,
+                       ispmodule_obj.preview_output_height);
+       }
+
+       if (ispmodule_obj.isp_pipeline & OMAP_ISP_RESIZER) {
+               ispresizer_config_size(ispmodule_obj.resizer_input_width,
+                       ispmodule_obj.resizer_input_height,
+                       ispmodule_obj.resizer_output_width,
+                       ispmodule_obj.resizer_output_height);
+       }
+
+       if (pix_output->pixelformat == V4L2_PIX_FMT_UYVY) {
+               isppreview_config_ycpos(YCPOS_YCrYCb);
+               if (is_ispresizer_enabled())
+                       ispresizer_config_ycpos(0);
+       } else {
+               isppreview_config_ycpos(YCPOS_CrYCbY);
+               if (is_ispresizer_enabled())
+                       ispresizer_config_ycpos(1);
+       }
+
+       return;
+}
+
+/**
+ * isp_vbq_done - Callback for interrupt completion
+ * @status: IRQ0STATUS register value. Passed by the ISR, or the caller.
+ * @arg1: Pointer to callback function for SG-DMA management.
+ * @arg2: Pointer to videobuffer structure managed by ISP.
+ **/
+void isp_vbq_done(unsigned long status, isp_vbq_callback_ptr arg1, void *arg2)
+{
+       struct videobuf_buffer *vb = (struct videobuf_buffer *) arg2;
+       int notify = 0;
+       int rval = 0;
+       unsigned long flags;
+
+       switch (status) {
+       case CCDC_VD0:
+               ispccdc_config_shadow_registers();
+               if ((ispmodule_obj.isp_pipeline & OMAP_ISP_RESIZER) ||
+                       (ispmodule_obj.isp_pipeline & OMAP_ISP_PREVIEW))
+                       return;
+               else {
+                       spin_lock(&isp_obj.isp_temp_buf_lock);
+                       if (ispmodule_obj.isp_temp_state != ISP_BUF_INIT) {
+                               spin_unlock(&isp_obj.isp_temp_buf_lock);
+                               return;
+
+                       } else {
+                               spin_unlock(&isp_obj.isp_temp_buf_lock);
+                               break;
+                       }
+               }
+               break;
+       case CCDC_VD1:
+               if ((ispmodule_obj.isp_pipeline & OMAP_ISP_RESIZER) ||
+                               (ispmodule_obj.isp_pipeline & OMAP_ISP_PREVIEW))
+                       return;
+               spin_lock(&isp_obj.isp_temp_buf_lock);
+               if (ispmodule_obj.isp_temp_state == ISP_BUF_INIT) {
+                       spin_unlock(&isp_obj.isp_temp_buf_lock);
+                       ispccdc_enable(0);
+                       return;
+               }
+               spin_unlock(&isp_obj.isp_temp_buf_lock);
+               return;
+       case PREV_DONE:
+               if (is_isppreview_enabled()) {
+                       if (ispmodule_obj.isp_pipeline & OMAP_ISP_RESIZER) {
+                               spin_lock(&isp_obj.isp_temp_buf_lock);
+                               if (!ispmodule_obj.applyCrop &&
+                                               (ispmodule_obj.isp_temp_state ==
+                                               ISP_BUF_INIT))
+                                       ispresizer_enable(1);
+                               spin_unlock(&isp_obj.isp_temp_buf_lock);
+                               if (ispmodule_obj.applyCrop &&
+                                                       !ispresizer_busy()) {
+                                       ispresizer_enable(0);
+                                       ispresizer_applycrop();
+                                       ispmodule_obj.applyCrop = 0;
+                               }
+                               isppreview_config_shadow_registers();
+                               isph3a_update_wb();
+                       }
+                       if (ispmodule_obj.isp_pipeline & OMAP_ISP_RESIZER)
+                               return;
+               }
+               break;
+       case RESZ_DONE:
+               if (is_ispresizer_enabled()) {
+                       ispresizer_config_shadow_registers();
+                       spin_lock(&isp_obj.isp_temp_buf_lock);
+                       if (ispmodule_obj.isp_temp_state != ISP_BUF_INIT) {
+                               spin_unlock(&isp_obj.isp_temp_buf_lock);
+                               return;
+                       }
+                       spin_unlock(&isp_obj.isp_temp_buf_lock);
+               }
+               break;
+       case HS_VS:
+               spin_lock(&isp_obj.isp_temp_buf_lock);
+               if (ispmodule_obj.isp_temp_state == ISP_BUF_TRAN) {
+                       isp_CCDC_VD01_enable();
+                       ispmodule_obj.isp_temp_state = ISP_BUF_INIT;
+               }
+               spin_unlock(&isp_obj.isp_temp_buf_lock);
+               return;
+       default:
+               return;
+       }
+
+       spin_lock_irqsave(&ispsg.lock, flags);
+       ispsg.free_sgdma++;
+       if (ispsg.free_sgdma > NUM_SG_DMA)
+               ispsg.free_sgdma = NUM_SG_DMA;
+       spin_unlock_irqrestore(&ispsg.lock, flags);
+
+       rval = arg1(vb);
+
+       if (rval)
+               isp_sgdma_process(&ispsg, 1, &notify, arg1);
+
+       return;
+}
+
+/**
+ * isp_sgdma_init - Initializes Scatter Gather DMA status and operations.
+ **/
+void isp_sgdma_init()
+{
+       int sg;
+
+       ispsg.free_sgdma = NUM_SG_DMA;
+       ispsg.next_sgdma = 0;
+       for (sg = 0; sg < NUM_SG_DMA; sg++) {
+               ispsg.sg_state[sg].status = 0;
+               ispsg.sg_state[sg].callback = NULL;
+               ispsg.sg_state[sg].arg = NULL;
+       }
+}
+EXPORT_SYMBOL(isp_stop);
+
+/**
+ * isp_vbq_sync - Walks the pages table and flushes the cache for
+ *                each page.
+ **/
+int isp_vbq_sync(struct videobuf_buffer *vb)
+{
+       struct videobuf_dmabuf *vdma;
+       u32 sg_element_addr;
+       int i;
+
+       vdma = videobuf_to_dma(vb);
+
+       for (i = 0; i < vdma->sglen; i++) {
+               sg_element_addr = sg_dma_address(vdma->sglist + i);
+               /* Page align address */
+               sg_element_addr &= ~(PAGE_SIZE - 1);
+
+               dma_sync_single_for_cpu(NULL, sg_element_addr, PAGE_SIZE,
+                                                       DMA_FROM_DEVICE);
+       }
+       return 0;
+}
+
+/**
+ * isp_sgdma_process - Sets operations and config for specified SG DMA
+ * @sgdma: SG-DMA function to work on.
+ * @irq: Flag to specify if an IRQ is associated with the DMA completion.
+ * @dma_notify: Pointer to flag that says when the ISP has to be started.
+ * @func_ptr: Callback function pointer for SG-DMA setup.
+ **/
+void isp_sgdma_process(struct isp_sgdma *sgdma, int irq, int *dma_notify,
+                                               isp_vbq_callback_ptr func_ptr)
+{
+       struct isp_sgdma_state *sgdma_state;
+       unsigned long flags;
+       spin_lock_irqsave(&sgdma->lock, flags);
+
+       if (NUM_SG_DMA > sgdma->free_sgdma) {
+               sgdma_state = sgdma->sg_state + (sgdma->next_sgdma +
+                                               sgdma->free_sgdma) % NUM_SG_DMA;
+               if (!irq) {
+                       if (*dma_notify) {
+                               isp_set_sgdma_callback(sgdma_state, func_ptr);
+                               isp_set_buf(sgdma_state);
+                               ispccdc_enable(1);
+                               isp_start();
+                               *dma_notify = 0;
+                               spin_lock(&isp_obj.isp_temp_buf_lock);
+                               if (ispmodule_obj.isp_pipeline
+                                                       & OMAP_ISP_RESIZER) {
+                                       ispmodule_obj.isp_temp_state =
+                                                               ISP_BUF_INIT;
+                               } else {
+                                       ispmodule_obj.isp_temp_state =
+                                                               ISP_BUF_TRAN;
+                               }
+                               spin_unlock(&isp_obj.isp_temp_buf_lock);
+                       } else {
+                               spin_lock(&isp_obj.isp_temp_buf_lock);
+                               if (ispmodule_obj.isp_temp_state ==
+                                                       ISP_FREE_RUNNING) {
+                                       isp_set_sgdma_callback(sgdma_state,
+                                                               func_ptr);
+                                       isp_set_buf(sgdma_state);
+                                       /* Non startup case */
+                                       if (ispmodule_obj.isp_pipeline
+                                                       & OMAP_ISP_RESIZER) {
+                                               ispmodule_obj.isp_temp_state =
+                                                               ISP_BUF_INIT;
+                                       } else {
+                                               ispmodule_obj.isp_temp_state =
+                                                               ISP_BUF_TRAN;
+                                               ispccdc_enable(1);
+                                       }
+                               }
+                               spin_unlock(&isp_obj.isp_temp_buf_lock);
+                       }
+               } else {
+                       isp_set_sgdma_callback(sgdma_state, func_ptr);
+                       isp_set_buf(sgdma_state);
+                       /* Non startup case */
+                       if (!(ispmodule_obj.isp_pipeline & OMAP_ISP_RESIZER))
+                               ispccdc_enable(1);
+
+                       if (*dma_notify) {
+                               isp_start();
+                               *dma_notify = 0;
+                       }
+               }
+       } else {
+               spin_lock(&isp_obj.isp_temp_buf_lock);
+               isp_CCDC_VD01_disable();
+               ispresizer_enable(0);
+               ispmodule_obj.isp_temp_state = ISP_FREE_RUNNING;
+               spin_unlock(&isp_obj.isp_temp_buf_lock);
+       }
+       spin_unlock_irqrestore(&sgdma->lock, flags);
+       return;
+}
+
+/**
+ * isp_sgdma_queue - Queues a Scatter-Gather DMA videobuffer.
+ * @vdma: Pointer to structure containing the desired DMA video buffer
+ *        transfer parameters.
+ * @vb: Pointer to structure containing the target videobuffer.
+ * @irq: Flag to specify if an IRQ is associated with the DMA completion.
+ * @dma_notify: Pointer to flag that says when the ISP has to be started.
+ * @func_ptr: Callback function pointer for SG-DMA setup.
+ *
+ * Returns 0 if successful, -EINVAL if invalid SG linked list setup, or -EBUSY
+ * if the ISP SG-DMA is not free.
+ **/
+int isp_sgdma_queue(struct videobuf_dmabuf *vdma, struct videobuf_buffer *vb,
+                                               int irq, int *dma_notify,
+                                               isp_vbq_callback_ptr func_ptr)
+{
+       unsigned long flags;
+       struct isp_sgdma_state *sg_state;
+       const struct scatterlist *sglist = vdma->sglist;
+       int sglen = vdma->sglen;
+
+       if ((sglen < 0) || ((sglen > 0) & !sglist))
+               return -EINVAL;
+       isp_vbq_sync(vb);
+
+       spin_lock_irqsave(&ispsg.lock, flags);
+
+       if (!ispsg.free_sgdma) {
+               spin_unlock_irqrestore(&ispsg.lock, flags);
+               return -EBUSY;
+       }
+
+       sg_state = ispsg.sg_state + ispsg.next_sgdma;
+       sg_state->isp_addr = ispsg.isp_addr_capture[vb->i];
+       sg_state->status = 0;
+       sg_state->callback = isp_vbq_done;
+       sg_state->arg = vb;
+
+       ispsg.next_sgdma = (ispsg.next_sgdma + 1) % NUM_SG_DMA;
+       ispsg.free_sgdma--;
+
+       spin_unlock_irqrestore(&ispsg.lock, flags);
+
+       isp_sgdma_process(&ispsg, irq, dma_notify, func_ptr);
+
+       return 0;
+}
+EXPORT_SYMBOL(isp_sgdma_queue);
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
+                                                       enum v4l2_field field)
+{
+       unsigned int isp_addr;
+       struct videobuf_dmabuf *vdma;
+
+       int err = 0;
+
+       vdma = videobuf_to_dma(vb);
+
+       isp_addr = ispmmu_map_sg(vdma->sglist, vdma->sglen);
+
+       if (!isp_addr)
+               err = -EIO;
+       else
+               ispsg.isp_addr_capture[vb->i] = isp_addr;
+
+       return err;
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
+       ispmmu_unmap(ispsg.isp_addr_capture[vb->i]);
+       ispsg.isp_addr_capture[vb->i] = (dma_addr_t)NULL;
+       return;
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
+       int i;
+
+       if (a->id & V4L2_CTRL_FLAG_NEXT_CTRL) {
+               a->id &= ~V4L2_CTRL_FLAG_NEXT_CTRL;
+               i = find_next_vctrl(a->id);
+       } else {
+               i = find_vctrl(a->id);
+       }
+
+       if (i < 0)
+               return -EINVAL;
+
+       *a = video_control[i].qc;
+       return 0;
+}
+EXPORT_SYMBOL(isp_queryctrl);
+
+/**
+ * isp_g_ctrl - Gets value of the desired V4L2 control.
+ * @a: V4L2 control to read actual value from.
+ *
+ * Return 0 if successful, or -EINVAL if chosen control is not found.
+ **/
+int isp_g_ctrl(struct v4l2_control *a)
+{
+       u8 current_value;
+       int rval = 0;
+
+       switch (a->id) {
+       case V4L2_CID_BRIGHTNESS:
+               isppreview_query_brightness(&current_value);
+               a->value = current_value / ISPPRV_BRIGHT_UNITS;
+               break;
+       case V4L2_CID_CONTRAST:
+               isppreview_query_contrast(&current_value);
+               a->value = current_value / ISPPRV_CONTRAST_UNITS;
+               break;
+       case V4L2_CID_PRIVATE_ISP_COLOR_FX:
+               isppreview_get_color(&current_value);
+               a->value = current_value;
+               break;
+       default:
+               rval = -EINVAL;
+               break;
+       }
+
+       return rval;
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
+       int rval = 0;
+       u8 new_value = a->value;
+
+       switch (a->id) {
+       case V4L2_CID_BRIGHTNESS:
+               if (new_value > ISPPRV_BRIGHT_HIGH)
+                       rval = -EINVAL;
+               else
+                       isppreview_update_brightness(&new_value);
+               break;
+       case V4L2_CID_CONTRAST:
+               if (new_value > ISPPRV_CONTRAST_HIGH)
+                       rval = -EINVAL;
+               else
+                       isppreview_update_contrast(&new_value);
+               break;
+       case V4L2_CID_PRIVATE_ISP_COLOR_FX:
+               if (new_value > PREV_BW_COLOR)
+                       rval = -EINVAL;
+               else
+                       isppreview_set_color(&new_value);
+               break;
+       default:
+               rval = -EINVAL;
+               break;
+       }
+
+       return rval;
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
+       int rval = 0;
+
+       switch (cmd) {
+       case VIDIOC_PRIVATE_ISP_CCDC_CFG:
+               rval = omap34xx_isp_ccdc_config(arg);
+               break;
+       case VIDIOC_PRIVATE_ISP_PRV_CFG:
+               rval = omap34xx_isp_preview_config(arg);
+               break;
+       case VIDIOC_PRIVATE_ISP_AEWB_CFG: {
+               struct isph3a_aewb_config *params;
+               params = (struct isph3a_aewb_config *)arg;
+               rval = isph3a_aewb_configure(params);
+               }
+               break;
+       case VIDIOC_PRIVATE_ISP_AEWB_REQ: {
+               struct isph3a_aewb_data *data;
+               data = (struct isph3a_aewb_data *)arg;
+               rval = isph3a_aewb_request_statistics(data);
+               }
+               break;
+       case VIDIOC_PRIVATE_ISP_HIST_CFG: {
+               struct isp_hist_config *params;
+               params = (struct isp_hist_config *)arg;
+               rval = isp_hist_configure(params);
+               }
+               break;
+       case VIDIOC_PRIVATE_ISP_HIST_REQ: {
+               struct isp_hist_data *data;
+               data = (struct isp_hist_data *)arg;
+               rval = isp_hist_request_statistics(data);
+               }
+               break;
+       case VIDIOC_PRIVATE_ISP_AF_CFG: {
+               struct af_configuration *params;
+               params = (struct af_configuration *)arg;
+               rval = isp_af_configure(params);
+               }
+               break;
+       case VIDIOC_PRIVATE_ISP_AF_REQ: {
+               struct isp_af_data *data;
+               data = (struct isp_af_data *)arg;
+               rval = isp_af_request_statistics(data);
+               }
+               break;
+       default:
+               rval = -EINVAL;
+               break;
+       }
+       return rval;
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
+       int index = f->index;
+       enum v4l2_buf_type type = f->type;
+       int rval = -EINVAL;
+
+       if (index >= NUM_ISP_CAPTURE_FORMATS)
+               goto err;
+
+       memset(f, 0, sizeof(*f));
+       f->index = index;
+       f->type = type;
+
+       switch (f->type) {
+       case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+               rval = 0;
+               break;
+       default:
+               goto err;
+       }
+
+       f->flags = isp_formats[index].flags;
+       strncpy(f->description, isp_formats[index].description,
+                                               sizeof(f->description));
+       f->pixelformat = isp_formats[index].pixelformat;
+err:
+       return rval;
+}
+EXPORT_SYMBOL(isp_enum_fmt_cap);
+
+/**
+ * isp_g_fmt_cap - Gets current output image format.
+ * @f: Pointer to V4L2 format structure to be filled with current output format
+ **/
+void isp_g_fmt_cap(struct v4l2_pix_format *pix)
+{
+       *pix = ispmodule_obj.pix;
+       return;
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
+                                       struct v4l2_pix_format *pix_output)
+{
+       int crop_scaling_w, crop_scaling_h = 0;
+       int rval = 0;
+
+       rval = isp_calc_pipeline(pix_input, pix_output);
+       if (rval)
+               goto out;
+
+       rval = isp_try_size(pix_input, pix_output);
+       if (rval)
+               goto out;
+
+       rval = isp_try_fmt(pix_input, pix_output);
+       if (rval)
+               goto out;
+
+       if (ispcroprect.width != pix_output->width) {
+               crop_scaling_w = 1;
+               ispcroprect.left = 0;
+               ispcroprect.width = pix_output->width;
+       }
+
+       if (ispcroprect.height != pix_output->height) {
+               crop_scaling_h = 1;
+               ispcroprect.top = 0;
+               ispcroprect.height = pix_output->height;
+       }
+
+       isp_config_pipeline(pix_input, pix_output);
+
+       if (crop_scaling_h || crop_scaling_w)
+               isp_config_crop(pix_output);
+
+out:
+       return rval;
+}
+EXPORT_SYMBOL(isp_s_fmt_cap);
+
+/**
+ * isp_config_crop - Configures crop parameters in isp resizer.
+ * @croppix: Pointer to V4L2 pixel format structure containing crop parameters
+ **/
+void isp_config_crop(struct v4l2_pix_format *croppix)
+{
+       u8 crop_scaling_w;
+       u8 crop_scaling_h;
+#if ISP_WORKAROUND
+       unsigned long org_left, num_pix, new_top;
+#endif
+
+       struct v4l2_pix_format *pix = croppix;
+
+       crop_scaling_w = (ispmodule_obj.preview_output_width * 10) /
+                                                               pix->width;
+       crop_scaling_h = (ispmodule_obj.preview_output_height * 10) /
+                                                               pix->height;
+
+       cur_rect.left = (ispcroprect.left * crop_scaling_w) / 10;
+       cur_rect.top = (ispcroprect.top * crop_scaling_h) / 10;
+       cur_rect.width = (ispcroprect.width * crop_scaling_w) / 10;
+       cur_rect.height = (ispcroprect.height * crop_scaling_h) / 10;
+
+#if ISP_WORKAROUND
+       org_left = cur_rect.left;
+       while (((int)cur_rect.left & 0xFFFFFFF0) != (int)cur_rect.left)
+               (int)cur_rect.left--;
+
+       num_pix = org_left - cur_rect.left;
+       new_top = (int)(num_pix * 3) / 4;
+       cur_rect.top = cur_rect.top - new_top;
+       cur_rect.height = (2 * new_top) + cur_rect.height;
+
+       cur_rect.width = cur_rect.width + (2 * num_pix);
+       while (((int)cur_rect.width & 0xFFFFFFF0) != (int)cur_rect.width)
+               (int)cur_rect.width--;
+
+       offset_value = ((cur_rect.left * 2) +
+               ((ispmodule_obj.preview_output_width) * 2 * cur_rect.top));
+#endif
+
+       ispresizer_trycrop(cur_rect.left, cur_rect.top, cur_rect.width,
+                                       cur_rect.height,
+                                       ispmodule_obj.resizer_output_width,
+                                       ispmodule_obj.resizer_output_height);
+
+       return;
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
+       struct v4l2_crop *crop = a;
+
+       crop->c = ispcroprect;
+       return 0;
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
+       struct v4l2_crop *crop = a;
+       int rval = 0;
+
+       if ((crop->c.left + crop->c.width) > pix->width) {
+               rval = -EINVAL;
+               goto out;
+       }
+
+       if ((crop->c.top + crop->c.height) > pix->height) {
+               rval = -EINVAL;
+               goto out;
+       }
+
+       ispcroprect.left = crop->c.left;
+       ispcroprect.top = crop->c.top;
+       ispcroprect.width = crop->c.width;
+       ispcroprect.height = crop->c.height;
+
+       isp_config_crop(pix);
+
+       ispmodule_obj.applyCrop = 1;
+out:
+       return rval;
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
+                                       struct v4l2_pix_format *pix_output)
+{
+       int rval = 0;
+
+       rval = isp_calc_pipeline(pix_input, pix_output);
+       if (rval)
+               goto out;
+
+       rval = isp_try_size(pix_input, pix_output);
+       if (rval)
+               goto out;
+
+       rval = isp_try_fmt(pix_input, pix_output);
+       if (rval)
+               goto out;
+
+out:
+       return rval;
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
+int isp_try_size(struct v4l2_pix_format *pix_input,
+                                       struct v4l2_pix_format *pix_output)
+{
+       int rval = 0;
+
+       if ((pix_output->width <= ISPRSZ_MIN_OUTPUT) ||
+                               (pix_output->height <= ISPRSZ_MIN_OUTPUT))
+               return -EINVAL;
+
+       if ((pix_output->width >= ISPRSZ_MAX_OUTPUT) ||
+                               (pix_output->height > ISPRSZ_MAX_OUTPUT))
+               return -EINVAL;
+
+       ispmodule_obj.ccdc_input_width = pix_input->width;
+       ispmodule_obj.ccdc_input_height = pix_input->height;
+       ispmodule_obj.resizer_output_width = pix_output->width;
+       ispmodule_obj.resizer_output_height = pix_output->height;
+
+       if (ispmodule_obj.isp_pipeline & OMAP_ISP_CCDC) {
+               rval = ispccdc_try_size(ispmodule_obj.ccdc_input_width,
+                                       ispmodule_obj.ccdc_input_height,
+                                       &ispmodule_obj.ccdc_output_width,
+                                       &ispmodule_obj.ccdc_output_height);
+               if (rval) {
+                       printk(KERN_ERR "ISP_ERR: The dimensions %dx%d are not"
+                                       " supported\n", pix_input->width,
+                                       pix_input->height);
+                       return rval;
+               }
+               pix_output->width = ispmodule_obj.ccdc_output_width;
+               pix_output->height = ispmodule_obj.ccdc_output_height;
+       }
+
+       if (ispmodule_obj.isp_pipeline & OMAP_ISP_PREVIEW) {
+               ispmodule_obj.preview_input_width =
+                                       ispmodule_obj.ccdc_output_width;
+               ispmodule_obj.preview_input_height =
+                                       ispmodule_obj.ccdc_output_height;
+               rval = isppreview_try_size(ispmodule_obj.preview_input_width,
+                                       ispmodule_obj.preview_input_height,
+                                       &ispmodule_obj.preview_output_width,
+                                       &ispmodule_obj.preview_output_height);
+               if (rval) {
+                       printk(KERN_ERR "ISP_ERR: The dimensions %dx%d are not"
+                                       " supported\n", pix_input->width,
+                                       pix_input->height);
+                       return rval;
+               }
+               pix_output->width = ispmodule_obj.preview_output_width;
+               pix_output->height = ispmodule_obj.preview_output_height;
+       }
+
+       if (ispmodule_obj.isp_pipeline & OMAP_ISP_RESIZER) {
+               ispmodule_obj.resizer_input_width =
+                                       ispmodule_obj.preview_output_width;
+               ispmodule_obj.resizer_input_height =
+                                       ispmodule_obj.preview_output_height;
+               rval = ispresizer_try_size(&ispmodule_obj.resizer_input_width,
+                                       &ispmodule_obj.resizer_input_height,
+                                       &ispmodule_obj.resizer_output_width,
+                                       &ispmodule_obj.resizer_output_height);
+               if (rval) {
+                       printk(KERN_ERR "ISP_ERR: The dimensions %dx%d are not"
+                                       " supported\n", pix_input->width,
+                                       pix_input->height);
+                       return rval;
+               }
+               pix_output->width = ispmodule_obj.resizer_output_width;
+               pix_output->height = ispmodule_obj.resizer_output_height;
+       }
+
+       return rval;
+}
+EXPORT_SYMBOL(isp_try_size);
+
+/**
+ * isp_try_fmt - Validates input/output format parameters.
+ * @pix_input: Pointer to V4L2 pixel format structure for input image.
+ * @pix_output: Pointer to V4L2 pixel format structure for output image.
+ *
+ * Always returns 0.
+ **/
+int isp_try_fmt(struct v4l2_pix_format *pix_input,
+                                       struct v4l2_pix_format *pix_output)
+{
+       int ifmt;
+
+       for (ifmt = 0; ifmt < NUM_ISP_CAPTURE_FORMATS; ifmt++) {
+               if (pix_output->pixelformat == isp_formats[ifmt].pixelformat)
+                       break;
+       }
+       if (ifmt == NUM_ISP_CAPTURE_FORMATS)
+               ifmt = 1;
+       pix_output->pixelformat = isp_formats[ifmt].pixelformat;
+       pix_output->field = V4L2_FIELD_NONE;
+       pix_output->bytesperline = pix_output->width * ISP_BYTES_PER_PIXEL;
+       pix_output->sizeimage =
+               PAGE_ALIGN(pix_output->bytesperline * pix_output->height);
+       pix_output->priv = 0;
+       switch (pix_output->pixelformat) {
+       case V4L2_PIX_FMT_YUYV:
+       case V4L2_PIX_FMT_UYVY:
+               pix_output->colorspace = V4L2_COLORSPACE_JPEG;
+               break;
+       default:
+               pix_output->colorspace = V4L2_COLORSPACE_SRGB;
+       }
+
+       ispmodule_obj.pix.pixelformat = pix_output->pixelformat;
+       ispmodule_obj.pix.width = pix_output->width;
+       ispmodule_obj.pix.height = pix_output->height;
+       ispmodule_obj.pix.field = pix_output->field;
+       ispmodule_obj.pix.bytesperline = pix_output->bytesperline;
+       ispmodule_obj.pix.sizeimage = pix_output->sizeimage;
+       ispmodule_obj.pix.priv = pix_output->priv;
+       ispmodule_obj.pix.colorspace = pix_output->colorspace;
+
+       return 0;
+}
+EXPORT_SYMBOL(isp_try_fmt);
+
+/**
+ * isp_save_ctx - Saves ISP, CCDC, HIST, H3A, PREV, RESZ & MMU context.
+ *
+ * Routine for saving the context of each module in the ISP.
+ * CCDC, HIST, H3A, PREV, RESZ and MMU.
+ **/
+void isp_save_ctx(void)
+{
+       isp_save_context(isp_reg_list);
+       ispccdc_save_context();
+       ispmmu_save_context();
+       isphist_save_context();
+       isph3a_save_context();
+       isppreview_save_context();
+       ispresizer_save_context();
+}
+EXPORT_SYMBOL(isp_save_ctx);
+
+/**
+ * isp_restore_ctx - Restores ISP, CCDC, HIST, H3A, PREV, RESZ & MMU context.
+ *
+ * Routine for restoring the context of each module in the ISP.
+ * CCDC, HIST, H3A, PREV, RESZ and MMU.
+ **/
+void isp_restore_ctx(void)
+{
+       isp_restore_context(isp_reg_list);
+       ispccdc_restore_context();
+       ispmmu_restore_context();
+       isphist_restore_context();
+       isph3a_restore_context();
+       isppreview_restore_context();
+       ispresizer_restore_context();
+}
+EXPORT_SYMBOL(isp_restore_ctx);
+
+/**
+ * isp_get - Adquires the ISP resource.
+ *
+ * Initializes the clocks for the first acquire.
+ **/
+int isp_get(void)
+{
+       int ret_err = 0;
+       DPRINTK_ISPCTRL("isp_get: old %d\n", isp_obj.ref_count);
+       mutex_lock(&(isp_obj.isp_mutex));
+       if (isp_obj.ref_count == 0) {
+               isp_obj.cam_ick = clk_get(&camera_dev, "cam_ick");
+               if (IS_ERR(isp_obj.cam_ick)) {
+                       DPRINTK_ISPCTRL("ISP_ERR: clk_get for "
+                                                       "cam_ick failed\n");
+                       ret_err = PTR_ERR(isp_obj.cam_ick);
+                       goto out_clk_get_ick;
+               }
+               isp_obj.cam_mclk = clk_get(&camera_dev, "cam_mclk");
+               if (IS_ERR(isp_obj.cam_mclk)) {
+                       DPRINTK_ISPCTRL("ISP_ERR: clk_get for "
+                                                       "cam_mclk failed\n");
+                       ret_err = PTR_ERR(isp_obj.cam_mclk);
+                       goto out_clk_get_mclk;
+               }
+               isp_obj.csi2_fck = clk_get(&camera_dev, "csi2_96m_fck");
+               if (IS_ERR(isp_obj.csi2_fck)) {
+                       DPRINTK_ISPCTRL("ISP_ERR: clk_get for csi2_fclk"
+                                                               " failed\n");
+                       ret_err = PTR_ERR(isp_obj.csi2_fck);
+                       goto out_clk_get_csi2_fclk;
+               }
+               ret_err = clk_enable(isp_obj.cam_ick);
+               if (ret_err) {
+                       DPRINTK_ISPCTRL("ISP_ERR: clk_en for ick failed\n");
+                       goto out_clk_enable_ick;
+               }
+               ret_err = clk_enable(isp_obj.cam_mclk);
+               if (ret_err) {
+                       DPRINTK_ISPCTRL("ISP_ERR: clk_en for mclk failed\n");
+                       goto out_clk_enable_mclk;
+               }
+               ret_err = clk_enable(isp_obj.csi2_fck);
+               if (ret_err) {
+                       DPRINTK_ISPCTRL("ISP_ERR: clk_en for csi2_fclk"
+                                                               " failed\n");
+                       goto out_clk_enable_csi2_fclk;
+               }
+               if (off_mode == 1)
+                       isp_restore_ctx();
+       }
+       isp_obj.ref_count++;
+       mutex_unlock(&(isp_obj.isp_mutex));
+
+
+       DPRINTK_ISPCTRL("isp_get: new %d\n", isp_obj.ref_count);
+       return isp_obj.ref_count;
+
+out_clk_enable_csi2_fclk:
+       clk_disable(isp_obj.cam_mclk);
+out_clk_enable_mclk:
+       clk_disable(isp_obj.cam_ick);
+out_clk_enable_ick:
+       clk_put(isp_obj.csi2_fck);
+out_clk_get_csi2_fclk:
+       clk_put(isp_obj.cam_mclk);
+out_clk_get_mclk:
+       clk_put(isp_obj.cam_ick);
+out_clk_get_ick:
+
+       mutex_unlock(&(isp_obj.isp_mutex));
+
+       return ret_err;
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
+       DPRINTK_ISPCTRL("isp_put: old %d\n", isp_obj.ref_count);
+       mutex_lock(&(isp_obj.isp_mutex));
+       if (isp_obj.ref_count) {
+               if (--isp_obj.ref_count == 0) {
+                       isp_save_ctx();
+                       off_mode = 1;
+#if ISP_WORKAROUND
+                       isp_buf_free();
+#endif
+                       isp_release_resources();
+                       ispmodule_obj.isp_pipeline = 0;
+                       clk_disable(isp_obj.cam_ick);
+                       clk_disable(isp_obj.cam_mclk);
+                       clk_disable(isp_obj.csi2_fck);
+                       clk_put(isp_obj.cam_ick);
+                       clk_put(isp_obj.cam_mclk);
+                       clk_put(isp_obj.csi2_fck);
+                       memset(&ispcroprect, 0, sizeof(ispcroprect));
+                       memset(&cur_rect, 0, sizeof(cur_rect));
+               }
+       }
+       mutex_unlock(&(isp_obj.isp_mutex));
+       DPRINTK_ISPCTRL("isp_put: new %d\n", isp_obj.ref_count);
+       return isp_obj.ref_count;
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
+       struct isp_reg *next = reg_list;
+
+       for (; next->reg != ISP_TOK_TERM; next++)
+               next->val = omap_readl(next->reg);
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
+       struct isp_reg *next = reg_list;
+
+       for (; next->reg != ISP_TOK_TERM; next++)
+               omap_writel(next->val, next->reg);
+}
+EXPORT_SYMBOL(isp_restore_context);
+
+/**
+ * isp_init - ISP module initialization.
+ **/
+static int __init isp_init(void)
+{
+       DPRINTK_ISPCTRL("+isp_init for Omap 3 Camera ISP\n");
+       isp_obj.ref_count = 0;
+
+       mutex_init(&(isp_obj.isp_mutex));
+       spin_lock_init(&isp_obj.isp_temp_buf_lock);
+       spin_lock_init(&isp_obj.lock);
+
+       if (request_irq(INT_34XX_CAM_IRQ, omap34xx_isp_isr, IRQF_SHARED,
+                               "Omap 34xx Camera ISP", &ispirq_obj)) {
+               DPRINTK_ISPCTRL("Could not install ISR\n");
+               return -EINVAL;
+       }
+
+       isp_ccdc_init();
+       isp_hist_init();
+       isph3a_aewb_init();
+       ispmmu_init();
+       isp_preview_init();
+       isp_resizer_init();
+       isp_af_init();
+       isp_csi2_init();
+
+       DPRINTK_ISPCTRL("-isp_init for Omap 3 Camera ISP\n");
+       return 0;
+}
+EXPORT_SYMBOL(isp_sgdma_init);
+
+/**
+ * isp_cleanup - ISP module cleanup.
+ **/
+static void __exit isp_cleanup(void)
+{
+       isp_csi2_cleanup();
+       isp_af_exit();
+       isp_resizer_cleanup();
+       isp_preview_cleanup();
+       ispmmu_cleanup();
+       isph3a_aewb_cleanup();
+       isp_hist_cleanup();
+       isp_ccdc_cleanup();
+       free_irq(INT_34XX_CAM_IRQ, &ispirq_obj);
+}
+
+/**
+ * isp_print_status - Prints the values of the ISP Control Module registers
+ *
+ * Also prints other debug information stored in the ISP module structure.
+ **/
+void isp_print_status(void)
+{
+       if (!is_ispctrl_debug_enabled())
+               return;
+
+       DPRINTK_ISPCTRL("###ISP_CTRL=0x%x\n", omap_readl(ISP_CTRL));
+       DPRINTK_ISPCTRL("###ISP_TCTRL_CTRL=0x%x\n", omap_readl(ISP_TCTRL_CTRL));
+       DPRINTK_ISPCTRL("###ISP_SYSCONFIG=0x%x\n", omap_readl(ISP_SYSCONFIG));
+       DPRINTK_ISPCTRL("###ISP_SYSSTATUS=0x%x\n", omap_readl(ISP_SYSSTATUS));
+       DPRINTK_ISPCTRL("###ISP_IRQ0ENABLE=0x%x\n", omap_readl(ISP_IRQ0ENABLE));
+       DPRINTK_ISPCTRL("###ISP_IRQ0STATUS=0x%x\n", omap_readl(ISP_IRQ0STATUS));
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
index 0000000..7101311
--- /dev/null
+++ b/drivers/media/video/isp/isp.h
@@ -0,0 +1,341 @@
+/*
+ * drivers/media/video/isp/isp.h
+ *
+ * Top level public header file for ISP Control module in
+ * TI's OMAP3 Camera ISP
+ *
+ * Copyright (C) 2008 Texas Instruments.
+ * Copyright (C) 2008 Nokia.
+ *
+ * Contributors:
+ *     Sameer Venkatraman <sameerv@ti.com>
+ *     Mohit Jalori <mjalori@ti.com>
+ *     Sakari Ailus <sakari.ailus@nokia.com>
+ *     Tuukka Toivonen <tuukka.o.toivonen@nokia.com>
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
+#include <media/videobuf-dma-sg.h>
+#include <linux/videodev2.h>
+#define OMAP_ISP_CCDC          (1 << 0)
+#define OMAP_ISP_PREVIEW       (1 << 1)
+#define OMAP_ISP_RESIZER       (1 << 2)
+#define OMAP_ISP_AEWB          (1 << 3)
+#define OMAP_ISP_AF            (1 << 4)
+#define OMAP_ISP_HIST          (1 << 5)
+
+/* Our ISP specific controls */
+#define V4L2_CID_PRIVATE_ISP_COLOR_FX          (V4L2_CID_PRIVATE_BASE + 0)
+
+#define ISP_TOK_TERM           0xFFFFFFFF      /*
+                                                * terminating token for ISP
+                                                * modules reg list
+                                                */
+#define NUM_SG_DMA             (VIDEO_MAX_FRAME + 2)
+
+#define ISP_BUF_INIT           0
+#define ISP_FREE_RUNNING       1
+#define ISP_BUF_TRAN           2
+
+#ifndef CONFIG_ARCH_OMAP3410
+#define USE_ISP_PREVIEW
+#define USE_ISP_RESZ
+#define is_isppreview_enabled()                1
+#define is_ispresizer_enabled()                1
+#else
+#define is_isppreview_enabled()                0
+#define is_ispresizer_enabled()                0
+#endif
+
+#define ISP_XCLKA_DEFAULT              0x12
+#define ISP_OUTPUT_WIDTH_DEFAULT       176
+#define ISP_OUTPUT_HEIGHT_DEFAULT      144
+#define ISP_BYTES_PER_PIXEL            2
+#define NUM_ISP_CAPTURE_FORMATS        (sizeof(isp_formats) /\
+                                                       sizeof(isp_formats[0]))
+#define ISP_WORKAROUND 1
+#define buffer_size (1024 * 1024 * 10)
+#define no_of_pages (buffer_size / (4 * 1024))
+
+typedef int (*isp_vbq_callback_ptr) (struct videobuf_buffer *vb);
+typedef void (*isp_callback_t) (unsigned long status,
+                                       isp_vbq_callback_ptr arg1, void *arg2);
+
+enum isp_interface_type {
+       ISP_PARLL = 1,
+       ISP_CSIA = 2,
+       ISP_CSIB = 4
+};
+
+enum isp_irqevents {
+       CSIA = 0x01,
+       CSIB = 0x10,
+       CCDC_VD0 = 0x100,
+       CCDC_VD1 = 0x200,
+       CCDC_VD2 = 0x400,
+       CCDC_ERR = 0x800,
+       H3A_AWB_DONE = 0x2000,
+       H3A_AF_DONE = 0x1000,
+       HIST_DONE = 0x10000,
+       PREV_DONE = 0x100000,
+       LSC_DONE = 0x20000,
+       LSC_PRE_COMP = 0x40000,
+       LSC_PRE_ERR = 0x80000,
+       RESZ_DONE = 0x1000000,
+       SBL_OVF = 0x2000000,
+       MMU_ERR = 0x10000000,
+       OCP_ERR = 0x20000000,
+       HS_VS = 0x80000000
+};
+
+enum isp_callback_type {
+       CBK_CCDC_VD0,
+       CBK_CCDC_VD1,
+       CBK_PREV_DONE,
+       CBK_RESZ_DONE,
+       CBK_MMU_ERR,
+       CBK_H3A_AWB_DONE,
+       CBK_HIST_DONE,
+       CBK_HS_VS,
+       CBK_LSC_ISR,
+       CBK_H3A_AF_DONE,
+       CBK_CATCHALL,
+       CBK_CSIA,
+       CBK_CSIB,
+       CBK_END,
+};
+
+/**
+ * struct isp_reg - Structure for ISP register values.
+ * @reg: 32-bit Register address.
+ * @val: 32-bit Register value.
+ */
+struct isp_reg {
+       u32 reg;
+       u32 val;
+};
+
+/**
+ * struct isp_sgdma_state - SG-DMA state for each videobuffer + 2 overlays
+ * @isp_addr: ISP space address mapped by ISP MMU.
+ * @status: DMA return code mapped by ISP MMU.
+ * @callback: Pointer to ISP callback function.
+ * @arg: Pointer to argument passed to the specified callback function.
+ */
+struct isp_sgdma_state {
+       dma_addr_t isp_addr;
+       u32 status;
+       isp_callback_t callback;
+       void *arg;
+};
+
+/**
+ * struct isp_sgdma - ISP Scatter Gather DMA status.
+ * @isp_addr_capture: Array of ISP space addresses mapped by the ISP MMU.
+ * @lock: Spinlock used to check free_sgdma field.
+ * @free_sgdma: Number of free SG-DMA slots.
+ * @next_sgdma: Index of next SG-DMA slot to use.
+ */
+struct isp_sgdma {
+       dma_addr_t isp_addr_capture[VIDEO_MAX_FRAME];
+       spinlock_t lock;        /* For handling current buffer */
+       int free_sgdma;
+       int next_sgdma;
+       struct isp_sgdma_state sg_state[NUM_SG_DMA];
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
+ * @vdint0_timing: VD0 Interrupt timing.
+ * @vdint1_timing: VD1 Interrupt timing.
+ * @strobe: Strobe related parameter.
+ * @prestrobe: PreStrobe related parameter.
+ * @shutter: Shutter related parameter.
+ * @hskip: Horizontal Start Pixel performed in Preview module.
+ * @vskip: Vertical Start Line performed in Preview module.
+ * @wenlog: Store the value for the sensor specific wenlog field.
+ */
+struct isp_interface_config {
+       enum isp_interface_type ccdc_par_ser;
+       u8 dataline_shift;
+       u32 hsvs_syncdetect;
+       u16 vdint0_timing;
+       u16 vdint1_timing;
+       int strobe;
+       int prestrobe;
+       int shutter;
+       u32 prev_sph;
+       u32 prev_slv;
+       u32 wenlog;
+       union {
+               struct par {
+                       unsigned par_bridge:2;
+                       unsigned par_clk_pol:1;
+               } par;
+               struct csi {
+                       unsigned crc:1;
+                       unsigned mode:1;
+                       unsigned edge:1;
+                       unsigned signalling:1;
+                       unsigned strobe_clock_inv:1;
+                       unsigned vs_edge:1;
+                       unsigned channel:3;
+                       unsigned vpclk:2;       /* Video port output clock */
+                       unsigned int data_start;
+                       unsigned int data_size;
+                       u32 format;             /* V4L2_PIX_FMT_* */
+               } csi;
+       } u;
+};
+
+/**
+ * struct isp_sysc - ISP Power switches to set.
+ * @reset: Flag for setting ISP reset.
+ * @idle_mode: Flag for setting ISP idle mode.
+ */
+struct isp_sysc {
+       char reset;
+       char idle_mode;
+};
+
+void isp_release_resources(void);
+
+void isp_start(void);
+
+void isp_stop(void);
+
+void isp_sgdma_init(void);
+
+void isp_vbq_done(unsigned long status, isp_vbq_callback_ptr arg1, void *arg2);
+
+void isp_sgdma_process(struct isp_sgdma *sgdma, int irq, int *dma_notify,
+                                               isp_vbq_callback_ptr func_ptr);
+
+int isp_sgdma_queue(struct videobuf_dmabuf *vdma, struct videobuf_buffer *vb,
+                                               int irq, int *dma_notify,
+                                               isp_vbq_callback_ptr func_ptr);
+
+int isp_vbq_prepare(struct videobuf_queue *vbq, struct videobuf_buffer *vb,
+                                                       enum v4l2_field field);
+
+void isp_vbq_release(struct videobuf_queue *vbq, struct videobuf_buffer *vb);
+
+int isp_set_callback(enum isp_callback_type type, isp_callback_t callback,
+                                       isp_vbq_callback_ptr arg1, void *arg2);
+
+void omapisp_unset_callback(void);
+
+int isp_unset_callback(enum isp_callback_type type);
+
+u32 isp_set_xclk(u32 xclk, u8 xclksel);
+
+u32 isp_get_xclk(u8 xclksel);
+
+int isp_request_interface(enum isp_interface_type if_t);
+
+int isp_free_interface(enum isp_interface_type if_t);
+
+void isp_power_settings(struct isp_sysc);
+
+int isp_configure_interface(struct isp_interface_config *config);
+
+void isp_CCDC_VD01_disable(void);
+
+void isp_CCDC_VD01_enable(void);
+
+int isp_get(void);
+
+int isp_put(void);
+
+void isp_set_pipeline(int soc_type);
+
+void isp_config_pipeline(struct v4l2_pix_format *pix_input,
+                                       struct v4l2_pix_format *pix_output);
+
+int isp_queryctrl(struct v4l2_queryctrl *a);
+
+int isp_g_ctrl(struct v4l2_control *a);
+
+int isp_s_ctrl(struct v4l2_control *a);
+
+int isp_enum_fmt_cap(struct v4l2_fmtdesc *f);
+
+int isp_try_fmt_cap(struct v4l2_pix_format *pix_input,
+                                       struct v4l2_pix_format *pix_output);
+
+void isp_g_fmt_cap(struct v4l2_pix_format *pix);
+
+int isp_s_fmt_cap(struct v4l2_pix_format *pix_input,
+                                       struct v4l2_pix_format *pix_output);
+
+int isp_g_crop(struct v4l2_crop *a);
+
+int isp_s_crop(struct v4l2_crop *a, struct v4l2_pix_format *pix);
+
+void isp_config_crop(struct v4l2_pix_format *pix);
+
+int isp_try_size(struct v4l2_pix_format *pix_input,
+                                       struct v4l2_pix_format *pix_output);
+
+int isp_try_fmt(struct v4l2_pix_format *pix_input,
+                                       struct v4l2_pix_format *pix_output);
+
+int isp_handle_private(int cmd, void *arg);
+
+void isp_save_context(struct isp_reg *);
+
+void isp_restore_context(struct isp_reg *);
+
+void isp_save_ctx(void);
+
+void isp_restore_ctx(void);
+
+/* Configure CCDC interface bridge*/
+int isp_configure_interface_bridge(u32 par_bridge);
+
+void isp_print_status(void);
+
+dma_addr_t isp_buf_get(void);
+
+int __init isp_ccdc_init(void);
+int __init isp_hist_init(void);
+int __init isph3a_aewb_init(void);
+int __init ispmmu_init(void);
+int __init isp_preview_init(void);
+int __init isp_resizer_init(void);
+int __init isp_af_init(void);
+int __init isp_csi2_init(void);
+
+void __exit isp_ccdc_cleanup(void);
+void __exit isp_hist_cleanup(void);
+void __exit isph3a_aewb_cleanup(void);
+void __exit ispmmu_cleanup(void);
+void __exit isp_preview_cleanup(void);
+void __exit isp_hist_cleanup(void);
+void __exit isp_resizer_cleanup(void);
+void __exit isp_af_exit(void);
+void __exit isp_csi2_cleanup(void);
+
+#endif /* OMAP_ISP_TOP_H */
diff --git a/drivers/media/video/isp/ispmmu.c b/drivers/media/video/isp/ispmmu.c
new file mode 100644
index 0000000..b0aaf54
--- /dev/null
+++ b/drivers/media/video/isp/ispmmu.c
@@ -0,0 +1,746 @@
+/*
+ * drivers/media/video/isp/ispmmu.c
+ *
+ * Driver Library for ISP MMU module in TI's OMAP3 Camera ISP
+ *
+ * Copyright (C) 2008 Texas Instruments.
+ *
+ * Contributors:
+ *     Senthilvadivu Guruswamy <svadivu@ti.com>
+ *     Thara Gopinath <thara@ti.com>
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/interrupt.h>
+#include <linux/types.h>
+#include <linux/dma-mapping.h>
+#include <linux/mm.h>
+
+#include <linux/io.h>
+#include <linux/scatterlist.h>
+#include <linux/semaphore.h>
+#include <asm/byteorder.h>
+#include <asm/irq.h>
+
+#include "isp.h"
+#include "ispreg.h"
+#include "ispmmu.h"
+
+/**
+ * struct ispmmu_mapattr - Struct for Mapping Attributes in L1, L2 descriptor
+ * endianism: Endianism.
+ * element_size: Bit size of the element.
+ * mixed_size: Mixed region type.
+ * map_size: Mapping size.
+ */
+struct ispmmu_mapattr {
+       enum ISPMMU_MAP_ENDIAN endianism;
+       enum ISPMMU_MAP_ELEMENTSIZE element_size;
+       enum ISPMMU_MAP_MIXEDREGION mixed_size;
+       enum ISPMMU_MAP_SIZE map_size;
+};
+
+/* Structure for saving/restoring mmu module registers */
+static struct isp_reg ispmmu_reg_list[] = {
+       {ISPMMU_SYSCONFIG, 0x0000},
+       {ISPMMU_IRQENABLE, 0x0000},
+       {ISPMMU_CNTL, 0x0000},
+       {ISPMMU_TTB, 0x0000},
+       {ISPMMU_LOCK, 0x0000},
+       {ISPMMU_LD_TLB, 0x0000},
+       {ISPMMU_CAM, 0x0000},
+       {ISPMMU_RAM, 0x0000},
+       {ISP_TOK_TERM, 0x0000}
+};
+
+/* Page structure for statically allocated l1 and l2 page tables */
+static struct page *ttb_page;
+static struct page *l2p_page;
+
+/*
+* Allocate the same number as of TTB entries for easy tracking
+* even though L2P tables are limited to 16 or so
+*/
+static u32 l2p_table_addr[4096];
+
+/* An array of flags to keep the L2P table allotted */
+static int l2p_table_allotted[L2P_TABLE_NR];
+
+/* Current count of l2 pages mapped */
+static int no_of_l2p_alloted;
+
+/* TTB virtual and physical address */
+static u32 *ttb, ttb_p;
+
+/* Worst case allocation for TTB for 16KB alignment */
+static u32 ttb_aligned_size;
+
+/* L2 page table base virtural and physical address */
+static u32 l2_page_cache, l2_page_cache_p;
+
+static struct ispmmu_mapattr l1_mapattr_obj, l2_mapattr_obj;
+
+/**
+ * ispmmu_set_pte - Sets the L1, L2 descriptor.
+ * @pte_addr: Pointer to the Indexed address in the L1 Page table ie TTB.
+ * @phy_addr: Section/Supersection/L2page table physical address.
+ * @mapattr: Mapping attributes applicable for Section/Supersections.
+ *
+ * Set with section/supersection/Largepage/Smallpage base address or with L2
+ * Page table address depending on the size parameter.
+ *
+ * Returns the written L1/L2 descriptor.
+ **/
+static u32 ispmmu_set_pte(u32 *pte_addr, u32 phy_addr,
+                                               struct ispmmu_mapattr mapattr)
+{
+       u32 pte = 0;
+
+       switch (mapattr.map_size) {
+       case PAGE:
+               pte = ISPMMU_L1D_TYPE_PAGE << ISPMMU_L1D_TYPE_SHIFT;
+               pte |= (phy_addr >> ISPMMU_L1D_PAGE_ADDR_SHIFT)
+                                               << ISPMMU_L1D_PAGE_ADDR_SHIFT;
+               break;
+       case SMALLPAGE:
+               pte = ISPMMU_L2D_TYPE_SMALL_PAGE << ISPMMU_L2D_TYPE_SHIFT;
+               pte &= ~ISPMMU_L2D_M_ACCESSBASED;
+               if (mapattr.endianism)
+                       pte |= ISPMMU_L2D_E_BIGENDIAN;
+               else
+                       pte &= ~ISPMMU_L2D_E_BIGENDIAN;
+               pte &= ISPMMU_L2D_ES_MASK;
+               pte |= mapattr.element_size << ISPMMU_L2D_ES_SHIFT;
+               pte |= (phy_addr >> ISPMMU_L2D_SMALL_ADDR_SHIFT)
+                                               << ISPMMU_L2D_SMALL_ADDR_SHIFT;
+               break;
+       case L1DFAULT:
+               pte = ISPMMU_L1D_TYPE_FAULT << ISPMMU_L1D_TYPE_SHIFT;
+               break;
+       case L2DFAULT:
+               pte = ISPMMU_L2D_TYPE_FAULT << ISPMMU_L2D_TYPE_SHIFT;
+               break;
+       default:
+               break;
+       };
+
+       *pte_addr = pte;
+       return pte;
+}
+
+/**
+ * find_free_region_index - Returns the index in the ttb for a free 32MB region
+ *
+ * Returns 0 as an error code, if run out of regions.
+ **/
+static u32 find_free_region_index(void)
+{
+       int idx = 0;
+       for (idx = ISPMMU_REGION_ENTRIES_NR; idx < ISPMMU_TTB_ENTRIES_NR;
+                                       idx += ISPMMU_REGION_ENTRIES_NR) {
+               if (((*(ttb + idx)) & ISPMMU_L1D_TYPE_MASK) ==
+                                               (ISPMMU_L1D_TYPE_FAULT <<
+                                               ISPMMU_L1D_TYPE_SHIFT))
+                       break;
+       }
+       if (idx == ISPMMU_TTB_ENTRIES_NR) {
+               DPRINTK_ISPMMU("run out of virtual space\n");
+               return 0;
+       }
+       return idx;
+}
+
+/**
+ * page_aligned_addr - Returns the Page aligned address.
+ * @addr: Address to be page aligned.
+ **/
+static inline u32 page_aligned_addr(u32 addr)
+{
+       u32 paddress;
+       paddress = addr & ~(PAGE_SIZE-1);
+       return paddress;
+}
+
+
+/**
+ * l2_page_paddr - Returns the physical address of the allocated L2 page Table.
+ * @l2_table: Virtual address of the allocated l2 table.
+ **/
+static inline u32 l2_page_paddr(u32 l2_table)
+{
+       return l2_page_cache_p + (l2_table - l2_page_cache);
+}
+
+/**
+ * init_l2_page_cache - Allocates contigous memory for L2 page tables.
+ *
+ * Returns 0 if successful, or -ENOMEM if no memory for L2 page tables.
+ **/
+static int init_l2_page_cache(void)
+{
+       int i;
+       u32 *l2p;
+
+       l2p_page = alloc_pages(GFP_KERNEL, get_order(L2P_TABLES_SIZE));
+       if (!l2p_page) {
+               DPRINTK_ISPMMU("ISP_ERR : No Memory for L2 page tables\n");
+               return -ENOMEM;
+       }
+       l2p = page_address(l2p_page);
+       l2_page_cache = (u32)l2p;
+       l2_page_cache_p = __pa(l2p);
+       l2_page_cache = (u32)ioremap_nocache(l2_page_cache_p, L2P_TABLES_SIZE);
+
+       for (i = 0; i < L2P_TABLE_NR; i++)
+               l2p_table_allotted[i] = 0;
+       no_of_l2p_alloted = 0;
+
+       DPRINTK_ISPMMU("Mem for L2 page tables at l2_paddr = %x,"
+                                       " l2_vaddr = 0x%x, of bytes = 0x%x\n",
+                                       l2_page_cache_p, l2_page_cache,
+                                       L2P_TABLES_SIZE);
+
+       if (omap_rev() < OMAP3430_REV_ES2_0)
+               l2_mapattr_obj.endianism = B_ENDIAN;
+       else
+               l2_mapattr_obj.endianism = L_ENDIAN;
+       l2_mapattr_obj.element_size = ES_8BIT;
+       l2_mapattr_obj.mixed_size = ACCESS_BASED;
+       l2_mapattr_obj.map_size = L2DFAULT;
+       return 0;
+}
+
+/**
+ * cleanup_l2_page_cache - Frees the memory of L2 page tables.
+ **/
+static void cleanup_l2_page_cache(void)
+{
+       if (l2p_page) {
+               ioremap_cached(l2_page_cache_p, L2P_TABLES_SIZE);
+               __free_pages(l2p_page, get_order(L2P_TABLES_SIZE));
+       }
+}
+
+/**
+ * request_l2_page_table - Requests L2 Page table slot.
+ *
+ * Finds a free L2 Page table slot.
+ * Fills the allotted L2 Page table with default entries.
+ * Returns the virtual address of the allocatted L2 Pagetable, or 0 if cannot
+ * allocate the requested L2 pagetables
+ **/
+static u32 request_l2_page_table(void)
+{
+       int i, j;
+       u32 l2_table;
+
+       for (i = 0; i < L2P_TABLE_NR; i++) {
+               if (!l2p_table_allotted[i])
+                       break;
+       }
+       if (i < L2P_TABLE_NR) {
+               l2p_table_allotted[i] = 1;
+               l2_table = l2_page_cache + (i * L2P_TABLE_SIZE);
+               l2_mapattr_obj.map_size = L2DFAULT;
+               for (j = 0; j < ISPMMU_L2D_ENTRIES_NR; j++)
+                       ispmmu_set_pte((u32 *)l2_table + j, 0, l2_mapattr_obj);
+               DPRINTK_ISPMMU("Allotted l2 page table at 0x%x\n",
+                                       (u32)l2_table);
+               no_of_l2p_alloted++;
+               return l2_table;
+       } else {
+               DPRINTK_ISPMMU("ISP_ERR : Cannot allocate more than 16 L2\
+                               Page Tables");
+               return 0;
+       }
+}
+
+/**
+ * free_l2_page_table - Frees the allocatted L2 Page table slot.
+ * @l2_table: 32 bit address for L2 Table to be freed.
+ *
+ * Returns 0 if successful, or -EINVAL if table is not found.
+ **/
+static int free_l2_page_table(u32 l2_table)
+{
+       int i;
+
+       DPRINTK_ISPMMU("Free l2 page table at 0x%x\n", l2_table);
+       for (i = 0; i < L2P_TABLE_NR; i++) {
+               if (l2_table == (l2_page_cache + (i * L2P_TABLE_SIZE))) {
+                       if (!l2p_table_allotted[i])
+                               DPRINTK_ISPMMU("L2 page not in use\n");
+
+                       l2p_table_allotted[i] = 0;
+                       no_of_l2p_alloted--;
+                       return 0;
+               }
+       }
+       DPRINTK_ISPMMU("L2 table not found\n");
+       return -EINVAL;
+}
+
+/**
+ * ispmmu_get_available_page_tables - Returns current available pages size
+ **/
+int ispmmu_get_mapeable_space(void)
+{
+       return (L2P_TABLE_NR - no_of_l2p_alloted) * ISPMMU_TTB_ENTRIES_NR *
+                                                       ISPMMU_L2D_ENTRIES_NR;
+}
+
+/**
+ * ispmmu_map - Map a physically contiguous buffer to ISP space.
+ * @p_addr: Physical address of the contigous mem to be mapped.
+ * @size: Size of the contigous mem to be mapped.
+ *
+ * This call is used to map a frame buffer.
+ *
+ * Returns a valid address when successful, 0 if no memory could be mapped,
+ * or -EINVAL if runned out of virtual space.
+ **/
+dma_addr_t ispmmu_map(u32 p_addr, int size)
+{
+       int i, j, idx, num;
+       u32 sz, first_padding;
+       u32 p_addr_align, p_addr_align_end;
+       u32 pd;
+       u32 *l2_table;
+       dma_addr_t ret_addr;
+
+       DPRINTK_ISPMMU("map: p_addr = 0x%x, size = 0x%x\n", p_addr, size);
+
+       p_addr_align = page_aligned_addr(p_addr);
+
+       first_padding = p_addr - p_addr_align;
+       if (first_padding > size)
+               sz = 0;
+       else
+               sz = size - first_padding;
+
+       num = (sz / PAGE_SIZE) + ((sz % PAGE_SIZE) ? 1 : 0) +
+                                               (first_padding ? 1 : 0);
+       p_addr_align_end = p_addr_align + num * PAGE_SIZE;
+
+       DPRINTK_ISPMMU("buffer at 0x%x of size 0x%x spans to %d pages\n",
+                                                       p_addr, size, num);
+
+       idx = find_free_region_index();
+       if (!idx) {
+               DPRINTK_ISPMMU("Runs out of virtual space");
+               return -EINVAL;
+       }
+       DPRINTK_ISPMMU("allocating region %d\n", idx/ISPMMU_REGION_ENTRIES_NR);
+
+       num = num / ISPMMU_L2D_ENTRIES_NR +
+                               ((num % ISPMMU_L2D_ENTRIES_NR) ? 1 : 0);
+       DPRINTK_ISPMMU("need %d second-level page tables (1KB each)\n", num);
+
+       for (i = 0; i < num; i++) {
+               l2_table = (u32 *)request_l2_page_table();
+               if (!l2_table) {
+                       DPRINTK_ISPMMU("no memory\n");
+                       i--;
+                       goto release_mem;
+               }
+
+               l1_mapattr_obj.map_size = PAGE;
+               pd = ispmmu_set_pte(ttb+idx+i, l2_page_paddr((u32)l2_table),
+                                                       l1_mapattr_obj);
+               DPRINTK_ISPMMU("L1 pte[%d] = 0x%x\n", idx+i, pd);
+
+               l2_mapattr_obj.map_size = SMALLPAGE;
+               for (j = 0; j < ISPMMU_L2D_ENTRIES_NR; j++) {
+                       pd = ispmmu_set_pte(l2_table + j, p_addr_align,
+                                                               l2_mapattr_obj);
+                       p_addr_align += PAGE_SIZE;
+                       if (p_addr_align == p_addr_align_end)
+                               break;
+               }
+               l2p_table_addr[idx + i] = (u32)l2_table;
+       }
+
+       DPRINTK_ISPMMU("mapped to ISP virtual address 0x%x\n",
+                       (u32)((idx << 20) + (p_addr & (PAGE_SIZE - 1))));
+
+       omap_writel(1, ISPMMU_GFLUSH);
+       ret_addr = (dma_addr_t)((idx << 20) + (p_addr & (PAGE_SIZE - 1)));
+       return ret_addr;
+
+release_mem:
+       for (; i >= 0; i--) {
+               free_l2_page_table(l2p_table_addr[idx + i]);
+               l2p_table_addr[idx + i] = 0;
+       }
+       return 0;
+}
+EXPORT_SYMBOL_GPL(ispmmu_map);
+
+/**
+ * ispmmu_map_sg - Map a physically discontiguous buffer to ISP space.
+ * @sg_list: Address of the Scatter gather linked list.
+ * @sglen: Number of elements in the sg list.
+ *
+ * This call is used to map a user buffer or a vmalloc buffer. The sg list is
+ * a set of pages.
+ *
+ * Returns a valid address when successful, 0 if no memory could be mapped,
+ * or -EINVAL if runned out of virtual space.
+ **/
+dma_addr_t ispmmu_map_sg(const struct scatterlist *sglist, int sglen)
+{
+       int i, j, idx, num, sg_num = 0;
+       u32 pd, sg_element_addr;
+       u32 *l2_table;
+       dma_addr_t ret_addr;
+
+       DPRINTK_ISPMMU("Map_sg: sglen (num of pages) = %d\n", sglen);
+
+       idx = find_free_region_index();
+       if (!idx) {
+               DPRINTK_ISPMMU("Runs out of virtual space");
+               return -EINVAL;
+       }
+
+       DPRINTK_ISPMMU("allocating region %d\n", idx/ISPMMU_REGION_ENTRIES_NR);
+
+       num = sglen / ISPMMU_L2D_ENTRIES_NR +
+                       ((sglen % ISPMMU_L2D_ENTRIES_NR) ? 1 : 0);
+       DPRINTK_ISPMMU("Need %d second-level page tables (1KB each)\n", num);
+
+       for (i = 0; i < num; i++) {
+               l2_table = (u32 *)request_l2_page_table();
+               if (!l2_table) {
+                       DPRINTK_ISPMMU("No memory\n");
+                       i--;
+                       goto release_mem;
+               }
+               l1_mapattr_obj.map_size = PAGE;
+               pd = ispmmu_set_pte(ttb + idx + i, l2_page_paddr((u32)l2_table),
+                                               l1_mapattr_obj);
+               DPRINTK_ISPMMU("L1 pte[%d] = 0x%x\n", idx + i, pd);
+
+               l2_mapattr_obj.map_size = SMALLPAGE;
+               for (j = 0; j < ISPMMU_L2D_ENTRIES_NR; j++) {
+                       sg_element_addr = sg_dma_address(sglist + sg_num);
+                       if ((sg_num > 0) && page_aligned_addr(sg_element_addr)
+                                                       != sg_element_addr)
+                               DPRINTK_ISPMMU("ISP_ERR : Intermediate SG"
+                                               " elements are not"
+                                               " page aligned = 0x%x\n",
+                                               sg_element_addr);
+                       pd = ispmmu_set_pte(l2_table + j, sg_element_addr,
+                                                       l2_mapattr_obj);
+
+                       /* DPRINTK_ISPMMU("L2 pte[%d] = 0x%x\n", j, pd); */
+
+                       sg_num++;
+                       if (sg_num == sglen)
+                               break;
+               }
+               /* save it so we can free this l2 table later */
+               l2p_table_addr[idx + i] = (u32)l2_table;
+       }
+
+       DPRINTK_ISPMMU("mapped sg list to ISP virtual address 0x%x, idx=%d\n",
+                       (u32)((idx << 20) + (sg_dma_address(sglist + 0) &
+                                               (PAGE_SIZE - 1))), idx);
+
+       omap_writel(1, ISPMMU_GFLUSH);
+       ret_addr = (dma_addr_t)((idx << 20) + (sg_dma_address(sglist + 0) &
+                                                       (PAGE_SIZE - 1)));
+       return ret_addr;
+
+release_mem:
+       for (; i >= 0; i--) {
+               free_l2_page_table(l2p_table_addr[idx + i]);
+               l2p_table_addr[idx + i] = 0;
+       }
+       return 0;
+}
+EXPORT_SYMBOL_GPL(ispmmu_map_sg);
+
+/**
+ * ispmmu_unmap - Unmap a ISP space that was mmapped before.
+ * @v_addr: Virtural address to be unmapped
+ *
+ * Works with mmapped spaces either with ispmmu_map or ispmmu_map_sg.
+ *
+ * Returns 0 if successful, or -EINVAL if wrong region, or non region-aligned
+ **/
+int ispmmu_unmap(dma_addr_t v_addr)
+{
+       u32 v_addr_align;
+       int idx;
+
+       DPRINTK_ISPMMU("+ispmmu_unmap: 0x%x\n", v_addr);
+
+       v_addr_align = page_aligned_addr(v_addr);
+       idx = v_addr_align >> 20;
+       if ((idx < ISPMMU_REGION_ENTRIES_NR) || (idx >
+                                       (ISPMMU_REGION_ENTRIES_NR *
+                                       (ISPMMU_REGION_NR - 1))) ||
+                                       ((idx << 20) != v_addr_align) ||
+                                       (idx % ISPMMU_REGION_ENTRIES_NR)) {
+               DPRINTK_ISPMMU("Cannot unmap a non region-aligned space"
+                                                       " 0x%x\n", v_addr);
+               return -EINVAL;
+       }
+
+       if (((*(ttb + idx)) & (ISPMMU_L1D_TYPE_MASK <<
+                                               ISPMMU_L1D_TYPE_SHIFT)) !=
+                                               (ISPMMU_L1D_TYPE_PAGE <<
+                                               ISPMMU_L1D_TYPE_SHIFT)) {
+               DPRINTK_ISPMMU("unmap a wrong region\n");
+               return -EINVAL;
+       }
+
+       while (((*(ttb + idx)) & (ISPMMU_L1D_TYPE_MASK <<
+                                               ISPMMU_L1D_TYPE_SHIFT)) ==
+                                               (ISPMMU_L1D_TYPE_PAGE <<
+                                               ISPMMU_L1D_TYPE_SHIFT)) {
+               *(ttb + idx) = (ISPMMU_L1D_TYPE_FAULT <<
+                                               ISPMMU_L1D_TYPE_SHIFT);
+               free_l2_page_table(l2p_table_addr[idx]);
+               l2p_table_addr[idx++] = 0;
+               if (!(idx % ISPMMU_REGION_ENTRIES_NR)) {
+                       DPRINTK_ISPMMU("Do not exceed this 32M region\n");
+                       break;
+               }
+       }
+       omap_writel(1, ISPMMU_GFLUSH);
+
+       DPRINTK_ISPMMU("-ispmmu_unmap()\n");
+       return 0;
+}
+EXPORT_SYMBOL_GPL(ispmmu_unmap);
+
+/**
+ * ispmmu_isr - Callback from ISP driver for MMU interrupt.
+ * @status: IRQ status of ISPMMU
+ * @arg1: Not used as of now.
+ * @arg2: Not used as of now.
+ **/
+static void ispmmu_isr(unsigned long status, isp_vbq_callback_ptr arg1,
+                                                               void *arg2)
+{
+       u32 irqstatus = 0;
+
+       irqstatus = omap_readl(ISPMMU_IRQSTATUS);
+       DPRINTK_ISPMMU("mmu error 0x%lx, 0x%x\n", status, irqstatus);
+       if (irqstatus & IRQENABLE_TLBMISS)
+               DPRINTK_ISPMMU("ISP_ERR: TLB Miss\n");
+       if (irqstatus & IRQENABLE_TRANSLNFAULT)
+               DPRINTK_ISPMMU("ISP_ERR: Invalide descriptor in the"
+                                               " translation table -"
+                                               " Translation Fault\n");
+       if (irqstatus & IRQENABLE_EMUMISS) {
+               DPRINTK_ISPMMU("ISP_ERR: TLB Miss during debug -"
+                                                       " Emulation mode\n");
+       }
+       if (irqstatus & IRQENABLE_TWFAULT)
+               DPRINTK_ISPMMU("ISP_ERR: Table Walk Fault\n");
+       if (irqstatus & IRQENABLE_MULTIHITFAULT)
+               DPRINTK_ISPMMU("ISP_ERR: Multiple Matches in the TLB\n");
+       DPRINTK_ISPMMU("Fault address for the ISPMMU is 0x%x",
+                                               omap_readl(ISPMMU_FAULT_AD));
+       omap_writel(irqstatus, ISPMMU_IRQSTATUS);
+}
+
+/**
+ * ispmmu_init - ISP MMU Initialization.
+ *
+ * - Reserves memory for L1 and L2 Page tables.
+ * - Initializes the ISPMMU with TTB address, fault entries as default in the
+ * - TTB table.
+ * - Enables MMU and TWL.
+ * - Sets the callback for the MMU error events.
+ *
+ * Returns 0 if successful, -ENODEV if can't take ISP MMU out of reset, -ENOMEM
+ * when no memory for TTB, or init_l2_page_cache return value if L2 page cache
+ * init fails.
+ **/
+int __init ispmmu_init(void)
+{
+       int i, val = 0;
+       struct isp_sysc isp_sysconfig;
+
+       isp_get();
+
+       omap_writel(2, ISPMMU_SYSCONFIG);
+       while (((omap_readl(ISPMMU_SYSSTATUS) & 0x1) != 0x1) && val--)
+               udelay(10);
+
+       if ((omap_readl(ISPMMU_SYSSTATUS) & 0x1) != 0x1) {
+               DPRINTK_ISPMMU("can't take ISP MMU out of reset\n");
+               isp_put();
+               return -ENODEV;
+       }
+       isp_sysconfig.reset = 0;
+       isp_sysconfig.idle_mode = 1;
+       isp_power_settings(isp_sysconfig);
+
+       ttb_page = alloc_pages(GFP_KERNEL, get_order(ISPMMU_TTB_ENTRIES_NR *
+                                                                       4));
+       if (!ttb_page) {
+               DPRINTK_ISPMMU("No Memory for TTB\n");
+               isp_put();
+               return -ENOMEM;
+       }
+
+       ttb = page_address(ttb_page);
+       ttb_p = __pa(ttb);
+       ttb_aligned_size = ISPMMU_TTB_ENTRIES_NR * 4;
+       ttb = ioremap_nocache(ttb_p, ttb_aligned_size);
+       if ((ttb_p & 0xFFFFC000) != ttb_p) {
+               DPRINTK_ISPMMU("ISP_ERR : TTB address not aligned at 16KB\n");
+               __free_pages(ttb_page, get_order(ISPMMU_TTB_ENTRIES_NR * 4));
+               ttb_aligned_size = (ISPMMU_TTB_ENTRIES_NR * 4) +
+                                               (ISPMMU_TTB_MISALIGN_SIZE);
+               ttb_page = alloc_pages(GFP_KERNEL, get_order(ttb_aligned_size));
+               if (!ttb_page) {
+                       DPRINTK_ISPMMU("No Memory for TTB\n");
+                       isp_put();
+                       return -ENOMEM;
+               }
+               ttb = page_address(ttb_page);
+               ttb_p = __pa(ttb);
+               ttb = ioremap_nocache(ttb_p, ttb_aligned_size);
+               if ((ttb_p & 0xFFFFC000) != ttb_p) {
+                       ttb = (u32 *)(((u32)ttb & 0xFFFFC000) + 0x4000);
+                       ttb_p = __pa(ttb);
+               }
+       }
+
+       DPRINTK_ISPMMU("TTB allocated at p = 0x%x, v = 0x%x, size = 0x%x\n",
+                                       ttb_p, (u32)ttb, ttb_aligned_size);
+
+       if (omap_rev() < OMAP3430_REV_ES2_0)
+               l1_mapattr_obj.endianism = B_ENDIAN;
+       else
+               l1_mapattr_obj.endianism = L_ENDIAN;
+       l1_mapattr_obj.element_size = ES_8BIT;
+       l1_mapattr_obj.mixed_size = ACCESS_BASED;
+       l1_mapattr_obj.map_size = L1DFAULT;
+
+       val = init_l2_page_cache();
+       if (val) {
+               DPRINTK_ISPMMU("ISP_ERR: init l2 page cache\n");
+               ttb = page_address(ttb_page);
+               ttb_p = __pa(ttb);
+               ioremap_cached(ttb_p, ttb_aligned_size);
+               __free_pages(ttb_page, get_order(ttb_aligned_size));
+               isp_put();
+               return val;
+       }
+
+       for (i = 0; i < ISPMMU_TTB_ENTRIES_NR; i++)
+               ispmmu_set_pte(ttb + i, 0, l1_mapattr_obj);
+
+       omap_writel(ttb_p, ISPMMU_TTB);
+
+       omap_writel((ISPMMU_MMUCNTL_MMU_EN|ISPMMU_MMUCNTL_TWL_EN), ISPMMU_CNTL);
+       omap_writel(omap_readl(ISPMMU_IRQSTATUS), ISPMMU_IRQSTATUS);
+       omap_writel(0xf, ISPMMU_IRQENABLE);
+
+       isp_set_callback(CBK_MMU_ERR, ispmmu_isr, (void *)NULL, (void *)NULL);
+
+       val = omap_readl(ISPMMU_REVISION);
+       DPRINTK_ISPMMU("ISP MMU Rev %c.%c initialized\n",
+                               (val >> ISPMMU_REVISION_REV_MAJOR_SHIFT) + '0',
+                               (val & ISPMMU_REVISION_REV_MINOR_MASK) + '0');
+       isp_put();
+       return 0;
+
+}
+
+/**
+ * ispmmu_cleanup - Frees the L1, L2 Page tables. Unsets the callback for MMU.
+ **/
+void __exit ispmmu_cleanup(void)
+{
+       ttb = page_address(ttb_page);
+       ttb_p = __pa(ttb);
+       ioremap_cached(ttb_p, ttb_aligned_size);
+       __free_pages(ttb_page, get_order(ttb_aligned_size));
+       isp_unset_callback(CBK_MMU_ERR);
+       cleanup_l2_page_cache();
+
+       return;
+}
+
+/**
+ * ispmmu_save_context - Saves the values of the mmu module registers.
+ **/
+void ispmmu_save_context(void)
+{
+       DPRINTK_ISPMMU(" Saving context\n");
+       isp_save_context(ispmmu_reg_list);
+}
+EXPORT_SYMBOL_GPL(ispmmu_save_context);
+
+/**
+ * ispmmu_restore_context - Restores the values of the mmu module registers.
+ **/
+void ispmmu_restore_context(void)
+{
+       DPRINTK_ISPMMU(" Restoring context\n");
+       isp_restore_context(ispmmu_reg_list);
+}
+EXPORT_SYMBOL_GPL(ispmmu_restore_context);
+
+/**
+ * ispmmu_print_status - Prints the values of the ISPMMU registers
+ * Also prints other debug information stored
+ **/
+void ispmmu_print_status(void)
+{
+       if (!is_ispmmu_debug_enabled())
+               return;
+       DPRINTK_ISPMMU("TTB v_addr = 0x%x, p_addr = 0x%x\n", (u32)ttb, ttb_p);
+       DPRINTK_ISPMMU("L2P base v_addr = 0x%x, p_addr = 0x%x\n",
+                                               l2_page_cache, l2_page_cache_p);
+       DPRINTK_ISPMMU("ISPMMU_REVISION = 0x%x\n",
+                                               omap_readl(ISPMMU_REVISION));
+       DPRINTK_ISPMMU("ISPMMU_SYSCONFIG = 0x%x\n",
+                                               omap_readl(ISPMMU_SYSCONFIG));
+       DPRINTK_ISPMMU("ISPMMU_SYSSTATUS = 0x%x\n",
+                                               omap_readl(ISPMMU_SYSSTATUS));
+       DPRINTK_ISPMMU("ISPMMU_IRQSTATUS = 0x%x\n",
+                                               omap_readl(ISPMMU_IRQSTATUS));
+       DPRINTK_ISPMMU("ISPMMU_IRQENABLE = 0x%x\n",
+                                               omap_readl(ISPMMU_IRQENABLE));
+       DPRINTK_ISPMMU("ISPMMU_WALKING_ST = 0x%x\n",
+                                               omap_readl(ISPMMU_WALKING_ST));
+       DPRINTK_ISPMMU("ISPMMU_CNTL = 0x%x\n", omap_readl(ISPMMU_CNTL));
+       DPRINTK_ISPMMU("ISPMMU_FAULT_AD = 0x%x\n",
+                                               omap_readl(ISPMMU_FAULT_AD));
+       DPRINTK_ISPMMU("ISPMMU_TTB = 0x%x\n", omap_readl(ISPMMU_TTB));
+       DPRINTK_ISPMMU("ISPMMU_LOCK = 0x%x\n", omap_readl(ISPMMU_LOCK));
+       DPRINTK_ISPMMU("ISPMMU_LD_TLB= 0x%x\n", omap_readl(ISPMMU_LD_TLB));
+       DPRINTK_ISPMMU("ISPMMU_CAM = 0x%x\n", omap_readl(ISPMMU_CAM));
+       DPRINTK_ISPMMU("ISPMMU_RAM = 0x%x\n", omap_readl(ISPMMU_RAM));
+       DPRINTK_ISPMMU("ISPMMU_GFLUSH = 0x%x\n", omap_readl(ISPMMU_GFLUSH));
+       DPRINTK_ISPMMU("ISPMMU_FLUSH_ENTRY = 0x%x\n",
+                                       omap_readl(ISPMMU_FLUSH_ENTRY));
+       DPRINTK_ISPMMU("ISPMMU_READ_CAM = 0x%x\n",
+                                               omap_readl(ISPMMU_READ_CAM));
+       DPRINTK_ISPMMU("ISPMMU_READ_RAM = 0x%x\n",
+                                               omap_readl(ISPMMU_READ_RAM));
+}
+EXPORT_SYMBOL_GPL(ispmmu_print_status);
diff --git a/drivers/media/video/isp/ispmmu.h b/drivers/media/video/isp/ispmmu.h
new file mode 100644
index 0000000..a20b3b0
--- /dev/null
+++ b/drivers/media/video/isp/ispmmu.h
@@ -0,0 +1,119 @@
+/*
+ * drivers/media/video/isp/ispmmu.h
+ *
+ * OMAP3 Camera ISP MMU API
+ *
+ * Copyright (C) 2008 Texas Instruments.
+ *
+ * Contributors:
+ *     Senthilvadivu Guruswamy <svadivu@ti.com>
+ *     Thara Gopinath <thara@ti.com>
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
+#ifndef OMAP_ISP_MMU_H
+#define OMAP_ISP_MMU_H
+
+#define ISPMMU_L1D_TYPE_SHIFT          0
+#define ISPMMU_L1D_TYPE_MASK           0x3
+#define ISPMMU_L1D_TYPE_FAULT          0
+#define ISPMMU_L1D_TYPE_FAULT1         3
+#define ISPMMU_L1D_TYPE_PAGE           1
+#define ISPMMU_L1D_TYPE_SECTION                2
+#define ISPMMU_L1D_PAGE_ADDR_SHIFT     10
+
+#define ISPMMU_L2D_TYPE_SHIFT          0
+#define ISPMMU_L2D_TYPE_MASK           0x3
+#define ISPMMU_L2D_TYPE_FAULT          0
+#define ISPMMU_L2D_TYPE_LARGE_PAGE     1
+#define ISPMMU_L2D_TYPE_SMALL_PAGE     2
+#define ISPMMU_L2D_SMALL_ADDR_SHIFT    12
+#define ISPMMU_L2D_SMALL_ADDR_MASK     0xFFFFF000
+#define ISPMMU_L2D_M_ACCESSBASED       (1 << 11)
+#define ISPMMU_L2D_E_BIGENDIAN         (1 << 9)
+#define ISPMMU_L2D_ES_SHIFT            4
+#define ISPMMU_L2D_ES_MASK             (~(3 << 4))
+#define ISPMMU_L2D_ES_8BIT             0
+#define ISPMMU_L2D_ES_16BIT            1
+#define ISPMMU_L2D_ES_32BIT            2
+#define ISPMMU_L2D_ES_NOENCONV         3
+
+#define ISPMMU_TTB_ENTRIES_NR          4096
+
+/* Number 1MB entries in TTB in one 32MB region */
+#define ISPMMU_REGION_ENTRIES_NR       32
+
+/* 128 region entries */
+#define ISPMMU_REGION_NR (ISPMMU_TTB_ENTRIES_NR / ISPMMU_REGION_ENTRIES_NR)
+
+/* Each region is 32MB */
+#define ISPMMU_REGION_SIZE             (ISPMMU_REGION_ENTRIES_NR * (1 << 20))
+
+/* Number of entries per L2 Page table */
+#define ISPMMU_L2D_ENTRIES_NR          256
+
+/*
+ * Statically allocate 16KB for L2 page tables. 16KB can be used for
+ * up to 16 L2 page tables which cover up to 16MB space. We use an array of 16
+ * to keep track of these 16 L2 page table's status.
+ */
+#define L2P_TABLE_SIZE                 1024
+#define L2P_TABLE_NR                   41 /* Currently supports 4*5MP shots */
+#define L2P_TABLES_SIZE                (L2P_TABLE_SIZE * L2P_TABLE_NR)
+
+/* Extra memory allocated to get ttb aligned on 16KB */
+#define ISPMMU_TTB_MISALIGN_SIZE       0x3000
+
+#ifdef CONFIG_ARCH_OMAP3410
+#include <linux/scatterlist.h>
+#endif
+
+enum ISPMMU_MAP_ENDIAN {
+       L_ENDIAN,
+       B_ENDIAN
+};
+
+enum ISPMMU_MAP_ELEMENTSIZE {
+       ES_8BIT,
+       ES_16BIT,
+       ES_32BIT,
+       ES_NOENCONV
+};
+
+enum ISPMMU_MAP_MIXEDREGION {
+       ACCESS_BASED,
+       PAGE_BASED
+};
+
+enum ISPMMU_MAP_SIZE {
+       L1DFAULT,
+       PAGE,
+       SECTION,
+       SUPERSECTION,
+       L2DFAULT,
+       LARGEPAGE,
+       SMALLPAGE
+};
+
+int ispmmu_get_mapeable_space(void);
+
+dma_addr_t ispmmu_map(unsigned int p_addr, int size);
+
+dma_addr_t ispmmu_map_sg(const struct scatterlist *sglist, int sglen);
+
+int ispmmu_unmap(dma_addr_t isp_addr);
+
+void ispmmu_print_status(void);
+
+void ispmmu_save_context(void);
+
+void ispmmu_restore_context(void);
+
+#endif /* OMAP_ISP_MMU_H */
--
1.5.6.5


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
