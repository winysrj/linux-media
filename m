Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:50112 "EHLO comal.ext.ti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932803AbcI1VVT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Sep 2016 17:21:19 -0400
From: Benoit Parrot <bparrot@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [Patch 11/35] media: ti-vpe: vpdma: Add support for setting max width height
Date: Wed, 28 Sep 2016 16:21:17 -0500
Message-ID: <20160928212117.26815-1-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Nikhil Devshatwar <nikhil.nd@ti.com>

Add a helper function to be able to set the maximum
VPDMA transfer size to limit potential buffer overrun.

Added enums for max_width and max_height fields of the
outbound data descriptor.

Changed vpdma_add_out_dtd to accept two more arguments
for max width and height.

Make use of different max width & height sets for different
of capture module (i.e. slices).

Signed-off-by: Nikhil Devshatwar <nikhil.nd@ti.com>
Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
 drivers/media/platform/ti-vpe/vpdma.c      | 27 ++++++++++++++++----
 drivers/media/platform/ti-vpe/vpdma.h      | 32 ++++++++++++++++++++++--
 drivers/media/platform/ti-vpe/vpdma_priv.h | 40 +++---------------------------
 drivers/media/platform/ti-vpe/vpe.c        |  7 +++++-
 4 files changed, 62 insertions(+), 44 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/vpdma.c b/drivers/media/platform/ti-vpe/vpdma.c
index af8e8f083727..587dacce3880 100644
--- a/drivers/media/platform/ti-vpe/vpdma.c
+++ b/drivers/media/platform/ti-vpe/vpdma.c
@@ -493,6 +493,22 @@ void vpdma_update_dma_addr(struct vpdma_data *vpdma,
 }
 EXPORT_SYMBOL(vpdma_update_dma_addr);
 
