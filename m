Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:55703 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423317Ab3FUQzz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jun 2013 12:55:55 -0400
MIME-Version: 1.0
In-Reply-To: <1371817628.5882.13.camel@weser.hi.pengutronix.de>
References: <20130617182127.GM2718@n2100.arm.linux.org.uk>
	<007301ce6be4$8d5c6040$a81520c0$%dae@samsung.com>
	<20130618084308.GU2718@n2100.arm.linux.org.uk>
	<008a01ce6c02$e00a9f50$a01fddf0$%dae@samsung.com>
	<1371548849.4276.6.camel@weser.hi.pengutronix.de>
	<008601ce6cb0$2c8cec40$85a6c4c0$%dae@samsung.com>
	<1371637326.4230.24.camel@weser.hi.pengutronix.de>
	<00ae01ce6cd9$f4834630$dd89d290$%dae@samsung.com>
	<1371645247.4230.41.camel@weser.hi.pengutronix.de>
	<CAAQKjZNJD4HpnJQ7iE+Gez36066M6U0YQeUEdA0+UcSOKqeghg@mail.gmail.com>
	<20130619182925.GL2718@n2100.arm.linux.org.uk>
	<00da01ce6d81$76eb3d60$64c1b820$%dae@samsung.com>
	<1371714427.4230.64.camel@weser.hi.pengutronix.de>
	<00db01ce6d8f$a3c23dd0$eb46b970$%dae@samsung.com>
	<1371723063.4114.12.camel@weser.hi.pengutronix.de>
	<010801ce6da7$896affe0$9c40ffa0$%dae@samsung.com>
	<1371804843.4114.49.camel@weser.hi.pengutronix.de>
	<CAAQKjZOxOMuL3zh_yV7tU2LBcZ7oVryiKa+LgjTM5HLY+va8zQ@mail.gmail.com>
	<1371817628.5882.13.camel@weser.hi.pengutronix.de>
Date: Sat, 22 Jun 2013 01:55:51 +0900
Message-ID: <CAAQKjZOeskLB7n6FM+bnB8n7ecuQM5k6uANXJXo=xk979f9s9Q@mail.gmail.com>
Subject: Re: [RFC PATCH v2] dmabuf-sync: Introduce buffer synchronization framework
From: Inki Dae <daeinki@gmail.com>
To: Lucas Stach <l.stach@pengutronix.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	linux-fbdev <linux-fbdev@vger.kernel.org>,
	YoungJun Cho <yj44.cho@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"myungjoo.ham" <myungjoo.ham@samsung.com>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2013/6/21 Lucas Stach <l.stach@pengutronix.de>:
> Hi Inki,
>
> please refrain from sending HTML Mails, it makes proper quoting without
> messing up the layout everywhere pretty hard.
>

Sorry about that. I should have used text mode.

> Am Freitag, den 21.06.2013, 20:01 +0900 schrieb Inki Dae:
> [...]
>
>>         Yeah, you'll some knowledge and understanding about the API
>>         you are
>>         working with to get things right. But I think it's not an
>>         unreasonable
>>         thing to expect the programmer working directly with kernel
>>         interfaces
>>         to read up on how things work.
>>
>>         Second thing: I'll rather have *one* consistent API for every
>>         subsystem,
>>         even if they differ from each other than having to implement
>>         this
>>         syncpoint thing in every subsystem. Remember: a single execbuf
>>         in DRM
>>         might reference both GEM objects backed by dma-buf as well
>>         native SHM or
>>         CMA backed objects. The dma-buf-mgr proposal already allows
>>         you to
>>         handle dma-bufs much the same way during validation than
>>         native GEM
>>         objects.
>>
>> Actually, at first I had implemented a fence helper framework based on
>> reservation and dma fence to provide easy-use-interface for device
>> drivers. However, that was wrong implemention: I had not only
>> customized the dma fence but also not considered dead lock issue.
>> After that, I have reimplemented it as dmabuf sync to solve dead
>> issue, and at that time, I realized that we first need to concentrate
>> on the most basic thing: the fact CPU and CPU, CPU and DMA, or DMA and
>> DMA can access a same buffer, And the fact simple is the best, and the
>> fact we need not only kernel side but also user side interfaces. After
>> that, I collected what is the common part for all subsystems, and I
>> have devised this dmabuf sync framework for it. I'm not really
>> specialist in Desktop world. So question. isn't the execbuf used only
>> for the GPU? the gpu has dedicated video memory(VRAM) so it needs
>> migration mechanism between system memory and the dedicated video
>> memory, and also to consider ordering issue while be migrated.
>>
>
> Yeah, execbuf is pretty GPU specific, but I don't see how this matters
> for this discussion. Also I don't see a big difference between embedded
> and desktop GPUs. Buffer migration is more of a detail here. Both take
> command stream that potentially reference other buffers, which might be
> native GEM or dma-buf backed objects. Both have to make sure the buffers
> are in the right domain (caches cleaned and address mappings set up) and
> are available for the desired operation, meaning you have to sync with
> other DMA engines and maybe also with CPU.

