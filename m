Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38053 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751157AbdGMNio (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 09:38:44 -0400
Subject: Re: [PATCH v2 07/14] v4l: vsp1: Add support for the BRS entity
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <20170626181226.29575-1-laurent.pinchart+renesas@ideasonboard.com>
 <20170626181226.29575-8-laurent.pinchart+renesas@ideasonboard.com>
Reply-To: kieran.bingham@ideasonboard.com
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <a89a37a8-ec11-cd50-5323-48510c11bcce@ideasonboard.com>
Date: Thu, 13 Jul 2017 14:38:40 +0100
MIME-Version: 1.0
In-Reply-To: <20170626181226.29575-8-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26/06/17 19:12, Laurent Pinchart wrote:
> The Blend/ROP Sub Unit (BRS) is a stripped-down version of the BRU found
> in several VSP2 instances. Compared to a regular BRU, it supports two
> inputs only, and thus has no ROP unit.
> 
> Add support for the BRS by modeling it as a new entity type, but reuse

s/modeling/modelling/


> the vsp1_bru object underneath. Chaining the BRU and BRS entities seems
> to be supported by the hardware but isn't implemented yet as it isn't
> the primary use case for the BRS.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
>  drivers/media/platform/vsp1/vsp1.h        |  2 +
>  drivers/media/platform/vsp1/vsp1_bru.c    | 45 ++++++++++++++--------
>  drivers/media/platform/vsp1/vsp1_bru.h    |  4 +-
>  drivers/media/platform/vsp1/vsp1_drv.c    | 19 +++++++++-
>  drivers/media/platform/vsp1/vsp1_entity.c | 13 ++++++-
>  drivers/media/platform/vsp1/vsp1_entity.h |  1 +
>  drivers/media/platform/vsp1/vsp1_pipe.c   |  7 ++--
>  drivers/media/platform/vsp1/vsp1_regs.h   | 26 +++++++++----
>  drivers/media/platform/vsp1/vsp1_video.c  | 63 ++++++++++++++++++++-----------
>  drivers/media/platform/vsp1/vsp1_wpf.c    |  4 +-
>  10 files changed, 130 insertions(+), 54 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1.h b/drivers/media/platform/vsp1/vsp1.h
> index 847963b6e9eb..73858a0ed35c 100644
> --- a/drivers/media/platform/vsp1/vsp1.h
> +++ b/drivers/media/platform/vsp1/vsp1.h
> @@ -54,6 +54,7 @@ struct vsp1_uds;
>  #define VSP1_HAS_WPF_HFLIP	(1 << 6)
>  #define VSP1_HAS_HGO		(1 << 7)
>  #define VSP1_HAS_HGT		(1 << 8)
> +#define VSP1_HAS_BRS		(1 << 9)
>  
>  struct vsp1_device_info {
>  	u32 version;
> @@ -76,6 +77,7 @@ struct vsp1_device {
>  	struct rcar_fcp_device *fcp;
>  	struct device *bus_master;
>  
> +	struct vsp1_bru *brs;
>  	struct vsp1_bru *bru;
>  	struct vsp1_clu *clu;
>  	struct vsp1_hgo *hgo;
> diff --git a/drivers/media/platform/vsp1/vsp1_bru.c b/drivers/media/platform/vsp1/vsp1_bru.c
> index 85362c5ef57a..e8fd2ae3b3eb 100644
> --- a/drivers/media/platform/vsp1/vsp1_bru.c
> +++ b/drivers/media/platform/vsp1/vsp1_bru.c
> @@ -33,7 +33,7 @@
>  static inline void vsp1_bru_write(struct vsp1_bru *bru, struct vsp1_dl_list *dl,
>  				  u32 reg, u32 data)
>  {
> -	vsp1_dl_list_write(dl, reg, data);
> +	vsp1_dl_list_write(dl, bru->base + reg, data);
>  }
>  
>  /* -----------------------------------------------------------------------------
> @@ -332,11 +332,14 @@ static void bru_configure(struct vsp1_entity *entity,
>  	/*
>  	 * Route BRU input 1 as SRC input to the ROP unit and configure the ROP
>  	 * unit with a NOP operation to make BRU input 1 available as the
> -	 * Blend/ROP unit B SRC input.
> +	 * Blend/ROP unit B SRC input. Only needed for BRU, the BRS has no ROP
> +	 * unit.
>  	 */
> -	vsp1_bru_write(bru, dl, VI6_BRU_ROP, VI6_BRU_ROP_DSTSEL_BRUIN(1) |
> -		       VI6_BRU_ROP_CROP(VI6_ROP_NOP) |
> -		       VI6_BRU_ROP_AROP(VI6_ROP_NOP));
> +	if (entity->type == VSP1_ENTITY_BRU)
> +		vsp1_bru_write(bru, dl, VI6_BRU_ROP,
> +			       VI6_BRU_ROP_DSTSEL_BRUIN(1) |
> +			       VI6_BRU_ROP_CROP(VI6_ROP_NOP) |
> +			       VI6_BRU_ROP_AROP(VI6_ROP_NOP));
>  
>  	for (i = 0; i < bru->entity.source_pad; ++i) {
>  		bool premultiplied = false;
> @@ -366,12 +369,13 @@ static void bru_configure(struct vsp1_entity *entity,
>  			ctrl |= VI6_BRU_CTRL_DSTSEL_VRPF;
>  
>  		/*
> -		 * Route BRU inputs 0 to 3 as SRC inputs to Blend/ROP units A to
> -		 * D in that order. The Blend/ROP unit B SRC is hardwired to the
> -		 * ROP unit output, the corresponding register bits must be set
> -		 * to 0.
> +		 * Route inputs 0 to 3 as SRC inputs to Blend/ROP units A to D
> +		 * in that order. In the BRU the Blend/ROP unit B SRC is
> +		 * hardwired to the ROP unit output, the corresponding register
> +		 * bits must be set to 0. The BRS has no ROP unit and doesn't
> +		 * need any special processing.
>  		 */
> -		if (i != 1)
> +		if (!(entity->type == VSP1_ENTITY_BRU && i == 1))

If we're using this module for both BRU and BRS, would an is_bru(entity) and
is_brs(entity) be cleaner here ?

Not required - just thinking outloud...

Actaully - it's only this line that would be affected so not really needed.  I
thought there would be more uses/differences.

>  			ctrl |= VI6_BRU_CTRL_SRCSEL_BRUIN(i);
>  
>  		vsp1_bru_write(bru, dl, VI6_BRU_CTRL(i), ctrl);
> @@ -407,20 +411,31 @@ static const struct vsp1_entity_operations bru_entity_ops = {
>   * Initialization and Cleanup
>   */
>  
> -struct vsp1_bru *vsp1_bru_create(struct vsp1_device *vsp1)
> +struct vsp1_bru *vsp1_bru_create(struct vsp1_device *vsp1,
> +				 enum vsp1_entity_type type)
>  {
>  	struct vsp1_bru *bru;
> +	unsigned int num_pads;
> +	const char *name;
>  	int ret;
>  
>  	bru = devm_kzalloc(vsp1->dev, sizeof(*bru), GFP_KERNEL);
>  	if (bru == NULL)
>  		return ERR_PTR(-ENOMEM);
>  
> +	bru->base = type == VSP1_ENTITY_BRU ? VI6_BRU_BASE : VI6_BRS_BASE;
>  	bru->entity.ops = &bru_entity_ops;
> -	bru->entity.type = VSP1_ENTITY_BRU;
> +	bru->entity.type = type;
> +
> +	if (type == VSP1_ENTITY_BRU) {
> +		num_pads = vsp1->info->num_bru_inputs + 1;
> +		name = "bru";
> +	} else {
> +		num_pads = 3;
> +		name = "brs";
> +	}
>  
> -	ret = vsp1_entity_init(vsp1, &bru->entity, "bru",
> -			       vsp1->info->num_bru_inputs + 1, &bru_ops,
> +	ret = vsp1_entity_init(vsp1, &bru->entity, name, num_pads, &bru_ops,
>  			       MEDIA_ENT_F_PROC_VIDEO_COMPOSER);
>  	if (ret < 0)
>  		return ERR_PTR(ret);
> @@ -435,7 +450,7 @@ struct vsp1_bru *vsp1_bru_create(struct vsp1_device *vsp1)
>  	bru->entity.subdev.ctrl_handler = &bru->ctrls;
>  
>  	if (bru->ctrls.error) {
> -		dev_err(vsp1->dev, "bru: failed to initialize controls\n");
> +		dev_err(vsp1->dev, "%s: failed to initialize controls\n", name);
>  		ret = bru->ctrls.error;
>  		vsp1_entity_destroy(&bru->entity);
>  		return ERR_PTR(ret);
> diff --git a/drivers/media/platform/vsp1/vsp1_bru.h b/drivers/media/platform/vsp1/vsp1_bru.h
> index 828a3fcadea8..c98ed96d8de6 100644
> --- a/drivers/media/platform/vsp1/vsp1_bru.h
> +++ b/drivers/media/platform/vsp1/vsp1_bru.h
> @@ -26,6 +26,7 @@ struct vsp1_rwpf;
>  
>  struct vsp1_bru {
>  	struct vsp1_entity entity;
> +	unsigned int base;
>  
>  	struct v4l2_ctrl_handler ctrls;
>  
> @@ -41,6 +42,7 @@ static inline struct vsp1_bru *to_bru(struct v4l2_subdev *subdev)
>  	return container_of(subdev, struct vsp1_bru, entity.subdev);
>  }
>  
> -struct vsp1_bru *vsp1_bru_create(struct vsp1_device *vsp1);
> +struct vsp1_bru *vsp1_bru_create(struct vsp1_device *vsp1,
> +				 enum vsp1_entity_type type);
>  
>  #endif /* __VSP1_BRU_H__ */
> diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
> index 5a467b118a1c..6a9aeb71aedf 100644
> --- a/drivers/media/platform/vsp1/vsp1_drv.c
> +++ b/drivers/media/platform/vsp1/vsp1_drv.c
> @@ -84,6 +84,10 @@ static irqreturn_t vsp1_irq_handler(int irq, void *data)
>   *
>   * - from a UDS to a UDS (UDS entities can't be chained)
>   * - from an entity to itself (no loops are allowed)
> + *
> + * Furthermore, the BRS can't be connected to histogram generators, but no
> + * special check is currently needed as all VSP instances that include a BRS
> + * have no histogram generator.
>   */
>  static int vsp1_create_sink_links(struct vsp1_device *vsp1,
>  				  struct vsp1_entity *sink)
> @@ -261,8 +265,18 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
>  	}
>  
>  	/* Instantiate all the entities. */
> +	if (vsp1->info->features & VSP1_HAS_BRS) {
> +		vsp1->brs = vsp1_bru_create(vsp1, VSP1_ENTITY_BRS);
> +		if (IS_ERR(vsp1->brs)) {
> +			ret = PTR_ERR(vsp1->brs);
> +			goto done;
> +		}
> +
> +		list_add_tail(&vsp1->brs->entity.list_dev, &vsp1->entities);
> +	}
> +
>  	if (vsp1->info->features & VSP1_HAS_BRU) {
> -		vsp1->bru = vsp1_bru_create(vsp1);
> +		vsp1->bru = vsp1_bru_create(vsp1, VSP1_ENTITY_BRU);
>  		if (IS_ERR(vsp1->bru)) {
>  			ret = PTR_ERR(vsp1->bru);
>  			goto done;
> @@ -502,6 +516,9 @@ static int vsp1_device_init(struct vsp1_device *vsp1)
>  	vsp1_write(vsp1, VI6_DPR_HSI_ROUTE, VI6_DPR_NODE_UNUSED);
>  	vsp1_write(vsp1, VI6_DPR_BRU_ROUTE, VI6_DPR_NODE_UNUSED);
>  
> +	if (vsp1->info->features & VSP1_HAS_BRS)
> +		vsp1_write(vsp1, VI6_DPR_ILV_BRS_ROUTE, VI6_DPR_NODE_UNUSED);
> +
>  	vsp1_write(vsp1, VI6_DPR_HGO_SMPPT, (7 << VI6_DPR_SMPPT_TGW_SHIFT) |
>  		   (VI6_DPR_NODE_UNUSED << VI6_DPR_SMPPT_PT_SHIFT));
>  	vsp1_write(vsp1, VI6_DPR_HGT_SMPPT, (7 << VI6_DPR_SMPPT_TGW_SHIFT) |
> diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
> index 71dd903263ad..c06f7db093db 100644
> --- a/drivers/media/platform/vsp1/vsp1_entity.c
> +++ b/drivers/media/platform/vsp1/vsp1_entity.c
> @@ -29,6 +29,7 @@ void vsp1_entity_route_setup(struct vsp1_entity *entity,
>  			     struct vsp1_dl_list *dl)
>  {
>  	struct vsp1_entity *source;
> +	u32 route;
>  
>  	if (entity->type == VSP1_ENTITY_HGO) {
>  		u32 smppt;
> @@ -62,8 +63,14 @@ void vsp1_entity_route_setup(struct vsp1_entity *entity,
>  	if (source->route->reg == 0)
>  		return;
>  
> -	vsp1_dl_list_write(dl, source->route->reg,
> -			   source->sink->route->inputs[source->sink_pad]);
> +	route = source->sink->route->inputs[source->sink_pad];
> +	/*
> +	 * The ILV and BRS share the same data path route. The extra BRSSEL bit
> +	 * selects between the ILV and BRS.
> +	 */
> +	if (source->type == VSP1_ENTITY_BRS)
> +		route |= VI6_DPR_ROUTE_BRSSEL;
> +	vsp1_dl_list_write(dl, source->route->reg, route);
>  }
>  
>  /* -----------------------------------------------------------------------------
> @@ -450,6 +457,8 @@ struct media_pad *vsp1_entity_remote_pad(struct media_pad *pad)
>  	  { VI6_DPR_NODE_WPF(idx) }, VI6_DPR_NODE_WPF(idx) }
>  
>  static const struct vsp1_route vsp1_routes[] = {
> +	{ VSP1_ENTITY_BRS, 0, VI6_DPR_ILV_BRS_ROUTE,
> +	  { VI6_DPR_NODE_BRS_IN(0), VI6_DPR_NODE_BRS_IN(1) }, 0 },
>  	{ VSP1_ENTITY_BRU, 0, VI6_DPR_BRU_ROUTE,
>  	  { VI6_DPR_NODE_BRU_IN(0), VI6_DPR_NODE_BRU_IN(1),
>  	    VI6_DPR_NODE_BRU_IN(2), VI6_DPR_NODE_BRU_IN(3),
> diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
> index 4362cd4e90ba..11f8363fa6b0 100644
> --- a/drivers/media/platform/vsp1/vsp1_entity.h
> +++ b/drivers/media/platform/vsp1/vsp1_entity.h
> @@ -23,6 +23,7 @@ struct vsp1_dl_list;
>  struct vsp1_pipeline;
>  
>  enum vsp1_entity_type {
> +	VSP1_ENTITY_BRS,
>  	VSP1_ENTITY_BRU,
>  	VSP1_ENTITY_CLU,
>  	VSP1_ENTITY_HGO,
> diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
> index e817623b84e0..9bb961298af2 100644
> --- a/drivers/media/platform/vsp1/vsp1_pipe.c
> +++ b/drivers/media/platform/vsp1/vsp1_pipe.c
> @@ -373,10 +373,11 @@ void vsp1_pipeline_propagate_alpha(struct vsp1_pipeline *pipe,
>  		return;
>  
>  	/*
> -	 * The BRU background color has a fixed alpha value set to 255, the
> -	 * output alpha value is thus always equal to 255.
> +	 * The BRU and BRS background color has a fixed alpha value set to 255,
> +	 * the output alpha value is thus always equal to 255.
>  	 */
> -	if (pipe->uds_input->type == VSP1_ENTITY_BRU)
> +	if (pipe->uds_input->type == VSP1_ENTITY_BRU ||
> +	    pipe->uds_input->type == VSP1_ENTITY_BRS)
>  		alpha = 255;
>  
>  	vsp1_uds_set_alpha(pipe->uds, dl, alpha);
> diff --git a/drivers/media/platform/vsp1/vsp1_regs.h b/drivers/media/platform/vsp1/vsp1_regs.h
> index cd3e32af6e3b..744217e020b9 100644
> --- a/drivers/media/platform/vsp1/vsp1_regs.h
> +++ b/drivers/media/platform/vsp1/vsp1_regs.h
> @@ -238,6 +238,10 @@
>  #define VI6_WPF_SRCRPF_VIRACT_SUB	(1 << 28)
>  #define VI6_WPF_SRCRPF_VIRACT_MST	(2 << 28)
>  #define VI6_WPF_SRCRPF_VIRACT_MASK	(3 << 28)
> +#define VI6_WPF_SRCRPF_VIRACT2_DIS	(0 << 24)
> +#define VI6_WPF_SRCRPF_VIRACT2_SUB	(1 << 24)
> +#define VI6_WPF_SRCRPF_VIRACT2_MST	(2 << 24)
> +#define VI6_WPF_SRCRPF_VIRACT2_MASK	(3 << 24)
>  #define VI6_WPF_SRCRPF_RPF_ACT_DIS(n)	(0 << ((n) * 2))
>  #define VI6_WPF_SRCRPF_RPF_ACT_SUB(n)	(1 << ((n) * 2))
>  #define VI6_WPF_SRCRPF_RPF_ACT_MST(n)	(2 << ((n) * 2))
> @@ -321,6 +325,8 @@
>  #define VI6_DPR_HST_ROUTE		0x2044
>  #define VI6_DPR_HSI_ROUTE		0x2048
>  #define VI6_DPR_BRU_ROUTE		0x204c
> +#define VI6_DPR_ILV_BRS_ROUTE		0x2050
> +#define VI6_DPR_ROUTE_BRSSEL		(1 << 28)
>  #define VI6_DPR_ROUTE_FXA_MASK		(0xff << 16)
>  #define VI6_DPR_ROUTE_FXA_SHIFT		16
>  #define VI6_DPR_ROUTE_FP_MASK		(0x3f << 8)
> @@ -344,6 +350,7 @@
>  #define VI6_DPR_NODE_CLU		29
>  #define VI6_DPR_NODE_HST		30
>  #define VI6_DPR_NODE_HSI		31
> +#define VI6_DPR_NODE_BRS_IN(n)		(38 + (n))
>  #define VI6_DPR_NODE_LIF		55
>  #define VI6_DPR_NODE_WPF(n)		(56 + (n))
>  #define VI6_DPR_NODE_UNUSED		63
> @@ -476,7 +483,7 @@
>  #define VI6_HSI_CTRL_EN			(1 << 0)
>  
>  /* -----------------------------------------------------------------------------
> - * BRU Control Registers
> + * BRS and BRU Control Registers
>   */
>  
>  #define VI6_ROP_NOP			0
> @@ -496,7 +503,10 @@
>  #define VI6_ROP_NAND			14
>  #define VI6_ROP_SET			15
>  
> -#define VI6_BRU_INCTRL			0x2c00
> +#define VI6_BRU_BASE			0x2c00
> +#define VI6_BRS_BASE			0x3900
> +
> +#define VI6_BRU_INCTRL			0x0000
>  #define VI6_BRU_INCTRL_NRM		(1 << 28)
>  #define VI6_BRU_INCTRL_DnON		(1 << (16 + (n)))
>  #define VI6_BRU_INCTRL_DITHn_OFF	(0 << ((n) * 4))
> @@ -508,19 +518,19 @@
>  #define VI6_BRU_INCTRL_DITHn_MASK	(7 << ((n) * 4))
>  #define VI6_BRU_INCTRL_DITHn_SHIFT	((n) * 4)
>  
> -#define VI6_BRU_VIRRPF_SIZE		0x2c04
> +#define VI6_BRU_VIRRPF_SIZE		0x0004
>  #define VI6_BRU_VIRRPF_SIZE_HSIZE_MASK	(0x1fff << 16)
>  #define VI6_BRU_VIRRPF_SIZE_HSIZE_SHIFT	16
>  #define VI6_BRU_VIRRPF_SIZE_VSIZE_MASK	(0x1fff << 0)
>  #define VI6_BRU_VIRRPF_SIZE_VSIZE_SHIFT	0
>  
> -#define VI6_BRU_VIRRPF_LOC		0x2c08
> +#define VI6_BRU_VIRRPF_LOC		0x0008
>  #define VI6_BRU_VIRRPF_LOC_HCOORD_MASK	(0x1fff << 16)
>  #define VI6_BRU_VIRRPF_LOC_HCOORD_SHIFT	16
>  #define VI6_BRU_VIRRPF_LOC_VCOORD_MASK	(0x1fff << 0)
>  #define VI6_BRU_VIRRPF_LOC_VCOORD_SHIFT	0
>  
> -#define VI6_BRU_VIRRPF_COL		0x2c0c
> +#define VI6_BRU_VIRRPF_COL		0x000c
>  #define VI6_BRU_VIRRPF_COL_A_MASK	(0xff << 24)
>  #define VI6_BRU_VIRRPF_COL_A_SHIFT	24
>  #define VI6_BRU_VIRRPF_COL_RCR_MASK	(0xff << 16)
> @@ -530,7 +540,7 @@
>  #define VI6_BRU_VIRRPF_COL_BCB_MASK	(0xff << 0)
>  #define VI6_BRU_VIRRPF_COL_BCB_SHIFT	0
>  
> -#define VI6_BRU_CTRL(n)			(0x2c10 + (n) * 8 + ((n) <= 3 ? 0 : 4))
> +#define VI6_BRU_CTRL(n)			(0x0010 + (n) * 8 + ((n) <= 3 ? 0 : 4))
>  #define VI6_BRU_CTRL_RBC		(1 << 31)
>  #define VI6_BRU_CTRL_DSTSEL_BRUIN(n)	(((n) <= 3 ? (n) : (n)+1) << 20)
>  #define VI6_BRU_CTRL_DSTSEL_VRPF	(4 << 20)
> @@ -543,7 +553,7 @@
>  #define VI6_BRU_CTRL_AROP(rop)		((rop) << 0)
>  #define VI6_BRU_CTRL_AROP_MASK		(0xf << 0)
>  
> -#define VI6_BRU_BLD(n)			(0x2c14 + (n) * 8 + ((n) <= 3 ? 0 : 4))
> +#define VI6_BRU_BLD(n)			(0x0014 + (n) * 8 + ((n) <= 3 ? 0 : 4))
>  #define VI6_BRU_BLD_CBES		(1 << 31)
>  #define VI6_BRU_BLD_CCMDX_DST_A		(0 << 28)
>  #define VI6_BRU_BLD_CCMDX_255_DST_A	(1 << 28)
> @@ -576,7 +586,7 @@
>  #define VI6_BRU_BLD_COEFY_MASK		(0xff << 0)
>  #define VI6_BRU_BLD_COEFY_SHIFT		0
>  
> -#define VI6_BRU_ROP			0x2c30
> +#define VI6_BRU_ROP			0x0030	/* Only available on BRU */
>  #define VI6_BRU_ROP_DSTSEL_BRUIN(n)	(((n) <= 3 ? (n) : (n)+1) << 20)
>  #define VI6_BRU_ROP_DSTSEL_VRPF		(4 << 20)
>  #define VI6_BRU_ROP_DSTSEL_MASK		(7 << 20)
> diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
> index 5af3486afe07..84139affb871 100644
> --- a/drivers/media/platform/vsp1/vsp1_video.c
> +++ b/drivers/media/platform/vsp1/vsp1_video.c
> @@ -481,7 +481,7 @@ static int vsp1_video_pipeline_build_branch(struct vsp1_pipeline *pipe,
>  	struct media_entity_enum ent_enum;
>  	struct vsp1_entity *entity;
>  	struct media_pad *pad;
> -	bool bru_found = false;
> +	struct vsp1_bru *bru = NULL;
>  	int ret;
>  
>  	ret = media_entity_enum_init(&ent_enum, &input->entity.vsp1->media_dev);
> @@ -511,16 +511,20 @@ static int vsp1_video_pipeline_build_branch(struct vsp1_pipeline *pipe,
>  			media_entity_to_v4l2_subdev(pad->entity));
>  
>  		/*
> -		 * A BRU is present in the pipeline, store the BRU input pad
> +		 * A BRU or BRS is present in the pipeline, store its input pad
>  		 * number in the input RPF for use when configuring the RPF.
>  		 */
> -		if (entity->type == VSP1_ENTITY_BRU) {
> -			struct vsp1_bru *bru = to_bru(&entity->subdev);
> +		if (entity->type == VSP1_ENTITY_BRU ||
> +		    entity->type == VSP1_ENTITY_BRS) {
> +			/* BRU and BRS can't be chained. */
> +			if (bru) {
> +				ret = -EPIPE;
> +				goto out;
> +			}
>  
> +			bru = to_bru(&entity->subdev);
>  			bru->inputs[pad->index].rpf = input;
>  			input->bru_input = pad->index;
> -
> -			bru_found = true;
>  		}
>  
>  		/* We've reached the WPF, we're done. */
> @@ -542,8 +546,7 @@ static int vsp1_video_pipeline_build_branch(struct vsp1_pipeline *pipe,
>  			}
>  
>  			pipe->uds = entity;
> -			pipe->uds_input = bru_found ? pipe->bru
> -					: &input->entity;
> +			pipe->uds_input = bru ? &bru->entity : &input->entity;
>  		}
>  
>  		/* Follow the source link, ignoring any HGO or HGT. */
> @@ -589,30 +592,42 @@ static int vsp1_video_pipeline_build(struct vsp1_pipeline *pipe,
>  		e = to_vsp1_entity(subdev);
>  		list_add_tail(&e->list_pipe, &pipe->entities);
>  
> -		if (e->type == VSP1_ENTITY_RPF) {
> +		switch (e->type) {
> +		case VSP1_ENTITY_RPF:
>  			rwpf = to_rwpf(subdev);
>  			pipe->inputs[rwpf->entity.index] = rwpf;
>  			rwpf->video->pipe_index = ++pipe->num_inputs;
>  			rwpf->pipe = pipe;
> -		} else if (e->type == VSP1_ENTITY_WPF) {
> +			break;
> +
> +		case VSP1_ENTITY_WPF:
>  			rwpf = to_rwpf(subdev);
>  			pipe->output = rwpf;
>  			rwpf->video->pipe_index = 0;
>  			rwpf->pipe = pipe;
> -		} else if (e->type == VSP1_ENTITY_LIF) {
> +			break;
> +
> +		case VSP1_ENTITY_LIF:
>  			pipe->lif = e;
> -		} else if (e->type == VSP1_ENTITY_BRU) {
> +			break;
> +
> +		case VSP1_ENTITY_BRU:
> +		case VSP1_ENTITY_BRS:
>  			pipe->bru = e;
> -		} else if (e->type == VSP1_ENTITY_HGO) {
> -			struct vsp1_hgo *hgo = to_hgo(subdev);
> +			break;
>  
> +		case VSP1_ENTITY_HGO:
>  			pipe->hgo = e;
> -			hgo->histo.pipe = pipe;
> -		} else if (e->type == VSP1_ENTITY_HGT) {
> -			struct vsp1_hgt *hgt = to_hgt(subdev);
> +			to_hgo(subdev)->histo.pipe = pipe;
> +			break;
>  
> +		case VSP1_ENTITY_HGT:
>  			pipe->hgt = e;
> -			hgt->histo.pipe = pipe;
> +			to_hgt(subdev)->histo.pipe = pipe;
> +			break;
> +
> +		default:
> +			break;
>  		}
>  	}
>  
> @@ -796,12 +811,14 @@ static int vsp1_video_setup_pipeline(struct vsp1_pipeline *pipe)
>  		struct vsp1_uds *uds = to_uds(&pipe->uds->subdev);
>  
>  		/*
> -		 * If a BRU is present in the pipeline before the UDS, the alpha
> -		 * component doesn't need to be scaled as the BRU output alpha
> -		 * value is fixed to 255. Otherwise we need to scale the alpha
> -		 * component only when available at the input RPF.
> +		 * If a BRU or BRS is present in the pipeline before the UDS,
> +		 * the alpha component doesn't need to be scaled as the BRU and
> +		 * BRS output alpha value is fixed to 255. Otherwise we need to
> +		 * scale the alpha component only when available at the input
> +		 * RPF.
>  		 */
> -		if (pipe->uds_input->type == VSP1_ENTITY_BRU) {
> +		if (pipe->uds_input->type == VSP1_ENTITY_BRU ||
> +		    pipe->uds_input->type == VSP1_ENTITY_BRS) {
>  			uds->scale_alpha = false;
>  		} else {
>  			struct vsp1_rwpf *rpf =
> diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
> index 32df109b119f..b6c902be225b 100644
> --- a/drivers/media/platform/vsp1/vsp1_wpf.c
> +++ b/drivers/media/platform/vsp1/vsp1_wpf.c
> @@ -453,7 +453,9 @@ static void wpf_configure(struct vsp1_entity *entity,
>  	}
>  
>  	if (pipe->bru || pipe->num_inputs > 1)
> -		srcrpf |= VI6_WPF_SRCRPF_VIRACT_MST;
> +		srcrpf |= pipe->bru->type == VSP1_ENTITY_BRU
> +			? VI6_WPF_SRCRPF_VIRACT_MST
> +			: VI6_WPF_SRCRPF_VIRACT2_MST;
>  
>  	vsp1_wpf_write(wpf, dl, VI6_WPF_SRCRPF, srcrpf);
>  
> 
