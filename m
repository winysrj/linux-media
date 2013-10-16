Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:55404 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752835Ab3JPFhz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Oct 2013 01:37:55 -0400
From: Archit Taneja <archit@ti.com>
To: <k.debski@samsung.com>
CC: <hverkuil@xs4all.nl>, <linux-media@vger.kernel.org>,
	<linux-omap@vger.kernel.org>, Archit Taneja <archit@ti.com>
Subject: [PATCH v5 2/4] v4l: ti-vpe: Add helpers for creating VPDMA descriptors
Date: Wed, 16 Oct 2013 11:06:46 +0530
Message-ID: <1381901808-25119-3-git-send-email-archit@ti.com>
In-Reply-To: <1381901808-25119-1-git-send-email-archit@ti.com>
References: <1378462346-10880-1-git-send-email-archit@ti.com>
 <1381901808-25119-1-git-send-email-archit@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Create functions which the VPE driver can use to create a VPDMA descriptor and
add it to a VPDMA descriptor list. These functions take a pointer to an existing
list, and append the configuration/data/control descriptor header to the list.

In the case of configuration descriptors, the creation of a payload block may be
required(the payloads can hold VPE MMR values, or scaler coefficients). The
allocation of the payload buffer and it's content is left to the VPE driver.
However, the VPDMA library provides helper macros to create payload in the
correct format.

Add debug functions to dump the descriptors in a way such that it's easy to see
the values of different fields in the descriptors.

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Archit Taneja <archit@ti.com>
---
 drivers/media/platform/ti-vpe/vpdma.c      | 268 +++++++++++++++
 drivers/media/platform/ti-vpe/vpdma.h      |  48 +++
 drivers/media/platform/ti-vpe/vpdma_priv.h | 522 +++++++++++++++++++++++++++++
 3 files changed, 838 insertions(+)

diff --git a/drivers/media/platform/ti-vpe/vpdma.c b/drivers/media/platform/ti-vpe/vpdma.c
index 42db12c..af0a5ff 100644
--- a/drivers/media/platform/ti-vpe/vpdma.c
+++ b/drivers/media/platform/ti-vpe/vpdma.c
@@ -21,6 +21,7 @@
 #include <linux/platform_device.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
+#include <linux/videodev2.h>
 
 #include "vpdma.h"
 #include "vpdma_priv.h"
@@ -416,6 +417,273 @@ int vpdma_submit_descs(struct vpdma_data *vpdma, struct vpdma_desc_list *list)
 	return 0;
 }
 
