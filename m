Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:52139 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154AbbDHLXy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Apr 2015 07:23:54 -0400
Date: Wed, 8 Apr 2015 08:23:42 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 1/1] media: Correctly notify about the failed pipeline
 validation
Message-ID: <20150408082342.1ff93eef@recife.lan>
In-Reply-To: <1423748591-19402-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1423748591-19402-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 12 Feb 2015 15:43:11 +0200
Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:

> On the place of the source entity name, the sink entity name was printed.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/media-entity.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index defe4ac..d894481 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -283,9 +283,9 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
>  			if (ret < 0 && ret != -ENOIOCTLCMD) {
>  				dev_dbg(entity->parent->dev,
>  					"link validation failed for \"%s\":%u -> \"%s\":%u, error %d\n",
> -					entity->name, link->source->index,
> -					link->sink->entity->name,
> -					link->sink->index, ret);
> +					link->source->entity->name,
> +					link->source->index,
> +					entity->name, link->sink->index, ret);

This should likely be reviewed by Laurent, but the above code
seems weird to me...

1) Why should it print the link source, instead of the sink?
I suspect that the code here should take into account the chosen
pad:

                        struct media_pad *pad = link->sink->entity == entity
                                                ? link->sink : link->source;

2) Assuming that your patch is right, why are you printing the
link->sink->index, instead of link->source->index?

Regards,
Mauro
