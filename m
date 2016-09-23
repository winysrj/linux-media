Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.goneo.de ([85.220.129.33]:58496 "EHLO smtp2.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965693AbcIWNfQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Sep 2016 09:35:16 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH 06/11] dma-buf: Introduce fence_get_rcu_safe()
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <20160923125932.GG3988@dvetter-linux.ger.corp.intel.com>
Date: Fri, 23 Sep 2016 15:34:32 +0200
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org
Content-Transfer-Encoding: 8BIT
Message-Id: <D6338AA5-B3C3-48DE-9318-B7255F1F2E84@darmarit.de>
References: <20160829070834.22296-1-chris@chris-wilson.co.uk> <20160829070834.22296-6-chris@chris-wilson.co.uk> <20160923125932.GG3988@dvetter-linux.ger.corp.intel.com>
To: Daniel Vetter <daniel@ffwll.ch>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 23.09.2016 um 14:59 schrieb Daniel Vetter <daniel@ffwll.ch>:

>> 
>> /**
>> - * fence_put - decreases refcount of the fence
>> - * @fence:	[in]	fence to reduce refcount of
>> + * fence_get_rcu_safe  - acquire a reference to an RCU tracked fence
>> + * @fence:	[in]	pointer to fence to increase refcount of
>> + *
>> + * Function returns NULL if no refcount could be obtained, or the fence.
>> + * This function handles acquiring a reference to a fence that may be
>> + * reallocated within the RCU grace period (such as with SLAB_DESTROY_BY_RCU),
>> + * so long as the caller is using RCU on the pointer to the fence.
>> + *
>> + * An alternative mechanism is to employ a seqlock to protect a bunch of
>> + * fences, such as used by struct reservation_object. When using a seqlock,
>> + * the seqlock must be taken before and checked after a reference to the
>> + * fence is acquired (as shown here).
>> + *
>> + * The caller is required to hold the RCU read lock.
> 
> Would be good to cross reference the various fence_get functions a bit
> better in the docs. But since the docs aren't yet pulled into the rst/html
> output, that doesn't matter that much

Hi Daniel ... I'am working on ;-)

* http://return42.github.io/sphkerneldoc/linux_src_doc/include/linux/fence_h.html

-- Markus 