Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49680 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751178AbdA0WDx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jan 2017 17:03:53 -0500
Date: Sat, 28 Jan 2017 00:02:53 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        hverkuil@xs4all.nl, Shuah Khan <shuah.kh@samsung.com>,
        Helen Koike <helen.koike@collabora.co.uk>
Subject: Re: [ANN] Media object lifetime management meeting report from Oslo
Message-ID: <20170127220252.GM7139@valkosipuli.retiisi.org.uk>
References: <20170127100822.GJ7139@valkosipuli.retiisi.org.uk>
 <20170127093831.6d1e7361@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170127093831.6d1e7361@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Obrigado for the comments! Please see my replies below.

On Fri, Jan 27, 2017 at 09:38:31AM -0200, Mauro Carvalho Chehab wrote:
> Hi Sakari/Hans/Laurent,
> 
> First of all, thanks for looking into those issues. Unfortunately, I was in
> vacations, and were not able to be with you there for such discussions.
> 
> While I have a somewhat different view on some of the introductory points of 
> this RFC, what really matters is the "proposal" part of it. So, based on the
> experiments I did when I addressed the hotplug issues with the media
> controller on USB drivers, I'm adding a few comments below.
> 
> 
> Em Fri, 27 Jan 2017 12:08:22 +0200
> Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> 
> > Allocating struct media_devnode separately from struct media_device
> > -------------------------------------------------------------------
> > 
> > The current codebase allocates struct media_devnode dynamically. This was
> > done in order to reduce the time window during which unallocated kernel
> > memory could be accessed. However, there is no specific need for such a
> > separation as the entire data structure, including the media device which
> > used to contain struct media_devnode, will have the same lifetime. Thus the
> > struct media_devnode should be allocated as part of struct media_device.
> > Later on, struct media_devnode may be merged with struct media_device if so
> > decided.
> 
> There is one issue merging struct media_devnode at struct media_device.
> The problem is that, if the same struct device is used for two different
> APIs (like V4L2 and media_controller) , e. g. if the cdev parent points
> to the same struct device, you may end by having a double free when the
> device is unregistered on the second core. That's basically why 
> currently struct cdev is at struct media_devnode: this way, it has its own
> struct device.

One of the conclusions of the memorandum I wrote is that the data structures
that are involved in executing a system call (including IOCTLs) must stay
intact during that system call. (Well, the alternative I can think of is
using an rw_semaphore but I certainly do not advocate that solution.)

Otherwise, we will continue to have serialisation issues: kernel memory that
may be released at any point of time independently of a system call in
progress:

<URL:https://www.mail-archive.com/linux-media@vger.kernel.org/msg106390.html>

That one is a NULL pointer dereference but released kernel memory can be
accessed as well.

> 
> IMHO, it also makes sense to embeed struct cdev at the V4L2 side, as I
> detected some race issues at the V4L2 side when I ran the bind/unbind
> race tests, when we tried to merge the snd-usb-audio MC support patch.
> I remember Shuah reported something similar on that time.
> 
> > Allocating struct media_device dynamically
> > ------------------------------------------
> > 
> > Traditionally the media device has been allocated as part of drivers' own
> > structures. This is certainly fine as such, but many drivers have allocated
> > the driver private struct using the devm_() family of functions. This causes
> > such memory to be released at the time of device removal rather than at the
> > time when the memory is no longer accessible by e.g. user space processes or
> > interrupt handlers. Besides the media device, the driver's own data
> > structure is very likely to have the precisely same lifetime issue: it may
> > also be accessed through IOCTLs after the device has been removed from the
> > system.
> > 
> > Instead, the memory needs to be released as part of the release() callback
> > of the media device which is called when the last reference to the media
> > device is gone. Still, allocating the media device outside another
> > containing driver specific struct will be required in some cases: sharing
> > the media device mandates that. Implementing this can certainly be postponed
> > until sharing the media device is otherwise supported as well.
> 
> The patches adding MC support for snd-usb-audio, pending since Kernel
> 4.7 (I guess) require such functionatilty. Last year, on the audio
> summit, they asked about its status, as they're needing MC suppor there.
> 
> So, whatever solution taken, this should be part of the solution.
> 
> (c/c Shuah, as she is the one working on it)