+void vpdma_set_max_size(struct vpdma_data *vpdma, int reg_addr,
+			u32 width, u32 height)
+{
+	if (reg_addr != VPDMA_MAX_SIZE1 && reg_addr != VPDMA_MAX_SIZE2 &&
+	    reg_addr != VPDMA_MAX_SIZE3)
+		reg_addr = VPDMA_MAX_SIZE1;
+
+	write_field_reg(vpdma, reg_addr, width - 1,
+			VPDMA_MAX_SIZE_WIDTH_MASK, VPDMA_MAX_SIZE_WIDTH_SHFT);
+
+	write_field_reg(vpdma, reg_addr, height - 1,
+			VPDMA_MAX_SIZE_HEIGHT_MASK, VPDMA_MAX_SIZE_HEIGHT_SHFT);
+
+}
+EXPORT_SYMBOL(vpdma_set_max_size);
+
 static void dump_cfd(struct vpdma_cfd *cfd)
 {
 	int class;
@@ -669,23 +685,25 @@ static void dump_dtd(struct vpdma_dtd *dtd)
  * @c_rect: compose params of output image
  * @fmt: vpdma data format of the buffer
  * dma_addr: dma address as seen by VPDMA
+ * max_width: enum for maximum width of data transfer
+ * max_height: enum for maximum height of data transfer
  * chan: VPDMA channel
  * flags: VPDMA flags to configure some descriptor fileds
  */
 void vpdma_add_out_dtd(struct vpdma_desc_list *list, int width,
 		const struct v4l2_rect *c_rect,
 		const struct vpdma_data_format *fmt, dma_addr_t dma_addr,
-		enum vpdma_channel chan, u32 flags)
+		int max_w, int max_h, enum vpdma_channel chan, u32 flags)
 {
 	vpdma_rawchan_add_out_dtd(list, width, c_rect, fmt, dma_addr,
-				  chan_info[chan].num, flags);
+				  max_w, max_h, chan_info[chan].num, flags);
 }
 EXPORT_SYMBOL(vpdma_add_out_dtd);
 
 void vpdma_rawchan_add_out_dtd(struct vpdma_desc_list *list, int width,
 		const struct v4l2_rect *c_rect,
 		const struct vpdma_data_format *fmt, dma_addr_t dma_addr,
-		int raw_vpdma_chan, u32 flags)
+		int max_w, int max_h, int raw_vpdma_chan, u32 flags)
 {
 	int priority = 0;
 	int field = 0;
@@ -724,8 +742,7 @@ void vpdma_rawchan_add_out_dtd(struct vpdma_desc_list *list, int width,
 	dtd->pkt_ctl = dtd_pkt_ctl(!!(flags & VPDMA_DATA_MODE_TILED),
 				DTD_DIR_OUT, channel, priority, next_chan);
 	dtd->desc_write_addr = dtd_desc_write_addr(0, 0, 0, 0);
-	dtd->max_width_height = dtd_max_width_height(MAX_OUT_WIDTH_1920,
-					MAX_OUT_HEIGHT_1080);
+	dtd->max_width_height = dtd_max_width_height(max_w, max_h);
 	dtd->client_attr0 = 0;
 	dtd->client_attr1 = 0;
 
diff --git a/drivers/media/platform/ti-vpe/vpdma.h b/drivers/media/platform/ti-vpe/vpdma.h
index 220dc7e793f6..32b9ed5191c5 100644
--- a/drivers/media/platform/ti-vpe/vpdma.h
+++ b/drivers/media/platform/ti-vpe/vpdma.h
@@ -117,6 +117,30 @@ enum vpdma_frame_start_event {
 	VPDMA_FSEVENT_CHANNEL_ACTIVE,
 };
 
+/* max width configurations */
+enum vpdma_max_width {
+	MAX_OUT_WIDTH_UNLIMITED = 0,
+	MAX_OUT_WIDTH_REG1,
+	MAX_OUT_WIDTH_REG2,
+	MAX_OUT_WIDTH_REG3,
+	MAX_OUT_WIDTH_352,
+	MAX_OUT_WIDTH_768,
+	MAX_OUT_WIDTH_1280,
+	MAX_OUT_WIDTH_1920,
+};
+
+/* max height configurations */
+enum vpdma_max_height {
+	MAX_OUT_HEIGHT_UNLIMITED = 0,
+	MAX_OUT_HEIGHT_REG1,
+	MAX_OUT_HEIGHT_REG2,
+	MAX_OUT_HEIGHT_REG3,
+	MAX_OUT_HEIGHT_288,
+	MAX_OUT_HEIGHT_576,
+	MAX_OUT_HEIGHT_720,
+	MAX_OUT_HEIGHT_1080,
+};
+
 /*
  * VPDMA channel numbers
  */
@@ -198,11 +222,12 @@ void vpdma_add_sync_on_channel_ctd(struct vpdma_desc_list *list,
 void vpdma_add_out_dtd(struct vpdma_desc_list *list, int width,
 		const struct v4l2_rect *c_rect,
 		const struct vpdma_data_format *fmt, dma_addr_t dma_addr,
-		enum vpdma_channel chan, u32 flags);
+		int max_w, int max_h, enum vpdma_channel chan, u32 flags);
 void vpdma_rawchan_add_out_dtd(struct vpdma_desc_list *list, int width,
 		const struct v4l2_rect *c_rect,
 		const struct vpdma_data_format *fmt, dma_addr_t dma_addr,
-		int raw_vpdma_chan, u32 flags);
+		int max_w, int max_h, int raw_vpdma_chan, u32 flags);
+
 void vpdma_add_in_dtd(struct vpdma_desc_list *list, int width,
 		const struct v4l2_rect *c_rect,
 		const struct vpdma_data_format *fmt, dma_addr_t dma_addr,
@@ -221,6 +246,9 @@ void vpdma_set_line_mode(struct vpdma_data *vpdma, int line_mode,
 		enum vpdma_channel chan);
 void vpdma_set_frame_start_event(struct vpdma_data *vpdma,
 		enum vpdma_frame_start_event fs_event, enum vpdma_channel chan);
+void vpdma_set_max_size(struct vpdma_data *vpdma, int reg_addr,
+			u32 width, u32 height);
+
 void vpdma_set_bg_color(struct vpdma_data *vpdma,
 			struct vpdma_data_format *fmt, u32 color);
 void vpdma_dump_regs(struct vpdma_data *vpdma);
diff --git a/drivers/media/platform/ti-vpe/vpdma_priv.h b/drivers/media/platform/ti-vpe/vpdma_priv.h
index aeade5edc8ac..54b6aa866c74 100644
--- a/drivers/media/platform/ti-vpe/vpdma_priv.h
+++ b/drivers/media/platform/ti-vpe/vpdma_priv.h
@@ -28,6 +28,10 @@
 #define VPDMA_MAX_SIZE1		0x34
 #define VPDMA_MAX_SIZE2		0x38
 #define VPDMA_MAX_SIZE3		0x3c
+#define VPDMA_MAX_SIZE_WIDTH_MASK	0xffff
+#define VPDMA_MAX_SIZE_WIDTH_SHFT	16
+#define VPDMA_MAX_SIZE_HEIGHT_MASK	0xffff
+#define VPDMA_MAX_SIZE_HEIGHT_SHFT	0
 
 /* Interrupts */
 #define VPDMA_INT_CHAN_STAT(grp)	(0x40 + grp * 8)
@@ -227,42 +231,6 @@ struct vpdma_dtd {
 #define DTD_MAX_HEIGHT_MASK	0x07
 #define DTD_MAX_HEIGHT_SHFT	0
 
-/* max width configurations */
- /* unlimited width */
-#define	MAX_OUT_WIDTH_UNLIMITED		0
-/* as specified in max_size1 reg */
-#define MAX_OUT_WIDTH_REG1		1
-/* as specified in max_size2 reg */
-#define MAX_OUT_WIDTH_REG2		2
-/* as specified in max_size3 reg */
-#define	MAX_OUT_WIDTH_REG3		3
-/* maximum of 352 pixels as width */
-#define MAX_OUT_WIDTH_352		4
-/* maximum of 768 pixels as width */
-#define	MAX_OUT_WIDTH_768		5
-/* maximum of 1280 pixels width */
-#define	MAX_OUT_WIDTH_1280		6
-/* maximum of 1920 pixels as width */
-#define	MAX_OUT_WIDTH_1920		7
-
-/* max height configurations */
- /* unlimited height */
-#define	MAX_OUT_HEIGHT_UNLIMITED	0
-/* as specified in max_size1 reg */
-#define MAX_OUT_HEIGHT_REG1		1
-/* as specified in max_size2 reg */
-#define MAX_OUT_HEIGHT_REG2		2
-/* as specified in max_size3 reg */
-#define	MAX_OUT_HEIGHT_REG3		3
-/* maximum of 288 lines as height */
-#define MAX_OUT_HEIGHT_288		4
-/* maximum of 576 lines as height */
-#define	MAX_OUT_HEIGHT_576		5
-/* maximum of 720 lines as height */
-#define	MAX_OUT_HEIGHT_720		6
-/* maximum of 1080 lines as height */
-#define	MAX_OUT_HEIGHT_1080		7
-
 static inline u32 dtd_type_ctl_stride(int type, bool notify, int field,
 			bool one_d, bool even_line_skip, bool odd_line_skip,
 			int line_stride)
diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 17451237220c..9823ee368a01 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -44,6 +44,7 @@
 #include <media/videobuf2-dma-contig.h>
 
 #include "vpdma.h"
+#include "vpdma_priv.h"
 #include "vpe_regs.h"
 #include "sc.h"
 #include "csc.h"
@@ -1035,8 +1036,12 @@ static void add_out_dtd(struct vpe_ctx *ctx, int port)
 	if (q_data->flags & Q_DATA_MODE_TILED)
 		flags |= VPDMA_DATA_MODE_TILED;
 
+	vpdma_set_max_size(ctx->dev->vpdma, VPDMA_MAX_SIZE1,
+			   MAX_W, MAX_H);
+
 	vpdma_add_out_dtd(&ctx->desc_list, q_data->width, &q_data->c_rect,
-		vpdma_fmt, dma_addr, p_data->channel, flags);
+			  vpdma_fmt, dma_addr, MAX_OUT_WIDTH_REG1,
+			  MAX_OUT_HEIGHT_REG1, p_data->channel, flags);
 }
 
 static void add_in_dtd(struct vpe_ctx *ctx, int port)
-- 
2.9.0

