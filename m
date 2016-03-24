Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40282 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbcCXX2f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2016 19:28:35 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 48/51] v4l: vsp1: dl: Add support for multi-body display lists
Date: Fri, 25 Mar 2016 01:27:44 +0200
Message-Id: <1458862067-19525-49-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1458862067-19525-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1458862067-19525-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Display lists support up to 8 bodies but we currently use a single one.
To support preparing display lists for large look-up tables, add support
for multi-body display lists.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_dl.c | 291 ++++++++++++++++++++++++++++------
 drivers/media/platform/vsp1/vsp1_dl.h |   8 +
 2 files changed, 252 insertions(+), 47 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index 4f2c3c95bfa4..f283035560a8 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -19,28 +19,20 @@
 #include "vsp1.h"
 #include "vsp1_dl.h"
 
-/*
- * Global resources
- *
- * - Display-related interrupts (can be used for vblank evasion ?)
- * - Display-list enable
- * - Header-less for WPF0
- * - DL swap
- */
-
-#define VSP1_DL_HEADER_SIZE		76
-#define VSP1_DL_BODY_SIZE		(2 * 4 * 256)
+#define VSP1_DL_NUM_ENTRIES		256
 #define VSP1_DL_NUM_LISTS		3
 
 #define VSP1_DLH_INT_ENABLE		(1 << 1)
 #define VSP1_DLH_AUTO_START		(1 << 0)
 
+struct vsp1_dl_header_list {
+	u32 num_bytes;
+	u32 addr;
+} __attribute__((__packed__));
+
 struct vsp1_dl_header {
 	u32 num_lists;
-	struct {
-		u32 num_bytes;
-		u32 addr;
-	} lists[8];
+	struct vsp1_dl_header_list lists[8];
 	u32 next_header;
 	u32 flags;
 } __attribute__((__packed__));
@@ -50,17 +42,44 @@ struct vsp1_dl_entry {
 	u32 data;
 } __attribute__((__packed__));
 
