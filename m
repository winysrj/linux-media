Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:33179 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751196AbdEOQnT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 May 2017 12:43:19 -0400
Date: Mon, 15 May 2017 18:43:16 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: Re: [PATCH v3 16/16] ARM: dts: exynos: Remove MFC reserved buffers
Message-ID: <20170515164316.snmpzllu5tcutkka@kozik-lap>
References: <1490007402-30265-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20170320105655eucas1p21706c33b5c1b413126fbfd1e23a34058@eucas1p2.samsung.com>
 <1490007402-30265-17-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1490007402-30265-17-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 20, 2017 at 11:56:42AM +0100, Marek Szyprowski wrote:
> During my research I found that some of the requirements for the memory
> buffers for MFC v6+ devices were blindly copied from the previous (v5)
> version and simply turned out to be excessive. The relaxed requirements
> are applied by the recent patches to the MFC driver and the driver is
> now fully functional even without the reserved memory blocks for all
> v6+ variants. This patch removes those reserved memory nodes from all
> boards having MFC v6+ hardware block.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
> Tested-by: Javier Martinez Canillas <javier@osg.samsung.com>
> Acked-by: Andrzej Hajda <a.hajda@samsung.com>
> Tested-by: Smitha T Murthy <smitha.t@samsung.com>
> ---
>  arch/arm/boot/dts/exynos5250-arndale.dts           | 1 -
>  arch/arm/boot/dts/exynos5250-smdk5250.dts          | 1 -
>  arch/arm/boot/dts/exynos5250-spring.dts            | 1 -
>  arch/arm/boot/dts/exynos5420-arndale-octa.dts      | 1 -
>  arch/arm/boot/dts/exynos5420-peach-pit.dts         | 1 -
>  arch/arm/boot/dts/exynos5420-smdk5420.dts          | 1 -
>  arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi | 1 -
>  arch/arm/boot/dts/exynos5800-peach-pi.dts          | 1 -
>  8 files changed, 8 deletions(-)
> 

Thanks, applied.

Best regards,
Krzysztof
