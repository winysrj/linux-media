Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:38196
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1757013AbcLORLK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 12:11:10 -0500
Subject: Re: [RFC v3 00/21] Make use of kref in media device, grab references
 as needed
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
References: <20161109154608.1e578f9e@vento.lan>
 <20161213102447.60990b1c@vento.lan>
 <20161215113041.GE16630@valkosipuli.retiisi.org.uk>
 <7529355.zfqFdROYdM@avalon> <896ef36c-435e-6899-5ae8-533da7731ec1@xs4all.nl>
 <fa996ec5-0650-9774-7baf-5eaca60d76c7@osg.samsung.com>
 <47bf7ca7-2375-3dfa-775c-a56d6bd9dabd@xs4all.nl>
 <ea29010f-ffdc-f10f-8b4f-fb1337320863@osg.samsung.com>
 <2f5a7ca0-70d1-c6a9-9966-2a169a62e405@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <b83be9ed-5ce3-3667-08c8-2b4d4cd047a0@osg.samsung.com>
Date: Thu, 15 Dec 2016 10:09:53 -0700
MIME-Version: 1.0
In-Reply-To: <2f5a7ca0-70d1-c6a9-9966-2a169a62e405@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/15/2016 09:28 AM, Hans Verkuil wrote:
> On 15/12/16 17:06, Shuah Khan wrote:
>> On 12/15/2016 08:26 AM, Hans Verkuil wrote:
>>> On 15/12/16 15:45, Shuah Khan wrote:
>>>> On 12/15/2016 07:03 AM, Hans Verkuil wrote:
>>>>> On 15/12/16 13:56, Laurent Pinchart wrote:
>>>>>> Hi Sakari,
>>>>>>
>>>>>> On Thursday 15 Dec 2016 13:30:41 Sakari Ailus wrote:
>>>>>>> On Tue, Dec 13, 2016 at 10:24:47AM -0200, Mauro Carvalho Chehab wrote:
>>>>>>>> Em Tue, 13 Dec 2016 12:53:05 +0200 Sakari Ailus escreveu:
>>>>>>>>> On Tue, Nov 29, 2016 at 09:13:05AM -0200, Mauro Carvalho Chehab wrote:
>>>>>>>>>> Hi Sakari,
>>>>>>>>>>
>>>>>>>>>> I answered you point to point below, but I suspect that you missed how
>>>>>>>>>> the current approach works. So, I decided to write a quick summary
>>>>>>>>>> here.
>>>>>>>>>>
>>>>>>>>>> The character devices /dev/media? are created via cdev, with relies on
>>>>>>>>>> a kobject per device, with has an embedded struct kref inside.
>>>>>>>>>>
>>>>>>>>>> Also, each kobj at /dev/media0, /dev/media1, ... is associated with a
>>>>>>>>>> struct device, when the code does:
>>>>>>>>>>   devnode->cdev.kobj.parent = &devnode->dev.kobj;
>>>>>>>>>>
>>>>>>>>>> before calling cdev_add().
>>>>>>>>>>
>>>>>>>>>> The current lifetime management is actually based on cdev's kobject's
>>>>>>>>>> refcount, provided by its embedded kref.
>>>>>>>>>>
>>>>>>>>>> The kref warrants that any data associated with /dev/media0 won't be
>>>>>>>>>> freed if there are any pending system call. In other words, when
>>>>>>>>>> cdev_del() is called, it will remove /dev/media0 from the filesystem,
>>>>>>>>>> and will call kobject_put().
>>>>>>>>>>
>>>>>>>>>> If the refcount is zero, it will call devnode->dev.release(). If the
>>>>>>>>>> kobject refcount is not zero, the data won't be freed.
>>>>>>>>>>
>>>>>>>>>> So, in the best case scenario, there's no opened file descriptors
>>>>>>>>>> by the time media device node is unregistered. So, it will free
>>>>>>>>>> everything.
>>>>>>>>>>
>>>>>>>>>> In the worse case scenario, e. g. when the driver is removed or
>>>>>>>>>> unbind while /dev/media0 has some opened file descriptor(s),
>>>>>>>>>> the cdev logic will do the proper lifetime management.
>>>>>>>>>>
>>>>>>>>>> On such case, /dev/media0 disappears from the file system, so another
>>>>>>>>>> open is not possible anymore. The data structures will remain
>>>>>>>>>> allocated until all associated file descriptors are not closed.
>>>>>>>>>>
>>>>>>>>>> When all file descriptors are closed, the data will be freed.
>>>>>>>>>>
>>>>>>>>>> On that time, it will call an optional dev.release() callback,
>>>>>>>>>> responsible to free any other data struct that the driver allocated.
>>>>>>>>>
>>>>>>>>> The patchset does not change this. It's not a question of the
>>>>>>>>> media_devnode struct either. That's not an issue.
>>>>>>>>>
>>>>>>>>> The issue is rather what else can be accessed through the media device
>>>>>>>>> and other interfaces. As IOCTLs are not serialised with device removal
>>>>>>>>> (which now releases much of the data structures)
>>>>>>>>
>>>>>>>> Huh? ioctls are serialized with struct device removal. The Driver core
>>>>>>>> warrants that.
>>>>>>>
>>>>>>> How?
>>>>>>>
>>>>>>> As far as I can tell, there's nothing in the way of an IOCTL being in
>>>>>>> progress on a character device which is registered by the driver for a
>>>>>>> hardware device which is being removed.
>>>>>>>
>>>>>>> vfs_ioctl() directly calls the unlocked_ioctl() file operation which is, in
>>>>>>> case of MC, media_ioctl() in media-devnode.c. No mutexes (or other locks)
>>>>>>> are taken during that path, which I believe is by design.
>>>>>
>>>>> chrdev_open in fs/char_dev.c increases the refcount on open() and decreases it
>>>>> on release(). Thus ensuring that the cdev can never be removed while in an
>>>>> ioctl.
>>>>>
>>>>>>>
>>>>>>>>> there's a high chance of accessing
>>>>>>>>> released memory (or mutexes that have been already destroyed). An
>>>>>>>>> example of that is here, stopping a running pipeline after unbinding
>>>>>>>>> the device. What happens there is that the media device is released
>>>>>>>>> whilst it's in use through the video device.
>>>>>>>>>
>>>>>>>>> <URL:http://www.retiisi.org.uk/v4l2/tmp/media-ref-dmesg2.txt>
>>>>>>>>
>>>>>>>> It is not clear from the logs what the driver tried to do, but
>>>>>>>> that sounds like a driver's bug, with was not prepared to properly
>>>>>>>> handle unbinds.
>>>>>>>>
>>>>>>>> The problem here is that isp_video_release() is called by V4L2
>>>>>>>> release logic, and not by the MC one:
>>>>>>>>
>>>>>>>> static const struct v4l2_file_operations isp_video_fops = {
>>>>>>>>       .owner          = THIS_MODULE,
>>>>>>>>       .open           = isp_video_open,
>>>>>>>>       .release        = isp_video_release,
>>>>>>>>       .poll           = vb2_fop_poll,
>>>>>>>>       .unlocked_ioctl = video_ioctl2,
>>>>>>>>       .mmap           = vb2_fop_mmap,
>>>>>>>> };
>>>>>>>>
>>>>>>>> It seems that the driver's logic allows it to be called before or
>>>>>>>> after destroying the MC.
>>>>>>>>
>>>>>>>> Assuming that, if the OMAP3 driver is not used it works,
>>>>>>>> it means that, if the isp_video_release() is called
>>>>>>>> first, no errors will happen, but if MC is destroyed before
>>>>>>>> V4L2 call to its .release() callback, as there's no logic at the
>>>>>>>> driver that would detect it, isp_video_release() will be calling
>>>>>>>> isp_video_streamoff(), with depends on the MC to work.
>>>>>>>>
>>>>>>>> On a first glance, I can see two ways of fixing it:
>>>>>>>>
>>>>>>>> 1) to increment devnode's device kobject refcount at OMAP3 .probe(),
>>>>>>>> decrementing it only at isp_video_release(). That will ensure that
>>>>>>>> MC will only be removed after V4L2 removal.
>>>>>>
>>>>>> As soon as you have to dig deep in a structure to find a reference counter and
>>>>>> increment it, bypassing all the API layers, you can be entirely sure that the
>>>>>> solution is wrong.
>>>>>
>>>>> Indeed.
>>>>>
>>>>>>
>>>>>>>> 2) to call isp_video_streamoff() before removing the MC stuff, e. g.
>>>>>>>> inside the MC .release() callback.
>>>>>>>
>>>>>>> This is a fair suggestion, indeed. Let me see what could be done there.
>>>>>>> Albeit this is just *one* of the existing issues. It will not address all
>>>>>>> problems fixed by the patchset.
>>>>>>
>>>>>> We need to stop the hardware at .remove() time. That should not be linked to a
>>>>>> videodev, v4l2_device or media_device .release() callback. When the .remove()
>>>>>> callback returns the driver is not allowed to touch the hardware anymore. In
>>>>>> particular, power domains might clocks or power supplies, leading to invalid
>>>>>> access faults if we try to access hardware registers.
>>>>>
>>>>> Correct.
>>>>>
>>>>>>
>>>>>> USB devices get help from the USB core that cancels all USB operations in
>>>>>> progress when they're disconnected. Platform devices don't have it as easy,
>>>>>> and need to implement everything themselves. We thus need to stop the
>>>>>> hardware, but I'm not sure it makes sense to fake a VIDIOC_STREAMOFF ioctl at
>>>>>> .remove() time.
>>>>>
>>>>> Please don't. This shouldn't be done automatically.
>>>>>
>>>>>> That could introduce other races between .remove() and the
>>>>>> userspace API. A better solution is to make sure the objects that are needed
>>>>>> at .release() time of the device node are all reference-counted and only
>>>>>> released when the last reference goes away.
>>>>>>
>>>>>> There's plenty of way to try and work around the problem in drivers, some more
>>>>>> racy than others, but if we require changes to all platform drivers to fix
>>>>>> this we need to ensure that we get it right, not as half-baked hacks spread
>>>>>> around the whole subsystem.
>>>>>
>>>>> Why on earth do we want this for the omap3 driver? It is not a hot-pluggable
>>>>> device and I see no reason whatsoever to start modifying platform drivers just
>>>>> because you can do an unbind. I know there are real hot-pluggable devices, and
>>>>> getting this right for those is of course important.
>>>>
>>>> This was my first reaction when I saw this RFC series. None of the platform
>>>> drivers are designed to be unbound. Making core changes based on such as
>>>> driver would make the core very complex.
>>>>
>>>> We can't even reproduce the problem on other drivers.
>>>>
>>>>>
>>>>> If the omap3 is used as a testbed, then that's fine by me, but even then I
>>>>> probably wouldn't want the omap3 code that makes this possible in the kernel.
>>>>> It's just additional code for no purpose.
>>>>
>>>> I agree with Hans. Why are we using the most complex case as a reference driver
>>>> and basing that driver to make core changes which will force changes to all the
>>>> driver that use mc-core?
>>>>
>>>>>
>>>>>>>> That could be done by overwriting the dev.release() callback at
>>>>>>>> omap3 driver, as I discussed on my past e-mails, and flagging the
>>>>>>>> driver that it should not accept streamon anymore, as the hardware
>>>>>>>> is being disconnecting.
>>>>>>>
>>>>>>> A mutex will be needed to serialise the this with starting streaming.
>>>>>>>
>>>>>>>> Btw, that explains a lot why Shuah can't reproduce the stuff you're
>>>>>>>> complaining on her USB hardware.
>>>>>>>>
>>>>>>>> The USB subsystem has a a .disconnect() callback that notifies
>>>>>>>> the drivers that a device was unbound (likely physically removed).
>>>>>>>> The way USB media drivers handle it is by returning -ENODEV to any
>>>>>>>> V4L2 call that would try to touch at the hardware after unbound.
>>>>>>
>>>>>
>>>>> In my view the main problem is that the media core is bound to a struct
>>>>> device set by the driver that creates the MC. But since the MC gives an
>>>>> overview of lots of other (sub)devices the refcount of the media device
>>>>> should be increased for any (sub)device that adds itself to the MC and
>>>>> decreased for any (sub)device that is removed. Only when the very last
>>>>> user goes away can the MC memory be released.
>>>>
>>>> Correct. Media Device Allocator API work I did allows creating media device
>>>> on parent USB device to allow media sound driver share the media device. It
>>>> does ref-counting on media device and media device is unregistered only when
>>>> the last driver unregisters it.
>>>>
>>>> There is another aspect to explore regarding media device and the graph.
>>>>
>>>> Should all the entities stick around until all references to media
>>>> device are gone? If an application has /dev/media open, does that
>>>> mean all entities should not be free'd until this app. exits? What
>>>> should happen if an app. is streaming? Should the graph stay intact
>>>> until the app. exits?
>>>
>>> Yes, everything must stay around until the last user has disappeared.
>>>
>>> In general unplugs can happen at any time. So applications can be in the middle
>>> of an ioctl, and removing memory during that time is just impossible.
>>>
>>> On unplug you:
>>>
>>> 1) stop any HW DMA (highly device dependent)
>>> 2) wake up any filehandles that wait for an event
>>> 3) unregister any device nodes
>>>
>>> Then just sit back and wait for refcounts to go down as filehandles are closed
>>> by the application.
>>>
>>> Note: the v4l2/media/cec/IR/whatever core is typically responsible for rejecting
>>> any ioctls/mmap/etc. once the device node has been unregistered. The only valid
>>> file operation is release().
>>>
>>>>
>>>>    If yes, this would pose problems when we have multiple drivers bound
>>>>    to the media device. When audio driver goes away for example, it should
>>>>    be allowed to delete its entities.
>>>
>>> Only if you can safely remove it from the topology data structures while
>>> being 100% certain that nobody can ever access it. I'm not sure if that is
>>> the case. Actually, looking at e.g. adv7604.c it does media_entity_cleanup(&sd->entity);
>>> in remove() which is an empty function, so there doesn't appear any attempt
>>> to safely clean up an entity (i.e. make sure no running media ioctl can
>>> access it or call ops).
>>
>> Right. media_entity_cleanup() nothing at the moment. Also if it gets called
>> after media_device_unregister_entity(), it could pose problems. I wonder if
>> we have drivers that are calling media_entity_cleanup() after unregistering
>> the entity?
>>
>>>
>>> This probably will need to be serialized with the graph_mutex lock.
>>>
>>>>
>>>> The approach current mc-core takes is that the media_device and media_devnode
>>>> stick around, but entities can be added and removed during media_device
>>>> lifetime.
>>>
>>> Seems reasonable. But the removal needs to be done carefully, and that doesn't
>>> seem to be the case now (unless adv7604.c is just buggy).
>>
>> Correct. It is possible media_device is embedded in this driver. When driver
>> that embeds is unbound, media_device goes away. I needed to make the media
>> device refcounted and sharable for audio work and that is what the Media Device
>> Allocator API does.
> 
> Basically all you need to do is to refcount the struct device in the media_device:
> call get_device(mdev->dev) when you take a reference, and put_device(mdev->dev)
> when you no longer need it. The mdev itself is freed when the mdev->dev refcount
> goes to 0.
> 
> No need to add another kref.

