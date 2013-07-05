Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:52161 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab3GEXLF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Jul 2013 19:11:05 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org,
	'Kishon Vijay Abraham I' <kishon@ti.com>,
	linux-media@vger.kernel.org, 'Kukjin Kim' <kgene.kim@samsung.com>,
	'Sylwester Nawrocki' <s.nawrocki@samsung.com>,
	'Felipe Balbi' <balbi@ti.com>,
	'Tomasz Figa' <t.figa@samsung.com>,
	devicetree-discuss@lists.ozlabs.org,
	'Inki Dae' <inki.dae@samsung.com>,
	'Donghwa Lee' <dh09.lee@samsung.com>,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Jean-Christophe PLAGNIOL-VILLARD' <plagnioj@jcrosoft.com>,
	'Tomi Valkeinen' <tomi.valkeinen@ti.com>,
	linux-fbdev@vger.kernel.org, 'Hui Wang' <jason77.wang@gmail.com>
Subject: Re: [PATCH V4 3/4] video: exynos_dp: remove non-DT support for Exynos Display Port
Date: Fri, 05 Jul 2013 16:11:02 -0700 (PDT)
Message-ID: <2149220.dCp7esoXHa@flatron>
In-Reply-To: <000c01ce76ff$fffa39d0$ffeead70$@samsung.com>
References: <000c01ce76ff$fffa39d0$ffeead70$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jingoo,

On Tuesday 02 of July 2013 17:41:52 Jingoo Han wrote:
> Exynos Display Port can be used only for Exynos SoCs. In addition,
> non-DT for EXYNOS SoCs is be supported from v3.11; thus, there is
> no need to support non-DT for Exynos Display Port.
> 
> The 'include/video/exynos_dp.h' file has been used for non-DT
> support and the content of file include/video/exynos_dp.h is moved
> to drivers/video/exynos/exynos_dp_core.h. Thus, the 'exynos_dp.h'
> file is removed. Also, 'struct exynos_dp_platdata' is removed,
> because it is not used any more.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/video/exynos/Kconfig          |    2 +-
>  drivers/video/exynos/exynos_dp_core.c |  116
> +++++++---------------------- drivers/video/exynos/exynos_dp_core.h | 
> 109 +++++++++++++++++++++++++++ drivers/video/exynos/exynos_dp_reg.c  |
>    2 -
>  include/video/exynos_dp.h             |  131
> --------------------------------- 5 files changed, 135 insertions(+),
> 225 deletions(-)
>  delete mode 100644 include/video/exynos_dp.h

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz

