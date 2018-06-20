Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:40351 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753644AbeFTGK3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 02:10:29 -0400
Received: by mail-ot0-f194.google.com with SMTP id w9-v6so2432790otj.7
        for <linux-media@vger.kernel.org>; Tue, 19 Jun 2018 23:10:29 -0700 (PDT)
MIME-Version: 1.0
References: <20180601120020.11520-1-christian.koenig@amd.com>
 <20180601120020.11520-2-christian.koenig@amd.com> <20180618081845.GV3438@phenom.ffwll.local>
 <2bcb34c3-b729-e3ea-fb8c-2471e4ed56d6@amd.com>
In-Reply-To: <2bcb34c3-b729-e3ea-fb8c-2471e4ed56d6@amd.com>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Wed, 20 Jun 2018 11:40:17 +0530
Message-ID: <CAO_48GG=whv7R5J1E-xHdZJYFsfYwgnyDq8CzKZktro60m1c+g@mail.gmail.com>
Subject: Re: [PATCH 2/5] dma-buf: remove kmap_atomic interface
To: Christian Koenig <christian.koenig@amd.com>
Cc: Daniel Vetter <daniel@ffwll.ch>,
        Linaro MM SIG <linaro-mm-sig@lists.linaro.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Christian,
On Tue, 19 Jun 2018 at 20:17, Christian K=C3=B6nig <christian.koenig@amd.co=
m> wrote:
>
> Am 18.06.2018 um 10:18 schrieb Daniel Vetter:
> > On Fri, Jun 01, 2018 at 02:00:17PM +0200, Christian K=C3=B6nig wrote:
> >> Neither used nor correctly implemented anywhere. Just completely remov=
e
> >> the interface.
> >>
> >> Signed-off-by: Christian K=C3=B6nig <christian.koenig@amd.com>
> > I wonder whether we can nuke the normal kmap stuff too ... everyone see=
ms
> > to want/use the vmap stuff for kernel-internal mapping needs.
> >
> > Anyway, this looks good.
Hope am not too late (was out of office for some time) - this looks ok
to me, please feel free to add my
Acked-by: Sumit Semwal <sumit.semwal@linaro.org>

> >> ---
> >>   drivers/dma-buf/dma-buf.c                          | 44 ------------=
----------
> >>   drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c          |  2 -
> >>   drivers/gpu/drm/armada/armada_gem.c                |  2 -
> >>   drivers/gpu/drm/drm_prime.c                        | 26 ------------=
-
> >>   drivers/gpu/drm/i915/i915_gem_dmabuf.c             | 11 ------
> >>   drivers/gpu/drm/i915/selftests/mock_dmabuf.c       |  2 -
> >>   drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c          |  2 -
> >>   drivers/gpu/drm/tegra/gem.c                        | 14 -------
> >>   drivers/gpu/drm/udl/udl_dmabuf.c                   | 17 ---------
> >>   drivers/gpu/drm/vmwgfx/vmwgfx_prime.c              | 13 -------
> >>   .../media/common/videobuf2/videobuf2-dma-contig.c  |  1 -
> >>   drivers/media/common/videobuf2/videobuf2-dma-sg.c  |  1 -
> >>   drivers/media/common/videobuf2/videobuf2-vmalloc.c |  1 -
> >>   drivers/staging/android/ion/ion.c                  |  2 -
> >>   drivers/tee/tee_shm.c                              |  6 ---
> >>   include/drm/drm_prime.h                            |  4 --
> >>   include/linux/dma-buf.h                            |  4 --
> >>   17 files changed, 152 deletions(-)
> >>
> >> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> >> index e99a8d19991b..e4c657d9fad7 100644
> >> --- a/drivers/dma-buf/dma-buf.c
> >> +++ b/drivers/dma-buf/dma-buf.c
> >> @@ -405,7 +405,6 @@ struct dma_buf *dma_buf_export(const struct dma_bu=
f_export_info *exp_info)
> >>                        || !exp_info->ops->map_dma_buf
> >>                        || !exp_info->ops->unmap_dma_buf
> >>                        || !exp_info->ops->release
> >> -                      || !exp_info->ops->map_atomic
> >>                        || !exp_info->ops->map
> >>                        || !exp_info->ops->mmap)) {
> >>              return ERR_PTR(-EINVAL);
> >> @@ -687,14 +686,6 @@ EXPORT_SYMBOL_GPL(dma_buf_unmap_attachment);
> >>    *      void \*dma_buf_kmap(struct dma_buf \*, unsigned long);
> >>    *      void dma_buf_kunmap(struct dma_buf \*, unsigned long, void \=
*);
> >>    *
> >> - *   There are also atomic variants of these interfaces. Like for kma=
p they
> >> - *   facilitate non-blocking fast-paths. Neither the importer nor the=
 exporter
> >> - *   (in the callback) is allowed to block when using these.
> >> - *
> >> - *   Interfaces::
> >> - *      void \*dma_buf_kmap_atomic(struct dma_buf \*, unsigned long);
> >> - *      void dma_buf_kunmap_atomic(struct dma_buf \*, unsigned long, =
void \*);
> >> - *
> >>    *   For importers all the restrictions of using kmap apply, like th=
e limited
> >>    *   supply of kmap_atomic slots. Hence an importer shall only hold =
onto at
> >>    *   max 2 atomic dma_buf kmaps at the same time (in any given proce=
ss context).
> > This is also about atomic kmap ...
> >
> > And the subsequent language around "Note that these calls need to alway=
s
> > succeed." is also not true, might be good to update that stating that k=
map
> > is optional (like we say already for vmap).
> >
> > With those docs nits addressed:
> >
> > Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>
> I've fixed up patch #1 and #2 and added your Reviewed-by tag.
>
> Since I finally had time to install dim do you have any objections that
> I now run "dim push drm-misc-next" with those two applied?
>
> Regards,
> Christian.
>
> >
> >> @@ -859,41 +850,6 @@ int dma_buf_end_cpu_access(struct dma_buf *dmabuf=
,
> >>   }
> >>   EXPORT_SYMBOL_GPL(dma_buf_end_cpu_access);
> >>
> >> -/**
> >> - * dma_buf_kmap_atomic - Map a page of the buffer object into kernel =
address
> >> - * space. The same restrictions as for kmap_atomic and friends apply.
> >> - * @dmabuf: [in]    buffer to map page from.
> >> - * @page_num:       [in]    page in PAGE_SIZE units to map.
> >> - *
> >> - * This call must always succeed, any necessary preparations that mig=
ht fail
> >> - * need to be done in begin_cpu_access.
> >> - */
> >> -void *dma_buf_kmap_atomic(struct dma_buf *dmabuf, unsigned long page_=
num)
> >> -{
> >> -    WARN_ON(!dmabuf);
> >> -
> >> -    return dmabuf->ops->map_atomic(dmabuf, page_num);
> >> -}
> >> -EXPORT_SYMBOL_GPL(dma_buf_kmap_atomic);
> >> -
> >> -/**
> >> - * dma_buf_kunmap_atomic - Unmap a page obtained by dma_buf_kmap_atom=
ic.
> >> - * @dmabuf: [in]    buffer to unmap page from.
> >> - * @page_num:       [in]    page in PAGE_SIZE units to unmap.
> >> - * @vaddr:  [in]    kernel space pointer obtained from dma_buf_kmap_a=
tomic.
> >> - *
> >> - * This call must always succeed.
> >> - */
> >> -void dma_buf_kunmap_atomic(struct dma_buf *dmabuf, unsigned long page=
_num,
> >> -                       void *vaddr)
> >> -{
> >> -    WARN_ON(!dmabuf);
> >> -
> >> -    if (dmabuf->ops->unmap_atomic)
> >> -            dmabuf->ops->unmap_atomic(dmabuf, page_num, vaddr);
> >> -}
> >> -EXPORT_SYMBOL_GPL(dma_buf_kunmap_atomic);
> >> -
> >>   /**
> >>    * dma_buf_kmap - Map a page of the buffer object into kernel addres=
s space. The
> >>    * same restrictions as for kmap and friends apply.
> >> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c b/drivers/gpu/d=
rm/amd/amdgpu/amdgpu_prime.c
> >> index f1500f1ec0f5..a156b3891a3f 100644
> >> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c
> >> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c
> >> @@ -244,9 +244,7 @@ static const struct dma_buf_ops amdgpu_dmabuf_ops =
=3D {
> >>      .release =3D drm_gem_dmabuf_release,
> >>      .begin_cpu_access =3D amdgpu_gem_begin_cpu_access,
> >>      .map =3D drm_gem_dmabuf_kmap,
> >> -    .map_atomic =3D drm_gem_dmabuf_kmap_atomic,
> >>      .unmap =3D drm_gem_dmabuf_kunmap,
> >> -    .unmap_atomic =3D drm_gem_dmabuf_kunmap_atomic,
> >>      .mmap =3D drm_gem_dmabuf_mmap,
> >>      .vmap =3D drm_gem_dmabuf_vmap,
> >>      .vunmap =3D drm_gem_dmabuf_vunmap,
> >> diff --git a/drivers/gpu/drm/armada/armada_gem.c b/drivers/gpu/drm/arm=
ada/armada_gem.c
> >> index a97f509743a5..3fb37c75c065 100644
> >> --- a/drivers/gpu/drm/armada/armada_gem.c
> >> +++ b/drivers/gpu/drm/armada/armada_gem.c
> >> @@ -490,8 +490,6 @@ static const struct dma_buf_ops armada_gem_prime_d=
mabuf_ops =3D {
> >>      .map_dma_buf    =3D armada_gem_prime_map_dma_buf,
> >>      .unmap_dma_buf  =3D armada_gem_prime_unmap_dma_buf,
> >>      .release        =3D drm_gem_dmabuf_release,
> >> -    .map_atomic     =3D armada_gem_dmabuf_no_kmap,
> >> -    .unmap_atomic   =3D armada_gem_dmabuf_no_kunmap,
> >>      .map            =3D armada_gem_dmabuf_no_kmap,
> >>      .unmap          =3D armada_gem_dmabuf_no_kunmap,
> >>      .mmap           =3D armada_gem_dmabuf_mmap,
> >> diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
> >> index 4a3a232fea67..b28fa8f44c8b 100644
> >> --- a/drivers/gpu/drm/drm_prime.c
> >> +++ b/drivers/gpu/drm/drm_prime.c
> >> @@ -426,30 +426,6 @@ void drm_gem_dmabuf_vunmap(struct dma_buf *dma_bu=
f, void *vaddr)
> >>   }
> >>   EXPORT_SYMBOL(drm_gem_dmabuf_vunmap);
> >>
> >> -/**
> >> - * drm_gem_dmabuf_kmap_atomic - map_atomic implementation for GEM
> >> - *
> >> - * Not implemented. This can be used as the &dma_buf_ops.map_atomic c=
allback.
> >> - */
> >> -void *drm_gem_dmabuf_kmap_atomic(struct dma_buf *dma_buf,
> >> -                             unsigned long page_num)
> >> -{
> >> -    return NULL;
> >> -}
> >> -EXPORT_SYMBOL(drm_gem_dmabuf_kmap_atomic);
> >> -
> >> -/**
> >> - * drm_gem_dmabuf_kunmap_atomic - unmap_atomic implementation for GEM
> >> - *
> >> - * Not implemented. This can be used as the &dma_buf_ops.unmap_atomic=
 callback.
> >> - */
> >> -void drm_gem_dmabuf_kunmap_atomic(struct dma_buf *dma_buf,
> >> -                              unsigned long page_num, void *addr)
> >> -{
> >> -
> >> -}
> >> -EXPORT_SYMBOL(drm_gem_dmabuf_kunmap_atomic);
> >> -
> >>   /**
> >>    * drm_gem_dmabuf_kmap - map implementation for GEM
> >>    *
> >> @@ -502,9 +478,7 @@ static const struct dma_buf_ops drm_gem_prime_dmab=
uf_ops =3D  {
> >>      .unmap_dma_buf =3D drm_gem_unmap_dma_buf,
> >>      .release =3D drm_gem_dmabuf_release,
> >>      .map =3D drm_gem_dmabuf_kmap,
> >> -    .map_atomic =3D drm_gem_dmabuf_kmap_atomic,
> >>      .unmap =3D drm_gem_dmabuf_kunmap,
> >> -    .unmap_atomic =3D drm_gem_dmabuf_kunmap_atomic,
> >>      .mmap =3D drm_gem_dmabuf_mmap,
> >>      .vmap =3D drm_gem_dmabuf_vmap,
> >>      .vunmap =3D drm_gem_dmabuf_vunmap,
> >> diff --git a/drivers/gpu/drm/i915/i915_gem_dmabuf.c b/drivers/gpu/drm/=
i915/i915_gem_dmabuf.c
> >> index 69a7aec49e84..82e2ca17a441 100644
> >> --- a/drivers/gpu/drm/i915/i915_gem_dmabuf.c
> >> +++ b/drivers/gpu/drm/i915/i915_gem_dmabuf.c
> >> @@ -111,15 +111,6 @@ static void i915_gem_dmabuf_vunmap(struct dma_buf=
 *dma_buf, void *vaddr)
> >>      i915_gem_object_unpin_map(obj);
> >>   }
> >>
> >> -static void *i915_gem_dmabuf_kmap_atomic(struct dma_buf *dma_buf, uns=
igned long page_num)
> >> -{
> >> -    return NULL;
> >> -}
> >> -
> >> -static void i915_gem_dmabuf_kunmap_atomic(struct dma_buf *dma_buf, un=
signed long page_num, void *addr)
> >> -{
> >> -
> >> -}
> >>   static void *i915_gem_dmabuf_kmap(struct dma_buf *dma_buf, unsigned =
long page_num)
> >>   {
> >>      struct drm_i915_gem_object *obj =3D dma_buf_to_obj(dma_buf);
> >> @@ -225,9 +216,7 @@ static const struct dma_buf_ops i915_dmabuf_ops =
=3D  {
> >>      .unmap_dma_buf =3D i915_gem_unmap_dma_buf,
> >>      .release =3D drm_gem_dmabuf_release,
> >>      .map =3D i915_gem_dmabuf_kmap,
> >> -    .map_atomic =3D i915_gem_dmabuf_kmap_atomic,
> >>      .unmap =3D i915_gem_dmabuf_kunmap,
> >> -    .unmap_atomic =3D i915_gem_dmabuf_kunmap_atomic,
> >>      .mmap =3D i915_gem_dmabuf_mmap,
> >>      .vmap =3D i915_gem_dmabuf_vmap,
> >>      .vunmap =3D i915_gem_dmabuf_vunmap,
> >> diff --git a/drivers/gpu/drm/i915/selftests/mock_dmabuf.c b/drivers/gp=
u/drm/i915/selftests/mock_dmabuf.c
> >> index 302f7d103635..f81fda8ea45e 100644
> >> --- a/drivers/gpu/drm/i915/selftests/mock_dmabuf.c
> >> +++ b/drivers/gpu/drm/i915/selftests/mock_dmabuf.c
> >> @@ -130,9 +130,7 @@ static const struct dma_buf_ops mock_dmabuf_ops =
=3D  {
> >>      .unmap_dma_buf =3D mock_unmap_dma_buf,
> >>      .release =3D mock_dmabuf_release,
> >>      .map =3D mock_dmabuf_kmap,
> >> -    .map_atomic =3D mock_dmabuf_kmap_atomic,
> >>      .unmap =3D mock_dmabuf_kunmap,
> >> -    .unmap_atomic =3D mock_dmabuf_kunmap_atomic,
> >>      .mmap =3D mock_dmabuf_mmap,
> >>      .vmap =3D mock_dmabuf_vmap,
> >>      .vunmap =3D mock_dmabuf_vunmap,
> >> diff --git a/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c b/drivers/gpu/d=
rm/omapdrm/omap_gem_dmabuf.c
> >> index 8e41d649e248..1a073f9b2834 100644
> >> --- a/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
> >> +++ b/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
> >> @@ -148,8 +148,6 @@ static const struct dma_buf_ops omap_dmabuf_ops =
=3D {
> >>      .release =3D drm_gem_dmabuf_release,
> >>      .begin_cpu_access =3D omap_gem_dmabuf_begin_cpu_access,
> >>      .end_cpu_access =3D omap_gem_dmabuf_end_cpu_access,
> >> -    .map_atomic =3D omap_gem_dmabuf_kmap_atomic,
> >> -    .unmap_atomic =3D omap_gem_dmabuf_kunmap_atomic,
> >>      .map =3D omap_gem_dmabuf_kmap,
> >>      .unmap =3D omap_gem_dmabuf_kunmap,
> >>      .mmap =3D omap_gem_dmabuf_mmap,
> >> diff --git a/drivers/gpu/drm/tegra/gem.c b/drivers/gpu/drm/tegra/gem.c
> >> index 8b0b4ff64bb4..d7661702c11c 100644
> >> --- a/drivers/gpu/drm/tegra/gem.c
> >> +++ b/drivers/gpu/drm/tegra/gem.c
> >> @@ -596,18 +596,6 @@ static int tegra_gem_prime_end_cpu_access(struct =
dma_buf *buf,
> >>      return 0;
> >>   }
> >>
> >> -static void *tegra_gem_prime_kmap_atomic(struct dma_buf *buf,
> >> -                                     unsigned long page)
> >> -{
> >> -    return NULL;
> >> -}
> >> -
> >> -static void tegra_gem_prime_kunmap_atomic(struct dma_buf *buf,
> >> -                                      unsigned long page,
> >> -                                      void *addr)
> >> -{
> >> -}
> >> -
> >>   static void *tegra_gem_prime_kmap(struct dma_buf *buf, unsigned long=
 page)
> >>   {
> >>      return NULL;
> >> @@ -648,8 +636,6 @@ static const struct dma_buf_ops tegra_gem_prime_dm=
abuf_ops =3D {
> >>      .release =3D tegra_gem_prime_release,
> >>      .begin_cpu_access =3D tegra_gem_prime_begin_cpu_access,
> >>      .end_cpu_access =3D tegra_gem_prime_end_cpu_access,
> >> -    .map_atomic =3D tegra_gem_prime_kmap_atomic,
> >> -    .unmap_atomic =3D tegra_gem_prime_kunmap_atomic,
> >>      .map =3D tegra_gem_prime_kmap,
> >>      .unmap =3D tegra_gem_prime_kunmap,
> >>      .mmap =3D tegra_gem_prime_mmap,
> >> diff --git a/drivers/gpu/drm/udl/udl_dmabuf.c b/drivers/gpu/drm/udl/ud=
l_dmabuf.c
> >> index 5fdc8bdc2026..ae7225dedc30 100644
> >> --- a/drivers/gpu/drm/udl/udl_dmabuf.c
> >> +++ b/drivers/gpu/drm/udl/udl_dmabuf.c
> >> @@ -156,27 +156,12 @@ static void *udl_dmabuf_kmap(struct dma_buf *dma=
_buf, unsigned long page_num)
> >>      return NULL;
> >>   }
> >>
> >> -static void *udl_dmabuf_kmap_atomic(struct dma_buf *dma_buf,
> >> -                                unsigned long page_num)
> >> -{
> >> -    /* TODO */
> >> -
> >> -    return NULL;
> >> -}
> >> -
> >>   static void udl_dmabuf_kunmap(struct dma_buf *dma_buf,
> >>                            unsigned long page_num, void *addr)
> >>   {
> >>      /* TODO */
> >>   }
> >>
> >> -static void udl_dmabuf_kunmap_atomic(struct dma_buf *dma_buf,
> >> -                                 unsigned long page_num,
> >> -                                 void *addr)
> >> -{
> >> -    /* TODO */
> >> -}
> >> -
> >>   static int udl_dmabuf_mmap(struct dma_buf *dma_buf,
> >>                         struct vm_area_struct *vma)
> >>   {
> >> @@ -191,9 +176,7 @@ static const struct dma_buf_ops udl_dmabuf_ops =3D=
 {
> >>      .map_dma_buf            =3D udl_map_dma_buf,
> >>      .unmap_dma_buf          =3D udl_unmap_dma_buf,
> >>      .map                    =3D udl_dmabuf_kmap,
> >> -    .map_atomic             =3D udl_dmabuf_kmap_atomic,
> >>      .unmap                  =3D udl_dmabuf_kunmap,
> >> -    .unmap_atomic           =3D udl_dmabuf_kunmap_atomic,
> >>      .mmap                   =3D udl_dmabuf_mmap,
> >>      .release                =3D drm_gem_dmabuf_release,
> >>   };
> >> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_prime.c b/drivers/gpu/drm/v=
mwgfx/vmwgfx_prime.c
> >> index fbffb37ccf42..373bc6da2f84 100644
> >> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_prime.c
> >> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_prime.c
> >> @@ -71,17 +71,6 @@ static void vmw_prime_dmabuf_vunmap(struct dma_buf =
*dma_buf, void *vaddr)
> >>   {
> >>   }
> >>
> >> -static void *vmw_prime_dmabuf_kmap_atomic(struct dma_buf *dma_buf,
> >> -            unsigned long page_num)
> >> -{
> >> -    return NULL;
> >> -}
> >> -
> >> -static void vmw_prime_dmabuf_kunmap_atomic(struct dma_buf *dma_buf,
> >> -            unsigned long page_num, void *addr)
> >> -{
> >> -
> >> -}
> >>   static void *vmw_prime_dmabuf_kmap(struct dma_buf *dma_buf,
> >>              unsigned long page_num)
> >>   {
> >> @@ -108,9 +97,7 @@ const struct dma_buf_ops vmw_prime_dmabuf_ops =3D  =
{
> >>      .unmap_dma_buf =3D vmw_prime_unmap_dma_buf,
> >>      .release =3D NULL,
> >>      .map =3D vmw_prime_dmabuf_kmap,
> >> -    .map_atomic =3D vmw_prime_dmabuf_kmap_atomic,
> >>      .unmap =3D vmw_prime_dmabuf_kunmap,
> >> -    .unmap_atomic =3D vmw_prime_dmabuf_kunmap_atomic,
> >>      .mmap =3D vmw_prime_dmabuf_mmap,
> >>      .vmap =3D vmw_prime_dmabuf_vmap,
> >>      .vunmap =3D vmw_prime_dmabuf_vunmap,
> >> diff --git a/drivers/media/common/videobuf2/videobuf2-dma-contig.c b/d=
rivers/media/common/videobuf2/videobuf2-dma-contig.c
> >> index 12d0072c52c2..aff0ab7bf83d 100644
> >> --- a/drivers/media/common/videobuf2/videobuf2-dma-contig.c
> >> +++ b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
> >> @@ -358,7 +358,6 @@ static const struct dma_buf_ops vb2_dc_dmabuf_ops =
=3D {
> >>      .map_dma_buf =3D vb2_dc_dmabuf_ops_map,
> >>      .unmap_dma_buf =3D vb2_dc_dmabuf_ops_unmap,
> >>      .map =3D vb2_dc_dmabuf_ops_kmap,
> >> -    .map_atomic =3D vb2_dc_dmabuf_ops_kmap,
> >>      .vmap =3D vb2_dc_dmabuf_ops_vmap,
> >>      .mmap =3D vb2_dc_dmabuf_ops_mmap,
> >>      .release =3D vb2_dc_dmabuf_ops_release,
> >> diff --git a/drivers/media/common/videobuf2/videobuf2-dma-sg.c b/drive=
rs/media/common/videobuf2/videobuf2-dma-sg.c
> >> index cf94765e593f..015e737095cd 100644
> >> --- a/drivers/media/common/videobuf2/videobuf2-dma-sg.c
> >> +++ b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
> >> @@ -507,7 +507,6 @@ static const struct dma_buf_ops vb2_dma_sg_dmabuf_=
ops =3D {
> >>      .map_dma_buf =3D vb2_dma_sg_dmabuf_ops_map,
> >>      .unmap_dma_buf =3D vb2_dma_sg_dmabuf_ops_unmap,
> >>      .map =3D vb2_dma_sg_dmabuf_ops_kmap,
> >> -    .map_atomic =3D vb2_dma_sg_dmabuf_ops_kmap,
> >>      .vmap =3D vb2_dma_sg_dmabuf_ops_vmap,
> >>      .mmap =3D vb2_dma_sg_dmabuf_ops_mmap,
> >>      .release =3D vb2_dma_sg_dmabuf_ops_release,
> >> diff --git a/drivers/media/common/videobuf2/videobuf2-vmalloc.c b/driv=
ers/media/common/videobuf2/videobuf2-vmalloc.c
> >> index 298ffb9ecdae..467a4005164b 100644
> >> --- a/drivers/media/common/videobuf2/videobuf2-vmalloc.c
> >> +++ b/drivers/media/common/videobuf2/videobuf2-vmalloc.c
> >> @@ -346,7 +346,6 @@ static const struct dma_buf_ops vb2_vmalloc_dmabuf=
_ops =3D {
> >>      .map_dma_buf =3D vb2_vmalloc_dmabuf_ops_map,
> >>      .unmap_dma_buf =3D vb2_vmalloc_dmabuf_ops_unmap,
> >>      .map =3D vb2_vmalloc_dmabuf_ops_kmap,
> >> -    .map_atomic =3D vb2_vmalloc_dmabuf_ops_kmap,
> >>      .vmap =3D vb2_vmalloc_dmabuf_ops_vmap,
> >>      .mmap =3D vb2_vmalloc_dmabuf_ops_mmap,
> >>      .release =3D vb2_vmalloc_dmabuf_ops_release,
> >> diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/andro=
id/ion/ion.c
> >> index 57e0d8035b2e..a46219ff5e16 100644
> >> --- a/drivers/staging/android/ion/ion.c
> >> +++ b/drivers/staging/android/ion/ion.c
> >> @@ -374,8 +374,6 @@ static const struct dma_buf_ops dma_buf_ops =3D {
> >>      .detach =3D ion_dma_buf_detatch,
> >>      .begin_cpu_access =3D ion_dma_buf_begin_cpu_access,
> >>      .end_cpu_access =3D ion_dma_buf_end_cpu_access,
> >> -    .map_atomic =3D ion_dma_buf_kmap,
> >> -    .unmap_atomic =3D ion_dma_buf_kunmap,
> >>      .map =3D ion_dma_buf_kmap,
> >>      .unmap =3D ion_dma_buf_kunmap,
> >>   };
> >> diff --git a/drivers/tee/tee_shm.c b/drivers/tee/tee_shm.c
> >> index 556960a1bab3..df4a1553b78b 100644
> >> --- a/drivers/tee/tee_shm.c
> >> +++ b/drivers/tee/tee_shm.c
> >> @@ -80,11 +80,6 @@ static void tee_shm_op_release(struct dma_buf *dmab=
uf)
> >>      tee_shm_release(shm);
> >>   }
> >>
> >> -static void *tee_shm_op_map_atomic(struct dma_buf *dmabuf, unsigned l=
ong pgnum)
> >> -{
> >> -    return NULL;
> >> -}
> >> -
> >>   static void *tee_shm_op_map(struct dma_buf *dmabuf, unsigned long pg=
num)
> >>   {
> >>      return NULL;
> >> @@ -107,7 +102,6 @@ static const struct dma_buf_ops tee_shm_dma_buf_op=
s =3D {
> >>      .map_dma_buf =3D tee_shm_op_map_dma_buf,
> >>      .unmap_dma_buf =3D tee_shm_op_unmap_dma_buf,
> >>      .release =3D tee_shm_op_release,
> >> -    .map_atomic =3D tee_shm_op_map_atomic,
> >>      .map =3D tee_shm_op_map,
> >>      .mmap =3D tee_shm_op_mmap,
> >>   };
> >> diff --git a/include/drm/drm_prime.h b/include/drm/drm_prime.h
> >> index ef338151cea8..d716d653b096 100644
> >> --- a/include/drm/drm_prime.h
> >> +++ b/include/drm/drm_prime.h
> >> @@ -93,10 +93,6 @@ void drm_gem_unmap_dma_buf(struct dma_buf_attachmen=
t *attach,
> >>                         enum dma_data_direction dir);
> >>   void *drm_gem_dmabuf_vmap(struct dma_buf *dma_buf);
> >>   void drm_gem_dmabuf_vunmap(struct dma_buf *dma_buf, void *vaddr);
> >> -void *drm_gem_dmabuf_kmap_atomic(struct dma_buf *dma_buf,
> >> -                             unsigned long page_num);
> >> -void drm_gem_dmabuf_kunmap_atomic(struct dma_buf *dma_buf,
> >> -                              unsigned long page_num, void *addr);
> >>   void *drm_gem_dmabuf_kmap(struct dma_buf *dma_buf, unsigned long pag=
e_num);
> >>   void drm_gem_dmabuf_kunmap(struct dma_buf *dma_buf, unsigned long pa=
ge_num,
> >>                         void *addr);
> >> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> >> index 346caf77937f..d17cadd76802 100644
> >> --- a/include/linux/dma-buf.h
> >> +++ b/include/linux/dma-buf.h
> >> @@ -205,8 +205,6 @@ struct dma_buf_ops {
> >>       * to be restarted.
> >>       */
> >>      int (*end_cpu_access)(struct dma_buf *, enum dma_data_direction);
> >> -    void *(*map_atomic)(struct dma_buf *, unsigned long);
> >> -    void (*unmap_atomic)(struct dma_buf *, unsigned long, void *);
> >>      void *(*map)(struct dma_buf *, unsigned long);
> >>      void (*unmap)(struct dma_buf *, unsigned long, void *);
> >>
> >> @@ -394,8 +392,6 @@ int dma_buf_begin_cpu_access(struct dma_buf *dma_b=
uf,
> >>                           enum dma_data_direction dir);
> >>   int dma_buf_end_cpu_access(struct dma_buf *dma_buf,
> >>                         enum dma_data_direction dir);
> >> -void *dma_buf_kmap_atomic(struct dma_buf *, unsigned long);
> >> -void dma_buf_kunmap_atomic(struct dma_buf *, unsigned long, void *);
> >>   void *dma_buf_kmap(struct dma_buf *, unsigned long);
> >>   void dma_buf_kunmap(struct dma_buf *, unsigned long, void *);
> >>
> >> --
> >> 2.14.1
> >>
> >> _______________________________________________
> >> dri-devel mailing list
> >> dri-devel@lists.freedesktop.org
> >> https://lists.freedesktop.org/mailman/listinfo/dri-devel
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel



--=20
Thanks and regards,

Sumit Semwal
Linaro Mobile Group - Kernel Team Lead
Linaro.org =E2=94=82 Open source software for ARM SoCs
