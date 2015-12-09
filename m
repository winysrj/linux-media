Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:49858 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673AbbLINjZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Dec 2015 08:39:25 -0500
Date: Wed, 9 Dec 2015 11:39:19 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH v8 52/55] [media] media-device: remove interfaces and
 interface links
Message-ID: <20151209113919.79d49642@recife.lan>
In-Reply-To: <2308569.EQQ6uCyAre@avalon>
References: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com>
	<fcb7fe56b016191b35dfc9fbc007ba1a1f35e837.1441540862.git.mchehab@osg.samsung.com>
	<2308569.EQQ6uCyAre@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 23 Nov 2015 23:22:56 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> Thank you for the patch.
> 
> On Sunday 06 September 2015 09:03:12 Mauro Carvalho Chehab wrote:
> > Just like what's done with entities, when the media controller is
> > unregistered, release any interface and interface links that
> > might still be there.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > 
> > diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> > index 7c37aeab05bb..0238885fcc74 100644
> > --- a/drivers/media/media-device.c
> > +++ b/drivers/media/media-device.c
> > @@ -574,6 +574,22 @@ void media_device_unregister(struct media_device *mdev)
> > {
> >  	struct media_entity *entity;
> >  	struct media_entity *next;
> > +	struct media_link *link, *tmp_link;
> > +	struct media_interface *intf, *tmp_intf;
> > +
> > +	/* Remove interface links from the media device */
> > +	list_for_each_entry_safe(link, tmp_link, &mdev->links,
> > +				 graph_obj.list) {
> > +		media_gobj_remove(&link->graph_obj);
> > +		kfree(link);
> > +	}
> > +
> > +	/* Remove all interfaces from the media device */
> > +	list_for_each_entry_safe(intf, tmp_intf, &mdev->interfaces,
> > +				 graph_obj.list) {
> > +		media_gobj_remove(&intf->graph_obj);
> > +		kfree(intf);
> > +	}
> > 
> >  	list_for_each_entry_safe(entity, next, &mdev->entities, graph_obj.list)
> >  		media_device_unregister_entity(entity);
> > @@ -651,7 +667,6 @@ void media_device_unregister_entity(struct media_entity
> > *entity) /* Remove all data links that belong to this entity */
> >  	list_for_each_entry_safe(link, tmp, &entity->links, list) {
> >  		media_gobj_remove(&link->graph_obj);
> > -		list_del(&link->list);
> >  		kfree(link);
> 
> The link has already been freed in media_device_unregister(). You have access-
> after-free and double-free issues here.
> 
> >  	}
> > 
> > diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> > index a37ccd2edfd5..cd4d767644df 100644
> > --- a/drivers/media/media-entity.c
> > +++ b/drivers/media/media-entity.c
> > @@ -206,6 +206,10 @@ void media_gobj_remove(struct media_gobj *gobj)
> > 
> >  	/* Remove the object from mdev list */
> >  	list_del(&gobj->list);
> > +
> > +	/* Links have their own list - we need to drop them there too */
> > +	if (media_type(gobj) == MEDIA_GRAPH_LINK)
> > +		list_del(&gobj_to_link(gobj)->list);
> 
> Please... That's a very bad layering violation. Let's not do that. Generic 
> graph object code should not contain any type-specific code. You can create a 
> media_link_remove() function for links that will remove the link from the 
> entity links list and call media_gobj_remove().
> 
> >  }
> > 
> >  /**
> > diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> > index ca4a4f23362f..fb5f0e21f137 100644
> > --- a/include/media/media-entity.h
> > +++ b/include/media/media-entity.h
> > @@ -153,7 +153,7 @@ struct media_entity {
> >  };
> > 
> >  /**
> > - * struct media_intf_devnode - Define a Kernel API interface
> > + * struct media_interface - Define a Kernel API interface
> 
> This belongs to a different patch ;-)
> 
> >   *
> >   * @graph_obj:		embedded graph object
> >   * @list:		Linked list used to find other interfaces that belong
> > @@ -163,6 +163,11 @@ struct media_entity {
> >   *			uapi/media/media.h header, e. g.
> >   *			MEDIA_INTF_T_*
> >   * @flags:		Interface flags as defined at uapi/media/media.h
> > + *
> > + * NOTE: As media_device_unregister() will free the address of the
> > + *	 media_interface, this structure should be embedded as the first
> > + *	 element of the derived functions, in order for the address to be
> > + *	 the same.
> 
> s/NOTE/DIRTY HACK/
> 
> Or, much better, let's fix it :-) If you want to be able to destroy graph 
> object without needing to know their type, you can add a destroy operation to 
> the graph objects and have per-type implementations. There's probably other 
> options as well.
> 
> >   */
> >  struct media_interface {
> >  	struct media_gobj		graph_obj;
> > @@ -179,11 +184,11 @@ struct media_interface {
> >   * @minor:	Minor number of a device node
> >   */
> >  struct media_intf_devnode {
> > -	struct media_interface		intf;
> > +	struct media_interface	intf; /* must be first field in struct */
> > 
> >  	/* Should match the fields at media_v2_intf_devnode */
> > -	u32				major;
> > -	u32				minor;
> > +	u32			major;
> > +	u32			minor;
> 
> This doesn't belong to this patch either.
> 
> >  };
> > 
> >  static inline u32 media_entity_id(struct media_entity *entity)
> 

Thanks for review!

Indeed, this patch had several troubles. I reworked on it, fixing
the pointed issues. The new version is enclosed.

I tested it with both KASAN and KMEMLEAK, and it is working as
expected:
	- no memleaks at the media controller core;
	- no memory usage on a freed data.

Regards,
Mauro


[media] media-device: remove interfaces and interface links

Just like what's done with entities, when the media controller is
unregistered, release any interface and interface links that
might still be there.

Change-Id: I51c1742fe071965f4606d98ed890712e81a1d4d9
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/media-device.c |   30 +++++++++++++++++++-----------
 drivers/media/media-entity.c |    7 ++++++-
 include/media/media-entity.h |    1 +
 3 files changed, 26 insertions(+), 12 deletions(-)

--- patchwork.orig/drivers/media/media-device.c
+++ patchwork/drivers/media/media-device.c
@@ -574,6 +574,17 @@ void media_device_unregister(struct medi
 {
 	struct media_entity *entity;
 	struct media_entity *next;
+	struct media_interface *intf, *tmp_intf;
+
+	/* Remove all interfaces from the media device */
+	spin_lock(&mdev->lock);
+	list_for_each_entry_safe(intf, tmp_intf, &mdev->interfaces,
+				 graph_obj.list) {
+		__media_remove_intf_links(intf);
+		media_gobj_remove(&intf->graph_obj);
+		kfree(intf);
+	}
+	spin_unlock(&mdev->lock);
 
 	list_for_each_entry_safe(entity, next, &mdev->entities, graph_obj.list)
 		media_device_unregister_entity(entity);
@@ -633,27 +644,24 @@ void media_device_unregister_entity(stru
 	int i;
 	struct media_device *mdev = entity->graph_obj.mdev;
 	struct media_link *link, *tmp;
+	struct media_interface *intf;
 
 	if (mdev == NULL)
 		return;
 
 	spin_lock(&mdev->lock);
 
-	/* Remove interface links with this entity on it */
-	list_for_each_entry_safe(link, tmp, &mdev->links, graph_obj.list) {
-		if (media_type(link->gobj1) == MEDIA_GRAPH_ENTITY
-		    && link->entity == entity) {
-			media_gobj_remove(&link->graph_obj);
-			kfree(link);
+	/* Remove all interface links pointing to this entity */
+	list_for_each_entry(intf, &mdev->interfaces, graph_obj.list) {
+		list_for_each_entry_safe(link, tmp, &intf->links, list) {
+			if (media_type(link->gobj1) == MEDIA_GRAPH_ENTITY
+			    && link->entity == entity)
+				__media_remove_intf_link(link);
 		}
 	}
 
 	/* Remove all data links that belong to this entity */
-	list_for_each_entry_safe(link, tmp, &entity->links, list) {
-		media_gobj_remove(&link->graph_obj);
-		list_del(&link->list);
-		kfree(link);
-	}
+	__media_entity_remove_links(entity);
 
 	/* Remove all pads that belong to this entity */
 	for (i = 0; i < entity->num_pads; i++)
--- patchwork.orig/drivers/media/media-entity.c
+++ patchwork/drivers/media/media-entity.c
@@ -674,9 +674,12 @@ static void __media_entity_remove_link(s
 
 		/* Remove the remote link */
 		list_del(&rlink->list);
+		media_gobj_remove(&rlink->graph_obj);
+
 		kfree(rlink);
 	}
 	list_del(&link->list);
+	media_gobj_remove(&link->graph_obj);
 	kfree(link);
 }
 
@@ -920,11 +923,13 @@ struct media_link *media_create_intf_lin
 EXPORT_SYMBOL_GPL(media_create_intf_link);
 
 
-static void __media_remove_intf_link(struct media_link *link)
+void __media_remove_intf_link(struct media_link *link)
 {
+	list_del(&link->list);
 	media_gobj_remove(&link->graph_obj);
 	kfree(link);
 }
+EXPORT_SYMBOL_GPL(__media_remove_intf_link);
 
 void media_remove_intf_link(struct media_link *link)
 {
--- patchwork.orig/include/media/media-entity.h
+++ patchwork/include/media/media-entity.h
@@ -325,6 +325,7 @@ void media_devnode_remove(struct media_i
 struct media_link *media_create_intf_link(struct media_entity *entity,
 					    struct media_interface *intf,
 					    u32 flags);
+void __media_remove_intf_link(struct media_link *link);
 void media_remove_intf_link(struct media_link *link);
 void __media_remove_intf_links(struct media_interface *intf);
 void media_remove_intf_links(struct media_interface *intf);


