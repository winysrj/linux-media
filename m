Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:53585 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbbHTShn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Aug 2015 14:37:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/4] [media] staging: omap4iss: get entity ID using media_entity_id()
Date: Thu, 20 Aug 2015 21:37:41 +0300
Message-ID: <3021244.b1huftRsSL@avalon>
In-Reply-To: <1439998526-12832-2-git-send-email-javier@osg.samsung.com>
References: <1439998526-12832-1-git-send-email-javier@osg.samsung.com> <1439998526-12832-2-git-send-email-javier@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

Thank you for the patch.

On Wednesday 19 August 2015 17:35:19 Javier Martinez Canillas wrote:
> The struct media_entity does not have an .id field anymore since
> now the entity ID is stored in the embedded struct media_gobj.
> 
> This caused the omap4iss driver fail to build. Fix by using the
> media_entity_id() macro to obtain the entity ID.
> 
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

This looks fine to me. The patch needs to be moved between Mauro's 1/8 and 2/8 
patches to avoid breaking bisection with patch 3/8. I'd squash this patch and 
2/4 into a single "media: Use media_entity_id() in drivers" patch.

> ---
> 
>  drivers/staging/media/omap4iss/iss.c       | 2 +-
>  drivers/staging/media/omap4iss/iss_video.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/media/omap4iss/iss.c
> b/drivers/staging/media/omap4iss/iss.c index f32ab7b98ae2..7226553ceb2f
> 100644
> --- a/drivers/staging/media/omap4iss/iss.c
> +++ b/drivers/staging/media/omap4iss/iss.c
> @@ -607,7 +607,7 @@ static int iss_pipeline_disable(struct iss_pipeline
> *pipe, * crashed. Mark it as such, the ISS will be reset when
>  			 * applications will release it.
>  			 */
> -			iss->crashed |= 1U << subdev->entity.id;
> +			iss->crashed |= 1U << media_entity_id(&subdev->entity);
>  			failure = -ETIMEDOUT;
>  		}
>  	}
> diff --git a/drivers/staging/media/omap4iss/iss_video.c
> b/drivers/staging/media/omap4iss/iss_video.c index
> bae67742706f..25e9e7a6b99d 100644
> --- a/drivers/staging/media/omap4iss/iss_video.c
> +++ b/drivers/staging/media/omap4iss/iss_video.c
> @@ -784,7 +784,7 @@ iss_video_streamon(struct file *file, void *fh, enum
> v4l2_buf_type type) entity = &video->video.entity;
>  	media_entity_graph_walk_start(&graph, entity);
>  	while ((entity = media_entity_graph_walk_next(&graph)))
> -		pipe->entities |= 1 << entity->id;
> +		pipe->entities |= 1 << media_entity_id(entity);
> 
>  	/* Verify that the currently configured format matches the output of
>  	 * the connected subdev.

-- 
Regards,

Laurent Pinchart

