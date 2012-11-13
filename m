Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37488 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754540Ab2KMOYP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Nov 2012 09:24:15 -0500
Date: Tue, 13 Nov 2012 16:24:10 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Cc: laurent.pinchart@ideasonboard.com,
	broonie@opensource.wolfsonmicro.com, hverkuil@xs4all.nl,
	sylwester.nawrocki@gmail.com
Subject: Re: [PATCH 1/1] media: Entities with sink pads must have at least
 one enabled link
Message-ID: <20121113142409.GR25623@valkosipuli.retiisi.org.uk>
References: <1351280777-4936-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351280777-4936-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Comments would be appreciated, either positive or negative. The omap3isp
driver does the same check itself currently, but I think this is more
generic than that.

Thanks.

On Fri, Oct 26, 2012 at 10:46:17PM +0300, Sakari Ailus wrote:
> If an entity has sink pads, at least one of them must be connected to
> another pad with an enabled link. If a driver with multiple sink pads has
> more strict requirements the check should be done in the driver itself.
> 
> Just requiring one sink pad is connected with an enabled link is enough
> API-wise: entities with sink pads with only disabled links should not be
> allowed to stream in the first place, but also in a different operation mode
> a device might require only one of its pads connected with an active link.
> 
> If an entity has an ability to function as a source entity another logical
> entity connected to the aforementioned one should be used for the purpose.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  drivers/media/media-entity.c |   16 +++++++++++++---
>  1 files changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index e1cd132..8846ea7 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -227,6 +227,7 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
>  	media_entity_graph_walk_start(&graph, entity);
>  
>  	while ((entity = media_entity_graph_walk_next(&graph))) {
> +		bool has_sink = false, active_sink = false;
>  		unsigned int i;
>  
>  		entity->stream_count++;
> @@ -243,18 +244,27 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
>  		for (i = 0; i < entity->num_links; i++) {
>  			struct media_link *link = &entity->links[i];
>  
> +			/* Are we the sink or not? */
> +			if (link->sink->entity != entity)
> +				continue;
> +
> +			has_sink = true;
> +
>  			/* Is this pad part of an enabled link? */
>  			if (!(link->flags & MEDIA_LNK_FL_ENABLED))
>  				continue;
>  
> -			/* Are we the sink or not? */
> -			if (link->sink->entity != entity)
> -				continue;
> +			active_sink = true;
>  
>  			ret = entity->ops->link_validate(link);
>  			if (ret < 0 && ret != -ENOIOCTLCMD)
>  				goto error;
>  		}
> +
> +		if (has_sink && !active_sink) {
> +			ret = -EPIPE;
> +			goto error;
> +		}
>  	}
>  
>  	mutex_unlock(&mdev->graph_mutex);
> -- 
> 1.7.2.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
