Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:48958 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932419Ab3FQNbg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jun 2013 09:31:36 -0400
Message-ID: <51BF0FB4.6060300@canonical.com>
Date: Mon, 17 Jun 2013 15:31:32 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
MIME-Version: 1.0
To: Inki Dae <inki.dae@samsung.com>
CC: dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	daniel@ffwll.ch, robdclark@gmail.com, kyungmin.park@samsung.com,
	myungjoo.ham@samsung.com, yj44.cho@samsung.com
Subject: Re: [RFC PATCH v2] dmabuf-sync: Introduce buffer synchronization
 framework
References: <1371112088-15310-1-git-send-email-inki.dae@samsung.com> <1371467722-665-1-git-send-email-inki.dae@samsung.com> <51BEF458.4090606@canonical.com> <012501ce6b5b$3d39b0b0$b7ad1210$%dae@samsung.com>
In-Reply-To: <012501ce6b5b$3d39b0b0$b7ad1210$%dae@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Op 17-06-13 15:04, Inki Dae schreef:
>
>> -----Original Message-----
>> From: Maarten Lankhorst [mailto:maarten.lankhorst@canonical.com]
>> Sent: Monday, June 17, 2013 8:35 PM
>> To: Inki Dae
>> Cc: dri-devel@lists.freedesktop.org; linux-fbdev@vger.kernel.org; linux-
>> arm-kernel@lists.infradead.org; linux-media@vger.kernel.org;
>> daniel@ffwll.ch; robdclark@gmail.com; kyungmin.park@samsung.com;
>> myungjoo.ham@samsung.com; yj44.cho@samsung.com
>> Subject: Re: [RFC PATCH v2] dmabuf-sync: Introduce buffer synchronization
>> framework
>>
>> Op 17-06-13 13:15, Inki Dae schreef:
>>> This patch adds a buffer synchronization framework based on DMA BUF[1]
>>> and reservation[2] to use dma-buf resource, and based on ww-mutexes[3]
>>> for lock mechanism.
>>>
>>> The purpose of this framework is not only to couple cache operations,
>>> and buffer access control to CPU and DMA but also to provide easy-to-use
>>> interfaces for device drivers and potentially user application
>>> (not implemented for user applications, yet). And this framework can be
>>> used for all dma devices using system memory as dma buffer, especially
>>> for most ARM based SoCs.
>>>
>>> Changelog v2:
>>> - use atomic_add_unless to avoid potential bug.
>>> - add a macro for checking valid access type.
>>> - code clean.
>>>
>>> The mechanism of this framework has the following steps,
>>>     1. Register dmabufs to a sync object - A task gets a new sync object
>> and
>>>     can add one or more dmabufs that the task wants to access.
>>>     This registering should be performed when a device context or an
>> event
>>>     context such as a page flip event is created or before CPU accesses
> a
>> shared
>>>     buffer.
>>>
>>> 	dma_buf_sync_get(a sync object, a dmabuf);
>>>
>>>     2. Lock a sync object - A task tries to lock all dmabufs added in
> its
>> own
>>>     sync object. Basically, the lock mechanism uses ww-mutex[1] to avoid
>> dead
>>>     lock issue and for race condition between CPU and CPU, CPU and DMA,
>> and DMA
>>>     and DMA. Taking a lock means that others cannot access all locked
>> dmabufs
>>>     until the task that locked the corresponding dmabufs, unlocks all
> the
>> locked
>>>     dmabufs.
>>>     This locking should be performed before DMA or CPU accesses these
>> dmabufs.
>>> 	dma_buf_sync_lock(a sync object);
>>>
>>>     3. Unlock a sync object - The task unlocks all dmabufs added in its
>> own sync
>>>     object. The unlock means that the DMA or CPU accesses to the dmabufs
>> have
>>>     been completed so that others may access them.
>>>     This unlocking should be performed after DMA or CPU has completed
>> accesses
>>>     to the dmabufs.
>>>
>>> 	dma_buf_sync_unlock(a sync object);
>>>
>>>     4. Unregister one or all dmabufs from a sync object - A task
>> unregisters
>>>     the given dmabufs from the sync object. This means that the task
>> dosen't
>>>     want to lock the dmabufs.
>>>     The unregistering should be performed after DMA or CPU has completed
>>>     accesses to the dmabufs or when dma_buf_sync_lock() is failed.
>>>
>>> 	dma_buf_sync_put(a sync object, a dmabuf);
>>> 	dma_buf_sync_put_all(a sync object);
>>>
>>>     The described steps may be summarized as:
>>> 	get -> lock -> CPU or DMA access to a buffer/s -> unlock -> put
>>>
>>> This framework includes the following two features.
>>>     1. read (shared) and write (exclusive) locks - A task is required to
>> declare
>>>     the access type when the task tries to register a dmabuf;
>>>     READ, WRITE, READ DMA, or WRITE DMA.
>>>
>>>     The below is example codes,
>>> 	struct dmabuf_sync *sync;
>>>
>>> 	sync = dmabuf_sync_init(NULL, "test sync");
>>>
>>> 	dmabuf_sync_get(sync, dmabuf, DMA_BUF_ACCESS_READ);
>>> 	...
>>>
>>> 	And the below can be used as access types:
>>> 		DMA_BUF_ACCESS_READ,
>>> 		- CPU will access a buffer for read.
>>> 		DMA_BUF_ACCESS_WRITE,
>>> 		- CPU will access a buffer for read or write.
>>> 		DMA_BUF_ACCESS_READ | DMA_BUF_ACCESS_DMA,
>>> 		- DMA will access a buffer for read
>>> 		DMA_BUF_ACCESS_WRITE | DMA_BUF_ACCESS_DMA,
>>> 		- DMA will access a buffer for read or write.
>>>
>>>     2. Mandatory resource releasing - a task cannot hold a lock
>> indefinitely.
>>>     A task may never try to unlock a buffer after taking a lock to the
>> buffer.
>>>     In this case, a timer handler to the corresponding sync object is
>> called
>>>     in five (default) seconds and then the timed-out buffer is unlocked
>> by work
>>>     queue handler to avoid lockups and to enforce resources of the
> buffer.
>>> The below is how to use:
>>> 	1. Allocate and Initialize a sync object:
>>> 		struct dmabuf_sync *sync;
>>>
>>> 		sync = dmabuf_sync_init(NULL, "test sync");
>>> 		...
>>>
>>> 	2. Add a dmabuf to the sync object when setting up dma buffer
>> relevant
>>> 	   registers:
>>> 		dmabuf_sync_get(sync, dmabuf, DMA_BUF_ACCESS_READ);
>>> 		...
>>>
>>> 	3. Lock all dmabufs of the sync object before DMA or CPU accesses
>>> 	   the dmabufs:
>>> 		dmabuf_sync_lock(sync);
>>> 		...
>>>
>>> 	4. Now CPU or DMA can access all dmabufs locked in step 3.
>>>
>>> 	5. Unlock all dmabufs added in a sync object after DMA or CPU
>> access
>>> 	   to these dmabufs is completed:
>>> 		dmabuf_sync_unlock(sync);
>>>
>>> 	   And call the following functions to release all resources,
>>> 		dmabuf_sync_put_all(sync);
>>> 		dmabuf_sync_fini(sync);
>>>
>>> 	You can refer to actual example codes:
>>> 		https://git.kernel.org/cgit/linux/kernel/git/daeinki/drm-
>> exynos.git/
>>> 		commit/?h=dmabuf-
>> sync&id=4030bdee9bab5841ad32faade528d04cc0c5fc94
>>> 		https://git.kernel.org/cgit/linux/kernel/git/daeinki/drm-
>> exynos.git/
>>> 		commit/?h=dmabuf-
>> sync&id=6ca548e9ea9e865592719ef6b1cde58366af9f5c
>>> The framework performs cache operation based on the previous and current
>> access
>>> types to the dmabufs after the locks to all dmabufs are taken:
>>> 	Call dma_buf_begin_cpu_access() to invalidate cache if,
>>> 		previous access type is DMA_BUF_ACCESS_WRITE | DMA and
>>> 		current access type is DMA_BUF_ACCESS_READ
>>>
>>> 	Call dma_buf_end_cpu_access() to clean cache if,
>>> 		previous access type is DMA_BUF_ACCESS_WRITE and
>>> 		current access type is DMA_BUF_ACCESS_READ | DMA
>>>
>>> Such cache operations are invoked via dma-buf interfaces so the dma buf
>> exporter
>>> should implement dmabuf->ops->begin_cpu_access/end_cpu_access callbacks.
>>>
>>> [1] http://lwn.net/Articles/470339/
>>> [2] http://lwn.net/Articles/532616/
>>> [3] https://patchwork-mail1.kernel.org/patch/2625321/
>>>
>> Looks to me like you're just writing an api similar to the android
>> syncpoint for this.
>> Is there any reason you had to reimplement the android syncpoint api?
> Right, only difference is that maybe android sync driver, you mentioned as
> syncpoint, doesn't use dma-buf resource. What I try to do is familiar to
> android's one and also ARM's KDS (Kernel Dependency System). I think I
> already mentioned enough through a document file about why I try to
> implement this approach based on dma-buf; coupling cache operation and
> buffer synchronization between CPU and DMA.
Making sure caching works correctly can be handled entirely in the begin_cpu_access/end_cpu_access callbacks, without requiring such.. framework

