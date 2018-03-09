Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39420 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932783AbeCIWEV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Mar 2018 17:04:21 -0500
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 08/11] media: vsp1: Add support for extended display list headers
Date: Fri,  9 Mar 2018 22:04:06 +0000
Message-Id: <5c9ae0101b81306fc368139e695392ba71c93b1f.1520632434.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.50cd35ac550b4477f13fb4f3fbd3ffb6bcccfc8a.1520632434.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.50cd35ac550b4477f13fb4f3fbd3ffb6bcccfc8a.1520632434.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.50cd35ac550b4477f13fb4f3fbd3ffb6bcccfc8a.1520632434.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.50cd35ac550b4477f13fb4f3fbd3ffb6bcccfc8a.1520632434.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Extended display list headers allow pre and post command lists to be
executed by the VSP pipeline. This provides the base support for
features such as AUTO_FLD (for interlaced support) and AUTO_DISP (for
supporting continuous camera preview pipelines.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1.h      |  1 +-
 drivers/media/platform/vsp1/vsp1_dl.c   | 83 +++++++++++++++++++++++++-
 drivers/media/platform/vsp1/vsp1_dl.h   | 29 ++++++++-
 drivers/media/platform/vsp1/vsp1_drv.c  |  7 +-
 drivers/media/platform/vsp1/vsp1_regs.h |  5 +-
 5 files changed, 116 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1.h b/drivers/media/platform/vsp1/vsp1.h
index 1c080538c993..bb3b32795206 100644
--- a/drivers/media/platform/vsp1/vsp1.h
+++ b/drivers/media/platform/vsp1/vsp1.h
@@ -55,6 +55,7 @@ struct vsp1_uds;
 #define VSP1_HAS_HGO		(1 << 7)
 #define VSP1_HAS_HGT		(1 << 8)
 #define VSP1_HAS_BRS		(1 << 9)
+#define VSP1_HAS_EXT_DL		(1 << 10)
 
 struct vsp1_device_info {
 	u32 version;
diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index dc273e3b4753..36440a2a2c8b 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -26,6 +26,9 @@
 #define VSP1_DLH_INT_ENABLE		(1 << 1)
 #define VSP1_DLH_AUTO_START		(1 << 0)
 
+#define VSP1_DLH_EXT_PRE_CMD_EXEC	(1 << 9)
+#define VSP1_DLH_EXT_POST_CMD_EXEC	(1 << 8)
+
 struct vsp1_dl_header_list {
 	u32 num_bytes;
 	u32 addr;
@@ -38,11 +41,34 @@ struct vsp1_dl_header {
 	u32 flags;
 } __packed;
 
+struct vsp1_dl_ext_header {
+	u32 reserved0;		/* alignment padding */
+
+	u16 pre_ext_cmd_qty;
+	u16 flags;
+	u32 pre_ext_cmd_plist;
+
+	u32 post_ext_cmd_qty;
+	u32 post_ext_cmd_plist;
+} __packed;
+
+struct vsp1_dl_header_extended {
+	struct vsp1_dl_header header;
+	struct vsp1_dl_ext_header ext;
+} __packed;
+
 struct vsp1_dl_entry {
 	u32 addr;
 	u32 data;
 } __packed;
 
+struct vsp1_dl_ext_cmd_header {
+	u32 cmd;
+	u32 flags;
+	u32 data;
+	u32 reserved;
+} __packed;
+
 /**
  * struct vsp1_dl_body - Display list body
  * @list: entry in the display list list of bodies
@@ -99,9 +125,12 @@ struct vsp1_dl_body_pool {
  * @list: entry in the display list manager lists
  * @dlm: the display list manager
  * @header: display list header
+ * @extended: extended display list header. NULL for normal lists
  * @dma: DMA address for the header
  * @body0: first display list body
  * @bodies: list of extra display list bodies
+ * @pre_cmd: pre cmd to be issued through extended dl header
+ * @post_cmd: post cmd to be issued through extended dl header
  * @has_chain: if true, indicates that there's a partition chain
  * @chain: entry in the display list partition chain
  */
@@ -110,11 +139,15 @@ struct vsp1_dl_list {
 	struct vsp1_dl_manager *dlm;
 
 	struct vsp1_dl_header *header;
+	struct vsp1_dl_ext_header *extended;
 	dma_addr_t dma;
 
 	struct vsp1_dl_body *body0;
 	struct list_head bodies;
 
+	struct vsp1_dl_ext_cmd *pre_cmd;
+	struct vsp1_dl_ext_cmd *post_cmd;
+
 	bool has_chain;
 	struct list_head chain;
 };
@@ -498,6 +531,14 @@ int vsp1_dl_list_add_chain(struct vsp1_dl_list *head,
 	return 0;
 }
 
+static void vsp1_dl_ext_cmd_fill_header(struct vsp1_dl_ext_cmd *cmd)
+{
+	cmd->cmds[0].cmd = cmd->cmd_opcode;
+	cmd->cmds[0].flags = cmd->flags;
+	cmd->cmds[0].data = cmd->data_dma;
+	cmd->cmds[0].reserved = 0;
+}
+
 static void vsp1_dl_list_fill_header(struct vsp1_dl_list *dl, bool is_last)
 {
 	struct vsp1_dl_manager *dlm = dl->dlm;
@@ -550,6 +591,27 @@ static void vsp1_dl_list_fill_header(struct vsp1_dl_list *dl, bool is_last)
 		 */
 		dl->header->flags = VSP1_DLH_INT_ENABLE;
 	}
+
+	if (!dl->extended)
+		return;
+
+	dl->extended->flags = 0;
+
+	if (dl->pre_cmd) {
+		dl->extended->pre_ext_cmd_plist = dl->pre_cmd->cmd_dma;
+		dl->extended->pre_ext_cmd_qty = dl->pre_cmd->num_cmds;
+		dl->extended->flags |= VSP1_DLH_EXT_PRE_CMD_EXEC;
+
+		vsp1_dl_ext_cmd_fill_header(dl->pre_cmd);
+	}
+
+	if (dl->post_cmd) {
+		dl->extended->pre_ext_cmd_plist = dl->post_cmd->cmd_dma;
+		dl->extended->pre_ext_cmd_qty = dl->post_cmd->num_cmds;
+		dl->extended->flags |= VSP1_DLH_EXT_POST_CMD_EXEC;
+
+		vsp1_dl_ext_cmd_fill_header(dl->pre_cmd);
+	}
 }
 
 static bool vsp1_dl_list_hw_update_pending(struct vsp1_dl_manager *dlm)
@@ -715,14 +777,20 @@ bool vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
 }
 
 /* Hardware Setup */
-void vsp1_dlm_setup(struct vsp1_device *vsp1)
+void vsp1_dlm_setup(struct vsp1_device *vsp1, unsigned int index)
 {
 	u32 ctrl = (256 << VI6_DL_CTRL_AR_WAIT_SHIFT)
 		 | VI6_DL_CTRL_DC2 | VI6_DL_CTRL_DC1 | VI6_DL_CTRL_DC0
 		 | VI6_DL_CTRL_DLE;
 
+	if (vsp1_feature(vsp1, VSP1_HAS_EXT_DL))
+		vsp1_write(vsp1, VI6_DL_EXT_CTRL(index),
+			   (0x02 << VI6_DL_EXT_CTRL_POLINT_SHIFT) |
+			   VI6_DL_EXT_CTRL_DLPRI | VI6_DL_EXT_CTRL_EXT);
+
 	vsp1_write(vsp1, VI6_DL_CTRL, ctrl);
-	vsp1_write(vsp1, VI6_DL_SWAP, VI6_DL_SWAP_LWS);
+	vsp1_write(vsp1, VI6_DL_SWAP(index), VI6_DL_SWAP_LWS |
+			 ((index == 1) ? VI6_DL_SWAP_IND : 0));
 }
 
 void vsp1_dlm_reset(struct vsp1_dl_manager *dlm)
@@ -767,7 +835,11 @@ struct vsp1_dl_manager *vsp1_dlm_create(struct vsp1_device *vsp1,
 	 * fragmentation, with the header located right after the body in
 	 * memory.
 	 */
-	header_size = ALIGN(sizeof(struct vsp1_dl_header), 8);
+	header_size = vsp1_feature(vsp1, VSP1_HAS_EXT_DL) ?
+			sizeof(struct vsp1_dl_header_extended) :
+			sizeof(struct vsp1_dl_header);
+
+	header_size = ALIGN(header_size, 8);
 
 	dlm->pool = vsp1_dl_body_pool_create(vsp1, prealloc,
 					     VSP1_DL_NUM_ENTRIES, header_size);
@@ -783,6 +855,11 @@ struct vsp1_dl_manager *vsp1_dlm_create(struct vsp1_device *vsp1,
 			return NULL;
 		}
 
+		/* The extended header immediately follows the header */
+		if (vsp1_feature(vsp1, VSP1_HAS_EXT_DL))
+			dl->extended = (void *)dl->header
+				     + sizeof(*dl->header);
+
 		list_add_tail(&dl->list, &dlm->free);
 	}
 
diff --git a/drivers/media/platform/vsp1/vsp1_dl.h b/drivers/media/platform/vsp1/vsp1_dl.h
index 5ad2cec5cad9..4898b21dc840 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.h
+++ b/drivers/media/platform/vsp1/vsp1_dl.h
@@ -21,7 +21,34 @@ struct vsp1_dl_body_pool;
 struct vsp1_dl_list;
 struct vsp1_dl_manager;
 
-void vsp1_dlm_setup(struct vsp1_device *vsp1);
+/**
+ * struct vsp1_dl_ext_cmd - Extended Display command
+ * @free: entry in the pool of free commands list
+ * @cmd_opcode: command type opcode
+ * @flags: flags used by the command
+ * @cmds: array of command bodies for this extended cmd
+ * @num_cmds: quantity of commands in @cmds array
+ * @cmd_dma: DMA address of the command bodies
+ * @data: memory allocation for command specific data
+ * @data_dma: DMA address for command specific data
+ * @data_size: size of the @data_dma memory in bytes
+ */
+struct vsp1_dl_ext_cmd {
+	struct list_head free;
+
+	u8 cmd_opcode;
+	u32 flags;
+
+	struct vsp1_dl_ext_cmd_header *cmds;
+	unsigned int num_cmds;
+	dma_addr_t cmd_dma;
+
+	void *data;
+	dma_addr_t data_dma;
+	size_t data_size;
+};
+
+void vsp1_dlm_setup(struct vsp1_device *vsp1, unsigned int index);
 
 struct vsp1_dl_manager *vsp1_dlm_create(struct vsp1_device *vsp1,
 					unsigned int index,
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 6fa0019ffc6e..73d9b1a44bdb 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -532,7 +532,8 @@ static int vsp1_device_init(struct vsp1_device *vsp1)
 	vsp1_write(vsp1, VI6_DPR_HGT_SMPPT, (7 << VI6_DPR_SMPPT_TGW_SHIFT) |
 		   (VI6_DPR_NODE_UNUSED << VI6_DPR_SMPPT_PT_SHIFT));
 
-	vsp1_dlm_setup(vsp1);
+	for (i = 0; i < vsp1->info->wpf_count; ++i)
+		vsp1_dlm_setup(vsp1, i);
 
 	return 0;
 }
@@ -741,7 +742,7 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 		.version = VI6_IP_VERSION_MODEL_VSPD_GEN3,
 		.model = "VSP2-D",
 		.gen = 3,
-		.features = VSP1_HAS_BRU | VSP1_HAS_WPF_VFLIP,
+		.features = VSP1_HAS_BRU | VSP1_HAS_WPF_VFLIP | VSP1_HAS_EXT_DL,
 		.lif_count = 1,
 		.rpf_count = 5,
 		.wpf_count = 2,
@@ -759,7 +760,7 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 		.version = VI6_IP_VERSION_MODEL_VSPDL_GEN3,
 		.model = "VSP2-DL",
 		.gen = 3,
-		.features = VSP1_HAS_BRS | VSP1_HAS_BRU,
+		.features = VSP1_HAS_BRS | VSP1_HAS_BRU | VSP1_HAS_EXT_DL,
 		.lif_count = 2,
 		.rpf_count = 5,
 		.wpf_count = 2,
diff --git a/drivers/media/platform/vsp1/vsp1_regs.h b/drivers/media/platform/vsp1/vsp1_regs.h
index dae0c1901297..43ad68ff3167 100644
--- a/drivers/media/platform/vsp1/vsp1_regs.h
+++ b/drivers/media/platform/vsp1/vsp1_regs.h
@@ -70,12 +70,13 @@
 
 #define VI6_DL_HDR_ADDR(n)		(0x0104 + (n) * 4)
 
-#define VI6_DL_SWAP			0x0114
+#define VI6_DL_SWAP(n)			(0x0114 + (n) * 56)
+#define VI6_DL_SWAP_IND			(1 << 31)
 #define VI6_DL_SWAP_LWS			(1 << 2)
 #define VI6_DL_SWAP_WDS			(1 << 1)
 #define VI6_DL_SWAP_BTS			(1 << 0)
 
-#define VI6_DL_EXT_CTRL			0x011c
+#define VI6_DL_EXT_CTRL(n)		(0x011c + (n) * 36)
 #define VI6_DL_EXT_CTRL_NWE		(1 << 16)
 #define VI6_DL_EXT_CTRL_POLINT_MASK	(0x3f << 8)
 #define VI6_DL_EXT_CTRL_POLINT_SHIFT	8
-- 
git-series 0.9.1
