Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40281 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878AbcCXX2N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2016 19:28:13 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 23/51] v4l: vsp1: Add header display list support
Date: Fri, 25 Mar 2016 01:27:19 +0200
Message-Id: <1458862067-19525-24-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1458862067-19525-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1458862067-19525-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Display lists can operate in header or headerless mode. The headerless
mode is only available on WPF0, to be used with the display engine. All
other WPF instances can only use display lists in header mode.

Implement support for header mode to prepare for display list usage on
WPFs other than 0.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_dl.c  | 74 +++++++++++++++++++++++++++++++---
 drivers/media/platform/vsp1/vsp1_dl.h  |  1 +
 drivers/media/platform/vsp1/vsp1_wpf.c |  2 +-
 3 files changed, 71 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index 0b2896c04f4f..596f6a67f1bb 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -28,9 +28,23 @@
  * - DL swap
  */
 
+#define VSP1_DL_HEADER_SIZE		76
 #define VSP1_DL_BODY_SIZE		(2 * 4 * 256)
 #define VSP1_DL_NUM_LISTS		3
 
+#define VSP1_DLH_INT_ENABLE		(1 << 1)
+#define VSP1_DLH_AUTO_START		(1 << 0)
+
+struct vsp1_dl_header {
+	u32 num_lists;
+	struct {
+		u32 num_bytes;
+		u32 addr;
+	} lists[8];
+	u32 next_header;
+	u32 flags;
+} __attribute__((__packed__));
+
 struct vsp1_dl_entry {
 	u32 addr;
 	u32 data;
@@ -41,6 +55,7 @@ struct vsp1_dl_list {
 
 	struct vsp1_dl_manager *dlm;
 
+	struct vsp1_dl_header *header;
 	struct vsp1_dl_entry *body;
 	dma_addr_t dma;
 	size_t size;
@@ -48,8 +63,15 @@ struct vsp1_dl_list {
 	int reg_count;
 };
 
+enum vsp1_dl_mode {
+	VSP1_DL_MODE_HEADER,
+	VSP1_DL_MODE_HEADERLESS,
+};
+
 /**
  * struct vsp1_dl_manager - Display List manager
+ * @index: index of the related WPF
+ * @mode: display list operation mode (header or headerless)
  * @vsp1: the VSP1 device
  * @lock: protects the active, queued and pending lists
  * @free: array of all free display lists
@@ -58,6 +80,8 @@ struct vsp1_dl_list {
  * @pending: list waiting to be queued to the hardware
  */
 struct vsp1_dl_manager {
+	unsigned int index;
+	enum vsp1_dl_mode mode;
 	struct vsp1_device *vsp1;
 
 	spinlock_t lock;
@@ -74,27 +98,44 @@ struct vsp1_dl_manager {
 static struct vsp1_dl_list *vsp1_dl_list_alloc(struct vsp1_dl_manager *dlm)
 {
 	struct vsp1_dl_list *dl;
+	size_t header_size;
+
+	/* The body needs to be aligned on a 8 bytes boundary, pad the header
+	 * size to allow allocating both in a single operation.
+	 */
+	header_size = dlm->mode == VSP1_DL_MODE_HEADER
+		    ? ALIGN(sizeof(struct vsp1_dl_header), 8)
+		    : 0;
 
 	dl = kzalloc(sizeof(*dl), GFP_KERNEL);
 	if (!dl)
 		return NULL;
 
 	dl->dlm = dlm;
-	dl->size = VSP1_DL_BODY_SIZE;
+	dl->size = header_size + VSP1_DL_BODY_SIZE;
 
-	dl->body = dma_alloc_writecombine(dlm->vsp1->dev, dl->size, &dl->dma,
-					  GFP_KERNEL);
-	if (!dl->body) {
+	dl->header = dma_alloc_writecombine(dlm->vsp1->dev, dl->size, &dl->dma,
+					    GFP_KERNEL);
+	if (!dl->header) {
 		kfree(dl);
 		return NULL;
 	}
 
+	if (dlm->mode == VSP1_DL_MODE_HEADER) {
+		memset(dl->header, 0, sizeof(*dl->header));
+		dl->header->lists[0].addr = dl->dma + header_size;
+		dl->header->flags = VSP1_DLH_INT_ENABLE;
+	}
+
+	dl->body = ((void *)dl->header) + header_size;
+
 	return dl;
 }
 
 static void vsp1_dl_list_free(struct vsp1_dl_list *dl)
 {
-	dma_free_writecombine(dl->dlm->vsp1->dev, dl->size, dl->body, dl->dma);
+	dma_free_writecombine(dl->dlm->vsp1->dev, dl->size, dl->header,
+			      dl->dma);
 	kfree(dl);
 }
 
@@ -160,6 +201,18 @@ void vsp1_dl_list_commit(struct vsp1_dl_list *dl)
 
 	spin_lock_irqsave(&dlm->lock, flags);
 
+	if (dl->dlm->mode == VSP1_DL_MODE_HEADER) {
+		/* Program the hardware with the display list body address and
+		 * size. In header mode the caller guarantees that the hardware
+		 * is idle at this point.
+		 */
+		dl->header->lists[0].num_bytes = dl->reg_count * 8;
+		vsp1_write(vsp1, VI6_DL_HDR_ADDR(dlm->index), dl->dma);
+
+		dlm->active = dl;
+		goto done;
+	}
+
 	/* Once the UPD bit has been set the hardware can start processing the
 	 * display list at any time and we can't touch the address and size
 	 * registers. In that case mark the update as pending, it will be
@@ -215,6 +268,13 @@ void vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
 	vsp1_dl_list_put(dlm->active);
 	dlm->active = NULL;
 
+	/* Header mode is used for mem-to-mem pipelines only. We don't need to
+	 * perform any operation as there can't be any new display list queued
+	 * in that case.
+	 */
+	if (dlm->mode == VSP1_DL_MODE_HEADER)
+		goto done;
+
 	/* The UPD bit set indicates that the commit operation raced with the
 	 * interrupt and occurred after the frame end event and UPD clear but
 	 * before interrupt processing. The hardware hasn't taken the update
@@ -277,6 +337,7 @@ void vsp1_dlm_reset(struct vsp1_dl_manager *dlm)
 }
 
 struct vsp1_dl_manager *vsp1_dlm_create(struct vsp1_device *vsp1,
+					unsigned int index,
 					unsigned int prealloc)
 {
 	struct vsp1_dl_manager *dlm;
@@ -286,6 +347,9 @@ struct vsp1_dl_manager *vsp1_dlm_create(struct vsp1_device *vsp1,
 	if (!dlm)
 		return NULL;
 
+	dlm->index = index;
+	dlm->mode = index == 0 && !vsp1->info->uapi
+		  ? VSP1_DL_MODE_HEADERLESS : VSP1_DL_MODE_HEADER;
 	dlm->vsp1 = vsp1;
 
 	spin_lock_init(&dlm->lock);
diff --git a/drivers/media/platform/vsp1/vsp1_dl.h b/drivers/media/platform/vsp1/vsp1_dl.h
index 46f7ae337374..571ed6d8e7c2 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.h
+++ b/drivers/media/platform/vsp1/vsp1_dl.h
@@ -22,6 +22,7 @@ struct vsp1_dl_manager;
 void vsp1_dlm_setup(struct vsp1_device *vsp1);
 
 struct vsp1_dl_manager *vsp1_dlm_create(struct vsp1_device *vsp1,
+					unsigned int index,
 					unsigned int prealloc);
 void vsp1_dlm_destroy(struct vsp1_dl_manager *dlm);
 void vsp1_dlm_reset(struct vsp1_dl_manager *dlm);
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index cf18183370f4..d82502681bc3 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -202,7 +202,7 @@ struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index)
 
 	/* Initialize the display list manager if the WPF is used for display */
 	if ((vsp1->info->features & VSP1_HAS_LIF) && index == 0) {
-		wpf->dlm = vsp1_dlm_create(vsp1, 4);
+		wpf->dlm = vsp1_dlm_create(vsp1, index, 4);
 		if (!wpf->dlm) {
 			ret = -ENOMEM;
 			goto error;
-- 
2.7.3

