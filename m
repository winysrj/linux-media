Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55434 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754786AbcLOLbU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 06:31:20 -0500
Date: Thu, 15 Dec 2016 13:30:41 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com
Subject: Re: [RFC v3 00/21] Make use of kref in media device, grab references
 as needed
Message-ID: <20161215113041.GE16630@valkosipuli.retiisi.org.uk>
References: <20161109154608.1e578f9e@vento.lan>
 <20161114132722.GR3217@valkosipuli.retiisi.org.uk>
 <20161122154429.62ab1825@vento.lan>
 <20161128104556.GI16630@valkosipuli.retiisi.org.uk>
 <20161129091305.37ab004c@vento.lan>
 <20161213105305.GX16630@valkosipuli.retiisi.org.uk>
 <20161213102447.60990b1c@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161213102447.60990b1c@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Tue, Dec 13, 2016 at 10:24:47AM -0200, Mauro Carvalho Chehab wrote:
> Em Tue, 13 Dec 2016 12:53:05 +0200
> Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> 
> > Hi Mauro,
> > 
> > On Tue, Nov 29, 2016 at 09:13:05AM -0200, Mauro Carvalho Chehab wrote:
> > > Hi Sakari,
> > > 
> > > I answered you point to point below, but I suspect that you missed how the 
> > > current approach works. So, I decided to write a quick summary here.
> > > 
> > > The character devices /dev/media? are created via cdev, with relies on a 
> > > kobject per device, with has an embedded struct kref inside.
> > > 
> > > Also, each kobj at /dev/media0, /dev/media1, ... is associated with a
> > > struct device, when the code does:
> > > 	devnode->cdev.kobj.parent = &devnode->dev.kobj;
> > > 
> > > before calling cdev_add().
> > > 
> > > The current lifetime management is actually based on cdev's kobject's
> > > refcount, provided by its embedded kref.
> > > 
> > > The kref warrants that any data associated with /dev/media0 won't be 
> > > freed if there are any pending system call. In other words, when 
> > > cdev_del() is called, it will remove /dev/media0 from the filesystem, and
> > > will call kobject_put(). 
> > > 
> > > If the refcount is zero, it will call devnode->dev.release(). If the 
> > > kobject refcount is not zero, the data won't be freed.
> > > 
> > > So, in the best case scenario, there's no opened file descriptors
> > > by the time media device node is unregistered. So, it will free
> > > everything.
> > > 
> > > In the worse case scenario, e. g. when the driver is removed or 
> > > unbind while /dev/media0 has some opened file descriptor(s),
> > > the cdev logic will do the proper lifetime management.
> > > 
> > > On such case, /dev/media0 disappears from the file system, so another open
> > > is not possible anymore. The data structures will remain allocated until
> > > all associated file descriptors are not closed.
> > > 
> > > When all file descriptors are closed, the data will be freed.
> > > 
> > > On that time, it will call an optional dev.release() callback,
> > > responsible to free any other data struct that the driver allocated.  
> > 
> > The patchset does not change this. It's not a question of the media_devnode
> > struct either. That's not an issue.
> > 
> > The issue is rather what else can be accessed through the media device and
> > other interfaces. As IOCTLs are not serialised with device removal (which
> > now releases much of the data structures) 
> 
> Huh? ioctls are serialized with struct device removal. The Driver core
> warrants that.

How?

As far as I can tell, there's nothing in the way of an IOCTL being in
progress on a character device which is registered by the driver for a
hardware device which is being removed.

vfs_ioctl() directly calls the unlocked_ioctl() file operation which is, in
case of MC, media_ioctl() in media-devnode.c. No mutexes (or other locks)
are taken during that path, which I believe is by design.

