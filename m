Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:56497 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757908AbZA3XqB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jan 2009 18:46:01 -0500
From: Dominic Curran <dcurran@ti.com>
To: linux-media@vger.kernel.org,
	"linux-omap" <linux-omap@vger.kernel.org>
Subject: [OMAPZOOM][PATCH v2 2/6] Increase isp workaround buffer size for 8MP sensor.
Date: Fri, 30 Jan 2009 17:45:54 -0600
Cc: greg.hofer@hp.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901301745.54348.dcurran@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Dominic Curran <dcurran@ti.com>
Subject: [OMAPZOOM][PATCH v2 2/6] Increase isp workaround buffer size for 8MP 
sensor.

A temporary buffer is created to hold the image while it is written by
Previewer module and then read by Resizer module. This is called LSC
Workaround. To take into account the Sony IMX046 8MP sensor that buffer
needs to be increased in size.
Changed the #defines to be upper case.
Patch also fixes the initialization of a couple of CCDC values.

Signed-off-by: Dominic Curran <dcurran@ti.com>
---
 drivers/media/video/isp/isp.c     |   10 +++++-----
 drivers/media/video/isp/isp.h     |    7 +++++--
 drivers/media/video/isp/ispccdc.c |    2 ++
 drivers/media/video/isp/ispmmu.h  |    3 +++
 4 files changed, 15 insertions(+), 7 deletions(-)

Index: omapzoom04/drivers/media/video/isp/isp.c
===================================================================
--- omapzoom04.orig/drivers/media/video/isp/isp.c
+++ omapzoom04/drivers/media/video/isp/isp.c
@@ -1172,20 +1172,20 @@ void omapisp_unset_callback()
  **/
 u32 isp_buf_allocation(void)
 {
-	buff_addr = (void *) vmalloc(buffer_size);
+	buff_addr = (void *) vmalloc(ISP_BUFFER_MAX_SIZE);
 
 	if (!buff_addr) {
 		printk(KERN_ERR "Cannot allocate memory ");
 		return -ENOMEM;
 	}
 
-	sglist_alloc = videobuf_vmalloc_to_sg(buff_addr, no_of_pages);
+	sglist_alloc = videobuf_vmalloc_to_sg(buff_addr, ISP_BUFFER_MAX_PAGES);
 	if (!sglist_alloc) {
 		printk(KERN_ERR "videobuf_vmalloc_to_sg error");
 		return -ENOMEM;
 	}
-	num_sc = dma_map_sg(NULL, sglist_alloc, no_of_pages, 1);
-	buff_addr_mapped = ispmmu_map_sg(sglist_alloc, no_of_pages);
+	num_sc = dma_map_sg(NULL, sglist_alloc, ISP_BUFFER_MAX_PAGES, 1);
+	buff_addr_mapped = ispmmu_map_sg(sglist_alloc, ISP_BUFFER_MAX_PAGES);
 	if (!buff_addr_mapped) {
 		printk(KERN_ERR "ispmmu_map_sg mapping failed ");
 		return -ENOMEM;
@@ -1217,7 +1217,7 @@ void isp_buf_free(void)
 {
 	if (alloc_done == 1) {
 		ispmmu_unmap(buff_addr_mapped);
-		dma_unmap_sg(NULL, sglist_alloc, no_of_pages, 1);
+		dma_unmap_sg(NULL, sglist_alloc, ISP_BUFFER_MAX_PAGES, 1);
 		kfree(sglist_alloc);
 		vfree(buff_addr);
 		alloc_done = 0;
Index: omapzoom04/drivers/media/video/isp/isp.h
===================================================================
--- omapzoom04.orig/drivers/media/video/isp/isp.h
+++ omapzoom04/drivers/media/video/isp/isp.h
@@ -26,6 +26,9 @@
 #define OMAP_ISP_TOP_H
 #include <media/videobuf-dma-sg.h>
 #include <linux/videodev2.h>
+
+#include "ispmmu.h"
+
 #define OMAP_ISP_CCDC		(1 << 0)
 #define OMAP_ISP_PREVIEW	(1 << 1)
 #define OMAP_ISP_RESIZER	(1 << 2)
@@ -69,8 +72,8 @@
 #define NUM_ISP_CAPTURE_FORMATS 	(sizeof(isp_formats) /\
 							sizeof(isp_formats[0]))
 #define ISP_WORKAROUND 1
-#define buffer_size (1024 * 1024 * 10)
-#define no_of_pages (buffer_size / (4 * 1024))
+#define ISP_BUFFER_MAX_SIZE (1024 * 1024 * 16)
+#define ISP_BUFFER_MAX_PAGES (ISP_BUFFER_MAX_SIZE / ISPMMU_PAGE_SIZE)
 
 typedef int (*isp_vbq_callback_ptr) (struct videobuf_buffer *vb);
 typedef void (*isp_callback_t) (unsigned long status,
Index: omapzoom04/drivers/media/video/isp/ispccdc.c
===================================================================
--- omapzoom04.orig/drivers/media/video/isp/ispccdc.c
+++ omapzoom04/drivers/media/video/isp/ispccdc.c
@@ -1265,6 +1265,8 @@ int ispccdc_config_size(u32 input_w, u32
 	}
 
 	if (ispccdc_obj.ccdc_outfmt == CCDC_OTHERS_VP) {
+		ispccdc_obj.ccdcin_woffset = 0;
+		ispccdc_obj.ccdcin_hoffset = 0;
 		omap_writel((ispccdc_obj.ccdcin_woffset <<
 					ISPCCDC_FMT_HORZ_FMTSPH_SHIFT) |
 					(ispccdc_obj.ccdcin_w <<
Index: omapzoom04/drivers/media/video/isp/ispmmu.h
===================================================================
--- omapzoom04.orig/drivers/media/video/isp/ispmmu.h
+++ omapzoom04/drivers/media/video/isp/ispmmu.h
@@ -59,6 +59,9 @@
 /* Number of entries per L2 Page table */
 #define ISPMMU_L2D_ENTRIES_NR		256
 
+/* Size of MMU page in bytes */
+#define ISPMMU_PAGE_SIZE		4096
+
 /*
  * Statically allocate 16KB for L2 page tables. 16KB can be used for
  * up to 16 L2 page tables which cover up to 16MB space. We use an array of 16
