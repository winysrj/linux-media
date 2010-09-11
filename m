Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.47]:52840 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911Ab0IKUit (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Sep 2010 16:38:49 -0400
Message-ID: <4C8BE8C9.3050905@maxwell.research.nokia.com>
Date: Sat, 11 Sep 2010 23:38:33 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: [RFC/PATCH v4 05/11] media: Reference count and power handling
References: <1282318153-18885-1-git-send-email-laurent.pinchart@ideasonboard.com> <1282318153-18885-6-git-send-email-laurent.pinchart@ideasonboard.com> <4C883127.1070003@redhat.com>
In-Reply-To: <4C883127.1070003@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi Mauro,

Thanks for the comments!

Mauro Carvalho Chehab wrote:
> Em 20-08-2010 12:29, Laurent Pinchart escreveu:
>> From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
>>
>> Basically these are the interface functions:
>>
>> media_entity_get() - acquire entity
>> media_entity_put() - release entity
>>
>> 	If the entity is of node type, the power change is distributed to
>> 	all connected entities. For non-nodes it only affects that very
>> 	node. A mutex is used to serialise access to the entity graph.
>>
>> In the background there's a depth-first search algorithm that traverses the
>> active links in the graph. All these functions parse the graph to implement
>> whatever they're to do.
>>
>> The module counters are increased/decreased in media_entity_get/put to
>> prevent module unloading when an entity is referenced.
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
>> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
>> ---
>>  Documentation/media-framework.txt |   37 +++++++++
>>  drivers/media/media-device.c      |    1 +
>>  drivers/media/media-entity.c      |  146 +++++++++++++++++++++++++++++++++++++
>>  include/media/media-device.h      |    4 +
>>  include/media/media-entity.h      |   15 ++++
>>  5 files changed, 203 insertions(+), 0 deletions(-)
>>
>> diff --git a/Documentation/media-framework.txt b/Documentation/media-framework.txt
>> index a599824..59649e9 100644
>> --- a/Documentation/media-framework.txt
>> +++ b/Documentation/media-framework.txt
>> @@ -278,3 +278,40 @@ When the graph traversal is complete the function will return NULL.
>>  Graph traversal can be interrupted at any moment. No cleanup function call is
>>  required and the graph structure can be freed normally.
>>  
>> +
>> +Reference counting and power handling
>> +-------------------------------------
>> +
>> +Before accessing type-specific entities operations (such as the V4L2
>> +sub-device operations), drivers must acquire a reference to the entity. This
>> +ensures that the entity will be powered on and ready to accept requests.
>> +Similarly, after being done with an entity, drivers must release the
>> +reference.
>> +
>> +	media_entity_get(struct media_entity *entity)
>> +
>> +The function will increase the entity reference count. If the entity is a node
>> +(MEDIA_ENTITY_TYPE_NODE type), the reference count of all entities it is
>> +connected to, both directly or indirectly, through active links is increased.
>> +This ensures that the whole media pipeline will be ready to process
>> +
>> +Acquiring a reference to an entity increases the media device module reference
>> +count to prevent module unloading when an entity is being used.
>> +
>> +media_entity_get will return a pointer to the entity if successful, or NULL
>> +otherwise.
>> +
>> +	media_entity_put(struct media_entity *entity)
>> +
>> +The function will decrease the entity reference count and, for node entities,
>> +like media_entity_get, the reference count of all connected entities. Calling
>> +media_entity_put with a NULL argument is valid and will return immediately.
>> +
>> +When the first reference to an entity is acquired, or the last reference
>> +released, the entity's set_power operation is called. Entity drivers must
>> +implement the operation if they need to perform any power management task,
>> +such as turning powers or clocks on or off. If no power management is
>> +required, drivers don't need to provide a set_power operation. The operation
>> +is allowed to fail when turning power on, in which case the media_entity_get
>> +function will return NULL.
> 
> The idea of doing power management via media entity get/put doesn't seem right.
> The mediabus interface and its usage should be optional, and only specialized
> applications will likely implement it. If a refcount 0 means power off, it ends
> that a device implementing the media bus will not work with V4L2 applications.

The Media controller does handle the power through reference count but
this does not limit to subdev entities. The reference count is also
applied recursively to all entities which are connected through active
links.

There are two cases:

1. The user application opens a subdev node. The subdev entity use count
will be incremented and the subdev will be powered up.

2. The user application opens a video node. The reference count for all
entities connected to the video node entity through active links will be
incremented. Subdevs will be powered up as well (if they are not already
because of (1) above). The same works if the entities connected through
a video node are connected to another entity and the link to that entity
is activated. In this case the use_counts of the entity sets are applied
across the both sets.

The user application does not need to use the Media controller interface
to get this functionality.

Another thing is that the user likely wants to use the device through
libv4l most likely, at least in the case of OMAP 3 ISP case. The link
configuration can be made by libv4l so that the regular V4L2
applications will work as expected.

>> +
>> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
>> index eeb002e..c309d3c 100644
>> --- a/drivers/media/media-device.c
>> +++ b/drivers/media/media-device.c
>> @@ -71,6 +71,7 @@ int __must_check media_device_register(struct media_device *mdev)
>>  	mdev->entity_id = 1;
>>  	INIT_LIST_HEAD(&mdev->entities);
>>  	spin_lock_init(&mdev->lock);
>> +	mutex_init(&mdev->graph_mutex);
>>  
>>  	/* Register the device node. */
>>  	mdev->devnode.fops = &media_device_fops;
>> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
>> index c277c18..da4fef6 100644
>> --- a/drivers/media/media-entity.c
>> +++ b/drivers/media/media-entity.c
>> @@ -21,6 +21,7 @@
>>  #include <linux/module.h>
>>  #include <linux/slab.h>
>>  #include <media/media-entity.h>
>> +#include <media/media-device.h>
>>  
>>  /**
>>   * media_entity_init - Initialize a media entity
>> @@ -194,6 +195,151 @@ media_entity_graph_walk_next(struct media_entity_graph *graph)
>>  EXPORT_SYMBOL_GPL(media_entity_graph_walk_next);
>>  
>>  /* -----------------------------------------------------------------------------
>> + * Power state handling
>> + */
>> +
>> +/* Apply use count to an entity. */
>> +static void media_entity_use_apply_one(struct media_entity *entity, int change)
>> +{
>> +	entity->use_count += change;
>> +	WARN_ON(entity->use_count < 0);
> 
> Instead of producing a warning, just deny it to have usage bellow zero. As this will
> be called from userspace, the entire interface should be reliable enough to avoid
> dumb applications to miss-use it.

This WARN_ON() always indicates a driver (or MC) bug. The entity
use_count should never be under 0, thus the warning.

The calls to this function should be always related to an open file
handle in a way or another. There is no direct user influence over this.

> Also: what happens if an userspace application dies or suffer any troubles? You
> need to reset all use_count's at release() callback.

Yes, this is true. media_entity_{get,put} should always be called when
file handles are open()ed or release()d.

I guess Laurent will correct me if required. :-)

Cheers,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