+static void dump_cfd(struct vpdma_cfd *cfd)
+{
+	int class;
+
+	class = cfd_get_class(cfd);
+
+	pr_debug("config descriptor of payload class: %s\n",
+		class == CFD_CLS_BLOCK ? "simple block" :
+		"address data block");
+
+	if (class == CFD_CLS_BLOCK)
+		pr_debug("word0: dst_addr_offset = 0x%08x\n",
+			cfd->dest_addr_offset);
+
+	if (class == CFD_CLS_BLOCK)
+		pr_debug("word1: num_data_wrds = %d\n", cfd->block_len);
+
+	pr_debug("word2: payload_addr = 0x%08x\n", cfd->payload_addr);
+
+	pr_debug("word3: pkt_type = %d, direct = %d, class = %d, dest = %d, "
+		"payload_len = %d\n", cfd_get_pkt_type(cfd),
+		cfd_get_direct(cfd), class, cfd_get_dest(cfd),
+		cfd_get_payload_len(cfd));
+}
+
+/*
+ * append a configuration descriptor to the given descriptor list, where the
+ * payload is in the form of a simple data block specified in the descriptor
+ * header, this is used to upload scaler coefficients to the scaler module
+ */
+void vpdma_add_cfd_block(struct vpdma_desc_list *list, int client,
+		struct vpdma_buf *blk, u32 dest_offset)
+{
+	struct vpdma_cfd *cfd;
+	int len = blk->size;
+
+	WARN_ON(blk->dma_addr & VPDMA_DESC_ALIGN);
+
+	cfd = list->next;
+	WARN_ON((void *)(cfd + 1) > (list->buf.addr + list->buf.size));
+
+	cfd->dest_addr_offset = dest_offset;
+	cfd->block_len = len;
+	cfd->payload_addr = (u32) blk->dma_addr;
+	cfd->ctl_payload_len = cfd_pkt_payload_len(CFD_INDIRECT, CFD_CLS_BLOCK,
+				client, len >> 4);
+
+	list->next = cfd + 1;
+
+	dump_cfd(cfd);
+}
+
+/*
+ * append a configuration descriptor to the given descriptor list, where the
+ * payload is in the address data block format, this is used to a configure a
+ * discontiguous set of MMRs
+ */
+void vpdma_add_cfd_adb(struct vpdma_desc_list *list, int client,
+		struct vpdma_buf *adb)
+{
+	struct vpdma_cfd *cfd;
+	unsigned int len = adb->size;
+
+	WARN_ON(len & VPDMA_ADB_SIZE_ALIGN);
+	WARN_ON(adb->dma_addr & VPDMA_DESC_ALIGN);
+
+	cfd = list->next;
+	BUG_ON((void *)(cfd + 1) > (list->buf.addr + list->buf.size));
+
+	cfd->w0 = 0;
+	cfd->w1 = 0;
+	cfd->payload_addr = (u32) adb->dma_addr;
+	cfd->ctl_payload_len = cfd_pkt_payload_len(CFD_INDIRECT, CFD_CLS_ADB,
+				client, len >> 4);
+
+	list->next = cfd + 1;
+
+	dump_cfd(cfd);
+};
+
+/*
+ * control descriptor format change based on what type of control descriptor it
+ * is, we only use 'sync on channel' control descriptors for now, so assume it's
+ * that
+ */
+static void dump_ctd(struct vpdma_ctd *ctd)
+{
+	pr_debug("control descriptor\n");
+
+	pr_debug("word3: pkt_type = %d, source = %d, ctl_type = %d\n",
+		ctd_get_pkt_type(ctd), ctd_get_source(ctd), ctd_get_ctl(ctd));
+}
+
+/*
+ * append a 'sync on channel' type control descriptor to the given descriptor
+ * list, this descriptor stalls the VPDMA list till the time DMA is completed
+ * on the specified channel
+ */
+void vpdma_add_sync_on_channel_ctd(struct vpdma_desc_list *list,
+		enum vpdma_channel chan)
+{
+	struct vpdma_ctd *ctd;
+
+	ctd = list->next;
+	WARN_ON((void *)(ctd + 1) > (list->buf.addr + list->buf.size));
+
+	ctd->w0 = 0;
+	ctd->w1 = 0;
+	ctd->w2 = 0;
+	ctd->type_source_ctl = ctd_type_source_ctl(chan_info[chan].num,
+				CTD_TYPE_SYNC_ON_CHANNEL);
+
+	list->next = ctd + 1;
+
+	dump_ctd(ctd);
+}
+
+static void dump_dtd(struct vpdma_dtd *dtd)
+{
+	int dir, chan;
+
+	dir = dtd_get_dir(dtd);
+	chan = dtd_get_chan(dtd);
+
+	pr_debug("%s data transfer descriptor for channel %d\n",
+		dir == DTD_DIR_OUT ? "outbound" : "inbound", chan);
+
+	pr_debug("word0: data_type = %d, notify = %d, field = %d, 1D = %d, "
+		"even_ln_skp = %d, odd_ln_skp = %d, line_stride = %d\n",
+		dtd_get_data_type(dtd), dtd_get_notify(dtd), dtd_get_field(dtd),
+		dtd_get_1d(dtd), dtd_get_even_line_skip(dtd),
+		dtd_get_odd_line_skip(dtd), dtd_get_line_stride(dtd));
+
+	if (dir == DTD_DIR_IN)
+		pr_debug("word1: line_length = %d, xfer_height = %d\n",
+			dtd_get_line_length(dtd), dtd_get_xfer_height(dtd));
+
+	pr_debug("word2: start_addr = 0x%08x\n", dtd->start_addr);
+
+	pr_debug("word3: pkt_type = %d, mode = %d, dir = %d, chan = %d, "
+		"pri = %d, next_chan = %d\n", dtd_get_pkt_type(dtd),
+		dtd_get_mode(dtd), dir, chan, dtd_get_priority(dtd),
+		dtd_get_next_chan(dtd));
+
+	if (dir == DTD_DIR_IN)
+		pr_debug("word4: frame_width = %d, frame_height = %d\n",
+			dtd_get_frame_width(dtd), dtd_get_frame_height(dtd));
+	else
+		pr_debug("word4: desc_write_addr = 0x%08x, write_desc = %d, "
+			"drp_data = %d, use_desc_reg = %d\n",
+			dtd_get_desc_write_addr(dtd), dtd_get_write_desc(dtd),
+			dtd_get_drop_data(dtd), dtd_get_use_desc(dtd));
+
+	if (dir == DTD_DIR_IN)
+		pr_debug("word5: hor_start = %d, ver_start = %d\n",
+			dtd_get_h_start(dtd), dtd_get_v_start(dtd));
+	else
+		pr_debug("word5: max_width %d, max_height %d\n",
+			dtd_get_max_width(dtd), dtd_get_max_height(dtd));
+
+	pr_debug("word6: client specfic attr0 = 0x%08x\n", dtd->client_attr0);
+	pr_debug("word7: client specfic attr1 = 0x%08x\n", dtd->client_attr1);
+}
+
+/*
+ * append an outbound data transfer descriptor to the given descriptor list,
+ * this sets up a 'client to memory' VPDMA transfer for the given VPDMA channel
+ */
+void vpdma_add_out_dtd(struct vpdma_desc_list *list, struct v4l2_rect *c_rect,
+		const struct vpdma_data_format *fmt, dma_addr_t dma_addr,
+		enum vpdma_channel chan, u32 flags)
+{
+	int priority = 0;
+	int field = 0;
+	int notify = 1;
+	int channel, next_chan;
+	int depth = fmt->depth;
+	int stride;
+	struct vpdma_dtd *dtd;
+
+	channel = next_chan = chan_info[chan].num;
+
+	if (fmt->data_type == DATA_TYPE_C420)
+		depth = 8;
+
+	stride = (depth * c_rect->width) >> 3;
+	dma_addr += (c_rect->left * depth) >> 3;
+
+	dtd = list->next;
+	WARN_ON((void *)(dtd + 1) > (list->buf.addr + list->buf.size));
+
+	dtd->type_ctl_stride = dtd_type_ctl_stride(fmt->data_type,
+					notify,
+					field,
+					!!(flags & VPDMA_DATA_FRAME_1D),
+					!!(flags & VPDMA_DATA_EVEN_LINE_SKIP),
+					!!(flags & VPDMA_DATA_ODD_LINE_SKIP),
+					stride);
+	dtd->w1 = 0;
+	dtd->start_addr = (u32) dma_addr;
+	dtd->pkt_ctl = dtd_pkt_ctl(!!(flags & VPDMA_DATA_MODE_TILED),
+				DTD_DIR_OUT, channel, priority, next_chan);
+	dtd->desc_write_addr = dtd_desc_write_addr(0, 0, 0, 0);
+	dtd->max_width_height = dtd_max_width_height(MAX_OUT_WIDTH_1920,
+					MAX_OUT_HEIGHT_1080);
+	dtd->client_attr0 = 0;
+	dtd->client_attr1 = 0;
+
+	list->next = dtd + 1;
+
+	dump_dtd(dtd);
+}
+
+/*
+ * append an inbound data transfer descriptor to the given descriptor list,
+ * this sets up a 'memory to client' VPDMA transfer for the given VPDMA channel
+ */
+void vpdma_add_in_dtd(struct vpdma_desc_list *list, int frame_width,
+		int frame_height, struct v4l2_rect *c_rect,
+		const struct vpdma_data_format *fmt, dma_addr_t dma_addr,
+		enum vpdma_channel chan, int field, u32 flags)
+{
+	int priority = 0;
+	int notify = 1;
+	int depth = fmt->depth;
+	int channel, next_chan;
+	int stride;
+	int height = c_rect->height;
+	struct vpdma_dtd *dtd;
+
+	channel = next_chan = chan_info[chan].num;
+
+	if (fmt->data_type == DATA_TYPE_C420) {
+		height >>= 1;
+		frame_height >>= 1;
+		depth = 8;
+	}
+
+	stride = (depth * c_rect->width) >> 3;
+	dma_addr += (c_rect->left * depth) >> 3;
+
+	dtd = list->next;
+	WARN_ON((void *)(dtd + 1) > (list->buf.addr + list->buf.size));
+
+	dtd->type_ctl_stride = dtd_type_ctl_stride(fmt->data_type,
+					notify,
+					field,
+					!!(flags & VPDMA_DATA_FRAME_1D),
+					!!(flags & VPDMA_DATA_EVEN_LINE_SKIP),
+					!!(flags & VPDMA_DATA_ODD_LINE_SKIP),
+					stride);
+
+	dtd->xfer_length_height = dtd_xfer_length_height(c_rect->width, height);
+	dtd->start_addr = (u32) dma_addr;
+	dtd->pkt_ctl = dtd_pkt_ctl(!!(flags & VPDMA_DATA_MODE_TILED),
+				DTD_DIR_IN, channel, priority, next_chan);
+	dtd->frame_width_height = dtd_frame_width_height(frame_width,
+					frame_height);
+	dtd->start_h_v = dtd_start_h_v(c_rect->left, c_rect->top);
+	dtd->client_attr0 = 0;
+	dtd->client_attr1 = 0;
+
+	list->next = dtd + 1;
+
+	dump_dtd(dtd);
+}
+
 /* set or clear the mask for list complete interrupt */
 void vpdma_enable_list_complete_irq(struct vpdma_data *vpdma, int list_num,
 		bool enable)
