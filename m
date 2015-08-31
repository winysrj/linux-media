Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:38556 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751373AbbHaNgf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2015 09:36:35 -0400
Message-ID: <55E4582A.5050205@xs4all.nl>
Date: Mon, 31 Aug 2015 15:35:38 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v8 48/55] [media] media_device: add a topology version
 field
References: <cover.1440902901.git.mchehab@osg.samsung.com>	<e8cb8de5ad8f2da3c32418d67340fe4bb663ce5c.1440902901.git.mchehab@osg.samsung.com>	<55E448A8.6060004@xs4all.nl> <20150831095213.667d7a22@recife.lan>
In-Reply-To: <20150831095213.667d7a22@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/31/2015 02:52 PM, Mauro Carvalho Chehab wrote:
> Em Mon, 31 Aug 2015 14:29:28 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> On 08/30/2015 05:06 AM, Mauro Carvalho Chehab wrote:
>>> Every time a graph object is added or removed, the version
>>> of the topology changes. That's a requirement for the new
>>> MEDIA_IOC_G_TOPOLOGY, in order to allow userspace to know
>>> that the topology has changed after a previous call to it.
>>>
>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>>
>> I think this should be postponed until we actually have dynamic reconfigurable
>> graphs.
> 
> So far, we're using the term "dynamic" to mean partial graph object
> removal.
> 
> But even today, MC does support "dynamic" in the sense of graph
> object additions.
> 
> You should notice that having a topology_version is something that
> IMHO, it is needed since the beginning, even without dynamic
> reconfigurable graphs, because the graph may grow in runtime.
> 
> That will happen, for example, if usb-snd-audio is blacklisted
> at /etc/modprobe*, and someone connects an au0828.
> 
> New entities/links will be created (after Shuah patches) if one would
> modprobe latter snd-usb-audio.

latter -> later :-)

You are right, this would trigger a topology change. I hadn't thought about
that.

> 
>>
>> I would also like to reserve version 0: if 0 is returned, then the graph is
>> static.
> 
> Why? Implementing this would be really hard, as that would mean that
> G_TOPOLOGY would need to be blocked until all drivers and subdevices
> get probed.
> 
> In order to implement that, some logic would be needed at the drivers
> to identify if everything was set and unlock G_TOPOLOGY.

That wouldn't be needed if the media device node was created last. Which
I think is a good idea anyway.

> 
> What would be the gain for that? I fail to see any.

It would tell userspace that it doesn't have to cope with dynamically
changing graphs.

Even though with the au0828 example you can expect to see cases like that,
I can pretty much guarantee that no generic v4l2 applications will ever
support dynamic changes. Those that will support it will be custom-made.

Being able to see that graphs can change dynamically would allow such apps
to either refuse to use the device, or warn the user.

Regards,

	Hans

> 
> On the other hand, the patch below offers a simple way to detect if topology
> changes, as, no matter if an object was added or removed, the topology
> version will be increased.
> 
> Btw, I added a logic at the mc_nextgen_test program to identify if the
> topology changes between the two calls:
> 	http://git.linuxtv.org/cgit.cgi/mchehab/experimental-v4l-utils.git/tree/contrib/test/mc_nextgen_test.c?h=mc-next-gen&id=fdc16ece9732c94cfa76eee86978158c5976c00a#n504
> 
> Regards,
> Mauro
> 
>>
>> In G_TOPOLOGY we'd return always 0 for now.
>>
>> Regards,
>>
>> 	Hans
>>
>>>
>>> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
>>> index c89f51bc688d..c18f4af52771 100644
>>> --- a/drivers/media/media-entity.c
>>> +++ b/drivers/media/media-entity.c
>>> @@ -185,6 +185,9 @@ void media_gobj_init(struct media_device *mdev,
>>>  		list_add_tail(&gobj->list, &mdev->interfaces);
>>>  		break;
>>>  	}
>>> +
>>> +	mdev->topology_version++;
>>> +
>>>  	dev_dbg_obj(__func__, gobj);
>>>  }
>>>  
>>> @@ -199,6 +202,8 @@ void media_gobj_remove(struct media_gobj *gobj)
>>>  {
>>>  	dev_dbg_obj(__func__, gobj);
>>>  
>>> +	gobj->mdev->topology_version++;
>>> +
>>>  	/* Remove the object from mdev list */
>>>  	list_del(&gobj->list);
>>>  }
>>> diff --git a/include/media/media-device.h b/include/media/media-device.h
>>> index 0d1b9c687454..1b12774a9ab4 100644
>>> --- a/include/media/media-device.h
>>> +++ b/include/media/media-device.h
>>> @@ -41,6 +41,8 @@ struct device;
>>>   * @bus_info:	Unique and stable device location identifier
>>>   * @hw_revision: Hardware device revision
>>>   * @driver_version: Device driver version
>>> + * @topology_version: Monotonic counter for storing the version of the graph
>>> + *		topology. Should be incremented each time the topology changes.
>>>   * @entity_id:	Unique ID used on the last entity registered
>>>   * @pad_id:	Unique ID used on the last pad registered
>>>   * @link_id:	Unique ID used on the last link registered
>>> @@ -74,6 +76,8 @@ struct media_device {
>>>  	u32 hw_revision;
>>>  	u32 driver_version;
>>>  
>>> +	u32 topology_version;
>>> +
>>>  	u32 entity_id;
>>>  	u32 pad_id;
>>>  	u32 link_id;
>>>
>>

