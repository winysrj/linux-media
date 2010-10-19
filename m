Return-path: <mchehab@pedra>
Received: from devils.ext.ti.com ([198.47.26.153]:55223 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab0JSEKD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Oct 2010 00:10:03 -0400
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id o9J49xQg022282
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 18 Oct 2010 23:10:02 -0500
Received: from dbde71.ent.ti.com (localhost [127.0.0.1])
	by dbdp20.itg.ti.com (8.13.8/8.13.8) with ESMTP id o9J49wu4016643
	for <linux-media@vger.kernel.org>; Tue, 19 Oct 2010 09:39:59 +0530 (IST)
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Nilofer, Samreen" <samreen@ti.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 19 Oct 2010 09:39:57 +0530
Subject: RE: [PATCH 1/1] OMAP3: V4L2: Kconfig changes to enable V4L2 options
 on OMAP3
Message-ID: <19F8576C6E063C45BE387C64729E739404AA4E760C@dbde02.ent.ti.com>
References: <1287374534-10722-1-git-send-email-samreen@ti.com>
In-Reply-To: <1287374534-10722-1-git-send-email-samreen@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> -----Original Message-----
> From: Nilofer, Samreen
> Sent: Monday, October 18, 2010 9:32 AM
> To: Hiremath, Vaibhav
> Cc: linux-media@vger.kernel.org; Nilofer, Samreen
> Subject: [PATCH 1/1] OMAP3: V4L2: Kconfig changes to enable V4L2 options
> on OMAP3
> 
> The defconfig options for V4L2 are taken in the respective Kconfig
> to enable V4L2 by default on OMAP3 platforms
> 
> Signed-off-by: Samreen <samreen@ti.com>
> ---
>  drivers/media/Kconfig            |    2 ++
>  drivers/media/video/omap/Kconfig |    2 +-
>  2 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
> index a28541b..2592d88 100644
> --- a/drivers/media/Kconfig
> +++ b/drivers/media/Kconfig
> @@ -5,6 +5,7 @@
>  menuconfig MEDIA_SUPPORT
>  	tristate "Multimedia support"
>  	depends on HAS_IOMEM
> +	default y if ARCH_OMAP2 || ARCH_OMAP3
[Hiremath, Vaibhav] I am quite not sure whether this is right approach to do this, I think adding dependency of ARCH_ here will pollute the file.

Why not add this definition to omap2plus_defconfig, which is common defconfig file for all OMAP architecture.

Thanks,
Vaibhav

>  	help
>  	  If you want to use Video for Linux, DVB for Linux, or DAB
> adapters,
>  	  enable this option and other options below.
> @@ -19,6 +20,7 @@ comment "Multimedia core support"
> 
>  config VIDEO_DEV
>  	tristate "Video For Linux"
> +	default y if ARCH_OMAP2 || ARCH_OMAP3
>  	---help---
>  	  V4L core support for video capture and overlay devices, webcams
> and
>  	  AM/FM radio cards.
> diff --git a/drivers/media/video/omap/Kconfig
> b/drivers/media/video/omap/Kconfig
> index e63233f..f3e33c3 100644
> --- a/drivers/media/video/omap/Kconfig
> +++ b/drivers/media/video/omap/Kconfig
> @@ -6,6 +6,6 @@ config VIDEO_OMAP2_VOUT
>  	select OMAP2_DSS
>  	select OMAP2_VRAM
>  	select OMAP2_VRFB
> -	default n
> +	default y
>  	---help---
>  	  V4L2 Display driver support for OMAP2/3 based boards.
> --
> 1.5.6.3

