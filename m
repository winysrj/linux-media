Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59168 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932443AbdA0KJD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jan 2017 05:09:03 -0500
Date: Fri, 27 Jan 2017 12:08:22 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
        mchehab@s-opensource.com
Subject: [ANN] Media object lifetime management meeting report from Oslo
Message-ID: <20170127100822.GJ7139@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everyone,

Please read below my report on resolving object lifetime issues in V4L2 and
Media controller frameworks. The document is rather long but worth reading if
you're interested in the topic.


Sakari Ailus, Laurent Pinchart and Hans Verkuil present
2016-01-13


Introduction to the problem domain
==================================

The Media controller framework was first used for complex devices with
internal data processing pipelines. The problem domain that got most of the
attention as how the pipeline configuration would work and how V4L2
sub-device format would be propagated or how the pipeline validation would
work. As none of the devices that were supported in the beginning were
hot-pluggable, little attention was paid in making it possible to remove
them.

The media graph is a complex, highly interconnected data structure with
object allocated by different drivers and with different lifetimes. The data
structure can be navigated by the Media controller framework and by drivers,
including parts that those drivers did not create themselves. While some
rules exist on how this could be done, for instance the graph traversal,
these rules are not enough to support new use cases such as hot-pluggable
devices (or safely unbinding devices in general).

In the original (and also the current) implementation of the Media
controller framework tearing down a Media device was centered in the ability
of removing devices without crashing the kernel while the said devices were
not in use by a user application. In order to prevent unbinding drivers,
module use counts are increased whilst the devices are in use. This
obviously does not guarantee that: hot-pluggable devices may be removed
without the user application even knowing it, as well as non-hotpluggable
devices may also be unbound even if the module stays loaded (of which the
latter is certainly a lesser concern).


Current and future issues
=========================

* Media device lifetime management. There is no serialisation between
  issuing system calls to the media device driver and removing the struct
  media_device from the system, typically through unbinding a device from
  the driver. This leaves a time window in which released kernel memory may
  be accessed.

* Media entity lifetime management (including driver allocated objects that
  can be reached through media graph objects). Media entities (and objects
  that embed media graph objects) may be looked up by drivers and
  referenced. Such references may be kept for an extended period of time.
  Sub-device drivers may call other sub-devices' operations as well as they
  may be accessed from the user space through file handles. Media entity
  lifetime management is required for safely removing them.

* Sharing a struct media_device between drivers. This is not a problem right
  now but will need to be addressed before a struct media_device may be
  shared between multiple drivers. Currently, the struct media_device has
  multiple fields that are specific to a single driver which inherently
  makes a media device non-shareable:

	- dev: struct device of the bridge/ISP driver
	- ops: ops structure that contains e.g. link_setup used for managing
	  power across the pipelines found in a media device. In the future,
	  this would include routing configuration as well.

  The functionality supported by these fields has to be implemented by means
  supporting multiple drivers before sharing the struct media_device is
  possible. In that solution, these fields may not continue to exist in the
  form they do now.


General rules for accessing data and running code
=================================================

These rules must be followed in accessing data and executing code in all
cases:

code) While there is a chance to execute code, the containing module
  reference count must be incremented.

data) Every memory allocation must be reference counted if a pointer to
  that memory is being shared. Each user obtains a reference and puts it
  using a related put function which will release the memory if it was the
  last reference.


Object reference counting golden rules
======================================

1. When a pointer to a reference-counted object is stored for later use, a
   reference to that object must exist.

2. A reference exists if it is taken or borrowed.

3. A borrowed reference is a reference taken elsewhere that can be proven to
   exist for the complete lifetime of the pointer.

4. When in doubt about whether a reference can be borrowed, it can be taken
   without any adverse impact.

5. A reference taken must be put at some point.

6. No access to a pointer can occur after the corresponding reference has
   been put.

	6.1. The point when the reference is put must be proven to occur
	     later than all other possible accesses to the reference.

	6.2. At the location where the reference is put, care must be taken
	     not to access the corresponding pointer after putting the
	     reference.

	     e.g.

	     object_put(obj);
	     obj->dead = true;

	     is invalid, the correct code would be

	     obj->dead = true;
	     object_put(obj);

7. Immediately set a reference to NULL before or right after putting a
   given reference. This helps catching use-after-release errors.


Media device lifetime
=====================


IOCTLs and removal
------------------

