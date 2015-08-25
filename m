Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:33040 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755780AbbHYNv0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2015 09:51:26 -0400
Message-ID: <55DC7237.5050709@xs4all.nl>
Date: Tue, 25 Aug 2015 15:48:39 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v7 22/44] [media] media: add a linked list to track interfaces
 by mdev
References: <cover.1440359643.git.mchehab@osg.samsung.com>	<cc0587807ee794a75a61b953d054bd782a06eb03.1440359643.git.mchehab@osg.samsung.com>	<55DC1F2D.1070903@xs4all.nl> <20150825071257.1d7ca523@recife.lan>
In-Reply-To: <20150825071257.1d7ca523@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/25/15 12:12, Mauro Carvalho Chehab wrote:
> Em Tue, 25 Aug 2015 09:54:21 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> On 08/23/2015 10:17 PM, Mauro Carvalho Chehab wrote:
>>> We need to be able to navigate at the interfaces that
>>> belong to a given media device, in to indirect
>>> interface links.
>>
>> The part after the comma is not clear. Did you perhaps mean 'into'?
>> Although that still doesn't really clarify the sentence.
> 
> What about:
> 
> It should be possible to navigate at the interface objects from the
> media controller. So, add a linked list there.

Sorry, still unclear.

How about this:

"The media device should list the interface objects, so add a linked list
for those interfaces in struct media_device."

Regards,

	Hans

> 
>>
>>>
>>> So, add a linked list to track them.
>>>
>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>>>
>>> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
>>> index 3e649cacfc07..659507bce63f 100644
>>> --- a/drivers/media/media-device.c
>>> +++ b/drivers/media/media-device.c
>>> @@ -381,6 +381,7 @@ int __must_check __media_device_register(struct media_device *mdev,
>>>  		return -EINVAL;
>>>  
>>>  	INIT_LIST_HEAD(&mdev->entities);
>>> +	INIT_LIST_HEAD(&mdev->interfaces);
>>>  	spin_lock_init(&mdev->lock);
>>>  	mutex_init(&mdev->graph_mutex);
>>>  
>>> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
>>> index 16d7d96abb9f..05976c891c17 100644
>>> --- a/drivers/media/media-entity.c
>>> +++ b/drivers/media/media-entity.c
>>> @@ -875,6 +875,8 @@ struct media_intf_devnode *media_devnode_create(struct media_device *mdev,
>>>  	media_gobj_init(mdev, MEDIA_GRAPH_INTF_DEVNODE,
>>>  		       &devnode->intf.graph_obj);
>>>  
>>> +	list_add_tail(&intf->list, &mdev->interfaces);
>>> +
>>>  	return devnode;
>>>  }
>>>  EXPORT_SYMBOL_GPL(media_devnode_create);
>>> @@ -882,6 +884,7 @@ EXPORT_SYMBOL_GPL(media_devnode_create);
>>>  void media_devnode_remove(struct media_intf_devnode *devnode)
>>>  {
>>>  	media_gobj_remove(&devnode->intf.graph_obj);
>>> +	list_del(&devnode->intf.list);
>>>  	kfree(devnode);
>>>  }
>>>  EXPORT_SYMBOL_GPL(media_devnode_remove);
>>> diff --git a/include/media/media-device.h b/include/media/media-device.h
>>> index 3b14394d5701..51807efa505b 100644
>>> --- a/include/media/media-device.h
>>> +++ b/include/media/media-device.h
>>> @@ -46,6 +46,7 @@ struct device;
>>>   * @link_id:	Unique ID used on the last link registered
>>>   * @intf_devnode_id: Unique ID used on the last interface devnode registered
>>>   * @entities:	List of registered entities
>>> + * @interfaces:	List of registered interfaces
>>>   * @lock:	Entities list lock
>>>   * @graph_mutex: Entities graph operation lock
>>>   * @link_notify: Link state change notification callback
>>> @@ -77,6 +78,7 @@ struct media_device {
>>>  	u32 intf_devnode_id;
>>>  
>>>  	struct list_head entities;
>>> +	struct list_head interfaces;
>>>  
>>>  	/* Protects the entities list */
>>>  	spinlock_t lock;
>>> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
>>> index aeb390a9e0f3..35d97017dd19 100644
>>> --- a/include/media/media-entity.h
>>> +++ b/include/media/media-entity.h
>>> @@ -156,6 +156,8 @@ struct media_entity {
>>>   * struct media_intf_devnode - Define a Kernel API interface
>>>   *
>>>   * @graph_obj:		embedded graph object
>>> + * @list:		Linked list used to find other interfaces that belong
>>> + *			to the same media controller
>>>   * @links:		List of links pointing to graph entities
>>>   * @type:		Type of the interface as defined at the
>>>   *			uapi/media/media.h header, e. g.
>>> @@ -164,6 +166,7 @@ struct media_entity {
>>>   */
>>>  struct media_interface {
>>>  	struct media_gobj		graph_obj;
>>> +	struct list_head		list;
>>>  	struct list_head		links;
>>>  	u32				type;
>>>  	u32				flags;
>>>
>>
>> Regards,
>>
>> 	Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
