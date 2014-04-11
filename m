Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:41216 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750735AbaDKTa0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Apr 2014 15:30:26 -0400
Message-ID: <534842CD.70303@vmware.com>
Date: Fri, 11 Apr 2014 21:30:21 +0200
From: Thomas Hellstrom <thellstrom@vmware.com>
MIME-Version: 1.0
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
CC: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	ccross@google.com, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] [RFC v2 with seqcount] reservation: add suppport
 for read-only access using rcu
References: <20140409144239.26648.57918.stgit@patser> <20140409144831.26648.79163.stgit@patser> <53465A53.1090500@vmware.com> <53466D63.8080808@canonical.com> <53467B93.3000402@vmware.com> <5346B212.8050202@canonical.com> <5347A9FD.2070706@vmware.com> <5347B4E5.6090901@canonical.com> <5347BFC9.3020503@vmware.com> <53482FF1.1090406@canonical.com>
In-Reply-To: <53482FF1.1090406@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

On 04/11/2014 08:09 PM, Maarten Lankhorst wrote:
> op 11-04-14 12:11, Thomas Hellstrom schreef:
>> On 04/11/2014 11:24 AM, Maarten Lankhorst wrote:
>>> op 11-04-14 10:38, Thomas Hellstrom schreef:
>>>> Hi, Maarten.
>>>>
>>>> Here I believe we encounter a lot of locking inconsistencies.
>>>>
>>>> First, it seems you're use a number of pointers as RCU pointers
>>>> without
>>>> annotating them as such and use the correct rcu
>>>> macros when assigning those pointers.
>>>>
>>>> Some pointers (like the pointers in the shared fence list) are both
>>>> used
>>>> as RCU pointers (in dma_buf_poll()) for example,
>>>> or considered protected by the seqlock
>>>> (reservation_object_get_fences_rcu()), which I believe is OK, but then
>>>> the pointers must
>>>> be assigned using the correct rcu macros. In the memcpy in
>>>> reservation_object_get_fences_rcu() we might get away with an
>>>> ugly typecast, but with a verbose comment that the pointers are
>>>> considered protected by the seqlock at that location.
>>>>
>>>> So I've updated (attached) the headers with proper __rcu annotation
>>>> and
>>>> locking comments according to how they are being used in the various
>>>> reading functions.
>>>> I believe if we want to get rid of this we need to validate those
>>>> pointers using the seqlock as well.
>>>> This will generate a lot of sparse warnings in those places needing
>>>> rcu_dereference()
>>>> rcu_assign_pointer()
>>>> rcu_dereference_protected()
>>>>
>>>> With this I think we can get rid of all ACCESS_ONCE macros: It's not
>>>> needed when the rcu_x() macros are used, and
>>>> it's never needed for the members protected by the seqlock, (provided
>>>> that the seq is tested). The only place where I think that's
>>>> *not* the case is at the krealloc in
>>>> reservation_object_get_fences_rcu().
>>>>
>>>> Also I have some more comments in the
>>>> reservation_object_get_fences_rcu() function below:
>>> I felt that the barriers needed for rcu were already provided by
>>> checking the seqcount lock.
>>> But looking at rcu_dereference makes it seem harmless to add it in
>>> more places, it handles
>>> the ACCESS_ONCE and barrier() for us.
>> And it makes the code more maintainable, and helps sparse doing a lot of
>> checking for us. I guess
>> we can tolerate a couple of extra barriers for that.
>>
>>> We could probably get away with using RCU_INIT_POINTER on the writer
>>> side,
>>> because the smp_wmb is already done by arranging seqcount updates
>>> correctly.
>> Hmm. yes, probably. At least in the replace function. I think if we do
>> it in other places, we should add comments as to where
>> the smp_wmb() is located, for future reference.
>>
>>
>> Also  I saw in a couple of places where you're checking the shared
>> pointers, you're not checking for NULL pointers, which I guess may
>> happen if shared_count and pointers are not in full sync?
>>
> No, because shared_count is protected with seqcount. I only allow
> appending to the array, so when
> shared_count is validated by seqcount it means that the
> [0...shared_count) indexes are valid and non-null.
> What could happen though is that the fence at a specific index is
> updated with another one from the same
> context, but that's harmless.

Hmm.
Shouldn't we have a way to clean signaled fences from reservation
objects? Perhaps when we attach a new fence, or after a wait with
ww_mutex held? Otherwise we'd have a lot of completely unused fence
objects hanging around for no reason. I don't think we need to be as
picky as TTM, but I think we should do something?

/Thomas



>
> ~Maarten