Yeah, right. Then, in case of desktop gpu, does't it need additional
something to do when a buffer/s is/are migrated from system memory to
video memory domain, or from video memory to system memory domain? I
guess the below members does similar thing, and all other DMA devices
would not need them:
        struct fence {
                  ...
                  unsigned int context, seqno;
                  ...
        };

And,
       struct seqno_fence {
                 ...
                 uint32_t seqno_ofs;
                 ...
       };

>
> The only case where sync isn't clearly defined right now by the current
> API entrypoints is when you access memory through the dma-buf fallback
> mmap support, which might happen with some software processing element
> in a video pipeline or something. I agree that we will need a userspace
> interface here, but I think this shouldn't be yet another sync object,
> but rather more a prepare/fini_cpu_access ioctl on the dma-buf which
> hooks into the existing dma-fence and reservation stuff.

I think we don't need addition ioctl commands for that. I am thinking
of using existing resources as possible. My idea also is similar in
using the reservation stuff to your idea because my approach also
should use the dma-buf resource. However, My idea is that a user
process, that wants buffer synchronization with the other, sees a sync
object as a file descriptor like dma-buf does. The below shows simple
my idea about it:

ioctl(dmabuf_fd, DMA_BUF_IOC_OPEN_SYNC, &sync);

flock(sync->fd, LOCK_SH); <- LOCK_SH means a shared lock.
CPU access for read
flock(sync->fd, LOCK_UN);

Or

flock(sync->fd, LOCK_EX); <- LOCK_EX means an exclusive lock
CPU access for write
flock(sync->fd, LOCK_UN);

close(sync->fd);

As you know, that's similar to dmabuf export feature.

In addition, a more simple idea,
flock(dmabuf_fd, LOCK_SH/EX);
CPU access for read/write
flock(dmabuf_fd, LOCK_UN);

However, I'm not sure that the above examples could be worked well,
and there are no problems yet: actually, I don't fully understand
flock mechanism, so looking into it.

>
>>
>>         And to get back to my original point: if you have more than
>>         one task
>>         operating together on a buffer you absolutely need some kind
>>         of real IPC
>>         to sync them up and do something useful. Both you syncpoints
>>         and the
>>         proposed dma-fences only protect the buffer accesses to make
>>         sure
>>         different task don't stomp on each other. There is nothing in
>>         there to
>>         make sure that the output of your pipeline is valid. You have
>>         to take
>>         care of that yourself in userspace. I'll reuse your example to
>>         make it
>>         clear what I mean:
>>
>>         Task A                                         Task B
>>         ------                                         -------
>>         dma_buf_sync_lock(buf1)
>>         CPU write buf1
>>         dma_buf_sync_unlock(buf1)
>>                   ---------schedule Task A again-------
>>         dma_buf_sync_lock(buf1)
>>         CPU write buf1
>>         dma_buf_sync_unlock(buf1)
>>                     ---------schedule Task B---------
>>                                                        qbuf(buf1)
>>
>>         dma_buf_sync_lock(buf1)
>>                                                        ....
>>
>>         This is what can happen if you don't take care of proper
>>         syncing. Task A
>>         writes something to the buffer in expectation that Task B will
>>         take care
>>         of it, but before Task B even gets scheduled Task A overwrites
>>         the
>>         buffer again. Not what you wanted, isn't it?
>>
>> Exactly wrong example. I had already mentioned about that. "In case
>> that data flow goes from A to B, it needs some kind of IPC between the
>> two tasks every time"  So again, your example would have no any
>> problem in case that *two tasks share the same buffer but these tasks
>> access the buffer(buf1) as write, and data of the buffer(buf1) isn't
>> needed to be shared*.  They just need to use the buffer as *storage*.
>> So All they want is to avoid stomping on the buffer in this case.
>>
> Sorry, but I don't see the point. If no one is interested in the data of
> the buffer, why are you sharing it in the first place?
>

