Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55589 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab1ECIXw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 May 2011 04:23:52 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v4 2/3] v4l: Move S5P FIMC driver into Video Capture Devices
Date: Tue, 3 May 2011 10:24:23 +0200
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	kyungmin.park@samsung.com, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, kgene.kim@samsung.com,
	sungchun.kang@samsung.com, jonghun.han@samsung.com
References: <1303399264-3849-1-git-send-email-s.nawrocki@samsung.com> <1303399264-3849-3-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1303399264-3849-3-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105031024.23466.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sylwester,

Thanks for the patch.

On Thursday 21 April 2011 17:21:03 Sylwester Nawrocki wrote:
> s5p-fimc now also implements a camera capture video node so move
> it under the "Video capture devices" Kconfig menu. Also update
> the entry to reflect the driver's coverage of EXYNOS4 SoCs.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/video/Kconfig |   19 +++++++++++--------
>  1 files changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index 4498b94..4f0ac2d 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -927,6 +927,17 @@ config VIDEO_MX2
>  	  This is a v4l2 driver for the i.MX27 and the i.MX25 Camera Sensor
>  	  Interface
> 
> +config  VIDEO_SAMSUNG_S5P_FIMC
> +	tristate "S5P and EXYNOS4 camera host interface driver"

Should this read "Samsung S5P and EXYNOS4" ? Without the brand name kernel 
config entries are a bit cryptic.

> +	depends on VIDEO_DEV && VIDEO_V4L2 && PLAT_S5P
> +	select VIDEOBUF2_DMA_CONTIG
> +	select V4L2_MEM2MEM_DEV
> +	help
> +	  This is a v4l2 driver for the S5P and EXYNOS4 camera host interface
> +	  and video postprocessor.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called s5p-fimc.
> 
>  #
>  # USB Multimedia device configuration
> @@ -1022,13 +1033,5 @@ config VIDEO_MEM2MEM_TESTDEV
>  	  This is a virtual test device for the memory-to-memory driver
>  	  framework.
> 
> -config  VIDEO_SAMSUNG_S5P_FIMC
> -	tristate "Samsung S5P FIMC (video postprocessor) driver"
> -	depends on VIDEO_DEV && VIDEO_V4L2 && PLAT_S5P
> -	select VIDEOBUF2_DMA_CONTIG
> -	select V4L2_MEM2MEM_DEV
> -	help
> -	  This is a v4l2 driver for the S5P camera interface
> -	  (video postprocessor)
> 
>  endif # V4L_MEM2MEM_DRIVERS

-- 
Regards,

Laurent Pinchart
