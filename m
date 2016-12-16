Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:39871 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757141AbcLPOxd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Dec 2016 09:53:33 -0500
Subject: Re: [RFC v3 00/21] Make use of kref in media device, grab references
 as needed
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <20161109154608.1e578f9e@vento.lan>
 <20161213102447.60990b1c@vento.lan>
 <20161215113041.GE16630@valkosipuli.retiisi.org.uk>
 <7529355.zfqFdROYdM@avalon> <896ef36c-435e-6899-5ae8-533da7731ec1@xs4all.nl>
 <fa996ec5-0650-9774-7baf-5eaca60d76c7@osg.samsung.com>
 <47bf7ca7-2375-3dfa-775c-a56d6bd9dabd@xs4all.nl>
 <ea29010f-ffdc-f10f-8b4f-fb1337320863@osg.samsung.com>
 <2f5a7ca0-70d1-c6a9-9966-2a169a62e405@xs4all.nl>
 <b83be9ed-5ce3-3667-08c8-2b4d4cd047a0@osg.samsung.com>
 <20161215152501.11ce2b2a@vento.lan>
 <3023f381-1141-df8f-c1ae-2bff36d688ca@osg.samsung.com>
 <150c057f-7ef8-30cb-07ca-885d4c2a4dcd@xs4all.nl>
 <20161216085741.38bb2e18@vento.lan>
 <c654bffd-792c-f860-33b4-3c399984dbd4@xs4all.nl>
 <20161216100056.5f3fcb55@vento.lan>
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b34d42aa-2007-f1fb-70ee-2533998ec54e@xs4all.nl>
Date: Fri, 16 Dec 2016 15:45:10 +0100
MIME-Version: 1.0
In-Reply-To: <20161216100056.5f3fcb55@vento.lan>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 16/12/16 13:00, Mauro Carvalho Chehab wrote:
> Em
>  escreveu:
>
>> On 16/12/16 11:57, Mauro Carvalho Chehab wrote:
>>> Em Fri, 16 Dec 2016 11:11:25 +0100
>>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>>>
>>>>> Would it make sense to enforce that dependency. Can we tie /dev/media usecount
>>>>> to /dev/video etc. usecount? In other words:
>>>>>
>>>>> /dev/video is opened, then open /dev/media.
>>>>
>>>> When a device node is registered it should increase the refcount on the media_device
>>>> (as I proposed, that would be mdev->dev). When a device node is unregistered and the
>>>> last user disappeared, then it can decrease the media_device refcount.
>>>>
>>>> So as long as anyone is using a device node, the media_device will stick around as
>>>> well.
>>>>
>>>> No need to take refcounts on open/close.
>>>
>>> That makes sense. You're meaning something like the enclosed (untested)
>>> patch?
>>>
>>>> One note: as I mentioned, the video_device does not set the cdev parent correctly,
>>>> so that bug needs to be fixed first for this to work.
>>>
>>> Actually, __video_register_device() seems to be setting the parent
>>> properly:
>>>
>>> 	if (vdev->dev_parent == NULL)
>>> 		vdev->dev_parent = vdev->v4l2_dev->dev;
>>
>> No, I mean this code (from cec-core.c):
>>
>>
>>         /* Part 2: Initialize and register the character device */
>>          cdev_init(&devnode->cdev, &cec_devnode_fops);
>>          devnode->cdev.kobj.parent = &devnode->dev.kobj;
>>          devnode->cdev.owner = owner;
>>
>>          ret = cdev_add(&devnode->cdev, devnode->dev.devt, 1);
>>          if (ret < 0) {
>>                  pr_err("%s: cdev_add failed\n", __func__);
>>                  goto clr_bit;
>>          }
>>
>>          ret = device_add(&devnode->dev);
>>          if (ret)
>>                  goto cdev_del;
>>
>> which sets cdev.kobj.parent. And that would indeed be vdev->dev_parent.
>
> Ah! So, you're basically proposing to have a separate struct for
> V4L2 devnode as well, right?
>
> Makes sense.

No need for that, that's already struct video_device.

