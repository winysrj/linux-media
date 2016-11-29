Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:44887
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752303AbcK2LN7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Nov 2016 06:13:59 -0500
Date: Tue, 29 Nov 2016 09:13:05 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com
Subject: Re: [RFC v3 00/21] Make use of kref in media device, grab
 references as needed
Message-ID: <20161129091305.37ab004c@vento.lan>
In-Reply-To: <20161128104556.GI16630@valkosipuli.retiisi.org.uk>
References: <20161109154608.1e578f9e@vento.lan>
        <20161114132722.GR3217@valkosipuli.retiisi.org.uk>
        <20161122154429.62ab1825@vento.lan>
        <20161128104556.GI16630@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

I answered you point to point below, but I suspect that you missed how the 
current approach works. So, I decided to write a quick summary here.

The character devices /dev/media? are created via cdev, with relies on a 
kobject per device, with has an embedded struct kref inside.

Also, each kobj at /dev/media0, /dev/media1, ... is associated with a
struct device, when the code does:
	devnode->cdev.kobj.parent = &devnode->dev.kobj;

before calling cdev_add().

The current lifetime management is actually based on cdev's kobject's
refcount, provided by its embedded kref.

The kref warrants that any data associated with /dev/media0 won't be 
freed if there are any pending system call. In other words, when 
cdev_del() is called, it will remove /dev/media0 from the filesystem, and
will call kobject_put(). 

If the refcount is zero, it will call devnode->dev.release(). If the 
kobject refcount is not zero, the data won't be freed.

So, in the best case scenario, there's no opened file descriptors
by the time media device node is unregistered. So, it will free
everything.

In the worse case scenario, e. g. when the driver is removed or 
unbind while /dev/media0 has some opened file descriptor(s),
the cdev logic will do the proper lifetime management.

On such case, /dev/media0 disappears from the file system, so another open
is not possible anymore. The data structures will remain allocated until
all associated file descriptors are not closed.

When all file descriptors are closed, the data will be freed.

On that time, it will call an optional dev.release() callback,
responsible to free any other data struct that the driver allocated.

Em Mon, 28 Nov 2016 12:45:56 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> On Tue, Nov 22, 2016 at 03:44:29PM -0200, Mauro Carvalho Chehab wrote:
> > Em Mon, 14 Nov 2016 15:27:22 +0200
> > Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> >   
> > > Hi Mauro,
> > > 
> > > I'm replying below but let me first summarise the remaining problem area
> > > that this patchset addresses.  
> > 
> > Sorry for answering too late. Somehow, I missed this email in the cloud.
> >   
> > > The problems you and Shuah have seen and partially addressed are related to
> > > a larger picture which is the lifetime of (mostly) memory resources related
> > > to various objects used by as well both the Media controller and V4L2
> > > frameworks (including videobuf2) as the drivers which make use of these
> > > frameworks.
> > > 
> > > The Media controller and V4L2 interfaces exposed by drivers consist of
> > > multiple devices nodes, data structures with interdependencies within the
> > > frameworks themselves and dependencies from the driver's own data structures
> > > towards the framework data structures. The Media device and the media graph
> > > objects are central to the problem area as well.
> > > 
> > > So what are the issues then? Until now, we've attempted to regulate the
> > > users' ability to access the devices at the time they're being unregistered
> > > (and the associated memory released), but that approach does not really
> > > scale: you have to make sure that the unregistering also will not take place
> > > _during_ the system call --- not just in the beginning of it.
> > >
> > > The media graph contains media graph objects, some of which are media
> > > entities (contained in struct video_device or struct v4l2_subdev, for
> > > instance). Media entities as graph nodes have links to other entities. In
> > > order to implement the system calls, the drivers do parse this graph in
> > > order to obtain information they need to obtain from it. For instance, it's
> > > not uncommon for an implementation for video node format enumeration to
> > > figure out which sub-device the link from that video nodes leads to. Drivers
> > > may also have similar paths they follow.
> > > 
> > > Interrupt handling may also be taking place during the device removal during
> > > which a number of data structures are now freed. This really does call for a
> > > solution based on reference counting.
> > > 
> > > This leads to the conclusion that all the memory resources that could be
> > > accessed by the drivers or the kernel frameworks must stay intact until the
> > > last file handle to the said devices is closed. Otherwise, there is a
> > > possibility of accessing released memory.  
> > 
> > So far, we're aligned.
> >   
> > > Right now in a lot of the cases, such as for video device and sub-device
> > > nodes, we do release the memory when a device (as in struct device) is being
> > > unregistered. There simply is in the current mainline kernel a way to do
> > > this in a safe way.  
> >   
> > > Drivers do use devm_() family of functions to allocate
> > > the memory of the media graph object and their internal data structures.  
> > 
> > Removing devm_() from those drivers seem to be the first thing to do,
> > and it is independent from any MC rework.
> > 
> > As you'll see below, we have different opinions on other matters,
> > so, my suggestion about how to proceed is that you should submit
> > first the things we're aligned.
> > 
> > In other words, please submit the patches that get rid of devm_()
> > first. Then, we can address the remaining stuff.  
> 
> Removing devm_*() is needed, but when should the memory be released then?
> There's no callback currently from the media device the driver could use.