I think we should postpone that, or at least resolve that in a separate
patchset. This is already getting very big. The refcounting problems will be
harder to fix, should we extend the MC framework with media device sharing
without considering the object lifetime issues first. So the order should
be: first fix object lifetime issues, then add more features.

Matters unrelated to the object lifetime issues such as the device (driver)
specific fields in struct media_device need to be addressed before support
for sharing the media device can be implemented. That work can be done
independently of fixing the object lifetime issues.

Implemeting media device sharing correctly will also be easier after
the media device is refcounted: the object lifetime issues with a shared
media device are resolvable (and likely very easily so).

> 
> > Lifetime of the media entities and related framework or driver objects
> > ======================================================================
> > 
> > The media graph data structure is a complex data structure consisting of
> > media graph objects that themselves may be either entities, links or pads.
> > The media graph objects are allocated by various drivers and currently have
> > a lifetime related to binding and unbinding of the related hardware. The
> > current rules (i.e. acquiring the media graph lock for graph traversal) are
> > not enough to properly support removing entities.
> > 
> > Instead, reference counting needs to be introduced for media entities and
> > other objects that contain media entities. References must be acquired (or
> > in some cases, borrowed) whenever a reference is held to an object. A
> > release callback is used to release the memory allocation that contains an
> > object when the last reference to the object has been put. For instance:
> > 
> > 	struct media_entity {
> > 		...
> > 		struct kref kref;
> > 		void (*release)(struct media_entity *entity);
> > 	};
> 
> The similar rationale is valid also for media interfaces and, on a
> lesser extent, to pads and links.
> 
> So, instead, IMHO, the kref should be implemented at struct media_gobj,
> with is inherited by all graph elements. I guess that handling it
> there will avoid us to duplicate the same logic on different
> places (e. g. interface and entity logic handling; links handling).

I don't argue against doing that in principle, but my question is: is there
a need for that? Does a driver (or a framework) need to be able to hold a
link, a pad, for instance? In the proposal, acquiring the media entity would
be practically enough to hold the pads (albeit that would have to be
documented), or we could add functions for that that would be wrappers to
media_entity_get() and so on:

void media_pad_get(struct media_pad *pad)
{
	media_entity_get(pad->entity);
}

The lifetime of the graph objects are dependent of each other in any cases;
you can't have pads having significantly different lifetime than the entity
they belong to. Typically such a case is related to making sure structs stay
around as long as something may still access them in a case when graph
objects are being removed.

> 
> Btw, as you want to use OMAP3 as a reference driver, you should
> implement interface and interface links there, in order to have a
> broader testcase coverage, or use some other driver that already
> implements it.
> 
> Alternatively, we should work on merging the Helen's vimc driver, being
> sure that it provides hot plug support for all kinds of media graph
> objects. It should be easier/faster to detect race issues on such a driver
> that doesn't depend on a hardware to complete their operations. So,
> I'm a big fan on using it as primary testcase. Of course, we'll need to
> test with real drivers too.

The vimc driver looks pretty good in my opinion; it could be merged after
addressing the comments. I wrote quite a few comments to the patchset but
AFAIR all the matters are minor.

I see no reason why we shouldn't implement these fixes for both of the two
drivers. My understanding is that the driver changes due to refcounting will
be relatively minor after all. It's the framework changes that will be
harder.

