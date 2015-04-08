Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40592 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbbDHNu2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Apr 2015 09:50:28 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] media: Correctly notify about the failed pipeline validation
Date: Wed, 08 Apr 2015 16:50:48 +0300
Message-ID: <4424832.AmZfJ0mdjq@avalon>
In-Reply-To: <1423748591-19402-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1423748591-19402-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Sakari,

Thank you for the patch.

On Thursday 12 February 2015 15:43:11 Sakari Ailus wrote:
> On the place of the source entity name, the sink entity name was printed.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree. It's a bit late for v4.1, can it wait for v4.2 ?

> ---
>  drivers/media/media-entity.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index defe4ac..d894481 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -283,9 +283,9 @@ __must_check int media_entity_pipeline_start(struct
> media_entity *entity, if (ret < 0 && ret != -ENOIOCTLCMD) {
>  				dev_dbg(entity->parent->dev,
>  					"link validation failed for \"%s\":%u -> \"%s\":%u, error 
%d\n",
> -					entity->name, link->source->index,
> -					link->sink->entity->name,
> -					link->sink->index, ret);
> +					link->source->entity->name,
> +					link->source->index,
> +					entity->name, link->sink->index, ret);
>  				goto error;
>  			}
>  		}

-- 
Regards,

Laurent Pinchart

