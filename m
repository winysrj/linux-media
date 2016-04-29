Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:56242 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060AbcD2Qwl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2016 12:52:41 -0400
Subject: Re: [PATCH] media: fix media_ioctl use-after-free when driver unbinds
To: Lars-Peter Clausen <lars@metafoo.de>, mchehab@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com,
	chehabrafael@gmail.com, sakari.ailus@iki.fi
References: <1461726512-9828-1-git-send-email-shuahkh@osg.samsung.com>
 <5720EC1A.8060101@metafoo.de> <57213591.3000109@osg.samsung.com>
 <5721B994.4030202@metafoo.de>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <5723914F.6020504@osg.samsung.com>
Date: Fri, 29 Apr 2016 10:52:31 -0600
MIME-Version: 1.0
In-Reply-To: <5721B994.4030202@metafoo.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/28/2016 01:19 AM, Lars-Peter Clausen wrote:
> On 04/27/2016 11:56 PM, Shuah Khan wrote:
>>>>  	dev_dbg(mdev->dev, "Media device unregistered\n");
>>>>  }
>>>> diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
>>>> index 29409f4..9af9ba1 100644
>>>> --- a/drivers/media/media-devnode.c
>>>> +++ b/drivers/media/media-devnode.c
>>>> @@ -171,6 +171,9 @@ static int media_open(struct inode *inode, struct file *filp)
>>>>  		mutex_unlock(&media_devnode_lock);
>>>>  		return -ENXIO;
>>>>  	}
>>>> +
>>>> +	kobject_get(&mdev->kobj);
>>>
>>> This is not necessary, and if it was it would be prone to race condition as
>>> the last reference could be dropped before this line. But assigning the cdev
>>> parent makes sure that we always have a reference to the object while the
>>> open() callback is running.
>>
>> I don't see cdev parent kobj get in cdev_get() which does kobject_get()
>> on cdev->kobj. Is that enough to get the reference?
>>
>> cdev_add() gets the cdev parent kobj and cdev_del() puts it back. That is
>> the reason why I added a get here and put in media_release().
>>
> 
> The cdev takes the parent reference when created and only drops it once it
> is released. So as long as the cdev exists there is a reference to the
> parent. While cdev_del() puts one reference to the cdev there is also one
> reference for each open file. So as long as there is a open file there is a
> reference to the parent as well.
> 
>> I can remove the get and put and test. Looks like I am not checking
>> kobject_get() return value which isn't good?
> 
> kobject_get() can't fail.

Yes looks that way, yet there are so many places in lib/kobject.c
that check for kobject_get() returning NULL. :)

> 
>>
>>>
>>>> +
>>>>  	/* and increase the device refcount */
>>>>  	get_device(&mdev->dev);
>>>>  	mutex_unlock(&media_devnode_lock);
>>>>  /*
>>> [...]
>>>> diff --git a/include/media/media-devnode.h b/include/media/media-devnode.h
>>>> index fe42f08..ba4bdaa 100644
>>>> --- a/include/media/media-devnode.h
>>>> +++ b/include/media/media-devnode.h
>>>> @@ -70,7 +70,9 @@ struct media_file_operations {
>>>>   * @fops:	pointer to struct &media_file_operations with media device ops
>>>>   * @dev:	struct device pointer for the media controller device
>>>>   * @cdev:	struct cdev pointer character device
>>>> + * @kobj:	struct kobject
>>>>   * @parent:	parent device
>>>> + * @media_dev:	media device
>>>>   * @minor:	device node minor number
>>>>   * @flags:	flags, combination of the MEDIA_FLAG_* constants
>>>>   * @release:	release callback called at the end of media_devnode_release()
>>>> @@ -87,7 +89,9 @@ struct media_devnode {
>>>>  	/* sysfs */
>>>>  	struct device dev;		/* media device */
>>>>  	struct cdev cdev;		/* character device */
>>>> +	struct kobject kobj;		/* set as cdev parent kobj */
>>>
>>> You don't need a extra kobj. Just use the struct dev kobj.
>>
>> Yeah I can use that as long as I can override the default release
>> function with media_devnode_free(). media_devnode should stick around
>> until the last app closes /dev/mediaX even if the media_device is no
>> longer registered. i.e media_ioctl should be able to check if devnode
>> is registered or not. I think I am missing something and don't understand
>> how struct dev kobj can be used.
> 
> The struct dev that is embedded into th media_devnode as the same live time
> as the media_devnode itself. In addition to that struct device is a
> reference counted object. This means a structure that embeds struct device
> must not be freed until the last reference is dropped.
> 
> What you do here is introduce a independent reference counting mechanism for
> the same structure. Which means if there is a reference to struct device,
> but not to the new kobj you end up with a use-after-free again.
> 
> The solution is to only use one reference counting mechanism (the struct
> device) and intialize the cdev kobj parent to the device kobj and whenever
> you did kobj_{get,put}() replace that with {get,put}_device(). And in the
> device release callback free the struct media_devnode.
> 

Okay. It is all well and good that I can use the kobj in devnode->dev,
however, devnode->dev doesn't get initialized in device_register(&devnode->dev)
and cdev_add() is the one that does kobject_get() on the cdev parent kobj.

I am seeing:
[   45.724866] au0828: Registered device AU0828 [Hauppauge HVR950Q]
[   45.724961] ------------[ cut here ]------------
[   45.724975] WARNING: CPU: 1 PID: 312 at lib/kobject.c:597 kobject_get+0x8f/0xf0
[   45.724982] kobject: '(null)' (ffff8801f6166530): is not initialized, yet kobject_get() is being called.

warnings as soon as drivers do cdev_add().

This will be a problem at cdev_del() time, since cdev_del() is done after
device_unregister(&devnode->dev) and device_del() deletes the dev->kobj

In other words, devnode->dev lifetime is going to be within
device_register(&devnode->dev) and device_unregister(&devnode->dev)
and that won't work as cdev_add() happens before device_register(&devnode->dev)
and cdev_del() after device_unregister(&devnode->dev)

cdev_add()

    device_register(&devnode->dev)
    dev.kobj initialized
    device_unregister(&devnode->dev)
    dev.kobj deleted

cdev_del()


I will go back to adding kobject to devnode.

thanks,
-- Shuah

