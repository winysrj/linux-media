Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:37216 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab2CPSzs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Mar 2012 14:55:48 -0400
Received: by vcqp1 with SMTP id p1so4561235vcq.19
        for <linux-media@vger.kernel.org>; Fri, 16 Mar 2012 11:55:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4f637907.8511440a.7941.ffff9067SMTPIN_ADDED@mx.google.com>
References: <1331775148-5001-1-git-send-email-rob.clark@linaro.org>
	<4f637907.8511440a.7941.ffff9067SMTPIN_ADDED@mx.google.com>
Date: Fri, 16 Mar 2012 13:55:47 -0500
Message-ID: <CAF6AEGvB7Gh4AS4qt9Zh29z43H-M8uKV1rQHWh0ARK62pe+fgA@mail.gmail.com>
Subject: Re: [PATCH] RFC: dma-buf: userspace mmap support
From: Rob Clark <rob.clark@linaro.org>
To: Tom Cooksey <tom.cooksey@arm.com>
Cc: linaro-mm-sig@lists.linaro.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, rschultz@google.com,
	sumit.semwal@linaro.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 16, 2012 at 12:24 PM, Tom Cooksey <tom.cooksey@arm.com> wrote:
>
>> From: Rob Clark <rob@ti.com>
>>
>> Enable optional userspace access to dma-buf buffers via mmap() on the
>> dma-buf file descriptor.  Userspace access to the buffer should be
>> bracketed with DMA_BUF_IOCTL_{PREPARE,FINISH}_ACCESS ioctl calls to
>> give the exporting driver a chance to deal with cache synchronization
>> and such for cached userspace mappings without resorting to page
>> faulting tricks.  The reasoning behind this is that, while drm
>> drivers tend to have all the mechanisms in place for dealing with
>> page faulting tricks, other driver subsystems may not.  And in
>> addition, while page faulting tricks make userspace simpler, there
>> are some associated overheads.
>
> Speaking for the ARM Mali T6xx driver point of view, this API looks
> good for us. Our use-case for mmap is glReadPixels and
> glTex[Sub]Image2D on buffers the driver has imported via dma_buf. In
> the case of glReadPixels, the finish ioctl isn't strictly necessary
> as the CPU won't have written to the buffer and so doesn't need
> flushing. As such, we'd get an additional cache flush which isn't
> really necessary. But hey, it's glReadPixels - it's supposed to be
> slow. :-)
>
> I think requiring the finish ioctl in the API contract is a good
> idea, even if the CPU has only done a ro access as it allows future
> enhancements*. To "fix" the unnecessary flush in glReadPixels, I
> think we'd like to keep the finish but see an "access type"
> parameter added to prepare ioctl indicating if the access is ro or
> rw to allow the cache flush in finish to be skipped if the access
> was ro. As Rebecca says, a debug feature could even be added to
> re-map the pages as ro in prepare(ro) to catch naughty accesses. I'd
> also go as far as to say the debug feature should completely unmap
> the pages after finish too. Though for us, both the access-type
> parameter and debug features are "nice to haves" - we can make
> progress with the code as it currently stands (assuming exporters
> start using the API that is).

Perhaps it isn't a bad idea to include access-type bitmask in the
first version.  It would help optimize a bit the cache operations.

> Something which also came up when discussing internally is the topic
> of mmap APIs of the importing device driver. For example, I believe
> DRM has an mmap API on GEM buffer objects. If a new dma_buf import
> ioctl was added to GEM (maybe the PRIME patches already add this),
> how would GEM's bo mmap API work?

My first thought is maybe we should just dis-allow this for now until
we have a chance to see if there are any possible issues with an
importer mmap'ing the buffer to userspace.  We could possible have a
helper dma_buf_mmap() fxn which in turn calls dmabuf ops->mmap() so
the mmap'ing is actually performed by the exporter on behalf of the
importer.

>
> * Future enhancements: The prepare/finish bracketing could be used
> as part of a wider synchronization scheme with other devices.
> E.g. If another device was writing to the buffer, the prepare ioctl
> could block until that device had finished accessing that buffer.
> In the same way, another device could be blocked from accessing that
> buffer until the client process called finish. We have already
> started playing with such a scheme in the T6xx driver stack we're
> terming "kernel dependency system". In this scheme each buffer has a
> FIFO of "buffer consumers" waiting to access a buffer. The idea
> being that a "buffer consumer" is fairly abstract and could be any
> device or userspace process participating in the synchronization
> scheme. Examples would be GPU jobs, display controller "scan-out"
> jobs, etc.
>
> So for example, a userspace application could dispatch a GPU
> fragment shading job into the GPU's kernel driver which will write
> to a KMS scanout buffer. The application then immediately issues a
> drm_mode_crtc_page_flip ioctl on the display controller's DRM driver
> to display the soon-to-be-rendered buffer. Inside the kernel, the
> GPU driver adds the fragment job to the dma_buf's FIFO. As the FIFO
> was empty, dma_buf calls into the GPU kernel driver to tell it it
> "owns" access to the buffer and the GPU driver schedules the job to
> run on the GPU. Upon receiving the drm_mode_crtc_page_flip ioctl,
> the DRM/KMS driver adds a scan-out job to the buffer's FIFO.
> However, the FIFO already has the GPU's fragment shading job in it
> so nothing happens until the GPU job completes. When the GPU job
> completes, the GPU driver calls into dma_buf to mark its job
> complete. dma_buf then takes the next job in its FIFO which the KMS
> driver's scanout job, calls into the KMS driver to schedule the
> pageflip. The result? A buffer gets scanned out as soon as it has
> finished being rendered without needing a round-trip to userspace.
> Sure, there are easier ways to achieve that goal, but the idea is
> that the mechanism can be used to synchronize access across multiple
> devices, which makes it useful for lots of other use-cases too.
>
>
> As I say, we have already implemented something which works as I
> describe but where the buffers are abstract resources not linked to
> dma_buf. I'd like to discuss the finer points of the mechanisms
> further, but if it's looking like there's interest in this approach
> we'll start re-writing the code we have to sit on-top of dma_buf
> and posting it as RFCs to the various lists. The intention is to get
> this to mainline, if mainline wants it. :-)

I think we do need some sort of 'sync object' (which might really just
be a 'synchronization queue' object) in the kernel.  It probably
shouldn't be built-in to dma-buf, but I expect we'd want the dma_buf
struct to have a 'struct sync_queue *' (or whatever it ends up being
called).

The sync-queue seems like a reasonable approach for pure cpu-sw based
synchronization.  The only thing I'm not sure is how to also deal with
hw that supports any sort of auto synchronization without cpu sw
involvement.

BR,
-R

> Personally, what I particularly like about this approach to
> synchronization is that it doesn't require any interfaces to be
> modified. I think/hope that makes it easier to port existing drivers
> and sub-systems to take advantage of it. The buffer itself is the
> synchronization object and interfaces already pass buffers around so
> don't need modification. There are of course some limitations with
> this approach, the main one we can think of being that it can't
> really be used for A/V sync. It kinda assumes "jobs" in the FIFO
> should be run as soon as the preceding job completes, which isn't
> the case when streaming real-time video. Though nothing precludes
> more explicit sync objects being used in conjunction with this
> approach.
>
>
> Cheers,
>
> Tom
>
>
>
>
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