> 	
> > 	/*
> > 	 * For refcounting, the caller has to set entity->release after
> > 	 * initialising the entity.
> > 	 */
> > 	void media_entity_pads_init(struct media_entity *entity)
> > 	{
> > 		...
> > 		kref_init(&entity->kref);
> > 	}
> > 	
> > 	int media_device_register_entity(struct media_device *mdev,
> > 					 struct media_entity *entity)
> > 	{
> > 		...
> > 		entity->graph_obj.mdev = mdev;
> > 	}
> > 	
> > 	void media_entity_release(struct kref *kref)
> > 	{
> > 		struct media_entity *entity =
> > 			container_of(kref, struct media_entity, kref);
> > 		struct media_device *mdev = entity->graph_obj.mdev;
> > 		
> > 		entity->release(entity);
> > 		if (mdev)
> > 			media_device_put(mdev);
> > 	}
> > 	
> > 	void media_entity_put(struct media_entity *entity)
> > 	{
> > 		kref_put(&entity->kref, media_entity_release);
> > 	}
> > 
> > 	void media_entity_get(struct media_entity *entity)
> > 	{
> > 		kref_get(&entity->kref);
> > 	}
> > 	
> > The above takes into account the current behaviour which makes no use of
> > reference counting while still allowing reference counting for drivers that
> > use it.
> > 
> > Often media entities are contained in another struct such as struct
> > v4l2_subdev. In that case, the allocator of that struct must provide a
> > release callback which is used as a destructor of that object. Functions to
> > count references (get() and put()) are defined to obtain and released
> > references to the said objects. Wrappers are added for the types containing
> > the object type that does have the refcount, for instance in this case:
> > 
> > 	void v4l2_subdev_get(struct v4l2_subdev *sd)
> > 	{
> > 		media_entity_get(&sd->entity);
> > 	}
> > 
> > 	void v4l2_subdev_put(struct v4l2_subdev *sd)
> > 	{
> > 		media_entity_put(&sd->entity);
> > 	}
> > 
> > Memory allocations that contain one or more objects must be considered
> > indivisible. All the objects inside a struct are allocated and released at
> > one point of time. For instance, struct v4l2_subdev contains both struct
> > media_entity and struct video_device. struct video_device contains struct
> > device (related to the character device visible to the user) that is
> > reference counted already.
> 
> Here's the problem: if we point the media_devnode's cdev parent to
> the same object as struct video_device, both cores will try to
> decrement its kref at release() time.

At the time of registering a struct video_device with the struct
media_device, the underlying refcount (struct
media_device.devnode.dev.kobj.kref) needs to be incremented. This needs to
done using media_device_get(), with (a) few layers of abstraction.

This guarantees that the struct media_device will stick around at least as
long as the struct video_device.

The struct video_device cdev arrangement differs from what's being done in
the CEC framework and elsewhere; that should be fixed I guess. Still, the
struct media_device reference should be put in v4l2_device_release() (the
release callback of the struct device corresponding to the device node,
struct video_device.dev.release).