There is a choice to be made related to the approach used to ensure that the
media device itself will stay around as long as it is needed. This can be
done by referencing the media device, in which case the media device memory
will be released once all the users are done with the media device. An
alternative to this is to use locking, taking a lock during an IOCTL call
and during device removal. rw_semaphores could potentially be used for this
purpose, but they are hardly meant for such use.

The rest of the kernel generally uses reference counting to address such
issues. Besides this, sharing the media device later on will require using
reference, so it is certainly more future-proof as well as being a generally
known-good solution.

The media device thus needs to be reference counted.


Allocating struct media_devnode separately from struct media_device
-------------------------------------------------------------------

The current codebase allocates struct media_devnode dynamically. This was
done in order to reduce the time window during which unallocated kernel
memory could be accessed. However, there is no specific need for such a
separation as the entire data structure, including the media device which
used to contain struct media_devnode, will have the same lifetime. Thus the
struct media_devnode should be allocated as part of struct media_device.
Later on, struct media_devnode may be merged with struct media_device if so
decided.


Allocating struct media_device dynamically
------------------------------------------

Traditionally the media device has been allocated as part of drivers' own
structures. This is certainly fine as such, but many drivers have allocated
the driver private struct using the devm_() family of functions. This causes
such memory to be released at the time of device removal rather than at the
time when the memory is no longer accessible by e.g. user space processes or
interrupt handlers. Besides the media device, the driver's own data
structure is very likely to have the precisely same lifetime issue: it may
also be accessed through IOCTLs after the device has been removed from the
system.

Instead, the memory needs to be released as part of the release() callback
of the media device which is called when the last reference to the media
device is gone. Still, allocating the media device outside another
containing driver specific struct will be required in some cases: sharing
the media device mandates that. Implementing this can certainly be postponed
until sharing the media device is otherwise supported as well.


Lifetime of the media entities and related framework or driver objects
======================================================================

The media graph data structure is a complex data structure consisting of
media graph objects that themselves may be either entities, links or pads.
The media graph objects are allocated by various drivers and currently have
a lifetime related to binding and unbinding of the related hardware. The
current rules (i.e. acquiring the media graph lock for graph traversal) are
not enough to properly support removing entities.

Instead, reference counting needs to be introduced for media entities and
other objects that contain media entities. References must be acquired (or
in some cases, borrowed) whenever a reference is held to an object. A
release callback is used to release the memory allocation that contains an
object when the last reference to the object has been put. For instance:

	struct media_entity {
		...
		struct kref kref;
		void (*release)(struct media_entity *entity);
	};
	
	/*
	 * For refcounting, the caller has to set entity->release after
	 * initialising the entity.
	 */
	void media_entity_pads_init(struct media_entity *entity)
	{
		...
		kref_init(&entity->kref);
	}
	
	int media_device_register_entity(struct media_device *mdev,
					 struct media_entity *entity)
	{
		...
		entity->graph_obj.mdev = mdev;
	}
	
	void media_entity_release(struct kref *kref)
	{
		struct media_entity *entity =
			container_of(kref, struct media_entity, kref);
		struct media_device *mdev = entity->graph_obj.mdev;
		
		entity->release(entity);
		if (mdev)
			media_device_put(mdev);
	}
	
	void media_entity_put(struct media_entity *entity)
	{
		kref_put(&entity->kref, media_entity_release);
	}

	void media_entity_get(struct media_entity *entity)
	{
		kref_get(&entity->kref);
	}
	
The above takes into account the current behaviour which makes no use of
reference counting while still allowing reference counting for drivers that
use it.

Often media entities are contained in another struct such as struct
v4l2_subdev. In that case, the allocator of that struct must provide a
release callback which is used as a destructor of that object. Functions to
count references (get() and put()) are defined to obtain and released
references to the said objects. Wrappers are added for the types containing
the object type that does have the refcount, for instance in this case:

	void v4l2_subdev_get(struct v4l2_subdev *sd)
	{
		media_entity_get(&sd->entity);
	}

	void v4l2_subdev_put(struct v4l2_subdev *sd)
	{
		media_entity_put(&sd->entity);
	}

Memory allocations that contain one or more objects must be considered
indivisible. All the objects inside a struct are allocated and released at
one point of time. For instance, struct v4l2_subdev contains both struct
media_entity and struct video_device. struct video_device contains struct
device (related to the character device visible to the user) that is
reference counted already.

