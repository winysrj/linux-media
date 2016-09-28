Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([198.47.19.11]:58034 "EHLO bear.ext.ti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754268AbcI1VQx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Sep 2016 17:16:53 -0400
From: Benoit Parrot <bparrot@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Benoit Parrot <bparrot@ti.com>
Subject: [Patch 01/35] media: ti-vpe: vpdma: Make vpdma library into its own module
Date: Wed, 28 Sep 2016 16:16:09 -0500
Message-ID: <20160928211643.26298-2-bparrot@ti.com>
In-Reply-To: <20160928211643.26298-1-bparrot@ti.com>
References: <20160928211643.26298-1-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The VPDMA (Video Port DMA) as found in devices such as DRA7xx is
used for both the Video Processing Engine (VPE) and the Video Input
Port (VIP).

In preparation for this we need to turn vpdma into its own
kernel module.

Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
 drivers/media/platform/Kconfig         |  6 ++++++
 drivers/media/platform/ti-vpe/Makefile |  4 +++-
 drivers/media/platform/ti-vpe/vpdma.c  | 28 +++++++++++++++++++++++++++-
 3 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index f98ed3fd0efd..3c15c5a53bd5 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -334,6 +334,7 @@ config VIDEO_TI_VPE
 	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
+	select VIDEO_TI_VPDMA
 	default n
 	---help---
 	  Support for the TI VPE(Video Processing Engine) block
@@ -347,6 +348,11 @@ config VIDEO_TI_VPE_DEBUG
 
 endif # V4L_MEM2MEM_DRIVERS
 
+# TI VIDEO PORT Helper Modules
+# These will be selected by VPE and VIP
+config VIDEO_TI_VPDMA
+	tristate
+
 menuconfig V4L_TEST_DRIVERS
 	bool "Media test drivers"
 	depends on MEDIA_CAMERA_SUPPORT
diff --git a/drivers/media/platform/ti-vpe/Makefile b/drivers/media/platform/ti-vpe/Makefile
index e236059a60ad..faca5e115c1d 100644
--- a/drivers/media/platform/ti-vpe/Makefile
+++ b/drivers/media/platform/ti-vpe/Makefile
@@ -1,6 +1,8 @@
 obj-$(CONFIG_VIDEO_TI_VPE) += ti-vpe.o
+obj-$(CONFIG_VIDEO_TI_VPDMA) += ti-vpdma.o
 
-ti-vpe-y := vpe.o sc.o csc.o vpdma.o
+ti-vpe-y := vpe.o sc.o csc.o
+ti-vpdma-y := vpdma.o
 
 ccflags-$(CONFIG_VIDEO_TI_VPE_DEBUG) += -DDEBUG
 
diff --git a/drivers/media/platform/ti-vpe/vpdma.c b/drivers/media/platform/ti-vpe/vpdma.c
index 3e2e3a33e6ed..e55cb58213bf 100644
--- a/drivers/media/platform/ti-vpe/vpdma.c
+++ b/drivers/media/platform/ti-vpe/vpdma.c
@@ -75,6 +75,7 @@ const struct vpdma_data_format vpdma_yuv_fmts[] = {
 		.depth		= 16,
 	},
 };
