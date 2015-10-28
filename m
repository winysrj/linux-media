Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53382 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755147AbbJ1Anr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Oct 2015 20:43:47 -0400
Date: Wed, 28 Oct 2015 09:43:43 +0900
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	javier@osg.samsung.com, hverkuil@xs4all.nl
Subject: Re: [PATCH 07/19] media: Use the new
 media_entity_graph_walk_start()
Message-ID: <20151028094343.009cbcf9@concha.lan>
In-Reply-To: <1445900510-1398-8-git-send-email-sakari.ailus@iki.fi>
References: <1445900510-1398-1-git-send-email-sakari.ailus@iki.fi>
	<1445900510-1398-8-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 27 Oct 2015 01:01:38 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Please add some documentation at the body for all patches.

Btw, IMHO, it would be best to fold this patch and the following ones
that are related to media_entity_graph_walk_init() altogether, as it
makes easier to review if all places were covered.

> ---
>  drivers/media/media-entity.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index bf3c31f..4161dc7 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -492,7 +492,13 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
>  
>  	mutex_lock(&mdev->graph_mutex);
>  
> -	media_entity_graph_walk_start(graph, entity);
> +	ret = media_entity_graph_walk_init(&pipe->graph, mdev);
> +	if (ret) {
> +		mutex_unlock(&mdev->graph_mutex);
> +		return ret;
> +	}
> +
> +	media_entity_graph_walk_start(&pipe->graph, entity);
>  
>  	while ((entity = media_entity_graph_walk_next(graph))) {
>  		DECLARE_BITMAP(active, MEDIA_ENTITY_MAX_PADS);
> @@ -590,6 +596,8 @@ error:
>  			break;
>  	}
>  
> +	media_entity_graph_walk_cleanup(graph);
> +
>  	mutex_unlock(&mdev->graph_mutex);
>  
>  	return ret;
> @@ -623,6 +631,8 @@ void media_entity_pipeline_stop(struct media_entity *entity)
>  			entity->pipe = NULL;
>  	}
>  
> +	media_entity_graph_walk_cleanup(graph);
> +
>  	mutex_unlock(&mdev->graph_mutex);
>  }
>  EXPORT_SYMBOL_GPL(media_entity_pipeline_stop);


-- 

Cheers,
Mauro