> 
> > there's a high chance of accessing
> > released memory (or mutexes that have been already destroyed). An example of
> > that is here, stopping a running pipeline after unbinding the device. What
> > happens there is that the media device is released whilst it's in use
> > through the video device.
> > 
> > <URL:http://www.retiisi.org.uk/v4l2/tmp/media-ref-dmesg2.txt>
> 
> It is not clear from the logs what the driver tried to do, but
> that sounds like a driver's bug, with was not prepared to properly
> handle unbinds.
> 
> The problem here is that isp_video_release() is called by V4L2
> release logic, and not by the MC one:
> 
> static const struct v4l2_file_operations isp_video_fops = {
> 	.owner		= THIS_MODULE,
> 	.open		= isp_video_open,
> 	.release	= isp_video_release,
> 	.poll		= vb2_fop_poll,
> 	.unlocked_ioctl	= video_ioctl2,
> 	.mmap		= vb2_fop_mmap,
> };
> 
> It seems that the driver's logic allows it to be called before or
> after destroying the MC.
> 
> Assuming that, if the OMAP3 driver is not used it works,
> it means that, if the isp_video_release() is called
> first, no errors will happen, but if MC is destroyed before
> V4L2 call to its .release() callback, as there's no logic at the
> driver that would detect it, isp_video_release() will be calling
> isp_video_streamoff(), with depends on the MC to work.
> 
> On a first glance, I can see two ways of fixing it:
> 
> 1) to increment devnode's device kobject refcount at OMAP3 .probe(), 
> decrementing it only at isp_video_release(). That will ensure that
> MC will only be removed after V4L2 removal.
> 
> 2) to call isp_video_streamoff() before removing the MC stuff, e. g.
> inside the MC .release() callback. 

This is a fair suggestion, indeed. Let me see what could be done there.
Albeit this is just *one* of the existing issues. It will not address all
problems fixed by the patchset.

> 
> That could be done by overwriting the dev.release() callback at
> omap3 driver, as I discussed on my past e-mails, and flagging the
> driver that it should not accept streamon anymore, as the hardware
> is being disconnecting.

A mutex will be needed to serialise the this with starting streaming.

