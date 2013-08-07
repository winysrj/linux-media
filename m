Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:47340 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932282Ab3HGQuD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Aug 2013 12:50:03 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MR60051B6RBLXD0@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 07 Aug 2013 17:50:00 +0100 (BST)
Message-id: <52027AB7.5080006@samsung.com>
Date: Wed, 07 Aug 2013 18:49:59 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] V4L: Drop meaningless video_is_registered() call in
 v4l2_open()
References: <1375446449-27066-1-git-send-email-s.nawrocki@samsung.com>
 <51FBAD74.6060603@xs4all.nl>
In-reply-to: <51FBAD74.6060603@xs4all.nl>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 08/02/2013 03:00 PM, Hans Verkuil wrote:
> Hi Sylwester,
> 
> The patch is good, but I have some issues with the commit message itself.

Thanks a lot for the detailed explanation, I just wrote this a bit 
longish changelog to possibly get some feedback and to better understand 
what is exactly going on. Currently the v4l2-core looks like a racing 
disaster to me.

> On 08/02/2013 02:27 PM, Sylwester Nawrocki wrote:
>> As it currently stands this code doesn't protect against any races
>> between video device open() and its unregistration. Races could be
>> avoided by doing the video_is_registered() check protected by the
>> core mutex, while the video device unregistration is also done with
>> this mutex held.
> 
> The video_unregister_device() is called completely asynchronously,
> particularly in the case of usb drivers. So it was never the goal of
> the video_is_registered() to be fool proof, since that isn't possible,
> nor is that necessary.
> 
> The goal was that the v4l2 core would use it for the various file
> operations and ioctls as a quick check whether the device was unregistered
> and to return the correct error. This prevents drivers from having to do
> the same thing.

OK, I think I just myself used this video_is_registered() flag for some
more stuff, by surrounding it with mutex_lock/mutex_unlock and putting
more stuff in between, like media_entity_cleanup(). And this probably led
me astray for a while, thinking that video_is_registered() was intended 
to be used synchronously.
For example see fimc_lite_subdev_unregistered() in drivers/media/platform/
exynos4-is/fimc-lite.c.

But as you said video_is_registered() is fully asynchronous. 

Actually I'm trying to fix a nasty race between deferred driver probing 
and video device open(). The problem is that video open() callback can 
be called after driver remove() callback was invoked.

This issue is actually not only related to deferred probing. It can be
also triggered by driver module removal or through driver's sysfs "unbind"
attribute.

Let's assume following scenario:

- a driver module is loaded
- driver probe is called, it registers video device,
- udev opens /dev/video
- after mutex_unlock(&videodev_lock); call in v4l2_open() in v4l2-core/
  v4l2-dev.c something fails in probe() and it unwinds, probe callback
  exits and the driver code code calls dev_set_drvdata(dev, NULL); as
  shown below.

static int really_probe(struct device *dev, struct device_driver *drv)
{
	...
	pr_debug("bus: '%s': %s: probing driver %s with device %s\n",
		 drv->bus->name, __func__, drv->name, dev_name(dev));
	...
	if (dev->bus->probe) {
		ret = dev->bus->probe(dev);
		if (ret)
			goto probe_failed;
	} else if (drv->probe) {
		ret = drv->probe(dev);
		if (ret)
			goto probe_failed;
	}
	...
	pr_debug("bus: '%s': %s: bound device %s to driver %s\n",
		 drv->bus->name, __func__, dev_name(dev), drv->name);
	goto done;

probe_failed:
	devres_release_all(dev);
	driver_sysfs_remove(dev);
	dev->driver = NULL;
	dev_set_drvdata(dev, NULL);

	...
	ret = 0;
done:
	...
	return ret;
}

Now we get to 

 	ret = vdev->fops->open(filp);

in v4l2_open(). This calls some driver's callback, e.g. something
like:

static int fimc_lite_open(struct file *file)
{
	struct fimc_lite *fimc = video_drvdata(file);
	struct media_entity *me = &fimc->ve.vdev.entity;
	int ret;

	mutex_lock(&fimc->lock);
	if (!video_is_registered(&fimc->ve.vdev)) {
		ret = -ENODEV;
		goto unlock;
	}

	...

	/* Mark video pipeline ending at this video node as in use. */
	if (ret == 0)
		me->use_count++;
	...
unlock:
	mutex_unlock(&fimc->lock);
	return ret;
}

Now what will video_drvdata(file); return ?

static inline void *video_drvdata(struct file *file)
{
	return video_get_drvdata(video_devdata(file));
}

static inline void *video_get_drvdata(struct video_device *vdev)
{
	return dev_get_drvdata(&vdev->dev);
}

Yes, so that will be just NULL o_O, due to the dev_set_drvdata(dev, NULL);
in really_probe(). drvdata is cleared similarly in __device_release_driver(),
right after calling driver's remove handler.

