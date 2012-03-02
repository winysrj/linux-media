Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:4365 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965271Ab2CBWjF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Mar 2012 17:39:05 -0500
Message-Id: <e39f63$3uf6dn@fmsmga002.fm.intel.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [Linaro-mm-sig] [PATCH 2/3] dma-buf: add support for kernel cpu access
To: Daniel Vetter <daniel.vetter@ffwll.ch>,
	linaro-mm-sig@lists.linaro.org,
	LKML <linux-kernel@vger.kernel.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	linux-media@vger.kernel.org
In-Reply-To: <1330616161-1937-3-git-send-email-daniel.vetter@ffwll.ch>
References: <1330616161-1937-1-git-send-email-daniel.vetter@ffwll.ch> <1330616161-1937-3-git-send-email-daniel.vetter@ffwll.ch>
Date: Fri, 02 Mar 2012 22:38:58 +0000
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu,  1 Mar 2012 16:36:00 +0100, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> Big differences to other contenders in the field (like ion) is
> that this also supports highmem, so we have to split up the cpu
> access from the kernel side into a prepare and a kmap step.
> 
> Prepare is allowed to fail and should do everything required so that
> the kmap calls can succeed (like swapin/backing storage allocation,
> flushing, ...).
> 
> More in-depth explanations will follow in the follow-up documentation
> patch.
> 
> Changes in v2:
> 
> - Clear up begin_cpu_access confusion noticed by Sumit Semwal.
> - Don't automatically fallback from the _atomic variants to the
>   non-atomic variants. The _atomic callbacks are not allowed to
>   sleep, so we want exporters to make this decision explicit. The
>   function signatures are explicit, so simpler exporters can still
>   use the same function for both.
> - Make the unmap functions optional. Simpler exporters with permanent
>   mappings don't need to do anything at unmap time.

Are we going to have to have a dma_buf->ops->begin_async_access(&me, dir)
variant for coherency control of rendering with an imported dma_buf?
There is also no concurrency control here between multiple importers
doing simultaneous begin_cpu_access(). I presume that is going to be a
common function across all exporters so the midlayer might offer a
semaphore as a library function and then the
dma_buf->ops->begin_cpu_access() becomes mandatory as at a minimum it
has to point to the default implementation.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
