Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53355 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545AbbJ1ASv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Oct 2015 20:18:51 -0400
Date: Wed, 28 Oct 2015 09:18:46 +0900
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	javier@osg.samsung.com, hverkuil@xs4all.nl
Subject: Re: [PATCH 01/19] media: Enforce single entity->pipe in a pipeline
Message-ID: <20151028091846.7d0ae2f4@concha.lan>
In-Reply-To: <1445900510-1398-2-git-send-email-sakari.ailus@iki.fi>
References: <1445900510-1398-1-git-send-email-sakari.ailus@iki.fi>
	<1445900510-1398-2-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 27 Oct 2015 01:01:32 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> If a different entity->pipe in a pipeline was encountered, a warning was
> issued but the execution continued as if nothing had happened. Return an
> error instead right there.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Reviewed-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

> ---
>  drivers/media/media-entity.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index 66b8db0..d11f440 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -431,7 +431,12 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
>  		DECLARE_BITMAP(has_no_links, MEDIA_ENTITY_MAX_PADS);
>  
>  		entity->stream_count++;
> -		WARN_ON(entity->pipe && entity->pipe != pipe);
> +
> +		if (WARN_ON(entity->pipe && entity->pipe != pipe)) {
> +			ret = -EBUSY;
> +			goto error;
> +		}
> +
>  		entity->pipe = pipe;
>  
>  		/* Already streaming --- no need to check. */


-- 

Cheers,
Mauro
