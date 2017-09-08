Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751577AbdIHLYH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Sep 2017 07:24:07 -0400
MIME-Version: 1.0
In-Reply-To: <1504850560-27950-6-git-send-email-hoegeun.kwon@samsung.com>
References: <CGME20170908060309epcas1p4061542ce39ddfdd385b1b6b51eda2ace@epcas1p4.samsung.com>
 <1504850560-27950-1-git-send-email-hoegeun.kwon@samsung.com> <1504850560-27950-6-git-send-email-hoegeun.kwon@samsung.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
Date: Fri, 8 Sep 2017 13:24:05 +0200
Message-ID: <CAJKOXPfyrH66X3iPLaXK_OJgadU6HByyjTwfp_6xYasq8cS-Lw@mail.gmail.com>
Subject: Re: [PATCH v3 5/6] [media] exynos-gsc: Remove unnecessary compatible
To: Hoegeun Kwon <hoegeun.kwon@samsung.com>
Cc: Inki Dae <inki.dae@samsung.com>, airlied@linux.ie,
        kgene@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        catalin.marinas@arm.com, will.deacon@arm.com, mchehab@kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, a.hajda@samsung.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 8, 2017 at 8:02 AM, Hoegeun Kwon <hoegeun.kwon@samsung.com> wrote:
> Currently, the compatible('samsung,exynos5-gsc') is not used.
> Remove unnecessary compatible.
>
> Signed-off-by: Hoegeun Kwon <hoegeun.kwon@samsung.com>
> ---
>  Documentation/devicetree/bindings/media/exynos5-gsc.txt | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/media/exynos5-gsc.txt b/Documentation/devicetree/bindings/media/exynos5-gsc.txt
> index daa56d5..1ea05f1 100644
> --- a/Documentation/devicetree/bindings/media/exynos5-gsc.txt
> +++ b/Documentation/devicetree/bindings/media/exynos5-gsc.txt
> @@ -3,9 +3,9 @@
>  G-Scaler is used for scaling and color space conversion on EXYNOS5 SoCs.
>
>  Required properties:
> -- compatible: should be "samsung,exynos5-gsc" (for Exynos 5250, 5420 and
> -             5422 SoCs) or "samsung,exynos5433-gsc" (Exynos 5433)
> -             or "samsung,exynos5250-gsc" or "samsung,exynos5420-gsc"
> +- compatible: should be "samsung,exynos5250-gsc", "samsung,exynos5420-gsc"
> +             or "samsung,exynos5433-gsc" (for Exynos 5250, 5420, 5422,
> +             and 5433 SoCs)

You should not remove the compatible (neither here nor in the driver)
but mark it as deprecated. Removal should happen slightly later.

Best regards,
Krzysztof

>  - reg: should contain G-Scaler physical address location and length.
>  - interrupts: should contain G-Scaler interrupt number
>
> @@ -16,7 +16,7 @@ Optional properties:
>  Example:
>
>  gsc_0:  gsc@0x13e00000 {
> -       compatible = "samsung,exynos5-gsc";
> +       compatible = "samsung,exynos5250-gsc;
>         reg = <0x13e00000 0x1000>;
>         interrupts = <0 85 0>;
>  };
