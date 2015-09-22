Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:38573 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932621AbbIVMLu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2015 08:11:50 -0400
Date: Tue, 22 Sep 2015 09:11:44 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	javier@osg.samsung.com, hverkuil@xs4all.nl
Subject: Re: [RFC 0/9] Unrestricted media entity ID range support
Message-ID: <20150922091144.328735a3@recife.lan>
In-Reply-To: <55FE5F91.6090506@linux.intel.com>
References: <1441966152-28444-1-git-send-email-sakari.ailus@linux.intel.com>
	<20150919092231.55fd5c28@osg.samsung.com>
	<55FE5F91.6090506@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 20 Sep 2015 10:26:09 +0300
Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:

> Hi Mauro,
> 
> Mauro Carvalho Chehab wrote:
> > Hi Sakari,
> >
> > On Fri, 11 Sep 2015 13:09:03 +0300
> > Sakari Ailus <sakari.ailus@linux.intel.com> wrote:
> >
> >> Hi all,
> >>
> >> This patchset adds an API for managing entity enumerations, i.e.
> >> storing a bit of information per entity. The entity ID is no longer
> >> limited to small integers (e.g. 31 or 63), but
> >> MEDIA_ENTITY_MAX_LOW_ID. The drivers are also converted to use that
> >> instead of a fixed number.
> >>
> >> If the number of entities in a real use case grows beyond the
> >> capabilities of the approach, the algorithm may be changed. But most
> >> importantly, the API is used to perform the same operation everywhere
> >> it's done.
> >>
> >> I'm sending this for review only, the code itself is untested.
> >>
> >> I haven't entirely made up my mind on the fourth patch. It could be
> >> dropped, as it uses the API for a somewhat different purpose.
> >>
> >
> > Sorry for not reviewing this earlier, but I'm traveling this week to
> > China, and I was having some troubles with the Internet. Btw, I don't
> > have my notebook here (just a chromebook without the media tree).
> > So, please consider this as just a preliminary review.
> >
> > I won't be comment this series patch by patch, because it is really
> > painful to do it while here with this Internet.
> >
> > Also, I want to discuss the patch series as a hole.
> >
> >  From what we've agreed last week, we won't be using a separate ID
> > range for the entity ID, but this patch series is actually adding
> > it, and, IMHO, using a confusing nomenclature: instead of calling the
> > entity ID range as "entity_id" at the media_device struct, you're
> > now calling it "low_id". That sounds confusing to me. If you think
> > we should keep a separate range for entities, calling it as
> > "entity_id" is clearer.
> 
> It's *not* the entity ID. It's a number used internally to keep track of 
> the entities, and only used for this purpose, nothing else. If you look 
> at the patch, the number of places where low_id is used is very limited. 
> Individual drivers do not and must not access the low_id field.
> 
> The underlying algorithm for keeping track of entities does not change, 
> but that could be changed later on without affecting the users of the 
> alrogithm. --- See patch 3.
> 
> There are two main reasons for this:
> 
> 1. No need to implement a new algorithm which would be less efficient 
> but could cope in cases we do not have yet; this can be done later on, 
> as patch 3 adds an API to access the information without making 
> assumptions on the implementation.

If this is an internal number used only by the graph traversal
algorithm, then the implementation doesn't seem correct. I mean:
such number should be generated internally when starting the
graph traversal algorithm, and it would be better to store such
graph-traversal internal algorithm data on a separate struct.

> 2. It does solve the problem. The graph object IDs of the entities can 
> be large without adversely affecting the functionality of existing drivers.

Right now, with just those 9 patches, it doesn't ;)

I mean: if I apply your patches after the MC next gen ones and try to use the
graph traversal, it will do the wrong thing for hybrid TV cards, as the number
of entities there are more than 64. Ok, easy to fix after this series by
just changing the value of MEDIA_ENTITY_MAX_LOW_ID, but this will only
work while we don't implement dynamic support.

> >
> > Also, you said at the low_id comment that if an entity is
> > unregistered and then re-registered, it would preserve the same
> 
> I never claimed that, and the patchset does not implement that either.

That's what I understood from this comment:

	Rename the macro as it no longer is a maximum ID that an entity can have,
	but a low ID which is used for internal purposes of enumeration. This is
	the maximum number of concurrent entities that may exist in a media
	device.

