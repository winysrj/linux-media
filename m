Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38684 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbbKWPms (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2015 10:42:48 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH 1/2] [media] media: don't try to empty links list in media_entity_cleanup()
Date: Mon, 23 Nov 2015 17:42:57 +0200
Message-ID: <4525565.mVzskEzFVD@avalon>
In-Reply-To: <1440602719-12500-2-git-send-email-javier@osg.samsung.com>
References: <1440602719-12500-1-git-send-email-javier@osg.samsung.com> <1440602719-12500-2-git-send-email-javier@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Javier,

(Resending as I've replied by mistake to the version of the patch you had sent 
to the media workshop list only)

Thank you for the patch.

On Monday 12 October 2015 13:44:11 Mauro Carvalho Chehab wrote:
> From: Javier Martinez Canillas <javier@osg.samsung.com>
> 
> The media_entity_cleanup() function only cleans up the entity links list
> but this operation is already made in media_device_unregister_entity().
> 
> In most cases this should be harmless (besides having duplicated code)
> since the links list would be empty so the iteration would not happen
> but the links list is initialized in media_device_register_entity() so
> if a driver fails to register an entity with a media device and clean up
> the entity in the error path, a NULL deference pointer error will happen.
> 
> So don't try to empty the links list in media_entity_cleanup() since
> is either done already or haven't been initialized yet.

Does this mean that it's an invalid usage of the API to create links before 
registering entities ? If so it should be clearly documented somewhere, such 
as in the kerneldoc of the media_create_pad_link() function.

And yes, that means that all exported API functions need kerneldoc. Sorry for 
being a killjoy 

On a related note, we need to solve the userspace API race caused by 
registering the MC devnode before all entities and links are created an 
registered. It's not a new issue so I won't call for fixing it as part of this 
patch series, but we'll need to fix that with the dynamic graph update 
implementation at the latest. It will likely require reworking the 
initialization and registration sequences.

> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> ---
>  drivers/media/media-entity.c | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index 2c984fb7d497..eaeda2589ce5 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -268,13 +268,6 @@ EXPORT_SYMBOL_GPL(media_entity_init);
>  void
>  media_entity_cleanup(struct media_entity *entity)
>  {
> -     struct media_link *link, *tmp;
> -
> -     list_for_each_entry_safe(link, tmp, &entity->links, list) {
> -             media_gobj_remove(&link->graph_obj);
> -             list_del(&link->list);
> -             kfree(link);
> -     }
>  }
>  EXPORT_SYMBOL_GPL(media_entity_cleanup);

As media_entity_cleanup is now empty I'd turn it into a static inline. We need 
to keep the function in case cleanup ends up being needed later, but there's 
no reason not to optimize the call away for now.

-- 
Regards,

Laurent Pinchart