> 
> > 
> > In the example below, foo is a sub-device driver. The struct foo_device
> > contains a struct v4l2_subdev field sd which in turn contains a media
> > entity. In addition to that, struct v4l2_subdev contains a struct
> > video_device (the devnode field) that currently is a pointer. In order to
> > simplify the reference counting, it is assumed to be directly a part of the
> > struct v4l2_subdev below. The example assumes that the driver requests a
> > device node for the V4L2 sub-device and does not address the case where the
> > device node is not created.
> > 
> > 
> > 	struct media_entity {
> > 		...
> > 		struct kref kref;
> > 		void (*release)(struct media_entity *entity);
> > 	};
> > 	
> > 	struct v4l2_subdev {
> > 		...
> > 		struct video_device devnode;
> > 	};
> > 
> > 	void media_entity_release(struct kref *kref)
> > 	{
> > 		struct media_entity *entity =
> > 			container_of(kref, struct media_entity, kref);
> > 		struct media_device *mdev = entity->graph_obj.mdev;
> > 		
> > 		/* Release the media entity, possibly releasing its memory. */
> > 		entity->release(entity);
> > 
> > 		/*
> > 		 * If it was bound to a media device, put the media device
> > 		 * as well.
> > 		 */
> > 		if (mdev)
> > 			media_device_put(mdev);
> > 	}
> > 	
> > 	void media_entity_put(struct media_entity *entity)
> > 	{
> > 		kref_put(&entity->kref, media_entity_release);
> > 	}
> > 
> > 	/*
> > 	 * Returns zero if getting entity succeeds, -ENODEV otherwise.
> > 	 */
> > 	int media_entity_try_get(struct media_entity *entity)
> > 	{
> > 		return kref_get_unless_zero(&entity->kref) ? 0 : -ENODEV;
> > 	}
> > 
> > 	void media_entity_get(struct media_entity *entity)
> > 	{
> > 		kref_get(&entity->kref);
> > 	}
> > 	
> > 	/*
> > 	 * Depending on the data structure containing the media entity, the
> > 	 * caller has to set entity->release after initialising the entity.
> > 	 */
> > 	void media_entity_pads_init(struct media_entity *entity)
> > 	{
> > 		...
> > 		kref_init(&entity->kref);
> > 	}
> > 	
> > 	int media_device_register_entity(struct media_device *mdev,
> > 					 struct media_entity *entity)
> > 	{
> > 		...
> > 		/*
> > 		 * Bind the media entity to the media device; thus increment
> > 		 * media device refcount. The media device typically is not
> > 		 * available during sub-device driver probe() time. This
> > 		 * requires that a media entity may only be registered once.
> > 		 */
> > 		entity->graph_obj.mdev = mdev;
> > 		media_device_get(mdev);
> > 		/* And get the entity as well. */
> > 		media_entity_get(entity);
> > 	}
> > 	
> > 	
> > 	void media_device_unregister_entity(struct media_entity *entity)
> > 	{
> > 		...
> > 		media_entity_put(entity);
> > 	}
> > 
> > 	int v4l2_device_register_subdev(struct v4l2_subdev *sd)
> > 	{
> > 		...
> > 		media_device_register_entity(&sd->entity);
> > 		...
> > 	}
> > 	
> > 	void v4l2_device_unregister_subdev(struct v4l2_subdev *sd)
> > 	{
> > 		...
> > 		media_device_unregister_entity(&sd->entity);
> > 	}
> > 
> > 	/*
> > 	 * Custom release callback function for V4L2 sub-devices that export
> > 	 * a device node. (Could be used for others as well, with
> > 	 * sd->devnode.release() callback.)
> > 	 */
> > 	void v4l2_device_subdev_devnode_release(struct media_entity *entity)
> > 	{
> > 		struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
> > 
> > 		/*
> > 		 * If the devnode got registered we still hold a reference
> > 		 * to it. Check this from vdev->prio (but any other field
> > 		 * which gets set during device node registration and never
> > 		 * changed again could be used). If the devnode was never
> > 		 * registered, call its release function directly.
> > 		 */
> > 		if (sd->devnode.prio)
> > 			video_put(sd->devnode);
> > 		else
> > 			sd->devnode.release(&sd->devnode);
> > 	}
> > 	
> > 	int v4l2_device_register_subdev_nodes(struct v4l2_device *vdev)
> > 	{
> > 		struct video_device *vdev;
> >  	        struct v4l2_subdev *sd;
> > 	        int err;
> > 
> > 	        list_for_each_entry(sd, &v4l2_dev->subdevs, list) {
> > 			__video_register_device(&sd->devnode, ...);
> > 			video_get(&sd->devnode);
> > 			sd->devnode.prio = something non-NULL;
> > 		}
> > 	}
> > 	
> > 	int v4l2_subdev_try_get(struct v4l2_subdev *sd)
> > 	{
> > 		return media_entity_try_get(&sd->entity);
> > 	}
> > 
> > 	void v4l2_subdev_get(struct v4l2_subdev *sd)
> > 	{
> > 		media_entity_get(&sd->entity);
> > 	}
> > 
> > 	void v4l2_subdev_put(struct v4l2_subdev *sd)
> > 	{
> > 		media_entity_put(&sd->entity);
> > 	}
> > 
> > 	/* V4L2 sub-device open file operation handler */	
> > 	int subdev_open(struct file *file)
> > 	{
> > 		struct video_device *vdev = video_devdata(file);
> > 		struct v4l2_subdev *sd = vdev_to_v4l2_subdev(vdev);
> > 		int rval;
> > 		
> > 		/*
> > 		 * The v4l2_subdev depends on the video device node. It thus
> > 		 * may be that the media entity refcount (which is also used
> > 		 * to count references to the v4l2_subdev) has reached zero
> > 		 * here. However its memory is still intact as it's part of
> > 		 * the same struct v4l2_subdev.
> > 		 */
> > 		rval = v4l2_subdev_try_get(sd);
> > 		if (rval)
> > 			return rval;
> > 		
> > 		...
> > 	}
> > 	
> > 	/* V4L2 sub-device release file operation handler */
> > 	int subdev_close(struct file *file)
> > 	{
> > 		struct video_device *vdev = video_devdata(file);
> > 		struct v4l2_subdev *sd = vdev_to_v4l2_subdev(vdev);
> > 
> > 		v4l2_subdev_put(sd);
> > 	}
> > 
> > 	struct foo_device {
> > 		struct v4l2_subdev sd;
> > 		struct media_pad pad;
> > 	};
> > 
> > 	void foo_device_release(struct video_device *vdev)
> > 	{
> > 		struct v4l2_subdev *sd =
> > 			container_of(vdev, struct v4l2_subdev, devnode);
> > 		struct foo_device *foo =
> > 			container_of(sd, struct foo_device, sd);
> > 
> > 		/*
> > 		 * TODO: acquire the graph mutex here and remove the
> > 		 * entities corresponding to the V4L2 sub-device and its
> > 		 * device node from the graph.
> > 		 */
> > 		media_entity_cleanup(&foo->sd.entity);
> > 		
> > 		kfree(foo);
> > 	}
> > 
> > 	int foo_probe(struct device *dev)
> > 	{
> > 		struct foo_device *foo = kmalloc(sizeof(*foo), GFP_KERNEL));
> > 
> > 		media_entity_pads_init(&foo->sd.entity, 1, &foo->pad);
> > 		foo->sd.entity.release = v4l2_subdev_devnode_release;
> > 		foo->sd.devnode.release = foo_device_release;
> > 		v4l2_async_register_subdev(&foo->sd);
> > 	}
> > 
> > 	void foo_remove(struct device *dev)
> > 	{
> > 		struct foo_device *foo = dev_get_drvdata(dev);
> > 		
> > 		v4l2_async_unregister_subdev(&foo->sd);
> > 		v4l2_device_unregister_subdev(&foo->sd);
> > 		/*
> > 		 * v4l2_subdev_put() will end up releasing foo immediately
> > 		 * unless file handles are open currently. Thus further
> > 		 * accesses to foo are not allowed.
> > 		 */
> > 		v4l2_subdev_put(&foo->sd);
> > 	}
> > 	
> > Practical considerations
> > ------------------------
> > 
> > - Beyond media entities, other media graph objects could be made refcounted.
> >   This is not seen necessary as the related objects such as pads are in
> >   practice allocated within the same driver specific struct containing the
> >   media entity.
> 
> As I mentioned already, you're forgetting about the media interfaces, with 
> are created/removed elsewhere as they're (somewhat) independent of the media
> entities.