In the example below, foo is a sub-device driver. The struct foo_device
contains a struct v4l2_subdev field sd which in turn contains a media
entity. In addition to that, struct v4l2_subdev contains a struct
video_device (the devnode field) that currently is a pointer. In order to
simplify the reference counting, it is assumed to be directly a part of the
struct v4l2_subdev below. The example assumes that the driver requests a
device node for the V4L2 sub-device and does not address the case where the
device node is not created.


	struct media_entity {
		...
		struct kref kref;
		void (*release)(struct media_entity *entity);
	};
	
	struct v4l2_subdev {
		...
		struct video_device devnode;
	};

	void media_entity_release(struct kref *kref)
	{
		struct media_entity *entity =
			container_of(kref, struct media_entity, kref);
		struct media_device *mdev = entity->graph_obj.mdev;
		
		/* Release the media entity, possibly releasing its memory. */
		entity->release(entity);

		/*
		 * If it was bound to a media device, put the media device
		 * as well.
		 */
		if (mdev)
			media_device_put(mdev);
	}
	
	void media_entity_put(struct media_entity *entity)
	{
		kref_put(&entity->kref, media_entity_release);
	}

	/*
	 * Returns zero if getting entity succeeds, -ENODEV otherwise.
	 */
	int media_entity_try_get(struct media_entity *entity)
	{
		return kref_get_unless_zero(&entity->kref) ? 0 : -ENODEV;
	}

	void media_entity_get(struct media_entity *entity)
	{
		kref_get(&entity->kref);
	}
	
	/*
	 * Depending on the data structure containing the media entity, the
	 * caller has to set entity->release after initialising the entity.
	 */
	void media_entity_pads_init(struct media_entity *entity)
	{
		...
		kref_init(&entity->kref);
	}
	
	int media_device_register_entity(struct media_device *mdev,
					 struct media_entity *entity)
	{
		...
		/*
		 * Bind the media entity to the media device; thus increment
		 * media device refcount. The media device typically is not
		 * available during sub-device driver probe() time. This
		 * requires that a media entity may only be registered once.
		 */
		entity->graph_obj.mdev = mdev;
		media_device_get(mdev);
		/* And get the entity as well. */
		media_entity_get(entity);
	}
	
	
	void media_device_unregister_entity(struct media_entity *entity)
	{
		...
		media_entity_put(entity);
	}

	int v4l2_device_register_subdev(struct v4l2_subdev *sd)
	{
		...
		media_device_register_entity(&sd->entity);
		...
	}
	
	void v4l2_device_unregister_subdev(struct v4l2_subdev *sd)
	{
		...
		media_device_unregister_entity(&sd->entity);
	}

	/*
	 * Custom release callback function for V4L2 sub-devices that export
	 * a device node. (Could be used for others as well, with
	 * sd->devnode.release() callback.)
	 */
	void v4l2_device_subdev_devnode_release(struct media_entity *entity)
	{
		struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);

		/*
		 * If the devnode got registered we still hold a reference
		 * to it. Check this from vdev->prio (but any other field
		 * which gets set during device node registration and never
		 * changed again could be used). If the devnode was never
		 * registered, call its release function directly.
		 */
		if (sd->devnode.prio)
			video_put(sd->devnode);
		else
			sd->devnode.release(&sd->devnode);
	}
	
	int v4l2_device_register_subdev_nodes(struct v4l2_device *vdev)
	{
		struct video_device *vdev;
 	        struct v4l2_subdev *sd;
	        int err;

	        list_for_each_entry(sd, &v4l2_dev->subdevs, list) {
			__video_register_device(&sd->devnode, ...);
			video_get(&sd->devnode);
			sd->devnode.prio = something non-NULL;
		}
	}
	
	int v4l2_subdev_try_get(struct v4l2_subdev *sd)
	{
		return media_entity_try_get(&sd->entity);
	}

	void v4l2_subdev_get(struct v4l2_subdev *sd)
	{
		media_entity_get(&sd->entity);
	}

	void v4l2_subdev_put(struct v4l2_subdev *sd)
	{
		media_entity_put(&sd->entity);
	}

	/* V4L2 sub-device open file operation handler */	
	int subdev_open(struct file *file)
	{
		struct video_device *vdev = video_devdata(file);
		struct v4l2_subdev *sd = vdev_to_v4l2_subdev(vdev);
		int rval;
		
		/*
		 * The v4l2_subdev depends on the video device node. It thus
		 * may be that the media entity refcount (which is also used
		 * to count references to the v4l2_subdev) has reached zero
		 * here. However its memory is still intact as it's part of
		 * the same struct v4l2_subdev.
		 */
		rval = v4l2_subdev_try_get(sd);
		if (rval)
			return rval;
		
		...
	}
	
	/* V4L2 sub-device release file operation handler */
	int subdev_close(struct file *file)
	{
		struct video_device *vdev = video_devdata(file);
		struct v4l2_subdev *sd = vdev_to_v4l2_subdev(vdev);

		v4l2_subdev_put(sd);
	}

	struct foo_device {
		struct v4l2_subdev sd;
		struct media_pad pad;
	};

	void foo_device_release(struct video_device *vdev)
	{
		struct v4l2_subdev *sd =
			container_of(vdev, struct v4l2_subdev, devnode);
		struct foo_device *foo =
			container_of(sd, struct foo_device, sd);

		/*
		 * TODO: acquire the graph mutex here and remove the
		 * entities corresponding to the V4L2 sub-device and its
		 * device node from the graph.
		 */
		media_entity_cleanup(&foo->sd.entity);
		
		kfree(foo);
	}

	int foo_probe(struct device *dev)
	{
		struct foo_device *foo = kmalloc(sizeof(*foo), GFP_KERNEL));

		media_entity_pads_init(&foo->sd.entity, 1, &foo->pad);
		foo->sd.entity.release = v4l2_subdev_devnode_release;
		foo->sd.devnode.release = foo_device_release;
		v4l2_async_register_subdev(&foo->sd);
	}

	void foo_remove(struct device *dev)
	{
		struct foo_device *foo = dev_get_drvdata(dev);
		
		v4l2_async_unregister_subdev(&foo->sd);
		v4l2_device_unregister_subdev(&foo->sd);
		/*
		 * v4l2_subdev_put() will end up releasing foo immediately
		 * unless file handles are open currently. Thus further
		 * accesses to foo are not allowed.
		 */
		v4l2_subdev_put(&foo->sd);
	}
	
