Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:56994 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755007AbcLOOFE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 09:05:04 -0500
Subject: Re: [RFC v3 00/21] Make use of kref in media device, grab references
 as needed
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
References: <20161109154608.1e578f9e@vento.lan>
 <20161213102447.60990b1c@vento.lan>
 <20161215113041.GE16630@valkosipuli.retiisi.org.uk>
 <7529355.zfqFdROYdM@avalon>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <896ef36c-435e-6899-5ae8-533da7731ec1@xs4all.nl>
Date: Thu, 15 Dec 2016 15:03:36 +0100
MIME-Version: 1.0
In-Reply-To: <7529355.zfqFdROYdM@avalon>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15/12/16 13:56, Laurent Pinchart wrote:
> Hi Sakari,
>
> On Thursday 15 Dec 2016 13:30:41 Sakari Ailus wrote:
>> On Tue, Dec 13, 2016 at 10:24:47AM -0200, Mauro Carvalho Chehab wrote:
>>> Em Tue, 13 Dec 2016 12:53:05 +0200 Sakari Ailus escreveu:
>>>> On Tue, Nov 29, 2016 at 09:13:05AM -0200, Mauro Carvalho Chehab wrote:
>>>>> Hi Sakari,
>>>>>
>>>>> I answered you point to point below, but I suspect that you missed how
>>>>> the current approach works. So, I decided to write a quick summary
>>>>> here.
>>>>>
>>>>> The character devices /dev/media? are created via cdev, with relies on
>>>>> a kobject per device, with has an embedded struct kref inside.
>>>>>
>>>>> Also, each kobj at /dev/media0, /dev/media1, ... is associated with a
>>>>> struct device, when the code does:
>>>>>   devnode->cdev.kobj.parent = &devnode->dev.kobj;
>>>>>
>>>>> before calling cdev_add().
>>>>>
>>>>> The current lifetime management is actually based on cdev's kobject's
>>>>> refcount, provided by its embedded kref.
>>>>>
>>>>> The kref warrants that any data associated with /dev/media0 won't be
>>>>> freed if there are any pending system call. In other words, when
>>>>> cdev_del() is called, it will remove /dev/media0 from the filesystem,
>>>>> and will call kobject_put().
>>>>>
>>>>> If the refcount is zero, it will call devnode->dev.release(). If the
>>>>> kobject refcount is not zero, the data won't be freed.
>>>>>
>>>>> So, in the best case scenario, there's no opened file descriptors
>>>>> by the time media device node is unregistered. So, it will free
>>>>> everything.
>>>>>
>>>>> In the worse case scenario, e. g. when the driver is removed or
>>>>> unbind while /dev/media0 has some opened file descriptor(s),
>>>>> the cdev logic will do the proper lifetime management.
>>>>>
>>>>> On such case, /dev/media0 disappears from the file system, so another
>>>>> open is not possible anymore. The data structures will remain
>>>>> allocated until all associated file descriptors are not closed.
>>>>>
>>>>> When all file descriptors are closed, the data will be freed.
>>>>>
>>>>> On that time, it will call an optional dev.release() callback,
>>>>> responsible to free any other data struct that the driver allocated.
>>>>
>>>> The patchset does not change this. It's not a question of the
>>>> media_devnode struct either. That's not an issue.
>>>>
>>>> The issue is rather what else can be accessed through the media device
>>>> and other interfaces. As IOCTLs are not serialised with device removal
>>>> (which now releases much of the data structures)
>>>
>>> Huh? ioctls are serialized with struct device removal. The Driver core
>>> warrants that.
>>
>> How?
>>
>> As far as I can tell, there's nothing in the way of an IOCTL being in
>> progress on a character device which is registered by the driver for a
>> hardware device which is being removed.
>>
>> vfs_ioctl() directly calls the unlocked_ioctl() file operation which is, in
>> case of MC, media_ioctl() in media-devnode.c. No mutexes (or other locks)
>> are taken during that path, which I believe is by design.

chrdev_open in fs/char_dev.c increases the refcount on open() and decreases it
on release(). Thus ensuring that the cdev can never be removed while in an
ioctl.

