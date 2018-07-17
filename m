Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:57494 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729907AbeGQVK1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Jul 2018 17:10:27 -0400
From: Kieran Bingham <kieran@ksquared.org.uk>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v5 08/11] media: vsp1: Add support for extended display list headers
Date: Tue, 17 Jul 2018 21:35:50 +0100
Message-Id: <4c12a88003d585ecc36054a6492357fdd4565d40.1531857988.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.6efe8ff8efecd736e2aab039b2cf34d43e849939.1531857988.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.6efe8ff8efecd736e2aab039b2cf34d43e849939.1531857988.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.6efe8ff8efecd736e2aab039b2cf34d43e849939.1531857988.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.6efe8ff8efecd736e2aab039b2cf34d43e849939.1531857988.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Extended display list headers allow pre and post command lists to be
executed by the VSP pipeline. This provides the base support for
features such as AUTO_FLD (for interlaced support) and AUTO_DISP (for
supporting continuous camera preview pipelines.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

---

v2:
 - remove __packed attributes

v5:
 - Rename vsp1_dl_ext_header field names
 - Rename @extended -> @extension
 - Remove unnecessary VI6_DL_SWAP changes
 - Rename @cmd_opcode -> @opcode
 - Drop unused @data_size field
 - Move iteration of WPF's inside vsp1_dlm_setup
 - Rename vsp1_dl_ext_cmd_header -> vsp1_pre_ext_dl_body
 - Rename vsp1_pre_ext_dl_body->cmd to vsp1_pre_ext_dl_body->opcode
 - Rename vsp1_dl_ext_header->reserved0 to vsp1_dl_ext_header->padding
 - vsp1_pre_ext_dl_body: Rename 'data' to 'address_set'
 - vsp1_pre_ext_dl_body: Add struct documentation
 - Document ordering of 16bit accesses for flags in vsp1_dl_ext_header

 drivers/media/platform/vsp1/vsp1.h      |   1 +-
 drivers/media/platform/vsp1/vsp1_dl.c   | 104 ++++++++++++++++++++++++-
 drivers/media/platform/vsp1/vsp1_dl.h   |  25 ++++++-
 drivers/media/platform/vsp1/vsp1_drv.c  |   4 +-
 drivers/media/platform/vsp1/vsp1_regs.h |   2 +-
 5 files changed, 132 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1.h b/drivers/media/platform/vsp1/vsp1.h
index f0d21cc8e9ab..56c62122a81a 100644
--- a/drivers/media/platform/vsp1/vsp1.h
+++ b/drivers/media/platform/vsp1/vsp1.h
@@ -53,6 +53,7 @@ struct vsp1_uif;
 #define VSP1_HAS_HGO		(1 << 7)
 #define VSP1_HAS_HGT		(1 << 8)
 #define VSP1_HAS_BRS		(1 << 9)
+#define VSP1_HAS_EXT_DL		(1 << 10)
 
 struct vsp1_device_info {
 	u32 version;
diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index 90e0a11c29b5..2fffe977aa35 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -22,6 +22,9 @@
 #define VSP1_DLH_INT_ENABLE		(1 << 1)
 #define VSP1_DLH_AUTO_START		(1 << 0)
 
+#define VSP1_DLH_EXT_PRE_CMD_EXEC	(1 << 9)
+#define VSP1_DLH_EXT_POST_CMD_EXEC	(1 << 8)
+
 struct vsp1_dl_header_list {
 	u32 num_bytes;
 	u32 addr;
@@ -34,12 +37,59 @@ struct vsp1_dl_header {
 	u32 flags;
 };
 
+/**
+ * struct vsp1_dl_ext_header - Extended display list header
+ * @padding: padding zero bytes for alignment
+ * @pre_ext_dl_num_cmd: number of pre-extended command bodies to parse
+ * @flags: enables or disables execution of the pre and post command
+ * @pre_ext_dl_plist: start address of pre-extended display list bodies
+ * @post_ext_dl_num_cmd: number of post-extended command bodies to parse
+ * @post_ext_dl_plist: start address of post-extended display list bodies
+ */
+struct vsp1_dl_ext_header {
+	u32 padding;
+
+	/*
+	 * The datasheet represents flags as stored before pre_ext_dl_num_cmd,
+	 * expecting 32-bit accesses. The flags are appropriate to the whole
+	 * header, not just the pre_ext command, and thus warrant being
+	 * separated out. Due to byte ordering, and representing as 16 bit
+	 * values here, the flags must be positioned after the
+	 * pre_ext_dl_num_cmd.
+	 */
+	u16 pre_ext_dl_num_cmd;
+	u16 flags;
+	u32 pre_ext_dl_plist;
+
+	u32 post_ext_dl_num_cmd;
+	u32 post_ext_dl_plist;
+};
+
+struct vsp1_dl_header_extended {
+	struct vsp1_dl_header header;
+	struct vsp1_dl_ext_header ext;
+};
+
 struct vsp1_dl_entry {
 	u32 addr;
 	u32 data;
 };
 
 /**
+ * struct vsp1_pre_ext_dl_body - Pre Extended Display List Body
+ * @opcode: Extended display list command operation code
+ * @flags: Pre-extended command flags. These are specific to each command
+ * @address_set: Source address set pointer. Must have 16 byte alignment
+ * @reserved: Zero bits for alignment.
+ */
+struct vsp1_pre_ext_dl_body {
+	u32 opcode;
+	u32 flags;
+	u32 address_set;
+	u32 reserved;
+};
+
+/**
  * struct vsp1_dl_body - Display list body
  * @list: entry in the display list list of bodies
  * @free: entry in the pool free body list
@@ -95,9 +145,12 @@ struct vsp1_dl_body_pool {
  * @list: entry in the display list manager lists
  * @dlm: the display list manager
  * @header: display list header
+ * @extension: extended display list header. NULL for normal lists
  * @dma: DMA address for the header
  * @body0: first display list body
  * @bodies: list of extra display list bodies
+ * @pre_cmd: pre command to be issued through extended dl header
+ * @post_cmd: post command to be issued through extended dl header
  * @has_chain: if true, indicates that there's a partition chain
  * @chain: entry in the display list partition chain
  * @internal: whether the display list is used for internal purpose
@@ -107,11 +160,15 @@ struct vsp1_dl_list {
 	struct vsp1_dl_manager *dlm;
 
 	struct vsp1_dl_header *header;
+	struct vsp1_dl_ext_header *extension;
 	dma_addr_t dma;
 
 	struct vsp1_dl_body *body0;
 	struct list_head bodies;
 
+	struct vsp1_dl_ext_cmd *pre_cmd;
+	struct vsp1_dl_ext_cmd *post_cmd;
+
 	bool has_chain;
 	struct list_head chain;
 
@@ -495,6 +552,14 @@ int vsp1_dl_list_add_chain(struct vsp1_dl_list *head,
 	return 0;
 }
 
+static void vsp1_dl_ext_cmd_fill_header(struct vsp1_dl_ext_cmd *cmd)
+{
+	cmd->cmds[0].opcode = cmd->opcode;
+	cmd->cmds[0].flags = cmd->flags;
+	cmd->cmds[0].address_set = cmd->data_dma;
+	cmd->cmds[0].reserved = 0;
+}
+
 static void vsp1_dl_list_fill_header(struct vsp1_dl_list *dl, bool is_last)
 {
 	struct vsp1_dl_manager *dlm = dl->dlm;
@@ -547,6 +612,27 @@ static void vsp1_dl_list_fill_header(struct vsp1_dl_list *dl, bool is_last)
 		 */
 		dl->header->flags = VSP1_DLH_INT_ENABLE;
 	}
+
+	if (!dl->extension)
+		return;
+
+	dl->extension->flags = 0;
+
+	if (dl->pre_cmd) {
+		dl->extension->pre_ext_dl_plist = dl->pre_cmd->cmd_dma;
+		dl->extension->pre_ext_dl_num_cmd = dl->pre_cmd->num_cmds;
+		dl->extension->flags |= VSP1_DLH_EXT_PRE_CMD_EXEC;
+
+		vsp1_dl_ext_cmd_fill_header(dl->pre_cmd);
+	}
+
+	if (dl->post_cmd) {
+		dl->extension->post_ext_dl_plist = dl->post_cmd->cmd_dma;
+		dl->extension->post_ext_dl_num_cmd = dl->post_cmd->num_cmds;
+		dl->extension->flags |= VSP1_DLH_EXT_POST_CMD_EXEC;
+
+		vsp1_dl_ext_cmd_fill_header(dl->post_cmd);
+	}
 }
 
 static bool vsp1_dl_list_hw_update_pending(struct vsp1_dl_manager *dlm)
@@ -736,9 +822,16 @@ unsigned int vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
 /* Hardware Setup */
 void vsp1_dlm_setup(struct vsp1_device *vsp1)
 {
+	unsigned int i;
 	u32 ctrl = (256 << VI6_DL_CTRL_AR_WAIT_SHIFT)
 		 | VI6_DL_CTRL_DC2 | VI6_DL_CTRL_DC1 | VI6_DL_CTRL_DC0
 		 | VI6_DL_CTRL_DLE;
+	u32 ext_dl = (0x02 << VI6_DL_EXT_CTRL_POLINT_SHIFT) |
+		      VI6_DL_EXT_CTRL_DLPRI | VI6_DL_EXT_CTRL_EXT;
+
+	if (vsp1_feature(vsp1, VSP1_HAS_EXT_DL))
+		for (i = 0; i < vsp1->info->wpf_count; ++i)
+			vsp1_write(vsp1, VI6_DL_EXT_CTRL(i), ext_dl);
 
 	vsp1_write(vsp1, VI6_DL_CTRL, ctrl);
 	vsp1_write(vsp1, VI6_DL_SWAP, VI6_DL_SWAP_LWS);
@@ -792,7 +885,11 @@ struct vsp1_dl_manager *vsp1_dlm_create(struct vsp1_device *vsp1,
 	 * memory. An extra body is allocated on top of the prealloc to account
 	 * for the cached body used by the vsp1_pipeline object.
 	 */
-	header_size = ALIGN(sizeof(struct vsp1_dl_header), 8);
+	header_size = vsp1_feature(vsp1, VSP1_HAS_EXT_DL) ?
+			sizeof(struct vsp1_dl_header_extended) :
+			sizeof(struct vsp1_dl_header);
+
+	header_size = ALIGN(header_size, 8);
 
 	dlm->pool = vsp1_dl_body_pool_create(vsp1, prealloc + 1,
 					     VSP1_DL_NUM_ENTRIES, header_size);
@@ -808,6 +905,11 @@ struct vsp1_dl_manager *vsp1_dlm_create(struct vsp1_device *vsp1,
 			return NULL;
 		}
 
+		/* The extended header immediately follows the header. */
+		if (vsp1_feature(vsp1, VSP1_HAS_EXT_DL))
+			dl->extension = (void *)dl->header
+				      + sizeof(*dl->header);
+
 		list_add_tail(&dl->list, &dlm->free);
 	}
 
diff --git a/drivers/media/platform/vsp1/vsp1_dl.h b/drivers/media/platform/vsp1/vsp1_dl.h
index 7dba0469c92e..afefd5bfa136 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.h
+++ b/drivers/media/platform/vsp1/vsp1_dl.h
@@ -20,6 +20,31 @@ struct vsp1_dl_manager;
 #define VSP1_DL_FRAME_END_COMPLETED		BIT(0)
 #define VSP1_DL_FRAME_END_INTERNAL		BIT(1)
 
+/**
+ * struct vsp1_dl_ext_cmd - Extended Display command
+ * @free: entry in the pool of free commands list
+ * @opcode: command type opcode
+ * @flags: flags used by the command
+ * @cmds: array of command bodies for this extended cmd
+ * @num_cmds: quantity of commands in @cmds array
+ * @cmd_dma: DMA address of the command body
+ * @data: memory allocation for command-specific data
+ * @data_dma: DMA address for command-specific data
+ */
+struct vsp1_dl_ext_cmd {
+	struct list_head free;
+
+	u8 opcode;
+	u32 flags;
+
+	struct vsp1_pre_ext_dl_body *cmds;
+	unsigned int num_cmds;
+	dma_addr_t cmd_dma;
+
+	void *data;
+	dma_addr_t data_dma;
+};
+
 void vsp1_dlm_setup(struct vsp1_device *vsp1);
 
 struct vsp1_dl_manager *vsp1_dlm_create(struct vsp1_device *vsp1,
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 3367c2ba990d..b6619c9c18bb 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -754,7 +754,7 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 		.version = VI6_IP_VERSION_MODEL_VSPD_GEN3,
 		.model = "VSP2-D",
 		.gen = 3,
-		.features = VSP1_HAS_BRU | VSP1_HAS_WPF_VFLIP,
+		.features = VSP1_HAS_BRU | VSP1_HAS_WPF_VFLIP | VSP1_HAS_EXT_DL,
 		.lif_count = 1,
 		.rpf_count = 5,
 		.uif_count = 1,
@@ -774,7 +774,7 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 		.version = VI6_IP_VERSION_MODEL_VSPDL_GEN3,
 		.model = "VSP2-DL",
 		.gen = 3,
-		.features = VSP1_HAS_BRS | VSP1_HAS_BRU,
+		.features = VSP1_HAS_BRS | VSP1_HAS_BRU | VSP1_HAS_EXT_DL,
 		.lif_count = 2,
 		.rpf_count = 5,
 		.uif_count = 2,
diff --git a/drivers/media/platform/vsp1/vsp1_regs.h b/drivers/media/platform/vsp1/vsp1_regs.h
index 0d249ff9f564..5ea9f9070cf3 100644
--- a/drivers/media/platform/vsp1/vsp1_regs.h
+++ b/drivers/media/platform/vsp1/vsp1_regs.h
@@ -72,7 +72,7 @@
 #define VI6_DL_SWAP_WDS			(1 << 1)
 #define VI6_DL_SWAP_BTS			(1 << 0)
 
-#define VI6_DL_EXT_CTRL			0x011c
+#define VI6_DL_EXT_CTRL(n)		(0x011c + (n) * 36)
 #define VI6_DL_EXT_CTRL_NWE		(1 << 16)
 #define VI6_DL_EXT_CTRL_POLINT_MASK	(0x3f << 8)
 #define VI6_DL_EXT_CTRL_POLINT_SHIFT	8
-- 
git-series 0.9.1