Practical considerations
------------------------

- Beyond media entities, other media graph objects could be made refcounted.
  This is not seen necessary as the related objects such as pads are in
  practice allocated within the same driver specific struct containing the
  media entity.

	- This does not apply to links which are allocated dynamically by
	  the framework, and released at unregistration time, meaning that
	  accessing a link will require holding the media graph mutex.

- A custom release callback is to be used for refcounted framework
  structs. This makes it easy for the drivers to embed the objects in their
  own structs.

- As long as an object has its own reference count, getting or putting an
  object does not affect the refcount of another object that it depends on.
  For instance, a media entity depends on an existence of the media
  device.

- Each media entity holds a reference to the media device. Being able to
  navigate from the media entity to the media device is used in drivers and
  an abrupt disconnection of the two is problematic to handle for drivers.

- At object initialisation time the kref refcount is initialised. The object
  is put at unregistration time.
  
  	- If the object is a media entity, it is removed from the media graph
 	  when the last reference to the media entity is gone. The release
 	  callback needs to acquire the media graph mutex in order to
 	  perform the removal.

	- In particular for struct video_device, media_entity release callback will
	  put the refcount of the video device (struct device embedded in
	  struct video_device)

	- For struct v4l2_subdev, struct media_entity contained in struct
	  v4l2_subdev is dependent on struct device within struct
	  video_device.

- When a driver creates multiple reference-counted objects (such as multiple
  media entities for instance) that are part of its own private struct, it
  will need to reference-count its own struct based on the release callbacks
  of all those objects. It might be possible to simplify this by providing a
  single release callback that would cover all objects. This is already
  feasible for drivers that implement a media_device instance, V4L2
  sub-devices and V4L2 video devices hold a reference on the media_device,
  whose release callback could then act as a single gatekeeper. For other
  drivers we haven't explored yet whether the core could meaningfully
  provide help, but it should be remembered that drivers that implement
  multiple graph objects and that do not implement a media_device are not
  legion. Most slave drivers (such as sensor drivers) only implement a
  single v4l2_subdev.

- No V4L2 sub-device driver currently supports unbinding the device safely
  when a media entity (or V4L2 sub-device) is registered. Prevent manual
  unbind for all sub-device drivers by setting the suppress_bind_attrs field
  in struct device_driver.


Rules for navigating the media graph and accessing graph objects
================================================================

- Graph traversal is safe as long as the media graph lock is held during
  traversal. (I.e. no changes here.)

	- During graph traversal entity refcount must be increased in order
	  to prevent them from being released. As the media entity's release()
	  callback may be already in process at this point, a variant
	  checking that the reference count has not reached zero must be
	  used (media_entity_get_try()).

