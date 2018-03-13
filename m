Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:41770 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932387AbeCMSFz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 14:05:55 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 09/11] media: vsp1: Provide support for extended command pools
Date: Tue, 13 Mar 2018 19:05:25 +0100
Message-Id: <e9dac69c91be6e85c79d097be7c9e5f0e7241f83.1520963956.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.89a4a5175efbf31441ba717a99b0e3c31088179f.1520963956.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.89a4a5175efbf31441ba717a99b0e3c31088179f.1520963956.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.89a4a5175efbf31441ba717a99b0e3c31088179f.1520963956.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.89a4a5175efbf31441ba717a99b0e3c31088179f.1520963956.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

VSPD and VSP-DL devices can provide extended display lists supporting
extended command display list objects.

These extended commands require their own dma memory areas for a header
and body specific to the command type.

Implement a command pool to allocate all necessary memory in a single
DMA allocation to reduce pressure on the TLB, and provide convenient
re-usable command objects for the entities to utilise.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

---

v2:
 - Fix spelling typo in commit message
 - constify, and staticify the instantiation of vsp1_extended_commands
 - s/autfld_cmds/autofld_cmds/
 - staticify cmd pool functions (Thanks kbuild-bot)

 drivers/media/platform/vsp1/vsp1_dl.c | 190 +++++++++++++++++++++++++++-
 drivers/media/platform/vsp1/vsp1_dl.h |   3 +-
 2 files changed, 193 insertions(+)

diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index cd91b50deed1..d8392bd866f1 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -121,6 +121,30 @@ struct vsp1_dl_body_pool {
 };
 
 /**
+ * struct vsp1_cmd_pool - display list body pool
+ * @dma: DMA address of the entries
+ * @size: size of the full DMA memory pool in bytes
+ * @mem: CPU memory pointer for the pool
+ * @bodies: Array of DLB structures for the pool
+ * @free: List of free DLB entries
+ * @lock: Protects the pool and free list
+ * @vsp1: the VSP1 device
+ */
+struct vsp1_dl_cmd_pool {
+	/* DMA allocation */
+	dma_addr_t dma;
+	size_t size;
+	void *mem;
+
+	struct vsp1_dl_ext_cmd *cmds;
+	struct list_head free;
+
+	spinlock_t lock;
+
+	struct vsp1_device *vsp1;
+};
+
+/**
  * struct vsp1_dl_list - Display list
  * @list: entry in the display list manager lists
  * @dlm: the display list manager
@@ -163,6 +187,7 @@ struct vsp1_dl_list {
  * @queued: list queued to the hardware (written to the DL registers)
  * @pending: list waiting to be queued to the hardware
  * @pool: body pool for the display list bodies
+ * @autofld_cmds: command pool to support auto-fld interlaced mode
  */
 struct vsp1_dl_manager {
 	unsigned int index;
@@ -176,6 +201,7 @@ struct vsp1_dl_manager {
 	struct vsp1_dl_list *pending;
 
 	struct vsp1_dl_body_pool *pool;
+	struct vsp1_dl_cmd_pool *autofld_cmds;
 };
 
 /* -----------------------------------------------------------------------------
@@ -339,6 +365,139 @@ void vsp1_dl_body_write(struct vsp1_dl_body *dlb, u32 reg, u32 data)
 }
 
 /* -----------------------------------------------------------------------------
+ * Display List Extended Command Management
+ */
+
+enum vsp1_extcmd_type {
+	VSP1_EXTCMD_AUTODISP,
+	VSP1_EXTCMD_AUTOFLD,
+};
+
+struct vsp1_extended_command_info {
+	u16 opcode;
+	size_t body_size;
+} static const vsp1_extended_commands[] = {
+	[VSP1_EXTCMD_AUTODISP] = { 0x02, 96 },
+	[VSP1_EXTCMD_AUTOFLD]  = { 0x03, 160 },
+};
+
+/**
+ * vsp1_dl_cmd_pool_create - Create a pool of commands from a single allocation
+ * @vsp1: The VSP1 device
+ * @type: The command pool type
+ * @num_commands: The quantity of commands to allocate
+ *
+ * Allocate a pool of commands each with enough memory to contain the private
+ * data of each command. The allocation sizes are dependent upon the command
+ * type.
+ *
+ * Return a pointer to a pool on success or NULL if memory can't be allocated.
+ */
+static struct vsp1_dl_cmd_pool *
+vsp1_dl_cmd_pool_create(struct vsp1_device *vsp1, enum vsp1_extcmd_type type,
+			unsigned int num_cmds)
+{
+	struct vsp1_dl_cmd_pool *pool;
+	unsigned int i;
+	size_t cmd_size;
+
+	pool = kzalloc(sizeof(*pool), GFP_KERNEL);
+	if (!pool)
+		return NULL;
+
+	pool->cmds = kcalloc(num_cmds, sizeof(*pool->cmds), GFP_KERNEL);
+	if (!pool->cmds) {
+		kfree(pool);
+		return NULL;
+	}
+
+	cmd_size = sizeof(struct vsp1_dl_ext_cmd_header) +
+		   vsp1_extended_commands[type].body_size;
+	cmd_size = ALIGN(cmd_size, 16);
+
+	pool->size = cmd_size * num_cmds;
+	pool->mem = dma_alloc_wc(vsp1->bus_master, pool->size, &pool->dma,
+				 GFP_KERNEL);
+	if (!pool->mem) {
+		kfree(pool->cmds);
+		kfree(pool);
+		return NULL;
+	}
+
+	spin_lock_init(&pool->lock);
+	INIT_LIST_HEAD(&pool->free);
+
+	for (i = 0; i < num_cmds; ++i) {
+		struct vsp1_dl_ext_cmd *cmd = &pool->cmds[i];
+		size_t cmd_offset = i * cmd_size;
+		size_t data_offset = sizeof(struct vsp1_dl_ext_cmd_header) +
+				     cmd_offset;
+
+		cmd->pool = pool;
+		cmd->cmd_opcode = vsp1_extended_commands[type].opcode;
+
+		/* TODO: Auto-disp can utilise more than one command per cmd */
+		cmd->num_cmds = 1;
+		cmd->cmds = pool->mem + cmd_offset;
+		cmd->cmd_dma = pool->dma + cmd_offset;
+
+		cmd->data = pool->mem + data_offset;
+		cmd->data_dma = pool->dma + data_offset;
+		cmd->data_size = vsp1_extended_commands[type].body_size;
+
+		list_add_tail(&cmd->free, &pool->free);
+	}
+
+	return pool;
+}
+
+static struct vsp1_dl_ext_cmd *vsp1_dl_ext_cmd_get(struct vsp1_dl_cmd_pool *pool)
+{
+	struct vsp1_dl_ext_cmd *cmd = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pool->lock, flags);
+
+	if (!list_empty(&pool->free)) {
+		cmd = list_first_entry(&pool->free, struct vsp1_dl_ext_cmd,
+				       free);
+		list_del(&cmd->free);
+	}
+
+	spin_unlock_irqrestore(&pool->lock, flags);
+
+	return cmd;
+}
+
+static void vsp1_dl_ext_cmd_put(struct vsp1_dl_ext_cmd *cmd)
+{
+	unsigned long flags;
+
+	if (!cmd)
+		return;
+
+	/* Reset flags, these mark data usage */
+	cmd->flags = 0;
+
+	spin_lock_irqsave(&cmd->pool->lock, flags);
+	list_add_tail(&cmd->free, &cmd->pool->free);
+	spin_unlock_irqrestore(&cmd->pool->lock, flags);
+}
+
+static void vsp1_dl_ext_cmd_pool_destroy(struct vsp1_dl_cmd_pool *pool)
+{
+	if (!pool)
+		return;
+
+	if (pool->mem)
+		dma_free_wc(pool->vsp1->bus_master, pool->size, pool->mem,
+			    pool->dma);
+
+	kfree(pool->cmds);
+	kfree(pool);
+}
+
+/* ----------------------------------------------------------------------------
  * Display List Transaction Management
  */
 
