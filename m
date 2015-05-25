Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vn0-f45.google.com ([209.85.216.45]:42586 "EHLO
	mail-vn0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbbEYJO4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2015 05:14:56 -0400
MIME-Version: 1.0
In-Reply-To: <1425904366-14447-2-git-send-email-andrzej.p@samsung.com>
References: <1425904366-14447-1-git-send-email-andrzej.p@samsung.com>
	<1425904366-14447-2-git-send-email-andrzej.p@samsung.com>
Date: Mon, 25 May 2015 18:14:55 +0900
Message-ID: <CAJKOXPfSo-_ngR452V=ucjOLpOt=sNaSMMnVfuFEJEdb4oTt6g@mail.gmail.com>
Subject: Re: [PATCHv3 1/2] ARM: dts: exynos5420: add nodes for jpeg codec
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
	Kukjin Kim <kgene@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kamil Debski <k.debski@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2015-03-09 21:32 GMT+09:00 Andrzej Pietrasiewicz <andrzej.p@samsung.com>:
> Add nodes for jpeg codec in Exynos5420 SoC.
>
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> ---
>  arch/arm/boot/dts/exynos5420.dtsi | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)

Acked-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

The patch adding bindings documentation and changing s5p-jpeg driver
was merged (7c15fd4bf3d3 merged in 4.1-rc1 cycle) so this can be
safely picked up by Samsung tree. Kukjin, can you apply it?

Best regards,
Krzysztof
