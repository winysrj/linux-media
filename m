Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34828 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932238AbdBNRDW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Feb 2017 12:03:22 -0500
Date: Tue, 14 Feb 2017 19:03:16 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: Re: [PATCH 15/15] ARM: dts: exynos: Remove MFC reserved buffersg
Message-ID: <20170214170316.nsp3g5ht3ldoxc43@kozik-lap>
References: <1487058728-16501-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20170214075221eucas1p18648b047f71e9dd95626e5766c74601b@eucas1p1.samsung.com>
 <1487058728-16501-16-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1487058728-16501-16-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 14, 2017 at 08:52:08AM +0100, Marek Szyprowski wrote:
> During my research I found that some of the requirements for the memory
> buffers for MFC v6+ devices were blindly copied from the previous (v5)
> version and simply turned out to be excessive. The relaxed requirements
> are applied by the recent patches to the MFC driver and the driver is
> now fully functional even without the reserved memory blocks for all
> v6+ variants. This patch removes those reserved memory nodes from all
> boards having MFC v6+ hardware block.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
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

Looks okay (for v4.12). Full bisectability depends on changes in MFC
driver, right?  I will need a stable branch/tag with driver changes
(although recently Arnd did not want driver changes mixed with DTS...).


Best regards,
Krzysztof
