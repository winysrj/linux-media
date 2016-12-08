Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45423 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752805AbcLHOJo (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Dec 2016 09:09:44 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se
Subject: Re: [PATCH 1/5] media: entity: Fix stream count check
Date: Thu, 08 Dec 2016 16:09:27 +0200
Message-ID: <4059323.dlFNBvkxl2@avalon>
In-Reply-To: <1480082146-25991-2-git-send-email-sakari.ailus@linux.intel.com>
References: <1480082146-25991-1-git-send-email-sakari.ailus@linux.intel.com> <1480082146-25991-2-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Friday 25 Nov 2016 15:55:42 Sakari Ailus wrote:
> There's a sanity check for the stream count remaining positive or zero on
> error path, but instead of performing the check on the traversed entity it
> is performed on the entity where traversal ends. Fix this.
> 
> Fixes: commit 3801bc7d1b8d ("[media] media: Media Controller fix to not let
> stream_count go negative") Signed-off-by: Sakari Ailus
> <sakari.ailus@linux.intel.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/media-entity.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index 58d9fa6..da46706 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -484,7 +484,7 @@ __must_check int __media_entity_pipeline_start(struct
> media_entity *entity,
> 
>  	while ((entity_err = media_entity_graph_walk_next(graph))) {
>  		/* don't let the stream_count go negative */
> -		if (entity->stream_count > 0) {
> +		if (entity_err->stream_count > 0) {
>  			entity_err->stream_count--;
>  			if (entity_err->stream_count == 0)
>  				entity_err->pipe = NULL;

-- 
Regards,

Laurent Pinchart

