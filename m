Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:33103 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbbHaNmx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2015 09:42:53 -0400
Date: Mon, 31 Aug 2015 10:42:48 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v8 51/55] [media] remove interface links at
 media_entity_unregister()
Message-ID: <20150831104248.113615fb@recife.lan>
In-Reply-To: <55E44E59.5030300@xs4all.nl>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
	<36ec2d60b61f769115982c5060d550d35e3ca602.1440902901.git.mchehab@osg.samsung.com>
	<55E44E59.5030300@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 31 Aug 2015 14:53:45 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 08/30/2015 05:07 AM, Mauro Carvalho Chehab wrote:
> > Interface links connected to an entity should be removed
> > before being able of removing the entity.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > 
> > diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> > index a91e1ec076a6..638c682b79c4 100644
> > --- a/drivers/media/media-device.c
> > +++ b/drivers/media/media-device.c
> > @@ -618,14 +618,30 @@ void media_device_unregister_entity(struct media_entity *entity)
> >  		return;
> >  
> >  	spin_lock(&mdev->lock);
> > +
> > +	/* Remove interface links with this entity on it */
> > +	list_for_each_entry_safe(link, tmp, &mdev->links, graph_obj.list) {
> > +		if (media_type(link->gobj1) == MEDIA_GRAPH_ENTITY
> > +		    && link->entity == entity) {
> 
> I don't think you need the == MEDIA_GRAPH_ENTITY check here. That should always be
> true if link->entity == entity.

Yes, I know. Actually, I coded it as just  if (link->entity == entity).
Latter, when reviewing my own patch, I decided to add the extra
check, as it sounded me a little better.

Not sure really what would be the better.

> 
> > +			media_gobj_remove(&link->graph_obj);
> > +			kfree(link);
> > +		}
> > +	}
> > +
> > +	/* Remove all data links that belong to this entity */
> >  	list_for_each_entry_safe(link, tmp, &entity->links, list) {
> >  		media_gobj_remove(&link->graph_obj);
> >  		list_del(&link->list);
> >  		kfree(link);
> >  	}
> > +
> > +	/* Remove all pads that belong to this entity */
> >  	for (i = 0; i < entity->num_pads; i++)
> >  		media_gobj_remove(&entity->pads[i].graph_obj);
> > +
> > +	/* Remove the entity */
> >  	media_gobj_remove(&entity->graph_obj);
> > +
> >  	spin_unlock(&mdev->lock);
> >  	entity->graph_obj.mdev = NULL;
> >  }
> > 
> 
> Regards,
> 
> 	Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
