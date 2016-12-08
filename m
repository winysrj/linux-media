Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45423 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752078AbcLHOJm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Dec 2016 09:09:42 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se
Subject: Re: [PATCH 2/5] media: entity: Be vocal about failing sanity checks
Date: Thu, 08 Dec 2016 16:09:20 +0200
Message-ID: <1963835.tWnYaqGUsW@avalon>
In-Reply-To: <1480082146-25991-3-git-send-email-sakari.ailus@linux.intel.com>
References: <1480082146-25991-1-git-send-email-sakari.ailus@linux.intel.com> <1480082146-25991-3-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Friday 25 Nov 2016 15:55:43 Sakari Ailus wrote:
> Commit 3801bc7d1b8d ("[media] media: Media Controller fix to not let
> stream_count go negative") added a sanity check for negative stream_count,
> but a failure of the check remained silent. Make sure the failure is
> noticed.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/media-entity.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index da46706..82dd0bc 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -483,8 +483,8 @@ __must_check int __media_entity_pipeline_start(struct
> media_entity *entity, media_entity_graph_walk_start(graph, entity_err);
> 
>  	while ((entity_err = media_entity_graph_walk_next(graph))) {
> -		/* don't let the stream_count go negative */
> -		if (entity_err->stream_count > 0) {
> +		/* Sanity check for negative stream_count */
> +		if (!WARN_ON_ONCE(entity_err->stream_count <= 0)) {
>  			entity_err->stream_count--;
>  			if (entity_err->stream_count == 0)
>  				entity_err->pipe = NULL;
> @@ -529,8 +529,8 @@ void __media_entity_pipeline_stop(struct media_entity
> *entity) media_entity_graph_walk_start(graph, entity);
> 
>  	while ((entity = media_entity_graph_walk_next(graph))) {
> -		/* don't let the stream_count go negative */
> -		if (entity->stream_count > 0) {
> +		/* Sanity check for negative stream_count */
> +		if (!WARN_ON_ONCE(entity->stream_count <= 0)) {
>  			entity->stream_count--;
>  			if (entity->stream_count == 0)
>  				entity->pipe = NULL;

-- 
Regards,

Laurent Pinchart

