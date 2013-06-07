Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:50994 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab3FGJCu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jun 2013 05:02:50 -0400
From: Inki Dae <inki.dae@samsung.com>
To: 'Maarten Lankhorst' <maarten.lankhorst@canonical.com>,
	'Daniel Vetter' <daniel@ffwll.ch>,
	'Rob Clark' <robdclark@gmail.com>
Cc: 'linux-fbdev' <linux-fbdev@vger.kernel.org>,
	'DRI mailing list' <dri-devel@lists.freedesktop.org>,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	"'myungjoo.ham'" <myungjoo.ham@samsung.com>,
	'YoungJun Cho' <yj44.cho@samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
References: <CAAQKjZP=iOmHRpHZCbZD3v_RKUFSn0eM_WVZZvhe7F9g3eTmPA@mail.gmail.com>
 <CAF6AEGuDih-NR-VZCmQfqbvCOxjxreZRPGfhCyL12FQ1Qd616Q@mail.gmail.com>
 <006a01ce504e$0de3b0e0$29ab12a0$%dae@samsung.com>
 <CAF6AEGv2FiKMUpb5s4zHPdj4uVxnQWdVJWL-i1mOOZRxBvMZ4Q@mail.gmail.com>
 <00cf01ce512b$bacc5540$3064ffc0$%dae@samsung.com>
 <CAF6AEGuBexKUpTwm9cjGjkxCTKgEaDhAakeP0RN=rtLS6Qy=Mg@mail.gmail.com>
 <CAAQKjZP37koEPob6yqpn-WxxTh3+O=twyvRzDiEhVJTD8BxQzw@mail.gmail.com>
 <20130520211304.GV12292@phenom.ffwll.local>
 <20130520213033.GW12292@phenom.ffwll.local>
 <032701ce55f1$3e9ba4b0$bbd2ee10$%dae@samsung.com>
 <20130521074441.GZ12292@phenom.ffwll.local>
 <033a01ce5604$c32bd250$498376f0$%dae@samsung.com>
 <CAKMK7uHtk+A7CDZH3qHt+F3H_fdSsWwt-bEPn-N0919oOE+Jkg@mail.gmail.com>
In-reply-to: 
Subject: Introduce a dmabuf sync framework for buffer synchronization
Date: Fri, 07 Jun 2013 18:02:47 +0900
Message-id: <00e201ce635d$c8230650$586912f0$%dae@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Came back :)

Please, ignore previous fence helper. I have re-implemented buffer
synchronization mechanism, dmabuf sync, based on DMA BUF and wound/wait
style lock v5[1] and tested it with 2d gpu and drm kms drivers.

The below is dmabuf sync framework codes,
	
https://git.kernel.org/cgit/linux/kernel/git/daeinki/drm-exynos.git/commit/?
h=dmabuf-sync&id=ae6c5a0146ab72ea64d9fc91af4595aacf9a5139
	
And g2d driver with dmabuf sync framework,
	
https://git.kernel.org/cgit/linux/kernel/git/daeinki/drm-exynos.git/commit/?
h=dmabuf-sync&id=4030bdee9bab5841ad32faade528d04cc0c5fc94

And also exynos drm kms framework,
	
https://git.kernel.org/cgit/linux/kernel/git/daeinki/drm-exynos.git/commit/?
h=dmabuf-sync&id=6ca548e9ea9e865592719ef6b1cde58366af9f5c

[1] https://patchwork-mail1.kernel.org/patch/2625321/

The purpose of this framework is not only to couple synchronizing caches and
buffer access between CPU and CPU, CPU and DMA, and DMA and DMA but also to
provide easy-to-use interfaces for device drivers: we may need
user interfaces but there is no good way for exposing the interfaces to user
side yet.

Basically, the mechanism of this framework has the following steps,
Initialize dmabuf sync object - A task gets a new sync object allocated and
initialized by dmabuf_sync_init(). This work should be done when a context
or similar thing of device driver is created or before cpu access.
    
Add a dmabuf to the sync object - A task can add a dmabuf or more that this
task wants to access to its own sync object. This work should be done just
before setting up dma buffer relevant registers or buffer cpu access.
    
