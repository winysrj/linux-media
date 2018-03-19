Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:51256 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754166AbeCSOJk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Mar 2018 10:09:40 -0400
Received: by mail-wm0-f53.google.com with SMTP id h21so15400206wmd.1
        for <linux-media@vger.kernel.org>; Mon, 19 Mar 2018 07:09:40 -0700 (PDT)
Date: Mon, 19 Mar 2018 15:09:36 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Christian =?iso-8859-1?Q?K=F6nig?=
        <ckoenig.leichtzumerken@gmail.com>
Cc: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org
Subject: Re: RFC: unpinned DMA-buf exporting v2
Message-ID: <20180319140936.GO14155@phenom.ffwll.local>
References: <20180316132049.1748-1-christian.koenig@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180316132049.1748-1-christian.koenig@amd.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 16, 2018 at 02:20:44PM +0100, Christian König wrote:
> Hi everybody,
> 
> since I've got positive feedback from Daniel I continued working on this approach.
> 
> A few issues are still open:
> 1. Daniel suggested that I make the invalidate_mappings callback a parameter of dma_buf_attach().
> 
> This approach unfortunately won't work because when the attachment is
> created the importer is not necessarily ready to handle invalidation
> events.

Why do you have this constraint? This sounds a bit like inverted
create/teardown sequence troubles, where you make an object "life" before
the thing is fully set up.

Can't we fix this by creating the entire ttm scaffolding you'll need for a
dma-buf upfront, and only once you have everything we grab the dma_buf
attachment? At that point you really should be able to evict buffers
again.

Not requiring invalidate_mapping to be set together with the attachment
means we can't ever require importers to support it (e.g. to address your
concern with the userspace dma-buf userptr magic).

> E.g. in the amdgpu example we first need to setup the imported GEM/TMM
> objects and install that in the attachment.
> 
> My solution is to introduce a separate function to grab the locks and
> set the callback, this function could then be used to pin the buffer
> later on if that turns out to be necessary after all.
> 
> 2. With my example setup this currently results in a ping/pong situation
> because the exporter prefers a VRAM placement while the importer prefers
> a GTT placement.
> 
> This results in quite a performance drop, but can be fixed by a simple
> mesa patch which allows shred BOs to be placed in both VRAM and GTT.
> 
> Question is what should we do in the meantime? Accept the performance
> drop or only allow unpinned sharing with new Mesa?

Maybe the exporter should not try to move stuff back into VRAM as long as
there's an active dma-buf? I mean it's really cool that it works, but
maybe let's just do this for a tech demo :-)

Of course if it then runs out of TT then it could still try to move it
back in. And "let's not move it when it's imported" is probably too stupid
too, and will need to be improved again with more heuristics, but would at
least get it off the ground.

Long term you might want to move perhaps once per 10 seconds or so, to get
idle importers to detach. Adjust 10s to match whatever benchmark/workload
you care about.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
