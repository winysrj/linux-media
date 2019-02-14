Return-Path: <SRS0=jAfH=QV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2992FC10F04
	for <linux-media@archiver.kernel.org>; Thu, 14 Feb 2019 15:15:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC340222D7
	for <linux-media@archiver.kernel.org>; Thu, 14 Feb 2019 15:15:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394317AbfBNPPA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 14 Feb 2019 10:15:00 -0500
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:41865 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728674AbfBNPPA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Feb 2019 10:15:00 -0500
X-Originating-IP: 2.224.242.101
Received: from uno.localdomain (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 29C302000D;
        Thu, 14 Feb 2019 15:14:54 +0000 (UTC)
Date:   Thu, 14 Feb 2019 16:15:18 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Niklas =?utf-8?Q?S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 03/30] media: entity: Walk the graph based on pads
Message-ID: <20190214151518.ee3wkmrdc67ljp47@uno.localdomain>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
 <20181101233144.31507-4-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qcyn3pqgowzln5er"
Content-Disposition: inline
In-Reply-To: <20181101233144.31507-4-niklas.soderlund+renesas@ragnatech.se>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--qcyn3pqgowzln5er
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,
  as I anticipated to Sakari I would like to revive this series,
so I've started from V2 and I'm trying to close comments to re-submit.

In the meantime, I might have some more questions...

On Fri, Nov 02, 2018 at 12:31:17AM +0100, Niklas S=C3=B6derlund wrote:
> From: Sakari Ailus <sakari.ailus@linux.intel.com>
>
> Instead of iterating over graph entities during the walk, iterate the pads
> through which the entity was first reached. This is required in order to
> make the entity pipeline pad-based rather than entity based.
>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Reviewed-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  Documentation/media/kapi/mc-core.rst          |  7 ++-
>  drivers/media/media-entity.c                  | 46 ++++++++++--------
>  drivers/media/platform/exynos4-is/media-dev.c | 20 ++++----
>  drivers/media/platform/omap3isp/ispvideo.c    | 17 +++----
>  drivers/media/platform/vsp1/vsp1_video.c      | 12 ++---
>  drivers/media/platform/xilinx/xilinx-dma.c    | 12 ++---
>  drivers/media/v4l2-core/v4l2-mc.c             | 25 +++++-----
>  .../staging/media/davinci_vpfe/vpfe_video.c   | 47 ++++++++++---------
>  drivers/staging/media/omap4iss/iss_video.c    | 34 +++++++-------
>  include/media/media-entity.h                  |  7 +--
>  10 files changed, 122 insertions(+), 105 deletions(-)
>
> diff --git a/Documentation/media/kapi/mc-core.rst b/Documentation/media/k=
api/mc-core.rst
> index 27aefb9a778b2ad6..849b87439b7a9772 100644
> --- a/Documentation/media/kapi/mc-core.rst
> +++ b/Documentation/media/kapi/mc-core.rst
> @@ -167,8 +167,11 @@ Drivers initiate a graph traversal by calling
>  The graph structure, provided by the caller, is initialized to start gra=
ph
>  traversal at the given pad in an entity.
>
> -Drivers can then retrieve the next entity by calling
> -:c:func:`media_graph_walk_next()`
> +Drivers can then retrieve the next pad by calling
> +:c:func:`media_graph_walk_next()`. Only the pad through which the entity
> +is first reached is returned. If the caller is interested in knowing whi=
ch
> +further pads would be connected, the :c:func:`media_entity_has_route()`
> +function can be used for that.

