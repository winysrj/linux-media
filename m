Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:38343 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S932090Ab0HDJzj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Aug 2010 05:55:39 -0400
Date: Wed, 4 Aug 2010 11:55:39 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Michael Grzeschik <m.grzeschik@pengutronix.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	baruch@tkos.co.il, Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 2/5] mx2_camera: remove emma limitation for RGB565
In-Reply-To: <1280828276-483-3-git-send-email-m.grzeschik@pengutronix.de>
Message-ID: <Pine.LNX.4.64.1008041149470.29386@axis700.grange>
References: <1280828276-483-1-git-send-email-m.grzeschik@pengutronix.de>
 <1280828276-483-3-git-send-email-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 3 Aug 2010, Michael Grzeschik wrote:

> In the current source status the emma has no limitation for any PIXFMT
> since the data is parsed raw and unprocessed into the memory.

I'd like some explanation for this one too, please. What about

+	/*
+	 * We only use the EMMA engine to get rid of the broken
+	 * DMA Engine. No color space consversion at the moment.
+	 * We adjust incoming and outgoing pixelformat to rgb16
+	 * and adjust the bytesperline accordingly.
+	 */
+	writel(PRP_CNTL_CH1EN |
+			PRP_CNTL_CSIEN |
+			PRP_CNTL_DATA_IN_RGB16 |
+			PRP_CNTL_CH1_OUT_RGB16 |
+			PRP_CNTL_CH1_LEN |
+			PRP_CNTL_CH1BYP |
+			PRP_CNTL_CH1_TSKIP(0) |
+			PRP_CNTL_IN_TSKIP(0),
+			pcdev->base_emma + PRP_CNTL);
+
+	writel(((bytesperline >> 1) << 16) | icd->user_height,
+			pcdev->base_emma + PRP_SRC_FRAME_SIZE);
+	writel(((bytesperline >> 1) << 16) | icd->user_height,
+			pcdev->base_emma + PRP_CH1_OUT_IMAGE_SIZE);
+	writel(bytesperline,
+			pcdev->base_emma + PRP_DEST_CH1_LINE_STRIDE);
+	writel(0x2ca00565, /* RGB565 */
+			pcdev->base_emma + PRP_SRC_PIXEL_FORMAT_CNTL);
+	writel(0x2ca00565, /* RGB565 */
+			pcdev->base_emma + PRP_CH1_PIXEL_FORMAT_CNTL);

To me it looks like the eMMA is configured for RGB565. What's the trick?

Thanks
Guennadi

> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> ---
>  drivers/media/video/mx2_camera.c |    8 --------
>  1 files changed, 0 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
> index c77a673..ae27640 100644
> --- a/drivers/media/video/mx2_camera.c
> +++ b/drivers/media/video/mx2_camera.c
> @@ -897,10 +897,6 @@ static int mx2_camera_set_fmt(struct soc_camera_device *icd,
>  		return -EINVAL;
>  	}
>  
> -	/* eMMA can only do RGB565 */
> -	if (mx27_camera_emma(pcdev) && pix->pixelformat != V4L2_PIX_FMT_RGB565)
> -		return -EINVAL;
> -
>  	mf.width	= pix->width;
>  	mf.height	= pix->height;
>  	mf.field	= pix->field;
> @@ -944,10 +940,6 @@ static int mx2_camera_try_fmt(struct soc_camera_device *icd,
>  
>  	/* FIXME: implement MX27 limits */
>  
> -	/* eMMA can only do RGB565 */
> -	if (mx27_camera_emma(pcdev) && pixfmt != V4L2_PIX_FMT_RGB565)
> -		return -EINVAL;
> -
>  	/* limit to MX25 hardware capabilities */
>  	if (cpu_is_mx25()) {
>  		if (xlate->host_fmt->bits_per_sample <= 8)
> -- 
> 1.7.1
> 
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