If this is the "max number of concurrent entities", you need to reassign
those numbers when entities are removed.

If this is not what you're meaning, then fix the patch description
to let it clearer.

I guess then that "low ID" is actually an upper bound for that
graph-traversal only control number. We should really not use the word "ID"
here, as this is not an ID. it is just some index/control number that will
be granted to be below some upper bound.

> If an entity is unregistered and registered again, from the MC point of 
> view it is not the same entity. We do not keep track of entities that 
> are not registered with MC, do we?
> 
> > entity ID. That doesn't seem easy to implement, as we would need
> > to track those previously-used ID. On the other hand, if we just
> > re-use a previously released ID for some other entity, this can
> > be a problem, as userspace may not be aware of such changes and
> > might be asking the Kernel to do the wrong thing.
> 
> Let's not do that then. This is why we have graph object IDs.

Ok, provided that we better describe it and better represent those
fields.

> >
> > So, I can't see how non-monotonically incremented numbers would
> > work here.
> >
> > Finally, the changes you did still rely on having the ID limited
> > to a well-defined, hardcoded number (MEDIA_ENTITY_MAX_LOW_ID).
> >
> > I can see this working only if:
> >
> > - We keep a separate range ID for entities (so, having a minimum
> >    of two ranges);
> >
> > - the entity maximum ID is defined by the driver (as the number
> >    of entities is actually dependent on the hardware);
> 
> The case is that we do not have a driver requiring more entities. 

We do: the DVB and hybrid TV drivers. A reasonable limit for a
PC consumer device like that would be an upper bound at the order
of 2^10.

> Once 
> we do, we can implement a new algorithm for the purpose. Memory 
> allocation will be required, but that's a separate matter from the graph 
> object ID of the entities, which is the problem this patchset was 
> intended to solve.

The problem this patchset should be solving is exactly the case
of those new drivers that are being properly mapped with the MC
next gen patches ;)

> >
> > - some other mechanism would be available for drivers that
> >    would support dynamic entity creation.
> >
> > So, I don't see how this would solve the problems that we
> > discussed at the last week IRC chats.
> >
> > Am I missing something?
> 
> This set indeed solves a problem, and that problem was unrestricting the 
> graph object ID of the entities. There are other problems remaining 
> before entities can be e.g. unregistered one by one, but they are 
> separate problems.

That's not the way I see it ;) I mean, for the current MC code, this patch
series is not needed, as all drivers right now have less than 64 entities.

This need only starts after/during the MC next gen patches, in order
to address two changes that come on this series:

- having an arbitrary entity ID number that will be a way bigger
  than the current upper bound (the number of entities);

- support more than 64 entities.

So, I would be expecting a patch series that would either:

1) change the graph traversal algorithms to not depend on some
upper bound limit;

	or:

2) dynamically create whatever internal index number and to
dynamically determine the upper bound limit that would be needed for the
graph traversal algorithm to work, allocating those data when the graph 
traversal algorithm starts and freeing them when the graph traversal
stops, and/or when the media device is unregistered.

> 
> >
> > Regards,
> > Mauro
> >
> > PS.: sparse already complains on two places at the media-entity where
> > bitmaps are declared at the stack. With max entities equal to 64,
> > that's not an issue, but if we change to a higher number, those will
> > need to be dynamically allocated, in order to avoid stack overflows.
> > I didn't see any patches touching that.
> 
> I agree. The aim of the set was not to increase the number of concurrent 
> entities. That is a separate problem which can be solved later on once 
> we have a use case for it.
> 

I reviewed that code. The problem there is actually unrelated to what
this patch series is trying to solve, as the problem there is due to the
number of PADs (and not on the number of entities). I mean about this
code at media_entity_pipeline_start():

	while ((entity = media_entity_graph_walk_next(&graph))) {
		DECLARE_BITMAP(active, entity->num_pads);
		DECLARE_BITMAP(has_no_links, entity->num_pads);

That limits the max number of pads, as a big number would cause a
Linux stack overflow.

Those bitmaps should likely be moved to struct media_pipeline or
struct media_device and be either dynamically created/removed or 
having them relying on a max number of pads.

I guess the latter is easier.

In any case, this is independent of the problem we're trying to
fix with this RFC patch series (and even independent of the MC
next gen series).

I'll prepare a patch for that on the top of the current master
branch.

Regards,
Mauro