It should be easy to add a release callback if you need. Yet, I think you
don't need a callback for that. Instead, you could just use the already
existing one at struct device, e. g. export media_devnode_release() and,
on drivers that need to release additional data, you would be doing something
like:

	static void my_devnode_release(struct device *cd)
	{
		// Some code that would release things before kfree(dev)
		kthread_stop(foo_thread);
		free(foo);

		// will internally do a kfree(dev)
		media_devnode_release(cd);

		// Some code that would release things after kfree(dev)
		free(bar);
	}

And set the new release callback after registering the media device with:

	media_device_register(...);
	devnode->dev.release = my_devnode_release;

The advantage of such approach is that it allows to control the order
where things will be freed/released.

> 
> OTOH devm_*() interfaces are very convenient to use, it's a lot of extra
> work for drivers to handle releasing all the resources. It'd be great to
> find another object where to bind those resources. Still, device_release()
> does first release devres resources and then calls the release() callback,
> which obviously makes the setup problematic to begin with.

Shuah's approach is providing another way to bind things. Yet, maybe
it could still be possible to use devm_*(), if it has a way to
control when devm will free their resources. I suspect that, if you call
devm_free() during dev.release() callback, or if you use the same struct
device that is associated with the cdev, devm will work.

> >   
> > > 
> > > With this patchset:
> > > 
> > > - The media_device which again contains the media_devnode is allocated
> > >   dynamically. The lifetime of the media device --- and the media graph
> > >   objects it contains --- is bound to device nodes that are bound to the
> > >   media device (video and sub-device nodes) as well as open file handles.  
> > 
> > No. Data structures with cdev embedded into them have their lifetime
> > controlled by the driver's core, and are destroyed only when there's
> > no pending fops. The current approach uses device's core dev.release()  
> 
> Fair enough; that part is indeed handled towards the user space as far as I
> can tell. However that's still not enough: the media graph contains the
> graph objects, and the media device that holds the graph, must outlive the
> graph objects themselves.

Sorry, didn't follow you here. What's the sense of not freeing the media
graph before destroying the struct device associated with /dev/media0? 
In other words, what should outlive after chardev's data is freed?

Please notice that the driver's core kobject kref ensures that the device
release code is called only after all file descriptors are closed, and
no other syscall would affect the cdev.

> Also removing entities doesn't really work currently: touching an entity, a
> link or any kind of a graph object is not guaranteed to work unless you hold
> the media graph lock. And that's simply unfeasible.

Sorry, again, didn't follow you here. The current strategy for adding
and removing things at the graph relies on a lock, with serializes access
to the graph, in order to avoid races if someone is trying to navigate on
the graph while an object is being inserted or removed.

It could be converted into a lockless approach (for example, using RCU),
but this is a separate issue.