Right. I do have an additional kref in Media Device Allocator API that serves
a different purpose. It is used for ref-counting drivers that are sharing the
media_device so it can't be unregistered until all those drivers unregister it.
I think we discussed this when this API was reviewed.

> 
> 
>>
>> Maybe we have more cases than this audio case that requires media_device refcounted.
>> If we have to keep entities that are in use until all the references go away, we
>> have to ref-count them as well.
>>
>>>
>>>>
>>>> If an app. is still running when media_device is unregistered, media_device
>>>> isn't released until the last reference goes away and ioctls can check if
>>>> media_device is registered or not.
>>>>
>>>> We have to decide on the larger lifetime question surrounding media_device
>>>> and graph as well.
>>>
>>> I don't think there is any choice but to keep it all alive until the last
>>> reference goes away.
>>
>> If you mean "all alive" entities as well, we have to ref-count them. Because
>> drivers can unregister entities during run-time now. I am looking at the
>> use-case where, a driver that has dvb and video and what should happen when
>> dvb is unbound for example. Should dvb entities go away or should they stay
>> until all the drivers are unbound?
> 
> That depends on the architecture. If these are completely independent devices
> then you want to allow this, if possible to do this safely. But for e.g.
> subdevices that depend on a parent device the unbind should just be prohibited.
> There is no point whatsoever in allowing that.
> 
>>
>> v4l2-core registers and unregisters entities and so does dvb-core. So when a
>> driver unregisters video and dvb, these entities get deleted. So we have a
>> distributed mode of registering and unregistering entities. We also have
>> ioctls (video, dvb, and media) accessing these entities. So where do we make
>> changes to ensure entities stick around until all users exit?
>>
>> Ref-counting entities won't work if they are embedded - like in the case of
>> struct video_device which embeds the media entity. When struct video goes
>> away then entity will disappear. So we do have a complex lifetime model here
>> that we need to figure out how to fix.
> 
> That why I think the best approach would be to safely delete them from the
> MC graph: take the top-level lock (graph_mutex I think) and remove all references
> before releasing the lock.

media_device_unregister_entity() entity does that now. It also removes links.
Do you believe something is missing there. It does hold graph_mutex.

> 
> I think this will work for interface entities, but for subdev entities this
> certainly won't work. Unbinding subdevs should be blocked (just set
> suppress_bind_attrs to true in all subdev drivers). Most top-level drivers
> have pointers to subdev data, so unbinding them will just fail horribly.
> 

Yes that is an option. I did something similar for au0828 and snd_usb_audio
case, so the module that registers the media_device can't unbound until the
other driver. If au0828 registers media_device, it becomes the owner and if
it gets unbound ioctls will start to see problems.

What this means though is that drivers can't be unbound easily. But that is
a small price to pay compared to the problems we will see if a driver is
unbound when its entities are still in use. Also, unsetting bind_attrs has
to be done as well, otherwise we can never unbind any driver.

thanks,
-- Shuah



