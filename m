Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:36602 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751388AbdJXPlX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Oct 2017 11:41:23 -0400
Subject: Re: [PATCH 4/7] media: exynos4-is: Remove dependency on obsolete
 SoC support
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <e58c8c45-f9e2-fe30-0f98-8160182c9b44@samsung.com>
Date: Tue, 24 Oct 2017 17:41:16 +0200
MIME-version: 1.0
In-reply-to: <20171004063828.22068-5-m.szyprowski@samsung.com>
Content-type: text/plain; charset="utf-8"
Content-language: en-GB
Content-transfer-encoding: 7bit
References: <20171004063828.22068-1-m.szyprowski@samsung.com>
        <CGME20171004063836eucas1p1c45902d81f8520b4bfc6b06ded50cc2b@eucas1p1.samsung.com>
        <20171004063828.22068-5-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/04/2017 08:38 AM, Marek Szyprowski wrote:
> Support for Exynos4212 SoCs has been removed by commit bca9085e0ae9 ("ARM:
> dts: exynos: remove Exynos4212 support (dead code)"), so there is no need
> to keep remaining dead code related to this SoC version.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
