Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:40331 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752259AbbHTMqH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Aug 2015 08:46:07 -0400
Message-ID: <55D5CB73.6090202@xs4all.nl>
Date: Thu, 20 Aug 2015 14:43:31 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Javier Martinez Canillas <javier@osg.samsung.com>,
	linux-kernel@vger.kernel.org
CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 4/4] [media] media: remove media entity .parent field
References: <1439998526-12832-1-git-send-email-javier@osg.samsung.com> <1439998526-12832-5-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1439998526-12832-5-git-send-email-javier@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/19/15 17:35, Javier Martinez Canillas wrote:
> Now that the struct media_entity .parent field is unused, it can be
> safely removed. Since all the previous users were converted to use
> the .mdev field from the embedded struct media_gobj instead.
> 
> Suggested-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> 
> ---
> 
>  include/media/media-entity.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index 3b653e9321f2..d7e007f624a5 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -103,7 +103,6 @@ struct media_entity_operations {
>  struct media_entity {
>  	struct media_gobj graph_obj;
>  	struct list_head list;
> -	struct media_device *parent;	/* Media device this entity belongs to*/
>  	const char *name;		/* Entity name */
>  	u32 type;			/* Entity type (MEDIA_ENT_T_*) */
>  	u32 revision;			/* Entity revision, driver specific */
> 