-struct vsp1_dl_list {
+/**
+ * struct vsp1_dl_body - Display list body
+ * @list: entry in the display list list of bodies
+ * @vsp1: the VSP1 device
+ * @entries: array of entries
+ * @dma: DMA address of the entries
+ * @size: size of the DMA memory in bytes
+ * @num_entries: number of stored entries
+ */
+struct vsp1_dl_body {
 	struct list_head list;
+	struct vsp1_device *vsp1;
+
+	struct vsp1_dl_entry *entries;
+	dma_addr_t dma;
+	size_t size;
+
+	unsigned int num_entries;
+};
 
+/**
+ * struct vsp1_dl_list - Display list
+ * @list: entry in the display list manager lists
+ * @dlm: the display list manager
+ * @header: display list header, NULL for headerless lists
+ * @dma: DMA address for the header
+ * @body0: first display list body
+ * @fragments: list of extra display list bodies
+ */
+struct vsp1_dl_list {
+	struct list_head list;
 	struct vsp1_dl_manager *dlm;
 
 	struct vsp1_dl_header *header;
-	struct vsp1_dl_entry *body;
 	dma_addr_t dma;
-	size_t size;
 
-	unsigned int reg_count;
+	struct vsp1_dl_body body0;
+	struct list_head fragments;
 };
 
 enum vsp1_dl_mode {
@@ -92,6 +111,111 @@ struct vsp1_dl_manager {
 };
 
 /* -----------------------------------------------------------------------------
+ * Display List Body Management
+ */
+
+/*
+ * Initialize a display list body object and allocate DMA memory for the body
+ * data. The display list body object is expected to have been initialized to
+ * 0 when allocated.
+ */
+static int vsp1_dl_body_init(struct vsp1_device *vsp1,
+			     struct vsp1_dl_body *dlb, unsigned int num_entries,
+			     size_t extra_size)
+{
+	size_t size = num_entries * sizeof(*dlb->entries) + extra_size;
+
+	dlb->vsp1 = vsp1;
+	dlb->size = size;
+
+	dlb->entries = dma_alloc_writecombine(vsp1->dev, dlb->size,
+					      &dlb->dma, GFP_KERNEL);
+	if (!dlb->entries)
+		return -ENOMEM;
+
+	return 0;
+}
+
+/*
+ * Cleanup a display list body and free allocated DMA memory allocated.
+ */
+static void vsp1_dl_body_cleanup(struct vsp1_dl_body *dlb)
+{
+	dma_free_writecombine(dlb->vsp1->dev, dlb->size, dlb->entries,
+			      dlb->dma);
+}
+
+/**
+ * vsp1_dl_fragment_alloc - Allocate a display list fragment
+ * @vsp1: The VSP1 device
+ * @num_entries: The maximum number of entries that the fragment can contain
+ *
+ * Allocate a display list fragment with enough memory to contain the requested
+ * number of entries.
+ *
+ * Return a pointer to a fragment on success or NULL if memory can't be
+ * allocated.
+ */
+struct vsp1_dl_body *vsp1_dl_fragment_alloc(struct vsp1_device *vsp1,
+					    unsigned int num_entries)
+{
+	struct vsp1_dl_body *dlb;
+	int ret;
+
+	dlb = kzalloc(sizeof(*dlb), GFP_KERNEL);
+	if (!dlb)
+		return NULL;
+
+	ret = vsp1_dl_body_init(vsp1, dlb, num_entries, 0);
+	if (ret < 0) {
+		kfree(dlb);
+		return NULL;
+	}
+
+	return dlb;
+}
+
+/**
+ * vsp1_dl_fragment_free - Free a display list fragment
+ * @dlb: The fragment
+ *
+ * Free the given display list fragment and the associated DMA memory.
+ *
+ * Fragments must only be freed explicitly if they are not added to a display
+ * list, as the display list will take ownership of them and free them
+ * otherwise. Manual free typically happens at cleanup time for fragments that
+ * have been allocated but not used.
+ *
+ * Passing a NULL pointer to this function is safe, in that case no operation
+ * will be performed.
+ */
+void vsp1_dl_fragment_free(struct vsp1_dl_body *dlb)
+{
+	if (!dlb)
+		return;
+
+	vsp1_dl_body_cleanup(dlb);
+	kfree(dlb);
+}
+
+/**
+ * vsp1_dl_fragment_write - Write a register to a display list fragment
+ * @dlb: The fragment
+ * @reg: The register address
+ * @data: The register value
+ *
+ * Write the given register and value to the display list fragment. The maximum
+ * number of entries that can be written in a fragment is specified when the
+ * fragment is allocated by vsp1_dl_fragment_alloc().
+ */
+void vsp1_dl_fragment_write(struct vsp1_dl_body *dlb, u32 reg, u32 data)
+{
+	dlb->entries[dlb->num_entries].addr = reg;
+	dlb->entries[dlb->num_entries].data = data;
+	dlb->num_entries++;
+}
+
+/* -----------------------------------------------------------------------------
  * Display List Transaction Management
  */
 
@@ -99,43 +223,61 @@ static struct vsp1_dl_list *vsp1_dl_list_alloc(struct vsp1_dl_manager *dlm)
 {
 	struct vsp1_dl_list *dl;
 	size_t header_size;
-
-	/* The body needs to be aligned on a 8 bytes boundary, pad the header
-	 * size to allow allocating both in a single operation.
-	 */
-	header_size = dlm->mode == VSP1_DL_MODE_HEADER
-		    ? ALIGN(sizeof(struct vsp1_dl_header), 8)
-		    : 0;
+	int ret;
 
 	dl = kzalloc(sizeof(*dl), GFP_KERNEL);
 	if (!dl)
 		return NULL;
 
+	INIT_LIST_HEAD(&dl->fragments);
 	dl->dlm = dlm;
-	dl->size = header_size + VSP1_DL_BODY_SIZE;
 
-	dl->header = dma_alloc_writecombine(dlm->vsp1->dev, dl->size, &dl->dma,
-					    GFP_KERNEL);
-	if (!dl->header) {
+	/* Initialize the display list body and allocate DMA memory for the body
+	 * and the optional header. Both are allocated together to avoid memory
+	 * fragmentation, with the header located right after the body in
+	 * memory.
+	 */
+	header_size = dlm->mode == VSP1_DL_MODE_HEADER
+		    ? ALIGN(sizeof(struct vsp1_dl_header), 8)
+		    : 0;
+
+	ret = vsp1_dl_body_init(dlm->vsp1, &dl->body0, VSP1_DL_NUM_ENTRIES,
+				header_size);
+	if (ret < 0) {
 		kfree(dl);
 		return NULL;
 	}
 
 	if (dlm->mode == VSP1_DL_MODE_HEADER) {
+		size_t header_offset = VSP1_DL_NUM_ENTRIES
+				     * sizeof(*dl->body0.entries);
+
+		dl->header = ((void *)dl->body0.entries) + header_offset;
+		dl->dma = dl->body0.dma + header_offset;
+
 		memset(dl->header, 0, sizeof(*dl->header));
-		dl->header->lists[0].addr = dl->dma + header_size;
+		dl->header->lists[0].addr = dl->body0.dma;
 		dl->header->flags = VSP1_DLH_INT_ENABLE;
 	}
 
-	dl->body = ((void *)dl->header) + header_size;
-
 	return dl;
 }
 
+static void vsp1_dl_list_free_fragments(struct vsp1_dl_list *dl)
+{
+	struct vsp1_dl_body *dlb, *next;
+
+	list_for_each_entry_safe(dlb, next, &dl->fragments, list) {
+		list_del(&dlb->list);
+		vsp1_dl_body_cleanup(dlb);
+		kfree(dlb);
+	}
+}
+
 static void vsp1_dl_list_free(struct vsp1_dl_list *dl)
 {
-	dma_free_writecombine(dl->dlm->vsp1->dev, dl->size, dl->header,
-			      dl->dma);
+	vsp1_dl_body_cleanup(&dl->body0);
+	vsp1_dl_list_free_fragments(dl);
 	kfree(dl);
 }
 
@@ -170,7 +312,8 @@ static void __vsp1_dl_list_put(struct vsp1_dl_list *dl)
 	if (!dl)
 		return;
 
-	dl->reg_count = 0;
+	vsp1_dl_list_free_fragments(dl);
+	dl->body0.num_entries = 0;
 
 	list_add_tail(&dl->list, &dl->dlm->free);
 }
@@ -196,11 +339,45 @@ void vsp1_dl_list_put(struct vsp1_dl_list *dl)
 	spin_unlock_irqrestore(&dl->dlm->lock, flags);
 }
 
+/**
+ * vsp1_dl_list_write - Write a register to the display list
+ * @dl: The display list
+ * @reg: The register address
+ * @data: The register value
+ *
+ * Write the given register and value to the display list. Up to 256 registers
+ * can be written per display list.
+ */
 void vsp1_dl_list_write(struct vsp1_dl_list *dl, u32 reg, u32 data)
 {
-	dl->body[dl->reg_count].addr = reg;
-	dl->body[dl->reg_count].data = data;
-	dl->reg_count++;
+	vsp1_dl_fragment_write(&dl->body0, reg, data);
+}
+
+/**
+ * vsp1_dl_list_add_fragment - Add a fragment to the display list
+ * @dl: The display list
+ * @dlb: The fragment
+ *
+ * Add a display list body as a fragment to a display list. Registers contained
+ * in fragments are processed after registers contained in the main display
+ * list, in the order in which fragments are added.
+ *
+ * Adding a fragment to a display list passes ownership of the fragment to the
+ * list. The caller must not touch the fragment after this call, and must not
+ * free it explicitly with vsp1_dl_fragment_free().
+ *
+ * Fragments are only usable for display lists in header mode. Attempt to
+ * add a fragment to a header-less display list will return an error.
+ */
+int vsp1_dl_list_add_fragment(struct vsp1_dl_list *dl,
+			      struct vsp1_dl_body *dlb)
+{
+	/* Multi-body lists are only available in header mode. */
+	if (dl->dlm->mode != VSP1_DL_MODE_HEADER)
+		return -EINVAL;
+
+	list_add_tail(&dlb->list, &dl->fragments);
+	return 0;
 }
 
 void vsp1_dl_list_commit(struct vsp1_dl_list *dl)
@@ -213,11 +390,30 @@ void vsp1_dl_list_commit(struct vsp1_dl_list *dl)
 	spin_lock_irqsave(&dlm->lock, flags);
 
 	if (dl->dlm->mode == VSP1_DL_MODE_HEADER) {
-		/* Program the hardware with the display list body address and
-		 * size. In header mode the caller guarantees that the hardware
-		 * is idle at this point.
+		struct vsp1_dl_header_list *hdr = dl->header->lists;
+		struct vsp1_dl_body *dlb;
+		unsigned int num_lists = 0;
+
+		/* Fill the header with the display list bodies addresses and
+		 * sizes. The address of the first body has already been filled
+		 * when the display list was allocated.
+		 *
+		 * In header mode the caller guarantees that the hardware is
+		 * idle at this point.
 		 */
-		dl->header->lists[0].num_bytes = dl->reg_count * 8;
+		hdr->num_bytes = dl->body0.num_entries
+			       * sizeof(*dl->header->lists);
+
+		list_for_each_entry(dlb, &dl->fragments, list) {
+			num_lists++;
+			hdr++;
+
+			hdr->addr = dlb->dma;
+			hdr->num_bytes = dlb->num_entries
+				       * sizeof(*dl->header->lists);
+		}
+
+		dl->header->num_lists = num_lists;
 		vsp1_write(vsp1, VI6_DL_HDR_ADDR(dlm->index), dl->dma);
 
 		dlm->active = dl;
@@ -240,9 +436,9 @@ void vsp1_dl_list_commit(struct vsp1_dl_list *dl)
 	 * The UPD bit will be cleared by the device when the display list is
 	 * processed.
 	 */
-	vsp1_write(vsp1, VI6_DL_HDR_ADDR(0), dl->dma);
+	vsp1_write(vsp1, VI6_DL_HDR_ADDR(0), dl->body0.dma);
 	vsp1_write(vsp1, VI6_DL_BODY_SIZE, VI6_DL_BODY_SIZE_UPD |
-		   (dl->reg_count * 8));
+		   (dl->body0.num_entries * sizeof(*dl->header->lists)));
 
 	__vsp1_dl_list_put(dlm->queued);
 	dlm->queued = dl;
@@ -308,9 +504,10 @@ void vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
 	if (dlm->pending) {
 		struct vsp1_dl_list *dl = dlm->pending;
 
-		vsp1_write(vsp1, VI6_DL_HDR_ADDR(0), dl->dma);
+		vsp1_write(vsp1, VI6_DL_HDR_ADDR(0), dl->body0.dma);
 		vsp1_write(vsp1, VI6_DL_BODY_SIZE, VI6_DL_BODY_SIZE_UPD |
-			   (dl->reg_count * 8));
+			   (dl->body0.num_entries *
+			    sizeof(*dl->header->lists)));
 
 		dlm->queued = dl;
 		dlm->pending = NULL;
diff --git a/drivers/media/platform/vsp1/vsp1_dl.h b/drivers/media/platform/vsp1/vsp1_dl.h
index 571ed6d8e7c2..de387cd4d745 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.h
+++ b/drivers/media/platform/vsp1/vsp1_dl.h
@@ -16,6 +16,7 @@
 #include <linux/types.h>
 
 struct vsp1_device;
+struct vsp1_dl_fragment;
 struct vsp1_dl_list;
 struct vsp1_dl_manager;
 
@@ -34,4 +35,11 @@ void vsp1_dl_list_put(struct vsp1_dl_list *dl);
 void vsp1_dl_list_write(struct vsp1_dl_list *dl, u32 reg, u32 data);
 void vsp1_dl_list_commit(struct vsp1_dl_list *dl);
 
+struct vsp1_dl_body *vsp1_dl_fragment_alloc(struct vsp1_device *vsp1,
+					    unsigned int num_entries);
+void vsp1_dl_fragment_free(struct vsp1_dl_body *dlb);
+void vsp1_dl_fragment_write(struct vsp1_dl_body *dlb, u32 reg, u32 data);
+int vsp1_dl_list_add_fragment(struct vsp1_dl_list *dl,
+			      struct vsp1_dl_body *dlb);
+
 #endif /* __VSP1_DL_H__ */
-- 
2.7.3