diff --git a/drivers/media/platform/ti-vpe/vpdma.h b/drivers/media/platform/ti-vpe/vpdma.h
index 8056689..eaa2a71 100644
--- a/drivers/media/platform/ti-vpe/vpdma.h
+++ b/drivers/media/platform/ti-vpe/vpdma.h
@@ -124,6 +124,39 @@ enum vpdma_channel {
 	VPE_CHAN_RGB_OUT,
 };
 
+/* flags for VPDMA data descriptors */
+#define VPDMA_DATA_ODD_LINE_SKIP	(1 << 0)
+#define VPDMA_DATA_EVEN_LINE_SKIP	(1 << 1)
+#define VPDMA_DATA_FRAME_1D		(1 << 2)
+#define VPDMA_DATA_MODE_TILED		(1 << 3)
+
+/*
+ * client identifiers used for configuration descriptors
+ */
+#define CFD_MMR_CLIENT		0
+#define CFD_SC_CLIENT		4
+
+/* Address data block header format */
+struct vpdma_adb_hdr {
+	u32			offset;
+	u32			nwords;
+	u32			reserved0;
+	u32			reserved1;
+};
+
+/* helpers for creating ADB headers for config descriptors MMRs as client */
+#define ADB_ADDR(dma_buf, str, fld)	((dma_buf)->addr + offsetof(str, fld))
+#define MMR_ADB_ADDR(buf, str, fld)	ADB_ADDR(&(buf), struct str, fld)
+
+#define VPDMA_SET_MMR_ADB_HDR(buf, str, hdr, regs, offset_a)	\
+	do {							\
+		struct vpdma_adb_hdr *h;			\
+		struct str *adb = NULL;				\
+		h = MMR_ADB_ADDR(buf, str, hdr);		\
+		h->offset = (offset_a);				\
+		h->nwords = sizeof(adb->regs) >> 2;		\
+	} while (0)
+
 /* vpdma descriptor buffer allocation and management */
 int vpdma_alloc_desc_buf(struct vpdma_buf *buf, size_t size);
 void vpdma_free_desc_buf(struct vpdma_buf *buf);