Lock a sync object - A task tries to lock all dmabufs added in the sync
object. And for this, ww-mutexes is used to resolve dead lock. This work
should be done before dma start or cpu access. The lock means DMA or CPU of
current task can access dmabufs so the other cannot access dmabufs.

Unlock a sync object - A task tries to unlock all dmabufs added in the sync
object. This work should be done when after the completion of dma operation
or CPU access. The unlock means DMA or CPU access of current task has been
completed so the other can access the dmabufs.

In addition, this framework includes the following two features,
Consider read and write lock - this feature is for more performance: we
don't need to take a lock in case that a buffer was accessed for read and
current task tries to access the buffer for read. So when current task tries
to take a lock, this feature checks previous access type and desired type to
a given buffer and then decides if it has to take a lock to the buffer or
not.
    
Consider lockup and resource management - this feature considers the case
that any task never unlocks a buffer after taking a lock to the buffer. In
this case, a timer handler to this task is called sometimes later and then
the buffer is unlocked by workqueue handler to avoid lockup and release the
buffer relevant resources.
    
Tutorial.
	when allocating and initializing device context
		struct dmabuf_sync *sync;

		sync = dmabuf_sync_init(NULL, NULL);

	when setting up dma buffer relevant registers
		/* it can be called repeatly for multiple buffers. */
		dmabuf_sync_get(sync, dmabuf);

	just before dma start or cpu access
		dmabuf_sync_lock(sync);

	after the completion of dma operation or cpu access
		dmabuf_sync_unlock(sync);
		dmabuf_sync_put_all(sync);
		dmabuf_sync_fini(sync);


Deadlock reproduction with dmabuf sync.
For deadlock test, I had tried to reproduce deadlock situation like below
and the below approach had been worked well,
(Please, presume that two tasks share two dmabufs together.)

	[Task A]
	struct dmabuf_sync *sync;

	sync = dmabuf_sync_init(NULL, NULL);
	
	dmabuf_sync_get(sync, dmabuf A);
	dmabuf_sync_get(sync, dmabuf B);

	while(1) {
		dmabuf_sync_lock(sync);
		sleep(1);
		dmabuf_sync_unlock(sync);
		sleep(1);
	}

	[Task B]
	struct dmabuf_sync *sync;

	sync = dmabuf_sync_init(NULL, NULL);
	
	dmabuf_sync_get(sync, dmabuf C);
	dmabuf_sync_get(sync, dmabuf A);

	while(1) {
		dmabuf_sync_lock(sync); <-- deadlock
		sleep(1);
		dmabuf_sync_unlock(sync);
		sleep(1);
	}

With the above example codes, deadlock occurs when Task B called
dmabuf_sync_lock function: internally, Task B takes a lock to dmabuf C and
then tries to take a lock to dmabuf A. But at this time, ww_mutex_lock()
returns -EDEADLK because ctx->acquired became 1 once taking a lock to dmabuf
C. And then task B unlocks dmabuf C and takes a slowpath lock to dmabuf A.
And then once Task A unlocks dmabuf A, Task B tries to take a lock to dmabuf
C again.

And the below is my concerns and opinions,
A dma buf has a reservation object when a buffer is exported to the dma buf
- I'm not sure but it seems that reservation object is used for x86 gpu;
having vram and different domain, or similar devices. So in case of embedded
system, most dma devices and cpu share system memory so I think that
reservation object should be considered for them also because basically,
buffer synchronization mechanism should be worked based on dmabuf. For this,
I have added four members to reservation_object; shared_cnt and shared for
read lock, accessed_type for cache operation, and locked for timeout case.
Hence, some devices might need specific something for itself. So how about
remaining only common part for reservation_object structure; it seems that
fence_excl, fence_shared, and so on are not common part.

Now wound/wait mutex doesn't consider read and write lock - In case of using
ww-mutexes for buffer synchronization, it seems that we need read and write
lock for more performance; read access and then read access doesn't need to
be locked. For this, I have added three members, shared_cnt and shared to
reservation_object and this is just to show you how we can use read lock.
However, I'm sure that there is a better/more generic way.

The above all things is just quick implementation for buffer synchronization
so this should be more cleaned up and there might be my missing point.
Please give me your advices and opinions.

Thanks,
Inki Dae

