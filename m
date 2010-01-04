Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:35176 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753370Ab0ADOmQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jan 2010 09:42:16 -0500
From: hvaibhav@ti.com
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org, hverkuil@xs4all.nl, tony@atomide.com,
	Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH 1/2] OMAP2/3 V4L2: Add support for OMAP2/3 V4L2 driver on top of DSS2
Date: Mon,  4 Jan 2010 20:12:08 +0530
Message-Id: <1262616129-23373-2-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vaibhav Hiremath <hvaibhav@ti.com>

Features Supported -
	1. Provides V4L2 user interface for the video pipelines of DSS
	2. Basic streaming working on LCD, DVI and TV.
	3. Works on latest DSS2 library from Tomi
	4. Support for various pixel formats like YUV, UYVY, RGB32, RGB24,
	RGB565
	5. Supports Alpha blending.
	6. Supports Color keying both source and destination.
	7. Supports rotation.
	8. Supports cropping.
	9. Supports Background color setting.
	10. Allocated buffers to only needed size

Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 drivers/media/video/ti-media/Kconfig        |   10 +
 drivers/media/video/ti-media/Makefile       |    4 +
 drivers/media/video/ti-media/omap_vout.c    | 2654 +++++++++++++++++++++++++++
 drivers/media/video/ti-media/omap_voutdef.h |  148 ++
 drivers/media/video/ti-media/omap_voutlib.c |  258 +++
 drivers/media/video/ti-media/omap_voutlib.h |   34 +
 6 files changed, 3108 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/ti-media/omap_vout.c
 create mode 100644 drivers/media/video/ti-media/omap_voutdef.h
 create mode 100644 drivers/media/video/ti-media/omap_voutlib.c
 create mode 100644 drivers/media/video/ti-media/omap_voutlib.h

diff --git a/drivers/media/video/ti-media/Kconfig b/drivers/media/video/ti-media/Kconfig
index 2617600..52a764d 100644
--- a/drivers/media/video/ti-media/Kconfig
+++ b/drivers/media/video/ti-media/Kconfig
@@ -86,3 +86,13 @@ config VIDEO_DM355_CCDC
 
 	   To compile this driver as a module, choose M here: the
 	   module will be called vpfe.
+
+config VIDEO_OMAP2_VOUT
+	tristate "OMAP2/OMAP3 V4L2-DSS driver"
+	select VIDEOBUF_GEN
+	select VIDEOBUF_DMA_SG
+	select OMAP2_DSS
+	depends on TI_MEDIA && (ARCH_OMAP24XX || ARCH_OMAP34XX)
+	default y
+	---help---
+	  V4L2 DSS support for OMAP2/3 based boards.
diff --git a/drivers/media/video/ti-media/Makefile b/drivers/media/video/ti-media/Makefile
index 1a8b8f3..ac3a363 100644
--- a/drivers/media/video/ti-media/Makefile
+++ b/drivers/media/video/ti-media/Makefile
@@ -15,3 +15,7 @@ obj-$(CONFIG_VIDEO_VPSS_SYSTEM) += vpss.o
 obj-$(CONFIG_VIDEO_VPFE_CAPTURE) += vpfe_capture.o
 obj-$(CONFIG_VIDEO_DM6446_CCDC) += dm644x_ccdc.o
 obj-$(CONFIG_VIDEO_DM355_CCDC) += dm355_ccdc.o
+
+# OMAP2/3 Display driver
+omap-vout-mod-objs := omap_vout.o omap_voutlib.o
+obj-$(CONFIG_VIDEO_OMAP2_VOUT) += omap-vout-mod.o
diff --git a/drivers/media/video/ti-media/omap_vout.c b/drivers/media/video/ti-media/omap_vout.c
new file mode 100644
index 0000000..98cad55
--- /dev/null
+++ b/drivers/media/video/ti-media/omap_vout.c
@@ -0,0 +1,2654 @@
+/*
+ * drivers/media/video/omap/omap_vout.c
+ *
+ * Copyright (C) 2005-2009 Texas Instruments.
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2. This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ *
+ * Leveraged code from the OMAP2 camera driver
+ * Video-for-Linux (Version 2) camera capture driver for
+ * the OMAP24xx camera controller.
+ *
+ * Author: Andy Lowe (source@mvista.com)
+ *
+ * Copyright (C) 2004 MontaVista Software, Inc.
+ * Copyright (C) 2009 Texas Instruments.
+ *
+ * History:
+ * 20-APR-2006	Khasim		Modified VRFB based Rotation,
+ *				The image data is always read from 0 degree
+ *				view and written
+ *				to the virtual space of desired rotation angle
+ * 4-DEC-2006 Jian		Changed to support better memory management
+ *
+ * 17-Nov-2008 Hardik		Changed to used the new DSS paches by Tomi
+ *				Changed driver to use video_ioctl2
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/kernel.h>
+#include <linux/vmalloc.h>
+#include <linux/interrupt.h>
+#include <linux/sched.h>
+#include <linux/kdev_t.h>
+#include <linux/types.h>
+#include <linux/wait.h>
+#include <linux/videodev2.h>
+#include <linux/platform_device.h>
+#include <linux/dma-mapping.h>
+#include <linux/irq.h>
+
+#include <media/videobuf-dma-sg.h>
+#include <media/v4l2-dev.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-device.h>
+
+#include <asm/processor.h>
+#include <plat/dma.h>
+#include <plat/vram.h>
+#include <plat/vrfb.h>
+#include <plat/display.h>
+
+#include "omap_voutlib.h"
+#include "omap_voutdef.h"
+
+MODULE_AUTHOR("Texas Instruments.");
+MODULE_DESCRIPTION("OMAP Video for Linux Video out driver");
+MODULE_LICENSE("GPL");
+
+
+/* Driver Configuration macros */
+#define VOUT_NAME		"omap_vout"
+
+enum omap_vout_channels {
+	OMAP_VIDEO1 = 0,
+	OMAP_VIDEO2,
+};
+
+enum dma_channel_state {
+	DMA_CHAN_NOT_ALLOTED = 0,
+	DMA_CHAN_ALLOTED,
+};
+
+#define QQVGA_WIDTH		160
+#define QQVGA_HEIGHT		120
+
+/* Max Resolution supported by the driver */
+#define VID_MAX_WIDTH		1280	/* Largest width */
+#define VID_MAX_HEIGHT		720	/* Largest height */
+
+/* Mimimum requirement is 2x2 for DSS */
+#define VID_MIN_WIDTH		2
+#define VID_MIN_HEIGHT		2
+
+/* 2048 x 2048 is max res supported by OMAP display controller */
+#define MAX_PIXELS_PER_LINE     2048
+
+#define VRFB_TX_TIMEOUT         1000
+
+/* Max buffer size tobe allocated during init */
+#define OMAP_VOUT_MAX_BUF_SIZE (VID_MAX_WIDTH*VID_MAX_HEIGHT*4)
+
+static struct videobuf_queue_ops video_vbq_ops;
+/* Variables configurable through module params*/
+static u32 video1_numbuffers = 3;
+static u32 video2_numbuffers = 3;
+static u32 video1_bufsize = OMAP_VOUT_MAX_BUF_SIZE;
+static u32 video2_bufsize = OMAP_VOUT_MAX_BUF_SIZE;
+static u32 vid1_static_vrfb_alloc;
+static u32 vid2_static_vrfb_alloc;
+static int debug;
+
+/* Module parameters */
+module_param(video1_numbuffers, uint, S_IRUGO);
+MODULE_PARM_DESC(video1_numbuffers,
+	"Number of buffers to be allocated at init time for Video1 device.");
+
+module_param(video2_numbuffers, uint, S_IRUGO);
+MODULE_PARM_DESC(video2_numbuffers,
+	"Number of buffers to be allocated at init time for Video2 device.");
+
+module_param(video1_bufsize, uint, S_IRUGO);
+MODULE_PARM_DESC(video1_bufsize,
+	"Size of the buffer to be allocated for video1 device");
+
+module_param(video2_bufsize, uint, S_IRUGO);
+MODULE_PARM_DESC(video2_bufsize,
+	"Size of the buffer to be allocated for video2 device");
+
+module_param(vid1_static_vrfb_alloc, bool, S_IRUGO);
+MODULE_PARM_DESC(vid1_static_vrfb_alloc,
+	"Static allocation of the VRFB buffer for video1 device");
+
+module_param(vid2_static_vrfb_alloc, bool, S_IRUGO);
+MODULE_PARM_DESC(vid2_static_vrfb_alloc,
+	"Static allocation of the VRFB buffer for video2 device");
+
+module_param(debug, bool, S_IRUGO);
+MODULE_PARM_DESC(debug, "Debug level (0-1)");
+
+/* Local Helper functions */
+static void omap_vout_isr(void *arg, unsigned int irqstatus);
+static void omap_vout_cleanup_device(struct omap_vout_device *vout);
+
+/* list of image formats supported by OMAP2 video pipelines */
+const static struct v4l2_fmtdesc omap_formats[] = {
+	{
+		/* Note:  V4L2 defines RGB565 as:
+		 *
+		 *      Byte 0                    Byte 1
+		 *      g2 g1 g0 r4 r3 r2 r1 r0   b4 b3 b2 b1 b0 g5 g4 g3
+		 *
+		 * We interpret RGB565 as:
+		 *
+		 *      Byte 0                    Byte 1
+		 *      g2 g1 g0 b4 b3 b2 b1 b0   r4 r3 r2 r1 r0 g5 g4 g3
+		 */
+		.description = "RGB565, le",
+		.pixelformat = V4L2_PIX_FMT_RGB565,
+	},
+	{
+		/* Note:  V4L2 defines RGB32 as: RGB-8-8-8-8  we use
+		 *  this for RGB24 unpack mode, the last 8 bits are ignored
+		 * */
+		.description = "RGB32, le",
+		.pixelformat = V4L2_PIX_FMT_RGB32,
+	},
+	{
+		/* Note:  V4L2 defines RGB24 as: RGB-8-8-8  we use
+		 *        this for RGB24 packed mode
+		 *
+		 */
+		.description = "RGB24, le",
+		.pixelformat = V4L2_PIX_FMT_RGB24,
+	},
+	{
+		.description = "YUYV (YUV 4:2:2), packed",
+		.pixelformat = V4L2_PIX_FMT_YUYV,
+	},
+	{
+		.description = "UYVY, packed",
+		.pixelformat = V4L2_PIX_FMT_UYVY,
+	},
+};
+
+#define NUM_OUTPUT_FORMATS (ARRAY_SIZE(omap_formats))
+
+/*
+ * Allocate buffers
+ */
+static unsigned long omap_vout_alloc_buffer(u32 buf_size, u32 *phys_addr)
+{
+	u32 order, size;
+	unsigned long virt_addr, addr;
+
+	size = PAGE_ALIGN(buf_size);
+	order = get_order(size);
+	virt_addr = __get_free_pages(GFP_KERNEL | GFP_DMA, order);
+	addr = virt_addr;
+
+	if (virt_addr) {
+		while (size > 0) {
+			SetPageReserved(virt_to_page(addr));
+			addr += PAGE_SIZE;
+			size -= PAGE_SIZE;
+		}
+	}
+	*phys_addr = (u32) virt_to_phys((void *) virt_addr);
+	return virt_addr;
+}
+
+/*
+ * Free buffers
+ */
+static void omap_vout_free_buffer(unsigned long virtaddr, u32 buf_size)
+{
+	u32 order, size;
+	unsigned long addr = virtaddr;
+
+	size = PAGE_ALIGN(buf_size);
+	order = get_order(size);
+
+	while (size > 0) {
+		ClearPageReserved(virt_to_page(addr));
+		addr += PAGE_SIZE;
+		size -= PAGE_SIZE;
+	}
+	free_pages((unsigned long) virtaddr, order);
+}
+
+/*
+ * Function for allocating video buffers
+ */
+static int omap_vout_allocate_vrfb_buffers(struct omap_vout_device *vout,
+		unsigned int *count, int startindex)
+{
+	int i, j;
+
+	for (i = 0; i < *count; i++) {
+		if (!vout->smsshado_virt_addr[i]) {
+			vout->smsshado_virt_addr[i] =
+				omap_vout_alloc_buffer(vout->smsshado_size,
+						&vout->smsshado_phy_addr[i]);
+		}
+		if (!vout->smsshado_virt_addr[i] && startindex != -1) {
+			if (V4L2_MEMORY_MMAP == vout->memory && i >= startindex)
+				break;
+		}
+		if (!vout->smsshado_virt_addr[i]) {
+			for (j = 0; j < i; j++) {
+				omap_vout_free_buffer(
+						vout->smsshado_virt_addr[j],
+						vout->smsshado_size);
+				vout->smsshado_virt_addr[j] = 0;
+				vout->smsshado_phy_addr[j] = 0;
+			}
+			*count = 0;
+			return -ENOMEM;
+		}
+		memset((void *) vout->smsshado_virt_addr[i], 0,
+				vout->smsshado_size);
+	}
+	return 0;
+}
+
+/*
+ * Try format
+ */
+static int omap_vout_try_format(struct v4l2_pix_format *pix)
+{
+	int ifmt, bpp = 0;
+
+	pix->height = clamp(pix->height, (u32)VID_MIN_HEIGHT,
+			(u32)VID_MAX_HEIGHT);
+	pix->width = clamp(pix->width, (u32)VID_MIN_WIDTH, (u32)VID_MAX_WIDTH);
+
+	for (ifmt = 0; ifmt < NUM_OUTPUT_FORMATS; ifmt++) {
+		if (pix->pixelformat == omap_formats[ifmt].pixelformat)
+			break;
+	}
+
+	if (ifmt == NUM_OUTPUT_FORMATS)
+		ifmt = 0;
+
+	pix->pixelformat = omap_formats[ifmt].pixelformat;
+	pix->field = V4L2_FIELD_ANY;
+	pix->priv = 0;
+
+	switch (pix->pixelformat) {
+	case V4L2_PIX_FMT_YUYV:
+	case V4L2_PIX_FMT_UYVY:
+	default:
+		pix->colorspace = V4L2_COLORSPACE_JPEG;
+		bpp = YUYV_BPP;
+		break;
+	case V4L2_PIX_FMT_RGB565:
+	case V4L2_PIX_FMT_RGB565X:
+		pix->colorspace = V4L2_COLORSPACE_SRGB;
+		bpp = RGB565_BPP;
+		break;
+	case V4L2_PIX_FMT_RGB24:
+		pix->colorspace = V4L2_COLORSPACE_SRGB;
+		bpp = RGB24_BPP;
+		break;
+	case V4L2_PIX_FMT_RGB32:
+	case V4L2_PIX_FMT_BGR32:
+		pix->colorspace = V4L2_COLORSPACE_SRGB;
+		bpp = RGB32_BPP;
+		break;
+	}
+	pix->bytesperline = pix->width * bpp;
+	pix->sizeimage = pix->bytesperline * pix->height;
+	return bpp;
+}
+
+/*
+ * omap_vout_uservirt_to_phys: This inline function is used to convert user
+ * space virtual address to physical address.
+ */
+static u32 omap_vout_uservirt_to_phys(u32 virtp)
+{
+	unsigned long physp = 0;
+	struct vm_area_struct *vma;
+	struct mm_struct *mm = current->mm;
+
+	vma = find_vma(mm, virtp);
+	/* For kernel direct-mapped memory, take the easy way */
+	if (virtp >= PAGE_OFFSET) {
+		physp = virt_to_phys((void *) virtp);
+	} else if (vma && (vma->vm_flags & VM_IO)
+			&& vma->vm_pgoff) {
+		/* this will catch, kernel-allocated,
+		   mmaped-to-usermode addresses */
+		physp = (vma->vm_pgoff << PAGE_SHIFT) + (virtp - vma->vm_start);
+	} else {
+		/* otherwise, use get_user_pages() for general userland pages */
+		int res, nr_pages = 1;
+		struct page *pages;
+		down_read(&current->mm->mmap_sem);
+
+		res = get_user_pages(current, current->mm, virtp, nr_pages,
+				1, 0, &pages, NULL);
+		up_read(&current->mm->mmap_sem);
+
+		if (res == nr_pages) {
+			physp =  __pa(page_address(&pages[0]) +
+					(virtp & ~PAGE_MASK));
+		} else {
+			printk(KERN_WARNING VOUT_NAME
+					"get_user_pages failed\n");
+			return 0;
+		}
+	}
+
+	return physp;
+}
+
+/*
+ * Wakes up the application once the DMA transfer to VRFB space is completed.
+ */
+static void omap_vout_vrfb_dma_tx_callback(int lch, u16 ch_status, void *data)
+{
+	struct vid_vrfb_dma *t = (struct vid_vrfb_dma *) data;
+
+	t->tx_status = 1;
+	wake_up_interruptible(&t->wait);
+}
+
+/*
+ * Release the VRFB context once the module exits
+ */
+static void omap_vout_release_vrfb(struct omap_vout_device *vout)
+{
+	int i;
+
+	for (i = 0; i < 4; i++)
+		omap_vrfb_release_ctx(&vout->vrfb_context[i]);
+
+	if (vout->vrfb_dma_tx.req_status == DMA_CHAN_ALLOTED) {
+		vout->vrfb_dma_tx.req_status = DMA_CHAN_NOT_ALLOTED;
+		omap_free_dma(vout->vrfb_dma_tx.dma_ch);
+	}
+
+}
+
+/*
+ * Return true if rotation is 90 or 270
+ */
+static inline int rotate_90_or_270(const struct omap_vout_device *vout)
+{
+	return (vout->rotation == dss_rotation_90_degree ||
+			vout->rotation == dss_rotation_270_degree);
+}
+
+/*
+ * Return true if rotation is enabled
+ */
+static inline int rotation_enabled(const struct omap_vout_device *vout)
+{
+	return vout->rotation || vout->mirror;
+}
+
+/*
+ * Reverse the rotation degree if mirroring is enabled
+ */
+static inline int calc_rotation(const struct omap_vout_device *vout)
+{
+	if (!vout->mirror)
+		return vout->rotation;
+
+	switch (vout->rotation) {
+	case dss_rotation_90_degree:
+		return dss_rotation_270_degree;
+	case dss_rotation_270_degree:
+		return dss_rotation_90_degree;
+	case dss_rotation_180_degree:
+		return dss_rotation_0_degree;
+	default:
+		return dss_rotation_180_degree;
+	}
+}
+
+/*
+ * Free the V4L2 buffers
+ */
+static void omap_vout_free_buffers(struct omap_vout_device *vout)
+{
+	int i, numbuffers;
+
+	/* Allocate memory for the buffers */
+	numbuffers = (vout->vid) ?  video2_numbuffers : video1_numbuffers;
+	vout->buffer_size = (vout->vid) ? video2_bufsize : video1_bufsize;
+
+	for (i = 0; i < numbuffers; i++) {
+		omap_vout_free_buffer(vout->buf_virt_addr[i],
+				vout->buffer_size);
+		vout->buf_phy_addr[i] = 0;
+		vout->buf_virt_addr[i] = 0;
+	}
+}
+
+/*
+ * Free VRFB buffers
+ */
+static void omap_vout_free_vrfb_buffers(struct omap_vout_device *vout)
+{
+	int j;
+
+	for (j = 0; j < 4; j++) {
+		omap_vout_free_buffer(vout->smsshado_virt_addr[j],
+				vout->smsshado_size);
+		vout->smsshado_virt_addr[j] = 0;
+		vout->smsshado_phy_addr[j] = 0;
+	}
+}
+
+/*
+ * Allocate the buffers for the VRFB space.  Data is copied from V4L2
+ * buffers to the VRFB buffers using the DMA engine.
+ */
+static int omap_vout_vrfb_buffer_setup(struct omap_vout_device *vout,
+			  unsigned int *count, unsigned int startindex)
+{
+	int i;
+	bool yuv_mode;
+
+	/* Allocate the VRFB buffers only if the buffers are not
+	 * allocated during init time.
+	 */
+	if ((rotation_enabled(vout)) &&
+			!vout->vrfb_static_allocation)
+		if (omap_vout_allocate_vrfb_buffers(vout, count, startindex))
+			return -ENOMEM;
+
+	if (vout->dss_mode == OMAP_DSS_COLOR_YUV2 ||
+			vout->dss_mode == OMAP_DSS_COLOR_UYVY)
+		yuv_mode = true;
+	else
+		yuv_mode = false;
+
+	for (i = 0; i < *count; i++) {
+		omap_vrfb_setup(&vout->vrfb_context[i],
+				vout->smsshado_phy_addr[i],
+				vout->pix.width, vout->pix.height,
+				vout->bpp, yuv_mode);
+	}
+	return 0;
+}
+
+/*
+ * Convert V4L2 rotation to DSS rotation
+ *	V4L2 understand 0, 90, 180, 270.
+ *	Convert to 0, 1, 2 and 3 repsectively for DSS
+ */
+static int v4l2_rot_to_dss_rot(int v4l2_rotation, enum dss_rotation *rotation,
+		bool mirror)
+{
+	switch (v4l2_rotation) {
+	case 90:
+		*rotation = dss_rotation_90_degree;
+		return 0;
+	case 180:
+		*rotation = dss_rotation_180_degree;
+		return 0;
+	case 270:
+		*rotation = dss_rotation_270_degree;
+		return 0;
+	case 0:
+		*rotation = dss_rotation_0_degree;
+		return 0;
+	default:
+		return -EINVAL;
+	}
+
+}
+
+/*
+ * Calculate the buffer offsets from which the streaming should
+ * start. This offset calculation is mainly required because of
+ * the VRFB 32 pixels alignment with rotation.
+ */
+static int omap_vout_calculate_offset(struct omap_vout_device *vout)
+{
+	struct omap_overlay *ovl;
+	enum dss_rotation rotation;
+	struct omapvideo_info *ovid;
+	bool mirroring = vout->mirror;
+	struct omap_dss_device *cur_display;
+	struct v4l2_rect *crop = &vout->crop;
+	struct v4l2_pix_format *pix = &vout->pix;
+	int *cropped_offset = &vout->cropped_offset;
+	int vr_ps = 1, ps = 2, temp_ps = 2;
+	int offset = 0, ctop = 0, cleft = 0, line_length = 0;
+
+	ovid = &vout->vid_info;
+	ovl = ovid->overlays[0];
+	/* get the display device attached to the overlay */
+	if (!ovl->manager || !ovl->manager->device)
+		return -1;
+	cur_display = ovl->manager->device;
+
+	rotation = calc_rotation(vout);
+
+	if (V4L2_PIX_FMT_YUYV == pix->pixelformat ||
+			V4L2_PIX_FMT_UYVY == pix->pixelformat) {
+		if (rotation_enabled(vout)) {
+			/*
+			 * ps    - Actual pixel size for YUYV/UYVY for
+			 *              VRFB/Mirroring is 4 bytes
+			 * vr_ps - Virtually pixel size for YUYV/UYVY is
+			 *              2 bytes
+			 */
+			ps = 4;
+			vr_ps = 2;
+		} else {
+			ps = 2;	/* otherwise the pixel size is 2 byte */
+		}
+	} else if (V4L2_PIX_FMT_RGB32 == pix->pixelformat) {
+		ps = 4;
+	} else if (V4L2_PIX_FMT_RGB24 == pix->pixelformat) {
+		ps = 3;
+	}
+	vout->ps = ps;
+	vout->vr_ps = vr_ps;
+
+	if (rotation_enabled(vout)) {
+		line_length = MAX_PIXELS_PER_LINE;
+		ctop = (pix->height - crop->height) - crop->top;
+		cleft = (pix->width - crop->width) - crop->left;
+	} else {
+		line_length = pix->width;
+	}
+	vout->line_length = line_length;
+	switch (rotation) {
+	case dss_rotation_90_degree:
+		offset = vout->vrfb_context[0].yoffset *
+			vout->vrfb_context[0].bytespp;
+		temp_ps = ps / vr_ps;
+		if (mirroring == 0) {
+			*cropped_offset = offset + line_length *
+				temp_ps * cleft + crop->top * temp_ps;
+		} else {
+			*cropped_offset = offset + line_length * temp_ps *
+				cleft + crop->top * temp_ps + (line_length *
+				((crop->width / (vr_ps)) - 1) * ps);
+		}
+		break;
+	case dss_rotation_180_degree:
+		offset = ((MAX_PIXELS_PER_LINE * vout->vrfb_context[0].yoffset *
+			vout->vrfb_context[0].bytespp) +
+			(vout->vrfb_context[0].xoffset *
+			vout->vrfb_context[0].bytespp));
+		if (mirroring == 0) {
+			*cropped_offset = offset + (line_length * ps * ctop) +
+				(cleft / vr_ps) * ps;
+
+		} else {
+			*cropped_offset = offset + (line_length * ps * ctop) +
+				(cleft / vr_ps) * ps + (line_length *
+				(crop->height - 1) * ps);
+		}
+		break;
+	case dss_rotation_270_degree:
+		offset = MAX_PIXELS_PER_LINE * vout->vrfb_context[0].xoffset *
+			vout->vrfb_context[0].bytespp;
+		temp_ps = ps / vr_ps;
+		if (mirroring == 0) {
+			*cropped_offset = offset + line_length *
+			    temp_ps * crop->left + ctop * ps;
+		} else {
+			*cropped_offset = offset + line_length *
+				temp_ps * crop->left + ctop * ps +
+				(line_length * ((crop->width / vr_ps) - 1) *
+				 ps);
+		}
+		break;
+	case dss_rotation_0_degree:
+		if (mirroring == 0) {
+			*cropped_offset = (line_length * ps) *
+				crop->top + (crop->left / vr_ps) * ps;
+		} else {
+			*cropped_offset = (line_length * ps) *
+				crop->top + (crop->left / vr_ps) * ps +
+				(line_length * (crop->height - 1) * ps);
+		}
+		break;
+	default:
+		*cropped_offset = (line_length * ps * crop->top) /
+			vr_ps + (crop->left * ps) / vr_ps +
+			((crop->width / vr_ps) - 1) * ps;
+		break;
+	}
+	v4l2_dbg(1, debug, &vout->vid_dev->v4l2_dev, "%s Offset:%x\n",
+			__func__, *cropped_offset);
+	return 0;
+}
+
+/*
+ * Convert V4L2 pixel format to DSS pixel format
+ */
+static enum omap_color_mode video_mode_to_dss_mode(struct omap_vout_device
+			*vout)
+{
+	struct omap_overlay *ovl;
+	struct omapvideo_info *ovid;
+	struct v4l2_pix_format *pix = &vout->pix;
+
+	ovid = &vout->vid_info;
+	ovl = ovid->overlays[0];
+
+	switch (pix->pixelformat) {
+	case 0:
+		break;
+	case V4L2_PIX_FMT_YUYV:
+		return OMAP_DSS_COLOR_YUV2;
+
+	case V4L2_PIX_FMT_UYVY:
+		return OMAP_DSS_COLOR_UYVY;
+
+	case V4L2_PIX_FMT_RGB565:
+		return OMAP_DSS_COLOR_RGB16;
+
+	case V4L2_PIX_FMT_RGB24:
+		return OMAP_DSS_COLOR_RGB24P;
+
+	case V4L2_PIX_FMT_RGB32:
+		return (ovl->id == OMAP_DSS_VIDEO1) ?
+			OMAP_DSS_COLOR_RGB24U : OMAP_DSS_COLOR_ARGB32;
+	case V4L2_PIX_FMT_BGR32:
+		return OMAP_DSS_COLOR_RGBX32;
+
+	default:
+		return -EINVAL;
+	}
+	return -EINVAL;
+}
+
+/*
+ * Setup the overlay
+ */
+int omapvid_setup_overlay(struct omap_vout_device *vout,
+		struct omap_overlay *ovl, int posx, int posy, int outw,
+		int outh, u32 addr)
+{
+	int ret = 0;
+	struct omap_overlay_info info;
+	int cropheight, cropwidth, pixheight, pixwidth;
+
+	if ((ovl->caps & OMAP_DSS_OVL_CAP_SCALE) == 0 &&
+			(outw != vout->pix.width || outh != vout->pix.height)) {
+		ret = -EINVAL;
+		goto setup_ovl_err;
+	}
+
+	vout->dss_mode = video_mode_to_dss_mode(vout);
+	if (vout->dss_mode == -EINVAL) {
+		ret = -EINVAL;
+		goto setup_ovl_err;
+	}
+
+	/* Setup the input plane parameters according to
+	 * rotation value selected.
+	 */
+	if (rotate_90_or_270(vout)) {
+		cropheight = vout->crop.width;
+		cropwidth = vout->crop.height;
+		pixheight = vout->pix.width;
+		pixwidth = vout->pix.height;
+	} else {
+		cropheight = vout->crop.height;
+		cropwidth = vout->crop.width;
+		pixheight = vout->pix.height;
+		pixwidth = vout->pix.width;
+	}
+
+	ovl->get_overlay_info(ovl, &info);
+	info.paddr = addr;
+	info.vaddr = NULL;
+	info.width = cropwidth;
+	info.height = cropheight;
+	info.color_mode = vout->dss_mode;
+	info.mirror = vout->mirror;;
+	info.pos_x = posx;
+	info.pos_y = posy;
+	info.out_width = outw;
+	info.out_height = outh;
+	info.global_alpha = vout->win.global_alpha;
+	if (!rotation_enabled(vout)) {
+		info.rotation = 0;
+		info.rotation_type = OMAP_DSS_ROT_DMA;
+		info.screen_width = pixwidth;
+	} else {
+		info.rotation = vout->rotation;
+		info.rotation_type = OMAP_DSS_ROT_VRFB;
+		info.screen_width = 2048;
+	}
+
+	v4l2_dbg(1, debug, &vout->vid_dev->v4l2_dev,
+		"%s info.enable=%d info.addr=%x info.width=%d\n info.height=%d "
+		"info.color_mode=%d info.rotation=%d info.mirror=%d\n "
+		"info.posx=%d info.posy=%d info.out_width = %d \n"
+		"info.out_height=%d info.rotation_type=%d info.screen_width=%d\n",
+		__func__, info.enabled, info.paddr, info.width, info.height,
+		info.color_mode, info.rotation, info.mirror, info.pos_x,
+		info.pos_y, info.out_width, info.out_height, info.rotation_type,
+		info.screen_width);
+
+	ret = ovl->set_overlay_info(ovl, &info);
+	if (ret)
+		goto setup_ovl_err;
+
+	return 0;
+
+setup_ovl_err:
+	v4l2_warn(&vout->vid_dev->v4l2_dev, "setup_overlay failed\n");
+	return ret;
+}
+
+/*
+ * Initialize the overlay structure
+ */
+int omapvid_init(struct omap_vout_device *vout, u32 addr)
+{
+	int ret = 0, i;
+	struct v4l2_window *win;
+	struct omap_overlay *ovl;
+	int posx, posy, outw, outh, temp;
+	struct omap_video_timings *timing;
+	struct omapvideo_info *ovid = &vout->vid_info;
+
+	win = &vout->win;
+	for (i = 0; i < ovid->num_overlays; i++) {
+		ovl = ovid->overlays[i];
+		if (!ovl->manager || !ovl->manager->device)
+			return -EINVAL;
+
+		timing = &ovl->manager->device->panel.timings;
+
+		outw = win->w.width;
+		outh = win->w.height;
+		switch (vout->rotation) {
+		case dss_rotation_90_degree:
+			/* Invert the height and width for 90
+			 * and 270 degree rotation
+			 */
+			temp = outw;
+			outw = outh;
+			outh = temp;
+			posy = (timing->y_res - win->w.width)-
+				win->w.left;
+			posx = win->w.top;
+			break;
+
+		case dss_rotation_180_degree:
+			posx = (timing->x_res - win->w.width) -
+				win->w.left;
+			posy = (timing->y_res - win->w.height) -
+				win->w.top;
+			break;
+
+		case dss_rotation_270_degree:
+			temp = outw;
+			outw = outh;
+			outh = temp;
+			posy = win->w.left;
+			posx = (timing->x_res - win->w.height)
+				- win->w.top;
+			break;
+
+		default:
+			posx = win->w.left;
+			posy = win->w.top;
+			break;
+		}
+
+		ret = omapvid_setup_overlay(vout, ovl, posx, posy, outw,
+				outh, addr);
+		if (ret)
+			goto omapvid_init_err;
+	}
+	return 0;
+
+omapvid_init_err:
+	v4l2_warn(&vout->vid_dev->v4l2_dev, "apply_changes failed\n");
+	return ret;
+}
+
+/*
+ * Apply the changes set the go bit of DSS
+ */
+int omapvid_apply_changes(struct omap_vout_device *vout)
+{
+	int i;
+	struct omap_overlay *ovl;
+	struct omapvideo_info *ovid = &vout->vid_info;
+
+	for (i = 0; i < ovid->num_overlays; i++) {
+		ovl = ovid->overlays[i];
+		if (!ovl->manager || !ovl->manager->device)
+			return -EINVAL;
+		ovl->manager->apply(ovl->manager);
+	}
+
+	return 0;
+}
+
+/* Video buffer call backs */
+
+/*
+ * Buffer setup function is called by videobuf layer when REQBUF ioctl is
+ * called. This is used to setup buffers and return size and count of
+ * buffers allocated. After the call to this buffer, videobuf layer will
+ * setup buffer queue depending on the size and count of buffers
+ */
+static int omap_vout_buffer_setup(struct videobuf_queue *q, unsigned int *count,
+			  unsigned int *size)
+{
+	int startindex = 0, i, j;
+	u32 phy_addr = 0, virt_addr = 0;
+	struct omap_vout_device *vout = q->priv_data;
+
+	if (!vout)
+		return -EINVAL;
+
+	if (V4L2_BUF_TYPE_VIDEO_OUTPUT != q->type)
+		return -EINVAL;
+
+	startindex = (vout->vid == OMAP_VIDEO1) ?
+		video1_numbuffers : video2_numbuffers;
+	if (V4L2_MEMORY_MMAP == vout->memory && *count < startindex)
+		*count = startindex;
+
+	if ((rotation_enabled(vout))
+			&& *count > 4)
+		*count = 4;
+
+	/* If rotation is enabled, allocate memory for VRFB space also */
+	if (rotation_enabled(vout)) {
+		if (omap_vout_vrfb_buffer_setup(vout, count, startindex))
+			return -ENOMEM;
+	}
+
+	if (V4L2_MEMORY_MMAP != vout->memory)
+		return 0;
+
+	/* Now allocated the V4L2 buffers */
+	*size = PAGE_ALIGN(vout->pix.width * vout->pix.height * vout->bpp);
+	startindex = (vout->vid == OMAP_VIDEO1) ?
+		video1_numbuffers : video2_numbuffers;
+	for (i = startindex; i < *count; i++) {
+		vout->buffer_size = *size;
+
+		virt_addr = omap_vout_alloc_buffer(vout->buffer_size,
+				&phy_addr);
+		if (!virt_addr) {
+			if (!rotation_enabled(vout))
+				break;
+			/* Free the VRFB buffers if no space for V4L2 buffers */
+			for (j = i; j < *count; j++) {
+				omap_vout_free_buffer(
+						vout->smsshado_virt_addr[j],
+						vout->smsshado_size);
+				vout->smsshado_virt_addr[j] = 0;
+				vout->smsshado_phy_addr[j] = 0;
+			}
+		}
+		vout->buf_virt_addr[i] = virt_addr;
+		vout->buf_phy_addr[i] = phy_addr;
+	}
+	*count = vout->buffer_allocated = i;
+
+	return 0;
+}
+
+/*
+ * Free the V4L2 buffers additionally allocated than default
+ * number of buffers and free all the VRFB buffers
+ */
+static void omap_vout_free_allbuffers(struct omap_vout_device *vout)
+{
+	int num_buffers = 0, i;
+
+	num_buffers = (vout->vid == OMAP_VIDEO1) ?
+		video1_numbuffers : video2_numbuffers;
+	for (i = num_buffers; i < vout->buffer_allocated; i++) {
+		if (vout->buf_virt_addr[i]) {
+			omap_vout_free_buffer(vout->buf_virt_addr[i],
+					vout->buffer_size);
+		}
+		vout->buf_virt_addr[i] = 0;
+		vout->buf_phy_addr[i] = 0;
+	}
+	/* Free the VRFB buffers only if they are allocated
+	 * during reqbufs.  Don't free if init time allocated
+	 */
+	if (!vout->vrfb_static_allocation) {
+		for (i = 0; i < 4; i++) {
+			if (vout->smsshado_virt_addr[i]) {
+				omap_vout_free_buffer(
+						vout->smsshado_virt_addr[i],
+						vout->smsshado_size);
+				vout->smsshado_virt_addr[i] = 0;
+				vout->smsshado_phy_addr[i] = 0;
+			}
+		}
+	}
+	vout->buffer_allocated = num_buffers;
+}
+
+/*
+ * This function will be called when VIDIOC_QBUF ioctl is called.
+ * It prepare buffers before give out for the display. This function
+ * converts user space virtual address into physical address if userptr memory
+ * exchange mechanism is used. If rotation is enabled, it copies entire
+ * buffer into VRFB memory space before giving it to the DSS.
+ */
+static int omap_vout_buffer_prepare(struct videobuf_queue *q,
+			    struct videobuf_buffer *vb,
+			    enum v4l2_field field)
+{
+	struct vid_vrfb_dma *tx;
+	enum dss_rotation rotation;
+	struct videobuf_dmabuf *dmabuf = NULL;
+	struct omap_vout_device *vout = q->priv_data;
+	u32 dest_frame_index = 0, src_element_index = 0;
+	u32 dest_element_index = 0, src_frame_index = 0;
+	u32 elem_count = 0, frame_count = 0, pixsize = 2;
+
+	if (VIDEOBUF_NEEDS_INIT == vb->state) {
+		vb->width = vout->pix.width;
+		vb->height = vout->pix.height;
+		vb->size = vb->width * vb->height * vout->bpp;
+		vb->field = field;
+	}
+	vb->state = VIDEOBUF_PREPARED;
+	/* if user pointer memory mechanism is used, get the physical
+	 * address of the buffer
+	 */
+	if (V4L2_MEMORY_USERPTR == vb->memory) {
+		if (0 == vb->baddr)
+			return -EINVAL;
+		/* Virtual address */
+		/* priv points to struct videobuf_pci_sg_memory. But we went
+		 * pointer to videobuf_dmabuf, which is member of
+		 * videobuf_pci_sg_memory */
+		dmabuf = videobuf_to_dma(q->bufs[vb->i]);
+		dmabuf->vmalloc = (void *) vb->baddr;
+
+		/* Physical address */
+		dmabuf->bus_addr =
+			(dma_addr_t) omap_vout_uservirt_to_phys(vb->baddr);
+	}
+
+	if (!rotation_enabled(vout)) {
+		dmabuf = videobuf_to_dma(q->bufs[vb->i]);
+
+		vout->queued_buf_addr[vb->i] = (u8 *) dmabuf->bus_addr;
+		return 0;
+	}
+	dmabuf = videobuf_to_dma(q->bufs[vb->i]);
+	/* If rotation is enabled, copy input buffer into VRFB
+	 * memory space using DMA. We are copying input buffer
+	 * into VRFB memory space of desired angle and DSS will
+	 * read image VRFB memory for 0 degree angle
+	 */
+	pixsize = vout->bpp * vout->vrfb_bpp;
+	/*
+	 * DMA transfer in double index mode
+	 */
+
+	/* Frame index */
+	dest_frame_index = ((MAX_PIXELS_PER_LINE * pixsize) -
+			(vout->pix.width * vout->bpp)) + 1;
+
+	/* Source and destination parameters */
+	src_element_index = 0;
+	src_frame_index = 0;
+	dest_element_index = 1;
+	/* Number of elements per frame */
+	elem_count = vout->pix.width * vout->bpp;
+	frame_count = vout->pix.height;
+	tx = &vout->vrfb_dma_tx;
+	tx->tx_status = 0;
+	omap_set_dma_transfer_params(tx->dma_ch, OMAP_DMA_DATA_TYPE_S32,
+			(elem_count / 4), frame_count, OMAP_DMA_SYNC_ELEMENT,
+			tx->dev_id, 0x0);
+	/* src_port required only for OMAP1 */
+	omap_set_dma_src_params(tx->dma_ch, 0, OMAP_DMA_AMODE_POST_INC,
+			dmabuf->bus_addr, src_element_index, src_frame_index);
+	/*set dma source burst mode for VRFB */
+	omap_set_dma_src_burst_mode(tx->dma_ch, OMAP_DMA_DATA_BURST_16);
+	rotation = calc_rotation(vout);
+
+	/* dest_port required only for OMAP1 */
+	omap_set_dma_dest_params(tx->dma_ch, 0, OMAP_DMA_AMODE_DOUBLE_IDX,
+			vout->vrfb_context[vb->i].paddr[0], dest_element_index,
+			dest_frame_index);
+	/*set dma dest burst mode for VRFB */
+	omap_set_dma_dest_burst_mode(tx->dma_ch, OMAP_DMA_DATA_BURST_16);
+	omap_dma_set_global_params(DMA_DEFAULT_ARB_RATE, 0x20, 0);
+
+	omap_start_dma(tx->dma_ch);
+	interruptible_sleep_on_timeout(&tx->wait, VRFB_TX_TIMEOUT);
+
+	if (tx->tx_status == 0) {
+		omap_stop_dma(tx->dma_ch);
+		return -EINVAL;
+	}
+	/* Store buffers physical address into an array. Addresses
+	 * from this array will be used to configure DSS */
+	vout->queued_buf_addr[vb->i] = (u8 *)
+		vout->vrfb_context[vb->i].paddr[rotation];
+	return 0;
+}
+
+/*
+ * Buffer queue funtion will be called from the videobuf layer when _QBUF
+ * ioctl is called. It is used to enqueue buffer, which is ready to be
+ * displayed.
+ */
+static void omap_vout_buffer_queue(struct videobuf_queue *q,
+			  struct videobuf_buffer *vb)
+{
+	struct omap_vout_device *vout = q->priv_data;
+
+	/* Driver is also maintainig a queue. So enqueue buffer in the driver
+	 * queue */
+	list_add_tail(&vb->queue, &vout->dma_queue);
+
+	vb->state = VIDEOBUF_QUEUED;
+}
+
+/*
+ * Buffer release function is called from videobuf layer to release buffer
+ * which are already allocated
+ */
+static void omap_vout_buffer_release(struct videobuf_queue *q,
+			    struct videobuf_buffer *vb)
+{
+	struct omap_vout_device *vout = q->priv_data;
+
+	vb->state = VIDEOBUF_NEEDS_INIT;
+
+	if (V4L2_MEMORY_MMAP != vout->memory)
+		return;
+}
+
+/*
+ *  File operations
+ */
+static void omap_vout_vm_open(struct vm_area_struct *vma)
+{
+	struct omap_vout_device *vout = vma->vm_private_data;
+
+	v4l2_dbg(1, debug, &vout->vid_dev->v4l2_dev,
+		"vm_open [vma=%08lx-%08lx]\n", vma->vm_start, vma->vm_end);
+	vout->mmap_count++;
+}
+
+static void omap_vout_vm_close(struct vm_area_struct *vma)
+{
+	struct omap_vout_device *vout = vma->vm_private_data;
+
+	v4l2_dbg(1, debug, &vout->vid_dev->v4l2_dev,
+		"vm_close [vma=%08lx-%08lx]\n", vma->vm_start, vma->vm_end);
+	vout->mmap_count--;
+}
+
+static struct vm_operations_struct omap_vout_vm_ops = {
+	.open	= omap_vout_vm_open,
+	.close	= omap_vout_vm_close,
+};
+
+static int omap_vout_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	int i;
+	void *pos;
+	unsigned long start = vma->vm_start;
+	unsigned long size = (vma->vm_end - vma->vm_start);
+	struct videobuf_dmabuf *dmabuf = NULL;
+	struct omap_vout_device *vout = file->private_data;
+	struct videobuf_queue *q = &vout->vbq;
+
+	v4l2_dbg(1, debug, &vout->vid_dev->v4l2_dev,
+			" %s pgoff=0x%lx, start=0x%lx, end=0x%lx\n", __func__,
+			vma->vm_pgoff, vma->vm_start, vma->vm_end);
+
+	/* look for the buffer to map */
+	for (i = 0; i < VIDEO_MAX_FRAME; i++) {
+		if (NULL == q->bufs[i])
+			continue;
+		if (V4L2_MEMORY_MMAP != q->bufs[i]->memory)
+			continue;
+		if (q->bufs[i]->boff == (vma->vm_pgoff << PAGE_SHIFT))
+			break;
+	}
+
+	if (VIDEO_MAX_FRAME == i) {
+		v4l2_dbg(1, debug, &vout->vid_dev->v4l2_dev,
+				"offset invalid [offset=0x%lx]\n",
+				(vma->vm_pgoff << PAGE_SHIFT));
+		return -EINVAL;
+	}
+	q->bufs[i]->baddr = vma->vm_start;
+
+	vma->vm_flags |= VM_RESERVED;
+	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
+	vma->vm_ops = &omap_vout_vm_ops;
+	vma->vm_private_data = (void *) vout;
+	dmabuf = videobuf_to_dma(q->bufs[i]);
+	pos = dmabuf->vmalloc;
+	vma->vm_pgoff = virt_to_phys((void *)pos) >> PAGE_SHIFT;
+	while (size > 0) {
+		unsigned long pfn;
+		pfn = virt_to_phys((void *) pos) >> PAGE_SHIFT;
+		if (remap_pfn_range(vma, start, pfn, PAGE_SIZE, PAGE_SHARED))
+			return -EAGAIN;
+		start += PAGE_SIZE;
+		pos += PAGE_SIZE;
+		size -= PAGE_SIZE;
+	}
+	vout->mmap_count++;
+	v4l2_dbg(1, debug, &vout->vid_dev->v4l2_dev, "Exiting %s\n", __func__);
+
+	return 0;
+}
+
+static int omap_vout_release(struct file *file)
+{
+	unsigned int ret, i;
+	struct videobuf_queue *q;
+	struct omapvideo_info *ovid;
+	struct omap_vout_device *vout = file->private_data;
+
+	v4l2_dbg(1, debug, &vout->vid_dev->v4l2_dev, "Entering %s\n", __func__);
+	ovid = &vout->vid_info;
+
+	if (!vout)
+		return 0;
+
+	q = &vout->vbq;
+	/* Disable all the overlay managers connected with this interface */
+	for (i = 0; i < ovid->num_overlays; i++) {
+		struct omap_overlay *ovl = ovid->overlays[i];
+		if (ovl->manager && ovl->manager->device) {
+			struct omap_overlay_info info;
+			ovl->get_overlay_info(ovl, &info);
+			info.enabled = 0;
+			ovl->set_overlay_info(ovl, &info);
+		}
+	}
+	/* Turn off the pipeline */
+	ret = omapvid_apply_changes(vout);
+	if (ret)
+		v4l2_warn(&vout->vid_dev->v4l2_dev,
+				"Unable to apply changes\n");
+
+	/* Free all buffers */
+	omap_vout_free_allbuffers(vout);
+	videobuf_mmap_free(q);
+
+	/* Even if apply changes fails we should continue
+	   freeing allocated memeory */
+	if (vout->streaming) {
+		u32 mask = 0;
+
+		mask = DISPC_IRQ_VSYNC | DISPC_IRQ_EVSYNC_EVEN |
+			DISPC_IRQ_EVSYNC_ODD;
+		omap_dispc_unregister_isr(omap_vout_isr, vout, mask);
+		vout->streaming = 0;
+
+		videobuf_streamoff(q);
+		videobuf_queue_cancel(q);
+	}
+
+	if (vout->mmap_count != 0)
+		vout->mmap_count = 0;
+
+	vout->opened -= 1;
+	file->private_data = NULL;
+
+	if (vout->buffer_allocated)
+		videobuf_mmap_free(q);
+
+	v4l2_dbg(1, debug, &vout->vid_dev->v4l2_dev, "Exiting %s\n", __func__);
+	return ret;
+}
+
+static int omap_vout_open(struct file *file)
+{
+	struct videobuf_queue *q;
+	struct omap_vout_device *vout = NULL;
+
+	vout = video_drvdata(file);
+	v4l2_dbg(1, debug, &vout->vid_dev->v4l2_dev, "Entering %s\n", __func__);
+
+	if (vout == NULL)
+		return -ENODEV;
+
+	/* for now, we only support single open */
+	if (vout->opened)
+		return -EBUSY;
+
+	vout->opened += 1;
+
+	file->private_data = vout;
+	vout->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+
+	q = &vout->vbq;
+	video_vbq_ops.buf_setup = omap_vout_buffer_setup;
+	video_vbq_ops.buf_prepare = omap_vout_buffer_prepare;
+	video_vbq_ops.buf_release = omap_vout_buffer_release;
+	video_vbq_ops.buf_queue = omap_vout_buffer_queue;
+	spin_lock_init(&vout->vbq_lock);
+
+	videobuf_queue_sg_init(q, &video_vbq_ops, NULL, &vout->vbq_lock,
+			vout->type, V4L2_FIELD_NONE, sizeof
+			(struct videobuf_buffer), vout);
+
+	v4l2_dbg(1, debug, &vout->vid_dev->v4l2_dev, "Exiting %s\n", __func__);
+	return 0;
+}
+
+/*
+ * V4L2 ioctls
+ */
+static int vidioc_querycap(struct file *file, void *fh,
+		struct v4l2_capability *cap)
+{
+	struct omap_vout_device *vout = fh;
+
+	strlcpy(cap->driver, VOUT_NAME, sizeof(cap->driver));
+	strlcpy(cap->card, vout->vfd->name, sizeof(cap->card));
+	cap->bus_info[0] = '\0';
+	cap->capabilities = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_OUTPUT;
+
+	return 0;
+}
+
+static int vidioc_enum_fmt_vid_out(struct file *file, void *fh,
+			struct v4l2_fmtdesc *fmt)
+{
+	int index = fmt->index;
+	enum v4l2_buf_type type = fmt->type;
+
+	fmt->index = index;
+	fmt->type = type;
+	if (index >= NUM_OUTPUT_FORMATS)
+		return -EINVAL;
+
+	fmt->flags = omap_formats[index].flags;
+	strlcpy(fmt->description, omap_formats[index].description,
+			sizeof(fmt->description));
+	fmt->pixelformat = omap_formats[index].pixelformat;
+
+	return 0;
+}
+
+static int vidioc_g_fmt_vid_out(struct file *file, void *fh,
+			struct v4l2_format *f)
+{
+	struct omap_vout_device *vout = fh;
+
+	f->fmt.pix = vout->pix;
+	return 0;
+
+}
+
+static int vidioc_try_fmt_vid_out(struct file *file, void *fh,
+			struct v4l2_format *f)
+{
+	struct omap_overlay *ovl;
+	struct omapvideo_info *ovid;
+	struct omap_video_timings *timing;
+	struct omap_vout_device *vout = fh;
+
+	if (vout->streaming)
+		return -EBUSY;
+
+	ovid = &vout->vid_info;
+	ovl = ovid->overlays[0];
+
+	if (!ovl->manager || !ovl->manager->device)
+		return -EINVAL;
+	/* get the display device attached to the overlay */
+	timing = &ovl->manager->device->panel.timings;
+
+	vout->fbuf.fmt.height = timing->y_res;
+	vout->fbuf.fmt.width = timing->x_res;
+
+	omap_vout_try_format(&f->fmt.pix);
+	return 0;
+}
+
+static int vidioc_s_fmt_vid_out(struct file *file, void *fh,
+			struct v4l2_format *f)
+{
+	int ret, bpp;
+	struct omap_overlay *ovl;
+	struct omapvideo_info *ovid;
+	struct omap_video_timings *timing;
+	struct omap_vout_device *vout = fh;
+
+	if (vout->streaming)
+		return -EBUSY;
+
+	mutex_lock(&vout->lock);
+
+	ovid = &vout->vid_info;
+	ovl = ovid->overlays[0];
+
+	/* get the display device attached to the overlay */
+	if (!ovl->manager || !ovl->manager->device) {
+		ret = -EINVAL;
+		goto s_fmt_vid_out_exit;
+	}
+	timing = &ovl->manager->device->panel.timings;
+
+	/* We dont support RGB24-packed mode if vrfb rotation
+	 * is enabled*/
+	if ((rotation_enabled(vout)) &&
+			f->fmt.pix.pixelformat == V4L2_PIX_FMT_RGB24) {
+		ret = -EINVAL;
+		goto s_fmt_vid_out_exit;
+	}
+
+	/* get the framebuffer parameters */
+
+	if (rotate_90_or_270(vout)) {
+		vout->fbuf.fmt.height = timing->x_res;
+		vout->fbuf.fmt.width = timing->y_res;
+	} else {
+		vout->fbuf.fmt.height = timing->y_res;
+		vout->fbuf.fmt.width = timing->x_res;
+	}
+
+	/* change to samller size is OK */
+
+	bpp = omap_vout_try_format(&f->fmt.pix);
+	f->fmt.pix.sizeimage = f->fmt.pix.width * f->fmt.pix.height * bpp;
+
+	/* try & set the new output format */
+	vout->bpp = bpp;
+	vout->pix = f->fmt.pix;
+	vout->vrfb_bpp = 1;
+
+	/* If YUYV then vrfb bpp is 2, for  others its 1 */
+	if (V4L2_PIX_FMT_YUYV == vout->pix.pixelformat ||
+			V4L2_PIX_FMT_UYVY == vout->pix.pixelformat)
+		vout->vrfb_bpp = 2;
+
+	/* set default crop and win */
+	omap_vout_new_format(&vout->pix, &vout->fbuf, &vout->crop, &vout->win);
+
+	/* Save the changes in the overlay strcuture */
+	ret = omapvid_init(vout, 0);
+	if (ret) {
+		v4l2_err(&vout->vid_dev->v4l2_dev, "failed to change mode\n");
+		goto s_fmt_vid_out_exit;
+	}
+
+	ret = 0;
+
+s_fmt_vid_out_exit:
+	mutex_unlock(&vout->lock);
+	return ret;
+}
+
+static int vidioc_try_fmt_vid_overlay(struct file *file, void *fh,
+			struct v4l2_format *f)
+{
+	int ret = 0;
+	struct omap_vout_device *vout = fh;
+	struct v4l2_window *win = &f->fmt.win;
+
+	ret = omap_vout_try_window(&vout->fbuf, win);
+
+	if (!ret) {
+		if (vout->vid == OMAP_VIDEO1)
+			win->global_alpha = 255;
+		else
+			win->global_alpha = f->fmt.win.global_alpha;
+	}
+
+	return ret;
+}
+
+static int vidioc_s_fmt_vid_overlay(struct file *file, void *fh,
+			struct v4l2_format *f)
+{
+	int ret = 0;
+	struct omap_overlay *ovl;
+	struct omapvideo_info *ovid;
+	struct omap_vout_device *vout = fh;
+	struct v4l2_window *win = &f->fmt.win;
+
+	mutex_lock(&vout->lock);
+	ovid = &vout->vid_info;
+	ovl = ovid->overlays[0];
+
+	ret = omap_vout_new_window(&vout->crop, &vout->win, &vout->fbuf, win);
+	if (!ret) {
+		/* Video1 plane does not support global alpha */
+		if (ovl->id == OMAP_DSS_VIDEO1)
+			vout->win.global_alpha = 255;
+		else
+			vout->win.global_alpha = f->fmt.win.global_alpha;
+
+		vout->win.chromakey = f->fmt.win.chromakey;
+	}
+	mutex_unlock(&vout->lock);
+	return ret;
+}
+
+static int vidioc_enum_fmt_vid_overlay(struct file *file, void *fh,
+			struct v4l2_fmtdesc *fmt)
+{
+	int index = fmt->index;
+	enum v4l2_buf_type type = fmt->type;
+
+	fmt->index = index;
+	fmt->type = type;
+	if (index >= NUM_OUTPUT_FORMATS)
+		return -EINVAL;
+
+	fmt->flags = omap_formats[index].flags;
+	strlcpy(fmt->description, omap_formats[index].description,
+			sizeof(fmt->description));
+	fmt->pixelformat = omap_formats[index].pixelformat;
+	return 0;
+}
+
+static int vidioc_g_fmt_vid_overlay(struct file *file, void *fh,
+			struct v4l2_format *f)
+{
+	u32 key_value =  0;
+	struct omap_overlay *ovl;
+	struct omapvideo_info *ovid;
+	struct omap_vout_device *vout = fh;
+	struct omap_overlay_manager_info info;
+	struct v4l2_window *win = &f->fmt.win;
+
+	ovid = &vout->vid_info;
+	ovl = ovid->overlays[0];
+
+	win->w = vout->win.w;
+	win->field = vout->win.field;
+	win->global_alpha = vout->win.global_alpha;
+
+	if (ovl->manager && ovl->manager->get_manager_info) {
+		ovl->manager->get_manager_info(ovl->manager, &info);
+		key_value = info.trans_key;
+	}
+	win->chromakey = key_value;
+	return 0;
+}
+
+static int vidioc_cropcap(struct file *file, void *fh,
+		struct v4l2_cropcap *cropcap)
+{
+	struct omap_vout_device *vout = fh;
+	struct v4l2_pix_format *pix = &vout->pix;
+
+	if (cropcap->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
+		return -EINVAL;
+
+	/* Width and height are always even */
+	cropcap->bounds.width = pix->width & ~1;
+	cropcap->bounds.height = pix->height & ~1;
+
+	omap_vout_default_crop(&vout->pix, &vout->fbuf, &cropcap->defrect);
+	cropcap->pixelaspect.numerator = 1;
+	cropcap->pixelaspect.denominator = 1;
+	return 0;
+}
+
+static int vidioc_g_crop(struct file *file, void *fh, struct v4l2_crop *crop)
+{
+	struct omap_vout_device *vout = fh;
+
+	if (crop->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
+		return -EINVAL;
+	crop->c = vout->crop;
+	return 0;
+}
+
+static int vidioc_s_crop(struct file *file, void *fh, struct v4l2_crop *crop)
+{
+	int ret = -EINVAL;
+	struct omap_vout_device *vout = fh;
+	struct omapvideo_info *ovid;
+	struct omap_overlay *ovl;
+	struct omap_video_timings *timing;
+
+	if (vout->streaming)
+		return -EBUSY;
+
+	mutex_lock(&vout->lock);
+	ovid = &vout->vid_info;
+	ovl = ovid->overlays[0];
+
+	if (!ovl->manager || !ovl->manager->device) {
+		ret = -EINVAL;
+		goto s_crop_err;
+	}
+	/* get the display device attached to the overlay */
+	timing = &ovl->manager->device->panel.timings;
+
+	if (rotate_90_or_270(vout)) {
+		vout->fbuf.fmt.height = timing->x_res;
+		vout->fbuf.fmt.width = timing->y_res;
+	} else {
+		vout->fbuf.fmt.height = timing->y_res;
+		vout->fbuf.fmt.width = timing->x_res;
+	}
+
+	if (crop->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+		ret = omap_vout_new_crop(&vout->pix, &vout->crop, &vout->win,
+				&vout->fbuf, &crop->c);
+
+s_crop_err:
+	mutex_unlock(&vout->lock);
+	return ret;
+}
+
+static int vidioc_queryctrl(struct file *file, void *fh,
+		struct v4l2_queryctrl *ctrl)
+{
+	switch (ctrl->id) {
+	case V4L2_CID_ROTATE:
+		v4l2_ctrl_query_fill(ctrl, 0, 270, 90, 0);
+		break;
+	case V4L2_CID_BG_COLOR:
+		v4l2_ctrl_query_fill(ctrl, 0, 0xFFFFFF, 1, 0);
+		break;
+	case V4L2_CID_VFLIP:
+		v4l2_ctrl_query_fill(ctrl, 0, 1, 1, 0);
+	default:
+		ctrl->name[0] = '\0';
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int vidioc_g_ctrl(struct file *file, void *fh, struct v4l2_control *ctrl)
+{
+	struct omap_vout_device *vout = fh;
+
+	switch (ctrl->id) {
+	case V4L2_CID_ROTATE:
+		ctrl->value = vout->control[0].value;
+		return 0;
+	case V4L2_CID_BG_COLOR:
+	{
+		struct omap_overlay_manager_info info;
+		struct omap_overlay *ovl;
+		ovl = vout->vid_info.overlays[0];
+
+		if (!ovl->manager || !ovl->manager->get_manager_info)
+			return -EINVAL;
+
+		ovl->manager->get_manager_info(ovl->manager, &info);
+		ctrl->value = info.default_color;
+		return 0;
+	}
+	case V4L2_CID_VFLIP:
+		ctrl->value = vout->control[2].value;
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
+static int vidioc_s_ctrl(struct file *file, void *fh, struct v4l2_control *a)
+{
+	struct omap_vout_device *vout = fh;
+
+	switch (a->id) {
+	case V4L2_CID_ROTATE:
+	{
+		int rotation = a->value;
+
+		mutex_lock(&vout->lock);
+
+		if (rotation &&
+			vout->pix.pixelformat == V4L2_PIX_FMT_RGB24) {
+			mutex_unlock(&vout->lock);
+			return -EINVAL;
+		}
+
+		if ((v4l2_rot_to_dss_rot(rotation, &vout->rotation,
+				vout->mirror))) {
+			mutex_unlock(&vout->lock);
+			return -EINVAL;
+		}
+
+		vout->control[0].value = rotation;
+		mutex_unlock(&vout->lock);
+		return 0;
+	}
+	case V4L2_CID_BG_COLOR:
+	{
+		struct omap_overlay *ovl;
+		unsigned int  color = a->value;
+		struct omap_overlay_manager_info info;
+
+		ovl = vout->vid_info.overlays[0];
+
+		mutex_lock(&vout->lock);
+		if (!ovl->manager || !ovl->manager->get_manager_info) {
+			mutex_unlock(&vout->lock);
+			return -EINVAL;
+		}
+
+		ovl->manager->get_manager_info(ovl->manager, &info);
+		info.default_color = color;
+		if (ovl->manager->set_manager_info(ovl->manager, &info)) {
+			mutex_unlock(&vout->lock);
+			return -EINVAL;
+		}
+
+		vout->control[1].value = color;
+		mutex_unlock(&vout->lock);
+		return 0;
+	}
+	case V4L2_CID_VFLIP:
+	{
+		struct omap_overlay *ovl;
+		struct omapvideo_info *ovid;
+		unsigned int  mirror = a->value;
+
+		ovid = &vout->vid_info;
+		ovl = ovid->overlays[0];
+
+		mutex_lock(&vout->lock);
+
+		if (mirror  && vout->pix.pixelformat == V4L2_PIX_FMT_RGB24) {
+			mutex_unlock(&vout->lock);
+			return -EINVAL;
+		}
+		vout->mirror = mirror;
+		vout->control[2].value = mirror;
+		mutex_unlock(&vout->lock);
+		return 0;
+	}
+
+	default:
+		return -EINVAL;
+	}
+
+}
+
+static int vidioc_reqbufs(struct file *file, void *fh,
+			struct v4l2_requestbuffers *req)
+{
+	int ret = 0;
+	unsigned int i, num_buffers = 0;
+	struct omap_vout_device *vout = fh;
+	struct videobuf_queue *q = &vout->vbq;
+	struct videobuf_dmabuf *dmabuf = NULL;
+
+	if ((req->type != V4L2_BUF_TYPE_VIDEO_OUTPUT) || (req->count < 0))
+		return -EINVAL;
+	/* if memory is not mmp or userptr
+	   return error */
+	if ((V4L2_MEMORY_MMAP != req->memory) &&
+			(V4L2_MEMORY_USERPTR != req->memory))
+		return -EINVAL;
+
+	mutex_lock(&vout->lock);
+	/* Cannot be requested when streaming is on */
+	if (vout->streaming) {
+		ret = -EBUSY;
+		goto reqbuf_err;
+	}
+
+	/* If buffers are already allocated free them */
+	if (q->bufs[0] && (V4L2_MEMORY_MMAP == q->bufs[0]->memory)) {
+		if (vout->mmap_count) {
+			ret = -EBUSY;
+			goto reqbuf_err;
+		}
+		num_buffers = (vout->vid == OMAP_VIDEO1) ?
+			video1_numbuffers : video2_numbuffers;
+		for (i = num_buffers; i < vout->buffer_allocated; i++) {
+			dmabuf = videobuf_to_dma(q->bufs[i]);
+			omap_vout_free_buffer((u32)dmabuf->vmalloc,
+					vout->buffer_size);
+			vout->buf_virt_addr[i] = 0;
+			vout->buf_phy_addr[i] = 0;
+		}
+		vout->buffer_allocated = num_buffers;
+		videobuf_mmap_free(q);
+	} else if (q->bufs[0] && (V4L2_MEMORY_USERPTR == q->bufs[0]->memory)) {
+		if (vout->buffer_allocated) {
+			videobuf_mmap_free(q);
+			for (i = 0; i < vout->buffer_allocated; i++) {
+				kfree(q->bufs[i]);
+				q->bufs[i] = NULL;
+			}
+			vout->buffer_allocated = 0;
+		}
+	}
+
+	/*store the memory type in data structure */
+	vout->memory = req->memory;
+
+	INIT_LIST_HEAD(&vout->dma_queue);
+
+	/* call videobuf_reqbufs api */
+	ret = videobuf_reqbufs(q, req);
+	if (ret < 0)
+		goto reqbuf_err;
+
+	vout->buffer_allocated = req->count;
+	for (i = 0; i < req->count; i++) {
+		dmabuf = videobuf_to_dma(q->bufs[i]);
+		dmabuf->vmalloc = (void *) vout->buf_virt_addr[i];
+		dmabuf->bus_addr = (dma_addr_t) vout->buf_phy_addr[i];
+		dmabuf->sglen = 1;
+	}
+reqbuf_err:
+	mutex_unlock(&vout->lock);
+	return ret;
+}
+
+static int vidioc_querybuf(struct file *file, void *fh,
+			struct v4l2_buffer *b)
+{
+	struct omap_vout_device *vout = fh;
+
+	return videobuf_querybuf(&vout->vbq, b);
+}
+
+static int vidioc_qbuf(struct file *file, void *fh,
+			struct v4l2_buffer *buffer)
+{
+	struct omap_vout_device *vout = fh;
+	struct videobuf_queue *q = &vout->vbq;
+
+	if ((V4L2_BUF_TYPE_VIDEO_OUTPUT != buffer->type) ||
+			(buffer->index >= vout->buffer_allocated) ||
+			(q->bufs[buffer->index]->memory != buffer->memory)) {
+		return -EINVAL;
+	}
+	if (V4L2_MEMORY_USERPTR == buffer->memory) {
+		if ((buffer->length < vout->pix.sizeimage) ||
+				(0 == buffer->m.userptr)) {
+			return -EINVAL;
+		}
+	}
+
+	if ((rotation_enabled(vout)) &&
+			vout->vrfb_dma_tx.req_status == DMA_CHAN_NOT_ALLOTED) {
+		v4l2_warn(&vout->vid_dev->v4l2_dev,
+				"DMA Channel not allocated for Rotation\n");
+		return -EINVAL;
+	}
+
+	return videobuf_qbuf(q, buffer);
+}
+
+static int vidioc_dqbuf(struct file *file, void *fh,
+			struct v4l2_buffer *b)
+{
+	struct omap_vout_device *vout = fh;
+	struct videobuf_queue *q = &vout->vbq;
+
+	if (!vout->streaming)
+		return -EINVAL;
+
+	if (file->f_flags & O_NONBLOCK)
+		/* Call videobuf_dqbuf for non blocking mode */
+		return videobuf_dqbuf(q, (struct v4l2_buffer *)b, 1);
+	else
+		/* Call videobuf_dqbuf for  blocking mode */
+		return videobuf_dqbuf(q, (struct v4l2_buffer *)b, 0);
+}
+
+static int vidioc_streamon(struct file *file, void *fh,
+			enum v4l2_buf_type i)
+{
+	int ret = 0, j;
+	u32 addr = 0, mask = 0;
+	struct omap_vout_device *vout = fh;
+	struct videobuf_queue *q = &vout->vbq;
+	struct omapvideo_info *ovid = &vout->vid_info;
+
+	mutex_lock(&vout->lock);
+
+	if (vout->streaming) {
+		ret = -EBUSY;
+		goto streamon_err;
+	}
+
+	ret = videobuf_streamon(q);
+	if (ret < 0)
+		goto streamon_err;
+
+	if (list_empty(&vout->dma_queue)) {
+		ret = -EIO;
+		goto streamon_err;
+	}
+	/* Get the next frame from the buffer queue */
+	vout->next_frm = vout->cur_frm = list_entry(vout->dma_queue.next,
+			struct videobuf_buffer, queue);
+	/* Remove buffer from the buffer queue */
+	list_del(&vout->cur_frm->queue);
+	/* Mark state of the current frame to active */
+	vout->cur_frm->state = VIDEOBUF_ACTIVE;
+	/* Initialize field_id and started member */
+	vout->field_id = 0;
+
+	/* set flag here. Next QBUF will start DMA */
+	vout->streaming = 1;
+
+	vout->first_int = 1;
+
+	if (omap_vout_calculate_offset(vout)) {
+		ret = -EINVAL;
+		goto streamon_err;
+	}
+	addr = (unsigned long) vout->queued_buf_addr[vout->cur_frm->i]
+		+ vout->cropped_offset;
+
+	mask = DISPC_IRQ_VSYNC | DISPC_IRQ_EVSYNC_EVEN |
+		DISPC_IRQ_EVSYNC_ODD;
+
+	omap_dispc_register_isr(omap_vout_isr, vout, mask);
+
+	for (j = 0; j < ovid->num_overlays; j++) {
+		struct omap_overlay *ovl = ovid->overlays[j];
+		if (ovl->manager && ovl->manager->device) {
+			struct omap_overlay_info info;
+			ovl->get_overlay_info(ovl, &info);
+			info.enabled = 1;
+			info.paddr = addr;
+			if (ovl->set_overlay_info(ovl, &info)) {
+				ret = -EINVAL;
+				goto streamon_err;
+			}
+		}
+	}
+
+	/* First save the configuration in ovelray structure */
+	ret = omapvid_init(vout, addr);
+	if (ret)
+		v4l2_err(&vout->vid_dev->v4l2_dev,
+				"failed to set overlay info\n");
+	/* Enable the pipeline and set the Go bit */
+	ret = omapvid_apply_changes(vout);
+	if (ret)
+		v4l2_err(&vout->vid_dev->v4l2_dev, "failed to change mode\n");
+
+	ret = 0;
+
+streamon_err:
+	mutex_unlock(&vout->lock);
+	return ret;
+}
+
+static int vidioc_streamoff(struct file *file, void *fh,
+			enum v4l2_buf_type i)
+{
+	u32 mask = 0;
+	int ret = 0, j;
+	struct omap_vout_device *vout = fh;
+	struct omapvideo_info *ovid = &vout->vid_info;
+
+	if (!vout->streaming)
+		return -EINVAL;
+
+	vout->streaming = 0;
+	mask = DISPC_IRQ_VSYNC | DISPC_IRQ_EVSYNC_EVEN |
+		DISPC_IRQ_EVSYNC_ODD;
+
+	omap_dispc_unregister_isr(omap_vout_isr, vout, mask);
+
+	for (j = 0; j < ovid->num_overlays; j++) {
+		struct omap_overlay *ovl = ovid->overlays[j];
+		if (ovl->manager && ovl->manager->device) {
+			struct omap_overlay_info info;
+
+			ovl->get_overlay_info(ovl, &info);
+			info.enabled = 0;
+			ret = ovl->set_overlay_info(ovl, &info);
+			if (ret) {
+				v4l2_err(&vout->vid_dev->v4l2_dev,
+					"failed to update overlay info\n");
+				return ret;
+			}
+		}
+	}
+
+	/* Turn of the pipeline */
+	ret = omapvid_apply_changes(vout);
+	if (ret) {
+		v4l2_err(&vout->vid_dev->v4l2_dev, "failed to change mode\n");
+		return ret;
+	}
+	INIT_LIST_HEAD(&vout->dma_queue);
+	videobuf_streamoff(&vout->vbq);
+	videobuf_queue_cancel(&vout->vbq);
+
+	return 0;
+}
+
+static int vidioc_s_fbuf(struct file *file, void *fh,
+				struct v4l2_framebuffer *a)
+{
+	int enable = 0;
+	struct omap_overlay *ovl;
+	struct omapvideo_info *ovid;
+	struct omap_vout_device *vout = fh;
+	struct omap_overlay_manager_info info;
+	enum omap_dss_trans_key_type key_type = OMAP_DSS_COLOR_KEY_GFX_DST;
+
+	ovid = &vout->vid_info;
+	ovl = ovid->overlays[0];
+
+	/* OMAP DSS doesn't support Source and Destination color
+	   key together */
+	if ((a->flags & V4L2_FBUF_FLAG_SRC_CHROMAKEY) &&
+			(a->flags & V4L2_FBUF_FLAG_CHROMAKEY))
+		return -EINVAL;
+	/* OMAP DSS Doesn't support the Destination color key
+	   and alpha blending together */
+	if ((a->flags & V4L2_FBUF_FLAG_CHROMAKEY) &&
+			(a->flags & V4L2_FBUF_FLAG_LOCAL_ALPHA))
+		return -EINVAL;
+
+	if ((a->flags & V4L2_FBUF_FLAG_SRC_CHROMAKEY)) {
+		vout->fbuf.flags |= V4L2_FBUF_FLAG_SRC_CHROMAKEY;
+		key_type =  OMAP_DSS_COLOR_KEY_VID_SRC;
+	} else
+		vout->fbuf.flags &= ~V4L2_FBUF_FLAG_SRC_CHROMAKEY;
+
+	if ((a->flags & V4L2_FBUF_FLAG_CHROMAKEY)) {
+		vout->fbuf.flags |= V4L2_FBUF_FLAG_CHROMAKEY;
+		key_type =  OMAP_DSS_COLOR_KEY_GFX_DST;
+	} else
+		vout->fbuf.flags &=  ~V4L2_FBUF_FLAG_CHROMAKEY;
+
+	if (a->flags & (V4L2_FBUF_FLAG_CHROMAKEY |
+				V4L2_FBUF_FLAG_SRC_CHROMAKEY))
+		enable = 1;
+	else
+		enable = 0;
+	if (ovl->manager && ovl->manager->get_manager_info &&
+			ovl->manager->set_manager_info) {
+
+		ovl->manager->get_manager_info(ovl->manager, &info);
+		info.trans_enabled = enable;
+		info.trans_key_type = key_type;
+		info.trans_key = vout->win.chromakey;
+
+		if (ovl->manager->set_manager_info(ovl->manager, &info))
+			return -EINVAL;
+	}
+	if (a->flags & V4L2_FBUF_FLAG_LOCAL_ALPHA) {
+		vout->fbuf.flags |= V4L2_FBUF_FLAG_LOCAL_ALPHA;
+		enable = 1;
+	} else {
+		vout->fbuf.flags &= ~V4L2_FBUF_FLAG_LOCAL_ALPHA;
+		enable = 0;
+	}
+	if (ovl->manager && ovl->manager->get_manager_info &&
+			ovl->manager->set_manager_info) {
+		ovl->manager->get_manager_info(ovl->manager, &info);
+		info.alpha_enabled = enable;
+		if (ovl->manager->set_manager_info(ovl->manager, &info))
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int vidioc_g_fbuf(struct file *file, void *fh,
+		struct v4l2_framebuffer *a)
+{
+	struct omap_overlay *ovl;
+	struct omapvideo_info *ovid;
+	struct omap_vout_device *vout = fh;
+	struct omap_overlay_manager_info info;
+
+	ovid = &vout->vid_info;
+	ovl = ovid->overlays[0];
+
+	a->flags = 0x0;
+	a->capability = V4L2_FBUF_CAP_LOCAL_ALPHA | V4L2_FBUF_CAP_CHROMAKEY
+		| V4L2_FBUF_CAP_SRC_CHROMAKEY;
+
+	if (ovl->manager && ovl->manager->get_manager_info) {
+		ovl->manager->get_manager_info(ovl->manager, &info);
+		if (info.trans_key_type == OMAP_DSS_COLOR_KEY_VID_SRC)
+			a->flags |= V4L2_FBUF_FLAG_SRC_CHROMAKEY;
+		if (info.trans_key_type == OMAP_DSS_COLOR_KEY_GFX_DST)
+			a->flags |= V4L2_FBUF_FLAG_CHROMAKEY;
+	}
+	if (ovl->manager && ovl->manager->get_manager_info) {
+		ovl->manager->get_manager_info(ovl->manager, &info);
+		if (info.alpha_enabled)
+			a->flags |= V4L2_FBUF_FLAG_LOCAL_ALPHA;
+	}
+
+	return 0;
+}
+
+static const struct v4l2_ioctl_ops vout_ioctl_ops = {
+	.vidioc_querycap      			= vidioc_querycap,
+	.vidioc_enum_fmt_vid_out 		= vidioc_enum_fmt_vid_out,
+	.vidioc_g_fmt_vid_out			= vidioc_g_fmt_vid_out,
+	.vidioc_try_fmt_vid_out			= vidioc_try_fmt_vid_out,
+	.vidioc_s_fmt_vid_out			= vidioc_s_fmt_vid_out,
+	.vidioc_queryctrl    			= vidioc_queryctrl,
+	.vidioc_g_ctrl       			= vidioc_g_ctrl,
+	.vidioc_s_fbuf				= vidioc_s_fbuf,
+	.vidioc_g_fbuf				= vidioc_g_fbuf,
+	.vidioc_s_ctrl       			= vidioc_s_ctrl,
+	.vidioc_try_fmt_vid_overlay 		= vidioc_try_fmt_vid_overlay,
+	.vidioc_s_fmt_vid_overlay		= vidioc_s_fmt_vid_overlay,
+	.vidioc_enum_fmt_vid_overlay		= vidioc_enum_fmt_vid_overlay,
+	.vidioc_g_fmt_vid_overlay		= vidioc_g_fmt_vid_overlay,
+	.vidioc_cropcap				= vidioc_cropcap,
+	.vidioc_g_crop				= vidioc_g_crop,
+	.vidioc_s_crop				= vidioc_s_crop,
+	.vidioc_reqbufs				= vidioc_reqbufs,
+	.vidioc_querybuf			= vidioc_querybuf,
+	.vidioc_qbuf				= vidioc_qbuf,
+	.vidioc_dqbuf				= vidioc_dqbuf,
+	.vidioc_streamon			= vidioc_streamon,
+	.vidioc_streamoff			= vidioc_streamoff,
+};
+
+static const struct v4l2_file_operations omap_vout_fops = {
+	.owner 		= THIS_MODULE,
+	.ioctl 		= video_ioctl2,
+	.mmap 		= omap_vout_mmap,
+	.open 		= omap_vout_open,
+	.release 	= omap_vout_release,
+};
+
+/* Init functions used during driver intitalization */
+/* Initial setup of video_data */
+static int __init omap_vout_setup_video_data(struct omap_vout_device *vout)
+{
+	struct video_device *vfd;
+	struct v4l2_pix_format *pix;
+	struct v4l2_control *control;
+	struct omap_dss_device *display =
+		vout->vid_info.overlays[0]->manager->device;
+
+	/* set the default pix */
+	pix = &vout->pix;
+
+	/* Set the default picture of QVGA  */
+	pix->width = QQVGA_WIDTH;
+	pix->height = QQVGA_HEIGHT;
+
+	/* Default pixel format is RGB 5-6-5 */
+	pix->pixelformat = V4L2_PIX_FMT_RGB565;
+	pix->field = V4L2_FIELD_ANY;
+	pix->bytesperline = pix->width * 2;
+	pix->sizeimage = pix->bytesperline * pix->height;
+	pix->priv = 0;
+	pix->colorspace = V4L2_COLORSPACE_JPEG;
+
+	vout->bpp = RGB565_BPP;
+	vout->fbuf.fmt.width  =  display->panel.timings.x_res;
+	vout->fbuf.fmt.height =  display->panel.timings.y_res;
+
+	/* Set the data structures for the overlay parameters*/
+	vout->win.global_alpha = 255;
+	vout->fbuf.flags = 0;
+	vout->fbuf.capability = V4L2_FBUF_CAP_LOCAL_ALPHA |
+		V4L2_FBUF_CAP_SRC_CHROMAKEY | V4L2_FBUF_CAP_CHROMAKEY;
+	vout->win.chromakey = 0;
+
+	omap_vout_new_format(pix, &vout->fbuf, &vout->crop, &vout->win);
+
+	/*Initialize the control variables for
+	  rotation, flipping and background color. */
+	control = vout->control;
+	control[0].id = V4L2_CID_ROTATE;
+	control[0].value = 0;
+	vout->rotation = 0;
+	vout->mirror = 0;
+	vout->control[2].id = V4L2_CID_HFLIP;
+	vout->control[2].value = 0;
+	vout->vrfb_bpp = 2;
+
+	control[1].id = V4L2_CID_BG_COLOR;
+	control[1].value = 0;
+
+	/* initialize the video_device struct */
+	vfd = vout->vfd = video_device_alloc();
+
+	if (!vfd) {
+		printk(KERN_ERR VOUT_NAME ": could not allocate"
+				" video device struct\n");
+		return -ENOMEM;
+	}
+	vfd->release = video_device_release;
+	vfd->ioctl_ops = &vout_ioctl_ops;
+
+	strlcpy(vfd->name, VOUT_NAME, sizeof(vfd->name));
+	vfd->vfl_type = VFL_TYPE_GRABBER;
+
+	/* need to register for a VID_HARDWARE_* ID in videodev.h */
+	vfd->fops = &omap_vout_fops;
+	mutex_init(&vout->lock);
+
+	vfd->minor = -1;
+	return 0;
+
+}
+
+/* Setup video buffers */
+static int __init omap_vout_setup_video_bufs(struct platform_device *pdev,
+		int vid_num)
+{
+	u32 numbuffers;
+	int ret = 0, i, j;
+	int image_width, image_height;
+	struct video_device *vfd;
+	struct omap_vout_device *vout;
+	int static_vrfb_allocation = 0, vrfb_num_bufs = 4;
+	struct v4l2_device *v4l2_dev = platform_get_drvdata(pdev);
+	struct omap2video_device *vid_dev =
+		container_of(v4l2_dev, struct omap2video_device, v4l2_dev);
+
+	vout = vid_dev->vouts[vid_num];
+	vfd = vout->vfd;
+
+	numbuffers = (vid_num == 0) ? video1_numbuffers : video2_numbuffers;
+	vout->buffer_size = (vid_num == 0) ? video1_bufsize : video2_bufsize;
+	dev_info(&pdev->dev, "Buffer Size = %d\n", vout->buffer_size);
+
+	for (i = 0; i < numbuffers; i++) {
+		vout->buf_virt_addr[i] =
+			omap_vout_alloc_buffer(vout->buffer_size,
+					(u32 *) &vout->buf_phy_addr[i]);
+		if (!vout->buf_virt_addr[i]) {
+			numbuffers = i;
+			ret = -ENOMEM;
+			goto free_buffers;
+		}
+	}
+
+	for (i = 0; i < 4; i++) {
+		if (omap_vrfb_request_ctx(&vout->vrfb_context[i])) {
+			dev_info(&pdev->dev, ": VRFB allocation failed\n");
+			for (j = 0; j < i; j++)
+				omap_vrfb_release_ctx(&vout->vrfb_context[j]);
+			ret = -ENOMEM;
+			goto free_buffers;
+		}
+	}
+	vout->cropped_offset = 0;
+
+	/* Calculate VRFB memory size */
+	/* allocate for worst case size */
+	image_width = VID_MAX_WIDTH / TILE_SIZE;
+	if (VID_MAX_WIDTH % TILE_SIZE)
+		image_width++;
+
+	image_width = image_width * TILE_SIZE;
+	image_height = VID_MAX_HEIGHT / TILE_SIZE;
+
+	if (VID_MAX_HEIGHT % TILE_SIZE)
+		image_height++;
+
+	image_height = image_height * TILE_SIZE;
+	vout->smsshado_size = PAGE_ALIGN(image_width * image_height * 2 * 2);
+
+	/*
+	 * Request and Initialize DMA, for DMA based VRFB transfer
+	 */
+	vout->vrfb_dma_tx.dev_id = OMAP_DMA_NO_DEVICE;
+	vout->vrfb_dma_tx.dma_ch = -1;
+	vout->vrfb_dma_tx.req_status = DMA_CHAN_ALLOTED;
+	ret = omap_request_dma(vout->vrfb_dma_tx.dev_id, "VRFB DMA TX",
+			omap_vout_vrfb_dma_tx_callback,
+			(void *) &vout->vrfb_dma_tx, &vout->vrfb_dma_tx.dma_ch);
+	if (ret < 0) {
+		vout->vrfb_dma_tx.req_status = DMA_CHAN_NOT_ALLOTED;
+		dev_info(&pdev->dev, ": failed to allocate DMA Channel for"
+				" video%d\n", vfd->minor);
+	}
+	init_waitqueue_head(&vout->vrfb_dma_tx.wait);
+
+	/* Allocate VRFB buffers if selected through bootargs */
+	static_vrfb_allocation = (vid_num == 0) ?
+		vid1_static_vrfb_alloc : vid2_static_vrfb_alloc;
+
+	/* statically allocated the VRFB buffer is done through
+	   commands line aruments */
+	if (static_vrfb_allocation) {
+		if (omap_vout_allocate_vrfb_buffers(vout, &vrfb_num_bufs, -1)) {
+			ret =  -ENOMEM;
+			goto release_vrfb_ctx;;
+		}
+		vout->vrfb_static_allocation = 1;
+	}
+	return 0;
+
+release_vrfb_ctx:
+	for (j = 0; j < 4; j++)
+		omap_vrfb_release_ctx(&vout->vrfb_context[j]);
+
+free_buffers:
+	for (i = 0; i < numbuffers; i++) {
+		omap_vout_free_buffer(vout->buf_virt_addr[i],
+						vout->buffer_size);
+		vout->buf_virt_addr[i] = 0;
+		vout->buf_phy_addr[i] = 0;
+	}
+	return ret;
+
+}
+
+/* Create video out devices */
+static int __init omap_vout_create_video_devices(struct platform_device *pdev)
+{
+	int ret = 0, k;
+	struct omap_vout_device *vout;
+	struct video_device *vfd = NULL;
+	struct v4l2_device *v4l2_dev = platform_get_drvdata(pdev);
+
+	struct omap2video_device *vid_dev = container_of(v4l2_dev,
+			struct omap2video_device, v4l2_dev);
+
+	for (k = 0; k < pdev->num_resources; k++) {
+
+		vout = kmalloc(sizeof(struct omap_vout_device), GFP_KERNEL);
+		if (!vout) {
+			dev_err(&pdev->dev, ": could not allocate memory\n");
+			return -ENOMEM;
+		}
+		memset(vout, 0, sizeof(struct omap_vout_device));
+
+		vout->vid = k;
+		vid_dev->vouts[k] = vout;
+		vout->vid_dev = vid_dev;
+		/* Select video2 if only 1 overlay is controlled by V4L2 */
+		if (pdev->num_resources == 1)
+			vout->vid_info.overlays[0] = vid_dev->overlays[k + 2];
+		else
+			/* Else select video1 and video2 one by one. */
+			vout->vid_info.overlays[0] = vid_dev->overlays[k + 1];
+		vout->vid_info.num_overlays = 1;
+		vout->vid_info.id = k + 1;
+		vid_dev->num_videos++;
+
+		/* Setup the default configuration for the video devices
+		 */
+		if (omap_vout_setup_video_data(vout) != 0) {
+			ret = -ENOMEM;
+			goto error;
+		}
+
+		/* Allocate default number of buffers for the video streaming
+		 * and reserve the VRFB space for rotation
+		 */
+		if (omap_vout_setup_video_bufs(pdev, k) != 0) {
+			ret = -ENOMEM;
+			goto error1;
+		}
+
+		/* Register the Video device with V4L2
+		 */
+		vfd = vout->vfd;
+		if (video_register_device(vfd, VFL_TYPE_GRABBER, k + 1) < 0) {
+			dev_err(&pdev->dev, ": Could not register "
+					"Video for Linux device\n");
+			vfd->minor = -1;
+			ret = -ENODEV;
+			goto error2;
+		}
+		video_set_drvdata(vfd, vout);
+
+		/* Configure the overlay structure */
+		ret = omapvid_init(vid_dev->vouts[k], 0);
+		if (!ret)
+			goto success;
+
+error2:
+		omap_vout_release_vrfb(vout);
+		omap_vout_free_buffers(vout);
+error1:
+		video_device_release(vfd);
+error:
+		kfree(vout);
+		return ret;
+
+success:
+		dev_info(&pdev->dev, ": registered and initialized"
+				" video device %d\n", vfd->minor);
+		if (k == (pdev->num_resources - 1))
+			return 0;
+	}
+
+	return -ENODEV;
+}
+/* Driver functions */
+static int omap_vout_remove(struct platform_device *pdev)
+{
+	int k;
+	struct v4l2_device *v4l2_dev = platform_get_drvdata(pdev);
+	struct omap2video_device *vid_dev = container_of(v4l2_dev, struct
+			omap2video_device, v4l2_dev);
+
+	v4l2_device_unregister(v4l2_dev);
+	for (k = 0; k < pdev->num_resources; k++)
+		omap_vout_cleanup_device(vid_dev->vouts[k]);
+
+	for (k = 0; k < vid_dev->num_displays; k++) {
+		if (vid_dev->displays[k]->state != OMAP_DSS_DISPLAY_DISABLED)
+			vid_dev->displays[k]->disable(vid_dev->displays[k]);
+
+		omap_dss_put_device(vid_dev->displays[k]);
+	}
+	kfree(vid_dev);
+	return 0;
+}
+
+static int __init omap_vout_probe(struct platform_device *pdev)
+{
+	int ret = 0, i;
+	struct omap_overlay *ovl;
+	struct omap_dss_device *dssdev = NULL;
+	struct omap_dss_device *def_display;
+	struct omap2video_device *vid_dev = NULL;
+
+	if (pdev->num_resources == 0) {
+		dev_err(&pdev->dev, "probed for an unknown device\n");
+		return -ENODEV;
+	}
+
+	vid_dev = kzalloc(sizeof(struct omap2video_device), GFP_KERNEL);
+	if (vid_dev == NULL)
+		return -ENOMEM;
+
+	vid_dev->num_displays = 0;
+	for_each_dss_dev(dssdev) {
+		omap_dss_get_device(dssdev);
+		vid_dev->displays[vid_dev->num_displays++] = dssdev;
+	}
+
+	if (vid_dev->num_displays == 0) {
+		dev_err(&pdev->dev, "no displays\n");
+		ret = -EINVAL;
+		goto probe_err0;
+	}
+
+	vid_dev->num_overlays = omap_dss_get_num_overlays();
+	for (i = 0; i < vid_dev->num_overlays; i++)
+		vid_dev->overlays[i] = omap_dss_get_overlay(i);
+
+	vid_dev->num_managers = omap_dss_get_num_overlay_managers();
+	for (i = 0; i < vid_dev->num_managers; i++)
+		vid_dev->managers[i] = omap_dss_get_overlay_manager(i);
+
+	/* Get the Video1 overlay and video2 overlay.
+	 * Setup the Display attached to that overlays
+	 */
+	for (i = 1; i < 3; i++) {
+		ovl = omap_dss_get_overlay(i);
+		if (ovl->manager && ovl->manager->device) {
+			def_display = ovl->manager->device;
+		} else {
+			dev_warn(&pdev->dev, "cannot find display\n");
+			def_display = NULL;
+		}
+		if (def_display) {
+			ret = def_display->enable(def_display);
+			if (ret) {
+				/* Here we are not considering a error
+				 *  as display may be enabled by frame
+				 *  buffer driver
+				 */
+				dev_warn(&pdev->dev,
+					"'%s' Display already enabled\n",
+					def_display->name);
+			}
+			/* set the update mode */
+			if (def_display->caps &
+					OMAP_DSS_DISPLAY_CAP_MANUAL_UPDATE) {
+#ifdef CONFIG_FB_OMAP2_FORCE_AUTO_UPDATE
+				if (def_display->enable_te)
+					def_display->enable_te(def_display, 1);
+				if (def_display->set_update_mode)
+					def_display->set_update_mode(def_display,
+							OMAP_DSS_UPDATE_AUTO);
+#else	/* MANUAL_UPDATE */
+				if (def_display->enable_te)
+					def_display->enable_te(def_display, 0);
+				if (def_display->set_update_mode)
+					def_display->set_update_mode(def_display,
+							OMAP_DSS_UPDATE_MANUAL);
+#endif
+			} else {
+				if (def_display->set_update_mode)
+					def_display->set_update_mode(def_display,
+							OMAP_DSS_UPDATE_AUTO);
+			}
+		}
+	}
+
+	if (v4l2_device_register(&pdev->dev, &vid_dev->v4l2_dev) < 0) {
+		dev_err(&pdev->dev, "v4l2_device_register failed\n");
+		ret = -ENODEV;
+		goto probe_err1;
+	}
+
+	ret = omap_vout_create_video_devices(pdev);
+	if (ret)
+		goto probe_err2;
+
+	for (i = 0; i < vid_dev->num_displays; i++) {
+		struct omap_dss_device *display = vid_dev->displays[i];
+
+		if (display->update)
+			display->update(display, 0, 0,
+					display->panel.timings.x_res,
+					display->panel.timings.y_res);
+	}
+	return 0;
+
+probe_err2:
+	v4l2_device_unregister(&vid_dev->v4l2_dev);
+probe_err1:
+	for (i = 1; i < 3; i++) {
+		def_display = NULL;
+		ovl = omap_dss_get_overlay(i);
+		if (ovl->manager && ovl->manager->device)
+			def_display = ovl->manager->device;
+
+		if (def_display)
+			def_display->disable(def_display);
+	}
+probe_err0:
+	kfree(vid_dev);
+	return ret;
+}
+
+static struct platform_driver omap_vout_driver = {
+	.driver = {
+		.name = VOUT_NAME,
+	},
+	.probe = omap_vout_probe,
+	.remove = omap_vout_remove,
+};
+
+void omap_vout_isr(void *arg, unsigned int irqstatus)
+{
+	int ret;
+	u32 addr, fid;
+	struct omap_overlay *ovl;
+	struct timeval timevalue;
+	struct omapvideo_info *ovid;
+	struct omap_dss_device *cur_display;
+	struct omap_vout_device *vout = (struct omap_vout_device *)arg;
+
+	if (!vout->streaming)
+		return;
+
+	ovid = &vout->vid_info;
+	ovl = ovid->overlays[0];
+	/* get the display device attached to the overlay */
+	if (!ovl->manager || !ovl->manager->device)
+		return;
+	cur_display = ovl->manager->device;
+
+	spin_lock(&vout->vbq_lock);
+	do_gettimeofday(&timevalue);
+	if (cur_display->type == OMAP_DISPLAY_TYPE_DPI) {
+		if (!(irqstatus & DISPC_IRQ_VSYNC))
+			goto vout_isr_err;
+
+		if (!vout->first_int && (vout->cur_frm != vout->next_frm)) {
+			vout->cur_frm->ts = timevalue;
+			vout->cur_frm->state = VIDEOBUF_DONE;
+			wake_up_interruptible(&vout->cur_frm->done);
+			vout->cur_frm = vout->next_frm;
+		}
+		vout->first_int = 0;
+		if (list_empty(&vout->dma_queue))
+			goto vout_isr_err;
+
+		vout->next_frm = list_entry(vout->dma_queue.next,
+				struct videobuf_buffer, queue);
+		list_del(&vout->next_frm->queue);
+
+		vout->next_frm->state = VIDEOBUF_ACTIVE;
+
+		addr = (unsigned long) vout->queued_buf_addr[vout->next_frm->i]
+			+ vout->cropped_offset;
+
+		/* First save the configuration in ovelray structure */
+		ret = omapvid_init(vout, addr);
+		if (ret)
+			printk(KERN_ERR VOUT_NAME
+					"failed to set overlay info\n");
+		/* Enable the pipeline and set the Go bit */
+		ret = omapvid_apply_changes(vout);
+		if (ret)
+			printk(KERN_ERR VOUT_NAME "failed to change mode\n");
+	} else {
+
+		if (vout->first_int) {
+			vout->first_int = 0;
+			goto vout_isr_err;
+		}
+		if (irqstatus & DISPC_IRQ_EVSYNC_ODD)
+			fid = 1;
+		else if (irqstatus & DISPC_IRQ_EVSYNC_EVEN)
+			fid = 0;
+		else
+			goto vout_isr_err;
+
+		vout->field_id ^= 1;
+		if (fid != vout->field_id) {
+			if (0 == fid)
+				vout->field_id = fid;
+
+			goto vout_isr_err;
+		}
+		if (0 == fid) {
+			if (vout->cur_frm == vout->next_frm)
+				goto vout_isr_err;
+
+			vout->cur_frm->ts = timevalue;
+			vout->cur_frm->state = VIDEOBUF_DONE;
+			wake_up_interruptible(&vout->cur_frm->done);
+			vout->cur_frm = vout->next_frm;
+		} else if (1 == fid) {
+			if (list_empty(&vout->dma_queue) ||
+					(vout->cur_frm != vout->next_frm))
+				goto vout_isr_err;
+
+			vout->next_frm = list_entry(vout->dma_queue.next,
+					struct videobuf_buffer, queue);
+			list_del(&vout->next_frm->queue);
+
+			vout->next_frm->state = VIDEOBUF_ACTIVE;
+			addr = (unsigned long)
+				vout->queued_buf_addr[vout->next_frm->i] +
+				vout->cropped_offset;
+			/* First save the configuration in ovelray structure */
+			ret = omapvid_init(vout, addr);
+			if (ret)
+				printk(KERN_ERR VOUT_NAME
+						"failed to set overlay info\n");
+			/* Enable the pipeline and set the Go bit */
+			ret = omapvid_apply_changes(vout);
+			if (ret)
+				printk(KERN_ERR VOUT_NAME
+						"failed to change mode\n");
+		}
+
+	}
+
+vout_isr_err:
+	spin_unlock(&vout->vbq_lock);
+}
+
+static void omap_vout_cleanup_device(struct omap_vout_device *vout)
+{
+	struct video_device *vfd;
+
+	if (!vout)
+		return;
+
+	vfd = vout->vfd;
+	if (vfd) {
+		if (vfd->minor == -1) {
+			/*
+			 * The device was never registered, so release the
+			 * video_device struct directly.
+			 */
+			video_device_release(vfd);
+		} else {
+			/*
+			 * The unregister function will release the video_device
+			 * struct as well as unregistering it.
+			 */
+			video_unregister_device(vfd);
+		}
+	}
+
+	omap_vout_release_vrfb(vout);
+	omap_vout_free_buffers(vout);
+	/* Free the VRFB buffer if allocated
+	 * init time
+	 */
+	if (vout->vrfb_static_allocation)
+		omap_vout_free_vrfb_buffers(vout);
+
+	kfree(vout);
+}
+
+static int __init omap_vout_init(void)
+{
+	if (platform_driver_register(&omap_vout_driver) != 0) {
+		printk(KERN_ERR VOUT_NAME ":Could not register Video driver\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static void omap_vout_cleanup(void)
+{
+	platform_driver_unregister(&omap_vout_driver);
+}
+
+late_initcall(omap_vout_init);
+module_exit(omap_vout_cleanup);
diff --git a/drivers/media/video/ti-media/omap_voutdef.h b/drivers/media/video/ti-media/omap_voutdef.h
new file mode 100644
index 0000000..3b2f745
--- /dev/null
+++ b/drivers/media/video/ti-media/omap_voutdef.h
@@ -0,0 +1,148 @@
+/*
+ * drivers/media/video/omap/omap_voutdef.h
+ *
+ * Copyright (C) 2009 Texas Instruments.
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2. This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+#ifndef OMAP_VOUTDEF_H
+#define OMAP_VOUTDEF_H
+
+#include <plat/display.h>
+
+#define YUYV_BPP        2
+#define RGB565_BPP      2
+#define RGB24_BPP       3
+#define RGB32_BPP       4
+#define TILE_SIZE       32
+#define YUYV_VRFB_BPP   2
+#define RGB_VRFB_BPP    1
+#define MAX_CID		3
+#define MAC_VRFB_CTXS	4
+#define MAX_VOUT_DEV	2
+#define MAX_OVLS	3
+#define MAX_DISPLAYS	3
+#define MAX_MANAGERS	3
+
+/* Enum for Rotation
+ * DSS understands rotation in 0, 1, 2, 3 context
+ * while V4L2 driver understands it as 0, 90, 180, 270
+ */
+enum dss_rotation {
+	dss_rotation_0_degree	= 0,
+	dss_rotation_90_degree	= 1,
+	dss_rotation_180_degree	= 2,
+	dss_rotation_270_degree = 3,
+};
+/*
+ * This structure is used to store the DMA transfer parameters
+ * for VRFB hidden buffer
+ */
+struct vid_vrfb_dma {
+	int dev_id;
+	int dma_ch;
+	int req_status;
+	int tx_status;
+	wait_queue_head_t wait;
+};
+
+struct omapvideo_info {
+	int id;
+	int num_overlays;
+	struct omap_overlay *overlays[MAX_OVLS];
+};
+
+struct omap2video_device {
+	struct mutex  mtx;
+
+	int state;
+
+	struct v4l2_device v4l2_dev;
+	int num_videos;
+	struct omap_vout_device *vouts[MAX_VOUT_DEV];
+
+	int num_displays;
+	struct omap_dss_device *displays[MAX_DISPLAYS];
+	int num_overlays;
+	struct omap_overlay *overlays[MAX_OVLS];
+	int num_managers;
+	struct omap_overlay_manager *managers[MAX_MANAGERS];
+};
+
+/* per-device data structure */
+struct omap_vout_device {
+
+	struct omapvideo_info vid_info;
+	struct video_device *vfd;
+	struct omap2video_device *vid_dev;
+	int vid;
+	int opened;
+
+	/* we don't allow to change image fmt/size once buffer has
+	 * been allocated
+	 */
+	int buffer_allocated;
+	/* allow to reuse previously allocated buffer which is big enough */
+	int buffer_size;
+	/* keep buffer info across opens */
+	unsigned long buf_virt_addr[VIDEO_MAX_FRAME];
+	unsigned long buf_phy_addr[VIDEO_MAX_FRAME];
+	enum omap_color_mode dss_mode;
+
+	/* we don't allow to request new buffer when old buffers are
+	 * still mmaped
+	 */
+	int mmap_count;
+
+	spinlock_t vbq_lock;		/* spinlock for videobuf queues */
+	unsigned long field_count;	/* field counter for videobuf_buffer */
+
+	/* non-NULL means streaming is in progress. */
+	bool streaming;
+
+	struct v4l2_pix_format pix;
+	struct v4l2_rect crop;
+	struct v4l2_window win;
+	struct v4l2_framebuffer fbuf;
+
+	/* Lock to protect the shared data structures in ioctl */
+	struct mutex lock;
+
+	/* V4L2 control structure for different control id */
+	struct v4l2_control control[MAX_CID];
+	enum dss_rotation rotation;
+	bool mirror;
+	int flicker_filter;
+	/* V4L2 control structure for different control id */
+
+	int bpp; /* bytes per pixel */
+	int vrfb_bpp; /* bytes per pixel with respect to VRFB */
+
+	struct vid_vrfb_dma vrfb_dma_tx;
+	unsigned int smsshado_phy_addr[MAC_VRFB_CTXS];
+	unsigned int smsshado_virt_addr[MAC_VRFB_CTXS];
+	struct vrfb vrfb_context[MAC_VRFB_CTXS];
+	bool vrfb_static_allocation;
+	unsigned int smsshado_size;
+	unsigned char pos;
+
+	int ps, vr_ps, line_length, first_int, field_id;
+	enum v4l2_memory memory;
+	struct videobuf_buffer *cur_frm, *next_frm;
+	struct list_head dma_queue;
+	u8 *queued_buf_addr[VIDEO_MAX_FRAME];
+	u32 cropped_offset;
+	s32 tv_field1_offset;
+	void *isr_handle;
+
+	/* Buffer queue variables */
+	struct omap_vout_device *vout;
+	enum v4l2_buf_type type;
+	struct videobuf_queue vbq;
+	int io_allowed;
+
+};
+#endif	/* ifndef OMAP_VOUTDEF_H */
diff --git a/drivers/media/video/ti-media/omap_voutlib.c b/drivers/media/video/ti-media/omap_voutlib.c
new file mode 100644
index 0000000..bce5072
--- /dev/null
+++ b/drivers/media/video/ti-media/omap_voutlib.c
@@ -0,0 +1,258 @@
+/*
+ * drivers/media/video/omap/omap_voutlib.c
+ *
+ * Copyright (C) 2005-2009 Texas Instruments.
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2. This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ *
+ * Based on the OMAP2 camera driver
+ * Video-for-Linux (Version 2) camera capture driver for
+ * the OMAP24xx camera controller.
+ *
+ * Author: Andy Lowe (source@mvista.com)
+ *
+ * Copyright (C) 2004 MontaVista Software, Inc.
+ * Copyright (C) 2009 Texas Instruments.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/videodev2.h>
+
+MODULE_AUTHOR("Texas Instruments.");
+MODULE_DESCRIPTION("OMAP Video library");
+MODULE_LICENSE("GPL");
+
+/* Return the default overlay cropping rectangle in crop given the image
+ * size in pix and the video display size in fbuf.  The default
+ * cropping rectangle is the largest rectangle no larger than the capture size
+ * that will fit on the display.  The default cropping rectangle is centered in
+ * the image.  All dimensions and offsets are rounded down to even numbers.
+ */
+void omap_vout_default_crop(struct v4l2_pix_format *pix,
+		  struct v4l2_framebuffer *fbuf, struct v4l2_rect *crop)
+{
+	crop->width = (pix->width < fbuf->fmt.width) ?
+		pix->width : fbuf->fmt.width;
+	crop->height = (pix->height < fbuf->fmt.height) ?
+		pix->height : fbuf->fmt.height;
+	crop->width &= ~1;
+	crop->height &= ~1;
+	crop->left = ((pix->width - crop->width) >> 1) & ~1;
+	crop->top = ((pix->height - crop->height) >> 1) & ~1;
+}
+EXPORT_SYMBOL_GPL(omap_vout_default_crop);
+
+/* Given a new render window in new_win, adjust the window to the
+ * nearest supported configuration.  The adjusted window parameters are
+ * returned in new_win.
+ * Returns zero if succesful, or -EINVAL if the requested window is
+ * impossible and cannot reasonably be adjusted.
+ */
+int omap_vout_try_window(struct v4l2_framebuffer *fbuf,
+			struct v4l2_window *new_win)
+{
+	struct v4l2_rect try_win;
+
+	/* make a working copy of the new_win rectangle */
+	try_win = new_win->w;
+
+	/* adjust the preview window so it fits on the display by clipping any
+	 * offscreen areas
+	 */
+	if (try_win.left < 0) {
+		try_win.width += try_win.left;
+		try_win.left = 0;
+	}
+	if (try_win.top < 0) {
+		try_win.height += try_win.top;
+		try_win.top = 0;
+	}
+	try_win.width = (try_win.width < fbuf->fmt.width) ?
+		try_win.width : fbuf->fmt.width;
+	try_win.height = (try_win.height < fbuf->fmt.height) ?
+		try_win.height : fbuf->fmt.height;
+	if (try_win.left + try_win.width > fbuf->fmt.width)
+		try_win.width = fbuf->fmt.width - try_win.left;
+	if (try_win.top + try_win.height > fbuf->fmt.height)
+		try_win.height = fbuf->fmt.height - try_win.top;
+	try_win.width &= ~1;
+	try_win.height &= ~1;
+
+	if (try_win.width <= 0 || try_win.height <= 0)
+		return -EINVAL;
+
+	/* We now have a valid preview window, so go with it */
+	new_win->w = try_win;
+	new_win->field = V4L2_FIELD_ANY;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(omap_vout_try_window);
+
+/* Given a new render window in new_win, adjust the window to the
+ * nearest supported configuration.  The image cropping window in crop
+ * will also be adjusted if necessary.  Preference is given to keeping the
+ * the window as close to the requested configuration as possible.  If
+ * successful, new_win, vout->win, and crop are updated.
+ * Returns zero if succesful, or -EINVAL if the requested preview window is
+ * impossible and cannot reasonably be adjusted.
+ */
+int omap_vout_new_window(struct v4l2_rect *crop,
+		struct v4l2_window *win, struct v4l2_framebuffer *fbuf,
+		struct v4l2_window *new_win)
+{
+	int err;
+
+	err = omap_vout_try_window(fbuf, new_win);
+	if (err)
+		return err;
+
+	/* update our preview window */
+	win->w = new_win->w;
+	win->field = new_win->field;
+	win->chromakey = new_win->chromakey;
+
+	/* adjust the cropping window to allow for resizing limitations */
+	if ((crop->height/win->w.height) >= 4) {
+		/* The maximum vertical downsizing ratio is 4:1 */
+		crop->height = win->w.height * 4;
+	}
+	if ((crop->width/win->w.width) >= 4) {
+		/* The maximum horizontal downsizing ratio is 4:1 */
+		crop->width = win->w.width * 4;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(omap_vout_new_window);
+
+/* Given a new cropping rectangle in new_crop, adjust the cropping rectangle to
+ * the nearest supported configuration.  The image render window in win will
+ * also be adjusted if necessary.  The preview window is adjusted such that the
+ * horizontal and vertical rescaling ratios stay constant.  If the render
+ * window would fall outside the display boundaries, the cropping rectangle
+ * will also be adjusted to maintain the rescaling ratios.  If successful, crop
+ * and win are updated.
+ * Returns zero if succesful, or -EINVAL if the requested cropping rectangle is
+ * impossible and cannot reasonably be adjusted.
+ */
+int omap_vout_new_crop(struct v4l2_pix_format *pix,
+	      struct v4l2_rect *crop, struct v4l2_window *win,
+	      struct v4l2_framebuffer *fbuf, const struct v4l2_rect *new_crop)
+{
+	struct v4l2_rect try_crop;
+	unsigned long vresize, hresize;
+
+	/* make a working copy of the new_crop rectangle */
+	try_crop = *new_crop;
+
+	/* adjust the cropping rectangle so it fits in the image */
+	if (try_crop.left < 0) {
+		try_crop.width += try_crop.left;
+		try_crop.left = 0;
+	}
+	if (try_crop.top < 0) {
+		try_crop.height += try_crop.top;
+		try_crop.top = 0;
+	}
+	try_crop.width = (try_crop.width < pix->width) ?
+		try_crop.width : pix->width;
+	try_crop.height = (try_crop.height < pix->height) ?
+		try_crop.height : pix->height;
+	if (try_crop.left + try_crop.width > pix->width)
+		try_crop.width = pix->width - try_crop.left;
+	if (try_crop.top + try_crop.height > pix->height)
+		try_crop.height = pix->height - try_crop.top;
+	try_crop.width &= ~1;
+	try_crop.height &= ~1;
+	if (try_crop.width <= 0 || try_crop.height <= 0)
+		return -EINVAL;
+
+	if (crop->height != win->w.height) {
+		/* If we're resizing vertically, we can't support a crop width
+		 * wider than 768 pixels.
+		 */
+		if (try_crop.width > 768)
+			try_crop.width = 768;
+	}
+	/* vertical resizing */
+	vresize = (1024 * crop->height) / win->w.height;
+	if (vresize > 4096)
+		vresize = 4096;
+	else if (vresize == 0)
+		vresize = 1;
+	win->w.height = ((1024 * try_crop.height) / vresize) & ~1;
+	if (win->w.height == 0)
+		win->w.height = 2;
+	if (win->w.height + win->w.top > fbuf->fmt.height) {
+		/* We made the preview window extend below the bottom of the
+		 * display, so clip it to the display boundary and resize the
+		 * cropping height to maintain the vertical resizing ratio.
+		 */
+		win->w.height = (fbuf->fmt.height - win->w.top) & ~1;
+		if (try_crop.height == 0)
+			try_crop.height = 2;
+	}
+	/* horizontal resizing */
+	hresize = (1024 * crop->width) / win->w.width;
+	if (hresize > 4096)
+		hresize = 4096;
+	else if (hresize == 0)
+		hresize = 1;
+	win->w.width = ((1024 * try_crop.width) / hresize) & ~1;
+	if (win->w.width == 0)
+		win->w.width = 2;
+	if (win->w.width + win->w.left > fbuf->fmt.width) {
+		/* We made the preview window extend past the right side of the
+		 * display, so clip it to the display boundary and resize the
+		 * cropping width to maintain the horizontal resizing ratio.
+		 */
+		win->w.width = (fbuf->fmt.width - win->w.left) & ~1;
+		if (try_crop.width == 0)
+			try_crop.width = 2;
+	}
+
+	/* Check for resizing constraints */
+	if ((try_crop.height/win->w.height) >= 4) {
+		/* The maximum vertical downsizing ratio is 4:1 */
+		try_crop.height = win->w.height * 4;
+	}
+	if ((try_crop.width/win->w.width) >= 4) {
+		/* The maximum horizontal downsizing ratio is 4:1 */
+		try_crop.width = win->w.width * 4;
+	}
+
+	/* update our cropping rectangle and we're done */
+	*crop = try_crop;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(omap_vout_new_crop);
+
+/* Given a new format in pix and fbuf,  crop and win
+ * structures are initialized to default values. crop
+ * is initialized to the largest window size that will fit on the display.  The
+ * crop window is centered in the image. win is initialized to
+ * the same size as crop and is centered on the display.
+ * All sizes and offsets are constrained to be even numbers.
+ */
+void omap_vout_new_format(struct v4l2_pix_format *pix,
+		struct v4l2_framebuffer *fbuf, struct v4l2_rect *crop,
+		struct v4l2_window *win)
+{
+	/* crop defines the preview source window in the image capture
+	 * buffer
+	 */
+	omap_vout_default_crop(pix, fbuf, crop);
+
+	/* win defines the preview target window on the display */
+	win->w.width = crop->width;
+	win->w.height = crop->height;
+	win->w.left = ((fbuf->fmt.width - win->w.width) >> 1) & ~1;
+	win->w.top = ((fbuf->fmt.height - win->w.height) >> 1) & ~1;
+}
+EXPORT_SYMBOL_GPL(omap_vout_new_format);
+
diff --git a/drivers/media/video/ti-media/omap_voutlib.h b/drivers/media/video/ti-media/omap_voutlib.h
new file mode 100644
index 0000000..8ef6e25
--- /dev/null
+++ b/drivers/media/video/ti-media/omap_voutlib.h
@@ -0,0 +1,34 @@
+/*
+ * drivers/media/video/omap/omap_voutlib.h
+ *
+ * Copyright (C) 2009 Texas Instruments.
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2. This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ *
+ */
+
+#ifndef OMAP_VOUTLIB_H
+#define OMAP_VOUTLIB_H
+
+extern void omap_vout_default_crop(struct v4l2_pix_format *pix,
+		struct v4l2_framebuffer *fbuf, struct v4l2_rect *crop);
+
+extern int omap_vout_new_crop(struct v4l2_pix_format *pix,
+		struct v4l2_rect *crop, struct v4l2_window *win,
+		struct v4l2_framebuffer *fbuf,
+		const struct v4l2_rect *new_crop);
+
+extern int omap_vout_try_window(struct v4l2_framebuffer *fbuf,
+		struct v4l2_window *new_win);
+
+extern int omap_vout_new_window(struct v4l2_rect *crop,
+		struct v4l2_window *win, struct v4l2_framebuffer *fbuf,
+		struct v4l2_window *new_win);
+
+extern void omap_vout_new_format(struct v4l2_pix_format *pix,
+		struct v4l2_framebuffer *fbuf, struct v4l2_rect *crop,
+		struct v4l2_window *win);
+#endif	/* #ifndef OMAP_LIB_H */
+
-- 
1.6.2.4

