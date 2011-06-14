Return-path: <mchehab@pedra>
Received: from devils.ext.ti.com ([198.47.26.153]:57782 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234Ab1FNGro (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2011 02:47:44 -0400
Received: from dlep33.itg.ti.com ([157.170.170.112])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id p5E6liT8024790
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 14 Jun 2011 01:47:44 -0500
Received: from dlep26.itg.ti.com (smtp-le.itg.ti.com [157.170.170.27])
	by dlep33.itg.ti.com (8.13.7/8.13.8) with ESMTP id p5E6lhEY015778
	for <linux-media@vger.kernel.org>; Tue, 14 Jun 2011 01:47:43 -0500 (CDT)
Received: from dlee73.ent.ti.com (localhost [127.0.0.1])
	by dlep26.itg.ti.com (8.13.8/8.13.8) with ESMTP id p5E6lhgf022127
	for <linux-media@vger.kernel.org>; Tue, 14 Jun 2011 01:47:43 -0500 (CDT)
From: Archit Taneja <archit@ti.com>
To: <hvaibhav@ti.com>
CC: linux-media@vger.kernel.org, Archit Taneja <archit@ti.com>
Subject: [PATCH v2 1/3] OMAP_VOUT: CLEANUP: Move generic functions and macros to common files
Date: Tue, 14 Jun 2011 12:24:45 +0530
Message-ID: <1308034487-11852-2-git-send-email-archit@ti.com>
In-Reply-To: <1308034487-11852-1-git-send-email-archit@ti.com>
References: <1308034487-11852-1-git-send-email-archit@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Move the inline functions rotate_90_or_270(), rotation_enabled(), and
calc_rotation() from omap_vout.c to omap_voutdef.h.

Move the independent functions omap_vout_alloc_buffer() and
omap_vout_free_buffer() to omap_voutlib.c.

Remove extern identifier from function definitions in omap_voutlib.h

Add static identifier to functions that are used locally in omap_vout.c

Signed-off-by: Archit Taneja <archit@ti.com>
---
 drivers/media/video/omap/omap_vout.c    |  117 +-----------------------------
 drivers/media/video/omap/omap_voutdef.h |   62 ++++++++++++++++
 drivers/media/video/omap/omap_voutlib.c |   46 ++++++++++++
 drivers/media/video/omap/omap_voutlib.h |   12 ++--
 4 files changed, 119 insertions(+), 118 deletions(-)

diff --git a/drivers/media/video/omap/omap_vout.c b/drivers/media/video/omap/omap_vout.c
index 5634097..1d4112b 100644
--- a/drivers/media/video/omap/omap_vout.c
+++ b/drivers/media/video/omap/omap_vout.c
@@ -35,17 +35,14 @@
 #include <linux/sched.h>
 #include <linux/types.h>
 #include <linux/platform_device.h>
-#include <linux/dma-mapping.h>
 #include <linux/irq.h>
 #include <linux/videodev2.h>
-#include <linux/slab.h>
 
 #include <media/videobuf-dma-contig.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 
 #include <plat/dma.h>
-#include <plat/vram.h>
 #include <plat/vrfb.h>
 #include <video/omapdss.h>
 
@@ -56,7 +53,6 @@ MODULE_AUTHOR("Texas Instruments");
 MODULE_DESCRIPTION("OMAP Video for Linux Video out driver");
 MODULE_LICENSE("GPL");
 
-
 /* Driver Configuration macros */
 #define VOUT_NAME		"omap_vout"
 
@@ -65,31 +61,6 @@ enum omap_vout_channels {
 	OMAP_VIDEO2,
 };
 
-enum dma_channel_state {
-	DMA_CHAN_NOT_ALLOTED,
-	DMA_CHAN_ALLOTED,
-};
-
-#define QQVGA_WIDTH		160
-#define QQVGA_HEIGHT		120
-
-/* Max Resolution supported by the driver */
-#define VID_MAX_WIDTH		1280	/* Largest width */
-#define VID_MAX_HEIGHT		720	/* Largest height */
-
-/* Mimimum requirement is 2x2 for DSS */
-#define VID_MIN_WIDTH		2
-#define VID_MIN_HEIGHT		2
-
-/* 2048 x 2048 is max res supported by OMAP display controller */
-#define MAX_PIXELS_PER_LINE     2048
-
-#define VRFB_TX_TIMEOUT         1000
-#define VRFB_NUM_BUFS		4
-
-/* Max buffer size tobe allocated during init */
-#define OMAP_VOUT_MAX_BUF_SIZE (VID_MAX_WIDTH*VID_MAX_HEIGHT*4)
-
 static struct videobuf_queue_ops video_vbq_ops;
 /* Variables configurable through module params*/
 static u32 video1_numbuffers = 3;
@@ -172,49 +143,6 @@ const static struct v4l2_fmtdesc omap_formats[] = {
 #define NUM_OUTPUT_FORMATS (ARRAY_SIZE(omap_formats))
 
 /*
- * Allocate buffers
- */
-static unsigned long omap_vout_alloc_buffer(u32 buf_size, u32 *phys_addr)
-{
-	u32 order, size;
-	unsigned long virt_addr, addr;
-
-	size = PAGE_ALIGN(buf_size);
-	order = get_order(size);
-	virt_addr = __get_free_pages(GFP_KERNEL, order);
-	addr = virt_addr;
-
-	if (virt_addr) {
-		while (size > 0) {
-			SetPageReserved(virt_to_page(addr));
-			addr += PAGE_SIZE;
-			size -= PAGE_SIZE;
-		}
-	}
-	*phys_addr = (u32) virt_to_phys((void *) virt_addr);
-	return virt_addr;
-}
-
-/*
- * Free buffers
- */
-static void omap_vout_free_buffer(unsigned long virtaddr, u32 buf_size)
-{
-	u32 order, size;
-	unsigned long addr = virtaddr;
-
-	size = PAGE_ALIGN(buf_size);
-	order = get_order(size);
-
-	while (size > 0) {
-		ClearPageReserved(virt_to_page(addr));
-		addr += PAGE_SIZE;
-		size -= PAGE_SIZE;
-	}
-	free_pages((unsigned long) virtaddr, order);
-}
-
-/*
  * Function for allocating video buffers
  */
 static int omap_vout_allocate_vrfb_buffers(struct omap_vout_device *vout,
@@ -369,43 +297,6 @@ static void omap_vout_release_vrfb(struct omap_vout_device *vout)
 }
 
 /*
- * Return true if rotation is 90 or 270
- */
-static inline int rotate_90_or_270(const struct omap_vout_device *vout)
-{
-	return (vout->rotation == dss_rotation_90_degree ||
-			vout->rotation == dss_rotation_270_degree);
-}
-
-/*
- * Return true if rotation is enabled
- */
-static inline int rotation_enabled(const struct omap_vout_device *vout)
-{
-	return vout->rotation || vout->mirror;
-}
-
-/*
- * Reverse the rotation degree if mirroring is enabled
- */
-static inline int calc_rotation(const struct omap_vout_device *vout)
-{
-	if (!vout->mirror)
-		return vout->rotation;
-
-	switch (vout->rotation) {
-	case dss_rotation_90_degree:
-		return dss_rotation_270_degree;
-	case dss_rotation_270_degree:
-		return dss_rotation_90_degree;
-	case dss_rotation_180_degree:
-		return dss_rotation_0_degree;
-	default:
-		return dss_rotation_180_degree;
-	}
-}
-
-/*
  * Free the V4L2 buffers
  */
 static void omap_vout_free_buffers(struct omap_vout_device *vout)
@@ -664,7 +555,7 @@ static int video_mode_to_dss_mode(struct omap_vout_device *vout)
 /*
  * Setup the overlay
  */
-int omapvid_setup_overlay(struct omap_vout_device *vout,
+static int omapvid_setup_overlay(struct omap_vout_device *vout,
 		struct omap_overlay *ovl, int posx, int posy, int outw,
 		int outh, u32 addr)
 {
@@ -744,7 +635,7 @@ setup_ovl_err:
 /*
  * Initialize the overlay structure
  */
-int omapvid_init(struct omap_vout_device *vout, u32 addr)
+static int omapvid_init(struct omap_vout_device *vout, u32 addr)
 {
 	int ret = 0, i;
 	struct v4l2_window *win;
@@ -809,7 +700,7 @@ omapvid_init_err:
 /*
  * Apply the changes set the go bit of DSS
  */
-int omapvid_apply_changes(struct omap_vout_device *vout)
+static int omapvid_apply_changes(struct omap_vout_device *vout)
 {
 	int i;
 	struct omap_overlay *ovl;
@@ -825,7 +716,7 @@ int omapvid_apply_changes(struct omap_vout_device *vout)
 	return 0;
 }
 
-void omap_vout_isr(void *arg, unsigned int irqstatus)
+static void omap_vout_isr(void *arg, unsigned int irqstatus)
 {
 	int ret;
 	u32 addr, fid;
diff --git a/drivers/media/video/omap/omap_voutdef.h b/drivers/media/video/omap/omap_voutdef.h
index 659497b..31e6261 100644
--- a/drivers/media/video/omap/omap_voutdef.h
+++ b/drivers/media/video/omap/omap_voutdef.h
@@ -27,6 +27,31 @@
 #define MAX_DISPLAYS	3
 #define MAX_MANAGERS	3
 
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
+#define VRFB_NUM_BUFS		4
+
+/* Max buffer size tobe allocated during init */
+#define OMAP_VOUT_MAX_BUF_SIZE (VID_MAX_WIDTH*VID_MAX_HEIGHT*4)
+
+enum dma_channel_state {
+	DMA_CHAN_NOT_ALLOTED,
+	DMA_CHAN_ALLOTED,
+};
+
 /* Enum for Rotation
  * DSS understands rotation in 0, 1, 2, 3 context
  * while V4L2 driver understands it as 0, 90, 180, 270
@@ -144,4 +169,41 @@ struct omap_vout_device {
 	int io_allowed;
 
 };
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
 #endif	/* ifndef OMAP_VOUTDEF_H */
diff --git a/drivers/media/video/omap/omap_voutlib.c b/drivers/media/video/omap/omap_voutlib.c
index 2aa6a76..ca96326 100644
--- a/drivers/media/video/omap/omap_voutlib.c
+++ b/drivers/media/video/omap/omap_voutlib.c
@@ -24,8 +24,12 @@
 #include <linux/types.h>
 #include <linux/videodev2.h>
 
+#include <linux/dma-mapping.h>
+
 #include <plat/cpu.h>
 
+#include "omap_voutlib.h"
+
 MODULE_AUTHOR("Texas Instruments");
 MODULE_DESCRIPTION("OMAP Video library");
 MODULE_LICENSE("GPL");
@@ -291,3 +295,45 @@ void omap_vout_new_format(struct v4l2_pix_format *pix,
 }
 EXPORT_SYMBOL_GPL(omap_vout_new_format);
 
+/*
+ * Allocate buffers
+ */
+unsigned long omap_vout_alloc_buffer(u32 buf_size, u32 *phys_addr)
+{
+	u32 order, size;
+	unsigned long virt_addr, addr;
+
+	size = PAGE_ALIGN(buf_size);
+	order = get_order(size);
+	virt_addr = __get_free_pages(GFP_KERNEL, order);
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
+void omap_vout_free_buffer(unsigned long virtaddr, u32 buf_size)
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
diff --git a/drivers/media/video/omap/omap_voutlib.h b/drivers/media/video/omap/omap_voutlib.h
index a60b16e..e51750a 100644
--- a/drivers/media/video/omap/omap_voutlib.h
+++ b/drivers/media/video/omap/omap_voutlib.h
@@ -12,23 +12,25 @@
 #ifndef OMAP_VOUTLIB_H
 #define OMAP_VOUTLIB_H
 
-extern void omap_vout_default_crop(struct v4l2_pix_format *pix,
+void omap_vout_default_crop(struct v4l2_pix_format *pix,
 		struct v4l2_framebuffer *fbuf, struct v4l2_rect *crop);
 
-extern int omap_vout_new_crop(struct v4l2_pix_format *pix,
+int omap_vout_new_crop(struct v4l2_pix_format *pix,
 		struct v4l2_rect *crop, struct v4l2_window *win,
 		struct v4l2_framebuffer *fbuf,
 		const struct v4l2_rect *new_crop);
 
-extern int omap_vout_try_window(struct v4l2_framebuffer *fbuf,
+int omap_vout_try_window(struct v4l2_framebuffer *fbuf,
 		struct v4l2_window *new_win);
 
-extern int omap_vout_new_window(struct v4l2_rect *crop,
+int omap_vout_new_window(struct v4l2_rect *crop,
 		struct v4l2_window *win, struct v4l2_framebuffer *fbuf,
 		struct v4l2_window *new_win);
 
-extern void omap_vout_new_format(struct v4l2_pix_format *pix,
+void omap_vout_new_format(struct v4l2_pix_format *pix,
 		struct v4l2_framebuffer *fbuf, struct v4l2_rect *crop,
 		struct v4l2_window *win);
+unsigned long omap_vout_alloc_buffer(u32 buf_size, u32 *phys_addr);
+void omap_vout_free_buffer(unsigned long virtaddr, u32 buf_size);
 #endif	/* #ifndef OMAP_VOUTLIB_H */
 
-- 
1.7.1

