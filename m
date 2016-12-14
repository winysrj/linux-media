Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56818 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750786AbcLNH2v (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Dec 2016 02:28:51 -0500
Date: Wed, 14 Dec 2016 09:28:44 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: laurent.pinchart@ideasonboard.com,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCHv3 RFC 4/4] media: Catch null pipes on pipeline stop
Message-ID: <20161214072843.GA16630@valkosipuli.retiisi.org.uk>
References: <1481651984-7687-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
 <1481651984-7687-5-git-send-email-kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1481651984-7687-5-git-send-email-kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Tue, Dec 13, 2016 at 05:59:44PM +0000, Kieran Bingham wrote:
> media_entity_pipeline_stop() can be called through error paths with a
> NULL entity pipe object. In this instance, stopping is a no-op, so
> simply return without any action

The approach of returning silently is wrong; the streaming count is indeed a
count: you have to decrement it the exactly same number of times it's been
increased. Code that attempts to call __media_entity_pipeline_stop() on an
entity that's not streaming is simply buggy.

I've got a patch here that adds a warning to graph traversal on streaming
count being zero. I sent a pull request including that some days ago:

<URL:http://www.spinics.net/lists/linux-media/msg108980.html>
<URL:http://www.spinics.net/lists/linux-media/msg108995.html>

I think the check here could simply be removed as the check is done for
every entity in the pipeline with the above patch.

If there's still a wish to check for the pipe field which should not be
written by drivers, it should be done during pipeline traversal so that it
applies to all entities in the pipeline, not just where traversal starts.

> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> ---
> 
> I've marked this patch as RFC, although if deemed suitable, by all means
> integrate it as is.
> 
> When testing suspend/resume operations on VSP1, I encountered a segfault on the
> WARN_ON(!pipe->streaming_count) line, where 'pipe == NULL'. The simple
> protection fix is to return early in this instance, as this patch does however:
> 
> A) Does this early return path warrant a WARN() statement itself, to identify
> drivers which are incorrectly calling media_entity_pipeline_stop() with an
> invalid entity, or would this just be noise ...
> 
> and therefore..
> 
> B) I also partly assume this patch could simply get NAK'd with a request to go
> and dig out the root cause of calling media_entity_pipeline_stop() with an
> invalid entity. 
> 
> My brief investigation so far here so far shows that it's almost a second order
> fault - where the first suspend resume cycle completes but leaves the entity in
> an invalid state having followed an error path - and then on a second
> suspend/resume - the stop fails with the affected segfault.
> 
> If statement A) or B) apply here, please drop this patch from the series, and
> don't consider it a blocking issue for the other 3 patches.
> 
> Kieran
> 
> 
>  drivers/media/media-entity.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index c68239e60487..93c9cbf4bf46 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -508,6 +508,8 @@ void __media_entity_pipeline_stop(struct media_entity *entity)
>  	struct media_entity_graph *graph = &entity->pipe->graph;
>  	struct media_pipeline *pipe = entity->pipe;
>  
> +	if (!pipe)
> +		return;
>  
>  	WARN_ON(!pipe->streaming_count);
>  	media_entity_graph_walk_start(graph, entity);

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
