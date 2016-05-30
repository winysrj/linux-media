Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:12214 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbcE3H3B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 May 2016 03:29:01 -0400
Subject: Re: [PATCH v4 5/7] ARM: Exynos: remove code for MFC custom reserved
 memory handling
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
References: <1464096690-23605-1-git-send-email-m.szyprowski@samsung.com>
 <1464096690-23605-6-git-send-email-m.szyprowski@samsung.com>
Cc: devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Uli Middelberg <uli@middelberg.de>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Message-id: <574BEBB8.8040606@samsung.com>
Date: Mon, 30 May 2016 09:28:56 +0200
MIME-version: 1.0
In-reply-to: <1464096690-23605-6-git-send-email-m.szyprowski@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/24/2016 03:31 PM, Marek Szyprowski wrote:
> Once MFC driver has been converted to generic reserved memory bindings,
> there is no need for custom memory reservation code.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  arch/arm/mach-exynos/Makefile      |  2 -
>  arch/arm/mach-exynos/exynos.c      | 19 --------
>  arch/arm/mach-exynos/mfc.h         | 16 -------
>  arch/arm/mach-exynos/s5p-dev-mfc.c | 93 --------------------------------------
>  4 files changed, 130 deletions(-)
>  delete mode 100644 arch/arm/mach-exynos/mfc.h
>  delete mode 100644 arch/arm/mach-exynos/s5p-dev-mfc.c

Thanks, applied.

What is your final decision for DTS patches? Which approach for MFC
reserved memory node?

Krzysztof

