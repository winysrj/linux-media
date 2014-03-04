Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:60132 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756305AbaCDHuo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Mar 2014 02:50:44 -0500
Message-ID: <531585CE.9020509@canonical.com>
Date: Tue, 04 Mar 2014 08:50:38 +0100
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
MIME-Version: 1.0
To: Daniel Vetter <daniel@ffwll.ch>, Ian Lister <ian.lister@intel.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-arch@vger.kernel.org, Colin Cross <ccross@google.com>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	"Clark, Rob" <robdclark@gmail.com>,
	dri-devel <dri-devel@lists.freedesktop.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH 4/6] android: convert sync to fence api, v4
References: <20140217155056.20337.25254.stgit@patser>	<20140217155640.20337.13331.stgit@patser> <CAKMK7uESOhk_i8ui1pVknA=6s8oQsBOCTULYszxe5fodcBwTGw@mail.gmail.com>
In-Reply-To: <CAKMK7uESOhk_i8ui1pVknA=6s8oQsBOCTULYszxe5fodcBwTGw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

op 03-03-14 22:11, Daniel Vetter schreef:
> On Mon, Feb 17, 2014 at 04:57:19PM +0100, Maarten Lankhorst wrote:
>> Android syncpoints can be mapped to a timeline. This removes the need
>> to maintain a separate api for synchronization. I've left the android
>> trace events in place, but the core fence events should already be
>> sufficient for debugging.
>>
>> v2:
>> - Call fence_remove_callback in sync_fence_free if not all fences have fired.
>> v3:
>> - Merge Colin Cross' bugfixes, and the android fence merge optimization.
>> v4:
>> - Merge with the upstream fixes.
>>
>> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
>> ---
> Snipped everything but headers - Ian Lister from our android team is
> signed up to have a more in-depth look at proper integration with android
> syncpoints. Adding him to cc.
>
>> diff --git a/drivers/staging/android/sync.h b/drivers/staging/android/sync.h
>> index 62e2255b1c1e..6036dbdc8e6f 100644
>> --- a/drivers/staging/android/sync.h
>> +++ b/drivers/staging/android/sync.h
>> @@ -21,6 +21,7 @@
>>   #include <linux/list.h>
>>   #include <linux/spinlock.h>
>>   #include <linux/wait.h>
>> +#include <linux/fence.h>
>>
>>   struct sync_timeline;
>>   struct sync_pt;
>> @@ -40,8 +41,6 @@ struct sync_fence;
>>    * -1 if a will signal before b
>>    * @free_pt: called before sync_pt is freed
>>    * @release_obj: called before sync_timeline is freed
>> - * @print_obj: deprecated
>> - * @print_pt: deprecated
>>    * @fill_driver_data: write implementation specific driver data to data.
>>    *  should return an error if there is not enough room
>>    *  as specified by size.  This information is returned
>> @@ -67,13 +66,6 @@ struct sync_timeline_ops {
>>    /* optional */
>>    void (*release_obj)(struct sync_timeline *sync_timeline);
>>
>> - /* deprecated */
>> - void (*print_obj)(struct seq_file *s,
>> -  struct sync_timeline *sync_timeline);
>> -
>> - /* deprecated */
>> - void (*print_pt)(struct seq_file *s, struct sync_pt *sync_pt);
>> -
>>    /* optional */
>>    int (*fill_driver_data)(struct sync_pt *syncpt, void *data, int size);
>>
>> @@ -104,42 +96,48 @@ struct sync_timeline {
>>
>>    /* protected by child_list_lock */
>>    bool destroyed;
>> + int context, value;
>>
>>    struct list_head child_list_head;
>>    spinlock_t child_list_lock;
>>
>>    struct list_head active_list_head;
>> - spinlock_t active_list_lock;
>>
>> +#ifdef CONFIG_DEBUG_FS
>>    struct list_head sync_timeline_list;
>> +#endif
>>   };
>>
>>   /**
>>    * struct sync_pt - sync point
>> - * @parent: sync_timeline to which this sync_pt belongs
>> + * @fence: base fence class
>>    * @child_list: membership in sync_timeline.child_list_head
>>    * @active_list: membership in sync_timeline.active_list_head
>> +<<<<<<< current
>>    * @signaled_list: membership in temporary signaled_list on stack
>>    * @fence: sync_fence to which the sync_pt belongs
>>    * @pt_list: membership in sync_fence.pt_list_head
>>    * @status: 1: signaled, 0:active, <0: error
>>    * @timestamp: time which sync_pt status transitioned from active to
>>    *  signaled or error.
>> +=======
>> +>>>>>>> patched
> Conflict markers ...
Oops.
>>    */
>>   struct sync_pt {
>> - struct sync_timeline *parent;
>> - struct list_head child_list;
>> + struct fence base;
> Hm, embedding feels wrong, since that still means that I'll need to
> implement two kinds of fences in i915 - one using the seqno fence to make
> dma-buf sync work, and one to implmenent sync_pt to make the android folks
> happy.
>
> If I can dream I think we should have a pointer to an underlying fence
> here, i.e. a struct sync_pt would just be a userspace interface wrapper to
> do explicit syncing using native fences, instead of implicit syncing like
> with dma-bufs. But this is all drive-by comments from a very cursory
> high-level look. I might be full of myself again ;-)
> -Daniel
>
No, the idea is that because android syncpoint is simply another type of dma-fence, that if you deal with normal fences then android can automatically
be handled too. The userspace fence api android exposes could be very easily made to work for dma-fence, just pass a dma-fence to sync_fence_create.
So exposing dma-fence would probably work for android too.

~Maarten
