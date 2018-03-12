Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:53468 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932588AbeCLRYG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Mar 2018 13:24:06 -0400
Received: by mail-wm0-f49.google.com with SMTP id e194so18148115wmd.3
        for <linux-media@vger.kernel.org>; Mon, 12 Mar 2018 10:24:05 -0700 (PDT)
Date: Mon, 12 Mar 2018 18:24:01 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Christian K??nig <ckoenig.leichtzumerken@gmail.com>
Cc: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org
Subject: Re: RFC: unpinned DMA-buf exporting
Message-ID: <20180312172401.GM8589@phenom.ffwll.local>
References: <20180309191144.1817-1-christian.koenig@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180309191144.1817-1-christian.koenig@amd.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 09, 2018 at 08:11:40PM +0100, Christian K??nig wrote:
> This set of patches adds an option invalidate_mappings callback to each
> DMA-buf attachment which can be filled in by the importer.
> 
> This callback allows the exporter to provided the DMA-buf content
> without pinning it. The reservation objects lock acts as synchronization
> point for buffer moves and creating mappings.
> 
> This set includes an implementation for amdgpu which should be rather
> easily portable to other DRM drivers.

Bunch of higher level comments, and one I've forgotten in reply to patch
1:

- What happens when a dma-buf is pinned (e.g. i915 loves to pin buffers
  for scanout)?

- pulling the dma-buf implementations into amdgpu makes sense, that's
  kinda how it was meant to be anyway. The gem prime helpers are a bit too
  much midlayer for my taste (mostly because nvidia wanted to bypass the
  EXPORT_SYMBOL_GPL of core dma-buf, hooray for legal bs). We can always
  extract more helpers once there's more ttm based drivers doing this.

Overall I like, there's some details to figure out first.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
