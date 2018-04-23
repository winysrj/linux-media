Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:49226 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754513AbeDWJq1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 05:46:27 -0400
Subject: Re: [RFCv11 PATCH 03/29] media-request: allocate media requests
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
 <20180409142026.19369-4-hverkuil@xs4all.nl>
 <20180410065239.7e1036d0@vento.lan>
 <20180410111430.iuacaxpleiwfpzok@valkosipuli.retiisi.org.uk>
 <20180411071315.0c21c4f8@vento.lan>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e21fc99c-f6b5-b8ad-7317-412a941cd849@xs4all.nl>
Date: Mon, 23 Apr 2018 11:46:21 +0200
MIME-Version: 1.0
In-Reply-To: <20180411071315.0c21c4f8@vento.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/11/2018 12:13 PM, Mauro Carvalho Chehab wrote:
> Em Tue, 10 Apr 2018 14:14:30 +0300
> Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> 
>>>>  /**
>>>> @@ -88,6 +96,8 @@ struct media_device_ops {
>>>>   * @disable_source: Disable Source Handler function pointer
>>>>   *
>>>>   * @ops:	Operation handler callbacks
>>>> + * @req_lock:	Serialise access to requests
>>>> + * @req_queue_mutex: Serialise validating and queueing requests  
>>>
>>> IMHO, this would better describe it:
>>> 	Serialise validate and queue requests
>>>
>>> Yet, IMO, it doesn't let it clear when the spin lock should be
>>> used and when the mutex should be used.
>>>
>>> I mean, what of them protect what variable?  
>>
>> It might not be obvious, but the purpose of this mutex is to prevent
>> queueing multiple requests simultaneously in order to serialise access to
>> the top of the queue.
> 
> It is not obvious at all. The purpose of a lock is to prevent
> multiple acesses to the content of a data structure.
> 
> From what I see, here we have a single structure with two locks.
> To make it worse, you're introducing first the lock and then,
> on patch 04/29, the actual structs to be protected.
> 
> Well, a house with two doors is only closed if both doors are
> closed. The same happens with a data structure protected by
> two locks. It is only locked if both locks are locked.
> 
> So, every time I see two locks meant to protect the same struct, it
> sounds poorly designed or wrong. 
> 
> There's one exception, though: if you have an independent
> guest house and a main house, you could have two locks at the
> same place, one for the main house and another one for the
> guest house, but in this case, you should clearly tag with lock
> protects each house.
> 
> So, in this case, two new locks that are being proposed to be added
> at for struct media_device. So, I would be expecting a comment
> like:
> 
> 	@req_lock: serialize access to &struct media_request 

Urgh. This req_lock is a left-over from some older code. It's never
used and I've now deleted it. That explains the confusion. I thought you
were talking about the spinlock in struct media_request.

The req_queue_mutex is there to serialize queueing of requests, it
doesn't protect any data structures, it just ensures you can't queue
two requests in parallel for the same media device.

Regards,

	Hans


> 	@req_queue_mutex: serialize access to &struct media_request_object
> 
> Clearly stating what data structures each lock protects.
> 
> That was my concern when I pointed it. After looking at the entire
> patchset, what I saw was a non-consistent locking model.
> 
> It sounded to me that the original design to be:
> 
> 1) req_queue_mutex was designed to protect struct media_request
>    instances;
> 
> 2) req_lock was designed to protect just one field inside
>    struct media_request (the state field).
> 
> There is a big issue on that:
> 
> As state is part of media_request, assuming that the data struct
> won't disappear while in use (with is warranted by kref), before
> changing its value and touching other fields at req, the code should 
> be locking both req_queue_mutex and req_lock, but I didn't see that
> behavior on several places.
> 
> Also, I noticed several locking inconsistencies, as, on several places,
> the content of a media_request instance and/or its state was 
> accessed/altered without either locks.
> 
>> How about this instead:
>>
>> 	Serialise access to accessing device state on the tail of the
>> 	request queue.
> 
> It still doesn't mention what struct each of the new locks protect.
> IMHO, this patch should either be bound with patch 04/29 or come after
> that, and explicitly mention what data is protected by each lock.
> 
> Thanks,
> Mauro
> 
