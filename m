Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:61761 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539Ab3GIIua (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Jul 2013 04:50:30 -0400
Message-id: <51DBCED2.7010102@samsung.com>
Date: Tue, 09 Jul 2013 10:50:26 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org,
	'Kishon Vijay Abraham I' <kishon@ti.com>,
	linux-media@vger.kernel.org, 'Kukjin Kim' <kgene.kim@samsung.com>,
	'Felipe Balbi' <balbi@ti.com>,
	'Tomasz Figa' <t.figa@samsung.com>,
	devicetree-discuss@lists.ozlabs.org,
	'Inki Dae' <inki.dae@samsung.com>,
	'Donghwa Lee' <dh09.lee@samsung.com>,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Jean-Christophe PLAGNIOL-VILLARD' <plagnioj@jcrosoft.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	linux-fbdev@vger.kernel.org, Hui Wang <jason77.wang@gmail.com>
Subject: Re: [PATCH V6 0/4] Generic PHY driver for the Exynos SoC DP PHY
References: <003d01ce7c7a$d04043d0$70c0cb70$@samsung.com>
In-reply-to: <003d01ce7c7a$d04043d0$70c0cb70$@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/09/2013 10:03 AM, Jingoo Han wrote:
> This patch series adds a simple driver for the Samsung Exynos SoC
> series DP transmitter PHY, using the generic PHY framework [1].
> Previously the DP PHY used an internal DT node to control the PHY
> power enable bit.
> 
> These patches was tested on Exynos5250.
> 
> This PATCH v6 follows:
>  * PATCH v5, sent on July, 8th 2013
>  * PATCH v4, sent on July, 2nd 2013
>  * PATCH v3, sent on July, 1st 2013
>  * PATCH v2, sent on June, 28th 2013
>  * PATCH v1, sent on June, 28th 2013
> 
> Changes between v5 and v6:
>   * Re-based on git://gitorious.org/linuxphy/linuxphy.git

I'm not sure if we really need to keep the documentation of the
original binding. Anyway, for the whole series, please feel free
to ad my

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

--
Thanks,
Sylwester

