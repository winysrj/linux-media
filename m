Return-path: <mchehab@pedra>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:39614 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751807Ab1CHR7p convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Mar 2011 12:59:45 -0500
MIME-Version: 1.0
In-Reply-To: <1299588365-2749-4-git-send-email-dacohen@gmail.com>
References: <1299588365-2749-1-git-send-email-dacohen@gmail.com>
	<1299588365-2749-4-git-send-email-dacohen@gmail.com>
Date: Tue, 8 Mar 2011 11:59:43 -0600
Message-ID: <AANLkTikvUah8LPXCeV4Opi09DJ4ZoHAc2xUVTcDhNK=Q@mail.gmail.com>
Subject: Re: [PATCH 3/3] omap: iovmm: don't check 'da' to set
 IOVMF_DA_FIXED/IOVMF_DA_ANON flags
From: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
To: David Cohen <dacohen@gmail.com>
Cc: Hiroshi.DOYU@nokia.com, linux-omap@vger.kernel.org,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Mar 8, 2011 at 6:46 AM, David Cohen <dacohen@gmail.com> wrote:
> Currently IOVMM driver sets IOVMF_DA_FIXED/IOVMF_DA_ANON flags according
> to input 'da' address when mapping memory:
> da == 0: IOVMF_DA_ANON
> da != 0: IOVMF_DA_FIXED
>
> It prevents IOMMU to map first page with fixed 'da'. To avoid such
> issue, IOVMM will not automatically set IOVMF_DA_FIXED. It should now
> come from the user. IOVMF_DA_ANON will be automatically set if
> IOVMF_DA_FIXED isn't set.
>
> Signed-off-by: David Cohen <dacohen@gmail.com>
> ---
>  arch/arm/plat-omap/iovmm.c |   12 ++++++++----
>  1 files changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm/plat-omap/iovmm.c b/arch/arm/plat-omap/iovmm.c
> index 11c9b76..dde9cb0 100644
> --- a/arch/arm/plat-omap/iovmm.c
> +++ b/arch/arm/plat-omap/iovmm.c
> @@ -654,7 +654,8 @@ u32 iommu_vmap(struct iommu *obj, u32 da, const struct sg_table *sgt,
>        flags &= IOVMF_HW_MASK;
>        flags |= IOVMF_DISCONT;
>        flags |= IOVMF_MMIO;
> -       flags |= (da ? IOVMF_DA_FIXED : IOVMF_DA_ANON);
> +       if (~flags & IOVMF_DA_FIXED)
> +               flags |= IOVMF_DA_ANON;

could we use only one? both are mutual exclusive, what happen if flag
is IOVMF_DA_FIXED | IOVMF_DA_ANON? so, I suggest to get rid of
IOVMF_DA_ANON.

Regards,
Fernando.

>
>        da = __iommu_vmap(obj, da, sgt, va, bytes, flags);
>        if (IS_ERR_VALUE(da))
> @@ -713,7 +714,8 @@ u32 iommu_vmalloc(struct iommu *obj, u32 da, size_t bytes, u32 flags)
>        flags &= IOVMF_HW_MASK;
>        flags |= IOVMF_DISCONT;
>        flags |= IOVMF_ALLOC;
> -       flags |= (da ? IOVMF_DA_FIXED : IOVMF_DA_ANON);
> +       if (~flags & IOVMF_DA_FIXED)
> +               flags |= IOVMF_DA_ANON;
>
>        sgt = sgtable_alloc(bytes, flags, da, 0);
>        if (IS_ERR(sgt)) {
> @@ -803,7 +805,8 @@ u32 iommu_kmap(struct iommu *obj, u32 da, u32 pa, size_t bytes,
>        flags &= IOVMF_HW_MASK;
>        flags |= IOVMF_LINEAR;
>        flags |= IOVMF_MMIO;
> -       flags |= (da ? IOVMF_DA_FIXED : IOVMF_DA_ANON);
> +       if (~flags & IOVMF_DA_FIXED)
> +               flags |= IOVMF_DA_ANON;
>
>        da = __iommu_kmap(obj, da, pa, va, bytes, flags);
>        if (IS_ERR_VALUE(da))
> @@ -862,7 +865,8 @@ u32 iommu_kmalloc(struct iommu *obj, u32 da, size_t bytes, u32 flags)
>        flags &= IOVMF_HW_MASK;
>        flags |= IOVMF_LINEAR;
>        flags |= IOVMF_ALLOC;
> -       flags |= (da ? IOVMF_DA_FIXED : IOVMF_DA_ANON);
> +       if (~flags & IOVMF_DA_FIXED)
> +               flags |= IOVMF_DA_ANON;
>
>        da = __iommu_kmap(obj, da, pa, va, bytes, flags);
>        if (IS_ERR_VALUE(da))
> --
> 1.7.0.4
>
>
