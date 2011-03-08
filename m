Return-path: <mchehab@pedra>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:36055 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755597Ab1CHUmJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Mar 2011 15:42:09 -0500
MIME-Version: 1.0
In-Reply-To: <1299615316-17512-4-git-send-email-dacohen@gmail.com>
References: <1299615316-17512-1-git-send-email-dacohen@gmail.com>
	<1299615316-17512-4-git-send-email-dacohen@gmail.com>
Date: Tue, 8 Mar 2011 14:42:04 -0600
Message-ID: <AANLkTindXXOsx8ibp0tmVx9HGfQ4eeQoO0kLj=C67w6+@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] omap: iovmm: don't check 'da' to set
 IOVMF_DA_FIXED flag
From: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
To: David Cohen <dacohen@gmail.com>
Cc: Hiroshi.DOYU@nokia.com, linux-omap@vger.kernel.org,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Mar 8, 2011 at 2:15 PM, David Cohen <dacohen@gmail.com> wrote:
> Currently IOVMM driver sets IOVMF_DA_FIXED/IOVMF_DA_ANON flags according
> to input 'da' address when mapping memory:
> da == 0: IOVMF_DA_ANON
> da != 0: IOVMF_DA_FIXED
>
> It prevents IOMMU to map first page with fixed 'da'. To avoid such
> issue, IOVMM will not automatically set IOVMF_DA_FIXED. It should now
> come from the user throught 'flags' parameter when mapping memory.
> As IOVMF_DA_ANON and IOVMF_DA_FIXED are mutually exclusive, IOVMF_DA_ANON
> can be removed. The driver will now check internally if IOVMF_DA_FIXED
> is set or not.

Looks good to me.

Regards,
Fernando.

