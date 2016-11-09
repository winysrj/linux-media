Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:41966
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752629AbcKIRzg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Nov 2016 12:55:36 -0500
Subject: Re: [PATCH 2/2] exynos-gsc: Add support for Exynos5433 specific
 version
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
References: <1478701778-29452-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20161109142951eucas1p25ea07a6d0ba507b26df345f3888b4539@eucas1p2.samsung.com>
 <1478701778-29452-3-git-send-email-m.szyprowski@samsung.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Message-ID: <cfc1fbc3-32a5-7856-9085-1c2d3efd4bc8@osg.samsung.com>
Date: Wed, 9 Nov 2016 14:55:29 -0300
MIME-Version: 1.0
In-Reply-To: <1478701778-29452-3-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Marek,

On 11/09/2016 11:29 AM, Marek Szyprowski wrote:
> This patch add support for Exynos5433 specific version of GScaller module.

s/GScaller/GScaler

> The main difference is between Exynos 5433 and earlier is addition of
> new clocks that have to be controlled.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  .../devicetree/bindings/media/exynos5-gsc.txt      |  3 +-
>  drivers/media/platform/exynos-gsc/gsc-core.c       | 74 ++++++++++++++++------
>  drivers/media/platform/exynos-gsc/gsc-core.h       |  6 +-
>  3 files changed, 62 insertions(+), 21 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/media/exynos5-gsc.txt b/Documentation/devicetree/bindings/media/exynos5-gsc.txt

Usually the DT changes go in a separate patch as documented in
Documentation/devicetree/bindings/submitting-patches.txt.

But I guess this is a too small change so is OK to squash it?

> index 5fe9372..26ca25b 100644
> --- a/Documentation/devicetree/bindings/media/exynos5-gsc.txt
> +++ b/Documentation/devicetree/bindings/media/exynos5-gsc.txt
> @@ -3,7 +3,8 @@
>  G-Scaler is used for scaling and color space conversion on EXYNOS5 SoCs.
>  
>  Required properties:
> -- compatible: should be "samsung,exynos5-gsc"
> +- compatible: should be "samsung,exynos5-gsc" (for Exynos 5250, 5420 and
> +	      5422 SoCs) or "samsung,exynos5433-gsc" (Exynos 5433)

I would also add 5800 to the list.

Besides these minor comments, the patch looks good to me:

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>

And I've also tested in an Exynos5800 Peach Pi Chromebook:

Tested-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
