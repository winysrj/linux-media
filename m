Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:53669 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751592AbcKBX72 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 2 Nov 2016 19:59:28 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: Kieran Bingham <kbingham@kernel.org>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [RFC 2/3] v4l: vsp1: allow entities to have multiple source pads
Date: Thu, 03 Nov 2016 01:59:23 +0200
Message-ID: <10485514.ZeQkqvitYq@avalon>
In-Reply-To: <1477576885-21978-3-git-send-email-kieran.bingham+renesas@ideasonboard.com>
References: <1477576885-21978-1-git-send-email-kieran.bingham+renesas@ideasonboard.com> <1477576885-21978-3-git-send-email-kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Thursday 27 Oct 2016 15:01:24 Kieran Bingham wrote:
> The upcoming writeback feature of the VSP1 WPF, allows the active output
> of the DU to be written back to memory. On Generation 3 hardware, the DU
> is fed by the LIF, which is in turn fed by the WPF.
> 
> It is the WPF which will perform memory writeback functionality, and
> this brings in a second output of the entity. Configured in this mode,
> the WPF will output to both the LIF, and to a memory (V4L2 video)
> device.
> 
> Support this feature by extending vsp1_entity_init() to specify the
> number of source and sink pads.

Do we need this, can't we just connect the single WPF source pad to both the 
LIF and WPF output (video node) entities ?

> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> ---
>  drivers/media/platform/vsp1/vsp1_bru.c    |  2 +-
>  drivers/media/platform/vsp1/vsp1_clu.c    |  2 +-
>  drivers/media/platform/vsp1/vsp1_entity.c | 15 ++++++++-------
>  drivers/media/platform/vsp1/vsp1_entity.h |  3 ++-
>  drivers/media/platform/vsp1/vsp1_histo.c  |  2 +-
>  drivers/media/platform/vsp1/vsp1_hsit.c   |  2 +-
>  drivers/media/platform/vsp1/vsp1_lif.c    |  2 +-
>  drivers/media/platform/vsp1/vsp1_lut.c    |  2 +-
>  drivers/media/platform/vsp1/vsp1_rpf.c    |  2 +-
>  drivers/media/platform/vsp1/vsp1_sru.c    |  2 +-
>  drivers/media/platform/vsp1/vsp1_uds.c    |  2 +-
>  drivers/media/platform/vsp1/vsp1_wpf.c    |  2 +-
>  12 files changed, 20 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_bru.c
> b/drivers/media/platform/vsp1/vsp1_bru.c index ee8355c28f94..796bcc77eb44
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_bru.c
> +++ b/drivers/media/platform/vsp1/vsp1_bru.c
> @@ -411,7 +411,7 @@ struct vsp1_bru *vsp1_bru_create(struct vsp1_device
> *vsp1) bru->entity.type = VSP1_ENTITY_BRU;
> 
>  	ret = vsp1_entity_init(vsp1, &bru->entity, "bru",
> -			       vsp1->info->num_bru_inputs + 1, &bru_ops,
> +			       vsp1->info->num_bru_inputs, 1, &bru_ops,
>  			       MEDIA_ENT_F_PROC_VIDEO_COMPOSER);
>  	if (ret < 0)
>  		return ERR_PTR(ret);
> diff --git a/drivers/media/platform/vsp1/vsp1_clu.c
> b/drivers/media/platform/vsp1/vsp1_clu.c index f2fb26e5ab4e..b38692b1f0dd
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_clu.c
> +++ b/drivers/media/platform/vsp1/vsp1_clu.c
> @@ -283,7 +283,7 @@ struct vsp1_clu *vsp1_clu_create(struct vsp1_device
> *vsp1) clu->entity.ops = &clu_entity_ops;
>  	clu->entity.type = VSP1_ENTITY_CLU;
> 
> -	ret = vsp1_entity_init(vsp1, &clu->entity, "clu", 2, &clu_ops,
> +	ret = vsp1_entity_init(vsp1, &clu->entity, "clu", 1, 1, &clu_ops,
>  			       MEDIA_ENT_F_PROC_VIDEO_LUT);
>  	if (ret < 0)
>  		return ERR_PTR(ret);
> diff --git a/drivers/media/platform/vsp1/vsp1_entity.c
> b/drivers/media/platform/vsp1/vsp1_entity.c index
> 5263387f7ec7..72c99de6e3a4 100644
> --- a/drivers/media/platform/vsp1/vsp1_entity.c
> +++ b/drivers/media/platform/vsp1/vsp1_entity.c
> @@ -472,11 +472,13 @@ static const struct vsp1_route vsp1_routes[] = {
>  };
> 
>  int vsp1_entity_init(struct vsp1_device *vsp1, struct vsp1_entity *entity,
> -		     const char *name, unsigned int num_pads,
> +		     const char *name, unsigned int num_sink_pads,
> +		     unsigned int num_source_pads,
>  		     const struct v4l2_subdev_ops *ops, u32 function)
>  {
>  	struct v4l2_subdev *subdev;
>  	unsigned int i;
> +	unsigned int num_pads = num_sink_pads + num_source_pads;
>  	int ret;
> 
>  	for (i = 0; i < ARRAY_SIZE(vsp1_routes); ++i) {
> @@ -501,18 +503,17 @@ int vsp1_entity_init(struct vsp1_device *vsp1, struct
> vsp1_entity *entity, if (entity->pads == NULL)
>  		return -ENOMEM;
> 
> -	for (i = 0; i < num_pads - 1; ++i)
> +	for (i = 0; i < num_sink_pads; ++i)
>  		entity->pads[i].flags = MEDIA_PAD_FL_SINK;
> 
> -	entity->sources = devm_kcalloc(vsp1->dev, max(num_pads - 1, 1U),
> +	for (; i < num_pads; ++i)
> +		entity->pads[i].flags = MEDIA_PAD_FL_SOURCE;
> +
> +	entity->sources = devm_kcalloc(vsp1->dev, num_source_pads,
>  				       sizeof(*entity->sources), GFP_KERNEL);
>  	if (entity->sources == NULL)
>  		return -ENOMEM;
> 
> -	/* Single-pad entities only have a sink. */
> -	entity->pads[num_pads - 1].flags = num_pads > 1 ? MEDIA_PAD_FL_SOURCE
> -					 : MEDIA_PAD_FL_SINK;
> -
>  	/* Initialize the media entity. */
>  	ret = media_entity_pads_init(&entity->subdev.entity, num_pads,
>  				     entity->pads);
> diff --git a/drivers/media/platform/vsp1/vsp1_entity.h
> b/drivers/media/platform/vsp1/vsp1_entity.h index
> c169a060b6d2..c709c29eb994 100644
> --- a/drivers/media/platform/vsp1/vsp1_entity.h
> +++ b/drivers/media/platform/vsp1/vsp1_entity.h
> @@ -120,7 +120,8 @@ static inline struct vsp1_entity *to_vsp1_entity(struct
> v4l2_subdev *subdev) }
> 
>  int vsp1_entity_init(struct vsp1_device *vsp1, struct vsp1_entity *entity,
> -		     const char *name, unsigned int num_pads,
> +		     const char *name, unsigned int num_sink_pads,
> +		     unsigned int num_source_pads,
>  		     const struct v4l2_subdev_ops *ops, u32 function);
>  void vsp1_entity_destroy(struct vsp1_entity *entity);
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_histo.c
> b/drivers/media/platform/vsp1/vsp1_histo.c index e1d0d7236907..8d809afb3b09
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_histo.c
> +++ b/drivers/media/platform/vsp1/vsp1_histo.c
> @@ -589,7 +589,7 @@ int vsp1_histogram_init(struct vsp1_device *vsp1, struct
> vsp1_histogram *histo, histo->entity.ops = ops;
>  	histo->entity.type = type;
> 
> -	ret = vsp1_entity_init(vsp1, &histo->entity, name, 2, &histo_ops,
> +	ret = vsp1_entity_init(vsp1, &histo->entity, name, 1, 1, &histo_ops,
>  			       MEDIA_ENT_F_PROC_VIDEO_STATISTICS);
>  	if (ret < 0)
>  		return ret;
> diff --git a/drivers/media/platform/vsp1/vsp1_hsit.c
> b/drivers/media/platform/vsp1/vsp1_hsit.c index 94316afc54ff..6c54f2483248
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_hsit.c
> +++ b/drivers/media/platform/vsp1/vsp1_hsit.c
> @@ -173,7 +173,7 @@ struct vsp1_hsit *vsp1_hsit_create(struct vsp1_device
> *vsp1, bool inverse) hsit->entity.type = VSP1_ENTITY_HST;
> 
>  	ret = vsp1_entity_init(vsp1, &hsit->entity, inverse ? "hsi" : "hst",
> -			       2, &hsit_ops,
> +			       1, 1, &hsit_ops,
>  			       MEDIA_ENT_F_PROC_VIDEO_PIXEL_ENC_CONV);
>  	if (ret < 0)
>  		return ERR_PTR(ret);
> diff --git a/drivers/media/platform/vsp1/vsp1_lif.c
> b/drivers/media/platform/vsp1/vsp1_lif.c index e32acae1fc6e..c3f87879e0bf
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_lif.c
> +++ b/drivers/media/platform/vsp1/vsp1_lif.c
> @@ -180,7 +180,7 @@ struct vsp1_lif *vsp1_lif_create(struct vsp1_device
> *vsp1) * requires a function to be set. Use PROC_VIDEO_PIXEL_FORMATTER just
> to * avoid triggering a WARN_ON(), the value won't be seen anywhere. */
> -	ret = vsp1_entity_init(vsp1, &lif->entity, "lif", 2, &lif_ops,
> +	ret = vsp1_entity_init(vsp1, &lif->entity, "lif", 1, 1, &lif_ops,
>  			       MEDIA_ENT_F_PROC_VIDEO_PIXEL_FORMATTER);
>  	if (ret < 0)
>  		return ERR_PTR(ret);
> diff --git a/drivers/media/platform/vsp1/vsp1_lut.c
> b/drivers/media/platform/vsp1/vsp1_lut.c index c67cc60db0db..595f036f6476
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_lut.c
> +++ b/drivers/media/platform/vsp1/vsp1_lut.c
> @@ -239,7 +239,7 @@ struct vsp1_lut *vsp1_lut_create(struct vsp1_device
> *vsp1) lut->entity.ops = &lut_entity_ops;
>  	lut->entity.type = VSP1_ENTITY_LUT;
> 
> -	ret = vsp1_entity_init(vsp1, &lut->entity, "lut", 2, &lut_ops,
> +	ret = vsp1_entity_init(vsp1, &lut->entity, "lut", 1, 1, &lut_ops,
>  			       MEDIA_ENT_F_PROC_VIDEO_LUT);
>  	if (ret < 0)
>  		return ERR_PTR(ret);
> diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c
> b/drivers/media/platform/vsp1/vsp1_rpf.c index 03d71601bab6..427cbabf5c6a
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_rpf.c
> +++ b/drivers/media/platform/vsp1/vsp1_rpf.c
> @@ -274,7 +274,7 @@ struct vsp1_rwpf *vsp1_rpf_create(struct vsp1_device
> *vsp1, unsigned int index) rpf->entity.index = index;
> 
>  	sprintf(name, "rpf.%u", index);
> -	ret = vsp1_entity_init(vsp1, &rpf->entity, name, 2, &rpf_ops,
> +	ret = vsp1_entity_init(vsp1, &rpf->entity, name, 1, 1, &rpf_ops,
>  			       MEDIA_ENT_F_PROC_VIDEO_PIXEL_FORMATTER);
>  	if (ret < 0)
>  		return ERR_PTR(ret);
> diff --git a/drivers/media/platform/vsp1/vsp1_sru.c
> b/drivers/media/platform/vsp1/vsp1_sru.c index b4e568a3b4ed..404f9d484a2a
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_sru.c
> +++ b/drivers/media/platform/vsp1/vsp1_sru.c
> @@ -345,7 +345,7 @@ struct vsp1_sru *vsp1_sru_create(struct vsp1_device
> *vsp1) sru->entity.ops = &sru_entity_ops;
>  	sru->entity.type = VSP1_ENTITY_SRU;
> 
> -	ret = vsp1_entity_init(vsp1, &sru->entity, "sru", 2, &sru_ops,
> +	ret = vsp1_entity_init(vsp1, &sru->entity, "sru", 1, 1, &sru_ops,
>  			       MEDIA_ENT_F_PROC_VIDEO_SCALER);
>  	if (ret < 0)
>  		return ERR_PTR(ret);
> diff --git a/drivers/media/platform/vsp1/vsp1_uds.c
> b/drivers/media/platform/vsp1/vsp1_uds.c index da8f89a31ea4..777d68dfe1f8
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_uds.c
> +++ b/drivers/media/platform/vsp1/vsp1_uds.c
> @@ -366,7 +366,7 @@ struct vsp1_uds *vsp1_uds_create(struct vsp1_device
> *vsp1, unsigned int index) uds->entity.index = index;
> 
>  	sprintf(name, "uds.%u", index);
> -	ret = vsp1_entity_init(vsp1, &uds->entity, name, 2, &uds_ops,
> +	ret = vsp1_entity_init(vsp1, &uds->entity, name, 1, 1, &uds_ops,
>  			       MEDIA_ENT_F_PROC_VIDEO_SCALER);
>  	if (ret < 0)
>  		return ERR_PTR(ret);
> diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c
> b/drivers/media/platform/vsp1/vsp1_wpf.c index 958e7f215a2b..b5f44d6839c6
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_wpf.c
> +++ b/drivers/media/platform/vsp1/vsp1_wpf.c
> @@ -494,7 +494,7 @@ struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device
> *vsp1, unsigned int index) wpf->entity.index = index;
> 
>  	sprintf(name, "wpf.%u", index);
> -	ret = vsp1_entity_init(vsp1, &wpf->entity, name, 2, &wpf_ops,
> +	ret = vsp1_entity_init(vsp1, &wpf->entity, name, 1, 1, &wpf_ops,
>  			       MEDIA_ENT_F_PROC_VIDEO_PIXEL_FORMATTER);
>  	if (ret < 0)
>  		return ERR_PTR(ret);

-- 
Regards,

Laurent Pinchart

