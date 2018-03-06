Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:46322 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750836AbeCFQZX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Mar 2018 11:25:23 -0500
Date: Tue, 6 Mar 2018 13:25:15 -0300
From: Mauro Carvalho Chehab <mchehab@kernel.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] media: platform: Drop OF dependency of
 VIDEO_RENESAS_VSP1
Message-ID: <20180306132515.261cf47c@vento.lan>
In-Reply-To: <1519668550-26082-1-git-send-email-geert+renesas@glider.be>
References: <1519668550-26082-1-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 26 Feb 2018 19:09:10 +0100
Geert Uytterhoeven <geert+renesas@glider.be> escreveu:

> VIDEO_RENESAS_VSP1 depends on ARCH_RENESAS && OF.
> As ARCH_RENESAS implies OF, the latter can be dropped.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  drivers/media/platform/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 614fbef08ddcabb0..2b8b1ad0edd9eb31 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -448,7 +448,7 @@ config VIDEO_RENESAS_FCP
>  config VIDEO_RENESAS_VSP1
>  	tristate "Renesas VSP1 Video Processing Engine"
>  	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && HAS_DMA
> -	depends on (ARCH_RENESAS && OF) || COMPILE_TEST
> +	depends on ARCH_RENESAS || COMPILE_TEST

That is not correct!

COMPILE_TEST doesn't depend on OF. With this patch, it will likely
cause build failures with randconfigs.

>  	depends on (!ARM64 && !VIDEO_RENESAS_FCP) || VIDEO_RENESAS_FCP
>  	select VIDEOBUF2_DMA_CONTIG
>  	select VIDEOBUF2_VMALLOC



Thanks,
Mauro
