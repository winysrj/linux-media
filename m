Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:50750 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161129AbcFGWfF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jun 2016 18:35:05 -0400
Subject: Re: [PATCH 3/3] ARM: dts: exynos: enable MFC device for all boards
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
References: <2241b7f4-4565-d17b-10f3-5c27cd9985da@osg.samsung.com>
 <1465301018-9671-1-git-send-email-m.szyprowski@samsung.com>
 <1465301018-9671-3-git-send-email-m.szyprowski@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <df3d4305-738f-3505-1064-95b913f6b854@osg.samsung.com>
Date: Tue, 7 Jun 2016 18:34:57 -0400
MIME-Version: 1.0
In-Reply-To: <1465301018-9671-3-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Marek,

On 06/07/2016 08:03 AM, Marek Szyprowski wrote:
> MFC device can be used without any external hardware dependencies (when
> IOMMU is enabled), so it can be enabled by default (like it has been
> already done for Exynos 542x platforms). This unifies handling of this
> device for Exynos3250, Exynos4 and Exynos542x platforms. Board can still
> include exynos-mfc-reserved-memory.dtsi to enable using this device
> without IOMMU being enabled.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