Just used as a storage. i.e., Task A fills the buffer with "AAAAAA"
using CPU, And Task B fills the buffer with "BBBBBB" using DMA. They
don't share data of the buffer, but they share *memory region* of the
buffer. That would be very useful for the embedded systems with very
small size system memory.

>>
>>         So to make sure the output of a pipeline of some kind is what
>>         you expect
>>         you have to do syncing with IPC
>>
>> So not true.
>>
>>         . And once you do CPU access it is a
>>         synchronous thing in the stream of events. I see that you
>>         might want to
>>         have some kind of bracketed CPU access even for the fallback
>>         mmap case
>>         for things like V4L2 that don't provide explicit sync by their
>>         own, but
>>         in no way I can see why we would need a user/kernel shared
>>         syncpoint for
>>         this.
>>
>>         > > A more advanced way to achieve this
>>         > > would be using cross-device fences to avoid going through
>>         userspace for
>>         > > every syncpoint.
>>         > >
>>         >
>>         > Ok, maybe there is something I missed. So question. What is
>>         the
>>         > cross-device fences? dma fence?. And how we can achieve the
>>         > synchronization mechanism without going through user space
>>         for every
>>         > syncpoint; CPU and DMA share a same buffer?. And could you
>>         explain it
>>         > in detail as long as possible like I did?
>>         >
>>
>>         Yeah I'm talking about the proposed dma-fences. They would
>>         allow you to
>>         just queue things into the kernel without waiting for a device
>>         operation
>>         to finish. But you still have to make sure that your commands
>>         have the
>>         right order and don't go wild. So for example you could do
>>         something
>>         like this:
>>
>>         Userspace                                   Kernel
>>         ---------                                   ------
>>         1. build DRM command stream
>>         rendering into buf1
>>         2. queue command stream with execbuf
>>                                                     1. validate
>>         command stream
>>                                                      1.1 reference
>>         buf1 for writing
>>                                                          through
>>         dma-buf-mgr
>>                                                     2. kick off GPU
>>         processing
>>         3. qbuf buf1 into V4L2
>>                                                     3. reference buf1
>>         for reading
>>                                                      3.1 wait for
>>         fence from GPU to
>>                                                          signal
>>                                                     4. kick off V4L2
>>         processing
>>
>>
>> That seems like very specific to Desktop GPU. isn't it?
>>
> Would you mind explaining what you think is desktop specific about that?
>

Sorry. there was my misunderstanding. That's not specfic to desktop
gpu. I guess the V4L2 device and GPU device are in a same graphic card
in case of desktop pc, and also they would use same memory domain.
However, If we use other device, that uses system memory as dma
buffer, instead of V4L2 device then doesn't it need specific something
to handle memory domain migration issue? My point is that such thing
is not common portion we want to do. I think things common to entire
archtectures such as ARM, x86, and so on should be placed in
drivers/base/here.

That's just my opinion.

Thanks,
Inki Dae

> Regards,
> Lucas
>
> --
> Pengutronix e.K.                           | Lucas Stach                 |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-5076 |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
>