Right. Nothing prevents adding a kref to struct media_interface. It'd work
the same way than with media entities. Interface-wise, the refcounting
should use _get()/_put() functions of the native types independently of
where the kref refcount is located. (Obviously this requires that it has to
be in the same memory allocation. For instance, v4l2_subdev's depending on
kref in struct media_entity in the example.)

Having to do add kref to struct media_interface, though, does increase the
appeal of adding kref to each graph object instead. Still, my hunch is that
this would be vastly overkill: the other graph objects we have are very
tightly bound to entities (and media interfaces). I can't see a use case for
them right now other than than just walking the graph. That said, I'm
certainly open for new ideas and information that could probe me wrong.

> 
> > 
> > 	- This does not apply to links which are allocated dynamically by
> > 	  the framework, and released at unregistration time, meaning that
> > 	  accessing a link will require holding the media graph mutex.
> 
> If we're moving to refcounts, then perhaps we can get rid of the
> graph mutex or reduce its usage.

It'll be a lot easier to get rid of the graph mutex, I agree. Only the graph
walk will depend on holding the graph mutex then, and it's much easier to
address the serialisation needs in that use case only. The solution will
still be non-trivial as it's likely to require wait/wound mutexes: the graph
walk can well start at two locations of a graph simultanoeously and two
walkers may thus try to parse the same graph nodes. One of them needs to
back away in that case. This is something that needs to be managed in the
users of the graph walk API.

