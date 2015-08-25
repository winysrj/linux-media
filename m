Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:50712 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755067AbbHYGfI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2015 02:35:08 -0400
Message-ID: <55DC0C68.2040501@xs4all.nl>
Date: Tue, 25 Aug 2015 08:34:16 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Javier Martinez Canillas <javier@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org
Subject: Re: [PATCH v7 02/44] [media] staging: omap4iss: get entity ID using
 media_entity_id()
References: <cover.1440359643.git.mchehab@osg.samsung.com> <89b52db55e6ab0ad54e2ed0e760ba0ca3f54dec8.1440359643.git.mchehab@osg.samsung.com>
In-Reply-To: <89b52db55e6ab0ad54e2ed0e760ba0ca3f54dec8.1440359643.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/23/2015 10:17 PM, Mauro Carvalho Chehab wrote:
> From: Javier Martinez Canillas <javier@osg.samsung.com>
> 
> The struct media_entity does not have an .id field anymore since
> now the entity ID is stored in the embedded struct media_gobj.
> 
> This caused the omap4iss driver fail to build. Fix by using the
> media_entity_id() macro to obtain the entity ID.

This commit log is now a bit misleading since with the new position in this
patch series this change is here to *prevent* a build failure once the id
field is removed, and not to fix a build failure.

After fixing this:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> 
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
> index 9bfb725b9986..e54a7afd31de 100644
> --- a/drivers/staging/media/omap4iss/iss.c
> +++ b/drivers/staging/media/omap4iss/iss.c
> @@ -607,7 +607,7 @@ static int iss_pipeline_disable(struct iss_pipeline *pipe,
>  			 * crashed. Mark it as such, the ISS will be reset when
>  			 * applications will release it.
>  			 */
> -			iss->crashed |= 1U << subdev->entity.id;
> +			iss->crashed |= 1U << media_entity_id(&subdev->entity);
>  			failure = -ETIMEDOUT;
>  		}
>  	}
> diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
> index bae67742706f..25e9e7a6b99d 100644
> --- a/drivers/staging/media/omap4iss/iss_video.c
> +++ b/drivers/staging/media/omap4iss/iss_video.c
> @@ -784,7 +784,7 @@ iss_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
>  	entity = &video->video.entity;
>  	media_entity_graph_walk_start(&graph, entity);
>  	while ((entity = media_entity_graph_walk_next(&graph)))
> -		pipe->entities |= 1 << entity->id;
> +		pipe->entities |= 1 << media_entity_id(entity);
>  
>  	/* Verify that the currently configured format matches the output of
>  	 * the connected subdev.
> 