> 
> Btw, that explains a lot why Shuah can't reproduce the stuff you're
> complaining on her USB hardware.
> 
> The USB subsystem has a a .disconnect() callback that notifies
> the drivers that a device was unbound (likely physically removed).
> The way USB media drivers handle it is by returning -ENODEV to any
> V4L2 call that would try to touch at the hardware after unbound.
> 
> So, on au0828, there's no need to add any extra release logic.
> 
> > <URL:http://www.spinics.net/lists/linux-media/msg108943.html>
> > 
> > > 
> > > Em Mon, 28 Nov 2016 12:45:56 +0200
> > > Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> > >   
> > > > Hi Mauro,
> > > > 
> > > > On Tue, Nov 22, 2016 at 03:44:29PM -0200, Mauro Carvalho Chehab wrote:  
> > > > > Em Mon, 14 Nov 2016 15:27:22 +0200
> > > > > Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> > > > >     
> > > > > > Hi Mauro,
> > > > > > 
> > > > > > I'm replying below but let me first summarise the remaining problem area
> > > > > > that this patchset addresses.    
> > > > > 
> > > > > Sorry for answering too late. Somehow, I missed this email in the cloud.
> > > > >     
> > > > > > The problems you and Shuah have seen and partially addressed are related to
> > > > > > a larger picture which is the lifetime of (mostly) memory resources related
> > > > > > to various objects used by as well both the Media controller and V4L2
> > > > > > frameworks (including videobuf2) as the drivers which make use of these
> > > > > > frameworks.
> > > > > > 
> > > > > > The Media controller and V4L2 interfaces exposed by drivers consist of
> > > > > > multiple devices nodes, data structures with interdependencies within the
> > > > > > frameworks themselves and dependencies from the driver's own data structures
> > > > > > towards the framework data structures. The Media device and the media graph
> > > > > > objects are central to the problem area as well.
> > > > > > 
> > > > > > So what are the issues then? Until now, we've attempted to regulate the
> > > > > > users' ability to access the devices at the time they're being unregistered
> > > > > > (and the associated memory released), but that approach does not really
> > > > > > scale: you have to make sure that the unregistering also will not take place
> > > > > > _during_ the system call --- not just in the beginning of it.
> > > > > >
> > > > > > The media graph contains media graph objects, some of which are media
> > > > > > entities (contained in struct video_device or struct v4l2_subdev, for
> > > > > > instance). Media entities as graph nodes have links to other entities. In
> > > > > > order to implement the system calls, the drivers do parse this graph in
> > > > > > order to obtain information they need to obtain from it. For instance, it's
> > > > > > not uncommon for an implementation for video node format enumeration to
> > > > > > figure out which sub-device the link from that video nodes leads to. Drivers
> > > > > > may also have similar paths they follow.
> > > > > > 
> > > > > > Interrupt handling may also be taking place during the device removal during
> > > > > > which a number of data structures are now freed. This really does call for a
> > > > > > solution based on reference counting.
> > > > > > 
> > > > > > This leads to the conclusion that all the memory resources that could be
> > > > > > accessed by the drivers or the kernel frameworks must stay intact until the
> > > > > > last file handle to the said devices is closed. Otherwise, there is a
> > > > > > possibility of accessing released memory.    
> > > > > 
> > > > > So far, we're aligned.
> > > > >     
> > > > > > Right now in a lot of the cases, such as for video device and sub-device
> > > > > > nodes, we do release the memory when a device (as in struct device) is being
> > > > > > unregistered. There simply is in the current mainline kernel a way to do
> > > > > > this in a safe way.    
> > > > >     
> > > > > > Drivers do use devm_() family of functions to allocate
> > > > > > the memory of the media graph object and their internal data structures.    
> > > > > 
> > > > > Removing devm_() from those drivers seem to be the first thing to do,
> > > > > and it is independent from any MC rework.
> > > > > 
> > > > > As you'll see below, we have different opinions on other matters,
> > > > > so, my suggestion about how to proceed is that you should submit
> > > > > first the things we're aligned.
> > > > > 
> > > > > In other words, please submit the patches that get rid of devm_()
> > > > > first. Then, we can address the remaining stuff.    
> > > > 
> > > > Removing devm_*() is needed, but when should the memory be released then?
> > > > There's no callback currently from the media device the driver could use.  
> > > 
> > > It should be easy to add a release callback if you need. Yet, I think you
> > > don't need a callback for that. Instead, you could just use the already
> > > existing one at struct device, e. g. export media_devnode_release() and,
> > > on drivers that need to release additional data, you would be doing something
> > > like:
> > > 
> > > 	static void my_devnode_release(struct device *cd)
> > > 	{
> > > 		// Some code that would release things before kfree(dev)
> > > 		kthread_stop(foo_thread);
> > > 		free(foo);
> > > 
> > > 		// will internally do a kfree(dev)
> > > 		media_devnode_release(cd);
> > > 
> > > 		// Some code that would release things after kfree(dev)
> > > 		free(bar);
> > > 	}  
> > 
> > I think we really want to make correct implementations easy for drivers, not
> > requiring e.g. to use the media_devnode interface directly. As device
> > removal isn't serialised with IOCTLs, every driver should do this in order
> > to prevent device driver's / framework IOCTL handlers operating on released
> > memory.
> 
> Well, it would be easy to add a callback at that media_devnode_release()
> would call on drivers that would need it.
> 
> As I said before, USB drivers don't need anything extra at devnode
> release. I'd say more, even PCI drivers won't likely need it, as they
> don't use MC to do things like streamoff.
> 
> I suspect that such special .release() logic is only needed on drivers
> that don't work without MC, e. g. subdev-based ones.
> 
> > 
> > > 
> > > And set the new release callback after registering the media device with:
> > > 
> > > 	media_device_register(...);
> > > 	devnode->dev.release = my_devnode_release;
> > > 
> > > The advantage of such approach is that it allows to control the order
> > > where things will be freed/released.  
> > 
> > That's among the things the patchset does, but I think in a much nicer way.
> 
> A /21 patch series that break release on all drivers but OMAP3 doesn't seem
> to be a cleaner/nicer approach.

