Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60147 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab2AONoD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jan 2012 08:44:03 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [media-ctl PATCH 1/1] libmediactl: Implement MEDIA_ENT_ID_FLAG_NEXT in media_get_entity_by_id()
Date: Sun, 15 Jan 2012 14:44:08 +0100
Cc: linux-media@vger.kernel.org
References: <1326569616-7048-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1326569616-7048-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201201151444.08443.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Saturday 14 January 2012 20:33:36 Sakari Ailus wrote:
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  src/mediactl.c |    9 +++++++--
>  src/mediactl.h |    4 +++-
>  2 files changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/src/mediactl.c b/src/mediactl.c
> index 5b8c587..f62fcdf 100644
> --- a/src/mediactl.c
> +++ b/src/mediactl.c
> @@ -81,8 +81,13 @@ struct media_entity *media_get_entity_by_id(struct
> media_device *media, for (i = 0; i < media->entities_count; ++i) {
>  		struct media_entity *entity = &media->entities[i];
> 
> -		if (entity->info.id == id)
> -			return entity;
> +		if (!(id & MEDIA_ENT_ID_FLAG_NEXT)) {
> +			if (entity->info.id == id)
> +				return entity;
> +		} else {
> +			if (entity->info.id >= (id & ~MEDIA_ENT_ID_FLAG_NEXT)
> +				return entity;
> +		}

Just one question that hasn't crossed my mind before, why do you need this ? 
If you want to enumerate entities in an application you can just iterate over 
media_device::entities.

>  	}
> 
>  	return NULL;
> diff --git a/src/mediactl.h b/src/mediactl.h
> index 1b47b7e..4d3892e 100644
> --- a/src/mediactl.h
> +++ b/src/mediactl.h
> @@ -164,7 +164,9 @@ struct media_entity *media_get_entity_by_name(struct
> media_device *media, * @param media - media device.
>   * @param id - entity ID.
>   *
> - * Search for an entity with an ID equal to @a id.
> + * Search for an entity with an ID equal to @a id. If id flag
> + * MEDIA_ENT_ID_FLAG_NEXT is present, an entity with ID greater or equal
> to + * @a id will be returned.
>   *
>   * @return A pointer to the entity if found, or NULL otherwise.
>   */

-- 
Regards,

Laurent Pinchart
