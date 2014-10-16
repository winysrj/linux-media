Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:60455 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbaJPFXd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Oct 2014 01:23:33 -0400
Date: Thu, 16 Oct 2014 07:23:27 +0200
From: Simon Horman <horms@verge.net.au>
To: Yoshihiro Kaneko <ykaneko0929@gmail.com>
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH] media: soc_camera: rcar_vin: Add BT.709 24-bit RGB888
 input support
Message-ID: <20141016052326.GG1265@verge.net.au>
References: <1413267730-8172-1-git-send-email-ykaneko0929@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413267730-8172-1-git-send-email-ykaneko0929@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[CC Mauro Carvalho Chehab]

On Tue, Oct 14, 2014 at 03:22:10PM +0900, Yoshihiro Kaneko wrote:
> From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
> 
> Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
> Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
> ---
> 
> This patch is against master branch of linuxtv.org/media_tree.git.

Acked-by: Simon Horman <horms+renesas@verge.net.au>

If the series needs reposting to a different CC list -
e.g. including Mauro - please let Kaneko-san or myself know.

> 
>  drivers/media/platform/soc_camera/rcar_vin.c | 10 ++++++++++
>  include/linux/platform_data/camera-rcar.h    |  1 +
>  2 files changed, 11 insertions(+)
> 
> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index 20defcb..7eb4f1e 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
> @@ -74,6 +74,8 @@
>  #define VNMC_INF_YUV10_BT656	(2 << 16)
>  #define VNMC_INF_YUV10_BT601	(3 << 16)
>  #define VNMC_INF_YUV16		(5 << 16)
> +#define VNMC_INF_RGB888		(6 << 16)
> +#define VNMC_INF_RGB_MASK	(6 << 16)
>  #define VNMC_VUP		(1 << 10)
>  #define VNMC_IM_ODD		(0 << 3)
>  #define VNMC_IM_ODD_EVEN	(1 << 3)
> @@ -272,6 +274,10 @@ static int rcar_vin_setup(struct rcar_vin_priv *priv)
>  
>  	/* input interface */
>  	switch (icd->current_fmt->code) {
> +	case V4L2_MBUS_FMT_RGB888_1X24:
> +		/* BT.601/BT.709 24-bit RGB-888 */
> +		vnmc |= VNMC_INF_RGB888;
> +		break;
>  	case V4L2_MBUS_FMT_YUYV8_1X16:
>  		/* BT.601/BT.1358 16bit YCbCr422 */
>  		vnmc |= VNMC_INF_YUV16;
> @@ -331,6 +337,9 @@ static int rcar_vin_setup(struct rcar_vin_priv *priv)
>  	if (output_is_yuv)
>  		vnmc |= VNMC_BPS;
>  
> +	if (vnmc & VNMC_INF_RGB_MASK)
> +		vnmc ^= VNMC_BPS;
> +
>  	/* progressive or interlaced mode */
>  	interrupts = progressive ? VNIE_FIE | VNIE_EFE : VNIE_EFE;
>  
> @@ -1013,6 +1022,7 @@ static int rcar_vin_get_formats(struct soc_camera_device *icd, unsigned int idx,
>  	case V4L2_MBUS_FMT_YUYV8_1X16:
>  	case V4L2_MBUS_FMT_YUYV8_2X8:
>  	case V4L2_MBUS_FMT_YUYV10_2X10:
> +	case V4L2_MBUS_FMT_RGB888_1X24:
>  		if (cam->extra_fmt)
>  			break;
>  
> diff --git a/include/linux/platform_data/camera-rcar.h b/include/linux/platform_data/camera-rcar.h
> index dfc83c5..03a9df6 100644
> --- a/include/linux/platform_data/camera-rcar.h
> +++ b/include/linux/platform_data/camera-rcar.h
> @@ -17,6 +17,7 @@
>  #define RCAR_VIN_VSYNC_ACTIVE_LOW	(1 << 1)
>  #define RCAR_VIN_BT601			(1 << 2)
>  #define RCAR_VIN_BT656			(1 << 3)
> +#define RCAR_VIN_BT709			(1 << 4)
>  
>  struct rcar_vin_platform_data {
>  	unsigned int flags;
> -- 
> 1.9.1
> 