I've said multiple times this RFC set is proposing an MC core interface
change, and until the interface is agreed on or at least discussed, there is
no point in converting all existing drivers. It'd be just extra work for no
gain.

It's also debatable whether this breaks any other driver. It does widen the
time window during which bad stuff may happen (without driver changes) but
it does not add any new ones as far as I can tell.

> 
> > > > OTOH devm_*() interfaces are very convenient to use, it's a lot of extra
> > > > work for drivers to handle releasing all the resources. It'd be great to
> > > > find another object where to bind those resources. Still, device_release()
> > > > does first release devres resources and then calls the release() callback,
> > > > which obviously makes the setup problematic to begin with.  
> > > 
> > > Shuah's approach is providing another way to bind things. Yet, maybe
> > > it could still be possible to use devm_*(), if it has a way to
> > > control when devm will free their resources. I suspect that, if you call
> > > devm_free() during dev.release() callback, or if you use the same struct
> > > device that is associated with the cdev, devm will work.  
> > 
> > I wonder if we could use the media_devnode cdev's struct device to bind this
> > stuff to. It'd be gone when there's a certainty it'll no longer be needed.
> 
> Maybe, but the real problem here is that some data are associated to
> MC, while others are associated with V4L2. 
> 
> If you can identify what data is associated to MC, and provide a way
> to handle MC ".disconnect()" so that V4L2 won't be trying to use the
> MC-related data, then it would be safe to use devm to allocate memory.

Let's see how stopping the streaming in omap3isp remove() handler would look
like, and what else needs to be serialised with that.

> 
> > The caveat is the release callback is called after the devres resources have
> > been released. So if a driver requires also the release callback, then it
> > has no longer access to memory allocated using devm_*() functions. I'd like
> > to have Laurent's opinion on this.
> > 
> > This solution is no longer enough when we have media devices where you can
> > remove entities, as those would only be released when the entire device is
> > gone. Or, there's a memory leak until removal of the media device. I don't
> > like that albeit there might be still very few practical problems.
> 
> Agreed.
> 
> > 
> > >   
> > > > >     
> > > > > > 
> > > > > > With this patchset:
> > > > > > 
> > > > > > - The media_device which again contains the media_devnode is allocated
> > > > > >   dynamically. The lifetime of the media device --- and the media graph
> > > > > >   objects it contains --- is bound to device nodes that are bound to the
> > > > > >   media device (video and sub-device nodes) as well as open file handles.    
> > > > > 
> > > > > No. Data structures with cdev embedded into them have their lifetime
> > > > > controlled by the driver's core, and are destroyed only when there's
> > > > > no pending fops. The current approach uses device's core dev.release()    
> > > > 
> > > > Fair enough; that part is indeed handled towards the user space as far as I
> > > > can tell. However that's still not enough: the media graph contains the
> > > > graph objects, and the media device that holds the graph, must outlive the
> > > > graph objects themselves.  
> > 
> > I meant to say that the media device, media graph and media graph objects
> > must stay around as long as they may be accessed from the user space. For
> > instance, the user may have a file handle opened from a video device, and the
> > media graph may be accessed through that file handle on media controller
> > enabled drivers. That's just one example.
> > 
> > This is what happens if you stop streaming in a pipeline after unbinding the
> > driver implementing the media device (same log as above):
> > 
> > <URL:http://www.retiisi.org.uk/v4l2/tmp/media-ref-dmesg2.txt>
> 
> As I said, if this is a requirement, you could increase kobject's 
> reference. If not, you could just stop streaming when the media device
> has gone.
> 
> > 
> > > 
> > > Sorry, didn't follow you here. What's the sense of not freeing the media
> > > graph before destroying the struct device associated with /dev/media0? 
> > > In other words, what should outlive after chardev's data is freed?
> > > 
> > > Please notice that the driver's core kobject kref ensures that the device
> > > release code is called only after all file descriptors are closed, and
> > > no other syscall would affect the cdev.
> > >   
> > > > Also removing entities doesn't really work currently: touching an entity, a
> > > > link or any kind of a graph object is not guaranteed to work unless you hold
> > > > the media graph lock. And that's simply unfeasible.  
> > > 
> > > Sorry, again, didn't follow you here. The current strategy for adding
> > > and removing things at the graph relies on a lock, with serializes access
> > > to the graph, in order to avoid races if someone is trying to navigate on
> > > the graph while an object is being inserted or removed.  
> > 
> > The graph mutex is taken during graph walk but nothing guarantees that, say,
> > an entity that was obtained during the graph walk will stay around once the
> > graph mutex is released.
> > 
> > An alternative would be to add refcounts to entities. That'd allow removing
> > graph objects safely during the media device lifetime. The streaming would
> > certainly need to be stopped first though.
> 
> My first MC patch series added refcounts to all graph objects[1] ;)
> 
> [1] https://patchwork.linuxtv.org/patch/30766/
> 
> My original idea were to increment entities kref when links were
> created. This way, it would be easier to cleanup stuff, as they
> could be destroyed in any order, specially with dynamic entity
> creation/removal. Also, graph traversal could increment link's 
> krefs to avoid them to be destroyed while navigating on them,
> without needing to keep media lock hold for a long time.
> 
> I removed it on the second version because Laurent was unable to see
> any usage for that, but, IMHO, if properly implemented, it would
> help to support dynamic entities removal/insertion.