>
>>
>>>
>>> Thanks,
>>> Mauro
>>>
>>> [PATCH] Be sure that the media_device won't be freed too early
>>>
>>> This code snippet is untested.
>>>
>>> Signed-off-by: Mauro Carvalho chehab <mchehab@s-opensource.com>
>>>
>>> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
>>> index 8756275e9fc4..5fdeab382069 100644
>>> --- a/drivers/media/media-device.c
>>> +++ b/drivers/media/media-device.c
>>> @@ -706,7 +706,7 @@ int __must_check __media_device_register(struct media_device *mdev,
>>>  	struct media_devnode *devnode;
>>>  	int ret;
>>>
>>> -	devnode = kzalloc(sizeof(*devnode), GFP_KERNEL);
>>> +	devnode = devm_kzalloc(mdev->dev, sizeof(*devnode), GFP_KERNEL);
>>
>> I'm not sure about this change. I *think* this would work, but *only* if all
>> the refcounting is 100% correct, and we know it isn't at the moment. So I
>> think this should be postponed until we are confident everything is correct.
>
> Yes, such change will require first to be sure that drivers would be
> doing the right thing.

So devm_ resources are released right after remove() exits, not when the last reference
goes to 0. In other words, devm_ typically can't be used for these complex scenarios, 
certainly not for memory. See discussion with Laurent on irc.

>
>>
>>>  	if (!devnode)
>>>  		return -ENOMEM;
>>>
>>> diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
>>> index 8be561ab2615..14a3c56dbcac 100644
>>> --- a/drivers/media/v4l2-core/v4l2-dev.c
>>> +++ b/drivers/media/v4l2-core/v4l2-dev.c
>>> @@ -196,6 +196,7 @@ static void v4l2_device_release(struct device *cd)
>>>  #if defined(CONFIG_MEDIA_CONTROLLER)
>>>  	if (v4l2_dev->mdev) {
>>>  		/* Remove interfaces and interface links */
>>> +		put_device(v4l2_dev->mdev->dev);
>>>  		media_devnode_remove(vdev->intf_devnode);
>>>  		if (vdev->entity.function != MEDIA_ENT_F_UNKNOWN)
>>>  			media_device_unregister_entity(&vdev->entity);
>>
>> I think this is the wrong order: put_device should go after media_device_unregister_entity().
>
> OK.
>
>>
>>> @@ -810,6 +811,7 @@ static int video_register_media_controller(struct video_device *vdev, int type)
>>>  			return -ENOMEM;
>>>  		}
>>>  	}
>>> +	get_device(vdev->v4l2_dev->dev);
>>
>> You mean v4l2_dev->mdev->dev?
>
> Yes, that's right (vdev->v4l2_dev->mdev->dev).

Laurent helped me realize that this won't work either: mdev->dev is typically a 
platform/pci/usb device, and that won't go away when you rmmod the driver.

So while taking a refcount on that device doesn't hurt, we also need to take a refcount
on a kref inside the mdev. Just like v4l2_device this struct has an unfortunate name.
It's not a device, but a root structure for media devices.

We really need a whiteboard for this :-(

Regards,

	Hans

>
>>
>>>
>>>  	/* FIXME: how to create the other interface links? */
>>>
>>> @@ -1015,6 +1017,11 @@ void video_unregister_device(struct video_device *vdev)
>>>  	if (!vdev || !video_is_registered(vdev))
>>>  		return;
>>>
>>> +#if defined(CONFIG_MEDIA_CONTROLLER)
>>> +	if (vdev->v4l2_dev->dev)
>>> +		put_device(vdev->v4l2_dev->dev);
>>
>> Ditto.
>>
>>> +#endif
>>> +
>>>  	mutex_lock(&videodev_lock);
>>>  	/* This must be in a critical section to prevent a race with v4l2_open.
>>>  	 * Once this bit has been cleared video_get may never be called again.
>>> diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
>>> index 62bbed76dbbc..53f42090c762 100644
>>> --- a/drivers/media/v4l2-core/v4l2-device.c
>>> +++ b/drivers/media/v4l2-core/v4l2-device.c
>>> @@ -188,6 +188,7 @@ int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
>>>  		err = media_device_register_entity(v4l2_dev->mdev, entity);
>>>  		if (err < 0)
>>>  			goto error_module;
>>> +		get_device(v4l2_dev->mdev->dev);
>>>  	}
>>>  #endif
>>>
>>> @@ -205,6 +206,8 @@ int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
>>>
>>>  error_unregister:
>>>  #if defined(CONFIG_MEDIA_CONTROLLER)
>>> +	if (v4l2_dev->mdev)
>>> +		put_device(v4l2_dev->mdev->dev);
>>>  	media_device_unregister_entity(entity);
>>>  #endif
>>>  error_module:
>>> @@ -310,6 +313,7 @@ void v4l2_device_unregister_subdev(struct v4l2_subdev *sd)
>>>  		 * links are removed by the function below, in the right order
>>>  		 */
>>>  		media_device_unregister_entity(&sd->entity);
>>> +		put_device(v4l2_dev->mdev->dev);
>>>  	}
>>>  #endif
>>>  	video_unregister_device(sd->devnode);
>>>
>>>
>>>
>>>
>>
>> Regards,
>>
>> 	Hans
>
>
>
> Thanks,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

