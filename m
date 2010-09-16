Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:43507 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827Ab0IPLL0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Sep 2010 07:11:26 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC/PATCH v4 05/11] media: Reference count and power handling
Date: Thu, 16 Sep 2010 13:11:27 +0200
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	linux-media@vger.kernel.org
References: <1282318153-18885-1-git-send-email-laurent.pinchart@ideasonboard.com> <201009161046.03098.laurent.pinchart@ideasonboard.com> <4C91F301.3050508@redhat.com>
In-Reply-To: <4C91F301.3050508@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009161311.28531.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

On Thursday 16 September 2010 12:35:45 Mauro Carvalho Chehab wrote:
> Em 16-09-2010 05:46, Laurent Pinchart escreveu:
> > On Saturday 11 September 2010 22:38:33 Sakari Ailus wrote:
> >> Mauro Carvalho Chehab wrote:
> >>> Em 20-08-2010 12:29, Laurent Pinchart escreveu:
> >>>> From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> >>>> 
> >>>> Basically these are the interface functions:
> >>>> 
> >>>> media_entity_get() - acquire entity
> >>>> media_entity_put() - release entity
> >>>> 
> >>>> 	If the entity is of node type, the power change is distributed to
> >>>> 	all connected entities. For non-nodes it only affects that very
> >>>> 	node. A mutex is used to serialise access to the entity graph.
> >>>> 
> >>>> In the background there's a depth-first search algorithm that
> >>>> traverses the active links in the graph. All these functions parse
> >>>> the graph to implement whatever they're to do.
> >>>> 
> >>>> The module counters are increased/decreased in media_entity_get/put to
> >>>> prevent module unloading when an entity is referenced.
> >>>> 
> >>>> Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> >>>> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >>>> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
> >>>> ---
> >>>> 
> >>>>  Documentation/media-framework.txt |   37 +++++++++
> >>>>  drivers/media/media-device.c      |    1 +
> >>>>  drivers/media/media-entity.c      |  146
> >>>>  +++++++++++++++++++++++++++++++++++++ include/media/media-device.h
> >>>>  
> >>>>   |    4 +
> >>>>  
> >>>>  include/media/media-entity.h      |   15 ++++
> >>>>  5 files changed, 203 insertions(+), 0 deletions(-)
> >>>> 
> >>>> diff --git a/Documentation/media-framework.txt
> >>>> b/Documentation/media-framework.txt index a599824..59649e9 100644
> >>>> --- a/Documentation/media-framework.txt
> >>>> +++ b/Documentation/media-framework.txt
> >>>> @@ -278,3 +278,40 @@ When the graph traversal is complete the function
> >>>> will return NULL.
> >>>> 
> >>>>  Graph traversal can be interrupted at any moment. No cleanup function
> >>>>  call is required and the graph structure can be freed normally.
> >>>> 
> >>>> +
> >>>> +Reference counting and power handling
> >>>> +-------------------------------------
> >>>> +
> >>>> +Before accessing type-specific entities operations (such as the V4L2
> >>>> +sub-device operations), drivers must acquire a reference to the
> >>>> entity. This +ensures that the entity will be powered on and ready to
> >>>> accept requests. +Similarly, after being done with an entity, drivers
> >>>> must release the +reference.
> >>>> +
> >>>> +	media_entity_get(struct media_entity *entity)
> >>>> +
> >>>> +The function will increase the entity reference count. If the entity
> >>>> is a node +(MEDIA_ENTITY_TYPE_NODE type), the reference count of all
> >>>> entities it is +connected to, both directly or indirectly, through
> >>>> active links is increased. +This ensures that the whole media
> >>>> pipeline will be ready to process +
> >>>> +Acquiring a reference to an entity increases the media device module
> >>>> reference +count to prevent module unloading when an entity is being
> >>>> used. +
> >>>> +media_entity_get will return a pointer to the entity if successful,
> >>>> or NULL +otherwise.
> >>>> +
> >>>> +	media_entity_put(struct media_entity *entity)
> >>>> +
> >>>> +The function will decrease the entity reference count and, for node
> >>>> entities, +like media_entity_get, the reference count of all connected
> >>>> entities. Calling +media_entity_put with a NULL argument is valid and
> >>>> will return immediately. +
> >>>> +When the first reference to an entity is acquired, or the last
> >>>> reference +released, the entity's set_power operation is called.
> >>>> Entity drivers must +implement the operation if they need to perform
> >>>> any power management task, +such as turning powers or clocks on or
> >>>> off. If no power management is +required, drivers don't need to
> >>>> provide a set_power operation. The operation +is allowed to fail when
> >>>> turning power on, in which case the media_entity_get +function will
> >>>> return NULL.
> >>> 
> >>> The idea of doing power management via media entity get/put doesn't
> >>> seem right. The mediabus interface and its usage should be optional,
> >>> and only specialized applications will likely implement it. If a
> >>> refcount 0 means power off, it ends that a device implementing the
> >>> media bus will not work with V4L2 applications.
> >> 
> >> The Media controller does handle the power through reference count but
> >> this does not limit to subdev entities. The reference count is also
> >> applied recursively to all entities which are connected through active
> >> links.
> >> 
> >> There are two cases:
> >> 
> >> 1. The user application opens a subdev node. The subdev entity use count
> >> will be incremented and the subdev will be powered up.
> >> 
> >> 2. The user application opens a video node. The reference count for all
> >> entities connected to the video node entity through active links will be
> >> incremented. Subdevs will be powered up as well (if they are not already
> >> because of (1) above). The same works if the entities connected through
> >> a video node are connected to another entity and the link to that entity
> >> is activated. In this case the use_counts of the entity sets are applied
> >> across the both sets.
> >> 
> >> The user application does not need to use the Media controller interface
> >> to get this functionality.
> > 
> > That's correct. The subdev s_power operation is still there and can be
> > called directly by non-MC bridge drivers as required.
> 
> It is clear that non-MC bridge devices will not be affected by MC.
> 
> My concern is about MC bridge drivers. Userspace may not be implementing
> MC. Yet, the device needs to fully work. If you're relying at MC to power
> up parts of the device, this means that a pure V4L2 application won't work
> anymore.
> 
> I didn't see any patch on this series addressing this case.

When the non-MC userspace application will open a video device node, the 
media_entity_get() call will power up all entities (subdevs in this case) in 
the pipeline, so it will be completely transparent for V4L2-only applications.

-- 
Regards,

Laurent Pinchart
