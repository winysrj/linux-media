Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:42115 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753965AbbHYGh6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2015 02:37:58 -0400
Message-ID: <55DC0D17.20109@xs4all.nl>
Date: Tue, 25 Aug 2015 08:37:11 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Javier Martinez Canillas <javier@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v7 12/44] [media] media: remove media entity .parent field
References: <cover.1440359643.git.mchehab@osg.samsung.com> <05b394a87249d87c086a44e04182df136ccafbe9.1440359643.git.mchehab@osg.samsung.com>
In-Reply-To: <05b394a87249d87c086a44e04182df136ccafbe9.1440359643.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/23/2015 10:17 PM, Mauro Carvalho Chehab wrote:
> From: Javier Martinez Canillas <javier@osg.samsung.com>
> 
> Now that the struct media_entity .parent field is unused, it can be
> safely removed. Since all the previous users were converted to use
> the .mdev field from the embedded struct media_gobj instead.
> 
> Suggested-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> 
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index e0e4b014ce62..239c4ec30ef6 100644
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

