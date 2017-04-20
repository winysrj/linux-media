Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f172.google.com ([209.85.128.172]:34819 "EHLO
        mail-wr0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938686AbdDTIB6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Apr 2017 04:01:58 -0400
Received: by mail-wr0-f172.google.com with SMTP id o21so29997890wrb.2
        for <linux-media@vger.kernel.org>; Thu, 20 Apr 2017 01:01:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170420075054.yvsjzvuwb4yrzfuc@phenom.ffwll.local>
References: <1492630570-879-1-git-send-email-logang@deltatee.com> <20170420075054.yvsjzvuwb4yrzfuc@phenom.ffwll.local>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Thu, 20 Apr 2017 13:31:35 +0530
Message-ID: <CAO_48GGAXwZfhYq84sESCiffBRn0Uo8oObZeS=-3Pe7HnS_=Pw@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH v2] dma-buf: Rename dma-ops to prevent
 conflict with kunmap_atomic macro
To: Logan Gunthorpe <logang@deltatee.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-tegra@vger.kernel.org, devel@driverdev.osuosl.org,
        David Airlie <airlied@linux.ie>,
        Thierry Reding <thierry.reding@gmail.com>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Sinclair Yeh <syeh@vmware.com>,
        Russell King <linux@armlinux.org.uk>,
        Christoph Hellwig <hch@lst.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        VMware Graphics <linux-graphics-maintainer@vmware.com>,
        Laura Abbott <labbott@redhat.com>,
        Pawel Osciak <pawel@osciak.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Riley Andrews <riandrews@android.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Logan,

Thanks for the patch.

