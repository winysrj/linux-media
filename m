Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:49906 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab2BTPN6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Feb 2012 10:13:58 -0500
Date: Mon, 20 Feb 2012 16:13:44 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Fabio Estevam <festevam@gmail.com>
cc: linux-media@vger.kernel.org, javier.martin@vista-silicon.com,
	kernel@pengutronix.de, mchehab@infradead.org,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH 1/3] media: video: mx2_camera.c: Fix build warning by
 initializing 'res_emma'
In-Reply-To: <1329312801-20501-1-git-send-email-festevam@gmail.com>
Message-ID: <Pine.LNX.4.64.1202201612250.2836@axis700.grange>
References: <1329312801-20501-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fabio

On Wed, 15 Feb 2012, Fabio Estevam wrote:

> Fix the following build warning:
> 
> drivers/media/video/mx2_camera.c: In function 'mx2_camera_probe':
> drivers/media/video/mx2_camera.c:1527: warning: 'res_emma' may be used uninitialized in this function

This warning should be no longer occur after recent patches from Javier 
Martin, that should appear in 3.4.

Thanks
Guennadi

> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
>  drivers/media/video/mx2_camera.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
> index 04aab0c..5888e33 100644
> --- a/drivers/media/video/mx2_camera.c
> +++ b/drivers/media/video/mx2_camera.c
> @@ -1524,7 +1524,7 @@ out:
>  static int __devinit mx2_camera_probe(struct platform_device *pdev)
>  {
>  	struct mx2_camera_dev *pcdev;
> -	struct resource *res_csi, *res_emma;
> +	struct resource *res_csi, *res_emma = NULL;
>  	void __iomem *base_csi;
>  	int irq_csi, irq_emma;
>  	irq_handler_t mx2_cam_irq_handler = cpu_is_mx25() ? mx25_camera_irq
> -- 
> 1.7.1
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
