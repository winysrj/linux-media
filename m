Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:45866 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387484AbeHBQta (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Aug 2018 12:49:30 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran@ksquared.org.uk>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: Re: [PATCH v5 09/11] media: vsp1: Provide support for extended command pools
Date: Thu, 02 Aug 2018 17:58:35 +0300
Message-ID: <5383123.6Vee3TadY2@avalon>
In-Reply-To: <8b2969c3371d9b132dd492cdddaf11d0bf5b659f.1531857988.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.6efe8ff8efecd736e2aab039b2cf34d43e849939.1531857988.git-series.kieran.bingham+renesas@ideasonboard.com> <8b2969c3371d9b132dd492cdddaf11d0bf5b659f.1531857988.git-series.kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Tuesday, 17 July 2018 23:35:51 EEST Kieran Bingham wrote:
> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> VSPD and VSP-DL devices can provide extended display lists supporting
> extended command display list objects.
> 
> These extended commands require their own dma memory areas for a header
> and body specific to the command type.
> 
> Implement a command pool to allocate all necessary memory in a single
> DMA allocation to reduce pressure on the TLB, and provide convenient
> re-usable command objects for the entities to utilise.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> ---
> v2:
>  - Fix spelling typo in commit message
>  - constify, and staticify the instantiation of vsp1_extended_commands
>  - s/autfld_cmds/autofld_cmds/
>  - staticify cmd pool functions (Thanks kbuild-bot)
> 
> v5:
>  - Rename vsp1_dl_ext_cmd_header -> vsp1_pre_ext_dl_body
>  - fixup vsp1_cmd_pool structure documentation
>  - Rename dlm->autofld_cmds dlm->cmdpool
>  - Separate out the instatiation of vsp1_extended_commands
>  - Move initialisation of lock, and lists in vsp1_dl_cmd_pool_create to
>    immediately after allocation
>  - simplify vsp1_dlm_get_autofld_cmd
>  - Rename vsp1_dl_get_autofld_cmd() to vsp1_dl_get_pre_cmd() and moved
>    to "Display List Extended Command Management" section of vsp1_dl
> 
>  drivers/media/platform/vsp1/vsp1_dl.c | 194 +++++++++++++++++++++++++++-
>  drivers/media/platform/vsp1/vsp1_dl.h |   3 +-
>  2 files changed, 197 insertions(+)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_dl.c
> b/drivers/media/platform/vsp1/vsp1_dl.c index 2fffe977aa35..d5b3c24d160c
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_dl.c
> +++ b/drivers/media/platform/vsp1/vsp1_dl.c
> @@ -141,6 +141,30 @@ struct vsp1_dl_body_pool {
>  };
> 
>  /**
> + * struct vsp1_cmd_pool - Display List commands pool
> + * @dma: DMA address of the entries
> + * @size: size of the full DMA memory pool in bytes
> + * @mem: CPU memory pointer for the pool
> + * @cmds: Array of command structures for the pool
> + * @free: Free pool entries
> + * @lock: Protects the free list
> + * @vsp1: the VSP1 device
> + */
> +struct vsp1_dl_cmd_pool {
> +	/* DMA allocation */
> +	dma_addr_t dma;
> +	size_t size;
> +	void *mem;
> +
> +	struct vsp1_dl_ext_cmd *cmds;
> +	struct list_head free;
> +
> +	spinlock_t lock;
> +
> +	struct vsp1_device *vsp1;
> +};
> +
> +/**
>   * struct vsp1_dl_list - Display list
>   * @list: entry in the display list manager lists
>   * @dlm: the display list manager
> @@ -186,6 +210,7 @@ struct vsp1_dl_list {
>   * @queued: list queued to the hardware (written to the DL registers)
>   * @pending: list waiting to be queued to the hardware
>   * @pool: body pool for the display list bodies
> + * @autofld_cmds: command pool to support auto-fld interlaced mode
>   */
>  struct vsp1_dl_manager {
>  	unsigned int index;
> @@ -199,6 +224,7 @@ struct vsp1_dl_manager {
>  	struct vsp1_dl_list *pending;
> 
>  	struct vsp1_dl_body_pool *pool;
> +	struct vsp1_dl_cmd_pool *cmdpool;
>  };
> 
>  /*
> ---------------------------------------------------------------------------
> -- @@ -362,6 +388,157 @@ void vsp1_dl_body_write(struct vsp1_dl_body *dlb,
> u32 reg, u32 data) }
> 
>  /*
> ---------------------------------------------------------------------------
> -- + * Display List Extended Command Management
> + */
> +
> +enum vsp1_extcmd_type {
> +	VSP1_EXTCMD_AUTODISP,
> +	VSP1_EXTCMD_AUTOFLD,
> +};
> +
> +struct vsp1_extended_command_info {
> +	u16 opcode;
> +	size_t body_size;
> +};
> +
> +static const struct vsp1_extended_command_info vsp1_extended_commands[] = {
> +	[VSP1_EXTCMD_AUTODISP] = { 0x02, 96 },
> +	[VSP1_EXTCMD_AUTOFLD]  = { 0x03, 160 },
> +};
> +
> +/**
> + * vsp1_dl_cmd_pool_create - Create a pool of commands from a single
> allocation + * @vsp1: The VSP1 device
> + * @type: The command pool type
> + * @num_cmds: The number of commands to allocate
> + *
> + * Allocate a pool of commands each with enough memory to contain the
> private + * data of each command. The allocation sizes are dependent upon
> the command + * type.
> + *
> + * Return a pointer to the pool on success or NULL if memory can't be
> allocated. + */
> +static struct vsp1_dl_cmd_pool *
> +vsp1_dl_cmd_pool_create(struct vsp1_device *vsp1, enum vsp1_extcmd_type
> type, +			unsigned int num_cmds)
> +{
> +	struct vsp1_dl_cmd_pool *pool;
> +	unsigned int i;
> +	size_t cmd_size;
> +
> +	pool = kzalloc(sizeof(*pool), GFP_KERNEL);
> +	if (!pool)
> +		return NULL;
> +
> +	spin_lock_init(&pool->lock);
> +	INIT_LIST_HEAD(&pool->free);
> +
> +	pool->cmds = kcalloc(num_cmds, sizeof(*pool->cmds), GFP_KERNEL);
> +	if (!pool->cmds) {
> +		kfree(pool);
> +		return NULL;
> +	}
> +
> +	cmd_size = sizeof(struct vsp1_pre_ext_dl_body) +
> +		   vsp1_extended_commands[type].body_size;
> +	cmd_size = ALIGN(cmd_size, 16);
> +
> +	pool->size = cmd_size * num_cmds;
> +	pool->mem = dma_alloc_wc(vsp1->bus_master, pool->size, &pool->dma,
> +				 GFP_KERNEL);
> +	if (!pool->mem) {
> +		kfree(pool->cmds);
> +		kfree(pool);
> +		return NULL;
> +	}
> +
> +	for (i = 0; i < num_cmds; ++i) {
> +		struct vsp1_dl_ext_cmd *cmd = &pool->cmds[i];
> +		size_t cmd_offset = i * cmd_size;
> +		/* data_offset must be 16 byte aligned for DMA. */
> +		size_t data_offset = sizeof(struct vsp1_pre_ext_dl_body) +
> +				     cmd_offset;
> +
> +		cmd->pool = pool;
> +		cmd->opcode = vsp1_extended_commands[type].opcode;
> +
> +		/*
> +		 * TODO: Auto-disp can utilise more than one extended body
> +		 * command per cmd.
> +		 */
> +		cmd->num_cmds = 1;
> +		cmd->cmds = pool->mem + cmd_offset;
> +		cmd->cmd_dma = pool->dma + cmd_offset;
> +
> +		cmd->data = pool->mem + data_offset;
> +		cmd->data_dma = pool->dma + data_offset;
> +
> +		list_add_tail(&cmd->free, &pool->free);
> +	}
> +
> +	return pool;
> +}
> +
> +static
> +struct vsp1_dl_ext_cmd *vsp1_dl_ext_cmd_get(struct vsp1_dl_cmd_pool *pool)
> +{
> +	struct vsp1_dl_ext_cmd *cmd = NULL;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&pool->lock, flags);
> +
> +	if (!list_empty(&pool->free)) {
> +		cmd = list_first_entry(&pool->free, struct vsp1_dl_ext_cmd,
> +				       free);
> +		list_del(&cmd->free);
> +	}
> +
> +	spin_unlock_irqrestore(&pool->lock, flags);
> +
> +	return cmd;
> +}
> +
> +static void vsp1_dl_ext_cmd_put(struct vsp1_dl_ext_cmd *cmd)
> +{
> +	unsigned long flags;
> +
> +	if (!cmd)
> +		return;
> +
> +	/* Reset flags, these mark data usage. */
> +	cmd->flags = 0;
> +
> +	spin_lock_irqsave(&cmd->pool->lock, flags);
> +	list_add_tail(&cmd->free, &cmd->pool->free);
> +	spin_unlock_irqrestore(&cmd->pool->lock, flags);
> +}
> +
> +static void vsp1_dl_ext_cmd_pool_destroy(struct vsp1_dl_cmd_pool *pool)
> +{
> +	if (!pool)
> +		return;
> +
> +	if (pool->mem)
> +		dma_free_wc(pool->vsp1->bus_master, pool->size, pool->mem,
> +			    pool->dma);
> +
> +	kfree(pool->cmds);
> +	kfree(pool);
> +}
> +
> +struct vsp1_dl_ext_cmd *vsp1_dl_get_pre_cmd(struct vsp1_dl_list *dl)
> +{
> +	struct vsp1_dl_manager *dlm = dl->dlm;
> +
> +	if (dl->pre_cmd)
> +		return dl->pre_cmd;
> +
> +	dl->pre_cmd = vsp1_dl_ext_cmd_get(dlm->cmdpool);
> +
> +	return dl->pre_cmd;
> +}
> +
> +/*
> ---------------------------------------------------------------------------
> - * Display List Transaction Management
>   */
> 
> @@ -463,6 +640,12 @@ static void __vsp1_dl_list_put(struct vsp1_dl_list *dl)
> 
>  	vsp1_dl_list_bodies_put(dl);
> 
> +	vsp1_dl_ext_cmd_put(dl->pre_cmd);
> +	vsp1_dl_ext_cmd_put(dl->post_cmd);
> +
> +	dl->pre_cmd = NULL;
> +	dl->post_cmd = NULL;
> +
>  	/*
>  	 * body0 is reused as as an optimisation as presently every display list
>  	 * has at least one body, thus we reinitialise the entries list.
> @@ -913,6 +1096,15 @@ struct vsp1_dl_manager *vsp1_dlm_create(struct
> vsp1_device *vsp1, list_add_tail(&dl->list, &dlm->free);
>  	}
> 
> +	if (vsp1_feature(vsp1, VSP1_HAS_EXT_DL)) {
> +		dlm->cmdpool = vsp1_dl_cmd_pool_create(vsp1,
> +					VSP1_EXTCMD_AUTOFLD, prealloc);
> +		if (!dlm->cmdpool) {
> +			vsp1_dlm_destroy(dlm);
> +			return NULL;
> +		}
> +	}
> +
>  	return dlm;
>  }
> 
> @@ -929,4 +1121,6 @@ void vsp1_dlm_destroy(struct vsp1_dl_manager *dlm)
>  	}
> 
>  	vsp1_dl_body_pool_destroy(dlm->pool);
> +	vsp1_dl_ext_cmd_pool_destroy(dlm->cmdpool);
>  }
> +

Extra blank line. Apart from that,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> diff --git a/drivers/media/platform/vsp1/vsp1_dl.h
> b/drivers/media/platform/vsp1/vsp1_dl.h index afefd5bfa136..125750dc8b5c
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_dl.h
> +++ b/drivers/media/platform/vsp1/vsp1_dl.h
> @@ -22,6 +22,7 @@ struct vsp1_dl_manager;
> 
>  /**
>   * struct vsp1_dl_ext_cmd - Extended Display command
> + * @pool: pool to which this command belongs
>   * @free: entry in the pool of free commands list
>   * @opcode: command type opcode
>   * @flags: flags used by the command
> @@ -32,6 +33,7 @@ struct vsp1_dl_manager;
>   * @data_dma: DMA address for command-specific data
>   */
>  struct vsp1_dl_ext_cmd {
> +	struct vsp1_dl_cmd_pool *pool;
>  	struct list_head free;
> 
>  	u8 opcode;
> @@ -58,6 +60,7 @@ struct vsp1_dl_body *vsp1_dlm_dl_body_get(struct
> vsp1_dl_manager *dlm); struct vsp1_dl_list *vsp1_dl_list_get(struct
> vsp1_dl_manager *dlm); void vsp1_dl_list_put(struct vsp1_dl_list *dl);
>  struct vsp1_dl_body *vsp1_dl_list_get_body0(struct vsp1_dl_list *dl);
> +struct vsp1_dl_ext_cmd *vsp1_dl_get_pre_cmd(struct vsp1_dl_list *dl);
>  void vsp1_dl_list_commit(struct vsp1_dl_list *dl, bool internal);
> 
>  struct vsp1_dl_body_pool *

-- 
Regards,

Laurent Pinchart