@@ -136,6 +169,21 @@ void vpdma_reset_desc_list(struct vpdma_desc_list *list);
 void vpdma_free_desc_list(struct vpdma_desc_list *list);
 int vpdma_submit_descs(struct vpdma_data *vpdma, struct vpdma_desc_list *list);
 
+/* helpers for creating vpdma descriptors */
+void vpdma_add_cfd_block(struct vpdma_desc_list *list, int client,
+		struct vpdma_buf *blk, u32 dest_offset);
+void vpdma_add_cfd_adb(struct vpdma_desc_list *list, int client,
+		struct vpdma_buf *adb);
+void vpdma_add_sync_on_channel_ctd(struct vpdma_desc_list *list,
+		enum vpdma_channel chan);
+void vpdma_add_out_dtd(struct vpdma_desc_list *list, struct v4l2_rect *c_rect,
+		const struct vpdma_data_format *fmt, dma_addr_t dma_addr,
+		enum vpdma_channel chan, u32 flags);
+void vpdma_add_in_dtd(struct vpdma_desc_list *list, int frame_width,
+		int frame_height, struct v4l2_rect *c_rect,
+		const struct vpdma_data_format *fmt, dma_addr_t dma_addr,
+		enum vpdma_channel chan, int field, u32 flags);
+
 /* vpdma list interrupt management */
 void vpdma_enable_list_complete_irq(struct vpdma_data *vpdma, int list_num,
 		bool enable);
diff --git a/drivers/media/platform/ti-vpe/vpdma_priv.h b/drivers/media/platform/ti-vpe/vpdma_priv.h
index 8ff51a3..f0e9a80 100644
--- a/drivers/media/platform/ti-vpe/vpdma_priv.h
+++ b/drivers/media/platform/ti-vpe/vpdma_priv.h
@@ -116,4 +116,526 @@
 #define	VPE_CHAN_NUM_CHROMA_OUT		103
 #define	VPE_CHAN_NUM_RGB_OUT		106
 
