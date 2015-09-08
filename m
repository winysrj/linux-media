Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:34821 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754419AbbIHKF4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Sep 2015 06:05:56 -0400
Date: Tue, 8 Sep 2015 07:05:50 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v6 2/8] [media] media: add a common struct to be embed
 on media graph objects
Message-ID: <20150908070550.1c7d23f3@recife.lan>
In-Reply-To: <1533583.FbVB9fTcuR@avalon>
References: <cover.1439981515.git.mchehab@osg.samsung.com>
	<1667127.681LBiMjnq@avalon>
	<55D6DC48.3070406@xs4all.nl>
	<1533583.FbVB9fTcuR@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 08 Sep 2015 00:49:58 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Hans,
> 
> On Friday 21 August 2015 10:07:36 Hans Verkuil wrote:
> > On 08/21/2015 03:02 AM, Laurent Pinchart wrote:
> > > On Wednesday 19 August 2015 08:01:49 Mauro Carvalho Chehab wrote:
> > >> +/* Enums used internally at the media controller to represent graphs */
> > >> +
> > >> +/**
> > >> + * enum media_gobj_type - type of a graph element
> > > 
> > > Let's try to standardize the vocabulary, should it be called graph object
> > > or graph element ? In the first case let's document it as graph object.
> > > In the second case it would be more consistent to refer to it as enum
> > > media_gelem_type (and struct media_gelem below).
> > 
> > For what it is worth, I prefer the term graph object.
> 
> So do I.

At v7 we removed the term "elements" in favor of "objects", as proposed by
Hans.

> 
> > >> + *
> > >> + */
> > >> +enum media_gobj_type {
> > >> +	 /* FIXME: add the types here, as we embed media_gobj */
> > >> +	MEDIA_GRAPH_NONE
> > >> +};
> > >> +
> > >> +#define MEDIA_BITS_PER_TYPE		8
> > >> +#define MEDIA_BITS_PER_LOCAL_ID		(32 - MEDIA_BITS_PER_TYPE)
> > >> +#define MEDIA_LOCAL_ID_MASK		 GENMASK(MEDIA_BITS_PER_LOCAL_ID - 1, 
> 0)
> > >> +
> > >> +/* Structs to represent the objects that belong to a media graph */
> > >> +
> > >> +/**
> > >> + * struct media_gobj - Define a graph object.
> > >> + *
> > >> + * @id:		Non-zero object ID identifier. The ID should be unique
> > >> + *		inside a media_device, as it is composed by
> > >> + *		MEDIA_BITS_PER_TYPE to store the type plus
> > >> + *		MEDIA_BITS_PER_LOCAL_ID	to store a per-type ID
> > >> + *		(called as "local ID").
> > > 
> > > I'd very much prefer using a single ID range and adding a type field.
> > > Abusing bits of the ID field to store the type will just makes IDs
> > > impractical to use. Let's do it properly.
> > 
> > Why is that impractical? I think it is more practical. Why waste memory on
> > something that is easy to encode in the ID?
> > 
> > I'm not necessarily opposed to splitting this up (Mauro's initial patch
> > series used a separate type field if I remember correctly), but it's not
> > clear to me what the benefits are. Keeping it in a single u32 makes
> > describing links also very easy since you just give it the two objects that
> > are linked and it is immediately clear which object types are linked: no
> > need to either store the types in the link struct or look up each object to
> > find the type.
> > 
> > >> + * All elements on the media graph should have this struct embedded
> > > 
> > > All elements (objects) or only the ones that need an ID ? Or maybe we'll
> > > define graph element (object) as an element (object) that has an ID,
> > > making some "elements" not elements.
> > 
> > Yes, all objects have an ID. I see no reason to special-case this.
> > 
> > You wrote this at 3 am, so you were probably sleep-deprived when you wrote
> > the second sentence as I can't wrap my head around that one :-)
> 
> It's always 3:00am in some time zone, but it wasn't in Seattle ;-)
> 
> The question was whether every element is required to have an ID. If some of 
> what we currently call element doesn't need an ID, then we'll have to either 
> modify the quoted documentation, or redefine "element" to only include the 
> elements that have an ID, making the graph objects that don't have an ID not 
> "elements".

Sorry but I read the above 3 or 4 times, but I failed to understand
what you're meaning.

There's one good reason for all objects to have an ID: userspace
should be able to detect if a graph object was removed.

I mean, let's suppose that the topology_version has changed, because
some links were removed and others added, among other changes.

If all objects have an object ID, it is easy (and quick, because all
it needs to do is to compare a u32 integer) for userspace to compare the
previously retrieved topology with the new one and check what objects
were dropped/added by checking the object ID.

Regards,
Mauro
