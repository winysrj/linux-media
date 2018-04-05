Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58284 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750726AbeDEU7X (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Apr 2018 16:59:23 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH v2 17/19] media: omap4iss: make it build with COMPILE_TEST
Date: Thu, 05 Apr 2018 23:59:21 +0300
Message-ID: <2089683.SxzjDIYJiK@avalon>
In-Reply-To: <f6b45300aebbfc67100b000a91cbe80056bef306.1522959716.git.mchehab@s-opensource.com>
References: <cover.1522959716.git.mchehab@s-opensource.com> <f6b45300aebbfc67100b000a91cbe80056bef306.1522959716.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thank you for the patch.

On Thursday, 5 April 2018 23:29:44 EEST Mauro Carvalho Chehab wrote:
> This driver compile as-is with COMPILE_TEST.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I don't have patches pending for the omap4iss driver, could you merge this 
patch as part of the whole series ?

> ---
>  drivers/staging/media/omap4iss/Kconfig | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/omap4iss/Kconfig
> b/drivers/staging/media/omap4iss/Kconfig index 46183464ee79..192ba0829128
> 100644
> --- a/drivers/staging/media/omap4iss/Kconfig
> +++ b/drivers/staging/media/omap4iss/Kconfig
> @@ -1,6 +1,7 @@
>  config VIDEO_OMAP4
>  	tristate "OMAP 4 Camera support"
> -	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && I2C && ARCH_OMAP4
> +	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && I2C
> +	depends on ARCH_OMAP4 || COMPILE_TEST
>  	depends on HAS_DMA
>  	select MFD_SYSCON
>  	select VIDEOBUF2_DMA_CONTIG


-- 
Regards,

Laurent Pinchart
