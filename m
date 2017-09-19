Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36681 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750998AbdISRcz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 13:32:55 -0400
Date: Tue, 19 Sep 2017 19:32:50 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Hoegeun Kwon <hoegeun.kwon@samsung.com>
Cc: inki.dae@samsung.com, airlied@linux.ie, kgene@kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, catalin.marinas@arm.com,
        will.deacon@arm.com, mchehab@kernel.org, s.nawrocki@samsung.com,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, a.hajda@samsung.com
Subject: Re: [PATCH v4 2/4] ARM: dts: exynos: Add clean name of compatible.
Message-ID: <20170919173250.o3yhqpxgopxmtlyj@kozik-lap>
References: <1505302915-15699-1-git-send-email-hoegeun.kwon@samsung.com>
 <CGME20170913114215epcas2p30e9a4593bdb6cc3142c6e4dc108ff2f0@epcas2p3.samsung.com>
 <1505302915-15699-3-git-send-email-hoegeun.kwon@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1505302915-15699-3-git-send-email-hoegeun.kwon@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 13, 2017 at 08:41:53PM +0900, Hoegeun Kwon wrote:
> Exynos 5250 and 5420 have different hardware rotation limits. However,
> currently it uses only one compatible - "exynos5-gsc". Since we have
> to distinguish between these two, we add different compatible.
> 
> Signed-off-by: Hoegeun Kwon <hoegeun.kwon@samsung.com>
> ---
>  arch/arm/boot/dts/exynos5250.dtsi | 8 ++++----
>  arch/arm/boot/dts/exynos5420.dtsi | 4 ++--
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 

Thanks, applied with modified subject.

Best regards,
Krzysztof