The removal code needs to use whatever lock (or lockless) schema we
use to serialize the access to the graph.

> Just look at what the
> drivers do with entities: they use the v4l2_subdev interface and the control
> framework to access them.
> 
> These data structures contain struct media_entity in them, and that entity
> is part of the media graph. Other drivers use entities e.g. to obtain
> control values from them. References should be used to prevent releasing the
> memory.

References are used by the driver's core, using kobject_get() and
kobject_put(). That warrants that dev.release() will only be called
when nobody is using it anymore.

> media_entity_get() and media_entity_put() do not do what you'd expect.

Please elaborate.

> v4l2_subdev_call() should also verify that a sub-device is registered, and
> make sure it will stay that way for the duration of call: the driver must be
> able to expect the entity is accessible as the driver registered it.

Yes, but I can't see how this is related to this discussion. Before
unregistering struct device, you need to unbind the subdevs.

The only case I can see of calling v4l2_subdev_call() after all file
descriptors are closed is if you have some kthread running. You need to 
call kthread_stop() for such kthreads before freeing struct device.

You could do it at a my_devnode_release() if you need the kthread running
even after closing all file descriptors, or even before that, before
calling media_device_unregister().

> The same goes for the control framework.

I don't think we have kthreads for controls. The control routines
are called only when a file descriptor is opened. So, I don't see
any possible issue with the control framework.

> As far as I remember, we somehow assumed that just acquiring the related
> kernel modules would be enough to counter this but it is not.

Well, if not, you could use kobject_get() and kobject_put() to increment
or decrement the cdev's refcount. Yet, I suspect that, if the drivers are 
properly designed, you won't need to manually touch at the kref.

> 
> I would prefer to postpone this however, the patchset already does enough
> for a single patchset. Fixing this properly would likely require wait/wound
> mutexes for individual entities.
> 
> > callback to release memory.
> > 
> > In other words, dev.release() is only called after the driver's base
> > knows that the cdev is not in use anymore. So, no ioctl() or any
> > other syscalls on that point.
> > 
> > Ok, nothing prevents some driver to do the wrong thing, keeping a
> > copy of struct device and using it after free, for example storing
> > it on a devm alocated memory, and printing some debug message
> > after struct device is freed, but this is a driver's bug.
> > 
> > What really worries me on this series is that it seemed that you 
> > didn't understood how the current approach works. So, you decided
> > to just revert it and start from scratch. This is dangerous, as
> > it could cause problems to other scenarios than yours.  
> 
> I'm not quite sure what do you mean.
> 
> It may well be that the patchset will require changes but that's precisely
> the reason why patches are reviewed before merging.

>From your comments and from your code, you didn't seem to realize that
the current approach relies at the struct device refcount. See above.

> >   
> > > - Care is taken that the unregistration process and releasing memory happens
> > >   in the right order. This was not always the case previously.  
> > 
> > Freeing memory for struct media_devnode, struct device and struct cdev 
> > is currently handled by the driver's core, when it known to be safe,
> > and using the same logic that other subsystems do.  
> 
> That's simply not the case. Other sub-systems do not have graphs managed by
> multiple device drivers for multiple physical devices that expose device
> nodes through which all of those devices can be accessed. The problem domain
> is far more complex than if you had a single physical device for which a
> driver would expose a device node or two to the user space.

No. The current approach uses the struct device associated with /dev/media0,
created via cdev, to provide a refcount for the data associated with the
character device.

The struct device kobject refcount ensures that everything associated
with it will only be freed after the refcount goes to zero.

As I said before, if are there any cases where the refcount is going
early to zero, it is just a matter of adding a few kobject_get() and
kobject_put() to ensure that this won't happen early, if the driver is
so broken that it is unable to do the right refcount.

> 
> > 
> > We might do it different, but we need a strong reason to do it, as
> > going away from the usual practice is dangerous.  
> 
> I think we already did that when we merged the original Media controller and
> V4L2 sub-device patches...
> 
> >   
> > > - The driver remains responsible for the memory of the video and sub-device
> > >   nodes. However, now the Media controller provides a convenient callback to
> > >   the driver to release any memory resources when the time has come to do
> > >   so. This takes place just before the media device memory is released.  
> > 
> > Drivers could use devnode->dev.release for that. Of course, if they
> > override it, they should be calling media_devnode_release() on their
> > internal release functions.  
> 
> That'd be really hackish. The drivers currently don't deal with
> media_devnode directly now and I don't think they should be obliged to.

I'm not against adding a callback instead. However, that makes it lose
flexibility, as the callback will either be called before of after
freeing struct device.

By overriding the dev.release callback, we have a finer control.

If you don't see any case where we'll be freeing data after freeing
struct device, then a callback would work.

> >   
> > > - Drivers that do not strictly need to be removable require no changes. The
> > >   benefits of this set become tangible for any driver by changing how the
> > >   driver allocates memory for the data structures. Ideally at least
> > >   drivers for hot-removable devices should be converted.  
> > 
> > Drivers should allow device removal and/or driver removal. If you're
> > doing any change here, you need to touch *all* drivers to use the new 
> > way.  
> 
> Let's first agree on what needs to be fixed and how, and then think about
> converting the drivers. Buggy code has a tendency to continue to be buggy
> unless it is fixed (or replaced).

True, but as I said, this series create buggy code when it ignored what
was fixed already. Also, a patch series to be considered ready for
upstream need to do the needed changes on all drivers it affects.

> > > In order to make the current drivers to behave well it is necessary to make
> > > changes to how memory is allocated in the drivers. If you look at the sample
> > > patches that are part of the set for the omap3isp driver, you'll find that
> > > around 95% of the changes are related to removing the user of devm_() family
> > > of functions instead of Media controller API changes. In this regard, the
> > > approach taken here requires very little if any additional overhead.  
> > 
> > Well, send the patches that do the 95% of the changes first e. g. devm_()
> > removal, and check if you aren't using any dev_foo() printk after
> > unregister, and send such patch series, without RFC. Then test what's
> > still broken, if any and let's discuss with your results, in a way
> > that we can all reproduce the issues you may be facing on other drivers
> > that don't use devm*().  
> 
> As I said, there's currently no way to properly release these resources as
> the driver won't receive a callback from media device release.

