Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:35376 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab3GEXN3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Jul 2013 19:13:29 -0400
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
Subject: Re: [PATCH V4 1/4] ARM: dts: Add DP PHY node to exynos5250.dtsi
Date: Sat, 06 Jul 2013 01:13:25 +0200
Message-ID: <9669926.RxF55qzGZI@flatron>
In-Reply-To: <000a01ce76ff$a02a7c40$e07f74c0$@samsung.com>
References: <000a01ce76ff$a02a7c40$e07f74c0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 02 of July 2013 17:39:11 Jingoo Han wrote:
> Add PHY provider node for the DP PHY.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> Acked-by: Felipe Balbi <balbi@ti.com>
> ---
>  arch/arm/boot/dts/exynos5250.dtsi |   13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz

