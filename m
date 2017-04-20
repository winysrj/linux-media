Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:33346 "EHLO
        mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936444AbdDTA2v (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Apr 2017 20:28:51 -0400
Received: by mail-io0-f169.google.com with SMTP id k87so44882001ioi.0
        for <linux-media@vger.kernel.org>; Wed, 19 Apr 2017 17:28:51 -0700 (PDT)
Subject: Re: [PATCH v2] dma-buf: Rename dma-ops to prevent conflict with
 kunmap_atomic macro
To: Logan Gunthorpe <logang@deltatee.com>,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Christoph Hellwig <hch@lst.de>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Sean Paul <seanpaul@chromium.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        VMware Graphics <linux-graphics-maintainer@vmware.com>,
        Sinclair Yeh <syeh@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?Q?Arve_Hj=c3=b8nnev=c3=a5g?= <arve@android.com>,
        Riley Andrews <riandrews@android.com>
References: <1492630570-879-1-git-send-email-logang@deltatee.com>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <69283988-3a6b-fba3-529a-d5ad70eda32b@redhat.com>
Date: Wed, 19 Apr 2017 17:28:46 -0700
MIME-Version: 1.0
In-Reply-To: <1492630570-879-1-git-send-email-logang@deltatee.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/19/2017 12:36 PM, Logan Gunthorpe wrote:
> Seeing the kunmap_atomic dma_buf_ops share the same name with a macro
> in highmem.h, the former can be aliased if any dma-buf user includes
> that header.
> 
> I'm personally trying to include highmem.h inside scatterlist.h and this
> breaks the dma-buf code proper.
> 
> Christoph Hellwig suggested [1] renaming it and pushing this patch ASAP.
> 
> To maintain consistency I've renamed all four of kmap* and kunmap* to be
> map* and unmap*. (Even though only kmap_atomic presently conflicts.)
> 
> [1] https://www.spinics.net/lists/target-devel/msg15070.html
> 
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> Reviewed-by: Sinclair Yeh <syeh@vmware.com>
> ---
> 
> Changes since v1:
> 
> - Added the missing tegra driver (noticed by kbuild robot)
> - Rebased off of drm-intel-next to get the i915 selftest that is new
> - Fixed nits Sinclair pointed out.
> 
>   drivers/dma-buf/dma-buf.c                      | 16 ++++++++--------
>   drivers/gpu/drm/armada/armada_gem.c            |  8 ++++----
>   drivers/gpu/drm/drm_prime.c                    |  8 ++++----
>   drivers/gpu/drm/i915/i915_gem_dmabuf.c         |  8 ++++----
>   drivers/gpu/drm/i915/selftests/mock_dmabuf.c   |  8 ++++----
>   drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c      |  8 ++++----
>   drivers/gpu/drm/tegra/gem.c                    |  8 ++++----
>   drivers/gpu/drm/udl/udl_dmabuf.c               |  8 ++++----
>   drivers/gpu/drm/vmwgfx/vmwgfx_prime.c          |  8 ++++----
>   drivers/media/v4l2-core/videobuf2-dma-contig.c |  4 ++--
>   drivers/media/v4l2-core/videobuf2-dma-sg.c     |  4 ++--
>   drivers/media/v4l2-core/videobuf2-vmalloc.c    |  4 ++--
>   drivers/staging/android/ion/ion.c              |  8 ++++----
>   include/linux/dma-buf.h                        | 22 +++++++++++-----------
>   14 files changed, 61 insertions(+), 61 deletions(-)
> 

For Ion,

Acked-by: Laura Abbott <labbott@redhat.com>

I did some major Ion refactoring but I don't think this
will conflict.

Thanks,
Laura
