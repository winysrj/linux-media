Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38510 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751171AbdGMR5u (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 13:57:50 -0400
Subject: Re: [PATCH v2 09/14] v4l: vsp1: Add support for multiple LIF
 instances
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <20170626181226.29575-1-laurent.pinchart+renesas@ideasonboard.com>
 <20170626181226.29575-10-laurent.pinchart+renesas@ideasonboard.com>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <1a43853e-d33e-f990-255f-47e77fcc7573@ideasonboard.com>
Date: Thu, 13 Jul 2017 18:57:40 +0100
MIME-Version: 1.0
In-Reply-To: <20170626181226.29575-10-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 26/06/17 19:12, Laurent Pinchart wrote:
> The VSP2-DL instance (present in the H3 ES2.0 and M3-N SoCs) has two LIF
> instances. Adapt the driver infrastructure to support multiple LIFs.
> Support for multiple display pipelines will be added separately.
> 
> The change to the entity routing table removes the ability to connect
> the LIF output to the HGO or HGT histogram generators. This feature is
> only available on Gen2 hardware, isn't supported by the rest of the
> driver, and has no known use case, so this isn't an issue.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
This looks good.

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
>  drivers/media/platform/vsp1/vsp1.h        |  5 ++--
>  drivers/media/platform/vsp1/vsp1_drm.c    |  8 ++---
>  drivers/media/platform/vsp1/vsp1_drv.c    | 49 +++++++++++++++++++------------
>  drivers/media/platform/vsp1/vsp1_entity.c |  3 +-
>  drivers/media/platform/vsp1/vsp1_lif.c    |  5 ++--
>  drivers/media/platform/vsp1/vsp1_lif.h    |  2 +-
>  drivers/media/platform/vsp1/vsp1_regs.h   |  4 ++-
>  7 files changed, 46 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1.h b/drivers/media/platform/vsp1/vsp1.h
> index 73858a0ed35c..78ef838416b3 100644
> --- a/drivers/media/platform/vsp1/vsp1.h
> +++ b/drivers/media/platform/vsp1/vsp1.h
> @@ -41,11 +41,11 @@ struct vsp1_rwpf;
>  struct vsp1_sru;
>  struct vsp1_uds;
>  
> +#define VSP1_MAX_LIF		2
>  #define VSP1_MAX_RPF		5
>  #define VSP1_MAX_UDS		3
>  #define VSP1_MAX_WPF		4
>  
> -#define VSP1_HAS_LIF		(1 << 0)

I guess I can re-use this 'bit' for the Writeback prototype which used to be
BIT(9) (which is now the BRS)


>  #define VSP1_HAS_LUT		(1 << 1)
>  #define VSP1_HAS_SRU		(1 << 2)
>  #define VSP1_HAS_BRU		(1 << 3)
> @@ -61,6 +61,7 @@ struct vsp1_device_info {
>  	const char *model;
>  	unsigned int gen;
>  	unsigned int features;
> +	unsigned int lif_count;
>  	unsigned int rpf_count;
>  	unsigned int uds_count;
>  	unsigned int wpf_count;
> @@ -84,7 +85,7 @@ struct vsp1_device {
>  	struct vsp1_hgt *hgt;
>  	struct vsp1_hsit *hsi;
>  	struct vsp1_hsit *hst;
> -	struct vsp1_lif *lif;
> +	struct vsp1_lif *lif[VSP1_MAX_LIF];
>  	struct vsp1_lut *lut;
>  	struct vsp1_rwpf *rpf[VSP1_MAX_RPF];
>  	struct vsp1_sru *sru;
> diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
> index daaafe7885fa..4e1b893e8f51 100644
> --- a/drivers/media/platform/vsp1/vsp1_drm.c
> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> @@ -181,7 +181,7 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
>  		format.format.code);
>  
>  	format.pad = LIF_PAD_SINK;
> -	ret = v4l2_subdev_call(&vsp1->lif->entity.subdev, pad, set_fmt, NULL,
> +	ret = v4l2_subdev_call(&vsp1->lif[0]->entity.subdev, pad, set_fmt, NULL,
>  			       &format);
>  	if (ret < 0)
>  		return ret;
> @@ -599,15 +599,15 @@ int vsp1_drm_init(struct vsp1_device *vsp1)
>  
>  	vsp1->bru->entity.sink = &vsp1->wpf[0]->entity;
>  	vsp1->bru->entity.sink_pad = 0;
> -	vsp1->wpf[0]->entity.sink = &vsp1->lif->entity;
> +	vsp1->wpf[0]->entity.sink = &vsp1->lif[0]->entity;
>  	vsp1->wpf[0]->entity.sink_pad = 0;
>  
>  	list_add_tail(&vsp1->bru->entity.list_pipe, &pipe->entities);
>  	list_add_tail(&vsp1->wpf[0]->entity.list_pipe, &pipe->entities);
> -	list_add_tail(&vsp1->lif->entity.list_pipe, &pipe->entities);
> +	list_add_tail(&vsp1->lif[0]->entity.list_pipe, &pipe->entities);
>  
>  	pipe->bru = &vsp1->bru->entity;
> -	pipe->lif = &vsp1->lif->entity;
> +	pipe->lif = &vsp1->lif[0]->entity;
>  	pipe->output = vsp1->wpf[0];
>  	pipe->output->pipe = pipe;
>  	pipe->frame_end = vsp1_du_pipeline_frame_end;
> diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
> index c4f2ac61f7d2..e875982f02ae 100644
> --- a/drivers/media/platform/vsp1/vsp1_drv.c
> +++ b/drivers/media/platform/vsp1/vsp1_drv.c
> @@ -168,10 +168,13 @@ static int vsp1_uapi_create_links(struct vsp1_device *vsp1)
>  			return ret;
>  	}
>  
> -	if (vsp1->lif) {
> -		ret = media_create_pad_link(&vsp1->wpf[0]->entity.subdev.entity,
> +	for (i = 0; i < vsp1->info->lif_count; ++i) {
> +		if (!vsp1->lif[i])
> +			continue;
> +
> +		ret = media_create_pad_link(&vsp1->wpf[i]->entity.subdev.entity,
>  					    RWPF_PAD_SOURCE,
> -					    &vsp1->lif->entity.subdev.entity,
> +					    &vsp1->lif[i]->entity.subdev.entity,
>  					    LIF_PAD_SINK, 0);
>  		if (ret < 0)
>  			return ret;
> @@ -334,18 +337,23 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
>  	}
>  
>  	/*
> -	 * The LIF is only supported when used in conjunction with the DU, in
> +	 * The LIFs are only supported when used in conjunction with the DU, in
>  	 * which case the userspace API is disabled. If the userspace API is
> -	 * enabled skip the LIF, even when present.
> +	 * enabled skip the LIFs, even when present.
>  	 */
> -	if (vsp1->info->features & VSP1_HAS_LIF && !vsp1->info->uapi) {
> -		vsp1->lif = vsp1_lif_create(vsp1);
> -		if (IS_ERR(vsp1->lif)) {
> -			ret = PTR_ERR(vsp1->lif);
> -			goto done;
> -		}
> +	if (!vsp1->info->uapi) {
> +		for (i = 0; i < vsp1->info->lif_count; ++i) {
> +			struct vsp1_lif *lif;
> +
> +			lif = vsp1_lif_create(vsp1, i);
> +			if (IS_ERR(lif)) {
> +				ret = PTR_ERR(lif);
> +				goto done;
> +			}
>  
> -		list_add_tail(&vsp1->lif->entity.list_dev, &vsp1->entities);
> +			vsp1->lif[i] = lif;
> +			list_add_tail(&lif->entity.list_dev, &vsp1->entities);
> +		}
>  	}
>  
>  	if (vsp1->info->features & VSP1_HAS_LUT) {
> @@ -638,8 +646,8 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
>  		.version = VI6_IP_VERSION_MODEL_VSPD_GEN2,
>  		.model = "VSP1-D",
>  		.gen = 2,
> -		.features = VSP1_HAS_BRU | VSP1_HAS_HGO | VSP1_HAS_LIF
> -			  | VSP1_HAS_LUT,
> +		.features = VSP1_HAS_BRU | VSP1_HAS_HGO | VSP1_HAS_LUT,
> +		.lif_count = 1,
>  		.rpf_count = 4,
>  		.uds_count = 1,
>  		.wpf_count = 1,
> @@ -672,8 +680,8 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
>  		.version = VI6_IP_VERSION_MODEL_VSPD_V2H,
>  		.model = "VSP1V-D",
>  		.gen = 2,
> -		.features = VSP1_HAS_BRU | VSP1_HAS_CLU | VSP1_HAS_LUT
> -			  | VSP1_HAS_LIF,
> +		.features = VSP1_HAS_BRU | VSP1_HAS_CLU | VSP1_HAS_LUT,
> +		.lif_count = 1,
>  		.rpf_count = 4,
>  		.uds_count = 1,
>  		.wpf_count = 1,
> @@ -721,7 +729,8 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
>  		.version = VI6_IP_VERSION_MODEL_VSPD_GEN3,
>  		.model = "VSP2-D",
>  		.gen = 3,
> -		.features = VSP1_HAS_BRU | VSP1_HAS_LIF | VSP1_HAS_WPF_VFLIP,
> +		.features = VSP1_HAS_BRU | VSP1_HAS_WPF_VFLIP,
> +		.lif_count = 1,
>  		.rpf_count = 5,
>  		.wpf_count = 2,
>  		.num_bru_inputs = 5,
> @@ -729,7 +738,8 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
>  		.version = VI6_IP_VERSION_MODEL_VSPD_V3,
>  		.model = "VSP2-D",
>  		.gen = 3,
> -		.features = VSP1_HAS_BRS | VSP1_HAS_BRU | VSP1_HAS_LIF,
> +		.features = VSP1_HAS_BRS | VSP1_HAS_BRU,
> +		.lif_count = 1,
>  		.rpf_count = 5,
>  		.wpf_count = 1,
>  		.num_bru_inputs = 5,
> @@ -737,7 +747,8 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
>  		.version = VI6_IP_VERSION_MODEL_VSPDL_GEN3,
>  		.model = "VSP2-DL",
>  		.gen = 3,
> -		.features = VSP1_HAS_BRS | VSP1_HAS_BRU | VSP1_HAS_LIF,
> +		.features = VSP1_HAS_BRS | VSP1_HAS_BRU,
> +		.lif_count = 2,
>  		.rpf_count = 5,
>  		.wpf_count = 2,
>  		.num_bru_inputs = 5,
> diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
> index c06f7db093db..54de15095709 100644
> --- a/drivers/media/platform/vsp1/vsp1_entity.c
> +++ b/drivers/media/platform/vsp1/vsp1_entity.c
> @@ -468,7 +468,8 @@ static const struct vsp1_route vsp1_routes[] = {
>  	{ VSP1_ENTITY_HGT, 0, 0, { 0, }, 0 },
>  	VSP1_ENTITY_ROUTE(HSI),
>  	VSP1_ENTITY_ROUTE(HST),
> -	{ VSP1_ENTITY_LIF, 0, 0, { VI6_DPR_NODE_LIF, }, VI6_DPR_NODE_LIF },
> +	{ VSP1_ENTITY_LIF, 0, 0, { 0, }, 0 },
> +	{ VSP1_ENTITY_LIF, 1, 0, { 0, }, 0 },
>  	VSP1_ENTITY_ROUTE(LUT),
>  	VSP1_ENTITY_ROUTE_RPF(0),
>  	VSP1_ENTITY_ROUTE_RPF(1),
> diff --git a/drivers/media/platform/vsp1/vsp1_lif.c b/drivers/media/platform/vsp1/vsp1_lif.c
> index 702487f895b3..e6fa16d7fda8 100644
> --- a/drivers/media/platform/vsp1/vsp1_lif.c
> +++ b/drivers/media/platform/vsp1/vsp1_lif.c
> @@ -30,7 +30,7 @@
>  static inline void vsp1_lif_write(struct vsp1_lif *lif, struct vsp1_dl_list *dl,
>  				  u32 reg, u32 data)
>  {
> -	vsp1_dl_list_write(dl, reg, data);
> +	vsp1_dl_list_write(dl, reg + lif->entity.index * VI6_LIF_OFFSET, data);
>  }
>  
>  /* -----------------------------------------------------------------------------
> @@ -165,7 +165,7 @@ static const struct vsp1_entity_operations lif_entity_ops = {
>   * Initialization and Cleanup
>   */
>  
> -struct vsp1_lif *vsp1_lif_create(struct vsp1_device *vsp1)
> +struct vsp1_lif *vsp1_lif_create(struct vsp1_device *vsp1, unsigned int index)
>  {
>  	struct vsp1_lif *lif;
>  	int ret;
> @@ -176,6 +176,7 @@ struct vsp1_lif *vsp1_lif_create(struct vsp1_device *vsp1)
>  
>  	lif->entity.ops = &lif_entity_ops;
>  	lif->entity.type = VSP1_ENTITY_LIF;
> +	lif->entity.index = index;
>  
>  	/*
>  	 * The LIF is never exposed to userspace, but media entity registration
> diff --git a/drivers/media/platform/vsp1/vsp1_lif.h b/drivers/media/platform/vsp1/vsp1_lif.h
> index 7b35879028de..3417339379b1 100644
> --- a/drivers/media/platform/vsp1/vsp1_lif.h
> +++ b/drivers/media/platform/vsp1/vsp1_lif.h
> @@ -32,6 +32,6 @@ static inline struct vsp1_lif *to_lif(struct v4l2_subdev *subdev)
>  	return container_of(subdev, struct vsp1_lif, entity.subdev);
>  }
>  
> -struct vsp1_lif *vsp1_lif_create(struct vsp1_device *vsp1);
> +struct vsp1_lif *vsp1_lif_create(struct vsp1_device *vsp1, unsigned int index);
>  
>  #endif /* __VSP1_LIF_H__ */
> diff --git a/drivers/media/platform/vsp1/vsp1_regs.h b/drivers/media/platform/vsp1/vsp1_regs.h
> index ab439a60a100..007e2bbc26c0 100644
> --- a/drivers/media/platform/vsp1/vsp1_regs.h
> +++ b/drivers/media/platform/vsp1/vsp1_regs.h
> @@ -351,7 +351,7 @@
>  #define VI6_DPR_NODE_HST		30
>  #define VI6_DPR_NODE_HSI		31
>  #define VI6_DPR_NODE_BRS_IN(n)		(38 + (n))
> -#define VI6_DPR_NODE_LIF		55
> +#define VI6_DPR_NODE_LIF		55		/* Gen2 only */
>  #define VI6_DPR_NODE_WPF(n)		(56 + (n))
>  #define VI6_DPR_NODE_UNUSED		63
>  
> @@ -663,6 +663,8 @@
>   * LIF Control Registers
>   */
>  
> +#define VI6_LIF_OFFSET			(-0x100)
> +

Reverse order offsets ... lovely ...

>  #define VI6_LIF_CTRL			0x3b00
>  #define VI6_LIF_CTRL_OBTH_MASK		(0x7ff << 16)
>  #define VI6_LIF_CTRL_OBTH_SHIFT		16
> 
