Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:45589 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab2JaL5P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Oct 2012 07:57:15 -0400
Date: Wed, 31 Oct 2012 09:57:02 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Fabio Estevam <fabio.estevam@freescale.com>
Cc: <g.liakhovetski@gmx.de>, <kernel@pengutronix.de>,
	<gcembed@gmail.com>, <javier.martin@vista-silicon.com>,
	<linux-media@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 2/2] mx2_camera: Fix regression caused by clock
 conversion
Message-ID: <20121031095702.41649bf9@infradead.org>
In-Reply-To: <1351598606-8485-2-git-send-email-fabio.estevam@freescale.com>
References: <1351598606-8485-1-git-send-email-fabio.estevam@freescale.com>
	<1351598606-8485-2-git-send-email-fabio.estevam@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 30 Oct 2012 10:03:26 -0200
Fabio Estevam <fabio.estevam@freescale.com> escreveu:

> Since mx27 transitioned to the commmon clock framework in 3.5, the correct way
> to acquire the csi clock is to get csi_ahb and csi_per clocks separately.
> 
> By not doing so the camera sensor does not probe correctly:
> 
> soc-camera-pdrv soc-camera-pdrv.0: Probing soc-camera-pdrv.0
> mx2-camera mx2-camera.0: Camera driver attached to camera 0
> ov2640 0-0030: Product ID error fb:fb
> mx2-camera mx2-camera.0: Camera driver detached from camera 0
> mx2-camera mx2-camera.0: MX2 Camera (CSI) driver probed, clock frequency: 66500000
> 
> Adapt the mx2_camera driver to the new clock framework and make it functional
> again.
> 
> Tested-by: Gaëtan Carlier <gcembed@gmail.com>
> Tested-by: Javier Martin <javier.martin@vista-silicon.com>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

As it seems that those patches depend on some patches at the arm tree,
the better is to merge them via -arm tree.

So,

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

> ---
> Changes since v3:
> - Drop unneeded clk_unprepare calls as pointed out by Guennadi
> Changes since v2:
> - Fix clock error handling code as pointed out by Russell King
> Changes since v1:
> - Rebased against linux-next 20121008.
>  drivers/media/platform/soc_camera/mx2_camera.c |   39 ++++++++++++++++++------
>  1 file changed, 29 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
> index e575ae8..558f6a3 100644
> --- a/drivers/media/platform/soc_camera/mx2_camera.c
> +++ b/drivers/media/platform/soc_camera/mx2_camera.c
> @@ -278,7 +278,8 @@ struct mx2_camera_dev {
>  	struct device		*dev;
>  	struct soc_camera_host	soc_host;
>  	struct soc_camera_device *icd;
> -	struct clk		*clk_csi, *clk_emma_ahb, *clk_emma_ipg;
> +	struct clk		*clk_emma_ahb, *clk_emma_ipg;
> +	struct clk		*clk_csi_ahb, *clk_csi_per;
>  
>  	void __iomem		*base_csi, *base_emma;
>  
> @@ -464,7 +465,8 @@ static void mx2_camera_deactivate(struct mx2_camera_dev *pcdev)
>  {
>  	unsigned long flags;
>  
> -	clk_disable_unprepare(pcdev->clk_csi);
> +	clk_disable_unprepare(pcdev->clk_csi_ahb);
> +	clk_disable_unprepare(pcdev->clk_csi_per);
>  	writel(0, pcdev->base_csi + CSICR1);
>  	if (is_imx27_camera(pcdev)) {
>  		writel(0, pcdev->base_emma + PRP_CNTL);
> @@ -492,10 +494,14 @@ static int mx2_camera_add_device(struct soc_camera_device *icd)
>  	if (pcdev->icd)
>  		return -EBUSY;
>  
> -	ret = clk_prepare_enable(pcdev->clk_csi);
> +	ret = clk_prepare_enable(pcdev->clk_csi_ahb);
>  	if (ret < 0)
>  		return ret;
>  
> +	ret = clk_prepare_enable(pcdev->clk_csi_per);
> +	if (ret < 0)
> +		goto exit_csi_ahb;
> +
>  	csicr1 = CSICR1_MCLKEN;
>  
>  	if (is_imx27_camera(pcdev))
> @@ -512,6 +518,11 @@ static int mx2_camera_add_device(struct soc_camera_device *icd)
>  		 icd->devnum);
>  
>  	return 0;
> +
> +exit_csi_ahb:
> +	clk_disable_unprepare(pcdev->clk_csi_ahb);
> +
> +	return ret;
>  }
>  
>  static void mx2_camera_remove_device(struct soc_camera_device *icd)
> @@ -1772,10 +1783,17 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
>  		break;
>  	}
>  
> -	pcdev->clk_csi = devm_clk_get(&pdev->dev, "ahb");
> -	if (IS_ERR(pcdev->clk_csi)) {
> -		dev_err(&pdev->dev, "Could not get csi clock\n");
> -		err = PTR_ERR(pcdev->clk_csi);
> +	pcdev->clk_csi_ahb = devm_clk_get(&pdev->dev, "ahb");
> +	if (IS_ERR(pcdev->clk_csi_ahb)) {
> +		dev_err(&pdev->dev, "Could not get csi ahb clock\n");
> +		err = PTR_ERR(pcdev->clk_csi_ahb);
> +		goto exit;
> +	}
> +
> +	pcdev->clk_csi_per = devm_clk_get(&pdev->dev, "per");
> +	if (IS_ERR(pcdev->clk_csi_per)) {
> +		dev_err(&pdev->dev, "Could not get csi per clock\n");
> +		err = PTR_ERR(pcdev->clk_csi_per);
>  		goto exit;
>  	}
>  
> @@ -1785,12 +1803,13 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
>  
>  		pcdev->platform_flags = pcdev->pdata->flags;
>  
> -		rate = clk_round_rate(pcdev->clk_csi, pcdev->pdata->clk * 2);
> +		rate = clk_round_rate(pcdev->clk_csi_per,
> +						pcdev->pdata->clk * 2);
>  		if (rate <= 0) {
>  			err = -ENODEV;
>  			goto exit;
>  		}
> -		err = clk_set_rate(pcdev->clk_csi, rate);
> +		err = clk_set_rate(pcdev->clk_csi_per, rate);
>  		if (err < 0)
>  			goto exit;
>  	}
> @@ -1848,7 +1867,7 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
>  		goto exit_free_emma;
>  
>  	dev_info(&pdev->dev, "MX2 Camera (CSI) driver probed, clock frequency: %ld\n",
> -			clk_get_rate(pcdev->clk_csi));
> +			clk_get_rate(pcdev->clk_csi_per));
>  
>  	return 0;
>  




Cheers,
Mauro
