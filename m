Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3370 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885Ab3IKODP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Sep 2013 10:03:15 -0400
Message-ID: <523077CE.5070300@xs4all.nl>
Date: Wed, 11 Sep 2013 16:01:50 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mark Brown <broonie@kernel.org>,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: Re: [PATCH] V4L: Drop meaningless video_is_registered() call in v4l2_open()
References: <1375446449-27066-1-git-send-email-s.nawrocki@samsung.com> <51FBAD74.6060603@xs4all.nl> <52027AB7.5080006@samsung.com> <520288C1.7040207@xs4all.nl> <522906CD.1000006@gmail.com> <522D8FDF.3030006@xs4all.nl> <52306B2D.8060503@samsung.com>
In-Reply-To: <52306B2D.8060503@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On 09/11/2013 03:07 PM, Sylwester Nawrocki wrote:
> On 09/09/2013 11:07 AM, Hans Verkuil wrote:
>> On 09/06/2013 12:33 AM, Sylwester Nawrocki wrote:
>>> On 08/07/2013 07:49 PM, Hans Verkuil wrote:
>>>> On 08/07/2013 06:49 PM, Sylwester Nawrocki wrote:
>>>>> On 08/02/2013 03:00 PM, Hans Verkuil wrote:
>>>>>> Hi Sylwester,
>>>>>>
>>>>>> The patch is good, but I have some issues with the commit message itself.
>>>>>
>>>>> Thanks a lot for the detailed explanation, I just wrote this a bit
>>>>> longish changelog to possibly get some feedback and to better understand
>>>>> what is exactly going on. Currently the v4l2-core looks like a racing
>>>>> disaster to me.
>>>>>
>>>>>> On 08/02/2013 02:27 PM, Sylwester Nawrocki wrote:
>>>>>>> As it currently stands this code doesn't protect against any races
>>>>>>> between video device open() and its unregistration. Races could be
>>>>>>> avoided by doing the video_is_registered() check protected by the
>>>>>>> core mutex, while the video device unregistration is also done with
>>>>>>> this mutex held.
>>>>>>
>>>>>> The video_unregister_device() is called completely asynchronously,
>>>>>> particularly in the case of usb drivers. So it was never the goal of
>>>>>> the video_is_registered() to be fool proof, since that isn't possible,
>>>>>> nor is that necessary.
>>>>>>
>>>>>> The goal was that the v4l2 core would use it for the various file
>>>>>> operations and ioctls as a quick check whether the device was unregistered
>>>>>> and to return the correct error. This prevents drivers from having to do
>>>>>> the same thing.
>>>>>
>>>>> OK, I think I just myself used this video_is_registered() flag for some
>>>>> more stuff, by surrounding it with mutex_lock/mutex_unlock and putting
>>>>> more stuff in between, like media_entity_cleanup().
>>>>
>>>> You can't do that, because there are most likely still filehandles open
>>>> or even ioctls being executed. Cleanup happens in the release function(s)
>>>> when the kref goes to 0.
>>>
>>> Yeah, a bit late, but I'm finally well aware of that.
>>>
>>>>> And this probably led
>>>>> me astray for a while, thinking that video_is_registered() was intended
>>>>> to be used synchronously.
>>>>> For example see fimc_lite_subdev_unregistered() in drivers/media/platform/
>>>>> exynos4-is/fimc-lite.c.
>>>>>
>>>>> But as you said video_is_registered() is fully asynchronous.
>>>>>
>>>>> Actually I'm trying to fix a nasty race between deferred driver probing
>>>>> and video device open(). The problem is that video open() callback can
>>>>> be called after driver remove() callback was invoked.
>>>>
>>>> How is that possible? The video_device_register must be the last thing in
>>>> the probe function. If it succeeds, then the probe must succeed as well.
>>>>
>>>> Note that I now realize that this might fail in the case of multiple device
>>>> nodes being registered. We never had problems with that in the past, but in
>>>> theory you can the race condition you mention in that scenario. The correct
>>>> approach here would probably be to always return 0 in probe() if only some
>>>> of the video_device_register calls fail.
>>>>
>>>> Anyway, assuming that only one device node is created, then I can't see how
>>>> you can get a race condition here. Any open() call will increase the module's
>>>> refcount, making it impossible to unload.
>>>
>>> The main issue is that in the exynos4-is driver there are multiple platform
>>> devices (these represent IP blocks that are scattered across various Exynos
>>> SoC revisions). Drivers of this platform devices create subdevs and video
>>> nodes are registered in subdev's .registered() callback. This allows the
>>> drivers to be more modular and self contained. But also during video device
>>> registration proper struct v4l2_device (and through this struct 
>>> media_device)
>>> can be passed so the video nodes are attached to the common media driver.
>>>
>>> In probe() of the media driver all subdevs are registered and this triggers
>>> video nodes creation. The media device first registers all platform devices.
>>> Subdevs are created and all video nodes. After that are being registered
>>> sensor subdevs and media links are created. Then all subdev devnodes are
>>> created in a single call. Note this single call is a bit contrary to the
>>> v4l2-sync API concepts.
>>
>> It wouldn't be difficult to add a v4l2_device_register_subdev_node() function.
>> The v4l2_device_register_subdev_nodes() function predates v4l2-sync, so if
>> it needs some tweaking to make it behave better with v4l2-sync, then that's
>> no problem.
> 
> Yeah, I think it will need to be added sooner or later.
> 
>>> So there is lots of things that may fail after first video node is 
>>> registered, and on which open() may be called immediately.
>>
>> The only solution I know off-hand to handle this safely is to unregister all
>> nodes if some fail, but to return 0 in the probe function. If an open() succeeded,
>> then that will just work until the node is closed, at which point the v4l2_device
>> release() is called and you can cleanup.
> 
> Another solution would be to properly implement struct video_device::release()
> callback and in video device open() do video_is_registered() check while
> holding the driver private video device lock. Also video_unregister_device()
> would need to be called while holding the video device lock.

