Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:54148 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933471AbcCPOcv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2016 10:32:51 -0400
Subject: Re: [PATCH 4/5] [media] media-device: use kref for media_device
 instance
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <dba4d41bdfa6bb8dc51cb0f692102919b2b7c8b4.1458129823.git.mchehab@osg.samsung.com>
 <82ef082c4de7c0a1c546da1d9e462bc86ab423bf.1458129823.git.mchehab@osg.samsung.com>
 <56E9681B.3070403@osg.samsung.com> <20160316112540.37086aba@recife.lan>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <56E96E90.8040609@osg.samsung.com>
Date: Wed, 16 Mar 2016 08:32:48 -0600
MIME-Version: 1.0
In-Reply-To: <20160316112540.37086aba@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/16/2016 08:25 AM, Mauro Carvalho Chehab wrote:
> Em Wed, 16 Mar 2016 08:05:15 -0600
> Shuah Khan <shuahkh@osg.samsung.com> escreveu:
> 
>> On 03/16/2016 06:04 AM, Mauro Carvalho Chehab wrote:
>>> Now that the media_device can be used by multiple drivers,
>>> via devres, we need to be sure that it will be dropped only
>>> when all drivers stop using it.
>>>
>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>>> ---
>>>  drivers/media/media-device.c | 48 +++++++++++++++++++++++++++++++-------------
>>>  include/media/media-device.h |  3 +++
>>>  2 files changed, 37 insertions(+), 14 deletions(-)
>>>
>>> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
>>> index c32fa15cc76e..38e6c319fe6e 100644
>>> --- a/drivers/media/media-device.c
>>> +++ b/drivers/media/media-device.c
>>> @@ -721,6 +721,15 @@ int __must_check __media_device_register(struct media_device *mdev,
>>>  {
>>>  	int ret;
>>>  
>>> +	/* Check if mdev was ever registered at all */
>>> +	mutex_lock(&mdev->graph_mutex);
>>> +	if (media_devnode_is_registered(&mdev->devnode)) {
>>> +		kref_get(&mdev->kref);
>>> +		mutex_unlock(&mdev->graph_mutex);
>>> +		return 0;
>>> +	}
>>> +	kref_init(&mdev->kref);
>>> +
>>>  	/* Register the device node. */
>>>  	mdev->devnode.fops = &media_device_fops;
>>>  	mdev->devnode.parent = mdev->dev;
>>> @@ -730,8 +739,10 @@ int __must_check __media_device_register(struct media_device *mdev,
>>>  	mdev->topology_version = 0;
>>>  
>>>  	ret = media_devnode_register(&mdev->devnode, owner);
>>> -	if (ret < 0)
>>> +	if (ret < 0) {
>>> +		media_devnode_unregister(&mdev->devnode);
>>>  		return ret;
>>> +	}
>>>  
>>>  	ret = device_create_file(&mdev->devnode.dev, &dev_attr_model);
>>>  	if (ret < 0) {
>>> @@ -739,6 +750,7 @@ int __must_check __media_device_register(struct media_device *mdev,
>>>  		return ret;
>>>  	}
>>>  
>>> +	mutex_unlock(&mdev->graph_mutex);
>>>  	dev_dbg(mdev->dev, "Media device registered\n");
>>>  
>>>  	return 0;
>>> @@ -773,23 +785,15 @@ void media_device_unregister_entity_notify(struct media_device *mdev,
>>>  }
>>>  EXPORT_SYMBOL_GPL(media_device_unregister_entity_notify);
>>>  
>>> -void media_device_unregister(struct media_device *mdev)
>>> +static void struct kref *kref)
>>>  {
>>> +	struct media_device *mdev;
>>>  	struct media_entity *entity;
>>>  	struct media_entity *next;
>>>  	struct media_interface *intf, *tmp_intf;
>>>  	struct media_entity_notify *notify, *nextp;
>>>  
>>> -	if (mdev == NULL)
>>> -		return;
>>> -
>>> -	mutex_lock(&mdev->graph_mutex);
>>> -
>>> -	/* Check if mdev was ever registered at all */
>>> -	if (!media_devnode_is_registered(&mdev->devnode)) {
>>> -		mutex_unlock(&mdev->graph_mutex);
>>> -		return;
>>> -	}
>>> +	mdev = container_of(kref, struct media_device, kref);
>>>  
>>>  	/* Remove all entities from the media device */
>>>  	list_for_each_entry_safe(entity, next, &mdev->entities, graph_obj.list)
>>> @@ -807,13 +811,26 @@ void media_device_unregister(struct media_device *mdev)
>>>  		kfree(intf);
>>>  	}
>>>  
>>> -	mutex_unlock(&mdev->graph_mutex);
>>> +	/* Check if mdev devnode was registered */
>>> +	if (!media_devnode_is_registered(&mdev->devnode))
>>> +		return;
>>>  
>>>  	device_remove_file(&mdev->devnode.dev, &dev_attr_model);
>>>  	media_devnode_unregister(&mdev->devnode);  
>>
>> Patch looks good.
>>
>> Reviewed-by: Shuah Khan <shuahkh@osg.samsung.com>
>>
>> Please see a few comments below that aren't related to this patch.
>>
>> The above is unprotected and could be done twice when two drivers
>> call media_device_unregister(). I think we still mark the media
>> device unregistered in media_devnode_unregister(). We have to
>> protect these two steps still.
>>
>> I attempted to do this with a unregister in progress flag which
>> gets set at the beginning in media_device_unregister(). That
>> does ensure media_device_unregister() runs only once. If that
>> approach isn't desirable, we have to find another way.
> 
> Do you mean do_media_device_unregister()? This is protected, as
> this function is only called via media_device_unregister(),
> with the mutex hold. I opted to take the mutex there, as
> it makes the return code simpler.
> 

The below two steps are my concern. With the mutex changes in
do_media_device_unregister() closed critical windows, however
the below code path still concerns me.

device_remove_file(&mdev->devnode.dev, &dev_attr_model);
media_devnode_unregister(&mdev->devnode); 

Especially since we do the clear MEDIA_FLAG_REGISTERED in
media_devnode_unregister(). This step is done while holding
media_devnode_lock - a different mutex

We rely on media_devnode_is_registered() check to determine
whether to start unregister or not. Hence, there is a window
where, we could potentially try to do the following twice:

device_remove_file(&mdev->devnode.dev, &dev_attr_model);
media_devnode_unregister(&mdev->devnode);

You will see this only when both au0828 and snd-usb-audio
try to unregister()

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
