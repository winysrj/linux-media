Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:50116 "EHLO comal.ext.ti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933150AbcI1VVb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Sep 2016 17:21:31 -0400
From: Benoit Parrot <bparrot@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [Patch 12/35] media: ti-vpe: vpdma: Add abort channel desc and cleanup APIs
Date: Wed, 28 Sep 2016 16:21:24 -0500
Message-ID: <20160928212124.26860-1-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Nikhil Devshatwar <nikhil.nd@ti.com>

Whenever VPDMA processes a data descriptor of a list, it processes it
and sets up the channel for the DMA transaction. List manager holds the
descriptor in the list until the DMA is complete. If sync_on_channel
descriptor, or another descriptor for the same channel is present in
the FIFO, list manager keeps them until the current channel is free.

When the capture stream is closed suddenly while there are pending
descriptors in the FIFO (streamON failed, application killed), it would
keep the VPDMA in a busy state. Any further list post would fail with
EBUSY.

To avoid this, drivers need to stop the current processing list and
cleanup all the resources VPDMA has taken and also clear the internal FSM
of list manager. The state machine is cleared by issuing channel specific
abort descriptor.

Therefore, the vpdma_list_cleanup accepts an array of channels for which
abort_channel descriptors should be posted. It is driver's responsibility
to post for all the channels or the channels which were used in the last
context.

Signed-off-by: Nikhil Devshatwar <nikhil.nd@ti.com>
Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
 drivers/media/platform/ti-vpe/vpdma.c | 75 +++++++++++++++++++++++++++++++++++
 drivers/media/platform/ti-vpe/vpdma.h |  6 +++
 2 files changed, 81 insertions(+)

diff --git a/drivers/media/platform/ti-vpe/vpdma.c b/drivers/media/platform/ti-vpe/vpdma.c
index 587dacce3880..4a2f093dc0df 100644
--- a/drivers/media/platform/ti-vpe/vpdma.c
+++ b/drivers/media/platform/ti-vpe/vpdma.c
@@ -385,6 +385,56 @@ void vpdma_unmap_desc_buf(struct vpdma_data *vpdma, struct vpdma_buf *buf)
 EXPORT_SYMBOL(vpdma_unmap_desc_buf);
 
 /*
+ * Cleanup all pending descriptors of a list
+ * First, stop the current list being processed.
+ * If the VPDMA was busy, this step makes vpdma to accept post lists.
+ * To cleanup the internal FSM, post abort list descriptor for all the
+ * channels from @channels array of size @size.
+ */
+int vpdma_list_cleanup(struct vpdma_data *vpdma, int list_num,
+		int *channels, int size)
+{
+	struct vpdma_desc_list abort_list;
+	int i, ret, timeout = 500;
+
+	write_reg(vpdma, VPDMA_LIST_ATTR,
+			(list_num << VPDMA_LIST_NUM_SHFT) |
+			(1 << VPDMA_LIST_STOP_SHFT));
+
+	if (size <= 0 || !channels)
+		return 0;
+
+	ret = vpdma_create_desc_list(&abort_list,
+		size * sizeof(struct vpdma_dtd), VPDMA_LIST_TYPE_NORMAL);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < size; i++)
+		vpdma_add_abort_channel_ctd(&abort_list, channels[i]);
+
+	ret = vpdma_map_desc_buf(vpdma, &abort_list.buf);
+	if (ret)
+		return ret;
+	ret = vpdma_submit_descs(vpdma, &abort_list, list_num);
+	if (ret)
+		return ret;
+
+	while (vpdma_list_busy(vpdma, list_num) && timeout--)
+		;
+
+	if (timeout == 0) {
+		dev_err(&vpdma->pdev->dev, "Timed out cleaning up VPDMA list\n");
+		return -EBUSY;
+	}
+
+	vpdma_unmap_desc_buf(vpdma, &abort_list.buf);
+	vpdma_free_desc_buf(&abort_list.buf);
+
+	return 0;
+}
+EXPORT_SYMBOL(vpdma_list_cleanup);
+
+/*
  * create a descriptor list, the user of this list will append configuration,
  * control and data descriptors to this list, this list will be submitted to
  * VPDMA. VPDMA's list parser will go through each descriptor and perform the
@@ -629,6 +679,31 @@ void vpdma_add_sync_on_channel_ctd(struct vpdma_desc_list *list,
 }
 EXPORT_SYMBOL(vpdma_add_sync_on_channel_ctd);
 
+/*
+ * append an 'abort_channel' type control descriptor to the given descriptor
+ * list, this descriptor aborts any DMA transaction happening using the
+ * specified channel
+ */
+void vpdma_add_abort_channel_ctd(struct vpdma_desc_list *list,
+		int chan_num)
+{
+	struct vpdma_ctd *ctd;
+
+	ctd = list->next;
+	WARN_ON((void *)(ctd + 1) > (list->buf.addr + list->buf.size));
+
+	ctd->w0 = 0;
+	ctd->w1 = 0;
+	ctd->w2 = 0;
+	ctd->type_source_ctl = ctd_type_source_ctl(chan_num,
+				CTD_TYPE_ABORT_CHANNEL);
+
+	list->next = ctd + 1;
+
+	dump_ctd(ctd);
+}
+EXPORT_SYMBOL(vpdma_add_abort_channel_ctd);
+
 static void dump_dtd(struct vpdma_dtd *dtd)
 {
 	int dir, chan;
diff --git a/drivers/media/platform/ti-vpe/vpdma.h b/drivers/media/platform/ti-vpe/vpdma.h
index 32b9ed5191c5..4dafc1bcf116 100644
--- a/drivers/media/platform/ti-vpe/vpdma.h
+++ b/drivers/media/platform/ti-vpe/vpdma.h
@@ -163,6 +163,8 @@ enum vpdma_channel {
 #define VIP_CHAN_YUV_PORTB_OFFSET	2
 #define VIP_CHAN_RGB_PORTB_OFFSET	1
 
+#define VPDMA_MAX_CHANNELS		256
+
 /* flags for VPDMA data descriptors */
 #define VPDMA_DATA_ODD_LINE_SKIP	(1 << 0)
 #define VPDMA_DATA_EVEN_LINE_SKIP	(1 << 1)
@@ -219,6 +221,8 @@ void vpdma_add_cfd_adb(struct vpdma_desc_list *list, int client,
 		struct vpdma_buf *adb);
 void vpdma_add_sync_on_channel_ctd(struct vpdma_desc_list *list,
 		enum vpdma_channel chan);
+void vpdma_add_abort_channel_ctd(struct vpdma_desc_list *list,
+		int chan_num);
 void vpdma_add_out_dtd(struct vpdma_desc_list *list, int width,
 		const struct v4l2_rect *c_rect,
 		const struct vpdma_data_format *fmt, dma_addr_t dma_addr,
@@ -233,6 +237,8 @@ void vpdma_add_in_dtd(struct vpdma_desc_list *list, int width,
 		const struct vpdma_data_format *fmt, dma_addr_t dma_addr,
 		enum vpdma_channel chan, int field, u32 flags, int frame_width,
 		int frame_height, int start_h, int start_v);
+int vpdma_list_cleanup(struct vpdma_data *vpdma, int list_num,
+		int *channels, int size);
 
 /* vpdma list interrupt management */
 void vpdma_enable_list_complete_irq(struct vpdma_data *vpdma, int irq_num,
-- 
2.9.0

