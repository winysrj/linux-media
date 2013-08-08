Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:14299 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757778Ab3HHMgR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Aug 2013 08:36:17 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MR7001VNPNB7190@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 08 Aug 2013 13:36:15 +0100 (BST)
Message-id: <520390BD.3020201@samsung.com>
Date: Thu, 08 Aug 2013 14:36:13 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] V4L: Drop meaningless video_is_registered() call in
 v4l2_open()
References: <1375446449-27066-1-git-send-email-s.nawrocki@samsung.com>
 <51FBAD74.6060603@xs4all.nl> <52027AB7.5080006@samsung.com>
 <520288C1.7040207@xs4all.nl>
In-reply-to: <520288C1.7040207@xs4all.nl>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

As a person who debugged the problem I would like add my comments.

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
> 
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

The problem is that increasing refcount does not prevent the driver from
unbinding via sysfs unbind attribute. Drivers/core are not handling
such situation correctly. For example during v4l2 open callback
driver_data is not protected by any lock so it can disappear in the most
inconvenient time and cause system crash/hang (proven by real tests).

The patch introducing unbind attribute suggests that it could be used in
production systems ( https://lkml.org/lkml/2005/6/24/27 ) so I suppose
the situation should be better handled.

device_lock is used by unbind, so maybe it could be used also by callbacks?


Regards
Andrzej


> 
> As far as I can tell, once you call rmmod it should no longer be possible to
> open() an device node whose struct file_operations owner is that module (i.e.
> the owner field of the file_operations struct points to that module). Looking
> at the way fs/char_dev is implemented, that seems to be correctly handled by
> the kernel core.
> 
>>
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
>>   v4l2-dev.c something fails in probe()
> 
> And that shouldn't happen. That's the crucial bit: under which scenario does
> this happen for you? If there is a control path where you do create a working
> device node, but the probe fails, then that will indeed cause all sorts of
> problems. But it shouldn't get in that situation (except I think in the case
> of multiple device nodes, which is something I need to think about).
> 
>> and it unwinds, probe callback
>>   exits and the driver code code calls dev_set_drvdata(dev, NULL); as
>>   shown below.
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
>>  	ret = vdev->fops->open(filp);
>>
>> in v4l2_open(). This calls some driver's callback, e.g. something
>> like:
>>
>> static int fimc_lite_open(struct file *file)
>> {
>> 	struct fimc_lite *fimc = video_drvdata(file);
>> 	struct media_entity *me = &fimc->ve.vdev.entity;
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
> 
>>
>>>> The history of this code is that the second video_is_registered()
>>>> call has been added in commit ee6869afc922a9849979e49bb3bbcad7948
>>>> "V4L/DVB: v4l2: add core serialization lock" together with addition
>>>> of the core mutex support in fops:
>>>>
>>>>         mutex_unlock(&videodev_lock);
>>>> -       if (vdev->fops->open)
>>>> -               ret = vdev->fops->open(filp);
>>>> +       if (vdev->fops->open) {
>>>> +               if (vdev->lock)
>>>> +                       mutex_lock(vdev->lock);
>>>> +               if (video_is_registered(vdev))
>>>> +                       ret = vdev->fops->open(filp);
>>>> +               else
>>>> +                       ret = -ENODEV;
>>>> +               if (vdev->lock)
>>>> +                       mutex_unlock(vdev->lock);
>>>> +       }
>>>
>>> The history is slightly more complicated: this commit moved the video_is_registered
>>> call from before the mutex_unlock(&videodev_lock); to just before the fops->open
>>> call.
>>>
>>> Commit ca9afe6f87b569cdf8e797395381f18ae23a2905 "v4l2-dev: fix race condition"
>>> added the video_is_registered() call to where it was originally (inside the
>>> videodev_lock critical section), but it didn't bother to remove the duplicate
>>> second video_is_registered call.
>>>
>>> So that's how v4l2_open ended up with two calls to video_is_registered.
>>
>> Apologies for simplifying the history . I'll just drop it from the changelog, 
>> as it can be retrieved git. I'll try to put just concise explanation why this 
>> this video_is_registered() is not needed currently.
>>
>>>> While commit cf5337358548b813479b58478539fc20ee86556c
>>>> "[media] v4l2-dev: remove V4L2_FL_LOCK_ALL_FOPS"
>>>> removed only code touching the mutex:
>>>>
>>>>         mutex_unlock(&videodev_lock);
>>>>         if (vdev->fops->open) {
>>>> -               if (test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags) &&
>>>> -                   mutex_lock_interruptible(vdev->lock)) {
>>>> -                       ret = -ERESTARTSYS;
>>>> -                       goto err;
>>>> -               }
>>>>                 if (video_is_registered(vdev))
>>>>                         ret = vdev->fops->open(filp);
>>>>                 else
>>>>                         ret = -ENODEV;
>>>> -               if (test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags))
>>>> -                       mutex_unlock(vdev->lock);
>>>>         }
>>>>
>>>> Remove the remaining video_is_registered() call as it doesn't provide
>>>> any real protection and just adds unnecessary overhead.
>>>
>>> True.
>>>
>>>> The drivers need to perform the unregistration check themselves inside
>>>> their file operation handlers, while holding respective mutex.
>>>
>>> No, drivers do not need to do the unregistration check. Since unregistration
>>> is asynchronous it can happen at any time, so there really is no point in
>>> checking for it other than in the core. If the device is unregistered while
>>> in the middle of a file operation, then that means that any USB activity will
>>> return an error, and that any future file operations other than release() will
>>> be met by an error as well from the v4l2 core.
>>
>> Yes, so video_is_registered() seems not very useful to use in drivers.
> 
> That's true. The main use case for it is in the v4l2 core to stop ioctls and fops
> from going through to the driver and return an error instead. So drivers don't
> need to do that themselves.
> 
>> But as I've shown above it's not even used optimally in the v4l2-core.
> 
> There really isn't anything else you can do with it in my view.
> 
> Regards,
> 
> 	Hans
> 
>>
>>>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>>> ---
>>>>  drivers/media/v4l2-core/v4l2-dev.c |    8 ++------
>>>>  1 file changed, 2 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
>>>> index c8859d6..1743119 100644
>>>> --- a/drivers/media/v4l2-core/v4l2-dev.c
>>>> +++ b/drivers/media/v4l2-core/v4l2-dev.c
>>>> @@ -444,13 +444,9 @@ static int v4l2_open(struct inode *inode, struct file *filp)
>>>>  	/* and increase the device refcount */
>>>>  	video_get(vdev);
>>>>  	mutex_unlock(&videodev_lock);
>>>> -	if (vdev->fops->open) {
>>>> -		if (video_is_registered(vdev))
>>>> -			ret = vdev->fops->open(filp);
>>>> -		else
>>>> -			ret = -ENODEV;
>>>> -	}
>>>>
>>>> +	if (vdev->fops->open)
>>>> +		ret = vdev->fops->open(filp);
>>>>  	if (vdev->debug)
>>>>  		printk(KERN_DEBUG "%s: open (%d)\n",
>>>>  			video_device_node_name(vdev), ret);
>>>> --
>>>> 1.7.9.5
>>>>
>>>
>>> A long story, but the patch is good, although the commit message needs work :-)
>>>
>>> Regards,
>>>
>>> 	Hans
>>
>>
>> Regards,
>> Sylwester
>>
> 