Another issue I have is that, e.g. driver/media/platform/exynos4-is/fimc-lite*
driver has empty video dev release() callback. It should be implemented
in the driver to kfree the whole driver's private data structure where
struct video_device is embedded in (struct fimc_lite). But that freeing 
really needs to be synchronized with driver's remove() call, since there 
is e.g. freed interrupt which accesses the driver's private data. I can't 
use kref from struct v4l2_device as that belongs to a different driver. 
A driver's custom reference counting comes to mind, where vdev->release() 
and drv->remove() would be decrementing the reference counter. But that
seems ugly as hell :/ And it predates devm_*.

This is all getting a bit depressing :/ Deferred probing and the 
asynchronous subdev handling just made those issues more visible, i.e.
not very good design of some parts of the v4l2-core.

>> The history of this code is that the second video_is_registered()
>> call has been added in commit ee6869afc922a9849979e49bb3bbcad7948
>> "V4L/DVB: v4l2: add core serialization lock" together with addition
>> of the core mutex support in fops:
>>
>>         mutex_unlock(&videodev_lock);
>> -       if (vdev->fops->open)
>> -               ret = vdev->fops->open(filp);
>> +       if (vdev->fops->open) {
>> +               if (vdev->lock)
>> +                       mutex_lock(vdev->lock);
>> +               if (video_is_registered(vdev))
>> +                       ret = vdev->fops->open(filp);
>> +               else
>> +                       ret = -ENODEV;
>> +               if (vdev->lock)
>> +                       mutex_unlock(vdev->lock);
>> +       }
> 
> The history is slightly more complicated: this commit moved the video_is_registered
> call from before the mutex_unlock(&videodev_lock); to just before the fops->open
> call.
> 
> Commit ca9afe6f87b569cdf8e797395381f18ae23a2905 "v4l2-dev: fix race condition"
> added the video_is_registered() call to where it was originally (inside the
> videodev_lock critical section), but it didn't bother to remove the duplicate
> second video_is_registered call.
> 
> So that's how v4l2_open ended up with two calls to video_is_registered.

Apologies for simplifying the history . I'll just drop it from the changelog, 
as it can be retrieved git. I'll try to put just concise explanation why this 
this video_is_registered() is not needed currently.

>> While commit cf5337358548b813479b58478539fc20ee86556c
>> "[media] v4l2-dev: remove V4L2_FL_LOCK_ALL_FOPS"
>> removed only code touching the mutex:
>>
>>         mutex_unlock(&videodev_lock);
>>         if (vdev->fops->open) {
>> -               if (test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags) &&
>> -                   mutex_lock_interruptible(vdev->lock)) {
>> -                       ret = -ERESTARTSYS;
>> -                       goto err;
>> -               }
>>                 if (video_is_registered(vdev))
>>                         ret = vdev->fops->open(filp);
>>                 else
>>                         ret = -ENODEV;
>> -               if (test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags))
>> -                       mutex_unlock(vdev->lock);
>>         }
>>
>> Remove the remaining video_is_registered() call as it doesn't provide
>> any real protection and just adds unnecessary overhead.
> 
> True.
> 
>> The drivers need to perform the unregistration check themselves inside
>> their file operation handlers, while holding respective mutex.
> 
> No, drivers do not need to do the unregistration check. Since unregistration
> is asynchronous it can happen at any time, so there really is no point in
> checking for it other than in the core. If the device is unregistered while
> in the middle of a file operation, then that means that any USB activity will
> return an error, and that any future file operations other than release() will
> be met by an error as well from the v4l2 core.

Yes, so video_is_registered() seems not very useful to use in drivers.
But as I've shown above it's not even used optimally in the v4l2-core.

>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  drivers/media/v4l2-core/v4l2-dev.c |    8 ++------
>>  1 file changed, 2 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
>> index c8859d6..1743119 100644
>> --- a/drivers/media/v4l2-core/v4l2-dev.c
>> +++ b/drivers/media/v4l2-core/v4l2-dev.c
>> @@ -444,13 +444,9 @@ static int v4l2_open(struct inode *inode, struct file *filp)
>>  	/* and increase the device refcount */
>>  	video_get(vdev);
>>  	mutex_unlock(&videodev_lock);
>> -	if (vdev->fops->open) {
>> -		if (video_is_registered(vdev))
>> -			ret = vdev->fops->open(filp);
>> -		else
>> -			ret = -ENODEV;
>> -	}
>>
>> +	if (vdev->fops->open)
>> +		ret = vdev->fops->open(filp);
>>  	if (vdev->debug)
>>  		printk(KERN_DEBUG "%s: open (%d)\n",
>>  			video_device_node_name(vdev), ret);
>> --
>> 1.7.9.5
>>
> 
> A long story, but the patch is good, although the commit message needs work :-)
> 
> Regards,
> 
> 	Hans


Regards,
Sylwester
