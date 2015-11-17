Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:57816 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730AbbKQOMI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2015 09:12:08 -0500
Subject: Re: [PATCH] media: fix kernel hang in media_device_unregister()
 during device removal
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <1447339307-2838-1-git-send-email-shuahkh@osg.samsung.com>
 <20151115230255.GZ17128@valkosipuli.retiisi.org.uk>
 <20151116163652.591e992d@recife.lan> <564A3474.2070901@osg.samsung.com>
 <20151117062702.33e5141e@recife.lan>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <564B35B0.4020206@osg.samsung.com>
Date: Tue, 17 Nov 2015 07:12:00 -0700
MIME-Version: 1.0
In-Reply-To: <20151117062702.33e5141e@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/17/2015 01:27 AM, Mauro Carvalho Chehab wrote:
> Em Mon, 16 Nov 2015 12:54:28 -0700
> Shuah Khan <shuahkh@osg.samsung.com> escreveu:
> 
>> On 11/16/2015 11:36 AM, Mauro Carvalho Chehab wrote:
>>> Em Mon, 16 Nov 2015 01:02:56 +0200
>>> Sakari Ailus <sakari.ailus@iki.fi> escreveu:
>>>
>>>> Hi Shuah,
>>>>
>>>> On Thu, Nov 12, 2015 at 07:41:47AM -0700, Shuah Khan wrote:
>>>>> Media core drivers (dvb, v4l2, bridge driver) unregister
>>>>> their entities calling media_device_unregister_entity()
>>>>> during device removal from their unregister paths. In
>>>>> addition media_device_unregister() tries to unregister
>>>>> entity calling media_device_unregister_entity() for each
>>>>> one of them. This adds lot of contention on mdev->lock in
>>>>> device removal sequence. Fix to not unregister entities
>>>>> from media_device_unregister(), and let drivers take care
>>>>> of it. Drivers need to unregister to cover the case of
>>>>> module removal. This patch fixes the problem by deleting
>>>>> the entity list walk to call media_device_unregister_entity()
>>>>> for each entity. With this fix there is no kernel hang after
>>>>> a sequence of device insertions followed by removal.
>>>>>
>>>>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
>>>>> ---
>>>>>  drivers/media/media-device.c | 5 -----
>>>>>  1 file changed, 5 deletions(-)
>>>>>
>>>>> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
>>>>> index 1312e93..c7ab7c9 100644
>>>>> --- a/drivers/media/media-device.c
>>>>> +++ b/drivers/media/media-device.c
>>>>> @@ -577,8 +577,6 @@ EXPORT_SYMBOL_GPL(__media_device_register);
>>>>>   */
>>>>>  void media_device_unregister(struct media_device *mdev)
>>>>>  {
>>>>> -	struct media_entity *entity;
>>>>> -	struct media_entity *next;
>>>>>  	struct media_link *link, *tmp_link;
>>>>>  	struct media_interface *intf, *tmp_intf;
>>>>>  
>>>>> @@ -596,9 +594,6 @@ void media_device_unregister(struct media_device *mdev)
>>>>>  		kfree(intf);
>>>>>  	}
>>>>>  
>>>>> -	list_for_each_entry_safe(entity, next, &mdev->entities, graph_obj.list)
>>>>> -		media_device_unregister_entity(entity);
>>>>> -
>>>>>  	device_remove_file(&mdev->devnode.dev, &dev_attr_model);
>>>>>  	media_devnode_unregister(&mdev->devnode);
>>>>>  
>>>>
>>>> media_device_unregister() is expected to clean up all the entities still
>>>> registered with it (as it does to links and interfaces). Could you share
>>>> details of the problems you saw in case you haven't found the actual
>>>> underlying issue causing them?
>>>>
>>>
>>> I was not able to reproduce here with au0828. Tried to register/unregister 20
>>> times with:
>>> 	$ i=1; while :; do echo $i; sudo modprobe au0828 && sleep 2 && sudo rmmod au0828; i=$((i+1)); done
>>>
>>> The results are at:
>>> 	http://pastebin.com/1B9c9nYm
>>
>> Mauro,
>>
>> Please remove the device physically to see the problem I am seeing.
>> Also make sure you have the locking debug enabled. I just have to
>> remove the device physically just once to see the hang.
> 
> I did that too: no problem. I can remove/reinsert the device without
> causing any hangs or any dmesg related to locking issues.
> 
>>
>>>
>>>
>>> PS.: I had to add the 2 seconds sleep there, as otherwise unregister may
>>> fail, because udev is started every time the devnodes are created. Without
>>> that, sometimes it returns -EBUSY, because udev didn't close the devnode
>>> yet. Still no problem, as a later rmmod works:
>>>
>>> 	$ sudo modprobe au0828 && sudo rmmod au0828
>>> 	$ sudo modprobe au0828 && sudo rmmod au0828
>>> 	rmmod: ERROR: Module au0828 is in use
>>> 	$  sudo rmmod au0828
>>> 	$ 
>>>
>>> So, I don't think that the issues you're experiencing are related to the
>>> MC next generation.
>>
>> On my system it is the case. I have run physical removal of the device
>> on MC and didn't see the problem.
> 
> Sorry. Do you mean that rmmod au0828 never works on your system?

No physical removal not rmmod that causes problems.

> 
> Then indeed there's something broken with udev and some other module,
> and the radeon patch you've applied didn't actually solve the bug.
> 

Right - I will try without radeon to see if the problem persists.
I think we are good based on your tests. This problem might indeed
be an isolated one specific my setup.

Thanks for testing on your system.

-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
