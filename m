Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:50741 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161245AbcFGWeJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jun 2016 18:34:09 -0400
Subject: Re: [PATCH 2/3] ARM: dts: exynos: move MFC reserved memory regions
 from boards to .dtsi
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
References: <2241b7f4-4565-d17b-10f3-5c27cd9985da@osg.samsung.com>
 <1465301018-9671-1-git-send-email-m.szyprowski@samsung.com>
 <1465301018-9671-2-git-send-email-m.szyprowski@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <4f164dd6-2bc7-0d66-7508-dae3e0ae9d7c@osg.samsung.com>
Date: Tue, 7 Jun 2016 18:34:00 -0400
MIME-Version: 1.0
In-Reply-To: <1465301018-9671-2-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Marek,

On 06/07/2016 08:03 AM, Marek Szyprowski wrote:
> This patch moves assigning reserved memory regions from each board dts
> to common exynos-mfc-reserved-memory.dtsi file, where those regions are
> defined.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
Tested-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
