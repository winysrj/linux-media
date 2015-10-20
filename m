Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38547 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282AbbJTMW2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2015 08:22:28 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] staging: omap4iss: Compiling V4L2 framework and I2C as modules is fine
Date: Tue, 20 Oct 2015 15:22:26 +0300
Message-ID: <5654919.mNVcuqlhxs@avalon>
In-Reply-To: <1444951273-22350-1-git-send-email-sakari.ailus@iki.fi>
References: <1444951273-22350-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Friday 16 October 2015 02:21:13 Sakari Ailus wrote:
> Don't require V4L2 framework and I2C being linked to the kernel directly.

That's a leftover of when the driver had to be compiled in the kernel.

> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/staging/media/omap4iss/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/omap4iss/Kconfig
> b/drivers/staging/media/omap4iss/Kconfig index 8d4e3bd..4618346 100644
> --- a/drivers/staging/media/omap4iss/Kconfig
> +++ b/drivers/staging/media/omap4iss/Kconfig
> @@ -1,6 +1,6 @@
>  config VIDEO_OMAP4
>  	tristate "OMAP 4 Camera support"
> -	depends on VIDEO_V4L2=y && VIDEO_V4L2_SUBDEV_API && I2C=y && ARCH_OMAP4
> +	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && I2C && ARCH_OMAP4
>  	depends on HAS_DMA
>  	select MFD_SYSCON
>  	select VIDEOBUF2_DMA_CONTIG

-- 
Regards,

Laurent Pinchart

