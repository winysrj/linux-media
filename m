Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:52393 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755570Ab3CEKVL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2013 05:21:11 -0500
Date: Tue, 5 Mar 2013 11:21:05 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Albert Wang <twang13@marvell.com>
cc: corbet@lwn.net, linux-media@vger.kernel.org,
	Libin Yang <lbyang@marvell.com>
Subject: Re: [REVIEW PATCH V4 01/12] [media] marvell-ccic: add MIPI support
 for marvell-ccic driver
In-Reply-To: <1360238687-15768-2-git-send-email-twang13@marvell.com>
Message-ID: <Pine.LNX.4.64.1303051119210.25837@axis700.grange>
References: <1360238687-15768-1-git-send-email-twang13@marvell.com>
 <1360238687-15768-2-git-send-email-twang13@marvell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Oh, one more thing occurred to me after looking at your another patch:

On Thu, 7 Feb 2013, Albert Wang wrote:

> From: Libin Yang <lbyang@marvell.com>
> 
> This patch adds the MIPI support for marvell-ccic.
> Board driver should determine whether using MIPI or not.
> 
> Signed-off-by: Albert Wang <twang13@marvell.com>
> Signed-off-by: Libin Yang <lbyang@marvell.com>
> ---
>  drivers/media/platform/marvell-ccic/mcam-core.c  |   66 +++++++++++++
>  drivers/media/platform/marvell-ccic/mcam-core.h  |   28 +++++-
>  drivers/media/platform/marvell-ccic/mmp-driver.c |  113 +++++++++++++++++++++-
>  include/media/mmp-camera.h                       |   10 ++
>  4 files changed, 214 insertions(+), 3 deletions(-)

[snip]

> @@ -183,8 +285,18 @@ static int mmpcam_probe(struct platform_device *pdev)
>  	mcam = &cam->mcam;
>  	mcam->plat_power_up = mmpcam_power_up;
>  	mcam->plat_power_down = mmpcam_power_down;
> +	mcam->calc_dphy = mmpcam_calc_dphy;
>  	mcam->dev = &pdev->dev;
>  	mcam->use_smbus = 0;
> +	mcam->bus_type = pdata->bus_type;
> +	mcam->dphy = pdata->dphy;
> +	/* mosetly it won't happen. dphy is an array in pdata, but in case .. */
> +	if (unlikely(mcam->dphy == NULL)) {

There's no such case - you did define it as an array, this will never be 
NULL.

> +		ret = -EINVAL;
> +		goto out_free;
> +	}
> +	mcam->mipi_enabled = 0;
> +	mcam->lane = pdata->lane;
>  	mcam->chip_id = V4L2_IDENT_ARMADA610;
>  	mcam->buffer_mode = B_DMA_sg;
>  	spin_lock_init(&mcam->dev_lock);
> @@ -223,7 +335,6 @@ static int mmpcam_probe(struct platform_device *pdev)
>  	 * Find the i2c adapter.  This assumes, of course, that the
>  	 * i2c bus is already up and functioning.
>  	 */
> -	pdata = pdev->dev.platform_data;
>  	mcam->i2c_adapter = platform_get_drvdata(pdata->i2c_device);
>  	if (mcam->i2c_adapter == NULL) {
>  		ret = -ENODEV;
> diff --git a/include/media/mmp-camera.h b/include/media/mmp-camera.h
> index 7611963..813efe2 100755
> --- a/include/media/mmp-camera.h
> +++ b/include/media/mmp-camera.h
> @@ -1,3 +1,4 @@
> +#include <media/v4l2-mediabus.h>
>  /*
>   * Information for the Marvell Armada MMP camera
>   */
> @@ -6,4 +7,13 @@ struct mmp_camera_platform_data {
>  	struct platform_device *i2c_device;
>  	int sensor_power_gpio;
>  	int sensor_reset_gpio;
> +	enum v4l2_mbus_type bus_type;
> +	/*
> +	 * MIPI support
> +	 */
> +	int dphy[3];		/* DPHY: CSI2_DPHY3, CSI2_DPHY5, CSI2_DPHY6 */
> +	int dphy3_algo;		/* Exist 2 algos for calculate CSI2_DPHY3 */
> +	int mipi_enabled;	/* MIPI enabled flag */
> +	int lane;		/* ccic used lane number; 0 means DVP mode */
> +	int lane_clk;
>  };
> -- 
> 1.7.9.5
> 

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
