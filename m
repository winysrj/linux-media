Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47540 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab3IEWdx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Sep 2013 18:33:53 -0400
Received: by mail-ee0-f46.google.com with SMTP id c13so780037eek.5
        for <linux-media@vger.kernel.org>; Thu, 05 Sep 2013 15:33:52 -0700 (PDT)
Message-ID: <522906CD.1000006@gmail.com>
Date: Fri, 06 Sep 2013 00:33:49 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] V4L: Drop meaningless video_is_registered() call in v4l2_open()
References: <1375446449-27066-1-git-send-email-s.nawrocki@samsung.com> <51FBAD74.6060603@xs4all.nl> <52027AB7.5080006@samsung.com> <520288C1.7040207@xs4all.nl>
In-Reply-To: <520288C1.7040207@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Sorry for putting this on a back burner for a while.

On 08/07/2013 07:49 PM, Hans Verkuil wrote:
> On 08/07/2013 06:49 PM, Sylwester Nawrocki wrote:
>> Hi Hans,
>>
>> On 08/02/2013 03:00 PM, Hans Verkuil wrote:
>>> Hi Sylwester,
>>>
>>> The patch is good, but I have some issues with the commit message itself.
>>
>> Thanks a lot for the detailed explanation, I just wrote this a bit
>> longish changelog to possibly get some feedback and to better understand
>> what is exactly going on. Currently the v4l2-core looks like a racing
>> disaster to me.
>>
>>> On 08/02/2013 02:27 PM, Sylwester Nawrocki wrote:
>>>> As it currently stands this code doesn't protect against any races
>>>> between video device open() and its unregistration. Races could be
>>>> avoided by doing the video_is_registered() check protected by the
>>>> core mutex, while the video device unregistration is also done with
>>>> this mutex held.
>>>
>>> The video_unregister_device() is called completely asynchronously,
>>> particularly in the case of usb drivers. So it was never the goal of
>>> the video_is_registered() to be fool proof, since that isn't possible,
>>> nor is that necessary.
>>>
>>> The goal was that the v4l2 core would use it for the various file
>>> operations and ioctls as a quick check whether the device was unregistered
>>> and to return the correct error. This prevents drivers from having to do
>>> the same thing.
>>
>> OK, I think I just myself used this video_is_registered() flag for some
>> more stuff, by surrounding it with mutex_lock/mutex_unlock and putting
>> more stuff in between, like media_entity_cleanup().
>
> You can't do that, because there are most likely still filehandles open
> or even ioctls being executed. Cleanup happens in the release function(s)
> when the kref goes to 0.

Yeah, a bit late, but I'm finally well aware of that.

>> And this probably led
>> me astray for a while, thinking that video_is_registered() was intended
>> to be used synchronously.
>> For example see fimc_lite_subdev_unregistered() in drivers/media/platform/
>> exynos4-is/fimc-lite.c.
>>
>> But as you said video_is_registered() is fully asynchronous.
>>
>> Actually I'm trying to fix a nasty race between deferred driver probing
>> and video device open(). The problem is that video open() callback can
>> be called after driver remove() callback was invoked.
>
> How is that possible? The video_device_register must be the last thing in
> the probe function. If it succeeds, then the probe must succeed as well.
>
> Note that I now realize that this might fail in the case of multiple device
> nodes being registered. We never had problems with that in the past, but in
> theory you can the race condition you mention in that scenario. The correct
> approach here would probably be to always return 0 in probe() if only some
> of the video_device_register calls fail.
>
> Anyway, assuming that only one device node is created, then I can't see how
> you can get a race condition here. Any open() call will increase the module's
> refcount, making it impossible to unload.

The main issue is that in the exynos4-is driver there are multiple platform
devices (these represent IP blocks that are scattered across various Exynos
SoC revisions). Drivers of this platform devices create subdevs and video
nodes are registered in subdev's .registered() callback. This allows the
drivers to be more modular and self contained. But also during video device
registration proper struct v4l2_device (and through this struct 
media_device)
can be passed so the video nodes are attached to the common media driver.

In probe() of the media driver all subdevs are registered and this triggers
video nodes creation. The media device first registers all platform devices.
Subdevs are created and all video nodes. After that are being registered
sensor subdevs and media links are created. Then all subdev devnodes are
created in a single call. Note this single call is a bit contrary to the
v4l2-sync API concepts.

So there is lots of things that may fail after first video node is 
registered,
and on which open() may be called immediately.

> As far as I can tell, once you call rmmod it should no longer be possible to
> open() an device node whose struct file_operations owner is that module (i.e.
> the owner field of the file_operations struct points to that module). Looking
> at the way fs/char_dev is implemented, that seems to be correctly handled by
> the kernel core.

Yes, that's a good news. There is only still the issue with the "unbind" 
sysfs
attribute. I couldn't see any similar checks done around code 
implementing it.

>> This issue is actually not only related to deferred probing. It can be
>> also triggered by driver module removal or through driver's sysfs "unbind"
>> attribute.
>>
>> Let's assume following scenario:
>>
>> - a driver module is loaded
>> - driver probe is called, it registers video device,
>> - udev opens /dev/video
>> - after mutex_unlock(&videodev_lock); call in v4l2_open() in v4l2-core/
>>    v4l2-dev.c something fails in probe()
>
> And that shouldn't happen. That's the crucial bit: under which scenario does
> this happen for you? If there is a control path where you do create a working
> device node, but the probe fails, then that will indeed cause all sorts of
> problems. But it shouldn't get in that situation (except I think in the case
> of multiple device nodes, which is something I need to think about).

Yes, I'm dealing with multiple device nodes created from within media 
driver's
probe(). As described above, there is quite a few things that could 
fail, even
single sub-driver created multiple nodes for same IP block (capture, 
mem-to-mem).

>> and it unwinds, probe callback
>>    exits and the driver code code calls dev_set_drvdata(dev, NULL); as
>>    shown below.
>>
>> static int really_probe(struct device *dev, struct device_driver *drv)
>> {
>> 	...
>> 	pr_debug("bus: '%s': %s: probing driver %s with device %s\n",
>> 		 drv->bus->name, __func__, drv->name, dev_name(dev));
>> 	...
>> 	if (dev->bus->probe) {
>> 		ret = dev->bus->probe(dev);
>> 		if (ret)
>> 			goto probe_failed;
>> 	} else if (drv->probe) {
>> 		ret = drv->probe(dev);
>> 		if (ret)
>> 			goto probe_failed;
>> 	}
>> 	...
>> 	pr_debug("bus: '%s': %s: bound device %s to driver %s\n",
>> 		 drv->bus->name, __func__, dev_name(dev), drv->name);
>> 	goto done;
>>
>> probe_failed:
>> 	devres_release_all(dev);
>> 	driver_sysfs_remove(dev);
>> 	dev->driver = NULL;
>> 	dev_set_drvdata(dev, NULL);
>>
>> 	...
>> 	ret = 0;
>> done:
>> 	...
>> 	return ret;
>> }
>>
>> Now we get to
>>
>>   	ret = vdev->fops->open(filp);
>>
>> in v4l2_open(). This calls some driver's callback, e.g. something
>> like:
>>
>> static int fimc_lite_open(struct file *file)
>> {
>> 	struct fimc_lite *fimc = video_drvdata(file);
>> 	struct media_entity *me =&fimc->ve.vdev.entity;
>> 	int ret;
>>
>> 	mutex_lock(&fimc->lock);
>> 	if (!video_is_registered(&fimc->ve.vdev)) {
>> 		ret = -ENODEV;
>> 		goto unlock;
>> 	}
>>
>> 	...
>>
>> 	/* Mark video pipeline ending at this video node as in use. */
>> 	if (ret == 0)
>> 		me->use_count++;
>> 	...
>> unlock:
>> 	mutex_unlock(&fimc->lock);
>> 	return ret;
>> }
>>
>> Now what will video_drvdata(file); return ?
>>
>> static inline void *video_drvdata(struct file *file)
>> {
>> 	return video_get_drvdata(video_devdata(file));
>> }
>>
>> static inline void *video_get_drvdata(struct video_device *vdev)
>> {
>> 	return dev_get_drvdata(&vdev->dev);
>> }
>>
>> Yes, so that will be just NULL o_O, due to the dev_set_drvdata(dev, NULL);
>> in really_probe(). drvdata is cleared similarly in __device_release_driver(),
>> right after calling driver's remove handler.
>>
>> Another issue I have is that, e.g. driver/media/platform/exynos4-is/fimc-lite*
>> driver has empty video dev release() callback. It should be implemented
>> in the driver to kfree the whole driver's private data structure where
>> struct video_device is embedded in (struct fimc_lite). But that freeing
>> really needs to be synchronized with driver's remove() call, since there
>> is e.g. freed interrupt which accesses the driver's private data. I can't
>> use kref from struct v4l2_device as that belongs to a different driver.
>> A driver's custom reference counting comes to mind, where vdev->release()
>> and drv->remove() would be decrementing the reference counter. But that
>> seems ugly as hell :/ And it predates devm_*.
>>
>> This is all getting a bit depressing :/ Deferred probing and the
>> asynchronous subdev handling just made those issues more visible, i.e.
>> not very good design of some parts of the v4l2-core.
>
> It's just not clear to me how exactly things go wrong for you. Ping me on irc
> tomorrow and we can discuss it further. I have reworked refcounting in the
> past (at the time it was *really* bad), so perhaps we need to rework it again,
> particularly with video nodes associated with subdevices in the mix, something
> that didn't exist at the time.

Thanks, and sorry for holding on with that for too long.

The main issue as I see it is that we need to track both driver remove() 
and
struct device .release() calls and free resources only when last of them
executes. Data structures which are referenced in fops must not be freed in
remove() and we cannot use dev_get_drvdata() in fops, e.g. not protected 
with
device_lock().

--
Regards,
Sylwester
