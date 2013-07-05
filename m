Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:39075 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab3GEXMJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Jul 2013 19:12:09 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Jingoo Han <jg1.han@samsung.com>,
	linux-samsung-soc@vger.kernel.org, linux-fbdev@vger.kernel.org,
	'Kukjin Kim' <kgene.kim@samsung.com>,
	'Hui Wang' <jason77.wang@gmail.com>,
	'Tomasz Figa' <t.figa@samsung.com>,
	'Donghwa Lee' <dh09.lee@samsung.com>,
	'Felipe Balbi' <balbi@ti.com>,
	'Kishon Vijay Abraham I' <kishon@ti.com>,
	'Inki Dae' <inki.dae@samsung.com>,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Tomi Valkeinen' <tomi.valkeinen@ti.com>,
	'Sylwester Nawrocki' <s.nawrocki@samsung.com>,
	'Jean-Christophe PLAGNIOL-VILLARD' <plagnioj@jcrosoft.com>,
	devicetree-discuss@lists.ozlabs.org, linux-media@vger.kernel.org
Subject: Re: [PATCH V4 2/4] phy: Add driver for Exynos DP PHY
Date: Sat, 06 Jul 2013 01:12:05 +0200
Message-ID: <1543218.1F6S8MDx2p@flatron>
In-Reply-To: <000b01ce76ff$cf9fd6a0$6edf83e0$@samsung.com>
References: <000b01ce76ff$cf9fd6a0$6edf83e0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 02 of July 2013 17:40:31 Jingoo Han wrote:
> Add a PHY provider driver for the Samsung Exynos SoC DP PHY.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Acked-by: Felipe Balbi <balbi@ti.com>
> ---
>  .../devicetree/bindings/phy/samsung-phy.txt        |    8 ++
>  drivers/phy/Kconfig                                |    6 ++
>  drivers/phy/Makefile                               |    1 +
>  drivers/phy/phy-exynos-dp-video.c                  |  111
> ++++++++++++++++++++ 4 files changed, 126 insertions(+)
>  create mode 100644 drivers/phy/phy-exynos-dp-video.c

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz

