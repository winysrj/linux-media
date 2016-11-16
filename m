Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33587 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752899AbcKPRSa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 12:18:30 -0500
Date: Wed, 16 Nov 2016 19:18:24 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Inki Dae <inki.dae@samsung.com>
Subject: Re: [PATCH 9/9] s5p-mfc: Add support for MFC v8 available in Exynos
 5433 SoCs
Message-ID: <20161116171824.GA4983@kozik-lap>
References: <1479287098-30493-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20161116090523eucas1p12a4b95363e9d2b0a823141a2f1c226e1@eucas1p1.samsung.com>
 <1479287098-30493-10-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1479287098-30493-10-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 16, 2016 at 10:04:58AM +0100, Marek Szyprowski wrote:
> Exynos5433 SoC has MFC v8 hardware module, but it has more complex clock
> hierarchy, so a new compatible has been added.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  Documentation/devicetree/bindings/media/s5p-mfc.txt |  1 +
>  drivers/media/platform/s5p-mfc/s5p_mfc.c            | 14 ++++++++++++++
>  2 files changed, 15 insertions(+)
> 

Acked-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof

