Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:64167 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963Ab2JIMtU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Oct 2012 08:49:20 -0400
Received: by mail-wi0-f172.google.com with SMTP id hq12so5421995wib.1
        for <linux-media@vger.kernel.org>; Tue, 09 Oct 2012 05:49:19 -0700 (PDT)
Message-ID: <50741D08.1060706@gmail.com>
Date: Tue, 09 Oct 2012 14:48:08 +0200
From: =?UTF-8?B?R2HDq3RhbiBDYXJsaWVy?= <gcembed@gmail.com>
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>
CC: g.liakhovetski@gmx.de, mchehab@infradead.org,
	javier.martin@vista-silicon.com, kernel@pengutronix.de,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH v2 2/2] [media]: mx2_camera: Fix regression caused by
 clock conversion
References: <1349735823-30315-1-git-send-email-festevam@gmail.com>
In-Reply-To: <1349735823-30315-1-git-send-email-festevam@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
On 10/09/2012 12:37 AM, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
>
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
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
> Changes since v1:
> - Rebased against linux-next 20121008.
>
>   drivers/media/platform/soc_camera/mx2_camera.c |   47 +++++++++++++++++-------
>   1 file changed, 34 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
> index 403d7f1..9f8c5f0 100644
> --- a/drivers/media/platform/soc_camera/mx2_camera.c
> +++ b/drivers/media/platform/soc_camera/mx2_camera.c
> @@ -272,7 +272,8 @@ struct mx2_camera_dev {
>   	struct device		*dev;
>   	struct soc_camera_host	soc_host;
>   	struct soc_camera_device *icd;
> -	struct clk		*clk_csi, *clk_emma_ahb, *clk_emma_ipg;
> +	struct clk		*clk_emma_ahb, *clk_emma_ipg;
> +	struct clk		*clk_csi_ahb, *clk_csi_per;
>
>   	void __iomem		*base_csi, *base_emma;
>
> @@ -432,7 +433,8 @@ static void mx2_camera_deactivate(struct mx2_camera_dev *pcdev)
>   {
>   	unsigned long flags;
>
> -	clk_disable_unprepare(pcdev->clk_csi);
> +	clk_disable_unprepare(pcdev->clk_csi_ahb);
> +	clk_disable_unprepare(pcdev->clk_csi_per);
>   	writel(0, pcdev->base_csi + CSICR1);
>   	if (cpu_is_mx27()) {
>   		writel(0, pcdev->base_emma + PRP_CNTL);
> @@ -460,7 +462,11 @@ static int mx2_camera_add_device(struct soc_camera_device *icd)
>   	if (pcdev->icd)
>   		return -EBUSY;
>
> -	ret = clk_prepare_enable(pcdev->clk_csi);
> +	ret = clk_prepare_enable(pcdev->clk_csi_ahb);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = clk_prepare_enable(pcdev->clk_csi_per);
>   	if (ret < 0)
>   		return ret;
>
> @@ -1725,11 +1731,18 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
>   		goto exit;
>   	}
>
> -	pcdev->clk_csi = devm_clk_get(&pdev->dev, "ahb");
> -	if (IS_ERR(pcdev->clk_csi)) {
> -		dev_err(&pdev->dev, "Could not get csi clock\n");
> -		err = PTR_ERR(pcdev->clk_csi);
> -		goto exit;
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
> +		goto exit_csi_ahb;
>   	}
>
>   	pcdev->pdata = pdev->dev.platform_data;
> @@ -1738,14 +1751,15 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
>
>   		pcdev->platform_flags = pcdev->pdata->flags;
>
> -		rate = clk_round_rate(pcdev->clk_csi, pcdev->pdata->clk * 2);
> +		rate = clk_round_rate(pcdev->clk_csi_per,
> +						pcdev->pdata->clk * 2);
>   		if (rate <= 0) {
>   			err = -ENODEV;
> -			goto exit;
> +			goto exit_csi_per;
>   		}
> -		err = clk_set_rate(pcdev->clk_csi, rate);
> +		err = clk_set_rate(pcdev->clk_csi_per, rate);
>   		if (err < 0)
> -			goto exit;
> +			goto exit_csi_per;
>   	}
>
>   	INIT_LIST_HEAD(&pcdev->capture);
> @@ -1801,7 +1815,7 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
>   		goto exit_free_emma;
>
>   	dev_info(&pdev->dev, "MX2 Camera (CSI) driver probed, clock frequency: %ld\n",
> -			clk_get_rate(pcdev->clk_csi));
> +			clk_get_rate(pcdev->clk_csi_per));
>
>   	return 0;
>
> @@ -1812,6 +1826,10 @@ eallocctx:
>   		clk_disable_unprepare(pcdev->clk_emma_ipg);
>   		clk_disable_unprepare(pcdev->clk_emma_ahb);
>   	}
> +exit_csi_per:
> +	clk_disable_unprepare(pcdev->clk_csi_per);
> +exit_csi_ahb:
> +	clk_disable_unprepare(pcdev->clk_csi_ahb);
>   exit:
>   	return err;
>   }
> @@ -1831,6 +1849,9 @@ static int __devexit mx2_camera_remove(struct platform_device *pdev)
>   		clk_disable_unprepare(pcdev->clk_emma_ahb);
>   	}
>
> +	clk_disable_unprepare(pcdev->clk_csi_per);
> +	clk_disable_unprepare(pcdev->clk_csi_ahb);
> +
>   	dev_info(&pdev->dev, "MX2 Camera driver unloaded\n");
>
>   	return 0;
>
I only test detection at kernel boot not streaming using Gstreamer due 
to lack of time.

On imx27_3ds board with ov2640 sensor:
ov2640 0-0030: ov2640 Product ID 26:42 Manufacturer ID 7f:a2
mx2-camera mx2-camera.0: MX2 Camera (CSI) driver probed, clock 
frequency: 44333333

On clone imx27_3ds board with mt9v111 sensor (draft driver):
mt9v111 0-0048: Detected a MT9V111 chip ID 823a
mx2-camera mx2-camera.0: MX2 Camera (CSI) driver probed, clock 
frequency: 44333333

Tested-by: Gaëtan Carlier <gcembed@gmail.com>
