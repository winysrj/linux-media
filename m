Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56379 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbbLFDR6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Dec 2015 22:17:58 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org
Subject: Re: [PATCH v8 02/55] [media] staging: omap4iss: get entity ID using media_entity_id()
Date: Sun, 06 Dec 2015 05:18:12 +0200
Message-ID: <11605234.UyDltQlPdy@avalon>
In-Reply-To: <95dccc89e638c5cd60a6d13541efd29ca39766fb.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com> <95dccc89e638c5cd60a6d13541efd29ca39766fb.1440902901.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

Thank you for the patch.

On Sunday 30 August 2015 00:06:13 Mauro Carvalho Chehab wrote:
> From: Javier Martinez Canillas <javier@osg.samsung.com>
> 
> Assessing media_entity ID should now use media_entity_id() macro to

Did you mean "accessing" ?

> obtain the entity ID, as a next patch will remove the .id field from
> struct media_entity .
> 
> So, get rid of it, otherwise the omap4iss driver will fail to build.
> 
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

With the typo fixed,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> diff --git a/drivers/staging/media/omap4iss/iss.c
> b/drivers/staging/media/omap4iss/iss.c index 9bfb725b9986..e54a7afd31de
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