On 20 April 2017 at 13:21, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Wed, Apr 19, 2017 at 01:36:10PM -0600, Logan Gunthorpe wrote:
>> Seeing the kunmap_atomic dma_buf_ops share the same name with a macro
>> in highmem.h, the former can be aliased if any dma-buf user includes
>> that header.
>>
>> I'm personally trying to include highmem.h inside scatterlist.h and this
>> breaks the dma-buf code proper.
>>
>> Christoph Hellwig suggested [1] renaming it and pushing this patch ASAP.
>>
>> To maintain consistency I've renamed all four of kmap* and kunmap* to be
>> map* and unmap*. (Even though only kmap_atomic presently conflicts.)
>>
>> [1] https://www.spinics.net/lists/target-devel/msg15070.html
>>
>> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
>> Reviewed-by: Sinclair Yeh <syeh@vmware.com>
>
> Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Acked-by: Sumit Semwal <sumit.semwal@linaro.org>
>
> Probably simplest if we pull this in through the drm-misc tree for 4.12.
> Can we have an ack for the v4l side for that pls?
>
> Thanks, Daniel
>
>> ---
>>
>> Changes since v1:
>>
>> - Added the missing tegra driver (noticed by kbuild robot)
>> - Rebased off of drm-intel-next to get the i915 selftest that is new
>> - Fixed nits Sinclair pointed out.
>>
>>  drivers/dma-buf/dma-buf.c                      | 16 ++++++++--------
>>  drivers/gpu/drm/armada/armada_gem.c            |  8 ++++----
>>  drivers/gpu/drm/drm_prime.c                    |  8 ++++----
>>  drivers/gpu/drm/i915/i915_gem_dmabuf.c         |  8 ++++----
>>  drivers/gpu/drm/i915/selftests/mock_dmabuf.c   |  8 ++++----
>>  drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c      |  8 ++++----
>>  drivers/gpu/drm/tegra/gem.c                    |  8 ++++----
>>  drivers/gpu/drm/udl/udl_dmabuf.c               |  8 ++++----
>>  drivers/gpu/drm/vmwgfx/vmwgfx_prime.c          |  8 ++++----
>>  drivers/media/v4l2-core/videobuf2-dma-contig.c |  4 ++--
>>  drivers/media/v4l2-core/videobuf2-dma-sg.c     |  4 ++--
>>  drivers/media/v4l2-core/videobuf2-vmalloc.c    |  4 ++--
>>  drivers/staging/android/ion/ion.c              |  8 ++++----
>>  include/linux/dma-buf.h                        | 22 +++++++++++--------=
---
>>  14 files changed, 61 insertions(+), 61 deletions(-)
>>
>> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
>> index f72aaac..512bdbc 100644
>> --- a/drivers/dma-buf/dma-buf.c
>> +++ b/drivers/dma-buf/dma-buf.c
>> @@ -405,8 +405,8 @@ struct dma_buf *dma_buf_export(const struct dma_buf_=
export_info *exp_info)
>>                         || !exp_info->ops->map_dma_buf
>>                         || !exp_info->ops->unmap_dma_buf
>>                         || !exp_info->ops->release
>> -                       || !exp_info->ops->kmap_atomic
>> -                       || !exp_info->ops->kmap
>> +                       || !exp_info->ops->map_atomic
>> +                       || !exp_info->ops->map
>>                         || !exp_info->ops->mmap)) {
>>               return ERR_PTR(-EINVAL);
>>       }
>> @@ -872,7 +872,7 @@ void *dma_buf_kmap_atomic(struct dma_buf *dmabuf, un=
signed long page_num)
>>  {
>>       WARN_ON(!dmabuf);
>>
>> -     return dmabuf->ops->kmap_atomic(dmabuf, page_num);
>> +     return dmabuf->ops->map_atomic(dmabuf, page_num);
>>  }
>>  EXPORT_SYMBOL_GPL(dma_buf_kmap_atomic);
>>
>> @@ -889,8 +889,8 @@ void dma_buf_kunmap_atomic(struct dma_buf *dmabuf, u=
nsigned long page_num,
>>  {
>>       WARN_ON(!dmabuf);
>>
>> -     if (dmabuf->ops->kunmap_atomic)
>> -             dmabuf->ops->kunmap_atomic(dmabuf, page_num, vaddr);
>> +     if (dmabuf->ops->unmap_atomic)
>> +             dmabuf->ops->unmap_atomic(dmabuf, page_num, vaddr);
>>  }
>>  EXPORT_SYMBOL_GPL(dma_buf_kunmap_atomic);
>>
>> @@ -907,7 +907,7 @@ void *dma_buf_kmap(struct dma_buf *dmabuf, unsigned =
long page_num)
>>  {
>>       WARN_ON(!dmabuf);
>>
>> -     return dmabuf->ops->kmap(dmabuf, page_num);
>> +     return dmabuf->ops->map(dmabuf, page_num);
>>  }
>>  EXPORT_SYMBOL_GPL(dma_buf_kmap);
>>
>> @@ -924,8 +924,8 @@ void dma_buf_kunmap(struct dma_buf *dmabuf, unsigned=
 long page_num,
>>  {
>>       WARN_ON(!dmabuf);
>>
>> -     if (dmabuf->ops->kunmap)
>> -             dmabuf->ops->kunmap(dmabuf, page_num, vaddr);
>> +     if (dmabuf->ops->unmap)
>> +             dmabuf->ops->unmap(dmabuf, page_num, vaddr);
>>  }
>>  EXPORT_SYMBOL_GPL(dma_buf_kunmap);
>>
>> diff --git a/drivers/gpu/drm/armada/armada_gem.c b/drivers/gpu/drm/armad=
a/armada_gem.c
>> index 1597458..d6c2a5d 100644
>> --- a/drivers/gpu/drm/armada/armada_gem.c
>> +++ b/drivers/gpu/drm/armada/armada_gem.c
>> @@ -529,10 +529,10 @@ static const struct dma_buf_ops armada_gem_prime_d=
mabuf_ops =3D {
>>       .map_dma_buf    =3D armada_gem_prime_map_dma_buf,
>>       .unmap_dma_buf  =3D armada_gem_prime_unmap_dma_buf,
>>       .release        =3D drm_gem_dmabuf_release,
>> -     .kmap_atomic    =3D armada_gem_dmabuf_no_kmap,
>> -     .kunmap_atomic  =3D armada_gem_dmabuf_no_kunmap,
>> -     .kmap           =3D armada_gem_dmabuf_no_kmap,
>> -     .kunmap         =3D armada_gem_dmabuf_no_kunmap,
>> +     .map_atomic     =3D armada_gem_dmabuf_no_kmap,
>> +     .unmap_atomic   =3D armada_gem_dmabuf_no_kunmap,
>> +     .map            =3D armada_gem_dmabuf_no_kmap,
>> +     .unmap          =3D armada_gem_dmabuf_no_kunmap,
>>       .mmap           =3D armada_gem_dmabuf_mmap,
>>  };
>>
>> diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
>> index 9fb65b7..954eb84 100644
>> --- a/drivers/gpu/drm/drm_prime.c
>> +++ b/drivers/gpu/drm/drm_prime.c
>> @@ -403,10 +403,10 @@ static const struct dma_buf_ops drm_gem_prime_dmab=
uf_ops =3D  {
>>       .map_dma_buf =3D drm_gem_map_dma_buf,
>>       .unmap_dma_buf =3D drm_gem_unmap_dma_buf,
>>       .release =3D drm_gem_dmabuf_release,
>> -     .kmap =3D drm_gem_dmabuf_kmap,
>> -     .kmap_atomic =3D drm_gem_dmabuf_kmap_atomic,
>> -     .kunmap =3D drm_gem_dmabuf_kunmap,
>> -     .kunmap_atomic =3D drm_gem_dmabuf_kunmap_atomic,
>> +     .map =3D drm_gem_dmabuf_kmap,
>> +     .map_atomic =3D drm_gem_dmabuf_kmap_atomic,
>> +     .unmap =3D drm_gem_dmabuf_kunmap,
>> +     .unmap_atomic =3D drm_gem_dmabuf_kunmap_atomic,
>>       .mmap =3D drm_gem_dmabuf_mmap,
>>       .vmap =3D drm_gem_dmabuf_vmap,
>>       .vunmap =3D drm_gem_dmabuf_vunmap,
>> diff --git a/drivers/gpu/drm/i915/i915_gem_dmabuf.c b/drivers/gpu/drm/i9=
15/i915_gem_dmabuf.c
>> index 11898cd..f225bf6 100644
>> --- a/drivers/gpu/drm/i915/i915_gem_dmabuf.c
>> +++ b/drivers/gpu/drm/i915/i915_gem_dmabuf.c
>> @@ -200,10 +200,10 @@ static const struct dma_buf_ops i915_dmabuf_ops =
=3D  {
>>       .map_dma_buf =3D i915_gem_map_dma_buf,
>>       .unmap_dma_buf =3D i915_gem_unmap_dma_buf,
>>       .release =3D drm_gem_dmabuf_release,
>> -     .kmap =3D i915_gem_dmabuf_kmap,
>> -     .kmap_atomic =3D i915_gem_dmabuf_kmap_atomic,
>> -     .kunmap =3D i915_gem_dmabuf_kunmap,
>> -     .kunmap_atomic =3D i915_gem_dmabuf_kunmap_atomic,
>> +     .map =3D i915_gem_dmabuf_kmap,
>> +     .map_atomic =3D i915_gem_dmabuf_kmap_atomic,
>> +     .unmap =3D i915_gem_dmabuf_kunmap,
>> +     .unmap_atomic =3D i915_gem_dmabuf_kunmap_atomic,
>>       .mmap =3D i915_gem_dmabuf_mmap,
>>       .vmap =3D i915_gem_dmabuf_vmap,
>>       .vunmap =3D i915_gem_dmabuf_vunmap,
>> diff --git a/drivers/gpu/drm/i915/selftests/mock_dmabuf.c b/drivers/gpu/=
drm/i915/selftests/mock_dmabuf.c
>> index 99da8f4..302f7d1 100644
>> --- a/drivers/gpu/drm/i915/selftests/mock_dmabuf.c
>> +++ b/drivers/gpu/drm/i915/selftests/mock_dmabuf.c
>> @@ -129,10 +129,10 @@ static const struct dma_buf_ops mock_dmabuf_ops =
=3D  {
>>       .map_dma_buf =3D mock_map_dma_buf,
>>       .unmap_dma_buf =3D mock_unmap_dma_buf,
>>       .release =3D mock_dmabuf_release,
>> -     .kmap =3D mock_dmabuf_kmap,
>> -     .kmap_atomic =3D mock_dmabuf_kmap_atomic,
>> -     .kunmap =3D mock_dmabuf_kunmap,
>> -     .kunmap_atomic =3D mock_dmabuf_kunmap_atomic,
>> +     .map =3D mock_dmabuf_kmap,
>> +     .map_atomic =3D mock_dmabuf_kmap_atomic,
>> +     .unmap =3D mock_dmabuf_kunmap,
>> +     .unmap_atomic =3D mock_dmabuf_kunmap_atomic,
>>       .mmap =3D mock_dmabuf_mmap,
>>       .vmap =3D mock_dmabuf_vmap,
>>       .vunmap =3D mock_dmabuf_vunmap,
>> diff --git a/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c b/drivers/gpu/drm=
/omapdrm/omap_gem_dmabuf.c
>> index ee5883f..0dbe030 100644
>> --- a/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
>> +++ b/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
>> @@ -160,10 +160,10 @@ static struct dma_buf_ops omap_dmabuf_ops =3D {
>>       .release =3D omap_gem_dmabuf_release,
>>       .begin_cpu_access =3D omap_gem_dmabuf_begin_cpu_access,
>>       .end_cpu_access =3D omap_gem_dmabuf_end_cpu_access,
>> -     .kmap_atomic =3D omap_gem_dmabuf_kmap_atomic,
>> -     .kunmap_atomic =3D omap_gem_dmabuf_kunmap_atomic,
>> -     .kmap =3D omap_gem_dmabuf_kmap,
>> -     .kunmap =3D omap_gem_dmabuf_kunmap,
>> +     .map_atomic =3D omap_gem_dmabuf_kmap_atomic,
>> +     .unmap_atomic =3D omap_gem_dmabuf_kunmap_atomic,
>> +     .map =3D omap_gem_dmabuf_kmap,
>> +     .unmap =3D omap_gem_dmabuf_kunmap,
>>       .mmap =3D omap_gem_dmabuf_mmap,
>>  };
>>
>> diff --git a/drivers/gpu/drm/tegra/gem.c b/drivers/gpu/drm/tegra/gem.c
>> index 17e62ec..8672f5d 100644
>> --- a/drivers/gpu/drm/tegra/gem.c
>> +++ b/drivers/gpu/drm/tegra/gem.c
>> @@ -619,10 +619,10 @@ static const struct dma_buf_ops tegra_gem_prime_dm=
abuf_ops =3D {
>>       .map_dma_buf =3D tegra_gem_prime_map_dma_buf,
>>       .unmap_dma_buf =3D tegra_gem_prime_unmap_dma_buf,
>>       .release =3D tegra_gem_prime_release,
>> -     .kmap_atomic =3D tegra_gem_prime_kmap_atomic,
>> -     .kunmap_atomic =3D tegra_gem_prime_kunmap_atomic,
>> -     .kmap =3D tegra_gem_prime_kmap,
>> -     .kunmap =3D tegra_gem_prime_kunmap,
>> +     .map_atomic =3D tegra_gem_prime_kmap_atomic,
>> +     .unmap_atomic =3D tegra_gem_prime_kunmap_atomic,
>> +     .map =3D tegra_gem_prime_kmap,
>> +     .unmap =3D tegra_gem_prime_kunmap,
>>       .mmap =3D tegra_gem_prime_mmap,
>>       .vmap =3D tegra_gem_prime_vmap,
>>       .vunmap =3D tegra_gem_prime_vunmap,
>> diff --git a/drivers/gpu/drm/udl/udl_dmabuf.c b/drivers/gpu/drm/udl/udl_=
dmabuf.c
>> index ac90ffd..ed0e636 100644
>> --- a/drivers/gpu/drm/udl/udl_dmabuf.c
>> +++ b/drivers/gpu/drm/udl/udl_dmabuf.c
>> @@ -191,10 +191,10 @@ static struct dma_buf_ops udl_dmabuf_ops =3D {
>>       .detach                 =3D udl_detach_dma_buf,
>>       .map_dma_buf            =3D udl_map_dma_buf,
>>       .unmap_dma_buf          =3D udl_unmap_dma_buf,
>> -     .kmap                   =3D udl_dmabuf_kmap,
>> -     .kmap_atomic            =3D udl_dmabuf_kmap_atomic,
>> -     .kunmap                 =3D udl_dmabuf_kunmap,
>> -     .kunmap_atomic          =3D udl_dmabuf_kunmap_atomic,
>> +     .map                    =3D udl_dmabuf_kmap,
>> +     .map_atomic             =3D udl_dmabuf_kmap_atomic,
>> +     .unmap                  =3D udl_dmabuf_kunmap,
>> +     .unmap_atomic           =3D udl_dmabuf_kunmap_atomic,
>>       .mmap                   =3D udl_dmabuf_mmap,
>>       .release                =3D drm_gem_dmabuf_release,
>>  };
>> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_prime.c b/drivers/gpu/drm/vmw=
gfx/vmwgfx_prime.c
>> index 31fe32d..0d42a46 100644
>> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_prime.c
>> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_prime.c
>> @@ -108,10 +108,10 @@ const struct dma_buf_ops vmw_prime_dmabuf_ops =3D =
 {
>>       .map_dma_buf =3D vmw_prime_map_dma_buf,
>>       .unmap_dma_buf =3D vmw_prime_unmap_dma_buf,
>>       .release =3D NULL,
>> -     .kmap =3D vmw_prime_dmabuf_kmap,
>> -     .kmap_atomic =3D vmw_prime_dmabuf_kmap_atomic,
>> -     .kunmap =3D vmw_prime_dmabuf_kunmap,
>> -     .kunmap_atomic =3D vmw_prime_dmabuf_kunmap_atomic,
>> +     .map =3D vmw_prime_dmabuf_kmap,
>> +     .map_atomic =3D vmw_prime_dmabuf_kmap_atomic,
>> +     .unmap =3D vmw_prime_dmabuf_kunmap,
>> +     .unmap_atomic =3D vmw_prime_dmabuf_kunmap_atomic,
>>       .mmap =3D vmw_prime_dmabuf_mmap,
>>       .vmap =3D vmw_prime_dmabuf_vmap,
>>       .vunmap =3D vmw_prime_dmabuf_vunmap,
>> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/me=
dia/v4l2-core/videobuf2-dma-contig.c
>> index fb6a177..2db0413 100644
>> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
>> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
>> @@ -356,8 +356,8 @@ static struct dma_buf_ops vb2_dc_dmabuf_ops =3D {
>>       .detach =3D vb2_dc_dmabuf_ops_detach,
>>       .map_dma_buf =3D vb2_dc_dmabuf_ops_map,
>>       .unmap_dma_buf =3D vb2_dc_dmabuf_ops_unmap,
>> -     .kmap =3D vb2_dc_dmabuf_ops_kmap,
>> -     .kmap_atomic =3D vb2_dc_dmabuf_ops_kmap,
>> +     .map =3D vb2_dc_dmabuf_ops_kmap,
>> +     .map_atomic =3D vb2_dc_dmabuf_ops_kmap,
>>       .vmap =3D vb2_dc_dmabuf_ops_vmap,
>>       .mmap =3D vb2_dc_dmabuf_ops_mmap,
>>       .release =3D vb2_dc_dmabuf_ops_release,
>> diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/=
v4l2-core/videobuf2-dma-sg.c
>> index ecff8f4..6fd1343 100644
>> --- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
>> +++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
>> @@ -504,8 +504,8 @@ static struct dma_buf_ops vb2_dma_sg_dmabuf_ops =3D =
{
>>       .detach =3D vb2_dma_sg_dmabuf_ops_detach,
>>       .map_dma_buf =3D vb2_dma_sg_dmabuf_ops_map,
>>       .unmap_dma_buf =3D vb2_dma_sg_dmabuf_ops_unmap,
>> -     .kmap =3D vb2_dma_sg_dmabuf_ops_kmap,
>> -     .kmap_atomic =3D vb2_dma_sg_dmabuf_ops_kmap,
>> +     .map =3D vb2_dma_sg_dmabuf_ops_kmap,
>> +     .map_atomic =3D vb2_dma_sg_dmabuf_ops_kmap,
>>       .vmap =3D vb2_dma_sg_dmabuf_ops_vmap,
>>       .mmap =3D vb2_dma_sg_dmabuf_ops_mmap,
>>       .release =3D vb2_dma_sg_dmabuf_ops_release,
>> diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media=
/v4l2-core/videobuf2-vmalloc.c
>> index 3f77814..27d1db3 100644
>> --- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
>> +++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
>> @@ -342,8 +342,8 @@ static struct dma_buf_ops vb2_vmalloc_dmabuf_ops =3D=
 {
>>       .detach =3D vb2_vmalloc_dmabuf_ops_detach,
>>       .map_dma_buf =3D vb2_vmalloc_dmabuf_ops_map,
>>       .unmap_dma_buf =3D vb2_vmalloc_dmabuf_ops_unmap,
>> -     .kmap =3D vb2_vmalloc_dmabuf_ops_kmap,
>> -     .kmap_atomic =3D vb2_vmalloc_dmabuf_ops_kmap,
>> +     .map =3D vb2_vmalloc_dmabuf_ops_kmap,
>> +     .map_atomic =3D vb2_vmalloc_dmabuf_ops_kmap,
>>       .vmap =3D vb2_vmalloc_dmabuf_ops_vmap,
>>       .mmap =3D vb2_vmalloc_dmabuf_ops_mmap,
>>       .release =3D vb2_vmalloc_dmabuf_ops_release,
>> diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android=
/ion/ion.c
>> index f45115f..95a7f16 100644
>> --- a/drivers/staging/android/ion/ion.c
>> +++ b/drivers/staging/android/ion/ion.c
>> @@ -1020,10 +1020,10 @@ static const struct dma_buf_ops dma_buf_ops =3D =
{
>>       .release =3D ion_dma_buf_release,
>>       .begin_cpu_access =3D ion_dma_buf_begin_cpu_access,
>>       .end_cpu_access =3D ion_dma_buf_end_cpu_access,
>> -     .kmap_atomic =3D ion_dma_buf_kmap,
>> -     .kunmap_atomic =3D ion_dma_buf_kunmap,
>> -     .kmap =3D ion_dma_buf_kmap,
>> -     .kunmap =3D ion_dma_buf_kunmap,
>> +     .map_atomic =3D ion_dma_buf_kmap,
>> +     .unmap_atomic =3D ion_dma_buf_kunmap,
>> +     .map =3D ion_dma_buf_kmap,
>> +     .unmap =3D ion_dma_buf_kunmap,
>>  };
>>
>>  struct dma_buf *ion_share_dma_buf(struct ion_client *client,
>> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
>> index bfb3704..79f27d6 100644
>> --- a/include/linux/dma-buf.h
>> +++ b/include/linux/dma-buf.h
>> @@ -39,13 +39,13 @@ struct dma_buf_attachment;
>>
>>  /**
>>   * struct dma_buf_ops - operations possible on struct dma_buf
>> - * @kmap_atomic: maps a page from the buffer into kernel address
>> - *            space, users may not block until the subsequent unmap cal=
l.
>> - *            This callback must not sleep.
>> - * @kunmap_atomic: [optional] unmaps a atomically mapped page from the =
buffer.
>> - *              This Callback must not sleep.
>> - * @kmap: maps a page from the buffer into kernel address space.
>> - * @kunmap: [optional] unmaps a page from the buffer.
>> + * @map_atomic: maps a page from the buffer into kernel address
>> + *           space, users may not block until the subsequent unmap call=
.
>> + *           This callback must not sleep.
>> + * @unmap_atomic: [optional] unmaps a atomically mapped page from the b=
uffer.
>> + *             This Callback must not sleep.
>> + * @map: maps a page from the buffer into kernel address space.
>> + * @unmap: [optional] unmaps a page from the buffer.
>>   * @vmap: [optional] creates a virtual mapping for the buffer into kern=
el
>>   *     address space. Same restrictions as for vmap and friends apply.
>>   * @vunmap: [optional] unmaps a vmap from the buffer
>> @@ -206,10 +206,10 @@ struct dma_buf_ops {
>>        * to be restarted.
>>        */
>>       int (*end_cpu_access)(struct dma_buf *, enum dma_data_direction);
>> -     void *(*kmap_atomic)(struct dma_buf *, unsigned long);
>> -     void (*kunmap_atomic)(struct dma_buf *, unsigned long, void *);
>> -     void *(*kmap)(struct dma_buf *, unsigned long);
>> -     void (*kunmap)(struct dma_buf *, unsigned long, void *);
>> +     void *(*map_atomic)(struct dma_buf *, unsigned long);
>> +     void (*unmap_atomic)(struct dma_buf *, unsigned long, void *);
>> +     void *(*map)(struct dma_buf *, unsigned long);
>> +     void (*unmap)(struct dma_buf *, unsigned long, void *);
>>
>>       /**
>>        * @mmap:
>> --
>> 2.1.4
>> _______________________________________________
>> Intel-gfx mailing list
>> Intel-gfx@lists.freedesktop.org
>> https://lists.freedesktop.org/mailman/listinfo/intel-gfx
>
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> http://blog.ffwll.ch



--=20
Thanks and regards,

Sumit Semwal
Linaro Mobile Group - Kernel Team Lead
Linaro.org =E2=94=82 Open source software for ARM SoCs