@@ -442,6 +601,12 @@ static void __vsp1_dl_list_put(struct vsp1_dl_list *dl)
 
 	vsp1_dl_list_bodies_put(dl);
 
+	vsp1_dl_ext_cmd_put(dl->pre_cmd);
+	vsp1_dl_ext_cmd_put(dl->post_cmd);
+
+	dl->pre_cmd = NULL;
+	dl->post_cmd = NULL;
+
 	/*
 	 * body0 is reused as as an optimisation as presently every display list
 	 * has at least one body, thus we reinitialise the entries list
@@ -863,6 +1028,15 @@ struct vsp1_dl_manager *vsp1_dlm_create(struct vsp1_device *vsp1,
 		list_add_tail(&dl->list, &dlm->free);
 	}
 
+	if (vsp1_feature(vsp1, VSP1_HAS_EXT_DL)) {
+		dlm->autofld_cmds = vsp1_dl_cmd_pool_create(vsp1,
+					VSP1_EXTCMD_AUTOFLD, prealloc);
+		if (!dlm->autofld_cmds) {
+			vsp1_dlm_destroy(dlm);
+			return NULL;
+		}
+	}
+
 	return dlm;
 }
 
@@ -879,4 +1053,20 @@ void vsp1_dlm_destroy(struct vsp1_dl_manager *dlm)
 	}
 
 	vsp1_dl_body_pool_destroy(dlm->pool);
+	vsp1_dl_ext_cmd_pool_destroy(dlm->autofld_cmds);
+}
+
+struct vsp1_dl_ext_cmd *vsp1_dlm_get_autofld_cmd(struct vsp1_dl_list *dl)
+{
+	struct vsp1_dl_manager *dlm = dl->dlm;
+	struct vsp1_dl_ext_cmd *cmd;
+
+	if (dl->pre_cmd)
+		return dl->pre_cmd;
+
+	cmd = vsp1_dl_ext_cmd_get(dlm->autofld_cmds);
+	if (cmd)
+		dl->pre_cmd = cmd;
+
+	return cmd;
 }
diff --git a/drivers/media/platform/vsp1/vsp1_dl.h b/drivers/media/platform/vsp1/vsp1_dl.h
index 4898b21dc840..3009912ddefb 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.h
+++ b/drivers/media/platform/vsp1/vsp1_dl.h
@@ -23,6 +23,7 @@ struct vsp1_dl_manager;
 
 /**
  * struct vsp1_dl_ext_cmd - Extended Display command
+ * @pool: pool to which this command belongs
  * @free: entry in the pool of free commands list
  * @cmd_opcode: command type opcode
  * @flags: flags used by the command
@@ -34,6 +35,7 @@ struct vsp1_dl_manager;
  * @data_size: size of the @data_dma memory in bytes
  */
 struct vsp1_dl_ext_cmd {
+	struct vsp1_dl_cmd_pool *pool;
 	struct list_head free;
 
 	u8 cmd_opcode;
@@ -56,6 +58,7 @@ struct vsp1_dl_manager *vsp1_dlm_create(struct vsp1_device *vsp1,
 void vsp1_dlm_destroy(struct vsp1_dl_manager *dlm);
 void vsp1_dlm_reset(struct vsp1_dl_manager *dlm);
 bool vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm);
+struct vsp1_dl_ext_cmd *vsp1_dlm_get_autofld_cmd(struct vsp1_dl_list *dl);
 
 struct vsp1_dl_list *vsp1_dl_list_get(struct vsp1_dl_manager *dlm);
 void vsp1_dl_list_put(struct vsp1_dl_list *dl);
-- 
git-series 0.9.1
