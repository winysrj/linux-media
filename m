Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36302 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279AbaGQLnC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 07:43:02 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] media: Set entity->links NULL in cleanup
Date: Thu, 17 Jul 2014 13:43:09 +0200
Message-ID: <3533594.Ac4LJj8QGP@avalon>
In-Reply-To: <1401197269-18773-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1401197269-18773-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Tuesday 27 May 2014 16:27:49 Sakari Ailus wrote:
> Calling media_entity_cleanup() on a cleaned-up entity would result into
> double free of the entity->links pointer and likely memory corruption as
> well.

My first question is, why would anyone do that ? :-)

> Setting entity->links as NULL right after the kfree() avoids this.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/media-entity.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index 37c334e..c404354 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -83,6 +83,7 @@ void
>  media_entity_cleanup(struct media_entity *entity)
>  {
>  	kfree(entity->links);
> +	entity->links = NULL;
>  }
>  EXPORT_SYMBOL_GPL(media_entity_cleanup);

-- 
Regards,

Laurent Pinchart

