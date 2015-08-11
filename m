Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:56974 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751401AbbHKM24 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2015 08:28:56 -0400
Message-ID: <55C9E9FA.1080701@xs4all.nl>
Date: Tue, 11 Aug 2015 14:26:34 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH RFC v2 16/16] media: add functions to allow creating interfaces
References: <cover.1438954897.git.mchehab@osg.samsung.com>	<d34a30c10ed3c6a0e2e850e2cd0ce123f4546e35.1438954897.git.mchehab@osg.samsung.com>	<55C9D921.6010808@xs4all.nl> <20150811092444.484f2640@recife.lan>
In-Reply-To: <20150811092444.484f2640@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/11/15 14:24, Mauro Carvalho Chehab wrote:
> Em Tue, 11 Aug 2015 13:14:41 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> On 08/07/15 16:20, Mauro Carvalho Chehab wrote:
>>> Interfaces are different than entities: they represent a
>>> Kernel<->userspace interaction, while entities represent a
>>> piece of hardware/firmware/software that executes a function.
>>>
>>> Let's distinguish them by creating a separate structure to
>>> store the interfaces.
>>>
>>> Latter patches should change the existing drivers and logic
>>> to split the current interface embedded inside the entity
>>> structure (device nodes) into a separate object of the graph.
>>
>> So, to be clear, the plan is to replace the embedded media_entity
>> struct in struct video_device by a struct media_intf_devnode pointer
>> that is allocated with media_devnode_create()?
> 
> Yes.
> 
>>
>> Can we keep struct media_intf_devnode embedded in struct video_device?
>> Or is that impossible since all media_graph_obj structs are expected
>> to be allocated?
>>
>> I do have a preference for keeping structs embedded, unless there is a
>> good reason not to. I just want to make sure there is a good reason.
> 
> My plan is to always allocate the structs, as we'll very likely need to
> have kref for all those structs, in order to be sure that they'll be
> freed only after having all their usages stopped.
> 
> The thing is that it is really complex when we have lots of objects
> linked to know when an object is not used anymore.
> 
> Let's assume, for example, this simple graph:
> 	entity 0
> 		pad 0
> 	entity 1
> 		pad 0
> 		pad 1
> 	entity 2
> 		pad 0
> 	link 0
> 		entity 0:pad 0 -> entity 1: pad 0
> 	link 1
> 		entity 1:pad 1 -> entity 2: pad 0
> 
> 
> If we need to keep back references for the links, we'll end by
> having both links 0 and 1 used twice.
> 
> We can't free neither the entities or the pads while link 0
> is not freed, but it is used twice: as a link and as a backlink.
> 
> Assuming that we want to free all those objects from the memory,
> It can be really tricky to find the right order to free them, as
> we need first to go into the 3 entities and free the links there,
> then we can free the pads and entities.
> 
> If, on the other hand, we use kref, we can simply do a for on
> all objects and call kref_put(). The object memory will be
> freed in an order that will be safe, e. g. when all kref counts
> are zero for that specific object.
> 
> I actually postponed the usage of kref because it is a little hard to
> de-embed the entities on subdevices, but IMHO, using kref is the best
> and safest way to be sure that the Kernel won't be accessing a freed
> memory as the graph dynamically changes. 

OK, I agree. I just wanted to make sure I understood the reason for
this change.

Regards,

	Hans