>>
>>>> there's a high chance of accessing
>>>> released memory (or mutexes that have been already destroyed). An
>>>> example of that is here, stopping a running pipeline after unbinding
>>>> the device. What happens there is that the media device is released
>>>> whilst it's in use through the video device.
>>>>
>>>> <URL:http://www.retiisi.org.uk/v4l2/tmp/media-ref-dmesg2.txt>
>>>
>>> It is not clear from the logs what the driver tried to do, but
>>> that sounds like a driver's bug, with was not prepared to properly
>>> handle unbinds.
>>>
>>> The problem here is that isp_video_release() is called by V4L2
>>> release logic, and not by the MC one:
>>>
>>> static const struct v4l2_file_operations isp_video_fops = {
>>>       .owner          = THIS_MODULE,
>>>       .open           = isp_video_open,
>>>       .release        = isp_video_release,
>>>       .poll           = vb2_fop_poll,
>>>       .unlocked_ioctl = video_ioctl2,
>>>       .mmap           = vb2_fop_mmap,
>>> };
>>>
>>> It seems that the driver's logic allows it to be called before or
>>> after destroying the MC.
>>>
>>> Assuming that, if the OMAP3 driver is not used it works,
>>> it means that, if the isp_video_release() is called
>>> first, no errors will happen, but if MC is destroyed before
>>> V4L2 call to its .release() callback, as there's no logic at the
>>> driver that would detect it, isp_video_release() will be calling
>>> isp_video_streamoff(), with depends on the MC to work.
>>>
>>> On a first glance, I can see two ways of fixing it:
>>>
>>> 1) to increment devnode's device kobject refcount at OMAP3 .probe(),
>>> decrementing it only at isp_video_release(). That will ensure that
>>> MC will only be removed after V4L2 removal.
>
> As soon as you have to dig deep in a structure to find a reference counter and
> increment it, bypassing all the API layers, you can be entirely sure that the
> solution is wrong.

Indeed.

>
>>> 2) to call isp_video_streamoff() before removing the MC stuff, e. g.
>>> inside the MC .release() callback.
>>
>> This is a fair suggestion, indeed. Let me see what could be done there.
>> Albeit this is just *one* of the existing issues. It will not address all
>> problems fixed by the patchset.
>
> We need to stop the hardware at .remove() time. That should not be linked to a
> videodev, v4l2_device or media_device .release() callback. When the .remove()
> callback returns the driver is not allowed to touch the hardware anymore. In
> particular, power domains might clocks or power supplies, leading to invalid
> access faults if we try to access hardware registers.

Correct.

>
> USB devices get help from the USB core that cancels all USB operations in
> progress when they're disconnected. Platform devices don't have it as easy,
> and need to implement everything themselves. We thus need to stop the
> hardware, but I'm not sure it makes sense to fake a VIDIOC_STREAMOFF ioctl at
> .remove() time.

Please don't. This shouldn't be done automatically.

 > That could introduce other races between .remove() and the
> userspace API. A better solution is to make sure the objects that are needed
> at .release() time of the device node are all reference-counted and only
> released when the last reference goes away.
>
> There's plenty of way to try and work around the problem in drivers, some more
> racy than others, but if we require changes to all platform drivers to fix
> this we need to ensure that we get it right, not as half-baked hacks spread
> around the whole subsystem.

Why on earth do we want this for the omap3 driver? It is not a hot-pluggable
device and I see no reason whatsoever to start modifying platform drivers just
because you can do an unbind. I know there are real hot-pluggable devices, and
getting this right for those is of course important.

If the omap3 is used as a testbed, then that's fine by me, but even then I
probably wouldn't want the omap3 code that makes this possible in the kernel.
It's just additional code for no purpose.

>>> That could be done by overwriting the dev.release() callback at
>>> omap3 driver, as I discussed on my past e-mails, and flagging the
>>> driver that it should not accept streamon anymore, as the hardware
>>> is being disconnecting.
>>
>> A mutex will be needed to serialise the this with starting streaming.
>>
>>> Btw, that explains a lot why Shuah can't reproduce the stuff you're
>>> complaining on her USB hardware.
>>>
>>> The USB subsystem has a a .disconnect() callback that notifies
>>> the drivers that a device was unbound (likely physically removed).
>>> The way USB media drivers handle it is by returning -ENODEV to any
>>> V4L2 call that would try to touch at the hardware after unbound.
>

In my view the main problem is that the media core is bound to a struct
device set by the driver that creates the MC. But since the MC gives an
overview of lots of other (sub)devices the refcount of the media device
should be increased for any (sub)device that adds itself to the MC and
decreased for any (sub)device that is removed. Only when the very last
user goes away can the MC memory be released.

The memory/refcounting associated with device nodes is unrelated to this:
once a devnode is unregistered it will be removed in /dev, and once the
last open fh closes any memory associated with the devnode can be released.
That will also decrease the refcount to its parent device.

This also means that it is a bad idea to embed devnodes in a larger struct.
They should be allocated and freed when the devnode is unregistered and
the last open filehandle is closed.

Then the parent's device refcount is decreased, and that may now call its
release callback if the refcount reaches 0.

For the media controller's device: any other device driver that needs access
to it needs to increase that device's refcount, and only when those devices
are released will they decrease the MC device's refcount.

And when that refcount goes to 0 can we finally free everything.

With regards to the opposition to reverting those initial patches, I'm
siding with Greg KH. Just revert the bloody patches. It worked most of the
time before those patches, so reverting really won't cause bisect problems.

Just revert and build up things as they should.

Note that v4l2-dev.c doesn't do things correctly (it doesn't set the cdev
parent pointer for example) and many drivers (including omap3isp) embed
video_device, which is wrong and can lead to complications.

I'm to blame for the embedding since I thought that was a good idea at one
time. I now realized that it isn't. Sorry about that...

And because the cdev of the video_device doesn't know about the parent
device it is (I think) possible that the parent device is released before
the cdev is released. Which can result in major problems.

Regards,

	Hans
