Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0U0rrnj032175
	for <video4linux-list@redhat.com>; Thu, 29 Jan 2009 19:53:53 -0500
Received: from bear.ext.ti.com (bear.ext.ti.com [192.94.94.41])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0U0rbTj014643
	for <video4linux-list@redhat.com>; Thu, 29 Jan 2009 19:53:37 -0500
From: Dominic Curran <dcurran@ti.com>
To: "linux-omap" <linux-omap@vger.kernel.org>, video4linux-list@redhat.com
Date: Thu, 29 Jan 2009 18:53:31 -0600
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901291853.31318.dcurran@ti.com>
Cc: greg.hofer@hp.com
Subject: [OMAPZOOM][PATCH 2/6] Increase isp workaround buffer size for 8MP
	sensor.
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

From: Dominic Curran <dcurran@ti.com>
Subject: [OMAPZOOM][PATCH 2/6] Increase isp workaround buffer size for 8MP 
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
 drivers/media/video/isp/isp.h     |    4 ++--
 drivers/media/video/isp/ispccdc.c |    2 ++
 3 files changed, 9 insertions(+), 7 deletions(-)

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
@@ -69,8 +69,8 @@
 #define NUM_ISP_CAPTURE_FORMATS 	(sizeof(isp_formats) /\
 							sizeof(isp_formats[0]))
 #define ISP_WORKAROUND 1
-#define buffer_size (1024 * 1024 * 10)
-#define no_of_pages (buffer_size / (4 * 1024))
+#define ISP_BUFFER_MAX_SIZE (1024 * 1024 * 16)
+#define ISP_BUFFER_MAX_PAGES (ISP_BUFFER_MAX_SIZE / (4 * 1024))
 
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

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
