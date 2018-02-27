Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58070 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752300AbeB0J3V (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Feb 2018 04:29:21 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] media: platform: Drop OF dependency of VIDEO_RENESAS_VSP1
Date: Tue, 27 Feb 2018 11:30:09 +0200
Message-ID: <2302791.QsluJuEtpd@avalon>
In-Reply-To: <1519668550-26082-1-git-send-email-geert+renesas@glider.be>
References: <1519668550-26082-1-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Geert,

Thank you for the patch.

On Monday, 26 February 2018 20:09:10 EET Geert Uytterhoeven wrote:
> VIDEO_RENESAS_VSP1 depends on ARCH_RENESAS && OF.
> As ARCH_RENESAS implies OF, the latter can be dropped.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and taken in my tree.

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
>  	depends on (!ARM64 && !VIDEO_RENESAS_FCP) || VIDEO_RENESAS_FCP
>  	select VIDEOBUF2_DMA_CONTIG
>  	select VIDEOBUF2_VMALLOC

-- 
Regards,

Laurent Pinchart
