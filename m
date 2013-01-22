Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42135 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab3AVIWL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jan 2013 03:22:11 -0500
Date: Tue, 22 Jan 2013 09:21:58 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	arm@kernel.org, Javier Martin <javier.martin@vista-silicon.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Sascha Hauer <kernel@pengutronix.de>,
	Shawn Guo <shawn.guo@linaro.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 09/15] media: coda: don't build on multiplatform
Message-ID: <20130122082158.GC9414@pengutronix.de>
References: <1358788568-11137-1-git-send-email-arnd@arndb.de>
 <1358788568-11137-10-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358788568-11137-10-git-send-email-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 21, 2013 at 05:16:02PM +0000, Arnd Bergmann wrote:
> The coda video codec driver depends on a mach-imx or mach-mxs specific
> header file "mach/iram.h". This is not available when building for
> multiplatform, so let us disable this driver for v3.8 when building
> multiplatform, and hopefully find a proper fix for v3.9.
> 
> drivers/media/platform/coda.c:27:23: fatal error: mach/iram.h: No such file or directory

I just sent a pull request for this with a proper fix.

> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 3dcfea6..049d2b2 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -142,7 +142,7 @@ if V4L_MEM2MEM_DRIVERS
>  
>  config VIDEO_CODA
>  	tristate "Chips&Media Coda multi-standard codec IP"
> -	depends on VIDEO_DEV && VIDEO_V4L2 && ARCH_MXC
> +	depends on VIDEO_DEV && VIDEO_V4L2 && ARCH_MXC && !ARCH_MULTIPLATFORM

This breakage is not multiplatform related at all, it won't compile
without multiplatform support either. So depends on BROKEN would be
more appropriate if you want to go this way.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
