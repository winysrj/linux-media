Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34452 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751203AbcKIUHV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Nov 2016 15:07:21 -0500
Date: Wed, 9 Nov 2016 22:07:15 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>
Subject: Re: [PATCH 2/2] exynos-gsc: Add support for Exynos5433 specific
 version
Message-ID: <20161109200715.GD23534@kozik-lap>
References: <1478701778-29452-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20161109142951eucas1p25ea07a6d0ba507b26df345f3888b4539@eucas1p2.samsung.com>
 <1478701778-29452-3-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1478701778-29452-3-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 09, 2016 at 03:29:38PM +0100, Marek Szyprowski wrote:
> This patch add support for Exynos5433 specific version of GScaller module.
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

Acked-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof

