Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:34044 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbbHXRx5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Aug 2015 13:53:57 -0400
Received: by igui7 with SMTP id i7so67093261igu.1
        for <linux-media@vger.kernel.org>; Mon, 24 Aug 2015 10:53:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <89b52db55e6ab0ad54e2ed0e760ba0ca3f54dec8.1440359643.git.mchehab@osg.samsung.com>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
	<89b52db55e6ab0ad54e2ed0e760ba0ca3f54dec8.1440359643.git.mchehab@osg.samsung.com>
Date: Mon, 24 Aug 2015 11:53:56 -0600
Message-ID: <CAKocOOPYg3ac6GFA1ybo3cg=quczpd8Uh+8frhbsdGWrUEV5Mw@mail.gmail.com>
Subject: Re: [PATCH v7 02/44] [media] staging: omap4iss: get entity ID using media_entity_id()
From: Shuah Khan <shuahkhan@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org, shuahkh@osg.samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Aug 23, 2015 at 2:17 PM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> From: Javier Martinez Canillas <javier@osg.samsung.com>
>
> The struct media_entity does not have an .id field anymore since
> now the entity ID is stored in the embedded struct media_gobj.
>
> This caused the omap4iss driver fail to build. Fix by using the
> media_entity_id() macro to obtain the entity ID.
>
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>
> diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
> index 9bfb725b9986..e54a7afd31de 100644
> --- a/drivers/staging/media/omap4iss/iss.c
> +++ b/drivers/staging/media/omap4iss/iss.c
> @@ -607,7 +607,7 @@ static int iss_pipeline_disable(struct iss_pipeline *pipe,
>                          * crashed. Mark it as such, the ISS will be reset when
>                          * applications will release it.
>                          */
> -                       iss->crashed |= 1U << subdev->entity.id;
> +                       iss->crashed |= 1U << media_entity_id(&subdev->entity);
>                         failure = -ETIMEDOUT;
>                 }
>         }
> diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
> index bae67742706f..25e9e7a6b99d 100644
> --- a/drivers/staging/media/omap4iss/iss_video.c
> +++ b/drivers/staging/media/omap4iss/iss_video.c
> @@ -784,7 +784,7 @@ iss_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
>         entity = &video->video.entity;
>         media_entity_graph_walk_start(&graph, entity);
>         while ((entity = media_entity_graph_walk_next(&graph)))
> -               pipe->entities |= 1 << entity->id;
> +               pipe->entities |= 1 << media_entity_id(entity);
>

Looks good to me.

Acked-by: Shuah Khan <shuahkh@osg.samsung.com>

thanks,
-- Shuah