I found this change confusing. Users of 'media_graph_walk_next()' should be
just notified they will iterate over pads, as one of pads of the next
reachable entity will be put on the stack (this function will always gives
you a pad in the "other entity", as it works on the entity's links)

I don't get what "Only the pad through which the entity is first reached is
returned" stands for here... care to clarify?

Also, the media_entity_has_route() function has not been introduced yet,
and its purpose is to verify if two pads in the same entity has internal
routing, and will be used to make sure the pad put on top of the
stack, is internally connected to the "local pad" link side, not to
get routes to pads in the "other entity".

Am I confused?
Thanks
  j

>
>  When the graph traversal is complete the function will return ``NULL``.
>
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index 892e64a0a9d8ec42..70db03fa33a21db1 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -349,9 +349,9 @@ static void media_graph_walk_iter(struct media_graph =
*graph)
>  		next->entity->name, next->index);
>  }
>
> -struct media_entity *media_graph_walk_next(struct media_graph *graph)
> +struct media_pad *media_graph_walk_next(struct media_graph *graph)
>  {
> -	struct media_entity *entity;
> +	struct media_pad *pad;
>
>  	if (stack_top(graph) =3D=3D NULL)
>  		return NULL;
> @@ -364,11 +364,11 @@ struct media_entity *media_graph_walk_next(struct m=
edia_graph *graph)
>  	while (link_top(graph) !=3D &stack_top(graph)->entity->links)
>  		media_graph_walk_iter(graph);
>
> -	entity =3D stack_pop(graph)->entity;
> -	dev_dbg(entity->graph_obj.mdev->dev,
> -		"walk: returning entity '%s'\n", entity->name);
> +	pad =3D stack_pop(graph);
> +	dev_dbg(pad->graph_obj.mdev->dev,
> +		"walk: returning pad '%s':%u\n", pad->entity->name, pad->index);
>
> -	return entity;
> +	return pad;
>  }
>  EXPORT_SYMBOL_GPL(media_graph_walk_next);
>
> @@ -416,7 +416,8 @@ __must_check int __media_pipeline_start(struct media_=
entity *entity,
>  {
>  	struct media_device *mdev =3D entity->graph_obj.mdev;
>  	struct media_graph *graph =3D &pipe->graph;
> -	struct media_entity *entity_err =3D entity;
> +	struct media_pad *pad =3D entity->pads;
> +	struct media_pad *pad_err =3D pad;
>  	struct media_link *link;
>  	int ret;
>
> @@ -426,9 +427,11 @@ __must_check int __media_pipeline_start(struct media=
_entity *entity,
>  			goto error_graph_walk_start;
>  	}
>
> -	media_graph_walk_start(&pipe->graph, entity->pads);
> +	media_graph_walk_start(&pipe->graph, pad);
> +
> +	while ((pad =3D media_graph_walk_next(graph))) {
> +		struct media_entity *entity =3D pad->entity;
>
> -	while ((entity =3D media_graph_walk_next(graph))) {
>  		DECLARE_BITMAP(active, MEDIA_ENTITY_MAX_PADS);
>  		DECLARE_BITMAP(has_no_links, MEDIA_ENTITY_MAX_PADS);
>
> @@ -452,11 +455,11 @@ __must_check int __media_pipeline_start(struct medi=
a_entity *entity,
>  		bitmap_fill(has_no_links, entity->num_pads);
>
>  		list_for_each_entry(link, &entity->links, list) {
> -			struct media_pad *pad =3D link->sink->entity =3D=3D entity
> -						? link->sink : link->source;
> +			struct media_pad *other_pad =3D link->sink->entity =3D=3D entity
> +				? link->sink : link->source;
>
>  			/* Mark that a pad is connected by a link. */
> -			bitmap_clear(has_no_links, pad->index, 1);
> +			bitmap_clear(has_no_links, other_pad->index, 1);
>
>  			/*
>  			 * Pads that either do not need to connect or
> @@ -465,13 +468,13 @@ __must_check int __media_pipeline_start(struct medi=
a_entity *entity,
>  			 */
>  			if (!(pad->flags & MEDIA_PAD_FL_MUST_CONNECT) ||
>  			    link->flags & MEDIA_LNK_FL_ENABLED)
> -				bitmap_set(active, pad->index, 1);
> +				bitmap_set(active, other_pad->index, 1);
>
>  			/*
>  			 * Link validation will only take place for
>  			 * sink ends of the link that are enabled.
>  			 */
> -			if (link->sink !=3D pad ||
> +			if (link->sink !=3D other_pad ||
>  			    !(link->flags & MEDIA_LNK_FL_ENABLED))
>  				continue;
>
> @@ -507,9 +510,11 @@ __must_check int __media_pipeline_start(struct media=
_entity *entity,
>  	 * Link validation on graph failed. We revert what we did and
>  	 * return the error.
>  	 */
> -	media_graph_walk_start(graph, entity_err->pads);
> +	media_graph_walk_start(graph, pad_err);
> +
> +	while ((pad_err =3D media_graph_walk_next(graph))) {
> +		struct media_entity *entity_err =3D pad_err->entity;
>
> -	while ((entity_err =3D media_graph_walk_next(graph))) {
>  		/* Sanity check for negative stream_count */
>  		if (!WARN_ON_ONCE(entity_err->stream_count <=3D 0)) {
>  			entity_err->stream_count--;
> @@ -521,7 +526,7 @@ __must_check int __media_pipeline_start(struct media_=
entity *entity,
>  		 * We haven't increased stream_count further than this
>  		 * so we quit here.
>  		 */
> -		if (entity_err =3D=3D entity)
> +		if (pad_err =3D=3D pad)
>  			break;
>  	}
>
> @@ -548,8 +553,9 @@ EXPORT_SYMBOL_GPL(media_pipeline_start);
>
>  void __media_pipeline_stop(struct media_entity *entity)
>  {
> -	struct media_graph *graph =3D &entity->pipe->graph;
>  	struct media_pipeline *pipe =3D entity->pipe;
> +	struct media_graph *graph =3D &pipe->graph;
> +	struct media_pad *pad;
>
>  	/*
>  	 * If the following check fails, the driver has performed an
> @@ -560,7 +566,9 @@ void __media_pipeline_stop(struct media_entity *entit=
y)
>
>  	media_graph_walk_start(graph, entity->pads);
>
> -	while ((entity =3D media_graph_walk_next(graph))) {
> +	while ((pad =3D media_graph_walk_next(graph))) {
> +		struct media_entity *entity =3D pad->entity;
> +
>  		/* Sanity check for negative stream_count */
>  		if (!WARN_ON_ONCE(entity->stream_count <=3D 0)) {
>  			entity->stream_count--;
> diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/medi=
a/platform/exynos4-is/media-dev.c
> index 51d2a571c06db6a3..5813639c63b56a2c 100644
> --- a/drivers/media/platform/exynos4-is/media-dev.c
> +++ b/drivers/media/platform/exynos4-is/media-dev.c
> @@ -1135,7 +1135,7 @@ static int __fimc_md_modify_pipeline(struct media_e=
ntity *entity, bool enable)
>  static int __fimc_md_modify_pipelines(struct media_entity *entity, bool =
enable,
>  				      struct media_graph *graph)
>  {
> -	struct media_entity *entity_err =3D entity;
> +	struct media_pad *pad, *pad_err =3D entity->pads;
>  	int ret;
>
>  	/*
> @@ -1144,13 +1144,13 @@ static int __fimc_md_modify_pipelines(struct medi=
a_entity *entity, bool enable,
>  	 * through active links. This is needed as we cannot power on/off the
>  	 * subdevs in random order.
>  	 */
> -	media_graph_walk_start(graph, entity->pads);
> +	media_graph_walk_start(graph, pad_err);
>
> -	while ((entity =3D media_graph_walk_next(graph))) {
> -		if (!is_media_entity_v4l2_video_device(entity))
> +	while ((pad =3D media_graph_walk_next(graph))) {
> +		if (!is_media_entity_v4l2_video_device(pad->entity))
>  			continue;
>
> -		ret  =3D __fimc_md_modify_pipeline(entity, enable);
> +		ret  =3D __fimc_md_modify_pipeline(pad->entity, enable);
>
>  		if (ret < 0)
>  			goto err;
> @@ -1159,15 +1159,15 @@ static int __fimc_md_modify_pipelines(struct medi=
a_entity *entity, bool enable,
>  	return 0;
>
>  err:
> -	media_graph_walk_start(graph, entity_err->pads);
> +	media_graph_walk_start(graph, pad_err);
>
> -	while ((entity_err =3D media_graph_walk_next(graph))) {
> -		if (!is_media_entity_v4l2_video_device(entity_err))
> +	while ((pad_err =3D media_graph_walk_next(graph))) {
> +		if (!is_media_entity_v4l2_video_device(pad_err->entity))
>  			continue;
>
> -		__fimc_md_modify_pipeline(entity_err, !enable);
> +		__fimc_md_modify_pipeline(pad_err->entity, !enable);
>
> -		if (entity_err =3D=3D entity)
> +		if (pad_err =3D=3D pad)
>  			break;
>  	}
>
> diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/p=
latform/omap3isp/ispvideo.c
> index 50ad35bc644eae29..dc11b732dc05b00b 100644
> --- a/drivers/media/platform/omap3isp/ispvideo.c
> +++ b/drivers/media/platform/omap3isp/ispvideo.c
> @@ -226,8 +226,8 @@ static int isp_video_get_graph_data(struct isp_video =
*video,
>  				    struct isp_pipeline *pipe)
>  {
>  	struct media_graph graph;
> -	struct media_entity *entity =3D &video->video.entity;
> -	struct media_device *mdev =3D entity->graph_obj.mdev;
> +	struct media_pad *pad =3D video->video.entity.pads;
> +	struct media_device *mdev =3D pad->entity->graph_obj.mdev;
>  	struct isp_video *far_end =3D NULL;
>  	int ret;
>
> @@ -238,23 +238,24 @@ static int isp_video_get_graph_data(struct isp_vide=
o *video,
>  		return ret;
>  	}
>
> -	media_graph_walk_start(&graph, entity->pads);
> +	media_graph_walk_start(&graph, pad);
>
> -	while ((entity =3D media_graph_walk_next(&graph))) {
> +	while ((pad =3D media_graph_walk_next(&graph))) {
>  		struct isp_video *__video;
>
> -		media_entity_enum_set(&pipe->ent_enum, entity);
> +		media_entity_enum_set(&pipe->ent_enum, pad->entity);
>
>  		if (far_end !=3D NULL)
>  			continue;
>
> -		if (entity =3D=3D &video->video.entity)
> +		if (pad =3D=3D video->video.entity.pads)
>  			continue;
>
> -		if (!is_media_entity_v4l2_video_device(entity))
> +		if (!is_media_entity_v4l2_video_device(pad->entity))
>  			continue;
>
> -		__video =3D to_isp_video(media_entity_to_video_device(entity));
> +		__video =3D to_isp_video(media_entity_to_video_device(
> +					       pad->entity));
>  		if (__video->type !=3D video->type)
>  			far_end =3D __video;
>  	}
> diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/pla=
tform/vsp1/vsp1_video.c
> index e35b2e2340b82f00..806825bd3484167a 100644
> --- a/drivers/media/platform/vsp1/vsp1_video.c
> +++ b/drivers/media/platform/vsp1/vsp1_video.c
> @@ -570,8 +570,8 @@ static int vsp1_video_pipeline_build(struct vsp1_pipe=
line *pipe,
>  				     struct vsp1_video *video)
>  {
>  	struct media_graph graph;
> -	struct media_entity *entity =3D &video->video.entity;
> -	struct media_device *mdev =3D entity->graph_obj.mdev;
> +	struct media_pad *pad =3D video->video.entity.pads;
> +	struct media_device *mdev =3D pad->entity->graph_obj.mdev;
>  	unsigned int i;
>  	int ret;
>
> @@ -580,17 +580,17 @@ static int vsp1_video_pipeline_build(struct vsp1_pi=
peline *pipe,
>  	if (ret)
>  		return ret;
>
> -	media_graph_walk_start(&graph, entity->pads);
> +	media_graph_walk_start(&graph, pad);
>
> -	while ((entity =3D media_graph_walk_next(&graph))) {
> +	while ((pad =3D media_graph_walk_next(&graph))) {
>  		struct v4l2_subdev *subdev;
>  		struct vsp1_rwpf *rwpf;
>  		struct vsp1_entity *e;
>
> -		if (!is_media_entity_v4l2_subdev(entity))
> +		if (!is_media_entity_v4l2_subdev(pad->entity))
>  			continue;
>
> -		subdev =3D media_entity_to_v4l2_subdev(entity);
> +		subdev =3D media_entity_to_v4l2_subdev(pad->entity);
>  		e =3D to_vsp1_entity(subdev);
>  		list_add_tail(&e->list_pipe, &pipe->entities);
>  		e->pipe =3D pipe;
> diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/p=
latform/xilinx/xilinx-dma.c
> index 566c2d0fb97dc162..a2a329336243bdc7 100644
> --- a/drivers/media/platform/xilinx/xilinx-dma.c
> +++ b/drivers/media/platform/xilinx/xilinx-dma.c
> @@ -178,8 +178,8 @@ static int xvip_pipeline_validate(struct xvip_pipelin=
e *pipe,
>  				  struct xvip_dma *start)
>  {
>  	struct media_graph graph;
> -	struct media_entity *entity =3D &start->video.entity;
> -	struct media_device *mdev =3D entity->graph_obj.mdev;
> +	struct media_pad *pad =3D start->video.entity.pads;
> +	struct media_device *mdev =3D pad->entity->graph_obj.mdev;
>  	unsigned int num_inputs =3D 0;
>  	unsigned int num_outputs =3D 0;
>  	int ret;
> @@ -193,15 +193,15 @@ static int xvip_pipeline_validate(struct xvip_pipel=
ine *pipe,
>  		return ret;
>  	}
>
> -	media_graph_walk_start(&graph, entity->pads);
> +	media_graph_walk_start(&graph, pad);
>
> -	while ((entity =3D media_graph_walk_next(&graph))) {
> +	while ((pad =3D media_graph_walk_next(&graph))) {
>  		struct xvip_dma *dma;
>
> -		if (entity->function !=3D MEDIA_ENT_F_IO_V4L)
> +		if (pad->entity->function !=3D MEDIA_ENT_F_IO_V4L)
>  			continue;
>
> -		dma =3D to_xvip_dma(media_entity_to_video_device(entity));
> +		dma =3D to_xvip_dma(media_entity_to_video_device(pad->entity));
>
>  		if (dma->pad.flags & MEDIA_PAD_FL_SINK) {
>  			pipe->output =3D dma;
> diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/=
v4l2-mc.c
> index 9ed480fe5b6e4762..98edd47b2f0ae747 100644
> --- a/drivers/media/v4l2-core/v4l2-mc.c
> +++ b/drivers/media/v4l2-core/v4l2-mc.c
> @@ -339,13 +339,14 @@ EXPORT_SYMBOL_GPL(v4l_vb2q_enable_media_source);
>  static int pipeline_pm_use_count(struct media_entity *entity,
>  	struct media_graph *graph)
>  {
> +	struct media_pad *pad;
>  	int use =3D 0;
>
>  	media_graph_walk_start(graph, entity->pads);
>
> -	while ((entity =3D media_graph_walk_next(graph))) {
> -		if (is_media_entity_v4l2_video_device(entity))
> -			use +=3D entity->use_count;
> +	while ((pad =3D media_graph_walk_next(graph))) {
> +		if (is_media_entity_v4l2_video_device(pad->entity))
> +			use +=3D pad->entity->use_count;
>  	}
>
>  	return use;
> @@ -398,7 +399,7 @@ static int pipeline_pm_power_one(struct media_entity =
*entity, int change)
>  static int pipeline_pm_power(struct media_entity *entity, int change,
>  	struct media_graph *graph)
>  {
> -	struct media_entity *first =3D entity;
> +	struct media_pad *tmp_pad, *pad;
>  	int ret =3D 0;
>
>  	if (!change)
> @@ -406,19 +407,19 @@ static int pipeline_pm_power(struct media_entity *e=
ntity, int change,
>
>  	media_graph_walk_start(graph, entity->pads);
>
> -	while (!ret && (entity =3D media_graph_walk_next(graph)))
> -		if (is_media_entity_v4l2_subdev(entity))
> -			ret =3D pipeline_pm_power_one(entity, change);
> +	while (!ret && (pad =3D media_graph_walk_next(graph)))
> +		if (is_media_entity_v4l2_subdev(pad->entity))
> +			ret =3D pipeline_pm_power_one(pad->entity, change);
>
>  	if (!ret)
>  		return ret;
>
> -	media_graph_walk_start(graph, first->pads);
> +	media_graph_walk_start(graph, entity->pads);
>
> -	while ((first =3D media_graph_walk_next(graph))
> -	       && first !=3D entity)
> -		if (is_media_entity_v4l2_subdev(first))
> -			pipeline_pm_power_one(first, -change);
> +	while ((tmp_pad =3D media_graph_walk_next(graph))
> +	       && tmp_pad !=3D pad)
> +		if (is_media_entity_v4l2_subdev(tmp_pad->entity))
> +			pipeline_pm_power_one(tmp_pad->entity, -change);
>
>  	return ret;
>  }
> diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/st=
aging/media/davinci_vpfe/vpfe_video.c
> index 912d93fc7a483cd4..5219a0372d140f4a 100644
> --- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
> +++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
> @@ -130,8 +130,8 @@ __vpfe_video_get_format(struct vpfe_video_device *vid=
eo,
>  static int vpfe_prepare_pipeline(struct vpfe_video_device *video)
>  {
>  	struct media_graph graph;
> -	struct media_entity *entity =3D &video->video_dev.entity;
> -	struct media_device *mdev =3D entity->graph_obj.mdev;
> +	struct media_pad *pad =3D video->video_dev.entity.pads;
> +	struct media_device *mdev =3D pad->entity->graph_obj.mdev;
>  	struct vpfe_pipeline *pipe =3D &video->pipe;
>  	struct vpfe_video_device *far_end =3D NULL;
>  	int ret;
> @@ -150,13 +150,14 @@ static int vpfe_prepare_pipeline(struct vpfe_video_=
device *video)
>  		mutex_unlock(&mdev->graph_mutex);
>  		return -ENOMEM;
>  	}
> -	media_graph_walk_start(&graph, entity->pads);
> -	while ((entity =3D media_graph_walk_next(&graph))) {
> -		if (entity =3D=3D &video->video_dev.entity)
> +	media_graph_walk_start(&graph, pad);
> +	while ((pad =3D media_graph_walk_next(&graph))) {
> +		if (pad->entity =3D=3D &video->video_dev.entity)
>  			continue;
> -		if (!is_media_entity_v4l2_video_device(entity))
> +		if (!is_media_entity_v4l2_video_device(pad->entity))
>  			continue;
> -		far_end =3D to_vpfe_video(media_entity_to_video_device(entity));
> +		far_end =3D to_vpfe_video(media_entity_to_video_device(
> +						pad->entity));
>  		if (far_end->type =3D=3D V4L2_BUF_TYPE_VIDEO_OUTPUT)
>  			pipe->inputs[pipe->input_num++] =3D far_end;
>  		else
> @@ -288,27 +289,27 @@ static int vpfe_video_validate_pipeline(struct vpfe=
_pipeline *pipe)
>   */
>  static int vpfe_pipeline_enable(struct vpfe_pipeline *pipe)
>  {
> -	struct media_entity *entity;
> +	struct media_pad *pad;
>  	struct v4l2_subdev *subdev;
>  	struct media_device *mdev;
>  	int ret;
>
>  	if (pipe->state =3D=3D VPFE_PIPELINE_STREAM_CONTINUOUS)
> -		entity =3D vpfe_get_input_entity(pipe->outputs[0]);
> +		pad =3D vpfe_get_input_entity(pipe->outputs[0])->pads;
>  	else
> -		entity =3D &pipe->inputs[0]->video_dev.entity;
> +		pad =3D pipe->inputs[0]->video_dev.entity.pads;
>
> -	mdev =3D entity->graph_obj.mdev;
> +	mdev =3D pad->graph_obj.mdev;
>  	mutex_lock(&mdev->graph_mutex);
>  	ret =3D media_graph_walk_init(&pipe->graph, mdev);
>  	if (ret)
>  		goto out;
> -	media_graph_walk_start(&pipe->graph, entity->pads);
> -	while ((entity =3D media_graph_walk_next(&pipe->graph))) {
> +	media_graph_walk_start(&pipe->graph, pad);
> +	while ((pad =3D media_graph_walk_next(&pipe->graph))) {
>
> -		if (!is_media_entity_v4l2_subdev(entity))
> +		if (!is_media_entity_v4l2_subdev(pad->entity))
>  			continue;
> -		subdev =3D media_entity_to_v4l2_subdev(entity);
> +		subdev =3D media_entity_to_v4l2_subdev(pad->entity);
>  		ret =3D v4l2_subdev_call(subdev, video, s_stream, 1);
>  		if (ret < 0 && ret !=3D -ENOIOCTLCMD)
>  			break;
> @@ -333,25 +334,25 @@ static int vpfe_pipeline_enable(struct vpfe_pipelin=
e *pipe)
>   */
>  static int vpfe_pipeline_disable(struct vpfe_pipeline *pipe)
>  {
> -	struct media_entity *entity;
> +	struct media_pad *pad;
>  	struct v4l2_subdev *subdev;
>  	struct media_device *mdev;
>  	int ret =3D 0;
>
>  	if (pipe->state =3D=3D VPFE_PIPELINE_STREAM_CONTINUOUS)
> -		entity =3D vpfe_get_input_entity(pipe->outputs[0]);
> +		pad =3D vpfe_get_input_entity(pipe->outputs[0])->pads;
>  	else
> -		entity =3D &pipe->inputs[0]->video_dev.entity;
> +		pad =3D pipe->inputs[0]->video_dev.entity.pads;
>
> -	mdev =3D entity->graph_obj.mdev;
> +	mdev =3D pad->graph_obj.mdev;
>  	mutex_lock(&mdev->graph_mutex);
> -	media_graph_walk_start(&pipe->graph, entity->pads);
> +	media_graph_walk_start(&pipe->graph, pad);
>
> -	while ((entity =3D media_graph_walk_next(&pipe->graph))) {
> +	while ((pad =3D media_graph_walk_next(&pipe->graph))) {
>
> -		if (!is_media_entity_v4l2_subdev(entity))
> +		if (!is_media_entity_v4l2_subdev(pad->entity))
>  			continue;
> -		subdev =3D media_entity_to_v4l2_subdev(entity);
> +		subdev =3D media_entity_to_v4l2_subdev(pad->entity);
>  		ret =3D v4l2_subdev_call(subdev, video, s_stream, 0);
>  		if (ret < 0 && ret !=3D -ENOIOCTLCMD)
>  			break;
> diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging=
/media/omap4iss/iss_video.c
> index 6f72c02c8054f496..1271bbacf9e7bdeb 100644
> --- a/drivers/staging/media/omap4iss/iss_video.c
> +++ b/drivers/staging/media/omap4iss/iss_video.c
> @@ -206,8 +206,8 @@ static struct iss_video *
>  iss_video_far_end(struct iss_video *video)
>  {
>  	struct media_graph graph;
> -	struct media_entity *entity =3D &video->video.entity;
> -	struct media_device *mdev =3D entity->graph_obj.mdev;
> +	struct media_pad *pad =3D video->video.entity.pads;
> +	struct media_device *mdev =3D pad->entity->graph_obj.mdev;
>  	struct iss_video *far_end =3D NULL;
>
>  	mutex_lock(&mdev->graph_mutex);
> @@ -217,16 +217,17 @@ iss_video_far_end(struct iss_video *video)
>  		return NULL;
>  	}
>
> -	media_graph_walk_start(&graph, entity->pads);
> +	media_graph_walk_start(&graph, pad);
>
> -	while ((entity =3D media_graph_walk_next(&graph))) {
> -		if (entity =3D=3D &video->video.entity)
> +	while ((pad =3D media_graph_walk_next(&graph))) {
> +		if (pad->entity =3D=3D &video->video.entity)
>  			continue;
>
> -		if (!is_media_entity_v4l2_video_device(entity))
> +		if (!is_media_entity_v4l2_video_device(pad->entity))
>  			continue;
>
> -		far_end =3D to_iss_video(media_entity_to_video_device(entity));
> +		far_end =3D to_iss_video(media_entity_to_video_device(
> +						pad->entity));
>  		if (far_end->type !=3D video->type)
>  			break;
>
> @@ -860,7 +861,7 @@ iss_video_streamon(struct file *file, void *fh, enum =
v4l2_buf_type type)
>  	struct iss_video_fh *vfh =3D to_iss_video_fh(fh);
>  	struct iss_video *video =3D video_drvdata(file);
>  	struct media_graph graph;
> -	struct media_entity *entity =3D &video->video.entity;
> +	struct media_pad *pad =3D video->video.entity.pads;
>  	enum iss_pipeline_state state;
>  	struct iss_pipeline *pipe;
>  	struct iss_video *far_end;
> @@ -876,30 +877,31 @@ iss_video_streamon(struct file *file, void *fh, enu=
m v4l2_buf_type type)
>  	 * Start streaming on the pipeline. No link touching an entity in the
>  	 * pipeline can be activated or deactivated once streaming is started.
>  	 */
> -	pipe =3D entity->pipe
> -	     ? to_iss_pipeline(entity) : &video->pipe;
> +	pipe =3D pad->entity->pipe
> +	     ? to_iss_pipeline(pad->entity) : &video->pipe;
>  	pipe->external =3D NULL;
>  	pipe->external_rate =3D 0;
>  	pipe->external_bpp =3D 0;
>
> -	ret =3D media_entity_enum_init(&pipe->ent_enum, entity->graph_obj.mdev);
> +	ret =3D media_entity_enum_init(&pipe->ent_enum,
> +				     pad->entity->graph_obj.mdev);
>  	if (ret)
>  		goto err_graph_walk_init;
>
> -	ret =3D media_graph_walk_init(&graph, entity->graph_obj.mdev);
> +	ret =3D media_graph_walk_init(&graph, pad->entity->graph_obj.mdev);
>  	if (ret)
>  		goto err_graph_walk_init;
>
>  	if (video->iss->pdata->set_constraints)
>  		video->iss->pdata->set_constraints(video->iss, true);
>
> -	ret =3D media_pipeline_start(entity, &pipe->pipe);
> +	ret =3D media_pipeline_start(pad->entity, &pipe->pipe);
>  	if (ret < 0)
>  		goto err_media_pipeline_start;
>
> -	media_graph_walk_start(&graph, entity->pads);
> -	while ((entity =3D media_graph_walk_next(&graph)))
> -		media_entity_enum_set(&pipe->ent_enum, entity);
> +	media_graph_walk_start(&graph, pad);
> +	while ((pad =3D media_graph_walk_next(&graph)))
> +		media_entity_enum_set(&pipe->ent_enum, pad->entity);
>
>  	/*
>  	 * Verify that the currently configured format matches the output of
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index 99c7606f01317741..cde6350d752bb0ae 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -952,10 +952,11 @@ void media_graph_walk_start(struct media_graph *gra=
ph, struct media_pad *pad);
>   * The graph structure must have been previously initialized with a call=
 to
>   * media_graph_walk_start().
>   *
> - * Return: returns the next entity in the graph or %NULL if the whole gr=
aph
> - * have been traversed.
> + * Return: returns the next pad in the graph or %NULL if the whole
> + * graph have been traversed. The pad which is returned is the pad
> + * through which a new entity is reached when parsing the graph.
>   */
> -struct media_entity *media_graph_walk_next(struct media_graph *graph);
> +struct media_pad *media_graph_walk_next(struct media_graph *graph);
>
>  /**
>   * media_pipeline_start - Mark a pipeline as streaming
> --
> 2.19.1
>

--qcyn3pqgowzln5er
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlxlhgUACgkQcjQGjxah
VjwxQRAAugyQDn6/qDOGV5MIZvyFAkrWGb3qyh6Y1s+ky/ENE4ZvFi47DgGouv/z
O41nQQpmsWpdA3R4LsMsbc7NPTGNfLem5vDtg02nesQ98BHU+zHQ57AliCyya9XL
o2KPU1yn9+GAYLSHcF2SoCYO7GFnazniNm9IWDLmKh0+M7APh7z7D31CUrkXN4Kn
aXvEexJtpWIZtnkf0PdLzbQvICddase4ptBO4KGQBjGS4GKk3xBzwANNH+qyKrEu
JnGxSAkKVG05y9hJvAG1qiaZoDs+4Ttii79hvzCnXuC1LbM0hbmlQ74QyG2AWqbi
Wq3GS7Jqo0tzGKge8XVVUHexa7JEHcfn+LOPNQPGgq3DGqlFAbjP9sOzQDL2fqOc
gvjLd+ngjiSQvYsSv54WgUX+IfgZF1vCMszk02/t6G3Y95YbLwb8Rk7t5k3m/hPB
BnbvhmR6r7Ecju6uTno50BSRhc3jLmdxvvUbneYwE7yrq8XNWoeeeOyqn26/ZEHQ
vhae2qFH5im0cOOMF7K3LnV6qHqxYdNVZkSio8EnkaGp1fRD3qjAcirjob1ft8mp
T6/4AFcEjo+iX8Pu3+A2fZGGq8cwLb5qdCxEWWCHH/ZKGCyDHNkgIWhgKAhF7IH4
p14RRBPXabQsQrdVtdvtH9BPp9LRId2ZBC0nx3zJ3OKBKzK7ALw=
=r/jC
-----END PGP SIGNATURE-----

--qcyn3pqgowzln5er--
