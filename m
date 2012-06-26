Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51188 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758524Ab2FZRiV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jun 2012 13:38:21 -0400
Received: by eaak11 with SMTP id k11so85185eaa.19
        for <linux-media@vger.kernel.org>; Tue, 26 Jun 2012 10:38:20 -0700 (PDT)
Message-ID: <4FE9F38A.5040209@gmail.com>
Date: Tue, 26 Jun 2012 19:38:18 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
MIME-Version: 1.0
To: dri-devel@lists.freedesktop.org
CC: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org
Subject: implicit drm synchronization wip with dma-buf
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey,

Due to inertia, I thought I would take a shot at implicit synchronization as well.
I have just barely enough to make it work for nouveau to synchronize with itself
now using the cpu. Hopefully the general idea is correct but I feel the
implementation wrong.

There are 2 ways to get deadlocks if no proper care is taken to avoid it,
the first being 2 tasks taking each device's lock in a different order,
the second 2 devices waiting on completion of each other before starting
own work. The easiest way to avoid this is to introduce a global
dma_buf_submit_mutex so in cases where synchronization is needed.
This way only 1 submission involving dma-buffer synchronisation can be made
simultaneously. This will make it impossible to deadlock because even if you
take dma mutex->dev a mutex->dev b mutex, and swap a and b, the dmabuf mutex
would prevent this from being done at the same time.

That leaves the real problem of the synchronization itself. I felt that because
the code involved was already sharing dma-buf's, the easiest way to implement it
would be.. another dma-buf. Some hardware might have specific requirements on them,
so I haven't pinned down the exact details yet.

It's a bit of intermingling between drm and dma-buf namespace since it is an early
wip, any comments are welcome though.

This is what I used so far:

#define DRM_PRIME_FENCE_MAX 2
struct drm_prime_fence {
	struct dma_buf *sync_buf;
	uint64_t offset;
	uint32_t value;
	enum {
		/* Nop is to allow preparations in case dma_buf
		 * is different for release, so the call will
		 * never fail at that point.
		 */
		DRM_PRIME_FENCE_NOP = 0,
		DRM_PRIME_FENCE_WAIT_EQ,
//		DRM_PRIME_FENCE_WAIT_GE, /* block while ((int)(cur - expected) < 0); */
		DRM_PRIME_FENCE_SET
	} op;
};

and added to struct dma_buf_ops:
	/* drm_prime_fence_ is written by function to indicate what is needed
	 * to acquire this buffer, up to DRM_PRIME_FENCE_MAX buffers are allowed
	 * sync_acquire returns a negative value on error, otherwise
	 * amounts of fence ops that need to be executed.
	 *
	 * Release is not allowed to fail and merely returns number of
	 * fence ops that needs to be executed after command stream is done.
	 * Abort occurs when there's a failure between acquire and release,
	 * for example because dma-buf's from multiple devices are involved
	 * and the other one failed to acquire.
	 */
	int (*sync_acquire)(struct dma_buf *, struct drm_prime_fence fence[2],
			    unsigned long align, unsigned long release_write);
	int (*sync_release)(struct dma_buf * struct drm_prime_fence fence[2]);
	void (*sync_abort)(struct dma_buf *);

I'm not completely sure about this part yet, align can be seen as minimum
alignment requirement, ideally I would negotiate those earlier but I haven't
found the correct place yet, maybe on attach?
nouveau writes a 16 byte stamp as part of it's semaphore ops
(4 bytes programmable, 4 bytes pad, 8 bytes timestamp) which is why I need
to communicate those requirements somehow. Not all nouveau cards wold support
DRM_PRIME_FENCE_WAIT_GE either.

I think there is a great power in making the sync object itself just another
dma-buf that can be written to and/or read. Especially since all graphics
card have some way to write an arbitrary 4-byte value to an arbitrary location
(even the oldest intel cards have a blitter! :D). I'm hoping for more input
into making the api better for other users too, which is why I'm posting
this as early as I had something working (for some definition of working).

Thoughts?
~Maarten