The media graph lock will get / is getting more and more problematic over
time, but for now, entity kref could be just enough to support this. Let's
see, anyway this is out of the scope right now IMO.

> 
> So, I don't mind if someone would send a patch adding it again.
> 
> > > It could be converted into a lockless approach (for example, using RCU),
> > > but this is a separate issue.  
> > 
> > V4L2 sub-devices, besides an entity, may contain a device node as well. The
> > data structures span multiple drivers and may span multiple sub-systems
> > (think of ALSA) as well. The media entity is embedded in a sub-device data
> > structure allocated by drivers. Drivers, also other drivers that walk the
> > media graph, do make use of this knowledge to obtain sub-devices and access
> > controls in them.
> 
> Well, a kref-based approach would avoid locks most of the time.
> Perhaps it could be combined with RCS.
> 
> > 
> > > 
> > > The removal code needs to use whatever lock (or lockless) schema we
> > > use to serialize the access to the graph.
> > >   
> > > > Just look at what the
> > > > drivers do with entities: they use the v4l2_subdev interface and the control
> > > > framework to access them.
> > > > 
> > > > These data structures contain struct media_entity in them, and that entity
> > > > is part of the media graph. Other drivers use entities e.g. to obtain
> > > > control values from them. References should be used to prevent releasing the
> > > > memory.  
> > > 
> > > References are used by the driver's core, using kobject_get() and
> > > kobject_put(). That warrants that dev.release() will only be called
> > > when nobody is using it anymore.  
> > 
> > Yes, but this does not reach entities. Their lifetime is not related to
> > that.
> 
> No. That's why, currently, we need to lock before adding/removing
> graph objects.
> 
> > >   
> > > > media_entity_get() and media_entity_put() do not do what you'd expect.  
> > > 
> > > Please elaborate.  
> > 
> > The functions simply get / put the module that owns the media entity. The
> > entities as such are not refcounted, and acquiring the driver's module does
> > not guarantee the entities aren't released.
> 
> Yes.
> 
> > >   
> > > > v4l2_subdev_call() should also verify that a sub-device is registered, and
> > > > make sure it will stay that way for the duration of call: the driver must be
> > > > able to expect the entity is accessible as the driver registered it.  
> > > 
> > > Yes, but I can't see how this is related to this discussion. Before
> > > unregistering struct device, you need to unbind the subdevs.
> > > 
> > > The only case I can see of calling v4l2_subdev_call() after all file
> > > descriptors are closed is if you have some kthread running. You need to 
> > > call kthread_stop() for such kthreads before freeing struct device.
> > > 
> > > You could do it at a my_devnode_release() if you need the kthread running
> > > even after closing all file descriptors, or even before that, before
> > > calling media_device_unregister().
> > >   
> > > > The same goes for the control framework.  
> > > 
> > > I don't think we have kthreads for controls. The control routines
> > > are called only when a file descriptor is opened. So, I don't see
> > > any possible issue with the control framework.  
> > 
> > This isn't about kthreads; other drivers do this as well through
> > user-initiated actions. Such as starting or stopping streaming.
> 
> As explaining before, either streamoff should happen during MC removal
> or you need to increment kobject refcount to serialize the removal
> order.
> 
> > >   
> > > > As far as I remember, we somehow assumed that just acquiring the related
> > > > kernel modules would be enough to counter this but it is not.  
> > > 
> > > Well, if not, you could use kobject_get() and kobject_put() to increment
> > > or decrement the cdev's refcount. Yet, I suspect that, if the drivers are 
> > > properly designed, you won't need to manually touch at the kref.  
> > 
> > Entities are not refcounted. You can't get a kobject as there's none to get.
> 
> Entity removal is protected via mutex.

It is, but if you get a reference to an entity, the reference is only
guaranteed to be valid as long as you hold the mutex.

> 
> > >   
> > > > 
> > > > I would prefer to postpone this however, the patchset already does enough
> > > > for a single patchset. Fixing this properly would likely require wait/wound
> > > > mutexes for individual entities.
> > > >   
> > > > > callback to release memory.
> > > > > 
> > > > > In other words, dev.release() is only called after the driver's base
> > > > > knows that the cdev is not in use anymore. So, no ioctl() or any
> > > > > other syscalls on that point.
> > > > > 
> > > > > Ok, nothing prevents some driver to do the wrong thing, keeping a
> > > > > copy of struct device and using it after free, for example storing
> > > > > it on a devm alocated memory, and printing some debug message
> > > > > after struct device is freed, but this is a driver's bug.
> > > > > 
> > > > > What really worries me on this series is that it seemed that you 
> > > > > didn't understood how the current approach works. So, you decided
> > > > > to just revert it and start from scratch. This is dangerous, as
> > > > > it could cause problems to other scenarios than yours.    
> > > > 
> > > > I'm not quite sure what do you mean.
> > > > 
> > > > It may well be that the patchset will require changes but that's precisely
> > > > the reason why patches are reviewed before merging.  
> > > 
> > > From your comments and from your code, you didn't seem to realize that
> > > the current approach relies at the struct device refcount. See above.  
> > 
> > That refcount is only for struct media_devnode. It's simply not enough, as
> > I've elaborated:
> > 
> > - No serialisation between IOCTL and releasing media device memory.
> > 
> > 	- This causes that once the IOCTL call has begun, media device may
> > 	  be released, and this released memory can be accessed by the IOCTL
> > 	  handler.
> > 
> > - Drivers and frameworks that access the media device through other device
> >   nodes such as V4L2 devices will also access released memory.
> > 
> > There could be others.
> 
> See above.
> 
> 
> > 
> > >   
> > > > >     
> > > > > > - Care is taken that the unregistration process and releasing memory happens
> > > > > >   in the right order. This was not always the case previously.    
> > > > > 
> > > > > Freeing memory for struct media_devnode, struct device and struct cdev 
> > > > > is currently handled by the driver's core, when it known to be safe,
> > > > > and using the same logic that other subsystems do.    
> > > > 
> > > > That's simply not the case. Other sub-systems do not have graphs managed by
> > > > multiple device drivers for multiple physical devices that expose device
> > > > nodes through which all of those devices can be accessed. The problem domain
> > > > is far more complex than if you had a single physical device for which a
> > > > driver would expose a device node or two to the user space.  
> > > 
> > > No. The current approach uses the struct device associated with /dev/media0,
> > > created via cdev, to provide a refcount for the data associated with the
> > > character device.
> > > 
> > > The struct device kobject refcount ensures that everything associated
> > > with it will only be freed after the refcount goes to zero.
> > > 
> > > As I said before, if are there any cases where the refcount is going
> > > early to zero, it is just a matter of adding a few kobject_get() and
> > > kobject_put() to ensure that this won't happen early, if the driver is
> > > so broken that it is unable to do the right refcount.  
> > 
> > That's correct, but it only applies to struct media_devnode. Nothing else.
> > Please see above.
> 
> Well, don't remove entities before stop using them.
> 
> > > > > We might do it different, but we need a strong reason to do it, as
> > > > > going away from the usual practice is dangerous.    
> > > > 
> > > > I think we already did that when we merged the original Media controller and
> > > > V4L2 sub-device patches...
> > > >   
> > > > >     
> > > > > > - The driver remains responsible for the memory of the video and sub-device
> > > > > >   nodes. However, now the Media controller provides a convenient callback to
> > > > > >   the driver to release any memory resources when the time has come to do
> > > > > >   so. This takes place just before the media device memory is released.    
> > > > > 
> > > > > Drivers could use devnode->dev.release for that. Of course, if they
> > > > > override it, they should be calling media_devnode_release() on their
> > > > > internal release functions.    
> > > > 
> > > > That'd be really hackish. The drivers currently don't deal with
> > > > media_devnode directly now and I don't think they should be obliged to.  
> > > 
> > > I'm not against adding a callback instead. However, that makes it lose
> > > flexibility, as the callback will either be called before of after
> > > freeing struct device.
> > > 
> > > By overriding the dev.release callback, we have a finer control.
> > > 
> > > If you don't see any case where we'll be freeing data after freeing
> > > struct device, then a callback would work.
> > >   
> > > > >     
> > > > > > - Drivers that do not strictly need to be removable require no changes. The
> > > > > >   benefits of this set become tangible for any driver by changing how the
> > > > > >   driver allocates memory for the data structures. Ideally at least
> > > > > >   drivers for hot-removable devices should be converted.    
> > > > > 
> > > > > Drivers should allow device removal and/or driver removal. If you're
> > > > > doing any change here, you need to touch *all* drivers to use the new 
> > > > > way.    
> > > > 
> > > > Let's first agree on what needs to be fixed and how, and then think about
> > > > converting the drivers. Buggy code has a tendency to continue to be buggy
> > > > unless it is fixed (or replaced).  
> > > 
> > > True, but as I said, this series create buggy code when it ignored what
> > > was fixed already. Also, a patch series to be considered ready for
> > > upstream need to do the needed changes on all drivers it affects.
> > >   
> > > > > > In order to make the current drivers to behave well it is necessary to make
> > > > > > changes to how memory is allocated in the drivers. If you look at the sample
> > > > > > patches that are part of the set for the omap3isp driver, you'll find that
> > > > > > around 95% of the changes are related to removing the user of devm_() family
> > > > > > of functions instead of Media controller API changes. In this regard, the
> > > > > > approach taken here requires very little if any additional overhead.    
> > > > > 
> > > > > Well, send the patches that do the 95% of the changes first e. g. devm_()
> > > > > removal, and check if you aren't using any dev_foo() printk after
> > > > > unregister, and send such patch series, without RFC. Then test what's
> > > > > still broken, if any and let's discuss with your results, in a way
> > > > > that we can all reproduce the issues you may be facing on other drivers
> > > > > that don't use devm*().    
> > > > 
> > > > As I said, there's currently no way to properly release these resources as
> > > > the driver won't receive a callback from media device release.  
> > > 
> > > If you're so convinced that it is needed and you won't be overriding
> > > media device's struct device release callback, just add it. It should
> > > be a 3 lines patch.  
> > 
> > Just the callback isn't enough. You need to get a reference to the kobject
> > when the graph components may be accessed.
> 
> Yes. Or protect it with a mutex.
> 
> > Should we add reference counts to entities, we could add functions to get
> > references to entities, and make the media device their parent. That'd be a
> > largish change but it might not affect that many drivers after all.
> 
> Adding krefs to graph objects can be handled inside the core, except for
> the drivers that implement their own graph traversal functions.

I think at least the omap3isp does. That's one reason to convert to what the
framework provides. I can check at some point if that'd be feasible.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