How would that help?

> Then some devm_* calls would need to be removed from drivers, as we wanted to
> have driver private data structure released on in video_device::release(), not
> after failed driver probe() or after remove() call.
> 
> As a side note, in some previous posts a had been confusing struct device embedded 
> in struct video_device with struct device of a physical device, e.g. associated
> with struct platform_device. As video_get_drvdata() uses the former it should be
> safe to  use this helper in open(), even without holding the driver private lock.
> 
>> What does alsa do with multiple node creation?
> 
> Not sure, maybe Mark could shed some light on that (I've added him at Cc).
> 
>>>> As far as I can tell, once you call rmmod it should no longer be possible to
>>>> open() an device node whose struct file_operations owner is that module (i.e.
>>>> the owner field of the file_operations struct points to that module). Looking
>>>> at the way fs/char_dev is implemented, that seems to be correctly handled by
>>>> the kernel core.
>>>
>>> Yes, that's a good news. There is only still the issue with the "unbind" 
>>> sysfs attribute. I couldn't see any similar checks done around code 
>>> implementing it.
>>
>> That seems to me to be a core code issue and should be solved there.
> 
> Yeah, as I noted below, it has been tried already [1].
> 
>>>>> This issue is actually not only related to deferred probing. It can be
>>>>> also triggered by driver module removal or through driver's sysfs "unbind"
>>>>> attribute.
>>>>>
>>>>> Let's assume following scenario:
>>>>>
>>>>> - a driver module is loaded
>>>>> - driver probe is called, it registers video device,
>>>>> - udev opens /dev/video
>>>>> - after mutex_unlock(&videodev_lock); call in v4l2_open() in v4l2-core/
>>>>>    v4l2-dev.c something fails in probe()
>>>>
>>>> And that shouldn't happen. That's the crucial bit: under which scenario does
>>>> this happen for you? If there is a control path where you do create a working
>>>> device node, but the probe fails, then that will indeed cause all sorts of
>>>> problems. But it shouldn't get in that situation (except I think in the case
>>>> of multiple device nodes, which is something I need to think about).
>>>
>>> Yes, I'm dealing with multiple device nodes created from within media 
>>> driver's
>>> probe(). As described above, there is quite a few things that could 
>>> fail, even
>>> single sub-driver created multiple nodes for same IP block (capture, 
>>> mem-to-mem).
>>
>> Is this 'could fail', or 'I have seen it fail'? I have never seen problems in probe()
>> with node creation. The only reason I know of why creating a node might fail is
>> being out-of-memory.
> 
> In my case it was top level driver that was triggering device node creation
> in its probe() and if, e.g. some of sub-device's driver was missing, it called,
> through subdev internal unregistered(), op video_unregister_device(), but also
> media_entity_cleanup() which seemed to be the source of trouble.

Device nodes should always be created at the very end after all other setup
actions (like loaded subdev drivers) have been done successfully. From your
description it seems that device nodes were created earlier? 