If you're so convinced that it is needed and you won't be overriding
media device's struct device release callback, just add it. It should
be a 3 lines patch.
> 
> > 
> >   
> > > On Wed, Nov 09, 2016 at 03:46:08PM -0200, Mauro Carvalho Chehab wrote:  
> > > > Em Wed, 9 Nov 2016 10:00:58 -0700
> > > > Shuah Khan <shuahkh@osg.samsung.com> escreveu:
> > > >     
> > > > > > Maybe we can get the Media Device Allocator API work in and then we can
> > > > > > get your RFC series in after that. Here is what I propose:
> > > > > > 
> > > > > > - Keep the fixes in 4.9    
> > > > 
> > > > Fixes should always be kept. Reverting a fix is not an option.
> > > > Instead, do incremental patches on the top of it.
> > > >     
> > > > > > - Get Media Device Allocator API patches into 4.9.      
> > > > > 
> > > > > I meant 4.10 not 4.9
> > > > >     
> > > > > > - snd-usb-auido work go into 4.10    
> > > > 
> > > > Sounds like a plan.
> > > >     
> > > > > > Then your RFC series could go in. I am looking at the RFC series and that
> > > > > > the drivers need to change as well, so this RFC work could take longer.
> > > > > > Since we have to make media_device sharable, it is necessary to have a
> > > > > > global list approach Media Device Allocator API takes. So it is possible
> > > > > > for your RFC series to go on top of the Media Device Allocator API.    
> > > > 
> > > > Firstly, the RFC series should be converted into something that can
> > > > be applicable upstream, e. g.:
> > > > 
> > > > - doing the changes over the top of upstream, instead of needing to
> > > >   revert patches;    
> > > 
> > > The patches are in fact on top of the current media-tree, or were when they
> > > were sent (v4).
> > > 
> > > The reason I'm reverting patches is that the reason why these patches were
> > > merged was not because they would have been a sound way forward for the
> > > Media controller framework, but because they partially worked around issues
> > > in a device being in use while it was removed.
> > > 
> > > They never were a complete fix for these problems nor I do think they could
> > > be extended to be such. There were also unaddressed issues in these patches
> > > pointed out during the review. For these reasons I'm reverting the three
> > > patches. In more detail:
> > > 
> > > * media: fix media devnode ioctl/syscall and unregister race
> > >   6f0dd24a084a
> > > 
> > > The patch clears the registered bit before performing the steps related to
> > > unregistering a media device, but the bit is checked only at the beginning
> > > of the IOCTL call. As unregistering a device and an IOCTL call on a file
> > > handle of that device are not serialised, nothing guarantees the IOCTL call
> > > will finish with the registered bit still in the same state. Serialising the
> > > two e.g. by using a mutex is hardly a feasible solution for this.
> > > 
> > > I may have pointed out the original problem but this is not the solution.
> > > 
> > > <URL:http://www.spinics.net/lists/linux-media/msg101295.html>
> > > 
> > > The right solution is instead to make sure the data structures related to
> > > the media device will not disappear while the IOCTL call is in progress (at
> > > least).  
> > 
> > They won't. Device core won't call dev.release() while an ioctl doesn't
> > finish. So, the struct device and struct devnode will exist while the
> > ioctl (or any other fops) is handled.  
> 
> I believe you're right when it comes to drivers using video devices without
> Media controller. However the Media devices and V4L2 sub-device nodes are
> another matter as well as the drivers The drivers need to be able to rely on
> the frameworks to support them. On MC the driver simply has no way to
> release the media device at the right time. The same applies to V4L2
> sub-devices --- something that could be added to the patchset.

Huh? What's the sense of removing /dev/media0 and their associated
struct device before releasing the media graph?

The problem here is exactly the same as *any* other character device:
you need *first* to stop using whatever data struct is needed for
controlling /dev/media device and *then* removing /dev/media and
freeing their data structures, including struct device.

> >   
> > > * media: fix use-after-free in cdev_put() when app exits after driver unbind
> > >   5b28dde51d0c
> > > 
> > > The patch avoids the problem of deleting a character device (cdev_del())
> > > after its memory has been released. The change is sound as such but the
> > > problem is addressed by another, a lot more simple patch in my series:
> > > 
> > > <URL:http://git.retiisi.org.uk/?p=~sailus/linux.git;a=commitdiff;h=26fa8c1a3df5859d34cef8ef953e3a29a432a17b>  
> > 
> > Your approach is not clean, as it is based on a cdev's hack of doing:
> > 
> > 	devnode->cdev.kobj.parent = &devnode->dev.kobj;
> > 
> > That is an ugly hack, as it touches inside cdev's internal stuff,
> > to do something that the driver's core doesn't expect. This is the
> > kind of patch that could cause messy errors, by cheating with the
> > cdev's internal refcount checking.
> > 
> > Btw, your approach require changes on *all* drivers, in order to make
> > device release work, with is a way more complex than changing just the
> > core. as the current approach. 
> >   
> > > It might be possible to reasonably continue from here if the next patch to
> > > be reverted did not depend on this one.
> > > 
> > > * media-device: dynamically allocate struct media_devnode
> > > 
> > > This creates a two-way dependency between struct media_devnode and
> > > media_device. This is very much against the original design which clearly
> > > separates the two: media_devnode is entirely independent of media_device.  
> > 
> > Those structs are still independent.
> >   
> > > The original intent was that another sub-system in the kernel such as the
> > > V4L2 could make use of media_devnode as well and while that hasn't happened,
> > > perhaps the two could be merged. There simply are no other reasons to keep
> > > the two structs separate.
> > > 
> > > The patch is certainly a workaround, as it (partially, again) works around
> > > issues in timing of releasing memory and accessing it.
> > > 
> > > The proper solutions regarding the media_device and media_devnode are either
> > > maintain the separation or unify the two, and this patch does nor suggests
> > > either of these. To the contrary: it makes either of these impossible by
> > > design, and this reason alone is enough to revert it.
> > > 
> > > The set I'm pushing maintains the separation and leaves the option of either
> > > merging the two (media_device and media_devnode) or making use of
> > > media_devnode elsewhere open.  
> > 
> > As mentioned before, being based on a hack doesn't make it nice
> > for upstream merging.
> > 
> > The current approach uses the recommended way: the structure with
> > cdev embedded should be dynamically allocated. Well, we could merge
> > media_device and media_devnode, but, in this case, we'll need to
> > not embed media_device, in order to avoid hacks like the above.  
> 
> The current approach is simply not enough, be cdev allocated separately from
> media_devnode or not: the drivers have no way properly release memory
> related to the media devices nor the v4l2 sub-devices. That memory will get
> accessed through IOCTL calls: simply checking that a device was registered
> at one point does not mean it continues to be registered in another point of
> time in the future, unless the two operations are serialised in a way or
> another.

