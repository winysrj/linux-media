Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41180 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762110AbZDCI2r (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Apr 2009 04:28:47 -0400
Date: Fri, 3 Apr 2009 10:28:44 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Guennadi Liakhovetski <lg@denx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] mx3-camera: fix to match the new clock naming
Message-ID: <20090403082844.GM23731@pengutronix.de>
References: <Pine.LNX.4.64.0904021145040.5263@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0904021145040.5263@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 02, 2009 at 11:49:55AM +0200, Guennadi Liakhovetski wrote:
> With the i.MX31 transition to clkdev clock names have changed, fix the 
> driver to use the new name.
> 
> Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
> ---
> diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
> index 70629e1..7e6b51d 100644
> --- a/drivers/media/video/mx3_camera.c
> +++ b/drivers/media/video/mx3_camera.c
> @@ -1100,7 +1100,7 @@ static int mx3_camera_probe(struct platform_device *pdev)
>  	}
>  	memset(mx3_cam, 0, sizeof(*mx3_cam));
>  
> -	mx3_cam->clk = clk_get(&pdev->dev, "csi_clk");
> +	mx3_cam->clk = clk_get(&pdev->dev, "csi");

clk_get(&pdev->dev, NULL) please. The name is only for distinguishing
the clocks when there is more than one clock per device which isn't the
case here.

I just see that it's

_REGISTER_CLOCK("mx3-camera.0", "csi", csi_clk)

Should be

_REGISTER_CLOCK("mx3-camera.0", NULL, csi_clk)

instead.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
