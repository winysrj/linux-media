Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751120AbdJDIQZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Oct 2017 04:16:25 -0400
MIME-Version: 1.0
In-Reply-To: <20171004063828.22068-5-m.szyprowski@samsung.com>
References: <CGME20171004063836eucas1p1c45902d81f8520b4bfc6b06ded50cc2b@eucas1p1.samsung.com>
 <20171004063828.22068-1-m.szyprowski@samsung.com> <20171004063828.22068-5-m.szyprowski@samsung.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
Date: Wed, 4 Oct 2017 10:16:22 +0200
Message-ID: <CAJKOXPfP_QdCTQjHduCyh0ruWQF-c81Ld-F=Mw+mcqtKbhtT7A@mail.gmail.com>
Subject: Re: [PATCH 4/7] media: exynos4-is: Remove dependency on obsolete SoC support
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 4, 2017 at 8:38 AM, Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
> Support for Exynos4212 SoCs has been removed by commit bca9085e0ae9 ("ARM:
> dts: exynos: remove Exynos4212 support (dead code)"), so there is no need
> to keep remaining dead code related to this SoC version.
>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/media/platform/exynos4-is/Kconfig     | 2 +-
>  drivers/media/platform/exynos4-is/fimc-core.c | 2 +-
>  drivers/media/platform/exynos4-is/fimc-lite.c | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)

Acked-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof
