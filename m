Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:49251 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754486AbbKXK52 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Nov 2015 05:57:28 -0500
Date: Tue, 24 Nov 2015 08:57:23 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 04/18] [media] media-device: supress backlinks at
 G_TOPOLOGY ioctl
Message-ID: <20151124085723.79af4e69@recife.lan>
In-Reply-To: <2796992.BmKOJN8UBM@avalon>
References: <cover.1441559233.git.mchehab@osg.samsung.com>
	<7cc4f0ce2266e6300d349535e705941a190398e9.1441559233.git.mchehab@osg.samsung.com>
	<2796992.BmKOJN8UBM@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 23 Nov 2015 21:56:50 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> Thank you for the patch.
> 
> On Sunday 06 September 2015 14:30:47 Mauro Carvalho Chehab wrote:
> > Due to the graph traversal algorithm currently in usage, we
> > need a copy of all data links. Those backlinks should not be
> > send to userspace, as otherwise, all links there will be
> > duplicated.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > 
> > diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> > index 0238885fcc74..97eb97d9b662 100644
> > --- a/drivers/media/media-device.c
> > +++ b/drivers/media/media-device.c
> > @@ -333,6 +333,9 @@ static long __media_device_get_topology(struct
> > media_device *mdev, /* Get links and number of links */
> >  	i = 0;
> >  	media_device_for_each_link(link, mdev) {
> > +		if (link->is_backlink)
> > +			continue;
> > +
> >  		i++;
> > 
> >  		if (ret || !topo->links)
> > diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> > index cd4d767644df..4868b8269204 100644
> > --- a/drivers/media/media-entity.c
> > +++ b/drivers/media/media-entity.c
> > @@ -648,6 +648,7 @@ media_create_pad_link(struct media_entity *source, u16
> > source_pad, backlink->source = &source->pads[source_pad];
> >  	backlink->sink = &sink->pads[sink_pad];
> >  	backlink->flags = flags;
> > +	backlink->is_backlink = true;
> > 
> >  	/* Initialize graph object embedded at the new link */
> >  	media_gobj_init(sink->graph_obj.mdev, MEDIA_GRAPH_LINK,
> > diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> > index e1a89899deef..3d389f142a1d 100644
> > --- a/include/media/media-entity.h
> > +++ b/include/media/media-entity.h
> > @@ -96,6 +96,7 @@ struct media_pipeline {
> >   * @reverse:	Pointer to the link for the reverse direction of a pad to 
> pad
> >   *		link.
> >   * @flags:	Link flags, as defined at uapi/media.h (MEDIA_LNK_FL_*)
> > + * @is_backlink: Indicate if the link is a backlink.
> >   */
> >  struct media_link {
> >  	struct media_gobj graph_obj;
> > @@ -112,6 +113,7 @@ struct media_link {
> >  	};
> >  	struct media_link *reverse;
> >  	unsigned long flags;
> > +	bool is_backlink;
> 
> I agree with the purpose of this patch (and as stated for other patches in the 
> series I believe you should squash it with the patch that introduces the 
> G_TOPOLOGY ioctl) but I won't whether you couldn't do with the additional 
> variable by adding a flag for backlinks (flag that wouldn't be shown to 
> userspace).
> 
> Now that I think about it an even better implementation could be to avoid 
> creating backlinks at all. As links are now dynamically allocated you could 
> have two struct list_head in the link structure, one for the source and one 
> for the sink. It sounds too easy to be true, I wonder if I'm overlooking 
> something.

I tried that. This was actually one of my pans. However, it is not as
trivial as it seems. I explored several different alternatives:

1) we could have two lists at struct media_entity, one for links and another
one for backlinks:

struct media_link {
	...
	struct list_head list;
	...
};

struct media_entity {
	...
	struct list_head links;
	struct list_head backlinks;
	...
};

And add the link to either one of the list. However, in such case,
container_of() would not work, because the offset of the data at the 
struct media_entity will be different, if the link is at the links
or backlinks list.

2) to have 2 lists also at struct media_link, one for the links and
another one for the backlinks, but this will require non trivial
changes at the graph traversal logic.

I can foresee some other alternatives that I didn't try yet:

- to use a separate data struct for the backlinks, like:
	struct media_obj_group {
		struct *media_object;
		struct list_head list;
	}
  and use this to store backlinks. Again, would require nontrivial
  changes at the graph traversal logic and would end by spending
  some extra memory for the backlinks;

- using the same structs as already defined, patching all routines
  that use links to add the capability for them to identify if the
  link is actually a backlink. This would be non-trivial and may
  be messy.

So, while I would love to get rid of backlinks, fixing it is not
trivial at all.

Regards,
Mauro