>
> Signed-off-by: David Cohen <dacohen@gmail.com>
> ---
>  arch/arm/plat-omap/include/plat/iovmm.h |    2 --
>  arch/arm/plat-omap/iovmm.c              |   14 +++++---------
>  2 files changed, 5 insertions(+), 11 deletions(-)
>
> diff --git a/arch/arm/plat-omap/include/plat/iovmm.h b/arch/arm/plat-omap/include/plat/iovmm.h
> index bdc7ce5..32a2f6c 100644
> --- a/arch/arm/plat-omap/include/plat/iovmm.h
> +++ b/arch/arm/plat-omap/include/plat/iovmm.h
> @@ -71,8 +71,6 @@ struct iovm_struct {
>  #define IOVMF_LINEAR_MASK      (3 << (2 + IOVMF_SW_SHIFT))
>
>  #define IOVMF_DA_FIXED         (1 << (4 + IOVMF_SW_SHIFT))
> -#define IOVMF_DA_ANON          (2 << (4 + IOVMF_SW_SHIFT))
> -#define IOVMF_DA_MASK          (3 << (4 + IOVMF_SW_SHIFT))
>
>
>  extern struct iovm_struct *find_iovm_area(struct iommu *obj, u32 da);
> diff --git a/arch/arm/plat-omap/iovmm.c b/arch/arm/plat-omap/iovmm.c
> index e5f8341..894489c 100644
> --- a/arch/arm/plat-omap/iovmm.c
> +++ b/arch/arm/plat-omap/iovmm.c
> @@ -279,7 +279,7 @@ static struct iovm_struct *alloc_iovm_area(struct iommu *obj, u32 da,
>        start = da;
>        alignment = PAGE_SIZE;
>
> -       if (flags & IOVMF_DA_ANON) {
> +       if (~flags & IOVMF_DA_FIXED) {
>                /* Don't map address 0 */
>                if (obj->da_start)
>                        start = obj->da_start;
> @@ -307,7 +307,7 @@ static struct iovm_struct *alloc_iovm_area(struct iommu *obj, u32 da,
>                if (tmp->da_start > start && (tmp->da_start - start) >= bytes)
>                        goto found;
>
> -               if (tmp->da_end >= start && flags & IOVMF_DA_ANON)
> +               if (tmp->da_end >= start && ~flags & IOVMF_DA_FIXED)
>                        start = roundup(tmp->da_end + 1, alignment);
>
>                prev_end = tmp->da_end;
> @@ -654,7 +654,6 @@ u32 iommu_vmap(struct iommu *obj, u32 da, const struct sg_table *sgt,
>        flags &= IOVMF_HW_MASK;
>        flags |= IOVMF_DISCONT;
>        flags |= IOVMF_MMIO;
> -       flags |= (da ? IOVMF_DA_FIXED : IOVMF_DA_ANON);
>
>        da = __iommu_vmap(obj, da, sgt, va, bytes, flags);
>        if (IS_ERR_VALUE(da))
> @@ -694,7 +693,7 @@ EXPORT_SYMBOL_GPL(iommu_vunmap);
>  * @flags:     iovma and page property
>  *
>  * Allocate @bytes linearly and creates 1-n-1 mapping and returns
> - * @da again, which might be adjusted if 'IOVMF_DA_ANON' is set.
> + * @da again, which might be adjusted if 'IOVMF_DA_FIXED' is not set.
>  */
>  u32 iommu_vmalloc(struct iommu *obj, u32 da, size_t bytes, u32 flags)
>  {
> @@ -713,7 +712,6 @@ u32 iommu_vmalloc(struct iommu *obj, u32 da, size_t bytes, u32 flags)
>        flags &= IOVMF_HW_MASK;
>        flags |= IOVMF_DISCONT;
>        flags |= IOVMF_ALLOC;
> -       flags |= (da ? IOVMF_DA_FIXED : IOVMF_DA_ANON);
>
>        sgt = sgtable_alloc(bytes, flags, da, 0);
>        if (IS_ERR(sgt)) {
> @@ -784,7 +782,7 @@ static u32 __iommu_kmap(struct iommu *obj, u32 da, u32 pa, void *va,
>  * @flags:     iovma and page property
>  *
>  * Creates 1-1-1 mapping and returns @da again, which can be
> - * adjusted if 'IOVMF_DA_ANON' is set.
> + * adjusted if 'IOVMF_DA_FIXED' is not set.
>  */
>  u32 iommu_kmap(struct iommu *obj, u32 da, u32 pa, size_t bytes,
>                 u32 flags)
> @@ -803,7 +801,6 @@ u32 iommu_kmap(struct iommu *obj, u32 da, u32 pa, size_t bytes,
>        flags &= IOVMF_HW_MASK;
>        flags |= IOVMF_LINEAR;
>        flags |= IOVMF_MMIO;
> -       flags |= (da ? IOVMF_DA_FIXED : IOVMF_DA_ANON);
>
>        da = __iommu_kmap(obj, da, pa, va, bytes, flags);
>        if (IS_ERR_VALUE(da))
> @@ -842,7 +839,7 @@ EXPORT_SYMBOL_GPL(iommu_kunmap);
>  * @flags:     iovma and page property
>  *
>  * Allocate @bytes linearly and creates 1-1-1 mapping and returns
> - * @da again, which might be adjusted if 'IOVMF_DA_ANON' is set.
> + * @da again, which might be adjusted if 'IOVMF_DA_FIXED' is not set.
>  */
>  u32 iommu_kmalloc(struct iommu *obj, u32 da, size_t bytes, u32 flags)
>  {
> @@ -862,7 +859,6 @@ u32 iommu_kmalloc(struct iommu *obj, u32 da, size_t bytes, u32 flags)
>        flags &= IOVMF_HW_MASK;
>        flags |= IOVMF_LINEAR;
>        flags |= IOVMF_ALLOC;
> -       flags |= (da ? IOVMF_DA_FIXED : IOVMF_DA_ANON);
>
>        da = __iommu_kmap(obj, da, pa, va, bytes, flags);
>        if (IS_ERR_VALUE(da))
> --
> 1.7.0.4
>
>