>> I'm not going into a full review, you may wish to rethink the design
> first.
>> All the criticisms I had with the original design approach still apply.
>>
> Isn't that enough if what I try to do is similar to android sync driver?
> It's very simple and that's all I try to do.:)
>From what I can tell you should be able to make it work with just the use of fences, you don't need to keep the buffers locked for the entire duration,
just plug in the last fence in the correct slots and  you're done..

I'm not sure if the android sync api is compatible enough, but you shouldn't need to write code in this way to make it work..
>>
>> A few things that stand out from a casual glance:
>>
>> bool is_dmabuf_sync_supported(void)
>> -> any code that needs CONFIG_DMABUF_SYNC should select it in their
>> kconfig
>> runtime enabling/disabling of synchronization is a recipe for disaster,
>> remove the !CONFIG_DMABUF_SYNC fallbacks.
>> NEVER add a runtime way to influence locking behavior.
>>
> Not enabling/disabling synchronization feature in runtime. That is
> determined at build time.
>
>> Considering you're also holding dmaobj->lock for the entire duration, is
>> there any point to not simply call begin_cpu_access/end_cpu_access, and
>> forget this ugly code ever existed?
> You mean mutex_lock(&sync->lock)? Yeah, it seems unnecessary in that case.
>
>> I still don't see the problem you're trying to solve..
>>
> It's just to implement a thin sync framework coupling cache operation. This
> approach is based on dma-buf for more generic implementation against android
> sync driver or KDS.
>
> The described steps may be summarized as:
> 	lock -> cache operation -> CPU or DMA access to a buffer/s -> unlock
>
> I think that there is no need to get complicated for such approach at least
> for most devices sharing system memory. Simple is best.
>
>
> Thanks,
> Inki Dae
>
>> ~Maarten

