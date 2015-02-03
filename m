Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:51930 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbbBCJ3X (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Feb 2015 04:29:23 -0500
Received: by mail-wi0-f173.google.com with SMTP id r20so22716338wiv.0
        for <linux-media@vger.kernel.org>; Tue, 03 Feb 2015 01:29:22 -0800 (PST)
Message-ID: <54D094F1.50404@linaro.org>
Date: Tue, 03 Feb 2015 09:29:21 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
MIME-Version: 1.0
To: Sumit Semwal <sumit.semwal@linaro.org>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org, rmk+kernel@arm.linux.org.uk,
	airlied@linux.ie, kgene@kernel.org, daniel.vetter@intel.com,
	thierry.reding@gmail.com, pawel@osciak.com,
	m.szyprowski@samsung.com, mchehab@osg.samsung.com,
	gregkh@linuxfoundation.org
CC: linaro-kernel@lists.linaro.org, intel-gfx@lists.freedesktop.org,
	linux-tegra@vger.kernel.org
Subject: Re: [PATCH v3] dma-buf: cleanup dma_buf_export() to make it easily
 extensible
References: <1422449643-7829-1-git-send-email-sumit.semwal@linaro.org>
In-Reply-To: <1422449643-7829-1-git-send-email-sumit.semwal@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 28/01/15 12:54, Sumit Semwal wrote:
> At present, dma_buf_export() takes a series of parameters, which
> makes it difficult to add any new parameters for exporters, if required.
> 
> Make it simpler by moving all these parameters into a struct, and pass
> the struct * as parameter to dma_buf_export().
> 
> While at it, unite dma_buf_export_named() with dma_buf_export(), and
> change all callers accordingly.
> 
> Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>

Sorry, a few more comments. Should have sent these before but at least
the are all related only to documentation. Once that is fixed then:
Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>


> ---
> v3: Daniel Thompson caught the C99 warning issue w/ using {0}; using
>     {.exp_name = xxx} instead.
> 
> v2: add macro to zero out local struct, and fill KBUILD_MODNAME by default
> 
>  drivers/dma-buf/dma-buf.c                      | 47 +++++++++++++-------------
>  drivers/gpu/drm/armada/armada_gem.c            | 10 ++++--
>  drivers/gpu/drm/drm_prime.c                    | 12 ++++---
>  drivers/gpu/drm/exynos/exynos_drm_dmabuf.c     |  9 +++--
>  drivers/gpu/drm/i915/i915_gem_dmabuf.c         | 10 ++++--
>  drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c      |  9 ++++-
>  drivers/gpu/drm/tegra/gem.c                    | 10 ++++--
>  drivers/gpu/drm/ttm/ttm_object.c               |  9 +++--
>  drivers/gpu/drm/udl/udl_dmabuf.c               |  9 ++++-
>  drivers/media/v4l2-core/videobuf2-dma-contig.c |  8 ++++-
>  drivers/media/v4l2-core/videobuf2-dma-sg.c     |  8 ++++-
>  drivers/media/v4l2-core/videobuf2-vmalloc.c    |  8 ++++-
>  drivers/staging/android/ion/ion.c              |  9 +++--
>  include/linux/dma-buf.h                        | 34 +++++++++++++++----

Documentation/dma-buf-sharing.txt needs updating as a result of these
changes but its not in the diffstat.


>  14 files changed, 142 insertions(+), 50 deletions(-)
> 
> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index 5be225c2ba98..6d3df3dd9310 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -265,7 +265,7 @@ static inline int is_dma_buf_file(struct file *file)
>  }
>  
>  /**
> - * dma_buf_export_named - Creates a new dma_buf, and associates an anon file
> + * dma_buf_export - Creates a new dma_buf, and associates an anon file
>   * with this buffer, so it can be exported.
>   * Also connect the allocator specific data and ops to the buffer.
>   * Additionally, provide a name string for exporter; useful in debugging.
> @@ -277,31 +277,32 @@ static inline int is_dma_buf_file(struct file *file)
>   * @exp_name:	[in]	name of the exporting module - useful for debugging.
>   * @resv:	[in]	reservation-object, NULL to allocate default one.
>   *
> + * All the above info comes from struct dma_buf_export_info.
> + *

I'm not at all sure about this. Its a novel trick but won't this make
the HTML docs come out looking a bit weird? Is there any prior art for
double-documenting the structure members like this?


Daniel.
