Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34408 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759421Ab3ICSHn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Sep 2013 14:07:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v1.1 3/5] media: Pads that are not connected by even a disabled link are fine
Date: Tue, 03 Sep 2013 20:07:43 +0200
Message-ID: <1806796.1hWpdenVOE@avalon>
In-Reply-To: <1377966487-22565-1-git-send-email-sakari.ailus@iki.fi>
References: <1611138.kmhZXgyzhc@avalon> <1377966487-22565-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Saturday 31 August 2013 19:28:06 Sakari Ailus wrote:
> Do not require a connected link to a pad if a pad has no links connected to
> it.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
> Hi Laurent,
> 
> This goes on top of patch 2/4. I can combine the two in the end but I think
> this is cleaner as a separate change.

Merging the patches separately could result in a bisection breakage, so I'd 
rather combine the patches if that's OK. What about the following commit 
message ?

"media: Check for active links on pads with MEDIA_PAD_FL_MUST_CONNECT flag

Do not allow streaming if a pad with MEDIA_PAD_FL_MUST_CONNECT flag is 
connected by links that are all inactive.

This patch makes it possible to avoid drivers having to check for the most
common case of link state validation: a sink pad that must be connected."

>  drivers/media/media-entity.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index a99396b..2ad291f 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -236,6 +236,7 @@ __must_check int media_entity_pipeline_start(struct
> media_entity *entity,
> 
>  	while ((entity = media_entity_graph_walk_next(&graph))) {
>  		DECLARE_BITMAP(active, entity->num_pads);
> +		DECLARE_BITMAP(has_no_links, entity->num_pads);
>  		unsigned int i;
> 
>  		entity->stream_count++;
> @@ -250,6 +251,7 @@ __must_check int media_entity_pipeline_start(struct
> media_entity *entity, continue;
> 
>  		bitmap_zero(active, entity->num_pads);
> +		bitmap_fill(has_no_links, entity->num_pads);
> 
>  		for (i = 0; i < entity->num_links; i++) {
>  			struct media_link *link = &entity->links[i];
> @@ -257,6 +259,11 @@ __must_check int media_entity_pipeline_start(struct
> media_entity *entity, ? link->sink : link->source;
> 
>  			/*
> +			 * Mark that a pad is connected by a link.
> +			 */
> +			bitmap_clear(has_no_links, pad->index, 1);
> +
> +			/*
>  			 * Pads that either do not need to connect or
>  			 * are connected through an enabled link are
>  			 * fine.
> @@ -278,6 +285,9 @@ __must_check int media_entity_pipeline_start(struct
> media_entity *entity, goto error;
>  		}
> 
> +		/* Either no links or validated links are fine. */
> +		bitmap_or(active, active, has_no_links, entity->num_pads);
> +
>  		if (!bitmap_full(active, entity->num_pads)) {
>  			ret = -EPIPE;
>  			goto error;
-- 
Regards,

Laurent Pinchart

