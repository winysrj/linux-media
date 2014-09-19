Return-path: <linux-media-owner@vger.kernel.org>
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:63949 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750738AbaISHXy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Sep 2014 03:23:54 -0400
Message-ID: <1411111432.18041.4.camel@x220>
Subject: Re: [v2,35/35,media] omap: be sure that MMU is there for
 COMPILE_TEST
From: Paul Bolle <pebolle@tiscali.nl>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Fri, 19 Sep 2014 09:23:52 +0200
In-Reply-To: <1409090111-8290-36-git-send-email-m.chehab@samsung.com>
References: <1409090111-8290-36-git-send-email-m.chehab@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Tue, 2014-08-26 at 18:55 -0300, Mauro Carvalho Chehab wrote:
> COMPILE_TEST fail on (some) archs without MMU.
> 
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

This patch just landed in next-20140919 as commit 38a073116525 ("[media]
omap: be sure that MMU is there for COMPILE_TEST").

> ---
> drivers/media/platform/omap/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/omap/Kconfig b/drivers/media/platform/omap/Kconfig
> index 2253bf102ed9..05de442d24e4 100644
> --- a/drivers/media/platform/omap/Kconfig
> +++ b/drivers/media/platform/omap/Kconfig
> @@ -3,7 +3,7 @@ config VIDEO_OMAP2_VOUT_VRFB
>  
>  config VIDEO_OMAP2_VOUT
>  	tristate "OMAP2/OMAP3 V4L2-Display driver"
> -	depends on ARCH_OMAP2 || ARCH_OMAP3 || COMPILE_TEST
> +	depends on ARCH_OMAP2 || ARCH_OMAP3 || (COMPILE_TEST && HAS_MMU)

There's no Kconfig symbol HAS_MMU. So this last test will always fail.
Did you perhaps mean simply "MMU"?

>  	select VIDEOBUF_GEN
>  	select VIDEOBUF_DMA_CONTIG


Paul Bolle

