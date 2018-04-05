Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:55759 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751365AbeDESP2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Apr 2018 14:15:28 -0400
Date: Thu, 5 Apr 2018 15:15:23 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 16/16] media: omap: allow building it with COMPILE_TEST
Message-ID: <20180405151523.1980c739@vento.lan>
In-Reply-To: <debd2bac93a5a1cb58232d50e9d4127e547839d7.1522949748.git.mchehab@s-opensource.com>
References: <cover.1522949748.git.mchehab@s-opensource.com>
        <debd2bac93a5a1cb58232d50e9d4127e547839d7.1522949748.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu,  5 Apr 2018 13:54:16 -0400
Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:

> Now that we have stubs for omap FB driver, let it build with
> COMPILE_TEST.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/platform/omap/Kconfig | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/platform/omap/Kconfig b/drivers/media/platform/omap/Kconfig
> index e8e2db181a7a..e6b486c5ddfc 100644
> --- a/drivers/media/platform/omap/Kconfig
> +++ b/drivers/media/platform/omap/Kconfig
> @@ -4,11 +4,11 @@ config VIDEO_OMAP2_VOUT_VRFB
>  config VIDEO_OMAP2_VOUT
>  	tristate "OMAP2/OMAP3 V4L2-Display driver"
>  	depends on MMU
> -	depends on ARCH_OMAP2 || ARCH_OMAP3
> -	depends on FB_OMAP2
> +	depends on ARCH_OMAP2 || ARCH_OMAP3 || COMPILE_TEST
> +	depends on FB_OMAP2 || COMPILE_TEST
>  	select VIDEOBUF_GEN
>  	select VIDEOBUF_DMA_CONTIG
> -	select OMAP2_VRFB if ARCH_OMAP2 || ARCH_OMAP3
> +	select OMAP2_VRFB if ARCH_OMAP2 || ARCH_OMAP3 || COMPILE_TEST
>  	select VIDEO_OMAP2_VOUT_VRFB if VIDEO_OMAP2_VOUT && OMAP2_VRFB
>  	select FRAME_VECTOR
>  	default n

This actually produces a warning:

	WARNING: unmet direct dependencies detected for OMAP2_VRFB
  Depends on [n]: HAS_IOMEM [=y] && ARCH_OMAP2PLUS
  Selected by [y]:
  - VIDEO_OMAP2_VOUT [=y] && MEDIA_SUPPORT [=y] && V4L_PLATFORM_DRIVERS [=y] && MMU [=y] && (FB_OMAP2 [=n] || COMPILE_TEST [=y]) && (ARCH_OMAP2 || ARCH_OMAP3 || COMPILE_TEST [=y])


I'm folding this one with the enclosed change:


diff --git a/drivers/media/platform/omap/Kconfig b/drivers/media/platform/omap/Kconfig
index e6b486c5ddfc..ff051958d675 100644
--- a/drivers/media/platform/omap/Kconfig
+++ b/drivers/media/platform/omap/Kconfig
@@ -4,11 +4,10 @@ config VIDEO_OMAP2_VOUT_VRFB
 config VIDEO_OMAP2_VOUT
 	tristate "OMAP2/OMAP3 V4L2-Display driver"
 	depends on MMU
-	depends on ARCH_OMAP2 || ARCH_OMAP3 || COMPILE_TEST
-	depends on FB_OMAP2 || COMPILE_TEST
+	depends on ((ARCH_OMAP2 || ARCH_OMAP3) && FB_OMAP2) || COMPILE_TEST
 	select VIDEOBUF_GEN
 	select VIDEOBUF_DMA_CONTIG
-	select OMAP2_VRFB if ARCH_OMAP2 || ARCH_OMAP3 || COMPILE_TEST
+	select OMAP2_VRFB if ARCH_OMAP2 || ARCH_OMAP3
 	select VIDEO_OMAP2_VOUT_VRFB if VIDEO_OMAP2_VOUT && OMAP2_VRFB
 	select FRAME_VECTOR
 	default n



Thanks,
Mauro
