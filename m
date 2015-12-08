Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:47784 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494AbbLHUXy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Dec 2015 15:23:54 -0500
Date: Tue, 8 Dec 2015 18:23:50 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v8 50/55] [media] media-entity: unregister entity links
Message-ID: <20151208182350.15f3a0b4@recife.lan>
In-Reply-To: <2087950.8UOe3P6UsK@avalon>
References: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com>
	<43cafe9354b359f2827ff37d574681b94fe1e2cb.1441540862.git.mchehab@osg.samsung.com>
	<2087950.8UOe3P6UsK@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 23 Nov 2015 23:27:40 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> Thank you for the patch.
> 
> On Sunday 06 September 2015 09:03:10 Mauro Carvalho Chehab wrote:
> > Add functions to explicitly unregister all entity links.
> > This function is called automatically when an entity
> > link is destroyed.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> > index 064515f2ba9b..a37ccd2edfd5 100644
> > --- a/drivers/media/media-entity.c
> > +++ b/drivers/media/media-entity.c
> > @@ -903,6 +903,7 @@ EXPORT_SYMBOL_GPL(media_devnode_create);
> > 
> >  void media_devnode_remove(struct media_intf_devnode *devnode)
> >  {
> > +	media_remove_intf_links(&devnode->intf);
> >  	media_gobj_remove(&devnode->intf.graph_obj);
> >  	kfree(devnode);
> >  }
> > @@ -944,3 +945,25 @@ void media_remove_intf_link(struct media_link *link)
> >  	mutex_unlock(&link->graph_obj.mdev->graph_mutex);
> >  }
> >  EXPORT_SYMBOL_GPL(media_remove_intf_link);
> > +
> > +void __media_remove_intf_links(struct media_interface *intf)
> > +{
> > +	struct media_link *link, *tmp;
> > +
> > +	list_for_each_entry_safe(link, tmp, &intf->links, list)
> > +		__media_remove_intf_link(link);
> > +
> > +}
> > +EXPORT_SYMBOL_GPL(__media_remove_intf_links);
> 
> The only place where this function is used is in media_remove_intf_links() 
> below. How about inlining it for now ?
> 
> > +void media_remove_intf_links(struct media_interface *intf)
> > +{
> > +	/* Do nothing if the intf is not registered. */
> > +	if (intf->graph_obj.mdev == NULL)
> > +		return;
> > +
> > +	mutex_lock(&intf->graph_obj.mdev->graph_mutex);
> > +	__media_remove_intf_links(intf);
> > +	mutex_unlock(&intf->graph_obj.mdev->graph_mutex);
> > +}
> > +EXPORT_SYMBOL_GPL(media_remove_intf_links);
> 
> As this function is exported it should be documented with kerneldoc.

Will do both on a followup patch.

> 
> > diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> > index bc7eb6240795..ca4a4f23362f 100644
> > --- a/include/media/media-entity.h
> > +++ b/include/media/media-entity.h
> > @@ -318,6 +318,9 @@ struct media_link *media_create_intf_link(struct
> > media_entity *entity, struct media_interface *intf,
> >  					    u32 flags);
> >  void media_remove_intf_link(struct media_link *link);
> > +void __media_remove_intf_links(struct media_interface *intf);
> > +void media_remove_intf_links(struct media_interface *intf);
> > +
> > 
> >  #define media_entity_call(entity, operation, args...)			\
> >  	(((entity)->ops && (entity)->ops->operation) ?			\
> 
