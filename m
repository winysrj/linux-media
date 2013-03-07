Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:47562 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab3CGHRK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Mar 2013 02:17:10 -0500
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MJA003SG489FEH0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 07 Mar 2013 16:17:08 +0900 (KST)
From: Inki Dae <inki.dae@samsung.com>
To: 'Vikas Sajjan' <vikas.sajjan@linaro.org>
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	kgene.kim@samsung.com, 'Joonyoung Shim' <jy0922.shim@samsung.com>,
	'sunil joshi' <joshi@samsung.com>
References: <1361961178-1912-1-git-send-email-vikas.sajjan@linaro.org>
 <512EC410.3050301@samsung.com>
 <CAD025yT+VQ=bv1Sk61QtMft45nw7BWqn9ox5B5opGpr3s-1nxw@mail.gmail.com>
In-reply-to: <CAD025yT+VQ=bv1Sk61QtMft45nw7BWqn9ox5B5opGpr3s-1nxw@mail.gmail.com>
Subject: RE: [PATCH] drm/exynos: modify the compatible string for exynos fimd
Date: Thu, 07 Mar 2013 16:17:07 +0900
Message-id: <014501ce1b03$c70ccdc0$55266940$%dae@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Already merged. :)

> -----Original Message-----
> From: Vikas Sajjan [mailto:vikas.sajjan@linaro.org]
> Sent: Thursday, March 07, 2013 4:09 PM
> To: InKi Dae
> Cc: dri-devel@lists.freedesktop.org; linux-media@vger.kernel.org;
> kgene.kim@samsung.com; Joonyoung Shim; sunil joshi
> Subject: Re: [PATCH] drm/exynos: modify the compatible string for exynos
> fimd
> 
> Hi Mr Inki Dae,
> 
> On 28 February 2013 08:12, Joonyoung Shim <jy0922.shim@samsung.com> wrote:
> > On 02/27/2013 07:32 PM, Vikas Sajjan wrote:
> >>
> >> modified compatible string for exynos4 fimd as "exynos4210-fimd" and
> >> exynos5 fimd as "exynos5250-fimd" to stick to the rule that compatible
> >> value should be named after first specific SoC model in which this
> >> particular IP version was included as discussed at
> >> https://patchwork.kernel.org/patch/2144861/
> >>
> >> Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
> >> ---
> >>   drivers/gpu/drm/exynos/exynos_drm_fimd.c |    4 ++--
> >>   1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> >> b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> >> index 9537761..433ed35 100644
> >> --- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> >> +++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> >> @@ -109,9 +109,9 @@ struct fimd_context {
> >>     #ifdef CONFIG_OF
> >>   static const struct of_device_id fimd_driver_dt_match[] = {
> >> -       { .compatible = "samsung,exynos4-fimd",
> >> +       { .compatible = "samsung,exynos4210-fimd",
> >>           .data = &exynos4_fimd_driver_data },
> >> -       { .compatible = "samsung,exynos5-fimd",
> >> +       { .compatible = "samsung,exynos5250-fimd",
> >>           .data = &exynos5_fimd_driver_data },
> >>         {},
> >>   };
> >
> >
> > Acked-by: Joonyoung Shim <jy0922.shim@samsung.com>
> 
> Can you please apply this patch.
> 
> >
> > Thanks.
> 
> 
> 
> --
> Thanks and Regards
>  Vikas Sajjan

