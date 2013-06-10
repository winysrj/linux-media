Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:36825 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab3FJOiJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jun 2013 10:38:09 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MO600LW0LQEC870@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 10 Jun 2013 15:38:07 +0100 (BST)
Message-id: <51B5E4CE.1000504@samsung.com>
Date: Mon, 10 Jun 2013 16:38:06 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@iki.fi,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	a.hajda@samsung.com
Subject: Re: [RFC PATCH v2 0/2] Media entity links handling
References: <1370806899-17709-1-git-send-email-s.nawrocki@samsung.com>
 <152314640.pO20KFaLY3@avalon>
In-reply-to: <152314640.pO20KFaLY3@avalon>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 06/09/2013 10:23 PM, Laurent Pinchart wrote:
> Hi Sylwester,
> 
> On Sunday 09 June 2013 21:41:37 Sylwester Nawrocki wrote:
>> Hi All,
>>
>> This small patch set adds a function for removing all links at a media
>> entity. I found out such a function is needed when media entites that
>> belong to a single media device have drivers in different kernel modules.
>> This means virtually all camera drivers, since sensors are separate
>> modules from the host interface drivers.
>>
>> More details can be found at each patch's description.
> 
> The patches look good to me.

Thanks, I would push v3 upstream if everyone agrees. I think there is further
work to be done, to allow the media entities race-free access to their parent
media device and the graph mutex. For example, entity->parent->graph_mutex is
needed to access entity->stream_count in a subdev driver, but for that it needs
to be ensured that entity->parent doesn't change unexpectedly.

>> The links removal from a media entity is rather strightforward, but when
>> and where links should be created/removed is not immediately clear to me.
>>
>> I assumed that links should normally be created/removed when an entity
>> is registered to its media device, with the graph mutex held.
>>
>> I'm open to opinions whether it's good or not and possibly suggestions
>> on how those issues could be handled differently.
> 
> It's a very good question. So far links were created at initialization time 
> and assumed to stay until the device gets torn down. Existing drivers thus 
> access the links without holding the graph mutex.
> 
> An easy solution to fix race conditions at link creation time would be to take 
> the graph mutex in media_entity_create_link(). We will still have to fix 
> drivers to take the mutex when accessing links, I don't think there's a way 
> around that. We also need to precisely define what the graph mutex protects 
> and how drivers can access links and entities. This will become especially 
> important when the media controller framework will be used in DRM/KMS.

I agree with that. Clear and documented semantics of the graph mutex is
essential. And it all really seems required for proper subdevs hotplugging,
deferred probing support etc.

Regards,
Sylwester