+EXPORT_SYMBOL(vpdma_yuv_fmts);
 
 const struct vpdma_data_format vpdma_rgb_fmts[] = {
 	[VPDMA_DATA_FMT_RGB565] = {
@@ -178,6 +179,7 @@ const struct vpdma_data_format vpdma_rgb_fmts[] = {
 		.depth		= 32,
 	},
 };
+EXPORT_SYMBOL(vpdma_rgb_fmts);
 
 const struct vpdma_data_format vpdma_misc_fmts[] = {
 	[VPDMA_DATA_FMT_MV] = {
@@ -186,6 +188,7 @@ const struct vpdma_data_format vpdma_misc_fmts[] = {
 		.depth		= 4,
 	},
 };
+EXPORT_SYMBOL(vpdma_misc_fmts);
 
 struct vpdma_channel_info {
 	int num;		/* VPDMA channel number */
@@ -317,6 +320,7 @@ void vpdma_dump_regs(struct vpdma_data *vpdma)
 	DUMPREG(VIP_UP_UV_CSTAT);
 	DUMPREG(VPI_CTL_CSTAT);
 }
+EXPORT_SYMBOL(vpdma_dump_regs);
 
 /*
  * Allocate a DMA buffer
@@ -333,6 +337,7 @@ int vpdma_alloc_desc_buf(struct vpdma_buf *buf, size_t size)
 
 	return 0;
 }
+EXPORT_SYMBOL(vpdma_alloc_desc_buf);
 
 void vpdma_free_desc_buf(struct vpdma_buf *buf)
 {
@@ -341,6 +346,7 @@ void vpdma_free_desc_buf(struct vpdma_buf *buf)
 	buf->addr = NULL;
 	buf->size = 0;
 }
+EXPORT_SYMBOL(vpdma_free_desc_buf);
 
 /*
  * map descriptor/payload DMA buffer, enabling DMA access
@@ -361,6 +367,7 @@ int vpdma_map_desc_buf(struct vpdma_data *vpdma, struct vpdma_buf *buf)
 
 	return 0;
 }
+EXPORT_SYMBOL(vpdma_map_desc_buf);
 
 /*
  * unmap descriptor/payload DMA buffer, disabling DMA access and
@@ -375,6 +382,7 @@ void vpdma_unmap_desc_buf(struct vpdma_data *vpdma, struct vpdma_buf *buf)
 
 	buf->mapped = false;
 }
+EXPORT_SYMBOL(vpdma_unmap_desc_buf);
 
 /*
  * create a descriptor list, the user of this list will append configuration,
@@ -396,6 +404,7 @@ int vpdma_create_desc_list(struct vpdma_desc_list *list, size_t size, int type)
 
 	return 0;
 }
+EXPORT_SYMBOL(vpdma_create_desc_list);
 
 /*
  * once a descriptor list is parsed by VPDMA, we reset the list by emptying it,
@@ -405,6 +414,7 @@ void vpdma_reset_desc_list(struct vpdma_desc_list *list)
 {
 	list->next = list->buf.addr;
 }
+EXPORT_SYMBOL(vpdma_reset_desc_list);
 
 /*
  * free the buffer allocated fot the VPDMA descriptor list, this should be
@@ -416,11 +426,13 @@ void vpdma_free_desc_list(struct vpdma_desc_list *list)
 
 	list->next = NULL;
 }
+EXPORT_SYMBOL(vpdma_free_desc_list);
 
-static bool vpdma_list_busy(struct vpdma_data *vpdma, int list_num)
+bool vpdma_list_busy(struct vpdma_data *vpdma, int list_num)
 {
 	return read_reg(vpdma, VPDMA_LIST_STAT_SYNC) & BIT(list_num + 16);
 }
+EXPORT_SYMBOL(vpdma_list_busy);
 
 /*
  * submit a list of DMA descriptors to the VPE VPDMA, do not wait for completion
@@ -446,6 +458,7 @@ int vpdma_submit_descs(struct vpdma_data *vpdma, struct vpdma_desc_list *list)
 
 	return 0;
 }
+EXPORT_SYMBOL(vpdma_submit_descs);
 
 static void dump_cfd(struct vpdma_cfd *cfd)
 {
@@ -498,6 +511,7 @@ void vpdma_add_cfd_block(struct vpdma_desc_list *list, int client,
 
 	dump_cfd(cfd);
 }
+EXPORT_SYMBOL(vpdma_add_cfd_block);
 
 /*
  * append a configuration descriptor to the given descriptor list, where the
@@ -526,6 +540,7 @@ void vpdma_add_cfd_adb(struct vpdma_desc_list *list, int client,
 
 	dump_cfd(cfd);
 };
+EXPORT_SYMBOL(vpdma_add_cfd_adb);
 
 /*
  * control descriptor format change based on what type of control descriptor it
@@ -563,6 +578,7 @@ void vpdma_add_sync_on_channel_ctd(struct vpdma_desc_list *list,
 
 	dump_ctd(ctd);
 }
+EXPORT_SYMBOL(vpdma_add_sync_on_channel_ctd);
 
 static void dump_dtd(struct vpdma_dtd *dtd)
 {
@@ -674,6 +690,7 @@ void vpdma_add_out_dtd(struct vpdma_desc_list *list, int width,
 
 	dump_dtd(dtd);
 }
+EXPORT_SYMBOL(vpdma_add_out_dtd);
 
 /*
  * append an inbound data transfer descriptor to the given descriptor list,
@@ -747,6 +764,7 @@ void vpdma_add_in_dtd(struct vpdma_desc_list *list, int width,
 
 	dump_dtd(dtd);
 }
+EXPORT_SYMBOL(vpdma_add_in_dtd);
 
 /* set or clear the mask for list complete interrupt */
 void vpdma_enable_list_complete_irq(struct vpdma_data *vpdma, int list_num,
@@ -761,6 +779,7 @@ void vpdma_enable_list_complete_irq(struct vpdma_data *vpdma, int list_num,
 		val &= ~(1 << (list_num * 2));
 	write_reg(vpdma, VPDMA_INT_LIST0_MASK, val);
 }
+EXPORT_SYMBOL(vpdma_enable_list_complete_irq);
 
 /* clear previosuly occured list intterupts in the LIST_STAT register */
 void vpdma_clear_list_stat(struct vpdma_data *vpdma)
@@ -768,6 +787,7 @@ void vpdma_clear_list_stat(struct vpdma_data *vpdma)
 	write_reg(vpdma, VPDMA_INT_LIST0_STAT,
 		read_reg(vpdma, VPDMA_INT_LIST0_STAT));
 }
+EXPORT_SYMBOL(vpdma_clear_list_stat);
 
 /*
  * configures the output mode of the line buffer for the given client, the
@@ -782,6 +802,7 @@ void vpdma_set_line_mode(struct vpdma_data *vpdma, int line_mode,
 	write_field_reg(vpdma, client_cstat, line_mode,
 		VPDMA_CSTAT_LINE_MODE_MASK, VPDMA_CSTAT_LINE_MODE_SHIFT);
 }
+EXPORT_SYMBOL(vpdma_set_line_mode);
 
 /*
  * configures the event which should trigger VPDMA transfer for the given
@@ -796,6 +817,7 @@ void vpdma_set_frame_start_event(struct vpdma_data *vpdma,
 	write_field_reg(vpdma, client_cstat, fs_event,
 		VPDMA_CSTAT_FRAME_START_MASK, VPDMA_CSTAT_FRAME_START_SHIFT);
 }
+EXPORT_SYMBOL(vpdma_set_frame_start_event);
 
 static void vpdma_firmware_cb(const struct firmware *f, void *context)
 {
@@ -909,4 +931,8 @@ struct vpdma_data *vpdma_create(struct platform_device *pdev,
 
 	return vpdma;
 }
+EXPORT_SYMBOL(vpdma_create);
+
+MODULE_AUTHOR("Texas Instruments Inc.");
 MODULE_FIRMWARE(VPDMA_FIRMWARE);
+MODULE_LICENSE("GPL v2");
-- 
2.9.0

