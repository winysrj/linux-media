Return-path: <linux-media-owner@vger.kernel.org>
Received: from [216.32.181.182] ([216.32.181.182]:55408 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750914Ab2H2FlB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Aug 2012 01:41:01 -0400
Date: Wed, 29 Aug 2012 13:39:54 +0800
From: Richard Zhao <richard.zhao@freescale.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: <linux-media@vger.kernel.org>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, <kernel@pengutronix.de>
Subject: Re: [PATCH v2 0/14] Initial i.MX5/CODA7 support for the CODA driver
Message-ID: <20120829053954.GF4011@b20223-02.ap.freescale.net>
References: <1346151241-10449-1-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1346151241-10449-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 28, 2012 at 12:53:47PM +0200, Philipp Zabel wrote:
> These patches contain initial firmware loading and encoding support for the
> CODA7 series VPU contained in i.MX51 and i.MX53 SoCs, and fix some multi-instance
> issues. The last two patches touching files in arch/arm/* are included for
> illustration purposes.
> 
> Changes since v1:
>  - Use iram_alloc/iram_free instead of the genalloc API.
>  - Add a patch to add byte size slice limit control.
>  - Add a patch to enable flipping controls.
>  - Do not allocate extra frame buffer space for CODA7 on i.MX27.
>  - Removed JPEG from the coda7_formats, will be added again
>    with the JPEG support patch.
> 
> regards
> Philipp
> 
> ---
>  arch/arm/boot/dts/imx51.dtsi        |    6 +
>  arch/arm/boot/dts/imx53.dtsi        |    6 +
>  arch/arm/mach-imx/clk-imx51-imx53.c |    4 +-
>  drivers/media/video/Kconfig         |    3 +-
>  drivers/media/video/coda.c          |  399 ++++++++++++++++++++++++++---------
>  drivers/media/video/coda.h          |   30 ++-
It's not based on latest linuxtv git. video/ has been renamed to
platform/. Please look at:
git://linuxtv.org/media_tree.git staging/for_v3.7

Thanks
Richard
>  6 files changed, 338 insertions(+), 110 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