> So if we ignore the sysfs "unbind" issue the problem might not be that severe.
> Not sure if we should. Nevertheless most of drivers crash kernel currently
> when "unbind" is used on them. E.g. I could unbind unregister the system power
> management device (PMIC) driver, the regulator core warned about regulators 
> in use being removed and then cpufreq killed the system completely due to a
> dangling pointer to a regulator object.
> 
>>>>> and it unwinds, probe callback
>>>>>    exits and the driver code code calls dev_set_drvdata(dev, NULL); as
>>>>>    shown below.
>>>>>
>>>>> static int really_probe(struct device *dev, struct device_driver *drv)
>>>>> {
>>>>> 	...
>>>>> 	pr_debug("bus: '%s': %s: probing driver %s with device %s\n",
>>>>> 		 drv->bus->name, __func__, drv->name, dev_name(dev));
>>>>> 	...
>>>>> 	if (dev->bus->probe) {
>>>>> 		ret = dev->bus->probe(dev);
>>>>> 		if (ret)
>>>>> 			goto probe_failed;
>>>>> 	} else if (drv->probe) {
>>>>> 		ret = drv->probe(dev);
>>>>> 		if (ret)
>>>>> 			goto probe_failed;
>>>>> 	}
>>>>> 	...
>>>>> 	pr_debug("bus: '%s': %s: bound device %s to driver %s\n",
>>>>> 		 drv->bus->name, __func__, dev_name(dev), drv->name);
>>>>> 	goto done;
>>>>>
>>>>> probe_failed:
>>>>> 	devres_release_all(dev);
>>>>> 	driver_sysfs_remove(dev);
>>>>> 	dev->driver = NULL;
>>>>> 	dev_set_drvdata(dev, NULL);
>>>>>
>>>>> 	...
>>>>> 	ret = 0;
>>>>> done:
>>>>> 	...
>>>>> 	return ret;
>>>>> }
>>>>>
>>>>> Now we get to
>>>>>
>>>>>   	ret = vdev->fops->open(filp);
>>>>>
>>>>> in v4l2_open(). This calls some driver's callback, e.g. something
>>>>> like:
>>>>>
>>>>> static int fimc_lite_open(struct file *file)
>>>>> {
>>>>> 	struct fimc_lite *fimc = video_drvdata(file);
>>>>> 	struct media_entity *me =&fimc->ve.vdev.entity;
>>>>> 	int ret;
>>>>>
>>>>> 	mutex_lock(&fimc->lock);
>>>>> 	if (!video_is_registered(&fimc->ve.vdev)) {
>>>>> 		ret = -ENODEV;
>>>>> 		goto unlock;
>>>>> 	}
>>>>>
>>>>> 	...
>>>>>
>>>>> 	/* Mark video pipeline ending at this video node as in use. */
>>>>> 	if (ret == 0)
>>>>> 		me->use_count++;
>>>>> 	...
>>>>> unlock:
>>>>> 	mutex_unlock(&fimc->lock);
>>>>> 	return ret;
>>>>> }
>>>>>
>>>>> Now what will video_drvdata(file); return ?
>>>>>
>>>>> static inline void *video_drvdata(struct file *file)
>>>>> {
>>>>> 	return video_get_drvdata(video_devdata(file));
>>>>> }
>>>>>
>>>>> static inline void *video_get_drvdata(struct video_device *vdev)
>>>>> {
>>>>> 	return dev_get_drvdata(&vdev->dev);
>>>>> }
>>>>>
>>>>> Yes, so that will be just NULL o_O, due to the dev_set_drvdata(dev, NULL);
>>>>> in really_probe(). drvdata is cleared similarly in __device_release_driver(),
>>>>> right after calling driver's remove handler.
>>>>>
>>>>> Another issue I have is that, e.g. driver/media/platform/exynos4-is/fimc-lite*
>>>>> driver has empty video dev release() callback. It should be implemented
>>>>> in the driver to kfree the whole driver's private data structure where
>>>>> struct video_device is embedded in (struct fimc_lite). But that freeing
>>>>> really needs to be synchronized with driver's remove() call, since there
>>>>> is e.g. freed interrupt which accesses the driver's private data. I can't
>>>>> use kref from struct v4l2_device as that belongs to a different driver.
>>>>> A driver's custom reference counting comes to mind, where vdev->release()
>>>>> and drv->remove() would be decrementing the reference counter. But that
>>>>> seems ugly as hell :/ And it predates devm_*.
>>>>>
>>>>> This is all getting a bit depressing :/ Deferred probing and the
>>>>> asynchronous subdev handling just made those issues more visible, i.e.
>>>>> not very good design of some parts of the v4l2-core.
>>>>
>>>> It's just not clear to me how exactly things go wrong for you. Ping me on irc
>>>> tomorrow and we can discuss it further. I have reworked refcounting in the
>>>> past (at the time it was *really* bad), so perhaps we need to rework it again,
>>>> particularly with video nodes associated with subdevices in the mix, something
>>>> that didn't exist at the time.
>>>
>>> Thanks, and sorry for holding on with that for too long.
>>>
>>> The main issue as I see it is that we need to track both driver remove() 
>>> and
>>> struct device .release() calls and free resources only when last of them
>>> executes. Data structures which are referenced in fops must not be freed in
>>> remove() and we cannot use dev_get_drvdata() in fops, e.g. not protected 
>>> with device_lock().
>>
>> You can do all that by returning 0 if probe() was partially successful (i.e.
>> one or more, but not all, nodes were created successfully) by doing what I
>> described above. I don't see another way that doesn't introduce a race condition.
> 
> Yes, that could be a work around for the problem. However it doesn't seem right 
> to assume at the subsystem level. For example errors like EPROBE_DEFER should 
> be propagated transparently by drivers so the driver core retries probing. 
> 
> It is all easy to trigger with the sysfs unbind feature. Regarding fixing 
> it at the driver core, it seems there have been brave that tried it already 
> [1]. :) It's surprising how poorly this feature is handled by many drivers or 
> even subsystems.

I really don't think the unbind issue can be solved in drivers without improved
core support.

Regards,

	Hans