+/*
+ * a VPDMA address data block payload for a configuration descriptor needs to
+ * have each sub block length as a multiple of 16 bytes. Therefore, the overall
+ * size of the payload also needs to be a multiple of 16 bytes. The sub block
+ * lengths should be ensured to be aligned by the VPDMA user.
+ */
+#define VPDMA_ADB_SIZE_ALIGN		0x0f
+
+/*
+ * data transfer descriptor
+ */
+struct vpdma_dtd {
+	u32			type_ctl_stride;
+	union {
+		u32		xfer_length_height;
+		u32		w1;
+	};
+	dma_addr_t		start_addr;
+	u32			pkt_ctl;
+	union {
+		u32		frame_width_height;	/* inbound */
+		dma_addr_t	desc_write_addr;	/* outbound */
+	};
+	union {
+		u32		start_h_v;		/* inbound */
+		u32		max_width_height;	/* outbound */
+	};
+	u32			client_attr0;
+	u32			client_attr1;
+};
+
+/* Data Transfer Descriptor specifics */
+#define DTD_NO_NOTIFY		0
+#define DTD_NOTIFY		1
+
+#define DTD_PKT_TYPE		0xa
+#define DTD_DIR_IN		0
+#define DTD_DIR_OUT		1
+
+/* type_ctl_stride */
+#define DTD_DATA_TYPE_MASK	0x3f
+#define DTD_DATA_TYPE_SHFT	26
+#define DTD_NOTIFY_MASK		0x01
+#define DTD_NOTIFY_SHFT		25
+#define DTD_FIELD_MASK		0x01
+#define DTD_FIELD_SHFT		24
+#define DTD_1D_MASK		0x01
+#define DTD_1D_SHFT		23
+#define DTD_EVEN_LINE_SKIP_MASK	0x01
+#define DTD_EVEN_LINE_SKIP_SHFT	20
+#define DTD_ODD_LINE_SKIP_MASK	0x01
+#define DTD_ODD_LINE_SKIP_SHFT	16
+#define DTD_LINE_STRIDE_MASK	0xffff
+#define DTD_LINE_STRIDE_SHFT	0
+
+/* xfer_length_height */
+#define DTD_LINE_LENGTH_MASK	0xffff
+#define DTD_LINE_LENGTH_SHFT	16
+#define DTD_XFER_HEIGHT_MASK	0xffff
+#define DTD_XFER_HEIGHT_SHFT	0
+
+/* pkt_ctl */
+#define DTD_PKT_TYPE_MASK	0x1f
+#define DTD_PKT_TYPE_SHFT	27
+#define DTD_MODE_MASK		0x01
+#define DTD_MODE_SHFT		26
+#define DTD_DIR_MASK		0x01
+#define DTD_DIR_SHFT		25
+#define DTD_CHAN_MASK		0x01ff
+#define DTD_CHAN_SHFT		16
+#define DTD_PRI_MASK		0x0f
+#define DTD_PRI_SHFT		9
+#define DTD_NEXT_CHAN_MASK	0x01ff
+#define DTD_NEXT_CHAN_SHFT	0
+
+/* frame_width_height */
+#define DTD_FRAME_WIDTH_MASK	0xffff
+#define DTD_FRAME_WIDTH_SHFT	16
+#define DTD_FRAME_HEIGHT_MASK	0xffff
+#define DTD_FRAME_HEIGHT_SHFT	0
+
+/* start_h_v */
+#define DTD_H_START_MASK	0xffff
+#define DTD_H_START_SHFT	16
+#define DTD_V_START_MASK	0xffff
+#define DTD_V_START_SHFT	0
+
+#define DTD_DESC_START_SHIFT	5
+#define DTD_WRITE_DESC_MASK	0x01
+#define DTD_WRITE_DESC_SHIFT	2
+#define DTD_DROP_DATA_MASK	0x01
+#define DTD_DROP_DATA_SHIFT	1
+#define DTD_USE_DESC_MASK	0x01
+#define DTD_USE_DESC_SHIFT	0
+
+/* max_width_height */
+#define DTD_MAX_WIDTH_MASK	0x07
+#define DTD_MAX_WIDTH_SHFT	4
+#define DTD_MAX_HEIGHT_MASK	0x07
+#define DTD_MAX_HEIGHT_SHFT	0
+
+/* max width configurations */
+ /* unlimited width */
+#define	MAX_OUT_WIDTH_UNLIMITED		0
+/* as specified in max_size1 reg */
+#define MAX_OUT_WIDTH_REG1		1
+/* as specified in max_size2 reg */
+#define MAX_OUT_WIDTH_REG2		2
+/* as specified in max_size3 reg */
+#define	MAX_OUT_WIDTH_REG3		3
+/* maximum of 352 pixels as width */
+#define MAX_OUT_WIDTH_352		4
+/* maximum of 768 pixels as width */
+#define	MAX_OUT_WIDTH_768		5
+/* maximum of 1280 pixels width */
+#define	MAX_OUT_WIDTH_1280		6
+/* maximum of 1920 pixels as width */
+#define	MAX_OUT_WIDTH_1920		7
+
+/* max height configurations */
+ /* unlimited height */
+#define	MAX_OUT_HEIGHT_UNLIMITED	0
+/* as specified in max_size1 reg */
+#define MAX_OUT_HEIGHT_REG1		1
+/* as specified in max_size2 reg */
+#define MAX_OUT_HEIGHT_REG2		2
+/* as specified in max_size3 reg */
+#define	MAX_OUT_HEIGHT_REG3		3
+/* maximum of 288 lines as height */
+#define MAX_OUT_HEIGHT_288		4
+/* maximum of 576 lines as height */
+#define	MAX_OUT_HEIGHT_576		5
+/* maximum of 720 lines as height */
+#define	MAX_OUT_HEIGHT_720		6
+/* maximum of 1080 lines as height */
+#define	MAX_OUT_HEIGHT_1080		7
+
+static inline u32 dtd_type_ctl_stride(int type, bool notify, int field,
+			bool one_d, bool even_line_skip, bool odd_line_skip,
+			int line_stride)
+{
+	return (type << DTD_DATA_TYPE_SHFT) | (notify << DTD_NOTIFY_SHFT) |
+		(field << DTD_FIELD_SHFT) | (one_d << DTD_1D_SHFT) |
+		(even_line_skip << DTD_EVEN_LINE_SKIP_SHFT) |
+		(odd_line_skip << DTD_ODD_LINE_SKIP_SHFT) |
+		line_stride;
+}
+
+static inline u32 dtd_xfer_length_height(int line_length, int xfer_height)
+{
+	return (line_length << DTD_LINE_LENGTH_SHFT) | xfer_height;
+}
+
+static inline u32 dtd_pkt_ctl(bool mode, bool dir, int chan, int pri,
+			int next_chan)
+{
+	return (DTD_PKT_TYPE << DTD_PKT_TYPE_SHFT) | (mode << DTD_MODE_SHFT) |
+		(dir << DTD_DIR_SHFT) | (chan << DTD_CHAN_SHFT) |
+		(pri << DTD_PRI_SHFT) | next_chan;
+}
+
+static inline u32 dtd_frame_width_height(int width, int height)
+{
+	return (width << DTD_FRAME_WIDTH_SHFT) | height;
+}
+
+static inline u32 dtd_desc_write_addr(unsigned int addr, bool write_desc,
+			bool drop_data, bool use_desc)
+{
+	return (addr << DTD_DESC_START_SHIFT) |
+		(write_desc << DTD_WRITE_DESC_SHIFT) |
+		(drop_data << DTD_DROP_DATA_SHIFT) |
+		use_desc;
+}
+
+static inline u32 dtd_start_h_v(int h_start, int v_start)
+{
+	return (h_start << DTD_H_START_SHFT) | v_start;
+}
+
+static inline u32 dtd_max_width_height(int max_width, int max_height)
+{
+	return (max_width << DTD_MAX_WIDTH_SHFT) | max_height;
+}
+
+static inline int dtd_get_data_type(struct vpdma_dtd *dtd)
+{
+	return dtd->type_ctl_stride >> DTD_DATA_TYPE_SHFT;
+}
+
+static inline bool dtd_get_notify(struct vpdma_dtd *dtd)
+{
+	return (dtd->type_ctl_stride >> DTD_NOTIFY_SHFT) & DTD_NOTIFY_MASK;
+}
+
+static inline int dtd_get_field(struct vpdma_dtd *dtd)
+{
+	return (dtd->type_ctl_stride >> DTD_FIELD_SHFT) & DTD_FIELD_MASK;
+}
+
+static inline bool dtd_get_1d(struct vpdma_dtd *dtd)
+{
+	return (dtd->type_ctl_stride >> DTD_1D_SHFT) & DTD_1D_MASK;
+}
+
+static inline bool dtd_get_even_line_skip(struct vpdma_dtd *dtd)
+{
+	return (dtd->type_ctl_stride >> DTD_EVEN_LINE_SKIP_SHFT)
+		& DTD_EVEN_LINE_SKIP_MASK;
+}
+
+static inline bool dtd_get_odd_line_skip(struct vpdma_dtd *dtd)
+{
+	return (dtd->type_ctl_stride >> DTD_ODD_LINE_SKIP_SHFT)
+		& DTD_ODD_LINE_SKIP_MASK;
+}
+
+static inline int dtd_get_line_stride(struct vpdma_dtd *dtd)
+{
+	return dtd->type_ctl_stride & DTD_LINE_STRIDE_MASK;
+}
+
+static inline int dtd_get_line_length(struct vpdma_dtd *dtd)
+{
+	return dtd->xfer_length_height >> DTD_LINE_LENGTH_SHFT;
+}
+
+static inline int dtd_get_xfer_height(struct vpdma_dtd *dtd)
+{
+	return dtd->xfer_length_height & DTD_XFER_HEIGHT_MASK;
+}
+
+static inline int dtd_get_pkt_type(struct vpdma_dtd *dtd)
+{
+	return dtd->pkt_ctl >> DTD_PKT_TYPE_SHFT;
+}
+
+static inline bool dtd_get_mode(struct vpdma_dtd *dtd)
+{
+	return (dtd->pkt_ctl >> DTD_MODE_SHFT) & DTD_MODE_MASK;
+}
+
+static inline bool dtd_get_dir(struct vpdma_dtd *dtd)
+{
+	return (dtd->pkt_ctl >> DTD_DIR_SHFT) & DTD_DIR_MASK;
+}
+
+static inline int dtd_get_chan(struct vpdma_dtd *dtd)
+{
+	return (dtd->pkt_ctl >> DTD_CHAN_SHFT) & DTD_CHAN_MASK;
+}
+
+static inline int dtd_get_priority(struct vpdma_dtd *dtd)
+{
+	return (dtd->pkt_ctl >> DTD_PRI_SHFT) & DTD_PRI_MASK;
+}
+
+static inline int dtd_get_next_chan(struct vpdma_dtd *dtd)
+{
+	return (dtd->pkt_ctl >> DTD_NEXT_CHAN_SHFT) & DTD_NEXT_CHAN_MASK;
+}
+
+static inline int dtd_get_frame_width(struct vpdma_dtd *dtd)
+{
+	return dtd->frame_width_height >> DTD_FRAME_WIDTH_SHFT;
+}
+
+static inline int dtd_get_frame_height(struct vpdma_dtd *dtd)
+{
+	return dtd->frame_width_height & DTD_FRAME_HEIGHT_MASK;
+}
+
+static inline int dtd_get_desc_write_addr(struct vpdma_dtd *dtd)
+{
+	return dtd->desc_write_addr >> DTD_DESC_START_SHIFT;
+}
+
+static inline bool dtd_get_write_desc(struct vpdma_dtd *dtd)
+{
+	return (dtd->desc_write_addr >> DTD_WRITE_DESC_SHIFT) &
+							DTD_WRITE_DESC_MASK;
+}
+
+static inline bool dtd_get_drop_data(struct vpdma_dtd *dtd)
+{
+	return (dtd->desc_write_addr >> DTD_DROP_DATA_SHIFT) &
+							DTD_DROP_DATA_MASK;
+}
+
+static inline bool dtd_get_use_desc(struct vpdma_dtd *dtd)
+{
+	return dtd->desc_write_addr & DTD_USE_DESC_MASK;
+}
+
+static inline int dtd_get_h_start(struct vpdma_dtd *dtd)
+{
+	return dtd->start_h_v >> DTD_H_START_SHFT;
+}
+
+static inline int dtd_get_v_start(struct vpdma_dtd *dtd)
+{
+	return dtd->start_h_v & DTD_V_START_MASK;
+}
+
+static inline int dtd_get_max_width(struct vpdma_dtd *dtd)
+{
+	return (dtd->max_width_height >> DTD_MAX_WIDTH_SHFT) &
+							DTD_MAX_WIDTH_MASK;
+}
+
+static inline int dtd_get_max_height(struct vpdma_dtd *dtd)
+{
+	return (dtd->max_width_height >> DTD_MAX_HEIGHT_SHFT) &
+							DTD_MAX_HEIGHT_MASK;
+}
+
+/*
+ * configuration descriptor
+ */
+struct vpdma_cfd {
+	union {
+		u32	dest_addr_offset;
+		u32	w0;
+	};
+	union {
+		u32	block_len;		/* in words */
+		u32	w1;
+	};
+	u32		payload_addr;
+	u32		ctl_payload_len;	/* in words */
+};
+
+/* Configuration descriptor specifics */
+
+#define CFD_PKT_TYPE		0xb
+
+#define CFD_DIRECT		1
+#define CFD_INDIRECT		0
+#define CFD_CLS_ADB		0
+#define CFD_CLS_BLOCK		1
+
+/* block_len */
+#define CFD__BLOCK_LEN_MASK	0xffff
+#define CFD__BLOCK_LEN_SHFT	0
+
+/* ctl_payload_len */
+#define CFD_PKT_TYPE_MASK	0x1f
+#define CFD_PKT_TYPE_SHFT	27
+#define CFD_DIRECT_MASK		0x01
+#define CFD_DIRECT_SHFT		26
+#define CFD_CLASS_MASK		0x03
+#define CFD_CLASS_SHFT		24
+#define CFD_DEST_MASK		0xff
+#define CFD_DEST_SHFT		16
+#define CFD_PAYLOAD_LEN_MASK	0xffff
+#define CFD_PAYLOAD_LEN_SHFT	0
+
+static inline u32 cfd_pkt_payload_len(bool direct, int cls, int dest,
+		int payload_len)
+{
+	return (CFD_PKT_TYPE << CFD_PKT_TYPE_SHFT) |
+		(direct << CFD_DIRECT_SHFT) |
+		(cls << CFD_CLASS_SHFT) |
+		(dest << CFD_DEST_SHFT) |
+		payload_len;
+}
+
+static inline int cfd_get_pkt_type(struct vpdma_cfd *cfd)
+{
+	return cfd->ctl_payload_len >> CFD_PKT_TYPE_SHFT;
+}
+
+static inline bool cfd_get_direct(struct vpdma_cfd *cfd)
+{
+	return (cfd->ctl_payload_len >> CFD_DIRECT_SHFT) & CFD_DIRECT_MASK;
+}
+
+static inline bool cfd_get_class(struct vpdma_cfd *cfd)
+{
+	return (cfd->ctl_payload_len >> CFD_CLASS_SHFT) & CFD_CLASS_MASK;
+}
+
+static inline int cfd_get_dest(struct vpdma_cfd *cfd)
+{
+	return (cfd->ctl_payload_len >> CFD_DEST_SHFT) & CFD_DEST_MASK;
+}
+
+static inline int cfd_get_payload_len(struct vpdma_cfd *cfd)
+{
+	return cfd->ctl_payload_len & CFD_PAYLOAD_LEN_MASK;
+}
+
+/*
+ * control descriptor
+ */
+struct vpdma_ctd {
+	union {
+		u32	timer_value;
+		u32	list_addr;
+		u32	w0;
+	};
+	union {
+		u32	pixel_line_count;
+		u32	list_size;
+		u32	w1;
+	};
+	union {
+		u32	event;
+		u32	fid_ctl;
+		u32	w2;
+	};
+	u32		type_source_ctl;
+};
+
+/* control descriptor types */
+#define CTD_TYPE_SYNC_ON_CLIENT		0
+#define CTD_TYPE_SYNC_ON_LIST		1
+#define CTD_TYPE_SYNC_ON_EXT		2
+#define CTD_TYPE_SYNC_ON_LM_TIMER	3
+#define CTD_TYPE_SYNC_ON_CHANNEL	4
+#define CTD_TYPE_CHNG_CLIENT_IRQ	5
+#define CTD_TYPE_SEND_IRQ		6
+#define CTD_TYPE_RELOAD_LIST		7
+#define CTD_TYPE_ABORT_CHANNEL		8
+
+#define CTD_PKT_TYPE		0xc
+
+/* timer_value */
+#define CTD_TIMER_VALUE_MASK	0xffff
+#define CTD_TIMER_VALUE_SHFT	0
+
+/* pixel_line_count */
+#define CTD_PIXEL_COUNT_MASK	0xffff
+#define CTD_PIXEL_COUNT_SHFT	16
+#define CTD_LINE_COUNT_MASK	0xffff
+#define CTD_LINE_COUNT_SHFT	0
+
+/* list_size */
+#define CTD_LIST_SIZE_MASK	0xffff
+#define CTD_LIST_SIZE_SHFT	0
+
+/* event */
+#define CTD_EVENT_MASK		0x0f
+#define CTD_EVENT_SHFT		0
+
+/* fid_ctl */
+#define CTD_FID2_MASK		0x03
+#define CTD_FID2_SHFT		4
+#define CTD_FID1_MASK		0x03
+#define CTD_FID1_SHFT		2
+#define CTD_FID0_MASK		0x03
+#define CTD_FID0_SHFT		0
+
+/* type_source_ctl */
+#define CTD_PKT_TYPE_MASK	0x1f
+#define CTD_PKT_TYPE_SHFT	27
+#define CTD_SOURCE_MASK		0xff
+#define CTD_SOURCE_SHFT		16
+#define CTD_CONTROL_MASK	0x0f
+#define CTD_CONTROL_SHFT	0
+
+static inline u32 ctd_pixel_line_count(int pixel_count, int line_count)
+{
+	return (pixel_count << CTD_PIXEL_COUNT_SHFT) | line_count;
+}
+
+static inline u32 ctd_set_fid_ctl(int fid0, int fid1, int fid2)
+{
+	return (fid2 << CTD_FID2_SHFT) | (fid1 << CTD_FID1_SHFT) | fid0;
+}
+
+static inline u32 ctd_type_source_ctl(int source, int control)
+{
+	return (CTD_PKT_TYPE << CTD_PKT_TYPE_SHFT) |
+		(source << CTD_SOURCE_SHFT) | control;
+}
+
+static inline u32 ctd_get_pixel_count(struct vpdma_ctd *ctd)
+{
+	return ctd->pixel_line_count >> CTD_PIXEL_COUNT_SHFT;
+}
+
+static inline int ctd_get_line_count(struct vpdma_ctd *ctd)
+{
+	return ctd->pixel_line_count & CTD_LINE_COUNT_MASK;
+}
+
+static inline int ctd_get_event(struct vpdma_ctd *ctd)
+{
+	return ctd->event & CTD_EVENT_MASK;
+}
+
+static inline int ctd_get_fid2_ctl(struct vpdma_ctd *ctd)
+{
+	return (ctd->fid_ctl >> CTD_FID2_SHFT) & CTD_FID2_MASK;
+}
+
+static inline int ctd_get_fid1_ctl(struct vpdma_ctd *ctd)
+{
+	return (ctd->fid_ctl >> CTD_FID1_SHFT) & CTD_FID1_MASK;
+}
+
+static inline int ctd_get_fid0_ctl(struct vpdma_ctd *ctd)
+{
+	return ctd->fid_ctl & CTD_FID2_MASK;
+}
+
+static inline int ctd_get_pkt_type(struct vpdma_ctd *ctd)
+{
+	return ctd->type_source_ctl >> CTD_PKT_TYPE_SHFT;
+}
+
+static inline int ctd_get_source(struct vpdma_ctd *ctd)
+{
+	return (ctd->type_source_ctl >> CTD_SOURCE_SHFT) & CTD_SOURCE_MASK;
+}
+
+static inline int ctd_get_ctl(struct vpdma_ctd *ctd)
+{
+	return ctd->type_source_ctl & CTD_CONTROL_MASK;
+}
+
 #endif
-- 
1.8.1.2