- In order to keep a reference to an object after the graph traversal has
  finished, a reference to the object must be obtained and held as long as
  the object is in use.

	- The same applies to file handles to V4L2 sub-devices or drivers
	  keeping a reference to another driver's sub-device.

- Once the reference count of an object reaches zero it will not be
  increased again, even if that object was part of a memory allocation which
  still has referenced objects. Obtaining references to such an object must
  fail.

- Navigating within a memory allocation while holding a reference to an
  object in that allocation to obtain another object is allowed. The target
  object type must provide a function testing for zero references in order
  not to not to increment reference count that has reached zero.
  kref_get_unless_zero() can be used for this. Especially drivers may need
  this.

- Circular references are not allowed.

- It is safe to move between objects of the same lifetime (same kref),
  e.g. struct v4l2_subdev and struct media_entity it contains.

The rules must be documented as part of the Media framework ReST
documentation.


Stopping the hardware safely at device unbind
=============================================

What typically gets little attention in driver implementation is stopping
safely whenever the hardware is being removed. The kernel frameworks are not
very helpful in this respect --- after all how this is done somewhat depends
on the hardware. Only hot-pluggable devices are generally affected. While it
is possible to manually unbind e.g. platform devices, that certainly is a
lesser problem for such devices.

The rules are:

- No memory related to data structures that are needed during driver
  operation can be released as long as interrupt handlers may be still
  executing or may start executing or user file handles are open.

- All hardware access must cease after the remove() callback in driver ops
  struct has returned. (For USB devices this callback is called
  disconnect(), but its purpose is precisely the same.)

Handling this correctly will require taking care of a few common matters:

1. Checking for device presence in each system call issued on a device, and
   returning -ENODEV if the device is not found.

2. The driver's remove() function must ensure that no system calls that
   could result in hardware access are ongoing.
   
3. Some system calls may sleep, and while doing so also releasing and later
   reacquiring (when they continue) the mutexes their processes were
   holding. Such processes must be woken up.

This is not an easy task for a driver and the V4L2 and Media controller
frameworks need to help the drivers to achieve this so that drivers would
need to worry about this as little as possible. Drivers relying for their
locking needs on the videobuf2 and the V4L2 frameworks are likely to require
fewer changes.

The same approach must be taken in issuing V4L2 sub-device operations by
other kernel drivers.


Serialising unbind with hardware access through system calls
------------------------------------------------------------

What's below is concentrated in V4L2; Media controller will need similar
changes.

- Add a function called video_unregister_device_prepare() (or
  video_device_mark_unregistered() or a similarly named function) to amend
  the functionality of video_unregister_device(): mark the device
  unregistering so that new system calls issues on the device will return an
  error.

- Device node specific use count for active system calls.

- Waiting list for waiting for the use count to reach zero (for proceeding
  unregistration in v4l2_unregister_device()). Each finishing system call on
  a file descriptor will wake up the waiting list.

- Processes waiting in a waiting list of a system call (e.g. poll, DQBUF
  IOCTL) will be woken up. After waiting, the processes will check whether
  the video node is still registered, i.e. video_unregister_device_prepare()
  has not been called.


Things to remember
------------------

- Using the devm_request_irq() is _NOT_ allowed in general case, as the
  free_irq() results in being called _after_ the driver's release callback.
  This means that if new interrupts still arrive between driver's release
  callback returning and devres resources not being released, the driver's
  interrupt handler will still run. Use request_irq() and free_irq()
  instead.


What changes in practice?
=========================

Most of the changes needed in order to align the current implementation to
conform the above are to be made in the frameworks themselves. What changes
in drivers, though, is how objects are initialised and released. This mostly
applies to drivers' own data structures that often contain reference counted
object types from the frameworks.

Relations between various frameworks objects will need to be handled in a
standard way in the appropriate registeration, unregistration and reference
getting and putting functions. Drivers (as well as frameworks, such as the
V4L2 sub-device framework in its open and close file operations) will make
use of these functions to get an put references to the said objects.

Drivers that are not hot-pluggable could largely ignore the changes, as
unregistering an object does in fact take place right before releasing that
object, meaning drivers that did not perform any object reference counting
are no more broken with the changes described above without implementing
reference counting. Still care must be taken that they remain decently
unloadable when there are no users.

New drivers should be required to implement object reference counting
correctly, whether hot-pluggable or not. One platform driver (e.g. omap3isp)
should be fixed to function as a model for new platform drivers.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
