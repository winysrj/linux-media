Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:57172 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964835AbbHKNWL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2015 09:22:11 -0400
Date: Tue, 11 Aug 2015 10:22:01 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hansverk@cisco.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Tina Ruchandani <ruchandani.tina@gmail.com>,
	Akihiro Tsukada <tskd08@gmail.com>,
	Antti Palosaari <crope@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Markus Elfring <elfring@users.sourceforge.net>,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH RFC v2 09/16] media: use media_graph_obj for link
 endpoints
Message-ID: <20150811102201.5abaf64d@recife.lan>
In-Reply-To: <55C9E9AE.5020602@cisco.com>
References: <cover.1439292977.git.mchehab@osg.samsung.com>
	<6d02794028ea4f7ad33e3ba0e07e0c690e2feee2.1439292977.git.mchehab@osg.samsung.com>
	<55C9E9AE.5020602@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 11 Aug 2015 14:25:18 +0200
Hans Verkuil <hansverk@cisco.com> escreveu:

> Hi Mauro,
> 
> Thanks for posting the missing patches.

Thanks for reviewing this patch series!

> 
> On 08/11/15 14:09, Mauro Carvalho Chehab wrote:
> > As we'll need to create links between entities and interfaces,
> > we need to identify the link endpoints by the media_graph_obj.
> > 
> > Most of the changes here was done by this small script:
> > 
> > for i in `find drivers/media -type f` `find drivers/staging/media -type f`; do
> > 	perl -ne 's,([\w]+)\-\>(source|sink)\-\>entity,gobj_to_pad($1->$2)->entity,; print $_;' <$i >a && mv a $i
> > done
> > 
> > Please note that, while we're now using graph_obj to reference
> > the link endpoints, we're still assuming that all endpoints are
> > pads. This is true for all existing links, so no problems
> > are expected so far.
> > 
> > Yet, as we introduce links between entities and interfaces,
> > we may need to change some existing code to work with links
> > that aren't pad to pad.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > 
> 
> <snip>
> 
> > diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> > index 403019035424..f6e2136480f1 100644
> > --- a/include/media/media-entity.h
> > +++ b/include/media/media-entity.h
> > @@ -43,6 +43,17 @@ enum media_graph_type {
> >  	MEDIA_GRAPH_LINK,
> >  };
> >  
> > +/**
> > + * enum media_graph_link_dir - direction of a link
> > + *
> > + * @MEDIA_LINK_DIR_BIDIRECTIONAL	Link is bidirectional
> > + * @MEDIA_LINK_DIR_PAD_0_TO_1		Link is unidirectional,
> > + *					from port 0 (source) to port 1 (sink)
> > + */
> > +enum media_graph_link_dir {
> > +	MEDIA_LINK_DIR_BIDIRECTIONAL,
> > +	MEDIA_LINK_DIR_PORT0_TO_PORT1,
> > +};
> 
> 1) the comment and the actual enum are out-of-sync

Ah, yes. I was in doubt about using PAD or PORT here. I ended by using
port at the links, as the endpoints can either be an interface/entity
or a pad. So, I decided to use port.

> 2) why not just make a 'BIRECTIONAL' link flag instead of inventing
>    a new enum? Adding yet another field seems overkill to me. Have a
>    'BIDIRECTIONAL' flag seems perfectly OK to me (and useful for the
>    application as well).

Yeah, we can use flags, instead. I decided to use an enum here just
to make it clearer about the two possible options.

I was actually considering to rename media_link source/sink to
port0/port1, as using "source"/"sink" names on a bidirection link
doesn't make sense. I'm still in doubt about such rename, though,
as it would make harder to inspect the graph traversal routines.

Also, I want to force all places that create a link to choose
between either BIRECTIONAL or PORT0_TO_PORT1, as this makes easier
to review if the code is doing the right thing when inspecting it.

In summary, I would prefer to keep this internally as a separate
 enum, at least for now. We can latter simplify it and use a flag
for that (or maybe two flags?).

> 
> >  
> >  /* Structs to represent the objects that belong to a media graph */
> >  
> > @@ -72,9 +83,9 @@ struct media_pipeline {
> >  
> >  struct media_link {
> >  	struct list_head list;
> > -	struct media_graph_obj			graph_obj;
> > -	struct media_pad *source;	/* Source pad */
> > -	struct media_pad *sink;		/* Sink pad  */
> > +	struct media_graph_obj		graph_obj;
> > +	enum media_graph_link_dir	dir;
> > +	struct media_graph_obj		*source, *sink;
> 
> I'm not too keen about all the gobj_to_foo(obj) macros that this requires. It
> is rather ugly code.
> 
> What about this:
> 
> 	union {
> 		struct media_graph_obj *source;
> 		struct media_pad *source_pad;
> 		struct media_interface *source_intf;
> 	};
> 	union {
> 		struct media_graph_obj *sink;
> 		struct media_pad *sink_pad;
> 		struct media_entity *sink_ent;
> 	};
> 
> Now the code can just use ->source_pad etc.

good idea. Will do that on a version 3. I think that, in this case, the
best is to write a note that the first element at pad/entity/interface
should be the graph_obj.

I would actually call port0_intf and port1_ent on the above structs,
as it makes no sense to call sink/source for interface->entity links.

> >  	struct media_link *reverse;	/* Link in the reverse direction */
> >  	unsigned long flags;		/* Link flags (MEDIA_LNK_FL_*) */
> >  };
> > @@ -115,6 +126,11 @@ struct media_entity {
> >  	u32 group_id;			/* Entity group ID */
> >  
> >  	u16 num_pads;			/* Number of sink and source pads */
> > +
> > +	/*
> > +	 * Both num_links and num_backlinks are used only to report
> > +	 * the number of links via MEDIA_IOC_ENUM_ENTITIES at media_device.c
> > +	 */
> >  	u16 num_links;			/* Number of existing links, both
> >  					 * enabled and disabled */
> >  	u16 num_backlinks;		/* Number of backlinks */
> > @@ -171,6 +187,12 @@ struct media_entity_graph {
> >  #define gobj_to_entity(gobj) \
> >  		container_of(gobj, struct media_entity, graph_obj)
> >  
> > +#define gobj_to_link(gobj) \
> > +		container_of(gobj, struct media_link, graph_obj)
> > +
> > +#define gobj_to_pad(gobj) \
> > +		container_of(gobj, struct media_pad, graph_obj)
> > +
> 
> I saw a lot of type checks (if (link->sink.type != MEDIA_GRAPH_PAD))
> that I think would look cleaner if there was a simple static inline
> helper:
> 
> static inline bool is_pad(const struct media_graph_obj *obj)
> {
> 	return obj->type == MEDIA_GRAPH_PAD;
> }
> 
> media_is_pad() will work as well, but I think brevity is more useful
> in this case. Personal opinion, though.

I would use media_is_pad() instead, to avoid namespace conflicts. We may
eventually need other inline functions for other types in the future.

> 
> >  void graph_obj_init(struct media_device *mdev,
> >  		    enum media_graph_type type,
> >  		    struct media_graph_obj *gobj);
> > 
> 
> Regards,
> 
> 	Hans