> 
> > 
> > - A custom release callback is to be used for refcounted framework
> >   structs. This makes it easy for the drivers to embed the objects in their
> >   own structs.
> > 
> > - As long as an object has its own reference count, getting or putting an
> >   object does not affect the refcount of another object that it depends on.
> >   For instance, a media entity depends on an existence of the media
> >   device.
> > 
> > - Each media entity holds a reference to the media device. Being able to
> >   navigate from the media entity to the media device is used in drivers and
> >   an abrupt disconnection of the two is problematic to handle for drivers.
> > 
> > - At object initialisation time the kref refcount is initialised. The object
> >   is put at unregistration time.
> >   
> >   	- If the object is a media entity, it is removed from the media graph
> >  	  when the last reference to the media entity is gone. The release
> >  	  callback needs to acquire the media graph mutex in order to
> >  	  perform the removal.
> > 
> > 	- In particular for struct video_device, media_entity release callback will
> > 	  put the refcount of the video device (struct device embedded in
> > 	  struct video_device)
> > 
> > 	- For struct v4l2_subdev, struct media_entity contained in struct
> > 	  v4l2_subdev is dependent on struct device within struct
> > 	  video_device.
> > 
> > - When a driver creates multiple reference-counted objects (such as multiple
> >   media entities for instance) that are part of its own private struct, it
> >   will need to reference-count its own struct based on the release callbacks
> >   of all those objects. It might be possible to simplify this by providing a
> >   single release callback that would cover all objects. This is already
> >   feasible for drivers that implement a media_device instance, V4L2
> >   sub-devices and V4L2 video devices hold a reference on the media_device,
> >   whose release callback could then act as a single gatekeeper. For other
> >   drivers we haven't explored yet whether the core could meaningfully
> >   provide help, but it should be remembered that drivers that implement
> >   multiple graph objects and that do not implement a media_device are not
> >   legion. Most slave drivers (such as sensor drivers) only implement a
> >   single v4l2_subdev.
> > 
> > - No V4L2 sub-device driver currently supports unbinding the device safely
> >   when a media entity (or V4L2 sub-device) is registered. Prevent manual
> >   unbind for all sub-device drivers by setting the suppress_bind_attrs field
> >   in struct device_driver.
> > 
> > 
> > Rules for navigating the media graph and accessing graph objects
> > ================================================================
> > 
> > - Graph traversal is safe as long as the media graph lock is held during
> >   traversal. (I.e. no changes here.)
> > 
> > 	- During graph traversal entity refcount must be increased in order
> > 	  to prevent them from being released. As the media entity's release()
> > 	  callback may be already in process at this point, a variant
> > 	  checking that the reference count has not reached zero must be
> > 	  used (media_entity_get_try()).
> > 
> > - In order to keep a reference to an object after the graph traversal has
> >   finished, a reference to the object must be obtained and held as long as
> >   the object is in use.
> > 
> > 	- The same applies to file handles to V4L2 sub-devices or drivers
> > 	  keeping a reference to another driver's sub-device.
> > 
> > - Once the reference count of an object reaches zero it will not be
> >   increased again, even if that object was part of a memory allocation which
> >   still has referenced objects. Obtaining references to such an object must
> >   fail.
> > 
> > - Navigating within a memory allocation while holding a reference to an
> >   object in that allocation to obtain another object is allowed. The target
> >   object type must provide a function testing for zero references in order
> >   not to not to increment reference count that has reached zero.
> >   kref_get_unless_zero() can be used for this. Especially drivers may need
> >   this.
> > 
> > - Circular references are not allowed.
> > 
> > - It is safe to move between objects of the same lifetime (same kref),
> >   e.g. struct v4l2_subdev and struct media_entity it contains.
> > 
> > The rules must be documented as part of the Media framework ReST
> > documentation.
> > 
> > 
> > Stopping the hardware safely at device unbind
> > =============================================
> > 
> > What typically gets little attention in driver implementation is stopping
> > safely whenever the hardware is being removed. The kernel frameworks are not
> > very helpful in this respect --- after all how this is done somewhat depends
> > on the hardware. Only hot-pluggable devices are generally affected. While it
> > is possible to manually unbind e.g. platform devices, that certainly is a
> > lesser problem for such devices.
> > 
> > The rules are:
> > 
> > - No memory related to data structures that are needed during driver
> >   operation can be released as long as interrupt handlers may be still
> >   executing or may start executing or user file handles are open.
> > 
> > - All hardware access must cease after the remove() callback in driver ops
> >   struct has returned. (For USB devices this callback is called
> >   disconnect(), but its purpose is precisely the same.)
> > 
> > Handling this correctly will require taking care of a few common matters:
> > 
> > 1. Checking for device presence in each system call issued on a device, and
> >    returning -ENODEV if the device is not found.
> > 
> > 2. The driver's remove() function must ensure that no system calls that
> >    could result in hardware access are ongoing.
> >    
> > 3. Some system calls may sleep, and while doing so also releasing and later
> >    reacquiring (when they continue) the mutexes their processes were
> >    holding. Such processes must be woken up.
> > 
> > This is not an easy task for a driver and the V4L2 and Media controller
> > frameworks need to help the drivers to achieve this so that drivers would
> > need to worry about this as little as possible. Drivers relying for their
> > locking needs on the videobuf2 and the V4L2 frameworks are likely to require
> > fewer changes.
> > 
> > The same approach must be taken in issuing V4L2 sub-device operations by
> > other kernel drivers.
> > 
> > 
> > Serialising unbind with hardware access through system calls
> > ------------------------------------------------------------
> > 
> > What's below is concentrated in V4L2; Media controller will need similar
> > changes.
> > 
> > - Add a function called video_unregister_device_prepare() (or
> >   video_device_mark_unregistered() or a similarly named function) to amend
> >   the functionality of video_unregister_device(): mark the device
> >   unregistering so that new system calls issues on the device will return an
> >   error.
> > 
> > - Device node specific use count for active system calls.
> > 
> > - Waiting list for waiting for the use count to reach zero (for proceeding
> >   unregistration in v4l2_unregister_device()). Each finishing system call on
> >   a file descriptor will wake up the waiting list.
> > 
> > - Processes waiting in a waiting list of a system call (e.g. poll, DQBUF
> >   IOCTL) will be woken up. After waiting, the processes will check whether
> >   the video node is still registered, i.e. video_unregister_device_prepare()
> >   has not been called.
> > 
> > 
> > Things to remember
> > ------------------
> > 
> > - Using the devm_request_irq() is _NOT_ allowed in general case, as the
> >   free_irq() results in being called _after_ the driver's release callback.
> >   This means that if new interrupts still arrive between driver's release
> >   callback returning and devres resources not being released, the driver's
> >   interrupt handler will still run. Use request_irq() and free_irq()
> >   instead.
> > 
> > 
> > What changes in practice?
> > =========================
> > 
> > Most of the changes needed in order to align the current implementation to
> > conform the above are to be made in the frameworks themselves. What changes
> > in drivers, though, is how objects are initialised and released. This mostly
> > applies to drivers' own data structures that often contain reference counted
> > object types from the frameworks.
> > 
> > Relations between various frameworks objects will need to be handled in a
> > standard way in the appropriate registeration, unregistration and reference
> > getting and putting functions. Drivers (as well as frameworks, such as the
> > V4L2 sub-device framework in its open and close file operations) will make
> > use of these functions to get an put references to the said objects.
> > 
> > Drivers that are not hot-pluggable could largely ignore the changes, as
> > unregistering an object does in fact take place right before releasing that
> > object, meaning drivers that did not perform any object reference counting
> > are no more broken with the changes described above without implementing
> > reference counting. Still care must be taken that they remain decently
> > unloadable when there are no users.
> > 
> > New drivers should be required to implement object reference counting
> > correctly, whether hot-pluggable or not. One platform driver (e.g. omap3isp)
> > should be fixed to function as a model for new platform drivers.
> > 
> 
> Thanks,
> Mauro

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