Huh? The current approach relies on kref.

> >   
> > > > - change all drivers as the kAPI changes;    
> > > 
> > > The patchset actually adds new APIs rather than changing the OLD one --- as
> > > the old one was simply that drivers were responsible for allocating the data
> > > structures related to a media device. Existing drivers should continue to
> > > work as they did before without changes.  
> > 
> > Are you sure? Did you try the tests we did with binding/unbind, device
> > removal/insert and probe/remove of em28xx with your patches applied?  
> 
> I haven't tested that but as a matter of fact, I think I indeed have such
> device so I could test it. Changes on the DVB side would be needed as well
> in order to benefit from the API for allocating the media device.
> 
> > 
> > With that regards, you should really test it on an USB device, with
> > is hot-pluggable. There, you'll see a lot more memory lifetime issues
> > than on omap3.  
> 
> I'm not so sure about USB devices: unbinding works the same way whether the
> device is actually hot-pluggable. Still testing with different kind of
> devices definitely does help to root out issues, that's for sure.
> 
> >   
> > > Naturally, to get full benetifs of the changes, driver changes will be also
> > > required (see the beginning of the message).  
> > 
> > The test cases we did works on em28xx. If, after each patch of this series,
> > a regression happens, you need to address. I suspect that, even applying
> > the entire series, there will still be regressions, as I don't see any
> > changes to em28xx on this patch series.  
> 
> That's true, I've only changed the omap3isp driver so far as I wanted to get
> feedback on the framework changes.
> 
> >   
> > > The set has been posted as RFC in order to get reviews. It makes no sense to
> > > convert all the drivers and then start changing APIs, affecting all those
> > > converted drivers.  
> > 
> > Well, while it is not complete and still cause regressions, It can't be
> > considered ready for upstream review.
> >   
> > > > 
> > > > - be git bisectable, e. g. all patches should compile and run fine
> > > >   after each single patch, without introducing regressions.    
> > > 
> > > Compilation has already been tested (on ARM) on each patch applied in order.  
> > 
> > Good, but the best is to test it also on x86. Please notice that
> > just compiling doesn't ensure that it doesn't introduce regressions.
> > 
> > You should do your best to avoid regressions on every single patch
> > on your patch series.  
> 
> Certainly. Other than that, there would be fewer patches than there is
> now...
> 
> >   
> > > > 
> > > > That probably means that the series should be tested not only on
> > > > omap3, but also on some other device drivers.    
> > > 
> > > I fully agree with that. More review, testing and changes to at least some
> > > drivers (mostly for removable devices) will be needed before merging them,
> > > that's for sure.  
> > 
> > Good! One more point we agree :-)  
> 
> That's progress. It's a good start but we need more than that.
> 

Thanks,
Mauro
