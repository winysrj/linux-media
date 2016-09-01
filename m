Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:57040 "EHLO
        mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754608AbcIAK70 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2016 06:59:26 -0400
Subject: Re: [PATCH 1/3] media: exynos4-is: Add support for all required clocks
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
References: <1472649918-10371-1-git-send-email-m.szyprowski@samsung.com>
 <1472649918-10371-2-git-send-email-m.szyprowski@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Message-id: <6290e72a-2297-50eb-44a7-f0f145c4182b@samsung.com>
Date: Thu, 01 Sep 2016 12:57:29 +0200
MIME-version: 1.0
In-reply-to: <1472649918-10371-2-git-send-email-m.szyprowski@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/31/2016 03:25 PM, Marek Szyprowski wrote:
> This patch adds 3 more clocks to Exynos4 ISP driver. Enabling them is
> needed to make the hardware operational. Till now it worked only because
> those clocks were registered with IGNORE_UNUSED flag and were enabled
> by default after SoC reset.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  Documentation/devicetree/bindings/media/exynos4-fimc-is.txt | 7 ++++---
>  drivers/media/platform/exynos4-is/fimc-is.c                 | 3 +++
>  drivers/media/platform/exynos4-is/fimc-is.h                 | 3 +++
>  3 files changed, 10 insertions(+), 3 deletions(-)

Acked-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Best regards,
Krzysztof
