Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:55559 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752847AbZK0OGh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Nov 2009 09:06:37 -0500
Date: Fri, 27 Nov 2009 15:06:53 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Antonio Ospite <ospite@studenti.unina.it>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Eric Miao <eric.y.miao@gmail.com>,
	linux-arm-kernel@lists.infradead.org,
	Mike Rapoport <mike@compulab.co.il>,
	Juergen Beisert <j.beisert@pengutronix.de>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: Re: [PATCH 3/3] pxa_camera: remove init() callback
In-Reply-To: <1258495463-26029-4-git-send-email-ospite@studenti.unina.it>
Message-ID: <Pine.LNX.4.64.0911271503460.4383@axis700.grange>
References: <1258495463-26029-1-git-send-email-ospite@studenti.unina.it>
 <1258495463-26029-4-git-send-email-ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 17 Nov 2009, Antonio Ospite wrote:

> pxa_camera init() callback is sometimes abused to setup MFP for PXA CIF, or
> even to request GPIOs to be used by the camera *sensor*. These initializations
> can be performed statically in machine init functions.
> 
> The current semantics for this init() callback is ambiguous anyways, it is
> invoked in pxa_camera_activate(), hence at device node open, but its users use
> it like a generic initialization to be done at module init time (configure
> MFP, request GPIOs for *sensor* control).
> 
> Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>

Antonio, to make the merging easier and avoid imposing extra dependencies, 
I would postpone this to 2.6.34, and just remove uses of .init() by 
pxa-camera users as per your other two patches. Would this be ok with you?

Thanks
Guennadi

> ---
>  arch/arm/mach-pxa/include/mach/camera.h |    2 --
>  drivers/media/video/pxa_camera.c        |   10 ----------
>  2 files changed, 0 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm/mach-pxa/include/mach/camera.h b/arch/arm/mach-pxa/include/mach/camera.h
> index 31abe6d..6709b1c 100644
> --- a/arch/arm/mach-pxa/include/mach/camera.h
> +++ b/arch/arm/mach-pxa/include/mach/camera.h
> @@ -35,8 +35,6 @@
>  #define PXA_CAMERA_VSP		0x400
>  
>  struct pxacamera_platform_data {
> -	int (*init)(struct device *);
> -
>  	unsigned long flags;
>  	unsigned long mclk_10khz;
>  };
> diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
> index 51b683c..49f2bf9 100644
> --- a/drivers/media/video/pxa_camera.c
> +++ b/drivers/media/video/pxa_camera.c
> @@ -882,18 +882,8 @@ static void recalculate_fifo_timeout(struct pxa_camera_dev *pcdev,
>  
>  static void pxa_camera_activate(struct pxa_camera_dev *pcdev)
>  {
> -	struct pxacamera_platform_data *pdata = pcdev->pdata;
> -	struct device *dev = pcdev->soc_host.v4l2_dev.dev;
>  	u32 cicr4 = 0;
>  
> -	dev_dbg(dev, "Registered platform device at %p data %p\n",
> -		pcdev, pdata);
> -
> -	if (pdata && pdata->init) {
> -		dev_dbg(dev, "%s: Init gpios\n", __func__);
> -		pdata->init(dev);
> -	}
> -
>  	/* disable all interrupts */
>  	__raw_writel(0x3ff, pcdev->base + CICR0);
>  
> -- 
> 1.6.5.2
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
