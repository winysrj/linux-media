Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:49300 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751372AbbHaKpG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2015 06:45:06 -0400
Message-ID: <55E42FF9.7020505@xs4all.nl>
Date: Mon, 31 Aug 2015 12:44:09 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v8 20/55] [media] media: make add link more generic
References: <cover.1440902901.git.mchehab@osg.samsung.com> <81b61cdb4bb2192b2810675f80cc12b06b4d242b.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <81b61cdb4bb2192b2810675f80cc12b06b4d242b.1440902901.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/30/2015 05:06 AM, Mauro Carvalho Chehab wrote:
> The media_entity_add_link() function takes an entity
> as an argument just to get the list head.
> 
> Make it more generic by changing the function argument
> to list_head.
> 
> No functional changes.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index ff63201443d7..6d06be6c9ef3 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -580,7 +580,7 @@ EXPORT_SYMBOL_GPL(media_entity_put);
>   * Links management
>   */
>  
> -static struct media_link *media_entity_add_link(struct media_entity *entity)
> +static struct media_link *media_add_link(struct list_head *head)
>  {
>  	struct media_link *link;
>  
> @@ -588,7 +588,7 @@ static struct media_link *media_entity_add_link(struct media_entity *entity)
>  	if (link == NULL)
>  		return NULL;
>  
> -	list_add_tail(&link->list, &entity->links);
> +	list_add_tail(&link->list, head);
>  
>  	return link;
>  }
> @@ -607,7 +607,7 @@ media_create_pad_link(struct media_entity *source, u16 source_pad,
>  	BUG_ON(source_pad >= source->num_pads);
>  	BUG_ON(sink_pad >= sink->num_pads);
>  
> -	link = media_entity_add_link(source);
> +	link = media_add_link(&source->links);
>  	if (link == NULL)
>  		return -ENOMEM;
>  
> @@ -622,7 +622,7 @@ media_create_pad_link(struct media_entity *source, u16 source_pad,
>  	/* Create the backlink. Backlinks are used to help graph traversal and
>  	 * are not reported to userspace.
>  	 */
> -	backlink = media_entity_add_link(sink);
> +	backlink = media_add_link(&sink->links);
>  	if (backlink == NULL) {
>  		__media_entity_remove_link(source, link);
>  		return -ENOMEM;
> 

