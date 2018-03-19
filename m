Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.fireflyinternet.com ([109.228.58.192]:63035 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S934239AbeCSPxa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Mar 2018 11:53:30 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: Chris Wilson <chris@chris-wilson.co.uk>
To: christian.koenig@amd.com,
        =?utf-8?q?Christian_K=C3=B6nig?= <ckoenig.leichtzumerken@gmail.com>,
        linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org
References: <20180316132049.1748-1-christian.koenig@amd.com>
 <20180316132049.1748-2-christian.koenig@amd.com>
 <152120831102.25315.4326885184264378830@mail.alporthouse.com>
 <21879456-db47-589c-b5e2-dfe8333d9e4c@gmail.com>
In-Reply-To: <21879456-db47-589c-b5e2-dfe8333d9e4c@gmail.com>
Message-ID: <152147480241.18954.4556582215766884582@mail.alporthouse.com>
Subject: Re: [PATCH 1/5] dma-buf: add optional invalidate_mappings callback v2
Date: Mon, 19 Mar 2018 15:53:22 +0000
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Quoting Christian König (2018-03-16 14:22:32)
[snip, probably lost too must context]
> This allows for full grown pipelining, e.g. the exporter can say I need 
> to move the buffer for some operation. Then let the move operation wait 
> for all existing fences in the reservation object and install the fence 
> of the move operation as exclusive fence.

Ok, the situation I have in mind is the non-pipelined case: revoking
dma-buf for mmu_invalidate_range or shrink_slab. I would need a
completion event that can be waited on the cpu for all the invalidate
callbacks. (Essentially an atomic_t counter plus struct completion; a
lighter version of dma_fence, I wonder where I've seen that before ;)

Even so, it basically means passing a fence object down to the async
callbacks for them to signal when they are complete. Just to handle the
non-pipelined version. :|
-Chris
